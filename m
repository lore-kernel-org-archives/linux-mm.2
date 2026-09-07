Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C8CC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 06:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4526B009B; Mon,  7 Sep 2026 02:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC5A6B009D; Mon,  7 Sep 2026 02:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D26D6B009E; Mon,  7 Sep 2026 02:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C95C6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:23:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E30A0673
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:34 +0000 (UTC)
X-FDA: 85185974748.08.7290939
Received: from mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
	by imf27.hostedemail.com (Postfix) with ESMTP id 11FE740002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:23:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OC/zIDew";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788762211;
	b=t8GHpOELIz+TlW6MPORHh4eWp6PE02l/HUAcJ528RLUywWiRHn9MmJSfCYCxnotJAfNxNK
	RbOV/OVdU5u09ayyZrf++ZZxZMldd4n7nhnS96ZnU2L17iG6297tfq516P54LyhQSzMTgM
	vxHXSLiHFR1nvYJUietm66auHYYmAM4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OC/zIDew";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.58 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788762211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY1nhFgxRuHUzFEwBXRmpwzp8DWiy/uM12ejMBFxE8I=;
	b=1XMrXvub6Uhan//pw/zlPHDLEEJHBjNk1C+zRORX+ulgCCYcdTe0vXEhSlk+i8behWGpUw
	ZN5IU+iDLdY5XYXByHvf0nVv21PfmtrDdjGm6hvLuDDIuYbckr/AlCva9cibmv9cgievpB
	dbhYBbdxe2xw6fd5+UHJdSslDY40Noo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V8xaXgzY9XllyFlk89eNgFUoQBothzQGCS5P6ix37Rs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788762209; v=1; x=1789367009;
 b=OC/zIDewivDGk5D/c2JMi+LTo2WKd7KhSdjJ7tDuc7BrSGSKXj/q1UZJ7gM9Uohur7TZqF4i
 OaA19RRN733XQ5y0Mi5jrHu9E/Vq56iCXSlU203pOFrG+snKnppv0Mkd1JVcsAr7mN5x81iXjlz
 VW2k56RylWsEPTPxVBP5fEdM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 985a0dad0ac24b89;
	Mon, 07 Sep 2026 06:23:29 +0000
X-Mizu-Trace-ID: 985a0dad0ac24b89
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
Subject: [PATCH v8 1/4] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Mon,  7 Sep 2026 14:24:10 +0800
Message-Id: <20260907062414.106873-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907062414.106873-1-hao.ge@linux.dev>
References: <20260907062414.106873-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gpf7ijtpq76817yhxf7hio6b1maiifw7
X-Rspamd-Queue-Id: 11FE740002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788762210-294484
X-HE-Meta: U2FsdGVkX19f+U1PDxtfxVgCFEb7KeaE2VqreDE07/QWLpzPyL4VHHjZOQ8If8QKYlaiEFVof1FuYtnIZAo5S5pJTaEVQ4L0yfGyN/lLn5ZcVbCePgB4izz9GJSIBwHBYkxs46J0fb8fTzVnDLpoAjQ5UkNr1kkHi4vP+T4n8M2TA4rw95/B+YVpWTtiOULWwzkz/sRNjiwLFDcTiignz2Wi+vSD5PBbvfU7coTrV6dY5mJaLKhc41MYJ1DlS4wUkNgq2H2wqLyeiUDLSP25SL2cJyQS3CqRTBwKqFpHvuk8BynweJqtBcN6OKYpbZAEyWyUus5VvnvxrZ6/Pt7arYmyHlfrCXrwKdKIbqOvBg+8SAMlR49uzbNFCenJCia3MRd9Ti85byj9H4sXZu2MOzKSB0dOSYQhFvehT19ZlGKi2ZNYEh8idDiU0UX1X/U8FdeamK6+GwIz0dICeGxAd++08jjXR/7xsE+9J0Z9nc48qTmlnCz1hSfelhbj7EnveH+9mVa6XdJ1uNaoB8CemR+b90pgoidaIGkZQAxtCCukjQ+SUu6fcucX83CTNpH+NTRmko9sqw/wdpuCTlS7Jiein+rqdgZjX+iI7HR9rn0YUKxcqAYmSsgMccjBFZtkMz7Lcr3CkYxNws1OAUBRWKzhoe5vfoCPS//D9q2WrlA1KulO5T6MGMDveAqFlOnsTc9ajExMAVg8BgYD7YhHAy58t/EzzoTiMf+qc3Fktezb2ETUArgDm/iAx7uVzKCWFVs/wD+Zwt7BIOtHic4ynQVP502mkYcv+OXCxCPRhoQBfxsKfHK7cdb1q7rW06dB0r0TRDkG3tBlEcChHWafY1X6fGL1DSuiTkdj3rbVAWtrbfbSGeSYfwAMBKhQoY6O5hZ/HgFBf5c4QAC4ApCGx8DoWepFYrmZ3o8lIRYErMjmCjE75rNtPYaa1djRM26ZMKn8ezAGcNbwGPIKwHo
 cOgqNuGf
 s6gFIB9UcNf8CxoPoshWbGq5njQHnT0kGYqpbgbG1R+m6F9fORRrF87OBJ+aHXKCRVZlUkXyd3T5i3FJyr19Pmisk9OFN+WKanGvTEg3hoztG6J4vV/+mL8WInhj3c2ayvHSMDAZSXOMu5DG6ygUWGlnEGND9pOzFlqdkJc1R5KrkhIjl3J+yAkQ1mn4GpczM73vQzulUWiT3t+665n+VOsunO7koSUkGD9Kn61aeDs4s9Lyksi4op7h+T1FJABWbFOWWQMMrDN1PQiwKv9Lsf9dq5svCThLnkMhi96RK86dB+hIywC6jJZTrdx+zi0jPmGRR
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


