Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FE9E937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C651C6B009F; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEEAF6B00A0; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3286B00A1; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 874116B009F
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C1698CD01
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:09 +0000 (UTC)
X-FDA: 84650415738.03.B0DCF72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9312240002
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgIR1Wnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+++C4FbPvLuI+LhwloavFM8OGN025XzDv0RO8kBiFY=;
	b=4DXdRO4TpOzbhDQDXX2+N53iOkHHFj0uZGIXpD/UH/BoGwJhqWqB+FVhFMtxHa+MCPOBvk
	SZCLsphJ7fpdcdgjZcMhoJ9u6/0yE4vwJw4cUMOeasCv4jeeJx/dTK/jaP/y0G8pN1tA6I
	cT7Hjzvu0K/NqFw+InGfGr5tbpWMlqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010807; a=rsa-sha256;
	cv=none;
	b=PqOEQ+IML7x6ChEPdWaer8If8FxOnKnQQysfQZ15SNmkNPNuBIa4EQSDnVPl/51QHcgOv+
	UAj9mgXL0NxwLLm2mP8Uu+0cHN47fH/wNxCS4e2DjuXmbg6wKGNCY4lO7OkndOw2B0ddWX
	lrBZ4fV0K/6T6W9Yy8/0kv766kUnnA0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TgIR1Wnq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91158446C7
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4177AC19425;
	Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010806;
	bh=t5zJdXrSXfUqeg8E0cFC/+8XELPbXvEetq+3G/tXFao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgIR1WnqGlS/2JgAAt4SyAiI6Mz6Y24ftLG/3lSrscUXV/UXc4lXwh0b3GVFWZx0d
	 PV6spn2SBCkf8mWpGADK9YnpY5LQLfvjx1gt0qD2qyirArEICcyWADdmKGqyX3phFX
	 bWQldELArzcWTUlyUpJayPkdy7p/0aNzNYP+KonViexTh0ZtwfQ+W52mshdEzf2o6j
	 JD6GlmQ72pJhXaST5RvDdqee0Virrk4YUmsxnqXBcGfN/sggfuKfwx0oxRqDm3sFmh
	 G8koSn6IO8GNVq956ZzMpPMglmZr55ZoJHdGBcXEh7KwiV7drYA+N3pGi13AF0XjMk
	 vrCnbIgJ0E0ig==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Sun, 12 Apr 2026 09:19:54 -0700
Message-ID: <20260412161957.82835-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9312240002
X-Stat-Signature: zejx4nawm9kt3ystep7bb6f1dxhbg8da
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776010807-949887
X-HE-Meta: U2FsdGVkX1/WOwqX8+Zd0VyWr40ZXYYzsKzYNALKGm89B6LYQZ1s4uMRfD29KRmU3wy9/OGnnyfb7pc2eLeTJkt7Xfnrj9BAGh5PBMd3pX9zpLk83QNY0UrTFPXz6b66zmCGxtcplXGllrQBUA6VTOT2iPKnVVU3BUzmEm+4XQ1uXClj24diCL5rho7XjxpuMEvTFfy7UbIQb+6npS7DIWKjpmbx3IQsYBSK6wjs/1/ZjRWj+Zbufi3OP1DdmmtiyPtj1okDHqnaDQqvDC6Fh/jOtzbe6aEeQ79Z7bS0f/46erjMDxuXkFOza8m3zz3YMu+hQyg12hpUBULALdf/52UoVTqBLGkcn2A+9wncnH48veiDWtDc+iJDqHq0xL7gzTy3dO5d2sJppDkj/dymIKX6FK01HorBFwrgMfUP/Yk3qw3/xP+hweoMXRPAt1sn3URFf+Yqcl1cGrs0h66qQtTnG8YrUPFCh3vpA1LbMA1RiAyIRTBvpdfTPGmwohA9NHO+/nwPjYQJ5rph7o2mgxqtQl4Q97TF6XJ8KtkEvZx+GQuNGJmsXz4ALXTCpn9G+0OV2OqbdUSst+9QfNm+XSJ7hYk8qFeDUeRxmgJ3Nj5WOppQcUi7XYM0rRBgB+U0T0gqbyum4biP6uhm9goqq0e0L7Krp0AHHJYBFm/QVFiOOB7eKPnKYLJH/Cah4QKliNcetP2VlvK4V/o08row7JmguDfy/SB4O3KaxRblOA7vySUC5cwC6AWiRxc/hL1/aXntPKMRa1yNWbVViD8BNxNhVcX/HRS7b7EZAnqu/Qr3GIqp75ppjcTakkY4KK5A1n5xlE1KirWc2mX+7Y3dVusuSwNYU60wVtcptua2AV5/HG+Q1XlOPyAoiDiyOnnrNfg9O5CsSCRq6jeheua1eXSFXEcM1Lh31t9HgADWVeDnodcQhcKfAQHL/SuhnRK8dOAUswnuWxvN1uf3vet
 NwABrxZp
 yjIOXihBTUAinjM7XWJTx3q228G4E/x/fu04HRlfcnF9s38NN6uqSDZ2NwpwB9Bna8tHP8o1RDFrJPZ/ckGZ8hbyLGihkesPKMAhFjgzaempyffSKAT+OL6ltewCFbu4OZ3VSQJ+CW4ijDL2Hl/J3HLxqJh+b+FDTCZiVzWQOh/5fLKiwhsUjjq9DbnZGDZXQuYHQNs+Bcis/2kbTU9Me/YTH8cGxjrWq74ja0Wh5Hy8cipocN3Tlb8QtB/+qEPVli4YW4F3IrPnvB5g0zdx6hOzcWE02PWJGU+eD+g0vJlUGmzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py DAMON selftest to setup DAMOS action failed region quota
charge ratio and assert the setup is made into DAMON internal state.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 387286dc449d5..cd4d82c852113 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,10 @@ def assert_quota_committed(quota, dump):
             }
     assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
                 'goal_tuner', dump)
+    assert_true(dump['fail_charge_num'] == quota.fail_charge_num,
+                'fail_charge_num', dump)
+    assert_true(dump['fail_charge_denom'] == quota.fail_charge_denom,
+                'fail_charge_denom', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -278,6 +282,8 @@ def main():
                         nid=1)],
                     goal_tuner='temporal',
                     reset_interval_ms=1500,
+                    fail_charge_num=1,
+                    fail_charge_denom=4096,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
                     weight_age_permil=1000),
-- 
2.47.3

