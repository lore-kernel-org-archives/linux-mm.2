Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBB1D715F6
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 22:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC4F6B0005; Sat, 24 Jan 2026 17:21:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484636B0088; Sat, 24 Jan 2026 17:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAD96B0089; Sat, 24 Jan 2026 17:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6E06B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 17:21:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA161C19F5
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:21:40 +0000 (UTC)
X-FDA: 84368280360.11.D697C3E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf19.hostedemail.com (Postfix) with ESMTP id 760EA1A0008
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 22:21:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=mAgGlR78;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=InJFkMdf;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769293298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEezrfoM7rSLn5baNomU7Sd/yVS1Io7spXJytErID/I=;
	b=HdHzOt5QBFrOZMeczIxqNglj6xGv+aWD+aDOd423qSEC0fCvxIfESGwX+LYWBmMfIc5I2K
	lOpBqROKjLD1UFxMMbUx6LZ+fAmOqrB4zYiTyoFJ3fACOu1Qlawm8HKuiCRormckerfIbV
	aF+yBD0LXGb9/HKTDc3XQjHV7A1W0w8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769293298; a=rsa-sha256;
	cv=none;
	b=Pqcn8ezw8wCcmyzHHkuTpmmJWPE4WTZnxinihGGdM/rw8FCpPaUPaBQ5uzGj9pUs8A3V6q
	G4rozZY4IGHuHoKuJ2sFgY8HdIs50Exh9NbYW2hnLEHbWsoQpRyoZgI13zV6f7wz7NF9s4
	ElEKqb2vWL8E6Zcbq/yJkMArMQKmGGE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=mAgGlR78;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=InJFkMdf;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf19.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Sat, 24 Jan 2026 23:21:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1769293297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dEezrfoM7rSLn5baNomU7Sd/yVS1Io7spXJytErID/I=;
	b=mAgGlR78kES1YUeu+dz6w4M9ahezhqElwq/OUqP2o0M4XzgzeiA508XqwQxS9AOS5KTPg3
	Qo9GeJDWyObS/baflZ6an2GM7pJsQfLgQ4Sxtfd2ocZ0BxlEdyTByhrR2vai7P+NPGSaKA
	FfpUuUzS0F0vgy1oo8SSKOKchnp/9FGpNUaTOyqlBR+duiG71Zg8UmYywv6T1aSN0LUiNx
	/W1MUD2uJn3OqWfFUXf3lS+J7wYXL37s3spJsEDZ2Byji0E9zCEFkIfF0Xyr2c4R8ICtRA
	+k+61NsKTTLDxMfUnKNz8ZHDD7Hza2dz45NKe6Ei2eNx2527ReA+dd+XNo+U3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1769293297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dEezrfoM7rSLn5baNomU7Sd/yVS1Io7spXJytErID/I=;
	b=InJFkMdfzhsss3hyvjifoB4S2ByweMzklSY5uzTtJDUzuBDtjErBi1mG05T774EIv4Hc1X
	F4JZT+KUOdgxQ8Bg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-ID: <20260124222135.XyGv6OqY@linutronix.de>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-4-marco.crivellari@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260113114630.152942-4-marco.crivellari@suse.com>
X-Rspamd-Queue-Id: 760EA1A0008
X-Stat-Signature: nkgawbmjxxhkfxfi8a8ckbdkzteff7r6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769293298-136617
X-HE-Meta: U2FsdGVkX199OULZCjACljlClnbepeDUwBX5zjpkbx8f/NQV28klFwGEB26eCpOyKwd++cxi0ucr7HIOGnVirm3lSo9RDo5gU6FN8ZJNfQhZvwegFX3og7oeQRzgDe9jLGGvI00FK6WYk7fN7w9pJ1y9wzAYy2wsO7wloE7i+wSpPgE0IGAAZ9oFmfjuOHdfFVf8jkPA1qGmnpibun+TdhoCF1fVkQrxzKjwZv3kib8lbkG2qUfn/MDHpp9uZ+OdrOcjGhYwuAhU8GzUP+De47kzpncI6gyThwP3apfjY6h7BbMMgosDY2yJp6gshXoeOwk5mfDfVzrvJ2pgbaatyijAjA6q7tSCLyllirFboxJDXlS2G03Id5taMncHA+bhmWkkOXMRTYAoZi2JACMtrbY4AO0OLXHNpfyL9BdZsIzI2T+i0BzSLpXj1Az9cBEltygHuhr/pvE7yN5AFF7Ypc9cED0AGrNzD5auUUB3Q7oieJAL+Mw3VM1DSuuviEqEsck7aj59/5woBsSz53pcHoph0+VwrOf9Z0KJThUuTe+foX5u0eqJY6DtdUhMwEGb4SwcZTXGiNs5F5v+w2i79743hnBMIQ2+FqJdvfHGH29DuQBPMFHy9CsvMJgzVs7xy+7BqzXPBbip8qK2BEwRXxzbATqTiimKwFNc4F4I69dLduEUEhQYaAXdRTauPxLdAfcExrQ5CaFLjNADlWqHyKjJgZ4C3CO3XTw2kyhU2IuUIjFnGZr0LaaDwMw2hDF2Ux8PZnMSxpMuInouurIQ6FV9JUiVewj0tNczn3rBocXoUFYK6gCpIH9aEkjM529rwECaIiheNanF25/8jAAfXs6/8tryBrj7n2r5rcekmaAWK4s8HAFxZcGscRtNXPI5a70SFT+5x7K4KNHq3F+VjAmYNHLv6itfDH02PyAJKjJh3y81KwQ5Y5OugEDpz84ugiCJbr4RkLig1QKnzDF
 +j1XkAr5
 TPBmU79mYjyO3TH+iX4o++ffBOZk9Gdo/ZIxd8yJ0NwUqu8fivPFQwqwB5+xFARwLDIomIQw/C3oT/g6PtEt+zfh4PG7Tjulox4cCI6d6VfEc/kHzBOvMwU7IQIEWNY0aBcLjPpcmRExj9wCLsKqrxbAYn/0QqhMy8GJW6kVen4yVSu13fgL8ta7B04u79kOtN8saXpgMhhAlHAfv1/xmjE2J3r+sVxLmqj5ONJx7+vkoPHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-13 12:46:30 [+0100], Marco Crivellari wrote:
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
>  
>  void __init kmem_cache_init_late(void)
>  {
> -	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
> +#ifndef CONFIG_SLUB_TINY

This ifndef does not belong here.

> +	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
> +				  0);
>  	WARN_ON(!flushwq);
>  }

Without the ifndef above I am happy with
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian

