Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0178CEB2E6
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 17:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07BF8E0008; Sat, 15 Nov 2025 12:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB83F8E0005; Sat, 15 Nov 2025 12:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC698E0008; Sat, 15 Nov 2025 12:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9443A8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 12:51:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28E06BB6C4
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:51:44 +0000 (UTC)
X-FDA: 84113584128.13.EC7D429
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	by imf29.hostedemail.com (Postfix) with ESMTP id 647D6120006
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 17:51:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NzQJo2tC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763229101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bSAicikpbCT5Qt1fhaZ6Nsapj+ajo6yd6ehbJiPN1RQ=;
	b=KZ8iXxfoJBCScj088uEauOFqXYNEAed0QkDQ9aX1Lmhh8jI9vAtcG88zkSoyd8sjtPLdtJ
	twCybWWDSMXjcEwHJfzCXwGLjZas63sIcZq6mMeGFeFwpBcsNVUxvZUWzqDABVh4kVeVk2
	HHTfLKNbBKQoEF70HgpuCA1TWjaqIuM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763229101; a=rsa-sha256;
	cv=pass;
	b=4SlSeZnEbR+l1Q+St9CaYQV1SR43pYdFJgLMhcj7LonP4Pdp7XlcSjcV2beUk2SUzzUuKB
	/KmAp1BKwCz1i0GloSHO8rnZOSxSsIfSn172ma1hZCM/pyW/hkXXY/JegE+ea0Z6DOjh2W
	w0/6ZuUzKqMbBcnGB9MgNO02bEiJJbw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NzQJo2tC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CIffJTY3SPczD3/Ldf3RIKlZ+MZ5lBYZ8qJ468Z/Y48pFWtZ1T1dR1S+nGXOYcY70hMGa8qLXo0nbKtzLto0s4PQkmhSopRxq5AxzWBYyIlqt3Y9EXHOJZAD7+XU6lh18bj9jhAQKNuYLXRtCICHXpFNwB1Ml1J3fJrTEV+3nFxZGiMn0xuRuiBsytUjnk5DoUFy/EEPZ3fXN913T4u3G3E1jvKndnQhv3hEzklpr5Fj6O2xdDG9YJLM/r8S2y28AUzfBzbJxiehxtsQj7ovovUUtiSw50t0OEipnZXHhg8fjzxNeoFL+vNgR7eY4lya39n5e6x+6+KF/51pp5u8SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSAicikpbCT5Qt1fhaZ6Nsapj+ajo6yd6ehbJiPN1RQ=;
 b=HG67z7rBPTz/2mH4fEM3hnXyhioiwvKm81qu5r/F63eWP7nPeK5Gdeg8dQUSmpCaxkXpNPkafCumcDn6C79vpOk7dJuX3ODz1z28DETcJuFk0j1FlpOazbm8PCMe9dszAlKbr41Ue+M+/iJAiITJgzbvNC8fqRXsMmFrF63QGNKoymP0MeHXBUaVtM2k9Xix4a7mfGTC0C6hObtGcUhOjWc2a69ls9yYWycLmQmgEZsAGkyXTUf+XsR9yTrHl9oPPk4QXWGFIhikZ0Bih5xi+lsSVxYNYgQ31N0uZIIrccboSVxOUdShUOBd81OYNjQVry5x17Tlo8VMCFT17Pyq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSAicikpbCT5Qt1fhaZ6Nsapj+ajo6yd6ehbJiPN1RQ=;
 b=NzQJo2tCOjAACAO0vMlYdLiVbCQ4aEteE49DE+X/OvQBHK7XA3nCRem/9WNV5/fPEg2n2lUeU4pLfb8xeD8XepTQydZex/uwK3bS0LmVkoJ5I0vqQ3FprdIKucYi6SECW6on1kvvYSqcTzt1RROqwcJ8f3IfjhKrjrZKstlOvtX+qkBSQZqApOIj2pwYS71RYM+fYoE/zpnYwspcenesaN0KNknWDQWU9iob7Z5B44IHJbdo66/lozg/9n+JJlO63WP05qMRLOPna6UeUjc0fQgeKtI6VUwU8L1nO6Ikt7XIC0wnGMb8Zntp0ossFM0fY/TnE/GwNudX0RYDMVIevA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB7579.namprd12.prod.outlook.com (2603:10b6:208:43c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Sat, 15 Nov
 2025 17:51:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.018; Sat, 15 Nov 2025
 17:51:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: fujunjie <fujunjie1@qq.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: optimize lowmem_reserve max lookup
 using its semantic monotonicity
Date: Sat, 15 Nov 2025 12:51:36 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <36C81D51-A931-44BA-B58D-223950FD370F@nvidia.com>
In-Reply-To: <tencent_EB0FED91B01B1F8B6DAEE96719C5F5797F07@qq.com>
References: <tencent_EB0FED91B01B1F8B6DAEE96719C5F5797F07@qq.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:208:237::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB7579:EE_
X-MS-Office365-Filtering-Correlation-Id: c6f7e804-803f-4468-1759-08de246f9fd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ouhm1VUt3bTXYjZEROqoHw4XCyrrXya6WOvIlgefck6C+l+Q0fkEjwc43/GW?=
 =?us-ascii?Q?6BVg6zxxvquiXJVInl05qzOLedxVk7Se2puOE2azfaEQ6bZNixOEDcgfzonn?=
 =?us-ascii?Q?/4htE1WHbVCjA+J3j12/YZ7flYs/0L2QG0MGxu4TM84TI2xs5yHHDe6oKluw?=
 =?us-ascii?Q?zQqUZ5dw5XtmukIVjlHNGCoY6O5SUaPXzHtaYpNCwQlNxREsY7JsV0GPH79s?=
 =?us-ascii?Q?K8FduOS6eONrtxiNvgdNh/IoOm0voHrDaaq/gVq73dmNzVbNuO4AsRMXHRIu?=
 =?us-ascii?Q?sTaGaNWb1jJli1x27M2kBeADFTyFhtLqehQoBA8pANIMFEjL3z8MM6FcDOCt?=
 =?us-ascii?Q?EXOQzhaVMjyp4jn/44U5y2V270vdv7vDWt6c0dng5MWlqCEpdkSGXZNtVZoQ?=
 =?us-ascii?Q?5yoxQingZqlDYTp6wsV6dqdbSH9NE/AlnYa16pYtv0OxXdHrlbpAwKydAxsc?=
 =?us-ascii?Q?iNZXrnVR3hnzbTAuBb3Pe5h/i+6ydsG8icXzc1YQlXuUIgjtR7SnYOTBfOgg?=
 =?us-ascii?Q?hk098znUpyEDBLwWhPjKDX+qO8lUvZ0kUj57+zx3fwL7MVfZ3lJWVDZrGzk9?=
 =?us-ascii?Q?0ztZjfsFinupaG6dneE6Rhc/tfe4OkDwjrC8VqJKEXxcFpSOwBj8hDAAXib+?=
 =?us-ascii?Q?pPIj3MRsNS/BbEKFfetLcRyH7BJfhgjoxg5Cv1WezI0KeDM+NHQIEfuq7huu?=
 =?us-ascii?Q?F76Sthzi2TXrg55duhqHuonp7JR5JdV9/hLOmreBZuX0ZQ2cWk9sK9tI2d4a?=
 =?us-ascii?Q?2HISZPBqoLlu7ikdXsZRRQPtVy4MChJS5sWheYxtozlufHJhVige/USdCcCn?=
 =?us-ascii?Q?9Gnite0rDz/kO4b+tK11jVkxMrNhARFWYuKkhvhUx8VC0rmaleuYri5p9cTX?=
 =?us-ascii?Q?E14qhWSMiAtq3CuVldngxWzTEG/ZXGWAUD8GRtoPYnVzwwGw5t40AcfhP8TV?=
 =?us-ascii?Q?sjkWPq5SL9nbaEmThn0ikgngfhKoc9xBlUCuAfffzRu8F0iP96UFbV+qV+fe?=
 =?us-ascii?Q?RYIHa3mghh/7yMe5APQFD9wHQZcgFeh90ULuVWofzmt4EMkz41EH3tR7D/pi?=
 =?us-ascii?Q?24g4u3PPh4dgIugR5IdgWzyM2l3yMpRqAHmWPnc4WV/7p5b3yeJCeOBbUdJ+?=
 =?us-ascii?Q?8oEmXl6WbviKEbR/diRfqqsI4yALzRD90rco8cJHx3xque51HaJl3SdTkKCU?=
 =?us-ascii?Q?sfH+xDWdAy1k2qQAZVQjFW76kElxJOJNTmlmvyF79RUmEt/REQOAltN02DGY?=
 =?us-ascii?Q?1ncVt0aq0SoWoRV9koJHYqmP/mD1N0ZPkiIrmZAyvpbQKDO+GVpunXyPuIw8?=
 =?us-ascii?Q?mR/SbNUMX+etSZsoonq75gsvgDL9Ivk+RUeAqNsNDStNTfnMcE8ZQEh227N0?=
 =?us-ascii?Q?iYy+JTQxonC025eGAJVdMprhRN/fuSIaBSTwyrkgFss1asMxI6gwftW5OqjS?=
 =?us-ascii?Q?cEgWaYOnVzVITjhYiCouPuJG5Fy0P/SI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gUfCbcTQUbtF3wss9VoCFwrwoK0IZmapGOwWlb7C1+Co8CXe0MxS/YYf0qCI?=
 =?us-ascii?Q?q9lOdJITqXBY+1dMoBPKNQyBmaYXZTMZXStOGpRau/hDB0czjvh+GAJDIuaI?=
 =?us-ascii?Q?V6r17OQ1z5KBb6AQRY+BN+yxhgz7aTN52z8pgRj2fyR6Nq8VX4x3lxKx1sAp?=
 =?us-ascii?Q?XN48xOfcSO/JsUtV6LZcsWp/YxwTDXjNaoy4JRklntXaqpVW9KMcA+cMgIyy?=
 =?us-ascii?Q?1bNh4E3cC0CZrAucz5o9T4tPlRJfq/px6h9QZFujKWW5e+8Q9tJN75N6v4+4?=
 =?us-ascii?Q?Mj7VnUtzOZkVt9KCs26C3/jhzP22nlpn16zgNZVPDP1QXz0ZeTATPyYaKYTb?=
 =?us-ascii?Q?YFKWXVywxleFX44JPUUom7HugDjuhChu6xgUS3tmbJ1tevSQ6mDVf8fXbG69?=
 =?us-ascii?Q?HE3dXmtmY5AhvkbvkYPJxS2FF3RKixr1n/VjMjcGQ6ydMLK1JtMcVTRumRum?=
 =?us-ascii?Q?N/KQn5LL6caUymd6H2ReO6x3Kwedvq3Km6PJsUAKTX/ySlgKYvO4vQP/ijH1?=
 =?us-ascii?Q?Vx6z0F1yJlxrM0qlj1lHPcjBx6xy9tH50B2mE8QISOCA3DasPSZgS0nWRs5P?=
 =?us-ascii?Q?Evr2Bh3gT/Wp1lO91UJavEnnDfgjyZTAKbPrIeO6jBn3i14InS/Z8BfnRrGx?=
 =?us-ascii?Q?Q2qnNmshAgKjapcF94zTWo83tiR1JBuJbVhpYD3k+MDDnXza3hAnbt6RREFv?=
 =?us-ascii?Q?k71kwoebm2W/rLtCI0PIRCo17a53nbNFPfCdKPTT0OCC9BTAdwph4x2odhyH?=
 =?us-ascii?Q?HK2zi0YGr0qqacTh0sGd85u9cQgbGhtjQ+ATnSk2DWvYJr6lZQzNC1jbaQ+T?=
 =?us-ascii?Q?5aogolhHwCPKoZFlpMRADZ4o4jR2QQQ0zTiyyQXJTmjWWtvJptaBzTEMtKTv?=
 =?us-ascii?Q?g6Y1PXWFZ687qVw6dWdMcbeSS8LIm06RqtCIFFgV5EkcN7SOokS2BNzaPP+i?=
 =?us-ascii?Q?AFC3XnPj88g8lTGAVMF1lZ0069EYu+6LkA3Pg6T4pamUI5E4GBe5KSchMYFF?=
 =?us-ascii?Q?BCaFi8LXq3rcXNyYff6BHEgfYbKlnaYUgjYFqd4UoP/sx16zjNXAyM1HcUWR?=
 =?us-ascii?Q?PngVZY2Xf2pX/IiKC2FubT6O/a5Ax1cWo2h3o/BXuh8zB386rroHsTWt9xPk?=
 =?us-ascii?Q?GE86g3veKlTQN0NU6ev8Vv+1QlEsmhYnw6UVraQ2LddmSzNKGDoRWGOLQLtH?=
 =?us-ascii?Q?zvBpCV4IFdlboZVrLYpoPNOEuPgj+ZJ/8WfFh3PmlpU0K35jD6itEVvocjZb?=
 =?us-ascii?Q?CCTeGMw89MDxzjJeP1uqv3iITsqEwlrLAX7H1mbHR24ovk8YQuMbi4Cs9n9a?=
 =?us-ascii?Q?s1JyYiMkKzIu38y2qe+atPyTxCsDcco3KIyG+GUV/fyWakIzQ/2qFt0ZMDXI?=
 =?us-ascii?Q?QrZNvdg2m3+s4j/Vb1PjryaBpX7RpGO4fgU0T5Q7ywdO63kvpCORbpvHwzhe?=
 =?us-ascii?Q?rIRBxkDajaI2NuWLY8wEk1nn8/YNBwHHPi8kfeiDFDbrZJayqAN/xBjaoJRB?=
 =?us-ascii?Q?p7JKqgEqk+Jw5Av8gk44EkaRn7WF/IVvc1HrQ2sqofBC9mx+x/VYUjO/aff0?=
 =?us-ascii?Q?3Mg/xCwq5mCUoz2yN34d5vvH48t7PVvUfgQSZ0ql?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6f7e804-803f-4468-1759-08de246f9fd0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2025 17:51:37.5353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqQ2UcZ8iG/7/R+BTzIBbtMTS2n3JNcps6wVJ49a+LlsfblcHZq7eDLRgwM2BVU4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7579
X-Stat-Signature: h8aamod9mkged48nuy8hziwroi65sjix
X-Rspam-User: 
X-Rspamd-Queue-Id: 647D6120006
X-Rspamd-Server: rspam10
X-HE-Tag: 1763229101-874182
X-HE-Meta: U2FsdGVkX1/mKL/3/zdKqYnKNWUjTxPLgFSKcI5cN9a3/DYz+IOh1TWpl4S/K7C0OhPImBbp+7z3kp0K/37hRMbALdg853VXB7VvGzt5QueyiolQP8abdDmW8KnGA3rfe0aEXS3dHU/KllTEyiI8vVHy8Lip3nRbaD9I+uI5MNxh9SPMB4nDa58y+cL7aocwxRklW5DVZeOV05acp0t9qmNG62AZc/lXoIUHwxqHwy/w7sLFpGfB796xdmm/N4koiNl34/QZGOAaFQ4wTiTYxmDOPJg6Ks4sY9rwtViZk8laRPmyBOB5CVO1NWGK9q2lN2eo2Z8nXzrgh3IVGHt/0C5F+jwx2dKev2J0b/KS/Xng3yc10OlUU0y6bFy+vIUdiLSAiDzzU7TStWEmvDy9B4AUiACUJrdJGMWH+WRT79IZsUs+KMH+VZ8RP7px3wjtdu6VQbQZ/ePeiFotVY2lp7XG2G30rEs270+J96PaLWtNn0/mQeCbje4JNd/D4rnWluiC1Qv/JHnmKtorqjblnmmg1a5/NLoFLGJdKCwHcYoQvq9FbnWqipSWI6zjUvyP+PGRmTTn9p2wtI9qhj7aAhT2E32CbqK7beOtKt7EHAYXxEP56keA6hqIhv3GOwObiJF10baPR2c/Yba8SInAnIary2bxuBqcDCyj6Z//Hf2BrZLoHd/g267pI3CsAn03cLSXeDpRsPRsGWu0QDQSdsSmsKh6pHpFn5KvTUumqG4wWi5HFqDL2bubsoWy3BEe7MoWtLRWXh69jPf1wWJxZPTN4ZcQOXXYp3SIoRQts4s2p3XPB+rwrwMrxcUIds2RP+UrlIZQuUhquLHsiz1F0zMbwnTnwLii2z68E8Bn+99lOgmDlo/6ruT+7yS7TDGAKXCkjGrNV7Yy7cAEs7Y3pyNdd6U92+oo+YRpgjma272IR5SCuevo9lkjyCU+/mD+XA5oXsqhIe0+E/XC6xF
 jQ2WJp26
 XRIeKR1IQ0pg2nbRY0+wbxZpfQFsLa/PtTEEwPLUEl+tTNywc3INi1U154LMjO21AT6IgoGhFa9NLvQ1iEyX7vEMN1An9O+tjZZAHv3f0xr+rW8ce00jkCOWzflUyaI89o5/D6C1CdrE7W6lkU6fRp7/Xwqo0KTpQFEFyCs02JaNFYUFxvd0k4D6kb/MRz1td9z6dtCXZ2vfDx9CVVHXh/Nq7mRht0NPAAoi1ISfTMXXp0ED8swkTkT7zUGkwHVsLBqq90a9/LV2hgOmVrkXcuLNVzsZBgLydYk6B4+ZugqtbZjzATjm+8esB0TwWtUTPR4twj3OSgod6ance9eQbwxYXSXHAZbtDTzeSS0c85Udm4BQGbTJOX5+5NwBkAujMbKZP33AQwZqyona2qyoBS6/IGAV+T1YtWxbW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Nov 2025, at 22:02, fujunjie wrote:

> calculate_totalreserve_pages() currently finds the maximum
> lowmem_reserve[j] for a zone by scanning the full forward range
> [j = zone_idx .. MAX_NR_ZONES). However, for a given zone i, the
> lowmem_reserve[j] array (for j > i) is naturally expected to form a
> monotonically non-decreasing sequence in j, not as an implementation
> detail, but as a consequence that naturally arises from the semantics
> of lowmem_reserve[].
>
> For zone "i", lowmem_reserve[j] expresses how many pages in zone i must
> effectively be kept in reserve when deciding whether an allocation class
> that may allocate from zones up to j is allowed to fall back into i. It
> protects less flexible allocation classes (which cannot use higher
> zones) from being starved by more flexible ones.
>
> Viewed from this semantics, it is natural to expect a partial ordering in j:
> as j increases, the allocation class gains access to a strictly larger
> set of fallback zones. Therefore lowmem_reserve[j] is expected to be
> monotonically non-decreasing in j: more flexible allocation classes must
> not be allowed to deplete low zones more aggressively than less flexible
> ones.
>
> In other words, if lowmem_reserve[j] were ever observed to *decrease*
> as j grows, that would be unexpected from the reserve semantics' point of
> view and would likely indicate a semantic change or a misconfiguration.
>
> The current implementation in setup_per_zone_lowmem_reserve() reflects
> this policy by accumulating managed pages from higher zones and applying
> the configured ratio, which results in a non-decreasing sequence. This
> patch makes calculate_totalreserve_pages() rely on that monotonicity
> explicitly and finds the maximum reserve value by scanning backward and
> stopping at the first non-zero entry. This avoids unnecessary iteration
> and reflects the conceptual model more directly. No functional behavior
> changes.
>
> To maintain this assumption explicitly, a comment is added next to
> setup_per_zone_lowmem_reserve() documenting the monotonicity expectation
> and noting that calculate_totalreserve_pages() relies on it.
>
> Changes in v2:
>   - Reword the semantic explanation of lowmem_reserve[] monotonicity to
>     clarify that it arises naturally from its semantics.
>   - Maintain a minimal reference to the invariant in
>     calculate_totalreserve_pages(), with full documentation placed in
>     setup_per_zone_lowmem_reserve().
>
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  mm/page_alloc.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

