Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C558C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6771D6B0099; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2E16B00A0; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D3D6B009D; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08EA26B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 736D4A0165
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:04 +0000 (UTC)
X-FDA: 85212577128.12.EE6C6AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0F88140009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJpoxhar;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395602;
	b=h6nf67Apn2W04ffPdseUckA+htb8UUbEN492QKXdkCDwPAA7+Kr5rodcB1edNAVQcpI6tr
	0N0/Nx1zHRFx6eISm1o5lb/raEVFT+FAbhTgwK2K1dRK3ocWSr/Gkm9BvfB2g76LrLiqPf
	hZNk9N95zQkCaXtU3I8SQOvsPmb8ih0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJpoxhar;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMSM+RY05r6OH+v1CtMIxEVXYlWKzTDj5y/6JWGPvKc=;
	b=DTP+Xy1KT8gSuMciHMPeY43drNSfTfL8eqWXAL8CSLeUW00/Nh9xyJ9a284z6VjXOIOT5m
	Egm2n3w8qSe2/kOgECgoi9TyB35/wCHKqVt6ECpoADvXwwcBbtDrbYabvZrjpUvIhf5Riq
	c1EhzCs2pVAlyK8QMqVbWYHQ5sFlENk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7849C601FF;
	Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F381F0089A;
	Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395602;
	bh=iMSM+RY05r6OH+v1CtMIxEVXYlWKzTDj5y/6JWGPvKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJpoxhar5EcAr9Tj32UEKCjB7ygUKbu+YQU2MwEULu89BluCAJAvbiz8D9aLFe3YG
	 m4O61hGCSQ0UYdO8yIgUDixQlB/et1Zirheejfmo2ktwuCi9r78kzt8BPtFgRqgAaK
	 +V13J3DqhduxvjoE1QY0FHOAfyKFB+Pz/Ig249foADiDCtx+eEA3yPQT2WcsNgafrD
	 OoAJudEDwKaYMoCTZQ44t5loXVYBMqre193GtpoUpCzRikHp8b7PTkneOrR/PF55Cr
	 eRw7wbeExZ967wBmO1MYstDrdkz3rC5DwnrmueWTUku27UgrfALTFxxvXDiCtCobf3
	 dzdsJmnzyR7Fw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/6] selftests/damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
Date: Mon, 14 Sep 2026 07:19:48 -0700
Message-ID: <20260914141952.91465-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D0F88140009
X-Rspam-User: 
X-Stat-Signature: 5zjsbqxcdd1u41hj3c331ky3trjsk9yt
X-HE-Tag: 1789395602-811827
X-HE-Meta: U2FsdGVkX1/DHvK5O4HhAJ022A+gyqWJ21ySdZLrwK/G6KN2WoyXPnoLNayODVyuLmoCZtAuBz0ADtvf08qbsWlInQujgNbse92nEAIMc6tJYjRW7e3/6rIjMhjOwu6RrZ6yLYsaPfKS6RIbjPdiv6GlO3u/NKq+jdhcTBY+vuEs2KXefwJGPjHHCzmKLmoI+m4F8YtMoHbLtn/NFb84A97Z95MnksNq3mr+Abvk6kBeC+FjqxEe5DABlNq/XTEcqkVKvyZMirrUl5bExBZHXKCzGSscAqjvawBRNUFcpS5ase5SZhR7tQPJyxX4NNBJmwVWB+x3/M7dAbovyQDVB5EsHQGtwZuZpMddkg2BGi9D1R4eRNyBBOjur3wxaDdp/00stjdwoq0IMgBkm6he4wX3dktofxUjME43r/rpbDZvL2KW8a6gUxVSOG21LxurTubu6wOgEhE6yub6lqRU7Zgxae5qjGWNCDKSeBDOa4doIPFWIBDuFAUIUfcsUqcx4zLsbN+U0ndqJT1U4WfeUtemz9i6pFAIJELXLYEXvO8JbLYg8ap3aYqcDSPMLw08P9/hotpkkW/8dufcs9uZC7YZGSeCiCsndgr10S4A7JaYFIrmyUhIq0WFhoyQoekDw20v/S+rw5P5jDvZm2uL5+OpYqzJcUKJbKFpojklXl48NMCBQKPFsMog4fNkEsj4fAWWNIPiJLKsJnbeIuonDwDH/qnNh+Dv9MT1tX7mnSJm78O0mJcUtnZLYhMdtRZ9sNuBuTMLmqkoQt4RWmuf6s2gevHIFDx1V9Zn1+sKDhOfZc1KV6NcXWe4H+NVvy+k7VLPiPvuDi0UNkAw9ud6lLUqUujqU0A/8lye9vBhUxrxmNuLnG8RtEjKzoEQ4a21RyjvEEUGsVxQQLgFszaVF2Ye46oM4x2Dmt6sYMDc+1NDkN0hg2yXuE60t+RmVAivjMYCkngI0WGrcvEcN+h
 Bock/wv4
 LTUEgzT/KsTbgkfmAW89ow72Ei82ROiqz/BGInZ4yMqIvUfF/p/wYS4wHvwgqxz8tpsHuVUIoKVkDQVDdmdFdouUi08l3oJwTNGo5+4U4RF+oGxLKJgl5etPINj5+h1P5QOD78EcQzNBAYe8oETu1HFNGU7NMIrUczyCIpowXdLtszeXOMA1vbJcSbOE3cAMfIZOwYH+D8GloA/tQ0Lh+25gBwCt76BuWCrcJVGaAij0n46zbfCzwDLcWfqI1mA4VCRmOhruCg2JMu7ihFQuwPRJxBrdpljJMQR3C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

Running these tests under Python's safe path mode, either with -P on the
interpreter command line or with PYTHONSAFEPATH set in the environment,
stops the script's own directory being prepended to sys.path. Some
distributions (RHEL, for example) build the tests with -P in the shebang.

This breaks all 7 DAMON Python selftests that import the _damon_sysfs
helper module located in the same directory:

  ModuleNotFoundError: No module named '_damon_sysfs'

Fix this by explicitly adding the script's directory to sys.path before
importing _damon_sysfs, following the same pattern used in commit
c3b3eb565bd7 ("tools: ynl: add script dir to sys.path") which fixed the
identical issue for the YNL tools.

Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260908214238.2680324-1-eva.kurchatova@virtuozzo.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 tools/testing/selftests/damon/damon_nr_regions.py              | 3 +++
 tools/testing/selftests/damon/damos_apply_interval.py          | 3 +++
 tools/testing/selftests/damon/damos_quota.py                   | 3 +++
 tools/testing/selftests/damon/damos_quota_goal.py              | 3 +++
 tools/testing/selftests/damon/damos_tried_regions.py           | 3 +++
 .../selftests/damon/sysfs_update_schemes_tried_regions_hang.py | 3 +++
 .../damon/sysfs_update_schemes_tried_regions_wss_estimation.py | 3 +++
 7 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/damon/damon_nr_regions.py b/tools/testing/selftests/damon/damon_nr_regions.py
index 58f3291fed12a..e55239813c654 100755
--- a/tools/testing/selftests/damon/damon_nr_regions.py
+++ b/tools/testing/selftests/damon/damon_nr_regions.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def test_nr_regions(real_nr_regions, min_nr_regions, max_nr_regions):
diff --git a/tools/testing/selftests/damon/damos_apply_interval.py b/tools/testing/selftests/damon/damos_apply_interval.py
index 0f2f36584e48c..0bf7768b2006a 100755
--- a/tools/testing/selftests/damon/damos_apply_interval.py
+++ b/tools/testing/selftests/damon/damos_apply_interval.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
diff --git a/tools/testing/selftests/damon/damos_quota.py b/tools/testing/selftests/damon/damos_quota.py
index 57c4937aaed28..879115a499bf8 100755
--- a/tools/testing/selftests/damon/damos_quota.py
+++ b/tools/testing/selftests/damon/damos_quota.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
diff --git a/tools/testing/selftests/damon/damos_quota_goal.py b/tools/testing/selftests/damon/damos_quota_goal.py
index 661e4ba4765ae..fed033a0afdf9 100755
--- a/tools/testing/selftests/damon/damos_quota_goal.py
+++ b/tools/testing/selftests/damon/damos_quota_goal.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
diff --git a/tools/testing/selftests/damon/damos_tried_regions.py b/tools/testing/selftests/damon/damos_tried_regions.py
index d6472e6a6e082..6941f87c10b1c 100755
--- a/tools/testing/selftests/damon/damos_tried_regions.py
+++ b/tools/testing/selftests/damon/damos_tried_regions.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
index 28c887a0108fd..625761c243b58 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
index 16fdc6e7fc566..36e7ae5f826d8 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
-- 
2.47.3

