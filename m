Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A56C5AD2C
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78E566B00FB; Sat,  8 Aug 2026 22:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BF76B00FD; Sat,  8 Aug 2026 22:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9716B00FE; Sat,  8 Aug 2026 22:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 234E26B00FB
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:46:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 989B64049A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:46:30 +0000 (UTC)
X-FDA: 85080192540.07.43EF834
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011056.outbound.protection.outlook.com [52.101.62.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4F08180008
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:46:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oA3+/uFd";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786243587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/tMtaUP0qDQqX75sSzSv9OYCsZRvD5YbQxLwFKgY/Q=;
	b=0AY6pmVSx5QtSm2xbe5p8jBzsIs+X5j09L+PG9gBBKFtgrWMYymuXIX7h8UBOH5IvZPvEa
	d/OKd0BMN8i+uaCBL+0rf1SrHAdhsa1B4rwvaDW6SyFVVs1HP/vtWJGNSYBaWKEg+4s15s
	baBg0ajAbvy6G9B+Wk9RKTwkugj+C8M=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oA3+/uFd";
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786243587;
	b=zXHJLu4c/6gblMXMJWy4QS7ZvlyjvicXuALW6+S0EJRajBuxV7RVgi4nvkGAiySwyP8B3X
	rD29D56gwywEPVIyFk3XjwwxdCQKR+9rjYR4RMPRxkmMryMpBBM+TM9fVZefUl7mS8AKC8
	uESVZ0qzCyDIRC59FRfPKQQeDG+eciA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uyg+Th1o+B/00u7oZ+5rUE4jzhf+9SHAX9lOEnpeCOh/fBhz1N+5+nQ9aBTY9X/k4qedKFGfvVJV3jwgJc3qE+Dw6DmW8+QufPE5ZK//K/FhfnFoGOU0hpkEW5g8Eeq9IBHsTNBXaf8EIEWyuaut8Obv8pl/NuhLsHvzUi7hl44z0TP3hyTcSrjYGRjUke/EPJ14op+Rv/w/6FsXy0y41pgxf5YNRAbnor9cM83W7+gnOFj3qZ1Zl4IDfm2Ta0sq90Nblxhc5iTZbgHShCsz7gV172g8oWuKquCeJraduk44lhPkK3dxUMIAAJec2wKHaras9IN1m5KByr3cWs0srQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X/tMtaUP0qDQqX75sSzSv9OYCsZRvD5YbQxLwFKgY/Q=;
 b=usC22nEu/vtjnbj8gnkBNLb0RjBAcpOHqCzX2bNtT670OJPRHmxOPoIzIY12Kw9e5uS1iUT8kvI3MRHFG6Fkz+y8dNymOQd/6GqF3PD3/XMnpYMDgFLbe640LdmayWGKvMTIwO+uP2J/GkM2fTxXi6Bhn/kWUw2pw9/VPFXtO7fNd+2GQAktTKV4IXTXvMraOWclpKa2cTUfnO8/qwSW6BbkqHVaghZK0BPyQDt0GLS20PImuwbqZE89KB2iYLn6xKnGl+vH9T9PlmJDlbBAE4h4/4gZxii9XAFw3VyNZFf0sZviBqJwNJEN1SZG1G+vDAReE4HyG2iM+JspDcZtUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/tMtaUP0qDQqX75sSzSv9OYCsZRvD5YbQxLwFKgY/Q=;
 b=oA3+/uFdw4mrMJG9b4yF7YMdD+00fp5pDC/VryvxbP1VaNYX600YpC0PcfMSrX9OzrfCaFz+xBqyZE8wS5Vw6Ba/LKRLDZLXkoGa7v+cwQ2x3B8sqrZX7OQkLPy/mGHfNeHrIXdnEMwJgUziQEaR+aES7osciUnLv6r4KDy7GZ4gqdZMbDCRwtfsM9wIoYEXPJBtvfLxzvJrTW/CRXqlXUUMMaZ2lZ+/EZLg7n7sm4G6PnsqjdI1rWQhkgXLV2jq39OW+2wppS2S/huOo02vcZb6X32+f8q7ibQE2U9VCkJiThO0P1+QJJ4js8QxTpTdCEueJ5Omwt9oVAb1ItiqtA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6648.namprd12.prod.outlook.com (2603:10b6:930:3e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sun, 9 Aug
 2026 02:46:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:46:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:46:22 -0400
Message-Id: <DKK2I5CAQAII.ICGSW4XM9ZV2@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 12/13] mm/huge_memory: lift order-0 restriction for
 swapcache split
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-12-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-12-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BLAPR03CA0049.namprd03.prod.outlook.com
 (2603:10b6:208:32d::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6648:EE_
X-MS-Office365-Filtering-Correlation-Id: c72523bb-d762-4606-9492-08def5c06658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	o5rhBKiul3NdnhVAe6eqPx9sAQeDh6D4mKYZjfAYqomXndwjcDNbxn5tizg2atRmD/1z1qSUG/xUuU1OvWq4jak71qmDhN+YFp21bZCeiJlpgd5Uzab+sS3vDiSfe7mtppuNBJy2Dq3E56Gc5MytEN+Zu2FbQ+aFiuDccWlNGljr58OqHyJNYwb0IZqUh0bAUQO/l3NUxj2rEWnAOpgpg+lRejdCU+khA5//KdLbl17x7i4B03k1N/M246aNWIRCKYX8Cvv9Tj9pf88YxMXCak+yBk2XIfODoQ6FSbawGc7jNNQo5fVkHlflIlWMZbFbsoVg6juhJjTb4ZYiLgdWS8G4ca3oi/W0qJOP7eW66E/FEXqRlPItKS9iScGo0F0fSSJXio3GQyFmzbk0Vkn4CDqDqaaewxF3qUXZ3pNNepzZ6mmbBVzYJ6WU0bnkCJ8vb9xwoCJO4hdqlLn2DYhDwZ4WNmXlpLTDPe/G/ggtRtQoW4ndnhA2B3bnBFrE2v94O+6o3N9XEQW8Y3QcarR44gkiEkO7LKiR9FbHdxc2/WEMilFeI1d1N9ZqQUFFDidVrb5ND6GN9rx2tz8790nPY1PdtYDpbRk41+xtToDSHtD00i8aT0BG0vNcmeoQ97/gr2yfvZJ0VbA3qz5Ma6bCPyMR7AasiHjSBXWzAdRwREc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2o3Tmo0RVRGS3Q0b1JQUmVISk4xYTFPdU5Ga1V5aGlIdmkzb04xQXo2Nkw1?=
 =?utf-8?B?bUVoNy9XMGRpaVRHM2dYY01IMzQ1ZVpwRVFyczhKd09XT0dTNStESVo5Y0hp?=
 =?utf-8?B?bHNUbzVOUEYzUmE5S3lvZ2dkL1owUU9yVzFaMjg1aExFVWRKNGRUcUpLZ0kv?=
 =?utf-8?B?NFYrRTF3b3BvWVg3SEJia3BydUdvZU5PMTlFTGs3bVZTSGUramxMem41NURD?=
 =?utf-8?B?SzRJdm9UT3ZvOHRZR29lVVZhc0lyMHU1TVhrRDZzUVg0S1hxa0NEZ2dXWkZr?=
 =?utf-8?B?NlY0REtCVHhobXNvQmRXR3R6ZWExN2gxK29aSmRnSUJpZ1o1OUtaVW9hQkE3?=
 =?utf-8?B?YlpwTGlObnljSTMxV0FoSXJ2cko0UUpXTm9EZDVaSUFWSzdGRmF3UjdYQnZx?=
 =?utf-8?B?MDRtUzlpeUFweWxHaWgvU3VZTzgycXpacDcrRWVhRTV3Y0hDUVhObDdNc3pN?=
 =?utf-8?B?enlTVU54aWZvSVlUQ2NlUmpndFNiUkZEOFVUeEVMSGJPOU5IcGZpckJQMnk0?=
 =?utf-8?B?NGRPOVRkNGVQUHNmMkIxU25YNlY2SGE5eDBTVmIyM1RjV3A4QkJoWmx4by8z?=
 =?utf-8?B?RXBta1Znb05TSWFodnlyVHVQc2s0bmFVQVhlcmpVRHhGRE01cGZDUWRLamxX?=
 =?utf-8?B?OEVUL1h3VHREU29QZ0JIa1gvclA1WVl1WFpOM2Z4Slc5YlpibHZ2NWhSZUxK?=
 =?utf-8?B?QnZwNlFwUkdGOUtZMHc4eEpwclhSd05qQitkb3pPUHRvWFl0YVAvbGVnQ0k2?=
 =?utf-8?B?WHdVbGxydUxnTDdVMEhWcHdjQ3gxRStDc3lFdzNxOWxtWlRxZDlndEgvQW9P?=
 =?utf-8?B?YTZBVjFjRFdNRjRpYmVUeExYeTBacmtWT1libW1EbWRlUVBQV09EK3RrMGNW?=
 =?utf-8?B?VFlmMU1rVCt1NmI2WXNiN3k5d09vY2s4cjNxZC9ULzJ6MjA4cFNRZjBlcCtu?=
 =?utf-8?B?RVBZaERaNHlHWEQ2YnY3YTI5WEs2QUV1RU8wWC9STG5DVU9rNUVVRmdZZkRl?=
 =?utf-8?B?dXEwTXFzTmJHOUFWV2svTTlXUTJOK01TNi94eS9EcVZoYVlXeDV6dmxuZHI5?=
 =?utf-8?B?d0llMkN4QytlS0RQV29BV2phb3BFaVBMN0U5VHlkbk9obkVDK24rd3M0c0lU?=
 =?utf-8?B?TXVBRHlqRkk1T2gzTmxMZ0lDMDBIZVB1Zlk2TnVnYTBCQ3VZdm9kZ3pMZmp4?=
 =?utf-8?B?TERjbU9qS3czZmVDdXNmdVhDekM5UGlTSzZjdlhGYlJ2d3ZJYytGVmYzUjdi?=
 =?utf-8?B?TzBjZThDYlZVbzh3UDVPNDhyUEtYOVlaMnVjOTFFb25nQVg0NXArVzZPOTdV?=
 =?utf-8?B?TW1YUk9EYzRBZzB6aGhnMGNmZzVnMzZ2dVVPd1lRNUllUGhFalVIclhKV20x?=
 =?utf-8?B?MXN4TFNFYjd6MldWZVExdnY4Q1lmQTR0ZWpOdmwyUys0YmwyaGhnTXd3Nmhj?=
 =?utf-8?B?c1c1d3hTQTg1ZGUwdlJhck1tdDhUQnpRWHluSHlLdmZ4TVIvdTZmeG1OKzln?=
 =?utf-8?B?WHlwdnVuU3hKaXFVNDVaeGhxSzVHRWhtbm9raG5xaWtZN1hiV1pCVnJMSHdO?=
 =?utf-8?B?ODBoYUE5eDBnT2pCL29UdFg5SGEzRnlkSmRwTlNQTm9PZkpub0pidnF2T1ov?=
 =?utf-8?B?REZacGxvMjR1eGlLTHg5TGQ3NWYvWi96SnM2RkFUakdCZDEwMEc5ZjZYL0FZ?=
 =?utf-8?B?NVFuOWVyNnBHY3JnT0Jya0xEQmJPSTVOaEVjNlpJSzFENW0yYUJRWnVLT3Ix?=
 =?utf-8?B?TndKZ1FIZUdXdzl6SzlEQjRkZk5FeVppMHJlNm5pUTdRV3ZnZXgzejFIQm1i?=
 =?utf-8?B?MStOMStrN2J0eXBaMmZRS2JaT0xGbWVpQWVEV3RaY0NMSm1RQ1lSdjZpdktO?=
 =?utf-8?B?MUEzMHZMZHFFRjJVSTBvNUJXdHk1UE5iV2Zac21mMERMRXhqcWFxOHNJNjJD?=
 =?utf-8?B?T2gybEtiaXEvcE9ZVER0VGJoN2EwR1RKYUNuUkF6c0I0Tk84R1Vsd1o3cjZO?=
 =?utf-8?B?WEtzeEZhSGVad3RDMmV1UlVqdTFyaDhzOWJrVE9TUVJrNHdndUJUcWxCSWZF?=
 =?utf-8?B?cU9peGxDVytHbFkvUzg2VEcrQlFKeUtLa3lJNTAwQUN4UVhQd2V1a3ZBT0tW?=
 =?utf-8?B?cUlKb3kwQUJuWm1MQTVHQThON01rVkRSZXpXTzdsZGJzSzN0c3JYZldvMVlU?=
 =?utf-8?B?SjVzdjRZQzEzOWE1eExPSURTMHdHRXZCbjF5VDY5byt4YUw1Zy9NTi9zQWc4?=
 =?utf-8?B?eWpnR3lnMmYzZS9zbTdOVEdRZ0xRbk05V2UxazdsOUNuRU1tbDJGZkczd1ZT?=
 =?utf-8?Q?h804+cxCGiwuR96nMk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72523bb-d762-4606-9492-08def5c06658
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:46:23.3615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r/CdRWkEavd6tz+2IIiva9CZRp4IYTOu/VI90qEfECF0VMetxbyS/CZ8JddIcbvk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6648
X-Stat-Signature: cw9k1mes8mje1r8j9rn84rr8egqf99m1
X-Rspamd-Queue-Id: D4F08180008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786243587-919869
X-HE-Meta: U2FsdGVkX19dTgBk9iz4dJrCCjK94upFIoj+pWB1D2+5Pqz3hjzjimUfo06+FpPwxtLPZ95N2Xf1jAwztxNeI/SSg5E5P9LKeHxhIo88F4V6WfqJS3pMeNPCbQD7/PflfJIzg9+hJWRgJ9S4h1bDMqrMqAiFLtzIo/5l2rLyKTojcjrzB+mll34mzLpmoq+dE0AA4Q1+rywqQz5Nrwotd+r2M0fYmosY8BybkQX0q5SJPMU4ihMPYYYH+tMR4UjcM4RWVThefKHYjbSMfHwGwSNKH2dbNOQM8D7sxLHFJs1GsWZPEl1hdt5vzddfnH5GdSQeRxaiJ75np2nomRsMObKuJY4Xd9+5tFGWmg+rotaLq+debIpIQUk2trFP01yb4E7jx7PgpdegV/lo/bsZgudVp1JkQBXe76Bqf0D0UGXI/e0+PI8tDF2fSStGfNZks6m4GXwY7qih2ja/+YS88u7gEshiYO6zI6DcVT7Zw1mIEv3vVGMMjmDHS7PHUmgu9KifjNYVgGpc89xAVDbx2SX3tml/n2axpLTm3HXFNCkTI6GH3s0r8vhg39m/AP0p0Tj1pNM/0vJNEEJYZXl9YJKlHakREvTAqH+2hKhgs7vTT1nDt19+2Nx1onWr1nxKTbheVf5SJGPnPzXaS/6zA8mEoT4OR34v0gPGYD1Sc+uFDM6RHuWrvBE2doJ5lzY1wFW0bLR8iHdR/KdALwDxS6YzwATaFbGOFkHSHityrqYVdMK+zDNKJGsNS31xsUNYenesY3ynHBuZ5SZMrwpWWjUVNuVGQNZN8xSEuLNWuYA77izR9C8FSGM9IDt2IyloiiW3lt3ZDSI1nQuzxGiYvUxmnFBL8f/MkKV8p9/YNrc21AiKrURaFfzglSqpSJ9r7hq5XK9zaa5WJXtILAQ/MWaEA/fXUD29JBzDgRljkEZuOow7ucoWBnPl/p+b1XO+soQ53lBs6PQkBkChboi
 IXGYKIHt
 RJnDf7zki0dHnqotHZTjaUrbzUUgTA8yu00eaUd9VTSARr04Dbuq3ookrdrJqOY+L8ydDgGa70XZo3Phi1A5otlzQPyNanVQvePXAk143L3xItFNdwCS+WzXJoS6OzHJ2zu1ReJKHdmFwi/jkmw7Wk/bCEEWw/6bbBRe7j8hX4kcemt+y8alXEC8ndgNFJt8SJn5ALnTbLAmCm5qRX+lDKmMM5NL/h5rDBwCEB2iM8iBgJ3s19Pfp1zODIR5TIIc7eLSb03B7iV+xMgipkCl4gkXFZRoL1uOXtsGV+WORjxEWXzGtnlYY298JM9G1MQsfpYOvslXZeTx1X+5AGxW8z5gdki4aYMbPj1rEpfTbDZHpCoYGQX+C9DX9xOpd2arx50dy4oWJz7BiD/w60TWO0h1MWKV/KvK1bazodUeY5RPFiyOdLLxw5yY0luDZa947c9ebAuQVKxCUjxh6YixncVb59w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The restriction that swapcache folios can only be uniformly split to
> order 0 dates back to when the swap cache was managed via address_space
> mapping (swap_address_space).  The old split loop only created order-0
> sub-folios with a fixed stride, so non-uniform split and non-zero order
> were rightfully blocked.
>
> After the swap cache switched to swap table under a cluster lock,
> __swap_cache_replace_folio already gained the ability to replace any
> number of entries for any sub-folio size in one cluster, and the old
> swap_address_space locking and limit was removed. The restriction
> became obsolete but persisted through multiple refactorings.
>
> Drop it now: swapcache folios can be split to any supported order with
> either uniform or non-uniform split, except order-1 which is not
> supported for anon folios. Mappingless swap cache folios could be either
> anon or shmem, so for now we just simply forbid order-1 for all swapcache=
.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 32 +++++++++++++-------------------
>  1 file changed, 13 insertions(+), 19 deletions(-)
>

LGTM. BTW, __split_huge_page_to_list_to_order()'s comment also needs an
update about splitting to order-1 folios.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


