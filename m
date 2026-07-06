Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29362C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CBD6B00D9; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913F16B00DD; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765FE6B00DE; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 484F96B00D9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CEE5B403E7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
X-FDA: 84958559406.09.76ECAD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28F2320005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSunxpRj;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	b=3bUHqf51LJBTmWBUec8/LQUOe+AODJTI+pgoFxh/Nv639nO0XRfLyq9Dmih3n9zsZi2NIG
	SD3EkYbqaImuZhhUdE5kgCzi6ZtXwxniueiKyJbv4wWPRjngmRmz9eFjEbpFU4tHx71jAK
	nSFduhJBUj3M4awzMskQYKL1+lefODc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oSunxpRj;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347562;
	b=wr4nOgzZjAAzyLV/yx7bzXL8+vfqkgY83xsuASg6MOuCZxbGAVuZ+i6hSAoZwyMpsSiBZ9
	9XPyD6GGT1glMw4Y48pwkqjc8TkQfksuI7u+BOPZi+B3o6mbITFJ6swevAlS4sAoBGmWhe
	lOT0g8hYhkSCAxAcgnjLxBrnzb+e6B8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7EDB61389;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4970E1F00A3D;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347561;
	bh=kxd4/9TvByhr/rgk5a0bpEO5crurTcFohmlFktpxcC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oSunxpRjE28G9GA0pIiKIBiciz9OXBfj0HCCNt35BZmbbKfunTBrJacFk9cRfWWPS
	 JBlWqj4jpLWM14tYAQtokzZqixToRVeG57Aw/SO9VcYZL14zRYsuA7voGv54V83R8r
	 KCDqQLx12eLDiteQQe5vinWoQOS0vQFveQi2L/XEwccnt5/yasFo6OsmCBu330tCor
	 nBknJtSAqRu7d/l3X+gtMeZ+iElWw0TTaji3O34nvvuMI3KosTcJpEL3B9HyBlUC2y
	 IMadUo5NjiRZxIK5QKocT81JnlQioDKAc5Hkhn699/TDKCcYYelriG50KrsEv1zJdE
	 uXJITsdwXnPbg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 03/16] mm/damon/paddr: set samples in apply_probes() if requested
Date: Mon,  6 Jul 2026 07:18:57 -0700
Message-ID: <20260706141912.88445-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8szqajef9xafe6p9nuw6c3i6i7opam76
X-Rspamd-Queue-Id: 28F2320005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783347562-648849
X-HE-Meta: U2FsdGVkX18wv7hl3O9ZqhSE9ohaQo4unxQxf/sx8LHb6FFqTEV5XsM1qwLkcMxU1ltrAMfkcfZyhQFL6YvfMJMVls5VlabfcXH6qoKBGDNqVpdjLxgpk64qSwOAkI6rGrPoDtILuI4/g2VM4LlrCiBw752O3+rKlCn72I/7WOETmSbBUBY/ZeZ53E4hzlvKnHFxn4TYeYiPQIMHTMFD2qAaWZK1pufYEtii0waEpnCnFkBVd64YX+2vMRSmcC3h6FcnUSYRqLpI9W/F/zkoSMcW5Xa1MDPSVAFy3BsUAbTbbDQebNkb1e3ACD0NLOaCLhtqyn3fH9x2T3431yy5yWpSgMt19mu88UBpfo5Fy9hG8CHAFv+IwjCECkeBeleJU3EFWedxZuzb7eG6tJH0TMFEfAZH/wiylmii1oW4ntcx6zzwKAu6SbZB+ElJ+iwcXrxttpLbfFPX4ijdw9/Mz6TJ3Xc3z1WaGqCK68JW7fHCUOSogOUhXTCiCRl0vaQNwK4ebyohx/9kRKbSmv2DTN6iCPSbz8f6t4PAILVtgRsQaX0nQVMhjEMeEqFsUYXfvj5IokWp+HCE/13mviFRVCR2MFIAL/ipKSiSUIOAh87xxVoVenKURpxLT9iZ04KeUaTCWVIJI/fNZOR/nmJrBHWfyiHhTsijS9+C47x/M3Msfei/C6cmsl1b8BmqOFmd+pJ5YYjhFwWAWXeGHh/Iiy3yGI8LOESENSC/PrdwVNwV7NJwBhBIV2XWNVMPLVjO/xssToJe+0W0ewRcfkwvsMRBF9yDCC52+wFI1dI5jW0zcLYKPS1MXYddvx0TelbXVMjsrQs3Q71vODIMfeGk+To4GBPAWH+dF/pNsZTX0cEw1OJCxPH2rB4+xMW/cgI9g59XuvOuuN76Pu17yLc2nEA1LiUtk4Acp1ZfyxmCxNRcibshrqNjsAaJOaHvL36MaDKTBEwjYl4v0glx50U
 MyDZziKk
 xQ7zoKHn2iNuQhUZrAdjH9XdKoo6PRHfvhCoRIsTkzvFfofQwuKx7RT8CoWtZvV8OPM7KXLlUZ/haoTJMTmViBGYC88luwZT3up/aAYn9rAr/I0hrYn1bJKFRJizs0oOkplzOTvACXE2ps1rhfjTF93sbd614vc+0kcBfUCe8uhRl60nPKNXeS+y0elu/WtqS6EJUPrHZ3sMsbWqSYOWSQ/xZBPfYkR8vENhF38nlaf0BUMo0Bjb4lGzdUk6qzeIkA+vfIezjj8izN2K5GdF0RnGXHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

apply_probe() callback implementation in DAMON_PADDR is ignoring
set_samples parameter.  Respect it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/paddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b13bf7c6eade3..ff4fcca949660 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -178,6 +178,10 @@ static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 			phys_addr_t pa;
 			struct folio *folio;
 
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+
 			pa = damon_pa_phys_addr(r->sampling_addr,
 					ctx->addr_unit);
 			folio = damon_get_folio(PHYS_PFN(pa));
-- 
2.47.3

