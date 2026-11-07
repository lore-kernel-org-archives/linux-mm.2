Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACA6E606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=D1vHr0yS
Received: by kanga.kvack.org (Postfix)
	id CADDD6B05B2; Fri,  6 Nov 2026 21:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E616B05B3; Fri,  6 Nov 2026 21:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73BE6B05B4; Fri,  6 Nov 2026 21:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF0D6B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22554C0149
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:21 +0000 (UTC)
X-FDA: 85406741322.20.8CE9081
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9611D140007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=D1vHr0yS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQXpLd3G80J/dmpcLqjd+RdJWhUp5qcgTvnxnG9ug9I=;
	b=5hDN0PxTJcCBTFgIqPWHXVITRyrGoi5r/z0nvGbUag/SJkljpKzOYMKpk4BSWuTxtN21ez
	R0bwI2YziLVSTV3d+l08XpTWZI0L8BAo3Ii/izS92DYLf686RKu4NxZeNpiPRp6efY/SI/
	C3xZ/c2HlVMHJtzDaJzUfbBuTWbC1Co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018559;
	b=y/4u99b841SVpcou3mzy+SdxbAOp3CW0IoGlrI5K7VMZW2CwAgh+T1gCSIHTGw+MK8dvGY
	aycVP39GSAhnz1yH25d5+e7+iwD+4pKXrOWBwqMV91+1XOND8vVCNh7UkBKsqrsRoDNr1J
	/+Tf8KJvsUnLTWYm977iSsEZf3qoYmg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=D1vHr0yS;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36ff9c9da34so1637159eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018557; x=1794623357; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NQXpLd3G80J/dmpcLqjd+RdJWhUp5qcgTvnxnG9ug9I=;
        b=D1vHr0ySYnaVtbqTeuqEvpgqYHeFF1pRJjTRBYNV0EIWKw0UQenOjKGNIFqeV63/DS
         VUbXLy4vvXgTL99YrbIsZgZgrPVji1r2aK15ueoqXV+kDJnOp7iY+kd1ntwgE1VBTnvS
         fspA7EkvjJx6d3qCccvH6iWX/B54XiwqS3xcszDw+Uen9pWKbojbqJ8i/4A+L3e644xN
         nwrNiRaESTPn4WAf/YVdW6YUbzYDwaxQ0UAYj4JLld13Vkfd4g7BnAMo/RXw0ACvNYcx
         wDqR8KE0vx/+Lbj9vV2Gfr1t8gGzZGIHW6Hq3SJO9CAACGEgIQ6A+n7inOv9KT5FUWYi
         H6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018557; x=1794623357;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NQXpLd3G80J/dmpcLqjd+RdJWhUp5qcgTvnxnG9ug9I=;
        b=PJcHcIk3wpjoqIXDjVnd8hctUWjirYabuuaG+N+nmtAXwQrA4PbSW6og/+Xq7cqXKw
         fuvLMaFfDIBDLk43EGt6IoeEs4UtSJFNlJ9uflm766r1P1AEzeFovAIFecd+XvzSjegU
         blNhQbwdRnbgl+LHZXpv6IwG+SoQfqKLOrrbOTW1QSckRNhFIKImqbQxQp0xekLB7YdM
         4Dr2LU4muIM5sNihBg4bCoPMnKkU2mbBZiwD/kiIDf4fm5vi4kOeCooXECOTuVnpZWBY
         /CslWRh6c/oqCvHTNDADXgKqtHr14d6ziqBhWgq9lW6r/yhMq4kAACgXi2ibu0s/r66j
         ah7Q==
X-Forwarded-Encrypted: i=1; AL+hErE/2riXivEKHk/rA8Tajzvw+exgbk49y+KKfDyaznmihcNJkilC3L3+7tZz+HwaoYPsceINGzu74Q==@kvack.org
X-Gm-Message-State: APuU4Z+huzm9Nz7Xzvaq3D8Ff2OE/04Agbn6WJ+yOAzE7rZJ7QatR/bu
	m/iMuvJ0mSQsFpr0qzIDGdT2yeJ08jjKXN/iyl9D33LS49vDrjGFcUmW76aJI/uFL0k=
X-Gm-Gg: AYBFou0Ui+e6GI7cLfJnhoinoEt2qqG5PVIxdytXUNUh14aY94TXeyTvoC2DIkHJxdk
	gvcao/k6UJ6Oh3kuxeda1MJraqKysVnodIoluiewf1Qw6Q01JXr5Il+td25IBM1gaXfAEckGzDa
	BX2WJou7UoI3k0vdWxUU0KhuxroK3Vbnt2VtXiMsMMzQK+HMKA+Jy9qd5TdoqFRqGKo1u5YfVD3
	kD21wTsqXWDYb86qNLNbqoq/7k3TLp/OrBP7I4oIgpUp5HjrOtvZa+PJtkVYgFrmj2LopsCkWV0
	HxF1LQkyUtlLHHYJIbYRSTw+89ondUIiRPEmDuHWrkQdXCuOVdUEQvEdE7CBS2FKy7l5Rzjm3QS
	BvmBgZOy0NUzzSXMr7peHG5PBljl4661QZCPsIMDjEwkhJzEGxXU7BGkftK2BGkoKdG5O+7oclU
	sjA+8FTzitSp/QthtSYvTKf0i5JYz4OmQpZTBmLfrPFHJNexTxQ9JZ76/pxlAKqu251x6sVc5uu
	WVRi7T7n877npAEf7q3CdE710O2CjLC+W2dwM4euucejCGkc27C5gNpvlZb0zpdVUFvogvqfMjM
	WnGiDg6HTgvRjfWqDQYo8fD6ksnCWCHLUL1r4UzSYC3mLG0nxINy1U4HaO5I
X-Received: by 2002:a05:7301:dc2:b0:35e:5ca:e0df with SMTP id 5a478bee46e88-36f76b18abcmr6279268eec.35.1794018556813;
        Fri, 06 Nov 2026 18:29:16 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:15 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 01/13] mm: hugetlb_vmemmap: fix OOM during head page allocation
Date: Sat,  7 Nov 2026 10:27:44 +0800
Message-ID: <20261107022756.77731-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6k3cxpg9ut41t9iz13677a9wmrrsofxf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9611D140007
X-HE-Tag: 1794018558-746574
X-HE-Meta: U2FsdGVkX1+5Tx8hZOvupInhh/efKx45O3RLAIRURXJL+dqpSxV9spX4OJ9cM8LsGbFsQ47yfv/PL+7cLZRlqcE/Sm0hYRqHpH5Ib6cX+XaVeU8nYHEgE2oXaUjs60qPkasQSHxVsBBagmmiswwxhvk79ZvtRGuy20XsQQ6ncPN6HKBXWy1NF6PW2a1koi98+fKLXoTt1F/BGStEi9uUgSI5FdS//n8L8wkawECez9jvgliPek5pK7NnksBnyVK0DSsvURlhwD39DxrMaBRwZ0xq53hTU2TXiBwxt5yMzlqVzeaU9Z4haqRADEaxRGuc0DKFvAcHmQXTsedue58K86wwxWa3xnZmsKJokx96EjM8bcFO/dWOPqN872EH6aXYtd0kQEPmDLwkOFIDpDULeRrVHOM1x+TQ/TJ6TUEMWuVDtrhlcR3l4d4fn4U604OS5fVUyCjW/ROF2Yaf0DGQdJL5SIqeBg3fRaCs7+mLA2uv6Oc7Gx8MTP9oLQJPDel0LStAsHhXly3ylPeDOK3TkelOoWdK2QVEyBwrS3E+H8SWXNABD2sXN9tVaFRkvzwPfXxkcGu6CcL61a0w0Gn95aARo6FOHec/MMbzYe0v2ecNv2Q3vzo2DKfV21LKelllvu+L5WTX1iLsqfgMKslQEMPP6YVux+PZI0uPWWa5bJ7+bWsdZ7FIIRLH308yJ9jx9X4E+VBG7QsqxlwitGwx/9401RrMAgB05LnIOhLrYAZtAMIlzJvoQdhv9wvbag4UuDmXrYhcP84yc8PCqDrD7ak22ee8XZj8nZbrQ7bp21H378+xxMFLxJXxl3a+BAYrHpK0/TYVU9wyX9+3O+/QgW1/L0bUIkAdtEGNVg6InZRB0som/GzyFx7YyJee20dp1BogbqvW+/rZoJtPWtJiWaJagqK93I5JxfHeqgXCMfGLhvwHh7pEY3dNH6KekD4cos+FgmDLYJigZRu0Y7q
 3gJe2nUM
 G2KnZAADmNA+nq6MxMQ5zJADkdxioFNaDzMJ489RhPvKlYnWbdDw3zLKOEgUwAQ6eEtBN5/Jl1AnHoprae6Ga0shkQ3vUnlbr4NfG5A5h5FBhM8H73hTctvppK4DdosgmIUBfRzNK8JyC2iyarG7T3/hvB8RsbLVyshaTiYXtd4qDlenLXku9qw07GlD47fw0URRI/1+Uqf3WURi1byH/fmAwvJ2u1pwcakrKbTOOiDkKhHUqlbij8E3La5vkrU9zojV8mdbtgaEbcNGz7/MMSMrUFbLY0drU6ofn+8+T97ierYRq8n3/yLQwR3uKo+L+B0rcFDPLUwB//n81Su6mtq19X7uqZY3QOlt5KCwI+ESXCA+b73CKem2tl6QPBM8PFM/G2jb94IBzgkETWAoAVgDh7HRlpfGOAIDZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Yili Zhang <zhangyili01@baidu.com>

The head page used during HugeTLB vmemmap optimization is allocated with
a bare GFP_KERNEL mask. When boot-time hugepage allocation drains free
memory, parallel optimization workers can enter OOM handling before
userspace exists, leaving the kernel with no killable process and causing
a panic.

hugetlb_pages_alloc_boot_node() invokes HVO on the folios accumulated so
far when available memory reaches zero, allowing the released vmemmap pages
to support further hugepage allocations. If allocating the HVO head page
returns -ENOMEM, the bulk HVO path frees any vmemmap pages it has already
accumulated and retries, while callers can continue with an unoptimized
folio if the retry still fails. Therefore, neither an allocation warning
nor OOM handling helps this best-effort allocation. Use GFP_KERNEL |
__GFP_NOWARN | __GFP_RETRY_MAYFAIL to allow reclaim retries while avoiding
both.

Fixes: c0b495b91a47 ("mm/hugetlb: refactor code around vmemmap_walk")
Cc: stable@vger.kernel.org
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
Co-developed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v4:
- Split this patch out from patch 4.
- After splitting it out, the resulting change was almost identical to the
  patch at:
  https://lore.kernel.org/r/20261104133938.50974-1-zhangyili01@baidu.com/
  Retain the author of that patch and only rework the subject and commit
  message.
---
 mm/hugetlb_vmemmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b8ce014ba6e6..7fcc97b12773 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -501,6 +501,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 {
 	unsigned long vmemmap_start, vmemmap_end;
 	struct page *vmemmap_head, *vmemmap_tail;
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -527,7 +528,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+	vmemmap_head = alloc_pages_node(nid, gfp_mask, 0);
 	if (!vmemmap_head) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.54.0


