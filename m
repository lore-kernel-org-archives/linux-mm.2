Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399E5C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 17:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12B476B008A; Thu, 17 Sep 2026 13:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AED76B008C; Thu, 17 Sep 2026 13:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92026B0092; Thu, 17 Sep 2026 13:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7ED76B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:57:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58D7A12044B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:57:06 +0000 (UTC)
X-FDA: 85224010452.07.C2BD278
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B07440004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:57:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XnL7ULSi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789667824;
	b=VmhvcDgqKdhr52dOLtyv6jtwbW+vpc3x9c426+dUC0d123y3KFyAZjKWmRMdnp8UDayhp6
	e9L+84PwgeTonTTvEHHwNATb7pI1x+5HaP1dsUPJ252M7mqDyJ5mpyCGBQvdlroQgYNDY2
	oHoz7470dcnboG48WYKf8HKntWgfYzk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XnL7ULSi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789667824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbjWNmPKTP4kQU9l/195vv1JQgSjVzz8hVj2Dw5IYw8=;
	b=s9yfWI6HAod7xYVCdomJlipkutwJsndafsCwDAXV7roJSNyoKUZXEVc7II008HfljEjrsO
	BZaHQAxY5kkk6yoB+XILjMIVrprkgzIzM9pgEgAKOctQDurv/4DNR6vB9PGdN93CC+Bmxv
	uzv/LXcroaMDyTZl7SABisQEEVOzwck=
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a3a9768so960641b6e.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789667823; x=1790272623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbjWNmPKTP4kQU9l/195vv1JQgSjVzz8hVj2Dw5IYw8=;
        b=XnL7ULSirB0kx0BDDnyVEe1lDIolQhiyxtlE4KURbYcMJzq6hXY4jK6fImkIS+X/ye
         smxPAFcZrashp5OsxCAyLLmR0AiwTQTsfdADzc6m0NTkASr4o61w6g7QADEqDAphzJTT
         jxJSH+Qfvl5FIpVyxb7xFoWfQ5lMOFC4SilKt1S2c+pa8JvLzpOqjrxWJT2a6pAhuppn
         5qFPSJqVrNLqbk/6bZnoBDnruou7sIHb+sGYl5Zwk95TxXOrc5zYpdTIZZaTsLrJKDtS
         tEW7tl1xVFQY/lFeMFOWiUyeW8w9s2mOIZIqkheXjTizcwUA3WgnLyuE+pQWzra7YcBb
         JURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789667823; x=1790272623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vbjWNmPKTP4kQU9l/195vv1JQgSjVzz8hVj2Dw5IYw8=;
        b=mY5OqYldrvVjxIxSlWe/qBeD9+00xD1tGjLX3mW0WTlxZdnaemVFHdO4XyAChD4jv3
         jIv0RhfQjVd59d4dP6rw04PX/vnOatqZKb2J49WCkUkLntVzOxGEHNhpvuFlRVhoOQi6
         r+xu+m5rXmLJU3bgiSztWTef7PYSqV/VA5C8x2ZJo5NwvRd45IIJvAIuhGRJM9Iwzw7e
         zkRwFpxP6Csb4558cw2U2VSdRX3fUJi+o9/MZ8Hv2vOlE2FDUi+IrVQ4xLpCQsdZWo+X
         o7MEsLEdxf1jCXfKvO+dBtqetHwTKOvFgKOWQAd87/XoEBnE5jZIcnnD4/LOlVwvdwtj
         yigQ==
X-Forwarded-Encrypted: i=1; AKwUvBwcRHpmSIZi8Ly79VZ53zaATeeJUpmm5BrPgDJOKLvEupkgiu3ruX8ZOZXB1otIcs3htC3qKWaiJA==@kvack.org
X-Gm-Message-State: AFuF++k0j4vf9q2JDNnZVqWFekLkWGhb5Uak3FwPWrCoKsyy/ZMRnPle
	SP8vxjq802m98etwvcPADxQdD95OrqROdW66Ghbf+uWZPHqXrHd2Lp2M
X-Gm-Gg: AYBFou2mdM44t2PfbB3No+K6M7VLgaf7zMuj58k1QI7KgolbZUPSE9BcUC/P3U2MXb2
	54RRrmO1wE/Uhh2Xfa07kiBWN5+dWi6PMXTntuu58FbQBC0sPgR1dIXLILiU8yb+RhZrPlf7AOp
	4WUnL4k0U/o1/ETAE3Hwd0lkUF0r0SwYbM2N+09mhEuj44ZydJrRbw7S2Z5NY/Ik4IFYgMee6S8
	Fyvgv1GuatGPUaNst799t39ePrvOMXhD7uT07ffVqd186GHwwQOKQ6JdzA119nlv5y/aZANiVA9
	z1yPxBh/NZiSpZmxkid6b6kgTq8N9qRvCQHR9GrxDLTnf2q8B6/rlC5i0njyN8VeTiECGyWWBzA
	2unnYb31wmbITH1xqXTnnWRPtMKArIwrrnkwcF/45y7ysksCBm4Ues+JcToCZSSM3XHCCSlhYcL
	7oUHNztHYv9IuNo74E2A3fc/+yBW8LavVW0apU4IC7WhjGoN2W/PQmf1qEenuzP3m8xXf0DIeid
	xoUu+bjD5Eo7oGYsyQU1I1qR1/syw==
X-Received: by 2002:a05:6808:5190:b0:4b9:e5fa:8906 with SMTP id 5614622812f47-4ca4b643e8bmr7461249b6e.25.1789667823338;
        Thu, 17 Sep 2026 10:57:03 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:23::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6cc42831sm3206625b6e.7.2026.09.17.10.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 10:57:03 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v6 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Thu, 17 Sep 2026 10:57:00 -0700
Message-ID: <20260917175701.2343946-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916210552.891730-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8B07440004
X-Stat-Signature: sirkg9xdtqoq3yjwefm91w5c11afdufj
X-HE-Tag: 1789667824-584770
X-HE-Meta: U2FsdGVkX1/uQsSssHUWlbiKxm+VZwN+OrSvrkDWY/IvxI+lS6A95ItI1eSAtjXXrfjDDKkKA6Im3pNa2av1vXc/8ugMZKb9XB8SpUi2ZvXV8WFlaJkzOR4YqAOT4R0o1RkWRBLokzrN/EtIPREfCkLBEz5tq491ifa1w/cp13x7VzNRj1t4bGTp4JUo2xW0jOtwCoeSQEwx5EnJhkXlteWw1fqhEzj95hywm1kBS9nqWbDPDHMNLV00MMtrFc64Gu2DpxVvklvxHF/cY4ExlzC4vtfi+oeYomCk/49To/PKqMwZxPuG4k7Bgzfr+CljI18T84kShgOd1Goghg/zuiJrtE0N2Tcx7CBvwh4bu5IFkKYW/ROTLmMTu9v38hiBaGLG9HF4hqi7254PrPUoUcJS6UMfNsnNS23Zk3HVEirc3RfH/K5H7QFpyMKJLeEdBBkN6QI0/vTNkv3IJo+nd+pp2M2yRYoC7OXxzcMZaSwZ4cp+iEYQawICM8ZUp367bPf2hFDHGGY4Zpi+A3NMqU7Y4LhaUpBlQB4sOTBJA3JfbRr2GdykVRIx7NIxD3mNG8hFtcBlwJrsNfWkjdi9FR8sEftf/EuA0+uTZIiSO9VYJOIPtZZK8t0Hb67i5GuXV4sTiXl4DeVXsRtn7baZLkLKTyw/Zsywea6InN4IGByg1/NKBNU4Wnho3zW3BuN8dyMXpsfSbH5LZuW/uAqjQ3Lq51J7DjNm1BQ1NvhMUyWD0O/hCc0i20RPUiciHxoKSPxcy0B+LET14kyyx5tHpLoKGAbTJvrHLdy4wy4YKbqiWTYmmt+7CA60At7sSpKs4AEPpLp81iQtDZZLe0npiuKjJ85MtLYNjAhrQN9kRoIT9MMJq3Zlinu5vB4uqHQ+h5lTE3JaSlO9E1G9FFbX7WIJzptmPYe8u/5Hdv+QPIhY8k4MZ7ENnp/Z1VH5E2MZtyhpc8BK6vqHAMoY1ox
 mau0rcSL
 xvDN+VR1WMuOvZfnhocYPGjZ0nGfRPjSZ/5CetCRBdvfNQojdxyLh8IO5X+WqH/D65xMf+u2sCUNV+t2hN7rqatjlngTzaUZN2kylwWWWgm3wMSd5nFWDn+g3A9U1Cd4Aa/6Shm/5idvW0LDtwsYqoeeGCKY3wh7de55dNhXkSe43w3NHTpRzv8aUMC20TiAO+kCDJDmW9PhtE8el8hnEjJeOEryTM2ylqRg/O8LM87IPQTmRyN0O0ALfDM1Jj51Jyhl5W9K0P+qv1BppkAhv61TFomlRyipB+12KLlRrVSfGUI8y1PRCj61V5GN+pdATQzqTUEbv8VEyPt+5Sx5tp0Uw4UxTPKqYLfbAvIBi0NsSb/43JwVav94wI5tN8IKypt+qR+va1jiLvnbU05HTjGMXqaOtF4IyjMbbdbCcqB+AXfK8lrBaLBzpA4v6FmIqxUwMveVISZtu8wo2v4DbuB6Lv7/ym8eGM/M/Xb0e75kAKwJPo/eZa3ML1sVH7NGcImTi3A3+TCpFK0eKZxx4xlTOjtTsWsZPVNrzo3sR51Ib9YceXArtt16+q6ckIlCpdCAzV9iu0THZPtDdviHu11j0Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 14:05:46 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> v5 --> v6
> =========
> Following feedback that v5 combined the (1) stock abstraction move from
> memcg to page_counter and (2) changing the allocation / draining
> behavior, v6 limits itself to only the first goal. It retains the
> existing seven-slot per-CPU design and drain policy.
> 
> INTRODUCTION
> ============
> Memcg keeps a per-CPU stock of precharged pages so that small, frequent
> allocations do not walk the page_counter hierarchy every time.
> Today, the stock implementation is within memcontrol code, even though
> the operation it caches is a page_counter charge. This makes it
> difficult to add new page_counters to a memcg and preserve the fast
> path behavior.
> 
> This matters for future work like my tiered memcg limits series [1]
> which introduces multiple new page_counters to memcg. Without making
> stock a page_counter-level property, it means that every memcg charge
> now goes through multiple page_counter hierarchy walks, instead of
> being able to cache these charges.
> 
> To make future page_counters scalable and performant, move stock from
> mem_cgroup to page_counter so that each page_counter can opt into its
> own per-CPU cache of pre-charged pages.
> 
> We get an added benefit of simplifying try_charge_memcg code, which now
> has all the stock management handled transparently within the
> page_counter layer.

Sashiko raised one bug for the series:

 @@ -192,11 +245,20 @@ bool page_counter_try_charge(struct page_counter *counter,
  				WRITE_ONCE(c->watermark, new);
  		}
  	}
 +	if (charge > nr_pages)
 +		page_counter_refill_stock(counter, charge - nr_pages);
 +	if (nr_charged)
 +		*nr_charged = charge;
  	return true;

 failed:

And asked: Does this unconditionally report the batched size to the
caller even if the excess was rejected by the stock and uncharged from
the hierarchy?

---

This is true, but this is already the behavior for vanilla memcg.
In this series I'm hoping to preserve all existing semantics without
changing behaviors, so I can fix this problem in a separate issue.

Specifically, in vanilla try_charge_memcg:

done_restock:
	if (batch > nr_pages)
		refill_stock(memcg, batch - nr_pages);

...
			current->memcg_nr_pages_over_high += batch;

So I've just preserved the exact semantics that we used to have before.

The problem isn't that big anyways though, it's a transient inflation
in memcg_over_high and will be wiped on the next high handling run,
and there is no effect on accounting or permanent inflations.

So I think this issue is pre-existing and a minor transient inflation
for memcg_over_high at best. If this looks problematic I can write an
orthogonal fix separately.

Thanks anyways, Sashiko!
Joshua

