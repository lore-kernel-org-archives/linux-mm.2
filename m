Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF681606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9EoH/ak
Received: by kanga.kvack.org (Postfix)
	id 963156B05CF; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A1A6B05CC; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3316B05D2; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51EA16B05CC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D674D1A061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
X-FDA: 85446641280.24.CBF2FB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D98440004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q9EoH/ak";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968559;
	b=ma6iHxmtVlZk9ctUYTh6roRnwFm76BV+YWTdh8Xy6UoA1zlANJitX4aMsk02sTa77NfIMg
	08v9WIl8mfkD+lh8CSGqbgWfzb/qIWqE7rFsVUc7dqlUoe74LAG+JHP0yiivaSbMiJ29zw
	A+yFQkda37hdAX5acpUg7LfxCeMmTUI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q9EoH/ak";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	b=MBtlKoGltHlSGTKgIsUBQv3iO7unr4sqqrqROa2NB+Zmty/eEKGMYVOchWEhhtXzDp4E3+
	cqb60nvrYTzB+wRtWecb9XpuaRyy9yKC8Qq2yNuWxNvnxR0IWNlPfPfRLoEqKXwCln+ZB0
	f7xDzKXN2hHGeOYEFgKcRoCdhCAWcmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1097061F17;
	Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B561F00930;
	Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968558;
	bh=QzWAy5ljzbSA7LAk4a53ozwyTWaW9lGp6192iqNnFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9EoH/akzg6D4vzXOQRbdvJrRe+I7oJ9CBX9AcLYHdBJz9+kObzZGBgZgf1wDkuN7
	 C0ZsYSa/SY/1YrsHWW5iHiJI0VcCREZsVKEe1Jf9pKWxGFqax8dfbjb6hGeKJ3BR1H
	 pATLEkLnLXIYLVi65DmGRJaEF+MJgVL4iDMUngIAabntxEx+MDVZlqQDO+T3grHlMz
	 HfClme0yDcm4fQj+s0F+H/Vxd7ewx41b4GnfTFAxLBNBHsa4pnw4aQgFu1IMmz+lbC
	 FdHh+q/pMe/NH8eOsNyqcYOiCZzahParKq3LbEjvUrIOPCX5ps+ZudAXL5JScOyTuV
	 tQzkBbKazYayQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 18/27] Docs/admin-guide/mm/damon/usage: update for REPORT_MADE probe filter
Date: Tue, 17 Nov 2026 18:22:13 -0800
Message-ID: <20261118022225.100659-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3D98440004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5hw9rhupxg7o3pjznypd5g85qm6iunap
X-Rspam-User: 
X-HE-Tag: 1794968559-896490
X-HE-Meta: U2FsdGVkX1/argGx97yLg8PgPipDnUl8fEdYupz7vuzCZbw2uaJRtKZS4F8a33zdYk3x1jadvlF3ftaHCurJqfqOOv5tg+UIaKC6IfNwfzCMkWHc8+X+nlxrzmNUunYccz7WtxLoFenKjov/8ld2AdiIS7MYPXjQMrf0mLUE2X8C7aN94rce4Tx2GVew8dglsAIup4Ha7/wmqmiP0JDiaoYXV6+b6qMkFSxpGrpIX20IOqWiUmQOLqgds6gn2MVGaT5m+IHqkGhCxQjWQqLOfTLSpxWs6yhACBf8/x8ttGJJMkJ2Oexc8YNygU6+KHDRmjfGEw1p/qevm7o90PsG8jbpcSD+Yjp9M304tIt12cRwxcfNqsa59jQYuVHk/2dB5b6CLej5MrKvAeUdg1+QoKsjCgzInzsL6SrkBz5YQW5NKurZ7KrY2UAhC6f/31nuHriDIE/+b2pYMSPoFXlf0c1WZTsQgaZ5TGjnWF6eJQ9HZENC8GQZeIwgIUD236HkScesTw1vyqEP9cv+iTAFT2X3c6i3QIVdCwdK0wffRj/7zGf5luce/zi+xxACeN8BL+ymrm87T79kBG/jiSSUVsGdS51MAGkFoZzhaa8QjtDh9eTz3Gi1G1Ix0z5qEKVIrPcZAcyh9YOtsTN7IGBW8rzPDHnMK9e/+Wi4CzNauRWZJb4CPUvH7hamJL2nD/cIhglw+XcEDX+7wk2GR0L2wUm7Tf8Y0za2Hu9cD/CeGFcoFCHGt2Na2Z6++ubAfE/xT8i9iFViFnuDCsUiGOA5nEHt75BfQ/SjWSNn7e0PbEsRD3X+BMe4GbW2T2Yl4dgZnFGnBjInoQ8Vl9zfjA2eKZJOMrMqXv0i4holaFPVJ9wCk4cjkW3xVJgBfZdRnJg8xVnJYwhU1gk4ua7e4Ls5cAYX7TjezPHqFyTHee3lKY6GXhbH4nqz2Beb7KY/b4YDyNoqo+4jijeN3buem+8
 ZmBjtA3N
 rQ0Ik9iyRoDZVzd7WhuFeVjYuFbGmBVMyJKXq5afnvBVPDnuzz485aWWlmjDpLd+3ppMAo2Rtm03x7suXD0CwfgxCUIfwTtTegI4D/jfLvgXO1yKcexr1WxIPh7UyCJPasEacOvWGAlaxNtuu7Fdn6I66/r/JMnzF6jy/RQT8IS2FjjYlArAtLhm8rihGPD11r3CGT3D719WKrENp5oEAzJvRLpBqdXyUwrP6AqJGlUUFU0/f0WT9vry4KyOYu1ZtTeBvnCVzweRO3CLW0vixZRNNonLCTATpnpalgnLfGDmON8RNsrVXx0dxtWplokOT4M6mrs4eceHzj/JEOfwJWX+s+aVdvRBGLtlk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 644250c7bd681..ce4e9e4c13276 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max,filter_report_type
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -317,6 +317,10 @@ filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
 ``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
+When the filter ``type`` is ``report_made``, the :ref:`report
+<damon_design_attr_reporting>` type for the filtering should also be specified
+by writing the type name to ``filter_report_type`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
-- 
2.47.3

