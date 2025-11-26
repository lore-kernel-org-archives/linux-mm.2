Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6715D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CEEB6B002B; Wed, 26 Nov 2025 06:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F4D6B002C; Wed, 26 Nov 2025 06:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E9B6B002D; Wed, 26 Nov 2025 06:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 060E36B002B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:37:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEA1059524
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:40 +0000 (UTC)
X-FDA: 84152558280.04.D9F2E35
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4C355100016
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Lt0KLbw9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764157058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbHGa4BB8aa9QTSTlV4W5ITQSIzwh2P7qyqHhccO8MM=;
	b=H4Bq/fTIE4xv/p2KlIjTJ0hd8PcMcqyeWXxKUSQzdmVJgWrx4hWpgEC1638YC4tkz7s+bt
	uEvpAUcRJFz2qH4kovlDKB0wpL9Ty1jWFWStwJDMtMg6lC3P8JG1k+FN29FOzSHQEL3aPg
	wQlzRtkmG8H2AYgwiEQnSg+qmp0lMd4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Lt0KLbw9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764157058; a=rsa-sha256;
	cv=none;
	b=BnEjGy1Wv86N5PvD1Z1cgwd1x/UUvG/tvpGOHobnQh6oKc2KPc4KoOxgpw7EEt+WeFa1C+
	8oltZEt5yMyBcbB1lePsjazoq6WjyVMBvc29yT3MWdVrISvqKc8NacKbM0OfMD9SzyuSBm
	JnE8ZrHZrhYfpu1uUh7/XLrpZVzM9Cw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157058; x=1795693058;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=A6Bkc1CjCNGEUzmB+vj+9g0+vnekqJoz4ZJmkOXuFtA=;
  b=Lt0KLbw9ozM1zOcVG35LamvwLM2q8dXN4Qlpd+JYb6Vmi2A9jlGgDj3p
   1vC7FpPSGt3OW7Y1uxe/yoH7Q3ODRSJbNCKpMGLeh8VC+LHkRZke4fZap
   9Nh8qg5RJLpNkRG+4VPoJCKSGJKdUmkPycItFN4P8KYp3goNgMkJZlaiO
   qA1ZiH/A0XXi2V3stRuyuEM3jaWQqlCzCIATx7KUIRALD0t/tBl5pwfhe
   EARqBKURCsiQLXZkg7c+KJP6uzes6fPevWPe3cANGgpjBSi/ObAS+QJYt
   zFSEsa+IsDVGPHP2kBw+XzptrcYp/JXuDNbsYU7LpxBOZ8qnxXbk433eM
   g==;
X-CSE-ConnectionGUID: 75CxQyZiT2irr+36YFcNSA==
X-CSE-MsgGUID: lvY7GSdfSwGZ7P/IwlCzdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66232854"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66232854"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:37 -0800
X-CSE-ConnectionGUID: LrXXAq9MQ7Gkn5yHbAD75g==
X-CSE-MsgGUID: UuySfMbhRPiLFh6bfyX23Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192804450"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:34 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Wed, 26 Nov 2025 12:35:50 +0100
Subject: [PATCH 2/3] drivers/core: use va_format_call helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-va_format_call-v1-2-8a604a331730@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1601;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=A6Bkc1CjCNGEUzmB+vj+9g0+vnekqJoz4ZJmkOXuFtA=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpJuYyDtL0VgLHVzzLLiSjzMrHZZFBQRys/yRak
 H8GvM6ocCWJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaSbmMgAKCRAjYrKT3hD9
 1xkoC/45tS8nQSASXUWhuQoKU/MW/2j9k9Mx4OMjbIOgyk7HkimPpdX+VgwtbQW04GRZGu9rbe1
 VVhVP4HdZRUXM9rj7ODdHZabROk6p+o9VLLR7dn19NZ/2tTX17j6nw3PcySWMEcjWRuV9v+6S9/
 t4ki4HIGFdOV8vzAhKhmiqIx25bjwRQ+m24bi7ugPy92N/BShrlhvgBz20ULtxbfcH+DOI5djlf
 C934uRyzDcE/LBcnR224AQOm4Xkcs187FhZmLyF6Bly0a9alGSd5ylGj8fhBPcE4HT4V+dNTD6o
 U48gDC0ZhR5eFCqmEoJZy2jA53gblIu3MbIQmKv6HYqhSRxk/xRC3UcTLiF4qYvkyKrm/IBVRWM
 eA/hcxxxXWNDpDS9x8BezOVNTxqd9ePzyUWU/nraYu/wshU+eL9Dwap6VlG/OWCkA3h1K1Sdw3u
 I5SFU5wqJkdKVNomWL6tYrxGgmmk1znFdaYC2SQb6kojMXvBocZoKB2PDpDiJ/P34yrrQ=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C355100016
X-Rspamd-Server: rspam11
X-Stat-Signature: z8barkgp6i1xgm83hznd6cbgtehtbmm6
X-HE-Tag: 1764157058-686426
X-HE-Meta: U2FsdGVkX1//N/m0r0GXPEJWeuTCkcdPgmrjZeUug8QgLsvpIe0a4kslcybvWm8jsNm8xXysKQc0rCHdvxUp93k+fj7XtNwmM09tpZllp0MFdh8lvkkUPK92kr0is9Eq/DjrgWdp8yWRaLr+3lzLz4mOFhz40jzfdgUDLfBKpSpXHqJfkI7gM5ARejhyyWLB6K1NCKxTweoJS1cemJijPkIb+d7cNWldant4mgHliPanlCz23FxUMPsuxlI1Vy64RPwUsDaeBZKy5o4i5U1qnMxGqgle1iSYpUNq0rpz990luLin7PaQJxyHdUOGto1RRhEcRFRTnkQzCPRGx4IhEOaTuEYfpv0IS6oLPvvrK/SeJqVtYYvwg1Pz1lFF6QasYy5hLe00OwSZDkaRQuDX2NBZuc/Eg+E75yJcIJFsw/L8nhhTfQnimEE5KEysue9sflRNuAzJiMHprtU5iRgOuGvvsISKSiCLt2C8eK/3FgAEkuSdsYnA9HIcKs8rSSf5VTFnIf80F+6DurKAGGTNolR0Hw0IC2fxU1Qd0kZloUDPfPyAj8aEdtG7X/v5hCGM+xWy6/itZl4C4pF7OpHPDu0IJ0Hw5xf5is+WW4v7X/S57K1yTROMkoyXdy8dsvRNSrdQ0Xq5uUiJkTSqSrk8VxvmpPy1fxFwxmw+naAgWx2/gjOIMQ6MtgD/UqPd/fLJO15Y7+QZi215YZ3b43TBFQpqDnbx95mxPLoykAf0hd4gMmt41c1i86XQ6LI6DhF4ZfH8fS4/WqckFYE4sL0CUnOShpjRa9oaIjHQ5JFV8uRT0ChCtsgKgTtMO1hiZSsQ7gSHI5bVo/HK/yTJYiMHauyI9UWU+aE0g6WvrPIjG0MrR0+RyrQhIY9X1A2dmW2gRDJ3sebBvrZ0T9nYWusCTj6UCvo655khvOmPiIHQHpa97/LBNrP69SZn1OyLHzzF3El6hzPGA4UwdqrTdVY
 OtFtEmo6
 QpoJo8kwAwDoPDA8CgNhabPkxo1LGlsEQavXHhBmHEDs428GL2iKmrKYKzGhDHv2IzTIfeXnys/APDT7kqkS77rIhc1JhddSyF+ORVbvp8w9MVQ8FpdnYcGHqWiJIc/SBK4hN0+vEXru/OKtEhe61IXpAA4rsVJLJI83vYOW4PFZZwSQsegjfIaOXjSFzAfjgnNF7uz0qCL1bw7NRtyMf+a9PTubjMPaBf7IX3OH2+raC84Q=
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
 drivers/base/core.c | 32 ++++++--------------------------
 1 file changed, 6 insertions(+), 26 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index f69dc9c8595455d85bf7eda5d4abce1ed7cb5166..513e5ef8a6dabaec0aee0778c1338a9d72e66892 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4943,35 +4943,15 @@ static void __dev_printk(const char *level, const struct device *dev,
 void _dev_printk(const char *level, const struct device *dev,
 		 const char *fmt, ...)
 {
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	__dev_printk(level, dev, &vaf);
-
-	va_end(args);
+	va_format_call(fmt, __dev_printk, level, dev, va_format_arg);
 }
 EXPORT_SYMBOL(_dev_printk);
 
-#define define_dev_printk_level(func, kern_level)		\
-void func(const struct device *dev, const char *fmt, ...)	\
-{								\
-	struct va_format vaf;					\
-	va_list args;						\
-								\
-	va_start(args, fmt);					\
-								\
-	vaf.fmt = fmt;						\
-	vaf.va = &args;						\
-								\
-	__dev_printk(kern_level, dev, &vaf);			\
-								\
-	va_end(args);						\
-}								\
+#define define_dev_printk_level(func, kern_level)				\
+void func(const struct device *dev, const char *fmt, ...)			\
+{										\
+	va_format_call(fmt, __dev_printk, kern_level, dev, va_format_arg);	\
+}										\
 EXPORT_SYMBOL(func);
 
 define_dev_printk_level(_dev_emerg, KERN_EMERG);

-- 
2.43.0


