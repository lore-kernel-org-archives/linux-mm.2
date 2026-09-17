Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B59C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107C06B0099; Thu, 17 Sep 2026 12:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BBFD6B009B; Thu, 17 Sep 2026 12:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEF4C6B009D; Thu, 17 Sep 2026 12:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB45F6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:18:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E167F1C24E4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:18:31 +0000 (UTC)
X-FDA: 85223762022.06.2C9AA17
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf18.hostedemail.com (Postfix) with ESMTP id 240D41C000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:18:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uQbRYfkk;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789661910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2Hi4m2vwNF2BZX3mSCnm4rmtg2QaJGcI1RAR8lvzaY=;
	b=f5ddO6iu1GrSClBu1XPvkuO2GVzzNbiyKMamE+8eH8ASRvSGV1MQ0qbVcui3dmfBSBwfUN
	SSkHENRlg7rCC6cHSS5jfhCm+yPZPXGhcXbfg2ji3dnl89qfuGYOILOYIaO463pkpBwF0l
	26CqMBvZH4KYsnMhBgfkW67k4pTgUvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789661910;
	b=JEoZceaw7+yqBTu3p+o61oNqEcoMZDtCRfuSSIcdD7kU8CU3ii5AfkJwSWoBzgjRKH3/LY
	I/HSxAqQqTWhU/5W5QHEpfe85/mjTZkjDGnic38ZpTQTIoBqiTG69dyR7bC0+qzDFTOVK2
	9+IO2dCNxBeJCM23yWLGVJ1oWl+iEFI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uQbRYfkk;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb769ca02so10788931cf.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789661909; x=1790266709; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q2Hi4m2vwNF2BZX3mSCnm4rmtg2QaJGcI1RAR8lvzaY=;
        b=uQbRYfkkd2ZgFOK8EVLDvlGXcqEnCisojhV0eJbNPndCXDpyO/DaGCuxmBh5aJiEY6
         tnw0vCJvxX4SOL1UgleS+uYLr9YMo8Mp0DgnFy9IDDLffi4Dz6lHqpS+C4BvEEAHweE1
         Ykd7rzw8M61xTefmyp6D8wY2oKASrwn7sADg4iqE/aYTKZbqLy/Zz3n++xU9MvCrNwFP
         KmQi0jW7PZ5PJ3b92nKreGYaN495vsChHSiUs9KzhpnGa0UZpKe3gpM6vtHrC0nLU/CF
         7BFykcWHPZqyIYLJAonmT1kslnGYfiz9vA24q795E4DvD7tpUAKulfFqniQtXO/VHGrR
         2L5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789661909; x=1790266709;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q2Hi4m2vwNF2BZX3mSCnm4rmtg2QaJGcI1RAR8lvzaY=;
        b=Uy1TUc2QZINOvN7LuSvcqQzotd5vSA9ymtgH7/k1CoO6bfFUUVnM5RZpXzIjDCHd5N
         qPY2nsNXQcX8fS64m2Crj399+7qBH9BFXq0mEXZrQvVLnGWleLUkAy08zBOKSMoZBRpe
         dWCIoHdQhwk5dWKtFWIuwbflq3Vi6Gdnu0XyWyBB2TiTUFed6OPk4Rkk3N6a1GiHjoQX
         k50v/EBQgHuTbfJ8L0MfeKNO8D33xu7Ck1f+hUn261BugeIiWzwF27o3jLONWGjOJQXB
         /3Eheuxb62esTF0a2LZD/fXfejtDTyPi80+4DJKqX3oEdUO9onfg1Am0RT2YtuY0I5KP
         0A/A==
X-Gm-Message-State: AFuF++mphNlewCpm8kX0ZQ8tSm1ZBYdLTzvqMTTyl8f3FCn5IvgNQNTt
	dtv1eu0gcV2JuSnKTq8MYuvm0uwI0L6t+1p8SZnXlsgztOEhUlZ3k5qaFkeBGHaQDKw=
X-Gm-Gg: AYBFou3VTuc+7y/QL6UHPE6LAyuVFBImTK+XfvAPyuArjl4mPs6CKTG5GMD6GCJwOGn
	gHuP/0Jv0K9ZNcApJOoI2hcBkBEntwLA8bBmA4EJ6M4IjDk3/tVePrtnAdXPkZWRlfk3NSv9xWe
	cMKPAmXbTMoc/zXo9XbNPqElGC7wbDf5j4EYZhsYXchGIYBzgACiuTLRD1npObT8xhLbFOASHJn
	clnICW63HPcWxCDlzLaK1gF93cDCME85U8GJzh5Bp2/4RXUh4WqP39VsDpcYykA/ZP6CBjkM/nu
	vGjoPeoNcdjUKa9OwIkOoOqOAXCUTcWdU/JgEymqkt7REuKRUg0qeWLH6+fBFt1oBrDT3svKJi3
	qP4QnNUMB6QeiwPoN3yKB/US3iHYSP6Y3NINiIaoBILYuZbUV6UKigCZ7XzmMehDSafCSYUiQlU
	THgzxTIRdfTh3tGstaKFGtl+DS0UTdUcChMh1fk+41FL8mxO+N07A4A084BxszX7jNxf4I3+vUF
	YFmD+gUFD5zrAO+u0RNCOR+xxVJRKaFGg3XR3mYqOLGco2S/E3NE9X6Jxt7Gf0nlA==
X-Received: by 2002:a05:622a:90c:b0:530:f9e4:a0eb with SMTP id d75a77b69052e-5327ee3c420mr143369761cf.18.1789661909071;
        Thu, 17 Sep 2026 09:18:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620ea2efsm54577441cf.31.2026.09.17.09.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 09:18:27 -0700 (PDT)
Date: Thu, 17 Sep 2026 12:18:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	osalvador@suse.de, hannes@cmpxchg.org, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <aqwSBkeP-Df2GBLa@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-3-gourry@gourry.net>
 <20260917160827.GN4121339@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917160827.GN4121339@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: kertac1m4txyxw3bmw6ogf6xgf75xei7
X-Rspamd-Queue-Id: 240D41C000C
X-HE-Tag: 1789661909-664307
X-HE-Meta: U2FsdGVkX1+ym4iQfxlM7y21E0dTaOBvJg9iiZkCw9CL//M1ucSt6oLd2NBwVDvYrxNDSZmQpXHPN3DkS3ueZRCd2KL9RSBJRFwAdE/gSmeVEGYaj9qAvqQYVkqb+m9LpcPKv4l5JmoTmwegx/OK+Nyd1jtWj2qhS8cXL2V4fx4JnXuGRaSJ6gVt4rzLl5FvZMjn42v8z5SGT7GZQYDIMZd6W62F0YIIMWRGI+qVXaMOrgqfZLYqBF4zLEFbXe3QvLKyhi15hnwdSspcV3beg+39xCe0FUbq3oWK7vGMI3hynMVOV0Wo6HRku/bqEkni0SMHO68u6ILwpbVG7wYEPVVMGAOvP5YxsoNo0HblWc4/Q2r9pojiz//I8qb8rADisWcPMqa27g/OVendfnxB++Ei/gaGjIe188r2Mm0fP0uu/pVAZHrZ9OIND2T/fk1Y2dOwE8pcoBQNVCTh+7s6WbRpe/b6r+QnNZAfHvxb8/rjlBST/lWuXv4e6mpBaUnfB7wHR4OXT2p8KbC2uqYP+MgTUxaRoUm2/d9GqeSiOxVZhozclcBJhHvN28zEMQIFeEy0OdB/pFuLV4EwdFL6g7fO/zVFHLTR+CuBsVFVlgfqalG1g37d87uRR3wTOzaXUobAAedNHXJ+evKX4iJ3+Ahg1RMGZk0mm4A+94UjXknrM5CHyXN3WNK8YT43M1/7Jy/q+BKgYpY5YFUo2ZDwZTzkvO1kyjHnY+m+CC0hoSC7mq4n3y0PzNZh7h75dpu9UJm5ckVf45JlpFOmELaMMAq7gySGBHDldb1V2n6l8H/0ZZ6bbgU9EIvzIF65b6CexVOoKt2o8+XH5WLZvyI+UzDjB91+ZwNJN/kjf85BHpPa5F8NaXMIyawPAvA3Zw/Npc6ldi9BXrpRJAfMo6+WdHRPJFzNpwI1IPgAQmutikrRKZDbzmc6/Bp8cPl9GPNUvfYwa9UfZjnVq/nAf9s
 xZeqSfat
 dWbjjjzYuaho58g40JxYcin2BrjMzxZF2tQPF0Z20jgBcnJ7C0L2+hXcmnt80YtJ2EcApHwQm5THTsfcmW8TaBrbSAsgI/HP4pXqmj7C3BtTg90lPjZK3XkMr8AV0aTERONVQEImF67zL/M24CY8uzmyTYYFav+cdk3mAnnNq/Z5xS7oTgVoE+9CJpNqtjac6AsPdduyF5DZ77uFARejPVund8xQq9BS9PRuuwrx1a4siaT4P2SwICLnlRLAw5w/jlN/hTcs1RE5xUXlWTb9c4zDfaKgJNuL/YV875kGQVdtTs7cTubCYqLMNVr/j+ilWcK+dVHEmpW8eJoTabtSTCeFec0TqBcb4YGyxkNa0ip9w623L3i8OZAKYt5rvRAqwskALVY+inyT9qXAXxQBSZXFTBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:08:27PM +0200, Peter Zijlstra wrote:
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index a369d0c95c38..afd9c97d2389 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
> >  		/*
> >  		 * Do not migrate file folios that are mapped in multiple
> >  		 * processes with execute permissions as they are probably
> > -		 * shared libraries.
> > +		 * shared libraries, unless this is a promotion from a slow tier.
> >  		 *
> >  		 * See folio_maybe_mapped_shared() on possible imprecision
> >  		 * when we cannot easily detect if a folio is shared.
> >  		 */
> > -		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
> > +		if ((vma->vm_flags & VM_EXEC) &&
> > +		    folio_maybe_mapped_shared(folio) &&
> > +		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
> >  			return -EACCES;
> >  
> 
> Semi related; I've often wondered if we should still account shared and
> pinned vmas in the fault statistic, even though we should not migrate
> them.
> 
> After all, those pages are still used and by not accounting them in the
> fault statistics, it becomes easier to migrate a task away from them.
>

I don't have a strong opinion here to be honest, I'm just trying to get
tiering back on track.  There's some scheduler voodoo there that I will
happily claim ignorance on, so I just tried to keep things as-is here.

> Using the scanning for two different things has made a mess of things
> though :/

This has been my takeaway from this fix as well.

Honestly I'm starting to think hint faults are a big hammer making up
for the lack of hardware support for getting this data.

Would be nice to just have the hardware report what's hot (and how hot)
rather than depending on a software-heuristic like deriving hotness
from a page fault.

~Gregory

