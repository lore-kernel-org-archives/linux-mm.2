Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62183CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634D96B008C; Thu, 15 Oct 2026 10:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60C5D6B0098; Thu, 15 Oct 2026 10:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522BA6B009E; Thu, 15 Oct 2026 10:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324D66B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:10:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFF67409F7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:10:36 +0000 (UTC)
X-FDA: 85325046072.06.16F3716
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2FD2120005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:10:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMCS2YTk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792073435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnejWl8mRfWCD5JUDxQovY6ZIaJqGSRZlxKQNmpxKmE=;
	b=iXZXHrfGQjnS9xE1Os1lP6CR3EbBD2jd/Fmawf3i+ry5GU4oXTMMloU4N1PPuo8xnRE8aj
	OKZ1zJ8zjB+tjfxLUF8P7zbKggkkKdA2rLf6WHBrZzZP9VzFzA5pxN5zcgGHzdCX+yfk4z
	Gh9aWETlJ2FfJlFadggTNjwNrnP7LBg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMCS2YTk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792073435;
	b=j/9tvH0Tuo+bJkIF+aJcAlONIvlYmbLPe6LCMHh2UU4kaPQP3hku7nxU3UCFVGoozR+jU9
	dmOrMjc+OoE34VT9ZB7P0APZG7JjS26lPGDk9Jy8t6wwHllvEnT/I9dCQtgw3uapMcBarC
	sQY6quhSLknb//cGo+T+C1+j2vV6PNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D9540849;
	Thu, 15 Oct 2026 14:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB30F1F000C4;
	Thu, 15 Oct 2026 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792073434;
	bh=SnejWl8mRfWCD5JUDxQovY6ZIaJqGSRZlxKQNmpxKmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMCS2YTkoe7BKnA15EF+5Ouqg+UGP8EXI/UmIwlG7kZH47vSKuIbWwLOYBdN/yWr/
	 2Ci0WE4eT61jRLjAnNOi+Jsi1vhsvOINexjtV9gL/FFTByv44w8VSAMyljmKIoJlJq
	 2pdKUmDH87tN4fgsrNnrSV3CSvm8K9IBzFj5UUseztEEJmPy+Tdwbw8AMPAIwxj7Kr
	 /GEIZrjfcSWWd1gCkHv1sIs2hdEWqzoAawfA69A6sbDmYbh3NeHrEzGbzVhzjHHBkX
	 7jP7PPcHZ+UdI7bWavdZve6qwFHZn4gEFWo0cFd51vX/U23IrOpM3T+bik/p3Im6Zc
	 kYTyo7plDoxJw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON: 32-bit overflow selects wrong sampling interval
Date: Thu, 15 Oct 2026 07:10:26 -0700
Message-ID: <20261015141027.88149-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmFkTQMEpR10sxjoB+8XMsk=m9DAJVnyxguwV2LLYCg09A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fgt4j6j5h4nd8ujnr38et5e168ew1d7a
X-Rspam-User: 
X-Rspamd-Queue-Id: F2FD2120005
X-Rspamd-Server: rspam08
X-HE-Tag: 1792073434-696506
X-HE-Meta: U2FsdGVkX185OXTJUmvkEmzCMLv1kajSRIccxYlOG0Kbo6B/OvEV5gsc0nX6pLbMn+VUdrkEcl8urp+hYAbXcZXh7uDnbwrWHCP0C7LHweY+slarXhFIma2q8A1neATZPZZ1lPdl3Hlud7+KjmDRxY3BwhhEULV9SRu7uhdy/yCrfdhpNmZd+6WTrPhUwEr5fYonrQuQvHjSEAIDg54ZFMgHhYoAbuXnDu3e3u5AC8FR7/SCJ51Xba9vnyfBenRKJIIzKqEe3E7MfBurnKU9vlU9UlYFt02AQXNE6di7/bRg2r079IVhYIPVUNBmhFLAfztaFa5oUXqsiD7jbBtkAtz0aS15k9I5EstDGHztlbb6nnjcPX8TjenpEJc0tmJMKYVvCp/33q3ZabGFPKUgChT0IgzL9zajO6n5qrDJE/2jooItoZAVlEvLxgsQ9AJptkO8b2uYzKVHJP12ipWrbJBlAtq38bFZdE9dFkFtQyg+gE3rhQgeFvLuMfecuFch3xWkOeGGVF9JiujA/rHV72fDj8L60EmLD0SG+7xvNp7npgIn6QGKZ4LgnF+YneZ/Jt19yRE0NLPIdHArc8nvdEfi4w4kjDbSiDUYO4N1GenHPUe1cdbyHJ3J60y73JQVH+8HztP4kCJ/ayVNvWvbomFo9eJUV0Qw3e8uo7JEnxVGD+FBbDFbA64TVR+FeqJQceEjaxEL1yLKyWykNxteme93/E1wI+vFPUbpZchDBOxpnDfr/vV37nsbG9wMn55LYoW0mDZ9TgeSx0FSp8Qe4ba5J7xBlledf+N++954YSjfvtC00WjhR36FdxB/O3irxk09g3dcOoQWPR11U3OoTO7eBM8eX7W746xAQlqYNoff+eLM2S1JONyBy/0n7OiyxX0hqGF3+1pXuXFrcWTjXrpEG9GFEZ0ttTvHL1jaQx/MWkBPOed+e2I0nZ15ME76Q9B/wWMQ03mF8rz6cqO
 1UH9Qqfc
 Ec988GcjxSTOkvNVec0k1SeW7gSS6eSdE0FMmsgOl1NQs5l6StKRdYNhhDx59bwhY/M6TCrmO+hSd6+g20pSmptBBpGFpvmzclPf/rELUOR0LnuqeaKWgmh8cYW6z92CeRZ68i+UKFS+8ucR4CztmlDbOlW2RVy0om0V6+rTmq4i9axrfqgQ8Y6z+F4HUty0QKTuLzM+3VAY5mxveIYwzpw2B29c/oW3KNe5Z02zV2LUuiGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Avelin,

On Thu, 15 Oct 2026 07:24:08 -0400 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi,
> 
> In an unmodified i386 QEMU kernel built from mm-new commit
> ad9f2d463666, an intervals goal selected a 2500 us sampling interval
> after the first aggregation.  The same trace inputs give 2812 us with
> full-width arithmetic.
> 
> The kernel has CONFIG_DAMON_VADDR, CONFIG_DAMON_SYSFS, and tracing
> enabled.  The guest monitored a 1 MiB VADDR range as four contiguous
> 256 KiB regions, with sample_us=5000, aggr_us=100000, access_bp=400,
> aggrs=1, and min_sample_us=2500.  The default minimum of 5000 us would
> hide the difference.
> 
> At the first aggregation boundary, the four damos_before_apply records
> for kdamond.0 showed nr_accesses=1,1,1,3.  The next
> damon_monitor_intervals_tune record showed sample_us=2500; sysfs then
> reported sample_us=2500 and aggr_us=50000.  The records cover the same
> four 262144-byte regions before the first tune.
> 
> For that aggregation, the inputs to damon_get_intervals_score() are:
> 
>   max_access_events = 4 * 262144 * 20 = 20971520
>   access_events     = (1 + 1 + 1 + 3) * 262144 = 1572864
> 
> On 32-bit unsigned long, max_access_events * access_bp wraps before
> division by 10000.  This gives a target of 409364, a score of 38422 bp,
> and the observed interval of 2500 us.  With full-width arithmetic, the
> target is 838860, the score is 18750 bp, and the interval is 2812 us.
> The later mult_frac() remainder multiplication does not overflow in the
> observed 32-bit path, so the difference here comes from the target
> multiplication.
> 
> The affected expression is in mm/damon/core.c.  Widening only the
> target product would make the later 32-bit mult_frac() remainder
> multiplication overflow for these same inputs.  The 2812 us result
> requires sufficient width throughout the score calculation.
> 
> The 2500 us interval was measured on the unmodified kernel.  I
> calculated 2812 us from the trace; I have not tested a patched kernel.
> The i386 config, guest init, serial/trace log, and build/run steps:

Could you share more details of your use case that this setup is needed and the
overflow becomes a problem?


Thanks,
SJ

[...]

