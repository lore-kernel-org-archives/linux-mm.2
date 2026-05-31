Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2908FCD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F546B0117; Sun, 31 May 2026 05:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320466B0118; Sun, 31 May 2026 05:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235BC6B0119; Sun, 31 May 2026 05:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 158736B0117
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:18:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E43F1C0737
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:15 +0000 (UTC)
X-FDA: 84827163750.20.01A47E6
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58020180004
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G8EHJ/rD";
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IWyXqkdh8B95Hbx0fw5ujqdH7uVIqVfs8/h+BIpCjW8=;
	b=WqHg/GV0zKNS62N/+umFlzukTmFi2KlwvS2dLix8Vi9kNiMVByiqqSXc0ajFwCZJoyZujR
	FKQUduIiCEY/3cjwvuKk7LJC8uNSU+bnT52eScVQBHA0XWzq9d76PCzk6hRyUReg0WmiVD
	FpXd37IHCQha+pKUu2QERSw6la3xEDE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="G8EHJ/rD";
	spf=pass (imf24.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219094; a=rsa-sha256;
	cv=none;
	b=TFg2uBaBOusXTft5SAQ+kGZbWwx+8IMmcRRv+cHwdq6ZJJMtD82B/vNrMqjLWq/Yv5dK4N
	7nVg+yyVbk4Sa9esvqWdqa6Z8TLrDLeuGZNB79b+q24VAjZo9AMCw8DJvtrPACCM0EKcko
	Lt3CtKkhV1DTAXWTSdvzB4CVk/jIJMQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780219090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IWyXqkdh8B95Hbx0fw5ujqdH7uVIqVfs8/h+BIpCjW8=;
	b=G8EHJ/rD302WYFwKwCeAEHVsN5ajorXot4mN3ifwo62TT10PHAvV0/oOR9JNE8XCYBZpDw
	u5l5vPqec9u24mGpJoGUXj9aPK6YFYp0raryffYs2b3N8sbPeUhRvrDP4vmUYsR8I2eU7U
	Y7yjeyBTUOfIFwNdNrhKrCHw+Azuv60=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH 1/5] selftests/damon: prevent cross-context state pollution in DamonCtx
Date: Sun, 31 May 2026 17:17:20 +0800
Message-ID: <20260531091724.84381-1-kunwu.chan@linux.dev>
In-Reply-To: <20260531085633.48626-1-kunwu.chan@linux.dev>
References: <20260531085633.48626-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dub8fkscpkugxu975bqqf3d8fnc7ffyr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58020180004
X-HE-Tag: 1780219092-623353
X-HE-Meta: U2FsdGVkX19kZp1rBHWeGkgVDqtnxmMUimY0ECl43j5uVTtyhWNyL9Ztu0nQv8fGb23PqiAbWjKgf826ldg24hYdhnnXsjDuTzn7uXEHIxOOgdsGiY5TX2RKkRN+u9g34mn7mfyt2UuM20y4dvX0qFLU9qmJULVd4sB6d64DRq79Ob4JmOX3D0HPquzYM/p5xIPg5Oys4JcOZdLVfni5PG43V5e0EApOjTfseq0dLTxwoByqy1SZxaTxPjfkpH9MhB2pxHdUzCO+3zLxHctXPfvRvpjteVoSZCprU3Qr2XbyquMQDUCq1Sg4Dok07HWTZQs7cGt+JHUatbwp/cTDlop/rWl+u4jzA5B4bNUMhIWQVcIYwCJblT8uCcTlRYchWzJXouUY0lapPemKT87pzrL0YhNNnJ84Ajsn2fCPEBvdKE5xYl5A1DAe7yCmUHS9MlucHW8GpSJ9hoWRqcvhxj53z3DQGSHKahnFrg582wNqnc+blHtV8NVQrdTMTDEdXWoUXW12k20rCZmxvlZ4FIymd0c3DwzQV5iQMlh8iNdaZn/PBw/fuNFEVcVoDKHS1mFUaaGjDoxQPtGu1mqtLYH9XMhZiHqGxj4wlYBpMGeDkAQjM5Cmp2W1/8SnhB9I+zuOxSdKmETD9iTfRikE3+npbAXShVs6ff/2C69CVtuVuQHnEd3LO9USyYVeaDPC2AdRj+l1uWLyCkeAtcCahuqAIDPMn4XQJY/Np5tc/iJvIyQ9uO8eneb7zr7XZS+8Em3sGxKHNgFaJNTuwbgj3PAMEK0MR1qSg6xfEp5MXmm8SPSLyb8kOuWFvEZIsvY5m12l9EicIEe1aXoHdRDNyqCN7I7X5PGpUKA7k+MunVORmZSDNkxALRvE+9ezF+v6MR51Byaiiwe4OBw2rPKBdNkcF5nPyIVpE72ZMoJ5ljFsk4dPxFY9L4uqSVxePgG7bjtOv8ZAdtLkytX8vx9
 7z7Kc8xu
 DbXrJuPC6z6vMov1sajMGN6BMALjr88jjWmb7Xy+/UBQOmGUNEIWkQwwk80JX0b+ZnE78xj2tc2Vv43IHKHeeV4J9MgyQl3EG4O6/3zyTMWVqzO+Eoi80EhY5OFbDPx8s1/gMOmG8h60ECQynoN4gThTSbZ7FjnKI2FbNiiX94Sk77AedcZbO+P8UyhaaZMOgjjxwGT7CHZlXlV5vyN9E8imm4hTHO4WqsQs6n4JLFZ5H8cVomN7ntcEeIBC77GxpqLq4kgAcGuUdrk7mdhiKZpQa2Ej83ur4uo0ZLTE0/UGPcHzIyVF8ramJdTzAv7D4UPvp9nZsUXvEFxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

DamonCtx.__init__() uses mutable default values for
monitoring_attrs, targets, and schemes.  In Python these are
evaluated once at function definition time, so multiple
DamonCtx instances can unintentionally share the same lists
and DamonAttrs instance.

Replace the mutable defaults with None sentinels and
initialize the objects when needed.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc048440..2f6f2699db25 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -624,17 +624,23 @@ class DamonCtx:
     pause = None
     idx = None
 
-    def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[], pause=False):
+    def __init__(self, ops='paddr', monitoring_attrs=None, targets=None,
+            schemes=None, pause=False):
         self.ops = ops
+        if monitoring_attrs is None:
+            monitoring_attrs = DamonAttrs()
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
 
+        if targets is None:
+            targets = []
         self.targets = targets
         for idx, target in enumerate(self.targets):
             target.idx = idx
             target.context = self
 
+        if schemes is None:
+            schemes = []
         self.schemes = schemes
         for idx, scheme in enumerate(self.schemes):
             scheme.idx = idx
-- 
2.43.0


