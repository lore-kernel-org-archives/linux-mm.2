Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43DDBC43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 06:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443E46B0095; Sat, 11 Jul 2026 02:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4CC6B0096; Sat, 11 Jul 2026 02:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A9C6B0098; Sat, 11 Jul 2026 02:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9D96B0095
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 02:37:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 938621A06A7
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:37:38 +0000 (UTC)
X-FDA: 84975539796.05.CFD6FA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 127E5A0004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:37:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUKLPOwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783751857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvyeRb8ieg5MITEKIkWJ1aNjS0KVqbt4lC8GeXCqug0=;
	b=zRL55lGdfsAw7gYwJA2B6LVPRxHckYfRO44W/azeOv7VEOmMKu3R/rxSGLaImtVDuCKkTM
	LhdmmCH2tYPuhWL8qr6ofdFZ1Q0pI0yhkAIkY4aCDGXo7gmyM4DtARwN+zY1/jMPvMaLEE
	NZWocOIb7a1YabGslfwZk/DpEKS2P8Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUKLPOwO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783751857;
	b=kGoCMQpnDDm8FyZAJV5xfgJAzaFvtL2pUfzNv+7yjFv6gemvUsZkNfkf/u90xnst5o0SAo
	7NmWWrj8K5/WTuCds0iwQ42J+ea5U5KQTQ0Cmz5MyXJsAPtQtfGUMcR17/XJ31I5pNqW9U
	s5WqwuLL7gbST4vCSp/iYRyU+W70X1Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9701B600C3;
	Sat, 11 Jul 2026 06:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845431F000E9;
	Sat, 11 Jul 2026 06:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751856;
	bh=vvyeRb8ieg5MITEKIkWJ1aNjS0KVqbt4lC8GeXCqug0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BUKLPOwOKS9MkduqeHePNWghYzU5HZyLAT+9CRbmZZnlz+eZi1GBL19C2tHIM0zNO
	 WOnhH8cE/h318Ahl3yMlMClTpL5Fax+jKLRRf4b+2dllpwgo4Sz8KK6EmMr4BNmo2j
	 aEI6eMaVGSgJxvZLwdlnyVnBogXEcHjyGrLkQBdVjm6QwMjRHRBp5SN+kXByMSPhQ4
	 eAjrw335nzF6DOJzFhGyfC3rHH5SAHDQEVv6FKY5tXEOQ+bQ+0Oy7ieZGLzYMkAm7e
	 qZnBQqoPz6F8B+fj6G60OgQMCgeqdaBCfxOKuqi0iguRmbdTS1kcRKrxwcE5/5xH00
	 5Wgc+HlEJpCLQ==
Date: Sat, 11 Jul 2026 07:37:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: xu.xin16@zte.com.cn, akpm@linux-foundation.org, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, chengming.zhou@linux.dev, 
	qi.zheng@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Subject: Re: [PATCH] mm/mm_slot.h: add a helper function mm_slot_remove
Message-ID: <alHkQUJyr9UYlJKS@lucifer>
References: <20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn>
 <178368585772.363984.12871786869575753171.b4-review@b4>
 <alHG8YMmPYZWrKQz@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alHG8YMmPYZWrKQz@casper.infradead.org>
X-Rspamd-Queue-Id: 127E5A0004
X-Stat-Signature: reid5qfntob8t44w5yidhepqb9888rg9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783751856-935895
X-HE-Meta: U2FsdGVkX19PzMBl4ouFBZ6o+1DVtH5wxKWMn3mv5iQLtXnkclO2YacqniZJBwKb1W1xzhfWVjXgHWl8Fc7JHn60vlIpcd3H+nDJE8IbRKpBotPDRvXBidP62P7fw2a9bgcdASY+Omk0tZ3YHse96YI4JCmfZPbzrTXeDgsVfPmQy7O4pilXt0Miq9llu81SeZjnhvipD9Lxc5ZArX+9SKdi5qmvvxdZXehfDtPK0fJClV9UyLiGjWDYo6JxxPkWsC/QeavSSqYhYMffyLth5YzQ2ym2joST3eKALcc05dMRFcxsLDW7exhHMeYr5QeQlGp4ytog535LsbvVaiM647gry1wQ639vHG6H27D1oAMiFtmJ8jMxaiS2850Ip6J5lk0jw2d1u30jOIMP6QlIiGaNvi11UAtnzTBFbWrnMT+cS+OucNt+rBjxz4B/Bffi6bKUP3DCjod2JLZ50IJe7Xn45O1ps+/WBrNwhYkN407QT+ptSSdn1LqVVkrNpUGL87CAGnbKMN/q/W8UstA2PxoD132XfyqL600bv9tJQ3t00NmzzkUo8W07txtVxV5mHO/RTS7x1aWwcYanOWPQCZbZ0IRMoPSzF/2XlZkF3xWyyGv7Aw2GxXVDWE/9wg6gf5dgvnt/9jQiMVV/Z3JmmIMYwZQvw4MoVW90S0HGuqto0Z2DmXfRFDnt7+82V2Oqj7qlKKzhMTFXtjfFhANg23jixrJcIg4XUjNU2DhHa7CaZa063U4FyTbIDU411/rQ2JlaFfcjB7JqgAlWj+zjupm9yG64FMrp7dvLYaGobYSRl4zE7bg6cGHXhlTOKd8FEKHum9vtlRd6vW2aXGhRFRhmP95o1J1wJ+tVb6HyBgkxJkwxm5MqsC5EzxaEgBMdBSFxBesJI6VUkUnj0GONr//RlmNsDHcS2IWbtkNXf0H0Webo8QxQ8edQYGYKXjtWaOpxpsmzahzNtyC5wU1
 g5T9Ybuz
 Bq4uBYD23MDDmjA9LEG7fSu3cu8khVNBmhnufwota1KhDS4einx4gBk+1U/V5juh3xAMG5MeZkoNKmZEZ5tnb3NYPEzHqrI2NvDNJ9rfdXPGWO1myZG2S7urdrXEdgyRNdeG4p2Dl5p4B1vVZ6GG2AtT349IiWOfC17khjUWxkSo1EmUYOWo5w1IaCm3EUQg2X351JWEvOZh5ch9MKQRxRh8VyCYgocPs9BXPv4hoHkTiw0WhRYmQ+YTlUmeOYEkG4481/DnzDmaLoTcPJu2q8XBiEWdh8JBZSTKt1ETU00nX6RQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 05:30:41AM +0100, Matthew Wilcox wrote:
> On Fri, Jul 10, 2026 at 01:17:37PM +0100, Lorenzo Stoakes wrote:
> > In general it's fine but I want more :) see below.
>
> ... and these functions all need kernel-doc.
> Not sure where to suggest that it be added to the Documentation/
> Thoughts?

Well could just send out to the KSM/THP people? If somebody has some bandwidth
for it.

Or... are you volunteering yourself? ;)

It'd be unfair to ask Xu to also add kdoc I think, perhaps do that as a
follow-up?

Just need to get those nasty pointless (AFAICT) macros gone.

Cheers, Lorenzo

