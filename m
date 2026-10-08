Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D79CA6012
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 19:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 474306B008C; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402426B0095; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBA36B0092; Thu,  8 Oct 2026 15:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 02BFB6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:08:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8D3F12039B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:08:34 +0000 (UTC)
X-FDA: 85300395348.08.5988742
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A056100003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 19:08:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KJ0tBaQI;
	spf=pass (imf05.hostedemail.com: domain of 3LurHagkKCH8wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3LurHagkKCH8wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791486513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lziypnwRraIlsorF0VwfpRYSW789AnxqR1Fmirni4Xo=;
	b=XYhXLgXS5fArJzPRS1znA8p4PPbMVdFxOHhMXhBQSOTdBDPdfqx1zR20IFRRlPZ2dRirLD
	U7HnBqxFGSAzKRoEcnxSiDxz8eTnIuzDwVRYypcXPUqHJPakCdRYD2i35tlardbRviSkSg
	8yVCgTFeGjd6JcaqNPqiTxGS6fQ0uJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791486513;
	b=WMC39axxCFiKlro5y/QAEpW4ptFyezIO9T5r88o+wJyOpmRYhqbDA6XlEeru/7Ggu/oahG
	yz0Mfa8Ja41euLlAp8XXf0fGV8HdhB1++20RD077xQ2j0BCGF+qytSqVezexGAe/YADfnA
	b8i78z/sLEkXoE4r0Fod45vJCiS6RDY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KJ0tBaQI;
	spf=pass (imf05.hostedemail.com: domain of 3LurHagkKCH8wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3LurHagkKCH8wduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6afbee3d268so5574015a12.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 12:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791486512; x=1792091312; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lziypnwRraIlsorF0VwfpRYSW789AnxqR1Fmirni4Xo=;
        b=KJ0tBaQIXuQcDGsFto2VnIXiaoMA3IciycS2sDPpZxWEoppYErbX7f2kzMMi2kgnDx
         ERM4nuxGN7FMSiS5emjgGHcRfv6jxYOV1Bhx9mD5OnPz+AiGPklWKvyG8gP07BWf0C75
         4307kpao6xF67wttU6y2SJdZ2Aa/mq/XAObimEz2XWjSt0P1GyzWqNnOdSutvNDdLTL5
         qOv7gWphLN0WbWR01Ho1O0Xy06GqBFIxfr98Acn9CeDolmL+LA1jM7/FvKXvIfmnSIOt
         RCOOzfwsOmDbLQbPW5kLk61qxegHQdSy7lxtA78/odcn6GvxKb2iabugiabAn+G4vB3p
         LR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791486512; x=1792091312;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lziypnwRraIlsorF0VwfpRYSW789AnxqR1Fmirni4Xo=;
        b=G5OBj3vxU2W9mWWossM4uOST9ZQ3d4kqlTzR8Fv/nqAb05DGLGpZgOPN2ykRqMUGK8
         W4FDE0aKlgVX2mDcn6HJv7qnzRqxn37TRXiW3m20JwXgGLxEd3yt9XSZrOdrrHTlpZjf
         cIrcQ+HJZlBQztMIxMS1qJh8DTmLLyVlXngOztPBHHcmjuHlLjgH23amkOLa75w6UW5n
         YPiF0wyY57whAn1rH6OfJKPrXlxoOWc/vcl46TfbT/YkXWX3UhBT1ceZo8F2pem+AotK
         /oEtpQ6emKItzZmZ4I3Vn5K7dljltKo0I6HTkFLUO8acDPwqpg+aqGm4hLPkzsyoGJvB
         ZtxQ==
X-Forwarded-Encrypted: i=1; AKwUvBwaoIhz+nJyyeyr5AWyHe4Zt4KC9beqGWidXvoWwUR0CZUergYreL8nxrboAZotGPRPj8bGfKt//g==@kvack.org
X-Gm-Message-State: AFq9FYJYieM0dx2RBmrzGkjMmpD68qM05ANTn791v61KT30f1uymBI7A
	84MQptCc8hc5yLrXatIBM30mJr9C6y29D9Bqrol3lf9/pjOFYynGx3WSdv0Ip0d/z9Z3V3BCabw
	I0UlmGyvYL67WlVzTEQ==
X-Received: from edl6-n2.prod.google.com ([2002:a05:6402:4246:20b0:6aa:e587:e1c1])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3211:b0:6aa:edb3:d687 with SMTP id 4fb4d7f45d1cf-6aff38f1e95mr6238564a12.15.1791486510254;
 Thu, 08 Oct 2026 12:08:30 -0700 (PDT)
Date: Thu,  8 Oct 2026 19:08:27 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261008190828.3221718-1-tarunsahu@google.com>
Subject: [PATCH v4 1/2] memblock: drop for_each_memblock_type() and open code
 its users
From: Tarun Sahu <tarunsahu@google.com>
To: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A056100003
X-Stat-Signature: xytbbifudr8edoyjz1aa3dmdp4d669wd
X-HE-Tag: 1791486513-767878
X-HE-Meta: U2FsdGVkX19L+boIzlOTWiyrP5zmxmKN45b4F6pLCzj/+hun7Mo2EEOxUk2k4Qde0SnCnUrV5LeNGRozOvg9LVIaNMXVIjVMSWpCzRAF/GlAwI0A68sU2xN9NpPiTnJEfjbO46azozwuZdf7eaAU0cI8yytJQgMUTxWBtgik1TSlx+AHoUvxziJpc0bZd/IrgTCsnHP2MzI1uSFdrkHeh24mPCjce/pdDFck99Hgywfogp0sPGvX9nAtxJUQose1bI6UPaooXaeo/Zm4BwNjPNTg/Y0++3L5dvpF2JFD72ETwVPmyILAwoeyeC9Uv4y4vv0V8+FenCLfkSecMxkvNFX8Lv5ArRIcZWQ1M24BsZuk7a1GQjGYSuKBZdoias2AG7e6X1f2YZ6gsl1iLI5pKbeEjGykK3pf6UdYlePYHlx1JCkHw/OSoyUFsBmQT+VluyX2rPC4lyhdRugWHBksWVX5TFras0jLg0bK3uXCk6De2W7uFT56Rpy+DT7rxusYMMsNp4FAuoyciT2nReb9V+bG3pCOX9SaSPEeJ6UDaG0P53U6uYvt+bAYpwU6w+94qFvnESxGeU249z/TflUtQGdZxYQM74GQ1DY94MnOP/PQ8RRHFMIliQBgIkJWoP+rupb7YpmXuWD9PQzLuUi+Fy7tgyoTMBw9lx+q1TiW3lU2vdYkHT06Pd0a3xHVwzrlUIyTp4u8PJ8hHQnU3Z+hnd4ei5vLcq4rZ/1rym9hCkK2hSdbCjVYzp0cN4rKuCDtyPENuw0PnvLnAFWdMzLOPLzWWBechBUFf68ZY5XevdQN5x4VpAp3wtEfJ3p40Wp9mcZWRELtsBry0zA76aXEpnEFsANi4KkRgCmUyt6e8PrlxczqFhs23EG+Fw0iHF6xtIiLlwjYCf7easZjFqfwfTVpCoIBFCpqyJsoh6Qxux96cN1aahwvTN24K0IX82mh4k8FVB+eeUISsS6kT2Y
 0JbVGZ93
 7/C/j6N7dN9bP+NMUxw1/tStkNM80momC6Jys/PW9gWFrPJFHRjuu2nyJbcWrAL+RfCvhLAOw1i33Hr6IFwPFJP85Bq0bJXmfE7obMIocpOiPq1WgM2g9+kHDHx7ZUxTDuuoEMqZkU5WQt4Fga1Tj2wPFpxsjuk3Gu7LNBTNDIv/jC/Pwu99SjSxfYhBsFo0efDhmbi87z00x/qpMxtBlteS6h+4xBR86r5E+gA//h+XsdQUeAJsS094va9L3q2bLk6AQLLUK024pbMgIjoF6QYFnUL/dmcRoZgQ0eBjnTmVTT8cc3fpdcb3LnckmfYWJq5k+owKWI7agwubmKNxH6vf78jAc+CiwONovbEWjF9hrkcCGlbt/orbXaoNdetx76HVTEqDR1R3EFYbXupRhTDk7InnjqAjC9zb0gWYAe4ocUAbbqJRkcLv3ybLCJh9tsrsOfi6e4VfuUBPnWKkz7VUorCqJjtYPLPRGnN54lVLbg5DZb4tvLUijUp6BpNSXuhBFH0dFLd7tng8DYrlj13MknD1vO7ysdhbv1PxdFNAnY7F4jWJ/2K00hAqutchir6vwUQubtgThaGv//AKPt5IRPAR9pibC38gFzYdXfoMCDtafw9PlxYi7NPv1bnmb4izS5CWQchNE1abPJlW/x19RWP5CTVHguZ+WmJGVHHovwLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

for_each_memblock_type() always starts the iteration at index 0 and its
body is a trivial 'for' loop, so it hides very little. It also gets in
the way of iterating from an arbitrary index, which the next patch
needs.

Remove the macro and open code its three users: memblock_add_range(),
memblock_isolate_range() and memblock_dump(). While at it, move the
region pointer into the loop body scope.

No functional change.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 mm/memblock.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index f5aaa38cfa31..59dda7d085f3 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -155,11 +155,6 @@ struct memblock_type physmem = {
  */
 static __refdata struct memblock_type *memblock_memory = &memblock.memory;
 
-#define for_each_memblock_type(i, memblock_type, rgn)			\
-	for (i = 0, rgn = &memblock_type->regions[0];			\
-	     i < memblock_type->cnt;					\
-	     i++, rgn = &memblock_type->regions[i])
-
 #define memblock_dbg(fmt, ...)						\
 	do {								\
 		if (memblock_debug)					\
@@ -615,7 +610,6 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	phys_addr_t obase = base;
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int idx, nr_new, start_rgn = -1, end_rgn;
-	struct memblock_region *rgn;
 
 	if (!size)
 		return 0;
@@ -651,7 +645,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	base = obase;
 	nr_new = 0;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -815,7 +810,6 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 {
 	phys_addr_t end = base + memblock_cap_size(base, &size);
 	int idx;
-	struct memblock_region *rgn;
 
 	*start_rgn = *end_rgn = 0;
 
@@ -827,7 +821,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -2194,11 +2189,11 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
 	phys_addr_t base, end, size;
 	enum memblock_flags flags;
 	int idx;
-	struct memblock_region *rgn;
 
 	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
 
-	for_each_memblock_type(idx, type, rgn) {
+	for (idx = 0; idx < type->cnt; idx++) {
+		struct memblock_region *rgn = &type->regions[idx];
 		char nid_buf[32] = "";
 
 		base = rgn->base;
-- 
2.56.0.385.gd3acb90ef8-goog


