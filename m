Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5207CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C46C6B0151; Mon, 11 May 2026 12:46:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375126B0153; Mon, 11 May 2026 12:46:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B076B0154; Mon, 11 May 2026 12:46:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0766B0151
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:46:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1CCD140210
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:46:37 +0000 (UTC)
X-FDA: 84755717634.05.EB7B653
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F8121A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:46:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYQyVF0d;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDWlAo+by9et/MLJA85Pch/TMQZwZ2+eHb3ad+Lqwro=;
	b=ozFAu3pnj7RWDC6T1nBQ0lUu/rb01gyWeS2/YN9LJTpIbC3kumlvjc1gGA9tCZOMPNwxnj
	lb/4nGTLQ4y1SR8geChlEsxM4WfUm8qSvimQE/bfOs8+urXSNVj8tX5dsDV+/OjszMcUXG
	DZ+dEHi1R16SMt+1U/vSYyRWzPIrsWc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GYQyVF0d;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517996; a=rsa-sha256;
	cv=none;
	b=d9mQAYCCQ8hjDg5MiLZOJ7lfKBssGtaEfZwbA3Lz/UO2OLd4KfnIAJriwsPMdA4o7/BEmU
	gLJJN5iXfvxvwyi4qG1DjVbsCNSndVZ0a1jq/hhxCLkprD58WFPirlx2DrK7LW9iVqCxZP
	IwPWd11gEsnrbdHimV0/s+qbS97sEAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AECBA60121;
	Mon, 11 May 2026 16:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671B6C2BCB0;
	Mon, 11 May 2026 16:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517995;
	bh=bw1iSp23wIs22ISN/RndBuh+7+IBivBG0cops6DsbD8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GYQyVF0dodcnUtJFTeC3X6pBLZ91yI70qFAz9UI53t7Q0FVCJa3pgjktMCFALEF69
	 oFf86juGHdTTIx18+2++QfRgKVI/HsuKVJjpLA2YQHi2BHwP7iP4b2rDKOoXFAGDsZ
	 V6fW/otEE1ZlCA+SN9dsIevnW2msNppbiRYuSsLRnCiHukzao+82/kUJujVQ36Z7uz
	 FzXWDDyoSP6rMmM1WtGNgeYVuGySa5JT9xFKBJWyZ9rpD4cT6rFQGGSo3YH3LM9xrV
	 lf1cXfbMfcPqfBsW2BVAMoFeWtAJv7Q1CNFvKB8pBreZ9Lhr3L9wZAHJOwtFwVM4xi
	 6vuaKLjRTYdIg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
In-Reply-To: <agHGOxSnP_VraH1M@kernel.org> (Mike Rapoport's message of "Mon,
	11 May 2026 15:06:19 +0300")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-10-pratyush@kernel.org>
	<agHGOxSnP_VraH1M@kernel.org>
Date: Mon, 11 May 2026 18:46:31 +0200
Message-ID: <2vxzecjhc2s8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bm9uqci4b91peeowmzoagffzcwf16sy6
X-Rspamd-Queue-Id: 3F8121A0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778517996-169734
X-HE-Meta: U2FsdGVkX19rB/tbOKWjrbQ/4wIxOM/cau7q/Ml6DEpDVLsstKZ19Y2q9J+Qy7rnH2hwgGoBaiZqn0+EnE9mwOuZ+nOL4ATuXZipzr77c7extrQ/qsGJyFodj/jFpqmrgDZvcPnaQwGGVtltdcFXKswYjC4GN5eAI1OEPPBNiTHMUWmwoHm4pQ4uQ9fhhznYCjGEiH5ZCM1L50WR/rR8qDT4AH54lujCvNwimaLfJyWru38oqvepllWyr2Nn6Faq2cwvwpIY6omPLD7dQb+9KbaC3qwGB6/R7Y6dLv5SEyTsMNrMw3ZwmNY5ZVd+BjNdc3Qy65dN90lfNnqBo18e1nz7dUlmHOFLhos+XbNvV2apcUQC00G7Gp83yhzuXslasRFxIE9+C1mbU58kWXLIoFftmnGMDKJEZBvaKaOu4B9erhNvIW1HixJpkR8AKTj/gzKM1iw7qPRTHj7nfhh+zEJOR0SsGe+gFPBrEK3hrckhdIOCSNqp2WaLM7Pn2gVWgfXa2sPYvnl60seHDOMy8YpSVZ6pNF2eA3BjA4aCM4eVF2a0uPJSqVgZrxpIuk4bRNnYONVRBd5RpQOK1PBN1GTntg9Sxb1izxe+8cFd2ha2Vjm1rYdlfwYo3ASyoqJS2Queko7Y7+XjythTiWZR7YBTTRGB1I9Pbjl2hklyIgt1UO07gKfiRttDa57p+e/qoo5FOH4x507zIi0XUJz/BbsW/LxiLkqXNeHgKIa0JzM7UAAdsAE5G5D2DUc5lHMa7AJIFEFdtn+ZgHcuo3iLQe5A7kwX46GZTwwnMH2oPgKhOIAinQd2w2N7Hrz0PAMSDKj8X4u3AP7WAW3Th2NuCjfDUjtfGGDktkOvttxdLzSvWpAlI2sUuIYB+08ST8sUKCIVVW6Ttn9aOsWqfmGSXy0TDAi2eAlLNPJX6UfmeWktPEqDAKGu6VTR2X9I3pQMyFDOKUV2MZ0YN1YNJtE
 g5B1VhXY
 XZgx0KSgufUyTnai0emw5wI8gz/i/ellXG2QCyi5XH5xuvbC+9uYfdM81tPuYl2TuNGUxQ3lMrEjPWBomWKNYvps8jkhjgXEIHleQeoLrDGktNH+RyLLg7z8vxD7hNPqDXoCjE0VnSXWHCOMNGTwVwqMSgY/saLpPotvtNrVMvT/2k9kv50oaCNYFKUtroKPI3ZY/9l7NTmxiHEXtGkAf4SPHoJTdqGpIwtGZYftzUWBqG3VrORZNsrU4fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11 2026, Mike Rapoport wrote:

> On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> In the upcoming commits, the KHO will learn how to discover free blocks
>> of memory by walking the KHO radix tree. It will then mark those regions
>> as scratch to allow memory allocation in case scratch runs low.
>> 
>> To differentiate the extended scratch areas from the main scratch areas,
>> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
>> for allocations during scratch-only. Teach should_skip_region() to check
>> for both flags before deciding if the region should be skipped.
>
> Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
> SCRATCH (I still hate the name) means "memory memblock can safely use for
> the allocations". Initially this memory comes from the reservations in the
> first kernel, but if the second kernel can find more memory to extend it,
> why that additional memory should be treated differently? 

Two reasons:

1. We mark SCRATCH as MIGRATE_CMA. We don't want to do that for
   SCRATCH_EXT since this memory can be used for non-movable
   allocations.

2. Gigantic (1G) huge pages can not be allocated from scratch. They can
   be preserved memory and thus should not be allocated from SCRATCH.
   See patch 12 that does allocations for gigantic huge pages only from
   SCRATCH_EXT.

I will add this in the commit message for the next version.

Naming is hard, so if you have any better names I'm all ears :-)

>
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>> 
>> Notes:
>>     Checkpatch complains about no space after MEMBLOCK_KHO_SCRATCH_EXT in
>>     the declaration, but doing so makes it nicely align with all the other
>>     numbers. Mike, if you'd like I can add some whitespace.
>> 
>>  include/linux/memblock.h | 10 ++++++++++
>>  mm/memblock.c            | 41 ++++++++++++++++++++++++++++++++++------
>>  2 files changed, 45 insertions(+), 6 deletions(-)

-- 
Regards,
Pratyush Yadav

