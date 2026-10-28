Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45447606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F31E6B0968; Wed, 28 Oct 2026 00:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A32A6B0975; Wed, 28 Oct 2026 00:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9246B0977; Wed, 28 Oct 2026 00:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15A366B0968
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:06:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C0BA40BCB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:06:36 +0000 (UTC)
X-FDA: 85370698392.06.421220D
Received: from mail.linx-info.com (mail.linx-info.com [114.247.232.78])
	by imf26.hostedemail.com (Postfix) with ESMTP id DBD9E140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:06:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=JElZBt1ytYu+zjbdpKGM9sCMTT13/34lYpGkm8cooOk=;
	b=3H/ELnflKE8xACtDvvX2yAR9BoYyHSLJ7DFnUwkqJeJZt/IzXX5jKZld0wTcSPLgNLrvSF
	CgYP4R7XZT6enqJa8zgSqf5kF2UMitGwYw5yuyIdSQ1sXTT2RkTX4ddQOAeQ0RcUmVCYWb
	go15KkJm+TLsaoFfhBSQLr4K5+fTcKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gkwang@linx-info.com designates 114.247.232.78 as permitted sender) smtp.mailfrom=gkwang@linx-info.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160395;
	b=BImp/FfZk4AEzgPB39mou5yhm2ZjREtYEAY6z7T0ST8q4xSyel0NbZ+EDF/yo160jXalOg
	F34IXZx1XWaMRl9U40mAScjvOZ31epuLjz9sRiF2qgythHfknMym1k5nQzdFAuTYMYRe8W
	vSQ9A7oqvWMnXwxjgbilkEXEfQ1snUg=
Received: from localhost (localhost [127.0.0.1])
	by mail.linx-info.com (Postfix) with ESMTP id DCE18321211;
	Wed, 28 Oct 2026 12:06:30 +0800 (CST)
Received: from mail.linx-info.com ([127.0.0.1])
	by localhost (mail.linx-info.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tob-XWZYIJ-x; Wed, 28 Oct 2026 12:06:30 +0800 (CST)
Received: from LAPTOP-A9UKIAU1 (unknown [172.22.21.81])
	by mail.linx-info.com (Postfix) with ESMTPSA id A640632119B;
	Wed, 28 Oct 2026 12:06:30 +0800 (CST)
From: Wang Guangke <gkwang@linx-info.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wang Guangke <gkwang@linx-info.com>
Subject: [PATCH] mm: fix typo in comment
Date: Wed, 28 Oct 2026 12:06:25 +0800
Message-ID: <20261028040625.204-1-gkwang@linx-info.com>
X-Mailer: git-send-email 2.55.0.windows.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DBD9E140003
X-Stat-Signature: 8c45rq63ceu3q37ehndu78e35xeon8ud
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793160393-371767
X-HE-Meta: U2FsdGVkX1+CgjmE7Uu/pLTVMITzdoKB/3/88Hu2LHYCBA5561SCGsRXRGL8wqMnmDpSR/zrJfTlt2I5vMtNke6EYcDoThiCx6la66nGpMRQn4utZRa2vN0WhtMsEIvXgEBpFdbWZpPBhNKn+cqJ8+c4yHIxZ13vAPSEJKfWTJgQXUXt+lrf4JQfbyuj365iOTBMls8aFvtBwVHGfizsPPp5nRSVm6wXye5cuvD6uTe/SJ/j5yayzJXom3j49eJprUPHde+xTz6ftkjLn6OnezDCIe7D4vPqLcQcinz+1/4iWIdd34aR//RvdAoGvySmIz1LMi0VFkwrSZOVTtO21MSxoTfA8jNfo969pZ3WQ9MTiaAPUZrHSjGRLQxh5fEubBHlFmhrmUgqVHUA/H6AAz6as3e8gnQiX3XsV9lyC+w+7V/SCJhQUxcSd/gmqBQwgrenVtFKW0nr+qN0xDQcIHxcW2t3bngaBKmkhkwTBtSc1Qn3fZEDI+3sZ+1KMDBmrRWVtD2NcBx3eiQ8XmKTRdO5jj4RM8Nf7NdHhqeAA5xMqNiFbHtCdBlm6jIjNaGrzXLsj+vjX0Yn0KUilQJfn4sAd0JdwvU5gZtEsH9qg+Au7W12IT072DBPNim1mv3mHbqB5FjCrG7w2t1ZQOhV72pSaCrgyQpR68IMNRLTlkzPqv/3FbZeug0HdR44fK4GFaj9tC4b0G3rlbW3RVWPp2k4csnyPBO9IDt6ecLOJ5nUKZxcIMRUA35OowYjEWkfOd6QypJyChNzeV/X0oJFy24YH5j69DrgW66GEXWIhGB5qM+Ki3VrPUlpgO0dkmP2CmgiYTj9ZphxlK38zC5slO2mgp7eJtbQtJbo00ItPLjVakERqhDdQqSU74QqGm0cFGxdLPowJgk4DBdHnGnmvOum89eVKdnjlWJZaAgOXg6oZ/9NiDGE0GyU6WxRmbTMFCvidtslD87xe8JTH09
 +61mopC3
 0e4Ju5h1T3lvkLPZzZypeuWgM/b4xYTJQ1U8kY8tQzopIDRPByv8P8cQ4ELT4uWURumVlBL75/0o3Z3+NZBshzUlhhaCetVYo6ydtHhP6JGErtRkjUlFm0P93dzO9t9+y/9TE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Correct "pages frames" to "page frames".
Only touches comments,no code changes.

Signed-off-by: Wang Guangke <gkwang@linx-info.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..9d233b6af7ab 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1179,7 +1179,7 @@ static unsigned long __init __absent_pages_in_range(int nid,
  * @start_pfn: The start PFN to start searching for holes
  * @end_pfn: The end PFN to stop searching for holes
  *
- * Return: the number of pages frames in memory holes within a range.
+ * Return: the number of page frames in memory holes within a range.
  */
 unsigned long __init absent_pages_in_range(unsigned long start_pfn,
 							unsigned long end_pfn)
-- 
2.47.2


