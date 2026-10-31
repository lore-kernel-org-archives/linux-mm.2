Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA78606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xmf1ZoGy
Received: by kanga.kvack.org (Postfix)
	id 9BEF36B05B7; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9702D6B05B8; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886266B05B9; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 593B46B05B7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4D81A093F
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:26 +0000 (UTC)
X-FDA: 85384053972.02.E38FFD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 19BA2180009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmf1ZoGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70C4Ph3UTf6cW+VymDmG9zqM2mh9k5ZlsNQ24H+enrI=;
	b=35gTqHstyR55HjH/Esvjva2QHS4YmHw9vrsXNGSvn7SiPlmcm5QMV6XwuFQ+75l3rBUzmw
	TF9QeDlDdgR2m2l52J6e6s8mUW0/fjI16FsQihUiaKyy6t8iELdiU4uq+SOY/QUtDO6Zo8
	TSEJqrn+DLUWZFZ3MBNjBrxG5utG0O0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xmf1ZoGy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478385;
	b=CSDnRYtL8Q843jN+qZ43nzMBBayJT2nUwpmF1qDIDkZDrB3ysgu9i45Lt7+hEAtM5Aubrg
	Cjmzy3tlGttm1vDw0AVu3cKJrOyJFW3RMMb6PuzMnLAV5rdTAH6T+AHqHDs1zuGFeilb08
	sOZfr8Sfqkw1dQugE5SD5amXcZLEAXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6490743EE2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D121F00A17;
	Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478384;
	bh=70C4Ph3UTf6cW+VymDmG9zqM2mh9k5ZlsNQ24H+enrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xmf1ZoGylTJ7V7s8tHeeR5xjfQystGY8ac/LppuY+XFyKUcX4h4p3yCAx0yJhK59M
	 pQDoEkGjcbBAdphannF7mt1f6uGhWHfaNXUviR2tszW0CwUI2WIQPF3cvsKh82FdF9
	 KiyC4f6ZuBrCb9BRXbo6eHavlHFfBXkKbEJD2VmYAlXnZZwY7QyleQCFjCc6klxgTI
	 jXY9//+47DH84Z8C9j+n2UIL6/jUlqq9BRO7xcGUyPft+GR1YcMUKZCOYesgpOHUrW
	 aN4w36ja7orqBNxLPV6QgNFD5mFSNdHq9MxbEN+9ETcaE2A0sp3x8ZQHkn+EZA4xyZ
	 z+PZJtgQa59rg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6/6] selftests/damon: remove unused imports of os and sys modules
Date: Sat, 31 Oct 2026 13:26:13 -0700
Message-ID: <20261031202614.96036-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19BA2180009
X-Stat-Signature: nfaw7nskkm94botue4ysi4kab5bpiyeq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793478384-127701
X-HE-Meta: U2FsdGVkX1+h2nY3ZnIyAIn8Hfzl3jZPS7hgcAzrYpHdX0ORrAnxbePXvFn2K76MDSzYfAsdF4heO3Ffi32pnddN9y6nsSywxpqTXPnTT8Wjr9+P/zOJWjx9rW0t4IENWs1kJcIO8NGmL1HDKQrdZNgRom6iJHoBoZA9wc1zZIZr/mxN8EMsBybbVw0ThzgnxfjqUgs9PWYfoY4F5E2bfc8MDna5kZWIIFpFAW/u1K9e1jPWMyOXt54oXaZ6K8EnndW1tHSTUGr1a9pRjeUt0NYeCWNuf3D/OOrfzmKc5dp/TCvMZq7fBf5VAPhka96LlurBhyk15A67EemeTO7sDIBQye8kP2uJHLeqYpmD3NLA5sebrYhp7uPHwfEqqViAjH8vVwvZMr757g+buJGeFVHa2/h8rrOFGHIo0LYNhYoYxWwqwc/xfqHMn6x9YwbV+kIr4zb1/FcAGcjbFJylza/HFHAj8604lM9WCr1kaIlCxDlRmCqtL7mJEXg9rIzHSXOr0ueV9h4fiLeO0pn68cDcocC01GvGLaCk2Uy+MjwY2/YLEr2pnroxw9OM1hMlAfm5nFAfxNuBlKkz4s5KzrIZjYlw7QT7IyAXWfHdYxB7OYnWhZ58znt110Fh1BIcnBdvk9wSz7VyU4LtjiUZh+wOc+Y8SVP4iaCZlK+jzuwu5rE1hfwT6YEI3gB39dWBaejhMiVWVedBnR6iTb04vxRP+qr9DfoR7eB5sATkW4NevBQFdhW82L3x9cBLsl3B2XlcW3+i4HM9TII2x7xSON4/MNECn12Zu+WKEAz+ALPOw5sNgcNra206CweNRsknFR6/hLr7xau1Hn4NbmpmSAcTxxA8iBT+LGQzeMre+l/Wwm17CwgUUVIMUjNHydaZIAzZCyEFJ68xK5hxWTTjnFba43ubmQ4C39kIW7/GTpAnR8ciWZdpIP+TvyraazeL+rs3GlB6OjYp0WpVo1O
 uugWB9nK
 cXUYL+1+bHdFTugeU81B0VEUuJ4TM5O4Q/YoqEc6XRIW9fS8bTcNqDF1Md1XYJSH3BzfIcW3obvz5MnQHghMAKoLC+c37d9CYjkFvcCCpNYoUk+UUp3QeblhZemT3eQgRgg8akm7AXYKj/Bd+kJL2fThUwSm2wlTL4XFP61br6cYvSFn+AEBhZAIFMh7G0utbn0MJY3Wx6Tw5AKb2nFzS9dJgMbGzKekp8Hn0QS8Sx5T0PddPZ/LQRmlVIfPB1jXfkYcm0N/b306UL6IKafer/0ZrwcMqkMhVWQ3krRw9SVlvffc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sysfs_no_op_commit_break.py imports os module but never uses it.
sysfs_update_schemes_tried_regions_hang imports the sys module but never
uses it.  Remove the unnecessary imports.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_no_op_commit_break.py        | 1 -
 .../selftests/damon/sysfs_update_schemes_tried_regions_hang.py   | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 81774ddc55ac4..5664f75186bac 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -4,7 +4,6 @@
 import json
 import os
 import subprocess
-import sys
 
 import _damon_sysfs
 
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
index 625761c243b58..326a14f040534 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -4,7 +4,6 @@
 import os
 import subprocess
 import sys
-import time
 
 sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
-- 
2.47.3

