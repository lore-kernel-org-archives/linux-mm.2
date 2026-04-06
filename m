Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5653DF46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A8876B011C; Mon,  6 Apr 2026 13:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 759A76B011D; Mon,  6 Apr 2026 13:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648B06B011E; Mon,  6 Apr 2026 13:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 52FB66B011C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:31:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5B8F1B81C8
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:31:19 +0000 (UTC)
X-FDA: 84628822278.20.F653A97
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F2764000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:31:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oO0iLbNG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775496677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVvk2qhydCpV83QIMvKvS2H3kcbdiNafD2fDAPZbsmo=;
	b=pdzYH3HOkme5xdeHdj6YZWS3K/jHk1EndNEMwb6xEKiEgadYpQf/0wI+9XjPc1k9rZ+ROi
	v5Wczy6goemPxipgt6M+2ZloPJ13gQlGukZsdBrdBawn04rWeg1gbGNFN95y5Ux25kgKDw
	yT33wN+uwLPzgNMWObeIeg6Jf9YuZ6w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775496677; a=rsa-sha256;
	cv=pass;
	b=jxjxfe0bC4Wlt2StJ1CMTz76lWe7/myn/BNQeyADUwRCeavDNG7qu/VmbyV66ZoiJktSiu
	nyEkBjELdDzL2RB77oeEPMh5ZtZfqOgTDOuGzKmfWJBdHthp96pHYAQBIO6lExbuVWqGsM
	GHqzxrTNU3tMns8o8dTEEv4bCqSGog4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oO0iLbNG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of fvdl@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=fvdl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488879dcbc3so198065e9.0
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 10:31:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775496676; cv=none;
        d=google.com; s=arc-20240605;
        b=FaC4bnPfjVxqyTtRoUm11cU69LbGS+1nSK0E9lBH0TrvGaYKUEAUg/PNm02iEV0cEk
         bShQ0lmgfMo/CMh5LiQO6rS17BSaK6ot2bz54E8Uzq9cJBtMoRdXTOsCcyFNeKvMlVU9
         1od+3eNBzzmRkk+hWGa+hjtxJIVSv2ybXxn9LBQyRklQx4dkZgDLEOEhO9dsdsVihHBD
         b0vEgCqIN/4qAk7YpAdMVIGHSf2NZ7fUT6z2ru3CKGVEjzvSTraZTl+L98t3/4QrZUch
         1nXi8bjS1/qjhH+zW53E8DIDGxmAYAFrq7B21Zy1Uxs7H4jetI3mZWhiUxk2Bm50LE4H
         0nUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FVvk2qhydCpV83QIMvKvS2H3kcbdiNafD2fDAPZbsmo=;
        fh=8ZE+YKBNq8LFn9JMsWBE3vNZSB/89jk1RoX2mjm1RRk=;
        b=WiWkcHd1AG6zZt+3rusPpmSeVd8KtViNpFYK9MeGoRDJSPoEljG9Elye8ev0ono5ac
         wbfOaWQ5+uzfk9V3sYvP226rRsIznY1LW8pTAO2X/iakD3ixYgpnq/+7esKLqouqUAu9
         4udILLaZ7ByKf2YDIeLEI2TalGz4JLVO6R3OahuEbeYF/IV0lkmx5f6wFVoyNmjv2PNc
         G0noSBWms4P2SRsyKrK2vhku5JKLsO6sCZ8SVlwxV5OSisf5VMUXmPOOSO2N0dK41KBu
         m3WLD/qJvVV+UCRaHFy8c8+kPVTm0L2GT0oiq26YP7SPNn2Y3stXBCCA762zWKOjc8BR
         OczA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775496676; x=1776101476; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVvk2qhydCpV83QIMvKvS2H3kcbdiNafD2fDAPZbsmo=;
        b=oO0iLbNGMw5d+gDNwz87QdXDURocReEZUeh9IgAHnGUyBHVGQse+m0D605pfaTPzNZ
         zfZDk60LBy4FvV2qOBi8Xo73/twEaZyiEalJi0iFFwq6O7MLSE06txRs3C71tKCFT8g3
         z/ttrx0al69Qh53FTSprxlx+MSgAUy+99rzFmQhl1MJVcuP5v+O8AGdzyXPQew+vHN2J
         itwNFA01thu9fXqDqjqLdaIJFpeCYkmuU35EV8MV0HQpAViifhWpmlS7aitYjDV8LbF2
         pFl3lyDJAyA5q+svwu/2OO3Fiswglvck6dFuSrLm7Fny3tnGRGivkL1khR80weckxrnH
         bZ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775496676; x=1776101476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FVvk2qhydCpV83QIMvKvS2H3kcbdiNafD2fDAPZbsmo=;
        b=Af2O7JJZ8WEwAHno3uR1ABNFNB6B8+RNbufv8J4ne4uFnQYpGkHjGCn+5iK+NzZw9F
         PRMN2miKHn45g6v2OIwclbLE/k6s4daCkHoDeUAc+ifTKPh5RbpDebF4FMRGWh7g4Lpy
         Mj5uAPt+0pyDx+PSmiZF6w3MW3URvC5PIOFCAU3RX5Ih30MI4Oz03uR/51ACsdaX87p6
         ipdLn4fBpNt1ps0meZuMH0Vhdi5nvjgUGHCLSzP36rBhzZSTB4imvFjLiNZ0Enq6oA48
         ipDK2dzmcpp8Pkv3+EX8g04E+W2MpV2jR+l5akKTiIIyZP0FRvR6d3qe82viQIQuB+2c
         mQQA==
X-Gm-Message-State: AOJu0YxZ/BOPJlbmD2k2qXZfYiW3eEaD42FtjVUXQ0+d1gpUe4kDKo9p
	dZCFzD9ttMhTzmjvwRS2afqIzR+Rk8BN8bGwBYMh1X0cH9MSXtH9KNxGzoLdhF0TAJa3aVcA+XU
	zScdHMZEm0K1M/L34wJWd2HwS0Uz5BnvRkZxSkq1m
X-Gm-Gg: AeBDiesiucxuThRczZMY6pAFupOpRI+YI2HqpVkNC+GCBZEndc84H+/zdQJbUvo9HlC
	IUFYUXxG4P0di6Wqlt2Cjce4Wm+t2sQVasCesw4JnjAwif2sYm6AuGX4thl+MM6TSTd6QEbKb/E
	QiHtKVHj6mckBhfROmn74cswd4/WJkQQx9sitoGzk5I+OfX8lXxP/4H/KP+jjj6D1zB7hNS16W2
	ad5IHEHqnYeYVJZqZoVQdI3nRXrMUkJ91zuQjQovs4AcBTMsMNn6gLbQmZicHvA5zoGpyfcNYGO
	351+6FA=
X-Received: by 2002:a05:600c:3108:b0:485:1a54:9407 with SMTP id
 5b1f17b1804b1-48899eda575mr2999725e9.0.1775496675497; Mon, 06 Apr 2026
 10:31:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260403194526.477775-1-hannes@cmpxchg.org> <20260403194526.477775-3-hannes@cmpxchg.org>
In-Reply-To: <20260403194526.477775-3-hannes@cmpxchg.org>
From: Frank van der Linden <fvdl@google.com>
Date: Mon, 6 Apr 2026 10:31:02 -0700
X-Gm-Features: AQROBzBQEwrt8pFor2MLiZ4nkQKcPhZNMJmht0Guhr4QsNFVe53rZyPTfssw_TM
Message-ID: <CAPTztWYXT0jHKfMqmUJR7Cu1vU8YPXLkkVY2dPpiEtRQEvdY5A@mail.gmail.com>
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: i8w7r8z5ndqqd1i5seuwdh6oszn6nkun
X-Rspamd-Queue-Id: 8F2764000A
X-Rspam-User: 
X-HE-Tag: 1775496677-595636
X-HE-Meta: U2FsdGVkX18GzS6hzJQ/0G6yjHAHEkL7J9rSp+7HT5Q4beXbpZIvD7/2R6gzXtZZqhianb2aqQ8eXnVw+umppQ2PUygtDQ0jcv4xIe5iUqRB68Tfyd10FthVM7inmo15hbbTMk4xfRtbpsLR9JVTj73AlMU0bCvyUozV35OBiYVdk0X8MxKObCuCc1+j8PTGX1eORq9dRmWS9SXAbsUN5ZJhsBfFOkNcxtJW5TRlRmvB1COlxHm97wkc80tKWEAVDnnZ3mnjUU4sIUDvOp3Xfr9KYhTmcHdf5vCrIjcxHDVOs4VxRNdN1zwHRMDLy3fucJVy/JMnYnXTBjp7WcaifmUZwjg/jv3qPm4+RyAESrzViDLKaUuJqWR0B735bSYCm+OIWxc2GBka/7IaJJDCXUkAj37fy+mImW768wnqQrpwHnC8JfjsgS4pod9Pjqkds741nSGcP/NYYRcru5+wpkEv0MYbhJH7vuSypAZZe3lEOF9b19cvrFUV7ZZjR58wdImFMWtf34x8vEV4YKAPMFM+e9Z38YyayxNWkgIGYrrJPEDGLrFKU1aSnMaThhO4d+S6bFudWelFhp4/iiX5jG1/t4tNuR74nnMlzYqXJBk1FqLu0jYFn8TYSu87AmKf5fqiigx6wbsJurtChLctculhcWW50xwd4PQhYzyjHKb0qLl5VKdmtrqg5mFZRDuzNAtQK5vfM6Ig9py7s4nBHMvovD5S5GehX4XtwmUVC8/vLLZJVXChL5S69QZ1RCToZIUw8jWzZtQFLkJuRJRxH5gtM7BYyZdXH1DXRas4mt26DTTinO1y5yZWReS7S3u6a7gdMheo3VKTX5prx55jjnCysYuKU+cy3V/HYj54RrOn62oqyMBKvdrSXsnf9AUFmSHssPXgCJjKFF+/CI2hqRZHXHUfwJ3Rr2ebVEqonymhHbWeUn7CutSWb6UUpK+NDHbGJZK8QRJYO2YTb6f
 0GFX+iZK
 IQxcYvaJjrK4Rcx1whhnBfGwJsahkx9FAs9d7vvpDyKLSqd1r7vh0pQlyEowtZq0bOanfdKBov3KqxjHSRHBBzs2IvaNEP4klMYHa0Z9pEH68vXfrvQAFJxqig9VobtYpoWHM1KQGEzOIdsCzoxBjnXqO/E/n8U6nRHub+eJ6ZZmHAohjCcfx+LpaLl/pcElbYpjtvZIylEMYKeOM0STy0GauANidkkDFhjWKdezR8Ea/0ZxVRIZ/gARgBchoao1/+KsKRxfCKT/0zfrKndBmhSJAS+JMPTw0vWM7U/Ptn0kOV1z9ny4mo1qJz/8TUZv8cGH1iBQMMZ6nq1XRjJH09YMrGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 3, 2026 at 12:45=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On large machines, zone->lock is a scaling bottleneck for page
> allocation. Two common patterns drive contention:
>
> 1. Affinity violations: pages are allocated on one CPU but freed on
> another (jemalloc, exit, reclaim). The freeing CPU's PCP drains to
> zone buddy, and the allocating CPU refills from zone buddy -- both
> under zone->lock, defeating PCP batching entirely.
>
> 2. Concurrent exits: processes tearing down large address spaces
> simultaneously overwhelm per-CPU PCP capacity, serializing on
> zone->lock for overflow.
>
> Solution
>
> Extend the PCP to operate on whole pageblocks with ownership tracking.
>
> Each CPU claims pageblocks from the zone buddy and splits them
> locally. Pages are tagged with their owning CPU, so frees route back
> to the owner's PCP regardless of which CPU frees. This eliminates
> affinity violations: the owner CPU's PCP absorbs both allocations and
> frees for its blocks without touching zone->lock.
>
> It also shortens zone->lock hold time during drain and refill
> cycles. Whole blocks are acquired under zone->lock and then split
> outside of it. Affinity routing to the owning PCP on free enables
> buddy merging outside the zone->lock as well; a bottom-up merge pass
> runs under pcp->lock on drain, freeing larger chunks under zone->lock.
>
> PCP refill uses a four-phase approach:
>
> Phase 0: recover owned fragments previously drained to zone buddy.
> Phase 1: claim whole pageblocks from zone buddy.
> Phase 2: grab sub-pageblock chunks without migratetype stealing.
> Phase 3: traditional __rmqueue() with migratetype fallback.
>

Since the migrate type passed to rmqueue_bulk, where these changes
are, is the PCP migratetype, this will prefer MIGRATE_MOVABLE more
than before in the presence of MIGRATE_CMA pageblocks, right?

Currently, the CMA fallback is done when > 50% of free zone memory is
MIGRATE_CMA. For a PCP list, this isn't strictly true of course, since
grabbing a page of the PCP list doesn't do this check, and MIGRATE_CMA
doesn't have its own PCP list. But since rmqueue_bulk does do it, I'm
guessing the fallback still mostly adheres to that 50%.

With this change to rmqueue_bulk, it feels like it would prefer
MIGRATE_MOVABLE more, since that is the mt passed to it (never
MIGRATE_CMA), and the fallback is only done if the final phase is
needed.

Have you tested this with a zone that has a large amount of CMA in it
and checked the percentages?

- Frank

