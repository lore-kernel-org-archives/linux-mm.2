Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A568FD10F23
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4676B0029; Wed, 26 Nov 2025 06:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06936B002B; Wed, 26 Nov 2025 06:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFB86B002C; Wed, 26 Nov 2025 06:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A67066B0029
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:37:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 745C213B1FD
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:36 +0000 (UTC)
X-FDA: 84152558112.14.1DF48FC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2CBF910000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZjJzbvuy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764157054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eo8pVLylVZrMGeZKinhCgrjjmBYXktuB3eYr0qehkGE=;
	b=hbi9L5+3LPk6SzXa9IlryQPgovMmyAB5GEkUEMjqCtVngBG7jMIvNFHQMSKEuswQabIhjv
	yqnZyD17TYvMrCpahgbaUlxH15WWhDdkWkaR3gA4xsQlo8kFbhueNbciogRfEB97AuE7i8
	bY8TIvVwnRSKCx8yZ0lYHnXTlxpyES8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZjJzbvuy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764157054; a=rsa-sha256;
	cv=none;
	b=eQad8lflSZAn2XvVh7jzrXkGrC4PszmIinMR1rLj3NaNtvBqBeHlSUQsCdQAUIieTMFmVs
	U8TMv3OVV8ZC9ABf1AEedjyP5l8PeAsyKHOhPXdiW6G+SBgHfupmDOlLfY3yZSQNEl3k07
	hg5YB8dtXGZ44OvO0qNriwu9dPbfqVY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157054; x=1795693054;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=k9rf1evcgOHbfI52abG6ZM4IatEIxMqcv9QQySq3Zww=;
  b=ZjJzbvuyaCHGJNXLbYw8NdhSoR9UREujIHh9GBL0SUYUvZFbgYOo6frN
   k2fXdRwyCE82eT9La2G7I7v5GhGBGjSRoB4Gu8Pnra/S5Vw1ilFGyrsG/
   tobGdYYg3yljjbo7QtPbto+KiloWlb8CXs7YpG+RMCkCWH5mjaF8JczvV
   Ssyy9KEWRMXzQjhqTcAUKLRZT8r+2mVbARJ0FBKzvaexgBrQUvCWWc8WV
   2LZGHGs/NdghB+mJjH6UB7hOeL3uTB7atsfHrK/gU3nQ6iPN5e9hhg5tm
   +5Qw1aZkeHGBuQ0vR7s7UD53g9HGX7DivG9LlKBhXWrjV9XRExgKWoXRs
   A==;
X-CSE-ConnectionGUID: vZBDTkH4SzaQovAhgtczFA==
X-CSE-MsgGUID: T5hWZjihSqOKA/1ycXNl4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66232841"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66232841"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:33 -0800
X-CSE-ConnectionGUID: A72E+rh1TGW25s19+VobVA==
X-CSE-MsgGUID: 7dNS3MmkTkKzlCA3VQtVgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192804445"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:30 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Date: Wed, 26 Nov 2025 12:35:49 +0100
Subject: [PATCH 1/3] printk: add macros to simplify handling struct
 va_format
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251126-va_format_call-v1-1-8a604a331730@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2003;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=k9rf1evcgOHbfI52abG6ZM4IatEIxMqcv9QQySq3Zww=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpJuYxH0bYKsvR3i+lxG/l3jrDVxriqdFXPMXak
 P8UotHxgOmJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaSbmMQAKCRAjYrKT3hD9
 1/q6C/43BTWbOq9jSZxlivOSeTr9vqXUaAzZvFq2HvmBVuNfpUHGUyro3lyoJ8JKJ2C9Zsx6NRy
 RuT3AYLODLgUyoW3o5yWlolArXSJn13CQGOPpzRQepvWO4NXdeeoeCnUuaQgR6e+xIMPvhPW6Ke
 mzXdTWT4LbMs+1Uv5U3QIc0GDpqqxqbQT9LVL2OIFOxjanUshofUOVbU56Qu63f4R/V1+qDjW7K
 oqWPxqoCLdvup6rD3fI2nFqh+7Tfbp+hPLHrmRVfqcrJHqKWklsLI7iC9t6EhsMiR1ULxiSVWzF
 d8ODZbjEdVlQGtAdry26N6CXO4JcgNZDwWpQfphK5GLsDh0f/Q+oe3q0HuVcA8O1ITAl6aNq9TQ
 JVMBNovmp9bc34QPml9SoM2ew0ol8Xogj9Dun64/yG8C9aDfk4ZUMX6gyb2BjG3l9ISa7KdoTK0
 WIpahnhKZILdUG+iWxSAVw6tAx9kXYVU68LSp5ldmZrA7GIj3fKqUx3xIZWKRcd1xnSh0=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CBF910000C
X-Rspamd-Server: rspam11
X-Stat-Signature: oi17zysqzmzi3u5o8axhkbkxhdtzjsru
X-HE-Tag: 1764157054-945800
X-HE-Meta: U2FsdGVkX19mGmCKV917GaRFIC/Y3PjYkJyrQVVd8Dj5HRXi9V7vwzpm+f2BNHpai2ctIHl1YwDYkftHRoagZiiRyFm3a2U7onkmMyun2pOoIZxtGYzgLI1QK3DUCvTargs6Mpy06JkF2V1tLm7J5B9iw5+p7baZSXKNaqHJnhxhCFOpQKNFvlMjf4QE9HXgOjwY5GI6IAv8heYq/h0TDODqa5LQWlQEdAZbneL3BqJf+yE5aXiTZhz2nblF7s7wtFzvYKUHfNsfCcoa8ioTRhrjgynHI205TCLY63EuLoXQ2pcMMmZLuOVxNDALrhRh+VFeruDuQxnArZFslJnuM5yh69ld0TpSsBKrxClftcOR0iXq3vF+k5scGwV0OT2cnoE0iTsyDAeaicuhZN2MEvArZDgWVgxWsPogwKTVZ9J98rYC4j/xsNhhY5OOeEojGd0nTGau9K045a/RjaceY42x+sqw+EYD5+N1OpcegYU8Z1BowtGVfiY9LUyJcaCj39PB08++2WU89WCfsrvXfWFSd2n/BItstyWWFw1PF4dOi4+JaorYA0vDhyI1ZBu4Q2clHU1039pc9sRnhQjoNiQJlgntDz2bziZKWZk27H9+5Gaz/+iBHAz/ob1YlhIG8j0Mwlt9q8yfatPwMqlsKtsQry7NlnpsR4ViypuDGo6JpMGqJL1i9oyYgB7Svz4zDbfQa82+AqAwdhm9Otj7A/62NS4vwr2NlADIxrjxGsaCdY13iKImBn3jtjEdeZBN2ULUN8cMUBT3vw9Em8LvoWG5LlHEy7faZoeHWUDdkExNQe98cRRVqaxZ19AJhsYWBSlWWCjdXjr0LcLlsURuBgTeByZ/9YPs1UZutbofq0nWJiaMTM6wxK8rDI/Sw8E7gdshARIV5lQKzu7M25+XJkPXUlVYPYUJnW49/lB0zHp/+O4FmF+ElSFTupLxzVdgvAgzvodH0LZFk0B8XfM
 o9CFMS5R
 ilhrU/RG3TyMN7Z4nTq4EBZLO0e4v+O3yI+23eqrmq3SS5sDBJOSAjQDSCvEYRp7BqGlOEe9/QktrF/9in8plgMr+nCblTKYQsvCNileO/GKvgtnJFp8o0eHQYsIWuwRU5GbiZTlCRALYMJw8moVoS1kZCFDozkPGxvhO3TrG9mRHBgNiLSj5l+Sx+nFwCZc4Wmx52yXiUuDtRCyqNr6ivPfA3HOONXjxw9TdFDQJE8y7AtY=
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
index 45c663124c9bd3b294031d839f1253f410313faa..6fd817ce29a66b33a804b660c2b770efa110ee7e 100644
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


