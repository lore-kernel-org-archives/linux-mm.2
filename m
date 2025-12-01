Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81590D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733636B0088; Mon,  1 Dec 2025 04:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AFE6B0089; Mon,  1 Dec 2025 04:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2F16B008A; Mon,  1 Dec 2025 04:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5376B0088
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B3768AE99
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:39 +0000 (UTC)
X-FDA: 84170389758.29.0DD0E83
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1CD712000F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FqYTFKF6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581617; a=rsa-sha256;
	cv=none;
	b=mBQZq+BYPEmDvpzS220t+4rn5jEwLRd7QJlVN4htI+fgKsIMj8FMp66VaMBopB6n1YTPTd
	gzVx9gw0e1TlWKR7sayowUrJpjFsN8TXj6BzZLLL9SUHuQN+LVwQea5MPyT72DI9/we6Vq
	4JuFUEHOH4Bq3kfMmBxdD1+MyRs5NfE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FqYTFKF6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7Kf2iUJLmqeUDzUBtz88mm+77YTayi+OdMScpz3oD0=;
	b=5/+tTecG56j6Eft4sTJHtVIwDQy1LKmDa4DPP7S9i+B95zkLZaQYk0Xu6rqeRxB07ocOkl
	/XTpzfTHzhfhZNpj5waR3b6CU7N0tCNDxRCTkJWmgEZ2cbmEy8Yydy5eIS6P2E9uKiC1pp
	v85YxI6ltsrUKU4QMrrKgqny6TpXmZs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581616; x=1796117616;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=YczG0pLDYiEdMJk14SHF4xJmNNuo3F25zh2TrGVWcRw=;
  b=FqYTFKF6fg0JMTBYte4kzfQAihITmlMTPV23l1PrtbPN4BDkVOTpOW/R
   sDtbTJUFCi5To2piLg+83L0FA97CR6oKh42dNdB01XoiD9UYM2gGcKF60
   bKdr/4eXx3KZ6IQbYp5agTvTbkISpydz7brNGtsCWfM+KPS1jVjk7L5po
   lsztKnlrciI0Y4MwQb89P5OLIT0NU0V+4vxvySZglzVpdAjjyHugi3Ha8
   6Tf5/AZCAHoSTpAgQ64XqvvfTEkGSsRhY10bJ9dHx305t3UIymtOLNPc+
   UF2GcmE0Vf1ecZhmqN6wvhh+edfE7XVY2pRGHa+rS0idunp3l7Lm+zdtw
   w==;
X-CSE-ConnectionGUID: bRV7cnbwSHmuIZ+0wMDdKQ==
X-CSE-MsgGUID: P7E0moUiRKWwFf6LcdFZ3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586511"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586511"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:19 -0800
X-CSE-ConnectionGUID: zd4+EoNNSpuRB2cD/CPatA==
X-CSE-MsgGUID: JF39Mmk8RS6NbLfNcBE8rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014774"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:14 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 01 Dec 2025 10:31:25 +0100
Subject: [PATCH v2 4/5] mm: use va_format_call helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-va_format_call-v2-4-2906f3093b60@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1930;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=YczG0pLDYiEdMJk14SHF4xJmNNuo3F25zh2TrGVWcRw=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCDBdzFMEbv9il+/ZP56YrIY2JKu7pYw36o7
 Q73w7a7LLuJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1ggwAKCRAjYrKT3hD9
 15BOC/4n+qzjz6UOABhwlcO/wB7+6977X1yi9kKQ77MSaMWPblDviLXjg78spMbak97KvbyeUKK
 EOYMfpbzmJuJPIzPL6bi2A/O47E/5wiejBNLd8+g7/VdOMGettNh936pWeWVtwhLlBek+yqdIbF
 qIcJZURUOsy+w9Ltw6/HQJRFxZoUuwfW1a5M68jYewOu/WQk2vWTIRk88jbb7vhy6qlVoWSSHVU
 pBBAWK5L2aeZlG4RqjXI0dJ69ODy09IZ2JOifzmFzxSMXSA4bN/mOKeFZ9arAu3iEc6rz7BDhf7
 qGjA8kXetf5V2qcYZoa+WVzdubGkhVkioJgEeKFJvgMbwEDSenPqCDFbsUMP/AEi6yfSJygu0Er
 FRjuS12OVywZmBp3L9XpxcSqLeoVk03AfBadaB8lhEkDBv1tSPIV6nAGb60jtoXR5MdwWlZnbMc
 qVjO6wuheKfnmPXHGY9hCl+X5AngljUIZDtb+b91PB4UdM+MfgrOqwsD5gI1KTj0rXwvw=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1CD712000F
X-Stat-Signature: mn3g6xo5r5um4a11m843j1pnqd51igbs
X-Rspam-User: 
X-HE-Tag: 1764581616-667595
X-HE-Meta: U2FsdGVkX1+81PzeADLPHVHgfKZjvfZZ524sG1OOjQgNvh0eSKsfG4I4qxNPF1NYRZ9DVSxNQme27Fb8zZojoyfu9NbPxW9sZwPfGD7uGN/ZMWDAUa1Xp45ZLM5IuzBaNxx4o41f0s520woFh4H85qy9uNqWNnZxQTapeMCHm0V2ExCTH+/1TaG/thHhDQMCQGuCZGIi7Y+9KB9oF5s6A/1eX+XySPTNQG4sLlJJyfSXCQ3O0HTledD1492dJgop7e7KPcKe8OmStFp8WsKu0Lm1f/i/WUqi9KlLVJtXSxfoXxc+yiJEmIM95WCh1tc9u/dVu+zNl73xKgbShz/cbnrFKzW2EnKTpUefUJ7nQrSoYJgTqUWejCi55dQSP7cPYR+XL2KfayEUch5o3VtlXeqFq9LVGiXXoG/0FbLJMoZl5k/+iWsipRWGE2zhsODAzQ9R+1FY9MOgfSbTX6CQat4goAH+q2tw9LrLbU8bhsLazWTWHQ4XGgtcD01R7ZE5i1X8U/NOi9mk1FtBIN7plbvMVnnGG86Wkhk9cklizmSGAW16/KZ2GTTp6Sdl9thq8udEnmNR/1klrYkhmTHERv0bYpWVPeygGMxh5qvaK/kD72EgTudJ7cNPi9FRpbfhkQYBdXtHUu2iQ7QYW/kTWZtk0Ww80Tj9Ehyg4WakvdnjYNlTM3s3tFLktEcWvx7rsyEoSy7oYyoiduh2C4MXsJk+JZE/lvwgozGq9F8zY0Ldm8M2CwZ53gnz++2FSQ1PbDF9x0gMwAgEsuKD3RBIKmU9zEJ4Gd7EzWrhHyZmqVDgAwXbqF1KLF78N62UD+NWuOgAkLz+72XAh2tit10bRDF0An/eMtpKx8+VwAU9qXW6gvz6V0gR1iT9GoBUApbRqAvNWGHZtc5B3Bkj0Jdx9J63g9k0QO9Sn1a6Q6x7+udD51chA0lcedVv4DbGsYXvbmb+guejowlnkhAyOFy
 7hgkj9kF
 pIupl+XD2aoK2S6Uac9ZV44kvWXxw4dy6maPgnMjvYgLicwHDhbgVol88nyg27EV6l31wgsXSpsaBFM1pqpYU0Hf7i10SpOvVTuV9fs1S5ydijTvg63D+jnANp9Pu66tT6jsQJzWc9hNTgLnBdEgfiQWXqOowkGiWliRNO3ffpNY5KgAboi+/Ux7fPYMQPH0mtWxu/M+UV2Vp7Zjoxet4Vq+MEGJ3UvVsxauQqGg2+WNAZ5s=
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
index ed82ee55e66a..cd0b17ea4de0 100644
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
index 1a5fc3429042..786c5a4195d4 100644
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


