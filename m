Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA4EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1F26B009B; Mon, 29 Jun 2026 08:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9426B009D; Mon, 29 Jun 2026 08:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E576B009E; Mon, 29 Jun 2026 08:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3A9B6B009B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B9991A069F
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:08 +0000 (UTC)
X-FDA: 84932827056.10.E605E7B
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0A4B12000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="L RL+JWQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=T6l7P7ti;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734886;
	b=h/rQvFNFUomHpb9fbevHvQ2s7VwjAqqzdA3jF3rPqjmcPHcahNkMAyVVR6hA87XpNWeLJN
	YL9fr6QWF0nmdTKZ1HXV5cOarzwOOlK3tevEBpyrDkcsCYbzuYuQhTEdKF0W/9XxkKhJqK
	evSJrniFmGOVpx2nd2O2ORS+qHK9Uz0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xnTNjCuj3GdKZ1nDW7VG9OQhw9Q+3kzTNxitzuhMF4=;
	b=XetVC3UDXvSbHc5u8/AHejOYCLH8n2Pc8I46abz/5ORTSRwd9ygAIreUY5EGdm33ejMm3F
	7JYcfO5j9yIqOaC+RfV5xehWTWCY3qjI/T6DpV9WJtDoD5VNBvVIphlx03uJW5w8ht99TF
	zwX+8z2YT6hpojyUM5abVsXwcrcUMBk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="L RL+JWQ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=T6l7P7ti;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id A1A43EC0148;
	Mon, 29 Jun 2026 08:08:05 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 29 Jun 2026 08:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734885; x=
	1782821285; bh=0xnTNjCuj3GdKZ1nDW7VG9OQhw9Q+3kzTNxitzuhMF4=; b=L
	RL+JWQrbiNHyEN4J06RqZsSLGs1HKathsa1aLj0RNvEPCc30DvlU2UwKK4erJkLa
	+VCPTx5ikEDs5pIxFo2OzSlT9Rh2rTz+ukxpK19D3Ol0InDddGdoNcne1URBTlTb
	+c+/dIUsEcaBQnzxGAvLJhFeHil5tXgikQA8YwGRKWBP+o82IZce/ieX+R18q1Lj
	CVgHmJ/N7PyLj0SFy4MU+K2FvlY5DhiUDsR4/fQlkkutJLDjSjfisdzoWTcWeOOW
	33xkSGjv+ggwOeNbQUMFZvazQtZGjC0jJJRKXRd+pjnsnzS4Fyi62QudA54jaBpC
	u48HRaTirgdVC+8w37oTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734885; x=1782821285; bh=0
	xnTNjCuj3GdKZ1nDW7VG9OQhw9Q+3kzTNxitzuhMF4=; b=T6l7P7tiqqu2qjh/1
	1NyuoDEBc1l2ovh5Dn3rPgKZaGD6ITCC3iffilyMJiWXx1FLXf0120BiosBRia/O
	MuKmqm27S2RPpCJ/Ymnv8rAOTQw8f/7llkELghLcPflpdiBcdFVV3a8TFLvTgg2N
	T/dfuTDWrkD16QSOLn5aMoNoGEUbKinwjDXR8k03jHdxbdd02HKT8LoV9Xa0Ac+X
	MxJXdJaQ5M49TYLqIa5/BIyiXPzQjzu2f+uzquJlhUCHNxJRgbp8v8GT7c5qdgey
	uT6g/JyW+RYLmweqhCEcLbNZZ7zT7VIE+S4ya675ELQz9Vk4lQOGLNhyl80YmsDr
	+svyg==
X-ME-Sender: <xms:JWBCathRMqsVN-TEIZIpf4cfWDqeruhnD_aqahVKDlJF6xSKObmq-w>
    <xme:JWBCal8wP6vxGz7CzRTdywNAIBBZdjGHD_cEPCHJI1uZ5E3WAgJxJ_MqgWyFlFnEG
    hmoImsb1OBfLX1VqIAKiskYD1cII6arBfkma6fTo5IrZ1cXV9yYBa4>
X-ME-Received: <xmr:JWBCalkyrvF6aWiLXDB-WSO-fB328EzV1eTq8APqbm7UQpP2Sof1BWCJMZxn2Q>
X-ME-Proxy-Cause: dmFkZTGCAdWa8y56GE5iIIauxev7upOCYE9zCesFIW0XQilO0ILmz+DEdNbj9OmdP8/YaA
    R2/C6A1Oi3yNIsZMSQdi7yX3X8zsE//LQ3z/MutWiher2fNZ9EaxtOoPMRFom3ZhJtlOLu
    bGhxys8z0/PJrkXzE2pQ6GuSrdZdLCDRp7DGP5N9oqXEj+tYnVpcrD2hWEYBYKngpqp759
    siprR7jviw9IvY9Dom+95lDquor9f6gS9e/6NLSs9SurhVUXw/b7CPqd31Vji7wQyuHae+
    MwrukO62wp4PMOMkUjyYAj42LG8hSolh8RljqiaIwvl7VCqXF9PjqIT3nI8m5tG+BApnGW
    M5lqobsUq/KS4tIMhopGrUahSnqPCkCUVnbVx+T5luVuJ8GxWzdI4KlUA8oUb9pQfeNxBM
    5sxzLJjc35XbTmBV3OIM4X4CHF8mhwVBcnCaLju/gwK1xROCm7LbXQ01Z/E96OesZkwJB7
    w2683yGHyXc4MBKSOfRjteumYCYF+tfaFWYvAzbsPKTztlJ907tS7iGnZ3UrhUoYu2hyZq
    OXVUxsIJgjxzPCHLSKeZmD8WGdnMLmI+M+BV1fzCHRqITDEhftxwSll1IcIqA4S7jqxGJZ
    bsAeJpPr+Z6rnSGOzVOyf3PTrklO0Cu6H6489+iC7TQG2rbwBEAREUWtMVaw
X-ME-Proxy: <xmx:JWBCar12T3LLPPpxC1kqLJO1eGdPkgRu-Isg4KZ4sSAJ1qJEX0wB8A>
    <xmx:JWBCaiSvhzvtZDZDxMQm7ng28IbEhzjNBhpimf8lgZ-iQXTBhaJrog>
    <xmx:JWBCajP8mOyZ7Ji1CZTXrIn4IebIsKwMVUx9y7c5lUgBuIkmDjhvjw>
    <xmx:JWBCauhZrjjd7mEc95U2YXHfWJz7WYyRkko73hd5TKkgZWlvngvwxA>
    <xmx:JWBCajjVRCC0k6hPfGa9pl2IM340_OZxjgz_drrQSRLymXE_vcYLLK6e>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:05 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	kas@kernel.org
Subject: [PATCH v7 07/15] mm: preserve RWP marker across PTE rewrites
Date: Mon, 29 Jun 2026 13:07:38 +0100
Message-ID: <20260629120749.566063-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0A4B12000A
X-Rspam-User: 
X-Stat-Signature: 3ozg484h5z9q65wimz3wsj9sdky858ci
X-HE-Tag: 1782734885-836026
X-HE-Meta: U2FsdGVkX191/wDdA6MBX6axCSE8iou4w/tqrV94A5bj5WxE8bxlWMw0Q3SKl6rQv6qQa6Y0q7azDmgMukMxWyo7cRFzI1Z/CP+uQLIb9CKs33RebSav1GS+O2k27PZ4lmiMtuXM+IeaYjkaqPrWub60+UWdFWs1RoAhsJog1RbLFDNe/wBvEHlQRWDLkGrg2qsfv/LUKlZu0jVIl3bLpn+FYYJHFoWvrwWNO4W5N4+JmUUxfgaMn6wL1SREZVyCfXCAAjhEI7d3CV+gZDN5QNM4zZZqn9AgqYnclFzefWmfEsfJY8rfeYXnWNMsaCBQosyKzgHLMqcJTJJ0i2IHwaDkNa8HUHBvfcxfQYb9OyCN94QbxxraN3jxp5O3iTh0v92i7tKLWTrIs1GmwxTC+Cvnjo9Bo/O3FORdhxc5qyKkq29hCbCxiI4HS2Kg3zjSSD+go15E0WiHsQ7Y9yHnNJECSl9JHMYQB+r29/WL4N5n2eYa8DpicesabMIAJbvbRNUN82Mp26f/gC6z6vcXM7kZ4BsACMMeKzyPzmAJSASp1q+Itg9MGEYGMXq8uS8rlyF9K2GLnqvmDMwGdca2bURl2CNIH2SUqqTlQhzNVaJtjl4vlTPrAe+OzIItDfaSN0StvSWm1wXTJOikHt4rVLBYS0yN9tfeP5vCxvtFoNYg/9T61C0f/RalevZzvohG0bCnZE/KDhXzM5AW8t9svXhDICvfwqrR5cjEoRfuGIwQGCeE6z2+iotxeRJ+tqQ3G9lFKt4x7nI8+R4yblDeqIr70PjYDh7/fKyzax98byprrTDFc4g1HgjdUUvP5fAiHnOYYAsseyFerg3pDmDmh+988dLSf4w1HToYtlzYeHmkfGXqGBvCLBgPMckKEJPNJQn0AMzpoQzuF4STA/on4N/iMlQIr+VeRjNNI+ksMwqvN4/0k5TZqMwdX4bj4qDLPjaJsYsJSZMx40qmVpN
 Wk9zYLh6
 oSAnwPGw+AHJ+uYAAqV23hMi1SChV+Gb9D3EVY6pbvPiyeNq+UOu6QIoK7jl8iqjvakMD9Ti0d9Y27yIVh1DkJMjy9KFc8XlLd9kqMjvk4FPa5E5DLi5Lzdxa/PqWJ+Hdo+3B5YT+SbVVz4A0bU2bULV6AKMdndy6YgMthBskp1GWFWIvk33W4LCSYN3UFFHn9otOQHKHN4U6lNasWgaZ8wbVAESNEEuP51f63pe7mM8pqhgpGdusU9zvOyRs4xntoSuMjbitfgGt7f+j/dDHkmZJgRgc2MFykjJGtvelrKKZySvnNJRpcXWgQN7jW52srIXJLyNSYxmNGtI8qt6Cou1WcD1bhklfUsywIuWkzd3hMzMKncDduID7Hpys3j5T5kUprv++M8pz8XVgwXwafb5/B3WluE/5eP8JhRJeWAFTQPQtaYys/RpGN8W0bMgM6VkDkJuAQgNqICI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The uffd PTE bit must survive any kernel path that rewrites a PTE
on a VM_UFFD_RWP VMA, otherwise the marker that carries PAGE_NONE
semantics is silently dropped and the next access leaks past RWP
tracking. Wire the preservation through every path that rewrites a
VM_UFFD_RWP PTE.

Swap and device-exclusive: do_swap_page(), restore_exclusive_pte(),
and unuse_pte() (swapoff()) re-apply PAGE_NONE when the swap PTE
carries the uffd bit and the VMA has VM_UFFD_RWP.

Migration: remove_migration_pte() and remove_migration_pmd() do the
same after the migration entry is replaced with a real PTE/PMD.

Fork: __copy_present_ptes(), copy_present_page(), copy_nonpresent_pte(),
copy_huge_pmd(), copy_huge_non_present_pmd(), and
copy_hugetlb_page_range() keep the uffd bit on the child when the
destination VMA has VM_UFFD_RWP, matching the existing VM_UFFD_WP
handling. Add VM_UFFD_RWP to VM_COPY_ON_FORK so the flag itself
propagates.

mprotect(): change_pte_range() and change_huge_pmd() restore PAGE_NONE
after pte_modify()/pmd_modify() have recomputed the base protection
from a (possibly user-changed) vm_page_prot. pte_modify() preserves
_PAGE_UFFD, so the bit stays; we just have to force PAGE_NONE back
on top.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h |  3 ++-
 mm/huge_memory.c   | 47 +++++++++++++++++++++++++++++++++++++----
 mm/hugetlb.c       | 52 ++++++++++++++++++++++++++++++++++++++--------
 mm/memory.c        | 49 ++++++++++++++++++++++++++++++++++++-------
 mm/migrate.c       |  8 +++++++
 mm/mprotect.c      | 10 +++++++++
 mm/mremap.c        | 13 ++++++++++--
 mm/swapfile.c      |  5 +++++
 mm/userfaultfd.c   | 17 +++++++++++++++
 9 files changed, 181 insertions(+), 23 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87b2fb1e3f23..3d4d5f9a6f1b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -683,7 +683,8 @@ enum {
  *                           only and thus cannot be reconstructed on page
  *                           fault.
  */
-#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
+#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
+			 VM_MAYBE_GUARD)
 
 /*
  * mapping from the currently active vm_flags protection bits (the
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b352b0dfe1ba..addf3bc34618 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1856,7 +1856,7 @@ static void copy_huge_non_present_pmd(
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pmd = pmd_swp_clear_uffd(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 }
@@ -1951,9 +1951,15 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
-	pmdp_set_wrprotect(src_mm, addr, src_pmd);
-	if (!userfaultfd_wp(dst_vma))
+
+	/* See __copy_present_ptes(): restore accessible protection. */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma) && pmd_uffd(pmd))
+			pmd = pmd_modify(pmd, dst_vma->vm_page_prot);
 		pmd = pmd_clear_uffd(pmd);
+	}
+
+	pmdp_set_wrprotect(src_mm, addr, src_pmd);
 	pmd = pmd_wrprotect(pmd);
 set_pmd:
 	pmd = pmd_mkold(pmd);
@@ -2539,8 +2545,16 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma))
+		if (vma_has_uffd_without_event_remap(vma)) {
+			/*
+			 * See __copy_present_ptes(): normalise RWP PMDs so
+			 * the destination starts accessible instead of taking
+			 * a numa-hinting fault on first access.
+			 */
+			if (pmd_present(pmd) && userfaultfd_rwp(vma))
+				pmd = pmd_modify(pmd, vma->vm_page_prot);
 			pmd = clear_uffd_wp_pmd(pmd);
+		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
@@ -2679,6 +2693,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 */
 		entry = pmd_clear_uffd(entry);
 
+	/* See change_pte_range(): preserve RWP protection across mprotect() */
+	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
+		entry = pmd_modify(entry, PAGE_NONE);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2846,6 +2864,13 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
 		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
+
+	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		_dst_pmd = pmd_modify(_dst_pmd, PAGE_NONE);
+		_dst_pmd = pmd_mkuffd(_dst_pmd);
+	}
+
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
 	src_pgtable = pgtable_trans_huge_withdraw(mm, src_pmd);
@@ -3022,6 +3047,11 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		entry = pte_mkspecial(entry);
 		if (pmd_uffd(old_pmd))
 			entry = pte_mkuffd(entry);
+
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && pmd_uffd(old_pmd))
+			entry = pte_modify(entry, PAGE_NONE);
+
 		VM_BUG_ON(!pte_none(ptep_get(pte)));
 		set_pte_at(mm, addr, pte, entry);
 		pte++;
@@ -3298,6 +3328,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		if (uffd_wp)
 			entry = pte_mkuffd(entry);
 
+		/* Restore PAGE_NONE so an RWP marker keeps trapping */
+		if (userfaultfd_rwp(vma) && uffd_wp)
+			entry = pte_modify(entry, PAGE_NONE);
+
 		for (i = 0; i < HPAGE_PMD_NR; i++)
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 
@@ -4965,6 +4999,11 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 		pmde = pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd(*pvmw->pmd))
 		pmde = pmd_mkuffd(pmde);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pmd_swp_uffd(*pvmw->pmd) && userfaultfd_rwp(vma))
+		pmde = pmd_modify(pmde, PAGE_NONE);
+
 	if (!softleaf_is_migration_young(entry))
 		pmde = pmd_mkold(pmde);
 	/* NOTE: this may contain setting soft-dirty on some archs */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4d75b69d4272..0d8d39cd8888 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4843,8 +4843,16 @@ hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long add
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
-	if (userfaultfd_wp(vma) && huge_pte_uffd(old))
+	if (userfaultfd_protected(vma) && huge_pte_uffd(old)) {
 		newpte = huge_pte_mkuffd(newpte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping. */
+		if (userfaultfd_rwp(vma)) {
+			unsigned int shift = huge_page_shift(hstate_vma(vma));
+
+			newpte = huge_pte_modify(newpte, PAGE_NONE);
+			newpte = arch_make_huge_pte(newpte, shift, vma->vm_flags);
+		}
+	}
 	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte, sz);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
@@ -4917,7 +4925,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		softleaf = softleaf_from_pte(entry);
 		if (unlikely(softleaf_is_hwpoison(softleaf))) {
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(softleaf_is_migration(softleaf))) {
@@ -4931,11 +4939,11 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				softleaf = make_readable_migration_entry(
 							swp_offset(softleaf));
 				entry = swp_entry_to_pte(softleaf);
-				if (userfaultfd_wp(src_vma) && uffd)
+				if (userfaultfd_protected(src_vma) && uffd)
 					entry = pte_swp_mkuffd(entry);
 				set_huge_pte_at(src, addr, src_pte, entry, sz);
 			}
-			if (!userfaultfd_wp(dst_vma))
+			if (!userfaultfd_protected(dst_vma))
 				entry = huge_pte_clear_uffd(entry);
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 		} else if (unlikely(pte_is_marker(entry))) {
@@ -5000,6 +5008,16 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				goto next;
 			}
 
+			/* See __copy_present_ptes(): restore accessible protection. */
+			if (!userfaultfd_protected(dst_vma)) {
+				if (userfaultfd_rwp(src_vma) && huge_pte_uffd(entry)) {
+					entry = huge_pte_modify(entry, dst_vma->vm_page_prot);
+					entry = arch_make_huge_pte(entry, huge_page_shift(h),
+								   dst_vma->vm_flags);
+				}
+				entry = huge_pte_clear_uffd(entry);
+			}
+
 			if (cow) {
 				/*
 				 * No need to notify as we are downgrading page
@@ -5012,9 +5030,6 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				entry = huge_pte_wrprotect(entry);
 			}
 
-			if (!userfaultfd_wp(dst_vma))
-				entry = huge_pte_clear_uffd(entry);
-
 			set_huge_pte_at(dst, addr, dst_pte, entry, sz);
 			hugetlb_count_add(npages, dst);
 		}
@@ -5060,10 +5075,22 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 		huge_pte_clear(mm, new_addr, dst_pte, sz);
 	} else {
 		if (need_clear_uffd_wp) {
-			if (pte_present(pte))
+			if (pte_present(pte)) {
+				/*
+				 * See __copy_present_ptes(): normalise RWP
+				 * PTEs so the destination starts accessible
+				 * instead of taking a numa-hinting fault on
+				 * first access.
+				 */
+				if (userfaultfd_rwp(vma)) {
+					pte = huge_pte_modify(pte, vma->vm_page_prot);
+					pte = arch_make_huge_pte(pte, huge_page_shift(h),
+								 vma->vm_flags);
+				}
 				pte = huge_pte_clear_uffd(pte);
-			else
+			} else {
 				pte = pte_swp_clear_uffd(pte);
+			}
 		}
 		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 	}
@@ -6515,6 +6542,13 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 				pte = huge_pte_mkuffd(pte);
 			else if (uffd_wp_resolve || uffd_rwp_resolve)
 				pte = huge_pte_clear_uffd(pte);
+
+			/* Preserve RWP protection across mprotect() */
+			if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
+				pte = huge_pte_modify(pte, PAGE_NONE);
+				pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+			}
+
 			huge_ptep_modify_prot_commit(vma, address, ptep, old_pte, pte);
 			pages++;
 			tlb_remove_huge_tlb_entry(h, &tlb, ptep, address);
diff --git a/mm/memory.c b/mm/memory.c
index 6b0304caf1a4..978ead28c6d1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -896,6 +896,10 @@ static void restore_exclusive_pte(struct vm_area_struct *vma,
 	if (pte_swp_uffd(orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	if ((vma->vm_flags & VM_WRITE) &&
 	    can_change_pte_writable(vma, address, pte)) {
 		if (folio_test_dirty(folio))
@@ -1041,7 +1045,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				   make_pte_marker(marker));
 		return 0;
 	}
-	if (!userfaultfd_wp(dst_vma))
+	if (!userfaultfd_protected(dst_vma))
 		pte = pte_swp_clear_uffd(pte);
 	set_pte_at(dst_mm, addr, dst_pte, pte);
 	return 0;
@@ -1088,9 +1092,13 @@ copy_present_page(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 	/* All done, just insert the new page copy in the child */
 	pte = folio_mk_pte(new_folio, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
-	if (userfaultfd_pte_wp(dst_vma, ptep_get(src_pte)))
-		/* Uffd-wp needs to be delivered to dest pte as well */
+	if (userfaultfd_protected(dst_vma) && pte_uffd(ptep_get(src_pte))) {
+		/* The uffd bit needs to be delivered to the dest pte as well */
 		pte = pte_mkuffd(pte);
+		/* Restore PAGE_NONE so the RWP marker keeps trapping */
+		if (userfaultfd_rwp(dst_vma))
+			pte = pte_modify(pte, PAGE_NONE);
+	}
 	set_pte_at(dst_vma->vm_mm, addr, dst_pte, pte);
 	return 0;
 }
@@ -1100,9 +1108,31 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte_t pte, unsigned long addr, int nr)
 {
 	struct mm_struct *src_mm = src_vma->vm_mm;
+	bool writable;
+
+	/*
+	 * Snapshot writability before the RWP-disarm rewrite below: when the
+	 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
+	 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
+	 * so a later pte_write(pte) check would skip the COW wrprotect and
+	 * leave the parent writable over a folio shared with the child.
+	 */
+	writable = pte_write(pte);
+
+	/*
+	 * Child is not RWP-armed: restore accessible protection so the
+	 * inherited PAGE_NONE does not cost a fault on first read. Gate on
+	 * pte_uffd(pte) so unrelated PAGE_NONE markers (e.g. NUMA balancing)
+	 * are not normalised away.
+	 */
+	if (!userfaultfd_protected(dst_vma)) {
+		if (userfaultfd_rwp(src_vma) && pte_uffd(pte))
+			pte = pte_modify(pte, dst_vma->vm_page_prot);
+		pte = pte_clear_uffd(pte);
+	}
 
 	/* If it's a COW mapping, write protect it both processes. */
-	if (is_cow_mapping(src_vma->vm_flags) && pte_write(pte)) {
+	if (is_cow_mapping(src_vma->vm_flags) && writable) {
 		wrprotect_ptes(src_mm, addr, src_pte, nr);
 		pte = pte_wrprotect(pte);
 	}
@@ -1112,9 +1142,6 @@ static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
 		pte = pte_mkclean(pte);
 	pte = pte_mkold(pte);
 
-	if (!userfaultfd_wp(dst_vma))
-		pte = pte_clear_uffd(pte);
-
 	set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
 }
 
@@ -5041,6 +5068,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (pte_swp_uffd(vmf->orig_pte))
 		pte = pte_mkuffd(pte);
 
+	/*
+	 * A page reclaimed while RWP-protected carries the uffd bit on
+	 * its swap entry. Re-apply PAGE_NONE on swap-in so the first access
+	 * still traps as an RWP fault. pte_modify() preserves _PAGE_UFFD.
+	 */
+	if (pte_swp_uffd(vmf->orig_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
 	 * certainly not shared either because we just allocated them without
diff --git a/mm/migrate.c b/mm/migrate.c
index 49a360fbcb87..9516cda35e34 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -329,6 +329,10 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	if (pte_swp_uffd(old_pte))
 		newpte = pte_mkuffd(newpte);
 
+	/* See remove_migration_pte(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(pvmw->vma))
+		newpte = pte_modify(newpte, PAGE_NONE);
+
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
 	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
@@ -394,6 +398,10 @@ static bool remove_migration_pte(struct folio *folio,
 		else if (pte_swp_uffd(old_pte))
 			pte = pte_mkuffd(pte);
 
+		/* See do_swap_page(): restore PAGE_NONE for RWP */
+		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+			pte = pte_modify(pte, PAGE_NONE);
+
 		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 7dcc94e7bfd6..cc85a8862c28 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -296,6 +296,16 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 	else if (uffd_prot_resolve)
 		ptent = pte_clear_uffd(ptent);
 
+	/*
+	 * The uffd bit on a VM_UFFD_RWP VMA carries PROT_NONE
+	 * semantics. If mprotect() or NUMA hinting changed the
+	 * base protection, restore PAGE_NONE so the PTE still
+	 * traps on any access. pte_modify() preserves
+	 * _PAGE_UFFD.
+	 */
+	if (userfaultfd_rwp(vma) && pte_uffd(ptent))
+		ptent = pte_modify(ptent, PAGE_NONE);
+
 	/*
 	 * In some writable, shared mappings, we might want
 	 * to catch actual write access -- see
diff --git a/mm/mremap.c b/mm/mremap.c
index 12732a5c547e..8a46ec5831c8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -296,10 +296,19 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			pte_clear(mm, new_addr, new_ptep);
 		else {
 			if (need_clear_uffd_wp) {
-				if (pte_present(pte))
+				if (pte_present(pte)) {
+					/*
+					 * See __copy_present_ptes(): normalise
+					 * RWP PTEs so the destination starts
+					 * accessible instead of taking a
+					 * numa-hinting fault on first access.
+					 */
+					if (userfaultfd_rwp(vma) && pte_uffd(pte))
+						pte = pte_modify(pte, vma->vm_page_prot);
 					pte = pte_clear_uffd(pte);
-				else
+				} else {
 					pte = pte_swp_clear_uffd(pte);
+				}
 			}
 			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 		}
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9817928c24bd..a6f19759e8e3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2498,6 +2498,11 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mksoft_dirty(new_pte);
 	if (pte_swp_uffd(old_pte))
 		new_pte = pte_mkuffd(new_pte);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+		new_pte = pte_modify(new_pte, PAGE_NONE);
+
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
 	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ec1880d18171..4fca0409b7d7 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1292,6 +1292,13 @@ static long move_present_ptes(struct mm_struct *mm,
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
 		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+
+		/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+		if (userfaultfd_rwp(dst_vma)) {
+			orig_dst_pte = pte_modify(orig_dst_pte, PAGE_NONE);
+			orig_dst_pte = pte_mkuffd(orig_dst_pte);
+		}
+
 		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 
 		src_addr += PAGE_SIZE;
@@ -1373,6 +1380,9 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma))
+		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
@@ -1399,6 +1409,13 @@ static int move_zeropage_pte(struct mm_struct *mm,
 
 	zero_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
+
+	/* Re-arm RWP on the moved PTE if dst_vma is RWP-registered. */
+	if (userfaultfd_rwp(dst_vma)) {
+		zero_pte = pte_modify(zero_pte, PAGE_NONE);
+		zero_pte = pte_mkuffd(zero_pte);
+	}
+
 	ptep_clear_flush(src_vma, src_addr, src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
-- 
2.54.0


