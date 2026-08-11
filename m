Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065DDC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F4106B009B; Tue, 11 Aug 2026 13:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A72A6B009F; Tue, 11 Aug 2026 13:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9916B00A0; Tue, 11 Aug 2026 13:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69466B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:38:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 625AB14017A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:38:43 +0000 (UTC)
X-FDA: 85089698526.20.8FE9EDC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A5CF81C0011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:38:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=No247fuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786469921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEPPggs8PJNHHljShEYMadexxBKRpvP66LYQ1YU/1GM=;
	b=0aamnyfKpYfvpchJ9ehKjJwF23PZj8wQr5NGdjU4Hplvy85bmXAkVWUsENfUokJWCvLO81
	NezGez2WjvBjEIaeXOdg91h2Yzq9tzNKHgLY6o6BwOJOf3fah9NtxoTTWu87thEhSUFsIb
	FD9FlwF6CheZSBkcJiyMmcpAmO/ruy4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=No247fuK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=xC7b=GE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786469921;
	b=pMyuV4cOReRxEF16vs9e5KKfGZRTWTtfCFLailC95PgRfgTl+g2kkHG3ldSR/EzKP2FYvy
	zFPG8oJlnnwEd9SflRAFQwo0kjL4ma7mGiAJHE6hxR27TtMSzdXpZ/AMpAiMXylnEpwevn
	ZAROHXp4nEBdZ4abZ7ztWYxpKnu4WlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD24643530;
	Tue, 11 Aug 2026 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8501F000E9;
	Tue, 11 Aug 2026 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786469920;
	bh=QEPPggs8PJNHHljShEYMadexxBKRpvP66LYQ1YU/1GM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=No247fuKxaN6t1LDDKmSjpWYovQnxMVIrZbOGR7nbJWXVmMlQGV0liBwMvRhdxhp1
	 b/k7LRWClSY1eDmO0XZhEVEFIzc7Yk6M4hw9jkupgFfkfpQGbL/IhMllGjYbgpGSne
	 fRyaeV17/PPyBPGH9gjiGVbca4LjHXO/ulXuYZ46ZFVdke30I2BJmpDaPUFTycuuH/
	 AewU2NKJFOzRh7F7UBcZYTnhWLnk1HjLIWerJ9s/yZxC/cGpUmtjmeKpa+IYjVN7T1
	 8yBxYV9cRsOtA0M2MhxHx4mqUl6cGhdhbnRMWWEmpD51uSzRLr7xcaThvu9bi9n7ab
	 bFkqn/ra4xYBg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 89F42CE17BC; Tue, 11 Aug 2026 10:38:40 -0700 (PDT)
Date: Tue, 11 Aug 2026 10:38:40 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: report RCU-tasks quiescent states in
 shrink_lruvec()
Message-ID: <e019296d-43f5-47bd-ab49-6dfd1d8da0cb@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260810-rcu_task_shrink_lruvec-v1-1-4d9f7d5251cb@debian.org>
 <anqnkZceNHyvbR5S@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anqnkZceNHyvbR5S@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: A5CF81C0011
X-Rspamd-Server: rspam07
X-Stat-Signature: sz6gr1wny9wbjccddaernjfxwu1utic3
X-HE-Tag: 1786469921-398673
X-HE-Meta: U2FsdGVkX19uG9NUQ8lIsmCDRjVomf96NtrvpjWoRi/nZxwf6HTY6ORCY56WD5RImnqUrztkYwyVaroNytoEes6SGeHc3/CWa+i5DLH583xjU3OwsGEJMStnvA9JGSKHNx2nmNsyACV5c7Mlt66bqD6UiJ8NRmSgknqFM8mK1ro3n540GqeV/sUGKZMEjYDzx2yNENQCCn67XYeSp04oqQfFa4o2vUx3HSzvY6S87j3W22J9bxb1td5SW679ma19Flh0o6uaiwvXXhzOZtC+hoz5oOXlAb053lcVXKukaYya/SWlYtJiywOxCVbwMMajf5SMmmzKGQu+0IBdOTKeAWEPqYyTlTVv4lVbnUNkMa7V67FnxbJ1mBwnTrFJpbcxdGVrgdQf8/LdfA9JC62xVHM7DousCz38MhtrcuDTEtyjQ93jL4oXvYrSoC6BgZYfV2RQ11W0iH5xCDXKJyeka/K7VAOaViu2zAxrKBJ3VINOasXPoBhejypk8X/uTkI7WGxF2NjDXML0jeyIgsrotZwVVDvn6Rz2goSsczJb9j0/GG5xb6QVKYRdnw0YVdLTE5WgxOgd4fxcL/hNpgtriTfMB9co8vvZIwtB7qjS0YCUiRf62kes0vArp7RJ06w3OKdx8StGRuSvO+sZHDaNwwRJ05W94b4iOZ9h6xgMMeNSFt8sOKq4+NLDVlOCqXVRGZzZt0NzlKLp2dwzGt7JysH40xzIiIq/+FOh9k5ldEBi7DC/fIuhfiUILeU7uRxsLTHPEWpk/WbvifGF23FDIRaJiLLNj9EZKgoGUfvYVnSLeCMOP14gCuyiSQnhbNcR4tFkcSB1uPjJkfbVAMD7JXSWw9+sTC5lzwYWauI5XVop0i7hALDuHeEAqWa+Z8GEz152PfBXLfx1lzM1LmSj/5vaXSuQuUM5LxY6rGcMFUHXZLq4ybwGEY8GxU4sOtTYM2NTTWO1TVPFeShHJCU
 hj37n3rZ
 lwKoVpJytKTOrhzE+aAP5egccR2nh5ysWEMgsDevjfNo5I8aTx7mSwuKwM/pnaLYE7pr/sd71IBcJJ4LDKxG9Y7lGkbqtdhf1hm199mX9YICV9/srt1bBXBOtCfHmyLCH/DBQn5bWEYfxUPQ+KsmHK3yPjTk7XDXmHDRVN5pVaOynD981y8YAZPQDJbUqhQAjuwpMaJv+3hKXafkTCOfbBkBkruomSdcOiQ3ROJk81f1SDv4yvE0HD420lmEN7hWlMn7APPIf89k6wLYjppLiZrRNAqyud3sY4jUsElilGUzY/N9DRsrLXk/DYs5cc46+CThN9Wo6nMJSMjS8L5lDKOr8Ny/GqzFa9vBBuUtDVwKXXaYhWo5Pm44M9jvJD4neNiDMExWsVF4CoqtIqJW+OAu+ovqexovjyk643GK61lp2NECDAsk4hLtN9HvoqnDnXVVOIGDiziDzWG2dRZkcVv5Q25irqPC9NCtozAtg/sg75IIUk8ipIjaaSO2VIMHWFCuUB8x+9yBT2s9lxk0Ee+qZm+SpGd9Bv/1shH9NvR+BQbmULerUqDj8loK/0snBAje8ZZ7AXXB38lCv0JyoMSikgCG033AITFarN1GkY3WPVuFMCefaJ+MLrt2S14/W425FndWdR6huBi0QTCNRu7UWspLjVX+nwg14EmeDqYV1bPyhs7a763mGbwcscKcNb701E0gNfMPz23XnZjeWctkhVPrHx7Ne0K6B6KyuZ4povTppFfPxGPwruAYhFZwCut0q1uMieAKQoJ9ljAB3yNEsx9rdrdthN9BaTcpE83cwz64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 09:43:03PM -0700, Shakeel Butt wrote:
> On Mon, Aug 10, 2026 at 02:57:36AM -0700, Breno Leitao wrote:
> > I am seeing some rcu_tasks stalls in the Meta fleet during reclaim.
> > 
> >   INFO: rcu_tasks detected stalls on tasks:
> > 	0000000088620d09: .. nvcsw: 6735/6735 holdout: 1 idle_cpu: -1/8
> > 	task:GlobalCPUThread state:R  running task  pid:2552016 tgid:2524552
> >   Call Trace:
> >    shrink_lruvec
> >    mem_cgroup_iter
> >    shrink_node
> >    do_try_to_free_pages
> >    try_to_free_pages
> >    __alloc_frozen_pages_noprof
> >    alloc_pages_noprof
> >    pte_alloc_one
> >    __pte_alloc
> >    handle_mm_fault
> > 
> > Nothing promises direct reclaim returns in bounded time, and the scan
> > loop in shrink_lruvec() only calls cond_resched(), which is a no-op on
> > PREEMPTION kernels.  Involuntary preemption is not a Tasks-RCU
> > quiescent state, so the reclaiming task never reports one and becomes a
> > holdout.
> 
> I still don't understand why cond_resched() is being treated as involuntary
> preemption but that is orthogonal to this patch.

The history is that cond_resched() was originally intended to be a
preemption point in any otherwise non-preemptible kernel.  Therefore,
because it is a preemption point, it counts as an involuntary context
switch.

							Thanx, Paul

> > Upgrade it to cond_resched_tasks_rcu_qs(), which reports a quiescent
> > state even when cond_resched() does nothing.
> > 
> > PS: This has been discussed in [1]
> > 
> > Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 

