Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF08CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 10:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75796B0092; Sun, 24 May 2026 06:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D266D6B0095; Sun, 24 May 2026 06:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63786B0096; Sun, 24 May 2026 06:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B30816B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 06:03:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57B4D140CA3
	for <linux-mm@kvack.org>; Sun, 24 May 2026 10:03:31 +0000 (UTC)
X-FDA: 84801876222.01.F86C60F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90D74120006
	for <linux-mm@kvack.org>; Sun, 24 May 2026 10:03:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Drf2/asd";
	spf=pass (imf29.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779617009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EXBfuqbAyMEZ9CUfrSMvnKn8IB4mQp9S1TVPfOw1Hnw=;
	b=DidASRWv3JuqlF/357EuGepatQWqvZeGs78fWTiP9nzRfTufb7aWSl1k5astb06E+vwGLO
	la7WqQCFN4Bba2ayeNdIvdy7BMjGpIiyjxAAhfG2oQrlUBFdJltajKg8GlZnuOxiA7IU0g
	zVcAhvZX+VcUUrjfdCgdBBtZd1HIOa0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Drf2/asd";
	spf=pass (imf29.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779617009; a=rsa-sha256;
	cv=none;
	b=EHrVK1sqFFXm8+crdpgCsyeNKBm6A3HKceq/reSvyUJ+xyS7UU8z4pMQH6QW9hmI/sdLtR
	qge89Aa9xFeXRKVkIpnGo/t3AUYhlkVzsvwGytuMddRR6nybvVNj+8kmSK/odxOm6YniJM
	o7HSJw/DJhdT3AFW6FOcYMmQbmiXLMA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bd5b3f8a98so17020965ad.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 03:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779617008; x=1780221808; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EXBfuqbAyMEZ9CUfrSMvnKn8IB4mQp9S1TVPfOw1Hnw=;
        b=Drf2/asd1PO+XiN+RQ3tWWfjO5EYrUMk26NWXJqR++uDx4GdYc8IJQEtGdV8jaMzZ8
         FS1bUNhTVVaJJciQVT4fKnHvob2KRK+YF6ZkHaU5Onvw9nRseeduO6sPyvpbyrXKZq15
         f5LRVEskmQPdqYVS9TSCUxIcOiIigZMxtTgI4Ju93eCWXJaCyKbjUJ1A+kzZvyXB+Gnt
         wt0pkKJkLvwVkx3+GGeGUjTucTno7kZZTE8epEk1jMoxGTREB6VTosYZ9l7FEfMDq5X7
         I8C9VedNLeDW/QETAq//0YK2cKg8vklFXzCDTjhgtjCxLIpdCuoH6MmnfFXD1INDbDEy
         mH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779617008; x=1780221808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXBfuqbAyMEZ9CUfrSMvnKn8IB4mQp9S1TVPfOw1Hnw=;
        b=iwDcWljx6OthhMzeYXTg9NdHL3mq55FpOqeIYfvjJh/4RVruALl5YnuvUQRHozJGlg
         3UhxPvpPF0+08GErelpMtoSeVYHAip4kekN4uZqwgaaZnjPg6UvpvpWSb/5LV1/53tpH
         lukW+VRVIdM32WP4PHAe9zVR72236Ar9ZoyJQ/GvlbaOERn5oo8JSW2L31wH9cqfLQg+
         2zobZWPLPmJh/Ndom9wwhh4MaIJAyJZ4qnBrKKL6lkyMH92rbwZ/LKQSEoz5k6M8XUPf
         Q8V3npMHrSGJGFpV11JNFxWdSTNCueez3+EemTWnSRsBvgw0odOgtuOBXaLhJxxoNUeX
         HUJg==
X-Forwarded-Encrypted: i=1; AFNElJ/iX+DUAOfPGo5CEM13xisnK8j16An3jZ6VqRPg/hqCA2tdLLZqbOD2aqZLKWb0sRngemcSM65S5A==@kvack.org
X-Gm-Message-State: AOJu0YwnsyYSSxVAJxPzpWRPQN3pLR75elE3oxUMnnl3lvcuLVei9isG
	Q5i+3FVISkgiRnOibc24ZjIUPfCiisDTWBMaaQoGtzj9W1UkifLbC0wW
X-Gm-Gg: Acq92OGejMdI0ltdJQ0ijazVVBtdNrNWjHzpVmXx8mZxlh035cYQm2U6e6p+Av8PgDO
	miS9uszKOO02/Xng/c9FQHTYOk6Ch98sXdr7sE/0mrfPOZAWRk0azJa+WLsijhzEp9t0YDsvq8i
	nzQbPjLXTnqygvZQl70RzvoqHfYNLkHXs2XDm/45DHGsw4qccjZ7WiLZGiDENoILXWBHOCGkcAh
	mncTRAgOSUSA02uvIKG4/H+YLIaBpNpJEPeE9egy8A3UnPgqaIQVL8YSR3JXPsSa9SE8lZZ7ZUi
	l09m1HAWKWqKIVySqrxHW4JMFLEGv/Td3T0omWpBqwca7j+6aSMACvlXsEvhTBcFqtq8IwRRMAK
	cfzA8EikFIXj/sR6V1m2GlmMk1PzXAlQhnVE8dKfHBu6hLQoMRhvxzxqWAnddvmRX/95exJr7qR
	zycQSz57Cw5k7wv1HkpPOdaZnCQ1Tnxt+OeJpFMkLwBLa8NUEyhlQf6NO6IAk=
X-Received: by 2002:a05:6a21:4a8c:b0:39b:b6d2:1f24 with SMTP id adf61e73a8af0-3b3285caaf4mr5506279637.0.1779617008111;
        Sun, 24 May 2026 03:03:28 -0700 (PDT)
Received: from localhost.localdomain ([60.243.191.184])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84165009761sm7630123b3a.60.2026.05.24.03.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 03:03:27 -0700 (PDT)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH v2] selftests/damon: add regression test for damos_walk() vs kdamond exit race
Date: Sun, 24 May 2026 15:32:58 +0530
Message-Id: <20260524100258.36819-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90D74120006
X-Rspam-User: 
X-Stat-Signature: 3wj3h88zcuji1ha6itukwcajd9yxj8ac
X-HE-Tag: 1779617009-775212
X-HE-Meta: U2FsdGVkX19kc7PR/p/0tqqpPpTzxwHTujfbsPHh3YE8AQE4YX2LHHYdz9ZqCvmtPAtbtZnzroSezMxh8qMdoc39ODqOwHoT/jcHsJpt3d7xAuX5h/yxqfiXYw2z5AH3Hb525Cm91ggxjq7EiUN8bOm6McCN/HPEM/+U6q0IIG8RNdhn7cW1B++EDxRNhJbUx/RO6l9x8E91cUk5xz8KkxHL982guSwZJPQc56U77zOgZhvOigrn2lY8mTZUnDdjdc/rAbrU6laQO7bUleL1hcSBz1+mrTktJndPFdwv7ZKUjZT01+g3RqA92csrNyADB8x7qT/KN7EYEAzyliLEQQaVaeD9L4R85lILGvgLl0irC+Sa+PQXbOrtc93tCRXWEq9Q7jLNynmt4O/WDn0wTXxYCoHYfPF1ZXihN+hUOfc1J8+ygg/5jHfVWORqZD4f7NyYcZ8byiHQDDtt2QLZ7sAUax60BYSG3pUa/3quX0ZcXaR1b378YF/qbZSstNNF+jQx5Bqyho0Fo6BcKK4t9OnTI1uXZ2mZIbb3GpqxretJxFQAU+ngv9BwSYYOkI5teYL/1aONwEAmolcmbmwjop3wHQ2oVGKN3lhzJRX3u1wlooIvOHG2bWwxi6FyPIpfR6DrqfVYGolW3ec9PXB3bM0sxPY7DMB2GzKuQzNWTAqZ6XQVT0bwzAFdeYSny5ujfXwQNN/QxO1aeeCI4WzkBQaGxPcCUhi7aaEP1c1w64gvwRrHelGIAmnzZ8p4HrFJpepGjUvqN2h4T9BxoG33Dyf4LIXCAOOBX2BdbZLOu4wpVEpRXs1KDJXoQSwTOflup4j0ub332HwsVwcBaBMLMmJoRh5V34mgq92Hwge4DacaKjUgjnu4iyL7BWVdS50P95i/x+mGwjcDHK1Usx1sTVOwWRi5AMyzIEg0p24t10ttdNDLH+xtouedhfStwXrj8Jvijjx0TlzvjnjNst3
 ENxeE59s
 KUFdeRIIYUylM5f4TRIfMCr7gGdGwxLkfcFDM1mpU1TEEkLqOVmhGii4Y4xAnYuaWPOHe0hEV5Kxlrnnsd0XHSrdc7CgCLnz1RhM+2w9zwtiKIA/b79gHkFM3aEay/FrhVyJPIwVw64b7KDoT4AFpN2oCDUOla1r9fobcdLBdoOGDF3p1SEYSvQL9ZUk0KwdJClSFbTYmLi7uDWdlU1Ktkkbs5yIwqjum8GP6TRjRDrK4G149/7GsTb15YJkIRF/Kw6t3tsY45yhsCg7tFnSprpdWdKLO3S/BHnTDQ/dsZixWczr+pTXmNhcXQOLC6QVG9HGtj91x7fXJ9s7JmDsJWPufky7mb4AYva3Mmu0XTSXu4rtX6etrKU3RRSbdSbzdOL2y05S/8zHtUBD7EDG6qU7CLWtUHVfpBN/z4w5YczMB0Ue2h1UYS0/nOOIsfNkqxGBwS/LouZ8dLY7ZyaRqgljvMTaKjnlOdrfOZ7bZlLBzDi//4fgt7yyXKlWAQMTfB6U21Fh1dSZzxEKfE1ERsLk0VsvlYpethRh1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a regression test that verifies damos_walk() does not deadlock
when racing with kdamond_fn() exit.

When kdamond_fn() finishes its main loop, it cancels remaining
damos_walk() requests and unsets damon_ctx->kdamond. Without the fix
in commit 33c3f6c2b48c, damos_walk() could be called right after
cancellation but before kdamond pointer unset, causing it to wait
forever for handling that never comes.

The test starts kdamond monitoring a short-lived process, waits for
the process to exit naturally triggering kdamond termination, then
rapidly calls update_schemes_tried_regions in a separate thread to
hit the race window. Using a thread with join timeout ensures the
test can detect kernel-level deadlocks where the system call blocks
in uninterruptible state.

The sysfs state path is resolved dynamically via the kdamonds object
instead of being hardcoded, and exceptions are handled specifically
as OSError rather than using a bare except block.

Fixes: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../sysfs_damos_walk_kdamond_exit_race.py     | 82 +++++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100755 tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 2180c328a825..60c83d6c318e 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -20,6 +20,7 @@ TEST_PROGS += sysfs_update_removed_scheme_dir.sh
 TEST_PROGS += sysfs_update_schemes_tried_regions_hang.py
 TEST_PROGS += sysfs_memcg_path_leak.sh
 TEST_PROGS += sysfs_no_op_commit_break.py
+TEST_PROGS += sysfs_damos_walk_kdamond_exit_race.py
 
 EXTRA_CLEAN = __pycache__
 
diff --git a/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
new file mode 100755
index 000000000000..8e8006d63926
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
@@ -0,0 +1,82 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression test for damos_walk() vs kdamond_fn() exit race.
+#
+# When kdamond_fn() finishes its main loop, it cancels remaining damos_walk()
+# requests and unsets damon_ctx->kdamond. If damos_walk() is called right
+# after cancellation but before kdamond pointer unset, it could wait forever
+# for handling that never comes, causing a deadlock.
+#
+# This test verifies the fix by rapidly calling update_schemes_tried_regions
+# while kdamond is naturally terminating (monitored process exits).
+# Without the fix (commit 33c3f6c2b48c), this would hang indefinitely.
+
+import os
+import subprocess
+import threading
+import time
+import _damon_sysfs
+
+def call_update(kdamond, result):
+    err = kdamond.update_schemes_tried_regions()
+    result['err'] = err
+    result['done'] = True
+
+def main():
+    proc = subprocess.Popen(['sleep', '0.3'])
+
+    kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(
+                    action='stat',
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        nr_accesses=[0, 200]))]
+                )]
+            )])
+
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    # Wait for monitored process to die naturally
+    proc.wait()
+
+    # Rapidly call damos_walk() while kdamond is exiting
+    # Use a thread with real timeout to detect kernel-level deadlock
+    deadline = time.time() + 5
+    while time.time() < deadline:
+        result = {'done': False, 'err': None}
+        t = threading.Thread(target=call_update,
+                             args=(kdamonds.kdamonds[0], result))
+        t.daemon = True
+        t.start()
+        t.join(timeout=5)
+
+        if not result['done']:
+            print('FAIL: update_schemes_tried_regions hung - '
+                  'possible damos_walk/kdamond exit race deadlock')
+            exit(1)
+
+        if result['err'] is not None:
+            # kdamond stopped cleanly - expected
+            break
+
+        # Check kdamond state via sysfs using dynamic path
+        state_path = os.path.join(
+                kdamonds.kdamonds[0].sysfs_dir(), 'state')
+        try:
+            with open(state_path) as f:
+                if f.read().strip() == 'off':
+                    break
+        except OSError as e:
+            print('failed to read kdamond state: %s' % e)
+            exit(1)
+
+    print('PASS: damos_walk() vs kdamond exit race not triggered')
+
+if __name__ == '__main__':
+    main()
-- 
2.34.1


