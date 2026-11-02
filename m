Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867DC609D801
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eD1h06hZ
Received: by kanga.kvack.org (Postfix)
	id 6CCA56B060D; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657816B060E; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51EAE6B0615; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF2F6B060D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE1C0C0160
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:01 +0000 (UTC)
X-FDA: 85390562082.15.0FA165C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0BDCD80015
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eD1h06hZ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633340;
	b=FiCW2JvJPnxaVwjBXiO2jr/NuotzV91OpzO564C+9Uvb9M5SDu2hmeAbcLoQTGISZD5ilY
	ue6wNuNwt0ksJeiL67GzdHBGS/pfnuHm3S1hhv6/5oG9cttDzdV7QBzkJRluDBLsXfHV97
	gIyBIhTL/XB5VIVYj7kdkrorIFqdm64=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eD1h06hZ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4P5FOKS7FmEJpE6+fz4O6cuWQUWbxagUHKZklOqdlI=;
	b=mDDMeGGvb62AstGCGMSV5eL+tbWcvfm1L50v0l18g6PicwBiium1rCZQwSIRSUs7TPHo/h
	a4T6Jpzr7QDgFMrcvTDfgBp1vhnBytPlsjA2zU9I9CQtfyRu0po4ftG0Yv1xPMzcb6q8Aj
	c5Ezk0KCVdXxa3D6/J/DiH3agb1bsQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E19543483;
	Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85231F00A18;
	Mon,  2 Nov 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633339;
	bh=a4P5FOKS7FmEJpE6+fz4O6cuWQUWbxagUHKZklOqdlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eD1h06hZhD6ZYQdF9GG6DwkBrd9Qz6+vOdJQq/5lCM3rL9KuHY8R5OgeJKRESUkFG
	 W5n5I2VfakNz3O7cZgetbMye+rYRt4WMLvMyVSpejl1oHWVBs5+VNA/1gOn6XfyBM2
	 wMhJhaLrxrn2k03gkXJuWqaes3am26H7Hvs4SUkAsg0Bop7eZXltpJPY4ouMRnn9UW
	 2V2DYah4HtUhfX6V9AEwLJGGBZvwBHP1BoyyjirrDK/SoSWhyBrDEks7B6BKOEPAek
	 p/fOz92wVJOc+sbM/e6OrBZPlKAZ1ZGOVuQkist1yjLrafRmxToA59O3ZqMW8Dd8bq
	 bDaxrUVkcmnuQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/3] Docs/admin-guide/mm/damon/lru_sort: fix copy-paste mistakes
Date: Mon,  2 Nov 2026 07:28:46 -0800
Message-ID: <20261102152849.96057-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102152849.96057-1-sj@kernel.org>
References: <20261102152849.96057-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BDCD80015
X-Stat-Signature: kcdseg896soss9yaq9eo8ryz8a5351kf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793633339-32502
X-HE-Meta: U2FsdGVkX1/uehoZT3zZL7gLR9ugYuArgdBU9qJFxdaNUA0ZOs0RXlbiYi68mNmT9Lw/AjZHIT1LCibBBZAiHkHjNoFEgMpT6TztDbT/JBWow6+r0DV3YtxjuGuqUg9xGdUwCLBm1LueKKy4T53LKvM4vw7Xm1+6zjMdAy0MgVO/QQFHf7p0h+O+UU2HfB7N/IYOgayLzaPJ9VX0TOaD3KK09hnS8Di8PTq8EAHaAMOOlssYcobzLSXFI8CiEKrBFHky6ZUHKxTFX9DaMNbXQpuzHnKiFtEZoVNTIYi6qSk4TUfurJhaljVVqo2XNXQxffcFY0x3fLrPHqj/j6armTBkC2xmCiHoZu44YDQnDVI1WwNhr3UKFpFfh60y6rT0tXcVFyZw6/2854+KHRHmpnxfS3n7WI4IRIfsfWk2DnBKcqwY/+oULcUq7jDvS0c+kG78QbIRmbSOFp2Y+V4yyspi6coOdb74Cc985/XlFzJ8J3ZGB9jqJKwvaeFRp9GLGE9RWOqz/QSE7Z4NHHt0bV56szlkxrdfcwfy50k7Q9e9eRiaHkGKrgi8W7LXhtjy0bhF3wLOhinAP6HTwamX2zakpHxsbzZdHqOxCh2Q6hg9RFk2Rw/KKIGMhAhp5xHj0g77Fkapc+6JQnoTNO+uV09oQndgOjs1stMxntfxR4mb5Z0fWmi2l0bf5MJmC7eBRG/GGgGUD/F/PRLeg7pW29wbdUq60Cg9ht0lh9Sdq+raFJNJpe3khnzxicvIGUTuh7pvx2EmAZdXUkZO1GqMWwoJ9lcoL2EQq5PwirZzUVELok4gt3KMdrMXTlRzPgqQ6e22oJzFyRQYV6/d46OVOFbUEjauoZ3QWMoSgUZEZpnA0gO1vWNYK7kOOsk9/7SS5W8aMOOg/FB0wA7kbeJ1K1FPKhtcIQyy2DMdy0IJ2NrAZX+wzfAEq9v/mnov6ueuSbfJnhberiu4oEc/w97
 qJHtQD3e
 99skJyZ/9yWnCDyY0dKty01q3Bxf5khj32FkLcKd/wRENBHGg9g2qcwCidf9rNaGs72dBoy1Arqyhn44n66mc3oBbFhNo1NbMLGCDLRc7LUSVBeqPw6khmkz7kdW7PVf3Xn9OjJ/E3ErlAOqivF7eMtV2c11U0YEuvbDsmLLNGoIPpAgCGP2PL51P+wj84ovq2k616+sC4msOf6UbYyjCGirdR7wmWFAhnXZm2hu+JMn6RWqAvXdGu0QGRzIkvxvAzF2+ncSfoubcSkA8hPakRCnLs1JKsa6A1KhpKa3T5a23FqeEPUmbMpqgNAxa+oBQAHGAcZqG5E4RsHseLF44sMsvhS6SocRDT59xsdW+ibKLkcoYbTX41kuFUpuJ7FpFGnsinF7Im/hDjex6WTzALzU/9toNuAdpLvbCy8c2D53SRUnxK9lqpW5FiMDBf7OoMiqOa/FAx3SwMtMwnRnuMszKB4SgcGai7CKA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>

The DAMON_LRU_SORT documentation mistakenly refers to DAMON_RECLAIM
in a few places.

Fix these copy-paste mistakes to correctly refer to DAMON_LRU_SORT.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 02ea694426b2c..aa4cc90ca57c6 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -263,7 +263,7 @@ addr_unit
 A scale factor for memory addresses and bytes.
 
 This parameter is for setting and getting the :ref:`address unit
-<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_RECLAIM.
+<damon_design_addr_unit>` parameter of the DAMON instance for DAMON_LRU_SORT.
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
@@ -346,7 +346,7 @@ memory regions that not accessed for 120 seconds.  The prioritization and
 deprioritization is limited to be done using only up to 1% CPU time to avoid
 DAMON_LRU_SORT consuming too much CPU time for the (de)prioritization.  It also
 asks DAMON_LRU_SORT to do nothing if the system's free memory rate is more than
-50%, but start the real works if it becomes lower than 40%.  If DAMON_RECLAIM
+50%, but start the real works if it becomes lower than 40%.  If DAMON_LRU_SORT
 doesn't make progress and therefore the free memory rate becomes lower than
 20%, it asks DAMON_LRU_SORT to do nothing again, so that we can fall back to
 the LRU-list based page granularity reclamation. ::
-- 
2.47.3

