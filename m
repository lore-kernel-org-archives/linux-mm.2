Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C184CD61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204A66B0005; Thu, 29 Jan 2026 09:41:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2186B008A; Thu, 29 Jan 2026 09:41:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CCF6B008C; Thu, 29 Jan 2026 09:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E7EAB6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:41:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B217C0632
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:41:20 +0000 (UTC)
X-FDA: 84385264320.04.75C0831
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F38C12000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:41:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=j+47W0EN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gWcx+pEPLyFB649tRgKtEMqLbPr4LdLvvcxvtRJQM/M=;
	b=cKNNu5YOU7ftxOBAq692TwQoMk6adDhxwXDHb+o3hXT/MI2QcWwpj7KQAO/zYv+5u3c5M5
	gKl/y1aOmiALvcuYGWMwqdWhrNNHNA3a6C5QAEMbvA8LKrnTSFQ1WGr+7oAAvo54mCdekN
	PkJe8h4X01kp6Gk9QWY8aKjNeX1ff2I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697677; a=rsa-sha256;
	cv=pass;
	b=LNORL/QqyT6Obg7sWLWupgjh2vWSUZEJVlIPNuIX/lgDZc2fVvWcYnDZE8lHTkZ9TpiBkp
	c/SIjZtR7ufFYut906cUaiiDvD30KVUu3+rqs4prvCBUYLPUTzF47SX+vOfGQ1ZCPf33Nn
	ha7swhFX7l9vlxlVAJCu/sFkRX4eRwE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=j+47W0EN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 40.107.201.11 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Udmk6K+5DN4Kt/mssoE2dy7EwagTln29Z0hgqr7yJK/nM/lmtFzIIRX60SVphXvK2+XgHNoAPvTX9YjY/2lJ2Xv94pxya8iWZZS+I4P+ygRHdrF9aK78paCXvFx1bLocGxT4O5jYGcMiP/I6Kx8XyJXpRMJzfhY6kPlvxvy5oTZXwShlwMDAbvd6I09JothjZZneWGuF3M/ehmK5qsuYVPtXUNDGYcRHczliuAGHX05UEzrY8ff/7gKHAhXjGqtVFsF5mSPEWV65S9X81egH0/32EwJ3y3pKWJcVr5lOgvdResg3bPOuG8TGEamfLXTyv+xxCZg6a3kaugaJ090PIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWcx+pEPLyFB649tRgKtEMqLbPr4LdLvvcxvtRJQM/M=;
 b=QSBbteVW6g5Zh9oafPuOehcjqXy3LkqcJ3j1tUja7fG1vVA4SO2FHBD28JQh7P0PlcM04veuFRyiaygQXsLnY4/tNTOMCUxIH6g6n8rY0/0xUHyDmkbdXzNFccxem2Z/NLqXZucmRGnLojU0BT51eajifG3VHDVx5nqQ20mV9dDwpeKqhn0c82GszggEwnXykRjK16TmU46CNA2YObeCdJDKCyuSNBta9Ew3fQMrd57OWGyER03tydURF2QRCNm2WtFjoD/sASe0zZghIaw8yU9+maCbOA0zB1V98Q3Y8Ranj2IqydY8Kg/9M5L8RQTsoRf2oewmYS7H+BhwUTT2+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWcx+pEPLyFB649tRgKtEMqLbPr4LdLvvcxvtRJQM/M=;
 b=j+47W0ENCJFNE9xgoTWYG4QYjM40+T8isFaABs6L4GFrR9GFbE6wYHBOx6aX+5FODrul+MiEl/1laz0brfIrxI0GMVvePmUIWe0hEWi8ZIaW5DSFY34TyCnYV8EIWg55Q0KlX/9AHsPEuRUUu86IKyDHL1JyY/4YWARvClfcDZU=
Received: from SJ0PR05CA0088.namprd05.prod.outlook.com (2603:10b6:a03:332::33)
 by DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.8; Thu, 29 Jan 2026 14:41:10 +0000
Received: from MWH0EPF000971E7.namprd02.prod.outlook.com
 (2603:10b6:a03:332:cafe::7a) by SJ0PR05CA0088.outlook.office365.com
 (2603:10b6:a03:332::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.4 via Frontend Transport; Thu,
 29 Jan 2026 14:41:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E7.mail.protection.outlook.com (10.167.243.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:41:09 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:41:00 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion infrastructure
Date: Thu, 29 Jan 2026 20:10:33 +0530
Message-ID: <20260129144043.231636-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E7:EE_|DM4PR12MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: 60e3f4b8-e5f2-45b7-4cfc-08de5f44713b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vi9oN3d3L1kvS3ZNb2N3V01iRzBMa1h0YW11VmJjaGdqUXhtaXlqMm00U3Rj?=
 =?utf-8?B?Smx0czlHTU9wNnlYNzhBdXBIalR6SGVEMTFsOEdKeVhGMUJFelc2U1dQWUxL?=
 =?utf-8?B?YXdJSFo3RnhMMlNMYklyWDRnbFlqdVVURHAyWUVRa1pUcVluVStXMHQ4d1dq?=
 =?utf-8?B?THMvKy9mWW9UTHBPamlHSHowLzBTQ1JTK3E3Z1ZRZHdFU1NxdHUzR210Lyta?=
 =?utf-8?B?Z3I1QlI2ZndtandjSGI3anFsSUM4OHdRRTFuRHpJOFZOWEVxRGxzU3FMdEI3?=
 =?utf-8?B?am80cXBLeFhSbUVyMldTVDRmbDdwWjgyRyt6R1hQZVEzK3NraXo5dFY0Ynk4?=
 =?utf-8?B?UHJ4WUNxSlA5ZEtQYUJMbE1DYVZvaTBRbm56M3VrYmlSUjR4MzRjVm5VMVls?=
 =?utf-8?B?TkVyYjRFcG9HMWhoRmpSUUtnK1ZtVmliRUFhSk4rdlJ5aE5yMGdDWjJRWjFy?=
 =?utf-8?B?ZFlJaWNiSC83RFMwL2JGK2l0MHVLTDJpSzg1ZVRmQXZPNXJkODNTTlRDQVNh?=
 =?utf-8?B?blc1WW9WY1RKdUcwcG5FOXhXWS9NM0N2SmgwMk0xK042SEUzNE9CdUFZaWVn?=
 =?utf-8?B?YXhTOUxrQVdzVXRqS2RWMGhpbEhOQmM0S2Z1cTRlTzFxbkczK2JjNDAvYjdu?=
 =?utf-8?B?M0VRbEtsYWwrclJYTjJDcXYrRHlWOHU3b2tQaVJOOWlJSS8rNlMwVy9hd2dD?=
 =?utf-8?B?eVlQcnVjMisraXlCOE1pMnh0L29nU0k0Wm1xdHc5RFJVSUhtcG0vRFVqaEtC?=
 =?utf-8?B?eWRObU9ERUp6ZXJuVW9FbTlIVTVZZEFuRk9JNnI1cS92amlldGlONWRaYkVl?=
 =?utf-8?B?YkhLaks5WnFlTC81Z0pXQWxlTWRqNmdhQ1k4OEx3SzVIK3NiMkVvczVJekJu?=
 =?utf-8?B?NkpUcExHVzFJbGpNd0hwK1pSMXZLa2VzaVEzSVpFYTRIelhsWitjZmlLSE53?=
 =?utf-8?B?QUpCbE5IQjZKV09xOEdic3BHVDRVRTE4U1FOVE43R21NLzYrUm5DdGhHYnhm?=
 =?utf-8?B?MzhDbWZxTTZUejF2aHdMQUJOL1pzYVpFVzZJWWd5UkhhOEtzV0xxbVdVTUJS?=
 =?utf-8?B?OU5mQkJzbitjc0hWQmNIOXlRRG1zWGRDZzJBb2wyNWlZZEgxNEJpKzMxcjBU?=
 =?utf-8?B?VDNLK1N5YlJtUWp6ZitacTF5Y2hQNFc5NWJ1MFFud1hSaXhQMkFUMDJIUUJI?=
 =?utf-8?B?eThMOXM0bklUVm5BbGVXQlNEU1R3T2pNT2NUSm1XMzZ2ZnE4TzMyd0JuMVpK?=
 =?utf-8?B?TExWMjErcm5RbjVsM0w2Rkp5TXNXNHpCbkxOVzlMenppaDBYaDRnb3lGMkVN?=
 =?utf-8?B?NDI3L2FlbW5Ga1MxUTlLV3MzZEI1ck4rSHVZN0pIazZjOUNBeVFjZ0RWenBX?=
 =?utf-8?B?Q2FQa0ttaHhDd2szRE1jRG1TNHRVS1l6SlJ0eGF3Q2dQWmhlcCszcHVCdmtD?=
 =?utf-8?B?VjNaaExmQ3VJZHNrbVBOY1lMbjdQSTNTQlErUVBtZ3VtRlNYYUh6d3NzOE1h?=
 =?utf-8?B?QWNPaTdrVGJxRzlLRW9JNUtNSEpvYUl0WXFGc3daZng0SDFtREJWYitxdExI?=
 =?utf-8?B?Q2NUQTZGVnlicUlQQmJlMW1UaDBrUUZEd014KzU2MWhSOE1PSnJRYVRKUThQ?=
 =?utf-8?B?YUlrOWJENWQ3aVFGMFphVVFRYlJFY0M4cC9RWlREVjlvSXRWOHhuWCtyWDBR?=
 =?utf-8?B?bCt4ZE50c0IwWmR4SkhYa3hRSlZESFcwTnNGb0pDbWtRSmhmSXRSeGppU3hu?=
 =?utf-8?B?SWduOTVQbUdCYWFOeXVPemYzWkJSS1ZzSWFsWVNNYnJFVFZRYVlDY2pjeHUw?=
 =?utf-8?B?R3pKUXp5QXJJVXVxaE53QlBnVWlYWS9mNDlSTExIOWdWeldFdzB6anpQV2s4?=
 =?utf-8?B?dVpJTXZ5c09TR0hpRkRsMW9SUG1OK0Q2MXBzd0JMUXJwT0pZODkyVm02Umly?=
 =?utf-8?B?dzdBZ0w3QVE4dkpKeGlUbGtaWTc1SVRUb1FyOXFJQnZIbVBjYWJyU0tmNTlq?=
 =?utf-8?B?UzFZelFzc2lQWnN2UVhSeVlpdDRwQ1I0K2lZaUM3QmFlSmVEaDIrNzB2YVl1?=
 =?utf-8?B?TDVLS0t5Tm1nMGxiMjBrOVkxVHRVRFJxYnFjM2hncStTKzltRE54Rzd3M1pa?=
 =?utf-8?B?OHkzbnQwaWRvY01pNGhiTjFZUW9MNDA1RG5pNnJiV3N6N0g2N20wRURiYUdn?=
 =?utf-8?B?aWZVTUh3VVpyeWMzZWROM25wL0hIM0xMQ3hRbTBpeHkyMVZPMEV2L2hrV3RI?=
 =?utf-8?B?TFVFdFFBVkNFTCt4WWpsVVp4N0ZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:41:09.3969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e3f4b8-e5f2-45b7-4cfc-08de5f44713b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Rspamd-Queue-Id: 6F38C12000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: n1borg6oeai1y6uerug1cf47yo6484ad
X-HE-Tag: 1769697677-885218
X-HE-Meta: U2FsdGVkX1/e0zS0mYbrGVgl28ELVcisnu4YFM+GWd2gr2xEjoutg1u96uSxGkzWfCfDqM8rcfLuMuWdLEXciG2EgpNLWvAUlu8GM5jeieSbll6o43+wSZGjknXMxmaxvOnw3hGi1Cmf+7Ey22OLAtoCHpx4K5DzvLazF5jr2Re7T6jGuY8PfLJf6iHatkdYlMpId0GfnZmejd7KLqlh+FQpl0CLTEU8MT3yK7FsCoPfilI/Z3DyMuotSypKYDO/39254fcgBCT0jxWhsppHxtJk0d6m1Il+QG/OMtd9lNFLfPet+HSZbZWCo3rc/xVBP7ok5FCxchC7QJLxEF2SVnWQA+ixjSxcR2YiEj/tJnSGnF205Czm25h2cLH2zbvJAPnQGmnJLsxyK0V8MEYJlXu9cHCj5Cx+JP+pjgl2ichxtMOahDpJIArqOsoEpfEU5YhL20bzM5ao8/bMkfNNqnfWM96GK+bsDPb0Ssp/6xxwGrUfvz1+W/XO6HG+MR2yFKX9UXNxA/xSDn2jj2ZMq7sZoxnrgIuzVcb4pOfoXWxIxqHO2xeveHcKu0yomQIIFddy86bd9/ECBRzgf/X4M7cZvJr8fiFUmMVonU1LYHyWf6w2Nl4xi2csBkFXU653xZMtAwvNeBN2TzfEucFegiBqln0eaesmoot1HxFCvsXj8rCOvx5Bo7leAOmGDBRR1J8ywmKKjrQaqGkcA8G7XTaBB7hUru7CWklTwbE5yROep1ILd8AS4adu3R99QjT3VOG6dipBHJDIt+RNCpEuZmd1+d0UvmW5Y7AHw482lw+chKJmIxOcLPS2x/0TJjtacfhnDYZMJltK+8bsqMk44ojwkQMeSKjSvgid0BVhxWE3a32WvchmkkHajumZM0UJs5LatlNdOaDl742lXcHFcxqc3vkh9yx9Aix3L0erMtpwp79NRmrEsQ9qXDiTCCB34XG9ixIdK/Omvfo6c1Z
 LS/cVjNJ
 Lc6w3TXaW0d9cV+pUCyxWSTP+m5+tvxbJWv58xzxUZYTGkatQdbXQW82ZvOGkuLGTiq/X74QQ1/80Msx1yi7walnVx1tjKFpyA5ZnHswwqJ5aums4YXsnaMykoi2/pY27A6rWyYNMW/Uq0IxbH48EHHcI3LK7JyOJKYYuSbezalNBfXrFUvmacEvnOl5fwMUAv2iBpzgXWPHDV8IfaiQbTWKGaQIXCMtppts4pPTxR1C9ALEyYAIUUiJ/ZoIdSOXzXFubaC39cvi1TkYAHjrKpmNjvfNTDKC/9trj9K6jhDhNQNtC9sBoAKqjJaLVxshudT48Xmf/gDafXR8VvfNYGf2L7L8Y+jJvkyQ5DOnso2w6MyoRtsknateWQuVsyTYTDSVVnyvErT3Fa1PDVzfo8KA/BNdEW6B17wsTqoQ2ltSKB7BHReX3OVZehTy++G/sATXY5pNGlf4Pzxs4YB01OydHOaYBd/112sof6dqV/SREFu94FMsChbDTBWPKH6ywtZ5XYFYAfp/9v9YyHxxlKfzJBxq/EEPuLtCqrMHxvFdRGqwVGLH9SI3+JSBCS7z6T0FXT7zCcoZMLINqC7rMGBYpjzbMEQNs2f5C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is v5 of pghot, a hot-page tracking and promotion subsystem.
The major change in v5 is reducing the default hotness record size
to 1 byte per PFN and adding an optional precision mode
(CONFIG_PGHOT_PRECISE) that uses 4 bytes per PFN.

This patchset introduces a new subsystem for hot page tracking and
promotion (pghot) with the following goals:

- Unify hot page detection from multiple sources like hint faults,
  page table scans, hardware hints (AMD IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lower-tier-node kmigrated kernel
  thread.
- Move promotion rate‑limiting and related logic used by
  numa_balancing=2 (current NUMA balancing–based promotion) from
  the scheduler to pghot for broader reuse.
  
Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses.
- Shared infrastructure for tracking hotness at PFN granularity.
- Per-lower-tier-node kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency and last access time.
- Additionally, the accessing NUMA node ID (NID) for each recorded
  access is also tracked in the precision mode.
- These hotness parameters are maintained in a per-PFN hotness record
  within the existing mem_section data structure.
  - In default mode, one byte (u8) is used for hotness record. 5 bits are
    used to store time and bucketing scheme is used to represent a total
    access time up to 4s with HZ=1000. Default toptier NID (0) is used as
    the target for promotion which can be changed via debugfs tunable.
  - In precision mode, 4 bytes (u32) are used for each hotness record.
    14 bits are used to store time which can represent around 16s
    with HZ=1000.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked as ready for migration using the
  ready bit. Both modes use MSB of the hotness record as ready bit.
- Per-lower-tier-node kmigrated threads periodically scan the PFNs of
  lower-tier nodes, checking for the migration-ready bit to perform
  batched migrations. Interval between successive scans and batching
  value are configurable via debugfs tunables.

Memory overhead
---------------
Default mode: 1 byte per lower-tier PFN. For a 1TB lower-tier memory
this amounts to 256MB overhead (assuming 4K pages)

Precision mode: 4 bytes per lower-tier PFN. For a 1TB of lower memory
this amounts to 1G overhead.

Bit layout of hotness record
----------------------------
Default mode
- Bits 0-1: Frequency (2bits, 4 access samples)
- Bits 2-6: Bucketed time (5bits, up to 4s with HZ=1000)
- Bit 7: Migration ready bit

Precision mode
- Bits 0-9: Target NID (10 bits)
- Bits 10-12: Frequency (3bits, 8 access samples)
- Bits 13-26: Time (14bits, up to 16s with HZ=1000)
- Bits 27-30: Reserved
- Bit 31: Migration ready bit

Integrated sources
------------------
1. IBS - Instruction Based Sampling, hardware based sampling
   mechanism present on AMD CPUs.
2. klruscand - PTE‑A bit scanning built on MGLRU’s walk helpers.
3. NUMA Balancing (Tiering mode)
4. folio_mark_accessed() - Page cache access tracking (unmapped
   page cache pages)

Changes in v5
=============
- Significant reduction in memory overhead for storing per-PFN
  hotness data
- Two modes of operation (default and precision mode). The code
  which is specific to each implementation is moved to its own
  individual file.
- Many bug fixes, code cleanups and code reorganization.

Results
=======
TODO: Will post benchmark nubmers as reply to this patchset soon.

This v5 patchset applies on top of upstream commit 4941a17751c9 and
can be fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv5

v4: https://lore.kernel.org/linux-mm/20251206101423.5004-1-bharata@amd.com/
v3: https://lore.kernel.org/linux-mm/20251110052343.208768-1-bharata@amd.com/
v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

Bharata B Rao (7):
  mm: migrate: Allow misplaced migration without VMA
  mm: Hot page tracking and promotion
  mm: pghot: Precision mode for pghot
  mm: sched: move NUMA balancing tiering promotion to pghot
  x86: ibs: In-kernel IBS driver for memory access profiling
  x86: ibs: Enable IBS profiling for memory accesses
  mm: pghot: Add folio_mark_accessed() as hotness source

Gregory Price (1):
  migrate: Add migrate_misplaced_folios_batch()

Kinsey Ho (2):
  mm: mglru: generalize page table walk
  mm: klruscand: use mglru scanning for page promotion

 Documentation/admin-guide/mm/pghot.txt |  89 +++++
 arch/x86/events/amd/ibs.c              |  10 +
 arch/x86/include/asm/entry-common.h    |   3 +
 arch/x86/include/asm/hardirq.h         |   2 +
 arch/x86/include/asm/msr-index.h       |  16 +
 arch/x86/mm/Makefile                   |   1 +
 arch/x86/mm/ibs.c                      | 349 +++++++++++++++++
 include/linux/migrate.h                |   6 +
 include/linux/mmzone.h                 |  26 ++
 include/linux/pghot.h                  | 142 +++++++
 include/linux/vm_event_item.h          |  26 ++
 kernel/sched/debug.c                   |   1 -
 kernel/sched/fair.c                    | 152 +-------
 mm/Kconfig                             |  46 +++
 mm/Makefile                            |   7 +
 mm/huge_memory.c                       |  26 +-
 mm/internal.h                          |   4 +
 mm/klruscand.c                         | 110 ++++++
 mm/memory.c                            |  31 +-
 mm/migrate.c                           |  41 +-
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  73 ++++
 mm/pghot-precise.c                     |  70 ++++
 mm/pghot-tunables.c                    | 196 ++++++++++
 mm/pghot.c                             | 505 +++++++++++++++++++++++++
 mm/swap.c                              |   8 +
 mm/vmscan.c                            | 181 ++++++---
 mm/vmstat.c                            |  26 ++
 28 files changed, 1917 insertions(+), 240 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.txt
 create mode 100644 arch/x86/mm/ibs.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/klruscand.c
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-precise.c
 create mode 100644 mm/pghot-tunables.c
 create mode 100644 mm/pghot.c

-- 
2.34.1


