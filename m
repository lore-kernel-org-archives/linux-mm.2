Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073E0CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EC766B017D; Fri,  8 May 2026 11:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C48E6B017F; Fri,  8 May 2026 11:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101646B0180; Fri,  8 May 2026 11:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16E86B017D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:19:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97A0A1A0176
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:19:23 +0000 (UTC)
X-FDA: 84744611406.26.98811CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CD57C100007
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:19:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3eWI000;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778253562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO6OeXLCfb5YrE2JRdGncj5JkDxWd7H/4Nk8SkrupNQ=;
	b=6JHrqO0uEXM/tjb5lv6/9427vXbzSvFkIKnggJR5sENq98Cp368k84G+5zDLwPuVm74Hze
	gz9g0Mvr02/jMX91cHCIk3GX0oR5AXjyLAas7Yb8XRt70mjGVnfgehYMJZtlDjMXi5fzae
	0wa0F+mqEcgXueZ+diddl4g5+snyT48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778253562; a=rsa-sha256;
	cv=none;
	b=NTDC44swCzn2ud+XtjdnKW351WRvLtm5uqFfcjdCxabV+93AYri4umt4U0H5WMVXsqge8B
	xo4/To1ZGFvmHd1nlr9wC4S0sYtvpbeYloYAVNKUP/LHOApPBZ/80LC+VNOtPRyr/kO68n
	0WsG4kcsE0Ug6fi4Q7ICUo78yergwnk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3eWI000;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C70B340DA3;
	Fri,  8 May 2026 15:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFF4C2BCB0;
	Fri,  8 May 2026 15:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778253560;
	bh=ayrSpaUd3jG15AzEI0ud7gi0YPalJbLy8LxSW3JuGQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b3eWI000z94PR68LyY4hiZnPifWrTnGZg74C5npodbzso+uPu8+KdyUYefGOHSkZq
	 hIY2VEi1WHHo5VHKMXIqDc82lONbUitDa3WWQ7LUGVGETrYthgUub2OzmdB3/VSKXe
	 a4pKlXM0TQ+ZS+NNDpcwrlFgPUf3IQP35rpGLgVSIG1YCmBlQytyCvdhqN/SpxYyhM
	 K6WQrtxqDIKHFMHUFPQ7y1k7ygtmP+3Oul4Q3j1XGATw6mG+i+c2mLm9zW3Rttpe4I
	 a9ofKGu0D3D0C6Np5WpwrhM2B0A0hAPxWlaEBryjE6UF7P88EHdRhtBVmrv1edDG1R
	 fFuJPcKJkJyfA==
Date: Fri, 8 May 2026 16:19:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, roman.gushchin@linux.dev, 
	inwardvessel@gmail.com, shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, 
	surenb@google.com, tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev, 
	dev.jain@arm.com, laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 1/4] psi: add psi_group_flush_stats() function
Message-ID: <af3-BqtzYTpnog-s@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <20260508150055.680136-2-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508150055.680136-2-vernon2gm@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CD57C100007
X-Stat-Signature: qtyyx87bekzz61mybjrnz6ytqp5pjogx
X-Rspam-User: 
X-HE-Tag: 1778253561-246946
X-HE-Meta: U2FsdGVkX1+UaD05EGaOtMsnrBw0qTTxdqubPUcQuCqTJsC0vZlYonlL7WBWavzh4Yaq1SXh2wPFjlCAoD9HM5p6xnF1hlbL5wqMRNm06BmdOwOkLfO60ryQGCR7c9AFcwe6cLsMDVxdJNja+HLTGXTBkMYpMF8GhWGwfAffHKbtW/n5YRweR0u7mE8Wi2JiRVEsSxhFucce3n7cUUCXTUBgDssnGmnVpVVDYwb6KVcNt4DpbDoIa4Rt5kW/yL8tUnCwp0eC7DGobh7oW4tfawJZbfjoTPka+n271BwNMPqHK4NJ80qKBWG34SrSG+ucuCffAkxX/0+fufGPDq9gGD6ifYHt/TL++obe66mdO47mtmtyuXJD7KO+7fd4q1kBF2YP8T9/Yw/I5nFriK/wQRto9tRTMf5WgttSxeJqXP0llQ5cJHUu4VTibbgFmkjbdA33YJR47KDL3ygPJYXpuRyzZ9tDh/6yG9v8kRlQNs+2zxMBHTtVVQWVCb9f1pjUTSAp+tc57PfLTsCY4lhO26esq+pdrABNHIRybehY32iS8k303y/olBc3/GT0Ie5bbQM/zRJqKWGQYwFH6VHpiHr8w/wC+KoTHQF4ct/u9BamWpJfrXyWWaWc0BG33eAmAHqPV4SK8kRj9GUX+3WdlZozbMemszLpuNLUn8Xq57+kkhrLIRcnyz9JzWjlomIVXkhKENgBeni7+4F1seEFN/g87kUBtUZfqE/LBTXzSkgqnR+eW0fmNwrjsGYd9eKkeAwSZos0Pyq/pj0hzo9iCtY9+OvJyEhOCFXst2vQAnd5IP3NeLP5IgiAXY/DT+COh9BNMxpoe0a/xeHbGF0QfYm3/HIxt4aW27IW0Erv/utpiYnzaVymDiUAWBYsO82q2E1Au2VrkfvlxUWjkcKvbOSNOlFPNkHiqHR8+bVxBjs7ga/aYHZgmZRD8k5cfHKpG8FULhdKaKSl3EsGjlz
 sI7+gf6p
 Rw48hZ6DgoLyckrxih2NkhYsPaLKoWMdfTGVOdz62S4osEaidf5hBTUgWUGZ6/fRr8UW5crA7dtn6/z/BF5dgTEFdLHE6omiRv9IfU3qBmEn8q7f1KUUomUCRcX0LqZlD1td8CuXMCLe/aL1yXJgs5WrtQ3LEG9U5IsMGLRLnY8ClBeYCFqnU26iLSlGBnZLDyGZTAFa4Um/z0fTWPgMWv4jwTy+WjNPTEQiYZwX7NOlPhPpNAgotUinB693PVFMxTd7Gu1jNTqgzihqDS+fyZ4Yf2rMItFb+oXVZHaA+7KlquOt/uo58CghDOPNluldqRdMgRPTehF8YDxipW05pdEL04MCG/QM/7TPxMMmeRtR91KnA/ttCEBuXtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 11:00:52PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Add psi_group_flush_stats() function to prepare for the subsequent
> mthp_ext ebpf program.

This isn't a great commit message, you're just saying you're adding a function
then what you plan to use it for, not anything about the why of adding it.

>
> no function changes.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  include/linux/psi.h |  1 +
>  kernel/sched/psi.c  | 34 ++++++++++++++++++++++++++--------
>  2 files changed, 27 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/psi.h b/include/linux/psi.h
> index e0745873e3f2..7b4fd8190810 100644
> --- a/include/linux/psi.h
> +++ b/include/linux/psi.h
> @@ -22,6 +22,7 @@ void psi_init(void);
>  void psi_memstall_enter(unsigned long *flags);
>  void psi_memstall_leave(unsigned long *flags);
>
> +void psi_group_flush_stats(struct psi_group *group);

Feels a bit iffy, exporting an internal management function?

>  int psi_show(struct seq_file *s, struct psi_group *group, enum psi_res res);
>  struct psi_trigger *psi_trigger_create(struct psi_group *group, char *buf,
>  				       enum psi_res res, struct file *file,
> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> index d9c9d9480a45..76ffad90b0b5 100644
> --- a/kernel/sched/psi.c
> +++ b/kernel/sched/psi.c
> @@ -1242,11 +1242,35 @@ void psi_cgroup_restart(struct psi_group *group)
>  }
>  #endif /* CONFIG_CGROUPS */
>
> +/*
> + * __psi_group_flush_stats - flush the total stall time of a psi group
> + * @group: psi group to flush
> + */
> +static void __psi_group_flush_stats(struct psi_group *group)
> +{
> +	u64 now;
> +
> +	/* Update averages before reporting them */
> +	mutex_lock(&group->avgs_lock);
> +	now = sched_clock();
> +	collect_percpu_times(group, PSI_AVGS, NULL);
> +	if (now >= group->avg_next_update)
> +		group->avg_next_update = update_averages(group, now);
> +	mutex_unlock(&group->avgs_lock);

If we do need to factor this out, maybe worth making the mutex lock/unlock a
guard(mutex)(&group->avgs_lock) instead?

> +}
> +
> +void psi_group_flush_stats(struct psi_group *group)
> +{
> +	if (static_branch_likely(&psi_disabled))
> +		return;

Is it actually likely if you're calling this function?

And the caller doesn't care even if PSI is disabled?

> +
> +	__psi_group_flush_stats(group);
> +}
> +
>  int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
>  {
>  	bool only_full = false;
>  	int full;
> -	u64 now;
>
>  	if (static_branch_likely(&psi_disabled))
>  		return -EOPNOTSUPP;
> @@ -1256,13 +1280,7 @@ int psi_show(struct seq_file *m, struct psi_group *group, enum psi_res res)
>  		return -EOPNOTSUPP;
>  #endif
>
> -	/* Update averages before reporting them */
> -	mutex_lock(&group->avgs_lock);
> -	now = sched_clock();
> -	collect_percpu_times(group, PSI_AVGS, NULL);
> -	if (now >= group->avg_next_update)
> -		group->avg_next_update = update_averages(group, now);
> -	mutex_unlock(&group->avgs_lock);
> +	__psi_group_flush_stats(group);
>
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  	only_full = res == PSI_IRQ;
> --
> 2.53.0
>

