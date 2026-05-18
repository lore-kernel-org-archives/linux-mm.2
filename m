Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F9CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025F26B0092; Mon, 18 May 2026 02:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FF76B0093; Mon, 18 May 2026 02:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9DB6B0095; Mon, 18 May 2026 02:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D04D36B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:23:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90AE3C2958
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:02 +0000 (UTC)
X-FDA: 84779547804.16.7BF0EB1
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id D33A214000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MSX5waip5NGhQclFRhvsfyAyg2WPa1jmhfl7j5rXTuc=;
	b=Xd0djnyPCS5xgvX3IOUhmTFMms76Comky9grupeMm+5sEvyqHdoXqLWBrdvwPMcXBi3xvc
	qJlKJMhSy8IST8cAdjKxG4A2kW5yi8VMxxieu0+6MA6A6OQsHgXxIVUTUqjV1TElyGWRVX
	6couP0618NrIqRAe3UOhl4d+17X8Nbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085380; a=rsa-sha256;
	cv=none;
	b=Rueiwn8aynKIUjINLyGA08kx7MfV0iOOO/vjYZuF3qctyJPkMi/HHZp0+PLTeA8hxJzldD
	+mtoxzGRBMshc2h9vM1VS28irLA3cV2YQiGDrv8kWJElvA9qqwcWadBk7JrXGk6sbKbVk/
	u+e55KN4iSEsiOitW7A/mAP65TrzbUs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
X-UUID: fdea87d2528111f1aa26b74ffac11d73-20260518
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e173f121-d841-4328-8e7e-460a1e857669,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:e173f121-d841-4328-8e7e-460a1e857669,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:68c55320f66396b85f914a939628cce9,BulkI
	D:260518141718A8ARMP8Q,BulkQuantity:1,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fdea87d2528111f1aa26b74ffac11d73-20260518
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.40.146)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1633884271; Mon, 18 May 2026 14:22:48 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	stable@vger.kernel.org,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2 1/3] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Mon, 18 May 2026 14:21:57 +0800
Message-Id: <20260518062159.80664-2-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260518062159.80664-1-wangxuewen@kylinos.cn>
References: <20260518062159.80664-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D33A214000A
X-Stat-Signature: 879676dpnietyprhu9xuz8kwofnw6j53
X-Rspam-User: 
X-HE-Tag: 1779085379-560982
X-HE-Meta: U2FsdGVkX1/CapsvMzbV7QcvfdyX/AD+b1okDU+lIByPyqJk6dyh6QWF/TL3IRa3J1oRIMxKvpvNSihP17eHYtjIXKJ1fw2HBlY5tl479nNftitv7anE3hAF9LJn5VYqBF/DEKbwyy7CkiwsEbjQBkBKnajOcgTWkH9nhKTjJGp0jCUUjwBxK50vd71YH4Lz15844BeMX+WZWH1Dq2ZPv3SQysTQ5+iwLGXj40ui7y2e8rEoAxAD+0jfhs3fVd2v5QTcpte/VmwHsC9pPkyTB5KBTLcergRdAOHEkRxyGHZplxeHXUEg5+GC/iZoV46awbw+Ev8dgG/UxPpPgQAmhKf9/xuLx4pTgmFhsrgPCgfDFHUJZsAj1kuA2dgcZ1JFwllHKZ53+Fie9uKGsPlcmIOBy6HJKc3SZAUtlcHAaU+KVKCdhelHyWkABV0x/IgN7dcmDAvYBjeNxzRIHiBh062o2NvBWqsGI9pIxCUuEvJz/+QDw08LwxT9CmIICF6sXdTHnPILuC3hCvhMnCcHeJ/kBJCBysKeUmie8PscErevcV2Mw5JyIAHl67C5/KhSRCJqtq/z99DcZt+PotbLWPWqNQV4techvWGRHSJMgxejt+vEz8GUTEZtLt7qphimgHo1DxQp11UTipPoAd3EcvcuGrwrC1kExHjZnWPGKcjSxjqRY2DmcKRXsk0BQy1Q52juUr7S9JDHEVHMFHzbnAmhFsahsYsqv8KR0wREd2yvYpFmfTZiqHsycfOrPeesTh1FwWEEgU3J+TDKHbC9nAqqZXqd5d90x0w8dynSRQxG7qKRYN77A1VdX5spCM+usYgeKbtvvENJVFIrgSQ8saBJ7YGUh/OGylcUGtc3BAiDC6zXfznIJaReV6/utTlSzbnfdcSHiHtIucM/cKoJBJ/ezfRalpmgp/CnZ3WDQeQrRxs+tn5p44zRrqPcK/lZQdUPYruosU4Fyt+a1Sm
 IvvkTmC/
 PwqRXHnjhQjtU9TEIsmC6Xt/40A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0. This made trace functionality permanently
enabled once turned on for any slab cache.

Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Cc: stable@vger.kernel.org
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 54c7265ab52d..39f7eae7eecd 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -798,7 +798,7 @@ static void slab_debug(struct slabinfo *s)
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)
-- 
2.25.1


