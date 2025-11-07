Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C1BCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 11:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F348E000A; Fri,  7 Nov 2025 06:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266B68E0002; Fri,  7 Nov 2025 06:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CCE8E000A; Fri,  7 Nov 2025 06:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03F008E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 06:22:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2FABB6A42
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:22:03 +0000 (UTC)
X-FDA: 84083571726.08.7A7CC01
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8ED7D4000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 11:22:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=YSACZscg;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="M 78qrt2";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762514521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRKQkj5K280R3b/RrHon4pbe8I4h4CIdOkXCqLolvYs=;
	b=3EFSM5mm1aQYtSIFd5HPTGgTKoyXBV/VxHzBtSaL1vIYUVtpDPQYRvbW0xmJ7X+Xr6BTk/
	S5uMlbKu+9x8FZlTlfiylPcJXBdZuV4iY0am8yN00i4tKUGwNtm6UJqJ87KxBIqs/ooBH7
	d6OJHH9PCueLnBOsJa9iTxiAXj6+C3Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762514521; a=rsa-sha256;
	cv=none;
	b=vSrTejxDRX6LW1MN8a2U5wZ9vpAncgzdnJ+c0Nz3SBOMN0Vy3PBJOUwqnvH41HUFeKTC2j
	zhXECU/34uFJf3aTTr3g6p5SZKGAmeL/tEhG/+0v4EkMrmT4ZNwxGW7PqmrNtTrL3BmVZT
	z5MWRqq3WwNic8yzQMjq7ETwE3LAaSg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=YSACZscg;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="M 78qrt2";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.157 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 7B7AD7A015E;
	Fri,  7 Nov 2025 06:22:00 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Fri, 07 Nov 2025 06:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762514520;
	 x=1762600920; bh=eRKQkj5K280R3b/RrHon4pbe8I4h4CIdOkXCqLolvYs=; b=
	YSACZscgaAE6zaTDRz48k1SSNuohLiC/LIJS5vCBdwVEksiOAW9hXZRF9YX6UmW5
	e1SCmj1oD92HAJJsyUIv3JkIoM92HHeFXaBp+24wQZQNYRLuXzAaHfixwUKErGbw
	FIfagbU5Kw1TMnrK6Q7CAtijwz26zrD2rfNtuYzoNGG0Y4HsSaMJJt/iZGdeZkH4
	MJkK9l6OZKPZAizsgxO1byy0HCCKjowFCEWbYJPqhCFjnxZeCRl7qnzjr/jNm/+9
	Rzr4BbS0ZObMiZdn8VxnhFN0tl1GCeWZDeopmwP9abqn70Q9hGqlmv/Lt38qzW9Q
	TkhR5QsqiHjIv/xvIgDUvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762514520; x=
	1762600920; bh=eRKQkj5K280R3b/RrHon4pbe8I4h4CIdOkXCqLolvYs=; b=M
	78qrt2shsLedihBiftY2LhN7qRl3wauqxpz6V1CkKr57MzP6U24Mu1DI272vwvSk
	CNTOZLp4iF/ZayE5PmwqM9VJXRzpZlS8SmLvewp5tv8EHRGubiEVp6OCj0ff0CSz
	oB0r6FpY44INpIvbH7E+tK+0tHIUFl8dEaa38O6VAXjkCtxtyOmC2D67PB641O9m
	NUpkh17fFzY2fjD/6lgZMFd2vIhIGwPRs2wKzIjHOeYpnNeVzx8k5kIPpGCVZhjl
	YRa8TW8W8OgQ69+AwIDkcbxQq+DnM3S8GXATiWjk53HAeHlUlrCiGpjQ376uH6Yg
	wV+bUEV20AvgAYljOWmnw==
X-ME-Sender: <xms:V9YNaSK_IhghXN8L53jQ00QmzximYoN-NILgwl2B1FfeEXKzbE3v1Q>
    <xme:V9YNaU_BagkvJMrbkO8ExKZE6V8-kFozxPFI42YU-Sgi84cSRHnHVdADxRb89UMle
    h_HAFRcXvY84z4uQWG5sAnOWzqyWKprZtJcbXhq4G3Gwf8XM9TvWqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddukeelheefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdei
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnh
    gusegrrhhnuggsrdguvgdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepkhgvvhhinhdrsghrohgushhkhiesrghrmhdrtghomhdprhgtphhtth
    hopehvihhshhgrlhdrmhhoohhlrgesghhmrghilhdrtghomhdprhgtphhtthhopegthhgv
    nhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmse
    hkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurght
    ihhonhdrohhrghdprhgtphhtthhopegthhgvnhhhuhgrtggriheslhhoohhnghhsohhnrd
    gtnhdprhgtphhtthhopehjrggtkhesshhushgvrdgtiidprhgtphhtthhopehlihhnuhig
    qdgrrhgthhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:V9YNaRYqUYbviFtiweRkZtz2Jet6HeK2Pg0GbaBrbRsG_Ey09fAAnA>
    <xmx:V9YNaY1lSA4xcLi1JpSVQ11yzMt7p-rLc7fXkSjzve4S1rkDKKG3lg>
    <xmx:V9YNaUrnEs1k8ksUNkA3ulWIEYfix-yWovCRmJvhyq7RCrVvTbKe7Q>
    <xmx:V9YNaXPd3CiHNXZlRjiZFuUJmWIPORoJpMgZ9tAEE3GQP6ao3JLX4A>
    <xmx:WNYNabx21bZOZhiGnjTHPd7M0uPDhPXMxH0KxkFquw05Yb-X4GzEwMqX>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3322B700054; Fri,  7 Nov 2025 06:21:59 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AvUhhSuyoH3V
Date: Fri, 07 Nov 2025 12:21:38 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Huacai Chen" <chenhuacai@loongson.cn>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Vishal Moola" <vishal.moola@gmail.com>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>, "Jan Kara" <jack@suse.cz>,
 linux-mm@kvack.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-kernel@vger.kernel.org
Message-Id: <0fbcde0d-4fed-4aa6-b0bf-c4400b9b1cf5@app.fastmail.com>
In-Reply-To: <20251107095922.3106390-1-chenhuacai@loongson.cn>
References: <20251107095922.3106390-1-chenhuacai@loongson.cn>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*() about
 HIGHMEM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9yu9n4474wp9yeqxrjejyu9hzxoieoau
X-Rspam-User: 
X-Rspamd-Queue-Id: 8ED7D4000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762514521-174063
X-HE-Meta: U2FsdGVkX1+jK1G/5i7RH718Qcbe+Oo+Rd9f6Rp2x3dRdAxCbr/h3ezVPD15kjSA3CBUCaRIg86c1H246QoBq5e74pqmn4JkVYOruDATAYb0D2WfeuHjnNJcok2zSzrtiqAP3V797MfjaRbqZedWPFvMBs8Kz5Mu44YnMquoygAxrJcbzLmSRIT2g4/MXlusp0iKvQ61iPPmV1/mOqYHSYafq6S5cvcA1JFxGuQMgN1wVmKToXk15ENQys8a4JMvbvGLhQojqZvU8DZUAVmCsK83RcJPW7hdXckgC48tU5xBxEeXfiIzBlntbyjW71H8F5H6St/BWAGAaxPDLuw4chnu1weZJkTG3KPSEes0ohLc82NUamILQmJHKP/JJ+WvFB26IqW3zlrA+qRz0lcom6uo4eLGSG419gO087e3TMd1/so1jk3Kd1K2ejlMUgDoH6OppNVZ2+n47ieMrG2d7D+udPowJs9nvzi7veOKoFPdTa+Cmbl81+0TE8igWCvDr5MnnoSIENLIefVlg1opNksgaqxg29658R+rYFgLllbUuAQMAe6Hs7m1pg30HYoG06+ezwit5t9+XF7M4eMx6fLTvGE4JFjnFSz4BdNhXXssxUMZ7oAbac7LJK7DTq7hG75+5KoYK723+CBpgBraV5VhEK1IekanETvZL+MtNrD3Rna8kl/PYp9kQVHxd4TymfAH/cJj2Gu3y9UThBnRjoemKECnnWpTKIodKSYBaXLvMfc+/J9wku43GuxGihhGOAQfqOPenouezQmq+pKv+l3gsDz/eDMPowbgDOYFC8DSezG1Hs7+A1yUdzC7yTwE9DxPyhWyz04gIpFAQKnjCOeiVF0HqsH7e8UOfU7GTemDVg8Dg1HcT6AUL/p1YqmFI54ZJKhfj/2e1ncnMUhghhmTcUePtf5SyAA6qf8PH4riBKTX9VXO0T9UvWTtBfKYW2ipmtslka0cQtzqQ6X
 393+T9V1
 3p57UNyX1nXC5HJPI4krQXZq0dwMteM/jddrWIjI+yymtQecxkyhhhGg3oaP+W7I2s/XNIuxUG/MuYkwUX0mwpNsUZpvM3wIIQfzPD2mGBDtRKsQphnclM3w0terf44PME7ZtlqS9RDRvSPtul8CZXADeDAtBnE5QF5020b0bTlGUW5lJQ0pI1UmZ6OC/O56irvpm13RZ+aSETp6jeYzoAGtYJDQje+CfRA9+nIhL3vQU7f2JAL6+7OlHkO3gFrh1wKsjwRW3ksdqLuRni2/zYzf2Pgfr9Vc52KOiLKqQILsJjFT89jrVRC1wCXztHHVvfEQQidTjXNDQXNoUBarqufVZUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025, at 10:59, Huacai Chen wrote:
> __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> as follows:
>
>  #define GFP_PGTABLE_KERNEL	(GFP_KERNEL | __GFP_ZERO)
>  #define GFP_PGTABLE_USER	(GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
>
> There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> explicitly.
>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> Resend because the lines begin with # was eaten by git.

Thanks for your patch, this is an area I've also started
looking at, with the intention to reduce the references
to __GFO_HIGHMEM to the minimum we need for supporting the
remaining platforms that need to use highmem somewhere.

I'm not sure what the reason is for your patch, I assume
this is meant purely as a cleanup, correct? Are you looking
at a wider set of related cleanups, or did you just notice
this one instance?

Note that for the moment, the 32-bit arm __pte_alloc_one() function
still passes __GFP_HIGHMEM when CONFIG_HIGHPTE is set, though
I would like to remove that code path. Unless we remove
that at the same time, this should probably be explained in your
patch description.

      Arnd

