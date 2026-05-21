Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5ECCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A4F6B0088; Thu, 21 May 2026 11:10:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A8A6B008C; Thu, 21 May 2026 11:10:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39AE6B0092; Thu, 21 May 2026 11:10:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FC886B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:10:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EF821C197D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:10:03 +0000 (UTC)
X-FDA: 84791762286.29.E56D269
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E8DAC000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:10:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=upj6C5S9;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779376201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfKgnmkxzmNOJLZxt74jCmZIPMukmqle2YeHK8y00YQ=;
	b=hJ2MGzfKUAiFnxcQlVkLeqHAEC97bM1Bt5LCHoeKriVEA+jrJsVak1S8rrasL285nv9CkJ
	eG4WHXBOyXy1TtGArVrVGWVhX72iLT7m9soz66NuUW7vN5KqiAM5jEEvLyr1/xcKwSXAw0
	eDZWijNGEgCb46O5hK5RfsxJbCJea2E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=upj6C5S9;
	spf=pass (imf10.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779376201; a=rsa-sha256;
	cv=none;
	b=dSoLPZ1yYB4vvT8oIzsargA6dzu/Z4JFKe7i6Oe/HgEuysiIdKPFowWNJscM8jVkyAjqtG
	zNmsqOvxYCkk9LwsEE99b9z1IopYFn8q/6pTvHH/PILGF/ODvUwvKPxj6rLg7QD8RI2nb9
	aVJKCfn0CnLNU8qZEkAbMFNSieEAu6U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HfKgnmkxzmNOJLZxt74jCmZIPMukmqle2YeHK8y00YQ=; b=upj6C5S9PNg5BasGyzMLk2eay5
	kzmMWjqxrq6r3Z2kso/qvUxTL0mHvuGR+X/jksHgbq8u4wXddtU8ZF+kqcR8tn/rXegF4kKEBQEdt
	Yltq+1WpV3NUrdqeNHFsmQMSE50B13SspoS8/YXUVLd97D+m/ssmZJvkSTCy5BsDZv5JsxSfMKMvx
	7pCgygy8UX1dEgY0W62oijkmvV4kCwOXHFgWs02GTWVfgLTeV1bP5NlItNOoFlYN6DV+aSrfZVnDD
	O9n/PvX9uGbxJi2fzotLNFrW7urs+VFKjXl+O+kMd5Oy7+2mlPvfcZrQ5/RShRmdQKpwFTEJOs/fP
	so16I8bw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wQ51Z-003yDF-2C;
	Thu, 21 May 2026 15:09:25 +0000
Date: Thu, 21 May 2026 08:09:19 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, akpm@linux-foundation.org, david@kernel.org, 
	ljs@kernel.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, shuah@kernel.org, nao.horiguchi@gmail.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, liam@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v7 2/6] mm/memory-failure: surface unhandlable kernel
 pages as -ENOTRECOVERABLE
Message-ID: <ag8gDkHNWT-92Jjd@gmail.com>
References: <agXcPleVC9LGVCmj@gmail.com>
 <20260515070353.87244-1-lance.yang@linux.dev>
 <agcbfLHT5ZWnNeN0@gmail.com>
 <f76b79d3-080a-4931-873e-99d4b3e1020f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f76b79d3-080a-4931-873e-99d4b3e1020f@linux.dev>
X-Debian-User: leitao
X-Stat-Signature: q665f5ki1nh1natg9zz5t8zj4ch55d3g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E8DAC000D
X-HE-Tag: 1779376201-446064
X-HE-Meta: U2FsdGVkX1+r4+JrOtTBDS1TRjrDnjlEZ7aPCAb7NQZhEnQ/F+BklSk6KUWRQk26UKKoVzv2gjK8EIAHJhyNMTY6i0itm4hrIi0MnJ/H++N+Pg2UfjjqmoX7vynHEt4mMg0hyXh+tkRo0aHLrgjFhDymstZVsJQMQiyTRlI/bZ5ST4xE9F3CLBJK5fDyUYG3ydaFPLuQStNytsuFm1ZGcpoyfgC89BH7WjUydqJqDRzCGm8Bq1z4ZG7V7JJ3bRL1B0RlXphDbHxeVDXn4oCkn0VeDzKvylTRRZMOsqGbtT2mRvW4xVkCpq48qlSO+Rj1FrFeGZuIQgO24WuPdQclBP6LfO3VyM58r0sjpiDD6P1PCAUZ/H99gMEtpQUOlME5bqzgFaRmLjV9ycEpPpSj5bHyRTv5/P5suN6t845RYMRM4HhJTMynHbq3wHxkZyGXhs5TeD83aECjRlWaPZzs7IHuDOSlWLKjxLUZLHBRm7qVscgc1Z4+yP/J1lXyXuX9ORLV8XATGtO/4TN2Shy5t4rjky0JJ9Twg1d9h5v/MlpKLJwX0OaTEUbbVqOs0D8qwXdYupVAAMIlRcGXdjPwax5gSyBCaveLBon7Jse9W2yIcEFq+4v9OIMzqf3x9+HTI1yOSoYNxtOIeZJS6BGq01X2bSnTTqPo2+rI4EvyW+mo/S98x2FifYbup16dG5cA7z5I80LAHTnwaJxu63YtIGGdhG8qJV+5zFD6MvJHIpPKJe6mk1pTN57YICbL6UMMf0wjOjPRGk3o5+hjpnB6woiWdvXil1S8LJChwiRx6d38VP3MCtUuWsyV4GULVRrDZU45JoGz1GRu1NwyJaaQGyESyKRw/zW8KouTCaPt4tZL86zvbTY2wy3Kj+iHHr6P+6y6yxmDoLT24TM+2E2+CXCUVdEW7sJWWoAzztLRw0O6nXiZaake24aU+69otEboQqkj7NE+HttcS4xWFsG
 EJkRJ1DL
 5A9JaWnG600d7NbE9IusoAhDPzXxdFeUzTKc1Cdlu8RVX0VBdcuSx/DrKRv/D0mbC5WCjNtF/pi3Adc28C/omOkmWYqbnrtAoaWYb77qbiZ24RBLd6u2uYn4Y8HNj6hlDPKYT2dIn0hkt34Kg5pOuDwPy5rKfPB0rLFNpquotSw9TfFHBAcXnvAeqwWmBfdSbsMJJ9vD+eCn1pQxxJ9vu+8Zn1YMWL9SAkDmfIh7ZBxfs1UyUnPy9xnkeRX7ePl5vav9/0vvmsY+7m1ItjGDfgm4BmSCPFTc+Kf8f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 12:06:14PM +0800, Lance Yang wrote:
> 
> 
> On 2026/5/15 21:13, Breno Leitao wrote:
> [...]
> > > 
> > > Wonder if it would be simpler to just do a positive check near the top
> > > of get_any_page() instead. Something like:
> > > 
> > > static bool hwpoison_unrecoverable_kernel_page(struct page *page,
> > > 						unsigned long flags)
> > 
> > Ack. We probably want to call it something like HWPoisonKernelOwned() to
> > follow the same naming sematics of these helpers, such as HWPoisonHandlable()
> > 
> > By the way, I will re-include the self test back to this patch series,
> > In case they are not useful, we do not merge it.
> > 
> 
> Sounds good :)
> 
> Can you also test the relevant page types if possible, especially
> the ones the new helper is supposed to classify?

Ack. I will expand the test to cover different page types as well!

Thanks,
--breno

