Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC01C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 21:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE746B008A; Tue,  8 Sep 2026 17:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90206B008C; Tue,  8 Sep 2026 17:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5AE6B0092; Tue,  8 Sep 2026 17:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5E06B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:42:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F6BD14079E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:42:52 +0000 (UTC)
X-FDA: 85191920184.04.99A21E1
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99820120009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:42:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=ETKbjd3P;
	spf=pass (imf29.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788903769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O3DiMovYc6B1Qy4ylGXWdug+s2LRTGdo7r7Q/lm2Uiw=;
	b=s4vDGRaJkV3ioshZg0VUbzZSYWSbWYXZGDSmEt+4qil4ITHZ9Luja76ElUU7SNyICz5uoV
	DqYsD8mZUtjh8oI5roxrpyuZNtVZImXtlMut1bmQd1V+ndT/Fko9CqB8+EY2knpOfDliCy
	31QBnpn9a2FPSKL9WaMEQP3tCmpxQeA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=ETKbjd3P;
	spf=pass (imf29.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788903769;
	b=mDVjujsRUPNs3mW3PD7B+j3eTYfjXcfT15+Xq1Rhuy5smSE88aKNIzper9fSBuPJz1EmsB
	RvgUjpEmKV95QfA0JOwow5ygZyAN8Q0Jp3m/KsfwkKfWY0pHMZBXLdj4848viUlQbn0rJT
	pemT2LfSNeVzzbRGbHaE0CM24Q6CUpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=O3DiMovYc6B1Qy4ylGXWdug+s2LRTGdo7r7Q/lm2Uiw=; b=ETKbjd3P0aIS
	zLSFZ4jfN+wofW8JHslFcmsD/O8r/7CEOqA2CgQBIibGHKTUOX8LU1w20IQX/08IABQFAVcKGRY/V
	nvDD4NqKToHgZCbe7G868ys1SH3bS9dxZTs7KBtnS1i2+7iYdXqp/fauxBg24bSsnL4FoCwOJY7+v
	/n7uAIcXQYOCNmidfaxypgH/uI+fb8kUwRqIC87TLKhn7EK3sKy/U6hmNqC+yN+7JDtOn5RVzEXmX
	6o9I/XnywtrvKrzzmK3viVCj5TCSB7idsz7smYg52LiN0tQxYG5mm6wKDUH3FY39X2lGI7EGujwE7
	AiWkOhwaUM4nj261WH+Csw==;
Received: from ch-vpn.virtuozzo.com ([130.117.225.6] helo=LekKit-T14)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <eva.kurchatova@virtuozzo.com>)
	id 1x43Xv-002j23-0I;
	Tue, 08 Sep 2026 23:42:31 +0200
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
To: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH] selftests: damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
Date: Wed,  9 Sep 2026 00:42:35 +0300
Message-ID: <20260908214238.2680324-1-eva.kurchatova@virtuozzo.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6xwtqorgk4jtxt4fmdan7s9mgg7utn3w
X-Rspamd-Queue-Id: 99820120009
X-Rspamd-Server: rspam07
X-HE-Tag: 1788903769-935707
X-HE-Meta: U2FsdGVkX1+zW80S9dW1fAer6HnwSQpBTrBKLKvGXNq2fH5m24MTkLqAu3Ltk4il3QJ/UUfCNSDiBGM7aivppu1vFcgreGPYtykpso4E91zN1pPOTjXVfo6cHsG0mNDyf5JIqPa3LBdfne5ftybA6pdlprm5I9rscOiWJGFVHf1+pVjl7pslexCugR/4l5N2NHKVG1ZmckDPQnbXNH1LGDRz8NGUlt201rUPRJyfIgEEgc+Koc/biG1Gc+IPVdiWO2y8bdx8tzbnmwHA0nRoj0L8ud1clothII1dll5NNXXKbs4arR1AVRLdGTV6GPLWr9rNPv6aiDyxvNScNkYKXil12VuvKtBKpLUvGaVLZkdhY3+bhOW+GFXVuCP7Kk0e0Cz2hPzu/6swu2oTtG8HZifCWfSWN+fPQGLZr8O6euven3tQM6qzQOs4N2Mnf5LBtDuCGkH9mUq5JLC3CPdLkiVEGakhm3P6as8lrRw9qVKpgr/BDFZZCH3T1ypkbDxzi5i7UXwEp/p55V5sccXhJ5W9V/G3RkRJW/hs7kmfrSxqVDEyzNBwObJrtI/BG7VUHSkjUvgym5DzA8X6kUmZZlbyd/AEo9GFYEn1ugRnaKpY3fS/R+HdoMwGKg/M7rajJzcqTRWs7gyUo/v5ViuQ6PoAgJ1sJF1atbY7BY4KukK++zRSmluJvw4qiw0Rm3LbwmZuix6HqU4Rw6F2HnZzmz7UGwYS/Bi14dZqnHH+DtJNZF40U2TxaR+r/vVaqxBalH+njRsNBbKwEmzLGpQGvJ8oFUKwT7R0ApFazGtfE8GQvmz+44nSs4fX8FrblMaTQVuVywQ9UV9+r0IW5LVsqmo+JPScmMv3YYgWQ26FFklZHwXVuTutURqU+6rgEpYqWaG20GUvdGzu90dM+CTaDCHc4WiaFvrxWiyDBCcPkRyAGg63a0wGJwwlQZNR6Vf14TJqfzwUVPQQIC8KHjo
 B87590Qi
 qwJWp6kEvc8gOGVgDxXhLOia5AZE5TJe1049NQK8emAME/SFzMqRerjqII4rnpWJw52c6mTt4ODU+F/wygb4vBOHfoRRw+wPLNkyguEbiSNmzdvQVgyoofdpMHmsqO8OHCq2JBoxzoqjdQCFXUHWNgAJAsD0/W2hpK5//6X6BklTgnrBD6gChrqzcLozkIREfRCc2mVV4z8cKZRo/Ym38inIdI8ZV9obpYxLBCjykj5qooy0YpZZbAReK3kjJOaafzez0tI/W1LaGnoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 tools/testing/selftests/damon/damon_nr_regions.py              | 3 +++
 tools/testing/selftests/damon/damos_apply_interval.py          | 3 +++
 tools/testing/selftests/damon/damos_quota.py                   | 3 +++
 tools/testing/selftests/damon/damos_quota_goal.py              | 3 +++
 tools/testing/selftests/damon/damos_tried_regions.py           | 3 +++
 .../selftests/damon/sysfs_update_schemes_tried_regions_hang.py | 3 +++
 .../damon/sysfs_update_schemes_tried_regions_wss_estimation.py | 3 +++
 7 files changed, 21 insertions(+)

diff --git a/tools/testing/selftests/damon/damon_nr_regions.py b/tools/testing/selftests/damon/damon_nr_regions.py
index 58f3291fed12..e55239813c65 100755
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
index 0f2f36584e48..0bf7768b2006 100755
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
index 57c4937aaed2..879115a499bf 100755
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
index 661e4ba4765a..fed033a0afdf 100755
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
index d6472e6a6e08..6941f87c10b1 100755
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
index 28c887a0108f..625761c243b5 100755
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
index 16fdc6e7fc56..36e7ae5f826d 100755
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
2.55.0


