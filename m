Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A360C8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 20:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F4D8E007E; Mon, 25 Aug 2025 16:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FA68E0038; Mon, 25 Aug 2025 16:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917A18E007E; Mon, 25 Aug 2025 16:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3BC8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:31:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 247961404FB
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:56 +0000 (UTC)
X-FDA: 83816426232.30.322AF5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE270C000F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 20:31:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSK24H0W;
	spf=pass (imf28.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756153914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UaXh7Xddpcfv0yQ5STl7x2etaL4f9n7dStroyuuwHaY=;
	b=X9eeiiqfc3Fqopv8yXyZktIdLl3Dmj2ytEE/fXf7Eo4bh6QUEHbkIPEZisKH3yYcTEIFlW
	rOIHsfBVhukxAZZ8qiVKUcQq45PcBm6ECCj2gKQh9sUFdkGL8qQ0oHKrRCafJxsasPxV9m
	++QmNBvnj2r/twx6Eutqb1bCvhTw73w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756153914; a=rsa-sha256;
	cv=none;
	b=uwwr5Fsr14JtwVsfQFeYwC6ZJuCXpkKbcxdd6cYPwqYtTOh8kkHNivL63/IyWQrsOD5tbL
	8z4DmZ4uf/AxQ31G3xp4kQEUBSgDcQzdLVpQbjDNNLq9F10S1FuHlP7t4Qmy961mPnKOZY
	xEYM6XnKGJW34FCoNLUNfwQAqKC4v5M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SSK24H0W;
	spf=pass (imf28.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756153914; x=1787689914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=okYAGWwGwYjZD7NZd1rejvGMvVZcH4Qcm5xKkCEr0jA=;
  b=SSK24H0WF/G2+JdXdQY4oeyOl/y/TZtH0Eu16uZasKkfdJ6Yhf7yGToC
   cIRSHpqksh6A2xwROUpQ6HizLfwub8lASUHp1prS8e0C1/y8Qxr6q3f1/
   G8YOoFgLmLg29+KakkbIAXRfBLQ0iIgqIoK474+HTzhppGnK/iM6bcKtQ
   TfdcPEROwj7tI/Fox7sPPFodJlB/sRISIocNpB0gfJi1RFaUhWHUueIaK
   2EW1OcLoQF+FPOLmo7Xsk2OAWujCnnLFxWd2mxW3CfuRL26o+E47ihahJ
   HrH3yRZJx4tmvJORbS5uM8tYTP3sjWdNgeWXxhTAC7TFO941TxFXngcR+
   A==;
X-CSE-ConnectionGUID: Atp3NadIRHedwQWGCOxrDw==
X-CSE-MsgGUID: Jr+b+s4VQVq/M3zhtvBNZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="68971217"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="68971217"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:31:52 -0700
X-CSE-ConnectionGUID: Z6d3VSXbRamxE0DAKuvOBg==
X-CSE-MsgGUID: HqbNGGRlQTeuW6G+Ue7lgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169781025"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.6])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 13:31:30 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: sohil.mehta@intel.com,
	baohua@kernel.org,
	david@redhat.com,
	kbingham@kernel.org,
	weixugc@google.com,
	Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com,
	kas@kernel.org,
	mark.rutland@arm.com,
	trintaeoitogc@gmail.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	joey.gouly@arm.com,
	samitolvanen@google.com,
	joel.granados@kernel.org,
	graf@amazon.com,
	vincenzo.frascino@arm.com,
	kees@kernel.org,
	ardb@kernel.org,
	thiago.bauermann@linaro.org,
	glider@google.com,
	thuth@redhat.com,
	kuan-ying.lee@canonical.com,
	pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com,
	vbabka@suse.cz,
	kaleshsingh@google.com,
	justinstitt@google.com,
	catalin.marinas@arm.com,
	alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com,
	dave.hansen@linux.intel.com,
	corbet@lwn.net,
	xin@zytor.com,
	dvyukov@google.com,
	tglx@linutronix.de,
	scott@os.amperecomputing.com,
	jason.andryuk@amd.com,
	morbo@google.com,
	nathan@kernel.org,
	lorenzo.stoakes@oracle.com,
	mingo@redhat.com,
	brgerst@gmail.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	luto@kernel.org,
	jgross@suse.com,
	jpoimboe@kernel.org,
	urezki@gmail.com,
	mhocko@suse.com,
	ada.coupriediaz@arm.com,
	hpa@zytor.com,
	maciej.wieczor-retman@intel.com,
	leitao@debian.org,
	peterz@infradead.org,
	wangkefeng.wang@huawei.com,
	surenb@google.com,
	ziy@nvidia.com,
	smostafa@google.com,
	ryabinin.a.a@gmail.com,
	ubizjak@gmail.com,
	jbohac@suse.cz,
	broonie@kernel.org,
	akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com,
	rppt@kernel.org,
	pcc@google.com,
	jan.kiszka@siemens.com,
	nicolas.schier@linux.dev,
	will@kernel.org,
	andreyknvl@gmail.com,
	jhubbard@nvidia.com,
	bp@alien8.de
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v5 18/19] mm: Unpoison vms[area] addresses with a common tag
Date: Mon, 25 Aug 2025 22:24:43 +0200
Message-ID: <3339d11e69c9127108fe8ef80a069b7b3bb07175.1756151769.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE270C000F
X-Stat-Signature: x14afuzs5miwz7z7qyj6fy1c9b8t7wf3
X-Rspam-User: 
X-HE-Tag: 1756153913-118733
X-HE-Meta: U2FsdGVkX1/R/E7dz/TuC0ZZB6xyN9zsJbXkRzIku27viGuNVk12KsNbtGotAdSpi0pHf0uT49b8Eue0nAuC+c3toD4nHdmZdZwTTgbTH475+KxO6AVZyBMxDDqreUJpxq3W8VJLXs74YpDjQcm3g7yC3f497nIwRYQVpaEmpOtnRZMYO5sBcUsBr/yiDsaAVvQ7LTNKwqCsT4CnHwsdfAnb9gbumeLIfwhSd38oqDny7mqOLl73rlbWa8CC+9zxpsGJc5LiixChByyTZ+9t7KHN9SfnJ4pznlXp3prFwD30MyMw7SQE1LdlICoT555fHFciCOeiBBYMRzbxUZq36YPiswyienp356uPH3RU2UiuNDUDWbgl1fxZW2CBn57REbzfOMQglVKSGOSiNbEADudPQZ02Fcy5sSk/4XZFwvVZMediqSfysWi0ngqRD/Z+IYfJqCrY1bq8+ZLOSrRIp3v3NQH5HX7Gh/tzwyVwYmVXgHmqvzGkWSPCubOma1GyIQwZdjbCaYrQCu+jUBb9Js9+Ipny+BBGC66Y1qFmd2MkvYOs0SfYH0gDgvQRFd/DATPXKlJLKJcXQ/w3+CtqZjvW+DqaRCc6H05cLpYIOU8t5ALQz/0CZQ3e2ImxHIfdGlKbNoLUJmGwat2RcQlOEaQwl8ikJB/ZiXi4qtLRA/VJ+I4PimsS8l47S6wWj8xPmsBr1gWNg7QBTx3LYkAlGcqYT0NDCRBtRCM7VWRv5PMmtUfIW+/Y/dx6YOMRYxvop0Y36uZYct0gSjyf0sgrh3eYvxiMegvq7FOQ9nD5oIaJpYZlND0rtfFFlHtoPN1L2qNUYQnNBrO/MRrjRW2qVh4Dr9Sk8JFLkeRIQnjX+WDtkZaOHd6emSmcNstaa4+PTDrzXhaT+a4HhnxGXc0YWixuV9Eb55sv2NATTFQnAWkvVVuOcmByiPSafcbntKCDFsGm3dVLXdKpj/s79cq
 JxJTHF2O
 5gvp9Cy6PoP9W/mm/QtSgOuctVny9Gxw5v9Q88Pl60i/cP3+I+M3kth1WNoRLqBeFIcHdhNDMTqV83eZVr1ED0Prjo+pSiWtLKKPmoKIgtwcICxZQ1NeDSDZPOeftBGGG8qvh/cv9XOBuU84m4wXqOuuK5ipuRNOBV4/s5pw3UqL0htmqER5S+kLs8B8n0kPJ5eH8lR7D+Ad4p2vwvUAkoptq5V8zK7ApsHI8dOOyVAzGf/G/X0ZNf+cZOXDscy4eLZky
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


