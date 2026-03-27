Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915E710F2843
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0673C6B0096; Fri, 27 Mar 2026 11:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F526B0098; Fri, 27 Mar 2026 11:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE62A6B0099; Fri, 27 Mar 2026 11:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E06C26B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:30:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C3A38DC14
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:30:46 +0000 (UTC)
X-FDA: 84592230492.25.BB00FBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6646DA001A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:30:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dUTxbmCz;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774625444; a=rsa-sha256;
	cv=none;
	b=bJy24o0P4Omy6jd56ANU7GHlXFFY2Dya0dK6X3co/l2L4zQMeBYjrUlwSH6TsfMnG8/rYp
	YfLRqDUneq2WaD+VKTVFDfBffFMgsnqr8iBW06cNP5MUqd/C+ikyMrallCMrIA5i/0Addt
	r+btR1DmvOIetG5tvtOeHSgB2Bspa4o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dUTxbmCz;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774625444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/1X9sSGpYdtWgWWiiK9TbMjy4q3Ekq7uDFjF9dt0Xs=;
	b=O1kkUMg0wFzLGvxoitSmPxSaPk/hVBdb99EZ/9B4PDPhQYwIulI3YT/WVyMHpuwZjqvXxJ
	xK+Mib1xuNx8S6W9+tGZQKHGT9D2HZgJicB+nhH+ySAtXJ194jlRZNNgC+sqtubOSGBeAr
	Y1ISAap/96kUuWG9NrktF36zBKhmoyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 78E2760054;
	Fri, 27 Mar 2026 15:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87F0C19423;
	Fri, 27 Mar 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774625443;
	bh=SMebY9ZTaWWRA7SmqcieTLSkL0fd4WuEFVirgLwpLao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dUTxbmCzVq3tVCuof0pebARQfRtn9eu+rKkqBqJ2Pk/19CZ9Bpmgd2B53lToz9Lr/
	 QaPM2vA1Ckq/bfCT2794y442mvocn3tQ5jvhRj68jBvOrOdS2HFF38yTznkS+Tv4Q+
	 QL+9GgwdMOjrwqt3TMu0ZQbqpZMoqn6S0PKeBzIc=
Date: Fri, 27 Mar 2026 08:30:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ljs@kernel.org, baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
Message-Id: <20260327083042.da4fd1586ab8aa2f639393b0@linux-foundation.org>
In-Reply-To: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nycr3isa4xow7w1n933qk5tsrf6yqo77
X-Rspamd-Queue-Id: 6646DA001A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774625444-689043
X-HE-Meta: U2FsdGVkX1/lnqrpncM9FzkgpthFEweWwCcYtIrReT+nVhxVJWigD7rsytxNr2RZ5P7sG8emoSOLEYc7Bj/UajwG1Fml/MtQaEFQJP/Nqz0VWXyjCoDqeUA73ZtBse2yONYAR23i/6k4CiJmtpotR1WLRqCfMIAeiMp+7k6gH7tTMXBFBSM8wBz03hpyR6brv+1Tiy8bxV/Wp0vevWxinlliUTv09J6A400lg3Pxj9pmb5Tu3iY+gaSorGVwWsaIY41CZ6szDSqL7NXk6OM5Q2ZIPw0oRLZ+9rO1EXSIIk3x0oxkrt5SustcB4lR/g2q0UeuEAbcsmKm71F9dxURrhXaMChwDa79lmwnut9ZV6SCxFk5E+0BufHPlE10lX537V9RGx1ze4hJPxmHQb+cBB9MVZ08yHXLn2dIQG5OnogGF8w1hJ78ajSwGGIluhCoKexmi8+hjIu8jGBqcjIKS392Vy/5exp2pUudltswndsTKzLhodProuE4As38SolVe03/Uj/Dw+LfbDmvl2DCVPYZ/FHWTl7ESOubBLNmTnRwiz+fxGn8aDs7U+mqZ/u/4e1PvkIjux04IpJM6D3W0pDadd81mUp5YOR8gIzaNvUjdubn6Jacmbvkq/5lMuOYKyqDc4rhgtQpDVSEf17mhex1Ur/yhh4D0eGyfOzYRmtLJG4oKJDEVnx1HmVqN3ZV5U1rcKUtuGK2V4H7goAGu8w0pmAWaTJ47qeCPRZL4zgSrsS2CZ5vsY/siabs38gU+qVmIgIgQ4d65aAnoTG2+rVBHRvCtrSzsci02KAcsGTeu0amptv0cm5wLsLNLSoR1guu23b6vEnjwTMOD9vqlQ4zUcJqYELv57NpCc7ZLo2UvoRmSU1N8raQuR+8UD68L1rJH9EtWgHAbI/n8g/q1nwvcDE/hz4jv/5WJv1D6+W19wZNjGbSC+LwkDcMKxE3HtYTsMJEJ/Z7N/1N0Ff
 hWea1Lp6
 JGXeezwKjLpF7KnDdGr2PC739PvqLGd3e3HA0Cv1XeQ1IkSmZ55o89Ro4y7CrO/P72j7GcoJCIEMsLnSZC54aAkATaEW+vGqi/nv4F9e1xu0y+97ewxBUWCE9tQL7M97A51ggsUZcmYqU0pu/sYhptAo8Zn42KUG75hq9/hOavSRQ8UZWFgr7zQ18pU1Y7iHerMDGFQnEfaVTmzFXkradcdp3GAuBQzH2I4akeNsdrr0qtpEXYbKvBbnbQO1BZp+QoJu8LJ/G5fE6GcXB5qtC3ixzpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 18:21:08 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> on traditional hierarchies").
> 
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
> 
> On large memory systems, the flusher may not be able to write back quickly
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
> 
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.
> 
> The following test program can easily reproduce the OOM issue. With this patch
> applied, the test passes successfully.
> 
> $mkdir /sys/fs/cgroup/memory/test
> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
> 
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")

3+ years ago, I don't see a need to rush this into 7.0.

But should we cc:stable?



