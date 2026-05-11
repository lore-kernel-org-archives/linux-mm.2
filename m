Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0910CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142566B00C3; Mon, 11 May 2026 06:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2A66B00C5; Mon, 11 May 2026 06:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0088F6B00C7; Mon, 11 May 2026 06:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E45C56B00C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:52:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2171140623
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:27 +0000 (UTC)
X-FDA: 84754825134.13.E6DDD2C
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id D233AC000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:52:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r0VOxb3B;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6WtgpEfVE+ktty/21d7K0edFsjegj7CB2gJFywRNtg=;
	b=y7GilkbmxwKehu8/dS6WWQ+CpNvL8ZwLYPiGGCVW+IGq3VRmKvG7s2j5pR06gBOt71T/ia
	YgA6H+W1WAf43uAEGtp7JcYVYsvYzRlPTb7LCZWDmMRTzI139s4KAt551lb+/bc3GDCHxt
	9PL42rF/CrKvh3ZFRk9Q7zWOekevG1M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=r0VOxb3B;
	spf=pass (imf28.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496745; a=rsa-sha256;
	cv=none;
	b=qn+MbUmkr+zLpH8rGpCS5QoCbhGJjQHfr05p4v12vIFN0eAQvu9GLuvapkHxSx4CbZ9Aph
	u4lNNuaSXlcJN3cPJl3bXtJ0wHfMLNWCBBtuO8Ui/1j0Gw3rlZjN9LaToU/Y9S32eG13yT
	a2Ro21t/M5P33D1/ald+0cdbmWCTjLU=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ba0714574fso22467445ad.2
        for <linux-mm@kvack.org>; Mon, 11 May 2026 03:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778496745; x=1779101545; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n6WtgpEfVE+ktty/21d7K0edFsjegj7CB2gJFywRNtg=;
        b=r0VOxb3B7PcTgwfjWRqNXOtbS4uu1KhxCTXSmGcU2Nki7UwBjZwzPdxkjAn/tv+DLe
         EuGN8JZIVUIBJeBNK209KXFWnNGbc+Uo0MWQnhjRUwe071BVDDg5WA70bKqrgrlxOoFI
         mDAib6oTCId9YyYmdoudI7woYVsIe6cQLACBUpBCUet0uihy40nl13ArJYVIt920N1yi
         Ow+RzcCD/O9NS9gQt1GZ9d+9PWQ3zt+NfcjjTUTCtGHLi8JL4Ig1aPdKfmsPxYZO5jWD
         FY5xW6RtTatcgH/A86ld5KTcN5Wg6RdbDmTO+loUXyGrzcUPsvBQTAOiAisrQ+5TKL6V
         tcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778496745; x=1779101545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6WtgpEfVE+ktty/21d7K0edFsjegj7CB2gJFywRNtg=;
        b=Pg4LNa0Xkjc96RRM3JruJ2tLSnGyIbkTIcFEPZlH16PfOug9aMGVPgK6SNhOmrB7jo
         MCoBbPUpuRC/9ON9rWea8WFvI8hwEcfwdOElBIlfZa8b6v9D6e7OO9KUqIImAZ099l8X
         K1H1cnLO2AHlkdz6bs717L7891J4BoFv+LwhvsQont090KpQ+2ZPcJQNZMHfihjS62aX
         M5ML0aLoL7fLzqLdCPt+xeOrASQAw+UlCPcL4Do1EV1I+By91Ao6xKHIxi8BvJg5l/lc
         sbk8X/xp2XOJARPtRPA7u3XEOPbbxi4uvuBkqc6naAU8CdHHkWkvr/pxOVJCkL0P5qZH
         LAqA==
X-Forwarded-Encrypted: i=1; AFNElJ+vUA8F+CuSXfszAPRYoiWdecc394aZ8uxFgArcxRIDSaVcr2ePTtKUPklwuM8nIHxm8Q7G+2rIxQ==@kvack.org
X-Gm-Message-State: AOJu0YyJtNFsMQTm0ZiNTSznA6juLgldZo7nfu4agn2b2v4/QXoOh935
	CUYP4pWVen8ijiOEfWJOx89waPUUpCxmF3qUzPOh2kPzYwofaCnbEa2u
X-Gm-Gg: Acq92OHP8P1hOM6MuWdI18XNQ8JPRt+E84TqCQSi4q2/6lIHBTTswlU/73ywqGUs4NC
	AIZE/oDGzHpRf7It3CC8dw8KO7nIjm7EbKCWWXvY2hHKc+SLWqruoaHOvas5b9fE+iCca+Q+Nn+
	TwKqXOQ5tR6dXr1BKCw7yFaBxpS73qM87hq0xUvWswrj5d1CW0bT1RFiVxhnbdEMX0kI4+WO0VE
	yXHAnGJh9rUgSpWRnCGJINyWiFNMQ+MQTUKXS/Pr75Cz/91EtwAhewibvGTTtR7zsFsueNwRPNu
	K51mWy56eqGuB3DvkSvgQNNGM2MUbG5TWHmHJZXg3swaxr/ai4U2WZWFr2EPAmDkI0fB9IUdkWL
	d/y7UkoeMfEPG4HV9tkABQI3ATdAwnQ+j68iQC2B1Tl/PiyX8lPzgdsW4tSrYZXjPoBcRbhapwJ
	UFU4pt6lt8CMDh+Rn81rA8WR+3qB+Z30dT0B+aUCgE4WsB2qzm7HAPTqh+Io85Sg==
X-Received: by 2002:a17:902:ee92:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2ba798c279emr168316355ad.25.1778496744462;
        Mon, 11 May 2026 03:52:24 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d409eesm98571745ad.32.2026.05.11.03.52.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 May 2026 03:52:23 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH 3/3] mm/zswap: Add per-memcg stat for proactive writeback
Date: Mon, 11 May 2026 18:51:49 +0800
Message-Id: <20260511105149.75584-4-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260511105149.75584-1-jiahao.kernel@gmail.com>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zem9g7xyekjszto3s7fxow9tpspggz6m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D233AC000B
X-Rspam-User: 
X-HE-Tag: 1778496745-497952
X-HE-Meta: U2FsdGVkX192sT6DRWEjNfPu6Undcw2D1DJleRFA1HqMW1jtRNYRQdPGW0mkfKBzbj7aTYu9SSQG7bVh9nQCsNbdPzKxW5O24Mvn0OxY2srBiODeTuLHTGzzahHvbZCQ3hGYfDKIZOUrpyVqGd/DHWMYkKNnWQ77jjOAvza59TL9NYePV+ikQ/nRGCOmQ57evNCuvQOrtXt2n0T3eSp3nmgLdOK8wVaMi3Byipc3Ec+Rihc/5MLN6U1UqcQZEv5MphzKnCyC7v6qhjKdTe7xLMfNqb3deRafH0ihyykhj0PNxbhNuIUexfL5SxB6RmAbtHOSzAgsihxa3HWU6gwXbiba9j6KtIrLaGnpoVjh6qYcMAgXOIS97DTE1VliBQcDMqYsKwVsTm1fIkv8uuueV04j9tvZFiCyQcxSRrH7Qe2+YeTpgGIP4BI7Rm6KdHerp7IOZm48JbuMj9JNkjlekM3j5i3xp2bGR7q7fBwxcY1Ibh8H4jhZGKTlxkb2sMAydBt5vzsByLgxsljZBGvkxyX+MkCHKehTuCkehdv0ELfVI7UvxNTh56Wj+xoPlAEEsqL14nNSD0pPP33gkeXlmZcQ6MYJGCbPaLgPhAaqMckRZ6nrN4diJWNxbPvGymUvr6ViqrWKMLHG4FuI44xeVXGonn8lBQAN7nVTl4J80Oj/3+yoEn0HOGZo8KpnODC9a8fGNeIPhOokc3MvYXhEUsaAow4KzF/q2k1Gh/l+hpSddenPARslNgTHEBHcLom5AQ8utha+4b8AGrqt2gsKhZvSV/b7A/Zlr+Ah/b3frn3u7Kk0GYEvKXGrumnRJZ2VB9jsvZasAqr9uC5C0Pc5y66BrKLcYWQlCVNXPWOomMO4dK5fbfnbq5aBWR16GFMN/95rhgy5poetzIXDISlmaXvzQPuJXo1oc2Cvda9Cul3TShTR/13ZKD8HtukcTpViD7txKsoWioAEz04ExEy
 adHooZBI
 +Wuub3yEqV/PUQGM3N/5vzuVUWIqgAUxjwGlFa07sgs/jn7aIeerElfpEoe91nQpO7/3FfIE7GIs0vLlRtEkGn3knPqm5k6dh9iwSWGJhCkulusXX3JfPsFWW97ywr/rSAC5VmFneHv/9a7TzcsjCQHRmNJ+oIKW9hTmGnCj+145fBVbRMNVWqOJPo5RwoddI6J/umABXzP7mGUSv3j2D5pCstbwjRF9bg1fGMkSEK+9jsIsybW33W7hLnnfK1l8NaIU+ItPoBteL6w8078hackkNeRZew22GBQS29VL4GeBxC8/UlEK5swgNDTT4SP1TaqA+wZILLdVbrSmNUc4w/znoGd6yspOs6OKA4QtLDCozzjEztaTfQjWMsWTc6AucPGAOMCOM2xxEF8YeX6BxPof2Bj43ZPNvtlpT51xieLrOGdzaXNWuo82bsBFW8Kan7t/UBf9ImkBFKW9ToTtno8PDjedcZ57XCForqx4a4x+hkng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, zswap writeback can be triggered by either the pool limit
being hit or by the proactive writeback mechanism. However, the
existing 'zswpwb' metric in memory.stat and /proc/vmstat counts all
written back pages, making it difficult to distinguish between pages
written back due to the pool limit and those written back proactively.

Add a new statistic 'zswpwb_proactive' to memory.stat and /proc/vmstat.
This counter tracks the number of pages written back due to proactive
writeback. This allows users to better monitor and tune the proactive
writeback mechanism.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  4 ++++
 include/linux/vm_event_item.h           |  1 +
 mm/memcontrol.c                         |  1 +
 mm/vmstat.c                             |  1 +
 mm/zswap.c                              | 11 +++++++++--
 5 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 05b664b3b3e8..29a189b18efc 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1734,6 +1734,10 @@ The following nested keys are defined.
 	  zswpwb
 		Number of pages written from zswap to swap.
 
+	  zswpwb_proactive
+		Number of pages written from zswap to swap by proactive
+		writeback. This is a subset of zswpwb.
+
 	  zswap_incomp
 		Number of incompressible pages currently stored in zswap
 		without compression. These pages could not be compressed to
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..7a5bee0a20b6 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -138,6 +138,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		ZSWPIN,
 		ZSWPOUT,
 		ZSWPWB,
+		ZSWPWB_PROACTIVE,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ba7f7b1954a8..830d895e77c3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -572,6 +572,7 @@ static const unsigned int memcg_vm_event_stat[] = {
 	ZSWPIN,
 	ZSWPOUT,
 	ZSWPWB,
+	ZSWPWB_PROACTIVE,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..66fd06d1bb01 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1452,6 +1452,7 @@ const char * const vmstat_text[] = {
 	[I(ZSWPIN)]				= "zswpin",
 	[I(ZSWPOUT)]				= "zswpout",
 	[I(ZSWPWB)]				= "zswpwb",
+	[I(ZSWPWB_PROACTIVE)]			= "zswpwb_proactive",
 #endif
 #ifdef CONFIG_X86
 	[I(DIRECT_MAP_LEVEL2_SPLIT)]		= "direct_map_level2_splits",
diff --git a/mm/zswap.c b/mm/zswap.c
index 1173ac6836fa..bf23c46e838e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1048,7 +1048,8 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
  * freed.
  */
 static int zswap_writeback_entry(struct zswap_entry *entry,
-				 swp_entry_t swpentry)
+				 swp_entry_t swpentry,
+				 bool proactive)
 {
 	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
@@ -1108,6 +1109,12 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
+	if (proactive) {
+		count_vm_event(ZSWPWB_PROACTIVE);
+		if (entry->objcg)
+			count_objcg_events(entry->objcg, ZSWPWB_PROACTIVE, 1);
+	}
+
 	zswap_entry_free(entry);
 
 	/* folio is up to date */
@@ -1223,7 +1230,7 @@ static enum lru_status shrink_memcg_cb(struct list_head *item, struct list_lru_o
 	 */
 	spin_unlock(&l->lock);
 
-	writeback_result = zswap_writeback_entry(entry, swpentry);
+	writeback_result = zswap_writeback_entry(entry, swpentry, proactive_wb);
 
 	if (writeback_result) {
 		zswap_reject_reclaim_fail++;
-- 
2.34.1


