Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C693606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SLylRg54
Received: by kanga.kvack.org (Postfix)
	id 8A4A66B05B6; Mon,  2 Nov 2026 17:51:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855136B05B7; Mon,  2 Nov 2026 17:51:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8176B05B8; Mon,  2 Nov 2026 17:51:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0966B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:51:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7DA31A01D3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:07 +0000 (UTC)
X-FDA: 85391676174.24.535FFA1
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2E81320005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SLylRg54;
	spf=pass (imf31.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
	b=E74Ncbl9RU+HGBtuo3h6Q+pxjUiXjzOLPn7GM7F/+PXt9Y2oKLv32Cs8a7dQYeD/RA5dGs
	xjukke3R8nOJ6Tzey12SCgI88xHXgiXhp3ry8eNHSIiXcFc8AcPYbeK61tq2LSPa2kITKp
	4taK81iWsvIOwFCqSFrdTrnHH1sl9qc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SLylRg54;
	spf=pass (imf31.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659866;
	b=DKv5TYxVma6D+LpcrvRTDmLEWYlK7O2mfOnwtw/p+3XSnXIiV/NZXN109+l6KBboBIcfSA
	Oc7DE1G4UdyWLbGjRMNQhwEYdcQ6gQ+XD1azWR61bKl7ho9/L/KOOQ0Q536Pcng56vicQk
	58DYfxip18OxR/eSpng4xG2GtqS+beM=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6798d4ab549so3283824d50.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659865; x=1794264665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
        b=SLylRg54eXgx9uztx+n8ZGTqRIGvi3mK8sTBdE6zA8tQ5xQps6ucoV9T7P9rYHE/NM
         Bn2YXNsF5XPiZs5CldwAZF2+tZVO4An1Ggg2OXRFTsS9Sn/xQHLwtd0sne9BQLulWyMT
         bNyfFm///sOOE/D1YuNwDnSZESUj8yhexZnVFWcij0Vb1u/nNjjB9rlRIBD58UA3sdDq
         oNl0x6NV/Lf0kE88UL12M7BgeNo065bCTlM6E3yF4FGOQPia08jTaHRX/NvXm/oqPQRQ
         Q6mMHPB9IF/dJ27wQTY2B32S4dN0rV1YsXx/HCZaVywAeC8GXzzZ7NyAj2ogtragmcAT
         kqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659865; x=1794264665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YsIHlK7moF+Sg9EM5XQG5yakBii09xJE59b2g1kveUQ=;
        b=z9oPdcr2uV3tXvtb6DxyqG7PuPmZDJkXqyCrPL+2PQjx7UhKXUm0FySjmNWx4m5O6I
         /kDfDlVt+R4ddBVs6ehULnGiwFw5c7Yw18B/txBnroIHQ7YI4Uw9J1lR5HtuOyYmyvog
         nplmwMarqPMJkvGGHrQsNOcLY3pBgmqeUcMSeRutPvfHpTgcRc/Pkj1W0KSoOOOtTqc3
         gjk9lIvzZxL4wFTD+6WcTHk5lOYY6W1epiCp0AxlwPWk1MTWrvdKVs9YyADk1A87y+NU
         zfr8w/46e3tv9Yrxle3NJKYBbR+QXuqSEGYSQbReu2TMV4xEShxTuV0l+a8jxKHTXSjX
         ZHJg==
X-Forwarded-Encrypted: i=1; AKwUvBwvzUGgDTHRm0hwQ3RIoVWLhRgZbySm5/1A3MBryw4jfc11+bE/bnh6/nigLiy0uQt79q2blyg9LA==@kvack.org
X-Gm-Message-State: APuU4Z/e9J7atMUgMKKJI5wUdxuSeDQLZTpCid1OI9ueVPSUCNrAPM0l
	6tsnmGW+JDHYarf09FswnCnJKoGBEHZCg+tpFJQSWWGvhwuYiU8odi2Yy4rkPg==
X-Gm-Gg: AYBFou35Yhj+RL6dieu+no5HHemfqeICSLyLO7aJsA//pKo+P79maU50mIBQCP79ecv
	DNO+73iucCMZqiYItSoDgLph9EcMtqsueE9s0HTHVXJLIVDWQKwVXYcoSuPBIfAxwHGzb0XoYad
	n9r+n2OmthNYshBHMFAJhljIQSOeiuLsuaU8xvAzchrtbtR9tc22k+ML7H/LRqxEQzAfydd/m7t
	knscRn2sjbMghYragK4CgixlEc4eha2i0p3qSe+zIy+ZgBWCHzNOfj+bikS2cCSHZVYsK+qNmyt
	4MpIg0JGVupm/lUtSAuLFm3xGGeNEtpT0/68gcStVJmR14R/pntaHhD+OJK9mEKxIna3ociciu2
	iObE70UxsjCz5XO5CI07SZTahF6IYRO7U2yckrOSB5UQ0An8VU1KhuOO1btTqUGKZqJuKejpgqj
	FtExTN/yhb34V6t11yW3D4I2dr8yAfhwDC+A4TdsqWra5IbTXmyyJ0kBrJv8d/vaSb7JsBovdmB
	I0S9tj66CsEPj6N0npJxV0Xr5B1EMXHQlG+DblfDI2LlrbInia1e3HYT+YrvlXaX20zT7DYQkq0
	X8iHewFIQ1/+NqCBd5z3BrlAzIXd920m7TB44uEAMlyan17VryYrioQcFvEHuR9YGTPhxfmTXxO
	nQCIu//bqfxUDs3ytdM9Q//MlnsQ=
X-Received: by 2002:a05:690e:14ca:b0:679:c4e9:b645 with SMTP id 956f58d0204a3-67ba4c90a9emr8088319d50.4.1793659865073;
        Mon, 02 Nov 2026 14:51:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf2b138bsm5940925d50.9.2026.11.02.14.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:51:04 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 3/3] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  2 Nov 2026 14:50:30 -0800
Message-ID: <20261102225030.2743129-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1jy19ptr1gsi7hjuys3zhprr4uid1y5m
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2E81320005
X-HE-Tag: 1793659867-100793
X-HE-Meta: U2FsdGVkX1/of573be1GODBUon+SquwII1t9HTDSow34CKRaw2kAIHYSj3vMpMqrTsvUBU29lmASsMHXMX8YA9jTlm5oueJJPBu/0lmJQD9ulbitKGi+Kry73IQZ9rjsf6AWxJItih8s3u3DF3illG1pBAcYVP7C/9B7hGomY0SGS9Lh27Q/1E7kO1Uyvp4ot/hwk1AR3mRD38Uji2qm+WyeMx2Z0dn2TaalYwbyqCHcMRx1GgNZjyGFASZgMkL6COT/EM/6qSrHqvtCCGfQSOVBBcLZHcDi8ynfgY3jrXfs9m3maAtGzmhUSXy6Sy8CZNAoNu/ahxi/myh2LIT8/MItecj7n+iIJDxgOEtSw0SOG9uVaTCkQ3Tr7pI4PsmcNCK+s+yCeUh6x/kwVb6tvCcisWJbY78/OMtgN9CF/qYP6OwKMRUXxtt0IbLRXPrAlSqOxgKi6zHvAoQBXiXZTtpS0xksoPA44WU+tONmoqI4I1WaBIheXYWfJyB1IelUEf9rrzsZGL+nwYhqHlJVbqHQJq0rXmGqsuSwGsSL/zNwS4kK8Oz3pj+rNE5NBp09thKJ51U71v29C6EB68sIsS+4qAj/ymWZ0rTyt1aeo9a3JXCGYBf/ypIULDg51Oi5e8S4vGKuO82lYY2VybT/ykkXmy4w+KFQuJvVQh/J3ZGeu9tDBQC2lhTFSbac9YOUqKyfes1lLrn+g+KDHpthdj1/2oXElsU7Ei9nF3w4yQZbqySIM6uQDjD8hesk7Cmwf+0GmUB0IiGacDThueu4Sm0hBfdu4sxJZUle9BoMWT0EX17cHZkbZUMIDUgOiEGTXCXqLyiep6MoFlegYK/8oTw0gjWNmGy9I5wN5kITaadwS0T5pVM7v6Sk0jZAvSFsjrPzQfiGgnp8Eh/rVZ9XyGhF96tWqZ3FKWxcJvKOejt/jKJxNA6vp2qWeAPyv/Z1mQHhXgSZHQFcypndg0i
 9BiLVwjW
 yQqcyjp+dENy6EROWDm7X+QOwvQmuXZVdQtxfqnbwoW7M9X5LHWNTjrBFrCcQ9e9iMxXL+W3IuJ7VDgcSorlBhe/XfZCyUQcG7uRl6I+wy9snbbwllW2rseQqa338+N7C/dIducb0RBgWr58RqHMaaWrJRxXL8voXJmgSaV9IWLs4k+2z16QavYgWcWQ670abL1vHXvMBOA6vVXBeKK127SbGFntzhu8p9KwRHPvAfl2zpLAV+P9di6VWA9BtsXKNLPKM+h+FJHeMcRlrois1f0fs0J0u/a2j8EnW20D7USFgxO/BueMN/sXAokKmVv/p9XEvo9eO2Er/sOzpb/Ab+osR+K238ustO+P36F71x0/2FTy+xEF5rJKSmiXv0tengzT/0o7SE8CXQwwOAw9c75OCrcKkrJVX/iDmaVOMfqSMEBj3NGPSmMCoGAKUALUwHvkJgPbk1axeDNUIcm8vX9sNSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_get_node_memcg_used_bp() flushes the memcg stats before reading
the LRU sizes of the goal's memcg on the goal's node. For the root
memcg, that flushes every cgroup in the system. The flush is not
ratelimited, which means it happens every time the goal is evaluated.

For the root memcg, the node counters hold the same LRU sizes as the
memcg rstat stats, and they are always up to date. Use
lruvec_lru_page_state(), which reads the node counters for the root
memcg, and skip the flush for the root memcg.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/damon/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index bcb6395d9f66..61d92e572c53 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3049,12 +3049,17 @@ static unsigned long damos_get_node_memcg_used_bp(
 			return 10000;
 	}
 
-	mem_cgroup_flush_stats(memcg);
+	/*
+	 * The root memcg's LRU sizes are read directly from the node counters
+	 * (see lruvec_lru_page_state()).
+	 */
+	if (!mem_cgroup_is_root(memcg))
+		mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
-	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
-	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
-	used_pages += lruvec_page_state(lruvec, NR_ACTIVE_FILE);
-	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+	used_pages = lruvec_lru_page_state(lruvec, NR_ACTIVE_ANON);
+	used_pages += lruvec_lru_page_state(lruvec, NR_INACTIVE_ANON);
+	used_pages += lruvec_lru_page_state(lruvec, NR_ACTIVE_FILE);
+	used_pages += lruvec_lru_page_state(lruvec, NR_INACTIVE_FILE);
 
 	mem_cgroup_put(memcg);
 
-- 
2.52.0


