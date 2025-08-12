Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2309CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4754D8E013D; Tue, 12 Aug 2025 09:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44CEE8E00E5; Tue, 12 Aug 2025 09:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CAF8E013D; Tue, 12 Aug 2025 09:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2585E8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:31:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B76A411351C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:34 +0000 (UTC)
X-FDA: 83768192508.28.D785F3A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7F178180006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:31:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N3t2UaKe;
	spf=pass (imf16.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaXh7Xddpcfv0yQ5STl7x2etaL4f9n7dStroyuuwHaY=;
	b=ZYs8+0xWO3cifW2mVc/76F9CetWWvgXnSfhpvhBcxly9z//0TJDZQvzPVpJRSUKsU5VuDN
	fhwEgSTrhlAZuKmx43zRmNUyx27D9Z8rfpNlOVWsLKihis0+0aMLU7poXQG+0ZLuMTY36M
	Bft6G/0x4Yj57eBvw0S+YpXhN1LlNV4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N3t2UaKe;
	spf=pass (imf16.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005492; a=rsa-sha256;
	cv=none;
	b=SmplFmNzmMGXXtXdfLhMYxsrfi73iIB+Kytpd1zwkr4luykSEKMSZEsqdaC9sGFF0RbPyI
	RF3Ro4f2+nve3DAOKedy11OJLmIFCALnCx2/W+4zCYAhMR+HKUfv+MFmCWCAYm49jtSokq
	DAgYSeqFMsQuBk4+bie8p7L1RuaOe7M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005493; x=1786541493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=okYAGWwGwYjZD7NZd1rejvGMvVZcH4Qcm5xKkCEr0jA=;
  b=N3t2UaKeggDZWfhQEF/4UjZ8KJF2ueIh0xb15qjiRYSXbYcUB9GmqftN
   KV2mkph8gXJ2cGCLiX/18eJc0v48uQmF5P7YO4vfqZo/CFzNRxAvTSTiN
   LB8bv9RRafDVPUSqdy6ZzlUugRcidjNZ37fgNnmOws9K3FD1UlZTQotZE
   yL1v28RXm1B8QE5/6Y+s7Y0DG2OwdS82XhpdtdPOqGZGHDnpsNCSxY43X
   BLEDZ2gia5cIU1kQrnDF40PcgKmZS8jDITTI2yvgm/7GlnHZBO4xJgZwN
   4lEkkuRLdYOk9FIdwVe73vJ6MG6TgzbpJWUws2xfgOl9u413Enslblv7+
   Q==;
X-CSE-ConnectionGUID: QGtnInCMTeSyHYoPvSavUw==
X-CSE-MsgGUID: mmD+YjvpQHW63wUqCSu0gg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60904151"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60904151"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:31:32 -0700
X-CSE-ConnectionGUID: +neUmvM8S5Otg3Vc0KnEog==
X-CSE-MsgGUID: oyi06oYNTk2MyPzECSScWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165832138"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:31:09 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 17/18] mm: Unpoison vms[area] addresses with a common tag
Date: Tue, 12 Aug 2025 15:23:53 +0200
Message-ID: <fd65b0ec35f52c6bc714ff333241b828ff74604d.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F178180006
X-Rspam-User: 
X-Stat-Signature: kznb7z3dmssma1r3dsk1miii88mbsfzy
X-Rspamd-Server: rspam09
X-HE-Tag: 1755005492-177342
X-HE-Meta: U2FsdGVkX18KTJ9rD5wQ1ZCvpv+zTbzsnYejiH78GIERflgqWbU1jW+qYcYCrZd1UpnfwRSlaer9kttpbhkJW6etM7n/5/MeQZffyu0U966nmkkkfHHOvpixxC0ufmOstpnwl97STifnfxBNS+IhXYyFZYQh4andZgQcZXvGSWaRXU8PfRJ5CfkF/eCfoBb2woCG0jIx2V+zjbEB2UA8XMKsDPmDbLrUfhrFcxW7HfktyMXdAH3wujL6eGKXODb6PDFrddIiKCjcYS/XxzWHHXs6KvUqCifJymYn/8ZtJZamLHeK3IFXt6VVr5kCTmRMO1+4BJp7IVQKZ2tOdbfElGbrRIyLVFcdKMX8J23SgChwUsTcgtsBMZsLD+7VG3xhQJ7pfA67t+seSRuogllzwbhsUrM49oI4E1m1yTc83Trpw8b2+W8chRufXRkcJkDzFK7vM5F7wQ4MfeUEYzQzIYdXXjbfAIbr30rpZGIRJM8IQ6Li5gKbk8gQDYUD779gMbvQSXB1SMm/knStbiQjYdOrAWzX1R9Y4r9jmQL7fN1zIubi+0YZFm0UMG+KuWpcFtsAeXyPqDYGd6RS/BvXoJjut5tmgZrLQT5fSpXtqV9LIn038bERa8CDQw1tv9mFDdpKJgja2SLQMNSugvOjAC+kIX2VHkEgsMO3UE+7DNhGnBgMdjr5uKFb8VVPFEihYDqj0VAMDe4VKUDuByVe2PJ2t7SAHnnMs5kebdhfLR28zYFtQLBqhEEbe7YNms07tEMeKk9Xd/+TFglFB2hD6Mva0lL9OXC1mGEsOSVa/qxV4To301otvx0ZaTUKjmN+R1dAohl6djgQefSdeMpwr2GHq+/6F+5/UWWSZjwB1xcBZoDxAQG0p4o+uL9ou9Vrjh1eLyyIUEYmIkrv8xfCy+opP2zIxV179mKJb/t3WiMQT8a1aKhNZaaCqYlRQzPsRtdpecEw0v3drDQ3eWI
 YzmlO4EO
 2ntFJH0z/731k2dlLilXZc8YlAyfXjJGSWTf7EQkqUUam8/OwDJSfPEGv0b9ymoTfJJIhcCtu7SFIGvmq60JOxUNIMhHr5WWcuUgMICdI8MisQqvd9YEOS/WL1hITu3dCn2RkaDdpY86Y6Iq6RHwoH0yVuwzw0z7SouMIYkgfotH1uLdlJnbVXgTpQMEYy7nFDMR4NbbSotXwkK+6dUWPe/LV9Zz0ubSP45XtoZUP14DH/OAuUd7CAk3kw5CwAq5qSZU5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The problem presented here is related to NUMA systems and tag-based
KASAN mode. It can be explained in the following points:

	1. There can be more than one virtual memory chunk.
	2. Chunk's base address has a tag.
	3. The base address points at the first chunk and thus inherits
	   the tag of the first chunk.
	4. The subsequent chunks will be accessed with the tag from the
	   first chunk.
	5. Thus, the subsequent chunks need to have their tag set to
	   match that of the first chunk.

Unpoison all vms[]->addr memory and pointers with the same tag to
resolve the mismatch.

Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
---
Changelog v4:
- Move tagging the vms[]->addr to this new patch and leave refactoring
  there.
- Comment the fix to provide some context.

 mm/kasan/shadow.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index b41f74d68916..ee2488371784 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -646,13 +646,21 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
+/*
+ * A tag mismatch happens when calculating per-cpu chunk addresses, because
+ * they all inherit the tag from vms[0]->addr, even when nr_vms is bigger
+ * than 1. This is a problem because all the vms[]->addr come from separate
+ * allocations and have different tags so while the calculated address is
+ * correct the tag isn't.
+ */
 void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
 {
 	int area;
 
 	for (area = 0 ; area < nr_vms ; area++) {
 		kasan_poison(vms[area]->addr, vms[area]->size,
-			     arch_kasan_get_tag(vms[area]->addr), false);
+			     arch_kasan_get_tag(vms[0]->addr), false);
+		arch_kasan_set_tag(vms[area]->addr, arch_kasan_get_tag(vms[0]->addr));
 	}
 }
 
-- 
2.50.1


