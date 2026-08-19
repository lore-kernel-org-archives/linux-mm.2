Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7876EC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 05:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A256B0092; Wed, 19 Aug 2026 01:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AF96B0093; Wed, 19 Aug 2026 01:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 151E76B0095; Wed, 19 Aug 2026 01:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7CF96B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:38:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 612DCA03B7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:38:17 +0000 (UTC)
X-FDA: 85116913434.30.ABD7717
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DF35A0008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:38:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QpkA5Fry;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787117895;
	b=NnVcVsQIpeDb5HTB1VhZQ+CJAD6w+MPMIhmk2ppKalMudhf4Z3RWIQ4zau0uf+c+Esq3Gg
	dK75EGBo4SAopiV3QOHm5YONVp41XqVkBEBPqjHoMsLN+qz1MH2ZQX+ynI59UZepRVVcOE
	YD6/bEI6u36UguVLJoqiieu0fLOwhc8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QpkA5Fry;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787117895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nintaBnRUwNQ6TlSDbjsUm//931WFaXBns/iE8Egu1w=;
	b=GGsCOMxKfKOzplrD+pf8IMN2uXlrwt1CT48na2QUIZSdyjErKh9ARM/r3uq6faXh4MSJF5
	vLi9wKYTt6GLKkRmDkFYFtmfnSgPRW93/0sQV1Y5fr/0L7HymoGexSiKT37ugJWFXlaibE
	fZ5yWKu+Zj9rVfbtwOqFgahUvwDD5GU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tC9ZBjdlWTbI7P5V6dNNdQlq3npjUWVt+l2SpesYvG0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787117890; v=1; x=1787722690;
 b=QpkA5FryOr2Bfia407kXSBjt31B3nXAPuHYMU/38Tl9ZUFROamapwACt84X7sqd5GzEbEgN6
 FunSv1CzT5N8EdWgBZNtebPoSfEFXkEC9sE7IqVWZkBQQTaW0ZxWaLCddwf2XlEPFiUEhzTUDRj
 5w0THr++fo0k7Iv8Z1xSyBpI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 1a377b22757d086f;
	Wed, 19 Aug 2026 05:38:10 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: usama.arif@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	baoquan.he@linux.dev,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	liam@infradead.org,
	ryan.roberts@arm.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	linmiaohe@huawei.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v6 06/12] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Wed, 19 Aug 2026 13:38:03 +0800
Message-Id: <20260819053803.15868-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260818131202.494754-7-usama.arif@linux.dev>
References: <20260818131202.494754-7-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DF35A0008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mzhq7ntfwsabk1eq97jhaiknmsgqp5aq
X-HE-Tag: 1787117893-919319
X-HE-Meta: U2FsdGVkX1/1cbFAFbjyrpB6VHC4JRUljPT2S1x3Mfz8hL9JQD3snw4M7OzziX0O4UsSKlMvCUkTgPF9JO+nQ1BxSD0CIJWqt+yC1toCTzC2+/hvs+EzcbQjCkl4Le5qJxUVolYQJ21LzOmCw32EKiUA21SL+ZxLDMuC5i2uXhHnqw2XueRnCqAeQjLWUAqz+EXMzTUwdN+0Cs1y0lvuEux7GZ3aKpo7Tg0VOHUQPV48YD8wQ5i5c8dO1fRaK/MmfljOn7ISeD6NdxRkStbt9f7GmgbxHCDcU2O15pYl9k4NCTGiIZBf7VoafVh6eBToo8DI5hDY0aHkv4d9Xci0Fe+coUwaJwzUMSeYEJR91n4s1hokNiLXnk4c9cOIzYj4enHeIifL/k0nBwxaF26pI5SfjxxSiBKJlqlKUKKonzjWFOTzfSsly6nDhFFIH1hfDj1qTn4GgFfkoGa5t5dEkQjDlaGUmOdm1NG+zZ1MhLAgS7dCdCwvoIo/lQlDAdRCIEkenFak4jndH91PIiyu0zTg96nJA0YT6lbG4AMRJIYCeMA5S5eB4x+mWwibUFyp6snIZyNGEw/QrIRDVqclACuNBRG+49y4mM8MMSDn/Z5bk+HSHjHNjzG0kYeds0YeBe3GuDshMPeTDSH9s/PTj3TnkrAx36oo8L8lpx/FpfAFaStbvCaywV180EhW/JuYrsVdeEIBCFhCnDrUxatdpzDNBqpRB340jYa7iaXV+jfOF4/F+in8tCy4FbcvNkaVErvJJ6ORLA/sNsGPdXUT+foWr1bAqTN+YtwpWfT9SQaC7cBgKeS3IfTfGhNFg93r+WbbOmhw0Ctg6tJ1L0+rHAe6Cn7Epe4NCEHomsJeC9o1H9s9o8tHFjbtEZSMt7K/C5AjWKrl9jqeV4X4QemLi6BN9yfaWdnaJHM3qcQlxEKFcnwqVFkPoRJid/AWolzqYC84L0jCDIDfNxtXOKR
 u+LoMWIs
 m/6XgNCBZyhEWIgyISZON2obm/aLzXlcR0bOB186jCI9m0OsXyr+BzYl4hhE6jb1TY8OdlQKlifCRe7KAo4dr0lEpOOzJIx/p3jsR+8EjNqANlWSrSj5A6T2io2N1GHMR3Z+YpBdCSlIa2Aui/KFyy2tHv0ILgt6Ep0o+kyCyvTTcM+S/YYAIIGL+EkVe9RuCnjmSl8tlgEWCrQxINCzydrhmgtwrIutp5xDNNIXaDfLOWY9MN05ksYjcAFcXwfTyZC5PpXcuTYuFHd2zz49Fz8rWbkUjQDveJm8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Miaohe

On Tue, Aug 18, 2026 at 06:09:47AM -0700, Usama Arif wrote:
[...]
>+#ifdef CONFIG_THP_SWAP
>+/*
>+ * unuse_pmd - Map a locked folio at PMD granularity during swapoff.
>+ *
>+ * The caller provides a locked, swapped-in folio.  Returns 0 on success
>+ * (PMD was mapped).  Returns -EAGAIN if the swap cache folio no longer
>+ * matches the entry or the PMD changed under the lock (try_to_unuse will
>+ * rescan). Returns -EIO if the folio is not uptodate or contains a poisoned
>+ * subpage; in that case the PMD is split so unuse_pte_range() can handle
>+ * individual pages.
>+ */
>+static int unuse_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>+		     unsigned long addr, softleaf_t entry,
>+		     struct folio *folio)
>+{
>+	struct mm_struct *mm = vma->vm_mm;
>+	struct page *page;
>+	pmd_t new_pmd, old_pmd;
>+	spinlock_t *ptl;
>+	rmap_t rmap_flags = RMAP_NONE;
>+	bool exclusive;
>+
>+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
>+		return -EAGAIN;
>+
>+	if (unlikely(!folio_test_uptodate(folio))) {
>+		/* Let PTE fallback reread each slot independently. */
>+		swap_cache_del_folio(folio);
>+		__split_huge_pmd(vma, pmd, addr, false);
>+		return -EIO;
>+	}
>+
>+	if (unlikely(folio_contain_hwpoisoned_page(folio))) {
>+		/* Let PTE fallback isolate the poisoned subpages. */
>+		__split_huge_pmd(vma, pmd, addr, false);
>+		return -EIO;
>+	}

Hmm ... can this miss a poisoned tail?

memory_failure() sets PageHWPoison(p) before taking folio_lock(), but
PG_has_hwpoisoned is only set later. Since unuse_pmd_entry() holds folio
lock across this check, memory_failure() can be blocked on folio_lock()
with a tail already poisoned, IIUC ...

folio_contain_hwpoisoned_page() then sees neither a poisoned head nor
PG_has_hwpoisoned, and set_pmd_at() maps that tail through a normal PMD.

Note that unuse_pte() checks PageHWPoison(page) directly. Should we check
each subpage here as well before installing the PMD?

>+
>+	page = folio_page(folio, 0);
>+
>+	ptl = pmd_lock(mm, pmd);
>+	old_pmd = pmdp_get(pmd);
>+
>+	if (!pmd_is_swap_entry(old_pmd) ||
>+	    softleaf_from_pmd(old_pmd).val != entry.val) {
>+		spin_unlock(ptl);
>+		return -EAGAIN;
>+	}
>+
>+	exclusive = pmd_swp_exclusive(old_pmd);
>+
>+	/*
>+	 * Some architectures may have to restore extra metadata to the folio
>+	 * when reading from swap. This metadata may be indexed by swap entry
>+	 * so this must be called before folio_put_swap().
>+	 */
>+	arch_swap_restore(folio_swap(entry, folio), folio);
>+
>+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
>+	add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
>+
>+	new_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
>+	new_pmd = pmd_mkold(new_pmd);
>+	if (pmd_swp_soft_dirty(old_pmd))
>+		new_pmd = pmd_mksoft_dirty(new_pmd);
>+	if (pmd_swp_uffd(old_pmd))
>+		new_pmd = pmd_mkuffd(new_pmd);
>+	if (pmd_swp_uffd(old_pmd) && userfaultfd_rwp(vma))
>+		new_pmd = pmd_modify(new_pmd, PAGE_NONE);
>+
>+	if (exclusive)
>+		rmap_flags |= RMAP_EXCLUSIVE;
>+
>+	folio_get(folio);
>+	if (!folio_test_anon(folio))
>+		folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
>+	else
>+		folio_add_anon_rmap_pmd(folio, page, vma, addr, rmap_flags);
>+
>+	set_pmd_at(mm, addr, pmd, new_pmd);
>+	folio_put_swap(folio, NULL);
>+
>+	spin_unlock(ptl);
>+
>+	folio_free_swap(folio);
>+	return 0;
>+}

[...]

Cheers, Lance

