Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFED0CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 430C28E001F; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3933C940007; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C898E001F; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0593A8E001E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAF951DE55C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:31 +0000 (UTC)
X-FDA: 83869153662.22.FFE33D2
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0697C100002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AP2KvWMr;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp+RkJYLdE1Crh5KxPBrwpIKJDPei8RPqdYJQLcuk0c=;
	b=Sp41DdAEn3ptXWD+RCVo54QGDNVSDKrkZzISTD6sXwdaYW++mQtiTIxnCQaia5R28MGQO9
	Ue6S2AvuWW4xyZshW8iz/gts701lkg99eojgR6b6PmyAREmLB5NGCbw5TIS1WzK7EM8BZD
	jWUzSNM6BOX5hYWR79mM2eOlNNkqy9Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AP2KvWMr;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409330; a=rsa-sha256;
	cv=none;
	b=QsphumingNFh7hVj25HiHK+wjKnJzArp1z+IR/zvR+QJh/7O8oABfskOzZgGl4drLvyPKk
	loIsB2O0DOB9pj4IChXNImk4BDuCWO6YE87utGeDzNHUlB6KLgcGDnY0soFDrr/5CTlNC3
	BJqcC+vL3NYzKE20wj/UcFszZ1471jc=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b02c719a117so948980766b.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757409328; x=1758014128; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mp+RkJYLdE1Crh5KxPBrwpIKJDPei8RPqdYJQLcuk0c=;
        b=AP2KvWMr+tF5m5ax/ikBp5b+oWlCtJC000XyLiETPhFN475DDi7LS+6pCOtCapKHf3
         v4zVRMst1LmYF1GYzhNFzixAHu0k0a/p5yNLuq+kZKH3L4gq1WeuKm0C3pgrAKgtSDds
         E11xv1cCLeSYSwLKVP0YcTedZ6fQsqJAGIKTjLPvsPumpY0AhtCLSYcCQ3NBfJOeqMpl
         +G0/9Tf/FbZEJ/gPb1rRxjbCpnRaJ5GPFduLquklv54HLH5GQ3gCYUtmf5SMb4Xz3cj9
         sGIKH7kIyiuPNI4XYWikRknWNKMtaHL6W4xnM/R4LWxlo56EKTORmALGwMuOV4CfqOwy
         AclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409328; x=1758014128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mp+RkJYLdE1Crh5KxPBrwpIKJDPei8RPqdYJQLcuk0c=;
        b=hgSThrp2Emc76b7Svi8BF7q5RXO0aAjoH8Ok8u0sh8phIoV8b2LCnuATqxMTfhq6Xx
         uQdaoyV2LCYEjoEwAfBeedlIUi3Guc9ka//1RPvlHSzDK/LicM9VCLeQialgsEGYdJof
         9x6zROPHM2d3pKhK+Rij170/FdLUkgck3tjXZH50nHRoxfhWtAG5nKrhSJ4tec/UWV+6
         aA3DmwJBKXVZDBlN2wf0RIc5673ObhMbdLg72MBdNK556TJWMlEfyn/TC1d3JI5ha5DX
         QB9tP/cQfIWBBpLMWmhhWrRRGCvrGXneJnUpKHTGnIxbIuwgtD9vCwYHaN/m4+kssyaG
         8hAg==
X-Forwarded-Encrypted: i=1; AJvYcCU2pEHePOLhiGC1Rj4yeygC+GwmmJyfDr1MrtA3QdAnt8Yp0uMjmFGJUvz0/s0jmwqSg22iIjb47Q==@kvack.org
X-Gm-Message-State: AOJu0YzagseC0iHBMzkC6xyWlidIqXEY1Tix6iqaLgLGDG4WoSBE1/Ko
	QqhfQDQy7vzO4YRXd8uPT023nJ5Ic7qS0tjDyv/O9xW+9rUgRufH/bvGFcPgIIE30Mo=
X-Gm-Gg: ASbGncsYOoqKATTtLyxaic96qDaQ1jGNpjPonwY+VuADibqBXlHfhlCJ7D/1uJqC6dp
	66J+O6LZNKEcbS+BT0yF2H8bDRR6DKrd0cw66rcxuw2tkWbZjg4LDtgwbwS00+q+iWr0E5NOPEz
	iAp8/8Xum5D+LQtZEDMb5M6s+8Q1/aDJYY/NWAgwAxzTpKI0Pe89OT2EZ1IMareS/5P6EptVBmK
	WmH96Sgb8IfmVeJloYJLbt9Dcmjkqb2/XjBfCE+HEHZQ6mqSi29d2p/lxj+2sP1BWCYv7Kq+pNJ
	zKUKijgRizzrnHyMNcC359Jf0Jkm/KuUBIyRlq9l3baDyDYLVEdmV8o0tJep++NVKvJ6XRIv2kc
	IJ4nz/3bujKw7cvE/KHqLd04BGwg8tuXgcA==
X-Google-Smtp-Source: AGHT+IHUbvikxhHUTGxZjrj/IiuBOao2wd7cJlQ7Lb/Yre+ntGCxGyZdytPfWHiAGIqSj5PfiD+38Q==
X-Received: by 2002:a17:907:a03:b0:afe:be04:5ce2 with SMTP id a640c23a62f3a-b04b17c3124mr1010187766b.64.1757409328276;
        Tue, 09 Sep 2025 02:15:28 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b04190700a4sm2235051066b.63.2025.09.09.02.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:15:27 -0700 (PDT)
Date: Tue, 9 Sep 2025 11:15:26 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, lenb@kernel.org,
	rafael@kernel.org, pavel@kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
Message-ID: <aL_wLqsy7nzP_bRF@tiehlicka>
References: <20250909090659.26400-1-zhongjinji@honor.com>
 <20250909090659.26400-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909090659.26400-2-zhongjinji@honor.com>
X-Rspamd-Queue-Id: 0697C100002
X-Rspamd-Server: rspam05
X-Stat-Signature: h8h1puhujnnejpct3iwdq4jfgccqt6ek
X-Rspam-User: 
X-HE-Tag: 1757409329-678915
X-HE-Meta: U2FsdGVkX1+J3pvVKjU6ye+pq7kHzD/vZIJc8HMxUZjfEatFRuBYNFSs4HqXQ7kpSnEUaOMpAkHHUEX5/hv/7aHVStewgoXmbs0Fqz9jDErIZn3/J5osAAxDILEj3XNl0eb4Gk9p1gYyX1jLHt+UzNAcJON19wuPDh0A03UT0WrOUGO4EKjrahmLyWEUBUw8aEGjJ7qSaEw3ZIbjY7wPLVL2EfU/Cx+ktpolZ2/+fEREQRuV1h/n96FUqGJQxvpwY5Za/TqvZcsrXiGEDQrxcMiOtVJj16BS5S7j/UyVudvjFw34T3iDIwtY+KaUokmYqJDDIVAfOwE5ADrAOlApPNsqGR2oPIXQHehBPUcmxCwLoYUusukwp69SsJlCyayU9ofWUh2Xk9DQyio1jyv5c6vyUQbUqWBj6Gx0l4l5ppqAa0wVt4IKWVk4gM1xrxI0Rix9sh+3+BjgpDL+30gr6bP1vRDprf2k1TH3tmPcwX1d22UAwUuangCa4x2kgeR9d3pcbe5kMwEVx5/lh04m0HjudXjywqUyMWSzE+cxkttWRrX5agu2fABExwb+BnBUTGqztqqR1dtJqwS/RxkpQVKJon3gr3YgnnwneYehDJnY3/170r4RKATg6nTcT7pA+65eD6u2ladQKQMn2Zn8J1qBgzGep8wQV1iaaVkgBBCOY/t6IHOZuNFsyVFMHsbAkkRdpVT8H4WncjgV1biO+2nuF8sZbAaklbX3CiieHF2BZNwrmbil0MLNf5tsah2EibrvLUlZ+i1AW64vfSDuE0vQKltVznitWdKqHp8JjNtjSP03v3z28QBTgs5tq+tKsfmq9hwdDacba6liQr6HmADm9cuaRS6jfIsN5zFlZbptaSBGZ34p2PUjeKx1uiYfu1aq45E9TDz98Ob+GV0o5uQYhIqOQ1iPB4NB6SnlKAVoApvVWgPpGQKG7UDHFVqlpZxkjVFCk+Y3mbsKT2B
 XiPyRh2Y
 WkJJIsfiZMaUIEFhR5meWmFJgZwPUtVrIq7QP/TxO0ND2zCYmVjjqOnQdAXMZ5Np+APqHod4KgXcVHUkNKCz5CqDAwY38oPkx2/L3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 17:06:57, zhongjinji wrote:
> OOM killer is a mechanism that selects and kills processes when the system
> runs out of memory to reclaim resources and keep the system stable.
> However, the oom victim cannot terminate on its own when it is frozen,
> because __thaw_task() only thaws one thread of the victim, while
> the other threads remain in the frozen state.
> 
> Since __thaw_task did not fully thaw the OOM victim for self-termination,
> introduce thaw_oom_process() to properly thaw OOM victims.

You will need s@thaw_oom_process@thaw_processes@

I would also add the caller in this patch.

> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Other than that looks good to me. With the above fixed feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/freezer.h |  2 ++
>  kernel/freezer.c        | 19 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> index b303472255be..19a4b57950cd 100644
> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -47,6 +47,7 @@ extern int freeze_processes(void);
>  extern int freeze_kernel_threads(void);
>  extern void thaw_processes(void);
>  extern void thaw_kernel_threads(void);
> +extern void thaw_oom_process(struct task_struct *p);
>  
>  static inline bool try_to_freeze(void)
>  {
> @@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -ENOSYS; }
>  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
>  static inline void thaw_processes(void) {}
>  static inline void thaw_kernel_threads(void) {}
> +static inline void thaw_oom_process(struct task_struct *p) {}
>  
>  static inline bool try_to_freeze(void) { return false; }
>  
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index 6a96149aede9..17970e0be8a7 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -206,6 +206,25 @@ void __thaw_task(struct task_struct *p)
>  		wake_up_state(p, TASK_FROZEN);
>  }
>  
> +/*
> + * thaw_oom_process - thaw the OOM victim process
> + * @p: process to be thawed
> + *
> + * Sets TIF_MEMDIE for all threads in the process group and thaws them.
> + * Threads with TIF_MEMDIE are ignored by the freezer.
> + */
> +void thaw_oom_process(struct task_struct *p)
> +{
> +	struct task_struct *t;
> +
> +	rcu_read_lock();
> +	for_each_thread(p, t) {
> +		set_tsk_thread_flag(t, TIF_MEMDIE);
> +		__thaw_task(t);
> +	}
> +	rcu_read_unlock();
> +}
> +
>  /**
>   * set_freezable - make %current freezable
>   *
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

