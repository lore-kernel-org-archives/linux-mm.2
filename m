Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F67CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 645C66B0093; Tue,  6 Oct 2026 02:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E6D6B0095; Tue,  6 Oct 2026 02:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5342B6B0096; Tue,  6 Oct 2026 02:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 187986B0093
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:17:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8883DC0555
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:10 +0000 (UTC)
X-FDA: 85291193820.23.542A278
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2977180002
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itqF2kRa;
	spf=pass (imf16.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXj+ppi34PaHFxHHINamngQe5IHrKp/NnyfjPYvY7jg=;
	b=OL1UVWX1L1GdGfFaru9nAsNzkzAd9vjkI2w1LBXHDGR/Tf9rrW/YkFTv2jqKPqjcLoKlxy
	tP7g5aD7yA0hPNPJuJmJwyz1STbaB+MrPXiBkaeVsFxaBMcJZiBED+WKvI+C6yMD5ixQle
	4hvrUL8jOGiWP5+rJo/F0KN0st20KFc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itqF2kRa;
	spf=pass (imf16.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791267428;
	b=6XlkEoaZkmuN8YruHHmIQcTInu7PTdYmm65ntrjVAx8tdj1u7lZB3214WslfrxzE5joUNx
	chgdUBQB5eJnbQLdK0WtMfg5nOJrFFj51g6uVYKl551xh14f89T2HIUJmpGO4+PNK5Yx+R
	64wiXNiRxOyna0h9tU9F1yOjh96TZGU=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a7d283e017so1451352a91.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791267427; x=1791872227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kXj+ppi34PaHFxHHINamngQe5IHrKp/NnyfjPYvY7jg=;
        b=itqF2kRav1FVtvUgKrrsb3ratQNrpnLAQqSGqPEOdRqTL/kSoBFvLuCjZNn5i8Hhv2
         q+9n2oghV2RTBmU/H+bAbGcJY/OaEV5BOCph0x4TadaQ6gFmscxBHcHiUSK369wCd5Wj
         Z5aNcOGXiR+SGc24pgIJHFxRgx2wZ2uMXXj6KNoMg5PMsbk9Tp1/e+Dnlp/tvTYpj5l9
         kpdqm0xfA7nK0FTyvPkkasdnbII8sL080uLC2A7iEt91ws5yHtTGoFFDqjUlPGSJBxsh
         UMOCdkfVinaf0b2e2/q/DyPo4tnzcETE1YsoabFXtx8Ma8+OW6w9e6kG7OIar8IXFXiF
         IRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267427; x=1791872227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kXj+ppi34PaHFxHHINamngQe5IHrKp/NnyfjPYvY7jg=;
        b=Z2Yk9mQxIC/Po6vKWtCCuQ8Ew2lS11WmoJ2/4kDNiZUdjq5eymvvNU8QOKWH7FUBPQ
         lSS+LLSKA4q5lmpmxEZvC1vLZslgvAZrgTWVO9e9ctezi9067KH8gBf97Gxx//iQDJdr
         o8/FEKbSXOOoa/j6rUigjhtH4X3d1yCuPXKVxXmlsrDnepEEiDp05A2r5U62N+L9B2oj
         7Yhe7+a5rx2HqlKUl4n9XaL1jLix8DXRsY1jtt39itChAlIwnJF0bn4Ek0ydudA/w2kg
         cN5+DuaQyXP0Ud293UetbGGAgOUBsVTVF4w2qP4QwIv6b5DsHR9wjzBMuJsroII7KNK6
         S5DQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkGabvzQtuDdRJAZPJWR26mzd8fFXmp3/MQskfCIjz4VAxCOlhMnhzhqeIeomUCKT0z/kFEpDr5g==@kvack.org
X-Gm-Message-State: AFq9FYKrrDLSZqgoTIyGmTyDzQDgoz+4wnSMlZ4m/umPBE7kqfCiOf+o
	gag8qg3EcxLjeQPVc4Or7Lq0nfL/rgYXhgQVnE7fL3foelZXSnW2WJN5
X-Gm-Gg: AYBFou3tG2583bH3KhR3x7jLZLeN9d4c+H8CybARO12CYy3iRH5lUr+/Iqd+bLHtAiR
	ZeN3p4f0HdEuXtvgrjsNF/+VL43UV+PfRLF81hpJWVGbxCQ+NKx1KoTjay2htmORLa0f5Dwt+IX
	ndBI3faZorHBpkuP1nCX96sKohsqTCvwKZXPQu5NBuIrl4KnD8KqtbBmAMZ/6u5x0/jhQPzOArX
	Q3w0TWW8l7hz4Xu2St3UgIO7p3MpD+a/HZxaTJiqUgsUB0TQim14CiC80I71tb2SFXs5Ic8cnLW
	2bH/mxray5Ru3rDEsnvAzXVCo3rcr8gG6LELFtSo2/QSXUJOSfWx1SOM93xapGfUGXfbckl+C48
	7bTl8sO8CWr4f22s6MLwg00YFyf1tMcO3rSMPJQoYXomCFounvHETjYVsOQx34j76U2jlNdinYJ
	OTUrw1cZ+PNLhaD5hETYYjihC3/G29QX2KuIzQT0QWFmHsx5+tBK5HkS56fFoyhYtCXbB0l6WQ1
	n/DgPcHd/p5rbFk4dyYEoqyNmeLI9Xr4d9FSAotjC2WaLAks5DKvcMsEYQC0tscsGI6aL7/WQfD
	gUX9f0Ge7iPCbOjC
X-Received: by 2002:a17:90b:3912:b0:3a4:bc68:e867 with SMTP id 98e67ed59e1d1-3a87268878cmr360148a91.7.1791267427477;
        Mon, 05 Oct 2026 23:17:07 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533aba95sm3662789a91.2.2026.10.05.23.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:17:07 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 1/3] Docs/admin-guide/mm/damon: Fix various typos
Date: Tue,  6 Oct 2026 14:15:47 +0800
Message-Id: <20261006061549.627-2-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261006061549.627-1-adrianhuang0701@gmail.com>
References: <20261006061549.627-1-adrianhuang0701@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B2977180002
X-Rspam-User: 
X-Stat-Signature: uad5ric3hspxbueir6h6qm3eguoim3gc
X-HE-Tag: 1791267428-968495
X-HE-Meta: U2FsdGVkX1/i6NSO1Y57SUt88V0MXqhMXU3zpDuo2JAf+c0Q9UqrHN8LmKhridrWsZ6OIsf8Qoij1DCL6YtFUq3PfLARf0kDiNyGVtS4aDIMxV3duqci2p2sAKu13hctjXdnx+KvmHL2s5SbITcbmDzpxGVmt0bDOSZXCxefwsGheVYMon194jkdSLx7WkV+wIvpoZYXsB3ZsLj0gqBtZjuK5l77k7DhxzS9qpW0bjoB+2pDXTYR+crzZUwqtw5hpOJADoaoh58cAKM66SbQJ+23WldrbvF6M8UCTqmrfA89U2ZIjEQexWIncxZ+H8G+uWlS7vxhtiryTfEKn04ZHHvQe8Qbd9ukoy1ytQsxGGyO6Tf/bDFl0EICVkmDa76fiqDv8to5A/+Wj9vT2JTJjGfMWWJqtWYj+j9AU99y/4sOYaeGHC3n9qDXPGZFxvwoXVV9hJ+eesZluIl1Vz2gFynAGLDL+h73ihh9KGBaxF1KVkrtcqo3WRkdHGYE3AM4duVzHDeGyyPlgZlL/H6if/D3GuzAKmLPS7ARuZ9Yk+4wbmPKGmVieGMWpBREUpUZnnyupTKpOxvVHPelacRN1mGi0gGORjwS2yO5QHoqg2BfAhMmCSi0F+9tvkST3NENkvjcElSjQPgEgCLl3aZaYdvm2jfQrmgo9snxOSSCwLGZgyjvOJtGvUkBEVBAJdYUQOZfYH0xVyS/QTfbFROgMwp6cWfN57ekKRZEBAc8bqfhk+ykt+jcuxt8bhnla5OUFVTA5yRWHwHm4ARatWg0BXaD+5ooIqNfM19jtcgBxsaQPLV6AA7kiCRe2bdaNBp1I3cEZ7a8x+UhGDrZtMZ+VDtUBFsi/72rgzExqdKPyj9gyyS4GwWGar371JDjc9d2pLS/ZxXeHKPCxUNrs0R+OlMnKk1F6Tp/qocfCOR3bQ9wJNcC90zG6Nqb2bMHm/+35XZByPV7yw6/E4M/kIA
 cjJ+IP3E
 2ufttiCJOrgHwAHn9zMCwPlYcajZbxnagdl+xjH4yOd+457WzqAzp8CuadKwED4SED5cAObkzcO0uE+w8ItgPK7ZhPOj7MHFucKnYWhfSAlsA6/l+A4GhBR7pfy9oYBNBlyslrSKVgsspHm20e4yykO2ms1pLASWWAvcvVCpWBxfh2Mkzr3MzfHgWdBGT4bHkJor4XWAkEz17pV05rQhqcnjeoRz+f7QoFeh+S+Jk3iQkMzCEjedAOZYGSFcS93fRZVnNwgYRw+XvwMXwznX9r5+X3QUJ78KOpteI06bjGFDr1i++0u5ZQuV3TRm8FdAXKzFtn0Ye5vLe/PJ4dDlc/uBbPqYKZjmXr79Mg+R0EzF+5QjVOzfRGjzQy396+khgICGcFtzrK7z4UvBRP7nUJI6JnR4H/Z0yWkDmakgkdOe3M/YNh2HiwIWvlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix several spelling mistakes found while reading the DAMON
documentation:
  * trusworthy -> trustworthy
  * DAMON_RCLAIM -> DAMON_RECLAIM
  * charget -> charge
  * hetmap -> heatmap
  * colun -> column
  * evelenth -> eleventh
  * idlee -> idle

Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++--
 Documentation/admin-guide/mm/damon/start.rst    | 6 +++---
 Documentation/admin-guide/mm/damon/stat.rst     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index b93ca9b0853d..c3b688385681 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -7,7 +7,7 @@ DAMON-based LRU-lists Sorting
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
 aimed to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
-trusworthy data access pattern source.
+trustworthy data access pattern source.
 
 Where Proactive LRU-lists Sorting is Required?
 ==============================================
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index ec7e3e32b4ac..e4e2ffa52e26 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -55,7 +55,7 @@ enabled
 
 Enable or disable DAMON_RECLAIM.
 
-You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
+You can enable DAMON_RECLAIM by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
 no real monitoring and reclamation due to the watermarks-based activation
 condition.  Refer to below descriptions for the watermarks parameter for this.
@@ -125,7 +125,7 @@ quota_reset_interval_ms
 
 The time/size quota charge reset interval in milliseconds.
 
-The charget reset interval for the quota of time (quota_ms) and size
+The charge reset interval for the quota of time (quota_ms) and size
 (quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
 quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
 milliseconds.
diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index ec8c34b2d32f..d98b0eb8e771 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -69,16 +69,16 @@ monitored access pattern of the process from DAMON and shows the pattern in a
 human readable format.
 
 The first line of the output shows the relative access temperature (hotness) of
-the regions in a single row hetmap format.  Each column on the heatmap
+the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the colun on the row and the number on the column represents the
+position of the column on the row and the number on the column represents the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
 
 Each line of the output from the third line shows which virtual address range
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the evelenth region of
+accessed for how long time (``age XX``).  For example, the eleventh region of
 ~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
 the fourth command stops DAMON.
 
diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 46c5dd96aa2e..4a9db755a526 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -81,7 +81,7 @@ Per-byte idle time (milliseconds) percentiles of the system.
 DAMON_STAT calculates how long each byte of the memory was not accessed until
 now (idle time), based on the current DAMON results snapshot.  For regions
 having access frequency (nr_accesses) larger than zero, how long the current
-access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+access frequency level was kept multiplied by ``-1`` becomes the idle time of
 every byte of the region.  If a region has zero access frequency (nr_accesses),
 how long the region was keeping the zero access frequency (age) becomes the
 idle time of every byte of the region.  Then, DAMON_STAT exposes the
-- 
2.43.0


