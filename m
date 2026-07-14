Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2087C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52E76B0005; Tue, 14 Jul 2026 04:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03FF6B0088; Tue, 14 Jul 2026 04:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BC96B008A; Tue, 14 Jul 2026 04:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 693896B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:14:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB1991C0231
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:14:36 +0000 (UTC)
X-FDA: 84986670552.18.AD7914B
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id B478540004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:14:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784016874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=KlbBZBMghzYLmdEwCeMzA2yspJJ1Tvu2NKwiTx/ZtGA=;
	b=0d8na8g9GLzxWmTNggbUocbpB5Ocmt6usDSpy9GuX4TmLV8DuTGs/9q85fXw6D80C/6LPW
	x65vuZQnvgcB6UiKwwbfHPeBhV3z4yRLpDSjkgmwFGchS2ycAOJiyh7aheDry2i6c4HWm8
	dJdu7NPSjsgXBDgGc1aMShhLVtFHSdw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784016874;
	b=LeZ6DiYv5XL6Y0iEBKs/SvXio0sg6zBigdDQw29b65mkUy2Jns7FMLmerwI2M2jki+4KSA
	K+pqJUEuUtUT6n90qseZu9F2pG9Hr2H7C06LiPp/q/rBBjxIix/6liIzAPA8yNxPkGLvmw
	NBrIWkf9Y6Atg+6ozkj2xAewa8z5+5Q=
X-UUID: 05adc23e7f5c11f1aa26b74ffac11d73-20260714
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1c751aa5-e02a-4755-9f61-ae73243d78ca,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:45
X-CID-INFO: VERSION:1.3.12,REQID:1c751aa5-e02a-4755-9f61-ae73243d78ca,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:45
X-CID-META: VersionHash:e7bac3a,CLOUDID:dfdd182856bcc302edbee6b71e9bdf3c,BulkI
	D:260714161426D0BFWHNS,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 05adc23e7f5c11f1aa26b74ffac11d73-20260714
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 327767584; Tue, 14 Jul 2026 16:14:23 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm/kasan: fix swapped read/write lock usage in stack ring
Date: Tue, 14 Jul 2026 16:14:08 +0800
Message-Id: <20260714081408.1596052-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B478540004
X-Stat-Signature: dwy47ttx4jyzi5xtqqpa5rsz41qaj5gz
X-HE-Tag: 1784016872-709540
X-HE-Meta: U2FsdGVkX1+nWLSbC3VbIUvCmFb0XCYvNyEp0KvdsnfaZbg83hLJ1XNkDUC2sECDSAuCy9IdgS5eC2Il53fTO0gQrRWgeRM7+1Ag2z8r1XQflzFLl4A7f8a72fvJ9ygNMvpVoDzKo/BQT1mLXgV+yhU4xdNlDPv9xN9722qwFiZiZa32TdX+JSk/QrJBcVQ2+pTGhQvtke+iScqsoE3zsGnwRSNZB3XBG+I8y/YLnEwS+W2umTlmnDjDxQNw9Dvv73RDtE82DVqtL7aV/se2t1AxiTPPAyO9B8VpV5H/994CHTYMpv6jEcl3tGBUAKBOgAYCDBbgPhqTazWZ3odFeP1me7//YsVgxUY2mQes/w1yGMf4a1gaaTny65FGOBerS383m1tdNhWswU6DKzS3MPb1WwxTBW72RV0gKze1MT28J82qefT9I74biadHIGEd+s4jmBmCakPjlUcumdBHZAOuD1voncclhpBvw89kSEBxqG23GpEy9xjkIjEwDd7SWTTng29jMShQKa0ZbnJhxhrBe5ndKlOOztB1O0Fkbi4ov10SOcF58qGU3OLZjtCLn8zboDte8LHRbuGjJIkOIh02XAypmd7KXqua/5rLIHBg0eR3PoLbx4UeVCFLQdYE2u3SNXlNGPkhQ3uePhb51alDi/4epSQAtl9mlwWA4z6d0P5GavZK2u99r9sAtTcRJkHFtPFydM+duvkemz6Wf/OlADrAgvjdVA5pcuLbghoXDXn2EL4mDsdvATcaTfzUcZrj3tHgyqu9lZxSG7brYecstKdOPW1aILin2JIqszb6yujM4fJlqSxvwq3uzwOucolUxka6ykvBwCOCUUVYoegChoHkhxY+Pa2G12bvcG1dJ0VaXIIIozJbUQ4bJT/SUrTRlfJA1VTNb62oMR3qelTyzAVfp1rokOgGzl4b4y4QQo9xRyrgpkZO8Yz5kMBoKKQswW6hUq3TyVfae0r
 m9rhRXup
 Nl4Qk1ZSkdsFwRa4YBvVxthraXy+QQ7+vYyFv8kb3X8Ol7PcSklY7iX5zwctMIfghxfWDQcGIXT7KJIs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The read-write lock semantics for stack_ring.lock are inverted:

- save_stack_info() modifies stack ring entries but uses read_lock,
  which does not protect against concurrent writers and does not
  block readers from observing partial updates.
- kasan_complete_mode_report_info() only reads the stack ring but
  uses write_lock_irqsave(), which prevents concurrent readers from
  walking the ring simultaneously.

Swap the lock types to match their actual access patterns:
- save_stack_info(): read_lock -> write_lock
- kasan_complete_mode_report_info(): write_lock -> read_lock

Fixes: 7bc0584e5d2a ("kasan: implement stack ring for tag-based modes")
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 mm/kasan/report_tags.c | 4 ++--
 mm/kasan/tags.c        | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/report_tags.c b/mm/kasan/report_tags.c
index d15f8f580e2c..62576b1470e1 100644
--- a/mm/kasan/report_tags.c
+++ b/mm/kasan/report_tags.c
@@ -39,7 +39,7 @@ void kasan_complete_mode_report_info(struct kasan_report_info *info)
 		return;
 	}
 
-	write_lock_irqsave(&stack_ring.lock, flags);
+	read_lock_irqsave(&stack_ring.lock, flags);
 
 	pos = atomic64_read(&stack_ring.pos);
 
@@ -99,7 +99,7 @@ void kasan_complete_mode_report_info(struct kasan_report_info *info)
 		}
 	}
 
-	write_unlock_irqrestore(&stack_ring.lock, flags);
+	read_unlock_irqrestore(&stack_ring.lock, flags);
 
 	/* Assign the common bug type if no entries were found. */
 	if (!info->bug_type)
diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
index d65d48b85f90..6aa09122f09e 100644
--- a/mm/kasan/tags.c
+++ b/mm/kasan/tags.c
@@ -110,7 +110,7 @@ static void save_stack_info(struct kmem_cache *cache, void *object,
 	 * Prevent save_stack_info() from modifying stack ring
 	 * when kasan_complete_mode_report_info() is walking it.
 	 */
-	read_lock_irqsave(&stack_ring.lock, flags);
+	write_lock_irqsave(&stack_ring.lock, flags);
 
 next:
 	pos = atomic64_fetch_add(1, &stack_ring.pos);
@@ -131,7 +131,7 @@ static void save_stack_info(struct kmem_cache *cache, void *object,
 
 	entry->ptr = object;
 
-	read_unlock_irqrestore(&stack_ring.lock, flags);
+	write_unlock_irqrestore(&stack_ring.lock, flags);
 
 	if (old_stack)
 		stack_depot_put(old_stack);
-- 
2.25.1


