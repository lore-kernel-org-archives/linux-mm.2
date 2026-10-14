Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311A3CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5DC6B0092; Wed, 14 Oct 2026 07:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0973C6B0095; Wed, 14 Oct 2026 07:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7EE6B0096; Wed, 14 Oct 2026 07:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69A76B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:46:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5567214024F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:46:28 +0000 (UTC)
X-FDA: 85321054056.15.F8DF786
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7AA15A000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:46:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VokbzxfY;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791978386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8g+klyOjuE/CyZCMVGouc8UFY+Sf8KQ74E9e+yshUQ=;
	b=j/rG/h2e9VRf0MtRpoQgtSTk2UWNNdkFcL22vSp6TiVT2kiQ1DJhxST/rl16CMxF7cdmN/
	iuXZjuV0aFTI0TZ1/a11H3V6lrnjr3SeYXqosh5LkF6WSPwNTqXEi8RjrjWrEOh9xM9t3b
	X0FYSPaEMxzh92t7RBQBwxGpRqMnBLE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791978386;
	b=uAYEP5N/AVIFgfAbJX9vN4jLGPUaV2kRDNZ1e4UKFIXPbpNeEBVq6Tt1OK8oQx2juVSGku
	SsAk+ovbdxtYePlUZDt/62/ZiqReN3/JEgRTbUSTVO4HgilznSjGwraIyGF7QGujG45eB4
	Ago3/tc8+1Gd9uceU2J6ZoYScQuy3Wk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VokbzxfY;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48bbb06e746so241968f8f.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791978385; x=1792583185; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p8g+klyOjuE/CyZCMVGouc8UFY+Sf8KQ74E9e+yshUQ=;
        b=VokbzxfYxeNvog7MHBlqx4NKV9ehSu3xl0a95bceQ3NW5TXuqroyH10uVTnPB0W1re
         NcH/spqmxDPDkfgum9/VhOGq70Z6NqyXZc2IVC+ikNFN3MvxIBRvMaNnvysK+t+EfiJZ
         2kC5eK/lNk2Qb1rwPMB2CiGcOlqKW/DHDTwax06/rmJ5XFj6yG4/OQ3Oa8W34SKYHTSN
         n+6SCK8TYSjz8ASIQfGaERa5d9FVQ6UiwkF8w9OX+kvOeM5h0ymcGcP0RMo2iSeeP9Ie
         BJsNLYVy5FftdXuEoNFea1wqAES5Lmka2RrFfLGrnnI/dq4JEBK5Oc+SXaN1rWABrLBO
         PU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791978385; x=1792583185;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p8g+klyOjuE/CyZCMVGouc8UFY+Sf8KQ74E9e+yshUQ=;
        b=Ojf/46xtzzth12DgvbdSpPbqVkxnmrhF66MMwFdJpxb4VeD19Mng6UL84pZ5CDiKRV
         ZjV02zdzT+BWklzn7UnanRGr5WN9epwZA7jFykPoDV8Rilf4TcKr+ZjIwHzKkh8OoRjn
         qz5oTqHrlVRqhGyBGGC1lCjvjIU6hL2VnL7FkqgwuYIrsK7sW3BzQ9vPr0SE0z4d0B7z
         YAoZMKkxO+5LVoxJn3TXp17pt1bMz6bK9zaJPdahvzVUwplukejBih16KjxAtVSIo36i
         trO2nZ3pnK/+lo1jtxwCOJh4C9RC5GveXtcP9rhN9qLr8BnEOFtIh1udY/JvoSiFj2ne
         9Eew==
X-Forwarded-Encrypted: i=1; AKwUvBxIxNomJ9oBrQLg2VrjVxDczgWo35OLjojH4K10Y4g7D08gxD3+A6CC+uUFvd0o+YD5qmpeKo6b/w==@kvack.org
X-Gm-Message-State: AFq9FYIPESOgFJeEFoXqS3FghrMFb8RpAuGwGE2EDQudJ4XyELsxhvuA
	WEvzGgsP5QtPot99ht9GHIN8DGHF38zAQZPGVCUcfRgdLbuBJssqpmRQhz/spSexr3g=
X-Gm-Gg: AYBFou3vBLIF9D5cuGFSD4v2oll6KPzjmiPiylfj6CAq6HfjY6fyQHY2xfCZOVAg6rW
	v+he9J/XNATa/dWNvqz6F1Z2xvwW8Sg+wElTGWdJrt9057fzR1PTGUY/0dmg4uSr85dcIX0Ad2b
	JumJKYriHWoLv7e9Z4FXiPSPfBXMnPNpCakZLFq5gdBha+Ozrk01j8kioierVHqA4WC3ni17ApD
	t0Onr1nQZQO+q6pBCdaIeqYaC+GWdU9i75tOTx8wzNqifjEIllpW8M+FxFD0lI2eQvCApHL0VRR
	60GEalYxQhDrgipG9XqmZV7W0pr2wKHDb6EWI5Oh5gECuu2m5Go1YvYFrRVOqVmkpaIFadYMgQN
	Zm7/jcTDAIofTMZIaWXHOJiL0sqBBPWpz/7ojq/VoR8jzM3wHF/KF834faDrQEptohnqC6gG8hj
	ZnteEr2EVhvVVJV9uokjRtMyoXU2TW2I5o2l7/eZyA56Q+cYskBEmaqh0Wp8Oaqb00zETenf8mt
	/om7Q6Ovx4kBjym8tj6ATk=
X-Received: by 2002:a5d:43cb:0:b0:48a:f59f:8b70 with SMTP id ffacd0b85a97d-48dbaae4c6cmr24736574f8f.46.1791978385033;
        Wed, 14 Oct 2026 04:46:25 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0967affsm10286573f8f.1.2026.10.14.04.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:46:24 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:46:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as9rj8KoF1oKO8rE@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-6-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7AA15A000E
X-Rspam-User: 
X-Stat-Signature: 7w15ey6bcryqaahabmhax36ta56fqk89
X-HE-Tag: 1791978386-979380
X-HE-Meta: U2FsdGVkX19XyobZOpMkMnOodvmRKL4hjrErXNsjcgsOIq3rGsHH5SXinMuA8EU0jMl22SejSLY/4dcpByldJeLSK26+alkWHEdxL/z56Ebo6iJsU3YXPFXSTKZ18bQtDkAhnJ7acB3Hah5IcrnivbtlNDe7lI5o38zz1XiZfXvUU+QnIP0QxCLuaqXqezvB29I5Yik7vsD60xBEMHy8qS0svDs1th3LSMdjcJTldzkwoRmrMWCab301tckXJRIvk6PkYv0J7cn5QQfZahEhdWSj1g1nEP29d/yGrjFTSBI284/d6etPmQYznBTQXg1fEYtWHEENpqiHjGOpTubDHHuU4mzcEQPONaW+LvHD5+xkuQdrzRmYMeJXbd2soZtIal5LyX1ClFyyjVoqRPRA9BTv75im7Xbn1ILY58ubLnd2v1EYrZ6ybC0Y1yy1fBlUhwyMgMJQ+6hbnnO1uZCOeQP6GBC4+FCasj5MtNmAOU54gpNZPWE2z7Cb8AICK+ap8xL07TsPitQH3RE0hh7SJkNiH/Cnv9DqIYAPeLFyLkcxAul5veToOtWDqOFfmrQ3VimQlMZJPN9kV/XjFzciEL1NvODO2135VgV0zb/X0dRNvUqHEC0zESlByMRwKz9MyNMTj4X2o3aoj56sNvohftm8tdtdfvRM/iTRvHRj4LxeGgVkb+UI3P9hhOU4rCw3qtaa3JWFTIWQxwFiQ11GPlS9b9kM5eUq76hd392wQ7IvUp9JWCWyi5QowxLRKa5BPudItdzT4re01iTeEk4P/asInf4IkK1KBJvFz841QhTMqGkB6iMzUnVNdpYvMrftwp3OgtFxIDlKim9K9Ky4NAfayiZC8Hi02UBqBdaGtaQNJfu4PpMpoQQXwpkJ1o70RLLPL54s9Nfp/9vZpNGBDj96F4Yi5Umoh0xKkKAa/TqusoAO+akCxvy4eCb3BCvqTTZVTub70MmuHMDuye1
 0ptif5ey
 bUl1Nla/eWwd5gAiMRxkDCi6DyJYusOlwrrj8hXk405NnjlnGAuD8kIivUVJ/NFa83GzzEQrWPRsKgZVKc31ABJOt8Xb7tBsi9pUyztoBbFgA17AQuf1U2P0RBuZpAGYpTlxLMAqjeR/zAlqXEVeA6D3+/OAiWgF1MWYhYtt3aq7U/mN1Y2KApcylBv68LZPpluOB1j0IlhoOUYZbnhE0di3mpRiLMoiHRbduOBTd2ODBUifUnIZkW9S9S+FlUiEq6T/S1d/QA4/3yHeGSrTcMZHSrTkohCREfwk715EB+1BbitpdNBD3P83z27OOV+gNl4DnllP1KvQP9IC02Ho4wTv0u8s4lXYK4H2J/NHKUCQvnqk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
[...]
> -	/* Interrupts, kernel threads, and remote chargers stop here. */
> -	if (use_worker)
> +	/*
> +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> +	 * does not match the charged hierarchy.
> +	 */
> +	if (use_high_work) {
> +		if (!iter)
> +			return;
> +		if (allow_spinning)
> +			schedule_work(&iter->high_work);
> +		else
> +			irq_work_queue(&iter->high_irq_work);
>  		return;
> +	}
> +
> +	if (iter) {

Would it be much simpler to bail out on iter==NULL (i.e. nothing over
high limit) right after the loop?

> +		/*
> +		 * Count the full batch so reclaim work and delay penalties scale
> +		 * with the pages charged by this task.
> +		 */
> +		current->memcg_nr_pages_over_high += nr_pages;
> +		set_notify_resume(current);
> +	}
>  
>  	/*
> -	 * Reclaim is set up above to be called from the userland
> -	 * return path. But also attempt synchronous reclaim to avoid
> -	 * excessive overrun while the task is still inside the
> -	 * kernel. If this is successful, the return path will see it
> -	 * when it rechecks the overage and simply bail out.
> +	 * Earlier charges may have left high overage pending even if this charge
> +	 * found no new overage. Handle it now if this charge can block, to limit
> +	 * overrun while the task remains in the kernel.
>  	 */
>  	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
>  	    !(current->flags & PF_MEMALLOC) &&
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

