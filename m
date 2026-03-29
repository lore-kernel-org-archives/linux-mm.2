Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CBBF3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 09:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4F36B0005; Sun, 29 Mar 2026 05:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E756B0095; Sun, 29 Mar 2026 05:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D2B6B0005; Sun, 29 Mar 2026 05:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D27086B0005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 05:56:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84991160456
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:56:07 +0000 (UTC)
X-FDA: 84598644774.04.02BF2E0
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id B06764000B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:56:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=srlPc7wM;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774778165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0Sqb6Fhd08Evxd/ft0GWEl2Yd/g++AIRyWxcaAdZr0=;
	b=w15+VM9Y5ijQEhgwxElKAwZ4Tysdlh8JHThyu3ScRII+mxf3fVNDwd5rDeg9ExPn84LSzs
	H99PI7d8LMT/aBSO29cpVDMsCyEB2hE5K/9XDdtalnpb+Anv83kknwF1Cq6Banh+jmDGvu
	2M/fxn6iDum7nLmJeHsicSD6U3D3rLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774778165; a=rsa-sha256;
	cv=none;
	b=BXXXB6ChfsbG2/6zz1dKMure//6UcpwpnPll06Pan10bPUSkVHlYodS4CSdlwgTWwyXpyK
	2d8YjvOveUoQhXTTVZDBqVLRA/ZZnq9tAjBnpTTpqZORJylYo5OOWdlmZ1rGEjpnvPVOWr
	oYrBnS9AqJ7zUO5Nf59D+OOpa9+1LPo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=srlPc7wM;
	spf=pass (imf27.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad9a9be502so21813895ad.0
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 02:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774778164; x=1775382964; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0Sqb6Fhd08Evxd/ft0GWEl2Yd/g++AIRyWxcaAdZr0=;
        b=srlPc7wMRx2JpJ6rcbpBcVIoqC+mVUvORxFh2N0e86BofLlAOS5d0c6rzZk/zXzAih
         ElovW+8SbqcoQ8h1+rIYiiyaS8dOqGgrWYA06teD4DjzhiPrOKCesz5SXD0LKMNX+GY8
         Rz/Anih15QCT/JCfe+bVwRBXFvY/eiDjF+3LjE9gXwnAg0raRzYbPjD12pZ/NVcUoKap
         bSxwEi2YXpQFj+1E2SkbeKYt+00gp29msIUJV12H9N9skV659wg9/bHpSmKa4k8IQeZx
         BfrcH81A3WOn4BY2g0apNAdIHml6nxxSqYD1hQbjwrY6qia+dB8wp/JArrApv4oJOEMR
         PC+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774778164; x=1775382964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p0Sqb6Fhd08Evxd/ft0GWEl2Yd/g++AIRyWxcaAdZr0=;
        b=Rz4UkU1eU9rGtN/AmRdPy8tlXsT7ZmKbYt5ZZ/6zZHgSvmXP5rt2KNNX4N2TYnWvw0
         c9eJfxkCqpsDrK1ndU7DyItapLLiI9tWIffrHxNG9in7ZGj+2erUmUBABjqPgO3J1u3x
         OPiGQimdrPEth5rAOIghKrjEXhoneb3jhO4pmT5wwlWH2ycWnGQ79qaJ7cSnBUAQzdoV
         nYNUFseu1DPHzGrqFnj3vnxqIIwg4CeBymX/hmU2IrQ/E/hHaEzJiaBUPpWhzTMHQHHp
         3aHNLE+4PoM/WuawoBO07Sov87aHPUb6WLYt0NMRuZaO2MrR+irfveG8/PQajSUbtkVF
         kuXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu+gOfV0UjMZTT+n88pu0z5lkzkGGwboHUl4y+11Oj1LDK8Z/NT1PMRL8OAetahTkqaQZfDN1gOg==@kvack.org
X-Gm-Message-State: AOJu0YzG8YD9bWtwrvN0BoOAMsGTTCHDHX2bt2E3BdCVuZb9ZOX5vp+Q
	WmH4mL25D3eDGDcZhVRDYx/nRolbgCWXNPtR+q09CNp/A1GgeHkhsgIA
X-Gm-Gg: ATEYQzxlQTomOsyBKX5eErTkDu6IdUxFTzG8unEvS2OizZlxnuTzyOUw+zIlxZAXB1g
	iNTnUXTYUx0JRoF10c6fr7DwRaKW8taW2GXWt2NEXG8qCMSvGMRiRjq/iJhWM9hU74ttMt7fMXq
	D2anwk/qWzADxFex/frrXd1JC76rp5NZNlR+oBErXr5Fe5unVK10cc7/ALKpfLPPl7Jbxf3f3d2
	o/ykr4FHU8bD9AY/xOfgidOv953efnK7v387Gx0WSPdhXv9F/gvCEsiG/86UBmLlkKsF0EcPoHb
	f8hlJ/A4q+bukuXFJRpMGPgOvLmeVwPXI4bqNd4G9WpHETxqm7jFXKoQDV7Ee9JgqKqF6cCdHFE
	7p9nEI+H6/ABh5Viqtq3kfy0YR2nWTpaHqnK3oVmbdmaWwWMudjEwJTbo8ZmBQCZMBpKy7B+Hdd
	aSOIZS5TcSTnZda7/+dGfWrTSQZypsaum9M2YzmPFDYoKBn/+B5MpNBUsSdYygxA==
X-Received: by 2002:a17:902:fc85:b0:2b0:c451:ae98 with SMTP id d9443c01a7336-2b0cdcf1958mr82436185ad.43.1774778164397;
        Sun, 29 Mar 2026 02:56:04 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242642956sm48385955ad.6.2026.03.29.02.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 02:56:04 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: [PATCH v2] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 29 Mar 2026 17:56:02 +0800
Message-ID: <20260329095602.3471-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260329075415.36775-1-aethernet65535@gmail.com>
References: <20260329075415.36775-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: fqs6b8m394z7ktshwzjuetriot7ojrh4
X-Rspamd-Queue-Id: B06764000B
X-Rspam-User: 
X-HE-Tag: 1774778165-240956
X-HE-Meta: U2FsdGVkX1+Qf94qPZaEx9f5QSSRfrmDEPfNGerb2GcS/Zmcyc3cstezSCh/jsKGwPXltwEla9EfgFqrcLFacNrUI4NsVDOIWwSWqhPF25TosP02h/TZj+RpIh811pGxXrO14LkppgsFZ64GSTWyyjM3N1XM0tFZhz74SpokawB8wxr2BiJ47/pwpmq9XJx1SvCP/4usgjssTkB09XnIN4xNvGv/tIPHqOw5qlSoMP+Db1RtIr1H4MoKyTTZy8q7OMBcsP6i+9kqjq7sbnVct8uq4Q3xDSYmHS1w+bbL5fN0y4rZyTKdSbj47bekwjFuYIZypLQ470apnCA8ytPBJ7sQ1MDzsFafQFJDwbq5+XjX1ty1MIDc3fnFkcsI4AOUMo9embFOZpaw37F6Ir6i9e64poBtJ9/hCVxzB0pWNloqK5Pk89IQ1yS1cLyjRAm4elq0fqxv4wIWU2Q4c0ESPw4tbgYE4ZJUrJZcu5pej2V9ZPttPlxRKdArIE8Gd1fYfUzXkAo7KKSA/rr0qgu9OoEGA7AoQuDEX5+A9FTpa2yhI4u3E0fxjHMRymRzWTlXnl/5SfyhWA1GRKxxL6WEO6S9rRqjZd5OFUsdd0HGjNamH+5zeNO3GzaGbF6f+jmOy7zkpAe70DK2mhk3mKRN4ViPBTVDO1/2pQMwQ+C9OEblI3AQWFBDJNLkPy0g3VNFDwtMNm5EOJ4L6JH5hwSqvztECbtkaKNbIBKBlBocjmO16cBUjS8o9j4mGq2vXZiCJ+XpEyXCwqCg45QgdqEw0uKQIAhc3UV+5aNFJIMAav/eDd8dA3WEdr0tluYAwLMxQciWTdiHMV8DDynvBRE9gpn79rh3R5TH/I/cb0Zs/35PwBqmc+dZHpS+7gGKkOOoaYB6eN18Kzo2dRmy0SCXDqE80bmYcDdgxuW+1FZqpOsJxYNx3TRzFYHOf4D36qEI0nd0usSgorD3tJ8kJxp
 tertTcPK
 06KDQ5g+9G5xMJv74ar+opBia1PS+pFt+KUP5u2PbFxangmDV6qROcKyOjBjo0nTm3fzelHlbowh6CVfKRC2c4iTHyxupqUsubO1wqSxrWXm4TqT0x+r6nYSvoKTfbNcbAab+5UGkrN0C9KI/jWNS1EJWfPyYX2NnxY40yIK9PO4kl091WVCAtU6xyS7JAYOpul8MPK1JXc29yItntTyNck6YUjSk2kuXzvXxN2ZHl49ChhH5fI+Wg8a++yNHLmqQGI056uC9sLyX0A6GCsik4qp3emdpb9kBdAIpsbJ1z/9k6LtCRYa3eKNEblQfIkGwG7el4ydOe7gpzQIbY+/l+ufhRMsq3RiLXHKCLPiGNnqNC/dispzsujMGBxE9cmO0DbhRW4RNVgdGkF8UVd1eJwGi3pzKwpErEgPA2ahN/0GCqpJdRyi8Svq+zx/kUxz34z00pyiv8abfhROB+8XKbkrIYLffHCQ9A41bL1+lYHorz5bKJrbyKnWGJpAd5AWJ7epUdELnXsGhFNInBc1ZpecbwV4wWlkT1El+TD9LsyDm5yYmo4clxA3qiSfchJ4nxvOR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260329075415.36775-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 2fe50c13aebc88839d89dd3cdd5944c18c25dc9b
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon: add synchronous commit for commit_inputs

This commit modifies the commit_inputs module parameter callback to
synchronously apply parameters using damon_call() instead of relying on
asynchronous validation in the kdamond thread.

Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
[ ... ]
> @@ -349,18 +348,51 @@ static int damon_lru_sort_apply_parameters(void)
[ ... ]
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +					     const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +	};
>  
> -	if (!commit_inputs)
> +	if (!val) {
> +		commit_inputs_request = true;
> +	} else {
> +		err = kstrtobool(val, &commit_inputs_request);
> +		if (err)
> +			return err;
> +	}
>  
> -	err = damon_lru_sort_apply_parameters();
> -	commit_inputs = false;
> -	return err;
> +	if (!commit_inputs_request)
>  		return 0;
>  
> +	/*
> +	* Skip damon_call() if ctx is not initialized to avoid
> +	* NULL pointer dereference.
> +	*/
> +	if (!ctx)
> +		return -EINVAL;

Does this break module loading if commit_inputs=Y is provided as a boot
parameter or via a modprobe configuration?

During module initialization, parse_args() executes module parameter
callbacks before the module's init function runs.

Since ctx is initialized in the module's init function, won't ctx be NULL
when this callback fires, causing an -EINVAL return that aborts the
entire module load?

> +
> +	err = damon_call(ctx, &control);

Could this synchronous call break backward compatibility for userspace
scripts?

Previously, writing Y to commit_inputs while the monitor was disabled
(enabled=N) would silently succeed and apply the parameters on the next
start.

If the kdamond thread is not running, won't damon_call() detect
!damon_is_running(ctx) and return -EINVAL, causing writes to fail when
the monitor is off?

Since this is a module parameter callback, the global param_lock mutex is
held during its execution. Does calling damon_call() here cause system-wide
latency spikes?

damon_call() blocks on wait_for_completion() waiting for the kdamond thread,
which only checks its call list once per sample interval.

Will this stall all other tasks attempting to read or write built-in module
parameters for up to the duration of the DAMON sampling interval?

Is there a race condition here with the kdamond thread termination that
could result in a permanent deadlock?

When kdamond_fn() exits, it flushes pending controls and then sets
ctx->kdamond to NULL.

If a concurrent sysfs write triggers damon_call() after the controls are
flushed but before ctx->kdamond is cleared, damon_is_running(ctx) will
return true.

Will damon_call() block indefinitely on wait_for_completion() because the
thread is exiting and will never signal it, leaving the sysfs writer
permanently stuck in D state while holding the system-wide param_lock?

> +
> +	return err ? err : control.return_code;
>  }

[ ... ]
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
[ ... ]
> +static int damon_reclaim_commit_inputs_store(const char *val,
> +					    const struct kernel_param *kp)
> +{
[ ... ]
> +	/*
> +	* Skip damon_call() if ctx is not initialized to avoid
> +	* NULL pointer dereference.
> +	*/
> +	if (!ctx)
> +		return -EINVAL;
> +
> +	err = damon_call(ctx, &control);
> +
> +	return err ? err : control.return_code;
>  }

Are these same regressions present here in damon_reclaim_commit_inputs_store()
as well?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260329075415.36775-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260329075415.36775-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

