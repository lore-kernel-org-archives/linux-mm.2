Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3E2C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768056B0115; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0C06B0116; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B87B6B0117; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3334D6B0115
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACE061C0CB0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:38 +0000 (UTC)
X-FDA: 84933234036.17.667A59E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20114180004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9NuB6Qw;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744577;
	b=rEJ/lFnojSMPGa0qDMU8gEjR8pfzKC80+jqLZRSR7m0OJom40nDITsKCMIqtYBeySikmDl
	XWKRLNgC6EMa04CXRm9npOE6UpJIl3vEDH50Io1YozJxoSBXA1WZz+nmk3m8z0DUF3G5lp
	ArH3RIuBQpIrWkvLCYNwScxOrcRehWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jf02Ij8O80K2A7ATECAqkrfhafLEEQ+h7n6pFX7YXCo=;
	b=4BfVL6kzA5J1QhmIet0GatPaYP4RmiDN8P4Wm2PXLMVbyJOtndJdm4IryIpRlOS3LEHbNp
	r7oE6xCJLvSiataeADupphZQNA/RJJS3FGOn7aYObJVhb/GW9bAkAF5huFYjf9DDKEBvY8
	JKMxUvwVsAU1ljsYlnT7Dwg4a+bzIyw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9NuB6Qw;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9D78600AB;
	Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354511F00A3A;
	Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744576;
	bh=jf02Ij8O80K2A7ATECAqkrfhafLEEQ+h7n6pFX7YXCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9NuB6Qwn+GuWe+S0bSEWS5lP/9JluIjXtyezwZmrVqdJhpwrre577CuWhH9pIF5I
	 EgTUy/7NXimwhPPyophout9wNiSvN4ZjuVBRizCk/ELTPd9cEMYABojmHBrvesQ3HE
	 KpCKaVFZkhX2gCNcaEfYqJQhhQQ2ZGKNEsZW/odAUP2tFyEVUOYC/8Bp2usDJVuTI1
	 1k3RkNx1fyrcXd4VJvpGfr5hyDxcn3GUwqDZtcmhxjqRZm0qypctwOLRCSUSuSuqDG
	 1DWdkOXAEMm2nCaJw+ozaPahHX2cvbFa8YtKDxIuh8Bt94xCQuP3O30wvu5tWyb0zX
	 VZaSNd0x9zb7g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ruslan Valiyev <linuxoid@gmail.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/2] selftests/damon/sysfs_refresh: test kdamond refresh_ms
Date: Mon, 29 Jun 2026 07:49:26 -0700
Message-ID: <20260629144927.134237-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144927.134237-1-sj@kernel.org>
References: <20260629144927.134237-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4u1tc8qoz7ywynwq43mrc36fr93uokmg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20114180004
X-HE-Tag: 1782744576-686208
X-HE-Meta: U2FsdGVkX19dueswJpAujOoBL/DCldAZUirxZW5OshVDVdkG7taaA75hwKM/Nl1F52KeJtHJigYKe+wDmS5O5Juc8tGpcerSmZ3XKOUW+xG3YFRT2kTlrfPrv0zoJLtwH6+7/OOu0YipGfe0zw0v+Wo2KYPaFuxq2O7u8hi0yvtWj/xcndJ60PMKnvEwcA9Rhthyct3R/7Niw5n7LCD6HVhjhaw+KQJ202dbVJMYJdpnj0JdPoyKL49gjLuQQWQqNrOWrgOkgFZ3uKHrQ04JzX0kMvz2ZjTjolH6Zxmzf3g6gfVLU4j+kqhKoCZi7rMp4PRo9P2at9izz0Pj+1b8k20Vsu8/wpgaclTcwjdNR4YQdqQJHdnAX5ztvmEZ++phKsOLc3ZDMurdWTlr1KrR2mqEYLuxoG7xIMaLK23xOXwmAOBpJdE2/dLQr98R4Q8Vt62WyCcMx1/1t5PTKW97AB3kBbutSrDdbT3wKSc0CVlHtUDr7oiPEmiGDpTZ0PKwjw5GzYUXFuZbGHhLTRsiMD7ma3fE+cf8Nm+i/KRPgjxH1aaDEEkxpYqGpLSZGx3PFgvIJThwxd1oGXw00swKMLTlAhYxQU6cdCv+VLrxKfe4texbiKaGqCHv8iyO02PFizpo1hOsp0fV/03L632C3Bb5ZuYiwR8oBgiK2B01sRFvhAW1K1IdtsvCB7ui6uFilHNV7ENFqXlRKJ5zPdKvTrbDs/u0OF1h6BKleEJoxvxNGhVfJMWcY4It5hElq09wh57pOWmfAeIhQ50c2kUgxVStypqWfhNudFxFt4k4FeMIXsc8LrOhL8utZM7TpT2/UE15sv2YX/lOXENnmDxfg9TMMbSMfvFiD1Rxm4XNzKj4AyHvWvDRX/voeJ/BUyqIMkH93XIAMliYPx2s/HMsh8F//nTF7XeRe68ZDXMr3AU1zOYxi0UCS54gLihfNooRZU0txLDCFKr8fhgkz1T
 1x6mKfB1
 Lfp6tzqilz9DJrm/Y//YQC0c+FbSftskOzGbeKRAPQB010OzumIfXzcRqlK9Cclcde9vh1HUGSpv0GcgEfiCeQb8gw68xjeVNtZhLKqjiMd0oSxmms0bU/SX6LbtpaeL4KWwP9j1r8vTJ1qMqGoOel0TkmspFSaCLtskYSzNW9rThqFWsoUBlTnoHJJCpw0Wp9YVejtyL/pPGwXzbxUcLN5uoJwBNqlqRULa8SiYh1te2SxVS/No5UxYy/K2EBiyZRFjlFgMVoyCcoKQDgTACX4Jemtn9cAkOxGkWKG3W5cdYsPI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ruslan Valiyev <linuxoid@gmail.com>

Writing a non-zero value to a kdamond's 'refresh_ms' sysfs file should
make DAMON periodically update the read-only sysfs files on its own,
without the user writing update keywords such as 'update_schemes_stats'
to the 'state' file.  This behavior has no test coverage.

Add a test that starts a kdamond with refresh_ms set and a 'stat' scheme
whose default access pattern matches every monitored region, then polls
the scheme's 'nr_tried' stats file directly, without requesting an
update.  The value can become non-zero only via the periodic refresh, so
the test confirms refresh_ms works; with refresh_ms disabled the stat
stays zero and the test fails.

Link: https://lore.kernel.org/20260602131217.2210912-3-linuxoid@gmail.com
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../testing/selftests/damon/sysfs_refresh.py  | 75 +++++++++++++++++++
 2 files changed, 76 insertions(+)
 create mode 100755 tools/testing/selftests/damon/sysfs_refresh.py

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 2180c328a8252..ece244e5c5b95 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += sysfs.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
 TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
+TEST_PROGS += sysfs_refresh.py
 TEST_PROGS += reclaim.sh lru_sort.sh
 
 # regression tests (reproducers of previously found bugs)
diff --git a/tools/testing/selftests/damon/sysfs_refresh.py b/tools/testing/selftests/damon/sysfs_refresh.py
new file mode 100755
index 0000000000000..012b7e8f509f5
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_refresh.py
@@ -0,0 +1,75 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+
+import os
+import subprocess
+import time
+
+import _damon_sysfs
+
+def main():
+    # Continuously access a memory region for far longer than the test needs,
+    # so the kdamond always has a live target to monitor while we poll.
+    sz_region = 10 * 1024 * 1024
+    proc = subprocess.Popen(
+            ['./access_memory', '1', '%d' % sz_region, '60000', 'repeat'])
+
+    # A 'stat' scheme with the default (maximally wide) access pattern matches
+    # every monitored region, so its 'nr_tried' stat increases as the kdamond
+    # runs.  refresh_ms should make DAMON update the schemes' stats files under
+    # sysfs on its own, without a manual 'update_schemes_stats' request.
+    kdamond = _damon_sysfs.Kdamond(
+            refresh_ms=100,
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=proc.pid)],
+                schemes=[_damon_sysfs.Damos(action='stat')],
+                )])
+    kdamonds = _damon_sysfs.Kdamonds([kdamond])
+
+    err = kdamonds.start()
+    if err is not None:
+        # Kernels older than the refresh_ms feature have no such file; treat
+        # that as unsupported rather than a failure.
+        if not os.path.exists(os.path.join(kdamond.sysfs_dir(), 'refresh_ms')):
+            proc.terminate()
+            proc.wait()
+            print('kdamond has no refresh_ms file; skipping')
+            exit(_damon_sysfs.ksft_skip)
+        proc.terminate()
+        proc.wait()
+        print('kdamond start failed: %s' % err)
+        exit(1)
+
+    scheme = kdamond.contexts[0].schemes[0]
+    nr_tried_path = os.path.join(scheme.sysfs_dir(), 'stats', 'nr_tried')
+
+    try:
+        # Poll the stat file directly.  We never request an update (e.g.
+        # 'update_schemes_stats'), so 'nr_tried' can become non-zero only
+        # through the periodic refresh that refresh_ms enables.
+        nr_tried = 0
+        deadline = time.monotonic() + 10
+        while time.monotonic() < deadline:
+            if proc.poll() is not None:
+                print('the access_memory target exited unexpectedly')
+                exit(1)
+            content, err = _damon_sysfs.read_file(nr_tried_path)
+            if err is not None:
+                print('reading %s failed: %s' % (nr_tried_path, err))
+                exit(1)
+            nr_tried = int(content)
+            if nr_tried > 0:
+                break
+            time.sleep(0.1)
+    finally:
+        kdamonds.stop()
+        proc.terminate()
+        proc.wait()
+
+    if nr_tried == 0:
+        print('refresh_ms did not auto-update the schemes stats')
+        exit(1)
+
+if __name__ == '__main__':
+    main()
-- 
2.47.3

