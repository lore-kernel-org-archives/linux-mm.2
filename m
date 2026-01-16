Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2210D47CAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111B06B0005; Thu, 15 Jan 2026 19:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFF36B0088; Thu, 15 Jan 2026 19:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DDD6B0089; Thu, 15 Jan 2026 19:43:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6D76B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:43:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83969C1F8F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:43:10 +0000 (UTC)
X-FDA: 84335977740.14.E7A535C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E45F7160004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:43:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vmDbA6Mt;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768524188; a=rsa-sha256;
	cv=none;
	b=tfEhWNF+MMGCaPNqa4hqlH9sL6iUHmiW6fI9CYs9/LIBfoYQSLWEvN+2ad0fl/CWe7MzGk
	nn6+xiXb92tc02UlhnzITmrm1BIemny2+QrC48OuPl1+DOMdcRJtx0xwo0UnVyhiTbao9N
	WklCQbAMNrAtk587pydx7ReakGjfQ+k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vmDbA6Mt;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768524188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70lqrhrf23Klw30o99twOw/Tt2U2KGQbltgjyMxlZYY=;
	b=DHdXoV5yCnSE4vAPX4xcYFxccW/HKTTQzanwQTmJFCV/GGYE3fTwo4FSypexUt+fxpTWqf
	14DvtauOO3q6SP4kjFFot+AACgB20Pc/w5NSLXK9ovSi4Lw6uPQ2JdEZGt6ob1u/6lr0sN
	2nTENTArecg0Qp8XM5HU9rPMfHpvTAs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 186CD60167;
	Fri, 16 Jan 2026 00:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04F3C116D0;
	Fri, 16 Jan 2026 00:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768524187;
	bh=fBG1PD1bCRFzFRAlxECdYmAe0bpJ0YaafnJU65vARWE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vmDbA6MtFqwo35iaeesiHLhJecnjpBfk3K5wu0pcSuJqU/DzFn5SuD267N77HNO25
	 kUCId0VGDnqJldx/uJsMrr14LUMSgvv/k1OpBTb2R9XCy0lGKs/Clbd8PYBkYb/Anv
	 0lvu2I6ATviw5P4f9nr3CLwAj0QURqDgl6uitqo0=
Date: Thu, 15 Jan 2026 16:43:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 00/30] Eliminate Dying Memory Cgroup
Message-Id: <20260115164306.58a9a010de812e7ac649d952@linux-foundation.org>
In-Reply-To: <0a5af01f-2bb3-4dbe-8d16-f1b56f016dee@lucifer.local>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
	<20260114095839.eabf8106e97bf3bcf0917341@linux-foundation.org>
	<0a5af01f-2bb3-4dbe-8d16-f1b56f016dee@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E45F7160004
X-Stat-Signature: mnnhdqg93ogm8cbpw1q5wmn1s9xoekek
X-Rspam-User: 
X-HE-Tag: 1768524188-748866
X-HE-Meta: U2FsdGVkX18eaUVrlkjCbszJi3xP/JlvBu/JQVIemhQk2Cbg+NcvtVBwHj283WKXxUE4X+RNAVuViGd5WLVOI6qTHOPQOegL8G1djCl/ntVvABK4p4baKVFAcaXEyNrzuFfis1YB8DS9uDZ7U6vsWZBmRTCr400lxgRt5tXcZcB9gk/up0LqRif1m5hN4yh3qrfJKqHqV6XbGI14ZnAMC197ItZr89GOiicKfXd53ntq0hPlfaV2GCTG4Zr2UoWNlzzCA/hWSrjejmWaBG3miijYe00FraJC4Vth67o3pic2qFJEoAVOV8x/4rCsL3RoCv8CXaqLCXzgyqwPpJrfKseN48rRII64DnZ+lTAt1V4HBpyGV591Rjgf2KepnpGGeQhVNMPA4q6gGWKhS8WM8mlvtRc6KpJBK5jH3P28r9Hu6kpLXx6OQXbM3SsCWqjCsJc0s6KSRT1uykR4HHv5HPRixQVrm9pD22RvZf8W4Z675pusdjs7TCCWV+mmKQ3HmPoKZJ6SVgn7L27LATWvjV+Do81dcSFARBsA4EY2ORtmOOvyeOvRPwckghRmbdr9KJCUKfyFENAshUG9Yx1eIcBCUQ7Eb2XTw3LQd2rwAoLw3RI5ANcduRB8o65BVLWx9kbkAYYfhQTs5GjwqjYMbCVGNzc0P1AysV6NsqM3sLalGqYRJbBze6S15v6GGKFhK0juHQerW4oEuZvdvlHHtaAaxisW6Oqc9VHTpaZyFmvXl2Nex2vdKCVAqeL/GyqbI2hk43WFZNpog7f8Pv1Z1tM70nar/QIB+EYdCXc855XnuQMREPF+2nXiWGCHIWlYVr+K6c2ltlbpvsYGu9Vm0DJMeYXglm0JWznNsdbXnyw/ioaBkrHGsUCIEkB2tmUP2hYq+TDq/W3751CpQFM19zM01yGUn/DEvglwPxqtdijadhpqu2+ORgQR/KRMJSP+YY3QITjQRrtwl4fyHFo
 fMANl3Bh
 ClJUPP5bsVDYpw+r0WABT/t9kBZisBFO1Ulx5o04HIKMGuANARiTiGu9UMnDMgFQUd20lLMaLskn4xVzScpcWdZAMh8+ieSRD6FMd/MrAwxIbj6NO0Orsrrp0YZ3KxlGSZs1QAmEJ8mLqkrIRM1DL8E8vwiBn8DYTymlxivovnvdVcx5ILCaoMzfUyhOYtrypCeRcmxiJFWE5PRXQHE2/guYvmVNio3lDaNnAi57I1M/yxBut0SXaM3YCyGShRL9lRQKmJOhiDHm/XByJN7Y+9vHdTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 12:40:12 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Wed, Jan 14, 2026 at 09:58:39AM -0800, Andrew Morton wrote:
> > On Wed, 14 Jan 2026 19:26:43 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> >
> > > This patchset is intended to transfer the LRU pages to the object cgroup
> > > without holding a reference to the original memory cgroup in order to
> > > address the issue of the dying memory cgroup.
> >
> > Thanks.  I'll add this to mm.git for testing.  A patchset of this
> > magnitude at -rc5 is a little ambitious, but Linus is giving us an rc8
> > so let's see.
> >
> > I'll suppress the usual added-to-mm email spray.
> 
> Since this is so large and we are late on in the cycle can I in this case
> can I explicitly ask for at least 1 sub-M tag on each commit before
> queueing for Linus please?

Well, kinda.

fs/buffer.c
fs/fs-writeback.c
include/linux/memcontrol.h
include/linux/mm_inline.h
include/linux/mmzone.h
include/linux/swap.h
include/trace/events/writeback.h
mm/compaction.c
mm/huge_memory.c
mm/memcontrol.c
mm/memcontrol-v1.c
mm/memcontrol-v1.h
mm/migrate.c
mm/mlock.c
mm/page_io.c
mm/percpu.c
mm/shrinker.c
mm/swap.c
mm/vmscan.c
mm/workingset.c
mm/zswap.c

That's a lot of reviewers to round up!  And there are far worse cases -
MM patchsets are often splattered elsewhere.  We can't have MM
patchsets getting stalled because some video driver developer is on
leave or got laid off.  Not suggesting that you were really suggesting
that!

As this is officially a memcg patch, I'd be looking to memcg
maintainers for guidance while viewing acks from others as
nice-to-have, rather than must-have.

> We are seeing kernel bot reports here so let's obviously stabilise this for
> a while also.

Yeah, I'm not feeling optimistic about getting all this into the next
merge window.  But just one day in mm-new led to David's secret ci-bot
discovering a missed rcu_unlock due to a cross-tree integration thing.

I'll keep the series around for at least a few days, see how things
progress.


