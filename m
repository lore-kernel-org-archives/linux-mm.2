Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 722DB1088E7F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E89E6B03F0; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975756B03F3; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724666B03F0; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 564106B03F1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3432583AC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:12 +0000 (UTC)
X-FDA: 84561666504.14.A94FD8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45B1BC0006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLE1gPG+;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuYArKm7FGA11Ug5lCttUISANPUQJu09ocnA7gmRt/I=;
	b=tYAt/LmziiYeT0Nr+UkWoBF5LW5o92A4g9tlw/I1iwNPQFBPCOmXu1T/RxiIJSIIyz7sEZ
	nY4OdhrrnWNYviftGqTGSGa0GF4RiF4TGxrEDEeZPjIgFuSB5NBC0C3KYJG7J7uUHdykIU
	6Jo7z4Rh2IYVJdEwaG+6cKeOfvW6aeI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLE1gPG+;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897731; a=rsa-sha256;
	cv=none;
	b=30WLkyWM/rUWZSD4Qhr78K+F5I/Hsida+e7dyB5pQgCrxZ56S+hWtBi3VhkKghARm5eoI0
	9sy1+evqsfzfYYiRz7YYCS5tCknenRWuVq+Q5VGcSGI4t3Ba5g0KzRuw9RGZsDky4mp5e8
	DnIuDLdjDbIIsSZNaaP93oXX/N4aixc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD46742DF6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2B2C2BCB1;
	Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897729;
	bh=gKzlHjNwVy7/eu8xZ7uHLGZKBMO4b6mmZ9XNI0j6RLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLE1gPG+Hya7//RWaiPAEKxtepx386lQ0Cm8RdvkucYG+iOXOFeZPuszuRWKmhmqY
	 Hlxm5qQmMgd/Efqo63G8l2SuLp2Bxr4GnzCPV7S+DNGqdG8Q89JJ+QMbBAMNdzoeIK
	 OzXL+h+ya25rpojtJ7Hg/DmBKzOkdSFMuw7s2gKefp9JqRLIUXm7mTtbh2QiioYEka
	 4gWS9afrhZHM7PFTk3oiT+rnkAAeDLRe6Ix7R7uS3YviH0REcZaLVT1Z/Ug7VkjHEa
	 01/5O4fI4zM/Io7soEAT3UH61w2LoEMW0vljBhU7MvbGN30cHB29E8t3vNMLgsG97M
	 tr4+UyLCjhRDg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Wed, 18 Mar 2026 22:21:53 -0700
Message-ID: <20260319052157.99433-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45B1BC0006
X-Rspamd-Server: rspam07
X-Stat-Signature: x6jw5yhbnuz3p79snoi3dhpkfzu4ct1s
X-Rspam-User: 
X-HE-Tag: 1773897731-970004
X-HE-Meta: U2FsdGVkX18XTNU1O4tFd6f7Pagq892yS48L+DsxgNkbihdq/PAntYZHH+wKn7BIiVG4VEgFe1mdMQ3oocD8t3gTQCFMY6eEocfMefABG5z5mK5sbHxPLSQddxcc3Si/fVjb3nRJN48OSnOFy8pnTc5SkiiVRasTcWxh6u4Gt9gAcxbkqMtJPvGnlwUmabHoa55pc1K4i2WenlosduSHHkjLrilY/HRsD75bspsuHqqFXqfExlf5bwTpgYxNM/tiNxYhCr7P7fLGgfjybEqX3zBzHahi64rizRFqahsIB4Xz43JRYwmBJCo5ZkhgM2NB5z+cBQ/g5ugpVuGHmvbBctMPKWJo0LpCQRITQ9UdNKLiH5OGSiuSMyhSy+5PmiWvWbGqvNJDDkutsLJZ5f5HGPpZvt++XysLbY06aSRKmlZqgq9vgXHN4ETDOobvEEyAOv7BfIpOYweoz9UH1RN96ukHck4+tKVKq4RacXOeHXFreoKQg+rQggLjpaa3v4S7necuwnY8+/bJcwe8PaycoGWARrkOzE7e01wkcLijqSPgncsYrMNd/114bNMuw39ih11PCkDhq1Kppr/dhr55hFM0dQYrrr0n9un2o5pGwmuKjCFEWKODZd7U3VKUftbulIDmB33NXMAUCcu6JJ6FXegglgi5QEIeXv6vFneQPGT1PIDBFT3xJlqVciooIhBGJ6PLoDVkAGq3q/VnUWkqM7aoFSwmx21X3uDNOAk5ag4iuTp9g3FBWwjEdMJKBRz6eFvIe+l+7/BxRlGBX+RAC/DEPyD/tRiQIwwdtz1x4288eNtN2/bVNR5lJAtM3FlXAk/6ywwnvRriJ5x984NM3yV88qFbk5REkcddHFOVF+OZsUWX90nZ+qKQSV7BxRXExmUXZQ6AnVLAP2zVVWNFvlE8wciTJBGn9gNGSBN/8iDhaT+G/j3FbMWk82dxUgp90dvyK6ptdtRdkfbn2NM
 s1Ene1KW
 BdmO+aBg6HCF9emP9ZCEJrHh81Mqb6kdUfsZLkYGzjpzzAp7iWc7Um031ntHYcrpMskLo5RTwNh5Zrcl9aSNPiEGlZlO6C4NnhjqVW2pxdlR8aMTr+Dsg1uCWtJglOaBaJCmuERabwxkLHarxXtiIjBXRmNN48JS1dgkdb/Sz8fsP8T8IaFlnC6mn82DYxPLhjP9qS9X4zpjEDHV9B4CuVYrU2E+T9DNHujIFvHVwsY0h+ohh+x91zaN3qpUco7J6k6CHNrbXpMnd829tb4muQr88pnMOEcR6Cn02jnmM/iWlCr8=
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
 tools/testing/selftests/damon/sysfs.py | 31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index e6d34ba05893f..704729c7a318e 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -193,18 +193,48 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
+    ctxs_paused_for_dump = []
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx.pause is False:
+                ctx.pause = True
+                err = kd.commit()
+                if err is not None:
+                    print('pause fail (%s)' % err)
+                    kdamonds.stop()
+                    exit(1)
+                ctxs_paused_for_dump.append(ctx)
+
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
         kdamonds.stop()
         exit(1)
 
+    for kd in kdamonds.kdamonds:
+        for ctx in kd.contexts:
+            if ctx in ctxs_paused_for_dump:
+                ctx.pause = False
+                err = kd.commit()
+                if err is not None:
+                    print('resume fail (%s)' % err)
+                    kdamonds.stop()
+                    exit(1)
+                # restore for comparison
+                ctx.pause = True
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
@@ -302,6 +332,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

