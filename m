Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3292C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57016B0207; Thu, 13 Aug 2026 04:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFFE6B0413; Thu, 13 Aug 2026 04:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1DC6B0415; Thu, 13 Aug 2026 04:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 936166B0207
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:49:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28F561A054F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:49:38 +0000 (UTC)
X-FDA: 85095622836.26.F478356
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 363E81C0008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:49:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WNA730LO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786610976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ud3PerIKkxv+VQSOh8f05M4PIN0Du2TXNILy0NYD9Lo=;
	b=P7Brwyv2HfSK63Qb3UoLSCUBj8kyU07fY82c13SekdtEUeLFJF46328jDG9Q4xmtCy6dEE
	gsoVGVrokXaDHSaJmvCV7yNiSmx26QO7Rph/RQaiXxpraJAaORhc5H/iqdLdoJIgMDUktV
	s9Uo4XZg7Lq7RkM7uUij5MQbaRcj9ds=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WNA730LO;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786610976;
	b=j/Sizr8S9nxRJ6G6PsT79Dga2Gyu/XAbxoMPffJK8nDvuU3ypU4xleNKi6SfV8XKw9sRNZ
	4cPdK7g0j/2HEN9Oc47UrCWKwv1EY3Heg3UpvhjnZXYOZ7yTVleYLFYKez4HoGH8zGtPuX
	Zr0wTrTDwHSDLzBexowasqko7ooOQuo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49558ce01afso14617715e9.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786610975; x=1787215775; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ud3PerIKkxv+VQSOh8f05M4PIN0Du2TXNILy0NYD9Lo=;
        b=WNA730LOEPVPCcQduB2+TpK0OPa76aXmpQUWKCan88euDFUoNCcmBOeqwlC6WfmGmH
         2bmCeGXWbSA3OHj5baD3VMAek32+69Z7/7lUDnm+heqIJig/gz/sQeN5PUiR4+x95Xd+
         38zDtqg/PL+HOVgpLk1w9VZ3oJbGI3Dcm3N2sgwtMkP8fx++T6wRSq3YQAAJVYhO7mFZ
         QQiqVxWAucgHaEk3Xkw2QJ7LPsgdQL975xC9Le3J6I5FoJEGWgskYDHj6ph+v3n50Xm9
         TRxNptfF31KFcTNBi0uJDFwLRlYn/7duVYu66ELiz672aGRu0p1Zlku/aSyCttWDed77
         X1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786610975; x=1787215775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ud3PerIKkxv+VQSOh8f05M4PIN0Du2TXNILy0NYD9Lo=;
        b=pgRtAzGJ1zRwyO25xE0C8OpH9vGGN7vNhV5A+5iPyMlpc8JRM0pxav9KALaED0g2i3
         YmDULsXceOTJhA+J2u7uS/icxrrA0/NfNVocckoFPtaZpS0E8wVZOKKdq9vaKOG5AMdF
         o83JfThQevBWNeDiu/jmdaAiQZwtUtgfdXNkLhhJFgTUaF6PLErMboTryFQSpLxbA7Mz
         Lxu0vC1m+b27pq4hialx4W+sUVKqcEDVPC442Ji7l82l1hC6vgeH7LEHsIQmZ7+bx2sx
         qAjD01gTGcOqdX71ryLIJD9azqwZbNAvFPZE6HcMwVIGNneOmAeyMD9yTM5Hp4yzoGfI
         Hf2w==
X-Forwarded-Encrypted: i=1; AHgh+RqK4FKQg6DHmc2j8t3WKO7pXvm8NjGpEYe+0Kh3goq0ZB4F+ROfE1hVOFDMS8xO+zZfGnXRKX5Oew==@kvack.org
X-Gm-Message-State: AOJu0Yzvfv3kzv2hIVkbLIh/W2p7h7d/pPsWwDsn75Jbi5ojEg5swmtB
	6GBuKgjEgZMbWaK6btJgpBSgosJO71izKW30GkSNoZJ+4GZ1uuGoqok25pcDaz6zdotNa63myu7
	eS8SSP5k=
X-Gm-Gg: AR+sD13kvPcvDpAHORoxsnvK/bfigsc09LO1u17sMpYgBbHj9T9rK0jrJDQn9D6S8MT
	1nrGU4CpslGAI5OGohShHxTUK0VJXY1izbGUaR9DwB2Klp5TlctmR66pN7VMl3wAzpSlYbGslS6
	zYiLpXpENaYm61bNz4hMVrUZGqyxRMMja1qaXGPZcKI/YT8qwt79M4M3eL7j9MSulTRRNJ3iUaw
	FYN7BzqvLEJSs+WWAucFR7HIKjuBq+3zuULCEAViXvzUPoAM/ZVbfy5G6vBQMS+kSbmL7952wH+
	HcfMs0gtcb2f7jNRU9jHBzFwCFNxLsFNlJTzBc97YosZir9amciquuyugITOHurl0hScsbHFe68
	zAx4V3eDG4sljvcAG0lmX6DOk0TK1maRCs8eCaRiOTw4B8MhEHain0iBenrbsmt/EiX0/35ML6m
	Ec+OcgQ29Xp/zHgKyiEqc2IkFIf0+V30EAy7TlWZJktCOEGffCnogQnkxnvhp6kjaIMlXS86A=
X-Received: by 2002:a05:600c:4e87:b0:495:4859:8f9b with SMTP id 5b1f17b1804b1-499821add3amr43510945e9.9.1786610974833;
        Thu, 13 Aug 2026 01:49:34 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981abd6desm54463045e9.0.2026.08.13.01.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:49:34 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:49:32 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: simplify remaining RCU sections with
 guard(rcu)
Message-ID: <an2FHDjYy2IFEKsr@tiehlicka>
References: <20260813032634.344946-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813032634.344946-1-ye.liu@linux.dev>
X-Rspam-User: 
X-Stat-Signature: usb1n33wmqe6tuf8irnhf5sf7b3cib6y
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 363E81C0008
X-HE-Tag: 1786610976-653852
X-HE-Meta: U2FsdGVkX1+ty9bSeoaW3/21BBJ0IlQEYE391URBXQwHZh8Obsw41N5u0af2TTE1r5InqaniMIfUpZ2o77XHPj2VnYcu5i5Bp4oDTww57iUBoZLGi3jnexQdUZFq35wiGHOw5qvlK5PQUFFS8GBoKv0xm7ZSCazV0WunLv7yY5Wv/2bsMHR/eGIUvOnH/VRdbA6N/eZBtPywtKed/9ym7fkqmjQOmj4N53rWYghFI8PnpthiJeUehp65PPD6nKbF9/3d+Glp70LxbeoQZQcdE81tkTE7bfvsHikej9BsbDB1jpUJe95nOGJ/qP4g6+kO8pBV5NcUyEb0muVs3FYuvydvDAMDHhjchrp867pAHwnEw5mVQljNnQmbVnCYURgcHtsmvzHL/1mwrHz2jpizM3gdHWvZJyeg8fmstBrAn+AAnb/Mb18oeli+2MqGxAKN6cc9yVR1XcXp6fPFB/hdsFmT0eOxHinbH2rz65TXQGJFT4HKlN8uYrfyurhsSXEl6XRoyl1SiFzWI5RV9rg8tMloaY/cGt6qRqsy5aIQ1Qp1LWahqbTwtuz5r1/EBEuE5EwZUIo5Z5XG9Zvqq33sLRFVcAXJ5+arQy85/RQy4LjkQ+Qnl/7h4pEpF+Qq4EIAF4KHmrPWn4ALecYeWWrkM50jo6kd/UVswAnx/G2dD+SBo8+ajy7+krQyOv7/v4ujwqa12+SD9nJpcDpuW/mVeXObXeEt3mjiCf0J2POHY2RYlsjaP4uNc+A37dxLOVUVt5nuIlRdL2ju5cZXY5C7gxylUIk3dpBqbn8kjSuRcYU4LDvRxBLCSUkDxcoEs8UD+DEpDV5zoDoGhVVnXhh49aRETT90Nptq9tYuZKZRulcewc+4tHjVX4TXf3qr76tIACvn36We7PA0N65YnndjExN1z57cbrPwSWolFPwBN3QzbKWpNEk8D6u3QiHoSayX+8eHJkfVu1poOfWbUCm
 dgCIqtBO
 D2zD7R6HZRIWck2HPlJs5mx1FEZCdZbb6i9R2yhGjoHQqAf3URraCoNLY5ME8wI+NWnEpgSNpqz2ILqg0/btMAyXIWdZDCKYZdEpDWSK/8UtnFwZv4z7hST/LUSH8xhDVHE15+pe4jzXugMeM2VYP/c8lRSTJEsFmTdITwxsTnDUHWk3ztT7wtcIrx2I6OTqxmzEr4EF9k06Li0GqRDWBCsifof8XYPHMP6UI1JVH2Zd56QjrY0kUDomjNMTS9K8ais08JuYiCi/Fj74wXA3RJdu267kNG7MxVpHM/2kpTpZ29Sh9vJwNOv9kMJmLIB3bZcsOzQr9S19vPMrakFh6J/nCkDfzKIWlSRB7dIgrU5qaxYvFTkTK4ZKl89m0mZbmfBj9LEE6kcBw76yODgmkY383Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 13-08-26 11:26:33, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the remaining manual rcu_read_lock()/rcu_read_unlock() pairs
> in oom_cpuset_eligible(), select_bad_process(), dump_tasks(),
> task_will_free_mem(), and __oom_kill_process() with guard(rcu)() for
> consistency and simpler control flow.

Could you use scoped_guard instead? While all these functions do not
perform anything pas the for loop this might change in the future and I
find it more obvious what the actual scope for the RCU is rather than
the full function one.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/oom_kill.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4b5c70aaece4..8bbb5ca00bb6 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -94,7 +94,7 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  	bool ret = false;
>  	const nodemask_t *mask = oc->nodemask;
>  
> -	rcu_read_lock();
> +	guard(rcu)();
>  	for_each_thread(start, tsk) {
>  		if (mask) {
>  			/*
> @@ -114,7 +114,6 @@ static bool oom_cpuset_eligible(struct task_struct *start,
>  		if (ret)
>  			break;
>  	}
> -	rcu_read_unlock();
>  
>  	return ret;
>  }
> @@ -368,11 +367,10 @@ static void select_bad_process(struct oom_control *oc)
>  	else {
>  		struct task_struct *p;
>  
> -		rcu_read_lock();
> +		guard(rcu)();
>  		for_each_process(p)
>  			if (oom_evaluate_task(p, oc))
>  				break;
> -		rcu_read_unlock();
>  	}
>  }
>  
> @@ -430,14 +428,13 @@ static void dump_tasks(struct oom_control *oc)
>  		struct task_struct *p;
>  		int i = 0;
>  
> -		rcu_read_lock();
> +		guard(rcu)();
>  		for_each_process(p) {
>  			/* Avoid potential softlockup warning */
>  			if ((++i & 1023) == 0)
>  				touch_softlockup_watchdog();
>  			dump_task(p, oc);
>  		}
> -		rcu_read_unlock();
>  	}
>  }
>  
> @@ -894,7 +891,7 @@ static bool task_will_free_mem(struct task_struct *task)
>  	 * are dying as well to make sure that a) nobody pins its mm and
>  	 * b) the task is also reapable by the oom reaper.
>  	 */
> -	rcu_read_lock();
> +	guard(rcu)();
>  	for_each_process(p) {
>  		if (!process_shares_mm(p, mm))
>  			continue;
> @@ -904,7 +901,6 @@ static bool task_will_free_mem(struct task_struct *task)
>  		if (!ret)
>  			break;
>  	}
> -	rcu_read_unlock();
>  
>  	return ret;
>  }
> @@ -960,7 +956,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  	 * That thread will now get access to memory reserves since it has a
>  	 * pending fatal signal.
>  	 */
> -	rcu_read_lock();
> +	guard(rcu)();
>  	for_each_process(p) {
>  		if (!process_shares_mm(p, mm))
>  			continue;
> @@ -982,7 +978,6 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
>  			continue;
>  		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
>  	}
> -	rcu_read_unlock();
>  
>  	if (can_oom_reap)
>  		queue_oom_reaper(victim);
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

