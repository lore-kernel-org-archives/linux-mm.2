Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8A1606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S/g58O8J
Received: by kanga.kvack.org (Postfix)
	id A46F16B05B5; Mon,  9 Nov 2026 20:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2166B05B6; Mon,  9 Nov 2026 20:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A416B05B7; Mon,  9 Nov 2026 20:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD3D6B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:54:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7D5A1A083D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:59 +0000 (UTC)
X-FDA: 85417538598.21.70F022B
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0DD04C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="S/g58O8J";
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
	b=ULTKh2ID4HYO8dAeD560Xm5AnufIasumc0S1M/M3epgS9RrhYlUS1E/hBmTs1SjcdYWzwA
	ortYQl07+czST0sTBWkIWkG+aQ3Sc7qIY0O51qIhOlIGV5ZRLq/LfhZoB8JyeO2jyj32YF
	fqmxxCMF6Bk8yNNiVZLgJfowWxK2o/s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="S/g58O8J";
	spf=pass (imf28.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275638;
	b=FwPnit9oxveYMcFYezIoNEndGt1ikTJX0HaC6k6ZMdmyGoLlCoUrJcqhLAtyqEpvQJFZiO
	0aWbEoURAEnze7cQqXniBqivok/CPLW8YDcdDp6j9CnSGOmolQfLr+HgwYjVPWrO6EoTNS
	OH6hiQS2CJpQej7b/N15j2JNd+cCayg=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0b3438540so958843a91.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275637; x=1794880437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
        b=S/g58O8J9Bdz1syX1XfP6Oc5KlL65PqGH5Cn0gUOVuLYKgFUF9GVFrJBvDhG9lve9F
         MYWQkjitbI02QzIb0saE0z0BethMZ+zHeGT6tCWn+OTB/1RRPi3YaxWGtamv4hTLAOzv
         CgOJDX0FcGoyTv+TajSdsG1c741u2Vfd4lIt5661r9VMLLmF/mNOXYG81yHaZBbxWRvA
         Z+1iX9PiIpUMViWFwj7yoRGK6A8P8v3horl/0EgMCrKK/MwnmElzsHgpFPlKq3p3HdLn
         p5k9dbo5jmccVYr+OAZjtxImHq1Eoiy6xy14SJKLc1mP8rLN+kWgL6NRZnsAqI1sv2ZE
         0qwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275637; x=1794880437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8I8d+hDMqZ6xVmUygiM+c57kytjFuIQN7v7mSubiZXE=;
        b=db/3K6v6QtPjxEXJR71L4NL7q1LgjuIX4qVb275dPFgGpz3FiI+pNI+KYCsO3IhlgD
         hdWrp6N+UPp9EalXi8SlQpROJ1OT8zjQnpgxHUlXLZI/qI2orQadq0IZZ3u4224JvQ7h
         VX65sG8bFYCU0ENOgY+dhWf+9S3FPq42Ox9hCO+RrPmwlxvq7JvXCetfi4OkgCBAwH85
         NZVbyfR78K5ePgu3e0P6w1cawrKTlwt5GZzaG5kqwkYHc3GjQUyfGvdHLshSWPlMAFIC
         Glajk7kzWqPydR1sSov6f5ZBigZgojV33aq9B0H3paqwKFHOvMjGkJa51Ri0AL5Rfcxn
         fAuQ==
X-Forwarded-Encrypted: i=1; AL+hErGfz6FUd4ObU6vaPdJOQLlyyZTIlzD9lRgC2cVapWD+iGsjJARU1QZxrYMZ1WdGDlTL6KO3M5ns8Q==@kvack.org
X-Gm-Message-State: APuU4Z9ifESUqcocSRhEJgz+cstj/U/aXMBi5dw35x5dMMTsa3yNMwTC
	+dU5FBiSfsH2AevMEyO7CxFCYHgUpQzt5vaKN7inXsF0xpNacFFV+yls
X-Gm-Gg: AYBFou1b4HqG4AaTFo3hC6EY6C8354Z6wJBC9YD9WipPi26KaZQ4iw/LvmLuNj7bFNC
	BVKPylxF7RPl3LJTWIJ81KycRrLc4ZWiZNvYK0z6OtuNGeQ3Dbi1qyVvWdShZDBM/hRptIWR2aQ
	RAqBPibBPz70t1eM2Xkr8EnR2Ouyv45YspS1liJqIuf1Au38CNaVTy5EU/ftUQiuHDnPq0g2M3a
	EvO2yRNOROxrIAyqaCdsuX+85ZkW7X7roEuGgW730PlGuf78K3P+DDpU3UqRGIOTPQ7/F94+vu7
	5SlDw+FFYIdy+tZPFDyaKImEHDvD37+ckXIpp+22FgzrPK5+5HTuvcFqsD4ZftHxcYjcPoO7MX6
	bvSVbHP4pfvkmDsd8VzclFgblpnBmxnxijahETkhbXjOwugvXMlg39UVyYVq5IC44SLMbieR4sK
	Ule0BcIzJJexLizfJLTE9hNqAUGnVNa8tuemLWL39IeCUWsN+b1jMPdiw/Vo+4RqPGM2OAK3jx/
	UcLzMLvl61go8k0ZEIEP1PySFwsDEJnjp6itUSfaRmAlwuutI97RriEvBwYnV0CmEm5ris0hX8w
	SyBqjnfFVG3gvxVjP6O5qdEmy11bxRUuYgniiwhSOrbZM5668mgVI/p+Urd5tn5M3wIFXs3pRxx
	drhIaSQ==
X-Received: by 2002:a17:90b:5848:b0:3b0:9976:c1c6 with SMTP id 98e67ed59e1d1-3b166e38ceemr1381590a91.66.1794275636884;
        Mon, 09 Nov 2026 17:53:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:52::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168acaf41sm564784a91.0.2026.11.09.17.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:56 -0800 (PST)
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
Subject: [PATCH v2 3/4] mm: workingset: skip the root memcg flush in workingset_test_recent()
Date: Mon,  9 Nov 2026 17:53:20 -0800
Message-ID: <20261110015321.611093-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6cky6qun7g8hzsq43fh3iga5yy51p15e
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0DD04C0004
X-HE-Tag: 1794275637-162566
X-HE-Meta: U2FsdGVkX192Qu6MZDfeAYXrpPelKc38ZC83/zukBShndrUu3V324YlUk1JkmkqVRrA31LHcxFgga0os6hxX5ZyUPKc/kijJkn6/c9Rzvv5Xfet6oAd4xZyIHe5RhA2EfVCI8uqyWQr2bKtlZmra8vulfGtpiHY6J3Uftpz/+ylKFfAeysldh1E2uFC8ke5w/zVS7GqoMXOxBo54FD+GXWauPlENxthbsmnfCF5HG8cndk3dxv3lTnJ4eX7C9S9MK7NMLl+PTRiM7zPUK7OQQdYNrztKSwnuU3+OoAUJs2eS1c2ZKzUz6mckYgdOsz5R20A0BlHffLiGjZgkOXmbUCsG2Bj2oSV7sRJA19nhXYfW2a+2mXE7HpKS8gkuNUBULcvuFrK60VLJpFhaCr7YwCO/HNEOljEb7BHutisPeEmR69jQp8mBWKey/EhR2ljdai0G8tLMVp+j3DQjOnNlCQ2TtZ13PQonqFMIaFWDxidpycRufCoY8537T1B7DyNsNGn96dJoBacM65jtf98bdqgKnL1J7Fk380pjLwah1JaaaOcwQpAA8JaHyBTeKwT4/RZdsQoVY+wSd+NBMUetWeGStid66Gpnf6fRh1+yHqNp7cRfXPbVq/6h94/2ygiBGvvXge6Gw6kLnJqeo/wl/8tCRBW0Jc4Gi/LCoUYqsCBev6l2XS0qHi4KBRBpKD6UI/xZYyZuJ+k3UFtFH3lGHFUOz3sffvPaXwB7ZCFZwKdwa1LOV+W3J1gBM9EN/0hdZbiFU9GOMG6eYw03eWmyU7VoZqSA4Sm1q/tjIxDufRlt9qIMXl8ywFD32cBCPsqzWfRTXPcWsM7So9Li28+TVGVxFwvhUa24rbtZoF7Td7ip+w4NaPPyDGRPPPaZtj7wUNwB06i7MbhU6X2IOPgsFmwJAqx2rofboXx/0TR7YLgUJc/FcN05cI7hWwwnyibfP5oAB2W7gcnjt2HwR6z
 SF8s5cCL
 zqWAWLfx2K+XoXgwqNMpOHH2Rx4G3E0wju+8/1/99a+pqLw/XJG88B6hMrmb1vKOwZMOU/A5kcqQvTt7C9YBqh+N+HGs53eVE38rmlgxTxVb/gmdbnBlmLKHAEPZRwjwDXjLOhnpXRjANmMGKF+4f5DMJg6QyHgtxuinadqZUhis6SlgioPowoos9QNj31KNV/kCjIfEsKIW2J3nul9G9/oe7HOF27LFKDafP+S9RFYmZNViSwfENMqKGYlMXS576Ivai3ztDVvvWHr6V83d6/kj0qU9DYBBy95xV9xpl4Bch2CFtCyxcOQY7JO8pA8YHPTBK1DRUcQxFDl49+NsE/Fh7Z5/DwPqnADFqYwi9Bawomo8hCOmvfFgtwUWtcZLBWMCynGBinEmtb3ZrBLTOPvZoBgDdHkiN3ij0qfA0ND/3UW2EtkRBG9ekd98+bDiwGEHHOaOQTK8aZn0ltgtWVi69KzBIeLxaVx5CrPCGjLXZeEfEQ+k29qMEnUhB1ExgUiFBc3ULRPxDKkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We can skip the rstat flush in workingset_test_recent() when the
eviction memcg is the root memcg. lruvec_page_state() now reads the LRU
sizes of the root memcg from the node counters, which are always up to
date, and workingset_test_recent() only reads the eviction memcg's own
lruvec. This avoids an expensive flush on the refault path, as flushing
the root memcg flushes every memcg in the system.

For reclaim however, we still need to keep the flush (for now) since
global and root reclaim also read the rstat stats of the child memcgs
they scan, which the flush is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..383f951eaad4 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-- 
2.52.0


