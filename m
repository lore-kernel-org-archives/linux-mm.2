Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EE5C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5026B00D4; Fri, 17 Jul 2026 14:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BB66B00D8; Fri, 17 Jul 2026 14:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1F56B00DA; Fri, 17 Jul 2026 14:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5456B00D4
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D535E8020E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:55 +0000 (UTC)
X-FDA: 84999092430.10.1B1AC84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 04FAD80004
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:23:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHDmxbPk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVlIRx355t0P5ERcL5Eqs6eD8BqACD3+tbQgzhdx6t4=;
	b=8VPpUV6nLjIxDiiFtyzaJT8iO64cRrf1awvY7wt3GILHnFaQpco+ijbGrhlLwLFcsT3AEy
	e9rfJy0jLjL3GJ8DHMIft+yBL/itv9u+DrYjrOStCR7V80PNpIDxu6wg+KyeupNCzCv5du
	TxPrR0fRI2vN+/qAqWU8ldmhJ2S1Cfg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oHDmxbPk;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312634;
	b=vF7b4KIcpYvtqqd4NdVSnfTSCSz5Zaw4igEX8x4YYKFeZlQfLALEm+K3y/SEcrb0sOI8Ss
	SOHI2SDTRR8wD4lViYCrdHlZQ7HKGRQ9xUsMyUGNwn1t02fPrXHFCIp1KpASBjO/FnEQk7
	AV2sU9zJ9+T+qv70ya08dtQTlBgzgzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 530F543F30;
	Fri, 17 Jul 2026 18:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F601F000E9;
	Fri, 17 Jul 2026 18:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312633;
	bh=TVlIRx355t0P5ERcL5Eqs6eD8BqACD3+tbQgzhdx6t4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oHDmxbPkeZ2daJD26fnM+oSVULS5ZBTBm6laTClU9DxY3FQ2nY+UbQ0IESJ40tz25
	 AUwaH7OU9xiiEdGVIcHG4CHOwi5w6XK9DnbdVU+QKhtDUlHye7LQ6HLCTuoRzsHT7S
	 J72/Tv1VCcCLpctWACUDNPH7BZoY4UKdrQrKSaW8miBkU8G+UWtYrFO4WugRv4k4pW
	 GOl7REesFJUyAosHDnPQkgXY86dAWEgYQw7mXZdjxnBdsqntB4uQ0haOBciZ4x9cd3
	 sNZwF7UdnmPM0r0btx+i+obWK9DgjevDwoxiANm8YWp3biTuzvIqoAggy6ZJNmQiwF
	 olIYKjnWXCeBw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:49 +0100
Subject: [PATCH 11/15] tools/testing/selftests/mm: test virtual page offset
 merge behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-11-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2961; i=ljs@kernel.org;
 h=from:subject:message-id; bh=01jUabKK64NHmCAfzlhC9tplycbpQo1xdwDkiXe4HZs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZZRr3pjj9ycdukFK0HjybKqS6x5PtSNmeSwuIzz
 ZqxK9o6O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRle6MDPudjzufvXAlRnZ9
 xC++l0s1te6E7NvhMsum3C+U91K+9FtGhiuGt76qxysqLpgml1vBlPflsCireUL6n/vHT72o2z/
 PmRcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04FAD80004
X-Stat-Signature: 3ndgf6kc95oy1gpkykkehdwuit7qm6oo
X-HE-Tag: 1784312633-368954
X-HE-Meta: U2FsdGVkX18QzJf3gAY40XhQCSVq7yN+pouxsRBBZRmsmC9JxhNh3PFYHyrL/EpNn+U4PhEcx6wqr/Po0LMDmr71Tm2oYs0r+pM3P97bENW2Ys3mEtt/X61pMKntSoZQIkwNCIXNVsmKtjcgfDa84FU4cTrjRLsXS6miKMYSzkT76O+neAJ6QMLV4ycBTpTA4wghTrvCB6AlpMlSCMQ4CxbKnaKpDqE9ZW6yzZz24ys2XXYUdOvwcHI9Iojuto32hEYI8p+p3I9AjCO5DtIaC6zI6yTG443yDAfRF5g5B0Z6gzlrN4GoixAr+iXzEvgEouVYe1Ld7ssZtgHej5UKzxkWrroLeNc1o/2auGYaEplppPYX3HCiiq6u9DRxIk1qd/FphExAygblgvp7jtnrpFw6isLuk192FXdXKTE441zeK7Cxu7jwWVArOnGwRC5EAWveRXaTFQmN90/JWiQ7U18JYvX0Gi2DbvU/EMsPNCqMs5Y04hiVvt2QhhiFlYVFqMUwoF/a/9WGP/zTWTtXfoRElS+dSmJdOATnqym6tyozvjfs9xZnKLGqglJZbj2VzJ5FxQOArvwTBx9wqrnm7JioxgVPLqgNoMCUlGTP0I3xnMh+jelQ2X1kFiHTRvZKLsV6tD4iD4BgpTH74iwZtu2i5TgJdpiwLHdUfgtPEpZvMPZn33UXw6oN6pwQFXJnW1ZteuFmklVA7JaTlHSDaI1Fi7sPp4QfzLuOFz7Hno07CyLiBayu+QmWKNpyt5m3Ij7rtU+1ZnvWSkAohVrVAl/JmHUB3tMgu2Dt9f9812CU/NTt2k4m1VLXYvXzgSVrIJEDVB9ZoR5ExsQvmhK0WpbOmdo7iOW68CXe61SOoBIRY8uMAHkX3xnm3wPYbdl55uTRuG31cSHk1SorDDKcUyX/GoX4XyYUk52XezUlJqeRRT7CXU3QOxFW6ZkZGdxVAqBvyfkkWbBfFhNYhHH
 u1Or/Ehb
 RopNt2cPYg6E7mDVtH+CSd8+ooy+Dsbmz9F/eHZ70LTtrlbeBZLOVnNYRoyRx0RM6RfMAdVyibiyUxZKys4qwHPRP3R15LlM+DDIW7KcxcSZYjSYtDul4qfyKt34T68fJIz55+23rcY/2hBSfdqz/fXPTcVJV+E4k3PsIYSfu3iLv28yiRFhOXrUS85mfY4Osj4oqZESdWD/r6zZGkCph14NqBOnsQ/OvTFGER58YLJy3ESBK+1k/UfSn/P7kzu28nE/hKBXi7jLdHF9C0MMQt0FDvsPxoS8cg/yFm7Nkz3xuelnp2wqdkUUuuuKT3RuT1Xv5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While maintaining virtual page offsets for VMAs has no impact for most
merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
happen to have matching page offset but not matching virtual page offset.

Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
region with a faulted one with compatible file page offsets but
incompatible virtual page offsets.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 519e5ac02db7..c093e27d0aea 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, virt_and_page_offset_mismatch_memfd)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd;
+
+	/* Create a 10 page memfd descriptor. */
+	fd = memfd_create("virt_page_offset_test", MFD_CLOEXEC);
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
+	 * Because virtual page offset of the faulted region is now
+	 * &carveout[10 * page_size], despite the two regions being mergeable
+	 * due to file page offset, they are NOT mergeable due to virtual page
+	 * offset.
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


