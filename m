Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC25DC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D73B56B01F1; Tue,  1 Sep 2026 09:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4ACD6B01FB; Tue,  1 Sep 2026 09:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43386B01F1; Tue,  1 Sep 2026 09:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9963D6B01F1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:59:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 396E8A3696
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:59:17 +0000 (UTC)
X-FDA: 85165350354.23.C339DC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 658A920009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:59:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ug+tFPfl;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271155;
	b=EEyZB4ZBuBVQa1O0QlmziqAAAr120pvC5M7Wk+6zP0F3xbOrF6BeGlXkOvoe+ad0i90zjA
	uoOwO8k02Gx4MMjgfeDI5Yn/Phi2JhnzNm4PN9tnG2o+mjI8ooLi9MxMo4M2BkSIB+gan5
	T1aNyzxEIdH9csIVdjQ9KTc+f/AJkV8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ug+tFPfl;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4NZGL9sW0yTZysi364rSyA0YFBhdTM0YG9uCeDwPSE=;
	b=lNYUt1rZa8P9mNJCR829qmv3XrMWSyhoeBCQnQiTsQd562heRUPC8nxjIvBN1s8mzlASCq
	xRuuift/67RgmRwP0ShzIdK3zz4TT/Votlpqme+jQRAxab2tRLGEho3mLb8Hs56gUKyKto
	uuqFf39/OnGW0GcXGfVYVg1wFLOuq4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D77D42D90;
	Tue,  1 Sep 2026 13:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B001F000E9;
	Tue,  1 Sep 2026 13:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271154;
	bh=e4NZGL9sW0yTZysi364rSyA0YFBhdTM0YG9uCeDwPSE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ug+tFPfl+VDaefaVU/4BHgnPy4Ce554caP+BlVg3VmC2CafOtgwHuapsFUIbT00AM
	 JhBz78XPBoE1K7hRx8/zC063NUrEq5FGMqx6wpPftXQthG2CT9G0g3URZMrE4U0TIY
	 e3zCkZDksY2EmW26k9Gyy6Z5pr54TGS3qGDEduTJMHYJF/pL4zzJX8h82ZWL7H2SYd
	 zj0S2+Rm1ob2cjq2uV3T3jXfn+GY2AORNNkiA/y9hy2O4Bu7U0lfSAYSM8FapRpaHM
	 BKqjJ4dChKTHB63GV2bJjWfzK31GlWjYVs3pb8wPL2DheszV97Ty3+skGtidZzaHYM
	 J5jlsijPojrWw==
Message-ID: <47aa459f-27d5-4b2f-9eb9-36ebca63d890@kernel.org>
Date: Tue, 1 Sep 2026 15:59:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again
Content-Language: en-US
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Harry Yoo <harry@kernel.org>, Clark Williams <clrkwllms@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Peter Zijlstra <peterz@infradead.org>, Alexei Starovoitov <ast@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 syzbot+acf142088e0182172e58@syzkaller.appspotmail.com,
 ThangNN99 <ngocthang2710.1999@gmail.com>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
 <20260901073339.uyKHXWCX@linutronix.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260901073339.uyKHXWCX@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: o3h1qsu6ehoe6jcsodoe3fxqxky7zt1p
X-Rspamd-Queue-Id: 658A920009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788271155-243163
X-HE-Meta: U2FsdGVkX18i+TJ2Tg1ZeKnqyba2TQ9XcO6Guv5G3mxDWoJRkkzGijKBX7WINDeVm4d2CXva4YqERf5oIErZSiOAthkXEL0sNnOylb8G1NLpelyPb0BNKSyjhjWN7PBBW26GuB/soW4b7ZczD55VVIHY0V70zTUa1sPQ5Csqj9jKMj+U44EifB1SKyYQ2Q85V2CmZ97YzNn+K0Nh1cch4ILrCoq43u+/iH5xn3bqz9moyMa59GjDYkdON/EjAyMOQdZzvj9GTwS6DU0eTBsNhpbDlgbkTf/kyFrwoYMoL9Iwnqji/ljYOXu1KTbUzUMM1/ExIUSoD4BPAfjEU45qnSY17/ACeZxvNzfRMJxj83G8Qe+N8Rhipe8h5x8b1TAKFGLaBjhP0V7fqQc24T3w8PFLnuAtQvR3ggQ96PsmzkMXzCHX+X5/QQuqQgZpIgQEDwEC2IA2+OovCQy7gw6pcgNQNaYDBiiRUtA+JrfGDPIA4/zj5rYC9K1oONtlk+ETfhPHuT2UHTgWpYAeMq8JUZw0fnD2AuBeuXTS3qWPraGgoOdAoM3414OnFTeq4eISVIhSKtMzIcVF3wnlT2pWCV7iFGDhpp/5uLk51/vgdb01Ad0+TVy25wr1HzHNEp1DYTlW8ji8C5ZhgwfJXNqV1hlT453vTmsl+wNB6CzEYqQeVdgeR91bgVzoDDX1XgATBtlyc24p986KWpnIiANj9+OXy+v+zTDM/B739w82U8R+LMJK9IwavBdvz2BXt37A6+XHAcEckLgdlJHiucx+n3NmivaLJxfUTsRDU8a6Z6M+YM8XrbjBqDS8zutumT9IGkZMUTGMdhikFNlT2sIC1u/J/7PZuHRb+DvVtiUJY+//5VQbOsrgtc07lsxT5faa1X1MzHNmyPuAvQj3A660/cwiSK/k/VjDCQbhVt60A2OIeW9wlw3zzNdJgobP0EFLbqQdd+9SDyl21V8ZQFT
 +d2Jib6P
 vcDskQslDxbxu5CoHzzDHZQQVndnBdUlFuQGUJxhnVr5SJvLB4PRPdCQKJgzoMXHNWYsF9WG72FDKxIbH1JRHV5BVYW0McsC/oFZJfP7ouJ/gF5PhdQC4ETbw36MraVBk7Ahvu4pwFRNBv6J9ETakqgLm7vwkAd0HEtCAlLNaZBxljses52K/m1oqQ4H3QHvmSG90oj/1Budzoj5C66jy+0d7RwElZwzWaTvfyhz+9OJaliw2Es6AV6mynCtaa3EHzFlsavmvM/AUUY94Iwm1yUv0Gv6uZX+IeHZ85njBZO0XnBro3HVcgEC0UIkCvY93JqNV2LFdr4Hycdca6XqEyZncbD367V0hUzGl0/n452G9UCa+b5ksQwV9sLnDEQq+YZJnmF3UdQnIxWpE3oLsG3ludXw/FzVKxGL1vwNGUtB8o7mBjM5VQmx9uHp7/DYsK6IuTAYSy5qx89Vto/nRCvnIwX5U2KEO9waqVUarjSM0gJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 09:33, Sebastian Andrzej Siewior wrote:
> On 2026-08-31 18:02:38 [+0200], Vlastimil Babka (SUSE) wrote:
>> This partially reverts commit 2a8bb29ec9b2 ("mm/slab: allow
>> kfree_rcu_sheaf() on PREEMPT_RT"). It was based on an assumption that
>> local_trylock() is safe on PREEMPT_RT from any context.
> …
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
>> ---
>> Incidentally I have posted a RFC [1] that leads to replacing that
>> kfree_rcu() from set_cpus_allowed_force() but now after back from
>> vacation I need to check the feedback and based on this bug report I can
>> already see it makes the same bad assumption that trylock is fine.
> 
> free_to_pcs() has still this trylock.
> 
> What I am not so sure how good is that kfree_rcu_nolock() may allocate
> memory for the sheaf if there is none around.

Per sashiko review it's actually bad too under the pi_lock, because
GFP_NOWAIT means __GFP_KSWAPD_RECLAIM which can mean wakeup_kswapd() and
thus also need scheduler locks. And it's not a PREEMPT_RT-only issue...

> It could have a pool of X
> and if it runs out, it runs out and waits until the clean up process
> feeds the used sheafs back. There is fallback and the run out is not the
> usual case.

I'd rather not invent new pools, since there's fallback and the sheaf+barn
is already a pool. Could be enough to make sure the allocation attempt is
safe, i.e. use only __GFP_NOWARN.

> I do remember RCU tried the same thing but then it got to the case where
> HEAD had to be supplied or it had to be preemptible so could wait for
> grace period and free it. I just don't remember if it had a pool pages
> to fill pointers to or allocated pages if it run out. And I am too lazy
> to look atm.

Yeah.

> Sebastian


