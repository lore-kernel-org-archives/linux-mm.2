Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07257606A330
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jgBMRNhe
Received: by kanga.kvack.org (Postfix)
	id F17886B03EA; Mon, 19 Oct 2026 22:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC8AA6B03EC; Mon, 19 Oct 2026 22:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD736B03ED; Mon, 19 Oct 2026 22:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF7D16B03EA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:32:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36BFA14036C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:32:58 +0000 (UTC)
X-FDA: 85341432036.08.96A3216
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf29.hostedemail.com (Postfix) with ESMTP id F23B8120006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:32:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgBMRNhe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792463576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UeasOj6C0QSBv81NOjtXL/pSwcDJf+q6grtY75QD48=;
	b=tzp2e8/Zst6CIQ56Nmf/snV5tB7nXctbEHnS/d5OGhnjTtTSQJQq5FzqbdyR1o1Uyx+GL8
	1uJann3dTh/ZQE4Gx34e2kFt8HVlxveQ/R1icwjUDqoLnowxXy9sL+ZheyV1io1vTGz/03
	wyPLrgfUDjvlrW5xMHqWPg5XFggfFA8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgBMRNhe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792463576;
	b=fcA6JPho0Bh1OPUWn36MD6uJx3rYWQhhSHTKvV6evWnNnLRq7oXLMjIqIaUJKHVNtkjag7
	MWnJfuyPmj8o06rDzHd4nAtdqpHf0BoH1tGqtQgTxAuC3p9QYSHGAAdyaPNhk8L+7nKdDU
	1M8mDsztOEayv0A7X4sWSQA1Bm2WOBY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+UeasOj6C0QSBv81NOjtXL/pSwcDJf+q6grtY75QD48=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792463574; v=1; x=1793068374;
 b=jgBMRNheZKBI5mN5E7/ygI01+OFOk9dLk3mfNcNlhr/2K5tksjaBe9b9XywguOAT6nYV4j4e
 Hcs16QQgHVkYMkPGmmhMJ65IXPtKIiA4Cw20stlqJD9ct3HzAYPYQXW+d1SCWPWkTUwBpi/9RhL
 C4av6/ba0qR4JfXR/j1x/jrw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8af93f4628e3430e;
	Tue, 20 Oct 2026 02:32:54 +0000
X-Mizu-Trace-ID: 8af93f4628e3430e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
Date: Tue, 20 Oct 2026 10:32:34 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <285B262E-95AF-4BBD-923C-922DDDF0E70C@linux.dev>
References: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: F23B8120006
X-Rspam-User: 
X-Stat-Signature: 7b7ou7qxj6e4g3cxkw4ew8fjcxjgz1ab
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792463575-828329
X-HE-Meta: U2FsdGVkX18p8GbZyRE9qlJraAurJ/8PZ9qjqsPHRq0Q5RtX+r+dMF3vxsX5ZtSVyfHbT2eaEpl5TCpRsLaGnR82RisQiyE5jqW8btb5dPDH38S3cnmlMCfY29cFJ6/ttCxD8fpyJ9oPHilBpEqgRGJUUrmlSuSIadsvA+V1VhAExznq5TsV5S0ZIIlSIssFX6hWKJ3M3pkQfap9L5HnXmjwZOkH9uCTWsoeyJQ6n56E3/FZOfQZ/FGzIJD5Hpf608Fvp2aa+2y34GVvubt0qAyjARyf7HNkZSXRKU6qtNTz+Ky/TiXKSmpJJSHt6P2WRLeg+QbFFjHlBwWK5PlvytfA2Qy5eoOqN0A45K/yuPXqFxDmeWOYzhuM7MgzAkM2P09cpQdkpbm+edejDsH2fHHopmqQ4YMsmOWtKlnBtFWyicu40e4zdEIxD1xhJ5DkFdtWw3X+LaFPL/AzrKqMDi3sqjzX3WEXWC2K5Tj/uyfICksyuboCVKmT60ta6vKO1rziquE6LV4aHFXy4b+EkDcM/FLw6OGC1DJ1+60VnvhfLweEZWp8DtG1amDl8sbnzFhNP54QvHODmHTLVcBDtKYNRW7Dqx2VJdM536wM/+oEJ+lQHqFxMuwmrOHrqA120VQeTr6/DE2eL74XRy6B86TQpwLRiMYSZ6xYcdvjIJMlhQwS8s9p2gyKp4zrJt3wCojnias4slK61wrM8U3tpA9sevJ7Yn6GdB2Hb3/x7+HqYshbHcUk92Xskh4f1e8uWS7g0UeKsQvNAgsMOaSjXwq+H64XIl0Qrv8xgo2DGKIZAv5ws1eAdJVptUwNqEviE8BCHskjyIQDp6P/gtljfo9yaG3zTrPlXu/xudLtoHv0qU95w5+sOvwp652aPtRHNe7xA6n5obPXWDZtnBnVlMmd/wCsG1l1figsu3u3B0OtdhdWXKfMsHyrkJ02Gfwt+0qtRsx26LRjM6MF0ul
 w7nAuYAX
 D4JIZZU0kaWSrSnI6Y8GHP3BQS0FLEAGshLeR4xLgv8cnWPFHoNpWmxs5GcDwGLZYFYvcCMG0iHypedtpQGfOTqv14Y35iMShLALmtmvUWH8jG57SxFRkcmz7hCK05hwSmTLq8TQCRPghWGFlUmW26y0mAFurR/VF44jkPyDem+NzvuR4JKpEJL1H+gVU4Qh+naYXQ81pU/oV+5np4iVnHC5VcxKa6cfPd2/omHt2dvI/YCItZWjMKjj8JJqNblpzDRFRbBcPJwePEhpps5Z+HybD+KAyF5My1WmvPWQhOTGhEkOrjDs1E4tERaHJrWM74cb6TTMMpu2rRjILTfzJH6r/QD+NAygN+GMU32vlczonKRziOcJM+IxhQ+Xa9uApJnZ7lsVDL5iWPVMSGq7kG64gx0optvsTXURkQLwEVwyc3hzh7lWNyMLA7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 20, 2026, at 00:11, Konstantin Khorenko =
<khorenko@virtuozzo.com> wrote:
>=20
> shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
> plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
> from kmalloc-1k, so almost half of every unit is padding.
>=20
> Allocate the units from a cache of their own, sized to the unit. The
> cache is not cache-line aligned: the counters of a unit already share
> cache lines between shrinkers, and aligning the unit would only keep
> neighbouring units off each other's boundary line, at the cost of part
> of the saving.
>=20
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


