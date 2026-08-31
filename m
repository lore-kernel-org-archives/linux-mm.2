Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58F92C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5006B0095; Mon, 31 Aug 2026 15:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55BF6B0096; Mon, 31 Aug 2026 15:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFD86B0098; Mon, 31 Aug 2026 15:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5706D6B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:26:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A86824022E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:05 +0000 (UTC)
X-FDA: 85162545090.23.738266B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012065.outbound.protection.outlook.com [40.93.195.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE304160003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:26:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AnLySJ8x;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
	b=O3CDse/0EW232t3GXn5aEQm0y/1DZ4SX8adZx4pfbqMdmj9zdNiOGvdN5W5h4EpsowVTh/
	5OKsNYkxfrursfzfWZ9exIoUkDJzs22EbFa4bx18QDZZuPFtljR9VBjB+EttrNvUXOXApf
	4ZdP7mfHMbs+BZkXgizNr9XTo1THVXk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=AnLySJ8x;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788204362;
	b=On75Ba/yOHxxQe2RdczSrXCtrZ51fKkyBhlgQZC4Sj9e49PCqau6MmcemgZZaXKaha8lGP
	J44cvZlK5Y/faKmaUYYWuQyoUuCYbG6eR80WSAxWviCN9lGPPW148D/YMO7oxGTHD2Wmh6
	J5xdtMyzRVwAKNtlUKfhduxNu438jwA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qopNvCqwyjtINHg9KbusDN8tI+0areZ/p2iMXRGmfQddrtJNvqMjVgiQgY0bx5vzi4mwxMSMTb2b7TOl4/ezw2+k3v/CeC/EesAdXZEPhlAV1PsSgEEetHjQi4i/xT3Wf7S+V7jhEsb/YjVYRDwTbJlu1m5FyApQ7fMijSgoai8pPBxIrP3vq3xEjW7YhnAwKM/A/82CRYU8I4k0PDos+/+Mh6jxLwcZL8r8en16Kzkhi6+utMXGNPUFtbTF2mSzqEbvmCbfUPxUYjhwuXqHGOA4mvUC2Qva01U6tVHBcHG+7ySHt5WzrXHr+vr0dcjRjXsekd7wOkrpnIClHHG5TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
 b=f2LXQUURhP00OpgtDmhaFE9YQ7KsUu1XBNpnFhT+bSa7mRif/K2BNMzxGW31t2+S8Od5hmQyZkEf4Mip8OUDXZjzcQl1RjbGd2qPv9kru/0Js2onb0tw5lH9JFY5/tWRPxb11iptCszJWqINkV4vYuBBxMMdqWfr3o8kLx8m7M3YoXhxmr4J3GhaereTASG7YSp0932dA4+AYNYTVsk0cx3lHaVRyMrRc3Nq6aC5jmt7lvQIEYivI3PBW2E8IuPSv1dfTUaEnPM9CsAfbP2KuzNBYdLWT0YFMxxlbORZM8vq1GqFUWhZa9MXd24UwbhxpoF4KsLNc3jSoHMdRC8bmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgf8AR8nU41qGg9Ak0WHclMBa3GGy6njR91QTF4tAYc=;
 b=AnLySJ8xNyZ97ebPFNXZN29IGldk9Fty9paw9T41KDk9rwXaeBRhSKaGvoF7a/hKJiZHRNC30iSqBVI0bmNdrhXb4ZRqVbVDjISFRj2xzZxjm6E7TpMAAZoeaFLA0iYdYPkF3Y9Ocp08qJmXl7QuuSHZjYak2hTPKcBAHd2jH5wgDRiL/Jo04dT5/FjY1JHPxjOLE3BjHDyifdFKQkwh9jzlTUuijhbdN22fbgUEHTUvZUGobM8HA02NmmBB/uvxmLQ+1EPCRO0UVkCmEHdbP8HXGgnynfxTm2wuStx3ADPjR53oLYgncObo4D2HoNEc5i/AQzQ/iA8A/HqzHltkfA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Mon, 31 Aug
 2026 19:25:43 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 19:25:43 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 31 Aug 2026 15:25:26 -0400
Subject: [PATCH v2 03/14] xen/grant-table: stop setting PG_private on pages
 for grant mapping
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-remove-pg_private-v2-3-3668159cd9e8@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 xen-devel@lists.xenproject.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0103.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f3a1d50-becc-4928-7fbb-08df0795a654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|56012099006|10067099003|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	mWERXMMjK9kQc2LiNejUQRK8WVGOshRURzBVv5kubt6tg59eMCzbkoP4OWtVgPlHNRKGTtgg2dD4ekqzgQWaknj1rjm1eMjomysCajReh4A9zyl+yzoN091myPm88eBRn+gpD7sNnRMc36CdAcJbTF44jPAB+sWJOQ8eXRbzRLbOo78ZqYO3S1v3IF9Fv8RVPXLPusaXoO168g8iYjd9MRPt/WlIpUj82NRMNe3qewpA2hRCXjTGtEjrUhhDc7LSRSNjaa58PxyzAJOv2NFJYAhk8sx4sl87hUY/OA4Y2MLTrqkZYvtmttkrw4xgmLx9i/Bk56iW+MJhzYhc+RpVUus3m4WgtLHIM8IVYO6ElxcpEI9c95ZLePJdgvb5LjAsdILL6fw+4h4aeFKE6IT9m1bxK35AfIXdc6uXEKnGsooKZqrzuB0szfn5iaXXT+EG8ZtJkeoBsPIl5EmiwZGYN2qL+BYNGkgioNrrLClo04Y+ESsFM7h+26ebpa6JYAuYYsZbu5bz9KkVVeUeSTUqx3hGnszsjyJ2cQFAvqD5RieMpTswT/0WlMCSW5oAstG3mO/yRav2o6i+CzZ9CVZVlxubZs35uRp7oQyLltTbuODYIEqSA5zK5tNuVm4U/2s4y82e31iJSSBhfcQUY01lUM1AMKjgVO9+0TEEmX3hk03gm7D4CM45Zm1E3st1cFNEafO9O+nDof747nTgD2ZtGA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Unkycy9obmpOTkpvN1ZWd3JLeU5rS2VmditaUFNJOVRMZGh1VllXbzNlWm9R?=
 =?utf-8?B?Smp1bkRkeXdTZTdYeFBlWWpsSVp2TFJHbURaVU9IcWIzRk5qYlVJS2lhaVZK?=
 =?utf-8?B?SnZOdFB6dE45cjJ2MllPZFNkamsvVmVRdDIwWC94UVpiU3JWUzNHMEpnSUJV?=
 =?utf-8?B?S0ltRmk5RzI2aUMrTHM5dTZpZVBMNTBMRmI3TEt2WUVoUjRLK1p0RjBaVFYy?=
 =?utf-8?B?NVhKRHYzcU13K0c4ZlJiWEN6aEdEaWFOVXpZNUJLVlJaRG9xZ0ZyeXVQVFlt?=
 =?utf-8?B?S3lxV1F2WjlzYnB3SkhsMWlSVWoxcnZYNjlyMnpZRVFWemI4T1FkUkY4NGN6?=
 =?utf-8?B?bjQyamwyajdXbWRMamhlRlFMdUsrWFdsdTJrVlZJT3RJcUJpNnZWSWJWT3dt?=
 =?utf-8?B?N05kaEdscG9GamNoa2lwc0Z0T0NlTkxKVzg4b2ZSR0VvVDVEU01qUTZVTGp6?=
 =?utf-8?B?NWdqbXcxSHpaZUVlVFErWU5yT3FtdGRoSkZ4bSt5M3Bjd28xSG1tT2VFRk80?=
 =?utf-8?B?Z3poRlhTS0pIN2E3eFhTNFlTdWNWNjV0VDBwSGJpUDRHTmhVdGZyKzZpMTJw?=
 =?utf-8?B?dm13QTdiSmlYVzBpWlE2VEt0THczNXdNNW90SDM0bXpzNytWL3FGWHhBYXNG?=
 =?utf-8?B?dm1NNjZ2cDl3ajZDKzVjY05aZTFGZ1AwN3VQUkRHNzBxWGlUVXV5Rkt2bWRE?=
 =?utf-8?B?TERqWTd4OTlhcDNmS0I2dmc4b1hxRGQ4a0RnNytIbmhGK1BaSnh1YkQ2bWNq?=
 =?utf-8?B?N3VPQ0QyMm1DbjBBNGUxdGZlMW14NVg3bVoyL0s2TFpQN3ZqU1lIRU5ucDNK?=
 =?utf-8?B?QlR3a05GSGRLU3pzOGRnYTdxVk5xWWE0NFdnQTE0NUMzYUNMcE1UdVROTlJ1?=
 =?utf-8?B?WWxOc25VcnZ5WG1CWXNNQmVtZVExMmdPVjQyQzljV2lsRmVudW5TYUt5OHVp?=
 =?utf-8?B?d2tGZmVtMytaYjRTZE9vN25vSDFreU1kek5FMTVsYXZWUGh6ejJ0NzNzZ0VX?=
 =?utf-8?B?SU5lNjhGQnBFakRwejh0UHgxOGQrN015WVgvaGVENXZLWExvaGhaU3FubVFK?=
 =?utf-8?B?MXU4Vms4aFdYNVM1akp1Wmh2dmxhaXJDUEJWVzdFWGpuSE9sMFBkT3pxV005?=
 =?utf-8?B?d3JSWTdYTDBMdjFKanlRZkh5T20rcjhTUjBmU3B4ajFkRlBjMUJRWmNaRU5K?=
 =?utf-8?B?OC8vQ0dJc01leVl6d3FMdktERUVVWGh0TnllcGRSK1BJaU1vTGdPVTNLNkwr?=
 =?utf-8?B?T0NuUzhwcUVnZlhqazZyTnFlbm9kbk1uZk9ib0hBbEw3SVBSODlKUmp0Z0Ez?=
 =?utf-8?B?SEJ2cTRqZW5YcHppUEpjOFFIK2llVWdydTFqT3VBYW9RSU5Oa3VXeW1DUUZ4?=
 =?utf-8?B?TGxYVlM2SFkwSDdMVnl2eGVwQzIrR2toMWI4MTRQVXJaNjJ6d1RtVXcrenAv?=
 =?utf-8?B?Rm5PU3ErWHBPRnVtS1RlLzllRlVhdnprNXprZVpCbTRhUmY0dktHZWxNM2Nq?=
 =?utf-8?B?cnIzaWYvSDU2YU5RZDBNRlRKQmI0bGdrSm1DQW8zV3JsbkdjU0RNMGgxd1N6?=
 =?utf-8?B?WFlPMTVzb2lwc2IzdkhJbEIwbHJIbGYwVkJQS1dQWk9IT3RNYlFONjBJOHls?=
 =?utf-8?B?QnJleHQxdlJkU2ZJdlMzdlk2VXFiaFlJYkZVUGdTRksyK1ZrV2VubFRxTWVG?=
 =?utf-8?B?eWxYMkEyKzBQYWVXZDhqWGRsbTVRQWpaeUxOR3p5c3J2MUh4encveVhCaW1a?=
 =?utf-8?B?RURMNnNiWXpzQzZVV0RLR2JiM2dIS214QkRHbi9UbUdENzVYUzZ2RFRYcW9p?=
 =?utf-8?B?SU0xdGUvTGIvbk9lLzFJNVdWc0kwbUplVFAyV1p4R0xmRmlyOU00VWIvWVNC?=
 =?utf-8?B?aWdvQitDZXU3L3JxY3phOEVzc29QdCt6UHFQM0k0Vm5FQjkxdlRUWWpXT1R4?=
 =?utf-8?B?c09zbWZVWTNMWVA3bU5NNkQxZHF4US9YYVhPRVRMZ3VERWMvTEpoT3dOcHBj?=
 =?utf-8?B?cUFJTU1oditJL3cvZHFwd241SXpweXc5cml1dE4zSFRqQm5QKzZxN2plaGtZ?=
 =?utf-8?B?bGJVMHNkRk01NHV0dlJwVWdjekZWWGpjQ3Q2YWdFd21HYzVoOEhsNFJEUFdK?=
 =?utf-8?B?a3lWN2dldW5zNHlYZkFDVmlJRWl2YWFhOXNzMCtVbkFrS3RrVTRUSnNFWjI5?=
 =?utf-8?B?QnJ3QlFKY3E1TkFzSTRpaFlKRS9HVnhyMWd4TmsyRGJ1TzdZWUc0RHFvT0lT?=
 =?utf-8?B?VHdZdGhIdW9FK3JTNVlDQmNrS2VrVVlQbWcvTk5DdDBBR2JmRU5sSysvVWVG?=
 =?utf-8?Q?AKlLLk6vDlpkxTZPiY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3a1d50-becc-4928-7fbb-08df0795a654
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 19:25:43.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heh0HNNMPmEJNhwU8XKnYC1gTFrgaH3kmSa5bDYXRk9YZqvFD+ymQxvIlCBaZrzc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE304160003
X-Stat-Signature: w1gzu1fccus1sjam5dri4h4kc1xkthy9
X-Rspam-User: 
X-HE-Tag: 1788204362-402203
X-HE-Meta: U2FsdGVkX1+NfpSal50/mWuxDBlmVL2m0M1Hi8rs9IcVeCcnZM73sFZ8uva5DfZ2LRVd6piNUYIR/rcwlf4W961yYqm6W3Qb8qaoZoG5S2ZLAy5Gw2WwUDXGTlxEYG+LOJYzntVd5gcbPAgyvSof9A+Q7moW+Nu+qMtE7zKKug3JdA/kKAaNayjFCVXwto50RxsAPhFgfg1SNkJt27fdLIMp7qdQ0fOPIx9k57D96mJjVDmVeMDXVe1BAAVB48vMow058CDjL/h/ndn4OWXdBpS/gEMJzSKvLvLQD1p6CbjCvQUbIt0VZ0HaGkiF9m5kItH01KjVFRJiGPfVFb3pXD9WBmpWekmRl3vmWAh3ZVdqDQHSoP0bl/NSsXSgUj+Cff8IkrJ1aOeGEFBkx5ZVogGVbZKl4++0Mzg3nLs2H0QzTmzz+h495//RanZKdk8sgje0Zm66sn8zdLN6UHfriWITYXobF82MoPyM1BDtjSCg4tZfWPXkUO4siTp6a6W32eowT3FGZYHDEowtkpUxZAkpywQZHiZQSMugq/6v/523T1mP9o3IRaPwJjB9NoaMzXMRccCfRdsMQbOsqZ+trmw+NZyi42OCu7V6kyKv8VlhV0xjVnn9DCYXj1kf5azs700AGOCjuoJU9dYPLuWD2rYS4qR0ouflauIJOJeGrTNGFu6NMAUc+T1gVY73PxFvEH004bmrQSR9OZrMHiPJYxTsl8sfFw2+h/cDSmDHbloJdvCsqC2UjCvg1WMjeBrPeOToWvwrw6gw7WGCqjmlzX7UBSirTmtZ52aPHsOd986g0anCotjCLvk7uaTcFe1xBDvpAVfGH9l3nIbtP/umiccnvXMbYMF03TEC6GgpW6TWijEeqjqy6GRQje2cHh4kf9piGJT8fGlV6IAHrk0y3JbAoFE6G/AjDuaYuwBBoL7WSfdNhH7HycQkb72z+tD/u29z8eQCcfWY1yObGTU
 h2LwzSMc
 6hnr2ORszsKhJ4VQ0QbGYbsEHCxTvoqK3/bisvHRDpSefYMrwwk9ZxvgCGQRDlMVq69ziFu90yxF5s7clcer5h7dLJL/+Cujzui2Tx4ry61D5gVg5sLrc3BrJ0wO03FPOTLwoZI0t4DFu3W/m5UF0LWLRdSJS/FbPC+694vx2fVVupB5MZURUewW30UWJFAP5+IqfUt0wiC8FkEZuag3cludGcmsM6HD0Y1RB9ZiI0HYxF9oJG34BOWf+lMXHWA48qVxYMBW+11NGiQd4moKj+CxTUr/tbAJxsQ9LdEondt+9lILSv871laVhwUTXPHASdMmPPodHSvsN9NbwRrVCiwgJNpNIB65X8RIyld9Lo4Z784U8B/ycKphKS3PmV+Tx81Khe46FN7fGPVzh3pRvCYTnkwo3lALMu5EOlvHQriNeSTls/qY4G3VW0pi1WkRmGK1VzboQosOqYmOyjFjyMtQA+8ksEwP/XOUfTWYHBbKrR+SOetpMI7w1KYgli7nKj/6ET65136UhoflmomHEyj2HyTKpA+CQoxGKgihlvJIuT3p+uNjY5ziUW5QxT4RW4Q4KeiRBcpOFNaF1Ba8LJBEXxJAqW0jBsE8BXxtJEf/A+SE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
pointer to an allocated xen_page_foreign is stored; on 64-bit,
xen_page_foreign is stored inline. Checking page->private != NULL is enough
to tell whether a xen_page_foreign needs to be freed on 32-bit and
page->private is zeroed unconditionally on 64-bit.

It prepares for a future commit that remove PG_private.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Juergen Gross <jgross@suse.com>
To: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/xen/balloon.c     |  5 +++++
 drivers/xen/grant-table.c | 11 +++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index e7f74ea7cd5eb..fdb18348cfdfe 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_lowmem)
 
 	__ClearPageOffline(page);
 	dec_node_page_state(page, NR_BALLOON_PAGES);
+	/*
+	 * clear page->private before giving it out, since it might be used to
+	 * store xen_page_foreign info.
+	 */
+	set_page_private(page, 0);
 
 	return page;
 }
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 69922be28b54c..993f89f048e21 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -863,10 +863,10 @@ EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
 
 int gnttab_pages_set_private(int nr_pages, struct page **pages)
 {
+#if BITS_PER_LONG < 64
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-#if BITS_PER_LONG < 64
 		struct xen_page_foreign *foreign;
 
 		foreign = kzalloc_obj(*foreign);
@@ -874,9 +874,9 @@ int gnttab_pages_set_private(int nr_pages, struct page **pages)
 			return -ENOMEM;
 
 		set_page_private(pages[i], (unsigned long)foreign);
-#endif
-		SetPagePrivate(pages[i]);
 	}
+#endif
+	/* Data is stored in page->private on 64-bit */
 
 	return 0;
 }
@@ -1031,12 +1031,11 @@ void gnttab_pages_clear_private(int nr_pages, struct page **pages)
 	int i;
 
 	for (i = 0; i < nr_pages; i++) {
-		if (PagePrivate(pages[i])) {
 #if BITS_PER_LONG < 64
+		if (page_private(pages[i]))
 			kfree((void *)page_private(pages[i]));
 #endif
-			ClearPagePrivate(pages[i]);
-		}
+		set_page_private(pages[i], 0);
 	}
 }
 EXPORT_SYMBOL_GPL(gnttab_pages_clear_private);

-- 
2.53.0


