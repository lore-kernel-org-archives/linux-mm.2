Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BEACD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 06:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD1C6B0005; Wed, 17 Jun 2026 02:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DC86B0088; Wed, 17 Jun 2026 02:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3746E6B008A; Wed, 17 Jun 2026 02:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 073566B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:45:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CA761C1D81
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:45:44 +0000 (UTC)
X-FDA: 84888469008.10.E47F94E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46C10C0004
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:45:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781678742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=eajvXvr50g1H4LNxkW5m8CPKkkeKdI+ZUSd61mKjtw4=;
	b=GW883L7p3UKr/Uta7RLn4wAFEi4J8obuYkb6adSh50vpb5D9WqrFG18GhjY3Dw852d8XG4
	kY46IDP/UwK7ND/NhV7/XqwVU8B/Puzi04+2vlQerZRg9h+7ClgUybCp2DjJ6wAFACKILu
	pEhgGHSB1ierLFG4AFQVkh2uw8OaU7Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of pengyu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=pengyu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781678742;
	b=kydsJlb5GvrDOn7g/eQauZ69P1XZl+BSBBHwVlSc3E1arUdOY0Aqmhc24kCmyOQSlgrqOC
	nEjvlp1lrPMotpTKEDwGWXpYhS8VieI0ncam6/XkAYSA8Vr8KvyphsOKp9MOPFsdJP7Emb
	V8QwCY5GbMjHNneULe9PoHQwbIjx9Tk=
X-UUID: 2398b8fc6a1811f1aa26b74ffac11d73-20260617
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:cb92b188-edee-4008-960f-da707e1a66de,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:ee5f5aae7fb843cb12b433e46f0a2182,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2398b8fc6a1811f1aa26b74ffac11d73-20260617
Received: from localhost [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <pengyu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1400977214; Wed, 17 Jun 2026 14:45:33 +0800
From: Yu Peng <pengyu@kylinos.cn>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC] arm64: early_ioremap fails to map ACPI MADT on 64K pages
Date: Wed, 17 Jun 2026 14:01:10 +0800
Message-Id: <20260617060110.2846851-1-pengyu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46C10C0004
X-Stat-Signature: o88ixzcmkugxqk7wqsyhmirfam1kkfrx
X-Rspam-User: 
X-HE-Tag: 1781678740-945580
X-HE-Meta: U2FsdGVkX18uGDnfVtooPuYlW8Yjevht5oh5hEBDp4GGxSF/CuJEphkapZyth4PYFQPlu9D/a6D4l2CNPsBZBkJ3pt5yE3mUT2gmNkTksl5DjfawDyPF7mwVB8D4UC5+t9Ct7yDpEGGbiOXBUIlT+kBfgBP7igrmBpaZ/H8eqLHLruNASqNLByODtzQNVyUejyRRSFbFOlspsBewZKv28Xt3tI8doWb/ypRrFNWFZSZjoRic9qSElRVsF52WUkNYfUMTh2gCYPdFIu5jiFo/b1NEpBGrh2S5ig0mQK8Kkhn8wWDs+xhYlTvdiQFuxSSMV7WqtYRcaBChy4hFyOYOsNh5Ovf2RwUZ2h+j25RodKx2se9d/wqPhme2TMegWZHYQET0SHPTlt6vV9jODDUucvR/8ZKAxlaobOejcd+7u60asnuv7UitaIWVliQRVc0qNm0T1dV9kHdZTi0dI2ebHtUYqIt/buuJchkNOWBh3CDEVc6HNS/Olg3UckBzL4j/JTckI4Yj8Yph60fatVA6UhXTVVJjJt3ygeVPB/mxPL9Yac0l7i39tA8flt1OysHts+KmzpSFnBlRNepw7zm8oIZXPybmatsvtdb8cWGzyDpGkx4DiUZN5AMNIqaPyJo9xmzvkpikPWdECzfrY8gue94CnEWnPvk7Tm62JHPq2e0X2QDAMEoP0RPfeDNUzcxUWk/hJXuvtxrK6lLJtvGNqq04O3ltAtbeCCulfYEJ9QnKbXzeJ24ZCodvrn7sSVsfyvoVjeHuFvZ8SZYiaDikH8hGQjHnmn8gjIxkK3hKAD22gt5eZgVt8hd1fDaMNBMXaErifJhssoTeQGg6IUwFNye1vR0l/l35bZx34Jq98BjUpS4H3sIHfK3ZS2u4g8rYwCIEOXPtOGGd8bU9+mZ08iN6h7UzJeqHQcb7n2RNwvvhRjRkQDWn62CC3jlm1e9VZOvM+NwG5JpKDuYSiYQ
 j8ftj6jZ
 MZiO4VSMv9VFMa3lJGJV9DxKf+CEY/mmTA33aFu79x8vOo8XGKqInJrUwyKz40z3RbS4j7uEkkMAOqNY8Jo1gHOCnGQG5e2mx7iQo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,=0D
=0D
I hit an early boot failure on an arm64 system built with 64K pages while=0D
parsing the ACPI MADT.=0D
=0D
The failing system reports:=0D
=0D
  PAGE_SIZE: 64K=0D
  MADT physical address: 0x5a7ae018=0D
  MADT length: 0x32094=0D
=0D
The failure happens when acpi_table_parse_madt() calls into early_memremap(=
)=0D
via __acpi_map_table(). The MADT itself is smaller than 256K, but its=0D
placement causes the early mapping to require 5 64K pages:=0D
=0D
  offset within 64K page =3D 0x5a7ae018 & 0xffff =3D 0xe018=0D
  mapped range           =3D PAGE_ALIGN(0xe018 + 0x32094)=0D
                         =3D PAGE_ALIGN(0x400ac)=0D
                         =3D 0x50000=0D
  nrpages                =3D 0x50000 / 0x10000 =3D 5=0D
=0D
On arm64, NR_FIX_BTMAPS is currently derived from a 256K per-slot budget:=0D
=0D
  #define NR_FIX_BTMAPS        (SZ_256K / PAGE_SIZE)=0D
=0D
So for 64K pages, NR_FIX_BTMAPS is 4. The mapping therefore fails the=0D
early_ioremap() check:=0D
=0D
  if (WARN_ON(nrpages > NR_FIX_BTMAPS))=0D
          return NULL;=0D
=0D
After that, MADT parsing fails and the boot continues with symptoms such as=
:=0D
=0D
  ACPI: APIC not present=0D
  missing boot CPU MPIDR, not enabling secondaries=0D
  Kernel panic - not syncing: No interrupt controller found.=0D
=0D
A firmware change can avoid this by placing MADT so that:=0D
=0D
  (madt_phys & 0xffff) + madt_length <=3D SZ_256K=0D
=0D
However, I do not think ACPI requires such placement, so this looks like a=
=0D
kernel-side robustness issue as well, especially on large arm64 systems whe=
re=0D
MADT can grow with CPU topology.=0D
=0D
One possible kernel-side change is to increase the boot-time mapping budget=
 for=0D
CONFIG_ARM64_64K_PAGES, for example using a 512K per-slot budget only in th=
at=0D
configuration. I do not think this should be applied unconditionally to all=
=0D
page sizes, since the arm64 early fixmap code expects the boot-ioremap rang=
e=0D
to stay within one PMD.=0D
=0D
Has anyone seen similar failures on arm64 64K systems?=0D
=0D
Would maintainers prefer treating this as a firmware layout issue, or would=
=0D
increasing the early_ioremap budget for 64K pages be acceptable?=0D
=0D
Thanks,=0D
Yu Peng=0D

