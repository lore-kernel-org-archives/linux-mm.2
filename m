Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC38FCDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86896B00AE; Thu, 25 Jun 2026 16:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CCA6B00AF; Thu, 25 Jun 2026 16:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975216B00B0; Thu, 25 Jun 2026 16:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 704706B00AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:17:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA46CA02AD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:41 +0000 (UTC)
X-FDA: 84919545522.01.6E8BBA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 36FE620004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B8tC+7/Y";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418660;
	b=VA4FoGqayiJrvFGpgkPTSxmq6EBIuzzI8jWb6ZKtpgFnLyxn3kAvmcXaPuYQrbX5qlOrP6
	QkEs5CB0MUyEBDM6unu+srEqd5Mi5FpskAfD/t6fonmMWZTu6hwwxwC1Jhx1C0wzoCtCCo
	wztm44fYEJGOateAS8e9OAKwhogU2jA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3fZrNlOuQ3bmippvymiqUka8ZXELB1zwP/Z4jmtZxQ=;
	b=QiNwa9aoMhQ9N8gsktjpJFrVgRSqUlRBpY2uKnKd6DtrF1QsoUG0+Wp9INIwKPlaIriG+Y
	vI2bjoBW3hsiIZl8ipzGuJhEtCjV9roAhLgEZApoWmZSd7X57ca3lt2vuZ5YZIv3ze0PLr
	jQCP4CC8cXvMVQhjF2ThGfRojQ1ko5w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="B8tC+7/Y";
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAB5A60098;
	Thu, 25 Jun 2026 20:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C6D1F000E9;
	Thu, 25 Jun 2026 20:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782418659;
	bh=f3fZrNlOuQ3bmippvymiqUka8ZXELB1zwP/Z4jmtZxQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=B8tC+7/YZb8RcTEoQ/5cWlPL9lj5H6f2CzNa02Mv0pY93VfgylwXhnsWBfbEJdZqP
	 u5Wlo1R4fT7HuUxAQVjQGf3NptkLZ0KOA8+dRa+wrLuF/0CkWtj86OTo4Twipu/6+L
	 NWCkxmdJHc/dRXsQKJXwz8vKsnVSjfjFP83NmX7A=
Date: Thu, 25 Jun 2026 13:17:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, Keith
 Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
 <sagi@grimberg.me>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo
 <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-mm@kvack.org, Vitaly Vul
 <vitaly.vul@partner.samsung.com>
Subject: Re: [PATCH] mempool: optimize mempool resizing
Message-Id: <20260625131738.b7c10540e5c598cc9b60e19d@linux-foundation.org>
In-Reply-To: <20260625194915.387663-1-vitaly.wool@konsulko.se>
References: <20260625194915.387663-1-vitaly.wool@konsulko.se>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1ty7df5w18y3yrcg199uf5dff4gwg7oy
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 36FE620004
X-HE-Tag: 1782418660-597506
X-HE-Meta: U2FsdGVkX18qdw1V7sgbUT27SZVwylqoLtlyQIXvNms+vNoiWW+kO5EftJTm48hGeucj9SSvuHZkl7SVZU42IwB5RsLYuYwOFstNltbGTFX6JuYuX7fdkd6cvZzghDfdbSB7iEcwSIIpgJEhafvWmDRXIc+d7fKsmJqrjiF3sgNyPPICNpYD4xiyI6zzcalNfvhtNKZ8jf4Vf8t3sGWEr65fffRUdaTri87Ft0IZk/T8rUX045FvNIEaR6oIMSPNBA+gUO85BkBgBx//FHcYP0Zx3R5nf3nAZoNMYKuW8kpdA6/NqL7bCdTq+lMmnO8D0JwFyiB0ckLFKCV877HbE4Je1xIqFklYU2W/4lJ7MSQVgxp2XhFaEIB7uBYD8hdIAqw6MLJBjO+CqizUrx/MNzSwN7hIH+iJfMOp8NXAuDX9DJxeAzOqRraxL5ug8ft9rVZqdnG/Ztd/jtx9ozPjU6rvQk/yJBdVZESXVB47fRN4Rp63vKjcmp/WHtv6pn/HeNz0HqQNTUAP8NZrN9junwY7+CMPVtxYmo3Z7HOBSacoQNm4meGM86Rh3B5IVSRTBnX+wTIPvFRykSFu5EXb/8ODVtuLBqQkMJxoVhkGOG0zw7IBNzlcDXCMCW7YGlji92dFWH+1DSG8WQQGVEI0iE3glmxjF3l+x772vAxCKBz3JXauNZMgEmw0ab4V2LpqE1GrQv/I43AgqMvR2GMn818h4GymotmH3dVJh1aRfitunrCCbkbgIbzBesAmhO10h03M4wK8nG6gVAylc9u9VYkxBDFT5jk6aME3ZgmcOBsK3GOpG48E647OX/eKZBxVyJ6bN1Uo3iYJqjWlp5/hsgd5JRkiaKrBoaImoDbNFQI0PBH0N5zRGwRDX/JiltOhVeKQG8YP8MbZNMnXCmXZW3C8U+URC7G7n+o2RPpQaEkEuv32sbwVsqOd5ZNoHrAjUoT0bQNSbC5/OFxJK/3
 BPLJQhsL
 n+2oeaervqjYAetjpB4n4k3UBdmS4DcviETgYEKbn1Hp8WhyDSIq3QGqRjY0+tBljdaa+ZFx2SVY2C0mc/VfSlLdWL3VSkq3F0V1urgUhTWBWAzyzB6zK8HWsVTGbE+cVNlpXjJZaq9wCRnJar1b3aSFsxezGsC3M3FZyHgmjZHX6lJjcNoLxCWQ7c1ZBIsLF04+YJwq5qr5HkTBLBhNn+nBUE4L2Qowo7fzOvrmtM4fkpfE1gstLMeXZF/5mMLkWuE2Ntxd+R/0oSEn4aJtUDHvNYdLJPkzfidf0eO0LN99Ik8JDi0j9rDzT4H2IvxqmoPnNwmttLBu3pI0sQIzCmDcTeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 21:49:15 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> From: Vitaly Vul <vitaly.vul@partner.samsung.com>
> 
> Resizing mempool to a bigger size currently requires a new allocation and a
> data copy to a new larger elements array which doesn't go well with the
> idea of having a fast and deadlock free memory allocations during exreme VM
> load.
> 
> This patch introduces a new parameter max_nr for a part of the mempool API,
> which denotes the maximum size of the pool. With it in place we can avoid
> any allocations in mempool_resize() since we can either grant the resizing
> request or reject it basing on thr maximum allowed size of the elements
> array. For those few users of the mempool API that actually use
> mempool_resize() it is a clear upgrade because the maximum number of
> elements is known upfront.
> 
> Derivative APIs (like mempool_init_kmalloc_pool()) are mostly left intact,
> substituted by the new mempool_init_kmalloc_resizable_pool() API where the
> pool is actually meant to be resizable.

Thanks.

It would be helpful to have a description of what inspired this work. 
Presumably there is some observed problem in nvme or in zone-blockdev
use?  Can you please describe the problems and also describe what
effect the patch had upon them?

>
> ...
>
>  int mempool_resize(struct mempool *pool, int new_min_nr)
>  {
>  	void *element;
> -	void **new_elements;
>  	unsigned long flags;
>  
> -	BUG_ON(new_min_nr <= 0);
> -	might_sleep();
> +	if (WARN_ON(new_min_nr < 0))
> +		return -EINVAL;
> +
> +	if (new_min_nr > pool->max_nr)
> +		return -ENOSPC;

Seems strange to return -EINVAL if new_min_nr is too low, but -ENOSPC
if it is too large.

Also, (pet peeve), ENOSPC means "No space left on device".  If this
errno ever makes it back to userspace, the operator will be running
`df' and wondering what the heck happened.

Also, AI review had things to say:
	https://sashiko.dev/#/patchset/20260625194915.387663-1-vitaly.wool@konsulko.se


