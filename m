Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32E0CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3B596B0096; Thu,  8 Oct 2026 06:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC50B6B0098; Thu,  8 Oct 2026 06:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5616B0099; Thu,  8 Oct 2026 06:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 769136B0096
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:45:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 734991401E6
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:45:01 +0000 (UTC)
X-FDA: 85299126402.07.0EC172B
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DE3FC0002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:44:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpOBNcBD;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791456299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dH+v/ufGOq7i0ts93hi9MHjSRomJDT2cVjr72NMJIW0=;
	b=qTVNndwfDEqI5x536FrKfgOfW39VLl3W8M86/BnRIWwXk7R7x/6+e/BwSZINC+Thjja4Ny
	HVvEsjW3Jj59MIbbo+PJh33KD5BJb5M7bgv/0OJA6M1GW058edrktoiEuQUkQwpuSmFikL
	ELkGUqVAECepwYhWn6tkIGu+2YP3KaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791456299;
	b=C43iuTm06Iikvenej2XPEQp6DG2B5mhyty0xCaXbYlWDGQjN+ob6IcrU2+GC2VqS5Gr2TF
	NtuSgc7W2PHvFZgew45DydaOF+ULtx1MgQpetM5IonIqXcqoxAnMroPgDdxbGo8/4SyPZ2
	G8PzmKJgbnfYdy1AGH6LeszmJxfV9ek=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpOBNcBD;
	spf=pass (imf22.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so1250378a12.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 03:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791456298; x=1792061098; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dH+v/ufGOq7i0ts93hi9MHjSRomJDT2cVjr72NMJIW0=;
        b=YpOBNcBDRYuEWDQl3Tiq3K7khtylu+Ya3lxLkOoHgyAkXpCu7Obgvlewmb7cXcuRoU
         0Jb0qfvP1CY9FXpXL8b5m7ROm05vO+u9/mIeHT6tZdYClbU/rARLk8uAE/iYEOW0vBIK
         6LweFtuXUAOMyT7xh8ZCf8vdCEBmJamNKTvxxoMqKHNjeSistHfs6sozlbc1SPthb031
         eajFQ3JarUtsj/Jf/wLV/8gKpefz4sBX+2KVDkqZR1dhmmppsXe21XXxs5eLPWiw+5cQ
         e/z1uprOzmZrEfh8PYAIhI9zefEWoT3Qdf7CdyWIlRtc0KY+qxiBFY3f3QtJLznpiS8O
         b6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791456298; x=1792061098;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dH+v/ufGOq7i0ts93hi9MHjSRomJDT2cVjr72NMJIW0=;
        b=Qm8dryo5DPTfryQjfETlPSQFms6mylfVe3YXUfzpZsP3YtfDYE0NTtUgXOHAmZSttD
         wT9+9+cRw+Z4cpPVd/LP+HjOWDwdZv8LTDQ2+fee0xawPh7JXxkQkcqYDELz0povRyuZ
         oxZezbGhRuyMs4rjlwMOa91dZPW6YV+jq4jDI/sH1L4usrEyyN3U00D6mghaSUhmmknh
         qWEmqfKAx9Z+isRkDyLzKn2+XoEWtXbDz0Z1E3SqJPXLp/DnHgYyznKLlw80/Tz8RKG8
         /+gIIdUd/YD0nSlZWi0yJgrGEeFLespRu9SoTZlMTGDu4QKDX+yo06KMO0toziBi+4KS
         XX8w==
X-Forwarded-Encrypted: i=1; AKwUvBwCNGM0aeloc1+s+7iEf0LsizHCcvul5rdgxFVVP1yQnvd0rOKbjpBuTZbPrUtn10gvlwCDoo2zkw==@kvack.org
X-Gm-Message-State: AFq9FYK0e/ynadIWcxM+2I3FnhEGxB/oj5WkgLqpG1n+O6A1qVYj/QGL
	ko030/OW1h7SvFemUfHco9JY+1hP6azh7kViIsBLogbjJACZ+HrKi1AX
X-Gm-Gg: AYBFou1rU2zKtAkUEj+AAbbtV0E4IE/3OAYN02VQZbauEJN0RTxB7TqdQxgjC1z8IdM
	iRKVooKazbT9Cw8+P8Am4lifnzRsKYCtZTPAWzXgKVVAErEg3HjZ5Xzg6eqmzayCMp9lMFsPAPw
	BYqCwosdDSZ6kNgmcqTxKjt4y5qrB4xE2YCDCYeaRMjF2PezgJVL5vnne0PFXZIGOE2blEfh4mg
	CZc30hOzWmk91vS7qIfRF8/nZbuoifDSI7cjHeOc3G4bHFnLHhEfcSmkIiVO8vphlPvCE8lWi/x
	i2OBJGdGtnybDCSpk4QIMYkmAa0GOs/sMGQOmTv2H0YK1pRPDMKBEc3wJBDWOcW2d9V3KBbv8Wm
	rtLkuQ0lm91QO28WhYYrB7M/SsGMaUXuoWf/a8fpGCwFbUG8l1q2uNVuYiKgHZKGLdKXX14yyEu
	YvU1ynXC8J5GyQ7lUmlbdRF/THSCEwTF+wi/M/80oW3wn4e54OmSAiZhKjN2+WbvatiDVw6GrjP
	su1junQH0jQD21B9Uq9hJ+cAw==
X-Received: by 2002:a17:90b:4fc5:b0:3a6:dc2f:f07f with SMTP id 98e67ed59e1d1-3a8a1982a7fmr4554157a91.10.1791456298338;
        Thu, 08 Oct 2026 03:44:58 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:d08:1334:29ed:db11:2c4c:ee4f:606])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff848f9csm3616656a91.9.2026.10.08.03.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:44:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: suhaas@s-joshi.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	SJ Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
Date: Thu,  8 Oct 2026 18:44:45 +0800
Message-ID: <20261008104511.5290-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261007154851.45368-3-suhaas@s-joshi.in>
References: <20261007154851.45368-3-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9DE3FC0002
X-Rspam-User: 
X-Stat-Signature: u66ayj5o756d8n5yb4mfuk47yqtt4jqr
X-HE-Tag: 1791456299-983462
X-HE-Meta: U2FsdGVkX18XncizDJb0XxDNj6GHrWX7R2J4GKJJSq31LYqhMs9Xsa0VSTZbf6aO5GySxWTbATni78UE3nWsIAoUxf9lR6AleycFOy7tKILilMkogc6d34/GTlSzHCMPQg8P4YAZg/ujQFyfK4dm+KtAdYN/GYGJzIHFpdFenXOR3CIhitj231yi3uYqg92GcNAP5/3/AVJAAL4eXHS6PrCwBQm2UtozhqCpdpVNMtPS/EbASyTdrQauHpAdA1fGHW9MZkFe3vLFRYw5KeI/AXgTZb6a9W2jg/zC0T72Cnus5XFujm9Mb2UXi4fb/K7R18/VKBlLxwIyS8w/flH+RJeEYK2lsT/f/+oK3QUl3oEiBTkS7INqdbGiV6UYE1eTH2u6/+zL2Y/h6/c6hxeVtEGVpgoJuDgUJD6hPQSMwgQjJ3norJBLzcuLh7FobcvC/uFx38tesNRBDgUHrXQ55S8/6Zl7WA6G9NZkTM/nDvCGT2m4m/Th65tpuiJI6mN9DqZHCIwe8IaR7356RfdTIAZVVwIgel2opSvdfv9799UKsFhtT+zxCtrexgCmCv/6JZ7BMhDkxZXaY3WnEU87gE1UMNMwwD0xns6u35lzy+dwSguOv2DGNiWgb7H6CGRyLpMZo3Quaukwej/l/3OENlNzCiy8fGqSdTyHOrniTGdCJvhmA3Rwq7K5aK5+6dgDvZ6N5Ga+4Xnreb+3Dz3B+pVlPRcuFnrqnc61DBXfngb8VqZbyNoqU+kp+qLizlaV2zmP3Ie37ZOfH1hVVsXykId7eAVFJoicRBUD/vU9EPIQJPci/0DdYr3xkXag5rlNcF1KHORmhZrjdjitNPMr5BNxtrHqGZB6VIPK462H4ZE553N1IkTL6bE2ZvS7qJOSeZmTodzWUTIIoSE8gDV8Vq0j1LAKTJK9tvDT0O5fzelI/+nKTN7n1KKd4Nw6E7WDQWA8t7qruZ/qvTigm1P
 jI5zziMW
 lxUw8yiV9CAzTQkZ71sH8q8ItlDkugFNOvlp+8LkNU9GMk64ohSst7/2BP+9zD9DwT0iQMkPqOr2xCwaQCnHXu09EUMrsA2+inzGnCugJrIzSPup5StS7eTCQr6LdeeavRXMaYO7xFt1P3u6RaS9FLMAjRk3xHEuZuPrUhG53bd+py4ur7+6biClnpB4khSsikyt93HVcAEl4pLORvUZXxaGZ7jsGlrDldVcC15Qxid09qhlecUdX/kghCyCcovDhU2sFE8DvxspTOmZ3AEgijLaQmEJZtP/wT86fQ1ok+ZtBJTTDGYY+J6mb4GEabqt7KEee3tUYE/M64Rg2zxF6q1jDrDzNbLc2kXUgjY7bdfn1hC4b5eFYw7E23Y6FUZbCxPf34Sy5puYSqjtQyr4lqwvbQUNKr0OyFZkrTKxUMWkoDyKpc9VJ06uBrUDl7UNEVqa5rQdwR0IpSMoFbR5rA4YDug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 07 Oct 2026 21:18:46 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> In damon_split_region_at(), we copy the entire probe_hits[] and
> last_probe_hits[] arrays of DAMON_MAX_PROBES size. However it is possible
> that the number of probes installed is less than DAMON_MAX_PROBES, in which
> case one or more iterations is/are redundant. To remedy this, iterate over
> only as many times as the number of installed probes. To do so, accept a
> struct damon_ctx pointer in damon_split_region_at(), and update all
> invocations of the function to pass the new argument.
> 
> Also update damon_test_split_at() and damos_test_filter_out() in
> core-kunit.h to supply a context to function paths that call
> damon_split_region_at().
> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
> ---
>  mm/damon/core.c             | 42 +++++++++++++++++---------------
>  mm/damon/tests/core-kunit.h | 48 ++++++++++++++++++++++++++++++-------
>  2 files changed, 63 insertions(+), 27 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index a3af5ee685e1..025df4d19e20 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2049,8 +2049,8 @@ static unsigned long damon_region_sz_limit(struct damon_ctx *ctx)
>  	return sz;
>  }
>  
> -static int damon_split_region_at(struct damon_target *t,
> -				  struct damon_region *r, unsigned long sz_r);
> +static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
> +				 struct damon_region *r, unsigned long sz_r);
>  
>  /*
>   * damon_apply_min_nr_regions() - Make effect of min_nr_regions parameter.
> @@ -2075,7 +2075,7 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
>  	damon_for_each_target(t, ctx) {
>  		damon_for_each_region_safe(r, next, t) {
>  			while (damon_sz_region(r) > max_region_sz) {
> -				if (damon_split_region_at(t, r, max_region_sz))
> +				if (damon_split_region_at(ctx, t, r, max_region_sz))
>  					goto out;
>  				r = damon_next_region(r);
>  			}
> @@ -2494,9 +2494,9 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
>   *
>   * Return: true if the region should be skipped, false otherwise.
>   */
> -static bool damos_skip_charged_region(struct damon_target *t,
> -		struct damon_region *r, struct damos *s,
> -		unsigned long min_region_sz)
> +static bool damos_skip_charged_region(struct damon_ctx *ctx, struct damon_target *t,
> +				      struct damon_region *r, struct damos *s,
> +				      unsigned long min_region_sz)
>  {
>  	struct damos_quota *quota = &s->quota;
>  	unsigned long sz_to_skip;
> @@ -2523,7 +2523,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
>  				}
>  				sz_to_skip = min_region_sz;
>  			}
> -			damon_split_region_at(t, r, sz_to_skip);
> +			damon_split_region_at(ctx, t, r, sz_to_skip);
>  			skip = true;
>  		}
>  	}
> @@ -2581,12 +2581,12 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
>  		}
>  		/* start before the range and overlap */
>  		if (r->ar.start < start) {
> -			damon_split_region_at(t, r, start - r->ar.start);
> +			damon_split_region_at(ctx, t, r, start - r->ar.start);
>  			matched = false;
>  			break;
>  		}
>  		/* start inside the range */
> -		damon_split_region_at(t, r, end - r->ar.start);
> +		damon_split_region_at(ctx, t, r, end - r->ar.start);
>  		matched = true;
>  		break;
>  	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
> @@ -2779,7 +2779,7 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
>  					c->min_region_sz);
>  			if (!sz)
>  				goto update_stat;
> -			if (damon_split_region_at(t, r, sz))
> +			if (damon_split_region_at(c, t, r, sz))
>  				goto update_stat;
>  		}
>  		if (damos_core_filter_out(c, t, r, s))
> @@ -2826,7 +2826,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
>  		if (damos_quota_is_full(quota, c->min_region_sz))
>  			continue;
>  
> -		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
> +		if (damos_skip_charged_region(c, t, r, s, c->min_region_sz))
>  			continue;
>  
>  		if (s->max_nr_snapshots &&
> @@ -3643,10 +3643,12 @@ static void damon_verify_split_region_at(struct damon_region *r,
>   *
>   * Return: 0 on success, negative error code otherwise.
>   */
> -static int damon_split_region_at(struct damon_target *t,
> -				  struct damon_region *r, unsigned long sz_r)
> +static int damon_split_region_at(struct damon_ctx *ctx, struct damon_target *t,
> +				 struct damon_region *r, unsigned long sz_r)
>  {
>  	struct damon_region *new;
> +	struct damon_probe *p;
> +	int i;
>  
>  	damon_verify_split_region_at(r, sz_r);
>  	new = damon_new_region(r->ar.start + sz_r, r->ar.end);
> @@ -3658,11 +3660,13 @@ static int damon_split_region_at(struct damon_target *t,
>  	new->age = r->age;
>  	new->last_nr_accesses = r->last_nr_accesses;
>  	new->nr_accesses = r->nr_accesses;
> -	/* todo: do this for only installed probes */
> -	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
> -	memcpy(new->last_probe_hits, r->last_probe_hits,
> -			sizeof(r->last_probe_hits));
>  
> +	i = 0;
> +	damon_for_each_probe(p, ctx) {
> +		new->probe_hits[i] = r->probe_hits[i];
> +		new->last_probe_hits[i] = r->last_probe_hits[i];
> +		++i;
> +	}
>  	damon_insert_region(new, r, damon_next_region(r), t);
>  	return 0;
>  }
> @@ -3691,7 +3695,7 @@ static void damon_split_regions_of(struct damon_ctx *ctx,
>  			if (sz_sub == 0 || sz_sub >= sz_region)
>  				continue;
>  
> -			damon_split_region_at(t, r, sz_sub);
> +			damon_split_region_at(ctx, t, r, sz_sub);
>  			sz_region = sz_sub;
>  		}
>  	}
> @@ -3723,7 +3727,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
>  			if (sz_sub == 0 || sz_sub >= sz_region)
>  				continue;
>  
> -			damon_split_region_at(t, r, sz_sub);
> +			damon_split_region_at(ctx, t, r, sz_sub);
>  		}
>  	}
>  }
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 5ad89c1d9fc2..e02604c7e0bc 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -141,12 +141,26 @@ static void damon_test_split_at(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r, *r_new;
> +	struct damon_ctx *ctx;
> +	struct damon_probe *p;
>  
> +	p = damon_new_probe();
> +	if (!p)
> +		kunit_skip(test, "probe alloc fail");
> +	ctx = damon_new_ctx();
> +	if (!ctx) {
> +		damon_destroy_probe(p);
> +		kunit_skip(test, "context alloc fail");
> +	}
> +	damon_add_probe(ctx, p);
>  	t = damon_new_target();
> -	if (!t)
> +	if (!t) {
> +		damon_destroy_ctx(ctx);
>  		kunit_skip(test, "target alloc fail");
> +	}
>  	r = damon_new_region(0, 100);
>  	if (!r) {
> +		damon_destroy_ctx(ctx);
>  		damon_free_target(t);
>  		kunit_skip(test, "region alloc fail");
>  	}
> @@ -156,7 +170,7 @@ static void damon_test_split_at(struct kunit *test)
>  	r->last_probe_hits[0] = 3;
>  	r->age = 10;
>  	damon_add_region(r, t);
> -	damon_split_region_at(t, r, 25);
> +	damon_split_region_at(ctx, t, r, 25);
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
>  	if (damon_nr_regions(t) != 2)
>  		goto out;
> @@ -176,6 +190,7 @@ static void damon_test_split_at(struct kunit *test)
>  
>  out:
>  	damon_free_target(t);
> +	damon_destroy_ctx(ctx);
>  }
>  
>  static void damon_test_merge_two(struct kunit *test)
> @@ -1648,19 +1663,35 @@ static void damos_test_filter_out(struct kunit *test)
>  	struct damon_target *t;
>  	struct damon_region *r, *r2;
>  	struct damos_filter *f;
> +	struct damon_ctx *ctx;
> +	struct damon_probe *p;
> +
> +	p = damon_new_probe();
> +	if (!p)
> +		kunit_skip(test, "probe alloc fail");
> +	ctx = damon_new_ctx();
> +	if (!ctx) {
> +		damon_destroy_probe(p);
> +		kunit_skip(test, "context alloc fail");
> +	}
> +	damon_add_probe(ctx, p);
>  
>  	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
> -	if (!f)
> +	if (!f) {
> +		damon_destroy_ctx(ctx);
>  		kunit_skip(test, "filter alloc fail");
> +	}
>  	f->addr_range = (struct damon_addr_range){.start = 2, .end = 6};
>  
>  	t = damon_new_target();
>  	if (!t) {
> +		damon_destroy_ctx(ctx);
>  		damos_destroy_filter(f);
>  		kunit_skip(test, "target alloc fail");
>  	}
>  	r = damon_new_region(3, 5);
>  	if (!r) {
> +		damon_destroy_ctx(ctx);
>  		damos_destroy_filter(f);
>  		damon_free_target(t);
>  		kunit_skip(test, "region alloc fail");
> @@ -1668,27 +1699,27 @@ static void damos_test_filter_out(struct kunit *test)
>  	damon_add_region(r, t);
>  
>  	/* region in the range */
> -	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
> +	KUNIT_EXPECT_TRUE(test, damos_filter_match(ctx, t, r, f, 1));
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region before the range */
>  	r->ar.start = 1;
>  	r->ar.end = 2;
>  	KUNIT_EXPECT_FALSE(test,
> -			damos_filter_match(NULL, t, r, f, 1));
> +			damos_filter_match(ctx, t, r, f, 1));
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region after the range */
>  	r->ar.start = 6;
>  	r->ar.end = 8;
>  	KUNIT_EXPECT_FALSE(test,
> -			damos_filter_match(NULL, t, r, f, 1));
> +			damos_filter_match(ctx, t, r, f, 1));
>  	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
>  
>  	/* region started before the range */
>  	r->ar.start = 1;
>  	r->ar.end = 4;
> -	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
> +	KUNIT_EXPECT_FALSE(test, damos_filter_match(ctx, t, r, f, 1));
>  	/* filter should have split the region */
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
> @@ -1704,7 +1735,7 @@ static void damos_test_filter_out(struct kunit *test)
>  	r->ar.start = 2;
>  	r->ar.end = 8;
>  	KUNIT_EXPECT_TRUE(test,
> -			damos_filter_match(NULL, t, r, f, 1));
> +			damos_filter_match(ctx, t, r, f, 1));
>  	/* filter should have split the region */
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
> @@ -1717,6 +1748,7 @@ static void damos_test_filter_out(struct kunit *test)
>  	damon_destroy_region(r2, t);
>  
>  out:
> +	damon_destroy_ctx(ctx);
>  	damon_free_target(t);
>  	damos_free_filter(f);
>  }
> -- 
> 2.55.0

Thank you for your patches!  LGTM.

Reviewed-by: Liew Rui Yan <aethernet65535@gmail.com>

Best regards,
Rui Yan

