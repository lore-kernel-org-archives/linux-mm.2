Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF5E3EDF020
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7E26B0089; Wed, 11 Feb 2026 22:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092546B008A; Wed, 11 Feb 2026 22:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00F76B008C; Wed, 11 Feb 2026 22:24:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E03CF6B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:24:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C35614064E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:24:07 +0000 (UTC)
X-FDA: 84434360934.16.170C556
Received: from SHSQR01.spreadtrum.com (mx1.unisoc.com [222.66.158.135])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6603B40006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:24:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=wGaPsTk5;
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf01.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770866645; a=rsa-sha256;
	cv=none;
	b=SGJ3OTgJADkfag2UnJ/+L/B/spqb7Dl0FXcyD3HVoMCS/8xk3UacTVqQpVaYNA9F5s6BPd
	QS/XYyd8gaN1iftiSn1cald0zO1DoA+FFLdbydB1HSMboyF1l7VY/GPauSlO8mf75lzJ0x
	dszQu619/0kzM/BWcb/DklluwJYhvbU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=wGaPsTk5;
	dmarc=pass (policy=quarantine) header.from=unisoc.com;
	spf=pass (imf01.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770866645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QdCMFrzogHkQ8spZQwepKtQEezu1njOGBCSt6rWNZlg=;
	b=L+6ARVV46ahraxhOPMzzIFgfNyxlyf/UF3l1fF9cFRS1uPRghStfbTCkAb2eIxoBYkUswu
	bXQbV0HMIzi0c3woycalTp0p1F7TRbaA8a7pSjN949aJbcPl/eiQuXropQhUF+OMlZOiom
	jBLr0SVvm435JOOMmT3w3iAxGIFNstY=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 61C3LR8E064229;
	Thu, 12 Feb 2026 11:21:27 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fBLDM17bZz2N6JsN;
	Thu, 12 Feb 2026 11:21:07 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 12 Feb 2026 11:21:25 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>,
        Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>,
        Shakeel
 Butt <shakeel.butt@linux.dev>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "T . J . Mercier"
	<tjmercier@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: remove '!root_reclaim' checking in should_abort_scan()
Date: Thu, 12 Feb 2026 11:21:11 +0800
Message-ID: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 61C3LR8E064229
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1770866497;
	bh=QdCMFrzogHkQ8spZQwepKtQEezu1njOGBCSt6rWNZlg=;
	h=From:To:Subject:Date;
	b=wGaPsTk5TV4H4PErTPLlAMsGKYec+H7w4lynxRq2fSfwqbZuK6dIg1nwXzTmIm+sf
	 xCm+uT4IIc+01tdSUVmU95iP5sJvJ5C+Q3OVO/gMMKL2fd3VLS03P2XZPT/GqOyJA4
	 Uy4t29o1Sbdvgs72C4XEmadrRX39Qk4hBeP0WMpEUZZxv653sr+d9EH/eR3gZQpJIm
	 7jUoTyLpjuiwXxI3c1uJveEypX1FUsurgt7eRYFINWxPedJQuN09HFgHDG1vy/rEPL
	 77mRLKdIe3o4+DQUEIGf8gfBGnT56L3XVd8oqnMT0EIDn6VsLNuNlE1fMLQ0gRN3a7
	 U43E7/iII/mLg==
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6603B40006
X-Stat-Signature: 893hranojuasqbmyu7pdttahstua7hez
X-HE-Tag: 1770866644-315925
X-HE-Meta: U2FsdGVkX1+kLMjWHCc9edbJsFQ9K/vzVPcBYyo2XdvVqLwTCikRMtz0JP+osyd9+cftP1D4MXOshRe4F442nIPUZoaqD02SkRZExpFaIAljqqWnWcf8VwCTc/5c9lfMqNKNUEEPRo4MgMEwOTEJBx83DfmeofRM+HODO2grzxCb2tSq5JHRuloZw0fI+QC1GNDmj/9rHMlMQRNtOMgCx+L0GgylcJOqI/Vd0T1RX0OdTZ1hIS5ZeJwhamym68T1K/G70v68wi7f32046yMzGllHA1twYqbAgCzzGodca6yAHMwfdO0L1eC0vDwbOCtlmOCwPVGjvLy84XhqLXqVh08wLMKI+JkNCY0+8owLcCXDahZ/ryqSA+jhv8rd/Irw2FZ9UretSf3vTryh3iu/oWfTzFKWU43SNRd8am+tj7zCAMG443PAIUzlDPffoAMV20d63jSCA/WGVsjG+3+crPYcOQgCw0vRqSZUCPCeqKm2Mi93ezrf2wpUqzdZL7qBgsPRnli3FOLVR8iYahWHRW7KYarOgxA7dCG5YoCWx5/RuIQs5ShysKOXElRuoFytF4aH5L+cR6oaPThbbnI+ZriHf/qBASXFKfjHu3EtiSQDMPUYVe8yKgE/96cLD777bJ58CBm53NAJ+Gc81yLTNqqKMxt8cekSQsKrYCX6BBejgti0uoYMoXXzsG9faJNmqncKEN2El1qRPfrBvajC99XL5zF/536HtfVjFvkodFdABu0kzJUIyC+vpKc7z4I+pd0bsJGFXpbKS4+zAUJdUMHdgEiIA7zbnHvmdG6edrUrgRo6qNiTFyzuvSdEXZakd7G4SbJMgt8CGNjL6nhdA+wnI0+0PoWKgXWAc8flibS7gptQsPASYvm+L7P5gcHBwVupQL7dzrfvmiLYyY7qu8RCdZB2OLsOHu7s1MeaMAt4l6ruA0g6QqjD+fBfRmYzaGYaFHZNdDsVoZSOijA
 ndBEIlNx
 DShqUvFUJaNE2V1xhGfdM6qmt+XqtdQ6rFvUKhUQWnyhzhVbDftqe+7AehfigE08liT/zBgelXvcBQH1LXTCfZv650RrbLzCP59HIhQWJLuIUiuMQMO2/GT/HHWF7UfiiPdjT+T+JqUvafx15fqfk/ukW4mwNRFtI6Gmfyenmgiq6Q4pgmpxQJH1pdwSAXHsSOADpBy2g097Xv9mcw1g6bscFYlsB5mYiv6nET+Ac+IM+guwlDM9xoZbQynPpt1Z18hYSy09FdR+xrN51W6FV/w4ZNkYL/KvMlQJhggR0casn74171Z8IYmOKJNcGMyG43Zi3JL4nnjVvshZGYinmmdzWtBwINn2lGH6D0+y9l7SH4Etu4RIYbEa8OBEQcm/V7tOpCD4v5LoCKTcrLSQ3bCAb6nt4Dr4D8/dvsRpDGiHJMqIUmov8GYYj+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
user space memory management which desires to reclaim a certain amount of
memcg's memory. However, oversized reclaiming and high latency are observed
as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
when MGLRU enabled. Besides, this could also affect all none root_reclaim
such as reclaim_high etc.
Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgroup
iteration") introduces sc->memcg_full_walk to limit the walk range of
mem_cgroup_iter and keep the fairness among the descendants of one memcg.
This commit would like to make single memcg's scanning more precised by
removing the criteria of 'if (!root_reclaim)' inside
should_abort_scan().

Suggested-by: T.J.Mercier <tjmercier@google.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..9d900be478ea 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4832,10 +4832,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
-- 
2.25.1


