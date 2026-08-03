Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0DEC55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB6A6B00A3; Mon,  3 Aug 2026 11:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D9C6B00A4; Mon,  3 Aug 2026 11:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9728B6B00A5; Mon,  3 Aug 2026 11:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 710656B00A3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:14:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0971B1A00C5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:14:41 +0000 (UTC)
X-FDA: 85060305162.21.7D0F0A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43568180005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:14:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vzlq/5g+";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785770079;
	b=6W+gjGZqx+p/I5HshEj73sG9greB7CwdZsWmbteLNaqhsCAp+rYkYBwiimKbcosPFMfVs3
	ORUpFovP4KcTHhG1YKBh7zznsHwIxXfb76Y8SWe7Ab6rMl2Llf6ueC5yDSbraQXfliE5bq
	sZacg5M3VTQaWg+GQNfeDPDqyjClzBo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Vzlq/5g+";
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxpSlS7fw1sw+jv/kLILYNNHEAmkhzbCu2EmmYNqlJY=;
	b=vRICUrTWqG5tieZMeacwqITr66lPJ3pjt98Od8HiKi/ApY4rKujnpVDztE2viZnIKGHvRg
	MdN08xNYFemrcwvd5ZRIQbAkojRGrXdYIemm1zhCbKLyIsqFzk2vi73fD0qi/UdaMN77lX
	8OMo/N4KOUqN7eM21iIUAkeQ4ldpCaw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66F4B41AF2;
	Mon,  3 Aug 2026 15:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC91A1F000E9;
	Mon,  3 Aug 2026 15:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785770078;
	bh=jxpSlS7fw1sw+jv/kLILYNNHEAmkhzbCu2EmmYNqlJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vzlq/5g+ZM8dG9vHbh4TD57opi++DNF81m2TQVy2RYsQyN0pzjJAMexGSS+Q8mNDB
	 Jf7LIuUrrx1JK+4ohZhTwFnu6d1cXwaIg2A2F3E9SdD4/vIywwlQpe08Xbt9sg6iFO
	 CDDU9qVyT1E44okjSeeTmASarl2PQDxEh6rV0J300Sv1sGdbBxdQUXtfidCC7pfBkG
	 5vgdgpKK3P1JG0FSb/QuNlcD4Dhz8PvTTfl7JU4lsTLdQwMEvBHxL+AUNBJW1gwO7v
	 jejBsVHnSD+uc3mfeYd0/uiOMiAROHdPYhO1FhX/bVSilxznmRPJmgiip5jH5YJJ8t
	 tF6fpoaRiestQ==
Date: Mon, 3 Aug 2026 18:14:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org,
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anCwUb9lV18v6mfN@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
X-Stat-Signature: unm4dtj66erbkws8ukcdqxqdwturqw34
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43568180005
X-Rspam-User: 
X-HE-Tag: 1785770079-714576
X-HE-Meta: U2FsdGVkX1/4HsETtPk6ZmGeLo3muT75M87fWvNpt4e0c0pq71fOZ+e2CN1GFbbMTZLsdeZeMChIMIDCs/CXmiHl/fbcuo383J1ZFM7XN+HRAlIT0JsxvUUEvY8zgITsUhvREvKas6SfilRgU8kqqxDXYpyqUC2K1f1HrXLRP4QVhl/Am7c/IFXhauVAFDjbqt/VFE/FwOCuuMrTp4bp+QFzDv4XXxYraa2HcMrlTckFfXVRTUVrrHpBTXUf3Xq0ThCO462/IXLfpd39/Aaa8SldbFII+CnuqGfgi/YhfZgh+mQaZtNf/Jr5duBA21sT+RyKL7PPmty7CC5+RbWO4C5Qt8kptAuafGXwOg77lDA1CwKPiwOMnYTzyIEHXgaV64TMrxfp7fmGiphzwIfbXi82fmFxgPMwuP/56WPWUMN4b8g8B2RHwu6wMElzzVtek7BYaumNCqQo38JCih/dMRAyVaiNX+Uwf0Y4VH8Rg4byma/o++61cwVdJ/z0yUCeqPkhpHz24Q+Xfr9cEMLDpDgBt7Xo6tQJJXXB/CJfIDVMM92qzMZdiT5qiZMXNg5xCqpbIgTRVNfcxXwx+4+ZcxgUwq9AiPRerdN/i4GUu3FdDaG9g1Vkkw21gDKK3yaTZLlx+4XEs0NW2ey9PLjXLsWoYeCPcl/yaNrUwp92rWAPADCdvWW0f+1yxvf64UldrOP7B4NHOYyrvlqb1JfN/RdLNSMdoS8S4m36FKE5yyyPnAsBpn7PI/9BuKVcGo4sAP3GfDULkBOFmiAbAMmZk1LPNDwUeHaIFj3R2hTlV9vK+OTY3RffRreEi/YL9HsPBgnKka5Ro0Nlj9LCmzJKRGu3xsYihtq7wWz2b2ZpHxG3AnPzfLn4BVP03pHNs16ExITE6ENJtt8NoxzoxbmhwNwwXODjfe66TnkMVLnRx9jgMhVB/4eTGKll8XTDC5LvZKJyCrUyPaSFVn7IRRM
 46yF1LmZ
 3YB+ao+cP9iPH+I3BBZLKgXBnDFmgPWVBPqvbpwA2Z5eun4ZAlm9rt99ogIFUXgwXCuLTJ/meQpi2ws4atcrKjEqtAyq60cixZe2edMGU44ANXizXdpazQGwI44YFNt2QU1scfAIzxIKRxVJ02gli2DedvuLdPvVVEkG/7bpzYwoUfSJ0h1qPnEz5wRF+751W81obJWXm9ZyoVcmC3OIDNvaoNq4oq52O8SuUBX0dkbumU9O/r+5GzFxwX3TpvhmRjp6Y4946m1HjRXvc15twMX/GebIYCTNmU2t82M/5HumT6eB9hO6tjg0nO1ajjzZT72y7g+DhW545hDxOy5F3daAOVO2ypEAp2pUrE4VOfDcKy56gi5fcPcqjRARCsiVzykJFZO8R+lGRh0pYNCfXOZyAfg0GCLx1g36N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

@Dave, @Peter, how do you want to proceed with these?

On Tue, Jul 28, 2026 at 04:07:43PM +0300, Mike Rapoport (Microsoft) wrote:
> There are a couple of CPA fixes floating around:
> 
> Denis Lunev fixed races between split and collapse of the large mappings:
> 
> https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org
> 
> Lorenzo Stoakes fixed UAF caused by races between CPA and ptdump:
> 
> https://lore.kernel.org/all/20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org
> 
> and an issue with stale page tables in IOMMU:
> 
> https://lore.kernel.org/all/20260721-fix-cpa-kernel-pagetables-v2-1-2b255deed710@kernel.org
> 
> Mike Rapoport fixed a check of RW attribute in lookup_address_in_pgd_attr()
> used for the verification of RWX:
> 
> https://lore.kernel.org/all/20260715144519.934289-1-rppt@kernel.org
> 
> Some of the fixes got merged into x86 tree, some of them got merged into mm
> tree and some are still hanging in the air.
> 
> Beside the fixes there was a supposed simplification of cpa_lock locking 
> that looked like removal of an optimization for DEBUG_PAGEALLOC, but it
> turned out that it was not an optimization but rather a correctness
> guard because with DEBUG_PAGEALLOC the locks could be taken in an atomic
> context and couldn't use plain spin_lock()/spin_unlock().
> 
> The changes here are collected from all these fixes into a sinlge coherent
> set on top of tip/x86/mm:
>  
> * update to cpa_lock handling with DEBUG_PAGEALLOC
> * fix for races between CPA and ptdumpi causing UAF
> * fix for stale page tables in IOMMU
> * update to the fix of the race between split and collapse of large
>   mappings
> * fix for effective RW computation in lookup_address_in_pgd_attr()
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (3):
>       x86/mm/pat: acquire init_mm write lock on collapse to avoid UAF
>       x86/mm/pat: acquire init_mm read lock on attribute change to avoid UAF
>       x86/mm/pat: allocate split page tables as kernel page tables
> 
> Mike Rapoport (Microsoft) (2):
>       x86/mm/pat: introcude cpa_lock() and cpa_unlock()
>       x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
> 
>  arch/x86/mm/pat/set_memory.c | 95 +++++++++++++++++++++++++++++++-------------
>  include/linux/mmap_lock.h    |  2 +
>  2 files changed, 70 insertions(+), 27 deletions(-)
> ---
> base-commit: a5a162fe1ae130e3d2ceefef3f43afe3773c1d56
> change-id: 20260727-cpa-fixes-d3c73c075672
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

