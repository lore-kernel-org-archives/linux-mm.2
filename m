Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63F4FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C1B56B008C; Tue, 28 Apr 2026 09:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599906B0095; Tue, 28 Apr 2026 09:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF9E6B0096; Tue, 28 Apr 2026 09:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 390186B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:13:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC7124017A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:13:14 +0000 (UTC)
X-FDA: 84708005508.11.1BB534D
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013043.outbound.protection.outlook.com [40.93.196.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1D02340002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:13:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H0djNUr1;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4vEfpQ5xmzlwBprzz6WGr94gToNm/LJG2bcH6o15E+8=;
	b=t2dvH1yjLwv7U92eliIfjqlx58cYLibENr7JPTmqHlIga9wYzh2iJkCdGzVmQF8pFtgw4G
	Wv+D3s3DgFK2xm16l1WoDfuyU9G23uNBJRxpng/krzrDRbwgdMJMeLJIv1YYZNvqTLwKBb
	T7LqMjAhEgz9XD2pL+yT/AGxplIzRm4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=H0djNUr1;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777381992; a=rsa-sha256;
	cv=pass;
	b=BqoT19Naj/iLlmWC1ZjjKvMxtVAg4vJRSwaFXTBwunK0A3LkCVGNsVvvImNby1rldCly/o
	ydXOlbZPRD2NyMr0AgEVSU7epKJbWwwWha8h1uqKjjr+WFoFoeVNGIr+DzdpQ0fSfjNpHc
	sH7OYHUktR0kNHEQHnzhHaJFMn1oiO4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GunrqqQ9qXzAtDebt1P8e+yrVgRihvLREMGzRg582q7EMQEnujsS41sRaxBc+sZ5YCWmgeTrj5vb/pQkrGxl8IsqKSbX3crE574w90asgmJHERcuKajhv6aX1rAKYEjE5uKzAVJrOz/TxkxDCyI0ScB0+tK8qjn1rRD3DjV+C5ykegxgR8YPX/2aKrj75XuKgoSkM6Af4HJ8Rml4JYpYJfRVvkO3nSiWeRJ7vYJKbaFSWjV6OaY7tGyo5upuJfMTZZRCq2pY+hN/JcRkEE7NGLJPnYduGVrO4DwLU3/jPEHv11DXT8ttYx0+UC2AfstjLVZM5OFYdGA4CqPXOWTLZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vEfpQ5xmzlwBprzz6WGr94gToNm/LJG2bcH6o15E+8=;
 b=ET3PuISCDzDq0DM3+mEfNjmBHIembHFKZIvU3JII8m58V1sNQFPHxfvebo8e5UMT/nw/jR368dQ4n9KDzyTUuSyAlqjOfLXERwur7dMGs97Fe32L1sAi0dixZPUDZsIu2vDrbGPqQgJMs4D6PyTRnObEnplik8qjniCslR80bA1/qrYkjPK+PNW6OkKaqyfqilJrHrGoEb4bOuafGBugZPLxbbbVdrfMJi2dzQn6AFXK/eibv35csl+gvmDRd7THVtegmTGExNRs5tsde+nhKeAab4hy81T6tFUrmsT+qbF8Rlpmb+ZQSEkt8Eiw7t7run3AD+Nh2VOBcz/wNhx2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vEfpQ5xmzlwBprzz6WGr94gToNm/LJG2bcH6o15E+8=;
 b=H0djNUr1R9abudEmjLG/nla2NPvJmFCdG4s6ANtnqD0Djvbqx1ZPUcsgNsN8KOUx/ZS2jUmtYHBaSy4T/J8ia5H8El5ZcxFmPeqWWaIGhhO2/p/SI1oLJuDzcJLWp36V34FE6eYLn5ZZHOOMuTrs+buDjpngUbVZt0z558WskUcS2lK3urJoNQ43fLhMYwrZBbvyb1WDLZKc3XqNpDOy5hWRchWtFkZXJUJT1o8WF1nEmdbyH6b08vY5wkMZoGcJIPqJdMqPPUSpcgtHu74sdIyiBRCRx228epbKbsh/VNlXdWgqPa7rEtsXMVzJOXbdjnT8XdTqFr7P0a887DeNow==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7856.namprd12.prod.outlook.com (2603:10b6:806:340::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.17; Tue, 28 Apr
 2026 13:13:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 13:13:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/page_owner: add filter infrastructure
Date: Tue, 28 Apr 2026 09:13:03 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F8F8A2DA-CC65-491B-B69A-2716186D0495@nvidia.com>
In-Reply-To: <7944d24f-f29a-43b3-918b-ce25e7bae520@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-2-zhen.ni@easystack.cn>
 <12259EA6-2095-4F79-A7C4-E89DAFE9E8D6@nvidia.com>
 <7944d24f-f29a-43b3-918b-ce25e7bae520@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:408:e6::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: e1745ba9-bde9-4bcf-7eac-08dea527e309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AAJUNzYSG8OW4gAavyGGD11VLn/bX612rZcU5R7li7cmL7pdUK5JwM5DI6uqee1zuRtl+KUQlTmO44j+GNt/IkdXXicFia/WjvmfUH5k8jRZnqc5UNbkIk9PvSVafhTvfgykM8+pn3zSobZOsriLwp75irqG8mmzCti9ST1v8cIrbT6Nio4UkyD/TrxDQGv2bEU72SOCrfaSG3Bq5MtRu3v0uOfxW7ricfh2ZtAalCmOBEUC3sGL4NOmKzvxZ3A7LoyCV452l+16kq7N0ZnppL+cyPV2byRY7IGiLMSJq3GDo6E7N5jirj9cFYp4u4Apm8tdgKqQ3t/5rmMSNyMh4YQqrw/Q87NjwUG9nj+pjbVI9eprVcD7XpqklPYo9XbKyBsTUjE2CeW/1/6hQ/ySzS2rMxaCkXIcfq25YHU+ueZx7W6PXM27sRUFVesI3XelovujiXbKwBy2F1ywkFK2fNVj2EwEPPnWc9/Iguzq2OcmViFneor+0LnwjfmJWxxKYyyWWFJUV6GDn5mZEpuQ+vRUMkTB4mkR9hqe2mAPzxoc8fOmc+DcPdOo0P2c6Ae8SjuDfGaEtgiMowXR46gXD9Lj7LkV4L+36PlAtn1x4lLcR/eDM6qAvplUEj4iO/1NJOTf5Br1lG5MnFlnCj3uZALq4fjuydFHTI739n1UjFgmKHT4LIZWe5NVq4WrKw9x4NA5rcKORndnQyLgnlSfTdoPtkmzX1UUWw/G4PV4M2QuFnj/y8ZEm+7xazTYVK9x
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlBIQkgwcXU1Uk1nU1NJRDhPdFdTd0lsWU9PTStFSWZFdzdpZllIUmIvdHlH?=
 =?utf-8?B?bXJkYkw0dCtMUnZuc3RxSVdDdWdvbm00SnUwbkh0c1NBV2dsMmFId05TRTBs?=
 =?utf-8?B?eFdxaHVVaXFBdFNZdlB3aTQyQ2hUWHNjMFlJdnNpaWFzT0pEVTFNd2tNbEVS?=
 =?utf-8?B?QXBpUWh1dk4zUXVOQ0lpdUJFMVk3ZTdPZzk4N3lQdjBpd00wK1BpVjloTEdR?=
 =?utf-8?B?K2xOWFFHSFdDdEdVeGhrckpoak5ITCtHbGxZdDJhS0lSZkxyTi9UR2Jycjh1?=
 =?utf-8?B?bDVENUZuQmVoTXJ4cjduUktkVTBDdENGVzZqbHNLK0MxSVp1Z3RFUXhENXJM?=
 =?utf-8?B?Uk5PZm0wSGZoZXZHNjdFRncwbDJxanhhUGlPbndNNUxSQjAxajVpL254cjRE?=
 =?utf-8?B?M2VYTjlxSjhWbkJjVDkza1dBSXRVZWdKMHUydnB0QWNldDdmQXVvVFBma0dt?=
 =?utf-8?B?QUxhV0lxczdKQ0QzYnpLcUdkdlROUzBvUDRKTmNoYWxGRWdPbGFQTGFvdjds?=
 =?utf-8?B?ZFpHSzhhekhYVjhRTWRHWFl0Rm95OUozZHlmVlRVNi94N3RWS0h3T0F5OTY5?=
 =?utf-8?B?bXB1SFphM3lBaUlIdVArZmQzejBpWndPNE5WY1ZodXg3dzE2aXJKSXVvdUgy?=
 =?utf-8?B?Ky8rWm5Mc1lXVkNuWUg5dUQ5MnNIOGNONjBOY3lJMG54bEorNElwUWh1eHRY?=
 =?utf-8?B?RUpBVTdjUUlHV3hNNzJQQThteSs2akk2SmY0R2Y2L3BDZXN6NTRMRFF6RHhj?=
 =?utf-8?B?QlZST2pLV1JrMGdlNFU1NE9sWWQvc2phMlV0WXdxWmRLRklUMmxXZURQQzBI?=
 =?utf-8?B?L1dzdThzcHpwYSs5Yko0YWZCcml1VWkrdmdqbmhiaWxOT3VneFF2Zm1FZGFD?=
 =?utf-8?B?aXRvckJIL2JBZEhrQitobHg4dGtIRTEzV29YZEN3ZEpKaFhva0l4ZTJqVFgv?=
 =?utf-8?B?WjZwYWN3cHY0aHQxdVozd0tMY3RnSzBTQkc1a2R4ZG9LelNNa2xCSFd0NlNs?=
 =?utf-8?B?RVlEZC9CcnVTZnoraEdtbG5zT2tLTzE4ckNickZvMkNFdW5qRXZDdUNVbHVn?=
 =?utf-8?B?TnkxMzkxbWw0aEN1YzNGeVlDY2JveEdNeVRZV3lWVHZ2SHRpeG1GNGx1aFp1?=
 =?utf-8?B?TW9Vd29hNmh1YU9laTJoMno0bWh6bDRPZEJucGJZOW9qbzZZeDU0UlAvKzhu?=
 =?utf-8?B?SG92VnowZ1JMYnF0NzlZUUxHZkRnTzF1RVN2dWhKSkxlS3JySEVvTCtBQmVN?=
 =?utf-8?B?Ri9LQVo0VjB0aDc3aEZVVHhZdEw3NnRCdnQwNGZzZGJWbXJwTVp4MzBNaDVw?=
 =?utf-8?B?VC96emdhUDl1a0plUEtUZXlJN1k2YUsvTC81RW9qRjlOUnlhaTVIOVRzK0dH?=
 =?utf-8?B?a3ZjeUNxQStuZ1o5YlUxNGNibHduQ3JtUlNRREVHWDM2QmdrYzNBd3NSaVVv?=
 =?utf-8?B?L0dkVG5ZZ2Z6OXQ5QjdXNndpaFNNN0JIVG9ZQm5BUkhhN1EwUm1Wc1c1ajlG?=
 =?utf-8?B?UHBkOURBVVEyZWUrMW9abjZXMjlJRFBnQWRsWVQrVDB5ZDE3bGpRN3pJVVhq?=
 =?utf-8?B?Sm5UN3BLOHRaUjFsMFRWNmRRWVR3Q1lOVkRVMDZtNktLNGUzejVMV2t4MmJi?=
 =?utf-8?B?alhRaFAzWmRDN2I2dzdnZ3lWYy9iM3JhbERrYkFTQnFicWZ0UHU5dStOdFZQ?=
 =?utf-8?B?aGpLSzFrc01lOWNwTmRzS21qZWpQQzBFMlpTY21kSWlxdUk4UHNlMUpnWkpq?=
 =?utf-8?B?QkYxdjhLNTFOWWhoQU1wem16QzFORDhiRkp5TTN1YkN3N0xWM2FaRVRQUWht?=
 =?utf-8?B?dEZRSkZzVk5rVkp0RVYrWFlxV2VQWG11c1hOU1psdm44WkFjWjJKd2Rydm0y?=
 =?utf-8?B?OXh5cFEySDlUTzRBL1h2Q01MVmlnZmRvQy9LMWs0NnhCcFZEck5Kai9icGc2?=
 =?utf-8?B?MzB5M0RlS2dOUWtOY0hidjVsaGZ0S2JmVUxUbnduN3ZSY1FXUnR3ME4weGNw?=
 =?utf-8?B?QW8rZXI3UE05TUwwUXF0MFd1b2kwRkMwWkwwdUpFM01BQXBRcmFCTnBvZm5v?=
 =?utf-8?B?M0dtWDFtY041T1RtS0dNY29lQUV4UThXT1RLVVJqL1AwUWltcVh2OHVEeHYx?=
 =?utf-8?B?dDJEVGV3Wm55aFdpWHlKRGNEKzlWNzhRNy93Q1BLYkE4NzdHS2xIWVNZbTBL?=
 =?utf-8?B?YUh0Z1ZER1Zza2V4RUFtMTYrVlN5Mm9KSmt5Uk5CcVd5RzVTQnVhV1JLT3ND?=
 =?utf-8?B?Sktnbk5FazNtY20rOTNEZ2dtcXg3MXJOVFl3NWhEblhLSWVQS3hJUDAyeitV?=
 =?utf-8?Q?3RBHyJArepJ2HkCRHM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1745ba9-bde9-4bcf-7eac-08dea527e309
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 13:13:06.6568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnNOk5w7VjWZt6VfKWugXtHpb5Tl9X8BWYLSpDrURWiZ3sUsqmh/Vn6nsXWE6zvB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7856
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1D02340002
X-Stat-Signature: 7nkh8pm137hjjt3rhph6g76b7epmdeuu
X-HE-Tag: 1777381991-273613
X-HE-Meta: U2FsdGVkX18WUGWusguxD0cvO6ib9e1wspgXmqUfD6YewGwCLEeLUAMSC0n8C9Om9Ni3R1tjbxd+LQ12IMRYAINb6+anztA1oFrmPJWwmcHSQxDbLHgfNIWmbe+Yx5Uwqzzg1+nlz0XDHK4XU/pxED0S/Hojb0AA1JR2XhrgbVaB3khho/+m9TdFgydyw3b+WxvrfI2wOg0ILURb4cFd3xcmyUS6YG6lWg9+pjYcStisH4B4KaU8VOQfxgujhc20BTeAL+CIFvUA6EGXUe5QGL68wDP3sz8rYHlPEVocGIL18cX9ge++aO4xjVl8EziDEG+QHpOs514i5SvixQEj9nnWk9rG7dga4/ApYZd+XfNyzMNaOmaBzxLJQOTHTf0BthREtAOoqWOXXLrVqmcx7oXqndTbsqR2iT32ZVWpCJ12UF2o/n6eVrAgufhwcp7XdPiYh7zIgi55uQ/1LcUmdKEjNNoGBNzr3DBsd74H4w2WXPDrUB0oUsP1ZnmP0+AUdAwNBJspmPOQvvYebv/Tqsh6LOS+BvG0qo/O2Eata572hgbnhUFMCqjdcRE74oIE9zWS73rds4Pft7zm9LEZJVKmhQnYonzPUwOPuW4R19mVypT4sgolWPPjNOVBdDsAVDHFlcVT9KKNSs4Yp8rPwjvOoPM+jAGItzUZLf4tI7WCZTA2DbSrzN0LvEV5EmrPiSC/M8uQJRnUjNmCYZjmhxfcVdPuLYY/hH6tgDReMljRLltItXqxih17nM/l62gXq244j19/1gcqjU92R2oJ7UtVwcWxe343IYQa2w8tQ27c7jitOmJeroCa2rxRKCwUvwIMbjyaRuG/5fozxcgp3TOHv2tIYpppOArqUic0SKvR3RnW9O3cwIWFpyRL++ZdbKivalZQztEPnh7QzfvppG6PlDUNieGW+0me7ZR1RyWbQ3zjfcLe8qo0dcwBX5GS/hFAjsFyh3rXJyminSV
 pekiRePI
 K7S6pZXivIpP1OETUh67Z5RjOeSrpyHvscpG5ug7+7hvclp9Y727a5rOH/Ma9HkXJOO5VHL5OhBQDTz7qyDmeowOGe65tQIRPF+YFoeIxl6Hv0EMtxAQqAiNZxMNP+kqbj9aqq4ESjyZce/5GwAFKLtOSMbKrnbDl9BmhLDTd531imebawsRtN5mFVpEaKwrU90H70r7MdckpNvKA2UtYl1AxxgFuXCffUbp7vxvjarvCIPlciHotmPh5JnQzAAcJSImfk/1NaxgjRj10iJvncXEcdOEyAhOkM5cE6CmgT+bc2TlvI7xqvflB3ehPk+oyi008S2nYvCvSqXmaYI5TShQCGn+FZkLdpUi0x+6hac6WFz217Dhfcf9xjVW8IXvG7EQjPSZ21N/WIdGK1/NKjffcYaEWMYSTozDDasUdmJMELflbIn17j9sHSDMTqowNe+OuadFAhSUvjeo+vU1NsxkA8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Apr 2026, at 23:33, zhen.ni wrote:

> =E5=9C=A8 2026/4/27 23:35, Zi Yan =E5=86=99=E9=81=93:
>> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
>>
>>> Add data structure for page_owner filtering functionality and create
>>> debugfs directory for filter controls.
>>>
>>> This adds:
>>> - enum page_owner_print_mode with values for full_stack and stack_handl=
e
>>> - struct page_owner_filter with print_mode and nid_mask fields
>>> - Static owner_filter instance initialized with default values
>>> - page_owner_filter debugfs directory
>>>
>>> The filter infrastructure will be used to add print_mode and NUMA node
>>> filtering capabilities in subsequent commits.
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@e=
asystack.cn/
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>> ---
>>>
>>> Changes in v2:
>>> - Use enum page_owner_print_mode instead of bool 'compact' for better c=
larity
>>> - Use nodemask_t instead of int 'nid' to support multi-node filtering
>>> ---
>>>   mm/page_owner.c | 20 +++++++++++++++++++-
>>>   1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> The patch can be folded into Patch 2. Otherwise, these new types are not
>> used and page_owner_filter folder is just empty.
>>
>
>
> Thanks for your review and suggestion.
>
> I kept the 3-patch structure mainly for clear functional separation,
> which also makes review easier. Patch 1 adds the infrastructure,

What is the point of adding unused code in a separate patch?
Patch 1 has no functional addition and should be part of Patch 2.

> patch 2 adds print_mode filter, and patch 3 adds NUMA filter.
>
> I discussed this with Andrew and he has already accepted the
> current 3-patch structure into mm-new for testing. Since he's okay
> with it and mentioned that bisection holes are acceptable in this

The patches are still in mm-new, not mm-stable. It is totally acceptable
to reorganize them.

> case, I'll keep the current structure in v3.

Please refrain from posting a new version when the discussion is still
going on.

>
>>>
>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>> index 8178e0be557f..5884d883837e 100644
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -54,6 +54,21 @@ struct stack_print_ctx {
>>>   	u8 flags;
>>>   };
>>>
>>> +enum page_owner_print_mode {
>>> +	PAGE_OWNER_PRINT_FULL_STACK,
>>> +	PAGE_OWNER_PRINT_STACK_HANDLE,
>>> +};
>>> +
>>> +struct page_owner_filter {
>>> +	enum page_owner_print_mode print_mode;
>>> +	nodemask_t nid_mask;
>>> +};
>>> +
>>> +static struct page_owner_filter owner_filter =3D {
>>> +	.print_mode =3D PAGE_OWNER_PRINT_FULL_STACK,
>>> +	.nid_mask =3D NODE_MASK_NONE,
>>> +};
>>> +
>>>   static bool page_owner_enabled __initdata;
>>>   DEFINE_STATIC_KEY_FALSE(page_owner_inited);
>>>
>>> @@ -973,7 +988,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, =
&page_owner_threshold_get,
>>>
>>>   static int __init pageowner_init(void)
>>>   {
>>> -	struct dentry *dir;
>>> +	struct dentry *dir, *filter_dir;
>>>
>>>   	if (!static_branch_unlikely(&page_owner_inited)) {
>>>   		pr_info("page_owner is disabled\n");
>>> @@ -981,6 +996,9 @@ static int __init pageowner_init(void)
>>>   	}
>>>
>>>   	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops=
);
>>> +
>>> +	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
>>> +
>>>   	dir =3D debugfs_create_dir("page_owner_stacks", NULL);
>>>   	debugfs_create_file("show_stacks", 0400, dir,
>>>   			    (void *)(STACK_PRINT_FLAG_STACK |
>>> --=20
>>> 2.20.1
>>
>>
>> Best Regards,
>> Yan, Zi
>>
>>
> Best regards,
> Zhen


Best Regards,
Yan, Zi

