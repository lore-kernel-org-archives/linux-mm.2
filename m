Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF33D10F24
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94806B002D; Wed, 26 Nov 2025 06:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D406B002E; Wed, 26 Nov 2025 06:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE7E6B002F; Wed, 26 Nov 2025 06:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94B096B002D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:37:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AE5113B2CB
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:44 +0000 (UTC)
X-FDA: 84152558448.09.ABD2484
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3399C10000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S5l1jj/b";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764157062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yi26sGRvrlHtt/V0HnobvuRDeGckKLU/XOXe7VQc5Pg=;
	b=FPpwZ2Qo5CQTKoKJ1eGvJJg8XeDeVanr0Goz/HRZJxbkfCzTtX3wB85mEQ6bGCOwNpNu6q
	nX9gXx2X9ebiQawAkI+dU5wC8aXK+Jpr+YsEkD4d4Rol5aUCrNRfH6+TEl0bfui0Vd3wVr
	ZpPj8jqVa0pg2rmt7Jg7ulignfOjuEU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="S5l1jj/b";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764157062; a=rsa-sha256;
	cv=none;
	b=yvael4n9DceGQtkHZL+rQKy8pmDsYwNeq0bcrDtXENPbO6CTmmXFQHP9SBoINTN5y4+6vb
	hpCGMLxm6RUknlVREAr/ExLSsFYhXZJYjXX7OBJJoKz5qAIcI6bJli2THTNHIaojm09rhg
	eDi+4tD4k2mTF2MIikixXfyQKg2QEVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157062; x=1795693062;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=jgD1fW2/HmiwQtjECStW5RTYnv3ytPfWP7KQC+fNINs=;
  b=S5l1jj/bRB/InSbpNqzYvKiHl37gN8fhV1EJKKkwB7/y/WdJovO38x0K
   L3y/JClTOzYtDIROgdz4LjlOBjy+fR+fmdvvN8PoINOcxIEnMtUkZnyPC
   7Ro2EFr62gyDIcmczS0aHSZJlUz6BxbTMd8ltewVslr6CUqpjtn3tnF3P
   v/NxIKfkdVp4SLdLOnanpK83I2sC1vUpa3o5yusqo5ZRqPYbrp/vAe3HC
   KJQpXCeZM/nL9fr9XyV+0Pk09SENNF/Ngx/ybTegysuMxH0Nu6UYmHFOt
   Mncv3aUIpFIZ7lvSVAQO2XdfOrPcMo8Pw0X8y0aSp5jPQl9Obs9glNBvj
   g==;
X-CSE-ConnectionGUID: KX7wSdiYT+ueKjMNSvsKwQ==
X-CSE-MsgGUID: kN8BJRJcSjSZkGUhqVMsDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66232865"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66232865"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:41 -0800
X-CSE-ConnectionGUID: Wjwwe9UtSAuXoLbp68iXYA==
X-CSE-MsgGUID: +97oJy7dTB6CO2q43/wzxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192804460"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:38 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Wed, 26 Nov 2025 12:35:51 +0100
Subject: [PATCH 3/3] mm: use va_format_call helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-va_format_call-v1-3-8a604a331730@intel.com>
References: <20251126-va_format_call-v1-0-8a604a331730@intel.com>
In-Reply-To: <20251126-va_format_call-v1-0-8a604a331730@intel.com>
To: Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
 John Ogness <john.ogness@linutronix.de>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andrzej Hajda <andrzej.hajda@intel.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2042;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=jgD1fW2/HmiwQtjECStW5RTYnv3ytPfWP7KQC+fNINs=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpJuYy2Ei6pVpq+iRT+RUcGLhV1Bwx4jcAkAWTh
 a8DmOLnXkCJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaSbmMgAKCRAjYrKT3hD9
 1/1gDACkRt84YmIuBQkH5H9hpmGVce17KJ4r7+jlDuEjOzARqk/eHfLsHXLwKmuPtk1ghXZg4AH
 2ZWATLpMWyV32IszDPayMMeaTzZe9ZfLE/LIIzIoAlq+MEJP0HXUr/gmtV9isvmPeoqGBXj6zGK
 56JRKibprYT36I0g2TN/vrk9ot80JF0LHoEZs+33/eeH3hd5MSV1u7RwSWscWIRYOR6PIwvrt9F
 9IiN8zSF2DGAU/mobMIqc7P+niqk4xghBSzrJqmpX9vhFFcY1e0v9fBX2gAjCmGD61wrlcjELta
 YFPFj8D4317nIgLMz61sJa80287j76pv0vBF/sukBVuz9KGXewTz0URKupUMKJ73Av1pHaOBxTp
 T/R+akb79tvC73Pi/x+Gky32njCrMz9+ZG+OMHEkpOPUDaw01XB0KggMkkrllbR1KNGGb9H9HGO
 l54XNmeEiFrsyXFLPisGOsIR4J+mENyvMGsSe2B+enswYyDhaJqdYSKTIO8/K+vkZt5C4=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 3399C10000F
X-Rspamd-Server: rspam11
X-Stat-Signature: cya1ft8fbsianuyqtn9sa4j8wytjgqun
X-HE-Tag: 1764157062-225735
X-HE-Meta: U2FsdGVkX1/SLg8I2cF4wTQpgc45baZoR6n/tQQYp/M2xC7vOAw3QuY1UGbL3AyOgw3ewrhZklblEYStXQIgCBLKz53kYaF3AFgq1HTxGmOcTLIH77Y0XSMUOXatkug4Lrkn72lSrBjZVeSZjRoSn0s/V4wnfvMlGFtaUhxWymVUY7SegI6n2eaZmDb11G1flsjndsSBkZe2r3e62gsweH2O2/cVkm4ij/5iZFqz7pX8tyATrozVd+1sPn/Zswh/LAc/5j+xVZnR9HmpLW1JhRmBL4cOJOUC750QEiPC9XeVuvwwC2w7Bw+Mwec3Zy7vu6KcsXRkyj9ENJbRixYBV8x2LBQ6Ol3ATdahS6gZTP8jem/u4gYbvBpjW/at5T7voRPxg7pYUGJ23QVq2I7gsITAcYOVyIuRGNLxsmWz1YiKdhCRRaah596z5/qOw9hs393RFX2lN/wQo5ShbQUpSXNua3AvSpQZHVktt9L5mcm1MKtWE/2Kgp9Jiyo5/On3y4sxs8242SvSnxotbsfcbkg21QYhvqJDGLGm73XYzLpzFWgcbLb98yipc+DK8ULb+/kg1vRaU4mYni5Y+vmlaIifjn9fTCCly2Ad3ErF0mDNuPuSYSUI04NCeq1j4ZOtjwz9kTL3HCCcwX1xxyAe5EmS+I3KUbABaFc4u5Dve5Ima69heo4i8RvfZLya8bf7o0Yg67ANuvSX+iX3fu2sHYwh/AiaWWon8Y9MFMdBlSAt6cNeooCWxwBqXJd4n2T8YP/bg0trb15wHN2oKPHEp0boylQhk80QrpCZvOzTnvhMBkFDVDYBH6pyZBv/4a/QAHo/1mOcdnpXDLNJQiIKiKjDc4HDqHz8vXGuzFC2jNjly4LN+FVUVd3zXTWaIDFfhKBKh1dGX7Ayv0IQUwP01IWNqU9hwpjzXnSJ6cC4S77RBej57sSyJWr7Jk9KeR/m7GKc1PFCm09Wu1k1gDT
 CfFVmUqF
 ogJcmhVbQ9I3ecBwjfLZMMSqKWoY7nKlP9no2eROzOzcp1csW+lUZXJ2qcSiXRYW1k4PiR2hOkNYk1Ty9U0haAX/ItRABoghAWpCgUb9vNxF9lSycyz9Z6K1968dQGSBwzbnXzFuCACJgd4zskMpn/WlLfV0tqKxWzpMCXUWyNFVHjeGFRmkpYMgzgjSxnV0bh9StSW7ywlkARI+iE2NkPzeN64ewmIX65KxLU56X9hBFHi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It simplifies the code and makes it more clear.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 mm/page_alloc.c | 14 ++++----------
 mm/slub.c       | 10 +---------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ed82ee55e66afffafcf6360b13da410119f2898d..cd0b17ea4de0a3262fae117fac7f427a7396978f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3940,22 +3940,16 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 
 void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 {
-	struct va_format vaf;
-	va_list args;
 	static DEFINE_RATELIMIT_STATE(nopage_rs, 10*HZ, 1);
 
 	if ((gfp_mask & __GFP_NOWARN) ||
 	     !__ratelimit(&nopage_rs) ||
 	     ((gfp_mask & __GFP_DMA) && !has_managed_dma()))
 		return;
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-	pr_warn("%s: %pV, mode:%#x(%pGg), nodemask=%*pbl",
-			current->comm, &vaf, gfp_mask, &gfp_mask,
-			nodemask_pr_args(nodemask));
-	va_end(args);
+	va_format_call(fmt, pr_warn,
+		       "%s: %pV, mode:%#x(%pGg), nodemask=%*pbl",
+		       current->comm, va_format_arg, gfp_mask, &gfp_mask,
+		       nodemask_pr_args(nodemask));
 
 	cpuset_print_current_mems_allowed();
 	pr_cont("\n");
diff --git a/mm/slub.c b/mm/slub.c
index 1a5fc34290421ea32e6f5bba8acc87b53a9774b5..786c5a4195d44d5c40b3c9009ff52a3b836bfe23 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1161,17 +1161,9 @@ static void slab_bug(struct kmem_cache *s, const char *fmt, ...)
 __printf(2, 3)
 static void slab_fix(struct kmem_cache *s, const char *fmt, ...)
 {
-	struct va_format vaf;
-	va_list args;
-
 	if (slab_add_kunit_errors())
 		return;
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-	pr_err("FIX %s: %pV\n", s->name, &vaf);
-	va_end(args);
+	va_format_call(fmt, pr_err, "FIX %s: %pV\n", s->name, va_format_arg);
 }
 
 static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)

-- 
2.43.0


