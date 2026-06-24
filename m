Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B2FECDE003
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 09:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDDA6B0088; Wed, 24 Jun 2026 05:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EE56B008A; Wed, 24 Jun 2026 05:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC8606B008C; Wed, 24 Jun 2026 05:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C19976B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:26:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B9E7402B5
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:26:21 +0000 (UTC)
X-FDA: 84914275362.30.B42A210
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 296CEC000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:26:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782293179;
	b=oeTqMLJCsNhCtp7nKLpPHQh8UW5U4auKSrwxnTa+KMIMRtiqlfqEyfQUtvYDRGPplleY6e
	dkbDxKoZ4+L/QMc/7Ua/jCuCLExQqIVgfihBP+ETgH7kHi1k5GgCFpiHWq3Gyp4CEUoQLC
	0k6N+h7B1w2LLSS92bCyCRtKDz/UnbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782293179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=WA9PChKbSpGYwzSxdJjqcQqkAg89EZoWIzjvWgWqJ4Q=;
	b=Ftc9442AKAEF0YweW64FfvRAG8esTlzFJr7jyWOPMPXgQaVkataef3eXVqCgk+xv71Tm1k
	NdO+6gnOV8DcfkRNSVCiBgmilWKo3NPiwVNyhU/S44ltEVM57DbK0Y1qqZsKzeaHDVHVu2
	/MsN2Z7RdGXscxy3I4JCuzbhoUPc6UI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
X-UUID: bd2fb2fe6fae11f1aa26b74ffac11d73-20260624
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
X-CID-O-INFO: VERSION:1.3.12,REQID:6763ffaf-b635-4b57-bd6f-c9015ef85d01,IP:10,
	URL:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-35
X-CID-INFO: VERSION:1.3.12,REQID:6763ffaf-b635-4b57-bd6f-c9015ef85d01,IP:10,UR
	L:0,TC:0,Content:-25,EDM:-20,RT:0,SF:0,FILE:0,BULK:0,RULE:EDM_GE969F26,ACT
	ION:release,TS:-35
X-CID-META: VersionHash:e7bac3a,CLOUDID:d43ccca23dc672e1d1517885b93eba7d,BulkI
	D:260624172613TWL0RJG6,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	850|865|898,TC:nil,Content:0|15|50,EDM:1,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_AEC
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bd2fb2fe6fae11f1aa26b74ffac11d73-20260624
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 411350629; Wed, 24 Jun 2026 17:26:11 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm: fix data-race in folio_batch_count()
Date: Wed, 24 Jun 2026 17:26:06 +0800
Message-Id: <20260624092606.1083449-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: pfqt5shsqpzcx7wrf1yiq1w5df49ibpu
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 296CEC000A
X-HE-Tag: 1782293177-334851
X-HE-Meta: U2FsdGVkX1+fUrVmigTluOTbC0t3ABnN9U9Q/I/MgECdYb9SCyDqH/6CdIlJRHnxPnqOO9Wr0C10RfnekVGYJtBAvP8vC96cHXVd/dNDLGttbg3/9zN/wbZ+VvwWH+VPw8F4KW0/T8OH5sAsxwexF8jtdql4MXduVKppz7Us2VeAKEgHmqAFreWDye2p9OReM4lH7ymV8AB64hqE8DRA5JOJRxON0Cbeu+mn+l8EH6uQoaNfRmJrrCjbMiEhYoRM1QmC1kx/dhsjSVsqgTX/ChlqRFPriC9WjTjSrjPBLSA8pqEo7dFtPgOGkS6Agj3QZZL0V1MAsmUhXRYTUSFH8jCnX5N24yUCPxxfj33kzZpztE5PqttvoX2eJQa4L4+pl2p+YKTPDU8n0wW9CaUJFoTN1biix0vLOqHAFQfHbKBY6hQas+9xw7r0HN1sLz/J7p31gizNsV3TNnVleu4Hs5/TNUtaknZ1L9JAc8kZbeOHPl6mveO35Zgyq6NxXx9oDM//XbJwVBB9bnvwyy+IzHaRbsfXNf727pUToo9xw5ilpYaKJmKpOHo4ptIpe+BX9LuFFoTdUqF71oBO+GLNCyAvONuaMU/XNzJGiTzw0Jyha/HoEOvuEFNTMeSY/sd+z8cRtaA3UWV10dMxWlr+aEA54yu7w6b6lsuz6VmEMBvNIXtJ+euRCUrYUOv4Wi3nSWN8XfUE9v9tVjvwQlkEg34MqiDhzoIT2jbxc7FzIQYJ8ljec7iWjkLfx1+uooh4HawKk2uKrH95AQ8wfTPtC1gkXlgS+njzOBeUCVwGwFc7HIt1mSUoNgjFfIdbk43ZDw9H+3QjcNbN8urUBxoDs60ZzjQxsVrPbDVND3h6u5773nSZ8n2v6p+iypN9OpBZzis8DoScOT4wQ90CEeicVQvCrprS2l+pMT+svoHBqRllDrtI/RXTV7m52kHmVCoOwPzV8d6FPvrOi2KQXDU
 c85fw/fU
 itBRjfm6bzOt6a4EcumwgvggXpDeV1mxJjZMWZ2WIVKBvC+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KCSAN reports:

BUG: KCSAN: data-race in __lru_add_drain_all / folio_batch_add_and_move

write to 0xffff98fe74c015f8 of 1 bytes by task 45153 on cpu 2:
  folio_batch_add+0x30/0xe0

read to 0xffff98fe74c015f8 of 1 bytes by task 45175 on cpu 0:
  folio_batch_count+0x0/0x10
  cpu_needs_drain+0x253/0x430

The write side is a per-cpu local operation (folio_batch_add on the
CPU that owns the per-cpu batch), while cpu_needs_drain() reads
another CPU's per-cpu batch without locking. Reading a slightly stale
value is harmless -- it only determines whether to schedule a drain,
and a subsequent check will catch it.

Use READ_ONCE() to annotate the read and prevent load tearing, which
also suppresses the KCSAN warning.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 include/linux/folio_batch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/folio_batch.h b/include/linux/folio_batch.h
index b45946adc50b..1e31e058e19d 100644
--- a/include/linux/folio_batch.h
+++ b/include/linux/folio_batch.h
@@ -53,7 +53,7 @@ static inline void folio_batch_reinit(struct folio_batch *fbatch)
 
 static inline unsigned int folio_batch_count(const struct folio_batch *fbatch)
 {
-	return fbatch->nr;
+	return READ_ONCE(fbatch->nr);
 }
 
 static inline unsigned int folio_batch_space(const struct folio_batch *fbatch)
-- 
2.25.1


