Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F31FF10987AF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B326B00BC; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4CD6B00BE; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446D86B00C2; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 295376B00BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:35:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2BDD1CAA9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:14 +0000 (UTC)
X-FDA: 84566991348.23.CE8695B
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4B061C0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=IQcW4itx;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=;
	b=Tsw42etOchKgYdukFv9Q7mqnNJoqdcAqVSbf2m4PvwKAUtY/AG4w10qOrpYUP/Sk+o2+9C
	CpL/9xmiAaZm3iPJ77pdo/IYd88Qzp8jWXbwQ4MUaO6/Ei8+o47z1SL+ErDUP6u0GyVHiZ
	3uCPHmy+5WH0e+3WajXMUQqn1VPfaf0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=IQcW4itx;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024513; a=rsa-sha256;
	cv=pass;
	b=ozS+AQ/OhiHROUFoT0gAJapqcDnDNxk/x6LghSos/eQr13RBTIKlZHniwNyAGMPy5iu2aQ
	DO8uu9PhwzWV8VnL8aho9QBGQDNpgZwGwnNECS2aslL+0zpR6zfUvOGMxAETF9nqmTlEBA
	jQLOTd9Ba5RccpVX0cstUDMt/BcgzBA=
ARC-Seal: i=1; a=rsa-sha256; t=1774024502; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=AM95RR5uphhvbypB5zZcKQyuhQk7YMVitMyutExXVXZ+078ZMhENcqQ4t4t5bYAAnhKUTNlitxmlXxvKYgIB6SIw69NG0mqK8yRCcXu2EbwUaklxT/oGNdGSsr/9QkTVkt2nMxB8kIlDvWiH+y9aY3txUm6wzT+UBXkO9syUsf0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024502; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=; 
	b=cuDy398xA/BZzFaZTgMof76ZrElybYuGUf8hItLNkdOBCv9YkNMptn2/xf8hQUQLPBdyMXpX8TflzaI+5oa34xe0ezAruNWVe5dzhLWarbJzsMAm/gEhxxoLd5lWDVZgWAZ36h5Xjw8jl3prxuduCTIQ7IUbOzPGKVZ3X+rSmmg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024502;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=xBhz+FP718xfFTo+Jqt21ir9B4N+Sz9WG+S91iYYSqU=;
	b=IQcW4itxhvSjAeWAkGS291o2DHx7pM5CdohtNSGbnTqxs+WUqdeJwdjvurN/QrpW
	04Lvw8t/1GQZclHqSlX7vM6OJANpq4L5JYkNSah0AKN4XpDYA11S3h1UFaRbcil6cVS
	WprZNJxRuvTKTHqmGgHi+sYFNzb2Kztm4LtMQm+M=
Received: by mx.zoho.eu with SMTPS id 1774024498762636.5600957673564;
	Fri, 20 Mar 2026 17:34:58 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Fri, 20 Mar 2026 16:34:55 +0000
Message-Id: <20260320163456.177750-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260320163456.177750-1-objecting@objecting.org>
References: <20260320163456.177750-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: x4bc9meazqgmna4ybpuqkrewxycjg5dz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E4B061C0003
X-HE-Tag: 1774024512-161895
X-HE-Meta: U2FsdGVkX1+VYty9Q8dASlMPfnG7D5faNlkdP0zmWfULTY07OexVlupX6mISnlRDzTQVyTFwmDe8fAZyOiW/YGAMINkvORN6Wq02nI5j0tJIVpAepO66WyUb+5kG6mmLnYWdw+HoPimCTJ96l0ZZhMX9UPI7AAKa1kB++ea1ZZpHPxhCeLppj4xMTMF/AGd96kRD/8hiY2Cn40PkYDlA/Hj2BnaEDlaCS8T6ARWX2Mj6jxjqZWKCOVKUj7PWyjr7FSjpuotF0doXdMXtHk6TujKqCsPEr2ngPwuQ0jSIMYcvmNgu3jZZ6CYLGEcHOSwHRsvhu0NNE7FHN0ML4XvhiyIEyjNITPAjojB1W1ETXVi2rcXfYFOkzGML92cRrKZDLCsVMe7z/WjWNLNCt+sUmwu/AlvG16RCuUupb5Dn8Pfpa1T+RECd7yS62X+njfVxhCBwgh7D2xgtjdZFQWNBAu1mGMqF4I7goVVBCoDqjXOZsA/F6QtS5hmjbVghlv5IJeKLn3BXVN8ovD1jJPZCkMwgkJtYClsEU8lt1FMt9nz/3EOu7TqseGWcSv7DFHkiESHUGShqu1uFKOYFOy5kgJbtDjwmXbq8mZXFEY4XlNhAqs2vhPAHLXScuSBPsWsKD3MbLhbobKCpfZRidlhIXS1z+5isKLAQInAjaDMwb+s6zReyU9uFD1JLcKzVN+NxGaJ5X3tE1rnYnaeyTEI+/KFQjb9Pr6qNOjI9GRrAurcvT1OGzYIzxANiMGkl5J0h5jCvYDcMi3haaCVMr7BwVb8SZz0psTftarE2CcX2JAD985xn4pC8uOsSTGrOKISlsds7lyC3CtMyaBweqH5nl6dGAcP6CKpdscNJWutbPFe2REjVClCq82QE/Q+0AN7/5lH1E/O7BIx/rID4Uykh1R8x98gjacVhI4HRCU+OhLR3uD+rZyf/I/wEQqIl/gga4CZh3aClV9cQuiRKdqL
 l84fm7lO
 HKMfYBuO83JSnEn2HbDm09VYzwnq/qmuhWfhnVEW96COOtYRNPyqhB13maRLbNio5C+kaZO3xB9wcvgKYiBWznwI285Lm1rpEXwUJHCtEi/0ymMXIvEG9tdtSIo0CTG2qdE7fhaUAX9goeehyzC6qOEq8USOJP6fO/Xy1uYLTR7fcNRdsFhClMmVLrvX9MzbZYHmIti7q/helvhEnuIaVWXEsnvwm27VsA4Ij6akrs5H3JkTbNleIKD1kAVrUZe55H9g+bCxjt2C/sLr6lu1LQe53f7Ram36JjIaGBeoiVhyfUcDW14XQK/vkzB6vfc28IT0jKiRRE+B2oXLVLthM2t3OxndfzHWOy0lLooJJ4BuWqACKGfoHqA3/vBtvUq08zt/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that nr_contexts >= 1.  A user can set nr_contexts to 0 via
sysfs while DAMON is running, causing NULL pointer dereferences.

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Cc: <stable@vger.kernel.org>	# 5.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b573b9d60784..ddc30586c0e6 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1749,6 +1749,9 @@ static int damon_sysfs_update_schemes_tried_regions(
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
-- 
2.34.1


