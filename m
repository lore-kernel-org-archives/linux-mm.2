Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9E8C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04806B008A; Mon, 20 Jul 2026 07:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB51D6B008C; Mon, 20 Jul 2026 07:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA67B6B0092; Mon, 20 Jul 2026 07:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B51D66B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:53:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC4EF8014B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:53:21 +0000 (UTC)
X-FDA: 85008994602.04.FAFB685
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0891E80002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:53:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iV3CfCkf;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784548400;
	b=LS41voS3GUn0yCTbq1I4tk6zsCSeRzgrhz7spi8p/1w4Ya6B3/mx7Gku03R4+VSkYv9NlQ
	aas/52FSArxNQF39soqC4JV6ReO+kxK/kXkqaPNXoNmAjsbfmaAHZP1f7/tyfmnJaSPuj0
	UFAOoKj9a9N5v2T0czxOjhO4Pd3HVE8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=iV3CfCkf;
	spf=pass (imf30.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784548400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBnFxppqySBfjs+Yu8Bn669JHSlUb2xCcGpXBfWqu3k=;
	b=sXkWl3jmKeyX4Vh0iMx27b0rDqV9UJXJsMxYEprpslq3qyb7lT737LA68XnQIeBLpUS81Y
	rsg2vjv6DJpYwLnxEeuDaFF8M/Wzsl9J9bXJYwdINBOyQp21dqvN5Qy32DLM5Tk7AVkkbH
	cwJQUxtiJEdhApf2QbO5W9ZktvJNC04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E94B60A62;
	Mon, 20 Jul 2026 11:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938281F000E9;
	Mon, 20 Jul 2026 11:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784548399;
	bh=gBnFxppqySBfjs+Yu8Bn669JHSlUb2xCcGpXBfWqu3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iV3CfCkfO7yrsVL8wboRWdP7kqjLv/TjXz9iX87TumvPVceScjB74UwRsW5XjdOKd
	 fF37wlRke42HkShcIE5gJpuvmPFrbc8w7+qE4VB4wjLOtESBL6ewsMb7fJpfN3URZG
	 gxCSzA57jRbeWwb91c0ioc+Y7P6GzmiH0oI8MSIM=
Date: Mon, 20 Jul 2026 13:53:10 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, sj@kernel.org,
	stable@vger.kernel.org, yikai@z1k.dev
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Message-ID: <2026072053-silliness-slacked-8997@gregkh>
References: <2026072041-rearview-unselect-3f92@gregkh>
 <20260720110232.312053-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720110232.312053-1-aethernet65535@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0891E80002
X-Stat-Signature: ygcr6ynikqzkyynidcs8datj98a58n4y
X-Rspam-User: 
X-HE-Tag: 1784548399-955092
X-HE-Meta: U2FsdGVkX19OVwMyx86wD8zM9btrwqr1zzuz8sAja6uxK40O33EU2yZqSdwTioAzDrs69924xwsh88F2NcdB3LcC5DKO/0gzV9PI1rtZgFaVSZp3M7K+ceThuBPt+B534PDoQi+8XP0V5Cc03IKsYbjYcnZBn2eFPmqawwoD6MMP90Wh1ex0pneYzNPTTQgbHFkRQgqRye/RI9Lt09wcd8SSRf6AsGYbCiFVpu2uD9urePfnHlUFMJssgYZRMeCOUcemGOxV00cLM4NjzkVbmVZX2sc6rnMlORWbDUCQQLz9Lavx/wlUB9qoD0obxvegu173U9wpMPV1O2XAeezbcIpNHlL3LN17gLrOaTlwjLWSEXZafMk3mxKnpGJltja4rnteKObcMQ6zn7yf4FdQyPXQWsMUZQhZSD04CTdqMgbrPBHZqBJzqgUMwINjelXOaYk9gjeX0z03w+4mFJH9G84HgmsBsmnGvB3Pvm7uVLzYUDEuN/r3z3rsLHQWL2MmnqgEzbPYu9Xkva0MG2A0UjkxHHyINt7sQ4Lw+2wIEWsyQHWGV54yjYqhswPppbolMhmtezSfTHjQACBRExjXEvxB4QMoCcPpMgASzEP9UozKjY2Bfr5mBSs2jzUZ3Wd4fn8ptL55PJkGSsb5fwQrCj/1C6qnLL23JTmvchhg6k/lUq04nVWHAxPyk4qwgogXhLN+oFKnkzCBtxdE6WV5p7r7dsYq731UHlDKIMD6m6piKeWb4+87F598keXo3J4JeOLsNe2xHe6wO0rZ8HblhNSQaSGkCqrCRmi5FcdeWDLnwdSMhp2C7Wwvas/FPq+FLKOrz8LC36VxZra2h5KttNaLR3cGuYNcMF+lpKNMC2/6bopA9xClXE9wiNG6U+zpZZZywTcREeVbcMIbVOCTCP8SA/kWrCBsnpeTo4h3dH2iD2B7KVMsoCXXN8+FRrHFpccSyJ2o4tld5JHeu9u
 GbziEml0
 Bu6NWiWYEzETF1xJkQYu0Xoxz2xRFt0AlBzaSY4MfMngd2/EL2zTQjdJ025nH2yhD9ti0SA/+IR8+8i8GkwJCovWUWggaer7a+6THuNSxPzy6W9pG99EQW1Hzy/FZWUjFDRvKtoyAjoNQnWb15ev2Ia/EYk3w6xdEuRriY0Jwiypzt9MEX872DbY2MmjdlfNFbubF1vas+PiUEE64JWRB9AAbcXZMwPW//6rpa8biVLQ60693DdYYMEBU1Rckg3hQ5IJ0mT2Gi3PxAHq8w9QgDV5rsjiFYGFDKOmKZmFxQtDRBNXxxMd/PHKCy+kLK+yLdPtU6utAjGZ7180LY1UtqtOkJckZfjhRmp9FuZ/hBouFELmnH4i8BsOcRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 07:02:32PM +0800, Liew Rui Yan wrote:
> Hi Greg,
> 
> On Mon, 20 Jul 2026 11:59:03 +0200, Greg KH wrote:
> 
> > Why is this a stable-only patch?  Did something go wrong with the
> > backport of this commit that is not in the upstream version?
> 
> Sorry for the confusion!
> 
> This is a stable-only patch because this specific function was removed
> in mainline starting from v6.2.
> 
> Therefore, this bug only affects v6.1.176 and v6.1.177 stable branches.
> Mainline does not have this function anymore.
> 
>     $ git tag --contains 2f54908fae21
>     v6.1.176
>     v6.1.177
> 
> Let me know if you want me to resend with this explanation
> explicitly noted in the commit message.

Why can't we just take the same commits that are upstream that prevent
this issue from happening?

thanks,

greg k-h

