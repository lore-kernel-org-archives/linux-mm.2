Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ED0CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AAF6B0205; Sun, 31 May 2026 23:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62236B0207; Sun, 31 May 2026 23:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F806B0208; Sun, 31 May 2026 23:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AAA5F6B0205
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:24:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40332C1DA9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:21 +0000 (UTC)
X-FDA: 84829900722.03.1CF8AE7
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8DA6100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hl2Ut3C4;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780284259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0eHW6gzjNPUtuJqQkMXg8OwcF2zJjUTNGVxRHFSBI0=;
	b=Dvj0MICRPhGnCUneZ8DYGjwnLJj4MbgevctxVEdRIvoc7krFV0biDCw3F0tqCffxvRRNnN
	aAT5xl5dFImwRKrETulCirehtFjPE2O7hFtoedpD+IMr53DfAOFXu/O3Wu3Y/HfjT3TxNm
	lfwC994aWEyZC5r9W/L/VrgAEhGG3Z4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780284259; a=rsa-sha256;
	cv=none;
	b=IFrAB0pahnQIm+gVrtRkKlw2e4xoScl8ldUZeQ3zqs3OswAfrIkYECLpj9RSzZUvS6c4Hp
	zCZhi0RrgWZfUAVydnSbJHMxuqxKK5VDLvkKbMRwSOS4dWrB7nJnh1QaebC5rZJqdvNezU
	KJ7SNxNZKAo1rugDflQeNppQGpvCHlg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Hl2Ut3C4;
	spf=pass (imf05.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780284258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0eHW6gzjNPUtuJqQkMXg8OwcF2zJjUTNGVxRHFSBI0=;
	b=Hl2Ut3C4+vuq5qP49vk5424zEavISwmgYSN5PlBHStrCTykZ5stliQKvKHa655/N4sn9aC
	iXrpzrqtww4g72H49h3pQON10mwAHF7AHINgPIhHYdA41MabgcfoI5jV6NbxkiwveV3qt2
	1TfWbS6iB+tUXAwXAflfGHKM8bzYrNc=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 1/3] selftests/damon: prevent cross-context state pollution in DamonCtx
Date: Mon,  1 Jun 2026 11:23:12 +0800
Message-ID: <20260601032314.424013-2-kunwu.chan@linux.dev>
In-Reply-To: <20260601032314.424013-1-kunwu.chan@linux.dev>
References: <20260601032314.424013-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A8DA6100009
X-Stat-Signature: wiiqs8p9erx4a85jt6qk1en68m3f9m6x
X-Rspamd-Server: rspam06
X-HE-Tag: 1780284259-726362
X-HE-Meta: U2FsdGVkX1+RjIMtkCVDQo4KAewa9hCnpVstnZYYnqAbUwD20sqBBWCyDyNpemfoS7Vu5X0DSU1DSgmga5mu6nXVEkdgP1mqIIf41irE4jWPnvvGx4kE3uii4pPdG9Ny+uKQSQdgh8IubDuZKV5s5te79lpG83GIpDK84vNsYy8t5mmUityrr+9h3vgd2xJ4kJ6QU6MsYk31WE00DfMz/93ODQodZoQA2mGonAaSZZbVHUEy8+3cWq6nr5XXJUmumjufXorppCZCogtWvwSsoDj0c1P/0lSqR2d/YfLDa1cWggnicByaqvvEpEqLy67rhtVqMfObFn7xMDzmrSpqOl0Nssgd5aey500shPkH9xfM6pyf1kUmjuazhHJHdgfvJZuFOZ2lxq8jjnOAWZdHGBIdpAmqaiEP5f1Jsobv+3tcvcNc0v6NTEgiZmVzNnPs1GKhu1kJ4uU4EyQ7DOANJowvlMbTBmTjQTnZcR6tLfrNxbd6Jbx0D+RTzUXHif+7tr78jNX9Lgs/QJDrlZCeQO2X82mHKewtU2DL9fqnCP7sa9W8uiQ5e4grw0Lpe3YY6rJx9jcBPM8QLHSue90XmaiE+NW9C5HVp6S4PAZLxi7hTa5EH/qkyhGr1pz1gJm1bbhfhYkGfon4Gz5X512kpfVrlL6ETlb07PZq/NYU/G9+dOt2OuPLEHOxpI48PUxy+mkJ3G9An0GWxD2cy2CxAXD//VrpdFz7Lw2I3Rc6jqaTcJLoSA8zwwVK8XVCTDCP0vc0fBAUC2XjLhEtl9+Q1f6EcM0N+IWT+GARZ+7pIPVYwl1zOqBvPfxbu4857loIt5aG91kmSsEq35FoABwGsAe+LZVQYyZ2i5o4BjShJVewFhuVy3MOQvSf5KTiU4kkXz4JGrANeQrkExgSyrLyKROH/hJpbo54y13az3v+QqRzZf/3d8MWEXN2Q73R/LVPzzLh6eps9ctICKO1kiV
 Sf8DgTU9
 nWxrhoppfpYIt5cdomU5h1kbK23etOrbF5P0YFZ4K+RrbPHiLEruVpjAnYUqXI1HnGXD0Gewm09DH/Xt3XgmnmZPbOuHyCu+ynUZ1Tea8M4Y5CUMJfuJ6CPiuk2RCP6HsOcZEAv+NDh85AWrITt09io/mDWYxJ0xNlVSDIdK+UONNsHHzsr1P7WZ1d6TKyDVPsW5rWwNF+L9JMy4nf4ibVVPyjmbReBHjl1I5t0JpuWbiaR5zCSMuECms608hW0701gtwUKKIz48Xa24DPxsL6mQ/vPdJ5FzA4VSq3TC2PG0JDQHiK0UYZJmLRpJ/2B1tTIBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


