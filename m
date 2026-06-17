Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FC7CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E20E6B0099; Wed, 17 Jun 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66CA76B009D; Wed, 17 Jun 2026 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533556B00A0; Wed, 17 Jun 2026 01:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16BE06B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:38:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7028DC08E9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:38:27 +0000 (UTC)
X-FDA: 84888299454.20.851FD24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF4D2C0002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kRlZI/S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BziNteM5YVB6ogs4Q9Gd0LtktaFtRuTFTklo5cSHf2o=;
	b=EnUFnfuhb0r3HhdphinVLTB+G8aP1BXf6RzQmSJElLaRIgY9+lqYGPmBIRoTOGKbGzwBGz
	e2hqy5pZW89Y+iZwuUM1HXblf2xErpORQ8IJgiZ40cinuuhrNHit300EXGlaOB3M3VloTB
	0PPNOf3W+EqC3oLhwrz9LDYbTSArlKU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kRlZI/S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781674705;
	b=aX2Qy2EgTiKi2S3ezJm0vUIqUVlRpt49p+t8Ow+s0aVvKF/JN2LJe9LYD1zDI97BN0KFeR
	2v8kmo3x3/rrZ2ItyR0/Es90YCbbESCsBh2lJxVHmp1K4eAfwJal6kINtRPb1t9zmQ5CFj
	d6HZeSrokDrGBnT9iGyOUc8p9FWXBrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3963D600B0;
	Wed, 17 Jun 2026 05:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056D31F00A3A;
	Wed, 17 Jun 2026 05:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781674704;
	bh=BziNteM5YVB6ogs4Q9Gd0LtktaFtRuTFTklo5cSHf2o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kRlZI/S/SFJ7eCHH30KOn3xKjAraKHzfGJ0VFaXesYzWx9f8/ZZX9aOtIC5gDNtsV
	 EzVzvviG/lHxv5MJLbJt1K3PRAtgBkG746r+esGVf+fmcWatIYPqja3wSwGOyRSrxz
	 EVx7KpbWmC5lCfbOFcd2nqfUxm2RvtQQf7p5B5UG5eL6+jFeCdW4DvUQxPp6JK6bSB
	 89m2xNrHdH6k/eM9OBvI8GimRTvGRKkyArQHOinpuvLSiLCOMEYllllqcxJrs3fzW1
	 d2MvE+tcdh10NAQc1gKhSlxxp4QK7ZU0tPLjbkDcDRxR0iTiVuEVi9nT/wvr3MM62e
	 Nr4//4MN5llxA==
Message-ID: <9d8ca1ed-bc53-417f-944b-d78eecd1e6a5@kernel.org>
Date: Wed, 17 Jun 2026 07:38:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 6/9] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
To: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
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
 Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-6-70a54f3775bb@kernel.org>
 <f3a56a5a-f10b-46dc-bc99-28449ade1661@kernel.org>
 <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <40591888-3a87-433e-b3d2-cda1cab543be@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF4D2C0002
X-Stat-Signature: ys5bksaxnhjhfsbebo8d8gkn73nf9isw
X-Rspam-User: 
X-HE-Tag: 1781674705-60859
X-HE-Meta: U2FsdGVkX1+q+zB6kQQM8LGafKUaILvG+DyRbbuUMOsvscHkfnsBVy/JPj/ZU4LjlwwgJbThjepAYDfcRtIMYyt5Hx2KRhJdKmI4/TEOLmOYw67w5PXiSi2GjgqadAECzrzntr6imXg/aWaDQk1irlCeSuGfH/6hBJorPVSuf9bZyyYvw/ONynGM9Y1Wcu4lgXns7NofNBcIxmVvVU/6RLIDpi5chhr+BdHu3wO3mJWaN7Zjft6755CD1E+7vtymwHwioR/k4d76AlXskEPAOJQVzB9SVC8WM2Pd+s0Qe56zCvz4RRlZR9PimndI/CTwzTygnL4tFBwqp8B+ZLbclRLATTQ0PRQ8yeHcnF8NLhq342Jy6cqawDvlxZmbOW3i0IMu/K832Nhw7sbm++om+GeUj8dzAXm/QysWKn+1U9PGEYd7N/SkeRqRUcU4IT/JuUcHOEyg9dem/okMBS8rhgoD9Me5sy8H6KSb5StRoXGTV4SzEuHs1oUPU76kYsioNYu7Ds0bPthWWunAuci0nKANNPO3xbTeYi6iBgRY9VtguKWSZoaJZxMCgWwrtd+2/KPyw01wMy0PPwwQGMLFlKGBeL4gh6vOwBhcIQE6lju5a8qjcixtTSGI+E9mpBgHUUOb3scM5yRAVkJBcdHlTTZad+oWnKd32iFFg91CF7dftmNNG1AFYhKz0kzJV42K+T6spowGnOIPH4vanuMdnwcyAckRqd4Wbh+FF5XgtiJEGi0GyMo2e/tSnGn183iKoGxKsGerPR1vXz+7BMdhNXm2X4YXJylLRJaJmveeDhXq38XWS9QTzlkYsLfScTumF+tTdUMqckDk3dWUt/jsBEbzsVoaUW5Pvywvpm6JTuM+4itWk19RGX7lsW3/cCGtJHXhynwddLn954eu7AXcwkNLJffo0Nz4I1Zy2GeKyXMRPmEdpU/Y070YaEJi+80KF08v9/7l1sFTQjdS89F
 PQ4t4QBo
 P/QvaQYrHLVPBHaYykWLAl7Bvs5evY8CXmUMCy3w65HY4tG4780oEIy7z8nC55gLi+8dtosB+VBRy6O1WFMZ1UBiALiYDGY7B2NipfqxaJfwa2UXqkeIa9XIAWjZQ8gP24ATBxXATXvXyrr4dGhF2Q1svIhOA5xxaxOXHYwgv7/fyc1sFkqoVGVjB+zVN2W28V+lHDHo3ou5ssgnuhMWHyiFRI6tNm4Q5N5zq6Mv6/+X4rPxHw1DVhTsdjPsZXb5xmvLgcXSF4l2nSMXon5vroq1RS3Btor6IqdKHYAQ/TwWRUif7IB+4IHXUqDaBmWUYRsyugi1ZSiLw6Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 07:14, Harry Yoo wrote:
> 
> 
> On 6/17/26 2:24 AM, Vlastimil Babka (SUSE) wrote:
>> On 6/15/26 13:06, Harry Yoo (Oracle) wrote:
>>> As suggested by Vlastimil Babka, kfree_rcu_sheaf() can be used
>>> on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
>>> This is because local_trylock and spinlock_t are safe to use with
>>> trylock variant as long as the kernel does not spin and the context is
>>> not NMI and not hardirq.
>>>
>>> Now that __kfree_rcu_sheaf() knows how to handle allow_spin = false,
>>> relax the limitation and try the sheaves path on PREEMPT_RT as well.
>>>
>>> Keep the lockdep map on non RT kernels. However, do not use the lockdep
>>> map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
>>>
>>> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org
>>> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>> 
>> LGTM, but maybe unnecessary pessimistic wrt call_rcu() on PREEMPT_RT?
>> I thought (in the Link: above) we'd only need to downgrade allow_spin to
>> false on PREEMPT_RT for handling sheaves movement from/to barn and
>> alloc_empty_sheaf(), but call_rcu() would be safe from kfree_rcu() even on
>> RT?
> 
> Indeed. Good point, thanks!
> 
> Hmm, but I'm not sure that it's worth the complexity given that
> PREEMPT_RT tries very hard to avoid disabling IRQs...
> 
>> Or is the irqs_disabled() condition rare enough so we don't care?
> 
> Given that most users don't call kfree_rcu() under raw spinlock or
> IRQs-disabled section on PREEMPT_RT, I think it's okay to keep it as is
> (it's not making things worse, at least) and wait for call_rcu_nolock()?

Sounds good.

> On a side note, I don't have much idea on what needs to call kfree_rcu()
> under a raw spinlock, other than set_cpus_allowed_force(), which should
> really be using kfree_nolock() instead of kfree_rcu() once we support
> kmalloc() -> kfree_nolock():

Looks like the case. Well if the fallback path of kfree_nolock() that is
irq_work_queue() is indeed safe here.

>> 	/*
>> 	 * Because this is called with p->pi_lock held, it is not possible
>> 	 * to use kfree() here (when PREEMPT_RT=y), therefore punt to using
>> 	 * kfree_rcu().
>> 	 */
>> 	kfree_rcu((union cpumask_rcuhead *)ac.user_mask, rcu);
> 
> Any thoughts, RCU/RT folks?
> 


