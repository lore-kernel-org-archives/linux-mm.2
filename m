Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE78FD8FF4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418FD6B0111; Thu, 26 Feb 2026 13:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0CC6B0121; Thu, 26 Feb 2026 13:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FCBD6B0126; Thu, 26 Feb 2026 13:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2146B0111
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:49:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4090513A9BF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:49:57 +0000 (UTC)
X-FDA: 84487497234.01.A4B0054
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31791C0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:49:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=svDRnWdE;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772131795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNGl2PacRgY/7eEMD7XjUPhLqO/KH21uY3Hc8HdE6Yw=;
	b=zshF4oPaSPwLUOELCXGVTDo7gtkQ0lOvJrp6H4lk3kMNRxhQW9lgk9K2kwH1laF89q6sD6
	smnzh2sp1iEo5aMk4wGTCnaWDiEYD+KF2u7HQ3sovpvsXxzhgc9h1zd9+4BW9quGsJN8TD
	rCyhIlz/L/TYFDqQcDGEFeow/2H3aPw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=svDRnWdE;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772131795; a=rsa-sha256;
	cv=none;
	b=T0v+4itvkl5IxikXszG1/0RkBcJKhxJrT467LQl5ZTkvr+Jhq8Nwa+Vvdy7mmKvz7QpHab
	GrLwuy0ktMoyBxOWt6G9kmVr2zU33UQiAlvCjsTMpvo2j77qyJ+b6waDmqRU1Vt1oQR0pd
	V8tiiaYBSkcd0kd/SiFljsQ5nki4QFY=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cb39f64348so110703885a.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772131794; x=1772736594; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNGl2PacRgY/7eEMD7XjUPhLqO/KH21uY3Hc8HdE6Yw=;
        b=svDRnWdEn/6RlzB7XKabxf8xNGu5xPqw9cQSXQIhaT/CvQgLZFSNUFbUMm+AFWDwew
         myDgtOzW+YTqMLJAaf/QlVoIeS1k+ct64/7AuME6yI3xmlubIFtALCl7WwXdQifBEImk
         o1NVBWJ6wWIJcF5r8yLd+3NxS90iHhuML/8josvvd9a7ksYopjVL0nwFWUAIQHA96uvq
         X3Vw8ttf1CDfYFZf9OjHGUPINjqTpEjE/KHVXTC4WBkon8NE/aF5PI/nsDx9j6ASiDCf
         evEmG+bcb4XfEOvAzPWVX8yl/Mf3s1eLhGi3z2F5UxdFkThEFQ/MZ8QPpm1JaM1mVdX7
         gavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772131794; x=1772736594;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNGl2PacRgY/7eEMD7XjUPhLqO/KH21uY3Hc8HdE6Yw=;
        b=AS2DAMhde5I4PliBTjYcO4Qox3iRcSelfSavRlvDxwv8M3RqEU2eBkZ2ty6SVuLdVe
         HwNukumlTOuYjicnYIH3lxSRZhM/Db4lm4S7v659NuE7RJWtcwtaXxRp5dp5fWd4n62Z
         cvqFB5iELQklqnW4R+d5N5c6LKYEc2OTYFsWc+x3am1L64kaI5ncXlS5BVdaJ8dim5VO
         spCvkLkczizPm5sq0/NmOn4P5OyosAj2cBjkV2zFivoecyty5lB09Mf4Kp+2DORoAwaU
         vSqTUp/SbSMFb1H1W0Id+z5bIjHSf/R4nhhHsxMYBZHTxMB9Qy+Zs7C3LvcVJoLILKag
         3wyg==
X-Gm-Message-State: AOJu0Yx44MNFOIJkE8ak51vzGLoPXbyijOKbBI4odGv7gorThWWuAJL4
	F5eDWik/1OBpzdQ/XLMRmZ5xplsZ5z5J0RNS8ixN62BkGc/nBi1AO4MjOGE1hAHSLIY=
X-Gm-Gg: ATEYQzyc55PMA+WmUrTHSsWF+43PwP7M9A8fBP8oy1uOMvLymI275B6ZEs4jwoDK6jH
	GKPeh6m8h7z906XCj3XbbaOkYrIkaN0SWoxvINX9jP5X1K1TE1WA8ILd1TLe08igG64njXwEHMe
	SGSUUcUOFPHneKX3gHMr76hD0ruS2ufK1oQJEHXw7oN8Coz08GrNbDQE2GZXEH6txFpxSAI/2ag
	dH4W5tZy3MdFkT9uUvkpM7gfdy3+I2X7purzH8dRIRCOrys0prR3m9lQUe8Q0MliRJ2OTZDRK4j
	HssdI0MeXAYoQbXRsTMYWrk5m61JHRUKVZ56HMZkhuLhAA8vYixiRa8j9O0XbphrQxKc+HuvwVe
	8O6ntmFzyrjvKDh5pWt3omP5oQee2jKf/0H3j/rWmgOxXLDFimwFvvoTX3Xfg8ETbHSlMacx+CV
	o7fV2CJMdORB4UErypYfO+FC4E+IOGfKpT
X-Received: by 2002:a05:620a:25cb:b0:8cb:4f63:dac9 with SMTP id af79cd13be357-8cbc8d70e6dmr1400785a.17.1772131793718;
        Thu, 26 Feb 2026 10:49:53 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf746fc5sm268217885a.51.2026.02.26.10.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 10:49:53 -0800 (PST)
Date: Thu, 26 Feb 2026 13:49:49 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Byungchul Park <byungchul@sk.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, ziy@nvidia.com, ilias.apalodimas@linaro.org,
	willy@infradead.org, brauner@kernel.org, kas@kernel.org,
	yuzhao@google.com, usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com, almasrymina@google.com,
	toke@redhat.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v4] mm: introduce a new page type for page pool in page
 type
Message-ID: <aaCVzc2lexW0TiPf@cmpxchg.org>
References: <20260224051347.19621-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224051347.19621-1-byungchul@sk.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31791C0008
X-Stat-Signature: n6qu35ry3pz9cd7jibx4uqbuxuip47ef
X-HE-Tag: 1772131794-799252
X-HE-Meta: U2FsdGVkX1+XMjf9wu2RUiESzaL42lMxdzZM43uvWE40vixtRKCMyviu7138bO6zUyn+f70AMCN3ltRMJ/RM35fWZTqDJx7FY9lkvE9Uvr4KcCdolNfmH90a4eGB5lsjMSUPZRYlzCXoWsEhR2O4flvu9Ho6W4Wn+2VDqFvIPUQawIZQx2koa0wFVQ464FgODrygz7Dx02qeCPqJNIL4Ds5LfKSujNORs/aVTQX/WWXZDs+F9ywy8+lHNfW23cAdCcqESRba1U4GPllmDYAKRdbhQaj8v/LZFuusZC1rz2lQFKyHddgBRj7OtaOIV7IouuXjIn5WFhfZ8TYxGFC2PyMu+YIX1hHRs8TX01f/Yyk8FKjT6fsOAlXJrumToyWzA9Ht4rDEAQ9ZyBOHBgdl8ceNE99hnw2Yt8L3QgH4XLZF5y5+asiR3mFQMRnszWGbz0HjfnGY8KA70aaHIsIJVq8/4taeCoQpGAtGLLvdWh0kVZmF4Xl8G9x5tKDrcYlFHUEABMlOxM5Il1m9OIrPGOAORR3hud+oraNE3XE95KG56kZGcwB0lVtkYbH2K4JBdhU/yuNyIYaCF+Q61EdP28yj2tfY0C6HWQYtuomCIglL2PULkahFsNAY+PhaMgOrrPBNdv7pX2z+7DUBqjXo3P0/M/om1lTEwhbaWgpgp4HVV+BprXdvA1Udp46lY0tPhPeCqiOcCFWsk9mC14kh7Dd9DcTzntbvIvu5Ujh1FMniUsOt8u6n58DJ1jzO70Wq03Cu8fue/z1YMIDAS75B65d1RGTHMnoFDvrM2yKGZGaYlxS5S6JgZSuAbG/eDnePZgnBlZjB+eVfJOouIzwh/EBgb+8esb2sx7mBO/364d0/r87jzWsa69nOqJ+vI391sabRtkU4kroE2J1e9qs6oitebXuc/577CCAXxLaCOhiDz9H+xSBdPADEKUHUTh60EdECdGsygyodpWCnahn
 L/Ndo95W
 +HBEaF/yQ+EWgGALuEx6qS8B2Z+0AxT7XGai3JR9K8tA/1ePEgi7aMT5SGQBJSdbAZIB9+QG3SAwrjhg5n/gaZ4W4MEzyRYwmkgcLuMJi+DtimqBTMkxtkhBOGILVsXsxbNU7UI8FlySyo0BvglwdM52anGv23yIL585BdRDQTKivqTKD6TK8bAFh6LCeVThLA4t9ZXjWhMzTRuZPeus5R2d82+O4yCjGlhGkt9fPydou07SjxkPa9s2GMINAtxNHiB4gOrBNu0T8Rcyw9DQ4dP2kUNvYLP930HGmd1K58VILalhOPWveu4Ub1evoy0uRVz1YeTfh6c9UsStHqd+RWvCBUWqZZkOV0/IwXo9Xz9b5Yi0LmwSJYAUcaWIW9ZiBJlYk1NeU+eps3Xs1DziFTnvCJUo4ChR9NavE/mcN8k62v8OJFCAcSmC9ZeMfajveT1cVIDU5GIwXnQbZO+axML+bOWlo4G2HgYf+/n1nGA4Tf5LKKLzIE1lnjYr+qOUVJ1t1yfqD4kQ6au3kJAaIG6Rs8e9DY9mEPROnppm6XIzstmCkxx/S5wdWiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 02:13:47PM +0900, Byungchul Park wrote:
> @@ -1416,9 +1413,15 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>  		folio->mapping = NULL;
>  	}
> -	if (unlikely(page_has_type(page)))
> +	if (unlikely(page_has_type(page))) {
> +		/* networking expects to clear its page type before releasing */
> +		if (unlikely(PageNetpp(page))) {

You can gate that on is_check_pages_enabled(), to avoid a new branch
in the !debug case.

Otherwise, the MM bits look good to me!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

