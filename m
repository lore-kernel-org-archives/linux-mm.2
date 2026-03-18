Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EB310854BE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 09:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374AE6B0147; Wed, 18 Mar 2026 05:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325956B0149; Wed, 18 Mar 2026 05:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2142E6B014A; Wed, 18 Mar 2026 05:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6166B0147
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:19:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B07048BBBB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:19:04 +0000 (UTC)
X-FDA: 84558634608.06.F8FE084
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 281F0C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:19:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zvb2MB6S;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773825543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S30lli5ggsqIyJZJNjukotF0gHOe/hhFfpeT7wWOM3U=;
	b=doNwYDe9J2BH5TsE6YDP/bIZGlDy1HKljdaS5EOCJBlg5lWBQ6A3kzbgDdJ75K+tiwLcx/
	mdiyTDAQuWvQByffS2HxPzBDpNcf7QiCnxlzhqeeD3k+s8PZ95kDc4NitKjpcTqCR/0omD
	cmJgw1WI2TEExszeWkTUlTIUVCwTqxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zvb2MB6S;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773825543; a=rsa-sha256;
	cv=none;
	b=Bq0SqqDU5lBYGt2j7byLNU6v1Emlc2WpWJmwKLEoHJYLo0f9fFQ++yX9dZ2YsLJuwVoqDr
	HgkYUJnfbkb4lHTy67v3McCrIl86e9DyVcdH8mlg6s3Ml+jhNxnzcRMi85XX0siHmDJzK3
	anPx815fi+GkYObXot3F7vcllkRH3JU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98965600AE;
	Wed, 18 Mar 2026 09:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFBAC19424;
	Wed, 18 Mar 2026 09:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773825542;
	bh=0JD2z9hbWyZ4tnmpCj9vi532auXFmzldAoMxVsPMnJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zvb2MB6S69hYoIHPGZ0bJZwkuTFepjTX/yV5EVd7ToI/nxFmvKEcFi3O+uZrzUw4R
	 zfNlhlNJeA+Dm77J9IwPwb3h7rDGehR1yRgiEYgzxvubydT6yVFBUO51ZOq4y+RmLo
	 nfA6XrFcP/0Qu1qRjfxonLvnckW4ZoumlxlkvCxvGLr3MnnO5mQZTj1msRe5vc+GSj
	 //lu61VMUjxdMWpMEP0WeUN9qIqDYzEcYmhmOjtVWnQ9EdvxOo0Fp5ZXCt5Xtl90ax
	 s1eh6eCKRzUS5NOHPlbqCXt6WlsV/hm0lcaZFGIR6PQ/GArZV9rp30G/tnA5oU9/s1
	 TTELR8V/h0c1Q==
Date: Wed, 18 Mar 2026 11:18:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v7 0/3] kho: add support for deferred struct page init
Message-ID: <abpt_-9jxmK-N6Nu@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317141534.815634-1-mclapinski@google.com>
X-Stat-Signature: 7sx38qgt3dmipmjxk7tpdsa3ppkwbpat
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 281F0C000A
X-HE-Tag: 1773825543-359626
X-HE-Meta: U2FsdGVkX1+oonY9V7zZAgLKFomSmTKS5lqkYNId3ubp0xj5TztSolxYldi6ogFKMLuEbI7jjU/vnUsOKVEqSOuTtfo0p+gj2qmoqO7KD6FIfA4Fq0ZR3FNsKS3y83OzARz5yNW62M8itQvbl9Y6D1irpSQxfXXMsdMDrBg7Dx4CLVkmQqbM8F1xcN5spuZKGtsbuHGrrWYjuV6mvKSvQYTaRz1koIBWMkooQT5mHS5hQjXn3gqkMuo1xjvd+aMkrBLfXk8/hocABcKibhMVCZpnYvADshEr1Y1DeUZ75CkSG9Tj/B7RnviMNQuDjpbPlUjq3vkO+2mbMJy9ySeSZ6v3exS0Qg9oBwIg1XVzQz23xh9HXw66hmlFwwfiWcyf+V5xqXN8SXOaf0IEd3IVFQE/pcsHRPHYLN8m9GtpbXivS1TMVax5OBOn0NRSMnM/ZdgbtRk2yIDQJIJWOf+B3HkqWOnwNmIRC9sYR/CrrP7jjmM4xxuLYyH/0yMunl+l2Gb0j+MmByV5bOc6eHDMo+QZos6KGdPJ4J3sxXZLsmFeX5deHyOV76I8EQ0dKyKS/mgE2PEw96zV1h4/RCPji1lP1S2gp9XZM8KYqV0iGvFZKD2KNjO5Ala2BheBz3uvUfDPdKmlo5KfGMtEDlOxfvMjovm7lrFVp99t3UaudkucGn+34YqfEGQ3XZcBweKIFEo3DRs6xvofPzWkurLMEGVCAkgqy6GNxCaRJbwdObBdxpkdJ5yJGf288kZGEz8yZCw9JdXfd8/NRcXFA0x0zZqhJwQ5dQDQpNwtnf8rbfOyjHRK3ETDKm7z2pJqSd5p5upFEb1YLihG2lofzLPsQ19ssQzKTiiDXRc+GqhQuatamXVV/Y4NXlSEtGoz/zCXqVCPTF9EWTaRr6uZD/2Mv0se17K9YBSBNr1MwY7cjZs7RMUr5R2mNhrYokw4um8jQq2tMD0eNX6R9tRywP5
 oW3zdOmk
 KAOTob+0gaS/rlVDK9Org2mpfUr4o9/9MALdKuMc1KXLJs053aOl91jvs21jTeQhEAHdckxqRpIU5vmAOe/6G0hL1Dnupycg5IazjpgEaw4jkX5PX+Llsd/SrQacO9QmZ1qlPTN8jpYe8e/4vfM73eZo0NJ6Fviwsw1Ry8CY8AWg7Obzap8NEwtA8NtQyatmzT30zyH34rFDHcRehPhIzwgLpyoNDs2HqQ8s9/gtbNCPsJdxtwxXAjQhVvMCF0chCNU+fYTvlNo/+lpE/q1S4JOoxQ0iMBqNcMjrkyaU7iuHE6IUGGLzisppdzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Tue, Mar 17, 2026 at 03:15:31PM +0100, Michal Clapinski wrote:
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
> enabled, struct page initialization is deferred to parallel kthreads
> that run later in the boot process.
> 
> Currently, KHO is incompatible with DEFERRED.
> This series fixes that incompatibility.
> ---
> v7:
> - reimplemented the initialization of kho scratch again
> v6:
> - reimplemented the initialization of kho scratch
> v5:
> - rebased
> v4:
> - added a new commit to fix deferred init of kho scratch
> - switched to ulong when refering to pfn
> v3:
> - changed commit msg
> - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
> v2:
> - updated a comment
> 
> I took Evangelos's test code:
> https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> and then modified it to this monster test that does 2 allocations:
> at core_initcall (early) and at module_init (late). Then kexec, then
> 2 more allocations at these points, then restore the original 2, then
> kexec, then restore the other 2. Basically I test preservation of early
> and late allocation both on cold and on warm boot.
> Tested it both with and without DEFERRED.
> 
> Evangelos Petrongonas (1):
>   kho: make preserved pages compatible with deferred struct page init
> 
> Michal Clapinski (2):
>   kho: make kho_scratch_overlap usable outside debugging
>   kho: fix deferred init of kho scratch
> 
>  include/linux/kexec_handover.h              |  6 ++
>  include/linux/memblock.h                    |  2 -
>  kernel/liveupdate/Kconfig                   |  2 -
>  kernel/liveupdate/Makefile                  |  1 -
>  kernel/liveupdate/kexec_handover.c          | 65 ++++++++++++++++++---
>  kernel/liveupdate/kexec_handover_debug.c    | 25 --------
>  kernel/liveupdate/kexec_handover_internal.h |  7 ++-
>  mm/memblock.c                               | 22 -------
>  mm/page_alloc.c                             |  7 +++

Although it's a small change, page_alloc maintainers should be CC'ed
Adding them now.

>  9 files changed, 74 insertions(+), 63 deletions(-)
>  delete mode 100644 kernel/liveupdate/kexec_handover_debug.c
> 
> -- 
> 2.53.0.851.ga537e3e6e9-goog
> 

-- 
Sincerely yours,
Mike.

