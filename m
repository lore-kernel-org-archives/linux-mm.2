Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688F0606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=f43vwgDi
Received: by kanga.kvack.org (Postfix)
	id 8B8A96B05B0; Mon, 23 Nov 2026 01:46:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862706B05B3; Mon, 23 Nov 2026 01:46:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778B36B05B4; Mon, 23 Nov 2026 01:46:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 569EB6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:46:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B82DA1207EC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:46:16 +0000 (UTC)
X-FDA: 85465449552.07.4254D0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DF77AC0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:46:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f43vwgDi;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795416375;
	b=SerW33CPxu6MxO6h8+UKL88oUPE15CXkVMbguSfyW9L8bmK3mORJCbwslb65KCfai58Rd9
	bIWN1GVuiZta28wHKXdyGiKm8aeHg0aspCUGFtARVbOCXtTx48nxpF7ZJJk2DXi4HVW4/I
	hZBN7LxUDxQVmXPkEaNxlN8OKVLbYtQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795416375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smMnBtOrXp4KpQwGfADX4ET4EDpnjYeR/XXFrdbolek=;
	b=Vpd2M+jifVzL16JcQGZjU5h92a51PK9KaLW/me6yys9nKjdtnuMQj3cdlKnkgM6DHYWl0J
	pPc5hsW8ubyGrYqGSK15/BdzICpb96P+m4VJWererUTL3pTOCva/xcN+qqagZK7lFNVsk7
	X7yyEFIWcTjITicRaFYENgeTwgUT/h0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f43vwgDi;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CE4261D1A;
	Mon, 23 Nov 2026 06:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1F61F000C0;
	Mon, 23 Nov 2026 06:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795416373;
	bh=smMnBtOrXp4KpQwGfADX4ET4EDpnjYeR/XXFrdbolek=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f43vwgDiyUwxOgba9MedwB1i3kx8fX77P+jVWeAczvu/WwhfD0oCf7N56P7hJIcnt
	 nLfDANZkcx3oHd5XORFo3BBNijzFunB5QSnRSkhH/MON/ag4WHCU21wDk+h644cXsy
	 oXhyCEvKWuGDmN8+hmbE/MFHFMCZaDWI8So99uWQ=
Date: Sun, 22 Nov 2026 22:46:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, ljs@kernel.org, hughd@google.com, chrisl@kernel.org,
 kasong@tencent.com, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
Message-Id: <20261122224612.8e7f1bafa2b712521a95ed79@linux-foundation.org>
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DF77AC0003
X-Stat-Signature: 6wsestjzr5b3qu3fd86fwjogzedowt6c
X-Rspam-User:
X-HE-Tag: 1795416374-941050
X-HE-Meta: U2FsdGVkX1+70rzu/eSI95dYLHZJH2qGG23oAhK3wZcRrmSfyEnn9a1sHxqxlUtha8sh4U55gV/cZ8o4CnTvK+c9fwtX7eZZ782Spde7hOodYpKGMHWb2EU+hsCxAiIBV2ZMbn8EODD67LYE6pNtyTPAFz6IJlz2nUBzoZWEqh/EqGF2t6bbqA54BtMKze3SLCEqcEkpmJh65b7uxCruQwhZ6DBqT/xApeA2HlpWpjAfYh8II9Mn2xWNZHG3hMjOPwxw246kH3QgBPUIC3GxsGsOvgOnmgTAMtKhRUomwwwIy2N1YvvOlEH1/a39thQX/3ki8JkQMVzgFbbxhgUy9fNfzHGqCm3h+fHI4GxRr3DwUTYhuLytu512rg1vLVbnHagXoTqEKu8XfQe8wPU1iLpdSs1WtkcA8H8MHJl8siwaANzv/gI4jP3ZHPBGq4ermKXyO/4XGxHAUFPFVa9vs6BzpqmJmqF7nexn7lNulIWTNmqN6A37MMQ/E9iheAOax2+NbR/94++43O1pcJi0zb4qHtrqEjBgf2jtxTsXlxhpvEdzgPJqpqHwJ3xa29Mo0G1XdYNm9Vl9nYOhaK4oeWd1tyKigecHYrCvBj3C96nJyLoZjfOE6LAflAbxmMkXzfwH/9gRP5TyeAusKYFaUIrFbyQo5jhCGj6/JncYGSNWGT+qVBABo/7WVkEfL5yev2sEYhCqL20tcEYyZ4xNQZgcRvYmane5m3pdZcvMjWKKRlXDPy3JzHPuV5FwJHtDKCdiHnplD2n1bM2bXYdRXcXFrfR59HejgoKdz//PwwhpDBs66elxy9nryj7skvSceqyn704GJONLkfvICO07NxLnAC68Q4CDdP7Rb9NVoVODoNIxdDQ8QDFQWwspAPKM8Qbb9deK5NYYeMA7XBq5jxdZU1Ao9w2zABxTuI698fcRDJp/NEzetf6AWqo72m9tYT/REOMDWTUQDsi8XVm
 PVG1XGCW
 A3z5SUfcuoIi5D259YXcKCxjfTbun0JwbxRmToEKv1h7bxssWw5sEKkm0UkDagC51xPRfEp+PEnDxOKdU2uU2L3RXx5vc/M8u3JKKOYyzzEgJH2OdOVuGCs+HYUFBqAadTjs7UCaMaTe2QZQvVJE1KFgzAzoxH9kcTZXaWxNk4gms+8mi1wb1h7mayVCN+AHpCQxZ9/vheZs12389BW4FcmFBGIey/f622prtiiPoUqrCv0k122xB6KzuskLB6iGK/VuT9+uWBd71epssXqm/t08aw7aAeAcaAwTjbJVVv6ZCB8UIJApM2UI2mif98S1j2IBancqRi6sJuEc3/QJUHDq2R0yhqr+hUWqTCBE5xqhn2vDcdhCmHMyoso0MD+MpHvrEunGrWBOWuQPWJI8eHsX1pXMrWfc0Yxm/CtOeLuiKIU+fJp0dekt4YUlerZRxT65a1VYmatX6chf4smy4+YGxR7atliArOXC3qoJKRlCDAH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 23 Nov 2026 05:35:34 +0000 Dev Jain <dev.jain@arm.com> wrote:

> Speed up unmapping of anonymous swapbacked large folios by clearing
> the ptes, and setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:

Curious.

>
> ...
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%
> 
> resulting in more than 2x speedup.

Big.

> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%

Small.

Why the large discrepancy?  Host-side caching?  Was any IO actually
involved, or is this all CPU burn?

Maybe arm64 stuff such as pte-batching or TLB invalidation avoidance? 

I mean, that's a huuuuuuuuge discrepancy.  What's up with that?



Also, Barry's

	memset(addr, 0, SIZE_BYTES);

will trigger swap_writeout()'s is_folio_zero_filled() optimization
won't it?  That may affect things a lot.  Did you try writing non-zero?

