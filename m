Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFF2FA373C
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 12:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225306B0089; Fri,  2 Jan 2026 07:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E4756B008A; Fri,  2 Jan 2026 07:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FAC66B008C; Fri,  2 Jan 2026 07:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 000466B0089
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:12:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BA991A0C67
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:12:47 +0000 (UTC)
X-FDA: 84286912374.28.8ACA723
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D0D714000E
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:12:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=eWZ6M1Lx;
	spf=none (imf23.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767355966; a=rsa-sha256;
	cv=none;
	b=JWVJ2mwCr4BgwH8XgEWon+W1zb+E2dcTjGbh66qpBmuuQI337ePsgfsZp2vAwapcWHuTbM
	qPCzXhKn20TJwYkqn3Dzb6k+nHexu7b88p74pI+47zzQ3pTYUYFnatTwQy6Jh/D/FXYBeY
	+CgVI18SapiuqvufZLUo2DRN65pv5rg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=eWZ6M1Lx;
	spf=none (imf23.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767355966;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6sNsz3nStghYSzY+sXXm0yt/UqQQAPm0N+js139ygxI=;
	b=4KkD6DFfLmEKUqvtyus38VvTTb8NGrwo7PZxOhhsZqJpVd1kJQL4crXE7XgkHqIYTQkx0X
	LSei+ZvOU0IA9Rm1rae7bcXihYv/q/Fb+tZFBMhsKVTHKmL9d9itBKMrfEFd4lRpU35IDD
	aTlyKj9f24Mn7rzj3QcT79HWCIX/duQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6sNsz3nStghYSzY+sXXm0yt/UqQQAPm0N+js139ygxI=; b=eWZ6M1LxOy7uZXqanWlIQGUAO+
	MOCPLQXa7avZ/2SNw8YuSx1jkWfO8OQ2ROHAeH7unCs2xIfsNw/4UUpt+9+QVaCduJDkuggJPHLqQ
	+327Ef6QUxiHHK2+tyxckPNJbeSqfqB6lFY8F/tWC93NKL95phJOb//iOLMJMQJmVuTwom+mEt04b
	5Jm12IMW8W3uamxmcV+Go/CNG2VMe2q6mX+OUHl+3P1DTg2N6vBeNSeV7P/d//HXpT0+RBtxTu/kl
	GvnzBlqGY0Vl6AzymRFKx//5iAs1ik1f8ldQMYgjme1eLHQ5KGd/U/ZHPOLaXzgvaQ1tX+Vf6IOu9
	+Nmf+7Aw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41622)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vbe1F-000000005x6-2g7a;
	Fri, 02 Jan 2026 12:12:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vbe1A-00000000523-3D6T;
	Fri, 02 Jan 2026 12:12:32 +0000
Date: Fri, 2 Jan 2026 12:12:32 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Matthew Wilcox <willy@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH 3/4] ARM: remove support for highmem on VIVT
Message-ID: <aVe2MH0TUsobPaKL@shell.armlinux.org.uk>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-4-arnd@kernel.org>
 <20251219171412.GG254720@nvidia.com>
 <513078d3-976a-4e6d-b311-dcfcfea99238@app.fastmail.com>
 <aUtPRFdbpSQ20eOx@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUtPRFdbpSQ20eOx@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D0D714000E
X-Rspamd-Server: rspam04
X-Stat-Signature: q1o1wqdykzmgn1u4g41btc36m9gyscha
X-HE-Tag: 1767355965-55234
X-HE-Meta: U2FsdGVkX1/MHEpv2y0Oq/II6iaQjlcCFXas/CiXo10wfTak86v7Wh3L2qsh8afcaSxkyuQorMneyhXonMAp8N6uJsGgW3VKQtgV3HEwYSyl8MrRuwX+wEYDBeNgE422tq+mZ4Wnjw69Ow9kTZKeDOss0Npgi01CdsoSdjh75CKdOSpxa2FcVtUGDHeAvQkTpMJKi+68y+BgznuD5Bj73C1ySoFr+HClY1GvOTW3FshctbL0WiGlQEKX8Az/PddVbLDwBMpeBvGNl32q1at4SNEpe3YwCPo+aafN//LMJMc1u/nkSxpfNQwLRUSEDo15bebLqO0CE218e6XQcsBgmYu2j2Noo6mNPyY6jDQQ3Mpyv3qbcZ7brf7ppGXpnUSPjq+lYfDuNyBjnMWoRlJzuvzDtCi2KPSEbTP9yi8zCfCTK8O0neylXBTY6e2v4yTPO+qGt3ccISR4poXUxLqhTRyJSYK3MKNhWFndVjPB0thIyLgOaw7eU3sMvN91j3ckPkNu6+P6Jl+D4agbaE3IUj3lXRIDbIFep7xiBYvD4LDx3gThUGxe97ixb4jlQuDiTyJ+kRbRebS7RLiTAmuvKv07YtObjm2Uz1QMjMWufsO4z6VMPqYz3RTkp3JPRCL+VcASy123mWcuHWeRke2ozB8/KLTfROdsKevLgfCZL6wdB9aNJN5eogcmdzD/AB61+jaQbxmZs4qhr88Q+kJMheedO+SywM/bHojEM++PLXoc+OmKxPRHbssslo/n/7KEvBXWue3WQU97PD6kwp4bBBuhsdRGZm1QDJ8rFWca73NWrE47/S3hl6PGd86eB8q4XLpxY7tWYia17q3tn/YxhbMQ5K4eriAssqkLxIoSNAMRNlZbSK9BW59O2HOpoO83eEN7B8sC4WTnoAVgx8vqrp0bDT+iMzLCwBYmQ5flwknE+BKrTzkaWcvBF3Eebant3F4/mwZABgGTdic4XzI
 GG26XBPQ
 swPeUlOyz4vcW8U8gdXY4nhWonSI1gAczXmPGSkqwQu6HvpMgyTebp4hSmRRVM/ZxZUJbSth8cOo4JTkiwqOk1lT3Pf2ultoUIUNG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 10:26:12PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 19, 2025 at 09:34:33PM +0100, Arnd Bergmann wrote:
> > On Fri, Dec 19, 2025, at 18:14, Jason Gunthorpe wrote:
> > > On Fri, Dec 19, 2025 at 05:15:58PM +0100, Arnd Bergmann wrote:
> > >>  arch/arm/Kconfig                    |  1 +
> > >>  arch/arm/configs/gemini_defconfig   |  1 -
> > >>  arch/arm/configs/multi_v5_defconfig |  1 -
> > >>  arch/arm/configs/mvebu_v5_defconfig |  1 -
> > >>  arch/arm/include/asm/highmem.h      | 56 ++---------------------------
> > >>  arch/arm/mm/cache-feroceon-l2.c     | 31 ++--------------
> > >>  arch/arm/mm/cache-xsc3l2.c          | 47 +++---------------------
> > >>  arch/arm/mm/dma-mapping.c           | 12 ++-----
> > >>  arch/arm/mm/flush.c                 | 19 +++-------
> > >>  9 files changed, 16 insertions(+), 153 deletions(-)
> > >
> > > This looks great, but do you think there should be a boot time crash
> > > if a VIVT and HIGHMEM are enabled, just incase?
> > 
> > Do you mean in the common code or just for Arm?
> > 
> > We could use the Arm specific cache_is_vivt() macro, but it feels like
> > the 'dpends on !CPU_CACHE_VIVT' Kconfig check I added is both
> > safer and simpler.
> 
> Okay, so maybe I'm asking if !CPU_CACHE_VIVT then the kernel fails to
> boot on vivt systems, maybe it already does?

The cache modes (CPU_CACHE_xxx) are (were) selected by the processor
config entries. Not having the correct processor support built in to
the kernel will cause a boot failure.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

