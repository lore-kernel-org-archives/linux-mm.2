Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B36C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23AA06B009E; Sun, 28 Jun 2026 22:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EC006B00A0; Sun, 28 Jun 2026 22:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BF96B00A1; Sun, 28 Jun 2026 22:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D01DE6B009E
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:59:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 514CBC20B2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:59:23 +0000 (UTC)
X-FDA: 84931444206.16.502F9F2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012066.outbound.protection.outlook.com [52.101.48.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7E34980004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:59:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KZBXkSgh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701960;
	b=4az/qGjCmLFZ1tsk8MknEA4OJt7l8pnohMAx+5p4lmu9rNmo06wOdmmESsKz0hiUDsT5vJ
	V3B8jIEUab7UpsQDrzj62xoURj5C5RhlKP10vdwIjLHGN66SEGzN+0NeXUPK/sCfMf3DEv
	VnABLe/gf50xsxJ4lLBW7o17/H95CDw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oviQR214kGU7acuLL9CfWHTJawmmy+x9TYPxoHUVL+E=;
	b=oTljos77onyFmZU73pG+hPw6URK8uvlUDCGpvkRUujUZakOt0vcru8LrhGGMzmYP7cUd1Z
	sQWIrPneqDv/J1is2NIIMWAPx3uGGSpjbko9riA4wjSkxJjL/DIEJzrRLeWoK7aDErLKaI
	/+j/fDwkesy1COtGgZHKZMjHzshCEgw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KZBXkSgh;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWIsevu10gw7evooPNGPQqxP5fasuXYc41VLcJuq3HB2bUosLb9RukzyP58OBYcEUJLrWf382ggZDq2I4YitBUa+gPJmhUbWLaer1T+cNX++Jv4+5aOlYfD8C96eOjsDmSjf9yXWOalfvJLljds4nNWZiepFuivNK9Ahk+XePMzbWY+P/CBCbEH2gxoVhF1EFvjsgPGfNa6Tlj+iyLDKQnlZoMUQbaPhRzAG61BIyx8EqyN8F0yIs2erob3wCwBNy1ZzyOIsOXXkwUA2SpNGbiY6BF3NfdN5nXHGAxxKU7K1E9w15xS4c4Wst2Jh1dbInRShTspbHtWZXdH7OI4kzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oviQR214kGU7acuLL9CfWHTJawmmy+x9TYPxoHUVL+E=;
 b=UXUoyEvMwho4FyFvCTP3s008WAqwQgFxVc6EjJ4n2NDQ8gMSQ8gcZkEvcpSHiKZegE67OFdJwzJDbcm+lzBl77k6NTJxiVZJDIPxjuaXk/mrVX0yvSQKnr9+TwK/9Q7mRBXT2qNK4ewWzt6R9HdjGJy4eIuc+cCvSEJ5bYcumnGz5JpZL96fWo+Ak2ppDWSAgo5hVO9aac9j9DHYyfaSTCH2+t2y34d6boY6xdplyi3p1K7+Zk8iUjvisOKEKKCBq2oX0c78VtpqLVNQUvDmbtTvyxwGtljc6SVCzcMo0uGEdc4Uw1nNF0Yhoxy918+rfnuOESYVfxQuOODT+aM1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oviQR214kGU7acuLL9CfWHTJawmmy+x9TYPxoHUVL+E=;
 b=KZBXkSghcikeH3YRqIywyGCYJvFsw35+PU0tlRIYtG5dD2BClZT7fQp49sOsAxSxqXtYZ0PQcVspcFHc/wv2yl9aHqUqV68ssTQnwU3mH00Il5h/uBNtVd1kPFzO7s3N93UrTDzzz3dCEIQScCG/fsbOjS3ctgJpyw0Am8aukxazMpyK9i5Y7pdycQlY1PrROCDqzpJbLS0Uf733Ll+++8Egia2HGXMlnzHyQr5hHOOd+SeYyQdzDDpX2xmUuYMfbYKc9n+QJI1fdbqobOiUSCfBQRVD1yapoWIS8bvTJc/yJDsfBvbblTpGs8pBSghPS2m7oKW3SfoSq/I0M/HZ3g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:59:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:59:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 28 Jun 2026 22:59:15 -0400
Message-Id: <DJL73OH24NJ5.36AMD5QABHQZU@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 5/6] mm/page_owner: move free_ts_nsec output to free
 section in __dump_page_owner()
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-6-ye.liu@linux.dev>
 <DJJ7K125ZT44.1D6ZSH2JPWIES@nvidia.com>
 <4dce3872-1d3f-41de-adcf-5b0c4b431a6d@linux.dev>
In-Reply-To: <4dce3872-1d3f-41de-adcf-5b0c4b431a6d@linux.dev>
X-ClientProxiedBy: DS1PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:8:243::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fd1f3d6-4473-4aca-d032-08ded58a68c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|23010399003|6133799003|3023799007|22082099003|18002099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	wBgnETK2OOpEWsLS4STbGVbMbtHPirU/BSG3/6FQ5n56LHuOeqHnYD1deeuYOJbNpS7rUs/LtSZF6jPsJKF0r3jphQwqvg9hudzMwzKH2FXUIbdzrFnKPf9y2CrEj/+o3m6a4xl7D0evhWgJzeIy5dH3rFbSJk9gSu0sCOwwxQeKvyd8IAoI6TqRhyqG3YYP3oVU7+4Y3NcwIUKqRtM+v/wVHzrNM0C2atg7bneQfXCHhooetikXibGW6MkxuiS5fArKw0vl2h+eKbeaawNNJkbm3FDbyroUuTd2/sv1LU6V5V/CvMuUZ4XMkPIn49OB89h98Ga2915/BT5IPjs+h3ji622rR/zFOgEc+Hu3Iq9e/7Wb2+dLdD/AtgsXfTfA0CGlq9i8fM1n3eOP6dXrYtRGlDMleVmdzi3MrWRJFfkNeIcEnRfOTJRk18GnzzUFdyPrTDKlTlFHpncU3Wkcsl1qUeAiPysQrxmJQd121e2W4joUTCG/CCLBQW9wocLLuMfOsE2Iti7wvvfR11g91wmQxmmmID5HEQ0GFkMrPITiWXbn3xdtlARirjMgBA/u738naqbuk8EDw0sAzodIuRQ9D6Q4mUMK5bm/0ihPxH+mBqH6D4gmlzwhNOLdxH+rBGuQ704rmdn65oiiV7HJ4k5G3LW2shwkh2yr69Z7O20=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(23010399003)(6133799003)(3023799007)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RkgyMjFDMUduMGc3K0ZZNWhqelNPSkhFL1pCdGxhaDhGdTJlR2kzcE5hYUNB?=
 =?utf-8?B?eExhcnd0cEdwODFvUGhucW9tRXBvUHdYUE1BWk1tTHRHQWwreVZOSURjdnRj?=
 =?utf-8?B?TVNoUloxVjVwb1ZvOWJSUy9XR2p1blFxMEovRDIxZHNreG9qTlQ2cXRPaWdq?=
 =?utf-8?B?S1lBZlNhRXVYNUh5RDlwTm5IYkVzaTJneUZXSTlyNDNNa25OSElEaVlPZURX?=
 =?utf-8?B?ZXJydm5VNjIvT2J5UHdPNHdGQzFrNUt3ZWliNzEwTFdGaDF0ejlvbGhrSGNy?=
 =?utf-8?B?aEhjaWN3OGhpZXNyUDR5TVNROEwybjdkVGV6aGRzMktTNWtWNm1ZaStCc1Rw?=
 =?utf-8?B?ZUFpcDRSZVU0KzJmWUZvSzV0bWRyL3RjUVpvVUhQNEhnd2JMbU4yeUNNNjh1?=
 =?utf-8?B?UkF1YjhqOUg0NHAxdDFWWjgvT0wxRUp4ODV6YzBOaW5qY0Qrc0tQSWtLeDhj?=
 =?utf-8?B?V1dSZnE2SE5GMU12RHZYUWpyb2xhWmtmdXpoZWRaUGgyRzhQNk9adUVTV0Fi?=
 =?utf-8?B?OGorZ1lHTHpvT3FkMnQyMGQ3MTlnSXc5a2ZwK3dIRW1JMDROYUthcTdoN3pU?=
 =?utf-8?B?QVBHd2NKOXNsOUFMZDVaRnhqL1IvMVp6YllFSFFLQWI3bmRyYWhMbFdTVVhn?=
 =?utf-8?B?aDNGQ0xZUG5QZVF3ajU5cFdLT2JSRnpONTFVQWpZbFIzZDBGRFNNQXkyQ2sr?=
 =?utf-8?B?Tm03a1k1NVFaNFRKUkVkcmtpUVlnQ3pYU2V5eWxtWFo2ekYyMmdhOHU1V0Q4?=
 =?utf-8?B?VlJKL1ZtT3A1TmZSVzVBWDg0T2RRdG9yWTVzcFg4bFM4amhOV2tnb25Kb0tG?=
 =?utf-8?B?aytXTE43Z1d3cmNQRTA2OFBOREcvTHBERFJzRCtiSHNteE5SRWJpREVWR0JT?=
 =?utf-8?B?dkFqS0JucVlidms5RWVhNmRCVHU3REpQblRnTjA4RGk1QitBZllpZUpQOTJ5?=
 =?utf-8?B?NVczdW1SMHRRU2haUUtaOE5OYVZKWXR0V3ZxSkZ1NUZTbUFNdUNhc1lPODVK?=
 =?utf-8?B?ajBLMTB3bU9OZXhRQmtqOGwxVDAyS3VrSEtJYVgyOUVhb3RYMkJWTEVyMThH?=
 =?utf-8?B?S3VlOXR6ZVdHb3hrclE1ZU5wQjFpd0E4OU9DbnFxNjZRU2thVFZhR0x6TXFN?=
 =?utf-8?B?NENwOUY2QzVzZmVybHVERlpsZjVBVXgyN005ZHdTNVVkZWlvaTBYSnhZMTQ2?=
 =?utf-8?B?d21GL1RmT05sYnpvV1JVQ2U5dndXMmt1RzJRVVZ3cHM0NFM2dUZhZW4vc0Q1?=
 =?utf-8?B?TDJYWStxMmZsOWgzY3doU0FwSFFVSGR2eUZ1ZUpIVHhLZDJocHNuWGhSbEVs?=
 =?utf-8?B?UThJNUFhWXEzZ2pINGlyODBiVUhHbk53SFllVHcrYzdYZ3I2Vkl6T2EveWd4?=
 =?utf-8?B?cmNMYXV4VHJpWmRseE95dGJRa0RIZnVDM0ZYUURzQ0JvTW1uZWtPRFJ6OFRZ?=
 =?utf-8?B?WE1BazR5TnowSlpsTmora21qelNDRy9LbGZwUXhZMmNrK2gvNFlGVTJjNm9m?=
 =?utf-8?B?S0tCODkzT2xWdWRScEtrMGFBL2srVmZYR2FxYysyYlhpQlhyVmlXbVZBVFgx?=
 =?utf-8?B?OXF5M2lTTnRFTGhRb0RxRjJVa2NpendLa1hNNjlkcnpHTlZVQkFtZlRHYTE0?=
 =?utf-8?B?Ui8yVk90TVpIN0pWR3lEYWVYRWJhdGs5UTBLQ1VnT2dRRzUyZmNRYXBOM090?=
 =?utf-8?B?YUxqRkVzTGYrQUVXYzdTSTJud0RtLzZqUFdLN29LZ0RVNHg5Y01UN0NSUnlC?=
 =?utf-8?B?RDJpREdSa1dhRFdwVnF2aHB0eThXR3p0czd3RnZ5azN5UnZENzRZbFBpaEto?=
 =?utf-8?B?STNSN3BVR1dMeVhtVXNWR0JOV3hrYnRodHdmTDBQVXZXdHNOTWtkZmRjWU1S?=
 =?utf-8?B?blVvU29LdTgweXZ5aTdFY2IzTktNWUI0RW1LUjRiY3hsZURiNEdSeXMwa0Zz?=
 =?utf-8?B?ZW1iWVJSVGxvMHIwb3k1RHZDK2FTbTk1bWxaSXA2S1dDTkh0YjdZQjdaRm1J?=
 =?utf-8?B?U3lRVllzZUwrajd2MlhoQno3bmtxZXBhZ2UyVVZhNGkzeVdWRjJYcDE2UkJ1?=
 =?utf-8?B?MXlUYncycDg2QlhjeG9UT0VYN29TdTdXSDdVT1Y5US9LdU00VXFPYTZJckZs?=
 =?utf-8?B?R3REYVlLZ2hKczFwRWVWUjNBS1c4ZnZlZEduMllXN0JvdWVpc2N0djFkODdu?=
 =?utf-8?B?YXQ0RlhBNXdHN2lDMnRpS0xxRW5EVk9DMGZvN1F1TUF5NzhQYzJPOGY1R2pn?=
 =?utf-8?B?QTlHdit0b0NCVjAzNk5kLzBjVlhqYmVtQ0MzMkM3VENWMGVEMHBRMHVna2Js?=
 =?utf-8?Q?itPKVTFZ79kNzczL4T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fd1f3d6-4473-4aca-d032-08ded58a68c6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:59:17.4338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRDmDh37EsXYj4VzPTK0uU6fPNxUe7z0WDp708ZtPRXV9JE4XdjOTuERoYZkb3xX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E34980004
X-Stat-Signature: c5wb5hssr9dg9846hnha6o9mz3urz93s
X-HE-Tag: 1782701960-621480
X-HE-Meta: U2FsdGVkX19lLmxd8Rv7YX3GpqOJW5YN+RA3/G+27AAHQgij5Qx+6JSmPBI4HMND2YyhSnyXzOnZaHMvJs68eZ7qoU7dAu09DcxaxZkZSvxTcRi8k3JmwdxR1/82EoxBx6+MfsQBJxql46p8jmYh52z6kPPWngNs0P5cZ1SD70XaUc+62s2doSRQFAp4aY5PFYz1L3fQJpXCdF0zbYGVz62btZpDss6UECAbJlNy24mqHLsy/tfNl5Nr16gKrMPHJ87VTgz0lK7jr+94KGaMQaMJMdc8F0w02dN55w9tCxur7ql4HGBz64CO/kMnR/3nJCatLCN4OjTzUnDqbykKp+Jpx0X+FVzQlTo4JtU6pdCXOB6wwjyvn0TaQJMm8Gi9W0K1N1Mbh8emheKqqj+hXcOVO4F/NTN6y6lkHW6wAm7R9uKGq0EjYV+Cr0wd2+Og7/WRCTYDmIiliU9w7dDogKNuKWo3Y+PTcx5FAI4Ke7Sg8uRkaq5vGoRYg+/0pvniOhnKN4VhZpIh1EiUOHWX2PTnW09oYYA/r/z0RxxM96zaBp5rdjpPSmXpYJJVPuHwtxhCBFrLmhcVYVLgD6OCqyeTzVz5RWEutjw89kpfGMDVNuCN5fErc9WmIFlJz5XCxay8i48IsoIUqVcFRnFfStpyJxiSA87D87wySdGxh6jxsyhwcOrb+87dpNWtGy0/y/FEOeCQ2qXaTWRwuLB2XLqwPHxJi8IOr/7JWGetGeReeF/3T2r1jUNCXVOIjh2/+Ar2GEN96GliBavQ4QvM1S7hFBEDHjJaszyERayp96F1/TT8yAKUVLfofX2BNwWgxETkb7vTrGfxFfObzzYk/g/qHeLYRLgEtlwBnWq0CKeTOnroHAy6GOghvZvYsAOQPN+nQ8KK7kPkRTcH/vxhs8VtYbIXr4s64KPGF399bgChr2S6oWWXaE77wxd0dF5jdeyxQT9n0AhkrNIou4D
 ZzPsCxJ1
 q6PiZsxpIDlcEKyGSys3APmAWNfLFlLoQ68zeIlDxx4xVb6azl2ulVQCU2A7Tb5EavBMPBfmHpyWdYPo+gQ2uH343b8VCOqI8+cTKAGDxeLZ0RSlTPQregPTn1aiPjGE9NRVdIbhCjgDBFv7rqJWOuksPSTNHtS5fD5kJScjrWTilejHHnEvdufCZGfdlhr5UN3Uep3U2xqdtIjTu4XwoVqKnp/bi+oJShxAklj4YiDGwkI5lH/4IAN29pvpUd16WKaikPNCSSN7yAa0tVBTkCX/Jq4X0CXOnj3ixcTHTC9ybfpKWi/BzY9R7aWgei5FGjqbchMHGY0K2djXU9l/CSXxJqe5xixE5lFcjI5AGweh7T8Ea8BprHL2K/1W3Gt9vxsH+E7C5ulOFE/uDcHLpIvpSkxZaRRtcGrcHPG86O/U29rXBXaLmc0lbL57DwxhN7L0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Jun 28, 2026 at 10:36 PM EDT, Ye Liu wrote:
>
>
> =E5=9C=A8 2026/6/27 02:55, Zi Yan =E5=86=99=E9=81=93:
>> On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
>>> The free_ts_nsec field is a free-event timestamp, but it was printed
>>> in the allocation summary line alongside ts_nsec (allocation time).
>>> Move it to the free section where it logically belongs, together with
>>> free_pid and free_tgid.  This also makes __dump_page_owner() consistent
>>> with print_page_owner(), which only prints ts_nsec in the allocation
>>> summary.
>>>
>>> The output now groups all free-related information (pid, tgid,
>>> timestamp, stack trace) in one place.
>>>
>>> No functional change except output formatting.
>>>
>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>> ---
>>>  mm/page_owner.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>> index 958151ccb587..eaccff355cb4 100644
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
>>>  	else
>>>  		pr_alert("page_owner tracks the page as freed\n");
>>> =20
>>> -	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask =
%#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
>>> +	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask =
%#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
>>=20
>> Is it going to break existing programs parsing this information? This is
>> under debugfs, so probably does not matter?
>
> This is debugfs output, not a stable ABI =E2=80=94 debugfs format can cha=
nge at any time.
> The field just moves position within the same function's output.
> Grouping all free-related info together makes __dump_page_owner() consist=
ent
> with print_page_owner(), which already only prints ts_nsec in its allocat=
ion line.
> I'm not aware of any tools that parse this field, but if there are, I'm h=
appy to
> update them as well.

OK, feel free to add

Acked-by: Zi Yan <ziy@nvidia.com>

>
>>=20
>>>  		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
>>>  		 page_owner->pid, page_owner->tgid, page_owner->comm,
>>> -		 page_owner->ts_nsec, page_owner->free_ts_nsec);
>>> +		 page_owner->ts_nsec);
>>> =20
>>>  	handle =3D READ_ONCE(page_owner->handle);
>>>  	if (!handle)
>>> @@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
>>>  	if (!handle) {
>>>  		pr_alert("page_owner free stack trace missing\n");
>>>  	} else {
>>> -		pr_alert("page last free pid %d tgid %d stack trace:\n",
>>> -			  page_owner->free_pid, page_owner->free_tgid);
>>> +		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
>>> +			  page_owner->free_pid, page_owner->free_tgid,
>>> +			  page_owner->free_ts_nsec);
>>>  		stack_depot_print(handle);
>>>  	}
>>> =20
>>=20
>>=20
>>=20
>>=20




--=20
Best Regards,
Yan, Zi


