Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69D0EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759396B00A0; Wed, 15 Jul 2026 10:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730876B00A1; Wed, 15 Jul 2026 10:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 622D36B00A4; Wed, 15 Jul 2026 10:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29B316B00A0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:10:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE8DAA0129
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:10:21 +0000 (UTC)
X-FDA: 84991195842.11.BDF3359
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96D7B1A0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:10:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OgqC1O9p;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784124620;
	b=3k0PFlAxP1DkT3EzjfJUyIBNJpsxJjtdBbvIdp67amUhMmwqj11JunuSQmuGVfD3hkmVfc
	y+Uojek6zcGn3bHqOcU6e3MQQvAsss4a5iju6uoDqn1n/VKj6Ct+zwr/LatkLsAAezy0se
	Nu+Gr+8Zpbbodv8fjyE70oXV+okRO5g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OgqC1O9p;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIsfZleXeVRVmzFEqb2XavBzUBRe+/S77RcLpiiBE+s=;
	b=Ea5/auI2dT1pM6OpHPaPXLI9Ito1V54n+SpoGV1XO0JXSSSLY1rjty8/9Mg4AVRR6zj365
	VmKugwvo+jSp/pckZG2RcT4mpGCAbY/f7xgA3O1EZtRdeJvB20ue+JLs6TB4U6Lx4uGxUH
	4og3w7eyhsVVWqQNxK9pN7SEPlukXp0=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493ba701891so17804535e9.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784124618; x=1784729418; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pIsfZleXeVRVmzFEqb2XavBzUBRe+/S77RcLpiiBE+s=;
        b=OgqC1O9pCNo+y7DQMbKBeqWgv9QU1se17AqSV0EyVJdwdupDF7soDEXJcLc6fhOcSe
         8Ps5fcwOvcDgno09xOl6gi4DuEDFbhq6xQhoH/KZJSU20O/xPOMueWYNleJlLAXi1y+B
         nfL65fHz//ZXFM0rc64g76UNjwFlgbCfGI++CeCkEGSVhpyO9tZhhjEW+bQi60iWbvyX
         35o1bAn6MEORoGfJOtRYMp/TBBQKIRs2aAgIVg/l2jdaOKhDr7qjdlUsWyWZmQpZmVFY
         7RKPaJCzQ2P0vA24HLgGvHayX86XRHZsgmVrLarJS8X68V0QJuQbPrwJmC/UO/4fI999
         FS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784124618; x=1784729418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pIsfZleXeVRVmzFEqb2XavBzUBRe+/S77RcLpiiBE+s=;
        b=BVpQN6y4/QMYvb2rELPG9HIpNAYZL83Gq3T5Oybxiyr2Bi8IHk7eEKqleDeU7MhIq3
         jkeFFHNlFKmvKZpU9V4+jM55ap1uHzhtEnHcOGbeL9tk2Bmk0nkF3hNExNA1q0yLdm0i
         k4EoDj0x6JYCh6YgGZ192bKLqV3rpjXr6bWClpjaedZ3XE3Fz01VcGovL4U3a8IS3eIr
         SeIiZmRX1AyRSgpjNHVSSwix1MUtiksspWhZNxjmp0nFcazFWOJ4sKoB+dV0Z9UAdysG
         HwbEuoW3lCpJU+KFjl1a1pBjtT4wZkw8mcjrMUFm73JmKSGZB2duuthPxBIjQ30AlU0T
         1pEQ==
X-Forwarded-Encrypted: i=1; AHgh+RrcljwIakwPSo6amQKLPeze+2wgvArpW1I8mBdb+YDsjUvT44u1dUpwzWQ9zc8w6kKL9q7LIl1fQA==@kvack.org
X-Gm-Message-State: AOJu0Yyfvn2DGiCtfifjH7jD2VlDa45oVPeMR8H58gkC2z7jVS6dxCkh
	EWGmBZolVT7lbqoxAM3dq+cz4UD8ab2A1l0SHT/nC7wOIi7t4o1r24expikrelJH3iw=
X-Gm-Gg: AfdE7cmiHYE4yKKc/CKStBi/SHNTq4gP4mF+wdOTa/8VZkWWsF2g0XFf0z3JtuQ5km6
	sfsslgjBjxMVi6Rqm7EpwKewnTdFujiDX4tMIqe7lU+11DNpkIyzhNQt+i7bUicHu4/WqUYdHdI
	/DMCOPloCc/zzrP9oZf/XYW40gjC5//YKPFuxfCQR/sMAtwxo4B6VoK7eavjgWZvcUAxdqXEGc9
	qvwE6qf1rTrYD2d+jUaADYW4nv7pMF7Kz00OZXg6I5kIe/IK65O6ZfWPepnVCoPBJmB8YHPs/rg
	YBZLAty2LExGMFTz6wqsecZ39LTvhRRHzq4iWryQ9HXKmuD1pK51TJwh2QWbfNHPVINxCz+P0f1
	DHbX3iY89n5ikWlusp9cuPc1O98XC8+szumnrBSYFNRyhf3J+0S/qb61UBRBi91iCypdKjS9Q2h
	XAEamkvG4dKs/Lcw==
X-Received: by 2002:a05:600c:e548:10b0:493:b877:fbc with SMTP id 5b1f17b1804b1-493f881d146mr126677095e9.21.1784124617927;
        Wed, 15 Jul 2026 07:10:17 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:1353:8eb8:c84a:b6d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953f643acdsm24454195e9.3.2026.07.15.07.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:10:17 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:10:15 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/vmstat, mm/memcontrol: add _monotonic vmstat
 readers
Message-ID: <20260715141015.GP276793@cmpxchg.org>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
 <20260713163443.3562378-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713163443.3562378-2-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 96D7B1A0005
X-Rspam-User: 
X-Stat-Signature: kapdxh6w7ys6mndgut5a198ww77arihk
X-Rspamd-Server: rspam03
X-HE-Tag: 1784124619-260148
X-HE-Meta: U2FsdGVkX1+8dpSLQGmBHjzuka+4LJA8mithNpc0OE82crs4UABLMaelSNcQRk26BaosE3E+xY++TiqlXZVm2j9yEBN5+5/vXDgx9pC0FgdjjVyizgrfvPtKWzz4ni/Hdk9Iqt5mEPE6u1UVZ401AfoZxCzRpZOfcpm0D0Y3EYcF33OpLYvnfiguKj4RlyOOsPfwDDi3hzF5/oFMdxK8e0AGEjLLLrvU0AyKNc3kkHD0zR345iZjHahMlxyagPo/GTvBI1NSEoHpA3oVIBcxgj1nRAkC0x2w9/64kZB1e99g6+4zZv6rb5bRF2MBFW32yF+ddan8C+A1QydoMhXjgLJv34r1XUCZUs2QRa1NE08DIEwfyLFxk9FWtq/X2nbIMMU5ItdeOx4krYdOpslGqiY5VEyCnPBWlJgcx1zIuQy5vR4lrucgfH+CBKp2RegKctxNl7POtYRhg7KH8OgMl/8+YaX65XJHjhkB1BBy93PxCjgDjTPmOlrU9R7I3nsoka/qQadk8+YzIbXRuNnhkHBBB4j52oNakQSIbe+hXkdiWLzslkvhA1BWMgSJf+7i0QBneFLVh19FPUTfby7YtOxCHul/Ppmy6Yh5d+YUearWnpvoO7jVJBDGfyYv53LCmmaPQsgWoB8rmBYa0veFvWhPGkylmhsQAavAj8UXRlwSkIoWoDFPbopYGicYC6qL/UQYDiuMt5Rfwo2q8VuS5+KamFBLZV01O1iktl+Yd5VFF1qoqCKkDDeQoP7ipsO0bwFQeAKJOLvmUwGG5oLeTASHK4NNchrEdxGLu29tpCQgMDwEW/lW2HMLJrnxB30UVB6wCuiFc/UoCHkvI7J7V9XW9/5UAA8/gUUNiMYAhN9NduhH5mcn9bDdCpXzonuPWsuGBq+K6Y+fdKUQejiaxjWU3bGCu1eANzsmY6Hm1xSztjh+9oZKF+hOPnIVrs2y8GX2rXS9ABY2PlZdMOP
 ZLujqppB
 PAYIa/qJTIxBYBS2Pbt4jbcwvaUnO+/PfPeCvAm9U9Ymz8HP7yxP5edbyvj+kgsA8L2MDMagmnHzB0/o9P3THqkYTSoe8QFUnPScG+alh1Bta6UnQu2+BFlwrCrgIGpp47fiNXNxQjRqa4eMq6umV66+BxKbK277ri+zRa0PWGFlaGwjA27hsad/LZBetTTRDY/0iHcQ1xH/yu8QkT3S1/v7rr/P00HB+BNUWMsXylI3OvHDqbroezkPBEjO0CxmURCLssRPY6gwi0KISxiLY30HqWkFInC1vOoMhKbfdazKUMD3VXMjXHKINActS+CQg/2LeSigKjltGeGffs2YUMYlFbsvYntgBquFU+FidLiaHxd6lGeS0Ibj6bUUiXpPSmV0JzzcdO0FlF69Vo48flCzA+MnrNeO2ANcNTj7qkmoT9BfQvJVn6qNpModYYgBF3o6ouuN1+JDtdZojphPKCHKJFPd8T/GPdsSh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:34:16AM -0700, Usama Arif wrote:
> lruvec_page_state(), node_page_state(), and global_node_page_state()
> all clamp negative reads to zero on CONFIG_SMP so that a transient
> per-CPU delta skew presents as zero pages rather than
> as a garbage unsigned value. This is the right behaviour for
> non-monotonic page-count readers.
> 
> It is however incorrect for callers that snapshot a monotonically-
> incremented event counter and compute a delta from two samples.
> Once the underlying signed long wraps past LONG_MAX, the clamped read
> drops to zero while the previously-recorded snapshot still holds the
> pre-wrap value; the unsigned subtraction then underflows into a
> ~2^31 spurious delta for 32-bit architecture and corrupts the
> caller's accumulator.
> 
> Add non-clamping siblings that return the underlying state value
> cast to unsigned long:
> 
>   global_node_page_state_monotonic()
>   node_page_state_monotonic()
>   lruvec_page_state_monotonic()
> 
> With both samples read via the _monotonic variant, unsigned modular
> subtraction stays correct across a signed-long wraparound as long
> as the true growth between two samples fits in unsigned long
> (< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
> practically-reachable one that motivates this helper.
> 
> The variants are only safe for monotonically-incremented counters.
> Non-monotonic page-count readers must keep using the existing
> clamped helpers so transient negative reads still present as zero.
> 
> This is a prerequisite for the following patch which
> replaces the producer-side anon_cost/file_cost accumulators with a
> read-side accumulator in prepare_scan_control() that samples
> monotonic per-LRU vmstat counters (PGROTATE_*, PGRECLAIM_PAGEOUT_*,
> WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
> the unsigned modular delta into a per-lruvec cost_accum[].
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

It's unfortunate that we mix state counts with monotonic events in
node_stat_item. We have vm_event_state for monotonics, but they aren't
tracked per-node (which we need here and for other places in vmscan),
and they can't easily be made so because there are "global" events in
there that don't easily map to a specific node.

So this seems like the best solution for now.

