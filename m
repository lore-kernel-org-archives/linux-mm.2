Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C36C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17576B00BD; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECE96B00BE; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9945C6B00B9; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 582B46B00BB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:24:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DDD31401E1
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:30 +0000 (UTC)
X-FDA: 84944493060.26.AB77135
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96AC7C0016
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:17:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OV0GRM8X;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783012648;
	b=Fs70r61uRgCRzTtNqEv4inT4FRbyKbpshKLcTG0vnNCgmMuQjIc68VKOQXKBBqI1WrqEvO
	+N5Dx5QOlhNbFv9nEA8UcM/Sqvan5R7X92/Wq1GzZssDIwym2QvIJh35h48MoKKFDc3YHr
	JjJpKnVgWEVHvBRMRArlt6OuQ9pHhbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783012648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7SpLxZbspL6XS8P9x+tydUy80YkcthGS0kwmq/oA40=;
	b=B/spUdQhVxC9SoIFa3JfymjySBIOI8ZMepuynuFlApt35J5TzMIcq73ttMJCUPpvROrSIQ
	O83WzTOiKTji0DmLQWrMzjT0viO27bYONsfCOzoj/ShC+018XeY8LtbFhavtBKV35p2cBS
	1X3zN+r366zziOpH4aKlsdQjmB6HJac=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OV0GRM8X;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18CEF601D5;
	Thu,  2 Jul 2026 17:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B41F00A3A;
	Thu,  2 Jul 2026 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783012647;
	bh=r7SpLxZbspL6XS8P9x+tydUy80YkcthGS0kwmq/oA40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OV0GRM8Xw14V/XJHNFLeOXS6ZRg96+zCIwS8jw1vF/leCd+5ijvesos21lWjHFLZk
	 Yo14tOzcMD5W+ODOYUVYUR23gopp7e+w1uHnJNWq5qWfu3lUhImTvZc5Mj5ORQA23z
	 mQo9dHsu6YHd1wn5xWK5j5FVjjAIJWwwyuaQZaJ7whcdAvvruae7/5uNXEEmxyF9UI
	 or9m0787yhtBQO5QHScsJqoM2EL29hCO4eWfrrxAsj6UIjbBW+rpRLu7EtQIBBnKcJ
	 6Io8LbgYFYSIL0OSEA/qnD3/zLDAkWc9V00Iz5tIk/4Pk18y0eKMNLW1x7NBfri+AR
	 cuRqo1C/WJQSA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/3] mm/damon: add damon_region->last_probe_hits
Date: Thu,  2 Jul 2026 10:17:09 -0700
Message-ID: <20260702171714.88278-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702171714.88278-1-sj@kernel.org>
References: <20260702171714.88278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 96AC7C0016
X-Stat-Signature: yyre8hu9pu3qjwbhtqmhipya4pn3i9xp
X-HE-Tag: 1783012648-618672
X-HE-Meta: U2FsdGVkX18Teg//tgI+/rSBAbX4y28/hz/3sRRRudyVYXnBI7uAfEtoNsWva9DckXyDwvBhJDvRMihAYETUuRlG42odXIBHmhlohme/n7XeubSmlGcbkdZSrqkqH4lU7DmbWNX7dYrEHmNq3JznX4SlLHx8ypkMoztHtpEC2mB5RW+MYBYaZ7vo4/EYsuNJmULfN6QAqAjJFBLwvibb0yc/gQstft69P4p0hb+wkc3R2bUIR0V2k2jTfTIiyLSb8hVieb3sTx+hhdsEHNJxo6MJ4jgSrXDzyMelATwlyrPwbNujM0Dj7fvLEVFUgYP1XRFp+kf3l9NfYdVhT5BuYwxn8xSGiDJUnQQ/MIn4IpcUUv+YTdlrl1LYep6uWwDhiX5QWAeNmxqMKWo45a82nu9M5p6rij+HJUTFWRvPz4pOlXBz2r781Z1/j7AY+f1hZmqbcLut0bWrum974tRiG/2EABgdANqFF2X3wxtkzQwmEk9DIFVOIfq4KQc11993VzlimPv2R8vkkCGxIE1ker37K/81NVSqstmcusjodo2bBsh+mDQ7OSOuxM07YIuRjaXp836EdA7+QKRnqYOIElpS3J0dvaVs0XjvXQS836at0WViF6aO3Mvhy7JY5DuMx4Vg90102hLUmcRyY+HRj/rv3lNswcwx+SBtBwlMXX41wzV66kT74gct9T57dX1QxhQMH/6ygJAi9+dH5K4Uw7x50ayzMrqK1JqGejXK4N5xHztvnorfstgq4WC5ksOFqmbgiQftRC5ROvtKasZMk/79N/A0nWoN46u7vKNYtbjHYAhvp5TmS61f96JtvRnXmwiMTYNaM0Ym+Jx/XPd/b563apRRXRyCBNH7AKGeZBM2T18whKxfyonj7NzFzIDNP5q4etusD0wdQZI/rXP1ieq6bpK5NwOqytwlvjcDlbQ4U4p7eQ5hhRybl7DCLJ+it0tOfr4vSzOKNzbr3vQ
 4blVTvM3
 ChrKinQ2YATD3DREVk7EvdQA6vmi2+7hRilsIFduKM1EKEHa55nuYstYr7zNNj7gSur93d1mj/CNhlLQmUmemzsi9JeNvlcAG8u3mqpxvvSi1uN/PGBpF7Q8u0KPbRo9oWKGyzIcfsG3uFk3c1AgdPnvtpLuoeKHpUiMdscubJHabTNCxifVDMmpNg0wpynMgpBrwcxtL55fLgLHvGegH7bVWUaHBbEil85Zf0i9L+Ho7LtJdown1ybUF2k0dkea/bdwaHyYb8dG/bVtXA+8oUuyrUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new damon_region filed, last_probe_hits.  Maintain fully accumulated
probe_hits values from the last aggregation interval in the field.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 805e089ff4f2f..4f7e305b261c3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -68,10 +68,10 @@ struct damon_region {
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
-
 	unsigned int age;
 /* private: Internal value for age calculation. */
 	unsigned int last_nr_accesses;
+	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index b2fc15a3804ff..d45dc87fbbd9c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -302,8 +302,10 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+	for (i = 0; i < DAMON_MAX_PROBES; i++) {
 		region->probe_hits[i] = 0;
+		region->last_probe_hits[i] = 0;
+	}
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2047,8 +2049,10 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 					damon_nr_regions(t), nr_probes);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-			for (i = 0; i < DAMON_MAX_PROBES; i++)
+			for (i = 0; i < DAMON_MAX_PROBES; i++) {
+				r->last_probe_hits[i] = r->probe_hits[i];
 				r->probe_hits[i] = 0;
+			}
 		}
 		ti++;
 	}
@@ -3239,6 +3243,8 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
+	memcpy(new->last_probe_hits, r->last_probe_hits,
+			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
-- 
2.47.3

