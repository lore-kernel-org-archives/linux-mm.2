Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAAEC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E986B00A4; Wed, 29 Jul 2026 12:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEBB6B00A5; Wed, 29 Jul 2026 12:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36546B00A6; Wed, 29 Jul 2026 12:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C58966B00A4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46FA4A171F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:32 +0000 (UTC)
X-FDA: 85042402704.09.83435A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D146120007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhH6GHLO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343830;
	b=IITSRMd5l9EM3Z9B6iruISRYZIWmUkWsxT0/kXHhGYCv1Z/s6zVcNKosdLoPZqlbE+2Nzn
	x1fTgK3JCRQbg9ejst1f2GptI3L7gI9Owl51BBpUrQq9BZ6qYpEJ5bEyB/VJNaroSMHTvV
	JX43d4DgjQ4G877nCjgEyWzyu5p+wsI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhH6GHLO;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClCpkW84PAD177XPH35BlV4f23nMGVGxhm0xKhHeq3w=;
	b=7Rv2Z7UZKxflQ5CUM8UUZlFrk3VDb1juou1+0Llbl1AcmEU8p5WyfDvpaBEWk7Lf8Uc/0s
	3QAfOxLo7KIKhnzRe/XwDM5R26d0UF6DMm3VKqMWp/iNn5fRXlWF9OZ71Bmrt71BlGXuyt
	n+KSNegAIsNzlyhHRbrDFkEL8lHgxYc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E818600BC;
	Wed, 29 Jul 2026 16:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801D81F00A3A;
	Wed, 29 Jul 2026 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343829;
	bh=ClCpkW84PAD177XPH35BlV4f23nMGVGxhm0xKhHeq3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mhH6GHLOobQCB8al76Zu0zingH/C6stizvOMDRwZF6qpcdusj/NrDNoHRVIxL8N2A
	 J0oVV8Z7hZdYWeOYqJ0FuU5AWOYiehaAi3VJoLY+b5j8gDeDFMvrgwKXWNES19IGpy
	 7kWCWeSN2gfWbSqe+pwrWLWs4GYVmgY/oKtYLm6oxxmLESk8sa2dbLWVF3h76Bp3fK
	 3zGw2BJeiD+fMFaltl21Zdu3Fe7gx19kUzT8I8euwVjd8D1MmX7GWekHbN64RrjP6m
	 /cb2gC8Di2LAV6fubxNqHLwl7qW0jlSBucsdACvu/HXUbmXGTy+7qgNktY+hC8+Oif
	 DKw88H3t+SdVg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:46 +0100
Subject: [PATCH v3 11/15] tools/testing/selftests/mm: test anonymous page
 offset merge behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-11-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2975; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dwMvzFqQTQnP1VbLMwGR/grRN4JTFJuzh0kdCCF1g9s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H4+mtTzcfpuYx995aLHz7Snqb3r5vjzpTjIVL6rx
 OTTynLujlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExkAgPD/5L5cwNzDUVVm5QE
 LfmXW21jKK77O8dRys9/d8AF3StO1Qz/LJSe2bEVG63zUNM+E3Kv3POK4FmXTgYV51u+pbe5VBr
 YAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D146120007
X-Stat-Signature: ee8zc8cmec419xdq6hquhasejusx55yh
X-Rspam-User: 
X-HE-Tag: 1785343830-159124
X-HE-Meta: U2FsdGVkX1+enFb0OHujX270f2l5l3PW4Yim/IkmMJkOH2DXZguGHCOCOc4+FBsY9p2c5MLo14ufzmuiy/pb+mPsv8bnpx4SGQKuNc5Et6VIs+dHgc+R2Stz2Mph5utAfm6LAYV8ef3r+ekY6KF9bjOmmzfFTbwRsgnQkwKyClz7RFVWPdm4epINdyRdBtu/NjxNPQsb2k1Q7wChFiwV/5CAA73cNIpL7JLMZHLVv+pvOo7KHDLyVa6JPNR9FcznH/jdhakEm8CVfZnWi4uF+4l1HVK9unqN/s3ErvWb9i9bxLxZDx4w4taFYHfEaJ3WDCraj20PlefgJfTFHbL2b5cdYjuQ8yy9ckv9iPNWpOH6VxnN/aN1dfAHoLXMWejPC33nFvuRQalRcrgJcoCr196YN8mvWCzlKTXDE8sY82rpB9Qo8C6eZT4/pi5hwbsxeDX8BsAkCQcE58FYF8xMpymwHVfXZ1h57gaATjdtj0XMEcpRyelFAAW25noLd1Gbm4/44/zOrCApbJciBOsn2AfUKr6GS0VJXYZdjPdKKmoEuBJNQ/0zPxeq686xm2FejvqC7+rcwodvHXzzFG+Dm5KgpWdBRhtkSQWjZGllUBnQ0rEbDaMv6bpj6UHud5X2xZXil22xntelRSO4JucqjpIatKbuYVVd/GhLC9hF85rJBwH/gK58tLFgfbsWrDBShnOsi0py+QA3V3s0uw3hD2lSNtce0iX2I/Hcz3aSTSjXIoJRG04um4K07qgGLN8y4VtVihOvZwwT4fV6Jxk9xxjEPtkbfRtlEHcJlwhe7qzIYZCJF8sadvcClR11JI2HyYgUvfgex3Z0gFnrIS8iPBPJIR189t6JDZuphFOJV+yhuVhpOT2V0/ID6vHAOtL7GbCR1Jz0R5jEDJ2qTj05o9JYEAN6zp8icsBp/FQjgfYCcjAfJ02tDl8KyqWXNy/41iPGiv25NhrQIfY03fs
 mEL+qeMX
 7SYuS0JXfHKe12I7iJsi8HNjhf741FLpCQMm/pvDXPb/Zs1rhBoOjpnPIfX0OFH3RUDiktW7LmWI0fBmG3KHrYQzRllTUpiDe6MrITQ3Lm8yrb+KtIDMznxPFawNwQizvXsUvYjELd7CjzqWKTHSp9SW2/iyuc577VgKqnyi18dNVYizKG5IElOM7tuPIIgqTiSANQyDt0ChY0aSu0bPzrtRvv8SE690jLym50S56Z9JL/WQ+1qBZIU+23WdvY6dbos6vQtWbF88q2fiWmRh1Aap/2bVD4VLMSmPY/XXGS0us6uXQ8gFdfgD7pBWaYPcLYB+U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While maintaining anonymous page offsets for VMAs has no impact for most
merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
happen to have matching page offset but not matching anonymous page offset.

Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
region with a faulted one with compatible file page offsets but
incompatible anonymous page offsets.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 519e5ac02db7..cb7cdb6b7ada 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, anon_and_page_offset_mismatch_memfd)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd;
+
+	/* Create a 10 page memfd descriptor. */
+	fd = memfd_create("anon_page_offset_test", MFD_CLOEXEC);
+	ASSERT_NE(fd, -1);
+	ASSERT_EQ(ftruncate(fd, 10 * page_size), 0);
+
+	/* Map a region using the memfd at page offset 0. */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Map another separately, and fault in, at page offset 5:
+	 *
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 */
+	ptr2 = mmap(&carveout[10 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd, 5 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr2[0] = 'x';
+
+	/*
+	 * Now move it in place:
+	 *
+	 *                   |----------|
+	 *                   |          |
+	 *                   v          |
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 *
+	 * Because the anonymous page offset of the faulted region is now
+	 * &carveout[10 * page_size], despite the two regions being mergeable
+	 * due to file page offset, they are NOT mergeable due to anonymous
+	 * page offset.
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED,
+			  &carveout[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they did not merge. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


