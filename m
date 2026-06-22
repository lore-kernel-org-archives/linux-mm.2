Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0E0CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A216B00B8; Mon, 22 Jun 2026 10:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432056B00BA; Mon, 22 Jun 2026 10:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347F56B00B9; Mon, 22 Jun 2026 10:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 155A36B00B1
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99E7F1401B4
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:58 +0000 (UTC)
X-FDA: 84907762716.28.6145A5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08A5B18000B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HaOQ43lR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	b=M+vANBmU0i+N/2cxVd7J/DhjpbRrjhuV9WuNTEBxhU7jqSNfLuC+cUCO3dQ2rrOzyqQ4TY
	EX4Kffo3O01jABYteFfd999LTnkKCjE7et14CT3UYMWJvGubTrielU5c0lb61NezAEHuOC
	Z+J7kc5CvLbvx7Yf1lpyUzPcpKqM1wc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HaOQ43lR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138117;
	b=eCeqJervgN2zuXkPIJDZswxcL0u0YSJ4otkFgNRLaoBmvhnyzn9okXl+5zPV5qZpdoMCLW
	it77AW1IJAdXbUQ6Nghu62wz1GKZItYb32ln7T2Xa0VdR+ZtMCmwVnjM1MIU0uSuBsPQRy
	ErTWae9ne6zn+MuzWuQj1dcalxpIBmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B2AD601FF;
	Mon, 22 Jun 2026 14:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBC61F000E9;
	Mon, 22 Jun 2026 14:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138116;
	bh=HUk5Cck1sJbUUjMgjgxqdG3j5G1J/Fn/sddbtTw+llU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaOQ43lRcfy8m3lpjg0rvZLlCL77WChg0f1hmlk6691aqFV6NEHKtqtvPMI8QdwLm
	 xvWyyOOg6PN87YOz/PQ0hee+u66Wxn+FhilwSxVKXv32wrgznDOC6wB9zhZSCI6n8n
	 2mJQjCVB0ZcEvAH5Bjk9F5qmMVMXdeDtrusxdXU0dxCVHF12zMeuOSScAu8t7zOw+K
	 F89auxXY3aZPcCbJWoX9VT/SDpEV21ssZtonXSllMn9oY+z1gd/vkxvhK+ozCY/ZYv
	 sVznF/GK/IaIFKvB+c0wJczmM5AnicaKxp+jV8uJKYPHCGIHKr2ZLT2Fc28Hgumik1
	 r7NF8tqxya/Qg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 07/18] mm/damon/sysfs-schemes: use damon_nr_accesses_mvsum() for damo regions
Date: Mon, 22 Jun 2026 07:21:27 -0700
Message-ID: <20260622142139.30269-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08A5B18000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7nn1ce8ypzetc1kp4e719hzpa4ngux4m
X-HE-Tag: 1782138116-766877
X-HE-Meta: U2FsdGVkX18187dwlE9ipt8wUaJizdE0CWLetXmFrAroJUR3gnaacJgZibQoGyCDGydFiz/Vn1BZ2Q1kUFLio1Ee087r98cUJtwmawT4XuFigcb1v6sMwInTQ9tB6TDIZdpkL17qwdQe/pQplNB6Tr2dsxaG9+R2CUFX928/km5zxcaMEJytci2Prv5GkD7wtd+ZUagrpnqMl5Vj3z9Bl6hGK57NQVV5KOnA1gX+lVE3KA/6X3sMKcCMs03ELS9t+vuX5VraR4/hTpIDLGOyqyAroitkSGfO44JzPWRIk4TGnxHrQd2B1QrrXE4O7WWySyHHb7Ura9sgdtgTrvI7AoevfKjNq1m/z16DFQ1t8xS5FyCioJ+iDwZjNRCLwXQiehGlkcRRyQcbPi7vmdTW146fE9wGJapRgBV16z3LvoqRDZgQQbSa/mmmqy/v/Cmavr+gD1ZFPXa5lt6zFdgL1h3znFVNZAHOvWsd6jeCKAOmsf1RMI5w/xWqxzXOEAQFtI7jd+66eaiJQKQbzq6fOPrUcYgAu6tGPHUqeIaSAWRE+XNuVPfbKu8IudCxT/i8jVKR8cMXooOB1zXLw7f315KxZhAc+TRqDIbKs4IBXZ5azcSm7NqeUm9NmRDn5MKgyA/NNMzWvC1SxGQokiIckjW2It3Hjm1saw1bvP1Lkt0d4J96UfBzbgVwioMqdEEjpLN2O9kFJNEQ4XA7b+ZwLc8F2vpJWOgx/r+vgPvW7CY/WqfIdl2/xOb1LB5snP+rRRmLVpXRHMMjb8uOGY6ff7ax7RIVAsp2kIbJSaC0UgG5JUJFCLu7DcKKtYGbHaTHh9dJQCxVqPyycxoKL8+7r3ZUX90vSNMXFJOTnjVt0TpBHrjhl7zUiRJf9h7m0Xetx39rWkAlHSraxBjhjDcauJ3bqGkOqoWVzJKgVCqRkVnYoEd31Yi8wjvSBLHLVIfwFjTmGS++GOfDTrTcZ4v
 7ztJMM9U
 4o0zqcbZCKnAnQ3FLVE5H4cvIh9YfHVfTr/X84vKzRDXJ2RXs4gNE3BH4SoA7ZywdLARwjsAbrQ9ncUoc4Hr+Xf+KnJ+ontiVZQ5VBRWa9w+8IdHcSSy2lKdOXpYA1lPslL16VthWyuHvLCVjKDWp84yIaH6XyGd+PyYTlWyrLZqJFuNHjhQHomg15IRoeJ7pGo8uaijMT3eFtFIgftSpSaNr1IQ56T+dDnpyVwyeBcqvQ0GjVYfbkb/0o2Kag/vQLt+/tJELIFDk2Hr1iz6Z0rz4Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors.
Execution of the function would be more expensive than the simple read
of the field, but because the function is quite simple, the overhead
should be negligible.  Use it in the DAMON sysfs interface for
scheme-tried regions, instead of the nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 9d8fab32b80f7..30a007bcf82f4 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -159,7 +159,7 @@ struct damon_sysfs_scheme_region {
 };
 
 static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
-		struct damon_region *region)
+		struct damon_region *region, struct damon_ctx *ctx)
 {
 	struct damon_sysfs_scheme_region *sysfs_region = kmalloc_obj(*sysfs_region);
 
@@ -167,7 +167,7 @@ static struct damon_sysfs_scheme_region *damon_sysfs_scheme_region_alloc(
 		return NULL;
 	sysfs_region->kobj = (struct kobject){};
 	sysfs_region->ar = region->ar;
-	sysfs_region->nr_accesses = region->nr_accesses_bp / 10000;
+	sysfs_region->nr_accesses = damon_nr_accesses_mvsum(region, ctx);
 	sysfs_region->age = region->age;
 	sysfs_region->probes = NULL;
 	INIT_LIST_HEAD(&sysfs_region->list);
@@ -3124,7 +3124,7 @@ void damos_sysfs_populate_region_dir(struct damon_sysfs_schemes *sysfs_schemes,
 	if (total_bytes_only)
 		return;
 
-	region = damon_sysfs_scheme_region_alloc(r);
+	region = damon_sysfs_scheme_region_alloc(r, ctx);
 	if (!region)
 		return;
 	region->sz_filter_passed = sz_filter_passed;
-- 
2.47.3

