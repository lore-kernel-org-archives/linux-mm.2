Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D519606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Vk8jcUbJ
Received: by kanga.kvack.org (Postfix)
	id C63226B05B0; Mon, 23 Nov 2026 18:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13F26B05B1; Mon, 23 Nov 2026 18:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B298D6B05B2; Mon, 23 Nov 2026 18:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8379B6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:05:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E907F12075C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:05:10 +0000 (UTC)
X-FDA: 85467916380.11.A6ED1A1
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf01.hostedemail.com (Postfix) with ESMTP id C871740006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:05:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Vk8jcUbJ;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf01.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.153) smtp.mailfrom=fthain@linux-m68k.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795475109;
	b=wjthNZBF0efCxIJV5yArY57SWwsDL/FetpiWPFeLIwuBC+R8g8OkzfA8S0KxCOtDRstEQK
	mfP3CO2EoUONC+Mx6FBaSG8hAss1/9JtE4CpPByX7OWoBDjhg1XkxS41raud4mHp7Qn3K4
	ezRuBeknTDwY2bUZOCxC7eP5wLAWquk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795475109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBvnVcNyDPy2jbg+2CO4h/31R+00VEIJXbUaelLpP6Q=;
	b=UwoZSafThLF+rswNMO+Y8PSfCb1lyNNyuX6mSV+pfiywQ3ImOh/87wdARNktMNsNdaY2fQ
	nIt3QFLJjSdVbKjWf/FFbJ/XUSXl+kZvxVgb9UaItPP0r5Uo1+VNZYM+XqzjUWf/xdZ9Pw
	k0mOak5Ho89hkP3untXGiNZkfrAu7ik=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Vk8jcUbJ;
	dmarc=fail reason="No valid SPF" header.from=linux-m68k.org (policy=none);
	spf=none (imf01.hostedemail.com: domain of fthain@linux-m68k.org has no SPF policy when checking 202.12.124.153) smtp.mailfrom=fthain@linux-m68k.org
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A69BE7A0633;
	Mon, 23 Nov 2026 18:05:07 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 23 Nov 2026 18:05:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795475107; x=1795561507; bh=RBvnVcNyDPy2jbg+2CO4h/31R+00VEIJXbU
	aelLpP6Q=; b=Vk8jcUbJhMnZxk0jtJlzAaUX0A9w4moWpDR8BTr5OpQc1v7BZ7k
	tpw+Z8MTPezKz/8AG/ws95/39OzlGp3hZSInvrvbT3kTn5j8xRiFy4TgBRcFRJHo
	qdJYrMGwAHAO9yPKgyXlAAKBAYRgfkDK5Wab/Sj6gdMZ9qa6yvZm8xKOBIRc1dQw
	KOEbbAnTnXp4qPWXDiYAT1iAYu/WK6Zkt1TeLnNx9J475Y8FQaaKpTI7iQigkeXS
	UkGGW/+y4Ie0SKg4JH9kuMA3JsN7ifN5dS8sFegM4OyxhfMu5+t4rtvonhSHTYHq
	/Dhj1Kzzz4rl8orSPs3i4HEV15y5FW3mH+Q==
X-ME-Sender: <xms:osYEa9eGu0zy5rDZzIpF17Ee6uJi2z4w7C6m-xj31i8HsWa0fiC5aA>
    <xme:osYEaxMLNMBGuKAM1BtIE-5b2rRomgdBalTU4uGDg4Fjv3f9qyowMrMNAkjDB2qBA
    V0UQHZiEt6O6rinC4yv6pr8ieAlc6is_6nZvEbzykQ7-_Bmj3o1goYq>
X-ME-Received: <xmr:osYEaxUyYNu3zQXMOiKcLQgBVjjySZTIDo1HEUlmkBsiRxUSLmYKfohge2sg>
X-ME-Proxy-Cause: dmFkZTFj8cQpLMgo8/MrajZhRcME6EZ+BUuZwW6Y59Xv7zUI/toTR2dglaTUfJQPxkzVir
    4aQOWtYh5eJ0BJjg7gk5xKv88gxEigcOuPF95e/tEPXIdcY3cCVkS1pjd+bq0pitdSJS3q
    uWLf9YDKf44ZzH7vEoFS95dt0bcvl+LLRFC+u7zt76NtXhVihMUK974Ad3eKNk8fWc+zGZ
    Nkn52V+ZNyfPLetCQ4YhRNgTqKJ7onI1IFnA1718Y0F+bRJHJpbOuTktjEUwSKLrRz4JWp
    /DVI/T4Yg/SxykZwVQyis3PCwdmTIOQ/yBfcYbRfzpnB1sge3t4QE8zE+aH9+liL1bwLko
    57D10mUeUaPcqMs6EYdQqHxY/HlAkVcJMetU+jTv6l7siuVta/h9Uh584maX9VKNKwUGaC
    dkld3GG5f/yUTrmtJLVJPWb1IcHK9ks+2Pk43YpL3/ATL44Q/CwafzaMBi8Ud+Hb8Dn1Qq
    dVgil0lCu+nlISzpiswwkEaViW4Jn+IKhICFEXb5ME0Uwe5Dslm2mSVEIbQMdB1Z7jJIKl
    gsk7SsSb00FxwcWBijh18p+yzUgieWdQnru4nbQJQ/NGCuXWi+lJ7unFXM3UNKn1PNCAML
    egm8mAU5Jdy/m9sQH2jJLWWbSXHBlCyhtv35PK2N+nw85i0MHTzEorW7lh6A
X-ME-Proxy: <xmx:osYEa5xBwvi6iirRatahRe4gJcSp2kQFUKWB3UeHgH4kRuSFfC4CXg>
    <xmx:osYEa4_Z8r49e8EI3aAVdENZZD7HxaRzasuAZk8ofjiuYX7KyKA6xQ>
    <xmx:osYEa--hKXGSP8Mm_elRXZmwsw5MYkR1X20wzdkFiO3MmMCAZDDf6g>
    <xmx:osYEa3Xw2Bd_XNLXdyDnxEA5iZNZIHV173o4swEKnorMYc-o3YO5uw>
    <xmx:o8YEawGfcQh_CaUjpgdK6vW3xCMlDtq_VJtDeD2we0_TG-SvkSkNOCMZ>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 18:05:05 -0500 (EST)
Date: Tue, 24 Nov 2026 10:05:02 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Arnd Bergmann <arnd@arndb.de>, 
    James Bottomley <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
Message-ID: <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C871740006
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: qyps7ds3scp81ewt3pe5hhpxddx5bzf4
X-HE-Tag: 1795475108-630951
X-HE-Meta: U2FsdGVkX1/Nhfvro8POIU2j29dBSs9guwYltiW3KtWPWK7oLzc2o1T2n0bP8rBBSFpC49Mg+VsoOLL++FnU4WjstdvzArOYScW7+0cdBVwQ3KNKvmLqiSNLBTxg5N1uD7T6eTN4knu394IZrrd6lVSV4m/gsN3cFR+HAIGCXmAvqoTGSqujjJE8xJWhFdy9thISmaTBAIjxbbUqeC/E07ffiTl29OCB+V2jxkAxK1/kdtEmWVbi01UscybBAK0p8JwKbu9c/8ihe/KlU5dpA6PihVGuZiPk594wZwWqtIURtuPP9a+LCfUFuXgTloM/I0yUEcpUVksZ+BCm2t61ptWuFemwpTMKlKusn4V8RKBKmzroS0yKUUMwXnlwIhb0UeXA0TOtQk7Jq3RW9YC3D6iurkALyDFnLeCCtCXePjfnvlvm2G/5eohyd/aKupMjOGSfl0XiK9m0SSVahbhOiw/dFdxAedWcFBJOpNQYkDYmySCao43xkrph2zfbeaLuwFNqsHfoeQrilH+2iUAvQRbpzXCJxJ6D7ahKEzBpWIociRPdJjSOziIrZlYwJTxBg/q3W/JyYMsJ3KBE7L+HNykWFn9K3EoRY33ZmZ/dTqa/y5OEQNLbqVCIUlDkBVABqOn5wswDkzWlsvvKnQUxP+uvsbG+pHyeExYhFAfuZ6ABxkydExDnq/IdqNhJIgECapTHuOon8JjyOCZ/xDu4yYVcu+hh3ygZYZRTJ7538dzXyLXWS4XgVdjjGPTv0GQx1bNuvW4xXTB1zDWPTLGqbUJHABB+Ziv8VOFsMCFy3oee2miCK6297fvbCTanMV79aiJRPra9B0uaSaCEQpspH7HnqP0B3ZzBKOZMXjNUgv6Lf/TwmEqHOgMupyWotkg9a0kuEv4SMhB20Fpx1/f5ZjNMzj+osNehyD6n4It+aiQ/gWrFAxQzde5TbzX20nATAHeMgcIfaLdtbntdvDx
 9mza0Iwj
 A4oqcZM5lNBl/cIlrZVhlK/f1RAvFaYfAJMl9Gs17Oi2ZhAOQ3NyVrBd02J27/xjtLY/4nbO/LFRElw54Z+gTSK5Xfp1Ff2sKS9f2ItTR09TboN3gqApVNObvXPXZ7WcOdGAXwYIt23a8ThE8OrgluuOYt4csc9DePpfa7CRbpiWNIeZCG3tKJHZWNrBO0huUOXQt8DSrjq7Aa0lb5IweRIAlq+B6WU/oPTGn+hTLZ4zRT0UbwqsLeB6exSwcuJwMKJ3pReQWaMqdViHi2K6atEFtnc8sfRLoK2WUZZIQ0CFgHPm+UKCfnG0v23FnkJqc3Atfnppk1wggjmS6eXuqEDyPyVdfucfmEEOOuU9QsjTR9fmGvysMjNT8/Bd1DK9lsEaSIHoXHY8sJXeP8VhKhvQTCmtj4AabtzE8ghi6Tfrb7bnpaOTEhnGk2BtETisN0reBVdfAsVynm2tq82MXJZVvE0Oj+uw4PYoC23Upj+ReFnla9SrxEXrh+IgeObpJpjGKUv1x9TKhY8BT+3hJRn9hcEJrtHSdnqEEoYXmw1iuGLz0AgZGYLcKB+MXU+aIFHpn3h4twLXoyUHpP0KwVm93Lb18STXSDYKVLItTixYwv2ovuVPJTKMky9uAg2kDZe4WkxhKuFholsoo5BVi/lwXS+pSHwMISDglLiLzeWofhBPtPexzW3G1JKbnKcCXHcZOxc86QeOnAnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, 23 Nov 2026, Geert Uytterhoeven wrote:

> Hi Finn,
> 
> CC scsi
> 
> On Sat, 21 Nov 2026 at 05:10, Finn Thain <fthain@linux-m68k.org> wrote:
> > On Sat, 21 Nov 2026, kernel test robot wrote:
> > > FYI, the error/warning still remains.
> >
> > That's because the qla2xxx maintainers at Marvell did not respond to any
> > of the three fixes I sent. I'm not a paying customer so all bets are off.
> 
> That's "[PATCH] scsi: qla2xxx: Rework BUILD_BUG_ON() assertion",
> first submittted in March, right?
> https://lore.kernel.org/all/4808a5dc1a71528ffa3360868561009744277450.1791502886.git.fthain@linux-m68k.org
> 

Yes, two alternative solutions were submitted in March (either remove the 
assertion or rework it). The build bot reported the problem again in 
September so I resubmitted the "rework" alternative. Sashiko-bot didn't 
have much praise for that*, so now I'm leaning towards the "remove" 
alternative. I have been advised to keep re-submitting, and I will do so 
after a suitable back-off in retry rate i.e. 2027 or 2028.

*
https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org

