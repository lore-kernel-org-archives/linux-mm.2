Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0177CC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 15:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C276B008C; Tue, 22 Jul 2025 11:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3B56B0092; Tue, 22 Jul 2025 11:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821046B0093; Tue, 22 Jul 2025 11:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72DF26B008C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:04:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 234301CECC7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:04:26 +0000 (UTC)
X-FDA: 83692221732.29.8247E92
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6309A40009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:04:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HjIPw5Og;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753196664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DM1q4yZN/WH0WXbOJhikh3el0OxMls4EpUCRVMagXJc=;
	b=UYjBN7CQ86R6mtkHgo9Smm/gIW3wK4WbsNSRI15PI0+tVPSkEhRhjWubt4O+dYvfH+PT85
	lRMRA3795QCwXPbqkupaMCl2tdP6NVzFTm8KBgV7Ld/qWP2nDuCTE2SS6gtiyR4mZXZIaX
	HtmI/hKr6rf3VFkS5QwdUWbe7OwWQnw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HjIPw5Og;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753196664; a=rsa-sha256;
	cv=none;
	b=6xzUfPN7hD8XWDyh/DfCgC0Xfcdw5St2BOUJNeDC9yNPdU6g08cTL+P4maDw4LmZWkCK8K
	yBkqb065fIUSzReqE+XpK9zVqaxMhD3WNhsapDg+ymOSuI/O0hilJxncOGcY9+CdjoL51o
	VYMGqJ2v7gzePOL8QoEskojjNgTgwLE=
Date: Tue, 22 Jul 2025 08:04:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753196659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DM1q4yZN/WH0WXbOJhikh3el0OxMls4EpUCRVMagXJc=;
	b=HjIPw5OgOxP8ER/BTfN1scXUiUd1HYbWSGb5AQu03Q0Lzpeszkmv4tOMjXHzEOpH2GlEgP
	HPAFEH09sdyhwKMz84qO7HnzYIPbD3ea989as18ZLVeTk+a/B3qUrzBv6OVVafnj7+AfoJ
	ZilLjzzLseaSATX3zXENsQ5M/mXxgRc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 00/13] net-memcg: Allow decoupling memcg from
 sk->sk_prot->memory_allocated.
Message-ID: <vokpyz3p5pbv7ja4ltipxapq4xjemqmv26gayezeekcyq7llyq@6kahz7tldhfz>
References: <20250721203624.3807041-1-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250721203624.3807041-1-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f1xqehdax7n67hchx83aao6d97yxshgd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6309A40009
X-Rspam-User: 
X-HE-Tag: 1753196662-813494
X-HE-Meta: U2FsdGVkX19kwMRyuaf30CP0IoNSxBV6v4bWjQAA551X2VO9eFxYWKSIm+XY4F48SgF0rc/Rqeg8/Wq2iHR8GtBvVfRt4b55vqq3/FDL81+SElqKCXdgDbVHbWobG/os4eKWETS2bIDuF/LNtZcoRiTpx0vApE7LDTF4ZorYKHv2Mz/Kslb3e85TiYpqVgL6NCDo5JJ0L8pqFqRCUd0f0f5FGJJGBWyQQ6Or3NgH+Y6jpDP3a7y21gnDaj9cpUNFZlwRnTkGAi+sr1ZHEUn/tYFBHvEUJvKn5CPip1ZSTTCXxlv92rrzdqw8MfJP/awT25yuG10NITq041HwoOmxBIz1mcD10n9+xD5ZwGrkmO6NUG6g9Kc3OeDn/316mtez8tuKuEcpQ/SmUD11vZlbqty9UzJ4NgRYBcKrI1IWFeYqA3gJy3Qygx4h8zPtw213jWJ/xjN0ilqx2HF89nYBLOzKEBXaNnVkWI/QnwjsC9p6Z1IqktZGd2ruEFzigWiXUuqCMJXN9K/V52VAV8dRq3qaQKiZDW04olC5DlZHk1BFu0iI2DTArcQKLTYY2An4Ao8gU2usUZ4ZR02gr7cGRmHNxFeujjB7gMGn/WyeaFqDUFTOxFzDzmRVl0GwmgYntkszH7DDQ5TltRatPlUhBsR84dlXkXB7+g/wMLvH0nZVJi2H/7JS/LfDpk9Fq9+bgAgkUhtrspMRxEhrhZcdgOdANWSuXDmhkAcOvBHYFMJyLw5Dor77lf2GFuFPgfKEASPefzcPfRNgTgHNIgb1IYASL4FLTRNBiTMmJSwney2N2v+VdyK7pnB+oD2oK12OMKzwsgKoMulrS8KjPP/LtaIB6tw/7OA4lm3IHmHo/+VS+VweFiLsGqY7kuaMS/ssec+LlGwnHgBa+be94NdNI0f0ExYhA96/EAq+AWJZMfG2U5ApfVd+zMrAjy2kjSiOnvG3o7+K97TS1hedKwD
 zZpzuwut
 caP3cVoP0NkGFJrn1GbeeFsNOnnxbGy8aVgEUr7JKdtyh9i3QWCinN9wiq0wscXQVaqv7x5MN6fybNNtUd/72UXZXK1U1TFwuJV1B5qiKQ7wHkZbdyi0NM/cAllsq1O3Q74vdaTSlu62/evn51GX2yIg4uCyUVqEWHYnIz3BQ8+yiuqcVeQ1ub91bHRgJ3Vl3cJdCnuXBGix2jgQCrAVDWX/ydUqkXmZTbBp7m+HUZXJw2cG+yp43SGuzg6dezdRbUjNdeD+yWyzEWsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 08:35:19PM +0000, Kuniyuki Iwashima wrote:
> Some protocols (e.g., TCP, UDP) has their own memory accounting for
> socket buffers and charge memory to global per-protocol counters such
> as /proc/net/ipv4/tcp_mem.
> 
> When running under a non-root cgroup, this memory is also charged to
> the memcg as sock in memory.stat.
> 
> Sockets using such protocols are still subject to the global limits,
> thus affected by a noisy neighbour outside cgroup.
> 
> This makes it difficult to accurately estimate and configure appropriate
> global limits.
> 
> If all workloads were guaranteed to be controlled under memcg, the issue
> can be worked around by setting tcp_mem[0~2] to UINT_MAX.
> 
> However, this assumption does not always hold, and a single workload that
> opts out of memcg can consume memory up to the global limit, which is
> problematic.
> 
> This series introduces a new per-memcg know to allow decoupling memcg
> from the global memory accounting, which simplifies the memcg
> configuration while keeping the global limits within a reasonable range.

Sorry, the above para is confusing. What is per-memcg know? Or maybe it
is knob. Also please go a bit in more detail how decoupling helps the
global limits within a reasonable range?


