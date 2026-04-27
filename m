Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F30BFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34236B0088; Mon, 27 Apr 2026 11:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BD46B0092; Mon, 27 Apr 2026 11:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A492B6B0095; Mon, 27 Apr 2026 11:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9506F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:19:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47EF11BA7D6
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:46 +0000 (UTC)
X-FDA: 84704677932.13.E5BCB65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5548C40008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qIxHwC7j;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=oyTcKgvJXPELyGOct6W/eZ7GnEsj09IbSjWAh2qB/T40xVhjta0Rs1KGzTZhPXcetQD3SE
	5SnkxSPrjusWg6oTBHk9h0Abtqvywz9EYsiuGZ6rJ6hPYsJbrm3WIT0bADEtqMR/ruClvt
	DMMxEKcDNYxcBtYTt2JI6ad77GzgF3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302764; a=rsa-sha256;
	cv=none;
	b=AL8R1KGcau6MeVF3v7KeAqrC+MxtJQFgj++lDJmqxc8xvNTviU1B6eBX9LTWL5nWEdxgZO
	M4aSkhXh32xWa+WV0I992nNjyGE7uASVJTC/3lTrk/IINYK4flCkSn48L7IgrHwu1JTosA
	s2gKpiiMV7yCz3ti1/9UmogbtFFw9IM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qIxHwC7j;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EA7D60580;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1F2C19425;
	Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302763;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIxHwC7jpSTJLYHo4UAK3o1BQt0TxmjOyiTaW/8vKTIqO1Fi36gO4inEtqu7OvaYL
	 ea5lnGOmDsGrFslRP0dMXV6FS1c1TSBJEPDDYJ1fvVlFB8hEYiZhE/W0o+38XaNpNp
	 AWv+FPlqmqABpRiVtWo/UYn4na6zdhN4vAhUZMi7xmslSJCpilxtXYvteLPqpoB7LW
	 DtRukm/NtPKKGOueXTUC+nDuEjwiPKrU1MOnubP19Zrrfwczwuc/1L4NhDbv9FZ0o/
	 HMH7+YqNp6fOIiHpP2q1NRZAYnTDK0SciY5aOW5MpRkwrgQqE1B+0rDukd5x776b/Q
	 D0bXUjxFLJRjA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Mon, 27 Apr 2026 08:12:26 -0700
Message-ID: <20260427151231.113429-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5548C40008
X-Stat-Signature: mx9ofqcjkfy1hkcpoftm966how1ibafq
X-Rspam-User: 
X-HE-Tag: 1777302764-832149
X-HE-Meta: U2FsdGVkX1/VZX9pT93rZhiBhXFK5ikavBy+WAovvhorXFLSRHXoHdm4/FYoHxNEiVdOiSBUHD1QfPx3j4/nXDFk0gfc0YIaFx5s/w1cWYKZRJTrJls+EPa5wQrbS2CjPsiT4jOGzK1KiPvas+LI/WtGhKBq/e7MRGHgVS++cn6Yw4dSkoP52Rcj0ltjsUBIGPRcya6uOz1IpU+VkwnLEp4r2LTkC041pPZJUWdSpS2OUpDbt4pyis1eagaH9yeLgKpZuaeruCulFXxu84hsAjaJPphI0gIGFwC2LmMk9jSmpJRkPkpmPxOBbE6Bq/5FztVtFwAaGUV/3mmxRza7XIPJDQtg1oxVlRYYxoaUpQ+2H5VDjQMHAbF8SoTp+jKc5Y6uTaX672Mwbx2Y/7IUu0GfxlNGN/o1AlYVG4ohzM/zxpwfp43FExKa6SBaSxGGAu9me7oyL+YbC0mrItq/7uw5qVJwMvGgF+gDZOE3xikYrSe41vkF8dtk+U16WObzVf1bW0o1DWtSovHsYt1zWqXWkp9m4rox8PLVXAPGBjsRYGMVPZxaX5Mb+RJLrfipnLC7hsiNUg+2gnvV55bLBja6Hkg0OfNy0FI7JKUMgefCbUcXSHm9pRUA2TtmZQsi5AzMIxAImpLv7KJCU/jpM/xIdhIvPTF/C2PWnj6OQWb7jAtCcS0YZwpkZR+SUsiECRqIIf8rSn4mqrDr3orDVluH2pCeiuN0jf8Y3Bvb42cwiBQyLBRnR1VRHaTffZ0L28mNIWSP4oTLYinIET44fPKkD4JwTFgi0WhD5RGHH/QPGKFDfMis9sO7bW2PTfN3/xQbcDcwjQjpUOSK+PdP+oZ2U1sO5wdSFdce3uHJkH1xSJPLYfnhX1FC5RvKAgaTd87uH3zu2J/hT2kOP5NIexF01vH6HuVa+A7b0Ech9LvDGAN2P7B65Sxw/Vs/6b5yoteHqAkfDsKObvj4Y9S
 aDZ8AqP5
 /E6NZEP8py0Venfk589A9CXRbgT97SPtMP3StbXVEcYthFbsLYhSZghXdK6xFXdst2ASPpQc0uIYBJkX9m3x/nDa/tUUc7csCPEMcsd1JU3HMS/IBHX+VKnuHeBJnepiRKsaVpXvBGJZP/3loeI9X4mjqyfmG7qSSzD9y83jQzciUygldvxUl2CzNu8UrlR2tiMG0wyqYlmOFK9v1jIujqzOtl+eLaVeierJcuWhCSSmFDHIwzXH6ezughWW5CMFesDrYCmiLMWkUWT7s3ShJYzsruQ==
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

