Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD424CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E30F8E0011; Tue,  9 Sep 2025 05:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345498E0001; Tue,  9 Sep 2025 05:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 234588E0011; Tue,  9 Sep 2025 05:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3008E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5D3211A027
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:50 +0000 (UTC)
X-FDA: 83869154460.29.1510C47
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id E7E7B180004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fnSQ2jT4;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wyBfzXieOB4BKjRhG36VNeBbb5dfQQ18kcUJJo+HeI=;
	b=WNu+GG094w5r6xqa5dOFowx5Twp5sMJlxjdNvvCkiwEvAMXwEwkvLNA3u8LSx+RuwnIKtq
	9DJnz8NudWpywAeFPETJxfv2YS9mPh9KfMbGZsPEOxzvFhVjMD8G7PsOmeyhmIpkSyTb6r
	jQRYxshCDOaFTZM6FhoAYOlegYb3el8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fnSQ2jT4;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409349; a=rsa-sha256;
	cv=none;
	b=WZFracC9FkMwYAjMyoRxTnn+qDcTbuNg0ClKgaKxOMlAr/AwhoS5rAt2xFqe8TBDJmrqtD
	MdREpLYNdzUc5/9COHbbb/dXF5mHa5gCc083eErv+fs+iBzI7T06LXVAx60fVMmElFEnz4
	K8Gwf345e80UhT5Xw40GvlXh89xAEaw=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b04271cfc3eso729381366b.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757409347; x=1758014147; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4wyBfzXieOB4BKjRhG36VNeBbb5dfQQ18kcUJJo+HeI=;
        b=fnSQ2jT4phQMGGUz9mOnZxbd9Y1uMYmQXMTYwSv1WBapj/RpV1JUzWRRuCLF87tqjH
         nEuFBCdXiPzYon8WN79RLx2NRMlxa558vxkVMcf72Zyj07OakAIDoqnJArehHpbkbc8K
         Pvqld/lG8ObhZZIR1Qs0xQJaidVW88L4QZqBoGNJ3xi9AtPEpBiaE2uiV65uoxM35pu2
         FMl3DQise+92Yd+37D9a2hvGHmnQjxAJDIdCVuysGK9k4iz115VX8/4BT2MEe41tffzI
         vp0bU1kUqYa9fH607R35f6XkBM4lDkGUxSAp3r5LUqqq924WJmooVV0aCdRXG/c7pev/
         28yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757409347; x=1758014147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wyBfzXieOB4BKjRhG36VNeBbb5dfQQ18kcUJJo+HeI=;
        b=GpvsgtVJKROXYhPuxSLfuKcjxGXDXaTj4o7nxZJ3nl647RvuQwyBAJdFpSF93jdJiO
         J4bbvWNd8QoApu7m2d/R+nGwhTJiELPoz8OBKoNioGwR69oAXvXVz3Y1wvOICfquAumY
         w0k73dGMWg/juKaJ7RlGNtt1VTYgAr42kvJD6e+aWnu5a1o52gnkdfl9AB1xWMi+u1zi
         HKo/Qrj7JdjZwpeub4Z9cJrxLk5dYuHVszVp+fHwB5p5Ff9qch2LieWZWP1rzhukkPwm
         MDFVP96KKU+gsOoUQH3b0rHwXRfkJLjW8gjO3QLpuvWt/J28kQNnx3nLuqwDOlV3muF7
         r0GA==
X-Forwarded-Encrypted: i=1; AJvYcCUJkXNEVao7yM8N2WWLSfx4PfgT7b65RQu0y5AVdQ+usaUX5quyNjwfz2IPiGjhVDWrpSVKXJ04HQ==@kvack.org
X-Gm-Message-State: AOJu0Yzojv2GyZ8e5ZRxAG+fAAADtmPM89leBBg0FbcCotvq0XVsI0DR
	rK+hxn8Q+XajB3HOLgxEp9kn7cyH0qumJP83h3PbYIeZqu9TXJfxrrisZdfsyDib1mE=
X-Gm-Gg: ASbGnctPQdK+l+mMnmuoZcQWYkUlzY9izLiJf6KROgcMXwNN9haSTVEa502aPZqpYrv
	QGajshS61xS+FP1DFdljtXMyMIwfOflDxa/Q54XcAi2VvCNs2BwWoGGqQo74CGfoRZ38k+HU56+
	DvYC96es08ct9eFaEapzqmPMoTWoSJeJxs2SADJK4e1OwjY5DwfU11ihuyuMRvHyUhp7pE1actT
	qQ9xJwbfdpCGapqIF2PtMG6FjIRmD4v+Ok14lxoo/D7QNhK5zzG75q69BNWRDDAcYj6erA1Dtrq
	39RFYioBVXf76y8473rpwyOa5Yhu7o8ZVUp8HN3+Fu0pVQW/w0Fq9lFqpHrUk6TGvHU79ge3HFy
	bgSNKoqxRzkIT8cUSNlLW1SxbwFBjI6chd02ti7IfyioYRbvxIlNTGtU=
X-Google-Smtp-Source: AGHT+IFUomSr1Edwt6q9MQDVZ8nWTr0HkefRKWchKOMD/D/mp42AWKlgEJvjm+P3vDEQZ3SMoB8W3A==
X-Received: by 2002:a17:906:9fcb:b0:af9:5ca0:e4fe with SMTP id a640c23a62f3a-b04b179c35emr1088210266b.56.1757409347400;
        Tue, 09 Sep 2025 02:15:47 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aff0681aefdsm2661611766b.8.2025.09.09.02.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 02:15:46 -0700 (PDT)
Date: Tue, 9 Sep 2025 11:15:46 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, surenb@google.com, lenb@kernel.org,
	rafael@kernel.org, pavel@kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v8 2/3] mm/oom_kill: Thaw the entire OOM victim process
Message-ID: <aL_wQkwBZ7uLM2ND@tiehlicka>
References: <20250909090659.26400-1-zhongjinji@honor.com>
 <20250909090659.26400-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909090659.26400-3-zhongjinji@honor.com>
X-Rspamd-Queue-Id: E7E7B180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4cis7yn85dthjxk7uxs8t7gy1d3hnqrj
X-HE-Tag: 1757409348-338531
X-HE-Meta: U2FsdGVkX1+w/X94MWnbeYrYunHx+MArWRBb7O908BjDFCXF9WZmvN462uj5/jtYqHFlcpLO43zjAE60nzFenwt6acfgpVXwP8CONgwJqZ58v2jbgpmYKX7zkvRiI4vCL6FU8XpEE4kfN5RZd4McnBvY50tURU6qGnLL/L1fQCgCrK9oXnLg5TweFjoRRcPPqcGEAaEQfhh/9HcK8sve+7k77EmyPTIGdUzv+x35HbHGrmpPF6DIhqbMS0/pjZgC0KKHetiQOGLFWIQ1E5Yby7yBb7opzNoNpYuLcc3IPtQMn2OIBUFIonvKFSMnwTH5zuqDp0MF0RYVtARPVu14mi7k5e7js2B0XDAtPVuJhH2CsLdV5KGwWzvr5uTxhzeihUQaDzz8CEMiutop7ljPYJ9Mvm3o19/ZaYKMxSdp/VSoKPNGbydKtRc5qPFU8tMZ8bbTZ+rFr8f/HZJfVwp+CRhw66xWqCcOmbqhY1wWx8iTdidlJpgmw+9mb7dGQX8qsP4mR/D3KZql89seeIX0V3kxrywAUQ57dboqL3BKYzsA+WNg1pBN/uH4w/uFLf77K1mxCxnpB2rpL7mPU0uFCA6/cX7eoVIYGMsVx/89igmo23Uo3qfXCt70VBX1bkiff3lejJxj1pOCtavYZHz2vfa4tI2llPoVK/wpSHPPQk2oSizalfwElTG4xZBoTJr5GHh2vlK3WhedXlajRizVvBUj+U0g09ZKB5aQQ4Nc3++ZbCLho0R1nb37bBoTaEiVQRjRely6HIt8/O20tx/bZ44uhFTeKUUP2c6TbjVUIZPM+QIzZhvkniBJNuzn5J4mKAAkX/UxUeDL1LThgvO4oNuPKs3gTgai0vMKYlrlmhKy9tQG7LjV0KyZlfRwMHOXgYTzB560gtexhTyOZCGcVj4u4FVpSexl77biL60tINzAK9vZLTM8bSHZm6yh9ve2utGpis/3aqXiS8VOi0C
 J4TE9Z8s
 oMw5v0WxxwVIvB6YQO+5APqceNmq2VCK4bBTK56MxKZL65uHB2ul5m19szCiC0A9LI1j3qaOLrQSP6/zjGX4UEf0HwzjNG36E35+dFfk8+I7ZB88CKOd3uW88eWdWA5r3np388fQxNbvKuygzI8Dp4YrVF/Mxe+tdoRy47AWokiT8KeiefA+XuEndQfPl+dXi/zpzYdeCEq+t3pgvFwX1VMyKt1ckWcSYmq6f8uLfN3q+a8XfIXiG+8njakj9ddL8nYZh512GCX1CE4R32N4LJOSj0sDLHnGyf/D5xdp5dfJG02u0sb7QQa+YBO5RYM+vQiHYnd18vP5mEC3ZLpID8pKrnxB1sgsfsJfH7iJ6NTT5vsRxWEM/2yOCNAX6JzxZ3O7b3kMuxgHdJL9ValrOhV9fvj+Ro5yaJygfmjXjn3W2K3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 17:06:58, zhongjinji wrote:
> OOM killer is a mechanism that selects and kills processes when the system
> runs out of memory to reclaim resources and keep the system stable.
> However, the oom victim cannot terminate on its own when it is frozen,
> because __thaw_task() only thaws one thread of the victim, while
> the other threads remain in the frozen state.
> 
> This change will thaw the entire victim process when OOM occurs,
> ensuring that the oom victim can terminate on its own.

fold this into patch 1.

> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> ---
>  mm/oom_kill.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..ffa50a1f0132 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -772,12 +772,11 @@ static void mark_oom_victim(struct task_struct *tsk)
>  		mmgrab(tsk->signal->oom_mm);
>  
>  	/*
> -	 * Make sure that the task is woken up from uninterruptible sleep
> +	 * Make sure that the process is woken up from uninterruptible sleep
>  	 * if it is frozen because OOM killer wouldn't be able to free
> -	 * any memory and livelock. freezing_slow_path will tell the freezer
> -	 * that TIF_MEMDIE tasks should be ignored.
> +	 * any memory and livelock.
>  	 */
> -	__thaw_task(tsk);
> +	thaw_oom_process(tsk);
>  	atomic_inc(&oom_victims);
>  	cred = get_task_cred(tsk);
>  	trace_mark_victim(tsk, cred->uid.val);
> -- 
> 2.17.1

-- 
Michal Hocko
SUSE Labs

