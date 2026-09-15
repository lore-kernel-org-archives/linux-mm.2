Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC37AC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C594D6B0088; Tue, 15 Sep 2026 02:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C308D6B0099; Tue, 15 Sep 2026 02:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B48686B009B; Tue, 15 Sep 2026 02:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAD56B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:59:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2F7E14035B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:20 +0000 (UTC)
X-FDA: 85215095280.28.3BD5972
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1424A40002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:59:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XvH0H/gQ";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789455559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0AoV6LYkdymJpDD7VSHb3T6WvZ4tQ8szTYnbRZlsV4=;
	b=qd7udlsQ8bGxe4jstb6a99TLl2K80KcNloDsgbHiPH8pYlC9SZVaK6U4wZBK7Jbbi3H8A2
	Pvek3UKGWqMxeHB7zzoQyu/0ix/xzjgVGIzf6m6vRfkCFHnfQItJPhWg2chpkMyia/2yR/
	dLy+mZCdNzCwQAmC6VzAYpqMXSlDjtY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XvH0H/gQ";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789455559;
	b=Hs91+DJGUSpGwvO++kNV59WLy2kXpdVDjJrBhYQoPaaJXM6SSjEXqDls8LARP9MOnwt8MX
	FLworr9hhMUtK1Sq0bo1aymoDkJoj3Q0fRFGGg9rpqrUxftGwJSawNTS5XBsWg0Q/syvHr
	HvmZI6NrJq3mQ41606OdQY9QbgqH5fE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5Vw+v6tRRrP3hQtpFy1LEiukFTySuc0mxZr/k7GpH8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789455557; v=1; x=1790060357;
 b=XvH0H/gQ5qZmazbWuhKBFp2+oUOmHjfpydsM0L5V/NgCCPIFe6vhmxRZGBaXpsOBgGDKmDtd
 zmbEMmdwUmy5/lFMm4b5JNGQF8A+ICmaNJs7q8QIbbToqFgD6TyKUsVV98xeMTThCSFOoi0PBhn
 LXSlF8qY6ajAsV+EVsusMMQ4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 332822dd31fa1db3;
	Tue, 15 Sep 2026 06:59:17 +0000
X-Mizu-Trace-ID: 332822dd31fa1db3
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
Subject: [PATCH v10 2/6] alloc_tag: clean up the populate failure path
Date: Tue, 15 Sep 2026 14:59:57 +0800
Message-Id: <20260915070001.113559-3-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260915070001.113559-1-hao.ge@linux.dev>
References: <20260915070001.113559-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1424A40002
X-Stat-Signature: 3ghiwp3tzpyarxruhckmi5o3ti38rxkh
X-Rspam-User: 
X-HE-Tag: 1789455558-551118
X-HE-Meta: U2FsdGVkX19I+yTnFu5cikD3DsdK02ujcM9uk16F2UM4iTZ1HsgSxrRTZVtkhLt28u3oJ9yp4lY7Bde7qMmt6ktfqdkUx35QU06ZMpZ67D2sxmLwP6/YrgscL5nog7gECN5H3wqv64nzw56lK3kjG9pfYgsChL1IK0Bd8+oaWbGc6tc1PBlM5TdEksdWzqCAMLZTQTtY57n9/FQoEGs+czDSG6lauWvWtuUlQorYk1by/KJGpgc9C8K2ZyMdDOu4O7VSh/hdwWtDpKqfuKW7DZxH3hTCSF1IS4FPC03h/PzG7fTEJj5294AM8mON5BiDzXo17J9cltI7byDV9yv3Kl8qiZb/P0h3hji25irIkhXQaN3s0Qy2Up+Q6vsQvKhVLipcoZM45ZoM/Kij9AlxBetdOsY9+vZBn2wTbgVKpcFBbbH14M/ccsFWKYgQwubWJ4tGFeCnX9NPcYSYJPS1fldf/hcnI7FQTRxk8n9P5Vuw8hoVVW6lw6lIjnuywN9v6PtMk6mkPWlCqT0N73rD8JDdbH4EdhcTQOyZlsMUkzGi7QGjgpJLUyo1nz5kZJnuRe/hp9r61B1HEa5YccSLl8TCf+j1nonmV9kEVUZqTCdXcT0KWFRs5IhDEb1gvFlFso5Lusdnc5bGxyRD/Bvcw/ppzmnz6k3NLgYB0Zliw3cTVkaocYjV9DNM8HoO12wGJjXgQsLA/Lgik2ghPOaI3igzhIZfnSK083WN8jSU53hTQzn8/SSNz4udIgyu+4bmdVqJ6sMwxP60ygREbf/3xHnrwJTZhLDnJwt2vQSikCauQAYFVRTp68yCVY3FPG0sCUprnbHV7FdWwb1Sv3/nuI+UBLNEtoVXljwH5yh4pjmyQu2KHIYyUnq/OhjuO4PO1hxWJr+dRgLzKpCO2FKkIJ6+Vu/YhfDsaG0wgK7HqB6KWvNFH1ccJvIIh3LJjJTsaB31NmhjK+JpV1FKiok
 2t2Kz3SP
 uNa5ZjKs1aEoKuy5AzWsE2EikoESse6NZ2qJkgpOd0dwOEVXtsCOitlBVooAOccbUHKSxjSfteARfpwMF6LUK4gqBo5ux4GTw+87PKk7PmyaEVtC0BgLcycGas+MIP85sYZKXIrBlq5l/dO3V4J6NljZajniSkFVoSN5zF3L7dBCqeAkolkBVCQl77b3+Gq1RbkW6fGZ1ansUoVkGmsYNfvK+mC93U3K5UvUsE/9RevRttZP0XDL+uQG96ilcr8cZp1GP6AsV5Z8SRR8zR9Z0EinvJvtThYkmwmCGyXk61uT9+dg=
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
index 2070e682fe10..95ddf5b743d0 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -804,6 +804,13 @@ static int vm_module_tags_populate(void)
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
@@ -947,6 +954,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
 		return ret;
 
 	if (module_tags.size < offset + size) {
+		unsigned long prev_size = module_tags.size;
 		int grow_res;
 
 		module_tags.size = offset + size;
@@ -961,6 +969,8 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
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


