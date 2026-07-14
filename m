Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA5B3C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13FD6B0099; Tue, 14 Jul 2026 06:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EAD36B009B; Tue, 14 Jul 2026 06:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900F06B009D; Tue, 14 Jul 2026 06:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6217D6B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:56:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3322C031A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:56:04 +0000 (UTC)
X-FDA: 84987077448.08.978112C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10A77180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:56:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVCboPYQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2a0KE3nESMqZxaA6l2dQ0EDA41Z0UjF+K+SGxf5zjk=;
	b=xgwGjBgXXPV4t+N/8rqaQt1Yy8qJOKOu9k3skKIzntc0FZnxFf27kVzzEu1lPMnXj4lOjB
	GqJhHt6TLYOUfY7Vj9N/j8pzy/6RmfCKasNOY9zT1Mr4WTkluJoyoluaHxo/LiddXS41++
	pLBV0PI5nT6jJ4NT/Uk4if+CP3z+5Vw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SVCboPYQ;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026563;
	b=pA0qaj2j71WsTjUanZ73yVxX0NbsNZb++TLcBuQRdETGMvnzV7/bUDQ0JWRRXip0ITi27q
	ZXm2kxylWyGqD6MAS3l6SAXmlceiaJKKrif0gw6dDvAo3t1g/eSR79HlxM/NXV6I7yja2r
	jT9ijY90j6ZTAKWizthzxK/B/MPVaQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6171343989;
	Tue, 14 Jul 2026 10:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768711F000E9;
	Tue, 14 Jul 2026 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784026562;
	bh=h2a0KE3nESMqZxaA6l2dQ0EDA41Z0UjF+K+SGxf5zjk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SVCboPYQQhwjt1FcBVFT3LrF9qvX5MXkJ4mLsr6B1pkcUfrehPFqCnpbaqcBL9S8s
	 Y1QwugCQbDWyy3mfuSsw341hDpBthdLtnpmYoQHZhoyTOPhfXoAWx6YVst6F829bq6
	 yXuH/lAwu8SLixrxKTg4Yv5IP4rZf3yQbCSHSEocYTRpHxzhkZ+Ri+piDKZD1Vl57h
	 o+oNgLwUPEwhu9cPkc/J2LDhfnqNtQJxyGcr/7uf2nsxK0kZGGP5xzBMvnpzQ+XNSk
	 iqNQZWngNAMA91T8PWref3qXOdIehXkxRUdI9yKMtSfFEGZ/4jqT7kEe/U5Ro+tEMb
	 W+RPxECswLjjQ==
Message-ID: <d91892de-1814-4d64-87fb-2073c39e47a5@kernel.org>
Date: Tue, 14 Jul 2026 12:55:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: batch rmap walks during large folio migration
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: Karim Manaouil <kmanaouil.dev@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Kinsey Ho <kinseyho@google.com>,
 Wei Xu <weixugc@google.com>, Bharata B Rao <bharata@amd.com>,
 David Rientjes <rientjes@google.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10A77180003
X-Stat-Signature: mhwnc4ahre49xbnqphefhon3m1i4fz6z
X-HE-Tag: 1784026562-123900
X-HE-Meta: U2FsdGVkX1+ZhXztNWbbRgpUiYLz129WFzIC1JJ5Q2OMaMjJc2Dqh1pUjg6BuX23vymur+9p85s5yUpAGLJwlKmr08SlOeV0vLUu46w66OS/buePxDa2bV+9F1SX2YuFCkD4fc83U9XGJ7Gv9sHLFjtp9Z3BS9HQj9fRyqmTxXa6DCfpc6m8EZXlUc7Ki6XR16GSIDUqPkIh8LKcuSeBYnNiwR4n7qh2q7gp8NM/3axLEMSkcy2qKR3a8Igif28TSK/KNTmr4uAaJAvogHUAfxCpQUrFMi0WpXEtZxpkqkiS63R/xRIB4RGHMkBPD5oppKOqnfM+Nna/OlVuGTrIrzyk9KqBIhOtSOhRs+51mee7nXYUPmITp/YLw1WLmxVBl2A65A0EHw7B/JNNuCt+v/YZN1LR+rB2ryYByOGZMiNaB/TZLYuFTq5h79mxQ4lTU/yM5Ef0Jgufx05ecd0vKbL5RLIbV5xrs5uHTjEjez56APvekER1NZkuddSUqzywtLZn0Cm90HDFAg62AJMh43JoIx1tL1+TjxXO/RAnwVwQc6/cSXGKNGetYjQkKSnobGwS/56yBgp1WVP+1zX+ihhXFjzxCvV3NPCA/BPuR1y3MDz2iyiVE/FYlGTR6kG1XyX6/yFVRnYFmKf7IXbJyhi7bDIcRWVqQ6AEMh5eluMYcf8qO+uUE5ROszbBxP4vqdR+frdow0d7R1/igwhkx6QjJf64V6hwoW3iUi7/VJylMaFVfvafby+oXxCnVcwFcVOaA/K1YE+2J+E/d/C8FYLc2mKImIYd0yA+hjiaWg7awdEbJuRGMEyhRlWFKlsVRjjVXkAwUbQLuLO46pSAguYv+xJlLMyIJ6B33+P8T1w0HoGzR4xtASW4L01ThPKwnWNLo8UpRSozRyTnuGbuBDfDRuFQIiOvQt0tCUPt5STuLTccn6/3658Hx5Z10JdzV8adSVRa/qYplf2UacT
 di95qtdE
 TlQFWxU256cNiXnST26g3XrywxVRianm6bdfUtNAkUhNbtitEkhSP8Hh4psJx2ZWV/qTaPFIrBDzlOD/74kBnjll0jFd2cxnSuQMeLwq/BfR3AcswWNgCt0qa6BD20z3sJ2xoQa4NTb1Ai+lC7IgXtihib+66kGPVb3re/yCkC630TtRQ03DzEVb0NXCRZAIafS+V8O4mS144JE+GYgYBc1ww6S66vZ2ZVVvbCcUOFCdMjwilLj662KZhGaPYYwO0PURAQVNGsz6EReS9Skz1kff7JhZprUEwlZLlzxov6wOPD65C077kdiqhP7hvWBn3PCFt5Ce3zTvWPL2aqfLz6EOMjlpMU5Bysxs5MyuA9jr4XmVW9nBc/zfjcksOuTSrBcSrl+uA3zargLxrUQpGyCEMHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/12/26 09:38, Shivank Garg wrote:
> Migrating a PTE-mapped large folio currently walks the folio's rmap
> one page at a time. It does so twice per migration:
> 1. try_to_migrate_one(): Replace present PTEs with migration entries
> 2. remove_migration_pte(): Restore migration entries to working PTEs.
> 
> For a folio with N contiguous PTEs, each walk repeats page_vma_mapped_walk()
> and the associated operation per subpage of the folio. (256 iterations
> for 1M folio).
> 
> This series enables both walks to process a batch of consecutive PTEs
> that map the same large folio and do some refactoring and clean up on
> the way.
> 
> Performance:
> 
> AMD EPYC ZEN 3, 2-socket system (1 node per socket).
> move_pages() migrating 1 GB from node 0 -> node 1, throughput
> in GB/s:
> 		         batch-	        batch-restore +
> folio     vanilla        restore        unmap          restore%  restore+unmap%
> 4K        2.98±0.09      2.95±0.07      3.06±0.05        -1.0%    +2.6%
> 64K       6.16±0.09      6.24±0.08      7.80±0.08        +1.3%   +26.6%
> 256K      6.85±0.06      6.85±0.09      9.54±0.19        +0.0%   +39.3%
> 1M        7.06±0.09      7.17±0.09      9.89±0.06        +1.5%   +40.1%
> 2M       10.97±0.17     10.67±0.13     10.69±0.15        -2.7%    -2.6%
> 
> In plain migration, the folio copy itself dominate the cost, so these rmap walk
> savings are only partly visible end-to-end.
> When the folio copy is batched-copy and offloaded to DMA engine [1], the copy is
> no longer the bottlneck and rmap-walk batching translates into much larger gains:
> 
> This series + [1], DMA Offload on PTDMA (DCBM), 16 channels:
> 
> 		     batch-copy
> folio   vanilla      -offload(dcbm)  dcbm+restore   dcbm+restore+unmap
> 4K      3.36 ± 0.10   4.16 ± 0.18     4.10 ± 0.14    4.12 ± 0.13
> 64K     6.16 ± 0.47   9.63 ± 0.23    10.00 ± 0.33   14.63 ± 0.14
> 256K    6.70 ± 0.09  12.98 ± 0.18    13.52 ± 0.15   32.30 ± 0.65    (2.38x)
> 1M      6.99 ± 0.02  14.32 ± 0.67    14.84 ± 0.17   38.97 ± 1.03    (2.62x)
> 2M     10.74 ± 0.29  64.25 ± 1.48    65.36 ± 1.00   64.97 ± 1.75
> 
> [1] https://lore.kernel.org/linux-mm/20260630-shivank-batch-migrate-offload-v6-0-da95d7e8b8a2@amd.com
> 
> Applies cleanly on mm-new 10-07-26 (61cccb8363f).
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> Dev Jain (1):
>       mm/rmap: Add batched version of folio_try_share_anon_rmap_pte

This would ideally be based on Dev's series instead if including a patch from
his series.

-- 
Cheers,

David

