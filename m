Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE52CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11EA98E0011; Mon,  8 Sep 2025 05:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEE88E0001; Mon,  8 Sep 2025 05:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFF88E0011; Mon,  8 Sep 2025 05:28:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5D948E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:28:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7AE5BCAC5
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:28:25 +0000 (UTC)
X-FDA: 83865557370.11.9DD0D81
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB2F7140010
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:28:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QWoEmcbV;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757323703; a=rsa-sha256;
	cv=none;
	b=EAPQuJ0GHr9daWG3n2UaEsBKtQw72+pB5WuAiOWhTZbWxmZSpyhvJ7mnxLvyJjg93rlZ1a
	A38FIxEgS3sZ/MaSFKbLKpkxUuuF3Zo1hiQhkVmFYc+U0xaw4IaM03tJjU81lnDKIn1CXR
	XyVq1+2yG5cW2mihoHI9sFezF0ZxiUI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QWoEmcbV;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oULmcJMXha8v5gh2i1FU5HOTdqs6IUKbO31Sh0Sihfo=;
	b=bndO2yqV/1TDtaA5VICnh/eh52wfqtyIXJ7Udlf6yF7wTOWLRLmeteufzXG+VZuq1uuaR3
	nys8xZufMH7AnQChv73I+GAAmUEWABU5YLVXIH5N8bwuwlUrTG8xPHWhqSjNZbThQARLe+
	lX1K0tMYfD6H5/z8gFCUPSmOF7i3+yA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e46fac8421so1876158f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757323702; x=1757928502; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oULmcJMXha8v5gh2i1FU5HOTdqs6IUKbO31Sh0Sihfo=;
        b=QWoEmcbVG86vpOzfgj9Gn287w6fTq85FPwrGCKET4L5YBlELcnkzVI7qiUpxgCJauu
         CnRT2pIf0ZSuyMg3DukcuzecLlc/RzM5h5XePQxIHfpLZQcUSU/6FTIMTyWizxXe/+Ag
         8Lee4SurExsfR1C++84mP5V5Jx86Cmt77LxnUuv6OT9MZO9IvISdwQ9lGnyDutCOxkQb
         S23pv7EU2I1B+Qrq4Roa9sfSu/aG6Ern6+6B7I7pzqwHN0yzh2alz0MgYX/meuO6BP2i
         afL0/H+1KQu1V7hlqKjPDesl5Fpjkxw5H0mJMO0uH5TPn0yQp5mRi25Qn0H6mAmMI3Kc
         q4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757323702; x=1757928502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oULmcJMXha8v5gh2i1FU5HOTdqs6IUKbO31Sh0Sihfo=;
        b=hykIFHoCcBXjm95ParpjRJ33yVFPPJCcFYyJegRQKMvWg5dKCLXeYQxda6HEyYa8DZ
         lymLjn7QbCNLFwgyLXSBuuLqHqjAzlVLDyrkmORCkTWYjjOiWj9+Ty6lIZBcP58i6zyx
         hbu7jTt1oPXuHHFORgWgfEzk4ILgVXztDQcB+4Tf8DNspG2MHCKahyZp5vecuNy0ENLl
         V4470wa09wsVGBPJMLG8g+jg0Ns0Tla5UL+1lXo6e99gRzOQMJJ1mnuYlBDeljpFNB1v
         COVlW75CnE8O2MZ6+a/muyj6PKQ5UvWiWC5d3ABjs7IvV2g+qKYrm9RfeiFgvEfrQbWF
         h7rA==
X-Forwarded-Encrypted: i=1; AJvYcCXRkREhwzsZ/LFN0RPDsvFItMC6Sw/JpPTsg8QXPd7isRuRKDNrN33HUtPOmB8yieYIg1mEDvaLAg==@kvack.org
X-Gm-Message-State: AOJu0YxzSqNnenwKtA73aiso2wwGcGkd+CR5ylFiB/yPfTBn8z7Q94qJ
	X4pspb2Am4d7CshDuFm0koPC7SYk3Dc5KcadjNk7q22L1V0MrCLYQil9SzvPSq1n7WE=
X-Gm-Gg: ASbGnct58Vy6jbLOFDTY3F/8b1MnrhGviusXX2rfLPz0++70VtTGbeoho4FNkLCfhQB
	pf+a+Wn1QWVK9Ki4W9Lkqb13BQ83MEVnreY52DC4LIxBfb6qI/DDJC3AeuIGYFhxA7QWLdvAx6k
	a3GvQTFI+9N2VHvMSUHtzlRgZqKsP8wdhajwZs0tWqq1G17dAJTE/O7SWBJcHH2oS3BcrugJQIv
	ijaigQ6CmJND9iy+GYS3UvvyR1leUgDuam2wCnZMjh5lZ4om22F3WOmW9xBxmDkuv6xizmfMXDT
	qYRaj3NfGSzepfXE/glKJp2jidsrj2cWymJbXakjyzfxdM0SE2yEMpD3ZMtg+YRmQbbMY5DOXcs
	KI6MljVXY/io8i0HWHFZBga2Kc3STVg==
X-Google-Smtp-Source: AGHT+IGGMokDFkj82R0pk4Z/rqNX/HhpeR5ehoF8XM4OAGAn6N/D/anNfAR0B0g0zuYN0L4mk8/Jeg==
X-Received: by 2002:a05:6000:4404:b0:3e6:a8ba:7422 with SMTP id ffacd0b85a97d-3e6a8ba779cmr2767890f8f.10.1757323702096;
        Mon, 08 Sep 2025 02:28:22 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3cf33fba9fbsm40887135f8f.50.2025.09.08.02.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 02:28:21 -0700 (PDT)
Date: Mon, 8 Sep 2025 11:28:20 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Peilin Ye <yepeilin@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aL6htMt-jHAaCGLv@tiehlicka>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905201606.66198-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB2F7140010
X-Stat-Signature: 6nitxfm1fsqtxzej57ggu9f4cco8dyyi
X-Rspam-User: 
X-HE-Tag: 1757323703-585440
X-HE-Meta: U2FsdGVkX19X7TLaqePn7FK+bzhD7z0qYTdcTED18ASMgum4mo4U8xLYGrKW4W3brg/N4U5mtl7Y7bgLYGYG3/P7Qbu+ksvA1f7aMaCJvn+b5Y6dWHoTZiuh2uF8JWSiN/uyVeMAWDgr0BLetxsuucN2Cd0dtRmSQn2mCP21kU0RW1s2gqGLzt0gBk3SDpg6J3lukFyiaRxkBqxi2SDHcL+LOdHZY1TacjURQC+ZKGaSSn/8ANjN/o8bSkmxqwF/lVEOAVJxXv39zr9xX5EeEm+ARVAS7mFfRpwIfwv8PSHJLGfzpOUc6jBTsRyZhFtOdG/9c1PfLMq+ZYeC08hOmSEqQX0whoqNLgddvgMTnJcm6Gaoe9jgIo38bYttcZrPIUr5pKBZgCTp0MPJJvTDfP+KuGR3ht8TUa6XCPYLsRrNnEPUTuoFwVUDCFiuj2VNbZwyQtuEdo6FWdGkbJTyANxi90ZkXMCPBGyj8NQrNXQ6NyFFOYULcUPSTOmN77rwfQVs8pvGUHm4yAIJ/nwB4+985Vc4Oeb3znuveGBi3ziaPwYzrlsUqf/hBD/Kf0/J7854SI5d8/7IuLdK65Nah2hxHYWib9X1e38A7QzKm0Kkg8/xNg6WLPyF7dvVQGs+TuVlZE13ajtLMjKEEF6/lvZ5JfzTPP1zdKFpmgQixs6gV2hEwNjseW0t+jQgnZcaa+OUIA1xIKkBR0HHxmhocuBEn5dmONbKQUkzA4htmDGOeiENVe0x7ZMZuida3LbEePJwYVmYe3FC5FZkIn5YKX81hlfNCJkfPjNkVcJI3JfWT+XNY4YHo2UwJwcTH+m0rOUa+ss9+0TExIhyfulJ7QyYADK0cexnOeGf8JIrHjHRjHlmBTWNnJlbkduxuez5Jf+RnbryRMauPvtr3wDo674QNhly4h9jTqOisqH6xrYbvs3ECY/nCqoWcDy2s5+ghYmAbYicfVEQF6oK06l
 iHCPrATS
 g4KDh7/O2l0LK86AXu6LYxn1thexeWLGCeywAtK5oNCwEP3xChhJYGeoyl36+QtLzhOTmHQrDTRcfleCMX5MNS5jV5n/wq16If89bgNhFcHD2MyRvyaJdNYo4WmdKmHtwB82UU08ZhN/j9g4bc+enfj91Jb/pEHACppwH2mKHBOuhYkwKT4mJSP+MpwuVaJ6zV+JF2FDnMaZDBckGOMrutaxNhW6Z7EgLpszb8mEubGXHGpUY8vrDxrkbn2adev4f/N3S1ve/DgP6eDi2MPUd3a4VkDvVp+F5fVGGczUjPo8KuWcFxN3qf4LvWSri1KGWuIS0hDCBIRW8Zt2eT4omPPbZ3EqORitq7YC0PSRO6CHlqoVNJZX7tTmi3qr3WsMj8dvhSAMZGh9s/3F1Z9KyvNMGOl4C58hnJf70LzzzasYe7+eYXA/BQJEZS68F+Ax8veXKwBoOjE3B4ijklXlFrFy7SxEGe+bSLNzcXGyMinh9OPT9WCErbocOQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 13:16:06, Shakeel Butt wrote:
> Generally memcg charging is allowed from all the contexts including NMI
> where even spinning on spinlock can cause locking issues. However one
> call chain was missed during the addition of memcg charging from any
> context support. That is try_charge_memcg() -> memcg_memory_event() ->
> cgroup_file_notify().
> 
> The possible function call tree under cgroup_file_notify() can acquire
> many different spin locks in spinning mode. Some of them are
> cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> just skip cgroup_file_notify() from memcg charging if the context does
> not allow spinning.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h | 23 ++++++++++++++++-------
>  mm/memcontrol.c            |  7 ++++---
>  2 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 9dc5b52672a6..054fa34c936a 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -993,22 +993,25 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
>  	count_memcg_events_mm(mm, idx, 1);
>  }
>  
> -static inline void memcg_memory_event(struct mem_cgroup *memcg,
> -				      enum memcg_memory_event event)
> +static inline void __memcg_memory_event(struct mem_cgroup *memcg,
> +					enum memcg_memory_event event,
> +					bool allow_spinning)
>  {
>  	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
>  			  event == MEMCG_SWAP_FAIL;
>  
>  	atomic_long_inc(&memcg->memory_events_local[event]);

Doesn't this involve locking on 32b? I guess we do not care all that
much but we might want to bail out early on those arches for
!allow_spinning

> -	if (!swap_event)
> +	if (!swap_event && allow_spinning)
>  		cgroup_file_notify(&memcg->events_local_file);
>  
>  	do {
>  		atomic_long_inc(&memcg->memory_events[event]);
> -		if (swap_event)
> -			cgroup_file_notify(&memcg->swap_events_file);
> -		else
> -			cgroup_file_notify(&memcg->events_file);
> +		if (allow_spinning) {
> +			if (swap_event)
> +				cgroup_file_notify(&memcg->swap_events_file);
> +			else
> +				cgroup_file_notify(&memcg->events_file);
> +		}
>  
>  		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  			break;
> @@ -1018,6 +1021,12 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
>  		 !mem_cgroup_is_root(memcg));
>  }
>  
> +static inline void memcg_memory_event(struct mem_cgroup *memcg,
> +				      enum memcg_memory_event event)
> +{
> +	__memcg_memory_event(memcg, event, true);
> +}
> +
>  static inline void memcg_memory_event_mm(struct mm_struct *mm,
>  					 enum memcg_memory_event event)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 257d2c76b730..dd5cd9d352f3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2306,12 +2306,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	bool drained = false;
>  	bool raised_max_event = false;
>  	unsigned long pflags;
> +	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
>  
>  retry:
>  	if (consume_stock(memcg, nr_pages))
>  		return 0;
>  
> -	if (!gfpflags_allow_spinning(gfp_mask))
> +	if (!allow_spinning)
>  		/* Avoid the refill and flush of the older stock */
>  		batch = nr_pages;
>  
> @@ -2347,7 +2348,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> -	memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;
>  
>  	psi_memstall_enter(&pflags);
> @@ -2414,7 +2415,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	 * a MEMCG_MAX event.
>  	 */
>  	if (!raised_max_event)
> -		memcg_memory_event(mem_over_limit, MEMCG_MAX);
> +		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  
>  	/*
>  	 * The allocation either can't fail or will lead to more memory
> -- 
> 2.47.3
> 

-- 
Michal Hocko
SUSE Labs

