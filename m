Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07DA2CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C26D6B0095; Mon, 18 May 2026 15:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672E76B0096; Mon, 18 May 2026 15:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A396B0098; Mon, 18 May 2026 15:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47A346B0095
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8721A0A6D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:32 +0000 (UTC)
X-FDA: 84781486944.24.454F918
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 086EAA0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPbiAlDA;
	spf=pass (imf15.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8rvqbbv4pCegDpTmp8AOnsZ/Yo8hHTCvqhnXp9eK9A=;
	b=Dp1NycONGqa3qoBNco3F+B0QEsXsTsIGI+gDJ88nYtwC6KgtTdAzaVGydgO5xPjBmi6iUm
	TZRhvl4vez5ICAtcqL5nVnYz/hXB8PWLM3EPiEdeIkJh1iUI7iU/1vcsMMzcKrLZfgR4Mw
	Eiimmlq9IenHB6Zfan0QKzntX4HBOmY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPbiAlDA;
	spf=pass (imf15.hostedemail.com: domain of mshcherba2000@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=mshcherba2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131551; a=rsa-sha256;
	cv=none;
	b=ZyJQJFNA9cjQS09GBfkUJmowIvdbotzCzCclrk/K5ZTVmXZDBw72/LWLUyelegl21G7CXp
	M9QeOYVozlScSk5ObGD04lCybUyZNnQ/BfhXGeyvrCZD9Y+HduB4cWhwSLfztw+W49wqIk
	6Lcp6OFyVfnFeDa31twaEPZgaz5jgXE=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-43d7645adbdso1751993f8f.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779131550; x=1779736350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8rvqbbv4pCegDpTmp8AOnsZ/Yo8hHTCvqhnXp9eK9A=;
        b=sPbiAlDAujgoUUgD4JrxATuBj3pC9xSZKQdyXYK0BIJwgBYmBKR6I34gtc7n23rCvT
         M0k50N+VaCfkFQ5MVVTkHAgw6hMsu5532rtvj/UAt5dtcvWVgXDKNcxGvRq4PKQ9zwDR
         uqViifUNrhPfWsJTMsYeC62Tm1HVXqP56AsA72vx5panqKVjMAqLf4fxhxVHHa5qZ9ZV
         /7DT8sl9yuKl1apzCzKZ8JKd2EvWzzBeFd3ULgXajtNDCkPQ+Iq9hYsAsvXqJZB4/yfv
         sQ8zadIdK6DcH12B/W/Yo8Lwp8fpxhKeXuhpqp4DXnSji1D+OTPkJuRIOZkoBgUKFRue
         uHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131550; x=1779736350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G8rvqbbv4pCegDpTmp8AOnsZ/Yo8hHTCvqhnXp9eK9A=;
        b=b2MX9RDyRjacvtyFn8LPyIy8YUbutAl2xGziT3mBjFlCYbF4buylgTTyvx6c91s78I
         v8xdauz0kJMQq0GLeIZ/NUzVReaSLrKcRP9RNSXS93U+aqjg7jGerPTZtkohFCRwZJ4V
         YYBkxk9OnVjzo1YdAPw+hHqfiRcRyWip4ME1t1FWPwQJZVo0qOVj+x4D6SRcbODiwQJa
         bgHm2z7hRQA6BKD73jJG3+pwpJZIvsRIx2zpDIG1YCVOwft9cCJHFn0n03EGdg3ZOi+i
         NT593qqFVJIc04HY6QVK2q4ibxdHU12864JbxWdRpDG6RQ+dKBqrnIg3ZjnjzAHvppzP
         L2XQ==
X-Forwarded-Encrypted: i=1; AFNElJ+WbOlzR9zaiMhXi4HN4tQYIsQrQPRCyNit0WKJN3/Csc/KKP4DnSbQjqkV6FLudfi4e/VWHORadQ==@kvack.org
X-Gm-Message-State: AOJu0YxEvgmZSdzhTjSIH8ZFXxjZi/9C4wIy9PC+f6tm3cfRPSQLvZvQ
	WbDRobmVlimYLyOJGQIrenn/kuXv4EzMCJoCcJCy9X4eGvMASBdu0uEv
X-Gm-Gg: Acq92OG/PO2f3isRBcIbxdpbFhkPaaKL22kskaOgQJXEKXLkATIb9pj+vRofhgfrgm9
	n2kqAaIyiMkrZiydfUmeu416PG+Is627fYtWxiwjF7iErmuubuD6sI9lBoBuL/AW7SnJw8AzG1v
	nK9E7QaGCPQ1pVyLSNxdeg6c8JxmFDgvgNFBPT6871Y+ZccHMoFplXcMbAKQABuPCGWNPsJL/eI
	XKF8qxj1epKfUK7lrRc74SLDrbyOKXCJmXWt/FA0i1q8KBIrYSzX8VJa5Y0DCwWpfK2XSaQmAro
	ykbKBa/L1ow4hRDl4jNh+s1zo4ewQQnqZUmFxqbORF9CySgjLp2l6xwMr4cjV4YyEN4R+I2Pn9S
	bbGN2g/HwqnaPZz1tk6S7yr5lx2BIwjAKc+qSAvxl3lC16t5w9pxWTsDL1glcuaqDlxDFGfjbrX
	e0aIp1jys4Ny9xVIlJyBFrxynW923Gv5T+4SHoZ39Q9OUexJ5bf2CmqN73HZMY5A==
X-Received: by 2002:a05:6000:1247:b0:45e:6518:3299 with SMTP id ffacd0b85a97d-45e651832f5mr15730841f8f.5.1779131549508;
        Mon, 18 May 2026 12:12:29 -0700 (PDT)
Received: from mshcherba-RedmiBook-16.. ([188.163.115.207])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm40043167f8f.34.2026.05.18.12.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:29 -0700 (PDT)
From: Maksym Shcherba <mshcherba2000@gmail.com>
X-Google-Original-From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: [PATCH 6/6] selftests/damon: add a test for update_schemes_quota_goals
Date: Mon, 18 May 2026 22:09:32 +0300
Message-Id: <20260518190932.42270-6-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 086EAA0002
X-Stat-Signature: yn4g9ymmdd5ex9za56xpcurhutwkpqt9
X-HE-Tag: 1779131550-588216
X-HE-Meta: U2FsdGVkX19JajkHdZEgMkD9HPsWQHG9Sr5xxs+Y0poLbn4rww37vw/YmQMR7ROY8MX4ULtinmH16PT4nAyLvKN2l9qsqMWJ25eNA88AWaAjGOIi9bnddUyhAcURLvH+xsF+36XORJub0b9hAH8jqtK8HARlu1JBCr0HlEUnYAjarA44aoiQkPHcA36UmS4rCX/jTcD7VJjglHUm7O11G1hkK+0OKMPVP3szDOcA6gCfkk6XzLBs4ZMt3+xnWlOiYnnuNpi20CDnLGbnvDORnxAA2XP0l2DmTbVJB8izBU6/Qte6eD18zTzZ16q9QwbrqLBF0PS1z9YRz8XneFsWQPe7/URTVLpDH56jRk1xX1NW4l7Fihww6TX/ZYOizucj8egdkDCRj7dIsv0DMLM2Lu5luXrxzdAYe6UsQ0y//DK0Ad10WQjkqOEV/eC/qcj0pb5aRKV92rQ9LHi8WvX1FhLMPgKWuErjBnoeZZUx0YQsjpbyz+TFA5lkxhahZ71xKZiqFUAAfveGFHbT6xauPKZqfw0d1pSbYePAjoQQ24R3r6C2Zhw/jRATOAFtJqjJfLUz6Ab8QZekMMz1hSfAt4ULFRVevdZ4LNuOcUb80pSqWDp7/YHbcPKRsl0v3p6UfOIiVxaUr1vc+PcIWRXMx+lHgW/frh3/jooIg0T8hJZD2UW04vLX1DDRf6Z7O18RdxLEMCO55V4zdkgBSok2tBjdCv38sKCHXPQyyZxBV1QaXSFb67uuajsFLGMDZG9zis9w/e13/AP5xRZr6lemxQCEpPcr9oUVDKAO+IYvJkiOlhnlpQfFSTbnf8a9GElQ1tGcVCDXHifyePftkujkAzl6Ch3i5pVnac5C+Z3cdlcPUJnUjpMRCcQ9VxcV4VhfIpsHJiiFcCC+GBtNXoE0cL5R+3MFxKEWcVzeBHIZ/aqyVY6dMDuVIarsrX8Isl1dSjzoihcmx8gxHsDtbLF
 tEroHwmx
 +R42DDHFMMDUhMfN/dzuz/E4Ro0o2YzEvDYix/IxyzURC2Sj9gsCl48w12f7N4TkULKUmDEgymTA+3VCGel6cUB2d2YOrwcPmG2TygPxqrOu34aYjNMu/wEOXKmISUec6OFBo5Iwfsj2nwlp3HDEJ/3ibE41L/1urWoPrDByTb8MgE1bHntz524csUop8dz/TWCHac+mZdj/Nai3cS6rpo03o3IYPoTBRjtOdmC84wrFx0dTuQZlC+XXKLtUV7ev65JR4b6L3/zwRMm4a8GBeGKVxbpWZOKbtL3bSUJ+/7ltQu550PFozRejzLMFwjyOamdHFXlaTbMjzy4axtgvziBIeB3s/m0gZ+YR+9R3ENDh/1QkZjA0332mWORi2WH8YNvOCdpbuYyA3NDAaaCZc8g4l9nVL9nMgi6slLUU2n2FpNglNIFMKkYmn9HzoyTjN8dUt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new update_schemes_quota_goals sysfs command allows users to manually
update the current_value of quota goals.

Add a selftest for the command. The test writes a dummy value to
current_value, executes the update command, and verifies that the dummy
value is successfully overwritten by the kernel.

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../damon/sysfs_update_schemes_quota_goals.py | 86 +++++++++++++++++++
 2 files changed, 87 insertions(+)
 create mode 100755 tools/testing/selftests/damon/sysfs_update_schemes_quota_goals.py

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 2180c328a825..a692ebaa6c8a 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += sysfs.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
 TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
+TEST_PROGS += sysfs_update_schemes_quota_goals.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 # regression tests (reproducers of previously found bugs)
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_quota_goals.py b/tools/testing/selftests/damon/sysfs_update_schemes_quota_goals.py
new file mode 100755
index 000000000000..745b97f75bc2
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_quota_goals.py
@@ -0,0 +1,86 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+"""
+Test the update_schemes_quota_goals sysfs command.
+
+Start DAMON with a scheme that has a some_mem_psi_us quota goal.  Write a
+physically impossible dummy value to the goal's current_value sysfs file.
+Wait for a while, ensure the dummy value is not overwritten asynchronously,
+then write 'update_schemes_quota_goals' to the state file and verify that
+the dummy value is overwritten by the kernel.
+"""
+
+import os
+import time
+
+import _damon_sysfs
+
+
+def main():
+    goal = _damon_sysfs.DamosQuotaGoal(
+            metric=_damon_sysfs.qgoal_metric_some_mem_psi_us,
+            target_value=1000)
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='paddr',
+                schemes=[_damon_sysfs.Damos(
+                    action='stat',
+                    quota=_damon_sysfs.DamosQuota(
+                        goals=[goal], reset_interval_ms=100),
+                    )]  # schemes
+                )]  # contexts
+            )])  # kdamonds
+
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    # Write a dummy value to current_value to ensure the command actually
+    # overwrites it. We use 2x the quota reset interval in microseconds,
+    # which is a physically impossible value for the kernel to measure.
+    impossible_value = goal.quota.reset_interval_ms * 2000
+    err = _damon_sysfs.write_file(
+            os.path.join(goal.sysfs_dir(), 'current_value'),
+            '%d' % impossible_value)
+    if err is not None:
+        kdamonds.stop()
+        print('Writing dummy current_value failed: %s' % err)
+        exit(1)
+
+    # wait a couple of aggregation intervals so that the kernel has a chance
+    # to compute the first current_value measurement
+    time.sleep(0.5)
+
+    content, err = _damon_sysfs.read_file(
+            os.path.join(goal.sysfs_dir(), 'current_value'))
+    if err is not None:
+        kdamonds.stop()
+        print('Reading current_value before update failed: %s' % err)
+        exit(1)
+    if int(content) != impossible_value:
+        kdamonds.stop()
+        print('current_value changed before update (%s)' % content)
+        exit(1)
+
+    err = kdamonds.kdamonds[0].update_schemes_quota_goals()
+    if err is not None:
+        kdamonds.stop()
+        print('update_schemes_quota_goals failed: %s' % err)
+        exit(1)
+
+    # current_value must be updated and different from our dummy value
+    if goal.current_value is None or goal.current_value == impossible_value:
+        kdamonds.stop()
+        print('update_schemes_quota_goals failed to update current_value')
+        exit(1)
+
+    print('current_value after update_schemes_quota_goals: %d' %
+          goal.current_value)
+
+    kdamonds.stop()
+
+
+if __name__ == '__main__':
+    main()
-- 
2.43.0


