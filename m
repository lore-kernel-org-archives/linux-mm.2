Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 376BEC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D40B6B008A; Mon, 31 Aug 2026 13:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385286B008C; Mon, 31 Aug 2026 13:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 276F26B0092; Mon, 31 Aug 2026 13:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF81B6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:48:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 833AA1601EE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:48:59 +0000 (UTC)
X-FDA: 85162300398.14.3390C16
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id B549420003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:48:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=dama-to.20251104.gappssmtp.com header.s=20251104 header.b=w9YkMKWm
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788198537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vU3022IZTIrb8u3t2YTCnTCe+NuA1eT/LdRMgAStZmk=;
	b=EtIB3vI78z1sl6BOBNMRZqJNSdR1PKhGr3Ywl6xBpsA6oZBgf/osEX71aMS4TBDp6GWdCO
	fVjWFMuSZnu0enWrUaAsTTsQtDkLGIw4kzYXUVGEE7+/+UcUYuCnVGP99QVBGseMheGLRM
	p/LoNhdVN5W19Nr/XyedyUdphHePvLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788198537;
	b=SXVNkJ4gbdrNbyMj9b9WYwbE6R/+8ySo2ZxzdhxEzuoNkQrJJwSHTDnMinz5gYR/NcORq5
	wk1eJZ4FqL0cV90m6QJy5YOz0yqytV2z0FmfJmNmL5wm7MJpGtmjII/GA7cp7tWooJgEzQ
	T267cbHq3mBzsIVmxCIsqbcosfqUNmU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=dama-to.20251104.gappssmtp.com header.s=20251104 header.b=w9YkMKWm;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of joe@dama.to has no SPF policy when checking 209.85.216.48) smtp.mailfrom=joe@dama.to
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso40645a91.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20251104.gappssmtp.com; s=20251104; t=1788198536; x=1788803336; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vU3022IZTIrb8u3t2YTCnTCe+NuA1eT/LdRMgAStZmk=;
        b=w9YkMKWm5XIiuQWJDs5LWBlepsLNzbXltPbRUkS5VJ0lZddR2i42iKH03Q2nLaN15R
         z2lmQjfzUOXGdoNKoV0tdHN5F1Oo5/UjuAMKFHs7UGryrn/YRR7otDwo/+Akx/DHRnIE
         41FaIgL/Esuj1b3usBZ75QEBzjoFUgWhAcFQ6LROqnNxAx/5XGalhtxvYPxFP+b7udAS
         9bGA8bp14m0DvjxITJI8GHRKHm5t5VfpVLpWlWBjn4Uy3nTDyc/CRRJwiF2YLw+5aeoP
         GUXzdEmctXzOGBQEthWEywoab2Mau5gtT9Bm1M9rWF9T8L1+bEowCrvJHcWXBZv3ENQV
         IoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788198536; x=1788803336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vU3022IZTIrb8u3t2YTCnTCe+NuA1eT/LdRMgAStZmk=;
        b=ldHK3yBbgWiNbqdf4mivMajtzqpEj0mJMCAT5SsHeCbSK6ocklMBqo6h14jvmFJvvx
         jU6oWPk67b0EPW7Y1pvUOLWCd46Jj+9ru9rIy/S3NgpXDRSH+3b1GsceTEwfclASQaZ1
         qgbSn6lZNLxHNZuXZYXNlpBuNs9v2NIcCjJ4BfUIY9konSB27DkXUlN3NHRj5RSg+0Ya
         XKwebONv1htZu6NP0xjE6ZAvZCChN3RppSGyVsw7c8XnCU5RXaSp0Sjhz9a4C7RWc6FS
         sq7ef9JpXEveQ2vkSLNBSyqoqwXlozh1jo85wloKcJU59lGRDjsg0XBZunN7NLkwjh8Y
         ICZA==
X-Forwarded-Encrypted: i=1; AKwUvBzTpLmBbFA3rOr3po/P26FANMQl5OePsPvatnsH9VLWkT8IdHQ7a5v544VaTGmxVAR6Grc7TG8Ipg==@kvack.org
X-Gm-Message-State: AFuF++mS2ckemOt19uuEb9mE4jwnVhZE6cSAAjJ1gXmwp75GF/AmZHz0
	ybyNUhEOqTKN86cvGV3GlZyUcLtrgJPbZxW2AqTpj/ewowENjmWr9XrkZzx1YvZFq4wKT4zLW00
	J1C+0
X-Gm-Gg: AYBFou2Xn29Uk57Wk3+ANCJFNpVwd2sNeV/9ztJ6l+kEB+K6uuBLdH3HwbNPZjXLj5p
	mUMasU9EQ3rsEbXn0SIUxZ8E7uwxDXcXMBZCnmREaBb8hSVa3I+rGmqHyboayY2fzIF161+uzLV
	z+lGBvgrbew+/FU6YDqJ6NcNU4zOgdMifVwe+Y/4TFC6IMlCeCbi4hFNxaw5fclrmAQXBkiSZAi
	ImPMm0uMQaYw6Q6GK/a3RdHBri4/7YreM0jNrHPDy1ecTkHc/3nm/IJJVXQBH2Yig7cKye521Fo
	iVQAnJdTDrcaxsCmrauxc1HIW+Mbfl90VaNbFrdLnF+6wrjgdPoYKWR8eAgjrUKFqv1TDe0ODGA
	tQBzSkMMXX8Th1jmMwzHryQ6A041p6Ta5Q7c/j0Pfb+FSqh1buMrwRgklrpbrevknq4EPUz4/EW
	tcCAUDPApylxD73mtUCACMxbMETh29i6HXFH+RC1QTSkI1copiy3kY
X-Received: by 2002:a17:90b:6c7:b0:396:6344:3b63 with SMTP id 98e67ed59e1d1-396d0e25905mr43315795a91.2.1788198536190;
        Mon, 31 Aug 2026 10:48:56 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:54::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990c40d0c9sm731964a91.7.2026.08.31.10.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:48:55 -0700 (PDT)
From: Joe Damato <joe@dama.to>
To: linux-kernel@vger.kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Damato <joe@dama.to>,
	stable@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Subject: [PATCH v2] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Mon, 31 Aug 2026 10:48:35 -0700
Message-ID: <20260831174836.3102406-1-joe@dama.to>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B549420003
X-Stat-Signature: rebi3ia7chjtxs9k83o7b13t83gdryfc
X-Rspam-User: 
X-HE-Tag: 1788198537-338405
X-HE-Meta: U2FsdGVkX19QRq4OoiQlMw8o8j9MYfvJvF0fhVqXJ+Vx2ZE51Wd0ySNpF44IYZRfac4isTIvCYbuuq7fLBo0DtamzVxR4CbYp33lbF78J6/gKkNzrBu3EqPAYbsthUwimu1IEUkjIjyB3wvDYDhBDA6AHO1KRRaBLnUy2ZN2doFDnWQj4KS9fvMaa9ssoFNu8pLOq8eV55+OyHHLv04bX9VWBMWlNPWJDUm19WlFmdapgjlOaCu4BNoECbzQp8lDMAvm5KtW/kl8iFrtqg5xvIaBSF4QRt44GuHJCco9/uBa8xeT3eflFavw33g4ZPB6aDQskJOLr+LcGEPGT99Zisp2kyFkxSt++t4HoQEKtLQqUmy7PPOK3gkKAhcgf1fM8GrkM7bnfhG3k0Lui5qlA+UeNPHmQ+S42DxOl33KUkTuVBvEZwNtyeZtqKDFuoQwiaqMTsffp//lT+qkqsdeBaNCKG9r/9MXBAbqYd6/41ZJVQeh0KGY+O6n/RdO0DXg2ZoGVAGjEvaJzNsbA50w5JaLT5ootyvg9dDMmYc9s+AoQSg7d58MrUsIe/LS/Q8d1RYZdl/sFiUgEGv5fTCNY3KQAo2dx0ZNS24tb2tvIUh/ag+6iYlpH1ZVxfav/QLRkxB3Q9HhLiakmnhHVWa1UKKbW6y5XCPwag3rMICXzh7kc0lNxBJtGVzCRo+qaIlMsmFOWUbLVw/0gbMk6uHAB6emxBoxKZu1Y79yUbHtj74WQaqsIYRRLYydoTY2BFjoAjytj6ZsTwIdWAHAwwetzTq4HdXCVPHvZqX1gkTizLQPlWAyjYcInqgh+CfwmmROz+G6vCZvd99X9RyRP6Ygq7sI4i4YNSOSzSG9SHXh/VgLsRgcKJGqzbd0m2Ec8+9w5MyuOSkpvT+IEmS9AZD+lJvLHu4gnQZsbHDtu8M2wzav6JkC9zHEIC7ty8l9uXwg+PA6KfHJJNpXRJ9J/u/
 N8M7gYJO
 jgnr5qWIosQl6wzDu7e0ZT6JeUFPH7A5ZJajIHUturFBymLW+1aD5MmRJSiNkL9RWvLKY8SVk1iFVTo31fasT1W6YLuSdzDQYxJAFExwZPD+Bjkp7XKapAatj4+C03OE9B2YBg9LOt83ct7GftwSRSgVHVQQlEOUcSyuHK/lporbsMqt//jQc+baJsJD+ydEKjmZau6znkOcebfKCqMNVZz0eKowvcKOa2rkHlot7kM/xwAZHcuOKtjRu5j2L9iSwZftvGJyOdP+hdXKCAzV2OMnzPWMmDNYz5jqYvBOBaVEwr1FHFdQ/s+m3MHLK5fp21xbCeIBN/T8WVypDwcQ5uxHgS3j3Zc5ePgb6h9jbt0SrS6qDIesZbJ5+AlbpCde1WgJz4Mhy9v5/+w7vAClOplVCDJ/ROCU4LNhp+NvJD2320EZ1TTSNvzgYNm09MXivsg0EVPg0AGM8pLSI/wiwfobLnaagQ1nwerry
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not
visible in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
enforced allocations") added raised_max_event to cover charges that are
force charged without ever reaching reclaim, but charges that are
rejected outright were left out. Getting an allocation failure without
the corresponding MEMCG_MAX event is unexpected and makes debugging and
monitoring harder.

Raise the event on the way out for rejected charges as well, by routing
the -ENOMEM return through the same exit path that already covers forced
charges. The existing behavior of raising a MEMCG_MAX event on every
charge/reclaim/retry iteration is left unchanged.

Tested with a module that performs accounted GFP_NOWAIT page allocations
from a task in a cgroup at its memory.max, and measures the resulting
memory.events:max delta. Without this patch the rejected charges raise
no event at all; with it the delta matches the number of rejected charges
exactly. A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim, raises
the same two events per failed charge before and after, confirming the
existing charge/reclaim/retry accounting is unchanged.

Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
Cc: stable@vger.kernel.org
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Joe Damato <joe@dama.to>
---
v2:
  - v1 raised MEMCG_MAX once, as soon as the charge was known not to fit, which
    collapsed the existing per-iteration events raised while a charge loops
    through reclaim and retry. Instead leave that event where it is and route
    the -ENOMEM return through the same exit path that already covers forced
    charges, so only the rejected-charge case changes, as suggested by Shakeel.
  - Add Fixes tag and CC stable, as suggested by Shakeel.

v1: https://lore.kernel.org/cgroups/20260827233119.411152-1-joe@dama.to/

 mm/memcontrol.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..158b0562e8df 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2656,10 +2656,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2770,16 +2771,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2789,7 +2785,15 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
+	 * requests.
+	 */
+	if (!raised_max_event)
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2848,7 +2852,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		__mem_cgroup_handle_over_high(gfp_mask);
-	return 0;
+	return ret;
 }
 
 static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
-- 
2.53.0-Meta


