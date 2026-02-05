Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D73EEA795F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7446B0092; Wed,  4 Feb 2026 22:56:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674D36B009D; Wed,  4 Feb 2026 22:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F696B009E; Wed,  4 Feb 2026 22:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9B46B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:56:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB4A214034B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:56 +0000 (UTC)
X-FDA: 84409042032.18.DE5650E
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012032.outbound.protection.outlook.com [40.107.200.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34BD3A0006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:56:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kHkdt+kU;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770263814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KWZrti6d11DAwKaiz4S+l/tZ+8mU06+EENPVF5WXv8=;
	b=4AXmfiQej51ZDEUo2ZF6U4T/wA0xRq6HzWoyDBDUUkRR0bHAZEpqiRrVRSRhWJHsDVfD2Q
	z7Dtp+dqTP1bEZAXYuBfwn6RvieC9si4dmiTEOeidQdvnMWZI1/NdvIhyrnWex8DSS8zEn
	4VLHfYHtS4ABvSGiOZqT8/IMFXpPL+k=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kHkdt+kU;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770263814; a=rsa-sha256;
	cv=pass;
	b=XXtj3AUIEoS0Q+ePqAhqxUO6BJLL24760EEYO+DD4oSTf0g/yo1xYeq/XBx9EHgbDRXWAD
	7HNGMrPGJWGAOTSjHfPac4XRB75Z6EaVzN2XyrNh+4tA9lh8cp/Xo150NkdPlpxnZBho9p
	6Yv3lKYO0hd+3ApyPgNuXbSOn3soczc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e5zh/c149qoy3+GZgEqGfrMSaZfxE3x+ETvqld9HzZUvP6MIDoI3CpYaBaCyidE5RnykfGPxl0rWT3+FA/9gAQSaKqbUx2yUtYIIJfhsTzdu5/bT/EeAByUtpgVPhlyryMabshius7e4LD/0vruXdpoKrQMo8PIJA8qSzB3EGvqegKeSYCyv2mLm7pB16zq3Q2a/fqb3WYsDo0cwoBWcCJmAsaUcwqmpKBtF/bo7Qqj3vmwN8TCy20t6PR3Lm8XbABHmlqXwe8lDAUk/+/5opQ8BK6fJsqhyKoE/KPasjn576Q5jnGQvD/wQE2ZvrIMre2jKrOMzBH6NcfaWJS0XXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KWZrti6d11DAwKaiz4S+l/tZ+8mU06+EENPVF5WXv8=;
 b=K506D1WTOJxufMabKF5DsOLtMO28HBYpFd60Yb0WxaAX6SIZDcC/RqVxklopd0bd46zrzNsaiGxUVvUXYK0O2RuyCoEFkCcAjq8UP9/Jsb1S3V72e+6OaoSUdA9AdolktvsQh/jFBpEuKHBnekyLxkfZeTtu9sJBtAe+Q4IeicaDbqFp/D6OreLULmmM7EBOK0dmEzz7UP6QlA8HBfPDtbQxol5EpKTP8hTdbOXSGItxbUO4hhWqmpe3wPKrQ/Aen2SlL59NEN1xFNtKHXhkbX3txfbF2r+5nuE1EMxbZNLiFNzvMOZ6MIX/eCv6b4WRBjf8dIRuPxS/OwhHoKr3Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KWZrti6d11DAwKaiz4S+l/tZ+8mU06+EENPVF5WXv8=;
 b=kHkdt+kUWCyfwvqlw62cjkgdxBJSqIQyK6NBdT9REWH2DW5aFR4uylussRgzr7ITWOpz7e1APLj46xACgAjayrQm+b2Y9UqdAsz7dRqrvZeBnua4rrOmZYv8/E5s013Chlfk74hyollGX0zNy1ci0Whpex6ndfen8ECw4dNwMsejvf1JIU13IpahnRWzGKGI0dw5kGHB1DD/tp/wabt0L5k8CPgMI39tMouKD2+Kni5UfzXP/KSUXEHigKuYQPfleQTfHQjSVlydGdswTYxhfAPA8ArRql5Pe+cWhIVJWSW55t7+11JWOfhjXY06TMKVRmCPrIeUO26d9GkICGBMjA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Thu, 5 Feb
 2026 03:56:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 03:56:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>
Subject: Re: [PATCH] mm/memory_failure: reject unsupported non-folio compound
 page
Date: Wed, 04 Feb 2026 22:56:47 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B5A2736B-63D5-4ECD-91C2-9C7BDA409FDF@nvidia.com>
In-Reply-To: <20260205005603.274383-1-ziy@nvidia.com>
References: <20260205005603.274383-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P221CA0042.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d793a77-050a-46f5-7f2c-08de646a96e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cHVWSnI0dk1NVmxLeUlTaUFUTVcwekRvWkZqdXhSMS9NdEVsRU1GQjFEMkk2?=
 =?utf-8?B?ZVU3SW1MczZDZ1dLc2RDUkpMTHRDQ3dvdFZvck5zaDRHNnU1eE9hRFVhMHhv?=
 =?utf-8?B?VzJyaGlUZGtMVU5zeEN0R3phQVpKSWhPNnlEVXVPbFdpc1FXQlpEK3h4VktE?=
 =?utf-8?B?eFkvZUYrRjV6aW9HWFF6ckZCc1U5TEdtZXhTM0VZcmgxOXplcGhndkVyS1Uw?=
 =?utf-8?B?NXdCR1hpa0JmK2ZLV0NXMG90ZVB6clhhWlN4K2ljNjcyME1jWXh3M1RCOTdN?=
 =?utf-8?B?eHczT1JvbXlmZGJvMFZudlJvUTJuQ3pxcGdrZVROS0dxRG9tbENJL0F1RVNt?=
 =?utf-8?B?cEEyVGM1TFdZeVZjdXhWWXRQSkc1RGlYdEd4NHlPTml2MEh6SENwL3F5OVN2?=
 =?utf-8?B?S1l5ZENTNGlDSFR4VzkwR3QyNFNvdmovdERqeExqMERhd1ExOGhuZ1g3eUJX?=
 =?utf-8?B?akZiOVpoSHJ6K3c4QlFRY2pkenI0TUpFY1F3SGFKM2MyYjNFb3grWnZibkhU?=
 =?utf-8?B?S2NLNXN4MFZYRkZiSi8rRU8xeEJWNG9KWjZZQnJ0d1lOME9lTER6c1lOcFY5?=
 =?utf-8?B?WGdUL0pXQXNWY0RxQXhLa0tTNzJPTTdoOEZtWWhVTGJHWFQ5dlhQUjJXM0x3?=
 =?utf-8?B?Yk5Ea0s4dkZHTGhrL1F5VlBIL3hLTjB5TWs4VjlFejBGR0VCazNaUHRCTFpk?=
 =?utf-8?B?dnZBZFNHVXYvMHgzQ01QNnd0a0FaY3k2YWV2cThmTHFQZWVoU1FzeUpzTk0v?=
 =?utf-8?B?a0ZqMGl0NUd2KzRSTnJlbDU0Yk1CUVlFMXZhMTlDaVdSYVhDQStra0FSekxv?=
 =?utf-8?B?U2xhQjVERklGVjFwTkdOSy9GNUh6MVpQSXFTTGUrZTFYeDNJUHhZZlRkdEpS?=
 =?utf-8?B?RmR4UkIrMUdUeFpxTjJJTkl1eHdhN2VtcXFnbVRhQkJvbENJU1NsbkhKM1dD?=
 =?utf-8?B?RnNYYXRlRWthMmJsOStKNXM3eVUvUzdCdGNJaWNiUEpRLzdlWFpIbHR0dFNK?=
 =?utf-8?B?OFJoMTRQYlRJVXJPTEc1NU5CQi9uWnJOT3ByNjJuenhudG9Ha1BJb2RuRC9U?=
 =?utf-8?B?WlZrcjVrNzJ6dnNKVWRtQUhYYzkwckMvT01ZWDhlZ29HVStwL1hzSkRXN0JC?=
 =?utf-8?B?SmRzTEJoQk1BSjVZTk9Fc1lVcEdZM3JiZk1SYk5mbjJGUkZZR1ZQcExXdHlB?=
 =?utf-8?B?bEN6VFRMN21Hd0IrVWxZcjVISlpLejBMN1pHblYwOUxQNnd0MnZCMFQwc011?=
 =?utf-8?B?K2UxNW1VdnhUd2FkeFJHUUs1cEc5TmFONHRHM3NsTHRGK0ZQdUhiQzZJRDdt?=
 =?utf-8?B?Qi9zR1VUZ1RvS0huL0duL2FVOFFaUE93VGJ2RWlpZWxtV2xUREJOQStIYVRF?=
 =?utf-8?B?LzZJVVNqN1doeG1SM2QxWFAvbkRsVjQ0bnRvdVJ2azFOYVMvL0lQMXlQUXYy?=
 =?utf-8?B?SVFzUFEvK1JSclpDVjlVL1JsRGRZb0tkN1F5MVVWdm5wdHJ3MU1FaXRmVFpw?=
 =?utf-8?B?YTBVRUJvNGQvY2QzcnBYT3E5eEtDTkJiblhqb3dZVXRUZUc2T2R5UVpHeTB4?=
 =?utf-8?B?MW11U2xsWklTekU5M0kyYnFmRmZkUUxvbGE5SU1mYU5tdVlpZkdneHdPWWZL?=
 =?utf-8?B?N1VaUVd6cHlaemZwY1JSZEl6UG4yTklSWmluRkRoWGsyQm85YkZhRVhkempM?=
 =?utf-8?B?Vlpwb2hnTXlNVitIL1QwMHJ5MWMvTEE1Z3BSbWt6UGlXSmRnbVVGYUFyOVVX?=
 =?utf-8?B?MG1vay9ma0hYVzZabHRkanZMbGFkaStGSGNSME1zaXFJdmNERkcrVWpmR2hH?=
 =?utf-8?B?dGM5R2NHcExYejNWQVFPTk0xNTNTRCtrMzdwYjA4NTJWRDFad3ZwcEtVazcw?=
 =?utf-8?B?S1lHYm5zd1VMRnVVZlNsQXdSRFlScjNHRGlYcHY3S2xzWXQ5RXZ0NTRGZGsv?=
 =?utf-8?B?dGxpNEhpK2hLZnFaYWFzQ0tCbFBpOVo1QklFSGk0VTB5QjRDYzVHc0F6YzBW?=
 =?utf-8?B?TkpBR05CNDhJaVlyWWp6RUpQbElxazlTWlN2Z0FycVRxd1Z0VTJNT2RKY1lJ?=
 =?utf-8?B?bmR2cEZES3kydGN5N29FOEI5L1BsaXB1Nk5QZ3BLVjl6SFlqWGpyeG5FS2tj?=
 =?utf-8?Q?sGRKsUnhfKfmcdQ0tRSca2WBE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aHhoa1hnVTN6THBKNm1HK3ZXMFhRNnJlcUlla3BWQmhwUmpsVjNHbGpXbVhN?=
 =?utf-8?B?dXA2TUlzT2VOV1F6NGJMZGswaG1Yb003cW1VRi9XRzZEb0FtU0J0LzUvdW9q?=
 =?utf-8?B?M3pFc0cvQmplSnhGQUxhNjEyS3N1R0R5Yzk2SHJnVytLcGM0cjFDcjREbllY?=
 =?utf-8?B?dGNwK2FENW9RZTJxaXhJSFJpWlphNDlQUlQ5bllWMVRZNElCVFg4empLWUh3?=
 =?utf-8?B?R1A2NkYrMnZGeXVYdFgwR1doR04veTB6aHBZSWlrOUI2c1hIMVF6cXhkQ1NB?=
 =?utf-8?B?cEVuWWVhQ0s4ZUk5cjFKTkluUmo2WUQ3V2s3Sk1YT2lDNC9IWTdyVEY4TWFq?=
 =?utf-8?B?K3Zld0hDUSs5M2c5dlo1TW1ocys4SmRPTkNWeXRhVS8yRUhPNW1xUjcrZ3F3?=
 =?utf-8?B?R01xVGtXZ25JcUdZdzVRcVVhZFRZNmxKSVFZbThGWjdmRjBlczYxa0UzV0dS?=
 =?utf-8?B?cEwzTXdINFNXWHJNRTZobUpBU01tY29NT05keFc4QWxIYXZVdGhnZDNpRm5M?=
 =?utf-8?B?VDRqMDZMQmZSRmZkK2JuMTZIWW1abEtkcG42a0FWeGUrT3F5Z1NHalZEbXBI?=
 =?utf-8?B?MGorbmVmV2FpRmkxRS9KbkF6UDFwcWd6SHB1TXVuekIxb3VvUHZyVlp1dFZy?=
 =?utf-8?B?Z25xKzhUa2JEYWN6UEUyQUk1ZDNQaGZ4RVEzQ01NZTBCSVpZRHZFNjBCdDVT?=
 =?utf-8?B?VnZvZ09LOFRHdUNUM2ZtNnJZMTdwVHZnZXc2UUVsNEZxMEExUTZoQW42bE5B?=
 =?utf-8?B?bWJMeld2QTdjL1E3OGdLbGJzRkx4M0U1cXo1VncwK2hEb1ppU0hWWGhaa1l1?=
 =?utf-8?B?R1kzMWNmV1NseDluUC9ydFVVOW42SmZKQ3B1a3BkN29sdUQ0RG5qR1hVUEt4?=
 =?utf-8?B?NW9GcEJGalY1YTR4VHY1UDlYTWZtSFdCZVIrdThVTUd0WHY4T05qdVJvOTVy?=
 =?utf-8?B?bFp4bW93Q3pnOWxQREl1Ky9tMDVOM0N2RExON0w0ZkxtKy94SnBTQStreFZP?=
 =?utf-8?B?Snl0NUV0VGtQd1VBRk14b0ZnT2lHN0x3dmgwYmROVFZSZm83OERwWDY4L3lK?=
 =?utf-8?B?dmZjM3NPa0RSOEJEYzhRQmZuanY1M09KSEE0MG9sNXgyVmdWQkpLTUZsNkV2?=
 =?utf-8?B?VlZmTUxXV2k1VUJFdldSU2lkeXRkWlVsY1dnSElxRWlyZGluWGk3c1diNGZv?=
 =?utf-8?B?Z0RyVitwMWRWZUpvWVplWkNjOTJIdGdKUlBqUVNhRVRTU1ZwNkhJbHIxdlJm?=
 =?utf-8?B?WkpSMEdUSHpzcVpLaWs4MEVnbGU1dTJpWkN0cUV5M2J2WGgzU1ZiRGliQ2hu?=
 =?utf-8?B?YUJDeWxkeXBvL01ZK1hXOVZ6ejNreE41eHlnN3JTZmFwbmpOM1RnVk5oNXRy?=
 =?utf-8?B?RDlqTDhuVTRpaTBqWkJqbHBhQmRYMkcvMXB4MG0vUFkyOG9BdCtuMERuNnQ4?=
 =?utf-8?B?end5YytpMi9oNUxYWkVLQTZQaXFIUlg3QnVKWTFPUVlOa1RFN2RKcE5TSXdD?=
 =?utf-8?B?ai8rQ3ArZCtBRXFzVnRvK0J3NWc2VjRUbHluUG5aekdzd3NULzF5T2pUdVlO?=
 =?utf-8?B?Vml3N3RLeDAzbHZIbURqajI5STZvTHByQzdNQzA1OFI1Znd2NmEzUXl6dXpj?=
 =?utf-8?B?aHdrVzVsU1l3SmYranRLOE5EY1NNVTNKK2pxdURVaEUrL0EyMmhQdTN0eUNH?=
 =?utf-8?B?eW02QVVBRngrbEZ2U0RHS2orUGdYWUFPQ3hndnFHd0kwMzdXeGZ2bDE1bWUy?=
 =?utf-8?B?U2xDNkY2Qm9Tekdrc3hJSVBTWUM2L3l3WVB3bUpGV3lRa3VXZUZxVFhYV2RM?=
 =?utf-8?B?WDQwcmtXWlJ2aWNoNnV3c0FicVgxSWFLUkZUT3dHTlAzNTRyK290cjFlLzNM?=
 =?utf-8?B?S2U4cW5mbzN2Tzk5Z0E5RlMxRVAvNHFzaXp3U2s2cnhZUXRaRWlSbnZGV0c3?=
 =?utf-8?B?KzR4c0NBREZRRi9TWWlOeW1JQjFMOEx4eVNqb2RHSC80b3lhRkdwQ3BaZFMw?=
 =?utf-8?B?bFh0MGorWnBpeDBZWHZjYVVQR2RidUIwTVlxWG9RZHFIV3JSY0tFWFJ4aEpR?=
 =?utf-8?B?cWpJNXhOMmkzajJSd2tHWmtBek1nNENyczdMbjlJem05TDh3WEhDelduSDd2?=
 =?utf-8?B?ZGlXMlJjOXA0WU40MmMrZHludU1GOFBGa3g0QzF0M3dWczJBbzRIS0EzQzhG?=
 =?utf-8?B?aVZnNDBXNWgySFpMaDZTb2tqMEdDUkhIcXVReGZMME44RzJKanFuZEhoMkE4?=
 =?utf-8?B?MmZ4eHFuQkM2MzdQT0ZpWW9xcUJKM1NSaGZQb25VVlNmRWd1OTBCbko2MEhY?=
 =?utf-8?Q?go2khQUrOPghpeHIMJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d793a77-050a-46f5-7f2c-08de646a96e1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 03:56:49.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: buQ/Eg4RRcGOgngVuk4CkTko2nB8giiwFrnbBYxq7fG3jaPobLFlUBmUaX8qesxK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Rspamd-Server: rspam11
X-Stat-Signature: 919qyx4fokayxtc9m3jp39p541yhtiyj
X-Rspam-User: 
X-Rspamd-Queue-Id: 34BD3A0006
X-HE-Tag: 1770263813-34016
X-HE-Meta: U2FsdGVkX1+7tcHfhMtHVD7erVvjZH9N+xIzVGYgLlxAzELk6XIrlJbtuCcW8MM/JlWa2G3WH+hnONo9b685haftlkPpRCeM6ChElGpI7DI083E+aEAppHZCA+qyrLAdjte7Dgb9oNpbDaJvXrfV0dYeKYf2y+XwJPX3ZvGyyi7bwAAGF1LEtA3aIR1A6WjyKDLMnC27I+w0cJTBThVnmfRoOXA/3qwmFrfcHFrGS771o0OA4sKa2+VgPr5S3HSGaSBajxf9nB+j4vP8kGyszFIYsTKuazrF2DbzPRUalNV1Y4QvNj5EGHwCE1ZHPNMf4+/eBwZ6tSwpI7EHPqHE7+us0VxY5XcZs+5a2qpKXTo3T573WohkwKspGO2dbj8gNmSZb357sbjPXctSgtiu+dJyzTQ4eRZ6RDy5JIfaKPreBl04SlYctQRuldI/ku0LYPrykDes+Eaz5xI6lMTjzu+Yuc8tJkg6M47M6MpfbnLMk86umzLv7y4p1KoC5HUeXjhDk1Tv8iXS+LXwNqnhMT4PVUYtSCWCcCsRlMsEcEGVZgraxemuWem+AR4T1+vd+FK86nm+NN6Ctw9DMU9iUwj0HUhcWo0Eqq1iVz1Gx+v/0AQrC7Lf0ib7t9H7ZREQlsubxOASg3UPAz8w+8OZTGkUU5i5rw+erFrtfGyoyupNjs56qMEeUUN7za2PVOWLd4dhQ+U32oe79i7trxwiVEuQg90otfEnaOjYcxOMvirxJrtrOn+SkyuRxtztMkH9MojGcLq3DBtGHpFqxLZ3dTKCHS3V1Uql3pWEClNMcRdbbbI6g8MpC2fTKnVJJgtkSfytWXS4kH3dFlkB+mPN/m4ZvQFBOJg4M9XxT2IZ/awKL87dKBZDHrUlf2LtZydp5zIZEAd/WK50jxIME1xv5G9B+POkZgo4Vx3T5bjvwfxT9z8IFX9jxtG8bsLK+3ndazBm0VusTUW8eWaUeTQ
 Eq8lNNvD
 OyJPSuH1iT6L8+MWcwLQW7YOTNPKTfSoTSO/9tuUPg2yUXlbMpjqcagfdinTzehWO/2HsHV5KBUkL6GpGSjpbmOpsxkm8mUuAGhk6Vgqi5AimNjgsUD3gbJq+m76YMQy1Ix92XdGv4OqERMow8KnM2X5XWtFJJ4FhX0XzdA8RHnxbVCn+9XVQ+g2T87sn1AaameKEo3UUFthMlJoSJcQK3Ke4fD7CekoIBd4VrNdtzvrch9Jm8khnzJBIATA9kJJEjYmSFis9wtJ4xpppcjZVqLessACjtHNPs9iFbgmy3x184TEzfrshCY4kyi6H0zzLDNMCYdETpz1/4OkZCldNInefz4lEANRWW/VR24b2iH6WBe4Lgxf6pLmX1dIdaxh8U3BDrVwUC9odF40bfNInYVgHkfyOdnYtEQNdB6yneWyDn9nqrPsZPagRDTFKXrL9zr70BAy67JiXANWV7An6t+Ex8aIuDPFADQ3Bsoz+ESOL8rZV2aK+TOF/6NSINy1c1MbAYHe04z/7jGN7+ZcKVxtbqzzcVh/JXeegXA3l24eKwj6tVOzg4PJ+0Lp4eaJDo/plLzepd76Y81Rj3+XnSGmKtobkQz6eA5juHCSYLa+DzBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Miaohe has a more appropriate solution[1]. I think it is better to drop thi=
s patch
and wait for Miaohe's proper patch fix.

Thanks.


[1] https://lore.kernel.org/all/c5206f67-1e9e-d487-3514-8867f00cc626@huawei=
.com/


On 4 Feb 2026, at 19:56, Zi Yan wrote:

> When !CONFIG_TRANSPARENT_HUGEPAGE, a non-folio compound page can appear i=
n
> a userspace mapping via either vm_insert_*() functions or
> vm_operatios_struct->fault(). They are not folios, thus should not be
> considered for folio operations like split. Change memory_failure() and
> soft_offline_page() to reject these non-folio compound pages as
> EOPNOTSUPP.
>
> Add PageNonFolioCompound() helper function. This function is functionally
> equivalent to folio_test_large() && !folio_test_large_rmappable(), but it
> is supposed to be used on struct page. So open code it instead.
>
> Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio h=
andling")
> Reported-by: =E6=98=AF=E5=8F=82=E5=B7=AE <shicenci@gmail.com>
> Closes: https://lore.kernel.org/all/PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB=
98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  include/linux/page-flags.h | 16 ++++++++++++++++
>  mm/memory-failure.c        |  9 ++++++---
>  2 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f7a0e4af0c73..2fe8047f42a3 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1102,6 +1102,22 @@ static inline bool folio_contain_hwpoisoned_page(s=
truct folio *folio)
>
>  bool is_free_buddy_page(const struct page *page);
>
> +static inline bool PageNonFolioCompound(const struct page *page)
> +{
> +	if (PageCompound(page)) {
> +		const struct page *head =3D compound_head(page);
> +
> +		/*
> +		 * Without CONFIG_TRANSPARENT_HUGEPAGE, PG_large_rmappable
> +		 * should not be set/used.
> +		 */
> +		return !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) ||
> +		       !test_bit(PG_large_rmappable, &head[1].flags.f);
> +	}
> +
> +	return false;
> +}
> +
>  #ifdef CONFIG_MIGRATION
>  /*
>   * This page is migratable through movable_ops (for selected typed pages
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index cf0d526e6d41..8b6b5950bb66 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2440,9 +2440,12 @@ int memory_failure(unsigned long pfn, int flags)
>
>  	folio =3D page_folio(p);
>
> -	/* filter pages that are protected from hwpoison test by users */
> +	/*
> +	 * filter pages that are protected from hwpoison test by users or
> +	 * unsupported non folio compound ones
> +	 */
>  	folio_lock(folio);
> -	if (hwpoison_filter(p)) {
> +	if (hwpoison_filter(p) || PageNonFolioCompound(p)) {
>  		ClearPageHWPoison(p);
>  		folio_unlock(folio);
>  		folio_put(folio);
> @@ -2945,7 +2948,7 @@ int soft_offline_page(unsigned long pfn, int flags)
>  	ret =3D get_hwpoison_page(page, flags | MF_SOFT_OFFLINE);
>  	put_online_mems();
>
> -	if (hwpoison_filter(page)) {
> +	if (hwpoison_filter(page) || PageNonFolioCompound(page)) {
>  		if (ret > 0)
>  			put_page(page);
>
> --=20
> 2.51.0


--
Best Regards,
Yan, Zi

