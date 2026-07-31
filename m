Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E621BC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 00:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F7A6B007B; Thu, 30 Jul 2026 20:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A536B008A; Thu, 30 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1976B008C; Thu, 30 Jul 2026 20:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B87C6B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:32:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48C85A146B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:32:57 +0000 (UTC)
X-FDA: 85047196794.05.2F93BA2
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8BF5FC0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:32:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI46gb9p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785457975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+0vsC71zSDov/oBYPn9+nw22jst3hXsJQFoPYXKGz8o=;
	b=bpOgPtkwCRuHrrub+d39Qgw+8vL/hA6oIiDa9wcPvj2xuoNSfi1q2bDE6Wn0Xuotdp2ibA
	VcI9HZHMUHZpx0Cw50Uar+xu6ubGSOTujZztoq8A/1CouVfZZIqFIOUS+l/rYTVn1VIiAH
	bDI5i0FgvhXpIpYCEmNbWaRZ7oTLWT4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tI46gb9p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785457975;
	b=67J8pLqPEEVOZX2fz9TUBMOdaL5FNuSL+bvqlIrEkTTo0DG9g5AbZz3Yg8GJ59lPMoVUkB
	0SB0dLCs3X0uDc0P/lA+1R4DOQf4b8ulkOP4J27uRbBAADe5hvEy0eQpvZMrYyJ/Hbu8GA
	0PH6UM/AQL6vcqTDhCLPVeiXkcnGfxM=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso558335a91.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785457974; x=1786062774; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+0vsC71zSDov/oBYPn9+nw22jst3hXsJQFoPYXKGz8o=;
        b=tI46gb9pBls5t7FCWHjTwZ+oFQi6zhRYQGLO2YbscJYrl+ccth74Kk4bPyC98aQP44
         TXtLUOUx8CBf0zkhrnxhZWWZ5atPkWd7x7zoTTxjS+gQlGfR/B9emYc0+xAQGn/VecKU
         dJxRJw4TF15o9TB8z0Z46Fm7442yX0FLWHWUw3DVoe6AT0SGZrJR71RFWDYPVej4pXk7
         z2dOhOlBL8+Y4Xe3Olia/xOuztuzdFE9DhqFQ7fXxZM7F/y4M7yAEH8asPJB9AHkgKx6
         XRIOO9IdgHI9/KrSlMsLSBw4M48rIPsxEEZu+XfpJv9HqeOSmowgKU/qozJ030z+pwwT
         v7rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785457974; x=1786062774;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+0vsC71zSDov/oBYPn9+nw22jst3hXsJQFoPYXKGz8o=;
        b=N9PFGSc7Al86BtBhS3OvelfmECqy82FHZ3JpKcnifLG7ylbGe3h1OgE07q23XVLJLJ
         rvaT1ELf/eS0BMiAkPkzisi3mrL2g7f8pWtciGoEJ33QpPun5nIkoC8PdzqBUVqUn5S2
         RpIQLLLVx4UVmmgGvFvEvGpOJsZhGav1qq1S2U12Ir7TJZfSEFIwtj/nhr39EaGxJC5+
         MPuow2WyX2RmpdEoPsfiT7qixV5ttjQS9UGAeu3zvS4/BroijYPoJFJVaz4jhlhJPsyv
         hfzbrBXAj3txbG1VYAPEsL41+aTePyl5vsT5p1mghxrFYRdISdhbZgGjOF7sW0dtVRvN
         ZE6Q==
X-Gm-Message-State: AOJu0YzA/QpuzIMZKmfi5I9ERpScjyiPEaTRNvSnxXaa6GdByxzpew96
	82v9jS8E+gkfsvYpgMPV/829t/X4eQ+/W+wsbnHEDKOLhOinYJ+jvUvQ
X-Gm-Gg: AR+sD13h6nWBGB3uI0YMt2DvDpoxJeHMePW67hazEQ3LmBYV/NFjCsPl7m9RmzmWeRM
	XudkwFDqAyIrv9qQSVEjhfiqSyXc99H+HNs1j0uh7eK+C93RpDgiDQkoTpcrSOfw+rzi4hg5Jcu
	GL1+6k0EbufuRPZs8AqmFonzMe54RLm1Da5nETyFjkZPLrKwdI+dQ8MiJR6lcnEJrY/bAxKH5Y8
	FuVbSfJQ4PGpAhQAQ1dG5ro2+9AYQOAqvyEi8vlSPMz85vB1yAIe0BK/7nMYTh70RNW8pEoxqK/
	bzFeJ7SmrjsFhXsVEY3i9kDFtHsQR6qGBVAtHpcnZxck/McDPv5PPNLTqCQKcbznq/FlPH/acO+
	n5vvHdu7i/eDHtfS/vutNWWouNm2Phuo9KBsVQP5Nbx/qCAk/jD6Xql9ec2C5EzBqKP4AZU/ZCw
	hXIzl1x7d+A6vbnhmpLYCf1q27JHGSYLRp7uzU2cyCIBQejnwgFnfOdIARg/UoJ1dGlugsxzcWu
	V/DsupiXKec59twNtOKWm0L3D/qG/h4RGkNXKw=
X-Received: by 2002:a17:90b:1c05:b0:387:e0db:3fb1 with SMTP id 98e67ed59e1d1-38f9c0bdc13mr3564460a91.42.1785457974396;
        Thu, 30 Jul 2026 17:32:54 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b42d6c8sm1636301a91.3.2026.07.30.17.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 17:32:53 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH RFC v2 0/2] mm/zswap: shrink zswap_entry via a fixed pool
 index
Date: Fri, 31 Jul 2026 08:32:46 +0800
Message-Id: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC7ta2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDc2ND3eKMosy87Piq4vLEgvjUvJKiyvgyI10DIDQ3S0w2TkwzNEpNNlE
 C6i8oSk3LrACbHa0U5OasFFtbCwArxJ47cAAAAA==
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BF5FC0003
X-Rspam-User: 
X-Stat-Signature: 3t83gjhwk8rrg7m74yoi9h53ex4mtnrm
X-HE-Tag: 1785457975-456348
X-HE-Meta: U2FsdGVkX1/rMcsSrQJKIncqfeB7yaxwRAQEs2H8LFLFUlr2olOpit722BL2i7yYxGni+saUEviaXDniiegNUTa8FRKudFjSpwQ4jHb8x2iyvVbLpz6teloXRbv9jU+3xVzHHXtuQ/JBJ3ZTnHf+M5JwvlER6MUpwguTIktH7umr2zNTOrTWRPXIhzI4vmVybkNiq5zwUT9F8/+xHRsG0sB0/BYzHomiJwfUFMto7RJX34GPWvTFpPVknP1yOYS4XtUsSYJgJizggq6WqZgx0/IBTitMnt5GiH6FLze1spFX7w6uRdAGQbA2ro/ixr8gUUIM2cNG4SYYzJC3b3L8t4aOgS90dEdBc5g7cTjRPs27iLJJmo08x0NzSMD/yfUGkBmq9QISQzr2Cbt1YG7EbH+HrKWs2vPbAsbZLe6S1yIEXjRvp4QQRaXXWDdpembS/03oAxQBnkHG4M3d6MYKk992bfUAqFmIzRfbPM+qIPI9/At5EHcRUDKEdHwFeAkso3+leulWbJFXjA6UZ9UjAqBIzgpxYTaCilxAGwn6i5WYNrovIZClbiqhzyBZ6ivqIY6sf0Tp2hSddceLzrKJNbWN7yRbnkaYJRP9yzomm71kDNz/+q378xKC4CP3C9pTiHT6YRFQOPrWMAfr08bqkPAG1aKkfdtb9Qaqh8l/8Gkn+iv3aAoH66u8IWxYZqswBnEC95pdjm2eqsNcytj4MwPLydRv0+uhD9VkA3s4aQYYcCx4iQ+4KBSSrHhZWjnQ1YyTGv9UdfpLfMoYojxT815BGzyFXAXMjAkyTMqf/krCsiFRH7DrgrR4DgZCp+exJpBS1BS6mfC9c8O2vVTOb49BJ8XQeECzHsIixjE/+loV8dJCAniuaAftNlYtfD6f6JblU/6FM+0+xZrO8nwKyCTIn7M2XbnC0oUIjGiuD2Bf7zQ/JU3ueXt9gGs7KwDdmssismWDhmsqhD2+SQ1
 JqXhsDAz
 OVQiTYDC4s0/bdmup4aDGGLb56RzCOKQtxF5KbkWcJk8Pb+b8F17vZkYXJ5JFy+vvnT70J7l06NKwBi885F4lUnrzsCxAF2+QvBJ7AVFprCX/QqXDqDBWzn3jruTWw0fVW1ZsQnL5EYGB+0JnfdSiPrm3M1TXT51evvkdARJ3j9V3MHVyWzNQnOOs0aubPIdNZFDKqeGk31WeA3hX2w+wdCFEiDN7RstLdjmPv/JAatY2ccc9Ua05VpBe+OP1s2BbZ+CGZ5CDNXwesNZZye88vOGGXoURhHhcxkjqiIUuXqcBuT4Lh7SaLw0ObHFu4oBzPajxDTxI2DbDkMTCcDtMLj42aHOqBcK2MJyJNk1H1CtxiqVBk2J6RCJqaSdIOE4+qd+gBBJq9og9ocnp5tRzVjNv5Vgl1g8KfDnqFAy2WXeVrr3aNpZF1zYhoeQxA4dGN3FEzvWBhkyOCf/4GkUqNkcpTd6yFwgFJTRTP8xy8fv/zazRVmvjCSaJz2H80cUeWGkJcXwCQ5mXIFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every stored page has a struct zswap_entry, so its size is pure per-page
overhead.  On x86_64 it is currently 56 bytes, of which 8 bytes are a
pointer to the owning zswap_pool.

Only a handful of pools are ever live: a new pool is created only when
the compressor is (re)set, and pools are reused across compressor
switches.  That makes a per-entry pool pointer more expensive than it
needs to be, and the RCU list that currently tracks pools is more
machinery than this needs once each pool already has a stable slot.

This series replaces the list with a fixed array of ZSWAP_MAX_POOLS (16)
slots, tracks the current pool with a separate RCU-protected pointer,
then stores a u8 slot index in each entry instead of the pool pointer.
The u8 fits in padding after the bool referenced field, so the entry
shrinks from 56 to 48 bytes on x86_64 (~2MiB of metadata saved per 1GiB
of data held in zswap).  Runtime compressor switching is preserved;
creating a 17th pool fails and warns.

Patch 1 is the list -> array conversion.  Patch 2 is the per-entry
shrink.  Looking for feedback on whether this is the right shape before
sending a non-RFC version.

Benchmark (x86_64, compressor=lzo, MADV_PAGEOUT store + fault-in load):

  - zswap_entry object_size: 56 -> 48 bytes
  - e2e store+load median latency: no measurable regression vs baseline
    at matched stored_delta

The extra cost per store/free/decompress is one array-index load instead
of a pointer dereference.  With a single (or few) live pool(s) that does
not show up against (de)compression.

Changes from RFC v1:
  - Drop the allocating xarray; use a fixed array of 16 pools indexed by
    a u8, as suggested by Nhat and Yosry.
  - Drop the zswap_pools list and the per-pool list_head; the array
    carries stable slot numbers for entries, and a separate RCU pointer
    tracks the current pool.
  - Document the new pool-count cap; fail/warn when the array is full.
  - Clear the array slot in __zswap_pool_empty() before scheduling the
    release work (equivalent to the old list_del_rcu()), then
    synchronize_rcu() before free.
  - Use rcu_assign_pointer() / rcu_dereference*() for slot and current-
    pool publish/load.  Entry lookup uses rcu_dereference_protected()
    because a live entry already pins its pool.
  - Add NULL checks on the resolved pool in free/decompress.

Link: https://lore.kernel.org/all/20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com/

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Jianyue Wu (2):
      mm/zswap: replace the zswap_pools list with a fixed pools array
      mm/zswap: reference the pool by index to shrink struct zswap_entry

 mm/zswap.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 91 insertions(+), 28 deletions(-)
---
base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
change-id: 20260731-shrink_zswap_entry_v2-0-0-76ac3af12ec4

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


