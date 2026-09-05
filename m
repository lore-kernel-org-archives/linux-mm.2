Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA693C79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 18:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E42B6B008C; Sat,  5 Sep 2026 14:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981BA6B0095; Sat,  5 Sep 2026 14:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8841E6B0096; Sat,  5 Sep 2026 14:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDE46B008C
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:32:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB92DC03AB
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:32:05 +0000 (UTC)
X-FDA: 85180553010.12.E820C1F
Received: from mail-wm2-f6.google.com (mail-wm2-f6.google.com [74.125.225.134])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE5FB1A0006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:32:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HJoovj/Y";
	spf=pass (imf19.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788633123;
	b=OuhWKYzSMd8mffkfYKHMY60NRO5JY9gGk918WSbSka1tm7CnfmYruAq98O7yPiU4uRexim
	qbyWsEnBDvsGZTcShQE9kRAlj7BCAqyslmI3W2apWNM9TURjPOdAbpGVcBnV+94gHNfHuO
	Z1uW5tQIOhZKJ1jweY203nMqbt6bb5k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HJoovj/Y";
	spf=pass (imf19.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.134 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788633123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnvH3YyzaVn11cnbchkUMzbKPWM/Jg4IVEMRRuXlOTI=;
	b=lc/+jmS9LykrnbSz+i5AyD6f+x7qd4mSb7+5qyQjaVePvdtke0eONGSyO2LRRvKT+HfdJk
	HeEGCfAwxAtRB/hERxKgYNmNHe/SCkPZJu71qBN6eZeLGLuRV6UfcTwaXrSzRaWRnCaV+w
	CbBC0XBvb/g48rCh9aeMPeAY+U3fLoY=
Received: by mail-wm2-f6.google.com with SMTP id 5b1f17b1804b1-499c930cb9cso4486325e9.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 11:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788633122; x=1789237922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SnvH3YyzaVn11cnbchkUMzbKPWM/Jg4IVEMRRuXlOTI=;
        b=HJoovj/Y23x8aVW3cg+h4dE6JxRtVnWCiKUl40BkgTwuglHrPcoU5c6sDzy+hipQkE
         YwwBH0Lm6UATOCSv9txnpQBlNtHhe/vfve2vqZcZyqEN90oZzJTWOWxp/CW8Ca3YXdgm
         FKqIe74PYLmeVjcTeQXoHRFSBliH0PqZJzmUg0jPIfhFt6keYts48SuEBogUVp9c7nkM
         EHeKo2wwcGE/t/3syr4esyHDD24ZSsM26Kk+eD5BqdRsluBdKw3ovPn49NlP41+enNUJ
         Itta3SqnoBQmsieLqZJfeQRX2bqsLvT6O/lZYBO2i4xVIFCqszN9yFoiJYdhfznlFBdv
         7M0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788633122; x=1789237922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SnvH3YyzaVn11cnbchkUMzbKPWM/Jg4IVEMRRuXlOTI=;
        b=a6s2m7TXSu1MT8M9AnMfyE5hUii3/yaxOaG699rEpcX1CpLy0BYZn/7su+EYXyDAeJ
         GxXkrbG/PAXHlc9QwvfXRF4i1B7Tubppn3ZK1fQoWq9ebe2KHqshX4B50WLRsX1y76UA
         EdbGtbY64onU4IwCbmPCK9n7H6ODH+LhUvEWj5x4xxatpXSsUec6gE8jKpfhWhxp8MVD
         8BeX12MLkmhc8QPgfw/88YmErfv2GAP7JAAkaF7tGfvfoWlNbhwIgZq6Pa1DqJsO0Ver
         EAGzdP/7LitMZmaFT/JB5n2EUpPA+p5OXi5QsixsehcJVEbttGfdffPcMrMHYx+LQQ/i
         ryig==
X-Forwarded-Encrypted: i=1; AKwUvBys5lNC7Wu5tSJSOzrTngVTRxiBCUuZp1hhHDFZLMj9A+IVZsPkYYufHe6djZBI7qP+d0hti+Rlsw==@kvack.org
X-Gm-Message-State: AFuF++mB9Epkc75X6fJHAlnb5sO9ctO87TGvccsuizuzYae2wlnLKTN1
	pWgd6bz3l41xUaQn+N1zBDRmljXsmuuDzhEM9IQQy8kqWh3rVRCkFW6t
X-Gm-Gg: AYBFou2yuNqIpyXzNA9BKgHS/+lTr2PKvekRVTAbwzvj6M/KSBJGIpwbA7dcTnAmhCx
	UpAg0SK3s+j+EWemPn6E6kA+F6/gKP3j0y4w3AJ+IwZy6wZBMkv2ODbUTLtFbYW5nE6g+A1Tb6a
	bU1QoUs6SiWQx/HTd3RGl2G8W7RowUguwDbPpNyQ4/jRpLvqfAfk8qQAxIEH5dI9BU4ghM4Vrz/
	4ppRtXnakpTLanSYgVtt3ycH1TqdnKHV5NlMPTSsKPYYmThp7GMRE0/ZoxP61pz7Wze583palFc
	z+z9jQMJThT/2qUOf08b2SSfr/TPXM5TKxk7xYB0Rk4eCVJETEnW4ilMtPKWu7G1oAfJhKhT2Qo
	GvdHxwVIbuS2fcuTKiL3jOgL1n4UuazR/uNxmu/dBt8Hhmfx83AauMfy5Vk9lb1g3DcDdpoGF5O
	2OIwbrkz8ofgi+6SsdGLYdQPLbsVqIyNw8g3d2BLzQoz9zxoBbBbFTygpE36NbGAH5cxmBpb4ZO
	m1JPsFfB/eVaRpy1fCD2LmMZzhnzA==
X-Received: by 2002:a05:600c:190b:b0:49c:fa21:e743 with SMTP id 5b1f17b1804b1-49cfa21e92amr116118745e9.25.1788633122311;
        Sat, 05 Sep 2026 11:32:02 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm13066670f8f.3.2026.09.05.11.31.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 11:32:01 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH v2 2/3] mm/vmscan: fix various coding style warnings and errors
Date: Sat,  5 Sep 2026 21:31:34 +0300
Message-ID: <20260905183135.20993-3-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE5FB1A0006
X-Stat-Signature: gfainqhktxhts53y54b5m1eszf4hmzs4
X-Rspam-User: 
X-HE-Tag: 1788633123-599909
X-HE-Meta: U2FsdGVkX18TNJFOeHx0Iyb4PXIErGTiZG0+uys6vr5QQiiBv8T87deJveSauEQ8eD8NSVZuKMlp6mY50Cqa3Fvo9u/WjHWYInQzNfWtHJ2WKvzCXUE5JRm6SvXe/rm+CbAZW5A6h/grL4rPIZIbK6QgMahXUSWLPTHtJw5fAbunN8EwUDi5JLF6v1DyPLyWT3jKYF0gFpP9YOhwr+BhPmoVe6s8Y6xjNRW0Om0pL0kLZLyL+vYAkJLrbBtX7WAO9ontspl/XSuVY9fpx9mb/JGfWMwGtFdn0CVHZ7OvEXzGYDVBxvmRgj18peKSGm9YQWdH+C7lq968kw8L8YbTWhckb7tXKzK0ELRDO8yWouB5WAq9I6Pj54K0krcvqM3EwA394SjmVdNs40LUSVX1nYg2BQiuFxBxfR53DdieR/3i4ujJ5nlUcRHiGJ2pMkfjcU6GqbV9IQZc9i/VRra+pNH9eDzijds2u4w2hAl0A54NVpP2wziEQ0YMq7ChiNpF09s+9OU6ijIZryhtUaxCFxKvFErHHfzxZz0Aipoa2/KuUv58pIas90XhfrBp2TySi/KX3+CCLoJPoFa4qGgtPdvlGwSrbluBjAyitfbzexLsyInNWOv28D4o4ur6HTM6WGByZiYh9p2yTnI5/8gkVm5K/j/sVgt8IhhpTJoHuzidDjPhiZoTPJoLEbek5lr1i2tM63cVSN50xIKVii3QjTONxmQK/C3I1XZEEiiL5h97vOVrj5iGjgUc57G9BmECfW6B+zSKco5zX5KwxScYel0EIZcwgwkQMbvH4Us1w0KQv+f0n8abo2W8lHMBQ8TNnbsHV77VQzN6Y+ek9vY0WD+nEM8o+DfJ63eB4pP6I3T9q8B812bQWujKETjb+pUH3h6RusOd3U4+p03A488EBdCdeXWBVXgq5hc7bcV4qzs50U/8XfjisrdK4AHmfvlXw23uAAYfKWKW1v5NHMr
 RLrd8bR3
 Vxti8UOjmMVn9x6ooZRs2IaijmdeLFePMVtu+HLT9+zA2JZfkIz143PIguXJqP53jenoXByy7n+dluMbJEvhS3UfkJMd05H8L9H8dT5qJpnWRqrpYDpUkwyZ2J+Njsyu1iW14Ri0mV+8Ft0NzxvbnhF9vgqTcXxuAdMN3nS5uzLVSGHQN1K0gKXb400HH23Oy4kpLgQ/Q6ihHYldyw2oxICqjAMeIwyxeT55xsDXmCf705mrZVNUTQhFebNoh6j5qEgW4zZSGu3mGAYcydVISxg1XhCLEbVCzKd4ROhGnsnw82KytzYNmYdxyzyp4t/Yzy8i8QfvMYl73ZQ5Ks9gy/0BHrsFL3DVf4OEAvxJWnIyRHvCf8wXKffdisN8OzCyv52DKa01+nUi8dmI0mLQgXajPf1QRcGc7E/OZuWOWoBF1nFHwnPDNIULw9R3JoikWPBSPYNpzoJZbDbpdna+knxFhzkZyfUcNn72BF2wb2DFXw60iobHJIdxjsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style issues flagged by checkpatch.pl script. Specifically:
- Add missing blank lines after variable declarations.
- Replace "unsigned" with "unsigned int".
- Replace spaces with tabs where possible.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/vmscan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..e0df7268d989 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -535,7 +535,7 @@ void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason)
 	 * writeback to a slow device to excessive referenced folios at the tail
 	 * of the inactive LRU.
 	 */
-	switch(reason) {
+	switch (reason) {
 	case VMSCAN_THROTTLE_WRITEBACK:
 		timeout = HZ/10;
 
@@ -1529,6 +1529,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 		if (!folio_test_mlocked(folio)) {
 			int type = folio_is_file_lru(folio);
+
 			folio_set_active(folio);
 			stat->nr_activate[type] += nr_pages;
 			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
@@ -2073,8 +2074,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	LIST_HEAD(l_hold);	/* The folios which were snipped off */
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
-	unsigned nr_deactivate, nr_activate;
-	unsigned nr_rotated = 0;
+	unsigned int nr_deactivate, nr_activate;
+	unsigned int nr_rotated = 0;
 	bool file = is_file_lru(lru);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
@@ -2614,7 +2615,7 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 	/*
 	 * If there is enough inactive page cache, we do not reclaim
 	 * anything from the anonymous working right now to make sure
-         * a streaming file access pattern doesn't cause swapping.
+	 * a streaming file access pattern doesn't cause swapping.
 	 */
 	if (sc->cache_trim_mode) {
 		scan_balance = SCAN_FILE;
@@ -7748,7 +7749,7 @@ static int __init kswapd_init(void)
 	int nid;
 
 	for_each_node_state(nid, N_MEMORY)
- 		kswapd_run(nid);
+		kswapd_run(nid);
 	register_sysctl_init("vm", vmscan_sysctl_table);
 	return 0;
 }
-- 
2.55.0


