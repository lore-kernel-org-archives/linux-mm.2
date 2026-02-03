Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0024EE8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C996B00B0; Tue,  3 Feb 2026 12:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AAF6B00B6; Tue,  3 Feb 2026 12:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0673B6B00B7; Tue,  3 Feb 2026 12:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E06536B00B0
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:50:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C439B9E79
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:12 +0000 (UTC)
X-FDA: 84403884264.04.241C2D7
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88D7840006
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:50:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EQFwfj1g;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XYDwwfKs1xLCt/9o93NAUKEdzyyyti1OLGKwH3XgXg=;
	b=JYvAFsrWDv06XZuU0vP3Ds3Srw7mdTI1jt+/r1QS0FTp46UO9EIBQ+gxahV6O+g3GxLu9z
	Cg1D2ik2lp9sMGk85fy+vk57xO40DRptgECe5PccYPcnh6KkAhKnzqPytvvIG1uFfeyg9c
	JuNOuPj+GoSaT/vYHIFsGpPtN+LWJkw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770141009; a=rsa-sha256;
	cv=pass;
	b=CrW5Wao5HEDDPPmLc0wCujhqrG3ZmdWtEjp3XzyRquyJsic6weuiq7SBrJoy18w19WfrmD
	fRvSbd0IZIVxrpHuGPqHHqb2F7xPa1whi+QKujThnAgsX0NL7ZdIqC3jLc7IJToJb52ndF
	bQqPh9AOord76UsuhJkShKR1APArFvk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=EQFwfj1g;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of PratikRajesh.Sampat@amd.com designates 52.101.193.2 as permitted sender) smtp.mailfrom=PratikRajesh.Sampat@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+uVz8v9ImFdNWFmVSydDfpb7n+AGIJqJa/B5ZLXz7vtZ/NUVAqvVWAawdjA8uYunRtz1VHf/l+hiYOYjw323RxhvbiV5JYj+XTCDzB4JokLKYI6DXmQ8gJdPsTSjTM8oj7L5QoyQwvKUupmgRGaFQuiMpLnxfNmuLkL5XgNUnav+HH0WfiFk1L8H+xVsP4gK/ktJAgLJmgoCcOVYm68ue7uAlqvU8q6kCExHBYLRsrJxbtAl/BJ9QeFdRTqwZRtOvUZW/paa6knf74+iIxvdBYWWSJKNUOTHcZrBE5hEVzAqY6T/xtNpBCIMMMqiLlmaldqbFWGxrrjftByIVGfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XYDwwfKs1xLCt/9o93NAUKEdzyyyti1OLGKwH3XgXg=;
 b=NbtjwlzOrTvvzrgcwKBYDTBiQMdRDu38my3WIxcFsyJBFEZQbXE3NeMv4hkZBpU0stiHOqnlgYspEQBZwwjo/qGH7IjncnRTbMf9cWU1vUv+Sl3wAfFP4sG6BBE9raPuGWSb+SL7Dra1BIryWK+w3BGB2Tk+mUCnWj9Eoe67W8eMvSLBlWKciHQvTRjYMp9FCLQDBbXRNC8UTijOH1yKP1bBc4r0pQKwXDzL6+BYp4Z2iJwyidAV09EVbbhGSb9dLXcnFDi9GrvNBejn/hueCZofTLPfJ6dfzt+LsdeWGWvvAAdvBlqTEluLWB8qUIIOGk5o1cDXFy3OZc87bs8uzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kvack.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XYDwwfKs1xLCt/9o93NAUKEdzyyyti1OLGKwH3XgXg=;
 b=EQFwfj1gSsQw8AdpPKgHWoddFLmwuAEFjbeCGq+OmeXMzuuuw/E5MQYoBdK4gQ3L6H8jHOL8Uz9+2dME8O2Top7XhiIVkoWQw1JobINbnQkvBIear/xQRryTObx450zgbdknWA4ZEIkh8a8WUWylVwmlWNewBJURO0qgnt8er1A=
Received: from BN9PR03CA0283.namprd03.prod.outlook.com (2603:10b6:408:f5::18)
 by DS0PR12MB7584.namprd12.prod.outlook.com (2603:10b6:8:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 17:50:05 +0000
Received: from BN1PEPF00005FFE.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::b) by BN9PR03CA0283.outlook.office365.com
 (2603:10b6:408:f5::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.12 via Frontend Transport; Tue,
 3 Feb 2026 17:50:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00005FFE.mail.protection.outlook.com (10.167.243.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Tue, 3 Feb 2026 17:50:05 +0000
Received: from ellora.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Feb
 2026 11:50:04 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-mm@kvack.org>, <linux-coco@lists.linux.dev>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>, <ardb@kernel.org>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <osalvador@suse.de>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <prsampat@amd.com>
Subject: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory during hot-add
Date: Tue, 3 Feb 2026 11:49:45 -0600
Message-ID: <20260203174946.1198053-2-prsampat@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260203174946.1198053-1-prsampat@amd.com>
References: <20260203174946.1198053-1-prsampat@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFE:EE_|DS0PR12MB7584:EE_
X-MS-Office365-Filtering-Correlation-Id: 17954940-4f4e-4357-446b-08de634caa16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uKTSCHHu4pXllR0zeRnpIaRGr2+zDiwFtDVzVTxvvv+IrVkJWIX0VPm9swbU?=
 =?us-ascii?Q?7+/k1Zu9iRrkJCtbB2aApNABXG3LegzhgHoIwwTK0iv5Bwa/4QqrGK/2cIbn?=
 =?us-ascii?Q?H5LKn9Qe7TSWmo+eqX/VaboEVUcIs4MWAktOUTc31b/I1t65WmcNqL9CU6WW?=
 =?us-ascii?Q?IkG6Rzhh1yQ99CqmYy3jQREP+v76xp0+3I47QcwRW1+/JD3lHbs4xtuFt0zv?=
 =?us-ascii?Q?Oyt6fcwmWy7hmEZotOzUphEiJrHzukJUfndyHdlD+LVcWdnwufA+zG1qMLVj?=
 =?us-ascii?Q?5403SciN8OBgYw8783f6h84sD3+Muaq1wyvSkp1Q6vmtMZXayjlwGFgekng/?=
 =?us-ascii?Q?sSMcq97eoZcc+PUt5MrCbuz5SvHIwiBYE3vaqGRnfFItAqouG+bEpa8vUADO?=
 =?us-ascii?Q?uVl4RWWTcSpyqqzHYUctLJ6P6iKzH6fPJRUoPTL3+Snz0KP6Bo5kJQ1zTJsX?=
 =?us-ascii?Q?LQ9DIJhUenbXclaTc/rtN7Ad09uTdOQzQ0+Z90Vmz7JNafVpbxlTB4m+SfKq?=
 =?us-ascii?Q?exRIIuJaN9uD0XiaoKICjQDzy/ms0oE15yaIQBkZbBXSuhqSKaFofHZEBred?=
 =?us-ascii?Q?aeRxax37NU5vNQzBXo3dxKMnOl7uOL2rIwhajT4x0g+KiQpvaBDl47J2CySF?=
 =?us-ascii?Q?MlOc0GxMkuj80jm0AM6Ri+zQZAZkY+b2frzGjReYkE6JBmMqwFSkkUeBLu/N?=
 =?us-ascii?Q?ZabinOYlF4bwmVhYqhNRXL6EAJRjlVz5vSOAjcOlOEG0cBRgfvQbKRkuLn2+?=
 =?us-ascii?Q?94A0pgyWlePMfKO+lfWiOHSo1s0r2X8TQwtcczQETkqvzDODYPwfyViVHR6u?=
 =?us-ascii?Q?gsI08h6FNPWN3FlWCAk7rhWZhtBYaqSJFWI9ZSve5QNyxUJ3nTGFQS2GJ7Hi?=
 =?us-ascii?Q?Ldm/2euSKhd6+bJWWj6DAOprgwTpGc4L3B2onyO6C2W3maFhx7Z0UHnC9pji?=
 =?us-ascii?Q?C4SOtBUsbNlPpdaehb9dkiY4Mg0AUUEizc37NwpyJs0imDgIm1kxLeCmoQAQ?=
 =?us-ascii?Q?G4A9KAowK8TZTuvmFO3f8ARW34xUU4HC3Gaa/nEHmexRxDUPE+FIfF486u0n?=
 =?us-ascii?Q?Vk85xFDiWnTgz84zXBujOFkXNryLZyMGMwDG6A1EE/hwqAWSzM+em/Dalq54?=
 =?us-ascii?Q?dZ3mti/3hV3c4W0k8uTXZRMdcm5doDBoVXMjuGL9qnuoFHXxRu8TOlyUARRS?=
 =?us-ascii?Q?Vqa58PERenn5woCGmDszySeMKsAU1eyzwAe4K9cC8tokoTROXu+a6NBFU0br?=
 =?us-ascii?Q?82bL31lFAzGL58aoH54nbnUFXpp9SG//LqjwEINGJtLR7S+0u6AXw1PCqLTV?=
 =?us-ascii?Q?7rHCm0A5wPadUry9dvhaXSsMUwsvdjFJd0BCqQIh0dECYkjwvdoQvAhHcy1W?=
 =?us-ascii?Q?5dYGqHVFVqNUipBW9mx0BwG0iuE/vdPeevgyhtra7QV6DiWBjOEgrIL57zAt?=
 =?us-ascii?Q?x5aWgsG3ENmfXhdWmTsH9HHLKE6DDjmNHcOAxJtp6XKvSU6SiZ41pSfVFXgB?=
 =?us-ascii?Q?2vq73pvmORXxLaPtkHS+u0SJ3duJrSDAHCJ9eZXRtYuiZUmKkcDK4Z7dQrSM?=
 =?us-ascii?Q?0sLENpmxutAc2x3ySusX3/ERePTfDpVrVgaO5yjS3tZWb2N+Nt1BzJEsD7N5?=
 =?us-ascii?Q?YtfFX672Koiosy7AteFzHZfbaMY1O5af7UFymvydCbWyWV/egUgqKgwNYHOx?=
 =?us-ascii?Q?HmMIeA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9YLnC7bCuc9vQDMcUnUYU7fwkyRHcwmn9j6wlQqG3weObohHmmD3TQTK0ylvJOSTExhWZdB/JaeF4Gx8P9esl3TEPK1cXYum5Kw4XWvAdMxhIrWaiPEtig+CKIkt+4yMDs5D301nH6niD52avFyAYNrb+jnyVtXU2PoOys+xP0m/j5rTmv95Gi79ocnI5ni961upMLjcfAW2gtlr0hllblGhITwxoHdEuzqBwa1rKkc0a7gizsaWLuOYqIUlWqDeVv760osNeJ6gxXx7Cm8v3M6h3XNhvXYHVYDvkeqAAMTbI7mVzXv8M04D97BcHbrhM/MvbvUkFKAGwJe9YOpTjsz5beyaiREOGaDJPd4Hpro6I6+4Y888IlgkoQOD6/Tea0855wDt3DjDGYIAHU9X35yK+HjGMZAwOdU6SVxW0sd7wONGHlDR44AQZ290dyW5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 17:50:05.4998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17954940-4f4e-4357-446b-08de634caa16
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7584
X-Rspamd-Queue-Id: 88D7840006
X-Stat-Signature: hayk5zqz5sk3sgwxfxdonnzar1ok71xu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770141009-430491
X-HE-Meta: U2FsdGVkX18WFlfu+LZa9p4NBfyEVL0T2vy4cLEE7ZjwK+X3UwM+gnvsAmsew/rT8dH73GLNCVgAzSNXtFiIjR/PoauIjY1jSjvXFT7xOwYuxxt6adis/DauFIBBtFKQpyw12HN2Fd1/n73diGu6IvOQaWKD24qblcNS89bKBLcLMITU2KLxC/QEdG0Z3Kuqy/cwoqZuQh+DQwdgCGymxPPdvh7c8kghjQ1tsxXcjZrKooRQzw1XsBOILU59u5+E/c3TGMk/5geliZY+PwiaIYWEYrtS6LDoDTA/oMqHxkCT+1xNn2+ZzMkmT+5R+NMlfkjtZPN9TM/8j36qql5v0Vf7FTAfIb5tXB0+QEJk4IKJDUZdxTgPM6wmXrwDYcRFNYtsrgzustrOkTAGmpbOttievf65S/IuidWBGqDTKBueJQpE0QrI10VBdUJIp2crF9iulINixObB7R2rgUr4Nsg6L9m4H2vNsaKCIO6zuoYQM++mHkYBBAnVoX5S8cbINisvaAo683YjTrnAzrqY1pvrLluaZ3QlG6dAu4LwVK8sHyQjtjqu6qmvCAPKbfX7ahlTO3fs0gPJ9wLM/38n91Z9RecNbB16K2JqeP/bk3zNaVLFK5crFQ1WSM3OVX3fMvVdoIN4wHCN2FQAaJhrHCu+uWbxZ2/kE5A6B5jUx/sfASqjs2VSMHW10bblZxDeawGUMJRShm3d+1GrIojNQA8K6UisiedRCa5d6q2HmMZfsKaj4+zZryhZh9v3KWRyi6MS2W20eVhqaGLBzB989ZKrTEu/IPDwMIKd8+FPzSBu1P4dZIJVlcwmLI1gmicR6SebIOUrkbEaNMCB4zaAszpTbB9TDDInuPtQipbQDoPTjAxjrV2Mve4mEF0bFQhj450DOpPru3AsSR3npNzIHCL66ZvG1ffBma6iu68Ou6bF/mgLpc/ubCUwsifyLIRZPxzyrO2loI/iy0trUWw
 J4BNYGkS
 q0cnzskXI00JofIjRFi05FX1NvdhboUSN32LZu3M9iYvG/UKheeFBTmTIKfjM6M1Nsl78EAeh4cX4wnRyMOHtUhFm76nu/RS1BIl9GoN88ybROaVGGB7w/n6kE99Wi1hX428/+N/HvgPAxwmGtYikidL3niR4GisIl/UO8OLCJCrnK3S7aDuwM8/tProj3tcobZoxNFVzaGkq7i+lRuQFsy0e/+0QYmqRFBpzKzPgjMeoYaxU7Z3SP1sFFFO32AHlMRxB3Q+caUdvVlWEmJniSyXWdVrXd3z2SDgzNqlNj4DXcoXx4BTAfeX4HVeK0l/FO6j+fxsE7OdlYFGFSZc85brWHiFL2hRY/ih9zHrx/DXZd5lRWdLlUhNk9Caxgdp6+fAiupujPWNzlmHTu89RMHVRG2z0Zy0wNMMWOIxsv2Fi1vjGAILmFg+eKixW7Q36u6EYjJWQmbpCFGUwgzgddPAf+W2zHt2XfBVL/0UytXOuv6ofwwkj2wSovJ4WlPIicygnF/Q/zGNRhBp+R/LtDPPznSod+qju+ozKjfnvYlff8QzWgd7I1pEg9Sfa5MIaPN1EV+ugzL5W89atObYhVI540O79T1yd7xQw2kQEuphxGj9mSQzcM90qgWAlKUjFI/yzONuo4/2u1pPb2VUWUX5RFqxJt3E3eEu7SetvxGZP2Wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Confidential computing guests require memory to be accepted before use.
The unaccepted memory bitmap maintained by firmware does not track
most hotplugged memory ranges apart from system memory annotated to be
cold plugged at boot.

Explicitly validate and transition the newly added memory to a private
state, making it usable by the guest.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/firmware/efi/unaccepted_memory.c | 47 ++++++++++++++++++++++++
 include/linux/mm.h                       |  5 +++
 mm/memory_hotplug.c                      |  2 +
 3 files changed, 54 insertions(+)

diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
index c2c067eff634..359779133cb4 100644
--- a/drivers/firmware/efi/unaccepted_memory.c
+++ b/drivers/firmware/efi/unaccepted_memory.c
@@ -209,6 +209,53 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
 	return ret;
 }
 
+/*
+ * Unaccepted memory bitmap only covers initial boot memory and not the
+ * hotpluggable range that is part of SRAT parsing. However, some initial memory
+ * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
+ * that can be hot-removed. Hence post acceptance, only for that range update
+ * the unaccepted bitmap to reflect this change.
+ */
+void accept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+	struct efi_unaccepted_memory *unaccepted;
+	unsigned long range_start, range_len;
+	phys_addr_t end = start + size;
+	u64 phys_base, unit_size;
+	unsigned long flags;
+
+	unaccepted = efi_get_unaccepted_table();
+	if (!unaccepted)
+		return;
+
+	/* Accept hotplug range unconditionally */
+	arch_accept_memory(start, end);
+
+	phys_base = unaccepted->phys_base;
+	unit_size = unaccepted->unit_size;
+
+	/* Only update bitmap for the region that is represented by it */
+	if (start >= phys_base + unaccepted->size * unit_size * BITS_PER_BYTE)
+		return;
+
+	start = max(start, phys_base);
+	if (end < phys_base)
+		return;
+
+	start -= phys_base;
+	end -= phys_base;
+
+	/* Make sure not to overrun the bitmap */
+	end = min(end, unaccepted->size * unit_size * BITS_PER_BYTE);
+
+	range_start = start / unit_size;
+	range_len = DIV_ROUND_UP(end, unit_size) - range_start;
+
+	spin_lock_irqsave(&unaccepted_memory_lock, flags);
+	bitmap_clear(unaccepted->bitmap, range_start, range_len);
+	spin_unlock_irqrestore(&unaccepted_memory_lock, flags);
+}
+
 #ifdef CONFIG_PROC_VMCORE
 static bool unaccepted_memory_vmcore_pfn_is_ram(struct vmcore_cb *cb,
 						unsigned long pfn)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..2d3c1ea40606 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4504,6 +4504,7 @@ int set_anon_vma_name(unsigned long addr, unsigned long size,
 
 bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size);
 void accept_memory(phys_addr_t start, unsigned long size);
+void accept_hotplug_memory(phys_addr_t start, unsigned long size);
 
 #else
 
@@ -4517,6 +4518,10 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
+static inline void accept_hotplug_memory(phys_addr_t start, unsigned long size)
+{
+}
+
 #endif
 
 static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index a63ec679d861..549ccfd190ee 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1567,6 +1567,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	if (!strcmp(res->name, "System RAM"))
 		firmware_map_add_hotplug(start, start + size, "System RAM");
 
+	accept_hotplug_memory(start, size);
+
 	/* device_online() will take the lock when calling online_pages() */
 	mem_hotplug_done();
 
-- 
2.52.0


