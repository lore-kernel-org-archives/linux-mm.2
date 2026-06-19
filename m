Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5912CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871F66B0088; Fri, 19 Jun 2026 07:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A526B008A; Fri, 19 Jun 2026 07:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761306B008C; Fri, 19 Jun 2026 07:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51DF76B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:53:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2288A03FD
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:53:20 +0000 (UTC)
X-FDA: 84896501760.07.50C2FB9
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6BF6A140007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:53:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N6Am7BdF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781869999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9mPVvMMCfyeBaGkN73jmTiBQg6W6T62T72A1w8H18Y=;
	b=QQocvCMzc8kuqX0VUWqiC2FslL7XsLccxjZpgBfK/c7uMtEZcPkhX4IBsxUlOxILpFzM1N
	3aV+W5soyQiQ+KnjJjm5GzVskXSM3bq6ib50Y6CW1uBRFO2y3xpvGSLUOVv6mxmmOJCNQ0
	XNGYytieN2mn79NsJAX031zeKr1tk2Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781869999;
	b=AWq9y8iarSEvEmc1VI+5eIM0ukC9Uh+PF7jndXuG4YAuxCh/DUFabY/kG0m8n2LiPyY0ou
	G3d8sP0Nfs53nQ6zCvFt8K/SbtwG0a8CBvt/ndznesfnWWWado4l95e+V2GLPN03XIa8Q9
	mzIfTL5f884mv6PhcO90W+yUgyoqj5I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=N6Am7BdF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781869996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v9mPVvMMCfyeBaGkN73jmTiBQg6W6T62T72A1w8H18Y=;
	b=N6Am7BdFhEGiYoP8mqSSMeprq7jmKnvuFDIfeHkPHAals47GmvKExvTBiR91yb2o0zN3MY
	AbS6HuXZ0WAEVRYf9SJm48OwXl/MhxfKOS5+jzQGR9mTIiWRSg73VZJw79w36yOl2O+ULU
	FubH4ab/AIRtQB6GNBJVXHMU8zUomg4=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 11:53:08 +0000
Message-Id: <DJD06ZZOC9IR.33KCFLM7L4267@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <brendan.jackman@linux.dev>, "Brendan Jackman"
 <jackmanb@google.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
 <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
In-Reply-To: <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6BF6A140007
X-Stat-Signature: s8ymbnnfyt9tahujt1h99xqu9o1gjada
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781869998-343969
X-HE-Meta: U2FsdGVkX18ppunJqfOpOHxiQl1sxnw7fZTvQXSsrPx+eAmiJ0NxKRQgpknGGk+YRVPUXKaLtHtFGJAauvLXKVSnbEPQiLtadh8goThFqvCH+E7JF7hw/e64LDp35j0kq3lIfvblqkUasRpLIFfVh2TXdZM4/N+8PJHEH1oyBkCJj3ShxgWrOGSyk6MB60rVGlOz39oo39melP6NMBZeiY6U/sngTFVBFXxl4JSpDPQKedOvSWOFDZdoNBgLkbzzo/cCuNZ3CvVDeWjSv9JRY+Mk3yWdTK6lWywhN7MZeXD8WBTJA257gMgc5W0T6TmCpocd9qn48EdzxsXoMnT6fZJm0wmqLxefu08J2IsTFrsAw5PiBi6gge48+YrD8/fAaZlo/mkEM2q+ciHHnGI0xks870ecpVn/kxj8zcujNDLi+uyN5qz6bTkK6Y22xKJnp03ynypPOs0qRBKNWPjoRZbhYMQUEdEQizVVt6bzECCDSEKeXNVS0vaUga5m/jUM3/aMnUKXkpzHNl9pIfvARBv7xIfYcRSbdYkszRSznE5Bqfdbr1uWu/I13//iY2ltJlxuQHLLY/GOkejgsvAFrMnSIBaejuR31XgL8Os7yhi7YuEnhZ8IiuNtJMDoDeEj/S6m48kBSM4Pb1wrmdnnNbMtg5zk6LWj4HuR0GMwKf6muMy1EQtiHcIDhAcE5Qxi0fXc2wS8ICWRCoI2sOUqJ3/MslBlCZtFwfsFjUqFQFMX/VU1t1htcEOM8PZ0TK5ojNk7U2BO2GHezHUU5lmn7o1UNN55kDbUZTHO4/B2iAFwgXSpnlbarXCrn2AgdCbGxUkcsDPb+ETG14hrhVdVc+zK0iBF+wWc+VikHi0zPTKjH6e6YsybgXPiXr4HlmKqzfvaNa9qdFUpadNQ3gNPFBM8VT+kOy3CsogWbSNfTOeb26s6v8CHxKDVSxrczaAOIaQKKvbOwHFhgnnAQmW
 7IwX8rjD
 zImpM6WmfWVKfVNOnC6wqaJ7CKCDGekh0b8ZP0H7NJW1qdCK/RyGLRxGr6NyTWe9ERfIwYlXbidnpXxuCYzB91yciWOr7y3HHYeJe6z5rip6cUTWsqalERuPoUtfe0gee4KWOZSBl+Nt7BcEqvBQUNtg8LCfhsxJIf0KXBCfP40cxRGFZgw1de3qNbWGdcbqPCclIYozU9XW/J3OvfanmuS+Gyd1xgwH92+/FjlP5ysyanGp4F2S9J18HVE15DW63jUe4abZ45uNnbwFEx/CcIeWX2VHnKmP5d6y1K8W3U2Av54GcNBlpGWYjLvTwdFRCgtL3tmZoakaClHhQ20krtHA8PKh+y+o6a7fOvuoTFeWbYtZqKOmfTZixrmHJyDZIJE8RUxce4JETUB4+O37ZfONJF3IKvQ98f2/K48Naycs4zrEnDQvsyJFoyU3YargIrPpjvfSwSC6QaZ+W+qu+Tu2GecUEywtf7XeJDji6ucyUY2eGN2y80lw+nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 15, 2026 at 10:59 AM UTC, Brendan Jackman wrote: > On Mon Jun 15=
, 2026 at 10:54 AM UTC, Brendan Jackman wrote:
>
>>
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>> Changes in v2:
>> - Updated alloc_flags_nofragment() too.
>> - Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-1-=
936eb04202e7@google.com
>
> Sigh, maybe one day I'll send a patch without immediately following up
> with a "oops, I forgot to ...". But today is not that day.
>
> Forgot to add these tags from the v1:
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>
> Thanks everyone for the prompt reviews.

Hi Andrew,

This one didn't make it into any of the latest mm-* branches, is
anything blocked here?

