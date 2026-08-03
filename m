Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAAB9C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F10A66B00B7; Mon,  3 Aug 2026 09:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8516B00B8; Mon,  3 Aug 2026 09:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A966B00B9; Mon,  3 Aug 2026 09:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B01306B00B7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:19:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 847C080624
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:31:39 +0000 (UTC)
X-FDA: 85059289518.14.207DA17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD51112000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:31:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkUiqspx;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785745897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nO2+a+U5X2MAvQbsGGv6KYHXpTk6ryoC8p6rvByqe0A=;
	b=s2KmXXunZHSbPSb57VV3M1OaIR9ksicWLl4zIu0dJqzXV4vxZCmulZFSHWSvEUlx4484sy
	xt5Z7GaZgGS3rkRY6dJ0JSjekhXNRKIHyVeVw1B/kg6GRNzXW3qiUhTrRLIETBlz1OxHmV
	1bhkeCT1ja94NW1QiksskOzt/HwXCVk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RkUiqspx;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785745897;
	b=qvRgPDJTJ68UBA7wU+USHijJe/SX3RmQG1duDYfZfbr0a6qsE/pJ7Aj4t49VUiC+K8icR7
	ajD7HFUKsA0Xaq+YOcLHx+qRr8wVBSLTfEtPaqND8i9zL/0gbkiBxgM13ii2Xba/Mw0Xn/
	Q/4SxZ7oh8ucKNdDz/tucJXpHB3LppI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E942F4122B;
	Mon,  3 Aug 2026 08:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056921F000E9;
	Mon,  3 Aug 2026 08:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785745896;
	bh=nO2+a+U5X2MAvQbsGGv6KYHXpTk6ryoC8p6rvByqe0A=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=RkUiqspxtqSbCoGEIXIa79A/9JHzcBLO4mDsu84Ulh3AapPhhU7jYex7bGWT+y25/
	 YeXp3ppKm08wY+FgRaUsherk27Np6+LTVFvpEZiQmJmKZByn0p5QwmCRRzHenlYuDL
	 v25VRPB0DbFBC0YM1/pIuPIJ0p1/IWDgenanRW9oSv4zQr7mvCOIdWXjRXSHhfvs48
	 GxPQwIoXOFUwO+yR8FTFESf8/1l4lmsr1dyZkmhDtjGCF1NI6zLy4ZgxafukY41W4T
	 7sbUWITikkk7BHDe791a3jvOPoi8tl/FmEEHO7DlBfKWNO0ItpKgilV0yd9HsviQxT
	 3uGBuEnjqfOYQ==
Message-ID: <f2eb26f4-62e2-4a16-a56b-706adf230cb6@kernel.org>
Date: Mon, 3 Aug 2026 10:31:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: TLB free bug in 4c640eb4181c ("mm: move pte table reclaim code to
 memory.c")
To: Andy Lutomirski <luto@amacapital.net>, zhengqi.arch@bytedance.com,
 "Liam R . Howlett" <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Linux-MM <linux-mm@kvack.org>
References: <CALCETrXbj__SFQMzPZhES5y6-sh4np-ZHY5T_=4QY5+Fn8BM4A@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CALCETrXbj__SFQMzPZhES5y6-sh4np-ZHY5T_=4QY5+Fn8BM4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BD51112000C
X-Rspamd-Server: rspam01
X-Stat-Signature: w9qog1qa5da81me1itd93gm4xargijn4
X-HE-Tag: 1785745897-32051
X-HE-Meta: U2FsdGVkX183k4IQyDsocSdxbxINtqoy+XZ7Uh+bixIMNMKiDu/TLEqJiSEZlTyM72AuUsREIClKt/HeUieOcPUo+FQj+m47I3whEvlrImIu2FMT9q8YJepBxhyDIt9z850ty6K/58MTzqYJ1cq+M2DS1uiRr5+PPA0IbVfMw45mUP+9kM6/hKz8nf4u06Ax0NHElLTLAeBzmg640W+1wIstfZobgd+zguuuNpr6GUWISoFUEGzQANR0o/2Ew9b0DVsspWIFz2mn+KjsjFmOlNcPzFmhGuAjzj+C2XpSe9D5Y4TZtBoFnTHwJNLb3xi1RznqJKl3RpWUGINa4ipC+OmYXNlKmzcVP841oxSr7m9KTxYE+V7y8B/43ukbMOGKLyo8mIECWIgfUpZUbLU/HT/7Bgf7HlvKpAZGjfQm8iAvPaBEY5GtwW8tAa7vC/8zjbgAwRZz8uum+F7w/mwgn2B9C11iOQUr6NZQ2qneUknAWPtzg4a04tTmqckap27N60gHvM0RYu4ySH2y/63vHGtFKujBRzfnGLIJ6IElvZD2w/gnvHp4bvo5bQ80lpNuqV+yb4uLsmoVoD3PsgWdAHDszfwmyVx0S3vE4f/e1dbCdQ8uDWZtLipTeVJWj6MP9Wh9fwpoJw22+UScWtZ16Bz1UtmioS3WR5u+uLAJcb26hQ30a8G2tI9Q4haJSLRwQkg8YowhS6an59oAdgtz9WZBobymJlAKJEUsutwAGreQrHsxiaE9QLR9ERPuJMAeIYyThylyQpPqBw0CuvE3htkV6J3+kk50wTcQ3kX4v/EYtYYDRl/qTRf54jrAye7by7azqmA8dIsUetWdBqGcZeAzsmrKa7SYdm1qkFXkgqCRd0h8aYalACKtRfqPERk8HraKnRV3a6VcHLIyFL6R8cFpIToggg0oDoAsqbBn5PYgANN268Kq3SGSav8ukfsa/x7uWlrjkcfP+DvtNJd
 zZc26Aqn
 hC7XYL8lIn+61xZ+QzyvwiTv6GilUECKAQ+81pZL8HAo2ZcKE0PWKXeq0I+rZsFTVM+QDhgkIBwXmXks0oGM1UCD2St9r5fUIZuQIgP3GeXLORYKGsQ5Kb/eW7zLuSMZzBBuwGiTZtFmlAq3Aac5tsbcfUL3hYg6wiF8CSSZiNbxuWO/ZNHGZU23qFpu52uiXwT2BGmOt6VukbO/W4O39Ce/039HIx4ZPBhapgRnGaPsC8TNX0MbVlPuBiSjOEvnEq67U5RkIKRjwH8Wb0Jpu8bTMgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/26 16:00, Andy Lutomirski wrote:
> Hi all-
> 
> I saw a fun bug report in ripgrep and a studious but pretty bad
> AI-generated analysis, and I peeked at the actual code.  I'm rather
> suspicious of this:
> 
>     if (can_reclaim_pt) {
>         if (direct_reclaim || zap_pte_table_if_empty(mm, pmd, start, &pmdval)) {
>             pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);  <-- what is
> addr here?
>             mm_dec_nr_ptes(mm);
>         }
>     }
> 
> It looks to me (and an LLM -- I can *never* remember what all the
> tlb_xyz functions do, so I asked an LLM for a summary), like addr is
> not guaranteed to point at the range being zapped, because the do loop
> above may increment it right past the end.

It will actually always point at the end, whereby the end is at
the start of the next page table :/

pte_table_reclaim_possible() makes sure that we reclaim only when covering a full
page table.

Subtracting "PMD_SIZE" from start would ... or just remembering the original start.

> 
> On x86, by my reading of the extremely vague text in the SDM volume 3,
> INVLPG doesn't care in the sense that (most of?) the code paths
> reaching this have already validated that there weren't any live PTEs
> in the page and INVLPG promises to flush higher level paging structure
> caches for *all* addresses.  But INVPCID makes no such promise that I
> can see.
> 
> So it kind of seems like this code might end up flushing the wrong
> paging structure caches, leaving all *actual mappings* in the TLB
> valid but also leaving a cached reference to the to-be-freed
> pagetable.  Which would be quite bad.

:/

> 
> Original report here:
> 
> https://github.com/BurntSushi/ripgrep/issues/3494
> 
> I haven't sent a patch because I *still* don't pretend to have
> followed what all the tlb_ functions promise to do, and I don't want
> to submit a subtle patch based just on an LLM telling me what *it*
> thinks those functions do.  I could trace though all this mess
> manually, but I bet that one of you actually remembers :)

The memory.c code is definitely broken. I guess the real question is,
what the effect of that is.

-- 
Cheers,

David

