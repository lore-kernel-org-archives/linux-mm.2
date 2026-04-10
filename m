Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 408B1F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69496B0092; Fri, 10 Apr 2026 17:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA48E6B0093; Fri, 10 Apr 2026 17:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBA1F6B0095; Fri, 10 Apr 2026 17:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A809A6B0092
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A8C0E338B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:50 +0000 (UTC)
X-FDA: 84643883100.03.59551B9
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id A866240005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BnhprXA1;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BnhprXA1;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855268; a=rsa-sha256;
	cv=none;
	b=4ifRkSWwPeL9+oAFkogWM28IDZtyRLiT39ALL5oiTG+cZZykER3HvJjvOtVLpi8wP3K9jt
	eqpdxM5yMi/93HxDm5pj+f2a9HpzLDqTcCTRqczjk6JeUSttwW4+DWO7WR3p1axldUh/lH
	PxqB/hUbD5Hxsyc3n6qWN8pSVNPIp70=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc/5SAW/hlzwTRYBBK07KZ6zfX2jO27FY+LfQ7kQsVY=;
	b=8r955HsiUNsn6Fy+s9fByfN42qZbthUvViBjw4ptK1uD+7taaC6CtzKkXrXWud6HpF0/TX
	5NLuhgYeJqimgb0Wsm0qKBlNQiuolyQBdvEmXnvTXuhDxp6IJGIGJR51rwayIWQKkAqhrU
	EvjuEFKRqctItIWihONNVgOp/WWnuSo=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7dbec19732eso2301796a34.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855268; x=1776460068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uc/5SAW/hlzwTRYBBK07KZ6zfX2jO27FY+LfQ7kQsVY=;
        b=BnhprXA1OFUbm96b5/lyuzT5dnNmn4mkew8mDdX9RVNbPrtcuRilGU4junzgzVtiqO
         RsnKBysarCpcGDxXLclw3pfByeQdxnb+ZRkoUNFEv0am2p/u2SRW3rJE8xKMvOHav4rr
         n6f8wgYY/q/icSlYHtpre60HDkSiV2jbYxEUKQRy2E8B2SrIogXJiJp1DkjLFZblGjfq
         5IwukGVuoXIx1DUgfZQagjylIVoz1RvaPLZZq9Ll2q1cMtxJ48cfoU1gmxshUq6TtREL
         KSHlvI+NnC8JUF07JRvDdvmSycgNdQwcuKCaGWGZpJU+ALnedt2fsBFnafz8ZtfAyXgG
         6DLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855268; x=1776460068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uc/5SAW/hlzwTRYBBK07KZ6zfX2jO27FY+LfQ7kQsVY=;
        b=kBZgqqli0BLGP/B99JVFhLNlmgcrrCJ2LnP6kbupfsB+4pw9LhLlYQJjoH0tBFl46K
         OQaJYA2UkBZ6oglyFdkXuJPoq9wAvMWcW5eDz+Uh8vAdRtMgwP2WswFv6e/UCch6tbiv
         kBc+JrAqkgz05VYGBwyFZlmscnM0Vzz1/mu5HS41QS0Zlh6NYiB8PyTHUFaSMz091iEG
         j6yodDb+FL9mFDoNit5jEbVtNHU0TZTJP/wsO7YEwdiYvT6M1i0/lJh6SRCVk0fUSObR
         xcwl2iT7LOmoW4k9B62QLAq5zju6upGmPvho/vrNGQMtQpCSCnihUOwsNcLF5an72SD6
         dwoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqG2pDaRV66ih8b3T1it4lrKjDmi6ZwLIsAr3DPR+/WJSuPQmin+N8RCCufgb2Rc1FxFImPEZx+A==@kvack.org
X-Gm-Message-State: AOJu0YxzfrTPlgXdUnawG+LEDclb9Li7OYyChB9BvSi75Jk9vIVwddTq
	9YrzldvgIPdVzCgIjjJC4l9bqBF5WE/aqvAsnnhUfiTKDlziCkgrBam7
X-Gm-Gg: AeBDietQQuR8uyIEFVJKk/HZ1g+3Eu/SNZbzi3rU1QCsqTqRkM7dvd3YpxlzTHHOO50
	QzEhlkq+gxQNgJAJQ4xzKQeoonEddpGKx0S0sAe3/BGM+tjv+EIEugehXHnSANys0lybM8iQMB1
	K3Kn/EUYziNWTabKcdE7CMAi0ycN3NOpLH6wdTuIRYDfs9do2L/W84jqeiQDdMmvTBcjy4IEvFH
	M3WLAlDDu1qZGOU6q4uUgeCin+3XKDzo7ieoZVZYD/DDOvVriyjrE/e85ewjfxIndLa2NRnvfZr
	46pkGxNvOATT4uuNHeFi6na0ErfdQQHjgsYwodjQAgfMdDAQpbRl9pOKvcrieSNc64Q5tPv3cvo
	zt5yaC/NGIC14O5teFM+Y1iR9NHivwxUZBOk+MPjN0x/loR0s6fP1PRq9/6apmqwjxzLSUXZHgS
	vyold7waOsg+H9VGI6TEUa
X-Received: by 2002:a05:6830:81f7:b0:7d7:e844:7f4e with SMTP id 46e09a7af769-7dc27f1ca2emr2973075a34.22.1775855267769;
        Fri, 10 Apr 2026 14:07:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc3959099fsm214769a34.9.2026.04.10.14.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:47 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/8 RFC] mm/page_counter: use page_counter_stock in page_counter_try_charge
Date: Fri, 10 Apr 2026 14:06:56 -0700
Message-ID: <20260410210742.550489-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
References: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A866240005
X-Stat-Signature: cpto5we5nrkkhwogm94z1a4jb6yzbgho
X-Rspam-User: 
X-HE-Tag: 1775855268-7393
X-HE-Meta: U2FsdGVkX1/t/MNMmK7GcW4U3LEKZPeCcE0aGov23tIfIi3hbMYdiVmuHmzm5bvebkjSF34VPlgVRvqn/s4m/dRjPxRbk4SNME6RSrzslT3J7MNWDBRg+iV1bXYEZX91lyT2THXtiQHhnsP4r3HvKgin9QQKMuXL21K9CBRAwb4MeBiRW1TeNIluO5vflJKcUSex4qZbja0IMGLStqUA6KfetujodYTNn4HJaAiLl2stjQqCVAkqPPcW1urAPmRC5d7HAbtmcZIHltJL3WOY2AMjfQIxVN2+yFfthhPzsjbF/AKfhbojOEQOydd0BLlxqRe0SH9SRTMJrae/OPbwRKyWczPAXTa5g6WmzY69Kev7k8cBPgq1bPXMlTlc8Rb/dFEFYzjYUo7womQPG+44iVDwvVk9hK1tbPSYKTrZCjTOHeasT0SYG1NqOgAREeJRHTZiS3Xhk291KzXYmgKZNhbvKGhaM+7KcJ1b3MMAtdln5GuY6RpiNq6hJaiiT7Y5U6x2uNKykmDwmzzO493gFb70ywgvpdRsFLvqOPRYft/cX/Bgwzq0z8ct7SJMqiT917G99EzirC6u96/pMt09xV5ea1tCBiPJgo/Ym26V6cN9dT5kpghMp3eqYlPv1bETxpVvsKsDjSjT2mik9RmkwxsPO36kpnBaWWJNtBNDBE5CFTCP37KlFYtFlom/pp+8kOtnaq+kvuYX1WsdfKwFay31mO0kF0j/IpCOay4AMpB7yc7kYMrDZqmwvzTZ4z5+UeEt7+lver/eAqddhsQVTO86Mm1an6yIROKhHmxyYSk0V9yzjY3pF76VRqUnvlKK2xl+CiwSkPfnZ/gv8eG9mag3109D072IKimI0yjX8F4JJMj5UhRRVqXFQrMmERCWO3/ltDTkWYgSec5+UDX5bgO4BMJ9+jNTQjpMx9SimOQiNKtTZ+ZOyLBFeBCVNKqm+yr0qj/+WhEtDnug4UW
 KBkH5UwV
 u9qPIeG5nJ8j50oe43A/A5x+c04od4G/HRpDmn6f9s7mYYurBwziwyWwRIDEXwZHJXAnPYvPbGGihqlbrJxnQT24hAebS3SYC11AUdDqXReJbwoBl4R30b6+vwRFQYzwG4wLZw63++eXmQ7TmyzbbuirrgIDXT54wRmpBqNqBMk8L/57YheFat+BzJLdMkMqK4SYfzOTv74DoabbKja8bC0om5/g4fVQ7QDBXhIgwXbk0OwclfGuGSQMw+atuxcC2t6Tw7XR9LQvgBI/iroX/3uEsVxcWfPnkV4+FOaT/FQ1P8/TjZDMnCHwKRJPlqyOCLGW4fNrKGJ7OCnU3ZNa9lRaTUUYE4hJ6ly4USBhydak1TVdlx3GdNvKqQdllfpLhLw5k8b+mfjhCEUdyt5cB9cLPZXledjYvZZHETewgGnGUkhtoxUe1s9+73ZZRhq8BdUBn1xjjoRraeZVEzgjmcWhk5CndXWA3v6ueqj6+3GzHhl6jULNyvIQqyx3C4LfZmLkix1fHpgKG7mKBOBgKnc8H6yz+1YmmEOhc0KYbzdHlec2sXWXBnxloPbcvdfmJAdPrR2pVxpvo+6akcm62IGEaPHXb+zAFnKMe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make page_counter_try_charge() stock-aware. We preserve the same
semantics as the existing stock handling logic in try_charge_memcg:

1. Limit-check against the stock. If there is enough, charge to the
   stock (non-hierarchical) and return immediately.
2. Greedily attempt to fulfill the charge request and fill the stock up
   at the same time via a hierarchical charge.
3. If we fail with this charge, retry again (once) with the exact number
   of pages requested.
4. If we succeed with the greedy attempt, then try to add those extra
   pages to the stock. If that fails (trylock), then uncharge those
   surplus pages hierarchically.

As of this patch, the page_counter_stock is unused, as it has not been
enabled on any memcg yet. No functional changes intended.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_counter.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/mm/page_counter.c b/mm/page_counter.c
index 965021993e161..7a921872079b8 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -121,9 +121,24 @@ bool page_counter_try_charge(struct page_counter *counter,
 			     struct page_counter **fail)
 {
 	struct page_counter *c;
+	unsigned long charge = nr_pages;
 	bool protection = track_protection(counter);
 	bool track_failcnt = counter->track_failcnt;
 
+	if (counter->stock && local_trylock(&counter->stock->lock)) {
+		struct page_counter_stock *stock = this_cpu_ptr(counter->stock);
+
+		if (stock->nr_pages >= charge) {
+			stock->nr_pages -= charge;
+			local_unlock(&counter->stock->lock);
+			return true;
+		}
+		local_unlock(&counter->stock->lock);
+	}
+
+	charge = max_t(unsigned long, counter->batch, nr_pages);
+
+retry:
 	for (c = counter; c; c = c->parent) {
 		long new;
 		/*
@@ -140,9 +155,9 @@ bool page_counter_try_charge(struct page_counter *counter,
 		 * we either see the new limit or the setter sees the
 		 * counter has changed and retries.
 		 */
-		new = atomic_long_add_return(nr_pages, &c->usage);
+		new = atomic_long_add_return(charge, &c->usage);
 		if (new > c->max) {
-			atomic_long_sub(nr_pages, &c->usage);
+			atomic_long_sub(charge, &c->usage);
 			/*
 			 * This is racy, but we can live with some
 			 * inaccuracy in the failcnt which is only used
@@ -163,11 +178,31 @@ bool page_counter_try_charge(struct page_counter *counter,
 				WRITE_ONCE(c->watermark, new);
 		}
 	}
+
+	/* charge > nr_pages implies this page_counter has stock enabled */
+	if (charge > nr_pages) {
+		if (local_trylock(&counter->stock->lock)) {
+			struct page_counter_stock *stock;
+
+			stock = this_cpu_ptr(counter->stock);
+			stock->nr_pages += charge - nr_pages;
+			local_unlock(&counter->stock->lock);
+		} else {
+			page_counter_uncharge(counter, charge - nr_pages);
+		}
+	}
+
 	return true;
 
 failed:
 	for (c = counter; c != *fail; c = c->parent)
-		page_counter_cancel(c, nr_pages);
+		page_counter_cancel(c, charge);
+
+	if (charge > nr_pages) {
+		/* Retry without trying to grab extra pages to refill stock */
+		charge = nr_pages;
+		goto retry;
+	}
 
 	return false;
 }
-- 
2.52.0


