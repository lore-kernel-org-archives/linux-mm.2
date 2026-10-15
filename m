Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB751CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58536B00A1; Thu, 15 Oct 2026 10:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FF76B00A2; Thu, 15 Oct 2026 10:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F6E6B00A3; Thu, 15 Oct 2026 10:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96A056B00A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:47:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A49BD120A45
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:47:50 +0000 (UTC)
X-FDA: 85325139900.11.F61B798
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by imf21.hostedemail.com (Postfix) with ESMTP id BBA261C0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:47:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JnUHAvjS;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792075667;
	b=CTILQOCEi30TrWl30A/De/jsyu/3ys6JKEiIzGKBvdl/68zPe3t7+qn/wOwTMpRX/5VC8V
	r+OOildjBoNOZ5ODCTBAx0x0XbBF51yCijMn7aGxd+J0fMbermzg1YeUw5wrfRUW5GMs8U
	5rVkT92PB+QJ7GkTGJqGyyQJyX+PmU8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JnUHAvjS;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=citmihPxSlvxoLYoC2JBzDiOiA4zpxMD2haWcZkJfIU=;
	b=kWg9fG9BprYg54hjhjGfrf+GST4Yc+PuqDELd6/RtlcGXv/8UapU+JssGthRO8Fz5ee8dx
	lphYiRxCy2nrr1BEeMS6CeoQQEascGe4QMjZuYtos08rUYN/TLz+zQIkJ8LXXRFNC+xaxG
	8ISdrCW8TtMTJrxmb2Ku8kPQmUnmh9E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4rY46+mjauP/U0JQTLY74AW5ghlVJgoua6EUtypzaZrRQfkClUJSXhlj4KpaNvqh/lqwMfvGXNw7TmsEF3p6UbOEqjYJFHSDmKgca5K3mD2nMBTpP1aQvZi0X4ezQF5aX5YwclMc6pGuJS5gDpuVI5ESZN2nYOW1z2KMFjBNxL74xxR5kkOL+1VTcn5nX3iKFi6kiia1lVc+iYxirHhw2QyArHEXYsgcsPDO2T5S4owh6Npivwwhr0DYkBnmHbfW3JpTls6PTuEce3zd+6NLgKT8/Ix/kFEja/R2AxDWeSp2PrvKzPx94Jl2c6J87g9SQNf5Xb+0yd7iOOqpuRT8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=citmihPxSlvxoLYoC2JBzDiOiA4zpxMD2haWcZkJfIU=;
 b=C85/OOV912gMAQz05YPdRrCM+ixvOOP9bQXpEDoW/xz/aLQYN5YCx6yuKrzzGjqa2M2YnIebyqnbUG0zTR7/TFOJYv3LQNZhLD8FdVBT44b2C3lzGrSf3JVvEtFobD0Ua363TgNGBExhTu78IpR8RkrpzdUHsbA7u78e46AXFQxOlDF0kxGu5ULtc5CL8yhCyMTbqo+CxmnA5q9eVlCEmOWSzpTuweAMXFJcBlDjaBqiHqrpuNFE40Eq9zNon3pgWtyLT1/muKwFju4SmbPPkQVCkCdwmR2g0NTzQR8PCpTqzMtZ3hfZX5dZSmdVHmeLCw+HY0qKOT4g5Hy25Ai4sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=citmihPxSlvxoLYoC2JBzDiOiA4zpxMD2haWcZkJfIU=;
 b=JnUHAvjSaKyu52p3x1VkIuUqH5PFLhXAxQ2P9Txu+jieBNWOPus3W9GcZAaOoduLoKP6jGmOZt8g5GdivFGzGVh+XXU6Qlav6F0FWDlzXwflsfMO1iNaE9HWgPxoqpyQEw/OE1yqp9CNUPKAlotgaJ/EpE0g/XXgvi+N6gMp01aY72Wh/Mzy1ZC8RkG9iJ7GsgGr2ZPKPo1wvk1xpDUI/O6fvdYuNk1xF5p9M+WNdY/9r7FA5utCnxlO3i7hoVgnVTLxO1/5ZCtDGnjySolgLQaU7owKmFe3h2ka+Aw6Yq/e+x3ufNLHWskVtGA09VWkVVfwjJPD5he8p02x7Dz8iA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN5PR12MB9463.namprd12.prod.outlook.com (2603:10b6:408:2a9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 14:47:40 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 15 Oct 2026
 14:47:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>,
 ackerleytng@google.com, akpm@linux-foundation.org, chriscli@google.com,
 hannes@cmpxchg.org, harry@kernel.org, jack@suse.cz, liam@infradead.org,
 muchun.song@linux.dev, shakeelb@meta.com, sj@kernel.org,
 "Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Date: Thu, 15 Oct 2026 10:47:34 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <0AE012CB-0F74-4918-8D6C-E20F466D99A7@nvidia.com>
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: PH7P220CA0090.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:32c::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN5PR12MB9463:EE_
X-MS-Office365-Filtering-Correlation-Id: ab34b235-66e5-49a7-6958-08df2acb4300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|10067099003|22082099003|18002099003|11063799006|3613699012|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SXNfS2l8WPm57g7gB1ouFOY3zqjCSYNPNAnPfZa9wk9hXpDyZfAmIqGDDtVT3NLb4tgBLRX206UDp0HNS+kOgZOjkfRjdZkOW+wZfxNSLqoP50gcrTf243mK/MZ7ymhAim1z0mTOR20v1tNCzbxerQfLwWd9Ia42O4tZDMY1kfI8/knqSH51Q9hQ8eRPj/Ec1504UYwmE+3FZTfXhLiasSUF3VzoDKU7HyfjhSsV0nmjM3K/qhqyyi6ir8lSwxQTkvB1IiJONDRK4DCqfbLlpYY8Qlqz3aOWyIwQpSX1WkxxlSZVVq3VS9EvByhPPLKpfTIouX14wGU91GzI3KbyaFHUQksWJA6R4Ry5smAv8ZJHhOt2jTL9+5neqGD0taFEhuiNQxFw/SlSNMSRLuWoTPKGEW2ki5taHD6ZM9nPx0k2Y8PB6ooQBFtwFmaFdSK8XewtfX+UWEqcFDJ6wo8mSEBxsSaXu0d81wLeudLgHcTN1itKi4j1Xp7O+yNhQqfd/Ojd0wRQFXm6IX5t3eLFJtzgqR/BM83hMvyALp1J6qYOAe4wwb52F+rM8yCW4JlxSQXYHUYJLonmFSOLV8wrNaWXb2IKDSHDeivc3498kNUBcMdO/vNt4CCfHgT/0aaBshRbvRV0D0XHk4UZQGJtBrpOOMX4nUY91P2az4Bv7B7MoYt7EWIjH37a+B8Yv8yPh+qntssjxNe9LvZdi3GWX2q3f2D1cpzFuwVdEqHkFh4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(10067099003)(22082099003)(18002099003)(11063799006)(3613699012)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xnz6X1owwV2PpVmRKOob6tzd3jWAuEAxY/ZNW77QvVRfELuJCzK825bmNdzZ?=
 =?us-ascii?Q?UeC+nlnUnhrhFZ2lN+2kN6dC5XzpStsy22/xdf//ciafOQ0ivTty9AJjQyC1?=
 =?us-ascii?Q?84RgIiiRxIAD63wlxSNbBCF/hIBzrrdnABDQNLCd5gI/O6NOlqYDi1JJEAkj?=
 =?us-ascii?Q?R2AFi8hNdFQyCf6oIsANCDp+2BV/SioJZQGn7UBApKSwT263hyaHicIPBzNJ?=
 =?us-ascii?Q?hSsQxTaKdV3a7cR5atB7qMyg+0Vg3zSFMpLTPZNHFa22fjiqvFg6JAD2SKnE?=
 =?us-ascii?Q?s9lMwvG88UITTVQSK6s7vNHuD/DPhTdh4i2LocOPmkfzmCNuJs7tzVyzs5l5?=
 =?us-ascii?Q?5IOvmsmPBH6GQaThmUhxFDp8Vwn6bkkXWeX+1+XF8oZ3rzLFdPt+NxzgyPXU?=
 =?us-ascii?Q?a7Wk7p6wSTFMBVDIxv25bgozIAMXwZCaSockTMNwSj3103Y4HL2OnkDaSO8q?=
 =?us-ascii?Q?cfxOyxY62svKLz4Hsk+1sxrlsMRnsYp9Ni+ARShLyBxmI8+mGVQIq2zuEw5X?=
 =?us-ascii?Q?vdWcnvVk1rO1mzmAaOrDNPw+7km40ZFoxbNiZs5yqAH5/bUBYTFBupeQqzun?=
 =?us-ascii?Q?13HGB9YJ1okdcc1vJy3t+4YHgjjyXiLtBAKuAa0qEu9Pd6jfhsqpYr/oBq0S?=
 =?us-ascii?Q?qWMiGEPbL9oVX/CUdSyFany0K8oI2mF8IilSF/zAlrMn99/f0uQ92aUarciD?=
 =?us-ascii?Q?z0e6lFtVFhk8NU7yX5JQNcW74p68OxHFRZKaj96+GzJIB3aE+XCjLG2cqkD6?=
 =?us-ascii?Q?tKmbZRhBOBfHiFiwvw0hNNm03UkkGAmn5ihGNx0oPwaiDLqjKr2d/F9Mk9e0?=
 =?us-ascii?Q?FNRpwGHHozCkb+CspytNrzJtRsK2cxL1XfVJCMRe3npRKvquIPDFovDJNF2F?=
 =?us-ascii?Q?YQiBBHJvQ3Q1wHaohztbK3ATFg5pwT8+wbTaWSmicevG9edlvbOzUf+7QSIW?=
 =?us-ascii?Q?oUNhM8AQoLxJuZzrkrLz2+7fSlWbrpVjypl7YMyncIL4zDIs04e2Ddi8J8GB?=
 =?us-ascii?Q?X3O4edt3AAGxl7Px3akUq4a8TYAbyyRFllLATfgiSkHwOWguN/V+pPxGHPRc?=
 =?us-ascii?Q?okw/2nmDVKGcIjPVZqQ7LpVtmSJ2ZIEQ+1kvPD3uo0CXQa5kcgTjCFlOssNO?=
 =?us-ascii?Q?VuyE+9dh9Z8BB3wOBPqymftOXP4U2o9S8IGpyenbWq8x9A43bSjlqek5Naka?=
 =?us-ascii?Q?Yjy/kNBQK8Pi+6DIKeVXLccjI8uFw/FLLBBYo2Kr8NaEicfqLyWOTCbmmuN2?=
 =?us-ascii?Q?34KwMRYGbUBKtt8S6pKfPhIAkVBwa/go/hoB3zRDN7O7NnJy32JA8ZWPgpq6?=
 =?us-ascii?Q?F8QrAAjNVQN0TGSmsjVCYb4eT+nOODDPiaC3YBKEOwHr0jYEFgvjLvEu4qX/?=
 =?us-ascii?Q?d9cnghZXQYFB6wT0pviGObpn7/zeVVxKdsjR+rF5SxJoO7yM33AuGajRXEn8?=
 =?us-ascii?Q?aXnJSfknK7WBR3WudkpG8wxuycws5az/cpElRERWM1rNqiwiBr9e0hdgx/UE?=
 =?us-ascii?Q?CP9Yj/E9Vw3CRmP/AmJcwTQTr5FmlBLG8yv6IoZBB3VPRJOWqzt0UIz+okC1?=
 =?us-ascii?Q?WI35zGJZTDxkXE4iqT5ugCPWT8TMsQNzV3czsREM6MsGZoGFMlkm2+lyODkI?=
 =?us-ascii?Q?OgcPB07CHuLDe55l/C8oZV8yBhgYBBhqP4hAzsYLxFyVyEpfM005UOt287Pe?=
 =?us-ascii?Q?Mzfu2jHri+fush0C+QqOIjMcEgcDabzvAv9zbJheAh5nIINs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab34b235-66e5-49a7-6958-08df2acb4300
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 14:47:40.2179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VNIJKzoETLNg7Ch+pQjqi2GTJa1/zGC1IJl9uhGVPNahn1d/PQcc9YsbuTXySEf3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9463
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BBA261C0004
X-Stat-Signature: cc1nohcaddzje4f3hopsdt75j9g5fbys
X-HE-Tag: 1792075667-974150
X-HE-Meta: U2FsdGVkX1/hIAFlXgPJe6CW5HRLfZODQmipI/q1ypt5zvqk5XrStoVr7G8VYNKlia2qH0DHXze7g5N0cseWLppJb4W1BQtpnHbjsPU9jVf/KUXyLvll/zfVDjHx0BXeCg9wfEEhARTRjNFOJm5Ko1OkoJjeJ9SV1/wkKvPs5eAlvpkTU4HTMJvW9m5yRWnRB25A+5EjVI8FFTYAQ5QWdjwHfxVwAm/x3mf/U0E06J9XbBAv5JmbmYsFBhl+JiWTM73VvTNLoxqSEBdEpfGNXhXGJE0TX9FJIboZnbuE/PGxJXC2z6HhbiyLBmZybuh6LwYp3XG3gwd5Mx8QSZDCobWjTkgBZtrFFm6B2OK6sI1f/Ebgcu/vkA7N3B/2magBxK9lWGH4Jnk1fxWXkQqC6YajLmfj4PHFYJa5gHLN/k4L6mvDSv49VKvfFeHHt3P7T2YSlv5CswraRvGhvSu/EbbuFaBoDOQzJRsnk3FrIWmMRk3iEIuHYYqTldY8R1o+7NMzvaBNe3VSSjHqNxHQAdSzvjweeCVLMj7X+pgEXnYEhCZzk+3eH9haDTlrI3c7qBLGTiI62XaxnrTnCJ9rybVTHOmj78I3LHYV+9Mhq87W26fNS+FwKtKnwpoeI6AIDyLQIkbVl6QF9PqZPben2gHXwxCgWmKDbX0De3CBc6v/PTIfxSPhA3vTF6xqF58ujhvavMrSzs3QfoCBDBEp+QeUmt9YJPazB/2A/ctPlgeCyZIT4y1TqfCzlQ+Ez2WCvZDhFUzX1LGD/YwcuDR72CNjsSFVjSJkA1IqB+J02AhHC7OpWp2HYgpO5+12NDazzemJYZiwXD4OBbYOqgfujjGWQ2SzVelGQoPxVLg6bYTfsT+b2TeTQlX94TGdhjdJmCy5zXuTChfQjYCmCajTDOoSgcMKBx0WOGjvrlKsM0ttuyyR5ZtizbHrQDSMDE5twNxkAY7JFRllIS7tpIF
 9Zrrie5P
 eGcHTVaHMXFWWapaEQpRkjrt/b7MNekw2c1JUnqIR/HwUXp7vnGx5goNX79j5+6ovRIUKq6DTxcaqSQJxBrfT4oTLcpZY0JlQ+oE6N0TqrcJppqNc4BdDvo+4eJn90k4uWZ3O/sXUkLHNlx+Oflrf7OSkmx9zJd6+EysxpIpPbgUou0q717sTQB3q1QWhmbhUy8hfLWq1XHB0eLXSH66+WJ5iYA2OJpF4W9PVjpAfGfN0kkD2PvDzRVtWgBMsIhb7LQth7ZY5IdPVKFrgF2hAVZUUfa7CMIndQBT11uztGFq4qO4GdHE3mMJ5lZin6wQiy5Z+wSbTDf89DWJnPLukt23w4m6lZYsAb0/I0JU94uBEmLM+ZR+z6ylmT3kCTRYRCvVS4C4YkjRrZeLcEoFVXYMacAkALUTYpUUz/d877ZrJ5ffx3aISf5grW6GKcFxfH/VJjdHq0CroYQ1eBSgYgBWfz+wJHM1FQawTzhYSN6le2GyatPtKg/Y0i4TZiBVOlQyyxwU9wTB7OWmMPhvJGsGxml6YpcZAkX/L6YgiCzvZ8Cy56N7V7dm/kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Oct 2026, at 4:38, David Hildenbrand (Arm) wrote:

> (CCing all people attending the mm-next call)
>
> Hi,
>
> After talking to Roman at MS, he just informed me that sashiko now has =
a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
>
> That solves the key issue I had with sashiko: people/agents re-spinning=
 stuff
> too fast before a human at least had the chance to jump in first.
>
> I suggest the following sashiko change for linux-mm:
>
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing=
_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails =3D ["patchwork@emeril.freedesktop.org=
"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to =3D ["author", "list", "recipients"]
>
>  ["fsverity@lists.linux.dev"]
>  reply_to =3D ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to =3D ["author", "list", "recipients"]
> +embargo_hours =3D 24
>
>
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
>
> I'd say we start with 24h and see how it goes.
>
> Thoughts?

Sounds good to me.

Best Regards,
Yan, Zi

