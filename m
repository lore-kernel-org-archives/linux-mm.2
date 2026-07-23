Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A70C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD446B014F; Thu, 23 Jul 2026 04:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94A46B0151; Thu, 23 Jul 2026 04:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADAD6B0152; Thu, 23 Jul 2026 04:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0E66B014F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:45:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2874CA0428
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:28 +0000 (UTC)
X-FDA: 85019407536.12.109B3E6
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E64EC0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iKduSdmP;
	spf=pass (imf22.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNSCWeKhrxGWAlQghBfhaL555IVsMmUGtowa8Jgc3Rs=;
	b=ld/XmrFSdFTPD4pL6z5kv0Ti2fn65sJLL9eG4XAeyuCid/Nlm78UaPF/9P0rbjwZHHC1F7
	8v/ejNSeM9qAfFF1wxvR/Sg9iAQNXVsaJ1nuFFl/JHjX1kfRu3zLsZgAdf52tnGjx0/vtQ
	lfKn1x0s8iSWF6QLKQyMIkd2OlUcw4Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iKduSdmP;
	spf=pass (imf22.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796326;
	b=k/78uWw+l3i+4lHZARJxODQa2zPgTZ1VDUmHx+QDGneg7C6HDQoBvbztJEdaffa50+ikQc
	z7UEOrs7mZUZDpP+vb8/mR7e3WAExBwuu5FWxrvi2ZLx39qWI1pVuHfp7sncCH5ySod/eb
	GxZ3vZXjYklG9CccSSoAx9xcregD5ng=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495590dde14so4092915e9.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784796325; x=1785401125; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QNSCWeKhrxGWAlQghBfhaL555IVsMmUGtowa8Jgc3Rs=;
        b=iKduSdmPi5BRQQGfU351DJe4Ey/m40S4imVibCOPVf5l1kyP6TYrwKSWdJCmIw7uLv
         jw2FCO5HYxbWbY0D5dFxP0YNIX+boPKHcwx6BVxmvSpUdOq0k1qOVaE9KryxnubaLxmr
         HaCc64isml/tYJfdcPGsxXUWFckp/R8CJdEDynNYenvTP+W2gbuhWMkP5Q6KEIix/fJR
         rD+mj56OeQPKVpaXyQNRF3ccSS3l2Wunweogg/G0hLAJG38YruJxeatdjRbg8wpWxMN8
         /1B5DkSw+Z38mVoykKv6OiEnQFXXT6lZ0rVKVMzImCXww0U4I/VTWs2Tf+ojuUPwahdd
         Zw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784796325; x=1785401125;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QNSCWeKhrxGWAlQghBfhaL555IVsMmUGtowa8Jgc3Rs=;
        b=JLJqjzvaDC0dMb2WUPOg34bukczU6zh/nCmqK7gH0IAUAOdg2XDmpACHwbUON8v3mO
         uoZcVCLdBVCu6DCYs14/AEsl77OResoDkW30i4GDBshbgoJMAzVCIHmLqX6HEsMbpx8P
         EfInCdKx2EWNjYtdNyyPArzlwjucfMWcULdodlwG4dhgxU3GRZoVSEgSZkHYqOxpqZWP
         lO6k4QE7AwiYdh5ebHVT9dNb0uxD3Te8+aPiSrTIZbsOE0Io9U4DykjrSlTLzKvm6FLl
         WpnAV8EUB69r3FipFlqab/OQU6XgMbisLZV+Wb59kptfs/tcVUO9rBxmIAuA4ji3xvWR
         EuZg==
X-Forwarded-Encrypted: i=1; AHgh+Rocu+VaglCD/xRXPhd1cG/V28p33lpvlGj1yzBsIGDg/LhVCAd/3qB+iWrH77E1dvX/J8jZKitJjQ==@kvack.org
X-Gm-Message-State: AOJu0YynGUtn4raQAzzSEtB8M6sDXDUfgUhTHqeKvu1k7r6FHchO81TU
	AJwhvy7PRu5zstQ4RhDlhN+mczqUOXJ2ZF9xia+WGQqJiH0AB69jwwwL
X-Gm-Gg: AR+sD13cJ8eP2I1cj4ZEExeqm3alrROFHMM2QlIQK/+QQYpCXok/2Hua+rszH3Lnrf3
	STYQPRkQ2IpVfj/7SaRuwChZMadO8SfXY21spnujDbMNrLRRHhw6fZCU0WjoYodFaWaQwX94uqu
	ALSBaVOtB/0dCXe/HD0ynsQpK/hz/4PImM1edPzBUT/U/buXelHyzsm9v/xeILlnY4ORgn1SloP
	ESmdzndbKbnyDswsOR4TPA0YYvjeAS+XbX6JFipD0iksn2mKViHSZ/f9wJk3Gnw37pxGGgA+Cfq
	dHv2aFnZnUAf2DE+2eoA03o+mhXblfuvzUjM+mUj4f1GxSJ0+XKHWhmkrtEldoIYwecVTSIq8W+
	M/6fCRoqq0tr/1MuAfqQ7B59jQbVtsBnN5rILAVrR69BRk/vPxAJ91N8efOp0CRo2QxlYo7y8aj
	SvGtpbPDPP3MwAWSBAL5GAFyTTytXmFDLe1ZdfkmU=
X-Received: by 2002:a05:600c:1914:b0:495:5e86:4e59 with SMTP id 5b1f17b1804b1-49573cf6226mr22983005e9.22.1784796324550;
        Thu, 23 Jul 2026 01:45:24 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653bfabesm234783595e9.10.2026.07.23.01.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 01:45:24 -0700 (PDT)
Date: Thu, 23 Jul 2026 09:45:22 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
Cc: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Rapoport
 <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Message-ID: <20260723094522.535b284c@pumpkin>
In-Reply-To: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4E64EC0003
X-Stat-Signature: 8mgoiujeigngyjx7f1fznzxphck7ybqk
X-HE-Tag: 1784796326-460207
X-HE-Meta: U2FsdGVkX1+LT2W4+PUb9WLJQsnlM58jczGHldEbIKgnsRrJyVR+EY0ixVlJoJVETlPUdDFzPXI96taVcBoZ3UMk1LUpnV/SRKIYvrt1TgwwgWsf5UyzW8hlYbIFHnaiZXiUJG6++nSWyAFxavUS1Laty+kNMEe7R38Y6qGKsM3yQcqSPYdJyj6IVv8QWb6gyWv1KhTm3HkPSM7uMjmrwqHk+pEeHKYLAt3v9ITEP81FQnD6Ai2JnuUYxJWd/eGsdhjaZciKU3/Fl3oIMXO/MU5WoyRFYBH0PZuHDyQodscYnDl/jVvg27y8BLskSKdxFNyKh+yxulG0UUqO6zKxDpmgmhpzPVTGQqy53pXUMNWeVwISZaYw7YB5bxRDx5oZLd0RGawPNrDwAiWwSgZD74BKlKQDtKRM0GqSGCcu8B4pZAHKRtBilnhKEVvW9seCZUizjHyrdNeMOe0lt9B+FKOdXg83XBgMmr+7+F0xNWhXZvPH00V4UI3BsbOYMYSvdT+uGMHaCpQYCY8d16uLOizDuKwAvFgpqwN26PEvgvQsfVmpY6l36G1C+P3+RvjKnxaAKy1LgCz9slGFssLfFO14tNFNybZUuazVXkJkAXFY/EDfWM8oG604ilwP0lUdeppfXPQlAvtOPnyMLNJB+N5TEP9Djti6uUpWiIwUQDwCJPE4xCISunPzpnuOFbCi9EjWHtEe7Q0DlhHrS7atRFyMYudFQ5Danth2CXEQIw4Tez34R6FQjrVwrC28mdut1l2/sBSrBLYZWp1eoDJrpmevGAurv9zCR99dDbKxJhiEY038Hgzn8FuvfHylTgB2Il+Jjbx6GW2/1weQzgyKQtEv08AepeChWoXYQdd1f3+K+5t0/ap1QAtpzssUybuS7efEtaW5o5XNhqqexHu4f10lTF7j9G7x4CaRIHzAqIqPnoSoCmmEV0ucUCgYYQ7ZLHQSu//M36bJBIu8WG8
 /ijEIpdb
 C3B6wTI8v3PL+T3j4A63GujkZaLJfE7rHd8GYtJ1/MkElojI2Q20feQPMh674JhiMm+jk5uL5IZH3tcmfA3xDFknOKEGluIy69LE576ImHSBnArewggraYsqn4TN1TiuIHX4GrF1op3KtMwGaUlOkGyG8Hyg3xM523dRaBhTPBKlx4rWgpL9czKmH2T5c2EDT8lt9MmhthXXpYv6zX4oG41Xp19eVZFxePvhudhrk+syrMssgV0CjKd/RmHWX8kcCyiKVLvMMKR+dE6h+Mm9nzvQ9vzW+cRIXecEIxHRVFWKp/Me8rYlKgDoZemkR79bZAONcJh6WcSHitwbQZ3xbEGkz1zGF9MjrWsxf8RcgtblinfbBKH1QoHfcfEndzVRZnne2+d8+ACZ7IJ30rcYeoIk4SsX6/TNNd7mdtjq025ymcFl5xJE4Y6O5UnyqwbunjypAgX98LS4Im1clkXs95uzLIy0hndzNky34h57NgbK9Wx6EkBEyit3d6HbAK8AWw86qOp7msqEb8/r0LYx5UndAdTuRSnYw4W3z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 23:02:46 +0000
Mahad Ibrahim <mahad.ibrahim.dev@gmail.com> wrote:

> lkdtm_debugfs_entry and direct_entry use __get_free_page to allocate a
> temporary buffer, perform copy_from_user to get the crashtype name,
> strim() to strip whitespace and find_crashtype to find the corresponding
> crashtype that is being requested.
> 
> The lkdtm_debugfs_read uses __get_free_page to allocate a temporary
> buffer to store all the available crashtypes, and then copy it to
> userspace.
> 
> The buffers that are allocated can be allocated with kmalloc as there is
> nothing special that requires a struct page, or the page allocator.
> 
> kmalloc() additionally provides a better API that doesn't require ugly
> casts which obfuscate the code and kfree does not need to know the size
> of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().

None of those buffers need to be PAGE_SIZE.
Even the sanity limit for overlong requests could be 4k.
The longest 'crashtype->name' is probably about 32 characters, so could
probably go on stack.

And can't this code use the sysfs/kernfs wrappers?

	David

> 
> Signed-off-by: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>
> ---
>  drivers/misc/lkdtm/core.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index ededa32d6744..01bebcb33bd4 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -236,11 +236,11 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
>  	if (count >= PAGE_SIZE)
>  		return -EINVAL;
>  
> -	buf = (char *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  	if (copy_from_user(buf, user_buf, count)) {
> -		free_page((unsigned long) buf);
> +		kfree(buf);
>  		return -EFAULT;
>  	}
>  	/* NULL-terminate and remove enter */
> @@ -248,7 +248,7 @@ static ssize_t lkdtm_debugfs_entry(struct file *f,
>  	strim(buf);
>  
>  	crashtype = find_crashtype(buf);
> -	free_page((unsigned long)buf);
> +	kfree(buf);
>  
>  	if (!crashtype)
>  		return -EINVAL;
> @@ -271,7 +271,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
>  	ssize_t out;
>  	char *buf;
>  
> -	buf = (char *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (buf == NULL)
>  		return -ENOMEM;
>  
> @@ -290,7 +290,7 @@ static ssize_t lkdtm_debugfs_read(struct file *f, char __user *user_buf,
>  
>  	out = simple_read_from_buffer(user_buf, count, off,
>  				      buf, n);
> -	free_page((unsigned long) buf);
> +	kfree(buf);
>  
>  	return out;
>  }
> @@ -313,11 +313,11 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
>  	if (count < 1)
>  		return -EINVAL;
>  
> -	buf = (char *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  	if (copy_from_user(buf, user_buf, count)) {
> -		free_page((unsigned long) buf);
> +		kfree(buf);
>  		return -EFAULT;
>  	}
>  	/* NULL-terminate and remove enter */
> @@ -325,7 +325,7 @@ static ssize_t direct_entry(struct file *f, const char __user *user_buf,
>  	strim(buf);
>  
>  	crashtype = find_crashtype(buf);
> -	free_page((unsigned long) buf);
> +	kfree(buf);
>  	if (!crashtype)
>  		return -EINVAL;
>  


