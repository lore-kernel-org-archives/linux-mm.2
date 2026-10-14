Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44F31CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 10:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181286B0095; Wed, 14 Oct 2026 06:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E22C6B0092; Wed, 14 Oct 2026 06:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA826B0088; Wed, 14 Oct 2026 06:36:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C02466B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:36:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D7111204A4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:36:58 +0000 (UTC)
X-FDA: 85320878916.10.71942DA
Received: from fout-b2-smtp.messagingengine.com (fout-b2-smtp.messagingengine.com [202.12.124.145])
	by imf18.hostedemail.com (Postfix) with ESMTP id 394261C000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:36:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a xBB0Li";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WF726lTT;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791974216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9niRVdDofrrpATLDu24HuwcFMCvfPmKkgmurPmzx6jY=;
	b=EnWcT9jL+S2shI98IT5k5/4nYWJDRmt1pf15Kl7CRebNnitaTiN5ZvyfgYTqxE1n26PnGI
	n51pEHM5gIviL/rn9hwbGI4Eu3SwDyZGFyGpmdzkC9XtO1AFCP9if8FADHkgQNysDKSsjD
	a2U0HCQlfxbmwqS/sch+RFXDalxfC7s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="a xBB0Li";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=WF726lTT;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791974216;
	b=yTKYXGhPO6PNd3/OTrEr4Cd93sDLMLIAO8l+KYuO/1Bo+qiEpdPhXLVMhxF22nBOi6pzKM
	TwP59m6fdZEZOBIb/ax0Piwoldh382u9uiVkreslknJgnbVVEuaziKh/9KOVSiQLVUBQzs
	TgEkLuJ10I8MdZgfTU/ZBpeR0sGABa8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 43C841D0007A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:36:54 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Wed, 14 Oct 2026 06:36:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791974213; x=
	1792060613; bh=9niRVdDofrrpATLDu24HuwcFMCvfPmKkgmurPmzx6jY=; b=a
	xBB0Li96NsnZ/irHZ75FwB358ZLuiHr8HYFCThJqj+48/W78WxD6N4J2DvG7FeGP
	+rs17hKVtqdQ0d0QRICLj0NnJp5ki9QWpZFpeo5/MatMWd8ArMRQsGWXA1hc7IUK
	AS+0PAvKZXg6vZS2NnB7vis3t8kFRYfj0wYve9A30f1tYQXvFNFWCWmNMo4kTdqf
	yDfw2ryM+qWl3OC9gxFFNsN1ehtRG2MuLKMTkSEreYesulb3/JSIn/BoFdbB1qA/
	ePB70qA5OiYtf6pmfcBJqaz8FWzMShdFeQrcVomL7HeSpjYimJwvSFwlE6U52KAX
	rz2WumTxv0ZyNYNZ2Qcdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791974213; x=1792060613; bh=9niRVdDofrrpATLDu24HuwcFMCvfPmKkgmu
	rPmzx6jY=; b=WF726lTTF4TeXrr2DspNhoOkiBR+TxIGBRedtHiATcfLjapWbCl
	wayhOOc0WQRYK7e07I5Bv7grVrPhp6pDABeqqfktoxI60wpG/ZVZH9SNAWDLVanP
	G1Kyx2P5QopdMgCP4SMnj2OJeyEgyusUpCyuc8a3cGOQ89JjuMFz3dLjZYpILgjl
	fjESDeI9tyJGj6uQVb6ejmsO48SzhAqneqKoZVHAM41eyWWyXqm/yoITJkiwb+RB
	38xO84KYco1+HxmDJg8rU99XxSQdmZJI/6hR0dBGEjygAZxInr15UIRxuYa7TieD
	66ZCpXSsxwenJ7iGVzRmExsMlRR58cvcSWg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791974213; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:wGVv/YiNNaeZkLTBlOf7qnB8cZTUHPOdpIjEeRJ0zfJz3Fo
	2yyY/hNm64UTMvWvTSShV0BO4PWHvHm22p4+DzQOpGdYEZr4NQzUk5GsMDt76PlE
	RkIhF1YTNx01kN/rnbtC+3LfSH2faWYRWaQverbcaXBc5jZ8oW38rxIZoZPzPCFV
	+oDTb0T2SL0xseaFz79nfLL++MEow4U3OJeIgIX3qoI0r5Hfa8xzU+6NcsrN8KPb
	/FEdwDL8HzAP9dNSqIv5EUaAEX77vinHP2QiqNYgroWd2u5UJLkH3CqJLbHkLoWw
	JJ6ti6ncJ+46qL0o8yj4kBUVOZ7nJhtOSr1lo1Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:s40ghuQqRQ+FsRNKxrRGLcZ0CZnfAi2ZGMOEXRZlVAw=:Dxu9i3WMW4TKf6HMVitbB+K0/Ep0WTHU06lA/MWjVMk=;
X-ME-Sender: <xms:Q1vPardLtLdVCYlcriw_iTQ16Zp--NECrzF9Hhuai3-y2Y8QZB7Vfw>
    <xme:Q1vPatJlw_svcxr0gTzy4vlSHQrbWVfWvmO25hsqGRZDtY7Bi4ucGmSNVHoLUmURY
    SJcYcOES-4FBIshzufItqpM7GjU4wFc-BBd9sXdXFpCwMbXyIB0nTs>
X-ME-Received: <xmr:Q1vPaqqiJnxsX5YO4j2Pjt4jSqhc9yu5qdRR8_7C6Ekbcl99Sc6scDUNpuA>
X-ME-Proxy-Cause: dmFkZTFuONKeASOwUHIqNios3PKDeDz7a+w5ERMwBMX2xbkUUxN7LaQyAOnaqs2VvUULV+
    BfQDNCW8SlJYrZwGjqiW6IGrusOlnBvYQzTbbc2XBwNA9c+hwHRTvGTa/AkV2hu+b3xjcP
    BYC7+ccDzFGShUqc1XXiYtUdRTMbOt+mIciVRtXYd+Q8vbKlG3RilDf1jXWE3rb0FYTISG
    FX3h79NuctJRG04LoKBj4tPSiA7UMywGZ0r4DQahGk3YRWLO9FAC3k/o6HtcJhjA6u2tJL
    mL5Z+gad42T/BssNYShyuJi8iE80ahE4F5r0ENRGE3FtjmmQypA61x8HNAeAclMvm81ym/
    +hMQUKK7y7YbR75AoJxfxt/bM/3WXCP/VFW+GHN8B3NPhHIdgAAykimUB345Og0bdRPVSC
    0t53Iuq6/BkkPhHMkNrozZIMyos7bMuxPC6wCmixWDbIvOqSUU2HY1PqEQgSP8tbeqKH7n
    T3HyO3XeA0A5uEBJJyzNXPkuBO1BOX7tkLBh1bLk06/Pijtyc54V4zwJZTrg8u2361T/yT
    m5wFVaj6v8tegBBVmh1z5bmpDVtiPrL9zL9DhgNmz8NeUy+I6yFUZ/Sxhd40p5+VkION76
    IgVt582vhduxLyPGK5/NcbPrdcSW2e6R0sSVuejBmw+CZnIjDzWE4KkuTAEQ
X-ME-Proxy: <xmx:Q1vPajXX9RVVPga73Zv9kQAkvxD6Zw9Ao1bxZGq3BCYva8fUUj9hRw>
    <xmx:RFvPal3yoaAyHvt-RB1v0Dfg4rkSTnyzfHRGUfVxs2ztQpwlMvgJFw>
    <xmx:RFvPak1bmJXjmbM_naLFhTBIXSy82I28zSHlvWKqOEOJUVq_ECGchw>
    <xmx:RFvPakktgc8hQJxeLnwTgtwXGtOkH_EqXNlPuvAjszXl1OBj1HWGWg>
    <xmx:RVvPakqdKaLnz7LMdw0mFfAHfYpV620GwI-B4M8TBScd--cjPb-_mqHQ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 06:36:51 -0400 (EDT)
Date: Wed, 14 Oct 2026 11:36:50 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <as9af-Jd_rVZvMlC@thinkstation>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6ckC9NJVB8JBuV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as6ckC9NJVB8JBuV@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 394261C000C
X-Stat-Signature: oim83e9cakzq9hyuis8xqbg3eag7w94r
X-HE-Tag: 1791974216-900910
X-HE-Meta: U2FsdGVkX18hVr1pKVxJBByPOPQlPTwSiC/ACbVd7oav3toG2w1KsuRU0nyqokPjK1EyaLxUI4chgHiNQOwa02c2SccIIfVYySk27+7aghZqBMGUdH0bBsimO5tKUeBiPs9WLSX7oxw5++48gao+/eKtWnCGqqQXpPV214sYK9daXqPRjhCJ6cUd5bTGFpZdDnFn6CHxRtb/DT7LtuNWRub6GIz5jkOPF4OcO/IvVODRpLxVqtRztYEMxqoh57NMOhlpIIKZD2KSbH4dv3KWTL2UMcvmaw3UzGeiyqMpxolZ+hmcChjGclp17fMsMpTw5Q1szv28rndQyvB2HEaIuxvGfZly9g9//Jlbk6ofMoU58l8cUdrlM1j6xlSzABR73KMPcEwRn3kAZtXFuYCm7boniguim7bwXrbCa0MAf0S7Qth0W7XgZoYeMJbee0lZKpQDt0oS3B1pP5t/ofh3D2xJxqXgjAkC2UF00eZimWZ0FmmaS48RHP1qxil+fto6r2pBBlYjsuaLFCyec+3OqHiJcQlT1VTNyRflIcsY54TRXSOQ2YWdJvFtCel0PV+c79cctgczmxlhXA9da01zIjoTf7QntCGtzrcKNl59+dRqqfT/XzJU5JdB0cyUg6xsPGHYbSAtYZdX5QSVd2/6O7dGoz6l2GFW73LkYg9N76KHGzFTXOdiZU/Iw6T8UrMcYPO+RL+qR9C/yPF8WkJDOzYO0UQGp1I5Vuz5be3/7mrQ70GT7axh3cvJ4UrKohCrQKHSmBoJHAJoobFlmf1GawYmt0Pt3WXp3zrSZsh6tNb13UlbCKPltS11xE9ox4U2yJ66Ae1lqHfOePiq0MrbI9BAPIiMVcNjUr9AiEd1VZFGumMmCkbhYLHxUBdu3+/X0MnjzRqObEYr26jUFVLSjG0AsMIAMGX/bcPE3yrFKE0khBtJOMFC1L7p6mmjep/AS8G32gYRMwKBdRrCwDS
 52pUzn61
 /8mWEbMlxoTHbNQoHI6s69+Iy8HcoUqZ79PTklHPQ7D9u4MXEihLmekQ1m0dYLUTv12ErbXH51e7kreM9XyxtR7Zg1MPJ0WseK0D0Ggk1UWpemAtGcO8iRNI7fskbA4MFgnxCIUYhpNKs9rc05rwr8TWKVHpE4nfsGroPu5PHlizR3ccV2AFpAkV96yNCDOs6dTRxUNmMBPKKKRdjcaQ/xmdJ6egoe1Of/wcQNqElad9q99GwIOfEgpf7sPLu5anqw2J32RiUvbjImZ/WCcS/1Sqab5GH2ogXqXlz8y4AYXmyTDkh0I93Nm8n338pmT+hh/xLfEqZl7epj5oPRbKFyrPXJR12T/VTYGwISpU1Ar8G9MBmviK7o9BcAPMK2DsowxLyE1utCmB5ErLTbeYSO6WezZq9JKZzROM3AOPYVrMTbXxFN7iixyVKVuzHLpo49hzoGpUU35ff4V60Q/8gOGjcGEjPNJF2JRz1v09qYdvNMqLeH/t2MfvEsCpCuZScIFTvfc7W51jnl6BRTvEcX2lyBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:03:12PM +0100, Matthew Wilcox wrote:
> On Tue, Oct 13, 2026 at 11:43:14AM -0700, Linus Torvalds wrote:
> > The fairly short series of ten patches basically enhances folio lookup
> > by noticing when folios are hot, and setting a "delay relasing this
> > folio until after a RCU period", and then using that RCU delay it does
> > not just the folio lookup itself under RCU (which we've done forever),
> > but also the actual folio data accesses themselves under RCU. No
> > refcount taking needed for the fastpath where we can just read the
> > data from the folio entirely in an RCU-protected region when the user
> > copy doesn't cause page faults.
> > 
> > Unlike my original approach - because it now actually delays the
> > freeing of the underlying folio data - there's no need for any double
> > buffering, and a lot of the original limitations of my original patch
> > go away too. That improves performance quite a lot. And by "quite a
> > lot"  I mean "I see a 23x performance increase on my Ryzen
> > threadripper". Admittedly that is a very artificial case of reading
> > the same small part of a page over and over in a threaded loop on all
> > CPUs, so any real life impact will be much much less.
> > 
> > Anyway, I wasn't planning on posting the individual patches, I think
> > we all use git by now and probably find it easier than fetching
> > patches from the list. So it's all at
> > 
> >     git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux rcu-free-v3
> > 
> > and the commit messages are a bit more verbose than I would have done
> > it myself without tool use, but maybe it's better that way.
> 
> Obviously the numbers are compelling.  And thanks to Kiryl for figuring
> out a workload that confirmed my fears, then remedying the problem.
> 
> I don't like the PG_rcu_free flag.

I wonder if you would be okay with a 64-bit-only flag? Those are less
scarce. That's the direction I was looking at:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/commit/?id=59b23fdc4bb0d008e2a30d24156177eeede8a577

I don't think we care about the scalability of 32-bit machines here.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

