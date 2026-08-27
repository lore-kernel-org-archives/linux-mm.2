Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF27C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1176B0088; Thu, 27 Aug 2026 04:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA20C6B008C; Thu, 27 Aug 2026 04:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB83A6B009B; Thu, 27 Aug 2026 04:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A632F6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:17:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20DA11C1BC5
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:17:15 +0000 (UTC)
X-FDA: 85146344430.17.B19349A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 60B7980003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:17:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kb3+VZf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787818633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoV2JLyDthha8SRAUynv+MIxi6zER3ywHmEQ0B1FVZU=;
	b=Kr7jjhYfdlKKNDqAx0uzF1wPsGjEHDVIaL2CDDMhcTPQ/pIXMgrS8y6y5XTbvo1luYh6BW
	AnI6YPNR1ovWkSPTDgE4eZhAHkQQWfVVwkZ6bjNeLOwnuHCKaVg08DjnMLHBsZ5Rueh0Dk
	lPUzAAeWAyZwehGTBckpcVZPSON0VKY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kb3+VZf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787818633;
	b=r0Bd1nsBzsId6FVMmD5w4gVPlN2kaqsBrDd9HaPllR5CRbolK7wJ3T0ckX74ZKjTYB6akP
	/aaM4LjcYoi8iPuYmHts2aCa05DGWBZQ4v/n6Z0TAaKRHz6yFyzzuveVAjGhNcHBEWC3hg
	itCCp8NbEowZFMKHoWQ7rqrGP+JpN+c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 958B741364;
	Thu, 27 Aug 2026 08:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC0E1F000E9;
	Thu, 27 Aug 2026 08:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787818632;
	bh=IoV2JLyDthha8SRAUynv+MIxi6zER3ywHmEQ0B1FVZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Kb3+VZf0uc9hFIhgW8al0piOdE/JqGk3Kq7nxZ23oY2lo8kbzImiw7RY3gKQyIGf3
	 egGYVWXHOgMkrPimJ7z4RryeJxr4bUze9but/U8U/wUqhRY+4unAJQvzCq76Kj6ccI
	 uTmYJ8ZuSp6Epwm425ch7SAH0A6cGcNQQOsRNVz3lYc9YZs2A9AFohonNK07ozVTSU
	 W7VHt53CL/qm2315HgfsuzMC8jtrtR/WjkPBguh8Wk3GrcqRN3ww0VbKniXISd5wRE
	 ENaQF9nrIOUZ+QO2fI2NsvHb4YveXmDwiTs0i9lbnAm0NSXByY8bwviHpGiztS6Y1Z
	 SAG803NYX3JDA==
Message-ID: <62ba2ed2-d030-49d8-8872-d714ca0df8f2@kernel.org>
Date: Thu, 27 Aug 2026 10:17:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: annotate data race for per-cpu pageset fields
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260827070546.1336383-1-hui.zhu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260827070546.1336383-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: x5wpz3saahk1c1h14miwri71mzkfrgqy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 60B7980003
X-Rspam-User: 
X-HE-Tag: 1787818633-395895
X-HE-Meta: U2FsdGVkX18jUaxJv7Z6ELFHfF72oxs1aqRJE1/VWZzCPyeI14dpwFxuivHp7Mk3+AaO2KXITk7SML517Z51CYu5HBvAXh/2v9D/TDqhlZDnqYKSVzXLNg4Jt7lfGKXO0OfnzMUl0Y88a3cdWEt/o57ZRcaunSG6vICZEe0H/8GxXg3uLqvKRQXtOWvdvIhu2z8pWimRvgTKQ6JE4klb1NAw5GtrPFRNJLiwqvd4jvQ2Ko4YwvGj3ddhxiVVi2yog3nX956Hyje1BzkBEbKBXu4ucEarqgQNdfd6RVxRs1WZ4nFKHl7eHAe+yzLvpJy1c+7zOarcAWfyNeClDO1DqpvnJzWeiIBM5ZNnpVNgnpush34AymNhlBIkhz4liEc8ZW1lllOC+iJd2wGhR9t/4eU1SHvYM1EOFfeOb3iLSr7MfZt4/yr6YB6i0oSuBx0m5VPY+lwnccJ2/LoXrnxEniaDNxOf5lir5m+jgsMnwvMDc3vt1N80JAK/U9UdPT7fW/W29WvFHMq7t33sR9L/s2xlMFBxIY1+3xq7y5cY9SYw0dKiaM9gMX1RI3vppZU2uF9aBMZGUvTVovYpLaeC1ElKU2opgXmzKMNiDIsERjBslIIF4ZjcBRSUoZ1Y0G5BMSxUli/SbXOU52lpcK7N7tn+OGc1l5imxUFxlQmpY3w5QhEA2+nXgwbBIvf21Jkh0VZkLiW80dX1bzUsb0mDxPYowUouWCtJBuoP4asR2XuDUWYK3/7AYfFmJ38hNnOlYx+oOJZGyRfg0EcYJzd5mSzGMy+prKG/BecycYnLG78NwddsSiV01Oku0xfMsMLGf6r3AJ6gSbVH6Zt+WPkENagIXBwMyfkn+1Psb6eeLernccGD0rYEFmgpqcIycCysSQvhiLQttjYFTMEFPPEOEh5O1XrtIBxDD9iIzHh4XkQxm55jQwKuGsoxJd1j+L6HRtar3YQp3+5W65Wy0TI
 SIPGNI7R
 iWWY1uB3luDUd1YyJZJBMGJW4d8Ix1l937KXmt1Fo5ErL6Kr8KtCnHGPguj4hteBIoTWuiFM0Hl2bGQYqdgrdBWiWubHh9/Lh9LeRHKIo4nbr1mVvehDVAB5Ch3EEE5PlnDaXeq0nSBXZ2/RNbnM8hBvE+atUq/Pf3f4nhW+AP9aEdzyuZXTWH+A9YlzQiBgUPbWyxq1CZC3UEQDKdLmVq2oeR0EEAdpNALm8yTn5KfsRJevCmA2VJdhwwxuIeYtff64Aq/EHREZ6gxdCSQSGRqqcDpwhKlhcueiapT6GSApQ3LcX4JmG3rcmDd+8LncjGHJ00UpnV1CSZqw35gliDJ55mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/27/26 9:05 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> zoneinfo_show_print() reads pcp->count, pcp->high, pcp->batch,
> pcp->high_min, pcp->high_max and the per-cpu stat_threshold while
> holding only zone->lock, which does not synchronize these fields.
> The writers are the page allocation and free fast paths under
> pcp->lock, decay_pcp_high() which updates pcp->high without any
> lock, pageset_update() which writes batch/high_min/high_max with
> WRITE_ONCE(), and refresh_zone_stat_thresholds() which writes
> stat_threshold locklessly.
> 
> The race is benign: the values are only printed to /proc/zoneinfo,
> they are naturally aligned integers, and pageset_update() already
> documents that users of batch/high_min/high_max must cope with the
> fields changing asynchronously.  Annotate the reads with data_race(),
> following commit af1c31acc853 ("mm/vmstat: annotate data race for
> zone->free_area[order].nr_free").
> 
> Found by KCSAN testing on an older kernel; the same race still
> exists on mainline.  No functional change intended.
> 
> BUG: KCSAN: data-race in zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
> race at unknown origin, with read to 0xffff8e1835410808 of 4 bytes by task 22653 on cpu 12:
> zoneinfo_show_print+0x355/0x520 root/klinux/mm/vmstat.c:1774
> walk_zones_in_node root/klinux/mm/vmstat.c:1496 [inline]
> zoneinfo_show+0x41/0x70 root/klinux/mm/vmstat.c:1806
> seq_read_iter+0x30c/0x970 root/klinux/fs/seq_file.c:230
> proc_reg_read_iter+0x10c/0x170 root/klinux/fs/proc/inode.c:305
> copy_splice_read+0x2a1/0x4e0 root/klinux/fs/splice.c:365
> do_splice_read root/klinux/fs/splice.c:985 [inline]
> do_splice_read+0x139/0x1a0 root/klinux/fs/splice.c:959
> splice_direct_to_actor+0x16b/0x540 root/klinux/fs/splice.c:1089
> do_splice_direct_actor root/klinux/fs/splice.c:1207 [inline]
> do_splice_direct+0x10a/0x180 root/klinux/fs/splice.c:1233
> do_sendfile+0x6ea/0x7e0 root/klinux/fs/read_write.c:1363
> __do_sys_sendfile64 root/klinux/fs/read_write.c:1424 [inline]
> __se_sys_sendfile64 root/klinux/fs/read_write.c:1410 [inline]
> __x64_sys_sendfile64+0x117/0x130 root/klinux/fs/read_write.c:1410
> x64_sys_call+0x1cc7/0x1ee0 root/klinux/./arch/x86/include/generated/asm/syscalls_64.h:41
> do_syscall_x64 root/klinux/arch/x86/entry/common.c:46 [inline]
> do_syscall_64+0x75/0x2c0 root/klinux/arch/x86/entry/common.c:76
> entry_SYSCALL_64_after_hwframe+0x76/0xe0
> value changed: 0x000001b2 -> 0x000001b1
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 12 PID: 22653 Comm: syz-executor.12 Not tainted 6.6.140+ #672
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/vmstat.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index cb57714539fb..a3e809c57f29 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1837,6 +1837,11 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>  		struct per_cpu_zonestat __maybe_unused *pzstats;
>  
>  		pcp = per_cpu_ptr(zone->per_cpu_pageset, i);
> +		/*
> +		 * Access to the per-cpu pageset fields is lockless as they
> +		 * are used only for printing purposes. Use data_race to
> +		 * avoid KCSAN warning.
> +		 */
>  		seq_printf(m,
>  			   "\n    cpu: %i"
>  			   "\n              count:    %i"
> @@ -1845,15 +1850,15 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>  			   "\n              high_min: %i"
>  			   "\n              high_max: %i",
>  			   i,
> -			   pcp->count,
> -			   pcp->high,
> -			   pcp->batch,
> -			   pcp->high_min,
> -			   pcp->high_max);
> +			   data_race(pcp->count),
> +			   data_race(pcp->high),
> +			   data_race(pcp->batch),
> +			   data_race(pcp->high_min),
> +			   data_race(pcp->high_max));
>  #ifdef CONFIG_SMP
>  		pzstats = per_cpu_ptr(zone->per_cpu_zonestats, i);
>  		seq_printf(m, "\n  vm stats threshold: %d",
> -				pzstats->stat_threshold);
> +				data_race(pzstats->stat_threshold));
>  #endif
>  	}
>  	seq_printf(m,


