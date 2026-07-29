Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044F0C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11EAA6B00A3; Wed, 29 Jul 2026 10:07:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DEC36B00A5; Wed, 29 Jul 2026 10:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36B96B00A7; Wed, 29 Jul 2026 10:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFCB26B00A3
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:07:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA79B1C0F47
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:21:35 +0000 (UTC)
X-FDA: 85041271350.06.54018FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 13D7240009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:21:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kV2KAngc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785316894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ck/H1VPUEgL0UJhdG6kDLw/19qHzYtBNITX6iLnKog=;
	b=Bqm+LM8olhHSk13PgABdvpFGZ12Oi+DwzwJe6EeyeV30+qkpdlMFiZOiqKNTghzfuaxFjp
	Fe89kRw5rlFMQBKga7NaJNRPf1PErbVNbAdS5N1gurJVqeV/7mCwelrFmwKLbhqOvyFpmv
	p/dofAuWLBJiw3De3CGZY2xLharKL+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785316894;
	b=nOsnB+DMxHaQiTsnrEye8goLrKp4WYdn076xflSTD3+TX6fuvrEPbB6+p3aG62V7IHAwNd
	oRWex5Ip28PXHXPsWwSvcl2e0Phix+pNqYGCZ9rpm/hpMLmUwwYXV9mJYmkql02NC/nuf1
	a833WbX2fivonqtrZpZMY3+djVM8lSo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kV2KAngc;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E9694189E;
	Wed, 29 Jul 2026 09:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790081F000E9;
	Wed, 29 Jul 2026 09:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785316893;
	bh=1ck/H1VPUEgL0UJhdG6kDLw/19qHzYtBNITX6iLnKog=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kV2KAngcdMNxcJho/xhAEZXwMDIP49qRzAfHR4lrnJTE9dXajTsyQ+/sZ9D/G1XKS
	 H7Lcc5KvPOJuEoaJmFEJ95v3GW5s/4jqUKu+eL+wV15oxWQsBouINUehSHN5tF6M95
	 +VCbFq8eAOJS09HOB0ITH9R6dPsOu5XGwMx04zAlJZsdxWaG0n4nbL2C+GR7WSbkBX
	 41a/357wULvkt59XWNlPdF2czG22aRKLlKK6Mjir1Q7lBsJnTc/iCgzaZK+7W1rg31
	 VlZxYFjOj0KdkQ/kte/wCJfjAngUQlu/WLr8v/hxqsqwLBMfi9uev0RtpLgLjqx3dQ
	 98lkFNsgWbLrg==
Message-ID: <b640f7c8-4f1c-4be5-8471-4835d76d0f71@kernel.org>
Date: Wed, 29 Jul 2026 11:21:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, paulmck@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13D7240009
X-Stat-Signature: ek7uzz4cimg4moob8be1ueg3aywdef3c
X-HE-Tag: 1785316893-52230
X-HE-Meta: U2FsdGVkX1+LhHj6rCQgiylzc5tI105j039Sb2IPnDkEIK6SzsqlcAkIc+Ar/KBGvuOqf6WtiG2RRPuo2o2/zov3XCAZAGnP2jpv3ko3V09Ra5MtNPxVvU9f1y4TplvApRhLkZeAswB8CKhX0cPiMoY5tks7apGfISyEDbUHiWw6+JIinxePH6oDFg6jKkln1+uqElTz4fXOnJhcvIrCi7BmhGSgmWqvgnIdPy7l9Px03grTq8P43MAZleAQ9Zy7zjy0AELyxtCWW+fQg71iWyCmt6Av2KUBfyRqi3lWC4Ff9Ph6mJ1tEp644N8i97d3DmIOCbRxNiYoxmKPx3JvD4ubmhDcqVRa55r3L+ln/7WuV6p4NJv/zF+r/UyUZNYfaeLKUiW8CeLsfbugg/Bmt6pnAm7pfKvDjPZe70GdM8vTHGUOpzcDdnBXbxbgG7GjpVfVE6+sGHam7dM1hgPTGY1o6+sDJXDYoXaQrLI5q7JM4T5+rC8v5yUw0xg71vgYXoFAPFfT5hFf4639LKbv/nghRMR6IdRX5zjp5s8VROJFj4tGg0womQlC/nS0sg/NUkpZ7LZY7xqqXeq/u3Bq915S11TF3t+UJIHeF9PdY5xHbcJ2kPkQ8JwYbXCAuQ9+cOXWU8mtBhS71ctDYDBrhPMwlKdXK6OrxNm42aM1qXrQ+MmXth9Lg1YvKo9UcxEe2ApOfA2LnE92NVcWJyAh6kpCOZfdZ7cKWaQN5vUG6R09NYcy2wzfgbiqHB2PUzvEaWAMlC6LGkMqeVEzcZhjfPyA4zd92yj5zpWOk9NcYLe0PxTLgiJMH5xyUW16SUVKrgUJdH4Ydy2IN7KTLifTOLDfFeVI18WK1fNMXj/Vx2NvsZlNCuUw5CRWjgpAtF06yOlGY2LPSI/Fakk2N+5VwPl5xT+iqYhM3MIi0gSy71R0SGWcj/AxKU2Ca2vKuIM7W+vDB2POYuh5qjlXr7w
 3r8QYkbx
 VBoEklYJZQkrCB/S/A//EQWXj03ZjrMbEpgO/R6ZioW2Z+LpxFgyO6vBRN0r+vQ3xtES5zhWge8z1t1qfH/lwCPHDJKiq2gt9J15V/7D7DEZ0tkuOU2NVHCf0KMCjizSeayENRexlta3JbP/kzVW6pXNgaHE1Cx8oC4OnHuppK4xrIMdG4NDU7Rudu46ZWVPpjH1KzUwNc/ZOesqET3QwmbPlBKjV04UCvuaYd9XWGPe0L+YrEOAms3hQ3P54+LvH1ARxEFeEFS+e1af0yFPzjl0eTREeZTiuRDrYhPBVHpQ/WcpS1bkA602/NBUxHl/dxSXH9T2QfOUry45xNpAF5RAN38+9h0NRxuaB5aL93qa9vybOBntoyBeEXNAaQpMOjb8Sk9CvsuraivDMnFa7GY3UnNRSc7/X+jQ2TfkRyBXh4dJdc35aAbjkAgLN/YiJFCPcNA2lqsWZ1MI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 15:50, Breno Leitao wrote:
> migrate_pages_batch() unmaps each folio before moving it, and every
> unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
> tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
> the CPU busy for a long time.
> 
> The loop already calls cond_resched(), but on PREEMPTION kernels that is
> a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.
> 
> A long batch therefore never reports a quiescent state, and the
> migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
> Tasks-RCU grace period for minutes, which is common at Meta fleet:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
>   Call Trace:
>    tdp_mmu_zap_leafs
>    tdp_mmu_next_root
>    gfn_to_pfn_cache_invalidate_start
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    try_to_migrate_one
>    try_to_migrate
>    migrate_pages_batch
>    migrate_pages
>    compact_zone
>    compact_node
>    kcompactd
>    kthread
> 
> Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
> when cond_resched() does nothing.
> 
> PS: This has also been discussed at [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

