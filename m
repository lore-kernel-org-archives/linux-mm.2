Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1999C606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=p5ISgc2s
Received: by kanga.kvack.org (Postfix)
	id 2EF066B05B7; Thu, 26 Nov 2026 04:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6B76B05B8; Thu, 26 Nov 2026 04:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B65C6B05B9; Thu, 26 Nov 2026 04:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAF106B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:47:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FEA71A038C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:47:27 +0000 (UTC)
X-FDA: 85476792534.04.A7C54FC
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011054.outbound.protection.outlook.com [52.101.52.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1A4E180009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:47:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=p5ISgc2s;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795686445;
	b=HNDn5Aph+XxEMFr7rr2p0/CYHH78jDX2Dgh7/GMJg1OJhPGUKoMmwH1aa/VdGXWN+G+zZW
	rI7Wyiki68b3sbHeD0nPolFxO3JOpJsLOS7zpi0NNwTy7YUUkbiC655qtlLNv2zVro0PxX
	Wm7u0e2ENdh9uscgL45q5kGMLn5CGh4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ky9ofkePh4IJiZE3ot6txDaGySH57NxhR4MNlsnvGmM=;
	b=XZO/gYDH7pK+AgQKOJqMN9NnuDT6EaIxrhnauRHABMBmuz8wqpp2f3sPH2sNRki2Upssun
	5qMNt/VYn2bthIpFSCDFGdng+ed8XklFAMv5R608Pg4HexfDWJP7OJchG7WCzlQNBeBVXt
	FdCvjw6LqIkJdhfHWjNwXXEXU66DcYU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=p5ISgc2s;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.54 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bw/kC00w4LCFJQpMktIe5+Rd6tO5Az7a++xjPluQ0xFXIr71rdsd23TTkmlptEur0rx8IFElVHO08/+1VFU1G/FsRws8bGETybUg/T0SG03N3i2/W+cEMP+RQyzoxtmYX0EtEiLwst/UiCWiY9wQO2KkY4fgSx5eA0S1CCXf3w2GxJqR64sW+sxAgbfgEMOAd5l/XKaaWq4y6JZ1DkvGbBXna9/1IAT7hnHRTBeyIScD6rU8j0xwvbo3oNdExKuJrDZZQ2BEtA4FN31aM8wY3+gSKTcnu4PbjNEYYN/IYVRmjANFnllKX4T4wQK7WD9CApy/q1320sMGcbc5Lz0SoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ky9ofkePh4IJiZE3ot6txDaGySH57NxhR4MNlsnvGmM=;
 b=NT0keMS/iIeo6lr+7RyXi582/ErAAq8Lewa6aeT8QpYG5EZ/23xS5fRQcnUy7krkfekOZ32MHsWDZwiGRICrs5b/yVpdn1SYF5SIgj7WE2CDJjn9f7svxjB2/2IVEE5YgNEfUKps9NI1D81B4iyT+ztcmfIhzU+bLdzMiLiDbWBxRTbelM+RBilEmR/rmIP2hKWKqRy3//x02SmwZ3rQbcB2QALla56O4FBl+I6PJZQRE5Ys/jIv4gNpiblLo0Yq8iYCz49GxV1Evem453tOPG+Q00BszXjSCVJNO8bJ1xafn0NU/KbQs8N1zoSMpeeCLSaVnIRTz+JS7zPCaa98bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ky9ofkePh4IJiZE3ot6txDaGySH57NxhR4MNlsnvGmM=;
 b=p5ISgc2s/qUOrR8jeo5gHC+15oBOhUt0ZWk4p3Vb4+IPhRq/2nK6OhKbZ6Cy/FjOaOiii+DqSE0YNdhq8GNVAofLiJd8CuSpIsjNYQCmmVHz+tbKrl7D6vivW9GOSyQMEE3thXakIRspejemR2veZTEBH+YEtf+o/iU0ZO5vLsgpiA8J2ez7rpMXUzGS8QCWgHkaFZbQlFZJiHkGtUS4BNTX+vXnH4wMIKqz8MX17e5vPItBVEYnafn5w++eRNF9psH92Jo1HkcyZK6RDs5sFJk+xt5FAexTOLf3pZoyJnfP04DBUOGdltyOkt3Op0y/hXomN1okiL6upAxyfHKlnw==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Thu, 26 Nov
 2026 09:47:19 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 09:47:19 +0000
Date: Thu, 26 Nov 2026 20:47:14 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] selftests/mm: move the HMM migration benchmark out of
 selftests
Message-ID: <awf_TiUylMTGCb_e@parvat>
References: <20261126025653.1344932-1-balbirs@nvidia.com>
 <fba23668-add0-4787-b027-bfba1f66e090@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fba23668-add0-4787-b027-bfba1f66e090@kernel.org>
X-ClientProxiedBy: ME3P282CA0077.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f6::10) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: ab00f458-4a3c-4201-7d99-08df4ba24340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|56012099006|11063799006|4143699003|261022105027099003|261022075727099003|261102123227099003|261021121427099003|261009223027099003|261026140227099003|261026121527099003|261028144727099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	WpmX9EjEHokper8qW3CirBdgL5vKeme2jUXDTOwBq1ZeB7Xh0neoSdNsHLCxikp5kPUuJmPFhFT4Dsaj/vHaFS6i8T98fEQPJJp5qx/9rd6Mvp9iYu8XscDjJ90sO+sXIyu9m+NMzCNrTRiOnXREtBN+NgXnitHVHfIwoQEYFYwjMrx90S3ZX8eT89jT/8vEhZmAwHUt2zfeFkSFZ3ix4yrSwSiysy6dbAJSBNQUtgFtIyYoMPc9/3ZAfoJyw2KbAEMdhu8cYEq4bjq+S+g2hw5Cn2ttICqX3UgYmW88MT73vtmtUL6gWZtneabynhw/bqzH0VFNopR6EFHsJWwmJ0c1KEuZ7hfj/Jg/D5+3aNz6pWOwMSHxO3mmZ/TA9N/SWkAkLttH6E8eMm08pJUlR96IBelvqs6+mz80xu/0WCv8HJdye9dMlYDBtm1PaXc75IkuT2jPIupm6hFyDgQiQklbOqEK1vFbVpaOgjFSiVPaAa/sk0HrR2xIOwPlW/F+JXJ4arGGP1PHvVr4LJTkgaDYizcGAordNWC71TeacF0OHT0YdzJJxzrAjZ5lFQgme2TQswcNm5cXjylQSF76Z5cpNP/b8YWqFKHOCDdAjokc4tnB9op6T7ScjYKz8So9nryt4s+T/PbNgdvWpavekEozYLH6qSDxW7tyFtYJmU8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(56012099006)(11063799006)(4143699003)(261022105027099003)(261022075727099003)(261102123227099003)(261021121427099003)(261009223027099003)(261026140227099003)(261026121527099003)(261028144727099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVY4K0h2ckJDMGR1Mmd5MDAzSlBIZ00xWlhocnp5eXBuMytOUVg3Q2M3MVcx?=
 =?utf-8?B?bjRWWVVqTE1wVCtEWlVmU2dHeUROSWR4cEROK29IdjdyRDZpOFFDWlF4d0Qz?=
 =?utf-8?B?bmNDY3dmSU45UCtJdy9EZytsVk1LeGYvR1JGM0FGTFZxekFDSFErSmRxTVdt?=
 =?utf-8?B?VzRVVmlxSU83eTQvWWhodE1keTZMRDZ0Yi9hVzVLa3ZiTlNJMmpHaXFlOFpE?=
 =?utf-8?B?K1dGMjlRUWxMM1dUOWRqZlBBNDdVamtrMnFVTjNUaXJNY1Y4YzdSMlprV040?=
 =?utf-8?B?cWFiU0xCdDd5MERQQWpDSXUxVDRwcmFYdTI1aU5VQ2xsZGlBWnJoMEt4TjRR?=
 =?utf-8?B?TXBVTXpXV05Ma09wOEJkY0I0aGJ3cFJReWNDMEo5cXI4SXAzVUd6RVBzUzJO?=
 =?utf-8?B?N0RTdVJGcnJ6UkYyRDRLR3l4bWtTcUJjTGxHVUtzK1NOb0Qzc3orWmJaL295?=
 =?utf-8?B?WmpYWmYrZ3VEL0JYNlFJM2ZKdWkvbjlQaTNuSm5vMnFiQ2U1ZnVDZ2tBekpF?=
 =?utf-8?B?UEc0Uy9YMFJQOWRJbm9jZkhlVWVxanNrV2hkZVBIM2prcDNHeXRnWEVleGRv?=
 =?utf-8?B?SkJkYkdqQkduTWJVd3YrVW1ZZEJQaWE1SVhpWXRqMTZQYUVVb0h0dDZmV2xC?=
 =?utf-8?B?WXZQUnF6MFdtVG5yaWlMdGwvRSttR2E4TWlXbGJYRGdnT2pQZjI0TUVNRWN4?=
 =?utf-8?B?SkJMY01YREQ5eU56U09UMDVTWWZ5djdBdCsvMXhJUHVxQWQyekJVT3hGazNT?=
 =?utf-8?B?dVEraDl1Si9Ga05vWjVUWHhOOXdNVVRIT016OW1EZHp2SWUzK3pFbmZpMnBX?=
 =?utf-8?B?Y2V6MEFGcnVrYVZITW1icnRRbTlqS3JrYTNwcGNTTmEvUkpMUFFMKzNTQVVw?=
 =?utf-8?B?ZmIyTk9yd2E2SXUwSkgvZnhJYzF2Zms0VEJ2ZlY1bDRIMzZBNmx4M3lMZHNs?=
 =?utf-8?B?MmNqNFQ4azVhTWRWdHU5c0lhSXhWTjRTQ0RhbUc0dk1UWEtsZW5ZaFZ1QjBj?=
 =?utf-8?B?ZFBmS29kcGRvMkRHdHhQQnZQSXo4anU1RFZzWFhkU3JRSU1MQmQ3TEFwRytO?=
 =?utf-8?B?MG5GcmxxSDBpcEppQ1ljZmVWOW5qcTJFdzdCTlZkNisrd0xjMXlpcWJMK2x1?=
 =?utf-8?B?RmV4UzZlM21wUmxpUWFmRFRhTmxoOFdMZE4wMUIrQVJLUHY5Z1FqaFMrTWVO?=
 =?utf-8?B?dW1FRGxuTzhweEo1MVhWZVM3dFdDTGRPN05FSHk3Q28vYXVCeE9sc2xyMnFV?=
 =?utf-8?B?Ui9PSlZLck9iM2daTXBoVlZHQUlsbUR4RUtzTHU4M2lKcGtkcC9KalllTlZD?=
 =?utf-8?B?U2k5SmVTS0pCM1RzcldGZ0dvOWJvQ0VDMEJ6bWg4VmFiQ0dVZ3ppZEw3YUgx?=
 =?utf-8?B?T2NrR3QvRFJhdEpjZnM4WmZhdHJ2Ukp0VWJnMnlRanJyT2pLN1k0SE4vTWJi?=
 =?utf-8?B?V09ZbU1pelFCNURqMCtHV1V2QW41ZDBwU0NHWTU3amtSc3FuaWNvWjU4UTky?=
 =?utf-8?B?ZlNWZW1UT3VBbmxVUGFuOFdvNmZZOUxTaVYyRVB3WGxvWHoydDRZOEl0dEd6?=
 =?utf-8?B?VW5vaEhnV3RIZUVmbTN0RFFmREVYY1R1RDJBMTZsMFl4ek5GeVBNdUhCczZK?=
 =?utf-8?B?WXBIRnR4NC9XSWFCRHprdGpoRFBlQlJSc1FRMnZSaG4wK25oR1hWZnFwNEkx?=
 =?utf-8?B?cXgxU2dCTFdjczVtam9WUnNNWk1NOGNXQmtsZlM3SjVOUk1ZcFBNTmtPa3pM?=
 =?utf-8?B?QU9WTjNmZVgrc3JRU3AxazZuem8xRFprTVlRSjlUUzNPYXJoejQyTkZVQk5n?=
 =?utf-8?B?L3BEMUNnWXBRQmNxT0sxWG12K1FDczFpMURzdUIwL2x3bUFHbHdndnU4RVZw?=
 =?utf-8?B?U3V3TXlmTHZCK0QyeHE1TlJ3TDdzbEw2Y1VzcTBXSXdCdFZyVko5REtwd3I4?=
 =?utf-8?B?L3RiQkVuQUNMdUY2ZzNpd1NZajhGbGQyNVI0OGloSlFsL1hXTlI0NTQ2RUVq?=
 =?utf-8?B?WHROL3dwdytjQ1dZQjdRczhJTEs0VytrWDlVeVNaVjc3K1M1RnVTNUx6a042?=
 =?utf-8?B?RmQvT2piOUtYdFdiMzdFQXhXSWtFbTZEc0tsdVM2QVBJRHJyek8xN1BBa1oy?=
 =?utf-8?B?Z0FFSWRiM3FrY1ZEREtPMUQzRHFtVmRoL0pNQUpUSEdXMVpKY1oxbWZWcjRH?=
 =?utf-8?B?cnA3SFExNGRiSHN5T2s2cUt4eVhuaWMxaEVDVFBPZEE3VTEvaDU2TzFIK01F?=
 =?utf-8?B?ekM5WnVsSitxVXIrZk9aK2ZxZTVucFh3RmUyQnJRUHBrUUdRYnZWazdVVFUv?=
 =?utf-8?B?djgzNE53YWduaGp3emF4ZzU2SUZhMVVCYWtRN29JTGJVL0RZRmtoUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab00f458-4a3c-4201-7d99-08df4ba24340
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 09:47:19.5837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RW+6uEomy9zfTVRVuHHzoPjEHuvnZsppWdNnufiNYRsZgKIPL2YUZKdiWOKZePA+dzPbgB0o7xWflYzmzc6kkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1A4E180009
X-Stat-Signature: 3g95fjtt4gdk7ae3p3tbz9kh5qtckfrg
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795686444-931686
X-HE-Meta: U2FsdGVkX19cvcjVrKQG2ySWdgSHjZLH31JQlEtTtP6No0uR4c2hFRjAaEkParJ8MIWIDDZwOaCg9UTAe7sqK4ClNudLthNoqz1/gywE+RHGJqwR/S6lQCnFxaw8iTFbWbvscaSYgqskHkPisVkmAXIk3Qgy1/OFd145OBo/QCLQnP370AE4EOx/9tiQxo2QQFqozeniZK5GhkLGPIGJ0KVA1i6I+bL+2RbUZ/10+8XF3+vCxI7Lz6+ykP+jmOAf0R546y1zX544Dltk7JFDu/ghzu25564Xo7YevgDCLCprSPQy0pKc52eIH5EsFKzy0Ejv8n++fLurES03ZmedGDp1cS0OOUUwNW0Vy2v/3lnw7x7CSpXvTPvsTg29G5uRIbznya6nSdvGo79dyobTAmFR8szFY4sVuWgbz8ubcKmgNt1vFPjWZUZrwHABhlkn/T9AipwpN2cVezhKTcHRh+zh6Nr5iwsEsgtnt3I76iPrE/XAm/YLz4yetKmCq6ABDPtEDVk6WzoWf7e0yaCkh5W50E3IkM8dPGBLDbD5qm+VkstMSMvyxXWVAx+/yQeP6w64XgSKHy314AyAHDLhdnoEmTAFQm+/ckGkXFUAkm7hpQiHpYwdA4oZp4SF0uMTwWR0WAojwZLteFNx5+zOeKe7OYCWqjR32Dve44osbr0UiUzXCTzE6rwriHISHe6igvr0X4pQJQ2jsARKusitjwgDJP4QNs0GGMb+Ql8+sIp5DYDcL3PVaIg9qx9GO4RQN2qTCXjtda2dXZdaK/x2v77uwiR44n9B5wGcMcpSvUPyjYKkOIgNZBs4xlBGKxmao6bjBjRDUNhAp2Gk6s4Rtrz0fkrnyPjy0CZAH96YFjf43eD19zuOm9PxEd1ikw2FHizmjHegC9ks5Ye6C/ATRxvU7A+dAVYECcWjTErydHYjPoe7mZgKt2WQy+lg7HkqmBNN5rrHnL9iexgZhsk
 yw2tOiid
 acn+OAbdrru7InPOyz3NuYBSEkS34kGuDN+OrQ5tSNNSVOdzje8LHJ5cPzx6s4cVvR+N/e/2iczJSwKUcWPMFd9E4yL9MTD5US1OvcmrYDrsbIC3OoGp/frCBsidWuwo6bPBqKw4JfvQxxwbX176YtlQIx+E39KdEQIeLkmqvQWJXSqOE1p/0K/B+MBB4A0TTMUkrCxzs4fQtxXLArTLr1KvU4PRsx26PamAx40hahaGD0Bz6JSpTNH1tnJwNPydkWX1jvsViSpgpD9RwBHpmQdTGyrIQhoc+hh6G1Dz4mORfl1EeXY/kXgTjKBkyN6dYKiAvQxhul5iFBNJQf+6jXHyjwiJ2YAoNgAl2uFf9N3HcuoMcQaWC3kDBRHNxa3HfF+MSEdgCuCkvLxcyCI/wd/QidSR594WazFoh5ckwKzneGL1oYJ/wjpdsCrwoo2pZi58HnYrI3xHuPvFleFLGbChWzeQjm2bUYoOAgJy+uIK0UR3fUnjVHy2bcHYinzqCbyHKbLGRXNhoObZcSMaa6vIyVYCYt4/8gKmZK0w+ct9Iz7iBcadxwUZL6EqjWQ+gvKDos8oJXRGabvVQrGayTjZ5jKLlO5EkF5UE58E1CAyPZeGGVmFSaWgAcuKpNBbXNZlmhAhCoGr+iTFgBYex5+EEwZZv4/4p6g32pxyye9yvsegJyDScjIjGo3KDLJhzKJuZbLjeD1VsRSujsrV2rezyUag4vqey0hDM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 07:41:48AM +0100, David Hildenbrand (Arm) wrote:
> On 11/26/26 03:56, Balbir Singh wrote:
> > The HMM selftest runs benchmark_thp_migration on every invocation.
> > The benchmark repeatedly migrates buffers in both directions to measure
> > latency and throughput with and without THP. Run it on demand so the
> > regular suite spends its time checking correctness.
> > 
> > Move the benchmark into its own hmm-bench binary and share the device
> > fixture, buffer helpers and migration ioctls with hmm-tests. To run it:
> > 
> >   make -C tools/testing/performance-tests/mm
> >   sudo modprobe test_hmm
> >   sudo tools/testing/performance-tests/mm/hmm-bench
> > 
> > Drop the 128-PMD buffer to bound the amount of memory migrated in one
> > measurement. With 2 MiB PMDs, the largest buffer falls from 256 MiB to
> > 16 MiB. The remaining sizes still cover buffers smaller than a PMD, a
> > single PMD and multiple PMDs, with and without MADV_HUGEPAGE.
> > 
> > Call fflush(stdout) after printing the results for each buffer size.
> > The kselftest harness ends the test child with _exit(0), so timing
> > results still buffered in stdout can be lost when output is redirected
> > to a file or pipe.
> There was recently a discussion on where to put performance tests. Usually it's
> much rather tools to test performance.
> 
> So what about tools/mm/ instead, where we also placed gup_bench.c ?
> 
> -- 
> Cheers,
> 
> David

I don't feel strongly about the location, happy to put it where it can
be found and run. My motivation to put it where I did was to easily
reuse lib.mk and hmm-common.h and other mm helpers from the test case
(due to the dependence between the tests and benchmark). Let me
refactor and see if I can find a good way of reusing bits and see how it
looks like when I move it out to tools/mm

Thanks,
Balbir

