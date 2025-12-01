Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC53BD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86C746B0089; Mon,  1 Dec 2025 04:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844346B008A; Mon,  1 Dec 2025 04:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696466B008C; Mon,  1 Dec 2025 04:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFD16B0089
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FA1EC087B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:40 +0000 (UTC)
X-FDA: 84170389800.23.9203769
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id D08C9C000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Q/UesX3J";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bi25aC2CosrroX6R8bxu+CMhEK4KI7wmZpFiesXoVa8=;
	b=GQSTtW6hAKmyc03n3IEDi1XMFZNRGp82WF8e0wkx6Gt/VZP/qEsi8TnV8VFiOxurzKGUWQ
	qvzunantBBOOy6oZ0nl4ShaXGn7aDFcPfntgh7QwI2qcLdXQ/wQyHwtE8gSwRkEl2CmT58
	q1qvKZNzAdLjiEePE2YNG0AULA/OrVA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Q/UesX3J";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581618; a=rsa-sha256;
	cv=none;
	b=LHXrwvoYHoXedvoVCPZ22s3ImKXUYATgatKGvCJeI7sBgg+QhzKTlFrXZZiHuW60k/mvIu
	KBgx4QAKtlaOWAFqA9MRINv2BiT26kMMCr1cxzCyENmrFJ9aABvdqoghzVsJMwk75O7nKa
	Y7RqzICDaMP+f01SmMHDNq/f1cQNX3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581618; x=1796117618;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=gvSVxoCm7+LJlnSucQTnrfYh5mL799iZd5hm2jd1smU=;
  b=Q/UesX3Jh3NF3eqklQfOqve+6sp0sdVHCZCrNtEVVQ8YByJHu85xVY6+
   sAGaxJXDmu9biUAs/UW62rB9Zua2tFt+ha+LUHNYtgfbqTfmSVrbAjohz
   xgxFnezfTAqM9HiEU1EQsXAjV4djm3v6PoNQ0LLQ1AfKeIFf/abO+Ur3X
   YDJR/YZRCe672k4gMERpBf4PVBrJ7EydOIHIQwaVf7LhGo3alSIYG/n0w
   xCOlmmtXZeWkbqrfMMUi3Kj7alkv4Yxx8C+Mke0LvzONp3h+XRDfrxabY
   9qJGkP3rP9XMUVxAKVXFVnYwxk6EdwdE4/KbKca7qog/xzRy+ppzNKMBQ
   Q==;
X-CSE-ConnectionGUID: /LGn2AgIRm2RLJmPrlE+Yw==
X-CSE-MsgGUID: zfcSSVpMQWm4f/NBlxBAsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586553"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586553"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:24 -0800
X-CSE-ConnectionGUID: N8mdau3KR5OeSw/UqSSocw==
X-CSE-MsgGUID: uME5QcErRLC8jfCFrU+FLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014784"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:19 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 01 Dec 2025 10:31:26 +0100
Subject: [PATCH v2 5/5] mm: simplify variadic args handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-va_format_call-v2-5-2906f3093b60@intel.com>
References: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
In-Reply-To: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
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
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=1871;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=gvSVxoCm7+LJlnSucQTnrfYh5mL799iZd5hm2jd1smU=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCDqiBXNy04SmJYV2im6OViRn+7iKSUqg00o
 2dytiZ+4vqJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1ggwAKCRAjYrKT3hD9
 16atC/9VGz30NkzaVRwueNj4Ef8JUWpVlZNPb00u0k0MtZw6cY1kXOptb37F+QHud4kZ3UoJZqg
 hp16GX/CAdaa36gRLKN64PBnfs9vZYlOuhMQG1dIXVlmsQKi0Z1Fmm0D5/sp1nWK1wG5g/EJwuz
 S0xv/dnBhfWkRo4mVZrqEhYJOSt66RQJgJRGJnvGX1E9KEmJkxiKf6qlBve9XEJSvdB8p+czrSb
 VRhXgCYIrVrRdNzcNa05vPCJeOzpY4kJTtO2VPki7fTJHayThLv5UTE/yjXymc/hAAOkgyQA/Xd
 fDs4ylTcQx3Ple6Wgm+yTBk8rdJRbL2wUenTSMYfxJYpTmnhzLOYTx9jpcTQq4hU0XX2bwKOR0+
 AMOBRHQ+HwexKeuHPNTfjUbSWxd+ZUGAwoDOIH51phixPrnraGnCs7ERdZ2UFzUbQ/UKob6BGEx
 0vMt/TTQLENVACk/3lNHo63MrbIwSKP90CP7tEmPGRboyMu+/NB8oigad3jKB4TlNNLuk=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: D08C9C000B
X-Rspamd-Server: rspam11
X-Stat-Signature: ch4ffhm9qpz979hc111j4oebtkii865y
X-HE-Tag: 1764581617-774984
X-HE-Meta: U2FsdGVkX1/rKBIHvFokfj+NkwM1UcpMDIloTmDeFKfrcWjIMYIp48CNbq1RARPMmt/GITlyjSK/lEx9HmAtMpjSKNYGysV9sQ16PUGjEP0a3pl3Bko9XY2CgpEuYZMPXMtbHr4/ps4vesyl0MCCMR3OL0w2aEJ8ckx5uti562Ryl7IbMhyQaMgel69Uebd0+iRcw5XwHe04x8eDao81Bip1a/IIypx2iCXrylTMGkGB0wreviZ1ZF532tBk9oRH9rw7tcw8nLpwbmZif6ZK1x42qKSvJjRX7RKBmuTyWiCHE0KcivLuXBtaNPGOyOm0I248BuGOY5+nso3zj34OcutFQQPGh9PzhF5FYZUrxFuj8G0ugdPRHZh2YznuhO/5tv+VvHH9yv5dxYqVDZWadlh3Xx01SMUUbf09la/cRZcQVbk6s5nv91Zp82dQPU1nNy6C47KArmu6vc8Qb+uWyid9RPmQbuhfFf4hjZT9f/zSKy8crMbzoKDWmBASDaFMLmtb3gw5BQqbRYkyMGLoHSpxCTbL0CcCeBgNRwl9y9KJH4DG4aKOO3TTz9BPhFz26cM6rVazazPe8wrEdblL92MI8NM/PcYdon84ISLZbtY6GRGALeCs5R5FSNag1XcmFjJ4qmEvcUbfGBl3KQXHAGdrs74A1jqiTpSaGaxqBlnDto73/Hdep8+k63gUKa7h7aTqyH64+TINSHOjgsZICIfiXgQz/SpdG1pWdNko/vUYyc0E9bIKjehL0l5h6+6TFs89twUjYd1zIb7FTVAPcC2yAmiNHwPAVpfdxbUcBeTXeS2aMKwG7KPFooI4tYf/2lI6+EN+lt/poDN7lzwG9K5g9tgyjMqM7yICIki/8957zaTZaxI6hUkjRop2XlrdmoAhV0o+MHI7ldGoHwxfOFn5k7H4tSLW4PCsb7vZZcASPYzjQJYAXCgBVjywKq55ABAtgfjT7JPMCrc67pW
 Ixu7z3Rn
 thRDMlhS6MaeFI4JeQX/osoWFEdXU6eesEsytCjfld5FadNC0pXCkXt2w6Dt9/amxKl9TiqiYv0TWl7o1gTRTXMai0VPq0o5tr0iIo5eItyXlPfcvUykIAN0ER1K7s6q6eLqNC6rjF+LpI3Jo+kbTV4TqZM6NX069I8EJj/oBjCAeuQ5RQ2DP6IReXoX5UxIaJ0Ki
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changing argument type from va_list to struct va_format * allows
to simplify variadic argument handling with va_format_call helper.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 mm/slub.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 786c5a4195d4..12d8ec97eac5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1135,27 +1135,16 @@ void skip_orig_size_check(struct kmem_cache *s, const void *object)
 	set_orig_size(s, (void *)object, s->object_size);
 }
 
-static void __slab_bug(struct kmem_cache *s, const char *fmt, va_list argsp)
+static void __slab_bug(struct kmem_cache *s, const char *fmt, struct va_format *vaf)
 {
-	struct va_format vaf;
-	va_list args;
-
-	va_copy(args, argsp);
-	vaf.fmt = fmt;
-	vaf.va = &args;
 	pr_err("=============================================================================\n");
-	pr_err("BUG %s (%s): %pV\n", s ? s->name : "<unknown>", print_tainted(), &vaf);
+	pr_err("BUG %s (%s): %pV\n", s ? s->name : "<unknown>", print_tainted(), vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
-	va_end(args);
 }
 
 static void slab_bug(struct kmem_cache *s, const char *fmt, ...)
 {
-	va_list args;
-
-	va_start(args, fmt);
-	__slab_bug(s, fmt, args);
-	va_end(args);
+	va_format_call(fmt, __slab_bug, s, fmt, va_format_arg);
 }
 
 __printf(2, 3)
@@ -1252,14 +1241,10 @@ static void __slab_err(struct slab *slab)
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct slab *slab,
 			const char *fmt, ...)
 {
-	va_list args;
-
 	if (slab_add_kunit_errors())
 		return;
 
-	va_start(args, fmt);
-	__slab_bug(s, fmt, args);
-	va_end(args);
+	va_format_call(fmt, __slab_bug, s, fmt, va_format_arg);
 
 	__slab_err(slab);
 }

-- 
2.43.0


