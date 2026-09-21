Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91EB2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7306C6B00C5; Mon, 21 Sep 2026 06:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708626B00C9; Mon, 21 Sep 2026 06:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E3D6B00D1; Mon, 21 Sep 2026 06:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32A9B6B00C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:22:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07400A1D5C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:22:12 +0000 (UTC)
X-FDA: 85237379304.01.90C62F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 36EF6180003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:22:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iva+R/Zu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iva+R/Zu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789986130;
	b=CEhNS9eB4MW/OIfLx3W0USOv0PBMX4X+kz9mX+K8b/yIh12fyvb6vVvQxcjVRVdBMZQvuj
	pZjRpXwhUmCJeUuPZ3RK8MrSPkus7TX5l80bmMgmLmN9tJzYv829xUS+UEgh5Fc/HV0SH+
	W1ILXc5sD6rE62v/rljkrU+pwEsTbNk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789986130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWcnRSmN81n+TtIjFirFOAPiB0KPdF4SskaKnrNBemU=;
	b=q9egmZcLyJbZ7VtwMTyhYFwTo2YFyvpzRQyulcH3r8FTtpnwmOp7YoFS3DjgI4rQqLZHtu
	uG4mCASMrBId66Y7QKmag1rI3AMgQ32svW/J5+Ff+ZQBYCebelYm+KjgqbfaNJIZwanL6M
	GNxAD7MlwruWlMStEfNWDOLcFnK4g8g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BEB642A46;
	Mon, 21 Sep 2026 10:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7AB1F00893;
	Mon, 21 Sep 2026 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789986129;
	bh=LWcnRSmN81n+TtIjFirFOAPiB0KPdF4SskaKnrNBemU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iva+R/ZuCZyU82gLI0nCN8tz9gUnpWYVgMWLdSU4nhRi3x92j+Y+gTyAKpLdj3WOb
	 gkcSQKfgLkV6Rg7AL4zeWhvck5bGRMuADD12WGF1m5lJnr4mnSd6QeMKg9wVCbSqnu
	 sHYC4p3D+Wigx8tG8PWSZ7txGTjeJQP7TQ0kNe/p1NXPKPfpfVECpASqlzxqnlbyFI
	 i1arl/yhuLMLVC7iKUZKs3t+HiLY6nI/M7SacKTo3Lm3xHtioBKUG0GhuaPF5RpvIp
	 yqUIdJWmtkKsbAl5dpESapafjJwL7Pme6s5YQqUv9uVxltTMgNa7ewiXRc0l7gtMwr
	 z5euTjUeXnlbw==
Message-ID: <c947601e-3081-49bf-b4b3-8710fdd262d1@kernel.org>
Date: Mon, 21 Sep 2026 12:22:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Usama Arif <usama.arif@linux.dev>, Lance Yang <lance.yang@linux.dev>
Cc: joannelkoong@gmail.com, akpm@linux-foundation.org, ljs@kernel.org,
 hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org,
 kas@kernel.org
References: <20260921100852.2236761-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260921100852.2236761-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 36EF6180003
X-Stat-Signature: sdddfgbis3chsg6aewn347iggzr3qrzt
X-Rspamd-Server: rspam01
X-HE-Tag: 1789986130-590842
X-HE-Meta: U2FsdGVkX1/fG0wSqcO4vX/Qzt5SGe2Cbd4PiY4OvQgyT2eiMvICWcfxPsec4TdVoKatRoGujSYWg6ZakKHhPvSyv0lq4PQuBtOP7Sce1+i6TW7/kbn4fRUsLknKtkUN3GWGr/O3rbA1MpKeobtM0ruJKg3BHns7mj+K+C35HuQK9oHhsqtgiulo0/Lbn0DLXu42neENQsqFcVJf03Nts1FXhEDzYI+/NkozFiQkAnyE0Laa0RVcr4NaNfSWYm29OhgwV0hwizIZqVssQZfYFoS2pIH6uWZNxBV5ctaRlZ3yLcIsqQpis9n/Zys/cfF0nnBq+IVmUpBOSHMVfQg8YrJ8ogSwvxYGtYog+phkBRW7b4YwLXIwwHFInvc9XMQ+hO1i907Fg1YDQOFkRfqz7JXwM8Hzy+Moqr/LJsJ+7FAYZM0Dbgil3ulzijhLu4LjWBhG4SbbyEWeVmHLxRMkN58DztmdjTgDBtmv8oWwfyIpR+Cp0cTmdiCbqaOmIvv+CU5ykaeBZVrXvDcsFiHGHs8nE+MPqWg8/5zo2rHguo8X0VucpyKd/Ir8DOfxiS+yYGs7+qkW6pyzJ30OM2HaVXNMF80MwgezG75NJ7spvaJJCUwfxAGo0BsfN7Ypvz62Tc3OEw+4gFKc4dQapnba0WMWQf5nhEp0m7esj3Ql1X95ao4M4qb/HJ0tFdNjqXAsvXCWt+M8YquUy2ZM5cN2yswhUiRD/t/SSQtj9Wj3YjWbW+2l35i96Cjg0iSlvWx8/7hlLFQ5qXvFGWDGLjoQ5aMAPWrTHLJd7KslT5zvrCq3WJ8elnmKv9GdxAwmyEseLRiGc5xOapz1CYFOjwHKN4UdmrAwfa62MAcSQFHER00MmAr7LaFpyjlF9XeFs4K9prTD+KRlBjzz/erButUjHkLD9ysn5pweN0qmwqvCMBJV4tJfxra6c16WnVcxJUfLFhPNGyK27iPXViAwoa9
 l/7eViV0
 z+p9G5rZAkyqq66j8aTq3IXw1G8bvz3ACLgyxjCnr2xgqB7dGxh5jzJzI9/4YPHIGis8FuueA3IizmEAg7jEjiDIUvq3DHEtX9krE5i+Lod8qzqG+nduLKgbxYh7qx99I6KbiZr2D1FDXPrJKD2w4XPx59/uv1+GEYKsI8t/+qotCw9rGZr3tM8Uw8oej71RsSH4VJ3EOQDOlk1UZ3S1OnOBfaRt2JcVivWVFx8eUEIWYukBgMYC0s2FP+xpDQ/RUAtKECwvIS0GBTEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Kiryl, would your rework allow all values for mTHP collapse or would
> it stil only allow HPAGE_PMD_NR = 1 and 0?
> 
>> Would a per-order value make more sense here?
>>
> 
> I feel like per-order might be too many knobs? What about a percentage
> that might apply to all mTHP orders?

We discussed all that in the past, and concluded that we will have to support
the existing toggle. I played with using a percentage, but having two toggles
possibly mean the same thing (and some values not being possible) turned ugly.

So the conclusion for me was: no new toggles.

> 
>> An unset value could preserve the current behavior, while an explicit
>> value could control both mTHP collapse and underused splitting. That
> 
> Ah are you proposing that mTHP collapse can then take all values from 
> 0 to mTHP number of pages?
> I think one of the inital version of Nicos patches for mTHP collpase
> allowed that (hopefully I am not misremembering). Nico, what was the
> reason for only allowing 0 and max?

The creep problem was discussed plenty of times. That's when we decided to start
with 0 and max, and only add support for scaling later, once we actually know
which use cases would need them.  Without support for deferred shrinker, there
wasn't really the need to support other values.

Some of it can be had in:

commit 5a9c05d86683db5449b7fefd278c461cffb55234
Author: Nico Pache <nico.pache@linux.dev>
Date:   Fri Jun 5 10:14:11 2026 -0600

    mm/khugepaged: generalize __collapse_huge_page_* for mTHP support

    generalize the order of the __collapse_huge_page_* and collapse_max_*
    functions to support future mTHP collapse.

    The current mechanism for determining collapse with the
    khugepaged_max_ptes_none value is not designed with mTHP in mind.  This
    raises a key design issue: if we support user defined max_pte_none values
    (even those scaled by order), a collapse of a lower order can introduces
    an feedback loop, or "creep", when max_ptes_none is set to a value greater
    than HPAGE_PMD_NR / 2.  [1]

    With this configuration, a successful collapse to order N will populate
    enough pages to satisfy the collapse condition on order N+1 on the next
    scan.  This leads to unnecessary work and memory churn.

    To fix this issue introduce a helper function that will limit mTHP
    collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
    This effectively supports two modes: [2]

    - max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
      that maps the shared zeropage. Consequently, no memory bloat.
    - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
      available mTHP order.

    This removes the possibility of "creep", and a warning will be emitted if
    any non-supported max_ptes_none value is configured with mTHP enabled.
    Any intermediate value will default mTHP collapse to max_ptes_none=0.

    mTHP collapse will not honor the khugepaged_max_ptes_shared or
    khugepaged_max_ptes_swap parameters, and will fail if it encounters a
    shared or swapped entry.


Tracing back the discussion on that patch should give you all the details.


-- 
Cheers,

David

