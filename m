Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D1AF364A8
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A3B6B0088; Thu,  9 Apr 2026 13:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F258C6B0089; Thu,  9 Apr 2026 13:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5CF6B008A; Thu,  9 Apr 2026 13:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C77A36B0088
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:34:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A43254A53
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:34:05 +0000 (UTC)
X-FDA: 84639715650.17.6B23703
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010007.outbound.protection.outlook.com [52.101.201.7])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9437AC000F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:34:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kRHyD9iw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775756042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCT4CE2DbjIQjTKRTZw0BieD0HUYD7ay3+jCsU9I4uw=;
	b=td4A8QjsbRSJXsRAecJpFJOK1k32eZpUxeMH2jIVlNtuezWGOnr8PUamWFRv5yCn5weAZs
	Mbg2aZ0ZWtXNudsB0+SHtZ/DuLhPrtVMGsdVDHwqJ1UO9mn6IheCYbBzXBhrjcuF7NucnE
	Qgc/vRgR1MNpsa9hh297gsW0p5Asj4Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775756042; a=rsa-sha256;
	cv=pass;
	b=0mZGeklqy3nn9SXGCpteMS1cCKec7praK/i9S7z5lZwT0mABzmTLqZ013oth1mFwP8Yd9a
	I9LI+kAqug5VVgqHhHLyhQTa/fv4fq6Y7ttLaQkqBL/vDTiSE2sQNZ1JuIy/Fsup8jTX6r
	aPuaDosim4Jpo7ng4aQHpkYr7lhH5ms=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kRHyD9iw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNDJAQk2Nx8ZkfUVRKficFdcVuzpFE7rVW8gPDXKnY2KiGTj4vHIbA6IgqlIWk8X6co6LOsxe+iwd9bDJXWnp3J/d/nUvrEMsiEz7n5Lrc+rqvUlNMeEt272CFPcN3oSyradaez5+adZss+f8V13ukTjP2G1K9cJNlHtG/3PYTNHlTdSxuCizS/6N/+IPolp5o04hmLCwynbodK7BL5HgpBA0cZRN57ePrFab7StXr9KOJyIpbyNSfLlBq243g/9fCC4n6q+vmg2SmL1ff/KXqDmXrEDOOqkcAB/FuUof+MNkvV1UB8ncgQZQo25PUfNkUA8EDNF8CWnu8Y7IrohcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JCT4CE2DbjIQjTKRTZw0BieD0HUYD7ay3+jCsU9I4uw=;
 b=VwmnL6f6G74HL+2pvvoyDM5+Af0vLt0YtXL89ungRXwy7FjQZ3F3QisZalK60Yg8yb5UDcFCUcjBIS7uM/sLXIbCpNMEyR6+Z5W0pa0iQnzpdDD2lISLcF8+LngMDtizE0vIJtroBJYc1wuAxZrOecxTxfwruIHi3Qjp+fpLMIt3ZiBwhJDYgZzzxsPwWyTjV3GXl6LWL0blZG/mZk277CLaN8JZP408XGfUdwCLpgzSVo7X/uXDdD1W3qXGOCwjr5fnOlprKueEK+6OArNUgA9vVMB6bETugmVjZu6i5ageuFa2pugmWuMedOo1AqD/nx79Az4ZSWhlEmdI9zK6Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCT4CE2DbjIQjTKRTZw0BieD0HUYD7ay3+jCsU9I4uw=;
 b=kRHyD9iwf+S7x0fuWJ6Z/KCVDrMTVFry/DE92wZ40irh+OR56WaZ4NOE+tV7xvIGr5d5/iSCdsujUXBC0c0d0yb3mjR5vmjXzHMVcV1Ww4UP5FsUaj0+7I9nE+zdlks1Bk6GA7bZ3Ch+hgyC4lMmj5g3EIm0wyUHGk/OjF4kQRfdb8sWsXHHKJe9rzCEXxtsLrdg0U+qYZADdw0hh3HLRrh9pvQ2WCSUqok7ddAcHeikw1zc2QehGelXAV1h8ACM3CnDKs5BhPRXF9fAPxH3XjaEnvhjyZVA+ew2ZGEMmXlRsPb7ISKnlKBPDvmmfAV+03AzNJJ0ixOEF5F205MOww==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9561.namprd12.prod.outlook.com (2603:10b6:8:282::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Thu, 9 Apr 2026 17:33:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 17:33:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Date: Thu, 09 Apr 2026 13:33:48 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <FF3A2716-C343-4F87-AB5B-D4D572972CA9@nvidia.com>
In-Reply-To: <794e7270-c91d-42eb-b2a6-67929198a1da@kernel.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
 <accf843b-ee4f-46a2-b187-a6d8e4115ca7@kernel.org>
 <1A7433E5-C8C1-45EC-A0B7-2BDC7D065B1A@nvidia.com>
 <794e7270-c91d-42eb-b2a6-67929198a1da@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9561:EE_
X-MS-Office365-Filtering-Correlation-Id: 78d5e973-6e2c-4a87-6c65-08de965e2aa8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CoFQwuElQ6wX+R4XT6i//Nsw5LDfxTtiWsCEcbxX9kyLyO2xzsDhrfM8UoRV7V5Vq61LodoVbO5SfqMoDxLyEfYtJ1GT8wdGYVH1lJtw2CPNwSzL0MceGs8yQ7B03e2JOzb8CGrRfBcYqKjEK1fMiLNGQFGr2ZMeIA+E7mjH6+yDpK0ZqAQQtyE6yyLaexMA/iqGiQ22m5LqJQoDUITztUjz69s3S+dTPXzYVH+gCYmJc2WTkrQEmjWDqCJKxTbcwZF2HPqctIOvMIGEx/umzKo30cPWC0+LKoXxJujyyGk2f+ZCAAJSt7KADqD3xrJ4bjjTOQLacaEHL2L39tWr+mzRXPknfbOu17QQ8KpaB3xZE9yzscfardADCyW5L7/bYuo5EyFQSZwlGJowWFkIQkk8dYUuGrBOD7lnmFg1wYhQMArKZ21PLlYDLwT7ON8Kvzb6Gqtfxyqm/Mhy+lRqZZjSSMNJkbyi7TdLfJ0KReTTyEMDC8GTRNK2eNRlcD62FrVmewiPQiAaSuG+sETQ10xR8N97O9XOyeWODjxqtI9Fuyjxo66kzh/wmV6V2GvTmB640mWpNb5o9hlxTY3kI9zP6RUgs9Cmmkf5CKuWiZtX7kyTJGFiEWK96n07b6RH6Qx5pNI1YvgKmp7I3QjCXgD7cSdfpp0a1V13splWG52kwzdUC9dQlAnkdMjTJt7pmA9IYVi9P6nCqWKk1l5/elrgPMrKKc4EYhEVH0mcr1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rv594WJT8Lc7OgW8jWkiTs+EXuqVDFH/DqtK/Bk7oXNlcK9ULB6oahArm7b2?=
 =?us-ascii?Q?EFyDLnHblUi+SiQVWUCduxvNbyFAr3MGLk/pOX9iDLG7YwR10rnbPENy2Qqr?=
 =?us-ascii?Q?mG05oZyxePcvKzcS3vMeglps3DYcjGlGe28aznUv1ym7RVDpvQYJl6JURTbw?=
 =?us-ascii?Q?jrUmq/rZS3fj0ExGq6aciwDrBCkDq7wVaaV4Tu0CHnE/cIcQTI+LcubQbUOq?=
 =?us-ascii?Q?mbVbB1s44kURLlEgfAEqwtyXmmhvIJwf/gsbsKMxXaVRz3KPychHDnS5OcQB?=
 =?us-ascii?Q?EQcbVwdw9yPm+g3YWZtMqjV2Yffhx9QPNhiG3h212rqTTsNoqt8axPtSDs4r?=
 =?us-ascii?Q?nlFzYThB9S7m1X8kzc9r9nf2zagBu+dFRPe8t8A8dyx+uOW2kYCV5fHHz7ze?=
 =?us-ascii?Q?LhYXf4FN8TQlP8LeGoLYEffufmfzjP6jD7agCFLCwHOA31QbyqbNjI83MyU/?=
 =?us-ascii?Q?ULok9TbmHRV0ihwXUzeAcDDKJknYeF+awOcanebWSfr2wFmsh5ZbBxprslOC?=
 =?us-ascii?Q?uCJ2PjDbcEhcOzC0+PWsGR377PvdvRuwtQN3fmFZfISlc/DqFZnxnfz767AR?=
 =?us-ascii?Q?HsG27LA4geydGRD5IRuLDkR7cTSwjJwIBpd7xkAnSny1/8UJ7UyU1NudAlMh?=
 =?us-ascii?Q?7gSSfMTrBg4vp+UqmlaTfWLUWMDRmLYy5Pm1Gj7FYjjZfBomuDBB0pZIKhR8?=
 =?us-ascii?Q?4HU6TSq3+Tksw3rEEUS4krPjIg4AOPAcJSVGRUCZP1Gzb/pkVpDqsivv81/g?=
 =?us-ascii?Q?7qSxwAlE1pbVfjpCN574pzvzzV+5wljA5WD7Jf238QLWSTBSULQ+mmuGoeAw?=
 =?us-ascii?Q?iRoKl15R8WS9bJ+LK+wz5H7ITdppmX0LyAf9P/5OnrvbUjbl5efmsVjkr2WP?=
 =?us-ascii?Q?A4JUX5CjPvOWgEpr2nB/7OOcn9eTQyvcSLO/lf9UG2Rqp8x/cHdH6qpIg5Sl?=
 =?us-ascii?Q?yXQgwbo7tQzD0U5Mm3Gw8FagytPxu7HFA732Lms9NSBsdn/k9SpuTbzrXLJj?=
 =?us-ascii?Q?dJAbXdb9WKTkOBeE1VWTY3Ewf1jpV5v1zcGsznhqQPA1l5TSoqmxpjBNW2o5?=
 =?us-ascii?Q?/pOihztXlmc5KOUuWMHXOVppc70AxkBOuw7YLmtI5SxcMkdzEpB6B3jz5PGT?=
 =?us-ascii?Q?YGzz7GkKW2+nKtg1kJqwuVx2JNjK4Ev7B09KxLPBGa+qslWzwbGthYfyP6U8?=
 =?us-ascii?Q?NTWyO9PEvsXwSWrMW93RgMF5QPsfR7wuZ1N7zNWpTISJSEDW+IHfbhIwUKlN?=
 =?us-ascii?Q?1qy/Ms0Css2E34uLNHXtSzIkVPrDpgMaoAiBfgEjJPeHe/uYGjaT98DSXGZR?=
 =?us-ascii?Q?FJTubbLp29tDEG7inERKApfnDqvwEMLXL0bKMjYQBsKroUSakpxSQh196OC0?=
 =?us-ascii?Q?9b+EUBaBezE9nHWLLrd7GRGC8bHuBdVMjs9nsVQnoepIJGq/3MdQnrcaAU2R?=
 =?us-ascii?Q?V1i8FoPFBRBn6V6UI3XZ4dm0Nd1wxphjuT5uZ9i5zSq1njnK7+FfErq4iGvE?=
 =?us-ascii?Q?K2cen1HGphTaCQsBA6KG7t9WdXIKlcBJXwkd2ZXaAdpd2QIe6+4FqtBMRstU?=
 =?us-ascii?Q?JwSBHIWQ2s78drmEeOOD+/hW73cTIpDGUah68rPuRcFicl/Gbe5pE8gB6HR/?=
 =?us-ascii?Q?H36UiD/Au2Xu6JIzWNwSC4FSQOk4uJg7ZoEQYQze1Z/LCHtqwWEJFhNyvyyr?=
 =?us-ascii?Q?DDbhT9xDTBH5suCk9tIfQ1PYxkBrVrj5y3ey3rbupNgpvauWyVhyEJGCf+U7?=
 =?us-ascii?Q?G+LdrdLfkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78d5e973-6e2c-4a87-6c65-08de965e2aa8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 17:33:52.1606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: of+BQSxCPqNTt0siNIbZU8AiAjon6b2u25RW6OC9pt1E0vWeFkjjNET55ayuwBDG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9561
X-Rspamd-Queue-Id: 9437AC000F
X-Stat-Signature: s8oawuwjg7wapuocwiq9byunetkjaqiw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775756042-596486
X-HE-Meta: U2FsdGVkX19Iymt3ssg0IcM5RpTJeqBLc4GctaBNNzEVE0ZqSED5MQQD0KrM/UPtPtJhogjNPlDL0M1giCHoxxpF7gSSLHzQbW7epJIohzZGkQoCZyWCoKw0ZtW0wM8Yeg9wKM6Wf7Vj3OS//TBym3KfPf64JPDPFdbxId48keMMYiAzrBu00/idwDf6VT5IOhXl4mMi22B7PCJSDuq385uRBZSylfIL5oXDL4bSfLXGajZFbUjaCRvUfucu8Fm2TaOkFeVELllfdRcbCEV50kk9agVcUHyAH9+rxWmxRJOWgEB0Hifmfr0jv6/SXhLQrQT4wVRFRrTGYgFsc8z/JHdu4XZPNZLDOwqh9FwIpU1LOnZebgcrbjmjRmchrMbPkQ+eRqgTIchSSdFDIXtiHJ0FIeqhKDfk4mVXySC7xFktvpZSnYXbKI6AhdQ3I2EcYuMOZWptP3eXpgGCDtleBJRg9gqCKjvdPqNqJc9V2nquxctvCdxBbPIUtc7GaKETlarJLTpePv3oK9vj5JPi48aLVRzk82LONvwSpIjkf8hkzesPKFp0a8Xl0XCs6FbVqK/WrMmnIjV/AkrO+qbJ6CynmAgL+Ivj5DDJWPCx4TqP1AdJQw8iJ/uv0iN/n+JTFRl7rLSMF2qPX2PN2D8/U3z7/wUDhaQJcpQgXARdwxownx09KWGOtVW2iNgnjm8x0J1giZeSC6EP6RWkGOjuvJTm7P4kmnwT9lMTBhS6d6PvXzy7QjH6HDCzpjV6hNUpRD6jupMIU7yNDpAtvnys9Ahm812Nedqm9pdbmormsTD3qdAM4/W6xW8mjbeVmrY414++cnZKIMt56BOAOh8Y2Hn0tHGyMbkD88LRbXBUX8w0yH0QgYFKt/tI1ZlcPlkt8Q7vIMDcATpjmiZi8CbvmA3OO2Vux4u+BlaIZFtASyPPifnRP7ZWPkzKJubRZftrnWOv17vY/KKo+S4XbfR
 CNvuXfrb
 SAdhq0GFUsnn6dDEVZ5Ra9O3m/qWdeWr5k2gOzuz/8YMEF6rsOJA6bI7oJbOoP5KkpGWZ/3/cHJ5Gkduz/s7YMacTAaOpvJzbW8b+0WwAA+cXo73f8DqryxGakNDozKotiKb9scG+nSzLuVzMyoG3DQwrI3VNhOgsljQlHMHZbBIWspS1XVMN8BPE+dEIomxWFinpi1wmJx5H+ZkkvHrcU3hVYMESsddJ/idy28/dRwmvGi4WWQgiqvSH9OW0zrJpXAtWr0moSDMjGiJlDw5Tt5Nxd62NYsO5Ztw3ON/njQqle16A+8lLhpm7JAi3P50cu1KUHfotF5dhqN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Apr 2026, at 13:31, David Hildenbrand (Arm) wrote:

> On 4/9/26 18:55, Zi Yan wrote:
>> On 9 Apr 2026, at 11:11, David Hildenbrand (Arm) wrote:
>>
>>> On 4/9/26 17:05, Zi Yan wrote:
>>>>
>>>>
>>>> The idea is to give every allocated page a NotRmappable page_type and
>>>> 1) let page_rmappable_folio() remove the page_type by setting mapcount
>>>> to 0, since page_type overlaps with mapcount;
>>>> 2) allow callers of alloc_page*() to change page_type from NotRmappable
>>>> to other types.
>>>
>>> Could we instead just set the special type in vm_insert_page(), after
>>> verifying that it does not have any other type?
>>
>> You mean in validate_page_before_insert() we set the page to NotRmappable
>> if it can be inserted, then in the rmap code we reject NotRmappable
>> page/folios? And NotRmappable will remain until the page/folio is freed.
>> That should work. So the purpose is to avoid setting the page_type if
>> a page/folio is never going through vm_insert_page()?
>
> Yes, only these non-folio pages will show up process page tables.
>
> We would add a safety check that the mapcount really is 0 (-1) or
> already the proper type (NotRmappable).
>
> Rmap code would then simply skip any such thing.

OK, I can give this a try in my new version.

Best Regards,
Yan, Zi

