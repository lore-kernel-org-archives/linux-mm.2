Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06C6C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8256B0114; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A136B0115; Mon, 29 Jun 2026 10:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08BD6B0116; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C97936B0114
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:49:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64F2F1C2EF2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:38 +0000 (UTC)
X-FDA: 84933234036.16.53FE433
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id BE2172000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Le6BHDP8;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744576;
	b=LIKbNe48Ohz4gLEAU6TUSBOa+bL9A7VmueSXAELMaJeE+M0/TMXrEyi/aLFRnKboiN3mDv
	e1e6MXjbf5oh97ejV0cgrVe0CaBqVPKXCnb9JbBF42+Hd7sR1WGa6iyNfVEhnxCTuR9PJZ
	qhmzTzgyzDlLr/eH8thr81DFRGGOCNs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3trZStiezM+6sm/g9plYWwoc59rolAxRxndflOxpvQ=;
	b=LARgTpB2g2DXmdqo/15RudpZ9c7iXRxW6m6aICp/BWNA4LwR4PpoVvj1IoP2rm2DJI/rEq
	tVnQGJZ1jL/cMZltLmBVu1K1AkJ/OTBfs5wACN0cBX71OoKaXIPDpd9RWMLriH3uqaFMv+
	l8qvpDEDRgsOEu+03ePDZWGzAhEIe5M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Le6BHDP8;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56AB060125;
	Mon, 29 Jun 2026 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EA41F00A3E;
	Mon, 29 Jun 2026 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744576;
	bh=U3trZStiezM+6sm/g9plYWwoc59rolAxRxndflOxpvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le6BHDP8kLQkgFFLTSOq5d55t8jWttWvTorxRLRkbZJ6RNtucoYQFdNqMVWNFXwTQ
	 bQgcVL2T9voIC3o/JQ7bgcl+fTBBtl56ey16d5jHGSxPSYVgyyQO1g6G8HNAQePC/5
	 i5aZdsdMAQ9CUVV5geSBHZcg78ikGHZFlQMQLlk1IgfD7uU8EukT/+JKd7tyfRUaUa
	 lwhhxWwrQOOPuR9Zkn+mGUzbT3WctZMDTDsevx15yfZ61Y88wstVexBhZ3UT3LBjb0
	 /CpWZUaSS1DEl48fcTSoQkjN9MrYvgPrBUzD8WKWBu9B/3b0sC+se/YSPa+yEtcxM5
	 hHpTN7w/6d9+Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ruslan Valiyev <linuxoid@gmail.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] selftests/damon/_damon_sysfs: support kdamond refresh_ms
Date: Mon, 29 Jun 2026 07:49:25 -0700
Message-ID: <20260629144927.134237-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144927.134237-1-sj@kernel.org>
References: <20260629144927.134237-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE2172000A
X-Stat-Signature: zr331ubx6xm5hh1iiq4anw3cgzpqrnkc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744576-880961
X-HE-Meta: U2FsdGVkX1/GiAjR22ML5W+IRCJ02xUM5p63x/QEOVUuwx2+W49qv91b3Z67c2Gx/JMWMEusWLardCQW1aEOKWF+8H1yJeyENRptviNxbnQ/ZXOSkwU8LEmiNkAm6N9bwjoGxTnNIxVzIEpYKe6zq83JOSTWwtL/a00pgrm89/B4dAknkn/jcy1lNiwBVU1CvTYEzdKJCwHUoYR7sz/fh444J3+TG7sYPEmW+iZx9XsJNYO0h7skJZKMeKfHAn4qeAaYtr2UyoiFhihTZTkSZ/lOvG4BTPxAeIHHarzzyUmAU0WQFtcSvpFtcfwcBL40NnvL1v47VPGLGz72LQY4hToS/YRCo93Z8DVDdFfYV4z3w8HZRUXBqYTE9FiKqAkE2CyDN0OufPkdKjqS/vhctx4DFVDYVtaLPXxTZCFaJnRcJSMvJaxP8irOWLd+Ep5me0BEtddcGbsjzfScj/vg3gpJWJknW7IfqssuwiWnsa6pPNWwXfMW48fKSLK76yGojsMcMYq7g59se/chZ9IMgfThWsowzwS7PdI8Q1Sl3x4TcjH200CSAs1aZIFzLlHSqHkQvtUEOojHpsKdkNjR5omyk82ydags+5ipZs5B7pNz2Wcu97zTpawbzLpnbqIj5X8iXFLL9iLTNZxU3I8XajzWYCA/7A0qnHJLFrTqWngjXd3ViPFN5vpjfJvvOkYoW12dzeZKgry6zC2MvuExBSu60LKHHP2envN0hheaCwD87P/GahVyOgRxVjY5cE/wF61uHkcClt5kRPbFpPXtIYwRpY1fGIv5F/gJhoZWuR1d5cXI+vszRXznWz5KhqhGdK8PWpfFEL7O1uMndjQ/if1rWs7HpFtC0bJTOdW/VKR/ZomI4ay/k2NutIFWyEefIdVEZq4+KUa45ydKLSSPL31AQ/P16O2WlHmPXbiBoOwbIb3HHLIwduwCq3joIwtqValkB88Rjto5AppP/Ua
 GnnhYBaF
 jJ9b0GRszxKMcOniOKkpjlTowe5aPRbGVAmvXydIKHI4DJXnbxhGaB1VB+ZNnDSzVrDBemZEvw0RF8kg12G/Yd+9e6PnPJJQ4I7YcgxmKPSQ316IRlFjN53vHvXeDJ7am9rCcHTjlIHx8Svvr+7yTPGM9f/AcX9jakXU+P7SQoSwIlZJkdR6L99kl9dFfP5gNc3X1os9vl3k+92lGG5UFKSNfijreh014kiiFkJ6Tr3TkDEGzNr+XIfOPlwrw193AF7EQtUxHYbigMS6o2yySB3CB+lnSQtGWQG8foAacg2F3SII=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ruslan Valiyev <linuxoid@gmail.com>

The Kdamond class has no way to set the kdamond-level 'refresh_ms' sysfs
file, which makes DAMON periodically update the read-only sysfs files
(DAMOS stats, tuned monitoring intervals and the kdamond pid) on its own.

Add a 'refresh_ms' parameter to Kdamond.  When it is set (including to
zero, to disable the periodic update), write it before turning the
kdamond on, so tests can exercise the auto-update behavior.  Leaving it
unset keeps the previous behavior of not touching the file, so callers
running against kernels without the feature are unaffected.

Link: https://lore.kernel.org/20260602131217.2210912-2-linuxoid@gmail.com
Signed-off-by: Ruslan Valiyev <linuxoid@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index c197ab99bcc0a..e6a2265d721e8 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -698,12 +698,14 @@ class DamonCtx:
 class Kdamond:
     state = None
     pid = None
+    refresh_ms = None
     contexts = None
     idx = None      # index of this kdamond between siblings
     kdamonds = None # parent
 
-    def __init__(self, contexts=[]):
+    def __init__(self, contexts=[], refresh_ms=None):
         self.contexts = contexts
+        self.refresh_ms = refresh_ms
         for idx, context in enumerate(self.contexts):
             context.idx = idx
             context.kdamond = self
@@ -726,6 +728,11 @@ class Kdamond:
             err = context.stage()
             if err is not None:
                 return err
+        if self.refresh_ms is not None:
+            err = write_file(os.path.join(self.sysfs_dir(), 'refresh_ms'),
+                             '%d' % self.refresh_ms)
+            if err is not None:
+                return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         if err is not None:
             return err
-- 
2.47.3

