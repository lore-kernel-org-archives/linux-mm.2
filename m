Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FBC9F3028B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B5C6B00D2; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52FC6B00D6; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4086B00D2; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60F4B6B00D4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 106F61D699
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:27 +0000 (UTC)
X-FDA: 84549515694.14.A7E39B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 55D974000F
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4QfJVN4;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=6d+Odp/jDu7oDJh7s6W6ZA0u4ev0qwK+uRsPdicjOj96g9REZDPHOdPDxu0wMQb4U8h93T
	7LHBFmMW2a8l3haNKHVt3OeH9+OLPlYyyCaDlQDzHlbkJYr3OqpZLE6Dptwzy1wUBHd4Mh
	v/ne8V11/B8/NRCpDmoyzchjrTPU+C4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4QfJVN4;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608425; a=rsa-sha256;
	cv=none;
	b=SRyRMN8JLyuaEfHlZgwsvWecfxzYYaR1Gok16To93DagjdHH0foo/fVO2cTCqClzWg760o
	7jXAAdMkwpz68T5rD/Q+ZdqbysRVj6yKvaxEpHBw6k3RkALOlMa2BGAD81tul2ow9FIE0N
	imZrBBhXcndbbZPFN86pcbphcpbid1c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BBDC4470E;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C27C4CEF7;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608424;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4QfJVN4HeKCh0McGrK6msBGDauml8c9RrXjZDMP9MJ02VZ/Vkd6E/nqX8YQFmmRW
	 sNgg/Q6Q6a9d22XNJ5n0qmnm34e3mJwfzEAnRG7d2Yvl4fYJSYm3ZdbOBBPOmTA8Gx
	 EsAfRPdmz/7zI0witMyoa6h+TCl8K2T/906M6l+pGX+iVX30oKFHYFTeihHyQVknke
	 I4kMXMpSi/yCDJ63Rj9jPWkp5Ual1IFTyGe0zuLpnusU3ODg7oTEp6v5G00OfjpllR
	 dkZAE6MAUgnXQL9ROXKLNxnlNl41FcqN7nF5Kuzgfi7herb5VV+Q2VJSuWhbjsq4/i
	 d+9ydz+9ubCHw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [RFC PATCH 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Sun, 15 Mar 2026 14:00:03 -0700
Message-ID: <20260315210012.94846-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55D974000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 63zjuneg6kp4dmqujxcdoq4guddt3h6o
X-Rspam-User: 
X-HE-Tag: 1773608425-668555
X-HE-Meta: U2FsdGVkX1+HtYbqtxXBw73cChcZh3TgeTwtABIj6uVcl37pYwbUpuDuH0CpxbXJpzSjhHUQ7ofN0wBOcTySlYOhLsUE7ECRW36ikj1SwA7SGOg1F8o7gbZ0+stIfyr/Zictnl6oaJ28P5Txr8xE7SC8g40XTRab/J/6MuMUkuZOOYnB57ChI/UJ4WnaK3sT+Yze8iaGVafin8rgnl4L4bcr1OEWeynYrhpPBuRi/YL8g7t3FfcA9E4l5oEZ/EJ3uAtlOxdZPULKgWC4KQ1IrPvzioOvT5rrSLPnuKBwe4dtpsK1zFQg4ywC07zHlWe/twnUS6NtaHAv6s4UigFxLpiGUUEU804SU7TKJIAcFYZIzfoWzc1mghj2cW+BXHyAaBhGhhL9fxcmfniVk2OeESHThIgwji2qMrSd6YQVbC57UGecqWQCOV7Q15OYRm4CHB82xyVVnKZo1J1SQMC/cWouFO1/sb2p8KhHtwDs0M1G654QUnncMWAxxtF7LUMV2nki3Iz/EWkRGQkestLF7aT0bq1vzR3GOjVtjofh0caC2HChpVXRlOqpJ9whkIJrw/hAYfGnfBBKd0OAbM4/kQixLtuyo5Hck6Bd/S7DxcLGan69sDwpOLBtSeLVKp5+oc5bmbX8rs7PvlIGsU7ZBwyrzt0QCW/4eJmzEFR3pl1dknazfwluUaHZ5V8uyaN+FkJntX7Dd5042IEi8xnQo4xCPCbHBnwcYqQ2G11q4LcRG//sD+42qf0gmZnxVp6YImCWCUYxuyXRQMTuNKTKgMsyhksCvfuNJNd6RYGp2FIEJNZLzVzcMY2vLDQBF4C0TPQ6wvn3o+aRFZ5eNVA4pvVWdhnc7TgZmhtHKCdhyAs2EzpRTRbqQ5olfB2+AXUSoGt/1nBYksEXUasM9y/wbInRqBtReDjOokbbmiONkv70vwZBmqjXVNatBCAIKnc0g1NBs0k9dB+AaBWYCP2
 UIHv3BMv
 ixHoVAGlLmGdGm4xeYMecYXECkaDeziKYVN+thDgwfIkwR6Ouc+ounczIDaqVLU1/X8Dp9bL6hoOi0sJj8yVCFginHV0tYe/+4Rx5MRs06HEpSAd2VvQX1I5QR0ZNflpVnm03NbL/7c1TH9urYn069vTf4QmElLK36UZTJGeSYFaH3nIvUUYaX3yIfpf4urn8JKwfT8GpGNWe2p+w7AE8L4ClfE231CBYWxAsuirL5/xL1ZMIsUTZkDfbXlBJ5qAHrpn+CeUBOZnqJF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..bfdb717441f05 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,7 +66,8 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit,
+    │ │ │ │   pause
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -194,9 +195,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, three files (``avail_operations``, ``operations``
-and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
-and ``schemes``) exist.
+In each context directory, four files (``avail_operations``, ``operations``,
+``addr_unit`` and ``pause``) and three directories (``monitoring_attrs``,
+``targets``, and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -214,6 +215,9 @@ reading from the ``operations`` file.
 ``addr_unit`` file is for setting and getting the :ref:`address unit
 <damon_design_addr_unit>` parameter of the operations set.
 
+``pause`` file is for setting and getting the :ref:`pause request
+<damon_design_execution_model_and_data_structures>` parameter of the context.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
-- 
2.47.3

