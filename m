Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02869C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 23:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CB826B009D; Mon,  6 Jul 2026 19:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3916B009E; Mon,  6 Jul 2026 19:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC476B009F; Mon,  6 Jul 2026 19:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC236B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 19:38:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 493A88C77D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:38:37 +0000 (UTC)
X-FDA: 84959968674.18.9B98CA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9629740004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 23:38:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T70ApH+i;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783381115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4RvaHHR1JLiGd+lSbTeUq745Smy4dv+Izz0JZQMDa24=;
	b=0pkpaTRQ6kB87ZnzrGZLdcXEO9esVgPIG1ck4exmnmm9WqZQ3wNuIxNdDERMc09mFcb7TV
	gXUS1yh6wIZkYGpLlnOREeebivwKwIAuRd1gIJBFuV3oyit1YYzCb6mNCyIiRfVaZoaCVr
	Y5HRl28/UHp0ca7+o3sRo6GQ3D+8zyQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T70ApH+i;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783381115;
	b=Om8UMhaxtijcf/Q++AzhfT38JntOgdkZn1uOanXtSIfXkwWPlBnwsotM88FNonyYFBs+NL
	BFGvKFklW7Y2g2BbE0W1Ko3tIVeHAhVxhyrAIVuk8dLEfLW25fcD05Ghlb9uSazwpV5nso
	5Mj+kDsy5UqEgKR4N7HuA16slZi2GXA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D67B4600AA;
	Mon,  6 Jul 2026 23:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAAD1F000E9;
	Mon,  6 Jul 2026 23:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783381114;
	bh=4RvaHHR1JLiGd+lSbTeUq745Smy4dv+Izz0JZQMDa24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=T70ApH+ir5I5cPXv98r8DrjVUoxum7BeJzgWMoS2eW2HYvEJdSbuahFtwlVhniqwG
	 cRkLwfmlrUNps+9jh/GiNNWgNuzbOA/UWGihVUfo9zJUyGvpCSAo8OL1ufFhWfuF9N
	 V3Tt5MLXSBBO3mq49vKsQ35HAxcJ718rQVOQEG1A=
Date: Mon, 6 Jul 2026 16:38:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Chang <richardycc@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 "T . J . Mercier" <tjmercier@google.com>, Martin Liu
 <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: abort proactive reclaim early when freezing
Message-Id: <20260706163833.19b6c869407d51ba8e278f56@linux-foundation.org>
In-Reply-To: <20260706081218.3438762-1-richardycc@google.com>
References: <20260706081218.3438762-1-richardycc@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9629740004
X-Stat-Signature: 6byhmqi4mr31zhzcsxtn8gtohorhtfpd
X-HE-Tag: 1783381115-842621
X-HE-Meta: U2FsdGVkX18ipYav2tzN4tuSU2KncNBOKHBYVdBFF+2kiGzbchijW141Np57/D8qDzqpBJzp05wYUGGbPorB88SR+85vy7EYlcY7yMDtbj8rWD9kNx/kYKvw/yCDksPOiyV+mThUyix79vMj00jXkeoGudLAKD6L94EHbOH25NTUizavq0z0RTDtUbF8Caaq2vCNunuTTD4JspVJU6FpOnloYlP3psEBSjBzq2Hn1H/I0qXa/VIt/Lmfoq/0bM6WzlX94ySS5WKCZMHbdTudq0+JCwDE9UYN4nZwi+XZF/vmhVlzCKcjPuNMnaiXCqQx6ujqb6QQCHNM3M+Nt59ewf5KZw7rQqYkBZzDsnixuaTIdd77yO3Md17SBm3SqQL9ar2Xi4Bxtn6k5CTHpEjq5jkrl37eXw6on+elwC1C7OQBT02FnrEzLYaLg7PDOzh4veVrOJ89NBSiP7Hnv/EIved+zfoidKJKbvFtGX7Cfkc7vj3p38qiaLBHe77cAgfcKM6XWZ9X2LcRk+SVrvEnI9GYjHAG71u7U1XIi6Q2TgehFxeU/0DlERBdFiHbmckvxB3/hpznNZYQ2fgkDJLWkmfAdiztnKPSIClmDuiZftZuB8bIbRjwOCxTCI8xDo4krMJihflwPkq3MZv6wEjRyIlpQ5THLWoFHRqQH/Zm+X9gccHlLJKqPiFJSIoE0qwP85BU42A9IIm26GYo5EMMnG7guvrsILjV+OQBVQzV0rDZQo/mKcOSiYJDZ+Zu5RsJyTleRxgNS97ekV9Ihjyg2j28+jIBbEPcFWhOYDxf5MIJHlsRGIuG3aAZmMFWRcprLZQdFwDL6NMzDoQ5ef+4R2Jt9IqHT7P0vDza6APA15q6wGm2KdMSKyf2CwvS9CK2rBf2oGzuInugPmVfpfiMsfrRMs45Oz3gjG0cG1YgDtHhxn1ehucqNV+PI5+y9Ts4ClMOT+FPnIS6sBhViK2
 p1hG/AUn
 P65C0JnAuKK7YR33IjUhLpUOkwzGXF/NIlLFJkhsmV7V/ajFDjeCAeY8Zjwc7fgEDRKY8bKCFI2mPK0SZSbu5C3erMUSdrzqC1IKetu0lA8mZnqVzWdP8lZlMzKuoz1sJbUfiZWX2DM1D5IhFjWru0/UO5pT5odDMeq9gf400Rbl+EbiFMmHF8MhETbsvPmu/wrQQhubrJ4okL+JpPQW5wwbAScOsR5hSID8hwJgOha8fWXC4HyAc4k9XAfZvoVs0sdKdnnWraS/qjW76WMNzIhEhp1KyEgKE1gxCI98hfxDGtPyUDZkbwIQ325CNxfeHkPokncuDnF0/T6kDRc7t1S8tZilaxC8mUGTDRmyaT2sordA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 08:12:18 +0000 Richard Chang <richardycc@google.com> wrote:

> Proactive reclaim (via memory.reclaim or node reclaim) checks for pending
> signals in its outer loop in user_proactive_reclaim(). However, the inner
> reclaim loops—scanning cgroups in shrink_many() and evicting folios in
> try_to_shrink_lruvec() can run for a long time before returning to the
> outer loop, especially on systems with many cgroups or large memory sizes.
> 
> This latency in responding to signals can block the freezer (both cgroup
> freezer and system suspend), leading to freezer timeouts. This issue was
> specifically observed on Android when attempting to freeze background
> cgroups while proactive reclaim was active.
> 
> Add a signal_pending() check to should_abort_scan() for proactive reclaim
> paths. Since should_abort_scan() is called within the inner scanning and
> eviction loops, this allows proactive reclaim to abort early and return to
> the outer loop, ensuring the task can enter the refrigerator in a timely
> manner.
> 
> This check is limited to proactive reclaim (sc->proactive) to avoid
> affecting reactive reclaim paths, and wrapped in unlikely() as it is a
> slow path.

There are a number of ways of getting into proactive reclaim.  Have you
checked that all of them appropriately check and handle signal_pending()?

AI review thinks that classic LRU might need the same fix:
	https://sashiko.dev/#/patchset/20260706081218.3438762-1-richardycc@google.com

