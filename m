Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA629D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 00:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC32C6B0006; Sun, 14 Dec 2025 19:05:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CBF6B0007; Sun, 14 Dec 2025 19:05:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14206B0008; Sun, 14 Dec 2025 19:05:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BACAC6B0006
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 19:05:03 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E1A41366B8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:05:03 +0000 (UTC)
X-FDA: 84219760086.01.E2F2C42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A7B341C0013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:05:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mfMkTefw;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765757101; a=rsa-sha256;
	cv=none;
	b=CweJmK4xBZ7FRRjM7GwplFmkDfNyfaB2Dg46hR2YWcFk20TOrTbUSJKIFnso7wrFp8ScXQ
	dijmBDtG+1ID+qzBRq/N4MQu4RA403ow53GUMvK1UfZDMyFrTUy9vaBSS2ndY5R18fire/
	km9pTPIm9peXTLaaXg4k8mdzsoNnKhY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mfMkTefw;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765757101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPBD7gEnylW5titDp4GuetNn8GQxbyEKUWA5idaQovo=;
	b=zPJvpK5t+iAods91O+id7XYD6tizxgaTHdoorUKbsbs8lbewGlR6Wr4qmNO0G4gX22Qtcb
	xyfNkXVKEIcdPlHOYhS16CPvKeZlMNlZM1kkhVT4h1hc9VOCZ/phBkrwH7nBXqBW8qbjd+
	Rza2Jo8qBpJHtfD5ZyckE4kwtTaRxOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B0FC42E41;
	Mon, 15 Dec 2025 00:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9CEC4CEF1;
	Mon, 15 Dec 2025 00:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765757100;
	bh=KQgNOzzdpK9SAl+/0XAoh/jy5YQ7JxwdekPA/O3z5uk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mfMkTefw8w/EhEcVDPm9POvgcjbxFFKJbmXZGdDIJa8T2C1kifMdrXt8xsgPbGShI
	 AQ/caI6p1YLL4QAg8q2S8LYtf+0WO+upLPz3W4lIHVME3sBhJgQepaq4UrspqHa3vC
	 eJJ2WKsOYni5oldLMeK27VJszAhZ7HjEaB6L6w1k=
Date: Sun, 14 Dec 2025 16:04:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
 <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
 <gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
 <mgorman@suse.de>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
Message-Id: <20251214160459.1c9d9cfdec4088097ff6d713@linux-foundation.org>
In-Reply-To: <20251213082911.1509735-1-tujinjiang@huawei.com>
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A7B341C0013
X-Rspamd-Server: rspam10
X-Stat-Signature: e5b11qrk9ojanzz3qanspzxh9pi5suqb
X-HE-Tag: 1765757101-364149
X-HE-Meta: U2FsdGVkX198iWdJfkc6q7d6yDBYhEf8P/rwG70thacKVA1IYoLKztO1He2yREZs+HvTmOm1OETydZbBjk77HExBeXwYgHCwYqLEcl+QqUQT6dXmpIbGrPbI50JUqgitSc8GGpzt5gP5mtZQzSPPTCl6KfruIdii5qcZIRhxpSg0oSpRZ6xZtaEF1c3l276dJr4A9PAqs8PfeUjIzmw288AXSuZP0LlzIWRTSaEeBjSeaes+ZI0lPh4kGpogvu2Ar42fg4ckwIzC8ZuJUit/HydyBuTtgqxKZK+XIBHCVRBpNo3Mrc1JsGjAQEu3b6mEnJR93fykrgagzFbKEzbYhtE2HaHtJDKcqESDZDKdWgQtoS7kPoAX3kM0QKb+cntkOFGGDCBstKT7mnH/Guwv01ab5KPSR7NMTNaDwqAEwtwBKoBYW13Iv3fmUL3VkdXBPDEeevczjuhxv+NXT4PdCakAV/bMCpNTo0wP6eGZNs1WfRmfrWErPWe4PoIic6EKDnywWo5kWnCV0UVXmC0I0PIK5dlPBftrhHf6/bFS1vMtmtHPflDNNfFc0DQ6x+YieS3VXMZc4KUXlosirfVpCag6jJYatoZDV2rkDatIvIgKKKAqZcDcxHOzBFWPjcb69P1rMi98zwloTVqlyk/1eSHU5V8BBl3kosO3d5ayk+/rCXImNpOtxSCy8r7CHMC4YiuCDrGxUviOmTCn84UpuaXtbWbKBpyt4QKJttiYvKP6uYw3BkLoRh20PMyNC0jFsjpJ0D4nr6MwKnIjczi/H7pVXuxYOOGb7xnQuYf9N819to+34CqkYlqpwrJBK1Xq2oehTEphmEXbN3RP/yJs+21ygrfHealDmTTplgOyLiTyXaF4dH1sknwO8XNhmsXoUuaL/vFz2tH1szcRxqvTb2hVwlL/w6JRQ7eF1zzKCZsTH124sWEc79JK9fH7KSyKubNjXCKyp03LT41hnIN
 KhW23J2o
 zL+IzMJKxEg60ltn8BiIABoLXPyOBvc5xHn4koCwIUX5NSjBnbUyK4Lzaqukrakz7Ex2AOeIUvOKxL8S07km1Px+gGsIkluQyfa8ja/ORkQEZPmSJtr2hsWLkgm7ymFse8q2ezffgkn4vSJARz36Nfl8JV/Qki5H3vHYzjdne4TGUWKXdBMwojRkRPg+mB8Gf/J8ylsW29g2iX2AH23jT6QgpX1IQDlqJScXFWQfLfLtj1gX+v7ZL3snWuOnfG08lMcLdiYPuVSrZ8NBRh4xFonkKXqNQF00b8J05hlLkIa/bBKXMHPwYFcZU3GRYRtIA30e4Ummk6CrRJBXaFijYS5HVNYIROqwqKMc+xd30o8vtxHhDgIUwFBi3o8KBiEJuZkpadwc8eJDWZ9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 16:29:11 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> When mempolicy is rebound due to the process moves to a different cpuset
> context, or the set of nodes allowed by current cpuset context changes,
> mpol_rebind_nodemask() remaps the nodemask according to the old and new
> cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
> to store the old nodemask allowed by cpuset.
> 
> MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
> passed nodemask and nodes allowed by new cpuset context.
> For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
> are relative to the set of node IDs allowed by the process's current
> cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
> nodemask.
> 
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND, the behaviour of rebinding should be same with default
> befaviour. However, mpol_store_user_nodemask() returns true for
> MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
> the user's passed nodemask instead of cpuset_current_mems_allowed, and
> mpol_rebind_nodemask() remaps wrongly.

Thanks.

I find the changelog hard to follow, unfortunately.  It's odd that the
problem description comes in the final paragraph!

I cheekily changed that and then fed the text into Gemini, which
I think helped. What do you think of the below?

I won't merge the patch at this time - I'll await reviewer input.


## Bug Fix: Corrected `MPOL_BIND` Rebinding with `MPOL_F_NUMA_BALANCING`

### Problem

The commit `bda420b98505` ("numa balancing: migrate on fault among
multiple bound nodes") introduced the new flag
**`MPOL_F_NUMA_BALANCING`** to enable NUMA balancing for the
**`MPOL_BIND`** memory policy.

The intended behavior was for the rebinding logic to remain the same as
the default `MPOL_BIND` behavior.  However, the function
`mpol_store_user_nodemask()` was incorrectly returning `true` for
policies containing `MPOL_F_NUMA_BALANCING`.

This led to a bug where:

1.  `mempolicy.w.cpuset_mems_allowed` stored the **user's passed
    nodemask** instead of the actual nodemask allowed by the current
    cpuset context (`cpuset_current_mems_allowed`).

2.  Consequently, **`mpol_rebind_nodemask()` performed incorrect
    remapping** when the mempolicy was rebound.

### Analysis of Correct Rebinding Logic

When a memory policy is rebound (e.g., because the process moves to a
different cpuset context, or the allowed nodes within the current
cpuset change), `mpol_rebind_nodemask()`, by default, remaps the
policy's nodemask based on the transition between the **old** and
**new** `cpuset_mems_allowed` sets.

To support this mechanism correctly, `mempolicy.w.cpuset_mems_allowed`
**must store the old nodemask allowed by the cpuset** before the
transition.

### Context for Other Flags

* **`MPOL_F_STATIC_NODES`**: This flag suppresses the node remap and
  simply intersects the user's passed nodemask with the nodes allowed
  by the new cpuset context.

* **`MPOL_F_RELATIVE_NODES`**: For this policy, the user's passed
  nodemask represents node IDs **relative** to the set of node IDs
  allowed by the process's current cpuset.  Therefore,
  `mempolicy.w.user_nodemask` is correctly used to store the user's
  original relative nodemask.

### Proposed Fix

Ensure that `mpol_store_user_nodemask()` handles
`MPOL_F_NUMA_BALANCING` correctly so that
`mempolicy.w.cpuset_mems_allowed` stores the correct cpuset-allowed
nodemask, thereby restoring the proper remapping behavior in
`mpol_rebind_nodemask()`.


