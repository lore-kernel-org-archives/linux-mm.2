Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569FFCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 01:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CEF6B0088; Thu,  1 Oct 2026 21:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE026B008A; Thu,  1 Oct 2026 21:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104C16B008C; Thu,  1 Oct 2026 21:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2D7F6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 21:16:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D3E21A04CE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:16:30 +0000 (UTC)
X-FDA: 85275920940.05.413CE8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9328CA000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 01:16:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bIZVV1f0;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790903788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdhaloUS4Y2BCpMzkfsa7Cgwj3Yupg47+wKbGB4PVH8=;
	b=HuZE1bMu6s7fkd65j53u1r53FWTRZYKVb9CH1Jbqn8R7q5s2JRB2CPt/wFL+zViVx7EoPm
	HO2cMFyZd1aA+hJMTQip0IOL+xJeUAZ8HcCsRafAuTKPpi916UO7WjF7mIIti2LlK+h5D+
	evy2ySx5poaRafGdVnci0H4cxga9UXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790903788;
	b=Lp+D5laLputL5pTn2ab8+RDWrRkMaCCF48lFL8FviSZWO07QliPBtAM3Pz998KnxfinPKw
	IaIT+JhWxXnGbS3E3RmjAN3fLJiaFAHUIeJ/2+TQLR9DWxM5dzfGr5Dlz/2XO/tPq8KNNh
	3TvKgOMkZRUzqQ/3OukaOY6UVqT/jr8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bIZVV1f0;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FDC44147D;
	Fri,  2 Oct 2026 01:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB7A1F00893;
	Fri,  2 Oct 2026 01:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790903787;
	bh=hdhaloUS4Y2BCpMzkfsa7Cgwj3Yupg47+wKbGB4PVH8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bIZVV1f0mbriI/AK7Bvc3wxcbax8H3m6HVkH5EcbvxmxPxumrw7+L/z5ovbjGarm6
	 YmdqUfzXzvbLfdGTz8flSmA3QGCJ9GMC5bXWBhXSSQ1wVg8pVS7jhZxhSsMBcyJoE4
	 eUM+XsUMv4ExHdv9Hwbhekcc6DAxuDaq6yjZpTDY=
Date: Thu, 1 Oct 2026 18:16:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, linux-mm@kvack.org, Christoph Hellwig
 <hch@lst.de>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/swap: submit the last readahead batch before
 unplugging
Message-Id: <20261001181626.b4aa4476f1b3649fd3e6d54e@linux-foundation.org>
In-Reply-To: <20261001095238.2417205-1-joshua.hahnjy@gmail.com>
References: <20261001085730.2029773-1-alex@ghiti.fr>
	<20261001095238.2417205-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9328CA000A
X-Stat-Signature: 8zuztyajq4gia7jkbq7ikug7sr5wmsex
X-HE-Tag: 1790903788-888313
X-HE-Meta: U2FsdGVkX1806jhYGDNJrE4S51Io9JzW++uNS2ZutWDAm5NFpETc+elHeeLjNQpjPBot+SzNOhWTf4GyHYFJ54XZ7EjIRUFEV9AwnLoQsUTw9x5mm2R+zwnSFmNVuh5M+amsIxrsrw2hKFz/wW2ai1n84/q35jpY3Wb+OSveUp1WSH9WpdN17+S1Hxzqx1A3b/XK3vBWYoW9qZcx2b2sXVPwNA4fkoVObn9TlFZWSIgT4+G3sc0U2dUK55ThUi62q9hU83XN8H1jA+EKu6mNFe2RpG/S6Qrnd+70FehRPfKp05mrD+XAZim6cJbhr2GeDrkT4S+6rRCaKGRt4F6RMQDFN1Ahq1HNinGlGAkmrobio2Q5cVTZnxcZkpsg/38O00yE/agBmtq7mO0261ZMAY8erd4XMO0orbiwuJa0yrzDnmOO6FQgAsA5zqy0TDQeHZKtRjbPTQU00DrGm+6qewVm8vCFVIM7rphk4l5p2LpP6lVlqhN+ZYUkUdR63P5GmUwWiYAywgbPD5umqaCdWbQYo9LDgaIymbOqN77LeoeWVw/Jz4wxq8zhEkLKIkW/9aFwBtWdshC3altaUsMfD1HO867vvKFp9ZJ7bAaRjrGkhuRBesXRCiQ5tffDd22Xtst6ExKR/n7RgKIeinkV2K8TcxsRInAlU+bHlGtyJ5cUUG2ag9I3tuhQkfHjA0YGKEq5eMHIkqjvlTWbBJCwvP2eow3LfDDLIqhJ2QK+AcyWMxGreUYAfYdsTh4KEDG3sZ/wh53DIeRyNDlG9woEZ3B/3jy6LqeAWKRL4yfDg7K+679prFizul6Z+BlyC2dSS07f8wG3H092CQJeImAs17WJO63Jf5dEqXH5v6NWq3LNsMunVylb7rl8qLqfChZD9tsB3WOXKkxco06a+dOWZN3WDa0XhiFtI6+JS5omkWh2diBriM78/dQysa8cLtoy15D9etlMXBG4HF2vVn8
 0W6G0x2P
 gK5pveIAdC/HPN1FY6nIhhkv0J8YlE4AovABCF6mA11LubjMBzxx0y77CpTWSgyVoxOvDFcwC1Vx76H+QA0RzfceZcivQRM2DJYGnSx9dRqS4zDZTGSPn6cRhRHhi88gScXuL+JviklVzihkwNJ6v6BXqVGMZZmKa73ug7nw7/RMZqwNbvjx8JSHgEdraQY/JjenIO4B1A3qbJUa9FFqiD65NjqaKIf4/4/Xp7Fv5fBL5vJ5KHaL94AByhJmx6mkqXRB2vz/CynWBY09QsiNweuuiS+QslxpBQ04Eiau6UDleGei7s7qcPPVENjY0dCmmnZRUImAr7mZJZF9TXU6xvcV/xXFOdfEN4oXN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  1 Oct 2026 02:52:33 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Thu,  1 Oct 2026 10:57:12 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
> 
> > Since block swap I/O is batched in struct swap_iocb, swap_add_folio()
> > only appends a folio to the pending batch when its slot directly follows
> > the previous one, and submits the pending batch otherwise. Batches
> > submitted inside the readahead loop go through the plug, where the block
> > layer can still merge them, but the final batch is submitted after
> > blk_finish_plug() and always becomes a separate request.
> > 
> > So submit the final batch before finishing the plug.
> 
> Hi Alex,
> 
> I read through the code and this looks very reasonable to me.
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks.

> > Fixes: dda8fb68b590 ("mm/swap: also use struct swap_iocb for block I/O")
> 
> My only question is whether we need the fixes tag, it seems like
> dda8fb68b590 is still in mm-stable and not merged to linus yet.
> 
> Andrew, what do we usually do in these cases? I am wondering if it will
> just become folded into the original commit or if this should still be
> standalone.

dda8fb68b590 was added to 7.3.rc1 during the most recent merge window.

So the Fixes: is appropriate - if someone chooses to merge dda8fb68b590
into their downstream kernel we're telling them "hey, you need this one
as well".


