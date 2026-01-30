Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAADE6BF01
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 11:11:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8282B6B008A; Fri, 30 Jan 2026 06:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D5816B008C; Fri, 30 Jan 2026 06:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DC66B0092; Fri, 30 Jan 2026 06:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 536846B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:11:03 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 001F4BA5A7
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:11:02 +0000 (UTC)
X-FDA: 84388363206.10.A779C9E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013064.outbound.protection.outlook.com [40.93.196.64])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1BB6980002
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:10:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gHsbcLXb;
	spf=pass (imf30.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769771460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=68K3Gr8TegDmsX2nE2uiqv6bMN02WPhp/ztefXKBbrM=;
	b=ElioZb+zaqmpBq9HULdwHKkCuZQ4xmUDRHMkQvvaVnPYm7BDWuLK3axJd9B5vYo+ZLN+oE
	WkL1JpbamrDb6vQig+Lj7y44f8SpxdOB5Ev1HmBObFlVBhzuCd2My+r31pjrTzN7fnknBX
	x7wBZwKRdt/2q/lRS32gxIL0gxqSZGQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gHsbcLXb;
	spf=pass (imf30.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.196.64 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769771460; a=rsa-sha256;
	cv=pass;
	b=4nGF/Qjovu1xDLA9VJ0JtoUdfRz8iLYkTA2hLwLVP0JBsStBDxmvn+AScKFaHSip1bHi5K
	fNnYl49g6r5DmQAIXTNLdOYPoY+tfeWrtET7KGOcEd46CrF9TRqf3JqJAdb9dvAIkJ9kCT
	Yqp+YBS2+9RQQSCE20MYlHynxxctZcE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vocn7r1ydJuU2oKN9c8f0upYUHirvfph99utU5aEty/gmVqab8kfDfOR274IZpTgCZXXMke+guT9S8H1N42SHf0a9DgetivawxJ7NbnhL3RasFGK+zdvc/b413akaoDM7mu4hJ6DGdXPMrMU5Zckaai1Slq1cwYM9IFYbPpMpDW6Pw31g/WoUTmSO2ewuZyCZA5ACzq2UY7EMNGYhGoJChOwg0FydUhGtQVclvrno0Twpe3UyOU6LL43cZj3/QqCPa4KrUOEkVr1G5yHtGvE1/AfkDVQH3l7ObjCu8rW8SxlKAFQgJYN2XMBz9Iu7a1lZOeQF+WUIyOTUH4tgr15iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68K3Gr8TegDmsX2nE2uiqv6bMN02WPhp/ztefXKBbrM=;
 b=Ik4smnJyqMcsLTLdX92BKJiPrzsTBiG7jRidSpP+YzaP9dJAZZztzzeGjZ9dEFwNAyjVQ69a7WrqxardAAk5ikG9Sv0SXXX09EijhtxegAZfp7FSUhB1PZWJ/pTVVvpmSgHIIJjSYGZHZBeT7azDpDQ5tseWuQDNrxRr6F7IGwbE4QDyFR5BrWQ5xoe4sHi0vdM8+6dTTwNK4UP68JNsu3Z4u14eeCtGFGuy0UpzzLBrhL83j6V6CMmKkXtY1AFNzaBi9KZHqMAglAElEM5Y2j4FSYksOhAcSbAcgKxEa9tsAbfaQT307xqznSR5zr8epZUu4pi24S9WQUp5KiebcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68K3Gr8TegDmsX2nE2uiqv6bMN02WPhp/ztefXKBbrM=;
 b=gHsbcLXb9jMTLHSV8A0CJEvFqeoYR8owsETLsjz7kPbwSydM+/0I+BEOzpFEhcD3vJxCydA3VKiKrOwXJrRluQA5jJPvltm1LUoF30FsjnX2jD9OCVYyGE3/TdKqOUE99kANWQKPLRnmxE2iIsD3HShCbZ5dH+ybdnl7uF5Q+A4j4M8X1mhovIMIouhVj/7uMVLJa6Ow988/yiAQBhVEMi9qytsA5rYwD4ksf/SLUZeYx0abb3aeQCbpocJ/kgF3N2bFbaYCgJpswzBgiut/SNbxL7ZLtf5t79QPlSRVhk9zGyp667p26v5lzLwSCTx2eNYqfULhcKMtYHHpaQ18JA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 IA1PR12MB7712.namprd12.prod.outlook.com (2603:10b6:208:420::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.7; Fri, 30 Jan 2026 11:10:54 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.013; Fri, 30 Jan 2026
 11:10:54 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au
Subject: [PATCH v5 00/13] Remove device private pages from physical address space
Date: Fri, 30 Jan 2026 22:10:37 +1100
Message-Id: <20260130111050.53670-1-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::10) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|IA1PR12MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f1d862-f3a8-4006-8dea-08de5ff03c6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qO1rbjt1A/uT7You2PHdC8yK9Fvpw3gq/HQqhL2G1ZngRXvXkXj9GJijtthd?=
 =?us-ascii?Q?T8lpQFfy0TsmtyUHq1jL+QoHjJ7p4s5aZYzCEFPl/DMMu1p/mE+9Mx5YCcRU?=
 =?us-ascii?Q?SaWN0VLfTVb3O10aqDDPYT/xud2c3Z9F8lZXUvvyYl4uN8ZvpzkOvKGA2Q4w?=
 =?us-ascii?Q?dd7ZOkv6d159Lnh4JIWlj9t0lC0CmAcbC9fGZQMG3Fi0yIY3GwnOthTyzGdN?=
 =?us-ascii?Q?0YC7yAD/mMNBqUhH5fX543plxaTrcCuVEtpezBFbYkRG5Cwwq98LAAe7Cf2c?=
 =?us-ascii?Q?1prghFdxcQSy6/DUQWutnQj8z7Te1+qgxbDW+7+seUAT4NtkUbdcdb4hqe6m?=
 =?us-ascii?Q?DVwC7jr7ZiSfMNlsxVxq1XehkXHZ78U19gyhLggrJ9RY8+LUTMYIlfrn4NeL?=
 =?us-ascii?Q?8OtZEVGiWlRhGrFC1xPGLhuHo2k77asxZYCCn4K002veVJ6wWab+02CJxe01?=
 =?us-ascii?Q?F41X8oQluY0HLxrX6Eer1YNu9Qr9RpHcv54WY2YkY9PC7wOde4j41Ru2Jj7/?=
 =?us-ascii?Q?LAw4B8JJSdl+L6L/P7XSkrzMb4S9WkRUG7XZ2KUiodNwl0JQV/1vNNg9UerO?=
 =?us-ascii?Q?ptzeK/rjnRwxnQYQZp0/uGdJ8xsJVeaecwwsDh+GMY0+35v60qY2rU+sOUpD?=
 =?us-ascii?Q?n07VD8z+EWM3GoOKY8x8UNn8x4ApPv2aUGEr0Xcb+xOu0+29MO7In/+2569x?=
 =?us-ascii?Q?a7AsaVmjfJqarmEM6axClnGl4hy8oJfya9GvbqZTIL/2V5Km5kHxmssWtAjA?=
 =?us-ascii?Q?LM3PAnBX5ImIT19Wkt6TX4z9Cdtr6qdhh73kzRF8s6GPMJ7mdVigJ/BeQnx9?=
 =?us-ascii?Q?K1Q6nU6/FHMP/RBzJfP6OHgKTE47yxEVz1BFTj8ep4q6Fm5lwT+u9MMy3LhM?=
 =?us-ascii?Q?VxhbhYXIIcv3EZBlhSuxAO1tbsR7ok6HxsAOPX5Sb83HsgrG2r2QGb9aYAS+?=
 =?us-ascii?Q?LMMKy3RKXymz0L3VGSyWHoOoJu4NKYF8+f7H1foP6qXWwo3DTrM+YtAvWFE7?=
 =?us-ascii?Q?WIwmvJX5G+7fo9TYHVkXd198e0Vc2IW4Cmlh+17jzz6C/fzhRbpzMm76Zw3d?=
 =?us-ascii?Q?ft2QbM37zScpEz2luSKvM4pVXzIpvzYBNVwcItEEC1zHgYfwy+G4ujVO83uW?=
 =?us-ascii?Q?8D4X3LWfYNnztHbSu8VdOaA+yCYDGiGYW84Z45wBiHWWaOwuk6SW8tKT7gwR?=
 =?us-ascii?Q?RxNrAF8KWgEaJtwyIUplJlAFWdp6PZfO+YKxCZ7NkBMpg7kRCXzOegMx6vMN?=
 =?us-ascii?Q?4K7t7k+eb+ngpx79+OZmUrxbLWSvnap6Thd8YnI/DiCb1AzpDuu+zuCdRW+h?=
 =?us-ascii?Q?SxERXF7MxIrkNSltnmJj1vpViUjge3zQwt50e2EphA+ttcS6aqWXee7iKrkT?=
 =?us-ascii?Q?dJFzP+vPPEQ8ODl0TQtzGA4VlxPI1B8GrNS6KYveUkPBj1jXwKedJLxw5QlL?=
 =?us-ascii?Q?RGKoBPagOyfu59zVnQyEwX+AqKdVrCLvWts5SMg79r6Yrcr8bj8/1XS3ndim?=
 =?us-ascii?Q?OE8nAHsoH7YrAQCtGGusFMawBkcBxWXSewp3WRN/TX/qZCB+uktdSxGdyoBo?=
 =?us-ascii?Q?xqOMNliX+A18YDHsxWo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vv3IQxGg77K6o4AnSAVn2GmyLN4G2HLf7Frnf1QHK9HduMko+mHfq2JTiZX0?=
 =?us-ascii?Q?QyRssO5ScUVE+OUsB4xvCcfjFbjLtQYH4g2ByPfrBUA1MXuc9KdR3tXD28na?=
 =?us-ascii?Q?vQpy5LXQjMsJvWQDY+tgQ04/W9FGHIGIpQaTBABUkHSW64HyhTKyR0UBP6en?=
 =?us-ascii?Q?XR0fOEKMENazy0wP2HUGpzfYFv2Ec2F7++Cokh3FcHOl4hgS/PGOh2AJlcq3?=
 =?us-ascii?Q?so/ZpB8Y1zrWXZHZlbNIw9urRmM4rDJbNJxLFMaL/LIiWfLdZ66R7cDcAZvx?=
 =?us-ascii?Q?B2R0d5qLiIQLma0JftA+w7HavC7iwt5rdPV1tC6C78H3zqWJHBFgw6qS3yrR?=
 =?us-ascii?Q?PqyKtIFIpEMcMsqnE+ArStICExh+G3TdmgLKV+0DtFnSosG4WgUihKJIq9Ih?=
 =?us-ascii?Q?2ZSG39r+SXveyUG5e7xTyGrwISaYkdyAt5WauHPB0u0/77rHlR+pjTxsHDo0?=
 =?us-ascii?Q?mtltPjYR4OybybxTtkEXaRZ5yDMJiAwyFHiHXmBJn55nyV5VGu72GPuwluzU?=
 =?us-ascii?Q?tRECRT6VGLdz+MkLUXtTxrhEH30Vx4pjDJjKaB+xejrFYndEuovOSjj+5rmD?=
 =?us-ascii?Q?IdvAFxNxXp8w9VnOKz/9hQyGSR+i6KCUCTJtlnlxciTsajZVNlPalANgFYQV?=
 =?us-ascii?Q?l35O+JA10ZaV/DOzbkC3Bsw4EEMduVKa57RdC8CpztBL1MMbeup/M4MY18LP?=
 =?us-ascii?Q?ipgGla9DE/oJCabb68A/rc2BDGblBBTsyGVYyTgguqXwJV+ra0vqj9J2h9Wc?=
 =?us-ascii?Q?yRLD3xRxjLVue0EgAZ2ugTpQijIaNRca0pu/V1LQi17Y6d7tXaxlFyjoO8Z9?=
 =?us-ascii?Q?/T/oNAlWh0F2q8qv2gHtVccGFvd5bQjrObzfgxWmSQicg2VTd5Aa/Nyn4VPY?=
 =?us-ascii?Q?xHhKVm6QMZNJkk5i59QJBt0jYZIrTaputqSa+XwJ0q4epBMNhnVyZumPGIjJ?=
 =?us-ascii?Q?YJytUymoVC949vVj0B7EL34KyKAjPLqPBT8xFtv0yjGRc1SMPncu6DiRNV50?=
 =?us-ascii?Q?2KiZ1OT0pgZjFG/9mQJ5AD+mIzhYbLyhQ69oKMJo1Ra7RhSntilDFPc3mZs+?=
 =?us-ascii?Q?/nOFkEMtbPAFujFpfkQ9YHiTU9DVbOyuOP8o952nRTicEn40dZAqysU0ulDI?=
 =?us-ascii?Q?bbrT6NvL2EzUPMutU9DTiXWSaHIw/+J6l2lC7M7217qDA8KxYman550WXrOB?=
 =?us-ascii?Q?JGInXcdCbX7aAKEw/Rgq/PHU4bNSsmHs81KlAZACGL/Ric7+x1t+qKK9BL9u?=
 =?us-ascii?Q?BD6QY3n/Wyc1jxQgfXv9nx1h9wPL90viSja7CgY9rEikF30lCRvFyZewK3Pq?=
 =?us-ascii?Q?8UadPThmoGSfjv6uq5lkyBpaFCE2XSdNuhcE61Qy2Q0Vn8yvW5hZGK+rogUz?=
 =?us-ascii?Q?a62mF/HK6w+H6Nen7s2ZwgPuFAOn9yfUHZ3xi7cyZpgt83QlHX+81qzYCNzq?=
 =?us-ascii?Q?vOmkxHY1jPPpgz+GFK1kNCF6tcQiW5tFCUzsSInyKNEqdrVHDuO9osIgfaAP?=
 =?us-ascii?Q?RMcFkonBVdvdgSFOD5nxdP2EAqyMBCmihMPh7hSV3cUmtrmoIreJ9rZ3yTjQ?=
 =?us-ascii?Q?D2eyMIYEV7+U4STsmhcaPRDfNRstYipGlbFESgMCEtqFYdZ3FLatTpGhi/ZV?=
 =?us-ascii?Q?tfIbkF+N+IQzJyMSPnNVNDYYRQTDHh3ZtrtomwOvbgycmiYfANK9INXvhE83?=
 =?us-ascii?Q?C98+G7TRxeVNHwO8IaOxrvA2BcKwX7FRofzScE+D+fSOyNTnAMiCjj4rnWlw?=
 =?us-ascii?Q?g6ufaB2Chg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f1d862-f3a8-4006-8dea-08de5ff03c6e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 11:10:54.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1oTGaJKyKCbyWj1jCfcxHO9LXKRpvIrLpaOgjTJykkpBTCo6OEAm0CjeXONwrrJENIexpUYE/1kqYoNoJKNqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7712
X-Rspamd-Server: rspam12
X-Stat-Signature: 1x65jpbrs8digio1e3em17y1c4pohiao
X-Rspamd-Queue-Id: 1BB6980002
X-Rspam-User: 
X-HE-Tag: 1769771459-42671
X-HE-Meta: U2FsdGVkX1/jX+1Ifgam0eb7HWItUpRCpxRJhT9dkyK1Dez+okg+ixTRvxNRjySLDXmgEh5ljOzIoPjvvv0YnA6pdu7quv2ouWkFEPfvlJL5yoHJGuQSqBdZNsksZIKA3FR7xYX9qZF6WtWr6BY2IbCxKHAcWjCT6yVJ6HjZSmgupcJdDvoKC8eFan4LuVPUqlStSsUrkkbQt4ImPmsPV7WCEqXNo6GYM38hieINLfB15K1j2yF4cj3jq6l0KQdBeFOfN1JYFryVkO9JZ/UuCx9eC+7/ve6ttJmn2l24NFnhxen7lvp2Mj1U/YCYT5TfKuRTXeALOVTxnOB3bEU+9C08Fmh1KCX+MhyQxRa1MYPLVFKiSA856xfA25KDaSO09US/PEnKNrF0YaqBdufQlS/TKha/ZdNz4gcl2TdTdTBnaUkaPZ300p3QZMuZ+YmhyN7jnsCaTeFZsnkIiWYCPISLFw1YqcznLVRMWVRpEvT3WAnC3sHA8hXeJ6Dfvp9yLIvyKr/2mWcLDqRl7lbYMPKsT9U+ycfCuXECuWFxwryr2b7o3qgxaFI1LDRxO3w/1Vxe0WQhPnm/Z9K056j2KSLmh0/WrVxu0t3hGz/CFnaPhrJh2ipQrE5c9cLFv8Z7NCKvczjXsxUaW5S9dLllrMC0Eia3EamPHVXZo1NiVcODllRGGIYqFSo/cwAYmceGxSK4eqWglKg/NTF7u/qBsFKSXf281Qi9419EKIBQQX+YzcMwd+Duc8sZxIKBgZ4PSOVwaXNZqm3OeEqa0RlrwgIaO7XcbOCKAVV4WcY3NsWs+lA0KOpycN4Zu4Qv0/8VYtAOFjw2kXDeh8mx0m/kVxCrNwOMY3PhLHuiF7qp3A2LatE9FaC742YuaxFcRXSuHtfIfYsjuuka/J+QxQhe+lg0DQsS/7L6ribs2HJ3LG+vVP6urDNb7HSYVuaGeljZN8R1T5YjZ6KiQBbzJ/C
 GAlWbIBo
 Sxx4EPixobj1AiHM5XopKnIi/R4k+KagRNViBiNPq5cSOxJq1RjLdgWJp4ApR2aCXMqq61cRWLPyNC/PcQD+6kpPFA0m/2hBRm6wrq4FSo08SDJG6yrRCqm9YqT0zBNUkFIukcjJV5z4RAA03hCYNGQgly9qExXNa0q7nwsIZpNQJ7/BZeA56LtB/hw2kygKfhbhdwNofqhkqGIsLLTNMdZ0yEvkxJRG0S10WwX4I1REhZInuOyxY+Vxt1mffgI6vH8Fd6ehIILUugz5pGZ5L4yVd1JEJsOMuNssiLL+tLqGSKt9EZjE5hmLJkfhcF2wUxCIT9wV34C25Y2oOTT+BKBTI5oegAc6cAN0su/l1kWPiCQOwOU/5cS7ssOIeIdYBBb1SpW+qRNNo6rk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Apologies for the spam - I missed squashing in one of the style fixups
intended for v4 leaving device_private_entry_to_page() in a broken
state. ]

Introduction
------------

The existing design of device private memory imposes limitations which
render it non functional for certain systems and configurations where
the physical address space is limited. 

Limited available address space
-------------------------------

Device private memory is implemented by first reserving a region of the
physical address space. This is a problem. The physical address space is
not a resource that is directly under the kernel's control. Availability
of suitable physical address space is constrained by the underlying
hardware and firmware and may not always be available. 

Device private memory assumes that it will be able to reserve a device
memory sized chunk of physical address space. However, there is nothing
guaranteeing that this will succeed, and there a number of factors that
increase the likelihood of failure. We need to consider what else may
exist in the physical address space. It is observed that certain VM
configurations place very large PCI windows immediately after RAM. Large
enough that there is no physical address space available at all for
device private memory. This is more likely to occur on 43 bit physical
width systems which have less physical address space.

The fundamental issue is the physical address space is not a resource
the kernel can rely on being to allocate from at will.  

New implementation
------------------

This series changes device private memory so that it does not require
allocation of physical address space and these problems are avoided.
Instead of using the physical address space, we introduce a "device
private address space" and allocate from there.

A consequence of placing the device private pages outside of the
physical address space is that they no longer have a PFN. However, it is
still necessary to be able to look up a corresponding device private
page from a device private PTE entry, which means that we still require
some way to index into this device private address space. Instead of a
PFN, device private pages use an offset into this device private address
space to look up device private struct pages.

The problem that then needs to be addressed is how to avoid confusing
these device private offsets with PFNs. It is the limited usage
of the device private pages themselves which make this possible. A
device private page is only used for userspace mappings, we do not need
to be concerned with them being used within the mm more broadly. This
means that the only way that the core kernel looks up these pages is via
the page table, where their PTE already indicates if they refer to a
device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
use this information to determine if the PTE contains a PFN which should
be looked up in the page map, or a device private offset which should be
looked up elsewhere.

This applies when we are creating PTE entries for device private pages -
because they have their own type there are already must be handled
separately, so it is a small step to convert them to a device private
PFN now too.

The first part of the series updates callers where device private
offsets might now be encountered to track this extra state.

The last patch contains the bulk of the work where we change how we
convert between device private pages to device private offsets and then
use a new interface for allocating device private pages without the need
for reserving physical address space.

By removing the device private pages from the physical address space,
this series also opens up the possibility to moving away from tracking
device private memory using struct pages in the future. This is
desirable as on systems with large amounts of memory these device
private struct pages use a signifiant amount of memory and take a
significant amount of time to initialize.

Changes in v5
-------------
- Fix broken device_private_entry_to_page() in v4

Changes in v4
-------------

Thanks all for feedback and suggestions on v3.

The only major change is using devm_memunmap_device_private_pagemap() in
xe_pagemap_destroy_work.

Note removed previous discussion in the cover letter relating to aarch64
and memremap_pages() as this was actually already addressed in commit
eeb8fdfcf090 ("arm64: Expose the end of the linear map in PHYSMEM_END"). 

Details:
  mm/util: Add flag to track device private pages in page snapshots
    - style: move logical continuation to previous line
  mm: Remove device private pages from the physical address space
    - Use devm_memunmap_device_private_pagemap() in
      xe_pagemap_destroy_work()
    - Replace ^ with != for PVMW_DEVICE_PRIVATE comparisions
    - Minor style changes

Jordan Niethe (13):
  mm/migrate_device: Introduce migrate_pfn_from_page() helper
  drm/amdkfd: Use migrate pfns internally
  mm/migrate_device: Make migrate_device_{pfns,range}() take mpfns
  mm/migrate_device: Add migrate PFN flag to track device private pages
  mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track
    device private pages
  mm: Add helpers to create migration entries from struct pages
  mm: Add a new swap type for migration entries of device private pages
  mm: Add softleaf support for device private migration entries
  mm: Begin creating device private migration entries
  mm: Add helpers to create device private entries from struct pages
  mm/util: Add flag to track device private pages in page snapshots
  mm/hmm: Add flag to track device private pages
  mm: Remove device private pages from the physical address space

Jordan Niethe (13):
  mm/migrate_device: Introduce migrate_pfn_from_page() helper
  drm/amdkfd: Use migrate pfns internally
  mm/migrate_device: Make migrate_device_{pfns,range}() take mpfns
  mm/migrate_device: Add migrate PFN flag to track device private pages
  mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track
    device private pages
  mm: Add helpers to create migration entries from struct pages
  mm: Add a new swap type for migration entries of device private pages
  mm: Add softleaf support for device private migration entries
  mm: Begin creating device private migration entries
  mm: Add helpers to create device private entries from struct pages
  mm/util: Add flag to track device private pages in page snapshots
  mm/hmm: Add flag to track device private pages
  mm: Remove device private pages from the physical address space

 Documentation/mm/hmm.rst                 |  11 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  43 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  45 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |   2 +-
 drivers/gpu/drm/drm_pagemap.c            |  11 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  45 ++----
 drivers/gpu/drm/xe/xe_svm.c              |  39 ++---
 fs/proc/page.c                           |   6 +-
 include/drm/drm_pagemap.h                |   8 +-
 include/linux/hmm.h                      |   7 +-
 include/linux/leafops.h                  | 120 ++++++++++++--
 include/linux/memremap.h                 |  64 +++++++-
 include/linux/migrate.h                  |  23 ++-
 include/linux/mm.h                       |   9 +-
 include/linux/rmap.h                     |  29 +++-
 include/linux/swap.h                     |   8 +-
 include/linux/swapops.h                  | 100 ++++++++++++
 lib/test_hmm.c                           |  87 ++++++----
 mm/debug.c                               |   9 +-
 mm/hmm.c                                 |   5 +-
 mm/huge_memory.c                         |  43 ++---
 mm/hugetlb.c                             |  15 +-
 mm/memory.c                              |   5 +-
 mm/memremap.c                            | 196 ++++++++++++++++++-----
 mm/migrate.c                             |   6 +-
 mm/migrate_device.c                      |  76 +++++----
 mm/mm_init.c                             |   8 +-
 mm/mprotect.c                            |  10 +-
 mm/page_vma_mapped.c                     |  26 ++-
 mm/rmap.c                                |  59 ++++---
 mm/util.c                                |   8 +-
 mm/vmscan.c                              |   2 +-
 32 files changed, 783 insertions(+), 342 deletions(-)


base-commit: 344db0fba38920be64a429c64a8ca0531572896c
-- 
2.34.1


