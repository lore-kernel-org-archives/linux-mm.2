Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C2D9C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 21:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A84D6B009E; Sun,  5 Jul 2026 17:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F2A6B00A0; Sun,  5 Jul 2026 17:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BCD56B00B3; Sun,  5 Jul 2026 17:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 401BF6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:01:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C8836A01DC
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:01:36 +0000 (UTC)
X-FDA: 84955944192.12.CF4CF00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0C83A1C000F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gaEbpmQB;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285295;
	b=oC/PsWfBlr8G05P55NFz9lBGNK3rXn3lfBgi79EnBuz/UTRaAd8ygjuBCGHypukko2bSod
	RQ0NlGxEFtGh9m9J756SZZUOyAcrYRpsHfoyj+3ZNZCpH4jY6QhZsDKkacZF6REN0r/YZJ
	gwY3Uk2aozYNNGw41mjTkjDpbjx7p7M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gaEbpmQB;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfKe0kCK3HJQeJ+5QEWh3IBAQ7s7PrrKQ5wszb4ExVs=;
	b=b+oc3cUc5xV6ObGhNuA8fkPgcxvMg81Ap8+wRTLcEIx+ieyLuR30qO26D1VvySHG/TN2kX
	TP8cIX3FSuNbBegHGEONMu8BFfDPivOTkOSHqpIQ0d4D79jZt84bO8HwDpcSn9Zvcvp6DV
	j7Ht/APvZR39nVKuZMRpEKcdyKDgcV8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36309437E7;
	Sun,  5 Jul 2026 21:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DDD1F000E9;
	Sun,  5 Jul 2026 21:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783285294;
	bh=BfKe0kCK3HJQeJ+5QEWh3IBAQ7s7PrrKQ5wszb4ExVs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gaEbpmQBnJyIhLLQBSPXy7hGKEQJ0EcKljhlQsHrcFmRLuH6JXUBUirqyggrp0H/n
	 SDMcpr7ofWrghjqkrYSjWGCnjNvSfKsDOrlsLvy5a9sH6+Kgdgapx4Q1glsgai1UW6
	 TK6l3/6QSFncABTi/rcejYOvG4Vz9cr4bmfHBu5U=
Date: Sun, 5 Jul 2026 14:01:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Yosry Ahmed <yosry@kernel.org>, Nhat Pham
 <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>
Subject: Re: [PATCH v2] mm: memcg: reset zswap settings in css_reset
Message-Id: <20260705140133.e0534a0be91346860fd9056f@linux-foundation.org>
In-Reply-To: <20260702024827.353185-1-jiayuan.chen@linux.dev>
References: <20260702024827.353185-1-jiayuan.chen@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C83A1C000F
X-Rspam-User: 
X-Stat-Signature: kqw57tymgxigjsz19w8xo59xyqpzjqu6
X-Rspamd-Server: rspam03
X-HE-Tag: 1783285294-637262
X-HE-Meta: U2FsdGVkX1/SCdJi7joUQSfuR+0popG8zip+TekbiV0pAD0pbWgxyzJTkG8ecsc4a9vZqCkycXvcvTpaUZ/KW5ixFOaXgR4pObsWjIvitDTqAFXVX18UNvHsSoWrT5VCXS16VK0+j0koTnJ8l6DJa62TpLmwBnLmKe6JXeJDQo7Rnavxf48bEO7CzZBp+rnJ62iuTIapbs8Qb+Lt/XaTOPm3ihEMR+ilfxDbYP8vrJkUGPQtkSjzLz6nokc2uDNeYdPiVxm4bCR9uULAdmfODLYqS+K7N/HTvuWKSTzw6vgkVTLX7zXJHast6NklinoUcNED6vHSjwYGcZMU0EhvkiBd5fn1TqdNMHQGr3dBkEm6rgQ9aS/Z1AYDoxeuGeNNYig2dJUPyaopdfvh1diPO+cDyRGjjFTKgKJaleaULRE/U76Qehf/XXxA7DW65HrXCQrKfqOOUTn97DYI/Y2Qv8jOO3lwYxt5xiYpZoMfRzF2scLELXdSy8IE1pKK+Kh5ZOjnNiXRXRSaH9+dqIAuLrugQFHOo+i5FN7mLLAAItEJifJtwvrGpp/QEVB7RU5D6ffc9tnMUGFku1Cl5uqv4F/k3z04UmL1kz2KMeIhNKTETYpSUIjDZehHPF61cKW5Eh7hAB12qsRj05VYnTGgmCaAvGj0Jp0nqM/k4bLgpllLGHrlDjC6eC2X1IAtKqRACFqzviy8OWyQhoKOTEdpdzLUpdroV8nXPybxu/Zw4xiVVLsRQMtLk6SEpm8MJaetlwXeakfShtQNP8p1StGMPzM16UbiIrXJ/zjWnVt8bnxFXx+cYE0hk/6Dk+zd5M5mWhyptVB3eeTWyUsM2cqS5q/iMURHL/VreYD9WUY6JdcZG02fMa2zkxte5i0k+omFCMVsmo14n5zxPhqRHB7JYFVxws0nQ3qiePHYiAcsY9cwQVSvG7QWK2XRzPDs3Ib2Kc4abYe1SLEjwmMTsNP
 6VWNMVk5
 DEE52WmkK5TmnQpjXQ8ZXGfrAlbEZcLxDTTZwL7hxoCZNLeFDWwVAH80cn5rso3VuCX83O8TFrqZGuixjokU0vF8LprOX+/f6yn5ADYSxYvF41dVA6WhxhjICErBb7QbvTuz0hfrsoZ7nN65uOexH4OaGK1BkM2jq2pUwCm7Cwj+8pLIVMpjB/a9UzUG5XuHgA1xwM0eWGQpJFkAfC3XVA7YcBZVKKUySupdZWh/b3UU8tYb36wakQpYcqh3kwbfCxPHoZuueLIy166n82od9yb2M+G7mWPTTebAqu8ECP1j9g1UZMmHT4K0TkyZqItRZzIi0DVwMy3kk9f5IxjIOi/aEBz3ymiKMtEPCZRxA8GrO3iXlUJGKlkPf13KlDZN/fLGpCgHFk0D92EMPMAKy6TL2J20hpCyNgCQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 10:48:25 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> mem_cgroup_css_reset() is called when the memory controller is disabled
> on a cgroup but the memcg cannot be destroyed because it is pinned by a
> subsystem dependency -- for example, the io controller declares
> .depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
> and the css is hidden rather than killed.
> 
> The purpose of css_reset is to revert the memcg to its vanilla state so
> that no policies are applied and the css can be safely made visible again
> later.  Currently, all page counters (memory.max, swap.max, kmem.max,
> tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
> reset to their defaults, but zswap_max and zswap_writeback are not.
> 
> These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
> zswap_writeback inherited from parent) but were missing from css_reset.
> As a result, stale zswap policies remain in effect after css_reset: the
> zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
> zswap_max limit, and the writeback path continues to honor the old
> zswap_writeback setting, even though the memory controller has been
> "disabled" on this cgroup.
> 
> Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
> their defaults in css_alloc.
> 
> Test:
> 	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control
> 
> 	mkdir /sys/fs/cgroup/test
> 	mkdir /sys/fs/cgroup/test/child
> 
> 	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
> 	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max
> 
> 	# child/memory.swap.max and child/memory.zswam.max disappear
> 	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> 
> 	# re-enable memory control
> 	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> 
> 	# before this patch
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    8192
> 
> 	# after this patch, same as memory.swap.max
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    max

Thanks.

You convinced me, so I'll queue this for testing.  

The problem is old and doesn't sound serious, so I'll target 7.3-rc1,
no cc:stable.  If people disagree, please speak up.

AI review suggest that memcg->oom_group is missing similar treatment:
	https://sashiko.dev/#/patchset/20260702024827.353185-1-jiayuan.chen@linux.dev


