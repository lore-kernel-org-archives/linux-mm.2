Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FD2DD10F21
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E5676B002A; Wed, 26 Nov 2025 05:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893D36B002C; Wed, 26 Nov 2025 05:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D04C6B002F; Wed, 26 Nov 2025 05:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3CC6B002A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:40:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1944B1A04AC
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:40:52 +0000 (UTC)
X-FDA: 84152415144.30.310D507
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D9CB140009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:40:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d wvu/2P";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AmjIeswK;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764153650; a=rsa-sha256;
	cv=none;
	b=UmmNSfv/X0dTXr+e9kEd7ItEgNy12s/pZSwytmamQl0mHkxRBgDQ98ZE/qCifyp8vWulAT
	w/pFbD36MKzB86ilIbGLtwjKHJLncVQbo5t5ljoXoW8ZdSgIef523kGb5+wC7o0Cq/cAez
	BuMg6ErzCf87mGmZsc2fMKOtpOVJSdA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="d wvu/2P";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=AmjIeswK;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764153650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3WJHbONId0OTb4mrCarJ73S7Cl8PGiGgiRaNnNQc4Q=;
	b=Hbj4KguFV79HSB84tfDJFZZG4FBeb1CVmhamnSMauOsAMdzdZQBkyunqzpEhZMfOEI+f1J
	0X7K6LEruIxGTd+C7EWOBYjn/PGf1F+/T1dUSxWqXMyqBSYPXL6Y619uz30CX3rbZevZGo
	T2+bB9p87Y+VUoh7aQMWaFfeB/oatMo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 7BBC91300356;
	Wed, 26 Nov 2025 05:40:48 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 26 Nov 2025 05:40:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1764153648; x=
	1764160848; bh=o3WJHbONId0OTb4mrCarJ73S7Cl8PGiGgiRaNnNQc4Q=; b=d
	wvu/2PFhF0gaST14BQVzRC7LC1ViJzRFrdd+n5VKORhH9Kc72urqvZrlTXf/haUp
	kWRzWh7Q7sVTgdl9HeXZtAE/bBXHKLN6iEPQPkQxdFFULOvxXvhM0KktRDeZ3VrP
	kyEXB7e6D4+HENpNgEGVuSPP9ENZnCzuLX4KHOH48JvOQWJup2k3enDE4fOrOcgY
	cXunlROdOpjtQWauvbaJsqdhtIK2RtPRj0eveRTL/nTKQtn/2Zxl7MscTkmYjpOd
	yPB6rW5ka2WGrCMKT2xuUrOB/gbHtkaSonMmPcmpCDGcHA3VlSUshbpgw3PIsclp
	SJeqjRl4pebD1TPDS67oQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1764153648; x=1764160848; bh=o3WJHbONId0OTb4mrCarJ73S7Cl8PGiGgiR
	aNnNQc4Q=; b=AmjIeswK6eGUVTwZmVUGx0szng+oG3AHIdAr4j3QmSkWWPjeI3e
	CmotR5EfGToD/FXr9JuIFJ3tiQKjJi2+zUSwHsn8carDhY2M3Nz1kE1SACnA+BXM
	hQ2VTQdyNrGDmMrTcrZRfGMeiA34rNqvruYjGyje4R1TUMfNaAsBEg+4gYQa5hty
	POJqpuXAGEj5hZ8WAt1AKICbnEIBlgoQj1tXyac898gVcy0ciqoXhE8MrM/Eqdio
	IcAPcTOQoEoF3gsvohS3QNF4aOy/Ccku/1iiZsQeZqwOjokzWiQF65N8ERx0QwdM
	XmU+YfvM+IZLoQ/DRMYXEP5RL/cyjCawakw==
X-ME-Sender: <xms:MNkmae4h2GL22JZhxMdRuHXSDxl2B-MRBJJZy96oboPK7XCwIhnBdA>
    <xme:MNkmab2NFL6r0VSLC9CaEeq18ZvvY9UUgx-dJ6dWCUOaQUAe2Bnr0-uQ6uDEajPVe
    OSEZUbPwvDYjjwdl5viQzB1wueU0K3N0upzmc1o11F1WvkdIJ3gOg>
X-ME-Received: <xmr:MNkmaV9nET-9Xebuz10mAJjRBn57L5dGRR4ZorrJEHDt95PFNGa6EOS5Q-3tkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegudegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvse
    hgmhgrihhlrdgtohhmpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htoheptghhrghnghihuhgrnhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehgrhgr
    fhesrghmrgiiohhnrdgtohhmpdhrtghpthhtoheplhgvihhtrghoseguvggsihgrnhdroh
    hrghdprhgtphhtthhopehthhgvvhhlrggusehmvghtrgdrtghomhdprhgtphhtthhopehp
    rhgrthihuhhshheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrghnsh
    gvnheslhhinhhugidrihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:MNkmaUtuuJwqx9aPieBdeG5xFsMyUPgdoKWCDRoOZJAl5jt-NAtXag>
    <xmx:MNkmaZqqivO8GVSEWBETwrUY7Gi1-lSNZhQFvLl9PDwFccpEWisazQ>
    <xmx:MNkmaXERkhhJwQKrvt8LypKCV5gvGPPn9fgNgWRcp7achcxkLHOJBw>
    <xmx:MNkmaU4Z-hMEkvTPot2_dvtGLd3ioeCWlnXQfMXcRexKP82w3ijquw>
    <xmx:MNkmaePhG6jLbsLX2F3F6DyN9g-oLsyYOYLwtS2pgJ5K24ajuaRomkfm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 05:40:47 -0500 (EST)
Date: Wed, 26 Nov 2025 10:40:46 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usamaarif642@gmail.com>
Cc: rppt@kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	changyuanl@google.com, graf@amazon.com, leitao@debian.org, thevlad@meta.com, 
	pratyush@kernel.org, dave.hansen@linux.intel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memblock: only mark/clear KHO scratch memory when
 needed
Message-ID: <md65ppfkqim2kepsx6igvezpcnr4hx3g2dxfdojsgx4rligwfg@u5dejfzmirfc>
References: <20251126072051.546700-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126072051.546700-1-usamaarif642@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D9CB140009
X-Stat-Signature: wkk1j58kw6jegu11d8rrymdb1br1syn5
X-Rspam-User: 
X-HE-Tag: 1764153649-947995
X-HE-Meta: U2FsdGVkX1870mCLXeUy5yPrnC1CuVYSXtMppQb5zZibWhVGMLuEPNaMvRSqGrw154i/C+ufOOpSWsh8YOLhVxkx87qVPnlfCcxHmOZxmh1i84Yi2QrvAntTxHsucnj9NGtPJIceOLOn/czn5qIJ9RShZ2ecSVCTzMitlb+AWWU4Fi9PpaMIjoJd+q3f3Wp+45HlAxkbdlginNpkP1FjVwABj+oK5vGTPhno9VJwIaN1V2/ztdCHTqMJqOM/5lGptfJ1B5lIhkO1lBayMS7h7pv297rmZOOXFx4hByG9/fInAsOWOkVVTo4WIbZZR5wsgsbe9tFDFIzawj9hsLPf8c27/tgw4pObRxgbnbta1OGxTTfGzraxhRJ7yI4/0PIcf6RQBom3NP/MOIZRZJK44n+8ydxAj56gYhzIRFKx8PxCEFPRxbsLpfWgnDurdub87CQfD6AgTDU2p3Uc7KDu359cbx516ON/Iljk9ZS8rTdS90OhossmkHuQBdVllY8xtS+gRmBQldx2roiYC95SPlap7IYaBBI3rllxRlBxT1Lp7ZN31Z9zQnH0mdca/SEC5gZh5nni5j3qUOmpBPtLf77eV0HVau/e3Yxc4ET4n0oF91gostDOI7PEdYqLuXHt9HeadPLj1uFs9ehMORg2vGVWl1Y30Q7XfHAjzajMiMtdDOEc74Wik8sx4g3eev3Ugode2RkWkk5+Y2A2Vgzy+UzCTqon8a8/iCIgv5My7Hhl/WAiL+kRDtm6xO3ErOb5umMsvX/Iu4Q6corkq/Z/DFMSTDNHYbv9mdnlEp++G1B++4NoXyMhdkkhTLAoNit7rvXkQ7A+03h7WmRtjm9mKNGpTu19lb7LeDt/unAxIfg/ZqHFpkwnkz/h2hKS7EQD3RHBxmZLZ//fGgtZukDWvgupo5rRDLCQupYl//xXar5NJ28+ir2yqBPGWds8EUChGZ01mR64iIUwWW0Sldi
 Wj060v0Y
 lRx5xQ/Eokvul2/IGF9GJTDQYj6A+xClVsV5h+bDszCLsqIggORBpw5V01L5UqA2F9Q/jv4QNTwHkIQujKrl8zQQSk4pWYk7RsWk9+GGngR6Vp2+lZBd+bToFc9MP1W5ZNWbq/Sa2WyJVduDBHbnwq9Ksdjn9q0DuVdPal00wAwY/qcg8TfkrZ8XWKJYD2MnEaatZqxeMc93dHXz1wW0hKejpJW6DL7uNmKNZqTD2pgqcvrtUmJI+EXK14We4Zo8LIRDiPXb7PrgKBF6WE9N4n2qnCZIlwLMSTzwQtzAcO/XL5dGz7nqpOjxzEtzJ1+xjKrmeQTxfVNyt/ZYF+ObC4q9RMCh+EF/MS/PUl3PzOpJqmsgJ1YnTWIv/J7sIXIjuCdgouGARlkI658ME9sDTMbWWJR+pXBNP/oe1XT1QaKiF1n1lpywK8EgR2poVqb6cnLHy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 07:20:51AM +0000, Usama Arif wrote:
> @@ -1126,8 +1126,11 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
>   */
>  __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
>  {
> -	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> -				    MEMBLOCK_KHO_SCRATCH);
> +	if (IS_ENABLED(CONFIG_MEMBLOCK_KHO_SCRATCH) && is_kho_boot())

It makes me wounder why CONFIG_MEMBLOCK_KHO_SCRATCH exists? It seems to
be a proxy for CONFIG_KEXEC_HANDOVER which is the only option that
selects it and does it always.

Can we make s/CONFIG_MEMBLOCK_KHO_SCRATCH/CONFIG_KEXEC_HANDOVER/ and
remove IS_ENABLED() from this check? Just is_kho_boot() is enough.


-- 
  Kiryl Shutsemau / Kirill A. Shutemov

