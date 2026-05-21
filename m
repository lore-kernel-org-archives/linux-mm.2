Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE6DCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C126B0088; Wed, 20 May 2026 23:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21F66B008A; Wed, 20 May 2026 23:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38A46B0092; Wed, 20 May 2026 23:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 904526B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F651A04EC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
X-FDA: 84790058724.28.77FFE27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE7A720005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S5iXL/C1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	b=EAlN6o7kfl1yQBeLxHckxq+tSX0CtdENbLkz34+V4tTIcwMROq1jvLv+DHdYYOdszC8Tt0
	968tOxTzFn+2aXHR3pPxNfK7GCv8eFbk+Bsh+2Bvd778EwX7C4VPTeCi7+42CfciDLgqVW
	I0+7Tsto6raczfRAuniPqipwK0JUL8o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S5iXL/C1";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335640; a=rsa-sha256;
	cv=none;
	b=RcnKshLjAWXB5eW41U8EAB/ON6oWLm15t8Cs2st9QiwXx5RrtgyIMx7Ja28UOYvDO5svzj
	g7XCQVdCFaSoadi09G15l9Pxdq/jtEjabVE4nNmdDex7fvdF7zJ0RIBqqvNh9RdQWFjIT/
	xECVUSwHclVlFsUMrJTzRIsMMZq+FSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F3B46014B;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5621F00A3C;
	Thu, 21 May 2026 03:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335640;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5iXL/C1blLg/GyK2CQmNtbMwDPo3AXZFESdgEudrFXr0+gB4eLnW/2CoeEHiVVg/
	 CgaueD1eASKKsZ7KwUpa2CtfZAQDOc8zkPdwxVaKguWFWFXjaTv0uaCKWN3pSnW7O+
	 bDJLwVwwIv6EmwrNXqa6feOMeC5OE3lVNUmzwR18x6lHQl1NhFuNDIBEGVi/f7O9/Y
	 w+gDlv5V418PkQ5CYft9a9NKngoHUJjmjL9qoSTcDB383HBoZDD9sP+3Mh9UHuyFq9
	 E0S7nHA4yfQZAaM6YMdVdxPiB9BmfzwprER6t42CCeZK6TLj0rDPrQaoc4futrNIbY
	 dyaxOhRY6+J2Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/14] mm/damon/core: safely handle no region case in damon_set_regions()
Date: Wed, 20 May 2026 20:53:35 -0700
Message-ID: <20260521035349.87565-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE7A720005
X-Rspam-User: 
X-Stat-Signature: ckbi44rw833xyourak9scjsrku7pfes5
X-HE-Tag: 1779335640-304553
X-HE-Meta: U2FsdGVkX18tvMA/Ey5svmtj5ZQljk8Iy/mSFKVQ6jfOrKGvju1GJIplYodDbbYxWMIuk/dzBJsC0TN/MZnt+kPdE+E2O+U2noW30TrDAR+algksnJWhlhKvi4wwI4TN94LpoWUE3OlblXwSm3QCQ2VN4cMJKe2KDdxh9WCyxJu3PduaCK/caDYWH1mkafl2pIAyKMV+T4S4oPAfvEXIMpUnh3AgFTJmj8rswFjqNafQceUSHu4fScL7QaPkIlXl7rCjTY2sl65c8ojzRaKulD9gFcA+3DOZX8qALxkFfu1qav7O9Vp+M/DlbAvmxPUEhuYz+6l9azqyD72HgHec9cEvMzkrHlmaj/woVOneWLOvWMiXNV9tMbkL3iG15JMBTvoSfvyakfgv1XkXFpriaR0+NaS3WbshIbJVmpke+C0CgcuH+/b2UPQvazC8Gpv5viOeOAKHZX3wRFdAqzBZ9Dqsp6F4VmhQU5xpO1X7uNkggIKVow0BAeq4Ee2FiytnZbajkBrw8KLsQKTbmDKpS6AqoLho9gL1dsAYdosWfygZ031qKmmMHZ2tcSAkI+IDUWqJX/gmdDYw/llz0Ixdgse/2TlOIDLlKJnhf9RKvTqzs+/v8kyM40TR6+KTWCrsYqqIOFsD3tTVxpLtChHK595RsVCNRjFoNE+YFX2v3qE+w41oH4j65+zG5Al0EdYMsycxz8ltShkcCJJkznbWkooFs33vtNdJ2nwcV9P0UMGr+F6yOJlYVnI+toDWBNPCSzbzl23iuRMOSZZ7VrFHlU7WGHmky+lKT2jtUKml7VOUOptrBVsAvmBVqEcOhmXgQF1gGcekaertBHGCXqV8YgdrKGVykJfulCtQ9IOc5PKRhCoEw9TVR360bGpwY/Ax+iEqjMxQoCkuHK+t8qgQLBoPtXVw3zNdAAIU5AfmMVDUcavGBVuOv/2K0p03I//uR1UU2SZAfn7OpIoQdeH
 1tGSBrq4
 O+D5rJrvzDwuwan3xogsEytqI/HKO/DNHvuCALUNNuOllRVZLoGhPzvPgIe5ctkBU7vR5RWaSHxM4ZdnTv1uVJasl4TlEfp2gxEVurNhqHwymITjmzleBWTY7CHQ+5z5aj9msEXCAcd+dhObESO6/aRzWekghtBASMKyhndgGrxizQMjMOAfZ3i4BAYBoSiQYEdBY+IPYqjaWNzr0+HO6IJImnJM7+BBjT7lsenbTddOobaWEJM3lCONX+hkxhRY9BY9PUfJPuudXWgO8nG5BJxY7xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() calls damon_first_region() regardless of the number
of DAMON regions in a given DAMON target.  damon_first_region()
internally uses list_first_entry(), which clearly documents the list is
expected to be not empty.  Due to the internal implementation of the
macro, damon_set_regions() is safe for now.  But the internal
implementation of the macro can be changed in future.  Refactor the
function to explicitly and safely handle the empty region list case
without depending on the internal implementation.

No behavioral change is intended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0267faf216b95..40946a7f6f549 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 			damon_destroy_region(r, t);
 	}
 
+	if (!damon_nr_regions(t)) {
+		for (i = 0; i < nr_ranges; i++) {
+			r = damon_new_region(
+					ALIGN_DOWN(ranges[i].start,
+						min_region_sz),
+					ALIGN(ranges[i].end, min_region_sz));
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+		}
+		return 0;
+	}
+
 	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
-- 
2.47.3

