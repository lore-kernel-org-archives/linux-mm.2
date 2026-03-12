Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F728106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 686576B00A1; Thu, 12 Mar 2026 15:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634636B00A2; Thu, 12 Mar 2026 15:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533266B00A4; Thu, 12 Mar 2026 15:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40AB56B00A1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:58:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE8978AFE7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:58:36 +0000 (UTC)
X-FDA: 84538473432.14.FD6D6F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA67A20011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:58:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fJn00l88;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773345515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5tDeaPNlH4FbdOApt/fipBfHit079U3MSkOKJpajvA=;
	b=4Xt3kbW1kG3fXoZG48o7Jy277RlpE3fsPIYRntW1gU9ak96dd5oK0nlKEYszN6hlEFZc7o
	9j68iYmqbZnsOUPU4IsQDgGDn9H513uQp35BKUkpPYjCS+PJP/QQa84aLa0g9osRdlU5up
	bK1omFeFeqD0J/h0dnxB/ZmzA7qx12k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fJn00l88;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773345515; a=rsa-sha256;
	cv=none;
	b=lpuS+vq1joE1k3Ky5Wky7QOeZUUy+WGmt8jTxOa23JG+gWhawagMKk+PG1LpYODkM4LOCP
	dNesfARTnOIh3j7IYP+XW3Mx56rYFAPgHbJQ7cbJvaqxRqrvkMrPt1T7HX01sOuoku3dw9
	MmYMR3hh90jzGXo6UlA9K48WnMqyKhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFF1343F1E;
	Thu, 12 Mar 2026 19:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF02C19425;
	Thu, 12 Mar 2026 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773345513;
	bh=2oAIBAbeD5lh0AmLKC7kBXJJ4zqW2tjxgJK2/n54DlM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fJn00l883ztTj0W6a4qKGBTVC4OuFVFH0jACQVcA/Ph1OECYYIL40jPNoxXYaSx+6
	 BoLGgJkVwTuw3r6m6XwSUBu4wXDID2H4TyJ8EBPplSRMPvdtR+rEzcLkuuerqdFqbV
	 ZpV1+P4TKMLt6Ro8eYpYBV2abAfYDuI5wMjU2H9dlCT9yR7fmj7XJ83nDGO2S4yjB/
	 87Zj81Psth2YSETQbC9odXcHDk9VMD+o77BMl/dlGFmB0V31dDl7Vz1kwhd9XleeCI
	 DTfhEZAZvqaXK+IUAXo5KdFASU5skkR1+Tz5S9BIuii+YfkygptYY2GEp5G2/RpJsx
	 QKbug7dh6Ii/A==
Message-ID: <76c5576a-65d2-4dde-a969-ef6577855864@kernel.org>
Date: Thu, 12 Mar 2026 20:58:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] Migrate on fault for device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA67A20011
X-Stat-Signature: kf14p5m7mogrifd3ss9sgyi1ww8mbub5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773345514-259180
X-HE-Meta: U2FsdGVkX18fxyEzO5kghCsfn6Me/7TWv3Gu1FzNO0EuCvNxmf/Qa7IQ+psctN1CeFDde2A+yNhtd1oEwySSmOQOmBwrNVX5MRMB+mBcj5NPKuZGRcTbQiaHm93lvhDWNiHI3npjFvOo2sdpYLMFrdnVSgAmN7WJPVF4RPPDlVG0jSCs92EmfwuT0STALjvUICUYuPvC1aZy4DHyHdyrmREHRAfApekZ7CehU7GG4fxt89zWM8QdNP9Vb4hQNPRS6Li+HaBnlXharhXs3JlnzUqi1eIMyHGvSQ1yN/LswTygs7ohHrgZgzbdCYL/HXk+YdWlcomFx871NJ6y90bTP5AtQur7gyBsWbqmnL76wslMxSWoqOibxjYjRHxWbk06/k20nUR9kZuxcTeEL8kvH+qUFxkKH3qGUPr+7kaU+jrzTVEryLM1LGk6WAyoX/Vy9niwe7WYyf7Dwwidth/3X6nssjRURCUMTQBPGByOukw6+soEv2RVyEYmbLHYeI+y4RM7Acivob1JRsnGuvxBBA3eRHF8yFQ/almhaXYV0ivnJfhp38EgcNN+w3RUyK9q9dR9FvlgliZWH2bPUpBZHAj71ScDMhzqaIjAYDNybQPnFNzPLXvQOUVg//cXGdo55gOTHCJ01+FEuiOXZj9+qvqYuxjbCjfaK6/GmBOBt5Iz3/S+SGbD42snjIFrxdVgfr2JMuFzvJe8AGqjHh8zfAmHVIR3aPjRymxJBSkxp077jrOe2iHDnV6pfnbK3AXPQ6/KuJvkJxfqeoBrPc9vzbEPETCaB0tfWB3SfUrVM0jveZ89/2i1zjddxSKj+/wZFFVGNLNyrpIYTW9WG/sLv8haPP4lsjzBP7vBQfw+IS7OIBsyzxMtrpZfqNVLZjjzGkx4pbtjME+RYF3RaNAsw9W/XMIynqC8i/Pph6Vbe1fGMKMFLkHGiHJvSBitQ+jgIjgA7QXdZjx9ATuttbG
 JJezR9oU
 DoCJF32dIg4GWKrpAWgtqq8yTq0ia55di+Q7EMrOnUHh50E18CZIzrMitRlII3C/iUgGojlzaTbqP+nzfE8gGtLptCSLkjSu/3H/THd7Z+3PVoUIRQPvaR6aQUujdQyGHDXGJs3wAcUvHLZZw4b6jULxp8hB8OFHriubqH6jpbiCvxlOAjs2sJu9OzAHKrgGtnIjvM7nnxumLZa+3ePEH8A+Ez6AHylyrvXPrYp2mbXFnlKLrSgRi1fdp3xegDjGTNQlzdkBNRibYfjanr8NcgVo1q0PmA6FSKSq0jisv+3Obp6bqxqwKZebc1Cd2Nj01QzT3HH18a6tCRw6LSKryNGg0p13E1HKrL+8A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 09:12, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> One extra benefit of migrating with hmm_range_fault() path
> is the migrate_vma.vma gets populated, so no need to
> retrieve that separataly.
> 
> Tested in X86-64 VM with HMM test device, passing the selftests.
> For performance, the migrate throughput tests from the selftests
> show similar numbers (within error margin) as unmodified kernel.
> Tested also rebased on the
> "Remove device private pages from physical address space" series:
> https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
> plus a small patch to adjust with no problems.

Stumbling over this in my backlog, so far we have to RB tags.

I'm going to take a look at the core MM bits (soon I hope), but it would
be great if other people could review the HMM bits and provide proper tags.

-- 
Cheers,

David

