Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7257A606A338
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 05:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lwHpMddg
Received: by kanga.kvack.org (Postfix)
	id 435CA6B00EF; Wed, 18 Nov 2026 00:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7BC6B05B0; Wed, 18 Nov 2026 00:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5596B05B1; Wed, 18 Nov 2026 00:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 046F06B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:51:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77D8414061B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:51:33 +0000 (UTC)
X-FDA: 85447167666.13.F66971C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADBC5160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:51:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lwHpMddg;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794981091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSw6ZugS96kEz4/rIAoJ19YrrOB0SWDDu8VwO1dP5m8=;
	b=bE5GgTikVIc/epn+CN7T90sbNhftyDw9yX9nbfjln3BpcNW5JUnzpW/CuTyGv8jCmRuNca
	G5w1kbZxf0xhCvhRiSIHFE5lMLpwWqcBz5XYhY3D53j1rTS3vCXyx5pxGJysdIEUcD04wg
	CZLy+GKAxIaKiIAwsjTotS/iuHx257c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794981091;
	b=T8o+7C/0hGQpkV01xD83CZBpVVi1lSqkLpvJh0OY0ZJGxVjmV7VBKFUMTsifE7w9tGWzpz
	vFAm3pe0m1lxa7HmUJM8lWSBL7ldCOmTFST3miSX4kJBHf+13ch7LvbgXEfm4P6ZjWUJSv
	FO6i8MHFjQyKzHkd6jELr3XdKuw0Lfo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lwHpMddg;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9958C40F2F;
	Wed, 18 Nov 2026 05:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7B51F000C4;
	Wed, 18 Nov 2026 05:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794981090;
	bh=PSw6ZugS96kEz4/rIAoJ19YrrOB0SWDDu8VwO1dP5m8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lwHpMddgeDHi6TjIDH+6VVQjeNyiAfOC814NA6PtmuFFkHkSlZfdhHAkOobfcDcPz
	 CoNNJexbEbPdybV/yoAqdH6vgwZLBU6OWK/guFYoqQkkJKOLQNhcBtqaIPDSMGm/7Y
	 VRPZbN0YTlrodK8wlLLu+pb7MZFXkxdLG+v26qP4=
Date: Tue, 17 Nov 2026 21:51:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, Sashiko <sashiko-bot@kernel.org>,
 Muchun Song <songmuchun@bytedance.com>, Alexander Potapenko
 <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov
 <dvyukov@google.com>, Chris Down <chris@chrisdown.name>, David Hildenbrand
 <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>, Lu Baolu
 <baolu.lu@linux.intel.com>, Pranjal Shrivastava <praan@google.com>, Ketan
 <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/7] mm/page_ext: fix client data alignment
Message-Id: <20261117215129.d7bcc7bfa060daf99828f0c0@linux-foundation.org>
In-Reply-To: <11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
	<20261117120627.50601-3-songmuchun@bytedance.com>
	<sashiko-outbox-219498@kernel.org>
	<20261117114635.37d4c1f7f1b38cc4ce7fb886@linux-foundation.org>
	<F4EDF1D2-D02C-4339-AA30-422D576B735A@linux.dev>
	<20261117202136.9eb67013389f3bdefe9b3a15@linux-foundation.org>
	<11DE08A1-5F83-4BE2-B8C0-B426441A957A@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ADBC5160004
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ptzcdnm47gr91tbxnq944witbrbcjkp5
X-Rspam-User: 
X-HE-Tag: 1794981091-775095
X-HE-Meta: U2FsdGVkX1+NH7eMycUeZ6smA4gzzAvlhDCu28yRO4rTK9MSovPyWPtayrYMPv8c9qka0h2zTwF1TL9D2XllTk3Xo1U/qlFPnSfPw3gje0JGcF6JV4MnCvgfcPM4exErqBTs724udY5iKReUWLYH+yVn/a//50zbtAmQzuJ6ft38eUjZK8FERlzN7rARTdy00+ECWaO1ruD3+Bww2C5uNAFSD9O9RpENsTfKWjiotX4nvXTdIsvlW+uCBI9TYNU/31y4jCfoP5rZo9zsYL5aqBdL3gWRrjyu4cC7c6s01sT86/6/bsARUkF/kDhHhbt2Uymc3CkoRX/Gb06fhe9sCcG/EUvmAwWwaKtd8k42sdSiKZaxnKBbX8Zns2QXq6CUqdHk/GFv9D9AgIMIxz6NdYZdVfL+EjyczDOOOQKX3HsMetOH/FEvgGmbSNpMsCoBp68RpFCpyQXJ1KitylzbKfIIKcLRvsEDPKThRHlR3tkM5QbElBNhYvWQ36PCnLMm4z1qr2P4eQUqkUJBDw2vkfTLMaj2ZjytM4avWD1yxFWMu6tPmiXSRas9c4xdlfcVxEa2MfEWhZ/Cdfa2pOd5/FBFiuottQMDHQmSK5oF/X6+Y80DMhfY+3JPsSPpx70YU2pgTpohjrDFpccyeGjePQT0SZ4a6EWLCOtxSNnfuRgaAhDqfjC5Bj1qTGe8poIE33T7hMNXRKJEl/S5GRMGHD7A2hMnPe0pnQJIhSLiBJiCcfOFlbKQspZS77IMIGM9qzZCFR94Imr7dD82U1BhXQ7kL7FbzM5MC7ngwNcHyhWFl/+/froP7IN4x9z1TKcNUri+I91zH8U0zO4f2tKIIsvgpG7fCN6S+nLqwzIvuvFk4FJAQZczQSYII0qGi1i5VbmGb/lZ0uZji0BXI2SJJZdZnywPWhW5fgMIT0X2DoDr6K9i2r/wi5l/8G7B0wlo7vCv1a5ln0tp7PYdPjh
 VNGmrQQ7
 2xBckMwEYRA15XImq0Ct7clHRB3fjjzBcpM5nm5i2jpLHxXShHepL4HxyXTni/8noeEGWnqJBdozdcKp1KsiwhLBu/dd3KQOOjJg/3QKMQuvRRLdXmqU5puZFbd5nafB234MP6fgWDWE4+cGhx7wPZ2Zh4tJZLoBOZGst1YV+aVWMdpKYdyyUzi/CoxagWVFiYkgThUdJfTc9WNw1q55Mi6DyPzk+LXuldF13NuO9MpIb1N+BElvlX9KWdwVdcb9cHEWtxO5Cg6nUfEZWdNqGxS6P/GVUKANOLQW5LvpFT6Tr2a0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 13:39:04 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> 
> >> 
> >> Something like?
> >> 
> >> static inline size_t page_ext_data_alignment(size_t size)
> >> {
> >>        /* No client data means no alignment requirement. */
> >>        if (!size)
> >>                return 1;
> >> 
> >>        /* u64 has the strictest alignment required by page_ext clients. */
> >>        if (IS_ALIGNED(size, __alignof__(u64)))
> >>                return __alignof__(u64);
> >> 
> >>        /*
> >>         * A type's size is a multiple of its natural alignment, so its
> >>         * lowest set bit is at least that alignment.
> >>         */
> >>        return 1UL << __ffs(size);
> >> }
> > 
> > Well I prefer it!
> > 
> > The final bit-twiddle could be (size & ~size) but I'm not sure that's
> > any clearer.

err, (size & -size).

> > We should have a handy helper for this operation but I can't find one. 
> > max_pow_of_two_factor() is close, but only works on uint.
> 
> How about changing the helper to
> 
> #define max_pow_of_two_factor(n) ({					\
> 	typeof(n) __n = (n);						\
> 	static_assert(__same_type(__n, 0U) || __same_type(__n, 0UL));	\
> 	__n & -__n;							\
> })
> 

Switching max_pow_of_two_factor() to take a ulong should be OK - the
thing only has two callers.  But oh, that name!

But do we really want to go there?  The drama with min/max/min_t/max_t
and especially clamp has been endless.

Your open-coded bit-twiddle looks great ;)

