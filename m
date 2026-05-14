Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62720CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A8D6B009E; Thu, 14 May 2026 10:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31AD6B00B8; Thu, 14 May 2026 10:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970696B00BA; Thu, 14 May 2026 10:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE546B009E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:41:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5977F1404A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:41:32 +0000 (UTC)
X-FDA: 84766288824.24.1B9AE01
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id ACE7C4000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:41:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUIJYMgR;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778769690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoiZwtoN776VaqCtFN9gHXh3V9dwpsJwfbYIJ4mCAW8=;
	b=2RcuA+X/LRG9e6BkAL7w1bpIrKEsoAk69v1fVVL6QgQ4eRBVt9oWvtJ1QRqI04Vu1bDjnl
	rIahLec98zIZiayllkWoIjH5GqRmaaIscAo3cA+6bkHDskBpuTdgZ3TI6sfF4Pp1bR8e6P
	0ZACpy5GWRQ09z2aX7n5WA3DKbpI0ug=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AUIJYMgR;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778769690; a=rsa-sha256;
	cv=none;
	b=d0D+U66+yxzCipuB0A6Ga/hVrcswF8Otq/3whPjZAdOJeBKGa7q/KcYvVN6SriwlAbhJc2
	fO7FcLlNqNiOsvmDHK09O1FqmUi4EcSAL7fMhWM2nP2JqmNXtE5aFyasQgCN8lu2D/D+CP
	RG7ojfK6UchYlhUmeHJRpToTHh6pM2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D1F260132;
	Thu, 14 May 2026 14:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79155C2BCB3;
	Thu, 14 May 2026 14:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778769689;
	bh=KtWX1a5+HImqtCKe3Jka4nlb3lpWuqaCAeSX6uYt13w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUIJYMgRENypM1B0KnhPeo2fSIQOWNzFRHuzth1o0hjdQA0KJSsOloaIHlceXG1cd
	 0FeCoDfOxFzwzwoz9gBJlKBMPZsDEZQbsTlifpxbo1/2/x4c9IKjx5VlyEctNKPxsf
	 xT5z+vmnv1y6EylFxPV6b0TzEdiZRWELw9+Ve6R/nJp6guyiVuoZu1SOe7RYNR9WnP
	 ArwJB3OzlvX5FMFg/LVfmfLgwECtJZNLxuy3BLlrnTo02+pwOJm/Naspzha/qiWMed
	 TM4Z3m114XLlG/0Ks+pI5F292WUcMqSMQknraHNkiKoa5mhCBIOyvDy5w3+BYSR7uy
	 jRKk8hC8RllnA==
From: SeongJae Park <sj@kernel.org>
To: niecheng <niecheng1@uniontech.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel@uniontech.com
Subject: Re: [PATCH] mm/damon/core: recalculate intervals tuning deadline on attrs update
Date: Thu, 14 May 2026 07:41:02 -0700
Message-ID: <20260514144102.120203-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7946CE4E0773AEF7+20260514074846.3258908-1-niecheng1@uniontech.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACE7C4000B
X-Stat-Signature: 5bi579sf3rs7f5ohxaau1xu8rrzoty61
X-HE-Tag: 1778769690-608666
X-HE-Meta: U2FsdGVkX1+AWPSqgzTYU9Os6pajhKObVCtD+UJaWy+Ujp9jjk5mIyaN2Dh62ZuCPdQow7J4x4N4aJWkDIjUZnTzoyolt2iaNODMbq4li5eDZzR3+SPljroXPI744rkLHlNMwy48oXR1fHxw74IDODy0ibS9lqNZPZdJxmvdvSkAsjXjw2LUk0B24HxiLnaal60HkmmznrgLMb3lcVIpo+OZ21u8fhzKZ2DAdPNikT/5SJIVkfYGEHghWHOIp3OF2MsIHBpSlxj+C4y0Enz+EFro5+l2alOukuoFkaStzsN0EXMPM29lq9RIu/gvhfgXVjAnZcEVoFGmmsjXS5Dt4R/6hzy23JYtZePxtmJWoIxDWSFurQWfq3zZ891gZMvh7fGz0AkboSLxN35qa4Vyfd4S5fZQeV2g9qOc8zkGj3fW42AF8O8WAjtaAByKO+7CAqJUdsDB8sF57IrBYyMsjzjVN+va03dgeT/sZEBNr1fmJykH3fvWvO9XwrBx6DF6hOv/OgtdclR+G1ZAbGDiehcy7gB5vEG8ZXEezpw9pIKKp0jvl1Lb3voClKQ4UkMbBc0aeccWSNT4r1uH/l2OzSYlUsdkVRLMYfJ3febK5xkppmJ/pfGSyS8jYke7QLCReXfYGcT6HPpLaIlkdZqMgXubQ03+tU3DN754ft67xgVzDwwVTmcSjEUwmvpoD7IfCN7FvnZjVg/RCh+p1Yvn8omrhDt9kCsNyQkIKtRx5RGOzvtFteTQ2RzzanFT9t2XVZfzlDn8J9eKTcgwUsRTuTLccznhY+5L93+gju0paSmt47c4JvJqd7mR10h/WeqpFoIB22P+uXd+PTPF9/BoFMPSUM1y6O1xNDES/VTjRPf+qAdz+CI6irzsNYk3RVXXziJO/s7GOaj7UVfKs6IDI8nFJsiANwWOg5hzkKxXtGBREKMWwZYuD/8t9tFc0jlthHtuYyZIATJim/rhSui
 JZbjoDcr
 pIizB/gHhcrbv6bVMm59KoJcqvmIYFcJlO5RlfkjdQkzP/LGNk+hlzwCHptLmV/4IAgf7HJNBplCvwT0I4Mgb7U9jFg5nCEqAShzvYez6SamRoAcNSct4hy+n0erLwl+GqhqKvPmlnIapRGd8H+BkXdUQUslDHRycrA+gIk4v/fupwzgwHkWzMJ9GhV0QKNvUN7VG/t/RBF1brj/YLNOLW+jAMaW40nBQr+stLKYOAoRFz3SikamJGJubPXVLzkAvoUYKGfoNW1jOT40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Nicheng,

On Thu, 14 May 2026 15:48:46 +0800 niecheng <niecheng1@uniontech.com> wrote:

> damon_set_attrs() refreshes next_aggregation_sis and
> next_ops_update_sis for online monitoring attribute updates, but it
> does not refresh next_intervals_tune_sis.
> 
> Because of that, enabling intervals auto-tuning via an online attrs
> commit can leave next_intervals_tune_sis stale.  If a context starts
> with intervals_goal.aggrs == 0 and later updates attrs online to set it
> non-zero, kdamond_fn() can treat the tuning deadline as already expired
> and tune the intervals earlier than intended.
> 
> This has been possible since the intervals auto-tuning feature was
> introduced, because that commit initialized the deadline at kdamond
> start but did not refresh it on later attrs updates.

Good finding, thank you for sharing this!

But, the next_interval_tune_sis will be updated based on the updated
aggregation and sampling intervals, just before the next intervals tuning is
made.

In detail, the code flow of the kdamond_fn() main loop is like below:

- call kdamond_call()
  - call damon_set_attrs()
    - update aggregation and sampling intervals
- if passed_ample_intervals >= next_intervals_tune_sis:
  - update next_intervals_tune_sis with updated aggregation and sampling
    intervals
  - call kdamond_tune_intervals()

So, the old next_intervals_tune_sis will be used only once.  I agree not
everyone will think it is the best behavior.  But seems ok to me.  I'd like to
keep the current code in favor of less complexity.  What do you think?

Nevertheless, apparently the code can better be documented.  Maybe it is worthy
to add a comment about this.  For example, maybe it is better to add a comment
saying "next_intervals_tune_sis will be updated inside kdamond_fn()" on the
damon_set_attrs().  If you'd like to, please feel free to post such a patch.


Thanks,
SJ

[...]

