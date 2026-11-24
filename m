Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC5C606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FJKBchcn
Received: by kanga.kvack.org (Postfix)
	id 9F6F16B0615; Tue, 24 Nov 2026 02:51:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6AB6B0617; Tue, 24 Nov 2026 02:51:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895576B0618; Tue, 24 Nov 2026 02:51:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55F476B0615
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:51:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 075E4807FD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:51:53 +0000 (UTC)
X-FDA: 85469243706.08.3E50006
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21466180006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:51:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FJKBchcn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795506711;
	b=o1gGL1R7IMfqQXLpQnq5OJz5yXSz4bbUTHjRMMH9NgtViYsRLf3jpzKo/MtaWAV3B3Kogl
	pgQj4hH8jq5WgyOj2GtG7PreB/aGhAHDj3js8m/gLdpmefzL3nf/20kiNXVslNJN6HsOUO
	CRPmxVwfPceeItwPO9eb14dB/7VZooA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795506711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
	b=pp2xsBm95yhcnKgmfjdFt7dQgCfWu4gpfstNwYNt+/dAuYesaly1cWZe7zSvs+wZAEw4ns
	UQgU9ASmy75dO5Y3Dksz9kEFcA57LUX+Jsmz72zIS07RZKW1sK02cwc3hZZpy6VrmfONmS
	sGX0LBVDoLjRwBDayUf6nVfB+4D/XGY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FJKBchcn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-386c34f07ecso35754eec.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795506710; x=1796111510; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
        b=FJKBchcnKP6ucqu/r1Ui90uVAYyWS4ZtbwDGEUAaQQNEXxJWmSPFHlFJkGdgcEMxoh
         H/oxgZc1n0cDJePLKjbnKCX3obWX6LWLlcNeFlK6KPWrCjwRXv9kePNWnVgabXcQRf4A
         QoZY2JEqrTn+DGj6vp/LBWfuptGo6QF6U2Vv1Tlaf9k2Rz6jUhtp7UWEUcC27PFtzT6H
         5EpIo7l3+XzZc1rmG6jLncMnIh/aJGtdBUiBXBYE8GkdfpORthbxzbOz+I0/3LsVFEIi
         rLGp8xA8p9opb3ipQDKcp5/WbdI+IA8HlBLh0PDH5cuIm790SiVY37yyC69wVhBS2dhn
         ysVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506710; x=1796111510;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=igrsq5xWsPbd0pphtLnGo2EhnP6aWBAghEe3lo+KjZM=;
        b=zmmE6mUntPLTCYLPQt9ORTmRSOTdFyGDvIiWQWVqmXTY0v8nCznSCGKk2aFAHeWDPy
         OoeBhxOQIkXf3GGefTTD5ic1dsi3eiOlsibBEnNbB40mc41BYm+bzuVS4EWOuExi+cym
         xYz8gIaP8JCKo2STmA6jhLzzrBFN5XmRUzCvno+4dNzwWzu34QictwNWPpD50t72rpW+
         OX2Wj0MnwCVkqOBVElw0/vYMrpPBA99dYTHHmecDGczLxQy1iOCBB0Ozl45nCyrc9HmC
         0W+6Xxkq4odYh8PefMQiqTmocIpKZffELZX8e/uiBTlYlQBLyCNPNhYdetq7eMOY1ZLD
         na8w==
X-Forwarded-Encrypted: i=1; AL+hErFSN2HHEIWv9fmHsJ4n12JRdXI+iXT3gu2GOtf9VYml5m5pgMtDXXLmmIncmePtbcatbdkls8AD9w==@kvack.org
X-Gm-Message-State: APuU4Z+Vk0l2g22N9nh4OCIPuiG3cxKWKsQx65O36ptzMDFp/Ccez3cu
	Y6AGnitWTGMgWNgIt13lPQAxCdbNGawDi1GPIsptOCMX7J00WFi4POvC
X-Gm-Gg: AZFdTZc5LQ1PwIhTAu0CuvTC3HekTSHjoRBKqTE4CAmVXC9t3+i53FyJKm800oO7pNl
	ty4s/i00XK2hpRUxJ5a/FkKTXC8C6Py9ozqf4Y8wPTy3E6rfVRvdK4VUrvN+TUedSRVIJeJT73w
	AQW6smS7lBopb75zWeuEAc8SEXo7pJwscLF9LlPMWMmEkpR6CIrCpgZGfQddPOmsELmhwRQsF1C
	ljVm8wg16IbmGBaraAwVPKapk/tvTHshGxth/YBmoEdumJbP7ekZr7l2mDB3yat/RJjMm3MuPe2
	bXLVW6acL/L6B9iVXe+ebn69OEaDWv5ZCORwXdxIqj+NKAVG2aigx6sZjYqxFxbDmsuznzy0xVT
	xjBG5jTkgt/OPakt3IX/9tqa67LxqLpACSeGqN+oAXDWCnzEnKlojOL+mdeCAm/RPqReaba/vko
	OzAJfu3uXzpLKHtWtvNaFD0veNL7DvLUcTYueJhMCiWwQnIlc1aP0SKAKfLQQMB7xtyB4ei66Cl
	Q7wWBgGNm+TXhycXANg8SRntwllLIeU2hhhyJpFzYidKKG4lea9DeBiwza9zg620XL8YCktERSn
	xnYw/5m6GFiumtmfbdAGPCv1svXHUeEWzZs/j4//kH8BqVeZrcmsGi46COuZzib33GM=
X-Received: by 2002:a05:7301:b8e:b0:377:d6e5:e642 with SMTP id 5a478bee46e88-3856e245b2fmr18869883eec.1.1795506709267;
        Mon, 23 Nov 2026 23:51:49 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385666e99fdsm53099098eec.5.2026.11.23.23.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:51:48 -0800 (PST)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Tue, 24 Nov 2026 15:51:27 +0800
Subject: [PATCH] mm/memcontrol: expose anon and file reclaim statistics in
 memory.stat
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-memcg-reclain-stat-v1-1-c6cb14b0d917@gmail.com>
X-B4-Tracking: v=1; b=H4sIAP5BBWsC/yXMQQrCMBBG4auUWTvQhFDQq4iLdPqnjtgomShC6
 d1Ndfkt3lvJUBRGp26lgreaPnKDO3Qk15hnsE7N5Hs/OOcDL1hk5gK5R81sNVZ2CGHy/ZiOSai
 Fz4Kkn9/0fPnbXuMNUvcTbdsXrmg443YAAAA=
X-Change-ID: 20261124-memcg-reclain-stat-1e44d20bf9fc
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Xueyuan Chen <xueyuan.chen21@gmail.com>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 21466180006
X-Stat-Signature: nquzecehnkh317az9s8kgyrfdwm576oa
X-Rspam-User:
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795506711-643107
X-HE-Meta: U2FsdGVkX18TFWfiGFRypkskpt00XE7mSbLmxVYZEX1ikILkoZDUYnI0KyK/uPqJuIoohXDsAOdoo1zO6tckSFYz9+744p8/AO9Vr2jgB/dkwE9CWtw+IRm1WN33df+LP/x9abehOHH2q5omMEvFQ3Kvs6m7z+TGh3jJLjk92zUiMzN/Tsii4z95iMPnE303PGrb2it/quuOSmxqF+J0cY8QTM7n1ftVzQmHgvJbMYO872lpFqZMHoGH05Lghxkovau2vtBuRA7QpE4fxA2njCLtqon/f8lB1ivkwfGVBACI+DhKeaEGcWDGOAQPlQN0+FgFb9LT9BxshyXOvonAGpAI9QAZHFEri+A3A/VGoLidQIi/WOkIx9Nyt1jV+nyRw9rXRenNCyJ3yKszQvC7dqxpBFleyHlqXS71SRyJgoSVd9U9/y4UDpMjwrR/DplH6MLQJF5ytLiWnBXsTb+6BcCsxLfbYXim6Lagr43O+aPRzlQ8SrFxlsGkOoeaFhO7+tg4cVQYxGkSxxOmduDE+a9HtMDdf22J/2JZ/x/t3JJEjLSwFdlD7fyAclhFmf2SWdlz3oA/RmkT+W5K8eJMm0CKj3ZMT6HplAKx4V8fTdmc3lCJBZ0a4kntYkp+fwYNByjQPGADXP0h6cSMDXQFUbSiyk7IjSOp5QZ9KW2u3LtycsspLWY3peXOKAHMVgKRODpj4c2phm04KTGAjSouL2ssgSJRrMboxA6rgmYnNF9qRCg2JKpJzPWhXaRjDik0+OwYddZHCx6GMwm3yUKI527OwrFALWlpyH4SB5Qp3B3m7sRICh7apoWByffa+sht2CvlKH+bHoP6tU/E7aZgdYUsbP8OD5xwAWTmJetT3DuvhfzkcfGtirs3VP8bUNuVFfnNkFJmDRUrbOhD64Uyv4mDeuKhQrc0RPKLBgXo6V+yff7iZNL4no7/vQn+sYTW9g0+aduD2+HxT66KdT3
 m3/Qxye1
 ExQZNty4xtpfo0nlKlXSxdbnHme4jvDJOIh4P8JUATbA72DeF8Gp0afTXSxKoqT9DO2EkqaXkyo7U4J7d9lfVA9OKMOTOZYJyHqqXtHOi41YTs/huujGMjEBol8soEJTN7cdmqn6oGqBOVQfIizkCjMIZ5i/jXd9Nn8MwErf1h5GXEJViTJAleH0HK/OvvhNYM6DZfaQPxe+bIoam1BI/USx38gKVQPiNvkyK8YfKK3IqWgO/wzW6gYMFbhQJ4mIxkCfteBKpLcpCNlPN980rQiu3dQaszogimPI2ASK9YKr6Fh36FuxqDitnkwp5f//n7h263tagqOhPOiCL9rY8jdFxVnqqQ4bCUxzI1ph+bP1zNOpeNrOIrEY83zO1d8F/t3BCX3HbEu6Qv3eAa2cNonJrkJgPfc2Smls0l+CrlBRqXncivKQ0UX5gpUbUhzeEeyRvS2aeOBBZ6viwf2NCHM7e7MSl5+FAZox2p+gU0nQvnv0ChQJeeEqYnKQJzcltGBPajaOZSe2C82zGcdqx7qWJIUFYFvAmrri2RSjvlqejM4p+jFHgYo/09pxcTqGHKv+9WeNkPuuIRjgO9+/Pu+Cf/6tOmC+wWqUq5LqeO8TSsavFbDtzD8ppUl5L/VM3mBI+FatA4yukKPIER6FzGoLJHMp01FFgOZXx9d/Eh+ZVTb8W4snNRuZeyi7TZAAOIBY60OZzCLKXkjuNBPgLqwDGtagX4to1K39A9ufcNvIOxWEf6X0wpCPXCWK0/4P3S+5c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The aggregate reclaim counters in memory.stat do not show how reclaim
is split between the anonymous and file LRUs of a cgroup.

Expose the existing per-memcg scan and steal counters by LRU type so
userspace can measure reclaim balance and efficiency when evaluating
reclaim policy. Report the same counters per node in memory.numa_stat.
Both files report the counters in base pages.

Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++--
 mm/memcontrol.c                         |  8 ++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..eeeaf635754c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1726,6 +1726,22 @@ The following nested keys are defined.
 	  pgsteal_proactive (npn)
 		Amount of reclaimed pages proactively
 
+	  pgscan_anon
+		Number of base pages scanned for reclaim from the anonymous
+		LRU. With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgscan_file
+		Number of base pages scanned for reclaim from the file LRU.
+		With the multi-gen LRU, counts pages isolated for reclaim.
+
+	  pgsteal_anon
+		Number of base pages reclaimed from the anonymous LRU,
+		including pages demoted to another node.
+
+	  pgsteal_file
+		Number of base pages reclaimed from the file LRU,
+		including pages demoted to another node.
+
 	  pgfault (npn)
 		Total number of page faults incurred
 
@@ -1829,11 +1845,11 @@ The following nested keys are defined.
 	application performance by combining this information with the
 	application's CPU allocation.
 
-	All memory amounts are in bytes.
+	All memory amounts are in bytes. Reclaim counters are in base pages.
 
 	The output format of memory.numa_stat is::
 
-	  type N0=<bytes in node 0> N1=<bytes in node 1> ...
+	  type N0=<value for node 0> N1=<value for node 1> ...
 
 	The entries are ordered to be human readable, and new entries
 	can show up in the middle. Don't rely on items remaining in a
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1ebc9330aeae..ac12ff69a633 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1647,10 +1647,14 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
 	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
 	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
+	{ "pgsteal_anon",		PGSTEAL_ANON		},
+	{ "pgsteal_file",		PGSTEAL_FILE		},
 	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
 	{ "pgscan_direct",		PGSCAN_DIRECT		},
 	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
 	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
+	{ "pgscan_anon",		PGSCAN_ANON		},
+	{ "pgscan_file",		PGSCAN_FILE		},
 	{ "pgrefill",			PGREFILL		},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
@@ -1699,10 +1703,14 @@ static int memcg_page_state_output_unit(int item)
 	case PGSTEAL_DIRECT:
 	case PGSTEAL_KHUGEPAGED:
 	case PGSTEAL_PROACTIVE:
+	case PGSTEAL_ANON:
+	case PGSTEAL_FILE:
 	case PGSCAN_KSWAPD:
 	case PGSCAN_DIRECT:
 	case PGSCAN_KHUGEPAGED:
 	case PGSCAN_PROACTIVE:
+	case PGSCAN_ANON:
+	case PGSCAN_FILE:
 	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:

---
base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307

--  
Best regards,
Xueyuan


