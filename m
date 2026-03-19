Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DD471088E7F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 05:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7502C6B03E2; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD606B03E7; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE4C6B03E8; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8BA6B03E6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:22:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E310013A42E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:10 +0000 (UTC)
X-FDA: 84561666420.21.FDDC66E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 55FAC4000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:22:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TX3/i5dy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773897729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=O3dW0y8ku1FPAv0OQK75K7AwaHC4GM8HTYeselEdY9oPWC97y7AZfIroomNlk1g9KK54/5
	9iqNuDgvaIwvJps4AJC7XHTOnBw+Pf2i53fQiQ8X1C3FNEjSMqd2A1q39yl3vWQWlFKs4h
	/v3iNe6Ye/RHZ4DCGs4mcSKxeuPusiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773897729; a=rsa-sha256;
	cv=none;
	b=8U7qUP3EDtpgwWJqNTJ/3p5y+KzClz4b+q+w4Qsj4ZFFa+UUtkVQ9TueYx6lxYi6+bYCmF
	hOw5ENPvXCW4//7JlBf6V4wC+Hp1kXJSWg/T8o81c0DeLD1jv0dsSwBlAJRnSV7r2E/cXT
	5dflOhvA4N0wTggQtXlnN9Ik3aJTyHY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TX3/i5dy";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76A6344715;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183DDC2BCB9;
	Thu, 19 Mar 2026 05:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773897728;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX3/i5dyN4nBOy3OeHVTRAA3G44kn7OhV1sX6uq8Piw6dCKx1iW2YEn61XiTWkk15
	 fp4zPAAzbuH4PSf0XrsF2DUSIcjuv19ZENxo+k/JymOjSYFHL8YNFiWA8EJ6uiA3ds
	 VrKHLRykGKba9O07lnAV1F39aa7mXYNr4sLMjv3y+Nvpf/b40Nlz2+gziNHMapicRN
	 4Joh7WXFkRwQTRFT45YOZ+nkDl0hIbTG+5bk+6GQtlGcZZsTVKzAlUYCA+X0E355Bf
	 YBviR/sD5Zqf796TYKgV47Ct/0pHQxcrfymOgE7STBcGhVOIQ2kgGfQ4d0MayHRS8X
	 ueQ+my7+I0BAA==
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
Subject: [RFC PATCH v2 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Wed, 18 Mar 2026 22:21:47 -0700
Message-ID: <20260319052157.99433-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-1-sj@kernel.org>
References: <20260319052157.99433-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55FAC4000E
X-Stat-Signature: 13hroxyb51cyfy77r567danoijxsha5o
X-Rspam-User: 
X-HE-Tag: 1773897729-478427
X-HE-Meta: U2FsdGVkX18odRbHq2nGQmnQA1ERxUID8YKyTbT2pUHKz8siv25yTVqkOqX88/9lvxhpDqUx1jjrWopAUqw8qNgYuN/51AS1FfF7AXWpO3cUOjBvLPm0Vh5T7V7XdcCA/D+G30FPhoGHhASoJ/I5Xx+j9+MUNlmgBe2idcQhU01nXsDZL6T6RCg1kBeUg+RmmNv83Nsc80pTEbCWQkGSOFW3CCEvTQ9cT8jtjGOaIvOYeYkhKDR/buBUNX6lG84wo1w1/8s6S5+st4BWA09W1tQut4bX0xxLzWJTOdQASQLeEUoLtmclUKA9217NJwAVQQIsYmdcHth2lGe4eSjuN3gSv205C8uYtWo1HoDN9zkexQ330hWn6gvVw8I63M0gTa7YseEJ7MVGXEB9N0NL4cdwyQJH1D3bDXxDhVEw6BptRhjgMCxBATbFETS2XyWe7ggD/Uyedkg1rvLkeVARgTVcHqcLVn5zqE8/AyvDgzzbbtD4AhZEuCSIstL4NpYg7MD1fVNIfXSLxcjldQjdtaD+XeJVgvsnOKznOnd6pTufSYnHwc7bqnTKohOktk1IswvetrxgOqivvN8tsMIi7ejEQBJaOhS/Gklg8Zt9Mvcl0UxoeVEYhbyujtB+LmdCbDz+1BB5AB8nXRvE5z/ODBPjHOU3r0YvqcuWBMNbWgWwJg8MWpBcLjhzmdP9z+mxaxSYEIAJmq8Tt/QdNujy+7Lr9pbtEpJn+LOHEZShyMtkAt6Do/9I7ZaymLKIQtrG6SGd7G0So/9vNLpYQ8lTuSBGrPUFKCXST8vahB37ZBSAkpD0KDrKiFPejJgIQW/7eKZruwZduOP8nL1a5I2iDFCR4MpkbpVCUGwC5cuBCzEFVq8N/bM9CY9I85s3e/FfSvocjrbA1HA=
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

