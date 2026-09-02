Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05612C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D5C6B00C0; Wed,  2 Sep 2026 05:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECDCE6B00C2; Wed,  2 Sep 2026 05:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBDB96B00C3; Wed,  2 Sep 2026 05:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B281C6B00C0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:02:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3688E4011E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:02:12 +0000 (UTC)
X-FDA: 85168230504.04.95A327B
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4CFB0A0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:02:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jqE8aP7/";
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339730;
	b=5h7jX3bhb4fHKY6nKqgy+wFtKyE0qVeEXwG5+ygcKGK6hWNfKXgPo1HKAaQ+XVxg5ikFpo
	dZZzFr/c/F0VgAWyiJo0JuOLnFdknCABKCHYmI/R6L6mz28FFNAd5HEWxkMDBcXKO4ctUx
	6tYmApew/eunmv77xohXHZ+p5/uV1KY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jqE8aP7/";
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fy8D77TbbTZZuJ5DhR2JoC+KqjSKdSPnzBcIAoctkic=;
	b=Um+W6/h+pAlggcqlAeJJ9RzDDX4wjuPTI0kCjZ9ux1IEmv43gGQxf9tOHBnTLEIIMgw827
	pcCp27BEirQdJnFk0cgBAOMkv+LpV8Arc2CPOJjEgXOtuw23fvLWbghmVJNqtLkCBmLE+B
	VWPIKpR0PcqZ7A8jwUJJMXqZLe68Gys=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso838310b3a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 02:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788339729; x=1788944529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fy8D77TbbTZZuJ5DhR2JoC+KqjSKdSPnzBcIAoctkic=;
        b=jqE8aP7/res677A4OpemYeKSA4r0fdes3dkqy0rexIEk7U9XOCYbUXpn21TM/mNzR3
         CQh4AWCfOgDCWA8ad9Sl5XsPU83HG93G1Y6IebZNYkYM57do7U5dnXZQU8ClU43rLt8j
         L2vYM6tSc2ITtlaCSOqoPkKbUCmS6dBmOCkxFYEhe89Rahv7/lrOk4DJqo/RxTRqf/0I
         51NzHNAXEBwZj6vOqJkGokfCNAfAhQmvpvDXTeSA+7+4nNBu3lqA8zsAV2HHXPUBcliW
         wnJTCtd/atpE7x6F0brSFNbJevmSgMxGNCC0aTiuQVoLow+xPGaK6EPhjp4FL1VvqWi5
         K3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788339729; x=1788944529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fy8D77TbbTZZuJ5DhR2JoC+KqjSKdSPnzBcIAoctkic=;
        b=f3repvI0rVV2GDFqpNxUlwN/aWENsAwabh2aiy/MqJXH3d7+keDimnd79wqfRSwpa7
         SR8gdZ3IzQKTf7+38fXGpUnTDKQxRD6XaMBqq4nll8ruDGaAHv9eP+hHotMAeplWQ1op
         wfg+R0NJOLQGYIIJPgdo47yefIzrkeEelXr17g+wjZc3quFcEQfdAjQ8YR51GIH7stH7
         IDQL1EI7JdjpD4HuPlTXSW2WTupISMwfw0KE1U2mLKszqC6oSkYzA6WCTUcvXL5spn2a
         PHR5ACV6tmy02HK75iyZW7enHiIqlgvcLPDOcvZ9HpvMZlrFpxc1aoEjsGfa24ObKuw4
         +X2g==
X-Forwarded-Encrypted: i=1; AKwUvBzUqD3Q+FVVdzVCbwsrKMmgrZ+qUp1IET+mAQj/hvNm550gXYVTcQQvYUY74hfTHFz87FEjLdsZrw==@kvack.org
X-Gm-Message-State: AFuF++k/w625j91WPYyflq6uWLYEAjaWpNlUoD+zV68sGwkHhAbpaphH
	JRXLsAt5Ve9VTtTC3fGVRX6aNVoIqEx9x7O5fkGJBm29VbOLShyFArdF
X-Gm-Gg: AYBFou301xEpSNDGSuznSpuV2vQOZmVka9MalUg+tg+4FsPXzpfhuzbnUj478l+ngLh
	uuDMtZiLJ7T6beAtVId3WNZwRIfBhuf5dAFuMBc35E393C3uckl1JWE8MHWy14dOUBclPRA1GDB
	B99pZMcDdDBlebs/5g9W7ueVNsDQaH+5yAcPPK3Rh6qEcFeMcus78Fs7AWumYUMg9BIRojg0F3c
	65IEY19YjkGo2DbAnVDq8tWz3+CI16vzPLQfB3FlTu6hR/W0gGIAx7Mdo0kgcQ3fxj08EKjaoGi
	4zIfBep8pwG9uBATA4cA/7NsLESN8/vRw8LlJaqkH2ohfqAzm64II4wWnkC+RnbLDq9L7mw2ggx
	GDz2e3/gVZ1U4L7T7oHzxCSXybOtpI+Co3/TnyKn2XtMn8RZgACHRnrfU81p1hwHqmmN1p5VYeB
	PaWiv1F9KTJC3azzdHxOfrZRudmpNfVKH7KpBBlJDItSLDiz0RSvH4kmtmp4YtciIrCn9UUY3ds
	+biIRvtf+Jo1hjTaA==
X-Received: by 2002:a05:6a00:7099:b0:848:48d0:934 with SMTP id d2e1a72fcca58-85f448cdd36mr1124512b3a.18.1788339728703;
        Wed, 02 Sep 2026 02:02:08 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db23f7b8bsm1038728b3a.2.2026.09.02.02.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 02:02:08 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	sj@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix false positive in
Date: Wed,  2 Sep 2026 17:02:17 +0800
Message-ID: <20260902090217.29968-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902081825.18931-1-aethernet65535@gmail.com>
References: <20260902081825.18931-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u61ru8aui7zp4obt569e9634zrq6trow
X-Rspamd-Queue-Id: 4CFB0A0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788339730-383531
X-HE-Meta: U2FsdGVkX1/EPw7i6GCvpuAfGSuSVWqPJXkH8hVE2O69rPQz+bGaPxjS/zryCY2347Eu48JR3SHsvQUwcEu3me5XSiDP/zF4hIEvXesJID3s5sK4u05aufjowHONQT8IGlx8YYsb0hfVwqBAEQEnGyaBZWhd3lCG56+E4zB7wZky+7cHCOMP1z8CzsXy9i43I0Cw/7pmovVdeHjt+ZwJInAcieteGuQcqLlXxUfBItShvxJlv/pZ2EThk88mwFu4yOfc0Zd/sOPZo1VMPltsOJgkvZG16l2HFflSYdwcRCfCUNwwCnYfqkr8h9xROSnj37tc3Vc9EzUtbGkt0eW9qOcYb+6VoM1lftFxaBDOsuLqLTEiSlXh3OTe6ca6jgITKR8j06aiT1iF0aR+vRqVoKQzvngVoYDxOPWvXwVF3XqRaubKHQHB0O2S1UnVhUw+LoG2YGJuCrpkXj15QWt59EZJisPgXJumEAs2LvcZa/u55kTfAutjO2OIOBKuRZueFJUxiEjmYRGq5B6fiuP2F4a+/Pbum1iX25CSVz3xkC94T7V+OcYTS2/8c65AHs0FPl0aLbeuxqYKEzqQPyyY8bd3HPSLN/vHT+6luGynXAXSSfyrxyhZW097cB2UrV6fhKFv8YjEoZJAR22v1W6eQ0RYCandXzsPG0hYgRgghHencCiOQgUsqHlC5npDgCOUcjpKcuJ9zOcKl9EhLudWSzPj++jvwfKQZoQU5QDnCMBOhWOPqvFLnymiCsa+60etiaF564pKNGbwjFdk84jhUterilJI8yVvHR9aMJo4DuZeHP1+SFolii07Rtqj9f8V2zIH/FQweM/OhzUtwfJXk4ywd00pdx/WzTPfkj3Oy6f/3e4bkmhRgeCnYI2e5e2IUBV+9DzJqk4TXrtZ5yxgqrvlN9qhSrrE2zMuQ9l9Kz7qkWntxbGjmtkZiO7fZtYKxOicfSQDbjm/HMKPIei
 BaPuQYi2
 HcOiB/OB6L5v3LjAlJnMzKHX7qYgJYcRwbGlElvUXOR3nXy2IK6qYqa3QLnlTy8INlrzSIF1yYFJQCmAOXPrXP5dIe/0YcArkWxI/rrMoh8xs9EBVVd19TnPhhhISZQTeHqMHHSgEtqvmc6k0dgrajyswAf2pQv5KTtD/yd2wXqA9ytk42sUvBPTBgK4HN6zHaUXGLjbFX6zJuJQbKpVy93LegH0vq9NiKVQAC/Xd8euM1FQiQQRTziuUVE46fcUlTOvBB3MNXiDwy/1hpSVgU3Zd/rPQM3m0gTMU9Z1gYF9BWXWZlkf6MRceXfKxcl3TCQjasmEbA07IEA3+Wp8+0bMtWlq8s4C153TRF+2J4U+eK7YhoJ4lFBMRdSEaopVfgXhjmlYCEldM8ZGhpfWE7+vTS7yqPJP54KtEOP0oLu1nRIj+Kt8HrfQCzPygjB3rUuKk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 16:18:25 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> When setting goal_tuner to 'temporal', if the goal is achieved,
> quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> will always return true, even if no regions have been tried to apply at
> all.  This causes qt_exceeds to increase unexpectedly.
> 
> Fix it by:
> 
> - Returning false in damos_quota_is_full() when quota->charged_sz is
>   zero.
> - Adding an early exit in damon_do_apply_schemes() for schemes with zero
>   esz.
> 
> Fixes: c7ec7d5f6b3d ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> Cc: <stable@vger.kernel.org> # v7.2.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> 
> Changes from v1:
> - v1: https://lore.kernel.org/damon/20260901105925.106186-1-aethernet65535@gmail.com
> - Changed the check in damos_quota_is_full() from '!quota->esz' to
>   '!quota->charged_sz', because the former is an upper bound, while the
>   latter represents the actual quota usage.
> - Added an early exit in damon_do_apply_schemes() to prevent a scheme
>   with zero esz from being evaluated by damos_quota_is_full().
> - Changed patch title, original title: always return false when esz is
>   zero
> 
> ---
>  mm/damon/core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 8e3ded1a2cf6..de78ad56c8b3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2560,6 +2560,8 @@ static bool damos_quota_is_full(struct damos_quota *quota,
>  {
>  	if (!damos_quota_is_set(quota))
>  		return false;
> +	if (!quota->charged_sz)
> +		return false;
>  	if (quota->charged_sz >= quota->esz)
>  		return true;
>  	/*
> @@ -2666,6 +2668,9 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
>  		if (!s->wmarks.activated)
>  			continue;
>  
> +		if (!quota->esz)
> +			continue;
> +
>  		/* Check the quota */
>  		if (damos_quota_is_full(quota, c->min_region_sz))
>  			continue;
> -- 
> 2.55.0
> 
> 

Please ignore this patch.  The title was truncated, so I've reposted it.
If Sashiko provides a report in this thread that differs from the
reposted version, I'll forward it as well.

Best regards,
Rui Yan

