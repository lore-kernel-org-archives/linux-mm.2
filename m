Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5887FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5E88E00F4; Tue, 14 Oct 2025 16:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F798E0090; Tue, 14 Oct 2025 16:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E678E00F4; Tue, 14 Oct 2025 16:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD6A8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:15:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDF4888A81
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:15:17 +0000 (UTC)
X-FDA: 83997824274.29.05E1AF4
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id EA3DE20011
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:15:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLU4i0A6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760472916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30m/R6kGfPQmiGGpbfSfPfjCzYkpYWzL1bJUfwurkgI=;
	b=Tlb0FVbwNmdKNu8ofRSlC56xWItid823JPSJDiJy7SkieFasvogyXR7P5mI10B0APpmI3A
	AI9zCRBeJXobBR8b5wn/FFmS/I5saLRp99bySTLDl756dvDLxjDNoIN25jzDR3EHWfOIU2
	pP97Omn6Ry6Yo1PAwyxUmyb33SXbtnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760472916; a=rsa-sha256;
	cv=none;
	b=pgNU9Nyj166fxFBQjewMpw3zdlTVIwuBnWvv1iBH48fcl0/RSEgUT/g4l0Mt3c7iCfMpI6
	+XG2FQsc3k2GjSy0PH15WSQ8r12arX4P3oUF/HPLoYBhQadFi/E9ic1QAtcVCD81w0i+Mn
	VwTq/0tcWYn6ozLN/Ob9W9Hl+kO64zs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LLU4i0A6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 14 Oct 2025 13:14:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760472913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=30m/R6kGfPQmiGGpbfSfPfjCzYkpYWzL1bJUfwurkgI=;
	b=LLU4i0A6ZpHdPmXMxuV2bZN0fctkP3wxDDwLYaHrtOgCs0TWyKR1pug9wqOq1/2ryEsb/j
	QGUt2ynUwveYKjE988Gk7NtQDHnkdUGuc3oHlCVHDlRYy+x4kMD+1odLFDA7a2Nkszgwd+
	JNlBh2+SNLZrxG1xC/DGmw0nBbo8ueU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL
 in folio_memcg_kmem
Message-ID: <vdngz65wojqalim4xb6vxb6k7upbzmkfoogmbuswc4lowju3ke@32hgwjlzxibr>
References: <20251014152751.499376-1-hao.ge@linux.dev>
 <CAJuCfpGBxUmvWoe2xv2-bsF+TY4fK-m1-Z_E3OcyTiSYz5KeAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGBxUmvWoe2xv2-bsF+TY4fK-m1-Z_E3OcyTiSYz5KeAA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: qoxtpdgrgby1q6wrd5r54gi3qzpas181
X-Rspam-User: 
X-Rspamd-Queue-Id: EA3DE20011
X-HE-Tag: 1760472915-199189
X-HE-Meta: U2FsdGVkX1+SvoS2Ut4uX1qDCfYF1lZ4p70/dTWOG97xhOUfdJ0SAUYi7OCfOZ1ic5wCVLDaEjcWlgBkQBxNuE8TBUb7fybKfo4HRVUP4b/TjRCl1EC2Ze7R3DBiTSHV+dEk2GSZpfq6Z0Sx3xohlAiUsp2qaU+7GEFowC77Dr8LpoanVjOB1eoF2hEf8HN+gp5+uLZmIIFahXu8XUxeAANeNfFgSpiJcj9fjbiKWXoigxke/JT2Y6vIOXPYUr9xv/c+ahdGhxNqbdIITptx/YDiXQi5p50Dlb5ZA48ujCx1uLyF5x39Aj1h6hiPjccWF6mW7XGlyKZ0/V3uvmLv/OyXmxW5s3UnWumRoobRuKwDshzcb525g49PIWo7xZwsS/ahglJ76Hwgr8qoH4jt27IvQqRvi/bSDDleTEqiliJmzBBM6iogAMFx4MbmBzPwOp4GY20kDeVf9Mp5yv5c4hyBdd378LpvdS5PWdObm029ActrbobomTXNNBBE9niwaouJOrIOLrxqAL4/0G8wE6ZCm2a48Nw7LafDubb6GM4HE1XC+uThQ3DxtgBQXu7aRD7NE5TwMH2e3jkhQ3XHqsGPYNsKQrLAHeoJhOKJFvgsZZD+0fQHTNuJqWDKoTRONGms6o+8tUuRFHwNkQn4NKNn3rM+MfmUqb/EdxM1i2EHkKD0PWFlydro0Yu1MECTT1ML9G0twwvsfNB6TZ7i1cVErfbEzMTfiDvBqYlNxY5SOlrtjufL0EDW6B+yUHw4axkCOoRFBti70H/3PQ/1PafrRZNksNInM0E9cTlpgqxLGoEIxJaJNOZG8neV24qG9O78Jwb8K/IrCVP9TapZ3DPBaqclJTAkVjqfA2l7JCxRHh+mWc/9sPgDC4yTdyK4xuhAyNZ2ev/bcfjmMIwI7XnyWcmUfSmX2rnqke0m7w+zYPhZ8l3mUNeZ+aWdRvYLJtIYjxiUu2b2RwvC5xd
 RZ14jR+q
 ncz2MKXQYft0MLrH3/QcsB+7XTvfrwXlEDZZ4/pN/3RSXnf+0ICIzsMCyrKmhVfmAWAsGxRxbjPiaHqYk25xaRcE1bOfFHmDE3JMy20DsBNYyRlkbwtN1nYs+VWzt2HYTZUbL0ZYRiH4vHS4oRTqRwV58doV40Adan/xt6FswS0cca7ajKMXlEQooMYOOJ8DdzwlRhAjKDcULxALFMoOJlXlYmasEyC1i0ueno4C2dIs7m05UZnxjGpma2ZuCUQKudOn2KAJM0b5KQk8TAdgkpxJBHoybdfGc8n1fh83iPQiqi3J1O5KyOSTujiwnphPWxRGlePdcjysv6ot67c+vjPz4X9xNfdxxRWhCbZi6Zmio0bSmUqM7+yIB8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 09:12:43AM -0700, Suren Baghdasaryan wrote:
> On Tue, Oct 14, 2025 at 8:28 AM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > From: Hao Ge <gehao@kylinos.cn>
> >
> > Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
> > the same bit position, we cannot determine whether memcg_data still
> > points to the slabobj_ext vector simply by checking
> > folio->memcg_data & MEMCG_DATA_OBJEXTS.
> >
> > If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
> > and during the release of the associated folio, the BUG check is triggered
> > because it was mistakenly assumed that a valid folio->memcg_data
> > was not cleared before freeing the folio.
> >
> > So let's check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem.
> >
> > Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
> > Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> > Signed-off-by: Hao Ge <gehao@kylinos.cn>
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> 
> nit: I think it would be helpful if the changelog explained why we
> need the additional check. We can have the same bit set in two
> different situations:
> 1. object extension vector allocation failure;
> 2. memcg_data pointing to a valid mem_cgroup.
> To distinguish between them, we need to check not only the bit itself
> but also the rest of this field. If the rest is NULL, we have case 1,
> otherwise case 2.

With Suren's suggestion, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

