Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD58ACDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 07:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADCB6B0088; Wed, 24 Jun 2026 03:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55D426B008A; Wed, 24 Jun 2026 03:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4280E6B008C; Wed, 24 Jun 2026 03:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 213AF6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:57:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DBAAA0248
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:57:10 +0000 (UTC)
X-FDA: 84914050620.07.106FDE7
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0FDBA0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:57:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782287829;
	b=wqCfAL32X+NXFta3rq1D/txhIVXMUy+PsfeZskPfAgmDbljOFlMghQzNrKY1tnMMDqtUU7
	CmAfsmPr5HBnD8kwMXsy9u4wPtgk6Isa+xlIunwMBhpGbIkEY7xMskzSLGUbl3ICzwLA+0
	kvS1O2MhIrulzzEwl1qWY+e0qxPO7Wo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782287829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8SiVAVsxyhFLb2NwEWMYBu86w/b13szcRcVSi/Wx5IM=;
	b=6vrtg/L5Q+IZiX8aNrnStZBt7DrUfIow5/CzAAS4wQysdSbfhliEb5egBw+CmaOf0CzN+P
	c9Y+KhlcZG/Tm9nYeyhOSSF2JL57qziKWAcPN44fbaEfBqXZ+b+fJLYn0QSNaDlV9Ch4Ae
	H42YLd7uJTKFRj9ri/WJit7Zc3dHFko=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id E1E373ED08;
	Wed, 24 Jun 2026 07:57:01 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH] mm: bypass swap readahead for zswap
Date: Wed, 24 Jun 2026 09:55:01 +0200
Message-ID: <20260624075700.751467-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: dmFkZTFW5JeWAMgo+ECyKI5rK/lhcx855/4unPaUpCZ7h1SVKWvD3gGXEDJOilWeA995lv6ILpnx91JR/wfIMmleOE+6oAkAVDWehLFHiuI7PqJAUFi9pXJsyt3p6ayJAIUCinXaYO3o2qtIe7igkmB0FAMMlRSRa819MrQIRCN/+EzheCjVKv3IDUMzxqhvQ7BnG9A/XWZaSbcnz9ouRlWBcTIPwAbJ4pgH9tnAA5UOivWk9lfu0Q6pH9cpDf6iDrTEz9mDbdEz+OHqef+AbWjdDvc94436lrAQypRQi3rTUixmdVWC+dVcSbnV/Rjo1JIvCXe8d0eSleGrBpB623Xoxy5RnibKzGdgvjl1vEIgC/A8/Jr9FJtOu7WSZzFmP/ltZJ3U/qu/V4jyjPGt5mmYUW3X9/8zhSwVaTcLwKLsUklt5zCc2Oql1tUnWlGqEeHHjNGqlw0vJm1E6oA2r4HyUQHBlr44tvbLZoUIpqTH3k6tDMWku2xdU+1L8GrQLyzJEthtq8vM+x5d6yTDracGQ3stgnOwgiosLFm/N9T8trA/tTd3ftPDnZYIiI173ghpiia77tdjnWdSjcfdWMJlW4G9cv9TLUToLhfT/KGfqg4tO66x8Dp+F5WN/Jj+sU7UWnO/Mz3z/+jCYwCHT1j6ZMYimX8ytwQ3IQEsXecFDKBDZw
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0FDBA0002
X-Rspam-User: 
X-Stat-Signature: jsywghfoda44413uhgtiiz3xw8beqgg7
X-HE-Tag: 1782287828-520977
X-HE-Meta: U2FsdGVkX1/te2h93UvpL0fODNdXI0GgMwSQLkgOFznVyVKE+852flVGFfAOuz8tyuN+AnrRxD6sV6b5uAwqDZoP1TqC9IzAmEx64DJZDUTC9ytQNzW6nhhXxoA4zh5e40ITAh7ZqsbxdCeN8mK9zhCH294+xLMXHydEqwg8odJTByCoesbZbzM44KFgHq59IRbj+fDtoIa7MvpcPpxsBjXx1SYW6U1B1DfV1Feg/iIgxRFgeUneYurCwjXieVaJCJ9om0NMEKSg4z5wK42pTm9eHJ4lhdph0kel+f21VVzwn6uainJ4zHpFevmD7L0ssZWD2tWlVzsdtWM61HdO/gsqmulAtGEFHW/doZk5j91DLXAM65kCA1qDYUGASporLFWCJEmrUslB21OT+8iZpiuZSx2hdcK2IZ3vN1J8NqK+vxI8D9qEGwJg12mBpga93vMY/NdaqVEdHeRFRk+jOQ8JvDt5Gl7/HYiTz7/nQ13CSS6P/nuBaiyaPc9cF/lgR4a/95db/LyMPZnzTivzy6ak6sELWALjgtjVSSB46yPi2gh3HzDNQzTcfHvcdB/ajcKX2vhThp41qpDUa7gGeAJXdxTDNM4g+rLwxoamjZDerreW8w08dybY+ndXcmYMXy8/z2Qxc4izoXk92S7hVjcYHDJ6Mz0QVEBrXuIBfVak3IT16jdEP2PPTRnm5oF4JjKgcv3sJYxrEgPhdF1yk9kqNPtm65P4F2tsyPcVfy0tcD1XB7Uf80eDpeM0JcvRzzpBKUm08LZWBd8JlLrP4dL+TsRVWbeyFllFaatjwvqQcJwH3IIBudnRO50Ni9Xhcaa3By6wh8IKALCuaDOztohD9gIg8Bh3+5ulwujo8eP5dkZhjJmnGblHBicZF8bjPVh47pLF44DMazpeJ2ay4DJISeO+n2auEWujagnQ+Q0U+/pvfcKsGkVno+lG+/aPu2SvdrKPSLbLMyri3Uo
 QxINzQtG
 sU/0Gvmke34F27LobmRGYrlrAcJ50cYW2BH/oQu+VwUXb4dDJT6KCfEs23A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.

zswap is the same kind of in-memory, synchronous backend as zram, not a
swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
swapin_readahead().

Here are the results from bypassing readahead for zswap too: it was
measured with a kernel build (make -j16) in a memcg, zswap=zstd, shrinker
off, on Sapphire Rapids and 3 iterations.

  768M memcg (sustained swap thrash):
    metric                 mm-new    + bypass    delta
    build time (s)          405.0       341.7    -15.6%
    zswap-in (GB)            79.5        53.0     -33%
    zswap-out (GB)          144.8       115.6     -20%
    swap readahead (pages)  6.79M       0.45M     -93%
    swap_ra hit (%)          72.1        89.9     +18pp

  1G memcg (light pressure, build not memory-bound):
    metric                 mm-new    + bypass    delta
    build time (s)          177.7       176.0    ~same (no regression)
    zswap-in (GB)            10.2         7.5     -26%
    zswap-out (GB)           27.7        25.1      -9%
    swap readahead (pages)  1.07M       0.08M     -93%
    swap_ra hit (%)          68.6        87.2     +19pp

The gain is from no longer prefetching pages that are pointless for an
in-memory backend: readahead inflates anon residency and thrashes the
page cache (file pages get evicted and re-read), lengthens each fault by
synchronously (de)compressing a cluster of neighbours, and adds
compression traffic when those extra pages are reclaimed.

Bypassing swap readahead for zswap therefore makes sense.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---

- This bypass originally comes from Usama's series that implements
  large folio zswapin: while working on improving this series, I noticed
  the gains I got only came from the bypass of readahead.

 include/linux/zswap.h |  6 ++++++
 mm/memory.c           |  5 +++--
 mm/zswap.c            | 11 +++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..b6f0e6198b6f 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_present_test(swp_entry_t swp);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_present_test(swp_entry_t swp)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..5aa1ea9eb48a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (folio)
 		swap_update_readahead(folio, vma, vmf->address);
 	if (!folio) {
-		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices */
-		if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
+		/* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devices and zswap */
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
+		    zswap_present_test(entry))
 			folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
 					    thp_swapin_suitable_orders(vmf) | BIT(0),
 					    vmf, NULL, 0);
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..5b85b4d17647 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -234,6 +234,17 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+/**
+ * zswap_present_test - check if a swap entry is currently backed by zswap
+ * @swp: the swap entry to test
+ *
+ * Return: true if @swp has a zswap entry, false otherwise.
+ */
+bool zswap_present_test(swp_entry_t swp)
+{
+	return xa_load(swap_zswap_tree(swp), swp_offset(swp));
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
-- 
2.54.0


