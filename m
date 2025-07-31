Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7391AC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0171C6B0092; Thu, 31 Jul 2025 12:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A586B0093; Thu, 31 Jul 2025 12:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E47316B0095; Thu, 31 Jul 2025 12:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D47226B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:54:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C3535BDB1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:54:30 +0000 (UTC)
X-FDA: 83725158300.19.A46CA83
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8EC8010000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:54:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pQkeReWE;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753980868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9bcG3RWP3YSu8P95l+xRrExoCMmwz1nguza9LX7alc=;
	b=7InGngRZRh/tNrYkTHrUu+OJlL+JaoB+CN5W7RUH3Sfh45iBFHvsZcYa88FNV6qUbTpNsT
	P3R1WjQyoIbcEixbPCU7pzwY2qsiP7hC/4GNa7xJng7bgXok78yiajrVTukETQ5QT0w41h
	m+fvWjXBoogR1TQRO8pw4kOkEOjDd9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753980868; a=rsa-sha256;
	cv=none;
	b=HFoalV+djdjg9erJ2H9GwSmnN+F1Az1p3LE0SOh48h7ZoLGhZtFaKu55WqEkgFID/CWmBo
	3BQKWs9la67L1Bpf5mzL3lSs+7fjIr2hOzAT5DgM2c5iKmHl+icNbyqbHu3L/5Yw1TjRcn
	5Ns9h9PNa9kfga8f9SYvY7nVIQv87ys=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pQkeReWE;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 31 Jul 2025 09:54:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753980863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9bcG3RWP3YSu8P95l+xRrExoCMmwz1nguza9LX7alc=;
	b=pQkeReWEvLOrsvt7c9kQ0SHtinWYs9gBxAqIDJNFxiEKHd0bbP8T0kFpmAvvfgA//GGDSP
	cKlVuSSMlNyc5J0kwqyHsERlX7k1Iy3XnKdA5WtvS6mnhxXg1h5/UcAlpL7JCb+bnK8TSZ
	QZXxlqsABs9aPc6endS/w+3LmRjb3sA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	rientjes@google.com, npache@redhat.com, liulu.liu@honor.com, feng.han@honor.com, 
	jsavitz@redhat.com
Subject: Re: [PATCH] mm: delay oom_reaper only for the process using
 robust-futex
Message-ID: <u3mepw3oxj7cywezna4v72y2hvyc7bafkmsbirsbfuf34zpa7c@b23sc3rvp2gp>
References: <20250731102904.8615-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250731102904.8615-1-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8EC8010000B
X-Stat-Signature: 56hnmhy8rdwsy4n3bn87kuuyqq1gcj1m
X-Rspam-User: 
X-HE-Tag: 1753980868-47582
X-HE-Meta: U2FsdGVkX1/VG3XDiFHmveKVtiGOk4brR57jP5ZtRPG3ZDP/OrY2gc0hOZ0tNMMNt2quHBeEM9xHYgdFpMbsGcglSClJRuSJu+P+rgvuj8esfkF1otp7+JZgrFLAc4xQROVWhM44zAhXAQqN7qunUGu7EjoTo3A2ZiizSqPjEQnXolna/HjxqyueisyKJk5XIhKOi8uSvmBDFItzQkfbUgh4SRXbZFyqK/UPS7QFs657lqsL6TAhtc54jhUcCNJjJzXQhVMrOtp3Nz/kAQSfB8nv5Dv8gtJNDEfpUN4QCw8H0WDLvtby8wRCg6/IzAug0cdtFUGswXR4ST8Ha4yt3H6ctRYhk1l1ThdbjFicIZsox8bBBraGTLZ98Xi9AykGPZNYP/CwIEt81KX3m8ltQvrenN+svw/OVXBtBWZcfm6O43MK24rRPFt3OPtI3ejsMONyX6Xa7TxZ1jJJXibFY+5gHABbLMieJwUGRH8G/ETF2SOG6F1HXfikIEZfBJJEbjZwwnzDx3jvX8U/yUY0cpE7nIz3A5KMGBk+u84XLrIpppfMRzrgVp7+BTdB2KOtXRpDWon+no33xHmNF7+OjpWSjy5JiMiWSUUyZH7VPhlp9GTHEJWtFgC4KIP4ptf1ykG84AkIhQuGre/wl8zit6nQz3dsMYbyxoNDKhT8+MuZ14tCPYMGjufjUPevNebTV4iLdTpvEIxaoB6BSn/qA8GpDgcGaTrEbTo/Z2DczKkEaIjf93OrVOOjLs2gJArrB7Vd9JYOwBCME2WICNtUX1CRve5WPCuBz854gfpdDy/9yNEetiOr5EsSKkyhuLkVY43o6jG2hSelqdUKdP4+/V7UTEhJE6DCAT1Qj69b4pLUTuEN12ymrpz2QIpvfptF3QQ4OjdbwAm91Y1ziLVG8RNq2YgQWRmjNxellXqpmUZ5nj5W98niwRVObfxqvedlErTMq2418w+XDbm+wLb
 KyJJySzk
 Iscr39+NJwpXNz5kWBvNVNvn6tx8dE5kw2Pkb38HLKOGPG3H1NnseAWM8wjdQqP7x0a2Lff3rq69Ffp9e1Q7TEeCAWuxQ55SSZNXHtGXP5M6l1h2g8rEQzSJNsI38mSuRY3fVmaDb8Q9tn+ml+DE/wVH99DmDhrnLNGbFCPlHz5aDUoSbrCxQKJheok2LtXMYv0GZpaq3r80NQ399UNmnZYAVtCHhuoK4hB2WftaRZuuMNVd608Ltryuei8R2PS+LaITbQT0dBH7wepFzas+KSvfGlmiLLKseWAg1MgPX1SaXOTR0wwU2rv6XVB3SvDh4BPFWfl7eTheKLCAs6WauFLQK+16KEwIFD8zg73iGluCauQ+/gla/vZK/1DrNMPlSerYI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhongjinji,

On Thu, Jul 31, 2025 at 06:29:04PM +0800, zhongjinji@honor.com wrote:
> From: zhongjinji <zhongjinji@honor.com>
> 
> After the patch here:
> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
> was merged, the oom_reaper almost stops working.

Can you expand on this? How exactly it stopped working? Is this due to
oom-killed processes are exiting in timely fashion or are you seeing the
system remains in memory pressure state longer?

> 
> But I noticed that many processes do not use robust-futex, so they don’t
> access user-space memory during do_exit and don’t run into the problem
> mentioned in that patch.
> 
> So, this change delays the oom_reaper only when the process uses
> robust-futex, letting the oom_reaper work properly in more cases.

The direction seems reasonable.

>  
> +static inline bool exit_may_access_user(struct task_struct *task)
> +{
> +	return task->robust_list || task->compat_robust_list;

Here I am not sure. This robust_list seems like a per-task list and we
are making a process level decision based on a given task's usage of
robust list. Can we have a scenario where some tasks/threads of a
process does not have robust list and others have? If yes this can cause
similar similar which the original patch tried to solve, right?

