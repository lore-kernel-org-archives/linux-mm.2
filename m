Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D496BC5AC67
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 03:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90586B007B; Thu,  6 Aug 2026 23:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41716B0088; Thu,  6 Aug 2026 23:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933146B008A; Thu,  6 Aug 2026 23:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 578C66B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:12:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0FCDC0311
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:12:55 +0000 (UTC)
X-FDA: 85073001510.03.A94A1ED
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8660740008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:12:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zgch2i9C;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=672924bdb=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=672924bdb=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786072373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jbw8Gl9IPPMQwggElOzlBjMu2akYnLey90bjnD9+aL8=;
	b=pAsxhMoWdqje3YYezQ+VjaywhIqQSGjUi7dTTDkEgbGQ+LWzIwm8DQ7YkghEsDxVr/mqvY
	JoplvWf4A90/1j1YLQ4EPo0kxM87fTGsPurW76XvmvnS1QlagYHj5dd10cM96nW+LIupYA
	A9UdYtCllYaqMcgC5aB6dCqEQzeQgLk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Zgch2i9C;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=672924bdb=graf@amazon.de" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=672924bdb=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786072373;
	b=ZoIWMNs3d/+1fPf7IJ32Pa4+I/dP2UhAPcft4q+ZUKgnB+P58rsxModAgqJqVyOB9UDKIz
	PmmpckxhdSzgnI9oCFfRcQPAv1IzTNihYQzuJspptX5vFD0+9+l9e6bZgYD177+x958XnM
	YoHqXNnP81y3or1AEDEUrqHZZXJX7zI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786072373; x=1817608373;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jbw8Gl9IPPMQwggElOzlBjMu2akYnLey90bjnD9+aL8=;
  b=Zgch2i9ClKWFNAs9o5zAOxTpuuQlru9QbXvYRaTgIRG5QIfgdlPg0gKH
   ba3upKYyINAxytzaMIxSXwFArou9tQnR5hb3EZAmCfZ9nXcEy9nVP6KBB
   0PqFlk3sbadZ/4Rhp/Oe7nOBrZYfs7lUKkuovL2RSiYjZBhK3ZY6/0Bpa
   eUMLZR6CWV8KodQeRWDjweKvgVdKdFdyh0kPOkIoHnFwvQOWIXi9KipzF
   MuPuq6PLu2zbgh53XlHF0laUtMD8YMrdgxJLJ1xIrlUqSF0zy6dI5cdKN
   B/9qXqBD3xb5pYcSlt3cI2bQxjuUE1LsfNFX5soQ/m6a0kSyM/qTEEfWL
   w==;
X-CSE-ConnectionGUID: JubALCncSg64A77xzgDv/A==
X-CSE-MsgGUID: FSk0IWS0RpO9EWG37I8vZA==
X-IronPort-AV: E=Sophos;i="6.25,209,1779148800"; 
   d="scan'208";a="25138706"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 03:12:47 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:25824]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.208:2525] with esmtp (Farcaster)
 id 0a564dc6-3bcf-4164-863d-313a61187ca7; Fri, 7 Aug 2026 03:12:47 +0000 (UTC)
X-Farcaster-Flow-ID: 0a564dc6-3bcf-4164-863d-313a61187ca7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 7 Aug 2026 03:12:46 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 7 Aug 2026 03:12:45 +0000
From: Alexander Graf <graf@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [PATCH v2] mm/mm_init: fix out-of-range first_deferred_pfn
Date: Fri, 7 Aug 2026 03:12:43 +0000
Message-ID: <20260807031243.87904-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.99.218]
X-ClientProxiedBy: EX19D037UWB001.ant.amazon.com (10.13.138.123) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 78rycxoy9gpwybodkeimt44a9odtztdj
X-Rspamd-Queue-Id: 8660740008
X-HE-Tag: 1786072373-287372
X-HE-Meta: U2FsdGVkX18RYdESH4aMTqgMgKg29g36LYype34QKxhAbdVurW2jUBLtPsei2wbhAP0D2N9Z2JzvQugNl/x6ar2FcJJee/tXEuQvbUCeCjxzsb90H0psR0s4nDOKXe96go29PWGKe3qRkYPNmXsiiOn52YCHE0RA+3dP+5FMf2ZancE41MjyyzYMdlA97Vyc0K6mEVCUCVuIvUq08aoP1Z+djANUKIZO2p7RH6DBltYlr6+TImcrDIy9PpVbePJEVP80+q/utzXInwbFJt9eS3lbGXgj0mLzQg3aAabe9xa09I+xBp3p2CTDl5oDMNmTPILiuVMHkLgGVt94VOF1yfH+pqiA8tjrmhPRqEh7V7NI9PFFSZ2MZ3n50d29BleNurKwTqEVk4jPUX+9YYSJ2vputfM4TTmIyHKvE7gWOkIyxoTAADSWEDXMwfG+Nu+c8mh4k/pSSrfwIbvgoQVAVehBWERg5yWhRKYlH9St9vSWT6qLFbb/5R4uhsKW2SruwjZJvyKbHOwESXLahGlKHz85ECpbw+c1JmFDINU0D1RP52VKl0O12WrH/g8in6smag/7N1Jx+b9I/Dt3jCHc8t7rcRp02yGnv8idXm2x4w3/yWmg6O7MwCqGrNrLPpnTMh7tztpEDx1xmm0RzNc/jAzeHQ6CHehXi9eYkT2gESjS8I5N0uBfwHh4qKcZHTR9PUfuyzXFbhud+547Zg1+/IaIAfNaNyUCC8a7RPUEfRlv9Cf6gLVdE77ZG9b6NFOK1ft3r5/92veUTE8Iwcxj1AhjRzEdmSC4kHBil4MLUR3M0XZA0+lFo1ihqqVc6YLQbO39a7QXCexE7PAEFovXXC7i1CmySYhkzGXFpdQCosl2f0BcYSkFNew9fjIyzbSobXtlPCDQkAvnMmMCyLnEdr7GlyBsklT0Qi1zG96Iim+77+UXIJ+Fvu5wqjse/ST43EjFqazqkmKQBrEdExP
 aUTie8Ar
 TIloHt/zoj67JFtfVV4nN4wrrqiqxozkLw1BbXPw00P4fDqgjrz3uTeSXxy27tCrOZws7nTQwwvbJVrVSVhXGIX3a1Wsaqgj9HFHMqBxMPdjJF7vnUcO8oomDw5Jx39XK3aQcKnLAkaZJmQUkO4yi9X266K7NKbseFhvQQbyR+fd5SsbxfnG2JoZmSRZ1xVgJFBfEjNHHzODWJ1lbMDANaZy0uGf2KgLsIyhwuTomDGK+rO5bExoCrFtt1QUkJwebnVUrYAs7OkpOknCjJH924zyFX4D6yHYNfcoh5iZFxpeU4jpuTPwOoK6uZt2kkRrmnGhBVulAcXQiu74m73WQIhxi/tsltW1cNYcWNPk8zLw4D0AYyEFctTx7W/pxLw12mc1cRegTHYV1OGT2yt0ljhF9bhcSAob2cr4abNB++YsljUqFG46cwXf/r7LuNvlojDzI3pfrDxy+0E4dV9qIBaWUXFc2h9YvhbVAq8/qUgRjknypN7KQTfA7jrg2nkd8HUOiR3QHANojvzWvBE36alslCQjizZ57JWmL3p1HNU71ttP6i7aQSj14ljRubuFaZkBCAclBbFEQ/4pD0Pn2ewBnV1JeuqyxNxVerPrxUc6EhhTkgaYMxb1TqdhAJRi+uaZ9ZObD1Hx1+8eTCAQasxL4x/DAWXreLOvKxIlj2kosjT+LDzs4xEe9VrsMcHR/DATfN/NVeLGyHQPWL362Pz7tEqSo/aioxgqCQx8S9t3mPruf2zhH9FgQK33V7bSXDaoyP10F2ElEg+6pQ1Ww3JqH1b0lm9KsmSqjQaAzS4MPfa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled, deferred_grow_zone()
undefers struct page ranges early in boot to satisfy an allocation.  With
a large CMA reservation in place, the ranges it finds may not add up to
the allocation it was asked for, and we end up undeferring all available
RAM and still fall short.  That is fine in itself: the function accounts
for it and leaves the caller to decide whether it now has enough memory.

The function also remembers where undeferring is to continue next, in
pgdat->first_deferred_pfn, and it walks in PAGES_PER_SECTION (128M)
chunks.  If the node's RAM does not end 128M aligned and we undeferred
everything, that "next" points past the end of the node's RAM.

deferred_init_memmap() later picks up from first_deferred_pfn and hits a
BUG_ON(), because it expects a pfn within its node:

  kernel BUG at mm/mm_init.c:2131!
  CPU: 3 UID: 0 PID: 36 Comm: pgdatinit0 Not tainted 7.2.0-rc6 #1
  RIP: 0010:deferred_init_memmap+0x1b8/0x1c0
  RAX: 0000000000236000 R13: 0000000000238000
  Call Trace:
   kthread+0xdf/0x120
   ret_from_fork+0x187/0x250

Detect the end of RAM in deferred_grow_zone() instead of assuming that
more deferral is always available.  When the walk leaves the zone (which
is where this node's RAM ends), record ULONG_MAX, the value that tells
deferred_init_memmap() the memory map is already initialized.

To reproduce with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y and CONFIG_CMA=y:

  qemu-system-x86_64 -enable-kvm -m 8032M -kernel bzImage \
      -append "nokaslr cma=4768M@0x100000000"

The above command panics on every boot without this patch and boots
reliably with it applied.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Alexander Graf <graf@amazon.com>
---

Notes:
    Changes since v1: changelog rewritten for readability per review feedback.
    No functional change; the diff is byte-identical to v1.
    
    v1: https://lore.kernel.org/linux-mm/20260805224421.15794-1-graf@amazon.com/
    
    Applies unchanged to 6.18.y, 6.19.y, 7.0.y and 7.1.y (checked against
    v6.18.39, v6.19.14, v7.0.14 and v7.1.4); the deferred_init_memmap_chunk()
    signature change in cbbbf7795fc3 sits outside the hunk context, so stable
    needs no separate backport.

 mm/mm_init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 498d62c4ece3..91177be58a00 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2214,10 +2214,13 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 	}
 
 	/*
-	 * There were no pages to initialize and free which means the zone's
-	 * memory map is completely initialized.
+	 * The loop only tests spfn before entering an iteration, so on exit it
+	 * may point up to a section past the end of the zone.  When it does,
+	 * the rest of the zone has already been handed to
+	 * deferred_init_memmap_chunk() and nothing is left to initialize.
 	 */
-	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
+	pgdat->first_deferred_pfn =
+		spfn < zone_end_pfn(zone) ? spfn : ULONG_MAX;
 
 	pgdat_resize_unlock(pgdat, &flags);
 

base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.47.1


