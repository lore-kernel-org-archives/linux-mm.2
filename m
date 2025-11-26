Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 628B2D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937516B0028; Wed, 26 Nov 2025 06:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7E56B0029; Wed, 26 Nov 2025 06:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D71B6B002B; Wed, 26 Nov 2025 06:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 65B416B0028
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:37:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B84C131339
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:34 +0000 (UTC)
X-FDA: 84152558028.28.06BF97F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F2EA10000D
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:37:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiJbqXtn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764157052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fDQKxE7UEgrie+rUfcSBmD6qKYweusZMsIhS+ySK9Vw=;
	b=qYTmuzRpmBhKVjD1E6WBTJ7poNe8YeG2lwXkNnZ9bJRLouqJXe1YfmWksRehWp+w7+jlhA
	O8vHcK7HPvQ5vDSvIxcCyvp9/iGLfBCGAWH11Whjhw0YeGzR5hAAWzF8TgpjWzyphoq88i
	sOEB2V7Hn2AyhHAiB8DKs6GbJQ5Tup8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NiJbqXtn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764157052; a=rsa-sha256;
	cv=none;
	b=yVKNZxoXXDPT19vGMJEpsp/V+mHh9PO89UAs+tUYTYnTTfSHBnvOb97dtxercslJQWBgFT
	LU+esOjqRjXT2jgWmNw18/uESB3c9SMnaRwBEX5ZziWyFqRkzyau6+emzAGcKG4fun8/Oe
	NVFZvXewce5GKnaisXcuvYXAb3kMUTM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764157051; x=1795693051;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=qapqRYmQEkgzDGVBOxPMGjJRFppxpGzqyZ22CtAg6Zc=;
  b=NiJbqXtnD9eG61Qv+TFhaQS1QpUYN6Sc5MrQ8ggl5oY/4ENX/29/qc2M
   DA3fpKUg/q6FvDwZ7YLKjmBC9J2KTknzpqn2MCSLigdc0CyA+lzz5KPRb
   VigGkG5wUxGWZFUqZruRsyYvd6T9GmT3+ll1dH7E5TMpQ9kKvKS3ixdEa
   +C82dxJ9u/nwGRVJZGL+Iac9iU/N7TC1dvKYSXoTJF16fyb8EmC+YcW0D
   vrkdiZIhnElTQonLsirIi5k+YJyRiJhr0FL+Wg9Qk8iQe9Syi4periatL
   /Cc8qoknbYkbGHLGCOwYJ+78j9iDWwMbec+ktG0kegekUaBXlrSXthymQ
   A==;
X-CSE-ConnectionGUID: HaDBe14CT1GusEnGjImSCw==
X-CSE-MsgGUID: hokz5ieER1m/qZq743J2AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66232829"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="66232829"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:29 -0800
X-CSE-ConnectionGUID: VG5QBuyYSEmBkcvNqBhy1A==
X-CSE-MsgGUID: blXFTAVFQL+9E2vHPdrn0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192804438"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 03:37:26 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH 0/3] printk: add macros to simplify handling struct
 va_format
Date: Wed, 26 Nov 2025 12:35:48 +0100
Message-Id: <20251126-va_format_call-v1-0-8a604a331730@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABTmJmkC/x3MQQqDMBBA0avIrB1I0qrQqxSRMZnogEaZiBTEu
 zft8i3+vyCzCmd4VRcon5JlSwW2rsDPlCZGCcXgjGusdS2eNMRNVzoGT8uCT2uaB8fWxNBBiXb
 lKJ//8N0Xj5QZR6Xk598m6IqH7HDfX9PDLDJ6AAAA
X-Change-ID: 20251126-va_format_call-41053ef60fd7
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1086;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=qapqRYmQEkgzDGVBOxPMGjJRFppxpGzqyZ22CtAg6Zc=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpJuYx9YqJhNK+5SxA7bP5HtoVetWNsKlHAm9JO
 uDeFo0zy7iJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaSbmMQAKCRAjYrKT3hD9
 1whdC/kBeexu1mvqHTge9p1OoNI12CJW19qeJ/qiMj+ur0pZmyi7yoEXrqnyWruSYWrhL30yt1K
 tfOGRin471PIpt2G19eoIZTFtA7KcgdGeZi9/eo7waOIZNHUaWbGn3lTXTu9AKHpaoWCmJ7vgW7
 ghQ6nnx/SKU8deC+daRkMW9gjudLdRg/zWuGndJENJlNb5pgKLlevdAfanu0RezNnF3GcLagdMI
 7XvQvl1eJ+6373mvQNH8HIat38eeY++hfBqMjAvlghtLroVBpbBVu4fj9hk8cDvmq633HxcUyac
 RNRUjPYRNBxFluLbtkYNl/8i0JearUdYOd/amXS+ZGlbmem4F2AyAAHSWoDDIYUdZeT0AYhU642
 xWDXTTdxYTuOzTN/Ym2ljDARXafm9cNTUou7jvcqBJyqhWqf4UaFJGS9fu2cKHx6+Vlt9yJdK9D
 Pj7YAuYk6bfI2Rn45+2lp5RnHObREqYOwk9ABmgTTIWjc9db2rJyHQHSDqxTd3yKBmaRc=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F2EA10000D
X-Rspamd-Server: rspam11
X-Stat-Signature: 3goe1g9p177w5u43urz4iezmcfjofanz
X-HE-Tag: 1764157050-434359
X-HE-Meta: U2FsdGVkX1/gvXqk6sVBme6MqzNhLyL6Rdu+boGWF/7M3PGfI+b/abKlBNzvjH2LTnXjX06vlrik+21phhFYzQW5IL3jXQJld9fOGfQ9ivMQstwzLLMLwntzu3JWF9djxpB/PFKejmRf1PaxsvdlUoms+LuR42MNwTinr3sFiUvUXxNvFicE/0J75uIuETJaSiY3hssgmFmn4YnLrZGI8PNAl4CC0iT+zJaUbL2nZqLv2MpL0Ho1mPUBy96/dk7Zm3hrIEiL1Bx/+KGejhYGDLJDaujBXA08bdYENLibn+tNvNs0/YBcwLSbBxkll8Y+5wzyjdADXwQ6rLHpZrAE7ju6zOc0bA6LoHtzMwVgBIU3t4elMFax9U9+92cyQMkZ672P+Pk5lX1nUAgs+D13G7Rjx2g755MR91cQgnJOQmJ5CdMhzFJk6xYcT1zPvO0OHkcHsj6nNzMs6P76Yk7Iocdj1Qw/mI9YEEzlOwM3nTUt0r/1fLRhmRQXc2Snmb+SuxAPUwDINlzsJ8b+rRAYXb9qRIWjQTyWC6S/wIDnij6+t00wiKNlawztsVyIzIqC5kRXlpNSEOJW7swURBsx7CozDCU7tohSoIo07opIqmNIgXveQYkEenzKxthnHTOQsDKSeqyqvAcxOAPDn55nqguwNDeLHAl2UFKNF7usANBICu0AQLs3QywsXGVjXm5Ijs/G/b8drupIwFnpccf+lFEBcKhKffoqe4EtS3qpq0Jv9vjlfJocVgZN10zxmvoRz/TjiqNhdxmZIoRQOp7U77GKCI22t18sVOwFGjMnnaqTfMvr7IvIVvydbhYBBDu24dmF3BWDNpTflNGYfolgfCfi+HrXtcL7glMYZpXghF+ZFHBfu0U6WQrejcSnP5c4Vl5tSPP2v6R+75B3LqaVXPmE934GKmqLGByYMrosthZzJTogEvF5R71NP3F7vdrfy1JLpytk3j8HX0JCGnG
 XH7tDJdn
 yhMsnZefna9hdx06qR0L2pTbVYHf+ppPR2ceGT9ff0OcMawmVFyEwZlZGLACgYx5W30CIg7EL/o1LHEhPeYL9X+jDJnTkBG7mZj3awVWX8oUVzOe+Y4B1dEU8ISL1GuU2DkOIAYIkHIcefhatdD5+EXNmk1I2QbwyJJXXT5OzMcLFKib++9IPdM7pPdEzRvFP1GDzbqegx71rUqDU+JGAVZNlffLRHPWZIBFNG5BS6mlrfs0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset contains patch abstracting out most common bits of va_format uses
into small macro. The macro works as a forwarder of variadic args to va_format
call.
Rough estimates based on dirty cocci script suggests about 180-230 users
could be converted, allowing to remove about 1100-1300 lines of code.
Of course, I do not plan to do it in mass. I just provide two patches to
show the usage and potential.

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
Andrzej Hajda (3):
      printk: add macros to simplify handling struct va_format
      drivers/core: use va_format_call helper
      mm: use va_format_call helper

 drivers/base/core.c    | 32 ++++++--------------------------
 include/linux/printk.h | 30 ++++++++++++++++++++++++++++++
 mm/page_alloc.c        | 14 ++++----------
 mm/slub.c              | 10 +---------
 4 files changed, 41 insertions(+), 45 deletions(-)
---
base-commit: 37a098cc87aafdf4de147851cbf350bb66c51b45
change-id: 20251126-va_format_call-41053ef60fd7

Best regards,
-- 
Andrzej Hajda <andrzej.hajda@intel.com>


