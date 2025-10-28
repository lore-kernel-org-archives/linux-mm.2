Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682D1CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EE0801B4; Tue, 28 Oct 2025 15:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF9280199; Tue, 28 Oct 2025 15:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F54E801B4; Tue, 28 Oct 2025 15:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C11080199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:06:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B30413B3D8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:06:12 +0000 (UTC)
X-FDA: 84048453384.15.6CB0DEA
Received: from gecko.ash.relay.mailchannels.net (gecko.ash.relay.mailchannels.net [23.83.222.66])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F506180009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:06:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=hAAyE9YZ;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.66 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761678369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7yMuFnXzZTs27rxsR5yqI/BDHOQRZQBcgCQ/UynaDY=;
	b=OQVza7pZVZ1ZI1uCQSH/Wc+ia9c2/qQHWS38L4li7TKKlWS0zDogA9rCO3Uoo0N1APiRYq
	uMDaC4SmwGJJbfcKGYwBcGuuvjbwT7iBO9GL4vX/uONYalcRWX0g4rNazOuFGkZj9U20Iy
	A1POJln02vjln/czjtrrJL7M3KPLN2M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761678369; a=rsa-sha256;
	cv=pass;
	b=d8loU0hArprh14nlx3jm5LDQ6XOFEgHbJUp2h2iXeTqbS8dTj6oRU3GB1h81Wt+sya3qgk
	ASgz5hieLoRW59V+T8esA1dYseGVuf4P8EfQuPjH7wMCyDvb/bzVhXmej13j1PjSjWJJDX
	AY+t3qR0M4xiohHyDAzfon1hy5OufEU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b=hAAyE9YZ;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.222.66 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id DB16E703A2D;
	Tue, 28 Oct 2025 19:06:06 +0000 (UTC)
Received: from de-fra-smtpout2.hostinger.io (100-118-36-217.trex-nlb.outbound.svc.cluster.local [100.118.36.217])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 684407018F7;
	Tue, 28 Oct 2025 19:06:04 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761678365; a=rsa-sha256;
	cv=none;
	b=WKzSYiTEvfMiWE3kWZ0gnq6Lj1QDPi5aePwmcnSH8SzIGimVUsj6bP0sPKH2iXsd/q4QPl
	KmDLjmJp0L6d/FnRbMvQ8hiVHcrz0vpkOtm4SE/1OrB8eKzQ8smcOJD2kpj2kolEe1jd8h
	ZJ1eF621KuFEFLDThQPhvKTOk4C6e9EZT+OtH2eqtBjllbpT1TMJRLLjBR11v1DblCOCH0
	mKT98NV+1t5VOXQhCWQNvE6DjmMX+0upfOQZ+554dGNLUeMdhy10N6VAkJ3Czpl+e0bLcs
	aV7+cEQtF4b9DgREtxpsUGj7K4HDy6q84FsmHMaSySdFnPJevVLzp/uUM1Wj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761678365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7yMuFnXzZTs27rxsR5yqI/BDHOQRZQBcgCQ/UynaDY=;
	b=VeZ0Pp7WUdG1GPG4NNcxdnmIZ0j08AXw87uIsPrYAsk0ck4GGjIr6AUafBkT1gj5Pd3qaz
	0Dgkdqh1iZ3l3TmSbhDdD1KQRCSNJbaGT+xvVlq4oBK5E0YN3PCBeC06e+L9g9pDvP8l9X
	8dNCqbk5Wq+kevHK+lPOnWrZ4/wH1AtnnmTj5jQzZVK5sQDiVtsycVtKjipZ4x2xkAFXVa
	9x0n7veiNbPQGU3man5h/lTwys76v4PtywS3yp00nrry8faG29BM0rj/1gVEqOfPTKP8dD
	LpBbWu0L0FPgvkFFa4HQHTZoqgASOV0d2z2p7GkHhJIYjiykYCyR3YHCvr0WzA==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-6ldbt;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Trade-Versed: 44c630e95ed6652c_1761678365765_1624956607
X-MC-Loop-Signature: 1761678365765:230569200
X-MC-Ingress-Time: 1761678365765
Received: from de-fra-smtpout2.hostinger.io (de-fra-smtpout2.hostinger.io
 [148.222.55.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.118.36.217 (trex/7.1.3);
	Tue, 28 Oct 2025 19:06:05 +0000
Received: from [IPV6:2804:d59:8970:3b00:5f26:e2da:68e6:2358] (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cx0G05f3dz3whC;
	Tue, 28 Oct 2025 19:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761678362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7yMuFnXzZTs27rxsR5yqI/BDHOQRZQBcgCQ/UynaDY=;
	b=hAAyE9YZBFJ3sI2e8h5NgrMvFpPAht636ZAKxj9t7TFgBRDgGiasYLk49ZnVezObFRF1Pr
	aLqnzWpFIP4mYIvSq553tSV+Ixl4lkwqKw4JRPi5tWRQUoeLECKOGAbm8etORLUtKxxyCt
	0/vxTO7vMFFdrmME7ybQGXX+tsieR7F3tc2cP14mrX+pwNuFbCt/gCsUfY+8SHqlsLz2Zj
	IugmjvIyXh5G3aMyesBnyR3/2YeJLGkeURoyBqyjaZY0rb+/JjmbeG43Op78qDpJxjhSow
	lPCWFW0znP4bQWstBCH8BEUdJxY791QMkBNvPqWn4k9getgX9oNPTYPJPprB3A==
Message-ID: <7a46f3cf-3256-4179-8ac6-25223908480c@israelbatista.dev.br>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: Omar Sandoval <osandov@osandov.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, linux-debuggers@vger.kernel.org
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aaff172e-8fdd-4ff3-8161-1c7afb1f3e64@israelbatista.dev.br>
 <3873b85d-a8c8-472b-82e1-2751c6fef3b0@lucifer.local>
Content-Language: en-US
From: Israel Batista <linux@israelbatista.dev.br>
In-Reply-To: <3873b85d-a8c8-472b-82e1-2751c6fef3b0@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Oct 2025 19:06:00 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=Ceda56rl c=1 sm=1 tr=0 ts=6901141a a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=1xXcZfXGjt39WaqPgXAA:9 a=QEXdDO2ut3YA:10
X-CM-Envelope: MS4xfCWsKzO+MIZLG4tJPcBkExWHQSwr2NmAEzHTyhaUlMc3dSRdwvGrW0qwZwguU21Y4EKCZSwY1k3W3Okha9lHih0K+s92a/kQ9rGlkjwO5JYpES+6toRU 5RjY3NSyNsyzZ5wtZO53Uh3K9YBy5Pu8yKwjfsOJPmyOmGUkyma1kc2m79RDLElOu0TjMKdAeTWdqXBJsXaq7yxMIkEWR6+Qu1CuII7Lb3gy0zRtxI/EWK3/ UVXW93tTX/llLESPLHhr/oSATlvM01p9z2FCrMnMetfROwQR6JhbZKa8eFhVGYmrYXNFEZ+qbQCazdR/GYnAqERBPmXgtjKpF/IUhsHKymsVhnjqHFSAhRz+ MVTKGNma1bExUFYnkqlZBzpdzqgyEACPeXQktrphqP4tB5r3Tk5eNec1Ol+Kk3/0/Vd3JriqOwMpIIUm+5KRcL0fWM4nw43amwjyccm4U3gV0FdXhWS5ettF hfi6uh5J2c7fpC9f
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F506180009
X-Rspamd-Server: rspam02
X-Stat-Signature: 91p3r1r17cnu3ftd3hnxs7bei1frureb
X-HE-Tag: 1761678368-572016
X-HE-Meta: U2FsdGVkX19JvbXk76sPiESc/KLBioqmgadcAPcBmnirXN550jyud+H3QCunuXfyd5xImTgCIQ9iNEJFOfR2czo0E2Qf5aq0stUoBQY1hN/2yUaemic6v44NLqEAa4KlR3oH/UhyMwFoXP9OLUZbyRWVeut4aBGIOI7RKG6BPZMp88LUGirPnNhmJtfnVkYOM7GPF69um8YKNeoL2wj8sS4zrDvWAn/bqOkxeDYk7zPPaqGmIq0wPu2mFa8mFA3Va+HGlUqxnT1A69uyIXG6RyAELlXl7jNsMFArZ6LLj3ypySYsvH8118kQ8Onq9tnUzsFmGU9wf4lWLlJ9NXGideC+e8iA12Flnqw+M+X4yZTzyEBnY/BKSUQdqbyryN2dFvyaZLntTSPLsUeKzA92WTeV581j+4nsNXWCBDqA2ayxJCzNaiP9wNAE6GDhYN12OB+7YA+LK6oWfpxkeuh3b2Aqw36pzPL6wk6VW6k05t/WeIw0+YgUy3ieDudibVehf3/QzBxCsbtScn/UGkTEgMAbyqGic+pL+QncCeJ8leS8aY5A20SvFk8t7wT6ICJkHiT6IMFL2zXcJlhAMbzCat6q7c+Kdy+zo2s2cl6k5kxx75L5iuASwhyzA0aZ/mMXXM2o1OfH0rSMg2ZaEZiAYWrKD/xDBOw34Gk913TD1xUSK2vLWvUMlxtPjGQ/GkAg4nvjV3clSmkolP2Cx6+tsErzEIhr3l6uWIWXfnU1YHtEVr1UwxaAIelVheEPQ/UHoh5s15y1gDXPS3xlhbvrTJJR5cMSgs3/1JeRywBC6qSLs6SLgd7FMigJuY8MH6PSAlD29psrbCZS+lO4yRSPyaL9SSkDRua+UP7DrdXFAenx1EVRex/D1sRhIGE8N8VbVqxPRCD3URU5p4jiQfNVm+HpzWM4RE07/usXqxnl+ev/JB+kW8BJahUFc5Gxz+XgIXSg8nu5Ej3cNWHle9H
 SvN/6hFt
 t7FPVloLHfii3ZJJYzbxIFr2HAcDwxH4f7dwZMDqkuE6/LOpdmAggnrHi/qb6ioCYZPuZf3pBggT2ClI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000833, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/28/25 13:34, Lorenzo Stoakes wrote:
> On Mon, Oct 27, 2025 at 11:53:57PM +0000, Israel Batista wrote:
>>
>>
>> On 10/27/25 16:46, Lorenzo Stoakes wrote:
>>
>>>
>>> So why are we naming the type... does drgn require it?
>>>
>>
>> It doesn't need to be named, but as David pointed out, we could find
>> where these values are being used and replace the type with the proper
>> enum. I quickly grepped the codebase and it seems doable, I'm probably
>> adding these changes to the next version of this patch since there are
>> some things to fix anyway.
> 
> I mean we're getting a little out of scope here but fine, if these are not
> in fact used as flags, I don't mind, just remove the silly 1 << x values
> while you do it.

Could you also point me to what tree is preferred to base the patches
for the mm subsystem, please? There are differences between linux-next
and the current version of mainline regarding these values.
(MEM_PREPARE_OFFLINE and MEM_FINISH_OFFLINE are being removed on
linux-next).

So I would appreciate if you could indicate what tree is the best to
base my changes, as I'm not that familiar with this subsystem.

