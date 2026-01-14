Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9821D3901A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4781F6B0005; Wed, 14 Jan 2026 15:59:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F8A6B0089; Wed, 14 Jan 2026 15:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34E966B0092; Wed, 14 Jan 2026 15:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 24D3A6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:59:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A55D159AEE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:59:58 +0000 (UTC)
X-FDA: 84331786476.23.E8C241D
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 74C452000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:59:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=none (imf03.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768424397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lkolwiPwgsF4A/5SQSCwZ7V7qx+nHaPnoPb0elL6zdY=;
	b=rMzfl9Cn42V3Alwjk1rg6Sc7Qz1QB5vAMcMU6MhQAj+ROS0hUQN+kF5zx0BmjAk7FvnUPa
	2pMpSHiUob7tItMFsP2OVyHYyv5RKQGCfpInN+Xlyh18q6GioWpzA364dYD7ItXkbGTyq/
	YCGq7/e4/gFXfp608Q4zmLlxs6SUlsg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=none (imf03.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768424397; a=rsa-sha256;
	cv=none;
	b=e7OZiGlNG/DYHg32uA6xtqwX5k4HDOgz9jaLFduxz3jeH2cG9vy0Vg9mqJG5lP6rm1D2l5
	zohnC40n+LNREimwPBT2/nCj2Eff59EztyXz1Y8sfPon6lg/6c2LCoTgbtvoRpIql3OqFI
	lAvrfiHUozd6+4AiDGk7gBJzgQ3LdDY=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id CBABC92009C; Wed, 14 Jan 2026 21:59:52 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id C90FC92009B;
	Wed, 14 Jan 2026 20:59:52 +0000 (GMT)
Date: Wed, 14 Jan 2026 20:59:52 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: David Laight <david.laight.linux@gmail.com>
cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Nicolas Pitre <npitre@baylibre.com>, linux-mips@vger.kernel.org, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: mips64-linux-ld: div64.c:undefined reference to `__multi3'
In-Reply-To: <20260114173435.51cf556d@pumpkin>
Message-ID: <alpine.DEB.2.21.2601141950110.6421@angie.orcam.me.uk>
References: <202601140146.hMLODc6v-lkp@intel.com> <20260113200455.3dffe121@pumpkin> <alpine.DEB.2.21.2601140453090.6421@angie.orcam.me.uk> <20260114103103.216aa122@pumpkin> <alpine.DEB.2.21.2601141530510.6421@angie.orcam.me.uk>
 <20260114173435.51cf556d@pumpkin>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 6ndiinbrgyq68dhp5qpqtrcmxzrmxuxf
X-Rspamd-Queue-Id: 74C452000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768424396-640958
X-HE-Meta: U2FsdGVkX19p7YDgQ3wUbeZSc169X6Y9iyRXyjCg9DeyTMy/Tp2TQOswG38WJ4sAgZmvpxYaO1zwcvg/Q31gdtY0a/xHDy2OAnzz8Y8SUig/hH8qRZl7OR18dkjc7fqc3b4/nfSFxMbyReU5sNuGKEtWr316RRVX8ai0gFP8dRm98n/2XppRzE2N149Rdmfc3yQJgD0CXzTSDXfjSzvL7X++L9lOnxtQNS9PU+f6OpwTVxSYg+hvzbqRfgOujCG2ffLrJGlsRu8mQVIXBwL9eo+QNbIloJeGl/wAnKNSQ+v5teAaYbqFxJ5PT3lPSkuzG82IFIJOx9OgRrcBjoV4T24AIEOt4zDLnhqPgcNWs8dKZVO03ipCinR2wLwGm2WgJq7jZNtt8+CH3Gyvg7rVX4o/X5A2ihmJcMtkp9/aDTyGnXNmUsH0JVy2Wns2emNGXzm7AKGXesyI2A/nhxicMGqtkgiPwXQI8HM98ouHqX3PB+EX2arj802jx1PXgu6U4FZGttDik1AMD6YeXsQ7xdw3Gtetsyx3ERjffrzmX0gkHv6j/wmHl6z+h/K77l6y/qqZffFVLVvEGa6GZ+ZTsJKsHc/+beAJpGS6OgtR3qi+X0z5LhqpOV+l1/Jj6Wc7hqHBB7thEAdO2R6DOUKOuBN3XAcOy3etOhUQMGfVmuVDLYT2obWvz0leHSdHs6/s7iiXjUevLdquy4G+EAetNkynT65umTuq9Fh6MR1hSKaAI7OhgVlOeWmRX0OIiQiaKhLXSVA3PrQUQzNMROA+XPNDCU71NGU/qefTaqjC84ZrDeHX7C6fCjocabVs5PrWaERQbsCTxGhxugiD/i2teBYDTNCd/J1bZ/LzNxonVL2cyyJgCIdSuLfd3vbHapkOQtHfpOWT60UQtugAx9vQnrOR6m11TSQIfM28UvPZ1dGBxuLiwywn2kNZgz8H/C/9Hw9BAZi3syU7TRXr4SF
 aUqYB4s4
 r5UotTOT5FNO4BbC9NlzR7Swj/4Or40NS1BeIn+bK2fFmMo0fcEVJMF/IRKLnN6CUAnpC4GsDoyBFL6JmTln/y4+OI8hWNLiyrdt03v+/Ek+wi5H/n+8aurZykzvfB3tnecvkRGz7A6UjCPNih/YOezC55dGWUA2nYdYZX3qlRFUk58gqLxJIHkWFzroCXfCTt9SIIW/QL4B6jfQmqlkR1xmIF5959tpJ+EQxfpU1FW7ixMm3zF/Ap5evrYSXPHKbO367YPdq7mqtPqF7WPyBM2gn5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026, David Laight wrote:

> > 	dmul	$2,$5,$6	 # 9	[c=20 l=4]  muldi3_mul3_nohilo
> > 	dmuhu	$5,$5,$6	 # 10	[c=44 l=4]  umuldi3_highpart_r6
> > 	daddu	$7,$2,$7	 # 14	[c=4 l=4]  *adddi3/1
> > 	sltu	$2,$7,$2	 # 16	[c=4 l=4]  *sltu_didi
> > 	sd	$7,0($4)	 # 21	[c=4 l=4]  *movdi_64bit/4
> > 	jr	$31	 # 44	[c=0 l=4]  *simple_return
> > 	daddu	$2,$2,$5	 # 29	[c=4 l=4]  *adddi3/1
> > 
> > (hmm, I wonder why the cost for the high-part RTX is over twice that for 
> > the low-part one; this seems outright wrong, also taking the possibility 
> > of fusing into account).
> 
> They might be different, if the wide multiply is implemented with multiple
> narrow ones then the high result bits don't need to be generated if only
> the low result bits are needed.

 Well, it's GCC that has DImode multiplication in `muldi3_mul3_nohilo' RTX 
but then TImode one combined with a shift and a truncation operation in 
`umuldi3_highpart_r6' RTX, and then applies some generic cost figures to 
the respective complete expression.  Instead the MIPS backend ought to 
provide the correct cost in both cases.

 Given the technology involved with MIPS MDUs I'd expect the same latency 
for both operations (DMULT/U used to produce both parts in one operation, 
but required a dedicated MDU accumulator register, which complicated both 
the pipeline and instruction scheduling in the compiler), and indeed e.g. 
the figures for the MIPS I6500 CPU give the latency of 4 for both DMUL/U 
and DMUH/U each.  That would be 16 in terms of GCC insn costs, as that's 
cycles multplied by 4 so as to allow "fractional" costs in special cases, 
and while using 20 instead is not too bad, the value of 44 is way off as 
it's almost triple the actual cost.

 Incidentally, the repeat rate is 1 for all these instructions, so the 
multiplier is fully pipelined in the I6500 implementation.  No fusion is 
mentioned though.

> If those are gcc's costs I suspect they may not match reality, after all they
> usually only have to be 'good enough' or 'reasonable'.

 Well, they need to be good enough for the compiler not to come up with a 
worse alternative, such as e.g. with repeated addition when one of the 
operands is immediate.

  Maciej

