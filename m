Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589B3CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 10:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B618E0010; Thu, 16 Oct 2025 06:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F31C8E0003; Thu, 16 Oct 2025 06:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F918E0010; Thu, 16 Oct 2025 06:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E93D8E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:42:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DE2C57FC3
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:42:25 +0000 (UTC)
X-FDA: 84003638250.20.F5B4654
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf03.hostedemail.com (Postfix) with ESMTP id BBFE220005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:42:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=qtT7BYAX;
	spf=pass (imf03.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760611343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV1vjNqTC7g0wYqXVbFuuQgO1xGeyPpn8o/0TBe9zlY=;
	b=jF0X3oYy01a3qCY1YWumC8e4LNXdYq6QdVXL/0r5vnkUtV8pBhu3WaauOu8NI47GeEIHsL
	d0P++bHMZLD9hhIu/UDMh0rGx3cYtI76eD6BpzT95eyWUNTdbmzSBlv8ado+pS0J/6fyL7
	PpMhAogGvrpSZLJNsOuP+PJQBysfxLk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=qtT7BYAX;
	spf=pass (imf03.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760611343; a=rsa-sha256;
	cv=none;
	b=k+kz/WvpMc8wWSwiOgaRf692HjCl4pYPUEHHW7Jxxv6wesOEVpPLG3f3IdGU/+lSE8oIiO
	XvPWWGIYlGMnsOSQ9v6O6gmxi8q90F4YInXRkFVhSqcYt5nR1Ar5Off1gPtrK+Y2qaHEam
	KSJ1HOyFHNLw965QqaTp9dMpOQX2SQs=
DKIM-Signature: a=rsa-sha256; t=1760611341; x=1761216141; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=qV1vjNqTC7g0wYqXVbFuuQgO1xGeyPpn8o/0TBe9zlY=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=qtT7BYAXHacUHaOWwcNVZUb+OOX/qRxrW2/MGG4T5N++dY6H7t1qu235QwWdQF3EhSGRB7lZHgdlx8UT6PESarUaRmNuW7QFxA3GaxFo7hN9ZWDKFMXzlWAAHI8iZIp1GMe7npLL4QMpKN0oRpDtxRHlndxh6EF8+3f3SDGsEac=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.2.0 build 9 ) with ASMTP (SSL) id 202510161242190311;
        Thu, 16 Oct 2025 12:42:19 +0200
Message-ID: <59163049-5487-45b4-a7aa-521b160fdebd@cdn77.com>
Date: Thu, 16 Oct 2025 12:42:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg memory
 pressure
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Matyas Hurtik <matyas.hurtik@cdn77.com>, Simon Horman <horms@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Wei Wang <weibunny@meta.com>,
 netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <20251016013116.3093530-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D0311.68F0CC0C.0030,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Stat-Signature: x3mpi6y6xp1iedo1gk44yheyenitpph7
X-Rspamd-Queue-Id: BBFE220005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760611342-501727
X-HE-Meta: U2FsdGVkX18jkvGfYpVx9qmNF3uPFrd/sB3dedaICmbeNOZe62gurfAjOs2Ft+ZlsHxSFw9j5LRLDpwmVa3pfW5ydgtxfsr2KMd1JuC0XzhV9F51qkHnjq6t4HiYi3+3JfjItFn9PWBV2N4XU0h7dENXJVzY5dibhuiKNTsm0YhEoKCU4W78WYjczFQkwZ4bunt9CUbIZLrDUf14j9A2p4Al+qW26DGwrDne8WWqmLQiYOWZCYSGON6KQFuN0K0tPnko5i2Jd960oE5ZjaHuwyAxL6dmDbbQNcrV/UD3AXPdshZ4c/qNrW26e0MXRWwn4xTHuo7S+I1gDQ5wq/u5qkBugP+KbxvStiG68vcmEulaUF7jnxWUg9oNzG7/zt/0T/s+evr+o6fGm70y0stqpfjVkLs4zUniUHsr6EOyqWZxSPEhI3OzqwA9MzINJJI8wzqV3vXvi+9LKnWnzzTrf3QuRuRfBSc9329I+CF74sRZCw81g+t4xwTTL9L/LA05WCa4ZdEeepxUYdp2WmGtnOdWDSOGpj/DYCf2bggTvCjYOFN/BEAEecn828dvk31LfveFYzWLlesvMRUFkSBYI42bWqZe9c0Y7tUBq8t8wjYCUoEzOkXd+Bt7iBaQ/JKHnFCXLo/bgSYS0+dVwY9samzI2N9vkogN8cll5HOVHQ9abeAYNjSym0mjmbdg2IlLWjMyi+K/1zeeVHFeUcBM3pebTU3InSX0uKEqS8vwxZmk3loq/2YT5u6wMz4QWt9Mrl1ehacVJW9DQ+et1A13rRY+rYJjePodPqt+3fISRKo8XXbbI3jMa1c7UbL2WSQzbCVVFg+I/knWGpd8W7BjzCITRaB+nxLlP9laO/x/JMA58TGMIlaxNImsHsIwODWLcGBW0tWh/5iZLzEDeN9oiR6gfVmSw4MO1peT54zI1VBdvEcCuJBi7i/CPSJNLZoKqwaWdoXqVwDOFwWsJVe
 VMgW+pHT
 32S3O3AXii/YI1XAc/Z0qgEUOKcOcaSX2ebuZ/vQMS8L3H+a/t4aEvPnUkajFc52LXhMZ/7Q/R/SlE+BzGWCfWnXa+egaT30kky4vk4NhlpgHI4+w8Q9yoIksEBshuo8zsCHv2aC+dE0n/SkSKc4RKGD3YxfZdcNuLAJl13burOz9xy5HSoHA7c5JiIbzi3kBq9qDpIiJlTpGhpHb6SoU0wWW6VViqrHyDKN+ACQh/PI1igg7cevJjxreGoOdu/FYiADGlaoy+Q7iyvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 3:31 AM, Shakeel Butt wrote:
> The kernel can throttle network sockets if the memory cgroup associated
> with the corresponding socket is under memory pressure. The throttling
> actions include clamping the transmit window, failing to expand receive
> or send buffers, aggressively prune out-of-order receive queue, FIN
> deferred to a retransmitted packet and more. Let's add memcg metric to
> indicate track such throttling actions.
> 
> At the moment memcg memory pressure is defined through vmpressure and in
> future it may be defined using PSI or we may add more flexible way for
> the users to define memory pressure, maybe through ebpf. However the
> potential throttling actions will remain the same, so this newly
> introduced metric will continue to track throttling actions irrespective
> of how memcg memory pressure is defined.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Daniel Sedlak <daniel.sedlak@cdn77.com>

I am curious how the future work will unfold. If you need help with 
future developments I can help you, we have hundreds of servers where 
this throttling is happening.

Thanks!
Daniel


