Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 207DEEEB573
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7386B008A; Wed, 31 Dec 2025 20:39:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8774C6B008C; Wed, 31 Dec 2025 20:39:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791406B0092; Wed, 31 Dec 2025 20:39:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6769F6B008A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:39:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B2D0CDBF1
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:15 +0000 (UTC)
X-FDA: 84281687070.28.CA660A3
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 40F3B160004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:39:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g42Tynbh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767231553; a=rsa-sha256;
	cv=none;
	b=aDLqxeo5m/lt3mYzlVU/HnR+TMitNGrfYMl+UfUCVt6IvrbszYLGTszC6g8dy1doXWzc6a
	CwZ93OsUAHWlYCUCfT7+1YzdlFwnss/dz9uRyD7hnpA/E93ldffcS0/dog0CH+odW/8M5W
	23Uh1eaqxsb0G3GDIQ6o0nmpfUAc6Wg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g42Tynbh;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767231553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTpmjsFfWGJYXQ4+Gh1GNQFtrEKxgP8Pana/cMDdnXc=;
	b=0t2PqRnK3nHOBV6VNj0fsrpgptIDfw5+qohiEh6/3DyNt3zVBrxt9QlJ3U6ENP5bnHOcDH
	hzI9xA8hzddKSgUwf3jLM9LVVbRtRz0cDsiSnez2V5F0zERYSVNeKS98EGC+PXFnlTATJl
	OmhqbV4aDbjnRXyZJDMuTXlRV+YHb+Y=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0d52768ccso139477035ad.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 17:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767231552; x=1767836352; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jTpmjsFfWGJYXQ4+Gh1GNQFtrEKxgP8Pana/cMDdnXc=;
        b=g42TynbhGms1miS9jDtLWXt/liSg8ip5fBEIekfzOesPZTtTCUYDBIa9h8ONOOeJ34
         O6Nvfyr6YbAxSVyg5KDtt0VTqJZcoOYuVkdcYXhjwTr79n5vRyDCxbVMCtpYyfafPxU6
         L6R4UUylj1RgHmlWB7HOBmtdk36WP0kLYGhYg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767231552; x=1767836352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jTpmjsFfWGJYXQ4+Gh1GNQFtrEKxgP8Pana/cMDdnXc=;
        b=b8kuzMt2OORIfIAqwN0qLlQ2js9OP8FrWSABnFrWrZqkLY/f9QScfIg6tpJefNXH3g
         FgAVuFHWmLo4TFV2ArTif7rU16gFrcWs0+5nnhvT8J9ULmykXKNMNhuYHtft2J15FEUR
         6U+jgIjPQt5y6b2TRBzUAKLrB9Cqgxzt/kC76LcqTPKB89mmvR89RBPhvdoPt2NKcIf1
         ZprU+T8hnl8UGJywMKi3BsA3ja6bloS0l6aMc79cguVgmh8YG+/X32i/f8OiXWMSo71L
         qn5Kvdm0Rv0iQLcnFXvu2VCIeRNri3IhcXCGET7/0v+LAmLHyHdSekTtEd8IWHGjey50
         dJWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOnbz1MwSpl+Obu5cSAyWId6BrU0Qr38djYk4/EVV82DSYVOZvGasbfsByOPpuLGtGs7Z96BbGEA==@kvack.org
X-Gm-Message-State: AOJu0YzqXh7r6Iu6icFNc2sHdDh+NJivr0da8o5ehxjXSWMQW7I7y0HX
	3WS40zLG2IXHJKn4hls+F1B95+o2KGq7F7bTEkihxLb4tZ/AzMA/O3ssTTzkdbna3Q==
X-Gm-Gg: AY/fxX5/8OeaEMt1M4uFOm7OgZuvbRRwLXHE8kOrUs67rdiZ+KrYByPkssOrxtC9NL3
	wkupZUoypTtpfV/sVzotZ5X8U33XftpTrkxGvw15uhIC3CaYnfvyICLoLMf2YkZz6EX59tWgx6L
	DOWk1iTt1QdbDx5S05QWNwKtVKY5Sjf9jFiNPQ0HX2DdF51usuD1Xk5jAcQsKQPkS/WM9erq7Qp
	E5Uvh+IGqvUy7K8KcLaN3ddU1RnXZeQ76D0Z2qO15161F9qaGbAEYVEJRlOGe5NKNw8OTKdeSQ9
	nX1VXJy66PoITtcWMyLOjgs2RXmY6jLvKAEk40rXarTzTBC8yE5y0e59B8AqE7GXsuC8XVVbsmf
	US9urzwwVWBKXNWp3SnXscdQ/Ef7GBwOen+r/Ili3AYnlkiK+tI+FBYB2LRKDiGS/WKIYf9wh9M
	Y10KLzcKPRfBjEMLfrGrbDLxyxt4mKOaEbMVZ1NpqLynPCFm07r/c9cYzAmIDa2QS7nnjho2zKE
	tiGZIotXqJK
X-Google-Smtp-Source: AGHT+IE+BHEISzORLzKURPdWIV/MJpQWDSfcxMR8GTirgm7X3O11dg1wbOagPCX5OWb3Oqc/bYukoQ==
X-Received: by 2002:a17:902:f70d:b0:2a0:be68:9456 with SMTP id d9443c01a7336-2a2f28404a0mr372520875ad.46.1767231551884;
        Wed, 31 Dec 2025 17:39:11 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8d7c:8fc4:6773:1d38])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c14747csm30972091a12.27.2025.12.31.17.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 17:39:11 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [RFC PATCH 2/2] zsmalloc: chain-length configuration should consider other metrics
Date: Thu,  1 Jan 2026 10:38:14 +0900
Message-ID: <20260101013814.2312147-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260101013814.2312147-1-senozhatsky@chromium.org>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40F3B160004
X-Stat-Signature: 17w71ok6j1fntibki48anea6n8tat86r
X-HE-Tag: 1767231553-784659
X-HE-Meta: U2FsdGVkX183KYy3ajqJPN4zQjKDrQJK/M0j3tdtjiCrjVel8OgqBMJDn656cNKpydGjwsDE5+Ob3gXUIud9IRa3o32bMi/3h88ACz+bSjqYali7NBik+mdwk5HuUY4hJiEdOcUCuCEGC243mQ4++UTPlvFEyHtLUhmwnzR8mXfMHwGEP6+xSI6ujiJg8ozvwntCIO1ET9hMikG8Ptdh6IzRrtYNYmTwudj0Z6jynIUxsCuYZp9NDU7tGMMz3ZOth7XQERNNoVtzz/XamGj5DMbEuCs8ITpot2wMOYqYYkVkrqZd9WtLMScbyojFJRKY9tmyyu6Esv0dHv2QqBDCA73uVZudWvNFBmIydNhcVbzpFj2fhymvq4h8KyRMmT8MmNrBEWg4YqaA6T7K/Ejw8Y/1vZxvuNPJBJ0ttOcCULa0eMJ5T7/e6GyFMHrbI9wFV37S/JFX5mKvzybg4wBlb5glh0jtZctUiZCmRzyG1QecgrvNtLLwrEknHPJ/3KKOTrjBCFDrBvUG1NJNB/NpfTlQ6nAqEgkniMktJLX0pFkV5v0x6z1Ba1vk0UeXDBlb7jeSv9weZjhh52PsfBS7TI9eAj5JYx4CnYBwOAD7q+ZKuRzW6AQ0tk6bPNTzQT8dg+F8rgNm1XZ+WML2cwihzwLkSvzTfyVjhyHxqK5TRbSA7l/qLfoKLkdakaUqIoGWzyHu2U7xV4XQFJLGTzDSZvmUngdXKzt8u4WcVGbC2JL75qShkUqxXzOv/j4TKvu1UspYYr4/59gQ5MHm12qHqtRzPFYWEDa6HaXQ97UB4VJkXL88cmQwEF5OECYV76PBcfpGj/eiSX3BCl+aeqbx6krL0XEhfSQNBcX3qEzyWwDpuRi1ywqW3lJVA4TXH0w5Pm17RHggh0koblz4nT4MlzG0X/P4I6FLl4iKtH50gx4N2kGMynF3uc4LFik1APetQ8Ck/q4MeYQaXq9KhBv
 BJdM6T3C
 1VffhAkrBvSL79svE8q12DKjjBLrTlVGjzJGB8jq4D7wYvSq7i+IGonDmxF3JwpcRUyNLzMRV1Ww6xZwNPaYJP9xTLbg1+Wuy09dJoWI7RlBNUqXxDNWcV2fmQtdrLuAfjAMbhLZlUDSM9UgX4ifeMAmu7WrYntcFHQ6Thg+6DOsRXY1NTbqOqLhEM7GA4HdQhwduCyO8Zxl+Xf99AYP5cfAJXFKteCPr5f1yAmupvuz9KAyBOcgy5k28p3XNV1Y0h+ZA9YjVpCpmrcZg3q4Va/h+1Flnfj7q9EYLLGcd8sr2egsNWi0FF78HA/ITbX3Qpw297dvvPkZMRdwBVPia0L+zfWSxBMRlhaeDRb4qFbmq80k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the first step towards re-thinking optimization strategy
during chain-size (the number of 0-order physical pages a zspage
chains for most optimal performance) configuration. Currently,
we only consider one metric - "wasted" memory - and try various
chain length configurations in order to find the minimal wasted
space configuration.  However, this strategy doesn't consider
the fact that our optimization space is not single-dimensional.
When we increase zspage chain length we at the same increase the
number of spanning objects (objects that span two physical pages).
Such objects slow down read() operations because zsmalloc needs to
kmap both pages and memcpy objects' chunks.  This clearly increases
CPU usage and battery drain.

We, most likely, need to consider numerous metrics and optimize
in a multi-dimensional space.  These can be wired in later on, for
now we just add some heuristic to increase zspage chain length only
if there are substantial savings memory usage wise.  We can tune
these threshold values (there is a simple user-space tool [2] to
experiment with those knobs), but what we currently is already
interesting enough.  Where does this bring us, using a synthetic
test [1], which produces byte-to-byte comparable workloads, on a
4K PAGE_SIZE, chain size 10 system:

BASE
====
 zsmalloc_test: num write objects: 339598
 zsmalloc_test: pool pages used 175111, total allocated size 698213488
 zsmalloc_test: pool memory utilization: 97.3
 zsmalloc_test: num read objects: 339598
 zsmalloc_test: spanning objects: 110377, total memcpy size: 278318624

PATCHED
=======
 zsmalloc_test: num write objects: 339598
 zsmalloc_test: pool pages used 175920, total allocated size 698213488
 zsmalloc_test: pool memory utilization: 96.8
 zsmalloc_test: num read objects: 339598
 zsmalloc_test: spanning objects: 103256, total memcpy size: 265378608

At a price of 0.5% increased pool memory usage there was a 6.5%
reduction in a number of spanning objects (4.6% less copied bytes).

Note, the results are specific to this particular test case.  The
savings are not uniformly distributed: according to [2] for some
size classes the reduction in the number of spanning objects
per-zspage goes down from 7 to 0 (e.g. size class 368), for other
from 4 to 2 (e.g. size class 640).  So the actual memcpy savings
are data-pattern dependent, as always.

[1] https://github.com/sergey-senozhatsky/simulate-zsmalloc/blob/main/0001-zsmalloc-add-zsmalloc_test-module.patch
[2] https://github.com/sergey-senozhatsky/simulate-zsmalloc/blob/main/simulate_zsmalloc.c

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5e7501d36161..929db7cf6c19 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2000,22 +2000,45 @@ static int zs_register_shrinker(struct zs_pool *pool)
 static int calculate_zspage_chain_size(int class_size)
 {
 	int i, min_waste = INT_MAX;
-	int chain_size = 1;
+	int best_chain_size = 1;
 
 	if (is_power_of_2(class_size))
-		return chain_size;
+		return best_chain_size;
 
 	for (i = 1; i <= ZS_MAX_PAGES_PER_ZSPAGE; i++) {
-		int waste;
+		int curr_waste = (i * PAGE_SIZE) % class_size;
 
-		waste = (i * PAGE_SIZE) % class_size;
-		if (waste < min_waste) {
-			min_waste = waste;
-			chain_size = i;
+		if (curr_waste == 0)
+			return i;
+
+		/*
+		 * Accept the new chain size if:
+		 * 1. The current best is wasteful (> 10% of zspage size),
+		 *    accept anything that is better.
+		 * 2. The current best is efficient, accept only significant
+		 *    (25%) improvement.
+		 */
+		if (min_waste * 10 > best_chain_size * PAGE_SIZE) {
+			if (curr_waste < min_waste) {
+				min_waste = curr_waste;
+				best_chain_size = i;
+			}
+		} else {
+			if (curr_waste * 4 < min_waste * 3) {
+				min_waste = curr_waste;
+				best_chain_size = i;
+			}
 		}
+
+		/*
+		 * If the current best chain has low waste (approx < 1.5%
+		 * relative to zspage size) then accept it right away.
+		 */
+		if (min_waste * 64 <= best_chain_size * PAGE_SIZE)
+			break;
 	}
 
-	return chain_size;
+	return best_chain_size;
 }
 
 /**
-- 
2.52.0.351.gbe84eed79e-goog


