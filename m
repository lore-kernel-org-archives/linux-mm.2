Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D92AE937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E7126B0096; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697D26B0099; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5003D6B0096; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1B06B0096
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F17AE1A0BEB
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:06 +0000 (UTC)
X-FDA: 84650415612.10.FFCCDD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4227B18000D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaBgWyNs;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTSjVLYPguBmCdyYoU8/p+4xBT6J/c20Yd4o4tKZLuM=;
	b=OUjCxaQE3CUYmNY8g/7U45LlhirRb/WPVdVzUAw9SHyQXUAhhMgQpZNYrKihnM/TJcGr2x
	+2VKSl4+N4W8hABG38l8Zz3U7OuaW+I8ap8/wBWv83sWk84SPC3W4PCogVyPH69pF9iW7R
	l55r8jogeP6PkmmEZ+KSUWuUFYQnVgo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AaBgWyNs;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010805; a=rsa-sha256;
	cv=none;
	b=iN+BZ4ByUPbPEDB2YO+cRE5LCc64HtsWEP8SbOETu4DSx3eBsGU1qLX1IQLwFLTMw+rzqM
	g/F7w0Fazx1pbleG3uGH5iSLK7ZxbJXOlJAwHz4mpmaw+33MzUvN/81Lp4w8UFB9hX5BrN
	t1+cs9k6cAfkOO12EtCZB/iRtWhGiDw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E866A4456C;
	Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40374C2BCB0;
	Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010803;
	bh=x42u0yyujS0MNNJ5zIzlJ5WzcqjchBB5xjDhcoIlpNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaBgWyNs0nJ4v872EAZLuHaG0uWbUqGvdCTMDz0tlV8ECu0fvS1XnSqClMa706SpE
	 1cR0AWCe0uig23iWzz2L20aqpH5+1z6OIbv3sfdNHaEkL/V/0R3lsWcLAq1EqLXA5x
	 sour1JLGYxaOHd3Vd8IE23KNf7XjfXdSr7LibcwEaK2p48Aq9ZD7SER0DL14Cpz8EZ
	 UbMq+K0aCzQGGAsvyXFP5nf3X8CjMyVMGayNQBxfo7BetPG1VGWYJpGayNfOzPbwba
	 6VdMzOYS9oEx9bQ4nsP/lgQ2os9Yf0XvTHymFcDpOP3Q43EhUNFoURtYTt/TUik8zP
	 XEwX/G9+ult1A==
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
Subject: [RFC PATCH v5.2 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sun, 12 Apr 2026 09:19:48 -0700
Message-ID: <20260412161957.82835-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zeooptjyzukm3nbu44t1wkh54pb9qebb
X-Rspamd-Queue-Id: 4227B18000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1776010805-716552
X-HE-Meta: U2FsdGVkX19B9ZPJEnhUXIW2oP1WEjBDLdysUs2teL1GC8hhaoAa143zVRrpbj3ZJQOT6nnidcx9BRxZa0vBu01BIL9XCF26m0S32i2jvdN3Ip7dD7dFnJFNSQ4JDnxM1zpzbw0AykxpNy0qtS8XQyo4pza+DpOXc8DQccJs11mzti+CRlfmKvZRGjoSSLRXkXxmgxHKiyXNPi0nPV3wkkJjVl6I14iiuHs1kImf9fvcOS805RPQHy4m02nle9gv08NxSnlBKBOxaz8xPgMZd9R9rTSjxEpG9DiydRjSvvBkCqMPvUk1AL+0bjBObADG9tNsJWLI9tk1iUJXxrzV75Go1pFgLYmhFa0a7CYHz17tKNcd9M5Sh0SyHfu3j+GdvYFu0SAqdPr8f3fwCd7V0LvkE4F9U9Kf6Ys7RXs0+05aIGfWQXSrGY1M5E52FgxmAStfafA4KAGHHKIGjvVywPNZy5JaSN0TwCHvl+M4gVWct9Zh/QWWa3tjCUnH9HYjQei9lOK+CM1A5IOp2OPCYQ5svp3WeUcDQHCqI246yvaiOwhAha+tslVCT4Ugfr6jIIPlcOreLRVSnN3dNp/0A1vlxj+HzqIpz/uiOMah7I8Auwm1GGv0RtqQmbgMTXxA7GGLnTiYaRa+jlUN5l+atLSOzEieII+LjEFxrq0y5G0U76/0wHTWscMxVvXDp/R0QMo8ZMWl8MXF11fe4UpvAaTrD/VNB59PgWWuKgF4ctusGhCFNqAHj2V+paLDq/93QxXKUr3/d+TY7PaoFYzEFeb7eZeO4yaAeMGXqQAmL6qMZEacwxYHzxs8lcItDSNQl7WSHtpS9vmnRnFRgsu5T5SKA0VYLRbovKZFxpWuQDiXJr1y5nRSWJOM7sb7Nw3QQp6gmyy/YKMnqjwhOx4FDK6rGpaPD8Xzm+yFVlpo+z8GqRdnKzanU9kwYqjDAAlVnzUOZk8Hm4GzATS4KTH
 FeW5651s
 Oi7ssK4e88KFg5Gakpz8s4jM8e5RhtILLnhZ7P7IZJTS81ltM3MKUnmqD/JxkfOYMErhXNPl5TIYib9AEgOVrAK44l9qeQTO8WfXLpnxW+oSgBV66NeNKMz5iLRxjxONpE5K/VGe91LkqLjy4TODmouwPkdswLyH9VhDlgxSffcz8Dq+jqz4jHmzFg1ioLZ6iePqfAIotLmV8WDLJdmNRHY91obZH1sJbXvv15Cwa2wqzkWxoAprDMZaNCWdAEALFYOZyS25LjtOYcBVz6JxWApVr9BZQZdsjc8Yu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 622d24e35961e..fa7392b5a331d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -576,6 +576,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

