Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D7ACA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8578E0007; Fri, 29 Aug 2025 19:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F808E0001; Fri, 29 Aug 2025 19:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DCC68E0007; Fri, 29 Aug 2025 19:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 765358E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:20:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E19C9160991
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:20:39 +0000 (UTC)
X-FDA: 83831366598.12.2D522B1
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id F1FC920004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:20:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAa8XrSu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756509638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kh81RZzZpiPIXslFRnG6rVGhlxEMq1kmBomjyvChOoo=;
	b=Nm1RA9UCA6M61sOj6aJKsqWxHMGx536ju73VGXW5Y7BDdkEKhfGvVIxTPp4a0XXcAJ/Z9I
	WkoK6q6CvTIh/u1xOyBSrly1VDelq9X/twvmo80i8xCDu2ygo30NnBJQ5LI7QMG3VaJ5Eh
	Ltpd4y9yDZGGRcYVIRq8Iqe7X+sQ6ug=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NAa8XrSu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756509638; a=rsa-sha256;
	cv=none;
	b=mZbKrBkObvSedPOSQAKFWLQPxsQneJbm/vM7OHYTcluabbAznCiok5JENaAajdgECwY0bT
	1TKCbhqo7JJ9c8rhLOGtrL+CWHx5BiYUgJvJ6V5ZWU1R04d94qo1cNp3yQID2ZCrhnjDBn
	v7k2uY7Fmg+zex6+y7XT8i1STf9Wz0I=
Date: Fri, 29 Aug 2025 16:20:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756509635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kh81RZzZpiPIXslFRnG6rVGhlxEMq1kmBomjyvChOoo=;
	b=NAa8XrSuTmfZlqPQgBBj09AOVxU4pwSzGo4oJBiUrceLy/eecA5iyB/uL5oOGh5Mi0bu9o
	l1Q6G36QIR7zYO1/yS3pnuoJzUYypvb1V++f1KGRD1N6UxquIiIZg+zyobwqxX+U43MApM
	kfGzGtcp47eueHFXJZd+M2oCJyEpaSI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liam.howlett@oracle.com, lorenzo.stoakes@oracle.com, surenb@google.com, 
	liulu.liu@honor.com, feng.han@honor.com, tianxiaobin@honor.com, fengbaopeng@honor.com
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the
 victim is frozen
Message-ID: <krmliemwgxygxkc3rkix5ah6ubzzulpktejdbu5uhpldwtjts2@3sqqkl5i36tv>
References: <20250829065550.29571-1-zhongjinji@honor.com>
 <20250829065550.29571-2-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829065550.29571-2-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1FC920004
X-Stat-Signature: bxzd5h9zi3it6eiufqmf538zymk1wgc7
X-Rspam-User: 
X-HE-Tag: 1756509637-955332
X-HE-Meta: U2FsdGVkX1/4SABsu4bdT9xuWmG72k8fl0qrKZ5uM6QJy4Y0r9NF+CQYPp52cn8hKx+NwCgmL4+MAo5qyJDvBMHp+JmYqXLWPuq+90OFBAN0ZzD2yFKDPy4FwDbej9cE3pr0ADYudWj+JfACyUVGpigVF/wteamhcBjGnt8/RlxdDS8jbLmYY80eecUw+ud0K4AEl0Ebkq+S9hUntRrvfC3WjSq9NVkpVglpie4HhVf8F4Rbuw0oDgRlOjl6bWnVNTZa3JgGFOXEZpPr7lsgfYg1XaenH2OqF3ahxoaqk/HsMa0Rt5kIzYPqTirwKY6deHHPkgX1qS4YCndBzlPLTo4Lq9btM4gM1hvr8M528ZPCN8qqhOuOqR5MMQJmjOrSusk9Yub0eRIJN2KDvNSCUr0MY1WeiDAxcn1YrElOY0ftxv0lU0Bb7boTsz34SNPC4+/MO8MH+KyBgfFtHxMFCx1ySSkykJVXCM0pkxI9ziur4gndbX69LijtKYEjW8i+EMp8Jm1nnk15wN2DMYO+odlUo8t4kBr02eCmguLliVx6kMSEHg2w8pSOjdH/aMcqEuALGp/WIYR3kcIZ8FX9goU5UdBLXDc4Prk2/lKpNpgqo8rQPV2+AYqWbdTsQv5Hj9Wu1sz50L1ek80fj4AshoeY1Y2W+xSilof37LPs3teaRsAI9STjIQDM2GRnF3LIOudSV4GCvBbIhVYR0HNpNUhZVkzbGh6Z3fdSrjxOxgcpL5ZiUAQ8dfe85OFZeen5eda1Q2iGCA6DKlVO5IY7hfMzO6RkgCx9tuY3SXYN85KC9v7wTs4SqDtrR5NhPE0p7XSHD4s53+uLg09+2vI8FCH640OPHmd/LJLMhwCYb33u6bYlQBaMQ9a5R5nNo6U8coM8NtVf9l89h2AikOkQjvfU2r5hIZ8ORtk9hAFhFmdTgkSzIQBYcasEATsG9TDcm1xjMOtVc7OA3frCFjz
 gmWs7Ok5
 wTgR15dmiPCPT4X3QcTjfDTda+6c6B6VjsqN04/9l4Tuw/jEE5af9pAkSl0nSDYSskjTWBOiAngAzuIRooFkl0OFZpZcTcqX6LpLQnfy3marBcrjhZ7Aqy3qvO3xpbeV4HbmkkLr7iqj2KGeSBJUJ+Pdb4iNE8pKZ/SiruDSUC3uCLpTK+1p7LFWtbebG4F0vUqDlfAv5KSwWxHl7ph//ioTCkCeLHSSxly2FDA7iqyBfugc+mh4QqA1mSwOqlUshkTEIIjaLS6/VSSXhH1Nf8sJicoyY9cO4CLpQrUkjxXSUD6aXSSVBjYq2BNKofgGcNPtRaNjgt373qpLrFt4hW76IpTugqWFhbmq6h9iXO9Ivf04i7/zk6zNi06hzw8Mgc5i8LlNOk2Ph1gA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 02:55:49PM +0800, zhongjinji wrote:
> The oom reaper is a mechanism to guarantee a forward process during OOM
> situation when the oom victim cannot terminate on its own (e.g. being
> blocked in uninterruptible state or frozen by cgroup freezer). In order
> to give the victim some time to terminate properly the oom reaper is
> delayed in its invocation. This is particularly beneficial when the oom
> victim is holding robust futex resources as the anonymous memory tear
> down can break those. [1]
> 
> On the other hand deliberately frozen tasks by the freezer cgroup will
> not wake up until they are thawed in the userspace and delay is
> effectively pointless. Therefore opt out from the delay for cgroup
> frozen oom victims.
> 
> Reference:
> [1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>
> ---
>  mm/oom_kill.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25923cfec9c6..a5e9074896a1 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -700,7 +700,14 @@ static void queue_oom_reaper(struct task_struct *tsk)
>  
>  	get_task_struct(tsk);
>  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> +	tsk->oom_reaper_timer.expires = jiffies;
> +
> +	/*
> +	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
> +	 * because it cannot exit until thawed. Skip the delay for frozen victims.
> +	 */
> +	if (!frozen(tsk))

Can you please change the above condition with the following to handle
v2 as well?

	if (!frozen(tsk) && !(READ_ONCE(tsk->frozen)))

> +		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
>  	add_timer(&tsk->oom_reaper_timer);
>  }
>  
> -- 
> 2.17.1
> 

