Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8D5109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733B66B0117; Sat, 21 Mar 2026 14:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706296B0119; Sat, 21 Mar 2026 14:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6204B6B0117; Sat, 21 Mar 2026 14:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 502A96B0117
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 144A2C2125
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:59 +0000 (UTC)
X-FDA: 84570868998.05.67F86AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CCC9180002
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5ZylUjd;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vHReJORHqTOZdKsksMkya0ECCA7PzeqJQBiQA6V/q10=;
	b=V6AtTKXJsVLW8jO4dKvDvCqEOH6tTN3/n1F6C9RE6fGLH7RQLZETiJ0fXXf6P9HbNimY5i
	2RazoAtgTQdzQJLr8knaNe9kLK2fzYdsVoR/yZZvNu/LYOGRDDq8kHDnvdISCq8tdTJ3Pv
	tzPHo5KTBc9B6zWoS00OmwMii4tt8Xk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e5ZylUjd;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116837; a=rsa-sha256;
	cv=none;
	b=fVouZbqqDiRUIrXfJ5W1tdUl4VPXf2nGpMRV5dNIpnXK+3pYYun0aif3KH+NM3gu7lt4Eq
	5ChxtkkNvPdYCys1sZObiXLlodFKijmapC0znKG1wfVEbP6TpHfhczyhnRh0GhgIi4dn/a
	00775LSUAnodGx++drVTFFs1BjY3YEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACF6644553;
	Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778C1C2BCB0;
	Sat, 21 Mar 2026 18:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116835;
	bh=8CAJmnXM5hTXIdgeoG4mgBlgGTWslXDeLQsPkAPObfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5ZylUjdQnzbpGn66thpuzFmsjx7QgL20spJw599mPYV8WT0+08p4aHAJD1dceRzS
	 PtatTga0LmJOVq9Yma+gQitzw+wqrPKva24yEhdNfArY042ApfJSvy5lS3s6uiqWD+
	 psUh1QbKT+1MEhcq51OADY6WPrHrBoCSscYfW4IuP3+xIHTzy1uHQee5swAxGxLU8o
	 BX+0GiqvmuC5fyY68ZtcK0H6cgknfvipezkmLWtDoI0Dawf9PIToQQZT2V6l5SG7Q/
	 Qnu6rM9hXthl88sD9pEV8ER7+rTkw0FyYoW2j+hXI44uFKoXVomKcpgdhUAl2VUdy1
	 Rimoocr2YTtEQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sat, 21 Mar 2026 11:13:40 -0700
Message-ID: <20260321181343.93971-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CCC9180002
X-Rspamd-Server: rspam08
X-Stat-Signature: p6py8qciq6n9mdwg79wa9crohok59sgq
X-HE-Tag: 1774116837-105068
X-HE-Meta: U2FsdGVkX1/ZH8ccZkd4HLxEPT2qONExMDSCCbNIhMM4yiN9/tygfPHWYqsMiXIMI+j7SZlA7Pn2V/TmyxcYVQ61Iimr1zPZEMDk2TqX70D7+gguNb1rUOaTZgCVu4HF1ouNJQuqcG+cNq3B5b0xBFBV9wWm3u2VkSw7g9MQtz1XgFogMHjv5JsjuMkyMGVN/Q0B1ppavxR91uk0bAZL9xPmFkV20ufvd4Las2BdHYPuZsItJnaRcrf2sRU2D33nmhENYVaXHGMEhwnmQnpN4blqCGomkLbOfTH+v5sJberAfyvgarAcxjL6lr93TzTtSRk+DFLWR8rU1k17qOO/nNKYca6QwYnjdmkwGgOTa/cKADtuAoaS9mNxKAftISuchHZUAElBlWhUFKUofwiquch7z95scHnW2dsFBFqunAtocmwPhdODlkmZf9Cxqpbskac3/jSDY1/g7TRUiUg/+iczI+Hp09j2NZE0TZdqyJ/efn2YJOn2cEsa4wQNo1I0Uy67I6/FVc/hkZ8+5tYmm6mpR5fSTuHPTlhbBoA3055o5JpUQB8n1uQm6+KbKw7gp5+0cjQ/JkQV3RUA2DdgGZK0l96IV//H5T2xILsalCHTxi8FBrY+LZDc+lo8OpIROdfapWkOu3jx3EHJuSQu+JLHQxITQ6xCgrd+2x9aobgGKICML75boA6jgjmE4gwcxYw32IMyEgP+fo0c44TbkyESb17C00q6b01aR9ODo78dUsROO4w7i6Qn1S1rfbz4XSozSbs/eoEY+hKAXok+Fvk2YawoJ+ZtJostnJ8NiUJwLRoc2pq8W7SjVVA3XYTrDm3tQwhxZe/PbxLPsyDEkpVwKUeHOR7WvaKICQ+Jh/+4iPhnuINAWyOFNGZPCbK+scowWcrfFoUC8yM9mZ+zP7ykDvgNXq0tZodjLyBPAsxlXYZVlAesrdK2s3H0OkwYs0LOfUvkxfu4QpOkB5A
 jaB0u4EM
 oSB8r7jzkPK9Sxf954VMEG/1hllkcsyxh/jV8rpj801iC/sx2ns7i6zJpuv7/UWht/dwvtz/0Ruqi5PPQF09eQQWTYW9RnZ0MSZm3ZXA2JLwWviT3KtI0tpPjgL7Sl1KUl6fjhwXZGtDGwKSZNQtD926dBnavfQaAnUiktDXJeLbZdcAI/0ArFG1EoYusno/MbHiObrjqPGd5iy7XXsg4646WoHfbtCIYfr4Wgd29FgQm4CY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs.py test commits DAMON parameters, dump the internal DAMON
state, and show if the parameters are committed as expected using the
dumped state.  While the dumping is ongoing, DAMON is alive.  It can
make internal changes including addition and removal of regions.  It can
therefore make a race that can result in false test results.  Pause
DAMON execution during the state dumping to avoid such races.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 36 ++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index e6d34ba05893f..7a4cd915d5bc9 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -193,18 +193,53 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
+    ctxs_paused_for_dump = []
+    # pause for safe state dumping
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx.pause is False:
+                ctx.pause = True
+                ctxs_paused_for_dump.append(ctx)
+        if len(ctxs_paused_for_dump) > 0:
+            err = kd.commit()
+            if err is not None:
+                print('pause fail (%s)' % err)
+                kdamonds.stop()
+                exit(1)
+
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
         kdamonds.stop()
         exit(1)
 
+    # resume contexts paused for safe state dumping
+    for kd in kdamonds.kdamonds:
+        for ctx in ctxs_paused_for_dump:
+            ctx.pause = False
+        if len(ctxs_paused_for_dump) > 0:
+            err = kd.commit()
+            if err is not None:
+                print('resume fail (%s)' % err)
+                kdamonds.stop()
+                exit(1)
+
+    # restore for comparison
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = True
+
     ctxs = kdamonds.kdamonds[0].contexts
     dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
 
+    # restore for the caller
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx in ctxs_paused_for_dump:
+                ctx.pause = False
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -302,6 +337,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

