Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEAEC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3076B008C; Tue, 11 Aug 2026 08:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D3D6B0095; Tue, 11 Aug 2026 08:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844946B0096; Tue, 11 Aug 2026 08:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5838E6B008C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:58:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1016120435
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:58:24 +0000 (UTC)
X-FDA: 85088992128.12.9F21FB2
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8FDB840005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:58:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S90NHlbP;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786453103;
	b=tup3entKrzK0ixNDJUkRw64Fp+MMsJ4YVRZv7F/8GP7yLtnpRoYMoLODfmsUNDB0MUaPIw
	iTMeMjKuWZqySVUvAMS03ZJyXoV339TEBM6vvkL8YX6Pe3VlQC+AP0bqsuGKnO41f65PJY
	Sp1MGfcgQHmjsLObT4YOMbdIKzvCn+U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=S90NHlbP;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786453103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wadoVsDULYZYXWQe9At0Wixp1lsixD+0O8hIBiY/5QA=;
	b=Q3oJWpFPJQRObEcCLJ5DWGTqHnegmpc3luhskW2whe6dFkbCpHePxZ2VC2HBAnSzO3NmXR
	PF8yOCFAutrq6IYFWBnqxIqPdTQlwgCKaspZIkyQ+bwb9eJNXIvrkzhpYv8iQMyJ/EUlhw
	mjq5UTgIcctnJ40XW2Bs9FiJcXj20pM=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so25053495e9.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786453101; x=1787057901; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wadoVsDULYZYXWQe9At0Wixp1lsixD+0O8hIBiY/5QA=;
        b=S90NHlbPY5GPBZzewKoLyuzUcL3XojvuKSl+4UH4eRVwn0L/KZ+GB/5gPd/9S1dVHs
         mq6nE7+pA3nouiVyK5KPyMRmkz5ABbZF1nZVWh1/vbeTBh7kwyczq5rL4kmmmSklqOmR
         EiH+B3rXnv3Oq/Wm/tVGUSDUq5n+G43Qeqy6U8RlUXyNfKXzMVBbQtcJlJTH11HEm/nu
         qCkzZwTcO4h/NTTmlkBaMRt2mAq/pVkTBz2KSKv6GWni8o3B39k3oAr2MrS5+dcreO5S
         3Vs6PASxizhbKJL8P4GRG7NTgypr9txxohZ0Gz8LdDN9T3I2D1Nvz99ST44O0V0UUbou
         NaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786453101; x=1787057901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wadoVsDULYZYXWQe9At0Wixp1lsixD+0O8hIBiY/5QA=;
        b=puU7y1qul4b+rQY4td0/4GX9dlhICktpOn3Lcye++49BpjRmHkUy59tK5HUrODhkLA
         fkZgGZjQ87RXejW+kRHULbXQ2Sl5DI5QfSNau71Jv8sxyS8OH9FvNL/AlOOKQ0I/H6jB
         UVkHCv2wqlj/qcim9egDc9+40U7Rtr2PbYIfGBV+x4ENyXJtrjel/AiYU7p0z4UVmnQA
         GfSSAEcAHtUYmZcAiW0pKILk8SWjJI9bB1dkURcm5I2tdA5/y8wnVmofqH343m3n1Qwp
         Ywgp/uADEMzxQ2Jo/5kDueu9Vev66l6JNpcYZrkhxiJvReqCASAdNJppEyjYk9SXMOaB
         GWOg==
X-Forwarded-Encrypted: i=1; AHgh+Rp28BQVvV1WfGTpJsYuDxyVaj+ol0epjeZ8PuaLAz+KRoFG5s3/OlEckCdfjgV3Co/ldEHgi80rGA==@kvack.org
X-Gm-Message-State: AOJu0Ywdy42zTxYIBnBc469jJlYbN4q9/9zOU2YnwdQsTg0IinP/Xcf4
	2/mKL0UnfxVah3Y9v06Zkg9iA34GxDfWR69E+5MRU2LLQWtQFWa2RUW+GKa1li+Bo1Y=
X-Gm-Gg: AR+sD13uYy22ZIVzBQQcujY4dhsaJ1oXY3+R3ci93VIrg5pII54DsVTdykT0G0pzyS+
	1wBRFNzPOm1HpI/3VKZcPbtYhvPlO0V/DrvYmvUuQxqB9xfUc/FUvQKJkK3GOQvMqL39meKYWXv
	pOXbyx+KvBEcGbRziKWYUMIeOrZygRWHSwVcIzIWU/SHiWsPoP504B4/zqUJLRGi3GQX9ycEUr0
	RdQym3cGQwZHtXF64OatM0nbv/4RCl2nzjjwUgdeS5ZrxOBNGY0iWkurM1kt3UNWpEwgUgncy6P
	NBFAEAxUaMFGLi4L1gnKz/8gyv5hB3RqezNoHe8aArZ2Vm1MOVVkaUYXPLeoUMlBLk0vGAMpJxF
	wEAH/IsKRVXkoglxpi0Jainc9xv6bv7I90U+jnWrIl5RdLVsSe7MhBc/CAAW4zct5CibaBcHGAY
	ss+K1kj9oXivzN+Kksm5NuAxuIbgqXvC9IyaaakXffmUQ8Gz3utddPQly7MN+PmfMp//BOmvY=
X-Received: by 2002:a05:600c:3114:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-4997844f628mr47773285e9.12.1786453101143;
        Tue, 11 Aug 2026 05:58:21 -0700 (PDT)
Received: from localhost (109-81-91-46.rct.o2.cz. [109.81.91.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499788fd9a4sm53399135e9.12.2026.08.11.05.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 05:58:20 -0700 (PDT)
Date: Tue, 11 Aug 2026 14:58:19 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with
 OOM_SCORE_ADJ_MAX
Message-ID: <ansca1TVAXul9lMK@tiehlicka>
References: <20260811033609.3992348-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811033609.3992348-1-ye.liu@linux.dev>
X-Rspamd-Queue-Id: 8FDB840005
X-Stat-Signature: 199zy59wt9fzfs87nsakgmoxoanxgab1
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786453102-209687
X-HE-Meta: U2FsdGVkX1+/a7lFKmjX8nrh/eP0jHQjovnsxeR0gaPVqod2q4qaFN2akiu2q28n2eAGZZDe2hKDJJcTuFPQzO+X6Hq4PrPg1v/crzzWAZRa3YOt4bWhU6kEW6NI19WJd9S7R3wj/ws7s9kyRdjMQ8st/QrsYm5fNuMRrOT1XvABe0vDtdKYIW0lxgkSRxnN96ZyrcQPNZk/dCrKqhaICtSjdLyIEh2kvHZJKiqSJqbq10ETDVYMJpJhGNBIHnRajzFMXWqrAsuUTL30ZIpOqzEsYfRhoFm2Qptk+R591aWRz6T8zYYFhL7Uo6jKRn4lslh/8iTwDmhCozzlTdBBtQUe96v6EFr+KcttLMOXZvP+QJgYvAxc6wMso8bkLZ6Pd6UUDHavZhGkkg5Ei4zLnB7f8wcniDQ5EHrlju8P2Fq/3bNkauM7I0mQP819Cg/sk29By52jKqHBMeLWta9B1GdJM9DhqdtXj5278+qhj14tZHXD64/mr+ycJw48CYga7GxCQVIt55i1p8ZqakgM4yUy0/eDGEWQEqzf1L9X5MWc/yOobjpsJbs5yTEATfyhFO2m8FRVDuYOUMicpaHo7CHTFjnVSTLUi2GoNLyh09oNszaK2TL8v9rdxZYhTZb6+fRVfAOYVNM8BBWt1xiWTZkZDchZtRRFfN1EpFBqiduAukM2cBHKutulFcuqDUeGUDDw7VY4MBySi04dW4rl6Sr+ikkF6GKbbr6AGWbI9n47JHRogZIEFjFhzZNYCb6ySLzInE/T2UTLeir6ZE1BqckTfFxPg/HWTL9FNoQymTd1WqeCwl4GfXoNfyJFSOSYae45M0+dNTBVAUcrBeqsE1usJnOFP6oyumfYct8lHRMi2eHnuGWg/x1tW9CT7zb27FOvKdr//Ctf/2QQmC/KVBq2A8nrnUli3R5yBxvRft0jD3uRQGGSeOPgMh9rirLtZPrg9z7idV/zsKXjID9
 tUlyS1gO
 2D5DV5uMaMpP92uGKLSHewZZBnFaDVHcBxjO+TJ+ISdlblN/uusYe6XvzJUcCLt2/wMPjsnaEhzbPe3jPJqm6ZG8puzEsbU3P26woS6wSBbNfzS1SlbidDEyDWnIMIbNDEy16e40Uy+FJQGTH1hda5eDQ5twe1ZZkNaV9+uJbPf4E/3UfiIV0X+VDRWNANmthwWMCfLq8qN8KWWoEQwpedkTG7J/xbPyh4hzJiaWA9uuQSnquVrcqYmpiXhAkdke8adtqViUgOuA1ryseczGJ60d37oSc55LrWce9i40TRmsPHroGWGikbl5km/gvqhxgwd4qK15AV3NNn3h2znrQbn6gMOcQZIf6gu8/Th6To1vnPN9jZZTKGPl4mc+yLnhJ3UF9eFtpJNxsjAl3MH1orSXNbiuDMmmgbyIEGTEGt6nzd8LPkGim+9xlxTswIWIqXhRofDAN2Y/ct1E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 11:36:08, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> In oom_badness() and proc_oom_score(), the oom_score_adj normalization
> uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined
> in include/uapi/linux/oom.h.  Other code in the kernel (e.g.
> fs/proc/base.c oom_adj handling) already uses OOM_SCORE_ADJ_MAX for
> the same purpose.
> 
> Replace the magic number with the macro for consistency and
> readability.  No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

I am not really sure this adds to the readability much TBH but no
fundamental objections from me.

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  fs/proc/base.c | 3 ++-
>  mm/oom_kill.c  | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 6a39de424f62..58be38942460 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>  	 * exporting for a long time so userspace might depend on it.
>  	 */
>  	if (badness != LONG_MIN)
> -		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
> +		points = (OOM_SCORE_ADJ_MAX +
> +			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
>  
>  	seq_printf(m, "%lu\n", points);
>  
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..08bff7a55db8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
>  	task_unlock(p);
>  
>  	/* Normalize to oom_score_adj units */
> -	adj *= totalpages / 1000;
> +	adj *= totalpages / OOM_SCORE_ADJ_MAX;
>  	points += adj;
>  
>  	return points;
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

