Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9EABCA6012
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 10:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628CF6B008A; Fri,  9 Oct 2026 06:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA8C6B008C; Fri,  9 Oct 2026 06:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C84C6B0092; Fri,  9 Oct 2026 06:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 210F76B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:04:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A47FF1A031B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:04:39 +0000 (UTC)
X-FDA: 85302653478.28.8159323
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id D454C40007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:04:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L3x/XJnx";
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791540277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCfrYFQWaB6ljrpcA5mB+GvPCr6ztXX1INv06kJj6BA=;
	b=ChMa8rQk+YY4yemigdAcnDwsObUkTWL6RfJ1K8RVs4msk288xQcGLZdzlY51r/CZccuwdV
	k4cRCqb2GdAo62so1ud1Qt4y/J85iG7O78pkVdyYB2HfClE0Jmd/HGfORYY1J4DO8kv9ey
	dEW2VhGc6t9Rah9UJNgUNWF9ipBmCVk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="L3x/XJnx";
	spf=pass (imf17.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791540277;
	b=VHO19tWqnzAEdKX1/vaPX7YWcnr0h7/dnfVBVz25ABt4KK2NZfIsH1Ka8srdw3lthuJP9a
	SoxEbwk5Ba27FlrwQRuEaDgagVSOLW8q+7JVvpti6wZ2iSy9iy2V1NkZ1kdgIiuJoiLbpx
	+nWLntPl50THidnvoucoSV64bS4vvpA=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48c4649b35bso5907703f8f.3
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 03:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791540276; x=1792145076; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WCfrYFQWaB6ljrpcA5mB+GvPCr6ztXX1INv06kJj6BA=;
        b=L3x/XJnxNmLzYkurDB1eyIgNgRtmqiXRVl7Z0xOaMeABpvLsRNgNZBQdgvX7NTAlaM
         sv/T4Np6SO0KaslTYhAj/iOLIMk/VN1L706ik3AoCBw61L18t+JysqJPsfXES0Ensw0C
         GtWUzdIfVX6udnAMvhDWpxD6cLsUOl9LtKGUU44d0i+Bb9NEwkr9/Z1ZoPA5uup7sfvO
         o0vRnWqLOqv2XepjABugo0MPpyzI03kG/Ccc1KHFn/s1y4c49RtOvLPXh89swUwaOgMT
         en12jSQzVVSZeSAMjlZO+dDWl/l0MMeVB146rxxMiFcJolm5PVrHw4Kxf3fca2Wtp0N/
         UUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791540276; x=1792145076;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WCfrYFQWaB6ljrpcA5mB+GvPCr6ztXX1INv06kJj6BA=;
        b=fyMMLfayN2LLVi8CnYWK0KDL6n1KyWFXe56mVLbWLOyKnSDRdfKUBhlC5hdR8a6Kou
         lhpncsJ+BYSjitZzFeQGYZjIuYA3EHLZEuPbmYbl4rfV66HxzGWfR0GYBrU3VkCUX2mN
         A/CqZ/QgQcFHtItwjwrwSoRWV31IViCSrEeFhE1H2dAUOF81QrHjoa90FkwZvYyAgfuy
         JKijHd4w1KslP2iFKrbcVXRb0e275QV8flQ7HJQCdoFZrWbp0VvTHdLbwxus/WnuaqcN
         wWoOnm5ARqqHYC+3law+QPW0ZhJ0sbCOxMoQd9G8523puBVPu/2ORFEIOCA9BQX2ADlW
         QvTg==
X-Forwarded-Encrypted: i=1; AKwUvBzJzti8ECLJd0N+WBRDWLc1LWIjeMn+f6pI6dv72fhaKucqjgoJlQqiusgKKRZwSsO7a5IlvkZzQw==@kvack.org
X-Gm-Message-State: AFuF++mBic9jwzSUB0Ub/bY+rwK0RAkkcDHLOuEDcFguOXDbRwfEMRX2
	xJZXqgTt6a5INhtdl0HKzdKQjDnFFhXGF7Gi7G7u5X9fPR7rwFVEcCj2
X-Gm-Gg: AYBFou1Ct0gLnW/AVy0mhAL/802Ta5bcMJKXtWWPnHnyLLEiIhocAdvL0rLrI147Yw+
	iIra5qlD6Hyx7H2y0ocHF3PYwMB0RtlIwES2Id9uqcWlXvHYR2C8CqNWjMBDXHQ6Fb2aF7/GjGk
	MUCKA//+zU3EP8fijkK58JItPEg4Ko/evgjjsmQBkXQaw7PzQUVhqwju9YmT+zrgh0OMaokfjj8
	7hbZ3rj2fwm7VAfHH5qWVuZ+I8yWOKhBsf16XSKn1SbcMtdERvrU/xgnAkJfmuoQZ+xETj3SbMN
	nHTWHoMDl0ujMhYXjKEoYYMz1wpO6hAkp1CqYRjuHWLjx8LnrFpQj/CiplNiU5618q2JALhg9QG
	YDLnLuOUvAehXCnI0SGxfN53Jx2U7y7Kflq7q44a02uXNiXG5zErfn+Y7+tYbOFYd1bkfF92740
	/KFDWrsaLVSDj0mS5+0DOHw8ozam+YCxvu1Za+PlNOkumgfPyZMwA2xJS0LcOdOQ+gx64YwSw6K
	TZegGBikrx2ti6wrAZ1TEkFaons7CZK6MTSI6yVDEFeqOWWEpT+JGbx+XwWu1Sl7mtpbNwGx/H0
	SMZ3miVFhE4e/MvZNSOu7clNPqEiZ8ZQ8NB7SKGixF8UScqFKxjQB4mWCtSUR7h0rcKa4xva8pD
	P8vSzWyhbL5q3mVg=
X-Received: by 2002:a05:600c:3f16:b0:4a0:2150:55fb with SMTP id 5b1f17b1804b1-4a18e44395bmr24842945e9.4.1791540276044;
        Fri, 09 Oct 2026 03:04:36 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a128-aa01-297a-7094-853e-a20c.310.pool.telefonica.de. [2a02:3100:a128:aa01:297a:7094:853e:a20c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf2caf4sm53382635e9.10.2026.10.09.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:04:35 -0700 (PDT)
Date: Fri, 9 Oct 2026 12:04:33 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Stevens <stevensd@google.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/3] locking, mm: Add atomic allocator trylocks on
 RT
Message-ID: <asi6Kj3TcCd6HAM5@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
 <asZ8jmWNoGk5tYce@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asZ8jmWNoGk5tYce@thinkpad>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D454C40007
X-Stat-Signature: zuqip9c65jo8is18zp9krqp1nmgxs4n8
X-HE-Tag: 1791540277-361456
X-HE-Meta: U2FsdGVkX18YLUGH7x2KOoX90HUBLDhgf5MYoxYRShLjKSF7XpEVfZzujZ/Qjx0z1SkdMjhBT5/tbX4in/xbG8towCSXdXietCMeWHKIYlmVCKlYG8GwY5wY3z3W/stY76pnIZDwAeIimItMhsobRaOVvHr/VSCI0y/WWWLOC1E+0CjhKIj4NkXMLU6Qfn/QRnnPPTo75Bfq/ClQ6usmbcPiT6UqUGFtknBh/V/OlWuQfqJ9NPwEmvGNCrLI7SqOXvKFdsc6H0+Nrsc9IaTTR4i6157S3VT5jCcxXYPCE+wVoQlClrL+eF5bcDA7Chk+qWDqDu72Cq8+tWGYH2MHHolaH8Zf9C13FfeuC7MAMXbKLPvH4Ugc1Buj75SNptU/A4vL+1920SepWj9mWjiLxXl3nGFbAJfc1ckYiB88zmDJGmVbBIEjatJT0MsIxSNBTxvG+V9Srt/uvxnt62U8Jf5L7M6FpQPBwO/9Bh5ZxBvZEys+Es7/JzTGV+UIb+38KiB/4T7ItgJTB/u4R93QZ2Dx1/yv0cMGNRnZFMnizp1E+v3uNEGji+BLUSEWKXOT5X+54dRhtjq6fAhHzYEllGQKCu+dJLLM8j12XCt92M5+WE57Mj8dsxVKAencqDbcWXLOCQw1or4ysD11QfDdVGaAU4sRoc/gyFqaarpqSQi7iMA9VyxuJ4G3BZNYh+h8QyNDMHtU/WHBZa4GlfAEyl3MS8+qCUACMNNF1k/suxejXNsCzl01IoFVrEcwJDoPBYYlw0aG3d8bSsc6f3JRkKpwFkM068wus5o7sCPAqKAC3uuqLcJnLeBgz+Yvr19qntvckdF/LL+HcthcYZf9ioy6B1ALnAHKMhhtxBlEExHuwpwREn2kW9GoDHroLsDcN798qKpl3lhs8UQuMRw8tBhkkGAf4aCALq4FFn1fGgsqDiNa0MwL5gIsIsWqm0LCAOpqmaovSXrDH6MRUdB
 w/fO0mVH
 tzg2T1Aig/ZNuBeRZFL9lRElmvIO1rhY4Eyy3JU40HuTJge7U/09ZkbmzhEH8PYXnPvuxFnHcqjZ/aseqeucjr8T0ztDZ5V2AspVsj45vSnmgXBzmZI1O5r/IvDcyU70r09WuMP4/mmqXaKMr94EGxvLm9L/1xNccUuuLxRRt2GYVvbPoQBkl1CBpWy07fm/IJFoeZaHAZ6oq7v0QI5KKvF47+r7uV8lNxp9e9rLIk2akieuy1V1dOBd1QKyNfUWOtl3OJZSwGiLW82dTGhzpf4hFVghmNOQrfs34GMZKNsk2UUI0GdU31GlOtQosPh7kE0eWZcqcqNkSHps8tjdS//UwPU9DWorganWS69+Kf9y+WeIPh1LdfmlfG0VO9wmi2f8L2ASX9yM6StOPX3RSDlkfmtMUGBP4EKFLd2ihL6adPuTmS4Wl/BXa0POI2ScUPIGzPAWcBCmxvvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 07:15:29PM +0100, Harry Yoo wrote:
> > This RFC instead adds an atomic owner state for bounded PREEMPT_RT spinlock
> > trylocks. Atomic acquisition succeeds only from the completely free state.
> 
> Please don't skip discussion stage and jump into submitting a very
> intrusive change across locking and mm, assisted by LLM? :/
> 
> I don't think attempts to tackle this problem will make progress without
> discussing and getting buy-in from (PREEMPT_RT) locking folks.
> 

Sorry, I should have followed up on the additional v1 replies before
posting this v2.

On the alternatives in [1], Alexei [2] preferred detecting
scheduler-lock contexts and returning NULL. He confirmed that NULL
returns are allowed, rejected restoring the local-storage allocator, and
raised the RT unlock/wakeup objection.

I initially tried that detection, tracking pi_lock, rtmutex wait_lock
and rq locks. With RT, lockdep and slab_debug enabled, task-storage
allocation under an independently held hrtimer base lock reported this
cycle:

  hrtimer_bases.lock -> rtmutex wait_lock -> pi_lock -> rq->__lock
    -> hrtimer_bases.lock

I don't know whether my changes introduced or exposed the dependency.
The timer lock was not covered by that guard. This was a lockdep warning
and the workload completed.

I then tried atomic ownership in v2 to avoid that unlock path, at
the cost of IRQ-disabled spinning without PI boosting of the owner.

One possible interpretation of "raw_local_trylock_t" would be preserving
the non-RT local_trylock semantics on RT for short per-CPU cache
operations, with allocation failing when it needs an rtmutex-backed
fallback.

Would that be worth exploring? Sebastian suggested
consolidating the existing local-lock variants first. What should that
cover?

For arena user faults, backing-page allocation failure returns
VM_FAULT_SIGSEGV on the RFC base. next-20261007 preallocates outside the
raw lock. Failed fallback allocation returns VM_FAULT_SIGBUS. If
restricting that fallback increases fault failures, is that acceptable?

Thanks,
Karl

[1] https://lore.kernel.org/r/arIY0wMQjCCsqidI@gmail.com
[2] https://lore.kernel.org/r/DLO3RV3IQUOV.21BNLF4QS9T4W@gmail.com

