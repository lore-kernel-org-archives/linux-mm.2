Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8D7C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7024F6B00AE; Wed,  2 Sep 2026 04:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA6F6B00AF; Wed,  2 Sep 2026 04:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616DA6B00B0; Wed,  2 Sep 2026 04:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E91D6B00AE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:17:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B41BA0104
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:38 +0000 (UTC)
X-FDA: 85168118196.12.D88F6D4
Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	by imf03.hostedemail.com (Postfix) with ESMTP id A133820003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:17:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HVZJzx/C";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY1nhFgxRuHUzFEwBXRmpwzp8DWiy/uM12ejMBFxE8I=;
	b=WfRZ2IryEAXGC6O2nt73BQ+RNUNWKVoAXsNpPdmEqJxV2+3KWwB2d5txQi/Bk0iOagnUuq
	8PLcoIF7ciePC7hHEyfkaOhsodoj3MP3QLLCdVUlHzXppHQIFCYEvNtMX+OlVxKwA3JhM6
	bBvZ2eycpkWI6kA1WLidD76pmHAgzug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="HVZJzx/C";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337056;
	b=O3BEIoqmdxOY3fFF0ZrJd8n44AqlGQ9gxnvb5ffB3uuaYdEmcNG4q9IOtrrGJndcpMQsID
	0OPrSPGIitDHaA3E7AI51VmUr8fBK5BsaKLZKZs9hpzcyi8RzinFKTEYWZdG3w1OtbCsII
	fv5O6J4KBoZyGO84ZcOuGapy3usSdyM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=V8xaXgzY9XllyFlk89eNgFUoQBothzQGCS5P6ix37Rs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337055; v=1; x=1788941855;
 b=HVZJzx/CZ0IeaxUaKOCfjyfHqKK/U+EqqslsgWhGtveuAOhmWX5TsNO+YJfY/DqTqv+B9LoJ
 qYSgeCcUN04+8+VBwMlasW4DDBLmauPcYdDKMjUdgXzAHcQx5MDo+Ry8ikiNoaNo+7mOSyg06/I
 IleTlruSJdDSV2TP70zY+pPg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e763d1ffbd60e14f;
	Wed, 02 Sep 2026 08:17:35 +0000
X-Mizu-Trace-ID: e763d1ffbd60e14f
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
Subject: [PATCH v7 1/4] alloc_tag: move release_module_tags() above reserve_module_tags()
Date: Wed,  2 Sep 2026 16:17:59 +0800
Message-Id: <20260902081802.146145-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260902081802.146145-1-hao.ge@linux.dev>
References: <20260902081802.146145-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 67d5qcanujy3p5wntg7m44yu7xjan7ar
X-Rspamd-Queue-Id: A133820003
X-HE-Tag: 1788337056-17123
X-HE-Meta: U2FsdGVkX19GnBHNv2Wg2dVbvJeSnUun89S7zI8wXVAgMX7T3V0hPoA2eEeUsmbT/hewRyzgrL5D/cfvCIJMXZ15w/th+iJ+1X46nsR2vbYDP2+386zeKTizv4yoKHvH5zjFpw48roeEEBrW9uMr5h3+dWAf31M1PbqMcWRWWDo1DJB50BQbKrQXvhWn/8AGGhM1xblrgYdC+DCOe3CQYf0waZ2m/9tt77FaIwoZIOO7DAf+OL3TMAd9J5pHhGyU0X71aLbbVjFiSPmBGx2eswZ0y2v/j7oZuH8I4sPcJ6vzMeOJqHYq3f2pdiesh1r3GxDKvT/vjf/gigXkvvqWf+sr5ys/Z5yGlY9SuOXUNKa4pcJj3SMHjMCXNB5wAkjqG+ZPPzDLRF34jjG33TrouS77sPj7h/7VBGYIdIQbqlmJ3cyFr13iwzdb63ZNop0Y7k0YlC/VIE9g7qX8vdRZ1/X8RZW1/wZB9KNtSr/jnYtjy5kSZEFPap85kKYvkp5OT0z8xby/bx0xhjxI6ISrQUWLo1DtnyTydsoMVFNkfCO4zoNY/nktWQsU+W1rvMDb3Asn8y5CqbL3R4XdlDPryvwfaZhFCh7Vdzzv+1x6AWRJJfHkU4yWoRnRQW8XV6X0j26pMvXtOmYGrDOIMGiC1dgOh3AMn1YEWjd/v1bzVrlbcyjUO2c97GwKkul1cCCavwJNWW7eASNQ4qjmB0Q73Q0R49erpQzBjXFGkqIrOjRJUp5FpO4CV6hlxkItpar3A1BwIkJfvNJg4L8fXISyScyVzghPg6n7JBEOW0q6J8XaxCzkv3gePX9+jbwmIaGtM5X+R3nDO1AM6Gz8IcnD/YcdbCCfPCLpkbi5EqWkHsE5GosC5jbvZdUwXlvgWGMuEOfgN4luqoKzc4baimsb/MjG4GiX2xD/Ewe2dqPNMTuN6Cvy4IaElEb1F9Xj+qBsrmE/pjaKOrY1vdIng46
 Tj8vMWxN
 NBvTtSc4WexI847fXu8hmR92wKLi50E6gu48p32d54EGRZmZc9HvB3rQ+XkW6ZOnsjICQx6sBPZUVjahZ8f8fDiIktE3IQ6oZu/6dWU2WdB151bAIbX12CIsmkKqFrTtbg1I8KMPMxbIDlPZOCB5wh8Vz6ZyROINhduYYoYvinVsFqFLyMjMZOPiAW0si07Gqmtg2szopCUQWTFbWN5jwps9cfovzTKyqe1KBCAGCeiGHun+tvBAJTmoxvHc4/aNyepJfe98SlVsnpjpbupF0umKufNUE8zjYomvKS4572bTbh3XfT9PJ5PkF+iVoFf0VgZVJ
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


