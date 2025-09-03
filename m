Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35632CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 19:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 933998E0013; Wed,  3 Sep 2025 15:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E47D8E0001; Wed,  3 Sep 2025 15:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821878E0013; Wed,  3 Sep 2025 15:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 750358E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:10:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B73114087D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:10:49 +0000 (UTC)
X-FDA: 83848881018.09.A492DB8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id C29CE180017
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:10:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BQ1Xiq9K
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756926647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P5oFgSLbG/LhMYCnV00uhZjmeWxQIl25MIeZLrkiPBI=;
	b=04kArhfoBaagW1E1sMQ7ghJGOmkNtjENivllw5KbEukGCII0VJ+nUtU5VEK2KO7aiz5NYp
	AcLz7L+NAii6MXdQS5hfavPTNx9NY04JcPcWEixXH8F6yPuPb2gf7rN3EFDY8iHp2oi+6G
	27YJB9viV77eGvZJ2GylXuij0sCbM+o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BQ1Xiq9K;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756926647; a=rsa-sha256;
	cv=none;
	b=XNOSFA5anEe4knuMEvDxh10KeP5+h6bvQm5oi9NNiCCiQ3h/unEVqQzyXpsvVB01HeS716
	7zLQJHcEtxTsEsEHaejw4qehOTtV4K35kwjaYzrrwgob6MjHm2WNKAn3OP+B6G2I0KvFCZ
	BLyP3Dm1IYkD7VVYqMhshpvfBjVDOVA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=P5oFgSLbG/LhMYCnV00uhZjmeWxQIl25MIeZLrkiPBI=; b=BQ1Xiq9KD77OF3z4pxRk+/AVSv
	3vhMyPutwFCtZHmzuLzRUBnumGTQIJF+Xe3cG8x1faEHAHRDY461TlvkARAOPXOHz8XtyZQMlTNhJ
	UyNJqH+rRnUJJaWPspd+MWTs9GMgDfa73yQJI4ifJeBgUjATvQz9PcJs9QdPT1dVdEXHP2vUVPq3d
	sKCnzAkDgzKtT0Gg4kafzg5vLqHamlFPj7PkxDrXlrkLzqT0kofNR6iLusBzKzQLY4l5eOkDawkcX
	dlLFBMUDcLfE4ODpjnNlG+ua8lgsvY3icI2myUOEjApKzMrDwLZbUi1ZzVoH6ZQioiUBS/6tK7Q0g
	/pq4fzoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utssU-00000006qAH-4Awc;
	Wed, 03 Sep 2025 19:10:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: Remove mlock_count from struct page
Date: Wed,  3 Sep 2025 20:10:39 +0100
Message-ID: <20250903191041.1630338-1-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C29CE180017
X-Rspam-User: 
X-Stat-Signature: wuxtehfr3z3ffcahmuxswusu1xzzy3fg
X-Rspamd-Server: rspam09
X-HE-Tag: 1756926646-565560
X-HE-Meta: U2FsdGVkX1/gnivtPogHpejNhXGZwLJkUVRRxPK6Adi+SWgwSKq9ebITm19o9XuB+BaqhhdTPLaGvzzjlGFiQyxmm/a4XUTrm0tIbS7990kImvNbjE3m9HFVMBuFipgCojsJRdKHC4Y5xR9Og/mV3FPqlrtXgiD2ObEVLcxKhepKFMcUcfE8cXbUxvtyYVfCWbDfKwIo9Nq3OeKdY+eZeci0VyVjM4wma7HKjsZjIBJmftdjAV0FRB/qcoVlusCeSQRq+xYIwWi+xx0dt8voMtjm8OnZf25Lwto05cYwymt56UOk6Bt4CM1m5DRECgcdylAnDeKruH/Aa7Pn+DtuvtlWUrTxwoMK+buFCdwTnQYQId2MC/Gyi9Zodvhy0dxAMkscoet4GH0juYjBLBkUdYM0cQNvbdzWjj75Eapvgxk40A+bCfNGZCb+mCYsk3HitAqHbH1udZOsFoEURNr3wteyXZhLgpOhlXlRzebrXyRwMllP2mS3cylr7WIcmukV3u2ScSsAfLLq/Vab0UZvy3LAQLogI8qRFe0/EIZvLddGBKKR+wGKriCzU74wa1chJXIJ8kRQet3ELhFJ9psPV2Hy/FgES31+jYOckOhBSA/l4tTnsXYFDBRd9S3GviolZPYmgNrAHnN5wTmdHCdcTHhbR/SotNHcGxa4w+MJaLP73quGzd7zLQK9KPbhEOPTGuFJbT96nOEV/q5tYFAwZr2Uv32+OrgCeczutjUh1NtXjEwGbegTLM7+6xf8JLdHdXnN3IjMKEyXhsl1tuPHvcdUIfEpgpHSPlWmUldg4OWX8vdLATzsdhA6KkNANmcOynsQVSbltCc99nFbrubK6Bd7kQjrE5SwWCe+mVO0Z6lj9lK1jECDV4mgUtaJX0GVwxEZ9XtdDbf3Oxmt+bP5tbSkwGLMZ4kv0vnsAjcdLnOINezfyiC1GplbVG2abDPAqIxptPhdNnCxwqoj2AO
 kKJLck2J
 MHY+eGbkZPLu2A05uZp9GnE6lp8DLfKVTib0yZDF3cCrIh2yj2jd/GipJdmo+R0uVeCTkOmy4o9ic4yo+8hc1hBGPz/TIkAS5kKSkG2wlgpG3DLoQOZuM/6O7EXQcwVHL0hOkiuVNWQin+XKs9QB8OH8Nfb2G11Ndk891zZkaNIEwGixpVVB3xMRVQxh/1ROfX1mf2imIYFR8c5MG8JrLV2ONxqDm7euLViMKTo4Vage1Vez8krlugs0MnAd1iZAh4+6B7+vkfhAWJLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All users now use folio->mlock_count so we can remove this element of
struct page.  Move the useful comments over to struct folio.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..34205313a839 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -94,14 +94,6 @@ struct page {
 			union {
 				struct list_head lru;
 
-				/* Or, for the Unevictable "LRU list" slot */
-				struct {
-					/* Always even, to negate PageTail */
-					void *__filler;
-					/* Count page's or folio's mlocks */
-					unsigned int mlock_count;
-				};
-
 				/* Or, free page */
 				struct list_head buddy_list;
 				struct list_head pcp_list;
@@ -391,7 +383,9 @@ struct folio {
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
+				/* For the Unevictable "LRU list" slot */
 				struct {
+					/* Avoid compound_head */
 					void *__filler;
 	/* public: */
 					unsigned int mlock_count;
-- 
2.47.2


