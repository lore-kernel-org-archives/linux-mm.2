Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A996C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8D26B0095; Tue, 14 Jul 2026 05:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0246B0098; Tue, 14 Jul 2026 05:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E5E6B0095; Tue, 14 Jul 2026 05:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5E686B0095
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 725A01C02AC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:19 +0000 (UTC)
X-FDA: 84986866398.27.75EA7DA
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id C3B45C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="s5/7jKno";
	spf=pass (imf28.hostedemail.com: domain of 3IAJWaggKCNUA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3IAJWaggKCNUA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021537;
	b=bmCCYHhyb+T6z3DJkCmlzU7qEPVRJWMGPzym0INJEmF1PIKgh3wXXhA89zPxCaAHUDsc62
	N05W8oaByoygx3pbmz866JvysC4nrLEqVp4VusU9TWAGYFMaBbJzF1mN74ftp0qjpH3VzB
	0ImVN1Vdp1SpyXLlbUnLFvyVcxFC9CA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="s5/7jKno";
	spf=pass (imf28.hostedemail.com: domain of 3IAJWaggKCNUA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3IAJWaggKCNUA13BD1E27FF7C5.3FDC9ELO-DDBM13B.FI7@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXBjnrDZv69VqIXFsxu8XfktPLqyg9BDT74BtCfYp/c=;
	b=Hk0xhoLbkq5lq72vOGu43J4J1Op9BIG65159xe2vbdnOlfKeIlZP0I/3K6ol/B83Z5/BS6
	Xo2Q54JkHFJXIojXSFMiEJK9NAbAAcpJ3jTiolNO3+LOb3U7p9yGXwGObkUOvxEh2pfTLc
	T5o65CO6pgheZ9A8MoEz4/VNpoLirfE=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493ba771d1bso8426305e9.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021536; x=1784626336; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TXBjnrDZv69VqIXFsxu8XfktPLqyg9BDT74BtCfYp/c=;
        b=s5/7jKnoUq9qiwe4h8jZTRB69HfG67zR6NJD1fl/MotYAHyjhPl/oJivOfsfW8XooC
         nHCWfFkfumED7dYZOlOV61mbFoUl+jcDyioFp7VRL0+s10v5u0ylRV+BuICRbLHnz2ql
         5lfUmi/VT3548z3Gy6+o29I5MAlbMe8u47Zjzad0fHDIUfZhuod8Grv0oH7Z4DCocJWV
         uulzbERKizDO2scOAavLZawtwu1+Me/oZKTVgT+Ys/ovstm7mHvFd35RxNybGCmjsBJO
         WMMijPMJGNvOSOwVfY2e+rDKaJSnqJHXl5Cj28/+mSRLxvcpTXjMeE28I2/Ab1+Dyarj
         fHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021536; x=1784626336;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TXBjnrDZv69VqIXFsxu8XfktPLqyg9BDT74BtCfYp/c=;
        b=Zy/CZaLVSAAaNeC+ZmpN9Z8uGe56Wp+WYb1IlEGx5KachdBQUYDDviUJHrrqQ36G95
         /Nb+ExP4+o3TkcS9kjMuS7S8BCaljw6if/xcvZeNYjSDU2yVG6lYPDfses02ZaIkqtVj
         Mwljzmur1ouVG7VsgfppoYytQPH8vFKpbfOwdJptEmB2D2TzeGdf86xo6SxkSkc1dmLE
         EzM+aqWhN6jh5OeXQTHyOVlhU5B5eM46gSOjaEFNpoftJeAwVwdj7NiXD7RwpmmHviUH
         G8ftcknfqVb9Y50r+JFlvim8Lxt2/xswB19h73870aOA8r4MFoRd6ziXSAb9kAZQRasa
         tiNA==
X-Gm-Message-State: AOJu0YyXz0R4GFLnO6l9BhfOxY2IkL8OTcgTW7fGqQB5kDXC2/jFWZtR
	+CMvwy00uJ+hPg1gKVJyh+Hdnz00J3em71xmpikPdgHx+dro0OhBJFRSRAVciy4oLv84dsuRVT7
	ifiH69Qe8tb+mZw==
X-Received: from wmcu5.prod.google.com ([2002:a7b:c045:0:b0:493:b008:cbb9])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b77:b0:495:f31:7340 with SMTP id 5b1f17b1804b1-4950f3174e5mr30731045e9.5.1784021536099;
 Tue, 14 Jul 2026 02:32:16 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:32:00 +0000
In-Reply-To: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Mime-Version: 1.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-2-3c20ed032b14@google.com>
Subject: [PATCH v2 2/4] cgroup/cpuset: update some comments about the page allocator
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C3B45C0003
X-Stat-Signature: kzp3kzh3pdcergmus9j3ckg34c5jw9tj
X-HE-Tag: 1784021537-37218
X-HE-Meta: U2FsdGVkX19R5/jw53T8AkX3YPrK0I1q8+lr/WhZhYJNAbQredd9rDVb0fUNCyFUgYRSjgketgJnhr7wcYGxGrFlwRTO3X/7U6stUvt/0G/tnTJgmdFmRmxNMZANvUOW/6EVk3wVaHtWbbrrgGX1Q2RG5OBBibGi1WJfRMIwqfOXWN7Pd1GJXo5nOO0dRPmBiCbq9CFeKAkUo5TYyYWjFAl923oQ8P9/WWDo1UIOoSXsbE3v55AzP66a756WjgTPIg0EdRFE3sP+swOxzUp6VWtdrrqPQIwqlRJ3fdguJhKKnm8e52+vi5gd56oBFFVOoMBCk8wDPtI21hWHOXhyXP/dSnTeXmpZ1Ml41jGfUU35JZl4COK1jQPzmjuiwUGVHsD/h4/O6V4ItQl+L3deQA2E8sCfK6m6ay0z6kE8pwkqtCft4A+0o3JzvDx4MSz9ijhS6VTe8eQTX8f3MdFcaNAlCZzVMoa8yZCDRXdV8ZqYYIIGfqnp829O7tazctRPRdNERYlXsb1xhsrSk0MwHszbVKHleV+JcSf8gdzcRDXRpH38X/ztxVLjm0IDgkOk9JGFfLoQlZ3TcRKRssCX9xqrvcsSzaIt0mQ160B+EDKD/QiDYCxwyjwcdqpwrz79ffmBRQ+wgnt1F1YsRz8EfBjMgg2WO/HQTyX4S1/b3YvXjb+9DWzniq1PixmUhshGWuJhob1OamuPoL/XfI+KjpZJkSrwFiR86G1HZnt1sOvz6RKqJT7Ab1JbMwMuYbMSPMmqr0TAUyxHWXelb7ZmsOEyBUzrlIRbW/cYaHxLyokQii7jvsbzcM1rBTw4sUxX3/hLk771bFmgJh7ygEJrmq2hez0HBk/nRZfL9YuJm9dMAs5aN4XdWVVf8gav3sWJEeOnTxi2CvBkNxYjsgpBKMFXNHCoxTNKaMUql4Hbv453htk5SZjPD6Mga9qP7NbflkOhjF9BYhzFNh3aIee
 qAJzVLWj
 gBDQn+j8yPUEwo3CeiD3hAodrSOaCagurU7t1GWihtRgjsdfRguchYDQaEQ7XdXw9ck3sQO8amaTef/Ym8s+fkSAoAx6XMdQW3o5qtIc4ZMMGMHD7vTNS5b/I6PJ/+NoQjGqqh2M1Bge3Q7D8NSAv6uHtEADqZcG4mmCb9Xf/4bWG3EGgltysuXp69eU6IObGABJTBXc5vrpswmDDVwyLxxl7zRBvRmSavOm0jCktcbs2l/ffZnypLJcImE3eO7EzL/JyAy1Wyt9BDfthrovW+8XHzuSHsFkWfooYf8dxuTTrvHIFHJQqRUJDbEzoyaQYcR/XLSrlG2L9hmsippevkmRkk3eN/UxYWmc/CZi89gEfLACJg0lDaIUFTvz2foYbtSVOnmBeSsZi+bhfjfoML9E0AvS0GJwg4btBsQx8nKFJpAm4cLQXfZa0OR99SGgDGTZGGVQGlxGuGy9xpSlxyzbtxO0pkeybnxmQHHhipbmnleXgueFlexjzFEUCGMqr5J+ayrO6kZVLPytrF0eRDtO5z3n8h1O9oaIGo4eOLdJ4yCR4BhNEwDYy162FZCtzZVnY9uzCOcFA+oEHUlafWIwexcIX70Ez5Gq1Ku1H3+trKYhBBnbo2TLGj6//98i0Aw+uKN1CyKBpwwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These comments describing the page allocator are out of date:

- __alloc_pages() is no longer a public API and has no business being
  described outside of mm/.

- The `wait` variable is gone.

It may be out of date for other reasons too but this patch is just
fixing the issues that stood out.

To fix it:

- Instead of referring to a specific function, instead to "the page
  allocator"

- Completely drop out-of-date details of that function's internal
  behaviour, since they were irrelevant anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/DJP11T5V7BDW.2FZZZ8R6LOY4I@nvidia.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 kernel/cgroup/cpuset.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 24ea2d09cdbdb..dfd0f827e3b92 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4193,7 +4193,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * nearest enclosing hardwalled ancestor cpuset.
  *
  * Scanning up parent cpusets requires callback_lock.  The
- * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
+ * page allocator only calls here with __GFP_HARDWALL bit
  * _not_ set if it's a GFP_KERNEL allocation, and all nodes in the
  * current tasks mems_allowed came up empty on the first pass over
  * the zonelist.  So only GFP_KERNEL allocations, if all nodes in the
@@ -4206,11 +4206,8 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * come before the __GFP_HARDWALL check, otherwise a dying task
  * would be blocked on the fast path.
  *
- * The second pass through get_page_from_freelist() doesn't even call
- * here for GFP_ATOMIC calls.  For those calls, the __alloc_pages()
- * variable 'wait' is not set, and the bit ALLOC_CPUSET is not set
- * in alloc_flags.  That logic and the checks below have the combined
- * affect that:
+ * The second pass through get_page_from_freelist() doesn't even call here for
+ * GFP_ATOMIC calls.  That, and the checks below have the combined affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	tsk_is_oom_victim   - any node ok
@@ -4327,8 +4324,8 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
  * should not be possible for the following code to return an
  * offline node.  But if it did, that would be ok, as this routine
  * is not returning the node where the allocation must be, only
- * the node where the search should start.  The zonelist passed to
- * __alloc_pages() will include all nodes.  If the slab allocator
+ * the node where the search should start.  The zonelist used by
+ * the allocator will include all nodes.  If the slab allocator
  * is passed an offline node, it will fall back to the local node.
  * See kmem_cache_alloc_node().
  */

-- 
2.54.0


