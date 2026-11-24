Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A07F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=HwjCejkk
Received: by kanga.kvack.org (Postfix)
	id 852D16B0655; Tue, 24 Nov 2026 04:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801A06B0657; Tue, 24 Nov 2026 04:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1056B0658; Tue, 24 Nov 2026 04:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4889B6B0655
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:02:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4D1C9120AC2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:02:42 +0000 (UTC)
X-FDA: 85469422164.14.8C18C02
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4145340005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:02:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HwjCejkk;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510960;
	b=rGxW6I3bilJiYoweYVvAqbMa+tk1o+hk+KqAFj7htQkQgLJM0ivMYPeCauKBieSTlmjB8m
	KLY6Ow5eS98nMHb8K8XzTSbBXqmGdNVJGn1xTQVoxolgznKn/JYCTFka9Syu+HkHrO6Dab
	1orEYledsllURK6tVmcHi5d7I23WQPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
	b=mA+Ocezl0nsSA4B6745Y/iWFDuRar1hTZMiWcfqA1+6nEAnIWc8nVVxpAnxHlfmAq3gSI9
	q7QbahcXSye3vIZU1lA1qAP2/ftq1ENYV91/mFGdnEDC9A4kLrprc015gQ+cDcp1Ir6UlJ
	oViGaVd1Ku31TH0faTco60wW81h4qOg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=HwjCejkk;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso3776897f8f.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795510959; x=1796115759; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
        b=HwjCejkkdJBv5o/qQBhLcHYAwInsoBa1U/JBiZmT9ngBQpvtampM/3OQaYyyGcya0W
         E6+cdi3gwGI2vP/XMJqZ4u3YNYqggg44H0/krq7jwa4Y25tnbKBVMyTIjkseevYPzzJN
         DMkScRatGgXVNxARWx6atqVbSjeAKfSbEl4ZeCtLzE0tEiLSYvWS6oe14PE+/U27y6rE
         KVfLvu+3/F7ZhcMl36np0PAq6TH+Goi/eSUNVusSGfwtEzSpIHhio185pEpWGKYtmHYe
         mAcZ+2ieNlasm+/EXOnglXBmHtOCJXfmmAD04O/Jm06tLYUGhzNgdr06d+/bNvQTK2X5
         RxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510959; x=1796115759;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f3rJv8YrmzEdADJbDlr8p5ker/HZcgTcdaAmPaPw5V4=;
        b=WhP7ULne9Nd/tMguzuSfh+hsjzO9OBSd7I4BDk0htw61o97/yJ5tf/c3n3s2nOLg+4
         KmaZEJ8Tzr/Wxi2VcDKdbJylEWPdgzWFVZpC+j7ahqeF2aju9jTPysa+jIofQXhbTlRn
         3IGYzhjdbq4ItiSoWKMtGGjU2Kt49IBm7j101khAqovG4JxAGWxFuHNQGyfd/LZFGRzn
         Fj9Du/NC75UiNkqorgcfAiqO5QjToVoWmks0z7ZHFgmKpaKpGO4NnUkv2QYoImoR9gzD
         BaOeZ1Z9KciXyzZtr1j6aqNoSy59rbEVmYUaFLISELiRRUMVAybIYbyE6t0sSGyB4v8q
         tMyA==
X-Forwarded-Encrypted: i=1; AL+hErE11jlYpnH1g41VRai3TQRHudm7N8B45npSsk1VBCFkuk+hp1dJQMW5SKA6QDoFkV/WRCjQ/Q+BsA==@kvack.org
X-Gm-Message-State: APuU4Z/RZ7ZNfDc4+xVPzDaACqWOSFCARThDL/LTjmBJcNn8lcsV/SXy
	OuTJbKzeyP5578I1tacKgEOOfcHZ87C+xABIgS1AdP53QjJM/fb5GcCZlIMIRD6MKOE=
X-Gm-Gg: AZFdTZdTk8pxSllxA9ThZchXq7NyoBehOwo7TRaHyQ8WGH4v4lGmuTYCIlwahAvgYrv
	78PbxZ8B6dWK7O15/MP1WH87K8FmgSRhutLwg0lrFh0uTCxhf2Z2YJwhUNwQBuI4Chfj8zmgdp2
	pREBvAYUV6MDXJPs5lWpcdqjYK2/WIOy9AVyWY2VQ450SgRt7ExRaqFiFpMoQ3XlQ/mYFVc50sO
	xzLCvKXSGsFGThUF6SamilxohnJ8foViI4U5eeYticWphZmH0j+pMq9D1xfbjtaCZUFmJI/+r35
	D3uRSHUJ9B9SJLNo8Cl7zObW3GIx/OrS/v9yysSXRM5F4CE6p1pZLpJx4yaiqZ/CyXcd/awhyGU
	wtFUb/15/65rpA7bzjL2Cf84df6w0ihi0z6TbbwyEQefoJ01KOGG0yZs463BsAXW60IEzjPehnA
	1pCWXADDS2pod9hvsamay5g9poPHYN/S1MJaTjKR5IHcT53sPIPJFbTkV39V2/7WGKuHmN0s06m
	NSA/MlSshNFX9H1OSDNppEBAHUMnFbfVDVAgDWx0fkZ/HQCEXRDbjnCy2KGf1l5/VJYxdPyOh7g
	YawvcgblxYGwF8eAvchEnRYF5/vLj+gUZ/ZK8D7Ju/o=
X-Received: by 2002:a05:6000:26ca:b0:4a6:4687:2ce9 with SMTP id ffacd0b85a97d-4abad5ac73dmr26444918f8f.4.1795510958871;
        Tue, 24 Nov 2026 01:02:38 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b110ba3sm21973988f8f.35.2026.11.24.01.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 01:02:38 -0800 (PST)
Date: Tue, 24 Nov 2026 10:02:37 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <awVSrbJn00wmh1nn@tiehlicka>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124000439.967403-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4145340005
X-Stat-Signature: 75ptcmu83nkfnr6srcotkq18td6j9aoz
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795510960-80393
X-HE-Meta: U2FsdGVkX191y2w59MaXPIPJhBpnm1ltfDzF6CvTMhrbmRal7wlmXyZHve7WQ6JS8PXrn7Lk02J1dtkSh4upLo+grsJmECWPzHQXkXrFfaDS4tTMTqC5vBtMLjdJUaBh8gZkqLVe6k57w2WPiu55BWHR7Op19p49cNMA9rzFIZowMAisZWe5tWSTgoPa6xWZBUCO/JXL2IgR4Zp8zrJsRdblK88h6GEVyA0dsUKcFmZ9ECNz9SzLcLs3uroTTH3nBkwFMndbMUrphMXgrWBSrDIN8zGTQpoEv8CoftP/9RAC1/tlZ50FaMpqG9DxlF3In3atGyOBuNNF7jmzC59JS74ydwh1BLtCfIsUo2qvDu7ssXhIv/PdHCtvC5ocFHMByFCdQ4XkoMsVCPvezJQ7A1I5xnpKM6tauYFfNkCvnuZvHC/yG5BJ/A++ohS3TiTkfHKXKObmT/WMGiH9iSwycwIoSSS0qJH61yVRGlRdlc+YsMiZyoaIyz44vFkjnBh8eYhomNdAQnwUdMfY6IDPWbY4IRasZX60XMQJIAIuL85fchLmDvUsU3Vy1WdTG4zm7WtgN43EsPR64G/YVsZgIN2Mag7mhk7kyqTmZZc4emH5yM/sajZRpw3WB+feGvBj7carAMGbe793Szm0MftoCgShu9mI0Ujzf4a+iYE4f9ego//2kG62SqFJq4eeGKe2Vz/x+pf+//opyuWzviUKonHLOAgvZucIFaJyFcCwgyAqDMZsgW/e61a0SziGSWr5Hl02KSaVrhXhZClNqWtM8z69fwEaSf3fBqO9reG+qNQnPwRbSkOrw4+6G6D0ZEB00B6IOjz7uETTPYndAy+zjGYIP03EqtQk2XE3mQ3CfQG0NG92DWYIxep5Rzz+G7z1h4gwQEngbxklhV/RtddkvudI5FMzc/7QXCZI6aZ9gWa33xEdVh6w0l0finKX4+iuM10DvHMuDumIzK6oerv
 bDVKg5Ay
 HEJEe3JVHNiJ+bWBcVvxoDf/0TcQy8wCnPK0uY3Cx+vQpDphdbkiqupdxTbV29trK1qRMJQRXIRfJwahy6IDbFMWpEkRzQyl1AsPSfwBIyIEx61cNLrXfaTQUo9bLqAP6cgxIKCcAP2ANg+0kn6sgsC3ddu3LUaH8Yf9l8D8z7G4jymuCR0UPn2gFlNWAKoMwfvOWuD4/plJmxIYTrQjhDzOtNKz7sQKLZudL7DXziOMQw+sAkKs8x2eh+ZCSAir3YmcpRrDOarUNzodO2fUaEZ+15kl/1Poik2e/blu1iO7iSMCPrhkOCMVpNvBYAapHY5abALLRjCpc7hPSZRla9rzLb0XiYQThxWNn47xPGzQLAAu+JAHB40gLlOm9nvRsm8lzuM5sKsnFO8tPoD533yz2M1t3oFsuIJBPa2NCk+J6z6s0+MkIGrg3egFxzKc2ElHrFbcdqFXwpOEIyEZGjmCxi+VjrFeGS131sEtlIPQwcc428BRgmnOxu68BhX/YkpCEdpjYwJ12Cf5kjiWm9fthMIsvh23kai+T4CQ58bYMnR/e2u9c4FWl5k5pUw3u+nAfmuL5s8SMN/q9WoKqBVnm9LhktkEjOeXyn4Ufs0zlYYfbUMgGs8mbyvqYN7n+ovWnI+kHf+1jCoux4Zdl2S5e7qrClliD/TdyRQ4GUZN8rjFLFFq0d6qXGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 23-11-26 16:04:39, Shakeel Butt wrote:
> mem_cgroup_alloc() reserves the private ID of a memcg when its css is
> allocated. The ID is erased when the last reference to it is put, and
> that reference is first taken in mem_cgroup_css_online(). The failure
> paths of mem_cgroup_alloc() and mem_cgroup_css_online() erase the ID
> themselves.
> 
> But css_create() can also fail after css_alloc() and before
> online_css(): in percpu_ref_init(), cgroup_idr_alloc() or
> css_rstat_init(). The memcg is then freed through mem_cgroup_css_free()
> without ever coming online, and nothing erases its ID. The reserved
> entry stays in mem_cgroup_private_ids for good, and each such failure
> takes one of the 65,535 IDs away. With failslab failing radix tree node
> allocations during mkdir, 1,500 mkdirs leaked 6 IDs this way.

Considering these error paths they should be pretty impossible in
practice (and without fault injection), right?

> Erase the ID in mem_cgroup_css_free() if the memcg never came online,
> which is when (memcg->css.flags & CSS_RELEASED) will be false: it is
> only set when an fully onlined memcg is released.
> 
> Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/cgroup.h | 5 +++++
>  mm/memcontrol.c        | 7 +++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 2afb4cb2bb4f..123c713dcc91 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -449,6 +449,11 @@ static inline bool css_is_online(struct cgroup_subsys_state *css)
>  	return css->flags & CSS_ONLINE;
>  }
>  
> +static inline bool css_is_released(struct cgroup_subsys_state *css)
> +{
> +	return css->flags & CSS_RELEASED;
> +}
> +
>  static inline bool css_is_self(struct cgroup_subsys_state *css)
>  {
>  	if (css == &css->cgroup->self) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 091401cecf39..e7dfc96fd1b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4545,6 +4545,13 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	irq_work_sync(&memcg->high_irq_work);
>  	cancel_work_sync(&memcg->high_work);
>  	free_shrinker_info(memcg);
> +
> +	/*
> +	 * The css_create() error path bypasses normal CSS release, leaving
> +	 * CSS_RELEASED clear. Drop any private ID that is still reserved.
> +	 */
> +	if (!css_is_released(css))
> +		mem_cgroup_private_id_remove(memcg);
>  	mem_cgroup_free(memcg);
>  }
>  
> -- 
> 2.53.1-Meta
> 

-- 
Michal Hocko
SUSE Labs

