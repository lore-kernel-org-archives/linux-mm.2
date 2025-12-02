Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D9FD12687
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 23:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E6F6B0010; Tue,  2 Dec 2025 18:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66636B0011; Tue,  2 Dec 2025 18:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA35B6B0012; Tue,  2 Dec 2025 18:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9F836B0011
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 18:12:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A55A5885E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:12:09 +0000 (UTC)
X-FDA: 84176081178.11.C6B2FCA
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71662140013
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 23:12:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EapuCEfR;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764717127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xnFBORuZ6ngaKR/uhhUBVVKjmGvNc8Ti2cvoD5Olcc=;
	b=T1Zoi07K8sSwzh8EummLVoJPIm6RNDI3D8QttXAQEF7sNy54+83XlaDK41MD9akTCtlcJL
	er0D2QusqOel6gYTa4jq5VetJmO/qRDVYClIrSEw12nc2BRhs+zI5/obco7Ug+q1btFu38
	LTAuYb1nVL4WHvh3eZzvFrFKlmLd8k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764717127; a=rsa-sha256;
	cv=none;
	b=8UeV4r4ory2hdZEljT8UkKmayRRjE7GCAUTZtFtZl3PUlPm4fu6YZLOYR587eGlQcm4ROL
	8tO/N9qkBGb8gy4KvWFpaqp76jUy/97gkTO2EdfWQ/ZrnKP/QmquWALz3OmqItPCxX1rgq
	uW1Yiotd30LfSCHZ5W8Sic7l3XlsqCI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EapuCEfR;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 2 Dec 2025 15:12:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764717125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+xnFBORuZ6ngaKR/uhhUBVVKjmGvNc8Ti2cvoD5Olcc=;
	b=EapuCEfRnurnBKjqKLc5ANQkfN4J4DSkmrrhz+Liy72uoxFYzKLxAYfz+62OE9BOc+njH0
	wZRwK0Bfe7cYfr3vEOvKMZotyrQoiISFRTZas6ZPXAWGPM2H18OdkivEJW9Z6QQI3AOv2S
	PE2U/Plr9Bk2q1hlkeYIOf+VpbORRYE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, mkoutny@suse.com, muchun.song@linux.dev, lance.yang@linux.dev, 
	shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] selftests: cgroup: make test_memcg_sock robust
 against delayed sock stats
Message-ID: <me7djjzkgufieiyvrsbezi4i4t6v5zsbonirjlacce6hgilb2c@sxnifdeh2gnv>
References: <20251124123816.486164-1-zhangguopeng@kylinos.cn>
 <20251124123816.486164-3-zhangguopeng@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124123816.486164-3-zhangguopeng@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71662140013
X-Stat-Signature: mginwy4nsk99uckk85d1exqrzshynt1r
X-Rspam-User: 
X-HE-Tag: 1764717127-954349
X-HE-Meta: U2FsdGVkX1+ILokqxNoe+R8KEvHL4GKOpSgMEhD6Ms3LLN7zwRd2O4hwoY4KJJJgXDjyQL9xOrwawhET309qVyD6IV+SUozkdP3mH3MFStaF4HyhhaqgBU/bNI04EN7raCFzKvsPgzGB6B7sYjZCu7Ti8QWEp6doRqsNUQm0Akn9sEpf4nlgQHtoLMjaKMuz3KFAdSthJ7t2jW32FEhqwWpfGnqXE13vGxSyn9lQPAnNxuYWEGssQyXqziZj3U4AP9ZElHhTDcCscmS1kGSMDfWkSc4SNyUg1MX7MVaIcAzl9JJXEJ/faKHjBy0TcEmjo2MhM+oLpQk6WuXsYtB+NBIhU8UC8+bdIiW0LtKVNuI9NC9GGhTWp10zm7yfgCyHL1O/mgZrCjwHMKyR6s47p9y8kMZoS0nzSPR0RkbEAk/3UA10Vg1sjAVrYhVuh/pDfnmGPFvQ5RUpzRHlswpXIhjMmaw7jXKc/VZkAX/XhanUxH8vCtr1FfIl85a5N0YjkNrqRjqyWcoNmveczibXwqcBc6xoWbi0FErpIlZ1dXNDcjbsrJhFcwabbG3UJd7mUuWUkI03GC0tEgfbjgIj5Y/miQrc+time0XqGXJvzEdGstaDls1JhtxUmCssVqA2GV7Tqw5nyqE2JB7UW+mrSU6W0dF3Y5NYn3X2fVPqJDjz+x13MG04JukaYA3KgDNy87SaQNDtw3wg23H5UZYHMh45eljhzka/Oh3Xnf8is+OshNmIfX+D/lWMYDOodCDfiv8ANks5JLy46NcsOGlXu6LL+MFsOapfVBqQ3GeSF78JxHkPA+b0UaGkEh7YybTvpjfT45cH/X1teuwi+PKBZng9UwYlGKmbtPENDrlFuMpIbBK9GUc2arg9LArEZ2Xqmagi+LR0N+wANxeL8HNSsX9USYSZg29/o/lV4Wiu5psX3ZdzMSpSsvIONfvcsy7aTIVJJbd8G7lgANWaUi0
 ZAeYBak7
 FZecFKQKI3cvMcrDOfUSXwsdz7oBljwfZAneY1VfS30z/Wfz5JjqfdL6LVdInpDf9LNOx7t1O5sXCDugkHD2LSbkDaitvL9qzeH9uMLkJFK87jU0080mjXG+asu2sYovxo0X1BlEloe/gR1/xsJCeO5tAupRs2FviLUWRBrlLUHW1D6Ep+G5iLDO7Ch122wXbwjSMsKavdbMTLxaUPpeQP/dWbFU1rT81MDGke4qpAn1XF59SosIx1hjpSqU7wRymvtAE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 08:38:15PM +0800, Guopeng Zhang wrote:
> test_memcg_sock() currently requires that memory.stat's "sock " counter
> is exactly zero immediately after the TCP server exits. On a busy system
> this assumption is too strict:
> 
>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>   - memcg statistics are updated asynchronously via the rstat flushing
>     worker, so the "sock " value in memory.stat can stay non-zero for a
>     short period of time even after all socket memory has been uncharged.
> 
> As a result, test_memcg_sock() can intermittently fail even though socket
> memory accounting is working correctly.
> 
> Make the test more robust by polling memory.stat for the "sock "
> counter and allowing it some time to drop to zero instead of checking
> it only once. The timeout is set to 3 seconds to cover the periodic
> rstat flush interval (FLUSH_TIME = 2*HZ by default) plus some
> scheduling slack. If the counter does not become zero within the
> timeout, the test still fails as before.
> 
> On my test system, running test_memcontrol 50 times produced:
> 
>   - Before this patch:  6/50 runs passed.
>   - After this patch:  50/50 runs passed.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Suggested-by: Lance Yang <lance.yang@linux.dev>
> ---
>  .../selftests/cgroup/test_memcontrol.c        | 20 ++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 4e1647568c5b..dda12e5c6457 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -21,6 +21,8 @@
>  #include "kselftest.h"
>  #include "cgroup_util.h"
>  
> +#define MEMCG_SOCKSTAT_WAIT_RETRIES        30              /* 3s total */

No need for the comment at the end as it will be stale when someone
change DEFAULT_WAIT_INTERVAL_US in future.

Anyways it's a nit.

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

