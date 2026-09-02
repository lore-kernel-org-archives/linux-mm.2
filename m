Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDE5C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613026B00B9; Wed,  2 Sep 2026 14:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C906B00BC; Wed,  2 Sep 2026 14:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC5E6B00BD; Wed,  2 Sep 2026 14:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23DF76B00B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:01:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4EBEA41CC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:12 +0000 (UTC)
X-FDA: 85169588784.12.BF5B378
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C55DB1A001A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHevDBYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	b=oypSz4hlQfzVaVLSLIMrDoc+bPP6USeyL7xDOVsuJPrepFG+JGWVwrPWl2I1igpwuyiop/
	9kFxbkQBwCw1PGA5kS3rKePu2VIWNF5np16jBBuDHYczqKiY+/ChA50RZTdAdCxfskmC2m
	F1JxWXg+pNYkgkTN1keKW4WSvfKzOZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372070;
	b=YusfoGqJ8psTRWGn6U2iurm9JzIaWRu0knhcZiFbJcqaQzL80WA59iUG5cuw9B82rhKJu2
	H/YlD/nUyhPRkEfGsmTaCKEbzjPDZAI/GB+6X528sLU0ekR5FQPRCOtfw4gN8C+eQJn481
	Or3T5Dl81qszoyYtV1HNIMJ/nzH0y+s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHevDBYl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 195AC4341F;
	Wed,  2 Sep 2026 18:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87DA1F00A3A;
	Wed,  2 Sep 2026 18:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372070;
	bh=7INaOtP/gm2Q0CwFqGyhMMm+FXe4/enBYyOAMoEMKqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aHevDBYl5hjaNDNwhdaa8kY7f11J7SCp88tnXt+ak5jBNNMaNCZL/SLusgaHNCK/p
	 SZK9/Y1HaQ+x9hnq/BEjr+Jny3I4XQV12hx0fC7aOkDw5uke0RQGFPEeQuvkqKMyrr
	 0WvkYPYhDB9F7/zmeNrKwq/onEoa1yXvZ5cH60X1b40vRUdiOkMTl2B2viY2Qd6yP1
	 4SJeiZIVXf3dYH6RVJ5WXuaNVVV6XkbNx5hZfC6qjhrLTcDiGSqVoAlI6zr9Lylkrx
	 9poIzuEr+0GEGqSLXCLnwbqno0TlpN3MYCs/drYw5DrjU9FgggUiglJXMEQ29by99m
	 SqrfqhwqLkHWg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:22 +0100
Subject: [PATCH 5/6] tools/testing/vma: add test to assert
 MAP_PRIVATE-/dev/zero is anon
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-5-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1881; i=ljs@kernel.org;
 h=from:subject:message-id; bh=MuW0MgECKFqsgKYanDvHZ2zzAEiQ7iCtWQ9chN/jOZY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHi9nvw5TIiDx717l+IWCYn9hvfbghpNU3+UHZhwd
 Ifr/36GjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkmDkjwzuF0m63Ml359V7H
 NU1u3tJ+G1/wwdk+yDO64Ny5w3PjNzL8Yv678MJ/N2c2vfUGW7bmrdtdyCK598aDmPgrHVk5E5Z
 c4QcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C55DB1A001A
X-Stat-Signature: mest4d4t135bfxwe3638whiaj971zma1
X-Rspam-User: 
X-HE-Tag: 1788372070-909651
X-HE-Meta: U2FsdGVkX19oTHU0gw7ndBtk2hQMTXD+G/FfldHbntjOISvwnFBOHSFihslnOBUYo0z0WCLskLAQ09KSwcAqVkiEvv8AMRjsrIUdoWPLopi0v1fvhZpSLOrZ7IDPD6c8N6eGdZSUQzOkTAFXYqmfrcXAAGT8Nsg++8O7QEg0ljQn6ldLaFNXdJfDS5/h4SAuGhbkcn/Cnn+AEgDXwU1o4xkBPD8Ejuf2czqtQhwmqaiy4wjxzPKD1ofjzFus/jyuHEtn1RCAv9zQAcYew3D8HFzmYj4JMohHszwMly3uYq6F+rasq9bsBVT0f16sh7TUHlHtYBRuhF2gaPQdYpZffFPtNgIKrQnOTgWaA48qcqFfWgE+NZNXAYNFKNfsQ96yVzoWFmeCnaa8FNKRvqiHP+Y4w7Dxe2jrFGoaUIg1wfo4oF7wvk2471KanBoJxq1Gua+6CY7446tbhpNLHjHW335BmH8j57A7LW0Y18owpff2a7fM/SuToE+H/zxv8KMwMh4U+OGyuoIXU1hJcEwqQQ2pNyaVDWtv0U2h0GlxduyIka6M777Y+cVjNx7KcXDh1QNLZmgFss/asLcIpKXZtvL8FhU69UwqiFpzgAnMlT6GzGJML+pVHxo2mFel8V0Evg+qZZjLcbksCt7OKUc+B/tw0mrKKTib4Y419dSWreXeohHxZo631qhzKLYKAEC/fYT78cKFy7RY39xvuXNX/NSSWxlmQicvRZ3Mw4JvaqYWoyHY1XyRG3zl5ljRKGEUsrUeCkwG6jaWRiY2WyOqwsQyVRU3yD/yK+L8X504oAiHjBp8SBm/Rb4ScL/NpG88DlonPEXMuPw0woCRRLBQgbRLybC88ajUpnMrlcIcQ6fW7H9BTYcXxtqRDI/lZZVxJjhUocIXllwx+XyEJybqRmVzs/HFMcPGCuYYlIGSNjR1JGEmV70SuubdNVlRekRIWBBKfj02S/7g00F22zd
 5eEPch9m
 9BekpKVed9oWbZBZ25vxN92fi0+Mx/ry0nQSFm4u8N8/hRKRlrrWFIsM5LeKfLJ2zzYkiSGNm8K4UILUjj7bLiV2rsUF1sE8LxpusSASRMXVWQJJ2OiZtJK2p8PieaCVhVsStUucYf4HEtH45WYu70yKg+VkEQG2ptinsFqOdffQs1VAs0obPZxsonQxQziLt2/dK4u1Tzq/qHq9gIdqe80O0qShoRpSKJJ2xYhHtl3Dmff+1WBAildD4bYRXLHRQhN/Bp6vCindQN+hx5vM+nTMs3QMYfgQ2czFl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we've made MAP_PRIVATE-mapped /dev/zero mappings truly anonymous, add a
VMA userland test to assert that this is the case and everything is as we
would expect for an anonymous mapping.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/mmap.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..fa73faff2262 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -45,7 +45,44 @@ static bool test_mmap_region_basic(void)
 	return true;
 }
 
+static bool test_pure_anon_dev_zero(void)
+{
+	const vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
+			VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
+	struct file file = {
+		.f_op = &zero_fops,
+	};
+	struct mm_struct mm = {};
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	VMA_ITERATOR(vmi, &mm, 0);
+
+	current->mm = &mm;
+
+	/*
+	 * Map a MAP_PRIVATE-/dev/zero mapping at address 0x300000 with a page
+	 * offset of 0x10, which we expect to be reset to the anonymous page
+	 * offset.
+	 */
+	addr = __mmap_region(&file, 0x300000, 0x3000, vma_flags, 0x10, NULL);
+	ASSERT_EQ(addr, 0x300000);
+
+	/* Assert that it truly is an anonymous mapping. */
+	vma = vma_lookup(&mm, addr);
+	ASSERT_NE(vma, NULL);
+	ASSERT_TRUE(vma_is_anonymous(vma));
+	ASSERT_EQ(vma->vm_file, NULL);
+	ASSERT_EQ(vma->vm_private_data, NULL);
+	/* Expect anonymous page offsets. */
+	ASSERT_EQ(vma->vm_pgoff, 0x300);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0x300);
+
+	cleanup_mm(&mm, &vmi);
+	return true;
+}
+
 static void run_mmap_tests(int *num_tests, int *num_fail)
 {
 	TEST(mmap_region_basic);
+	TEST(pure_anon_dev_zero);
 }

-- 
2.55.0


