Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4F4E937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B346B009D; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2043A6B009E; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CB8C6B009F; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEB076B009D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 810E71A0BEB
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:08 +0000 (UTC)
X-FDA: 84650415696.20.12A4C44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C305A140004
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AoaL4d7p;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=Cb2m0gnOaYm9U40eKN8TLF1WEBPfwkuKkm33oxTGEIFhdLSALam0be/SNWtoLTBt78SITF
	jLG20ba+IfvueBZZz9c4oLuRxHBZLtQULgtW0nCHeoJ3fwu0NBEDAOmUoCZALzqTZTt0mQ
	5VL4qhwX7wOKaj940N5UBQiQFdy4Sfo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AoaL4d7p;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010806; a=rsa-sha256;
	cv=none;
	b=3SgdqLIR6IBUP3DjGi5Zx22/fzyj67Av1OLb5CtASqGtgI3iP4cDe0LPIfjr5Zi9fREk7L
	lSOXFZcSuX/Lg9fErhrgjwkngfWzsklD16P2qyiY7TyF6jkCXNFJjSvhXBI1SCNxOi9UW4
	g1iUuWrvtn3wFhJ+2WKMyPitC64VMt8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DED1C446C5
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C83EC2BCB4;
	Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010805;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoaL4d7pmxfMgt9EFFeZzqIPSiLvPK2MG0/aV3/+v8PoP/2jL4y2mn85aok/vAeWS
	 lUu0fcxy0JU3ldWr3YOHtd2OFM5v5K6Yb7OTnX/kU9eU0/0vaO42Fk9/UmCzb2O93Q
	 sXxZbMM+xN7z5pu8vzfffpXx6Xjt3suKivPtQzXhpFMlwUaz1zOTkcuPU+3viyCnL0
	 +Vdfxr8Mz5AaQ9YgLBYxkhybS8lTH0Suds41A7n32kjeVKLmA5uRyq7FifaZMNrnkv
	 W2q1BeImO185lV+9iFHQnaD9FtHcIe+FCUYtcXbqquPEsLI/JvtNHEK6pmFhyAyl95
	 jmW5MVuTEI/Zg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Sun, 12 Apr 2026 09:19:52 -0700
Message-ID: <20260412161957.82835-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C305A140004
X-Stat-Signature: xt347p7jqt1oe7xreybfmig3c19g4iry
X-Rspamd-Server: rspam06
X-HE-Tag: 1776010806-766527
X-HE-Meta: U2FsdGVkX198i+SbrdMPwl2bgI3ejrsB+KrLLtdQVXxGJfUbr93ogZb6UQCSEAcD5FaF/XuHwaDXmeDi5VZQFt9pwewXjCqY76wGGP1DUT2yNzL4Q7Szy6Rpyh4Aw3bbLX92q0Nz954uAmXYpYqf/5m86ZK15ikckF0OmGUVLFZyXU6e6YnlpcbbrBihXd+nrdlNEPue6KZNmLrEuzLql335jZq4YWesEo5vVwxwweqR2PNV9LXkkLRJKWB+DKpHrzAjEBk3xnlHmvV+ndU4cyh3IhjuCW8+L61bPCjiFYgzBxJz8VGEZpG+5/hp6ogXjyffPvkR01zGFswO3MDHR/q2ZZufaYZglY0rQzB0EHrySzOLFikaFWBhjqQsBKZQHRAevCH8Z6sCTZMNLS771AhqWIFf3e52FHSsqmGaM1GnStvxIJV7HImQ67IszVb6KHxRVTqXBlBtb0ekAz+2vodJ+yXwnwyuRvFu52S6eQVqKajOULRMmLqJyWFuT1vmmgu2WDJ3Lsn58BXWLTH+mYbcLgyFsVfI+r/+KhRzU1zLIJVw6Q8SoqQ/sbLNQkf3tATzW797JMj9eThggJgks+OCKjLw5PdHhLmVOwOrKUIIMnj40OwicJ+7ZwIRWJI/bm/GP7iF3UOWzQrKHlcyKVY47LdZJghhyS7eRbVyOLgmabHo7K43AlLNJvwFfUHA+q5bp7GNXF4yIlA3lFU52X6p4L2t3NWliD8Pe5d9TjdVz/xi73+mzLLfZpeEIWReMxHoMQWDUCNhkA4tMPxMtNalFqDbzdYHjeF1GUMNQY/HsMCOAxDrXPMmMJrnHqc49/8umwHnsj/SX+ElUJ4KA/ngQgQwbmzOgK1HjrjaX9TaxtYlyVmxYnRy8vR2A/kqJQ6QKQfJS+oaysH/3jLxLzwmllrULtx8ZbpbUZzNxOlwYrv1zzp1BypjPNSViTy10vLAOK5rIv9U1m0GEkH
 O6R23Tph
 hYGUHP+4sA4qtj5Ok87XlP7qRJLWiVbgdmhGqfKYzUywpC94DFQUn4IIYJzbZX6bsndW6+5f2MBJ7uWz1Q7+tFv3oalMw9fUsBEP2229q9/7WMOT9/nfMijzBCzsW4Rx0uV5Iga17i9h2ys7AS5KoZ7DELv0zjm6jdlgWT6NWO7Wjxiq9HfXHb8ju1O4PGsYemiA3V3cueujeSQVd01s1XBQhM1k0HBoztNjI8DDYJLnvfQhuVU8K4ovXdTWF141E8jsbcPLNO43adZUbvTVV3pSVu1ZP2Or+7Sqz52hbwrhqMQyFbbKYY9GHsuOi1UmArhPz3VA80WVUkPOqYYGFwr4Rg35r7WTZN388zUsCcoe2j733O9N4jC6SDQ==
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

