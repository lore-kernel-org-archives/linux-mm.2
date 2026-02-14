Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392D8EF5849
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 15:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7076B0005; Sat, 14 Feb 2026 10:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674326B0088; Sat, 14 Feb 2026 10:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5803B6B008A; Sat, 14 Feb 2026 10:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43FBB6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 10:51:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4BFF160898
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:51:57 +0000 (UTC)
X-FDA: 84443503074.03.79D60D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4665AC0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 15:51:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zcsc2E3/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771084316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kj1y80cehz+QFqb5pNaUYENbLojAmlIRUkZChDZr+fs=;
	b=QVUMQOyDRotW6qjYOgGrhvFaAcPceNaxXNPtosr7vmR7kzRFBSYSX4WHUA9NCfAS5Mmng3
	76onwgycrFCzEXbAAk6Husx4bPhdx2SdlL9c33geDTRpQSbCtdOKLBkblZ3cR6XArRIteW
	Fv7y4kAABJ6ZXumaKN2UVf+5OFYDk8c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771084316; a=rsa-sha256;
	cv=none;
	b=Y8Nh7B/OjgVbxUEi+balyh/7iXdfLPpIhtg/w3qW1kpQpj0mf3ht3l9eU7oR4jWOJxYViy
	532Ek4/73O4Gfo9Tbj0CzEG0ZNKDHXcawgclghq2B/+uvZJZIH374sguF3287KAw22arKE
	LP5yVtP6zO/PEV3ix5qHBuCoIW/m+6M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zcsc2E3/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 647BC600BB;
	Sat, 14 Feb 2026 15:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B52C16AAE;
	Sat, 14 Feb 2026 15:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771084315;
	bh=gqasDy2xb54ndlBw62GJHZO2RJmh2bA9prsyInGKGKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zcsc2E3/35RhPbFkNNnuqUTR8J0Vzr5V+E2+QVinLK6eLhF/ka9hS3vXgOdxlcTAI
	 yUO3YZmhJ/mZlBz3PR1JszQ0tpGtVCvP97hocYWK/lBZCYD3t4Mhq4EfYWWs47e2hQ
	 PUxfuzMvH0MHgT73KYfmMamZS0CTSvJVAswGCqog0wJHHk8nEN+oabrnpexRSDiQxF
	 yQQNWTcQsPnlcOunoMrj5LhIXHGZJpycyRQt4BFYAO2MUNMDFEPHZ8v0B47sbAP+lP
	 yU962dDLKCcOuw6MIGOjmnlPoBc15UpIh/WxbF72I/8bw9rleOo6G/k27hxzifRUL5
	 S3CU+LA/8EHew==
Date: Sat, 14 Feb 2026 17:51:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Ard Biesheuvel <ardb@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aZCaE04vDpf2hDEc@kernel.org>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
 <aY9Mf8oZODGiDoXp@thinkstation>
 <6d6dd421-774c-4f29-84d5-3e449240eb93@intel.com>
 <aY9c80nXefdXjGXh@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9c80nXefdXjGXh@thinkstation>
X-Rspamd-Queue-Id: 4665AC0005
X-Stat-Signature: wpaoz34ogufmmwdrxkg97p51691a6brz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771084316-429912
X-HE-Meta: U2FsdGVkX1/NpLojTg4iX2e5dy1j1Rgm5v/rsFDo8MgDgMarOpZxYLHIEz5i8AD6Pn0NxLqhvl05oVjoHbc6jjNJ5zEI2XVbp305PqEW89u+a7FB/zBfCler6nRXDtPTGbGir07xVcSeSspuZJq0JfzOfioOMSwEQc8zUghoFMdTfiD+mL6NVHfnQKvpNgS8s0oPReMgE6jQE2K+4Lcvwzow0jgwrTQch+/PTY+UEojgefsj2GBq+j0MS2cNHtzrx+X+mCCU0K401KZ6uLwgJCEF7wCyb/VTvaUFUfN1iF8JQgkcW/owSHJO0u0yIffPbOamLz0oO90dO2WlZVcDfAq/IPiF5tUFNt8W2myqElxl4/k3c82RKctD6VNKaffhTr97q5JuJyOcIwJYrloIQ/7zTWTOLIpTBw1gOvHKQ+bTnvxc0YWXB5UKJjqIfypyJGedPiHgwQwh9Dd3qEJs87Y8K7odO9bKcY1Ehetf9DCDf551rc0aFN9K1s+HTJFXvXCtj6McS4cYWp4XyfUZdo61AOFedVsqHAF2bWgn1eYO71wTzqSIjLTha0qwUKS3pTTzFupGtVzQc8c8pQ/n27WuRRI/cvxmFjzXgpzCYbspbQ8bJ6EDZbBUwsgoD2tAK0wgC2MPQqakRSQQ5FYBOozSqVtDcju+vKtH9wFBPsueIUa5Lw5EQZRDIE5XLF/VIb2Jp8YE6VmpEYDm9uY3UMzDeAuWs52Lu+9YQMo3mbGgPRvLg5I8F8n07b+RvN2pcO+kR2blnWOqeNjyRgOVGeKXcODW5upbm1h/ECZgE3GoRRL4G+387M6HIj/sioViqAXr88OB7ILv2nKVVWhv0ByeuWEIrf1vWhNxcr1we/h80HEwZf+wVQVpSaf5+siAjaFt0SOxtuxGXqUCT7I/VtQB4gEo67dh0xKz/O703fKmDZgcuYnFpseQ2Qk32tQabO26YqFOhiOCwlrY3jP
 VqWD9Abl
 AT3SxBuQw3ObCtevFNsKWNlJXYZcV01nHpQreGT3mgptOih2lTAGSqM52MK/sgVTJJnWRCL9eHHvrdyh/yUbdU5a0ULIT9d3ykjGxkOY9qcwNRhBbWQXhCiGsXC904APrbEoyjioaLr+qA4CmSHbabneJTCp+glo/tATsiBD3o8ghHVegBZn/LiDQ29ipdKXwh3Uxm7BQ5hH11XHiOV9ZHDcFEtW1vC+mAAUISzCRvl2onQDTIHprwR49w5GtBSN8X7gX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 05:20:14PM +0000, Kiryl Shutsemau wrote:
> On Fri, Feb 13, 2026 at 08:46:55AM -0800, Dave Hansen wrote:
> > On 2/13/26 08:14, Kiryl Shutsemau wrote:
> > >> The memblock code seems to be able to handle arbitrary alignment just fine.
> > > Memblock will track it, but, as the comment says, anything smaller than
> > > page size will not be mapped, but we need the table to be accessible by
> > > kernel.
> > 
> > That seems really, really fragile.
> > 
> > We should first make sure this is intentional memblock behavior and not
> > a bug before we go add more hacks on top of it.
> > 
> > Why would you even present a byte-level reservation interface if it is
> > free to just silently ignore some of the ranges by rounding them off later?

Heh, it's x86's choice of memblock iterator that's rounding the ranges ;)

Maybe I miss some context, but my understanding is that for crash kernels
the unaccepted table is E820_TYPE_RESERVED and those are never added to
memblock.memory by e820 code, hence the call to memblock_add() in
reserve_unaccepted().

When x86 creates page tables, init_range_memory_mapping() walks
memblock.memory with for_each_mem_pfn_range() that rounds ranges that are
not page-aligned, which is normally fine, because it would mean that we
miss some partial pages that are divided between E820_RAM and
E820_SOMETHING_ELSE.

And Kiryl's intention to round up unaccepted to page boundary seems correct
to me.

> My guess that multiple memblock_add() calls might add up to the full
> page size.

I'm not following here. Can you explain what do you mean?

Multiple memblock_add() calls to adjacent ranges will coalesce into one
larger range. But I don't see how is that related.

> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

-- 
Sincerely yours,
Mike.

