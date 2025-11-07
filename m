Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 557C0CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7448E000A; Fri,  7 Nov 2025 07:50:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F3C8E0002; Fri,  7 Nov 2025 07:50:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9949A8E000A; Fri,  7 Nov 2025 07:50:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 891FF8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:50:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25131160401
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:50:30 +0000 (UTC)
X-FDA: 84083794620.20.56C43CB
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf13.hostedemail.com (Postfix) with ESMTP id 384FA20005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:50:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=qChaefVE;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="n Quoyt1";
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762519828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3C46CBmXvkNh/lNjT5LsxgIlwhV7BbbpfhRABJ49noQ=;
	b=F20P2pCGa0Zl3HGbzgtynE7byymkyVyy4iwJLgkJWQBf77yrE5MraDsbgBSGXi3C+G0a4B
	dJCR8sb00tSua0kHHJQ2d2OpUvzSJVaXTYsqsuFkT8NJTUwfT7+0GclnvVXQrXF56+GN2m
	3MTqZwfTPH0ph19GPHLCmqqPMhKX9EA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=qChaefVE;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="n Quoyt1";
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762519828; a=rsa-sha256;
	cv=none;
	b=WSgonc1DoqWT87xT4KSwhCGL+ou5ezACzIqf0pU2fOjmq6g3oDOZQ9wH5qjcFbc1UcF+Pt
	loBH7FtN+UMfRPQAcx7/r+zxy+eitMNTisl8CDMkzCY/bw4UtJciIeK6ywAeQuFG9yOoTk
	rJbsFuD8M7otDqYPFwzB8eeVHuNuC+A=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 4E452EC02A9;
	Fri,  7 Nov 2025 07:50:27 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 07 Nov 2025 07:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762519827;
	 x=1762606227; bh=3C46CBmXvkNh/lNjT5LsxgIlwhV7BbbpfhRABJ49noQ=; b=
	qChaefVEsgOZdf6lVF15n4ab38MYqDzr1mqd/5XHKwbiMkHaV5Dpmq9lC6UY3nvH
	NLLARRlbmvHW9qvCr5nkfH2PW/80SVSWwScra/KDzw++XDKmOT29+VjlGRyMvFlL
	O2J0jgHOUHpWHpUD2Zsxi9m6yURAuJGKcE7tFkSHLIPRjuHb7JjQ3S5O5OpOZHWZ
	rhlMnpHKan2SVqGuYZBOSEpNsVqtdD3GYqeXAeh2XXXX1XPQnkZSV7zRxPZCFbRe
	kOf7OnxwwSvLD8Jtztvr83sjMCdAmxmEpaigTovocm8YROIPRKSO6ZFP4IyIJ4V6
	dNbfXrjQqpEwBuZUe2p9xg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762519827; x=
	1762606227; bh=3C46CBmXvkNh/lNjT5LsxgIlwhV7BbbpfhRABJ49noQ=; b=n
	Quoyt1GkFfWLYSqEEnibICGaxv4GhAWsUOcAfICcb+O6WBR/Rlkdfxz6OdjmAfdB
	+LX3ULKcF+9kpM4K/OBBoEPadUP6+BkG4nktOdyeElK5gNvA9M/Xh0RjlaQW8ZkX
	BTZ4xfJsqKxvwLt+HTDiFYApHblC5GL+CCAkFUXtQH0u+lpj+g/I0uk+Seipos5P
	WePnZlT6j3JCKl6+64pc12MltjukZ4KKBY04u5DN+fiNyckiRZouyYQf+U9LJ8We
	DFC51um+oBHVlYWVj1Ob/fRXZgBjhYAxo/HQfpA1Gpa7IBxxYRkVc2IJRFFMf+LO
	GxIpaiwqrpos5Yz2WSKbg==
X-ME-Sender: <xms:EusNaXe9cGgx0dI-PeJ5w3StTzQ9h72ZQBBez2U254nuiMPPCA1eVg>
    <xme:EusNaYBpfHkPJWs8qd_EnBU66ZZftLJQviuvpfzUM8CC1xpKlEycwVu-LGnVwH980
    C6p8jhEg0RIu-L8JoeqJmOZRJd0nOQW_1jSIl_T94WPXQ5fYw2r3As>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeeljeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopehkvghvihhnrdgsrhhoughskhihsegrrhhmrdgtohhmpdhrtghpth
    htohepihhofihorhhkvghrtdesghhmrghilhdrtghomhdprhgtphhtthhopehvihhshhgr
    lhdrmhhoohhlrgesghhmrghilhdrtghomhdprhgtphhtthhopegthhgvnhhhuhgrtggrih
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprg
    hkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlrghn
    tggvrdihrghngheslhhinhhugidruggvvhdprhgtphhtthhopegthhgvnhhhuhgrtggrih
    eslhhoohhnghhsohhnrdgtnh
X-ME-Proxy: <xmx:EusNabR-hy4dOJ6b7ZA8_OFZ906Sv72CGyDtu6rj06WnoCapJDAqAA>
    <xmx:EusNaZf2IH8cXFinuUPh-BfmQ8e6WYQh-EMZSzWReoRJff04oWaKnA>
    <xmx:EusNaUuLtn1Ywbkws_-PhRTvfwWOoFFn5Kdzpe5Vu10hRHz0PJV0-A>
    <xmx:EusNaVKkyJhqbpZVHw5r5dtgmXjTIEYS4wun2GGp7vf5IzK2kWW1Zw>
    <xmx:E-sNaWadqPTvujXbbeGKAQETVX3PdlND9csF6KeOmKufF6lgMZO8MUNA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 572CF70006B; Fri,  7 Nov 2025 07:50:26 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AvUhhSuyoH3V
Date: Fri, 07 Nov 2025 13:50:06 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lance Yang" <ioworker0@gmail.com>, "Huacai Chen" <chenhuacai@loongson.cn>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Huacai Chen" <chenhuacai@kernel.org>, "Jan Kara" <jack@suse.cz>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>,
 Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, vishal.moola@gmail.com,
 "Lance Yang" <lance.yang@linux.dev>
Message-Id: <f0efca40-aa3b-41ba-a8e4-c9595c19778e@app.fastmail.com>
In-Reply-To: <20251107114455.59111-1-ioworker0@gmail.com>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
 <20251107114455.59111-1-ioworker0@gmail.com>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about
 HIGHMEM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 384FA20005
X-Stat-Signature: 5bzgy6cz5j4xznrptmtjfxtrii5m3cdt
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762519828-342459
X-HE-Meta: U2FsdGVkX19d0RkXrb1ow3Cg5WvHzG6+swVmL91y4wDs2Ke3xU6y1liZ8+TwHQLFzmzt3TRHyoSRQzfObvVOjgFoRO1oNBxplRpzWglDprqJg5ObT6fdgJk/9IzyxUkGZ2O89CTmdH1okI01utgp0xagszAtuLu+BzEpgjxL1PMj9BanRBU+X7pzI+QnpuBiV6pcgZ1eErw/J2yaJYdYNUubZckOGeDybjVxesKbpiidyEUko+GzsRUMJ5auJf9WSdZ7eK/CCTGzVtDAnddkdOiU1c/o8UgjzNZdG7+fpKMwK7P3bUGwfdT/SJhrNB8TGwI6nvZm6POA9rlXWTVpHLb1ir3a9du54A015mxzVf0Ac2chDA2een/Lcq6yZVsVDcnDGeYNEWyA4ccahc/UxESpv473yIhxXwUGeIhU0lSRJAoQC2rqRxtSi8xCwTdKp3DwLxLUePc5FhL5/NAMx3R8ixDyXuSCVbi55t0nTRYfD99F24lI3OBANaTRkUEpJFuMzK4m2d9+gEZjLoXtKX6sZdoqkzOayGsqMU1H8zFlCFF9cRYu2dNBwLQlcihnanqtN2Q+q1P9ODVYSoBIrZ7MsMC0UjIKjuChXv1uTjfVLle2RWjeNsm4xqPSaLrIhYmV/eu8RVsq2mlkvw6fQaQRr852caML0nwRuZ/YTnh6MLLVx+b/pny3tUUXL5g4IManzK7M4/XQT5ge0B7hL0jXXPRMBVE/55SLVNY5JdkPl1XKFUHuZYlQ8hh/VoO4V6XqhYbl4cSc/w25GksSv0wBbn3zgHVQ44M/sUOOIkw44Pf785rDiqrTdbBnN5HnnOGTx0RMnTgLu5oeQG7PDwftS0D1f8bBzTGWGs/Q7lMnfmGnIWF9s8jhXW6ZKFxxj4R+yH653tB+HXojmmt008Pab8HiMS35nNMTL017H+cw/E6sS7zMgB//3xdcdoa7oo0AzUWkT+FeTortmEq
 clr/2fYE
 Ob7qQpzoty0bSw1Vw6kijLqY5W5PEOAjR9EvoyE/j5H1nq74=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025, at 12:44, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> On Fri,  7 Nov 2025 17:59:22 +0800, Huacai Chen wrote:
>> 
>>   */
>>  static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>>  {
>> -	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL &
>> -			~__GFP_HIGHMEM, 0);
>> +	struct ptdesc *ptdesc = pagetable_alloc_noprof(GFP_PGTABLE_KERNEL, 0);
>
> I looked into the history and it seems you are right. This defensive pattern
> was likely introduced by Vishal Moola in commit c787ae5[1].

Right, so not even so long ago, so we need to make sure we agree
on a direction and don't send opposite patches in the name of
cleanups.

> After this cleanup, would it make sense to add a BUILD_BUG_ON() somewhere
> to check that __GFP_HIGHMEM is not present in GFP_PGTABLE_KERNEL and
> GFP_PGTABLE_USER? This would prevent any future regression ;)
>
> Just a thought ...

I think we can go either way here, but I'd tend towards not
adding more checks but instead removing any mention of __GFP_HIGHMEM
that we can show is either pointless or can be avoided, with
the goal of having only a small number of actual highmem
allocations remaining in places we do care about (normal
page cache, zram, possibly huge pages).

      Arnd

