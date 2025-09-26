Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA395CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 18:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEF58E0003; Fri, 26 Sep 2025 14:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B987E8E0001; Fri, 26 Sep 2025 14:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87F28E0003; Fri, 26 Sep 2025 14:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 999B68E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 14:24:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51BF6160756
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:24:43 +0000 (UTC)
X-FDA: 83932227246.05.DCBA317
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7705940008
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 18:24:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dSq//hYA";
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758911081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgMaTmzAW2IsbHkewTLtsw0ymxufZZwBMtrCMFxVR/M=;
	b=6TqEepggcHAdrq+/8z7D7BGBwTbe2GsjToYRCccGHVSFt+xrBtUbeHvr5iBnX3mYOsjzH8
	SJNrdQr1CQ5D5tAHoXvJ5eokzZuwOxVsqgaPBl/bqUYMmuPG7G5zs+yZ+MNFzQPKQtT5Nq
	dbIvS+FHUNLwgDnEGxxmXR/KtDaQREc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758911081; a=rsa-sha256;
	cv=none;
	b=hgjbzRRPfeUlt9tW61cRKIRaTgrIEbn41RJbYpyPMx1GSZxC+xSR53l1fEIWAt74cS19Ke
	WJCYuDC6lXO8AlhdeusJhhoF1A4okWNSpPxJcRS4ZdpFiW49mh63tDBOhkHcmOqD2SS8wu
	2+a+Wfjj8qINnQpYuP77/WDQR2Dn7rU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="dSq//hYA";
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d5fe46572so33507437b3.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758911080; x=1759515880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgMaTmzAW2IsbHkewTLtsw0ymxufZZwBMtrCMFxVR/M=;
        b=dSq//hYAzPge1jmCb/Ra1WoG6jFWK5IofBSSLjnkANxv+HiwQGJcKa2lpReEQZg/nL
         8koiUFjStOFnRkD6o6SpppUpYiXN6FLnUdxaoLbsET39e2gigFclxLoXNwGkelkY0LEF
         lw8w9e9tUSOy56yLGscX1hQYF2uxX7ullOa1W1nN/dyGtus9vYBQj7/2dX0IBef6InUu
         KfWuaIJ3ae1d6pf+4FK9nnrt4S5tvvn6toXi2XGLvMrEP10FMYIetcj2SwsTlQO4Ddn0
         K4yQRIHUozjmuuc9U4UWXEJqzWgw3tlV27pOwwBN6056JC6Gn+G6+dcFH9Cw2J0IcUw+
         /3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758911080; x=1759515880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgMaTmzAW2IsbHkewTLtsw0ymxufZZwBMtrCMFxVR/M=;
        b=CyzXgA9ti3aCyhuCQG0XpbW63Dg/NZAg62YFCMavJhXOudviiupVDbFMuCO4qjqL38
         zT9aLG6Rlt5CUkhNLrutUsHxMARHGTw718fFa/OInMPqkMfa7k2q2fFF+wpobDIMinML
         4gTEKdYpcSOuCaMwRwBG888JPC4JJCH1VNvY+R9chRPubp44cShKz32f+JXISkbTZD4E
         0nN6nRB3h5G5l/RT+X8PFPm0fPUOPBWQHTUXPFcaknaal9hqFmrVulX6TjnIoxhqd28s
         J7HyGi6gHpRVgeKegsjPbyNCHH0K8d7nzRhosT16v/6wSMgGEUgbTnzt0Q1FVu7vZzj1
         tcsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdaNkMbs84HV5eG+r4ouI0+tSVaiE77yX4VLGCyk7ytXGHlJhlfcLz5TSgQemHmdZFN6owoVDA0w==@kvack.org
X-Gm-Message-State: AOJu0YwCFguv+mEW5nqImQBm5+ydS2EnJ9Jkhi/XqIeAiz+U9cuDU7nM
	Msu+/HPipybY+ELTDwhh1wPiTLRw2AZD9BtuJ4kheiq98hEdw1p+pyhV
X-Gm-Gg: ASbGncuisq+wyMhMy70WB+puw3OT/u06sNDDxhT6ZOC2emo/jGqwOo2LCHP0XYW31LW
	FTGL8xmySuYVVnmWp1NmXB84NdrrUuO1w8cIsbdU3GEElJ/SIO1KJ0i+81GWCU60jDhTxmqBr7U
	pRT99N3NF7BdO7K+eUArPxY/b5ducHaAnwepNqEkvK06Km0F+wjOWn6bcxE6Me94GaGbmnLUalU
	Riwa2zPe6BcyDaWgAXnrfagKvEHqRDVVy4JwJdicHgcxPFK7TE08m3+lZWw0DXu34it5Xm3X3fs
	8A29kglotsRGUuhnrGCa4YfOXqgGfh5++eJKP4636YuPqjSAtNbBu1GtEcFnr8LBFWfF26JcAml
	QEL/9Kbco7HHpMJsL6/k+oo3pwfxyXd0svGOPg86ATK8Al7ZX0rZSUkZqTtChyRXV
X-Google-Smtp-Source: AGHT+IEFGcClrlUqJB+X7Lplug9ocElXcU3pHZrLwxFTnZfCeSZz3sfK4XzJe6Ni77BoZ8MwB3ILxg==
X-Received: by 2002:a05:690c:a083:10b0:75e:28f2:15f0 with SMTP id 00721157ae682-772213722b8mr5553137b3.6.1758911080241;
        Fri, 26 Sep 2025 11:24:40 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:46::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765c60b7a4esm12518807b3.40.2025.09.26.11.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 11:24:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/4] mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
Date: Fri, 26 Sep 2025 11:24:37 -0700
Message-ID: <20250926182438.3108364-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926175004.54610-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7705940008
X-Stat-Signature: 61km4g4undg58rnqy5zbyo41mpqjb9qa
X-Rspam-User: 
X-HE-Tag: 1758911081-171198
X-HE-Meta: U2FsdGVkX18JLpXRM7MV4+XpIXnGr7S/TbPGA4yqgPRFL62of95opHFwvNv9X4zYThtlB7C8mrDK6ssfcTm/0Y6j8wKCuVdV4ohdT7EjurqUQaIeJyf3/w8Aj+6AUVw5Rvx41/IL6BMI5zi92uZC98QgNLkew2QxFpiR3zg33y+8NEAsaxSN8YOknWit9Jbmy66bUWCpmefdojrURFE9iEV3heHYKr27zUr1cL5CgrGLtzkk0LtJO38ohtIwjpKU+CMN7EXMhy//Rj0K8Hfd/4RSNRin8KPt2tKncQn4/lDDeb+5R11OreBfSwnKLj0bRTOc42N10zA76NOBiC8jN52LOxquIrd8SlRJdaPVkIur+WOsEPgjRyh1xp/B3DtEKckcGBpiisRFfTS7Uhf9wrHRE4ck3MMDDa0G0+vE2iCkbftiTfTC7xi6zng2yT+O3jkX9za0eS1zkHJuRM5nwSTd7wusXtonbR0mvQbbZePswhV7QC18dnAITw0hmydPEZWWwioa/Nff3tdPVwxbUbJjxIU/060IpiTvuTjBP0PtVj2W/qQ3UicSp0U9+dMnYN8aFWFewFYSlmyB+N5T0kPBGlQ1o3wSwBPjb1jmoj6+TnN6nrn43sGXP2vmGMKCM8JD/LWhoBy8IInfs+5M72vKyaPbz+7bELJa40RMxvfIHvdDN3qiAedL0ylIy4GLlLk6reYLH5bCsmtSehDeG9vPHj8McGFWAigKNvXsiuTIbBpUAEujTED8Bxap/1vzVrGPfzN+rCxJC5bCxibkj6ceyNbHHr++pwCuxQsIdlAjjS3v2AvvolGbBHVc/jkqw/lGOxEwpxxb/Zkj3cquHFLK/pUzuRAd/W3gV816A6TnnS0UB+2hh0b+mU26PtXaHkqAoG9iKd/NWsDFhzShDW8Wk/dkqNX0ML9JmeWPob5AMO4nmxVDLf5onCNxsrKp7hpuuY0v0AyEM+mkjfL
 4esbbzeb
 jyXnKTs87mE0M95HxkmL+mjVowgYO0+R3Q+s/E9xgARnxCmln3LSVDEVZTw192mQsav977DdaXgUe0ae2cOtK5+3/bVfPpixKkbLxeiKjlRJY46NyENVFBenK/GV6G+w+PIH+h+xkSOZ7zokSNaDQIn5uMmXTeBo1SbCtHjis3EfR0LMcINEh66gU9yMHHNfbEOm1pmFCa2jWy9TBMcCIQ74AwkwZM5k14hVGiQIXn/DRPlmkgU4kv+/778+vNubmqd2om1BRTvrV2sNv9zrPFWJooyxF0YPMUxe0SjgyOzFn46souYvhX1Iow6yA9cl14KWlcRcwtrfjFSdUdoTT1jkXbngDbdca7Bc2JDZAqrHxfxA6VU3JMV+N7Yc7T8qVAUz2nwXyq9dDcmeShY2hTpD6yYXTY4n9W//GutpHyyuxT4uxHMyzfwILwS3Cz4edjcl27ecezh47SqO5rY+q6GB9aaYSffZPnkPCBs+X4F3YUWDf7vDx8aKxA5wU//aMCs6svi39YplMf+ILuUJqMVDvDdDX6zcbgbUADDkwNRGxPle+mUMj3uCnWJVj/us5zLKs5Xobor0/ha48+o2V25LE3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ, thank you for reviewing my patch!

> >  void page_alloc_init_cpuhp(void);
> > -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
> > +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp);
> >  void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
> >  void drain_all_pages(struct zone *zone);
> >  void drain_local_pages(struct zone *zone);
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d1d037f97c5f..77e7d9a5f149 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2561,10 +2561,10 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
> >   * Called from the vmstat counter updater to decay the PCP high.
> >   * Return whether there are addition works to do.
> >   */
> > -int decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> > +bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
> >  {
> >  	int high_min, to_drain, batch;
> > -	int todo = 0;
> > +	bool todo;
> 
> I know you and others already found 'todo' should be initialized. :)

Yes, I'll be sure to fix this in the next version! : -)

> [...]
> > diff --git a/mm/vmstat.c b/mm/vmstat.c
> > index 71cd1ceba191..1f74a3517ab2 100644
> > --- a/mm/vmstat.c
> > +++ b/mm/vmstat.c
> [...]
> > @@ -839,7 +839,7 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
> >  		if (do_pagesets) {
> >  			cond_resched();
> >  
> > -			changes += decay_pcp_high(zone, this_cpu_ptr(pcp));
> > +			changed |= decay_pcp_high(zone, this_cpu_ptr(pcp));
> 
> I'm not a fan of bit operations unless it provides clear benefits.
> What about below?
> 
>     if (decay_pcp_high(zone, this_cpu_ptr(pcp)) && !changed)
>     	changed = truee;

Here, what if I change it to just:

	if (decay_pcp_high(zone, this_cpu_ptr(pcp))
		changed = true;

Since even if changed == true already, this will be a no-op.

> Just a personal and trivial taste.  No strong opinion.  If you don't strongly
> feel my suggestion is better, please keep the original code.

I feel like if someone (you) feels like bitwise operations here makes it
less clear what the code is doing, others may feel the same way as well!
Happy to make the change to hopefully make it more easily understandable
what is happening. 

> >  #ifdef CONFIG_NUMA
> >  			/*
> >  			 * Deal with draining the remote pageset of this
> > @@ -861,13 +861,13 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
> >  			}
> >  
> >  			if (__this_cpu_dec_return(pcp->expire)) {
> > -				changes++;
> > +				changed = true;
> >  				continue;
> >  			}
> >  
> >  			if (__this_cpu_read(pcp->count)) {
> >  				drain_zone_pages(zone, this_cpu_ptr(pcp));
> > -				changes++;
> > +				changed = true;
> >  			}
> >  #endif
> >  		}
> > @@ -887,8 +887,8 @@ static int refresh_cpu_vm_stats(bool do_pagesets)
> >  		}
> >  	}
> >  
> > -	changes += fold_diff(global_zone_diff, global_node_diff);
> > -	return changes;
> > +	changed |= fold_diff(global_zone_diff, global_node_diff);
> > +	return changed;
> 
> Ditto.

Will make the same change here!

> >  }
> >  
> >  /*
> > -- 
> > 2.47.3
> 
> Other than the above trivial things, all looks good to me :)

Thanks SJ, I hope you have a great day!
Joshua

> Thanks,
> SJ

