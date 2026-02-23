Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CD9E98E0F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D0646B0088; Mon, 23 Feb 2026 04:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6543D6B0089; Mon, 23 Feb 2026 04:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528796B008A; Mon, 23 Feb 2026 04:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B88C6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:18:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA33F1A086F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:18:44 +0000 (UTC)
X-FDA: 84475171368.26.E80BA97
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E6CC20005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:18:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CTiooJZQ;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771838323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hH5OG2+RDDb8VrJivnQoBt0ft8/X+47GVBPq4Qe+3EI=;
	b=DRhC3byZ6rJIann/RI6a7KI4EFMYzgvwBcX7uVWppKH4Ze496CeY4vWxRT1fw17mRCvL/p
	KxvZem7tBGaN9Dse5dQTQ9Ikj8mfEPip4fGULdgVGYInaW689hBhcr/rNrJNvS7Y0RX0cO
	i65zCpY0Cqx6JO7z/vnzS+GeASuPugw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771838323; a=rsa-sha256;
	cv=none;
	b=RioU+YeBK3D5zON1uSc+aEGGwXIcpOOk9XeYsiqss5q4fAi9fuEJe8KhB6Bh9H/36iOQyd
	Ls+vpxXtBsBGyfKRvhPddHFVJbcITa8is0lU7U+fn2myu2WqVeGJ6FW6iXDFf+Gv2oryHz
	RhtyikRrFdbITkVZj1CCLoWOhc629VA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CTiooJZQ;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4837584120eso28646335e9.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 01:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771838321; x=1772443121; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hH5OG2+RDDb8VrJivnQoBt0ft8/X+47GVBPq4Qe+3EI=;
        b=CTiooJZQSIu/HFC9xBwR2KOFz7G5YQ7UdWiXQlonsIplO9PRcbfCmw8Yl9mwT0sPnh
         W7DUwgRte6XX8DLjD0QJ8JPSUSkLm5nFVqH9K0jk512w/sGkYOc4Lpe0OOfayM9tTLqW
         dnEIBuOG1TQ3z7CCxahREpzVI8DO51dWvMMqszCU7JXh+YOSYJDYp+kR6v5Oenxk2O4I
         LFEpLSO77g0H8VfkS1n8SpIPLGPVBbcvHqM/xv3/ayc9xlHur90O7RYGbZ+jgutggeRe
         sRDujW9DjnTz0FNY4mZ9Dw8Le/b4XHuK6UDiepnrw8SII+XIlGX3OHEHAb+V2YMwWjY6
         /3/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771838321; x=1772443121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hH5OG2+RDDb8VrJivnQoBt0ft8/X+47GVBPq4Qe+3EI=;
        b=gISLl7r0ynuYBUtR7Y/xqwUvJ3Vd1Wdqey1exmWgpS8Xv2ac0BWl6VeZSTg2gwALYQ
         0oLZ7BTGky8zJGHm2UQ3fYRNyEmFhl1pROk6MyffFgWipLMKcHw0yaEoXWUihECAMsNp
         pOlQAg8CzaM7oLm4JKTJYfkLk30WK0i3I1r2xQhVhvjhQATvcb+V0A3C61yHuFR/8rqd
         kxJgrFc4DeDyuucuwRhpxC3zQwZxoN3mwN+oqXpQ/G+ocAijeznL63mgfXkkqC6gRpsC
         L32mJiHD9Ik9XTajQpakUnVtG4K8Tc9FZt6xaBV0rMSbX2ASp/lWnumhKHE/RPuJG/nO
         qy7A==
X-Forwarded-Encrypted: i=1; AJvYcCUfQqaS7lUVSgSWeVOWWH9kW5mgJR3aQe+yqPaFKBBEOqKwA0aGKP3+fa9AuoYdQccOUBXCZMoBoQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+OA9Cr4o+3SBiwU7r1XJLc6LfXEfYAmele1FeoXgNx5+QpecU
	TsRsNKeXgcXim6w9YF7JeNim2ILq0vUUtpBqJLuJjYgo/kNYlwkrjKOV5tdZ7XAYVGE=
X-Gm-Gg: AZuq6aJuHWnYfio6XwPzoDr+CF7lD8Pjr5qXlxqHmRpQyuCtw1rDwHa/fNSAOPXDmho
	ZWU+X2itA42RtyVsTq1GloRbrpIkaJm5+Pxk1tqv2VXizlD6uk7R/h5GhhzIjfnVoEh9JvzQCOm
	ItWV06w4O+hojwVEdlPA4jKQoxCaMNZsl0kp9uk03ndkazYFLY9h+AXGuXBrIdcPSVH5W/OfR0B
	Vri5PBgsAR3JW34R6TLUiGkrZfYFhm9mFKnV37cRVQEcJUYBQtUpHzVf3eEAYseCxXJi3YJ7CMe
	GYR7qmiqozN1qYRhaS537Whs5QFUGwACIEuQy0981NwCJeRHNxjd7pT/h3JsrA3Y7KR6zAGxMSm
	vpZinlcteSV7E5qqfuwpmBhbbI4ohBuRowrVsKXBJdkVE4wi/lEygUyCt6GFObSnBp4fvz6kDQL
	aTpOat6xoMTeikAVpewGOcCs2Kp12nGis=
X-Received: by 2002:a05:600c:8b71:b0:480:1dc6:2686 with SMTP id 5b1f17b1804b1-483a95c63ddmr129275105e9.13.1771838321486;
        Mon, 23 Feb 2026 01:18:41 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9cab38dsm160005865e9.9.2026.02.23.01.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 01:18:41 -0800 (PST)
Date: Mon, 23 Feb 2026 10:18:40 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aZwbcKeO-59l0UOC@tiehlicka>
References: <20260206143430.021026873@redhat.com>
 <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZhv+Bw7nKKmbFdq@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZhv+Bw7nKKmbFdq@tpad>
X-Rspam-User: 
X-Stat-Signature: 1sk6pfk64wmokokf6eote58p6sxoqi3e
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E6CC20005
X-HE-Tag: 1771838322-411440
X-HE-Meta: U2FsdGVkX19oHqWMx12zDS90AKFxEqrZTaHY1ePv2kLc6F3oNLf7T/2FpyQAf5lZQ+mRReAvmOsT1+NccAK9brJ4GUfnHzApG4uGrYs6AXka74qAfHtj/MSM/VVS1bn+2NK6XLf9get51lvMB1lIlv6Nh9t8a4A8sB+IHYwJIXBgvr12XjjGhQUR9xy9iiijB4xsEZSwEZST6xB4j3FcqcEMr1ggXGSj42E6Y/QUKUDJzmNG4sOXrL2aFzsctoE1G98RCiXAEqkQGfEnANdlTpkmKpir/TXaSXl8tT19NwBWuVXbsOJnG0au5w5BjSeaJY98OXXp8Ukx3duHDDg/2NAWM9CHre18ByXnvLZsMRIeU/bBkSEacPvwSZdzJNq0k8njdT3vTyO5CeA01ud3uT0yHaISb3h8GYOeCtPg0J1wjiGZC1epogB0JScCPWB1CYY8HtWmusLqdzhzgD0rOemKsIz4sf/H0DazZlxxSiSS1t9YAGeloMSVzMj3I9cW6KYKIs0zCsK5Ay9Fmnu8uJzqjNH0e795Yqe6AT1lPGP0SxRjHgpuGJrP4TCq/oBW5CqbPayopoLVnJY6MgkxQ/gmywrGXkf6wN0fWUkiZAe5J6BVQns5cT3LJH1iGu7ywn/swewr+Tm0nCB6+kBt5Irdu52So1CmnGON4sGy6R9rZ62T0Zr0ivmL5zl5D9zk5tsN+ELuYhcyXAKf8OgT6HuyMz9YXKTXruYXyIjKsp6Jgeo4kHHCP+atGDvfITkuHBKMyELVtpjeULrW5eBYoYzoCnrhbuR7FCivr5Ie1D30bxRFUPjusnhn4eAihzxFaXeJfnl/plH7Xoivo0o3GQM4H03Ik7uE+7FPp7rHGmOpBeEsKKqlLUEQmCLZw2EK5dke5iPGPUXuLFwsvoa79lOIImBIyi4b9dZaIYsYxMdvS9Jmy4g34dCvo1Ykclbkarx8xTEEaQTDKr3x6T+
 l0j1ZE7E
 0095E9JvO8qfN+z2BSVzA64tniC5D+UXzOxsxz/T0D682L7sKHN0N4sEEi9m2T32LsjC6n5gsYNO3er2ClxfgxColNLj68szWgRymF2eK2hwvar440TceoxdIifHJeQapExF1CAr8kcHld1hxaVTqamSaNfRmgomgaKF0Ggr17VMtFPAj19KOyW0/9ucTF62RiowIgVN8rViThocApsLBwRsl51iajVxh6lsqR5788Jbs2fi0F4KovFf0RNkA4I/SnbfFCPGYTNHErKmNjXgE6o+rP1fBiJj4vI2Z1eN1qebY25E8kbAA5Su3Q2iIkig2mFnKMmBIWlf5yAwfRPfSnUZrVocB6QuvmILzVuiL/zei36KCpfpBKxYGbawjY7BSNon5VwLcEItBXrQNiYU18tVW3oBeb9o/j+Ahs9ax6Hkhyrw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-02-26 11:30:16, Marcelo Tosatti wrote:
> On Thu, Feb 19, 2026 at 08:30:31PM +0100, Michal Hocko wrote:
> > On Thu 19-02-26 12:27:23, Marcelo Tosatti wrote:
[...]
> > and delayed pcp work that migh disturb such workload
> > after it has returned to the userspace. Right?
> > That is usually hauskeeping work that for, performance reasons, doesn't
> > happen in hot paths while the workload was executing in the kernel
> > space.
> > 
> > There are more ways to deal with that. You can either change the hot
> > path to not require deferred operation (tricky withtout introducing
> > regressions for most workloads) or you can define a more suitable place
> > to perform the housekeeping while still running in the kernel. 
> > 
> > Your QWP work relies on local_lock -> spin_lock transition and
> > performing the pcp work remotely so you do not need to disturb that
> > remote cpu. Correct?
> > 
> > Alternative approach is to define a moment when the housekeeping
> > operation is performed on that local cpu while still running in the
> > kernel space - e.g. when returning to the userspace. Delayed work is
> > then not necessary and userspace is not disrupted after returning to the
> > userspace.
> > 
> > Do I make more sense or does the above sound like a complete gibberish?
> 
> OK, sure, but can't see how you can do that with per-CPU caches for
> kmalloc, for example.

As we have discussed in other subthread. By flushing those pcp caches on
the return to userspace. Those flushes are not needed immediately. They
just need to happen to allow operations listed by Vlastimil to finish.
Or to avoid the problem by not using them but that is a separate
discussion.

I believe we can establish that any pcp delayed operation implemented
through WQs can be flushed on the way to the userspace, right? The
performance might be suboptimal but correctness will be preserved.
So doing this on isolated CPUs could be an alternative to making changes
to the pcp WQ handling.

I haven't checked the WQ code deeply but I believe it should be feasible
to flush all pcp WQs with pending work on the isolated cpu when the
isolated workload returns to the userspace. This way we wouldn't need to
special case each and every one of them.
-- 
Michal Hocko
SUSE Labs

