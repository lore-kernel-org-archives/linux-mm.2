Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D640CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8626B0099; Thu, 15 Oct 2026 12:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B3C6B009B; Thu, 15 Oct 2026 12:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64C46B009D; Thu, 15 Oct 2026 12:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8F8D6B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:08:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B56980192
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:04 +0000 (UTC)
X-FDA: 85325342088.05.224B8E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3850E4000D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:08:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CD2obr0a;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792080482;
	b=eKlHKu/IjJSw+T/bh8QFeaEg3FURJPXC/CYObXlpuEGjgUb4F9QLSMuUeYmIbeOkxBTgEu
	VawGjbMuhta3alyaJNXRAS68s/J0HjZVxe2E/jMpvJX7h8RQgrAljRqqxhtY2hnRbqk3nB
	gbJ5bKZ6NVm1PneBSZT9C6rJl/fkNuY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CD2obr0a;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792080482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ud2Znr5W7y/xLuHTpF4M1rYyTf9+FphnA6xGQ/z7Ks=;
	b=BnyoLqvVzpK2JKzqX9UDSDoyHIzamcYeXkv0CriumwFT4qM68cOpmf3kqvUVMxz4+I/gIc
	rjVKhXnjUjqVOQkG6bpPFL6TinZB6ggYB7gG3w7YmVSASx5LrHjKrIuvODx87v8l94jKsB
	b9Der1f0FvBpEINdZAPPuiKv808kExg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BB64D416E5;
	Thu, 15 Oct 2026 16:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D01F000C7;
	Thu, 15 Oct 2026 16:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792080480;
	bh=8Ud2Znr5W7y/xLuHTpF4M1rYyTf9+FphnA6xGQ/z7Ks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CD2obr0axs8FhpRcUB5Ocn0+jnAceHNutIpXQgX+lSym4HnRx2yPgZyvSrb/fiQ4s
	 DysmRMSYtytGwsRc1DJdO5XDM7WHDnaNK6rytI7+mEpSSR/ywEZD7uM3eCyoIYlinT
	 skNZAcTxHH9+eWiX9YdttVL5qE8jCFMh4IhrW9S3y6NnTXK5feC1M+YDjR83WWaiWW
	 X9mKhmkzNjXunDWgbzHSri4+hf3NPCYy7h/1Z6Ig0E+89D/Lg9YNsZtw4B3qRCKgJt
	 xPJYt0q+/wGDIOXag8ZGUeyx6T7IlRJnC3H9Y6rXVS5BV3KWq4eYIKiThS7fYPep2u
	 UDfpWoLOVbwpg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 15 Oct 2026 18:07:12 +0200
Subject: [PATCH 06/10] mm/hugetlb: fix endless write fault on a leftover
 uffd bit
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-urgent_fixes-v1-6-42796911043b@kernel.org>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
In-Reply-To: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Adam Litke <agl@us.ibm.com>, 
 Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@surriel.com>, 
 Peter Xu <peterx@redhat.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2767; i=david@kernel.org;
 h=from:subject:message-id; bh=vsY/j7SLFL5BWtxtbqOGInAFZOdZ8OaRvzchTAd21uY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIu/DKeF/jzQWTX4YzuQz8Xil02n/wjZcXlhVut+S89n
 9Oh+malY0cpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQAT+VnK8M/s4oWsK5uvTn7K
 dtH4e7XSXJH89fb5QTkO2ZtrLIx9jxow/BURPXnt9LfKPHvunq9MxTWG5+QncrFset3XoD77JuP
 St8wA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3850E4000D
X-Rspam-User: 
X-Stat-Signature: 79fab6i6uypdic7d6u3pffqpg1h88riq
X-HE-Tag: 1792080482-279565
X-HE-Meta: U2FsdGVkX1/FZYnz3IS4AOeHkfI5BKbAB2SPl2OCReh8yp13kJfe01nBq78p+4M+iE1I99CJzcJR7SY53o1Iwx9jYSDHAlvqe5Lf8aQcmZ8fD4VGsCG0Tk+XTHg5yKSQxIXyQqBb56bOvapnC8vmBx6T1fJ7aQTG+yv7k7JDJ+xOS7/VhGWsGD14orqdPzq3IoE2TsjvJHg7I8NGJxO8QVLCwvz2Ej0l9bKKvPOXzhjdB99300HH7wJ6EQ+EW4gZmdObwH86AebvcOkO2/bK+3zVYzhG5/ahETRdbOQa1iEJWHE47y8pfnIYG8Hp+lLMZQEIRtCdWsryS+FTJKJmqpGIa8VHS42MAzeKboH/KB+Mm9BGR+9Xyo+jr1hJoCx8sUZ028dvoR0Nq8B8PcrBS8rFdj9w+/KoN9vdToNsgecYgri279BcpRgDOXb0Frtd6Xg5DvhOJdwNmAmHM9gxccDLtHv64ox6HqAEQBw/jdGe8zUeIntEdE5yuE3DFcwfWN9gC798b0uojAPYvzLMGBuH9KPYoSxqpbU0eFW+1Bg1dCGl9jpZuXtFM+uLMH4t7F9LG3NoVDz7oCBlDkRnC7F8KhbufsBaK6piXy+GiojGiM6aVx9S6UeXlR8V2u8z2vCkKOqmOPf1Q3mxIHjL0M3IuVIsFXg9Y5KQJRfmeFn3koRJD68tTWQIRIhWpMKD2aoQ7GxdUt6Z6n4cNlwcYjT5HJADfT0aLqn6N3HylLYtYIkbDR9Q83zCZ77lhg30gTQ00ITUk0GJU6Vatm+qJV0CsHzWkaNTs5GilMyV2tQAXHnDVGq2ZeVXuakMD5lARSPbHGmgXx6nLUswJTtFeAMoCY1W7vH4EOzjA6DYWu8iI2p+g5roXnx2mWnTHCPbre7Ae3aWi/wdQt62rssuDnOF13b0LKfmYRx+/kHYMOdpbTypTxTSFn4iJffJXm38h4CHv+xCUiEBFhYOcsw
 W9PDb2rG
 xHchjjGemJAvtBVPuV+7rgleXJckP6rtm3sd84JjT6x5YVV5zf809AbpVZbF9n8iPnk6TttW90LjP+z63e7pEKVMCwEBWi0gBAN42MAI3LT/ntF8t+Y4vygtvltFUI1/Xl2gghRpbGj/hHxaYn36L6J/PSsJcTtUhQeclkBRQH3Ak4rMZeZPSDneC1TCBzwZhvYpbq9HAKk+F1us6I4K9W3B2kSnSv9PUAZnmjQYboVkc7Mfn6pFEYPyKqogpcq2brtF1ifMd7wV02Sznx2LhEqdwfD6N3mXGqDYOLHHNUnnNpa+AG/16pJb6ES5ki8PU4JG+zEGagIKHnFKImdbChootRBSvceWU+u7z68V6OvBktAVHIcUQT6sZyZ/BdKK5GICH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josef Bacik <josef@toxicpanda.com>

hugetlb_fault() resolves the uffd bit on a write fault only if the VMA is
registered for userfaultfd write protection, and hugetlb_wp() bails out
for any entry with the uffd bit set assuming hugetlb_fault() has already
resolved it.

When a read-only hugetlb entry with the uffd bit set is mapped in a VMA
that is not registered for uffd-wp, a write fault to it never makes
progress. If the access comes from the kernel, e.g. read(2) from
/dev/zero into such page, the task spins in the page fault handler,
ignores SIGKILL and keeps holding the locks taken by the system call.

Such entries should not exist, but an unprivileged user can create them,
for example with MADV_DONTNEED of a page protected with UFFDIO_RWPROTECT
or with UFFDIO_COPY in MODE_WP racing with UFFDIO_UNREGISTER.

Clear the uffd bit when the VMA is not registered for uffd-wp and let the
fault proceed to hugetlb_wp(), like do_wp_page() does for regular pages.

Note that a FOLL_FORCE write to a page protected with UFFDIO_RWPROTECT in
a private VMA that was made PROT_NONE now drops the RWP protection of
that page.

Original fix generated by an LLM and sent in private by Josef.

Fixes: 60d5b473d61b ("mm/hugetlb: fix uffd wr-protection for CoW optimization path")
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[rppt: massage commit message]
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[ david: convert comment into a TODO ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f8ad2efd472cb..c3823f1958568 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6184,15 +6184,19 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		goto out_ptl;
 
 	/* Handle userfault-wp first, before trying to lock more pages */
-	if (userfaultfd_wp(vma) && huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
+	if (huge_pte_uffd(huge_ptep_get(mm, vmf.address, vmf.pte)) &&
 	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(vmf.orig_pte)) {
-		if (!userfaultfd_wp_async(vma)) {
+		if (userfaultfd_wp(vma) && !userfaultfd_wp_async(vma)) {
 			spin_unlock(vmf.ptl);
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			return handle_userfault(&vmf, VM_UFFD_WP);
 		}
 
+		/*
+		 * TODO: fix all cases where uffd PTE bits remain in VMAs that
+		 * are no longer registered with uffd.
+		 */
 		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
 		set_huge_pte_at(mm, vmf.address, vmf.pte, vmf.orig_pte,
 				huge_page_size(hstate_vma(vma)));

-- 
2.43.0


