Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D235BD7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 17:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193256B00AD; Fri, 19 Dec 2025 12:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172716B00B0; Fri, 19 Dec 2025 12:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C766B00B2; Fri, 19 Dec 2025 12:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5796B00AD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:46:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97FDE8983D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:46:46 +0000 (UTC)
X-FDA: 84236950812.02.E740C7B
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9451B20011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:46:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E xazx2S";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iRYwswjU;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766166404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2gbCq/TeBYPxiITWPNdSmIe+GVkyoCIvjxfX+HLNZM=;
	b=j0ElGLAIzMYis2EIWx1xmHEiXsmLgkWE0wyJQuNjsmAu8DIwB3/fnmLqOsBfObOyBirzQD
	R1L4bS4sK8sDQqJ7n0LN2Tlg6ELnOAUfBR80vv87okNruXP6iFIDmyyZkVckb5AJkqEg45
	EH+Q22I+BoZGs+dOVb2EG7uewMDzFwE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="E xazx2S";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=iRYwswjU;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766166404; a=rsa-sha256;
	cv=none;
	b=wBF2M0xCN1EApNRWR3wRK738vfWei+J37AaPDLIDHEgefPSmbjZdWuDXJqG2FlaMrjMZTo
	vAwoZA8HdD6aTrRK7goEIafGb/w5LJA4GbabB2w/LgI4hEmT0MIQUpyMTh0qB7UXrvF8vN
	qFUPYBMB86FsfLnWMW8Yh3rXdbPP0yE=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id C5E7A13800C8;
	Fri, 19 Dec 2025 12:46:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 19 Dec 2025 12:46:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1766166403; x=
	1766173603; bh=A2gbCq/TeBYPxiITWPNdSmIe+GVkyoCIvjxfX+HLNZM=; b=E
	xazx2SrMIw9ZUs9geIvDyOTgE0ar83/WRcd9GqsSMB37Ch44sNAA5iXVCBDj5yiR
	vqpKok5koCnvVk+8aV2e5qLtBG9cwzVDtn/lGjtgjQ80NI/f/R7HTDViP9g69BPV
	cSqUmD3lmZX5wRB7nDLkwXtkllaTqeItQDVT6qTI8NK3KTgTq6hfjO9A1yVbesXI
	52xjy10TW6pQHl88NEJt4PC1Svb/uDQjguqgyQpsCynFGKNlEBQufJ/sOtog0kn0
	3HyupMLp/qN2mf5LTDYvNSv2mC3Md14su2l7pJ+pi3LuqC6TlVH8B99oGiHETkkP
	IA1txELq2o3E4b7vDlqIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1766166403; x=1766173603; bh=A2gbCq/TeBYPxiITWPNdSmIe+GVkyoCIvjx
	fX+HLNZM=; b=iRYwswjU6McptpLB4eoG0trSl7tYnPgD9kLXZSpd38cT8DlVhGX
	6Uq47MPgTn4bi6Ct92Lm1/Iz3/C7XhZuJTuiliUJ78p7WL4JTv24sb8mw5O+qLp1
	LCPxyHVpjV+xtSS4dHBUnpi1M1x6U1RKCz/0tI0YTZX5EPHDlIpC1PT5w0Cnhqcy
	nxDgLXXlsysE+3bzLnWJSVA1TFeNLCVIXKcZKsIvWW2hKmpaLvyVy2tWsnpY1UCl
	+p9nDrR+x0YQRtBYGrVTndTf7aJ1FxBga2i2CwlE7bOXQpmK4h8CqZ93fN0+dCc4
	JpW/R+YHG3MSfOi8dIslJnfFVHGJcLgufcA==
X-ME-Sender: <xms:gY9FaYL-bsVWqQcrv9ei-mfEnvFsaG2tR0P3rEPkTvgeVGV1Y29Uog>
    <xme:gY9FaTDe_dbmLZ7wjF65wzcLzAxS-vtjM9l_l-NHzbY_0jyJwR2ZmUedtQMVEvkir
    PECOqd7796TwIR1FrcSbminLnmG9bPV_V5u0u7Bhb650aCO1D0PPQ>
X-ME-Received: <xmr:gY9FabnW2jUf2ioE0zD-vYESI0xDb5sxBU-Pr0eOnr3Zs4J4Mf1DJrTrpwgGZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegkeelfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohephedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehglhgrugihshhhvghvrdhilhihrg
    dusehhqdhprghrthhnvghrshdrtghomhdprhgtphhtthhopehguhhohhgrnhhjuhhnsehh
    uhgrfigvihdrtghomhdprhgtphhtthhopeifrghnghhkvghfvghnghdrfigrnhhgsehhuh
    grfigvihdrtghomhdprhgtphhtthhopeifvghihihonhhgjhhunhdusehhuhgrfigvihdr
    tghomhdprhgtphhtthhopeihuhhsohhnghhpihhngheshhhurgifvghirdgtohhmpdhrtg
    hpthhtoheplhgvihhjihhtrghngheshhhurgifvghirdgtohhmpdhrtghpthhtoheprghr
    thgvmhdrkhhuiihinheshhhurgifvghirdgtohhmpdhrtghpthhtohepshhtvghprghnoh
    hvrdgrnhgrthholhihsehhuhgrfigvihdrtghomhdprhgtphhtthhopegrlhgvgigrnhgu
    vghrrdhgrhhusghnihhkohhvsehhuhgrfigvihdrtghomh
X-ME-Proxy: <xmx:gY9FafFXRbY4sb5fGPF35vKKf24lSM6JmJ5LB4oibWq3tjbQWSjaHQ>
    <xmx:gY9Faaiq43KSrQaI_FyCO2dZYBQMTNNAmEI5gfjSPFb4OVwx8sTJyA>
    <xmx:gY9FaXd-kKsU4LZXAWbcuBMk9FqgWtrQlNeSsayZ5NqvSqieWFwAkg>
    <xmx:gY9FaQ-IOYlRU3dhSD6rFg51kB1cJFGEFMrqqFEdNAQXk6_EO5Buww>
    <xmx:g49FacJDpk8LC7y32lqUDNGe4jcqDf4325jPHcPWprbCELfuq3eQtEUF>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Dec 2025 12:46:41 -0500 (EST)
Date: Fri, 19 Dec 2025 17:46:40 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: guohanjun@huawei.com, wangkefeng.wang@huawei.com, 
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com, 
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, yuzhao@google.com, baolin.wang@linux.alibaba.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via
 dedicated bit
Message-ID: <ans3mrfqd6jv5hfarbx5bzsl2ugtatbfyjw2vlv5ybuhevjc4i@46f45fdds5m7>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
 <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
 <9822c658-c2f0-4b1c-9eef-9ffa865e44f7@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9822c658-c2f0-4b1c-9eef-9ffa865e44f7@h-partners.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9451B20011
X-Stat-Signature: gsp863p6ksb7ja78adm1d6tigs383nqq
X-HE-Tag: 1766166404-260394
X-HE-Meta: U2FsdGVkX18nipsNdqsZCmTLNUkfn5Jw8r4A0KmTV3ByUkQKnBliAbFos1Qr8XgC8E5m6f+bL0rH+wtK0k8BZF8nOx2HOcr0affiu4CyP6t/iDjjPODyLKveKVc8aYMYYeLD8iRvgTfHp2BxbkRIxXN3jEzH2oqrjy2wXn7yenvIyF7tsyCEsySnbkzdYSiyyS3oloGU7MUZAxd0WgBvivbPO0iFzwCIQwyPQi6KqcH7f1IhqRkSqMHwwZnLzh8WCHKuKvuuoXmpKCgySOFaFQIzDyQOFvRXucgQp5Zd6zc6Fl2k1Ggik1c/AJPBtw3U6Rlz2bK+7egVKaiU55hV/aSXMaD0y3UuXSO2tobXBPqKCBDjcRubaJm4nfWwS3Xbf17avEwBDI4lbSlaetzKs5o+RpxjQH9aJ0WMMYdxjR+eBR5YkAnPTs+Ljwsc3/N2383QuzeYex+Rbbe+mPzfvy76QTT1B07Lv5OMzkWTtx9uHzfYGkpiBqulJ676i1m4d3D3lfxtMzS5qm7vHz7UW2xg5ZU1XmX1b30pAKIbipYxBcu420WN5oJT1/kHSGaAC8Ww6fRntV+8gctwj6nvGAizYQfzHGwZuYWkuU9+bJFGfY0log+Wls5uN+6by6ONsdg7iO2UAW4qRpUwCYJgp60eHRgJfOn56AgrMaRcDtZGphgypnYzhaaVKfqEuLEunrJorJAoy0L4ZkUKheOmmNpLnzViyfXN7yLvfGltbEODr2WWLOkonNH6p9rgydAryfz+p8R04ucPoXy5+hMJoLVJcR4Rkosoxm1CbIFRDkR4+GMmY6y+VW9U8TOQ/28H16uAw4iCizljo0NytjZFXldoe/0sGb1GjH1hPIDml9dQg2xKwUQazOHHRUFGjwKy1tO0YGbAXuyZeqK67aiGgTL4pCLgT0whmskIGK9Nv+/cMZnvCknwMn3T0YnEyYhhdmv5GUsZ3ohh+SRXI3b
 I9otGe8U
 UQM7cv6JNuiyOWC+xZBFazlrR0lgfXsCT37a0GdrrnrFpkyxLPjXUJ3SEREgfo8IlE9mdpUQqEFjS5AeM0OBFnT5/HUO+srSxofERfI2vqBzxglHs60fsqBbmHpzvX4zkrn7GJxs07u/LtVuRx81CK0CBcCpsZh/u6Djn1yTIVhmL1wN/+0N4Bdh3mkFL7oKAMy8bqkO9BzmTyjhtHWwmuXrB2Lkp7H/01JkzXm7DN6GYKLGl45NF1xyd35SbInipyVMwU0d2Qy7jn0O8+sHgQwImuMSPkRQg3caXZA9oKNfhKME/zG1OpjO49WNV6AaNsxfUbbLHtyQY7rQDaRZuP3dP5FBAAqy+5pk1WKLpbOO8R6C97yYHMCtLpwyMRd9YhmbLpe4tt5hPUTvj79RYOiWPLvfI0Pli0cebcAKgpfI+BO5pI5di9TPR2Tjodqc8QTEK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 07:18:53PM +0300, Gladyshev Ilya wrote:
> On 12/19/2025 5:50 PM, Kiryl Shutsemau wrote:
> > On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
> > > The current atomic-based page refcount implementation treats zero
> > > counter as dead and requires a compare-and-swap loop in folio_try_get()
> > > to prevent incrementing a dead refcount. This CAS loop acts as a
> > > serialization point and can become a significant bottleneck during
> > > high-frequency file read operations.
> > > 
> > > This patch introduces FOLIO_LOCKED_BIT to distinguish between a
> > 
> > s/FOLIO_LOCKED_BIT/PAGEREF_LOCKED_BIT/
> Ack, thanks
> 
> > > (temporary) zero refcount and a locked (dead/frozen) state. Because now
> > > incrementing counter doesn't affect it's locked/unlocked state, it is
> > > possible to use an optimistic atomic_fetch_add() in
> > > page_ref_add_unless_zero() that operates independently of the locked bit.
> > > The locked state is handled after the increment attempt, eliminating the
> > > need for the CAS loop.
> > 
> > I don't think I follow.
> > 
> > Your trick with the PAGEREF_LOCKED_BIT helps with serialization against
> > page_ref_freeze(), but I don't think it does anything to serialize
> > against freeing the page under you.
> > 
> > Like, if the page in the process of freeing, page allocator sets its
> > refcount to zero and your version of page_ref_add_unless_zero()
> > successfully acquirees reference for the freed page.
> > 
> > How is it safe?
> 
> Page is freed only after a successful page_ref_dec_and_test() call, which
> will set LOCKED_BIT. This bit will persist until set_page_count(1) is called
> somewhere in the allocation path [alloc_pages()], and effectively block any
> "use after free" users.

Okay, fair enough.

But what prevent the following scenario?

		CPU0					CPU1
page_ref_dec_and_test() 
  atomic_dec_and_test() // refcount=0
					page_ref_add_unless_zero()
					  atomic_add_return() // refcount=1, no LOCKED_BIT
					page_ref_dec_and_test()
					  atomic_dec_and_test() // refcount=0
					  atomic_cmpxchg(0, LOCKED_BIT) // succeeds
  atomic_cmpxchg(0, LOCKED_BIT) // fails
  // return false to caller
// Use-after-free: BOOM!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

