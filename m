Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60F30C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E02B6B00B1; Wed,  2 Sep 2026 06:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690DB6B00B2; Wed,  2 Sep 2026 06:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7946B00B3; Wed,  2 Sep 2026 06:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5F06B00B1
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:24:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A132A16017C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:24:37 +0000 (UTC)
X-FDA: 85168438194.25.171C16A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0699A180006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:24:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOvew3l8;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788344676;
	b=Tk5Z9NEKe8dtUC4sIGzDL62xSIobcR/zXB/2FPfChsfMWGSPTZXBp06qkdSh4Wesp/Rzis
	SXqDLhN4/QzrEX+UNwQQBDuq3MhWRT7XY/OalUcnFc3FD93Re1wGUIZlP3+yRWRBEcMmWx
	+FZsJ0YAUkREKtxgwxp4vV6WLV+Dcfg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EOvew3l8;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788344676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NaQwdMaMWyBaW+1JHeOi/GljyUWwMv+cdyTRLLUox2E=;
	b=cWVr7hQQhvCvghaOq7K4mpFAQZCf9K41EQZvyJKuXLE/XWDfMNHrFb7gvmFCT/09EF7va2
	BFYdO4NPBCGEVHLBRWa+fHi0l8/kTaCPjvq1l+yPLbuNAc/G9k2XwCGktNMl2O6XzABeTd
	U0yG4QyGaNgwme9y2e5ZNclqbALr9lE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7431060213;
	Wed,  2 Sep 2026 10:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A9E1F000E9;
	Wed,  2 Sep 2026 10:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788344675;
	bh=NaQwdMaMWyBaW+1JHeOi/GljyUWwMv+cdyTRLLUox2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EOvew3l83e06p6RB76xlMujpso/lVLUdS2hThNW4uCyyf6i7UFiit3bgubPkygPHv
	 KPqzA3EDTjtV4rtdbGEcjnfYsMm5DAQYgJpXI1EYEoD3C6NWuhbZTs6WgVA/QABcTp
	 wTPijWfibcwm3MTbrLwzFiJKEqg4Hm11nH5lxr1ZKt4JBafdB0BEshVxv0CKtlfKSo
	 BJe8xZQH7aO7RZahvxSTk/ozNCsbNVMT34Ih1adzBGId7GzH0HLYj9372wV8tbfcDD
	 Sf7DFcw0BJhB6VkjNsh7clAoTm9Gp5buJhpP7Cj3Y5svOrMPVQSL2BqvecbEOAi4hI
	 pjhLLko5zWpng==
Date: Wed, 2 Sep 2026 11:24:32 +0100
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com, ThangNN99 <ngocthang2710.1999@gmail.com>, puranjay@kernel.org
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Message-ID: <apfwshahN_C6jBSn@nixos>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
 <20260901073339.uyKHXWCX@linutronix.de>
 <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0699A180006
X-Stat-Signature: 8i39d3ox61aeakx7nfy57wstfz9q9ie6
X-HE-Tag: 1788344675-835412
X-HE-Meta: U2FsdGVkX1/K8aP+/VeJuH8wwU4EUmComR0+M3d0K5skNrgp75etO85FVd0Wpcs6SwOxUA4QE5Zs2dB3ZM9DLwJabVzlWTeTZlx9UhF5F9t1KP7S/zsPN5HrfBU+9NDA4lCdBDgEcu+VUH3R9/FIOOWmYFAqfOQmGySKakTlzvMqlTHcSOoDvx238xtvLFdgo6Zgxl9lMswv29XCWsIaItu22o7bzURjy14htjSulwXVeQHXK+x4Aj1dLj3UmBQN4SCZLquN/iaZOI19clZHdx9pwOYhB4hruRpLME5X79bhGMKBcGPtjKJMVrDjDlfUrLQ3+TCVrD7qRcX4Ued6HaTsGyVmMYZfg77IMcUvq9AlRBppf/kBov3EUySRntG8zh75t18E8yUZ+LLs0eQzwRpgIqY2Yf6ts6TN5WoaRA/yAXRUABT2C8koSB2S23hJfO3QPvvWSWLRhQZxNJCOk4+cruuSSym24I5qkaizrVGa0okzPXAIFqKx26Synsum/WExU/evnpC90Sir6YDi7zbT+r+yafPeBHFGT4+iG+/PPrytIs5ZOsln2HgRxC9FRIEPKymLtyCAF4wG/j+vDUr78rHrCl6CcD5t36Cznbm6NSCoLOeTenw4yjRwyrqKhAOZ+DJ4IpCHgPFLMP2RHs6Hf00P9OiqzxlucJOL9SxxYNXzc3gSnDhsZDvJxMjLKTB82lJPxSHjJw2ScyaH1h26hba4q2Ku4gnlDJn5hBobmNIy59pBY870Q9n+NHizWPozdE0qj2Mjgk7gIoiJ38ju2YmTGfkhW2qKtg4/fMQBCflbVoTjjNFPXijvEN7qvhYmo+0ZE+FkVL1jLJX6iibi02EumLXtDvOBSJwfhjv6Q3ZtHJKdJxnMXjqEi3RyDRxnIzRzjlQCdnJc06apTTYyjn4x8M6uv99oqeW2DIAA7HnBfyF1tib5UkzEzJAnNc4BtqmYB12jq+a0eXA
 p8pWUlSG
 hC7/3bOyjeX7cwSwtfz5br4HTGVcMYfJ4dQaJLxHPJ7Mm5JiAW6XZ0za7PPLJ9Yw9lB73JQ4WgZ81/zvZNnzyQRsQOCHhjRUgEP/3Ti5ljlzQpDn1CV6wV20s8nvIYYyXQrApbUo/aSLF+VTc23JTAi4WEvTYOk+s1V6fcg4XWkXxHzi/bzy7V5Mlk2w9XSV6m8XosajHccM4qNRaTzPYnAOvbVfRKmesBjnzaL0qTd/EgOX3wjF7BW+tcWqQzPIiFKJeQ5el9fcKVMgLp6R4Z8VNJllzQEz3TtFQsrNXBUNr8lhKMYvHyA4D01UtIUZ8QlWCjp0XNxPSSv9RTF3Vto8Hp9pJIcZ7etIzPDxT4yc+KZx3dBOI2ogJOEFo/6Zk62trLYSO0W8e5L91sXI8jV52C1p4bJzvyjyd3m8IKNopNAj9g1PY2cdpAQMX7Dm+Y0G9STU8vtbjaUDiLxmFqQXu1Ba2bVjtv3gO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026 at 03:59:09PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/1/26 09:33, Sebastian Andrzej Siewior wrote:
> > On 2026-08-31 18:02:38 [+0200], Vlastimil Babka (SUSE) wrote:
> >> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
> >> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
> >> local_trylock() is safe on PREEMPT_RT from any context.
> > …
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > 
> >> ---
> >> Incidentally I have posted a RFC [1] that leads to replacing that
> >> kfree_rcu() from set_cpus_allowed_force() but now after back from
> >> vacation I need to check the feedback and based on this bug report I can
> >> already see it makes the same bad assumption that trylock is fine.
> > 
> > free_to_pcs() has still this trylock.
> > 
> > What I am not so sure how good is that kfree_rcu_nolock() may allocate
> > memory for the sheaf if there is none around.

At least it doesn't wake up kswapd... oh wait, but it does use trylock.
But that's not just kfree_rcu_nolock()'s problem?

_nolock() helpers can be called at any context, even under pi_lock
(at least in theory). re: we should fix can_spin_trylock() and use it
IMHO?

> Per sashiko review it's actually bad too under the pi_lock, because
> GFP_NOWAIT means __GFP_KSWAPD_RECLAIM which can mean wakeup_kswapd() and
> thus also need scheduler locks. And it's not a PREEMPT_RT-only issue...

Right. That's a pre-existing issue that has been around for a while...
I tried to reproduce it locally a while ago but it was quite tough.

> > It could have a pool of X
> > and if it runs out, it runs out and waits until the clean up process
> > feeds the used sheafs back. There is fallback and the run out is not the
> > usual case.
> 
> I'd rather not invent new pools, since there's fallback and the sheaf+barn
> is already a pool.

Agreed.

> Could be enough to make sure the allocation attempt is
> safe, i.e. use only __GFP_NOWARN.

in __kfree_rcu_sheaf(), yeah.

-- 
Cheers,
Harry / Hyeonggon

