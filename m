Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF887E81A3D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F266B0005; Mon, 16 Feb 2026 10:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156CB6B0088; Mon, 16 Feb 2026 10:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C026B0089; Mon, 16 Feb 2026 10:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52A46B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:53:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 730D58D2C1
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:53:38 +0000 (UTC)
X-FDA: 84450764916.05.173FC01
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id C56AF1C0010
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:53:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TatD1DQJ;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771257216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3bkMbPVQZ0imzoqz791Opp6HhgWaEqfZv7eOVmBf9Y=;
	b=WXW7k/Kh2JF9oMxE9R5/wtWwNHdvIMghOTUtwhu37N9DBOpgNITkFS/TljieKldIEj4U6A
	lIMcyARLwzLpEcfnuDI7PAYZG6t4/mYu9bTbcl5OsPy+U5yBDeSR7jhJAezC+23TyTZUII
	tj4rxt0SupDf/LLKrBD17wqiB9yits8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TatD1DQJ;
	spf=pass (imf20.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771257216; a=rsa-sha256;
	cv=none;
	b=m7jl0WnreLX7Bj/DRN9XJI40A5Eqa/5ORf82Se4Jeu12HzvIOFYrzANCKBuImle9c28tGE
	LKLWVVt+VxnBKAVk0WNgd2FIEZTcX4ztOK4JjpxqEP8XeD5Q0rTn2QRtsqhCDp/9Gj9gA8
	C9m0hSw9vQKDyoS1PPhosRl9TGOgJ1Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771257216; x=1802793216;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KeYACCgUQAQm/5RNYJtj6lgt52CuskhiILUqay0ToN0=;
  b=TatD1DQJbj92wgY0YYPQsBeDpUgtlm9BPXA1NYICyJ/66z77VGc5AZl9
   7C3MwW8EIUxep66q0iQvLvve5uz7M5/hpZfXDB11Qywnm2km3PKYQbzdI
   1EBPHiC9AsI4NYSV1MVi6CIcKh7nZefTbtTDbhZ0FEFQgnP8qtgDJt4xX
   dyd1P/YcPTZh8zRwldx4txiiF7yOxY1GibbyFwSYshBIRT3Hqx1rRmtce
   u/OcDLaHWS7HFhJN3wJ2AbIIwMUc5F0QHkoaQ2y734nKT0ewH73Le3vzy
   xIsV4TQ9RlHXWmM2INqzSCI3n7Sl1FG8HszrmSc/ZzF8bsEolB71E2nw3
   A==;
X-CSE-ConnectionGUID: P95pb6vfSkCdR7HemG6kfA==
X-CSE-MsgGUID: 5jJ3lRhHSHyqisio55WGfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72434472"
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="72434472"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 07:53:34 -0800
X-CSE-ConnectionGUID: sTdObpXVTum2Mt/1uIDB5A==
X-CSE-MsgGUID: Tf6TTdHwSRiELgLXug197Q==
X-ExtLoop1: 1
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.109.103]) ([10.125.109.103])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 07:53:34 -0800
Message-ID: <6a43f009-335f-44de-a48f-f48ee1e912d0@intel.com>
Date: Mon, 16 Feb 2026 07:53:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
To: Mike Rapoport <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
 linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Moritz Sanft <ms@edgeless.systems>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation> <aZCaE04vDpf2hDEc@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aZCaE04vDpf2hDEc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: kjmimzeohy6gqffy13ez5o3o579dhexi
X-Rspam-User: 
X-Rspamd-Queue-Id: C56AF1C0010
X-HE-Tag: 1771257215-880036
X-HE-Meta: U2FsdGVkX1/PwGeUtEV7Yz9sWnzW7h1ko57H8QCPSsADBDIGHc0ZLnHVxFfCAV+dfa474eqvL9A+Au+cxdDZJtRq2fkrEDUxu7WlYiQgqFPlft4E7KSgIszOzefjEnqWtIkmetgA837ORkKodpTQccuPezZBB9JG3fi7RxB63C96HogbxIocyKZNNEBJuW1u1vHet0sMoU85E/M2IrLBjfKTh7cSvymzfkgs2wF2/uy68AaWRXaeA1iSeZCKYnFYt3sw8tmuT+6k5tC4s84vmZ1j6uwnffx1HqFPmv/v2GjuM8z2HWhwTcdzHFCLYw6gc4cREmGGl6OOEeeq7/mI6UC7RHltLjqU1O8UkBfqAKzWT/sli1dnRAbouBG8SqWtVPyWrgW96B4tQIVuEJNqggcHrLf+gnhbYUpLJ8PgcnrdhqDlcZrRxDaXQFekk0a+LBlFP8FCSQOiOG/DpSy2U9atImt4HonxnQ+20eLk1Ob2i7lljsrBfbDrnLp9eeVPiy3/MuY1V9PV0cEOtIzeA3QziXRrYXdhdAlXpUbidtX2rPRLtsb9sUhTwbyYiDTTROFItvPDhogcLNt2dHuuX0M/kbrD9Vybo+TVsJ9Miy650VaZewCtXxFa5O9USagGwuFm0UZ0G2eXJ7HF6ZC5MUiD6ERgT+r0+of08l12HrpMOU7kH6N8RjS5MA4EOfJeMUtG7lePAmqOPrlWc5/ecrBxFr3favycpMCR5Y1Ue26MfEMcfEWypkkjDRylQ5wCtmXxan4qCxIFwHBgc3PS6cnM5+P9Nxq0oqjZieGHe1YkZTfV9B/rhuh8lf1otx+a4BB10bhOj1adxVFeAXKM4Q1Fe17EhLTKQSRY9Scu9JZFAc6UZLSRSczG02gFFDTTLJWDsO9KgkMgPYscOrpZprHIN439Mx8ODeNPDRPm/HlY6SLUxbi0LEQXZQj515Qo9bAtkgcnJtMQ7X6lYFF
 TJ4nHBJP
 3Frj7qy/GQrbpOWG/8GWVNdC8DEG81pmT8o1J8te0nJO68xZJkAxCdB6A5HkXNft1cs7sgxhd4x4nbTod1hKTF+bcm3z4ASjQMotyxKa4PrIbKb8U0agiEh43YiUi8Arf5PZ6fw1lQ9/JAzbL6hMvqZBtY5Egx6FqZpLR/WRuzwttrBlBitzUAA2ER+iL55Fmd6Wpd+36wBaAvEqCYj5VtgtQ1wFR3QvBmN5g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 07:51, Mike Rapoport wrote:
> Heh, it's x86's choice of memblock iterator that's rounding the ranges 😉

Ahh, good point. I was just assuming that the memblock iteration _had_
to be over PFNs. Silly me.

> Maybe I miss some context, but my understanding is that for crash kernels
> the unaccepted table is E820_TYPE_RESERVED and those are never added to
> memblock.memory by e820 code, hence the call to memblock_add() in
> reserve_unaccepted().
> 
> When x86 creates page tables, init_range_memory_mapping() walks
> memblock.memory with for_each_mem_pfn_range() that rounds ranges that are
> not page-aligned, which is normally fine, because it would mean that we
> miss some partial pages that are divided between E820_RAM and
> E820_SOMETHING_ELSE.
> 
> And Kiryl's intention to round up unaccepted to page boundary seems correct
> to me.

It fixes the bug for sure.

I'm more worried about the next feature, or the existing features that
also only working because memory is page-aligned somewhere (even though
it isn't guaranteed to remain that way).

There are two choices for fixing this: One, we do Kiryl's fix plus
checks to ensure that all the memblocks that generate direct mappings
(is it _just_ the "memory" type?) are padded out to page-aligned boundaries.

The other alternative is to do for_each_mem_range() and do the padding
universally when creating the mappings. Maybe _also_ with warnings or
maybe a pr_debug().

I do still think it's a little wonky for memblock_add()'s management of
the "memory" type to allow unaligned arguments when that type is also
used to create page-aligned mapping structures. Memblocks themselves
obviously need to be byte-level, but I'm not sure it's the right thing
for the "memory" type API.

