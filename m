Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11B5C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926BB6B00A1; Tue, 15 Sep 2026 02:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE666B00A2; Tue, 15 Sep 2026 02:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7246B00A3; Tue, 15 Sep 2026 02:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A9D16B00A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D97E4A0347
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:38 +0000 (UTC)
X-FDA: 85215096036.15.0CD4BC6
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf12.hostedemail.com (Postfix) with ESMTP id E114C40003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcwewssJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kcwewssJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455577;
	b=7kf+3P1rQZPaNnftBl8iyAxwaTW9gix4IN59F8GgJ7R+0RNpIRpZdHjVMPD73vbAraJs0M
	LoiXJCEDQSe7MTVO+Fk76vMVqrnpoLlgezwUP7dcy2vHYbgodrbOYyJ6M2HZM6hAaz5FML
	CG55E4Uv9ut8PrQqB5j03LG/wVxolVs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJ0uGObJDnZYcJRhrOuFwKVQ+hmhkarUC/5neDLVh5Q=;
	b=OLzdRXQ3h5shvao3KMS73WSxS+OmG5oWpO0qx1icVv/4hl/pxjM5TBzmWe4YOUey2MInlz
	BTAbFb7VOknH5tXvd8tQUtbsl3nPlgCTv8u/1zYuVwxgfZsM1jLLOUse8psU6MWzyF90bV
	9Rlq9Z5MxXDLwLyJqm4PrSNjUo7Pmn4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j1q5lh6+pcNupQnOWdCoKiNEOrdrCXWiA588ffNXkqk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455575; v=1; x=1790060375;
 b=kcwewssJoV9tjMvq8zA7F36JiK8XsZIx99HA4Hi5iMdA43G12vyPbV1ZVYHEEokVJwK7u2Rt
 ei+2BuSYhJdWwYhFP5Oxwg9tn2YuBTTaZ2w4Yta/OFq6ZPIylRd1vQVCI5BoSZuQ4uX4l/Q+AS1
 OII+G2A3x2Iw5fyISiEg6HpM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 245cf166983b45cf;
	Tue, 15 Sep 2026 06:59:35 +0000
X-Mizu-Trace-ID: 245cf166983b45cf
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v10 5/6] alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Tue, 15 Sep 2026 15:00:00 +0800
Message-Id: <20260915070001.113559-6-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E114C40003
X-Stat-Signature: rei1jxpzwz5q1dhyuyb98pqqxudj75o3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789455576-290417
X-HE-Meta: U2FsdGVkX18eM0MlfZykTmtb7KtHTcFUYgx9GtUNDlXGC9Q4jWdU+wERoAPMr02BM9mUUEHUNNbizq6d4qpfl5k/lQ/CK6DFGEKHzicHjtG9xqdSsQJP6xWT/Vsl0u8C7MioAhZvwwrD+JdpCV5vJWKveRqQmiORSpGOQNuJjFFaQuIQAdqWMMGyL7jdOWD1pUBc/9TKR3XKwUNKfPaHu2Hk7D7hZArl3rfF54vgT1rA3GmkXDXsdRMffMYlJ5NPZKF3CHHDcMLeqRaX/aWjVVloa07M2Lymonfg2lFDWqNIC0XUrzMvtrjB0JxdyG0Q65fPmZA4HdfWdybn6FPLG0MWyM4ti5ax7Ffk6IsR/Ig8pfeAlfXdi1139tPcSHJbkh8Gyo5uTQPAsE04O3nyrQXc+4S48/sFQeYuRpmWYcDRVz43Ev7ZJU8uFf8kuXKYQt2gTCcSwPPn0OrrhL8n2GIV5DDanq3qPAZf/+n4Lge/E2Jgc812xmqTs7hoU0Mp7e6TZ1pVlJh+R4iByn04hrBnID1SCRExU4gsmRcBLuMG975VzoG1+CgVBAAe5jMaTaCTpjSwsj0X+km1gdBdeecvaVTItdKQut90pqWi+OH1/SV4tuggPhQatS+uel67dCtgQA3uV17rVrHTAceQ10RoelV8ft7/FEpq5ow0gV1E6+LF2VqCDJsVNiyULOxFWDJexa9v/uqlc2WwY523du/Mr+dxVwFnN5cCQNBbWzCezuF//MiqGJmxY2YvkG8pZG/oMXkvRFnA0H23RlW55MCRX+CqFW60aioVDG1Auex1EK85helkntJ+VXvhVr7jUTRhwNevB23MZL0WhXjN4Pqbf7i0Vm+9Wb0i0/edD8UgmHGG1aAmILPu8y1ONfbLIiRA98v9V9wfSk/4yZaYcO2LUfK6MaJiz+0gFvzEzHBluFnKwrjrrkhdJ/fn9MMNhf2jKh/DKdLuscnMzwo
 xFa0pxas
 InM02BL2O/timA5qtxavGGIjbmWSrV9k9Q1aKAXhfgUh0KefXO2p/56ZbZHvVp/k9oYXxLndCOnwacaRK5Dm3g1A5oFsyVisPrnXyNr8IVtd9pF1hYyR0f1t+jZTJ8Nnwme+1/F2qCayKv9rTO9r9RzlVYR9lV9/QVqV00oOv6kYZ9imnYmGHdbsWKOOjsFHJG4UTIkxRRmoxAwOq9xpa8YZzYyUptyZZgVff7mya4e1rdOX4xUCyhP/Ldj/RYDVDzOQnU72kyDwnvKQ+9XMAU9NBzxrzVL+i1jA8uCv+v+IfbEAQDGQ42mUXw5yOP/QIPQ99
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
index 5836803898ad..1ca0409b492b 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -988,6 +988,10 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
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


