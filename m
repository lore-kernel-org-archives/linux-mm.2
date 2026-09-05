Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC5EC79F89
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 02:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0566B0095; Fri,  4 Sep 2026 22:45:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1715F6B0096; Fri,  4 Sep 2026 22:45:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087EA6B0098; Fri,  4 Sep 2026 22:45:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9E106B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:45:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38EFD1A01ED
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:45:11 +0000 (UTC)
X-FDA: 85178166822.21.2EC73A1
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7349F180004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 02:45:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=my10TE+8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788576308;
	b=e24JWSZK620hDlvrnWfDK5fQEUhKPrIZS3IqUieM/lifULkIgGU1YAmVLP3IzD/nc/4Mqs
	2PsUXyDvBabWl31Nwjgcm7/VBm40MXz0lV6XzHOyZvMUV0x0QNVZywTEVUeuEA3h5YgeMz
	m+rozVxFe4h2FtLEYnMvocvgkYPpNx0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=my10TE+8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788576308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YdiYCDW0ds85cdHpCtFo6bH34eI4T8Bz1wBZJRlKbM=;
	b=MxfWkq7sGZVBxwzNjU3lgVg+jpLfNhd53iFyncx23Zd+irTp/2ZiPuERVI/ra9Jwk6WYFS
	JY9PnhCyikUJ90LsuoGBwGkeaUX350CfSaWOHaiv9mey5UWoAceb01o4P+fbLazTLFIsjs
	92v50dWXnvkCJOcC3CtdEzEBror+lVA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCU4sinYV5IiOtGO6CZza341n+STzU8NM2+zvI6VoSvfHsub7z2ZBDp0SsZrQH+uaq50Wej/cTlazDyaJLbR+idBiBTLwLe2T6pHRA6afO+AjoZWMwUDRpzCz2cMhut4sasiZTkDEpZJbAZWDpTW7v20RSRfpRt6Nap2c1FfXdi8FLdccEXoxX38QiqKeF+2fKixf8N9yoqacCgmpgPTIxRcsMtBC39UgObKF41F7PZArFqgxIaZUNd4pJcAtnaDUxEyRSYNtTNoI34K8xaq0G7V//Wq7GH20xkpel1Um8rsTGuJF3YF57wBVO7o+2cZiHxoGe3fcRyrhGkN24q/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YdiYCDW0ds85cdHpCtFo6bH34eI4T8Bz1wBZJRlKbM=;
 b=pEkkQxULwRQwqXwgn5Cs7J1c+/PkkF7dbv/c5F9sSO0brnDN1DSAiD8dchUbXYn47EBPV7NkWgiVNOySuxdrH92/XHv0phPMP8OTEQgGu2s36j1x3e8foc86LpuYy7BY5Evub6jGVUwu/2kkRVD/m8nrhGbQkqHFO+olern4XPeLdKod7SldDjRBOy+Q8FAGOoUlKfOp2Kpz0w/BQGjpG1wrf4ProF747EVjfsGn7d6zS7SjX9YYEMEbNypWkSqbO3vrOid6No9qIGKWoEEPrmKQBMzIQTpUdxiYrjETt4ohlrbvaNgdYXZO1y4qnbIKsNqpQPrhr/9J9Ow63GPqHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YdiYCDW0ds85cdHpCtFo6bH34eI4T8Bz1wBZJRlKbM=;
 b=my10TE+8eHvya81QJ8U1AhnKmNz5zSDIZKI6gTH/WaCRPlJpAKS7NDRrnwhbZwIVgUc6hBmAB4iJndZDx+Yc3WIR3IHiR1A16VMw3FfNpOVp/hYaxhJ0UwzZTNJ+JZy6m4q9FSFQsFX31/Mf3gfOe8R2sOcshjaV+aXjO0eW26TUgAwJRCEDaHJF2Ypvwp4i175SMony0NYdTy/IU/DtVCqU7Zojpx3DkBTGGEm5XiOAf2+tWAVNOY768Id7XmqN00S/XrXF3dYZ7m7hUQigHBHCKkbret3tGaSijZMYx7jFBHDuMA2Zbo/7zojqnmtVjG8E7RQOtP+h2KSzbzYkWw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH1PPFE5ACC0FD2.namprd12.prod.outlook.com (2603:10b6:61f:fc00::629) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Sat, 5 Sep
 2026 02:45:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Sat, 5 Sep 2026
 02:45:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 04 Sep 2026 22:44:58 -0400
Message-Id: <DL71DSES00K6.5JMVM0IJLPHP@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 05/12] mm/collapse: state what a collapse may do in the
 policy
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kernel-team@meta.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>
X-Mailer: aerc 0.22.0
References: <cover.1788533997.git.kas@kernel.org>
 <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
In-Reply-To: <b01681c3cc945a7f7c3c7ca1de502f7cc0e93fe8.1788533997.git.kas@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0267.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH1PPFE5ACC0FD2:EE_
X-MS-Office365-Filtering-Correlation-Id: fb90b19c-69af-4dec-faeb-08df0af7ae03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|10067099003|4143699003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	1BIL/gSwww0dzMy6qQ4m/rCPwrO9q1JIiouon4v8KwbiL0qG2noa79nMmhhdQbqvXc5pdQJCfPzz5OPP9YD07MuwAqbiHxrNMeZrUXPDw97yZupSmwQqNY2ViOkeG4WWBYSymrGTEJugp8srv/HNZOCDdhnfYuyLuhslEWY0oAYUQEt61OLRVdCfIl055bHBl7a2Ye2cZ+CIg82A9faLCtsm2GooBA9gfKf4ze+CVf8WAB925nYquTglnZ78HWqy+BYwLaFfHRgPbfwEdPPXWTfYX9qxJO2VqkTxNhfbAamNLf2zhRUG5e3sIG2hzLzmwaF7cQ+2dYFIhBPBmBEley7n+dm0SaqxbEAxxV1X3K73u4q9fuvqRWHmSWnHAdRgryfMrN77jydupfr4cWo9xP6MAQiF2VGgynrAtBJaPA5zn6ZLnf2s4x5BB+7vSdGNWrib8aBwSwUdmNYnxGo+XTskqXWSNQJCmVxnYoG9NDxsxaXIK5TBbwfD9I92OsOy+aaWfsKsJTb28VnL977BnL3jEm7wp7QnbG0mxCqwB1GiCdmpHsCmRyCTURzReK+UST180gozsxENgF2Lj5xprJ1C2Qaz+lSyeXfZityCce49Pguxg4rgZFw9S1b13cDnOgyRu1xNk3/bksr6Y8dHKgrtn3bCWyRxnTrzbPZFlJs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjhNYVpqaHA1RXFNcUgycWtKZlltTUlIUWxqK2g1cE9RTFpZSUVyWCtLcUwx?=
 =?utf-8?B?R084L3BRMzhHRjhtbXJnaEJvUkVLOWFJUTJGMnlFQ0NucXBqQnFIZUZyNzY4?=
 =?utf-8?B?TUhJc0xZQmVTTHVpa1ArQzRONkJQNkxGK29pZnZ1aG05bmk2RmpXbDF4SGdl?=
 =?utf-8?B?WnNQRVppeWgvaTQvb2xUbnBGWU5ZS1ZuNTcvblJSaWdrMUJ0SUcvaTRjY1FH?=
 =?utf-8?B?eVJvTzRmVWRTZUFiZmxpL09WQjJQaFNuQi9HZTJKbnU1U1dDOEdlOFRmQXRt?=
 =?utf-8?B?ekdab1NJMjZkelhudy9jdmJJbS9jZzRkcjBobUx5QUl2NmhmS2Q5T0xUS3Ur?=
 =?utf-8?B?UEFYOUZmV1JTTnZFRm1xOGV1Y0RJRGN2eG1XbE1kTEZxSTlNUjJUTlpCazJH?=
 =?utf-8?B?NHplcU5Qb2hGOEtWMEQ2ZHdkY3pTa1BkWjg3WnVuYlJjZVgrRG9SQ2tHY2wz?=
 =?utf-8?B?OFlXVFZUS2ErdG5taC9pMkY2U1l3OWpQODB1RFRsRXFsL2RQQ0EwaGtLdnFI?=
 =?utf-8?B?OGhvKzFEalhObTlhbW9IaUFTSitWbnJWUUhRZSsxQ1ZqL0U2Mk9YdjdEMmty?=
 =?utf-8?B?em5NMnZsWGYrM3ZwZklVcXpsRjNaUmRvbUhIVEpSZ3ZWdGpCMndNb28vQkUv?=
 =?utf-8?B?end6eVIyMktSSE5lek9xbzgwUHNQMkJiaElMRHF6OGtwSkJsN0Rrc3RiVzYy?=
 =?utf-8?B?VlR5cE5kQnM2T3B5bjJSbndJdWt2c2d0VVNuSDBjTFZIM3BmN2duNk1TZ2ov?=
 =?utf-8?B?N1MwOC9jTnZaTC9MTmJ2VklRSmttZDd6SUxIaGhjY2FvczhjNjBUbFd1ME1W?=
 =?utf-8?B?c00xZWFzbTd2ZlBSRzQrUzltRHVkUWFlUWU1VVFjaHRqdWFHRzhWY3VtTW5B?=
 =?utf-8?B?NXp0YUJ0bHd3UFZTY2JEQjBIbEY2YUxKM0MxUEVyU0E5Vi9JRTY3ckhCTXE3?=
 =?utf-8?B?bUZkcVlGRS9aU0V2RG1BRTUyNkNYZ1FBczVmMzE1Y1lxZUtUTVJpRU1DeDhM?=
 =?utf-8?B?WGF6TFl2aks1U01BZWpaWFVwSU1wVkJsSDBOVkdCbSs2YXc3MGN3M24rRFVM?=
 =?utf-8?B?Ukg5QXZla2JhK1VyeWtwWXNxZDQ1RllDYWFlUDdsZFdqWjBmUDRqaGRqSWxX?=
 =?utf-8?B?VGE2eC81VHJIR0orVVlhbzR5bmVKVWcwZWJkczBrNEJPdFIrSVhSNk1sYXdZ?=
 =?utf-8?B?bnZJZW4zU0VpVzJPVVFFa0FWazNHYnBvdTlTV2ZsUEVsa3AvY0R6S3E0SE00?=
 =?utf-8?B?cU44U1hMeUZCRUMxTG1iL0xDa21RMEwwendJNDRaNVZpLzRScUF6Z3BINlJm?=
 =?utf-8?B?ckIyenBnR3UwQ1V4Z25Ockx3ZnQ4aEhndjRJbjZlRWx3NVlYcS9uQ05NdjIx?=
 =?utf-8?B?d2RJUkRRVGFsc3YzSm95Q2xwQUdQR012RDRVQWxEQlVTMWpvR013TXl4c3dB?=
 =?utf-8?B?S3cwQkozd0pEczRtTko3VWdnVlFEc2VNM1JvNGpON2FsSHFvbXM0WXRHOGhu?=
 =?utf-8?B?a0x3Uyt6MzMwZlU1U255WG9BcG9oczhDS0g0VHFMdjlkL1k3cXBvdEJ5T0xq?=
 =?utf-8?B?TjZDOG5zRFhHOEhrWWplZ040cmxuQ2ZGeVJsZmhJTkwyd1d4ZXg0NVA2VDRu?=
 =?utf-8?B?RllzVVFYY0NUVDk0cC9GL1JjdUxnNW1JUGtZc2R1OWc1bllPR1RvbDUydnJJ?=
 =?utf-8?B?b1FNMUlaQWUvYkc5ZzNHVDMvOHM0MitwVXlrVEV6R1dad0U5NURGTk5lbmxa?=
 =?utf-8?B?UDFDeGxYTmxCdElVRzFtcm9iRkY5ODRKQ1k2S1BjMWxlUjkvWG1nTkZXd0tB?=
 =?utf-8?B?dTNmMlN2eHZMblI2VzRxbnlmRiticE90M1VNOWNMbXpGdVdJQTlGZ0hoRmlJ?=
 =?utf-8?B?ZlFEMHo1R2ZxRkFGRXFwb250enh0YkNPaUQyLzN1T3JiYnFaYUZtdEZkSkdW?=
 =?utf-8?B?YmhRSGJxSzdQeFI4cWNkb0p5dUs2SHhXQmI2OGEvemt3dC80djVhSVpkRHVK?=
 =?utf-8?B?a1JwZjdvdU5uaG9zbzdscG8yWXlXVkVWU0RwZjR6YjBXbUtZbEVTbjRJSFh5?=
 =?utf-8?B?UXhRQS9BNi9ZT2REYUU3NmljTFZWSVBlUGxPSFBUZTdhdXo0Q1cvRnB1QUlW?=
 =?utf-8?B?eG9xZDRqQTFkOXREUy9Hek5OelpmekNxSjI3aytBSG84ZGVmeUZYT2RWSTQ5?=
 =?utf-8?B?dUE1QllYZGdhVDUxbFYzQmV2QVpVVDlKZDV3TUMzbEhwNWJNdERTSExLb2tB?=
 =?utf-8?B?c0prZDE3N2FPbzBwYTVkSE1sQnRyVkJmTlFYdkliUWlLVGl2VElPYm9Jazk2?=
 =?utf-8?Q?IkRoKXNHVPsuQcl7La?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb90b19c-69af-4dec-faeb-08df0af7ae03
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2026 02:45:00.3296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FjDu00++RhIEExT/39tMM9mLv5t32d/16LK4U9fCiKVvhDFMWl9ii+m54CWB3G75
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPFE5ACC0FD2
X-Rspam-User: 
X-Stat-Signature: 4ymzoz6wkrwucyx95yxdd5eyfb3r48cf
X-Rspamd-Queue-Id: 7349F180004
X-Rspamd-Server: rspam06
X-HE-Tag: 1788576308-823916
X-HE-Meta: U2FsdGVkX1+nujMOtHdbm5XiR5McRawPL4SDsijKsbIW84ERAc/8sObMoZlncWurYsTTAPrqyG4OSydt0tR6CkhOMougdyAivS9ySSUWhmwEl/EWLsfhCuSlqI1Rc5dBQ0nd1wk2qik9AUdNrk3dP4gpJgM8xMxqDDHUBpe5UuSFx/qIoSqjijUwFw++PSOP3CFaVM4k5MRzJ8Djd0ydLUzlxbA0G4tryQPBWDq+hR2W249P6J9URJ5UFmZqy8fLkFACWOd6UYmps27ZVVlfpu16dD/rW7ZDjUk8KqJG4ykPXmuF/LjtnboNipE0c/uIrZu2FMhAXLCeL1r9+kEEExoRaxjnryZeYbQlfkuYfJSUERWxMvPxo+/J4e1JI7f4KTOTHktm/QVcxDLt0M7nj9ROTjVp5UvWXlp6VBU+jpCLpBmSRq1AvCn3x6BXRz/X7Ge8BTnmWCuBIgwLjf5wCIJkMFLaoNwyCS8Vf808lHRRiP8TamRsJ7W5L5J2AHIbuUDWV/xUFB9gCkYP9VRX+zNO+VmTVAGUd6tkw27cdlFkXxLPrNmRlKle6v4jj4q2yCHw98hWVcJbBtdQdFLfdE9fSup6eyu6je2VcRAy8TcZsnlg/Pn2mxQCUF9N7EQHxwLxDOriA7bsA9Jklc2yqhpmA4ZoVhUfA7UKzhASCagc2hd5jGEuE+5e8bGWqsF1B/H05hYhHQUViGGZHpeBn+8crwXh2udMV3n2XG+X/ziRC5KHp368ANU+bAPB0BExIr+PI0se9RQTDjq5u3F/vz9ANQ4iqeTYea5DcNbm5Qm3ngX/HB7Tq1m/dPEGeEoVVQRNfOSnfOga7Dan2G/phn/s27l2uBCxKjC6NeIbum19RARc5DH0aNMolubJxrBChu2K3DxTgG7McMXaXpWdP399u060QJDq2MR7i0FOJhrYtqcpenP9U+W4Pds8HuCnwgS6x4JVxHEYUZio4tu
 avKmMWXG
 9HQkqX+K8RgxzmvO8BvPgIjYPw+UdjmRrF3I1hX05FzlKk+fd+FxfsSYV5bJPCTiGJoZKLjyGJTrdEzio0SsYFtZL78SYjztledJH1XmwXzzq29a1js9JKKLMHW2Nd5Zz6xPwwfyWiR9nZISm5QPkKBFyPR/Cr5TFreBdsJi+7MdsFhGCks4j4qaT9E2KMW+xAfy9TppCdHrGJkSigoTv1ET6dYFqgrS7+pp+Rf/8ZIldo2MxN5ZiVkJ7jYd8+FuzKrIV3xdSMvkVFeTITDOhqc1VTiO671i1tzN0Uhe7+4tVD99VgTqIwrR3qa/RDHZPv2+9EWWmZ3FK7V3leGJpctvoPbjUY1xZW/VQOVKKPydZ+kh0GXy2yjXP09dBYQ4a7cYKFBbi7XcUGU9wnyqqrvOFBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 4, 2026 at 11:10 AM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Tests scattered through the collapse path decide what a collapse is
> allowed to do by asking whether khugepaged started it.  Between them they
> settle:
>
>  - which VMAs are eligible, and how hard to try for a folio;
>  - how many empty, swapped-out or shared PTEs a window may contain, and
>    whether a sub-PMD window is held to a stricter rule than a PMD;
>  - whether a range has to look used, and whether a MADV_FREE'd page is
>    left alone;
>  - whether the PMD is mapped as part of the request, and whether dirty
>    pages are worth writing back and retrying.
>
> None of those is a fact about khugepaged.  Each is something the caller
> decided before asking, and the collapse code should not have to look up
> who called to find out.
>
> Add struct collapse_policy for the caller to fill: khugepaged from its
> own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
> Every test becomes a read of a field, and cc->is_khugepaged goes, having
> no reader left.
>
> khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
> call.  That is the one change in behaviour.  The max_ptes_* limits and th=
e
> defrag setting behind the allocation mask are sampled once per pass rathe=
r
> than on every table.  A table scanned early in a pass and one scanned lat=
e
> are then judged alike.
>
> collapse_file() also drops a NULL check on the collapse_control.  It has
> one call site, reached only from collapse_single_pmd(), which dereference=
s
> cc unconditionally, so the check was already dead.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/collapse.h   |  40 ++++++++++++++++-
>  mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
>  2 files changed, 102 insertions(+), 52 deletions(-)
>
> diff --git a/mm/collapse.h b/mm/collapse.h
> index 1c40229b9554..05282eed9a35 100644
> --- a/mm/collapse.h
> +++ b/mm/collapse.h
> @@ -48,8 +48,46 @@ enum scan_result {
>  	SCAN_PAGE_DIRTY_OR_WRITEBACK,
>  };
> =20
> +/* What a collapse is allowed to do, decided by the caller that asks for=
 it */
> +struct collapse_policy {
> +	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
> +	unsigned int max_ptes_none;
> +	unsigned int max_ptes_swap;
> +	unsigned int max_ptes_shared;
> +
> +	/*
> +	 * Hold a sub-PMD window to a stricter rule than a PMD: no swapped-out
> +	 * and no shared PTEs at all, and max_ptes_none as
> +	 * collapse_max_ptes_none() scales it.
> +	 */
> +	bool strict_sub_pmd;
> +
> +	/*
> +	 * Collapse only where it looks worth doing: require some sign the
> +	 * range is in use, and leave clean lazyfree folios for reclaim rather
> +	 * than collapsing them into a folio that is not lazyfree.
> +	 */
> +	bool skip_lazyfree;
> +	bool require_referenced;
> +
> +	/*
> +	 * Finish the job rather than leaving it half done for a fault to pick
> +	 * up: map the PMD over a file collapse before returning, and write
> +	 * dirty pages back and retry once instead of refusing them.  Both cost
> +	 * latency the caller has to be willing to pay.
> +	 */
> +	bool install_pmd;
> +	bool writeback_dirty;
> +
> +	/* How hard to try for a destination folio */
> +	gfp_t gfp;
> +
> +	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
> +	enum tva_type tva_type;
> +};
> +
>  struct collapse_control {
> -	bool is_khugepaged;
> +	struct collapse_policy policy;

Can it be made const since it seems to be read-only?


--=20
Best Regards,
Yan, Zi


