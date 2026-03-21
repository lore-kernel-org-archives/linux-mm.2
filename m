Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D451094480
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1936B6B00DA; Sat, 21 Mar 2026 13:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143066B00DB; Sat, 21 Mar 2026 13:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059A26B00DD; Sat, 21 Mar 2026 13:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9D9F6B00DA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:06:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 944A51605EC
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:06:28 +0000 (UTC)
X-FDA: 84570698856.26.41AA25B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD8AC80003
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:06:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNbvBs9E;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774112786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lbf1+ThtHrOD3BrhmZ2eOBQ79WRrjUJGoyo2N4t3x0g=;
	b=w+KsuSNWy737d9IV9OsOnCg8At6Fn0Y0IVqa+E6LpakY3mn4ZzEsXKuuS6pjgOtvj+/+eR
	QIU2u5Qw/UmnEj9fz/+qKgBdh+5oi3jt31b2+aQ76aI4OqZaY6aLbVhJ7Ta2M9+JSoXKRt
	pu6Wp16dDQk1cMZPn+M+VDfEOdU7/00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774112786; a=rsa-sha256;
	cv=none;
	b=4rXn7297+/5xkhIeIVR5k//UAEwqvWM6xko4B88v6WDXHxWp2DMNYMBZ2oALf7hibm5Wyx
	H3+Ks4TG+WuHHEGeDhPkN/tjkjSmeBgjQ24ji2OMlkJCV5d1HUHxB9sYyBwHt/grwvlgha
	StLJWI0IvlYWVcLYzqdSyLn6Lz7edN8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KNbvBs9E;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE0B840AA2;
	Sat, 21 Mar 2026 17:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C51C19421;
	Sat, 21 Mar 2026 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774112785;
	bh=0zSg2d5xtZ4jTHhBSNs+uwXApZmV7XKUPMr6CJQqSRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNbvBs9EFfhezdV8+SZlR1YUMGvLg4e+gb+pYmDE5sa/MzP1+IukHTlUCDZ/z9YED
	 7eUXn4AZDFcCi2abUF4cHQwbeXzu4Re+1rzgSSEpqjemJZCBa4EXvuKpVatnqQslIm
	 LJ56adId9xDBIBq2ZdB7MR+t/ROvSyxxZhSCFUMcRn7XtEBeTr8RBT6u7XwxdsWit0
	 UDrGW9ZJ2kAmwxn7I9IMFBmhpXGy7fR2tEbfB1eUWqfI36wBSzBZo6EGBD2GTJ9tuc
	 ciP0/K3rjKi1ovRFCLgi7qFNB45bKfbVR0ABEq41fs/sSv/thb9OWoXpNKPVvWspjE
	 lZthCnKlAxJug==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: (Sashiko) Re: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 10:06:22 -0700
Message-ID: <20260321170623.84638-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321140926.22163-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD8AC80003
X-Stat-Signature: iokpczipc85fqe6sgesgp7pn6woytpbf
X-HE-Tag: 1774112786-478537
X-HE-Meta: U2FsdGVkX180xYm+usCO+tocv3zf9JGn3HN7i2gIxX8qv2VuhyPagicapUvQMQEIQB+kdyLef8vefnHP80355l5Ff/T0hswMf1BIAGG3iwihLwy9GzetCEQwNRoTfn2iRPdHYeh9aY4bww0q1Dw4r7/NlEAGh5yj8i8SkqExUYpf9KijsOzA14LUlRutXMxGSVKFHuLsTFMXNR/OHyMgIjQhjOvvlcNS8g34+euyZ5Hm7k93qXdYLsq+iGSy3y8cb60zYSyac0G3R5VrsBtlPrbAcVXWBLqsNw4PMne88YSkuLJVVqGs5wQEAzgEXbI1k1gFMg0Qj7g13wBl2nzUd34VTSuphCTK6As6/lEWdTNSpCrgiqWlHTaOJ7RmulwEG1p/FzanvwWN+liht/g50Y1w1ngfC/h+uNlyXrLqPm06x3aKFsVHwDn5bl+lKwh5RzYZWApOMdgBjaGhPDeLkEUJ3Bd1BSenw3gwlkbyjXvZguLp5JHzi2qQujRrBtXl4dFGqU3DOz8OxlCKUc2+IGqSLiXOEGqAWh4SNZ3119fx/afkEJYiBw3I6tquPev774R5f+36g/WOWRN4uf/uiYW8wQajvAXd4zXqaOHyyWXm9YLDNl0tR8hMCAp9mROgWtM2kMVaC602meHkwJpUfQb/8rmOjeKMMeaAJQO9NLsIX6CMRgBEb3r000gcg+gX4CY976K2MVbKUVSoDRtFtlvCjSnpMW32XqMJAKnjWbsHeUkuFS09c4j48GTwLKoxJD0OOsvqvcCR15uKKDeq2+D5q8iDSsmxyKftUMS860RkCDlVZMCxLeeoKBEShpi6hY6XJDJYM1kX3vEMabee/4vlITKLdKrmpi+9pisVQDWw4bNSScnjkZBgexrFvqHca7lQZ7MCL9LyjywBHQsT0y0wX2l2nDzAKaZask/8enqhwrLBTsAriKuLhA3vjIloQbhtXTmzNTchZwRL6PL
 KlY9iJ6w
 uddmk5CdNyhHBgOFvytM9wQ+vOs5xauFsRgkbAP4Ht/Dlw1tU/3tCDJ4mo5ZSVLDgh93iTQ4yfRnAD5dpEEn98qXFPZPUJD4upbU3z/tadcVRQ9Yb0CiMX85k+UCAuhPKL/eYJTwfL360MgLbjv0XhPmXRdX2aG9zZ0HrbenzV+TKHfyZ1HrH4OBo/r706Id3d2FmludgxDno2LfqVVK4HvTb3jLlGI/7A67WLp2+bxy3dkzU98GktbpVNN1Pl15TMr2m7ve+kDq+7LCsT+USCcERIcyTMHjjYEuHVbdpeZcbSVfUo46aW58OKYtGTJQbzewWSieKjByldMNPQcTN/f/rqSs5U0eBWj0ZAz1VZv3UFrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing the discussion on the mailing list.

# review url: https://sashiko.dev/#/patchset/20260321140926.22163-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 05e8b12e4fe302bfaf2b30ee9c0d38b036fc1c5e
Author: Liew Rui Yan <aethernet65535@gmail.com>
Subject: mm/damon: add synchronous validation for commit_inputs

This commit adds synchronous validation to the sysfs commit_inputs parameter
for the DAMON lru_sort and reclaim modules. It aims to return immediate
feedback to userspace if the provided monitoring attributes are invalid,
rather than failing silently in the background.

Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index db6c67e52d2b..22136486e745 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -751,6 +751,27 @@ static bool damon_valid_intervals_goal(struct damon_attrs *attrs)
>  	return true;
>  }
>  
> +/**
> + * damon_validate_attrs() - Check if the given DAMON attributes are valid.
> + * @attrs:		attributes to be checked
> + *
> + * Return: 0 if valid, negative error code otherwise.
> + */
> +int damon_validate_attrs(struct damon_attrs *attrs)
> +{
> +	if (!damon_valid_intervals_goal(attrs))
> +		return -EINVAL;
> +	if (attrs->min_nr_regions < 3)
> +		return -EINVAL;
> +	if (attrs->min_nr_regions > attrs->max_nr_regions)
> +		return -EINVAL;
> +	if (attrs->sample_interval > attrs->aggr_interval)
> +		return -EINVAL;

Does this validation fully prevent silent asynchronous failures?

If a user writes 0 to sample_interval or aggr_interval, the check 
attrs->sample_interval > attrs->aggr_interval will pass (since 0 > 0 is
false), returning success to the shell.

Since the daemon's actual application logic requires non-zero intervals,
will this still fail silently in the background for zero values?

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(damon_validate_attrs);

Is this EXPORT_SYMBOL() necessary? 

Since both DAMON_RECLAIM and DAMON_LRU_SORT are built into the kernel and
cannot be compiled as loadable modules, does this need to be exported to the
global symbol table? None of the other DAMON core functions in this file
appear to be exported for this reason.

[ ... ]
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..883860721d3b 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
[ ... ]
> @@ -361,6 +360,39 @@ static int damon_lru_sort_handle_commit_inputs(void)
>  	return err;
>  }
>  
> +static int damon_lru_sort_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	struct damon_attrs attrs;
> +	bool yes;
> +	int err;
> +
> +	err = kstrtobool(val, &yes);
> +	if (err)
> +		return err;
> +
> +	if (commit_inputs == yes)
> +		return 0;
> +
> +	if (!yes)
> +		return 0;

If a user writes 'N' to the sysfs parameter, yes evaluates to false and this
returns success without updating commit_inputs.

If commit_inputs was previously 'Y' (waiting for kdamond to process it),
does this prevent administrators from aborting a pending parameter commit?

> +
> +	attrs = damon_lru_sort_mon_attrs;
> +	err = damon_validate_attrs(&attrs);

Will this synchronous validation reject valid configurations if
autotune_monitoring_intervals is enabled?

The actual parameter application logic in damon_lru_sort_apply_parameters()
overwrites sample_interval and aggr_interval with hardcoded defaults when
autotuning is on. 

Because this validation happens before those overrides are applied, will a
user who leaves sample_interval > aggr_interval receive a false -EINVAL error
even though the configuration would be safely overridden?

> +	if (err)
> +		return err;
> +
> +	commit_inputs = yes;
> +	return err;
> +}
[ ... ]
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..6ea44b02cc76 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
[ ... ]
> @@ -267,6 +266,39 @@ static int damon_reclaim_handle_commit_inputs(void)
>  	return err;
>  }
>  
> +static int damon_reclaim_commit_inputs_store(const char *val,
> +		const struct kernel_param *kp)
> +{
> +	struct damon_attrs attrs;
> +	bool yes;
> +	int err;
> +
> +	err = kstrtobool(val, &yes);
> +	if (err)
> +		return err;
> +
> +	if (commit_inputs == yes)
> +		return 0;
> +
> +	if (!yes)
> +		return 0;

Similar to the lru_sort module, does returning 0 here without clearing
commit_inputs prevent users from aborting a pending commit by writing 'N'?

> +
> +	attrs = damon_reclaim_mon_attrs;
> +	err = damon_validate_attrs(&attrs);
> +	if (err)
> +		return err;
> +
> +	commit_inputs = yes;
> +	return err;
> +}
[ ... ]


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260321140926.22163-1-aethernet65535@gmail.com

