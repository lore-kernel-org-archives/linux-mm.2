Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7E6C9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57A26B008A; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ED66B0089; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72856B0089; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B49F36B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:42 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 764578B0D8
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:42 +0000 (UTC)
X-FDA: 84339819564.13.9EBD09C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id DDFF1100008
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F5G6ObI8;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4JXd2yVY4Bch+GVdGO/1gJALeMgKSCSmJxiLyH/HGVw=;
	b=YSLYq4UqJIB5vR18Na0j7KC67v45mooqCG70Wsf8/2xLbUCqS/33GPYVin87tx4nnLQ1Xr
	zwdKyQGGyd0G6SVZn974e502+XFkFTcW2lUfMcjClryHVLs3nXP2z4AuXI6O3IHUJjB2Bh
	1L193Q1OykSLEaCHJot23eVCZ1RAjvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615660; a=rsa-sha256;
	cv=none;
	b=0xdzgISp3vBgkXFszghrtqTEzJvkqh0scY49Epw0wTGgwF93EyDwGxeteGFFl9rLBsnjY0
	sSe9/Jy9eCjzmFfhegIWqqM5hBWD6Ac6ZDARLg4MZcG2dDFsd3zFH/5nvWa82Bk3DteYAN
	P6VWtx4eYsw/10JEPaoxRPu7tOOUvWM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F5G6ObI8;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E15E60160;
	Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B74C116C6;
	Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615660;
	bh=j53bKE/6kD2pppzUnBcXuqbjxn53YKphj01tk4fSuMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5G6ObI8XH9zVIBydWbJGWRkJcj7D6Ee7V0OYWFvkHPwHMsn84TbbgJ52vGMXtLFe
	 LAdbttivZWioN9Ncr4XwvlVLDJSlc/Hu2iGM3IkcfUM9C4NSlSdJ51Xl60fd+ODUh5
	 TB+9U6Cti9YlJKfNwXE1vELsxPEzJqqaD28UEOsubwOtQ5MIY6H/oqilMRvvQfA4nQ
	 EaCa/gH7/dDyP4eKRpqZ/n5M2YkM051uuSzoGErBm9niuKX1FPs25/2Q2nEkH2VA6x
	 3DbZkyCaZPJe4J5DaZuESWCD+DY1tMP4sLkBa/nAJtflWZAgLSlkY/siTlbMwiy9RH
	 vF1azDzezWe5Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] selftests/damon/wss_estimation: ensure number of collected wss
Date: Fri, 16 Jan 2026 18:07:27 -0800
Message-ID: <20260117020731.226785-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117020731.226785-1-sj@kernel.org>
References: <20260117020731.226785-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DDFF1100008
X-Rspam-User: 
X-Stat-Signature: rjjxwkcdexndqz3oq1isj469omy19376
X-HE-Tag: 1768615660-875406
X-HE-Meta: U2FsdGVkX1+EofEJrw0gZnApAy1VDwFn8SHDOQMBOQUmRBX/tb/CjTekNIZSPj1IIB2o7buIDIX/N4GNGAH/DGqhCpeXvVa1vtBUC9yMb9tB1kyNyI/02LvoGBJLthzpHzeqsQZhXo2pasuo+mAtyJOzBl2ULYw/pJ5BZ933gKbblK1C4s1BpOHrtNr9Eo6ewII+5Tj0mITHEZ+VhBacp4q96Ry4tcQ3q2xANsAsbwBeG9H5iawhi8vSC7+9uUM7PhyX0ntKdZ8Fud+qRY00wdjN6/iK0CRJLRcsNZO4Tg2ZmV856ijq6D3YEBjtpZECRAggjhA4opMgs3YeAd0ALuvNZP7PI8sjTSRy1u7c06akwMfkI7GGB/3lGUszHIjLQKQkC5QDqKBuvz++LgYfFSiRJVl9vCEzX4SsrRPYz0VN4PYFY8RBwKm1Ot+/E7sMR59bAZ0a5n8zbScQ5/oNx/XJralAH4tKY1F0oiIP3Ss43FeKFmH3vlATXfF2P0AwrlWpVEP/0P9h+DzaF3Bax76noegiFKBq78EpBZgx1LUZpnE59t1czsd8WrdzUw0DLAmBGaFL3nr/SGI9ry1s3kbnB5nz2Bf7TXDvmaiBeGSOzkUKh3zAUNmMy6Qm3uraD9doWvKi9X6QAqpT/KsMhXrPUe8Zjyg6hmNnXJlwFlbXAlknWCQ1+EKx3QJ/L0SSAvc4dOfNwhmbQdkKfPBWVV2tSsqfqVI6ev0mbDLez0oZwkn/ELkRA1pDNYdsnkjto72VxM15NhdAe90s5Qae56wnXRxGq6U+oDO6YA1lGW/+QWJh8J8DR26tblEqMna5PYEUiK20VTTubq75kCQR8jT98ak7c8OZZOx7ztOClYC3iXV0B02a09zmw/UGLv835RekoSwgR+VV63k+eIDds3o4Wq6VuonAksXeP4NysY53r871kqmL9a7V3f0QkbrvQ5fCcKPCvMJv8gyXrqD
 4K8ptpwi
 mM9ks1cSrGMDuqC3dlcMgAJ0gvNufJLG7l8NWbaAWcRyjVPDPQYo5MTfeAeTcP2wie5rs4ZV5EiAGjQFPxqEkMEVSrNKot4Vkk4RRjyM8R8VzNAfd3SIpnsmAhyRNxgUjZVtpg8y5b8hkqYkwuH1ATNNL2vXs+yQUJzwUWLxwz7ciMLBBHA5cloKM/dyJ728txGS9Me3KFZwxw7HSzupwqAfnd4EEWWKCoVvEsTtkVo9MUgqxSef8gTO4I0AolZQ5w/IYcqM7OuOQM0SexDSdw1qztg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest for working set size estimation collects DAMON's working
set size measurements of the running artificial memory access generator
program until the program is finished.  Depending on how quickly the
program finishes, and how quickly DAMON starts, the number of collected
working set size measurements may vary, and make the test results
unreliable.  Ensure it collects 40 measurements by using the repeat mode
of the artificial memory access generator program, and finish the
measurements only after the desired number of collections are made.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../sysfs_update_schemes_tried_regions_wss_estimation.py    | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
index bf48ef8e5241..cdccb9f0f855 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -8,7 +8,8 @@ import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
     # access two regions of given size, 2 seocnds per each region
-    proc = subprocess.Popen(['./access_memory', '2', '%d' % sz_region, '2000'])
+    proc = subprocess.Popen(
+            ['./access_memory', '2', '%d' % sz_region, '2000', 'repeat'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
             contexts=[_damon_sysfs.DamonCtx(
                 ops='vaddr',
@@ -26,7 +27,7 @@ def pass_wss_estimation(sz_region):
         exit(1)
 
     wss_collected = []
-    while proc.poll() == None:
+    while proc.poll() is None and len(wss_collected) < 40:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_tried_bytes()
         if err != None:
@@ -35,6 +36,7 @@ def pass_wss_estimation(sz_region):
 
         wss_collected.append(
                 kdamonds.kdamonds[0].contexts[0].schemes[0].tried_bytes)
+    proc.terminate()
     err = kdamonds.stop()
     if err is not None:
         print('kdamond stop failed: %s' % err)
-- 
2.47.3

