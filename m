Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D32D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2466B002E; Mon,  1 Dec 2025 04:33:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 499D36B0088; Mon,  1 Dec 2025 04:33:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AF9E6B0089; Mon,  1 Dec 2025 04:33:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2981D6B002E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:33:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9530140AB4
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:34 +0000 (UTC)
X-FDA: 84170389548.19.02641B3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78418C0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:33:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KrL7hsJ5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NaYrB4l6eWTASp8ZXH6AxHSVGA3dxA/bA+wA7mm2P5U=;
	b=w7lpFjVIMYhx5nJXUsyc6NKilYPdVVTlPRx5jw4E7Tn7Tt4Msu0qfgYWlYz0zOJHyQdNJz
	ORhMusgzEQaX5jcIg9coGJIi45vAFZB+NWDGnv/edbqdTvsJU1WJBc0UraGyZkp9nYof9U
	NVJNXm6W2t/TwsfX12JPW5IizKeVNjw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KrL7hsJ5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of andrzej.hajda@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=andrzej.hajda@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581612; a=rsa-sha256;
	cv=none;
	b=ULyDBDfwAZ9oFfm/ld48LeAkUOSDqaX6/Iizp1VP+GoM+0bJjAoxvy2/FqicJ79gKhjwQa
	UUfXC2Xn3X659V4avJ1gQ1ynDoyAjJSFCz//HX+SRoLohYvM8rTTm1tORagsyG4eQEVBeo
	ayquWTBBig4nXQziJN3052EGNceTi2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764581611; x=1796117611;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=zNBD+A+iXVqpv+gNiOEjl6zITJ0wPMuYG4MuQZeW2ZU=;
  b=KrL7hsJ5gTtvmk0UrOEsMCtrjAcubmc6tEzoSqkrtZC/mm++MSR6SjBJ
   x9BtsiEPikNVikYGE+4d+Q7w0dXWTu9gD+JeQLeBnyzEingA8uigum88p
   kq3vf6Ek/VRvAIUx/isFdg8gDD04SOSKReVqdm77A8HyIG1kXpczN2hs/
   PyKszUUNQK91qy0e1pwxhlCqU78HQfGHK+BsgzDW4XvruNauV98JwaOt8
   XREuDb82MkwZ4EdGUfImgsu1DpTUrldcRHPlJtXoHYwxdAxe7+Z89tQKD
   ObSXykcnC1W9YM3jA/DgJzpEqbKeV0USa6i6dIlLggQPD5qGAPqCOAg36
   Q==;
X-CSE-ConnectionGUID: QwZLxmbHRKCi7QTd1wNNlA==
X-CSE-MsgGUID: MCZoRNfmTHWcuIIzUHrBMw==
X-IronPort-AV: E=McAfee;i="6800,10657,11629"; a="66586414"
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="66586414"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:33:04 -0800
X-CSE-ConnectionGUID: XXnqchyFSIGVc5XD7e1QeA==
X-CSE-MsgGUID: 8rqGomoiRGSgdqGFa+4odw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,240,1758610800"; 
   d="scan'208";a="194014675"
Received: from lab-ah.igk.intel.com (HELO [127.0.1.1]) ([10.211.135.228])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 01:32:56 -0800
From: Andrzej Hajda <andrzej.hajda@intel.com>
Subject: [PATCH v2 0/5] printk: add macros to simplify handling struct
 va_format
Date: Mon, 01 Dec 2025 10:31:21 +0100
Message-Id: <20251201-va_format_call-v2-0-2906f3093b60@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGlgLWkC/3WNywqDMBBFf6Vk3ZQ8fJSu+h9FZIyTOqCJJCG0i
 P/e6L7LA+eeu7GIgTCyx2VjATNF8q6Aul6YmcC9kdNYmCmhailVwzP01ocFUm9gnnklRa3RNsK
 OLSujNaClzxl8dYUHiMiHAM5MR2YMC0+0HuZEMfnwPZ+zPPy/J1lywe/QiAq0lq0WT3IJ55vxC
 +v2ff8B69jM8sYAAAA=
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
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2162;
 i=andrzej.hajda@intel.com; h=from:subject:message-id;
 bh=zNBD+A+iXVqpv+gNiOEjl6zITJ0wPMuYG4MuQZeW2ZU=;
 b=owEB7QES/pANAwAKASNispPeEP3XAcsmYgBpLWCBXIZJkfYMBnvqix36gH82kiCgWg87tR4GA
 m/FApbYFYKJAbMEAAEKAB0WIQT8qEQxNN2/XeF/A00jYrKT3hD91wUCaS1ggQAKCRAjYrKT3hD9
 10sEC/9OvWrRfv88d3Yta2uEulsEB3wcsna1k94mG+FpUUYzExeAsNB0HqziL79tR4ZbV8IIawC
 1eUtK0dJcdtZV3pvBJAbYGHF7PCmj401+n1XKY/9G7Fn9Y8zsC3p6Aa3eNtMnx49hcEqeP3kSzo
 fdbPAwukgWMThMWyNlCq9s3M3XhdAUsyC02+vad2MU4CzFgY+lQdCPqrPRAW1goLXr173Zo0gB+
 wNk1qbxS8CrnwHnQHytq1SlzgwHYKg3JyZKZBm7nJPYhlgY0uVqV5OeA0wPMMoVip1bQK/SZKfs
 bKTF5cFn+xGI8+XdnkaeejrqDGsRnTi+4Par4FpWR9AIroJag7NCU/Ypa60zSzxkXm19+CeUHyQ
 pKXQLYsD3thphGcXEljFl4VZRWkxe+Sy+Wu6lP77fkfSjGDJ7+qDiVGbryeDnsxrp7Uye9UqoaR
 tpPhk35822jNhXNFyJv+uKCD+10lIIbULecLiv9dVRe9XT6No0xY9vRSUn6G5iV36JZ8s=
X-Developer-Key: i=andrzej.hajda@intel.com; a=openpgp;
 fpr=FCA8443134DDBF5DE17F034D2362B293DE10FDD7
X-Rspam-User: 
X-Rspamd-Queue-Id: 78418C0012
X-Rspamd-Server: rspam11
X-Stat-Signature: 7bk87n1j3yqsrow8y969h3wm6j3ijtba
X-HE-Tag: 1764581611-12137
X-HE-Meta: U2FsdGVkX19naEARGZV/KMXBAbaX0Gpuy2INx4ITfdfltwtlE5ujm0XGNwfts/u77IKWyO4bamr6KJbB3sTxqlU3RbSND5UlrD5tQ96NbP6lOl6HrCaR4mBQij5haZD3mW0xLsktHdULuXSoG+Yfh3XQXnfcg3ZWY4PBfA41zy53m2213u+B34r/6a+tgVcVLSTFexYEaa+oZLnN64DsJyI7bCgvnXapMEY0LJkblbVwh/j0kzTjPI2ATLcqmhEPwZc7f8C1U2eXD2XJ2InQy3Me66eodAdYCnouHrVbi+X+wOVos0ohW1WQbVQCIfdsRfkoBMKKEy5PuJvPyWo6iqZ8dxRKAeNUwAk+6elOe5vhb+JXC1POCxRGU1GnJ2h0HEdLpHlYPnP2WFnqKkDiH8NEnt2jmJphuGq4V1NN1U+W+Yg0t3TdYqxNqP1c7qhphBTX+H+9beKlR7ZWcOrizkv34g1MI42Mc7cMhaWa6WBEkJ3lwEAWP6BV+vz7AVHYuopP5bJIs2BuSmjtXBQ9aIBPUEnFmoKENASFTsGoIM1QmnuraLy2Y2ro73o5BzZsVSwXay6meBOQ5X63yi47SulEcMGRrBRtoLrj9jQxFry/z+/rqdM7xtWUDi6NyCBx6LGMOPhZQP/zp5ctcdeo4PrMPE1CsNQy4hGK5FxuHfRneh39Y66Mg16lELqOi9lK2B7xUjZrRFXaK2m4pgO9MH/XJ4RHcunOGSI131yZNABzc4DkGnYQAj7us/8gc9uYcRI6Htdf0XxuLNHKdKEooy/i0168YhxkwcqXtLELsIiX7GxbMKaHBe6SSy6SBkpf2iqYVxaE+nUX00bkd0HikAKmL80GmWZZTKVorfsyRI2lwnBV7lLLJqjlB4OtGMgDnkOHDC4oXWszbxidqBL64fbf0d6IEDScnkrnj5/0FU5G5X36OPlhbxZ+1erY1AGECfiw3VkefDCay2fMMNF
 uN8Ig01A
 RlZQlOuU0KVH2kYBc+hm7y87Qu65dopu2Sqhg0+2JDCVxWsA5jJtEwOKjaD228VQlPdmGv3vYNRWULRxy23G8TG2XiGdLk3Cnlq19tU6vY4XujrOWiYT12A2QQyXoOGKSLI0bv3zxlXj2e+tyywc1rMrUz64rJIiTqJhiIjP4g/ic6yP3dChywFZ7nMfNbyMmjfAPe5/Y1+vD3YCl0ZKeDI40N/QPWY7c3mycq34BovkIAFYCIdac+ZUOFL763U1snSrB
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
Of course, I do not plan to do it in mass. I just provide few patches to
show the usage and the potential.

Provided helper deals with variadic args to va_format conversion/forwarding.
Similar solution could be proposed also for variadic args to va_list conversion.
Common code:
    va_list args;
    va_start(args, fmt);
    ret = func(..., fmt, args);
    va_end(args);
    return ret;
Could be replaced with:
    ret = va_list_call(fmt, func, ..., fmt);
This is less rewarding (less lines to remove) but still looks promising. Also
separate helper should be created for functions without return value,
unless somebody knows trick how to do it in one macro:
    va_list_void_call(fmt, func, ..., fmt);
Any comments?

Signed-off-by: Andrzej Hajda <andrzej.hajda@intel.com>
---
Changes in v2:
- added two patches simplifying handling of variadic args in drivers/core and mm
  in slightly less obvious cases, this way both mm and drivers/core do not use
  anymore hand rolled variadic -> va_format conversions.
- Link to v1: https://lore.kernel.org/r/20251126-va_format_call-v1-0-8a604a331730@intel.com

---
Andrzej Hajda (5):
      printk: add macros to simplify handling struct va_format
      drivers/core: use va_format_call helper
      drivers/core: simplify variadic args handling
      mm: use va_format_call helper
      mm: simplify variadic args handling

 drivers/base/core.c    | 82 ++++++++------------------------------------------
 include/linux/printk.h | 30 ++++++++++++++++++
 mm/page_alloc.c        | 14 +++------
 mm/slub.c              | 33 +++-----------------
 4 files changed, 52 insertions(+), 107 deletions(-)
---
base-commit: 37a098cc87aafdf4de147851cbf350bb66c51b45
change-id: 20251126-va_format_call-41053ef60fd7

Best regards,
--  
Andrzej Hajda <andrzej.hajda@intel.com>


