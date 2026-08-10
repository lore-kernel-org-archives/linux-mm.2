Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD1FC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9036B0093; Mon, 10 Aug 2026 05:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69F86B009F; Mon, 10 Aug 2026 05:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FF16B00A0; Mon, 10 Aug 2026 05:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACF466B0093
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:39:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3086C1C15C2
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:39:55 +0000 (UTC)
X-FDA: 85084863150.06.5133F67
Received: from mta1.migadu.com (out-59.mta1.migadu.com [95.215.58.59])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28B35140006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:39:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QhVQmnlU;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354793;
	b=nmS22z90U5tIuK8h3D4YtCZmLumN2NzTk8+oYWBiCOsUUaTHFKzIyZX0K7Y9LynvAhEJQW
	msoXKHnalwjsda7Zc3ymCULtw1qp3PObNO2yCjvlfi2pHPnUJmMyLCiijRQEiQjcrD6/Fi
	84DrvcLJVa5uKVD+fKNIeCVNgL6Fy1g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QhVQmnlU;
	spf=pass (imf26.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.59 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e530wfDtQX8Sd4NzpAZy7/F5jDBrIDJn6CXSV5PK7aU=;
	b=x0SicjDCUw/tkH4IlP70Yk6ho5Ic99smEXyHEbqmJodRJ0gzmjZ+xVmwjlLlJMeG37xqHC
	r/ojshovCnK9//C0+n8RnY6Yfp8UICuacM3i18I9MBiX5oE0gnIImYFvrtaLFK88PSt7IK
	9oAcQFy1uI+uPJGF6o8X1Mm8IgECK2Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tlcnQ2gSnDSweAJxKqL+Wd2tfNW+VPS5fl701xcZpzM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786354792; v=1; x=1786959592;
 b=QhVQmnlUFgIENngiHOFBkChlBLKBnEmSuAgXzDR/RpSG+dU7kP7sSWHArqQglPtHcidDatb3
 Gd6EoHj42AHRicDURwWPayM+/9fyGNtLEzxEkXCZ/eBaqlW6XbxtwCvbf6H5y+GEIibVJrDN+5o
 RLsk3GGVmakIVLZDXF+exc8Y=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by mta10.migadu.com with ESMTPS id ed45d9bbade2a809;
	Mon, 10 Aug 2026 09:39:51 +0000
X-Migadu-Scanner: mta10.migadu.com
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4 1/2] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Mon, 10 Aug 2026 17:39:54 +0800
Message-Id: <20260810093955.153015-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260810093955.153015-1-hao.ge@linux.dev>
References: <20260810093955.153015-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28B35140006
X-Stat-Signature: 3r7q4zf8o5p7jzo75gnmzdodcz583gos
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786354792-106729
X-HE-Meta: U2FsdGVkX19iWIzirkv/3BeoQCJ1vu00ze68tNIwWbhaOmPcQVAXdxL8Df3bJ7h7dJnMTc78WjijnDTPRxxwAN9Mxeohs/l3CdD+CVHS+eODqbwYKYHuWsoAlg5EydbC3zf7S6nOG4HnHovhXgRhg7NfuUwp2Yi1z3462IWCe4hMvDPRUguNaPkmFGWAG/IUY7XldSCmVV6XXOqUm3gZLCPR5eqoIkNpC/dqn4SprRgGk4kk6vYxHSWeFff7Gueuni6Q9HSQI/mhS50tIij4qfo3SXjnHnMgb3H2ih2P1Ts/M5Hu84CeuhikX38lf/2uQQjvx9rKMBVR3Q6cdIG0QkUCoOQ9/NxuS63xxd3bykcoNj8c/QmK8b9r5ETble6ZRmwJlK40HScUmOflxq1Ao3GodF8I+8u3RPLtWMKS1Yucg6f180ZExZ0zWzS9a5x7lNfG9BDFWQTHFPa1cfQKMPwpo6ZmDBuPe7KYVx8zYcMifSwZAy4RtI6AGY5jS/OCzVZuSED5AiZmp3U28YBpt+kL3AJYiwXIAMz1v1rceEob/ZoTtwVJKsghbpQiqG557J6Ih9BjNok2mWd1Y9sj+ZTwPcGZAiOGfV1FO6CcdAvLZMfD0fv1Beb8VmAEgdf33PbbTJ9ijj9WL45jtu9aTj+zQfR9F1aGR96jRH/YBexCBUGrgXnM6Q0rU+oG/25zi313El3hs5JejBdLx5A00qGQHlWLabE8jF912S9VLOiMbWgPo/kKc54uqjX4y5VP+MYDlt8Y8OKc1ThtO/LxFLPc9japeI0fZRz0yY7QauoY4SZBRd66jNbu+jpKRA/IIXEaWaZrjrF3PuSePlZg/c/7XuJVqnNPDfnkvDGTZTYBhNJS6ryQZ8YYKJn1wbeoU4O//EuuGNkOBlHVVU5txFfbFcsuYhq6anvJqWqE+ScOuxJRwjAhasqxyV8F+9hPiJYgnsOCgZTG1UEsUxR
 +PLdaePg
 QdchKxW8Dw9mGdeuoX6gvFzFbNbBTWNroiaHzD9XoIO+bf4VM8HdNbJqMRaOI8BeRH1nbPqiGmOkoncJUUjHSjkgBfe2QbMt/C5pVLjb7jqT7K77oO8pNQRrGQ2lFYBnotJJY+qd9640FlCIfAQSm3rwQXI7krgY7kdmQc9ik/iKaT0uQ1oxxn2y1X05dMwjyU0y9Br3RuHZpkSB5fF9aurtpDzGTWsSu8AlgE4VNxmUJZ5oUVRfQv92ZgqGniKqk/ioicYYTCWEZmPVZxaQyMQAP7w==
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

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 92 +++++++++++++++++++++++++-------------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..af44f90379f2 100644
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


