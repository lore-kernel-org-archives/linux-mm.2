Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0954C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2C16B009E; Mon, 14 Sep 2026 22:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87C8B6B009F; Mon, 14 Sep 2026 22:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C2E6B00A0; Mon, 14 Sep 2026 22:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5096F6B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:43:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C5001202F8
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:48 +0000 (UTC)
X-FDA: 85214451336.22.9282A84
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1CC2640002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:43:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjhZH6q5;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789440226;
	b=mWVV3uYdj7jlPr/97mYmH1LLje6T+D21zuNSNZvvWiwkn2iY1epqt031wAYKQ8qZd6qa56
	DvVU8azhiHC/VXcM18kaxtd7qBvw74PMVF5OsQxKv1Tnuvlb9wHNQepxrpDetFKXC4gdm4
	5jyEHUNoZ/iBxqfQLDYnjueiopUJjcg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FjhZH6q5;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789440226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BvkMh9Iy1JobJgrp6Ml+mHhqHRRyrh+l4E+WQY75hyg=;
	b=8nkeFVsqZUJqy1QrEZBReFc5OhDOyeaYOEI4ipEvFUo1RM3K2iS67zUs1DENaocUkPaveZ
	2Cj7ehShOg5OclC/CyR/1iFCog3bAU7MrPxm/8l50csFtxgIqf9bIs7eu58RXI2iNnIRiQ
	n2vXwO7MNmBGix/ggBFtsd2Ak7Rpaxs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m2TNnslMOJm74BH1oK0RGdEaDDffaGOdJpOrKHOeGS0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789440224; v=1; x=1790045024;
 b=FjhZH6q5/++5RhX+BFEpDgQkfRNl6jBvLp3ejdv+DjLlWeS6CKbSc9QiWSrLyT2Gy+GyHN3j
 t+RxqeeXcAXvmttBV/pGbNY8YgiY4tM9fJnlCNq2cXfqbHBKQEUCMuHg1WOkVddHp+YPVIcMwgg
 ACJykYRAx9PZlDvj4yhjDDfU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ff7b2e19b41e7456;
	Tue, 15 Sep 2026 02:43:34 +0000
X-Mizu-Trace-ID: ff7b2e19b41e7456
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Subject: [PATCH v2 0/3] mm/vmalloc: minor cleanups
Date: Tue, 15 Sep 2026 10:43:29 +0800
Message-Id: <20260915-vmalloc_study-v2-0-cc4dfe635e22@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANGwqGoC/3XMQQ6DIBCF4auYWZcGsaJ21Xs0prEw1EksNKBEY
 7h7qfsu/5e8b4eAnjDAtdjBY6RAzuYQpwLUONgXMtK5QXAheVdeWHwP0+TUI8yL3tizMtiopmq
 NGCB/Ph4NrYd373OPFGbnt4OP5W/9J8WScVYLaWRb113D5W0iu6xnjRH6lNIXT6evnaoAAAA=
X-Change-ID: 20260914-vmalloc_study-b3fe7c738f2a
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CC2640002
X-Rspam-User: 
X-Stat-Signature: hgb5bhk3759g3obe7kufdjm1hx7mj54g
X-HE-Tag: 1789440225-855426
X-HE-Meta: U2FsdGVkX19Lsr3fmK/coOGMOXpVQe6zobz2FNYpC+kGarOZW2/LZlmVqsDw1fwWiOJRKmjsXu3GtImBzW6yGaQ45RiNNnuFOD9WivtmDfKLVNEvyy4U99/NQFtyUf1NtA37Uap9EGuV2j5gU+jEP7n4jkXiJZdq/VW1JC5b+hE8ExRfabxk5o5Xkss0+6RrFRvFdJzgFH5zSPphthkD9SV8Z4BuNWdrifG+QoHUO6XjaynONwlWQlSUBZnt97N5hppHbpIV3K2WWLzzFTo96ZQ7thuNfbrRy9tyBKqouE+grYIN6yQ8jhUlVQxnczNXl5/EJli0K8h1lAML1dqp6e1aBqaeG2nkhklbJaxF4YwC/Y3Nn+JTuhII2idmlSYeeF1y1KMBghKNY0fGeV0dcSd0M8iA6BDQYcQkfY8U6mMgD7bqKCdpLfCzv/Syho3kudgTpeoeM3GnHtJSKCEYtc0W2K61/enNNFqRfvWFeMKsNGdHq9FK5Pm4t8aCpuK77zmDoRNOVwFQGZAvu/kQOzw8y8tJu7chj614PIVeeEd/dustLKehfzrA1MYd5OR6frOinW3P6GCyWDUBFdcw3OF0Ye8jX9Yme5u0utnT0q3qJIAbNgPXie6uNuMl7XO/VUd2+PfP1JcW0bjNgBSEwWsc/c1pt6QhEo5IurRWLPnAR9rUppjRbI1h/aOya2kDFxacNkF8rUHk0bHFA2bepMHWtBbJkr14Pmu//SoMQEQiJ26SsCxmwCPudqCu3yIyW45RGJMHNcVipt7moFqdcA/9AnNSNjL7MWWqCw3APeWfRp+vomDGUM2ooOBL+DIx/bJWL0qFh01XBADLqkmr+EoNwL+nQGiSJx4YoJGSAqHcVp1rpsS7//cciDI3aJ6Dt6EgfVdzHCMum7UjzLldIcQqN0ETC65z07QwIUL+kmcP8NeQ5a1d0FGZiLchhLbeD6YTFxVAPEqRWI+XPOx
 fbps9avW
 b9w72jHeuh6ikYpvR1TI0cyYbSGsBlUw4lEjqV532LT8BR8v8+Id7B7wYnivJS/O133S5eoxXrMsFCSoHYiVlBWm5g3Duq5GHCA5eLG3NLgudkCsDkpjkENAwTTFk/D9OKyXOSQMYTvSHupdivy/lVaZsue+5bAZ+Q17U9+QYUn8TxWGatbOUxvltVtLGHeqXN/9V3MJVcchg5xTpjY21B5aIWf7FjLZvUNv/rCCAeJaMR8CH1FEQnJy2/1XiyXo53yAE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small cleanup series for mm/vmalloc.c, no functional changes:

- Group xa_init() with the other vmap_block_queue field initializations
  in vmalloc_init(), instead of after the unrelated vfree_deferred setup.

- Extract vmap_insert_free_area() helper to deduplicate the allocate-
  and-insert pattern that appeared both inside the loop body and after
  the loop in vmap_init_free_space().

- Extract show_busy_info() from vmalloc_info_show(), mirroring the
  existing show_purge_info() pattern, so the top-level show function
  only orchestrates the two data sources.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v2:
- Patch2: Keep space after (unsigned long) cast per Uladzislau's review.
- Patch3: Drop the NULL initialization of counters in show_busy_info. 
- Link to v1: https://lore.kernel.org/r/20260914-vmalloc_study-v1-0-526f68559706@linux.dev

---
Ye Liu (3):
      mm/vmalloc: group xa_init with vbq field initializations
      mm/vmalloc: extract vmap_insert_free_area helper
      mm/vmalloc: extract show_busy_info from vmalloc_info_show

 mm/vmalloc.c | 56 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)
---
base-commit: 68142f986ff04b2b70b31db00f719bf690f64a9a
change-id: 20260914-vmalloc_study-b3fe7c738f2a

Best regards,
-- 
Ye Liu <ye.liu@linux.dev>


