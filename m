Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88C1C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891B96B00EF; Mon, 29 Jun 2026 10:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842486B00F0; Mon, 29 Jun 2026 10:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759306B00F1; Mon, 29 Jun 2026 10:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8226B00EF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:43:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCDB41C0455
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:43:00 +0000 (UTC)
X-FDA: 84933217320.30.2F24744
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 522E9180010
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qrThgDT7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744179;
	b=0wPRHa45fjgIbDrUcMfd0K/9gnNeVtSWmqw1ElUPBdiA2Lwhc+HA+84Y7gw6+EUNUFSZjq
	+dqdHhNYZ6ItCXnIbDMdFFpb2Ma75KBTG9/8i2B0bk4/M93CaVzgxuy1U4NmF/Hn8TaqbE
	epoVk/Ix4OB6UgvpuVct6PCrEKfiDDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=;
	b=ci2O0XxzzDnsqR0cjI7PcpLe/PaEFe01n3sTMmlnKkSrohoBWxf4jJ0rTHRZXwhCWcorfT
	o1/vBEIf39uZfBg9mWne3F/81JfsQHjtzrP5RpxXnnJKaB6srDwdMgpSniG1Umu8pXQsQc
	ORwnxrIOB7UMezrHb0mh1AiQbOfD1Lg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qrThgDT7;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ySvyaqBnJby490O44Q0qs0efkhX6UCzOyNrGR/pLA+A=; b=qrThgDT7T+qLjUW7NtCaIPDxR6
	H+f4CiE0uFscF2d1FkLX8vOILKZtLgIMKytb6Q4kjWE3NJpxEucm3NXickzulpMfm/uAcIUMiDqyg
	xfyeEmrvwwlINNe+qbK9WhlDKTIFjiJ3nyoPABGcmuPp0jX++0z5mSZA+CP9/lhyT9AJbGd+xv+mH
	nsvr7TOrZv7RgVFi/TlqUdrZrakwJqWcwcEiFpkdmWwmM9IYdnP+wBP4Lb5BpvpE/J5Fd3Tm2B/Xn
	1ki6IiNIlnNaSI5OWOp/BiuR57uOZKVpqkE9WwGtvHR5kjTSeufR6Ss0YuRYpidalqWoHvdhTtbpU
	HIUdKZCg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCM-0000000EuhF-0Mxo;
	Mon, 29 Jun 2026 14:42:58 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Joe Perches <joe@perches.com>
Subject: [PATCH 16/18] maple_tree: Change two GFP flags in tests
Date: Mon, 29 Jun 2026 10:41:43 -0400
Message-ID: <20260629144145.1572283-17-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 522E9180010
X-Stat-Signature: qcwedaoq8aum9jo7n867gjw59sb4sieo
X-HE-Tag: 1782744179-930407
X-HE-Meta: U2FsdGVkX18bq07xYg4WmEqIvT6zz0JBoTK9D07AEjQvM3FC04OjKNurPOk39Nna70l//mk18BNGq/vrvyG4CiZxVJQaKY7GHq4m2h5zS8+C+jbCj76YpxECUXjN1jLzmQN8HDcxVBEGSFX11UWavPFweiW7k2GREk5STNiU0I8sp7ab6zq9/66ZWGysJI6h/eyfw9q9/2rtW8tGQG0lJiUCeVBGfK7urKWT0BN9FGMkSMD6IRV7SXrzki886rXB5wvh89DtVN5k8VNYggQj3VuaPAlFnJT8fblP5dZGqDm6CpXhtt12V//ezMWTGjVhOE+/m2lLyK75CqhIzt9bWJoBCTft2/RU4awb1Hg8hyuFIDsgNS2at3MOlXbehVlabiEELQ9ciMLSMFX7WXkL/tAys9YSdSOI7eZTScWA1x/nF3OZkkUx7bbUqbvlYH0q75cIyL20JhLCvIWHvDbeYzC2WwWOy4w09uoZP4pfLS6k5R8bCkMj3Y4aLl3Yh4qaNnoY+T5D06g4QLEIgHqP7bZiGA8UhxKpRMuKAIyCI7yO+mJiFW7Rr4wdtzHOlGB8gGEh+MY0BDlQrTjGql51+/oELT2Q07btMtU4F/PqAhU07SAXxJSlLhzq45gm7j3qthZ63ef6tM/+/FfAe8l4u1ifySI6nR14XNaruykDozK9UwpR/2ugxi6u/VdwfYif8icgDZqGkLs2SKf9XD91vC4mue5nvPmj1OGVnuzF9DN6w8IZiMOwFB1dKrGFb85aEstWSGL3kHq9y2tq1wGxblJQvZewOWOFNzEuk/qySB/glA5jZt9q3KYJ6+qbRk7Go4L3xtN52rRVziUhlye86ElPdBi6poKtkek33E69/6gyJPHOsG2iLzSRpVUi1A2rH11ahvHbsTC6KfJKBmVE0LRswfuao05CXl/gl4s+WW8cdQCaMcybK9X5u5BR0UmMVu+LkH+p1aetHWpv6of
 wpj/IxUz
 XR2+QibVscglC/IZUqLRbfmdhKytpuzzKrn3xgBd1CJGG6lF0IddkI5Ngy+oOxVurkUncHxo2vCwpE2nSMMUa46x8mZx8PmmhTfciBcZTd0A/jbotfiJO8a4xevm0ML+dWgaAvlcaR/ugNVcQ5FwdKW0sNjvDrHfKHbX2LfU28nSxzja0Hjbc3oKibmoxjpksOAYnTo8jsrSV16/iO1wQc71FKvJGOSWfZ8x4Jg0BKG+YTRoSIbY0caC58IMbhpm7OQsNU5iOxuT5q2pLnbN4vM65oSqsmup4349B7wr7ZUqqqTcC+JpirpvHpAY393EP8xu6U1iPLW1vSecCsR/Q/0kuyAJ7+gX7/cHn5T3o+nvFZGC1Jq7+K5bokPhfjruyubr8Ee+OEZ04NhC8BV6YXbHc7lEuF7T5nzcSleEXo+XJ0DI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The GFP flags in two tests are obviously incorrect.  Make the tests
correctly run by updating the GFP flags.

Link: https://lore.kernel.org/all/d9cbb89faa5bdb71d451781d214a51ce8923a83e.camel@perches.com/
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 tools/testing/radix-tree/maple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 0607913a3022d..d967e76a3c065 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35234,7 +35234,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	mt_set_non_kernel(1);
 	/* Spanning store */
 	mas_set_range(&mas, 1, 100);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
@@ -35257,7 +35257,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 	mas_set_range(&mas, 0, 200);
 	mt_set_non_kernel(1);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL & GFP_NOWAIT) == 0);
+	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_NOWAIT) == 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	MT_BUG_ON(mt, allocated != 0);
-- 
2.47.3


