Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BCDCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FFA38E001B; Wed, 22 Oct 2025 21:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D0D8E0012; Wed, 22 Oct 2025 21:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8EC8E001B; Wed, 22 Oct 2025 21:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E2308E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05CF91298DE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:47 +0000 (UTC)
X-FDA: 84027637134.12.22C638E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F52520007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uezsR/zJ";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182745; a=rsa-sha256;
	cv=none;
	b=FqwpZUt+Q6Y3sUHMegA3xthG/PibQxgLexjNfkIU0wTSLdwla/CeBZoph64ZXrdKYPO/e8
	Rni8ooUOVgYujIuv1hJ+IAu7HamOUeoxz5mk87rQXpIebtDtA31ejmddazT6iptl3WK0Z8
	lnb1UFqwN/h8gH97c/TeFdrdlF+j1e0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uezsR/zJ";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZFOW9XUwP4OzBoZNat7aRlaC0c7e0/AoO/NYRzv07w=;
	b=yh0u9+mXM6DHu/6o8Zv3Wz+plxAMAMD919JUjAZ4HvDP4PG2DA890vrA4+/VoUkwUVVX5w
	Ptoudx7HQptTovepYR8gznOM0LFFIzX0SnZbD0xwpYhrZBQ89cdMkrONb8qRvByRh5+elL
	FRjpljb9jugS9NUAaQN9EU23iFxkhuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 852264A8D9;
	Thu, 23 Oct 2025 01:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D239CC116B1;
	Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182744;
	bh=RKBfxsBzDKUrYjFTiKbvh8ntTnFoyVwTsTEd+4eRipY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uezsR/zJxoo+BgYu1GbfDfbFJOX02+pWxKCRXgxjhRtIgWFIdTDzahq7STAK6a6Ex
	 rCrmY3omr5ZoSoytdOgy+5pemZYlaOTn9TYlJ5MWCInC6i9a+iSEW5FmDweM4cWmq8
	 eF8lAvypVFdPAQWzr0Fgjoy3uFf4NAHp9k31Z59kaD9CO1/gsAyXVTGUAPkNLGmnAV
	 9U+xiEEjvBqaUy9fYV/hQ7NC/EoqYvW/WUPbHBgMtDU7duCDO3vofznEhm8GBQG8CS
	 ZdhiWEbkBx6au3ai7F53rC3/3HkKNyC7AfU0zLLBoZ0jBZviOiu/Q/5SrWGXHWyllF
	 obXd6bIItSOKQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/9] selftests/damon/_damon_sysfs: support obsolete_target file
Date: Wed, 22 Oct 2025 18:25:30 -0700
Message-ID: <20251023012535.69625-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zrpxhpzybk5dnj4ru5ni4dqfonskpfq7
X-Rspamd-Queue-Id: 5F52520007
X-Rspamd-Server: rspam09
X-HE-Tag: 1761182745-8758
X-HE-Meta: U2FsdGVkX18T5oAutNC03mNgKnoDT4Qt8NcNXSM1f8BvIPkboXsn5b4U500gvVXnL4nxMpDIJYuHG/mSRnBxdLTNFnrR/a3+DAaLGl3yIZJt4BNjqqSjA9vIbuahb2akXh8ATc/IFLIZj0VmSMrXFo6yNZgJoPq1Xqvp5qLxL0RKO1hKh321EwSiYvLFcBvtbWNBDuJvEmBoO7CYr0Di4CLE1/YwKR/EdmSvKAQRiMAo895g1+2Z9cn++Paq6sEab2LSLWIzXzcYFiWUJbpb584RQzBtNPdjiassrS2a1bu5z7o3kiG+ZDDkYpFrdN3Hn/ZT34PEm6x7Ry2u37f6CgFz5f4GvsuvwM+COzvZJSjJCdVjR1Q70uo9O1tU3LcnQYcBHi17mPO96Hf9HB6nqUS6/8Fuf3n0T5xoKYRWPdPdfgUl8qKONx2WHwi1BwbRL+4WsNwlFEMHY2emwks+6q88loyHY3GN1GwW+ruT1oVfNs2qBW+YalpX8p8/oC/CRVZyk+4OZ0+OQ6plWuxTfZTdVbul0sFKW2RpkrWgacip4rVmG7RWnmXEwb2lwOen0BUxQZEhiCl/vTWaH77KYvrQ+w3ejigj0SaZaKzJN1kt/QQWFlzBElzgjIYG0OvqLC/VgAP5NIB86Rb9K5LQlvEQNHGUxd6Q+9saQOiooXehmON9hEjr26AnT1PXsLk4fICUBI4NpgXUGgAaPC28BN2pcdKq2td9nGISCDMoFmt3kpeI4IGA4KY24Bb5vFJdS+Xo5nA4AWM/InLKACRWBTWd0DonPKb8ap2QnXqfckaRrRvkfyqINsysl8Is0UaV/aTTsZaoTr+P83oAlGSIDuqKkFUZI3gADkNcoq/ofCIDN9GiM5cYM8wc9JgMlE1vbjb4UejP2fnAkh9wbjgDgbFA42JskDgBKfXlLCwtyf2NsQ380xsKOTdaJmoSrCVmNnw2WVLXOS8qDN8ROEY
 7auR/sQR
 9pelNvHvqP0M25T9c9eE5SXNQcVpWhPkKhYEJhyatxmWQgNqYsKwISdyzs+Mi6TQ/wLnBwxdz4he5iU/yhZEba6SBV7loD8Am9NNoy2/h/Mls2zt+n/kjeCmdz4G2JwBAtCR6oW9FCBKARvV3TAFEZp83Z/iD07M+CPDlo6uxVUTwriLrxF6uHQ0DGjkgcVtJpaexVkrghmfqqAfgU2lwVxVt9bbg+8CW0qjDcERRIdMhIMVef8QZA6CtlVRb97gdkBhzDZ8GBGZetePOofCKkME8cQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A DAMON sysfs file, namely obsolete_target, has been newly introduced.
Add a support of that file to _damon_sysfs.py so that DAMON selftests
for the file can be easily written.

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

