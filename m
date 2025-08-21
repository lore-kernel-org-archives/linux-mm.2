Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291F6CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4399C6B0008; Thu, 21 Aug 2025 10:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4113F6B000A; Thu, 21 Aug 2025 10:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9356B000C; Thu, 21 Aug 2025 10:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E04E6B0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:04:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B08601DCC21
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:04:43 +0000 (UTC)
X-FDA: 83800935246.02.CC4A8DA
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63])
	by imf25.hostedemail.com (Postfix) with ESMTP id BD971A0010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:04:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZydnE2SV;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755785081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ekt0SyVL0zhGwfCWr9Xp5Xj7oEj3veLe6mrnkmTejTk=;
	b=jUzK3jjMmla8mlLrKmp8Yt4FukSftf69oP1vAXbdsDNgX3/Jn/U9wobQeN3zhNdpyw+pEQ
	La30OoMwS36KYxzdF97tXUXNiZopaWxl7SWbHpYIgTwG9QEB071hLVdiQgnORuYqDDtip7
	e+NgL6Xdj2IXstva7sMNOW6qDCE8CZg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755785081; a=rsa-sha256;
	cv=pass;
	b=2oiRiT2Z32UXOuXBk96B1h/dPVwFiWYvvo4aRRV3xuPWAdEOohqGOtBYikSh1t+nsAiXDU
	rI4JSALVmobw76XyrEvIVobtYBB9ylbX1p+4Ae+35vIsAwi4Fwn/wlPh0wIfctaDt7sl+I
	xu/LWqQ67ATOsslo6qSsbO2897QxbBM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZydnE2SV;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.237.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yvenVXoZuMhOrOWHeqDfreXuDCjxWDbuzYtlWIVJG6Bx2/L9+Vek4D/mtIqutFMhT40VKihFv57jYAmbjqYGUXGWrIJElUpK/65vnYsO0+MtMMpaZGPih1CjE4pyrqcO+MIan54Q+PnxuPkGIlW04p3U7qYGP4A1hdV4cQWtJ39nlYW2vt6NXmGvMbixOhX1M67SOPvDC23VAXEX4kjE1LNU0bfDyg5N9NC8VJPUmWENfNO9w53IhiI6XmYdFPaiu5q40/3cUW2Q4igwE+ezFBWtyacEOrgJGnAejxB9k/KgnKFVsRVXVp02SLXWWgjwcvH4d/8gEQUT1pmW3VUZdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ekt0SyVL0zhGwfCWr9Xp5Xj7oEj3veLe6mrnkmTejTk=;
 b=jKPJO51GxzMl34Qw3WyOm8Q9jslv3LjNCOOFBU43ihjRDDjHd4/2KutmpwoWVfP2wB2UeDaw/73JqrVlk4/+8agwyrq+ODioUcimEvGfNpDSFI1Bf6tPYWnabnKyfMpYxrhVIZQCjxo8jIRKg7nwUU7/Wwi6u1Ri6r+ZwyPmou/PMcL6Rvq+PwLgyQVKJyPPC6G79mKyMDFrcdJ1vfbuFlfxCOn2fLUAIBEniTiGwRH1dJAk6Wse1njExqzCGZcTTfMhBwywcTIzrZ1eEI4PFyZb+bzZuKxD2sVpLNhpBv1zIPEmlQ8jDIDh04XJLUq3sV2dIoHmT4TgBm15lqoJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ekt0SyVL0zhGwfCWr9Xp5Xj7oEj3veLe6mrnkmTejTk=;
 b=ZydnE2SVCgmPjTETNREmrcDkz3vjH42Kr5/yl/S8+ogeVkwSX8n7jXl0TRcjWG0N3vm12m0AGXGb9mEOAC8NpqNO4MqsqnG/8oo1nqaxHM/Iw1AWP3IvU5AnaaXzHU27MqLlSy7NY3t5PfrOi7qhe6IMMdANG/4bYkz8hs7e4j/faKR4KNrObHwtCkDKfgqYapIRcB2IliN6mEaaWO/D54V+4a//BxrBzBSxTKSinnJjGvizTuTQObbEZig4O2/ZypBdNp8w3VKBxJkakmdXzpuwW/HbJpnfDwqDxHMUgifAd6q7bG67ljNtTzOFxHPB2fl/w1OOsolvVIRtuw0LEA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 14:04:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Thu, 21 Aug 2025
 14:04:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove is_migrate_highatomic()
Date: Thu, 21 Aug 2025 10:04:33 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <C0F291DF-60B2-4662-834F-162AEFB10E0B@nvidia.com>
In-Reply-To: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
References: <20250821-is-migrate-highatomic-v1-1-ddb6e5d7c566@google.com>
Content-Type: text/plain
X-ClientProxiedBy: BN1PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:408:e0::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 14f94106-4bcd-4e88-b50a-08dde0bba947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z6fU4RW25QD3A5+Cn30BrOV+CnFe4AmPqdmH9GoGfc779M6JkbbWFQpVSMNS?=
 =?us-ascii?Q?L1Kg3/1MF+cF0Ne2Ju8szcP7sDjx6RhwtcoNpV/d9bMGV3T1+uLPp/tQxvSG?=
 =?us-ascii?Q?kwKZ4mDLEcPB7miWZfsWq+uv88DXxvYxgu+PtE0A0GRnlH/IKWWgsIHAcZpf?=
 =?us-ascii?Q?m2BjrhUaUmDjLHLMHeZyuOJkvT9qQ2AoPicaGDjzHid5aJKUD2UM9wIgXgKA?=
 =?us-ascii?Q?kAwlCUvU6K+9a2SjkC2TLGPfb0PCbnjTOVF7G497LN7jV9ww1BAx2AIj8azi?=
 =?us-ascii?Q?SUVJPSyHC45VlZqUyTuBTTpHuC3hPM6SxhfYL4APuVk8WPKOHaZtN5Z+9BqR?=
 =?us-ascii?Q?2R9AG3FoVxh5TZxSyUjWeGMdNgvqZkFi6TifBozZJk6icv5oYB4Sav9cUwS5?=
 =?us-ascii?Q?e/1BTXmTkNIiFaAR4J0TsPGyDDYDi0F69EDEW01lZEDrVempZ6cAiajZ8dV/?=
 =?us-ascii?Q?+nIw19/C2ycUaUvercZdX4FI1dbLrzO8cqQ2ucsXKx6bfY9n+naQgShrHC+G?=
 =?us-ascii?Q?xfiEFKXCUjuxXdwPomTWfwqNQRUw+KFnzX81ZmaC147Pj7wwk0oPG3pUPjXF?=
 =?us-ascii?Q?LcblZ8q5Qa974vPnHoFakHFeaPVGdLhuK0LtkMIUxdsbpIdmY0+hVq3+qinA?=
 =?us-ascii?Q?Inx2alaDNWE1YdQqmb/ohl9SHa6nJhkJm+aEopltnjO09YXYo74aUYybfYW/?=
 =?us-ascii?Q?G8yNLOZsrDEo6dKu+KiCUWAy7t+xe/QJMZ9zjJ3EkqdX9ONkjDM9xPkFnl8Q?=
 =?us-ascii?Q?p6MIBB8utCPZAzo/PX06X6hlFHGdP87eKWZZSZrMPp7DOnX5f0JPHR3/d6+j?=
 =?us-ascii?Q?vVD4C0e874vehCYUMUn3PXedvSi3pqfy0fRNzFk6HZOdYLXwbZjPjUj25ATH?=
 =?us-ascii?Q?e6AAxiGErLWyMV7fFWXL4Zugo5r4riappgl24KHuqeqnyyJVuCUsImPwWVTn?=
 =?us-ascii?Q?y0drF8zaqHfQbNjLpVMOthoBbrQ5v95pDuH8sV+szE5Eb7YP/5xIbBq2l7SE?=
 =?us-ascii?Q?RDyQXPssSzNqC+nT+v5WFJcs4DDR447QZ2SX57fyWs8Zi4BBbuisTaKlW5L/?=
 =?us-ascii?Q?1zyYAOdO4B8KKPCn5fo5JsgpK0Jj9LJ32tspm0FTpbJM2sL8vAgeLXYEns+9?=
 =?us-ascii?Q?atotjyI7YR0Fo3LXJD+S324H3cInKs7pJJT7J1tU2c0aVsVyrZJrG6iJP47C?=
 =?us-ascii?Q?ejfr0fDhOW+r4mrdY6VIb3LPJvY/P5P7sXkYAySYMHTLI5rdmndmC1JriZJb?=
 =?us-ascii?Q?K1WwsS+7warflhJ+C23AvPmFdt0pRxIubXdbImqdmZSmYOGq/r0tTEoNDioT?=
 =?us-ascii?Q?ZVgn8/ppYqQT+BurYEx5mhHuXA0NK1RrGU5CeHZjmxA0dGGPT8g3AxWDYY7V?=
 =?us-ascii?Q?jWU5OIfesybB7XQS2qAjYO+snPPwEIROb+JHZX021RK1tmsi9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5zVZDQRX5+iJYGB5i4zW+v/gbjN5BdVm6xbFLZuYzq3aA2P2WshmYbzjnHLu?=
 =?us-ascii?Q?66pty45nL+NC9oT6sQcL49z32T32LNz3CmMaRpXBu8+2WxvSoxTHIvAtZXsm?=
 =?us-ascii?Q?J0ucok54zns9WiNhJGnM9KDARswob8q/3a4er21YG+mAXKNAaca3UOGoLsIo?=
 =?us-ascii?Q?316IARh6VTD/C99CqROfuSSJuIeoFtyj1IHHYbI47YxAYZfRpz4AawrBM3np?=
 =?us-ascii?Q?vxrVRDoLpDHaE176GVvQbFf1M31M1qh+dlktXNaB3OvXlybh82N1XZTadtdu?=
 =?us-ascii?Q?IQO0gZBVChZHKKofKFb6wsfS+rFSju3aF9hS45p5m/YN/sQM4hpbm2MlxJzm?=
 =?us-ascii?Q?f/nkMIghAxb4Soei1SPm/ePTMiLGfpICFs0FVZeLhoB6q2Sml3CKaiU+h4l4?=
 =?us-ascii?Q?8pYmcoY/OegRnu8Wz9fKLPZ7qha2zZpvtDG6X+OPN8aAjCYqL80BE/MFe0Xa?=
 =?us-ascii?Q?A14zodilRDD9uyZWAjNAsPQAMGZfYxoWMGKY0xkhaHjbpu4u4FMSd50c0/yy?=
 =?us-ascii?Q?IUBz6d9uVhjMM6VfewLkDkpGK6/03vR2++rZx12nvMa1Ra7zZtWgg/SsYtZ9?=
 =?us-ascii?Q?411uz2aIhIyXKF/tsVnXKcIW5nHIItvdOFx8ZXYZMIWV/7ckqb/WD3qC9HHf?=
 =?us-ascii?Q?wuPHaoOBLdDlj8huE81yHFe2CEJ64OiHrivqWgUPg3ccfZt/pWXaJFwu4ahE?=
 =?us-ascii?Q?EMaIB9nY6p65mfpqY23Olr3EoR7JRN96kzODTGWO5BbgTp6wqdSirOmDDK5C?=
 =?us-ascii?Q?5Iv6F40bqugPO3AKzo5NREYU785cAJTYSEj2HSuSqdrb2G8QVuHoXTMExkdk?=
 =?us-ascii?Q?+gFRHcWOgsX3jjKu4ZN5GPcURzdWzgKZh8L/tW4TIsip6SNg10kzE+Y9gNeo?=
 =?us-ascii?Q?GOImrq0Y5hl4DwrwElZtOR8bw8e/vKOWmN1ZM6krNl9AYs6FDneo1HMx3mrN?=
 =?us-ascii?Q?t5SKNancoHKkXcLTXZNJ8OMaG6/PIpSQ1w4c+DdGZW9EJ8zs4chBS6n/ALLc?=
 =?us-ascii?Q?yv/9pulFiRPd7330VK+Gqc5VDTwtuRyYtDAf/DRywIMOU4AutwTZIgMtpGVE?=
 =?us-ascii?Q?xP6zALUTwFPZon9v2dRFAWc+nh5OrccVjPGfxzGefi9VOK6+MGHDdppCp19i?=
 =?us-ascii?Q?cwzTAnYjuVXeu7hDeJqeUQVF+tXruznNEuxw6sEWV/mREZ6p/zTzsfI7uzvJ?=
 =?us-ascii?Q?28DKivUUhNTjwI5NI5Vy8kN35mhZqZ2HFmlq8oSJvoN59xj2sMnVjWsSczqW?=
 =?us-ascii?Q?G5jTAzrrLqfjf8evtiRnJDlOJsbVSpXU7lmZrQR3iexMVhm/WMoTlkPrXEOI?=
 =?us-ascii?Q?1RpTRI+Qa8WIaWPO1490jRsWfuvyGP60zOcYmnejGKTTBWQRFUZ30AZ3dYC0?=
 =?us-ascii?Q?4IFnZ9ZKkd8lnEqJ8B1AMHht/qONo/cVqjyzA+mA+zswv2ilscP2HzmnbCXf?=
 =?us-ascii?Q?P16wgo2ZgS9iVkTJ9cytaM0V73/rzq/1C3wXsN7cR4UD1gZf88Tc2lERhezV?=
 =?us-ascii?Q?DauMJw8Bv0Z+Tx+v1XhW8Gip4tMz+6MHKFXzsMOls5TPtwjuLMo7SuLefoVY?=
 =?us-ascii?Q?MfbvCAa52Ik1aPOEiWfJsBxXemrCqg7JHST2au1K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f94106-4bcd-4e88-b50a-08dde0bba947
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:04:36.1244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: inGjRMI+uiC/EZYvE4u+Ce9ou7/K1Q05YEaNKooz1hNez6t4YSWc6DgwkIB2zcpN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD971A0010
X-Stat-Signature: r6wak8c8zi4uertdgadbebx8ghbwhiaw
X-HE-Tag: 1755785080-238343
X-HE-Meta: U2FsdGVkX1/IEJA8ZMRyOrHo1MRX/4Cw4JPEnEAvWghaqOvbgVW21og5kYpljODBQgNsGAlV1c5FYa7lhcuCFw49DpQ5bp5YyHW9vd+kgttNH/0GN/6UR1Qxj93bSa9LgZOpmQoboWTIOKQ1nr4+qKhvGGcMa/BnHhx9ThNLr1OH1GyF+gNImkfAGzpc7HU7PqTBA+RmdOPQMLbQssrLpksycAdXRpr41nRePkoP9xlphV0y/xzYg67bdb0guH0L/g8fBdW10j5gWr8nP18FkynPT1NucQn1t5n9xOI8wgx8KbSvmVkvGvHhM0srqC5kC7a+676VRLYOO67tpVxrB1oLiCj6bkmcP55rnlhA9X4uLnEtUE0iB7EqaWMm3/gwRDcJZu4Kh0nl3dAJwqc2FZBBImsSuWyd9MX+PPk9WYWZlAtXRXcbJVRGzu8dD4ZuIp2JK/aQxQZ0RYw3QIP+NNHottXXsYWC90RtYy4btmndeBHZ74b0vU/ktdEGv1J7m9geb4sdsqqAx1s/FGuW2Hlp0id2+7dcrCIw9njIcMhQPNjaMCYWdWKaWoKPNPFldtJ3yVRpP32mkxPrM5vf1CE0tLwldn0mmWIfYZdgv2Kau9Y94MvQW9FrCSy6woyMFFtnVvrDQ4hfZ3FJwEJc+bN5m18bzRg2IWV8aAXbBPe3j5d3CC9vukUwjDxtWabxXdS09QUBIPRgectJXJMJw0FfjehkBvEnPRtk+eU+gle1AXqDv7W5vi1HrVdkQiShWQkGIl+Qn09oP0oQVuGSz8YOACHJhmlnQF64F3FHm5wcs/vro4BYjH7Kmo0ycBmMRHKOM9r2+xJbzfhG1g2LMPYys7O4p7o+jsuPYIKnaDWiSDkGKzLSxzC5e/Vp0cdCQRsOtWCwhdW3y3rI6f0W8riHrCbgDosY8NhjkUbhxhSaviEULPHO1xqbAG8+eePXLdaY7ciMQjsnUwA39EO
 A5Up0vCR
 tpe1i8qA/rjBhqlZFTLToIegRmChgt/WId92bl8XyFNDEvMBA0XTGLOl9tPpY2h0OxKmW+VYEyu0HwGHlUQGQAwdyh2UsPJ7BUjBD7X1YbwzZoGNwr/uOt85Xj7WS70Qje8SAhScooLv1rK/mYfcFky+9Rx2V+wvpRg7hzSSD3MROVKJeAX0Uz1UbDwMd2dNy7CLLXeRCKBKy03/oLNjZCLe3CHeI/++qVBFMnN7Z43dCouL/XbtoPodf20VugQiAd4jgEUROQagUE6GimJTcCcsK8e0tCuJgxqon5VZ/BDoOZHhZ2QU6uGc44QVWbFm8FdgFDwbpbcddRuWoNQFw3jRlss63k57wy6xEGBoPhQj3zOlr3Crc5vuey1HvB4arg6tU49INkCFaTcwAKpdmAt6c0nrQq0Z31a8jZeIwdM1jU1P3bBROJDXEPcyCzXc+FEPnxumufHXS7k4JSmGtLpXOJxEmXDoD0mTl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 9:29, Brendan Jackman wrote:

> There are 3 potential reasons for is_migrate_*() helpers:
>
> 1. They represent higher-level attributes of migratetypes, like
>    is_migrate_movable()
>
> 2. They are ifdef'd, like is_migrate_isolate().
>
> 3. For consistency with an is_migrate_*_page() helper, also like
>    is_migrate_isolate().
>
> It looks like is_migrate_highatomic() was for case 3, but that was
> removed in commit e0932b6c1f94 ("mm: page_alloc: consolidate free page
> accounting").
>
> So remove the indirection and go back to a simple comparison.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/internal.h   | 5 -----
>  mm/page_alloc.c | 2 +-
>  2 files changed, 1 insertion(+), 6 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

