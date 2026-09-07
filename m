Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836B7C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 19:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140E66B009E; Mon,  7 Sep 2026 15:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F0C96B009F; Mon,  7 Sep 2026 15:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFDE16B00A0; Mon,  7 Sep 2026 15:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18076B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:58:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48234802D1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:58:06 +0000 (UTC)
X-FDA: 85188027372.03.1D56245
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011005.outbound.protection.outlook.com [52.101.62.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8C9F41A0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:58:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r4TzcxWV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788811083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/M2PszB3lmzXag4sSPuZr8fX+7Ydvg4Q4Uy7bmhLv4o=;
	b=IGe1IjXw2Z5LDbz5tStdmuNkTPRGhGWekOwEj1cLIJoybqfSKfKpH0HhahDhiV9rEypgxv
	nkfqwvOLSJvSRAaxxAEfYhMpZSBkEXfMqL3XrNbekvLVuRCy5Y3now/IKZcaOBoocTcpyA
	BgS4E6mZOMIVPm11ODlhofYhBJbBtfM=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r4TzcxWV;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788811083;
	b=V8y6J7VtAmAvugYlIw3qubrPnp50PxlgyHXtxRIScL0W78S+cl1Ujpw5LfUurlbdjU1KPD
	A0SzWcOhMFJ/UirCDbS2/ENjaA29CIO8J7asVEYHaMnV1lEkSuTeHBvr7FHKq76ESvUuWQ
	Yq9AeoOGkz2Aoza5Yt9W/kgekfO804g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYYSWDYrr90vMlzNU5p5HOl5IoOQwgN29nv8hNdm8qn59YiVd4GjK+3coZ3x458e+gZBrj9BY7sW589DXzpQ6iXVZfikgBkL2xkUeHdXqwezEtWf1cQ0fQXweY8IAj0zwwYitLJPaZia37Y4OQXvq9S0EJHjNCX80I0vMLlhD1WtAB0Dmzgvz03EtTuT8mhyq85vCNMLYoTZRa+6Q2aIkdTTG6QPeW5Cj4XfztiHg/D2jkSykq+UfagdJnaDpB3D1U6hC0A+E2o+zZuyWEZgmxkDIwl6asNQDNSN4gszjB+o1PWXFuFLzsG03g2McB9UQ69NzU4kRAdB/RwM4WQ2Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/M2PszB3lmzXag4sSPuZr8fX+7Ydvg4Q4Uy7bmhLv4o=;
 b=kKj9a2ST/hnGNL8U/9TZrysOWXRxJoPylfTn/qQyjPROYE5VYrPVjLhZANB45eqEGe++lvTf9NkAuLMNDe/BmiiL3oKx3BGwb+im8UPESqkD/yGxI1xlt+82Kx/Nwc358wVxBzKRBJA5hdkI2u/ASA2z2MDlAipBvyF22ibtjNzdgA3cG7uJVI+jAbDWDDx0VwSQlpVYSjlAZjFFZ7xrfWRfcyb64tJp0pwPn18fPZ1OCs730GmTbplM43K1u9KNfRpJOnO2Mb7H8Gzx/JNPOqywIui/zWwsVDtg4Ysi0qeKMNLUOSyYq0dU0Q5zXd2gDr+RWYu0tNNRi+nSJjzfXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/M2PszB3lmzXag4sSPuZr8fX+7Ydvg4Q4Uy7bmhLv4o=;
 b=r4TzcxWVMvMKLgod4LrVdOZWsH5AE0DtyHBiE8sHnEtkJfFiUEKe8nQL2nftGf6FZeQLbYRIcL+CQ8z6vX9YKAKXk2nh2H5A/y4BruKpi2qLruo8RclYJmGCojwCUK4sm5pwZ6VQKb0o+6ZiOehJL1BXCn+Txfgl/em05bcQBeuicahD0X4uOuLfJwwBo7pDsCmHmZhsw6vhwcw7QJVFYtPXuwGfo7gm18DTklmWfBQsxPmGyb5PR6cpUTUJ8KhZvyOfodmhBY6fY/4mEWA/buSkO9Lcr+GmHbC48Dbx/1qT8vUt2w7jyJjr0GGOkc674oa+Z5+UHfSouG3W97V4qA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB6913.namprd12.prod.outlook.com (2603:10b6:510:1ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 19:57:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 19:57:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 07 Sep 2026 15:57:57 -0400
Message-Id: <DL9CLS7A92FX.22UD8JGZT2NI6@nvidia.com>
Subject: Re: [PATCH v4 11/17] mm/huge_memory: move filemap management into
 the file split helper
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Yeoreum Yun" <yeoreum.yun@arm.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>, "Shivam Kalra"
 <shivamkalra98@zohomail.in>, "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-11-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-11-b532a3f20e71@tencent.com>
X-ClientProxiedBy: BL0PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:91::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB6913:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fdf4a7d-8c63-4adb-7c2e-08df0d1a5088
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|10067099003|6133799003|3023799007|56012099006|22082099003|18002099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	9DGOH+J+7/q1+AOzS9/7DCJh/b88V1P/3DU5MT6YUo9iWUnWlVeO89xGTDLngvAODCfoGwur+ru1cQ389nXkEKccvcLbXD02rZKGH8y1VjAQKL/w+g/nbLZW/DYRnfC5LmWB/L6qlbJzEYpHOyAepKGDEPeFzH30Yq5gUVvygJaqjCwL0EfGfQdypUyNR8WZYKknxv4krXT3ftzCGlm8OOc4exacoc9Q2byB+I7YF8UxE+CMDuBrYLi5+LpsKoBu6fHZsNxZcwzSnQm5ovk6OqIPcH0ax+EJA6scYEId8o+zjvwo+ouwNoPbqYk8S3sDqyZXmM2t+glqDBbaIFuZwO9ral7625uEqnhB+CxxeQMjN5Hv/iUZHf4qelojOIZtxBcR+iZWS/oanO7iCG5lhx8FGc5yLOY9qESbPreP8zPKiiC0komoZHBErwuq18Vpnfl5Bgjh4ko3huWZFl+svid0/kZdANPkivWIssY1XBPBqsC5iPGmj8qVf1NTIcgqUl8mGv4UjXhQWouxcb3axGB3IaGd6an1WW1DxpDRLi44MvN6Rb/WvRG2Uydq7ksiXWdMOByvC4kSHmeCIWT07+q5n4E0P2ZQHPtveUKhtvK7deQ1lOINVXRy50KDO7s6k0XlbmqyQwgbM1SE6rHCmZx7VqJTbjRwGKewKYO+dU0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(10067099003)(6133799003)(3023799007)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enVzMkJKbHZMYU5YREovOGZoa2JPVE1QaFZ1RVE3dmJwc1cwSVJIamVSWTdp?=
 =?utf-8?B?bUNrOFhSRVR1TEZRbmJ6WlV2Ung5ZWdMeW9PY2F2czR0TUZGY2RDZVo1S01D?=
 =?utf-8?B?SzhvL1JhZFNIZmZ5U1lJMUowUXYyV2gwaXdGSnFEY0lFd0NYRFFSTE1HRVRy?=
 =?utf-8?B?UmEvMzVpeEEzRmFLT0JBMDg5VjhvMDJNR2toa2NRd2RDczM3QkQxVmIwd0xI?=
 =?utf-8?B?Q2FIQlVCQ2ZhS2UyMnZOYnRaSzRkRVVGS2R0Qm10bjF4MVNUMWdMRkw0Rzg2?=
 =?utf-8?B?bEs4dnRCWWcvdzlaNG93OFN4dFNINUhMWXFKaVZ4Ty9wSCtCTjlIem16dU5C?=
 =?utf-8?B?Q08yZW0rZGYzYkFBajk4enZ6ZW9meWJrbHBnZDdnc3NKVWszeUdGcll3U0o3?=
 =?utf-8?B?dlB4SjVzcVU4V3M2MlA2ck8xSTB3N1VtaEtZeldHMGNXRm5leWEyS3pCK3Qx?=
 =?utf-8?B?YUJNMDZBcVU1UG9vSVQ2ZGxoalU3eGZZUWEvTXNoMW9Cb1VNNnVtdVhyT0E2?=
 =?utf-8?B?eTgrdlM4RWsyYzUyNXRHL2gzcWx5TGtFalBjRDRkWEZHUFIyZkZ5a1BHU1RS?=
 =?utf-8?B?NlR5WGh0S1dBN1RCaVRkbGUzcjRWZnYyZWNVTGl0MDdwdVFpV1NUTkYzUlVv?=
 =?utf-8?B?dUZvZnBOWnRHYWdabXlDUHJHU2lvQW52eFExYVcvUFZtdDJ5MDMzdFJvbk1G?=
 =?utf-8?B?UndUWk4wRkpESXFiOENyQ0R2T0RldWgrUi9MVERLZ0pVRlY5UmtwV3NwZ05j?=
 =?utf-8?B?L293SGwySWhXZ2ZRendCbzhiV01iUHk2K3BJTW9oOC9LRU1iMEpUZ1Q1ZnhO?=
 =?utf-8?B?dnNPdW9FSFErUytXM0hiZ3BLZk05Y2JlN3lsNyt1WW5uTWxDMzNKOTJvM1NN?=
 =?utf-8?B?eXFSbkJMWEltLy92QXVDSHNlTnNOQ0pqN2ZxdEQxOW1sYnBuYXhvN21aVGRZ?=
 =?utf-8?B?TmVkRU5QbDJHak1GMHRRSVpUSkVMQ3kwbnlTUFBhYkZFTFFkZm5UR08rQjRL?=
 =?utf-8?B?K0NwUWlkVW1CSDlORUdzNmQ3dS8wU1VNMms1MkV4SC9CdHpFbnhxSGtjNmoz?=
 =?utf-8?B?K0xNeXN3dEkxWlBpVUJ3T2R5QTFkbHFZYjA4Zk80ZlFma3craVk3VlpVTWI3?=
 =?utf-8?B?S3lscFZMODBYOHpyZHV2blU1OEthcW13cGdHVzgyNVBJWlVqSmFIQnhiYzBS?=
 =?utf-8?B?Yi9YZ3MxcWd2Y2FrTVBpTjFqY3EzZFFTbHdkSm5vWHVweHUxVTUwc21xLzBP?=
 =?utf-8?B?dXhmeTQrTFJoK2JMU01rVWNnRFJRajA0N2JOaGVGS3Z2cHBCUW00dWRubWVB?=
 =?utf-8?B?VTFkNThIYytOQnVkY3dXN1BWYUt5emZ0MWIrTlBUYjRCZ3VEUGhuaXRQc2JP?=
 =?utf-8?B?aEswZXlha0pqdWZFdXVjVUhXeXdTWnFxUFlud2JwM0R0VzBJcWRuc3lNRGxO?=
 =?utf-8?B?alU4NTl6V29MZmZ1WFZySUxsSy8xdjZocXJqQWhndklLSVU3dXkzeU1MbjYr?=
 =?utf-8?B?NEJXSkFKWU0vOXNNVmh5R0JPeXRwcFhIOG5NZS9velhlM0ZHcWVBdHF4a3Iz?=
 =?utf-8?B?cTBjZXRBVTVwTjVnNVRMMHBtZ0Y2VlhmL0Y4OU8wRmM2SVFpQ0pJU2ZDZzFK?=
 =?utf-8?B?S0VFcHpyZmZWRWI5cXd0V3FjMDk1WmZqak5mT3pRU1hmaE5RVFp5eUhJMk94?=
 =?utf-8?B?TFFoVGR1NTYrSmo1dUgyQkxZR09yVVFWcVRYQmpTSWlrdzdpcGpvMXhRQjI5?=
 =?utf-8?B?WmlDMzdKNE5ZWis0ZERvbVFlUStlaFFOUVZLbEtxWTVKd3lvQU82aUUrQXRT?=
 =?utf-8?B?elNJazNvQi8wWHI4SlZLaTJXbFhIanNJcHRQa2FRSFRJb0ZMMzQvNXNhcnZY?=
 =?utf-8?B?WjloUkRFOVh6TkNEMkdJOVlRS1pNRGZoSllLeE0zN2RQTWkxYzhvaFFuSzdY?=
 =?utf-8?B?NjgwR3UveklRdXNLN3J6QWE1dTd2V0xwWExqUEcxUWk4SHRUVWtxMVZZUDhE?=
 =?utf-8?B?U0RWMEVoUk1mS3ZmdzRQWFhjSm54U1ZjbDdPa2kyVDMzcjlXd09MRnAzUFdG?=
 =?utf-8?B?OXVMVUpYZU9FZ2x1NTNmN2FyeG8zUEVrNEF5aUlKbFFnQ0tnOU5HSmU2U24w?=
 =?utf-8?B?QzlFTTlHVmhDcUNObEVyaXczNXNCcTR1SGp2Y0NXbUFYN0xJNkRya2dYL3JS?=
 =?utf-8?B?WXJBNVU2K0t6dHpxM2IxZCt2V3dqekhCR0t1cXY1dDBFRUhCMi9TNUxvQ2hU?=
 =?utf-8?B?REUzSE83SHpIdWFWSjF1RFNCSUh1NkZMSWwyZjRoQlpMQ21kNG5KT3NHQ3NL?=
 =?utf-8?Q?KVqihaKUxl9DFk+EQ8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fdf4a7d-8c63-4adb-7c2e-08df0d1a5088
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 19:57:58.2354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWp9ClmJazsb47RPcqbfNITvaLSK5NuVC/JRdmDgcGx1lx0huB2A60ERGub1s1kJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6913
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u7xk9zcfyohdzxn73bew4pz9abduoe8m
X-Rspamd-Queue-Id: 8C9F41A0003
X-HE-Tag: 1788811083-815845
X-HE-Meta: U2FsdGVkX18ctujnbBX3OjQ5WifEOL0UY9KjfuwWP+oSMPSkuLCxOBoAehJhCYsHR4etFOQJMeEJdbF71kp/cQKbjR5URDLcflBg04JdHp8+yn1szVd8R+fwE2NXQnfrdhQjnKRIBwiv3tYQ/xq+AHE/9+mhiL5JN48dvvqimgCrdtlQfVwy6fkZRCDr68b+AIIWZmJ3OOWXD23YOMR/Nhxy9LzCNv6E0kRwV7qYqjSakQPl8i6guJJ7vmfTc/l7yHgduzd6K13rySROpgayGWy6OpoLZY7D1kzi88eZmHV7B2ICLiUT0hzveTZWoHW9IFOFwSeux90sHvF4tPHTgPN114ai95hRbeLcA7gcxPxlW/uIIN13a0yjMmrp5c3ObsU0rg7CEASicxDeQgjUPDH8/3kO4W25YSIiouP6jFCiCDK+/A5jjLHoWcOdyrdCHkP1scowcmzUfmjCaG6tZbxuYwJNIWYWhw/WKen2yw7RhOwUJckH9g30a/NwuUzdwvhao6yHf19iKQiqpc/938D0pArbq+NkS8CKERsv3UvKpIB7JY7Xj+rQZ6nrxFqf7v3ReGQTMjyYD4G7ajCEIBTQHOAwVVRtHtA7ZcuR33wdetJZn9j8Xf/ZSS4QznrxInx+t9suGa4T3h0Pw9TI9te2sSRmwEHsxdryopubrxIHsygtDeqbVe8hDK8dP0sAt8WxdaQUvrschZQy/4VYex9cpQ2Z6Xo7e9sp0Shvel5atp2gd5DEhbr5zV4FSkf9cVR02LG1lPdbeaGQljYQ4dG6n6hW6N4BUhdpDI1DLWsQa0zlQTaRrLW9Nfn0UEEvYKtzgUTDkVElqj3AUT9GgS82S3FkWqVoK7pDTDT9MBNS1/le/sUonPB0UkdxUlccRYPxqykl48LAjTAMlP83ErDbq75WFLQpc1dajR/4Ysy7ZCiMh0fnk8eUpeIFG8uPVN2Dkk6cip5vp8vut1S
 MURjoaFr
 21ehJRR/C9V9vQRKiBpMB2tQlEdhh3TXxWDw6RFr2dy+JferixdwSJM7BUlYrQZJbRHBqZ70tYBtqBz85jfa+OKSqP2XHsRjl3aTeo8zoT+bjqXCbSC1SRVgaU3TulgM88en9rYZXFeGVSH0jO2O99HVjf+UE1jKlf5Fygv04/UsYZyctiakvBG6GzQHiC2OBYkVggy1GWKnMWC+BU1h/GD6uob+wCYys4z2BLl02B7NJ0JXFdUfR4JayzDs5OJu361eEi/2WnCKA6vWmPbR0VE9Vl+q6shLKxKmydYVn5e+ITGEPEcfp+g3rdg0cVovxZBX0FBfRiB0ot9ozJHhJfTo+IVpKXJfEeZluALVJYAN4T92z2SZ+1KH0ObYtv9NX0d4tcPTo8rpBp5TcaZ0YIWCy2iANW1Qp17VP9cDtzaWPKEmcQ/xLgTDV0dDE0KENtnZxCFXAKcIOwRCwNSJVBRvaDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 7, 2026 at 2:12 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Only file split needs the filemap and xarray handling and related
> variables.  Move them out of __folio_split() into the file helper so
> the helper is self-contained, and simplify the parameters.
>
> No functional change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 102 ++++++++++++++++++++++++-------------------------=
------
>  1 file changed, 44 insertions(+), 58 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


