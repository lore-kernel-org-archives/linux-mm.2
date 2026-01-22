Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCDF0D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5E66B0313; Thu, 22 Jan 2026 14:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0B36B0314; Thu, 22 Jan 2026 14:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15786B0315; Thu, 22 Jan 2026 14:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0B726B0313
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:09:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 995D31B03DF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:09:31 +0000 (UTC)
X-FDA: 84360538542.03.8E18C4F
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91739C0005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:09:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BNqHnv5S;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769108969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uFuZoZJrwPWm069b7Zxl5WdE9K+cZvS9QdYX8aCTtE=;
	b=WScC9FAdhzKmr8djXoLVvCqT0eUjk/eX3nfCpOipnKGmv/zCkaWBeKvUxr3cCmhtx92ANF
	Lkn6BWoEanaCWKFAk5Ltazn0WiniVXLH324wiWSQ3I4BwoJ/ei2BR6FsXQdmJNzd2mZUq1
	X8SMCjWXkkKTtgQXRwRBy67z2xE9crw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BNqHnv5S;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769108969; a=rsa-sha256;
	cv=pass;
	b=8AGTR0HUCht5w4L9UCF/gtBRA5KqfZYMMo6EV6iWLTwByXvG5sI3kUvfs1whGuBMxcOY9a
	VL7SPzjeI/ZwIU3eFkBUmyNPySso5ZAhLy3SmclHFIsXioZtnoaDbSUnXOt2EGKdrpGAE/
	agfk8dJq04a11aKU0RySTMi1fzWhxpw=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65832eb9723so2574984a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:09:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769108968; cv=none;
        d=google.com; s=arc-20240605;
        b=W9NyOQRCgBfEr+OEX6MQC52frklOflE2ilVp6JEnEqZX/8QA8ovdCY5fY8+7siqqha
         +yb20R848EtfjDmRhhWrLeTK7OzD1YxD/9QKh0G9d+KEHwqxWebyo/UnJfWQTrtureZA
         j8set3VSBLCtBRRiosahUjdt/Vol7KOYLvuPs1Rap2jGi4q0I97ZHbxBDRH9QGWwd1/p
         J2BsaUDg6FWWj3XyOGcO79FzwazZC/0xFP0l2flSeWsyRZfzjzNd3k7bxRSfdk9rXYme
         ArugyJUL/QQ/L147ecBfvIwOUbTX3rBIu+XvyTxrx5cTXih3pXhf4hT0G7rPup6hbxQX
         9Tvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7uFuZoZJrwPWm069b7Zxl5WdE9K+cZvS9QdYX8aCTtE=;
        fh=yXAYsgWWPlTAhkvqngovxH9FtrmnaCavZS3YmXa3W2c=;
        b=JMYoSUejX4AU8wp4G4NOTPuqOq/+ybL/384u7bsnrCuiQ2FaNqVhTz5XUMXFMv/CpK
         EIjgYwIrmCYJVq1H2A2z6cLGZUWymL8kXys72tcVKsRIo0c0P4vZhHC0WXyTCwv0DVVc
         NTmfvKX3Nkn9dhU3EjQ5WSKXTBiIXB92iFFiohOcpHvOhbqi5swFyg1wUEnYMfDi+Ubq
         mVPKDxMfRwkXsCa+4VJ2+I1RLzHLb69iuZF+LgBHpINjpgGf1IgnKrt+yX/x0O2BBLEp
         Ij5hp1b0xqg1ExoTo7o9kI24PwX0kncMGxJ8u1NWTch7euhwgBQsN49y9lLEHcPIAVh5
         V49g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769108968; x=1769713768; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7uFuZoZJrwPWm069b7Zxl5WdE9K+cZvS9QdYX8aCTtE=;
        b=BNqHnv5SyGOXD/TpAJjcJ8iR86ANJ2eh5zW1G7oHhD4JU3/OYw4kgRwRZtR6jv827q
         qEpWRlWuu/U4RelyiwKLwEMjSDTHk7bRAwMc/hjTLJwRtmZohrwDNYLMiM6oR6+HilEb
         vc75M2zQH/LwAioTlCZRuaa77JLGsxW05J27tLwi8S3u7pcD4o2mIT4XOTJVLNgXLpfU
         J/WLG13lIYBI4ZECsBn+DMrLbv5REwmPcVvuTnNfMlmZ0tUuOC8qwa3wlWRKy3D/hMxj
         af0YT694F1+9WdccuiKeCqcdDdMWT8QuEd2xJfeo6LV+6ziCisoLfCxU9+sr03ufhBpJ
         RI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769108968; x=1769713768;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uFuZoZJrwPWm069b7Zxl5WdE9K+cZvS9QdYX8aCTtE=;
        b=xNN0ZDkI+RXW46fQMqOzk0ZWhKI4CONEHjzsq4gj0RANeQlsPaXU+TVCGzhsxkAjHU
         TGjj8ZvstyHjmFpKCLo5cEe9/yEglLbJxBUs7D4X8h+WD7kUR6XK0Ub0KGdDPgFUIlN0
         4sHgbw2tyu7hYc4pqaZbetyCh3T7X0niydI+ottN7vSRj3bDA3uXrW+ll+dLeN+HDX7j
         o6mHO8d9eNI8XfiohCBsEuFel77gVDl9CkipfaMvm/SYbZNuu8f6sWEQMnNzXV1f7s1n
         awAnwRmiqM6xOKyYxcgAFhtFpg8KvegeGJyfoMeoEh9JbuYzS0tjlr8dQQ70jOHhWCS7
         Z/qQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIaetpUBQ7/MGoptdggQygWSIhmkZF7FWga8vOQiVTV8hPpadT0h74gjinEH8nzPTMLJ0yrKkMZQ==@kvack.org
X-Gm-Message-State: AOJu0YwdsPItXaPgZFLKE+R4mKMh+OI5bFVMpv1MzktAS9c7tUb+UaMi
	93ja4hiXMJklEN9ujI7Y9zkb3Bx+UY+eWIfyzwe/wPkQplOuSh2gKzWVOmJqKvsPo0z468SBXEO
	xvsuGddPR084eeHsMveTVPsCdfieSJdpTOsCHEw3KoQ==
X-Gm-Gg: AZuq6aLjMBJdGQuVy4RoT0zXaSDxKzrwp2Vuw1JfwlYGJ42gUJaUWfdhoSM1oO/aEA1
	ILxP9XbIKSk0Thf7I/HZ+raPme2J12cFb6FwHhYXMA/7JrccAkY3xNoNZtphs1sL7Bmh2iQXqJk
	8eNmlpmBarxh38ouzoiT/HhhsCp5PzalRPNdWLMd4FE3qL4FOt+MzLpa1B0crWEYOmHyPReoXtz
	erW9vUy20oBHUIildlfGaVucPmqSsFSYMocwOTA7uT7FXhgDaRaFLIEBBufZeSLIdqmiyl/9JuS
	gBRr96NRsd7Ks6dDo6JZ19gYSw==
X-Received: by 2002:a05:6402:1e91:b0:64b:bb79:96a8 with SMTP id
 4fb4d7f45d1cf-6584874e5cdmr458412a12.3.1769108967947; Thu, 22 Jan 2026
 11:09:27 -0800 (PST)
MIME-Version: 1.0
References: <20260116112217.915803-1-pratyush@kernel.org> <20260116112217.915803-2-pratyush@kernel.org>
In-Reply-To: <20260116112217.915803-2-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 14:08:51 -0500
X-Gm-Features: AZwV_Qh1xgpWqyDuNv5Xd0XNYx9RNx5Okc3zvyw-nwyeS0nxuHtmcgoGkJDkvlo
Message-ID: <CA+CK2bAsGHDQGm7t43MPTS7jCSHVdfvyTZ3Oj2Qnx6G=8N-P-g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] kho: use unsigned long for nr_pages
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, 
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: zk1ujo7rr6zpax53kbyc6a14mkkafcq7
X-Rspam-User: 
X-Rspamd-Queue-Id: 91739C0005
X-HE-Tag: 1769108969-769431
X-HE-Meta: U2FsdGVkX19cUcPrMsfcmmg9HgZ8wWBCNUpOhSEgAO2WSXC9nY1/5JzN8WlGNoX0x3PkLyEdzNi2yvftkgjIqr/Iu4zdUJlTrSyjVZ6PPiXPL7J9Ld1TGeVfXnw+DUmhzsNrrF2q8QhavtJ9PsSrj5eRwIjF4ssyU7de+sibJ4Ex6nLbJ8hiMdTbALhfe+8GQsu7sVY1jnou29ZQ1oOjU+c2MmdUblsC7ca/SVZyhxYoMUFddFyxJZIpIWMw2D4NODvt22pmXvAVFsZdHrVG0BVPYvu4AsLrW89KdSI4LkW27SD9LWT1MYqDOJG21dkXD+aPXGIGVzEH+ZnumVdd6EFasMujbSUh0pDZJpStnAwxmP+mzmH4j7LObHVBT6R709Y6zyDITDYubwB5IxL2o9rWrS6Kva82XEo9NJ3duKDI7zVgkHoX/aOpjSvi7kJcrWWVfUT15yoSGo4YpdfgOzpJhy55iEqC4Db4dvEr+eoCtIgsZOuUgw9rRV9JF8xlVhx/WtWxswDC35YbqEY+Qnj9JNTtbse5eYuVdeWGtZhzrH/UBzw2kqaq9+QT6GEHdAMQ07DZypVtR+eom+opmVho2IQ2murbfbYD9iUPTL4iCpqPs+wRyWm97F3O3vjAM+XnM0C3WXH20UTpD4OipZZ7mGnwa63lVNeXaJu68hUEr/TQjGfPj03Ruu+3/5NFmLbo0a2l+GuVcb77PUvVtzGFcrV9jjQi3pvcD3MBr1oB5WM4rk9xA0CcywsrAl0w/EgIEoEXbwJfmd1f+aW92hVdvI8aP19ugnQJ4S2TWU5H1tU6L3fbrWlDzPommKuaISgj54KG3Lja359tezhtJcpkAA0wx6YqTu5/1wytEpmGrnF3ZJJCyy0Cz026vB3mtQKvRR8mjybCJNKpUp0VLCkB+S6K6s98ettSsBIrnlPreiHCobFyp8BcziD2G1p5WgcdmZSHWvHYHvze11K
 3QGBMzfN
 D/xEdA1Z76V7RWPpso1RKm1iRAlUJj2H8p60wNOWaPyOWvJdvSvcOnNtoXxXMSFgCSZmKGPGx8yn5OJL0Dxz/s4zCmwHR49RWReCTFOBPzwIbT51Mq3r3/aW/RiEWRBowXPu5k7J5WyIJDeB5mW2TaJfRdCQx00oSSUkamTduS08WdkCdym3bfODYbMbfxe1+F9q7dhj3PfguVNXUbHhNTlIHkTUrwwEJkhSSgNpeX0JKU45GuPFL6+Taltzf14fks9lz6Br1qaxPGRF2LItjnGDruAct+BIT+X/h7/4bt2TdceKRGuheKg9o0RLfYMoD8MkwCjk1gsh/s9GvqVi/b3HZCf09ImQoxBrXKsj+J3LZOSgfrV/ulE1sSK6hExgDHN8hRguIhbM2eEOGa1B7qDMBcZ9ppOMrBvGtawNOt47Qo04=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> @@ -222,7 +222,8 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>         struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> -       unsigned int nr_pages, ref_cnt;
> +       unsigned long nr_pages;
> +       unsigned int ref_cnt;
>         union kho_page_info info;
>
>         if (!page)
> @@ -249,7 +250,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>          * count of 1
>          */
>         ref_cnt = is_folio ? 0 : 1;
> -       for (unsigned int i = 1; i < nr_pages; i++)
> +       for (unsigned long i = 1; i < nr_pages; i++)
>                 set_page_count(page + i, ref_cnt);
>
>         if (is_folio && info.order)
> @@ -283,7 +284,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
>   *
>   * Return: 0 on success, error code on failure
>   */
> -struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
> +struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>  {
>         const unsigned long start_pfn = PHYS_PFN(phys);
>         const unsigned long end_pfn = start_pfn + nr_pages;
> @@ -829,7 +830,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_pages(struct page *page, unsigned int nr_pages)
> +int kho_preserve_pages(struct page *page, unsigned long nr_pages)
>  {
>         struct kho_mem_track *track = &kho_out.track;
>         const unsigned long start_pfn = page_to_pfn(page);
> @@ -873,7 +874,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
>   * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
>   * preserved blocks is not supported.
>   */
> -void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
> +void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

