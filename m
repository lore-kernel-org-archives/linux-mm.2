Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2FFD6D22A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D55C6B0089; Thu, 18 Dec 2025 09:26:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482376B008A; Thu, 18 Dec 2025 09:26:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C396B008C; Thu, 18 Dec 2025 09:26:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2801A6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:26:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8BD8140142
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:26:22 +0000 (UTC)
X-FDA: 84232817004.30.6D69982
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id A245A180017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:26:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fYWbrYLT;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766067981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O4JfDdWMGPq8CSrxduIu7FfagUjVyoTiMCySGeC3YnI=;
	b=kmySdEG1lGHp8ZsmHxd5FYBT5zEDkOHvEAFFygX/aVJ0vZr0gCXhuGFuc+2p6m2KG4UXW5
	K7tsdsDrHnOsFQBlsGABXLxv7edb6M8TFCkCWOEnvSeSucfOx6wlQfKWLJPDuTxMgTf8IC
	uyQxLirk7Ib1y0ijcUtJkS+ADPNlz1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766067981; a=rsa-sha256;
	cv=none;
	b=rIWE2RaYbBcQTQM3DVfGvWHbwTW/NrvDAeHNV53O8Kw9Qmfrcog/lsjFbddAGMZWvrd1HH
	1wCuOdA7d2foMhM5xg8UEM7YfXc+apNesJ9JYsnw07GVNTOHNIDdKoLpylPGJ1tsiMb98U
	E9yTjNYV7Od3D2sRASWsLUlch/UO0YM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fYWbrYLT;
	spf=pass (imf24.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-88a37cb5afdso21646826d6.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766067979; x=1766672779; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O4JfDdWMGPq8CSrxduIu7FfagUjVyoTiMCySGeC3YnI=;
        b=fYWbrYLT6n0+ByeiEoz0SUgoZK83TJAlg73Bs8jiezbRMHczHTQcH/1SdylRj1WGYH
         RGAagPDBhS3MHTwTPd8grvZL999v2LTdjHbMOU4fLylIx8A3Zc9Xxnz8WP5QGJp3OxqV
         YleaL+tm0Mw/eiR9tg9mOhdGJDyNExoXLgg9mA8OEee29iEaVv4gHlC/2AK5oo6N4qbi
         +bVu8dWMKsRoDulmCfzHuFw3UX96HnBOwDEusTCiHk1kOaf8g5y0cW6F1yfdydn3jBmO
         MjqC11GdGmTa2Q3RAXCQCkP8gMUDJq+p+0DwVK7F6dxw7ly9hHrf9YvDhxHwtKpvGBcx
         uv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766067979; x=1766672779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4JfDdWMGPq8CSrxduIu7FfagUjVyoTiMCySGeC3YnI=;
        b=CUrjUMHI2+kIUgKtbpiajBjQiumNG+ZLLafwj/QWCVR/wOGbsg6MzpjvhoY0QPmHSL
         PHYjyimC3GjMDRRx1JwCvFPJtQENgqyp0FUsijSHm5Mj5pJ4eANc8QIFBFSmxjbbWHpy
         O9G+9AyfEfClj7D45Jk++hmahA3MTGQZeqpX37eW17C0WFi+++DXkd6LJC7bzwgLXjo6
         ob5fj4OS3PDDaf8DZzbCcCVcsf9UrJFaIMI3RNIsciXozh3EXWAT9MGJkj7lnSj15L7u
         1CfVz+zPT8Vw+s4DcvASTwU+npsAkbDABQMLW2pWBH5wFR0U5HyDi+tfJLtuCPUP6KHY
         jXWg==
X-Forwarded-Encrypted: i=1; AJvYcCWcnYgnPVH/VxVNa3/MTPmsDUeurKyqX5VDi+azVIxLrmICFHkc3VKJqviSeHsWobNnpbJkLu5iLg==@kvack.org
X-Gm-Message-State: AOJu0YxiEqPgcd8CNU4FCMcKODZmSwEIUgIruSz7fk6+QJfJYV+fIY7K
	6zsPf+koaRIrs8ud+5+aLpDGoywQFgLKkprHp+2OeLAxoubYPsmktC4X1Ogjdx7sa+A=
X-Gm-Gg: AY/fxX7K2tHsbmSN4CvrSFit7xr5SSCOzoMKtoiBnOX4Z74Z7/F/1uA/k4+K1fHJpBA
	tuM4jknd1s1nc6dWG7jEcmN8JZ9pL2ECqEogLsRgW2JT2RVoz/zxeQ67g3d/VnYX5iB9zDLgdN0
	ZinGzt7oSUM7egMrlbU0X5ug1ZF0iI6SnbaMFUK6N83pANUvlzceGFLBQbeCTvdBbfRH9sIR22x
	VHNHJrqk7h7sV3Wp6Z2B62rPm1jCjwfDrjhVD17n69X+AF5zeH4ryYUgBLGFVx9rXQ7Vy6x6Obb
	j8JJdRmtuQ81qMDOX103fSPysqqU5hZyhUUnRzPJIxSNWrAbO1erkkZnObKGhJTI+qo0TidCJff
	806ebxAm/vRtIbaM8dv4UFqEij3VoXku1L7Tp2risT3RhCSdJb6hYyKxtWvcBzCKmCDi3jm/Pku
	ibzOIgvjAt1A==
X-Google-Smtp-Source: AGHT+IELq2RKx20U60QDHWt5nbgZD6b0sDzQmfp1LT1fm0LfAa5ovOYvirAd5MjdzrOUr19AMKNjZA==
X-Received: by 2002:a05:6214:2d46:b0:880:5589:54cd with SMTP id 6a1803df08f44-88c51e5859dmr46310956d6.19.1766067979375;
        Thu, 18 Dec 2025 06:26:19 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88c6089a7c3sm18147036d6.27.2025.12.18.06.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:26:18 -0800 (PST)
Date: Thu, 18 Dec 2025 09:26:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	harry.yoo@oracle.com, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 13/28] mm: migrate: prevent memory cgroup release in
 folio_migrate_mapping()
Message-ID: <aUQPB0cUP9PXnrqh@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <1554459c705a46324b83799ede617b670b9e22fb.1765956025.git.zhengqi.arch@bytedance.com>
 <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a6ab69e-a2cc-4c61-9de1-9b0958c72dda@kernel.org>
X-Stat-Signature: f5epur3dadmwbch6ynajdys5ubzapg65
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A245A180017
X-Rspam-User: 
X-HE-Tag: 1766067980-4735
X-HE-Meta: U2FsdGVkX1/ZjMVuy4X4Lh9pl0njUiKn1dfm6ZMxeTvn3kFyEZ4SJakPmM3Dl+1Q6mifQ8ohA4BtWZ2sVnR5TgjFYogTZ0dLHUpjVT6SLFuSka5w5WXx9/wuLqXdyW1nrhyVmwwdXQuPJonghPe9iSbr84y4ukqWBJByvqbTbYC8B4gg5R2NaH1BTvENGQwv80hVR00EUGUBX6G0x8OKb2iy87Ic9OSAFASihq2PE8m6IobsSHMpEw5TVTvT8ldlP4ntfe/nYk7syW4Mu1bzxSOt6AzY3l4Ss4JEqxihnvFIM9ukH6UkwkUoTHMO5yGU/pTap762Quzt/6AWMu7IRzESPa4b7TsPQW8AcS28OJXVntZUKI/rpZ6YFegVFacDW9FsfZjzoUoYQ1AW12Gy2NPdCI6o9kcnkcS3TByRlL1joQr34bZzSgJUnuEu0OodipUf9p4LXZxWr7FE7XC2fElPLAvwok44WiuD7Y6EHWdxeD2wEvhln5c6XvZO6baNjHD2jdGbLmYCA9kl95P/3p0OhLG7dab4yWuk3WsL6Kl83ihFEX1d+Fhxf+gBs2tEqzOBaRDb5dsafJ+8Vp1CJde2ODu62gZlF9vp4halBiJcN22WaHD9S5xepjqZBPsh782DPyAb/Zd7lzGfqx9jMEM9uXi1VWYL/E5eqO4zNnvGQEAJmisO0A/9PHlV668nuEg535IwpytImzbSCSRYEsCCssXG3FvuLrDlh1TRL1c8f+0HBs/M3GWmj6Ssqcnfj21Ug0o53mPScqLjS6LzYFT1NqgKAwp8uUUVPs453xEu0JtTTioUGt0Wyh0veLoisfYK+mYaaShj8+7Ds9AOSm2tPDRxISiMI+Wd+LHh/v329HYdE2yJzDNPfeujP1/Jy/1xl/ySKmcr5/x1NPKi3I2Pu7paPom/CETk8yai5Kv7CvtiROcTo8qNc0Q8+GPBaNz+IONR6KmqtxK14Mv
 qq6dRea9
 AEiYUoYRuXHuSxjt1PIAW04LsAo0WE2cpFjDPlhnR0OO5qfr5d0sBlazNbHsw3no53mgGGFTSs4k/5paxgjtKbZmrPfv07pZot6Q77HhCowgub3lCh/mSODR9SdT6wBTw6g6a1T5bRsjnogPKa3qsbPSJAxQ0BL8wT8pdVun5rWqgl9PUG8sspcBup7AzWw4vZ3MiH67iyeL7dULYjFHorGlHuWAGM2jqYuAZi38jvSQa426wCIjQ5Yt0j+WReDP2jyVIV9HFYWMdzIvhc5iCuxvyuLfF/NVHqTPKTZ2AI7uJ9PObIrrm5Y2WkIlk9hRYmyFZcggqXyemXS86BX37gJ2NMW77SAPu+SBBIKzp3YF9lCgDe3vbBokLgdFQDvtU/7rQZNSFJwVDSV9yN0BG8DFgQ/5W3tUFRkHgwNKjEjlkkB7qPwzfiHEA0znEFQTMFt3tsWY6/DCOi2jh2UTeXQEBbFMYucRN7dKQN96zT0jyDIsWwtK0lzVS1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:09:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/17/25 08:27, Qi Zheng wrote:
> > From: Muchun Song <songmuchun@bytedance.com>
> > 
> > In the near future, a folio will no longer pin its corresponding
> > memory cgroup. To ensure safety, it will only be appropriate to
> > hold the rcu read lock or acquire a reference to the memory cgroup
> > returned by folio_memcg(), thereby preventing it from being released.
> > 
> > In the current patch, the rcu read lock is employed to safeguard
> > against the release of the memory cgroup in folio_migrate_mapping().
> 
> We usually avoid talking about "patches".
> 
> In __folio_migrate_mapping(), the rcu read lock ...
> 
> > 
> > This serves as a preparatory measure for the reparenting of the
> > LRU pages.
> > 
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >   mm/migrate.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 5169f9717f606..8bcd588c083ca 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -671,6 +671,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
> >   		struct lruvec *old_lruvec, *new_lruvec;
> >   		struct mem_cgroup *memcg;
> >   
> > +		rcu_read_lock();
> >   		memcg = folio_memcg(folio);
> 
> In general, LGTM
> 
> I wonder, though, whether we should embed that in the ABI.
> 
> Like "lock RCU and get the memcg" in one operation, to the "return memcg 
> and unock rcu" in another operation.
> 
> Something like "start / end" semantics.

The advantage of open-coding this particular one is that 1)
rcu_read_lock() is something the caller could already be
holding/using, implicitly or explicitly; and 2) it's immediately
obvious that this is an atomic section (which was already useful in
spotting a bug in the workingset patch of this series).

"start/end" terminology hides this. "lock" we can't use because it
would suggest binding stability. The only other idea I'd have would be
to spell it all out:

memcg = folio_memcg_rcu_read_lock(folio);
stuff(memcg);
otherstuff();
rcu_read_unlock();

But that might not be worth it. Maybe somebody can think of a better
name. But I'd be hesitant to trade off the obviousness of what's going
on given how simple the locking + access scheme is.

