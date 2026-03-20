Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D8B1093170
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8F646B041B; Thu, 19 Mar 2026 22:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B405D6B041F; Thu, 19 Mar 2026 22:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D356B0421; Thu, 19 Mar 2026 22:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97FAE6B041B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:37:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FAA513BA86
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:37:39 +0000 (UTC)
X-FDA: 84564880638.20.ECA2CB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AAEDE120004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:37:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Om6KcrXu;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYVW+mY55uzfqPfTCFo7zJeYYX0vBKUEot6RLC41cU0=;
	b=pvdTMdPlkc5sDkdfQFP+w1z4UgdbAwGMPZubKMRcNuBevz2bAxXDUAQJjpImaf3pAAIlKt
	ZFubeGL/vpwRbWnS1GNTjtOiXp09qLsruMPyA8g4+uwjv4S8MrejM7zpuZ97eXbdjA5u/g
	TcTx3gJV+NCkgMulAC5tIN2H6IKgzAY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Om6KcrXu;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974257; a=rsa-sha256;
	cv=none;
	b=G+n1Gz8W3J+Vc+4Q0sKuQjU+GJJGtda8e3IKJEbRt+HeYcjkCIJpZN5wtPZMChXj89BkJX
	lOJtllbouO7NMsj7wHzePRKMEq/iDm2p4uO1Nh4Z8/Oja78StzVsknlfWpw33q/3JtrKcr
	Qvk5+hPlKy3fDqXVihL2jHRzf+LpJRw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB84940687;
	Fri, 20 Mar 2026 02:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECEDC19424;
	Fri, 20 Mar 2026 02:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974256;
	bh=Ce9ZvvedBVgFA/+wmV2hIlsGSiYitcDJqHPohquR+Zk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Om6KcrXu8DE2JhUZs0+F2J+y4aA2hbY89smr4crrjx5cRej3tpnwOxli02mGOXb5b
	 0HZvTa5Zfc83wD+u2NAxu5b7wvyTPBmHCZiD+dySxaGGzRg0SxQpDz5fDdp9gdzJlb
	 Obs5tI+hxPgFgGOf2mx7oJ3SOuqr6d+c6LP4BxUU=
Date: Thu, 19 Mar 2026 19:37:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Elver <elver@google.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, Pasha
 Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v2] kho: use checked arithmetic in deserialize_bitmap()
Message-Id: <20260319193735.2ea34594b36d37e7850a8c37@linux-foundation.org>
In-Reply-To: <20260319210528.1694513-2-elver@google.com>
References: <20260319210528.1694513-2-elver@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAEDE120004
X-Stat-Signature: ss3awzbpngzitjx6194ckxtuab8355n6
X-Rspam-User: 
X-HE-Tag: 1773974257-230799
X-HE-Meta: U2FsdGVkX1+6JIoM4ysTe2UxMzZbRLm2kwkfFD1JKMntANOCqO9h2xh0tHmQVxZRh7tVWAKp/aEjxKvqFJWbC8r9Bx5gI5GJWKyUTKax9pO/DhGdORJwQ2xk3g/yYQXrPJBFOrnOqGcvXTk5tYUfi2PZSaxKIOsQubeXIxxzODyLdO/NZI7XEXB3r6+I9iMwIE1WLnng0F/nXXhpV6kzu78FFG7hmsk5nkMshJZ5Qt6tJXyJFSq1FB2wWv5GRSMx5/H1wbD5REYtaOMBoRiooJlU7hQ3z+dD9ZUjirLE64xX/9M9ZtIki5bxmYnuwfLUePaenAk/jz4jPrAfsM5xE0M1V5PL9EDO0nO0KwGnfqtQA3xKLGr4NYOTkzB+hGO8QSFwRt7horqOERabAh5fQaL2p07Pi5qli+0rKD0BzD4DzZAScvxwQ8EGqIqzIWhxAt72AoP1D00jwAhXgnkNYaCSrli/IkrFz8ktBKUkY05kp1NCWiToLDOehpn/955KZwMLIcIQVggvZ24MTG45FA9QxMK7Itq8Zo7cVjQtILPnxA4IUF1dglHxu0u3aSqUyr3pbPGB5Cp5k9gflFOTBDdvKD+Pkq4akMtHPf1hf1UzsK5o2yHm84dAShrTffW6Llxo2kWoDqNrpTX3soQ/56vUS+37vW12uhwnxuJf1ZDp6bCRyX2y+Axzbr5bsGZbr5dD/DdSowkuqlXbsmTKGbtEb/OmrX1LsnGuViP9Aay6tO3HPPq+wbYq3/dkmg+pOXxQ9qe7tQfOJDBy30od0+dvfCdlFiPIOwuC6xrM7gTEMziH+FZz5ZXWoFfDq18TyNP3n/tJK0d2TBPbyb4K9FHKdmHXdbc74TOPejG+nFo1ubSoQqClDgcDWdKCRvjq88O9CsPUs6v1Awd62eMSQjJr6HFpQDoJmZsCEH+x6tNRTlbeLC88en3N+1UmxLgj+EG1MipgvTeEkyNPMqs
 PPYAJiYu
 PUobImHf2ei9NeRYW3GSo1wh6vLGxylMx4nDrL5IhPtSIQN31lFOPuDkvzWVnHbCyX+XuhSvn2NAALRNRLedzK0Z0EJfu0QokvP/QqkpgDZikGna+QCrf3raOXXgk8FItLtunfvu93oq7D1N8hW+/q3thECxlT3sY1fnek+rwcFRKP7p5IBPTJMT9lluaD4My5SOtyBJ9Y1fo+Bqu+5g6rxtGVwTTphoGS6UNemXiHPPBDwIQAGSnwjx/ZTU+UZgMpmyd0OcuXiyv92N4UmtdrQUkG3zXUMoXUeHc2ni5a7pt/UL8rLTBwzD3timOoGKZG1hdoSQjUO9R15Zxc6BIm2wi2MFsEDqhmZUTlOeghFyBy1GhXaquyNEsCi1S41vroC7f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 22:03:53 +0100 Marco Elver <elver@google.com> wrote:

> The function deserialize_bitmap() calculates the reservation size using:
> 
>     int sz = 1 << (order + PAGE_SHIFT);
> 
> If a corrupted KHO image provides an order >= 20 (on systems with 4KB
> pages), the shift amount becomes >= 32, which overflows the 32-bit
> integer. This results in a zero-size memory reservation.
> 
> Furthermore, the physical address calculation:
> 
>     phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));
> 
> can also overflow and wrap around if the order is large. This allows a
> corrupt KHO image to cause out-of-bounds updates to page->private of
> arbitrary physical pages during early boot.
> 
> Fix this by changing 'sz' to 'unsigned long' and using checked add and
> shift to safely calculate the shift amount, size, and physical address,
> skipping malformed chunks. This allows preserving memory with an order
> larger than MAX_PAGE_ORDER.

AI review asked questions:
	https://sashiko.dev/#/patchset/20260319210528.1694513-2-elver%40google.com

