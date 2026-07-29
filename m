Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B69C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:14:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1906C6B009D; Wed, 29 Jul 2026 10:14:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161BB6B009E; Wed, 29 Jul 2026 10:14:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0773A6B00A0; Wed, 29 Jul 2026 10:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C695B6B009D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:14:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66A598067A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:14:15 +0000 (UTC)
X-FDA: 85042008870.15.B869172
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91D2B140009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:14:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7N+xkVI;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785334453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR+HtKGzuohI9h8IjhDmmFqiaFeXTkINifmtGZ3dgIA=;
	b=19bq3KZEofbiU4ywsoSJZKAU2Jm2a7DQzS/vx+UlCtQc+x4Gms0sO6ap9Pnn2dzzDBZOYp
	9GLWdnUHxOmkFKh/XBDIqU3qYcxgcA2t+iNnWjsDixVzxQI6p2R28tZ6fLn1G3AWKbkyIg
	IOA7wzXAMiXrugwQ1QXlKT4FqmEwnAw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M7N+xkVI;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785334453;
	b=e6dt8Fpy5NoLjILqGIlC8GfxGvu/x7+kZL157w7raKCvxpQUsbCBB+X/D/MwuAR9OULIyU
	xfT7MfHocoC+5BAvZ8VDAPpCr8643PlFXnO9XyYOX++2a2IhZwpmEKyYcuxmYRLk/e72dB
	P1NJoboHgzj442fUdrSaxYO5Z0eVw4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E29DA40457;
	Wed, 29 Jul 2026 14:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28891F00A3A;
	Wed, 29 Jul 2026 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785334452;
	bh=KR+HtKGzuohI9h8IjhDmmFqiaFeXTkINifmtGZ3dgIA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M7N+xkVIxLiKKt6LAuXsLMfV9V43y5vkIDnSQFrycZ1pEgUQCfVqi4pWqHT8MCqNl
	 Y/4yUHdVj6AUqgh/OnchFDCb4JWXw8pp3oTMa4xj9DV289QQpEEfyrb+5yPaSuEOMz
	 EOGQaUz/dzzzZD6Ei5iOVfjjZPbmNwwtwkD/pRNcyQTl2ClrqCJvMXrfBr9kgtifC9
	 1AMBdOWUR7tmolauvZdTq/kvfLi3qxi/7mCwcqud0fldUL0C+pUHO4S7I3LLIUzM42
	 gWNpIsuE6vCBjg73w+FOD3weyfA0uLPopfM10hkrUuhbohNWhaLHQ6Zb8LW8EjCYRg
	 pR3cCCp2u3rLQ==
Message-ID: <5342124c-4847-4e93-92a4-f3512928c4d1@kernel.org>
Date: Wed, 29 Jul 2026 16:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] mm/slab: introduce kfree_rcu_nolock() and improve
 slub_kunit coverage
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91D2B140009
X-Stat-Signature: 13rrtc3o7f7m41dcafdxndygciq3hoi8
X-HE-Tag: 1785334453-547797
X-HE-Meta: U2FsdGVkX1+4/WlxtbXr8PM1GzBJKnbl6GTtL3uioMLMI7VG6D3hpPYPANoptfw5XptqvGXt/2bhvFo2pEMdnxTsTqJ5aCIDAcQnltTOxBH8imNtAAcKkJxQvShPm9889QEGQqea62D6mlzhICM+OfowbZtwGy264Y+ay79JbiS46wyE2vqF0uUH6wemgBLRZxrYFvEjMHfiVAJC4qXfOPkf/62SagFop/x834+NympicMKYBMklkNWhB/uDGBnm9fNbIhZr57EAulZRZ6aPU1PqBYgcoXUKJ7LScGT1hIuJBm4MZCVPVvohoz5XjY3Xv01G29gMgcgMkGZzb7LZSGG95fDWBjCaufsuSwQmFb7hOg3s2UH8bR2oYDF0GgqqfMZ+NmTexi5WQRjstU85qvHE5lFLO0Xr7mfIsQYLCXI/L88+351OglIzMTOWckWmeNDIJHJSojBiseaW/2vF5D3SV+dVrOzwbwKc68tER0r5a8ouZFs11PDS5p8TSYssk1PPOMoxwO9Ugekx2IYyfwxeqXUM7gm7ILqoFsNHQ7CUBqWup1sor0+MMl44mWHVjCauoySvsP2dg4tRjwQSZ/ROwkSKOIVCfAlvORctcL0FGbdKlqVNnPE6RGs5IJHPZ+KngCJ6VlirsC1f2p+BpISh2T6x/p8zuPIu6age3Zm2WP4TsGz20Lpi3hTAlvuEB2GNDOvlzUxeU1/0fqg5JNtXF/XNKZZX2P+TwFcHV77yLFaeUF3/GVNRAEPqSC72BXBZ9YmrOAmkfSdXNcuFRDGLBXbfy8ggs9rlOoL91V/6wDb8xqPhq+rgBX0vUoVZF4yP4HemYl6xHYshTknH/EHOjBeE6xZofbFpdooR7bXfptlfgh4M/hoW6SS7wUbSPplmqwN6XHqdsnvXMGCmCgt4MuBIm+BcMSQn8yZbiU7KeVLU1SXlr5mhoyYnJH3yITxGVsqD6rVy190MDUy
 JCo6ZxCL
 dsWMNvNeMykeazrLNbfpwWXUcHpMkucxUxMS3kIXrbcvD8H3Ok1biff9q+B3HqP2+CNOIPwEsGbk/mEl9bhDC1QhvHFvu4CXUsJtAoKhGpUXtgmwqjl78SWKPJUR8B0r7VDfayJmxOz7ycGeAhEh/+7IFpebfBSThwJAop/2SUfy83vPiwlKURTo5WU4gyE8t+cejIye5tGMbgwH4CyHdqyJjS0k+TNqxuvDVaCiAsQ0cgJtcLJSO6WwMYuTOyVNbWFFnxQD/AkOO7qaOFAgpnHF3zwksLLj7TymJApcK1dP4s75RRo8YlBrPSugFtNzMjStMxoMdAmduxMMUI4QoFwvwtA5iTpIv+lq/nwJ0j/A0lho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 10:20, Harry Yoo (Oracle) wrote:

...

> 8:  8e69c83a1e52 ! 8:  aeaf2ab60046 slub_kunit: extend the test for kfree_rcu_nolock()
>     @@ lib/tests/slub_kunit.c: struct test_nolock_context {
>      -			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>      +			gfp_t gfp = (i & 1) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
>       
>     - 			objects[j] = kmalloc_obj(*objects[j], gfp);
>     +-			objects[j] = kmalloc(64, gfp);
>     ++			objects[j] = kmalloc_obj(*objects[j], gfp);
>       			if (!objects[j]) {
>     + 				j--;
>     + 				while (j >= 0)
>      @@ lib/tests/slub_kunit.c: static void test_kmalloc_kfree(void)
>       			}
>       		}
> 
> Link: https://lore.kernel.org/linux-mm/20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org [1]
> Link: https://lore.kernel.org/linux-mm/6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org  [2]
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Link: https://lore.kernel.org/linux-mm/872bd673-3d45-4111-8a41-31185db3ece5@kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
> Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Wonder what produced this weird block of assorted trailers? "b4 prep
--compare-to vX" never did that for me?

> ---
> Harry Yoo (Oracle) (8):
>       mm/slab, slub_kunit: register kprobe to trigger _nolock APIs
>       mm/slab: handle the !allow_spin case in kfree_rcu_sheaf()
>       mm/slab: use call_rcu() in unknown context if irqs are enabled
>       mm/slab: extend deferred free mechanism to handle rcu sheaves
>       mm/slab: allow kfree_rcu_sheaf() on PREEMPT_RT
>       mm/slab: introduce struct kvfree_rcu_head for kvfree_rcu batching
>       mm/slab: introduce kfree_rcu_nolock()
>       slub_kunit: extend the test for kfree_rcu_nolock()
> 
>  include/linux/rcupdate.h   |  32 ++++++-
>  include/linux/slab.h       |  16 +---
>  include/linux/types.h      |   8 ++
>  include/trace/events/rcu.h |   2 +-
>  lib/tests/slub_kunit.c     | 190 ++++++++++++++++++++++++++++-----------
>  mm/slab.h                  |  52 ++++++++++-
>  mm/slab_common.c           |  81 +++++++++++++----
>  mm/slub.c                  | 220 ++++++++++++++++++++++++++++-----------------
>  8 files changed, 433 insertions(+), 168 deletions(-)

Applied to slab/for-7.3/kfree_rcu_nolock and merged go slab/for-next, thanks!
Used slab/for-next-fixes as a base for a better topic branch indepdencence.

> ---
> base-commit: ffc64805cebac330b2a60b2f1f144fcc35b8ab46
> change-id: 20260615-kfree_rcu_nolock-e5502555992f
> 
> Best regards,


