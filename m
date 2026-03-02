Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79687EB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B67736B0005; Mon,  2 Mar 2026 14:22:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14BF6B0088; Mon,  2 Mar 2026 14:22:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20C36B0089; Mon,  2 Mar 2026 14:22:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 91A736B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:22:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE3EAC17E5
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:22:23 +0000 (UTC)
X-FDA: 84502094166.19.5EF7020
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9B59E180015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:22:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EZBvXZcX;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772479342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45JV1FbUhPNRK5yswRM7EqKvKlI72dsQnxRCf/XH0b4=;
	b=jTjV1NQJBfFaN34XoWzdGbkz4B1HI1FH0hVvcWdiTzavGFXrkRbs7ynMIj6oufkOPJtEGr
	FsX9v29E3IHOkrCjleaZlvgKUkuc3pHAE8pFd2Uyx+tdduYkcPMRce3hTG2RYrIalrwLbn
	aKEC8lWaA1wFWGqRoBLmQLxnOPEKUUQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EZBvXZcX;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772479342; a=rsa-sha256;
	cv=none;
	b=0DTcqzIquyo2q5g6xTL2nTTmxnBDNOp6UVkcOakpQPJ4RUR7e1fQy5gKXy4P+FQxHJa/pu
	egSj3J0gB58M6mRscd8EoJF2QCOeBVpm/to7vMd21DZiuaxyckPACz1GE+KVKENcw5aOFA
	ZOkPwdGfbqLqu5cE8ALqeKz2gL/pATw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=45JV1FbUhPNRK5yswRM7EqKvKlI72dsQnxRCf/XH0b4=; b=EZBvXZcXktuQEKBGZo4Y3KHqOE
	sD8V1fo61T0BQ5d7LaqY1UbOP5TAlfC3FZadaKwlckt7m0THlPPO8R0mg3ohC03nme4LR/gSti2Fd
	cCfU04MR0yW0hlF28Mx4+czsTNjEHfbvpNWG2qJoqiGIARAOQkzTWTb7o+k4b1tG9042Ocb+rgSUQ
	gP/91jaSUoAtM/1BjqTiC7kzu3WJ3jcYNYzBZ/CgA2VmGdn3/grfN0glXE6S25qGdO36+3TYbvAIK
	gb+1udmIv6hF8ARXb/7QAr4lJnE1EZ9HeF5KN39uXXGhVdDjUMqLIaxQFHOA39iTWMfF8TYEDpnh3
	479QazCQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx8qQ-00000009y7O-3LOX;
	Mon, 02 Mar 2026 19:22:18 +0000
Date: Mon, 2 Mar 2026 19:22:18 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Alexey Suchkov <aleks.koyf@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexey Suchkov <dywoq.contact@gmail.com>
Subject: Re: [PATCH] mm: initialize 'seq' in gup_fast to remove
 -Wmaybe-uninitialized warning
Message-ID: <aaXjajTMqWOwdHhG@casper.infradead.org>
References: <20260302191237.34375-1-dywoq.contact@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302191237.34375-1-dywoq.contact@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9B59E180015
X-Stat-Signature: zizwxag5dm3wtkdfpze3coagubpi53yb
X-Rspam-User: 
X-HE-Tag: 1772479341-379708
X-HE-Meta: U2FsdGVkX1/1EqNeCqv55ey/FGvEhaPYQo//TT+br4VYm9B3+rzoOECWFTYMh9BgX0LOw5IX0gSVLT6JtbGOInT1Mg4HZceBA5mk/gZClVseK4MnuYLD5i5EjA6A/n5zwgNNakXdK4XLQlqDmeOaIe/xCsY1Ubk3YwG29Jq7dveDHSV103na69Fo7yfBjP6R0hG/efpJufWM0RXMuzaC+wj7UOnPedV07ttuWCzWqajv87dQ9DheB6BJXE57aryr1GVwHo5f4Fc2d5bv3Mkv4CoVHMxgAmz5bHLr1wa5e2PVXMq3TbNYz1BXk6jKaIXkPkhKv/EO9a8Tn6GYk06HD5z6w+MoSiP945JLwNEQODTacJ/TkBkiAy6SsY9qX5MVawTIvlV/DromoyIt/jtNMNwZK2dNO1GUeQu4ZmQuKMvKVIef3K7aSU9oUVSyQ2hottwfYo+wgGufzv3OC3akLmIUOcfA63oKBc/Ouao40XABQgt3PwxfwOiR83ctWcERfpJHbdPNnfFLIGDutwKBXOB1h7pfEczf9AqOpW0+YmAS47aj/iiZnHJDRuYAPxoYRqxIpV4WQbtQUwE4la5uXRQsxt/Aydt9szGn7yXRh7DM8MyALujTIBHy6Qpu7jGWX6twOwxvLbliODNP7z+NDQXIaMw1bOcN5fS6YNaTFXDMxXv4FK/rkw35n9WbdfxVvOC5D9K6cY5xuCLbqRTly9VXaptlRna93HJApjRNzEgHUiXRvwt0B49JfbZsssKV+HtgyREVhYT2+W+iQU5TgcjysPcMldxyuzwC8zN6KmHWDWGDYlwnKz4AxJeS5T+bLHepqBvikCNpfBtDuKTeZmxu9KA1KQYZij8GNm8tfx5xyjlcgq+CfXpe5+Ir5ccZkCSkh97nOZ4dIKzC4dyS3M7tqN56NgGp/luBlYCnJMRvrFabkMSe+jaQxh19Uwd570YE6qlpRabSecKPhWB
 fEzQrTJX
 47/IjS/etdIYtJJlXPCNA943CpjffB4CDAqh7ma9piG6+Ne9IapMV6Yk+vX7qMT2zmnwpaJZJSz07bxLxqeVs+kRgd5fivkqp3AGjrffZxvJl8bgcB6JVpn11a6Si32yaa4T8g0SO5lqUDC9my4Y7ga6VtORJVBgINL63qnanrsE0ZkCWxKiS20LQF2LhR0LopjkI++8KNbAd8vhUX5ysApN325z5DVhiG8f+cD/iFO23/CROQvc6HtBXVLP5RH4l8FO6Y5Xjf+4hxGHY8edIqrgibC1hO2hZKvvS0w0WVSqwTgpcRoDAZIG2xWrt0IEsOqlMQMNwznA4LLJ1gKSq2fvKezm+/Hq0wIQD96y70rB5UJE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 10:12:37PM +0300, Alexey Suchkov wrote:
> The local variable 'seq' in gup_fast (mm/gup.c) was declared
> without initialization, which can trigger:

I was going to look at your patch to see why it's wrong, but it contains
so much gratuitous reformatting that I gave up.  NAK.

