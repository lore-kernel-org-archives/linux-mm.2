Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC55C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 10:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C08796B00A6; Wed,  1 Jul 2026 06:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7E36B00A8; Wed,  1 Jul 2026 06:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5C46B00A9; Wed,  1 Jul 2026 06:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FD136B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:31:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17B8F1402F6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:31:13 +0000 (UTC)
X-FDA: 84939840426.17.B9A7A40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3CC388000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:31:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xrxzxwio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782901871;
	b=bUnxpQCo4QN/BVsDj+5AldkQ72D+qBAsmsEdMLk4iPgfJ3g3vvG/1IRsC94dABbDTGQjl5
	c6zjXiOdwLhawlMikNmtd8izpk9XlN0acv5jSKpmshI69hLmczfUzViLLs0wlRGYWo9bnq
	wGheBKx/DvEYXuy8A3YGcWn4H0caHkY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782901871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IIKmtqkYUA2YPobStqpa3RsIbXrHII8266gsF/EimRU=;
	b=B9HrUXZk/LT15FXr9VsUU2ob9g+1tH3YgJmtLRmXAeq5smJyeOVA6KHRLFhWR2YK9Bx4KP
	1StnDXpEcPzkv5vWHfrglZGvvvc+zKqBgy8FCoY2fpBZ+wheKeGmvNqjTX0HXndNFhejuX
	JeYKPcx3fut8b75uBGq8S4Oodhwhqrc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xrxzxwio;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26B0441FB2;
	Wed,  1 Jul 2026 10:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4041F000E9;
	Wed,  1 Jul 2026 10:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782901870;
	bh=IIKmtqkYUA2YPobStqpa3RsIbXrHII8266gsF/EimRU=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=XrxzxwiotKv/LKfqyO2JYen1SMfZzycMIFzc6PrQHWUj4cdPFdG61fMy3SxrIc6ka
	 52AVDRaj8qW+Hfd4/AYmCinSP+E6FwF2bc+kgVyx6Ow2Foo87Nx3Enm1hvfOiOivf7
	 XiErzK7zd/RUcVw7pYUXEXXz5nF+XxPPk3yWHpRjw264i70RVFun+Tg5KMgmIX9uBM
	 KtrpBWdogwH2ZURn5oHO6wrV02O+gwrSq96kbRvsgtqq7kXT9Kr4Tu2Jr9NUBPlh/A
	 GcNfVi6v5E3b+HnPggY3pY4n/agpMwPDR4Ya616Z/fTDzFY+R9g2IGxaZoFtK8ZaOd
	 w3MI17F50UOlQ==
Message-ID: <a3b046a0-a607-46e8-ad11-cc8c1c52ebe3@kernel.org>
Date: Wed, 1 Jul 2026 19:31:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
From: Harry Yoo <harry@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Danielle Costantino <dcostantino@meta.com>, Kees Cook <kees@kernel.org>
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
 <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
 <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org>
 <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
 <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
 <c4eab53b-c54d-4f1e-a4ff-8d86b8d32503@kernel.org>
 <CAJuCfpE6WSWPyZMheF4b=2mrwx7bPP3JUe9Pwp6QAswSMF4GyQ@mail.gmail.com>
 <9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org>
 <92bf5e21-690e-4a77-929e-5217e0d7cb0c@kernel.org>
 <68e7f6cd-cf11-46b2-84a2-d512bb22dae4@kernel.org>
 <143ed5f0-67be-451d-a592-e184dd51763a@kernel.org>
Content-Language: en-US
In-Reply-To: <143ed5f0-67be-451d-a592-e184dd51763a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CC388000B
X-Stat-Signature: ghwhqbrpi4sue55frkpfk341gj6px6hr
X-HE-Tag: 1782901871-451525
X-HE-Meta: U2FsdGVkX1+hP0blw+c5WOJKFCwtfJHGmRVPUYHkdZKp2bG/km0ExW9A1OdaK0PzWkmKTcaD76EQpep0f5kt5xreIogzWJd7ZeOOpzrr/+XpUki6chnuFofpk0soTo1Nz4OEVxKSmWuotpsZ8kCe1N6wa2bsPNz1FyDh00mh2YN/UA6FtTbUuWAa8qO2EseV2CBGWXUTtctPiVq8nS8vGbTjLBayNulqr16bkUHZpFVa/Ph4Gr8l65Sd1cbVPFfG07twe89eDg0E/Xe4bpIyG+tYt0XV6dWJvSXMDW0Ko3qs+Z9d0pVhkrefcabsETssbs9AaONnMYbD9afsdXCDxAmKAE6sBQJr0P/ztB0JatTmf5CFJOc+gYdD3B1NkEH2ry/VJ9E8h5yNEiMxTkEl4STHU8tL+XkJ9ntxQPDwSZp/1c7Or994aVQsJEzvDGcqFrmxXfNHrQS7za2rA6oJ5Jq21h0DmbjV2rbdeomn+4Y+0AetXVdtGPrYK3Na9wIagNad6xB5JzgR2DdiLt4A3/jF3gIzNNtAi/HwaGQZiFGWfM31CatjvR5ibQJC14d1Bg3FVMwefUjRh2SwPNYVQdJXfTWegPR22gzo5PFB7ryJcL51Tkx2ufiFTqs3E2vto79dBf7fka9HjEl1nLuUxjxxH+eiivh/ic9CMMALS4q0F8ivicDU7hxj1bUZ0gxecVaG/VJGcKQtBJGQ7oGuka2cdtlLiqjKKWNNcvakp3688OgZo1iIHYugq96rfy5ijTJohLSAR348yUEG9HCHshmoRT1caE2f/9Hl4Eh43b5hLTlT/chGtxCPpNEMqMgm8W96KgYZpyEwTyPJ/yBFaGP2get3jWkTottWSjsXeu01VeyAhovNRW4JbYo8ST7j074VhcOIbR2K/aVLRNVSbfpQXQ1IlQo3ORTYhwNbqOB21eA/X9gsrk6yNdeEkEPuBrNyujG06YbBxSoe6k8
 Y3N2bpYR
 2cbWBPDaHS90Ix12Sqt9F/5lH4sGSr4gxSTpEkKMr3aC0DjpuzQfdcUop9Mvolf+gxty+fY4L3n0JTtdXMpUYO6w7aUoZMmvNXU0l5lptTx6DQU8G2Fwvp8ty2KUsyjhhcSD+/d4A1Iz5p2JXFuyEmU6a0MjYM2f4fTJkLHrW2Q3OfqOFS9VOOkDJdmcCvnRxuTFPQGNYeFgr1LWjs/Ew/HaXoI1lWnLJEDqEVqUgFEYPc6n/geEyQSKlUFm694MAeHNWQOtvO6c6EpIx63FGk38Pdbrq4Te/7JxzlSiXx57wMxbyrpXz7WIi2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/1/26 5:43 PM, Harry Yoo wrote:
> On 7/1/26 4:42 PM, Harry Yoo wrote:
>> On 7/1/26 1:53 PM, Harry Yoo wrote:
>>> On 7/1/26 1:30 PM, Harry Yoo wrote:
>>>> We can do that in pre-7.2 kernels, by teaching kmalloc_type() and
>>>> kmalloc_slab() select the new KMALLOC_TYPE based on __GFP_NO_OBJ_EXT?
>>>>
>>>> e.g.) Select the new KMALLOC_TYPE when KMALLOC_NOT_NORMAL_BITS is not
>>>> set AND __GFP_NO_OBJ_EXT is set.
>>>
>>> Uh, this is bit subtle though.
>>>
>>> In some cases  KMALLOC_DMA == KMALLOC_NORMAL,
>>> KMALLOC_CGROUP == KMALLOC_NORMAL,
>>> or KMALLOC_RECLAIM == KMALLOC_NORMAL.
>>>
>>> Just checking KMALLOC_NOT_NORMAL_BITS is misleading.
>>
>> Here's a prototype for slab/for-next. Backporting it requires handling
>> __GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_RECURSE, but shouldn't be
>> too difficult. Now writing changelog and going through testing...
> 
> Now thinking about the performance implication of sheaf allocations
> for kmalloc caches being served from KMALLOC_NO_RECURSE caches won't
> have sheaves at all

Oh, wait. I tried too hard to not introduce a new alloc_flag because
we cannot add new gfp flags when backporting it.

Probably it's just fine to simply reuse __GFP_NO_OBJ_EXT (because only
few caches have sheaves in v6.18) to select KMALLOC_NO_RECURSE,
while 7.2 can introduce a new flag.

-- 
Cheers,
Harry / Hyeonggon

