Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A02CA0FE8
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12A56B0126; Fri, 22 Aug 2025 11:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAA66B0127; Fri, 22 Aug 2025 11:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27D66B0128; Fri, 22 Aug 2025 11:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94E216B0126
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:12:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54D451143DA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:12:06 +0000 (UTC)
X-FDA: 83804733852.08.1372333
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 806A31C0016
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:12:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gi25p9sE;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755875524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1caK4/CeBqmFZVqvqUPKKf/tNhYxSNSju7u+8j5swI=;
	b=cWSq1/oyquj6zorlLaMoqrv7aD6R60g9dTqjQovBd29Qb0YlWge1mUkPTlNEtT+MiC05i7
	Q1KwHk87VctTKdoaPFwqdP+kxiEwvSwDT24kjYfp+ApzSYOSMkJrEHMj0g7SzVg04a89oO
	1kyw1NGtJBpgTkWJf6YSQjMXw8G3s20=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gi25p9sE;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755875524; a=rsa-sha256;
	cv=none;
	b=hsit8x39lfiM5veRBJXTURuetPR2J0FVsmN0a3llHf44PYGg5K62fWdly5gGXEHpUfri6C
	CzxKMz4gAA7BwRdZZpA2leOqZbbLxpHKHVq0gjE6MnpHP14N0bnfq+u4+VJBkHh2td1jEX
	2Zc2EEDMj8hR9erarhdcI5HGPrpWdwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8512544470;
	Fri, 22 Aug 2025 15:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164C3C113CF;
	Fri, 22 Aug 2025 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875523;
	bh=HRRQbT257R2q2AEfvEk1n3oH5/MZBF2WDP7W6waprfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gi25p9sE7/lhCMi1fpxXS8fHF0WuseavqUdHcmBb8R6Y5VmKdKZVf1NnefLXt7kJ7
	 URm4lN5NGS/MzTvr5vAw98Gq9CNFGqAh8ylmDv22+DClMuw6uQoLRDzkVyRGmBlOl5
	 pRDjccH/6i79s/pMSSAEfP5hs73RRhp+GS4gTAO//P13gtHF9XponRl0O3F6GIHolA
	 6zgBDUxATcZf2srHifss8fRY80pD0AOMPWUP3XezWzz82yxkmlYx2QZZ7J5OBL3NEv
	 BrAn9osE1Lz4iRcmF7gBSFbdr0TGaiCiIGNk8hDPs3BG24FCO8bHkl52zypr7/T0mK
	 AjOJKgqMIIPCA==
Date: Fri, 22 Aug 2025 18:11:44 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 04/35] x86/Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aKiIsF8mpeUy-8zt@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-5-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-5-david@redhat.com>
X-Rspamd-Queue-Id: 806A31C0016
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8uabozsbrmrpemm5j7numbfnscf3sidf
X-HE-Tag: 1755875524-639607
X-HE-Meta: U2FsdGVkX1+z/4Ys2TUM/Yci4L9wV7fHcjqW7pPStKJEf+Q1myAkqGwrMAGEAeMxkYDV9jMZ3RiHqGnwOBiTUhdGdHJSf0OIb24dlQQni7epu3L15z9YhceO3BoyaBV4s6vWGXQNMP5QvhgU6ZV2LHbisGCq0ieSFMqmNdfiCH+56m9qnVqm9tODo2zQE/KzYwScAUMfBGMc+QKEyinrit/IrR3JQAM8eVFAHtyJ293b3X9lmF6qxIyx2BlrzeyYuZ1kjgglUBf16Fw2YFeL7+OvJnq8DWhYx1za0NMml76x8/j2/HCxxLz34m6NrhwJ//eHGhL2p+UyKmDE/vtgU/WFgff+So3SHkjKLedFjbBPKzRco2wbNYezebGCMz9g4NSyTLy64uZa1Y+u8e+QITpTVMUgKNuJGIPTgr/0gVoObJela3NqzVrRwpMfwweo3qids4q8ZFHkucz3NudRI/TFrtSW4fCKJj0zwlU2ffIdaHZeuGDNnEFDTeVGZEVUJUrsPNjejSUQ0Ex7AsnF44XgrFNgYHjOq3Hlsbq0z3YIFlYjn6lPOlyv3TpvaRsAi3/ttRbk/SDY8IwDI1V4tbLF1Opov40AslCMR9r9SpwS7u9C4jzxGgWd0sK8/EQFeUal5PSyvEVlh4JfTVcZE9WN+DI39bxUSZPhu4S2xoJ8iCPP2HHuxVg/tx/xbRHyE4JRY/TxzCgVAlQ3fIfCrIfQ647iPJ1dUC+Vi0gNoUorfxJZHywAiQNatvIIbWf/nHekEfrhrf6Jo9p5KFQ8lMJyw+TBj84h3ChFh1yF2JaLl0xT/UZf7Ib8U339Pc7tywqEgjusfCi7Q35GPSatOiZpYRPU8UiNK89sTso9HVWwYfNCykHcMLQdaVspNYX4rbru34etPVXmh8z6bsKABDuVzSt5mTwaP9/5O2Cr4xYWlnGplkVPl3tqRoBuJxa6fbuNftROscuMx9TawSq
 JnBBm0XP
 04BPufrniFlNqxPvjHGodCmSb9CV37HzZ4cFwu9CReJ9q1UAn8BzTHpGhkLHVBICpD1RWQaTcFuFJjduUfvr/Yiu1NwNYPLW51l/jBw12l+YLJCisZgJyH6Z4BSkvW/GcHBl9e8l+w0uIERFLoxPg2x5sCoYK4C4l3xWISaNE9Fmzz0BIZCZXSu/Kx7zPgSEcAGZyHLeYB0q3rz9FYnnZvQ2cgt/0kMUtU1LZOifkyGXzhKbzEYBv/LkwNEJvYXDMHeGarYbtlP04kjTyRyGLbJSK8FkTmbyGyNTuSHxzo7/BLq0Rgmtt7xsULsEsf6IRINp+DmfxoY8rPgBsMWAIGqzQD9q1Gyvsesn5L+ItaTMtIPIwqq7Vx6T1DA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:30PM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/x86/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 58d890fe2100e..e431d1c06fecd 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_STATIC if X86_32
>  	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
> -	select SPARSEMEM_VMEMMAP if X86_64
>  
>  config ARCH_SPARSEMEM_DEFAULT
>  	def_bool X86_64 || (NUMA && X86_32)
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

