Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926DCC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE686B008C; Sun, 12 Jul 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A65E6B0092; Sun, 12 Jul 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F066B0093; Sun, 12 Jul 2026 11:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34D3C6B008C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB56492CE9
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:23 +0000 (UTC)
X-FDA: 84980548926.30.1660160
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC4774000B
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nLU3GX3k;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpaKnc1e95Tg7VSs2UGrLw6c/qizit0d3ArQLheYoTo=;
	b=dIno0BNc19CRfdylzinnfXOP5lBaF8mARygIIpzJbyLe6/AlhL0fjNs1cwwip3nF3v078b
	9ADJr6/Z3Y3NmMozmAJDPIUGFnLW1vEQz6temKXEU+hQtVqSxIBy0BH86aJUbyCgjpm2jw
	t3icIi6zzai17GUwtIR3Fo8PJdNeDz4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=nLU3GX3k;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871121;
	b=PyP4uQ9LYSEE3PpVXyuhmsijdP3KOYVLqlkWz2f9HSSKxJRMTceBj7OpePKJorRazGvCA9
	QY9dobC+eQhyULZc0luF3s3/gTQWVbjJsSy/XPgiz4FXfLYj+7IfmfK8qRmEvNoKvx0acg
	cISNqFVYJuhzios5Ek32qSD2VQjeKwo=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e4fd65b2bso126161585a.0
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871121; x=1784475921; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qpaKnc1e95Tg7VSs2UGrLw6c/qizit0d3ArQLheYoTo=;
        b=nLU3GX3k5/gotfx5ko73g0+I1U/FlyPmEOVvl5JKrWnsDqlEoeZWFLE8wcc2KTPQv0
         v9dS0k/XRm4c7kUW9Bn/OaoLs4fURkpfY5G/WaoTvbMLbxlW9AMY3TZ9uVVWlsNoBTxh
         8PD8pKKXQwXepyPP7/Cmnl4+y/YKKy1PnbBBbOWfTXgsgwYyi0KYP1G3RWmG8d6auaij
         /JKvAY53gSHXI80FVTxYmxH/cEYtGfX3HMA2nQ5kc+XkiiH5ZxZQ1Y69BCrckm+AE57f
         e3YXBcHtXx8HxYJv8J4baGf7BK87J4pOgdwmf1YwxIXn+OhRnRqPvW5P97vNM0an9hIv
         XkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871121; x=1784475921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qpaKnc1e95Tg7VSs2UGrLw6c/qizit0d3ArQLheYoTo=;
        b=QXGgqdOFD14f2p6/tRr1OlrUa8zk1r2DFZoP7JjRBfFdbS/mxMT1+GZ9SzAdH4HV0w
         yJgAMBY+88ltdFwwODYNR2VaUjxXQUUjsnWAG7MRAqCnrv5VaNkq1Oc0w+YzlqVjyG9l
         F1n+oDlVvbr3MGlcpud+oocid6WKQfHHneVGXUdAhrZ8U8QfuDWuOy44o0cggYcC8iKx
         ftDsvYhSxkZB1nWEG8RUNBJiuoBDQktuJgaq4RS6QSRV9XpXs0rm+Q3INPVr+JdZwnmT
         PC6o1tlYkck1WiMAUSKfBq81RXAdgtmlsZnPxkSvn/eW2pq7E9aVD97x7249yzfT4UnO
         lLfQ==
X-Gm-Message-State: AOJu0Yyom0jLaB7X5Ya7O8ZtUUHXB/+v7Y5YuSQctyFWa8LF6ZoVTXNh
	2kEIEytyLIqR/NmNmACvYc3814FUW6iZMFfyIZ0hzKrKHCDfXzG2Z40oX3NO/P6z4dDtHkIUWof
	kyPnZ
X-Gm-Gg: AfdE7clq4jAWEZqLG3cerKd3HOgApORcUuRptN+utO/tIPUYPjPyurLa9/saBrWe5au
	CifUN1ck7cuoPAh+InkuhZkDnp5t1kualCyUFM68/xlkD32ZLsTvF+gPoK0kOQUm8awicFq5Bae
	dXBdpg8RhWZ/qujn+bPEMkn/+yeZ87iqfXUY8DHJL+ItF66gmXOYKupv1DjW+lFY7VacNmTf4g9
	/zEf6QuqNmO+jLS8NCIm8mhxiLvinL6O00mLIKh3J8IfuDIS0jgme4E8RDHvHRnKe3EL46DoTSt
	dV2vyrFo40OLsepO3r6dXLR+jloobLpnDiiAl+fg78tU32ptEw/niZgZ+v7h710WpMawcUNUEC2
	3+A2l8smtUrr/TtsjRyvLX8vCcATGC1w1kYaVB94wQRBV2yGm3w+85wC9dvGMubieZ8gXt0Mojs
	CM2pIYsYHPNjGgf9dBi8Tu7J+8U8xe/e7aUshzcfmPE0a43nvLaVhuFNaacXjgNUutiznqdmDH2
	A==
X-Received: by 2002:a05:620a:2913:b0:915:e9c3:f1a0 with SMTP id af79cd13be357-92ef2b35bfemr677144185a.12.1783871120928;
        Sun, 12 Jul 2026 08:45:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v7 03/10] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sun, 12 Jul 2026 11:44:57 -0400
Message-ID: <20260712154505.3564379-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC4774000B
X-Stat-Signature: rn5mfcuwjqn4e69pkmxrjpzky37pf6uw
X-Rspam-User: 
X-HE-Tag: 1783871121-845694
X-HE-Meta: U2FsdGVkX1+6Zbb6rhC19zRhi8aWY+TX5DmMUbP4sBlpNlC00yAott/h2/1aO34ZNFzR9bOaUVR8RP+wDPjdwQj+2WB1fRHeKZchldRFw+7k550C/T4cIQvajCGoiQ8hNjL7h6xj4OfWrY5aPId8LtsmF2saQ2T1xG7tzwGINg2ZOek2IuzBtGJgSCjhfJovCDLN29rVwSzVrJ+Dp/mKD+SxpVE5YlFdlyH6HBADs41LTjPyWYK4i/rCusGiPCjAoG+XdtWx1mCBy+LAd2NUsn+dC4+jx0qhl7l1cZjzMFSvtg81yswONcj6KFSSGDJwA+5kFRHcbTpCpFoXh9/MKVd/pNf3iE91RwExvNJLMlMeqNNM7su0noIknnc6EF8En/c3UgON+bylRcYjAOTnLu/jjfEdXKNNME+CTIMi6ZKAkoNNkieweResg3YjYVHbi3ub/KQ4pZMJ1VXkc4EN/Z4lUnq9pn90pAar2bm3o7xuLRrAqP5iQdCTW39Ytfdt3g021Q2mj2/rGd8rWHzgFkG+ovPMRD12f34wmoY1piqcxDvVxrMsLc+N8RGkiL2jVsZv6f0EDdYt/qy0LmyJX8kVOFzxmp4mcHIRnQD+4fAltik9MaGSduBRl3WGuK0O4HvNxvocQcglYkdJGSZ70QKuYisNxW8bUBUzmgMYMGYdhxPZ8pi0PHFQ41Ivg7zGaysN82JLjjynON+vyksimB+2HoAYZ56yF/3u3/dQ/CIoECv7IlC63K3ik8Whg5bMoPN1kbSvKgZY0a2efBhW6h1V+fXdLrSUxLhKHtMS039EPm0YM9UF1RCbDIm3q/q/AuQzVvsLxMIWlMuhsA37a81kRhxFSXCFC6H6jyNZ3LOFKVWCQPiUKTI57A98bttaBXR6OWsfl51dIU2TA4pd5g/sxn1QxFyoaC2N1jCUGl0sHaBKAy2ugGdvR7wPekIKOCvtLyX9G4OZWCdBKAY
 AsCzrid2
 Sn4283I6i5fX1ouvK8Toiz8NN+9PFbN1sTVsMzwdXzdze1Ct7JZxrjunasBqwUbYO0NvEY2dli13dOjY8MGqDrN56yqiwg1EZB4rCOxdm95kAvnzaioAY+wOVzycy+vDSUVYo7SDst5FPwFrose5a/4a2bA8FTFxdvaRVffhVfSbW4yvk3znB7I8lEoE/6UhQI0oZKZrQkAj3yf6AZFouRveNRo+D/5z5q5QH91gyShQFUFtb8SKeviEOpyQe311lKwBf6HZHUdfqeC2MyYZONBggY0q09AFcwYV+BEJMdr0JlJSl5+T15L63JQZuKwCZfvjE/9f1WYJ5J9xrmLTIbS6Spir+hrgjIVl5LtmSIpshvfgtTSK9YfYGtGgtb9CUIqhvf8Lsv+YI3SA5ACr+lc96zAZlxFB1B/e4JG4Opp5MRak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 8b137328dcf01..e625529baf996 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1338,7 +1338,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1495,6 +1497,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1583,7 +1586,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.53.0-Meta


