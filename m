Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6D7ECD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EAAD6B03BC; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B606B03C2; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B716B03C4; Tue,  2 Jun 2026 09:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00C9A6B03BC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:12:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF136162E5F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:24 +0000 (UTC)
X-FDA: 84835011408.09.91001A8
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C78940002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:12:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sgmxYf/M";
	spf=pass (imf12.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405942;
	b=D00FIayHLSUZ/LcLmnkhHTz41/EdG6kXmnZxgsweIojxA+PrpRdSCIxTagh5H11p/ZGSj9
	95uqJbmA/ntb0YwDwdmJwdp1bGIobsP1RKDchamIRuVS6M5EHs7yNm7ZOplWQ9iMDhxXQx
	/DuXbRBpZKAanmpE9vHGKTiSpDo3rVM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="sgmxYf/M";
	spf=pass (imf12.hostedemail.com: domain of linuxoid@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=linuxoid@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xufbH6/LW8nomXQ4PybUK63N3KgJQEA2McZ4fEZ1QJw=;
	b=5nxQW1ptwvxB+/lkxRG5HFOiGVJ5kZMkIYFBFrrPF0lawu54TaWwBS75Td/3rLqwtDyctO
	XhdI8tayR0Kn79m1Z/Eif6sw9dMNjei8JvlO/e6RNN2OoS4JPxENnwTUVShxmkyb9LCdk6
	PNfgKyGRYq5XevzALxk3WZAufv7EYxk=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49050bfe053so83219145e9.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 06:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780405941; x=1781010741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xufbH6/LW8nomXQ4PybUK63N3KgJQEA2McZ4fEZ1QJw=;
        b=sgmxYf/M3XJAd+/XZA6QGrc6L/Z4jQsQ7qXEtOwC/1uJpNQ9a0mrD080zPtgat6DZy
         jwtRV86pN7kVfAvY/oksRY8KkN2ryXjYMTzJEORZoyFWKqjOQvKYZvl1oymVtb8VLIna
         hkiqPl+bo/AQ1oZhLi1KURZEyM3wWysOjN9wygW+SNyZJT37cOET+c8SyvckXeAA+ATH
         cyNaKR8k/hnEDaI5IyRI2P3SN4zaVA2PxVMV1jIwdHZ736iZxO2LJHKBFH/dDP2Qr+Qv
         zUW04RZB9sgyj6pbNKkEqO6ga+R/l/pcb1aNh8DfcUE3tRy1eQyrHPrbJzcEP/FgO4aG
         vgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780405941; x=1781010741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xufbH6/LW8nomXQ4PybUK63N3KgJQEA2McZ4fEZ1QJw=;
        b=E71LKo2f4pZp1sj4MbWJv9bXLKsyUF5uFAciAwRQlgrSfHlA7EWrYXVGLjSxz1OCzt
         V8AgGbQaWV57Mhc1ofSnRA7bHemVs8UgLsgmTCfpEVi7rsmYe4NVDMnI09Z8Uil4uZWW
         3bIBaRDGZRlrtPf5a0xffheFYItot+lqAtFuYpesyKcON6OMo6EduhC2+XL9Eh01QW6x
         sPVUaOISZwYdaH3aGeY/RtbQHLFF8aVJESA4CvsRX7JHdPQ5VDnu2fgL0tlH2/jE/Wn6
         MWLSuKyUTCJs/e4I5guLPo8Lc4adWQ++vjMRNiZsMtmhg9l3j2FPsOFbCKuLd6cZtput
         mFSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/vgEhJotWyE9KlfjZ2RJFiaf/sHLke7acL/qsdy9OQVfUvYFR42kbi3CBSR9MDySq2cVnV/XIgfQ==@kvack.org
X-Gm-Message-State: AOJu0YxxUdUquXY5cT+R35RWDNGOQgmo/UnFXrmHIcDvw0QArCxq30XK
	z3u5VhcnSnJArDcKNamfDcPJdTJxB8J1+75YzCGAYFYaLku/VnJt61WS
X-Gm-Gg: Acq92OFhrvLM/bt55osyq5E5rORtCtichE8u0i63CqbvFCBIIr4JkpGuebYbb/gdLNw
	a4eL1cb9266ETXd6E+wwiZc0rlWeMjV4XA3rU7llmp4sGiGUoVhvb83SfqZFlNv6vj7kvhFh7nZ
	0hIImWzcYc7Hboi1RBW8+09pAGi0A6xgFZG2KSPLvJ+pV8ynbOD35FTQDegyM0ipm27NiqPjKKc
	13jqDKBcnLG+u2NyiCJ1p3Z9Ow5TzFt1/YOMH2FYtqDwUbLpkqPx3nqJvi6AWBaWWA3sX9YKF8x
	zjhua5mSwYbzmRNHYnea2PzNuMGWut8ghM4MpwIWjYZkv8lmJGUNglPnlySV+Pp8L+9HHe5LhEW
	dqXJVk5lhCQ8+V26tLlwInPfmO88nCzz2pAyjjDtmNd5xpMhiAAhY0wKCK4XuYFOd4Xq+BrLd8K
	6U0r7pmZsUIIFrYyu8f32Nr+7Lw5Cua3fFMSVx1vf2yA==
X-Received: by 2002:a05:600c:5915:b0:490:958f:2a5e with SMTP id 5b1f17b1804b1-490b071aa9dmr56258675e9.13.1780405940691;
        Tue, 02 Jun 2026 06:12:20 -0700 (PDT)
Received: from x1.tail0e71db.ts.net ([46.140.7.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34c3081sm33234665f8f.15.2026.06.02.06.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 06:12:20 -0700 (PDT)
From: Ruslan Valiyev <linuxoid@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxoid@gmail.com
Subject: [PATCH 2/2] selftests/damon/sysfs_refresh: test kdamond refresh_ms
Date: Tue,  2 Jun 2026 15:12:17 +0200
Message-ID: <20260602131217.2210912-3-linuxoid@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260602131217.2210912-1-linuxoid@gmail.com>
References: <20260602131217.2210912-1-linuxoid@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C78940002
X-Stat-Signature: s9f8rn86qksxk3exo6b8gnohch9e7r9d
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780405942-885814
X-HE-Meta: U2FsdGVkX1+fkEtuuLrmZIUNmb1aIN2OZG1xq0dTueMRxOe79C48NTKx8IgDQEaWxvexewtTVAAzwa4UjfN0wcVDNDzMxzNjV1JoXmYIYi2yQlCZZgpo3HLTHsQLZe/QJzgRUOcIevz+0wzKf2QKK04bUqD3QSeCkBhPYgMVSWgRzqGY+qIxpb32/G1Mdrm2RnD68/kqQLEwABRvCYXBqfFVZDOO3GiLi8AiTY0Fl50g1Jb8NrWQ2+IiSZNpkW00ElCDT4Q+sMEOJ0zrxZRs4+QQ9blFYpMQpvwG7yBmBLXPJE5xqFBxXZVbSA+LgvN79dHR5B0P8xrlX7tyQ4fFkQBYyXWHvhhlB5wVZaaZtr7XWFaHrE30KPPGFx7atiP6CIWNL/aqzzpupN+sn3YwJv+EqLKqYyNp61svy9Smy8i1gAxN/Kj0jyHfh/mJSfPyyYcU/nIpXGiGwwa1Av2c4cj2I1vn3/GKHQctDKQQIxcs3/xJ82ijSfgLPLgr7YVPONgnxx4xrALgf0cNquqKojr12UYWRRfCyUApB5r15OcccyDr7sCSIiMAelfCz5B/uq9P/8rOwMP0E9UPAXC1e9xl+d5QtqS70JJWJpRU6EMou2FT5BvOWNZuNl552wRN5TtnJg4Dev1K6AjI1BnfVZiVpCk+edpJRtMCMQp2enu7VZ2WEEliY4KMADAX040VX1+UCKtCefSmWzVAbticmWtvr9YzeU2yfw2ChLQ+ow5KtONzhP+njQg9K626Z2S/wdHAesJ/vHnCttqrAW9iV54lKk666GVkxs8fkJ+bPDaqmJ3SavoVPZ2oXhUSofV2NW/UTFyDSbSvrn71Uu5Hz941nWf/cNokLjUFzZ9GmR0yu17C0g1odf9gjZgPcs83WYo+MtrYetgEafE9BxbNQfG216I15lhJvA7D4B15ocv3gAApcP2n7310pgt1i0qZyZrl8L81ZTgc0pWkC0U
 njttMw8T
 UuUdrGjeULmf/xB8aBzAgpcQkjMhNI69ceVTpHtm1C6v4Dr1EKyW/eSmIq75KAVvNCPxs9V2HlC8RA9oNUmZ/B6EdflmGsUYeFH0pPtLjnb7X2wEy+ZrobbIje8zDzEhUWQvW0+MGyBDajtDMaIhGxXCY2rAyiLQ4MFqL5pzaFPTVPMQS+vPEQhItRFG+zaZ1lE/u+U/8LSnR9cjMvuBodQ2tjFJYq5ywIJ+RQ18/KERPrLYBk8hN9V0zPUPiA0Ativ/wNwpX5fIjLx9MciFi4VGWEccwQt94vtNgD8/MSidyY35YGM1PTA67S8EPb/5joNvCeNxTPpwmd++TXm86L2hXy+C6FHiaOg2XR37/92A+4hc87c3kUOdFeOBnUjtmdgu7FtaDCLew5eRirpAH/YmA6rlsfZC2w2QUvJf+4LQZF8jhGYEgO5S9BF18+NmDIuAKvx+mz9NIq+8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
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
2.43.0


