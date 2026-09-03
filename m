Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDD5C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDCF6B00D7; Thu,  3 Sep 2026 06:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78EA26B00D9; Thu,  3 Sep 2026 06:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4C06B00DA; Thu,  3 Sep 2026 06:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACF86B00D7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:54:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C12A9160477
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:54:47 +0000 (UTC)
X-FDA: 85172143014.04.033E45E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16EC516000D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:54:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEYVSY1A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of johan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=johan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yte+8LLHHjHRtJk2Wim31OWnwZFXKsPlPjw39cWebrY=;
	b=Ur79wjCg/kBaQ/K8Wcd1Lm8/yshWx625llbBLEBbKOvB8cIASlJLC12lBh973mZXja7jDU
	tXS/E+KMzxWZZKS9RcBdtd0mm8miEyl1+V+3f2FvxPUBs8AA7S97wO5X2CDUdOSioZTtWg
	1Z4FQ2RHqSe5pTRuADZkaqSL+DG+DeQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEYVSY1A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of johan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=johan@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432886;
	b=8q3q1LXB4JcAEDmxPwFWM/v7JSCY559xQMxvwOnGiqvIDiKtc/8BujVTwYrpUH+PQ21qwp
	0UfjOCTNSVLqGFYeuwsRuu0tK4umFy4OZPaUeZgQMuKkHaLDvfa299Vf2IO8q0kLYg1TqB
	jvvsjteZDsHD3y/WMIV960OOhAfNINk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7F1741AB8;
	Thu,  3 Sep 2026 10:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93931F000E9;
	Thu,  3 Sep 2026 10:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788432884;
	bh=Yte+8LLHHjHRtJk2Wim31OWnwZFXKsPlPjw39cWebrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FEYVSY1A2Xn3I1xKM06H+6iDo+CONHwGUrieaf8YLTIr++gbZ/osX1XJBvIyQfVgS
	 5pG3pNip6KnKrx99j8e2oaxupXZWjgIqdQ6F3Wz24RDGrXbqC0EdgWiVp3UslPHcrk
	 uu9VMayxq9lhK6wcGnOxI7udRC1b7SsLnCHs9tz01qbC0lff43D55N2utRlitv5pFc
	 fZ4bjpQO8DdHg8AG1klb0Ora+nS9wqxH4yKtxoykH65y3LudBJKx/FZnJZQiZsY3Ot
	 piK0p6QgVo0uSP6e+s9iAajiKhBQcFTul614EjzoP1UVJbVTIHo8DrzxswovFhI09v
	 TOYQajtG33zew==
Received: from johan by xi.lan with local (Exim 4.99.4)
	(envelope-from <johan@kernel.org>)
	id 1x255e-00000005wji-0O90;
	Thu, 03 Sep 2026 12:54:42 +0200
Date: Thu, 3 Sep 2026 12:54:42 +0200
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
Message-ID: <aplR8tmzndmg4kfq@hovoldconsulting.com>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
 <178840081114.3041656.13596134068099743678.git-patchwork-notify@kernel.org>
 <apkRyoCr2dNI0bNS@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apkRyoCr2dNI0bNS@hovoldconsulting.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 16EC516000D
X-Stat-Signature: 15stqrrqmcrtqzf5dpyyyhtyegwq8n8h
X-Rspam-User: 
X-HE-Tag: 1788432885-31444
X-HE-Meta: U2FsdGVkX1/jwSCR5JeXqTbqDIgC/icrGGTcHMB4uW6Leph+SCg6u9svUIghlfiVapjlAAGYtRglWkJotJtnUTvyN1CWiwQRDKXL/cLdZGxd6HnVAb+yoCeqlVXXU645mp5VgXEOFd+isUw7Jb6x9TamKFVZHirQBj3ewq27XObiFOcyvLeCQWZzxCULb3TXIP8McuDSBI02gpzmDl66LpIa3Lavi+tAwVb/+16gTt0IWrw4ycU2LXUlN9KLV4fdQHG3O5EF2QNLjHCi6fVPaQ95NdmuPTtR8NkLUNcCddbKyK1C2USbk8wfvIjHgkzEtPBQy5H2TeC5wGRRC80ajA26+f49JyEqg9j0ByKqQf3GpLBZz2wDwgWWetGTj6v8kexXO7dpFRbzSwp9qh7FonPMKyTjvA6sBg9M0OPxB75OzM+ummjapd6WyoAPhKb3a2ENfQlch+TMxMbZu6yBOEsQ6ZFgnGLU8fVExi7Hp1Q4jXE11856tAbI8sU2Ok/nrHyEQibH4rPd84XZ7GoaGW3xG+BIyPgq5O2rcVxfbo9iBpwaUB5b7eHuVHQYrIlyJs1xpndv6y0fU+qyfFdKI64ts1WAWyGV0u5/Ajs1ITux12Mj5JVJnAUNugsw9082CJRcz20qvYHidwV0VDkR/rsLsk7CfXle5kvYZrPeVfy5ns1OuTKvjWJGw7l0tcokqBI2EZ8TsIa42s5Hi7ndZN2jMbzAivflSOHa4raEdXsKQzevUTz5bn5brRCBbupsi9gDO5/SHq8UnL6gr0Og4eE8kr5ok9PcMoN1TvlWdN/cnZ3o+KwLfQWGMbKTWNUfsSeWIMRouQTSYqpGiA8Zu0Yt7TzivRy4Qq0Co6WDbNcwhyEufJv+UAdLO7GjGSqw5Pz+PSFWDrIAUBWssVFLtuM+hQXXht/EENOGP8snTO6mAKDdobr2RAGUNgaPsLAnSz3xTxHyUV1emsYk37W
 A6dFmaY2
 NgqNyGU9YuZUnUlYRx5Rvm9VoJZd/9L82nVcblmfufO3ksXsZ8ynkpoQmk79dILlueMjknxMdk8gis0QW8akzJ3wwrL6x8ZScyIMqMHrw4JvA3H/wviwvbkyvI0XMqrcA4z7Q8/5br2/dxzmtfNSLi8jopf/6ACvp1DllxJvHivjz6OmJWtLyqKQ+a5CGEaEzSgE5snUXeqQV4h7HojFbsOQAZN53USK59QqwTGTJQn7BwB5/2mTmg6zoqtk1bgLdpzJJQlGeKD+pYgOcCNvOLXGwoXc8BJFol3BtOsYPzU/lvuzJC2ldPQzuDc8qV7WGT5Xh/028hUNeRnbOl80pYHdYMTlPTKNJwEs7hQp/QJ5TNbI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:20:58AM +0200, Johan Hovold wrote:
> On Thu, Sep 03, 2026 at 02:00:11AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> > 
> > This series was applied to netdev/net-next.git (main)
> > by Jakub Kicinski <kuba@kernel.org>:
> > 
> > On Sun, 30 Aug 2026 11:10:36 +0300 you wrote:
> > > This is a (small) part of larger work of replacing page allocator calls
> > > with kmalloc.
> > > 
> > > My initial intention a few month ago was to remove ugly casts [1], but then
> > > willy pointed out that Linus objected to something like this [2] and it
> > > looks like more than a decade old technical debt.
> > > 
> > > [...]
> > 
> > Here is the summary with links:
> >   - [1/4] USB: usbfs: replace __get_free_page() with kmalloc()
> >     (no matching commit)
> >   - [2/4] USB: cxacru: replace __get_free_page() with kmalloc()
> >     https://git.kernel.org/netdev/net-next/c/a3b4826138d4
> >   - [3/4] USB: speedtch: replace __get_free_page() with kmalloc()
> >     https://git.kernel.org/netdev/net-next/c/534b18813974
> >   - [4/4] USB: serial: wwan: replace __get_free_page() with kmalloc()
> >     (no matching commit)
> 
> Why were these USB patches applies to net-next?

I see now that it was only the ATM ones.

Sorry about the noise.
 
Johan

