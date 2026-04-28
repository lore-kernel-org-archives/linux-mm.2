Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C0BFFF8867
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB606B0096; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778016B0098; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618776B0099; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC326B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F00FD120324
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
X-FDA: 84706244868.10.C0DBCB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F39F40008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IeKmR7UQ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=WytAVygJYbf2UQZwePhvLzT5Gda9BtpbQeauhrj5NN81eWHsCJMd/slzuzISbwcF/R+wx1
	wbKXmJX0fzaQ7+Cq/TNnzUvu7B8sewi7VE6L2W4tNtUibUzEFzuV9oTXkRw60z2mtayq3M
	NcoST+XIpNwOfjXRGAxUWWU6J7hnG0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IeKmR7UQ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340073; a=rsa-sha256;
	cv=none;
	b=DpoYctOa+lEwfC1i+iorH/RTPlak75UHnGbGgNORl+cUw+ESLknV4ii4MigrTLDuTTR6Db
	R7qu7hVLDCdCwKxfCQlg1cZ0/lbEkKlBOG3dooSwpd9S6QXuMnTQ2nHJI8RqELitxHqQwb
	exDygnpJ5N8GJmCPI31XMJaF0gABMoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C15EF6014C;
	Tue, 28 Apr 2026 01:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC79BC2BCC7;
	Tue, 28 Apr 2026 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340072;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeKmR7UQvah1qRjDn/7akgBv/fphHPwmW9ugHEcx5qkaUVCVM1P53gWBUpE5nSjcS
	 LUN2oN63KaY/k7LvtmoYQWwdUJ6dqMseS3y+5Dy96sSpQUlcs1Ri86weqeTrSLkkzV
	 lbI+UO/ixoHuZiZW2lp4Ae7BAAG2XtIwjTHnwzpqhieDG+gFum/gROTBa5I5ObqWwy
	 Pa4H1BloLmlggXm2qn/7PNffDheA9YFoppgvf7xect0W+gti+PEAe70Cnr9mSF9Att
	 +m8BYfZeCHjgn24QkOAXIGpGEeBI8xWmrqkeF/zGGNq/3M2uDLbZqqKdXe8JMuPS/F
	 +KmyLdUKw3RfA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Mon, 27 Apr 2026 18:33:55 -0700
Message-ID: <20260428013402.115171-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F39F40008
X-Stat-Signature: 9kiz9e94mpw1ngj57uj46peyazd8gbqp
X-HE-Tag: 1777340073-691650
X-HE-Meta: U2FsdGVkX18EqjiJ7UkON5sTvhxXaTRIpJjsmx6fIrbE9OMYzd9qfliHfE+1h6qR8Jnwdx2+2/VjJA9ZWCon+p9DqHNxGxwSCGX9hHpd58FjK/kM4zlRv5p4kf//p1H5DdMzWPfCfbsTmBZ5fqXCdxAOTV/XdtyLcK/H92G9Pm19yxGOH3uWN8t1s2EH1fO8sQEIAP52yMOVr+YlMuPcfixW20iFdn15gKgJP6p1xsjYYlgqCpA0aTsIWlB/YABzw2AbXuCP0US/JsK8ZHUWJ2QbdDz8PjEFmKiiHa0JWSOd58JaPJf6e4GXwy/QeecceDURgXhbbz0Rt/vhWORa5nwFrzov8BFTENgJZEpD4eXiiZ7hk2hz3X7HpJyDd5WslO2OE694votmWd3LXMgXKMSomFQIzKau/sH1WO5NIUjlxrZth11EZv+bOBG+WBAwdtKzn4fOcGGMq278E546BvgkO4+uqLZmd+y1RB8CIZ8we7xT7hB86WSOOonKO/8r97AwIwInuGXaBMnpgHh2I+W39UPWJ5JXEr503/klz0wl0Iw0OpZSjlVGzZIhMssoLZkKkcn1WuXIua6AnfZt+lbB4pEc1xcBvkV3aW9hcQJX68vswfStWf1U2nz5fNhtqSBwNEOF0SThLiR9AdphwuqRDvAZkSCm9CFyYTVHMv8HmDs00RZfGQn/HLzQrPEzGlHFYhdTfEoL+0r8IL+c5K45KaL5pk1oowm0pLeoWqN+XAQlU3rtGkJcgNEQLqCcn7hv67Mn4Fy6YxmzraML0qTcNCmCXnqVWleOfDgfcRCN8fEEwpu98SxGhgcXzG9bAHWK3yGs3aSYa3ggAEzrGg5WBfZYUymB1KRei+l4IWQcG8kKTkA93oPxI0Wms/UmJSb/l/rux02qX7nlTixYmBEAY74zbITJ9x/enD9hmBcDkA71xHW+IALOTCAMGGv9VxlU4E+oP3/Js2q85Nx
 yrR7gfKE
 tTS5Q+wzdisdqKI8w+iRg4d0JptX6Rjy3szO2CYi07bCoyqbHNsplsuAmNVus32ryvbM7vXSeFS+KjAz4B8eKnt2ZRBnYKxRp4HHsgKLQLUDDSlXPPi0YpB1stU/WEI37ZGpkYrXpRNG02m2/5ZmUBBiiONN4Ue3oLiqfi3qEFEttGMJgMKeUvehXEAYwm+3Uih0s+RfCtlZFCtndMnvn161rokobBTXnVDpCQjzFd7VX61TXA7jMnRG8JLXuOK+RBIgVDXvfO9Thhl+cgUO4kdQvluPxVQgOdSwXbhsmJYXwkrksgnTLo3tng67cp0s1eLcVrgUw3qliKGlMadkFZkgP40ZvFV/rL2yV7z/HSbaHxaiVem+KPSQHog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bfdb717441f05..d5548e460857c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -84,7 +84,9 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,
+    │ │ │ │ │ │ │     effective_bytes,goal_tuner,
+    │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -381,9 +383,10 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, five files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
-directories (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, seven files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``, ``goal_tuner``, ``fail_charge_num``
+and ``fail_charge_denom``) and two directories (``weights`` and ``goals``)
+exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -402,6 +405,13 @@ the background design of the feature and the name of the selectable algorithms.
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+You can set the action-failed memory quota charging ratio by writing the
+numerator and the denominator for the ratio to ``fail_charge_num`` and
+``fail_charge_denom`` files, respectively.  Reading those files will return the
+current set values.  Refer to :ref:`design
+<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
+the ratio feature.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

