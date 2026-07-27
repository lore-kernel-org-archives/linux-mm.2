Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48ADC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0DD6B007B; Mon, 27 Jul 2026 14:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891936B0093; Mon, 27 Jul 2026 14:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 780ED6B0095; Mon, 27 Jul 2026 14:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41FE76B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:12:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE4E48017E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:12:43 +0000 (UTC)
X-FDA: 85035352206.09.9C754E1
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 39EA314000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:12:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDAKI6v3;
	spf=pass (imf26.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785175962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3wYLZ7xaCueJ0HKXGOYqw27/ElSiF4nHj9CgFbPY+D4=;
	b=7FZoSU0C5mJ/FMB42Gcm7ddiPFEjPb29TglaFaiM4ASHLYMw8sHqcb0pqHcJMc/e+O8u18
	iZLd9+FMnjbwrr37xYxCmRdyG0nzrdBNi4oCgezx17FYX7EqpJKQierXFpfSU9m2jndXPv
	TIn8r5zulofdbG18PMQ4vAkSXTNPQrw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eDAKI6v3;
	spf=pass (imf26.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785175962;
	b=DMZhPI+UGpFt/9mx2MHU8E6ok8n1PGZmaSob3r4TS9XyhoUGvJHkVdBzsoGJOBtznnW8CS
	mFGXDcMUDxXhOep+WDj+v4tyYaqKsB/wel/Y0T7Imk4cNJa5gmlX0cnkinQY2WFAoIfAvW
	dUVHvSG+pWvWZMjTqst8gQk8hU0l0E0=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so28009645e9.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175961; x=1785780761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3wYLZ7xaCueJ0HKXGOYqw27/ElSiF4nHj9CgFbPY+D4=;
        b=eDAKI6v3IOFhEU22y5ExoFbsJjpD1ayUAWXj9etM59DoFmCIo/2SrrzrqcmTRrIIkL
         2MdmUtMD/fwgZ/ThANrBnUhichJiGVBggxTkOp7XEjPk4ddxGgEk+99Qshu090Camm0t
         /sqJKxSSKU1wrYEtxeGv20uD7+jUeszQQDjrVml7v0wd2kutSdXQgg5diRpSkOnWyDOm
         sxV/JJ5+fpAug1Tp0V25sZh3tw65P/Sdgj5nv7VW99RFoWR3+kCTu6kJgg0Fpzvpnhy+
         lQKNRm1M3+q3YLPrgcvnLpv34ymv7LT9jtgWDOTg/RV3r6s3kt9pza7DkWs7laApGEn3
         h7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175961; x=1785780761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3wYLZ7xaCueJ0HKXGOYqw27/ElSiF4nHj9CgFbPY+D4=;
        b=VoMOGTGbIino/UHdOjbxiqXvPoAxcDcRgN2w5wRGsUlGAB5tbKGBkhvLm2Rv6X8H2i
         Vuec0t7lPKbRPNRG6qxe6B1dAeh89ThydPzGDXsY8tk9VJz+kCxWTDyQD07knzoxEdh0
         RvuZchUUMm2Rj2rgOeOQbw6d0kPGXtMUMTW4sxNap+rURZlaenWQjnIliOUildzofnYr
         c2fLaFFSmHn4COCemAmDCWm6YyRTWSgIz0J+6QISLwUQ7kK4XNAImwAZ2qclyHuMNaqv
         aZ6rp3KnikxOy2PY9AdLZYp3JIN8jwrFTTgPKyXhvzx5YcUuohEmkHPJbs8cYbfFFCFR
         yJcw==
X-Gm-Message-State: AOJu0YxlZCdKDASNA/eUP6FTF7bTAtavcdgR/b62vM3mwz3J6y7J60if
	XuQn2xScKHt+d4Vre14r0X1kqoe8L5rwrGAqN/in4GZgI7Ow0cziffzj9qZ3x9Q=
X-Gm-Gg: AR+sD13u8ZPX/oQm7QH+XH0VLJJWvXfNx3dbFqVEqkROt/+tdDKagj6X7NgjJwAHNw+
	4YBSE+OpZU2B6j30mr9HNIAInB1aCuX4l02oIP/IP4fAIReIUc7T4LfuIEUlfgfs8MncOFZKyXq
	nSPVwZTy4xo5kLcuLjZF6kTbLNc9mz7Az8zVCw1XCrm61C5upzVU7LZR/y+co6dkHqzFcnH8hUJ
	GkrgXLenDB97TdMB9PfFbgVCi+WS/Mk3UrSlG0XXPjLpPBPjALqm5pja/0ZqIxfHEtLo6vtnHi3
	Q5AZ3b+93Do8yE079JksCJzAeR/tfytZBxLaSPdUeR9lfG+x9wiyZRWQpAGlxo38dVITNZ6Z56n
	lQvSGrrc7QBmc1LbQ9PEJyDU3dILEAXXc0qdgtGX4P+BIrGavuKs70Pe7cm4n+7XRXJPMxgjViU
	sfdN0OYGSBc/Q+V/6vheVpC6iL1FD5+6VodWa1kD9jznjhtMeCB5G+6tXK+4OcE51OI00IE+3K5
	tICe4Tf+Pb21ZJa2/KkSm3SOspe85UM
X-Received: by 2002:a05:600c:a4f:b0:493:d741:5d72 with SMTP id 5b1f17b1804b1-496b57116e2mr151773555e9.38.1785175960626;
        Mon, 27 Jul 2026 11:12:40 -0700 (PDT)
Received: from archtop.localdomain (92-242-248-94.broadband.mtnet.hr. [92.242.248.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm53643668f8f.31.2026.07.27.11.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 11:12:40 -0700 (PDT)
From: Jakov Novak <jakovnovak30@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"\\  Liam R . Howlett \\ " <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-kernel-mentees@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakov Novak <jakovnovak30@gmail.com>
Subject: [PATCH] mm/khugepaged: replace mutex_lock/mutex_unlock usage with guard macro
Date: Mon, 27 Jul 2026 20:11:36 +0200
Message-ID: <20260727181136.2542-1-jakovnovak30@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39EA314000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 8yexfrtyruqc5tonnndx8o9ac3qs57x6
X-HE-Tag: 1785175962-220655
X-HE-Meta: U2FsdGVkX1/c7LWxgcVmfm2IRmK08W4K3oXXY5OVnT9PfTdJhOYwNdzQnJ0svyd6hZFJ4+SIXu+j3o6nlft11+pOOux3saUuhIeaNYxEgL9pFsosPkmbegJzgwNwsXoqrx8w6n64e476DlPrNKO1ZYfEYRQA0fcXbXzd1u5kY/zgMBkxRqxi6BdJ11hXGFnqgkfXgWGnRBEJVZbyAFtYD3uQG/lVBgL2XXisNISFzbyxmbgD7dd3ZylYMRZbSKt3uxXQo9sn23SGSMAoH92pEdL7xW1W+qCVFxiYEm/nwE0fyytvxP7PVfZzRVuHStZGW+BxpL/ha8+mV9fEN4Gqr9cbEZcnPlUg2x7Ve1aQKfuNwimAn3+XugpsJId5iyRWvom0l6wISFNifrwXawajglSnZobBYtbOFrpt59A+yoO6HLh0lZ3D/j1E9CnqjzpB9ilbUykuvZFKgnASdd2YVlezI8L726OfwveAFhru5vQxzZ1hIpwNugCWPtFBtL/sujrVelwMzGVbUB9DU+avkAtY0Iy+mDrJyGmw6cSLNfuMTEAe0wOAw6b6aDtEolF/FG5Mif+XTEbIA/Uvoxt0KRNRD+5M+5CUYMDmFRYVXP89QI1ntYAxL8hXI77VKP1io9uA/JQp88SXiKRj/J5jMuQVpR19PpuZrLUTt1Csuov0tN4Vy/wxo/S66Ide4HYX4iMijnXtaet2q1r48nvLIX8bcXv+EUETJyCu3ZUN1ZUwnnsC3Fu5JtmkVdJWVX/4JDOPBztrD5jSgK8pOCEaEX/6qIBJTmCL1/GXmOsydf7ZUQZqVzaICEWPOJdsCuMse/YK2/Ohv6ohEuh2fd26VuenK/2vay23W3KJJRD3OPWv8015xtW3eQoHDQTvt3k1iAjPEC81wc1S2XpP61Vpqm2P8ig+40NWhBrobB9W0LJizK/hlpca4St6CbzbIrqNQdEjtWxEcTT+v7m55EA
 jx+CgERL
 sSGWN2iI806A0MltevP8Wqc2FjbChhwfAQXRplJKUA95/2NpX+i5+Gglq+FT6e5p/KAf9bxUIBsOkRLiQQlickKUw0y56oPHVWGRxg8iwsOLRQRsSGJX9ukKCsS0Qf2jAeC6DTQUsAQN8KE1Y1CAnscLlc7GrL0wljHwIdz6TXoBobGridPqmSQqhl4ed4LhyKB8nToNq46RMobI1qL+ZFix2Nulj8+IXMLDilIH3GN0gbzMm0W8YoKzKB4a+z3ozQwN3HWCitj+vu0sjSHksJa2MZfkZnLO6p+Yc9DpPi8z/UNpHDwX/1vUi1PBr7jvbM645gQVEdlKdRnKHG5qi6Avv3ut0FRZH3jUBu60kfB36aBWFrlmGyIanuENhAurERDBv+wx78wEJZJfLI7HHFgsd43TVpqxaAtTiuUxTYNd+zVQGX38QiO6wJ+w49LnYkzhy4QXLmeFrIAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, khugepaged locks the khugepaged_mutex in two functions:
start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
mutex_lock/mutex_unlock usage in these functions and replace it with the
guard macro. This makes the code more readable (removing a goto statement)
and makes it harder to introduce bugs in the future.
No functional changes introduced.

Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
---
 mm/khugepaged.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..c583867f2e7a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3113,7 +3113,7 @@ int start_stop_khugepaged(void)
 {
 	int err = 0;
 
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
@@ -3122,7 +3122,7 @@ int start_stop_khugepaged(void)
 			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
 			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
-			goto fail;
+			return err;
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -3132,17 +3132,14 @@ int start_stop_khugepaged(void)
 		khugepaged_thread = NULL;
 	}
 	set_recommended_min_free_kbytes();
-fail:
-	mutex_unlock(&khugepaged_mutex);
 	return err;
 }
 
 void khugepaged_min_free_kbytes_update(void)
 {
-	mutex_lock(&khugepaged_mutex);
+	guard(mutex)(&khugepaged_mutex);
 	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
-	mutex_unlock(&khugepaged_mutex);
 }
 
 bool current_is_khugepaged(void)
-- 
2.55.0


