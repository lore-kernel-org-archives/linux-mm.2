Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782E6C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 986116B00C1; Fri, 18 Sep 2026 20:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916EB6B00C2; Fri, 18 Sep 2026 20:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8298D6B00C3; Fri, 18 Sep 2026 20:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA7A6B00C1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:56:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE51B40161
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:56:07 +0000 (UTC)
X-FDA: 85228695174.24.516F353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 52C2BA0004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:56:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koKWAmIM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789779366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLSey5EwmTczQHfC6e3oURw6GECTJUovFx/5PEz81tk=;
	b=5LuYW4fz/9ROS2CG8t1tSybe4rew9e1PgQ9YhiYsKE3B9lcWBJysYTBnaozA9eWIDLuGuM
	XotOCGPPlXAvA4+nHzfg5wfqTWq/v9DilIATmrXJGfCnw2VjsB5TRQnCk/O2ni29RECC3a
	A1ofLBpVVGexYiubZiOt4QBv9AKRNtc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789779366;
	b=nasI93I+8c7J+UCoJkxjfRxmAj6Iri3+0ZnOlTZhKbAsNriypnPekcRgm8yCR9/eT2Ivro
	14CaPJEF6OyMVPmY9e0Az2bQqPoOtbe67OjsA5ekk8wv9pqkJ5pcD6B3bfEgnZukDqBHB7
	GwvMrEKx0BDX0qH9RvopRIm0YK6gs9k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koKWAmIM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88AD26053B;
	Sat, 19 Sep 2026 00:56:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDD31F000FF;
	Sat, 19 Sep 2026 00:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789779365;
	bh=WLSey5EwmTczQHfC6e3oURw6GECTJUovFx/5PEz81tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koKWAmIMGFrgR6e4punkJ0rHQ3GZ7gEbdrPdo87NikvO4TC8/dENCzrPHJl5M3T8s
	 u8zPcj0hZsixZOzJtiu9cYcviqrjA58gX2Nyf9tHMwMArgyVnqVVc7mKuamx7Id9BV
	 j0cXS5abW64bUyXkZOi1sh/yyo1e1Jy+8vsFspQiWO8+iJKYQINEb00XxL8AYRtWbO
	 VOnR9Mkk2yoPn+aEwbAMlxwlxKpauG5VlAMOXbgq7e8q0zhMR2Kg8av0T7NS0AHELm
	 30k2qYLXz8IQXe/lPFQ+4aJclxZJJCgG4N/ebdrUwQDXiKvDt3asq6Qh0tFOjTIl6t
	 ySQjcFvjt1Ung==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
Date: Fri, 18 Sep 2026 17:55:57 -0700
Message-ID: <20260919005558.87687-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260918165601.1014666-3-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ot7xit1ei8rg3ca4yhzwstwqb5pt7oce
X-Rspam-User: 
X-Rspamd-Queue-Id: 52C2BA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789779366-450332
X-HE-Meta: U2FsdGVkX1+gR9VNoio0XOUFgneBdk3KgxnHzUzJtM9iIBmB1wsKr48AZOZCurENm4dcjIbxdA93dXMtqq8g8FxsniEnDZgCGnU+pNqgfoKWH33bCz/4jsh6kiDvKslGWUmoRDc7iqZEZ9cnnPME1+hntpUGgpYV6R0CQ4DMe5P0uSzyvwgH9O3TC9eYglIpAWtzRKnKs8Q0B5wEE52gH0OtG2xrLvFl2jIDL/pQwXTQVrEVroC1oslOgXt825evF5Kb7dckBC7yGyoUzTWd4rBh/TuM9MYE5vFtuLA5MNn5XwngF4/P+CxaMqq3fc0lxfiIsYPMExtYX6Hq/LI9b5331nm3gzDW157Mj2nYtPPWSiL+3rCpiibzxFclpa0zZqecSOZRS5qjoX/LFOF3WDRPoosgE+aE4NJNC1m9pRfQcrhbmuC9xsA+IYuv/eYkho3BHzi03JZoiTTqBfT+0o4ybqlGnN4KSpFdVJ0FVyiyBriwO7nNUp5RT9EqTvdilTWQsLQN+w+wZcgr1+vaV0SkvPWZWuDDc8ARJY//r8KqOBmmxMwSHtyzWyQM2VFruvU7BEfWwzfkwQukd/DQfLCcLtHgs9CC+1x83MZiUNP+wVVjOgSmwoRLGN2lnENJOUpA6gRxr1AbZUnoHE4Sv3zOUg06GGzwnMdJnVr1jg5a4qQxKf/V9zXt67bIYgVTBYvXCFqXFuvYtVp93KVsV1WtcaEtE/ym7wI1j5PlNyjcPln8vfMp9nz5pSHAYSVjnXce08n7hU+TWTkER9+UAmR2wtet82PWEohMFZ1G23ECIzf16Iyjvt7a+kVfSRhnKDiwfS9I+fgKrcZs2sDLMGtLpiygHzEFRP3zRNqIkZgFZRlRvbwP8OeYnH9ilmfxop+o0bGCG2DeEfXgcQ8XjX74PCO1To6NXPRzPfgF0dNCT4mSNEnQv8EBHkpwltGXWZOHnkoSLjfenIPKA/x
 Wk8SLHTN
 IAO1G3psqDGVilG9M0GyIX6cqiFluWry+Sn/HcHSrt32H3kVOth9TdbUdPmqQCZrK/xMyeyeYqGw5WNVb3HSufVDbqmk0dJAY9nkorsnwT0xv8gBaVpmCXYPytjgP2lncCrJhjGgTyOwPw63dFBekeCNynJWcyYVQ/kI0xurfC2OebcNK59OI+Gdt5n11GCr8p/1Go/CMIc7OBusnHziAP4U6QOW+034cDGQs98Z4ND5KlxA8NGY9U1aABTdz7IDkBY2YoE8vIFgB75EX4lWcob2jZkSrHTL4wkc6PvQSDfmcog4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 01:55:58 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
> vmstat counter"), mod_memcg_page_state() has no callers.
> 
> So remove it.
> 
> No functional change.

Nice cleanup!

> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

