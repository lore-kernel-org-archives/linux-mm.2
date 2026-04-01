Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF9D10F6FB7
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94946B008A; Wed,  1 Apr 2026 10:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BBC6B008C; Wed,  1 Apr 2026 10:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82006B0092; Wed,  1 Apr 2026 10:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97CF56B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:57:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C5B6E0797
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:57:11 +0000 (UTC)
X-FDA: 84610289862.03.510A8EB
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id D1722C0002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:57:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=thc87eUm;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQXEHfCvMyv/KoK0NtC8KfdmVuqSsveRiH4neLzH/nM=;
	b=XHwmFsPqIbh9tDTQ5LLerzzdMMzlviwpTjYue7iSaNz+IxyaZ4ogsjcRPSNsjxSTmQB0Uo
	7/zQKEvUi1MrSAJlh9f6fVF0bhvBelPHVUOJkjo21CUSCXD2JtDuxh7mKnBAmjhSwJVwuM
	drGYppher+eTN6eRmIhJ1Sfv1P6kT4w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=thc87eUm;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055429; a=rsa-sha256;
	cv=none;
	b=fDZhsSYJzUlfNgAklheeragn6uo7056Q9D5Iirhnf81aGHaxdXJcU9qwmDT5om27NUWg3r
	VZy2liyx0Rhoyde22f34Cb3XY09Hijepi2U+xkh24M3Rbs6yQu8hrtb/a1suZeph8QUYmZ
	zU0lZImg+jaz5hMciJXpseP/PQxSWC8=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89f68634786so52139296d6.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 07:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775055428; x=1775660228; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQXEHfCvMyv/KoK0NtC8KfdmVuqSsveRiH4neLzH/nM=;
        b=thc87eUm2YA7p1XHNH8tBlrJD1PuUDGKMgu0GrQaXwZ3qrb+DDXbfhuADoEJq83CoM
         KB/RPw6X2v8DyuMWA1whnvpBIEg6/WRTfDE0/Z9lxJ9J2W7TUB6R/tCxdKVi1KWd8jgZ
         MEX4p0RMdFhAu3ec8Ok0MeX9tfBm1/7K4CiH8RAK00T/CHXTeLiSFWnwVB0eLsRSGebY
         o+2stanyNVViXtYQ0qWNNf2IUbavqUkKtcv/4R1z5+wWo/G3eCQ46aQa0jO+a9xo/pJv
         uSfy/03//GWk9vPSW3DN5zS+gZm+2un0UaSXa8Z4WPH7GrjO26519mBYBjhyxErdv0fj
         xy2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775055428; x=1775660228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQXEHfCvMyv/KoK0NtC8KfdmVuqSsveRiH4neLzH/nM=;
        b=pLFjcpvCGCmd94dsmEPTvUtDelQRBiqF9McBehCTWX+TtCQ/B9b0zNRtgVKD85EfKb
         ewbj/R84PCKZ7zk5daRE+kpUm0gwCHqAF2HBP9S4XT6M7JXroKGjU5nqK2jztgIhYn6D
         UgUgHEEKZrRC6ZDRQb5a/BhmFPCXjRValhWuPxowZVLhAoywmrkw7Bre8YIXfSgo41ZF
         Wr6FuJ1d/q5w7N02ad/zMNu8wDliyJdLk7+CuWL27+AG8pT8mK/lUGn1nNEa084qKDj+
         7uza5IvdG+1Y+6Dya/JiocGWl0xfZ3nOSFSu3QiAxBcyJ+GdDPtIYszrJlrK3vlCfrxA
         guBA==
X-Forwarded-Encrypted: i=1; AJvYcCUe1XKoJLcRMdscylvDAwihBy+cr5ylOJwVqgyh/QknalNALiJzuciWKdnH0vwHYl2sNndYcM0fFA==@kvack.org
X-Gm-Message-State: AOJu0YyXQFyrzU5NvsLdnfbBStD0caMfD/Z4ONdh9d2k8FTeiPfy6VpI
	337RXn1oqkIbFlqaR0SQ2d8cMxAN0Ie6EyfcMrVJlmFwEGQ0RVwSXAmSUIe5wN00NwQ=
X-Gm-Gg: ATEYQzy+8o+TA8cRR+6lBjlXm1Ml+kv/99X3wylntLthBZAJZ5oaMjhXv0cLiuPbsLU
	LabAXO5rb6hm5VC9bZvlc0wMvzIgNpt+I8BihYPzIh+e8aNt+DkWvsnuf2yFu5RkhIiTfCCVTJC
	NpHHTIz4n+9W5y8BYORi7t/GbD4vYLUJaNbUPm7eDMVUSIvL13eh9o/R9rCDCAUHw7ZIA5pXwSg
	2mmVkvMoV1lvKa+0nsVV+JsqO9aM8yZdc1edtVUh2GKJcd51Y3fvvwhjyddRA/cq1vQ3DKymju4
	Ylda4OqwCLaiq4nuFSeNMhXgrM/g3hgLKtY7VS2nnfunaaUDNlj8doHB6hzy2ISwWp2ZVYx/A34
	+IhtczQ3Tq4MknFiHvIEpyxjuYN+DWn9Qe+ehDwkeumVFFm/DMy5UKvlg2Zrj8ZwI7nnHT5IicV
	3wiuXZtBFnSmKru86o5RGaRA==
X-Received: by 2002:ad4:5ae2:0:b0:894:6510:4946 with SMTP id 6a1803df08f44-8a436c125b4mr63773826d6.10.1775055427499;
        Wed, 01 Apr 2026 07:57:07 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf960d2esm119091476d6.34.2026.04.01.07.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 07:57:06 -0700 (PDT)
Date: Wed, 1 Apr 2026 10:57:06 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0yQjSJfhH6nSfy@cmpxchg.org>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <ac0q37PYB-2DZhLk@cmpxchg.org>
 <ac0tQb96dK7FKkCQ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0tQb96dK7FKkCQ@gmail.com>
X-Rspamd-Queue-Id: D1722C0002
X-Stat-Signature: f74und9mkwbetwur53fmkemss1ujiyg6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775055428-263346
X-HE-Meta: U2FsdGVkX19oqkYciTeH0yjbvKfxoLjjRCnKEsvDJIRlAHHLtz1HnY2ifl8Imsk987xOvRq2X/l2l7VsS2adrDyx90VOIKJwfI1bMNHC7C5Rm5kZNXL63y7oo8c6ZIfvQGwIaXkAo2ovTs3oJ5tCRv3z2k1HiTDMZzWf+y88/IcNXvJo7zyR/Xmr+VDzR75xFI42I6vTvYNDGjy5abu9D/8rLZTglMlX07JY4T9XYk1QpXmee9l058KCQRGYkLWzAZdVIqI2VJy20b0abFZFWeQ/aZSlNg6mR+nnWI9QoR60eGDykLhcMSOw9AtsWBnU/4RmxVJUCOn7pdSry/EOGySsGVYni+GPFBHFea32vx5YIr88dBKyxc4NU7dcxpkRpCeYqlDJ9PWNJRj86+rn1uOt0jGonpNGLqtgSWBXwCyZ1IXw2TUw6cnebdzI+YkY0wGocoNge+n3ywxdKY02VoWMgScMMm5YuZAlAOmMijjrCcjGYV4UQtewwzIJAw6IBSIPj2YujVfHNzP7K/4ckqWUVxDzp3peMQWJNKIE9DPVApQs/MfgkeidrqU4PoW2c2BuySM07UykUAm9Wxx4kdoLCgrbho4eVDzHLrJTchPnT9tM/oAFdXa4yxA5Sa0kl+F+jOAa43lNejh9LVN0h5v4QxTwyJfh3aLKmR0HSYqBxFdd4SdGrrjO1t84T8C0aGmwpsmt/Ojtl6JSOOmyKP8edRa6yzIkmzWFnIw1gQ2uzGK8Oz8Dx6cmT8sPRwoAEI9dvZm//y+n1sK5ISQOW9wQbnMjhRIveiqNK9I/3AfXHwms6sxRqwtEgaVGFfgGDBxObvFSU+g+3NtxyMHW13ch3XRyDcwmIq/0Tx73o49De9st4BX2A5WhQyaVQptam+vWee51A3bjImOeDqePoNyAUARR/V37rnuQHMFoXgFPP3KQHLJjesLHf1UgFX76Zn6uPac3eZ40HwZKn5v
 tqc9ClpJ
 h/826IQMislodR6UgF5S9VshVg72QvwSt0HZS0vonp+aKu3wzwYLUfOD9haBwJWomFB9hAtd96rhSWZoW9QOVYBv6U8//Yw+8HyoyiRC+Aplr3gpZXYpHUHkpGr5+hTrwhWWtRWT+E3DEpKiuyx5HyjXTbj0NHi5y0f34XvOYtAO81D2apPTZrNY+uMkedBGkTF4H7ozZtQ8DWLd9DVmGGBq5xt7b5vd9GlUeP4DNipwmRLxosletPWPsEXtxhuccKq9+o5bi6Le2SidWThsO4ceiLKqw/ng3qm6y52dLNneTsXTUgARS98Ot2s2qbmACC1yfsphxhQsSqTVKWUf+dxrbG9eyjOax4uFcyOsJPXqAv4I4/42TnN90TmKoq+jdHEPDQ7XRK7Qb332Sj5Wk3VyLrzK1TSp4dj+mrfrZQcpR1Awc+UogXIbDMtmaO05UAkq1xp3QgrEmCyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 07:39:28AM -0700, Breno Leitao wrote:
> Hello Johannes,
> 
> On Wed, Apr 01, 2026 at 10:25:35AM -0400, Johannes Weiner wrote:
> > On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> > > +static unsigned long vmstat_spread_delay(void)
> > > +{
> > > +	unsigned long interval = sysctl_stat_interval;
> > > +	unsigned int nr_cpus = num_online_cpus();
> > > +
> > > +	if (nr_cpus <= 1)
> > > +		return round_jiffies_relative(interval);
> > > +
> > > +	/*
> > > +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> > > +	 * use round_jiffies_relative() here -- it would snap every CPU
> > > +	 * back to the same second boundary, defeating the spread.
> > > +	 */
> > > +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> > 
> > smp_processor_id() <= nr_cpus, so
> > 
> > 	return interval + interval*cpu/nr_cpus
> > 
> > should be equivalent, no?
> 
> nr_cpus is the number of online CPUs, while smp_processor_id() is the
> CPU id.
> 
> If you offline a CPU, then smp_processor_id() might be bigger than
> num_online_cpus()
> 
> My goal was to linearly shift the timer and avoid creating gaps when
> removing certain CPUs.

Ah makes sense. Plus you'd spill into the next interval otherwise.


