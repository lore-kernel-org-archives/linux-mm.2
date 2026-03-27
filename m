Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C2210BA431
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:04:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B6A6B00BE; Fri, 27 Mar 2026 03:04:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C196B00BF; Fri, 27 Mar 2026 03:04:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A476B00C0; Fri, 27 Mar 2026 03:04:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DC3E6B00BE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:04:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C267F1B96C7
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:04:06 +0000 (UTC)
X-FDA: 84590953692.04.9901652
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id DC3681C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:04:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BmzG14Rx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595044; a=rsa-sha256;
	cv=none;
	b=6YtOjvM0kkyNcAVg4aWZ3cZAsbM6FO24umzGzbUmg8o5qICyhndP0S9z5/ZLwr2zkA/fsl
	zX/uocW2z3qDXA8jjhHP6JxDBLa4XfeeCgIu73FBBkAQZumWMsqAUriuEnl+rwSKsQ2bnT
	mjXKttLkwP3qrIU7OZYjP7GcE23AEYs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BmzG14Rx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJl7pDB0zfAjMt3lYRTDqHzTHNLB8U/7DHfn4W8ruLQ=;
	b=ii0V4Vxx0H+CuXfdqMcIQLXnqS1yp3+XZu8OHrKrkEFhjLaX5ZDJIIlhMYLeMlUonjSl4C
	qvgBjkNeHSDq4aEUt52NWjUlOqy7o9FE9RcSAqeYPqE2XU2dkW+o/rfQTB+eq4+LtiDwn2
	UxchWOU1/XjDY5KYJVP6hfAEOT3NShM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b0c8362d93so7608045ad.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774595043; x=1775199843; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJl7pDB0zfAjMt3lYRTDqHzTHNLB8U/7DHfn4W8ruLQ=;
        b=BmzG14RxP5A253z72JeuxShcGMI0Aw3F6TOYIO9YzDg7y+gMoro5WIH+LfOb0ucgqZ
         yUSaLgC+atycpL/Zgr3Kw5kd0LQPRjlR0TFqXxB/hc29nHekzutA0S7GbExNxiVhEpVu
         7O3Toa3Z9tXORx6d/Wl5KWAUDQgTzUE4TofIfN5u11mCo4hqiNOghIjyxWc9RyOV9z2l
         kDHfdP0K0H8y7nTAQI2MvnR+VreurWyVA3fCCP3rtdnveaCnruI50PF/q0DJEC6dn4b1
         IbLHrthqaxXfLe77Ge21mUIeGhamDpKIWTjjNGJIRNE2hcEUzGvPppYNU29eIltomuOp
         6IJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774595043; x=1775199843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EJl7pDB0zfAjMt3lYRTDqHzTHNLB8U/7DHfn4W8ruLQ=;
        b=aDvSNiPmWZulJllbaJYMr8W6ieNdFzzerBD5uwTC6gugddsAMOTJDrt6jfB5SAmCnA
         kh2bJDvfJYCOI11U6E2TxsHscXY9m6Drl6m+aCfLM4Dn/ziuA0FGabQ6D6if8c7lcQWg
         SAdmQCS2sNc9HA3Vk6lRElLcyL6NiaXyqmarkacwIcadkH0PpExa7547USLSuBnfXt/Y
         sOPq6UeU/m/t+tsxj73nrz1gb4kV7YqHQRweUrJIgDuOXfinP2IyPcVXCnFwv8JjP7n5
         kMNd4Aq0FZnjhjTexhJQIuedvx2O6IJoNNR1eABQGr456KpdMuZxDE8k5x5M2U6NYhNT
         balA==
X-Forwarded-Encrypted: i=1; AJvYcCUrDfTg9tFnEi8MWGUgFKw/KnhY1mK2oWvVmHlrAFmw7NRwTk9PRjUTpDUwT/XXj3bHZkmbICPwbQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4Z1bkZMcXjdefvLoWL8LksSeoTBLnn5esJ1ko5flqgD2aS5jj
	01yyh4gAQ4nF6v1nsp+9Yv45GWuENvz0rl79mYrlAH99A1JqcSAJH1VB
X-Gm-Gg: ATEYQzwbsSUnh9pSxDio7h4ap9pqZlJ/Hu8rQAoTe+HrU42lwCwJk84vdmT6nPSKNmj
	oAxvsQ0+cPFB+C+qx+x8qnDHca0F3rSCF/eqjWAjxjqzh0bno2jRapf8VQ2Xs6KN+oQwwHJRIJ0
	0V/Z16c5v6UBC3LT3S0Kz/cBousc2KJN1E7Oli04YwY2PvOj05IMOMhAi2Nvkn8G+Kc+U1hkRbT
	6sa25w4eCHdbzyLGJz0kV1stJuB0uhd9eV4v8M60zNOLuSAyXySKlInnp25TCvAb3XoRBwBKAkV
	AX60XQaEEPlF5p7w/zlaEe7YhEeNMyvUCOffg2G8kHQAW6FRRijkqxYekLaXalR1YqkHf7ouCO+
	und1+9BpufwXeGDDV0yoIQCf8IC6RKp1cbzNFxDGAU57o0jrbKjg3pPi5+BBmExEcKvdazh370l
	DTNdI4Z/lbefKwHKzxFG7NI1hIVXgooy6UB0gkFQ==
X-Received: by 2002:a17:903:19d0:b0:2b0:afb4:7d41 with SMTP id d9443c01a7336-2b0cdc02e54mr17965755ad.10.1774595043512;
        Fri, 27 Mar 2026 00:04:03 -0700 (PDT)
Received: from celestia ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc883c0asm53376215ad.45.2026.03.27.00.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 00:04:03 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [RFC PATCH v6] mm/damon: add synchronous commit for commit_inputs
Date: Fri, 27 Mar 2026 15:04:00 +0800
Message-ID: <20260327070400.71707-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260327062558.66392-1-aethernet65535@gmail.com>
References: <20260327062558.66392-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC3681C0003
X-Stat-Signature: hj8hg7c6rtg5cw1319hnwi9c9m9wybpx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774595044-104914
X-HE-Meta: U2FsdGVkX1/3nvh7Vm4wkv+NcparaLEi6qB8OivmlwzDOdC+WWiCYUstx0UaJx8ydB9bobVWEURXLzmwrmf371/UJE3NKfuKTjLzdKpnS8MtmjB5iSpuZBnmEk1Pj8766vFW4z9G3DRFeZg1dNH8OZGJcQg6Ocwb8L2c1zBWBYoRHEFANT8o4T80SJ5oEes+KaDU07dZEThybK19Zme/eyc6UWt8HbyZ7OIV03jeM7th4EI9HmlwkS81sjYLVZQhYDZCyjoIx27ka30Z7llx2ciP2pIgf38PnAQt+8uGvpw4DIM9zMxVstVW5X/KBmGatLWs4RuWytQj06jCsgNLrbJ8tV1HrHvsE4kc9VNjWMre2KOvWi5kbZWhAu4lI6SOIg1A0HYohUQjJFbC9M7kOGzzD2CCa7aPDzZ3gxz9mHIfegWQKKToU8TQn9CAo3cCL5uaMOz0ZeE6H+1PGucHkwmAIiMFxpl9vp3EHLuJ1BP9g29taamlUYRGjyaR2/aYHqEbuF2vdLX3JgJJvq5F9HanFHLrxELmhmsDW/NypE3zbSA3GbiwlnJoWtcPg6GPhnPdsG33UeLOmyHBfMBA/pMwy7vML+0jcTh9yDOj6U+UvPbwc/rxXqwV8IVDyWe+YuBukIK77jZBdTArzDYrsHYRhX4bu9lcpxeHFL9pS9xN5PdVCBZjOLFzNrqj6mTlFmIUxDVXwUEnZsDDpaGattG8XlV9tfkGI9rcocUP5cKC8CYMp8Jreg+Yuq+7vsEoJ4DVGpieUM9Q/S9Y/z4rE2QrRxsWesqj7oBvQhBrhU3hSIhCQQtWvm6iifWBldYKMyth66nPL5oTk6sUAIKQhM3BwV4VHuMP8FuaDSXI5zCQ4jvPEM5sUPS5CIOgFD8gfCTUG5KhURI3r+vczE7W5iZX3Aku3ZpopbtiKXYtASTM9TFdLwZ4bc8eaNifKU6d1oZlPiDhJbXPDK6KkS5
 iqf9bQ1e
 kUqqoYNg+Rzz7JIqH9ODZQYgK9YsaWWulbApnkdNiXL2Jzr9aWsI3ozIO/taJApMDlLIfuZQtMVbXbvCuw8EIi0UYINDBBGrXFlpq4+gGrlhOzP8yHSiNUHNv/RdBu+mpcWgL+E9CO68lmuIzWB5b5c4b4SqVx6aiWhjeCibYbKLMxeVtWFBWrzaWKhPeTG1xaBLp6IY3VaiW2XLq25/HyGmaiky+2WDXsfeFjRBfXI1PzXcHyiDiIWFkLripVu0JnsHf7gfov6EOpfTMC+oL/xWOh/Mct4Mfo9OHsovpTu+QWsDgTCTnqY/gyHHK0lUCUdj9DntnPYd8TfXYYCLxGuWSif1tKGlAjcMKbE4qO4a0MZIM254A41A0LmwWsqXk4tCjqFuIXmb/YnDyk4/v5pSDo/4ugJ78zjis+OPNFAhshKTGd5Y160p/i3tx9AbvxgprCgksWnCs0PSOTbAgCOn5t58Zn9KTo8nWrQwCGoBx6lqPs+6N8qF0hjB8vlpRqiOBfIUbW8bugsHByJkirTDt9+MQt+azM2aKMbQEcx1IjyXhVQ7vrgmuzxfjuP7+n1iw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260327062558.66392-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 405545126e8bb145d7fb1fbb4f36016bc1f6c42c
Author: Liew Rui Yan <aethernet65535@gmail.com>
Date:   Fri Mar 27 06:25:58 2026 +0000

mm/damon: add synchronous commit for commit_inputs

This commit modifies the commit_inputs_store() callback to use damon_call()
for synchronously committing parameters in the kdamond thread's context.
This change aims to ensure validation errors are returned immediately to
userspace.

Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..453033f3cb3e 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c

[ ... ]

> @@ -349,18 +348,47 @@ static int damon_lru_sort_apply_parameters(void)
>  	return err;
>  }
>  
> -static int damon_lru_sort_handle_commit_inputs(void)
> +static int damon_lru_sort_commit_inputs_fn(void *arg)
> +{
> +	return damon_lru_sort_apply_parameters();
> +}
> +
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_lru_sort_commit_inputs_fn,
> +		.repeat = false,
> +	};

[ ... ]

> +	err = damon_call(ctx, &control);
> +
> +	return control.return_code;
>  }

If damon_call() fails, for example returning -EINVAL when kdamond is not
running, err is set but the error code is never returned or checked.

Will this cause the sysfs write to incorrectly succeed by returning the
default control.return_code of 0?

Should it return err if err is non-zero, or control.return_code otherwise?

> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..03e3300ce607 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c

[ ... ]

> +static int damon_reclaim_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	bool commit_inputs_request;
>  	int err;
> +	struct damon_call_control control = {
> +		.fn = damon_reclaim_commit_inputs_fn,
> +		.repeat = false,
> +	};

[ ... ]

> +	err = damon_call(ctx, &control);
> +
> +	return control.return_code;
>  }

Does this function have the same issue where the return value of
damon_call() is ignored?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260327062558.66392-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260327062558.66392-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

