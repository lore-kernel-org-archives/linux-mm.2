Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4F26D41D7E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37236B0005; Thu, 11 Dec 2025 15:04:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE66C6B0006; Thu, 11 Dec 2025 15:04:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBE36B0007; Thu, 11 Dec 2025 15:04:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B73A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:04:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DBB488EEA
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:04:52 +0000 (UTC)
X-FDA: 84208268424.14.229ABEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D099C0016
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:04:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XrOBsbtw;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765483490; a=rsa-sha256;
	cv=none;
	b=Qvl66vL8bU5Snnai7CeK6gcKgqnGCks5MZDFT88FM/t226zQK2RA99OweD2Sv2w/f07sJf
	j39cqwzQftZB4y7GSszq96LwBkmlDh3sqYefmZ4Heh9DqAeo53zhpcZk1L7cTE3i8N+mmI
	1PiVQHbgtpxOIdL6YMYdYrZvnLdd/iE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XrOBsbtw;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765483490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCj6CZIFMwDWqO4IYBo7H7H9rX/kKKqTC4rfYsfVVkE=;
	b=tG4QbrEDZM5QvC92DTg/JUXjbzGdzlpCjkO7ZkE5hu4O/10c/DtydEUPSkqFXfYL3hCpCi
	RiBLlxxAfym9evc3mdrGdRNdG/4amRqp8bNhDpShLw50HvL3f/ixA+ZKKLc5oB7A1ZGd+O
	PmnFZQDJlAFsagEzjXeTktf0LNMQ+kE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46AF142E21;
	Thu, 11 Dec 2025 20:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05389C4CEF7;
	Thu, 11 Dec 2025 20:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765483489;
	bh=tWPJ6Cx/h6JkS/7/YzHeKANRm/xCo+1cG3XgCtCuwiU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XrOBsbtw/XYB5npPaSynS4CV4AMBE2tY55tK5rZrPjTRu1Ksi+UU4XhlDi22CE3Lh
	 7tBaBeRWmxegG5MC/sLM8ADqsy9h6jyPyZft5mRFvka/pPpPov08ffOJV/IX2oU9m4
	 Fow9Q5ZBHE07MmhCD/rVrE8InQjUJnoTCzLLXRas=
Date: Thu, 11 Dec 2025 12:04:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yankai Xu <815559068@qq.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/gfp: cast GFP_ZONE_TABLE entries to long to avoid
 shift overflow
Message-Id: <20251211120448.817a352350813ae84cb600b3@linux-foundation.org>
In-Reply-To: <tencent_917BFA629ACDD8A2E6A32C53CEA147C66409@qq.com>
References: <tencent_917BFA629ACDD8A2E6A32C53CEA147C66409@qq.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8D099C0016
X-Stat-Signature: zx3k7puc6updchfxktf43dekdaw1my56
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765483490-31565
X-HE-Meta: U2FsdGVkX1+L35w77z3r6bPOXx1D5KCU461nwCsv+u5Q+tKMyyR1KCOUcV5ZHIgQi4PaQMyZ35azNqTm35bHvv+bdyI1P+oiBvmp3Ndj1ODZiwRZFyqJfCMgbC71cUzuKpMiy796rqp6dn/XSnHDnJRQdzENRNBHQeEo7rC7oFx/7nn05qaMEBpQMAb+rHTcYkUJO3M5EpeSQ0EEVH5j4vGS9xBQ13kF8uvxVoYLOo35eqCVAEIqPxpve1uWKPll0neImhCti7qIrcT4WxYJB5bXNcOxs1HNz/eOyQQP1pBm0jCyMJGobfMcdbHwVUtrI5BNy0xBXV/5fKZykkeifzJmYNc90EQms92kVvT7V3IwjGdvBXCbkdzX88JwHGfdrBvIrXwCq01MKOkhVHz1C3pCRVJLeBr2C2mXKozqk0jZFkml8fZqkleJT6i3DssXPVlBo3KszsdQv11+8/v65AoxSThYFeUHsY/FGP7Itj4Y9h4F+s+KLQGTkKCit9r77JrCUcUqQPkY+9ffI5HQ1GdXDjFLA5tgZKNYRc6DIhFF0K12yEC9P/gYQDyc77xbwz87nx7wfWMsGDZ8g5cKVlC2iUcsfQCFxag8pHkXTp00syEQDOLvxUPUBDhF5Kw2F8gqeVZPAYe0tE2BGaoJAXr9QVOoHR7g6WOEp8iI49q+M7pMJvbcabp6mKpR7PD1tu9v0Q1rmSQDLJ39YsniZVWzg/0XevK9wR26RTpkRp9DDyM0Q8oUpqPLLkPRIad+hovd8xHmtL3ToqgcS26jmE5G/6yP3DNQIZQBBhP8nF4CAt8qDGjG/49NB8298R0SRFEv8NBWjnVB7fol0hXruD/08pZLzr53MXr1Oi9YO7R/oYU0GnL7tBa2PPgvyQxEsuCTrt0f4avsy6PX9AWChCK+ZlCZe9pAHTmIPY2f83jlGt/moA9+ZQUt1LfMoplmBoxP+rgTd28gnQC/o0K
 qn29IGDn
 stKq4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 18:24:05 +0800 Yankai Xu <815559068@qq.com> wrote:

> 
> When a new zone is added to enum zone_type in mmzone.h, the existing
> GFP_ZONE_TABLE macro causes a compile-time shift overflow.

Thanks.

Please quote the compiler warning messages and describe how to
reproduce this.  Please include this info in the patch changelog and
maintain it.

> This happens
> because enum zone_type is of type int. The shift is logically
> valid because it has been checked by 16 * GFP_ZONES_SHIFT > BITS_PER_LONG previously.
> 
> Fixed this by casting each value in GFP_ZONE_TABLE to type long.
> 
> ...
>
>  #define GFP_ZONE_TABLE ( \
> -	(ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)				\
> +	((long)ZONE_NORMAL << 0 * GFP_ZONES_SHIFT)			\

It would be nice to find something nicer than this.  Perhaps a type of
something was poorly chosen.

