Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D32D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37AF6B0099; Mon, 23 Mar 2026 19:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2F96B009D; Mon, 23 Mar 2026 19:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C186B009E; Mon, 23 Mar 2026 19:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB20A6B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4078D160CEB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:48 +0000 (UTC)
X-FDA: 84578887176.08.779DAC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 854CD1C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5yydVUq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307746; a=rsa-sha256;
	cv=none;
	b=q61lj2qD9bKEiLDQjxtk9gyEwnfI5sWEXO4lbWKzAlYXp460cyXJpFbBEU2a5lXXLbY4Oy
	kXVDvm4sY0sCnFTYz12KO4N530s/14OAXeTLNYcpEvnqR/q2S4FeXXCNm5zsE6WdY9lxK+
	WoeioUIKaWljJYibKxRPzjWsJQm0KoY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q5yydVUq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YJfiJXcStVYqSRLt9fICpyoHcdMrdRSASnhW4QpPU4=;
	b=JOoxWP9KJacTiOCu2kr52hjuGQis8Fyo9YrcerEedD0OBjcJWYMJ08HRwb9EJDQXRPPwfT
	aCLT1lafp2x13v0UaAcy1dwDx6ENkPGzClmRvL0N6UAv8rcJVzdBXvjW3bL5pgfApYZE6H
	6TzfmDE9VB8velrEGGfEKGu/CI0+uU0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 455CF44592
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12013C2BCB0;
	Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307745;
	bh=Z1nIZLeoxb98TWw70o0hO/Y6NrW1kS5M/KiHOgpnygQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5yydVUqpqiwnomNgbxwEbtmAZhljkYMPVfddPIOY8MHs670ZwRkshNhjKACcpyqj
	 UXGdbuW3aC6ygNvSQRh63A6Vm3MKNumaRlwrWu0QGtVA2hBIiLP+51U4tByUyRr9Oc
	 7f29kyj0Ib+buceF5JQSK1Sxs+UqAJ7aUuiLA8HPJSGyO0qkVTSusH1XxouH/GpdiC
	 yz3JlMmLII9kUKLaU9V4q2CTvbrwn53+2P6VCMOqd3pGPWi2o/1I6hlpihFpOpp7wo
	 DWyLl+zXS2LfYTvDmG79gDpl8bY+O2c8DilXB+dNsvHYPfcyJcrXW0BwKMfWoTsima
	 pch5opspDVcuw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 10/10] selftests/damon/sysfs.py: pause DAMON before dumping status
Date: Mon, 23 Mar 2026 16:15:35 -0700
Message-ID: <20260323231538.84452-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 854CD1C0005
X-Stat-Signature: 5b9zad18186tpb6foh43gi1ogog9cy6y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774307746-369891
X-HE-Meta: U2FsdGVkX1+DkowJh7/spIfSe13BX6kNdFqhEibd1iHnbVvh+pG79OSE3P29kwtY0hxgJCXzIXiC/a5xDkd7dpS6o+dsrV8vWl2wfM1kFAjicKXA4XP+WCeja0JC5jAzr1iyAPp2zf7IutPg3FZTNQ9DItfMsN+GcjOtSIBiWBE7AcVc0y4Zl5GInKbp1wcu4kNbD4AABD0nJP5b4aHzBcVdoX0jtz4Ge3a2EbsBXhvLcpXh0rvagELqaWMnu1ggiD0jqIO0AE6THa2vseVdpdK7bXTpJXAOc2my+wv1LJJd6pvCJ50TKz6VV8juzpyyPSFK+vJcEkr3EqJiwAg0iiN0FGNF77AzcyPoc18OCHWCrUiWl+v25MKVM/ZIIoboqtCbylKZRLdC6YsnwYmkrarloFdJMv3YXsmOMRG2CgEjXPRT7ft/euRTRfe+SXNsroAZO75fGhXg92xMDUAJuUznWydwgG46jywsr4K4iXR+cPjs3ILwk6Z8uyrAHr/26iE2MNDNvmWj8DKtpiC3szUHYtuVbaqmv/APFqlikJs435bbmnRJEXV3Xbn8P5yks9aDsrym7iqe5ofRiuPWcN3aEJBgoDDe7QSY6OTjioNOglBDgwwMahN2U9SUNNADernMb7y1uC8eMa6NbSix5IhYhcUMquA8k0QGW9WYfP+XXSnj1Y7BG1Naz5o0un8Ph2ioX28f7QOq1f1jdNsvCEMIBqnS+7d2ASrPPYPcLSBwjk6aeOT85QPeQHasiGjTvzEZiYh/BrabPC0svJHpRONoTOXoX/Co/8IJjY9VLd7NvdZ5MpViFUchtGf+Tq5EgJ6oSOr1/2o8KSlEk68km5WAw0WB1Swlb9doB2hRIz1gesbXy6l7rGn/B62lFk13/YGDhwX3KX7ABuyPQ5yf0gGheZNvDJsz8QI6qKqz1b7aqz/OXGsvVLm8tJWu9u8rJtv4lUu0NpljmIay84z
 hUa6jyrd
 2LbveuG2cCpwyWIdmfqPES9m0RdJ7745eyYdmzHlcx2Ln5F8kidde4Z2wG4G4/SQ0zL/zCOFBSv5uVWFM3H50HBvMryURnltGNoHfFmtBFtkkSRWiqtBSL8lFhlNHLiG363CMmeierVDheVKoEHlcKpPSN2FZmzmyo1F1ip0TiVaMDn+ISc/C3W4evNAndqIxQSRksvoW5wy6OcWMD0+CkgcEzq+rDRRfFxIkvFM8F3YJ3kUZwu4QtACxQR6DlT8w2AuqpjjH6wXs2etde9IBX1m1517Fmw0pkR/eYuxgSTY2jvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs.py test commits DAMON parameters, dump the internal DAMON
state, and show if the parameters are committed as expected using the
dumped state.  While the dumping is ongoing, DAMON is alive.  It can
make internal changes including addition and removal of regions.  It can
therefore make a race that can result in false test results.  Pause
DAMON execution during the state dumping to avoid such races.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 38 ++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index e6d34ba05893f..b8d6e0f8fd906 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -193,18 +193,55 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
+    ctxs_paused_for_dump = []
+    kdamonds_paused_for_dump = []
+    # pause for safe state dumping
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx.pause is False:
+                ctx.pause = True
+                ctxs_paused_for_dump.append(ctx)
+                if not kd in kdamonds_paused_for_dump:
+                    kdamonds_paused_for_dump.append(kd)
+        if kd in kdamonds_paused_for_dump:
+            err = kd.commit()
+            if err is not None:
+                print('pause fail (%s)' % err)
+                kdamonds.stop()
+                exit(1)
+
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
         kdamonds.stop()
         exit(1)
 
+    # resume contexts paused for safe state dumping
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = False
+    for kd in kdamonds_paused_for_dump:
+        err = kd.commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
+
+    # restore for comparison
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = True
+
     ctxs = kdamonds.kdamonds[0].contexts
     dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
 
+    # restore for the caller
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx in ctxs_paused_for_dump:
+                ctx.pause = False
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -302,6 +339,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

