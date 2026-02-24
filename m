Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5968DEFB7F5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 04:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C19A6B0088; Mon, 23 Feb 2026 23:00:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F796B0089; Mon, 23 Feb 2026 23:00:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751BE6B008A; Mon, 23 Feb 2026 23:00:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B12F6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:00:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBF96C1BDC
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:00:12 +0000 (UTC)
X-FDA: 84477997464.15.9A947D7
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by imf07.hostedemail.com (Postfix) with ESMTP id D558B40011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:00:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FtSNd7YF;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771905610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaJDU43VAIvoX2mmsAgsTdufyDOQ9/0/sEeWfmiOc0A=;
	b=I3GvDfvme6nl9QsDaeYmf8SJcRH7+IVE0ng5kJi9BFf1d9/l1hyDkrkEKFqmhP9U2/TQZ7
	XzzWmyQc+KurkfMlKn7rhOqyOO5f0mH1aWpCdB+uGDiFfAO3gdjerHBTspqXqqEHiugCXo
	ppcqAOl2AJ4TTUgwWKz8AlhONqrPv+A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FtSNd7YF;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771905610; a=rsa-sha256;
	cv=pass;
	b=ODywm2nLqNX8SUi1D8ET5NChRJoOFOHcBYy7mxSBu8nzBoh1FNLf6fWAf6QusMCKMfmIJz
	8muWdnomnmNFPd62vBOq8MCAFUTajV/5epz8GGyNcRufH9trJGIuUwTqLvYj/plj9h5T+u
	1OhrheTzhoR46Kxwo4sWU4Z8LoyB26U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n+t5UV8t6S3nDrY0rjxmXrfJ1u4UOxqWE3PgQ/uzPaKIpYdfrxZ3u981Au3LF53mzH42To+vVj3u30aXArlj60vcWScd4A0gxEbXbWY6gb6DDLmPkLyqH5htCgZJT5IGF2Ck4VAoDOSSRyZ/FzVHyAZTPYmRc08W7nuYCgxCzUpiE9gyFDAdmEfTzjWxp72d0PqlHwHa+KxoQCVwzIqBAOyXfDyIevss2RZXsHg8x04TdSsCCQurbqujvL8CSWqiZdQmrkvJibnJib6mTk0In4hLfrtSDyO+dQk43X2Zov/705csdpeqO7amFP3aaj6N3fWfz/ZsLECHDuNN1jbcCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OaJDU43VAIvoX2mmsAgsTdufyDOQ9/0/sEeWfmiOc0A=;
 b=Ch+60VKAUklPQCZcOrGbD15LWZ9UaXo02AoVRBndxIsnwvgQdN3q7LfKrsGLOVL7iNBDAPXvTIRqUGS2BDtlZzjNZo7livb6PUSY5RzzESSWV/pC6VT98h4vdxTbfFfzLsGHXRwrRaTFIJO/SxBQr8OrT9GimUKSaNL3uoytokbUchmVLzqqRAWaLDfQhKs1xvDshWnqHhyoGBfiS3ANhUiobqAu9jC9Jxcu78fJJiXlOIEvB6cIQBGoB1F/OUw1U8lS3qdgGbOyekADcfbJKDAKvZoCYkSEZEi8WK3CtWZ9JUyVRoJ1Sh52KCsAGZWZhBmLOQCowzjjdberPPEKJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OaJDU43VAIvoX2mmsAgsTdufyDOQ9/0/sEeWfmiOc0A=;
 b=FtSNd7YFVzL5XB8PubZOnlNvR5/prlOvtJPpgd8Zz8S6pFzUHEJCthsd2g1Vd0KL459/vPBli98DI+OaW4g6hUwQfSMu93QXuK7llP1MgF1ccDq/Vr6TF6NXs1sHu4B7pUVyTp/z5xYD/UGwcWFmKA89ZYE9mtjNP//Dp7oX/MN3FjImDW4FBodgFn82HfcJO1fzLfpukMoCWRyjdb+SChGK4I6nQohONpHBtTEGm5LFwBF0yH+vjDa3ziEhFCELbjQOgqcAnASp5L3K1EmjMClGP6n2hYFtACcVP0JC3Oaf6R+mDSgBAay7IlVxfZDAld5BP/qD9Y5Y3w+NWZGjxA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 04:00:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 04:00:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Linux MM <linux-mm@kvack.org>
Subject: Re: A potential refcount issue during __folio_split
Date: Mon, 23 Feb 2026 23:00:01 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <097A507A-C60A-47AF-9590-1D6CF712B1FE@nvidia.com>
In-Reply-To: <20260223115948.sbylmtqhznmabcth@master>
References: <20260222010425.gbsjzhrew3pg4qrw@master>
 <20260222010708.uohpmddmzaa4i4ic@master>
 <6346656B-7518-4A55-8DEF-C2E975714C8B@nvidia.com>
 <3e22afe6-ecf7-4180-9287-c48fea7b8be1@kernel.org>
 <20260223115948.sbylmtqhznmabcth@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0343.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL3PR12MB9049:EE_
X-MS-Office365-Filtering-Correlation-Id: 656dc1d7-ce50-4edb-23f3-08de7359314f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wK2mjLftLIWMYYb9t0mhunqFB4bg7mF7ZMY2C/ZXKC2o3McnVLRoTmy5pGRo?=
 =?us-ascii?Q?G+utumVUeJM1/cps7EQDiAzS+TmKGS2QLZQxAAU2FZX2vOkxqTZcCqUwuN5C?=
 =?us-ascii?Q?XSP+G2ccFRypgS6jicOOulyiNqdjFchOZCJD4hTTWuNVg3tI0lTe+EBiAsjx?=
 =?us-ascii?Q?uXnnbACPTSBGUSWx2GgtQvbqEgy2bp1cIkFYm5qyNduH52BxTOcXOEb5EG4D?=
 =?us-ascii?Q?EpfyCXs7PAPtE6wpqEaB3TxLbD+G1FpQZNUgIryZwv3fhe+LUBCNDbAGcRT3?=
 =?us-ascii?Q?FTU0AMu3okd7bbm1ILSEr6XeYw4b6ks0dLiM4fG+yW956s3fesjVv9NcnHud?=
 =?us-ascii?Q?f98JyZae1BT2LLx46FHZ03PIA5YpNMID8svaWYHtnctggYdRBbOD/+4iOSn1?=
 =?us-ascii?Q?UYieamTbY9XG330NbA4sgLg1AuovbJF2rFdrtUaCm8J/2FEfYqIU/F+ySycS?=
 =?us-ascii?Q?LSv1htaYwhWerUss4qtXiEClPbVR/6f9H0JaqukbAf+GVFDKvrPsT5VDNhPh?=
 =?us-ascii?Q?g9ynf3Fjp6RD0bPt5mzTNJ6r4Ei7yo6hMBDPyNwaT5+Q0+JqbcQ9Moh9RfmC?=
 =?us-ascii?Q?naYu+2hV/J/zLV/jRz7UqftEk27cE3OSfZs6e6WTiBdUkD4mAwFcILWF3rYm?=
 =?us-ascii?Q?9no5P9ao+HpqZJp3tqDMmvlvpCyjadKMIoFFCMPrYBJNAdJYapfoBWR54pA/?=
 =?us-ascii?Q?pfwDjQZDeMNE7DKTejL54YCFkBSWn9mJf2hs2ksRgYn82ESNMNW+RvqNlLj1?=
 =?us-ascii?Q?eAtadBauRFIgXxFD7h9+lFCUe3XNTOhk4n/EIgNUtNcb3k3ug6l5gKhEf/a4?=
 =?us-ascii?Q?tcLbvSJAkmF7HtDCLv7RCy3xs7+wxphsbkYwCf/PJdBTqUmGN/rm5q8R3iM0?=
 =?us-ascii?Q?S0ta6Fokb3FPwmSAgwpza8sUTnugeHK0SFR7bfo50U+oxicZK4gstxULUT/v?=
 =?us-ascii?Q?ROdEPqZS5UxEQD2rqB6JzkRIjEe9tEKaUAKhmjJmNwHxP7p4rWu2mCNKymbl?=
 =?us-ascii?Q?csOgTqtRK8uLhhPPRpea4ro0PIYz/aDpOACcLYm4DFfAjI6s5L0C/FnRN2RC?=
 =?us-ascii?Q?tOR7hzB7RK748pnrkM9qBoWzIg5Ay+JUR/z3HL53Caji6AMOGTKMcXTXaIPa?=
 =?us-ascii?Q?UIL0GOZGa3uc00lcwhOft+CSvi14hiRxwtQ7Kod28Lt2KPo4N+EREe8cQzB/?=
 =?us-ascii?Q?6ZQSWQkYnR66d0v94eKhUG2l0Rt8979AdoR0qTHla8E8Xat/CWCvl9P6bmy9?=
 =?us-ascii?Q?uj9vJrOIUHHHtZzS/FPUF08LPnPWKPi4zqTnrWVQJimw5fiyeQzrDaGYW5EG?=
 =?us-ascii?Q?iiXKEuZsqAvcNWEUKpflRXSrgKehRIVAEW1ZDthZPfV0Kx3b7cxM3/l9GE0u?=
 =?us-ascii?Q?pX+j/hr+85Sgbmc+92BqE0WHjzahaiYvNb8UQinK89dK/5rFKxaixmDv3Or9?=
 =?us-ascii?Q?KMCOXJw7FY//aXowswAWTay+9XsjxIcnw16OAUuN6eIJ+aKQmnU8Ur6S+DVR?=
 =?us-ascii?Q?EMFLkO9RIaIgrzPmPQjdcstUVjCG/Y6r1Vp9hocS1EdWv7RHnwJzmNmhOCNf?=
 =?us-ascii?Q?o/+NCRqisnE1AXhz3nM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IYX8xDkrcqXzeMTpA0uMKrfxISgISoIftlRcL4IHTqzgcLJ+TNBAAznczX+O?=
 =?us-ascii?Q?+CfcJmMYqlqSORnBDsZGM1grS2RcKf5cppsCXGpTEXX+uMLbW8oHYbwLbt/v?=
 =?us-ascii?Q?UEmN4nDsmyTLPnCVnBjWJhUrIkVHmOz+Ie0wWp2vHSj351a7cGZPQLmLQnrJ?=
 =?us-ascii?Q?Q2yZoo/7QUv37/M/KCMZLDzU4w7RLztx86CPEG98UjeIAJ7f4II6yesa0woK?=
 =?us-ascii?Q?FOFlc5Q45AF9bdv7yqwIU/tKrRK/H4W+cACsT2vVGYwCvx6iGTVUK0FLZCub?=
 =?us-ascii?Q?RT7dkVpYdJj1XvckmAzp02jhwrLfU7XsOt6tpxButRv+GohSZslZDujv0wx8?=
 =?us-ascii?Q?8IkyLustW0neUdJ9PwMBSSsUxGJUt7cr/xNgTFuI92KYUBghnDkQIEyadkFM?=
 =?us-ascii?Q?LnxPf9tpJR+PlQRpRAKOlDGHezJvBe74tQm1ur0mrRzRkCTOAW3vJCjuFDOp?=
 =?us-ascii?Q?HVIV5Ig5bJZMcV1PReNFiJHaDg7Okf8HsLX714dZ443wlAMKtMDIUFn5muGG?=
 =?us-ascii?Q?sl2MViAzrbv8TgMHRKOiLhzJNuMpeUEgB5Tiu1MlOsyEZzBddbJPoIeMd5vo?=
 =?us-ascii?Q?NF0SyUIwug6F/2ruzziFmHQD1x0YfUBrM59rfO7xFKxK+cbd2gQGkaRWRTuC?=
 =?us-ascii?Q?wjESA7+tdf3JvLVvpsgOCIAm/xwG2QyJQUuv04zgpUrvDkJHcpT/2p+IsciV?=
 =?us-ascii?Q?k2hZLDWmef5dRzl7X/2JcFxg5Honvd2TWw7HO8lVuqPflCz2ITZDQBT2tYjg?=
 =?us-ascii?Q?7sl1EcxfE0Hc4SsPtiWmVzS5KWtWeQly8TQWKxGnMMjbXRvvyTXYsJFLbnKP?=
 =?us-ascii?Q?2A8bWtxEgUiOYlenfm7cyCb5sM2bzc+q3ialq2i4Uhrwa26VAogf8j+2H+9U?=
 =?us-ascii?Q?gglYcyZ2HHUOdG1TIPVmcOiCkw0hGT3faL0ATiekvHDnKYUPgF2/KONTlz68?=
 =?us-ascii?Q?1su1z9umpeFMIzB3qiRMsHkWIGwYOFptTRFe/CVOOXtinApFPQYkTzje2OOf?=
 =?us-ascii?Q?89UurP+J2t3vjxPHb0uvSb+KH7qqD3o8B7LTVj8Kr6imJJNUgRYnbw260mFE?=
 =?us-ascii?Q?pIkGzZG6/zKdwFwwkXFfVn6I778cJEsfhJ01gvSNMh2IdjJL7t6tcUHg4eKP?=
 =?us-ascii?Q?NzeGFRlsp+SXL4hwMfv6im+pTCcISlNwR8SgYI+/ZjocnA73ArKbOYGobsem?=
 =?us-ascii?Q?TpQ1qFce2nhCkcosH1wk/1togyvmsNsnE/vYwoDf6o5h3mXFM9+iqr5D/T59?=
 =?us-ascii?Q?YfY9Fb7YsGIC9fMs5z1C/MyXkXOxz1sPJubow1tVZeBNpRSXUspWrvrh5iPO?=
 =?us-ascii?Q?IQvKTkOSx+uc2b4XVjGWR8YjYCG0W2u0QWHxU0l+NjJFXl8hP8h5I45WPlKK?=
 =?us-ascii?Q?d0xwAjDGUin2z13Ni0satN95B7nAZuc5yO+l6zK5oUyMNTL7U9zj/i89B63N?=
 =?us-ascii?Q?XzaoteJILKAz8bRlmnOT0ynZfPVpFDz4VTvIS2fJyn6T8Pn/YY6iExxOxRxM?=
 =?us-ascii?Q?yTsr/KvdZwEAUk07Gxf23I9XZmdh/VUsKFhCt5YwDWZlOj88mdDuf/kg6Nwl?=
 =?us-ascii?Q?t0AVRPcHweDNrftaNrQtl60F8KJihOIJVafsLY9+Nb3meA3+/kRbvrJ0jX/0?=
 =?us-ascii?Q?uhO9k/4KC8txASPU9OBSrtOUmHRYV6ibPN1ug56f+hpa2sNTotdeQFsCQpAl?=
 =?us-ascii?Q?aLNDEEA2Pk2cOMm+HjOUW0KlD04StVjggqTILPqPvxSUaNCd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 656dc1d7-ce50-4edb-23f3-08de7359314f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 04:00:05.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Ocl84mpzDGA9GMbxOj4kOZ7Rzt9oTcBhfi6eGjxlsFkfE3m4vwOMSebxeczMMHe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9049
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: D558B40011
X-Stat-Signature: 4quqpnp6cpnnmf1chi9ksowree5qj6a8
X-HE-Tag: 1771905609-397673
X-HE-Meta: U2FsdGVkX1+Ub2T297VEuZvdseE8DjU2XpTVnvpbVsKNMndUtAx9nhiGFre0XD3FpF9W1xiJxGtfZGa4EZlXsBEIi4/r1srpF4YxvPYSbRhYaBg4yr/Ue59YGptYVS0dO9nLrWDiSY4LGXsHI3e7RAbDGQXYEKV7sYBF/sr2r/ueRk/za9AJcjrFybaTl7cdcdSGmQmc1BuZ0V5LwAPDFu1ayADXkBt1fOOhx1p+eNdYJM6adXu3Rtd5+E8e29+YhIbEuwIOQBLOO0rg+8tV2zqHbS1WM6c3XpUBudLVL9Py+3Sk6WlkR5PZX5QFgWRexwfZWkFxwp5epFBEgk5I2cOAru/OVig1DdUNn5baWiQ/bZcbNGsirROWhkk9of5FBsdnOEprTPB6Bqa0G4Wk+RqZ1mNpJKRLnxA5/vHW8SGlTj39bpdiDSTdkstr3zTQh1bD9aMvoN83lGLG9d8PRqsT5Gs3IL7BAyYEgRzn7CgNToVd1FFKT/jcsHwEz2nslnoViNIDL/wsWh6GsHkz4AoGC5/u3bWoJGxbK5wiM6h4UX3WzSc5eRSqzTuSnS34+2ZfU7EBxfAVbmucDch3alrNK5XJi2nXESSk2I7W++zKXSSRav7mPXa/zQK3qA3XyHAYHPybGFUjdN2EWQ83pCpYSFN8fqS+VzXhjslcMSsekHqJmyss7d+dwsGF84K38AEzT1n94+XUbRA+bbnsKKapT0FZeJaMuOuYJlQ5KBIND8d/kF6d13727w0mdAQVPGPk/N5x5+L9dqd7e+bmLPpitZeZ0YYkZLpPz4IXFiYBRQHDlF0lx4/x36CsaEdDsZXUHIhLycYE5eoianUPj2y33sqW7n+PxumsviIZIZCVEoXUfsRmtnmUJ5cMGu+QiejbJIQw/Utw+UMvt1XMUhJsGiimmHCOl8k2Ob2Zss+d+WZMbDELB0Fg4iN8ZdvXbxpxSwfLpEf+gzYobjZ
 YYRa/O+f
 2La7QMsiwyu3AyUXoFwdYqibp/N70fdOzP20RX9SyXZJhS/DjsnsSR4hNm4fUL9IwltBanXzrOYFqslm5Y6dVJg1YLBt5+GMmnlDn3CIlZHLYNbvlGYra4OD+9HNs39MjwQhY3y81NIKoVLC+Y74RsDrabYpT0He7J3OYWWgEHkEWHeDBRRwZrodgAIq39QoH+qTYRp/bRR6BTKcrL+0cKGYDPpPqhujMD+EabvFixAZPey+qjE+yxmFUYwIZag7Ues0zkhXOOieMpQeEoF/mw1Bd9Zljc+S9+t3w9iiF7h5QJ1dmLaOln0Y2eBpmdthVayMvzWvneUedJnKkFW9d2MUxAMHWJINCARoizRnfR064vCXcPwWFJpOZsQDXXQWLrjKx50N8GEQ7zkR54FkfmHuV/PztXWm8N2v5uUXfnMgWxfGPhs+hy65DH7GXbn2qTTfjlFF6PDax0+GTIpKXQ4ekIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Feb 2026, at 6:59, Wei Yang wrote:

> On Mon, Feb 23, 2026 at 10:23:11AM +0100, David Hildenbrand (Arm) wrote=
:
>>> BTW, in the folio world, I do not think it is possible to perform the=
 aforementioned
>>> split_huge_page_to_list_to_order() pattern any more, since you always=
 work on folio,
>>> the head. Unless there is a need of getting hold of a tail after-spli=
t folio after
>>> a folio split, the pattern would be:
>>>
>>> tail_page =3D folio_page(folio, N);
>>>
>>> folio_get(folio);
>>> folio_lock(folio);
>>> folio_split(folio, ..., /* new parameter: lock_at =3D */ tail_page, .=
=2E.);
>>> tail_folio =3D page_folio(tail_page);
>>> folio_unlock(tail_folio);
>>> folio_put(tail_folio);
>>
>
> Missed this. Agree.
>
>> Agreed. Maybe it would be even nicer if the split function could retur=
n the
>> new folio directly.
>>
>> folio_get(folio);
>> folio_lock(folio);
>> split_folio =3D folio_split_XXX(folio, ..., tail_page, ...);
>> if (IS_ERR_VALUE(split_folio)) {
>> 	...
>> }
>> folio_unlock(split_folio);
>> folio_put(split__folio);
>>
>
> I am afraid it would be complicated?
>
> Well, we don't have this usecase now, could decide it when we do need i=
t.

The patch below should work, but for now, since we do not have any user,
it is better to update the comment and add a check to make sure @lock_at
always points to the head page if @list is not NULL.

=46rom 66e24e6cc4397caa134f5600d22d77fdb9b58049 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 23 Feb 2026 21:59:18 -0500
Subject: [PATCH] mm/huge_memory: allow caller to unlock any subpage of a =
folio
 after split

Transfer to-be-split folio's reference to an after-split folio that calle=
r
wants to unlock and put.

Also let __folio_split() return the folio containing @lock_at for caller =
to
use.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 65 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 47 insertions(+), 18 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d487649e4de..d051d611c6e5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3768,10 +3768,9 @@ static unsigned int folio_cache_ref_count(const st=
ruct folio *folio)
 }

 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsign=
ed int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+		struct page *split_at, struct page *lock_at, struct xa_state *xas,
+		struct address_space *mapping, bool do_lru, struct list_head *list,
+		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio =3D folio_next(folio);
 	struct folio *new_folio, *next;
@@ -3855,7 +3854,11 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
 			folio_ref_unfreeze(new_folio,
 					   folio_cache_ref_count(new_folio) + 1);

-			if (do_lru)
+			/*
+			 * skip @lock_at since caller wants to unlock and put it
+			 * after split
+			 */
+			if (do_lru && new_folio !=3D page_folio(lock_at))
 				lru_add_split_folio(folio, new_folio, lruvec, list);

 			/*
@@ -3898,8 +3901,17 @@ static int __folio_freeze_and_split_unmapped(struc=
t folio *folio, unsigned int n
 		 */
 		folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);

-		if (do_lru)
+		if (do_lru) {
+			/*
+			 * caller wants to unlock and put @lock_at instead of
+			 * @folio, treat @folio as other after-split folios
+			 * by either elevating its refcount and putting it in
+			 * @list or putting it back to lru if @list is NULL.
+			 */
+			if (folio !=3D page_folio(lock_at))
+				lru_add_split_folio(folio, folio, lruvec, list);
 			unlock_page_lruvec(lruvec);
+		}

 		if (ci)
 			swap_cluster_unlock(ci);
@@ -3925,14 +3937,13 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
  * preparing @folio for __split_unmapped_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains lo=
cked
- * and others are unlocked:
- * 1. for uniform split, @lock_at points to one of @folio's subpages;
- * 2. for buddy allocator like (non-uniform) split, @lock_at points to @=
folio.
+ * and others are unlocked and the caller's folio reference is transferr=
ed to
+ * @lock_at's folio. @lock_at can point to anyone of @folio's subpages.
  *
  * Return: 0 - successful, <0 - failed (if -ENOMEM is returned, @folio m=
ight be
  * split but not to @new_order, the caller needs to check)
  */
-static int __folio_split(struct folio *folio, unsigned int new_order,
+static struct folio* __folio_split(struct folio *folio, unsigned int new=
_order,
 		struct page *split_at, struct page *lock_at,
 		struct list_head *list, enum split_type split_type)
 {
@@ -4052,8 +4063,10 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
 		}
 	}

-	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, split_at, &=
xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
+	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, split_at,
+						lock_at, &xas, mapping, true,
+						list, split_type, end,
+						&nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4100,7 +4113,10 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
 	if (old_order =3D=3D HPAGE_PMD_ORDER)
 		count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	count_mthp_stat(old_order, !ret ? MTHP_STAT_SPLIT : MTHP_STAT_SPLIT_FAI=
LED);
-	return ret;
+
+	if (!ret)
+		return page_folio(lock_at);
+	return (struct folio*)ERR_PTR(ret);
 }

 /**
@@ -4138,9 +4154,10 @@ int folio_split_unmapped(struct folio *folio, unsi=
gned int new_order)
 		return -EAGAIN;

 	local_irq_disable();
-	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &folio->pag=
e, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret =3D __folio_freeze_and_split_unmapped(folio, new_order, &folio->pag=
e,
+						&folio->page, NULL, NULL, false,
+						NULL, SPLIT_TYPE_UNIFORM, 0,
+						NULL);
 	local_irq_enable();
 	return ret;
 }
@@ -4196,9 +4213,14 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
 				     unsigned int new_order)
 {
 	struct folio *folio =3D page_folio(page);
+	struct folio *ret;

-	return __folio_split(folio, new_order, &folio->page, page, list,
+	ret =3D __folio_split(folio, new_order, &folio->page, page, list,
 			     SPLIT_TYPE_UNIFORM);
+	if (IS_ERR_VALUE(ret))
+		return PTR_ERR(ret);
+
+	return 0;
 }

 /**
@@ -4228,8 +4250,15 @@ int __split_huge_page_to_list_to_order(struct page=
 *page, struct list_head *list
 int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
-	return __folio_split(folio, new_order, split_at, &folio->page, list,
+	struct folio *ret;
+
+	ret =3D __folio_split(folio, new_order, split_at, &folio->page, list,
 			     SPLIT_TYPE_NON_UNIFORM);
+
+	if (IS_ERR_VALUE(ret))
+		return PTR_ERR(ret);
+
+	return 0;
 }

 /**
-- =

2.51.0


Best Regards,
Yan, Zi

