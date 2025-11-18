Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC486CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCB88E0006; Tue, 18 Nov 2025 02:00:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C4F8E0005; Tue, 18 Nov 2025 02:00:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B928E0006; Tue, 18 Nov 2025 02:00:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 828428E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:00:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13E00C03C7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:00:42 +0000 (UTC)
X-FDA: 84122829924.28.39EBF9F
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id D37B62001C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:00:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Rph7KNau;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763449239; a=rsa-sha256;
	cv=none;
	b=irWYWzYeLtVqXptqYJW83ubv2zOdmh9eIgEIP6vqQZQE3IaPgwQkEzh3aetYvqTAVvblI2
	dnbAFrrSHMTaIydWNkDx7QYXffRFrvWDv/qs8jrAhClFhU4BEFLIxUkVjv2dbqgOfw/Flc
	dDea5zMxegcPsNxXOrlgwKlmlBvkQ3Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Rph7KNau;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763449239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmTt4bdcSxqSZRCTcBCbSzCGqQ66VU3Pz/goFqi2reY=;
	b=fWwiuMB/Vg+SG3XAdmq9BjkKvmyqSIQP4ttXGdRjTTpaimwuQ8idWooyz+OIV6+klmatHF
	Kr7F2pUzTlPhBqQKd74Ok3rvuFw2H5wcX1xp0+PEVUGsB0j3FgcJYnfI0CkInfHUFgBh4k
	MziGUBFwJ00cXpH6IeWbrwvGVJgGShE=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297e239baecso56192235ad.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763449239; x=1764054039; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RmTt4bdcSxqSZRCTcBCbSzCGqQ66VU3Pz/goFqi2reY=;
        b=Rph7KNaunv1hvbcR03LhqdTUp4q5czFMj1wGNu/5ErBoLGqQknxYKTrlw/Ekzc4pPQ
         bBQhH1GeB7S2sMHs8bLSELGK71NCjDQCuL+wxWujtgg1yPcbmz5HA4o5+cvkhSHZCbsy
         gxEh06VjHzuwV7hxIW2jLbYgX6sNifSvIJEYA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763449239; x=1764054039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RmTt4bdcSxqSZRCTcBCbSzCGqQ66VU3Pz/goFqi2reY=;
        b=ODvoLaReIz6UMfJGQJttRLKHsIJipA3d+xjGMk6wyVqRW8o7LAZiG5W6rs6gBv5cAr
         PIukjAhkSpdEbw6WGN5LnZjjEGgOzr0osklGqRejcMTeQihaJ2BOoo1EaqdO72CE+Eqi
         5AtsI97X8yk0NOU7nxMZilnXU8Zbo+PQD4XvqeXbQfOBnJNsa//NR2CHJOABCUDS4xbc
         mYDVjWwLA0rOjDlvvvGspYmfFiQIClN8FvFa5nVq5BZJZDBN8/QtA2334r23I6qnuDm7
         Dojnm/nhB3tIkNMQiPpNpizDK2+/JyIwMr2UUncfBS6x3UxAY0lTudfvtP9+jHP0Ky7k
         +itw==
X-Forwarded-Encrypted: i=1; AJvYcCXLkSuSQ/RLWFcL0pSeR/a57MJy4Ef2i0DMLbtDqn2bo0B8YADg6i2OSKbx1q30XkWOD4sxTiGrjQ==@kvack.org
X-Gm-Message-State: AOJu0YyVHyZXijrbta1wzp52noa5etuuThd6FzBOLeQnViS8j4rlIk2c
	n6zQ5KJGvOia8mnxpk36SkQjUMDjUdEAGXcs7F9GSFpvxsZNxnmxggWE3CiJJ7DVjg==
X-Gm-Gg: ASbGncstyMwb3ZtYSUI0jF80nrsyYTtb4jbOcEUZO7EIU7eA9YvlHpZ9f3bTtP9YS+N
	pOzBNrLe5LLjzM66o6WiyeTch594192l0DYz+RgufWD4VtG/cRf+p3/FIYI7iW8R9AZV1vEE6gs
	6+N6k9JjwsJw3au22RlnviwYQqdBUa1XcdKz0D7dd3NOuJthWA7qKbdpcO8rdQZ3EqKPwZhJ9uC
	UmmlfzSl6wIdhJ0CrQFf2q3CHAaMCoH6kfPBh8PcrsIJ6ZJbo6ndRn5CrwK68UkJUXNfO0ieUG3
	wXLFRR3bwEPgqG/Jwz4vM45O9BT1V6aYoqQog7Y/8DfiwAeuFdFdVTlwB+8TX5JT7oQ5GiPsq3b
	zOI0LIXrtESfpxae/1fi2jZuE8WCwCGzliG7cPq1xrJKWpUg8PvkXEGfBb3IYW+odnNuGkIJmSs
	BhTzFE
X-Google-Smtp-Source: AGHT+IF3GB3OuQkSGJQgjd6ndP7i9bypEbEprGds7oNMXJqRWrwJRSq9m+dsDKDeLD7REP6viKq7kw==
X-Received: by 2002:a17:903:3b88:b0:297:df84:bd18 with SMTP id d9443c01a7336-299f55b8153mr28585875ad.30.1763449238472;
        Mon, 17 Nov 2025 23:00:38 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c24941csm161791945ad.41.2025.11.17.23.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:00:37 -0800 (PST)
Date: Tue, 18 Nov 2025 16:00:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Message-ID: <hbtjgtrba2elesgfxva63y6g2s3ycnwv5yhxlwknrfpulmljte@ghz2eudf3i7r>
References: <20251115023447.495417-1-senozhatsky@chromium.org>
 <20251115023447.495417-2-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115023447.495417-2-senozhatsky@chromium.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D37B62001C
X-Stat-Signature: q466cdgdpedc5x1bphg6jj8xz9etnh7z
X-Rspam-User: 
X-HE-Tag: 1763449239-978170
X-HE-Meta: U2FsdGVkX1+Lj7hXVz75wFTgX3Q7VParIGoL/ZaR9P4xwu+RMCQ55W0yVbCjt/N/a+klT1HB6OhKR6ZmwDY1IZkLnBFmBEpgrF4QTUTsziLTsaSOJLa2wgYLcuA1JqKKTy4xpRKZ3Gziq3zganL8j5/Qwm3RxW5EyVK5pyWI+jgB2NFrjT+qLW/rFkGAyOfx7pL04qM/q+SKvDH4h0f3tgK4H666Nu1R6VxFUInSMB0DYaCxYFTjjuK1xWyL86J8+86CPRsolX/w2ro84ZGLNYfklL3GX6V9lAlTGLnrmQMYr4ka3HGrp/5j6gZFLBwjBllFX5gXdcmJ58ZNvbNnPgDb67iOmB0GPqhOeeVAPh+7t48PJIxd06z5e6SEExtiau17AaOTGM5M8xxc6K7NFCs36vZ4dputQDzN+lKvBp+8JD8Vq+m9xC3XLanE9829S967b+DiacynkHJcMI/yPVo0Quc5jHC8qr99g7W6WfrRy6Rce0BnCO3KXAxberpDNnzfKp4YCYVXtPmwFqoH94y+os4yQ8511aijE3+bvDtoGUeodAweMycpIoNLKW0mX3ClWUaYpjNvZHiZUJaMHyU74ScL0imwMPCjQtjuHbSc6BKe+3zv3srvu+RmXJCQfoBR93M9WCIfhz0Us6lnLkJ/Hx4KEVavp+4yTSh12xJjYa8jOum1s6+oLz8KakhP3O30dzu710+32cLEzu+OSZtfiYxfCyX9JJnreVw80BMTDzmF4IfoCjaKGsy9tcLhkgC9fRgb34uI6jXpbF1IC79jcnR6lKyXK2cDdaeX0eCK3tJNGDwYMK7/Gw6TBHqu5hEcIusRDTSqHcYNLMVYkGbJIC/zcBSIAKGrAIez10v0Fod0QA0UiR6+5u8XcYlajeL71HsmIG45emxj8se5i3sqislXfqDv1P6qURcqbAX2uiNl2Ir4sQdLkHL1GWXOiZ9la6q0yyUUzQiRGNI
 HRb/PVGW
 4tnaZdiFluc+ZnaupuHjbmj2wUkc/lWdIin6zmHTBWQf9kJXwIZaaU6bef+Wgi8xwn4UEspEOUF4pN1eWkY4Kk58hb/J4Tz+eK28Hg3IavCv2Ex8feRguH5Z44GSK7m1Jh9zyHSBw1Ko/vPc6sxzN87xJepTee9HMVi9ndlcHWWL/537OzV+3kz49FxPDjLYWhQSTlL8HcaPniq/RQaVjgact8/m49RmWjnMgfCTsApRV62YLCqnDdPBF//EoGbzC2FzxCkuv4NnWaCf6wBUyYe1j/Mbgy+VyvY5a2s+m/qeZgrLFl3yAkSGMXLZxZniwIBNhDxBLQ6ivKy1E+NzFRzyb5SqnaXaCbs+dVaThIByvDVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/15 11:34), Sergey Senozhatsky wrote:
[..]
> +static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
> +{
> +	u32 index;
> +	int err;
> +
> +	index = req->pps->index;
> +	release_pp_slot(zram, req->pps);
> +	req->pps = NULL;

It's too early to release the pp_slot here.  Will fix in v4.

