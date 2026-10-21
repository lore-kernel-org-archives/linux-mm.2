Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154F1606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=NSuVeUhD
Received: by kanga.kvack.org (Postfix)
	id 10F0C6B063E; Wed, 21 Oct 2026 02:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C00A6B0640; Wed, 21 Oct 2026 02:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F194B6B0641; Wed, 21 Oct 2026 02:20:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC2086B063E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:20:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51335120468
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:20:14 +0000 (UTC)
X-FDA: 85345633548.01.C838027
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6140C40004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:20:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NSuVeUhD;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=568eS8s6dBl5MYj9uCKiRiVK+QnO/nCbP+ChdFcu2p4=;
	b=s//2gv6Yr/GEhNZ4EtEtjvBEdDiQ1zbSC2uVIT4Mla6gHJBu5jta0YbiNOzNMo0MYbCjRZ
	9hZDCo9m0UOGxj9l92nyNWzuO4C2ivSkcjDQklAzgoZww+6r9RCWtr57LhBnd+e031xehD
	XAj+C4JmF1wpzibK6aDvjTG6ZFkixZE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792563611;
	b=xGsyVmhpS9rsWGdHpFlw+QSowX2dMgBQPyvGQ4wV4qpX/w7CEg2iun6RFKQP6OYXWJNf2T
	LYkDd7UQdttbEGX5Pmz/4C85gsCHP05VYoQHT1BzXCEHdd5xZmJxJNrKfEo3XYbfvjouG6
	ZfwWYX1ZtlrEc4Id+tO5S9Wh2XLzmRw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NSuVeUhD;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRqPxlK3Cxp0Wg/KNVrz0pagbsh4h/8L3zP+zOC5Or9IPJhVDxjuj/Hbgm4vjsoQmr0AWPrJY7esa419Iy3waOtzbUDKcJIe2QmAVc4JfW8a/vYIIuhGtFQ7Qd+Z4cdCqqoB64to5L4OFPETQ+hlYngY60gzMohdH5nNwB051TyvJxNt1epklLL+DKy+nQMuDo5cxVNQmFlYjLY5Wf/fkAFCnTxJsHoSoMvAhlRkZu6YtXnymOrMF2zGRn9E/JTQQY5RIVuoMgu7fjC6t2HCIdfrNytIBcxBZDMtbz4GBrf+Uin7i07Dz996OtUDKEo6N5KT0mjSWHPvSnotgN4cVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=568eS8s6dBl5MYj9uCKiRiVK+QnO/nCbP+ChdFcu2p4=;
 b=pe0kMKpogn1t8IyTcnVzhwkQlbbwCF3KrX5LX7wIaKxG2v/IRDH3wuPWmld3A4PpChFvPxZMWQemwyamBi5MqdFi0/fIBaV0hJsd+3AgX7zRgz1P1431zgZYv/iQ52NWhdj2dHrW31SVrTqSDNazzvr7rRUu6+KegVEUcUA/H2LH2cr+Xd0CjX9gW5u0X9aIo6Q1oUT3y5dp7JtZQ8AsZ/ihnHWrNq7XJ9Rote9tTRC0iEowNghaPlVgjg7T3j3nfvtMdKFP55JuHEaDBgSjWPmaf1aPBJ/veHrKmFKhjfTqgu3DVRIEq+cCElgtrnyAmr3i0WZyAtSpjToE/bEM5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=568eS8s6dBl5MYj9uCKiRiVK+QnO/nCbP+ChdFcu2p4=;
 b=NSuVeUhDM7/kxuGz7+SDFFDSEsbVaePW+9icEy1wEnKFZoQ8L8lsgBo7lzkTMVJ9Ke45xNqoujIcdd/tQyLJ3PUON5za+FLFxXL5PziWIPyiqCtjb+UhN6MAQQZIzoTgfLqR4fJ8bq3IxHFjIhcj0OshSbI2iNzo7JaG4z6/Xbz7AKtlfWhqcIS1v3joIysbN4rL70sZ/tr7tPpc/wIx/3x9G4RZDAWJAkX62Q3Sr47JVc/wigCHSHknrLbZwjNMn+lhzopRu309wer0wj8C+TRD7dzZFLXVTtFq45GGaJzB804hPhqzqH1QqMB6PxtDDLm6vN1nJWhFV0pSC153Tg==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by AT6PR12MB529233.namprd12.prod.outlook.com (2603:10b6:170:115::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:20:07 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0522.016; Wed, 21 Oct 2026
 06:20:06 +0000
Message-ID: <7c8c663f-cf31-40ff-bce4-784726f42a0b@nvidia.com>
Date: Wed, 21 Oct 2026 17:19:57 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 09/12] mm: enable device page migration from HMM
 pagewalk
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-10-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20261021060506.2377545-10-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME3PR01CA0005.ausprd01.prod.outlook.com
 (2603:10c6:220:19e::12) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|AT6PR12MB529233:EE_
X-MS-Office365-Filtering-Correlation-Id: b529126b-8a96-42f2-425e-08df2f3b59bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|56012099006|4143699003|11063799006|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	2rrXo1phrhSuIIGhkL3IwPYT3d8DAnlRkjl5oFJliyWnykqywt5dl8PwkVkxS4MHpc81t7iAEZHLlh3a3r3BIuX64UknasHQxd2+nTyCxAu7uzrrtByLA5hvRBsLNcYZiTiTcT2btdtA4M+2pYzokiKzDfZbigwnTwfGhT5hKevxFZ+76+tSUDGTJOIK1ySkIKPe8rS/jk+t4UxvlyxQfXJNeGxP/EoJaKdCbYayNjV5WtU+eh6Yt8CtJpANPjRQ9X2Wup+GQ+bAL4Kl5uIweiMuiGQS8mFSMLgvsyz02xnXzQPs8KNFNIyHsV/mD64wXb36qen1WP7Oe4NdDdRipjNWk+EN1vVvU/XBoXbi9gA+kIY+t0yHqP6bFkY763y40kf/ogybx0GQjpSF52UGDTIrami72W6YGMkcTpCKc20fBkMo0HXdsLqziI8Us5CJVq7AUym8aV6ax0YUvk+3xeHwyfBgmhjbf8W5Xy+Hdb1QGevvX5l7dc2AG2YXeM1l4YHHyG2V8Y0DE+qnVDsffxmzzqBGxQ6Rh8tOtW1GVfj1uwdZNsscSa/6aMNLL90wiIvQ64oF8jPDoIoCsCMgEF1frte2phn6F5E7vRdDBuCyG8OZ7pRR9OGU8LtB3A0goT5vCHeLZgCumnJkftipVn7yfcqRSiPNRR6fC+/WzT0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFFXc3JXQTdrNVo4YWY0ckJINzZnMWxMWVJyR2NQSVY4WE5OTysvWXNTYno1?=
 =?utf-8?B?aVAxZUJYR3JBVkNpZXFocWhOdUdLRUNieVZsWUFOV0pidlVJcGhzVmZEdllq?=
 =?utf-8?B?cUZGMmxxNG5pSUdDVmtudTM5L2hVQ0daZU1Va0w1US9ua1ZvcFpYczFuYnYw?=
 =?utf-8?B?Si9sZ0lXY3lMcjg5bFQ2bm80dDR6VDdHWTJWZG4xcTAzZ2VyTnAzcjJJWnZF?=
 =?utf-8?B?dWdoRWhMTWovbHY4Vkw1dVhGMDNMM3FZdmFNN0xUT0hkMVpMTWdMdHdKelZW?=
 =?utf-8?B?TXlrZmprdkJBaGF3ZXZKTmt5OUh0WC9iVHhNeG5OKzFkZ0FIWUN3dXplUWp2?=
 =?utf-8?B?UnFCMVZoZmNacCtubHhtZmJrc0xtaVNwYktJQ2hCenpVWGY4eDBaSGQ2Skp3?=
 =?utf-8?B?Sm5JRU5Ta3FqQzQ1TXhWZllMTU9QSEZKMmY4UTJmUDRNSUI1WnFmeUkzQUJU?=
 =?utf-8?B?dmJFWmNFYTBRWk9YSG5ITDRxRzBvU1dBRmZiVjJlYWw1REtLc3FLYmJaOEZ1?=
 =?utf-8?B?dVA0dVk3Szc4RXhQSjM1Uk9OYWplZWZBQk9PcUg3ODZJcHAzcG9leklNUlhj?=
 =?utf-8?B?UC9xMHVEOUVmdHA3TXJCdE1XWDlSb2I4MU81YVNxblJuWm1SOTRJRUU2TWhC?=
 =?utf-8?B?WVJDam8wcVlBVzN5YXNSUEZyQm8wMktJNVBMeWh0L1p2UVdsWFZwbXc5aXY2?=
 =?utf-8?B?cGpIdTBjdnFDUm84aTZiekh2ZWhVY1d3di9rMzVmYmFZd1FsK0hxbjhsR29w?=
 =?utf-8?B?T1RZNTA1eGgxRmNTOXdaZ3oySkZKNW52ZElWWG5qYWdhNmJNTnV4RHhKNEpW?=
 =?utf-8?B?WFdFWVB2K2p0WEltOW9RZ1c1TjdhOEZBd1FJRHVuaTh3enhURnp1NnRvb2Iw?=
 =?utf-8?B?d3hKcjgrYnFoU092VjFadlJDSTdKNE5VZUE0QUFLcHpNdm9abFdUdGc3Qzd2?=
 =?utf-8?B?Q0FmZXkwMVN1NmNjbWY3Ymo4Q1N3a3ZrUWtDV1oyc0VycHU1M0NWelEzZmg4?=
 =?utf-8?B?NlFvUXhxYXJnaDdBMm1QU0Fnd3hyUzRCNUVhWTY3WXdXTDAzR3JSdmQ0NUFL?=
 =?utf-8?B?UDBlTWtRWDJmcTk3THNqY25hVHY2SnIrd1NJYTJjRk9uaW5lWXE0UXQwUHFF?=
 =?utf-8?B?aDR4L2Z5R2kxbW9OZHhsclNudlNyRXF2R25Wd3U2eVpHbDQ5OU54UkV6QjUy?=
 =?utf-8?B?SWJ2NzBLYWFES2gyN3o5cExNeDRFeG96UG5tamY3cGhpSytKM2liczRlTTdw?=
 =?utf-8?B?Q3ZvVExKYXIzRSt0NmN2OGJ3SGZmOWZsRWoxQTFCMjJzVGl1U3ZidE1VNTBh?=
 =?utf-8?B?Y05RTjdpV0F0MVEzOHA4TTBmUWlvNEQ4bWdTOVgzaU1pNGpMSkJiQzcrN2Ez?=
 =?utf-8?B?TVp3RFhjcnE1ZjhLZWwvbmZpL0hmV3ZGTkFCQTRmQVBodGhlR0NHaXJMU1U1?=
 =?utf-8?B?dHRWKzllczZ0MTBoNDVuL1ZaUFNUN2NNKzIzaU9veSs0UWtHY2ZvOUw5L0xj?=
 =?utf-8?B?RE80SzZEa0piTUFqNWFyYWU1U05OVkNEa2VGSGp3UVU1QTh2b01UM09jOWxN?=
 =?utf-8?B?QnhZbjRnQ0FWenBKdXlwaEN0Wk0rbDJOMmN3dTZsWE1yWWJEWEdjSnVOcjVW?=
 =?utf-8?B?bXlpdk43NDFEa0tUMzVaYktaa21Pd0IxQTNqSGFaSVMwczN4MlQ3Rk80WlZi?=
 =?utf-8?B?T2gya0VFb2h2TEJLcTFqRjNnNTNBMytjdDFVTnJJajdWbzk5ZDV5WUxoREho?=
 =?utf-8?B?RGRSbFlaUStJVmpsOUUvWGozNE56bS9GMG1IWk0xcVAyVitlTE5OZWRHTW1T?=
 =?utf-8?B?eTI4WE1nbS80YlExWWl2OEVTV2ZYb3lZZnIxdFVPMUQ1YWh6UnlqUmxrT3Nx?=
 =?utf-8?B?UVZhbWdCM1Z1YnhxVC9UcXZ4SXJUTlM3WkovL2tCSFVjT1R1MmtWckQvUVJ4?=
 =?utf-8?B?a3F5MS9Zb1A1WFhsSDV0K2lpbTF0bE1ZR3d3MWcyYzBmKy9RM21DdFZSRGhq?=
 =?utf-8?B?eUt5NFRzZUFTRk9mNE9ibFJtM2gvSE1PcjJEZjVlZVFnRGh0SHJkdXNYeExE?=
 =?utf-8?B?UmY4bUxudHQzQ0t6dmV4dkJ1Ui8wN09xc0ZrWm5DZjFXTWtTS1hMTDIrOTky?=
 =?utf-8?B?dWl6SFZFeWRmbEdvVWwxUzJZZ3FzOU1OM29nUE12TU5OeGtNc3RpYUZjQytX?=
 =?utf-8?B?NzZGMzFGK3lEeWZoYTYwWGF6cC93Qkd5RWVEQ3JLSjJpS2tBclRvQUppeGRH?=
 =?utf-8?B?eG9sZVVtb0pkeXJVT3RVR2hObU9lMkxqalNQYkIzRUdsTE1Ua0lLdDg5MVFL?=
 =?utf-8?B?Y2lFN0ZzcjJSQW4rcDR0Z3BiTUwzSHM2U1FRZkU0dGNzVUNTclNwQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b529126b-8a96-42f2-425e-08df2f3b59bc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:20:06.6120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2ZYGNhHf48R3bOZgoQ7W5pgCnuF4raTY33e/8u4+2jUpTlhFV98Y4jbEvXhr2eCe58YSuo8rkpiQNYnphQqmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AT6PR12MB529233
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6140C40004
X-Stat-Signature: 997jgoj8xxeedsdin1zfnkciucn9i185
X-Rspam-User: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792563611-922785
X-HE-Meta: U2FsdGVkX1+2SUUBG3j+wA9Moix015WZWuJz6fAsAm8Ri9fgv+kbkX3l9aNpu7SBqCsaZyXCfVgm9Q+L4sVV7A9R/K89HLrW5yupwIHq4P8FhmyuOLMjtbM644mmjP7RKjXDSDeiJEPDlpAESb3AavKiZ2VHfR8pbjPVbioo+yh3ZMnup7KwMG/aQu1y5dCWK3g7pwiyIBOai1fc5uq3dWFJ4jVjfKOScOYmLwjY1Kl+qwtIqiBOeLGrjIobaCe0tWlercDalR67rzK/MGumXi7/e75iO7bL8eYR8gIgIXooVwv0jewoEMAQbZtwZguRxqx+Om+OhTyRpBSES7XT3V6rjY8MVTy7/xjL4NGY9bOcgMOnXrVJcbLL/RJmB2LbxZpXmUNqwNrYrEqxOiM5anelLFWE2749sQcJ3KF0MoH+G27bG+LhFjkSFBivH+Qj9Uq6Os81uoaO/wafsV2MlvqNesA7hV1iZMEL6zzNInEO1d3dSg7NryUc3bmDSJatsdpMGKnZeAiZhy1a3yIQxu3TP/0BryWbtBnlc//b8xly84ZJNiybq+sY5r7x8ZPwQJWh+DkloMWRhEPK3Rouw7+HKHWIkt3KUM0vDXsDXkv3ww+i6OVMLVFIF1MpDXOfTWqvV6EPsAs6jHFykDakt1poEX/+Xno0rGhj/Ib0VOB890WrPubz1LN5ki3OVSL3TdlmWVFnctAv3ImI5LoxkeK4Gt7XFylEPA54IzjShgPrbptxofE9o6cgBTog4XcKviIGgXR4OXmvSxl3UmbxA/BuZRobSZysIm1GXSXHl053ffytqTHGJTg80UHWHX41S0UdEtwoJXRYiBc9ekBUIQXY8DcAugexNILKUXLyqEignooHNX+J2X6tqn85/Aup8W6dA/UCa1m6Xr2XQhyPj+vTRGFAYo83/fJ+gMdsV5ON4evCVKSVNyLRsYmkbQ7nzBXPkFelU9SItMbPrzL
 7ICeOb/D
 4YWYhll7jn/SXuvVDvXxb1EXbei7P4DQCOU0FdwkvroiP0fCv6qPYVJf1Re6gt8eaMQ5z2dIHGUQPtQKSheKu6ed5RQ1WQMMpxPNSpFOLFEBE+NLIkhHp8AzJdXE8mJRbqjGnFHzHpu4W39rQi5HLkdTMFX3gE4JycUfLexypq98e1hHeWbcnkGg9dWcq4WhAQaJR+rKLwZd3LVhhh0iv7jIuvbkzJJEOLU8Ne4k4TyWHPTFtgjL9L3c4Vl/DXaP6NiNA+nBhKGMCkiVe847PkAJpWSHJeYqDbLkz20miTIzVKbtcNaNs0dqAHSz7nIyl+SVC7cnpDhWTCQw598CF497gwN4svLNjaPaCabWLDZI7tdAlmAmzNF4Hd/4MGfS+7HdF1jinrLC1GG/iBOP7SWmYnboWSQmHcCnnMBzMbxHxWPe4saglurVYjzsni2PJ87ZyfOFINNVYv7buUT6ujkDu5bfMqjN40yKLcRvbSSBIFqrl23VAg/Ju+hnxBdJ6K/znAmU1Zfy7Tf+JVAcgV8pRzSjBcM5OCqLpqxcKoQB3eHxyOLMPppS3fZ8ZrKjv4ZlmUZ1wQ7ZipMgMT7BZsP4LxaNWoKlDamph
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 5:05 PM, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> HMM pagewalk has now the machinery to do the first phase of
> device page migration, collecting the pfns and installing
> migration ptes.
> 
> Enable migration in hmm_range_fault(), and change migrate_vma_setup()
> to use HMM pagewalk path. Two new flags, MIGRATE_VMA_FAULT and
> MIGRATE_VMA_WRITE are introduced for migrate_vma_setup(),
> to request for faulting missing pages, and requesting write
> access.
> 
> Also, the migrate_vma_collect*() based paths are now unused,
> so delete them.
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/migrate.h |  10 +-
>  mm/hmm.c                |  33 ++-
>  mm/migrate_device.c     | 562 ++++------------------------------------
>  3 files changed, 83 insertions(+), 522 deletions(-)
> 
I got a conflict applying this patch on the latest mm-everything with
mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup(), quite a simple fixup

Balbir

