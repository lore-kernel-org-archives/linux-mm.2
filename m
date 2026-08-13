Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFECC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0726B0273; Thu, 13 Aug 2026 09:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391506B0278; Thu, 13 Aug 2026 09:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6A76B027B; Thu, 13 Aug 2026 09:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6B86B0273
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:43:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98545140179
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:43:38 +0000 (UTC)
X-FDA: 85096363716.15.EE61869
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F1A181C0005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:43:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqFpH2CS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786628617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAHSyVZsm9YXO0RmUNpzPqO0wNYBSTgob7pwAZgh2Oo=;
	b=pV1k8g1L2bJk8xfbHNNGkritZ2ZOEo/6lyxk5XoVZaIeAEFk9+cUAnOBLjx8Usj09OY+1S
	jbuO9Miy9+HbEqY0D1i1YylVkK7nqjVy2pgQMYwGILsRhZ50QMWz83De1fA//UMGiAGfaJ
	g6dJOJXAE7CeqfyGQ1ICpOclIXq7NZk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqFpH2CS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786628617;
	b=kfydvuaIf0jT5eL+cirniyOsmx4jmQSXg5Tu+T/INozv/AbAAe9OZEPrb1uFk5N+SKlzih
	iKk8nbTl4T1mON9gK4Zw0C0l6gqiLj8XnIECBwY1CVaO2jFm5rR/r75f3VWBAbix1bBcIK
	UHnBHmOaMOMp9N/n3MMcNmT+cVbSDwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7083660120;
	Thu, 13 Aug 2026 13:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C7D1F000E9;
	Thu, 13 Aug 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786628616;
	bh=WAHSyVZsm9YXO0RmUNpzPqO0wNYBSTgob7pwAZgh2Oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IqFpH2CSq9p9bZR2i5Y4nqzZOu7/zIMm7Iez7N30zxLzo/UKHOkmIEB92KVNtmyC6
	 LIJxCaR/sgEkr3lEFG/B1ATruQUTEI3JpcV8Wf3YSHjFi68ieH/1ciWkveUnIz457g
	 6zZK5UeOjOZ3BXnJpdG0ofWa6EXcdBUvXZ7wSlzDqtwn6bobxllc0oMqunKMCYD3XP
	 OkLHdQ2hhWrX7wMZdX/8K7oVIT+LtPVwY163C8IALm+c9cbu7UUAhlCY2eJzI116yR
	 +/yMSSC8DfNRa29FAz39Z1APfy0F/8caGDrWDAsZOOMkkZWyi1fcdkTQeJQSE74mHj
	 kxkpqFE72yKxA==
Date: Thu, 13 Aug 2026 14:43:16 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an3JiUfhRPe_X-kC@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <an3E-5BuWLgwzrd-@casper.infradead.org>
 <an3G24JX-ZE9Obbt@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3G24JX-ZE9Obbt@lucifer>
X-Rspam-User: 
X-Rspamd-Queue-Id: F1A181C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: dq9pzqpbp3m5u7sjwohwscurtgjhzur1
X-HE-Tag: 1786628616-481116
X-HE-Meta: U2FsdGVkX1+MTmdfQLw9MHeYBOD8GNjBbfbCT8pvNOUGuTgDu3Jvu0/qh2VMPMQDJVPAEftYgqn7NmK0qd2wk6hq2dHwrdyZ25ZoF6CweZqBq52hNcogYzquOroIpGaqqZkfMTAlqdNDN79pdqFRdAYIuZIgbRWdSKuv3emyc2KbPqxLXHUijW6uGb4Q1Bf6IIdZ4Onn0UtGlow6Gzofev47A3lA/DbXEFzuwDNvGRrIiZGKRoKDVUiC1PFGrXgSk7aFmeIKAf2ZspVZD4Q0IGOvZ5dy+zF3i4IP4moctj6oFIGhbXZ9yoFge2GSr8Np9zHlxNwRwICFIR3tswxSAbJ7/sjd4ZOap7+tntdsNElnh/0xvCrDt9BecRjUy5hSpfGYlJRwmElZZ7kws/qyFMWbNCTFlEp6yyp0lX9HCIzC5R83eF0WCzeDn4XXCDwNG4rKtD9r2hJgnLpnIyiPqU/rWT48yCGgjdFMWx2aKDcT6bg0soc0z4YukbozPfgYgWXcUhd/TZO8Uo8hrsmMO8TCwEYYdjfJcBqfx3/M1I9TUz9d7BCfmpnCd8u7Ht4iUSlMU4VD3hESM6QdJ+c8ROSLaG9ng5+eEL6ws2MMjdqPLPCNsEcd8h0pmXKBvzZfi4vSJ/Qf95JB3lBPomnZykJJ543tYcURhwUQ3SD2o0ThPUkv3lYRbuRQ7f7WFeO/D6tbc0oBWz+n6F4TMyyYwM7iWlv4r2FA1dN+YjPiDxlPjSkov1i47nPEfMhJI74VPXRZOfImHSoOBQR3cKM7jdHQkHJuMWWcgVQrd8bkn2pimg4QVreKWauw3QbyJWXuyvEholzI8aY2aQxvSLz9WvVQjQz6/D7JUqMbwtCBqtVT2wmwS/xZX/FHDAeZooGjGqkfsTzCw9X+DnUBI8BvPhNKn6MTMixty6xXauTHR4hADCr2bBgqA0uKDiBm7r1aErNS7/oFfjuDJI1ghkZ
 Iq87uLCh
 e01d8dkl1y+p0mDqUiHI6lAAhY8t7QBHB//Q5BQA5+L9Pl6rPOFKVbkVGgKBy5n/vMmI6y5QC1mUvMMvsk13T1u7GukLAwdr9pbiDHGpvBCZB6gY9vremyraxBCwcvfHwrafgq3GPkVn7myAwThp+jOdvDimwR3D8UdUIv0/yVUijylJRl+I/rEpROvA0kVa3PSPVkfQG7pWy45fXBuI9FUImADbzXy0ZWacxO2YG82Ep87Y/BYGci1kRysbzLGvQpppbA5wyogmia0I3r7dDxS3kfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 02:32:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> I do agree with Greg however that nommu is something we should get rid of. See
> my other reply here.

Sorry this was an overreach - Greg didn't say that :)

I mean Greg asked if anybody uses nommu, the answer is yes, but the real
question I think is 'is anybody using a very recent kernel who couldn't either
use an older one or maintain a downstream kernel'.

And to that I think the answer is absolutely not.

And if the answer were yes - you must surely be a company with a product
(security concerns on a nommu system is a debatable concept) - and then you need
to put up or shut up IMO.

--
Cheers, Lorenzo

