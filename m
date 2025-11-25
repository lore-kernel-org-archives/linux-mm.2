Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D2DD0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 17:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDB26B00AD; Tue, 25 Nov 2025 12:58:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4F06B00AE; Tue, 25 Nov 2025 12:58:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5126B00AF; Tue, 25 Nov 2025 12:58:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B61196B00AD
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:58:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84E8658495
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:58:21 +0000 (UTC)
X-FDA: 84149888802.27.6E30517
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010016.outbound.protection.outlook.com [52.101.61.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B2A21A0006
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 17:58:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XDUTyH4N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.61.16 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764093498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3f8IHmRNMRcRDN2JmsN7U0H2Rx50NzMLzFyKm26pac=;
	b=1UZuBlf/yuPNuMhG+/hEi6yx2elVbqZmF0BfPxeXpy54pKK2YIVGhIM6uZO5E5/tPaZ1fA
	nCZts6OoGwuHQB137UQ5Um6HLviKirJoLtyli6sXQpBaL/pXiuRT+jMnUDPyLqhNU2tA/3
	GtID2g2wcMWmSLVcfYSdSgHCqleEYGE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XDUTyH4N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.61.16 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764093498; a=rsa-sha256;
	cv=pass;
	b=1Pl+gob0CiJeMIv5luSgNHpy56YMtorscWpyqd/SvsdvjHyv7POMgFyF0xfiqbN3ZjHeq5
	fnsHM7rmHASQ1FN/GvuYDZVZuK7MEcB6xGZTxPp6QwN0al41TSyQIgQOZpMto0D0fKxKYo
	AvqzYaYUW2fhRrP/HA0YyvA64+cOBiI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qteVE4AG9zovUtC3vgl6hkBcaNNHRO8ZF5s7kRw2py3ru4SAVZbIHxnTUkANve5BVFdcM/y0NKqGa5anhyfIu/YMopkZycrJmBKvTvH7vm7wvMZS0l5BbYgCkHdCZ5E5e8Xe+jG/HGPVN7R0XoVqjNAiz/5JBipxP5WYsL1tK0wABdgwpuHZuz1kQCMBYMoDe4WhTMs86yN0bilHqKEBwKKVGs/gPn9qU05H1EtcNDM+EgS734V8lUA57bYfTJ3mZE1vmsHr+YMJoIMeLQEPr2YYOrevzmGz/zmFcyrGAbWqfx8DwqIAEc44J0P0wLtRkBVthmPrtpe6dPrdMMJnRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3f8IHmRNMRcRDN2JmsN7U0H2Rx50NzMLzFyKm26pac=;
 b=o1WsYMHP9qrUPl3A37cizNG4BDtqdSXDPNQbiTcHzp3ThLv/HUz36IcSHifIAsMB/X6jRfY2HWj/iQvka4nvWiave/Q3s9tqj7cXsG1ZvpdJI9DU3/Foc+hHlxZp4MnioC5lF059Idc5vBCDBRFaQle5ihz0Moe+AcUTxlYEeAHACOb1CfFKQbiSLAEV0+1EtSPSDoctrb8dbVIQpj67Ja0I9KxxvlId9wo0GldIhcWO2P93aAl5HKc5xTS/zt6VIcSsrggZY5aHZ2imtiagFp54h0AZBcnue41MuADGPPTSDLEURROOne6hDeMsmo7Gb8RZiqR9OtxGY09je8bTOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V3f8IHmRNMRcRDN2JmsN7U0H2Rx50NzMLzFyKm26pac=;
 b=XDUTyH4NNDzZKfaUtBWEpFgBm2KES9qeU8x944vOqTbcjIQeVk/jH+AbdyOkWDb1j89NLsmnVWENHz9szK+Mw9Dsd/kk+G945/a6Cnul90ttW02PLZ8ieTtheQY1MIg/5jLZal2xKWePo2O015Q0KkVf2PlRzoX89rrzpIxc77Q=
Received: from PH7P223CA0013.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::13)
 by SN7PR12MB7854.namprd12.prod.outlook.com (2603:10b6:806:32b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:58:12 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:510:338:cafe::c4) by PH7P223CA0013.outlook.office365.com
 (2603:10b6:510:338::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.18 via Frontend Transport; Tue,
 25 Nov 2025 17:58:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:58:11 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 25 Nov
 2025 11:58:10 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>,
	<linux-efi@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [RFC PATCH 1/4] efi/libstub: Decouple memory bitmap from the unaccepted table
Date: Tue, 25 Nov 2025 11:57:50 -0600
Message-ID: <20251125175753.1428857-2-prsampat@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251125175753.1428857-1-prsampat@amd.com>
References: <20251125175753.1428857-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|SN7PR12MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d64bdaa-f58d-487c-29aa-08de2c4c32f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FzQRAK6+eEUF4t2XsSgiduOM5KYNEnPjxWaoWd0xtWdCX6TDRg31BrYbx4zy?=
 =?us-ascii?Q?S0EIc09MLCOBqLV8dj6tVA2GGVchDQOSoQp/sNoEeMp9CNvp20UghiU81ylr?=
 =?us-ascii?Q?oEWY+sqlYSIk4FU/0jlKN/PvqGkLDrKwa6K0oFV07oO21LOk7/DrjPUrxzNv?=
 =?us-ascii?Q?ClIVuR0v2DcdfO2EmZZE5dbkE6nKVxf3FPJ1+sdpSz2za1oZNmby+ka+OW2D?=
 =?us-ascii?Q?WjPk4l1VJRXy/8YTGg92PZI292nf9fBDu41iVjELq+Vh1UumQDfaodb1V70f?=
 =?us-ascii?Q?6+tYceijVAPjettsE88ly3iywDjGTe7AWUQZpYzCxb7f3IkNgyFuKfkGOMoA?=
 =?us-ascii?Q?9YdazU3OyDv82kC2d7efHSSgRn4QXlyryVzaGM7NG6BagYuxBiir1hEXXixs?=
 =?us-ascii?Q?Af+CVYAFF9gylCQoOwjqQl2vgC3QCbS4S2xEKwW8pzbx2lGoJVBSP4nZi4sP?=
 =?us-ascii?Q?dQYWFQJXwBWaARsSu9jemDszn3ldemo4EdMtvfRpttXOZ6Md/n5te96zOh58?=
 =?us-ascii?Q?g6Sxo2RjbYgncNPO0PJKV7EoTiIrVqIprtFGO7SKKvcIT3lri8icquYD9GM7?=
 =?us-ascii?Q?dpnkWzwaGqSlnPOyNNxz9/0S0xIBj7rvPHvUEGtABjFU+/nTHj4PeacyS89R?=
 =?us-ascii?Q?VfUGuxsmgzJs/eddQYCWQzsWdcRarawwZGcPO21xjq7Bsxt+w2OhUbVFdgGR?=
 =?us-ascii?Q?Xj+ixP7Tu9abLUB6aPvXe0OQTEPtSk/ZM8KLaMU45VdXnddjtwQoXG2Rg1EE?=
 =?us-ascii?Q?KwkzREbPbB/QLt9kiLXZH3hZf8/w2BsPKvnJwXw+D1IHgCASv0koVdK9NKQq?=
 =?us-ascii?Q?cMOGaTEpB7fTtZClKkpIda9ULO6Kj1EmaAUeG5siEjOnU0rdaE4QGB04KzWT?=
 =?us-ascii?Q?O/PqGyHQzoN4p6NfmSY7e66amKSBXoIkFQmbikgEmFDnau1SKPr9YJIntoSu?=
 =?us-ascii?Q?Z4tItM71+/Bf3qlqloLHCAq1YeJiGsDxrYbaqarN501NYSyd6yt9HCfGL93V?=
 =?us-ascii?Q?k1cKeVQdRQADWv+Lbp2z1lj5b+pkUS57xD02USuQJB1t4PkJQ3w349bsiILo?=
 =?us-ascii?Q?bj4WUXhYuqzh15kN3JzhpHN6nFx2h8JNcxYuhdlYKy4hEQfDzONrkGs2Jfte?=
 =?us-ascii?Q?o6uzcN6BlExeUAE0VYFzuzBi5CssYTVXXCEyOPkJ7Dm0t7HONnFxh+8co1mn?=
 =?us-ascii?Q?WA37bPKqEHrL5wUkggT+hE46FWaNVuIToiI1OpXobTiiJJyuUxA/STC0ik0f?=
 =?us-ascii?Q?1Je8OtDx7u+wlX/qP6ybMBWAOja/E/PWtL9pL/7/+EkAlAFv/tIAnrsz7tvH?=
 =?us-ascii?Q?gIrpM3xW9TO0kG+x8sftXOK3YuDHHFpNthVT0hCxVJphnE3NoqqXbeLxM0UP?=
 =?us-ascii?Q?BtNFHoMkMI9WOAoKdTt7Bg3Pu4O0HaR9vq/X6y/69bOk59fiOwE3KNhPOLP0?=
 =?us-ascii?Q?ypOZNnTBfzoEfWn5snvRUZe2VNhTT+kE6hhnUXhdsesHohd8UkeLpdJt5Zev?=
 =?us-ascii?Q?cZ1Ai02C9sgD1CvC2XIZjCyozRx1oCgisTOJra9oKq9oPYUhCCaK/y+gBiXC?=
 =?us-ascii?Q?iwUAA8GF50nZomTNvdw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:58:11.6590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d64bdaa-f58d-487c-29aa-08de2c4c32f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7854
X-Rspamd-Queue-Id: 9B2A21A0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1yit89huwq98db3ggbo3jc3rt49169po
X-HE-Tag: 1764093498-295822
X-HE-Meta: U2FsdGVkX199KnXs2QCy/Y+/4j8ea5F7G2yGKGr/DvzG4SWcgNyrkWlZwI24zSP+qZPA7rfwHUlgGM+VRdM2o3KmZSswoLMOt0EbUS42Is2k2Di+eNcYk9XpzC6pBtsOK+nvehlYFhx/tB2/8qHmS6yB7dJBI2Z7ZJSKSn0JallOrnPLyNVjfSXdRzLktAuqb98GxXxtjd2wonEMNvNqa2kV2ADv0LyuUj4FGY2EFPFTEFpTMMtnDDQlKyA+WvS+yBFBuxf42oFfbtmQnbxmoxtu+LXjrq/DgmxVBtlV19owU51rgSdFqIG5G0ha5ijSmpMQFjeJLpncEX7khIVn0oG1T5YbYpz3OH3JCqBbfky7mw558dZ+NzylamRS5VFGU5w83diJxdoYFFPW4qn3FHLla2GDeuhMfcEd71M+97031PwvFilsOanxJU6eIjbprLbZHJKU5Jf0gA2apbuxe9xWNP+MzQSbHdga/gRILAEy2FP6l23LYK75KfRL/CcRUtXz5bC1LEGBDtTAU50KdO/7hfcsCBGd+VR8/K8wjLrjSczH6jH5MeeOvO4HvdbXylRPd+jmJ4DjV9zWd4QW/O+9qAqE534Mi4pOhw7jtRq2pUs7Rd8Mo0WDwme2hvYc3kf3p77zc1B8Ntn8zuSge+o1+nNZM9++yZBvzQqOxmtqD2hDxDucX13X71tXnHqvQkQ6OsIRp17CWh/1bPdBXIsr+C0SXZoPqxSk3rU7n29xk6mtZf+9COiZgF3W7ZXK2CdKe5wyZ9/dVQ73mb8372cyn9u4ptuvzVVNisz2JuFSZ1kiVzjJmIoXSbfyYB2/EsF5OT9Zka5UzPARDdVgHyPnXjZMguWxgqM7KtqavyUjfxYt2SaGgnuCYNZEMZQ13HJwXsSAJ4+Ki8bCAWWSbdPeNMOJqH4Kl7uZFhLA3/tha2CUMpOA2i17wsIsxi9zsjELLluil/DRY1H2+/Q
 rC/Oj7MM
 K/Krl3Y4uhfQLp5qRLernbEhS3psp9dUMhk8SjenVis5cFqvRJyWuBiZo0ZohcTIFvLxP7/+taAQuqRaZexCn9+i7UAafCf2Y/UnvbRAtzMPqKb4EMN2OnwBZL0k8sCbBtkH9k7BV2bNAPUqstXCrDr8rWA/ElPFE/Ub0tnYEczaINXd8oHBuOmTNYrqyn05YG6glUQs4iktvOFuW+yucx3JOeJV4qqhrBUUgI7gXT+Wi15XQ3LZvpHfdp8jdnjxhS5yAbS3HpAVL+fKsrHU7rKGbHrXYoUnDYj49y6wfPJ0rBoUXl5u29l+eUcy/0QjfoFi2zqswW0H14WZT7Orxom8JmsUuB8syUkcfTVe6sH/Z72N2QgD+5eYuv3AzdemDNOuNBEzMDkENdUaXmYBOw3BdlOhCEbo4c2U3VFET7iDTQUTCgCyK9IYVlrJNZcBWhOvg05AhBs9CynhG5JZhTKhJ3qS1HAJPO15MfcayhFrxC8+hm1trQ8HArmPEbhSTtUhDJFt+K+Vr1bYVyVc3wYlhzZafZypUUZ1GYZvawz/Cu3/2YC8Kwp386w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug in secure environments requires the unaccepted memory
bitmap to grow as new memory is added. Currently, the bitmap is
implemented as a flexible array member at the end of struct
efi_unaccepted_memory, which is reserved by memblock at boot and cannot
be resized without reallocating the entire structure.

Replace the flexible array member with a pointer. This allows the bitmap
to be allocated and managed independently from the unaccepted memory
table, enabling dynamic growth to support memory hotplug.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 arch/x86/boot/compressed/efi.h                |  2 +-
 arch/x86/include/asm/unaccepted_memory.h      |  9 +++++++++
 .../firmware/efi/libstub/unaccepted_memory.c  | 11 ++++++++++-
 drivers/firmware/efi/unaccepted_memory.c      | 19 ++++++++++++++-----
 include/linux/efi.h                           |  2 +-
 5 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/efi.h b/arch/x86/boot/compressed/efi.h
index b22300970f97..4f7027f33def 100644
--- a/arch/x86/boot/compressed/efi.h
+++ b/arch/x86/boot/compressed/efi.h
@@ -102,7 +102,7 @@ struct efi_unaccepted_memory {
 	u32 unit_size;
 	u64 phys_base;
 	u64 size;
-	unsigned long bitmap[];
+	unsigned long *bitmap;
 };
 
 static inline int efi_guidcmp (efi_guid_t left, efi_guid_t right)
diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/asm/unaccepted_memory.h
index f5937e9866ac..5da80e68d718 100644
--- a/arch/x86/include/asm/unaccepted_memory.h
+++ b/arch/x86/include/asm/unaccepted_memory.h
@@ -24,4 +24,13 @@ static inline struct efi_unaccepted_memory *efi_get_unaccepted_table(void)
 		return NULL;
 	return __va(efi.unaccepted);
 }
+
+static inline unsigned long *efi_get_unaccepted_bitmap(void)
+{
+	struct efi_unaccepted_memory *unaccepted = efi_get_unaccepted_table();
+
+	if (!unaccepted)
+		return NULL;
+	return __va(unaccepted->bitmap);
+}
 #endif
diff --git a/drivers/firmware/efi/libstub/unaccepted_memory.c b/drivers/firmware/efi/libstub/unaccepted_memory.c
index 757dbe734a47..c1370fc14555 100644
--- a/drivers/firmware/efi/libstub/unaccepted_memory.c
+++ b/drivers/firmware/efi/libstub/unaccepted_memory.c
@@ -63,13 +63,22 @@ efi_status_t allocate_unaccepted_bitmap(__u32 nr_desc,
 				   EFI_UNACCEPTED_UNIT_SIZE * BITS_PER_BYTE);
 
 	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
-			     sizeof(*unaccepted_table) + bitmap_size,
+			     sizeof(*unaccepted_table),
 			     (void **)&unaccepted_table);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to allocate unaccepted memory config table\n");
 		return status;
 	}
 
+	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
+			     bitmap_size,
+			     (void **)&unaccepted_table->bitmap);
+	if (status != EFI_SUCCESS) {
+		efi_bs_call(free_pool, unaccepted_table);
+		efi_err("Failed to allocate unaccepted memory bitmap\n");
+		return status;
+	}
+
 	unaccepted_table->version = 1;
 	unaccepted_table->unit_size = EFI_UNACCEPTED_UNIT_SIZE;
 	unaccepted_table->phys_base = unaccepted_start;
diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index c2c067eff634..4479aad258f8 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -36,7 +36,7 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	unsigned long range_start, range_end;
 	struct accept_range range, *entry;
 	phys_addr_t end = start + size;
-	unsigned long flags;
+	unsigned long flags, *bitmap;
 	u64 unit_size;
 
 	unaccepted = efi_get_unaccepted_table();
@@ -124,8 +124,12 @@ void accept_memory(phys_addr_t start, unsigned long size)
 	list_add(&range.list, &accepting_list);
 
 	range_start = range.start;
-	for_each_set_bitrange_from(range_start, range_end, unaccepted->bitmap,
-				   range.end) {
+
+	bitmap = efi_get_unaccepted_bitmap();
+	if (!bitmap)
+		return;
+
+	for_each_set_bitrange_from(range_start, range_end, bitmap, range.end) {
 		unsigned long phys_start, phys_end;
 		unsigned long len = range_end - range_start;
 
@@ -147,7 +151,7 @@ void accept_memory(phys_addr_t start, unsigned long size)
 		arch_accept_memory(phys_start, phys_end);
 
 		spin_lock(&unaccepted_memory_lock);
-		bitmap_clear(unaccepted->bitmap, range_start, len);
+		bitmap_clear(bitmap, range_start, len);
 	}
 
 	list_del(&range.list);
@@ -197,7 +201,12 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 
 	spin_lock_irqsave(&unaccepted_memory_lock, flags);
 	while (start < end) {
-		if (test_bit(start / unit_size, unaccepted->bitmap)) {
+		unsigned long *bitmap = efi_get_unaccepted_bitmap();
+
+		if (!bitmap)
+			break;
+
+		if (test_bit(start / unit_size, bitmap)) {
 			ret = true;
 			break;
 		}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a98cc39e7aaa..a74b393c54d8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -545,7 +545,7 @@ struct efi_unaccepted_memory {
 	u32 unit_size;
 	u64 phys_base;
 	u64 size;
-	unsigned long bitmap[];
+	unsigned long *bitmap;
 };
 
 /*
-- 
2.51.1


