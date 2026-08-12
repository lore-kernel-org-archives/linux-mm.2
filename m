Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6DC4C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C27D6B02CE; Wed, 12 Aug 2026 12:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573516B02CF; Wed, 12 Aug 2026 12:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4610E6B02D0; Wed, 12 Aug 2026 12:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 104786B02CE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:48:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87264120421
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:48:36 +0000 (UTC)
X-FDA: 85093201032.17.C4624D0
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79D4F1A000C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:48:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HX8q06wX;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786553314;
	b=awWkXObnYi+BfpH1YLVfAEBAl9E0gg7y1Fl14HO3RtTT5WWIMN/Mie3xTtPhHRMg2Hvedf
	M0tO4EGsI+gEyNIN4w8ShM3S2hY+F1mCQet04k7Zm4SHxzEno6KN51j4jc33y1/H7O17cr
	SIn2x1lquWxdy0ZfYJZUpL1EH0VkKSY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=HX8q06wX;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786553314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJWnk/M4buJ0YbJEsu331nsW/cLwTebx/mZLjvLX5Ns=;
	b=PBD+H1wkzA/h22HQa2bZWWwBh8JV0H3UC0Z9rrrThLfRY92y8eg72jH6GjTIrdWkEMDxwe
	We7l4w752xzTJSHEduEOd0U00pxMAyinXVJAZHCynOzCLABQbXv6rasEA8+cLifslkl55i
	vf0bKraxX/ty4bOx4depmI+AetNi4pQ=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ee88fce572so11494396d6.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786553313; x=1787158113; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eJWnk/M4buJ0YbJEsu331nsW/cLwTebx/mZLjvLX5Ns=;
        b=HX8q06wX+SZYJAvXMWP3Nxj6LTInfUFuuvWn4JBi/hexCtNWX1dT2EWRm6Zqi+gNEp
         baN4cmO8Jl8kla7fUjLHBuPgmnbHXupnX9o3QXlW9w7DWrzxSgw2oy0thmNGlf1Cm5uv
         BjeAgeRu+zXeTQ0ja+lcgH/iZWnRviy7kw4p1iZK3SZE92y0SVWNVKuoI/KNGq4SS/Yp
         7whE0rrcVBpLDysJruZcU1ZwoyDrX2ikwIao4AI3DaoOyZTOhH+emtpeO2WzVNl28sD4
         pjUos48k+9qNLVcyVVN7wNESQjmpnxeaZ97JRx8/5KmoRI6kQ3gmXsMSPfnoWborLGoB
         KY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786553313; x=1787158113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eJWnk/M4buJ0YbJEsu331nsW/cLwTebx/mZLjvLX5Ns=;
        b=Cvs0BeirExaosBp4lxq+z0Qv3a5i2OG9bgXJRiS8aIlWpjQcOGpUFWYBNorp/XM+ZA
         thZO7rUYIdqMTCCo5Tb5fZwVdFaN+OddyXanMVGQWxSfVT8zz1sFma3CNx0zwZjXrYZd
         zcJJcMi8b9PPRy8HFnKGqr/Qhx6cS4roNmr17P3sYJrJtX5mrrXR/wx+zp40OlF0Y2wK
         cwogGR6Qb7d8s8CKOn9V2M9grbValw98Q+36WBVEDJdBxnowdz058a2UoGoDCblVUopR
         mILpP1s2JzDM2t6Uoq43Wrz/ry/2GbEfywZ/JwapTc59FLog8mL3sCLzNgiIgwL0moPP
         0Ckw==
X-Forwarded-Encrypted: i=1; AHgh+RrGjDgTjbbdlCm9f5VoSjTX/CMP0BBAmSow0u07ByQ6tLelO5Sdh9vrL8lIsgQ7pbMN4HLf0pPFWA==@kvack.org
X-Gm-Message-State: AOJu0YyYF0UkELBse/KgU6CB188pABrMZ9WWx3n3ZcEk9O3oBA8+jjye
	e4xJn41HayhvObXdaIUb20zhZHguyFkcmUpCkwOGs9Lb84x1tbe2LTsjWkh4IbLad0Y=
X-Gm-Gg: AR+sD10mGM8P3tEapY7Bq9FEcVQgFnX8uXZE4sDp5UM0uwkQNapHNTIW48QVbsZQCRh
	Of7Gkl+jg63A2W642JsCKVcqSBezaG68L1dK1IWOb0W3Aoa3nFVPXx46DfJZTD6LYTNdWpTZiUn
	lxYv4vesika6gHtQcIQJ3m9PjqTWtqlPjDX/VNlL52tPyOZBTIL/HKcnxhf4WkAE978g6kFHLih
	6eJXqreoRJN2I01wFJnoOC4w772qivq1dbBu+Fx3sxK/29jRdzLmCCrYWqtjrNlBZHcoeXLU9ho
	b5UgV+laA2jOx3reJr/8vyNpxPokf8GBm2nLKe/QGZE0L2r8KKvOg6fnzHP3yzxhu5uJivckq/l
	0pUybugqIF+KMiqSAEx22yewT4sH6rQz+JwXzCevs6igetpYYN9m6NNGbBRT90BjzSt3myw6DsR
	Jq6Eb3CGqyWn0H8SoizZyVuKPsh8Yu63vIBqYbSmCfBiORIGCRXyC1oS5C/VALK6ieqTfM6A==
X-Received: by 2002:a05:6214:492:b0:8f0:a849:f392 with SMTP id 6a1803df08f44-90a6ff45bdcmr55143356d6.14.1786553313548;
        Wed, 12 Aug 2026 09:48:33 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c2cdcebsm24786266d6.21.2026.08.12.09.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 09:48:32 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:48:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 2/2] mm, memcg: fix memory.peak reset clobbering other
 fds' watermark
Message-ID: <anyj4GGPnuU-q2AP@cmpxchg.org>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-3-ridong.chen@linux.dev>
X-Rspamd-Queue-Id: 79D4F1A000C
X-Rspam-User: 
X-Stat-Signature: 8pjnkjnfuzpghas5k7knuujg7qp75w39
X-Rspamd-Server: rspam06
X-HE-Tag: 1786553314-224301
X-HE-Meta: U2FsdGVkX19qmsmAXhSj4xCUz8WJk39C71nxzxFldvmimnElu0Lh4pupUOcvIyFv5drost8TmBHgrWRfa34NdUZfDWxkeGt1GdHmV4r4KlMUYmL+mBRgGxqV85Fmr3+W6L9zejfBTfPJMTxSSfQLtfX/USaKEA/Ui0TLmtZroA7l97k6+IiSxx/ZBYRGFXYxbf6GeH8zUlaZjGq8Hk3n8IJcxcxWIPAI1/Ee0v3EtztnL0ad4mhdL+7FEoQof+6JhLEAyETz3L8UJAMQc0v5YfsBRbWtAle0Nq+Bj8a8KWPossDwTZ+bpFTn5FxIOa02ndbp7X/qoeFPPcFt911Zx2pmc1SoRLxrckmcP1VfdQ77mwf8pJuoPC6ZxYE2k9pQbRTL4xShxY6o23wutk/bVwScSsSYI7Aaut1kEJY9b06xCmknyIaqLF3uQkyHiQJ7anfF2/fiX5VYX/YRTEmLgQl2eyIT17iJYfB82KiRkz3lvg921fB/DB5MBHrIhizX3TORrUaR8OUvA43ra2s/W7MDni0VMDuLU/EDYhLr1dWur5HDxOKrbodaPLpHb8CtuVIdckl0DjMwmb23oaKauMEnETTxlo6tPECMv4tdeoUm+R7b2/dKkxb0THhAIqJZ+8an9TiNj+lxVJjzLOGQlCNwHQJ3t7Yn0rxHDb+K8zktq9hdWyeey6GDmAyeIOz39EnB/YZ+SujUD6RXX4IjtXcZAH3FzfBzGlCNamwowx/ymUwC628RcDLGjsQO7t4GhSUkcLt73w4E4o8QozyXa9dRToQbCbNwYBfEXQISnnJPRVcCPipZguzF4n7kaoMqoTIMKdXTtEnSbfHc4uOKJqe/tPpaUiZM/kcxDaC7p29ExvPnHw7ky01plJhFHZhyf0tyoPVbKijgiLpx3+sFan7CHzTxE21KyIB+4IjXultrRmYGOp750yzsOlkXglWIKbmhOR/wyUZq8Oz79si
 IR9KiT1W
 KmzfIHejajAG3Eg/3Q6v9dSB9MOb70Zjjd8HONX6ITzbrQKmg1TPSMqOcyMcdKZepuSx/aPU0hIgd0fnxfRLTyyuDTlIwmST04ZRw51GGY0PYFDHFaGPChPhJo55zchbx5HQfBxbpg1x8Uwn1BCgUv4X99tblHVtpbsJoXGOzQ06n3u8Gl32wcA5AxBfsjEa3rpNnqFy0q+sh0FeJ2rdbmN9lDpoE+yfxSQzfjheHmE2CvD6p4DSeRgLTLH+F+rODhjexApPLqefKrOShmOXlAavSnEjLKhT8hM9E4kLX0+515SNyYYZEBn11nFMq4I3B4PCEHWZqKFNrN6GCavrLy8lwOEANx7R48zW4/LVLUBmplDhudHQt/X7Css1ofOPUHLi81OxICJQGLimWrS4+MjWAqmnmaPgx3hoLT25GqmUkKqe38axo/QvzMmQMBaYtRq66b8bVvuE2Vwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 05:00:00PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Writing to memory.peak resets the peak for that fd only. Each fd is a
> watcher and reads back max(its own value, the shared local_watermark).
> 
> peak_write() resets by lowering local_watermark to the current usage.
> To keep the other watchers' peaks it then walks the watcher list, but it
> stores the current usage into them instead of the old watermark. So once
> usage has dropped from a peak, a reset on one fd wrongly drags every
> other fd's peak down too, even fds that never reset.
> 
> Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
> B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
> collapses to 1060 KB although B never reset. With this patch B keeps
> reading 410624 KB.
> 
> Fix: save the old watermark before lowering it and use that to floor the
> other watchers, so a reset only affects the fd that issued it.
> 
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/memcontrol.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2da55b778ae3..28577beeb3d0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4746,7 +4746,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  			  loff_t off, struct page_counter *pc,
>  			  struct list_head *watchers)
>  {
> -	unsigned long usage;
> +	unsigned long usage, peer_watermark;
>  	struct cgroup_of_peak *peer_ctx;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	struct cgroup_of_peak *ofp = of_peak(of);
> @@ -4754,11 +4754,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  	spin_lock(&memcg->peaks_lock);
>  
>  	usage = page_counter_read(pc);
> +	peer_watermark = max(usage, READ_ONCE(pc->local_watermark));
>  	WRITE_ONCE(pc->local_watermark, usage);
>  
>  	list_for_each_entry(peer_ctx, watchers, list)
> -		if (usage > peer_ctx->value)
> -			WRITE_ONCE(peer_ctx->value, usage);
> +		if (peer_ctx != ofp && peer_watermark > peer_ctx->value)
> +			WRITE_ONCE(peer_ctx->value, peer_watermark);

Sorry for letting your previous reply sit unanswered. You made a good
point on the peer_watermark = max(usage, local_watermark) being
pointless because that's how local_watermark moves to begin with.

So what you had before was indeed better. It was just me missing that
detail. Could you please go back to your original? Feel free to
include:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

