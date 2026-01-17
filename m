Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3AEC9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290A86B0089; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0BF6B0093; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DBE06B0092; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E62116B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B24E28B33A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:42 +0000 (UTC)
X-FDA: 84339819564.21.AD6AFD2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 018A51C0008
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cFgHni2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615661; a=rsa-sha256;
	cv=none;
	b=cJ8HWx0MeR8kuA3VCNs9dH45He4liS+4/t/ZRlNn91AqLUwIoxLBFEuLOg4YQGY0crpf8u
	eiZI4oJ7F28rKE0+A0Gz3dG6Qf3nPkpVyIcxJHrh+uyn+39Md7ePg25Rd+PTXfZ7z7VlDf
	mzY449oKGhl88if4wg9nieRGTIm429Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cFgHni2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNvwG1oDFuW7bfbcByS/X6ePSqZS60WGsO1ZvqCn5DU=;
	b=gJXhbRRgE7/PpcKb4w6ZTAKUSMIhDepJc9dmsAO2tAnTnYIxo3J7zOCljtzRMBE0Uyzjtc
	gv02sL6CqLiRe//G0qp//geEufKN9mI4ymu45CCu6SLpZAUZce+yxX5Ax50HPgyHEORpAH
	GIvAYxJPj7lhrZiET7JKE2/xtwdqn4U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD97844253;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8446FC19423;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615659;
	bh=hotNE+mkKLh4E3ZrIzL4sCf5Wg0MeE2kOyjLK5ej2kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFgHni2fBFLxaEC3ayWzPAfAqtL435n6RT3GbJ0EFn8rFi4YlLAGRb1zj2eThEYIv
	 keP/Y2hkwZwDxdmIWSPhk7LmY6CV+10esWPRC8JdsFlRygYvZp7mrDrZp+fbz8dg5q
	 L9O+dBYohuLOvUdmylv+vu9ZSD1uz7qvyWQr3oBhWPZp/ttNabXHq/oKmeOsyxtBPA
	 kdUWTZyD/isx884RtprXEYVzvhSJ2HDzoAhxahNsCrgxOhFF0s5WhC8lv/akPZRmRw
	 3eNPqeo94qInMmFaEAOgCejOGLYAKLL9j8NRbUIZ2SFngRMpnsH9mEUOX0Ume6hO/W
	 YAvd4WjwQ20EQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] selftests/damon/wss_estimation: test for up to 160 MiB working set size
Date: Fri, 16 Jan 2026 18:07:25 -0800
Message-ID: <20260117020731.226785-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117020731.226785-1-sj@kernel.org>
References: <20260117020731.226785-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 018A51C0008
X-Stat-Signature: 6si1knfyz953gzy6ootfnjk4k8zcje8z
X-Rspam-User: 
X-HE-Tag: 1768615660-501751
X-HE-Meta: U2FsdGVkX1+3FsYL+LFIA7vuY4U00551BPl1RHi+JbbZ26s825fbVamU3JYdY7bQFGHC9Yx47P6vxMEIpiv9qbLS7mgnpcSjZaKSgDXrsloAzSKgpJH+eqHK2Uqj5IPcCHu5rNwEH9N3kAm+AUQF04lb+6q+SRow9djqeGaWd8kP9xa+kO7/Sr6/Qt/iLE6VBa0orW529F2eDBrlwJkRlXZ5mnbIADqkywkdtA2jzNJsAhH5xix3Dx8XVG7WeaanSaqfKlGpMsiIvjRSvg9juGkB7jwaY6jcN5aOk0n0suUKlr4ch4WzEfePQpuv9MMwkGGGTU4wfkmTOm+Xp7Jyo879prBjaJw5f+LqodT0JRXg+4U0ius9lNcezU1fyRUz7kLqvk/PNIyh8jyxOkJ+9JRL6cRrB6tBcD2qMQ0Dy7u/I5FPU0yknFKxWu9vdF/tc33GWA1LfRZTkHcVFMSHTfwUc12ieQUMK8R1MMfmy+ceIfnZDdBRzx1PjEY1rQX45/pGEU2qZbsiCpgFv77FOybVeSRjMuF/PfK4rWIOQfw6dc7pNkXhXvVAZxSQ9wgZDXmvWeekC96eXa2oMRfZx67Zw2nx8bHrg9IInBhyRCs3Cs5Q3ECxT1EmlC/VtV5US5DaPxPNdrb/bZzawED/+1pYAJr5jxw0u8xZ9APXVsEzSoyLueyFGZzXNtIvzS307lB3AiW0H0woOdw+Vu24dREqViL50wmwrOjMsDX9pMLsfWuaLMK3jzRmT7gAseTd3upJ5/olQz/ErqLIoNCL/X8O928oJEWkJMRUxeuyfwTYsCBb+v1FZW9omiSHI7+7Yxw/H6x38t+moISc7XzaPWFBuNHIf5l4YUaZf4AdHDIPdOlmEFvAz2P3/WjzPgTv7leh5uKGw1oCy2d6f2yX5KcWu4kjRUtr35a6XzZ7D2XdEbZeooTtwUIAafvEUUNawQmf5nmAQHlRv+AGTDm
 ts2mDWc+
 GcYFoY7IW3H2G793R+MAt1vdGSegkisSLAT5H//fwLs5zu6603Zcx9rdA0uK2luvWZ0DhLUSRU8zAv5obWBHIoah8qr9DVJw3Ce3nE/479Y8ITPS0CisWBDKN4GDiQZWQ5MZBeRtsUebPsfYu2k2tbMlh1NpZKCFnQrkkn/sj2CLh25c12oMJ3yNaQWqa2gjsM7Kav+dxZw4a4Czs9qlTPtv61CuEEg0YRHNJSXw5xs6I2htYsuYHtotFOkRhc+6sxfU0kr1yrzA6z9rLogsLpAAXGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON reads and writes Accessed bits of page tables without manual TLB
flush for two reasons.  First, it minimizes the overhead.  Second, real
systems that need DAMON are expected to be memory intensive enough to
cause periodic TLB flushes.  For test setups that use small test
workloads, however, the system's TLB could be big enough to cover whole
or most accesses of the test workload.  In this case, no page table walk
happens and DAMON cannot show any access from the test workload.

The test workload for DAMON's working set size estimation selftest is
such a case.  It accesses only 10 MiB working set, and it turned out
there are test setups that have TLBs large enough to cover the 10 MiB
data accesses.  As a result, the test fails depending on the test
machine.

Make it more reliable by trying larger working sets up to 160 MiB when
it fails.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 ...te_schemes_tried_regions_wss_estimation.py | 29 +++++++++++++++----
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
index 90ad7409a7a6..bf48ef8e5241 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -6,9 +6,8 @@ import time
 
 import _damon_sysfs
 
-def main():
-    # access two 10 MiB memory regions, 2 second per each
-    sz_region = 10 * 1024 * 1024
+def pass_wss_estimation(sz_region):
+    # access two regions of given size, 2 seocnds per each region
     proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
@@ -36,20 +35,38 @@ def main():
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    err = kdamonds.stop()
+    if err is not None:
+        print('kdamond stop failed: %s' % err)
+        exit(1)
 
     wss_collected.sort()
     acceptable_error_rate = 0.2
     for percentile in [50, 75]:
         sample = wss_collected[int(len(wss_collected) * percentile / 100)]
         error_rate = abs(sample - sz_region) / sz_region
-        print('%d-th percentile (%d) error %f' %
-                (percentile, sample, error_rate))
+        print('%d-th percentile error %f (expect %d, result %d)' %
+                (percentile, error_rate, sz_region, sample))
         if error_rate > acceptable_error_rate:
             print('the error rate is not acceptable (> %f)' %
                     acceptable_error_rate)
             print('samples are as below')
             print('\n'.join(['%d' % wss for wss in wss_collected]))
-            exit(1)
+            return False
+    return True
+
+def main():
+    # DAMON doesn't flush TLB.  If the system has large TLB that can cover
+    # whole test working set, DAMON cannot see the access.  Test up to 160 MiB
+    # test working set.
+    sz_region_mb = 10
+    max_sz_region_mb = 160
+    while sz_region_mb <= max_sz_region_mb:
+        test_pass = pass_wss_estimation(sz_region_mb * 1024 * 1024)
+        if test_pass is True:
+            exit(0)
+        sz_region_mb *= 2
+    exit(1)
 
 if __name__ == '__main__':
     main()
-- 
2.47.3

