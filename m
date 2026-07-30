Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F69C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695B76B0095; Thu, 30 Jul 2026 11:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6452C6B0096; Thu, 30 Jul 2026 11:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534326B0099; Thu, 30 Jul 2026 11:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7416B0095
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:17:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD552401C8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:17:06 +0000 (UTC)
X-FDA: 85045796052.11.FD669DA
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id D9CCB20011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:17:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CxdIPYz5;
	spf=pass (imf31.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785424625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=be+vywYOO52uR7pywIjLWsbFNIwfm83WliUEbwXuaao=;
	b=JEZtQ7zlg9DVIsgflcPSQF87fpivEFP2W6zgvCJlvOTfNt5TkrGq4fxoakxTiOrKk2n5yb
	dSupfr/rj76SHpKdCfpPh5vKcNJKYoG7pIYuJDdpXL3jT8Ee2D2cKzgTEc1kYD5wsHkS3C
	hAJKGVv6P3T14UurXzMrM7AxEFWJ5hE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785424625;
	b=VX23DO3NUp09q5KN94T4aqiWzoLMvl44lN32vH1sbM/Ia2ZPxmV5H1NEHwEf2nWEjtd1WF
	dBJLjSnCtoyjHT88Uca2SwNo0erZcnusvrFslBQO65CWWZtk14FFz1jo+SQZG6AfMuy2fu
	cDz3lhAdpDnJSvz2gatZdzNMXFaRiew=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CxdIPYz5;
	spf=pass (imf31.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d47fa11a-54de-4768-ad15-0c7127cd5b01@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785424619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=be+vywYOO52uR7pywIjLWsbFNIwfm83WliUEbwXuaao=;
	b=CxdIPYz5ftz4x6wxsBPJhs8StXdeOE+gJICfYkQ1rZldApSqmYTBYP+6q4JQg26JUDN3Ct
	UkhnIK6+syDBgl9WsaMRT0Nh3toU2fkIz/rZUuFTtjaZz8RYuWH/c/kefkBeCFIZZsqs2a
	q3t8er1OwU9ZjsRTVR9xW4A3RSbmACA=
Date: Thu, 30 Jul 2026 23:16:49 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Muchun Song <muchun.song@linux.dev>,
 David Finkel <davidf@vimeo.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm, memcg: fix memory.peak reset clobbering other fds'
 watermark
To: Ridong <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20260730115314.1069089-1-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260730115314.1069089-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D9CCB20011
X-Stat-Signature: a4zfc8exj3fo88bnrbn7zk5wth3kb45c
X-Rspam-User: 
X-HE-Tag: 1785424622-422182
X-HE-Meta: U2FsdGVkX18p9UBZ3ezE8gGEBiBeHZdiYHK65IphZDf4BoV1M0tq7ax0TtiANPzTzWlQMxUDlGE7lNGB30wOMaYNs9vyPtqEiyQzqjeq1e+KwJc9SS3C9if63oP5FYrAq0KoQNyfKZgFC304R1qv1R0/YUihlLFo1jI4ORYHWXGwdRcinwCx7zUuUQPKNWkyaSjXj0cyMhtvQo7427wNVmkJDAH7XmgS996ZBbBG6xnNKvsoaa6HR3dhjendwJyF2r9JbH+5A82/JrbdnAcBq/B/2uUi7VeWJmfANxdNlHvdfYlvoXrg5CNT1WnHQtyuLOneoX5Alww+T0lwfO1wo6nfmAWukDTRbwOVeoz4sHlZ/Y6+MQWsh+DXq72ZM7nSdjEQGyTNtZ/6JhVp8mEelOxsk+r/cVQpAad6xymr0NFIMlFA3enMJJq9NmkxCjv8M+TQEH07vTOTmfVzMNX4i1l5uUrxdOjoJYa5ALyO/sSK6YPLwlWJeuL46/xc6p+ic1Gnkufb9HUt3TreJzG/QPbC5fad1I+xMqKct1hZhl//VDsAZa7pRRyPx+P92AnT1HYwA6mPbzJT5JoRNtbjacSSSAtP/MNLBYsuzCKVmzGGa+AX/9LvTK4vIYDm3eXyORZqjXDNKF0Tsey6/r/F/hK4bJn0P6qXz39ZfBV9or7qXElJtYJI29bGzP14DNeOI6ClAgVCTxFkTNxUxzusW9O81qq01rV+j3xhmf0rjEIUr/dUSZ4A+yGIMqLjKPkewxlaYVpf+PyZs7FSe2dRqUMeFKEBG8MdWZz57Hdopn4W/Ze4REXIjz+DATyoOMfCQ4QzH4cubMlUP/fK+0YZRlkzY+dSHdWbYoXlgV4Sa+I8XBDo3oVuABgo4MOJj0zC7H9Wtr9yv5bhrEUr664DK3HoNDrDzH5pBp5OcTCqEEQZI5f0GPSXNfUebC24jq+6hFPmTyvZ8B2INvEr1v3
 dd25P1Dj
 pgo89s86ci9U3V1Atukl3wIdLorohBOvzOc98pgNthcaPwiOs0rTVpLBpbLpX5sQ+4yT60+PjcZHvITOKyVG2oK7ejxVHhOJpcgk6O0Zr4MNm28BZ41tgoVtm8mYXQwc8zy48ZA1zjY0L228nED3svlwzxhRHE2JC+D+ZRA3NoaP1fzw7PL0b0xqdWqFsOs+oQ90BteeSsbvpVV0OF6jxvRDwX/QlJp4zEA2F3i2VkM8F7ffR2MUjCnCiynkFOJkgRVrC9dgGQsX5PJU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/30 19:53, Ridong 写道:
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
> index 60145aadfc5e..881e7c459c64 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4692,7 +4692,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  			  loff_t off, struct page_counter *pc,
>  			  struct list_head *watchers)
>  {
> -	unsigned long usage;
> +	unsigned long usage, old_watermark;
>  	struct cgroup_of_peak *peer_ctx;
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
>  	struct cgroup_of_peak *ofp = of_peak(of);
> @@ -4700,11 +4700,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
>  	spin_lock(&memcg->peaks_lock);
>  
>  	usage = page_counter_read(pc);
> +	old_watermark = READ_ONCE(pc->local_watermark);
>  	WRITE_ONCE(pc->local_watermark, usage);
>  
>  	list_for_each_entry(peer_ctx, watchers, list)
> -		if (usage > peer_ctx->value)
> -			WRITE_ONCE(peer_ctx->value, usage);
> +		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
> +			WRITE_ONCE(peer_ctx->value, old_watermark);
>  
>  	/* initial write, register watcher */
>  	if (ofp->value == OFP_PEAK_UNSET)
Acked-by: Tao Cui <cuitao@kylinos.cn>


