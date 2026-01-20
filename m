Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91B3CA5FB9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1999B6B0470; Tue, 20 Jan 2026 12:46:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144226B0472; Tue, 20 Jan 2026 12:46:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B536B0473; Tue, 20 Jan 2026 12:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E73FE6B0470
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:46:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A089C1AF5CA
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:24 +0000 (UTC)
X-FDA: 84353071488.09.0517955
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6965180007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:46:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uB7J5VIU;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkdL6exjZRisK29PWXrwZU8OGWsXzYf9OGkm2KvZw8g=;
	b=jcA3vbLPV39ob65STUHpOPqVeZ3AXP2F8gz/ZOvALv2YAjRkFcpuHhzHpbt3VEpnmPGjLs
	mc/+5T9T9yPmM8jqPukdlzn3jPvzp5ywMJVjxe4XPZzahhK2mjAdhTcNupK006tsvOI9uj
	6zX8zM8kdxY04y5TNO2CGe5bM8CCjtY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uB7J5VIU;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768931183; a=rsa-sha256;
	cv=none;
	b=otg3a5BlY2q+EmjEerKKzepXthFYYy1oi2lpdxpYkfdZTm3xL4v2Ug34+bVoQlVsYgW8Kx
	J5D7f//H1iAUJSGpgP7C4LznXFRXjcvNbcPxy4ehvjjH+UKeSJOD03zO+oTWO1XWFHYmDb
	89ViHHdq3o+fmhvAd8ovhUfOdQ0vh+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AEB3F43509;
	Tue, 20 Jan 2026 17:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532CDC16AAE;
	Tue, 20 Jan 2026 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768931178;
	bh=d913gHiC7qyAQGtH50oI3jMK1kbHhTOj4kG7zU0QOmA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uB7J5VIUyJlYBEPPsxzVcA4alTvhY6C6nzyO6qsW2rXfF7KeTSdxAvdULVMLimp58
	 e0wofVjX7CNvQNv0DM7awPKca4ol6l2pbrvVd9thyhwUrtMZz8w80mOxqX0gvitatf
	 ODg5ErvdlaNQ3fygK7JRr98fQWgTwsd8rl8rrzXo=
Date: Tue, 20 Jan 2026 09:46:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pimyn Girgis <pimyn@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
 dvyukov@google.com, glider@google.com, kasan-dev@googlegroups.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/kfence: randomize the freelist on initialization
Message-Id: <20260120094617.ed5a53e9ec40e8f0a91f8cb6@linux-foundation.org>
In-Reply-To: <20260120161510.3289089-1-pimyn@google.com>
References: <20260120161510.3289089-1-pimyn@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c5xerh93xja6u1f9s58oqut5ysdqacex
X-Rspamd-Queue-Id: D6965180007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768931182-301911
X-HE-Meta: U2FsdGVkX1+Ib5G9+1DBM0UrGoT6a2S+/6vRmqV7x8i/dL1BtpAUwB9P1IGGBZCtI4+QDf+hLws6+5k/TKEiQ7EhceZzxo0/dMXw+1xalPcF4MLzj9ulWAS0EQs/mnw0Hh/FNmEZVIaSfkaFLdEwcu4MoWARHwUlhJJGyy1itVnqk9SwcCSLk08eaWMlkbPpGZ+2G9YJhiVkutzChNj39ilAqoQySbv7yQaOEDGqxwbi6g4QPPsjA8CnD/zsvR0fh44OBX4OcZbB0+RZcLfY+bEM2M3OCUGg6L2xU9IIobONk/V9CcH2ob+PIaGEXmEXjRsoo75KZz8r9LAjYalpki+1pDD1jPn5e+fT3oXrhpiDYbizb62n0DOjpUiJECQ5ze+dod0x56CI+b6fas3esFACvURqthFIf5VJVPCrHCm9YH5gsijjsGiwszSLmj0cEdFR33kiqu7IjO08hK5IVAjoSBqXf8YN5xDuVxUdhlBuJERjQwqa6EjC25bSCUmcvfWXpxhwwNBocXjUrTLD1GwrNw6+mLbJheU4hYAxy4ufScxflFlxwCxrGpG97E0suBRr+eAuajxSasLzjGF7sC9s83Ge5atWjRKfHw2zqsyKd0QYI+9LTg/BCfpm+UakC20ShWp1IOn909VLVzVsWKCB0Vn+8n0l+FoXKxYwNmVo8iHn6UZyxW73r1iVj8xJPEUoYTzHammnYyH2YY4t3dbKO9dvGfOKT/ZUUX4dmh9pOkmMkCF4niAP9s/8P1LLTwruqJqclS3JsZl3bFgIk4EnaupqyKT0dCxPc0tAlDTuWfzBJhRq3FaEIFeHYOnxjyZgfGtmtrZ3COImGQWw/+JA3K1nk5f7D2sH2SUzS6Zm/QHr/PlueaIi3X2cdSAIFFF3bIUqyyrr2hXTYERgfwljNhEdviy0Rt4OD9wppT/ZY13gzEc7CV1jD0PPloxiwuLXq2K03I9IqIzECJT
 HyI9lKVr
 omOnVBaS0MiZ0YUimVWTe4aOrEYGaPTx38o/CD00KY21s4YwvT03EwfgxzjzPGVcoS4qGIrX/lFZ3mZT43S4z1vGsIz700YPVgKgAnpZvD43AdriopFJDZvSV4X0V4ot/3F9Gt32eSC4NJzPcWzgowEyPmueWSs8ERcgu/rqytJG1adUL0yJdxw18pLMw5HMbKye6nF5THBdryaXRCK72lPJyy8ItDcHYK65Vy/IJE8esZGW8A2CUv9LRZkmFgyVtlsmd8mf+cydB8plepmSBPHn41jaxNwbtwQ2gZi45M4bVofI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 17:15:10 +0100 Pimyn Girgis <pimyn@google.com> wrote:

> Randomize the KFENCE freelist during pool initialization to make allocation
> patterns less predictable. This is achieved by shuffling the order in which
> metadata objects are added to the freelist using get_random_u32_below().
> 
> Additionally, ensure the error path correctly calculates the address range
> to be reset if initialization fails, as the address increment logic has
> been moved to a separate loop.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")

It isn't clear (to me) what was wrong with 0ce20dd84089, nor why a
-stable backport is proposed.

Can we please have a full description of the current misbehavior?  What
are the worst-case userspace-visible effects of this flaw?

