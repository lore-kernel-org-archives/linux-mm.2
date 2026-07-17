Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94213C4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:11:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA826B0093; Fri, 17 Jul 2026 03:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482DC6B0096; Fri, 17 Jul 2026 03:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398C06B0099; Fri, 17 Jul 2026 03:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 148216B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:11:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84985C0302
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:11:40 +0000 (UTC)
X-FDA: 84997398360.26.4611ED1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCBFEA000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:11:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TtyK9amO;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kRja4aDlEGiiIQuTIJfrSCAb+ZicMh3kvGxb3+bkSi8=;
	b=SpV3dPTbgHNM1jL7n251rdHCQ8SyA+/61d/HHtNNQWTtRMrgECXhX8wf0jgXP6ssjJRZle
	8BVVKfoCyd7YkEYVCS4QiDCELVHlmA+w7fhXL3vTXGSMF/2q25CLhHmRy/g+rG8CFKd/Hb
	YvOb5XKHi0nj174BI/uIMuZUuqvKa98=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TtyK9amO;
	spf=pass (imf25.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272299;
	b=jf5/ffzOZvOcKx4AjqdkwQfgB7Zl564G+BT6BzwPxWbPC+1hN59ZwT9VAPJqXxquFnyiyT
	L4gPRlkDOrZCCqlUV6u9n108SWBEg1Vrko+kuX0zRS5VkuyDx0WiFh6e3JO5hoZuQQDA/C
	bablerNXfzaM7kaQsAU4WixNVM0u/nc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784272296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kRja4aDlEGiiIQuTIJfrSCAb+ZicMh3kvGxb3+bkSi8=;
	b=TtyK9amOGWVxYf0MrPrrpAXP4jz/nVlsU5MqbHcDMUitw5Wo8spvtI7zbt3YHooV1T2y8U
	Gqyv9E6b9GFlbL3rbUcI5070oV5k6RB0G/BqosOOXTM5NtyempSrPqDQOY8Wge2bViEDfJ
	orTsOkQ0On3bG9M1uqQOpujTxAWMw4s=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2] mm/swap: Fix swap_cluster_lock() !CONFIG_SWAP stub signature mismatch
Date: Fri, 17 Jul 2026 15:11:04 +0800
Message-ID: <20260717071104.73467-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCBFEA000D
X-Stat-Signature: eiri9cchjgrqb3uj116a91mrbfycxuc8
X-HE-Tag: 1784272298-621121
X-HE-Meta: U2FsdGVkX19QRjEUdN7sQby0Kra3loahz1ks9XgBEqgyh6syMWDsuGUXxj51hQIATZ2QdcH/zx1nY7nRFzOquM8THfjNuqWI1TSrERmhK8PslsHKeLWG5JC48I9kQzuu0chTnOugXznRi8wyY3AxKQAaIutIAVOdXvD9Hw94MkLcpWqkfaqe5xw4F1vkrDT493aob4AvFlUo+gXq9WUH7KUVwWM4xcyavgMzklBG4W/MmAaI3JA7aAbMh5Jh8ycdDx6mkjJIWl2zZPguIjvHikM1JlToYuW14v5Ldq1yagoHIMKpSej8h1L7J/90LSVNsaH8CXL3YNfecXDsJ3M+w2AZeVoe++Hgjh+/l9d8SPSpLp1T3SfX+nVaYwhsoqrESafftcfe40XBetpuFFWSZcPWH/3mpcCaS4cTbkAZRKD4JCAWtRvOsF1F4LLKteYaFWO9KkMSWlUe62We/2AiSTaOtQDGrIXTDrU9zoV3r7imM8/OTTYOGftnCE1v+CXaMXA37Idhl6y9WnlCxWO/od/58fI879tDfLw+JRtzFLw3IEtU/0SIH35aaqnz7KhiTLvdKRpiyMBEdgosFakgz+SuYSMTAZWWDl3ADuy9A2VXo+oDODiCEJxRtFhVaOkjbap3+0U4s9Z+pV/LR0FhA+uFjFcDy61vGr6QuevIy8JlR3pVi2TLnj5+1KAGW7/grTGqo6wWgWb2q0vpIX46SyZuqKSRLNHhjJ3iN6/sp4xYcsq81/weWlaEOff8U5yA8YF8rsICcnBo/3y7zrf3pR3jIKZyLbfuArRdOjmRk/9/0sPBxKda5GtGkMOfgSSowzgGqL7+CVPtKmmWng84g0kyPpcI+ES+0CkN+7zdTJAP93Dxyi2lQcjOfkaLE52mLicq/vaqS3UsB+4BuOErCrvKbfVqhEz3YVm+pjKufXeHWIZ6qmD0Pz4T3wdHzTtRclREJbLsH/zwTogm7Rg
 CWoDnI+3
 qkB1ffkbk+QdcgruhNasm9YdXVvOd07Ve7X/qVnL1QpspQycspJp3BFBNPvx1kIe3AMHH1m8LKBgSzSC/R1q7nuPkiEfZ0yfj+wrFehouaJ2c/6Sx5TkHxBaYVNMx2V8/cevT3sc/kJI2dIfyhs9gqaFo/D5uEKAuxLi7dwwPV+p2CBhhV940/JQKeNVm7nJFFoPCeb/wozZ/KoT0qrdTtmxNavAY07TH316u/dbNlg3fRh7uEmK/r43219iJ3dp7QOTkGDlZBaONVJ3ahcsxKnZcj9gsD/BawWFX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

The !CONFIG_SWAP stub for swap_cluster_lock() has mismatched prototype:
it has an extra unused irq argument and uses pgoff_t instead of unsigned
long for offset. All callers are under CONFIG_SWAP so the extra parameter
is dead.

Delete the unused stub function entirely.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
---
v2:
- Drop the stub entirely instead of fixing its signature. All callers are under
  CONFIG_SWAP, so the stub is dead code. (Suggested by Kairui Song)
- Add Reviewed-by tag
- Update commit message
---
 mm/swap.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda42..d7834888e0d2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -336,12 +336,6 @@ static inline unsigned int folio_swap_flags(struct folio *folio)
 
 #else /* CONFIG_SWAP */
 struct swap_iocb;
-static inline struct swap_cluster_info *swap_cluster_lock(
-	struct swap_info_struct *si, pgoff_t offset, bool irq)
-{
-	return NULL;
-}
-
 static inline struct swap_cluster_info *swap_cluster_get_and_lock(
 		struct folio *folio)
 {
-- 
2.54.0


