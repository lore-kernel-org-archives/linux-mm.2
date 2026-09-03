Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4796C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95D06B00B9; Thu,  3 Sep 2026 02:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46C06B00BD; Thu,  3 Sep 2026 02:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D615A6B00BE; Thu,  3 Sep 2026 02:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE4456B00B9
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:21:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30588A0488
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:21:04 +0000 (UTC)
X-FDA: 85171453248.09.30BFF10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 880D5A0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:21:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcsyK+iw;
	spf=pass (imf25.hostedemail.com: domain of johan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=johan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788416462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ezvwsuD+u14PjNnoqia2u/ikHfD23PiSeMOTx59SyOQ=;
	b=gB+XCwKmwcoARBSY182flIFrf21AS9F6Yme1F0BlCeJ2opy3vDIQ/roP3rRdfhhK64X5ER
	yV3E9+xR5beifq78XMWgy1NzknWhA1iI5HxmwBk5odsMeATQJgDKQZXWMHSmDmVmVWA7Cv
	WzfwmVeD4WTGOGxkBxQ87SeYuHMcgY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788416462;
	b=XM6AxwUWojwWQm0eSaYyUctkvFNAEdNQkeFkfTzt17ihbDdc7IANpevdnX8vSo7eTEt4rM
	G+KLOdx2gYrEv4EF3Sb5wCHdkSjeEre3FXwDCWP+qEd+LdXhYUTeo9pnjv0Dg8awhTDm5K
	GtTvZcPLjtJT81mkkORgOnuk26qBB3Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PcsyK+iw;
	spf=pass (imf25.hostedemail.com: domain of johan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=johan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30EF4600C8;
	Thu,  3 Sep 2026 06:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CC61F000E9;
	Thu,  3 Sep 2026 06:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788416460;
	bh=ezvwsuD+u14PjNnoqia2u/ikHfD23PiSeMOTx59SyOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PcsyK+iwGOgKA+wkEdVujasyooSN/g8G/3SWmvA0aK4DTO4e5rebZ45LBNCBnw9WQ
	 zgdF3JXR9mDEJlDBnsRCsoy58th9rFL2q24kSyIJwApAqV6Py9etnC+qjumCE4KL5j
	 Y8Uj2XmA05pzcW8WRMx7Yjg279fUtFhmfRvB+yE0Q8lwcoo9yD+/iBkv24Se/dwTaW
	 9O1G44jOT6mBV7tLjQo1+GgfJdx0zZz+zqsrFO8BDnikpR1J8jyGGbKnRsnDi4lqZe
	 7XU3w9T2KJvuNuzykEf6UHanO8UkGXDzAEDRLgYrnZLNW93HV17ugmY3PcDRPPSEJE
	 SQ05bco5JpnRA==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1x20ok-00000005jqX-0ZFU;
	Thu, 03 Sep 2026 08:20:58 +0200
Date: Thu, 3 Sep 2026 08:20:58 +0200
From: Johan Hovold <johan@kernel.org>
To: patchwork-bot+netdevbpf@kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 3chas3@gmail.com, duncan.sands@free.fr,
	gregkh@linuxfoundation.org, akpm@linux-foundation.org,
	david@kernel.org, willy@infradead.org, vbabka@kernel.org,
	accessrunner-general@lists.sourceforge.net,
	linux-atm-general@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] USB: replace page allocator calls with kmalloc()
Message-ID: <apkRyoCr2dNI0bNS@hovoldconsulting.com>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <178840081114.3041656.13596134068099743678.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178840081114.3041656.13596134068099743678.git-patchwork-notify@kernel.org>
X-Stat-Signature: ry3askh61wi8bj4uj6cmytkd6oegk83i
X-Rspamd-Queue-Id: 880D5A0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788416462-69025
X-HE-Meta: U2FsdGVkX18HAZiQR0Hln3jEQrZBpdVQ//1STR4UbZCA6BiWxIY/FBMj7qpxLrd1Fd7LYBWkoBYyYSWkMC6TBGAMgvYsNCl4G2my/NecNEdX3bZ6HthOZCRczpAjDO9t3baknFkaLJrAgUerLY93/uqEu9Rqo2Wy5Lmh29VxRP+YVICN8ccKm6HPo841GmprW8Z1kZ8pA+kzRiKN3qKvczcv4w+FIg+JxRnkwaiB1rITDztHyt+XjCz9VD44VDKpGRNXilo+Go7/fZ6/3stZqORkDr0xfQBijeXKASGH68bdT5UQaavoi4pkfu2fjPFy8o9xRKyBIhFb/mthgb/N0naWGUPK8dNSjsZq/rk/3X0YIfd6s+gdeoGWe1DcWvkgEDaWJ6doMl1w7Ub1vIbgAwxZnTUeyvKZtMmELyfXe0ZkLz3fmlTJbdM93TprRfBLKvEwSZrDVjUQEAwQDoNeCpy9s1ijKubf2iH8xcFAOyg0+vK8Q9AAN+VXdzgBXeKdVOlrQTjQVOA0Nk3CoXV5AHWHg8Rc64nu7c16UtMo2Qmuvg7iOYi8o6kh+BrLhWuJM5UtmqujgXv8eksUZ7KB20xhBnJd47yoIMmSy/YVAPwcUC0Uqq5gTC4TLebQGR/2HOnZGME0mfLkePHzWw7+jAu7yCvsAOVLNURbh5fODfkCq/1mzqSzI9Ng94rDEJ6kv3fhhxsfaCkg+Mze+p6s2GN6BLroIo1fIHxXaLN2xqqDklxH7DKxfbkGPD6wRWh78u4Osk6ohJPEMtI1euC4P6uGH2tWgAVYB+QDY7OF6cNgcSjHsIp6eRDpBGPENOYRY4R1Lm+HMXxx68qdpHH3F1l9odtMZsX2b+sTg798NfCe4RDdSF35t67N+r95z5ZsO5xUUxtJSxphFT6rlnfpCtx/222DrtdRaMm2whSQ8BJMCy4xve95JQOfY6w8J7mhHMxHZalziKZEl7kmnyM
 M/6XKIG/
 Ry4iwN92tgrluQL1H4HqyZVCQiuS8JP+qIga6PAtSU0LuoYG2rpzvhXggbPtp0daeTx+OqgvJAlrzhgPnCKxsNNI2TtEovkbEIBDYPP8q8kq1cW7zTk9O/N0dDqECmFTdYvlHElIOY3Muo1rgzHrjesZEqVso5xkOcyYspb0eJPAWtekyuqtPv2ONyT3q+xiSaYT7HwA8M1xsCCkudo5LQ0h2W1I+qbg6+yX8hKBjges8B5skFMNmhiaL7MIZ9NoeXouNHglXBOpTCqrZ1hlPF3HyfTOUBFRMUMGZqMPszEeOJRRECDMHPek1r3VcDGmcbVEVoRvwLTdl/MRTsQIxoZMFmnM7oiq5UnZ7SrpqU6fD02w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 02:00:11AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (main)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Sun, 30 Aug 2026 11:10:36 +0300 you wrote:
> > This is a (small) part of larger work of replacing page allocator calls
> > with kmalloc.
> > 
> > My initial intention a few month ago was to remove ugly casts [1], but then
> > willy pointed out that Linus objected to something like this [2] and it
> > looks like more than a decade old technical debt.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [1/4] USB: usbfs: replace __get_free_page() with kmalloc()
>     (no matching commit)
>   - [2/4] USB: cxacru: replace __get_free_page() with kmalloc()
>     https://git.kernel.org/netdev/net-next/c/a3b4826138d4
>   - [3/4] USB: speedtch: replace __get_free_page() with kmalloc()
>     https://git.kernel.org/netdev/net-next/c/534b18813974
>   - [4/4] USB: serial: wwan: replace __get_free_page() with kmalloc()
>     (no matching commit)

Why were these USB patches applies to net-next?

Johan

