Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642EE606A331
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=h2yQ1bBs
Received: by kanga.kvack.org (Postfix)
	id 7EB056B0AC7; Wed, 25 Nov 2026 16:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1E56B0AC9; Wed, 25 Nov 2026 16:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689F86B0ACA; Wed, 25 Nov 2026 16:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1126B0AC7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:36:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A0ADA8C7B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:36:09 +0000 (UTC)
X-FDA: 85474949658.17.AC50CE4
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24CD0180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:36:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=h2yQ1bBs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795642566;
	b=uT/RVtnl+KHGaezcYHLabvpvhUPK29Rb5yNlTGkGRU3Y4wMwvQpTZlj2NMlEnQLkW0m5+1
	Ae1gLdcY8yjJdtsShOI9R6zyXJ1VbWke+nBytPtDEf90sEqYsrCkJQHjzQlsSVjBnvZb5a
	FXdiuvZBaX1K2B9tx1GurRK2iYxfPkI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
	b=XLIdma+NqnHtCK/ggpFis6bjLnLB76xKzjSRzXYFOVnHmdxaunCPRT9cLeGZe5usNq/JMG
	uIycfnoToE2emZjh5kIFsO3xkd67oHc7tVuKbQWNmh1SSQ0p327YoxLbSCA8NG7tMpqzU7
	+P6aN3the70jcWpW0cuXpxH6KGtYHEg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=h2yQ1bBs;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of jhubbard@nvidia.com designates 40.93.198.26 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Os6eFg9LyRSrgs4GMPaIH2GyBbIJBC+B7p6YfaPbOgHfOAMcV1fUnrrgblZ5lMvksyldcdrNG/iX1mI5B2U51BzjPArkNqWricvY3SrHRBsHFEPVjw4MrKnuVAM6VILbLTpBy6tXgS/gafhXyh/8M2cBtfECKYdIqNmxnpFzxshzQlHuIWwHH67mVEMAiHVejTeAVlG+aHkg1cWDnmZrHK3UjWBkGgvo8vMLxOfKZ04r0LDnFYFcAx252BSNk/vzTMBajaePpWgs3nlNSjlyukCrCV87MQkxbZpeoSHKwe99WuixNOdhzUIAqgmS/7SuMze8QPtBynwTxTpBnJnlEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
 b=nxjWZ43CUJ1S6oy6EIfY6uI9SKoU63IZLJIv/YoVbd2XvVDWzZnePfzNB3cP0RZook5sgloHVsoqKt+UCFBq5tQlkoEUYavWRaGKa+aVupBxxCfz1DyDz7p/CnnYb/jZsDirQ+8j4pkUhIbJ9RHHoQhUbS7Ook9tH4lFyusNMY7DHAbTHEZ/bo2jHigD66w7aLFwOVVRrgkUW+MSlTVG1d1NKz7XvANmZsMZaxIsUtNkR5XPLkUkhqNrn9JUOO2/cKasu27v44ay5BnBU323+X5AZNTOaCJvhss/FtH7hUEtRpv8xMC828jcUxXF6v+6y8PnLeltcDiYFLJg4uYU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hICcxFwpGqAt1bFPGPlzvicfD6n257Qr6ewQEMpxZlw=;
 b=h2yQ1bBsJWSE0lHR/IpZfFG/ZjnBSV2mM3w2RMs2diBWyCU9zMzHe7blBarFZOx3NUM+2kUNTlu4tvqxuh9GI1dUx4rjm1wJY8NvpH+1+vKGqZpjKTc+grpcXyxlCRHZTr4P3h+eG6c7pWUW4zi+r9ndDmsEaB7hPhp7rY/T2nWWs6rLx/VONXN/oWDA3lH+PVwnQBJNPBHzaw957DN48bAWHlEQeRZuz1w3VszuJbg0sM8ztFxG3LrsVbxH8Hy1sMdAHqIuEoqUBCa+WCR8oFvbQSnoOCC5B0hLAaF85FzBcKSINQzE1FYck6k+l9KBkLtdnpbLtq5KYdUmpfLEHg==
Received: from SA1PR12MB5614.namprd12.prod.outlook.com (2603:10b6:806:228::7)
 by PH8PR12MB999295.namprd12.prod.outlook.com (2603:10b6:510:408::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 21:36:00 +0000
Received: from SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6]) by SA1PR12MB5614.namprd12.prod.outlook.com
 ([fe80::1a0c:e9e8:f3a5:d9d6%6]) with mapi id 15.21.0639.011; Wed, 25 Nov 2026
 21:36:00 +0000
Message-ID: <8ba27f45-a99d-4ff8-acd6-e4eae302591c@nvidia.com>
Date: Wed, 25 Nov 2026 13:35:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: Removing ->dirty_folio
To: Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>,
 Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org> <20260826050733.GB15122@lst.de>
 <20261125085814.GA24887@lst.de>
 <woe7ui2vuwznrdt4zxynkbnte7r57juoaicwuk4hmwmlhq7lmp@no52geqttfyk>
 <20261125143206.GA15229@lst.de>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20261125143206.GA15229@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::13) To SA1PR12MB5614.namprd12.prod.outlook.com
 (2603:10b6:806:228::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB5614:EE_|PH8PR12MB999295:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e2387fd-4dcc-4df1-0636-08df4b3c190c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|56012099006|11063799006|261022075727099003|261026140227099003|261028144727099003|261026121527099003|261022105027099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DpqKynoHIJbOkFORdRMRzqmEYsQARv6izJGK89nb+ts7pHDnc3vjnp4rXGcQOlCCmWp6/iwnAfAHTFRAq94BH92iMwH7eYVNZopSXQBej0dyYZCzQGh1T+UNioyYgS9Oeg+5LsSz58RSETYNlhQrIS6H/wqOx260/DVPlLJT92hNbAsh+k9GbIg7a0eFJtdICqLxuP+LRpiAygeovJnp19Yaiem4Z134s2wbaRsINb/HEalnuboUr5THa9YrjOJoWiybDgDBvz2j8MLZLXake6Et1qOQSAfMhD73+YVYhZnL8VHOSIoO4zsNu3mrycZxKvGNwfEwX947PUEGuE7T4ypwu4UgpkP5ozzU9/e2NQ3QKeZUA6drjoVt/AA/ymaM3tfU4FuSuQ5LoVig/KKeAwlf1cJUnNbdhPCTTXrgDe1wsLWLzjF4ELtHgg4dFqHfH0YJasDrLht5PKInpPHpMPFZpEOwi0dkXIWBpWcUz4yRUqorGyA6ZBtuQalzjRCFIz8hUmPi8VcomXy1OJ9f6nV0CpzhbJXpXP5w1IKTLxsj3F2xpP/lCPWoKHNuFNvjiLGcmwiM3JsBXS8b2OJWNyUS8xl1joOqCBokuE5WMeExt8hSX/odd7YMOWMx+LbnSBjwcZZYmDbtieWY5DQKhXZx1bfCEHxmoMsOoyrYaaQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB5614.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(261022075727099003)(261026140227099003)(261028144727099003)(261026121527099003)(261022105027099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWp3Vi9LTVJBSlJDZFpJa295KzZCalExYkdUTEVRcFRicyt0RGlJSDFDVTNs?=
 =?utf-8?B?alkxTVYzMERKUDZaN0Y3L1RQUkhCUjUvdWFXTFdSbCtzdWYrRGNrNmFhT1Nl?=
 =?utf-8?B?YmhMYXpWd1owZFlDYmpJTlJUdGVqRWhoRWltQVRteUhPVmZVT0FiV2xJZm5B?=
 =?utf-8?B?NXI0MW9RQVd1SXJTQ0RmdElaZVpoaWVLUXhWa09nSmJ2SmFTTUVaclR2R3hC?=
 =?utf-8?B?aHBBNDgrNUtUcDlBZ2ZITWFxODlhd0pOVEUwK3VUcU1Lak5Vd3FxK2dJRVBV?=
 =?utf-8?B?RlkwblVQaEZUNEpuV0kybWRYUlFRZktOR0tKUmszRHQwMlRLV1d6TGRhcHFK?=
 =?utf-8?B?eVJMQUg2a2lOUG5xR1Q1NVNGcHZvQzNlRDZmSFE3QXVDSUgySU16Z0FUc1Yv?=
 =?utf-8?B?bnBEZjZpUGJVZXJJUnROdFFFVm1Bczh1Rk00YW1tSFZPKzFUcHJ0L0tjVjhX?=
 =?utf-8?B?TEhBVm9XWjRldnJ1Tzl1MkszNmRId0xrbjFMVHlLUnc2OVRhNEFOWDZhU0px?=
 =?utf-8?B?UHM1RDF3ZEtzRVd6RUo1bHdJQ2MrWk1YYXkxTVhSdVRLbWEvaHlza01ESjJE?=
 =?utf-8?B?MzV0d0tITmRjZWJzTXZaa3dTZEF0VFdHM25ycTZVQ2N4MkFMdERUL3ZTRkUr?=
 =?utf-8?B?cTJzeWdmQjUxdXZXWGRmVHI3aW1Oa1N0bjM5UE9LOUl6VEpUYXJEak5xcWtJ?=
 =?utf-8?B?RlpxT0FOK21NNzlvbUZwd0VKQmlteDlXQVpNYUZ4S3FsdGRSVjZXZHBHY2Nt?=
 =?utf-8?B?YWZORVQ3bWkrNHQ2ZFozaEhhRmN3Z0lHK2ZGaU1WcXdwT09XK2FoemNVbmFu?=
 =?utf-8?B?M3hQYi9ZYXhubE1jeXFYN1pKTHQwd3dKRHZaOGRmb082ODdNaVU5ZUo3amNk?=
 =?utf-8?B?TVFINU5zbkU2YXdxUEtERUVPaW5MckZvdEJnUkFJQ09QUGdleStDd3JDQXM0?=
 =?utf-8?B?alBYby85bkNla3JwUU9ZeWtpUlBoVkFkbnRhZkVJbXJ4aFk3TnZhZDJOUW84?=
 =?utf-8?B?b1J3VUUzS1cxTkVRMTJBYzZvbVlrZThzVlprS3VOOVFjaDBQdXoxbHNCUGdn?=
 =?utf-8?B?bDU0OW1VRCtuMGoxTm9Dd3NUVHRQYUw3NmJCelVwUkFyZFpyaWcxdEtScXBt?=
 =?utf-8?B?ZG4zVEJmT2RaenVPQUthVW1zZHFDYnVrVVBjVTdkZ0lMSk1XckFTSUM2WjUz?=
 =?utf-8?B?eDlvMnlHRHdISnJKbGpmcjg3cCtGbHZ6c1l4SXljYW9tQ1Y2MVQ5RGwvTGwy?=
 =?utf-8?B?TUVkd21mcDZsMFZXemFzditLWFNPUDVGR2RJWlRmaTdQajMzZnNEckJ3Z3ov?=
 =?utf-8?B?RVlHdE5yMzk2QURwU1lsU3hLWEhWTnBjZGptK3ZPU1crMUc2Z24zUThoM1pP?=
 =?utf-8?B?aTJYS0FETHR4VFM0ZmVRb3RqeFh3cE4vL3BHbUljeERETWFiWTJoL2ZFYklQ?=
 =?utf-8?B?T29vM252RURkTE1OV1JqNGFPK1EzSnZKczhaQTFBZ2lzVlQzWldHaWZVZ1lQ?=
 =?utf-8?B?SHMrNldhRHJDeGVlWENMOE1pTDJoTjNXYkUvZ2czMEVJK3k2Sm5uR0RoRXBa?=
 =?utf-8?B?SzJ0b0JGY2xEUWd6Uk9zWXYvYm9XOFcrNWJPZllpdm92dDViOHJ1SUw5VTlQ?=
 =?utf-8?B?SzdOQURYeEV2N2FvbjdJcFkvNHVVeE5aUWlMeENVQkVURGxyalczUDdGK3NB?=
 =?utf-8?B?MzBHcFBSamJabUlOLzFSREg2MVpKWkx6OGxjMmNtOUlDQk85YUxPaFZSQzd1?=
 =?utf-8?B?d2tHVExqNTVyeWZKY2xldStQUlcyTkdUSWpNTU9uUGhRdGwyTS9YTFNPcVo5?=
 =?utf-8?B?N3pua0tHRzJZRVluanFwcFgzbk5LemVweHF2L2pJVjlKakxjMWlEbWhpUTJU?=
 =?utf-8?B?OTFnbnI0YVBreUxvYk4zT3dSeDZwenkzUEgxVXE3SlAxeUtPSmdCNVJ4NVdK?=
 =?utf-8?B?YXd6MUZyeU5RNFl5M0xydHIzS2I3dFU4eDlBOW4wUUYzSm1sNGJyR0JyTDd6?=
 =?utf-8?B?blV0YlhLdHBGQ0wzMlkzQVQyYlBtY29yRHhRYTVSQytndjNucTN5clgwaE1Y?=
 =?utf-8?B?UWNZSXJPZHV1T1Z5aGhqakM3TU5zQUFiMVZ0ZExzcDVycUZsRzBMajNnSU9R?=
 =?utf-8?B?SDQ5U0VzbTBad1F2TytaVmdmZHNmOGh0M0hwQm5nNXNteW5ycWJTOThReE5p?=
 =?utf-8?B?c2t6b3RzMjM4eXhtWGJNMHpDTnRCR0hmeUx2RDluZFdoVGtvaU54cXJSMnZN?=
 =?utf-8?B?RHNvV2E1VEdmdFRxTndYNTk2WVZGcEoxcVZwellvWHU1b1AzeHY5dmtkcTNz?=
 =?utf-8?B?ZWJyMFB5YjVLWTZtT09nUWM3NmczOWZCL243bzhLR3I2bXdqRkIrUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2387fd-4dcc-4df1-0636-08df4b3c190c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB5614.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:36:00.1737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G/1a6ac9cJFNJfoLq0vQHG1eR58UoFdoMDlgicvgD7fSEgPr5Zims9I/Oqvd1AuUnvmmIDPLRuNcuVFyYRzQIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB999295
X-Stat-Signature: d3jgnxf6g9f98pxj3arf1exncur1eut1
X-Rspamd-Queue-Id: 24CD0180005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795642565-313000
X-HE-Meta: U2FsdGVkX19RWh2hGo78KLlUpVaNPclJc4Vy7NtA1ARgKzbKEGrpzymsPelSt46N5ivk0knhY2BI2fjGk1ixrvsWtR8AwFq69Jt8oDAXz/3R94IpQHr/uqYZ7aPZHe53icbF1RgWBQHsn45QWHkkwNY0sy24sjNLB6sbkC4/1DYCavvoHBYlejoSSniJIN6Eg/aYBJUoxZSmffuVDLISeMWAs2fmUKGBvBnmL57urMnyysQuN/Wfvq6I7SlPny5URpzy5ff464adyLS6a0p5tCs4FrHrdtugw/MThxSVNnDBxRfgAXiQJQ/6KDcjTSd9npWGk9hU2+e7un0Mmzq1evmhNJNk1FdrD4W5CVPnf5wR4VLKYGJBf20Bw+LmnqP9CDW6C5SShqAPn1xllM3IoWpDlJa0sWZc8tRJLgX1MSCjFDSwah5mcdOi3wwFIjlsD6bmAyNV3pZKCzE70+wQKL1NZjSHUNhkI6r7v/lJYBun9X67koY2GghBS1bVG+UJGPMjmPFwc6reRKzcAmZLcCLrgZ/q+Fe9e9dmAMOGe0OTR0Ku7Ip5Mn7AZLQEtjGKpZYq22thPYuBTMujwKi5eFQaqJHvktDIEfy5rP44i2kmYCjkaLsyTQSnA8dPiIoo63JHnG99VgTxvQDJQOUEMpPbl3k7T+A0ekJtuk3HJGHfk9Q5EWqA78Rcv7qb0M8En9MnFgRpXVqsV8FwDiJugKckuiJDi+aRTP16tYjwUioyy3ZYayCOB4hhub2p6EufHHLKzNQZBXrh5DrJdPrHyKJvPaLv5NiR6kKExgaQRWk+jGN1xjekFy2KhC86modGjpVTivhboH5O4XUdRorH2vBT/tFwasXet5bo/uOfGtYLKR9MiWFyS/RQlfbWLEFLVNWxrWGYj6/n1a4MVWgnNmBkJBEXG85wh4ogxGJM5rc+d06Igmcz1U8oEio2R6aQ6t7reHzD7jOm/t2bq2m
 WlmVQmXU
 LVdVy2T5jasizlRbPpVQgKuz7HoQpP8WXS+N+Y11v3B2pkXj+kkSxypowY2hBdrV1bht6UZIBUdJ70+Qz63nuMWMk3/yOJm5ZhtTpNc6gXktUecKbFVIeVZDp+NL8HPL8w6fnl9D6JbFDvJS9J5OvdPFa1NbBqgwNr7wW/sAyKp9cMzv83qX6ReDIKR25/Jrirnp46fFmBnIyQepTmOAj16I8TC9vcGphzvEMxRx29+CZZpBMUKJ9TFCnMw71rmcG94eI0s2Mw6NRMOMooTJgCqic2A9dB6a1lLovSabY0zeW6SmSJ5VGl0vczQC00xdzqlgX9tQNjK2Ja52CG8GnE9cJGm16qI1lXvj5BLnNhCd0/9727oqHyVj9s/ASz4nLfagOlwfrH0xOhezXo9UHM4uSFjJC0FQe1m4CJ2qQi+Jn9QwNA4cdWL3HrLxZZe57IfIvh+Dldv7zfLUp7pkN7FDVU5Mc902d6v3Zc3Mbkq32zFRpnL6tGyTlhhxB63jJMXKQIwnoRDdP9PhnWsDei0ps8qzdeSjalwrUbEAf+RpvOt6km9gi8aa2W41tCaoOLIVomMfI3hPIdgMsmhwrYsgyNxczdJoG/2fzJ3XyYmdQ5bOD63EjA90SB3xrPmbwhlPSUH6A438hLTsrZk2w0zeZipckMb+7KBtPySp5GVsbRfCQ7qlF75lqelNfgM2+Va8gP+w0ZajpCc3OSSP6WmGbx2Dn2OA6CEmYUv7mxHVEot6lVoilVYjDf6ZL3ZKU2AvfO6g8Mh47x65GwhHD8yafag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 6:32 AM, Christoph Hellwig wrote:
> On Wed, Nov 25, 2026 at 11:15:40AM +0100, Jan Kara wrote:
>> I think we agree regarding the direction where this should be going :).
> 
> Well, that's good.
> 
>> Regarding the tracking of longterm pins, I remember when we started working
>> of the GUP / pin_user_pages() fixes, one of the ideas that we floated was
>> to take pinned pages off the LRU (they cannot be freed anyway) and use that
>> space in struct folio for the tracking we need. John? even had patches for
>> that but the performance overhead was too big (primarily due to LRU locks
>> contention) for direct IO. But for longterm pins, the additional overhead
>> of the setup could be acceptable and that would significantly increase our
>> maneuvering space in what we can do (because longterm pins are yet another
>> page refcount in the end).
> 
> Yes, additional significant overhead for plain FOLL_PIN would be bad.
> But for longterm pins it should not be an issue, as they should last
> long enough to amortize additional cost

Let me go dig that up. I seem to recall that one variation added an "if" branch
to put_page(), and there was a thudding sound followed by silence when I
posted it. haha :)


thanks,
-- 
John Hubbard


