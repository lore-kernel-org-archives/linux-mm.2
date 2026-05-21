Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68259CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5016B00BB; Thu, 21 May 2026 10:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B864A6B00BC; Thu, 21 May 2026 10:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3FC6B00BD; Thu, 21 May 2026 10:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0BFF6B00BB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:30:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 660E914050E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:30:56 +0000 (UTC)
X-FDA: 84791663712.12.7444BDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7F76720018
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:30:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvRGgHMC;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ytCtYAbDMoi50EVmKyGwP8l3Bc1iyOOpcTsBTsqE27Q=;
	b=7nSFkG9f06nFCKitguFKlVpVDcNDYfRpuWTTyxAPuUnLj66R+d83qixCnabM+x2saKBOz3
	GLuHnxnbHIqlx83tRf9aSmjs93wnnKk6nNxSNq7+Gsm4e/8wWr5J2TzvcLyQ1wVxxJLjrR
	bmPTkhal54Cmo7qQNxM3pI2rYmCKej0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvRGgHMC;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373854; a=rsa-sha256;
	cv=none;
	b=bmRRCtbapK2JfnuUXZtUtgL9aGBXAeZrt6Fjw8B+wTmow4+ZLmmthSssbrlr9V0rA7kPUC
	XRVvYkhvdcYjL6fFUsn7zU0Esp+G+9Sn5gPqCPnTwuyhPOQOeS/BJUQ1A30KnezXxStF3z
	l3WUUjH3eKxG4uF799TehIY1xrU88P8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EBB14394D;
	Thu, 21 May 2026 14:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C4E1F000E9;
	Thu, 21 May 2026 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779373853;
	bh=ytCtYAbDMoi50EVmKyGwP8l3Bc1iyOOpcTsBTsqE27Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BvRGgHMCe08HiDzpk54AlIL9OaxfRvKXudxABSaibuH+gLfHbJg0Vm787J6VLebpF
	 OClo1gXqbzHmRx4zOyL2i6R1MDvDVD0tKRbZKpK44itxD6Zk0b6y2oBJGCoyujWLZZ
	 kpi6b3a/z+uHFabnDqd+RoOH5h3u+DR8oG2I1un3Vm6gG5eqQdBZEWeZIhaYY2Lbly
	 0gLkdeLGBjYZGUUnLj10fon1L4CqlOArgJpcuotXU4Yj6Ag93UlriEmlwq2KYbl5DP
	 KMAbR/umSaW2R3DdI7k6Bc9MPYMmgUn7YdUsmjK8RnyEMch4qzGth7n8raLO1bTivA
	 UHzOsQ5N0K45Q==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Thu, 21 May 2026 07:30:48 -0700
Message-ID: <20260521143049.82745-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521045236.115749-1-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dxkgnqrk13ux7waegot751a5jimpeur1
X-Rspamd-Queue-Id: 7F76720018
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779373854-887464
X-HE-Meta: U2FsdGVkX1+Gw9eT2eDqDtbzXbsJE9W8hBsrzGcRmVmo6CngZNILBgMgfE3MzELjNbB0CCgYMlZoJYHzgnDHti8mxaZIY4dbnCR6KVb5IEzR6ci5VAkI5JG6aA7qnAFQoK5BOLFEBqjzZehs7PQC74x65e0POmp5LejEHb2fZaX12crsB0PktA/MLSgHyNxuGvUUbtSBZvM9nP+hhy/pD8Dr0prLk8lDP7krpdl6oAsfFdVLxOl6ggIUNtUgE1tt7/7Pjvnp3xerjyhyUNtQtsuDd0RNmDY6FFsjImpXy+tCr8HqB+z/ahG8xTKoXxnqmfKwDA9Z3XeYfS6FPFuJHUV1K+TMBCSzMqs4eQHyb00ED17icQlt8VyfyOnAeDS10NVjeRnSmBTqG0VLlZAslxDoYiXi4/tXydGV0ex1ycWfBzXBZABOoJberzfV4cNUYkxIN0Yi6la903EnkupIU8JQC3MXdtisiWY93yhT6erkQwY368guIk1bgXyUjaKKQ6GgLBTfV/x0rBQ98R7t8b3yHL+qe0d9VEhaGPNhfD5mznUNPrUC+eQXeS5GjEGe4KKzT2A1aGrhzzE/jpsvV4TfQpfTHML5MD4gFGzHeLUJhdAb3I4u/RMd25V/YsD/hsCf5qTVdSMkTtv2qtVb7tyS8tSemop4Q0jrq5WNNFsDV27r3e4dnXnfJ3p0E569mdAdCxF/pe/ghFbCiW6e2MUWG+PV04eBmEngLeMTZ9MdMcAYtCEenu1m9sqvG0+xXapJRWUZ7QpLNm1fjWNt6S6HLxVyh1xuZxA36QO1CaCy3NLilwW86hUTubx5Je23hkXFS/UMHycQ0jfTZkXE5bOx05eu9atQ2J47FakJ3mNHiMOxvrWkiPzRnldGnZpLzfNIlsuBiF/GUwZnFHH5Piq23xyR0aTbjsqjMrIjdbGbFIVGcGsZ0b0p02LG6zqHCoDF98n7QRMGS2gmDxs
 pBId+X3r
 fIixcW05fj4CtkVGhZmUuZuN8m4gN0ulQA9BwpSJAWji11k+27tQC275J7dmJhjgQtDVY2B8s0ByPLG99uK9E50K0Nn2kZNSNhMRjYnsGH8AnUQPnmCuNWTUh+bHmxc4qwqvqUS/XjxiGc2Y8m0KArRa/pb2LeepSKuyjUpZzR+xGXnf7FtIj6FJYS4at4HOAwGsC8ZAI8sCV3HNoXMck7PIFSP+5ERItQN4I8w9YfIzVwrI72kWI6WFPilxcbOcWwGs8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jiayuan,

On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> kdamond_split_regions() bails out early when nr_regions is already
> above max_nr_regions / 2.  A large region that picks up new internal
> variation after that point never gets split, so we lose visibility
> into its hot/cold structure.
> 
> We hit this with damon-paddr on hugepage workloads and damon-vaddr
> on processes that mmap a large anonymous range.
> 
> On our production tree we added a current_nr_regions counter (no
> good upstream home for it yet, so it's not in this series).  We saw
> nr_regions never getting close to max_nr_regions, and the picture of
> the access pattern was too coarse.

Is 'current_nr_regions' somewhat showing the number of DAMON regions?  If so,
you could also get the information from nr_regions field of damon_aggregated
tracepoint.  I'm wondering if you considered using that but found a problem
that made you have to implement the internal change.

I will be happy to help removing such downstream changes.

> 
> Example with max_nr_regions == 1500.  A target ends up with 799
> small hot/cold regions plus one big region (an earlier merge
> collapsed a uniformly-accessed range into a single piece):
> 
> H:hot
> C:cold
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
> 
>     nr_regions = 800  >  max_nr_regions / 2 = 750
> 
> Now a cold subarea shows up inside r800:
> 
>       r1     r2     r3                 r800
>     HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
> 
> The small regions can't merge with each other (their access counts
> differ), so budget never frees up.  r800 can't be split because
> nr_regions > max_nr_regions / 2 returns early.  The cold subarea
> stays invisible.

I agree this corner case could theoretically happen.  But, would the small
regions have the current pattern forever?  On real world systems having dynamic
access pattern, I guess those small regions may not keep the shape forever, and
give chance for the large region to be split.  Am I missing something?

My theory also implies that this kind of situation could happen at least
sometimes for temporal periods.  In other words, it could happens too
frequently and too long to be problematic.  But, in the case, maybe the user
could mitigate the issue by increasing the max_nr_regions.  I'm curious if you
considered that direction and found a problem that I don't expect for now.

> 
> Patch 1 lets this path still split regions that just changed
> (age == 0),

Why 'age == 0' means it is a good candidate to split?  Because it means its
access frequency is anyway unstable?  Or are there other reasons?  More
clarification would be helpful.

> up to whatever budget is left under max_nr_regions.
> If a split turns out useless, the next merge cycle undoes it.

I'm again curious why the user cannot just increase max_nr_regions.

> 
> Patch 2 adds a KUnit test for the case where nr_regions is already
> above max_nr_regions / 2.

Adding tests for new features is always nice, thank you!

I will review each patch in detail after the above high level questions are
answered.


Thanks,
SJ

[...]

