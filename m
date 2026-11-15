Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 968D1606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 02:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=XchkAXl/
Received: by kanga.kvack.org (Postfix)
	id 30A386B05B3; Sat, 14 Nov 2026 21:46:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB426B05B4; Sat, 14 Nov 2026 21:46:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1886B05B5; Sat, 14 Nov 2026 21:46:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEE396B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 21:46:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44BE8A04C8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:23 +0000 (UTC)
X-FDA: 85435814646.01.5181C12
Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C3A01C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:46:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="XchkAXl/";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf20.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794710781;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8xUXS0A9Zx5562ccafC+4FXG6fYzwvM8bL3muSMq8g=;
	b=EbrOO5MISf45NPtsUwwSzQ5a5/Y3fUDJd61pJ5baF9pz8TCPy5o8nzuFvStdzGdMwTLP0e
	2DYqd6LdEGoyjR3unVpZKNSbSL16XkjXz+mIjpmuhZZnlPGhUWhLlIvMjR9+cPvyLp7+wS
	1LuJaIQy4c7PZWUc1ySGfgUc4gu2i6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b="XchkAXl/";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf20.hostedemail.com: domain of nzzhao@126.com designates 117.135.210.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794710781;
	b=sf9pWUFVllNsOJ6tWfC8a08dRuZJOH5OxBI94pb1td+r6OM1VS4QS305v7oBQGwDEQkDCW
	/NtW1aiy9YRkrpH+HFwplF4MUkhpnd75/I+K0DMGRnSX5lbcXsmJtR+fZy06m8GwDZ/cGX
	STsYJal7c8Dx/yhoVC7C2Um9fTxLSAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=r8
	xUXS0A9Zx5562ccafC+4FXG6fYzwvM8bL3muSMq8g=; b=XchkAXl/0DuW1oDJeR
	yQyJF1sQql/YPr2uJd3G5R7JbEIOo7jnJ/B+ouEdfu5V/2iiZDLDQvzOoU1v97S2
	pZYQOu36hTxd1eLrICYymhCa53Cg532muNNnLcMBbQlRy1aAUmDLn82VBEFmvrfh
	rsawr31gLZJ+i2IAhGQzgIOQw=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PikvCgD3H_OtHPlq+ob+DQ--.31738S5;
	Sun, 15 Nov 2026 10:45:21 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <baohua@kernel.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Subject: [RFC PATCH v4 3/4] zram: backend_zstd: use multi-page size for zstd parameter setup
Date: Sun, 15 Nov 2026 10:44:50 +0800
Message-ID: <20261115024455.1465726-4-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PikvCgD3H_OtHPlq+ob+DQ--.31738S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zry7XFy8Ww15WrW8Gw4fAFb_yoW8XF4rpF
	yxu34jk3W8KF10vrs5X3yI9F15Can2qFy7W3yxtw48ZrW3tFyDuFnrKw1fZFyUK3yrXF47
	XF9rGF4Fk3y7CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jTQ6JUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsAFQIGr5HMEvLAAA3M
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C3A01C0004
X-Stat-Signature: junm5stsic33o6r8mwjgkxsek4idoiso
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1794710779-898325
X-HE-Meta: U2FsdGVkX198N7nkV/TgX86Di+XqCtEdmnSDc2J5jqF85mxYZjk9XWYM28bzcvU9ma1fK9QEGGjTLFJ085yHEcnveuqU/hA0ZwbesYR7Ekn68YCCEBCDj7DkIh6gYrJbMUmCyZxgT9N21lHwefaQskqY2IakeUYPOv0L+tOvkvAH4L7IMUp+LjwguSWyIw0JY3ot1E4eSx5wK0H+R+pjsJDKjlycORZc6SEP0kR1rn6a5/gF8ZAzRtMhyGwtDU3I0J7YmkIvIWAXPG2/SV99q43to0tjmUAY1DphwuJwGlEPlhzFXD0y5D5Mk7htF/dNqWnvVeVtsPj7QVHPg95AMP5ZUsPjP0N0fTGSt5SsXPT5gWPK7UwfVMfOJgmJmcCYCCGfxQbWlcObI1vixFgk7eVpJ7DbJcx6Fg/EXEpoV67c+F1ALEPiSAXnyfJiXZfiFUT4wLue3Bdo3xTMK7orZSUVWxwZfFpgisR03V0+sMrY0ebhpwJASDpqgXxJq8SwP2RBkyJACEGrkPtVlOGQO7yrYN6i6L+tMDBxomS4ju0+q6E0IWJINRSG1BPqIAD/OyD3EofOzmrwjGctiKTaUVei4qV822+zga9H2mr+j/1O/KZAgl1qvOzm6u/rQzfMcEy6UCIfyJiDmK/uQBpYCTQ4TQpVjN8bf4TxCudhc8PF0YZud65aqUD/T0zuhyRd4GX9F223O3L8/2oqttDH9Z93SxlLPiI6OsDKqsD6vlSuacszB65yMLQ/md7ymOKgdOItocR9EK2dngGcmCjQTHW91+0BC7qhRGuGuZ0j9/TcRwt4WaRL3/g36poz9fm2uZafMzImjto2SJOSgsRxVXl6B5UZkZuYSPUt124bKOEkuOplkeKo8eWf7yiEpLfF5Zcs8PlAoDmvMoN2dOwAkm84LMODV4wYCtPURfZOzwTpQv740L8bM6tpBDZ07r2Np4kQfzkifH5OS+wpwH3
 vrHDrj/i
 Xr89GaBPqyt9ju/BsLkHgHvAfJ8GQ2fEl1kJWU6BngzJUS8m1J2Kalh0LpUF8doR5xzfIK4/9/tW4i0w2gGSczLdDrlvQJ0oVCwBwMMmvA7rzL4AY/dtVlbF+KiSNOKIDfTLCqX3Ryhpat0L7O3fy19wm4aiN8GRmFXonfrt8FCTb8IsZAb3DgayHwyuJMJLiFjaEHi3b6zupDcCJEmSO4xz5bxQxi7RXzZkPdyBS103FYEwYXk6gvEU4s4pTMPJmdLxBORNxNM7FeUbJEtOIxtcgLfIhxDj2B8CSBhk/JFK923C6Kvx35YQ5ywT/taZn0zUhJzSBDmp3ZnHUAymw5ebGhhSWnp6WjOyfw6PzgqFUk9M0mzNg+pCRM6+4i4S8ZvyNpyUa50YsXDyIkWQDnbTQh15H0bR3MDdERnd84OGRhqzPBW7gGTVK3fDTjTNX7zdP+JHDJsQVCCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Barry Song <baohua@kernel.org>

zstd_setup_params() passes PAGE_SIZE to zstd_get_params() and
zstd_get_cparams() as the source size hint. When multi-page compression
is enabled, compressing 16 KiB blocks with 4 KiB-tuned parameters limits
zstd's match window to a single page and prevents it from finding
cross-page redundancy.

Pass ZCOMP_MULTI_PAGES_SIZE instead of PAGE_SIZE so that zstd configures
its parameters for the multi-page block size.

Signed-off-by: Barry Song <baohua@kernel.org>
Co-developed-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
Signed-off-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
---
 drivers/block/zram/backend_zstd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index d55615f34300..9438691791ef 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -73,12 +73,12 @@ static int zstd_setup_params(struct zcomp_params *params)
 		goto error;
 	}
 
-	zp->cprm = zstd_get_params(params->level, PAGE_SIZE);
+	zp->cprm = zstd_get_params(params->level, ZCOMP_MULTI_PAGES_SIZE);
 
 	zp->custom_mem.customAlloc = zstd_custom_alloc;
 	zp->custom_mem.customFree = zstd_custom_free;
 
-	prm = zstd_get_cparams(params->level, PAGE_SIZE,
+	prm = zstd_get_cparams(params->level, ZCOMP_MULTI_PAGES_SIZE,
 			       params->dict_sz);
 
 	if (!params->dict || !params->dict_sz)
-- 
2.43.0


