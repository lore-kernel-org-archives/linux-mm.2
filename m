Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCADDC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B3A6B008C; Thu, 27 Aug 2026 10:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032546B0092; Thu, 27 Aug 2026 10:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AB36B0095; Thu, 27 Aug 2026 10:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5E2C6B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:16:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FDCE40447
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:16:13 +0000 (UTC)
X-FDA: 85147249026.13.9533DF9
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0A78120003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:16:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CUKCcIam;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787840171;
	b=dvlrQDKqxj86yqDaHsEQ6siC+X3Vzex4yVoimDAKav+iAq89opqVJr2rxG40x12COEWw1H
	OwJI4cMWd39u2JVE+UoPjNTSM6+vr+1QjiFbk4ieuDbr3IXPHSpjb0M92bm2f4VpcqVk16
	Y/SaJH1curOssFBojLZ0MuA64Yaud00=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787840171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVoIwDlF3yETw9iWFWyYa/WcXPQgoIbsjIMm89Vx28E=;
	b=007rjW24ED0wH2a962D3SygI8XEIdc7SqVoTBtV1dvc6nz3oOt6Ot7MIzXN2zBElshdL8y
	oUGCOvjhjMCYbakjuPpCUV0nkLm50skjp4qfYO7umrNlWLKiIejokijgVhSh+UXukWXTgY
	ZGis11D3EfW6lnZ0hpZJSmqyEDiWkwE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CUKCcIam;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so18866745e9.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787840169; x=1788444969; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CVoIwDlF3yETw9iWFWyYa/WcXPQgoIbsjIMm89Vx28E=;
        b=CUKCcIamC7+T7hhjzpFQoTPGXZ1F6udfCYIkcjWJa5d0hpbXKUaSsc/dUCNvMtltso
         kx4LKu0sDJFA5QjWOhqVrzKJ8BddDWJKC8b0U5X7keY5Edyr65RwVjEyYjaKppVVAaKZ
         oajHaB92qH4NXSM5V7xzjHG6E6RTlRVvnbN/f98jPc8THvjQB9Qfvmrk+AAhytEk3Ftr
         Rt3EFmf2+ANVKVEsj56pFHqFTrxejAubQVA+IEYef92Kw/H5+/t+3M6CoRtaOc126ZX/
         NPkIib9JIidSkX2z2AgH7ACNZO4Kqcf4daTk7NZ5a86hB61AC9o48nQ1w5zdplJBYQ0/
         ssKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787840169; x=1788444969;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CVoIwDlF3yETw9iWFWyYa/WcXPQgoIbsjIMm89Vx28E=;
        b=TDYSKT7s6ZZyZ5xN72x56mW9f+rd+hHnNYQ3xe16k525aMT8rmoytM73z0BT2RhhXm
         NS0fdL5afXIAkgBg9X1UQOdU/8vV/xiOVXrL7M1q4jfd+RZGiMBgKdbk8xDetCffq1GI
         xSLFKZPysBcdG/Vd0VPqahWe9V2mWgLV7dsqeY1V9fYKa3CADOIrQiAANhOdWZmZ+AFg
         nCWFrG7ZRddpOeWtTv6ua2F5dxSp0UCJlf8S25LCRJ459XAw0NlWV2uAKvcBxaGU1jIU
         tfBK5PPZXVEm4FOykm+SBMZi2zMl58PT/AItSL8gCBX0Wb9omNSHpwtWN3Nmmdj845Qd
         Sytg==
X-Gm-Message-State: AFuF++kSWk7VDTR9eFnjqgbIMhJxZTHxd1fM6SPI19Xg+mGdFnxuSZe5
	WyzzfxsH62PT7wVlyqmKzjdUpfE/Oul7HZCs94VGem/Wpm0vsMKwMqWd8TN0uGt4xhg=
X-Gm-Gg: AR+sD13pmVxZgw/0AASEezRG1nCsx1g3YDmblhN1N7x1XfQKHTmlrz74E3JWqNkYo+T
	trHrUYqDmNf1o9XSC0YO9+q6bLH6Q/tX2+STFxr2Gs9XTrcjEVsysFDEZNt2xB+EcpMe2t9Yfyf
	+cXc80LIEI5XJQWLyv9Izbyv88/bZPM1bDzT0eQSu1Hvqj/93aDA8SvC2SCtrVZknSRIjfMFbQi
	Q/cs9DmDS2O5LSQpX5wfA+jULcP0zbNco3+NEmHdPDODkcGtfuAVBhgd4OP9LDVg+i00xrq0piV
	NgJQuiFJWt3CyUhwc45IVvwZ1PPuezIumCytDpKwde6ZmEM3DWw/95VBzq/jNd5yU+yqpawEwJL
	FDSkzcgWTzKL2wBYJJtfHaUmb0V4yJVQMrzIXGmm6IeTxokRNns3s6uKfEolmOrWm2nk8SmZhRh
	pb6NfIWa/E4TU1kQXtOPmUbvAeXIfgZnwcLH1el3vo+qN8L0UIh6CaCFldxvPzKHe1gvO68PHdq
	I8=
X-Received: by 2002:a05:600c:3f08:b0:499:d513:e507 with SMTP id 5b1f17b1804b1-499dc6efdf9mr208752205e9.2.1787840169409;
        Thu, 27 Aug 2026 07:16:09 -0700 (PDT)
Received: from localhost (109-81-32-216.rct.o2.cz. [109.81.32.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b0dd3e148sm44345705e9.1.2026.08.27.07.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:16:08 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:16:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>, Chris Li <chrisl@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
Message-ID: <apBGp2BF1RJVYiXP@tiehlicka>
References: <20260827025457.116191-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827025457.116191-1-jiayuan.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A78120003
X-Stat-Signature: nki5ymwynwsy49qacjcfrmz4imo4qqja
X-HE-Tag: 1787840170-586813
X-HE-Meta: U2FsdGVkX19rInN+c1MgT4nksjTDEBrBa2obTdQ14wRHALjYRhWS7M/8HkmsaUKRp7wFOiQ+7fxnbooMITNl6C58erpCqvsNxwsWIvCROeLBbFuh0Tfz6TuaQr463mcP7hfpBb2qZeJF1lUsE+gw6Lb4O31dxpwL+eswuWII8GIlV/N6F6oWaVEawV8yQq1MN2LpSPGfFJoW8zVMC0pEuUIwRPkP0qrCfSUWZm1v7EiAb2be4dUoJEynfTvlQvnfyo2NkaiQdkRZxQJ1gext0zBAjBoK5kjLpll13A9csmPiT0C1kl3gBwvcNb/+1DqLm/IDqmvb7rECG/5Aqod0F3Vk4lXC06juTMW0FCNxq+vjFLfsDiKMU1UPz8xocXK8UMTkvxv8REHSsdWRYEvRHbdv1FQqBrB7qAPja9gVL+6/Ie7gcW4s3rZ0e+/GJn6FW0JM6CfT/gmxg/ZBVCF2L7N2wraUjS6BTTSkyJyG/zuVwd/s9gpCejBjQnlTNAIx6ffsBMeFSSVDlr57j4F8sHoo78uWDjWMKhiY4QdFQ5ldxfHlBm1DSKKS7TOxUlOz45/IuW6mY6aDSPjOUDsg1a5tRIHZC6lserywmdKB8TC4dvOZMSYWGABl8V2o2c5Sngg2T9/DKoJFlNQVtpz4NL57U2W+4BcGwTs/rPQ9tvtZGr3uorPoVuXniaGUILfVw5PtMlFCXBte/CPfwJDxByPwGdSpL2LUiRPpedtKvA6xSgAxBvr/n/2RbwU0L12x/OLEPC4g1WSgzKnO+DzlltZ83JwfMPwqzSgxvE4lFRl8LYMCBFbav7F0wyeSeD11FihSityysgwLrCzZUl1bTtsB22mbbTzc7wnJZjyTstDJvp2g3L0xZbpY1K1aPdatL10Vtb/vRmSlF2yQinb3XA4yznrhpQ42qdWI8Kmh5EnPyLQUxwX3c71C3i1IFzZ1le6LA7g7S2xJsMQ2jvP
 qxRHuqmS
 uQnbjrfNL+DtRrqzfijbL//TAgRj9tdUpjUZjX2bk3dzjqCGHIG0ras8fryI/eV2IP2i3j+lpIQ7JH+3WGJEcqi9QSaiHvH9SaxH1cvccwhJLLnSy1+EWPPsrpeANUa02MOU/HErz3XekccahQuSyw4neCOxRxo7VWqcc7JurHvd73kVRB+dOc9H5cp12/kyHKSjftmtLC44409LY1+oYprjcycS746v0g+StW2vcVBJugvBbo8tBSzYjRJWT6fnrGPwTlVhOiXNu2+aqDqaZg03me+J7Yz3ftjyyelWzf3jkmuhMnxEtFc4KGMfGOvBMOZLP9bNvQSz3TV6jHbBex81nY7gb1i66Bu/y3hEYqnWJb9gXt2dExVbAUoJyw1M5WztTZ21JWMgnS2+ixI+cmNkCB3MfT5othk40Ha3XqD2aJZiLxzilr+rb9tPj56asUEkmy+mfiH5bHhoogenUI7eiM7vEYKsfLlc9g1ETrp8XTKyZE9i1p0sRmix0gX5wmUhxYLDWueNCxsHKInuwHEQUe6grb7vVMEpwmUa4vM/9fivgQV/He6/q+sX8y6n7cZ80W4tPQArXHNOnNlhMh8doVx2rqOaq1rCxRwNMB4DfoLfgbLtbstTzJLLUh4Pd6pqRbSvGV2upeEToPS+HqCQFDFeaoXiJfb684MyQ5MS7B9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 27-08-26 10:54:56, Jiayuan Chen wrote:
> KCSAN reported a data-race between tick_do_update_jiffies64() updating
> jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.
> 
> Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
> accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
> and fix the same pattern in mem_cgroup_flush_foreign().

Yes, this looks more correct. I do not expect this to have any
practically visible effects, right?

> Cc: <stable@vger.kernel.org>
> Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
> feel free to drop Fixes tag.
> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11b85f4b6828..5a3fe057debc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -757,7 +757,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>  		return;
>  
>  	if (mem_cgroup_is_root(memcg))
> -		WRITE_ONCE(flush_last_time, jiffies_64);
> +		WRITE_ONCE(flush_last_time, get_jiffies_64());
>  
>  	css_rstat_flush(&memcg->css);
>  }
> @@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
>  {
>  	/* Only flush if the periodic flusher is one full cycle late */
> -	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
> +	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
>  		mem_cgroup_flush_stats(memcg);
>  }
>  
> @@ -3945,7 +3945,7 @@ void mem_cgroup_flush_foreign(struct bdi_writeback *wb)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
>  	unsigned long intv = msecs_to_jiffies(dirty_expire_interval * 10);
> -	u64 now = jiffies_64;
> +	u64 now = get_jiffies_64();
>  	int i;
>  
>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> -- 
> 2.43.0
> 

-- 
Michal Hocko
SUSE Labs

