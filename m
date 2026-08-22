Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F301C5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 17:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74686B0095; Sat, 22 Aug 2026 13:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B616B009B; Sat, 22 Aug 2026 13:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61376B009D; Sat, 22 Aug 2026 13:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81F2C6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:30:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECF8B80153
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:30:46 +0000 (UTC)
X-FDA: 85129595292.10.4B263B7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 286E2100002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:30:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GbbejwmR;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787419844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOewuHhYijHg680wHZMfLhmFaLHTLM5/CGaRUwoaHXw=;
	b=o96BcxW/wY1k59htaz9mLKZikySAuNqZx1hGFeu8iXBO+yIOmvfqAlnhcUfdHNCZbGXnDG
	dYGSx7GcjO9McUtRmR66B7dLjm1H4pvQKAQIEB3dn5zftBr9GWwzjAGM5k61fh6/Jpcr/z
	bN7xtUMA9bpGic1kSH31tPYLjPLW1rM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GbbejwmR;
	spf=pass (imf14.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787419844;
	b=Mc/yksIiRCyjG2UDkWmTqKsS4KGJ0pBz8uOTohR5jnIZi5ehZ9RxZjYAT+pjZKQ2n0jssw
	hAKYPGwlkOnoQSigK9OJNX/Ck22aL3cxHyaNvsAILmnXdlejScU1UnkX8HuJq61Zju7gHo
	PBAHmJMYYrGZtavePVA1094iYfwqjwI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=cOewuHhYijHg680wHZMfLhmFaLHTLM5/CGaRUwoaHXw=; b=GbbejwmRT/Y9YCxZ5dFbYZGMG/
	4mhTcJj02Rb+ynspC7Gd7T+p0BhxZWbFBjrdzuzpF5lT7YFlk9ge++4aemWplVqm62iGsrY7IoTxM
	HkpIP6//e8SeHa0L34uU9ZsGlW9lsSFv+mVGE1s94VOfU5PxUKaggXPErWD9Bc8WarRkIEOomPz3W
	nERR2GMVPWhe9CJVVoHnIpHxH2Rxl6tm4RIQy9VN/5Ea1qfR2uqgDV8w68RYjLekK6VlwPYQd0pp+
	s6tGALbp0TjdT8YQOg24Qo4PXeQMnG7cKaX8R7pk/4XEAIImjTSiXmgb3sCzPYnXDyuBrhA8aovnA
	U2H7LffQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxpYG-0000000Egoh-23eY;
	Sat, 22 Aug 2026 17:30:40 +0000
Message-ID: <23c3480c-2779-4618-8f8e-57a60d26cb3b@infradead.org>
Date: Sat, 22 Aug 2026 10:30:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] docs: xarray: Fix xas_try_split() name
To: Karl Mehltretter <kmehltretter@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260822121651.1559-1-kmehltretter@gmail.com>
 <20260822121651.1559-7-kmehltretter@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260822121651.1559-7-kmehltretter@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 286E2100002
X-Stat-Signature: jsfk3u13qorymfykfbrdwh4kzryayy43
X-Rspam-User: 
X-HE-Tag: 1787419844-424793
X-HE-Meta: U2FsdGVkX1/aMtvcGNDklTcrjF8Bj+OzqVkpw9yd/MHdq4PchnRz17ZdD9mMg8Pe3x+1sjjtUD6p0/lpt2fwtw6BVfdHi51GjqNDAdafR4zoYq1VhNY3pGEQOj0wKJEDJMXVJazJ0p9I2AYGvzLqWjPIRzaJt9gTHDX+8qxVzzzTjuIt+1ET7l0xdgv/lVk8Zk66oqjxDr+eUvCaKqlbA8fMpXLe6tc/Tzrtdf6gMEsIHvdguQtqxachuNetdeJ9rj/Ka4A7iAaXtLSJIUQtpxJiVdp5koyueo6CqCQpeLyjD+8f9bKCtEL5ZQWFkdbNOOWhCGlqJgjCqcD073dUKf87CFCUPT9cH6g0qCA2YBKoaXKlX4eBjVOkNMficXw06Ao4Oip7Ok2KxOd4XFoJCtyrnHuRRAbP8Khta+X5bL6T3hRelecar3taOXjrQWMKdM4AnFKrGupQQYhc8PM633twlyugr4o7sUAqTe8IxHOW2fAT0eiD6esTTR2PgUHw4yYsFguJjL1/FXPdzAQbh2bijZdZUifZJgrlferWF/Gcf8VaaZ7xVQj63JQJo7clIxnySpYrjmfHlozSqDUw2gvjwCK4bHKZABl32eroR+Rt4K2qjMaSZF7eoSRu4zIqbUZ9FrpfHUeSpHB7MPsFArPJmmowh60Ad/TAeuplQtiAFckHfIWkz8T1lmR2I6y20tb70vYaN4ufgf6mbFjK7439+7xodeHQ57eBd8GPEQ8Hg3wqK7H+LXx7VCwdSJ6iDifKnA4rx29r3EzuNoTaFxnuXLxf4hxJAOlkw+ow2dAO1OimH9etftp7mIci6FRScEsPNR5T7gvUqVscTK8Aivl033Uyr4oGUThxHmJgYUkB/eK6BA6L+yHwt59Q/BMrSSMJmzORuc8D8nnmnZZ8DwE7nEQdpYAF2ULA8KuCyQ1SoTaudz2dW1RyaFqnJbQSBcFaFhu1Prjr4qXfllu
 hsXXn8aW
 GyduaQ2yZE0qqWenmWsz5tC/3/XbNj64TLuUIVR1YhzmzTPIvUdpMSz1JQH+fWQzfNfVGTo0MPJSA0VItBgDkm1rbfg3DKXKieAhmIhrohS/nwNKSYKKjRvOba0G+Op6qER4sp9f8r4Ek8Ez3bihZqsl9Cmom5UtS+JxjlSouzPNkMO8B1ku/8TQfZoAcau9BrchrFiLBNbV3BvRZqwfBMQYCExQF4wf5CHWNSi1hqIdAMeA9ydj/kix5ybswGRgjND3DiHFE9uXfMgXw1pbYffMFJBsAR7mutTV3juWbgg6P0FnLKAYR9WCMB2ar6KPd3MEwhDtqNTMFaNw1ixt8anvbEjgjDHi/Bq+bZDVJBvew8KoZrZCeTSUD6/Mup9od1VFJh6J5KD98Dfnj+K5p9ZJb1UgISg8iJNwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/22/26 5:16 AM, Karl Mehltretter wrote:
> The iterative split helper is xas_try_split(), not
> xas_try_alloc().
> 
> Fixes: 3fec86f8aa8c ("xarray: add xas_try_split() to split a multi-index entry")
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/core-api/xarray.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
> index c6c91cbd0c3ce..3d2b20c05a937 100644
> --- a/Documentation/core-api/xarray.rst
> +++ b/Documentation/core-api/xarray.rst
> @@ -490,7 +490,7 @@ entry at every index to ``NULL`` and dissolve the tie.  A multi-index
>  entry can be split into entries occupying smaller ranges by calling
>  xas_split_alloc() without the xa_lock held, followed by taking the lock
>  and calling xas_split() or calling xas_try_split() with xa_lock. The
> -difference between xas_split_alloc()+xas_split() and xas_try_alloc() is
> +difference between xas_split_alloc()+xas_split() and xas_try_split() is
>  that xas_split_alloc() + xas_split() split the entry from the original
>  order to the new order in one shot uniformly, whereas xas_try_split()
>  iteratively splits the entry containing the index non-uniformly.

-- 
~Randy

