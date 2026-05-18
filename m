Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B38CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8E66B0093; Mon, 18 May 2026 02:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A756B0095; Mon, 18 May 2026 02:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48CA6B0096; Mon, 18 May 2026 02:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A80D36B0093
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:23:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6ACF0C28DB
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:04 +0000 (UTC)
X-FDA: 84779547888.13.5915D01
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id BC8B0140005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:23:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=el9fR9/td0zYSrEJRf63MUj+pejJRhGK+7Llst9mnHc=;
	b=EVH1LDjB18q6xa8LZAqp9T+pNFUQBaQP7Xa034sJLQ9p/KJsnuznJbHOqxNlNH4hM0sKUT
	d5lNVRs3SQiso+KzewTA5I3ZsozMN8sxzM/A0alYYZu9IaOOg+3MP7xGo0v3ToR3Ak6xuV
	hh5kEf3I4ioTqj03NMxzSgmbi+h1s6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085382; a=rsa-sha256;
	cv=none;
	b=skAYYnIqwvokW0LIZCKChGzrrNqH0VtyOdG4OqiQt8yDtD6HrCkMcnpLX7JF6pmEwVki/b
	rnghqTp/CTZV6uIJRltsT6NmkvIvf0u1dLgSTEBP0VxaPG289WY62+kxqQjYEhPawDOeWo
	NSns+lixlCV0/OQeb73VR0pFSK0oSaQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
X-UUID: ffba6b4a528111f1aa26b74ffac11d73-20260518
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:59f05866-5562-4e68-b067-320fec2d9a47,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:59f05866-5562-4e68-b067-320fec2d9a47,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:dbbdee0b3b701250e6f381e26478b264,BulkI
	D:260518141718I6N2R5JJ,BulkQuantity:1,Recheck:0,SF:17|19|66|78|81|82|102|1
	27|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ffba6b4a528111f1aa26b74ffac11d73-20260518
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.40.146)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1454384281; Mon, 18 May 2026 14:22:51 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2 3/3] tools/mm/slabinfo: remove redundant slab->partial assignment
Date: Mon, 18 May 2026 14:21:59 +0800
Message-Id: <20260518062159.80664-4-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260518062159.80664-1-wangxuewen@kylinos.cn>
References: <20260518062159.80664-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC8B0140005
X-Rspam-User: 
X-Stat-Signature: eum4wpa3b49dxqhgdadswrq6moq851ad
X-HE-Tag: 1779085381-347272
X-HE-Meta: U2FsdGVkX1+7GvY6kHT3IxBUkS9cRLHyAyo2EtSdLJ9l+9E2CpQ2/qoKzb/baLSg26D4XZDwtYUbynrcvH+kvZ0Dtp4NUsvpz8wO3zUcWPTN7Dq1pT+6Go3ZzsrBCsGhDxsDQ2uqSlndaE/vldZ9/zsRmQNev7esJSQubuN5KB9gBVvXUqXOHAhL+u+Nc4l1g8ti6sse6yTG15GJsWtlePvl0o/Cbrbf+gMHsacUGfB1kpLBLkycBFkSV2xIv+HjR6gxOg2J2fbk3NEYQILww61Knsx3VFqnM37VSaJaCVzZ92icTdJQrNI3WXWRmkBYKcWQIb4wFNVpJA+XzgH3IKw/cvIy+j71KXBXMWHNgAICOFZ0PHlrm2t8RDTDz0uJoGYKIjhTL635IxBHtZSmrrKpedCfsyovNW2TwjIhtkrew1zeobfRipse6Ya6A5Zu7/fIJerqzx/EiJlboaatOcZcfkyAlwYE69/MOBCwhN8JLNdfAGBRW8mcL631XPan6ROCG6wHUPq+Dsu74jGMg4IG3YcE2MIutLmih5MqPrFwBUW9QUNGjwLXb6VPJqOD85aoeyEQLG4pijUgDQsabiIkpJlrwR5bWr/AWjO4lQw6X1z2hiaF8ZpY0v0rgSMN2rSKCm8ZMS8UWckyRODRrq7TAPn0JCFApr9po7cs5fH9ptMc1N6VFOFOcWQIIWEWZv3g6SRQV1dZslZPuIwi4ZDfW28rxWrPrcwrxSD0dktk7NYKAdYrCD4PrvWDCeAngj3RSC1ZD7rrqExucvZ3f8IqCt4zZvZjxhHz4ymIbPDmeKfsyjfpQItCJ6e6RdTiq3EOH/xr4X1jDp7Gsb/6ipM+EvrJ4fUh1B9Akleylaj38HhKOoLzJegrUaM93dp0kYFbLTNbeM1Dj3ct9Jw/xPM1nz7BDmgryINH8L6qpPd7WryH3Wu+i4cP5A7g55h5Tr3nVnoHNSQAgOuRqOg
 6lxwQV5I
 7K+oNvMFJhupaHg0luM8zgoF6OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slab->partial is assigned by get_obj("partial") and then immediately
overwritten by get_obj_and_str("partial", &t). Remove the first
redundant assignment.

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 685bcdd03568..87570c22b151 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -1265,7 +1265,6 @@ static void read_slab_dir(void)
 			slab->objects_total = get_obj("objects_total");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
-			slab->partial = get_obj("partial");
 			slab->partial = get_obj_and_str("partial", &t);
 			decode_numa_list(slab->numa_partial, t);
 			free(t);
-- 
2.25.1


