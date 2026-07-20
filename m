Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1502C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:23:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1ED66B008C; Mon, 20 Jul 2026 01:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEA86B0095; Mon, 20 Jul 2026 01:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0C86B0099; Mon, 20 Jul 2026 01:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA4E6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:23:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F18EE160386
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:23:10 +0000 (UTC)
X-FDA: 85008011340.13.AE93383
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E91731C0002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:23:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1uNvXdKp;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yDfZH9hbjyh5mwCLdQi48sM2SkPYDPdFLyTByyg6de4=;
	b=43cuA0H/v6KMGbJGyBZuRYrnJnCUtlNPnyjUeEMeyQRz1t5hsImAYHDU4C1E4bMLajpQWu
	iFu+T51Ss/FQ30D9UnOCh2+97ieYkcvgctcuEaeLTHaH+/+Qmo9382YMHwIzbZI8lutr9j
	B+wE2GP63NnqArGVmVpbPI6AzX+ZuzA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1uNvXdKp;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524989;
	b=74fUQ78jT6t8aL1rkfDpc4Nm/7B7HWIekT2qeexGNKRyWIsW6O5h1jJcVozM8R8X0QkbEf
	0XYlS0pd9iFpwrJVEeWIRGRuDUJ4bcKYcKzCdoSd0E70QIEDn5l4WbeKgWrOK9to+cHf2a
	EoUxzUKjT4crtjVKxkhx058OnKBsF9s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4452760103;
	Mon, 20 Jul 2026 05:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580621F000E9;
	Mon, 20 Jul 2026 05:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784524988;
	bh=yDfZH9hbjyh5mwCLdQi48sM2SkPYDPdFLyTByyg6de4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1uNvXdKpOtc7vRh5uAxqp/HXU6KrP771A5oZnX13aAu63VvCaCCHhTeoWZRWa39HJ
	 nXhy4WHfTit2zix7KRAJ9yDplMUdez9FguVpnRx65hlgjlLzNNFSM7CdNjCA/8SR9E
	 nmY9k5ujtU81GvTJdYtuFO/gmr3yBh+alegHWVGU=
Date: Sun, 19 Jul 2026 22:23:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Chang <richardycc@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Suren
 Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>,
 Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko
 <mhocko@suse.com>
Subject: Re: [PATCH v4] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-Id: <20260719222306.540829de219e12e21396d260@linux-foundation.org>
In-Reply-To: <20260720044103.905191-1-richardycc@google.com>
References: <CALC_0q8rz7U-8x+syTFcWS6Nihxvzd00ruzOThb90P+cDqi=TA@mail.gmail.com>
	<20260720044103.905191-1-richardycc@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E91731C0002
X-Stat-Signature: f1h7od17ec4w43ajt5d31xewxshtuu65
X-HE-Tag: 1784524988-846618
X-HE-Meta: U2FsdGVkX18hLsFkPpOPUob9MAAjRchxvrO7iu4EotkGFcF7UX7Dud+AxVM6g1WZ4tBfeJCQD0gPGz0IWW0M/nlUFuvHEykMMlsuztw3War9sV6k7Wl63NYlDxKFFeVaXpnk+Ku0zXtY5RuelOh47NseUQ/0QC6n+ddK/RfkNepx1bQLGAjMAC/QC8ZvBQcyl3+WLQ44EWWAcBspwmfum1F0XhLRQAHov/LDUAgrenBhbMdOaeYmmZVGdf7lKT48SG2jjAJ/5fYgJy1iQppQqGLuahQ+GecNGDfhMAP+VPJGa0XQVvi4vjvW5sTj0PcsvheXcV9wKNPuXVlC58Ye2uyeLDW4ad6IPQPjzlj3zMtTlRoGUuJAedU/FcwVwC2zBqv1Rr9x4cSFTSQdIlRiSEAZ4hC+Pdxll31VzU98S2izgFzEk6K8QnSaVUI7Xc49M0mov0bQLlPjQNF+TNRjYkleg126rnxW+T4ppoMJ+34mYvlOoifaZdBWOmw8YrIRMcSZXdiWBnrjoKneSkrL5M5egRyZCM0q3myEDgcE4oFqhLwuiTMQxZGU72D143gf5xmLUEBIUgLZEicJoTX0CXyXoxqzVphqTG43po+Rd1mrmq9Pkfe8iUznVe2yjG70mnpjyHh4SWBjMEuInFzhb/iVKb+xaNxY4x+fJ+9wtlVxwlAG1L/L35OhtZFElQzM/aciTlk7hqH7ZQ4b41SlDVwNwXk0usfdZs4HDfYYu9Yn20CUi7qcIamAEJkhS9VCY0cAX4b3JRL7rtHWGPjJFO5rrwBaDlS/tYYUtVXvIL7G29GJWewvu7YOMpu/fHlBPe3qabmvA2qiH/Nz9vP9xlwCHQYUvqpX5nh8dDNrNuu/FTVTXlZN/ZYf45d8gqm2pP6gzQC/FX7z9fSn7hp5ScXHcIN8LPG+zWKzH7VQvSyv6uJKuyGCToRcYH/+ysIS9qnmYROAzeC9D6Vd2p4
 6asCMZQw
 jOQCLvpeNMcmZOmsHLquscu7Q5XDFksO3U2FOYb2fqpoArHUOL1ii+EBFsJ9VlkowTzgKCQJJ/hszkLhq3gJ+AsMDP8VCDGYX86IzC7t3xD1LXYKjR7uYv0bSHD5/gTboFzoXEaJbVKp/UjMoZYDEnHjMcfzrE95YIp6q5NxCC5GXKV8Sr9cusidz3+JvN8c9nJbH7GuGWON5PYXmWmfYYCPAa+avdGVscBLeJo2hYEVm+ZbM31uuunLGMoCkVUhDu+gDEFPEhcvFHf/D0rRveAo2ehfD5P4mNOWxSXGeChzfi8LSpoPphjAPhESSa3TLKe+5SZgN80MgLmZz6v2QDRNv155Dqx0xPbSQvAW4Y5ukMGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 04:41:03 +0000 Richard Chang <richardycc@google.com> wrote:

> Proactive reclaim (triggered via memory.reclaim or node sysfs) checks
> for pending signals in its outer loop in user_proactive_reclaim().
> However, the inner reclaim loops—specifically scanning cgroups in
> shrink_many() and evicting/aging folios in try_to_shrink_lruvec()—can
> run for a long time before returning to the outer loop, especially on
> systems with many cgroups or large memory sizes.
> 
> During system suspend, the PM freezer attempts to freeze all tasks by
> sending fake signals (setting TIF_SIGPENDING). Because the inner loops
> do not check for pending signals, the proactive reclaim task can remain
> stuck in kernel space for seconds, failing to enter the refrigerator in
> a timely manner. This leads to suspend failures due to freeze timeouts,
> a behavior observed on Android devices.
> 
> This latency issue is specific to proactive reclaim because of its
> large, user-defined reclaim targets (could be gigabytes). Since commit
> 287d5fedb377 ("mm: memcg: use larger batches for proactive reclaim"),
> proactive reclaim uses larger decaying batch sizes (starting at 1/4 of
> the remaining target) to maintain throughput. This keeps the task in
> the inner reclaim loop for extended periods. In contrast, reactive
> reclaim (global/memcg) uses small targets (SWAP_CLUSTER_MAX, typically
> 32 pages), allowing it to return to the outer loop and check signals
> frequently.

So 287d5fedb377 led to suspend failures on MGLRU-using kernels.

That's a regression which justifies a Fixes: and a cc:stable, don't
people agree?

AI review asked a couple of serious-sounding questions:
	https://sashiko.dev/#/patchset/20260720044103.905191-1-richardycc@google.com

> To fix this, add a signal_pending() check to should_abort_scan() for
> proactive reclaim paths. Since should_abort_scan() is called within
> the inner scanning and eviction loops, this allows proactive reclaim to
> abort early and return to the outer loop in user_proactive_reclaim().
> 
> Additionally, return -ERESTARTSYS instead of -EINTR in
> user_proactive_reclaim(). When interrupted by system suspend, returning
> -ERESTARTSYS allows the task to enter the refrigerator and automatically
> restart the syscall upon resume, making the freezer transparent to
> userspace. For real signals, the signal layer will either restart the
> syscall (if SA_RESTART is set) or return -EINTR to userspace.
> 
> This fix specifically targets Multi-Gen LRU (MGLRU). Classic LRU's scan
> targets per iteration are strictly bounded by get_scan_count(), which
> ensures it returns to the outer loop more frequently.
> 
> The check in should_abort_scan() is limited to proactive reclaim
> (sc->proactive) to avoid inadvertently affecting reactive reclaim paths,
> and is wrapped in unlikely() as it is a slow path.
> 


