Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7A7CD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146758E0007; Thu, 13 Nov 2025 02:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11DC18E0003; Thu, 13 Nov 2025 02:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B0E8E0007; Thu, 13 Nov 2025 02:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9EF88E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:16:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B9551408A5
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:16:37 +0000 (UTC)
X-FDA: 84104726034.19.8DD6443
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 993A6C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:16:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vp7KYIKZ;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763018195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7wrlB1q7/ZOkA42YS9v1roGaOvVL8ukdy93xk+fDJ2o=;
	b=hW+Xfg3+kLyoY/gmfMGr9mbmYFNvpZOOA1wrRHzjsLFEZltfAQbIoCndiFRWW+8KSUsB13
	SO2w3K75pzFfvvGgLLOIiNsIb4PcTghD+IqDgPfn3SlXshFFLUKuUi8B/NApvuG3HAWNlW
	mCzpE70Jo4KgizPn+dcvyAABl4aL+hw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Vp7KYIKZ;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763018195; a=rsa-sha256;
	cv=none;
	b=AiCIFKwAAhMrhzV/bIb+5q3k7ZoI8owWivSEUl1WEy4bYf3UFqlrI4b/YSZGUaOptwTdgs
	2UWssLgYYiXnKFfXnBHnC+zELplo/zB3oN7vkRfrqsEjuhYXZ4tUSfTfdCLjCmHhjUazTm
	CBYfisCK9Mh1uYy6eaq5Ot1SvFBcCj0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b98983bae8eso261591a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763018194; x=1763622994; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7wrlB1q7/ZOkA42YS9v1roGaOvVL8ukdy93xk+fDJ2o=;
        b=Vp7KYIKZkOSHWgRtMmRJ6BO/3uVvFHGqWq6xJFNDhn9VxYJoqtlFTDU9isZE/j/BnI
         OElwVnKD+z2olGFrZhGlfI0xZNs2zXgfWggTt2SXQQ1TpEwX6gPP8UWCbzfc5TudRDxO
         yk3TMCMhNZXm+bGdRl2pg4lXsYTUwvAqmtedM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763018194; x=1763622994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7wrlB1q7/ZOkA42YS9v1roGaOvVL8ukdy93xk+fDJ2o=;
        b=c1rZE5yLJPFnjv6GDgYTIPmDV9uP/OX8Qzc+NCfWA/3kni2rCROiKWBYdFQDdzyaaB
         XcF/tUuXkhViGXcogJEsWh1nM/SzQzhSMIuqyHLNiH2ZMJAJydVp58mCByu0n7ZOtUpm
         b6MrJnh8J92OejTcSQAWiF9HkHu8F3BB6Sh/FkCGE5iVL2BX5R5vYo+124YmZmTWbLR8
         J694WtCEdCtQhTexodayVf6FnPX51FUWihxI4Ki25En94wYc0HTZYamvYr8WYrBkug2e
         0meR/wJv2sfdxyD0nGqnIj1ghq429ai7Cb4e/OV1IrM1U38qk5M0UxSCMjPOEuH3FHeM
         iMlQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4O4aRVfDqdJrflXD0N64He23HGMY8A36gnH/iy2Zbw2xKprQNo/Pxd3Tq0ZnsaKI/V38iTYq26A==@kvack.org
X-Gm-Message-State: AOJu0YyAxmnon3xS2iPMmBQrqgtkLXqCdPTPNsrxUqI6wzt0f/k3eHsR
	Mk/lpfXaHy97f91xpiIuR8Q/u/Zy0zHUVY1FGR9dwUtjvJgI9M1nNg1XYfHkVsNP9Q==
X-Gm-Gg: ASbGnctQ30cpxG+9zNY96A3GjF8nr4Y2TPJYTK7DrVtFJqIcT+cU/+CFraQ1dYKvXpr
	2CsYj2p6AGigmwuS3F2iseM+CZaCnLsewaiTmMI+WYx6MYcDvj0vGd7JUUu9LkGv8XaCjxuqDlX
	GwAmbWDEGgbwFsYkGPKrmWw97l3tYLYlnnUqShc/Gd2XqeAToMQhsy3yfBSESX8Y0wC1cTZ8GiK
	c3MIRd4LV4NasT1O6f6SO8KNgQugRhgRoJoezuVI0TeaBeuw+vZqB34PeWfGBrK90UOvZisydIP
	C9AFdbBpd087gMbcw9PL1plnUQMJZAVXeFrYSMRpNXhxjCVd6nK5hXHOE5vJ6Q1f2g0nu2E6tp0
	DSlNiomc2TQVlCmPmLD4Z0Wstf5v1+QlCrTyWW8VR4wy3romZzLn5LFa6Tw4ysluqzLAOtdCNqc
	jDsp+N
X-Google-Smtp-Source: AGHT+IECRPkJaf4oGfrwi1MX+s8z5xbRJJ9Jk4VfQe26C35pT5SliM8hefU6QaId+JYNDJAkFupzCA==
X-Received: by 2002:a17:902:f707:b0:295:50f5:c0e1 with SMTP id d9443c01a7336-2984ed48facmr73094665ad.15.1763018194389;
        Wed, 12 Nov 2025 23:16:34 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed39sm14278045ad.77.2025.11.12.23.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 23:16:33 -0800 (PST)
Date: Thu, 13 Nov 2025 16:16:28 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: introduce bio batching support for faster
 writeback
Message-ID: <txgn6y47vwxb2d537374lklpbwwxy4r46okqgbvqxwxppjfwhj@wttkbv2pjjpx>
References: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 993A6C0003
X-Stat-Signature: hi3i1gwkfjjka8hse9hjq1ppmyftifgk
X-Rspam-User: 
X-HE-Tag: 1763018195-423037
X-HE-Meta: U2FsdGVkX1+FcTtkmInUF4t6E6EPpxGmj9r1eXRmciXPngezp/9F+gLDN8uoFVO4Y0nkKCtciulmT96OiMAJKKfqY6pSpcS+16A1JHv4LO5oO6yJgiMuwBPxclaZ8CCb1j3C8TC9rfUYBI9XpDhaLOksVjW+zqObfyB8KPI2nYLOM9+vuKDBlQu2QQWmqMSMoGlFRZuFWOWDjQNCFS0P5y5NBJX9L8GWSUdUhyArF4HQ9oBinpG007UCpBbFjR42bSo8U2wYCdYEVLwml6dDsmB3nE3Nv6n86S7TBfLgieHOcc5ja3nq0ULTGFvdj41UTXZ4dDgCOeH2rec4hzJCQyEmjdvvO+Tz9ea8hH2tAWMuBZ0gKthEdJlGxNJXCkOzqnyCBoGP6sfOK6m1ci8i4C0l+pkSEeeTMnb5Abxnf2upjvXkU9ZjDWUdGUmZUsQuyv06TWmCRlrDqUfbiS5F36oQlb0e3VhsRz3mW9104Bh4zUpSbNMV9MU5oWCgvw7caXE+OUoqNDXZHL+ELr5QxamPU34F/IFBKG2padHY6ZbOjX5gZ35d+gpFgcIeHr0JT2XIKR6Cs7E02xxW0GnF69AFtCcoxlyOpqrUJkmHFfvQpI4zfyE+8IYxvQT6Fntl/kSFvvPBEZdxGz09hHgvMTFJP4ZsUEdzXg1VLrcL0RJV8tJmWCOh6iiC8H2YK+tutApyqPgOW3Xs/oAdIfWUVWAs9PSwqjt5bb8QdKPNnS9K0vqNpSsDTQ90gr4C/37eP8qupiwgQNXPWLMxjvwO1hjLaQ/2reLiBSfZytBtZI9afjqRAh1N89IagEcT2XfambUqbeHaXAKBaFvahr+9DK5bZT5sicMS7q1OVmesl3HmDy31SiS6QOfDwyFh697X+Qe786XbZlH0UvuSPydkGBcZba5mEsOFNBh5C+1+olx2j8t+nTp85+9zjullxNTo0mNpXvnCz+80OccnMfu
 KBa36VBB
 J5ZW4Q53BLD21hHR7DNSEgFGSPbJltpWoZMMdnQ4R7YkUc4g97Iy1xqBLb96JuHLqHJMkWwkXG2ANsCMIL3KHvSl7jbhNIYZTpftVC0WCVIIWAuru0h6P5eLjgxG26SKlb5OZFKai4thWu8k1fvzkei4HlYWo2wtHjH7hlm5R+2DcozVD7d4QFa5yp9+yUQSnxNH/XnT0UipMp9xnZfSj8OZ3Z9jvKfRmxCMWqr5lwGW3ESfhcJcSzIOwKDJbf6S/Cg2jJkcmNvi2QxZ6SAWvgtd+RlJNPAlzqxZ66Fvo7YOiLgky3s/pTsIiqAJMuF+rrnBysUQDADLJYT9zGB+SI6yhMRo2mqPiXJ9kKJt9TcE1giU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/13 14:59), Sergey Senozhatsky wrote:
[..]
> @@ -775,67 +980,41 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  		 */
>  		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>  			goto next;
> -		if (zram_read_from_zspool(zram, page, index))
> +		if (zram_read_from_zspool(zram, req->page, index))
>  			goto next;
>  		zram_slot_unlock(zram, index);
>  
> -		bio_init(&bio, zram->bdev, &bio_vec, 1,
> +		req->blk_idx = blk_idx;
> +		req->pps = pps;

This should move ownership of pps from pps_ctl to req.  Will fix in the next
iteration (apparently compile-testing is not the same as testing).

