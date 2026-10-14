Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82556CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813DF6B00A0; Wed, 14 Oct 2026 10:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBAC6B00A1; Wed, 14 Oct 2026 10:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701FB6B00A2; Wed, 14 Oct 2026 10:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE696B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC48C120268
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:58:21 +0000 (UTC)
X-FDA: 85321537602.01.B2C2995
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012024.outbound.protection.outlook.com [52.101.53.24])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5F20160002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:58:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="lu1d/jT6";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.53.24 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojtXr+sKXcT01x2Z8aOEOjd5CScB6QrpkJHP+jJ8diA=;
	b=sAbHSRDnLm6Crpk1Ka2XjPLjM47dUS6vccSgEelkUHQFONH6VGwmodtUOzeE89pNqyF6sF
	9fwmDz7EHFTzomN1bqO09gemU6khXH9sS6m62BGNAio6/WBg5aPwDFt+2+1RQg5L7Y5Gtc
	StlKMxi0abpBPY6OcwlKydhwlr+Layo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="lu1d/jT6";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of radhey.shyam.pandey@amd.com designates 52.101.53.24 as permitted sender) smtp.mailfrom=radhey.shyam.pandey@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791989898;
	b=u2Y4kFAKFoeYnF1wuQt+ugbrfL4JEJZZWOgvHZGqs8FmV2+dfNdQILO8kJCP1csAusgWsO
	jHv+63cNlc19e4At66pUMX93T5+sFR6Xfr77eRMbNhpusSaMjquo9mUeQ4LCVtB0olC0lN
	5OdMdh1+BYRX+QzvsdGVE3ZZy0+B21Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5vZldQx4mPECDJ/ZcgLoQ06p+OPisEYtp4BYZQr0tiVSeuMf4MvYIfcOITFNgULWpIurpxjc6ToxkHGfuZEYvxuJszOa6kohSu8t4UIeEQEvelcIhndidx5r0jWKik3MatZRzpV/Y48OD6Z/kBeb+h28ASPThyE/OUw7edV11a48YwSEW4egh3nAEmcAypFDXI+NbWH0kV9FXxLeZSP1QqR0N0w5hcVRjmnJTy9iTK0QojggSpbFC+ZHQXxEZFhkwiHopMVJvPMi8X0SPAddwzIj/eGP9u8hPYtZ9T5uO64mr1W9A1BItwPs8BdhzFSJSi3B0NUR1eHQyLBHM2RCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ojtXr+sKXcT01x2Z8aOEOjd5CScB6QrpkJHP+jJ8diA=;
 b=N/bwBWz16yQ37ZGHTD+GVGNcpJ0U+qC6c6MbmoejCPLjeTeWNnvRonstUmNxAF34SDkRDapRCmb17tZOSiIl7myxv0CInwev1gw4eXu9MDpSUydtC5Qd4vwaDoy+bjsaavEFF/4f9iq//4PJ8Wk0a3cbOXFpRNtnIklAKCWAVuTmeaW9nu0Buy96kvERO9+d4zTfR9vYaTN+Z83WQwF+tkUBjLtblvC4RzDCSiG5kx4r1bcImmwQNnW22dCNP7vUcdRgIQizabbCBu0+y34FGTSNOsflklTUx/I+pAdalyP+frVVPha8X8QzmHDt9L3TtP/zyHRfdUEsz4rxITMo7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojtXr+sKXcT01x2Z8aOEOjd5CScB6QrpkJHP+jJ8diA=;
 b=lu1d/jT6rOCsQOFry+Y6HfrWWP9HMBkkEGeIAiWiDIH+c7OYeRiBrb2ot9eYshBUnazWQ2l+NB5I/6KYgPni1V5l1bVD6ZZomG9DLyR0nxrlSip+sUL69IQWvI/liCJwEi2BYpvX4k8kZlTYdteaHBXtHRXQIlAeLIhzbfPGbpY=
Received: from DS7PR03CA0229.namprd03.prod.outlook.com (2603:10b6:5:3ba::24)
 by PH0PR12MB7487.namprd12.prod.outlook.com (2603:10b6:510:1e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 14:58:12 +0000
Received: from CH3PEPF0002457C.namprd04.prod.outlook.com
 (2603:10b6:5:3ba:cafe::5c) by DS7PR03CA0229.outlook.office365.com
 (2603:10b6:5:3ba::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Wed, 14
 Oct 2026 14:58:11 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH3PEPF0002457C.mail.protection.outlook.com (10.167.252.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Wed, 14 Oct 2026 14:58:11 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 09:57:53 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 09:57:52 -0500
Received: from xhdradheys41.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Wed, 14 Oct 2026 09:57:48 -0500
From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <baoquan.he@linux.dev>,
	<pasha.tatashin@soleen.com>, <pratyush@kernel.org>, <graf@amazon.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<kexec@lists.infradead.org>, Radhey Shyam Pandey
	<radhey.shyam.pandey@amd.com>
Subject: [RFC PATCH 2/2] mm/cma: reject CMA areas that overlap the kernel image
Date: Wed, 14 Oct 2026 20:27:31 +0530
Message-ID: <20261014145731.3431527-3-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
References: <20261014145731.3431527-1-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457C:EE_|PH0PR12MB7487:EE_
X-MS-Office365-Filtering-Correlation-Id: 766d454a-1e3a-4d95-9639-08df2a039103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|82310400026|36860700016|56012099006|11063799006|261009223027099003|22082099003|10067099003|18002099003|6133799003|921020;
X-Microsoft-Antispam-Message-Info:
	XEBTTAH8bwXBqYKRKqrqjE66mewvAsqQesJMmOJ8naP+U7PHVtUFNN2ikW3i10K9aJUu9rfFcNXt1aX4kP6ub1qAVcqcWeCnv6T0Sw22S2RzODpQbwij9jyBdyaACPqaKSU4V+HOvZoFJkwmJFpG8IEll7d1aT2LK/a6rV8k2/j+Ggpmvjsvs+OKOveAkk3hwnGU5WaEIxT+Lr6nPeAbHJFVZ6U8nXrARMsjtdXDbdrxka+MXLgnWRI7fXAQOMs1KdCBsUIOai8pxR+U0GviD5Xx969y/9luxearFhq5F2Tz8ykfct3DnRck/gQ/o6oIBZha9UGFVqaxzAK/wxD2j7KxxQJnaEuk3Ilxh7D1HaSSIaxqSI/BLhxGoN+e49Evx6arIzLaw007fG6JrcA4pc88SaIUd3fniyMHBZVCH+ENUG5/VMO1Zgzm/ZAFFTLb+a2ICEanBsMgQiSjbtk5Vz34gt/w+1s/pwTRp5RvaK2/kV79U+dYG2JkhEAYHTurjHBZqL3eCz58LDCS5iKfRcc0QgVuOerV60pqcmg1x7vgekDchRAtX8A/nTkblQrsoClykefQSyNcI1ofYs+Pu0kgDpZwUgxTXHhoRKAaaZpajtAHPsNXOuUxBRimhJQBXe8mwBXsHh4M/tCGUvro4ul0YEIWAhhDfuIcvTyha+SFod+xWQxWvzpdh8jCbMwnKl+i63ksSfjkikhQoQT6Qg1lMlEG9X0AaEkd9vMHTmyh+p0VmRwZ5v6TYGDm6f1A
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(56012099006)(11063799006)(261009223027099003)(22082099003)(10067099003)(18002099003)(6133799003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mTaermkDno2RdRxKZtV3aErcXAh1H+QcLbCROTQxhts5HOfH9lDk3u5wbI6h/YeF/ijXpaaNt974ID8UX4lIZI7clmi37Y6CnVSH26DF2dLhTykNCLRCXzy+2odvKpvSzgeqbafPilOk0q3j2y4AIoWStFOcOqdENmpFcPJySUL65qYy6giDMwAN3CFoup6BprFsdJxOswUbqKnEu9gZJoqIPFF1GsJjUYpLYLjzGvqMvOSPjjjN/FTSUh2k3Toomq32ip8tGzc7jf7jojLBaKqDM4cax2IqY2qZGjnAmxsFRfKg8GE1RjtGtlSH1jTG3NuGQVAkLJPi1TEs4BChvAZKeGTl/t1+DrzJLda4OEy75KrSpbDo938MYihH0UR0BZAJ9dcjuyj2wVEmSkbt0tOGF6p6AA9pDZncYfZqAO6vkvyyKyhuDs+o8qbpxrNc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 14:58:11.5487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 766d454a-1e3a-4d95-9639-08df2a039103
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7487
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5F20160002
X-Rspam-User: 
X-Stat-Signature: b9k8wrsoansqb8chb3mmhorj9bkodxi1
X-HE-Tag: 1791989898-340470
X-HE-Meta: U2FsdGVkX1+iaNY0Z46IXH4werh7gqStB0FfIwZvjAeW63CP2BWNDKJ7Emup1VFK5SqQMLbY1Jbbh/KZHjNCineb7O3pcZvoA8VJIWsgYn5BcdsE9Fcug+BXnT9ZLDJoOsEH7vuzNR/c63OLPdeevsJy5IaTpcr7tikSSnPYbbfK8ICWDRsttJ/UJlThkieCOtquVp3IT8cYrFHoTKXqDYSC9Vs6RxIr09lgFdB/TXKQn2jg3qL3XonHv1ed5Hjavrdy0JpdQQfFug5R1n0EjGbopxEYDyIsOoszzPiA2UBYOZaVuG2nBTsRDyqDM8CT3ajVn5r//t791jzJ1jO8SfYIm4VY2Bk2r95V0DRhf4sIRz3MKV948y9TnydTPo2p6bSyHtK73HfjwlVfvYiaYKo2LL4oMttiRs1tbrAkVvbeNNPiL7qeN662aoKHe+7r4fvJL/8VhPgDt8t8fYvKYIXTKIOI970fPsKATqevt+GGjuUC/YYnXJmhVw71i+ATeVwFkCmY/JHA4o9JkLYyYlsmpxs2KMZQV9CnVI9s9VmfUxQ9fgx+WaTIlEoRkaLpNrTbcAsNL7AcG/XEpWz7DFuk9Sy+xXTv3jp65IUTmsBnt6eMIDkKgsSOeBLuVnpL21nKKDPtHVfhKBIwQxnZ7wnY4fguHZ+/S/3sRfWt2CrStLEW482ijcRW6dwhPPlFWXZUDWHvCksgBhABfPeUCpkrvPgV7CLMRDaOQvQLW9oVpKeXmJo1+4mz4owcVlKqlO0Sf/K73ei+h5RxpKOkbuAHm7TLXuiSszGEJ7/I5MHZ0JY9WQbTPkzlM9P6j7WJmhE47K2m1mR1LEhe7QoLs/aYVG3Qwv4kTABS2yqtwlPuHweZUGySu/WtpDxLiHzfSm0sue+FEr8PLSBgY3gxy0FJYMqFw3oDvz1vzn10uM3EL2Al2EcYRyUAmLR4cKFZzAyzXdefPTVVkEl91hu
 pSM/QP8A
 T9T57XPbMfZA42NnttuIB5yCvPa8xirzUABO6QgdgmksbKLRulu3sXHFciaMydCx+9DUGcGbTchVjd76w7mY7gaLw5ssMOiTyoIAkD5U7tiO0fCyv9T5aHDISF/0xJ401F9oqiGNedU4P9LwW0dhY+Y37ZPv9eoA6VXluFuBxJ0tRLOTTk7XEDuXLa3dtq/m+fQA9Dvq2l3u8vDQ/7vCCCN+79MsiW9/l6xUhwhLlRyVTEvRMpxAF7I5/TYJPpvpLd7ZTI+OQ0xrFKvN0ldpYIDq2JqgJEyeh6cDlDr9eQLpXHuiCs1bv76zBMdL/WSMS0yGucDbR+wZym5iyVGsN0NYNo7AYTaLyJnS5I0KfgFOH5h8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_init_reserved_mem() takes a base address chosen by its caller and
requires that the range already be reserved. That makes an overlap with
the kernel image indistinguishable from the normal case by looking at
memblock alone, yet such an area is fatal: cma_activate_area() hands it
to init_cma_reserved_pageblock(), which unconditionally clears
PageReserved on every page and frees them into MIGRATE_CMA, overriding
the memblock_reserve() of [_text, _end) that the architecture installed.
Those pages satisfy ordinary movable allocations from that point on, so
userspace is handed live kernel text.

The preceding patch closes the way this is reachable today, where a
kexec'd kernel runs from inside the default CMA area and then declares
the range it is executing from as a shared-dma-pool. On a VEK385 that
reproduced within ~300ms of /sbin/init starting, as a copy-on-write
fault writing to the read-only linear alias of .text:

  Unable to handle kernel write to read-only memory at virtual address ffff00084030c000
  Call trace:
   copy_page+0x48/0xc4 (P)
   copy_user_highpage+0x14/0x30
   __handle_mm_fault+0x318/0x1340

Dynamically placed areas cannot hit this: __cma_declare_contiguous_nid()
either rejects a fixed base that is already reserved, or picks an address
itself and so avoids the kernel image. Only a caller that passes a base
chosen elsewhere can, so check for the overlap explicitly rather than
leave the next such caller to corrupt the kernel silently.

Note that failing here is not by itself sufficient for a device-tree
pool. fdt_init_reserved_mem_node() responds to an error from a non-nomap
region by calling memblock_phys_free() on the whole range, which drops
the kernel image's own reservation along with it, so the pages are still
released - as plain free memory rather than MIGRATE_CMA. Callers that
keep their reservation on failure, such as powerpc's fadump_cma_init(),
are fully protected. For the device-tree path this is a diagnostic and a
second line of defence behind the preceding patch.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
---
 mm/cma.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/cma.c b/mm/cma.c
index 1f4d3d48a3bb..32b799a3f5c8 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -31,6 +31,8 @@
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
 
+#include <asm/sections.h>
+
 #include "internal.h"
 #include "cma.h"
 #include "mm_init.h"
@@ -68,6 +70,11 @@ bool cma_has_fixed_base(const struct cma *cma)
 	return test_bit(CMA_FIXED_BASE, &cma->flags);
 }
 
+static bool cma_overlaps_kernel_image(phys_addr_t base, phys_addr_t size)
+{
+	return base < __pa_symbol(_end) && __pa_symbol(_text) < base + size;
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     unsigned int align_order)
 {
@@ -295,6 +302,22 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
+	/*
+	 * The area being already reserved is expected here, so an overlap with
+	 * the kernel image cannot be told apart from the normal case by looking
+	 * at memblock alone. Check for it explicitly: activating such an area
+	 * clears PageReserved on the kernel's own text and data and releases
+	 * them to the page allocator.
+	 */
+	if (cma_overlaps_kernel_image(base, size)) {
+		phys_addr_t text = __pa_symbol(_text);
+		phys_addr_t end = __pa_symbol(_end);
+
+		pr_err("area %s (%pa, size %pa) overlaps kernel image [%pa-%pa]\n",
+		       name ?: "(unnamed)", &base, &size, &text, &end);
+		return -EBUSY;
+	}
+
 	/*
 	 * CMA uses CMA_MIN_ALIGNMENT_BYTES as alignment requirement which
 	 * needs pageblock_order to be initialized. Let's enforce it.
-- 
2.43.0


