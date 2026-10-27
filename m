Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB24D606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ad0FHs9a
Received: by kanga.kvack.org (Postfix)
	id A2F986B05CF; Mon, 26 Oct 2026 22:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07656B05D0; Mon, 26 Oct 2026 22:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944106B05D1; Mon, 26 Oct 2026 22:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E0476B05CF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:57:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE5221A08E3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:46 +0000 (UTC)
X-FDA: 85366896132.04.E9C00FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 40AD240002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:57:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ad0FHs9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069865;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QLq/0Ywl9pK28bgKTQB2XoDfd9pUDB5TCp5lP/azKI=;
	b=Qc8EzdeOl3I0M+l75BYA/RCN/a+pNiyjhUlIpyQLNn7rf6iP8or6MuVqvp7NXO0JFDabNU
	Pk/ToIma2XbCb9lviZSYquuTCp4ecYjjEuiegePfaE5OzdlIvzoE5NwzWrNVnD/RwNxqvS
	9HvK4CeIybjy86xaaemOzhBbUfVYcL0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ad0FHs9a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069865;
	b=OZw5i3IGPD6O36u0oAFi1yqZt6VHQ9eGFgepYAaZdUuC0p8WIT6HVdbrLjmOmtEyxi8fnH
	Fc/JwBIO4dNzmRPYm75HoeQ8jL05FWSycPN6K5lGFjJOxZitS2t29IX9dRLnvQ4mx+JYux
	h4+Um5h3ezmXWrRGZmnQW66XSvyX9fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64D71438F3;
	Tue, 27 Oct 2026 02:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4F21F01825;
	Tue, 27 Oct 2026 02:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793069864;
	bh=9QLq/0Ywl9pK28bgKTQB2XoDfd9pUDB5TCp5lP/azKI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ad0FHs9a7MG/b1Am11vly5ptqrs7PhBVadgxVTeFfMH+lDchF/sfAh9GwKgno687W
	 Pe6x/lX77RhdFrNSjYidsACwb+woLEIzwtVVirBNtDyQNrxmzy/PIo3tRqO2tXpaJ8
	 9RYXXQmhma5iXphzOeQoIGSUBVl+NJdm8J520p3TI9mx1M6uZq1dRq07DnXRl7upoT
	 6FGKZthg83zMr71kcgQO5eWQpVdu0C3zrANQ7KtxfEvju+VPonDMHC4MSy2JOfhn3p
	 DYfV46YqlfumgHEguxIHdxw+Nj/Y+C/IchoVSsWI501rXo1I4GB5S6amx3eQ0lMIpf
	 Szab3ftddcrRg==
Message-ID: <sashiko-outbox-186037@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yuanhe Shu" <xiangzao@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: =?utf-8?b?SHVhbmcsIFlpbmc=?= <ying.huang@linux.alibaba.com>, "Kaitao
 Cheng" <kaitao.cheng@linux.dev>, vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com, tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn, muchun.song@linux.dev, linux-mm@kvack.org
In-Reply-To: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:57:43 +0000
X-Rspamd-Queue-Id: 40AD240002
X-Stat-Signature: rmwcwn3hcuwjqbwtgujcjymp7b8fbs49
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793069865-847134
X-HE-Meta: U2FsdGVkX19P75PiWTG5kwUH8GNhvOWw2bp+aW89AYocDmlLB2JtLRNlLSS3Pg4vIpUOb6NLFpCBJ0UPNadY1Pf8OA/Znz9CUfguhrRG2tQ/NsAtG19V2N8VPh2bwcJXygKnQb/8Xj7rqhjdw09753wB8ijCAae7geX7VG+do4kSfcPUochd2ahEOFGqfhojBtSK7BoD43M49XUex+OBZ1OtyoWGznRSKXjLtVJcK1GimzY1tldxAGIucEGnbIq7RtW3O2qCO9B1aYfYH9SI+Jgom0/0s5pwSyZUehsZc8c7hHLt6oG/SkhOiMBNalwMLgH/CI9V6n4GLDt/y6GSdqX0GetigoSlkhxLBHiuvTVBYVAmLvmHBir/izkXMmwj16oZlgIv3XDaY8kNzZkpWviKTZbdkNV6B5Y5ae3fz/2WKK7fYVLG1cmFUNi+bh0DYKWHSqKPXZHVekrDIIi3UPn6h0l6jDNALUTD+V+56DdLX+O/vzjBT1kvm24TohFlOY8qPNDR2D1cL3028cNf7iXw1BEgO/k6CqZDskoDamkDf/sYW2IpztC/YSp1jh1sBwpbXGNcsrEGg/GsjCDMZR50XXOlkzHx4euYxNni9deNDKJ6ozDZ/YVvnPXyujg+sBY9XKSc2ouns1a5Fas+pSpolQnKGrfC9kIKyZhZR/YiEJJhsCbC1WBL39upRv0uOnZPf7IHk8qW8qv/abQnz7hExIEmYN47V9Ll4GJdklXFSLFQHwUgKcnirVMT1N//7/AbyKRofRIzo8h7QN6QE+kd0wcqwJWfvqCGNKGl8/chgLpooSf8hdjH7avGpGtADbO4wUaWmj0E7tzor58fhvPnmYZCRXJNFNC4ls00ZdxfJAvu6unlQUfmdh4Yx0poZ70Oz4ltJexuWUqeCm6Pm8P+0MPegdZockbfFRvn61pE3K1Jo7wHHuNGyWmGmREHaiXIeUvnEH/CKO2aeBU
 Dw24MB3W
 tasAaqh2d4EZO28lJUBIq0h44/D1qLAEocMwmzmHQOo7I6mHOaKCk8xu4qhOE77uuiBjowul7EKyG416SoKzFSB+TSCiRmGzsLgYDTBjGnvPBbIw8GP6pqFB51WKD/rGpL1QLk5l0m/sg/Z8yKd13sj+VzOxqW/OQIv2c+FCT+7o2xUbyertmmrD4YcgIFZFyVLycvBVU0TDMcDefBeRuQ+3jXam+SAtjEh9+TISX8UDuFiOBkbAAXJxrKCVSeKNjuhzakakabz+CCKvxf3Gt/Ya8EpXMvN+Yw7ulHweLc2nip1vUQpEOixxR2rK2nJIWAQGTWdNcm1As63ZBP1nafjjN3XOuLPbyLN5Lno6iMwqtpsXRU+8bUfnFFEhsEL1g9eWT3Mfo9tJ2YsML6yd6hRpOqF0C5Gd2TFfCV9hIId0wrugJI0RFlF0+NxYw0/2CIeJ7jk6m9SiqaLgMRPNe2yXujsxQXw8kAad5RFHxGpPQPr2gc5hEF/9CW8Pt0DLSJtAAC/LkafiPZxbAkUbvmDwc3vRBgrqUcXqL0iTJRaDYZKDyEIGGQXcvcCHgAGMlfpVnMK9TK9khp9r8rPICeixbUycW9UX3ZAmPYqduylVTk6jFqQaKl0KYsuKspkPrjV9KG449AbsiLh6Ywg1trZe7zU2BFlQ7UO4Oj8KU19tFH+A3CXUuW23nOFuPJxQdsvnN18UdudsQRsxSghuNBSXhg29LgWNvTZo6eY4mRplH3JjIRt7cOuU+rwChcrtnZZDQ2x7TfImx+uQ/AH7PY1aHMgycRdcjl5eBj+Sb1IXlLxjHchQXszMd7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm/highmem: wrong hwpoison granularity in copy_mc_*_highpage()=
 fallbacks
- [High] mm/highmem: copy_mc_*_highpage() reads poisoned page before flag c=
heck
--

commit e960425b93cf423ea993320abfce6ba212a1b8fe
Author: Yuanhe Shu <xiangzao@linux.alibaba.com>

mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks

This commit updates the !copy_mc_to_kernel fallbacks for
copy_mc_user_highpage() and copy_mc_highpage() to check
folio_contain_hwpoisoned_page(page_folio(from)) after copying the page
and return PAGE_SIZE if set.

Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/

> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index d7aac9de1c8a4..f90f0c6204a4e 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -474,12 +474,21 @@ static inline int copy_mc_user_highpage(struct page=
 *to, struct page *from,
>  					unsigned long vaddr, struct vm_area_struct *vma)
>  {
>  	copy_user_highpage(to, from, vaddr, vma);
> +	/*
> +	 * The flag can be set while the copy runs, so check after it;
> +	 * a flag landing later can no longer have corrupted this copy.
> +	 */

[Severity: High]
What happens in copy_mc_user_highpage() and copy_mc_highpage() if the
source page already has PG_hwpoison set from a real hardware memory error
before the copy starts (for example, reported earlier via ACPI APEI GHES, a
patrol scrubber, or a prior user-mode fault where memory_failure() set
PG_hwpoison before locking or unmapping the folio)?

On architectures without copy_mc_to_kernel (such as arm64, riscv, and
loongarch), copy_user_highpage() and copy_highpage() map the page with
kmap_local_page(from) and perform a plain kernel memory read via
copy_user_page() or copy_page() without exception-table recovery for
hardware memory errors.

Callers such as folio_mc_copy(), wp_page_copy() -> __wp_page_copy_user(),
copy_present_page(), collapse_file(), and __collapse_huge_page_copy() rely
on copy_mc_user_highpage() and copy_mc_highpage() to refuse poisoned pages.
If the check only runs after the copy, won't reading an already-poisoned
physical page in kernel mode trigger an unrecoverable kernel-mode fault
(such as an EL1 synchronous external abort on arm64) and panic the kernel
before reaching the post-copy check?

Should both functions check whether the source page is hwpoisoned before
the copy in addition to after the copy?

> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;
>  	return 0;
>  }
> =20
>  static inline int copy_mc_highpage(struct page *to, struct page *from)
>  {
>  	copy_highpage(to, from);
> +	/* Same reasoning as in copy_mc_user_highpage(). */
> +	if (folio_contain_hwpoisoned_page(page_folio(from)))
> +		return PAGE_SIZE;

[Severity: Critical]
Is folio_contain_hwpoisoned_page(page_folio(from)) the right granularity
for single-page copy helpers like copy_mc_user_highpage() and
copy_mc_highpage()?

In include/linux/page-flags.h:

static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
{
	return folio_test_hwpoison(folio) ||
	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
}

Because FOLIO_PF_ANY is 0, folio_test_hwpoison(folio) only tests
PG_hwpoison on the head page (&folio->page[0]), not on a tail page passed
as from. For any tail page of a large folio,
folio_contain_hwpoisoned_page(page_folio(from)) relies purely on the
folio-wide PG_has_hwpoisoned flag. Doesn't this cause both false negatives
and false positives?

First, for tail pages with PG_hwpoison set where PG_has_hwpoisoned is not
set, folio_contain_hwpoisoned_page(page_folio(from)) returns false and the
poisoned tail page is silently copied:

1. In mm/memory-failure.c:memory_failure(), TestSetPageHWPoison(p) sets
   PG_hwpoison on the target tail page before get_hwpoison_page() and
   folio_lock(folio), while folio_set_has_hwpoisoned(folio) is only called
   after acquiring and releasing folio_lock(folio):

   memory_failure()
       if (TestSetPageHWPoison(p))
           ...
       res =3D get_hwpoison_page(p, flags);
       ...
       folio_lock(folio);
       ...
       folio_unlock(folio);
       if (folio_test_large(folio)) {
           ...
           folio_set_has_hwpoisoned(folio);

   Callers holding folio_lock on the source folio during the copy -- such
   as migrate_folio() / filemap_migrate_folio() / __migrate_folio() ->
   folio_mc_copy(), do_cow_fault(), collapse_file(), and
   __collapse_huge_page_copy() -- block a concurrent memory_failure() at
   folio_lock(folio) after PageHWPoison(from) is already set on the tail
   page, before folio_set_has_hwpoisoned(folio) can run.

2. If memory_failure() (e.g., via debugfs corrupt-pfn without
   MF_COUNT_INCREASED) hits a tail page while a large folio is isolated
   from the LRU for migration or khugepaged, TestSetPageHWPoison(p) sets
   PG_hwpoison on the tail page, get_hwpoison_page() fails because
   HWPoisonHandlable() returns false for !PageLRU, and memory_failure()
   aborts without ever setting PG_has_hwpoisoned.

3. When CONFIG_TRANSPARENT_HUGEPAGE=3Dn and CONFIG_MEMORY_FAILURE=3Dy,
   folio_test_has_hwpoisoned() is compiled as FOLIO_FLAG_FALSE (always
   false), so poisoned tail pages of large page-cache folios are never
   detected, and mf_dax_kill_procs() sets PageHWPoison(page) on FS-DAX
   subpages without setting PG_has_hwpoisoned.

Second, for a non-hugetlb large folio that has PG_has_hwpoisoned set
because one subpage is poisoned (and could not be split to order 0, e.g.
due to extra references or min_order_for_split(folio) > 0 on a large block
size filesystem), unpoisoned subpages remain PTE-mappable and accessible.
When a single-page copy runs on a healthy subpage of that folio via
do_cow_fault(), wp_page_copy() -> __wp_page_copy_user(), or
copy_present_page() during fork(),
folio_contain_hwpoisoned_page(page_folio(from)) returns true and fails the
operation with VM_FAULT_HWPOISON (SIGBUS) or -EHWPOISON even though the
copied subpage from is not poisoned.

Would using is_page_hwpoison(from) in include/linux/page-flags.h instead of
folio_contain_hwpoisoned_page(page_folio(from)) avoid both problems by
checking PageHWPoison(from) on the specific subpage being copied while
still checking the head page for hugetlb folios?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026025724.1430=
747-1-xiangzao@linux.alibaba.com?part=3D1

