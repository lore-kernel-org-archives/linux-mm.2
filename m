Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0FDCC6B1F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 02:48:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0776B0088; Tue, 13 Oct 2026 22:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2CC6B008A; Tue, 13 Oct 2026 22:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2AC6B008C; Tue, 13 Oct 2026 22:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C941C6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 22:48:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BA631603C1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:48:33 +0000 (UTC)
X-FDA: 85319698506.26.D6C9635
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf08.hostedemail.com (Postfix) with ESMTP id EECD4160005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:48:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kk02qkMV;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791946111;
	b=ANO4+qZYsJQQZ5kOJ6WK7PQ8SJvbs/5sLmAJzXi+3Kf4gI338HFqs8dlH7IGh5zcOugxZe
	wnRRT9A7RziUSipU7/JF/HrK7Z9uO6NznbWybKuYktPr3i4ux9YJ6N5zkJPTlPp5Bilfp+
	qbYwFjLbG5Kac9WEACw7xBEm8U0ZKwc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kk02qkMV;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791946111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4z03Bv7bkdYx9bGLqVZqYE+4w8O1MxHE2dIRVvy8jc=;
	b=zcfTCyW2YgS8GSpH3nWBrNHiu+DJ32UKZJGKmTiUX5TBjz/0PGOzFgUtMy26Ow2BByoBuw
	+IBT4CtTTPfRf5olWeGISla4s0R9uFgaSOhOCRfyG2CEjaDcf0/tqSO4MnEXkRxDYZ3T0+
	Z+afp9rKefJQEWOV/xu0mBWyxKEjFYQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2kHoms2QSSahMaMVeqUufPLoRe85ZbbkTBqAyiaowT8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791946109; v=1; x=1792550909;
 b=Kk02qkMV1wnrYkoj8hoDrlMuw8WCNtXDUrHdEpkGmbHIkqWbFf4lOt7+YT2Z2U/xiEFZxaco
 Szv5SlUvGoU/TgfbXb77JE9WqN1LAWpUwpm01sGDtvHp4qmbOyQhrmIkFcP32mgL1VDBypSK8rF
 IXSbv//6P6ONuIu0/0/IqgtA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e25af03395e5a192;
	Wed, 14 Oct 2026 02:48:29 +0000
X-Mizu-Trace-ID: e25af03395e5a192
X-Migadu-Flow: FLOW_OUT
Message-ID: <c9799efb-a002-4925-959f-c9a2b883d85b@linux.dev>
Date: Wed, 14 Oct 2026 10:48:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
 hannes@cmpxchg.org, mhocko@kernel.org, ljs@kernel.org,
 roman.gushchin@linux.dev, dave@stgolabs.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
References: <20261012022917.1102467-1-vernon2gm@gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261012022917.1102467-1-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 76zx3xqbrnm3prdz857yb7z78nusu5f7
X-Rspamd-Queue-Id: EECD4160005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791946110-362699
X-HE-Meta: U2FsdGVkX1+2ZRY27Y+lPTn+Fot0m14YauEFTPuVnZoE1omXgvpKtElKXcRLsB3ErS+ENTLRe8f2PRptG1vEPYXtCmoKb/+LmnVJAC0a6y+Um85igwxupEsjO2NnMRwEdwSdFtvDt8GTESv6nFlS3p5OyM2VyIsyT7dcerwntQfH1Z44W8S/sUd5qS/x/hXmCCRczYtpUvn3NXrFRq+hKFpOkSGYJjwxIGpgu0IUjR60BLgyww5L0XwyKJLBPJ0EN+oIXz+xF/RedXpmZ69hYx2qZGLMKHBdczoD7r97x13SrTD3KFxCPSwRvaNTqmGQ7/sqYamU1ABHvnLfXDA6sN8nbpZxXmviwMa8DlH6WU8hK8awyqv5IZmxaXue3fvCixlMVqSCVzHfU7/4W0BRKg+MdUGbBXKrXvW/CVMMHpspxcBAT3d4yqi0aRoRbq8KtZYH95D8JoGfQorzRFV7FPOOWPmvzdwn3+w5KYf66b4KxsL3f1bmQA3WKDz5dL9Myu8tEHvlbkumG1XKoT76mi/OtUdENGZ+Makr35YJy7WfnVp8ShFaSwtX2GhBZbazRERsnY9ssBraC0LAzD1TXTxpi6ncdyPB4UyqptV4rj1HISYVVVFMmew4RBx0aB9sqmqVfa0e81I3SJ8Z6dE5/C4tRWBMWR9qTdTGxOjqbV7w/rpu77fPHQnZAwbFOoGALkxLQ9bqFuUH8bxtcnkg9iWAIJfs73Ze8rYatCLE9mSupCMAgOe+sMwA9FMGq3vyDeHWIeg5vw4ODArI1y3LYOWHCE/rQLY8Kyb66eE3QVcmZdz8id+aKWLWpAwgceYqg+AyusrehRFu6fV/E9PXxHydguFfBtp+hxE4lV+jMkMjRbhhoSe6jn/AtggWOTusUnt/PI+yHEEOFyCpAuU3LDOCDt//3gub3oLYeA4LlSuV25/rT527gJJ6H8ZDIO+Cb9rnHF1HeeJ40itG9RJ
 rYtZ+Gd4
 GroLY1cXzVex1gUq7NBz0EhdosFGQz9q0cpgqSpklK5ccO0qs4EM/uA+X1GosK6NjwFNjBFX8KvqyeCwtb+fu4yZzgUregcubtvrzFQQdmBrAehvrB8r67QNAv8KMkmWQFntEposNtn6F671F1zI9hDE640NHYLBx49v1iics8Cm6cQESB5YF+9AgXar4Bih+gndop/OdnOVPE6a25CKYkCpJFS3lx0rkTJrt6tsuchv8mtBP7K5dwFKJF6tK9eEN3dWW9i6x088lhGSrbHFWQBNEUWenGpjNGcnWkr1ZkN0NQD5I3Ig9GQR8CunC4XkINvkOkgviotjBlsPpKz+/lYvP2bPk3JyeQk3I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/12/2026 10:29 AM, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the cgroup has no memory pressure at all, writing to
> /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> NUMA node, causing increase in the writer cgroup's memory PSI.
> 
> Due to this reclaim is performed in the context of the write(),
> accounted as memory pressure on the writer, like
> commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> as memory pressure"). This is unexpected, the similar scenarios (e.g.
> senpai) will continue to occur, only this time it is for the
> /sys/devices/system/nodeX/reclaim knob.
> 
> The Documentation/ABI/stable/sysfs-devices-node documentation also
> notes that "This interface is equivalent to the memcg variant."
> 
> This patch unifies the semantics of the memcg and node interfaces:
> per-node proactive reclaim is no longer counted as memory pressure,
> and the per-node proactive reclaim interface no longer produces
> phantom pressure.
> 
> I ran demo[1] that performs per-node proactive reclaim 10000 times
> in qemu, writer cgroup memory.pressure as follows:
> 
> without patch:
> 
> some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> 
> with patch:
> 
> some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> 
> [1] https://github.com/vernon2gh/app_and_module/tree/main/reclaim_node_psi
> 
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
> V1 -> V2:
> - Check `sc->proactive` to differentiate between proactive reclaim or
>    page allocation. (Thanks Barry)
> 
> V1 : https://lore.kernel.org/linux-mm/20261005062236.564210-1-vernon2gm@gmail.com/
> ---
>   mm/vmscan.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 91295070ca33..2e9ca5e4c741 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7994,7 +7994,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>   					   sc->gfp_mask);
>   
>   	cond_resched();
> -	psi_memstall_enter(&pflags);
> +	if (!sc->proactive)
> +		psi_memstall_enter(&pflags);
>   	delayacct_freepages_start();
>   	fs_reclaim_acquire(sc->gfp_mask);
>   	/*
> @@ -8011,7 +8012,8 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
>   	memalloc_noreclaim_restore(noreclaim_flag);
>   	fs_reclaim_release(sc->gfp_mask);
>   	delayacct_freepages_end();
> -	psi_memstall_leave(&pflags);
> +	if (!sc->proactive)
> +		psi_memstall_leave(&pflags);
>   
>   	trace_mm_vmscan_node_reclaim_end(sc->nr_reclaimed, NULL);
>   

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


