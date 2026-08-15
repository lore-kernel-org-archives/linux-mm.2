Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3ADC5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AD586B0348; Sat, 15 Aug 2026 02:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E196B0349; Sat, 15 Aug 2026 02:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845496B034A; Sat, 15 Aug 2026 02:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF4D6B0348
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:54:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB5801C0FD4
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:17 +0000 (UTC)
X-FDA: 85102589754.06.F63C2D4
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BA6A1A0007
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:54:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bnFCSzkt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786776856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hURuDThF+kvxKo9LZkdm8ThBYz8dMkZbE/Ix3/2UsHo=;
	b=lBdl7bhky6UVvYORTNf831Ct15g96KtHJyRqij/AN8E25EmFLtM4Caw91O+79Sr+Mn4TAb
	wslANI6eUeVky6lmc6LMiqx7oMoBvXkCAnBpTN4AfrbwllTI/uv7r8w/It6TY9Q0fcD4uW
	00NYlfQZx1eRw/lmYty4Wj1EqnDzRpQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bnFCSzkt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786776856;
	b=wCuBKb1l5LAXEna7mKH+CHgwWXbkk7Ezi0XmaTvDZu0kgJStYMhxtk72NLxAGY8YUx8OZ5
	Mwp5NmgAnDDjN4/nuto8OIehIKhhlLkVtihqJ/RZgGlN15DZVozHcPWdaVvmncwuLGclbe
	9u5W5PvmBY9U1dLlVTaOWwbK6JtDJVg=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e347638adso2153469a91.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786776855; x=1787381655; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hURuDThF+kvxKo9LZkdm8ThBYz8dMkZbE/Ix3/2UsHo=;
        b=bnFCSzktn/4ACmnARtBm1U+GLxxr8wCKZMF3S72TeDdyIKtdWe6Us20vmXVQSlotM8
         QnNGTx85wyL2H/w4wzUNkHvtF32UflkXyE2FHPW4sWrSkRlyKIIXraAUNclj2+zoGPlX
         UYWYyPckty0AetNrFReMMlmvf2x9UJKJzNiMBeo45qS4PCZPgSWvjg7w3UeQ3YTCRqUJ
         dzikplUi3KQfVsr9GRpZ2/Y41wehayQW9PgKDZ6cWdMk5tk/1/QFdXv3hnd84qNZhgLz
         1fVfPtDODzHlQgfDLpJ9YBljSMK7nBRo6bv3fjakFuMPSQ4/aXDIXl4wr/pMJF2NGYOR
         8/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786776855; x=1787381655;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hURuDThF+kvxKo9LZkdm8ThBYz8dMkZbE/Ix3/2UsHo=;
        b=nKJuqXjgGg8mGD7XCjJYSTaSHDWM7MzY905muYLspK+m0ztUprQ9x74t67kstGlpyP
         KDbEXTKHa3eHDsJ2GeXSIQhUHg1sEXwUk7SZ5V18T+6Wrubzjq0Sc9bsv8rZf+Ro85mo
         i9ZaTlZgm/zCr2V0Mj7+Xlha/lWK2vfaCE4IAvR+wdOVRCadJwd94BCDj48m1kxLdCVy
         qSm4uzpevoaYft95jlX1Qdjr5X1iuYKpi5w1R/jIMuvP9Qqhd8jVg4WwdJhIjQWcu2+q
         gB8OLDpoPtAzs6V9L1cAPOYuLnGDT9Y0WmEEi0hRQ1jeNcP8OnQczcbDhJiq7nTSlLdW
         GObw==
X-Forwarded-Encrypted: i=1; AHgh+RrAaRgMJb1sZfT9iIlx3dS7LHOOSQ/Qb/V915pXNpMBcn/1YlWOBM/ayCvpzMXDpgDayJwcgG12Yw==@kvack.org
X-Gm-Message-State: AOJu0Ywtieuds2889Ew2YVLjPxspGK2CzujbHWB6O393WDA0YgrGkRFe
	pXgCz+mSw1ow0WTD4fmonuPhkS21MFuRfWo0FkiX45rZ0AlilGOjiBfd
X-Gm-Gg: AR+sD13GWs7tsi1HTJhppAvH8bsFYPU/EwjFbxqOgHpSDGrzJBhJMLR9JZtx/unaykv
	r+z3xrcYtiVZe+2kB1kx7x2nSLCqOmgiiMvFwachWHvj1OaKGS9sbDkCMhalalnfX5IBV+5GrMc
	GhKstgl19Zjl7CtNblP8gEZwe1pQskp5k0tkAAclUTk277jAhQEZzIVcCSjcpvNJCcMs5iMy9uo
	C3j7wTdYRWCd+jsXD5xorH7xG3LvEnZZ/RgQB7qzi1NUAlhmB9n8AZRH7zWBCNabn3EE7sdoaOO
	qKsnIvXrhwN4Rm+or920bB7+MsoFs7Wl00e6iZnat7F2yW2yPWm+3i2yh2RIlQNfg5CRraPaXrr
	WxxUzi/e/b0GPSmOq2Nvp+sepWU92JED5b87miI936Ni0LJENS/n/jau/DFu6RqakBhVNYUTYgL
	uq66IMzrreAZ+lP74mVukO02ZX1aLyTKlB9417fSSV6ptvVZACLY42sHGAldtkwUeJ9xVTPikwE
	pxDmM7JWvDll/k8IkTKBW8PFpQzpRYdS7wayCtzbhSc
X-Received: by 2002:a17:90b:1c01:b0:381:a766:efcc with SMTP id 98e67ed59e1d1-3933b8c67camr10585706a91.14.1786776854821;
        Fri, 14 Aug 2026 23:54:14 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-394eb752fe2sm5691360a91.14.2026.08.14.23.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 23:54:13 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH RFC v3 0/3] mm/zswap: shrink zswap_entry via a fixed pool
 index
Date: Sat, 15 Aug 2026 14:54:06 +0800
Message-Id: <20260815-shrink_zswap_entry_0815_v2-v3-0-0171bd86a667@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA4NgGoC/23NwQrCMAwG4FcZOTtpm7kVT4LgA3iVUcpWt6BrR
 zumc+zdrT1LDuH/A19WCMaTCXDMVvBmpkDOxoC7DJpe287k1MYMgomSSX7IQ+/JPtQnvPSojJ3
 8on69mkXetlhwLkXBS4QIjN7c6Z3wG1wvZ6hj2VOYnF/SwxnTKdkV8n92ZFmctEwlmEStZYXFq
 Rs0PfeNG6Detu0L6ezAw8gAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BA6A1A0007
X-Rspamd-Server: rspam07
X-Stat-Signature: gou5ximcxo4p6ggwq1fcbpdaut9rar8r
X-HE-Tag: 1786776855-996494
X-HE-Meta: U2FsdGVkX18orPRMUdsTW1An+LGvSDqdO/BfrSU7XAGoBQkPqh8KsLs2CFKcnHDoHNUqYVzVBOtE+ycRmbnnIK8PAUWnwc6wppxnctIqqSpyg/YNAVXZ1k1Hjl2P5fobBEFNRstcgnJ/PDaeIoVqIKcDJ+MD3PrumBylpaTPN+E7sXsiTUU0kwFb2XdViuRp1ALgBLIYhvgLT9DJGlJ2zS7CxUuS4VAXdh/kM6seENOarDpAW2EiVzhg097a4vnUzbHMPxukENxMvTtecFBxzn7FRFtYfYD4D0tQOr37NnH9F55+M/18ai8eJ4nAG+ZeKsnV1PAfzb9HLlBKm+Tw/kHn90F+IwyjV+c6v9v5vVQuxMMpcjGxIWx13eEtmhUZuywKs24kwIvrwXhVVW6tWaaauIRhYLWYcKIyIyfIPnEgK43oMcAihmgaF9GJ5hIoCLEJ+Fvfgi2ibtxyD8GpF9+e762at9LoClBKKsqTD8mENQllUjpKPqORzbviKt3gR+xYPBjhjIV3Hv+ooESX6xvLjGhHI3xC9owOjgciP2J6gVKErtjEt/NmuGJYLeYpxy9+vaStzHzoyCz4bXiZCE+EgUEwAKU5pNS1qgMtE9oMycrqucyGsCSjZv+NOhzb4CZrNWXLh7PYQ+ODH1LFvMzesgv4Hl9tWO9r7MRRQw2FnzY+QgrcESKniZ22Eh6isNJySvN5III10R9+uEmmRX6TeItDT8cmYR7dkYxBF59Bb4eZiq9my9UFOKy8NbP3hm1jUYmF78TBGjxVXus7qMCMu6ezHiVWxjvAFDFnjhVruC2k0AtBOBsQNVi761yi1NESbzbmeUcN4z/GiTjoHe258cTShVmDc+RTo3osxleDcnFfco/D4of0QcyZIVBj1E4oe1QaHc7znHbgMiRotA9dg924AQ0lzdbNbO6G9/QQMYe2P+7HWDJ9f+gwTjymLkk4Jy3is7A7KIzs07y
 YdGKvBKx
 bbUFPZ4uSs6PRrXem9YbVEBTm0b1zuLZciYpBMK2+MUFCBH7TooBwDrfM67WhrB8EOm8pwtI5IdmbqgZ110o4aSPNROoaXtjYlBwn8Zj+Ja6CmMJtM4FTn55d4OYwe9NmHH9xDiuj0EsTODISnpuuzc/BUvL6is4O8DzIOsu+4C1wPVqhbM43yEjnlD+7U0UZ8uIxifYpfswMyXKpG8Sq99Q6Q5Vws21lmlf0C2N6U9Rp2l09zoi0Oi9TgB3HpoGIC1fozBH5pUBngHmE68Necrz78Dapqv/3R6HrpViMtSTA4d9dHDVyzpFrJJcXjH+EC2ryOwTTTQmd/SJjBB8BxNUq7qk0I+6MB6vhDQ4dSZLXlyhaDtQdz28JszlFEWlWTFmDfwjjy26MIQnALUOnirIAwl0YUwDaqaoXvwP3afw39FDjHRyG/eAWcIrdDLJfCjvZyDae7i15do/MT32uiRV8CrxAUt2MvJ7pj0Z7GuRYJGws2bayLarnlSfQ0IJt9bRWyPU9YOwuHSgR6/rNe2JwFuJOxXJtPkVPh2pxy5QXwb0iaRRZEKRL0VAzXO4m7lNxkautcTzEPQ25kMxwNJco1FIPyhS5/S6qcp5sQlv/zieknKHOufiysp3Kq39eZlzXG6sv2eXxs05+RsdvcYEqD2MHrukSK9br
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

This series:

  1. Releases retired pools with call_rcu() instead of synchronize_rcu()
     so the last put no longer blocks on an RCU grace period.
  2. Replaces the zswap_pools list with a fixed ZSWAP_MAX_POOLS (16)
     array and a separate RCU-protected current-pool pointer, giving
     each pool a stable slot index.  Slot 0 is left unused; create
     first stores a RESERVED placeholder and only publishes the real
     pointer when the pool becomes current.
  3. Stores that u8 slot index in each zswap_entry instead of the pool
     pointer.  The u8 fits in padding after the bool referenced field,
     so the entry shrinks from 56 to 48 bytes on x86_64 (~2MiB of
     metadata saved per 1GiB of data held in zswap).

Runtime compressor switching is preserved.  Creating a pool when all
usable slots are full fails with pr_err (15 live pools at once, since
slot 0 is reserved).

Benchmark (x86_64, compressor=lzo, MADV_PAGEOUT store + fault-in load):

  - zswap_entry object_size: 56 -> 48 bytes
  - e2e store+load median latency: no measurable regression vs baseline
    at matched stored_delta

The extra cost per store/free/decompress is one array-index load
instead of a pointer dereference.  With a single (or few) live pool(s)
that does not show up against (de)compression.

This series is based on akpm/mm-unstable as of 2026-08-15
(e737cebb8de0).

To: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
To: Chengming Zhou <chengming.zhou@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes since RFC v2:
  - Add a patch to retire pools via call_rcu() instead of
    synchronize_rcu().
  - Reserve array slots with a ZSWAP_SLOT_RESERVED placeholder and only
    publish the real pool pointer when making it current, so find_get /
    total_pages never see a not yet published pool.
  - Leave slot 0 unused; start allocation at ZSWAP_FIRST_POOL_SLOT.
  - Use guard(spinlock_bh) in zswap_pool_reserve_slot().
  - Replace BUILD_BUG_ON in zswap_setup() with static_assert() next to
    the pools array.
  - Use entry->pool_idx != 0 as the rcu_dereference_protected()
    condition in zswap_entry_pool() instead of true.

Link: https://lore.kernel.org/all/20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com/
Link: https://lore.kernel.org/all/20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com/
---
Jianyue Wu (3):
      mm/zswap: release retired pools via call_rcu() instead of synchronize_rcu()
      mm/zswap: replace the zswap_pools list with a fixed pools array
      mm/zswap: reference the pool by index to shrink struct zswap_entry

 mm/zswap.c | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 153 insertions(+), 34 deletions(-)
---
base-commit: e737cebb8de0d38e8f64584a8bbfbcf9176c7537
change-id: 20260815-shrink_zswap_entry_0815_v2-dd3411824163

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


