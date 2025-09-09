Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D77CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 22:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD75E8E0011; Tue,  9 Sep 2025 18:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD3D8E0001; Tue,  9 Sep 2025 18:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC3CE8E0011; Tue,  9 Sep 2025 18:40:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7E7B8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 18:40:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72D18B9CD0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:40:06 +0000 (UTC)
X-FDA: 83871181212.06.DD80159
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A3C2D140014
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:40:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhKtnfYh;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757457604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n1GHlORojKuHhY1MSxjHkY19dr9A8tnZbG7+/tCDdG0=;
	b=wSEwPMQp3FhntEHR5q4LW0qdwdJKDxobjSuELC4mEL1O185LVwufcq1VXpLzvYt5HJSn85
	2gNdsPp4NMeioy6Dlg+kEHCMD5Un4yTMe5tDJ6AFhxL+Y+UT5LEhjo8z50MQHlx3TUobop
	U6dmYcVkhxF+cerJ0IOWDWoP1BBMZLU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GhKtnfYh;
	spf=pass (imf26.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757457604; a=rsa-sha256;
	cv=none;
	b=mREu1Bu9PLRkeWzA2EhAAUS2ilGEC3lwnT8lG0IizhMJD/u+c62lraCHzs9H5JDlyXIh7z
	DGfM2Y1cI6Lmy6uqrk3sOdQufMBNsvdtgoxbP11qkNeyGaBGuEpidvBdUBXqubinJjsMN8
	3WbW+QN9yP9gO6REuL3oYLFbu2pmAk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44DC94086C;
	Tue,  9 Sep 2025 22:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1897CC4CEF4;
	Tue,  9 Sep 2025 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757457603;
	bh=hRjhnxUm0trj1HOY3MfMFjeHMWSzbkL2aSDIg0le0lQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GhKtnfYhpKBtZR0b1nh3HbaUzJ9RJbpRBUjJM9RincgI48FyVqvSl7QA6e0IKqtMB
	 IXbAeiSX9pWRfQ7vu5GsbHUxcw9C2Kq4wSgJKLnGrNpRRlzBp5Tecyezh+wDoE7Woq
	 Pj/akrdRZbE3BrGIdsDLgk71l+0KGov4SJm70NZnKGQKARcC02p/al6bvlY2syJExX
	 GnTd/AyrHOG3V7eOM50B5Tk4deQNhFe+biWHJrDBAdrpQppR0LN+0lRc0IYPDw0gev
	 yjwPLrNsOVpG5vZow3JtYUaaOsIuLJlHkK6Ei26MIAnE76efBsmAmPmspJS4+lGdIs
	 syLvfWi9Jvoqg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70FAC383BF69;
	Tue,  9 Sep 2025 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v2] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC
 in
 __bpf_async_init()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175745760626.837268.10273222616654949199.git-patchwork-notify@kernel.org>
Date: Tue, 09 Sep 2025 22:40:06 +0000
References: <20250909095222.2121438-1-yepeilin@google.com>
In-Reply-To: <20250909095222.2121438-1-yepeilin@google.com>
To: Peilin Ye <yepeilin@google.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, shakeel.butt@linux.dev,
 hannes@cmpxchg.org, tj@kernel.org, roman.gushchin@linux.dev,
 daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
 eddyz87@gmail.com, song@kernel.org, yonghong.song@linux.dev,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@fomichev.me,
 haoluo@google.com, jolsa@kernel.org, memxor@gmail.com, joshdon@google.com,
 brho@google.com, linux-mm@kvack.org, leon.hwang@linux.dev
X-Rspamd-Queue-Id: A3C2D140014
X-Stat-Signature: 4zwqb3om3p9ynfu3e6oqkzitquqcw7rp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757457604-313854
X-HE-Meta: U2FsdGVkX1+nueAL2im78quN/d5Nj1AeY00GvSsrzbWlIktSS0zzi5jDi+EGZ+9EeG8Hog22gODiZ5HLlpav/X+2Hsspu/bHlSaS0wB70CGMsHVqGJm9T2JWzdxUwqVYAJGxm2UKgkgkxCsdzVJYSBsQQuR+DHgx4AW6MX2r2zY2R1yeiEPZNJQoReOiO1lE329qIno+ZCv7VazK1PlvxYZsACHCFssWq8B8OpApKzKef7mriU8ntY1US7A0+F+kZ9KkSQDPvJTLHBCbN5ZnyIQoldlyk5CVBxaxwg0SSIabN429Wo0S3ffgMoTT/w6VDS9JRU+EQEL2/Oe+HB5wPO/zjSuxasqx1DClBqZEtOiAnHwLlkXFDMHBFhn0JFWg1es6CpbjOU3k2TMG3UFXCLaE+ZRhT8MuAkjb7FGg5FaNfaoYDe/ooMMJsIpjekq1/cu6KcpI1P1JJ0G9D+gAvg1EYZnJwDaM9LXP4FTjpZBNrPdvwN8W9GmhhqTXYBq4dyKXoIlJJEqdiH6omVePTP5oyli2O0bn41KL6elBz0oPVCn+AA27yDbN410NK6DNWzv8fwm43/zFz5EtdAKuMvqsas0ZXVwwHfd5rbwWOQ2dsyOlnd1uitdKqITkDKDO5vPk9NmXPVGTX+jXaJZcGYeuG86+kqWarmos4fLRVkHcQHPyEuFrbjQ/BpMfGShssEqO/lifIXL2NlJhUDIsvd/zErha3TcQnSrxlM2WE8fpgCrjn4FJ+H0K0fjzLGxhs7PGcVQcs9oKCN7Mq5dC2zkzF+pGDXSLMT0LpeCkse2a7TC1fv3OFnTQG1dTlNss6cIMKfhKmIWYO+Jsmwyz9BD1DSVor5nAZAqASR2qVGOpODkRxw3Bm1FQntP8AaCsETOvKNtDdGZ+Z7n9Oeg3e6hd2vPXVyalFYfrmiaMRKbYyyofc8/Pt0/ICin5DqhjER3EvTM5A7gtJT0Hhzr
 BpQN1zBu
 wCch1BPJaVstlLM7yiNYFi/8H8uwjhHP8/2GTragJl3NjU0NbYUwresqszkPOZhvnYffpXWlOP5cm4GfX4vcXs0RYQQ2+mui+AYjo/GmpAT02geH7oYV4maGU+YgQVlgPwbRr2Qd2fx6CUSjrIIu8W9BZWRdf4Afr232E22XLrn8UT7IQW+MLMLVuEvf79+xBIxVULSRX7EXCGU5CM12Eh1/GB7ihKRKOCZGyC7GI4FPQWv9AYegxqbaXKdR9NFWDTuhnhpdBJwhUCLHVQQk2wE2DetxsIa+f1IAl7IwZHRzZq1N5hLBMjSVWeI8Ar4mTTgqffMc/8i4p2vmnx4gycYwuw4e4TXvl0fwqJVtzpQszbVqZdBbe3iCR62yduU5hJ2gtiuM7daUv9d8iyJU89k7Df6wo9nCxWai4c+E1k6wFSYiVw82KORTWm/pDe7zBieUBFfd+70+P4Q9Nf7l5CJ/Z0KzgS2GLngexXdi6fNEyOek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue,  9 Sep 2025 09:52:20 +0000 you wrote:
> Currently, calling bpf_map_kmalloc_node() from __bpf_async_init() can
> cause various locking issues; see the following stack trace (edited for
> style) as one example:
> 
> ...
>  [10.011566]  do_raw_spin_lock.cold
>  [10.011570]  try_to_wake_up             (5) double-acquiring the same
>  [10.011575]  kick_pool                      rq_lock, causing a hardlockup
>  [10.011579]  __queue_work
>  [10.011582]  queue_work_on
>  [10.011585]  kernfs_notify
>  [10.011589]  cgroup_file_notify
>  [10.011593]  try_charge_memcg           (4) memcg accounting raises an
>  [10.011597]  obj_cgroup_charge_pages        MEMCG_MAX event
>  [10.011599]  obj_cgroup_charge_account
>  [10.011600]  __memcg_slab_post_alloc_hook
>  [10.011603]  __kmalloc_node_noprof
> ...
>  [10.011611]  bpf_map_kmalloc_node
>  [10.011612]  __bpf_async_init
>  [10.011615]  bpf_timer_init             (3) BPF calls bpf_timer_init()
>  [10.011617]  bpf_prog_xxxxxxxxxxxxxxxx_fcg_runnable
>  [10.011619]  bpf__sched_ext_ops_runnable
>  [10.011620]  enqueue_task_scx           (2) BPF runs with rq_lock held
>  [10.011622]  enqueue_task
>  [10.011626]  ttwu_do_activate
>  [10.011629]  sched_ttwu_pending         (1) grabs rq_lock
> ...
> 
> [...]

Here is the summary with links:
  - [bpf,v2] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in __bpf_async_init()
    https://git.kernel.org/bpf/bpf/c/6d78b4473cdb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



