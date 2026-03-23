Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F970EC01BE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D116B008A; Mon, 23 Mar 2026 06:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9749F6B008C; Mon, 23 Mar 2026 06:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B16E6B0092; Mon, 23 Mar 2026 06:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4E46B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:34:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D99D140B1D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:40 +0000 (UTC)
X-FDA: 84576969120.11.778484E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5A8C2A0016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:34:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=RgGuuyeA;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=JI6xEh+OMSILlSiOxNxPrUMrO1zShMBF0bdq81hsKYI=;
	b=7/VO+56lVgySykE/QO/GGapl2c6mjS+PSrRXPkUuM0l3fjMXkI1mhvp9tcJ45Lott7FVwx
	9mvH2v5IYPShJPBhRexGLUSg3JiKQRhDipt1wGtbg0GD/Rv/RQxqO4OOluBfvWrj82xxko
	YUO/TOxzGWvfG03M+/+R4WWNpl+KOKs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=RgGuuyeA;
	spf=pass (imf15.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262078; a=rsa-sha256;
	cv=none;
	b=Y5MojazuCjcKAwqZByHERannieRR0INbZHzCpKP1K1XppvVusEnxPeU0pxZBHOZDjwKDzO
	7nvIdU1Bip4wb47xPkfXA8LDt0ldUJtNZkS5BpJ1bFQunYwkBapMh0cMCjdabQ5o29BN1f
	oZEZ2b5bzfTK3HT2s1kVrKyr4EfrWE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D45E442C2;
	Mon, 23 Mar 2026 10:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3F6C4CEF7;
	Mon, 23 Mar 2026 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774262077;
	bh=vFWwqbCSOE+WKcldNnjnwqia5vR3kJxApc4iuUZxSmc=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=RgGuuyeAju1+WjxGViOZRXQQ8OsrydME8pM+EiYA794w9t7xA89d4y3wqTRjO4RY1
	 5ywO/XUaPqe5M1nvELdfzn6eA3FJbn6K/H/t20xhwawPw09EsjFFS5ObfRzDFs7sAb
	 RAk2FYIBG8ZLzYUGJW5igFcz+uPePq/rQ3Ihes1g=
Subject: Patch "mm/shmem, swap: avoid redundant Xarray lookup during swapin" has been added to the 6.12-stable tree
To: akpm@linux-foundation.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,bhe@redhat.com,chrisl@kernel.org,david@kernel.org,dev.jain@arm.com,gregkh@linuxfoundation.org,groeck@google.com,gthelen@google.com,hughd@google.com,kasong@tencent.com,lance.yang@linux.dev,linux-mm@kvack.org,nphamcs@gmail.com,shikemeng@huaweicloud.com,willy@infradead.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 23 Mar 2026 11:34:05 +0100
In-Reply-To: <ebffe1a4-f575-8a38-2584-70cbfeda6913@google.com>
Message-ID: <2026032305-cassette-faceless-e778@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Stat-Signature: mtm8t3xampy1oj5i6jt6qpg1azfemctr
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A8C2A0016
X-HE-Tag: 1774262078-684981
X-HE-Meta: U2FsdGVkX18ja6YCVX0L8ZsudCe3fnUCVt9VAs3fUyh3p7I8CdFxdfC+KcVwSppHaJJLd4PkSkxZzedslHUHBwAzOAHz4XChzvTgjdd4r6loajurWlWfDeW6I+pF61IGLGB0Upb+U06d8NQIM/HQ2+VStJbSRYpftxE/5S0447/u49WRNipsDOfyvtEl3SMCMCU11K2XOz/PYKSxBnO485HcSQ8FSThI/8x9Vp2+b+HmLbNOdY7FxJDo5qNUsA0JNJMSIrcgvcoWbghecBfFNC7QrgI0/mqhYU1W4cLXakZYDHsqwjxJz1LUL0uwWm9/kTcVN8UaLbzxQQfg0tJKhfQ5C+CgWHq4A4WgtUH/RqQJB1PG2mgvRlmLsCslSIpeK1d0e64xV00v/k/XfC3y4guUXOvMOD3o8izgOdFRJmPPCYrN72iCgyZUvPYzJrhIkFkaMsCrp7IZUx/xy2Knt0X4tpC/5Mw4EOvWWaQcYu3dmiKPJPAZf+IjCiZGmSMRUY1PxQUt9G7M97Hsc7v/Xic+DQQWMlvo3NKV8n4U2xodjbkxaDvd6l3AE/H7ryiRdSIgUyAwAylWMTxc9IoJkcxAp5vvo3YUjNaeMCkl7TD5/rrthsKczlvTH7w6e3jmbDydEFGAXN0bOSJwZwbI9VPqTZX/KWZ44zRRRg/xZAO21eSYff7tGKcOaxIfMfZGTGnoNCssl9dnExZNLjZfhqwaZyxW91YqlW+1wzR6gONYdxdtbLvjVF5j2Znxlw0gdg/CQyyDM2NX03tiwx7n5DZDVIWDPSMr1xo6pC7JVAuvb8VaayO6ur7t03+QWBb8HddKWOvocdx8vaxpjWNadmE4Ct3ORMBjXCW97/ASeOIhIuMf/Xw5pkZcf22aerisgrfMOSrB011xjQ+HnuOgcy9ti67L6HQV46kLORZuIKc9Ei0H34MbjQ6kOlVCxIZtnSqBtm9mRro7dCmoPBS
 zrvGvyw3
 etKS7jeHqFb0GafHRviS1fzW+JQabZEnWbInb2XFnmRCEymJY4ho9BfF3srglYdNTf8KkxvvcJKp/pccVGeJWBbXcMPZuyKgtgu0Z+uOGyrhTW6h25oxFGmwjG9lVmMGsAWwjRM24uytzAlMfNt6x5Rw1VuV7dvMlsqV51fmHSR0pze28QOk164K10Yd2LgrpwqrrfALn33FZfcDN2PCm3Q0EJ/GNphu7JpfoZiJMBuLAPjnYMI+S0XOKNajOCgkCKn+J3aFEUEwwzRD/jbFCiBeOupE5MUROWdV4DjT/S1dduzW67sgzBsU7qLjGm2aaeMhfSfgXwrtjtuGndwrOEgey312Gj9pv6mQQHmJAzXVpuX99mF/kDfy06hIlJvCukRkgp0118YABLs4PMB5UFJHnNtg3rzags76bQ8o0Rp5xwZe9iLUh2lbLlYz9OhNcI7iNug++qE2ZCrzcn+7/QaON9fxs+0ef5RcyfQnVi7iOKQn6Udu0WqJVMGljWbCuzRpu+VSJxGJCFBvrDi0E8WgNyJFoKu9BgZejK4DtJcRxPxjdrd2TvnRVLofU+HSA1DCPAnaTb51bexPvwu6puH/ofifctX7RJC7lcqpG3s1p18soQ1CF9SXl7ZK3+8BhXsUlFpio1bxreKTzJm5PPkRaoYz99gcd8fBaOoklFlhGC0iDE3pRmfEE1QrkghkMGZ/nyaNpaPDmDHz3VSvDgG7sKIH+3cMLQYLIFEXoftvCE/FdxSTnAjyW8+JlBjlG0a9kfTZ2K4/VikYu+GXERge6pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm/shmem, swap: avoid redundant Xarray lookup during swapin

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-227935-greg=kroah.com@vger.kernel.org Mon Mar 23 10:43:43 2026
From: Hugh Dickins <hughd@google.com>
Date: Mon, 23 Mar 2026 02:43:31 -0700 (PDT)
Subject: mm/shmem, swap: avoid redundant Xarray lookup during swapin
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>, Baoquan He <bhe@redhat.com>,  Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,  David Hildenbrand <david@kernel.org>, Dev Jain <dev.jain@arm.com>,  Greg Thelen <gthelen@google.com>, Guenter Roeck <groeck@google.com>,  Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,  Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>,  Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, stable@vger.kernel.org
Message-ID: <ebffe1a4-f575-8a38-2584-70cbfeda6913@google.com>

From: Kairui Song <kasong@tencent.com>

commit 0cfc0e7e3d062b93e9eec6828de000981cdfb152 upstream.

Currently shmem calls xa_get_order to get the swap radix entry order,
requiring a full tree walk.  This can be easily combined with the swap
entry value checking (shmem_confirm_swap) to avoid the duplicated lookup
and abort early if the entry is gone already.  Which should improve the
performance.

Link: https://lkml.kernel.org/r/20250728075306.12704-1-ryncsn@gmail.com
Link: https://lkml.kernel.org/r/20250728075306.12704-3-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Stable-dep-of: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
[ hughd: removed series cover letter and skip_swapcache dependencies ]
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -499,15 +499,27 @@ static int shmem_replace_entry(struct ad
 
 /*
  * Sometimes, before we decide whether to proceed or to fail, we must check
- * that an entry was not already brought back from swap by a racing thread.
+ * that an entry was not already brought back or split by a racing thread.
  *
  * Checking folio is not enough: by the time a swapcache folio is locked, it
  * might be reused, and again be swapcache, using the same swap as before.
+ * Returns the swap entry's order if it still presents, else returns -1.
  */
-static bool shmem_confirm_swap(struct address_space *mapping,
-			       pgoff_t index, swp_entry_t swap)
+static int shmem_confirm_swap(struct address_space *mapping, pgoff_t index,
+			      swp_entry_t swap)
 {
-	return xa_load(&mapping->i_pages, index) == swp_to_radix_entry(swap);
+	XA_STATE(xas, &mapping->i_pages, index);
+	int ret = -1;
+	void *entry;
+
+	rcu_read_lock();
+	do {
+		entry = xas_load(&xas);
+		if (entry == swp_to_radix_entry(swap))
+			ret = xas_get_order(&xas);
+	} while (xas_retry(&xas, entry));
+	rcu_read_unlock();
+	return ret;
 }
 
 /*
@@ -2155,16 +2167,20 @@ static int shmem_swapin_folio(struct ino
 		return -EIO;
 
 	si = get_swap_device(swap);
-	if (!si) {
-		if (!shmem_confirm_swap(mapping, index, swap))
+	order = shmem_confirm_swap(mapping, index, swap);
+	if (unlikely(!si)) {
+		if (order < 0)
 			return -EEXIST;
 		else
 			return -EINVAL;
 	}
+	if (unlikely(order < 0)) {
+		put_swap_device(si);
+		return -EEXIST;
+	}
 
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
-	order = xa_get_order(&mapping->i_pages, index);
 	if (!folio) {
 
 		/* Or update major stats only when swapin succeeds?? */
@@ -2241,7 +2257,7 @@ static int shmem_swapin_folio(struct ino
 	 */
 	folio_lock(folio);
 	if (!folio_test_swapcache(folio) ||
-	    !shmem_confirm_swap(mapping, index, swap) ||
+	    shmem_confirm_swap(mapping, index, swap) < 0 ||
 	    folio->swap.val != swap.val) {
 		error = -EEXIST;
 		goto unlock;
@@ -2284,7 +2300,7 @@ static int shmem_swapin_folio(struct ino
 	*foliop = folio;
 	return 0;
 failed:
-	if (!shmem_confirm_swap(mapping, index, swap))
+	if (shmem_confirm_swap(mapping, index, swap) < 0)
 		error = -EEXIST;
 	if (error == -EIO)
 		shmem_set_folio_swapin_error(inode, index, folio, swap);


Patches currently in stable-queue which might be from hughd@google.com are

queue-6.12/mm-shmem-swap-improve-cached-mthp-handling-and-fix-potential-hang.patch
queue-6.12/mm-shmem-avoid-unpaired-folio_unlock-in-shmem_swapin_folio.patch
queue-6.12/mm-shmem-swap-avoid-redundant-xarray-lookup-during-swapin.patch
queue-6.12/mm-shmem-fix-potential-data-corruption-during-shmem-swapin.patch

