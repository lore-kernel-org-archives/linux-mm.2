Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D726109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A826B0113; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A206B0118; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8033D6B0114; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 632F96B0114
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2666B8C034
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:58 +0000 (UTC)
X-FDA: 84570868956.02.2055B3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 773A71C0010
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sT2FwYha;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=V5r0edOKQ6DydlBYIiGFElQ7T7JWkNTcl5ju4TVWQPe7SiUeuazn7G6wgWXpolJT4S3EV5
	19NE4g8L7INXGHDHduSp10HUxOH0fWYFaQXWhzvTcP/BI/mz9hlyXRMsE3Cz61EEapl74o
	21pw64AkWPOFgyDA6gxFC/SYBaS38pM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sT2FwYha;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116836; a=rsa-sha256;
	cv=none;
	b=IYzDyqcBRfCgTF6L+m8YWuLQO3u4OjW4wqPK/I86HWWrT4REUPMkGAmfYo5AhlbUl9+PJR
	dBYhOYgvAFp0s62ow9/WyZD8wWSaVx5r3bigdUxloIAWaWMXWxZ4mpAjynxIpZisLIFcyZ
	gORg3oUXOhBCB0EFbiLblsbEvR7B3LI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2F7442A39;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7367C4AF0B;
	Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116834;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sT2FwYha5tiOMbwsOEicRBMnwu3gOCjkbkwjo3CYq6MEfzc4PXwO0GPSbLTv0+/SV
	 XHBdr7za67mbduLwqkL4MtU8KH+Sh3JBu+nV05kpxOy0AdXc3C0y+kVAB/yq6KWbGD
	 SyxqCWh2JylLIXrSffzmE8ujN2QWWVCAp35aEh3MaDmhNV2NNTs2jthjcRX6gqrSVK
	 Sr/HehNOkcVXgc+SpL0JH/ov8dg0LszJo5Uh2Xpyxdbt9ZTCcuXeErzb4P+okUuk5r
	 pBpinHMaRBasek86/kDpHmL1DCCyO1EPgjtqs+b95C2T3rHWgVLj8DgoLtbKOIIRdH
	 vREyyTH2BDzzw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Sat, 21 Mar 2026 11:13:37 -0700
Message-ID: <20260321181343.93971-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 773A71C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: c6an5wgg54oks75oz4qhnptdhwj3hb4r
X-Rspam-User: 
X-HE-Tag: 1774116836-438433
X-HE-Meta: U2FsdGVkX1/VX2OK6fDc64+TgiwmTj0jyN32FAkYoLw6gxefqdP4ZLE4UH/EfZZFafQAYdn73IKHKek7JS+rYAWC06HG//bhYQH8cGWaGFbo9ciuNhGZxzx4ntXoCy8yFNVLn/a1miRV+Y2doIbt4H1pJcFRKvCj2+dX6xmv6ch2LBmp7EaYIRq4X1LZOVhySWHbV/m7uJ18RbNAwk4N/y3nX+/FfN8L5NEQNhShVzoPzvF/9kSSza69kv2o0D34rhv4ZJMr32h8KV5+vXwuS8QSMWr+GThoEApzTy0dWMCp0FR0IMEOUvZr92D6TZhW+4a9/ZAffGnAClzaX5xbf4RO8Up069Iv3JZ0WKhzWdfXfU/FVDWxS1FNzKYqGRH5frVO+kv5bjy/x7iZvWQ5nEcnYpyS8JEDX9d5auAKNdcB/k3+JkU+HZ2C9lIoVnPfoBTf5apPcnEI/YsgCgk+BFAZNAVye5EJIB9P05CTrQW2pJjFOY2bcbz+wNc23sb+7eLXH9uqdYlEVflGBh85WhUq3cDfCQEa9X0kt5g6+vd7UfSASHtGIctosmRYwwp30g01HGy03AlGqV9FDOzIZ0EkWi6KBWTmEreDVX0XoVLkQgGbh3zWJeJ8xQiwO//YMAynFnQvHqc7qCH7I3AHuhAvGx5lOnVp9BghB9bEWhyFSOAhRKZKniBB4oWFXUfL4RRL3dYx7tWOGPX9IBPoKkD5CoeA6CaX9hsksy/7aly5F98DvlCU7t0qOHf1DU0PMCegk/iirjwj3dbw+bnIET7lw+BwnFKOlFHGfkaSN/878bNer/P4lUlIr2R2g/kxQew+/cVD7p6seAXMRrcjUu66snLhslEUwww9xiqseMyatUeQ3pWwyB/aT7FH7JDlxXQMhk5pfB/le+0iDxAmvrXs5Q/eBkLIj/W4oJOElZkSWOnaK7AEB84cuDHp/xaauTm4WZxBWZ1F5r/Vcvh
 EvALnYmT
 mhsGO6xn3iwO1vtIXKykCD/YnoxKylIdq8ZwQ72uM0GskXac8kLmwGj6ZdFXHajd6ZDJxTy1AZl33oiWiPJdqY0Hv3npPkhyRKQfgDxMvoCjhFIp43mlfWWcbAPEQQuzY2kfgd+B1svRhScGYGKR2/LBk6m8UdpmKDH+fZxc6KvAw5he5Pm8C65ZCLtIJHW/zEElNDlj3ApYtcAJYqraTXdOdf99/QkBtg3943yucunLSMU+810HoHL6RdaANPLDMc51q4EkfsvxeXcoJS9SjzzYQzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
is not supporting the newly added pause file.  Add the support of the
file, for future test and use of the feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..120b96ecbd741 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -604,10 +604,11 @@ class DamonCtx:
     targets = None
     schemes = None
     kdamond = None
+    pause = None
     idx = None
 
     def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[]):
+            schemes=[], pause=False):
         self.ops = ops
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
@@ -622,6 +623,8 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+        self.pause=pause
+
     def sysfs_dir(self):
         return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
                 '%d' % self.idx)
@@ -662,6 +665,11 @@ class DamonCtx:
             err = scheme.stage()
             if err is not None:
                 return err
+
+        err = write_file(os.path.join(self.sysfs_dir(), 'pause'), self.pause)
+        if err is not None:
+            return err
+
         return None
 
 class Kdamond:
-- 
2.47.3

