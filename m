Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3974ECA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 18:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECFF6B008C; Mon,  5 Oct 2026 14:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5016B0093; Mon,  5 Oct 2026 14:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C786B0095; Mon,  5 Oct 2026 14:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A84F06B008C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:14:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33C081C322D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:14:11 +0000 (UTC)
X-FDA: 85289371902.09.E01F90B
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7521D40007
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 18:14:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GPC6gkoK;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791224048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fqv4wAFN5hhj+vjq7T8uWvopMzxW3L2IbSGP67DpKxo=;
	b=kJPZ0hfQFyU7K+8LlX+p997vmx9oJknoNHW2YMIZDuifJLsXgfPoT24JYutRxMeKSK/2xP
	CBHjFjEUP+a8hCJ4e1p67KxGrBy+UwUoc6i1m4CtrhKBKR5fLCS32VNlALmOuBbcQrVeWr
	o+z9SM/nQg64Fv6MnctBnFDUKBOEnVI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791224048;
	b=0kAl47q+txS3FKMBSyaO0FazKwINYK5NNhzkL3jLXJaOGcK9KYbu4pO12DN/4biP1K4kOD
	4shwyEMaiq5n5h5DYYNyEqnbhk2PqDCEWsFrMt+3XH7L68OGjuK97jejTlDQDBTOJ+mlMg
	2SQqPI5v/SleWapy4mlrJ+CcfsyRBCE=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GPC6gkoK;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyaqYLauyAO3NY32hL0TF6fLI+nlOjMIvg1fE9IanB0/RX5QjbgOIK2G19Fe4sSznnWvj9vPNBScoTkQOeYwC4Xv3HTq70qK1hB6w7hSD5csfE+zSq+iPVaC2zL22OUEtKI/YB7/M60IP1TCbYV7KnHFSMAhuZZnp1UAucoBfCrGqXRaP2zcF+wGgXhHQ7EdGBXbN1p0p/LJOuUzx9iT5qcjTQsGXlnHYl5k4sEwJ6SSHDUWhwydYXUWOPMKazDh1b0NcISBvbMB8dnYsOBMyNLg046taFFKFEZsRvqesXGsI6KXAFOv+Aan25csdb/KMHjVvhnsYCE+lQP6quvrrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqv4wAFN5hhj+vjq7T8uWvopMzxW3L2IbSGP67DpKxo=;
 b=u9uYs1bOwftcGH2hyShHPhZpPWxJv6vP33+jqdVuDRcb10CJo6s66xHdIjQJDMMFFcRFDtbYUS20+kFSwlEZWmRXGihq21nSNrNCs9e7IHccOM9C1YdvF9Ug4+KDKllOt+w+qva1uGNhBU54q6IAqaN8BoYYRfOTw0gAcvL9aPBQZpyGJvSiAQNGvfrrPOdF+FKcHEQ3e2Bmu/bHcuAzkBk1PGS6o1qc28f6lY8sQYK388ZEZrUOOj9PEJl6T4DggbfBoE55AghVNk4iThGnFM9WdrTLYorWvpO3hXSSt594yPsgHgdcH7ZBa8nlVfa0rV1+pySbYvFvVOKFnZk36g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqv4wAFN5hhj+vjq7T8uWvopMzxW3L2IbSGP67DpKxo=;
 b=GPC6gkoKOvnFQnrrN8t1qLc8eyWYTKWnu6q5TrQHz9TbTQveVmM0kX7C1euWek+faWdx8XCfywhQqCH5sK4Fd+OzmyLjHxP8hhJIoTkt7LUk8ZRiB6Xw3fw1b33h79gLk6rikWbBzymnMe+a81h5zR8FxtSWi51/Uhbfu9q+YgDIPHvXFliTCe39tmXWUd+u12TL/uQH/zW5Vv2hE1BlD+AtSqNb7BkKHc1qpVOMGOckK68B0IPffnFsBzfjvkq+yT4PUkKp98GpM6Fiz4iAEt9wAViyOt5MZmO8vO7jRMdAMeDunL7PAtimYZE/ypZ5jPoI+dQYckChVBkzZlvfqw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4080.namprd12.prod.outlook.com (2603:10b6:208:1d9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 18:13:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 18:13:59 +0000
From: Zi Yan <ziy@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: =?utf-8?q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
 kvmarm@lists.linux.dev, linux-efi@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
 Sudeep Holla <sudeep.holla@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-mm@kvack.org
Subject: Re: [RFC 00/12] arm64: Add support for TLBI domains
Date: Mon, 05 Oct 2026 14:13:57 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <4DB4935E-4381-4FC5-8B0A-BBCAF55C7D53@nvidia.com>
In-Reply-To: <asND3-Wnb2hiDAop@willie-the-truck>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <DLW95E2XWSVT.8W90FW4WG6K8@nvidia.com> <asND3-Wnb2hiDAop@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0274.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::9) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4080:EE_
X-MS-Office365-Filtering-Correlation-Id: c7b5e4fc-56c9-44fc-ebc8-08df230c6d88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|11063799006|56012099006|4143699003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	1Scs5rf/wDSp2ycutRhIqusg2T0HcitIlZrOFuX8JxTFMjuXU7GTUKwryURX5run0+5J8wIgsNmDBGME3yUs7e0K32RAR6MNC/wbr9D4i0w6b0OpHm7iVWFviQw2QkkLc0Af3Vl4waCYafiFMO81ixqFmDYm2k1c8gjqdoyjxiLcePdEBjs0DpKGFUsDwY9jcie7NsAo7KOjgtZa2jJHgBZbBGWQtUNEMLbTaVB9vZ+NGLuU/Oc6i7OV+r9TWPa9uoBSZWbbhRQbuSe25+DI/UfYZmCjH2JoGTThoMSsdifWbUJhG9Y+Ku5bj/3WXoZj0Ua17irGNA7LVX8uKVOZV6jefBku4Jf3OETryMuX2wWEQA2CF5CuB8EaxNCc3LVMeJW5iFQ11RJoEZxb7I2NXAZhebjmnuG8f6ky6AHK1A2tcn0+40B2VtFk6YUZZcHpSfmagvmbjcEIwwuANiNnyb4mRkRIqohbZq5mBg/D1aEeiH4DTYo7ki3g2zDgDSFQlNSZIFDiVlCkTjSMEfQiMwG2beClMMQi0OeYXo/L1YyZO7HBtGjPOEkfAbikiESoB+ApXBLQJEKGHFdFizKMBBZs/DOP/BKEhcJ/tgAxUf8WJAcJSSyvW4MzNDoZd8bPlPAE7oyxQjSIXkJDfuUcJhVeKCfGH1h6QAzTnpuiIWY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHgzYnY1b2ZJY3ZrSUc1dWx6dm1DakZWNHVncnpzSUg5UTQxUUFmWTIwQk81?=
 =?utf-8?B?N0tVWDZsS2VWMzZvUDZBUG1sdjQ1Vk1hZG5OYk9CT21ZQVc3Ti9hb04vVG8z?=
 =?utf-8?B?L0NjOU85dXRWYUpBZE00UlUvVzVqV2llTkVhMitmWVNBTDNyWUlOaGsyU2VT?=
 =?utf-8?B?NktFQUpNeld5Q3l4UzhJWjFwd1BBWmxKRDdMbU91aFVzRW5VWUdncEUrdDdq?=
 =?utf-8?B?eFg5R3BYRjd5UHNBQ3VTYSthVnlweVJwSEVPd1djNTk0bzVlR0pEa0Rhdzcx?=
 =?utf-8?B?bks0QVI1dzN4eDhYckFZQmoxMk5LYVZxZGFBQk1WUEdrT3RjQTVFNDUxZG90?=
 =?utf-8?B?N3BzUW1WNk5SWXF5WFpxTnJhR1RkellBT0Jjd2ZwWTdKVDJkOVBzeVpGVHpW?=
 =?utf-8?B?eURTRkJReGNVYTNOYUtSSjd5Tkd4aXp3ckFFSjE5MWkvS2NWRnJXbXRGMGRl?=
 =?utf-8?B?NkdHR20wbTlCZlM1aGFKZHR6QkR2TVdzRTZ0dE9rZFE5RitkYlRoM3pneXkx?=
 =?utf-8?B?Y0RiNEVXSEEvTG9sNWxiN1cxWVlpNzlwdm1LcnpueVBDdXppZWp4TTJITG1n?=
 =?utf-8?B?cGQ4TFFDWEpGMTB3MnBNSHRXL0lQM0pZU21LZ2c5azNKNGFDNUtiRFBTaWJm?=
 =?utf-8?B?aGUrQkNrQnNXWHh2TXF6Q0s5WUNiSEQycEwrQi9nRE1FR2VVdnVYZVdOTHVL?=
 =?utf-8?B?RCtRVDliTUwyaGFRMzJmQS9UaHRKTmU2Y1kzVkg1MC80bTNGS0FVZm9YUWpz?=
 =?utf-8?B?S25tVUYyU2RoNDNtcnFFd29rWGhXQnF4VUk3ZWpZbVo4cDZVWWxTTjBzeXpK?=
 =?utf-8?B?TDgwNHJKNm95L0RSV1E4Mm44RXU1VXZwWkRJYnpodXpTYWJkem4yTHd1V21q?=
 =?utf-8?B?WmlZTnZBYXp4dHlOdzFTbFZsOVF4cGxVLzRCODZyQWNpNk5NWjhad0pVNGV2?=
 =?utf-8?B?UFhha1NsY3VkZEJ2RnFwY2dqck1BT3VkSlJxRGd5WkFKWEdzKytPV0wwT1Y4?=
 =?utf-8?B?QVl2c0FKRTdPbE81VGRtSVhtSVl5R3kzdi9TVGU4K3ZYa0RCTDNDQThLcjdk?=
 =?utf-8?B?MVNoSzR2alRQaHFZcE9pMlIwRERVTzRKYVF6cTM4aytRL1ZpNk9wRHBmYzVx?=
 =?utf-8?B?VmJ0VGVHT29MWlZaS3NLYU41TXRnaHpRZzJiaitPT1ZMWWxiS3Z2b1VxSktC?=
 =?utf-8?B?NWkrUmhtaTZzcXBKbzZsZ3JVSE1kRDkrT3BSSWhZOHErUUhicU9Ua1lEQ1BT?=
 =?utf-8?B?SEhCa0g4NUVraUFSck4wc3BVMjA5bW8zc095ZEtib2lJUE9zMVZiTXg1cnpK?=
 =?utf-8?B?cDcxeE9QNWVveXFOTGxBT2ExTEpGZVR2TUJQWEUyZyt5dUNucTRpSkl0NW5H?=
 =?utf-8?B?dCtBMzR3V2dsRDg4NUk1akRWMHRoZ1VhNjJKc0l6ZFJUOHZ0MWx4eFJLRU1E?=
 =?utf-8?B?S0xzWk5jTVIvWlZhL09RZlZDaHh4NCtKVStLSE9BaEVBL21JRmpYaldPRk5P?=
 =?utf-8?B?YXkrODN3b2Q1cEs3U0tkNXRETnNELzdPTTJKZnZvcGEzNmo2NDR2SXMrRzRE?=
 =?utf-8?B?QVZ2RXFhYjVnT3p5UVhqVzJ4TXo1eERMQmREOWp0NGo5SjIvalhhSXd5YUNR?=
 =?utf-8?B?eSt1U3A5czNtM1FuSWFnYlIwYXJTNktDNnFNa0ZlelNxdkJWQlliNTdYcDhZ?=
 =?utf-8?B?U3RubGVmbW1xWEx6bk9Jcy9ObWFSdko1cytOUkxWUkhpV1hIN2Q3MDkxTWtE?=
 =?utf-8?B?ODJURkFSczNSUy9uVjRjUDFzdDZTSUxXN2NLNkVTZGUxa3dHN0ZNK0Rtemd4?=
 =?utf-8?B?R2U3N044ZUdlTW1pY1Q1b2ZuQm5OdUtZczdhbm4rQ2trOW8yRDE2RGtoZFpZ?=
 =?utf-8?B?dmprUzQvTXRIbnZBYWFXWTg0MUFIU1FCS1Vici9zZm5YL0luZitJdTRTQXl6?=
 =?utf-8?B?dnJwK0djYklLcEp6REJNUElTRHdWUHl2Qk9OZGxpVWJ6aW9MNEt5d1dQdXJ6?=
 =?utf-8?B?K09LTlJMcEcvZEFWYVdhdTV0clZLZ3pSY0ZZZ1RKZnYyV3AyNk5oL3QvOHRS?=
 =?utf-8?B?YjBrVW56YS9WMXlpNkJZWXlzdUZCQkJXMExnTDkxTjhFVmlxRGFCRWN0Y3FW?=
 =?utf-8?B?L0V2aWZUbmZGRnFSZkxBdTVTNDQ4aTNVL0VBTDVQaXE0WGF6V3gzODlGb3BC?=
 =?utf-8?B?cXhDWm80QzdYZjVGa05Rb2MwcHdkMnlrL2x3anVYNDRnZ2hRUmZQdVlzeWJU?=
 =?utf-8?B?N0JBZU1ELzVFVzRHZEVCWE9pV25LdDNmMkNRS2s0c0NDRWk3TUFZcGY5d1NT?=
 =?utf-8?Q?Aky9uxdbUqOcxH/fzD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b5e4fc-56c9-44fc-ebc8-08df230c6d88
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 18:13:59.6078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9obrgPESDeqnlaixAeZnXZGbDbYlIeMT02ga+Uh4kElYHPnyxGhtSXkB0DSNm2v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4080
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7521D40007
X-Stat-Signature: ergaze8hwby5bas9csdtzncbshfxub59
X-HE-Tag: 1791224048-250439
X-HE-Meta: U2FsdGVkX1/Oc6y6IL2mZ5+6AokVT+WFsi1HasOlhaYY5rqyJVb3Bllh6i5y9b6RmgQPVK12YkPBYz3CqNkLkvOM+7hycDzxU/u/Siv1ZbHhA77rGC8rdB1ESmHQYXTq4HbjbFNPi+cj7ZD5QRnpVX0+1+W5eVW4eNTfzQf7Cag7XLpdNsT8M7TeaA1ldCvN+sj3U32bZtZsCKxVZSW5oW5amQKUte3cEvEA97y7YNrkoyursa80m5TrEIMq4eC4gCvmLuFFjruWJgy2Qe06FWbblJOWJyF6fDKxaDP+OhPVOOTi5/ADFxoHZJgP/2J/uo2r/obq9G+9QQhozcyi3gBG/4GaMfRytHC4BhYwaZLYA2V6KXDxiAxEt885FPqNB9aQdnOCv+Y9d6An7AQlJcOascKGtxPt+v+eiw9M8w7hx9VysmIY5l91xb1acIwIlj+o4iW5Nt5h2NOdypFuQlCEjYtapkwmqmG3TRXyxKAS6OohiwtvTHH0jQ9nk+6XcV6iO3//aVOWD9uXzMEVfEYNVzaOMF+oVYZs/4Kvlm4Y1WFAedBnN60CzgklRRAl3sUZAqErtgIwyakVNDdDwhAg54iV2WLVjU4+g/jaWZlCLLNbeQJ259gT99hfTLuFsmblaRbKWU4ShdvrObAZh2Qeenr5OP8FRDeK1NgRuXtibPCdblfjG4gJMbgc1XoDrMD04pJj4zB3PbF65LMlOcQC5uLtKvyZ4O6tmVWF9GJgos2vXXvREnKVRTdpGvYdOhywgOggZzovcFThfXilmDksGLH3LoEBxwsHbcYQLwGOkgQWv75PwKpnzBmfRQQ4U2FpTJ/9RWxJqWKISzbazPrdJ7Yc1HsYhI3j6d3rq6bT2OWcgJJBVbhOB9mrDua17zPxcdlNo+T9BfvZmNnhaz3DXH1I63HpE9s2Hu3jG16smL404fPkcdslxgv8AjQhaYvjdLSGz/WGQH/d2fw
 CkdGOJOI
 T2LsUf/tNVJSUs8YQlzTTtUK5Km4j2yEBKBEODwimZFASqkKPz7RTqWDME3e+/Uaao9l8Tk6kGz85kk9axn9AzVmRS1obAZwnhcBShLLLMvFz5LCAwlr33cY8IZHt+FYaWTyMp+HOHn8tisbyAYpPoH93w9fX5cxTjQnZhsJBKDgkNsY8GKvCr5+453JbwFv6XEHuKkE1TMn26SI5cLQG7DajTfpOSs8bJod0tsW2b5AkYukmXSVDKI8MgPnFSRgWDM2ZqA4b/0Qlt+JpVrLbQ2342S3e6tXFUr9bp+gJ8Idk4ZFAVmLbngK2T+TeILpW7dkcblG4wigeAT/LYd7HtSrtmgyIx+SLasdgD2oAjMEpZO/lEIqUb+gqVbt5WRAX0s18GLIwN6XEzkK/3cfUF69SwW6vvvHDSbl6O00ifShgY5y52zu/Vnf/tlTqJTPgm5majavSaNqYhCst/dXkzbUM55ntH4RzpNfjER53Ostd4/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Oct 2026, at 2:29, Will Deacon wrote:

> On Sun, Oct 04, 2026 at 02:06:48PM -0400, Zi Yan wrote:
>> On Thu Oct 1, 2026 at 7:06 AM EDT, Kristina Martšenko wrote:
>>> This series allows the kernel to use TLBI domains. TLBI domains (FEAT_TLBID) is
>>> an Arm architecture feature that enables a TLB invalidation to target a subset
>>> of CPUs instead of the whole system. It can improve performance on systems with
>>> many CPUs. TLBID is not yet part of the Arm Architecture Reference Manual but
>>> some of it is described in the latest XML [1].
>>>
>>> The goal of this series is to send TLBI commands only to the CPUs where a
>>> process has run (i.e. where its page tables have been installed). The last
>>
>> IIUC, mm_cpumask() is used to store this information on x86 and other
>> archs. I see you put this information in tlbid_domains of mm_context_t
>> from patch 9, although in the form of tlb id domains. I wonder why not
>> make arm64 also update mm_cpumask() like x86 and other archs and derive
>> the tlbid domains based on mm_cpumask() and a cpu-to-domain mapping
>> (added in patch 7).
>
> Historically, maintaining mm_cpumask() was a horrible source of contention
> when we looked at it in the past. Maybe that's no longer true, but it

Do you have a pointer to the cost you have in mind? LLM can only finds some
overhead reduction work done by Rik for x86[1][2].

[1] https://lore.kernel.org/all/20180716190337.26133-8-riel@surriel.com/T/#u
[2] https://lore.kernel.org/all/20241114152723.1294686-2-riel@surriel.com/

BTW, patch 9 is updating tlbid domains unconditionally. It can be optimized
in the same way as Rik did for x86 mm_cpumask(), read the tlbid domain first
and only update if CPU is in a new domain.

> would be good to see some numbers if we want to start keeping that thing
> accurate on arm64.


Best Regards,
Yan, Zi

