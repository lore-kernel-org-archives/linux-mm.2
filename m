Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E02606A338
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=M1qESGBR
Received: by kanga.kvack.org (Postfix)
	id A182E6B05C1; Mon,  2 Nov 2026 06:31:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFD66B05C7; Mon,  2 Nov 2026 06:31:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904B86B05CC; Mon,  2 Nov 2026 06:31:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBA36B05C1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:31:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13B8A4098A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:31:42 +0000 (UTC)
X-FDA: 85389964044.27.5D265FA
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01C71180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:31:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=M1qESGBR;
	spf=pass (imf24.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cJhDMYNwBW1Vp+zQ5jiIgTWuSx4tHUWYR/pyCjaZtlo=;
	b=PwQwgdZV/FA2vhlctuzS/bLrXAW8HgQtqMqrZmy7/SimWa7OO21urUAkHslU9k37Qx2aeE
	UafNqdeUpnASOMxJNK2A0Gk8plCwjqL2024E1TpVQc/orJTpeF+T6vZhcpmlE7iLBCPwti
	WQsrMV0BiAmrYGxdf9qXxhC9yNSWpkk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793619099;
	b=0VENFZi3Ujb3EJ5vgIxUPEKGS6omXzUSyLGH+TWRC8dgaE2THfO2G94By4VFidxgAYxLY7
	LxSSWYVHKMDJOVz2GoYPwzTYc3M9FMUeFNGUr0KM0nI1Ij1sU4c7kpdhqApZ74OIzNm68A
	hRhPGpdEQdTf2kmbi2lA6YZ+BoixPZE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=M1qESGBR;
	spf=pass (imf24.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoTYlSS+Q7w4vDUs7XFJSfaC6SrjYDTx0f080nmk0JJ4YMwiM6/nM/OD6f2viVvL7u5+lXENIlABlBjhzqXtjylpsJSo7hHq5f3+oJn+Elcad6Wnl+pnB2kGUOA8tvM2hoTbfZLm948ebYLOOVCQ3uL4dIGP4/gcUHiZeiI/dsko2N8zFknNbVOt2xI60kBErk9vj9WgkT8BF4oHaLf64eW5cPk9kPCea62UfiKgX814gZ/j9gzps6F5abT7g5vFmhseZixJb2yDI9Ju2bj5zY5aEHY22C/patCY67J0GR2cdlkcVYmWWEfWnn5Rkxu+CVxyRespCdDPeLxrR4XuTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJhDMYNwBW1Vp+zQ5jiIgTWuSx4tHUWYR/pyCjaZtlo=;
 b=mp6XepSS3084GhdTGU+WiTerAHxoDgmkUauem6VPkYLnjqdzTc1FgCW0JwiVf+U62iKzehudGQ0Ad3F6qds4i9i9vv5KgiBxljggugV0zQcIarNmdBx8u7jZLhFsSDFjYUS40P5YIyXzNxihxgOi620B6adviet1miCVtyhSeAbU8beQ3tiJvsUn+2P9phvmlMvxzytJ5R24baaFCQT2wS75GsS3WkpQ2jrs5UlpJzYxHDg/IFiVsmLRzIJxDl+PLBJpy9+HGwiDKsYOfc3SVGxzaS8zd2crK7oFqDhW+nCwUkYdWFuMiCTgBzTUzqoH6wU0TiIRQ73S5hToDQkL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJhDMYNwBW1Vp+zQ5jiIgTWuSx4tHUWYR/pyCjaZtlo=;
 b=M1qESGBRRdNwakvWMjwTfxB+Wq1AsIF/TjnWoWt6hq9nTvb00UZqgoExobBkqXtrD/soZTPQ9AcwD3DTqb3bRoyIgroPGvGBqMbiMbx9i/DwMnomL8NOqE5Fwg3x7VNpC1q2kLcGVGLa7TTNzZyrN1do2zYkzlFc1Q6Y9AdW5o8=
Received: from BN0PR04CA0142.namprd04.prod.outlook.com (2603:10b6:408:ed::27)
 by CYXPR12MB9339.namprd12.prod.outlook.com (2603:10b6:930:d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 11:31:33 +0000
Received: from BN6PEPF00000075.namprd03.prod.outlook.com
 (2603:10b6:408:ed:cafe::93) by BN0PR04CA0142.outlook.office365.com
 (2603:10b6:408:ed::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 11:31:33 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN6PEPF00000075.mail.protection.outlook.com (10.167.248.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Mon, 2 Nov 2026 11:31:33 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 05:31:33 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 05:31:33 -0600
Received: from pankaj-M75q.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Mon, 2 Nov 2026 05:31:27 -0600
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	<linux-kernel@vger.kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<linux-mm@kvack.org>, <Pankaj.gupta@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>
Subject: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no longer E820 RAM
Date: Mon, 2 Nov 2026 05:31:27 -0600
Message-ID: <20261102113127.161823-1-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PEPF00000075:EE_|CYXPR12MB9339:EE_
X-MS-Office365-Filtering-Correlation-Id: ac219cec-f33d-4f93-40c4-08df38d4d909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|7416014|376014|36860700016|261021123027099003|261021121427099003|261022105027099003|261009223027099003|261026140227099003|261028144727099003|11063799006|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	bbNiK9etZKgDbgmmZlMzqtRMvo9eEycoWdEoLnS9tC36Lga9NZ62S1M4viF6Od+WPVY5E03k4mg+/X6iKs+lP0NBb9y65sTWJ75W2UrTJhQk3RO/BxDuJYdkSxh+6H/3TLKJBMClSA8BeFlt8cn3MO4boGuYl626IDOi2hvuEy7ipuYYhpxnEBSraZVWCnM0Sj3phlY1vJZHDrmx+3oHvJXUnzj0iFt78H7aHqOTQ/WL388AyUQ4YUvZGgd1t4R3pZfQaGKya6XSlRUhU+DN1X8aewxjDDDOSCcBNkf1X0Y9l0FZ9bLg2j0K2MBVczmrRWyN+Jyo7aYU8dWMRg07DejAKBbhCVUjT+TKxRZhfQlCP+eW7S5Xi0ap7ANN1u7RWAAmv92c57MLWI/UaVYFQPk9UzOwwEp7Hy3vY24hCm1C+RUqpxOwzJ3GOwJYy6YjDfb09eC0xufcjnByTr4h8sqaBUfM28MrAwSBQIbJgUYYYBN7g1pansQt8HnE2s2L8zAGwkOzBN0AY2UKWtgFFXYdKZcd1Waz9dFYmuWLc9x8dhsnkhDeSkLozLmITbuOjSSzLn/jTf5hvSCVm9d2expZe+/LjwEDSFAZhb0JGsypJFOJdlwzQRjX6oAQv31CJpifbUiLdZY5lrZGhAyvIgQselEmPBwZkWewTvYEqlT27J9rOoP27/85yDbpiqahufxWHi3yib6r3RyV0778Lw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(7416014)(376014)(36860700016)(261021123027099003)(261021121427099003)(261022105027099003)(261009223027099003)(261026140227099003)(261028144727099003)(11063799006)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	74kZjZmgoeoiKv9+smoRJHS2ibNe3zy++qle+t7v6RvXMFgF1U6pwqQILtVzUBs9GXNyZm51+0H1Z4sElIu1v16bLycr+smUwt6SIzNvvH/zCo1zisNdKEokXyIsdONTDBJKhXwIWZhx2YRuOBTuJKEEkM3qrUhmDodH8vMVo6m/GdusmKP+a+DEscF+zSttFp4+aJvBCQLO7iuGuarini1lRsuBz7NrRSD74mzO+Quye/jQ1LwLhxHQ+zgc5hFR1zUd5GjXpZoPJe0f3ZUDPq1s3Frc8/iUlx7XCIvKQTjy3yw22aZsUbX3GXMEW1UvbX/CNP6kMfPqWYIuWrkNLRNB7TJ8cdoVrhFFNA2SkrdVnLfP+L4FLE63O8vCM5SNt/7gM+Ds0O9wLrYtN3p7K1P7JyR+Ec6Y7Y3GHsQwH2x5/6PbW/HxKtCDT+X5StlW
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 11:31:33.4981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac219cec-f33d-4f93-40c4-08df38d4d909
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN6PEPF00000075.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9339
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 01C71180003
X-Stat-Signature: u7pdn1kbh114xoy934oh7dakhdfakoe9
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793619098-419729
X-HE-Meta: U2FsdGVkX1+785ynwVp37nUgFLv3EWiP671yfLQCp/nqnWQhgUIM/NPOrEznOPQjkphWp0SARDSNzbkMQ7xEudo22PIGOc55CeNpSyxwSaHJrxKFZiRbvnykt9rEfukmJcbRV2tjsxqjwxNMbazPqD0aCbDGzXhReLZEhQm1ku38ANaplJzWZXKOuZ0Whuf5IzLaUf/y/NRPw9KEEzBqrjUQvFL09G4rQFX4kUY76Px4ExAic5hPwigOxZ+9DWiheWKadfqxKCc9/3+boCvHZkdGnfry1neVuNL29ps89+t0yLvjmDFbePWygK1QG/sqDlhUyOX932Ix9xVi6RsxcIfc5Bg0XDKkfi5/nE6qqobMgUtnoTkswSaFiOB85APtCQ8MKRmgoXp/QoU0tYn5Q16KAlr08cQZgJNl9n84q6Jrw0AiatKLH5OkVVRnwz/UdYjvvzxh9Q66GJ5ATcJfFItPFa3FOo0C2QZv3S+tA+DZSZZs9T920P0RkRvU/6EVHH/m3dJFI7mWK4zNARhXGZKQAgXCymhaFe4KttOz34Bm+gXJsidCn5GgdYEDD4UWnY0UaQaKsNWtledu72Y4Zb7HFMchG/fkVmdFU1Cnt7FJ89tJispwCkVAM1iJ4bO2ZNr/tzBDTseXG1TCZEhfe9Y6TUHh6TLW0A378u+zUV5tvxQGGJ3gLYhlznW69fFQ455sqQYNVK7l861rmy5rgHrHwS+oAZxqsAd9Tkusnhs2D4NMFdZTzh6D4cZBqqa9uYxvbKkmic07DivjddTB1i3wyybNE82L52F0s92mdtR7ciNjQOVxq++VPbhv9ssMiesQJDY8igb4C7wTlcPWTr6a648NEk37A6/5TVRSIeqItnOzMW2yd6MG03v6jOmzNqkgatq35rnuQqBhVUsB4G63O7vjxEDcsx45RG0Cv4oEq/5Kkhh8NwD6hz1T6ceXkXzRV2y0IlcqGKmWMVn
 IwEDjUPQ
 EW/IXI6JAIedZw21kJCLpBT776868aHVBTHy6cOsMK9YGH6dk2TNpnZFXQyN1OqmUDZbbi18pt4J2UgTfGvJ9ZwN0D7RN7RbNJoovZulweaz5LlwP80+HvvKQGt+hk8G/Hs6q6Vc/flhLLh8oX2hN/xU+9rZoAvrCMsVuaryD4h7Nzkc+zSy7NzT3X3SHK46qYppqoshbHtnmskp7fy6zZ98hvIoBAbnKXdaxHh6sCHcL7Dl+x+7t/PyDokv+5+x+TLAArIhMrULsdrpkBLEtudSl+JV4MRQ8Ybj2AAaeSjEBhm2jGEtwUoHqo3hgoZO5n51s0izoipmP7SP/PDR8RVeBy7zO9+eLdVYulzGukhmBdLE58o9BMjgFdribvLIbwNPquayhBka6ldO5WsVUmxstupUFihYh3tKT0/XVgQPSPbNBzXf2sy9/xTr7y30hicxWbMLb6lT7AAenGJzZKvb1vjfoE8gPWQvWHZegIffs7gbdUZmIuiDAkMyHB+im/+lCJ4Qwfl8Gxpx4ONECrloPqrPlHZ/zwwfV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The EFI stub builds the unaccepted memory bitmap before the kernel parses
its command line.  Option memmap=<size>$<addr> removes RAM from the E820
map while its bits are still set in the bitmap.

The removed range, such as a memmap=...$... hole, is then still treated as
unaccepted RAM and accept_memory() tries to accept it.  The hole is not
mapped, so on SEV-SNP the PVALIDATE faults and the guest crashes early in
the boot:

  BUG: unable to handle page fault for address: ffff8a14bfe00000
  RIP: 0010:pvalidate_pages+0xc0/0x250
   set_pages_state+0x41a/0x440
   snp_accept_memory+0x3e/0x50
   accept_memory+0x186/0x260
   __free_pages_core+0xd2/0x240
   memblock_free_pages+0x1b/0x30
   memblock_free_all+0x275/0x2d0

This was seen with memmap=2M$0x1ffe00000, a 2 MiB hole in RAM, on a 19 GiB
SNP guest with lazy acceptance.

Fixes: 2053bc57f367 ("efi: Add unaccepted memory support")
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 arch/x86/include/asm/unaccepted_memory.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..744f1a993352 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -2,10 +2,11 @@
 #define _ASM_X86_UNACCEPTED_MEMORY_H
 
 #include <linux/efi.h>
+#include <asm/e820/api.h>
 #include <asm/tdx.h>
 #include <asm/sev.h>
 
-static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+static inline void __arch_accept_memory(phys_addr_t start, phys_addr_t end)
 {
 	/* Platform-specific memory-acceptance call goes here */
 	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
@@ -18,6 +19,26 @@ static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
 	}
 }
 
+static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
+{
+	u32 i;
+
+	for (i = 0; i < e820_table->nr_entries; i++) {
+		struct e820_entry *entry = &e820_table->entries[i];
+		phys_addr_t s, e;
+
+		if (entry->type != E820_TYPE_RAM)
+			continue;
+
+		s = max_t(phys_addr_t, start, entry->addr);
+		e = min_t(phys_addr_t, end, entry->addr + entry->size);
+		if (s >= e)
+			continue;
+
+		__arch_accept_memory(s, e);
+	}
+}
+
 static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 {
 	if (efi.unaccepted == EFI_INVALID_TABLE_ADDR)
-- 
2.34.1


