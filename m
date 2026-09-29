Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B2DAC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425766B0099; Tue, 29 Sep 2026 04:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6096B00AF; Tue, 29 Sep 2026 04:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313176B00B0; Tue, 29 Sep 2026 04:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D82F6B0099
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:20:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72099A0435
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:45 +0000 (UTC)
X-FDA: 85266103650.08.13C427E
Received: from mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68213C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:20:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY8aVxj4;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.164 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnkkSoCDZx7e9L0+1+h4Kj3/KMdToCJJbb3nnzNl684=;
	b=G4zytmT4x1I0S17AVur8eEz2zCFu1//hojICz8UQBoGmtdePlkw6ytmcon8DZCvkmJuXzD
	6SH/HJv2/9v6xllprc1RIhx4LJj70mpRyTjRwFc/hH6ZzLI29P8XTlGuyZNtAQiWc+1JHQ
	g0qTKnmD9huXogVQPZ2Qfh4asx/p/TA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670043;
	b=5YImWCJK48k1wGbQ59blm+8rt1ga+iAXIfOAT24gs38P2Iv+Kvb1Bos4JnAzyrvcfDtRX/
	ji31kRHc4X7OBG4EnrYXXBjmldXxnAoOyAW2DRZ0q44LCwCf6APFl+Vw168XbEjaieNltv
	nb3+FgDEBTZCI0xLrY3IzroUAibgGYw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY8aVxj4;
	spf=pass (imf10.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.164 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N0ff/iGVp+b52+6AW1hzofKLKiwU3Q/JuQflNfL6tR8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670042; v=1; x=1791274842;
 b=wY8aVxj4JpcVF/SXqQM/e3Qda2pFi+YyPDKB71tB4ZiJmKwjBK7a+hBExwF0kO4h0BWcNbgq
 APjmev3X1DDydKKguV84f63chjw6jKx3YOGRXy0aljHZ6WX57Z1vgjlBtVfrn11RalqAGhcQnhK
 dG2PKVfF4aEqZZL491SUYIls=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b8917535a4169c27;
	Tue, 29 Sep 2026 08:20:41 +0000
X-Mizu-Trace-ID: b8917535a4169c27
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
Subject: [PATCH v11 6/7] alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Tue, 29 Sep 2026 16:20:13 +0800
Message-Id: <20260929082014.160587-7-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260929082014.160587-1-hao.ge@linux.dev>
References: <20260929082014.160587-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 68213C0006
X-Stat-Signature: q3xgefpwxy7isa11hc3q9fjc7ndbbb4j
X-Rspam-User: 
X-HE-Tag: 1790670043-361648
X-HE-Meta: U2FsdGVkX18k8FHG7aYNPC5oa6Y73uf549NBRRjiubbnf9pWFOcwFEwVdksS/MoJcEvNy4uA6Qt7wSIeb351N/vQh0CS//HTqj7SISAdrTQD6lX2oLk7MyLfGP3noPDs+ESAGe/IiSs1hyhuxObEN8Is9eVezVH9MpHi87k9BKAYFSLY2ocnr1se6nn1Tsk4kUGAeTbVoOSDcFlSLtUAJgWBOOwDo7mpMYbcjwWpGMtSx3OKvvponOKd1ykhZlC6nYfr5t5w3E7fsHwF6bHYYHiypj2t5z6cIs6OWfG2KTSzgpCfioPt3PuWJcxoCRFXGImqNsxDSleRQcLRErmjY1KqDG9Uv9AdoLexAqEGIxcBUB7/BqFOCjklL+MNbqmLhjFhY66ZD6i3jNiZL/SE2CfPCLhRAgJdL81Whvxs71U0j9iXOHFH2d73kppt1PiMtfn5FqBJofDIS/oQIYP8j22gvguuphpeyl7QFLGz9Lkto0iuhstqnQ4p7eQzIKiwgmCNNt7NxCAkzwlI3woGZvVvGGcK7OUtC9uFqSM54kcAtxDJt8z0iAAKoVL3oBY2Sgkkh68iA683B+Ppv6aj5pWA8Y9EhlKp7CvSlWQaTnbnB9CPrlE936xEFsFZbAIlzemoA2lAr/wiBYgkLhDMn79LmI9XzQwiGV67enqPMOflyw7UQrjP0Xr5TbHlpxSs8r3fFcRCr8HjCwWCjmLREqfhdQL+NSmDw1sA+f+yK+e1rI0+1BlrOxgObc+A/JPCmRbydSeUB38NdnzAUr4pg7icFV+X6Ik/zL1KScyFnTxo40K2adVU0B1VU5NB42orjEF8VTuytIAOgPZGtt63PT5NroQPS4cWHRIu0PkiysBmd5Vc2ABllTVCbZ6ozPOJP1cTzMkUjXmog6Xh048mu1lgUtjEgQHB4kDLhxUANMNWO7VnMBrm0e0tZbsS4tHnmMoyHYg9hDpVYtOE0gC
 9qt5fjjO
 +7mYC/hGJV456QV58dNlvd2AAG3TWthcjMIJ6yoy8rVNwVajPnEDjVukX/XWlQRZDr7Jj+0p0yTXRQEvP64n3drRoKAFOK/wmvezZ4XSwobmFdbiwS7waPxt2yWqPj1zdYLAlG5O3rIcYCcSYhmfOz3kHd008ujXfnZPFFlRBAAtxBa6LxMMlEb+felSmGCcn/R3F5nFfqw/bEZWOFTFkh7A4EHDnfVIXf3Z594tCQWHRAV23vRdVTB1MKgegARGdgyye/s6e78XXeIn/jxaXAqd0sSJbuz/7/lLhx5MZhI9lszegYkRu5jVvwXQJwwKOfsuP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After shutdown_mem_profiling() clears mem_profiling_support,
needs_section_mem() returns false, so later modules have their codetag
section placed as regular data and never enter the alloc_tag maple tree.
codetag_load_module() still called load_module(), which allocated a percpu
counter for every tag; release_module_tags() could not find these modules
on unload, so the counters leaked.

Return -EOPNOTSUPP from load_module() when profiling is off:
codetag_module_init() drops the module's cmod, no counters are allocated
and the module loads without its tags. codetag_unload_module() now always
calls free_section_mem(), since a module whose module_load() returned
-EOPNOTSUPP is not in the idr but may still hold a reserved section.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Cc: stable@vger.kernel.org
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 lib/codetag.c  | 10 ++++++++--
 mm/alloc_tag.c |  4 ++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/codetag.c b/lib/codetag.c
index a9cda4c962a3..a0b600720afc 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 
 	if (err < 0) {
 		kfree(cmod);
-		return err;
+		/* -EOPNOTSUPP means we can load the module without its tag. */
+		if (err != -EOPNOTSUPP)
+			return err;
 	}
 
 	return 0;
@@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
 			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
-		if (found && cttype->desc.free_section_mem)
+		/*
+		 * A module whose module_load() returned -EOPNOTSUPP is not
+		 * in the idr but may still hold reserved section memory.
+		 */
+		if (cttype->desc.free_section_mem)
 			cttype->desc.free_section_mem(mod, true);
 	}
 	mutex_unlock(&codetag_lock);
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 605c0016f646..ba8a651769e3 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -981,6 +981,10 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* Profiling disabled: load the module without its tags. */
+	if (!mem_profiling_support)
+		return -EOPNOTSUPP;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
 		return 0;
-- 
2.25.1


