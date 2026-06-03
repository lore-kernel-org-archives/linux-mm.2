Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B675CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EC46B008C; Tue,  2 Jun 2026 22:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6A36B0092; Tue,  2 Jun 2026 22:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C8C6B0093; Tue,  2 Jun 2026 22:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6FF6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:57:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1317C1C0DE4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:57:25 +0000 (UTC)
X-FDA: 84837090450.21.2EC95FC
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf24.hostedemail.com (Postfix) with ESMTP id 42CD818000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:57:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HRV8kLaI;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y3awZDWC/0BEHXSInI6v/h4g63e1F9fJCkxQA7vD56Q=;
	b=YrPfhzQJCZ8y0ugdGyk2hupQURAY3QbRaOqZ1TiJtWlPU0xY+kq8CxgUauxlRH0ilnQHFT
	gKg5c3VgsBgbR3LNnQa0k53RXQP7zizuPpoEhORAXhRx2yImVFSkPPqgcMH1n8n15AWF+R
	9EIR9eZsu7hbDS5qHTK+Lj9DKiv320s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780455443;
	b=xmIH7KUV/4bbC8iUc18Fn7HGB8bt0yxDtVX5IJI4rnslzJxHzPovkI0Kx86clI7csr3sMc
	nVfaNSaPEGMEkPvnsiZjqqzQG75v/3GUbBDsxCzKs9oVgENAXq8uBfIOoE9gKtSTQHrweA
	WbJPOkAZ0PWadk+pEtsqBfbyP2TJI98=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HRV8kLaI;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-915671abd29so264474585a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780455442; x=1781060242; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y3awZDWC/0BEHXSInI6v/h4g63e1F9fJCkxQA7vD56Q=;
        b=HRV8kLaIdz1zhXSZTQBDQ9ppvx66zzgkE/vNmdiHKMmhJDxUXTOmnRv2vRAFUu137t
         jDfcEjnwP/ViLY20HODWbwm10fzmxstnDQqhihIaTBY/O5U5ehx9vMyqNibOlAL7insy
         RnVMMWySPzngt1TiHlOS5YyJJe10DjDs6JiVrPar1TJJoq+YXhrK4zllDjDwsGeNjFex
         43Bh0lgq9SOmZ6YB/bpR7TX6e+BcZZqp10q7KSRQWZHr8yoeCKxaVQfUGCbBGnoqpGH/
         XDy1Pdf10gU7XicbeonQkBQgD/Vjy+UCPRTSMTm61CAXN0vaOeCn6DIO5ZqHOfdrFj3A
         r3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780455442; x=1781060242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y3awZDWC/0BEHXSInI6v/h4g63e1F9fJCkxQA7vD56Q=;
        b=gKfBaLKeR7M/K9GZdgqXGlAeevEquyhrBhZck8VwOGUtzCgQqakGSVZTHVtOOD2QLA
         dMNUTyIKRyENAAzLT+x94FBArgJPZTnPdp3027j5ePADEouk4lKCGX8LDN7f+R6xhydo
         MHMfDt3lt6YfhHE5E3XUvtMuztcoxg4+KWL0oFuyaUTjSXJgY74d4m/i1Y9M5DwTQu7D
         z8yEETL298fy4JQdutpRda+eS7SFWcdXo9V69Sf+a1evAVgod6m2ySiELvE0nT7aLOZV
         fga0Y9bnlrh+Wb0q6sOrS1ux6NqhtyU1YQP/peTeEEz3Irch7jqCDG/9Lm24NseIbtxQ
         nscg==
X-Forwarded-Encrypted: i=1; AFNElJ86SA+NSZfcbc9kOzzC9unvnmFCsDp24vabVSNCu4AlkkUCjLMufamr4PrFowMoLAC9aKnDKxhzGA==@kvack.org
X-Gm-Message-State: AOJu0YwoyKiik11wGH4WfjKdiFLnxj5rGjQbHTYIimgdaH2DEpI3J7mI
	tH/4xiH7t5YgCepsBMrfbgPbpF2ej5cPh/cuGn8FnSghHF4q3HGAoqDt7MuP3Hx2gHU=
X-Gm-Gg: Acq92OERx6URFOLprFgCN+Sqxw5Ffc6KBqthmc/nSj00rm09tFpKAwsS6DhmJEL5+8k
	j7AC1CK3pkYcfL3R8JB8rIdWnp8LQk8K7xQbuq9R+Ms3imscmcllWV27lhztQYPOMGUWj4f0PgI
	g+1deZmuhyhxwtr64boJ5T94qgbfsg2bw+W2oL8pobbRRwCkTVumZZI/PYmJu0PEDkdI+P70YMy
	F71pJQNyCDXQzukQcCOA+QROMrRb2pjx5xissXrUJD9S63R1TF/n69fDM+MEODke3FbV/u3dkBF
	6FBcOlfj44CSnUWfibVo/xOjNDqEj79jsvYijLOYQFHfbckXJ6DYGfQeznYphe9f/rlssAc0whw
	lNSC0ywg7LXsIhdaTuzWOD9Dzk/7Zhd+uX9IkV7wk/8GRh6xmjfms6XQKt5SEUvbh5MLnnHG1eR
	GMSjIEZ1UwEP2XZOEzB7vjCgyS3+1hK44P2050QQl+7SuVTL1tQUuSXllCUxy8gg==
X-Received: by 2002:a05:620a:3199:b0:915:86c6:8432 with SMTP id af79cd13be357-9158a6979f0mr317963585a.14.1780455442182;
        Tue, 02 Jun 2026 19:57:22 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37bae6sm118824085a.31.2026.06.02.19.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 19:57:21 -0700 (PDT)
Date: Wed, 3 Jun 2026 02:57:19 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 03/13] liveupdate: centralize state management into
 struct luo_ser
Message-ID: <ah-Wov2fvjYbpjHX@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-4-pasha.tatashin@soleen.com>
 <178038801487.119771.6308607614059754603.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178038801487.119771.6308607614059754603.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42CD818000C
X-Stat-Signature: qotez95itj5quxe6swqtbqdi1rnmcje6
X-HE-Tag: 1780455443-408612
X-HE-Meta: U2FsdGVkX1+EsvmVyOIwjDNPbsVuIAFoDjCZgHa5cw7mLv24K9hw4uQDXsG2hybuW/4YGqfPBBBD7U0bajtGdrHXlGtYdOVpEuUu0LDhE+qSXQxRLYX/7KrPOtzQGxSlnLzLgJ0ibJJXep4fCLJTxPdWFsQVA4p+9KH9PFoAhq0axFFuWt1jM4lGCqvQ3wYVszTPFeGjlldUa60ynYs4DHcz/nIYO5/bSkRFtUKoBHKrgirg6rZoL8SS4xi7MoRhivU/R0SSS68RbfcHfNchsX/0FAAqy2iyvXlWBtbp+Izorrn3/0TSc0vhbqfu5VbfjrcJcPlyacE7jpxXMghqeljn0dQlBMdVXyj6g2YCN+FxGNdkCLEQjX51EKKVv+iTc6KY565p5Tf2ecw5It4EiTZ+wAWyJ2/iJpksqHIThZCydDf7YpZg7ICc0XgOfaJFqtjCgxF0l8K4OMqq4L9lY+cnOX2Y9RiOp3/XFQCsrO+QYuN9LbtaA7qqL1FlM/y8Fqp2brMvlktsmX2WKBRdR5trAvJo53/GkslkTc17dgESRx+vD73/Qc0RI7vIx4YylXKI/PtvnRbcVpjRaRncREkSDyMvU+xprpNjTXd0TgA3rYsw81p4PrB/vPph7OTNBSiBwOOrmGhA2I5LdmtaRG69nbHeYQlCO/otm8VutUvYvxOcbbzs76jhqtc0rMBBqsUuyAwbZ2O1T5L6Yf+ZImDzXEATeBiTxfeI/xC4HjQlmBRgyGd8Dckad718jgkgL5F51gnGLScvOPld0FuBQJEJYUbcugy9NpnilmeX6veo5+Hi1pX2ZTTpvFzRuiOLf2eFVbKEkIebySP61Vcs+u1nsqwGC/L2GsFyerq6Fgs/dd9VtAdAGW+8SbN/2POicKvg+N1nhueEWVrjG+D6C1zHKXqLbXSvR8GVMQcVC1cyomofYp2qVGXvOUzEuDZaRHzPT5NVYPFuF1FS4bG
 2tTIP4aZ
 RoZ3zsWEEyH3Js5g3JwLEp/Y0mwTe5KyKzGv039zK+IbH1ak61YrT1AcVvzclY4WL8A1kFr9IyMzK2q5NvDsh4Bj+78hE1EIkwBRKHJpkmKIDG6MfvWuTnOL6LsIsUgXaOlI9VFkRbKcg/+4thVWKHCrm78EOiW1PGj8XgaotS98OjBTygXNWYCG4I7JZdYMYAtx68mZa5BnT5ZIYITPlMP9zDUTh+FUr0fXCcPqhEsajFFUslYjY+ltgo1z++DxH6uAg3iJwVAT9HMmdL4ztOvshK7vJWhv9TYXYIpq8/1Pif83ol7Jm1OdwBwSZ8OyQJP3TvH0itkO1+MsNF+8LIlP4b6P9EXF2bw32XEm6d4q0nibrFm4+uOPAmHvItARsBz0sBjy/FX0210RxGz7LbVLjQggtJlnleIg2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-02 11:13, Mike Rapoport wrote:
> On Sat, 30 May 2026 22:19:28 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> > index 8f5c5dd01cd0..c8dd30b41238 100644
> > --- a/kernel/liveupdate/luo_flb.c
> > +++ b/kernel/liveupdate/luo_flb.c
> > @@ -579,53 +565,18 @@ int __init luo_flb_setup_outgoing(void *fdt_out)
> > [ ... skip 18 lines ... ]
> > -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
> > -	if (offset < 0) {
> > -		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
> > -
> > -		return -ENOENT;
> > +	if (flbs_pa) {
> 
> I like 
> 
> 	if (!flbs_pa)
> 		return;
> 
> more

Ok.

> 
> >
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > index 8d9201c25412..3b760fefa7b9 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -497,75 +494,34 @@ int luo_session_retrieve(const char *name, struct file **filep)
> > [ ... skip 58 lines ... ]
> > +	if (sessions_pa) {
> > +		header_ser = phys_to_virt(sessions_pa);
> > +		luo_session_global.incoming.header_ser = header_ser;
> > +		luo_session_global.incoming.ser = (void *)(header_ser + 1);
> > +		luo_session_global.incoming.active = true;
> >  	}
> 
> Ditto

This functions get's re-written with early return later in the serires.

> 
> -- 
> Sincerely yours,
> Mike.
> 

