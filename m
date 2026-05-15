Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC7A9CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F746B0005; Fri, 15 May 2026 05:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368996B0088; Fri, 15 May 2026 05:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218F26B008C; Fri, 15 May 2026 05:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 064026B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 833E11C1A8A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:43:06 +0000 (UTC)
X-FDA: 84769165572.30.9237237
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id B270C40005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:43:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BvY4a28N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3puoGaggKCO0YPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3puoGaggKCO0YPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeUXgpk8WD8ZE041HMwOG7MAoJe4YLyYuNMxmvTB7rA=;
	b=ZXl6K5816PgS46lWVa+JcX54vP9t4UQW4WIttFNV9ZZkfGMW0f+Pw4sEuxNHgQBgzWNjol
	UwicPdbdI+D7nChZbhdEH9lYsVO41TXbdbDlGd8SFsbOwkUYv8E95a5ZfbWu/8kVXsSy7h
	08VN+Fd8Us74hiLOFioGGw4kGS9YS8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838184; a=rsa-sha256;
	cv=none;
	b=8rLRG23eisaYPyXnzPUOvacYIBzRaEzK4qDUhh7UOoKLZM+F6L4YrVKnwSVol1x1u977jf
	yFmQM8/YFqPdwyOzY2JNxHelw+J49O+ojd/a/81SQDaliTxMCXD2gtktiZLXoptIDxi0sU
	HL+p+cSF6WSwCE0ei+E/5BQoXc3vbdk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BvY4a28N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3puoGaggKCO0YPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3puoGaggKCO0YPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d7a5b9678so5831731f8f.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 02:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778838183; x=1779442983; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JeUXgpk8WD8ZE041HMwOG7MAoJe4YLyYuNMxmvTB7rA=;
        b=BvY4a28NVSVOcSgcDRmmr64/vXFsmg8c1+Gm07oVXrh5dK4+G4khCRXG9sYSUNLuFO
         FbmRGq384qZ9+AdcibBSuRuecyKxK1aNo01E21TOOp2qQaK1mvVWgs5HJXSB8zSTQnzv
         ynUEX8wO0TANb0MeCU56b54KVp3PDAal3S5pGWBEF3DfhE72W9wvKxyJlvAvzwqQaALX
         GgzaUvaLaCCkuVA1KfYDzhJQpmQefi0GRn0VSoUui6Fj82a5A95IfVIi92PLYmweZxkN
         DWZRtGQma52SbkPPLahJPG7TsghsB0by5t5JG0ZbVqZ8KsM/znP0KKw+pxdKkgz6OKX3
         taOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778838183; x=1779442983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JeUXgpk8WD8ZE041HMwOG7MAoJe4YLyYuNMxmvTB7rA=;
        b=dAO8dsMUrth/X8rI/VthBNIlh4OvjKeNqvEfNfKFXvme25UuzHm+NoaTAxS+XY4Fnx
         hsTKql0eJIDtUHAs71pV5X6XtvXGHURUphgd6R5hNWaHfkTcgjOijOEg8DeAeZVdPfev
         AmtED3tAV2A4Pg6BJokNLtWgcAAZmfOgPmTV6T3dU4o8ZRYtv69jpVY/v91Xzr6FpThH
         reJblIQ5BSzgx2gEr12VezcqjyKdNrcTPFw63PmhNPj/xhX4jz36yXJehmOIY96zHZbV
         5EOEmchJrfXyOI+kdzCWMsJcVMJiJu4xrVpLrZfsESWABFf8+jjVcl7O83IK8CdZFVSQ
         hZVQ==
X-Forwarded-Encrypted: i=1; AFNElJ+YKOwyYNqpSh5xDYwHCmxSgfmnAbNtg1SYy+zuqZQc2BVeIZgLllv9brqeRt7fsAji6CK/TRyWxQ==@kvack.org
X-Gm-Message-State: AOJu0Yxsz0cfJjsJfrdZ/CTuOmHiBtoaAgTlmcWcWcEEvuD+F4rvDX2U
	eX2QnyNGilKjJLxikf5GQt7ObSzN5aMPboYNCYkxOcAj26v3975P0CLM/G69zpWZj/6LFTUYqvx
	nnZK8+cXtUdB7oA==
X-Received: from wrbev6.prod.google.com ([2002:a05:6000:23c6:b0:45d:b6fd:7d20])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5c84:0:b0:44a:fe14:3738 with SMTP id ffacd0b85a97d-45e5c5be136mr3921543f8f.10.1778838182630;
 Fri, 15 May 2026 02:43:02 -0700 (PDT)
Date: Fri, 15 May 2026 09:43:02 +0000
In-Reply-To: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
X-Mailer: aerc 0.21.0
Message-ID: <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
From: Brendan Jackman <jackmanb@google.com>
To: Gregory Price <gourry@gourry.net>, <linux-mm@kvack.org>, <jackmanb@google.com>
Cc: <kernel-team@meta.com>, <vishal.l.verma@intel.com>, <ira.weiny@intel.com>, 
	<dan.j.williams@intel.com>, <longman@redhat.com>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, 
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, 
	<osalvador@suse.de>, <ziy@nvidia.com>, <matthew.brost@intel.com>, 
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>, 
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, 
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>, 
	<yury.norov@gmail.com>, <linux@rasmusvillemoes.dk>, <mhiramat@kernel.org>, 
	<mathieu.desnoyers@efficios.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<mkoutny@suse.com>, <sj@kernel.org>, <baolin.wang@linux.alibaba.com>, 
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>, 
	<baohua@kernel.org>, <lance.yang@linux.dev>, <muchun.song@linux.dev>, 
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <jannh@google.com>, 
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <pfalcato@suse.de>, 
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <riel@surriel.com>, 
	<harry.yoo@oracle.com>, <cl@gentwo.org>, <roman.gushchin@linux.dev>, 
	<chrisl@kernel.org>, <kasong@tencent.com>, <shikemeng@huaweicloud.com>, 
	<nphamcs@gmail.com>, <bhe@redhat.com>, <zhengqi.arch@bytedance.com>, 
	<terry.bowman@amd.com>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B270C40005
X-Stat-Signature: px4ak4kbt54duh4t91q4abzgskyj5g1k
X-Rspam-User: 
X-HE-Tag: 1778838184-761759
X-HE-Meta: U2FsdGVkX19nXHmUw4kPt5pTfRMNwFf9nOgVOEhSN4t09XKM17wDnBZ3XD+iqPbqfnet+8AzMwD33FvzkAG3g5Lpf5pAOXXNP1KVONnIRrHA9pUxA0R30zhTruuxAkVXf0ziOA3A/WUGR+6bbljuZB6IHNXOuVm+PHTdUeYDYBXIBu8OWSLmGgvXaTpW82NO+2fTk/m8fUfIz8cDn6XzdnQeroTeyeocRvT5Hq0tFw3Iie62mcsP9yz65iW6bo/o2kioWZmXpZBQoS/ncm8aMmG+J5HsEPXw1BJRADX1e+9XuIQQC75Z2qLC74/3TTy5dIrj61aHhUSH8t7SrhTDbHERETdPWK1M7YaN8ESe1q1q7nBFLgyggsJLHX4vQG/RJOHz7SWNaXeARb/NDNbhmMkk/LMOy/xL/48x8PHGXFDXVJLqOrY/Q84RUeLjMfxcr2pVwusKZtNbfR70bEBf+UoeOyfgbkx8dUBoKOb4Xy7uFTKvCBXeJ4obBqgWK7eoeHu/Eo+TTHXCMBpUhegW2Sd17MzTSzHEz57oNEIeRRtzxgl1YuGo1XdWMzI8gCpvTHobbZagN2/+gEgzg3Z1+H8+eWCEdSUvlNhG+Tu+RbTybK140bTnam5I+FzaiF5mX66DrXl8Q/Ytg3iO41kBTwmtJhqe6jARYI8IlymmjnSuo5DY5VLrMGbgSwLpx+uQk62zCZ6ghfo1OKrPg7EuNSdH7MjeCjA2dd/UHu4rJLPqQcWBwWYiFlb8SHhkZ9/Q76PA8jog9s3dbflrEGpzdviSBgpNrn7sj7jEZTPymNeUnxJQ0lzf+xyFxiNP6I3jjFT5Azu19HytsYEnrbvzxLZ8UYxN4fs083VK+AvaRP0+FLu2U1JP6AWhpjp+ySKGAe3LZ2cishhdsau5oO639pxgVE0NwosEayfj4j4ZhCASrQp5ZIUHb7jYdZVM0TrcYkArUGxfm2xFBxtScrS
 0UGHWRJz
 pzpWvMH3Mp5hFiYQ2Y4h55c87fyYICUpSmZ1NcTAcOLW3NQvrG7kt8c8hVECXoFa9wCATf3gEw9S8+DrC8oOUJdVA+w0RAReRZp5PtnfO7oLorQYM9xBn9CC2YDpEVyVgmbqOBmekAfOOVWVGaY+lfJJDTc2wYUks74HO+dCg35Q5W1riolQ4aTyEgDdIMlMVvlH5qCT0Ay9xmaIu8ZDB9Z/FPvMRy6wcD0dx/O/lndqrpIllzcfNiM6d0RljOwdZmHK1d+FsxtWoxLlcHyw78CukIme29Fd8AjPp439NXIHeDvQlEWZNbInPu62L9+c15W5HG9YfEfc7Mo0sF1/ZslmdlcQ6TFcv2l7oFCQ8YLHgFf0quLC0chR7N1XJRDiHdPIUHf8G1E2gJUwNAhTRXc6LySdvlSxSq1PC8elBfej9GeyRdCDnXosq+ccxKSpuOB5Adboy03mJYhONwC7A0qDdPbfHnCd+D0hhhMAhe2mUDL88MOe9QGipm2vBnLr4kNjLRHxgB+H5+sXD4aaI03D4OLC6y99kg8VHy68KI2jofqpro2Z7aRTGKELOwC9MslOdRX/Hg2N2TmXP4SlTvDbvZVagTuCIpeL58++bavBeqIzN5IJuqHdUhfX2HULGlPTU/9fINr3U9bDutZRapLmzQB9XypOwu4ni8Fkyrp+4CjCIR4lX5XuNtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu May 14, 2026 at 5:42 PM UTC, Gregory Price wrote:
...
> Maybe we could modify alloc_flags to be a struct, and export that
> without being tied to down to a 32/64-bit flag field - and mark certain
> sets of alloc flags verboten (internally controlled / controlled by GFP
> flags, and will either be ignored or cause a BUG()).
>
> Then we could get something like:
>
>     struct alloc_flags {
>         /* 
> 	 * internal only: will be ignored, cleared, or cause BUG() if used,
> 	 * or should be applied via the appropriate __GFP flag.
> 	 */
>         uint64_t wmark_min : 1;
>         uint64_t wmark_low : 1;
>         uint64_t wmark_high : 1;
> 	... etc ...
> 	/* 
> 	 * external context flags
> 	 * allows explicit access to certain resources
> 	 */
> 	uint64_t cma          : 1; /* allows access to CMA regions */
> 	uint64_t unmapped     : 1; /* return pages in unmapped state */
> 	uint64_t managed_node : 1; /* allows access to managed node */
> 	... etc ...
>     };
>
>     ___alloc_frozen_pages_noprof(..., struct alloc_context *ac) {
>         ac->flags.wmark_low = 1;
> 	...
> 	prepare_alloc_pages(..., ac);
> 	ac->flags.nofrag = alloc_flags_nofragment(...)
>
> 	/* First allocation attempt */
>         page = get_page_from_freelist(alloc_gfp, order, &ac);
> 	...
>     }
>
>     __alloc_frozen_pages_noprof(...) {
>         struct alloc_context ac = {};
>
> 	___alloc_frozen_pages_noprof(..., ac);
>     }
>
>     __alloc_frozen_pages_context_noprof(..., struct alloc_flags *aflags) {
>         struct alloc_context ac = {};
> 	
>         /* Snapshot to prevent external changes */
> 	ac.flags = aflags ? *aflags : 0;
>
>         sanitize_alloc_flags(&ac.flags); /* BUG() on insanity */
>         ___alloc_frozen_pages_noprof(..., ac);
>     }

Yeah, I have had a similar thought before. In fact, I wonder if we could
have a pointer in there that effectively allows you to replace
NODE_DATA? I think that would be a more general mechanism to achieve
that `managed_node` thing?

My original motive for that was: if we could get the allocator to stop
[unconditionally] mutating global variables it would make it easier to
test.

My feeling from poking around in the code is that setting this up is
actually quite a big job in page_alloc.c. But, I think it could be done
in a way that leaves the code better instead of worse.

There might be some annoying stuff like "turning these things that are
currently function arguments into struct fields effectively causes a
register spill and this code is hot enough for that to matter"? But that
seems like a bridge to cross if we come to it, not something to
premature-optimise over. (Do register spills matter in 2026 anyway?
I think registers and the stack are kinda virtual?)

(Sorry this is such a vague thumbs up without really contributing
anything but I'm just giving what I've got :D)

