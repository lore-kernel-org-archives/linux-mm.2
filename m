Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB35D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9FE6B0030; Mon,  1 Dec 2025 04:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A266B0032; Mon,  1 Dec 2025 04:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89E06B0088; Mon,  1 Dec 2025 04:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4F9A6B0030
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A5D81407AA
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:36 +0000 (UTC)
X-FDA: 84170389632.11.ED2CEB3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B321120019
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bo5iEg/Q";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581614; a=rsa-sha256;
	cv=none;
	b=XnTgT2eGI2beyYKcoNnXf5tFZKXt6GmvP3VQfgB9x6tHxoQ2u3ypjgk50tJM55XHqHazQT
	dJGuyzN+fJLoeWADCXrUMQI+NJCyd50qH4IW1SrE9adqEb+Nw8N1e8QxnDwX4rx53gCo6h
	mfMTLuztjDRgnpG69FMF9V/s5c0k3YU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bo5iEg/Q";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6X4LLXxBbw2K7HKhhZDizu/vwAzHJBt45c1oZSC0cFM=;
	b=Yqq+m4zLBfbV4FNDpCJF/tatjOxz29IJFt4Ho0xbBQu7i262lwZZtb/sJw0mRtqlDz70Sy
	QvoEiqSiGAeHxe7c3quBx7PRgobAqrgNxMM13rJaBQH8FvM77KIP3fB/Kwku6eM3MPNHCM
	VYgoXvnaqOGUD1mCsZ4BIAMX9fw8bys=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581614; x=1796117614;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=BidZ//3QtMfU86Ob65UNf2tBPu4j0g1ruYdm5SKevM8=;
  b=bo5iEg/Qr+bxQ8Lx5RDv9iV2qV1Wk23ABtEZoChX3RJm9OZUofcMs6H/
   Jdx9Mv9mF7dptw5nyyoMwJ5+0AelOaMoVpt4fPBD5rMxWdXhQycnUuqAc
   2oZn6ytaQy1rzFgEqichgn26pRuxeIrCl1nYSeXfVbcqr3cYqLeaZNr5W
   Vx5KH2M11FQPSQREH4+9nG5cQMwA8na9sTNKUQEICYlnDprWPWHtzrHs1
   Fqq3nyvswu3vL5IfcvNJ7xQWx3Thg0qT5mtSgcXVC8xleMSOD49PlrSmG
   s3ZIKtU0mftN5IsP+jIWCN/0tZh5X5HLcDYbfZUCJiapHRkcBOU1Uc5ez
   Q==;
X-CSE-ConnectionGUID: tG0gpawZR3a9uDu4sntBEg==
X-CSE-MsgGUID: TZKa0bwuSxq8esWEhVMxKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586438"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586438"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:07 -0800
X-CSE-ConnectionGUID: +J98+KRZSvm7YE8YjCy+CQ==
X-CSE-MsgGUID: L6Caq9yqTHCBLTiQiLwuTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014735"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:00 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 01 Dec 2025 10:31:22 +0100
Subject: [PATCH v2 1/5] printk: add macros to simplify handling struct
 va_format
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-va_format_call-v2-1-2906f3093b60@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1947;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=BidZ//3QtMfU86Ob65UNf2tBPu4j0g1ruYdm5SKevM8=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCCqgrlEBLHWYOOFjlFGD6Tu10XWZeK7VfDi
 s7v0zzoNeGJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1gggAKCRAjYrKT3hD9
 15gVDAClfsOsq5oWz8xyehgotr2qX0EkmLOP4SHstCcoZwpFPmgVpFXJZsbrEQq61BdxV34LMGS
 RUseDWoRcuoe+E01xsLw/6ML5YqOYeBYhebiw4yLIi+rSgnLkfa3SIiSMxlYvqwTqL7StV50nBy
 /1Ig+eXoLoOddJtC+dsWQmbBagt97nH1D10ROZ621wfpQ4GV4BuOXk2xt0g0qnpnJarOFtZx5aa
 UeKzZQC8rzlcODyO9v4NlizeITJjxeF+FGCVP0mTHPRoZmGfOilPj70Ow+35ufdkEvCZw7QZHIY
 5eePg5IfX5fJbtnx4rBVUfU2xReXZgRVFQNuc+QXIdHA7jcwMYPp7tjSIFxGRIYJfqCqZNOhBv4
 dP5JfXLQbmtf3UyTztapg8k4Hh/PV7DCptMswCWa6jlDQfO5nW8Y0gBg9xgicCOJIzQzseOr1Nn
 PH45VkUjdFzO5bmNCnLNzdg/t6SYU0oYSUeVCmq6ETxynodehHR6UD/Erlg+kq10ezhVE=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B321120019
X-Stat-Signature: qnk9jdfhjc6fcpq6jhozqu67y5dswrnc
X-Rspam-User: 
X-HE-Tag: 1764581613-592367
X-HE-Meta: U2FsdGVkX1/ffXqISGdEXMQnw6Lt7T7Uh81PjtyhI2n2OywFcitPzs8OSMN8jv8rAS6A6NxCqHZeCKM/9PnRXeZqn6tkNv/4YjMG91gyBoOWuH7H9URoH7lKhZ7WsxgWpz8MPt725NZVkpBjfA4ufe/ih5bN8eGDNkkQ1XMJXy9gv/gMyLEXXjQypcic1Y5i0Y9HFy2te8z83QIfxG0R65Qa6wdLexYcz2hbeO4N/SU19UahW/bCRut+VXjRUxDzGHDoE+u/EmvdFAgJUcQDMR9a8gp3tr/+3llNHAuGppGxKUWDbCHfvWnz8Wyg2KSf7NGPP3gPSJ1QbY9YFIYiNL5pD+QxiZW4aFm1+Aj4DoiKKyq0/lY72JYkwS0OZvjMbwFSzKz13Qd7NvNbsgpedug+9Jt2PfG/e6P5u/EuE5dSCGsXLkVJqaNm2DvgOW9y4oC11GbWmQJnHao96E/rjF+Zhaa5CYgoO54bHEwKizvthETLIP1lUJ2D/9uulJzzJ7JBeY0PRbQGxZoiGF+rSTdkJG6TszlCXmqLsplAhVcRbH9ihp0otx2EU2iFK7ILEHgqgG4QYOo4P1Yn9oRYW8FUhhMQmcaRhOjhGTVEwpj3PYdzZexnkuDfFeg3WM3z3l3F6voeZ8cSad4b/0axDrAoPOF8aYqZSOp9HNIJ/a17nO0RkoOEMiToulcTn/BUsh/nH09KS1Ct7EBYMRuKfV8PaKh3Sm2zixdnQnLTK0D1m7Ii357TEQM39HgIJ6Wgff4efudFF0IrW9umvzrfIvTncdsg9qEjaL0BvHXSaNJ0UBXXOwiHIngNq4SIzk9gC6AisCUQUkPJ5YzRB6FwwWitscghsyy8QU6CVRh7fsQIoFvWpv+uFytet65fshYrVYKH1j+pT9aOr2rsaTb1TDdfJ0IFMeaaiqJNhAjVW9TqY6w5rLdOfIVKcE/2EE6L2INhZ5Xwp3LHnHojO8z
 xUQtYi6Q
 oHEAde599btSDF6Ull9+V5ddDtfGKh40PkpsZJcl5yrpgpzLPIpdVC5RkfrYBSknslWe5qO0FsKC7SpqTbFk/+PHF5mk+pCo4IDqcwKRETRRm+ZAqEvy1r6CkCUWpZJBazmA6mf03zlEjbv8BjWXRqUH/HTsqYBsi/+ZUXm6HRH4LzezqRgPeKZYq3+/plxRtiWe25mTyTFKHTVykgxjZPqTyvErEfyN0i6UpGV3/tbN9XCg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct va_format is used to facilitate implementation of
variadic functions. Most of variadic users do not parse
arguments one by one, they just forward them to some
helper via va_format pointer. Introduced helpers simplifies
it more.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
 include/linux/printk.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 45c663124c9b..6fd817ce29a6 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -87,6 +87,36 @@ struct va_format {
 	va_list *va;
 };
 
+/* Special macro used only by callers of va_format_call to position va_format argument */
+#define va_format_arg (&vaf)
+
+/**
+ * va_format_call() - forward variable arguments to va_format aware function
+ * @_fmt: format used by @_func function
+ * @_func: function which should be called
+ * @_args: arguments passed to @_func. Exactly one of them must be va_format_arg,
+ *         to indicate position of *va_format type arg in arguments of @_func.
+ *
+ * Many variadic functions just forwards their variadic arguments to some helper
+ * function via va_format pointer. It involves few common steps encapsulated in
+ * this macro. The macro is accompanied by va_format_arg macro, described above.
+ * Sample implementation of common helper:
+ * void dev_err(struct device *dev, const char* fmt, ...)
+ * {
+ *    va_format_call(fmt, pr_err, "%s %s: %pV", dev_driver_string(dev),
+ *                   dev_name(dev), va_format_arg);
+ * }
+ */
+#define va_format_call(_fmt, _func, _args...)			\
+({								\
+	va_list ap;						\
+	struct va_format vaf = { .fmt = _fmt, .va = &ap };	\
+								\
+	va_start(ap, _fmt);					\
+	_func(_args);						\
+	va_end(ap);						\
+})
+
 /*
  * FW_BUG
  * Add this to a message where you are sure the firmware is buggy or behaves

-- 
2.43.0


