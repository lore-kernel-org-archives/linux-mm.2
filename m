Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF7BFFEFB51
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32E606B00F2; Fri, 27 Feb 2026 15:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB556B00F4; Fri, 27 Feb 2026 15:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD786B00F5; Fri, 27 Feb 2026 15:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 015A46B00F2
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:16:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4C5E8C6F4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:16:24 +0000 (UTC)
X-FDA: 84491343888.23.82E8AB4
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012018.outbound.protection.outlook.com [40.93.195.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id C22E1180003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:16:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U+404x1k;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772223381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9JOYYjbloyBgjZl5cX4qJZzOAJeTSavASEU/JWGyfo=;
	b=NzUBrAgnG7bAZwZezuuEoR691WbM7xjL03vsOVo8E98oWSqMQHw4zJDtpmZuUjs0N8Juh1
	kA5mNvvKo1MHQcF1xd77cTVFMi9LPXu4L2r3ReRD6/D9CrXKzgI2D03RapKGbjihacyeb2
	yK33Hwin9WBq5N93ZzEJo/Nwjv3m22Y=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U+404x1k;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772223381; a=rsa-sha256;
	cv=pass;
	b=S7I/TrhjhHCK453AFCYoRXEe+70nD8gaPbBQyu6x2FMsA4N+NFE6nUOwG2jMTA9ik5xjwT
	zwG1mhHeSDzfn03IM5bPi4Xr+WkDwD9rG5bpDyfJ9Bu6yutMLM4h1xC9bpCQEvmRPh1DtV
	+eV3P3eZbXb8E6vGlMSggFKxqCkl0D0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eyMshqv8Etiozi5JzoE7HPOzsUoCvI4fwDV5D7JpqdB/8Ca+jXXGhqyDOCcWZkKskHIIu3PmjvapIENku//LgsEzu1PbLEOusvEsFFGYL6Es2HQRsU1F3I7JreQCbUhBPCliiCAO5MAoJtl2uhNHlIpUdQSb8QkIEK/enyjcLfbjjUYrtjbwDGEIa43nvKfIoUjCyu2Vx1aiezGC41nWvqdrc6W3+tnPHCA37AL92/CoM6xDdlZHbH9BeF3jP8DxgphDTvblOObH5xTOJxsEWHZxRZfNs3TxsVjAJ8szxytqB5f+wInUTM1ZQTDJva8dPdVyGcl5E+3XPFlFsMc2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9JOYYjbloyBgjZl5cX4qJZzOAJeTSavASEU/JWGyfo=;
 b=becHKkcKVh0D6lKvSU7NAh5GNC68mNvPQR+F7JCsNcE6KpddKMbLkUAxNL91+IaMUgKraYmQJu2tT9AZmqLz3p47D2R2NxQ0CfVVuOBLqDdCziqkfeBuFhxn1/8AUuhna1A+qIdCNIuiF8tWBfcbbVS6HU8av12Gc2zXEsDpei1T7tMnEbTHVrmpGdwEypNg8Cn1fkFGkkXnISqsburO3uFx8L79XtlQ6ET2PjHIHKhRwZEWURobwclZbgfjYES3NopFeRc3WlFEzXcH/Vd4B6PAx89oRxdaBTjJoXLSx24ZnhFUOod73drTNng7TO0xjkyJw8iiq0RQkcfm2+g+TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9JOYYjbloyBgjZl5cX4qJZzOAJeTSavASEU/JWGyfo=;
 b=U+404x1kqZhjGZMVd6Z8YLGEvAVb2OzxdFbDN6gwbD5QWWkcDkeaci7s+oDvTJ+8WyzG5MzNpAo7yQlDHoRk+sgyi9RGzLaK4xmSlRyGXn8smvIyFMYoAhBlUt4k6NfsooeLK4lQzgSLkEz8UFK3+Ry7heoMLLyuWNBONuvq+PDnqUm9vVRSMmtUOA69sjUlBncQ6ivTEujOejA8sGWUJFuShSveDak5bHIbohhCuamWsdhFsn41nWInhZnLUGPFpioUVBRcQVlF4/hzLMJoEi420KNr5NfVHEOc9PXCUQ2uA+ZUF4HZ6YDcOE15t01POcISyJJ4fiSk8SvSFUCMTg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB7409.namprd12.prod.outlook.com (2603:10b6:806:29c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 20:16:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 20:16:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
 Pankaj Raghav <p.raghav@samsung.com>, Suren Baghdasaryan <surenb@google.com>,
 Mike Rapoport <rppt@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com,
 tytso@mit.edu
Subject: Re: [RFC v2 0/3] Decoupling large folios dependency on THP
Date: Fri, 27 Feb 2026 15:16:09 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <4A89F75A-325B-4FFC-AAB6-07C206844B02@nvidia.com>
In-Reply-To: <653e34d4-6356-4f9e-8298-40b4e237f761@kernel.org>
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <aaEsOu0hgCUznzl3@casper.infradead.org>
 <8ca84535-861c-4ab0-a46b-5dfe319ac8ac@kernel.org>
 <aaG2GkICML-St3B4@casper.infradead.org>
 <653e34d4-6356-4f9e-8298-40b4e237f761@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d7edebb-9194-4852-e689-08de763d1038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	X1BKQPL9ETAg2oDB3xfRICOrui22DsGCZDGo/+sFOJa9Mn8BCl+ZEDOEkoZnHK3ogErMizk0HAroWAQmztbVMgzpt1LGJjwkg56UQU8Lc8lN0DT7bPLUvqtjojrU9riYBKBkOq+uIJolT5B5befGqOoOgqlrn7g5t785d8hAyvUKFmaoWfmjdjNXEaeKNm8baFKsaQazo5ySu0xXXFWe7jAMdegXlMfBQulcztsV5yxkoJ8CFX3gMlVQ5qyI62qhE+smxZKM54Bi2d0WXCMKRH/7Vycnwy5kW1vCIDYAsZs6tlNWmBNxUAcDG1LwDhZuTXgktYQbTyS56Bo9tbIM/SVkExddWgD2dAJu9zCwvE8UxyQsHY/AILuZjM85CmtQIJ6VMtYUre1e9lRpcam6rrqW9qfFIHm8jvMsED7h+Tejo99uxogHePUK2hFEF0ENDzMGMv0R4EuXetebmFSLAkVYXNRxZmnzg4SD+rmDUWIUmNU5JLnF07Ad+V7Zf2HKoOwwMRlsbfSG+q2e4uOiAuMdIi4OazDgCHXmnheOuqw82Cv+tv2gaKsg7TM8yOC1f6b3yhCW6aJaCczBmsDo4i/6a85TFxbSo8NPqy/uFHdDYvqErSAYZBMOHhCjfeli0IYgsbJkpdxu/i/U9fwZhXo18ASeMNusc26KaGPFQ8iq8Zy7LtT91AkNbpY2K0G3HtTgKskwbJlKjzy5OeOusXMVb/SfqawavQT26rOdal8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZJsDJ/Vl0HkU1NgjOQb7NNL6HxL/eCYfjwWGPlfnj8BbKoCJjAprmoeM0Edk?=
 =?us-ascii?Q?7gGGTHgTY8pLfHnqheZ7JFlxqHdp47pnHICVJ4ccZSBB4s8M+GNGSqKTh76X?=
 =?us-ascii?Q?HVNwAxiUDEUYC1GUDVIqRLRfMEsn4jdr6DqnEakqE66V+3RWIFmEyzEv25u9?=
 =?us-ascii?Q?cWE4GNmZqtvsqHAnzskzYUX0DDp5TYBfVJiAMo5tDOz63Esc5go7KPwoRI+6?=
 =?us-ascii?Q?KoALZrEKCgotReU9K5CjX4hfHpJY5mEN0kRgsd/a5zPf4YhEX0H/oRecMCjO?=
 =?us-ascii?Q?t679nFVQJ+4U41XDBIIUDua4SBosrioa25+icVEaK5+yVlVFgC4I7HlpcGDx?=
 =?us-ascii?Q?XJbrifFIMjdA+IBJdpS7/KZLTPU78sOkTwASICEGaCtWcjtYl7BOn0b0VYYJ?=
 =?us-ascii?Q?w7+S5RhDWAqznIyznDBfyjsi1iThHD126SuEZ968VJw8qdXA8keIwf1U4Vo6?=
 =?us-ascii?Q?3++fEs+Ju/FLpgxFqJH8vYwToXOyS6rD2s7Hyj4Pwm1A+L3Eg/qSfXQcFOrb?=
 =?us-ascii?Q?RK47qwhSyHblxP3HGWr7ZLqhoHQDjvsNs82f9lHIiaoZSfcja+Ds7M2Q6xk0?=
 =?us-ascii?Q?cDV1w+nMhh0VWIzNjhnNV6ifnviGX6JHiTnOGOZDmF5vLjYLzw7cSsHTGsv0?=
 =?us-ascii?Q?kX3KePFlWpo8MVA++7ZE7+Lzm1YqQuZkdYN/Uw4oR9SXF8N21AU8TgKzEOLs?=
 =?us-ascii?Q?apIBi+fcsbaT8DhXxbAWXNjRof6IunRTpCTv+oZSCpEX/bSsdBXi9mQLH4kD?=
 =?us-ascii?Q?tUBz/VbVzOSM+9mSiqyZ8cED/t59LnRIO41R//ndfBaUN57mMoL/4Yctcq+B?=
 =?us-ascii?Q?VLhPk03EBJQeBLudQZ0pRDKBR0Y+Q0NBi3K5almyNx/s/ihU0Bh7qt4WPk2V?=
 =?us-ascii?Q?IWmETEZ3I9I7ZFkEGS0Eupdc+qJAYpKMRRTYaFcOMd07mTSNVyd5/UuLV9E5?=
 =?us-ascii?Q?967G2cH5Wvia3c6pc6owf+CxVRzg9GhCuCJRFEdrHQtGlMpajT1Tx01bvl86?=
 =?us-ascii?Q?xTa7FhwzvFqM0ZKhm4UZjWhjr7xsuDGAX8yjCexc3ryXO4DiWc8pk8/O427d?=
 =?us-ascii?Q?4fGuOdh/oVhhErFTq2UKWq52WFlBCj6vp35URSBEQEhZvxaEUqIqVQQlrhsm?=
 =?us-ascii?Q?qPcnwSFAJ2EyJfwPi2Zp6zFaMCo2Wta9kaXPR6rqWbK6haBgG1cja9ULkco6?=
 =?us-ascii?Q?zdQ5/rJLM4/kBC0tgbRqHHxLG9O4oQfjF9vqNeII7axAfp3JYn0qR35zHfgH?=
 =?us-ascii?Q?c6xYc078SPMc0ihHRHCIZYJSPro4atLOXX1XMwKTLNbrAfO6MUS8NCtgBiQJ?=
 =?us-ascii?Q?cvX74KTzpXXuE5sRJMAmJ4aNqTRb+r2gceNSMQha8+KG3sfk0G1mbdONQpKI?=
 =?us-ascii?Q?XzcD7liF9jq+G3g72TSwJcHbXWuFrhdpd7+lvDY1pJ4bc8p/xr6ryeoY8mtv?=
 =?us-ascii?Q?6qlf/CE6QdD7uiVxe4B6EApoWvp3Uma0hMwOKdbuupfQn1/iWpksozBIKbQA?=
 =?us-ascii?Q?t3uTkZfAnaPulntwmdb6fur7wwudGTsfoi+/t5KXoZztbxZ2yrjFfv24ip/H?=
 =?us-ascii?Q?qonlmaTyr/6ldmWBzCRzhUe9jNuPfv//ihAYJkeQylm63R+bPfL5E/jEB0xj?=
 =?us-ascii?Q?15DHt3HCbuCPPTXSF+yTBEt+yZ7bzYcUyekgk0bZtGI2ELe3ia4wxbuviNJR?=
 =?us-ascii?Q?lh9N1IeVnpFIjvBZNumAFBsPx3BiHCVLVrVee/Ca32hEBgQQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d7edebb-9194-4852-e689-08de763d1038
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 20:16:17.2442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ubXioYmg3TINbUdMgbOPLj16kyzqtpDuz0+jeG4XyL4+vLfJYqiOXK8HlK9CHxeq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7409
X-Stat-Signature: np567ybkhxo5ewhejn6jrsg6nccr8f1j
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C22E1180003
X-HE-Tag: 1772223381-839329
X-HE-Meta: U2FsdGVkX19kHr6YFYd8aE4r7EDLqY6wTDcS5uNmG2AdgXxtp88WQ3FZbxKbTW1HI/k6r6R/dlP6K0sDO6kPTKiZU+LuNcS1aVeQfgZqVnZID7MS4+pPgqXaatQd0vfY3c1LVPLZq8eDhf3v5OSmSRa+00edIspOeR3unhy9gTYtZOQSbjyYyfl53KMTdLrKicEStDXNqOsD7S5lbpY72WlP0XKhDxlxLxMx87+EY/nQis/+kHYwu6tahkTA3rxgEKf+oNmNMfrKX0dNwzZ2QSEHna3VF1z1aq/OyvNVf7JM+W7aN94qFbN7YznJtn6pBOjQKaifPhxu+PdNt/Prt9C30aTfoOB5DXM2kQSD9Qncga+1LdfhpEOBWWn9c9nw/Q+neCFg80CvORiyy4nLt9Sf9EEpuKq4zDhdnPOJ/EwrEZw4PwdCmjF80n6E4HBOJl1rv0gRFqfJgRedFJKaA8/Aw1iIZxdRIYUL/Xj53sbviaSbWeHs/WPHRoRmEP6N+/lsu2PdyXKZBf/ZG8xbKDWc1pqndcB94HiALBJ4WdJ5oyDEAXnEEY/wAGvlpZXOD4BjIJhxyZtQ6VwtsujKMvm+1x3E7ERhYhoVuRewb9wuVf85eKIxx/M2DcBSFz8WbuIFv3o7nco/F2uHN3hRHovurpNIeAlyFfjv8ihCG6uij9Te3iqH6FEwq+/1Psu8+95U/HA0JxpYgEAGRjUNEbdN5kPi9nz+A6OsRjsEA4WF9jvT7mArpgyAXG2HLA61ZmJggky1IqDUeOU6ID9zYTAja+o6fMwt7VjCmGhS9hWhvul/X7QY3M+oOddB+bHIiz+LCD8NV6hfZXAgqv14zsMbH0EXDxyls1FAPYfa47T8qbal2A0NjWeKRdAOLQLTIvXhDLxIP6L5Zp8LThxr5pIF7kF4juTE60o0BAsSyfaXUJnOoTTkU6oDaYTj8bT/g9cNyEOO6D1NdpEf8nl
 jSFAZHTo
 Ni6p/7sKHRQCPgEKgZvYvuX2kzD3opCz8T46MzHBgD0UqsG8pByTfCodQ1wqc+iHCHmKNq5mwKGI86nc4I1FSUoeW3DIJVHXt7FXcp0KK3oOW1vEmQT5wNSjUGnZqN71WkmlpilrFqMPr5JI/QuLWvJj6nLcxXcU/wDufhN2bl/bZEw6IO0UW+fQr/qQICZ9KQNITiefl/0FUDDB6aZNTvV1zUcjZ4ufZENIfZfBHQ0tos78dZbTPrxolpnsQrTIXlqQ0mYzKy9l/srrJRZu7LaK+1+v9L4v/AzUNvPG5jJKzy6+jDP/pgdGWCI+m9Oq/9w4uFN1QnUI9nsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Feb 2026, at 15:10, David Hildenbrand (Arm) wrote:

> On 2/27/26 16:19, Matthew Wilcox wrote:
>> On Fri, Feb 27, 2026 at 09:45:07AM +0100, David Hildenbrand (Arm) wrote:
>>> I guess it would be rather trivial to just replace
>>> add_to_page_cache_lru() by filemap_add_folio() in below code.
>>
>> In the Ottawa interpretation, that's true, but I'd prefer not to revisit
>> this code when transitioning to the New York interpretation.  This is
>> the NOMMU code after all, and the less time we spend on it, the better.
>>
>>>> So either we need to reimplement all the good stuff that folio_split()
>>>> does for us, or we need to make folio_split() available on nommu.
>>>
>>> folio splitting usually involves unmapping pages, which is rather
>>> cumbersome on nommu ;) So we'd have to think about that and the
>>> implications.
>>
>> Depending on your point of view, either everything is mapped on nommu,
>> or nothing is mapped ;-)  In any case, the folio is freshly-allocated
>> and locked, so there's no chance anybody has mapped it yet.
>>
>>> ramfs_nommu_expand_for_mapping() is all about allocating memory, not
>>> splitting something that might already in use somewhere.
>>>
>>> So I folio_split() on nommu is a bit weird in that context.
>>
>> Well, it is, but it's also exactly what we need to do -- frees folios
>> which are now entirely beyond i_size.  And it's code that's also used on
>> MMU systems, and the more code that's shared, the better.
>>
>>> When it comes to allocating memory, I would assume that it would be
>>> better (and faster!) to
>>>
>>> a) allocate a frozen high-order page
>>>
>>> b) Create the (large) folios directly on chunks of the frozen page, and
>>> add them through filemap_add_folio().
>>>
>>> We'd have a function that consumes a suitable page range and turns it
>>> into a folio (later allocates memdesc).
>>>
>>> c) Return all unused frozen bits to the page allocator
>>
>> Right, we could do that.  But that's more code and special code in the
>> nommu codebase.
>
> I guess I'd have to see the frankenstein folio_split() to judge if it is
> really better :)
>
> If it's really just about skipping the unmap+remap the end result would
> indeed be nice.

Without unmap+remap, that is just __folio_freeze_and_split_unmapped()? ;)

Best Regards,
Yan, Zi

