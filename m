Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E1DCD13D3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 07:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CE68E000D; Wed, 12 Nov 2025 02:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D768E0002; Wed, 12 Nov 2025 02:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04E68E000D; Wed, 12 Nov 2025 02:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BAFDA8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:30:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6144112D8E1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:34 +0000 (UTC)
X-FDA: 84101132388.15.F9427C9
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010057.outbound.protection.outlook.com [40.93.198.57])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6596CA0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:30:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=avoEzBdC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.57 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762932631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQQMX/nlAJhaBEBziG2NLFNNdRLNtD2k+Os9agqVAPc=;
	b=BOGYcNLN1sh4rpulQX4BUgls+lYxnaa3Umg14HQ+CeyJoHow91e6K2b/snqx70ylsLhVVZ
	1C4S/QLhAqv8C3lqzxN7bi0QqnTHCH3BmvvesLDJaYp6xKFNKIJcyqvdl2acO611k4Aaeb
	JfSo+d4oNLiKRE9Zg+/OPFLkajXwpTo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=avoEzBdC;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.93.198.57 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762932631; a=rsa-sha256;
	cv=pass;
	b=CcxXGNMVjh7PnpoZoEvdpfD9UeB+kjTKMrnjjyHxdwVxFe6IAcIJ/kJN0cHoE+f7dAcMh+
	OJKznGXUVhPsgGurz4bdnRGfdPt34JYd643/CgZfVl8xHakuWjQ3hkj0qIVLDFsx0AIltH
	TcS1dZMnDGfcspU8Zq+uG9CkMxCPR0A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5QPHN6LXZHw9oVg08IkKNGj/Q+xpNDa5M2KXk6tg4RDy7Pq28Cb6Wh2+KOsGqWTyLASAN2M2ZC57adDMd1NCZahBwtbOn0Ifu+M2TVDsrvDNkhYk1H+KzgotOzeLHkjMJ08mD4kF6jw2Q8xYE6lLkq9L/XryDXyXUZHc3grfgh7+xkgE8LsIOVijjAa/PTzSuvtEwhXNLA13VEjhBwBFztDhUiWyR0+9qQddrlKnllQfDFakbybOcGyAR3Syni83zEiwUTXDmEN6XA3Tuzi3TpOjVGAOx06YW/swV00Rts2DGqSAud6rO1tDUMTrkj69SOvCP/bq4Qn5FZ3jTRm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQQMX/nlAJhaBEBziG2NLFNNdRLNtD2k+Os9agqVAPc=;
 b=o2Iqb+0ykmhrsuMZ24MJDYMBOXnSJPxej4ULGM8HNgNDPGPmuZ0eOcPi/IBXCvn56qRebZCkW9x6e2KrKsw5CvDLZxmxpBDS//frpH5m4tS6JCu2nN8n2hTbdZE8pkpIIjrkjya9qxXZS0Xq6DMsd5IErmc4JA9B3V5qrBVwTmxNW7f1cgftdRfPeoTWwODmsvDLwOt/p8xpT4of+6o8wGNdZjbk2U/7sCT+dmQ/Ok2Em4nwNkmkhf7RB337wojzStt0lKOkYEXqiTRHuKFWKp7AlGcE2OeE4FAmdllb/OX1sWxGA2yZyFq7N6s6VDq5S1kvyLO+NCpTRyL4pzJRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQQMX/nlAJhaBEBziG2NLFNNdRLNtD2k+Os9agqVAPc=;
 b=avoEzBdCOmgqr477M5oAAKeCtp8EWQPZcSQsf7dohay4F7nTsUaNLRi+18IkW8zhjbQ9FOcCCqtClWTBXdDoM0SiU2Xmqwe5uwnaaXWpSa2tnXrQcHbjrcdL1VDucuLmJEJc7nTYFD76F6zlBzv4+PGu9Xb1szdGULKUK+Plh4g=
Received: from CH5P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::11)
 by SJ2PR12MB9088.namprd12.prod.outlook.com (2603:10b6:a03:565::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 07:30:27 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:1ef:cafe::2) by CH5P220CA0009.outlook.office365.com
 (2603:10b6:610:1ef::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Wed,
 12 Nov 2025 07:30:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 07:30:26 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 11 Nov
 2025 23:30:08 -0800
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuang@amd.com>,
	Honglei Huang <Honglei1.Huang@amd.com>
Subject: [PATCH 5/5] drm/amdkfd: Wire up SVM ranges ioctl handler
Date: Wed, 12 Nov 2025 15:29:10 +0800
Message-ID: <20251112072910.3716944-6-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251112072910.3716944-1-honglei1.huang@amd.com>
References: <20251112072910.3716944-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|SJ2PR12MB9088:EE_
X-MS-Office365-Filtering-Correlation-Id: a613e7ff-c707-4875-d7ca-08de21bd596f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4gjWFkOZo3vQOUY2/EIfBEq5s6HBpOoiRqoqKteCe7vd4MgY38qBtYeCdBhG?=
 =?us-ascii?Q?SaoQcmg3FIkqMPCnzj66srwLCMfaQ3THUDZSepLyg79m/hRW1SaKefK4/Y/O?=
 =?us-ascii?Q?Fvyzvp5RsOtQmZ652O0M2AXSyrhkSpH55MWYi0Jp5ralVrkEJHBs3g4yZsq7?=
 =?us-ascii?Q?IcFTrMUEO3ROd9L8HUgAtD0K/qtcGmD7XK3IQnLAfTQBN7hDIw8Z6jS1l4DN?=
 =?us-ascii?Q?mdkQAWKv9sRNlQeyVFM4GRuvvyqBMnfqIIgKq3TU8ZGHuwGzCCKriQhNAuxP?=
 =?us-ascii?Q?zTsE0SIh0FNhQC5tX9FxGymfgin93iCoOBETSAcf9x97UJpuRkLYEj6G1tpw?=
 =?us-ascii?Q?finBWlaRpC+4DjX80WDNZf5RJKNEAu2Yo9X2FEgzIXXdn5ZIfNAOUKctE/bz?=
 =?us-ascii?Q?1OanDaeFTc2j2EyjpnZuezD+6NyLe6UgpjPWZNwiDxnXC0MAertKvglbNN1S?=
 =?us-ascii?Q?me1hamOtH7w0yfhGpuhuZm+BeJd4VsuUnllFMw8i3FyU0t1Y+Ax95gKUD+4U?=
 =?us-ascii?Q?eTD2g3haC44dqAmg/uFHxSUdjHH21Kgptc3vC60AEFXpZQyBS1U7nTnkRPgO?=
 =?us-ascii?Q?33rrYHzYotiaAtg6otCyhd6aqTp/M1DgwHbCTuinYbjLriTPLgoZLHZSWJBF?=
 =?us-ascii?Q?rVKCWTD+jC28R+H5HefC19gY5JNHNbxgfRsEjafLrKgRUqayY2/xjcoCB/xX?=
 =?us-ascii?Q?itf8mgspy+N+2LugRDShMRF6I4OrNDfmpgysnlPOO8V+r0QbIoHwKRzFeeps?=
 =?us-ascii?Q?QTy2F09we5EtcgT4bsevU3Nikh5/QLjGRHz8xLDmJQblwm6PLuLdllTRdvIP?=
 =?us-ascii?Q?XdoUSWw2N2n4VJJOBxRlbEMCKRvSVIUgxPB4iGWezXZs3c51UPYBqcwTcQuB?=
 =?us-ascii?Q?Ek79moQDvPBZqbrvqgDX1RwxHXm3b9jlOS69gQwSgCaAnd87wzHHbICzKlWt?=
 =?us-ascii?Q?KQ+HxDOvhkz4ATrbSBs5kO1HmIZ2MGY8oTnyYqgizynRQXHkITXN6sR9lkm7?=
 =?us-ascii?Q?E+u3yxbwHwSONNKUuWUttQzYPr5oOF2kA2h2LiulJxvEKT1WUpgqdA4JrP5d?=
 =?us-ascii?Q?BmM5ZBUHccPDPqxosXJzJTV8UN+4zBrXBityRGdSm7qlmVl6oVTriILYQaJM?=
 =?us-ascii?Q?NR9RvUAQDqG4RXOPsIWrJ+HsATTO4AnS0HCE3naC0EGV34lZvYce5Xcbab4F?=
 =?us-ascii?Q?LgQy9SmVB/1WZD99zH0h6ypjR9f/ASV7sS4anTvVLrdWlmZKqrIKpPxDFL/z?=
 =?us-ascii?Q?S1QNyUz5i4IV4/WE84hlOgtQa+JCCDi8WE+HcI5hHUsiq5kZCVormThlC8nl?=
 =?us-ascii?Q?L7ThjQ3dkxKbTWiLag/YImGHZzFg6kLG+S2M1CgpER5J3bfBXz8rSNpyrqpz?=
 =?us-ascii?Q?54T4SoGbSjAEyp5fGsV/a22V7Vqz9jEj0WclsBlocHHdq6MQTlENxSYDF81G?=
 =?us-ascii?Q?zo7kHQY7fhSOpdTHS+YfIJ3FLgM/Ab8huCyGTjkyWON2bU7Mep4dtBkhP9Yb?=
 =?us-ascii?Q?eP/0ElRnahwOU4P2ZXL9LVEownn2fPnKVcZHtVYH7O+1F//S7r7+xWZzS13+?=
 =?us-ascii?Q?H5zbPl4K3dnwYOc59eM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 07:30:26.5691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a613e7ff-c707-4875-d7ca-08de21bd596f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9088
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6596CA0006
X-Stat-Signature: jwhukcxrb4esxjsgmkouuhh6yotc9jhj
X-Rspam-User: 
X-HE-Tag: 1762932631-467131
X-HE-Meta: U2FsdGVkX19De9CFiIaxA/HniPiMKGbaiFP0PSIjCkDR72Wd/GMhlmET/M1f0ZFIwQg/5VvIjyNmJ1atxjRxKty77BRvO62xMrAohonKDgmrWHGgAXthAPn6H7CZ9FBo/WV/5FfIkfA9VDUKs3Ajrig/sGU7WY8AKLnj5RH+rwZ/4eTkdy65j8x6JtPZvaszINftDQzdgzUfRA0kpqbbbybWattt/W0LHi/VGHsX8lU29Aj5RIsmSq4mxxHkcNpV6tQ7hBpv0bWJhymNdPFMTHnnZyMCTja/wwBYRtWic9kVG/l23RteM1KFXlmJXl3RU3aXOtYJVFpAxcKLggEIlCAzUoC0ukpaeWilqoCCRZ7vpLP1miLG2NO7wZH12zqubhsoEkvm2QdBdkjFDC3wVj0g1HBDzHFA5sWD2EDdFlXyYKLEbPhV6/mhVRtccpyjUbL1Ql05GFtP2NqDeQmwmc+Pf2Gc+UvmloCoqTk8NtJWVQc5tHnF3yXMO13N3PC+vACrOAuMl6GY1qP15HP6iAP283I6iEYbEs7sxw3TzAhEXfOHrgVM41AgLMixABQjhVT817OCU4Gv8S3QlfVeuIUFjErw1MdIkFtIkUlYxJKqGrOisdsbEAOIkfnenHPTDMhHLJeG1gsZLQ8kjTbuxlru1a+Ka92M1KF5lkNlkzheV0C1AUzxKNBHs2rUet6yRRh5GPK/Ku4MhVKGoMaqB272rVAltN+9F5PK5ARy5q9m3DWuApha+HWZ1zMESvGpA7yXfz2GlP07rhtVAEN4pEQpav9FF/Pvc8PaCLXMMt4+1g8OsmSDhKKnjxxUVxf1wDUD++JRo5KenM3VvENYwScvgSxvf08RTuTPHvkdiy8BLS5s8hJKPVbtpuU5p7PSWG5mcpNT9rawGLwwjMQsiTFthlQzjiVcuc9xQmb3yenj4tGkQXHvuDQC01yuU/M1HLAQ7oMVBWR8OBdBf/T
 yrpHSx0S
 nGKRBFOb4ag5tyFfWcV3hJIRu6f6SZDu2nrY87R4zXGyz9zr3PIyah6r5yPIQyZfxtFIUnv5QjAmtM89o7L5vOe9DoF88+QsrphzkUNsIUsyhbOjB2eSHOQoGW/L+Ak2kZ/w4f2isF2wQZHeu6C5fOke3+N08+Baf/ELiC91jsz3ejZsMbU28D2kOqGsu00zpbmr9NtZIKK7vT7zoP2ogmlfpWS2Uhmqw55wFP1oOVkYqPmcXxvDMiEybwhKshyYoE1tkOoID3fDsDaWqu2y+xPTjjqPDINnIlv8SQ0naZoNL1HxlQgJXV+VJzkjTPdkWmqn2N/xY+RKAobt46/tXQ/wM2i1Z/MeAL67o0R3Y7DH3BhVJ1WZu0jWQjBW0ZEgt0H4Rs9Mj7a6YY2DsaMZmhaoz1H6HqEnPgGU/h6lrlgJRJmBg+o7FStys5EZUgwAnYjElDQESZ0sFfOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <Honglei1.Huang@amd.com>

Implement the kfd_ioctl_svm_ranges() handler that integrates the
SVM ranges functionality:

1. kfd_ioctl_svm_ranges() implementation:
   - Validate input parameters (ranges, attributes, addresses)
   - Copy range descriptors and attributes from userspace
   - Call svm_pin_user_ranges() to pin the specified memory ranges
   - Construct kfd_ioctl_svm_args and invoke existing kfd_ioctl_svm()
   - Properly handle memory allocation and cleanup on error paths

2. Extend attribute handling:
   - svm_range_check_attr(): Accept KFD_IOCTL_SVM_ATTR_MAPPED attribute
   - svm_range_apply_attrs(): Set prange->is_map when MAPPED attr present
   - svm_range_is_same_attrs(): Force update when MAPPED attribute used
   - svm_range_has_mapped_attr(): Helper to detect MAPPED in attr list

3. Register ioctl in amdkfd_ioctls table:
   - Add AMDKFD_IOC_SVM_RANGES entry with kfd_ioctl_svm_ranges handler
   - No special flags required (use default permissions)

This completes the implementation of batch SVM range registration,
allowing userspace to efficiently register multiple non-contiguous
memory buffers with a single ioctl call.

The implementation reuses existing SVM infrastructure while adding
the ability to handle pre-pinned memory pages, reducing overhead
for applications that need to register many scattered allocations.

Signed-off-by: Honglei Huang <Honglei1.Huang@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_chardev.c | 67 ++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index fdf171ad4a3c..7e7e00d3f873 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1739,6 +1739,70 @@ static int kfd_ioctl_svm(struct file *filep, struct kfd_process *p, void *data)
 
 	return r;
 }
+
+static int kfd_ioctl_svm_ranges(struct file *filep, struct kfd_process *p,
+				void *data)
+{
+	struct kfd_ioctl_svm_ranges_args *args = data;
+	struct kfd_ioctl_svm_args *svm_args;
+	int r = 0, err;
+	struct kfd_ioctl_svm_range *ranges;
+	size_t sattr;
+
+	if (!args->nranges || !args->ranges_ptr)
+		return -EINVAL;
+	if (!args->start_addr || !args->size)
+		return -EINVAL;
+
+	pr_debug("start 0x%llx size 0x%llx op 0x%x nattr 0x%x nranges 0x%x\n",
+		 args->start_addr, args->size, args->op, args->nattr, args->nranges);
+
+	if (args->nranges && args->ranges_ptr) {
+		ranges = kvmalloc_array(args->nranges, sizeof(*ranges),
+					GFP_KERNEL);
+		if (!ranges)
+			return -ENOMEM;
+
+		err = copy_from_user(ranges, (void __user *)args->ranges_ptr,
+				     args->nranges * sizeof(*ranges));
+		if (err != 0) {
+			kvfree(ranges);
+			return -EFAULT;
+		}
+
+		r = svm_pin_user_ranges(p, args->start_addr, args->size, ranges,
+					args->nranges);
+
+		kvfree(ranges);
+
+		if (r)
+			return r;
+	}
+
+	sattr = args->nattr * sizeof(struct kfd_ioctl_svm_attribute);
+
+	svm_args = kvmalloc(sizeof(*svm_args) + sattr, GFP_KERNEL);
+	if (!svm_args)
+		return -ENOMEM;
+
+	svm_args->start_addr = args->start_addr;
+	svm_args->size = args->size;
+	svm_args->nattr = args->nattr;
+	svm_args->op = args->op;
+
+	err = copy_from_user(&svm_args->attrs[0], (void __user *)args->attrs_ptr,
+			     sattr);
+	if (err != 0) {
+		kvfree(svm_args);
+		return -EFAULT;
+	}
+
+	r = kfd_ioctl_svm(filep, p, svm_args);
+
+	kvfree(svm_args);
+	return r;
+}
+
 #else
 static int kfd_ioctl_set_xnack_mode(struct file *filep,
 				    struct kfd_process *p, void *data)
@@ -3226,6 +3290,9 @@ static const struct amdkfd_ioctl_desc amdkfd_ioctls[] = {
 
 	AMDKFD_IOCTL_DEF(AMDKFD_IOC_DBG_TRAP,
 			kfd_ioctl_set_debug_trap, 0),
+
+	AMDKFD_IOCTL_DEF(AMDKFD_IOC_SVM_RANGES, 
+			kfd_ioctl_svm_ranges, 0),
 };
 
 #define AMDKFD_CORE_IOCTL_COUNT	ARRAY_SIZE(amdkfd_ioctls)
-- 
2.34.1


