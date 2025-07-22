Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3991EC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 06:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8166B00A3; Tue, 22 Jul 2025 02:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A890C6B00A4; Tue, 22 Jul 2025 02:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB376B00A5; Tue, 22 Jul 2025 02:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0D26B00A3
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 02:03:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DD6DB746A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:03:37 +0000 (UTC)
X-FDA: 83690858874.15.90DED66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B740B20016
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 06:03:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUrC06TE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753164215; a=rsa-sha256;
	cv=none;
	b=MZDV+cs1mHkns6BlmVaeqo0w7hYlPpk/K9jl9IHwwRjpVWUay9tXDw8Y64iQQHobtMUVCq
	D4aMrj+xIo1d+O8w0ArYXtpA4Xxyrl+HG6LY2DFBtg2xhtqDN+uJf5uNOEYmerOXCDMwqm
	u/ylOrpH81NpL4eJBmB95l6zeEQ8g5Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eUrC06TE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753164215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rh61Fpfk7x8alVtQZYfRDCDiLhqaFxLESFyrmgc3CN0=;
	b=M39bMia4pCIsYeDoNrVTFlEe1EgzU9XVsGWQGChcwHsg6DiPfAhHRga64FP3UzbQISoDIY
	WKst0eczX8pvNDsj6hT681kkqBBzyR+PwF+v76/r6Erg/oUjkJ9ZKiJp7QnZTGnRyj5pTG
	wbjSoh+LCVBcffbm6wz8HGsJ2rWpoWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06D6B600AC;
	Tue, 22 Jul 2025 06:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922B8C4CEEB;
	Tue, 22 Jul 2025 06:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753164214;
	bh=D/8nQwpw1b4H3c6iBDsuwHR1cmui2Awzlsl6JSLf2cE=;
	h=From:To:Cc:Subject:Date:From;
	b=eUrC06TEQlGMy2kSlY2ON+CcOM15LY+UWEDecYscx6zBjbB1vWYLhf9hdZTosoff3
	 7z9uor+42noAHiZcLcXBcow+G6NmSlQm8Hs9CxzDrik6W9JSAlP7pazM/BegB3PuMR
	 LKNd+hgEWUY05EdZE9DgsFlZgUEKh8pa6BD2rYG54SF+lU7phQiDkexwSC0zfqDUIT
	 vFIF3Dh+4iSe+VGF2vdo3VWAcsLojbUdatKsj03CIS3GtDsnVK7z9uxpyT4iKg8bCx
	 Z1QW8FUIQT1v58OPndF/p9/SyXdf+W9NJ8tRoPJFQV9OotUz3PjFKjN+Ok3pxy5y3p
	 lzR1G/9jxqhFQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-stable] selftests/damon/sysfs.py: stop DAMON for dumping failures
Date: Mon, 21 Jul 2025 23:03:30 -0700
Message-Id: <20250722060330.56068-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: efxxtksmb6iuzwpw937q1ro5igbfibnk
X-Rspam-User: 
X-Rspamd-Queue-Id: B740B20016
X-Rspamd-Server: rspam02
X-HE-Tag: 1753164215-377241
X-HE-Meta: U2FsdGVkX1+cuWvoJ+LEc7hBx9ICmZeN2RFoX0m9bKEmH1UoJNTY400Hx8bWEWoAuDxgwSBwCFexf8k8YqK5ibtYBGkLCLChT3nwZX9F6HfkIg2Nu3Cb1HXJwq12GoKZORMnA9lr10IzySddi4vXv7Q5Q2scM6Ia8HCNueyh/ep/zXnQ9XvKJJcMncBkQf1rus/Z9TZp0mrKfYNSEyfW69V7AChTF2zEDUXHwXJqKS2ANjV+xusBmtAgFj42zAQ6GcT/Ji2iZjM/OOCp8ZivrETKMMo51GZGcJZJ2QUXyFWH5JfBoOmDR+zZVELUMQ1YRtBelcN48WiIg++nDFv3zb7m8ZVdKDGcgkbSb7a1zzUTZ7R8gwabgr/bMD8hUdmlk8R5cqmkUickY0qcjszTeY/5mm43rUDDkhQSs4MXnNoB2789djxw0Y9xfMZ8A2N+hzcF3zbi3C/qEVDEQedQUKxdCzcKwZ4+OI5/Dlv0A6I9EfQ5bWYEJ8QF3Tn14xPt0rbYhu/2cCL5a+3GCDrkQ62hfDn7yGp0pDzX1DjErCkMUu4pR7iu231v/ZZBQS8lSqJcq7VqTs7Ns8GVqA/Gx1IZ6q9d8iZOdqbngEHIBhs71odQtAt4/edCSVTrtGDXZko9jfsDFmgUInTpmY+9tkMZhTahj490vUZpLy4mECJ2VFyEdAN4AA58mWiTv4R7LCRYjk4g/bgO2+3kCaZHKLuoTJbaBxD9Eo3TXb3/K4UvyFgA8z7iK2SzFZX54XOqgdUUq7VAYOT3Be/KMSuZHfuTZRDB26bZUP9GEFCzWt+f/fY3P8m8vLRjBZ285MTnra1USNvKbUS75wwDbtKtsA9OhjqtrXKMlsibkGi2DG7wIc9Mkd87scXhwBJ+qRWJ1JIduILB202GIQTFK5mPHQiKcn15duMXYf0zO3+Kh2uClLZKVDy/NidErzwDYWJFNNuVag5ChTfy7vQnvg7
 xBmxTy68
 SGmqSYA3xqMlw4FjadoTAKjpLFJT+9Kem5souiKpTntlFvgQPxXj/4WV4HGLn5q2LdPq+71f3Q437HjZK1PTvHI5vN9soPjz841u8l82n7BIr4VVATnyG4idDw3+Q4KwMPbmUU/tzDRgbB8/gLwkxxxoFY7TPOg8s7Ipoe3S7oOlmRPpvfk1HaQMVT3hkyBmuS7xubgUDmvMoCBTIsrzIuRmrlD9e81ghMLgT3wWkF1R5Ff/vD31xUwpAxX70Sk3uwTh2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4ece01897627 ("selftests/damon: add python and drgn-based DAMON
sysfs test") in mm-stable tree introduced sysfs.py that runs drgn for
dumping DAMON status.  When the DAMON status dumping fails for reasons
including drgn uninstalled environment, the test fails without stopping
DAMON.  Following DAMON selftests that assumes DAMON is not running when
they executed therefore fail.  Catch dumping failures and stop DAMON for
that case.

Fixes: 4ece01897627 ("selftests/damon: add python and drgn-based DAMON sysfs test") # mm-stable
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202507220707.9c5d6247-lkp@intel.com
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 4ff99db0d247..dbf6613529bd 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -8,6 +8,10 @@ import subprocess
 import _damon_sysfs
 
 def dump_damon_status_dict(pid):
+    try:
+        subprocess.check_output(['which', 'drgn'], stderr=subprocess.DEVNULL)
+    except:
+        return None, 'drgn not found'
     file_dir = os.path.dirname(os.path.abspath(__file__))
     dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
     rc = subprocess.call(['drgn', dump_script, pid, 'damon_dump_output'],
@@ -31,6 +35,7 @@ def main():
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
+        kdamonds.stop()
         exit(1)
 
     if len(status['contexts']) != 1:

base-commit: 49c3f600a9088332b3c1a6db2dc6f3516f273609
-- 
2.39.5

