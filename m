Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF2BCEE356
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28B976B000A; Tue, 18 Nov 2025 21:48:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C1E6B0099; Tue, 18 Nov 2025 21:48:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BCC6B009D; Tue, 18 Nov 2025 21:48:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1BA26B000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:48:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEB3C1602CF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:48:57 +0000 (UTC)
X-FDA: 84125824314.17.84FF269
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F9DA80003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:48:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPtzsA3b;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763520536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtsC7i47XN3tI5AGAWoOTV5HdfOayzfArTnlJqAY4dc=;
	b=HbN/kdR1cWTBV/UvBe4QiY3LivzK5s6XxcM8Hi+HFKBRFB7NBDtcaI0cuRFkL1/He1urFZ
	X/J0yQsjhF0zW8sy3sYXy2f7uyzYLj2B9dJfWBpvYKU9nz/9jOBPWSoFVcYYn5eSQIV+hj
	IUB2LeSC3cWctFZ6kn6mC8uI32s3YEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763520536; a=rsa-sha256;
	cv=none;
	b=NoYf2qOGwzi8r8hb5RX5lQN7Od0+U4EIhDtRFUV710p0lzjF39jtrgOfEEA8oedCYLHruH
	C5/zADA3SSemzlNv8ecHU2dStj2AvIO7VUrg1V7m/nWw5PetcS+25fhYTLcRGLHec7HXyg
	+JlMVaTuWA0gx8v7DiJIWWYkj4s3EMI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uPtzsA3b;
	spf=pass (imf30.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5649A60135;
	Wed, 19 Nov 2025 02:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB412C2BCB0;
	Wed, 19 Nov 2025 02:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763520534;
	bh=UzR+D2r5Tf/NMJV7Pdd89HkiknvyfNwrgoZJRhBYlTs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uPtzsA3bj+RJ4iXsXgs/v75RYb8MDA6CzPXlfd/l2gyeM3HcfpU2UeYokip/jYhdb
	 KV3oHoY/IFnUw/wTiTiVUm4gPBMKK6He5iuiNh/o9yf15FCDd/84vRpYMn/D0eBZbJ
	 ihdiKzc6NBcNRkyBWb/itOwqN660VLn35+5/JHkoz174Wya+5QTRMUtFWnySK1nqNd
	 0wrE/0bx6OzUEOjpOny7ToS7s3HrZUd8oUrLEL1IW0qa6Q6X9BiP3mTMsIjo0QbtJS
	 OQsS3HZrJK0cPxkWL95kdkhB9TqGBX9/MQajYjfJ0sE4gJycEjcNC+hyU7tVlqVoNg
	 g10TxtYFnhFPQ==
Date: Tue, 18 Nov 2025 18:48:50 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
 hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
 asml.silence@gmail.com, alexanderduyck@fb.com, kernel-team@meta.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 mohsin.bashr@gmail.com, almasrymina@google.com, jdamato@fastly.com
Subject: Re: [RFC net-next] eth: fbnic: use ring->page_pool instead of
 page->pp in fbnic_clean_twq1()
Message-ID: <20251118184850.068273c5@kernel.org>
In-Reply-To: <20251119024546.GA18344@system.software.com>
References: <20251119011146.27493-1-byungchul@sk.com>
	<20251118173216.6b584dcb@kernel.org>
	<20251119024546.GA18344@system.software.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F9DA80003
X-Stat-Signature: y3knphewde5abmie44oib97hd56zpgi9
X-HE-Tag: 1763520536-8961
X-HE-Meta: U2FsdGVkX1+arRnaihCDjC1WzUg+qz8uj5wgE4Popw+fjiFzuSQGdXNOFlJqeLZYUTgYWLk3Qx0CFA12UrbgyjNb0DOBFl63yKStXFklwcH5IZHx5EMdsIBskE9hwom9i3M8VohN9eo3g64s3j8v3qIc47Hau6P8ABiSx2FlILiVOhL4XIT1BDXB7Pr7SyAaTdV8ZU5h/7cwbXtnDw61GJkbsoOELcwJtp8TBQiBx8r29XFt3orLG6U+zv6ZhPA2D+VK3UOg6/f1piHnfTbEOckP1BpRD5fAUPp3ToNP/U6XCAKsFLLW822on/JFPpKF/hnKwNBMynqOdOnMCbJkyB7nUSWpAdcFc73UR/vkTwWaNhAgdtP1OWmY73pIwGnUWF5OYWU46sGRPD3iM3TdIOj0lfeRghRAP1Sy9NNEWzysyXTz3USg9Td7ZXYaVVJvGPnJbNktepG7Kh6RE05DbgDT/gjSZhCkjIEMq/Ym2cqTZJg4a0wq04wrryRuJXWsNMfTX3EjM8347GaJOEV4Qnpr1LW9Yr3ioJrjRfAYqR/76giZBoWuTGIw6l5Kx5Jbwfa6sO52lGl7M8C+HC1fJtY4S9EOohaAoxWsf4PZPmB6iSW1bY4n6SiXiKnX8rPiml/Q3wMecnR2p3x3zQpvq+hjV7V4lzxaqKw35fn7P0SbNbYpGLARxy28JaPChSnBU5MH7W/FyFc/I7mEpMpNIqgEg+GL7iO/brgTp+aUUiGmRvVkuxn2UqMaGD5UHhrpVq+HuzJcb4xU+utgRnLBd16NGlZp+HfbJGSKwUDmNFIWOB12yDpgcJHsLABSjByBIM6WNypjrk1HI9TZFsu/ZRM1FQCQc7rLJpYU7YMnEiM/axWc2ARAFwis6RNncXc1jEkHDLUmpBZKp8h8IW+bJ88HgyL5QtxmWQgd8/FfO4NvGmdpMPYgfw/NxKx2CBcO6M+NuHDBvECZ+kX+vV1
 MYpuN7zl
 hA06XWMgZxVDC7FL9e0+H4s3GF+PPbT6B3dFd1csYDBL3rOfrYUHE3eMM6XPrX1n95J5rIYn12LCuT1YyVYPf6NrxwinLQR+JvV0zAiLAqY3pil6v0ESj/MsG+76Aw+T6AdmqhmVxgiwH2zyeaO340wz+kC55KNbk9pojyC5XkQq3P0qylZiosEyXnvVix/7d5/CJxe7mhy5ZabtyQtvqzNn1TyHjfNh6PizBrD4cBIIh6FblzdKruwUMVxZp3LOcAyJAvn3R4jk7HIcKzBKfr3e/Q8M4spBQIingVe0t9LdQusUPXYBqWOg+rmOh1lsh3hCXZRneZzGur0SOUJ5+/2kfnIJmTHjpb7Y0A6NKHSh8Ws7Rb+BJK3S1XRmMYvHNr7lNzoMkYmAVWwR7+VBwt7nqbypP6HAvByWK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 11:45:46 +0900 Byungchul Park wrote:
> > @ring in this context is the Tx ring, but it's the Rx ring that has the
> > page_pool pointer. Each Rx+Tx queue pair has 6 rings in total. You need
> > the sub0/sub1 ring of the Rx queue from which the page came here.  
> 
> Thank you for the explanation.  I'd better make it in the following way
> rather than modifying the unfamiliar code.  Looks fine?

Yes, I think that's fine. Just please wrap the long lines at 80 chars
in networking.

