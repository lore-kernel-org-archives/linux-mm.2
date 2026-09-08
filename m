Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49654C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACE06B00AF; Tue,  8 Sep 2026 05:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C1C6B00B0; Tue,  8 Sep 2026 05:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471FD6B00B1; Tue,  8 Sep 2026 05:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 232CA6B00AF
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:25:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4306C045D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:29 +0000 (UTC)
X-FDA: 85190061978.20.815991D
Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id A67E7120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:25:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xkjjv8Qk;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859528;
	b=IpPz8sQnEahOQWBbMMewC0xrDIu9U+ekGPXqvaeHGGoc/n4A4ed/xwMAL3EGgUI6h32s7Y
	5QQ//dk8OIh5QV8tKweOpf6+g3q/C1ADGsRjkaCjoE1aPvVH9cq4qO+l1M8NiQeNzYbbpv
	vSY+XYQvdCXt4s1HnWQBDPt2vnGVcxc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qY9KZE7C2ImgGwYoQ1/B0CPw9El5+3d4z2obiLrOK0=;
	b=RW3KAgj9XhrQv/XwrFG80tkpx17VzI6h1gHkcGiimDuvWcVKx2ki2MNvvxo0dF6qRMSW9w
	6PADg8aPwfJf3EPezIcJa27vDB8M38VAoerZPZapeiN4aVg0ZYS5ckKHrJD2eL6C4dqHkS
	nc+BfP0uI5ZSyvSCXZAFcG/PN67ipO8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xkjjv8Qk;
	spf=pass (imf29.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LBg+sSLJXtOw4WEz6FbemiKRacEtP0xCjkkrVUCvXnY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859526; v=1; x=1789464326;
 b=xkjjv8QkGbLFxmumUWQo4JmgAxkQdSsD3poo1JVJvohVH54wQYpRVSmscrnbe3XBjOUUoZQE
 hQBRbWe66aujOa/v3EIf+Vw0P2EtRZ3WwlJywiexqmvjcmHx1KlvS9HJo9eDnk0iJTMsLMAkCAw
 gkWmDBKkN2Vydw4zjcWzGHNU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7cf99981dc3c1c49;
	Tue, 08 Sep 2026 09:25:07 +0000
X-Mizu-Trace-ID: 7cf99981dc3c1c49
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
Subject: [PATCH v9 2/4] alloc_tag: clean up the populate failure path
Date: Tue,  8 Sep 2026 17:24:10 +0800
Message-Id: <20260908092412.115953-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260908092412.115953-1-hao.ge@linux.dev>
References: <20260908092412.115953-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A67E7120004
X-Stat-Signature: j3s4ebdrggfuwpo1j7one3hoyyg1hesf
X-HE-Tag: 1788859527-26339
X-HE-Meta: U2FsdGVkX1+Qcgy+VomTBy5T2gDKWsmMi0cr22PgzC8o1q2pFzz7AuFHILZJQqC4MmbyiVIu9U36vq/FS9ndXyCJM59PpSAx27Z8h5YnfUGAu/+3tc4mxhfU88t0fWFNA0BqutCP09sbFHXzoASWpTcgXGOrgXq7945CRckI8gwMzs3r2EPHUK+ZjsDZ3k3C1161cQpTSc8SwkZj3Kp+AMV3fAye1dHWjrUIP4e2LwiZ/lUtztlKm33g3ZehGYHFAzUhvbWZNGJafVpFglaZaPpMb/lYyCZrt5nGl39vsZE0ONwTDFQhESwhfNkdmXgElnZwcvLAB1FqRXq79Rd1griHKsK1sCFLDlD6eYEOHkaQwnkUQ4qapJL406dbcNTjR3Fl2S+R19BLvuHy4wC09WowLMKUP9KtMkUjloHVOB16Ui+TdisPd5c7XGHuhnHRDs5ZXVlq0xp0VeFNrdnMUjUJnVlO+spCWi7/ueAyQZLiMUZ+fWV8Xh76gdhEWPN8MqnITi5E4s/elmHUqrQizu0Wm+hL0aimPbc1o8ksN3E4oPh4oDe+bwTKOy78BFIe7tCfINiKEy+4CcMe7J4DwJOqkusouwewJ9ynb8T7VJ14ULPGRQG0VLahXtI7RCYaFZClUyXN2qdF5LBbAd251Wk9YO8tAzgmJxt/0ETunZ9E+Sygt4pnxQdCIissHPXZIkqf3mApFYueSki/BHvzmZSo+1Im8GWYNxXD7gqkrimsNBMdp5g963nuDXJ3IjXRVem5PzDwC7SQXC/C7HUk5sg19BGWjThuL7oftGNbcDlJsNcMdz4L6vn8BQfAjQ1XXA2vqjALVJTevLrEIBGNLkQNaqJJadbD9g1jjfpfyud14nyhLwL8CWA+eYbPYt0ABt2REGsnOa/JER3JcBoTRgsHz2M+wb68zo2gOT/wve+9K/zHnIiuDW/lFDJAV7oFhHZQvkL4KMLyJ1TDA1P
 L5I61Epa
 D1xglh3FiBFk+nwlRNLdwjOBKUA8DAms+/LqcEjIK0xSYR1sW2c34TJLMzvwRya48PeQa6tmy6FT7RKCM81IERVrBNNEYVpGgXBDg/Rl4PV7d6qNjmxrTppPNDrLCKK5pjUUoru2I6nRl6nc0QPgN0ijAT+kByKjD/aOI6PYQxplMbInkOx+KgcDvfKIMH6xdf4V/3n90/t1Q2QGqjIVuq840J8Ek78dBuEYcJxGoouCcMCrexpgH95P588OrOP35N/sVFHiCR1OWhJFAz2TRw/y4jI5/jWkZfE5MVJmfrK+SqWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The reservation is already stored in the maple tree when
vm_module_tags_populate() fails. A failed load never unloads the
module, so nothing releases the entry. Release it and roll
module_tags.size back. Without the rollback a concurrent load that
already passed needs_section_mem() can reuse the freed gap, skip
vm_module_tags_populate() and write to unmapped memory.

vmap_pages_range() may have installed some PTEs before failing. A
retry to populate the same range would BUG on them, so undo them,
but only if vmap actually ran.

Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/alloc_tag.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index e7a79116ad81..e7a40a276ed9 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -812,6 +812,13 @@ static int vm_module_tags_populate(void)
 				     next_page, PAGE_SHIFT) < 0) {
 			release_pages_arg arg = { .pages = next_page };
 
+			/*
+			 * vmap_pages_range() only runs once all pages were
+			 * allocated, and it may have installed some mappings
+			 * before failing. Undo them.
+			 */
+			if (nr == more_pages)
+				vunmap_range(phys_end, phys_end + (nr << PAGE_SHIFT));
 			/* Clean up and error out */
 			release_pages(arg, nr);
 			return -ENOMEM;
@@ -955,6 +962,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		return ret;
 
 	if (module_tags.size < offset + size) {
+		unsigned long prev_size = module_tags.size;
 		int grow_res;
 
 		module_tags.size = offset + size;
@@ -969,6 +977,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 			shutdown_mem_profiling(true);
 			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
 			       mod->name);
+			release_module_tags(mod, false);
+			module_tags.size = prev_size;
 			return ERR_PTR(grow_res);
 		}
 	}
-- 
2.25.1


