Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF405C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB7D36B00A9; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E698E6B00B0; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB1A6B00A9; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 834976B00A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCE3680341
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.01.EABBEEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2E08140004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ugzi/Wco";
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8hCX6J051ezDB5+YdYORXYfV8s2h4jIj2UT0/qKUvE=;
	b=xQRa3A3ySLBXMla5xTTQFtlrcW7W0JgjhZEbO0Np5tPyK9u+vTCFJKylWxPMAkg/5/bH5E
	kcQ4SwNnCdXbqlGJwpg79tf4MKAnUzUHO8EUCEQ9Vll4z1ny8UhgHZAe/FVvHPv2CtjwoW
	kaK2dSUq32GgM2T6wwOQe3RCVntGblI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763684;
	b=liBYJ6aE2Iohphv+zu5WfDHsA90el/Z172moeAl9KT/USsWZ7cnBU9c2Ox1bA0KFDoUXdy
	EK0yFm37kYS5DwrCvWzJZ2jYBigomd2S1Bkkd8JVN+2cnmEjOtcgO3ago0RJwvFa07ZoV6
	hPRmi9Jb3vBkL9VsLJgYe3RWCP81qpQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ugzi/Wco";
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A723D4514D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87CE8C2BCFF;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=7XTSZ54VuyxsLQ8EW8ywMrv/5l0zWuujijQrt7Pcvak=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ugzi/WcoShNp/D/DCH+3feoSAi7gx1TxEeOYybBxLwuQx/FAZK1pCng4z66iCEdP+
	 OAN92X9SHTy1C1Q54xRLkHoGuIrkSGBO9FStW43D//pZl2TfSvf4tfu2g390cLcw50
	 ADbJ/NrkcLQrCM3AsoL+sdDK0A2ALaTmLObwL4GxAAyonArXR0meYdvxplyww3uAz/
	 mhmGWrJS0daVCuxvcsoV2p40e7iNe/r198E9EMnymkWrXbiCmQ6LT42ig8OtO0Fxnj
	 MDmUE9nAX+K9GWCS2Jh9vbb67GDnOkFZSugvsHHYEuLF8NJ09e4/c1wNNeY3JOYKZk
	 Ya+nLZY2sQSdQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761C6C4453D;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:19 -0700
Subject: [PATCH v4 11/16] WIP: mm: hugetlb: Make struct hugepage_subpool
 private to hugetlb_subpool.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-11-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=2210;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lOjGCQX3/m/ifrV7JiSqPXOvpZ1jml5gEVW64pYajUU=;
 b=62CKcF92BwyBeZ4+JVII0ser/DgCEfN1PyHCWdGDtFmjFrAuQZH+HIAkkbwAgIhRX0bTFA9mn
 4K8I6LvaxRBBops7keMTrhLFMeObPf79bBddWfrNINpTiku9RWX/K7X
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2E08140004
X-Stat-Signature: h9ox5tyn7jcorssidwecfyrf7hyep9ci
X-HE-Tag: 1784763683-477057
X-HE-Meta: U2FsdGVkX1+ost0WjZkWyTL8ctNYb5PO+cGC+eotDRVo9dKjrBcKMylNkZtUcmr3zUi/HbQyXHAT+1J7WgKf3+Vy4TeT4WvLZ4/KBLqCLO0st+uwU5W+8IxBrQQ3H+5NyEJONlraBmwSJShbAksymBus1a0IRG6iaQ7gPzM5gQTOH7+AsgNlXwZ8j4sqtyP6Hqu1/kv1Dlyekk0DjzKtrdfKD+ZVfk5V4AKChGkLwkuxYwmSifsBl2c80axXNNE/WMIJWrE4LilS0GFCGywcdYXvACzuSQkY8VO8fbPc5W78sHxW/EVYjKQR57jPuF2pUsl8QBQ+wVoT9FhfexI1BmswG4rsqTBf0GpRLR/aELSJSy4gySgiHx/RRHH+14oGC3R+VALpBjdlNV8qNjmwQ1x0jhkbC9dKZVTfIrZ5wV+QchKzr9lFimjoLqxUZs6f/kzNReUBayRyo2+YI8Nzv5ieMXLaGWXoN1ZyiZYcnAZ4NJcbgYPFqjHt4rx83JAQspdcjipLsDS+bgeXj/mARNx7Sj5j3MMOo+Od1XsramTzvIQbVbAbU3q7TOFcGDhPcgNoJvkzkTKacn3SvjkJ8Yb4bUamym2j9WWAixqSGHUjUrdEuw67wBNo2eRc2mC5yv+5hEIoi42NqhCVO5sPyKN2zNtiZzGvt7hAR9+X2V8NtpFC+5kf9vXeByRdzqVNQYSUBFKD8z0AfQx+w3YHL0JtgMy2WaIr9vW7Qgv1JLRPDPwYfjP3PtSPmeLW6Ie0mbqROYfTB9nkAVb1Hte8u5fMXBgj0kjs6a+f0Yci3Gfq1eDanVr5WxFP7jCVvQLPu5hw1jaTewKGiaSSu4p3SJm2HN2+xzO/N8Sm46kb8ge5jPaPNoCEEr/vzCqpWDAR7xUNhSSSl6ssTZVR5Ew/XKCnRyXt5B72I+VNadC2/WW5DoQomNciiuHhChqR4u/319SeEAA1bcZfxo3SOAW
 mubfMxhO
 xaX9vycwxDqBLqHweIFyvDmhmZbamNm03pgKvni41RgQD0KGIivyldcgzgvP/MyUDFE9/uF6VGhFqOb+DLHlbmzuFBgtMkW2ejOl3Im6GWwlJbfNuznTKI/DpK8/6ry4WdzltU6MNgsl7JlIzm4OVVRlHKcxAgEje+laBKf9NLtQ1h2DUp33YiqoTunagFHYJwtO/6GMwRwqX5bRuutaMPg/xy1r6OINB68saiugmfX914TQp8nZ5mRz7tviVAQiAKzxR1tNpTiW32xyWZSyRX+f15t6POA6fPBuSnVop1UEyuED426LEVDsFEC/kGbiqvrVZzdIBdycPsByIiRux+Cf2Zle9MyABE2mr90mqBsrJVbsMQgZdb4mOBwosVWQ3gZ0oUz/bsarKknuWPqgrU6xMBaVZkQyK0dceMQ+W7PAnTCsdhcjf7NeqooryHxbE0etro5DfcDC/hweme/sy62ti589IPsCm1pSfgOM1ZAaGIHRK8ku3ciHKUFcehKIZo3tvwzNMOZzWN7+P7ATaXK2x60786bjjaO9i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Now that all filesystem and memory management subpool functions across
fs/hugetlbfs/inode.c and mm/ use getters, transition struct
hugepage_subpool out of the public header include/linux/hugetlb.h and
encapsulate it privately inside mm/hugetlb_subpool.c.

Replace the header definition with a forward declaration.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/hugetlb.h | 13 ++-----------
 mm/hugetlb_subpool.c    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index f36be371c6e88..074a45903973e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -18,6 +18,7 @@
 
 struct mmu_gather;
 struct node;
+struct hstate;
 
 void free_huge_folio(struct folio *folio);
 
@@ -34,17 +35,7 @@ void free_huge_folio(struct folio *folio);
  */
 #define __NR_USED_SUBPAGE 3
 
-struct hugepage_subpool {
-	spinlock_t lock;
-	long count;
-	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
-	long used_hpages;	/* Used page count, includes both */
-				/* allocated and reserved pages. */
-	struct hstate *hstate;
-	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
-	long rsv_hpages;	/* Pages reserved against global pool to */
-				/* satisfy minimum size. */
-};
+struct hugepage_subpool;
 
 struct resv_map {
 	struct kref refs;
diff --git a/mm/hugetlb_subpool.c b/mm/hugetlb_subpool.c
index ac0f9057b4921..39413515a2722 100644
--- a/mm/hugetlb_subpool.c
+++ b/mm/hugetlb_subpool.c
@@ -14,6 +14,18 @@
 #include <linux/bug.h>
 #include "hugetlb_subpool.h"
 
+struct hugepage_subpool {
+	spinlock_t lock;
+	long count;
+	long max_hpages;	/* Maximum huge pages or -1 if no maximum. */
+	long used_hpages;	/* Used page count, includes both */
+				/* allocated and reserved pages. */
+	struct hstate *hstate;
+	long min_hpages;	/* Minimum huge pages or -1 if no minimum. */
+	long rsv_hpages;	/* Pages reserved against global pool to */
+				/* satisfy minimum size. */
+};
+
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
 	if (spool->count)

-- 
2.55.0.229.g6434b31f56-goog



