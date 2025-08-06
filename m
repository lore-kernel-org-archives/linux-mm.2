Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29DEC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881D48E000F; Wed,  6 Aug 2025 15:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833108E0002; Wed,  6 Aug 2025 15:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748C98E000F; Wed,  6 Aug 2025 15:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 690E78E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:07:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18707160704
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:07:30 +0000 (UTC)
X-FDA: 83747266260.10.48DD9A5
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 60FF5A000E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:07:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lberwGMD;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754507247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxzrqLQwms0advTiJxY0X0FCdV3ytmB+YBrBMMbhrH4=;
	b=Lo37U50yU6Qisxs6i1t8su8k8vmWjuWx6RJCVRmFxVGHYGayycCt4BNnsIHZp2AdlLijuR
	DXl8Pkf1JLVQZzI/rWMib8ussK3B4O3gsXve1Z0WtpATL86cvaQh7VU3MN0yFvjfZzVOWa
	m3iUXAmIM1JLltgDDjUIX13GydPkc84=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lberwGMD;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754507247; a=rsa-sha256;
	cv=pass;
	b=YQe3fuiZXGgR6JfThve9s1vvwFKB2b/iBM8ydTh+gl7/prMUWry8h27j8PII8N7ivEoulr
	e6I7G/UBzmz32IQIaWQ0K3nnqPtUijPEwnIVYwuLSSQpSmKWCRBVSWRnh0xOTCYUiTUstM
	tZMCaZV9tre/dym7EqWv5yLwHhYRbcI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKrpBLSqmnQjN1cVC/mb0bf4Z0MBUpUOeEcJaU6yuXJwmmAMsRoqzUp6VxqSapjTH8iKHn0ja6z3ESLRY++2hCe30fXfcawymK9NnxKtfjaWJYt0eOC0Uef8LDVw7lLudpXKEHXfh5FHynEWLUubEf+dU/TgyHxo8lk8npIORrmOf7qfEcKakSbUxWfSAG7d9KHiU1sRsS6neYe0W/yM7Rg8W2T33nWnPSkRIyTbmqI4H2zPwzMhAU1f17v/aphEcU2aiBk09yJfqKm2T+gmkFhXrT7AperQckCAmBKhD+XlBvmNQ6X8IjPfQSGZUan+vLsWoH+sbVZA1E3lVrQFEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XxzrqLQwms0advTiJxY0X0FCdV3ytmB+YBrBMMbhrH4=;
 b=xnKKqwhvNFea/nu4gT0RFW/qLYMqmqMlssf4l0o1NqJumq0AO1uBdXACCGuo32K57WzZ2p7Wq7c4tq4uOde2EKA2Gl46bvWhtEyEX2IGszzlfuDMZxZEIFdTPkiM0kNim7zl4dxI/VYZ+F9RKFhbEabSdO9mhmQ5E2Iyz+lS1uOFT2jFp8oJMQiise/zYt3wOmLPPXT9fOmRzDNK9UFibCIhqwUg8y0RHupANU8sXLtlKPf4amkrKqflNOJT0YYaj5J1Au/Ex5WnR80LKZg/oM7LSY0iWtMjz4u3+NNEfIAzApTC8dAG65PO9vjKMtzEVeg/QiL0dFnnwv17KN75Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XxzrqLQwms0advTiJxY0X0FCdV3ytmB+YBrBMMbhrH4=;
 b=lberwGMDjPJyuhMmuqcNAz0vYwy8DwKYsWf7EQOhJzCWNXPJDCfu/L7GqEHGNThxSTUnaYWHSST4cR3x6LReO8lw5nO5PQ/ZDiGLkujpKNMWkruL5RTaMLFfTmauHrpPR4IXqh68wcHw7tWzoMakfkPiNPvCy3V2hieCmt6Ig6wGEC4DEzV8cdTYQDauoYdgOjtZepQXDs7dobAgk14kcKofhklqSx8XDjoNT0EyNNNDwXcszeypkkECvKmrcy88pjemUzxnv6632dzgjBIIMLh+pvxZ+J4FokrYdjkKwFt3f8mIkYImBxYh8bLpX1Mz8D15HpjfgvtLNtJBJrhd2g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7211.namprd12.prod.outlook.com (2603:10b6:510:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 19:07:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:07:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 03/11] mm: Introduce memdesc_nid()
Date: Wed, 06 Aug 2025 15:07:20 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <F223D001-2E4D-4EA6-A61B-875997ACC2E6@nvidia.com>
In-Reply-To: <aJOnUKm_uE-sp1VU@casper.infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-4-willy@infradead.org>
 <0EE8EB3C-EF13-4F6D-A1D1-9F840D8C10EC@nvidia.com>
 <aJOnUKm_uE-sp1VU@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0040.namprd04.prod.outlook.com
 (2603:10b6:408:e8::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7211:EE_
X-MS-Office365-Filtering-Correlation-Id: 90b79b23-2ba2-40f7-1cda-08ddd51c7a45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u80CjXha9KNVmlRoFs2q0jPFIRbW/ORoyBbSpy3sLU7k1nWVsdAk02oM4iS6?=
 =?us-ascii?Q?/XIopMwWffBMYkazp7nxA13cJeU8oHOVL7SatePpUDg8xpuHO1sd9u5PIXbB?=
 =?us-ascii?Q?hkb/7H6RfUDvBeF6krjpOX2s76FKkMu6PJxlxARipuEaSOE/1aG92WUVqheq?=
 =?us-ascii?Q?i7GgJgM2QLibKuBl8NSG8/NCJVSoRVelURSXirEzrjPm5dvFKY1WxFY4r2Su?=
 =?us-ascii?Q?t/z/ohs20TVRw/0j8casFkQ88IeIEq4H8s0ZtXb5/3PVcB2z7J/YxS8l3Eq3?=
 =?us-ascii?Q?45zLEIAfHN2de0tsWDIWpaye9w9Ayrx7lye2aaTLaxyWWj1rrHIXIOlzcOJ4?=
 =?us-ascii?Q?Zn9U7fKk4zjc8Glrnn++EXvCvrs/iAhDPSQUQQJKp5kAUD9e4je52Ed/ANvv?=
 =?us-ascii?Q?rZQ+yNs23U5kc2Jaf1Tft4m4FhQtDsKp/ZWm9LI0hdwOpagySOJZ5O/GS9hY?=
 =?us-ascii?Q?xaAI+fDpuAkUHz/bvNkwlUn+JdPEo9qPPG4XcxGASv0JmQeo/5h68Jm/dXVy?=
 =?us-ascii?Q?fYqbd7w7Ini5POLN5vsTXHgYJyy4CSAvpzyjzYONQN8oo1YlYt9VjA8RPx1W?=
 =?us-ascii?Q?AQ3m26J70iGNk95rZpGCXAB0T2uGophrWBZZfFxlHR2vY1wKoyV8AWv0W3Ht?=
 =?us-ascii?Q?SPhm/u56GUXhODbdtKRP42tshyTxqD8F0WgBDehlz8asDcOPbdcaElrNAXbU?=
 =?us-ascii?Q?L7v39qANcK+jl/3lfHtxEwA9ylR2PgOX6utYH0JcyXCy6w5gNZbi9FwHzvCt?=
 =?us-ascii?Q?V5PE0ZdSkWy5rqeOT5dC9C6d7TUKEIZIOb4AtluRnaXRJqjSQHIV1xB6eapO?=
 =?us-ascii?Q?W3zbjxEesoLVlQGSIP5B/4PC2cCaZqZSAVA28HwrhNbNflfG7FIWUCTV2tLi?=
 =?us-ascii?Q?ozvobOIYmGQ8Gz+K23OIQ9/IlfST7DCwjWyPFpLTZlfbKK7jQ4yLnp6CFGd1?=
 =?us-ascii?Q?8Drn9JXGtvFAtZW2ERfSulXPbXtqStuiqoXp1hhQrsmMpk0mU/GyRQBra8tC?=
 =?us-ascii?Q?WLXbx0bS7Ext4SB/dLmdFJDrgoofalEJDJTREYqpnzBD4z8p0UEw5U6kGhJ8?=
 =?us-ascii?Q?01nW8Af6DI0ABq8+ZqF17lyt4NgfzMUhHbhitM054/qxpIyDg/lBA6XtUaIE?=
 =?us-ascii?Q?gXZIyXgMOH056XS/8VQzdGc/I31ZKXu0xlguANotMNVT7sZywuKtiRuEIDEl?=
 =?us-ascii?Q?1kPq9Ems+nySeFWd28IOvJQ2Lck7BrHtnCrMKwYTxRgxmtisyLK8YitS0GOm?=
 =?us-ascii?Q?LgsyV55GvREsUk3L8Sla8x3lfvDl57dMBF5Zs4mUw9iKxykXnjC/7E/LXuoV?=
 =?us-ascii?Q?BAqC+edUAbR1ffwZ8FuVLXFXCFGRKgDCfBtf2eKtg+GrQ3r8okIh4W2VRS/E?=
 =?us-ascii?Q?DmtDVNXMZfVU6OCm83ptXW68xTVZgilMFJ9KwernPUdMJbKPjQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EzILb8B1O3hyn11O3GOridnh8k+e9/Oe6LlS0A9N7Ike83WWbWZvC56I/v8x?=
 =?us-ascii?Q?+xMNoFV76K82ZW/GyNhq1f3SMT7xDU4hF/qNO91ir405kQ7QzCIUbe/2tzTF?=
 =?us-ascii?Q?N0z6TT1ld4czFUelY898PeajI1BAvfmz6S+2VBInU3NVIbqKLfX2P8Pt4H4o?=
 =?us-ascii?Q?IH/tf9BCr+fmz9MmaSFtFMpK46btfc5x1bEqJhmQfI6Rqg5YUTwxrflOpXX+?=
 =?us-ascii?Q?mXT4PscsfGwkVJESTIKre7RUbL7RF9+G8dmc4SQ5W8i8g6ysQhxSY+/rSVrm?=
 =?us-ascii?Q?7Zlf+6XoS2dXVd6Aqs0p0ZOS51JvrWLbfzAKCvW16wepwWnKMlyxDx8Viy4L?=
 =?us-ascii?Q?2GrciLxEGsieDbxZ6JetiFwChiTq8kj4o18VxOyAc2PTFXyLxElWMu2EliHo?=
 =?us-ascii?Q?s61WMdjRu5RCQeI1itIcqkepQVlE6GGXWUy2znCyX+IHXAbkZWyCRE/3jZzf?=
 =?us-ascii?Q?/ANv03rWdm1dzHjP6g6WGcuGTgEn/lWhXzRe5kvM4XaqvAUdlpS4N5soUsXE?=
 =?us-ascii?Q?ZDRU+seN1JbLTNYSUeMxK4wmReUaFhJFr9HRE6h4hq0lXjTmLrdRd8iohmzM?=
 =?us-ascii?Q?eE4idEL+zMrVKn6s3dY1xtU9/StFsnKKWtgYRifvgawnl8z39R2yzvVaXr9r?=
 =?us-ascii?Q?ESw3b+TKpeiJQqUGd0E0XwKlImns4REGlsruvTAZI4meQ3pqhmtpMizppy9A?=
 =?us-ascii?Q?zwRvgoCG1ANmNKPoDRW3XeAEUSMJ/m0e/l/5HzUXRLhz9581RjEdH388pBdH?=
 =?us-ascii?Q?EE2oAuw+cuAiOd+WEzTXrOn5CjFRinQxdDIH/HAT+g4dk9vpye65io3k8bjx?=
 =?us-ascii?Q?U4lMNv+drZAm63KLUzIULK8FUcqyvekefM050M7slB0sWXQm+jQNaohOFDz5?=
 =?us-ascii?Q?DUjlRpdhpMb1JQfeV5IUHO9lWxoIiNY2xjyJ26O9RZN4ySnpCv005HAYXTQa?=
 =?us-ascii?Q?TJeOhb3ICPUcC49ZbTlH0mgR6KeaD8NvjsVmHYr8R14vgIaOeGSWcCHTb/MZ?=
 =?us-ascii?Q?KunkWO5hfWATB9bsYVL2LCzuLJFBaQhKUIs7Lia5S/G9tcvu3GIyhGnHROvM?=
 =?us-ascii?Q?XbsL+WRw1WEjcyrZB/XDt6dmvR3YbjRa3EV0ANVTY/ZM6mL/kCMK1ijBzRTo?=
 =?us-ascii?Q?BgTsIoVOi38hCsGv4KlQt1gl/O2yTkyv+ZpR3eIe2d3KiYvHsBwdIXmtBzTA?=
 =?us-ascii?Q?ZCosJB6KB8slL+5F6qxS3ShAMi4Pd7es5xwkQoTb1ma/CecqaP7+IXNVX2uP?=
 =?us-ascii?Q?BjkvTOKo2epXgGr3+ubEVJBw5IaFmm/TiK6tt6PBtqa1+Uic/7pDnZFF3HRX?=
 =?us-ascii?Q?xRB06KaWv0nWze4SPa7en/5IMAe/o7kSXC3X2CDpQyUy0o7PbuVkNSYHB5FZ?=
 =?us-ascii?Q?4Eu1H6E0yYA5WtpjENMztVTCwREFG5/JsUGodpeWo+o2HUzUYcpV3gVkkMEN?=
 =?us-ascii?Q?RQvSQ6oUuwUyVfwdwEeOzmul4CFxVf+Amkmy1gEoMuk2kzSU8xTsbZ5Kd5sy?=
 =?us-ascii?Q?NxlZFdfPOp9xgoWU0PMLTbMhu/1VZSRU0NaiYVSRteBSREhJT8XGYOHnxH5m?=
 =?us-ascii?Q?gRg/6n02vN7uXxvNmDzrvCaTwKd70unyFQn4WHbO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90b79b23-2ba2-40f7-1cda-08ddd51c7a45
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:07:24.4875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wJrXdEJQv2nyzxVQlE+mFMTh3i5eP16GnWRCu8oN8f71kA+5FEmft8dMaOyhid1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7211
X-Stat-Signature: 1ih4q6jhujm9z3x3ns9rk6641zuuqrtx
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60FF5A000E
X-Rspam-User: 
X-HE-Tag: 1754507247-58043
X-HE-Meta: U2FsdGVkX1/FfRO94KuLoIp6M0XpWHe6PmwwDX806CbCgkriQ44uVqp5iVvpyduNjzBjnG8U2LXwAN6pC9EN2ST6F8Lfj8xxd8YsjyRFQphZ5XU2sNJiBsVZiaqxL1CqqIIWKZ55tz0vkinDDD1GMGf35i7FgBcTVgjaqOK0dG6ao/OlKZ8Yqkj3wr8vDnQVW2aMqLhOQDSuPkCtK7qTi69a8mplUEZfCy5PvIv91mjSLKYPt8MNiA3uEeHoYLNy+hH1hXywbUvjGCFLpjykFw7Mh8NlQIhUhUStpGUKe2zmFSokls0O4MloYmwdw9wTpn2Tr6UItcnjq/b6GnxiDzKU0igEKpQxNJSitgJOPmb3l6F191iHD8n9hqaWT4QjxQBFfRH9Md4be8nTVBW5GLNSiLN7ffTJ+uU21FdVE6yXp11Skm+NlTpTh5TUutOkNiGPvCtK6RemYkSDP9WxIAvCEf4s7NSNvH0+H8waHhQCAPqHtSKQ1wcg/uxRletT+5G0+6UFyFvIBeiSbZ5Afr/YREZ66e2EYW+xdw3MfTib0UewU1xgDO/ICc0/eCkN81UCwCuiFn02oHkWTbuBufWCBB8xTEk0LPMNHYKebbCExzgaHwXH+xssg/fvxvEoUPerxHrLzCv248EF4R8yCrbicU7QRXQMwA+wOGz2xQtwU7/4sToI4TThBIlQjmEA48aUHGHwuStm2C4NIfhAI8ZgSzVaEg/eNSGUA/rzX8nIjWf+N8KWpJ+ffoeR9dsyZZ0hAJRqB8I9/bHuX8YNzrfh9jEiCSZ9ZPM5hfNtGS0hu320yJltCp93zSPe4kJL1mVsBOgpu22XnSw29iYYVgQHZ3Z9C+FRd7426IrpmTdMqCVoXDU+wTMBELFLl8ZIhVC3iOL7db09bMOsWloF9Q8Vk/oIK9LsaV8s4L9QZQBoz5q2Ao66ArMJwgtXqF8N6RoRoNYCM2FD86nIOqi
 UMWhy9ND
 9Y/FwEYVWc0NOwAZkEol4XvjiNul3PU3fUkH+53m/S9j52Bq/2uiJaffogaNapHFOEavVSAdjwDOgoIUDT3e65SpmdJNn+mVMmm/nqZOupjO2A8GtIwWlDyXv7bs/t1CO6/2ZgPGuVFPdu9iqmcv9NG4D5CfOas+fx/UKoicqmjsF7OuoGsDUPrAEpy8Z5tKBbrPNrJdYIhhp03HPMf22KOyxCeBUlg6eQo6aVBeOumn+jWMp9f00HFg94nZ7W5M0MBjS1s7COpuF6Cs/GQPlhAcZhhL+NCVOUpU7Y8xjzcS28DvfL8ScCdm/NJOcxRnjIj+YbrUDlQvlqoo9E0/61DfwtCDR41ADWwdghUSKPFLOnjtZfD57s278OCTlMwvGV/9TlHWg4cP/tZM/guQiE7YbYql9w5p86mkXSuqVvbkh3cLnyGWkGvreTxHmphNzNrl6B4APrgC7xKuVYfcw4kNhTp2tTmG4CyyEVQAXeaD3y8RDdWfYYPR9Sq3J1Fq1oZP7jTc1I4IE25uJ4GKlz00PLIMrIhKwHAsRC9WmnMrXfO72kmNEreDPSs2cOEkWEgeW13hsn3qgSKg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Aug 2025, at 15:04, Matthew Wilcox wrote:

> On Wed, Aug 06, 2025 at 02:47:19PM -0400, Zi Yan wrote:
>> On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:
>>
>>> Remove a conversion from folio to page by passing the folio->flags
>>> (which are a copy of the page->flags) to the new memdesc_nid() function.
>>>
>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>> ---
>>>  include/linux/mm.h | 21 +++++++++++++--------
>>>  mm/sparse.c        |  6 +++---
>>>  2 files changed, 16 insertions(+), 11 deletions(-)
>>>
>>>  }
>>> -EXPORT_SYMBOL(page_to_nid);
>>> +EXPORT_SYMBOL(memdesc_nid);
>>
>> page_to_nid() no longer needs to be exported, since it is a wrapper of
>> memdesc_nid() and in mm.h.
>
> That's right.  Did you want some verbiage about that in the commit
> message?

The comment is mainly for my understanding, since initially I was wondering
if page_to_nid export is removed, what current user would do.

It does not hurt to add it to the commit message. :)

>
>> LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Thanks!


--
Best Regards,
Yan, Zi

