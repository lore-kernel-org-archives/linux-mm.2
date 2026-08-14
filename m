Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479CFC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 09:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 221D26B0672; Fri, 14 Aug 2026 05:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DACD6B0673; Fri, 14 Aug 2026 05:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9B46B0674; Fri, 14 Aug 2026 05:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E24FE6B0672
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:55:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 652ECC03C8
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:55:53 +0000 (UTC)
X-FDA: 85099418586.26.A97AB7D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B62F100005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 09:55:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of duanchenghao@kylinos.cn: DNS error) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786701351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=iuhuehQ6MgrJxsnB5HDd/XKREyvn6MEiIwYky45/I9g=;
	b=IojHlW1ikrupDmNEaCY9ZU0QmA1uRHUFkvrirrvLNHeiKkNtXn0rjipJMmZYRHl/axrM7L
	HmeiXJJDtRqj/+WXpt6iOy8iSXLmaQG4VzvcDpSm5KqfV+Jqt/lqinX9dgzO4qkCXUXW0S
	C75IWQNyIL240FFdl8zF5yaYEujy9Jk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786701351;
	b=v3mt+AEbFJrM+FA0vTAMvFLOfBsmwBwY92uDufxCfTuYewzsxMDdzXc7fbBEU38akgp2l6
	qbAlZxvN4haJalRBn370Br/2mg/+NzJkVg7rk9LRe8OBP4/YWaEnfBLgXL9bnOe25i4YWL
	69PJb5ryPcT0HFZFevGk5Zqi3jc9eW0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of duanchenghao@kylinos.cn: DNS error) smtp.mailfrom=duanchenghao@kylinos.cn;
	dmarc=none
X-UUID: 4884d2e697c611f1aa26b74ffac11d73-20260814
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED
	SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:12f84e7f-cfa6-4117-9574-2b4cf115c43a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:12f84e7f-cfa6-4117-9574-2b4cf115c43a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:2dcb92359b08659083f82a1655c4f44c,BulkI
	D:2608141755332MBDLNDU,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4884d2e697c611f1aa26b74ffac11d73-20260814
X-User: duanchenghao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 456462654; Fri, 14 Aug 2026 17:55:30 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: pasha.tatashin@soleen.com,
	rppt@kernel.org,
	pratyush@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org
Cc: jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: [PATCH] liveupdate: use scoped_guard for mutex in session operations
Date: Fri, 14 Aug 2026 17:55:06 +0800
Message-Id: <20260814095506.631274-1-duanchenghao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5iip1ozr49xbub5fn8f9gsgkhdzxo6qh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B62F100005
X-HE-Tag: 1786701344-324462
X-HE-Meta: U2FsdGVkX19TriS9TgYxsfydMINc6890IG4Pz7mt/YycGARG9CSGCNa1rF3j72DkAs6LFaFApiLWyCApQXmGNK32yQG6cJiO8T2IOvg4t+M2nDUyastWg42/Rvz5HW8fjBcfgidl2lsSd5qiBEGNl0qvAdilZmcpSpDC1rNIJgd7r3FoHr3w6re6QLsLv05kwpQy3La6ljXeGmFNO41KTDlrEagSbcMBu5hPNLTMo8cJQIqehId/7WWTw2qosuXcftHQTx2iOqwXZdA3d1oENBDOV0DWtzsCNullQFHkS5PMVwTQdtaaQlTEDEXW8zKNhjp+rbb726egwPiU7V2W9Rnvr+kbybAOXpaHl5T6IBTdle/LBLhvnhRqVgW6v+w25KlBb5VyzmdhTyNURUDWueLeeYoFaiv0q7grCYn+fh8ZMvhAJiJe04cHg5kl0EBfm5cT7PS4UTwX5AhrPlt7R1d+EQldcW6jBoEv7JDP/JEdKh0SYPSuWayqkpcPRGxlvIIvsNWoGYUlIXoGg7ETs9NK1gmc2T6ojUiOh6tbzeXkQcXcFHlObcNJWC3GxxTCDHKnyASuvFhRsMNhO1AX0TEBdlh9B6/cyabKuFL5zak2PJz9WXiQVe7DKz7zJH9J6bplbKESoKSAC2Cf/qOR528+Iw+IKHyGxOyZQxJbjIksL8yaZgLQVEFDtOCOR4SGe8Ec+goJ1W+/qQ+PzrTlz4/HG1/nMa35tuaECaVmbI+Iq8EkKu88+IzeJiJofLeMZK1ShaIbdWIHug94s9mfor4Kdw3u9jVzqqiO2KiE5eLLDAvDQ+yS7pPgWVcIZfzdg9E/qhHJDNjolx3RVKNXi3DAtLE+CH9lLxK2i6XypNAuRlWd1OgGE1RxrvdJIdu7LjBxMV1awLFTpQb3KJ8ponB+7TH7YpqmdXPZoVZpMEa3MpEPnXguNXb7WtHaN0s5VRpdgw6ZvZWOROkh10+
 tUbk9xwN
 6Canxyq0yDQ0yQF5Tsg9dMXFlvUERyzg44IHFfbaHiQgzv2aqwq76K8krfRFsJz1BQnNZrBAzX0vAqarmQbO6jHq+i77EEpcQ4MsccBRyGSfc26LOqu9wvSr3K5/oQYUn1VZ2xH0/TeMVwy33GOhNg4AX0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace manually paired mutex_lock/unlock with scoped_guard to align
with the coding style of the rest of the codebase and simplify locking
paths.

Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
---
 kernel/liveupdate/luo_session.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f38b5b18f3f8..06307868a44e 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -290,9 +290,8 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 	if (argp->fd < 0)
 		return argp->fd;
 
-	mutex_lock(&session->mutex);
-	err = luo_retrieve_file(&session->file_set, argp->token, &file);
-	mutex_unlock(&session->mutex);
+	scoped_guard(mutex, &session->mutex)
+		err = luo_retrieve_file(&session->file_set, argp->token, &file);
 	if (err < 0)
 		goto err_put_fd;
 
@@ -478,9 +477,8 @@ int luo_session_create(const char *name, struct file **filep)
 	if (err)
 		goto err_free;
 
-	mutex_lock(&session->mutex);
-	err = luo_session_getfile(session, filep);
-	mutex_unlock(&session->mutex);
+	scoped_guard(mutex, &session->mutex)
+		err = luo_session_getfile(session, filep);
 	if (err)
 		goto err_remove;
 	up_read(&luo_session_serialize_rwsem);
-- 
2.25.1


