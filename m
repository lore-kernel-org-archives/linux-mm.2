Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45434EA8121
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600606B0005; Tue, 10 Feb 2026 09:29:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ADE16B0088; Tue, 10 Feb 2026 09:29:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0496B0089; Tue, 10 Feb 2026 09:29:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1466B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:29:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC90259498
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:29:42 +0000 (UTC)
X-FDA: 84428780604.14.13912C7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 05CC2140010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:29:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ABQU0gsW;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770733781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yc81MQpBN4LWvgjP4zjKZns2TrXMgn72vRhBrffrRU=;
	b=KtDdjM0ArH92jsizS7GiauU9+73BjjnUprPNUnhXwzzctM/j6pYApzWBF/3s7daZ4KpXdz
	SPOY4A3nQtrdYPJjQiNc0e9Z1d0IRx9dVMdkjSRVJz25hrMcOUHy98uNxh0KPkVQjOoBYc
	C5CGyFDJsBLELsDYnFPU5rfSiFuW0LY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ABQU0gsW;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770733781; a=rsa-sha256;
	cv=none;
	b=eitbojSqsze4Xq7WBrZ6qQjMP3nw2H5gl1km+1cu+I4ErBT4TXb9Lx1EBWvUGADAiV3sJ6
	V7zeUypsyYJprGBHk58yxXhjCg5WfSZRG53wph7w0Jsxih65mBrCVuT0w0gWpNe42QvDHk
	HRBxH5g74sPidfJd7S7v/SiNVCcRr+w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2yc81MQpBN4LWvgjP4zjKZns2TrXMgn72vRhBrffrRU=; b=ABQU0gsWucQOYM1NYmYhrEcOtL
	nYh5o5CJNDQxvU6f3eozUhcyF/Mxpr1e01JCOmARJLxG31rFdEDmC9sM8ore2htijbGla8C1oRkjV
	B4desCpo+oT8SK0sS+wUMNLaE8CGXLuOIkMEN8/hMYdIJWeCUmImZLCjE0KYqKDNS1Gcydx0ZQhdb
	SsoqkOstE3CywIMrkIpWY0xpwkyGgex2sXRf2NvBNGEt3LyVKZQmknM/Im03HK+w0y47uwXV04EXF
	P/+FWDxMyIPHvHU46Ndv+uw8sMcZSyNcXsPqqQ/JUXelywMvV0CsRzk9Ok6nB4uvIyeNQz2iM4xR1
	6HG1NgIw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vpokB-0000000BCcP-3Zsl;
	Tue, 10 Feb 2026 14:29:35 +0000
Date: Tue, 10 Feb 2026 14:29:35 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	Richard Chang <richardycc@google.com>,
	David Stevens <stevensd@google.com>
Subject: Re: [PATCH] zram: drop slot trylock and miss_free
Message-ID: <aYtAz5vQTod7DXqV@casper.infradead.org>
References: <20260210035045.3817297-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210035045.3817297-1-senozhatsky@chromium.org>
X-Stat-Signature: naqe7zuuwsoudkme3ihjteubqci6smwa
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 05CC2140010
X-HE-Tag: 1770733779-993458
X-HE-Meta: U2FsdGVkX19NkjiB+fdBTO3g+Pf3OeD84yzAOM2jJNWHN0CIoUadN2EsPLP9SIkTBqILhtXl7ygt0ZNeyNhLZwkOse56clTpZAAVGyia1DZPDFfbosRlQr200M11sQX/z95K8Lvroy+u+49ZbWs5lgkrP2OlS51v2kYIESToqnseHZF91FZruclmTRzOnZWDPQrzMxNwitSBB6CKTkFpXg2/bTgMX2hzXYCFy7c+KYKd2gCjgptyH77kRfsWhlMOm3NwzsD5VOiBFhmRg0q4G+09oKsWq3R2o9aLDIqP5k8JN4/fewHwNNLqPntm4ouPHAd+xwHPa3DOd07l8KCi3bsLXsHdaw5qhoGxmZGeqN78iSBmtEpCKqyiKYEwtELLjG3txpruaasOlzY/UjT64APmZpkikNqmCPeSTWVdjFmfkXW9LB6aEiJMvN7Cb4zTqWpNkN8/xTwDNXxiPlzpusxaunufOTZXiPaRbVgYG0NYfn05Y1Q7CbnZPx5UJfydw69fU5iaHAXc4DQ293rSk00rEXzeEn8MQ75ikZE9giId5kUcPDINgsPAOtv6ZcV7lJEeZEF9Q8wicCcuTqTYXpFz4ru0ybjdv09I++KUDLEfW3VxLpmAbGoPGGpzjFBXiJgaZJ03CMuhRlmqhN5UccRt7IGzcXb0Jx7/2Azy17jYxd/XZCfbudjYyi4VmN/fKT1axbDE9gLjzJxL589CLc5KH1d1IYvObSMlyXsImyvPbc2oZf5zTA+82Yz6RuWjaU/685bpcohahaSokl5MDpJP5RJJh+/8tH+glPL0LSPUDiOFGzBrxYKxPxXyrSC6abdQHI4C2GXwSxIjWOYgPreoRUHIPcGuK8oBScsquhqPZDDt03e+iXeeXr/5pAod4smYMR3N4kp/LO9WBMllNkzDeVfkrSyCFmA7pQfTjgAthsizK4wtLF/jcSOZ2hULJydDpkF9ixyv+mAErn5
 n0UGaxzu
 AF97DvsMcX6NUkBWdyegXNNCFP4Umu5cMrds9MYcDRC2A3f3D5HaFA0TRTwplk5Nu10md0FpP8CpfM2rFamfZpzOQWfVSAcjbZf3CHzge/w00Kf+6QFAgTyljPlTLsJWUq4dPra+ErBHCaos1IFWPlEmvdN789aL6KCE9vl9bk4qy6s3bsePTjYVAST/4blsuz7CFSwNB9FCSjDzipch44pdQJJENOAlnN5TPsglXbCIr+yef7uxrOMyqoJullnnmNA9wWLV0oJfjYR3KkmZlJH/kQdzR9w1HqiokIiPxckPA1Bo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 12:50:37PM +0900, Sergey Senozhatsky wrote:
> @@ -1943,15 +1927,9 @@ static ssize_t debug_stat_show(struct device *dev,
>  {
>  	int version = 1;
>  	struct zram *zram = dev_to_zram(dev);
> -	ssize_t ret;
>  
>  	guard(rwsem_read)(&zram->dev_lock);
> -	ret = sysfs_emit(buf,
> -			"version: %d\n0 %8llu\n",
> -			version,
> -			(u64)atomic64_read(&zram->stats.miss_free));
> -
> -	return ret;
> +	return sysfs_emit(buf, "version: %d\n0 0\n", version);
>  }

You don't need the dev_lock any more to just report the version.
And should the version be changed now that you've changed the format to
not include miss_free?


