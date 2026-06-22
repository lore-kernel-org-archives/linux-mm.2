Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A860CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846E36B009B; Mon, 22 Jun 2026 11:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EE36B009E; Mon, 22 Jun 2026 11:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C836B009F; Mon, 22 Jun 2026 11:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5016B009B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:42:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C38461C4A2B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:42:22 +0000 (UTC)
X-FDA: 84907965324.12.D39963C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FF1820002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:42:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ltwk5GUW;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782142941;
	b=8PgUi9Eo2YmTUH2BZiuTQJU3qWSZ1xY31yvxT1/MAqIaQn68oARNjpLLnJwGBx+yQvF4VH
	mG2if1JYwdkXbBltLeihFzouw6Y/MJ65HLbY+tniwF3y+sCp5ur9LM6Hsozbqy+034FrV8
	sPSIKlRpTJuomG16YH9gmxhrJPhK/70=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ltwk5GUW;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782142941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHJv21RfcqXYV0YgHyAqjEAPgB65Hb7a4g1x/AwkD00=;
	b=eFFnJvw/xi/NEQb3+Mq9+t1w5rPV/glPTJ/mNDd1DENEGtDiuy9lDA1PH0LcKY2t7CMGuP
	CMXZKmCpNxAlA3dQi1Vtc8OkQL6yO7UBA/6S+k3+cM8kb1w2C3cU3Wy6Qs8BzZdGH/dxqe
	7ESPC7wJEREej/m4pSunx1vNXKxgbsg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4291C406A0;
	Mon, 22 Jun 2026 15:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4371F00A3A;
	Mon, 22 Jun 2026 15:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782142940;
	bh=yHJv21RfcqXYV0YgHyAqjEAPgB65Hb7a4g1x/AwkD00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ltwk5GUWhRx19bhrpVQNuxrvfV3dfh40QSCrkheU91HyybacQU85c3GMCppUlDQTd
	 48tsMRIj4CFkV/DnoBZ0OjAieDfe5D1NwLhFxfURcGtIhYZwRmI/QtKXD1NJNpR9GG
	 HrA7oLczj4LM3R0AyLGiCvI3yl+qZTcSiaoNl7i0lk7iszDJOQeXIK9rCEa6Y0UFLp
	 FT2kHC1JeNm6z/IuYLfbtBlJN3wvLpoy6aUP6fGyUMYq4QmnJm+mF+dNjXhHDs29t+
	 caNmnwIbycjTfMwikiu6s74ishOOx+rigFzBj1TbmUg+gz8RLQZZDzAKmAW5vEHo0R
	 36XazeGrmW8qw==
Date: Mon, 22 Jun 2026 16:42:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
	Alex Williamson <alex@shazbot.org>, Anthony Pighin <anthony.pighin@nokia.com>, 
	linux-kernel@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org, 
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <ajlW-Lf_tSBMccw1@lucifer>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <20260618152805.GF231643@ziepe.ca>
 <ajVqRiAMG23QGseC@casper.infradead.org>
 <20260619170705.GC1068655@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619170705.GC1068655@ziepe.ca>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2FF1820002
X-Stat-Signature: 4cqt31x3tuqeezp5pgyjnzigynspc8hb
X-Rspam-User: 
X-HE-Tag: 1782142941-309872
X-HE-Meta: U2FsdGVkX1809QDIncVWhmieu8vbK1YvCqVIqVwXHzOJBpwEB3ZrHlEwrKhOX0Ed+t+cQHPLDc+6waZF1+GmAYc4ot2sQuu2Yw6685yIU0CsWcfWFHEtszeJfqaAomoo5MakdGMVFIp/OKCgp4+7qCdOhVuskcyHsLn2ePAp+X51z+KJnPNCP4yxw8HPD0o4tKlyWHZbuBgF63r/t38VQNYBG9qZ96AsJExLsOtPt0dB5Z8y0vs5o9p62jGPTJx4HKc6T91OKBCQcvbt8OFBI48pcGIgLDBIdEvZudKoyUlBb/0eR0Q+3OyETPY+dIvh9IYMPxTJ1rSRJwxUQ35SmeYR9Axo8HyIM/mekUdoOfSxN2gwPUTzZQq1nzKWbLB5EJO6bB4xhnyZ4azso+3vKxkei5AKH3Pk4yoijF2eBtkBCL1hOqOlLPIiB7gzxVf/tQn7FZA/fTVJDmbXscro/ZedBWB0B3cMN/3Tm4YxcxogZeIwz66k9bgjNBo2gf7KIbnJ77slb0PI3mu/CoF8JVTJ+jbUjXgvxfuhpcpc8kLTxNJxakDBOCO4dO0IrGeV80R/OJqbOYZIj624EpNOD/rnzyJ1G4OZbMzdwecQ9BCjZbKJzC+ned07+TITl5N2PWVU3HjLRLoqsp7fH50lGCadieYHIHPIPM9X37GOXKDX6lfQc39+DK/rJ1Zyg5fQYyb0KHI8+SneTuenGIrzNQ/hF75cSnip6uRyBnZB5lHiZfkPZmvLyaLOfar34U8fl+HoYE2yJqUo/EdYk1U9LV0Fw5LRiBI95oOX/pRVY1kuhZ2dGEEt4pDJ3mYe5NSaY22d+l/Zg34JtywfyNc5YC5kf2AQ3cHoIXrC24u22dgA6PubXBt7nS5MPdlS9s4Lm2eR7Vay8/5oaLsLm1GW8PRetQaKH1a3HpQoyTL+vxuRt2HpA9i3UdOZ/yPj86AhWKgpER+YOaFKptMMT+V
 1c5NXZSv
 OZnNJeEKtQHslp8eOayU8B1WEEvmPbse+QT7P0+lq15/nMGtJXn+jivM76m4NNSLtoubziiqsfVTa02q9M66XN0BtaxvTJ3OVBwte6WYbP9N6xFaIEMTvXtg1eftshyBIDYmXvgj5wzP+cVxu3Ytb9DmR8u5+5IXZbmjwWyz3k07mrzHns3pAh1Q8NgDb7tYMwkCC6GQoS2np16ZKJRUKKorP0qdzI3qxYFUGI4DM3a2xnhZZTsz8KPeI58Kd8LL2zlvD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 02:07:05PM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 19, 2026 at 05:11:50PM +0100, Matthew Wilcox wrote:
> > On Thu, Jun 18, 2026 at 12:28:05PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > > > Can't we figure this out from what the driver tells us when it invokes an
> > > > mmap_prepare action?
> > >
> > > VFIO installs the pages via fault handler so there is not a naturally
> > > existing way to pass in the pfn?
> >
> > Is there an advantage to doing it this way?  I understand why we (eg)
> > demand-page pagecache, that's obvious.  But I've never really understood
> > the advantage to taking page faults for PFNMAP areas where we don't
> > really do anything, just figure out which PFN needs to be installed.
> > It defers page table allocation, I suppose.
>
> VFIO has a model where the mapping can come and go, so it makes the
> entire VMA SIGBUS from time to time. The only way to do this currently
> is with faulting.
>
> The mm also had races around populating the mmap in the mmap callback
> and using zap on the inode, faulting avoids those too. Lorenzo may
> have fixed that with the new interface though

Well, you can't populate the mmap in .mmap_prepare, we do it for you.

I guess the issue there is an race with an rmap walker? I did add a (slightly
hideous) hack^Woption that keeps things rmap-locked until after the 'mmap
action' is complete (action->hold_rmap_lock).

So perhaps with that that issue is addressed?

I am figuring out new APIs for mmap_prepare as I carry on converting based on
what people are doing so I guess when I come to VFIO I can do the same thing
there.

>
> Jason

Thanks, Lorenzo

