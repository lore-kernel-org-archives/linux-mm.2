Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7969CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42AE08E000C; Wed, 22 Oct 2025 04:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402688E0002; Wed, 22 Oct 2025 04:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318B28E000C; Wed, 22 Oct 2025 04:20:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 206F48E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:20:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6A5714043E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:20:53 +0000 (UTC)
X-FDA: 84025054386.02.FFA411B
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C836180002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:20:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=RQyNv3R1;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sR7qicZ9;
	dmarc=pass (policy=none) header.from=kroah.com;
	spf=pass (imf16.hostedemail.com: domain of greg@kroah.com designates 103.168.172.156 as permitted sender) smtp.mailfrom=greg@kroah.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPC4ZvWHoZpQ0FA8oprvgTzvGpj3Enck39VjaaCP7LI=;
	b=LpONRv3PurPt5NDtzybICK3229LfjWSSG3F4wM9bYYLygKaHt74uA8RQdKwtBjDtFZ58Op
	fsi8uBmpC8HunaYJcz79p1dBBfUDt0+NjgC+Yl48GlnJroHiOdMpvxLz5hYbwVzkrVeTWx
	VcUbzypQzrFU6U5f+++31sQpxrbOYLE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kroah.com header.s=fm2 header.b=RQyNv3R1;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=sR7qicZ9;
	dmarc=pass (policy=none) header.from=kroah.com;
	spf=pass (imf16.hostedemail.com: domain of greg@kroah.com designates 103.168.172.156 as permitted sender) smtp.mailfrom=greg@kroah.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121251; a=rsa-sha256;
	cv=none;
	b=chFkpF1uJ6g4EWznj7bwc6RZIPEQn7JvqliBv3X44wLdChICPpLMG5+RyMQsF5gzQ687V8
	3Id3Ln8IJHHbyUldOtORkYYToAhUt4tIK0vpRaVE5t+nIHJiQEcy1XMgRbKsI+uZwalIOE
	7qP5cf4GZFBdQtK47L4LAZmgYlMSiWs=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F27DE14001C9;
	Wed, 22 Oct 2025 04:20:50 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Wed, 22 Oct 2025 04:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1761121250; x=1761207650; bh=uPC4ZvWHoZ
	pQ0FA8oprvgTzvGpj3Enck39VjaaCP7LI=; b=RQyNv3R1jkBd77W7ENqFkirfuU
	cvaWR7yqOgTuIVWKZUutJi41URla8X8U405KaHff63bl/kFDHR7io4U4s1gQqEz1
	dmjmv57cZIRMdOaSxMGRArYAubdpv6NwxdYL6jp/2/4AzSSQqVTmp4g/5hl/jFRi
	JsZWOKUyZryxPp09q0MK4Cj60gkntJG2D0F2u+lRIwe4T3oJ7PAeHMcq774KhkBK
	bEXUFu9TlgcBr9zAbFXxZQY3hnRaj7dzLEdXtQN69yfeTsRU3CT4P76RHXaBgWpm
	RWLqhWg1vl+y6COKrLoJFJkNTb7Tx1lbeSrI/OwUcWG6rpCmUsL/XpFBeNmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761121250; x=1761207650; bh=uPC4ZvWHoZpQ0FA8oprvgTzvGpj3Enck39V
	jaaCP7LI=; b=sR7qicZ9c5PnxW+VxYyhsnP9XcLrBfbc/awGfiyJDlmZ4UHqarU
	KozeOSwbOBDi+3zkskfFYy5+zJLG9OTChHYr0/4cv+83vAKFg3suBTzr5ghxGS3n
	RLnhXtUVXnAH9h7dlmqYwJIoIFH0k3LriH2f38vLnyZPnPtUBJBFSFCXoKYOgNmO
	jBmqBJDmqZq10y7vSKwTOyYafFD/GA3DsZWE0xlAB7eCssbWF+omWyQx3smsw5HD
	AZ4uwvFcyAtjUQVQOdXscwtROzO2218zvdjUWt+DmZibLqGKW6xsx5O3ePlDD8qV
	3cNAhZdHyJPGg6OZTcAiMaw5z5ohIwkFIQQ==
X-ME-Sender: <xms:4pP4aK8jqEfwKOq4EFFZBmz3K-FD3wSscM260pKPItpWa-DaRmxcew>
    <xme:4pP4aDcHI9eeDxqEs8dpejYouV14ZemsU65zAqAo0eoAD-I-ann5s7HGASFKmG_MP
    011lZQSNc1MgNsJIxhkVCLtnW0kctQEQK1D0_MmMsUqwXA0JQ>
X-ME-Received: <xmr:4pP4aOubuLV5MWkdsyEWlQONJmp9r48lo7ydBE012OtTVvQ8XfNNCC_I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeftdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvdevvd
    eljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhmpdhnsggprhgtphhtthhopedukedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhgvohhnrdhhfigrnhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepshhtrggslh
    gvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhig
    qdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrth
    drtghomhdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdr
    tghomhdprhgtphhtthhopehshhhurghhsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghr
    nhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlrghntggvrdihrg
    hngheslhhinhhugidruggvvh
X-ME-Proxy: <xmx:4pP4aE0cbiTkhkpo-euO6Vi41z_T7p0U3KfwGWeBTBGyi-kv0Rvi7A>
    <xmx:4pP4aDD6AekSYOMRUnqF6CarAHHdSQ0FrRTSh433D9lMfKOvhRCeRw>
    <xmx:4pP4aBdd1US3YSz3iNE9mnIDaovo72ekHpXk7QR5YMlYQJaQ92jPPA>
    <xmx:4pP4aFxWVdmYuQJJMnATsZurVvtofp8g5wbEo6ATVLcQSLvA_2prXg>
    <xmx:4pP4aFM5tPcaZAiYWSNb-vGqUe1nU82BwY6lkKdReyMjRZp6sGJauPjH>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Oct 2025 04:20:49 -0400 (EDT)
Date: Wed, 22 Oct 2025 10:20:48 +0200
From: Greg KH <greg@kroah.com>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Message-ID: <2025102210-detection-blurred-8332@gregkh>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <2025102230-scoured-levitator-a530@gregkh>
 <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C836180002
X-Rspamd-Server: rspam03
X-Stat-Signature: pp8q3d4bcq51mjm6swaw31mutrwgmc5t
X-HE-Tag: 1761121251-164630
X-HE-Meta: U2FsdGVkX19mgClDXdbMgPHtkmNHtllXjEeRgH2MKAWByKts6zs6vD/ZK1mtrvFcBQvxLCmhJ4/HGB++tFf9E2ZcXACh39siRXqeBA090epCC61Rxr8hzCah1a2PjiYu8jl9/r5w0Ck31yHc9tqkA7mEEva5wJy1SRtPDnmy+x6Il2u+EyP0RfJyF3pSZ1kyQ7ob1fk0/+XFn4VCULEVROncDPKo5KKkiZK1b8wkAJJKrP80me80YbNaosrz+sdWcQtd03KTlDHEjgUHKW3RGV95h7U4x+CXz8c8MaffDKZO3bWO9WBt++UzBzKV5IY7HkzG01tiihz2+akDkyLchId+Rb2LnEEvFjOMbBzYVqWrDgC+p5t6aQBt1Hy2lQVnDoX5IvsNzvfxgxrZfsNflMaZBkdGrYDbpgQfIVOck+2x0SjeKLn8o+d/b8wMxYidFzg4KmwHhtPVnm0Qh37tDShBJVqluFr79L7pZjZUAG37fkdzLYEVv8w1R5tUoQ9p3WEI5hqH/gsCA7qETXNDHBqVPT0K1DDvY2LYN/FbwqLJZGQcvgIhTKxY3ucAV6KtAU/IJUiQLQJqAUsVicVnnl3HXw2MgAwbqJskejYhM6Qnq5t0JKErnN6c8T7vlRY9s3OAF2qtA+oJwswbBB//7pe2giCvt6sGDph2PyF3TfNyW0PVHbFaJN8sDlsFFeP9bs4SNDxmod7vovB+jW3DBjNqVas5XrFO284j0lmSw61NB7S+EWGRTHviBDyGt/fsEw2SJcDUHhMbtpNGUkBeiIrugL+snRpIzsOjZ8BVmourJLUuW2ysVCFu6sBX4xjd+9EIRGfPfH0tliVx2KmwAwxcBLPt6KoMPHDH1YbjXxifARfcv7KLZF0IBlwTgtan3fhqzpTfBl7sDycUZlXitGdFruBADm+l6JmNi+A3AXmbsyI1BlGucP+Fdqf+wY8rmmEBNAHURvu1HTBFKOO
 wO3ML05V
 cF/OIwpRHEXGb2Yo1dsC7IRZ/lT8MKGOKUFPlEDBVMknAupucUC3nG36iyOuaEg1ayFJr77kSKZjMrw3c6lfmxBEcR8faXv2rFuvWsNCWte1IIR7Z+2JZ7QklTqtcapwDfyP+s6tEqtKY0Rfs4h9++ovAz35cmdapVQMPbgvJ1LvkeMFCYvYp/CtwsoTbeHi1izB2uHXLFHFGBmP3zBhRbgJk+x/0Zc3R7X/JTw694NFN4tKdTxY9Az+EWvUI/Tk/0IHkKQg5+JWk1B3G4/kglU9G8pLKm86hbUns+33La10RQSLsUh9l7f745IvCy3zpBpEzmE2QnHEeTMKIK9AuUKvhmz3BnlWjHgqyqNvzHzwqkMn+FMoHshpNKEeyxrJ6+v0iAIKR8+xxLgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:08:45PM +0800, Leon Hwang wrote:
> 
> 
> On 22/10/25 15:40, Greg KH wrote:
> > On Wed, Oct 22, 2025 at 01:51:38PM +0800, Leon Hwang wrote:
> >> Fix the build error:
> >>
> >> map_hugetlb.c: In function 'main':
> >> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
> >>    79 |         hugepage_size = default_huge_page_size();
> >>       |                         ^~~~~~~~~~~~~~~~~~~~~~
> >> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
> >> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
> >>
> >> According to the latest selftests, 'default_huge_page_size' has been
> >> moved to 'vm_util.c'. So fix the error by the same way.
> >>
> >> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> >> ---
> >>  tools/testing/selftests/vm/Makefile      |  1 +
> >>  tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
> >>  tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
> >>  tools/testing/selftests/vm/vm_util.h     |  1 +
> >>  4 files changed, 23 insertions(+), 24 deletions(-)
> > 
> > 
> > What commit id does this fix?  And again, why not just take the original
> 
> Let me check which commit introduced the fix.
> 
> > commits instead?
> 
> I agree that taking the original commits would be preferable.
> 
> However, it might involve quite a few patches to backport, which could
> be a bit of work.

We can easily take lots of patches, don't worry about the quantity.  But
it would be good to figure out what caused this to break here, and not
in other branches.

thanks,

greg k-h

