Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECB9FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C406D6B0088; Thu, 30 Apr 2026 20:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF11A6B008A; Thu, 30 Apr 2026 20:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06BA6B008C; Thu, 30 Apr 2026 20:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A30356B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:55:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C4D51601A7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:55:10 +0000 (UTC)
X-FDA: 84717031980.17.1858A0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9614B1A0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:55:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXVnd7xl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777596908; a=rsa-sha256;
	cv=none;
	b=RUxvC+HvBjMewuqWRsobpPV6u/efWGZXvAi7jyMnRhWtpBdYsAsqWWitl+yh0NHz/8p2a0
	TzatDBu7BAAo0ejY8PamaTf3OIfZxJEGyqH+i2HOtxzsWwXpq8EuovawRr2CTPdM5Ao9z6
	++kd0Z7Epg7rQVWTxXyjpP6K5u44baQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LXVnd7xl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777596908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChZGyaW9/cfUeHWnU4ms7cwxKXSzzBR+lEsoFG4qhas=;
	b=1HWsp3Kxm4IxRK41YtCasqrxNHr2WjBNzA4Sj9+oiLayJ2MOZlyhgFO717/EsAVSapABOk
	5nEGzVsx0C7iuNLHfq/VZLv4zRwNk7BzG/fqAhTa4EFIBXVVW58rycYVVEJiptEiYR/FGr
	bF2TTE3C/bCNJ3h0dAU28CnZ7t+TpzQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 98AF760142;
	Fri,  1 May 2026 00:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3124C2BCB3;
	Fri,  1 May 2026 00:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596907;
	bh=SN2ogcq83g8zSLd1ScLAn6N3IB4C4UcwuiZDm7rQfd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LXVnd7xl5UVm7hvwTTTinhJuHSd1vhtuM2+x/aIfnnk8VyEZ/XP4QvR1eZ+ryFB46
	 puVPydCdwDfWPNWMGX0n/cXblC/zk/NThvpB+nZnU0TMziDESWgCgWvCZIqxo0taSo
	 oFiYK7GULgOF2j4l++4UtC4BVmwS7DyQahpDnZk+OH7IuG4kmoPISoB/eYQonHgki0
	 FDd27GG3+hqlLVLdd/A7PE7rGP96l4jyfcag+dID5VRxN3KMvpZLOYbat1vaoat0WM
	 YRypV+BU5FsJ6jxwksin9sLOWpgExJzE99tTYXForFdA67Kx/WPajU/mu5eUfdjxmp
	 1a88hlYvtMXWA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 3/4] mm/damon: introduce DAMON_HUGEPAGE for hot region hugepage collapsing
Date: Thu, 30 Apr 2026 17:54:57 -0700
Message-ID: <20260501005458.79180-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430134139.2446417-4-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jg795rcux7d6nypmyijtoy5qgiphde8d
X-Rspam-User: 
X-Rspamd-Queue-Id: 9614B1A0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777596908-604736
X-HE-Meta: U2FsdGVkX19rJ/tgX6nb9K6NL0+pidIEN0Q8rBFbH0anCWlLox4BInxxdk01SYKFzOxozQlbbWtyw/pvJdq+C+Go/M5J6VHrMV1e/SZhr9R3s7SAhiZD+P9J211uvYK1rTM0gBQlX4fKelOVV4fiiOTrjPWRZL6ZdQWL9H/FnFbR3CpDHrNtKmo8GwW6TJsrNFIbxwchUtr0CtJ4Xe6DDu6oakPchL7+58GTnWMro46lnbhrlKVxbqxxZYYJbe7YLfvWgrgeuh/NkLoNimwTyGSUFefGhP1hzKJcUTjuazb14+M2Ez2H6gzJbEUwYtfSBKOHYZmabArHRvvbevAOzSeo63P6fwrynazNpP7w2W1zuuNo4R0sc/KaMLhtRwcp2+bRf+hUOWz7eKYMHXMG+tWCAVqKLo6hpKxPUxGfZx1kyGvG6CnrFC/NIGN/kCkQo7nz1g0IW4oyqLPpPN6+fkuMH7j9SH6SJqf4UCkvEHGPns5RDRb1gN2gEuDgHYDFCv7BgAYAb/WfffA3QPQUu2nuN5rNEyfXmhRkxsabe/+wrWUWXCSuV9X0uJXUmcprbRvEI91vf6cbUkf9HS7z90AFVpMXNY/ngkB3JcBQewechgTj1xM7YCFhTWU5iFwZlu921u0jxjEv9IwAnLeXByH4osaYTXRmg9LGzVMGjPAEmFAdV15ssWxXnAePtcIfjBpIQKDygDLjieIV19vgQj0TDucECrXP3pFdqu39cOMPqtIl2Oe/1E4cpc7rZBV6Ydl24n3v82y8iOYjwSSYK2RZUgZNY/1nyRPWPsXzDdut4vBKJ2ke44HsY5khYdP8IYijPSFbqZwm+KFQ9ZP6WwyyT12xou8/qaGQ2NW8A6ttr7b1kaz1/td9y561FO1pQag8vzE+ZyfzvMzzzJirAFFQozeFa2Dh9SExn9P59cj/6didcdR8xVQMOJ4pc8OCX55BGQCEHDXRcr7bnqb
 0aNWpoI7
 lRfzXPhS5WFXNNeae8+iuTFmW3AGJ+FR22Zl2ZuDpKFGOiXUvw/92IpQLmLZs9NS3PYuXNTcO3neS/gA13GTjdEj+XfzyguO29vGKKZNnnDzdiVN4AIJUr5+PxsCeFvGk32n2SHjJ5drBLRos2r1XI82oyoLywY3Vo0j/TFU1bM0NGemq8QZkB1X2zsl0xjIbXJGobCyaTJiDn37YFcwYJpdb2A2btHTCG+WuWWyGSNKWsuCxNAudast6ck0SmegJf0a+jOTSYhFM5MnrSg6eJ13PaCs3/CUsbw5Lm5f7JkWM/10EXM/8EBwv/NnLjg/g5a8XHlise6XzbIMJsLoisRKgiC4q4BJ7jEKg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 13:41:38 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> This patch introduces a new DAMON module (DAMON_HUGEPAGE)
> which collapses hot regions into huge pages.
> 
> DAMON_HUGEPAGE operates in the virtual memory space, for a
> specific task.

The new quota goal is for global memory, isn't it?  Why use global memory goal
for virtual address based scheme?

I understand it makes sense to monitor virtual address space for collapsing.
If we have to do collapsing, should we modify the quota goal to work for only
given task's virtual address space?

Also, what about split?  Should we also split huge pages into regular pages if
it is cold?  Maybe that could work on physical address space, and use the
proposed quota goal as is?

> The user is expected to supply the PID of
> the task that is going to be monitored through the
> monitored_pid module variable.
> 
> DAMON_HUGEPAGE uses the hugepage auto-tune mechanism to
> increase or decrease the aggressiveness of page collapsing.
> User autotuning is also available for additional tuning
> aggressiveness control.
> 
> The module also includes changes to the DAMON compilation,
> so that the module can be enabled or disabled.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  mm/damon/Kconfig          |   7 +
>  mm/damon/Makefile         |   1 +
>  mm/damon/hugepage.c (new) | 341 ++++++++++++++++++++++++++++++++++++++

The cover letter was saying this module is for demonstrating the usage of the
new goal type, but this is not a sample module.  Let's make sure what is the
purpose of this module, and decide where to put it based on that.

I will skip detailed code review until the above high level question is
answered, as depending on the conclusion the code may be changed a lot.


Thanks,
SJ

[...]

