Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFACEFCC074
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CA46B0005; Fri,  6 Mar 2026 15:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4065F6B0089; Fri,  6 Mar 2026 15:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316BA6B008A; Fri,  6 Mar 2026 15:20:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 223836B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:20:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB36C13B72C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:20:30 +0000 (UTC)
X-FDA: 84516755820.24.BF6F291
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf14.hostedemail.com (Postfix) with ESMTP id CCF5710000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:20:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g 9fC+Kz";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=umbMP8h1;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=377Iiy/2vhfVMCk/VUi+y/E5TjBXp6Xa6UY+t1Y1TWM=;
	b=1L1ikgnnQsLrM5/JRcMkpKXyBXSyQWAd/MVT3dqYNVHGjgBj9MZCDR2IM9yXGfiKHHXtaG
	ZG1IKaQMEG3mCJd6ueViLLIZfnkkWqP+hiXG1Yzjy8qKe7064JfQ9wxnlHdWSa1ONOOjSp
	/XFhAVha/aBblA8/NyX4xtHyobCo7pc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828428; a=rsa-sha256;
	cv=none;
	b=nAgW9+7nYGhF+jPV7ZaNcmY1HAwKU6imZrzM0NBYk19gfMIuqk/lw2t0nV2jYwxSlEjsKV
	TWsvbGPmAsEMY1oSEqtzt4g43KxPJYxBT3YHk8YT/2zWrCGM/ZNPakGlu8AM0w+nL6Rqmf
	w3OHCZaJLGgAs5m+7J1PBzGAnE7Eads=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="g 9fC+Kz";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=umbMP8h1;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 3ED80EC05A4;
	Fri,  6 Mar 2026 15:20:28 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 06 Mar 2026 15:20:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1772828428; x=
	1772914828; bh=377Iiy/2vhfVMCk/VUi+y/E5TjBXp6Xa6UY+t1Y1TWM=; b=g
	9fC+KzRYeUJ0aQGPuz3NL9oCfZt8u35dONToxyZP6jnrCyaM/8eP54E/2ij2gMEm
	Y+VIOLwaB9eZ6jwMMfZVStoBovK466Y5q0xmBo5ua9Vpjx2t6DfkqTMM8lEQEYDH
	G3H2mAXT4C0b/bB7tkzMiWm0j3Yv3B1CEBsm/Roj5hO15gXuDHwGqIo53JDC1140
	KfuTLbwO5jpQPrY4C1BAcHcGy4ExMrKGpBTKm397OurbtY89GOh4IsBtYlGDrv//
	3UtNiqL49YvWJ/2qhAxiXsEyZeLzNQIYesAjwiLuugFPCMjbpdzjrb8xFJ6aF/js
	mVAzyrmotIv90WfsEUZzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772828428; x=1772914828; bh=377Iiy/2vhfVMCk/VUi+y/E5TjBXp6Xa6UY
	+t1Y1TWM=; b=umbMP8h1nm2bsyUUAIt0U8ykWvIY7Cxn0AOrdbf1l9auM32lcvj
	aEuN6Q8YtO+qO6hui5fFDAsdmGXgvcvxUx/G3tDd8KErCkSDW87HiCxniMVoVm8W
	4MtqlggHHl6z+ivhbmD4JXo2kccHbMwxIrPyK2oM04VyC+9iLqMA2EC65rSx4MKX
	SOEr0j7hRKJIwolGzx8m/FmnoyKgQUagJcJN8PrLR/ylSUbmXOI0cfXJ7pesuec/
	22AltRrxTU1eU0M9QSnODL3acmVsSzHNE1x3Hbo3KGSMrC2vMnFyIRZZdWPqat+Q
	+kLTC3izGtHMYwBYXsC2uSwA+kivFksXNTg==
X-ME-Sender: <xms:DDeraf-SWXyF3tgPQoVLqr4qkOSLuBh6Qo8v7JsO8-Dkeu6kZbuplg>
    <xme:DDeraaPuzvAMMocPp33GVWdZfcyXM9bvJYya49Qrl-1wHSOUicp8klt4nypQDvwQM
    lJvPI5FtXN1lG3eaVjgyqRk0LdgTCFIWc4_IEaZJ4yThZDmagWSn3gy>
X-ME-Received: <xmr:DDeraT0pwkDnJEEMBBM3qiKFNkkH7HiXRp65IlGqOcFFlsIa_Uor4nYiYTkpIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjedtvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegtrghrghgvshestghlohhuughflhgrrhgvrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopeifihhllhhirghmrdhkuhgthhgrrhhskhhisehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvrhhnvghlqdhtvggrmhestghlohhuughflhgrrhgvrdgtohhm
X-ME-Proxy: <xmx:DDerabeoWr8rr5r6z3i8Pri8oYx6fZC1nyfchwWaCrrHoFt6OO5lcA>
    <xmx:DDeracZ94ff_KdNbwGjqh4C9Ui6tdaAwvvnGpxDL3bKzGemt8_bUpA>
    <xmx:DDeraYXvwgRYGKcq4gcrdbHiTol7o-fLV7MQzpaBaDCrT207DAUg5g>
    <xmx:DDeraXR_ei3OMJVubNO1jsLAb59RHO7rT28j0-zBHECUYLPYEeHzpw>
    <xmx:DDeraRZDqOfWDBSHmud6kCPdlDueRwdxK1vc4ZJockTKSmlWT61aiw0y>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Mar 2026 15:20:26 -0500 (EST)
Date: Fri, 6 Mar 2026 20:20:21 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris J Arges <carges@cloudflare.com>, akpm@linux-foundation.org, 
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aas2lmQtqW2tK2u3@thinkstation>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aasddOvIfcMYp3sk@thinkstation>
 <aasfxLYRWzNodAYO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aasfxLYRWzNodAYO@casper.infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCF5710000D
X-Stat-Signature: oowbsztfy3xnuuuumiowa51xrf3rbnhh
X-Rspam-User: 
X-HE-Tag: 1772828428-685029
X-HE-Meta: U2FsdGVkX1/IbMpRvYcjBmZDIBGTiE30D6SeSOjVk83CHBIl/81a6jiVeN8YmkEzLX4pTljcHS6DQFaoMF4gK66eHGsA33bWmo8/Z6f4VFHuVQl5w4PcvUpoBM8Y7XxqD1dpqT3b83C/n77UuGXrzvVUFmj61H0QUi/+hk2o0ANM5eQbcf79uCkZpIXzhWjNZetZGonw5iRRl5pFPFZgm1uCRAT7b9YZ2eBKwsLNSymkrgsm3IVc4al5rEuP1ics238Tyi4BeqVuFvYkiLL6zrCf3PRDwf9Io17f80J7cBX7fCdkaxrdQJuDah05oLZ1sNyzl4VGPMS8dvMdahP9qAA/UHKNBne5Wc7dmTrze6siuhBj4Z47k9fQjdZuTG7XZKEFQS3acVP+BYouEQXPskNn/NSqDAt8odZctsfHopxJNSTplHMOWwXp+2dydR+zHj8ITah+sBG7i2DZAsJ8GoQxkPg+rE3Sn7NEtPCy7gC2HmjLYlvxB6IAHVS2E3TuxzUoY0EXPYFLd1ayR/sjRsyeH7eLJKoVBo93pCyONAFoj733RENUh78ZM6vqDSoKj1z21ixftSY6ikcOTaOCBXRSFHyzmnAap/uWJKzYpa18Sg5s+GDjtFulmSpFa3sTDdn3P0Zi5kp+q3g7fMrtI1ObIkrZh7ukVGFMmeoaDSucl1WNYNpKTgvrrFbsjVCuyzQotVmUj+iZX1Fdz3yK/7GAWrd8JnPgak2nk985OQxX49GWobeYVHg/IRpr2kskWyucqdMXbjHem17qwS7zHVGv1iWUlGlyx6BKjSsc/shlFbU0C4hYjCpCP1J+X2oVD0wGfoPPcuU/OEgTBXveWBSmo+wZHvhJil7fVHuG5T6Z3sui3hCxhZ5V+wlzEAoWHr+xBJK7+gIEnSnOD3NzcoRIGxB7arCNMWSLCIYcV3jkDmOuHYpS+e0d0EOwRbOooR5stZp6ZAJCpuSDt0Z
 K6C2ZC9Z
 4lkFdzZr0lTHbNzRmBG/RnrY/p7OXrG8B8bQwqZRBKTnwNpuXW2iHvJHvlRJkTc/BStxVUFjbGZkkqsARH8er1xs9zgODeRqds+i3f0Skoe/+K39W+BV0xreJmOYelkB/E11Vy7/QLqbbst0hqBy5dDgo2QehzB7kC/FR+q2zAGLxy5ikyN3JIKF7pK3iky5lrSvqptmCeAb6HZ8Yg99JygimikHF5XH948utBVdB2hOVpJiz1e3FWoqc0NQCyBMVxCgVfKFRML6QThn+U7t8hnwkuJkDXfEnK4xxivRV0TZ4Y3wWsVKwhu3INcv3cGEumvHTHTTwmM43BrxUFlhnk42BhA41uJ2qLCJ+g1n7ibzpOGNbD84gNB26BRLkniZuuRjOcCXSFnKzZ0hpbImUYJYKAgg1jfc7M1uk/gUXpBWLr8f/SH5NGjszCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 06:41:08PM +0000, Matthew Wilcox wrote:
> On Fri, Mar 06, 2026 at 06:36:30PM +0000, Kiryl Shutsemau wrote:
> > The proposed change doesn't fix anything, but hides the problem.
> > It would be better to downgrade the VM_BUG_ON_FOLIO() to a warning +
> > retry.
> 
> The trouble is that a retry only happens to work in ... whatever scenario
> this is.  If there's a persistent corruption of the radix tree, a retry
> might be an infinite loop which isn't terribly helpful.

Whether the problem is transient can be useful.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

