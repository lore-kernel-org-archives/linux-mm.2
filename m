Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B558B606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=rL3JRQ91
Received: by kanga.kvack.org (Postfix)
	id A4E6B6B05B0; Mon, 16 Nov 2026 17:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26336B05B1; Mon, 16 Nov 2026 17:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEA76B05B2; Mon, 16 Nov 2026 17:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 585306B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:10:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B195FC025D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:10:33 +0000 (UTC)
X-FDA: 85442377146.01.CEF7FC7
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by imf28.hostedemail.com (Postfix) with ESMTP id D3844C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:10:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rL3JRQ91;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794867031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5TAVO6go8Pasz513R7ZxOL8KqcwSl/G+E3fgMn+i0s=;
	b=K0V2A90bPcQT1Q3Bua3grw3lOayTGDEwuN/4g0sno6GjkqubJqw7Se4LagfsFLGkLPOxZS
	+U5idOO4Vu5EdUrM6Gz/ajm6Xn+jXCTYIJYwijzDTX7E1qFQlU2M0G5oobfWwbAX7FGRzs
	z3w+5DiwpwsefsJv+96cRWikpnYs4K8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794867031;
	b=nalwsyuxRZ7et1yphRnLVTa440QxiJLNCjMp4vbU+4iEbGR2jFyQXmydrS5zFWKlk2qEQs
	Qwbt3/O0J15Re+As3mG39fgGSM1smkoGUz1KrIyIFmuZIfRSZ9JuDFO18FMeuuol11Ju+Z
	cBd7CTejd5bNEGOa2fzptZsvSfgEDT0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rL3JRQ91;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f3mVdgmv478e/9iNi9ZaIX5BMjNxMf1yF6Sruu0OfJ4ZmEwj7WtUXa5nLXwxahJPH6TTSb6zQkTqUAi75IVoJaPBxV2eUYKay4rURfePMvk0E1z/sTy7OxHcopyxp56fJnxy/wgIYCcxbjSxCgPElNYERpT4KjwCYqpvaQRy3sBcWDR/prgB5RaOV5i7p5FUAuMQXw5jROCRSnhJKuYZTZj3HzdCItjjlUag8i18wpn+NyqktjmjSaWHqhrvwXAUy0jZRjp6k4J5QkQBMsX0AY/N+rPIynoDxATi1bxP8cMyPreuM9p7ElHY4D8KoMZK00R1vt9m51JOtk/S+mTjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5TAVO6go8Pasz513R7ZxOL8KqcwSl/G+E3fgMn+i0s=;
 b=GGm/SoRa56s0ILW3NQg9O2VDQJEHnabohDm4+FgCd7AuL/EBXvgdZNEbADBcuRwmQx0KYUYW1qpG1E+IlVe6YWUSF/5RR6YtbmPrByqBVydkBiPSgCRvvblptCWpgSGL/iWSQMS/GSZMrxUclTw8caA9JyWyNyaJe8rFGKCl2zoY20jbz6lL28/p56q3sU6N/QuQhH3V/AO8t5vZjfhYxlDQbJvk1sFC4p1XzyP0obAdUE/5Xa0cljr13WcNtNg8MCmvUd2J3aHrlyqix7mGo4BFAvbXyhPqVBoWVRoMkfk3tlG+4cEZvUH3ZRV1TjJN/6f8keb/YfUAahezQ30OBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5TAVO6go8Pasz513R7ZxOL8KqcwSl/G+E3fgMn+i0s=;
 b=rL3JRQ91xvprclDxQvp1DUBBEN94iSpCwPWgvrM+NbBykpIVTbgdtEm7s2ozHn0zeSFUeysb6zN1XZhLfMl2l0KDJijj0T2k5UfX8j1eCvXEJ+1o+OfdVdwqqrVJunFVAyLGm9Ctzoglp4Gi7Is3E02OsTsb29W+CXm0aqVqctSjXVFDu5EoEkZDZ8lqUuHt05pp0oC7GrJ2w5roNPEwmpv4lBdCC6hg4BkRTG0zy8DMMHK8J46LwF9GeEvWk4no+yCMrmiKyNX9cDuqa/pmkgxe129YnqnqkZfmNdwsCu7sLJjVbJBbANd0EPaC8AUb201IknH+ojm5HldfcaU6mQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8852.namprd12.prod.outlook.com (2603:10b6:610:17d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Mon, 16 Nov
 2026 22:10:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Mon, 16 Nov 2026
 22:10:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 16 Nov 2026 17:10:21 -0500
Message-Id: <DMWZ9AF2XRF0.5LUCF3PW1MWG@nvidia.com>
Subject: Re: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark
 checks
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>
To: "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "David
 Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
 <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
In-Reply-To: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: YQBPR0101CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8852:EE_
X-MS-Office365-Filtering-Correlation-Id: 818180fa-521b-42e8-73fd-08df442e68b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|18002099003|22082099003|11063799006|4143699003|56012099006|10067099003|261028144727099003|261021123027099003|261021121427099003|261026140227099003|261009223027099003|261102123227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	7+XWzbeZ/wIJhLvPAh1bXiUzkcxuJnOGJMTjMLznOS7L8DJ+Yj5KIvg6ugADbSHXT/AbWsp5FN+8CbtS+eC94GZsuYrBk/Dp1t9fUpNcfQaNr3VV+NoqeWxZ7UvHaViIGKREcCBf6SXqMUUZNlSMdyakXvpaksGM+43IwzupVrO86/IK6fonNKvpEqk6t87HZdI+i73H8Wv2lAzWgumDAlzzHINL06dzfij3YorLuSv7Q5eJlmv1R8kor3YVExbYPuRvfABJcdmDpWYN6rbVKpWOm/rpHmUnkd1bzNs5AjE06qzyJ9H6T72LBf+hxcEdB1q+UYEwPN1lUMtS8Zj1WRngdDJ19lUnSxl+jNO5YpHm9yRYM4J4iWXIpQA7sAFUjWs3DLN2RgbTrqYPCeSnHwmfFdFnwjT24OA3bcNxOV/s9Pn0zP13MYEfxXd3lSw8HM99OiAnQyix0u68e9DVYTkCn+u4oJfoc2Q1cdXaLCcUSznTjpRS8Axoa4RkS2PnfTjtmYI1A1xOCiKAeWkLHghufyKzlcJJoC1VkVUj96QzMt0LEzwusKeKJUBX95riUeKQaPewr3cwr4lCQdgLN5gf0w8LBsQJovVP3D2H+pEoQ7iJ0X5gVjZ8/LDENNZTtyxo+y9PnJBGMLs5WAGkqqV71fsadC2Acnjr1JjFS+k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006)(10067099003)(261028144727099003)(261021123027099003)(261021121427099003)(261026140227099003)(261009223027099003)(261102123227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z1k0Uzl0bk15WWZ1OGlTdm5kSGk5Tkx1cEVhNkZZeVNucmlDT1pkU2ErL0R6?=
 =?utf-8?B?QlM5TWd6eWlDeWR4K3E3b2k0YlFUaVUzOFV2OURpVks5UENxcGZreTFyODUw?=
 =?utf-8?B?OHpqOXRYaDhtZmhydkR4YzhuWTlEeXppWDM1OVpITk1BZ2RMN2Jvc09IT05O?=
 =?utf-8?B?VzhveGk1ZHBnTjgyc21ObzQ0YkxCVUkva3F5OHFnQlpWYTZKVkI0TGc5dWlq?=
 =?utf-8?B?RmwvYjlTN2FSSkdncUpiL3pyc3Y4emVYSkh0azdnQ0xtcTc2TUhwTVgrdkZS?=
 =?utf-8?B?cnBUMVVva0pFcFJRV3JGc3dxK1FrMzV1THQvV1RyODh3elRZVzNjOVFqU2pY?=
 =?utf-8?B?TGJOZUpmOE1xMS81Vy9FRmUvVlArWGI2dG1iSTgzUmZCVDVlbnpnMS9WczJy?=
 =?utf-8?B?MXJ3VzhqMnRydENiSDZFYitPVDJqanRFZUxLVFJLaDQ3c0lBaW80d0gyaHhy?=
 =?utf-8?B?THJsVmsvUTY4aE1FWXV2cWdJVlNNajZwN2hvcG01ZXBKUGVDLzRaWnY5Nllt?=
 =?utf-8?B?bDZwSnJENkZCYWRFdnhxdlVreWFaOG1jZFFWcWwzaWZEekFkcUxHWklWRDdQ?=
 =?utf-8?B?OGpTUkpJV29jRGFVZWw1bkFyRit0TzNmbHFOTFAxbXpVNTVvamVzZEpXWmpB?=
 =?utf-8?B?MHYzcm9SS3hOQmJtNDR3WFAvbGtSbW1jVG4rRm15anZnSjNYbjZoa1M2YlRs?=
 =?utf-8?B?WHFBZ3ZwdFFKRU5pV3AvWk1ma2taaEs1NTg4ZVpUOStuayszRU91Mmh3SWp1?=
 =?utf-8?B?VGVxdEk0UExjanlXNEQ5TWwyRndiRzBFSU82VmpjeS9DVnBBaGc5TEl6YWkv?=
 =?utf-8?B?UHZHcG5LVW02cWFCQ3FnYXVYTFM4MlZkYzRkK3dqQ3RSK3ozM0JvOU91YkxH?=
 =?utf-8?B?WWlWMThKRXA4Tk8wSWpwUGhDQmxqL2E1N1hTb0Zla0pRbTlaS0V6Vm1sY0Rj?=
 =?utf-8?B?YmJDaHlDL1U4bHFGSDh5b093emxNTThvL1J3SlFURzdvdEwzVEdFNUVnMG82?=
 =?utf-8?B?TDV3c3BqcmwyR3JzbjZ4SnlhM0IzaGIrUU5GRVJXQnNWT0NzZ3FCT0NtVHdl?=
 =?utf-8?B?cldlU2RKQzBsaW1UNjhTUDY0YXZTcTBnUG5WUHRNaDRsWnlWaWU1THZ0MnJD?=
 =?utf-8?B?alFXWkRYMjd4amRFVnNNenVyKy9IUHFzMVlPQ1dDdkZoU1hzYWI0QS9FcnZY?=
 =?utf-8?B?TDhQOXJlMkw0MG4yaXRGWTl6cGNrd3JBV3MwdXFiMFBDTTR1UFFPNU5kelBi?=
 =?utf-8?B?emRuTFBqSXNQMFlObHN0RnpIV0hzYzN5K2cxSXdWVlJSNUE2czRaVEZCcVJu?=
 =?utf-8?B?dTQrbGFjOHc0YmY0OVNLY3FMRFh2VTZQc0dTcXkyazJiRWVITTlxS2JFRGpV?=
 =?utf-8?B?NTliYlorbC9xK2pjTFUyRXB5U2k1WFJzWFZHSEtyejBac0ZHQVNiY3RGdmlx?=
 =?utf-8?B?SEROUS8rYlJuVTZuYVRYMkV6Nnhwd3VJcGpKZUZDWDZEWDZaU3l2UE5TcUFt?=
 =?utf-8?B?WGtZZ05pVCtSMklOSis4MkVsRTVLaWRjWTZVTXR1UHg4RlFPVXRpSVhpTUZL?=
 =?utf-8?B?OEp6YWk0Umo5YTJucFhqb29PdERkelpFdytDU0JqVFNYZlJWT3psOHdNY3F5?=
 =?utf-8?B?N1ZLYTcxYkl1SjVzdGNHc1dGV2t4V1U0Z1RuQ3BVYW9YQjA3c1FUOWFJRU1r?=
 =?utf-8?B?bmg5VlY5U242TjU0bk1PbDFKMzFSYTU2elNxaXc0dXlBdlpjNmRUQWUxa21k?=
 =?utf-8?B?a0NGT1NUQ3RtZmVZK2h2eDdGSTZmZi9TTHpyS2t3UTZ1RmZNc2M2TGF1VzdU?=
 =?utf-8?B?dGVYRk9sM01lKytNTDdlUjRMazRnUTZWY1pKOXRIZHFLVUF2L3FIQWw4TXA5?=
 =?utf-8?B?ekZVYnJaemJQNzVyakRIcFY0T2V1QWtIeXJjNDVmWU1USy9RQzNJN1NRdVkx?=
 =?utf-8?B?Y01ZMk1JNTdMNG1YclVncDh3b1Z3OG5uT1JYZWdUYmF2c0lRYldHQzVuS1ND?=
 =?utf-8?B?YWNVdTgySXRHRjBMYm9PNnRhMWd6aSs3TXFyNHh5VWsycDBScktOODBNUTlx?=
 =?utf-8?B?anBxSDltdy9KdStidmVxUjJoREJJNDY2UWtGcWljbkNXYlZwdTBWdENJNFFa?=
 =?utf-8?B?RnVtcnBEMUF2djVMdzF4YVFlT0RzQlJWNmU3Tnl1VEgrWHFlM3pTWTd3T08w?=
 =?utf-8?B?ZDFXWGdrV1YvMGZOa1NEbDR2ZUZ6UTdsVHY0aE91bFprdFJrckpxa0hMWStR?=
 =?utf-8?B?bFdLMG1PQjVGOW1LczZOa045eE5DUUtYOVIvQXREbHMzeDcxK3h6alRjemh0?=
 =?utf-8?Q?pkUaJqcTv2NLhSqqsW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818180fa-521b-42e8-73fd-08df442e68b0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 22:10:22.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UY1vfDofMJcvffHf/UH+Pp69++4BPT7ji1ikLj1GKyi9EksIeT+Y2wBVTh25DZUw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8852
X-Stat-Signature: 6fz6wnynx36frgirn5woonitpszsws43
X-Rspam-User: 
X-Rspamd-Queue-Id: D3844C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794867030-428958
X-HE-Meta: U2FsdGVkX1/mqbwIl+Ifv7dGDPRjRBGk7XOkjHfzxMfYC9iJR/uP5mdwW0Ar7JX/Mwz+lSR7RAGTss/BNNVoa2OWRiaAKCrID3K9hWnghWDV4ZTQ6UhP0K72D+vU35m+A78F6vzBS2PVPD2cJzfoEhePni9GucqANVN7bbZOk4/GGKhy/4w/DSGucRqJeus8v6tlCcNq4mV6YpvDN7bS+sEGmwh8FngSgOKeKkK8mTh5BfMVfsgxgq3gv+eAZQS8lcoh/ZWP+kjly9K4tQF5J6LAKQfFBUlwyL5lNS8v+vyhRIW4kuE4GFJiGmlyM86QqRJXuHc6T2holzpnBsifWSCwfxGp+JqKuDUjgEX6Bo8FDpJG1PWE7pqgT/IHXH609oYwYKadBL8A3/UHOuA67gsU5zp9V0qF9LdB+hlb3sk/D3Rt2u+FY/B3Afw78y+95zUpD5hqM1BHVzoxnzPxEUbWgADPaIBgQ+HgYMO6ERgElLUfTW+d6fp4ITZsIKfNrpWeDZCVeQbFda+bnrK4AJ66DYrFuGT5HuFhKE60bWRfiDBum63/SN80bNX0gw6YaD+gfupdDWT2zHggFkpa0lymsq9cqrw4hZf759OnDH76WtgSZudLXMNw1HknjIMzEydVXQih76t36FOHYgLuo7ux1kumVJ0C8S9HxQ1Tn4xUr3PgPKq6bzK4Z6smzpTpWaCcJf1z3wOd/BY6vZOnmBf25DJn2CpPVZhD+ekO0xntVvsI/RxlW79vmVu9pRV6F2vCIfC5WdVNMW7DnYZFIwb6Z/h65LbQFMpxOD5C2FxYxobBHVfU+RKuQ2UASW8moUg5LV9COOReEvbIU7cG3Xon5KS3RHYMgyko8E9r69d4jbSinpEhE/dJ0vVySpz3nWkGHPI4OgDyk9Zhtmstj1xe3ES3A8ku0ww4zA/uNWexf7COSqLmuNKbQJbXNAIlHtzkPj3azfEgM/P7mG2
 Sqq8GjNs
 Zly/3wzRakOKs5zvaSbnxNm4qjdxqmSkgj9hjeOE60zmoHYhCoF85/AUVfPwuACZypktdxlf92ag7Qa1FuZ1+wHb7SDCjG/Cna6vCnppMAvRUqi/ozk7twp9vGXByHT1doD5tAL+CqD+f9Uub7klH+3X1rL3qIoOFY1fMM2PFoYX7XyeLrhMpxtYTc1NCtHpre970b8/30J/slZooOPJG9FlOqTbtx45PMbmN+8pcZY+wgj8wWn6ydaVC+kjYdKTEIjRQRckmaNir1ewLPviWcnfbiQdxtueeCxPV2u1uy+d2i1Pac+DL5LLVh1m+/21HBAK2ti7N5XX9UCiuJ9A97xFj3pfQdcoTD+11uaOCpK7ewBX9atih9t6Lwfi6YSbSpXSvWMDyd2Qy1hNL2xxZ6+LaCMDs3X/r+BKyOEQzJKkRO3bloPCUSH++WI1v2SPkZwkdRsbAcBj0wdnkQ33bXceQulOth66jlQHvflSFYWKmmeqLrW/XkE2JbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 13, 2026 at 6:52 PM EST, Joshua Hahn wrote:
> There are three sites which all check the watermark that kswapd reclaims
> zones up to, which is the promo watermark when NUMA balancing memory
> tiering is enabled, and the high watermark otherwise.
>
> Consolidate the patern into a helper function. While at it, remove the
> include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
> dependency on sysctl_numa_balancing_mode has been abstracted into
> vmscan code.
>
> No functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/internal.h   |  1 +
>  mm/page_alloc.c |  6 +-----
>  mm/vmscan.c     | 22 +++++++++++++---------
>  3 files changed, 15 insertions(+), 14 deletions(-)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


