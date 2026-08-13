Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEE1C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A1C6B0450; Thu, 13 Aug 2026 05:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0D96B0451; Thu, 13 Aug 2026 05:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E776B0452; Thu, 13 Aug 2026 05:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5D86B0450
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:34:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28BB8A2C04
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:06 +0000 (UTC)
X-FDA: 85095734892.02.6421D14
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf08.hostedemail.com (Postfix) with ESMTP id 490E3160005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:34:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ns2Gado5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786613644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/q2nt5ne3wYM8VYUkacVDVWttc5LT6ul37PUNNGyJ4=;
	b=3uQihGS53c3gFaDrP35ct+NIQFlPOEwQorbWfBuXyr5cZ6kmPtK0Zj5t4hhYnAb44Wl0eK
	Ss5v8A373lWnyCxpktD6/DOn1DlHpRO/j35yt/2Gv4zb4bB7dt6jXINL48hys8PVr0hq0t
	2FuQS8uBaejS/tg7uJsrE6tAk59Kxkg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ns2Gado5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786613644;
	b=EOKu+GxBOFW8YYzUhw6WCYqRFBMf6S9XPjHC57bcurB9tpZEyFYu1+HXgiqFoGOWVYNXdn
	Axpld8U60ZLC/jSOmqwIWdVYLvOLUly+2ZCTAleHwWO79LIqYRULEc/jjcBSXdb9Xd3DTg
	kTl7ejohAGZ+Fk4kS+LjHO6QYMFhQM0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tn8UuuKtkL7oFhh/U1B37Ptewe1hVf6VZJL600BRXaI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786613643; v=1; x=1787218443;
 b=ns2Gado5My663OsOlq6xH4Q/bnQS1hmgLKSrdDPs8vx+UeedXhTT7Z0gxpKI9yKmAXOGbsyA
 uIGKipHZfUJxhP85ftIQR51fkDMgWLpoDR8aMYRDnemhSegKfH/5aeto5uMYjvBeekVqzl6OPB8
 7mfJQgGJ8O4OxlxSlVIeuX98=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by smtp.migadu.com with ESMTPS id 7cdc111fd4b862bb;
	Thu, 13 Aug 2026 09:34:02 +0000
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
Subject: [RFC PATCH 1/3] alloc_tag: skip percpu counter allocation when profiling is disabled
Date: Thu, 13 Aug 2026 17:34:19 +0800
Message-Id: <20260813093421.135230-2-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260813093421.135230-1-hao.ge@linux.dev>
References: <20260813093421.135230-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8b3xwg7amtokq5f3g8uhepsjpf9qmz3s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 490E3160005
X-HE-Tag: 1786613643-118540
X-HE-Meta: U2FsdGVkX19jBKLriY0wi54uCrpOZlhPmlVWrEYBRM7DzqodPg5V8tK6sa6pVznYSt6+zhiBcQlZx1gfnG998rT/NlAfUkxs4NzWIR/n//mLIvF7nurZUYprATl6wCmbwQr3FjKKaA+5VxTellynkaUcM12lnc0nroeaMA8Gh0rgrqd6dZxOCE7ZPDthJi/i2a20efrhPg/jGWqwsR3vz1A7Kb3imgx832H6RZhcSJ5GbThrQqebXLFJOpAtKcMgu4M2NQk22PTmZYwa2jTs1oQKzzWPOfRQFTMBx4dylYyX+U9dlkTxuSVc+pv09KLjAETUBMBFiuTolwcLEjyTUnBL35evm5xX3S+WKUx1+vGPk5MWbPH4TasvubY6x86oF1/BoKmCpMBq3rj0qy0EV3QvLYWQNtnx9GSLZnO65YYH/0PwqRm9V28/rkE4j/SpQtYozic1bz41RZ6Dx6j6zo677XKBFff5g6bmtie4LztEsdZNq4jydHjxzCJgThz2s5aEADF9WvbXWXMUlcjYzU0XnL3JBrmmR8izqXJW3k2UUPUILYbHYAV2HgL70TEZfoZL4mIWK5i+ERBQvASzuVIJ0LvgDB8RpBQwQE+khHaaEsFX9OFZ1hCmTi2ItIGlJn14uCjCu8yhffbcrw0N50x2EaqO8Vh9p6yCODzI66OMW2kxg9ib0VTh+pxJouPw7Me5DFVJV8f+aTpqbqY5HGBNodKZYMGS9aXi5lc7UaRLKj5S6pUYuzMeoX4wZl2gwKAAhAqaYlc2He0NpZ6mnQIo7CRba8++G3BghIuAZ907PzfYWTxoVSxKscSD1bwzdikJpF3smmApNuwuzW9RPIWxzjmlAiejBvBw5CfdbBjKKlp8UsYW96QNB2Oav52rPYGnj+x7wrmBfiYoCuYdrenwfGZ7uALJJ/ANlw4MVsPYBhoorkXpxd7ext5P6+O4rDNh3MXJoIfU42K/IFx
 mHkhu1z7
 hFJqdf6NmZc/wPP4DlzwfE10tbGG4Fxh33gXSELO6aOHQCuOzmcnG8P5FtfaFwiAwe1K3aWApH5URegGVTfFHEKDbU2Pw4bdHyO3+lQD3GSPseWd6aVZtHKAGBMZkiRqM63hzph0uOZanyXjD/CMR+1fue7aItHQ5JzO0irzfkaAK5OuXDEdZwLQQgkHM2Oa5AWhHzSHPcSqNqLn2AM0uN0LVnoFHuwJOPNcB5djTnxEWjqSpB5Gf56PTWpJiuE0dYcS7VYeHH3/NPXeRI9rHpgGnBA==
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

Return CODETAG_MODULE_EXCLUDED from load_module() when profiling is off:
codetag_module_init() drops the module's cmod and no counters are
allocated. codetag_unload_module() now always calls free_section_mem(),
since an excluded module may still hold a reserved section.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 include/linux/codetag.h | 4 ++++
 lib/codetag.c           | 8 +++++---
 mm/alloc_tag.c          | 8 ++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index a25a085c2df1..88081c618673 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -52,6 +52,10 @@ struct codetag_type_desc {
 #endif
 };
 
+/* module_load() return values */
+#define CODETAG_MODULE_LOAD	0	/* module loads with its tags */
+#define CODETAG_MODULE_EXCLUDED	1	/* module loads without its tags */
+
 struct codetag_iterator {
 	struct codetag_type *cttype;
 	struct codetag_module *cmod;
diff --git a/lib/codetag.c b/lib/codetag.c
index a9cda4c962a3..8506ecab9ea7 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -238,9 +238,10 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
 	}
 	up_write(&cttype->mod_lock);
 
-	if (err < 0) {
+	if (err) {
+		/* Error or excluded: cmod is dropped, free it. */
 		kfree(cmod);
-		return err;
+		return err < 0 ? err : 0;
 	}
 
 	return 0;
@@ -388,7 +389,8 @@ void codetag_unload_module(struct module *mod)
 			++cttype->content_id;
 		}
 		up_write(&cttype->mod_lock);
-		if (found && cttype->desc.free_section_mem)
+		/* an excluded module may still hold section memory */
+		if (cttype->desc.free_section_mem)
 			cttype->desc.free_section_mem(mod, true);
 	}
 	mutex_unlock(&codetag_lock);
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 0a7b657fe2de..461fa87fbb0b 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -977,9 +977,13 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 	struct alloc_tag *stop_tag;
 	struct alloc_tag *tag;
 
+	/* Profiling disabled: load the module but exclude its tags. */
+	if (!mem_profiling_support)
+		return CODETAG_MODULE_EXCLUDED;
+
 	/* percpu counters for core allocations are already statically allocated */
 	if (!mod)
-		return 0;
+		return CODETAG_MODULE_LOAD;
 
 	start_tag = ct_to_alloc_tag(start);
 	stop_tag = ct_to_alloc_tag(stop);
@@ -1002,7 +1006,7 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
 		 */
 		kmemleak_ignore_percpu(tag->counters);
 	}
-	return 0;
+	return CODETAG_MODULE_LOAD;
 }
 
 static void replace_module(struct module *mod, struct module *new_mod)
-- 
2.25.1


