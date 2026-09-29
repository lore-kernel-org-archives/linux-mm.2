Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11170CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2886B00A2; Tue, 29 Sep 2026 04:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A7B6B00A4; Tue, 29 Sep 2026 04:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9596B00A5; Tue, 29 Sep 2026 04:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D19596B00A2
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:19:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 88C901A0421
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:55 +0000 (UTC)
X-FDA: 85266101550.07.B590431
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8E1A9C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:19:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KfBWDei/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790669993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHuVn8hUbj7N8TDfyEoDPKlG2yZcH2DzDBWw+EBJ4/g=;
	b=FqsnDjbWlE+Y0M+f/glg5eY5k3ylU0LxS9xL4u+EmuUgJFiDex9mABV6TWt7g2iFErd8yS
	FPYKa3BCIH/EcKP8+L8Fvv+MnDYZ6VGh+a1ri09KS7GSLmCMmZioQmflP4LdrummLzgrEU
	e9WmOznDpFPa7By6mwGEGpi/r5y1dgc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KfBWDei/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790669993;
	b=rr/UgZeq/ckZFCS1SbvMjn1quOlvEYkaapVkaKsyFW4DGRAtpLOaqp+5uqhpXunZ690SI/
	3mVBe+TgBN+6/9r/qrry7uLwdNurPB6aWnmaUpNFYhJpILERjpXPD6fJSXzZ67aE2WhOrB
	aq1pgMtJg7t1Jpt2hJTwkSxcUfKD/Ko=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1hrOUU2WscT9i12+q2dsMTJyNqNUXrCyPWNHR9ygX74=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790669992; v=1; x=1791274792;
 b=KfBWDei/udS8PZ0UB4EG9jC5AIU0y6wz559e5+lCRw2IZVIJAtXZI4QITiyglNoIsR2QK+ip
 bT/DwykHtFn7+KscShbGe15HHOjwZvWavKRIAKAUwu9S+lp+vRRgHYC/T/FhBIi1XXJ2Vh+cIX9
 +FGtm0xrVoZSeb6agaMewbHw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 360d4de2e6525221;
	Tue, 29 Sep 2026 08:19:52 +0000
X-Mizu-Trace-ID: 360d4de2e6525221
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	=Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v11 1/7] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Tue, 29 Sep 2026 16:20:08 +0800
Message-Id: <20260929082014.160587-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dt9razjwf8bp4ugd4ws6a9mnquftphs9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E1A9C0008
X-HE-Tag: 1790669993-983431
X-HE-Meta: U2FsdGVkX1/sclshgC00Dv23DHzXPJes0/gy4IQACFiQkypGXW+RJEKObJmTB2sIEJn7T7G+UnmY3Sanc8paPIZv78tzX8aXfHCrEv2s/QOTH1BnmNyOQ5nZVua66b4/yP+8SLzUFQywK/yUOlg92ORdcEpOkvfF0HIgaxygOCoDSTM2LsNMh6Kmeq5BkhCL09SqqSjLbENKqrjDCKxuI6ZuASvTAlIvVoEaPzHIhl8R0dF2ue8otHUtc1ysM5mZH82gMYakYQCJlTh8CRUKA4lMTDHLXKBvATRP1bco4dAaY73HAwj5SOEjc1/Z6I+m8QP8Gs/UlByEMfjFXl187yNfT0HnpzRXnC0SsfyeErwJqrn4t9eFxLwrt3CTVUjqS74Kexkve36FUhZDC2rdgm0hD3exTqrOduL3NmzQ4RGAaLGUMhBgU4lNHiclZScC4KI61imlbf/OeLY2dYs9waSw4uEijj1xNy7vvsDOJIwm25FSMFJ2sib1IJLVl+JMopsvTUouqQ+v0vix/DMq8uIU2IsVKGGW6uZxOZtw72WdHFsZTcKyfTdZPT670D97NgNV2UYcTZrdhJkVoXp5bk/952RhnlQQi6xx4sf58M46v6Mqs3BqYdeaKw6J4Oy9iUwxSpCX+DG+EHfCgJ0KXN98QfI4XXGZRlaonK0Rm0m23s3kL3fdTn0O1k5A/UA8Pg63jOj0zUUcq+PH7kq1bchmvxRqqP+VkvDxxDH989oS9XmR4WCJq7xY52GIXuTsFoq21g1wOTDgMEJt197ZPC8i/JstqQ+dQmCBV7GjvDwAfLExaRCsJExLkJQCeBpVlplV/yg/zJ4xsyL/rdfxWxcdn3+NdCBQj+3IEX2/IUzBiVSgE71v8Ck4BwDneueCJNJJeHOjzBnlwKKk+1f8xH1gHOvPPACZzbWfwCB9LLQEqB1c/o66itd4P9w/UmHu8Ki8wVc9E21DtIgYTsV
 +de++Wsf
 C72Y4kcJBa/VeelHvz1/IL9KoKHfZj8Sc9y3JQRYsusxPCsTrY2vaA4UjXJNogpSdsKHQCDrh+GjbUPPIUEIkOvMbYjsmfIgRhAKLuGqyRDeClyg4xGlm6qO9fvOKBEFMZP0vVRFk2rs2FNayD4mFpoEfJM8ZryPvs0WlKUHTGtjZSCPhkatArXqf2sLGTsu0w4jne3M0ne+B/PF3nPl3QSPreHF1Kp5Q5JxfN84LSwxeR0uRngp9dCmUG0w1SZ9OemelOmM48RoPuZAghWmWkDs8BJhjiWljjKNj9V5fFnSU6hXmz0ugJPiH7Psv+yAoS/hb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

release_module_tags() is a cleanup helper. reserve_module_tags() can
also fail after storing the reservation in the maple tree, in which
case it should call release_module_tags() to undo it. Move the helper
above reserve_module_tags() so no forward declaration is needed.

No functional change.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index b33410310477..2070e682fe10 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -835,6 +835,52 @@ static int vm_module_tags_populate(void)
 	return 0;
 }
 
+static void release_module_tags(struct module *mod, bool used)
+{
+	MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
+	struct alloc_tag *start_tag;
+	struct alloc_tag *end_tag;
+	struct module *val;
+
+	mas_lock(&mas);
+	mas_for_each_rev(&mas, val, 0)
+		if (val == mod)
+			break;
+
+	if (!val) /* module not found */
+		goto out;
+
+	if (!used)
+		goto release_area;
+
+	start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
+	end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
+	if (!clean_unused_counters(start_tag, end_tag)) {
+		struct alloc_tag *tag;
+
+		for (tag = start_tag; tag <= end_tag; tag++) {
+			struct alloc_tag_counters counter;
+
+			if (!tag->counters)
+				continue;
+
+			counter = alloc_tag_read(tag);
+			pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
+				tag->ct.filename, tag->ct.lineno, tag->ct.modname,
+				tag->ct.function, counter.bytes);
+		}
+	} else {
+		used = false;
+	}
+release_area:
+	mas_store(&mas, used ? &unloaded_mod : NULL);
+	val = mas_prev_range(&mas, 0);
+	if (val == &prepend_mod)
+		mas_store(&mas, NULL);
+out:
+	mas_unlock(&mas);
+}
+
 static void *reserve_module_tags(struct module *mod, unsigned long size,
 				 unsigned int prepend, unsigned long align)
 {
@@ -922,52 +968,6 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 	return (struct alloc_tag *)(module_tags.start_addr + offset);
 }
 
-static void release_module_tags(struct module *mod, bool used)
-{
-	MA_STATE(mas, &mod_area_mt, module_tags.size, module_tags.size);
-	struct alloc_tag *start_tag;
-	struct alloc_tag *end_tag;
-	struct module *val;
-
-	mas_lock(&mas);
-	mas_for_each_rev(&mas, val, 0)
-		if (val == mod)
-			break;
-
-	if (!val) /* module not found */
-		goto out;
-
-	if (!used)
-		goto release_area;
-
-	start_tag = (struct alloc_tag *)(module_tags.start_addr + mas.index);
-	end_tag = (struct alloc_tag *)(module_tags.start_addr + mas.last);
-	if (!clean_unused_counters(start_tag, end_tag)) {
-		struct alloc_tag *tag;
-
-		for (tag = start_tag; tag <= end_tag; tag++) {
-			struct alloc_tag_counters counter;
-
-			if (!tag->counters)
-				continue;
-
-			counter = alloc_tag_read(tag);
-			pr_info("%s:%u module %s func:%s has %llu allocated at module unload\n",
-				tag->ct.filename, tag->ct.lineno, tag->ct.modname,
-				tag->ct.function, counter.bytes);
-		}
-	} else {
-		used = false;
-	}
-release_area:
-	mas_store(&mas, used ? &unloaded_mod : NULL);
-	val = mas_prev_range(&mas, 0);
-	if (val == &prepend_mod)
-		mas_store(&mas, NULL);
-out:
-	mas_unlock(&mas);
-}
-
 static int load_module(struct module *mod, struct codetag *start, struct codetag *stop)
 {
 	/* Allocate module alloc_tag percpu counters */
-- 
2.25.1


