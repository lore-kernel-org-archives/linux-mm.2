Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892E1FB517F
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B79F6B0099; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768B86B009B; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5931C6B009D; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4323A6B0099
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC2548C026
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:45 +0000 (UTC)
X-FDA: 84629967450.22.031B3AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3EC6EC000A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODU85TTZ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODU85TTZ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523944; a=rsa-sha256;
	cv=none;
	b=DhhMBqw3KlTimD0QsYQvnVt0L/TB7lvr9L8XCg2J2rCuu9iqonZnadUnLm/GASBFJbTBZo
	chOTcA4XDYowBZZMfUcT+LDO13VribQ5SA6pucPNaGYyX1ST465zJHs5CeeOa9sZ8v952m
	lnloo5N2Gx3b8ub39gj3a0/TIlRmcqg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=cMj9YqWIVglhN72wsAFcPk1we9cTL+Vxn1BOeo3FsSNDPxsd4Q1DHf52UiMSKVUCqSLJZ2
	hcYHjv+TEe+XWB8R2h5CWULATgf0cqK6zSUi/x7wrWVvsJStiNqu4aKPwVlZUAGNWwqcAX
	an9EVehVaazsbYS7xRVzU7mXryodFss=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEADA6111B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB1EC2BCAF;
	Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523943;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODU85TTZFKTroXbh8r0wzowseIcB6UbnnIAZwvCjg596LBqHtS4B2P2VMF8DO++xp
	 9i4el1WvytI0Bb+pqpNW/22vs+gwu1q8gvvBQh7icRxckaDeR3PTqwCnr6lCK209FS
	 YJqWZwCxiMtSZsrqMGQ08yhHIGwiTcLn41+MTks8Fhi2KkOVJPoLKZQhJUyBZstGDc
	 YKMq3altvB5TtX2OkOSNIdCTwIpUS+6m1PQ9jPXkLG/3sSxajMicrOx2GUXNaLHy9+
	 AJwQaN2AzfFKY5evddqDeXbEtsKAhg4Xk7v/O4IJy49aPax9GHmZFUPDo2BLwAj029
	 k8+fmjjZw5oSA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 08/10] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Mon,  6 Apr 2026 18:05:30 -0700
Message-ID: <20260407010536.83603-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3EC6EC000A
X-Stat-Signature: xw3wen9c9he3538tixmbp6spf79bgdam
X-Rspam-User: 
X-HE-Tag: 1775523944-724607
X-HE-Meta: U2FsdGVkX1+uPj9+tfPCEvIw8zjVgfvY2C4E1U0MFsdwvLadZPcTITp1UzGGnUl6Of7t7MHK3POfTzbjEBT15NzsNB0A3py+nyliADpq2wBVfxEDdo4GuRfrI6S5EWGE+kMhH+fHyZtYtjdsU61MeQxzpQTlh+ScwhXLhLFcTkWgrLBZcE0oAhE17zenHEXNb4lHeaAwD2U1/Bp2j+K6plFqxUZL+O91xmGpb8dThmZ/2kNHS+MK97x7MHZCh1TI46aYusmK+2XvFkH9QXrda4Kb45HrhtxPt0AFsRpPFlqs/SrSaemHoFZ8nCoVg9q89CqZuVZ+ZNOWZBpmoqiR4LgPs4Q2p0dIW94pZrE7wNmf8xybrF7FBSTbrI4xDPlpZTL38cvtvRwgE6cqby4VohORvRdpnXW4/Zhug0He8tVKpO67P153PJQ7D9T9UXIylruIFBahvP9ryC2yeeaaoYgnVi9xjYLLw0zMPSpe+rpy08DETXTrt9Toab7wzSXX05a0wESoQmIsxEy8Ju3zb4XGm5lYF6W3TyJVGDlnfKytMGw81nKr2/wDe8j3BMpJ8362o8FBJd6iz9pap6BN4oJOQ9vUqy0t0yMeTpg52qh1ytIfYl5DSQE4TXRPYiLDDn3Y/+M/Rb7Cb85qWVHuKyfRkbok2xReMU/vk6jiuMnuoq1fyGtccZrphnjyUsdujpXfI/AIdV1e6BoDrznfG0rt8fU23IN7trfAAOMWxZq71UtVsFVVW6T8sg7La/mWtY+u3RA1lutaiQ2AmHrZatNPgqljzLZfrXDlkXgBPm6QZDMt43+FtQEG1KoeA1YRtcu27KUpK1kbPElNM8dpp+jfapoAibhLRl+ZcqrUbwRrzXuJXsQF8zZupLsaAF/71wEAwCX+w1rTje/WRWYFeP03Wrzs6UPjTAPFwO9U/RBK8kZhJStf9PY+2/t02faegZbn77yJSpnlP61taV1
 wH5X9R/s
 UgKcNBAXeabKZrP2m3FzqgEtwNpsFADFo9/DwJq1d2MqF3RE/w/EFU4u9XHKFPmyxHLsN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend _damon_sysfs.py for DAMOS action failed regions quota charge
ratio setup, so that we can add kselftest for the new feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 120b96ecbd741..8b12cc0484405 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -132,14 +132,17 @@ class DamosQuota:
     goals = None                # quota goals
     goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
+    fail_charge_num = None
+    fail_charge_denom = None
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
     def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
-                 reset_interval_ms=0, weight_sz_permil=0,
-                 weight_nr_accesses_permil=0, weight_age_permil=0):
+                 reset_interval_ms=0, fail_charge_num=0, fail_charge_denom=0,
+                 weight_sz_permil=0, weight_nr_accesses_permil=0,
+                 weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -151,6 +154,8 @@ class DamosQuota:
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
+        self.fail_charge_num = fail_charge_num
+        self.fail_charge_denom = fail_charge_denom
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'quotas')
@@ -197,6 +202,18 @@ class DamosQuota:
                 os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
         if err is not None:
             return err
+
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_num'),
+                self.fail_charge_num)
+        if err is not None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_denom'),
+                self.fail_charge_denom)
+        if err is not None:
+            return err
+
         return None
 
 class DamosWatermarks:
-- 
2.47.3

