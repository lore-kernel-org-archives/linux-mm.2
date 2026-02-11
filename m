Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB6E7E9E31B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAC56B0005; Wed, 11 Feb 2026 10:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57876B0092; Wed, 11 Feb 2026 10:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A416B0095; Wed, 11 Feb 2026 10:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A2F036B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:30:46 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6029DC1CBE
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:30:46 +0000 (UTC)
X-FDA: 84432563292.28.C98A3B4
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013048.outbound.protection.outlook.com [40.93.201.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4847418000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:30:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=apJJ2aDt;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.93.201.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jj8LT77DWJnLhjtsaq7saV8qJlrVKhbZndSD2asYnro=;
	b=2NjaQk+E61U41KIZt6IrZuYebJbKnc/0VsZCXhsJrBGMcL+PEJCM6asG7hOMs3oMkTtHOn
	JwRpLuNShEgfbwNo5synirssWpWWhyHdPwj7s5o731MbvWbCCQqmdA/fCJ6dYPNO8roKIm
	v3Pmnno6cLc8p3snCKy3dNQHfwpjNCk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=apJJ2aDt;
	spf=pass (imf16.hostedemail.com: domain of bharata@amd.com designates 40.93.201.48 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770823843; a=rsa-sha256;
	cv=pass;
	b=p+b0sNgJrcjJiEGPILDjIDCLsije2/eoLS+Irkiy2qoi/i3a+rYNaYAOw7yzUN0AXxs3yn
	V/d32PWCHapYJTQin5WD0GkrAiWza8Vb7XKPupOeDvxFIuxDWI8DD/5JV1psZqu3GLWP82
	72qqBa1U4HRhVFCwlyjUIHHvBALaRfY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MOL2/wx1SADHGFZpo/mpW3QGYs1n2uOQDRWnbDoW+SyMf2kodGjZyXcC3KNj7ICgtuFmdLsX1kpYmukj0kURcr0IHbS4lR0+XNZfqYUR0ZVJWmlMd20B8jnFMLpg9hMhablwA+9lMmiqsQRHDw57ptjj/tv1XRWf2KaLHuD4rhT4tYrvvnqZzjRVCi7bQbycd0+6QIl0BOI8e+Vago4Cwv3bX59swutEvYIZLAH2GisIcWFOteVvQk477+wHTw1G0kEio3PJWSDvRc3DIhucVkf0c9qcIi5tyajh2iskTkstqkFk3xClABPVWrTPtyl+0fjIarCo1wOHUwSb7ZkNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jj8LT77DWJnLhjtsaq7saV8qJlrVKhbZndSD2asYnro=;
 b=YrfXR9kHvGntZmNNPDddz6AtoqKVYlaLKfOz2JxNZQ3UYmtizcaflwxMTF7qnzRpOgMUxEXCxs1/NEolp7ku+jZlRBN8oKG1g0CBoGevTqV8/22Q6c8l0Vv4MaAIuIzyiPfdJ0LgW2ybKwA2XBVlZ2jYYUdeR42SkWFIbuux4BjeK1G/10Erp6tKU9OyvTwi5j5ZjoCeqnw9JpCkaMZH4pGE+NKH+mDZfMHEUUKEQX12r+AVgU958ClLrX5iU+nfLMYCcf4X5hytLiWavVeDL+T0q93R+N/FOXjmiTE37a1BYtwNt4AJg+7mEdNhJLCDVTuWW58iBjzsw60gHfS0uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj8LT77DWJnLhjtsaq7saV8qJlrVKhbZndSD2asYnro=;
 b=apJJ2aDtRE/i+n6tDYLCTpQJTaC9zahanvwWh+7z/zfVHySmSh/GHy0ZSnidlkBTOFFq7l6w6qnwEOImBj1dvQQYxLJB8+b1O9oromnQwPLHwqvclwgrEYODotgLMG+hdd+evhTu3z0whS2gY94GA2Ab3DgBdOFGfZ9vEh1Kmhk=
Received: from BY5PR20CA0018.namprd20.prod.outlook.com (2603:10b6:a03:1f4::31)
 by DS4PR12MB9708.namprd12.prod.outlook.com (2603:10b6:8:278::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 15:30:37 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::52) by BY5PR20CA0018.outlook.office365.com
 (2603:10b6:a03:1f4::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.10 via Frontend Transport; Wed,
 11 Feb 2026 15:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Wed, 11 Feb 2026 15:30:35 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 09:30:33 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 11 Feb 2026 09:30:26 -0600
Message-ID: <911f316b-87cf-45eb-8d9e-412473d7176a@amd.com>
Date: Wed, 11 Feb 2026 21:00:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
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
	<shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|DS4PR12MB9708:EE_
X-MS-Office365-Filtering-Correlation-Id: b51e1724-982d-4d1e-48c7-08de69828079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkRKSCtQcHF4R1p4Q20xQkxQVWRWcU55bW1aMFRWWk45aHVtcGk2OUdLb2h5?=
 =?utf-8?B?SnpHSlBBcnhxd2tIUklxcXBlVFgwR3UxSVZrUDVQWDU5ZGRZSUR2S0hDM1dq?=
 =?utf-8?B?bTBGVzhoM3RCYWpyRzRERlNSZk5CdmNhZ0M1TjdHVlZhbUUzU2h2ckxVQjJy?=
 =?utf-8?B?ZXZHU3hIc1hFZTU4c1YyYmFWaEdya1FjVjRWbDYrVkRlalBoT3liWEIyMWky?=
 =?utf-8?B?NDdWYktGU0JxdGZQMDg1OXNRZ3Q4MkhqNlcvd3lnY3VFQnFuOTN0dXRmQ2d1?=
 =?utf-8?B?OVRndmlHd0NFc2k1Z3FzZXNteWpkOS9EcXBxVFgyM0pWa3BpNGsyRjFMSE9w?=
 =?utf-8?B?em9Gb2EvVGUxZ0JWaXNUS1Z5ay9ORDNIMnpxWWNMNzF2MXZUMmgxU0RscWFB?=
 =?utf-8?B?OVQzSldyWDJDdHlDcmxncFNzK1JWTWUrY3NkUm82SENLMFFydkFZQU80TFRz?=
 =?utf-8?B?OENFTHJBVytxYVNrdjFQUzZvZTMzUU4rOUVhTCtlYThxZUFva2tOdjRHa0k1?=
 =?utf-8?B?MTRSTkhBbnBBWGtnZUlweTBPMCsrWlE4ajVpMlZ6SDN0WjgvMGhRUSt5MWtl?=
 =?utf-8?B?SG1rMElJdmJLdE1mNm44UnJtUm1LcWRuYUJJL3JXQzJGKzBsN3dqVi9qVTJZ?=
 =?utf-8?B?aWV3MjNEZ283MlI0Wk14aWxHQjBHRDRFclRNWWcxamp6ekV6cFl2TGU0QW5y?=
 =?utf-8?B?VVZvMXpmdVhNSnlMdUIrakFVYzhRSTgxRHpXMlNhWTZCK2NZQk9naG1xNzU0?=
 =?utf-8?B?TGs0K1NKWEx3Y29sZ0JuKzIrWFFuUmhkRjFSbjRuMkJBRXF0dlVsd3J1aHNJ?=
 =?utf-8?B?bEpwMU9Ic0NxZlY0NGphZEpmUGJJcUJTWEJSRE9Sc1dIMUhHcHphWlVxWDdv?=
 =?utf-8?B?WTJFRUEyMnpFSm9paHNSN21XVXk4ZDRtSGV0Q1ZMaG81U2F5RERYZ2IrNTUx?=
 =?utf-8?B?eS9YR1dsbjRDaldWWE1XZDRtTFlGaUVEcXh4eURDaUcxTzI3dGFNOGljbjhE?=
 =?utf-8?B?c1FQSmw2b0g3aWYyalBaV0pldWJ2ODkxd3ZIWmoxV3huSWNRZXROYTVuaVRo?=
 =?utf-8?B?UmJWL3R6enRPZytGZU8weWloWUZxd1Q2clZ2VnNhWWJYL2VwaExha1J1RHZj?=
 =?utf-8?B?dFA2bHBEZUJxaTdGMVJqditIR1ZBMTZGWWpTVkIzWE83QlVxbVBWdkk1Yk84?=
 =?utf-8?B?NENuNkUyeDJMU0N5eTlobmpNTTZQOE96RHB2VlQvYjJaNmFYcCtESFFqVWdD?=
 =?utf-8?B?bjBRTTBOajVGMTNPb1gyMWw4RzZKWVdwQ3hIR1p1d3VYMHMvdEs0T3FFUXNu?=
 =?utf-8?B?YzFGUGczWEVkai9YWXlxeEVkeUlwQlUwdXVhSmUzSFMyaStpaG1CeHBJZnNs?=
 =?utf-8?B?djBzUkFxYWhMSEpHeXIrTmFyV204SEIvVC9vR1lVN1lScGNmZHNTbjlPOXhv?=
 =?utf-8?B?K3Z6NE5PREVZbVdydmVJWnlQYWFUOHZSVk81Y0xxK3VhQm5nU2hHbWt6aElT?=
 =?utf-8?B?WFJaMnFWWVBBTzRrWUd3a08yaERHSWpxdFJUOVNrcVhsUmVJYklOSjRPUzcr?=
 =?utf-8?B?NVZ5RXNNcFF5eVJHdFpkVkkvMjRaVm40UlZWTjBSd281c2RwRlVHM1lKTm9a?=
 =?utf-8?B?LzRIVE80TXVBektKbUNkZWt5SkVUN1dsSE5sOWE4S1FNaWp6Sy9MaUdlNlgx?=
 =?utf-8?B?b09pZXhuQmJaU3Q2UksrbFZqVzQ3TTRKamlrRDU1QXZaNmFobE1tN2orQnVh?=
 =?utf-8?B?bVgwSGREVWYySmdYS1RxS29scVR1UHBqcmhPdVhPaUgxWjQ2dGZTN3RjZi9m?=
 =?utf-8?B?SGhwRHhneDhMWVA3OXYySXpya2hnVUhOMTllUzk4Q0R4WC9lRnFsSXZ3YnpZ?=
 =?utf-8?B?SmNkMnVlZTlubytYZDByWWRFK1loMFY1cGxNRWJTUGJLK1hEOHhlZnNVUFpi?=
 =?utf-8?B?YnFzMUZQT1N4Mm1OZkU2Y3hCZkhpZGNITkJrL2hDOStiRzlWT2srdnR3QnZP?=
 =?utf-8?B?MkpLLzhNVXFoRGxITTJiSzd0dmhMd2RqWXo4UkR3MnpvdGJiN2ZBYmdWUUxW?=
 =?utf-8?B?OEtTTnloeSt1TTZGTzNBVzgxTkVoS1R3a0NONUswWFJ6d3BobXp4Z3R6c3Y3?=
 =?utf-8?B?SjI2L1RvQXQvcXFKaVkxSFJFcjdFOTNTaDVqS2JYZi9sOS9oVjhnQkFMZmRM?=
 =?utf-8?B?bThkSjZvSVA4Uk5ER1pnRjFlZGNUU3dMWCtwYTNuUUxKaUN0RnluV1BkZFc2?=
 =?utf-8?B?dC9reDlWUGtiSkdnbU9CQnBIc0ZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	9+sb4A+Oix5HbHcxEQMRktMrUdu7LT766d1YUZypfYfCgjMx4SV0KupD/ixxDmEFEnjeopIbAD5bS15eLmSyfZ70sCVUXGEFghtAkyQQ4FGuwaIAqCQmdXr1BxrfLmynk08UYkqtgLpiN/qkxkla1LLM5JjMH/bt/5E1xqHKXXdJENw962DNmwUaTdqzulbkeLt2WvXWOGms5Dx9n9rqJ30Duga9dENhjR8L3f40WEe0FsbOt/OGTWH/VTkxwcIUWIPaGsXofOXmePucSNYBb9EuTsdy5HTiGTLzEl66Y6bAqZW66ZqiDgQC/EBuwepqIh/+jR82nAg6OKAxqvxUxf6D9uDyPLVNnehWQIX2DvzRZhvwEsb0UjzJWgDnBV7gmhw2aOfGr3H5Rn9w/6EqyYzuMcVib0p821pOPv4xWaPHtBiNjxmh8gzhJ6b1SniX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 15:30:35.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b51e1724-982d-4d1e-48c7-08de69828079
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9708
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4847418000C
X-Stat-Signature: azcmn4rbxnesftng5sopb3zx1dsxtbnj
X-Rspam-User: 
X-HE-Tag: 1770823843-385553
X-HE-Meta: U2FsdGVkX19ncML0MUykHu/2weD7tWz046kb+6lstMTmJ+qWvta8s/XShIvQkrjX/65TiUmX6bUqspMnAK5dM7Er/gWSNMWZU1bVsMvfN4M3i8fngv1RXxTCs0tLYqJVIqHiRP336ENtZ5sldTldBXU3M9ojUfofMCR3NrhkhzOghG0s8i+BplGBFcUC5ztXwPW2lF6wovRCeLX14/f2cqRiXeKPVw8tveYt4sXt/f+WNCeY/BN9+1QU/EJbdXvHKHPWV8OtGSJ7EqMVn8ihowq1sMulra9nFgr19NppuRAzti/G685x9FXfwfUQTwkcBt34kVyJRI8CZiNIMW9fxPRU6ksIjJiiQKafnbKzuJKd7vRWdXu7l1daeDx/AVv0X1JkJyZlQkDLkl97tWJmUHwp6X7b46jXGnSySDDD8EHsmJZQLq4kNfPVWNNTkgn7Q/vp2Usc82alfkehVcNKR1Jqui1Df/OZIHvlxxDBR29l+paWTORpBPTVNKcNV5W4cfkO/W/RAxv3uhYcaqXfDjH+agHJx4lFmi4r0rpx41tFBCQRt82KznihKfgdtynzL5x8P3VcBIZR3gQy6JYJUX46SaPRD/k5n7xFkpIUdRSOzPvXhWU3Hb2jz51XnLEhBAXenBSIUIJjoklhnv71NQ/8/sAffHvmxdmXE302FXRtRAeB8dHpGSpH7NZM7EDHv2BHK/x9AGmkscfYeu2tzeXVldLAOpm4wDPMhC7F18QYH2OuNUhjDpCjRvTVRa+AEcejfQcLHP8RbZSKDqOIMC5ujUb8Jql82OW+IC5/dv4c6frIYc/NKn5jdLlewapIMdokcXbRhtQk/mZVTz5RRwO22Ud5pwnJBWmtVg+3lud6NiFc93Dg5FoH11jRhxV0twD1LxcbYcNNztKIQ0OIItmqozfNgLzrXpy5lqxs9EB6k2JHfU71zMChHqqO/vCKlu1OH3dfN7RS4fWTFNK
 NESZXxil
 gZDFz15nKYkBOkijA1iMbJ+hyviHQ/TUL1PmP6SlWiuISXzr2wDiyGgVTreLpLJZzOy+r7s5FvcIznTYUEo2uAXOUTQSAUp0vkin+0KzOKWkvMYNSRTCV/+9hcHnXl283izOSuqxbwIgULQgumwXnOlo+QshUPIspt1+qaB76GlcfKOLVnxDHx08FIQK37AxPvajfDpxoNYSG646U5m+kNECJRZlopQl4FEsCoMkNdyQteDwC6k78ecCDOlCqq66+lRwi4mZEtFqharI2el3BBPpcy8aYCRKZL0/Hg5d3Vj3uX/laIyUdOz91WM3IPCNxWH3Kf5Rr6EkFiv2trqJFBVyp2W/gLosRbYzbwVcvYO5XJidpOS1DS8GWF5bt2bjF1Hfvngcl+pIDCJY0dZfcMHh8Y/TzhrgCGmbpFkdz8KSYjavuNq/6qFbisXjsOp4qNjUHABx3TfdNS1Z0AAQMk9C5S5oZaZ+PcNyGL5NxDYI0kTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> 
> Results
> =======
> TODO: Will post benchmark nubmers as reply to this patchset soon.

Here are Graph500 numbers for the hint fault source:

Test system details
-------------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2
  0:  10  32  50
  1:  32  10  60
  2:  255  255  10

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the pghot case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the pghot case.

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

Graph500 details
----------------
Command: mpirun -n 128 --bind-to core --map-by core
graph500/src/graph500_reference_bfs 28 16

After the graph creation, the processes are stopped and data is migrated
to CXL node 2 before continuing so that BFS phase starts accessing lower
tier memory.

Total memory usage is slightly over 100GB and will fit within Node 0 and 1.
Hence there is no memory pressure to induce demotions.

=====================================================================================
                        Base            Base            pghot-default
pghot-precise
                        NUMAB0          NUMAB2          NUMAB2          NUMAB2
=====================================================================================
harmonic_mean_TEPS      5.10676e+08     7.56804e+08     5.92473e+08     7.47091e+08
mean_time               8.41027         5.67508         7.24915         5.74886
median_TEPS             5.11535e+08     7.24252e+08     5.63155e+08     7.71638e+08
max_TEPS                5.1785e+08      1.06051e+09     7.88018e+08     1.0504e+09

pgpromote_success       0               13557718        13737730        13734469
numa_pte_updates        0               26491591        26848847        26726856
numa_hint_faults        0               13558077        13882743        13798024
=====================================================================================


- The base case shows a good improvement with NUMAB2(48%) in harmonic_mean_TEPS.
- The same improvement gets maintained with pghot-precise too (46%).
- pghot-default mode doesn't show benefit even when achieving similar page promotion
  numbers. This mode doesn't track accessing NID and by default promotes to NID=0
  which probably isn't all that beneficial as processes are running on both Node 0
  and Node 1.


