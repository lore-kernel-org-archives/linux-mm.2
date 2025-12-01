Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5643DD116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6FD6B0032; Mon,  1 Dec 2025 04:33:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50326B0088; Mon,  1 Dec 2025 04:33:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D596B0089; Mon,  1 Dec 2025 04:33:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 873E26B0032
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3292813BC0A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:38 +0000 (UTC)
X-FDA: 84170389716.07.CA3351A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id D6C0240006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aSg69Fpl;
	spf=pass (imf17.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=adm3M9SrsLozyQdIefjmp4+8Bti9U4aemp3cbps0RCs=;
	b=LFJLCDD8p8bVZ/hPlH+5a7DoM2mciXJcU2zfQXcZq22QHGJBIG0Qh50+NqmJ4MElJSs6dV
	kbf88xuYUC+wLXkLbsyexx6ERwYusd7f9r0GZnENOuirFZt3L7gJBf1tkwPnGzoYNXJRP2
	Zuvt7/q2dn9NHntHmvih7+adyKyXzzE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=aSg69Fpl;
	spf=pass (imf17.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581616; a=rsa-sha256;
	cv=none;
	b=uYcLo6XSUVh9N7UyY6x5r9JL+9uDlMqt9s5s5JnDxeATBhWSztVhXZ6+3jbAdOQFUtduvz
	flnTZDROWEH1VBZhUz4/1Er6tRSrWPzsXxYUXexF+DTJ1SIDBN6ZUIG3SRL6zAMoDb6C9x
	K0O4YvRpesa6wLz4qos72/KZ2rBp4u4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581616; x=1796117616;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=aLe4KcA4NSXkuz6n3mPRoFlQksa7NsVPK3f3ZLIZZ90=;
  b=aSg69FplO5U0wofuHO1q4O5PEPDi9eBGeHO86EoIVqsLirGvMtsJsO6B
   To/w+moEUBYlsrE7KTVLBjipkBHAJaMpQ2Mn4f/Gdo1dHfdzD3F6VyHtI
   DALTJLbOYXURn+6wXUNWp91ZCTXR0N9Nz9tE04vlJS7w1PS9SRYCYeyMu
   P2km0g2qDtShXvuGjK9k+aCNv9pcz0yiBA20L8SYxSEWpTH/29mKv5uGR
   H6obtHuvnkAoiDs+lfRYMrCVgJUJaZW/ZVjTuw/Lpv6y6XJ232bIGnR/U
   ObC+6ey0Fcv7dh623dIQDf7DK5qxa/QT54ZScqKwTfw0DCvE6qDxnaqRb
   Q==;
X-CSE-ConnectionGUID: pk1pozhRSdG3qzmA58RTDQ==
X-CSE-MsgGUID: xiR+lG14SHKyCzHHu8Gmlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586493"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586493"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:16 -0800
X-CSE-ConnectionGUID: PTLk49HIQ42h8lk9mJqShg==
X-CSE-MsgGUID: 7rzMsVPWTW+JaOplq6fONg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014762"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:09 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 01 Dec 2025 10:31:24 +0100
Subject: [PATCH v2 3/5] drivers/core: simplify variadic args handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-va_format_call-v2-3-2906f3093b60@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3161;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=aLe4KcA4NSXkuz6n3mPRoFlQksa7NsVPK3f3ZLIZZ90=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCDrFS81p5xl7Y4ta+Lv+9MYmMyR7mYdfpHU
 VNBnvpCZwGJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1ggwAKCRAjYrKT3hD9
 16TtDACXjKOhA8ukJfEVaatD9RMTdXDzxWSTE6JGwiD22eMpKA/P+LbxSVg+iwrqFKUMSMygpBV
 2VwVLP/IB/zRqeWCM5tDojIojNiN4zbx3a/HHcC57d2oaqUI9YXv0h1akeLjnMXGl2fA9rfYsAi
 ZFzaIW1XZrtJdYdfixg6SP8ImWc4+6RHl4msn8b9Morrng5z+Zx1kuvpzXlsnwtksY/V7ZyS+uH
 8QW3QlSFYonKXmV73Bx8rJBTB/omNDf28xYE8iL01En+tR9fjVGwebrgXAq8Abw0rgp1i3c0XBx
 DC8bBFh4JEOnAqmovMoDdRSA5VMq3YEljX6dEGflJz17FyJltOP2YBGmAqjhqi7u+rtFbpvCGxq
 Z9Xy3bkn/u2gUyviBU3+X3N32zVoO95dimpNz8rYrV8q+edG486ULFyqxaanGq+U9mnAK1ntaxs
 64td9HywJS68L+44/YSRu08Dsi5n3hKfetqYPKHGx1OWQbYBYnqvcYvgSGbb9KjspwWGM=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Stat-Signature: wurkbt46kctg5ke7zbzmh7iwxupw7mxk
X-Rspam-User: 
X-Rspamd-Queue-Id: D6C0240006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764581615-386091
X-HE-Meta: U2FsdGVkX19is/dR2kLmpciZC3ZcH0VDyoNYAgK80EbIftST4YOTSOB6t+POvKxre4GRyRtC7cHxHsE/FqGbZg6UczPn3TjxpgMkj6MxTOfUbdytobwS915uMZGLNFZUbYXwEgLdvml3vYh3C185rGgXJYjuB0gCeJOBSGL6FgAVsL4eNqBcp+98aXXvdlGmE2wZbkbNMUw5orr4hWiDezNoZ4UCuwt9/vXpGgSGJ8OPO33i2k8PrWcvA4eaM0OnoHLpz2iDvgscgzSqZy9kwm70sDmSwtiCrKS2BIyiT5Rut1Ar9w92Ob7KALPFn75KYYK2G2mEYSPotiHRCGp6ipVKUhBaEBOaBXVuBn+8Fs+65+XYbHvHNU2r/uipnei7w+7AOHTB9NP1v73ZCQHP5Z9A//5EnmrhYCvUT8ezFtiAx55fPfmwG2v8vikonuwWkLCsp6l/e5PVDGrfmVrNjy4z7z+AQ42mwbd72ucyhz3fTOIN6fCtdscdeMCviZ4v4QkY3/hZUuPKZDF6TqlEMVGvibeASy3tamXuDr+qBhcb7Lp6F9Zs4CxtAU7wXxTEqtMpKm9GgjB2TlwpzaNT4PCkSgIJ5ZzlKU9jZaEfHWqRcHDweWDqNdGPYi0n8z2mJwwtj2ZW2tCNdawV8kjO3PpDYklDMLE1U7fhE3HSKXtcC13E/Jt3cEVDXpnFCaAsAhuLo+5GtBThZ55gVuJZncgu3nW8H91SAImpBu8JA9Dp12O0qvnQR6klITVfkrh9QPgV4gTqY5etaf9FofD6G0tMH1Lo6gcVpgeaKCTFnqhLMTCPd08Z/c2XLzpwSioyCma71bHucGU+bPTGs9q6iPZorvHzjW6Lqm+AjAiYu0BOhx03SzhV3u8ZVZx/72c3BsZCBVeGSW2S/0FYxsx1njVvooYtQ2/FS6nzdwo9PlnEyroIa9aZowbudV8lvNwvGQCOtL+tsOdNyaXIxIX
 U/eCU2mM
 yaSbx/3oOKMw+SVhTOr1Lh4qz89XtAaz7U800zEg0hXLUjjnsBHtlHuiow7xYTGtWSwuvesdjqsZyJ6b+gvI7Ei5ecZzln3YeyY73cXpuUk8oKZXyaRrgQy7Z9Kg6vmGDZKIXgHexghI9Ymi8tsrhNzBXg7O0evI4oo2Cq8nBWHaFmo3ZZIExhkvwVg2SmqozLDFM
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
 drivers/base/core.c | 50 +++++++-------------------------------------------
 1 file changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 513e5ef8a6da..4d76b67a87e3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4965,30 +4965,12 @@ define_dev_printk_level(_dev_info, KERN_INFO);
 #endif
 
 static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
-			       const char *fmt, va_list vargsp)
+			       const char *fmt, struct va_format *vaf)
 {
-	struct va_format vaf;
-	va_list vargs;
-
-	/*
-	 * On x86_64 and possibly on other architectures, va_list is actually a
-	 * size-1 array containing a structure.  As a result, function parameter
-	 * vargsp decays from T[1] to T*, and &vargsp has type T** rather than
-	 * T(*)[1], which is expected by its assignment to vaf.va below.
-	 *
-	 * One standard way to solve this mess is by creating a copy in a local
-	 * variable of type va_list and then using a pointer to that local copy
-	 * instead, which is the approach employed here.
-	 */
-	va_copy(vargs, vargsp);
-
-	vaf.fmt = fmt;
-	vaf.va = &vargs;
-
 	switch (err) {
 	case -EPROBE_DEFER:
-		device_set_deferred_probe_reason(dev, &vaf);
-		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
+		device_set_deferred_probe_reason(dev, vaf);
+		dev_dbg(dev, "error %pe: %pV", ERR_PTR(err), vaf);
 		break;
 
 	case -ENOMEM:
@@ -4998,13 +4980,11 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
 	default:
 		/* Log fatal final failures as errors, otherwise produce warnings */
 		if (fatal)
-			dev_err(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
+			dev_err(dev, "error %pe: %pV", ERR_PTR(err), vaf);
 		else
-			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), &vaf);
+			dev_warn(dev, "error %pe: %pV", ERR_PTR(err), vaf);
 		break;
 	}
-
-	va_end(vargs);
 }
 
 /**
@@ -5042,15 +5022,7 @@ static void __dev_probe_failed(const struct device *dev, int err, bool fatal,
  */
 int dev_err_probe(const struct device *dev, int err, const char *fmt, ...)
 {
-	va_list vargs;
-
-	va_start(vargs, fmt);
-
-	/* Use dev_err() for logging when err doesn't equal -EPROBE_DEFER */
-	__dev_probe_failed(dev, err, true, fmt, vargs);
-
-	va_end(vargs);
-
+	va_format_call(fmt, __dev_probe_failed, dev, err, true, fmt, va_format_arg);
 	return err;
 }
 EXPORT_SYMBOL_GPL(dev_err_probe);
@@ -5090,15 +5062,7 @@ EXPORT_SYMBOL_GPL(dev_err_probe);
  */
 int dev_warn_probe(const struct device *dev, int err, const char *fmt, ...)
 {
-	va_list vargs;
-
-	va_start(vargs, fmt);
-
-	/* Use dev_warn() for logging when err doesn't equal -EPROBE_DEFER */
-	__dev_probe_failed(dev, err, false, fmt, vargs);
-
-	va_end(vargs);
-
+	va_format_call(fmt, __dev_probe_failed, dev, err, false, fmt, va_format_arg);
 	return err;
 }
 EXPORT_SYMBOL_GPL(dev_warn_probe);

-- 
2.43.0


