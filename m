Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5498FCA100B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B57C6B0006; Wed,  3 Sep 2025 03:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D5C6B0007; Wed,  3 Sep 2025 03:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2FB6B0008; Wed,  3 Sep 2025 03:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 398BE6B0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:00:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D59D21A0503
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:00:42 +0000 (UTC)
X-FDA: 83847041124.06.F57D33D
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id EDD83A0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:00:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fq0unwHs;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756882841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SeVcETCZnlVYVPJLuLayVDeCpLMJgj8fEd5DO+wa8w=;
	b=KbF7UyhUoqHlJNrkJT/VU0zPB3vf0U3+jaQa4Ef51c5Ue7MpkYcm72m0e3h7ihs+mxunzf
	LVX66FapcGzo14rSfD+WKAQ4LlTKj2GdycX8vpmcwn+hl5sheUISETxmP9RoCctACq6zpM
	jnsAEloXvosphSMC1NSaQX8Wy2E9mwQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Fq0unwHs;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756882841; a=rsa-sha256;
	cv=none;
	b=7WvfTwFi9RHFvOPZ8BCirTMOA9pPblGtLAxQNVOfZWrAxrgEu2v4opWMPv5JNVcpox5431
	TMhL5lQi2RF4+N9fywlWVg8hfzTd14OG6sIiHKDYoQzZUSlUEyfO2UwYJRcs/lbMM7ujDR
	DL/V717bKLyetPpBbJ8FWN5nc6v/oWc=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso38425015e9.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756882839; x=1757487639; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4SeVcETCZnlVYVPJLuLayVDeCpLMJgj8fEd5DO+wa8w=;
        b=Fq0unwHsqlcPrHHZT1qnCeIZj+J5tbQAktNlzU7eoK9V9kC/BycB+x4L/x6hJlJf1V
         Kvew9PZVjSv6v7KEACIxSvoJEwYJEX4ABythZrrQ9WPmuo4Ox74dPAdXYMCsbvzLZUaq
         fd1+KT5tIFByjkAYjBj8tVqd6IGhFzSJdmPhCwjGozqFVucapj1W/Bjr2AovFw1+CNU/
         3JIh+Cp3WGx2WDsLEqFjIKfSKDVAB50jGC8W01BOauL8xEFFhEeCFsZ4K//IPGZUjfsA
         N8/YQ296jqSFwNMO2c69Z3bov0Qwp3GcymxgYYgTZ4MYrwgZK0VJ1TeEUgp1xG/H2HI9
         LCHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756882839; x=1757487639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SeVcETCZnlVYVPJLuLayVDeCpLMJgj8fEd5DO+wa8w=;
        b=p/FxAd6pWl/+wj6Rq/BasCwF8pzp5+Di61MIcA2tvWOWA0yWJxspV+2VX6T9HYKz8M
         f7KZUK/rfZkdOf0P+qcJ5/bAkxOn+3ylxiCcsyaVHf+l8rTO+BAxZG/QBvzPWT2L6fCJ
         c5/TWXCRImQpDg23aM4yiit2DosXK7QNxQiGDMucchgR1yO9dNQ7/3mL30VpxQ1Nhuxs
         /vMayh9AeISV+oE11/TsbcPW46wYvxEA3kWDvhN6aYbUgGxm1iZ7tSY3uNAjHqf9PK84
         SPs/nRO1s3ArXdY9JyTQC2rJ51PbcF4lzxdi49bHa9JkBMvtv0dlW4JJX3aZuVfvbh6E
         7bgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ8Mqp5iDUe5GsEg9qNtWLopd5m9kF59QjFcT4nESzynOS/G9I2tjK4Sa35d0jBEBB6IIFVmV/xg==@kvack.org
X-Gm-Message-State: AOJu0YwlqITry2kkB57a1NCdZgkfBug+Mf+WW0L+W7rWxj1O4RTH5wzU
	qp1ESGKRaTYfPMme6z0oVntiMKMXWLTWW7jiUevmndpvC66HM3dX24Yie4+/3oijK1c=
X-Gm-Gg: ASbGncv+bUlYaAO0+sO9dYGTXOui+vJ9oCM9/vU7DqIT7Jc22XChr26HUGUHaCanXDE
	HaahqQz02/eSAN2343hm/JhPfBsuQ8+wYGv/JkTwqDTrGOnAFff1/BszzuK0eh5NOn2nKKb5fjI
	+i3OG+NambDYbzopzOMDCd/cJF+X/4HNebJWLtYfCTI1OPz97T41siqWU8tq9k/MAVoSyJNVA3G
	yXcMDv3v6O6Ib4S6OwkzTR4vGsoO0Gz+KjODdvZWCEHlaAn27SQQMBVV8/8Myfc7Id5I3MmBmYL
	75wRy+Bxbx0N+1fymJRMOZr/roqHw7rf3/5DKTaLv3h7hDhVhZcqGl3k7d4L/OPwTwXJbN+aO96
	ofFFfknHGOZ+xnDmJQxPZisPxf1V/98+RBUJxf0KhtdqYoEMqAuq4y02l
X-Google-Smtp-Source: AGHT+IEoXoDchPxjlW6nm9//Q2WMCRnFI5AVjrKIHIeZDsgd4U6erHhnOiYunkXji17UofJ0tU0gOg==
X-Received: by 2002:a05:600c:35c8:b0:45b:8939:8b1c with SMTP id 5b1f17b1804b1-45b89398f5emr91109865e9.27.1756882839064;
        Wed, 03 Sep 2025 00:00:39 -0700 (PDT)
Received: from localhost (109-81-86-254.rct.o2.cz. [109.81.86.254])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6f306c22sm312469495e9.13.2025.09.03.00.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 00:00:38 -0700 (PDT)
Date: Wed, 3 Sep 2025 09:00:37 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, fengbaopeng@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, lorenzo.stoakes@oracle.com,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de, tianxiaobin@honor.com
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <aLfnldGMZkRkt8Z8@tiehlicka>
References: <aLWmf6qZHTA0hMpU@tiehlicka>
 <20250902160129.13862-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902160129.13862-1-zhongjinji@honor.com>
X-Stat-Signature: 8oo5fbu1kmzcmuiudtwquwjyiqezu49y
X-Rspam-User: 
X-Rspamd-Queue-Id: EDD83A0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756882840-726153
X-HE-Meta: U2FsdGVkX18v6Sx3NJZf6Q9AkqWIrAZKCy4XaBerIVMt52yk4FWCCudFlpOJxf8dgjapGD9vj6VDX4y/hlm7myu8tyWRKkH2iIDRllV3rn/ZlwckD47XoFe8rCl9ZdYCiYGOp5dgKS/v7bWDNzgoUWjDtmACgr/aiZbiqTCpJ3UGn+mbS7joeszW98YzkzDKlfnaqcmRr7Q+dbfu0cGjEWzohVs0QF3VaM4FsBzIJMCXrW5EKyZVFsqpZjRN04rx3lmWxd7IL7DmwvH2mlNP7AQA98WDIpC5rLU3pJ9rwUWbVpuUtpq8JUIxJoVQ9Q42fL4cUBTn6/aqVE4yZN0rgF12Tya2N9mJd5hy6JhdDgRqu3MtBTAC8GKfrf8S+5EV0t2wRl4jkOVmG9szlIRY00k+lRaP8Jw0nJkkEl+GxOP7qDEDWAjlQRHmZ8unEx4JRqVQsB+lCtaAdw2BU//n+KDxGNCf8tjFFO36AV6MzIS7IQsrMKmaY92OkFj1ctEHDvHeNOfVdnMW2lhAJA4y6RGDxuLoNjfWyNKwi4cUX+JdZydNyKUlg3qcHqimQ6TTe58TTxoSMp1fy3tCUDyiSEQF0dkHGckNirCgknvosIO5r+/zpXQ/6HvFNmhX1BFWgGPBDTnO3i+FrNv7rIRJKxnMMQpVg8JgvVjOmclEfIUTgxAJG5l3aBKFrlw1Yi9Ugc/ZcChgOGrUzJaMDTGA0jMKZ66hFRE1nT6ArTO668fZ7DRWKjzf9RPQVomDSkjFokyaumJQWaZayFRc+kryOYKP0XosOsfZbaOCszyVMpImqX5XVyln2wt3csOJ3VLQElOH9cCy+L+cmd9BzBzZMpPMhy9X5hYZ1ISWveYzdXg3AX+H5dGFnyrnWYocLS5WDh/blBC3ITYi179h5+sZl3kpoZz4ry3aj7OUJb3bY0YCAxZ2dfARBlUM8TEJxY75tr4Ch4fkWifGEunvBgZ
 muD8b7kh
 6JpejlGHD17VPgjS8byWBhj9Sd9G9tpJPNiiJuoir4649ykR8jvKC7uOyIgRqlnFIycov/tUU6+NlsKrFR0mvZGf5Odj4tSZbvdFXmOdRybKnZL6HZW5+66qVp5KnXA5fmBWHpUS3aMwIBQEHKltLcmQNfMkmhGeiX35ak8b2IorFrLu8UmmQ8ftMcne3Bg6Txwbbeg7j8Eyu+YMxiBdJfN8lV0To+s3K0UQu3QZaWE4PY1R00Z+MBPX1pY7GJcgA99AiG3HBiViwr+TmHHo0hNgf0kSn6LqiHNa/yleKYEuS7igLdIThGXv+ShkJtLrQmU7f/R07q1PsE3OzI6hW5jj/n+oMZdXQ0kinvDBnfqg1K+dl2+fc1tjgBo0AdQJJrNudyk39gMOwLu0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-09-25 00:01:29, zhongjinji wrote:
[...]
> @@ -772,12 +773,18 @@ static void mark_oom_victim(struct task_struct *tsk)
>                 mmgrab(tsk->signal->oom_mm);
> 
>         /*
> -        * Make sure that the task is woken up from uninterruptible sleep
> +        * Make sure that the process is woken up from uninterruptible sleep
>          * if it is frozen because OOM killer wouldn't be able to free
>          * any memory and livelock. freezing_slow_path will tell the freezer
> -        * that TIF_MEMDIE tasks should be ignored.
> +        * that TIF_MEMDIE thread should be ignored.
>          */
> -       __thaw_task(tsk);
> +       rcu_read_lock();
> +       for_each_thread(tsk, t) {
> +               set_tsk_thread_flag(t, TIF_MEMDIE);
> +               __thaw_task(t);
> +       }
> +       rcu_read_unlock();
> +

I would prefer if we had thaw_process() rather than open code it here.
But the implementation matches what I would expect it to do.

>         atomic_inc(&oom_victims);
>         cred = get_task_cred(tsk);
>         trace_mark_victim(tsk, cred->uid.val);

-- 
Michal Hocko
SUSE Labs

