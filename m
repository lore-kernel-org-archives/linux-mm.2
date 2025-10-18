Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F9A0CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 20:45:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7198E0002; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CBA8E000D; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398AD8E0002; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2532C8E000D
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 16:44:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00EBD11A3FE
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84012414192.13.2EFFA5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 53F9D4000E
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tz4vjciH;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760820294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdvapTStLn3r64HXvMiHpMTOtrAIVsZPEi105Cn0dL4=;
	b=tlrJtm7FdpS4g/5hRxVcJC759LSdC/5q2CoTyII7P2k+A56gp2V7CCglpcaPKB68cdCCeA
	nYKQYYTDj3H/IH6qdRTNOTyCuRHpyMIoUuxhbuU1nsrMTAbpAz+pCRC0qU1mzSdkjYYHGj
	++bvPLdturqqoLG+4dT3yR8x3/OHkG8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tz4vjciH;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760820294; a=rsa-sha256;
	cv=none;
	b=F0KX9likus/+d/lrS7EBxnycP8uE7N69hPc3vcZeKQbsRanc2j1KOzWg90+Wa824X8fcat
	n2wMNI6aqi0UlkDewjohZPnnp9nR2orjY36NCyNpDO1RGs31tAywk+wWL3PNC8VoquYvZb
	7DQ40NVBVNJ0grfQdT9bfAhAr073wuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 715104870C;
	Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35164C116D0;
	Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760820293;
	bh=mizIUChAFsqpIHY6nU9Fx3Ot5p8OeQz4ge3WLnGs1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tz4vjciHPBEgfaX0+unXfY0pbZzsgdubL0xREO960MitKSNo2qjvSeprQbr0KDQDa
	 ppYb90xfdAuxt9ZFBXz7sY6oAPlkEXN3li/QaiuGOqm42LMPxif5zkfCYsy2oXMjqx
	 +Mlc0NS27oc3EM5T3Zr0Vp9JJRWo69rdYMo7RLYvBK1Av71FctMfjRe0jMvEphocwL
	 UETH5IWUq0i4A1qRLJsrHI6M47syyAaAsUjMQDTa+5V3Bl/PFFw2bEA1TgVxPI2LNv
	 JXvdJuDg+nAapHXSGEnkMYIaisS5+hoC20rx2jKjVlA9tnC+4J1wsx5vfD0aFl9rC1
	 xy0HB2Ep75THQ==
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
Subject: [RFC PATCH 4/4] selftests/damon/sysfs: add obsolete_target test
Date: Sat, 18 Oct 2025 13:44:45 -0700
Message-ID: <20251018204448.8906-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251018204448.8906-1-sj@kernel.org>
References: <20251018204448.8906-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53F9D4000E
X-Stat-Signature: tebacpnict9f3bcefpkd7ytijog1h8kr
X-Rspam-User: 
X-HE-Tag: 1760820294-279269
X-HE-Meta: U2FsdGVkX1+UL9cpzpKIkrCaRLjA2EdLHA/NI9txeq/BNhCcjBD99cMdoOh15ZOskx+7fGStumyb25BtN6Tfncy6RYagVWnwF0Wch9CRJRxw6FqGtHoR2YaxUXgfbwjougvP061RsOwXNNganrfaC4zRO7suiiyrG4UWVKXQGm7bS4OdRU2KS98Q5X0UFbmw6mQ/40BM32G6HMcr10EDiwKopeBofCoW8n34VWQ5wPv84QcKqrnuT/4w+JNt6/xi4NllrgvD5Ula5RslafmOMWh7Qk7FRp7Qscjt9E6vifVv9E20Gz6d2V8S9anbteoEjqimSpl/ykGIQcy4W3JVDDr+dYOwl0tK4BhijOZI5xJNyIbIK4figMgT16m5R9N7cOCKzQTUki81CUwBg4iPjkgIVy8Z8Bg1gTlJPCvKUvnfaPuKqTjvLm9Hws8dbm3CIDik/6Hgb/Xc1KtRTumSn61XWY6c3B8UdiQHitZq1Sy2j1uWdlHlnp3wySaiTK1lsgNWKmv0ZS5Mikugn3LH3q+xrLYw5tFeb9Xm9xch7ik5ZXW5P62C4GDFffwy0EUmF030CD/moQOKj6oK0U1TBuFjC9UDUxGSje8CRRBb/JbSwhaq815deaSoKHd/jxUs8i84HQyXG11cXWLDJdyGm4fjq2jhrz6NjdRr/MwXC7I9xvB3zRpRbOBZxUtVP/60u3A/oQ2jL5R37l6qfJAoLlH+ow+Y4+2aghmMVY3GdzsqOJHoJalHO6r9nv1rJBSSAEjuWQ1y9YI3GKKofFPKjAzqful+RkGAQITOXU8YaKCLSQBgx6JCRGj4Nr2aqxGCDldMWs6/p670j+lpTlCtqVQwcnMhk0HuxWymOorKwTyCe63gTaxUMRSKFrcOEb1J5zIJcoXcmbO+XE7vVCyQ3MVSX/kltIJgbsHueS5+SPFaw/eFX+sNn6ToBWPU2T456juSBgoYfVU1gS6aOQd
 Vr8DMslC
 GzYoq3jIm16jePSCptXGIhAVbtwOzQu5MGp2bI/TWrBtonvQ2bHzN0QKsFOtg+hI3no01wm3Xh6qq6MRFXY3x6nWVvHv6ap/+mzoN6h67QxCVg0zoKE/3Q+9GNxZP7yCwSCjKYu2y8qbIqQdy7dO573FdpxBZbUMv065LXHYdk1VNwvpGKMUDTfsTBK7vbKvXiUeYvIld/Y6rKHJ2lChn29aVzxOMraisCclur+FuUS3PsPFH3Vb9fljiMH1ltmZZzhDFIfpPZYEPGmQyfhM9vzQGnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new DAMON sysfs file for pin-point target removal, namely
obsolete_target, has been added.  Add a test for the functionality.  It
starts DAMON with three monitoring target processes, mark one in the
middle as obsolete, commit it, and confirm the internal DAMON status is
updated to remove the target in the middle.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index fd8d3698326e..b34aea0a6775 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -279,5 +279,42 @@ def main():
 
     kdamonds.stop()
 
+    # test obsolete_target.
+    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    ops='vaddr',
+                    targets=[
+                        _damon_sysfs.DamonTarget(pid=proc1.pid),
+                        _damon_sysfs.DamonTarget(pid=proc2.pid),
+                        _damon_sysfs.DamonTarget(pid=proc3.pid),
+                        ],
+                    schemes=[_damon_sysfs.Damos()],
+                    )])])
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+    kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    del kdamonds.kdamonds[0].contexts[0].targets[1]
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
+    kdamonds.stop()
+
 if __name__ == '__main__':
     main()
-- 
2.47.3

