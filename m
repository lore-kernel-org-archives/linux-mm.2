Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3E9D148A4
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 21:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3D316B0095; Thu,  8 Jan 2026 16:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24AF6B0098; Thu,  8 Jan 2026 16:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AC66B0099; Thu,  8 Jan 2026 16:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81C936B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:49:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A3C71602FA
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:49:21 +0000 (UTC)
X-FDA: 84310138122.02.1133648
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id 524BA1C0009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:49:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bLhPHEXH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767908958; a=rsa-sha256;
	cv=pass;
	b=FwJ1DACI8QftPNRaupirjzCU5hm5m6GX+O6sSR7XSzPDUiKzOkrEo9wD298GYlXJef2CjS
	kjPVpoqDu7r8ob1oN9rXJP3y0AOhdtYPzYXzkmotL8E+7Q4HRowi/NJ3x8+OCyvLMDNXEs
	xSp7E6Ze6CtnX3CYsidsmhTgZhgjZ+c=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=bLhPHEXH;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.56.14 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767908958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Do7blpdofxmBRztyFxHIbaBEcAd5x5mLEZFtrUzNUU=;
	b=TQg2A471TyDHbKsgG6WEOUyWWaiMREsDE8M+XuOeTB7xPJixJBvRIX0asCbqqA1f/tQ/a/
	ZnI2t/zrKKewpkPKjTgLwqA2yz76OVm9yqWGlgHuQln9l5ka8Z2ww7ebD3vuy3qbD+MRGa
	lTgiHh1tqEJfY4AEGcfzaL0pEyaXgos=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jfp0zrjilAdDAIjErmI76Fh8+wewZ69qbfp05xZVPUco7E8o6O8VFAunTYC67L4qh+i5jbISyowLgkU5z/gqgq3183eXY1yTYDqDHf6r6HM74KWI9SXZvAgD+wvO+axMuYBvRalSNtgtjMvvLrm6QVhjfTeFvRsDCfjiPZh6KADtcsu36bVmahIdjaGIEdOagNUhJisbKFeoZTJ8/uvg6h5+qO2+q8QiXWwlAeVsBPb4Sd1qs3opgB1PO693cfs6LPHkdMFFzVWqGdHU+F290Lb0Kc2YQTKiXk1Xt5zTUiWgZmCR1uuUlwN4Ulj11bt75VTQ19+ZwqOqavW0U1Pg2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Do7blpdofxmBRztyFxHIbaBEcAd5x5mLEZFtrUzNUU=;
 b=UyFZ6701K8ZOOivjFPyNq4XMz9Hjkwukc10ajusAwnM4GN+GsgtuP+Olt2h4pKEwGuFnNfjXZX2kmcYQ3EpKmGVh+yMDxkwR0kupaCD5X1/zI8PJ8wCHzqRJeledDwElCoWjnNw9wLfBWLfK10jUe5Av1tTusi9NoRuCBzqWxfm3ruFre7MGaQ/U2GnwyUIRHDpEaeA6LWw+dghmLhkpdyxXKi1YsUONYa9vQT0lnyA9UXo9xRu5ORIedO40D6AYZr2hD+SOgOCW+6FkNJF7y/GUTCaA+Xo9hf5MRdnr3QQ4FffFkCf6bzUJGeAgQJf8gKyNeX7VgNq9Rn9XI7N2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Do7blpdofxmBRztyFxHIbaBEcAd5x5mLEZFtrUzNUU=;
 b=bLhPHEXHlfks+A/PRo3KtpEYp3YkPTny76oqspUyUr7md8WHoc8zRFswWGYfjSFIYEKDiPFPf7f/0l0Fz94c/ZJ+vPEJb7GfGPTaA4OtE8DZSt2bYVNGf1viMyKvSzSxKCExDVAgmjEwIMYXF07PZd45zyNVBVSGEF8fwVzfvSA=
Received: from BYAPR11CA0049.namprd11.prod.outlook.com (2603:10b6:a03:80::26)
 by CY5PR12MB6527.namprd12.prod.outlook.com (2603:10b6:930:30::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 21:49:14 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:80:cafe::f8) by BYAPR11CA0049.outlook.office365.com
 (2603:10b6:a03:80::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9499.3 via Frontend Transport; Thu, 8
 Jan 2026 21:49:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 8 Jan 2026 21:49:13 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 8 Jan
 2026 15:49:13 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>, <pankaj.gupta@amd.com>, "Kai
 Huang" <kai.huang@intel.com>
Subject: [PATCH v3 5/6] KVM: TDX: Document alignment requirements for KVM_TDX_INIT_MEM_REGION
Date: Thu, 8 Jan 2026 15:46:21 -0600
Message-ID: <20260108214622.1084057-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260108214622.1084057-1-michael.roth@amd.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|CY5PR12MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd0a2fc-a0f0-4893-187b-08de4effc39e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8uhymynXgKjpXNtk/jOd+t9ItQfYAvCdyrzw9nmrqRsJTozIxCtEuSV6cTIV?=
 =?us-ascii?Q?/omdwjK4VVwMdOmSB2AnXmKFpq+PbfqTRahBqAyO4BLEaAwSSlrWlAjMGyHN?=
 =?us-ascii?Q?fk9L3leHCWl/59KxOsNIaY+j7OmBi+fzAZlPsTu3jfsjzu+/hdOQmwvPwX/0?=
 =?us-ascii?Q?H/VhcEpGW9nMgxE2IjEyehg+IwMetYPjvX4ZQ9FG8dgGbdEXLIVh7bQoEzAB?=
 =?us-ascii?Q?FIpWEqRimCMfgtPG4ROCMYA9xMi7tERa/alZ1+T79mOOVL9JgE+cSPy652U2?=
 =?us-ascii?Q?9J8elJRocMgV8a0NwnN8iCwYCg7FteLwzGFGESHtFWsrj5tgldQZtVGOBkn7?=
 =?us-ascii?Q?15biad81zCy6KvruRhl+NiZMbJWQAr9ODjeHc1oMlgFvu76qq2eTQWW1oG49?=
 =?us-ascii?Q?clilWOlS8qqIelpMuotcKt7c3fZB5Al+r5+joebmETMskk43pxSb6iHDvNfG?=
 =?us-ascii?Q?kN94S5lnm1AIdTcuPbI889fWfVslPDXgiBNIY4HUwNHfVYPlYYzFP7Nh6fP5?=
 =?us-ascii?Q?D6Hq3LTGHVeHBBSOJE6DWuTRiLiYW/zvFBXVX/Y9OVAVhSosmR0o1pBm9hyW?=
 =?us-ascii?Q?SfAG3V3a9ifyeBkdnVO4eaTdY9V/NzYeEtNR6hl4mspHrQ/0BYOyeJzdWHiL?=
 =?us-ascii?Q?N9juUKiRuWrQptMDyGCYFIDyPdxpEDWjopNsPjuQ9isKoiX0zUl5M0kiczjP?=
 =?us-ascii?Q?X6NP06BeiX6m+48cwqyDkJ3uUshLe8N8ygStQbrx95YfgpKJ7vDjCVZEaTE4?=
 =?us-ascii?Q?t9hiH9ieTl6KbI52s7lB2E/+iNkWLhg/BmYplgUR21q/J9CXCpgoNZl5EGf7?=
 =?us-ascii?Q?S9Rn8H10gAer89LJabgdxIoWAveeiPsTmhj7htx0arGTP0+fauQyXlFOLJEm?=
 =?us-ascii?Q?UjxWOr5RWvnQF6uzjEM/V3Mi8lu8lhJKwlQZTrOF4dMZgjBsCbZZ+GtIrGCw?=
 =?us-ascii?Q?koe4A5KZ/pYZtzSaSzZ6l1uqXTZTfGEC6/lprYJ2wyNuGdKdKD8dctTx7PSu?=
 =?us-ascii?Q?PkpTLg4ISIYu5MiJWhdwwOGQ4+fTcaMmpMrpUpGH02dfrG8U6pDcixRZTYqN?=
 =?us-ascii?Q?23vf86R3cQ1/EsRVSubDKWtCKW9FxEcNo2G8PD9f4gqhjFJFEJ+QT3NzJf1S?=
 =?us-ascii?Q?8L0u69t7RK+DEQFWYZjUXZcA3gzTYw5S8XOsYo7v1bVy6Rw0qsU53mYtvBmY?=
 =?us-ascii?Q?KxUlerf45wyW5RNEnjtNXzdn8WyYY8T4o5RRABvJo4FlZWTw2JU5CkWA0T6Z?=
 =?us-ascii?Q?KeslCnEVTqOZ66pjgBU1yotQxYEvf6RwhZLsUIcVlVhN5wEQ+LcP8GZHdoP1?=
 =?us-ascii?Q?pWRuzmOYrmVdncHIRInpTYCjnlDO3lVrbLOnsRJXRc9x/0tEkvo1SPRi+W2S?=
 =?us-ascii?Q?MkdruL+yHhYQJSoXZJ7/ySWpdiPZ2pvPoVBD5HNSqN7amr09obaCut1VcOKW?=
 =?us-ascii?Q?Z4SOsu0HhHXSmGXvSesO3M/FAmajz2/2PUms4mJ/JcKj8R3fvvlCOh1bbT6i?=
 =?us-ascii?Q?cS0+1rygpuVEgT6h1hyruPUotkS4ltKHeanHE0xz6VUogI7HHw8+TaBD0cz3?=
 =?us-ascii?Q?vVm9k5sSaZ596xByqSk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 21:49:13.7384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd0a2fc-a0f0-4893-187b-08de4effc39e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6527
X-Rspam-User: 
X-Stat-Signature: ph3gtrxyg1ohjsijopq8xd4mybtf11m7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 524BA1C0009
X-HE-Tag: 1767908958-667862
X-HE-Meta: U2FsdGVkX18s9HtDOywvSb7PDVCLJUZ8ZVheR0MAJuXHHFfojXlnzTSrLvryP9jcR3LeGmvCgnAws2sjujWcQbCwOX6Rr1aOi6R9DPukoKci+nLEQ0MyAAD0gQvO1DE8NE1vFKSS2/3ybEFRq2+ZsvTexNQ1L9CJB3izIWFiyzf9CxE+gmqE6tct9OHxsL+DJHfakdXkC62qXZ+iW4sYqxfZJeaj6BhjVWAMNLTuihs9jrNcQ10AEZomu1iCmG6GIypDt7v2rhDxtmvp5y90AOMunqy5jqtlWzNme30/SlcHigjlc1ZShV4bGruX4+tJr8q2vEm7eAAZe7QqdkYdxjXpc0v9vzqGmgfwn88ITmZrz2NMb04dsPzCWEPNkhrAmFWadL8WasQKgbofEQ8eixPaC1kdDRRlVr6r1OXpLE5EguXp+xo2emAHZ+9W57Hb/JHkhlASCXclu6A5U8oyOIgXLUqdp/fkRthJDuyxVBST3vfPhfOdaQRrLxJsXAuJVo+9lNhyKu0hoQCYGolpNzKf3Kd9rVSRwZWgZyPAUWFTHWuRYc5MMb5uZV6wn96Ji0SC8T1XFnEpvXoezD/0TATwLqiVFT3RuxF2jlLA8c79kFAPIngiLABvfxEkthpQ+F8reKUmjStbddUOfrRuzxRkI7TyXI6LP/Ivst3xuXTcV+mxFuOEsRlqxKhszAZgwUaGq7/aoKkGSuyLhkhfuH6moZwU+0UIaEPnFg8J7aL5DvHWxwnhNgftkVzEKgiFvY9xu0NQ6DRUIghkMB7VKCprGlc2ZgsjKHDR4y+wIUXidQqgZ0uOYj4fieL/3AFEyabo2ahexq6qt1z4Zc7EtltCzJyECM8hm8vcK2yWnm9aFNBwQTvlawCcbm+cFaWbO7vJUF5GkHNMShx1cQ0UvrunJKE5pP4mqF3eyBGL/2yJcHpmjgD3YrzUbLtn+X0EC3WD6fjFOMwqeqtGuO/
 jdmuWvxy
 x0hvcWOBXYbdQE48RSWc8jB6sSW/88OOw67LNI0zcCU91nJoaK3kD4bgNPPISe2xD5Q8fyqhcGD9Pm5i0RD01lqd+N9Zx+xdQiaNu5eINgsjn6Avw58q8XbSisSKcvJi9hoEZG34VERQib1WDdKmnTsI7eA9iMV45vIOnC7P7MYCDMQ6QMHOpiqUN3XrqENcMPcgJsbn6MhZQCazoydNxcWdAnniXihxdEMuJATQZSkTMbyWYb6mgFGVtJ5sLlH60wKUSpy0rcEX+0ioRH7jPrHMIwOaFMQrZNTsYYusHxSmSNpdjLYppi/xeu4GqG2m65AE5j7lCDodeydR3NHnr0ou+4A+Me+UYwnKyGNOQG9TFWIzFuJrSKhruW+JRuSFDIQ/0HqN5IkJHxyPGudz/lbCYx4nH7h9SML4rxZmirY29BclO2z87StieVWNbjkS0rQMe0h7/IoJ4iHCB7yTgcKoedZ5/diYApouWtsBzii+jGwQqvEOdmfaKxp4+1H+eSsrLgK8d8UpwQrSE9lzYaDlTZfPdFNyJg1qNkld9IfCSkuQ/hk2gf6V9qP04XnkOnwQUarujOZTaYRo3vCHeCwW/Z1ecc+vWpxR87pygwnU6yL5F3UVny7ZI2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since it was never possible to use a non-PAGE_SIZE-aligned @source_addr,
go ahead and document this as a requirement. This is in preparation for
enforcing page-aligned @source_addr for all architectures in
guest_memfd.

Reviewed-by: Vishal Annapurve <vannapurve@google.com>
Tested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/intel-tdx.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/intel-tdx.rst b/Documentation/virt/kvm/x86/intel-tdx.rst
index 5efac62c92c7..6a222e9d0954 100644
--- a/Documentation/virt/kvm/x86/intel-tdx.rst
+++ b/Documentation/virt/kvm/x86/intel-tdx.rst
@@ -156,7 +156,7 @@ KVM_TDX_INIT_MEM_REGION
 :Returns: 0 on success, <0 on error
 
 Initialize @nr_pages TDX guest private memory starting from @gpa with userspace
-provided data from @source_addr.
+provided data from @source_addr. @source_addr must be PAGE_SIZE-aligned.
 
 Note, before calling this sub command, memory attribute of the range
 [gpa, gpa + nr_pages] needs to be private.  Userspace can use
-- 
2.25.1


