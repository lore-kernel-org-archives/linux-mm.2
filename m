Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44120CD4F54
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 09:19:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125B36B0092; Sun, 24 May 2026 05:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDBE6B0095; Sun, 24 May 2026 05:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E726B0096; Sun, 24 May 2026 05:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF9246B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 05:19:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36BEF1402AA
	for <linux-mm@kvack.org>; Sun, 24 May 2026 09:19:37 +0000 (UTC)
X-FDA: 84801765594.21.27CC0A5
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 677A0180004
	for <linux-mm@kvack.org>; Sun, 24 May 2026 09:19:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FxV6gzFH;
	spf=pass (imf24.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779614375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rzFLSXviPLq0I/Xz70YuBFZ/FEtYhu4eVtx71crsM3c=;
	b=uVyt8JAmdcdcz132nDtaAMPxw6dbFp4CQEtxNuKHC/LZfSt05SpxLxBkhpq9rcreqQQNcl
	cBs1CtF8u3HDkId/nPLlZ+B4pw6C5dAq0gDWGQ6xTRN9s62chbZFjAYVQFNkqYDIX5B8OV
	DjYmAnE9BgZx+Ur1ljhsn+/MULBSJz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779614375; a=rsa-sha256;
	cv=none;
	b=bzXdf0fUqjVBFHmCM0jOsxSJtrpqfCKYC0BYh3iAWcwiuQoxxaMPSDw1YgizV2j5mMnNUJ
	/+R/kgZo51r6v4PAZ77bWB/Gu7V2mfW4Mmyz7kRrpW1BHSNsOAsRmSE7Bo8JilAeoxcKbq
	K3nbqooPy74HXmM6+/Oex3cizUdeLxQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FxV6gzFH;
	spf=pass (imf24.hostedemail.com: domain of saileshnandanavanam@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=saileshnandanavanam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2be3781e543so12117735ad.0
        for <linux-mm@kvack.org>; Sun, 24 May 2026 02:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779614374; x=1780219174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rzFLSXviPLq0I/Xz70YuBFZ/FEtYhu4eVtx71crsM3c=;
        b=FxV6gzFHeh+fYKfn3Ppqqy1KnSgEAwPXMWjdc1kH1ksacKKIuaR09a1se3YBHbh0we
         6K2KeeqEEZxSkF0IkypXafH/9Q9XS8X+ecOhZEEXWfHeDpj8aJ0Zk7/X2+Dfw88vxwLn
         WhOdUgHHqiIIeKj8zfwuBQxa8ahs2zF/kBbcB2m6/RvlIJXHJyilDdyU+PqNe7x70Y0T
         IqyiTR/y52eCnNmWrEvIPnlYxjGVZHymvfQTMvMaJZ/D91O3fcvIsu8FWEvDQ147D9Vc
         iS0Oho+Br/gOSEezWfR+XPnKnQOuBc1DBUeMJzIkaPc379nGnChBJNWVGLAOFM+Q5bVx
         Hzeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779614374; x=1780219174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzFLSXviPLq0I/Xz70YuBFZ/FEtYhu4eVtx71crsM3c=;
        b=oKCWjUny6htd3j/f7vMnGYum46QDPyxXkA76Css2jfabqQU23xgXQuYgaURfFKuo79
         62RQkkk66wSfXRBxl0oMJvzJA2PZkem0BmNIB/IfMgBg3v0UkauEYtQbncvFLEMQUsZl
         E+z6226aFhntiSVCn/oqPCS/4pC3T2PXvRDIDE48D5udq9YdwBd08FCksgvJKhdGVd0f
         guQ40rFi8+tV9Kdu4DKP1EbLOQbHaLO1g0FV/b33aquPPDgnB0lQcosGAbfUfkzc+/yl
         4Sgv2yp6VwRvrJhS6WXEgp1GMYk5SVU6K8qZ6/EZDGb+bCNrKMaq93BOQUCXStuDcPyw
         4Q2w==
X-Forwarded-Encrypted: i=1; AFNElJ90zWlkgn9CoU1QkRs99qdQhm05lL2lnrHGHN3C7l61C6xY2rfOyguhpLJUis7puUw99loQB6s7qQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7ER1t/BbSU+4j2Q5TwN6XnA3bnpKYUB7P/B9KHBKJHQhntNRm
	1BoVsZukN797mEeGwqy4O5eZ8GCoqer++DD5PVE8rVFYAiIUcKy3yCEX
X-Gm-Gg: Acq92OGYf4I5Ca9kE2an/Fu5QDwx8nV92ah/D0E7OkCdrGj0sS+SdlxUSlNmrv8S8vo
	9jKPI5wEbwSoYBv471yZdktBguVGM+hhqSVFIl1serwRbW90qBIXTZx7kJ+bR3hjpTN8DJY0Bxr
	HoSYGKuG+fG9B5Fk8L0nBAifA/K4J1QAyHRgM0zyEmu0aoE0AfcBD5x6gOs8SsXvElO8Er/3DBI
	KGVb3Q9VwOoADEgQfsRhC4hRotzVVCQaFIruNqiGC77UFuSVD6T1bIBqa2cDJ+IHcmVDx2ig2PU
	rj5bW4s1+iywijJuIhLvnYFLtaYrmf7Usrl09XJHjk3ESOmY4WqTzT98TIBBVKE0w34v4fTZWYF
	Fd5LN7YS1NKtx6gb5rnfjt8fWPTYsVkj4INhMXU8nuuW7PtCpiR/2J/GTBvNCA7INTEmT9E5gm3
	RUsDxYMCsJZ6kGGsjRxFwXBo2EL8SSLX/lN7ruu6CmJyuUORll0U/pD7T1v5U=
X-Received: by 2002:a17:902:ea01:b0:2bc:f1da:4c09 with SMTP id d9443c01a7336-2beb037fb81mr59515795ad.2.1779614373960;
        Sun, 24 May 2026 02:19:33 -0700 (PDT)
Received: from localhost.localdomain ([60.243.191.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58c69a0sm62023705ad.59.2026.05.24.02.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 02:19:33 -0700 (PDT)
From: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
To: sj@kernel.org
Cc: shuah@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Subject: [PATCH] selftests/damon: add regression test for damos_walk() vs kdamond exit race
Date: Sun, 24 May 2026 14:48:12 +0530
Message-Id: <20260524091812.35283-1-saileshnandanavanam@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 97jkfyd3axhopdccrjpxi1jkspqhoed7
X-Rspamd-Queue-Id: 677A0180004
X-Rspam-User: 
X-HE-Tag: 1779614375-744122
X-HE-Meta: U2FsdGVkX1/tfbyhkNdTZPZJVWhdFlEsUjVHnN6utPC5+zno55QemiufOPRBZrZ6oPWcwErE55AZ1USafFNGLBwgq1R0XfsPss6spnvLhXRkgC2UnEYVOooYfsqGQIR0wZbbfZXxq2yqwxcLfG62qIDaQaieH60eQNGrjQXLxlVudCzmZLFlam6jD4mZ3tpAo7Qn8erRVdfg4a+Hvn3mO1BpI3otCJCVZb6ByYD46E1cAr2mC4msGsJF4rHuEUkXPgnQ9JKUtNcvMiy8PpWGNZH7MSLqz/eni1YnJ/dqTRydoXo+U1y7btvXRV9C9xni/GfkGKleU9vuC23im0+KwShPtYYlmgXSTAUUHouAJifmsxNWEeZRQeE3+HxBUN2DmnNEaP1vq2jN1Nk9dpKFw32Kn7m6HP1eAcItNpU8i2/Nx/Hl/xbeikdVYwxt7uXcH+Gty0rp0P+9KE5gp4T2iAaYo5b8bvmx59QVopMk1PqkdsJTmvUnb5gS8TDKGl4Gw/LF19PLzYSJfgrEp0e6pu1/tEW/KeltJnhXa1jGieZMPweAdq8CAebOaPbXvV88+BlZhIEDluQDbhqaXguLw9W8TjT7EHQgO3zXtPb7nDIkHLUGnGv0Sz+ooMFHGtl1LaZe7wjy9bOhu2qOdAt1CklGFJIHxDtBF0VMgHGuXtLTotP+HDxoOCCWH9sJhvnoJofQQsCCw2cVWCHb4jVh+7s1eUCaKSW8mAs86Zr12opkjxKAXl3vr2ctH+MeVLM6bgly/ZPuGPb+TjNaSZaCAMQfy3rt0Ac0832H0DLLFXAOJ9sFshZnPek/7p7aMWoPdOUtUW/ZZeOzC2mfUfHOMH/OBjTOYJkolOCM2V3pAkIZZ7jWZ/YKG+cbCPJ7Lj+BC2t80Xh1+QLhEfyJawbDlD19WBOSoMCVoYxL74jTNlHaGUREDlg3iZkj1a8HY56zkv3LWlQNhP1cyD4zetY
 3i+kNGSs
 P+nvzSbSUCtNcLkp5DsbARrjouZIgkgCcCbsbkDliMGlvYc+jnr1FL5EG3H8oQz+DKADU577uxsuHF7Q7aL1xvZzUWn5QG7SOAK6fRaJxv+lkTI04tx4eD4Mnw113lSVdg0R+gsZ+pbcONQq1j5bX46ysHbR/yvXBQDK/MJsEM2oJx00UHnJRECiN5uicXXmX1cVAG5i8r2Bfv37vmtw6NkIiNOVZ4pFPyx7Ayku0jYAFoSnyu2CPB5AdacHiQeCL4Nur+MOkwb1XiEm+Rt8iwgxJ+c962qBLNkOm8xsAl9hKIL10yWTA6/8yMA971yRDZIzIRxlRPYr9/IUA99tMzzKJDX1BoHXf1+CK3/VllrXZahM8e1ju8IpUzm8e1AcC4S3MRJeXbVu4tQ4AGbNKsedhmxpgBEDKLzMXpn8zjCHbulFfShB+BIyBExlqsqAucGuz32y7NpF3Ao0=
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
rapidly calls update_schemes_tried_regions to hit the race window.
Without the fix this would hang indefinitely.

Fixes: 33c3f6c2b48c ("mm/damon/core: fix damos_walk() vs kdamond_fn() exit race")
Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |  1 +
 .../sysfs_damos_walk_kdamond_exit_race.py     | 47 +++++++++++++++++++
 2 files changed, 48 insertions(+)
 create mode 100644 tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py

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
new file mode 100644
index 000000000000..9b9d66a23f51
--- /dev/null
+++ b/tools/testing/selftests/damon/sysfs_damos_walk_kdamond_exit_race.py
@@ -0,0 +1,47 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression test for damos_walk() vs kdamond_fn() exit race.
+import subprocess
+import time
+import _damon_sysfs
+def main():
+    proc = subprocess.Popen(['sleep', '0.3'])
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
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+    proc.wait()
+    completed = False
+    timeout = time.time() + 5
+    while time.time() < timeout:
+        err = kdamonds.kdamonds[0].update_schemes_tried_regions()
+        if err is not None:
+            completed = True
+            break
+        try:
+            with open('/sys/kernel/mm/damon/admin/kdamonds/0/state') as f:
+                state = f.read().strip()
+            if state == 'off':
+                completed = True
+                break
+        except:
+            completed = True
+            break
+    if not completed:
+        print('FAIL: test timed out - possible damos_walk/kdamond exit race deadlock')
+        kdamonds.stop()
+        exit(1)
+    print('PASS: damos_walk() vs kdamond exit race not triggered')
+if __name__ == '__main__':
+    main()
-- 
2.34.1


