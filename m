Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E13C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AFB66B00AB; Tue,  8 Sep 2026 05:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386136B00AC; Tue,  8 Sep 2026 05:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C36A6B00AE; Tue,  8 Sep 2026 05:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0411B6B00AB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C719A04A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:03 +0000 (UTC)
X-FDA: 85190060886.13.947A2A6
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	by imf20.hostedemail.com (Postfix) with ESMTP id AA30D1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXrStVWc;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859501;
	b=N3GS+0hZYdgJU6621K8G2XynuK5EV3N6JzBluQ90OhgVjLCYREGHhsLsL1D+gfiuKuj7Hl
	v2d7lEnzI6NO6RJ7JzFUt+9LT0NKNvyUvIIRCE8OlS/ft6JeOD1xa0CGebM2bHcDK+qH0X
	JtClwlj7g+0mwRFOL7LxWbDb4MAKIrA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXrStVWc;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.36 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY1nhFgxRuHUzFEwBXRmpwzp8DWiy/uM12ejMBFxE8I=;
	b=ggStnLKX4JdQT3W982CuRep10IuHUgoCyc/O7MwcVz5lMIB443bzkkAVo3TLeGHL1DXsPb
	R75ObQxA0om5gTTQjKeNGd//uFXJYksmaCX1d8Qnsg6D7piMBTcY1Qn+Z23F29J6KOd84m
	/REYouN798rCLNcmcEgpcBAaFzZhodk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V8xaXgzY9XllyFlk89eNgFUoQBothzQGCS5P6ix37Rs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859500; v=1; x=1789464300;
 b=ZXrStVWcA3ndDiMkvoP1jRCdp6khiCSvLxqJQtV0bJSJXkDh7dplec02Hh3J74eirFw9qVTX
 Fr+I/qtdJokdbU6KeuRo+ARA5whnojtoFuT39dL4j6CF9iYGRc1no8E646e6rYWoOrCTLdqkzFe
 kleMGcbeSGp2aQtOJ7vhkcMg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 73556141def5d3fb;
	Tue, 08 Sep 2026 09:25:00 +0000
X-Mizu-Trace-ID: 73556141def5d3fb
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v9 1/4] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Tue,  8 Sep 2026 17:24:09 +0800
Message-Id: <20260908092412.115953-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260908092412.115953-1-hao.ge@linux.dev>
References: <20260908092412.115953-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AA30D1C0003
X-Stat-Signature: b9c194839wjckkgurfpw3hrkytbzxaxc
X-Rspam-User: 
X-HE-Tag: 1788859501-341874
X-HE-Meta: U2FsdGVkX1+GPUdYUy3h4b5P0PvKnvjL/dCsivXamWVdix/5UVANfLQ1Rj9ZC3lUxM9P26zvvO1oBNBSxKeo61v9Pxc8gyIhi65bx19cBJI4WHoWwQeVgTt1dDEyx/IEcFYSEOgWSHznYzbRy23+kKVPKAfJPo4UAY8PnwZnVnTvb06nZgxmiloXwUlkW36GFkdocNYDmDVoEanZXk/AV+5jFpTzc3EhsFzWtJIRkTh8yT+cQ8+7UcJxpsmagis45jO3alWywIRHCANlp4jcvPIo5rfqJRjkRBzi08eo/x7x5A4SKZn25UffTQ1N1fXVu65ZrW1bmCzQpuKEKBDOpgbK0egm19/u/WTqs7H3mIWAuhu4qd/HXu/34ISZ4TC6HoplIzRxHQocjXJsaq9wQ0xnfqBFuZqMQ4dXYX7x0+4YN2xbZT0aCSmMpU0tcjRnUJiXASBXPArwGQ74aXf46eJliWCueM272fMW7AtML7rGfP8Js/A6C46LVjqrwOg4q+HM5FwuCR8Lw2II4B3zNV6BvsEV7jvmYfzMsG6QYh5wpOGroSnpemdxKrkVkZpY01eCA2HQbpEpYtsZtGkMrNDJvSe1Z2CJA1l01Gt/oI7LJPmoy/Yhso0G0xNKWzj2GdxWGtTnQqPzZ0IU4o7+NJpkgXf9qkiprKJM82Cgr5CLepV/7CCdFjWb27u1m4Vu94ZAn4WTlH77Hg7QK3YrBOszBx+LEe/zxQyVFXTEMMHrzfaBtqfaFL2MsmQNtR9qeNMUnqThhH2qgNTjTIdCj/WmATWkyTHZw5wlsk6hCJ04J3cu0EbCnPjwqHxOaYTbgYEpJ+nQZV1Sdp3Wg4n+OtLciwQD5+TqIIzK5IYN6dE9hu2vc3feIfAqibUvocmZ13HGpmPh1eT/qXQPAOKDWiPOvfFPLZSeKfL0HyiujYghqv9nWr1mvTOU1Lio/uheyjECP+M33MAv3/8aj5J
 SjTWfiJi
 DniFHZ9WPvWjFSIFwM9mstNZRqcsA88tqjmfuTeZJnh3puwWW7TjIFjTJzn1FbJ/AH/Rlh5efFB2GRS2w6bRs03dPNs9xdLqJBWKOiXAygx6yzsX8iavDtSPSsCNaUBE8vDBV1SFn8lr2l35gItxANoDIPNVMQo6IY9g1PVzK3auoRTKlb2bTYZbmkyiM8cUpWEtPOaYAzXRM58FkeaCxxTcAgPpCh27JnYXgEpxml1LkcJ9gCncsTLgLqVP+DPFGWx4gXMgkHcVEvMEVB6RDekwJ41KWWt7rgURrUUOr5E9EiZHElIQzIXScL3KDNlyGVPEL
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
index b1d48532a25a..e7a79116ad81 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -843,6 +843,52 @@ static int vm_module_tags_populate(void)
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
@@ -930,52 +976,6 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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


