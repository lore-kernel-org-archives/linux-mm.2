Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD66EE369F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81826B0005; Thu, 12 Feb 2026 11:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58B86B0088; Thu, 12 Feb 2026 11:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9DD6B008A; Thu, 12 Feb 2026 11:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B92836B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:23:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63DDD8A059
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:23:50 +0000 (UTC)
X-FDA: 84436325820.01.AD9178C
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010033.outbound.protection.outlook.com [52.101.69.33])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E2E4C0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:23:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EdlCiKHC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EdlCiKHC;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf28.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.33 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770913426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JyYm2aSPcnB+9B5G4t+CixgxoRvnHURiXGcB5g3P/1s=;
	b=LqIcwx/Fzw1oy+IAo68foEOYnkDMgs/jlJ4+H86RbwTK/llcwJf9kdPPUffTq6DmtS8jB5
	H6Aw73GJKMKPWKL74tp6BsDonby0CFR5gGUyvSu/7BLBLbeb+IjRx6yodkFsNRG5taA3N/
	Uy1QmMDqLwdJSvuDUrlgCaUobdktIqQ=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1770913426; a=rsa-sha256;
	cv=pass;
	b=dT12CYTI61ESPUxtJllEg7J89rHSSRIBIHiirMpuQuE3PTSZW6Vnf0xGE97dx+T2yLCeg4
	7nPvTh84pDuetmnoXc5Xoul7E9h24eE6eWG5QMxkigfK4ILPUz06asNBOv9NI5HOtE6h1X
	kFQS/HUv3dI+sDOwbxDHuCohkVAuL1k=
ARC-Authentication-Results: i=3;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EdlCiKHC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EdlCiKHC;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf28.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.69.33 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QkJVQjmXyXJVnC6rIv6Iu4URQHl38FFJD4AoxFrO4hP0aFSxRbmlrFFCAtKPEYfAsV6DCSLROEKblFt6FWWIjQ8K3M/KxfBFiZwfwpbtDuIMijb/zSyvPB8idekZVHU8/S79YscwhV63sPys/Tf1t0uKJprL6WH4ewMhtDoN5zlc/PGa8YRxi+K7j4rV2nagblQuIfq2VOXgYKds+iTsrentQzi1TmYiK0MmyR8sHMM7dsg8vlZSf6JTcwpTVBF/vKRdk/97+W/Q0eWXLZkxCEtIInvUwh+Fl12dOTFPnxIAQVpyvJr66+f121EsHMpqfpFK5PKkVgeNNiom1eyYUg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyYm2aSPcnB+9B5G4t+CixgxoRvnHURiXGcB5g3P/1s=;
 b=rNne1K/bIuqAiCcKD6t1fDayIpCimykFu3c0shSb6Z9JRQ+s7XwPZER62NpNhaIbbgeMCKcHgxzF0d3JPoebIJnWlhrMXixYmYVST7F3dNj5sNin/WnVPS1H3vHv4pxde1jU6wgzaB+245N/NEyAWhtat/KQMeSzZkgllDQ7ZFvPiFv4sLRrRQzRfFZCRFu6PAZOd9XYP3cCwet8wTwcKkF04fc36olAX6hGZpUhZcLxZNgyeVh3+3JpqBkdTvqF9O80VCQMv9+VtPMqk4tPntdagW9ItW5Qw7/t1YQWD17PqnjUjOAbH6B24XWy7YkbOyix1y3SwbpnhPgV8agckw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=arm.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=arm.com; dkim=pass (signature was verified) header.d=arm.com;
 arc=pass (0 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com]
 dkim=[1,1,header.d=arm.com] dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyYm2aSPcnB+9B5G4t+CixgxoRvnHURiXGcB5g3P/1s=;
 b=EdlCiKHC6lA4FGXsYcckU5GI1fbe+NvDtdfiao1sJFvDkNZXMmPtb20mlhfPcuKbJtzWnqZqKt1anf0tqeWFCM4KkVlwAdu6r8ShDVZ1Ph3aGpjy2PTKRoZWGUbi2EBCk9FNbFpels+MmfdiphP97SUoRZzN1f8gbRC+jJ9Vz88=
Received: from AS4P190CA0023.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5d0::9)
 by DB4PR08MB8174.eurprd08.prod.outlook.com (2603:10a6:10:382::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Thu, 12 Feb
 2026 16:23:35 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d0:cafe::1b) by AS4P190CA0023.outlook.office365.com
 (2603:10a6:20b:5d0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Thu,
 12 Feb 2026 16:23:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Thu, 12 Feb 2026 16:23:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8KmbKvrqR1RS98KvWW6I1XVSyS0YW7MMS7jEX/NCo6EbSX+FrW6AwbDwnI7MoTNzyWHyMoROj48axkwlhhFcJLNnKZ0izN9e+SpfQky6wqWnq2+7mgm312bLr08Ca7BD1zY2V8Wo8wsNXKDvI3Yd85JK4aOZM6HR3N9+RSknsaw+P0CuqGmIOqZiQSFD30ppxq81YFqCgCln9Gp+qplfwfxZpApVbBDxW9v2jmqXqnqMHhPkG4iEso3Dwtc2oZvlEM3hRx8u6qRBWLso0Xz7d986P+8k8SfvrRAXp6tEs1/gcAIRsK56yv1ZZl6XOwmwbPaPbzXZUiMu7CgeK0iOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyYm2aSPcnB+9B5G4t+CixgxoRvnHURiXGcB5g3P/1s=;
 b=wOnlzata+oGV4Xqs2ZlkLyrW+U29qwZk+tTqTucS8/B9AheFU8orwmzavFmyXeToKQ65jirRtCZbkB0SuWOMTFjnkP1WGet+ZK2omlXduIrSlXfX4kg4k5Xlztlhlv2jK+tLnW+0UwbqQds5tyheGgJB2CLsK4H/FtLt/UwnWc/E0/KRa3NGj3kSJ35wpgmSPJjT+QHdUrknk3J1cCf8Hr1p8txMyMBkT3Hud6Kq5xdl5Uv1cl9mMY/NfaqsYIUg34bTPIkF+Fnw7TgV7I50noUi0Hcn1qTb0UeMbdSCIK0cUZb/rLuJ3s3R5pMMu0n5KdJOqnlRCydLgxiBx3i9rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JyYm2aSPcnB+9B5G4t+CixgxoRvnHURiXGcB5g3P/1s=;
 b=EdlCiKHC6lA4FGXsYcckU5GI1fbe+NvDtdfiao1sJFvDkNZXMmPtb20mlhfPcuKbJtzWnqZqKt1anf0tqeWFCM4KkVlwAdu6r8ShDVZ1Ph3aGpjy2PTKRoZWGUbi2EBCk9FNbFpels+MmfdiphP97SUoRZzN1f8gbRC+jJ9Vz88=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB10931.eurprd08.prod.outlook.com
 (2603:10a6:150:1f3::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Thu, 12 Feb
 2026 16:22:32 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 16:22:32 +0000
Date: Thu, 12 Feb 2026 16:22:29 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: catalin.marinas@arm.com, david@kernel.org, ryan.roberts@arm.com,
	kevin.brodsky@arm.com, sebastian.osterlund@intel.com,
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com,
	yeoreum.yun@arm.com
Subject: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
Message-ID: <aY3+Raf8eZqipCd6@e129823.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB10931:EE_|AM4PEPF00027A6A:EE_|DB4PR08MB8174:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a27ee19-8a8e-4758-3485-08de6a5311c9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?MjNGUUlGV016eXpwN0xyVzVYNDhiTGVWNGVQbXFCbW4zSnhDSE1HdWZPcVA3?=
 =?utf-8?B?Ulk0ZlpVV2ZsN2V6Z0cvai9rRlFMNFFIcnJrTzEzdUhRN1JGT3dzNWRGRmk2?=
 =?utf-8?B?Q211a000anJUekZwWGpUalg5Y2NDSVZTSVY0VE5RWVRBVERJZFhSaXZMOHJ4?=
 =?utf-8?B?NWZacVlyMFEzcXJXdENGVVd2aTl4NUxlempsbWFEUGtSbVZQWEY5elhWRE1x?=
 =?utf-8?B?YXBkaGRYZTFSdGIzNVhYNGFRV0c5ampwZjF1V1hud1QvTE9uR3o0MlNVQy9C?=
 =?utf-8?B?OU1rdTBjRkdWVk1HR0VyWXBtcEVmSTkxNVZQWTdSOVZOdTFlUVhUOHRMUElN?=
 =?utf-8?B?S0w1Zm9mRjRiVkVLeG0xWlBvT2g2RW1oSnlDbkVyVWdQYmE5Um5aRUdnQWFM?=
 =?utf-8?B?NDFVU0pjWmEvK0J6Mk1zU0svVFFleFZ2T2VmVDFSQzBnenBZaktNZ2pyUWJW?=
 =?utf-8?B?SngxTmt6ajFvSW1XVGk0MldYWkhQMFEwM2RHK1ptNDZkWlJpcTBtOVBrR2p5?=
 =?utf-8?B?T3pIZHlIWHVBd3NnQXFxMjcvR2JNUkxxeG1IRjkvZ0dLV1kva1REWlBMNFlZ?=
 =?utf-8?B?eks1ei9vK3I5TnJlZUxJN3pWalBJTUxQUDlRcitzWExBeXQrdjV6dCtCUUp3?=
 =?utf-8?B?REMrdFZOUG1yQWNrOHBQM1p0VGgrZDJIVU1NcEg3UlpNUnF0UnZ6QzJ1dGR6?=
 =?utf-8?B?SnBab2FDZ2JqS1RER3JDbnlWak5tZDgzalFzRTdYL0RUTHpQck5kblJ4RmNM?=
 =?utf-8?B?cGdaemJkNHAyVGgyeEUvMHFQTjMzSXNrTkNaWkZNK1RHckFLUkdCWE8yU1Bp?=
 =?utf-8?B?bkpFMVptNzZseWZuSWRvTy9WUzZnNC9lak81ajNzYkdVTHNZVHY5SUZ1T3o3?=
 =?utf-8?B?QUFSY2hzalY0ZS9NZ211Qkw3eTJ6YXdaTEFCY2JNai8vMVZBdHIwdTVQRjZy?=
 =?utf-8?B?a2NCRGJKTVp1QjVGb2hqejRDMEVJZDg3L1J6dXpzc0Q3YnYyLzh6elR4ODhC?=
 =?utf-8?B?L0pyQ28vcHdYUFloV0ovVlRnRUVMK1hZL0o3ejhaZlZPQXBNT3o5T0JUeVc5?=
 =?utf-8?B?NEdBdjNTLzdOTmkvVDV5b0hlck5oOW1HOGdxelVYQk1nT1llVUgzaGM0Uy9V?=
 =?utf-8?B?Z1h3Z0FySkNpQ0s4U3ZKdnZNNGdNNmhXTDJLK1lUcDViVmd4WUZrU1BFZlB0?=
 =?utf-8?B?cUlMTDVQUWZQUEJQaXE1cCthTFVXeDhKbVFUMElTbkdXYTlhUm0vQ0wrejlx?=
 =?utf-8?B?TzMvSXZlTXRtRWE3YzN6WlphaFB5aTJUOEVEdXVTdzVPNnRzK1VuejJWVVdh?=
 =?utf-8?B?aEgvRjNHbWVOK2hMZTcyVjVhSXQ3UDYxeXNuK0p1a29QdlU2UitGTCtLc2lH?=
 =?utf-8?B?R0FzL2RRVmwzQm9WL2FEVW8wbzVTT1RneGtvYThpOW42eHFHQVBaNmtaK0wr?=
 =?utf-8?B?cEZhVVduclF4cXRrRXlaLzc0eTUrR080WEhreldDWEpiY0hhUjRPSTUydUgy?=
 =?utf-8?B?cVNsRHM1dlZnQm1XcS9UMDRDR0Rsb1pmeHloaWszbVRPK1VvemxUTGR3NlNK?=
 =?utf-8?B?YzFuYVpLQnI5V0dmT1Qyc0s5TzFMQ1ZvWEpNejB1b2MrSXRxWndEd3IrUks5?=
 =?utf-8?B?eGdxaHgxekc3NFBFTXhERWtTekxIcW1kR2hYV2xOb2k2VjlMOFZUWjQrTklM?=
 =?utf-8?B?V0g0MmEyc21WS2lrMExkRGlPc1NBWUtzVWZPb3FRd3Z6L0gzK1ZaVm10RnFR?=
 =?utf-8?B?R1VSY1Zra1ZFVzV3Q1RDam44cWZ5M1l1WTRKbnBtMUc5U3FaNFpnZFBWSFFx?=
 =?utf-8?B?RDM2K05MMUFDZzE2eTdLLzJidGxwVXZhdk1vZ0E1MU5MZlU3dnZEdFpXazdM?=
 =?utf-8?B?YUw1K3NrUzMydVYyM21hcDgybExmRC9wKzYyK0VLL2Zra2JnZ2kyZ3dUaE00?=
 =?utf-8?B?OXZ2QWczdER1WkJaanpwQU9DSlJJejdUY1MrSVNudWNBYXF5a2I1OGRra2sz?=
 =?utf-8?B?OGE3TndERWF4cEwrQzNQbXEvb2tvMVNVc1hRN1I5cXRqUzJ3WG1iNVFpaFhF?=
 =?utf-8?Q?rBtcce?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10931
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	da24f9df-f0d8-4a59-1f03-08de6a52ec55
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700013|376014|35042699022|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHZJLzVmV0NrWTdtTjl3K0F3bjEwRDBCQkQ2NzlSS2ttSDlna1htVnErVjd3?=
 =?utf-8?B?OUJDSFJaNG5zMzErbUVRTDVYTkk3R3BWTVhaOFFVUFIySVdRYkRQUXoyVWlW?=
 =?utf-8?B?M3NRcUI2SXZBMUtRZzdHWUdQVDY2QU9RWTlvcER0cHlPeENkdEx3WmdxSjRS?=
 =?utf-8?B?Z3NSdHBpRnM4R1RYS3ZWSzFLdGpRa2NnWDNyajJGdUtQaDh4b05FWGsrY0hH?=
 =?utf-8?B?aHZQVGYrRVlnYUZtTmtDZVArZ1hyMDZiS3JOcHRHUjlXcUE4RHJPaGwvVHpK?=
 =?utf-8?B?MUN2cVJiUjJnNXppYVRQVXM4UnBhZ3JmYVpaZnF2ZlRNSmtuMEJhSlJqVnh0?=
 =?utf-8?B?ckZSZ2hNelZJKzd1Y1lwT0pONlJxbjNMeWd2QjZwTFU4NTVSbXNJeC9YT0Mz?=
 =?utf-8?B?YVdyMWdRbFRkUHU4YlY4dVY0RzZ4bDJxWVpqOXkzN3ZoVEdaRkZJUWhKcnNK?=
 =?utf-8?B?b1d5SzZ3V1czTVgvcGJtSDRaU3dyRWdtcW1XSW5DRzhjdUh4VTNNdld6b2pY?=
 =?utf-8?B?bHRUQ1NqWDNlU0hsV1gxVTRlRG1rM1A2UEtVS3ZsNEdpaVlLdTF2SGREbWU5?=
 =?utf-8?B?VkFNcjE2VUE0TnREQ3kwK0RBZDZBQTJoNERnMjJWSXBESnJpNUNMR0tVT3dI?=
 =?utf-8?B?aGljSU5NMHRpZEVHZWRnblNOVDN1SXltVEJFWjR0bkNxUmJ0M3ZqQWhkRDRT?=
 =?utf-8?B?QkQyaVlKMkhSUFJwREhVbEFxOFdLN3hDWDlkVkYrMERiVHJsc1RzRnNCU0hq?=
 =?utf-8?B?ZHBMKzZRMUdYTGlBeWVZaDR2dkY0Q01yUUJkQXFHbVpPWEpIUnAvSHRYUndh?=
 =?utf-8?B?Qk5mYzJrZitSTVNYa0syTStweGxGcDA1Q0NXMUVlK2hQaWpqelZraEhiTTJx?=
 =?utf-8?B?bDZkbUk3Ni9LVk9QYzhPVkxleVhZcHRaa29QbThPME9MTmcwQ3JHeExNL2w5?=
 =?utf-8?B?ZnFiTkZLYit5dzNJdi9weHNEcTI1a25JV0JwbWlyckQxTnlMVXhaYUJYelgx?=
 =?utf-8?B?UHpkMkhURnF4b0ZwTHUzcU5CSG03bUNBY0piTkRzbDlIWVhaU2d1WmFuNWpn?=
 =?utf-8?B?UEtmeThrYjc0TG5uemVWNDcrcmxYTVQ5ZHdMMUVTdXpNMW1KN3FOSisyYk5V?=
 =?utf-8?B?NU9mVjZtWXdwY01IbWJIb2xKdTdBV0YzYWhQejJJc2VqSlJ4U2JmMXBsK2o2?=
 =?utf-8?B?RFFpSmlHU20vdWVUMWIvTVlON2JMM0xGWXpxRHAwNTF1Z2I2cXNvMi8vbXFr?=
 =?utf-8?B?dDlrcWl5OCswMkR5RGJYcEJTalZKYURlWW1vTzVkejVSbjVod01PczIvZjBT?=
 =?utf-8?B?WjJzK05SQWh3RWdieDQwU255d09vcXJPVThWdllXT0pXY1B5eEtROW9CZEQ3?=
 =?utf-8?B?UkFEQURoNjdOTjVXd0JzZVdCQXdjMjBRMjdEYmUxdE1MYVBobEFwbTJNUnNQ?=
 =?utf-8?B?cVNTN1VIRkQwc1c5N1Z6bDNqYm01b0hZL0M2RjNHc0xpb2tQN1FXMmJSbkFJ?=
 =?utf-8?B?MmZ5dy82UTZmVjhUTldHK01zelpObjNORFhFUGFCWUwraEhhYWpudWdHdW5q?=
 =?utf-8?B?dHVxNU5oZU16VjlubVczZ1FobS9ld0NXUWJtVmtDVlRDZkt3aW50QTJwRSt2?=
 =?utf-8?B?M0lyN0dpSUJ2Z3haY1FuTU9jeGpWZzVGRlhnSTBJZ3h5Yno3dXpVVzA3Z1A3?=
 =?utf-8?B?VVVEVTlMcXYwRUk1d0ZHSUc1elZheGk3WnBpRm0zaFJKNk9zeERlaTNpbkN5?=
 =?utf-8?B?cmF3cEV4dlRzblpFdWFBb3RlSGh1ZGlWN1dXNlVOaVIreENhUmI4RjdjVTgw?=
 =?utf-8?B?TGZRT3Ztd2RhbWlZa3MvYWRGb0d6Z3oybTN0cmJRc1hiQ0JkN3hCc0tpZGJJ?=
 =?utf-8?B?VGRsUGdVL1pUaVFvTjlzYXowTEcxN3gySFRwWlpYTzFtcXU3bXp6WkRNeTdr?=
 =?utf-8?B?aUdYRDM2enhQeVdFbjcvbnYrUEF0TElmRlZwU0l2bU8zcXZFMFRIdXhYYjZr?=
 =?utf-8?B?UVkvUzVvT2pLVEZqaDNxUkVSV1JpOG43MHUwc0d3SFV3ellXZGRodkZwL1JS?=
 =?utf-8?B?RjViNGF4RUN4ajlBQy9kUGs5YVl2RHhmcG91KzVkQ043VE1rYmhFSUhveWgw?=
 =?utf-8?B?VFlDZUo5bEFKcEh6bU5sZDFEVTZYelBMVHE4Tk1mdjZUVFJMVE5pWUNCQXl5?=
 =?utf-8?Q?CMEHmu7OHYuQhZlfITNazGc=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700013)(376014)(35042699022)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Wsmn1JqWSQOXtdDZuho7lCglbBXo6e+QzK+EnkYHxilF8woCKZGMbCmZgYgvCSy1XHKA5h5eHcr3TJmH5iFmiRbHfIaSTSvbRHNLtBxBXKxjtAr71+iRT15XZpToZrsXdmyFJqeJLUlvwTK6fDPq2jw91OneerOGfScHZgYYU0MR7dK6VE39G2sy25UbyqRNbdXy6YYZAaSzE+RM+znj+MvVI6srjCHx3jO77RKuxun8yeDLW9XFoexa+leDqb03b3uyI7X+Pyqj0p4JZzBaFm/dqFyYjTekwQA4876AOq0awb5lm8kj1QspiwC+7P2VnQqqWNO7I+DzRDs7Z+4Dk2yQw4GucuSxM9s3QoUJvVbp5r4pi+YD7Xd2lN/62+i2jYNBUQzAYViikRXooHT5h91LhShAj3cfFfjhgRxboiaj2ioHx8HbIWYTwk5yk4c4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:23:34.5498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a27ee19-8a8e-4758-3485-08de6a5311c9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8174
X-Rspamd-Queue-Id: 4E2E4C0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: z671uyw3tujr9jkgsno8kkrs9mi4zpq9
X-HE-Tag: 1770913426-944587
X-HE-Meta: U2FsdGVkX1/5BUv/fgKSStgNFoMS0G9Pp5AOhjwsBTskhOGZPTf/EpimQb/qeFiezrvTnZ/Md/tajJqDIALVqarF9e7L0GmBgQdlqZ/cQAW2JduM4lhXrDQlKMVpYh3WVYhZ5xNzmRoESfj2QxqiEm8ODQi8SU7+XzS3ux6JUuwe9cbTcmRJ4X/DmS+q4jJi//yiMf4A8HXRowcaWEZ4VaM4eGlD+wfejvWJRz0lyuyprwAO7GyGzCiagYOznUi9hqPOC6jpvQKN0Jt39VCO6+uim/uwfU3qoZO1wSfSkBo/d3EFVoCpru14+SpBH/JDZWqH3ywtLfrfaV8gzBIamo8BeW5HjW/YfY48pVisWN6gCvrPXd6Gz9abnmOmKdWj6dD6Bj+mRHa7vMK5ZEWyrqjbjkxw8zPM/bxxTqfrRW9NyuIEZ6vHGVAbuTIQeuoqOw/dEQOi7NyX17dH8vt7FsVLPnI+1ZJ01x6elzEWxC5ZBAj0VQJZp0S5m6qzwWJJxKURCoxtDvTPnYZ5lKvgnEQ+PAXOJcGz99Oc/A3gghEdIpdoTwPnCXHeEh1+Dfi5oPfrYLjkNwVfVfwUx9JtExjA2eaik+LjNixsItmRTNr22zy+oMrTR/WbCL7vY1H8zDfdeVxwJC5wDF6tOLvJOwJv0WNq989kwoYmd25KhuAGSqI0mRpdQ3mwNSy9IX2Cg5JEtv9Rm7p+q6TbVbcLXhvyla5ZOBcPe/75cWC7R50+lbRqvVHVXWMmWZAWvJ4r30UqS1pp9UTnfX7uWPkzUqZwXzzJTbQ1TfsrJ4r+rwuB8wNK9rIiH5DLRTzC4D7sMIcByauaY/wx42p1fL4f6ASpE1YRGpkxsFCq54XCYResyS5X2sS8A7+QZHizKcra/0mc3MMpn871Anz6cp15NF2a72YP+jMjnyeiAKEpsTYO3GwFgUWFBuXHzjRAcbkpGii6OBX+bPdDkqKXryk
 GPzNvLNS
 pDXUK8JyVlB9jR+9sLoDYNl+l9wK++sjgzkA4oZDqvreQDRvl69nqSBxkdpXowR4kra4aOxlJf5vIFxy0+LkmC9xoiHhBWMm1UOCsl4/CwzNLmT/7/dEHofTPFU+tLXwfglzbPmNBB0aHFFY7OqozYyb63SWpCQ/kLDtHQ3PZW9OnKbe7pjCNPiT0iADPLDiKu8wpyAvS8SdPJU76M5R07bL3B9wYBLdT/7jRFohtsdB+gkWkmTWPEMOH0C3oZNRr2wG+pymWeAuZDQgPPffXwDcZQm6v6ExZcrB1QrQpy8JH3rk15xt2bT/qkM9G6vVLnwH7bqTSGeky9Em54j1W3LFhlh2r5o99fGAsLK7XKVbLEMWMhgC2S6FTxBzw9xE8W7ix5OoxrMNPGmFqCXpg9vGIigsa1Nb+x0nErR+F+uzlE5Aq5Jv10s700Dreego33sS3+IHrpOCa78ZOJiYmlAP8CqBKNLbDZ8HOOf+esufJrvk3EqWEIGl2w71ZYNeLBqPkqBIylvjUDLu9MiOiAZVepecww01cjNF8pmyHQxXjiCRvJJUOoSvMiKFFTT0o2PR0YnQ0m649QAZvtUqdS4uLMTGON9s7gSAPmGdbWr8KElSPo8I8eVdtMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I would like to propose the topic of eBPF isolation with pkeys at the
upcoming LSF/MM/BPF summit.


Background
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Today, eBPF programs provide powerful capabilities to extend kernel
functionality without requiring modifications to the kernel itself.
These capabilities are largely enabled by the eBPF verifier, which
enforces memory safety and other constraints to protect the kernel.

However, vulnerabilities in the verifier have repeatedly demonstrated that
eBPF programs can also become a serious attack surface.  In several cases,
flaws in verifier logic have allowed malicious eBPF programs to bypass
safety guarantees and compromise kernel security.

Representative CVEs include:

     - CVE-2020-8835   [1]
     - CVE-2021-3490   [2]
     - CVE-2022-23222  [3]
     - CVE-2023-2163   [4]

To mitigate security risks arising from verifier vulnerabilities, this
proposal introduces an approach to isolate eBPF programs using pkeys
implemented on top of the ARMv8.9 Permission Overlay Extension (POE) in
arm64 [5].


eBPF isolation with pkeys
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The goals of eBPF isolation are as follows:

  1. Prohibit eBPF programs from writing to memory that they
     are not permitted to access.

  2. Prohibit eBPF programs from executing memory that they are
     not permitted to access.

  3. Allow kernel memory writes and code execution only through controlled
     interfaces such as KFUNCS and BPF helpers.

Conceptually, the model can be illustrated as follows:
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=90
=E2=94=82                                     executable memory (RO)       =
=E2=94=82
=E2=94=82            =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90          =E2=94=8C=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90   =E2=94=82
=E2=94=82            =E2=94=82          =E2=94=82          =E2=94=82       =
 =E2=94=82         =E2=94=82        =E2=94=82   =E2=94=82
=E2=94=82            =E2=94=82  KFUNCS  =E2=94=82  allowed =E2=94=82  BPF  =
 =E2=94=82         =E2=94=82  BPF   =E2=94=82   =E2=94=82
=E2=94=82            =E2=94=82          =E2=94=82=E2=97=84=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4=
  PROG  =E2=97=84=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=96=BA  PROG  =E2=94=82   =E2=94=82
=E2=94=82            =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98          =E2=94=82  =
      =E2=94=82         =E2=94=82        =E2=94=82   =E2=94=82
=E2=94=82                                  =E2=94=9C=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98         =E2=94=
=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=A4   =E2=94=82
=E2=94=82                                  =E2=94=82                       =
    =E2=94=82   =E2=94=82
=E2=94=82                                  =E2=94=82              =E2=94=8C=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90   =E2=94=82   =E2=94=82
=E2=94=82               =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90      =E2=
=94=82              =E2=94=82        =E2=94=82   =E2=94=82   =E2=94=82
=E2=94=82               =E2=94=82 arbitrary =E2=94=82=E2=97=84=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80X-=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=A4  BPF   =E2=94=82   =E2=94=82   =E2=94=82
=E2=94=82               =E2=94=82    w/x    =E2=94=82      =E2=94=82       =
       =E2=94=82  PROG  =E2=94=82   =E2=94=82   =E2=94=82
=E2=94=82               =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98      =E2=
=94=82              =E2=94=82        =E2=94=82   =E2=94=82   =E2=94=82
=E2=94=82                                  =E2=94=82              =E2=94=94=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98   =E2=94=82   =E2=94=82
=E2=94=82                                  =E2=94=82                       =
    =E2=94=82   =E2=94=82
=E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=97=84=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90               =E2=94=82    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90             =E2=94=82  =
 =E2=94=82
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98    =E2=94=9C=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=90   =E2=94=82    =E2=94=82        =E2=94=82             =E2=94=82  =
 =E2=94=82
=E2=94=82                  =E2=94=82    BPF    =E2=94=82=E2=97=84=E2=94=80=
=E2=94=80=E2=94=BC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=A4  BPF   =E2=
=94=82             =E2=94=82   =E2=94=82
=E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=90=E2=97=84=E2=94=80=E2=94=80=E2=94=80=E2=
=94=A4  HELPERS  =E2=94=82   =E2=94=82    =E2=94=82  PROG  =E2=94=82       =
      =E2=94=82   =E2=94=82
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=98    =E2=94=94=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=98   =E2=94=82    =E2=94=82        =E2=94=82             =E2=94=82  =
 =E2=94=82
=E2=94=82                                  =E2=94=94=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98   =E2=94=82
=E2=94=82                                                                  =
=E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98

eBPF isolation is implemented by operating with some pkeys for example:

  - PKEY_DEFAULT: used for general kernel memory
  - PKEY_EBPF   : used for memory owned by eBPF programs

Additionally, an extra pkey can be used for specific data or code that is
shared between the core kernel and eBPF programs.

During execution, if an eBPF program attempts to access memory marked with
PKEY_DEFAULT without going through KFUNCS or BPF helpers, a permission
overlay fault is raised by the hardware.

As a result, even if a malicious eBPF program is loaded due to a verifier
vulnerability, any attempt to arbitrarily modify or execute kernel memory
will cause the program to fault and terminate.

This prevents further exploitation and significantly reduces the impact of
verifier bugs.


Goals of the discussion
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The goal of this session is to share concrete ideas on how eBPF isolation
can be implemented using pkeys.

To achieve effective isolation, all memory directly accessible by eBPF
programs must be marked with non-default pkey.  This requires kernel memory
allocators to become pkeys aware.

To that end, this discussion introduces a set of new allocator APIs and
explores more extensible API designs:

  - kmalloc_pkey series
  - vmalloc_pkey series
  - alloc_percpu_pkey series

We also aim to discuss how existing kernel allocators can be internally
extended to propagate and enforce pkey information.


Current status
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

An RFC series is planned for around Q2 2026, and the experimental
implementations for eBPF isolation with pkey and pkey-aware memory
allocators have already been completed internally.  Using these
implementations, we verified that eBPF programs running under isolation
successfully execute several sched_ext applications provided by
tools/sched_ext, as well as some bpf kselftest cases.


Reference
=3D=3D=3D=3D=3D=3D=3D=3D=3D

[1] https://www.zerodayinitiative.com/blog/2020/4/8/cve-2020-8835-linux-ker=
nel-privilege-escalation-via-improper-ebpf-program-verification
[2] https://github.com/chompie1337/Linux_LPE_eBPF_CVE-2021-3490
[3] https://github.com/tr3ee/CVE-2022-23222
[4] https://bughunters.google.com/blog/a-deep-dive-into-cve-2023-2163-how-w=
e-found-and-fixed-an-ebpf-linux-kernel-vulnerability
[5] https://developer.arm.com/community/arm-community-blogs/b/architectures=
-and-processors-blog/posts/arm-a-profile-architecture-2022


--
Sincerely,
Yeoreum Yun
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

