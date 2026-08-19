Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD2EC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9686B0092; Wed, 19 Aug 2026 04:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8276B0093; Wed, 19 Aug 2026 04:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496486B0095; Wed, 19 Aug 2026 04:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 170B26B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:11:41 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9415AA0496
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:11:41 +0000 (UTC)
X-FDA: 85117300002.22.5E507DB
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00AC520007
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:11:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf03.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787127100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/CrPPwtK7AAEBS7SVTgGzl9ODBNv+owz25Ni4teYRPQ=;
	b=nw/z1AYY+9xLxSyzyFVV9sb4T3zcaNmSY8WDRb++Ii+6pjL1zrxn6EN15xDreGMc18vYCB
	v/S/K8lrSM4hLIFbs4w4uN/NjDXsQV5fegD/ochElknQ24vVUhkpiXgBp2m++lF4tlnVQ+
	BYaoZ926jwq+hBPDcIENmJt/j8tKLQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787127100;
	b=UqpSMleXhwvq7FqwXtlvcwB+UJkaIvK6vQfTky5V3jTgTmpSGbt0MVu/tUScW9TeYqi63s
	USkMPNVYy3W+fPOpS0HIptp0Rb6dO5OsY/nDhVWhfW3vyrdp9djl0J8P+bxzNFh3IgE8c5
	Ecsnc44KCiFIupWl8vWzttVqPkj3GCQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=sk.com;
	spf=pass (imf03.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-f3-6a856537501a
From: Rakie Kim <rakie.kim@sk.com>
To: Gregory Price <gourry@gourry.net>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	Rakie Kim <rakie.kim@sk.com>
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Wed, 19 Aug 2026 17:11:30 +0900
Message-ID: <20260819081133.1924-1-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <aoRbDEn1sQ7b22dy@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsXC9ZZnoa5FamuWwYZZ7BZz1q9hs7j7+AKb
	xa4bIRYnbjayWay+uYbR4vnWX4wWP+8eZ7e4fmslo8X+p89ZLB40rWKyOL51HrvFulOH2CzO
	zzrFYnF51xw2i3tr/rNavHnsZvGtT9rifp+Dxcoff1gtjqzfzmQx+dICNouOl/dZLG5NOMZk
	sXpNhsXso/fYHSQ9ds66y+6xYFOpR3fbZXaPzSu0PBbvecnksWlVJ5vHpk+T2D1OzPjN4rHz
	oaXHi80zGT16m9+xeUydXe+xfstVFo/Pm+QC+KK4bFJSczLLUov07RK4MjZeectaMF+oYvW5
	LewNjBf5uhg5OSQETCTmzHnJCmMffb6EsYuRg4NNQEni2N4YEFNEQFWi7Yo7SAWzwDZWiVsX
	NUFsYYEgia7pzxlBbBagkh1HvrOB2LxAU65tO8AEMVFTYt3GWywgNqeAmcSv7WfBNgkJ8Ei8
	2rCfEaJeUOLkzCcsEPPlJZq3zmbuYuQC6v3ILvGkBaJIQkBS4uCKGywTGPlnIemZhaRnASPT
	KkahzLyy3MTMHBO9jMq8zAq95PzcTYzAOF1W+yd6B+OnC8GHGAU4GJV4eCPsW7OEWBPLiitz
	DzFKcDArifB+nNyUJcSbklhZlVqUH19UmpNafIhRmoNFSZzX6Ft5ipBAemJJanZqakFqEUyW
	iYNTqoFxaearFzEnNcxdr2zm+3XCyt9W9ow3T7XjhtqVTROX1nr81/zFGLnYpT3/o1jp0w4b
	ycuiZqoWqzZkqV6MWTEpgW2SBPcukS1c1fM7cxPZP56NK/t5vSml0q98mkm7lssroQjHP/e+
	sC06G8nCYKF/yUSmUL5trn7t++chz/V3MC2axRw931qJpTgj0VCLuag4EQBOzVVHzwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYQCG+c7OOTsuZ6cleVBYNIjQ0GaYfYLIqGgfUiCRBGXqyEObzimb
	t4mZl5KyEptK6iwNo9QtzXmdWcbyTlmmaS68pOW0NCtD8wLlkMB/Dzwvz5+X4gie4q6UQhXH
	qlUypYjk4bzCfSGeh9mrkeKbpoOwpMZIwtGptyRs+XAa9uXrSdg9kk5Cw4gRQFvDKoAro11c
	OGytBHBx+hsHtn2x4XAiowqDXQ33uPDl3R4CVvdaSPimuBeHAy0lJBwz/iXg3NRxuJTjBsdz
	JLDyzzoBLUM2ArbXNGEw710ZCa/NjuPQmtuJQYNRDtcaK0io7xjjSoTIXDzKRWWmeHQja4CL
	6io8UHnrLIZMVddJZPql46LuwjUcmT/5oZm6IoBuZX4n0dJHhMpnfmCoQH8Z1dS/x9GiSRhE
	n+X5R7BKRQKrPhAQzpPXDs4TsaWCJENfPTcN9DtlAweKoX2YDtsDkA0oiqRFTOezEDs603uZ
	rEGpfcGhGwnG2u9u5530KSb7jg3YGd+YNLcvk3bmb1SGGl9gm0V3prrWitvZgfZlVpteE3YW
	0I7M1ydtYHO/g+kp+oxv9nczmQ16Ti5wLN6iireoMoBVAWeFKiFaplAe8tJEybUqRZLXhZho
	E9i49OGl9dvN4PeA1AJoCogc+SjoSqSAkCVotNEWwFAckTP/Z15GpIAfIdMms+qYMHW8ktVY
	gBuFi1z4gWfYcAF9URbHRrFsLKv+bzHKwTUNhMrLdRqnyoLhk5IJS98jzA8jyuLwFPHj+7Te
	NzMgbpQKW/ROPCc1Z0yWSqxu00IKCRZSp+pX5nUT7QXnj2xTzQUbdnXvSZ3s3G9ayU9O8dQO
	+YuPDnpLF5YDXfiixHQfN+Erj+lgTWpu+/ZWszjEeXZ5rMLzufZYS2voCZ0I18hl3h4ctUb2
	D0WG0FzOAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Stat-Signature: bc3neerye6acmn11oizcms5u9xpe15xw
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00AC520007
X-HE-Tag: 1787127098-894086
X-HE-Meta: U2FsdGVkX1+3UqanMIyw1Q1PTXT6yVaMQekV/nJtJE7dqyKx0n+f3hxbYIYM2Qmrrh+SJknw9BhxQ2/jaSjNb754gRStRHsOusrIVE8by039TPU2lldUaE/SjsxkC9j+SVbIF1nJ4qVelSdd/Sc/bDrQ/bRlqVHwlWgVWmnkjLpFiArxdqKKu4IwUyQY8a2XiSTj7eE0iPJMnDxMuOkDIblFXDs3j5jxzOC65PSkfb+/87mASvZWYC1hUseIIgRvP5f/93054ZBg8TUzys+x5/2A/sK5bXLRpwQbDZFhGB3QkS3tidq97ldjQ5fapxj4pkbvS8gK5QuxbuZtxZOsyNL+B0b8bzn0FGtlpjshA3fzziQcDo4KcRulgHRGZGeujUGKwdB1U86NoLl5kC7D7vGqrVZ+2sR4mItmLkJrtgTkU9NN/z5cmwEbY8X1h83I+j0VaBqmRfwJoPx83PIeiu034ubLhsvBouM4UGxW0tFXBMorC+klrybpjb7k8FYDyl9QiWcT9CLFwpiCIZoB1UaRC1yB4OIYGjcC6JEu21X8LxnWQTVo7wVSVmDfJSDW8MZEbM3plxdPFQGAKsNOEcwn6ULxsHuqhGRHuRxEKcnkZjaiUEXssdKfMHkFN1JTqz03DpXumhEl8b1M5HnXmzmi0kNoAmajdhuDehDK8CET0Ls/HYMztoTMz1Y+Hvd8E4jsb4KZhUnZLn7jb0zTP/BDonxYT1JCqNRaoDvZvzdIdjdxcaNxRwMXnU/H1GWE563PWEUEvtwbJClJumCb0ZOzE5Y6IVA3W/WHmc6VL8+Vv2Ntmqwud0MlC28mKh22pA0Xs5wFLz0YTq07DReIcH5mfAhLgNpbhN0rJFPwCwWaKyZTXTU03wqlt4snVeNTcw86acGKblaVcLgLyB/U6TCQUwUQC0tpPr/t9OHk1/nWY0Wp46A+W7UlLsp4JPkPEwQMpyrLSZE3Yb7rJZ6
 M4RnfAQU
 X6STLE/Y3bkV4stiPW/DUSC+DQ+jVY7VrfsLF165G/fOmBCngeKIqSB8D4w5H+/SWTjjDT/s+RXHnZNL5km8EP0TAjWpA4yHJO87QeC1DnqnFpnb2jl5oREDshg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 09:30:36 -0400 Gregory Price <gourry@gourry.net> wrote:

> Not concerned about the performance, concerned about how complicated the
> mempolicy - cgroup - zonelist - page_alloc interaction already is, and
> then adding another filtering mechanism on top.
>
> Today we have:
>
> 1) cpuset constrains mempolicy (nodemask remaps)
> 2) cpuset constrains zonelist walks
> 3) mempolicy nodemask constrains zonelist walks
> 4) memory-tiers.c nodemask constrains zonelist walks for demotion
> 5) zonelist membership constrains allocation access
> 6) a bunch of corner conditions that violate 1-3 for the sake of forward
>    progress
>
> now we're adding:
>
> 7) memory-tiers.c nodemask constrains mempolicy nodemask
>    except when it doesn't, because fallbacks occurred hard enough
>
> It's already un-intuitive how and when memory lands on certain nodes.
>
> To be clear, I'm not saying this idea is bad - either as-is or in some
> other form - just that adding another nodemask filtering path is making
> it harder and harder to understand what lands where.

I understand what you are concerned about, and I share the concern.

I tried to keep the addition minimal and to make it act only in the
intended situation: the filter runs in weighted interleave node
selection, only while the toggle is on. It does not change cpusets,
the zonelist, or the allocator fallback. Still, it is true that this
adds one more filtering layer to the constraints you listed.

I will try to organize this part so that it is as easy to follow as
possible, and reinforce the documentation as well. I am not sure that
will be enough, though - it needs more thought.

> Mostly starting to wonder if we're reaching the point where the page
> allocator needs to take something a little more descriptive than a
> nodemask to dictate placement.

This is something I think about a lot as well. Many users simply let
the policy use all nodes, and in the situation this series targets,
that is exactly what costs performance. To fix it, the kernel needs
more information than a nodemask carries. But as you pointed out,
adding that information also adds complexity. This is my concern as
well, and I think how to handle it needs a discussion.

Thanks again for your time and review.

Rakie Kim

