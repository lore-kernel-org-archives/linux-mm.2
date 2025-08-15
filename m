Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D09CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD3A900241; Fri, 15 Aug 2025 05:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D978E0002; Fri, 15 Aug 2025 05:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345C3900241; Fri, 15 Aug 2025 05:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E54C8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:21:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEEE31408E3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:21:40 +0000 (UTC)
X-FDA: 83778449160.14.37B04A0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf24.hostedemail.com (Postfix) with ESMTP id E9716180009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:21:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755249698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ExduLD9fxfud2irz0LLMDbE/R4PgWzDW0AfyTw5F+kM=;
	b=GjLOl8M92VmKaEuSwYetiN/T2EeZ5jlmUmAkeu3DKyF0p2FSeSGDvBhZqfNkS2PpKXPFBx
	KsC0vSVMSeikuOy3ZrPyLDU0/pTp7aBUcWIJJMRwdAhLZTDB7ugJOHovLNOvQ+oTPXk0Bi
	HhrLI0eSIQmKVO5XdRIB0QytsBjkd4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755249698; a=rsa-sha256;
	cv=none;
	b=oMVPtC7x9XU8B0no6B1HKqeIiyCEwcqiGKEDJ3oZxleO1ZvsqMxHaErWhDnvEG8REHlroj
	P9XKUkwmoQ4fqUNvfI4c3ON1hxWUPIPAozBvLsAGkOjvnGKfD3BRxhDf66MzEzBK/9+rrC
	4LooDQR3rWFSXX8eIi8M0hFICrTdhRk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
X-UUID: 391f8c8279b911f0b29709d653e92f7d-20250815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-CACHE: Type:Local,Time:202508151717+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:972d1f86-3388-4f2c-9a28-ef1168239777,IP:10,
	URL:0,TC:0,Content:0,EDM:-30,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-35
X-CID-INFO: VERSION:1.1.45,REQID:972d1f86-3388-4f2c-9a28-ef1168239777,IP:10,UR
	L:0,TC:0,Content:0,EDM:-30,RT:0,SF:-15,FILE:0,BULK:0,RULE:EDM_GN8D19FE,ACT
	ION:release,TS:-35
X-CID-META: VersionHash:6493067,CLOUDID:ab7f1c49c2a63aa729cbabf1c15971fc,BulkI
	D:2508151717102HAXJBFB,BulkQuantity:0,Recheck:0,SF:17|19|24|44|66|78|102,T
	C:nil,Content:0|50,EDM:2,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:n
	il,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 391f8c8279b911f0b29709d653e92f7d-20250815
X-User: lienze@kylinos.cn
Received: from kylin.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2106063409; Fri, 15 Aug 2025 17:21:28 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH v2] mm/damon/Kconfig: make DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT
Date: Fri, 15 Aug 2025 17:21:10 +0800
Message-ID: <20250815092110.811757-1-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9716180009
X-Stat-Signature: wh1wrtbawnr45gzxa4178ehrmbiriqix
X-HE-Tag: 1755249697-350080
X-HE-Meta: U2FsdGVkX19ZB9+5Y2oqbvhF77TKe2jxXSJ32LU36zT/Wxz7nLG5qujLOcN57duMMopr7XEBqOkIRMQxVtvbLvmn8WUL95p61t9TDbsodpbEKaERLvCCWfrv2HYE0GCVBPxYJhMbILw/E8pn+QdvVm9Vgoxia4t9fw4uw9OfpcXUNlN4e4K81M68kaQjY+ra7ID7nmypxwiss5wpJ+PB3RHEd38YXYjTGMFWS8AGzDP/TWHPiTjn7Ih2cMp6IyxtLv43DeOAp8QP5TFfm980qekbVSGBkkNlSL7VXBf9vNCh7UysSsbAS6DFbHnDSJTkdgwh6Za+XwZVuOwPVtqV9S1srTVZ1mJB0kNxZ+Whb70k6mZu2Q9JNWyunb5sbSIdM0njt8JxS4eLFeI5SPk0I4py2y8J6hLdhL4RtpLdhaSAVX+0otzl2oDfhXpkkLQe5DIhG0wRlAkA23kDmUtrsgaJWc8xf0x6WWGlw1G1IgRvkZCc7dbrUcI5tBTf6DCinEr431o8UFH7RAV5bdUs8X2XcubFHp8gul1d81ZXCY+MlOYKpVSmftU1rVP0AjvVlpwgPwqVAc0z3JN+4XOg1y/i8zhrmKc4+HWQN154Qo/47iq9/FulC9EBmybMaeLogv5kYMEP/dUcwv6QtQ5LlkNB+14OZUcVpI/Vn8p3GbSkGlXsGosj7kYomIN6m+XlAkyndrlenqSrHAw2DP7JKmsRxlvE2AD6adrxYNL6H9QgNTDapsqgd8QfCZJXYlyeRKMN+EQDrw653/Kr53BzRuKxhRJHcfFmvQBm8xa/o4U9NsvWK174iEWOX4yqwkdHfKt3MeKOXQ8rbeyXDhygjM8Hzn/mbyy20L4oO6M+Fr3RkKXQjNulA9Q4el1NvlQYfjHp4omY/RiEICWYHRouKoOJ48rIaqz/8X0aGL6v79gzHkhn18BomAov1tAKJYNjs3w5Syt+KinE2fdbW1H
 9Nv0KkQg
 MNGZM8rQ+dUhaC1RzJPG+vcKDUUGO8iUB0F5yXqEhTju3VlI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON_STAT_ENABLED_DEFAULT option is strongly tied to DAMON_STAT
option -- enabling it alone is meaningless.  This patch makes
DAMON_STAT_ENABLED_DEFAULT depend on DAMON_STAT, ensuring functional
consistency.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
v2:
  - Change the subject as suggested by SJ.
  - Keep 'default DAMON_STAT' as before.
---
 mm/damon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/Kconfig b/mm/damon/Kconfig
index b3171f9406c1..8c868f7035fc 100644
--- a/mm/damon/Kconfig
+++ b/mm/damon/Kconfig
@@ -104,7 +104,7 @@ config DAMON_STAT
 
 config DAMON_STAT_ENABLED_DEFAULT
 	bool "Enable DAMON_STAT by default"
-	depends on DAMON_PADDR
+	depends on DAMON_STAT
 	default DAMON_STAT
 	help
 	  Whether to enable DAMON_STAT by default.  Users can disable it in

base-commit: d7ee5bdce7892643409dea7266c34977e651b479
-- 
2.43.0


