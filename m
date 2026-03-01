Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5C3FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F201D6B0005; Sat, 28 Feb 2026 20:24:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB0E6B008C; Sat, 28 Feb 2026 20:24:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF7296B0092; Sat, 28 Feb 2026 20:24:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD0D76B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:24:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CFF11B7D6E
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:24:58 +0000 (UTC)
X-FDA: 84495750276.05.D834738
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA4A7C0006
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:24:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+yMWeeX;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=E0xcDGG2ipBTAKOjGWurZmRFl/BhFdlRy7WAvDgw35g=;
	b=iatplWH7KKcyLl6Zr3+T3K4Jf72rf86oqA2vKTIgSXoE+pQQZoRRogyLfc7w6q0Dt98mpC
	M2Fo3hQKXAjBy09LO8fRquZY0hJP82fg/qx0D0kY/YxC6cMoKIVtejcihYmkqfZtvWctcv
	Xjvb9pdyNU5VrTbCLMHZOEcvEk6E1TE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+yMWeeX;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328296; a=rsa-sha256;
	cv=none;
	b=7iWIGLUJUk4l+EQZP9YeH/c4/26eCyZ8cfLJZ0UyLaBUs0UwpZxiLuXNQtE0p4wnSeJyYK
	tkgWoFlJewO5k9kXYZofnegHdu8+xoRorUGqdRyMxf4lmWcLocmjMmJOuJadOXaeVzjrrB
	FAYg95dZdJwoeWclrjA5oQiOacvK/WI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE3504395E;
	Sun,  1 Mar 2026 01:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23773C19421;
	Sun,  1 Mar 2026 01:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328295;
	bh=q2iLO8KbI9ALryCX6/wUxMqfWYriV0dYXQW5wrcui7E=;
	h=From:To:Cc:Subject:Date:From;
	b=X+yMWeeXj1pvQIPqcbKcmDHMpkw+d1FdTTM8zlMEOipUyBCtnhcfR2TnoxqfEfVam
	 Y6VLdllNMi3qy7EMIbca7ySGK/E0vX3kU7AY4ykt/RYJLGZE9FJ/X8a2E4OO4mLrri
	 Qdlvs2sr7afIW191kTtd3t1p5lDKQRbdYZ1Egcvwak2ZJxzRx0k+ru9kK6LFqHOLzY
	 hMZ1KrtIG0Ept+RgXfzqM/gp17PzuYZiRRNRzV5QVLFHbsLaqbKybg8uChvOxTiUNd
	 cI0Q0kiMga9Zcds0v9ynDzF6YoR1pxCQPJKStJGetd7k/ziJj9aae9ol9RxzKk+kfU
	 JlZgmkhgRlC0Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	williamt@cadence.com
Cc: Max Filippov <jcmvbkbc@gmail.com>,
	Chris Zankel <chris@zankel.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/highmem: fix __kmap_to_page() build error" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:24:53 -0500
Message-ID: <20260301012454.1681859-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA4A7C0006
X-Stat-Signature: kakukez95wyus1zfbfobynoiydkq9kni
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772328296-848099
X-HE-Meta: U2FsdGVkX19PTQTZrdUOkxklE6SV+b1+q2SkJMRkaupJ/yQEOvaQ5dn7Vn82+eGNUWEp2x0ieqsAoyN92A1VMov6qeWTBFTCDrNnjY+83n6ymW6DSXxRCZzCvMrT9Hegmct4nYdCvLI/ilLmQcp8P9e5Jw6pdjV7HzwrjUk+2SRIn5fVddT0Tsz55ohs9B6OazZjmqu+VmqTU4x3b4iazZdGz1i89Y8qALzMPx3RiAPvPKjohEU3M0mGzVjSGUkza0f3p0lpSC6qiSSr6GsKaa/o2vHqY1lmrxfhysMF5fe8ktcxb480p5tkPbEnCX9Tgd7cFcJgz2wdaA/h2qLCanAnia6kFqqvxTbQoUSDeGhgP1PfBTkkgSYp+5aczwFD2SJd9pH9NX3A2qf3XClXPKI19qDvrPtm0RqJoi1CNwyNi7AKY0Z6u3kF4WZJuwLrImWeQ8dxtAZ7azlOuJzhbRoaqCTEUYdqDgFTCB4LTm2AjOnnYPVrvawDCMu8PYy0Ou51NLht73PqpX4Gke97giiCofwMMXxJuY2lqp2FoJ9pIWPjYwPiYYZHxy0kvNQwJSCQVjbvzdvc/4+oeUA1ixDMmumBKCBQwt6U8gruaAl/qqAeQwLU4TQ+fAziX/kZz2BXCIKpkf7FEBGRlVGNC5bzP7waRfEIfuRdQO15Kkt7EuYZcrB/lew4J1k6HxI5ME9ak4bWxA+RORCTG6u01VfCyUCNogyxGKBQm9dpZHRFIJHXjMb2w5yMEAhiYAFfiZ4T41r8LcRLKXyP9NOv5rdcBSZ6jWwOo3uwOuN2rJGXKzCiGb2ovrZ6fTTHn8ssf4v3MWc4F/K5NdZyqP4iGCXFC1cCfnQtev97o4LUan2u0hEFtb4WuUeJS/VDBrjCLXcjh0baMYr65Gk84lVCyncIn/YxkmClNPE/XWaSe4L7cbvnRgON+9mj7HYXEEQuj9n7Iy+GA5Q/Et5ikEl
 f/LX1Ae2
 UN5ozTy133GQf3DR1+Bj3fycFRZBljXob65eaoldb6ZtfIUYESO83bhEeupwJE93RloL30wJl9CKYQjg5hDrQFW1CZ7Pg/SlvZkaj8XgOy0gzIrcfxA/e6CzwoSFbaz4YKeWNGPbX4BqdmtIPLl9ucGUhWmeAlA5fsPqbZNfA6lmfH/6dTuqTV3CHY971NLGiO7/44ssSvZnrY+oPFQ8WV/mO2BggeduSIG+x/6xPD1nMT83mRcOCPQH8q5MWUD68KGRvTfrMHttfz8+JUknvswOo22jyl4DrNhw8n8oCDJAuAGqYdG7pED2ftYOqD5g5Gj05ZCKqo5lWjAZZDsu1VzAOdy1Hxk3tpotNSnpF7kHx5xddK+cxKmJl48Zk5qcBg6HNoF019q9HTRqmr8PdssTc0aqvqt/DlOLdTSTC4CSh7wKC1ENVx63vQYiyu2lk/yqmg9d5Bp27DhsNp07x5ASgLfjyE5z52h4lNcFO6PBLpIisIMcI1IItTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 94350fe6cad77b46c3dcb8c96543bef7647efbc0 Mon Sep 17 00:00:00 2001
From: William Tambe <williamt@cadence.com>
Date: Thu, 11 Dec 2025 12:38:19 -0800
Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error

This changes fixes following build error which is a miss from ef6e06b2ef87
("highmem: fix kmap_to_page() for kmap_local_page() addresses").

mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
function); did you mean 'pte_val'?
184 | idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));

In __kmap_to_page(), pteval is used but does not exist in the function.

(akpm: affects xtensa only)

Link: https://lkml.kernel.org/r/SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com
Fixes: ef6e06b2ef87 ("highmem: fix kmap_to_page() for kmap_local_page() addresses")
Signed-off-by: William Tambe <williamt@cadence.com>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/highmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b5c8e4c2d5d49..a33e411839517 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
 		for (i = 0; i < kctrl->idx; i++) {
 			unsigned long base_addr;
 			int idx;
+			pte_t pteval = kctrl->pteval[i];
 
 			idx = arch_kmap_local_map_idx(i, pte_pfn(pteval));
 			base_addr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 
 			if (base_addr == base)
-				return pte_page(kctrl->pteval[i]);
+				return pte_page(pteval);
 		}
 	}
 
-- 
2.51.0





