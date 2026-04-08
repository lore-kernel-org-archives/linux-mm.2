Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE3910F995F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F01F6B0088; Wed,  8 Apr 2026 12:51:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0EF6B0089; Wed,  8 Apr 2026 12:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FE46B008A; Wed,  8 Apr 2026 12:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 071D36B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:51:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1042E03E7
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:51:21 +0000 (UTC)
X-FDA: 84635979162.02.ADB5B9E
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8ABFC000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:51:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8fyWN3N;
	spf=pass (imf10.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775667079; a=rsa-sha256;
	cv=none;
	b=WTVpF/xR+YoRGPsv2lUJ8UPxFLT/II5EgYto9oua5uG2Ol2E0Ti5NrwiAA/nlpsc1kk/cV
	tdrM2j+ZDHrlSIssoS2oAEjG9FfM93DO+gWCZs/xT+P5qecdMH1+R1vvdhjg9sR4avIP6N
	HXV3zWZaSDxBKej/U2THFlcahW5Pv38=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775667079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrHGwLfLgUQGW2hlMR2HktDjRBw+hKJj17XzuK6WT3o=;
	b=EXB6uCSS7bXIpYZx7ZVTKJIegciB+22rrC/DaB1QQCKr14vUPA6l0EId635Pllxrjik8Ad
	k8mT2JYz+ugjGdD47MkVGuFSbK1UGLybU0za8tL0Z7ClXnp/Xu6Qxv5wWHZ3XGcZuhsWP6
	WYHFdvECfeA7OUtOu+n09CNL3wBFwF4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y8fyWN3N;
	spf=pass (imf10.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-79a46ebe2beso1203997b3.2
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 09:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775667079; x=1776271879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rrHGwLfLgUQGW2hlMR2HktDjRBw+hKJj17XzuK6WT3o=;
        b=Y8fyWN3NJhhYVz88yAXx/fIAauvsClhOSelL+jI2AURYypz47DzaPq6zUdS1oLXt1/
         ZSOMCo1KurLIjrFlju/Ww72DodbQO6Lm/F+HHK31TsQrKPPdSoi6SO+gjONNUCRZ+2ip
         Duj1n5Baue4b+D9BUW8lLjsGplH8D7Pl/S8iQT+LW/+K07u1jPZHYZrEUyxzpS52qLCP
         II1ORIj4JaTUk5l5JQK+Q4Ozc5jnFmcTh0bFYVfkvToy9F1FqGkue5TQkHsaN79dzNEI
         9Ua0N7ymjXyJoPpHGsDs/tNHICjGIE+7booXwUSLB3hlZcaYlPVDyLG5o/EUhT+bMRdO
         szuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775667079; x=1776271879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rrHGwLfLgUQGW2hlMR2HktDjRBw+hKJj17XzuK6WT3o=;
        b=s0HQrI9OJo34ZqV3llVYlc7rIEGKWVogoxssu8P3TceGraWw8DNJZFxndagv1yzEGv
         IyVKrI5cY+lf4c34XuQvH4TQx908XB4t8Etq5vZKnEZzplDQaRido+nA0vE7VMGsg6vE
         KcS/LPht1pI9mLo0fM8tYZjyHqWzOVI0wSgTQY3ZpUj678Ab+5oYFAsvkQbicWoItZKC
         SlW/wWlR+p2gzIe2NIUhlvQ1LiVSTUNhqnG4Z3UmxyMc1iotrn1VhS36Aecfv05xwI7u
         D+hNDJF5vuUYqHNRXWFTvV0DYElqCZ8XN3O1sniGcuwxXiV9STJyXoDKx4O2H8Py0qiJ
         fLMw==
X-Forwarded-Encrypted: i=1; AJvYcCUTb+pHggzJLANJxiaPs/tx1/VCMvuEsmXbZTNe9tsq1zspu5IUb0znxrBiG6VsTFl6O6qTamsc8Q==@kvack.org
X-Gm-Message-State: AOJu0Yz+v0B5l8quGGebaR8gRjeW0UQnL5rEWSLqhjfTx0YkJPrxuhqO
	tjox6kZNZ6M/2tAKoB+LXEWaVL28SymAVrt59K9kQxIshEj8HL/0GeMt
X-Gm-Gg: AeBDies50ukgg5kNhs7+EBdUKnhUClvHoIVf5zP/nGizLsdLHoiNutCPl6CtOOaJRHp
	ImaC1Tr5rEpQdP0ceFJV8uv3b1PtiWNxqJAFT7jN6rxkUEsois956w9thwAx3zt6JrPnnD/6MBo
	3J72Euht9RSAGN32DSC2cQHTd7Rw+zl7BUim/d3MD4B/I8XD5OJdfAGJ08gbNN0kwPL8PPgcaRa
	8P892jqYQhDw2KODvQ3DrqflEmZ3wfCrEkhL/DteqNuebJ1KoOUftyAMtuQzpEHQF9yCNC7Ae6k
	KkrBRLow82qksrcRbAPlYCWlhQJlCm4eDPnaNEK2Hu7y39WfVnnkUVKfmB1yO8Zep3Trb8xOHGY
	PRiKcg91Zup1VMnA5g3RQ6d3w3VS5gf2MatuoxBEP0/8NcsdwDKz4tT2uZp1rfV74xoSYDDTIGH
	GPW5OF/CBsGT7X6aypqg5Fy8Sk6OwBvZ2UxHqDjyeOHgg5MT82EwjBxKY=
X-Received: by 2002:a05:690c:9:b0:79b:ccb6:a837 with SMTP id 00721157ae682-7a4d31e5f49mr215312817b3.5.1775667078580;
        Wed, 08 Apr 2026 09:51:18 -0700 (PDT)
Received: from bijan-laptop.attlocal.net ([2600:1700:680e:c000:161a:64d7:b05f:7124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7a36e42ff31sm86023777b3.6.2026.04.08.09.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 09:51:18 -0700 (PDT)
From: Bijan Tabatabai <bijan311@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 00/10] mm/damon: introduce DAMOS failed region quota charge ratio
Date: Wed,  8 Apr 2026 11:48:27 -0500
Message-ID: <20260408165001.8473-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8ABFC000F
X-Stat-Signature: w3s573xz3ww4ffpz5aematiswqm4xmj1
X-HE-Tag: 1775667079-99443
X-HE-Meta: U2FsdGVkX1+xrWrp/0sbWHMKngRuCXaAY4oGIQ5vHGDStTR2VLDF/5qmcr8+y9aLVbMg0WJMajHQxrT2O4VfOApNfjwDi0KvlqgexCt15n2FI/qm2VmEAx0pJS48QlD7jA2ymbLzosjedPeiNjKzHcUkHP5vstGVMYfda+Xnnbi/06yqzuMUq+N1BG830fEwUCkY3N7MzccBZapz2EznW+fNAKtgJSGFsqe4+DveW7yevEwS20xF6ix8KXgWMP5d1vbBcNzk2IWcb3ULDjum5ZIJnAeFxfQSa0ZgRtnbcyvG00ulcogMH8fv4dQQvKeAeb1IpuGq6SgUHrKK7uvlLQyAbU9vfBSlIAqoObjavdeh6bRkif6uabS3zBGhsAxKWScw5rb1bDzOGDvYWHw2qNUuohe3uqHm7K3wtXb3in47CFVFzvrDemNCSrGH7ZtZCSgEjP3glhHuzOKqyQKxb2iI4v6hvUwypemRTWj6mS+UGMzQgDDtZCIf8z8UXp2JNKu5VsSY0qowolsS1UTXfq3I+XO1sfkPTslfnbucqwlhpRgY0cXf3/ZUc3ntSK7IfPE2DQwme6nnAihgJiC50KMUuradLZ6cP6N0UKLoghiT9y0lt5Y2Ii8tPNfr6wdRnUKcTqqwg3g4QADW22GQWpFDCtSTkiQporodx4phJL0pGgLcR0HsUn6AbmN9lhXw+3Qouc00jk1BSkqWDXX66zYB2l9lfT6hPB4Dxzo9Ma1u6LezXfgOCB9nCdRRfZuPO+QR3r5YGbIeklP6wCd/U3S0imYTz5I4CRks3rcfZgFoe6GsaS2qn/6q1KBDB29GETIl2F52GeYQwZa9vf0RGS7Ig8NUai5FpXhC7qStKLA8DE63B2E7KqdvhBXV6bfrKMHta5tIUjRkoYEc8Tcd61glE2BE8lJGDAsBz3exx8G6fzuXYzjUyektmAjelfhsIjiT7FlVFwzONKylaJk
 pG46Gk7M
 Otgg1VQn4x9+PeRQFn78AILsfXO+SVLZQETXzPoJvUtB/SKmi9IZWPLFuZKEr+bn8c67Rn/MOpfsykOJhcE9DC+zSPH2M6GETWURR5wfv+Py7rd9a/OuWsCIhasasdHoh98svDVvv/GIhfh1sEi+fqCN5qmnJvSTcXuqPtW2SLjNhJ+iH3hkgfg8HnFX56ql7JxwMJ6LeQQKdTTKQ37uGTShj7iWz7NCv2dDPZTA5sjdpDMLIyO7G3LIxPwYWa3nvXDWt3GY5ep87KUeszir4WSUJ9qhxk9oHNeAANMG1bBTOYTR2IiSHCvMwuB9LgrP/74D/IolJbjs6JjcCz4sH9qdgV4wL5TCjHxwbX2ZkT2A4/1eJRXIpTcOSM1BHI07ZDq2TDGMCQJBOqXHqWUSmkzLCGcerJ19o8/QZWgwfxr2rkM372lIFhUsSeTP7xRaa3kx5VwrieBdTiQHbp8z0pvTpu9I27fw0JsZB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Apr 2026 18:05:22 -0700 SeongJae Park <sj@kernel.org> wrote:

Hi SJ,

> TL; DR: Let users set different DAMOS quota charge ratios for DAMOS
> action failed regions, for deterministic and consistent DAMOS action
> progress.
> 
> Common Reports: Unexpectedly Slow DAMOS
> =======================================
> 
> One common issue report that we get from DAMON users is that DAMOS
> action applying progress speed is sometimes much slower than expected.
> And one common root cause is that the DAMOS quota is exceeded by the
> action applying failed memory regions.
> 
> For example, a group of users tried to run DAMOS-based proactive memory
> reclamation (DAMON_RECLAIM) with 100 MiB per second DAMOS quota.  They
> ran it on a system having no active workload which means all memory of
> the system is cold.  The expectation was that the system will show 100
> MiB per second reclamation until (nearly) all memory is reclaimed. But
> what they found is that the speed is quite inconsistent and sometimes it
> becomes very slower than the expectation, sometimes even no reclamation
> at all for about tens of seconds.  The upper limit of the speed (100 MiB
> per second) was being kept as expected, though.
> 
> By monitoring the qt_exceeds (number of DAMOS quota exceed events) DAMOS
> stat, we found DAMOS quota is always exceeded when the speed is slow. By
> monitoring sz_tried and sz_applied (the total amount of DAMOS action
> tried memory and succeeded memory) DAMOS stats together, we found the
> reclamation attempts nearly always failed when the speed is slow.
> 
> DAMOS quota charges DAMOS action tried regions regardless of the
> successfulness of the try.  Hence in the example reported case, there
> was unreclaimable memory spread around the system memory.  Sometimes
> nearly 100 MiB of memory that DAMOS tried to reclaim in the given quota
> interval was reclaimable, and therefore showed nearly 100 MiB per second
> speed.  Sometimes nearly 99 MiB of memory that DAMOS was trying to
> reclaim in the given quota interval was unreclaimable, and therefore
> showing only about 1 MiB per second reclaim speed.
> 
> We explained it is an expected behavior of the feature rather than a
> bug, as DAMOS quota is there for only the upper-limit of the speed.  The
> users agreed and later reported a huge win from the adoption of
> DAMON_RECLAIM on their products.

Thanks for this series. This is a problem I have come across and am looking
forward to seeing this land.

> It is Not a Bug but a Feature; But...
> =====================================
> 
> So nothing is broken.  DAMOS quota is working as intended, as the upper
> limit of the speed.  It also provides its behavior observability via
> DAMOS stat.  In the real world production environment that runs long
> term active workloads and matters stability, the speed sometimes being
> slow is not a real problem.
> 
> But, the non-deterministic behavior is sometimes annoying, especially in
> lab environments.  Even in a realistic production environment, when
> there is a huge amount of DAMOS action unapplicable memory, the speed
> could be problematically slow.  Let's suppose a virtual machines
> provider that setup 99% of the host memory as hugetlb pages that cannot
> be reclaimed, to give it to virtual machines.  Also, when aim-oriented
> DAMOS auto-tuning is applied, this could also make the internal feedback
> loop confused.
> 
> The intention of the current behavior was that trying DAMOS action to
> regions would anyway impose some overhead, and therefore somehow be
> charged.  But in the real world, the overhead for failed action is much
> lighter than successful action.  Charging those at the same ratio may be
> unfair, or at least suboptimum in some environments.
> 
> DAMOS Action Failed Region Quota Charge Ratio
> =============================================
> 
> Let users set the charge ratio for the action-failed memory, for more
> optimal and deterministic use of DAMOS.  It allows users to specify the
> numerator and the denominator of the ratio for flexible setup.  For
> example, let's suppose the numerator and the denominator are set to 1
> and 4,096, respectively.  The ratio is 1 / 4,096.  A DAMOS scheme action
> is applied to 5 GiB memory.  For 1 GiB of the memory, the action is
> succeeded.  For the rest (4 GiB), the action is failed.  Then, only 1
> GiB and 1 MiB quota is charged.
> 
> The optimal charge ratio will depend on the use case and
> system/workload.  I'd recommend starting from setting the nominator as 1
> and the denominator as PAGE_SIZE and tune based on the results, because
> many DAMOS actions are applied at page level.

This makes sense, but the quota is also considered when setting the minimum
allowable score in damos_adjust_quota(), which, to my understanding, assumes
that all of the all of a region's data will by applied. If an action fails for
a significant amount of the memory, a lower score than what was calculated in
damos_adjust_quota() could be valid. If that's the case, the scheme would be
applied to fewer regions than strictly necessary.

As you mention above, this is not a correctness issue because the quota only
guarantees an upper limit on the amount of data the scheme is applied to.
Additionally, it may very well be true that what I listed above would not be
very noticeable in practice. I just thought this was worth pointing out as
something to think about.

Thanks,
Bijan

<snip>

Sent using hkml (https://github.com/sjp38/hackermail)

