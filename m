Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B909D66B85
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5026B00A2; Wed, 17 Dec 2025 13:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651F16B00A3; Wed, 17 Dec 2025 13:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532B26B00A4; Wed, 17 Dec 2025 13:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 400FC6B00A2
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:54:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C657A140BF9
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:54:30 +0000 (UTC)
X-FDA: 84229863900.24.246013D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23E16140010
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:54:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AyfLcPLr;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765997669; a=rsa-sha256;
	cv=none;
	b=X3kFQqvlbSrSEaS/J6t16CAjZJQOM78LRlLw9Mf3pnfxJII4/R5F/HaSrk5q3LMx19BpDe
	N0qd7fuIeFpMYVCKZsaKZwl75rJ74SANXlJLZDNArWypN7Cyp/dTAj9vvzV1RjwFG22k+i
	sIdRXVOyRfrpqtv3EoWSS/s5BWUNlw8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AyfLcPLr;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765997669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBKxbMfrcJiIOYO5T43kE8XdmeNy9V6+ZHUpxc+6P8M=;
	b=OCRbkdduFL05EJ6dQoNWiEEabcsZAX6vdvE8+WnxGzlpyVW77A4kzvhYG88tvL8Kh/tNAJ
	Tibagxw9caqM3KbCfGDLaLKQfUydb5zsI2OLiILAHHlnwt9YwWTnoRayr1E12xSp5fy8Mw
	Xwy3JL/TZQTl72CerqmYjGNhELLx19E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64FC06000A;
	Wed, 17 Dec 2025 18:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800F9C4CEF5;
	Wed, 17 Dec 2025 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765997668;
	bh=UFy5VoMJgJWDegfLPFYjegCo6V9/j0kd50sEbbKUC1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AyfLcPLrRvfchnBfMKPYwdOOu1UiM4BKHqjiErohamcPpOdn65yzlIGyPrwF0e7px
	 83dSOl3MRI8wwykW/cJ0Vv/TA2kldAaYueeVhCq4+NpEAbNja3fMIJyUYR0ilM0GWk
	 Pjxb8MsZdOLyEIaxn02C80FNsR72mymDBLdruRJs=
Date: Wed, 17 Dec 2025 10:54:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page
 ranges
Message-Id: <20251217105426.5f03b5e8abd2e50faee9f49f@linux-foundation.org>
In-Reply-To: <87fr994hot.fsf@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
	<20251215204922.475324-8-ankur.a.arora@oracle.com>
	<20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
	<874ipqexai.fsf@oracle.com>
	<20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
	<87fr994hot.fsf@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 23E16140010
X-Stat-Signature: sj96jpar6uxrijq76umzo4epihh3kcaa
X-Rspam-User: 
X-HE-Tag: 1765997669-680183
X-HE-Meta: U2FsdGVkX194zUsrpTk2Du/mcVJatqfv3l8Qf3NERVYcyVCbT6VnVVCBCnG5LsEWITaVH0bXE4VtNdo4/MF6GODthWJA4vPuVTIS/ZL5dI69gjdOaPomdL8KsDk+CSP5GT0wL9I5xB+9+qeWZokmxSoXAdbh5fYG4EQuv4O1WL1+Mg8GK1MQAuy0FpFj5MFO929YIX2SPzLmi5vIsjRKFnhepDdqEoGaK1qZGcukqVgcd6gKNh8AI2qRzmEZVDRKkZrVWSgUYS7WO7XIcqWmheCRJIAF9LukDFiDroKqaj4RUuAdqk/DuUWc+zDuFEwOOskbiF7+VkAHYF50OSaGyZk5flweikbr4MFeJWsiAWv+y5zCq3rU1LKLZa0Z3KnSrFKXPQP34sqPbP3WZ4pnV1oBz9fCqha01t1dgiGQJP4orxbnaG7s271volqyyj1ix7po6iIGSsFSw1FKI9GBanOi1HDd3tLqeXNMcpswEpJJKD4CkmVAzbzf9PUfMMl7jSpwC3+w6d+MK5wV0GBOVNYQ1TCeIUdpVZn+WcRlImFxTnh7fZRWtXWaI8I2gB70XNcqNbftfhY54PV3kourwx4vbZ/V6gXjpgDPQPz2zguGhVx5VeT0uQFOJSmqobNtkE/w2+jSSSwoVn+xkmHoyV7fPuQckx9vRuiS3e6/bfn6S9k7/41qtc1r6ffBIcsNx92BguNYrFGCVShwjg8iV2OtIO3eD2Bes9oOR8QxcXxl6fq5F3F6JvDlr1FHeLoAMoXqS00HXtdKdX+bBzXww+ywnOypxZPofn5i7NJb8a5q5R/Gyx8txOUJmYpB18neUgMg78iCCYjJzjXjNOokFP/6FGJdgHWzrCLwxAedL4CSVvZkv3WND+G8SNoDDx2D3N88uHZcWR2mVtc/56y1fIs0kbMEA/xqe8X3C73XhyfQ0yiOA4Oo55HS88y3kk1/ZvQymZNeKhSTZRDKu0U
 cYiakJqq
 qHoGTE32h9f3BZYCE8rFzemo5Af3TrNW+Vhqm6CfoQsicxtLmCLcp0Sbm6uw1WACKBWx6mwcgYlZqsMJOv7P9rEukI56c3rIq4iJpVsxR2clg1Kw8ydQYiobApXzFtapebeJaJQk6ocC5z7ubRvlTZPXaqn2k7/8CI8DpBskMcqM892Q0+JX8u8GnnbBZa8C0jzyAnvsUF/Kr9uxY5UPGLhT8lfaqvRHqVxlrYozzVKmed7uB053F4mPrddt08IcUz9Eha6esj5Vypxy8wsKXBEhgX++OtgQ6Cwu46GC9QmgbRJ7TQd1dZKkbSLpDNjPoqB1K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 00:48:50 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> > At 42GB/sec, 32MB will take less than a
> > millisecond, yes?  I'm not aware of us really having any latency
> > targets in these preemption modes, but 1 millisecond sounds pretty
> > good.
> 
> Agreed. The only complaint threshold I see is 100ms (default value of
> sysctl_resched_latency_warn_ms) which is pretty far from ~1ms.
> 
> And having a threshold of 32MB might benefit other applications since
> we won't be discarding their cachelines in favour of filling up the
> cache with zeroes.
> 
> I think the only problem cases might be slow uarchs and workloads where
> the memory bus is saturated which might dilate the preemption latency.
> 
> And, even if the operation takes say ~20ms, that should still leave us
> with a reasonably large margin.
> (And, any latency senstive users are probably not running with
> preempt=none/voluntary.)

So I think you're saying that yes, we should increase the chunk size?

If so, what's the timing on that?  It would be nice to do it in the
current -rc cycle for testing reasons and so the changelogs can be
updated to reflect the altered performance numbers.


