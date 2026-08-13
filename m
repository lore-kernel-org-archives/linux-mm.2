Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA46C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90A316B0453; Thu, 13 Aug 2026 05:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAD96B0455; Thu, 13 Aug 2026 05:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B926B0456; Thu, 13 Aug 2026 05:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE596B0453
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:34:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCD95A053B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:14 +0000 (UTC)
X-FDA: 85095735228.18.41399B1
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf01.hostedemail.com (Postfix) with ESMTP id E874440009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZxW9+DB6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TF8K63WeM6z6403hSZtDfDJXM9m2uLOv/bAAEqx+2S0=;
	b=u3+nQTw0ZiRc2A6SmsalMXbdA0IOKUMsyAL02+SGw503X5cSI0AnGyAdKzxBjxzoRpSaSf
	1cKlsVIsUzkmQwzNEocdyLxxN/mzbEkoIIGbbncsOrpcM8Em5Ch8w1V35qapSv0zjNOiOQ
	Is6vssR3UhaGIerUO9Lf1GjpXjpuwJs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZxW9+DB6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613653;
	b=CmIKAzTOuU9PhmfAbI5zUaOPGYq7k9wJR5yn0Gr+RxgBgHY59DRVkIAKUqNERrHW253kAL
	v5kFFWsZ30A41RHF8l/ef2tm/1Jc8Db2S8FoJ5myRDfQgJ2G0fHUE5JT/ikvZJaSR3aDxR
	64ktz/iFZcLsRIOrWpOlvRiTz6Zcn14=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p4TFMUd9q6GnbcN5ey2myrD4Zw8jApQ5r7UvSVGLQQM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613651; v=1; x=1787218451;
 b=ZxW9+DB6bwXRqzZq8to0yNNVzyfWCIMwxMxlc5JgvV4rHQ3KWecsC7XHr0G4Xeh/h48qWaS2
 qhMBoC3VqyRvFWWskbpQ4+TzVE/tiN2FlUJkrm8zTkkI6Vb7gX65e7MM9s7C2+TSjmfuYNBgg2X
 HP2JVkv+W56xc2ybPj/dKZDU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id f70264e86958a884;
	Thu, 13 Aug 2026 09:34:11 +0000
X-Migadu-Flow: FLOW_OUT
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
Subject: [RFC PATCH 2/3] module: move codetag section placement decision to layout_sections()
Date: Thu, 13 Aug 2026 17:34:20 +0800
Message-Id: <20260813093421.135230-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813093421.135230-1-hao.ge@linux.dev>
References: <20260813093421.135230-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ogzpjmuj5xmykh1p9soxarfkkij7xuyi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E874440009
X-HE-Tag: 1786613652-203158
X-HE-Meta: U2FsdGVkX19f7FVFcUYwf6pk3gNTF7H6kXREjm6x5PJwkE9J9Y76toRJ7/Yai+v9Zygqm7PdieR8qOlXlivYwGPn6NKWy1Fvq2UDKYlA8hSoel+ku1pyLkC1NOORC7AHWpL95Z1BqXE+lRJmyRPxUF5Na6mXFhxEap1naeJUTgThXDaMMy3Yw8K5nLq3l/ZOki348uPnk4qP6YI4PEamBDch6DoQzGtuO5pafyELtutNNB0GTiY3+CNCgs/QzUBO0anKyDo3Vh35uT9/ZpGKTP7Og29DlTT+iXEMm5w0JSfvec9ANgwaLXIByDyNIBZ6kLuOSKgPrMeEwZm7icKvAOclYUX0p1gNuoy+CQnPxmIV3PoPl0UvHywoIYAScv1Z/zSJwJoJY3SOpXCPQ6nBRvqBV5DeZIB8IcNTmdX3qll2m5MksmH/qYEfbZBY1opEui4KUgf6kSEH6uK0o0Y0h+livR3fQbtYfda1J7dGEKz8DBfQJMy3QCM1O+yVUN6xP6WcstqUuSxqTfsJ4eY49RUyFAjU4wSfRar4KqknKwct0wkqcnQT6K+GoLdXWMaRz+aT+b/umhOaDlLXecEIXsf9plgEf72Rd74kzqJNu8JwrFwpFdeZHz8W0saMrWaS2vXWOoicG+z7xaKgyKXH4mrA2Z3lXAudBQFqPW4DuEDAC8sOITBTxHzYVtgvag3zXQGqnzlr3kC7D1FKtu5KfN59v/aurJg5qCFrbSTcXuMC80aia+B7e3hQvqiZC77F5kV3St079utbX94azYyIOKHb50zlCPrJRGOpHoRsGh5To8PTBUvRXpvZlzu5OaVexWw1PaPvAF0kI4q76fm38/WB5VJU52kpGkkau61gimMSX8yMxhqM9LFfoK2lTCFcV21onSbI7QvQqCfVxIrvxjkAaxBWtTXy9zU75eJap9Ay7XuQJDo3UdTFYp91yuFMo/lWrg+6lXbaodCJIbh
 9K5znixI
 gwqZ9Kch653lQTCVFfTVpXtsz8LHN1Y93aSdH9zUgSL8IS8Xa6coSjdjigB3KDNbtTKSqYWkFKvMm9kXr/ghW3KLBbU0LKzL5+OSHxhpZcqe+C+sSQDmpATRMOKDk5aNVoQUIlOPELccElV2cTC5yqZkuLP63OBynaGZC6RRClpSmXp/+np3uOt5yX4TzG61uYPMAkMkBKBXcDgbMegAEllIA/qFhEHyhlsPQrGQu5nWUOQ/bkx46gH3DpZvKVF8KmWhzrAd/QfB4lAM4436eQ3sihg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

codetag_needs_module_section() is called twice per codetag section, once
in layout_sections() and once in move_module(), and both depend on
mem_profiling_support, which changes without a lock. If profiling is
disabled between the two calls, layout excludes the section (offset 0)
while move copies it as normal memory to offset 0:

  CPU0 (insmod A)                    CPU1 (insmod B)
  ----------------                   ----------------
  layout_sections()
    needs_section_mem() == true
    sh_entsize: type, offset = 0
                                     reserve_module_tags() overflows
                                       shutdown_mem_profiling()
                                       mem_profiling_support = false
  move_module()
    needs_section_mem() == false
    offset = sh_entsize & MASK = 0
    memcpy(mod->mem[type].base + 0, ...)
       -> overwrites the first section there

Record the decision in layout_sections() in sh_entsize using a
MOD_MEM_CODETAG type, and have move_module() use that instead of asking
again.

reserve_module_tags() returns -EAGAIN if profiling was disabled after
layout, so the loader retries and places the section as normal memory.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/module.h | 11 +++++++++++
 kernel/module/main.c   | 17 ++++++-----------
 mm/alloc_tag.c         |  8 ++++++++
 3 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 7566815fabbe..a02016528e1d 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -328,6 +328,17 @@ enum mod_mem_type {
 	MOD_INVALID = -1,
 };
 
+/*
+ * If CONFIG_CODE_TAGGING is on, modules get a .codetag section.
+ * codetag_needs_module_section() says where it goes: the usual
+ * mod->mem[], or off to the codetag region.
+ *
+ * Mark the codetag-region ones with MOD_MEM_NUM_TYPES.
+ * It's just past the real types, so it doesn't index into mod->mem[]
+ * and for_each_mod_mem_type() skips it.
+ */
+#define MOD_MEM_CODETAG	MOD_MEM_NUM_TYPES
+
 #define mod_mem_type_is_init(type)	\
 	((type) == MOD_INIT_TEXT ||	\
 	 (type) == MOD_INIT_DATA ||	\
diff --git a/kernel/module/main.c b/kernel/module/main.c
index ed26f167be84..2337bf604f58 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1728,11 +1728,8 @@ static void __layout_sections(struct module *mod, struct load_info *info, bool i
 			 * preallocated contiguous memory.
 			 */
 			if (codetag_needs_module_section(mod, sname, s->sh_size)) {
-				/*
-				 * s->sh_entsize won't be used but populate the
-				 * type field to avoid confusion.
-				 */
-				s->sh_entsize = ((unsigned long)(type) & SH_ENTSIZE_TYPE_MASK)
+				s->sh_entsize = ((unsigned long)MOD_MEM_CODETAG
+						 & SH_ENTSIZE_TYPE_MASK)
 						<< SH_ENTSIZE_TYPE_SHIFT;
 				continue;
 			}
@@ -2815,11 +2812,10 @@ static int move_module(struct module *mod, struct load_info *info)
 			continue;
 
 		sname = info->secstrings + shdr->sh_name;
-		/*
-		 * Load codetag sections separately as they might still be used
-		 * after module unload.
-		 */
-		if (codetag_needs_module_section(mod, sname, shdr->sh_size)) {
+
+		enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
+
+		if (type == MOD_MEM_CODETAG) {
 			dest = codetag_alloc_module_section(mod, sname, shdr->sh_size,
 					arch_mod_section_prepend(mod, i), shdr->sh_addralign);
 			if (WARN_ON(!dest)) {
@@ -2832,7 +2828,6 @@ static int move_module(struct module *mod, struct load_info *info)
 			}
 			codetag_section_found = true;
 		} else {
-			enum mod_mem_type type = shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
 			unsigned long offset = shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK;
 
 			dest = mod->mem[type].base + offset;
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 461fa87fbb0b..7481180dadd2 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -893,6 +893,14 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 	if (size < sizeof(struct alloc_tag))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * Profiling may have been disabled by a concurrent module load.
+	 * Return -EAGAIN so the loader retries with profiling off, laying
+	 * the section out as ordinary module memory.
+	 */
+	if (!mem_profiling_support)
+		return ERR_PTR(-EAGAIN);
+
 	/*
 	 * align is always power of 2, so we can use IS_ALIGNED and ALIGN.
 	 * align 0 or 1 means no alignment, to simplify set to 1.
-- 
2.25.1


