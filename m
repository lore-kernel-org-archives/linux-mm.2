Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CCED6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEEBB6B0311; Thu, 22 Jan 2026 13:52:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6506B0312; Thu, 22 Jan 2026 13:52:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFCD66B0313; Thu, 22 Jan 2026 13:52:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB9CB6B0311
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:52:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66C1AC1E6C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:52:19 +0000 (UTC)
X-FDA: 84360495198.13.4C123BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0E7680010
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:52:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="kLHOh/un";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769107937; a=rsa-sha256;
	cv=none;
	b=UikAf6B5q69BMcGWxvm0YhoBgLv41MekSvyJlGGivB/pBaPnMwYtrDBSzgBCGMeo9q8sD+
	/hUPWvdckTZLInWrYO09NApV2FmqXs06UFv/JdFSDZZaimKdH4UDODCzLMfmcE8FjRMfo2
	QrmP80rwZjJ2NGi08dQ01YPRjMiYDmU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="kLHOh/un";
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769107937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouWHns/1rNGcdWc5hwPWG4tNSf9Ww6pfuTdRtYtm+mY=;
	b=Vj4HEuOAFSY9H2YqDbnwSfOxflRBXif1G/9MdXz/FARIKymBYWNEqjdQzMFYwU7l647lFj
	2u0ZowQtC3D30PZYfYfliL4Qb+TSoINBxWN87taLiQznP9CJ/9m7xmXAAj4mlFQiSKNLYP
	K6gURAFsBkGtL3Y2RB140b237SauL0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5EBE6012B;
	Thu, 22 Jan 2026 18:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26273C116C6;
	Thu, 22 Jan 2026 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769107936;
	bh=p7QDPgg55RjVmOpJOuHBXK0qFxbkIbuGm9FcitbdG7c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kLHOh/unMENKI71Mu3xkAZRuA/gI4i3Q8mhBdiGY/HmFlZfv51QdeMDS25fKOC1JC
	 vawtFNLQY3o237Aswrf+W3rfpM7bb8Oo01oiw2hGS+/JlbBymwbnbtfrK+8JyEaiqH
	 o7n32mh+uzQwtRuDdrIiAToeXsJQYTSw9Y5rl1vo=
Date: Thu, 22 Jan 2026 10:52:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 mhiramat@kernel.org, rostedt@goodmis.org, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v5 0/3] mm: vmscan: add PID and cgroup ID to vmscan
 tracepoints
Message-Id: <20260122105215.6648b22da4c857a3f071bac8@linux-foundation.org>
In-Reply-To: <20260122182510.2126-1-tballasi@linux.microsoft.com>
References: <20260115123809.2257-1-tballasi@linux.microsoft.com>
	<20260122182510.2126-1-tballasi@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D0E7680010
X-Stat-Signature: 8uo5fo7puhksx7c83tstmf1mewmzjzok
X-HE-Tag: 1769107937-366460
X-HE-Meta: U2FsdGVkX19QU7SYo0J30JGrrtNE1wkQzRssrA/6QvcXuu6lO/L68x7HgJx5cOAMtJ2J0DNZehZD5NTTKMWfODlIlMld7IfmsV47dq5oZq3/S1N1iIRIi3yzcbc3SwycU0P/IzRbu03FlYPy6MPKMCoQUHsCzEV/eonjrx8IHo/uDPs1tn2Rjdq0GK8yTt1wEduDWz4EUVsnodr9Ztq5xQ4EqtJyJH6j4VWmEM3gHsCB5uThZF8yw09LxabEeIs0Cte6vPaTop/jt+n3u17VqrNInBAYPG0zL42sHQByCH1gNqc1Vz4fe2hbhKlWntz3z71pumsqbEU7WU1414fHhOkgnQd7pal66zlbeUtK5fRN8YcnpL7ZkqHWIjybUnRV+FHy42l5yNcI4E5Ua+lLRtiB+dUTBvl2RKjKlzxC6U7BeyqbiudN/GZtsyt1vtm+L9anad6vAJiLmH3oa/w5c6AfKZCrfmfLyu5bzhqLWuQHGR8St2mdBWXejsV3r1jKydQ+/uyWA/P5I1UaycFoeidVf31ianKYJHcyuzEb8o3sOjZbxT3SKx4UQjpTU5tUWEirjf8E9lUHGSyBQlXL3s5snKItMVhk82JFx6TWcx8KH+S52geUmPEbVXF4orUUZfVhmmFFxgUiqnjQAyyRLHqCLqcSRvF1wCVBdYqXp2YcMkRv73fZXyYr8Q8u5vfuuGCSofGuVrr/qhZQE8Y8p24wWNk1pDS8d2Otx02K5uMhrOeeb4UO6lcyrpCedzR9aZ929WYkucz9+VTz7vCL+nznsAszyTVZ5H847YYNYLTT1W/JK6UiGdzFL3jYUqITItPxDrwz/jGdd0V0hZgCwqot7rwqhqFAosPq00nVvs4ZTKQvxv+NqKtr4O/tag5Nu6t5jFo3FCUlTSho4lSTOw+ESo9TH+n3xcwKb/PP1wK0WkjRGheBRCUCfaeCQOthy6/NCRo9/4zIgmXKI4i
 99rm0l5R
 cuVs4LIjhNz9QsgHBe53KnJGYui5nBduAC8FcQaAbal+I1tiF7WqwbNz+/0Oo9fYHECCsy+7YjcPiC4EnLeY0g9S8dZw+KnoBkcSW8AOT4UNgxPfHcsS+uxBeqMUhFKyRa1SZ8UW3jglUIwwWyo9xKyPE/xSU5M5KdwuizBqK+c1tfPIDb7W3FzspAiXnm1HYqfreWU69Ye5iq22P9HolulD4TtuABEZFGg0HbmtPPBZ21RIR1U2Emhqq78FZphEpt/LTWA/W+u4/u8KCG55phymqMR6c70ziu6qhCfDktULno8trmR4SmoK3LVj/TK3wABUBQw9hwp2mPbTforW8MbeGfYj1YExnK25yRi3s8odNimnbiBaZy/FtHhqNJXoolBpP4t19cpU50xY/8jhW34CdUayNdplwYAdOmd/cmE0wpFbrdowGYfUG7yLYbF3a3/1Zt+okR0lJFmalQJ9Ry+znWFo4sHcZIlOdwEzHjhDL8TU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 10:25:07 -0800 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> Changes in v5:
> - Fixed a small quirk that added extra +'s at (in-irq) warnings
> 

Pleae cc the relevant maintainers on vmscan changes.  We have a
veritable army of them:

hp2:/usr/src/mm> scripts/get_maintainer.pl --no-rolestats --nogit -f mm/vmscan.c
Andrew Morton <akpm@linux-foundation.org>
Axel Rasmussen <axelrasmussen@google.com>
Yuanchu Xie <yuanchu@google.com>
Wei Xu <weixugc@google.com>
Johannes Weiner <hannes@cmpxchg.org>
David Hildenbrand <david@kernel.org>
Michal Hocko <mhocko@kernel.org>
Qi Zheng <zhengqi.arch@bytedance.com>
Shakeel Butt <shakeel.butt@linux.dev>
Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

The first patch should have your Signed-off-by:, as you were on the
delivery path.

The patchset looks sensible to me - I'll await reviewer input before
proceeding.  Thanks.



