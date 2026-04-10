Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB77F45A12
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC67A6B0089; Fri, 10 Apr 2026 19:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76C96B008A; Fri, 10 Apr 2026 19:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C4F6B0092; Fri, 10 Apr 2026 19:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98CF36B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:03:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F4381601AC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:03:56 +0000 (UTC)
X-FDA: 84644175672.10.C8CDAB9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1348CC0007
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:03:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k74RmVsu;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775862234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GWnC9MP5EEYIOM88Kc2CSfArcuDHNBSU6KPhlwMkppo=;
	b=RhwMxZXABjKlOpGlFHVBBixMdo6usgbmp5JDk8V2mK9SQ5iRQGSIa6Hh/7AVS90bIG3n9j
	sJ814DumhAAlZ9OQ3cldiH8u5IRGvFfcJ+rOfJzWKJfq9/6upCW4T1lToIY7fymERKqdtq
	XJyNjuxe1erJ3Xpnnlr6/UL3xv4wk5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775862234; a=rsa-sha256;
	cv=none;
	b=mJrvQ6uAj1jaRxlQRFHxUJ0l+fEfVZ+1OogaIgd5eMf8+wUOHQN1zTiNzsX2+/6OEXEsds
	DWLPge0Rp7j2WjakoeQd/QKdZ99W2Qa0wMSOux1+AZ4Td9StKIEnQRd82NIMCfEfUkDK/0
	q6EeT3YFptp8ttsRoZf35uSONTj3bL8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=k74RmVsu;
	spf=pass (imf28.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775862233; x=1807398233;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1licrSNtxf0nZ8ajbIrtz7CnCXf8IyTYurmKzQYvq24=;
  b=k74RmVsuW/skYFUhnQGpNT1Mi6tIbaZnbClzu/GjwoR0Csmhe0zzQu6B
   q5Y8AdogagHtT9lvcZlYoXaiLiX+9MsffoPU2PutJt/8zblm584elecOh
   AKhzyWiVRkg8Mc4UTi2J/lj/CZ/ulmob4C3/QKsiGmNQpu0/KJBLyfvFz
   55uaRI7qKzprcTDoRez7RE4HbdQGzRAAflgRVasg+QhOYa34tOsR9LHYn
   G8jxqDf9dPju7ZTJsKxeEfnjItZtp3iLn9r3cQV32eksJ7ZMZGUk0KtUS
   QuN/kbHaMsu+05nfRAPPntMz17kh1fgCc/YoGko4uhhzcDUf2BLhR49LQ
   w==;
X-CSE-ConnectionGUID: w39U+JjARvWXNUtSe5b8eQ==
X-CSE-MsgGUID: VU1Z+iwBRVSP4TjPUEm2PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="87587573"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="87587573"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:03:51 -0700
X-CSE-ConnectionGUID: MSITso4DSTyIyW4mmq8MTA==
X-CSE-MsgGUID: ISCsgaCJSwCv8FFwW6F0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="233620050"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:03:51 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/zone_device: Do not touch device folio after calling ->folio_free()
Date: Fri, 10 Apr 2026 16:03:46 -0700
Message-Id: <20260410230346.4009855-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sbcd49qib47oe975aehb85hwzt6fd6xn
X-Rspamd-Queue-Id: 1348CC0007
X-Rspam-User: 
X-HE-Tag: 1775862232-608932
X-HE-Meta: U2FsdGVkX18sEPnu7axeLDagMoSbULfCkKXkEnNPEgMLv000ZHzNdocAvtd1/3QmraKfB5AkhO6qE+dH2+bdH0d25Kvakemk8FSY3QBITxNt8vK/QBy3Q11kYUds/bFogzfOMZYohR9JMesF3M901ejDC3a4SfucWx4BSKQi9En6geVApXSCThUcFo4ruPJEGhc8P0aA8Ka/LfvNHIKoggOhW30ZIAIpG7PasbDfdvAD3rKHKmfZKalt2eRVGOARMD+kkDYo4Wantlpf9yJvo0vRX41AmzBITgpID0Qp9PuKnD53aUvia+bqNabig9yz0JQ2+YiMSZe966QGtziFYGsK3u86+/i5IYrWr5mDJEtLPramr97X5iFD8Tc21mglkvLkJdBSrHqNt193J4lXzyB+dNZeB050CLH088B2zfRPbOoY9JvNBWgiMu9U3UxOI6+YrJG92PrD3CVE5zA8uHFubzWyksa8TC6Qowb3BUI2YR2P2woz4RQAeHj6L33SmKZfUnhldDAmwXF3EF//02kngX9CbZsgbZ9oX8AgIkWzGWkYKEnVc5WMobOp5Y1Jb4k6rNNgQWIN0ig8DLklcXtf1qolzP5pG336Pznle6L6Q8KY5/dnZ5oGyPEijg+vQGbF5npEleRY1BD6c1mPSzJWkgwjWVz7+10UNIXnNEt7vQDspb3c48ZfL/WHcNF/W6QatDQosoNltyT1Nu3/k3ZUIspsAp4PrpLUKxN9re3Iil8z6nkyo39wUhakbo8h/YkgljXOUrX2ulnKNRtBpHUkeLCJ8+OQMIM9y0FInJADqX9JOpvGta8X1hG77wehu0ShEAWsTt72lcgAs7Vp6Ug1qyFtRgqhi/AyNmDVLlZp67t6oaV0rgV6hS4vXCIz0e7aq5foSPhjWhJgQP0b6Z1zaGSBkwM9qjlAB2tKWSZ1T9vOS8GRbviMqfYDuvM4RCvQIu0aEaxoUv/ubvF
 kyW/ZT56
 r6nkR2qMqcB/kIYWcuRr9cAP+2j4imzpv5b7SORA2H8dSmaBmwrNuqnzUjV7bekrPmJ5Vh+N5kbRGLVjgqRmnGTE3i+GH7YrlYcXiMuxyJmsXV/jWd1WaYF1hrIllNt3cBAPe0SeEJ5BoIjhnP75vFdpvi+bT+h992d+rflV4dzzQZt9M4iQwVKZu6Zy5+RaTsgLtFs9cDfhDY1QEx3wK/TF8GobOciZ6XZu6vlJQC/03HVB5uiGgimCa/wZ1KNppo8Fyu+gV6mLqFgxYza6be/OoEpJ377AR7mPvvR0LYcSAv1C9T6g8IMhD3ThTHQXBQLqZj3giAovKXowjDH+JIb1h+psWmdN1Vv66nEbTdl83YuRRU6cU+lIZVEg2LHalYraC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The contents of a device folio can immediately change after calling
->folio_free(), as the folio may be reallocated by a driver with a
different order. Instead of touching the folio again to extract the
pgmap, use the local stack variable when calling percpu_ref_put_many().

Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>

---
Stack trace:

[  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
[  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
[  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
[  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
[  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
[  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
[  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
[  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
[  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
[  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
[  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
[  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
[  632.400919] PKRU: 55555554
[  632.403605] Call Trace:
[  632.406039]  <TASK>
[  632.408131]  do_swap_page+0x146d/0x18c0
[  632.411938]  ? __pte_offset_map+0x3e/0x190
[  632.415994]  __handle_mm_fault+0x6e8/0x8d0
[  632.420053]  handle_mm_fault+0xbf/0x250
[  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
[  632.428256]  do_user_addr_fault+0x168/0x690
[  632.432399]  exc_page_fault+0x74/0x200
[  632.436117]  asm_exc_page_fault+0x26/0x30
[  632.440092] RIP: 0033:0x5587554ff70d
[  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
[  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
[  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
[  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
[  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
[  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
[  632.502547]  </TASK>
---
 mm/memremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index ac7be07e3361..053842d45cb1 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
 		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
 			break;
 		pgmap->ops->folio_free(folio);
-		percpu_ref_put_many(&folio->pgmap->ref, nr);
+		percpu_ref_put_many(&pgmap->ref, nr);
 		break;
 
 	case MEMORY_DEVICE_GENERIC:
-- 
2.34.1


