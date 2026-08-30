Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75EC3C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B83B6B008C; Sat, 29 Aug 2026 20:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668566B0092; Sat, 29 Aug 2026 20:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E716B0095; Sat, 29 Aug 2026 20:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF896B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:21:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9582BA01FD
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:26 +0000 (UTC)
X-FDA: 85156031772.05.D6C22E7
Received: from mta0.migadu.com (out-196.mta0.migadu.com [91.218.175.196])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C3191C0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:21:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LY7mmaoF;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788049284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sh6JwI0wDGuyUUtoMSIAwfrMYA6Yom1CzZLnh2+3Heg=;
	b=N1TaBvySDSRs6RlkG75AttRpRIV2qOvmQKx+/NmeZuWCzbm89Xp+KH9ugMqx0aeoJq7Qpn
	r7Iw/0yuHCkahL9yPZfnIi6JK2cSewOaWvGfXBn/9ksTd4DOnpd5IAqqpeDJrmFBddUYzK
	6opL44jUnNuc9BvRa1XPiiHQTpFuYbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788049284;
	b=sCRlXtzEz5z8+EXDl1G/dHh79bXXQXpykb0uD8sHhSf7raPgUfZWiILyVWCXVwPlmo5xQ5
	eXBPRWI1ftQWd9dCo+DY7ELgrAO0gU9A4xk6kqUrigf5D8FzoDuQxm/WRkTAIdshEJBLSU
	pF/i44tP2fZsJcKeB3tpRTlheDtlaWM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LY7mmaoF;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.196 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QVlkSSSS5i8xu5m23D1SnKfFAtjaOMB8/90a5M4Lomc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788049283; v=1; x=1788654083;
 b=LY7mmaoFxuUqir6SolTLvQ+wvq8vrtMjPYce7Zee0eOgPQXpj8wiy9VyV9C+3Kccn45pZhjw
 jiI3OEXMBfy1SNNWMhOkzo4y/6KiAgp+ifvwDKY9sQ/8kD1clnTnfS5rGW9K9odjlbrrCduLDZ8
 Fx0eqTyxod/bxqrkadPTOJNU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5c14cddd30220827;
	Sun, 30 Aug 2026 00:21:22 +0000
X-Mizu-Trace-ID: 5c14cddd30220827
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Finkel <davidf@vimeo.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 RESEND 1/2] memcg: acquire peaks_lock when reading memory.peak
Date: Sun, 30 Aug 2026 08:20:43 +0800
Message-Id: <20260830002044.1938621-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260830002044.1938621-1-ridong.chen@linux.dev>
References: <20260830002044.1938621-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C3191C0004
X-Stat-Signature: ndkmdbyznyecdt97da9ptam8tbgmiopo
X-HE-Tag: 1788049284-757567
X-HE-Meta: U2FsdGVkX19huyQ7O7rKylLpC0n5EnpJj0XhNUr10pYDwEp/fgnAUYfayaHjGFfl4q7gl0CPsXH9uI1UUzFufmYpaECj3Xa7BIoZqlX7bYaCB/TYculyVBWfOe9xS/gGlD4w08ypWRbZVhEfOJTIPjIW25sFd74quTPpoINrR+IKFiCm0ypwevNAAvoPmgmyTP468Yk/MzMELPsHRH7rSJxoOwHi78pHqNkYinq8vkDDW/TpOHxiGEyampfIckfWojk37aN4aYDZFxlPlSL6PMwiROW/LJZ9RBNmuKwjigcZjDNr2Ndi/Kuxi8mp6BZOYehLhkEJyNbwxmc8UalK6u/56Wz8+AephxntNi5fJEv4nHXqmq2CWWcRYABbQ/lRyNEhlPpSUEsurPFQhWilVspObFfeYpD4pPXignOV98Q9ZqaHjqDsUqavRaTl18J/13FhKisfXXYp7hytB1gX1aZ3BW8d3sVgKdSqEWSvN/8pNYfmN7NB5BJUHhSRLIonLmUgikLIFdTz7C8RLxFqhFjqezJRVpCs7wVKuwfD81Tx6d33TOYQJjQdWbEKXGOUqwoYrGU57hN6uBzCMK9gaAejgn9JqUCrZLx8EquZLT06eTtUv3BcHU3oZv5gxZG4gu/qh/3lV+OMz3OPpWakjLYiX87+mqGumCrkEWoVPcGcO1BJ/Yua4I8v5Ijygrw7AF0kb+HkEvzToJTeBdGvRIG0te8da2wfx2YLJCkdWMBkuL/jtwDAFN51/69/MRlF4C/fS4WI6JHDfTWtr24jo11BZPAflCjMsQ72riiUYxS4EO35N/4OhlNT6aXb7i2al/B7FZGv+Lz162COLjj03Ss5YCERxR58TiC+DnoiVoDUWIvJcerpemhxOXH7JDqBPgcXpCnqJ0pjveK6phH7Wov2msJibkkHeZGE62PBZSLrYEEp3IZCmJUpyRU44oPTjmFgf3GRXFw6RbiiXZl
 UNCalwXs
 i7GNGii7TOQP1QKloKIN3YJcOO9fi70rteMHMQ62NoEAY2TYU+1mD9yLs4pvPea8SGX1O/pLzTnyCPqAOSzSbvnKZYeSD6pIuhWEXQZ1dKlOj8PEW+eOAWXknegbvsB5+fiX39v4Cfb+SgCUAID+DB30wEY9ey4jTvxXF1Y7XvbWZCrb4ycEl6eUBQlXxJyUj3qOEEE2SF/xD1n10X4qRhVi2gJ8zS6S4UxzMkjGTUUEyOrZJw85BxIVzyRTjyPtLLSkq/WFAw2UwKSldxWKDDpm3hB7AWOUtBuQDTHm3HhLzX/iYAam/Ps7HD2RMwC5SxbO/9gXIuSeslgTgsaJ/Z4pMyPFx2UhYTvBYrgkTHRQhH93IB/gG2fGv4qhT/8Qo8nwoXJU+jYfueBeQVyteEVGL6hYT6kmbuDfs6jRTz11ZYEfaodye3oqQguBbTCjK3uAXCkPf2WmabTVQNaXVlMiPRc3V4EVQ9szdE8yvnAZNCHBJQaOMmyfUDB9BGOFjUjSwNh859/cottlLCB5B8U6U4/CFR6P2di2UJ26Y+m3ZgUJCJNfaGSvlEwjqWEz9XiL++ya0YCTJu0WjhoIgJCt/6ceAnXQm+CGXgGtKQfwSjvrmE7rJQhLCoewwGDFD1nwgSPO57pCFBUwRATEXecANJ10VqO16bD6CRTMHQaWDe3JTilTTDbbxy7c1E+2nF5niPU/FXHPK1D2pmOpo7ff8ZjyYhgecd6NcQpW3eYlwqvtnVg7Oys14nOCGhBTsdz6L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Sashiko reported that a reader can transiently observe a lower peak
within a race window [1]. peak_show() returns
max(local_watermark, ofp->value), but peak_write() updates those two
under peaks_lock while the reader takes no lock. The interleaving is:

  writer (reset on fd A)                 reader (fd B)
  ----------------------                 -------------
  usage = page_counter_read(pc)
  WRITE_ONCE(local_watermark, usage)
  // watermark lowered to usage
                                         lw  = READ_ONCE(local_watermark)
                                         // sees the lowered usage
                                         val = READ_ONCE(ofp->value)
                                         // B's value not updated yet
                                         return max(lw, val)
                                         // both low -> low peak
  WRITE_ONCE(peer_ctx->value, usage)
  // B updated, but too late

Fix it by acquiring peaks_lock when reading the peak, so the reader sees
a consistent snapshot of local_watermark and the per-fd values. The same
race applies to memory.swap.peak, which shares peaks_lock and the
peak_write() path, so take the lock there as well.

[1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1

Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Assisted-by: Claude:claude-opus-4-8
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 095050d4296a..b84f448fe984 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4719,6 +4719,7 @@ static int memory_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->memory);
 }
 
@@ -5909,6 +5910,7 @@ static int swap_peak_show(struct seq_file *sf, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
+	guard(spinlock)(&memcg->peaks_lock);
 	return peak_show(sf, v, &memcg->swap);
 }
 
-- 
2.34.1


