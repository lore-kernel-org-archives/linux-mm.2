Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F8BCCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580536B008C; Fri, 16 Oct 2026 10:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531916B0092; Fri, 16 Oct 2026 10:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447726B0095; Fri, 16 Oct 2026 10:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23D316B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:09:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6041404DB
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:09:10 +0000 (UTC)
X-FDA: 85328671260.05.120EEF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 131024000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:09:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGe+v27p;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792159749;
	b=7SkjpSoeebxGWgCuqNm8+W1fkL1FwkHAbUx5+mIJ70ZZoveyr7H83S0VyvI4Jkw5q4Fcg8
	0wB+r61Rx9/vX7O1lWmdJWsnyi8XO10lL8SxQaeZIIQVt5MbfwRIpyXGEzqQpTaf1X6sRv
	5Hd9ec5ryNRYkiOUMdOYbBgfGELZf8Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGe+v27p;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792159749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rY+da4gZ/gT6x5YDiZjxmuF5eCELrbiaY4rx2johDE=;
	b=LJlzS2ZqOuBjb47oFv7dIpmIPmdoufD0xmdInotL5JETwvTMwaw7RdHBUrHqFa8VNM6zaX
	yTgSsQH0ptEKON+gzUhxOOaBWstVGxpXdUdtz/oW4Hbs5g58KWehh5SKtU4cs2Eg/QfkiR
	gnY8/8/2nJsomZrRqhzW3aC/xaJbww8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 03451416D9;
	Fri, 16 Oct 2026 14:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEBA1F000C4;
	Fri, 16 Oct 2026 14:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792159747;
	bh=/rY+da4gZ/gT6x5YDiZjxmuF5eCELrbiaY4rx2johDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGe+v27p90GzDxWWTa5dWIjd7PcDB2ayLWfH/O8Pnfw2ZQl1W6mNxyXCSMa9WOhyX
	 nbSo/WYdZbmdS02R3+6eiI8Uw5iYDt5WynvXdf7qVpVFMMjvTlqecHl8Yz5pMYFM8l
	 DeVjAvJ3YnE+W/u4AkDZkIB3IEaXeeslVPTczncGkMjsrHqkKqYySJuA0M/myrVNRM
	 p7u/1JzWgh39EI7wWAwWtVKAKXnlJHjhMLx+HrCcZm4iR39ddN1kBEwd3Xqnie5TyC
	 Oto7KE3HDp/jXN9a+4EDGbxN8eMxI8HFISKckDQEWXKmVy9qo5UwS/hQj3laK/G6QM
	 szuTh7q0wRHvQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Fri, 16 Oct 2026 07:09:00 -0700
Message-ID: <20261016140900.125937-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179214257862.2.17756454862637555633@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 131024000B
X-Stat-Signature: r8ae7pqdpwh3w7frmepd6nhbqrm6nqn3
X-HE-Tag: 1792159748-700731
X-HE-Meta: U2FsdGVkX1+ByY6Vmluyjrpxn/EEVzFb3zC28ccgqvDhBa/UVXIU4k4AhjzfRTuL5Zhm0iyVnFYN94KL+aDZdNXvjKvAQ/rrFfn0YKdreB2sl00teAC00FCLCUFtTbYsf84T70/+L8hYCeS08+Dh6VXSDsXw7wFYkGIxiylitSJ55PyRmuEZaYRnmJl0dLl4ekrddd25NGZpzhtmRFhhikPMXkt1heMA90EhiEIpdmaDuZ7eksDKaCV+0aF8o61x6JJk7VRRDLTgzxJlULzxXnIuMhJ7ZB5vi2Ukews5cVTJk7fTRjqS5Jihjy8dLdpuqPEYS/izYBHpL9AKVys8Dh6UY+7cZT1a++vqeQ/2klDR3jALJLudVrXbhegsN3NEO6E9YdHlGlMXVVZ97eHpVxwj5vWlCz0gsdws/6lCCPWHgvLGvJc8i99mYDpVxQCrIBXuhdb82EhASg87u4Mol7msq352eLqc4YcH0Gqp/bvJADf+FgIia9bhSVyR8sxqXibdM6yfUS6cBoYgfp/HZk5kg4PWiqRLaIgUvBIQmUyEZq+fjNSXSAFFFCLxRkczj7cm5UlLwmBGiUD1TFpWXVH5Q2b5drgEPWfg3cde63Kfb1FoSevGZF8Lv8xkihKBIVzVe5WPWlJBfUYZW7CnBOuilA/89c4WUD/NSKpGtXhmAbauebf1Q3GGRYrxTYkPD5n4T51Gut+xJPaE31nZ+36/W3dcpUoichYqJAixTvBv1M38iGAUTfj8rVjGtenxoSpMKPabH2b4K2PfBFzQeEMPY+Z5vHluEobFyHgctl10O4nVVYL6g6UMEWZ5J6DN5PTo6uVroLdN4zshAa2tvMVCi4PBmEJ62qQXvNUMWSSS+2zK4Z0WLbm24qyg3ZKGWDRJb/IB8w7IOpYu8+kOpJhzfGIChlKLNO+h7LqHLjeh6L9FwIg/vue4hOJVxkurG8AOpurDqgI7Dxr7SFy
 b45csLpY
 nitnzcJ2hv3luI9x2YjrViZxxOsp0w3S/5Fiz8mDYGsXjPaVTr2r/QNNzjjp7wlVprYbOMXXrt88QWXm72uGJc2i5LL6nLkDC/0lyORPcpEyxlrdB92o2aAA3fQIzIqWipEsjvA+rIFUOP9SMmPNxM1xOyEIuSwFpolOnvU/iVHAtGXb9VRPKVbp0iVal3tblWt3RV8aDq0iCZBl8K3WmaKY5SJ2j6UCvMEfcmeWVtN8mfh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 17:22:58 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Thu, Oct 15, 2026 at 05:21:29PM -0700, SJ Park wrote:
> > This patch is sent as a followup of your previous bug report, right?
> > Unless it is very urgent, please make sure the previous discussion is
> > completed before making a followup action like sending this patch. As a
> > rule of thumb for DAMON, I'd suggest waiting for ~10 hours after the last
> > comment on the thread.
> 
> The patch was already prepared and additional tests were underway when
> your reply to the bug report arrived, so I went ahead and sent it.
> I'll leave more time for discussion before sending follow-up patches.
> 
> > What is 38?
> 
> 38 individual VM runs, forming 19 before/after pairs. The 20 same-image
> runs formed 10 control pairs.
> 
> > Do you have a plan to run more tests to be able to tell that?
> 
> I've run longer VM tests, but even same-kernel runs vary substantially,
> so the overall patch effect remains unclear. In a fixed-input 32-bit
> userspace test with 10 regions over 256 MiB, the median increase was
> 227 ns/call (+42%). The old code updated 15 entries, versus 101 with the
> fix. I haven't separated the extra updates from arithmetic cost.
> Maybe we could record region counts and sizes alongside VM timings to
> check whether both versions are doing comparable work.
> 
> > Any reason to use div64_ul() instead of div_u64()?
> 
> total_sz is unsigned long. div_u64() would truncate its divisor on 64-bit
> systems if it exceeds U32_MAX. div64_ul() preserves that width and maps
> to div_u64() on 32-bit.

All answers make sense.  Thank you.


Thanks,
SJ

[...]

