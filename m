Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C362FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118AD6B008A; Mon, 27 Apr 2026 11:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8DC6B008C; Mon, 27 Apr 2026 11:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0062A6B0092; Mon, 27 Apr 2026 11:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52D46B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:12:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF1491BA7D9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:46 +0000 (UTC)
X-FDA: 84704677932.25.F0F2A07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54D6C120015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VHFWsTLk;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6oiuDQoqYSCvfd3Nh0W1UlXYNip4yLXjZrcq2qrzWA=;
	b=bnFPFSxJcisNprpgv0eNbOY2WM6OKWMHMklT2yvmqtLrV3H6pMVUqe5vQ/syhdrOChCdkx
	gKqaHVengvWCDPwhvbz5cuu8LtKhAbyTkXC4xzOOjcohavUjt2jOYKz4o2s+3w/o7A3fJU
	7PKU4Vu83KyKPXk3E3yH2IIykMuZAfw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VHFWsTLk;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302765; a=rsa-sha256;
	cv=none;
	b=GB1w9kTTouJQI7IPMu76O8WCl7V6Bqsq4I806JiVE0PnR2L9khmPpBfRZDoEKxHvd7gHsa
	24wFgL43rKirKVM0NYbf91xzv6IQp4nH8htD89t2bvnSq2G/ErtdYRDs4f2aApJWXSjZba
	AoWjqMS01+f/lvMWDHhsVdP+CV3Mi5s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC32160181;
	Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486A5C2BCB7;
	Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302764;
	bh=o+aCOZ8LYgQ7c4SiAM/QTBFJ12mubN4z21IkEnGUqdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHFWsTLkJlDEZTGoFpJGGzf/s9KTchh9p7s1uxrbmNVq0FWxJpFYg/L8M0nKbV+/s
	 +HcZRFvRWd60ojYtA5QpTNHejdqv2BGsfB5CMvMD6iXI75gp0mD9aYKzyo00ELcnp6
	 nphwpWSiM2T+6KMjb+ErlzWxX/AAc2FtXXPwmXV08rl4rIFR1hfid4ypwLzPSaT4DU
	 Txib6HpFfBA1KNBycIDQHpkio3QxdpoC3ouIK5oUY0/xRZYBI8axpMdbn8V0oIgBEB
	 zx66VyyAGggKYhcGdBxXd1rusVdASrngnnV4vOpfBb1Ibfa8LGuH68PdZMsgB3/iY8
	 hNnl9x9vw2+yg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 10/10] selftests/damon/sysfs.py: pause DAMON before dumping status
Date: Mon, 27 Apr 2026 08:12:29 -0700
Message-ID: <20260427151231.113429-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54D6C120015
X-Stat-Signature: a13717ibs5pfxe9dtpsgf98e6gktq3b1
X-HE-Tag: 1777302765-851110
X-HE-Meta: U2FsdGVkX1+xt4vW89GyTSIutvgG0VrGRu7Ojp/Uw0WxwfdcVYXU+oL+oIJx31cgMiGu7zZE5CBVROuOnDxGokKLHZrT0dM+UXfRbV6NO7T1FOH6AKF7SOhGjI2GQN+2sCZz5QLQrdLk0tzxqGaynds2H03scsxWn1qGoQCa+dfchMJxjpCLGdHaHFEDpuWmwl1hlgWa5TIP5J8nAbSc2WMZZMxLceApc9vreJzT3ZH8bNS1NZLH01W9HtuIpCUZFjS1r3JhQbCfLlaZHwRD2W7M+42ExW0lf65YydqcINVPhF+whTGGd9v3eFc0cb3EgW6FIfWYurfjfa2CWBLD5TQSsQc5asVjczsh+RgGDt0RLOUprPpDRN2uJa0Wu2HNME59sW9XN4LrJaUEx+gSYrsA5V2Uqfitgvq1L7UVqa970zCJeC9jKH5dTo8WAIg1O01E/aXjV/UPXvdMD679biwupJeEtm5yRNTsOtqy+Pk58p2gcoS7gr2PfBTCNpvJzb+HNGzjgDrpVlgd1Lt4JnqNLKBA0b9acK152tdIEbwDkuTkJFL07nsBaxtOC1TLX5LukGzHcCEdQ1LsX4S6RHUPrk/BZ2DF09u2rjnqNckohOICXbBtELTYscMRiM/fXJPi2WEb0nb8cuzCh/xNlFEVr0XoLf2t9Tds3+TrAK2kubUVbEM3TEUu02H+8BffCFuA84wqiGMdVAd774x3LnKknrUHSs/JzzpriHqsnkFwa176n/wOiQqUvaw1bXKTQXMD5zdhR9S+yxMuOazjZoDPMuz6tmbpvM9z65LobI73uGILU1hXY+T9ERRv3IGa2KC6pgoVaQkDO38CCRw4WWcto+jERamn3iPdz3/aaAOm/ha/UXulfEG828Vqj4CYwE4ZFQ5NE8pApoB2zdXG5dSpo99cCJGg7jHFy+Y7G8l9HdtVCoAheTy0KOBJGXhFJOiTQmbXhjhX5w1e5Se
 wCLkv/MC
 xjb1Wq9vzXwPzqSrOZWfstXAyDNz7KubJ/gUjreHIqProrwHQeE7wFFiR5EQ1NiV2yyXzudHYN2zQM6Qif5GrtDZDPTKo5itHn9J6i2JPCXA910sOpfKFABUBEr+kwrPXyjYLjZSiAx7jENi/FgwiIsO1OJdx1kU6ma/Cca8U+YpEm4azljTE9cfcBUxPi+nNVtZjbAmitcNI1SyGZOB0R+A7EZvUcTq3QuacsrstTPDbEn8=
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
index 5a5d2f2774566..387286dc449d5 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -194,18 +194,55 @@ def assert_ctx_committed(ctx, dump):
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
@@ -303,6 +340,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

