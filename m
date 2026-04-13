Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EACD8F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:31:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B6F6B008A; Mon, 13 Apr 2026 15:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C786B009B; Mon, 13 Apr 2026 15:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003D76B00A6; Mon, 13 Apr 2026 15:31:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2D016B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:31:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90A7813A3E4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:31:41 +0000 (UTC)
X-FDA: 84654527202.12.7CE000C
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69A9E1C0013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:31:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=eBEb3+z4;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f K2XbJ9";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oF7+4SGRAImH9WMGSId2dJm+4RdrBt2YGrt25aFUZUA=;
	b=zZRgYOUjXAAULGk35HR5HTDYC36+AFaGpSzr5J+Cg6sbpKmNdwD3WC0VpVtyH0dQnleD/G
	NDc8qAjdAK3ag9lSvm8xioN5SiUa30i4Q6cASIkqflhII3EQsP9bVe8x1as2Wj1jjXkRrB
	S/zVmxkwyPwxxcOcO/5bNDVMqpa32TA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776108699; a=rsa-sha256;
	cv=none;
	b=AkH5quSLWOYrSxfZFJ3AI6LqR1nJxgvJrh9xxDBeYTxlj/RXtf+A96Ws7/RiRLN80mxFqK
	C8RVGjZR/6jEXMjOjWBbGzTnLHspMeFdjdYUdgcd6XxhioAFZ0SBdRUcxZB4pniQjMaBki
	Bf2TPe2H/7yGdw0SJBCfBGSGusioQJE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=eBEb3+z4;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="f K2XbJ9";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf21.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.139 as permitted sender) smtp.mailfrom=arnd@arndb.de
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id 9BAA81380415;
	Mon, 13 Apr 2026 15:31:38 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 13 Apr 2026 15:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1776108698;
	 x=1776115898; bh=oF7+4SGRAImH9WMGSId2dJm+4RdrBt2YGrt25aFUZUA=; b=
	eBEb3+z4uCJ5XpVJfmMDtd+Hz4pTmn4rIKoszU8vf+435LUmCEc3EJdi4K0/oVv8
	C+yjXVYuraejFdA/rcQOSN6Zfi5pNlS43GslApllsudgHnK44npvkIwaUHWVTtuh
	Dw/4I/j/UNeqyr1LQlKmH5vdXZciz/2GPqFtFHFDNoaInKEsvm7hwh9DYdVnGoah
	lMAIbVhEjH95sryDmrUzci3AfaiCDHHYDZH3oXJ/R4+VlvsfKJPopXWx0JE7CxaE
	ognvTjwa06PAMT31z/DBGKMGBcoGUsjb6Y3k+6cm618rMbyQ7yCpT6T6pE5XH3Hf
	w2SGXNdq7Abx7TrcOF+CrA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1776108698; x=
	1776115898; bh=oF7+4SGRAImH9WMGSId2dJm+4RdrBt2YGrt25aFUZUA=; b=f
	K2XbJ97Y0jsbU1s6LswXOEcaT2AuIJQsZKTCiqB2bsDjsavXFxXjXN24HUjqmHPV
	30lUfZzPVJ0GZrRSLZsyTrPlhAwj+oOp7rzHIcW4Q+ggBxcGWjNT+roTWJQkS80p
	muhmPfZao8pyrAslQS6xE9YgbnnrpBmxpEViK0VuBn5kyHZfCSLFSApLiy8hZEkj
	X3o7U4xt3roWjYEf/0QsKGiNqeP3myXk/e3+BEa4KYIE59wmYsrhudiDwV46CB5d
	E8K4OFv0fHuOdK14nnUUxfff3rCPKj8vJw3X7p6M4i0BpN1E8RSwySIEaUf5sCqK
	alHtK1Rc5jgsKIF8k3s0A==
X-ME-Sender: <xms:l0TdaRMQ1ovC5UjXw9wB_riUJbJZBZQ47VcEC4ozPMlWVwTWyL-hPg>
    <xme:l0Tdaey9qAPkMkkSsq5ZowyLiVSaVZg3Aabqq1QUbhdAX-Y8VC29U600TE9HTIGWj
    W-h6ka_l-N0bKYGG_W-3bzXlHGY0ZcjcSbZR_zuoL-6Ds0X7Q55CQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefledtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpedvhfdvkeeuudevfffftefgvdevfedvleehvddvgeejvdefhedtgeegveehfeeljeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepthdrshgrihhlvghrsegrlhhumhhnihdrvghthhiirdgthhdprhgtph
    htthhopegtrghtrghlihhnrdhmrghrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohep
    lhhinhhugiesrghrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopegurghvvghmse
    gurghvvghmlhhofhhtrdhnvghtpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhi
    ugdrrghupdhrtghpthhtoheprhihrggsihhnihhnrdgrrdgrsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepuggvlhhl
    vghrsehgmhigrdguvgdprhgtphhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprg
    hnrgdrohhrghdrrghu
X-ME-Proxy: <xmx:l0TdaTelOssYXt15-FK9p6saYLM_nmrvIO6c-_F3ZyF6_xfZywmCYA>
    <xmx:l0TdaUxOkh6ozfKMIVT4v_qdW_i5Tss0CLMqkf2F01TBmahdCnZo_w>
    <xmx:l0TdaUWn-LdWx2_7oUHRu6zzNshE3wCLw-aFKzbUUXN26D6Q-_6vLw>
    <xmx:l0TdacTwYVtUWJnf_Fdh14nt-sYvlNq7AaQbOTvOw2Uu221fQyzEjQ>
    <xmx:mkTdaTH5uGiAlbaAI17-uSN6CKxYeQsdeWCm3ruscf_j0l2LK_Chakad>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 04818700069; Mon, 13 Apr 2026 15:31:35 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AMdy4yCH1GcR
Date: Mon, 13 Apr 2026 21:30:11 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Woodhouse" <dwmw2@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, "Baolu Lu" <baolu.lu@linux.intel.com>,
 iommu@lists.linux.dev, "Michael Grzeschik" <m.grzeschik@pengutronix.de>,
 Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
 "Herbert Xu" <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 "Bernie Thompson" <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
 "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Marco Elver" <elver@google.com>, "Dmitry Vyukov" <dvyukov@google.com>,
 kasan-dev@googlegroups.com, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>,
 "Thomas Sailer" <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Richard Henderson" <richard.henderson@linaro.org>,
 linux-alpha@vger.kernel.org, "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Huacai Chen" <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 linux-m68k@lists.linux-m68k.org, "Dinh Nguyen" <dinguyen@kernel.org>,
 "Jonas Bonn" <jonas@southpole.se>,
 "linux-openrisc@vger.kernel.org" <linux-openrisc@vger.kernel.org>,
 "Helge Deller" <deller@gmx.de>, linux-parisc@vger.kernel.org,
 "Michael Ellerman" <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 "Paul Walmsley" <pjw@kernel.org>, linux-riscv@lists.infradead.org,
 "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Message-Id: <07df88e5-208d-4aac-9668-a3b0c65ae529@app.fastmail.com>
In-Reply-To: <7a48b636cb3146f4f7134c6d4fe42070ac2edb43.camel@infradead.org>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.592237447@kernel.org>
 <7a48b636cb3146f4f7134c6d4fe42070ac2edb43.camel@infradead.org>
Subject: Re: [patch 15/38] ptp: ptp_vmclock: Replace get_cycles() usage
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69A9E1C0013
X-Stat-Signature: ospqdty3cjbmtybipfyi5t64kmxxhscu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776108699-707474
X-HE-Meta: U2FsdGVkX1/aLq8MKJvdDmyZGD7MddlpvwRXcxeCdDrcPTmiHnf30CCKEfHKqEo+Z8BEQo6zGwRwugIIHADzVeMvjxOXCn+WZdGg6PCLag3z+pMv390YktrF9vasxMew2kFmFp+zhm2EcdJO4eSM6FgfbXYLshOX8dBtLMWdvn38ch9Jux0yrdKYqiyxCZIszhLPp+ku7BsGG0J+FDj73adTg6j3lfGBu5tMUNwbfvv51+pMiM1FKeg+yUnYn5IQ82gumc8iHGiH808xzxIl6bE7LepIFTtjmdFIc0vf1VYRG/96gi+AQDwQg4Zqeb8j9Rp73Vm65O+SlYNffUisGBYJOu7qkWVNxBwbqGQlmSLACM3Sw8+T6JpQHCVAXgeppjyWl9Z2Fu3SjAgsRQeMeGLQcTzI2o4MoSlISP03FnhK5vl7Xir330Yt/5SD3I7SSOaldMP4wAdnMXbTlKCcP2mqtuYhVV8u9CTaG3iyH9zcpjZU/+DJajeEynx+5JdDozdvNd9h7KpFFnxBOq6FgTuD4Vsjk5ZctmSu/JuVz1TjxLSEN+0jDUh2wNhzLN5r/4ibHGS4ACb++GmjkR/gpQiogVAjEhDT9bZyPyuUkdG4qYBPXCqSDPrGKvxhOYTOPJ98tcHcv7vDD32jFn+yi6/O7o8hP0T1iMQx641hx/KwSHRvgSzfCTs9i9o2jgFSCLFlkYl6N46M+wkbUAdOlffCs+SjInA/4BtOKTH1BJMcaCrVUtLrfU4iICSUkR4w6ZTq+MB6F5WkVb+9qht1EDXiNL7K6RX2d8qQ/btVmect7WCjWg17NMgMGSx71S8g0Jzrm95BbhkmoxqqwBXMqGUc+xvNobLkDP5yGSZqs/RqS2/skxMyUnT8EAsfhxpwosqykR6oCI6momBYl1NgCFEryF6ItkoKgmUA9sJXsT+bOHGUAr2TtbgZbomkBENW8v6hrZSvCpiENIxKw5q
 5iFtRIRD
 4YFOLIrTd8mDMd26JLTMONnUQ6Ap+BHlfGLjnb19mWbMAsGokFyLrb3rO3Ou7QSYHt9G32+6+1u8ddwProbaDOYu6ss0YU0Ys/VczF/peflFuO2s5PuERdG47+A5xHfJGnpQMb72Bt57ic0D+xh+TT1NRaubtUkFG4Cg/LLmjWr8vxKni0+Iv7/lB8VPIVWH2K9hiKqv9x5Qd77RWOG+YzxMHPoyxSk/zpVju2+aiAWwIsppZq1rrtlRYjrgR2e/q6qoBdREr9vMHtvY1S93qEhbWDLRrGp6zysJcsO3n9GndRUM2GvCIvtPVmsAgN2S+EZkXtaqPnSYI2C3sO1++jGCZi0UUCfCh+BSX0F+FgiKtaTjzAyZgTLzxIV82h765Sr56kreqJM0hh6iZ0GsFezOKUIseVkUxX+1XCpB5TTk2mI8f84ltzonIMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026, at 17:33, David Woodhouse wrote:
> On Fri, 2026-04-10 at 14:19 +0200, Thomas Gleixner wrote:
>
> ... depend on TSC_RELIABLE=C2=B9, since if the guest doesn't believe t=
hat it
> is, then the guest shouldn't be trying to use it as the basis for
> precise timing.
>
> =C2=B9 (Or... one of the other zoo of TSC flags for the gradually redu=
cing
> brokenness over the years...)

It looks like this is sufficiently handled in the caller:

static int vmclock_get_crosststamp(struct vmclock_state *st,
                                   struct ptp_system_timestamp *sts,
                                   struct system_counterval_t *system_co=
unter,
                                   struct timespec64 *tspec)
{
....
#ifdef CONFIG_X86
        /*
         * We'd expect the hypervisor to know this and to report the clo=
ck
         * status as VMCLOCK_STATUS_UNRELIABLE. But be paranoid.
         */
        if (check_tsc_unstable())
                return -EINVAL;
#endif

With 486 and ELAN out of the way, Winchip6 seems to be the only
one without X86_FEATURE_TSC, so I think the next logical step would
be to turn off Winchip6 as well and remove all X86_FEATURE_TSC
and CONFIG_X86_TSC checks.

      Arnd

