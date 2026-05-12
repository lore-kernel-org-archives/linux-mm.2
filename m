Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6B4CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561BF6B0092; Tue, 12 May 2026 02:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538A26B0093; Tue, 12 May 2026 02:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F2E6B0095; Tue, 12 May 2026 02:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3961B6B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:48:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1E9D1C0DF4
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:48:53 +0000 (UTC)
X-FDA: 84757840146.16.5E9545E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 11BC7140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:48:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXIV3apF;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778568532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ENo9gpPv9NCV1lJ12jOY0UtBog+uf+R02OhcCZpBhDM=;
	b=0ub17TOeuj10K3l1hiRavhjN46d0ME0vmoSDUvhasRgZCBh9msSLAuQLm1EAl5YRPj/qch
	VnBqs8m6mXFahwwuhA9zXdc1AMWy0aioUwZBqfvFEvE2q8NbQPanXFqeK0Ixk8aJumYvnr
	NeeEFI7hycMOowDjhphPgRSFWVJUICk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXIV3apF;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778568532; a=rsa-sha256;
	cv=none;
	b=5H9h1U1b6vLAaKdjeZxT7HJTJrsY1vl4upC+I4NS2DoXr/sW5f2gJ+lDP9q61PJ28RC8we
	30N+eLLiNxFoKm+LIEDxGgYhF0KIVFIXwPM3Lq86YCqU/BpLloUTT0lwR4h1JXAre+BCPM
	zfTDv8cbOHebD6pf+R2y7wvpFk4WMi4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D5E8F40263;
	Tue, 12 May 2026 06:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61E5C2BCB8;
	Tue, 12 May 2026 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778568530;
	bh=znGDfq/bJ1wkLHdJvnjCKiqpvwQQkaqjjb16iDxb1y0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PXIV3apFaDjZyXED5iKly1omTUB+j7+uTG8N0AEXXmIG4szMxGvHOGJvhXKMfajMq
	 wxD6uvJcSMQ1ylrb4bjecX0VUZLBZ0W2/oTL8lbeJiKkENf6XoAUEOyvJVw1IHituK
	 OrdJGdhe/tUf8fNAnDd6VLaumzn45ZZ70B/aE+mI7Tunu4X2aJKL4whsroD6qa/0FL
	 bIKBFjf6IroQSs2hPJyuEiSaqJIqXBE33PYQFuu2DDMHmrl3Yui4pjzlHSgJfzi7gx
	 5kJzv8jAqSLXx2HFuMbGWF0/i6XdtqLk1VZVX439ViJAEpCUYUmUJWgj+tE/rsyBZ8
	 HXmm1ZulcjYfQ==
Message-ID: <7a223c95-fcec-4ae4-9c22-f31c75e3fa93@kernel.org>
Date: Tue, 12 May 2026 08:48:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
To: Souvik Banerjee <souvik@amlalabs.com>, djbw@kernel.org
Cc: willy@infradead.org, jack@suse.cz, apopple@nvidia.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260511214020.208939-1-souvik@amlalabs.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511214020.208939-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 11BC7140009
X-Rspamd-Server: rspam06
X-Stat-Signature: zoff6i1xbdgfm144ffxifb9fibbu8os7
X-HE-Tag: 1778568531-424200
X-HE-Meta: U2FsdGVkX18dzwD6i005/0A4KU6VW4dHrUQgAKHbHS0CvNBTs2g5CCTMO+n9aUAuW4/rSea23HD6ZBL/UxiWukZsumUtv2axVNRiX2yLmKzOeEpW9EmDPs/KAsX7I7/2EsWFRRsMRXcbWsAgH9KExRVxek85K9Hf7X0EeeREDI9xLKlYVFgLsGUTI3wC8pIDp3hVBD7kg5Q0QXmgl6nRj3lmUbUxH/9a8XpVDKUHEJxb2B5OeK2mNLVajrmF4Mt7Et5B/684Yg2uUwP8YvSU5z6yz6Le3ArEsxHwHB/KPUIq4YFmKxHTzu/1O27jlt+ToojnUIMy8pQ4ud2JVa/EF3RUNKVjVDAipUvn5nR3tjEUuzALEiB1n0diIuZaiecMuUlDPRecclZDU+deotxUF6FeY7OVIzDbgNLCXB11XQUZG+qpjhX0gnbAgZMJnF9fbVqP2JRY59R/l0nOznPVYXyenH5Y6+kZASFxFIP8bJrD1mDMXbYMIXo65blEyF6+rZFNIgLOM7fwyee0TUoBi05osoHgJb1clsRaQIxCpylzF2EjJ0LPrc/KbYb/FikH54goPz8CG5eP3kIq9zvBFVYDB0M2AG44W+OeXGkrU4CkUT+zNqnmsHULyoy2I7KjlYvzDZM3/44fEgU1+rb1rPAB+/Sd7erv7BzriM5DDHAmc7qLzUD+fxw0JN0/xEo7LvduxDh8uV3hCU7L+vAEKyr+lDF6t/Yk9OR/f3bogodwTSFIRdwbF2u/cXvaE1ER2m50f25Jm/46uG/VVchFVDQeHiybWZ8NRdGPeQDq6RRCXu2AG7VeNjxBYqPdAckadLAXP8m6OkciugG9/J0TS9yr5Mv1IhFWYkZ72dxuL6QWT3OJXj8jK4kQkl9dQHPf1+Tc6hspGmmPAml99g5C0qfGmCVctcUCNNAZSSP1Nnp2IIDO8VgWb+kzzek4g0a5UkjRfMJ0D9iCDyNZDi3
 GOcz2cls
 1Q4FVEkwkxYfOYrw2rptgpPzJvRlRqxyAkazJ4NtiioBG+kYPb5WwagaNekFdhsFFbL4lqrol3xDBRfhs2y2D/+y7vDcOwFVvBVz6k7VWvrcsiNBWFkDluRWhhym2hsgMweDUBqKMLZLO+txiWj+qoQL6BQm9DuhGKyKtAeAJrQgoDdI5o3IT11l6NnZUCpUvvy6nxL4qmxrdNrP4uAheREXqQ5ksWCcgKD/DZQGfF459KYHmRs8Bhr/7eh8Mc/O9QY1E8SpaR9IzHI0WnRA/mFcSWocIBx6Qr+biNdj1anC6tUfZ1GGhGWRe8kKTMwjOdBdo8MJq2raBOFzANyOXjB8M1Vi5d1B5UuQsblJlg4LYEGrFdQ/1RdG/u/Pa4P9aywCjSFMqsrgAvuCQtxNREsNFMtzp9XSoHrmE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 23:40, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
> _compound_head() and performs READ_ONCE(page->compound_info) -- a real
> dereference of the struct page pointer derived from a bogus PFN
> extracted from the empty/zero XA value.
> 
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
> 
>   Unable to handle kernel paging request at
>   virtual address ffff_fdff_bf00_0008 (vmemmap region)
>   Call trace:
>    dax_disassociate_entry.isra.0+0x20/0x50
>    dax_iomap_pte_fault
>    dax_iomap_fault
>    erofs_dax_fault
> 
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in both dax_associate_entry() and
> dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
> which has the identical pattern but was not touched by the prior fix.
> dax_associate_entry() is reachable with a zero entry via
> dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
> new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
> dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
> dax_busy_page() additionally see DAX_EMPTY entries created by
> grab_mapping_entry().
> 
> The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
> either guarded or only reachable on real-PFN entries, so this exhausts
> the anti-pattern.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

