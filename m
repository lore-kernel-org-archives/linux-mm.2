Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915FBD1D486
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6326B0092; Thu,  8 Jan 2026 14:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54006B0095; Thu,  8 Jan 2026 14:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980F06B0096; Thu,  8 Jan 2026 14:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86ACE6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:10:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26E6CC1483
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:10:31 +0000 (UTC)
X-FDA: 84309737862.23.18B830D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 55FA940005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:10:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g3EeLTXU;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767899429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztKaoS2FV7UViH+R48ZyQnIZ1Y+jkrOUqgUswG2yE0w=;
	b=JI8PyuOuaeCMcoewHZhU5lOF8ITVlgzmQ3AbvRmNPVHq44ZgGqj1h0PXczsMc0wWYHsMQA
	RQ+iCN7nLS4fzDeepeiWDCrGPe7EiG+K2zjpswzXjOueFHvY8I0PVObCQo/30ssm1AbSJZ
	/aFfbYVDSWEjI1FOaLkyjuuVRft9lHk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=g3EeLTXU;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767899429; a=rsa-sha256;
	cv=none;
	b=C2r4OYgox3QRVjqa8ZR7cCmc4hQ9xWcR7VFzvn0n8wSEJthu+dCXLLkbyzJK9ZYS25P7dT
	+hH2p2Fgc3aX0oMfOQ2++VYSoQqwetFPJ/1HMuxCzjrBENEOBuTrasQuoyZ1jwMMx6YJ7K
	vuyqHwdWxN7omshV/YYPw4nLIwRaubc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 654EF40A1F;
	Thu,  8 Jan 2026 19:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2662C116C6;
	Thu,  8 Jan 2026 19:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767899428;
	bh=VNrN8JUZQcrq/pnCYgjUgfyW0bmZkPgoeILN/bAbbMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g3EeLTXUeU3eKRuS7y4uPO7sanUqMNZ5VF1Qp663J3H3gUDLjN9dx6+io8FYXgDPU
	 8NXIBIRdOMKfJwd4YfT+RwvyMLCa2/ZuyAwt01EYIQ5PjiSR4ZN3K+57VDA1VyHQPf
	 oe6G5dewC7dXXQEN8iLnyIst4LRTtL+WbdH7HiJA=
Date: Thu, 8 Jan 2026 11:10:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: jianyuew@nvidia.com, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: optimize stat output for 11% sys time reduce
Message-Id: <20260108111027.172f19a9a86667e8e0142042@linux-foundation.org>
In-Reply-To: <20260108093741.212333-1-jianyuew@nvidia.com>
References: <20260108093741.212333-1-jianyuew@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k9cwt94cjjkxgf9nuq3ohfg4km6kykzo
X-Rspamd-Queue-Id: 55FA940005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767899429-708778
X-HE-Meta: U2FsdGVkX1/Xr5vHGkGP9qVqLM4KnFUNoSs0J78QGgb+XrOgvrSSiqBETGZkMpPPeDCH3cQzkGjUQmrFux3i0eMoVBGzME1yCR4qAPhegumvxX4XdKdSmMsyUep2WxnxhKpzSNMMpUhlGvwnnxhtbDvxPoRQ/X+MAqqV4a1mk9nNkxFKJVuQ4ba29kKyHAAlqXgg19LhJVrB8fEv2AorjqNiozJK0HoP4zgIns/w4c9mM70ulBlzGbrDPgXVEEQqjB/OSap/vBDZxBU0sTsFH89VqpooRB/OOoI0S5sl7FUUiq+av6BFOkwVEnxf4zxF/WevfUS7Z2seaHdH7XH+Ip/9ex5Jo3f9++Zj6wHdCfIWikX1L6ci250hcIpCHUMpahP7E3GxErOEiGT2y44KxR0uFDxBB3W565imWtuLKcs6zeVKTAjjrX3ATnVzXlSic1z9JYmMfKCtBJTbCCJHORfgcLInOAkvEygo4LTbeAswPHbvBYcO4MhVDbo01VAIQp8RoW3gvxT+IndY/RrChb/w6e4nTR1J33mVNeysCLiVUz02Y2lPCGuWDw/hyOzcTWReH+JlTQxN9AeYtWsUEhjkCKgHOMvbmMnk5X/PqI/+OqEPU/EmsGJSk/3ySJHq76mkEhf0Jl2R1owELf9HGz0P6Q+CL6g/6U9Moe4fdBOLM+VNGhJ2UZ6UTequRyMdcOfqyGnCmbJL0mphoDLALVp/kdMe1KV+SNUzI9Q4F/OCqRgtFwQoU+TDyez+dV3kNHobCmbWvhb3sjXTh8R7DDxlLaqOBmH5UOJCs7bQPGSefhHbWVN8HreCT3/U7i0E/agmyLuRYvw3y2ngwOCiDxbB92jgNngavcnz1wAc83RELidJE3u5wpQketRnqD0CVv2E5R2yrjaKBjaeT9kR+2h3lsFHr+vHC/NkAlFefPs3miQqKniJ1jYqwFuTo5QDvXTce2UO7SEnp9qin2f
 B2X8rwFE
 6maETT+5uV9APT78Ee5N9GyNCNvu+VxkRf+cy+sVx47AtiM4cfZOGKRt8XzIvdbx3/L8lMcuciqalM+33G+4gz3aPiGX0UMvoyllWyca194i+bWqxZdBj6Sem+XJwQGbTBqGrFdzyFxVaTR+BdFyzduIPxowa1OmyvZ0F0gLFvb0cv0kroT6BsY4baA/H8valpIc/fW11zw4YAgIH9jI+SP7KY3R2wsM/mO22JRfxEySp2cy3B6a6Pm+VDMK4UcSJmsnxlnUduGnIvCqaIcwKQlkB+Yl3lmOw43vifwD/2MnVXJnc1YLl4HsCCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  8 Jan 2026 17:37:29 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:

> From: Jianyue Wu <wujianyue000@gmail.com>
> 
> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> printf parsing in memcg stats output.
> 
> Key changes:
> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> - Update __memory_events_show(), swap_events_show(),
>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> 
> Performance:
> - 1M reads of memory.stat+memory.numa_stat
> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> Tests:
> - Script:
>   for ((i=1; i<=1000000; i++)); do
>       : > /dev/null < /sys/fs/cgroup/memory.stat
>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>   done
> 

I suspect there are workloads which read these files frequently.

I'd be interested in learning "how frequently".  Perhaps
ascii-through-sysfs simply isn't an appropriate API for this data?

> @@ -1795,25 +1795,33 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  	mem_cgroup_flush_stats(memcg);
>  
>  	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
> -		seq_printf(m, "%s=%lu", stat->name,
> -			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> -						   false));
> -		for_each_node_state(nid, N_MEMORY)
> -			seq_printf(m, " N%d=%lu", nid,
> -				   mem_cgroup_node_nr_lru_pages(memcg, nid,
> -							stat->lru_mask, false));
> +		seq_puts(m, stat->name);
> +		seq_put_decimal_ull(m, "=",
> +				    (u64)mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> +								  false));
> +		for_each_node_state(nid, N_MEMORY) {
> +			seq_put_decimal_ull(m, " N", nid);
> +		seq_put_decimal_ull(m, "=",
> +				    (u64)mem_cgroup_node_nr_lru_pages(memcg, nid,
> +								       stat->lru_mask, false));

The indenting went wrong here.

The patch does do a lot of ugly tricks to constrain the number of
columns used.  Perhaps introduce some new local variables to clean this
up?



