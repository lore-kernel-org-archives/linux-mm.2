Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F3EFD875A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6B46B0088; Tue, 17 Mar 2026 08:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6C26B0089; Tue, 17 Mar 2026 08:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96EE26B008A; Tue, 17 Mar 2026 08:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F94D6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:33:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2604E8569E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:33:12 +0000 (UTC)
X-FDA: 84555495024.03.E66D639
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3DF6640013
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:33:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="yVjpuC/w";
	spf=pass (imf01.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773750789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OvF++IGjKAaqWGUfX+qLkBmP1nNWElSB0WIRzdy2sJE=;
	b=7J2E+t7BpGoGqkjJu/8WzbQnvC+Vso3/4AGY8SZcjtWAK2Jy6H+4PPVqR1cjaj234nRLTS
	Xi/71/Y5LRn+Q9L3/R61dyP3d/QDaC4Cr/cpTkyHezN8LFG2tQUfVrmjoWOfgHZaA+rXoz
	PJFb88uMnGHwN+vEKXn0IC75e4WuKto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773750789; a=rsa-sha256;
	cv=none;
	b=kDqgxwD1aVMYBHzFV+xN/OWCdwZezRsCmuWfaSKLeE/bRdlb2PUjsjVW1CmpuV5hoqOfnS
	TG9gAG0xCBVXWZPoF2PClrZIwu62dzgrND01HEw4Vri+IoPAmuQDFEoToV+xmsA3lJua0+
	r/B6zP9WKHeUG4xcadalmhivBRrEiIA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b="yVjpuC/w";
	spf=pass (imf01.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 62HCV3Lq000571;
	Tue, 17 Mar 2026 20:31:03 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4fZrqz1bW0z2PRM8y;
	Tue, 17 Mar 2026 20:29:35 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 17 Mar 2026 20:31:01 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko
	<mhocko@kernel.org>,
        "T . J . Mercier" <tjmercier@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang
	<huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCHv2] mm: remove '!root_reclaim' checking in should_abort_scan()
Date: Tue, 17 Mar 2026 20:30:37 +0800
Message-ID: <20260317123037.1651424-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 62HCV3Lq000571
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1773750668;
	bh=OvF++IGjKAaqWGUfX+qLkBmP1nNWElSB0WIRzdy2sJE=;
	h=From:To:Subject:Date;
	b=yVjpuC/wMiYEu8zirgdNZGtTop91/IonX+5fs6I4odHpG4pBrcctokj/fX9uh6fqT
	 KlXk3HO4TZeasGpALvwB1pYtewUnCYRN/kccyylHF8OIBuSyL9ckOMp6q+c7mcV3Bn
	 NVoToBaVkBWFtYvVUo8y1pmWaaqJUqfTJBPnyljA5hwKDyswNC4ZBiy7PyamoIX9MC
	 iZou+7q4ca72qWk/uVutruyXUN3c0rvCv99BGcUrkeV8fA92ZAmvz16UweXMPkX+KS
	 J009s08AODg98gZ3gLeT+dQ8L6jMZrMQQAOos93hSW3c6aobtvsE16WFgCeRd/+CwR
	 MENUk4FqY+yfg==
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DF6640013
X-Stat-Signature: 8a3eowtgu593po1ot3wdzdmayrnn7uw9
X-Rspam-User: 
X-HE-Tag: 1773750783-713814
X-HE-Meta: U2FsdGVkX1/3tTwAEIW0VYWv2UhHPDLh/Tm3bPAS7n28wxEb3/cMwuudsXV/g5kt5mwp9Boe6sCup9uFX3k85S8qMOufw3MPOIDnWiNuLDSmjv6gEcqbiu8WIvHHkT+htzOm+YpqJD8h4+sMq3+lxOJbQ/TTPnfqfVhTEp/tdcUVc9hpfAYXX7XCkk0PMEw/ilZo19pYKyuwil63TgEnKitftAC6k5Ma6M6cGmtZIpSpmPIKFAGJa5+DiRbMqxcQTrHUzi26LPqO+kLPLSBX7+YyAavvRehYJWd+DNRYIrTHgIwiLPuMW3pTFfkBgXuc0eoSP5ZFE0K2fhnGWxqWSNy9vF9By80Cjtoy1pKmAS6N82iU590z8ms5Vb/A2arPraLyHeWqyKDaVn5cV1zgS0xmUZtkwPmA68QFqgrXjTAdbimHLM5sGA5sOAYaX7TiB129p0qtypHNScedxEe9Y7e12sCO2d19gXSF69+ATvsCzfX65YAQ45aWNvXjrNzAIP0mJb0cfaB3wkSfaPqmJy1s3fgVHLGs9FNW/cXhXBwdDaP6eFxV8kNj/v0LAw/6rSbaMoyeNP7MFtoU6jYHJas198kB57zeCHJGS7VMdkn4fz4HUZmOIQyLheJfEFVwpw/UYGWpzJ7MmQjl0Eo1i8Oh+acTk2SISWXidsAqAWdei/aryEV1IDU5BKonf2Z1Mkjl4hy0BQPAvSP1/WcHU582bqX6iQDMJgIHTwd/0zXnlEZrgoaOkJvdp0Q7l9g5dfpIv7oB7we2S+gsRxR6hDom3i63fI7ZRVpEVNoDDfxN1Nr8lGOf2P3O2c5O3fUbdvxieG7OH0LKvn4EbzvZSn1xDDhI0rgixMFBeOAdIOnS32RHiE7hkSNsDL5SU/ak4QTUSNKMqZK9MWtFZz+eWJdM7smhdW1dMdABolbn65KYALB0+q7tXgCDXTCx/MpWzYm5bmCGjggWv0sqEPc
 lcdln8E0
 sBIDMrvWVEeev1waxGLs4SZErVej7CHqD2Ar5iCC2BKLbAZGuoS4R5UQ+I0GXfqBQm4ADE6UZBRqr595+iP/ytnfsN+nHaakwIe5NKSnViV4Moiwt+v2knYgrQmaVZVBfdSCmp6MsJo7wOoq4TdKTLhqFA1cinolnMGbKe5cYXYqDB32RGgYqanuAbd2f42k/kDpTftHpWFt1CsJ9xwu/8FtzTsXiqf6PXbCoVMjPxf+lDu/ry9gZMJDuXJkHP2nJnJIju3AUVpzSYZvNKBxV5yldgC1MmWASk6Nb1siHV1swMOKBpTyCfi5EvT1xNX6IPyNbIpoj42q4bLDKZSpyEjQKplYjaNDuIlrdDYEI3S2UOz6zon3uDXXsSO7qpcS+KdF9fiJK0LUNeDqml0jUZW3Ute42eXAUpVsXZrQhdTYV9PUhU4NKpUnoVIBMLAe7oLurEiwAkZq9ad+RUEBhV7AECsYqAR8GFMcwF65y4TrZVJRzBTgFbtPfRQ==
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
[1] as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
when MGLRU enabled. Besides, this could also affect all none root_reclaim
such as reclaim_high etc.
For try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
!root_reclaim(sc) check was there for reclaim fairness, which was
necessary before commit 'b82b530740b9' ("mm: vmscan: restore
incremental cgroup iteration") because the fairness depended on
attempted proportional reclaim from every memcg under the target
memcg. However after commit 'b82b530740b9' there is no longer a need
to visit every memcg to ensure fairness, horray. The problem is for
large lruvecs, the lack of a check against sc->nr_to_reclaim inside
try_to_shrink_lruvec (caused by the continued presence of the
!root_reclaim(sc) check) can cause overreclaim. The non-MGLRU
implementation in shrink_lruvec already checks nr_reclaimed against
nr_to_reclaim.

[1]
test log which shows a nr_to_reclaim=32 pages proactive reclaim ended with
nr_reclaimed=394.

[  485.100981] memcg iter ffffff8086535a00 nr_to_reclaim 32 nr_reclaimed 0
[  485.106927] memcg iter ffffff8086535a00 nr_to_reclaim 32 nr_reclaimed 127
[  485.109652] memcg iter ffffff80744e1400 nr_to_reclaim 32 nr_reclaimed 127
[  485.112255] memcg iter ffffff80744e4600 nr_to_reclaim 32 nr_reclaimed 127
[  485.115766] memcg iter ffffff8150306e00 nr_to_reclaim 32 nr_reclaimed 191
[  485.125635] memcg iter ffffff8157608a00 nr_to_reclaim 32 nr_reclaimed 191
[  485.131366] memcg iter ffffff8157754600 nr_to_reclaim 32 nr_reclaimed 216
[  485.136688] memcg iter ffffff8157752800 nr_to_reclaim 32 nr_reclaimed 216
[  485.140495] memcg iter ffffff8157755000 nr_to_reclaim 32 nr_reclaimed 216
[  485.147322] memcg iter ffffff8159461400 nr_to_reclaim 32 nr_reclaimed 216
[  485.150605] memcg iter ffffff8159466400 nr_to_reclaim 32 nr_reclaimed 216
[  485.158260] memcg iter ffffff8159460a00 nr_to_reclaim 32 nr_reclaimed 216
[  485.160819] memcg iter ffffff8159460000 nr_to_reclaim 32 nr_reclaimed 216
[  485.163200] memcg iter ffffff8159463c00 nr_to_reclaim 32 nr_reclaimed 216
[  485.171778] memcg iter ffffff808912ee00 nr_to_reclaim 32 nr_reclaimed 216
[  485.174156] memcg iter ffffff808912a800 nr_to_reclaim 32 nr_reclaimed 216
[  485.179110] memcg iter ffffff814bd3a800 nr_to_reclaim 32 nr_reclaimed 216
[  485.181537] memcg iter ffffff814bd39e00 nr_to_reclaim 32 nr_reclaimed 216
[  485.184877] memcg iter ffffff814bd3da00 nr_to_reclaim 32 nr_reclaimed 219
[  485.187245] memcg iter ffffff814bd38a00 nr_to_reclaim 32 nr_reclaimed 219
[  485.189654] memcg iter ffffff814bd38000 nr_to_reclaim 32 nr_reclaimed 219
[  485.192029] memcg iter ffffff814bd3bc00 nr_to_reclaim 32 nr_reclaimed 219
[  485.194509] memcg iter ffffff814bd39400 nr_to_reclaim 32 nr_reclaimed 283
[  485.197107] memcg iter ffffff814bd3c600 nr_to_reclaim 32 nr_reclaimed 330
[  485.201361] memcg iter ffffff814bd3ee00 nr_to_reclaim 32 nr_reclaimed 394

Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
Patchv2: update commit message
---
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..10f1e7d716ca 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
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


