Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8265CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:28:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80E86B0005; Fri, 12 Jun 2026 10:28:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58026B0088; Fri, 12 Jun 2026 10:28:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95336B008C; Fri, 12 Jun 2026 10:28:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C761C6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:28:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 735E940127
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:28:47 +0000 (UTC)
X-FDA: 84871491894.19.72C05E3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7752320011
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:28:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j1Il1Zuu;
	spf=pass (imf31.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781274525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uQFwXgZU0Ck9cr02Qktgh08VOPOTrz0vOOc1O5K1bE=;
	b=NujmCEJZqNR5LaMg2fN/C4RJ65k2mLkMdzSWqW/KXJRt8K6hlk4lZh99QHwBAZUHQHwWgq
	c1g7SRRhAyJXclAK9MBsGjkbsfUj+yg3PLg2pN1mmTBw3yC0zag5XQFI2QAL21Fy0tolkg
	bLvPHF8c1607X89IJXupbn+VCPU5edQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j1Il1Zuu;
	spf=pass (imf31.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781274525;
	b=kKiVLezpinUmncHFhXZzFrFsneoyIFLKN1slgRcFxPze1O+wfxP6zWLZMdbYAAV1ObEtkd
	pb38WNnkdkDXXX4GoUTT4a3dr6TPT+s5Y3g3IepDrHfYfao+kQs7iwcEBiZ52qCC8wi3MT
	oRmHYARvHKS0FkNSwWIYggAqpLCcOr4=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781274523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+uQFwXgZU0Ck9cr02Qktgh08VOPOTrz0vOOc1O5K1bE=;
	b=j1Il1Zuut8N1UBaK97YKnvlNSh/rcDwgA+Uc5Ar04/w7LegJIY0ddl00ePkUMRFJWaSzoF
	0bgyFsaLQSFmtiKOjgYgbJPVk7nUUdUKCpIXL9f3k5zelFeZUXX7r6m0i+ScvbQl2UWiyG
	ZWKl/sjhNq3Hh69HcGhxDIlX3+YrGtk=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 14:28:40 +0000
Message-Id: <DJ7549TJF9I5.O3K9X2TP8VE1@linux.dev>
Subject: Re: [PATCH v2 1/1] mm: reduce NODE_RECLAIM_xxx and change to enum
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Petr Tesarik" <ptesarik@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, <linux-kernel@vger.kernel.org>
References: <20260612085052.59291-1-ptesarik@suse.com>
 <DJ6ZMH9VU0BE.6Q8EHJIL65DW@linux.dev> <20260612133155.71958e80@mordecai>
In-Reply-To: <20260612133155.71958e80@mordecai>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7752320011
X-Stat-Signature: z66nqciansynwprnkgkt7x3kpb738cb1
X-Rspam-User: 
X-HE-Tag: 1781274525-141702
X-HE-Meta: U2FsdGVkX1+9S1pY+pAnqy8mttVzcZ3DjnMGQMw0uwUKeF4kSR8/R9Cydg7nBA2IIlaca5/VuAZeUHsM0r+MnK0FTXWPQwSNjVraeSpO6FJ3iEQJOyf3FhPnbxAv7deMTN0LihxS9IcyyQwOUVW1jeUJ9sMpgjuQNHJ8HOlmhe3RbRW6gNcHyU9cRhFCvwctgOXypkdusa+KSTk7voXyoiH/cmc86ulmKP9Bxlqq9RHnlbMD5sD6pjanpHSX36VkwYtbx/gvQ03zet6VbymNF5OKZrEiIIlL3fIQmZkDGFLt77kYr2t6wcZ0NZls7FoFD1uXEsOE4EA9FFbZbDcGV8eQjijLN1EkVqqEk6f0F6vjFfvtBmJ6cBKdjigmd1y5PX4FyH9yB/1FjaPqgHdpZoL8OlDW5ro49QXXrc4/CnK0u4dQAy4Kqzpe3G/PQ1HI+ievJ+L2IKsO7qA0CJA74YU7UQT/UruKci0a/AQ1/U52HiJVBb/m5eC/+Bch6DzJ5eRiFnQMb3eflIPI69VpfDNM+Er/kUPeUtQW2cYCadzvwaQzL9Vn7P6sRJAlAAHrN9UBdSH66wpRncsKIQ/2X1xSqEfvUmw7fEBA9XRG8ZInQykuOtGnJY9K1QPnq01EW0UDfNkFcacv21siV3zzfkO+/ZVCBMF1cRWoYh9iwJ4bklcffOaqXv81IjIwBT4ER63A03RxML17q3mp7WFrGpcGFJQbxxiFHl+5x0416V51m5TUVdWbgNm0PAxbolaDPJj/DDK8JdMkL5Xzw7Yv+obaCoySfHkKtwmZ8RGVnzEtC41HfM9AqVjGdpbaZFT8wx+bfkhqqegSfi7b6Gfec/S05T/zsz50g1e5BTedvDPOqwG3PTYnIgTFZyzyWwqrEKfYj15TDRAZVF5L0uOvr65M+8FzjTwO0NKCCSfQeleGr3Q2SAhkyqEHGON4LdBB5/LBtAR5viHhgGE+Lkn
 1P3q2zpa
 KtC2qcXhypW9db2QJemQT9RL4mMmjvq/7FRc/FL06sEUz1l0P8SQV6Oy8T5VeQ65x8q7fFD5yxXc12xAaJd92mvmJHSsUa7kXHXV/W4A1f1lwJ6oG0znW5kZMguSUdTgd7P/hrY9PU1t62vbJ+TtBmX0nPARQmcKKfb66Zq9FTDqMOyrtCFgK7pUyC4AQN64S2HmulCZaERh+DGZvxWu24KIa1OIrbaHqYWJ7wArM2JKrB0rlhdBz+TW0mi8qECu38f6H5Y+lul0MzovWW3SeMsIjY8wRvhzLiBcF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 11:31 AM UTC, Petr Tesarik wrote:
>> >
>> > - NODE_RECLAIM_NOSCAN  -> NODE_RECLAIM_NONE
>> > - NODE_RECLAIM_FULL    -> NODE_RECLAIM_NONE
>> > - NODE_RECLAIM_SOME    -> NODE_RECLAIM_SUCCESS
>> > - NODE_RECLAIM_SUCCESS -> NODE_RECLAIM_SUCCESS

>> > --- a/mm/internal.h
>> > +++ b/mm/internal.h
>> > @@ -1373,23 +1373,24 @@ static inline void mminit_verify_zonelist(void=
)
>> >  }
>> >  #endif /* CONFIG_DEBUG_MEMORY_INIT */
>> > =20
>> > -#define NODE_RECLAIM_NOSCAN	-2
>> > -#define NODE_RECLAIM_FULL	-1
>> > -#define NODE_RECLAIM_SOME	0
>> > -#define NODE_RECLAIM_SUCCESS	1
>> > +enum node_reclaim {
>> > +	NODE_RECLAIM_NONE,
>> > +	NODE_RECLAIM_SUCCESS,
>> > +};

>> > -	ret =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >=3D nr_pages=
;
>> > +	nr_reclaimed =3D __node_reclaim(pgdat, gfp_mask, nr_pages, &sc);
>> >  	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
>> > =20
>> > -	if (ret)
>> > +	if (nr_reclaimed >=3D nr_pages)
>> >  		count_vm_event(PGSCAN_ZONE_RECLAIM_SUCCESS);
>> >  	else
>> >  		count_vm_event(PGSCAN_ZONE_RECLAIM_FAILED);
>> > =20
>> > -	return ret;
>> > +	return NODE_RECLAIM_SUCCESS; =20
>>=20
>> Should that be returning NODE_RECLAIM_NONE when !ret?
>
> No. That's the thing. Before my patch, the return value here was either
> NODE_RECLAIM_SUCCESS (when at least nr_pages were reclaimed), or
> NODE_RECLAIM_SOME (if less than nr_pages were reclaimed), but the caller
> makes no distinction, handling both cases in the default label of a
> switch statement.

Agh! Sorry. It's good that you are cleaning this up :D

So in that case my question is: is it intended that we call
zone_watermark_ok() in the case that we reclaimed 0 pages?

If not, maybe what we want here is:

- One patch to stop doing that.

- Another patch to switch over to the enum.

And then it _would_ return NODE_RECLAIM_NONE when !ret?

Have a weird feeling I'm still being stupid here, let's see...

