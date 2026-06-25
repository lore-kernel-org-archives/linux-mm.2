Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CBECDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2545C6B009E; Thu, 25 Jun 2026 05:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 204A76B009F; Thu, 25 Jun 2026 05:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC676B00A0; Thu, 25 Jun 2026 05:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4BA96B009E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:04:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59AD71675AD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:04:21 +0000 (UTC)
X-FDA: 84917848722.06.0B41C33
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 748FB18000F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:04:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BCGcMdzc;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782378259;
	b=Yi7aozz8uTU0S2QPc1lp2xbJg6N9Uwhu7pozZcZcbInVqE8v6iF2E/KCf/jmsI1UJtNTaf
	2YamUG1gEt2D6VWBfCG9tmMvPV/9hoMOgrtBPWQllpO7dIDtLJyN8UhI6QSdBoyTjWWAAW
	2wQCafU7aix5G/Oq9txnBBIkMngUjuc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782378259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qu0jrj9G0JVc5Jq1V99cgOHIlKcLZfL164YXQsqb4tM=;
	b=bfJ6VDfeDjfn6SbwKOST0zIzEEh/0+4er1NDv8N0qWQIwZ6eKE0XYog4ArHdOsgGd1lwec
	5iqeu9kKUBmL/zisbs4EnY9FzgsM9nngRyh5lImopAs1lTk0JpFKav57scezZo6pl29xtA
	/Yyjzone7JGLy2o9rTpgCtYin+e1bZk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BCGcMdzc;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mkoutny@suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4633193af19so1533974f8f.2
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782378258; x=1782983058; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qu0jrj9G0JVc5Jq1V99cgOHIlKcLZfL164YXQsqb4tM=;
        b=BCGcMdzcnl3ntqPIjcd8kBQGo4TRGM6pff63c0nWt1W8VPH+QpZr9UibnKQaF3Po2h
         OLtsePURkfbkgL8NmhSfC6IH1cdHYP9F4wncrQgdbSPrpis4ZrMQ48nsBCi4vQTCM4Ne
         BpOUS+wcgj4oed/hQhZF5ammCHWig9VnwP4l7xoYpXVzsWQcc8kfSmczW4zly7AHvA0U
         37EN2xyWQ2X3jEjqpo+OnrZPKclqr2YFSDUiMcOEjhUHfoRdtvu8CTHsy5TVE4/NPePp
         EXW3p11Dxm2QwptHmRp101N2moLybNdd3Rv3iw87YfY9Dpxznwtfm/qkjIApoo4mmx1L
         UBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378258; x=1782983058;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qu0jrj9G0JVc5Jq1V99cgOHIlKcLZfL164YXQsqb4tM=;
        b=GoiUaJf/w56HrRXAXtmghrTM0pFLAFp505a1fdKRziY1+p8sgZfw282PuiPDBoMXru
         7h2Lk7gR+4ZpDHMGA6pTXHtZlrLb5eZDTeBIW7XMY2HNEU7Wu4UJjU0njy9XrrKvj9Za
         Che+DnljrS7rO8CmzAMHLKDKCToPXXaY/TTFr3vig7Ju67XYtQmF1Mt2dfBLAA9RkoG1
         khD+DTo9ENK2dLgnprthVzsJBKtwN56bNh8eU76myHYZDQsYwbohcESJN//hfIPJAHEn
         0wTc3FYyDDg9oOJU34SqQJlwSOqnRXiUXS7m3B6IHQAjFHsjP9cJ5IWvAY7q0VS9szd7
         BhJA==
X-Forwarded-Encrypted: i=1; AFNElJ/K81ZI2ocb2ECexaQZ+lJcK0jJlCiKL7KiKt2dCm1kDoett0HlF54JQeTCdc5FBGBxsAQZmF38+g==@kvack.org
X-Gm-Message-State: AOJu0YwLVISzazlTTD1O6FuzXUQMwJ39o34wXRUp6ZiMux+XDyFV8+qS
	2AKb1enw5ESpDPRsqcber2p2HsViRMQFy3nbEgQZNOTdo2CNFmCZJMGJHrzJkOmCdpM=
X-Gm-Gg: AfdE7cnFNSi6FoLVjRGP1cV/qVf6fLY8rKq7uRT9iPAR1M94zTw3ae2iJyq+Mxd9RD5
	p7qSTbYpyDg9O6IgkmJUyj9R9kmPFCXrg4+jYzlR7jIbqE7o4VDrudKjFA3FKnUy+zqmFC0F2jA
	DZXA8NA82rdzzp8YUam/YDxHqkjPq1pTKD2et724I6V6yYvNhE2WhIEU8znFFtHBGtO3Fp+TXxZ
	+aunxhHodgagAL9/rkdXOsS3bcMcgUqGkYSrDi1RMTme1aO8ln16Qxi8zPynB8O9suPUbzmcSfm
	OPP5BpfqpjFYQJKbje4afVrfcxYfVzJB7yzWbNjbRXdp+52lgwuTUyXKfzfDhnZVILMi46guhjA
	rgd60GM3Mvy3/vuTyCoEd6TYR/34sjs2ajBvA13bUO4o0S8kkO9G4/dWt/coGG12zL044gKtk+W
	OO9ygmCMPrknv9B8rQmVKaaXrBUx+p
X-Received: by 2002:a05:600c:3146:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-4926686df26mr17640625e9.11.1782378257843;
        Thu, 25 Jun 2026 02:04:17 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492660025a1sm29880925e9.0.2026.06.25.02.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:04:17 -0700 (PDT)
Date: Thu, 25 Jun 2026 11:04:15 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, shakeel.butt@linux.dev, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Message-ID: <ajzuUMLm6ClyRVPQ@localhost.localdomain>
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <20260606114158.3126210-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a3skirrhonq7dsal"
Content-Disposition: inline
In-Reply-To: <20260606114158.3126210-2-usama.arif@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 748FB18000F
X-Rspam-User: 
X-Stat-Signature: aforryjshprwtkr398zfxpjey1668eud
X-HE-Tag: 1782378259-248643
X-HE-Meta: U2FsdGVkX1/dGkasnR0Mti6AYS11bmHQ2BwIkd4jHTRNY03TDfZsp3ecCXXNZKXUXcUcnB7ZePfLJIyj5GcCx3thM3wRruksTb29tPb3x/g9AYgonGW1rzuH4S4EUWm5Doxw3r3Pg73oD4tTTggytWctSmDRdCCJOOkoYkrUABDzGtrrOWFMvml1Pkrqe2Vkp4OUOJSIvxtWIS94B4AqQ5Z36TbZ4Z+nbBepJryRKN/mk/2FXVKYG9q9qUfeuKN1EHgrhRFBRgyf06aoizy1Q+N2RGNMTVweJ0OdG49Ioanf7TSn/GE06+JoMG6+qgahwIfqtJn3CI6INaRTPc85zT18p+Xj6r/8U8KBmfP7rxKhM5vBETmLUmCpvWKoL7MkkBHPD2z5i1JV9kjsYqpWkzoyR6WAzR7SEYVf694M4ooyse9lCbm8rq73Qw85BMMUyFv2kSkMOKgpc+0a+1a1g0liZv/wPoFYIzlbw1nEduff9AlBfSn8In6GBwymoDWPHMpAqmWszxEkS4AwoW39xN1JQyEgPI2X6ekqlEyxTnoItTA/TMU+FBARnYrSUkwaiUjA+Yz6OaHRZAtltIA5wzNcb7DwUJP4aJnMAmp24trVWU/DUsG/botmkiR7kh+Bh1YG0iCm8pnkFERTpTa5OvUGnQO4lFS6ky1vpTAyaesRW1f2S4ljnnq5yfIc4erDaPqPkhIHZJdso8mKZY2Vq4/v9tia0CUjaqdY8BZow7mPNnt7D0V+oosN3l8IcjnkHQPMMLS6MR/MX8iPL2ruwBl1V85i7DNgHt7MgGqIzBmSPYTgDO3V5oftSqbBDJDGndZl8iBG27NGWBeoHpNuQ/ECNZS2yvKnGmyGV4kjzVXCwyZa+gSfdjMQSXLsCVQaLfanqVRYOCz2avao7WjgHSFcliyXXqVMeyt5YGKJr1Mgd1+TzyqMe+VhP2ioyfqulyldC4rxnC/QCZVq+p3
 G+TuOt0O
 JZzY50IW9BuoOJdvsBiofFsWam0KrVUvxvt5NLpy+ClTag2FbRdMuD/f28YKeX5+/PK2EVFnFoV0SA+yd6uOFrcpr9Kzwa6DFDZ28a8d1lUciCAengTMBuaU7DeCQ5C7wMxFSdMX2phWgRopw3+fHDYwVZ2IDMxWdQLPU8nkDmN+wa95liV6+PPBwMP1S+B4jlkj0MZLHgtbs0tg+JYesvZZpUwOq4d/cK5mCLIfXWaa6V1/VbAnP/ti3kI0NKcDp9pbIHv0a1Vj63fmgA2tKEnXpSiW9aABaLmfcu01zwq0T1oAWdWcCvphdt0SdfBsg/CA284FdSS6eIhI3LJJ4m32EDhlcrvdIYg9ERVBTmPWcBDr2ZMDQ7QGx5L4OM7cJNRT0i3O0MeCo+cEFnmtvI58Rcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--a3skirrhonq7dsal
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
MIME-Version: 1.0

Hello Usama.

On Sat, Jun 06, 2026 at 04:41:33AM -0700, Usama Arif <usama.arif@linux.dev>=
 wrote:
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cg=
roup *memcg, bool tree,
>  		return;
> =20
>  	/*
> -	 * The in-kernel users only care about the reclaim efficiency
> -	 * for this @memcg rather than the whole subtree, and there
> -	 * isn't and won't be any in-kernel user in a legacy cgroup.
> +	 * Only two combinations have a consumer:
> +	 *   cgroup v2 + tree=3Dfalse -> in-kernel socket pressure
> +	 *   cgroup v1 + tree=3Dtrue  -> userspace eventfds (memory.pressure_le=
vel)
> +	 * Skip the other two: nothing consumes the result.

This is a good finding, I had some troubles convincing myself that the
v2 has really only the memcg->socket_pressure. I think swapping the
order of the patches would make it easier to comprehend.


Michal

--a3skirrhonq7dsal
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajzvCxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjKBgEAyK2sPiCVRkReo0YiAqp1
DX6XbZ2mWl3yrlHdcIthi7UA/RIb0yL9zFWqFQwRyNJ5P5YdqY8GV9DOcfwugT+L
T9sN
=oRoJ
-----END PGP SIGNATURE-----

--a3skirrhonq7dsal--

