Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CF2CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 16:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BAF6B01B1; Fri,  8 May 2026 12:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3256B01F0; Fri,  8 May 2026 12:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F946B01F1; Fri,  8 May 2026 12:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 749956B01B1
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:15:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C9BF1A0213
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:15:48 +0000 (UTC)
X-FDA: 84744753576.06.BB677DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5CF71100006
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:15:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pJYFXwr/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778256946; a=rsa-sha256;
	cv=none;
	b=EOOs5hy3X/z15KtZLCWWPqVWTPu8+4lumwkrH7GTN0eltQ72Vde+phDyQUI3aQUH8EEHSc
	2eDpWL+ixRRJen6i3lKknDe8QKvFoKT2eMKPSJ4PscZFLRGXRVtw4VWVZopmVL1WuBNJff
	c8uhXtabzTZBtIwt3X/36aMHDAZ/SrM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pJYFXwr/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778256946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAnqsN28aFsNu/16NTMPDAYgeawX2B4xGrHBZ6/nEb0=;
	b=I3n1oykGHJdP8mZskmR0tvXpdFPLi+4dp4j0vIyMRdsK+OU7cLoQWgZb6NlUgQCUZHsq09
	ZYsqEH/tSeMTnukpYmi0HrCTbwfF45jYxljeOZH6POrpHrnQuhmjlQSW5wwQEqR8o+BCww
	eCniW12x3aE9HfVOnaPBd+1ptlhvtgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C948435BB;
	Fri,  8 May 2026 16:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C9DCC2BCB0;
	Fri,  8 May 2026 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778256945;
	bh=Ft2CV7mOczaOt1OzoiUOD/+6KLhVH4/495HB2YVzZFE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pJYFXwr/jVOt2dthilIBJ4EW9vU1GA/rNvI8q3uHg8znFcrjpqg2ecAz9ArE/89sc
	 vVnvuPJdelz2beT23aYiFRZ9Irxr4+CzIiLYEpSHF0neJd2dS+UhJfLGWA0H5vIDbp
	 1s3fylw+iVx7Jg5mmOnJXnrQBy5h35BfUZfzbopSEGmfIwO6GcDQNyYsGD9kI48He8
	 P+q7Npvr82EhjN6MwgVVpYFtPcmk3kobD633dw0VTxK6LA71K2K4TOPflRFhIPlxNj
	 3scx0jSRHVXvMDhRGFAfMCNtTfb/Dt8pXLEhwYKUlyUg0Dzu6AovNWAIeubFl0nfN0
	 utEYw6QNRQSiA==
Date: Fri, 8 May 2026 17:15:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	david@kernel.org, roman.gushchin@linux.dev, inwardvessel@gmail.com, 
	shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net, surenb@google.com, 
	tz2294@columbia.edu, baohua@kernel.org, lance.yang@linux.dev, dev.jain@arm.com, 
	laoar.shao@gmail.com, gutierrez.asier@huawei-partners.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 0/4] mm: introduce mthp_ext via cgroup-bpf to make
 mTHP more transparent
Message-ID: <af4KaeaCWUSfOS-Z@lucifer>
References: <20260508150055.680136-1-vernon2gm@gmail.com>
 <af4HYivyP7LDG2-k@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af4HYivyP7LDG2-k@pedro-suse.lan>
X-Stat-Signature: thnmwyer435osxkpkman4uxg1eifez4w
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CF71100006
X-Rspamd-Server: rspam07
X-HE-Tag: 1778256946-565013
X-HE-Meta: U2FsdGVkX18Hd0o6sQSEONSe+QSIgDCcvRA2Z0aX2QodjHUuOAqDb23BPiX0CNCApE8quVWBSQ2fnXnIvHIlIGd4dT2aM38lGwokT3eUkPA70rBeW6QyiCdcW/gNG4Z70R4ul9d0P8JVs1jLxUlC7HwPvNjzL/goroXcC4SjRwOhELETtnd+NxXV2ViSTTee4e2mWvoBRAJPrXWb0S/azz/Uh7sBx+LmwIco5Y6jj9jZj/KzvxN1qdLbWObc5JKqmkqV3B1WOPX+fkuGWouOBULAyelb9w1uIQ3f1tEj65gfKFT80h4nvgs/Labp+uVA7YN50DM1c+2prOf3HuOiW17CNLEZKkmEsZD1AGFmH6F3Yj3Y7H1s2ccO7Czg8R19ETCcyxSUu3lKeWQaBcYHJoOlTFLU9NRW41TTmMazMM7TuH+XtJJqJvXdZDVIySHCJXwpjqWtERBLGG/TmfpqARxetGZukIzz0gfY+Gqm8bHvYC159wDkRId3J1pi46ehg4goVv882Gqa5f36lFWaPcWyNjU4tDgcnXW1PBY3RXhBbj0ESc4/wGANtqGMHZIESDOHLOjYfqJ0Yr79EcDoIWzowLRKyr8VCu/uah7l1wcjPJ2oOackQ1eXSQNGbTMq7T5Fu4mqi9LYHW3aLKMHXdgmeV+LEqwTzRjYsdaOd/fDIMWiUENjKX1VT2S0kft/rSmdqLgGp9QoTObeagM5xp1UkYy+r+vnX29NKrU0k//+GzfSOgBkvRxfzGOPl2BuWCID1yH1/90g2a298mrprbleYanVrZ3swfr+9hQNLOu45G+a6PylAwNSNqmJGAfZc8Kwvl8LA1W0L1dDf/wscd3uF62AjugPT+HX6cQGQH8bXUs6LQiMzEKiaKuKhUHz8r3Q6nDxAo7JQaAumDMJl9LWExi/p3bLuTbP7RMIeAQ9LmtgCcC581wz1zZzJdnOrZeCro0zAHaKYIv2LTq
 Wylq/L0d
 dXJRULsN6C/D1Rv2b6bjnGLHcbmA21XOqu+uIA+GBC6+vT6jw9Tf2YjCfIFYraN1jRHI236pNhsOR3GsBfti3lQl3r8vX5K/4dCbn/W7rg3TFGylVYF1NUjZoDkmgQ/pqM1S8HuIFOVOxevnKsHGY94JzovHmL1+t9whNwzakImGJL9TvkNl68liAEyfz1xPPtdJJaVJKf4m7yd/+J/JSWDS+aDbZcyjH3pGPhlEnq2yJ2KSoTFi/KiUzYbgrc0wMVu0BLo1VePWrN1PtgQpH6Op7EsZRX/MZGK8xYdTUnVI5HgfDYpAJCRb1CfowXmnO6FNSex5XY6cYUStVcrixiasvW8QpEpehT5fXSglKgZ90yiG0FK6PbBukst6jIRCre6I8anqdN099dEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 05:00:04PM +0100, Pedro Falcato wrote:
> On Fri, May 08, 2026 at 11:00:51PM +0800, Vernon Yang wrote:
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > Hi all,
> >
> > Background
> > ==========
> >
> > As is well known, a system can simultaneously run multiple different
> > scenarios. However, THP is not beneficial in every scenario — it is only
> > most suitable for memory-intensive applications that are not sensitive
> > to tail latency. For example, Redis, which is sensitive to tail latency,
> > is not suitable for THP. But in practice, due to Redis issues, the
> > entire THP functionality is often turned off, preventing other scenarios
> > from benefiting from it.
> >
> > There are also some embedded scenarios (e.g. Android) that directly use
> > 2MB THP, where the granularity is too large. Therefore, we introduced
> > mTHP in v6.8, which supports multiple-size THP. In practice, however, we
> > still globally fix a single mTHP size and are unable to automatically
> > select different mTHP sizes based on different scenarios.
> >
> > After testing, it was found that
> >
> > - When the system has a lot of free memory, it is normal for Redis to
> >   use mTHP. performance degradation in Redis only occurs when the system
> >   is under high memory pressure.
> > - Additionally, when a large number of small-memory processes use mTHP,
> >   memory waste is prone to occur, and performance degradation may also
> >   happen during fast memory allocation/release.
> >
> > Previously, "Cgroup-based THP control"[1] was proposed, but it had the
> > following issues.
> >
> > - It breaks the cgroup hierarchy property.
> > - Add new THP knobs, making sysadmin's job more complex
> >
> > Previously, "mm, bpf: BPF-MM, BPF-THP"[2] was proposed, but it had the
> > following issues.
> >
> > - It didn't address the issue on the per-process mode.
> > - For global mode, the prctl(PR_SET_THP_DISABLE) has already achieved
> >   the same objective, there is no need to add two mechanisms for the
> >   same purpose.
> > - Attaching st_ops to mm_struct, the same issues that cgroup-bpf once
> >   faced are likely to arise again, e.g. lifetime of cgroup vs bpf, dying
> >   cgroups, wq deadlock, etc. It is recommended to use cgroup-bpf for
> >   implementation.
> > - Unclear ABI stability guarantees.
> > - The test cases are too simplistic, lacking eBPF cases similar to real
> >   workloads such as sched_ext.
> >
> > If I miss some thing, please let me know. Thanks!
> >
> <snip>
> > kernbench results
> > ~~~~~~~~~~~~~~~~~
> >
> > When cgroup memory.high=max, no memory pressure, seems only noise level
> > changes, mthp_ext no regression.
> >
> >                             always                 never               always+mthp_ext
> > Amean     user-32    19702.39 (   0.00%)    18428.90 *   6.46%*    19706.73 (  -0.02%)
> > Amean     syst-32     1159.55 (   0.00%)     2252.43 * -94.25%*     1177.48 *  -1.55%*
> > Amean     elsp-32      703.28 (   0.00%)      699.10 *   0.59%*      703.99 *  -0.10%*
> > BAmean-95 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> > BAmean-95 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> > BAmean-95 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
> > BAmean-99 user-32    19701.79 (   0.00%)    18425.01 (   6.48%)    19704.78 (  -0.02%)
> > BAmean-99 syst-32     1159.43 (   0.00%)     2251.86 ( -94.22%)     1177.03 (  -1.52%)
> > BAmean-99 elsp-32      703.24 (   0.00%)      698.99 (   0.61%)      703.88 (  -0.09%)
> >
> > When cgroup memory.high=2G, high memory pressure, mthp_ext improved by 26%.
> >
> >                             always                 never               always+mthp_ext
> > Amean     user-32    20250.65 (   0.00%)    18368.91 *   9.29%*    18681.27 *   7.75%*
> > Amean     syst-32    12778.56 (   0.00%)     9636.99 *  24.58%*     9392.65 *  26.50%*
> > Amean     elsp-32     1377.55 (   0.00%)     1026.10 *  25.51%*     1019.40 *  26.00%*
> > BAmean-95 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> > BAmean-95 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> > BAmean-95 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
> > BAmean-99 user-32    20233.75 (   0.00%)    18353.57 (   9.29%)    18678.01 (   7.69%)
> > BAmean-99 syst-32    12543.21 (   0.00%)     9612.28 (  23.37%)     9386.83 (  25.16%)
> > BAmean-99 elsp-32     1367.82 (   0.00%)     1023.75 (  25.15%)     1018.17 (  25.56%)
> >
> > TODO
> > ====
> >
> > - mthp_ext handles different "enum tva_type" values. For example, for
> >   small-memory processes, only 4KB is used in TVA_PAGEFAULT, while
> >   TVA_KHUGEPAGED/TVA_FORCED_COLLAPSE continues to collapse all mthp
> >   size. Under high memory pressure, only 4KB is used for
> >   TVA_PAGEFAULT/TVA_KHUGEPAGED, while TVA_FORCED_COLLAPSE continues to
> >   collapse all mthp size.
> > - selftest
> >
> > If there are additional scenarios, please let me know as well, so I can
> > conduct further prototype verification tests to make mTHP more
> > transparent and further clear/stabilize the BPF-THP ABI.
>
> How is it more transparent if you're essentially adding mTHP
> micro-programmability from the user's side? This series makes it
> _less_ transparent.
>
> If you actually want to make it more transparent, then I would suggest
> improving the heuristics such that (m)THP doesn't churn through memory
> on high memory pressure. Or such that it doesn't feel extremely compelled
> to place the largest THP it can based on vibes.

I agree but I also don't really want to see anything like that until mTHP is
actually stabilised and the code base is less appalling :)

We've deferred paying down technical debt far too long.

>
> --
> Pedro

Thanks, Lorenzo

