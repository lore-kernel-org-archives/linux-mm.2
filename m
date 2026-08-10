Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B41C5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3ED6B009E; Mon, 10 Aug 2026 05:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553106B009F; Mon, 10 Aug 2026 05:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491266B00A0; Mon, 10 Aug 2026 05:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4136B009E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:39:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B49F9A28C0
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:39:41 +0000 (UTC)
X-FDA: 85084862562.20.71669F3
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 02B394000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:39:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v/LHeJ+F";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UfUUXpI32LQkzhwHNFK5M3axqxDbYDPzpnxGauPdSs0=;
	b=3/CZgeKA8/EmVDg4Eg/bVLhqSIFb5jxcILl1W7B6/vBQuhekm1GZn03gyUWPd1FtMpkE4/
	eOAKnjRspxEOa+6yCiQ37tV8lfJQaE29jzJ8gJiKxkTHHyYF7oQkZGrCy2dt7WjTyNyr5c
	KVEI+Td6e/kkOEB38azpgKMfWgUwpv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354780;
	b=kdknpZ368try9JGou6t9qnCjRqjqBpWXAK8RAxSKKaonhkLWDXDtMJ7m0n/LCh3RH2mtg9
	f6TPFCUBjBQrz0wy6iIiFvPkgo9p3bkAMJqwxx3AyGKbigNC+SMlop0f2AReslTcuGle2J
	ZWhvQXJs2jpbWmlW0P29vj5jSGcYxbs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="v/LHeJ+F";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UIktgvsGULxryLMUxmq1Oes31GkwUNqAwQdlsQG+ahw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786354778; v=1; x=1786959578;
 b=v/LHeJ+FAcVLjiBlrRxpk9Zjf7fecqpX2/ZyQ1gVvYUJZF/tZRbWiPHmtEAFG4Gl3Ws30Z5b
 ivQmKPZxTtYo8Hy+albAC5x1ibfoVY9sZGHywNE+QI6vOdyqEpu9LIZUglycLuKtyS4pLnp6+ds
 C+YsLVjMVb6ZpQFvy22idnFs=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (116.128.244.169)
	by mta10.migadu.com with ESMTPS id fd542074912682a9;
	Mon, 10 Aug 2026 09:39:37 +0000
X-Migadu-Scanner: mta10.migadu.com
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v4 0/2] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Mon, 10 Aug 2026 17:39:53 +0800
Message-Id: <20260810093955.153015-1-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02B394000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: t7b98rrbf331gzr17iawx47hbgxbuuo3
X-HE-Tag: 1786354779-979308
X-HE-Meta: U2FsdGVkX19kA7ktFiZwTqVuHqQ+KsGZxYhOoIO8zCmwiaiAP5tip+d+J29xtUlH3HkExWkPKBpfiLFYsFa6aZxCCGRIglrSLSSCHVSm6MpFzt+5dxUYYadeo5EoZo5Og6a5ZpAkDy2Dq647xZra6NGk6mV42m754EW+zkZXZh/jgXm7jtkZrnXosqMdZVOeKSj6RaOd+h68wcqxDkfgQEBzJ2/ndCAPBkV2kwzdiynJXxg+3sue3nebly8xVTdkVmkqTM/TmnbDADvCitgG5gAwwOWtNH7izFSKVZIUHonSpqLdZGiyA5VNw53URL4S3O4RW5aBoXbP5XCjDrPSQP+IaTFHoAgP4gowzqArLN4UjvvDizv0HMJr3vGdMbUd6Iu+c9Xzb3BVXTMcVpJBB8jY9tJBru2W3r/cuC/jzfcme+WaWh4iDThIRKiPk/Tp5WqTTLxjcerw7XDkdnzLoaKhOH1mVtSTilfAHJlbkSOHEgS9XbAr9ZCY1x4+51NBQmcSmpBshm3yGZfB2dcgUvxRfGa4108XmlNGIQorcdHIBI43POZ/yKFiaUwf4/Xb2da1OC7TR7ZuAcEftN3kAXbApcChDtcGS/gTw53tYibdsZbNAqPHM2eFZQhJVkuB52n/B/wCmx0daqqlgMNCJqVo7tlwJx1nEJH8OacXquRKLCvz5RqfZHdkmwVFb8rvvhdXerIradmp8CCM8HhFgn9ciWxV8CRGRIgSIzKr+DBlXcShoXiJybtfSL3tNg8oMGgH3hK72YG5eYUTI0QpmlOhgKKDrYspY9IuKcTdyWxAx1zhxEjrvnc+/B9Pr3tZG0aDYQwX9wbX6H3nEViZB35F3q+vUsx9Kqli8y90RyOgX6Tsf9aiFU+i1y4881453P4ADrxguJINXxGdA5fw3WIA3gvG5hYN9bFK7aEnbPaVdkLyOISOw60cQnfunrGSF180xW+LxMgC4MK/eFs
 2kGmBPBB
 6kJ62TFz+VXjY68McRYAHfOWZRjY4y4Ph0uK0mmBBR2F/tziAH3S++B48pMCxfKputdm1si3M7IzozclyVYevFMlDdvT+Y8ukVV74zML+F9o63F2O7KUEOeWDGc2Q5b6cw+NFC2IZQffBxYGCsI4Z4AU+LEIY5zc9k67KYPZMPEhFDshyKyCg9150Dzw1ZprFGFSSmykjun43ZhfVeUsW7RbTiXWtJSslQXOJxn445rUi6vOcTFfUGHODvBLcCTg+NFZHWKYKKKDR+6OBfdWTwVv7w+VxHpwf3aGYcOPnHmXeyOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3 was a single patch. After discussion with Suren and Andrew we went
for a more graceful approach: rather than failing the module load on
overflow, let it load without profiling. Once profiling is disabled,
codetag_needs_module_section() returns false, so on retry the codetag
section is placed as regular module data.

A new patch (1/2) is added to move release_module_tags() above
reserve_module_tags(), since the overflow path now has to call it and
the helper sits below it.

release_module_tags() is what module unload calls to drop a module's
reservation from the maple tree. By the time reserve_module_tags()
detects the overflow it has already stored that reservation, and the
-EAGAIN return skips vm_module_tags_populate(), so the backing pages
never get mapped. If reserve_module_tags() returns without calling
release_module_tags(), the stale entry keeps pointing at that unmapped
range; when the module is later unloaded, release_module_tags() walks
it and panics.

Tested on an x86_64 virtual machine:

# insmod overflow_tag.ko
# dmesg
  With module overflow_tag there are too many tags to fit in 13 page
  flag bits. Memory allocation profiling is disabled!
# rmmod overflow_tag
The module loads without profiling.

Changes in v4:
- add a new patch (1/2) to move release_module_tags() above
  reserve_module_tags(); the overflow fix is 2/2
- release the reservation on the -EAGAIN path
- return -EAGAIN instead of -ENOMEM so the module can still load
  without profiling (Suren)
- reset sh_addr, mem[type].size and sym/str SHF_ALLOC before retry
- skip percpu counters in load_module() when profiling is off

Changes in v3:
- use pr_warn_once() instead of pr_warn()
- return -ENOMEM instead of -ENOSPC (Suren)
- expand the commit message to describe the /proc/allocinfo impact
  (Andrew)

Changes in v2:
- return an error after shutdown_mem_profiling() to skip
  vm_module_tags_populate()

v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
v3: https://lore.kernel.org/all/20260805090633.141001-1-hao.ge@linux.dev/

Hao Ge (2):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  alloc_tag: fix undetected compressed tag overflow when profiling is
    disabled

 kernel/module/main.c |  17 ++++++++-
 mm/alloc_tag.c       | 103 +++++++++++++++++++++++++++------------------------
 2 files changed, 69 insertions(+), 51 deletions(-)

-- 
2.25.1

