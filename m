Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A063C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3985A6B0092; Tue, 15 Sep 2026 05:40:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322226B0093; Tue, 15 Sep 2026 05:40:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212096B0095; Tue, 15 Sep 2026 05:40:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5096B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:40:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3AEF80376
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:40:02 +0000 (UTC)
X-FDA: 85215500244.05.31961A0
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf09.hostedemail.com (Postfix) with ESMTP id C252B140003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:39:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789465201;
	b=NeAsT4uiAl//AnoMbSIQfeyptOTSZXj+5ujagWCst+PwToJ6niek0e/0e73bdMd05LchaR
	oVSBFkUX0kTBsrh1NN5sKZ3CKsjChxs+jeSnnfFxw2Js1301CgPeZhQRx61zosnURTzeiw
	mf7RzE/wz/vZKz7lMWp9iYJoD5IYDkY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789465201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=+fO13wgGnmxZ1EeA1lGC0PJIzPqWqQxrFyUro4sDzUA=;
	b=1szVhF8izk/PqBSzoES0oDctmeJJIW4P/n52RoYkrfQ1o9scrEtJJJ/6waa/wIorGg8mxQ
	430B2akumX+QQVBHMQjUI39P/bgaRUP0ALXKoi1yuR5T6DiBjJWaLnCUPougoCYniFnWi3
	KRVIPm0u26PXMoOXiIW96m2gx0Z3QA8=
X-UUID: 6239f3d8b0e911f19a56ed5b684f684d-20260915
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:da4f0715-e686-4745-b629-eb1e25057181,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:da4f0715-e686-4745-b629-eb1e25057181,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:7b889e1e0295ac8b8f5b76b6da3ca3b3,BulkI
	D:260915173949X42TEFZR,BulkQuantity:0,SF:17|19|38|66|78|102|127|136|850|86
	5|898,TC:nil,Content:0|15|50|99,EDM:5|-100,IP:-2,URL:0,File:nil,RT:nil,Bul
	k:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0
	,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6239f3d8b0e911f19a56ed5b684f684d-20260915
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 379612814; Tue, 15 Sep 2026 17:39:44 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm/damon/sysfs: propagate damon_call() error in turn_damon_on
Date: Tue, 15 Sep 2026 17:39:28 +0800
Message-Id: <20260915093928.3389096-1-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C252B140003
X-Stat-Signature: zrzaybird568exnykyx6qqnnndja5eez
X-Rspam-User: 
X-HE-Tag: 1789465198-979973
X-HE-Meta: U2FsdGVkX19TigXPAb2GS3yepd4tBYav8VyLU6pbxGG/Mivkq4EJ20s7l5lAaXeVwfe9Otbz8VVld4HjO9sju1fE/mslw5kx21YafuIz/xv/VgKH3BTMcdQbWF/hD1Lv4orRt3tggiVRHi9HMC7MfpAsbK9Gl2IZWgpq2K8KQ4oY47VPxwpQOd6R/NMza2Dm5tUj97oU/grPEeV6Ibr1IPT2gwGc7wCLm6GogYLaPUIST1UTbk3JoKzqgPS8+XsTVBXOyeqjaIo7ks4Nu2uph/As5E9sySTY0Id4ZWeOKQivnAivM5cxSds8yO0BSsb7bElWXaLsJGzmymaa7XjJpP6CHmcgCKzg8sBUb5d8rfKQOvKmu1hH93m0koeG5oBtbTLktfYsGwkPmuJWcqr5LaWfb1pM+z288a1yw/dOy3qJoBf0uo1jIAFo3VqTTMzrePGDXMHmLsB8A2l3Wxh5Svg9xpYwbSn8kXbHqUNfZ3SEr+OLjx12LMjBcuyynPTmr1fYPrc+R11rcNP0xv7q+866c+Jv0DbxLnSWEK4zrU9Ci/OudUgFRtjzF2VVgguv+bkhRmDM6QQzt4dQZbpPFFNy4tzQg/L5VjI6VdNA0L/EVa66aAFsEbFmZDrlB+R+e5f8SqOY1EdVxa0/1j6ZKMI2WmX3f8YZyCqwDEspQc4H5dBJiJg9VzyFJAPlQNG2qkEgZUwxekyQ+Et9LkNbg/c6sD5fwhOiUlbefOiwsNB/B4WhfklEYKWVW2KsZBOn3VTLOIXxTwliE4hGIyB1Qc+BHJMDZlRWtvV1+FLif54yoPd7VZgocqBc+KSp9bfaoRUp7Edpe0tPCt/M1iGleBTu3oJXqUeWitS4oNXDtU+iJ47/NfDY4MXuJjAdRjBGz3l+YVT2qrcDX9rk9TAYYEw7BYQp/aloke65KGZpsGVPYceG5q72D8KSXKAoSl4JunvAGnkcWGOmxaMfU7p
 Jj/8VfNv
 uny6eO8POjHuc/ACabFwn5ZxEBVaZxuaA6+YYil35uoh5ewY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_turn_damon_on() ignored the return value of damon_call()
for the repeat call control registration and always returned the stale
result of damon_start() (0 at that point). When damon_call() fails,
e.g., the kdamond is already exiting, the user still gets success from
the state file write while monitoring is not actually on.

Save and return the damon_call() result instead. No rollback of
damon_start() is needed since a failed damon_call() guarantees the
context is stopped.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index e3858ffab4b2..beb4bdc74460 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2280,7 +2280,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;
 	repeat_call_control->dealloc_on_cancel = true;
-	if (damon_call(ctx, repeat_call_control))
+	err = damon_call(ctx, repeat_call_control);
+	if (err)
 		kfree(repeat_call_control);
 	return err;
 }
-- 
2.25.1


