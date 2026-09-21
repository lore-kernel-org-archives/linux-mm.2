Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7655C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FFD46B00B9; Mon, 21 Sep 2026 13:18:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D71F6B00C1; Mon, 21 Sep 2026 13:18:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F2F6B00C3; Mon, 21 Sep 2026 13:18:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B70D6B00B9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:18:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B96BA80262
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:18:32 +0000 (UTC)
X-FDA: 85238428464.29.A5868B5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id D17372000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:18:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NiMLrSuI;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790011109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K19FL12+fj35r4rbc/LoPUH5Lj8QwKUn+K9RtxcyAfQ=;
	b=n4st8cN3iuh1mliEmms7tQYSh0phGpLDYLS4c5q71vP7yaCby9kRQk4IihfROH7X8574x1
	Yao1kqEz5pWQRPuK1s6oAk72QVwG7RpDOUj5F3mU7tq76Tm+3c6VlVXneW8IvRya0uYK0J
	NXlxSDpyyLD8z5E6CUt4aHxe5G5Q9W8=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NiMLrSuI;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790011109;
	b=23MmB8IXB+cwCZseR80876glnjzphuNhNp+VstR6cRplJYvg11aoE/+nWI/ay5N5yRVtZQ
	gxHPuSgg6DVGD8TC+k9wpMFHGKH+ZmVuRPlOj/1FfhgcIMlUerBvUEnCZ0NruKl8RPbrFe
	NFW3s/Kmc1porcgfQRaoz5t+9rPdZxA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPvzANySFipYLfp41s3/uf3btim9my4pmZtNHiRtk9woPsOjTXD/EIvGjFToUswNTTLWhTVI5P+kyuPuNxpEZ1jqQlluCxLfaY2aTvtgBYAw6t7b27/FSqK0vmos22OzCarMYBZbXNhljTcX8M7NwGqfh3Noyl60g8u9Rn7riNhDz2LLBAQPtJFuH8UW6Z+301J/C6gzNQsMAemZAqX9gzbWEiOZr2Qhwg3/WS8xUoosgdPmNuMuI05t+eVG5/xXpMWaDxexhyX+E5qddfLpYlO7r1Q0Z0VMI6Od1OVZWpUj23x7T8JmCntmTgASTl+9auRR3yXhSc4g15Nq/j5Qfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K19FL12+fj35r4rbc/LoPUH5Lj8QwKUn+K9RtxcyAfQ=;
 b=ccIfGVBggPKGE6f4//tdEM6UsBlBr25KR1if11jQluBWQUZmCEYPZ6WKHafzDygL1KIkwQrd79OkduUJSLi/GbPtOwddJoyrKy0z9h9tvzhTkdZi2J4pqkP3nb/mNL1veyc6bwmUj6VgOGHRJWHSrA18Fon/HBhkVMlUe3S0Ysrpm3Zfix+nOeHLTaztPGz7hbSK4AwqniHNlsCA0oNuPBHX4GLvNDZDUA/ERaIdoFD+ufMeuKoM+/XylXwWCYkKh6KRhHtvAGoJVFDEXoxj06qW3AoBn0gSU0fhjAIxgavVAphAD5I0Ry5zVL6LpjxJ6mNM6lvciHpuVsamOAKzOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K19FL12+fj35r4rbc/LoPUH5Lj8QwKUn+K9RtxcyAfQ=;
 b=NiMLrSuI6YhSE4YcPSipiOObArxkfntYL4MbQit5prCGv2xG5sTrfUOT7Q+L4+E53IrFpasa8H993Mv3cZSpvQzPWlJ29IcqV1Cb67aU76LLxLn4kfxqh70Uj68oENbFi//iJ74mA4zMJmSMki5l+jtyy8gvpxN7woE30q4oDRkS3opkbUl2UBlLKJzw4lH0KAs3/m9Z+Wvx308cAGcM24kgZyfpByOEZCf3trIxVeL43mP99RnQvWPgtPmVjG99LxmCbNh0KvM5ANcawiFiyOTdtdDX8R1sTC2LpzVJvEgHYEf3UUu4D9dm1Vj1UDxYUunPwydDZ4oI+d8XxFJYpg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7729.namprd12.prod.outlook.com (2603:10b6:930:84::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 17:18:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 17:18:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist() out
 of build_zonelists()
Date: Mon, 21 Sep 2026 13:18:18 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <9CED0F0C-E5A6-4E69-A6A4-A0361AAC8E30@nvidia.com>
In-Reply-To: <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
 <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
 <arCeH_aD5PUM1tNE@gourry-fedora-PF4VCD3F>
 <C7A2977A-CDD8-4EEF-9448-A130411878B6@nvidia.com>
 <arFaiV9iVgxIsZ1g@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0896.namprd03.prod.outlook.com
 (2603:10b6:408:13c::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7729:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c9dd6e3-bf6e-4a1b-92b3-08df1804559c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|10067099003|11063799006|5023799004|3023799007|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	nfxMALzAh9QFU2EB3gElcs/AHVyHXqzCcoF8BIbNNckjGlNKTwEqouuw1rMPmWzmtBSX1LOY0v8Y12jAENW62+IRKdJVqK0Ro+zCnWQlJ1saW2O+ShgO1QeuCeSSrgRx5hJT/0TmEYMWs4tMkrgAD9FGd8N/Jdll+iiLF92Samu01H67IqmAZJxCFqwlfMwhWyNzcHSFLpxmcEokfoFPRj6vbMtdj1cU9VVONpLov2h7+a7sWttj7oSuYs+qEdtpr0zm+GoR6YaGmuzhVMOGo7EkkZfLVDsEb+HmC9+qVwicPJunSIgHsJuQyDIH010KzGX1pTioB4A/K7KKFiiXm1Hg+eXToDMcVuwPGHfCe4PvxmHprzgZF+jO2SOu+ExtGr29mcxDiQxqRwAnBVcaTkgDBg7R7cAO7nOf5lGekmwK6app45j3y6J++6vTEYMDjVLni3lTMfbxOcrZGZBDN7UhFQUIQeWb1gI8RpAr3bFE9tH0/tvp9GTYtrDRXVn+oGU7a94AyvGYixeIi8bgYGZe8sskymCRzv0sjgHXxTwWhZ2fjq7zq/TVPM87Ijq23LjIKejKP7lYeQKcEz08L2+sWxr+mNlrtjoS27CQZXc+0i46rKsy8u4GVXQJTr3JXufNA6vZ2iJLoHocP/dStMM3zc6eHWeHfKwwLPi9lLs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(10067099003)(11063799006)(5023799004)(3023799007)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFZJUFdrRW5jUlhHR3NYNUpPd3cydTZvY2hqRjFCTGdmc0JvdWMrUHlUVzUw?=
 =?utf-8?B?K0liYmJraHBrckNOOEhTWWhYY0JwWlpZM1BUT2ovWlljcWF6OEp1TUFaaHVk?=
 =?utf-8?B?TW1vZTJyQXRJNHpxRHZnWkVzUkVOcXA4TmlUemV0SndrZGw2ZlVLNC9uYk9v?=
 =?utf-8?B?UU40TVdkY3I0Zmk0Qm16dHVJYW5XRjNzWmVTazdXYXluaHI1VXFoR1l5cWNQ?=
 =?utf-8?B?MHpyWXVKM0gyZTBaRW4vaEJlWnpETXV1bUYrbC9OR2tJR3VuV0hVcnAxNjhG?=
 =?utf-8?B?OXdJTGlTRDJJZTZESld6K0ovN0xGY2o1cXcyNXdhMDRZZlVFT0UrZ1BMcXpE?=
 =?utf-8?B?bXFtb3E4bjI5c25HUGdrOU53dTYwNFYxK05zY2FycXU2NlJDUnhxUWtWTkxp?=
 =?utf-8?B?emFDR2d0NGU0aG5jVGFlUTFvMVE5Vnd3TDM5WUZQU2ZuRThML1E2UEJwZFFN?=
 =?utf-8?B?aG5iVXBWOHhqM1ROeFVzOGZVaW1Tdm9WdDBXUEpramdwVVVrVkhGVGZvK0Vq?=
 =?utf-8?B?dCtMNXZrMjV0Z0NteFg0Ly9Ga1NObFQyWkJHVUNicytrNlNxNkNNTEw4bDMx?=
 =?utf-8?B?Z09JMG0rWS9Pb3RiZnZ6ZWlaKzVVVFVRWFhJMlFtZmZsL0RkcWRHaFI1ZnEx?=
 =?utf-8?B?L0FPczE2WUdySXpNalE1YUQ2Z2hiWFkvQ09jK0loRmRaYkgyY0dDcWJlRGxE?=
 =?utf-8?B?MWZQQWN0engxNnpiZEluQXZXSncwck5ZK2JOWnZ6MzRKVFc4YTRwMFh2WFdy?=
 =?utf-8?B?cCtEdDJDV3hyMVdaRmJFZHROMUoxQkNhZyt1RUwvUTdlWXZCNlp3TDA5K1BH?=
 =?utf-8?B?cW93aC9QN214ZmwxQllrU2x0d0FuYTNCUTZhcnhmK3FZYnJseXhxUk9zK1hy?=
 =?utf-8?B?NCttYS9scG9LYk5OZWlReWtxL1NaTXd2TnlTOU5KOWZGQ2R0emVuTVNmSmk3?=
 =?utf-8?B?Z2o1amgvM083RUZ4U01ycWpGQVhURmJSNXdKWFcrdzRxUTA0SWh6SngzQ3Rk?=
 =?utf-8?B?Tnd5SGV2a3N0WXZDalpXN3didFAza3ExajkxMGx3NkUrOXEvdXRWV1Q3SEhI?=
 =?utf-8?B?ZzY5WUlSSytZMTQ3N0F6VUJEY1JJK2IxSHBVdGxTZGwvNzdmUzIzNmx0ZnNN?=
 =?utf-8?B?bG5YdDMvWmE2ZmhzaU9YUjdyazkvanIwZVpKUkNRcVlZOGlkL2h2bVZZRTd0?=
 =?utf-8?B?aDVsTXJ2STFGYUtWd0cwNit1ekp6MjVHM3dCQXUxZW14N2pPa1dGSkI4VHc5?=
 =?utf-8?B?ZnlQMGZkRUZjd3RWVzR3dGdING9aTTJOWG51bjhTVzR5ajlIalNFY1ZkU0tE?=
 =?utf-8?B?RWFsMHNHSDQ3WnRBa3k3d1lRZlF1RXZwZzMxUzJvSzRsK2RMbjgvbFpTZnFN?=
 =?utf-8?B?WTIybzRKZUtTdVAvQXFXM1FCRzNTdnNkSjJGUE1jdTUwNE9aeEhvMlRmK0Vi?=
 =?utf-8?B?dlR4VzdINjNKMXhzbC8wckExYWFLZ0VHcWpSZVg0RkdHcm5qUVprak9NNkZr?=
 =?utf-8?B?dlByMHcxZnN1aUMwTE45YjlrKzB4SEVtUGVxOG82dEYwTkNsWjZaaTJPbUlH?=
 =?utf-8?B?VHJmQ3NKanhnT2krVC9RNzV5TDYzYzdNTzVaOVlheG5DYnVGaHFqdkl5azhi?=
 =?utf-8?B?T21aZHVsRCtHMVlWRi82bzZTemtpWEFLTWNpOUc5emhWRjVPaStQeU1JVVNE?=
 =?utf-8?B?K1YybDlET2taUmgvRWw4S2VEQUttN0E3S1Q4S1JwWTJhMUxIQnJ6YVBLL3pQ?=
 =?utf-8?B?RWcweE4xQnM5eTF3dGd4akRuVWNaWVlrU1lJMGRBZzVwWXJ5SWozZjVQZHU1?=
 =?utf-8?B?R3BIK3RXUlBiWW5TRFkrUUhUL3hNSHhTd0Z2UVBFeXh0NTBIS2ttbzVKSlN2?=
 =?utf-8?B?K2F4N1JpelBEVGt1YWIrR0J2aG5GTmtpSFcwMkNSUnRSbzJ3MjRNd1F5cm9i?=
 =?utf-8?B?cGFvYVJ2V1RJMS9pdDdNR3lCY3h3WEZFb1hPOFVNb2QxYXp3ak8vdXhZaUFM?=
 =?utf-8?B?MlhoQlhoK29nZTJYMVZmMGZFMmprNkt5RmJVZXhMK3dGMmQ1dmN4MHZsV1U0?=
 =?utf-8?B?K2Y4Y0d0Rm5tNmdFZE5yNzhoc0IrM3dMVkRhYlBGdXVIaWFoV3hOUmxHdlJS?=
 =?utf-8?B?a3cxek9xUVNaT2M1WFR6RTFZRlZNMHJoeGpFdjNJVTBqYytONzJwMEwvUEpk?=
 =?utf-8?B?ZE9qOVEzemFQdnZheTNpSWdST0M0MzJSbGdobW1lemZHZGVRSXBwSVJZOGkw?=
 =?utf-8?B?MHplWllHQ1RPMERUd1IwOXQrbDcybjVNOUQ2aE1mWVVRZ1lMVXVDYjh6bUpz?=
 =?utf-8?B?bU9UbkhyUWE4TUxDdkhBaDdySmhCdTF1dm54MUR2Z3JVRlpXVnB3UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c9dd6e3-bf6e-4a1b-92b3-08df1804559c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 17:18:20.6435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2SVxQBEfzEVV1szRmtQiOTcYam7Kb6tasbYpBNhINKWyWSYOD/ohJVTPsw3khId
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7729
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D17372000C
X-Stat-Signature: f6e3omdasruu96xq943cquo87kgwddg5
X-Rspam-User: 
X-HE-Tag: 1790011109-39141
X-HE-Meta: U2FsdGVkX19SVkKFDvN/ttkZAdUwwWBCWFUTzEDXTlmLoUSo0gA/1BXqFIBMmhLaKT+RBgWQTVcGhDhsRgP/+VEUqAwhk9yt7lcr7X3rdI2HlQGNe5JJ1Qr+V1oJcCUt+KszmorcVElSelx5vpPWMJh5Tl0W9dGE0NfKqfivXOQt4Zn9837NniwyHUdhE/o7qWbqp/lvfUw7/5F/4EX0b5f/D5UmInyvlZxKEJhWC1SWEjOeFohjLE0IfAusGIIC9HHv78rtvHfd0vLzl8Ge4/VJuwr9pc8YXSa2eIO8xUoK323Afr717jk2VR4CWdBeZ1tfWSSyECvK2e7nW+kwv0tg3A6/dghMG469aMCT0IEVcPhP0fVUAdCl48sbbYxm4MwdT9g0gg1mq/TgDm9AAeO6WfTo90R6bxLyJ2Kai3P9u3OWPqYq94HZIuDaJpglgosP12cW6EytILZgwUd5Z+eDW0sdWviElZ4R73BKQg98KAz8XazFJnIoM92619oR+3louim6IePEpS4g1UdIqSCUNBkUNZVfAr28rBu14iB1EOJrsxiniGWvLIYTb5w1QlqWPKBI0nd1Bny1CNjOwp1r+lig0Gl4wMQ0y7Xm2L/k1/MOwj1gkduSQGkKRGNKSQA1hDKh/nxL3Lqpg+rKc6VkQs+19ecNUfCOburcn0CdYWLXzIiZEeu+0RN2SQfNghtkb/7qD4z4iibUYD5NTbeivU6UPR7AH48mrbvS+OiUdG8APVkC/hbzUBdCGWPOT3n2DaK0OX1YhPhfxa0t7c78ZpuKO7hx2uFkZQ47L8s0ATOz3RkTlzDUSId91W7oGgFBUB1B8oxzr2CgRSzzXB7SBeh4N4/cVv+IcVyFeU8iYrVwCOIclUGnsh+IXitSQSNMlyLq59NUwCzAsRCEPDq6ZjJ4BZu1hNjKHDBGBVRPK/ne1molM3+hmwDFqGCq0yGftqv+iUKYIKBFqQ6
 QCfSKHy7
 f9OFDO3+ONQ9jswT0iF6zwmGrRL5CAGzLpzo86/dLXFOA/+SUG4uvnaFNXYYdrYIv6SmFYUZpBv18hNvEwxvhwe2TkPRSfD2fM+LFPTrPiBekgF6YVLga5ELjoHbmcJvXMeBkBy/IL3jUQir5R5MO5fsJucl9EehhwRe88cRaQCLSJgGmsnYCaTzKw5KElnr5l/ZzLM1pjxgO9x6dejfpLd1WlqvM2FWMI1JkIXk5WREvS9XPBM3rS7lV4iF7TwRUScaSaVvXyE1VYrl8C+KV9OgJnaFTHx5oCJQ0Bw30X1GOO6Zckh57yAgOrKQlQZOD+fNZLTcl6cbSD2tz6e9LPfOzutqZBxHxPzoOD6f0mdiCR0AISosfHk4d8RBX5ZgzbVpce9hg5strFXg6clNIDmfqK1scc6wS60t51ObkQqmhNvX5LR2ntdVIsOMN2G33+unKnGcjGXScty6eIYUoCBlqMXvqnmDiy670Y978oUdMPJRufRwDA2ENXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Sep 2026, at 12:38, Gregory Price wrote:

> On Mon, Sep 21, 2026 at 12:18:12PM -0400, Zi Yan wrote:
>> On 20 Sep 2026, at 23:29, Gregory Price wrote:
>>
>> OK, ZONELIST_PRIVATE and ZONELIST_KTEST are not upstream yet, right?
>> In theory, the new zlidx can be added when you add new ZONELIST_ types.
>>
>> I am OK with adding it now, but you could mention this change in
>> the commit message to avoid confusion. Something like,
>> for bulid_node_zonelist(), use ZONELIST_FALLBACK explicitly.
>>
> ...
>>> And add a BUILD_ON_BUG/ASSERT that forces any CONFIG_NUMA to have
>>> balanced zonelist additions.
>>
>> Got it. Thank you for the explanation. Are all combinations of
>> {ZONELIST_FALLBACK, ZONELIST_PRIVATE, ZONELIST_KTEST} x
>> {N_MEMORY_GENERAL, N_MEMORY, /* private only */} allowed?
>
> Slight inaccuracy on the way zonelists are actually built.
>
> Every node has a list in every zonelist.  The contents of each node's
> list in that zonelist are limited to the candidate nodemask.

Got it. It makes sense to me now. Thanks.

>
> So consider the following nodes:  N0, N1, P2   (N=normal, P=private)
>
> With the following candidate mappings:
>    FALLBACK = N_MEMORY_GENERAL  (_COMMON)  (all normal nodes)
>    PRIVATE  = N_MEMORY                     (all nodes)
>    KTEST    = N_MEMORY & !N_MEMORY_GENERAL (only private nodes)
>
> FALLBACK
>   0  :  [0,1]
>   1  :  [1,0]
>   2  :  [0,1]  <- private node's fallback list is normal nodes
>
> NOFALLBACK
>   0  :  [0]
>   1  :  [1]
>   2  :  [2]
>
> PRIVATE          Accessible via ALLOC_PRIVATE_ZONELIST
>   0  :  [0,1,2]
>   1  :  [1,0,2]
>   2  :  [2,0,1]
>
> PRIVATE_NOFALLBACK
>   0  :  [0]
>   1  :  [1]
>   2  :  [2]
>
> KTEST             Not accessible via any flag, completely isolated
>   0  :  [2]
>   1  :  [2]
>   2  :  [2]
>
> KTEST_NOFALLBACK  Not accessible via any flag, completely isolated
>   0  :  []
>   1  :  []
>   2  :  [2]
>
> I haven't posted the ktest series yet, but it's how i've made the page
> allocator ktest-able.  Ktest is empowered to set the fallback list
> directly rather than requiring a flag - not something any in-tree caller
> can do - which lets it limit allocations to a private node and makes
> mutations on the pgdat for that node deterministic from test-to-test.
>
> Works on UML too, so testing is very fast. :]
>
> Apologies for the added complexity in the explanation, but I figure it's
> worth spelling out.

Definitely. Great information.

>
>> Any enforcement if not? This is more related your “private node” series,
>> instead of this patchset.
>>
>
> These zonelists aren't something we're going to allocate dynamically,
> the enforcement is encoded in the function (build ZONELIST_X over
> candidates N_MEMORY_Y).

ack.
>
>>>
>>> But I don't think it's strictly necessary for any of this, and we're
>>> just shuffling code from one place to another.  Probably I can just add
>>> that improvement when we add the next zonelist.  In the meantime - this
>>> makes it easier to add new zonelists as-is (and just makes the code more
>>> readable).
>>
>> Sure, no rush.
>>
>> Feel free to add
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> after you add some text on the added zlidx in the commit message.
>>
>
> ack. hopefully the explanation above helps.

Yep. :)

>
> I will work that into the commit message in a reduced capacity.

To be clear, I just would like you to mention the addition of
zlidx to bulid_node_zonelist(). Thanks.

Best Regards,
Yan, Zi

