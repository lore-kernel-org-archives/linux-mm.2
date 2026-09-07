Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 977FDC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512786B009B; Mon,  7 Sep 2026 06:15:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C49E6B009D; Mon,  7 Sep 2026 06:15:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4106B009E; Mon,  7 Sep 2026 06:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1437D6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:15:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AB7112072B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:15:27 +0000 (UTC)
X-FDA: 85186559094.25.8375B15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 819B71C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:15:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0MKkuWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXoDu1tMF/m4jQEGiGmHY63F0xkg8Ul6v/JOuBvCagg=;
	b=jWH6B5aMftCShgUYBRXYYbrWQcWvznrTWzHOVCQZ+XIKQV4LwGYuG+FbRbwGkpHJbrv7w1
	G8jeyxNtRfJm8fgb4OL6ziWkbtBJ0B8wnnkmjTTyMUkg8YvZBrgst267aL/IfYlu8CqxIo
	BeTKsyYZXlF/mzBG5lVjKWz9D34CqZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B0MKkuWy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776125;
	b=G6itT+nPMYr0r4uALU7Z8iZmPct8C2SiY6CFrPb5jlJTp0NqRKlByn9vuCFBpBw2DunaZZ
	cRSMr5cOyqXWlLket/3qnl/yG5QWZaCkD+rYupamzdIcRKuaW84XaBa1NFjwZo+TH/Opru
	uwn6gLIhAcg3eI3WaFciBJkwZLqQ4vE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FE534067B;
	Mon,  7 Sep 2026 10:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A981F00A3A;
	Mon,  7 Sep 2026 10:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776124;
	bh=uXoDu1tMF/m4jQEGiGmHY63F0xkg8Ul6v/JOuBvCagg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B0MKkuWyAkIty6BdiG/6Kws82Fw5TEuiwUGYU7WLDG67Fi6ZW4Dct4XfJ1soZCiMA
	 8UFaLk1hrxEEpmdoTpZajrzDVw2gowNTWygqZDuL8b4y94K8/8sW5s15WVhTEKpApd
	 BHzxDDWgXgGagpAlcgbA/zABdwF4t+rBeudPPfq25qB6Ve3jt5fptun+ET8wGxUqyo
	 +tRwrMpjEBFlTTXEDfVb/S3tHTUJr/Gu6mFn54gCaQ0sEI7rFlFdz/3jxdFTkQDsU8
	 L3YzVzuzkQYEbReNMP37b6z54NzkovspYwwqoG/LKxL9q0ku6V5xHqZDICeNjpcZQ3
	 +vS+vVbQX7ZQg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 518AA198003A;
	Mon,  7 Sep 2026 06:15:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 07 Sep 2026 06:15:21 -0400
X-ME-Sender: <xms:tI6eaioxSVOks1MJoD6R-S_Vh_AtHsMa35N6mp_0-Nbr1_L4V7hHuA>
    <xme:tI6eaju2Uv4uRwrT7B_E-oBjRS0NXseU9bAxuhla93TUHsh2Q70mDAYPpq3gr--8H
    xU0xzRXA3rghZMlqMNHqCg8w4er7jzW60mGawgK87L8BVzGLaAN9mVm0g>
X-ME-Received: <xmr:tI6ealS9cLRZ7cAiIsdk7xpwxZmm7tIDccAHHNesU6QwHDJAjJxDo-1jq1U>
X-ME-Proxy-Cause: dmFkZTFHFolurtLcJyg80wlpE3jE4As5ICevdsLw9Idtn5zhcahGdYV1d6mfesOnz7ojPM
    ytzhTab1V2GhnoGE1Cftep3BcFeYyX0YlfP4RU7WEC00zqBSEAY10lwR8q6VVL9j0Ys8no
    MTD/QXRXQNWCXlfNmtO0jrqDD3wszlDmafHT9AkWEkfheH+x9Vt3njf8EcVlrHDWB+wA8O
    uCS64qEvIb5A4F5wEyaUi/2/HjAZgeO5XE9Lw+CZifEc9aKV/igMWm8OrbrQFi/3xawyay
    dTVpNMntCM+OHerB41uHPJUCUxZf3tDWrBg4NTgw7Rozr3TlWpXPuatzWCuvHtlzLREhjF
    OsFMGvmM96qB2J7Q9z2eUYAFFGX4WapiC2NuJG5ILecaoUoq56hTapJ13PLvozI5SE6jL3
    7bkcbSsG938Ex6mZcGX82xm0finLo4F8q+PZwOwHl3d0oiwj/7t5fJjmB7tOAed7L/lyL4
    ZuRSWtiDAVa1MfXeDsBP/mA3nojlQTGCSFgb85XOQzWpN9IKCS8mi8KAcE9mvU36+gAASN
    E0TB0QAhKRhb8cJVB1JunYAQR7k6Qtp9K2OLyJ7cTx6VcIk/yBeVWDXm0HFpzsozwVTs9h
    Nouzqhdawo9IXzwzzIMJm6OX7PvNKVckNIMK2E38emiBsXOaT3ZKHQIPEi9A
X-ME-Proxy: <xmx:tI6ealVV0iXKK03Xc7ufXYAeW2v6_7dmWl-3ZMZ6RYmc39tWo__Crw>
    <xmx:tI6eaoDfHeUrKT2MYPHblQm8DFYXR-IwhbZb64EKZXq7GWVNmMVl2g>
    <xmx:tI6eavEKunu_m2YZgeGcFMkyBfuRJFGnqMDB1UBBv5aKPG5aMuaadg>
    <xmx:tI6eancfHl-JSXUfsjKZpilOvbQVDnQathOmNacC07Tu07tSVacG4Q>
    <xmx:tI6eard_QJtbsu3JuT1U4Ms5tvRxRsSBhg40qhA-_xsEc2rW845NgIfV>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Sep 2026 06:15:16 -0400 (EDT)
Date: Mon, 7 Sep 2026 11:15:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Boris Burkov <boris@bur.io>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <ap6LFvuOuWf_BkGi@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903182943.662461-1-kirill@shutemov.name>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4pwis51on1unmnhutszjtx8b7zuf5atj
X-Rspamd-Queue-Id: 819B71C0008
X-HE-Tag: 1788776125-443876
X-HE-Meta: U2FsdGVkX1+vL6ehstDVkqcolpmmfE1MBDFcxuV2SgZS1B+FmBasYkOdBPaApYiHQdzw/flfJp+6OWYYJ8Ui0KitwFiDLEbrxosbcoEm27ytlmlJ9tmE/bAHGisW2VguYxxvOg7OhdzuxmT2t7neeP7yyT6MO0ruNS6uHfbnozJnebPsTZkMJo3A+GvimnDjWekMjcNRW2LCny0l87yEjPtprBRUXBsGn44QzjKVIWPgOAjfe5LuTA6ZH5MV0tdFuTJz4ds8rbfZQAlSBQpOm2bxPKISAjERLODJqNFB4F1mn5f4LPS1G8YI65BPpysPi3L/q9tUfrWAGFvtIWaIjs0QsRZf7Z/+OjoehzxDEVl3ZmW8JLSfzzF5s9BcsrNju/JWEruAI2z1aHTjlT7OSyFPIDq9xvHqx+yuaO108ZLttg9qMw+VXUQs9RX3zCJLKmNzrdWiJLbxBW39Mw2uek79Oy5+aFDsEIiv5IetzaISCgZDM4fjcYcjOREIgzc/onDKFDi3Uhk18iNMLNnjQBZOzPa+WWiB71iNBvkaRmhqDYE1Sfx3sE3erGPq0xT4mwNrsxidUEiDa2DZNsOh5b6GBm892SU9TCrFkkhwtA3YP7ipIwbLF9gT+ISsiHV9z0vc1Pak3oM8X6fX5J5FV5NawGX7lWeAABRgdNw20M6/eLZSnRcOmZ26lwvWeja4JMKlriO276B2HQnBAbRRaDGXPtCeE6bxAXMpGhNaGWROzOswI1VRa+0Ahx8MSNLlFxlkWhnzoc/G7lntjYB85O8+uOSiwWIBUrLz0Kw8Hqzw4YnHX1G2lRn23EPNllDL4ZHPlu0NcRTpghuQn/3wtR0KtaCAPJezcmzKXjcVzR4j0Hc1ISb6xEES+hatllqxt9xGjUkuhu2pA3ajvzuqWUNdP7F/q1grS31Ar6rqdyKRe78PPpRq/I95MLpeQOnhkTMOrVjOOWl8696dEGF
 oXJ7O0ZI
 ivD9mMTpK1fVoNfIte55q3K2yl1X/mUIwgHXF3NZjbqeU99lvg5j/a9iXt2pnlZtWoDjGbJohCUHjUErzh70X/ddnEgZiPULSUQ1dR0OUgxTzBl3Bbx+8Esv/Rtc/EiEN/ii6a6cKYVU8naS+SyLpECWfI+g2RDXLB1u6BPJIE3p1XRug7ZK/x55L+SdnzyDFJoiFn+bY7kaHNkLTqi6wxczshmbH7iCMPB6nWZjB7F0MFiwgqnedPwdyXcbivS4HOTLax9/Nbd9aQO0T3IK80L8AwEmUxH3XME/ZZTWl9nUJ6z8M1Z4nn7bGwu0ebQi3OuI3SqeAREDaMQC6fm/tDe8IA1+UDc1G1WrRbbWms6ysxPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 07:29:38PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> A store through a shared file mapping dirties the whole folio. With large
> page cache folios that turns a 4K store into 2M of writeback: one dirty
> bit per folio, and writeback has no way to know which part changed.
> 
> XFS already knows better. iomap tracks dirty state per block and
> iomap_writeback_folio() submits only the dirty ranges, and the buffered
> write path sets just the range it copied. Only the mmap path throws that
> away, because iomap_dirty_folio() covers the whole folio.
> 
> Narrowing the dirtying at page_mkwrite() time does not work on its own:
> set_pte_range() batch-maps a whole folio writable on the first shared
> write fault, so the stores that follow never fault and never reach the
> filesystem.
> 
> So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> folio and throws it away. Those bits are the only record of which parts
> of a large folio were written through a mapping. Collect them there and
> hand the filesystem the runs that were dirty, through a new
> a_ops->dirty_folio_range().

Boris pointed me to Matthew's proposal to remove ->dirty_folio:

https://lore.kernel.org/all/aoyWln-Gt-yvZQkE@casper.infradead.org

I agree that the current ->dirty_folio() makes little sense and that
dirtying the folio can be bundled into ->page_mkwrite(), as they are
matched 1-to-1.

My proposal makes the distinction between making the folio writable and
making it dirty meaningful. ->page_mkwrite() allocates whatever is needed
on the filesystem side to track dirty state and drive writeback for the
*folio*, while ->dirty_folio_range() marks part of the folio dirty.

We can still drop ->dirty_folio(). A filesystem can provide
->dirty_folio_range() if it wants fine-grained (sub-folio) dirty
tracking.

A separate question is whether we want to avoid installing a writable PMD
entry for filesystems that want fine-grained dirty tracking. I have a
patch for this, but it deserves a separate discussion once we agree that we
want this for PTE-mapped folios first.

Any feedback?

> All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> it keeps writing back whole. Keeping shared write faults off PMDs is a
> separate patch and not part of this posting.
> 
> On a 512M file in 2M folios on XFS, storing one byte per folio and
> calling msync() wrote 512M before and writes 1M after, with identical
> minor fault counts.
> 
> Not addressed here:
> 
>  - Dirty accounting stays folio-granular. A 4K store still counts as 2M
>    against dirty_ratio and balance_dirty_pages().
>  - iomap_page_mkwrite() still allocates blocks for the whole folio.
>  - Filesystems without per-block dirty state see no change.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

