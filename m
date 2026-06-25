Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32510CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F636B00BF; Thu, 25 Jun 2026 02:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F746B00C0; Thu, 25 Jun 2026 02:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12EC46B00C1; Thu, 25 Jun 2026 02:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF1136B00BF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:52:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 720981C33D6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:52:15 +0000 (UTC)
X-FDA: 84917515830.30.2C01341
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52DC4140005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:52:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782370333;
	b=5wHGg0LWbRWJa007Txg9nKYX0Ebuj7H38ia9NYzNlO75nAJ8r1CrR0K+E91qlD22Iajewm
	6nWXMwf1aCCS/pwJlp/evv0DFREtiaj/PkELEe8nRZJf7pUgia5wUYeIuPccvPKTkKpd4f
	7lW92GMeTpF/4pnTwSVzuqa5ESk/ASU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nIm3r25KSF8AoFcuWwFdvb7aPEE3ohDM2tgYo05dM20=;
	b=G01aABS1wCFAjUqFrRdy/4tAsl+Yq/utosIHKghFzQI1lZzOS+iOIQuxcDzM9GQvRv7zu6
	yMv0z0Vk6mZzVoo0IgkRbV8j60J16nHJvJDa2EK9twDTpZvaIEeediepEk6wOqY1gOKwPC
	J/GXiTZoXyeZr2hq1muqgDxSRk7Wjak=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
X-UUID: 5e50d808706211f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED
	SA_LOWREP, SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:efb154ac-1be6-46e1-bc6c-340a1086e7ee,IP:10,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:efb154ac-1be6-46e1-bc6c-340a1086e7ee,IP:10,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:f0e0539f52f3f11153d60348e780fd73,BulkI
	D:260625145204QCCZN525,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5e50d808706211f1aa26b74ffac11d73-20260625
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 778511652; Thu, 25 Jun 2026 14:52:01 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v2] mm: annotate data-race in cpu_needs_drain() and need_mlock_drain()
Date: Thu, 25 Jun 2026 14:51:53 +0800
Message-Id: <20260625065153.1581419-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52DC4140005
X-Stat-Signature: m5asi3guxp1pjgc7htwajc1ysf3nfp9b
X-HE-Tag: 1782370331-154140
X-HE-Meta: U2FsdGVkX1+bJY4E2+SIOOuEIYl9l9dn76ZolZeM6AD8dUnPzfV5SV547kphD9h6S2bu4UMnB2e4wQC45a+vPH5/fKzh61B0bNp9wG93Vhz6TYpev9oSphBQQjLBc3owfiQ99ojoQCINejJXxpWGxYrpf+WBGp2XqQRHUkrOVhtkjkt36HfsqKUJzlBUeAngwYVD0elzQCuXhqVkMnaQpHgeUKODLR0E9Wms9RV9eNEQoiFDlIKOFJglWMESQGQaLAjclL4kK89dHVcDXmgaCpWdWjhZZhQCxknXI3mIKimbJsop93D8wCsQz8pGUZaYxFPjCFS9mHuekAl1uRJRb5f/hBwJrm/321K0xa61FVqApwiCLPcifVg3vqGMoqMgyFfXMay9DwbkRQsc/82GSySwrK6fHbbNnEHLbSIe+glth7vmmYi6tGNOe1J77uJbPIkTs2wCv71Cnx2Z4u5k07D5PlAjQ8ZgS+xbR4XXnpuIrRqBr1AKurrht73gCvznTA2vEnb6zTCRsEeYns4TSZb/v343P6MaUT4Tjh1KJ8Nnf3LjOHoeL10cDizeJzcVBU2hs7l8RLTmEoJ4g0q/xlvLTS9L8VwZOy/gbcMqJz6HkWIbBH8Jvf+NoQ71Ar6VAetBLIEkxLKmmfKAQn3e27Wpc94omBBwzP9/bqENo/rAgMmnkE50T41kLVif5QI2OcfkCc+Y1c/gUxbeiMRD7x93snaq/8J0xBtkA0m7mTiIpNtzfRT644/bwHxYucXAI/XctKeuQ9I3HwffXHfkUdCzLEhqO/9Sd8vYlHeK1w8tqYYeVXuNm3SKTJ7S7ykXjemyGsCOonDk+ZWWuEhS64mxzIHkqCAyI28ZSXTUxmlQxSXCTfJZ2XMZUynrKCn5Jqgx9pmnbJ67SjGd897BxDFAWa3UYxIGyotJzg/jw5evfgECxwW/dPiwlmkL3IysL+s2oswQXWnr4XBLp2u
 yOmJ1OFZ
 w0b3cTui2yRJEMbosr5gqUfU3wc8TaGp6pl2IVztEI9lUqDFaPf24IwIqJMUM1oi7gRzFcyCqsw8zf10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
per-cpu folio_batch->nr without locking, while the owning CPU writes
to it via folio_batch_add(). The same race exists in need_mlock_drain()
which is called from cpu_needs_drain().

Reading a slightly stale value is harmless -- cpu_needs_drain() only
decides whether to schedule a drain, and the next iteration of
__lru_add_drain_all() will re-check.

All other callers of folio_batch_count() either use stack variables or
access their own CPU's per-cpu data where no race exists, so
data_race() is added at the call sites rather than in
folio_batch_count() itself to avoid suppressing KCSAN warnings for
future callers that may have real bugs.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
Changes in v2:
- Use data_race() instead of READ_ONCE() in folio_batch_count(), as
  suggested by Lorenzo. READ_ONCE() is unnecessary for a single-byte
  read and imposes overhead on all callers, most of which have no race.
- Move the annotation from folio_batch_count() to the actual call sites
  (cpu_needs_drain() and need_mlock_drain()) where the cross-CPU race
  occurs, rather than affecting all callers.
- Add need_mlock_drain() which has the same cross-CPU race.
- Add comments explaining why the data race is safe.
v1:
  https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
---
 mm/mlock.c |  2 +-
 mm/swap.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..fbdb5018e2c3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -232,7 +232,7 @@ void mlock_drain_remote(int cpu)
 
 bool need_mlock_drain(int cpu)
 {
-	return folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu));
+	return data_race(folio_batch_count(&per_cpu(mlock_fbatch.fbatch, cpu)));
 }
 
 /**
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..d046428caed6 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -828,12 +828,12 @@ static bool cpu_needs_drain(unsigned int cpu)
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
 	/* Check these in order of likelihood that they're not zero */
-	return folio_batch_count(&fbatches->lru_add) ||
-		folio_batch_count(&fbatches->lru_move_tail) ||
-		folio_batch_count(&fbatches->lru_deactivate_file) ||
-		folio_batch_count(&fbatches->lru_deactivate) ||
-		folio_batch_count(&fbatches->lru_lazyfree) ||
-		folio_batch_count(&fbatches->lru_activate) ||
+	return data_race(folio_batch_count(&fbatches->lru_add)) ||
+		data_race(folio_batch_count(&fbatches->lru_move_tail)) ||
+		data_race(folio_batch_count(&fbatches->lru_deactivate_file)) ||
+		data_race(folio_batch_count(&fbatches->lru_deactivate)) ||
+		data_race(folio_batch_count(&fbatches->lru_lazyfree)) ||
+		data_race(folio_batch_count(&fbatches->lru_activate)) ||
 		need_mlock_drain(cpu) ||
 		has_bh_in_lru(cpu, NULL);
 }
-- 
2.25.1


