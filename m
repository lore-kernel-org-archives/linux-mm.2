Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC77EA71B7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 03:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A586B0152; Sun, 19 Apr 2026 23:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDB246B0168; Sun, 19 Apr 2026 23:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF0D06B016C; Sun, 19 Apr 2026 23:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE566B0152
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 23:18:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26F178C54D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:18:56 +0000 (UTC)
X-FDA: 84677477472.07.BBFF4E4
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A51A40007
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:18:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWhamPn+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776655134; a=rsa-sha256;
	cv=none;
	b=59M+WDDldu5kcxoRKaG7tmgfcIiDUsdbEHZZXyV8Xr4WystUynfUhwE/PLjxko9Oo/IB5d
	uM2/ZKrnWx+cAuJB/JSoNkrlJaemQaLUk0RrUVaxygYBbwG9iv6bvbv4f5pTTw2mwRhsxH
	upgSfyUQwN+LBBqsQXWZDwogdUImsUg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uWhamPn+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776655134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjADKv/hfT9QH2kft8L2afVA2LLe9bemIi2UDm66F3o=;
	b=ajOVlFql7O4bIl/CfLCqZ4xFYFPw84oXnky84/JIUQAGLmun2/kITD2/9lIaxVOCuM6itp
	S1vjM/Nh60v7ID8c1bu43Kbl63CI775vLS1g+y3wPEEpg+5y2jTLCfXphSkLdrIEFZqU21
	DE1FIKlB5zPovBRP7wyItXCq6xWVy+0=
Date: Mon, 20 Apr 2026 11:18:28 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776655132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OjADKv/hfT9QH2kft8L2afVA2LLe9bemIi2UDm66F3o=;
	b=uWhamPn+I9Q66JjgeVQnqRrGU6UiLGS7qSQe5URulIBpcplC/yVybjUooCYyBDJttZjKK7
	vV+vZsXcp8kvGDIJnD7nzBApJAhN+ZXAxBoxg+mp6ctSG8AmwaTeMfnBP1xvi6lgU1/qiq
	A5i96iwz/H/hpI6Dr2/PAL3ta27xP+4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.orgg
Subject: Re: [RFC PATCH] slub: spill refill leftover objects into percpu
 sheaves
Message-ID: <ixwynz2hiu4q5jscizqxkg74z57cfzpzeoyxz3ignatnebdoba@iww4m6byj5wo>
References: <20260410112202.142597-1-hao.li@linux.dev>
 <87a4v47xk5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4v47xk5.fsf@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: xijff1otmwdt77xi81njh6gi79i3z5gm
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A51A40007
X-HE-Tag: 1776655134-807071
X-HE-Meta: U2FsdGVkX19HYrLyUPXagzqdL/mXD1Mo0PY+jH6msVueDv5RyW7hpQwwDqPc0pocVmi4hYGmqIOeE2CSTtmNM+nBCd0cKxzEMELvEhQd555HeaKo/PCKnNWLMFg5Cj/1oYhpEArj+zTKqX8b3+iYOmPKDfe3aJAejNKNXcXQvKaaiR4ntH8A7Qa9C63vR7QIhN60+eAFDnSYNxbxBRAD6i4K7SV40+jkS+E3N6s9MEyGaAnugUSY9WHiekTinqJEu1jR+UPOFG+/a4i7RJAXmavNAeRr/ROy0M/2p0i4if0Z/dElLkXmsTGzaFVe5sMXB3BsXzRjMo3arBvwF0K5l5WicwS9TTWSPI88b2hCxA+lyy8YZ5LAg7FDwbA+h+tJV/ak8L+Rd/dKNB78QJr5IdKPKjVbrtnSnoyt+ELDM/nCKBQmUsyLZkSNZmrYfk0dsvyaGs1R16+qjRKN9AO+lbwWgBUht8KAE9CX4n8PzbWMPpkY1XKtWdW+/hU3Pz4xhtP4rDHp+4LnMKrz0h4VgqiQn9rwMqqsENNgvipyxWpnZK7wS5hqMEe2MtGRJT6bnPKaOtlv2kt+qZgT145rPNhYTgG3izLfPVq9+gAkcszcM5lYAgWtR7kEifaK/A2bH9d/BTWPM5pDWQ3FV6+eQreceAJjzVrONaLbcqeTOAeIChseKOFDUjouCoftLEMQBuHd5JYmJcSND80mA7KKwmiMFyzs3huAQf42zKyGrWXOIwazX4VU0MJrsIgG5Hjeue6mS+vCTDM1wMXFQuBkRdYWJ76+sFiIRseXNYhdlP6qBlmbrd+vzsa8FX69SprgXLGxE49UaNFbmvxinnxplzWOrgilLlN8TR6CXHj38RH75tujaDELGppLfdiRCNT8yVTsOb1lJisPl5Oa0bQo8XCrTmbElALd8Za39sX+Zl8BPpqO+sQauxam+VCxeMb/SZ68UqrIohY9MOe6ZfC
 11VAWUT6
 NE4P6uT+/grbdrJbypwQ1EKGz+2G+k6kftL1kU1/xxfx4cpqM91fyPZ1ncOL5WuUSqNiYk4WnvxkDFqvbrDCG6bK2jTrJ8MzlJkl+Woq9sfF4qHwG94yl2bOq4m/PjR7fk0fwm/Qeat8LUsNxt6FJxG32KNWfucVjpdCq3SS02cBkcKMIlNsIy7K3RpBx6C0CJpv++p1BDE0knGgOUJ7N159giTYgDhBFwoXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 01:55:54PM -0700, Vinicius Costa Gomes wrote:
> I was also looking at these regressions, but I went from a different
> direction, and ended up with 3 patches:
> 
> 1. the regressions showed a lot of increase in the cache misses,
>    which gave me the idea that a cache would help (and it seemed to help)
> 
> 2. Allowing smaller refills (but potentially more frequent);
> 
> 3. A cute (but with small impact) use of prefetch();
> 
> The numbers are here (the commentary from the bot are very hit or miss,
> so don't pay too much attention to them):
> 
> https://github.com/vcgomes/linux/commit/c898c39ee8def5252942281353eda6acdd83d4ea
> 
> I am re-running the tests against a more recent tree, but if you
> want to take a look:
> 
> https://github.com/vcgomes/linux/tree/mm-sheaves-regression-timerfd
> 
> Also, if you feel it's useful, I can send a RFC.
> 

Hi Vinicius,

I tested the three patches in your GitHub repository. Under a 96-process stress
workload, mmap2 achieved about a 3% performance improvement.

For the slub stats, I observed some differences. Here are the results:

(baseline vs 3 patches)
alloc_fastpath +4.6%
alloc_slowpath +0% (and no slowpath in both test)
free_fastpath +0%
free_slowpath +189%
alloc_slab +247%
free_slab +247%
barn_get +8%
barn_put +8%
barn_get_fail +16%
barn_put_fail +0%
free_add_partial -37%
free_remove_partial +247%
sheaf_refill +3.88%

I notice one thing that seems consistent with my approach is the churn in
alloc_slab and free_slab. My impression is that this may be a common issue with
solutions designed at the per-CPU level...

-- 
Thanks,
Hao

