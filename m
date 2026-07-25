Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9713C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 12:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4641D6B007B; Sat, 25 Jul 2026 08:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B476B0088; Sat, 25 Jul 2026 08:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378426B008A; Sat, 25 Jul 2026 08:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1373B6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 08:34:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 777D0A101F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:34:41 +0000 (UTC)
X-FDA: 85027242762.03.96BB4A6
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7104B1C0006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:34:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ALV/u6lo";
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784982879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4DKSBe6gBg9NpOljhRHmSDeJ/S4jLtsYwVLPovDP8M=;
	b=JvAMX2KAnNi3Y/n/KKxwUIMKOsrTwSs0rPat+V0SHH3peqmOatijem/GqBSeUuBtNngmud
	UBiWeR5YGDPI0bSLvyR2Uj7SKkvysK7vecLP53vP0/2s+uu7xEllk3FiK/xkO0lLe3nuyM
	dVsireqKcx4eTUKsoCTgp5A3ESlezGA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ALV/u6lo";
	spf=pass (imf18.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784982879;
	b=y1NU+ta/vYiCV5E5rm5MQV1M1IAxjHjTyNTLes4zUueWAE5Mz358EK4Vq8IFyVjFshK9Na
	UQR4Xth7G2BTchXEpVPbToH2WE1JKtbNVrTCJiVNXCmqe6z1hnVnQYpUK/Esj3dXXA54FF
	9YzuFmZMoVV3TEHSjWFbeGaiu2JXdd8=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784982877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m4DKSBe6gBg9NpOljhRHmSDeJ/S4jLtsYwVLPovDP8M=;
	b=ALV/u6loawzgaAOeUKoTBEZiF0fdJTuauRBaojnTcEvDW19TwfPHaQ0ng0Pv/5U1ImHfZ7
	KrvaY9pYQ2kWkc9/6+g6kDUIMCB/jsDQ1P3L5HMinU1M5CkX//40NgJNYSo2ovGqty3Hoa
	am7oY+SAh7d2fNfyg4queB/HMVNGUyE=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 25 Jul 2026 12:34:29 +0000
Message-Id: <DK7NM9RPUJOD.11PNJJ5N2OBED@linux.dev>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Zi Yan"
 <ziy@nvidia.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Johannes Weiner" <hannes@cmpxchg.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
 <20260722150006.3848560-5-hannes@cmpxchg.org>
In-Reply-To: <20260722150006.3848560-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7104B1C0006
X-Rspam-User: 
X-Stat-Signature: 8wx8tgk8f1sbf7qtscynr1mjm677aasb
X-Rspamd-Server: rspam04
X-HE-Tag: 1784982879-605294
X-HE-Meta: U2FsdGVkX18wYT9hkEQ5bRhPFvJgMzAZ631jyooGDfTpdFUtiBX7GswFf4fHx80rNxbLLF9EttVjcn0PZxgoTCzL8zkb5YQ1KqfBlsda7cqF3hqNA916CK/KU5IFK8cbJ1mnhZV9+IMFapG9Qa3odUDOR8cVxhIB9QroZk9PFF5Pj4w3mTEgYx+qEldK4S+j6HgMyLrzeRQgG29nQBfm/nW64qfA8UmH0UqYVHAlXUB2xpZ/ig+kIZAcyTQy5HU1nvimN2ToYBL8DfS8sjZig304z6OhNHz6dH//KxHY/2uTrpMh3COXvW2OWNy2IvSCHhwCq9ZuTFz+ddDPMu00g8dHUO7+EubidYxQEuMS2HJYroViQeSiXHZM6mFwLvfn6cX6hqc5pCA9czRWY3mGNK4Don2zKlgdOBblmGGVlhnIKe8MSSu5vln8g7jhn3BJRNT+h4XeDOoB6L84/fySClh0V4pMNB3kYx9Ft+nm455HrwE1+YytFl4M6KF6utCQ4gcNG9XS0DHWAfvkteXfmyWgsMo8XjlRBUN+jjjolZ8YidyfaMMKLJAKm+qvoB2BUuVv32qXyimQfxTJDnCgha+HlzBcZd9rf71Rw0J0GNkZNPEdPzPCzrXgTIuBltIsRgeUqOst1K2IDoXgk5wZF3wuFfGczywVJmoyKPgH0DiYccqBMef2uCaiNEHBGAZ6tqOo5uam34m413ydVBszsJim/mkWBW5U1AbUlVm9vbOLHMeYMg46w/+81icftjZCneaqMPD8ns0oW0HfQB+PpyCv5EYqhBtGjb7yvHpzKmVrtDXCa1/aCSkztCZMqn60HqZPhAwCl+XJqKTCpNqBvKvu1CXP0xga98voJ3PT3SZr14DapZFtiHWSpLY3xuzUDnEmqeIN5YY+xfuHlJfcBERJ2+TS0GmflMn6WYE4O5XkPcyb9+HHIu0kyuamOneH9A5wwU1x/YN3FoQ4qf9
 lSFvOYVC
 10g4/29QLbeFO4DiDdxPMiWMUJ7u376SeHt2LU2VMl1bVe1w06SJmXs8mB6Lqyc46bOhUQdH0leyvclDgrZLY6Oy/0uJM/GIqckp0TS28GtxWYFy577Y8o+oyQ26sXgXRZMtG/OxVCJFgQhsB9WVpS0U0bG8NgY3OxuhYkow23daRNOK6EgsFUDntPnIqkM3MQ2v4WO1trDb8UWmNJrbIaraK+gAhh6062dSSFNw7w7G57zc3ewEe5zEz6Stp56yVKoDga//mStwBG6Ox3imymtMEEDvm73YhU/bL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 22, 2026 at 2:56 PM UTC, Johannes Weiner wrote:
> @@ -4169,8 +4185,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsign=
ed int order,
>  	barrier();
>  	WRITE_ONCE(current->capture_control, &capc);
> =20
> -	*compact_result =3D try_to_compact_pages(gfp_mask, order, alloc_flags, =
ac,
> -							       prio, &capc);
> +	*compact_result =3D try_to_compact_pages(gfp_mask, compact_order,
> +					       alloc_flags, ac, prio, &capc);
> =20

Nit: the comment for try_to_compact_pages() is falsified by this,
we need something like:

diff --git i/mm/compaction.c w/mm/compaction.c
index 0568623d9384d..ca57403dc1522 100644
--- i/mm/compaction.c
+++ w/mm/compaction.c
@@ -2823,7 +2823,7 @@ static enum compact_result compact_zone_order(struct =
zone *zone, int order,
 /**
  * try_to_compact_pages - Direct compact to satisfy a high-order allocatio=
n
  * @gfp_mask: The GFP mask of the current allocation
- * @order: The order of the current allocation
+ * @order: The order to try and make available
  * @alloc_flags: The allocation flags of the current allocation
  * @ac: The context of current allocation
  * @prio: Determines how hard direct compaction should try to succeed



