Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C633F43830
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 14:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60D496B0005; Wed, 15 Apr 2026 10:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BDF46B0088; Wed, 15 Apr 2026 10:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB2F6B0089; Wed, 15 Apr 2026 10:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4000B6B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:50:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6B8F1B7FAD
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:50:33 +0000 (UTC)
X-FDA: 84661076346.12.8E47DF4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 97ABD180011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:50:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EArKl0On;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776264632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uk0JsMQf+CVFWDP/CsyX5sUtLObhpV7jtN+MOYTyvWk=;
	b=2xWLgxX1wugMAX5bWeiTAGsVx13rhIXzjdWQiTBddIyU7p8CGMTJx9yEEk08LR1D1VNdR+
	/e4f+p89vDyASB+W74bsAvDgHCLklQUQ+VYp0CVnu+26j/kk3R0s56qqfOJdDx6bSWKq2F
	Z0QVqWwG7AAnkoPJgFbiI8awDLbvltg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EArKl0On;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776264632; a=rsa-sha256;
	cv=none;
	b=hzgiy4uNODAk6o91m97VnBWY5T2qb2AMURKYEQuPrF14Qv0tVZZEArvTP2Q0CczibVJtmq
	0+IC95xjr90/4gZi3NzSh3QusRSIWWFZkqoPnT8UwkrxWvC4ViaRWDr8WL9gND18Y9Ct4T
	1zCZjQ7xK4okxuFMsY1FCSiOh1k4A+0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uk0JsMQf+CVFWDP/CsyX5sUtLObhpV7jtN+MOYTyvWk=; b=EArKl0OnAG9XoW3gQ9ptsyMcdE
	b6gh6tQcpyIV8JguJZcbvXRbQ/wsJaYDXB0GU1SP7B1bOsZ8urKsRrJemFZjwxdWctEbvvyjCDbSR
	wFnLNA7zNVO3RbjZQz7mIIO1dFwBX6AiXbK6oncdHs1kJrzufhytyiSparn7qGacnOTLFmsS066EX
	wRDcF6P/59+TOksrTxfTvdBX4CgK94PB+IEe5dFi7H8mDyzKiFyd+LtwpF56AggnGniRVd1E/ZRCn
	Tyn8MTq6BYcEE880k7ujkyDhl7loQbrS/8ZpnNAQx5QtXWHjwdUfXEkYawLopo9a7+JN7gOKd4Oud
	uCcI9fOw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD1GI-0000000004t-1aLk;
	Wed, 15 Apr 2026 14:30:38 +0000
Date: Wed, 15 Apr 2026 15:30:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <ad-hDv8QoeTmlPW9@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
 <adgJqiA0vivaW7NA@casper.infradead.org>
 <20260410061725.GA24667@lst.de>
 <adj6iibxNot-yc9X@casper.infradead.org>
 <20260415054407.GA26893@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415054407.GA26893@lst.de>
X-Rspamd-Queue-Id: 97ABD180011
X-Rspam-User: 
X-Stat-Signature: dax53wd6bb7yynij4pqjotxuax7w9suz
X-Rspamd-Server: rspam10
X-HE-Tag: 1776264631-498665
X-HE-Meta: U2FsdGVkX187KdBsm3aeVmOECBmO7XAl1KiGPBQAPq3ihgyVnnUUdAUcb+mTonJUzCOMUgma8NrYH5V283MBsc8vDWsVgqTtDnDSeIs8QE9NMErRbrAaoGGq3Cpr27HRxYen1JRRRlkxxYEBC9OY+ChcQ+oOtZZqsjMDM9mc+nUz6mxbNUGsgLVDT8qoHHZzoQrg20fsM6vhz1wuHV8yHnbHu58DRy7QQxgLS+mhznJ51ERfIwCRWWTulWh1TAUf0aMEQhF9mt9qJYhOaIOQduP9aTvP2xkrIWLR55vj0ZkDnx+FpnfFnRE2BetLEljTJAhKm/Z6V0eHNKK4F5TQ5qwFsf4sK3Pci8JukJ9n4UN2z76z+J6F2aKFmuVt6q7ryH7e0PdvgRKxA+p107aFBnC4TE2zydM3GjckWR7gsWBwZQ1+MelOMzucAz45h/M6He8/J7S313cgOl0ntFT3NnOQztAyZiAbGb/89t4icPIlwYVw2ngJoBVLkvB5iqify2lXP/k1XFMnj7ycsH9Pes7LLvH7ViLI5v18mEdsyeNwhGYedZc5+yknHaNgnhs7B0pzIcFtKNxFUDb6aHwZrVw31FV9yyphfy/jV3KufrTj/+EW4bXtbdUW+L3xGkbRZmJCgoQwMF+539q2JyxIUQ7x/F72gLmADVdPsrYgxvk2ElBVkN0CbKKaooUra25SIXiEr3XPNWIvFAgrxl6xFythqlCIjxBJBSKpJU6a/eX6WGBSJBdNpYXkHKn43nOutwWqbmJVym0AHDABfkto7Y1GfvriUP5uNduBN763c13fd4ttgArlvw52Ma9C9bIorZ7lyKEkN7H9NE4HabO98SNdBm7CMDXeK2o2dYGQGIAVQih9/Qgwhgp75S8PvI9OURKZiKkHGI84S0CIiA4Rtw8tV0n8zaanvsbp1Cz2JDwpkf/DZzOeoVn6OHAXLdmMhfSC92P40zjLNBxJM4v
 6eiFy3Cp
 awiF9oJMQEQIo7WhPFaazWQLujabe2vLT+HfKTAGTZwS/Ce7+3vK6cnPp5FGxlD4Dp1CuC6CkweKgt1H77BprqSHL/7NQ6yob2M4Uy2QTiPWZyRaS8X1RSMjARBux6cLLSEM7FBASLBTiIk7XRC8qkksVS+lm5lzgcGf7orvUTIvDrIMtRq3X5roYJl8Mo8CoPXHwrQu5+7zaNWg3xUcTyLFKYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 07:44:07AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 10, 2026 at 02:26:34PM +0100, Matthew Wilcox wrote:
> > > Yes.  On the other hand we can actually use it when we don't know if
> > > we need to offload beforehand, which enabls the two later conversions
> > > and probably more.
> > 
> > I don't understand why we need to remove _this_ way to defer completions
> > to take context in order to _add_ the ability to defer completions
> > inside the bi_end_io handler.
> 
> I don't need to, but we'd better have very strong reasons for two ways
> to do the same thing, and I don't really see it here.  But I can give it
> a try if the consensus is that we want to way to do it, and we're not
> worried about people getting the bio-flag one wrong as we could set it
> from ->bi_end_io, but it would not do anything.

I want to make all writebacks complete in task context so we can change
the i_pages.xa_lock from being irq-disabling to a plain spinlock.

