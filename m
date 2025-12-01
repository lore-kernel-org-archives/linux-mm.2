Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E05D116F8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5103A6B008A; Mon,  1 Dec 2025 04:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49AA16B008C; Mon,  1 Dec 2025 04:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B17C6B0092; Mon,  1 Dec 2025 04:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2605B6B008A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:42 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 90F2614097C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:37 +0000 (UTC)
X-FDA: 84170389674.23.F8CB1CF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2CA53C000B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZQtxFbek;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cDnJfE3VZq3EyBzZ2d3T7K6P7z+MCcigO5Iiu7s+3Es=;
	b=0VQqYm+450NKgsNwIi4fUtytg8Zx6pbifuUvZN28QqAGqpmGx0WG/EvOXHVRyH8FpUr87R
	pKkTCfXO6ob8hxbrlC673P3Nko3ejMEu+Y61p/DosSU/zp4ff5wlxG0nBgbABH7UFYdsDw
	9hcWDzvL8oUnXACn68M5bMHTRbceIJY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZQtxFbek;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581615; a=rsa-sha256;
	cv=none;
	b=rOJvobBPQZEdbMjsA0BK7tDeK2782jN4oluaBvEvYQh6H/iPVjMMPLNErvpT3ehfvr69Cq
	EJbUincTNwyOpCE2tswf6LeSwWbr/IipCov/dCyrNiCX5J1Dg8doWJGz9AmW3Ofax2nsN+
	vU52qzlLHEO0ClBeuT4HqlOfr9fom6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581615; x=1796117615;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=lGrs1BxIQfKUnVh49VAGVD/M+EcaVQqWiEREPf8/PlQ=;
  b=ZQtxFbekAHEw8zFcHnMoAyDdctq1wTDwcRogJxQWeVnn7SrLlsFZJ/FG
   Jz5m8rYkCez2C0VxLKozQ3puiduJayH/XqiB36gNyw+GGMzqzdPtPT3DI
   tYqo9Pqwyzld0sLglurPnAvr8+uAhQIiz8aLyY1HuWFUH55M/196R41Z6
   J4IpYnG+HLQu+HQSLM9+00iKv86WaugngUFsDK4mQwrOlYRe/kWBy79pL
   KbLESWQw87gRKbJbZEwRC8tBpACd6YZVEAoPPw9890Q+Rsbjcy7iradEk
   QgtPyxWWFOO8X15Wfzv7n3pbgQPrHUgSdrOAKlvXDf+oIU4wJN9L+KxA3
   g==;
X-CSE-ConnectionGUID: uItHGfwnQsqOOfONn3bshg==
X-CSE-MsgGUID: +oE0Y93dT9erooLurnEpvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586479"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586479"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:12 -0800
X-CSE-ConnectionGUID: GjiwUtuZQGKic3JOiUCruw==
X-CSE-MsgGUID: +AuekXMBS1GGKGZl5pIHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014751"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:05 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Mon, 01 Dec 2025 10:31:23 +0100
Subject: [PATCH v2 2/5] drivers/core: use va_format_call helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251201-va_format_call-v2-2-2906f3093b60@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=lGrs1BxIQfKUnVh49VAGVD/M+EcaVQqWiEREPf8/PlQ=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCC14IdpQZIWRFY8uWJDaJFNym4gRmOg382V
 oQ+7qlcRaaJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1gggAKCRAjYrKT3hD9
 10S7C/9MjmVyix6rLwBRYAldSB+2C97nOdpnVN91fDdTqin21RsGU1uxg3gUy3RnXTNJBFn/vYs
 9tvKoynVYQIQ9s564i8Y0ueEAyVmjAs7VlNcnH2VVzhgxgLHcNubC0cJ36JFjYcXzHhPZ5PkVTd
 IYjwlOjlreQA2mAOm/a+28e75wn3dh8YT22wVJWdG7edkJOAaDG2v7i2W20sITdE+ACiG5+OX7m
 YKiBjeWP/sDeb1fOxGxUPuNcPR07xMapOC4Cb/UZxhENi5Ut9zl5LdNIGsWemQVqWkFRafI1bjT
 lU8mVjvqZtGC81bHUQgGHbPKqCK7t4QydTr0TPyk/m+7Qc9CKPOpKVpy38M/Blp3iEa5/OWUl4/
 2ptm+FVMKtRCqWsW0eqwlhpAZh/CoPDjmu7+yt0cyqC1pDQCycZsEvHFJyfs8dwuvZfSZndBo3l
 bF4XJ9CMMZpM6Rb7jeQofa3Mm7mg6KLovot8iYJnDWwGyjkJfyd7Vk8Wg8SBw7UAkx/u4=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CA53C000B
X-Rspamd-Server: rspam11
X-Stat-Signature: 7wjjh3a46yhhtgcguxgkjjbirk8iqwmp
X-HE-Tag: 1764581614-694458
X-HE-Meta: U2FsdGVkX1/1jXBbn4Ws5pHdf0AHhNw0/3uWrjKPxFB/JNaK/Spfjk4zjL2rP2UKVmYiUyrX3EhPVlIJapAYPdTKWPbfYdCL03Eyf7JQEGH11EJhuINl8tJqm3PEJyImS2eyqFua9AV/uPST9OW1C2w13TFwGVuRrSNeAl9bMOq8+3Ee2aQVEjm8jMHo8u9OR1kg40CNaFkg9vGKeTq6FOwnW6ZK6wPTxCTlxp3eMjK8brDBWzjfxIvGf17rtMLV/HwP2oOdtYaH5IGrUjWzBtL3YUNaqNFsUU9LPa3BE3vdNvWKJjTFrdHuijL0xM9QHWZUp9n7IH9UVfPUpAXMJ1NUJI8eLvqG8cOJ/R2QVw113zK6hAbAOiFc+dDILlakTgyGiARASalQpo+o2l3IL781ihWFo4Ms+L5OLyan9l00vDGkCKmVDDRnq0IVaqjXiXtOxhG4Se8r5f6mgvUi4vxFSJnxPZzvD/zxtipqxNik39O4MdNGuPIbSPkrO0nWfHC0HtOdWBycp3RchpXkbxRQN4grvkDDgkd65vtGLXV4M9zwiAuyypzZJ08q1viZn60vuuWZntAmXoxi/1TjgAB69L5Iv5qZiNi5VBwALVRzVQKso5L4eEgOXLKtk/WYQ0NonafATN0scicqxlU56s+R31gVKyK3h3+mCVp3g/too33yFs48yvjoZj8TWG/uAF7RxtdJXOxRwNVbKEjoYC7yWsjjS8PNSAZAstr5nrg3nthJPfcxW0gFKhL0txpxJyO0zJX8sTZH/vf4xQD5NEOZybGRzmJ674r9VZ5I2LQxjKV+SrBrWzhdLv3pWHGarzxIrRph9pMruCdxNJpE745Gizit9PWaTza6Rkm8NFO2L6fY0jKVD+JXOmKCLERKuPos2yVCIHCEnlHBmUru7WzaNcc/LhtJlIVFvz0gKuAoRNopF5sgG88UKNlvOk66ROv2zeg6tOkl3p3VYfF
 f6w8S2cn
 33+ScclRjJxZa0EQq2rIe0j4fsiwA6jVY6VGvKKGC1ZDCs9MdT8MWzn4ivfziCSoFcRtN7mmg6I3+FjeqsVSwqxC0J0yEradAc4VkRP9JQmNTBsowRo8ZO88J1AOWL2RVS52FjlqZ5y9X5+vLZNg2A2NTDhHqJx7rjP/0S5ViSOvhAn9vjw9qboCcHBMFs8KI2Nh12mppmPNW3HrbpJx/N9zDu+LXkVUb8ZsuN2DdxP+mn5Q=
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
index f69dc9c85954..513e5ef8a6da 100644
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


