Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BFB4CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4516B0088; Fri, 19 Jun 2026 08:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C1C6B008A; Fri, 19 Jun 2026 08:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA876B008C; Fri, 19 Jun 2026 08:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEF0A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:34:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E31E165B18
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:34:59 +0000 (UTC)
X-FDA: 84896606718.20.1A2B4D7
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88510180010
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:34:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p6B9zDPU;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781872497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0p4Zco+EbJg2Q3om+c/k0HFON0p9YOo8Reu2aV1iyCQ=;
	b=M/k/mNmOmmal6vgnrM25gVOJFE3eu8lEIJKrQ9ms1GAQQYuAgELTFvR6wn9g1/Ktne9JQv
	zbXkVclHVIws8TP/Ddgv7KO0sjEvg+yCu0FrxeBs7qc/QtKUcz9FZ3+Ivj0o7nwD/95KMX
	T/9F4OYBUeoj2LJLyWY5TD6nQm+zt9w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p6B9zDPU;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781872497;
	b=WHrUFm9IkQLi4Qv+Eaifiz3WAZOqKqHp4BMUf7oIyM+R78ZDcqgGURMjgyNjhlcfzMF6hs
	JWHNHyIzlcZZlqbJHepv8DKcuBjw6Z1fsaTSyF1jFTU8wqEsobYLCkJLo9On4C2ntYoMSV
	f2dX9Y0Fg2qvJi2whp8ZIsx5VAVpgjM=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781872495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0p4Zco+EbJg2Q3om+c/k0HFON0p9YOo8Reu2aV1iyCQ=;
	b=p6B9zDPUI3qIl5LZUQoFzQ7QI7+zaHkEanl81k9UQURsEZnWQBZLMRxbLYUOjE7mabSJWh
	XtfIG2z6iAop1AoMGh2tbDPqfkNE86fz3H+N6jfcuu1RCY9UtCGtKm/Q/EqJzkaBylz1qz
	FncTsLoDUoo0IIJPX2csW9R8FCR+SOQ=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 12:34:53 +0000
Message-Id: <DJD12YR8S99G.1I43PSHB77TA2@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
 <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
 <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
 <DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
In-Reply-To: <DJD0X2R79SVW.1XM7FV4REYCHS@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88510180010
X-Stat-Signature: 1hy7kt887jioy4rknkc591uw7hwgdjwy
X-Rspam-User: 
X-HE-Tag: 1781872497-409489
X-HE-Meta: U2FsdGVkX1/GgLD59llp/LFUyoZY8Q5ataXMOTCcwI0aKOl0D8IkKZ0SL0s6JrgmAt4ftKeemSWQD7azeJEe4KlC629uxoxRcFLj2DQF4Vp3kEChG3JKuA2WPjlMCGELJaxJT7G4o2aig6TPqclcf/W6Sm+8vhs0d3SqjTldJhqNN8KemsbCvEvIyA77MAnslXHKrEo5o/BjRs361ADMAYfiFcASI4bp5IJxFijtn4+vBv1+tPDND1+L3tXQFrAwxZiqPy7Pu1GQByT3QPsKXWXAj0zXPO/rTqK1RNObNrgVPUdpqIAeop3qccVtP6Kg9lXuM5yFhKaDMO7j6p3w1L3vZFHhLClwx0pDZqRWzZ/EpMghAPFgKLIW2s19smqU2mAifW3Fh+4EAHwvkit2tGnC3oVBHju5NB1S4qTP/S8XsAnRzT+goW6kE6sY2D8ByslkPlGkKiwE8JWpoKuYUL855h73AR0cipD3G90cVpa5JVbFPNwmNYyxMaAuGEo4XkBoc5bWebQPibJk6lz++i+XZ3RwGu2B7UmAPpvxj5hyzwo8Mpvzgt4iD7o1d+PLCxDeYCVSaw1kIhrgNBzUGJ8CU4Sp9XofojJszJWek6pAoyceLOSahUqn5y5txJWXrF7ma+ZNCeOYDMq3P1jexaSXyQ5QHRwToNaNPM22knC2eKsaEGTpxZeANlS3M7Rnz+9VmUTKgWc2hkcLbMi/8eEY8/W8i1LyKGwKfEc+mvOgYy96Fxh4q1oEqN5jEjEWdBick02NqLQjKLSL5U/gB7ynLqzArKkK8x4Bq7Xr0CYCt2ogS7EZ9IRaH1Vbk+NBDH+U05JwpWIucPZKZ4Y2BdoxXT4MP4+qrX45sFsFjsMluXvcB90lP9Ol14T+Kinzy/kHjy2aQzSXHEH2xLt7XlFglP4KpYLzYAMfkEJSn0kj6SUsxc7yPZp5TSEDY7ZSDn4hPyuPE/0zUZEc01U
 E4MVITjD
 D7RS7nkZOtgPwqgYVogO9vtAC8QfVfkQ0bTGAd9+CJ+d2cNGPPpcrAOKSS378yCa1iFmzeOJJdFKHhiq6w06Ih5/qECmiDxR3iYgOdIsl0DJ1LMVVx9udydiruQULZjaid3JmisD5nEmy71jNsTQW1jUjFbmO3Pa39p9d9srRpcG4IxE355atbmYn8IfnjjnYpj+THL0c2YfRHGs214fx4et6/U/J5FmcIfwnKpq9rVFzfYlWLZibXJFzIoKW61n5ro3GhW9bApzEoDMmukbHAdcDDGgfOVc/1dxh5qpLR3OiDtEwRUhr3Tnsf32NrzREQAR1S19HeajNnB8CMjrIEFgfNiUp63Yl/qpthbNP4cXs91VpYtCCFhY5uYsJpPay8B4wJOYZGqItajMxJVbhHeeIlyisRijQ+snMtsZ4i3dbIvPVML69NzLRefpRUzd9gAZjaXoDS07cO+6ZV57sOjOjZLUqXCIAnSlK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 19, 2026 at 12:27 PM UTC, Zi Yan wrote:
> On Fri Jun 19, 2026 at 7:53 AM EDT, Brendan Jackman wrote:
>> On Mon Jun 15, 2026 at 10:59 AM UTC, Brendan Jackman wrote: > On Mon Jun=
 15, 2026 at 10:54 AM UTC, Brendan Jackman wrote:
>>>
>>>>
>>>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>>>> ---
>>>> Changes in v2:
>>>> - Updated alloc_flags_nofragment() too.
>>>> - Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-=
1-936eb04202e7@google.com
>>>
>>> Sigh, maybe one day I'll send a patch without immediately following up
>>> with a "oops, I forgot to ...". But today is not that day.
>>>
>>> Forgot to add these tags from the v1:
>>>
>>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Gregory Price <gourry@gourry.net>
>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>>>
>>> Thanks everyone for the prompt reviews.
>>
>> Hi Andrew,
>>
>> This one didn't make it into any of the latest mm-* branches, is
>> anything blocked here?
>
> It is in the quiet period, no patch will be picked up until -rc1 is
> out. If yours is not picked up then, feel free to resend it.

Ah, I thought mm-unstable didn't care about merge windows. It got
updated 2 days ago, but now I realise that's probably just coz Andrew
was updating mm-stable and then rebased onto it?

Thanks for clarifying.

