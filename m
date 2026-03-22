Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86938FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FF76B009D; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0CE6B009E; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77566B009F; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FC946B009D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CC091A051E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:43 +0000 (UTC)
X-FDA: 84574154406.28.8863CAB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCF33C0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQRMJZzA;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cu7/54W1rf5l/uMh04ouLRAIQu4QS7pm0tvyYymTjtE=;
	b=4rmmjRirwRXmkoxuMeuN9yeFl+hltunW8VuezJ480BywZegQRsMHmD99YNCE/oQ8Ps9y2A
	EW2odxXZEjx4YXMEdtV5E7EhZE7akK/tTSOV2FN1eMaz5w/tr7NH7yPEfiT28t1ZFdMBk9
	N2gIk6YKTMEz2zKbE9jLwxW3RkTti1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195061; a=rsa-sha256;
	cv=none;
	b=4WtTDS/Gg0ysZb3y2gmsSVTadoLk/rY9asYkG4ncCrHrG8XXSCE3Dxc9o+tiSfG+kT5uQZ
	TnVoZBJYilkoP9rOHB6KA0adM9V+Lr8rdtfKl+4wZ3MxpbMNzThYR6zWmrBhN6rsdmz+Yj
	Pm+EJBV76z1maYt8wlrpbMU0hZCEPXM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQRMJZzA;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0164445BF
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C550C2BCC4;
	Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195060;
	bh=dT0Co/dTQSMuQWLCRwci5Vw0M3Z0t6s+AmNwdu4waoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQRMJZzAgy5OgtrWB6C6XjwLHceTrAXQUqzUppUpdMEfG2oSL//F9gE4sFVPETCwo
	 wN1trbWGzeNMRD5Mw4+ex1fMDCn9SeDSP2Vh49gb3yAtuRmWkM+qZD5BjnuxpseAcB
	 43n+HtbZDDBSVXWeh3oZEzWCLy58ld0+8hX2ybPAAn47tw1YbPRXHDjPqQO5mBQO81
	 k9auOr/SF6gKBbjyq55E0y9i8mLUAbN5hLBiWMd7JJmLAuGuoM9/ywtWolInx7yhaK
	 Bq3LB6hl0Dom9/8AFF5KM7i6LVj7bTBBujloM32/UPP56cO/lrv92FE9BtgNt3ukQS
	 09cuQUksGreAQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sun, 22 Mar 2026 08:57:24 -0700
Message-ID: <20260322155728.81434-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fn7chxu3mtdxqg9getg17w4hzgyfqk5p
X-Rspam-User: 
X-Rspamd-Queue-Id: BCF33C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1774195061-616397
X-HE-Meta: U2FsdGVkX18CFY/P8iCogoqppTUT6ws6xCkYcRtsK+InNBBAjo2BDOvItsMtM5MXyCo4kcUmcqRjcPQALpksV0QP61falH/tl/Dleq5cNFW0iTbZa+zswb3NxtUIwO4ri1PPuqzESN0j0/8POtJTerbzOywKRy+v6oPPQhDwqSgseb7ns66aXN7x/gdOnOlpzxYz1RZ+gaTn/CwybPKjDT6FX+SM7ThEE6iPXlXCNn2ETCW574fsSbqxKAp6b2VMLSXYE4ktG5KceG0vE4wze1sm0cUD+Uy6cI7YgQQHSMOduvM+sNWnoRNLNpCXSuuJtcBT/cAAcbXCvjbZ6D3zIZ0nraNZrjjYxZq+Uo1dLcchz4Y5mi0w3Z0VIwDiWp4z+RGfExfuICXMXIkBu9vv0X6H5Brni/GP1ooggHIkdQsG2ZJOATKqtKAahPUqNnSwAKCTcUiRVGWDHjiWj+cnVBJaMferFJBA/PdUREN8i90ZAb9YZiYWeeYvIrBlGTpixJ0hJp1XW6+N8xLwHggMzIUidWCNgspSQhBidUCWz7uMm5sS0CqzxAT5aFlGdoVXb/ftIARhdusUQHpW5rzLriGRUo48hvCCNWraa9JQ+TKEEVCkW29IgxyTKMTtZ3Vw1eGff5vksxaEwYHNeb8DtX4BHRm6dTcx3RgyZofJv0p+tYh9SviMKWS6pKCMouKaia1xiDM52NQP5vN4uYRPZ+kqHQ7jJh1YE1wSe2TGyAqZ61jty2HnSxYZMQ6vPDb10Go4fTMZZ/z6jAqZF84Z5OofOIBohYyDom9p7gHJLVGFVLcZi6nmzAn8xAQaHZsE3mP9DEXxJXs/+l8HDXFQK0Nz/V6Xe+wg0r2W4gka/GWQFGq5fteyBY3+tIcj9qeFyPJrXxkzWDiPYyoIQjIV2XSS1hh2utzOpvqKl3oB9Pix0imUFHgMt3Yg53oAuxO1oxpuO4RO62iMuTjYRjO
 inLUwEZt
 uqySybV9MideJ5h+17dIPXPWxHw2Oggfl6yzMp5KcFJpXYnchvkHxzYL7bsmKVC0nZsmx6r0lKSVwTyi5gf/FNgbx7tQn+JBLExlGycaxGw3COxuSiRk1fXJZJumR/wscs+GoQCsFIiU7kOWEOtth4b2LvF43T8ehH55nz0sof1pB2y7OfNNzy+2nTF+oPGTwL8pry1BIm5lFEk8zRJ4nVxkdEdDre1bAgudfIXQMwZgo8Blc6p1kPdGIdrWu9Adl68DLq7wI+qiNGylBLan3rk6hA4oo2eQQ6p27rAfB73K6dTw=
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
 tools/testing/selftests/damon/sysfs.py | 38 ++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index e6d34ba05893f..5f00e97f019f4 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -193,18 +193,55 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
+    ctxs_paused_for_dump = []
+    kdamonds_paused_for_dump = []
+    # pause for safe state dumping
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx.pause is False:
+                ctx.pause = True
+                ctxs_paused_for_dump.append(ctx)
+                if not kd in kdamonds_paused_for_dump:
+                    kdamonds_paused_for_dump.append(kd)
+        if kd in kdamonds_paused_for_dump:
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
+    for ctx in ctxs_paused_for_dump:
+        ctx.pause = False
+    if kd in kdamonds_paused_for_dump:
+        err = kd.commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
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
@@ -302,6 +339,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

