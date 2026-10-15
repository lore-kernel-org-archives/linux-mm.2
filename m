Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0075CCA465
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 21:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AC976B0095; Thu, 15 Oct 2026 17:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484F86B0096; Thu, 15 Oct 2026 17:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373996B0098; Thu, 15 Oct 2026 17:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06F636B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 17:05:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F933A747A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:05:45 +0000 (UTC)
X-FDA: 85326092250.26.7D3F783
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id C654F14000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:05:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ovND3FB5;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792098343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ncaxmlrNNhxOdRmkKnio/byckek+qNzzNxHvBVY91N4=;
	b=zb3wC2wXzL+ObInyQhbeTqghEdbI9Dd+8rvzGSUgVbx7yClZREVQcQZ74FkaXRx34jy3ma
	un3+M8hnyRGSDV1wx9AUIhmLblhp4FlrCCSvIa8YZlk5ZF4d+YlNId6of3MjDFYTsJBjGp
	j0/279qUqLvMmkakKPP925YeKL6OzP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792098343;
	b=cEuGJ08k2ovpVOzqBFa60OqSA5QqkUShB4BqYEKZsAiQq19xIFHZJBpPhWCEz+iwfSqgOB
	jpHm9lpuOfBDOuW+1IOnTzexk/FlR9iuMzpQ8uMBwi9gMvPN71eirac2Lp+xVzJy7ByE0r
	tHXcYFayn2uyTlkFry+aCkTkk3dY6B0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ovND3FB5;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-917866225aaso78175576d6.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792098343; x=1792703143; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ncaxmlrNNhxOdRmkKnio/byckek+qNzzNxHvBVY91N4=;
        b=ovND3FB5OsiKcnCn/u6GH/1wK7TVjUWllOKnP5nuX+8Sl9CyeOnSYqm3VAt0pV+a4D
         9z5fi7jSskKIxpOpEmxzgn3llJ/A92ZpLsFfHhmHwRqz3Fbc4O6Mufdp/09WAFdWjxs/
         shMUtxhIATJlvIsq5W7oge+eTEwloU8iUz1USH/Z3AjOTI6dnJf9WJfnmq3jExJbl/6k
         tB6C4piqlACplobQzL7moaQNV9qANJmbHRYjev5QoXzgVKpNXj2/dMNVizb55TK9N5qE
         pWLzWONvN2Tzlfi+Dr08ZXnl7oFvMx5WgPK+PS9apZK/LP7KSnDCXy9X9kVColWPzyVW
         4y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792098343; x=1792703143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ncaxmlrNNhxOdRmkKnio/byckek+qNzzNxHvBVY91N4=;
        b=GxPD3w3On4WvHk+WxrmGjW2ozIBKbd/59AfQe4qfz1vcZ1/HsWNOQ4mdL2a1/LtVfS
         X8onZMBaPNxdbdmD3Hisj+xkj7n7yY7IT2iv8KWAnftuDVOtwIHwgphBSb4dnlbSn7cb
         TTB7fhTSgVNlnGurqlCE+gByPUHTbof0w6CPyJMAa6vRdKuuJzUCzfyDe3/MK+yt+ehW
         n3BrjX3h1cEn4KQbGNlUhmJmwT6TqjwqtBikSE8OOD2DPlwxS4uZ2ubcGDJPDd8tGQlR
         qqaq4B0gTpUSwz4elyV3399xkFLRju+I/rxVsXRAUShgzXOxeb6oocqjNz5sVRImZ9gp
         L1Sw==
X-Gm-Message-State: AFq9FYJvhm1D9oTCF0Uca2VM0dBstk5F3jmVI5JWq5ZUhCk8J28ICmmw
	YPTBefj591S4ie50JkYoCHuMSFXLs7BusmI624kRZVVk1in8E5diPM/lkgiuK75h7r9QoUAexLf
	1FwSwUh8=
X-Gm-Gg: AYBFou3GH7HnfnE8wwA/1kgmQR/KQ7R9348oSVA5xkeOf0HQisS/a5Xz+WMN2bA5VHj
	PXtkffZHBYZxFIzDSk/mXWLYISLvuEJOlJlPlqsSnSQtNen3WsjLIurUvKMiAfyQTInOEY+Cz7Q
	0vYf3n6b8o61IZXtTkC0mNyUtRPUe27OlxV//fIQKnBAYpfIzwmQcpC+VeRU/qswDGQZXraWjhZ
	KIvqzOG2PuPKmHQo6NBnKQo7gieersjhqrfltfCz2Sq6ygPLuBtXN7TNMeea4WcYRA6HarANgk9
	gcH4BIzi2E7AnFIEFVFIqrSKzHDT4bku1ayUn/38Tk782FRfEVOQk0k6JTzhfC7AyHDkJuNHy+h
	mD/dAE/BrnroVWuTgfTm/CbuckVspWpyni4Y/HItk/f3DUkceR4BcVj+eRsaawk0KPCUGyZxJu7
	sJbT1OrJhcAc2ECmcb3TWo6jzK/ZtmAvNy5Yf7qMjWjnmaszwk3tLgYXhykO3gIH0bK+xi/xAap
	bV7ohfAwd3voAzkiUjewlysoi1fTX4RT6BsSwINScxl29HMs5dak3ph/L81
X-Received: by 2002:a05:6214:4497:b0:917:edd4:d1d5 with SMTP id 6a1803df08f44-91b557bd604mr362771606d6.42.1792098342597;
        Thu, 15 Oct 2026 14:05:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbbb0d44sm5187326d6.47.2026.10.15.14.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 14:05:41 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	stable@vger.kernel.org
Subject: [PATCH] mm/page_alloc: validate zonelist slots against concurrent rebuilds
Date: Thu, 15 Oct 2026 17:05:39 -0400
Message-ID: <20261015210539.3243563-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C654F14000C
X-Stat-Signature: xk6x75sxgign63sxa3zynuaceej1ksjm
X-HE-Tag: 1792098343-642784
X-HE-Meta: U2FsdGVkX1+DyzLlCWx2nihEoQX4UDxxXvJphrDR4/B16EtLxbUpLiWltoxTy4khV9PiCZOsI+zgVxHitjfUaVoKNMRJBCtSGzSE8wFReHPOWos4kb0Fe6ARsE0lRamWEtZbI1cea0wzFmegtf9zuN/Kt0PR5rHBIa4teQIm1OPnBpH5u/sNU+S74HBm4Od+LOE61+r3L+oQJcZWNEgSgZcQAQs9noso1AGXMvo2Z5sHq0evAmKF6OcpIk3rVQhHp6bkngnEnjiCugndp5E9Q08ge6Otir8CVaa1M7TG+0x/JnkMkUhsSzTMJvcdrYZOl1EDlWG/ulPQFU6Pqvxp6t1EzXly7Rt/D/rLN+UK8FHeycHTYvW7LpYvyhYrbEQZ73aqhppvFrPAsbAyIq1/Gd1VFC57l4Xi6uu7T+ASYWC5oln0M7+noxaACo2rt8XxdTqUIMjBHojIshpTGpgCTqSnq1va3DES1WaAgRSrq5Zrk+R0+K0bulSdGJW8oRsufIYHQaGvHwK0jZC1dzBvNOtcEy5TcEvaMpb/xJETUn1HY3tuU+6zoUVlwlcChrCLzhFZQM+J0sN1zfZhQ1+r9FZb5mogYWe5BrHTf92x+y8BL5yYpR7Ds1zoQlEM2qohOh4xjF0RjM9fOdy0myNpL42pSw5eQJ/bAhcIgoufqvxd+WI9ejZT1gM6C1jxcH/J7sDJ6Reo2T+w3+QqVuxrOwkn5u9uLSHKrltC3UGTlqoORQxZF8H23ssHpN+2vKsTyP144ZsHgcltNKnndhv7SgEHcN0xw+J7g5qmekB/YMzPDa2uRHUM76CDC7XHIr6oHKpGFV/C1HpdRl5PvaOAIsxO36jSEV0sdz8dykKYjIGNC98coT6MqeA5iIUn5mZ88dAM7lefyWxpS8ByJMQlP0pR/jirav5JTLKzDdy+5G2c0oMH0/rfAL6BjTSuW/PHMY72Ht11QaEHrbcsPqk
 GEpqplrv
 g0sPDyRuEXn4FC5CWdt6tmzwPnwyphDVudxmYPAgEgV1n2UXjHqJfy8/6NyI54EkPFjuOU0S3aWFx/qrHYgFCi2tgP7iCROLjcFnA8pXETo/fbg4PYk069uBeSkSUBgPHUkquPaK2HLsgyaJsOdyB+S+zQf7GWMFt5u9lImWuXsV3YYRTY/DgOjTea8V4SZosGwNuv2baonQDok5r/7O6KMBfhEZNyTZ5fuvDY3QBZyZe5tlIBq3LI+ioaMvihJUyrfoZXKBKLPcMcTotEkQnkG8neDgnelIpv77ogM54yGHiJl1SBR2fDbd72y+ROJvLC0Ng+B859GewbZ5S91xxLVaGB2AFAfv5mZGinR1asQbWJKDaHXAY5pr66Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Onlining the first block of a zone (e.g. via virtio-mem or a DIMM)
rebuilds every node's zonelists in place. An allocation in flight can
then be served from a zone it never asked for: a GFP_KERNEL allocation
can get a page from ZONE_MOVABLE.

The allocation succeeds, so the zonelist-retry logic never triggers,
and an unmovable page in ZONE_MOVABLE breaks offline of that block.

Recheck each zone the loop visits against highest_zoneidx and the
nodemask, using the zone pointer itself. This covers both cases and
is a no-op without a concurrent rebuild.

Reproduced with a kprobe harness holding a GFP_KERNEL|__GFP_THISNODE
allocation across the online.

Fixes: c33d6c06f60f7 ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6ed36ba4d055..a1254f2e1892 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3782,6 +3782,19 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * The zonelist can be rebuilt in place while it is walked, so the iterator's
+ * filters may have passed a slot that now holds a different zone.
+ * Recheck the zone itself before using it.
+ */
+static inline bool zonelist_zone_valid(struct zone *zone,
+				       const struct alloc_context *ac)
+{
+	if (zone_idx(zone) > ac->highest_zoneidx)
+		return false;
+	return !ac->nodemask || node_isset(zone_to_nid(zone), *ac->nodemask);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3810,6 +3823,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
+		if (unlikely(!zonelist_zone_valid(zone, ac)))
+			continue;
+
 		if (cpusets_enabled() &&
 			(alloc_flags & ALLOC_CPUSET) &&
 			!__cpuset_zone_allowed(zone, gfp_mask))
@@ -5234,6 +5250,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
+		if (unlikely(!zonelist_zone_valid(zone, &ac)))
+			continue;
+
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
-- 
2.56.0


