Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A19D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163D56B000A; Fri, 28 Nov 2025 12:35:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ADE6B000C; Fri, 28 Nov 2025 12:35:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078356B0092; Fri, 28 Nov 2025 12:35:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E93B16B000A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:35:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B10616064A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:35:07 +0000 (UTC)
X-FDA: 84160716654.07.FEBFDD1
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
	by imf04.hostedemail.com (Postfix) with ESMTP id 830F840019
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:35:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=EL8Chp9j;
	spf=none (imf04.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764351305;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JwkxrOhf4MPsWdJ3TbYzFMXzZqwZrMM4caiEbRwaHlc=;
	b=61CyKW7lxwZ51StTgXUIKY54q5pcU/zRr4HqGWqA2yD7iO3OTCn+TJ2YF412PP/3ivKu91
	sV7PhQUqYMxFaV0GXo0N95VVRdYHDnlbYQv1Sr2+ZRk1JVGrddTQxIoB1GNbbRrJAwsvS5
	ulyKNN/vjUWLNvCS2x7VhvKjIWPJlHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764351305; a=rsa-sha256;
	cv=none;
	b=3lBSvB0bubOsFeN+gGwlZ66MVsHc58+Djb9bpAnloTeHQCcbbNsm9SPtL0FEykXilHwfxE
	B3ihMcbKohtDoUtQ8jXtnb+dTupP0C2sxUZJ12nHUFwEAxraXLymeyMPF43QOq2thYZSFy
	67W+TpUsu9+492OySrWUn/afmzplmNM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=armlinux.org.uk header.s=pandora-2019 header.b=EL8Chp9j;
	spf=none (imf04.hostedemail.com: domain of "linux+linux-mm=kvack.org@armlinux.org.uk" has no SPF policy when checking 78.32.30.218) smtp.mailfrom="linux+linux-mm=kvack.org@armlinux.org.uk";
	dmarc=pass (policy=none) header.from=armlinux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JwkxrOhf4MPsWdJ3TbYzFMXzZqwZrMM4caiEbRwaHlc=; b=EL8Chp9jEKRF7gKMPiwqVJMmUi
	3sja2/y4vjeQ1ppshT3Y0Phtzb/uA0GK4rORcGycRI4NBjBEMRXoaSoIXCeS+SWJl032Ib++WYptL
	x0IYBkql8K00oiwm7UzwVXX3X/i2/sBjeGk2+j6vi8lnTIx0FlJNpxYizecjmRn1iFfwg8hxM0ip9
	8p7k3NEwKfnQhmyhfYKrR+8rCrEUAn7CXRvAZO06nEmmL33gMsfTc5WHBJiUssojzWZUGL0x8BPYQ
	PhHgGkwqAaFhx/nnT54HgjdB7Zlsb5WvULLZ1VMGrYqeBfrUAuATDr+HUyD+sBc684L0Kt7gQdKgF
	aIHx+16g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34828)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1vP2Me-0000000076f-1n11;
	Fri, 28 Nov 2025 17:34:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.98.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1vP2MZ-000000003nu-1jFT;
	Fri, 28 Nov 2025 17:34:31 +0000
Date: Fri, 28 Nov 2025 17:34:31 +0000
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	arnd@arndb.de, brauner@kernel.org, david.laight@runbox.com,
	hch@lst.de, jack@suse.com, kuninori.morimoto.gx@renesas.com,
	liaohua4@huawei.com, lilinjie8@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, marc.zyngier@arm.com, nico@fluxnic.net,
	pangliyuan1@huawei.com, pfalcato@suse.de, punitagrawal@gmail.com,
	rjw@rjwysocki.net, rppt@kernel.org, tony@atomide.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com,
	will@kernel.org, wozizhi@huaweicloud.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <aSndJ1EYUnMGsUYX@shell.armlinux.org.uk>
References: <20251127145127.qUXs_UAE@linutronix.de>
 <20251128022756.9973-1-xieyuanbin1@huawei.com>
 <20251128120359.Xc09qn1W@linutronix.de>
 <aSnVXrnuY9QKjTKg@shell.armlinux.org.uk>
 <20251128172242.cCNBVf7H@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128172242.cCNBVf7H@linutronix.de>
X-Rspamd-Queue-Id: 830F840019
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: cuztf8aw3c66ro3twifyon4h7gxgx41j
X-HE-Tag: 1764351305-660277
X-HE-Meta: U2FsdGVkX1/UcCHoICmXHxa5LQAITAzfgaQyUJ0FrDNEscqL3sfFBgmjQAf8KyDqFCizW4V9vioGJmwy0jQ/rXig6yqV1N0UQUJ4EbalsxaP3LxBdhw1JuHMv+yx7Ml6ncW6YUm5BxdVknNKIzFQurcN3YI1Nbz+sewNqUthVvTTJuBb4hkQBMPMDFcdYGAiWU1XGEipSuXabbG0iD9aw2bROyq/evTx1AXOVzyhVvYPMPcFtwRf9wjsaaU2BhKTlCc4Gk3+v6w/8SpHOaAWcbDioTsGjb1HnAVnbuVJOTlw1NXfz79w7yiGrWFYsEtp6GuOrfjsTd6Hiu48LAvhtFf8cpLp74HHoUYlmrHBbNsSHeqPospPZBb10vGfaH72E+GCdkSBxNqV+QRX1QQ7lVXi2tLz1nkMQgquCKbGEyij9wB/9EHiMzjcULuhoXD76sf4LwbMjUUukbH8bx8KZkJTYm7tqz5aUVQ8DcjYNFU/rIFz4hja0VEUBzDK8Q+QwvJN9taeY3SUvJuaPx6eyNVPhONmPiJm5k6RRqt0pm6lv3TzE9bDH/7rmeTO99bqpVss2OCqkIcyrC69Txk6eRWwwaH1s7qIs+WQtWITakUAn4MUMrWAhzXotYVkMPLFSALmV2yOwpcITAHRs0WSvLyaWT02t9b5imwqFmIpZrlpSd3cvToEuHkUH4kSCMphvR9E9T53pfc2BMD57P06lmBn1xWYrNlRjtMIHPN0BzCaygSXddU1fJriK3htocGa9fAnBvI25WXU99fb45S0HTVwn6ECZN5UHTSoUYoUwclymbQ0w0UAfrxqyY320jjAAxA1XTUpWJo86BGE5oDoo00lofs+DcTsKaXZXJjUANGmdLKg4Cqa9VMGy5QglbMpUa7sTsjboJgCfD60qdjSDEpcC8ZR8P+8C+YNaSIgHyX+m2oXlh0sAoS0XDUa2Tff+pjfWd09Iw1GXij9Nra
 Eslt4pYL
 ehxA0Pn79zNyURXuY8Ua8Co67XLdDiCvgxTCCUMmeqBF1rtdjB+VzYm7oCUufdKt3OBPZnme09npzmMBqBkzj6HDG0+FEVaXq7sXVfG4Yu7BONBmDmNMNGcVdezNQ1pSY48z13JMqSo6mksBJaS1Oqz5DZmCgU3Nph8edjnfatlc2rueHVEgGfd/UZTRmzxQ/qKzHNc0Yd7VcjXc7ipf6niRy4Sia9BN7iJINv9ElUwf9nQTKXX5Y+eTPD/ajkVAklpe2X7WLK+7NXz6bMmTncWxhVuRhOMXfncUYcYwnmFrWdRKW89Z77CaacuiigWmCFgQfxtBZaog0OsHzMC3pCb/Jh+k1l4uC4ogfShPSX+8VZyRiWgfYfN4KEcRlqjFOWfEaZ6FQYZB3le1HTuDP2jWqwogpLq4x09KHIFl5mSPFODOkCjSYFDXdChHsHZTObb6lZT0wvaPePsEyP3Tk+5CdpEooiq36B4DI3emlr5kTKnpbpElbMu1R+/Me5gwW0BpvUCP5tIMInXAWNJCBfxXRcyu+8rAET8Oxe1WN514rd54=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 06:22:42PM +0100, Sebastian Andrzej Siewior wrote:
> On 2025-11-28 17:01:18 [+0000], Russell King (Oracle) wrote:
> > > I hope Russell will add them once he gets to it. They got reviewed, I
> > > added them to the patch system.
> > 
> > I'm not sure which patches you're talking about, but discussion is
> > still ongoing, so it would be greatly premature to merge anything.
> 
> This thread
> 	https://lore.kernel.org/all/20251110145555.2555055-1-bigeasy@linutronix.de/
> 
> and the patches are 9459/1 to 9463/1 in your patch system. They address
> other issues, not this one.

Oh, the branch predictor issue. Yea, I'm not keen on changing that
because I'm not sure if it's correct (the knowledge for this has
long since evaporated.) There have been multiple attempts at fixing
this in the past, and I've previously pointed out problems with
them when I _did_ have the knowledge. Have you looked back in the
archives to see whether any of that feedback I've given in the past
is relevant?

> > https://lore.kernel.org/r/aSmUnZZATTn3JD7m@willie-the-truck
> > 
> > There are now many threads each with their own discussion, which
> > makes it more difficult to work out which is the implementation that
> > should be merged. Clearly, not everyone knows about the other
> > discussion threads.
> 
> So Will suggested to let change the handler and handle this case. The
> other patch is avoiding handling addr > TASK_SIZE.
> Any preferences from your side?

... and now we have a new proposal from Linus. I'm not intending to
do anything on this new problem until the discussion calms down and
we stop getting new solutions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

