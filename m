Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF7CC53200
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B08F6B008A; Wed, 29 Jul 2026 21:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13AFC6B008C; Wed, 29 Jul 2026 21:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001FB6B0092; Wed, 29 Jul 2026 21:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D13606B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:18:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AC27A07C8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:18:00 +0000 (UTC)
X-FDA: 85043681520.14.D2CDE5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8994D40008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:17:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K+8mJltb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785374278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Es5KUQVRoUSm8lu4Qgb37wmW7A914LbkwxNQHClT8pk=;
	b=x18+BwYPqGyl5L+aO6ZznLM0cA0cR/oWsW/Y/bRTjdEZefpOPIfMLF+k+UcDRdHric2NWZ
	zzs1CZdlC9ImCp+lZZ867aR5ChnBMjgDSCqEqykIJc29yNoZNMGByOe8yAgOhkVcpFxaDK
	RETZDGma+c78/xchE3rc8I3cP1GaXNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785374278;
	b=qHV9FgBHF91bAbkf4hSpGygSfL9DLhfrJnEQq2n5Uq2bgFapjU1yQfG1XFXwYUYPkxhrrt
	q2Qdpe+MQxKpVaAdsz+qMVVBrTtgI1/nuXDGGohXrfqfSi4VIMiq6LKCSjRG6HDBOYcq8x
	PqL2GW1fKbtGvpOYMH/QW0rsBhCzy80=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K+8mJltb;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A133540DE9;
	Thu, 30 Jul 2026 01:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECDE1F000E9;
	Thu, 30 Jul 2026 01:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785374277;
	bh=Es5KUQVRoUSm8lu4Qgb37wmW7A914LbkwxNQHClT8pk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=K+8mJltbxDSXv6VNjHZdM43LVIaMBfhtxI78uRyVZfV8H3u6oiN02soQZ6k2t6LMt
	 fiwY7umJlE0UUrFeqpFy4+44MzEU31DWXcK58/i++DLHc2s/SiYwdBBduMIcvddtVw
	 0M4lmhanWeJc9UC6EP0La9zwppguhlFJtzNVMnBY=
Date: Wed, 29 Jul 2026 18:17:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
Message-Id: <20260729181756.a37e0cc7ea3f6013959d1d25@linux-foundation.org>
In-Reply-To: <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
	<20260729084206.77793-2-jiahao.kernel@gmail.com>
	<20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
	<CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8994D40008
X-Stat-Signature: 46ksxwpmfugd7r8hyteu19x7sw6phpu7
X-Rspam-User: 
X-HE-Tag: 1785374278-551493
X-HE-Meta: U2FsdGVkX19Vj7x+z6lpsV2YV9VbBJmYV6bXaGnVYaYq6XD2E/OuNDRppa4AboKfrRefLpdw8z7YyFWDzOOsXdLFjirVytIq7cMU1SzcRWjkErTvXpXJ0dccAiJsphSDGjeeMWn0r5UNpUb0dXa0BdvbtuqukZ6qoCiNuuuLaZqc987c5saFmdNHKLjHHMWAnRe3OKERq1HNJXAp8lexkbC9WkFbRanISK7Wj1QjcnYNo6YjrOXaZ1k+JPW8RGOFdoqkovqNvfuzOcpOFGkCMz19BWTgfHjzbWPiIgV7iDGxG0JIW+z98zfTDs5RnsEoiyDmnCdQNzKR6ZdyzZ/QD65v75yaEv9eSiHcUQlG5NUq343R7fXTtS2hQ+rqvAp01CYop577NfC/UKBkY8gtXuIKdQ6dlBu3gou2z69+0oSS/v3QBPBt1bBMT3lO8CP5BFlk6Y53ylfzgOXWoZ0OCGyZbqS3SQnj4VmDhs+3ByfMGW8HukkOMluG2iINJNbGU0P+Q08a5P0yPnDIcyuuBDfmtgsbFlGqVjX+o4xo/V5keUriyCTiV4el7iyyJRkSQi24aFbRrQ2PgdevF2XOqzfCP11mKkh0iytDANsfBdBl48yOoBMi1EwSbnF44xq2T0G06yvVc7PrWBkps44P0dPdDIuX29QoqmY/S30d8F/5ovh6EfQVA4PPJrBsrcA7m3ptwcSKS+IIvWwpm+aA2yAOoQ3i45F+f/y1Uu2/xwNTCa/BdpdnUNQCf+lNbCbn9iE/+1ix5nP9JDuH9Vq11WEGBlJ1cLnT3Qgmt5GGjKJ0mPr8mKC6125IxMouljS7DA2Hem0rNMwXM9iAtC8Nkm8IOPuAuLXrVITo6z16bEyfD5pQHsKxionCnKLo9p8T76Kri3Zo8bjVqMP5aNLIjAx7dWfYkJK97OQQ91B5oWJNaQhmOFgelHQEWOEDIk+fLw9fyJhGLsdzOEm1nxS
 utKuRMWo
 E4SF09yUn85H/6PtScOr0GfULORV1o42942bh3gO0v8maAe6gIs3osZt/6tf4zVdnB0pYAjFPyj9Hi0BpAuWbx1M06hfLh6/k5wvJHPZTUYKO6I6MSgobNkLLPgNCNh6+RlAYP0Ecfq093dtO4/GnfSVrJutCo++MchHP6hXwHXOU3QFCJ5+ajkEbFroLXXrGdTP1b5sxcPWJDUmkB46o3YUDBtPBvKUsHOILudUxRgPNRzp+0w8dSdwslr49fVG43RX9XHl7UYDicdaZqSQPDE5na80KVxeB24XwQg+rm6UH1RE947SaNfcJh6P70Ojj2vQqcl6DMyAeydTG41jVb54TrTiQCLOB+7FBp/ghpEO3hyPdJQJhPVXGjh3Va9BZfZkqzhXZ1BoeiRSGOvljqbqD20Zb39dsggVFtmH1iJy5RlOVE4N8Yyy2gWEa+Agp/wGdu0bgj7focQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 17:30:56 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Wed, Jul 29, 2026 at 3:58 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Wed, 29 Jul 2026 16:42:05 +0800 Hao Jia <jiahao.kernel@gmail.com> wrote:
> >
> > > Zswap writeback when the global pool limit is hit fails when memory
> > > cgroup is disabled. The pool remains full until it is organically
> > > drained by swapins or memory freeing, leading to zswap store failures
> > > and pages bypassing getting written directly to the backing swap device,
> > > causing LRU inversion (hotter pages with higher fault latency).
> > >
> > > This happens because mem_cgroup_iter() always returns NULL when
> > > memory cgroups are disabled. As a result, the global shrinker
> > > shrink_worker() repeatedly takes empty walks. After MAX_RECLAIM_RETRIES
> > > failed attempts, the worker gives up without writing back any pages.
> > >
> > > Therefore, when memory cgroup is disabled, fall through with the !memcg
> > > branch and shrink the root memcg directly.
> > >
> > > With memcg disabled, shrink_memcg() only returns -ENOENT when the root
> > > LRU is empty, which means the total pages are already below thr. In the
> > > absence of heavy concurrent zswap stores, the loop then safely bails out
> > > via the zswap_total_pages() <= thr check; otherwise, it will resume
> > > shrinking the memcg after processing the reschedule check. For any other
> > > return value from shrink_memcg(), the loop is guaranteed to terminate,
> > > either after MAX_RECLAIM_RETRIES failures or once the threshold is met.
> > >
> > > Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> > > Cc: stable@vger.kernel.org
> >
> > How does this affect users?  What behavior do they observe when it
> > occurs?
> 
> I think the first paragraph sums it up pretty well, especially the
> last sentence "hotter pages with higher fault latency".

How do users observe that?

See, what I'm looking for here is an explanation for why we're
proposing a backport.  How are our users harmed by the current code and
how does this change benefit them?

> >
> > > Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
> >
> > hm, that isn't really a bug report and doesn't answer the above
> > question.
> 
> Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
> it because checkpatch annoyingly complains if you add "Reported-by"
> without "Closes", so Hao just linked to the thread where I pointed out
> the bug.

OK.



