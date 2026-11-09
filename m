Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88E960A260F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 21:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KKBVTxvI
Received: by kanga.kvack.org (Postfix)
	id D87AC6B05B3; Mon,  9 Nov 2026 16:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60896B05B4; Mon,  9 Nov 2026 16:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27AC6B05B5; Mon,  9 Nov 2026 16:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 952826B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:05:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24EAF407FD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:05:34 +0000 (UTC)
X-FDA: 85416811788.07.08DCFF6
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	by imf11.hostedemail.com (Postfix) with ESMTP id F2DA640008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:05:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKBVTxvI;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794258331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzMJrVMkxFSZcfvp0qaJ7qx6tfWpR7g7taw8ntN2cIs=;
	b=WT8CsvPDkAJih+Z11TnlDWlqVYlBDsmj+rvXMOwnXNfNu2eKClZmd+/byLa5lVTvbr8F3s
	IW+G/b33rNpqmThVKigzpTKTpXWSit99Xx59ITfb4woUw7ePTZWX++Hs6EhsFiOS9aqnT3
	/cxBcYxCNtQwU++Fy4Dc/lXcTfnmlTc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794258331;
	b=DgleyP67pc9Oug9WEpQUaXzaaLd4aDH7y9dPi6LtW80ybE5FqLgJaTTLsb2n2eU7q/xpU4
	0IO+emMRbiN32lNud0qC/ye6kITyAiy6KgbwGILGwdpYotbC+xbtNc3YatSSNktMzRHq9Z
	KulHE4Y4iJWGa8E+q/f2CNH/xYgmCqI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKBVTxvI;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMMfIDKaeeyX1j2/4seo+C8aTPhsdWr05TL6k6Yk99CGqXXnQOt9Jzpq6bLCJEtdfWH0fVL0mS7wDlwOobYm28i2PCmaqT9fWbdlilfjeDgaV35BNyO0G2owGWMms7bFZPTy1Ibn9D2gJU7ULixzBtUPQZxOdFv80aOMr9XeefvhUV6kbB7mu4thz9tCiFwyCh1EYK3s1A+4gFwmC2+mS/HdHu3o9W4jZqO9/E9bulgQm+vbx7+1bQjtIBZXjp8Wyw6V9oTR9T8htL2nJp1ddNAl8g7s4seFU7snrxZ/sEnEBBNNL4uSNGrBr2NgPuqkt5h2kLF/4dniEVQzn4dJHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nzMJrVMkxFSZcfvp0qaJ7qx6tfWpR7g7taw8ntN2cIs=;
 b=SVU4tKADIZjlrQQ7YSs+ua3TuBd31fpWPeH7jEtlsvAVPq2YpJI6fRNoHhOTy3GPz6gL0KpNM0SENLb6KM1qhKt2Pd1s2mUpDJqXLhf5TP7nUNEoRP58CLUSDDB0UA8Dc6Rgg5iH240+RKlPCZqtUzp7LWV5WDzBB5T7l5VU3inqqtMos/efPqyoCB49t5lKZOnWfuR5VGyLZVyIDLpBX2HAQ59sYaEzqqOnon14sWNzKDkb5DnUqsyjTF2Uqc+F9spEpmKez5EtaEIQ5TJLqCwvOXoX19554F66uByyiYjiZ+3f2XNwZa2YRURTU+tfWRAMBf58RAD5RiKlsf7uDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzMJrVMkxFSZcfvp0qaJ7qx6tfWpR7g7taw8ntN2cIs=;
 b=KKBVTxvIuxzjEc/5sRme0ooPYsOzTPFgvOwoDf+oErghSH2csaV0I6G7OETh80SIXC6Ei8eEKL1cU4u1PVEasHQMWEgo49JO3OoPo62Huehf1iFIM2/oP+41YJlmmLf81YW+8wDuUj9LY2ZKsg5tqyUJyuo0B9Oo5XsWcMeJkhx3t0xUeAaDXfpAT8kYhUhe43OBLPROA9kL0EBXx6ejgOJyj4HhoEPEcmBB5DGT26WcBiw5tOvhFezDNTYt+246yectJkBPlEaM26DUtJec4I5dhpHYoZdZwzM6kn5C1guIPenyC19YwpPi8/IC/lkf4RjBDfTAFsRF48IQa+lXMw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL1PR12MB5994.namprd12.prod.outlook.com (2603:10b6:208:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Mon, 9 Nov
 2026 21:05:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 21:05:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Date: Mon, 09 Nov 2026 16:05:21 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
In-Reply-To: <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
References:
 <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0349.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL1PR12MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a26ec4b-bc59-4f83-1a93-08df3ea52bb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|22082099003|18002099003|13003099007|261022075727099003|56012099006|11063799006|261009223027099003|4143699003|5023799004|261102123227099003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261021123027099003|261026121527099003|260925021911599003|260925022911599003|260925021311599003;
X-Microsoft-Antispam-Message-Info:
	DcbibuScmWmvbs84gf342zwv6z3857ssgdB5SEs53M5lq99Gwya+T1vTcSiUe3VvJM8HdjX5fC/oW/zo2Q+1/5KBbvITHku9i9TTR+4BUkcsChuQGJEX8W2vCMvHUfn62J7F9LjXD9yRK3he+sAkpYI5j+2d59RvfU0wqrulgDxsYgzy7c2wZB+JAQDGadru/aHO3I+lV2vDrvbjjY3/fI4tHgqBB5s10cj/NqV0XsZmjp4oqvk16j2SbfssHhtEWpHXAIPrW0zqyeKy4o3lwQamsakLCLGuU6CXJs6+IuCErT/kNJE+UOkOyzQ9o8PikvMSYcK7+Qsa1eOdaJ57bN4aj2Hpx7sYEWMjYeHf2gEK/x1xlIVPmFSnQIeGxamjNWxKD/ORAoWxfjYGXFf21WdaZR2ETLy1ILqaWdB2il4oZlZcpzgEezi+eTV94oj6+2WlchoF0wPKP+OX0emljfNX0WFwo2kJmUlNz4QtdebPncRKpdZwsDNnHilTztPqiaXqTGQONhRw7evayZLT2lOzHdyCsYo5jDzr5iuEdpIkEVvJZYUhCkwlYeEnOLPut8uHZU8YVFK5Y29x4bozw5LHMUIlKgiEIVQd8oogjeaIPf1I0kn4qp3k1blDxSXFs9SByvLcsUBpbBdCjef3aInXWPmgV2M5bLpwx6nRazs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(22082099003)(18002099003)(13003099007)(261022075727099003)(56012099006)(11063799006)(261009223027099003)(4143699003)(5023799004)(261102123227099003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261021123027099003)(261026121527099003)(260925021911599003)(260925022911599003)(260925021311599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dDErd0VCclloN3AvN0w1K0dUVWcwR1F5V0FUSUtxYi8zTW1pZWVxaVNzbGg2?=
 =?utf-8?B?R2lFTHZhc2loTklvVThicVA0R3BqRVZCa2xBVlVNcmhwa2I2UVk3WHhqZjlS?=
 =?utf-8?B?aWY4NlFxYXdmai83eHNJNysyb0kzNHhkMk1LMCtINk5vQTBOdmdLaWt3YWtH?=
 =?utf-8?B?cDV4ZUZ2UWJCTEhpZzZpSUJodkQ4OW4xVXg3elFwY3ZCM0VqOThvNUc4ZWxJ?=
 =?utf-8?B?cnBZWkF4MkorUFpPUGduV2JNWlFkZ0VyekVldUNYT2FickVFYUk5cHFTZzhl?=
 =?utf-8?B?MFM3NDUzNjNTNE01UXg5L0RnSUR0aVV2SHdzdzhNaS82aGNPMmw3VlF0RXl3?=
 =?utf-8?B?bDlaS0hicFdPMnBPREIrV2NmOUxYbURKdTcvZytQSjBXSk9FMHBCejFrUTI1?=
 =?utf-8?B?V2pjaTZXZ2F2Q04yZWRQelJudjRUZHdFL29hSmFiSm1vVHFKVHdaYlFoZWhq?=
 =?utf-8?B?My9MeUg1MmxlWXZYNmlNVUdzTkt1WkhqQVRwU3JpMFlSVXRMRE9qbXB4MGJo?=
 =?utf-8?B?eGlqRlg0bmpLTTlXWmg0ZllQZTBCQmI4L0FOT0YxdG4vWUs3bFV2dERLS0ZK?=
 =?utf-8?B?b2o2THpUeHhUUXVPdkN0b2JBZEtlL2YwNWw4Wm8yL0pEeXM0WlFacFRvVU11?=
 =?utf-8?B?SUxIR3IxalBGOTd0OHo0NmNxWEczd2JHUjVleEs2bWgrdktTaFd0R0hmdHpu?=
 =?utf-8?B?eldXWVlLSzI2ZWpvNHpNc3JhNjdwbGFrYU1CNG50dWV4Wjd3YnJ2T2I4YW9S?=
 =?utf-8?B?N1FzdVJyQW9GdURWQ2FqNEJ6UEhXK1hSdEFUb1BQbTREM2xURFRMYTNZZG5u?=
 =?utf-8?B?Q2NHaitSeUd5UzdWNWxLTXg2ZythYjBSTVpIVUl1RGN3YlpMb2VPREcwc3d1?=
 =?utf-8?B?Z1lwak50SVJWSkFFMmlxK0tHNTVVeW8xRUhNWmlKK2MrMVpDZDd3a1ByM015?=
 =?utf-8?B?T2g1WXh5WDF3SEF0eklXMVptL01lL2dpdTVwUHZhR25FZE9JQ05tSWlPWVZ1?=
 =?utf-8?B?a2NwdENXc0xUT2ZMd3k0QW5TVEIrVkhicWJCci9BdTNEZi9tSHcwYStvQmNC?=
 =?utf-8?B?MnJ3c0JHaFJ1d3QyRElRbDdkTmxwZlEzM2tsZG9YR2VWdytHUjBCSXZNc0VH?=
 =?utf-8?B?WXVLTk04QndjZFpIaHJCdm42ZGVodUZadHVPQm9oZzNNc2h1Ukk1K0kvSm51?=
 =?utf-8?B?cnhDOFliZUZ2MVZmYUZNaDBCbitHb0FtbW83MFJtdkhBejg4Ynl6TlFjVXFG?=
 =?utf-8?B?L0NQa0hibGkyL3NSbVo0SDBLY25yNnJKUWpoc0Y5M2hXZXhCNFBudkF3WVpL?=
 =?utf-8?B?VUE4cUhDVlFsNS8rMVJkcWhRb0dFODhtdDg2Q3ppNmllWkh6Rk9ZdnBweEJ5?=
 =?utf-8?B?NVlGbmZ1ZjE2bTBRSzdHOTlTZk9iTllZSUFxVm5mRnZCeVcvZHd0VU9SbEtN?=
 =?utf-8?B?WGhZRC9HSFYrSG9HZFBSUTJDOE1sRC9wUEZPWTlpaXNSaWYwaXZkdHZkZGYv?=
 =?utf-8?B?b2szNWxBQ2tJOHVBS0hnYmZGYVVBcHp5T1FxSUdFV1cyOUR0aDNlRk9kWUkz?=
 =?utf-8?B?Y25VYlVSVmRFL0YzS0hqMTBBRkxhd2gyc25PNzZpaGZRSmJvL2xnU08yTEU1?=
 =?utf-8?B?R3dHN1B3NVM0VFZhZ3orWWdoMlhKU2RlcDNjdWthcXo1RkNVekVYK1JqWkp2?=
 =?utf-8?B?UjA5VGFLWCs4eGxTTWhWNXJJVVRhV2RRR0ltSTgvejJEVkpiUDdtdjRMbjZn?=
 =?utf-8?B?aDRqTmUrcDE5UU5pREloR0ZVQjBBbjZXS2RHZHNQUlAxWkxnaFVpVnJxS1BE?=
 =?utf-8?B?UDB0Y0RSRmpwbHo0NjlPeDVKaFhsTWo3N2ZuOGN4SjI1b01idEJJNXZacVl1?=
 =?utf-8?B?SlhqTDZZMXlTQnFXTVhkdXFRZWdXQ1BFZ1ZIQWlkeHJKT2dzaUF1emd0MHhN?=
 =?utf-8?B?NWxOZnFMcXRzc0oyc3VSbklxWFNRZjVNcWVTNHZpRmdQOU5vTmQzMHZjakZF?=
 =?utf-8?B?MXFpMk5icFRBOHZoU0U5NFZzZUpBOTQ0ZVZ5ODNuZ0ZqQnlqNnBGMEY2U0l5?=
 =?utf-8?B?Z1U5NnNrVmJxdFVNYTlOZWVCb3Z5VkVPeURDWS9vWXI2aWNGVFZySktyVm1Z?=
 =?utf-8?B?L1ZDRW5ld25xTmdsNzlsSTd4YU5Gb0xNR3FLOW5MTmVDZU9NUnpEV3lKaFZi?=
 =?utf-8?B?ck9Pb1A3Z1ZzNHlqblJlai81cXRSSUVIQURYNHlmZW1FUDhxSUZHUXFib0R2?=
 =?utf-8?B?MGZQQ0NYNElON0U3UFpPTWdYTU5CcS93SDIzM2hqdms0bHRIck1PMnJzYjlW?=
 =?utf-8?Q?i9gg0xBpOEDyMzu4sU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a26ec4b-bc59-4f83-1a93-08df3ea52bb6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 21:05:23.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgP8LA9jB8/6v7VT33PEwfIvlvJ90IiwH3YvyovdzoOrpy2GkvcST/WlucDa5Oq2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5994
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mha3p4epxp445jt74yrbtafxpyjpjhff
X-Rspamd-Queue-Id: F2DA640008
X-Rspam-User: 
X-HE-Tag: 1794258330-866750
X-HE-Meta: U2FsdGVkX1+0TYxOIgY5QoNsKZrRcewmGPze94Rdr30dy6j0gm6sYe7qSWIaAFkNjbp5AkySbxnqQBpbx3fX05HQMKrUStJ9B9n0qVsX48VufZNR2XDxP8e2fJ+DIiWixRlnh7jEItt5TH22h/teVF/0S3kn2wwkEzmQs2MrTY58SQbMDv8neJQ9ppY3HgkbuwQ5jvyEFawigIbXJyV6sSp5oj8OHwwVwGKfih6hel8RwJiH6p9hXhdMQYeZCNNx/EGbc6Q4XIZmLigHPBaASxQoJ+5edu/UQZf2CazVoEOxcLY1n/VDL2Z3ClwZ8UlFff06Rb6NjMRF8hCUXgLoEOPAmu3t47p+tGpcyoSJh3CtJfkMtnO7W5c2+LJY/ox6bguHLYGsbRGmuEJzlwhCVGPy4lYqvCo68nLRjsURBvvDgOsV4SZY+9MNl8MhohgKwvsNZWx7hFfCwcxauVrWscWKst5S+bypPhqbhaLmdh0QTRLXCx2SqJQGsT9P9f0SFQ3PiyFky+gMcW74CnZJ6mMpdnjsHEkkCOH+pruXo/L6jtae0OGGFy6BERivJPRuRqfhyPJx44SO3L5LiqieQMwI3maBj7XYGiDSm1yKeFZlKfpZzfQB01w9fGarVhaifplbO6YxX6EYEusSYm0DtiXto7IZuJ9+RNce12H4/19ICAkxwLjFtmoBFGz30EEe6oBX9c6ZaZkUeXLN9b5BWfJG/NuHIitUbIwBGotnrSPPmL+ows5uImAsGF4rZ+Gi1OmeGrT+CONTESkk9Ivzn0oniN6/GZIYunHdJ69RVvPfykyFxGWtPKt7UqoF5qL1qGXoPwxGpVHgg4525yO4MmwMuejEJMh8jLD73v08SlHabMfe4kXY67bLEWR1zBpmx/64v+X90YBVmPz5DnYA0KcVzWhbrn+HutbHRvF28U0PD8jAx88XqSJh9uGcPNvWrqml4Fa17U9mQn3rFTI
 ui7dxgfs
 XMyDbVcmpTlunidK93LtCtPmGVI7yFnonJfMEQ2MGoNRSVX8tpuOnkLP7OwdPDtRXqzN0sny5XT7HoLLaMJsd/ymCQyGsySxbnZwJxmw26i8ZvfQzgDYwZPyH+C5EUUC4WNhqeU2J08OXUV+O5nDdKjicNe30Yimaz4fqOgXVr9QKKKnXoE2xpBaM7eNEgepHj7eroquruXRxHH5BVDlD6UchskYP6vKTs/whcU2gc0/kj35LLISyFES9tCUAqLrn5nfVsZc3luY3xyxm/sua5ByDGGfGnA7swc79a3X4ymZD4oBOozlHj4jaOdfleR4Dh4RbgekLYJ8keAMKkatOkcZPXhcqi2ZVuK2nEOrRzW8JWG/JvMt+Hanwhk3FEcoVrfNHNkiK3LxfMfyOAipxu6im8pKxsGLQWVn+P/Egc2m5PZgOCr0fv7g2o7jDC5hmSTDZbQAtq5LYTqOnp42pOtTuZmdP4FpUP7e5RyYGkiONz1QdMQsz+kBo4M1Mabel97RBBrk57xAAjUkbahw0vbKtA1qWnD5vq3sQ3+xlUY+odC5SCQRn+FitOSO1g/F2Y9RxEes4fZJknOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 9 Nov 2026, at 15:21, David Hildenbrand (Arm) wrote:

> On 11/9/26 20:32, Zi Yan wrote:
>> __split_folio_to_order() calls prep_compound_page() on each new head pag=
e
>> to create a compound page after clear_compound_head(). prep_compound_pag=
e()
>> uses non atomic __SetPageHead(). It is mostly OK, since the folio is loc=
ked
>> and frozen and no one else is supposed to modify the folio's flags.
>>
>> However, code calling migration_entry_wait() can reach the folio by PFN,
>> then access its flags. It is because softleaf_entry_wait_on_locked() use=
d
>> by migration_entry_wait() sets PG_waiters concurrently without taking a
>> reference and the frozen refcount during split cannot block it. Meanwhil=
e,
>> __SetPageHead() does a plain read and write, so PG_waiters atomically se=
t
>> by softleaf_entry_wait_on_locked() will be lost if the set happens after
>> __SetPageHead()'s read and before its write.
>>
>> One example code interleaving:
>>
>> CPU0: __split_folio_to_order(new_order>0)  CPU1: do_swap_page()
>>
>> 1. clear_compound_head(new_head)
>>    new_head->compound_info =3D 0
>>    (page_folio(new_head) =3D=3D new_head now)
>>
>>                                            2. migration_entry_wait()
>>                                              softleaf_to_folio(entry)
>>                                              page_folio() -> new_head
>>                                              (not the old head any more)
>>
>> 3. prep_compound_page(new_head, new_order)
>>      __SetPageHead(new_head)
>>        tmp =3D new_head->flags.f  <-- load; PG_waiters =3D=3D 0 in tmp
>>
>>                                            4. folio_set_waiters(new_head=
)
>>                                              set_bit(PG_waiters, &flags.=
f)
>>                                              enqueue on waitqueue, sleep
>>
>> 5.     new_head->flags.f =3D tmp | (1UL << PG_head)
>>        <-- store; overwrites step 4, PG_waiters =3D=3D 0 again
>>
>> Later, folio_unlock(new_folio) sees no PG_waiters, skips folio_wake_bit(=
),
>> and CPU1 can remain blocked indefinitely.
>>
>> Fix it by setting PG_head along with other flags in new_folio->flags bef=
ore
>> smp_wmb() and clear_compound_head(). The remaining compound page metadat=
a
>> is set after clear_compound_head(). In that way, after
>> clear_compound_head() makes new_folio visible, nothing overwrites the
>> PG_waiters from softleaf_entry_wait_on_locked() by modifying
>> new_folio->flags non-atomically.
>>
>> While at it, use data_race() to suppress the KCSAN issue reported by Ye
>> Liu's patch (the second Closes) on reading ->flags during a folio split.
>>
>> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
>> Reported-by: David Hildenbrand <david@kernel.org>
>> Closes: https://lore.kernel.org/all/DMHE8BEEER1H.2BIY52NXATPIA@nvidia.co=
m/
>> Reported-by: Ye Liu <ye.liu@linux.dev>
>> Closes: https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112=
e331291c1@linux.dev/
>> Fixes: c010d47f107f6 ("mm: thp: split huge page to any lower order pages=
")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> The issue was raised by David when reviewing Ye Liu's "mm/huge_memory: u=
se
>> READ_ONCE() when cloning folio flags during split" [1]. This patch also
>> supersedes Ye Liu's patch.
>>
>> [1] https://lore.kernel.org/all/20261029-data_race_huge_mem-v1-1-112e331=
291c1@linux.dev/
>> ---
>> Changes in v3:
>> - set PG_head before smp_wmb() like Kiryl suggested instead of
>>   prep_compound_page_atomic().
>> - used data_race() to suppress KCSAN reports while at it.
>> - dropped Lorenzo's ack, since the patch is changed.
>> - Link to v2: https://patch.msgid.link/20261106-fix-split_folio_to_order=
-race-v2-1-1b59c67b8af3@nvidia.com
>>
>> Changes in v2:
>> - renamed __prep_compound_head_and_tail() to __prep_compound_page().
>> - added comments to prep_compound_page() and __prep_compound_page().
>> - Link to v1: https://patch.msgid.link/20261029-fix-split_folio_to_order=
-race-v1-1-a483c7451b0d@nvidia.com
>> ---
>>  mm/huge_memory.c | 32 ++++++++++++++++++++++++++++----
>>  mm/internal.h    |  2 ++
>>  mm/page_alloc.c  | 17 +++++++++++++++--
>>  3 files changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bd44d58e86845..99b48d7c988db 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3714,6 +3714,7 @@ static void __split_folio_to_order(struct folio *f=
olio, int old_order,
>>  		 * Don't pass it around before clear_compound_head().
>>  		 */
>>  		struct folio *new_folio =3D (struct folio *)new_head;
>> +		memdesc_flags_t new_flags;
>>
>>  		VM_BUG_ON_PAGE(atomic_read(&new_folio->_mapcount) !=3D -1, new_head);
>>
>> @@ -3730,8 +3731,16 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>>  		 * unreferenced sub-pages of an anonymous THP: we can simply drop
>>  		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
>>  		 */
>> -		new_folio->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> -		new_folio->flags.f |=3D (folio->flags.f &
>> +		/*
>> +		 * ->flags are stable since the folio is locked and frozen.
>> +		 * data_race() is used because reference-less writers,
>> +		 * 1. PG_waiters from softleaf_entry_wait_on_locked() and
>
> Hm? I thought that case would be handled by your patch? How can they stil=
l write
> to the page?

This is V3 of the patch. Instead of using prep_compound_page_atomic(),
PG_head is written before clear_compound_page(), after which new_head
is visible to the reference-less writers.

>
>> +		 * 2. PG_hwpoison from memory_failure(),
>> +		 * can still write to it.
>
> We lose PG_hwpoison left and right when racing with non-atomic updates. I=
t needs
> a fundamental fix. Is this really something we should take care of in thi=
s series?

IMHO, memory_failure()=E2=80=99s reference-less access violates the frozen
page contract and should be fixed. But I do not think it needs to go
along with this patch. We discussed HWPoison flag race with
Michael S. Tsirkin and Miaohe before [1]:

1. Miaohe proposed to reset HWPoison in memory_failure() as a best effort,
2. mst used RCU for all non-atomic flag accesses,
3. you also proposed to move HWPoison out of ->flags.

So memory_failure() needs a separate and proper fix series after
we decide the right solution.

[1] https://lore.kernel.org/all/cover.1782676497.git.mst@redhat.com/

>
>> +		 */
>> +		new_flags.f =3D data_race(new_folio->flags.f) & ~PAGE_FLAGS_CHECK_AT_=
PREP;
>> +		/* See above for data_race() use */
>> +		new_flags.f |=3D data_race(folio->flags.f) &
>>  				((1L << PG_referenced) |
>>  				 (1L << PG_swapbacked) |
>>  				 (1L << PG_swapcache) |
>> @@ -3749,7 +3758,18 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>>  #endif
>>  				 (1L << PG_dirty) |
>>  				 (1L << PG_dropbehind) |
>> -				 LRU_GEN_MASK | LRU_REFS_MASK));
>> +				 LRU_GEN_MASK | LRU_REFS_MASK);
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi

