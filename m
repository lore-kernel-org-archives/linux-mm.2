Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEF151098783
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B62A6B0005; Fri, 20 Mar 2026 09:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2672D6B0088; Fri, 20 Mar 2026 09:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CCD6B0089; Fri, 20 Mar 2026 09:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 063F16B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:00:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A3BA71A020B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:00:35 +0000 (UTC)
X-FDA: 84566450430.04.28E1306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2EAA40015
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:00:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrLp5IAN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774011634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZqkfpddEc48CH4Q+GIssdffBaK7vARVEQUExaMtVOGQ=;
	b=4ix3aeThktpf7bLnMkI9NNnzF3YD9ufVXFppI7r5F6LCMlHzHpuvk4ePllpD6zBo3k2JtQ
	yKiPLHRNPKQOF9nqHvWu/xwdixG0e0D9Rf3l3TJbWXU0PphIJbZWFpdnFpmPayGRAWtX67
	Yx7Z8LqYuCp5hg4kTKCXUjAeceiAvc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774011634; a=rsa-sha256;
	cv=none;
	b=3gtPEbTiskSOowDLK75iUl/nkdjYh0E8FCDVsqt0es2a+mYpo4VFrl9TRFrOC3189u4LsY
	yjN02hKNa5WODzgTct+Mw/M8nuDglV0z6NJ9Sie0ERQIzeyluGcSdNMJH2Rqus1Qjq/Owz
	E73wrvzMPmheR5bj/xsQZ5Hy0rUng5o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrLp5IAN;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0055C44379;
	Fri, 20 Mar 2026 13:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2F7C4CEF7;
	Fri, 20 Mar 2026 13:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774011632;
	bh=SFedwV2oEAm6rkFP9fGtF2Boej3NRSE73fzAFwnjCyo=;
	h=From:To:Cc:Subject:Date:From;
	b=PrLp5IANSOuZkKLqz9UKA7U6Y5nR/XtOsO+YYSdBtpUFljG0ikw+WuI6oZ7Q4yFvW
	 u1WU4kGTzxlI2VULjdhOXERR7l9fv2pAmRq/v4cg+rh9fez6gPHX7tCGDan9PO2NUW
	 kdH4mP6Ue//pEU6L4eq6ZXGq5tjRUq6UBVZvHB4p3DTN8l8rMxPsuVT98qAHVqkt0K
	 xb1GRG1ibE7Vn3VbzyTe5uV/dsKwpOCXDAU5Mg4mIKkPKAw3r9GlHQ5KavjoZ1jfpB
	 WOLU/Q3hdv2j/bGd2hWqr85rK2cgSzC5t/KxnNh33k7+7fNydbGUOwImqXYFvvILzP
	 8B2HHM+pDeoKA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH] MAINTAINERS, mailmap: update email address for Harry Yoo
Date: Fri, 20 Mar 2026 21:59:25 +0900
Message-ID: <20260320125925.2259998-1-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E2EAA40015
X-Stat-Signature: bgj9yastec5nwkh7ywh69sxufok8p6i7
X-Rspam-User: 
X-HE-Tag: 1774011633-891953
X-HE-Meta: U2FsdGVkX1+KY4GX3/ZixgAmTjFlxs0497DyQLFpx4xHdYAFbZbwBX4Tykm6Mv02/8YqzGzYXv5b8vior6fRqo067V3uuyx6rUk26WtYTuqUfT9vRgCKctE7mIGlO4T8jPabWcZQGQ2rFL06Ne5MF8W0TWZfO/TXxjlPCUn1qS9U31iPC2a34inWACJuWFB+RBCYfN7rdL0kMrmwWPnowzY0eLzkUEvfTdvImLzgLr4JMvwG+xQTAa/bqiNsHyZkZKwL/A/RoU/FXCXIlXN9qwpiCJYJF60m3hFeXYFvLzpGgXOpHKfOSfYnvv0lotfCBty/GVkMC0S8bnsLyfwrHLnap0zAWPLT3sqcGIzpItK706uYYWpOIFwGE6Ia7ycYeoQRecoWRekLEvCHCQhrbOXwBq5UWO8ndZehcKGgevf4B2iD4i6GkiVFKM8ca61wrE0YM2SQdcXW0rIoMigKPBd2T8qpGENRWagxcxyOwXtQWBoDzVdWDH/cj4Gf6wOuC24gLbbrkCkAXCUe689qmK7FOmNvLzYN/jQt8fxJlb0gTitlsqWmUCGtzcndnGvxlH91QFNz2CI/5+9pPibkHJI1Iggl56EDAG4lFECNyJGmnxC0bV70OCNHrzFLkIyxb6d7ong8ghrXHC3wAolhUGh8e30s7MC9ujrkpifoDYNBOyRL0IijmcJE13Yvn1tNACxCp943853WTEE0EwP8WdHsKeJywJzau2BNwiXNBVgeEfL639F3uT3QSjtFDVZNust68yaAWFHCW4bmPDbaIRUCYGmub/wNDTH6kdgBizOHrZvuiGG60VD74DInxKNoSNiOx6EgrCIylN/0tVUgMwIcImJIqUahNVz5oy/psxslzxCV4cPnQjbY6FrWOgNSqJ5dvvwiMdEVqXazLXlg4zJpE7HarvE/GyXwj2dVOOqlhBrcW5SIoaUcv+szRoaUkjBhILL7b16TDPgzA85
 GA2dQYzJ
 Umq9e6MiUS/3Rcc8cT2cD8WCpDGhgk5bCJ8UCuz60tU4snyAJyYEQ08NPYANdShS6jZIt4otKIhtb1ITbhfCxOLOnt3xZ+JTASN77lTTERbNxHOTtkFzZTGMnmaFeh97oLWNo1yHC45LtoMmE3FMqN/9Q5UCoTX6k2FNu3Jix6hLGT+UQKvZBjs7tGlmD30LvJJ32iBXxL4I8mrqss5yOxEwDY5EqbCTFEOSMhNFzsFmU4hKBl5M5haXI6svOv07QlFGUMV6EYKymofu0ffR/hNIc9VQCQNMg87QhF5Ss3hHAqI5udjaEpjjPBEejVbvBBL/7/1+f5UPNcjKrcEpqq2RjI0d1iNy1PowffANBlnQzk8IPZqv76BIelwP3/vsvIK/2BiuFlWkK7yHaQ7mFYD9IdkdJYeJovYPBqu2Trzw9k+1ThtBUAKb6pGNbAbf6lbg7CpAGG40qEuaj8v20Pdh11DjcYC5jc76k9CZH/Ay5aE5I+mo7iU3PXimNCxghPebyJMYPWEbvIQ6fsQGjiIbRoXr6DjxoC6d/BD2+wbpdInTSy/C1mhLpFFy4FUUx+ZZ1quoo+Mm4AAVNOZT98UzUhWIw7g4+BTuFN8o4VvYQnZHOMzPVnW/R4qeRlmRndPSBbKacBB7iFP0GKy2ZFi7UnkeX5zLpYQf9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update my email address to harry@kernel.org.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index 7d14504daf24..2d04aeba68b4 100644
--- a/.mailmap
+++ b/.mailmap
@@ -316,6 +316,7 @@ Hans Verkuil <hverkuil@kernel.org> <hverkuil-cisco@xs4all.nl>
 Hans Verkuil <hverkuil@kernel.org> <hansverk@cisco.com>
 Hao Ge <hao.ge@linux.dev> <gehao@kylinos.cn>
 Harry Yoo <harry.yoo@oracle.com> <42.hyeyoo@gmail.com>
+Harry Yoo <harry@kernel.org> <harry.yoo@oracle.com>
 Heiko Carstens <hca@linux.ibm.com> <h.carstens@de.ibm.com>
 Heiko Carstens <hca@linux.ibm.com> <heiko.carstens@de.ibm.com>
 Heiko Stuebner <heiko@sntech.de> <heiko.stuebner@bqreaders.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index d7241695df96..5158a7e76c97 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16875,7 +16875,7 @@ M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Harry Yoo <harry.yoo@oracle.com>
+R:	Harry Yoo <harry@kernel.org>
 R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -24341,7 +24341,7 @@ F:	drivers/nvmem/layouts/sl28vpd.c
 
 SLAB ALLOCATOR
 M:	Vlastimil Babka <vbabka@kernel.org>
-M:	Harry Yoo <harry.yoo@oracle.com>
+M:	Harry Yoo <harry@kernel.org>
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Hao Li <hao.li@linux.dev>
 R:	Christoph Lameter <cl@gentwo.org>
-- 
2.43.0


