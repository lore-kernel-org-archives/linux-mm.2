Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AB4C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1BD9000B8; Wed, 13 Aug 2025 13:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38922900088; Wed, 13 Aug 2025 13:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C63E9000B8; Wed, 13 Aug 2025 13:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF37900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:19:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDBC758DAB
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:19:15 +0000 (UTC)
X-FDA: 83772395070.17.70798DF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf10.hostedemail.com (Postfix) with ESMTP id 50C2FC000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:19:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ii8UnpkR;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755105554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1FMi5Yjh1vUlhiqB6XzBhiLfGu5kDDG1EY0MWpuA5g=;
	b=GNaW3WuijdDiOrnb+7CpoFxRHghrho6Z4+t2RtQo3uppAUuC5sASEiGe2cKQ9YSl0SbQKL
	Rer2clr8bvmTKbcPi3ulZRy3zvdlLLqCiomVvZWsij3nQQhcuVsoAQudrSlshD+I8eX8bi
	Q6bga1eZkbIcqQoM9U8BDAuPKSgIfW4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ii8UnpkR;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755105554; a=rsa-sha256;
	cv=none;
	b=W+oRcq5sJCMnJg0GQEiHvCyN1N3hH7idUL/Rw3HkukRgDTNoW4Hx6poZSO1V6wD2ijl1oT
	wSQxcG7QKBy4hVGLv4+dDway6/4yxKU6uwhbT7w4omI2CbRuN3neyM7rar32oZqnBqZEMs
	kBOdTXOxXj7Oa7jw7cWJYCRgZWa3cYY=
Date: Wed, 13 Aug 2025 10:19:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755105548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b1FMi5Yjh1vUlhiqB6XzBhiLfGu5kDDG1EY0MWpuA5g=;
	b=Ii8UnpkRn8GihHXCP3Zq/SnAvVnE3OovoucrWBxYKSrTGYHiRfkf7u46SHtP2x/y6SCoro
	BozREqc2qerr7Q53CpI5AuORNpsev64h/KoMeh2oV7YBavBw/Kz5ZKYVLvJgrWZ0RXtEuK
	7F9Xcs4/yQq3uyzkP/U8Sms1fCzUvgU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: Optimize exit to user space
Message-ID: <hzvjjgzf4cdvj56zeysosb7otkvplbbozzcpij2yeka4a4kakl@4l26obz3karf>
References: <87tt2b6zgs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tt2b6zgs.ffs@tglx>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: u4y1rmirrwe846a9xhibx9w8gkk3ytei
X-Rspam-User: 
X-Rspamd-Queue-Id: 50C2FC000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755105552-572944
X-HE-Meta: U2FsdGVkX1+Tnj5A18dGKjleNHn9YC6AE3gkAKXzmGQu5a/gAlWFALmoRgvzt92laH3YHH5zpTw1fopWR4anZo2HK84VMThj2ob7qw0q+hYzWE1JFoqbRuWziHSylZoWrMBYvb9ucElYXX97xAc684zh79mypKWN7t59r+Pi8tTIr3job9J5LjWjpUI0yzM8akbHAWUex1ejrxxnJUk9OwHvROnl84LzU48ceeRlPKMyPpst5cEnLY21Ct9C2VGsi9iRoqnDHpGGoQAhtM34s+FYilc1ODyNMe/fevFqOCcLLTDtwF4uG+waAL7KaPfAlrtvLl3eiTQgLT6sFgi49jsFB17OKYFCyWW+lLrnTuGb9FDWkwUTOr6md1/KHYDCli/IOpPKV4BaUsrHUM+FCPcGnqnzJENNQ/nzwj01e9IZ481F1+urwxdaYV115lqr4YeFhZRafZD21Pb3Me75uWWbu6qLFvs8x/nFhoxjASxVCt+y2Ye8Vgt3WSlu3f/zvapyZc+P3ooc+dyioZRSNPWO8kzV/uNust5uMbwrcVXyTi8viKuqzTp3fMBh+AiGiJI9oNIniDFQ6bok7uf4aKBWHx8ra3jDn/hahBHipTWBSOlpRy6DAzu4hZAedQLBPQNSnfxO/5fJGwhhwje820uq0cEIq7N7ZcSZ56vJS5C/mtuznWWkJL7+wYL2xIZAyrEYNa/mQroFKzjSAqkOMqDaYdpIu4dM4wuEE+0AZOvQo5t9hmJw7ltmZ7UegtzFKFLXHWT6KU4jPAm3+mwrLRs0BKgiXIaEmwRQhZQ3axSO48o+71OGFiqEngpCLd9dkoVocDy4B/o2t81MOWTotm6lixlmkoaRv5UOM2maLBA/SDSqa4wg8P7GuKGclwmPYFfJvRrkgvulQ0daEHyfY+FJG94jcEbyIyUA4Y64VaeifN9Qp6qXnZ657TP7v7kR1C5a40NuV/1eQhEYPL7
 cJ9OTFCT
 wKf7NuqMp4QH0kNPfCy8nRJiHLycy5WlYdqK1i3cntO9DFIT9NOg7QNx/N/AVU51BI7pw+biKWs21Tq7wDZosyf7X4m8kC48sr411fjFeomtznDN2rfDcfjEiD7lTqfkjp6bJtctHxH1ROefl2ufZH0BOwt8DC4Qp/DhGvhzcCOQLIBIP2kyDsfstrX1ph4NDR/WCTocq88UTEvqNkss/9PiWkDwEIKyDhD0XBXSCnshrqAygjOpoeClQdUlASoAtdHNe3lA7522UawZleGACSRIfnHNdz8NSZGqNgEDxInio/k7caBPiIThByf9jEfYJquHBm9b1jch49vqYc+WO+Ghcc+dtBsq+OO2F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 04:57:55PM +0200, Thomas Gleixner wrote:
> memcg uses TIF_NOTIFY_RESUME to handle reclaiming on exit to user
> space. TIF_NOTIFY_RESUME is a multiplexing TIF bit, which is utilized by
> other entities as well.
> 
> This results in a unconditional mem_cgroup_handle_over_high() call for
> every invocation of resume_user_mode_work(), which is a pointless
> exercise as most of the time there is no reclaim work to do.
> 
> Especially since RSEQ is used by glibc, TIF_NOTIFY_RESUME is raised
> quite frequently and the empty calls show up in exit path profiling.
> 
> Optimize this by doing a quick check of the reclaim condition before
> invoking it.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Since this is seen in profiling data and it is simple enough, I think it
is worth backporting to stable trees as well.

In the followup cleanup, we can remove the (!nr_pages) check inside
__mem_cgroup_handle_over_high() as well.


