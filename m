Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1651C10F3DE2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 13:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CACF6B008C; Sat, 28 Mar 2026 09:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A8D6B0095; Sat, 28 Mar 2026 09:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7EB6B0096; Sat, 28 Mar 2026 09:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EADF6B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:43:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A4FCE01CF
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:42:59 +0000 (UTC)
X-FDA: 84595587678.04.763C35D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DBEE44000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 13:42:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu56AoyU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774705377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBgAxo8MAdTuoPZYMoe6//g+eUK1iGFgJsFh+kFcDSE=;
	b=YzCjtdiDFq0lFkJIpb7O2Wi2bWm8BeHCdcr5P0bUnb5VaN4umC3CxkVaiEtiZrFtpP0s0E
	3LBBkWcKtsAKd8yIuLQKtxpf/i1vsh0JawtbvmoZRJJGYM+W3jsd5ww8wzxy1Q9BsH3DaS
	2q3mDBiFDCV0NjvkyMI4Ezw/FyUPh4c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qu56AoyU;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774705377; a=rsa-sha256;
	cv=none;
	b=uNJ0PghP1w5wPlablePnAM8QbdZQWQZaNR10iJc9ywseT4je/x+IQHo6aVS/NOpVVDNk5s
	YFF40zvGtEhl7eAlkYCZzZiLwLMk/nBIBsiFfGHqelJt4WmoF4c9n5hbVq5sAZUy7EJI89
	pheeX4Jr4JnHY5S7VHjTCHAIncwY8P4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6596B60018;
	Sat, 28 Mar 2026 13:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B8FC4CEF7;
	Sat, 28 Mar 2026 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774705377;
	bh=Zo0xwBlS33TnuFJgADBysYFie+bkoCRf9H3CXGjWLKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu56AoyUrs0g1RWp65nRpAVjFwcSwH649dYJA4JKVdNyldJkRP7P9ZPOZXs1O9Yat
	 rNQ/TDkHGI1Ts9t3nW9tlhLlAFsnnzjFXsYMzXHiUfpbec+mn6PbCFjaRWwXvRZn+P
	 3XrIPDhDIbRkeGPoJgAimGrZ39in7mXCp07X/2hPr7MqT3r5kx5YC63ThL7mhoGAxp
	 /KF436VCamFOd8N8t1M7OXNZW/EAcAbJypBaxrvUqU0nUelUhPenDU8vwRwmCCRJcp
	 ggXEqXpq2BwQEJIS+DNK9bUkIBs8ZS26EjzHcgCIbeaAZ3R5kIRswiXEakZ1EM/QOb
	 7vmamGwjOjLmA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Sat, 28 Mar 2026 06:42:55 -0700
Message-ID: <20260328134255.9884-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328023020.8525-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5kpti9admjq8emin4pkmm7sz999odnxx
X-Rspamd-Queue-Id: DBEE44000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774705377-106257
X-HE-Meta: U2FsdGVkX19iNB/iD3NRjk7nLqSqQP9hl5dw5BTjO/S3PIFg2Cn8mIFVITLjC9ZvbN+lOyylcVNSMyWLseuEPyQ8jlflpHe4I1E7AdOzgvtbFHWAOIYirI7QENxpew1GClNeGG+1mvzOc6GrU/80/dL2aeqaIYG1VkaIeuGbKwIiKGsugHC79XygOW6eyHQXsr3RNm5IPOYs7OUB4o7W1doBR148DpVtwxDBNzX7xu19Cn+s0ClGC9cZkj6sESeRPcOWeF9RwKKBz6cMKi315OSUO2oh5O6x+8T+BqK6NwCC1oEPFCoLOZliGGVWMxMHuMp36IsO8DbIMoNLVMkr4b4QvpPpQ8Y0Z5gp+wUm7m/UWyP54DRBYmUAeTdziz/zA20gP4761wyWGRfWXvSBgX2y7hn+WplBaag01MsFP03nyIgWTSucvLv4VY51piVfGxr2l60/Jwpjcf4GmAQRfv3L8YcF2GpnC4IjETrdWaneB2ji+9UvoAV00oxt8CtXDaCh9uzADPs3cdaEYF6iD5aqCWzOK7lO+m1DauddH8M0bSLt3jcOryIaiV16x6XLvthSIMCQw3JXE5gLQwTFlOWZcod9ORr2GgxrrpZdiilKP9UQ5DJPc93HCVmX0iJDYZj7pQwRkeOMSTcdZJyH56fVUbV/1g5dPNm3XX6kHxOK1E4nFTEGTdfrvx87h/ux5CVlWEJBgjjoIEW26LRJcErN0Gn+O8GY9aZeXWFXDbkPx85Ql9blOKfe3QkfMkoMw9msNxYfCNm4hQkqt5gF7wlCFYmJCN/7N08H1kWVOkjaXruf+4C8Zv6SAPDRF9syXNLbTYMw5kCDEyZxXZemNHofw7Y/zUH5FFHKdqf6iagS0AaHGOiUkw7864QUCTD/2S3//OQKOo0WNGLCVDvmu+WES5TMJcxGo5C+g3gJMpKfxH1wnw7urzK00rPEERZuWczIdL6pXVulnAdeoNN
 2yHyA6YZ
 vSWwdGHHc+4Gg51k5doDCc1hcv+WE6vyMighAUWbcanSLLp/8h3z9TJF4VCm3dIVo2IQttD01dBp5uYd4357WDmpS2wO5EgLV0AQJSvk6r15cw/7EVrU+VX1X2NgkqtGGm4pHGZJZLckuz27EXG6R/jIbJjB5sVqx/2/BUP0ZDR/AdD7id9ANEL5aqiuaB7pdr6K/YoFeO7Xb6uj6rL49ZN6iH27yU/cLQ2rLi1XiZLu1e0jLEr4K8t3S2WGn5X1v8KCJy36/aFVyka1y5W7nJRIz+gSqyGmljVO8FP958xv/6vbPJNiiH/UtEC0aNyZgxbphgJJ76LoFebA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Mar 2026 19:30:20 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260328005412.7606-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit d10719045bbbd92307cf40ef0886ce0e81cb9caa
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
> 
> This commit adds validation for the damos_quota_goal->nid when calculating
> node memory cgroup usage ratios. If an invalid node ID is provided, it
> returns 0% for used memory and 100% for free memory to prevent out-of-bounds
> memory access during NODE_DATA() lookups.
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2273,6 +2273,13 @@ static unsigned long damos_get_node_memcg_used_bp(
> >  	unsigned long used_pages, numerator;
> >  	struct sysinfo i;
> >  
> > +	if (invalid_mem_node(goal->nid)) {
> > +		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> > +			return 0;
> > +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> 
> This isn't a bug, but there is a typo in the comment here. It says
> DAMOS_QUOTA_NODE_MEM_FREE_BP instead of DAMOS_QUOTA_NODE_MEMCG_FREE_BP.

Good catch, I will fix this in the next spin.

> 
> > +			return 10000;
> > +	}
> > +
> 
> [ ... ]
> 
> >  	si_meminfo_node(&i, goal->nid);
> >  	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> >  		numerator = used_pages;
> >  	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
> >  		numerator = i.totalram - used_pages;
> >  	return mult_frac(numerator, 10000, i.totalram);
> >  }
> 
> Does this code safely handle nodes with zero managed pages?
> 
> While the new invalid_mem_node() check ensures the node has N_MEMORY set, a
> node could still have zero managed pages if all its memory is reserved, or
> if a concurrent hot-remove event drops the pages to zero just before
> si_meminfo_node() runs. If i.totalram evaluates to 0, mult_frac() will
> cause a divide-by-zero kernel panic.
> 
> Can this calculation also silently overflow on 32-bit architectures?
> 
> Both used_pages and i.totalram are unsigned long. Since numerator <=
> i.totalram, mult_frac() bypasses the initial integer division and computes
> numerator * 10000 directly.

To my understanding, mult_frac() doesn't do such bypass.  Correct me if I'm
wrong.

> If the memory cgroup uses more than ~1.7GB
> (about 429,496 4KB pages), numerator * 10000 will exceed the maximum
> 32-bit unsigned long value, resulting in an incorrect ratio.

So this concern from sashiko is wrong.


Thanks,
SJ

[...]

