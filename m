Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38AEBCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618AF6B0005; Mon, 18 May 2026 02:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8E96B0088; Mon, 18 May 2026 02:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DE686B008C; Mon, 18 May 2026 02:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5966B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:22:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD0F51612CF
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:14 +0000 (UTC)
X-FDA: 84779545788.04.594AAA6
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id C931B100007
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:22:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779085333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+Vy8rndaYKoC59/HF+JvaBHedA+n02w9ca1iTYg2PYA=;
	b=KnC0eMHX5W5XnZnaDyu89jG+DrWCvsyyDPTS0IyIzonTzePFDzboK9XbkY/ZzYOln+C+MY
	f8qyb0SPXHDCrmvfQhDd4AylBiQI9Vr0duX0COMcrQmf4RJqYD08b6dEi4zSdPj66Th0aV
	xZ+1xiFJydwSu3Gpa8K1SII4JcFp4QY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779085333; a=rsa-sha256;
	cv=none;
	b=4l1CIf7DviZVQcWPuePvObSWXF0+KT2ZKh+awXhyzc3I0jKdXGsNQ3uZ9I1w5KteaUUMpV
	mjDb404lkxNdAmY/Hfr/9MLPb83ej8h6XAUehrxYUBi43Ch7ttSF0nGOPwzxaVBdOGQvif
	177U5PlErPOqpoeQYML5fpMOfPtI1Zw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
X-UUID: e2904e72528111f1aa26b74ffac11d73-20260518
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	GTI_FG_BS, GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU
	AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:5632d04b-8b0d-4e5c-8eae-cd55602552b4,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:5632d04b-8b0d-4e5c-8eae-cd55602552b4,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:5d77ffaa1a5312dd419dde7a262702dc,BulkI
	D:26051814171559UCYG5P,BulkQuantity:1,Recheck:0,SF:17|19|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:
	40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e2904e72528111f1aa26b74ffac11d73-20260518
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.40.146)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 590260905; Mon, 18 May 2026 14:22:03 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v2 0/3] Cleanup and fix tools/mm/slabinfo utility
Date: Mon, 18 May 2026 14:21:56 +0800
Message-Id: <20260518062159.80664-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C931B100007
X-Stat-Signature: sumj1p79n4i76amwt9pp9n4feoih8yc7
X-Rspam-User: 
X-HE-Tag: 1779085331-84278
X-HE-Meta: U2FsdGVkX184dixl+RPhSwDG+xZUEmEU0iAQFc+m6HmthgEYqZKQrvtjxX61js/3L+Wyd9R/g6FMzY7RDB6AQB/wh02Ccs3rB76w2sz0/3ct6csglcMdIT+pkwLxrJYybz7ANKAsU5RMKZhKp1ZlJjzgeorI8INN0xVcjT5Ps9ODmmnzdkSC3kT2yqQ36wRJwtHTdWfIhduK1dKC4FnT4wfvaS8eBZxBUHonIpgW+Tp4xBtrOuMSg9grzMOiRGiFZmVdoTjfWJFHb+44iNWp7TXQ4EabdECVxU6C8HgxT6SOS8YE2z5s1+22ph9MZskBvV+lRmgf3LRRHjALTvEjaQYT+msvMDH6Jn0A8j6av2tMoY+4Gj48NAzXsurfIlRsPnMi+eTDEhO73YlBhEXnrix+RQcORPlHEphSHf25fLIh9e+3mlPNhfzK+nzOImVeqbjmsTq/9hdeGdEASlkDEVOD/eUlvXCtHbfhmsJYJoXqXqSOJ8yFgjfX5WAbwGZg97xkrzFqU4aPzOYgdKI/AAjRU563E8i8po42A33gMsD0o7EZY9Z6p3luw9LVoMbyYIdOY4aiP5shCArBCFY1DUDfaYz8t14SC8u8LKxcURTz8tii6xXdGeYQzhUsEFSFubvxd+U+0ZGARomM1Iht+RqiGWLy4UMVkg+1VMWQfwEqP94dOdIh1XjJJjnbj2TYKbyrhPksltk4R7nw/CG8XfE//V4BpUdKZjdoZZ78jaEkC18ZBaNDXNAT6rkeXZ6XR0Gog2w6Ik90ii5d78fPVRBCypcfyWo3FpUVX1ttbZoKcqgciaEQ5GucSq/5EAKRK5qE0YUtXrOKrEsRUmLm7vYI1+GUdZFAkkmAjkZvayCvnW3SjR2t+qHnpw7kKih/i+WMN20C2juKPapClI/XxaGa1LxitH1IIPvOqa5wwv/4V50zDWlIxbdMlDIOnWBwfNNbGSKOQ277a99teO1
 vzEXIymq
 a/ZtPaBl+Lrc+3gU8PESJdKGPV34/aYd61Ehm28FSR28tvp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes one bug and cleans up two code quality issues in tools/mm/slabinfo:

1. Fix trace disable logic inversion: when the user intends to disable
   tracing (!tracing) and it is currently enabled (s->trace),
   set_obj() was called with 1 instead of 0, which is opposite to
   the intended behavior. All other options (sanity_checks, red_zone,
   poison, store_user) in the same function use 0 for the disable
   case.

2. Remove dead assignment in get_obj_and_str(): `x = NULL` sets the
   local parameter variable instead of `*x`, which is a no-op since
   `*x` was already set to NULL on the line above.

3. Remove redundant slab->partial assignment in read_slab_dir():
   slab->partial is assigned by get_obj("partial") and then
   immediately overwritten by get_obj_and_str("partial", &t).

Xuewen Wang (3):
  tools/mm/slabinfo: Fix trace disable logic inversion
  tools/mm/slabinfo: remove dead assignment in get_obj_and_str()
  tools/mm/slabinfo: remove redundant slab->partial assignment

 tools/mm/slabinfo.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

---
Changes in v2:
- Fix author email mismatch
- Add Fixes tag for the bug fix (patch 1)
- Remove unnecessary braces in patch 2 per reviewer suggestion

Patches 1/3 and 3/3 carry Reviewed-by tag from SeongJae Park.

v1:
    https://lore.kernel.org/all/20260515065325.4009527-1-18810879172@163.com/

-- 
2.25.1


