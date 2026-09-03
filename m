Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B131EC624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 23:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953C76B008A; Thu,  3 Sep 2026 19:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B666B008C; Thu,  3 Sep 2026 19:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8690C6B0092; Thu,  3 Sep 2026 19:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6882C6B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 19:20:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DEF8C160663
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:20:24 +0000 (UTC)
X-FDA: 85174021968.16.015FB1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4A423180007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:20:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbmS68SM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788477623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jd2d3+3jAhjlIWPxn5NVZwiUzcNZ9cJ6/qoOYbHQKEk=;
	b=XEN4UMROSGuHfGuEzXg3BUiesOspxo6ra3halOH21un+PAvKoX2uw6cR7NYPOKTtf3MWip
	TpJB6kFQlDHIIaCHQyZlmrFgDoGW3DsDlAtHVUr9LRXm31+/i/qrgD5D9lonmuC6aQBKB9
	tVR0AHQKHR5qrfPt/cEcNIg7zqDhN28=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CbmS68SM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788477623;
	b=Er9wtj+3yKGkCmEZmgLm352Tyg0pYipx5mnH2LafmqpmG2KEf8gc9oVSXltv5IxkKX/0Eu
	TTJWp6N8DVqsj0F7+venNn6U6XcfdbYbAMzwUeQaMPLwNYZmjUKYbsscFJtRaGlc94Kz2S
	FPfB2YzWuNj+uyHrsGvstQPmg/A6oFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B5F24394A;
	Thu,  3 Sep 2026 23:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7A81F000E9;
	Thu,  3 Sep 2026 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788477622;
	bh=Jd2d3+3jAhjlIWPxn5NVZwiUzcNZ9cJ6/qoOYbHQKEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CbmS68SMAunuOIZQWmpFtxCQk7utUuViAFHuUe6GjOYQeTjKYbh3yM5O5b9kOTSPQ
	 ifmG3Nrl9vmCoLVnHdRrQFpgCED41Toeqs5/M0737rmTdoDKiACzGWzRs23ETvTmjD
	 W8Ydj9CccjusxqmdJaUoQvrawqm1i8R2sHUPbmg0vp9LGdEMZ42r00UjL3b8H5EyBD
	 wEdMRK7OgDO+NfMseCQCA26acf9n2B/gDTD/VypyqG+PWIGePX8+VJkVPVLH7/DD7x
	 MseYkufsPHfkSdnaQSKRvNHGn5E2qiNnFyVPpYi0hffmbQ61y7FIiw7idmYd4fQclf
	 p93cNSDI3k3jA==
Date: Thu, 3 Sep 2026 16:20:20 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Johan Hovold <johan@kernel.org>
Cc: patchwork-bot+netdevbpf@kernel.org, Mike Rapoport <rppt@kernel.org>,
 3chas3@gmail.com, duncan.sands@free.fr, gregkh@linuxfoundation.org,
 akpm@linux-foundation.org, david@kernel.org, willy@infradead.org,
 vbabka@kernel.org, accessrunner-general@lists.sourceforge.net,
 linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] USB: replace page allocator calls with kmalloc()
Message-ID: <20260903162020.323f6cdd@kernel.org>
In-Reply-To: <aplR8tmzndmg4kfq@hovoldconsulting.com>
References: <20260830-usb-v1-0-aa349c302246@kernel.org>
	<178840081114.3041656.13596134068099743678.git-patchwork-notify@kernel.org>
	<apkRyoCr2dNI0bNS@hovoldconsulting.com>
	<aplR8tmzndmg4kfq@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cdbxypx8cgtdxgwwj4o6hkspum6pfp3z
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A423180007
X-Rspam-User: 
X-HE-Tag: 1788477623-129085
X-HE-Meta: U2FsdGVkX19gjIJyzMlbwMTkGBMtXLA5De8w+w6qo7g7UOkgK+3zy0i2mEzolUg+CXiVLL7lvBfAy+hL5CUo9PkBq72S4jT4UNDQpbFQQhKVkfGkfWC7LdkF4U8iqC69Cf0ZfCxdsCeKc+6lMOJP+hjqcEywUbf0g2u8LSm9A+bopjQIKdtD3iE2SSLaYVxH2zG1EhIGaals4qDZroPjzNFSnOuAQXHwq6IpM/UzTLIqm+Nw82r1yqLl2jV6g2X9AvbiqzbI9+S8Ez1L+DNyw5EIhHxdECSY897Ep8dhPntODsUb54M+YufxOlHSBGQok1FtlDFolJ/NTnlnyNSB+DGOSJJiMq2lEp2RXNGJ3XDOgiDUQCpg20J0pvF9riYlk+wqZyWjxuxen+hzighczfJ97h/TQsK9S1N3BSmx+t0F1Xj0LhvucXSO0tUhUzed+0ikZV1O4kTxVNvf5F3kTntBG8MmD4lFPGA81HTJFe1qjjXeKodvN1UHUbGpfS/uRQILP7f67QsILQ5eulWQr1zT6w71jkArDKvsVYxSUYzhor+y4chCDq0IDMORfv8XO2V6fa12ZsXecMoRsBFGaXS5EXSbp6/p3H/Ks71LT1DTwnQrQCiTYuUVJkyzS66qHAWcIjxtz7f0w6YQ3CEVyAumXywg2LJ740Ao+dKRYVM6WIcUgozhSNXSxCarR1uzD8xcR3WLbcxri9IzQotXleT4zjhUk1meymwmcj7SH6qJixxVVz81sU3WHWMqLSk2EC2rtCbNJGUddkLgRnGYoj5lMFVozOC7fBTNVPk2pdREZ2woC1IzvRyeB8vdHs+48fWpbs8GQ24zaZ1tDX/v53+LQLFjw1SUOWiaHAosF7lelrgy0DJaPbwcfW8r36szFIA8w+ORniWW45dMmGNbUL6TGwc9jLQQtZ/48QcnenMpP9SBJIkeKtYK/CIwFqN/5hBJoG1x2QwjB4yPPJJ
 vrogxWcv
 4gS1idlQWmdQKq4/VTgf0G2j47R+oZatYHuKecHcgqo+yPFQ2WVWOy0VTXBqhg/bHfXLPUrtbDAgqWENUdy8rVCNQT3aaUA2Y3p17mWvXBkyjCponeA9ckgTTdMktsn33Di3qnb1xyTEFHaNI+3jaiNERgJs0JukYWvjt2X/Gw6q/LBIqmGKrz/ZDPTr2WB7foQlfcGCRr3DKZtgpgQ91ECvIbbBXC/uNvMbESFFs2x1Z8R7VBQ6eTDbpxuFFmoEMFDpsuvAKm82Ki8M27Q1/ncFVM3EaUw/1hxMY63nSzJEqr29igmgWq53ZGJYkPI+lvIwlv3ZxDgw1K6nLG3fuGrZuDwWKHOmqckzZWFGx4m7iNm4VVdfU7OMAlaAFdLK7/+SPSDHYeFXlKDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 3 Sep 2026 12:54:42 +0200 Johan Hovold wrote:
> On Thu, Sep 03, 2026 at 08:20:58AM +0200, Johan Hovold wrote:
> > > Here is the summary with links:
> > >   - [1/4] USB: usbfs: replace __get_free_page() with kmalloc()
> > >     (no matching commit)
> > >   - [2/4] USB: cxacru: replace __get_free_page() with kmalloc()
> > >     https://git.kernel.org/netdev/net-next/c/a3b4826138d4
> > >   - [3/4] USB: speedtch: replace __get_free_page() with kmalloc()
> > >     https://git.kernel.org/netdev/net-next/c/534b18813974
> > >   - [4/4] USB: serial: wwan: replace __get_free_page() with kmalloc()
> > >     (no matching commit)  
> > 
> > Why were these USB patches applies to net-next?  
> 
> I see now that it was only the ATM ones.
> 
> Sorry about the noise.

Sorry, should have sent a note.

