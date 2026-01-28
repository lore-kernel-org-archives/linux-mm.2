Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D487ED46BFA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 20:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0164E6B0005; Wed, 28 Jan 2026 15:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F05626B0089; Wed, 28 Jan 2026 15:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCF16B008A; Wed, 28 Jan 2026 15:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBBEB6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:41:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B58413BAF3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:41:21 +0000 (UTC)
X-FDA: 84382542762.18.322C03E
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010067.outbound.protection.outlook.com [52.101.193.67])
	by imf05.hostedemail.com (Postfix) with ESMTP id 346CF10000C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:41:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VtkdDX1q;
	spf=pass (imf05.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.193.67 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769632878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fQG+QZUWSH/EiGQEfpl/PhoLrtB8cI/3kvHyv4/lCsI=;
	b=ynEB9Qp6jgWScp7DCJXzaD9xmo64DIP19HoIVaVNMtyfx6BN7LR3gvo7Xl58xxtMUmfAdN
	OyrRKH5nysniCLP9Wt4r8eKYe0M+LOqZitj8u4e/d3aLFQfysi1JzvHGxbMsVFrEyKxQ17
	oOFvysoPJTs58h1WZEP98YQgkHjwZ1U=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VtkdDX1q;
	spf=pass (imf05.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.193.67 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769632878; a=rsa-sha256;
	cv=pass;
	b=121Jlc/Gt0ZxL3aI6CJZFbT8a9Y26FkZ5oZnA4o0QVpDghlBwhGM61tTxK+5GKHdoo3EcJ
	mDKnRvCaYsCM32mus8h1Pw7Cy7u8iXqtYVomBg5t/Ly0GLFi0PCqQ3LOlreTq4Bpbb+utM
	pwcUjT4hWub4hB8uBbQVTiYRY4QD9X8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KtwCyQ5cTk1XIgUNzolkoGdnHbl+hJLTe/hvw/aeZ2CvjmkEuwnBkSit0xo5UVbOfo9P5eG8OlKSLugLuZ+Y7SBdtpcOPA4Db+nLW2eUnHJ6wnxQPJkEvgcgQMbl4rQGHvBvJDLJHeP7S6ZNt4n1ktCGzYsNRblg+V1ja2qnnCD+gQ6m0f4Hf3ijneXo72aJn29RfC1DAecgWLrXRq6T6vFMumUX2mPun99EO84U9JD6xOPkhDwFBGKZFsEOHgb6fhBw/cw0WPtv4HdW26V5MU6Y1ynZBBVfWRW+Juu/9PlOfUIO64o7tzLe7p4dd/6wuMEz20MpThKe12VO1YQ98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQG+QZUWSH/EiGQEfpl/PhoLrtB8cI/3kvHyv4/lCsI=;
 b=VL4HQn4z3d8qjXZovpkK7Khq/mzGSVjwyV7/Leley8do4jY27fVp5rebVoZaGhEI8PKwQD/a3Z2xN4hyBQfdtTZboJ6tiewoK3gOQby/Zx1dNH0iPbnhgtSl86PztPoaDvY8/xemRGIBLE3HV/+oG6E1EZ7qYs7UwPIztUKMYvstyjvLdO4ArhMtGKEi2y+2s5jnjOqHJfeZmBQPcXGzv4NUfLQnsnFoFjUBxluKCHe1EUzWL+rabzq8AF+zHz1Ev4AAsVfUB+dGCv0wOqJtUv5a+ip69fvxq3y9glAc4rAVmDkz50mX//ASJ70TXUjzEmKAnB+lpgHKh0KzgSEbPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQG+QZUWSH/EiGQEfpl/PhoLrtB8cI/3kvHyv4/lCsI=;
 b=VtkdDX1qEsat9YQFM1PNmHymASc2C/5aOMRClu2FxT2BckwGnV/sYNmfuhO5ELklMFNZeRp7ejpFA8ioMKXKBsEq16KO5EIcaqahjhPZLka7dAtld3wKZ896UYoOVXPe3D5n8l1o9G1bqlOfdqfXE1Pvh/7IT2AdCGMtJ6KiBiU=
Received: from BYAPR03CA0023.namprd03.prod.outlook.com (2603:10b6:a02:a8::36)
 by CH3PR12MB8879.namprd12.prod.outlook.com (2603:10b6:610:171::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 20:41:13 +0000
Received: from BY1PEPF0001AE18.namprd04.prod.outlook.com
 (2603:10b6:a02:a8:cafe::7f) by BYAPR03CA0023.outlook.office365.com
 (2603:10b6:a02:a8::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 20:41:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BY1PEPF0001AE18.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Wed, 28 Jan 2026 20:41:12 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 28 Jan
 2026 14:41:11 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v3 0/2] SEV-SNP Unaccepted Memory Hotplug
Date: Wed, 28 Jan 2026 14:41:03 -0600
Message-ID: <20260128204105.508855-1-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE18:EE_|CH3PR12MB8879:EE_
X-MS-Office365-Filtering-Correlation-Id: b744149e-6333-47e0-b708-08de5ead931f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KRIINUCTPCkYeZPo27WNidzQ6FvjZ2nlOl0AMTfXKNT6hlBtDV+jRhTcJzpZ?=
 =?us-ascii?Q?Mf0GgkjDlXZoVUabmHZbKyoRJAJH4FdD928wSVdSVWnu1vO2+Jgn172512lo?=
 =?us-ascii?Q?rZLu51iIlZ9T78vqwzzeb6rz/UU0VhjkJYGJg2gcvJ1lh8ar20fzhWdygiVZ?=
 =?us-ascii?Q?Jk802Eh1hDFwiX7WmILi9/RGV90T3iR37yMsRvwBihkff+6GjpUzZasntinh?=
 =?us-ascii?Q?kxUZfuxSpnXrsya7Bl00/MLFWfmmd8oAx38R/B9UHOmsLlAfjFpl0KI80fvJ?=
 =?us-ascii?Q?hbHV6jxnfnao1qnIktZIwo0Q2jfDrXXqunKWqpGbiJmoGKg0fcJ+fzfybRf4?=
 =?us-ascii?Q?Cn3wM9jG39T/UBaylg1Vuy0oCT1+yESPh02bpckakGAm8reflLwMvPzhj7SP?=
 =?us-ascii?Q?zth3eVjEtSNZ+sz2QgabrLjQ9eJ5+FIunQuewqZ2FnH8PXpN98pz9C+nFMLf?=
 =?us-ascii?Q?xch8dbS5ScF0nQz4PzCxkocjjj+jyQbIrUfJ6WQaCCAkAl/bNnXr77UHK0pt?=
 =?us-ascii?Q?k+My6tK5y+Ulqujya65UNPEGE1rOVB7dX3e5qytyEqw5rIPdiwJGbW+2AxD/?=
 =?us-ascii?Q?1/CG8bKpeEUAtFyyd/uXKxzkHCTuO8PoGmVN6F2XcaVU7MvZsZa4tToHuJgg?=
 =?us-ascii?Q?YJXdkiN7qYWDvn7MwP7FbyX8/FOeFFvAX1PlIeiD2tGMfJaGdGYD7HYLeCVq?=
 =?us-ascii?Q?jjyrF5ix3sMC1rO0JNpH+Wxo+ishwbC1UZ79hdUx9Jcmfduzd/o16ebYIfzu?=
 =?us-ascii?Q?MHBfRyDH5pN4aSHrI1BJcbOWowZzXc0i/8z2deHkI4byEPGq0EVCNZcxeGQ6?=
 =?us-ascii?Q?40VGxNTKm8c7tVkrCgxSzCGENRXoMEGwVzjx3aZeLlSVhdFc9f3HBXIz/dKH?=
 =?us-ascii?Q?NuVLhKNYbl7hEXfsYTzxdAyCKgHp/lmm2Ppc1Ag8/rDBwzR32JtH/dndecCg?=
 =?us-ascii?Q?u22RDEm3GmyjW4R6olFpnC7sK8j202au55jR8+iZoJ8j8Y3r+TDq6S8bgK6L?=
 =?us-ascii?Q?voXETv64Yr4BZsfKYWsZcDBYhIiqkMeu3x9e0qFEBUd7Qxsf7tjFEtQ9uz7z?=
 =?us-ascii?Q?eXtdJndYDhddgf8W97jLAPoGGh0KuXNodJZ7OUfN5U7q+Kh795ikbgXLEV4q?=
 =?us-ascii?Q?e5ac7HYwec74hi22nBUQ0U2Nsr3FI0nBTZC618r4QIBxe/gnt68UVWkRb4oF?=
 =?us-ascii?Q?zhZG4/GB+KfVobhc7eEgG4Mj9Lbp03Pp15eSdXuPhOSEQR6xkNaAWupo256j?=
 =?us-ascii?Q?3gDfjVdWJbz0AqDkUqEtQZv8Dq9RGE+JgA1MahbbseAwfGx6ZKRoi/YtoSMJ?=
 =?us-ascii?Q?FR2oXcxxOxUhp79GbAu3RSqqLG3xcXcISS4w6ZtfvvvPvsMBiuobs+8v6VeC?=
 =?us-ascii?Q?+e+Rrqq/raavlgDYX0pB29Yt2zy8Bm4PKUBZN0Q7OvyKW1PTwBYKrYB5Oa+u?=
 =?us-ascii?Q?K2e0A1vyu1Bel8MBppepJ8wc0LZfu1YBf5YvRSVaXoRBL8A9cH8pWqvypdwX?=
 =?us-ascii?Q?rybTm53ftGnhXRk2fmF5yieT9aHCPHYTN1jmerhT0N70m80w0BruKjG2j8sC?=
 =?us-ascii?Q?bkKBq4kAbTmnc0rf7ULbiM4eS+kp2VdR7ztXyQgGk5tO0PKsA18krvYsMU85?=
 =?us-ascii?Q?iNnnUmWg3e+H+eMVsYikCa0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 20:41:12.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b744149e-6333-47e0-b708-08de5ead931f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE18.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8879
X-Stat-Signature: c7htponqqxmr31xet68agodwr8a4ccgi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 346CF10000C
X-HE-Tag: 1769632878-287221
X-HE-Meta: U2FsdGVkX1/nQxXimE6sMlu53PqOBETfJBahQ0Kfaet0EToBhac1TpcyTkGW9bKPOxhJJkdIVyBoaTgUeJ+MFRGAEM5vAjxWcL+JUQs3VV8BX8EU0/tvB3vXzM7fWS1oZfZImNxMw9K5jyHqD7V7OYSdDVDIU2EPue+ogAlwTlHuLmtFiqEkye9AbC+vBVUVLNnKO7bjTGz/0p3qB99lnFMeH5TGQfUQiT0o5IfbwvJ0EyoidBuBCw9Egd6SwxgEhoOtdOHxmMA8qURwUDbaz1APIgdxvxhqKMKJaY6PVfzAK421GmMCqGz5rvcuXnEcph3mMZDOJzd3mqsFAWxXoMQmIMxwiVaIh2dXZ43ntvRnzi16gt+fgRn4IKLv2KY5wWTGiKttOtSnltbqU3DK3iGFYDurbp1Uc/645+YFP/9eKbihSBW0dHdMkxOgrX3jZf9nEUtJQqnWTosBqo5GvuDn1lBsM+IOLzV2kMSR+doFXiBHHsCmNRvvaIYKN3sKmiMnar7hE69+MsJBazUQ/DTx+DiMHPr58hzCbKAxM5MNqqysNrjvkhwgPAHtXzEok8diOq9DSOQSsDY2obHwYJDfa2sUAErrBPhnMg/7GRQ3L++gTffHEdaQX/JmBUYcN3Eoqd+BAc3CxPO3IOhUL52I1gjJsPSg2VfxoYDYRsVSbXO1+6Iql7W2ACDWh/B56z6xLZ53KxhSYEW1xpUncFUcaHSVD+RREcDQmz9qyl4l4nLNLFDjhXlcnX0zp8Cygss94kXM+GQBEKvBZLvnrsfjtpASiSaBjj1OcP08ssxKB+lG71ZfImuwoFyH/bCYumC6KHyEnShCTd0NlV2vjvl3OuP4GV9k2nrOcZGztPJEkOClf331I2J7Xuu8qBUxC115TrjcrTLZJ1Pu+GNlWwwK9kjASyJizOMHGlAEbcNwwWOTSAhGROQ7JvjjV3Ne3rx80YfDEpuNUgHWrCk
 zD8mxxpG
 knL3KH/EoZ202fwMWEy53iY6ylYMw9Z7Kz54rh8cwusueKZK1wESlRaIhxNvtHDGodetw7srQDI19/SyaGH9A+UmgOnSWH/V7caMaR0CS6takA/+hOQzWILqG6X5AIdylnTETUv8aANeOFF7gKPCsvAHbrQ0lqIAq/dGG1AilRpnuxZv+jUGD67ipevZeIa5j+700O0hgMtG/mKYH9S3vXmzqtgG+JL06GhQVN1Uo091vFqmZXIlX3kdOqibBj8bm1Ja5Gg6Q+Upf0naMFjLSgOJWhVeRNrCMiBQmjariL78NZbY/RfEkcqKqbf9KN5ItJwFglRWuDCZ20TaGvwwBPHEzqxlCrL3iw95td6C6yknNRdpPoFyCL9U2srVdXbvwfbiGG1TIsWZBLSAbmotTygaFZl8iC88/V7dSlFWNPVtUi5LeLAKekKXZCdkidfor7+aDeXO76VN3mXQWpbayHJKw8M+YMuBWSPLMMBQ/4uAGOzgJeuLJX9S5iGu8p7rGJ7QVqXdNcgRlNYI/zFvJXAwheZt7Hro/4ZI7pNW0Zc+fcf19r4SSNdQZlMnI6/06t5uaP8nNGHt0lrrLpeyZRAbv9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Guest memory hot-plug/remove via the QEMU monitor is used by virtual
machines to dynamically scale the memory capacity of a system with
virtually zero downtime to the guest. For confidential VMs, memory has
to be first accepted before it can be used. Add support to accept
memory that has been hot-added and revert back it's state for
hypervisors to be able to use the pages during hot-remove.

Usage (for SNP guests)
----------------------
Step1: Spawn a QEMU SNP guest with the additional parameter of slots and
maximum possible memory, along with the initial memory as below:
"-m X,slots=Y,maxmem=Z".

Step2: Once the guest is booted, launch the qemu monitor and hotplug
the memory as follows:
(qemu) object_add memory-backend-memfd,id=mem1,size=1G
(qemu) device_add pc-dimm,id=dimm1,memdev=mem1

Memory is accepted up-front when added to the guest.

If using auto-onlining by either:
    a) echo online > /sys/devices/system/memory/auto_online_blocks, OR
    b) enable CONFIG_MHP_DEFAULT_ONLINE_TYPE_* while compiling kernel
Memory should show up automatically.

Otherwise, memory can also be onlined by echoing 1 to the newly added
blocks in: /sys/devices/system/memory/memoryXX/online

Step3: memory can be hot-removed using the qemu monitor using:
(qemu) device_remove dimm1
(qemu) object_remove mem1

Tip: Enable the kvm_convert_memory event in QEMU to observe memory
conversions between private and shared during hotplug/remove.

The series is based on
        git.kernel.org/pub/scm/virt/kvm/kvm.git next

Comments and feedback appreciated!

Changelog Patch v2..v3:
-----------------------
https://lore.kernel.org/all/20260112202300.43546-1-prsampat@amd.com/
1. Account for cold-plugged memory at boot and introduce proper handling
   of the unaccepted bitmap during both hotplug and remove. (Kiryl)
2. #include<asm/unaccepted_memory.h> within memory_hotplug caused build
   failures on non-x86 archs (Andrew). Instead of introducing
   #if-deffery to have arch agnostic fall throughs, create hotplug
   specific helper functions since we now also need to take care of
   managing the bitmaps due to 1. as well.

Changelog RFC..Patch v2:
------------------------
https://lore.kernel.org/all/20251125175753.1428857-1-prsampat@amd.com/
Based on feedback from the RFC, reworked the series to accept memory
upfront on hotplug. This is done for two reasons:
1. Avoids modifying the unaccepted bitmap. Extending the bitmap would
   require either:
   * Dynamically allocating the bitmap, which would need changes to EFI
     struct definitions, or
   * Pre-allocating a larger bitmap to accommodate hotpluggable memory.
     This poses challenges since e820 is parsed before SRAT, which
     contains the actual memory ranges information.
2. There are currently no known use-cases that would benefit from lazy
   acceptance of hotplugged ranges which warrants this additional
   complexity.

Pratik R. Sampat (2):
  mm/memory_hotplug: Add support to accept memory during hot-add
  x86/sev: Add support to unaccept memory after hot-remove

 arch/x86/coco/sev/core.c                 | 13 +++++
 arch/x86/include/asm/sev.h               |  2 +
 arch/x86/include/asm/unaccepted_memory.h |  9 +++
 drivers/firmware/efi/unaccepted_memory.c | 74 ++++++++++++++++++++++++
 include/linux/mm.h                       | 14 +++++
 mm/memory_hotplug.c                      |  4 ++
 6 files changed, 116 insertions(+)

-- 
2.52.0


