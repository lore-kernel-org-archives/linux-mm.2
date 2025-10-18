Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26957CCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 20:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FC38E000C; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0318E0005; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E917F8E000C; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2FD08E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 990DDB976C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84012414150.02.825410A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id F2B4E40006
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DqXsi/52";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760820294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fGswHs4wCBl2js1Cre7LHKEiFNTXOwcN2RxTS9P0iP8=;
	b=HKFNlRJY5umdLhQLeGBlBh+qBHmB8AJmVHJuhJtA35LG6jNqgRzR7irBn2Ibn9Seu4a4BU
	eJB33/eaCG6ABoo4kT8f9GN918Z8fq6aWb9arJYp0zi14/RcH5RHarF110PoI+lfhkJhG+
	kyJLiDJMI8tYTBqT/Edb2jeMrEm54b4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760820294; a=rsa-sha256;
	cv=none;
	b=fbiS96M5uF5PPPoJCZ9saj0Di1VioIKca6EQJhKCHIZI09Ziul+LrIHqvkFr0lskBNcqs1
	bisrx07PnkUlbgbyKaN/FjGBiJR7OFikx+eKnohYhAD6sxwAzekcz/1cUuEJBPWhWOdrbS
	TJoTOPUFGM/P/jBCHHRVAJ3yBxklTsg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DqXsi/52";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2BD9453FD;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D96FC4CEFE;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760820292;
	bh=S4lW4Yt0S7MkHRb5GuM0MpYSg8IJozn8ecS6DJPFv08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqXsi/52g5a5C4pINsXt4g4P/sejZ00AhNJflJ/NDCRkGGHM6Wo1b4RBxlcaJU3mp
	 3Qzyq8DIZRrbii3iw7BY/KyIObXLJtaRZ3zSV9gltUis/hoWGq2Ixan/X8kidTGNjX
	 Ez4IRFb4PzV5170Fs0vN/yWoglJJgf8x5Lzh2aLgHxcgtTm0OSJ2nlH4cNo8sPyZog
	 p6V3+s3CYVt/dr4+x8XMe2BarNkBFCQuv53m6pSc0yVbkur2G+dLxGhB5l0jH1FHSd
	 SZfIB/dJiMA6QYK7p+hvcUTaoL1VFxceXBC25QoJlFEEqo+nrNpZuKhLFLCI+LW2u9
	 zHPEz7x7FxxoQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] selftests/damon/_damon_sysfs: support obsolete_target file
Date: Sat, 18 Oct 2025 13:44:42 -0700
Message-ID: <20251018204448.8906-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251018204448.8906-1-sj@kernel.org>
References: <20251018204448.8906-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F2B4E40006
X-Rspamd-Server: rspam02
X-Stat-Signature: 67i41yomdtrgssw3fgscpxihpgqwzof6
X-HE-Tag: 1760820293-512354
X-HE-Meta: U2FsdGVkX185+lwKqDQ7hwJucljeKepyjB6V06cMCKW207NK1QDCECCF1FVpZ2Jd2DsyrFUkupnyk9nWhn0vTu8CghD04Lly8i2nIMXM28ZNBEyXfRFi6XmCaUfnaWqQ5ilqQJIKBr0vF67LvShGGA8pTliYGnrw4GnLt8XUTVFxYxe9zaCu8S78n+gzt8/VrGxnHJVneux9XxwySJS+KjTm3UQbTPV5mQaAooOqxM3G2ELScCEE+79eXoJABqPb7E4puGNR9dM6kAzWYnjt/fn0aAwqvmDa/xkd06srtE/gaAwRIWI8hHe2S+k4uMhecF7ivW+xx5qPwRMVzm6s7GMhRqkjJcs2TZLowwxWXie/8uUrsrYMzE+tXZKZR7gKSHQfu57dQKfXGS3hrPASN+KczZHGca0TmlWvQ6tc45fEz5RHpurtcSIg+yn+spNGgkp0k/MKAQAnRvdhuXJNopYmhCbguPOMe/kFGodiXKkS3DOHUEjFJWymlGdXDCflndFGVWkIEo9VjKMpS9jskkYFcI8MZFpuukoeoUUibZbEHTqe6hhyzLcZRoLKNajmfWGyl3HYnDOFeOlAdgunNCnMoX/73Wq7MgZQPK+avht0i5Jw1Qksp6eMIfPq5ckqNp90+9mcZMCJD0kDd47EfO4r+18IXo75A1h9BB/RfyLjExlXRw8aHf/DMZZ18bFiPPf0zAgX6S7oAK37I5Hf45AjwR/YqwlG9bh5wKUZBxr/6xUG7z6verBTJtkAvr4UVwkYme5m7V+tGM4JfQc0QdOoNwXM1V9yk0sppf1tK9ju/3i0JCEkAOfOlTQKVrm3XuEXvLilsHExRBnKjTmaseplmxPmaDyR96h8CTHvRd1jUgpulj5YZtJchX/aQSJKgML7Rpqx9ORE6oB/WcIvnRVQH8ZgS7M1l3MNNCrOIGklFM9k738CZ0oFecMCYKxd5hrSid43DogUler0YqN
 7twAWcrn
 0X6gnndEFbRIqaBBXTUB9XwXHTZVVbfNWHw9uJAN5G7/nZbwwLac4fAlY+YVy/H2nRXCC+AjTR+yoyaJfQxToutnG4l+tF6NSAnRpSdDPSs4c2x0POb3t8kBis8YQcaC5vbHAojz4OXqMAOFthe5zLKtTwrFY7mDk80pLGyS6/00IuAqazmhNZW1fQP/PNtC9uZ9hKfLCwhavN4lQDJ/SsAyPsmZuzwKbpdBEICN/iRRfS9WWFTR5wXtOz+lp02J1TwPYT9RUIz0EGoEhEF0zlMYhJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A DAMON sysfs file, namely obsolete_target, has newly introduced.  Add a
support of that file to _damon_sysfs.py so that DAMON selftests for the
file can be easily written.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index a0e6290833fb..748778b563cd 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -475,12 +475,14 @@ class Damos:
 
 class DamonTarget:
     pid = None
+    obsolete = None
     # todo: Support target regions if test is made
     idx = None
     context = None
 
-    def __init__(self, pid):
+    def __init__(self, pid, obsolete=False):
         self.pid = pid
+        self.obsolete = obsolete
 
     def sysfs_dir(self):
         return os.path.join(
@@ -491,8 +493,13 @@ class DamonTarget:
                 os.path.join(self.sysfs_dir(), 'regions', 'nr_regions'), '0')
         if err is not None:
             return err
-        return write_file(
+        err = write_file(
                 os.path.join(self.sysfs_dir(), 'pid_target'), self.pid)
+        if err is not None:
+            return err
+        return write_file(
+                os.path.join(self.sysfs_dir(), 'obsolete_target'),
+                'Y' if self.obsolete else 'N')
 
 class IntervalsGoal:
     access_bp = None
-- 
2.47.3

