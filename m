Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31DFFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A636B0095; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B02D6B009B; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703206B0095; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D64E6B0096
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01D2D1605E4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:38 +0000 (UTC)
X-FDA: 84701905638.18.11350B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 589071A0007
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NVBouhCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRnV16Iv7S+9fhtAyr617zWWEPxv8TqcPE0NZPy1BZo=;
	b=Wdugna+Vx9Xb3HFghwAqMcH5tw8y2EMeG/Ira2LOmZ8y1fdHg8P0g48QkTOLOUUXH6zTDw
	ZltbKV3RljpZs65gqDvn8vbWGdkb2I5nOnIzKGH1mceq9kdbZSk/SxpDXowz1l2/Ip2PH0
	09ALgQhiDRRdDh0nwvdY9FlPsNfvg7Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236757; a=rsa-sha256;
	cv=none;
	b=Fbufd7CjHYJIlkaBNFn9S7xn+w4p9qFNy8ZoxdF9JyiiZzi+VN2wD7aF3HypgJUC8PNRph
	eCDK+xFeaQ55vHntyAoCbnY95fjILnzyzY2fqTH8BMyeJlJw+KrhuRguvIaPj+WnewoMYB
	lqwEgmKT0ptT+NgTKDJlSPoIZ9uWRdA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NVBouhCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8975841A72;
	Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC08C2BCC6;
	Sun, 26 Apr 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236756;
	bh=wQ5jrgZcCcBYXHxkXe5BHmR4YJYJ4CSttqynLoS/qrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVBouhCnGZ8rz+3zC5fPPGDXlLEnJ7IYAnHrjKhKdRldcrRnYNjB/4y0E2qWRv8Ko
	 bYZakYEIUOv7m+AXJ5r+WN/V1lcdPFRmVoso3wXahATS8iBfrm9flDwD3TJMR4qnbE
	 V33sUp57SXx1Livw0cjPDxcQYpJceJg8r+/cMo0T+P9pBSg/7EWKkhBzLBPS3g2u/X
	 sGl+oHOVYRi7dz2Lfe2hZvMkqLTKPwChlcd19cVf0VLS6OuL0Fk0E340N9FkABj817
	 U2P5CwZ0/1j249CEcMzQVZizaCZ3LfDfsNnREc0bAuFUv7o1adK7Gy4fbmXcxlk8sm
	 XRRh/l3wyfAog==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/19] mm/damon/core: introduce damon_region->probe_hits
Date: Sun, 26 Apr 2026 13:52:06 -0700
Message-ID: <20260426205222.93895-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 589071A0007
X-Stat-Signature: 5qqj36im6u8774sexcrm15b7cymxoz46
X-Rspam-User: 
X-HE-Tag: 1777236757-439616
X-HE-Meta: U2FsdGVkX19namdFjHzhElsSAXaVryKRWotMtC6Nz/xUVnnOhGx2TzCnnPvH0E5bidrwBFULX6Fq1Om56WolVCTH9ap1y0WpUfBe9lDR+8uMMm8coZnbsjxVmWZnoEM+JyynIaAeoNjtFGueNj2fEA9Jc5fgrtSQR9+qWT9NW3uhRYhGe3sJPG9LDtho9auIL7HSOdLAWPBRRoU0z/pWzPT5PdEmURzMVzji8eSE3UHbhtPD6sjYQ8M75/sMZcGgSOhLRjyy8qXFpe4yM2/tW2JYnGKy01dX6BKQpgZv9PfFaH8eK6VyA7IG76gmfLn6w+rRT/zd0uIq3ZUXeEVF7UX6jNZJslQ5PAkclQGZlN1JPSezMmZ6O+czSyWR20tx7owXVtFLX2arbd5MtcOknnKsUbV0TmOF3dne9Cd2sOmq7l06LEfEj6eaNfFVuCjtT4er/7ap00w2/0NTEJkrYhZDCh85eXWbmr5olHJTZxlV6KsUpLToW6wZ4BWi5FUYYN4jDmjUAfwHC5ZHSHah0m8X/dPQbPo3Nmti5ZUXs1y+BNsORm+YeTet2Bvz0H/Ke0XZ+T/DAr/7sQZ6bJiKOFBMcFq4u+SgyallcEDosZbSoHIbLCxS/XLOepS6nUl88j56IJNbTQCRHbtZ6LAayb2fQ3C5uZlymKd+4lcrZtG5Wt5H9Dqd+LGUz6Ek5sAk5Q3ESK+VYWtCwmoivUBnJIAYgdQXEaSyl+XMAqRWltalSoZYzV0K5ivOKhh0kcdZVfRJ5zl19wK4Y2ZVIf38I41VKTka7ip6S4CyZHAqS8q4mksZhVae7L8ApYuywzdf5LCOZJ4uocrcTBPrzjEEeXefpH+bgmXbsDZLjdL8DUEYVabTJmWlaJv7dsrHg4df2hotlgmey+MMQgi//g7RmaJwt28oMzBi4K8hOgoLkqKp7BM/OMJ0evWxVq5p+7NL3gGOBPkz+VdvtCMt1sA
 rgZ4sVY7
 dTafrHuFvVqvqs8OKdFFfduRHvapr3bxIju3yW+k6j/blKtpSP6i+EDzZpuyMrlCa+vkLq+Hgk77Sc3srWqS8XZ0FdHYb5kZRBVwkm7/oSbXTsXQ88ZHcCzO+2d38RMng2ixCfOxJHDtRV0+0+rauz/jZ8Yk7mOkwO9zJ6o/EJ26kakPCHLb8weMjFV9djH0Lsf+0n+2sqFXc7LyVjQFWsl9rqrfQZv4cJ84XBiwyLeYxzuYtQ9yHzNL5VJMtUELw/NlRfNCPNVDTu+p4FsH+PgMvtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 mm/damon/core.c       | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3290792eab547..766d6daa52a3e 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -16,6 +16,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -52,6 +54,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -80,6 +83,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2ab1d6dd47da4..d4779b647a495 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -225,6 +225,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -235,6 +236,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
-- 
2.47.3

