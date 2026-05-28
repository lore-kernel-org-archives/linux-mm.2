Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790E9CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A3B6B0092; Thu, 28 May 2026 04:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA426B0093; Thu, 28 May 2026 04:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A072E6B0096; Thu, 28 May 2026 04:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9163F6B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:54:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B9A040764
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:54:50 +0000 (UTC)
X-FDA: 84816218340.13.9055457
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id C68FDA0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:54:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GnP0ejJk;
	spf=none (imf25.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/ylTjmkjCxHlPbas61DTDnAsi/DzIoB/quw6eoKXdo=;
	b=NauZktjD0cIQ1JNTwIqgjg5trZLX9MwA5VyUFjVeJmme7Ufmqrv1xgD8lguZGjVNoX902C
	2k9WkTGziyZiWK9OuzEgt4BS/560nGYhQVmD+zOTmEDwsBYI4ZCEaSn7uq8vnHRtgqZ8ua
	chJxHX6Nip0Cpf0v7OT5bU2xhaWkfUg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GnP0ejJk;
	spf=none (imf25.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958488; a=rsa-sha256;
	cv=none;
	b=Pmgttl6eAmaFWn2R32xRlH9mau2pihNl9o6wGalpNTwOqMMe+IzhSp259UfaEAT+rGdj28
	4nTP5Nr7Xg7ut2oT2Zlxjiuo1ZS6Z1/p0Vp83OZZ8lvd5Hc/7tqDqqnIpkxiMOUPQ6h/Pa
	5Ugh/45wikNX+mYRN29pJ6Jcj4zjmCU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v/ylTjmkjCxHlPbas61DTDnAsi/DzIoB/quw6eoKXdo=; b=GnP0ejJkzqi3XLjR28txV1ykHx
	hiTPWnHDJoGIDNzQTwm5HXZQ++6dnaEXuDkUgPm9/aQdUG7rg67a5SIoiu5xj2vStad9ILifqQ8Aj
	+Oayho8mgYUkZLIp8P15Ab2Fz9eayVCJuMb4IhuDefV0ZJwY40BlTpgfT7z8/WkunlIyAp2ptvAmW
	2rykR0UVSBBKJOxqoVb/VUlM6/lnYvnpsrjxWMKHt9xngGDky2ApgtXPRF2IKgabJTMFv1R2fsmnH
	3jknzO0Soy3QHZlsjGv8uszkHChQ4hnwWBiWVkR0gCP3EFM+R8ytKtISNJfgZCbHPDMSK+mg/x1v8
	KwkPuMZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWVo-00000005RTH-3Se8;
	Thu, 28 May 2026 08:54:44 +0000
Date: Thu, 28 May 2026 01:54:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahgC1PDFtFrJrsKC@infradead.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: y9f9typqxezegrzjq6xhr38h1rk81w4f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C68FDA0009
X-HE-Tag: 1779958488-320779
X-HE-Meta: U2FsdGVkX1/JeWjADefOI8jeXFjY8dOF0qkiO8BRPjP+vUYskiN3NORp5UecdHNHjM5BAFbZE75/iIGfowLakj4pOrlD6bd14sb2M1zx5Z3LDY5X65QzIqIJRjvGaUtFFPfVSQXUYBjhVUDp4+TCnmuRBOUfY+uDiD4PgjS4ibpeeuPzXVd/BPPcY0D7RgGN4DYpASVrx6Lmhrq6FaPFpXseUNwgISgBBGAzUNd53MI0LeLdrN/UB/KiBweWnSZ7KU6HvOFCc6WTdKUjeMx9j2ChJCLoxvbKVtk0cRbrFWP3V8mMArGEmkjT8P1IjKSnoNFg/H30rfjoztSnIhFzbhxNN+7qVwlkHEPYAoBXd1k7C8U6fg2Drzvy6uui8BRKejblRmlS0IO2pRcVrw4koyWZIxUgfnozED/rOnFOHB2ASJbTfn4bHVZD5nwlidBUK1tAX569NRKOx4ClMbXlmgtDzNDplNQakVswmYWctsGHUAB6TjXDOpZsLTVlJweb6cuzJVWTmxTazjQjt5R5W1N1ZyBpnXrv7gIoFyc0nNiMuIaU2AQfH1WbCxpT5yiZQv7OYeRrFcWwEn6vtyhmGlYMPrleEUGTZ388f5FcVmAzOVTD4KLjRajv0sy58UHuu4gHc+R0flvmBL7YFGlWe6wHdqxVn0J75CiQY82a8EL/1soW4qz7YbkYG80/+07mvLoVDAqKPQUOM/g7zDL/MfS96/6HXmQkTc/ZThaBnbDE0IgqlNP0O90GPp7Uf3IMyu+Iux/1bjjnDCZ3aOSTNu8iM2dEwnF2REX6j4/SV6IVJdiuoUypIiCVCPQPXoxYU2gBnbRPEBqsjyQDw08vXnSeS0VLUtwKFM1aOmsMj+TWo/PjAMkP1XQiccobTgx0CdNJCNh+n/B0M+fMimujal5Y2se1Rfrc8jAFt4joHBZRlJmEDxs/UoCUf9G/4vM1lT/MWTeiVpqSZtPGJ1e
 30iRW01U
 sJ2xj/A4EExtDtiKipxssQ0rqBOzIhzwI94Ea5cyWq82/lLwJfxKQWS/+F6/V/FRSYJnTGfQJrqzcIRmlYtmo6s9hZoXJm8K15JQRkg1uSPrOuimvyWW4xEgWkAD23rPpmtCJOq6LnMP6XjA41nNZ7/NCs0SY15AVCvOJdh2HnWp3qwvDGIk1AGz8gzvWiepNyFAsCY6qTLiONFaeW4LneTNg6iijOQGZTVSBTmVRQEDJO4J0LMSbe/m7TVh3Epc/tBDABQZejVvEWICP9f5N3NUbUmTithJXNGy9xOCa5zJp8XHcndnaVUdmkAeq/5RULNT/SVV/DTVCjPn3uHqPaFwZvSnSypgw2ds2jBS+Lat6td8NZwYc0HYErrtDxTFDD4EvTDrA3u1+g/yAI20JaeoDEe6RtXs+M0W4nEJHNAekwQuvTB2kw2znbf/Tja6A63JmIQna4GLPGdaOg6ByKutloMqpdp+Q55GyjL08ot+KdjzNHAK2f63IEeM8auDkjAt5We+4cFTAsHmAsXHaDNoRhczHUliV54huLXBpv64saXmbq8e2F24IaKzjJ0zKMqtQfOx5llJuWbtTwxiOF0hhmOpGRf+qgJzy3SahbOWp2NSnDwiJyANQkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 10:27:55AM +0300, Mike Rapoport (Microsoft) wrote:
> -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
>  	if (!b1) {
>  		pr_warn("xor: Yikes!  No memory available.\n");
>  		return -ENOMEM;
> @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
>  	pr_info("xor: using function: %s (%d MB/sec)\n",
>  	       fastest->name, fastest->speed);
>  
> -	free_pages((unsigned long)b1, 2);
> +	kvfree(b1);

This should be kfree now.


