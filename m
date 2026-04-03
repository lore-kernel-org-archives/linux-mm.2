Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FD8E7E342
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 08:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBF856B0005; Fri,  3 Apr 2026 04:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70F46B0089; Fri,  3 Apr 2026 04:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86896B008A; Fri,  3 Apr 2026 04:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6EB16B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 04:33:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F42D13B285
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:33:26 +0000 (UTC)
X-FDA: 84616580412.17.808273B
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id A97F0100009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:33:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGfVv50a;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775205204; a=rsa-sha256;
	cv=none;
	b=W+VXtRlkf5duRrdBsNBNbXXZN8Ky9m4nR5nyaI0ncYfpVI70/cXc/WuVHs/oLzTj7d0Ay8
	Or8WiqWcIVvqEkqf0350+U3+4+tiuzOeEWEQqwhiMvGhLWnn8pJ4trjEI56ReG0hv072Rh
	qho5wMdnBBh6K2MzPLrn9lPA772p81Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775205204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6bWdEuhaXAxPBHptBvlmQsfSLSE+qPqms2g9XHTbnI=;
	b=gnojoTsJBY06g8dnW3xWZbLn3pA4emozzmQ4jDP2P4zAZ5GBmpEL5PE/49L6Z8B+TwPnHg
	4HzBa7+9SM5gK4eIITH49DFe6SEKi/JFSzm14dP3NZAwxgk0L8ngZHfKqiZ0i86g9PWlpp
	au9Zy2l6kDK4srIAjC4SQwwTD7uHr/Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CGfVv50a;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c76b95e652bso545262a12.3
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 01:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775205203; x=1775810003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6bWdEuhaXAxPBHptBvlmQsfSLSE+qPqms2g9XHTbnI=;
        b=CGfVv50aitm5aQzXGF8kUS6L9xmVtygQf2fOcXZLou2Ip9EZhNEAjYtRpVnU+SIJfz
         zscRS5+PpcByr/ySMuOC1Bcttg5GFvvs00eZTKOYddY+LLubsLyK8f1whoCURPz7aMgY
         ZR7SgrtHDr18dq7w2hFDM1OLQEovQOBv80Judkcrt8MTVF0+vVpJZ7vozyq6+GAqpquJ
         y0e9Ftk8FDUKzOhBfApqDHqXHJJpOTFOY/wleqaRq7RLBazVoFzqK12tnpRDfGeYsxOV
         Hs/egNZGSQOGIHl9IbHg2a3jVvnQT+enp8oOfF7kQ+2h/xVSZ4pkmZiU9zzPx9jSOW9T
         d2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775205203; x=1775810003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s6bWdEuhaXAxPBHptBvlmQsfSLSE+qPqms2g9XHTbnI=;
        b=iKS05Q7LOf5p67+7Vag2I6H7u6y8WmgPza7oYU3aMdR9kpSthw5uCY9CJPMR7imLXs
         2Pjv/URFB3bOGRvIC4Cfw4++VmTPczPFak2o/tLhLE+vG1+HKrOsDguRuLwsDnGaOA1W
         Oj1ZrQ7FXADiy+EZjM/mGX/MPHyygYaBo2W3bu5eRbnpAPdBFcBSeT3M06mDJYdsFMiZ
         9qILykLTuhjHPmzCAT/NAoy9a/YHH7bB40VRPdcVaOXj4H9BjR7kOdfKRnCEqGnhqsdo
         2+X++phzh99Rzc8/rFSecrC3WJT+iy8uScVmXE3Yoz8nvoA4tkthx2TfsUxWummIcm23
         mjGg==
X-Forwarded-Encrypted: i=1; AJvYcCX3xBV7eluHZ41R8qFwvT8GUtbDWwcHNKJ/Cve20I+Vz3xs3vV3Sn3Xh756yRF0VjKAGRawJpjAOg==@kvack.org
X-Gm-Message-State: AOJu0YwZO/FdMlmPRYMAwLekfVZeXhzLFfT6x/WdjZ0cn3VNJl8o/Us7
	VKjwkWnJrNVf5bjOXpGOdciccrtda/zpQv3MNwoYL0QrV1mN8GEnfFDy
X-Gm-Gg: AeBDiesy7rwGo5oXrpNDYAS1KWN5K9RQjZicgrk4A6kNPoswIXdUR9s0OP5suXE8n3c
	g2g+EWv4UZthGzmuBlmjuqn1PynbL9mITb2avuf9QZRJgNBjeMIqUpvlHz/BLZYTuWuxtLmIaj6
	fj1Nf4L5lqg5ohbZzgkrpemD/tZwgI8OTP0k0khD05UffRxM/7I7OeqyZK6Dt5G0JtOwcPjiqTr
	eSjiVjDLkDsxScWPSph3ZDrr+5uYGL5xBp2C3idntlzp0vrzfn8hvK2F3xHeerekcEKCQtxmjE9
	wCJMox/vkKu4/mC1qYFRa0mIUK5UaJULX2fDe1t5hguADvguzJStdFYNLFg3AUZGkDQTCYmi7ry
	BjRG+yfZrd9bY94NIvxSI1FX65iSLWIrFO02RjMzoMq/kLOpp07tju0gl8bu/2kjgle5IXF3fNa
	bVTfN2SXpulzRJ7rSKuSLtBP1prD/gWUGfYBsgG8gNG3dzEwba2YI=
X-Received: by 2002:a17:903:1aae:b0:2b0:4a57:e480 with SMTP id d9443c01a7336-2b2817da2c3mr25467465ad.45.1775205203471;
        Fri, 03 Apr 2026 01:33:23 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27472d646sm51793865ad.5.2026.04.03.01.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 01:33:23 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	stable@vger.kernel.org,
	yanquanmin1@huawei.com
Subject: Re: (sashiko review) [PATCH v3 2/2] mm/damon/reclaim: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 16:33:22 +0800
Message-ID: <20260403083322.5852-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260403052837.58063-3-aethernet65535@gmail.com>
References: <20260403052837.58063-3-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A97F0100009
X-Stat-Signature: jso6zhwe4ryznbk8dbcjfep8kaktpheq
X-HE-Tag: 1775205204-16347
X-HE-Meta: U2FsdGVkX1/kP+DZyjuYs33K/y+Pm0HW+9eqfHrX0fWwI0pK+LR/Xk3hESTclYQt3fX67cI3K/TA8i2u4QIKJfzmR7NYY93jU5uoqw4noIeDYn6Z86bzzlB7RM0nJvbA2nMFEJPPmbLJNXLyF5j1c/PyH5SCz+zzQLd9rU78mZaGI+IeX9c2Qh9+nM2hSXnV+Pc2faBjZsIhbRUIc1uvhbiNYSXIN3yG0GAdCeG2wHnamjv/GgxpEIty+omgHhQ8boTn/Zqm5NtEAb30dVBRCyp1/2lqsYchsveCGBqEpCE9t8JcEj+w+qSAqgbGzNeSptOjtk9C7W10cEP+kXtXukrhIf5Dc/QQxZ0lxx5/E7MxE1sBv7FjJgzzMI2AqkfOW5Nsr9/C19nNL7J2TyxXzlXInzsi31TidK4c0qjCX8YT1BS35P1oIXNzcJmnrwFqGKVBtCEspfo5ggVRzwUhqWxOh5y1xkBMmTi0HTDMX+jVxW/UvV859IL5Yzn3GfYag1HeIhNY5DeCvtA9PDfMZJzFGRCTtCi9jQcVoMTbRegQw1UutFvc8F3lwrLwVF/P3tbVRZAOSILdVZNEHf9fMyOBd1kgRIRKOg417JKk0khWhG873n25yiO6wugFDvjk9t7pe9tbWos8yIIwGwQ3WO/VFzknJ/F5yhxOsXr7u3YuKKy57cipD6P2KCyRQPcC88mY7CFVJvmyPGPL+OjmGut8bXX8/7kAhiVS18RaB8FZMFPgJNrUvaAec9kIml+8OnGAXWHwjztcHv9iEe7FczFOEapzaeS7Yjm0MsuNOfC1Dxt3iT5eeQka7V+d7stgeLgn/7w50QPCGrmPbMCUOrlJGUk3OaDF0u5TJD1DXXbpYCqjq1i9gXOdSKoyvM2xDPJmViRP2AXncZXDq7X4pMyuZbCBVfqxR1P1l8xLVyuiOCT5KNC+pqEfMIq5bnNcWzNDhvqHKSIyXSKHY1c
 rBYX+SL/
 DKTxKOi+g8nOTbIvk5wpFfs8E4cVDCQCHuCJCao/aoZ755hdfRdNGeFani3zMBpUlnxrzmrN7Wvj3u1sclxlZ4FDOOh+7L9P72ZCZ5gWW3KheU1v+DXT0ESDc5I3L0E8IUZ34O4llsmjPneLZW29EUwIstNo4ArT0zDWonaCpvC3uGc5h2t6v15AszJxtHA4PtckVrWwdxafJmmuUh07unX41caiO3xQAMZzy7eDMXLk87WbzuPKCwe6UVzsXlRrGnwn16DTBkaA8ZsXSfe+7uEPYuXTAI2SuAD+nZbkbVanodRFNt1S1mPQDgkFP0bP/fc4THiDSxxOz0fB6qu+LbNgEs0l2LmQxoAuQoLGUssG0cnQJqWTV0lVc/LN+v3nOaEA6e1Zlc53fUFNagpf5d2lCvx+ot/Ft/jG9vcy51RuMBy8/ennYLatlBXmVF/HPcRLnJurh6diZQshB5zYhsPUuQJHmT3h4Stuo4bp9Fy06b4ZHN203rXj0ThcAxpyYUByXp4zT07nCxxu6WTJBzREXkcoBsdd7xiFF/WY/DB+vQ0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260403052837.58063-3-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 28b6de17622e17753e02ff606413650ad898f09d
Author: Liew Rui Yan <aethernet65535@gmail.com>

mm/damon/reclaim: validate min_region_size to be power of 2

This commit adds an early check in damon_reclaim_apply_parameters() to
validate min_region_sz and return -EINVAL if it is not a power-of-2.
This prevents kdamond from unexpectedly terminating due to late
validation failures.

> The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
> However, if an invalid input is provided via the DAMON_RECLAIM interface,
> the validation failure occurs too late, causing kdamond to terminate
> unexpectedly.

Is the root cause of this unexpected termination in damon_commit_ctx()
itself?

Looking at damon_commit_ctx() in mm/damon/core.c, it sets
dst->maybe_corrupted = true before running the is_power_of_2() check:

damon_commit_ctx()
    dst->maybe_corrupted = true;
    if (!is_power_of_2(src->min_region_sz))
        return -EINVAL;

If the check fails, it correctly returns -EINVAL but incorrectly leaves the
running context permanently marked as corrupted.  When kdamond_fn()
observes ctx->maybe_corrupted is true, it explicitly breaks its main loop,
terminating the thread.

Would it be safer to fix this regression by validating inputs before
mutating the maybe_corrupted state in damon_commit_ctx(), so that other
callers remain protected from unexpected daemon-crashing denial-of-service?

Also, does the DAMON sysfs interface bypass this min_region_sz validation,
allowing kdamond to run with invalid alignment?

In mm/damon/sysfs.c, a user can set addr_unit to a non-power-of-2 value via
the sysfs file. When turning DAMON on:

damon_sysfs_turn_damon_on()
  -> damon_sysfs_build_ctx()
    -> damon_sysfs_apply_inputs()

The code calculates ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1)
but lacks the is_power_of_2() safeguard. It then calls damon_start() directly,
bypassing damon_commit_ctx() entirely.

Since DAMON heavily relies on ALIGN() and ALIGN_DOWN() macros with
min_region_sz, could a non-power-of-2 value produce corrupted mathematical
masks, leading to overlapping bounds and memory corruption?

> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da147786583..2747eef5919d1 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
>  	param_ctx->addr_unit = addr_unit;
>  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>  
> +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
>  	if (!damon_reclaim_mon_attrs.aggr_interval) {
>  		err = -EINVAL;
>  		goto out;
>  	}

Can concurrent modifications of damon_reclaim_mon_attrs.aggr_interval via
sysfs cause a division by zero oops?

The global parameter is checked here, but it can be concurrently modified by
root without subsystem-level locks.

Subsequently, the function calls damon_reclaim_new_scheme() which executes:

damon_reclaim_new_scheme()
    .min_age_region = min_age / damon_reclaim_mon_attrs.aggr_interval;

If a concurrent sysfs write sets the interval to 0 immediately after the
check, could this re-fetch trigger an unhandled divide error?

Further down in damon_reclaim_apply_parameters(), the code calls:

    err = damon_set_region_biggest_system_ram_default(param_target,
                    &monitor_region_start,
                    &monitor_region_end,
                    ...);

Can a data race on monitor_region_start and monitor_region_end bypass
bounds checking?

These global variables are exported as module parameters and can be
concurrently written by userspace.

When passed to damon_set_region_biggest_system_ram_default(), the function
validates the pointers:

damon_set_region_biggest_system_ram_default()
    if (*start > *end)
        return -EINVAL;

Without READ_ONCE() wrappers, could these values be modified right after
the validation, satisfying the forbidden state where *start > *end?

If this happens, the invalid boundaries are blindly assigned to addr_range.
When the region is later sized, damon_sz_region() calculates
r->ar.end - r->ar.start, resulting in a massive underflowed unsigned long.

Could this cause an unbounded OOM loop inside kdamond_fn(), where the
region split condition while (damon_sz_region(r) > max_region_sz) executes
infinitely and constantly allocates new structures?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260403052837.58063-3-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260403052837.58063-3-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

