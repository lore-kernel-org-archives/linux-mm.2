Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80DA5CD98F8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8782C6B00A1; Thu, 18 Jun 2026 11:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2DB6B00A2; Thu, 18 Jun 2026 11:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B556B00A3; Thu, 18 Jun 2026 11:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA956B00A1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:15:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B22501C022F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:39 +0000 (UTC)
X-FDA: 84893382798.25.DC3CE66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E85D320003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:15:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALenW2U0;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781795737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDjjHeE3ik/DACcTjgmd/gOCffqc91TStH/d4lyl+0A=;
	b=JazGOAomoqtP+nQ4SsEqMr57URlNyI9hgrAasPVEsphzbvqzH3o/GevHqdjhNpyvxbK5SG
	rD2f+g1yuMaxw8zrY9+HYZcoeNk1PbEq190E/4ghkRK/MstBwvI5GfPSG3q+Ot3UPRaSwW
	RDtvSbwLZOjZv/nGcNhtC2/qBd7f+t8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781795737;
	b=CkI1Y2JyuBH9d9uZfIXSLk62IhGCr9ln2jUaOKKrnr1rDQ+BmEntuavG8796HKXnARq6wQ
	YC9RGEW8Zqn/yxzdJCLpQ2LaGZX81jodggseHupK9FwO3DZ0vU5tGEWbLwLZ/31NqFA42k
	5rk9rnvG93L+s6r5Iy+JolrX+rbenM0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ALenW2U0;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA6F560141;
	Thu, 18 Jun 2026 15:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A146B1F00A3D;
	Thu, 18 Jun 2026 15:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781795737;
	bh=xDjjHeE3ik/DACcTjgmd/gOCffqc91TStH/d4lyl+0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALenW2U0K5kUc27EbhsCZv2lBW6BvHI3zAcUedzVXhwdTPW60prdfnOnJzSD6sboY
	 2Esth1GWP8+y6/iWduNQqFr9wuyGGihgj21KOIrTD2Sut7mREF5aJbWrsthCA4W+L4
	 EDoiMHnlhEZYbp7y7aAFAjUr74Y5N1pnHoJ/FGr2E+VDVvJFM+/OZfZaEuy7g9aJTy
	 rln0BVDly/7Sp0Y9e1UiQln5SFlGwPeRclGXKe9jp5ezyLglUAc1vEkFpfPf23OckL
	 RESd6X6FK8dKbN30OoyuD7QtZFypr9HJNjMwvDZPpReR5Ea3pwUbNA2tOX2vxIxez2
	 auAdbGJ9MQrYg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 08/11] mm/damon/sysfs: kobject_del() probe dirs
Date: Thu, 18 Jun 2026 08:15:12 -0700
Message-ID: <20260618151517.5366-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618151517.5366-1-sj@kernel.org>
References: <20260618151517.5366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E85D320003
X-Stat-Signature: hime568xj53fi4mzgxbyb31bfkka3zsd
X-HE-Tag: 1781795737-820594
X-HE-Meta: U2FsdGVkX1/gCfWuyICPWzgJSKgPtoXSCXdAErkXNbUTdi47Ifo3B0INhzt+8DNyTPsCi+ddSXHINrUvEbRwzgXno+2+x078I0fwcAdDmLl8WIRfGadtr73XZAk1pPOToADR5PCjQZrc012a2Z4B6JJLTzHmsgVbQnsivREjrblDtY9G4BNErQfQiVRwyJBWn3nh6nwbZWJ7hltAncukW+gX8MBdKpbW43fuGhrOKyk38gLIT1b13CTd7ExXnIZeSqhZIuTGDoRolIJlECfeuYp/9lwGutdFDlWc67Vfv9uC2a4PpQGChjCXsPgos8G0ehLyZTGsneYxcCTYXjL4cPORIEJynNuTATdR6rJfs3UntXSdpVVQeMxLTJ/zkFVEdhlkBwoLovHkRCERJZcA6/KHGv0qmqyl3EnCGug9/yqc4tl4645CE1NlHedGvJ7mJNXTtcXV/sg+y5OGzT5lw45yy+EHJyO1+D5tdYBUK1gqNNBI7rxgOt9hQgWioMoKkj/EkptU8DUdfLfjOGGacBU+2Dv48wVC51ZwL+zXDcrWTRMIOYbuqlee3twsFfKGxOHbtgZu8Cpk/FoA2qJndQRScqVlz6mTrewIyoQelpNuU8aFnz4htNj6jIIWZRdPZnSlrKcyHeJam4tko3vHjFY4jFiN26vf28junnF2TiPbh6nVD4qMOfZM9Ds79Ew8/1ZnpkX/qALtSwa3REqjB9G6BrACRhIgH9I5ItdIq9Aw3mU93waMjur9CvS5g5B9aXoquWVSQ3IR8rXCGmhhfzCw6m9IQegIBLLg59LTwZr0WL/lezbojPp2ihRo+tHav/U6Iv4Us2nABe0Iqlb4t+IHoiJrS2NJxh5iS6jGscbAApB74pBs+S4WrF51ANrZ/EEsh60jMpjtvRuvaRC8532InjJz80x0cUh/VYY2iembe0A9CGuYPzg9DgXIQjtJ7QwijVn9gJImQpIDRlI
 uJOVl97r
 Y/HgGAkgy2MONRL1IXszyGAhj5BtI6nS2dStJA01w3JSW+nstAK6R1hwp/HZ+3ln3Ue/xtm17mqWflb3MOIsv2Rbc5sruTtVX4BrWMLnrMDAmYIaIJkHSqkGoicd3FFm/GLtvsi397p97qlMkfT7dO8I2ObuYO/SJD8Nd7apXEjLvPueUEsHc0fTBbbhC9wwMGYjQCzKSgpTETxOmhn/lt/1J6/A5aJTDR83IX2T4dcNdz9vhYtBkYZG+hs1LFRkP7paib91tGcZannLVu7/QscK54Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe directories by adding
kobject_del() calls.

Fixes: bf3ea3d30880 ("mm/damon/sysfs: implement probe dir")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 3c349f0fe80f0..5ca45654cdd39 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1139,6 +1139,7 @@ static void damon_sysfs_probes_rm_dirs(
 
 	for (i = 0; i < probes->nr; i++) {
 		damon_sysfs_probe_rm_dirs(probes_arr[i]);
+		kobject_del(&probes_arr[i]->kobj);
 		kobject_put(&probes_arr[i]->kobj);
 	}
 	probes->nr = 0;
-- 
2.47.3

