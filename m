Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF16CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 12:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22488E0014; Tue,  9 Sep 2025 08:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC278E0001; Tue,  9 Sep 2025 08:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA458E0014; Tue,  9 Sep 2025 08:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A356C8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:00:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4FBD61DE817
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:00:05 +0000 (UTC)
X-FDA: 83869568370.30.8751F4F
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A8A64000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:00:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nb0yMEKR;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757419203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpoH6jIFgFKbyHNBMDkBh9Rdg/ma6DdBtffCZfzJ4S8=;
	b=G11amu5t1S9VmMoqz5BvLUCzqzAAktrmQfOp4VWo5dq0nmh2YmIS3eeLEiSYOjHwbMuxKt
	mgc3Di8qCA53t31pDqzEm3cjSvPAPr4vQek2cGJAcxiOQrx7Xk8K5VBQkK4zSKkX4hAZO2
	NEIcO1E2QWZFIa1iP7qzbY/z6bPsQXc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Nb0yMEKR;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757419203; a=rsa-sha256;
	cv=none;
	b=Nyse3Ww99oLBkJDhJsNYl6qkL5974dRp5Yjw519UI0s5MkQDnHkY2NF1wLy3kFJMpHrpJA
	jm/Tg2wE0NhWBbYkAFDiz6KL0fb+pTOUUaXsn/ALU6PU+gVoMSMD6lPsAQAa7eagasM+dw
	83+H4nOWcdtZ3jLhJDN/R/XYlH76DCM=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-620724883e6so9264204a12.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757419202; x=1758024002; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zpoH6jIFgFKbyHNBMDkBh9Rdg/ma6DdBtffCZfzJ4S8=;
        b=Nb0yMEKRZxaxqCa34QL2dWDN8OLOS5lx7QiXqHfWsOnhcGYlmxbhDk6FZNVBXY4wpX
         3QGHaYf/YwxjhFbU62H7tqQYw9VcwWKvazhTaSb+lJvPd/VtBdi6HN7dKYhqJLvBGkPf
         cS59z/52f8RE6DP6SfVwIdbHgYJFQ8Cls1TtC1zV6GgOYey9lSBUj3i7/j6q0pstfg+0
         +kPPDA3Bd7wXXfyazH7u8WNxOoSNr9wrehSC03n2f/6oWGnxm4J8dUkKWHh5FBD1AMwX
         pxzt4bvdwiddLwkQUCh5F2qWMWVfwuoZ3vNHHs0c+VMi93vhWYZ3HRa18ZQQZdIDWMr2
         bPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757419202; x=1758024002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpoH6jIFgFKbyHNBMDkBh9Rdg/ma6DdBtffCZfzJ4S8=;
        b=PoEuwyhIAaIM/oVo07MA4ttl5H3Sk1uzGkuhZyHEfD7+HCxJSRIVUJna2me3GLFYAf
         nfVDZ6tGi3U0MqQCK+MqNI5NC+qmkdNDLJIQLG/IiUnbzxNrsaXe1aL0Ok/8OApRzF2x
         neJG88seMwbv/cNvQD0oz0UbsOt1xuUGX141GlIsbD92xGf5c52ztXdPgi/9ChcNP5ie
         c9DGikTt6CYb/nhjkWLUHykN+QBVsPHOhq36kkt9ukEKrFfA7Vo7HrFczYLWHAhTthhy
         cbRCc9Crtgb+CWrJpEE4PLzIGPFEv+/pLpzW35u74RgsqbRv43e15EBGPPPDEbbgk3Qe
         GDNA==
X-Forwarded-Encrypted: i=1; AJvYcCXJIsTAnc3sYn1mPJEBSwZ6mwUzZ3mPUMGmdCf2gt+pS7atSEiTP9V+wjGq6fBmrRP1KQU8xak1qQ==@kvack.org
X-Gm-Message-State: AOJu0YzfCp/Xjc6LH0OMRgVl8RMOXhbM8hAEf6ndkPaq3YmawU9uMl5k
	WSQwJO6RKBLShzM9wy/oP/Yz/bjgceYNLvrmF8EA1RtLK0CWVUQ257MCJrhotj337HA=
X-Gm-Gg: ASbGnctOvg7J2hjX8TOEMNfTlkvX6KWFFEK0XZniv26wSbbwnqBeuNe/iNjdAqSylr+
	8BH2eC9Kz+p2KHPLnXmc7IGhnsR9Dp7OcApH4GVntixaDPMZw/cGWs0S4ZNg9Av7N/8xk5ICht+
	XI+HsN3Cmnpp614VnaJ/BZg4zXzInHiLVvNVE6GhVXzNAxxizrvo5OI4IjeeOZN1+0swUzUDY5z
	GBDZTYBnKjldibYw5Lf6GGxTMpGNzYkIZ8keOEMMmqu6XHM2qTPSnc4gdh+7mc0WiSK151kxjoX
	7uzdM0+p7r1T4xNEE74L1Cgep2Fl2uBeuNqNZjXX2RNf4PL/+oZkbs7AM/6yXk+9JeogT0Vsn7m
	U8jKS7VoHmOhpWAEWqQqh7iGnu5D4vvBmqQY5Le3v79Ia8xsqG8IEbuU=
X-Google-Smtp-Source: AGHT+IGsIN8mwOQ4OSrkp1PyG3QvcNyGyHSS1KrMkb8cUBEj4L750Kxz7JC7cS2+GeODNKnh3rh9wg==
X-Received: by 2002:a17:906:16c9:b0:b07:6087:6803 with SMTP id a640c23a62f3a-b0760876abdmr372197466b.21.1757419201605;
        Tue, 09 Sep 2025 05:00:01 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b042a4b3110sm2112324566b.49.2025.09.09.05.00.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 05:00:00 -0700 (PDT)
Date: Tue, 9 Sep 2025 13:59:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, feng.han@honor.com, lenb@kernel.org,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pm@vger.kernel.org, liulu.liu@honor.com,
	lorenzo.stoakes@oracle.com, pavel@kernel.org, rafael@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, surenb@google.com,
	tglx@linutronix.de
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
Message-ID: <aMAWvwQ3eJZH55mp@tiehlicka>
References: <aL_wQkwBZ7uLM2ND@tiehlicka>
 <20250909114131.13519-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909114131.13519-1-zhongjinji@honor.com>
X-Stat-Signature: 5aps189kwxzz7mne16gbcoqtiwrxgtyk
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A8A64000C
X-Rspamd-Server: rspam04
X-HE-Tag: 1757419203-130288
X-HE-Meta: U2FsdGVkX1+knB3JJKKdPCht4Mp70mvlxckGo2yAlBdlrw0zU2tvtdhyf33u1c3DNboN9ajez3Lu7iTodRa4G6UNK0grqmNytlqHtoyK+yn7WVzJj6XauT7ffGEufocMxXmtiaI3NeUXnFPTjt32PDex9i6LJe2XMZ7EQEYp50UW1kM8bJp+GCQSaTMZSRy0x+Vf8tI7D98OtiDH9+rsjIL6Gsv1xqaj+k2SBlqW72rxvLpGq6hq+CCr2eaIOOFi9uptRgC0K5YYLmp4ds9bskygKb7YKDCaXC6qdlVJ5cuBLNYN4DGA7GKliI1Hi0vLYWUopdY5JYHzzOr9FpRbPiULiG/b28kTUO4UrGZjHSGABfsrXZZmGhMawLUgmTNIHh/1KGH5NPaDp41H+PiwAagHOKxUnkXcv8VT812GpBEpk+VaK32x+8XzYtmE+c5kKfiPG9TS7P69gubTyWaOtNhjfXPxpSjryR27/O1XHK9XlIRFRZoPyLb1sJTKqj9fho8e2FxKk2gO/OkRtNNmslCJjUWKh9Nalkqh+WZ04S2lxfN3XE1JdQ+Wi076eJgGhl95IQjrpO32TIBOidnnOSIXxE7DEZp+RXXJwjqXbAMpS2xc39xOjCFF4pCuM51f8NKzKkVapZVaMNx/IAewbRLhwTrSzzeMJuHeVFs5pHKngWATyPSd3iuxXeVM9ACLwr5qfMLW6R+VU7C2thpxHaYVis2UQUNN+INh3Qg+Hr714uXUtwEgSl2EnlLSEKbXuIAfgBgSoU8g+Ct5T/fUAJLzyckcrQzPNi03N4wnIkeZs+Q629yhnRrcDDRoeC9TMB/+TvVmcV2gHkMJXASthlEADN7vMLQAqyVF3N/OFBUXxYV6bE/+p0dqNTYKUJFB6kvJKIq6uvAMyclfs9aLd3emnqzmmUQvE/dyBsPUE4tK+MsOHN/yhfeHshqjRYKMC5/hWADtLhOaaH/+Obs
 Vj32sqvi
 DRdgkiB1jmr4G0/0vTA10RA2E0T1ZyN0CW8hSHlfLXeuC/st+ixECQwVYsU90cf0Euwtqwp/DCNQt4Yq7bi+gAlqwE6UtTmlL5egSNsLaiS1xWDxddptyADQ4xiFiNuLRkVOB0DeonF4GPBXmjzADMhkbMTOOnI3qlKF+7eZSjdA6UiSx0JslPzmvZHYP8lhH1VWRpP7osAqE/HvX1QZZzgAdIpzVyd1QZlsjFxxx3GDKA0xb7BAI3WhYV+SgjAo970l+2euSZEAuybj38ZXYMQ19/LBloqODukFSEWXq8hNJW/PwCk2vNtBoB/E2ukvzqinfg8EU/0hCthd+Mh1Op7lgdc014hp8iiAx3BI2A+B8nv5PpjbedLLhChxvxZc5WGixhLuIY5rh88FQJcH0Vm0yZnTQduego1oHEPLOVmYZNCPttnWXiN5C1IAmX4kTtjfi/ojRKLl+XS1ECRkRGG/QuqSIatKObeXP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 19:41:31, zhongjinji wrote:
> > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > OOM killer is a mechanism that selects and kills processes when the system
> > > runs out of memory to reclaim resources and keep the system stable.
> > > However, the oom victim cannot terminate on its own when it is frozen,
> > > because __thaw_task() only thaws one thread of the victim, while
> > > the other threads remain in the frozen state.
> > > 
> > > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > > introduce thaw_oom_process() to properly thaw OOM victims.
> > 
> > You will need s@thaw_oom_process@thaw_processes@
> 
> The reason for using thaw_oom_process is that the TIF_MEMDIE flag of the
> thawed thread will be set, which means this function can only be used to
> thaw processes terminated by the OOM killer.

Just do not set the flag inside the function. I would even say do not
set TIF_MEMDIE to the rest of the thread group at all. More on that
below

> thaw_processes has already been defined in kernel/power/process.c.
> Would it be better to use thaw_process instead?

Sorry I meant thaw_process as thaw_processes is handling all the
processes.

> I am concerned that others might misunderstand the thaw_process function.
> thaw_process sets all threads to the TIF_MEMDIE state, so it can only be
> used to thaw processes killed by the OOM killer.

And that is the reason why it shouldn't be doing that. It should thaw
the whole thread group. That's it.
 
> If the TIF_MEMDIE flag of a thread is not set, the thread cannot be thawed
> regardless of the cgroup state.

Why would that be the case. TIF_MEMDIE should only denote the victim
should be able to access memory reserves. Why the whole thread group
needs that? While more threads could be caught in the allocation path
this is a sort of boost at best. It cannot guarantee any forward
progress and we have kept marking only the first thread that way without
any issues.

> Should we add a function to set the TIF_MEMDIE
> state for all threads, like the implementation below?
> 
> -/*
> - * thaw_oom_process - thaw the OOM victim process
> - * @p: process to be thawed
> - *
> - * Sets TIF_MEMDIE for all threads in the process group and thaws them.
> - * Threads with TIF_MEMDIE are ignored by the freezer.
> - */
> -void thaw_oom_process(struct task_struct *p)
> +void thaw_process(struct task_struct *p)
>  {
>         struct task_struct *t;
> 
>         rcu_read_lock();
>         for_each_thread(p, t) {
> -               set_tsk_thread_flag(t, TIF_MEMDIE);
>                 __thaw_task(t);
>         }
>         rcu_read_unlock();
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 52d285da5ba4..67b65b249757 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -753,6 +753,17 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
>  }
>  #endif /* CONFIG_MMU */
> 
> +void mark_oom_victim_die(struct task_struct *p)
> +{
> +       struct task_struct *t;
> +
> +       rcu_read_lock();
> +       for_each_thread(p, t) {
> +               set_tsk_thread_flag(t, TIF_MEMDIE);
> +       }
> +       rcu_read_unlock();
> +}
> +
>  /**
>   * mark_oom_victim - mark the given task as OOM victim
>   * @tsk: task to mark
> @@ -782,7 +793,8 @@ static void mark_oom_victim(struct task_struct *tsk)
>          * if it is frozen because OOM killer wouldn't be able to free
>          * any memory and livelock.
>          */
> -       thaw_oom_process(tsk);
> +       mark_oom_victim_die(tsk);
> +       thaw_process(tsk);
> 
> > I would also add the caller in this patch.
> >
> > > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > 
> > Other than that looks good to me. With the above fixed feel free to add
> > Acked-by: Michal Hocko <mhocko@suse.com>

-- 
Michal Hocko
SUSE Labs

