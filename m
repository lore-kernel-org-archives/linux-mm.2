Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015D9C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6656B009B; Mon,  7 Sep 2026 12:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA36F6B009D; Mon,  7 Sep 2026 12:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2B16B009E; Mon,  7 Sep 2026 12:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A34156B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:30:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B30B1601D8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:30:24 +0000 (UTC)
X-FDA: 85187503968.25.EED35C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 803881C000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:30:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KI62XHM/";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYQA4jeD0DIJnAW0P78qjwDpNlErq0X6ckTCGSBrwCE=;
	b=TTe56tslcN51I78ZDZyJWcgFEN5rMKOzwheJbBsTAG+U7xy1k/CDWTLcrviinc3A4igMhq
	iU6kT2kBrAiKPJsD372CT/zyxZFsNQsmIMjU+3Q6mR2Y7sQ0NgjplFPUhlcVwh3JTH+daG
	E5iwf1Y6la3nzTXbCu9ovjG2IsSMpDQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798622;
	b=WOgwyB/fX/Z2tP0u9E4BlS98AlYXobn+9Z35Ha0tUcDjdjof0m9JutIxCsmZ+7y99uiGca
	btMu+NdwFHIRe/ZQAFYyP4cyxq7U+AEhmHF7ELET1JPxsrLqkT1nKRcwjEmT1I68mOHwLN
	hh3NEJJsfJBW4u77l9ZduIsxTT1CCcg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KI62XHM/";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0E26601DB;
	Mon,  7 Sep 2026 16:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF721F00A3A;
	Mon,  7 Sep 2026 16:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798621;
	bh=TYQA4jeD0DIJnAW0P78qjwDpNlErq0X6ckTCGSBrwCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KI62XHM/GgSlqq9owo7p9GRljeRJwENVHuSPu6fS8Kl04az1Sb242UsyNOKb+j4yN
	 ZZi0zcm8jQiNsGTjz2F6fRaAzU+TKsNUNm+PzC62GE/aHpaq6UwPqGqxc2Y6lfWGzw
	 8fOAhd9L3XYcD7ps5jP2GxzgfafQb5GNI1pLYcEFGNwa4yOuT4q41/5/NIV6bAf9Fa
	 dzsMQwOxbasMZ1trntTM+bbjwTqRFjeDxTzw85ts4FwCqtPSEh7RY7ypcCboomKVmw
	 Bm/hdu1W2T2NmbCIMF7QHMQsh208+sNp16Rr0HXynJ2r1S/ce+oZdiAjjQnk4wFxz/
	 hviFuc2R5p80w==
Date: Mon, 7 Sep 2026 17:30:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Cedric Le Goater <clg@redhat.com>, 
	Saravanan D <saravanand@crusoe.ai>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: bypass THP tuneables for huge pfnmap
 mappings
Message-ID: <ap7mZ1Ktd_rRRrdX@gremlin>
References: <20260827-hugepfn-allowable-orders-v1-1-94819c8807c8@kernel.org>
 <DL08J4JGJ4UK.2G92WO0NK8XU3@nvidia.com>
 <apEzvfGgsvbc3vBI@gremlin>
 <dc52dd1d-f62d-4278-ab4d-95746383fd50@kernel.org>
 <ap7i1vLkfZj4rbNM@gremlin>
 <4743f22a-c24f-4f93-80f5-3260f29bd410@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4743f22a-c24f-4f93-80f5-3260f29bd410@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 803881C000B
X-Stat-Signature: urfars5ndi61wo736wcdfmtguki9f8cg
X-HE-Tag: 1788798622-561878
X-HE-Meta: U2FsdGVkX196Dt93t07PKfFm6d+lFIrgMq1UFcAJb7ilkT3ERVNuLGd/XVPz6YOylUid8Mmnvnyk84W5bQv7zapIVU7NnF4pyxw2TyAV5PeI3bEkAC1X5ECIspBedA/rB0jUk8rRSp94cssVOB8AB3c4PqsNt7lvYjRQBaxjxQEG/6LeGPF9CXvZvcUGkBuVj1SGuHArBA3z9NXc05y/y2adGVQrJdmoAyBhaTTMEf3A4IazOOI3ocGqzBFDzR1Z3qu0CU7tkN2he45F6TnZTdc37w2Hzcf4cOlqJ2BhZj07ldMeEMNjkRTInmg4Vcf1mjPNk97znriVhoE6uIT7Gb0K4SF0TjGdJplsXFxIHmW5euZptyWxF06BIEr4UdIFZlaw+eYU7ObsFXJMoRqW2qb/BdogWvcjDem0rwePOnwDPqujQKGCyGyb5BlpY2+Q/z2/fufDCOXdNaoPId68eTlQ66f8bKfvruJF75ARW/m1x9ZcevihKWMkpzeSYQYRu3n4KNiInnKxYZAIhiSKctdfaCuBTkauQWo8jndy5+PggGzFTHFyIBRdBGA+yRLpOK8aF7sAUsaiw5LoxkGpPHSw5h7hijwrPZZysA5vTjAPAxDwjA+eQBLeMYrVutJi/WWotaq+yhiK2kj4c3qPEiBAMU477MHpObwKWkoiewbaMkC6gfcc0BhMEgvZuPJAaj60g/GNVqKIzWEuNqB61JuJ9JXBMtdG10X6yp0JLf/C6TUr3ViSlXIe0xpmCrlUkxBkl57y9lsyWLIX9ZPK3h6ZMJh+G1bJBytarHgSepk4ZMDIXN9bdXElq0ZKKtBhjKcJkTIjaImqtgHc8LKYdQJZep9rsNj0nQMJIL354Hllkf1Jse1QyIW6g1qqQzHvf6NHVUzAMxt+6L2u4zPRIVENjL2BEQUMb5E/A9fHj4Sv7Evpj84GdBvXgySyvUmoZ4PBLPaP1wt1KxGVBji
 bp0PXfSh
 wlJ6D7SxMx1o2aYVRU/yUYbGbZcaeIi2BXDMQkSSTAQCTaANifQ5oGeJ9QvxMFdGpINgOFgyg+brvxEngM4UOU9KcJqseYJhpai+X71HmXugsBXMPtXTaPIZNWQu5peLKs1thhHIGih7nq+si4K6RhfZwZn56VNbShEoHUA+S72sgDBNeoawxPiY+FGmQgBkcGj6ROwZ8a3Q3YA+RrtCTfKxIB0a14HMmh52Fcsw/8stsV0yIpv9d4CujrzbBVOei1+Ykm+v5+1zp7/9G/kesR8pqKSbWb+XAWBjYd3d9xq6bmuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 06:19:30PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 18:15, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 07, 2026 at 06:08:31PM +0200, David Hildenbrand (Arm) wrote:
> >>
> >>>
> >>> That's a good idea! Much better thanks.
> >>>
> >>>
> >>> Yeah, it's an annoying one as kinda want to say 'file-backed VMA' but I think
> >>> you're right vma_xxx_file() -> vma_file_xxx() is better.
> >>>
> >>> Andrew - could you fix that up in place?
> >>>
> >>> Obviously if there's further feedback I can respin as well.
> >>
> >> Just as a general note I really hate these in-place updates.
> >>
> >> For a reviewer perspective (like me stumbling over this) this is just a mess.
> >>
> >> Resending with b4 is as easy as it gets.
> >
> > Ack, you are right to be honest, and I do empathise obviously.
> >
> > I will respin these in future!
> >
> > Let me know if you want me to respin this to make life a bit easier?
>
> Sorry for being grumpy. With 1500 unread mails, playing Hensel and searching for
> breadcrumbs in my inbox is hard :D

Tsk, that's not grumpy, you're speaking to the king of grumpiness :P

>
> (I did see some reply from Zi to an mm-unstable patch, but not sure if that was
> applied in the end -- or whether Andrew fixed up any of that)
>
> I just saw my reply to my other mail, maybe a v2 would be best :)

Sure no problem will respin.

I will probably respin the RCU page table series too to wrap Kiryl's changes
into it just to make life easier there too!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

