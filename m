Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBBC8606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Hmt0GuJK
Received: by kanga.kvack.org (Postfix)
	id DD4976B05B4; Tue,  3 Nov 2026 11:11:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63F06B05B6; Tue,  3 Nov 2026 11:11:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB646B05B7; Tue,  3 Nov 2026 11:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93D9D6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:11:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F3ED1C3C7B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:11:47 +0000 (UTC)
X-FDA: 85394298654.02.AC537E1
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010030.outbound.protection.outlook.com [52.101.85.30])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9E3934000D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:11:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hmt0GuJK;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knVfMihA34/swoT1UZQLVmq2kD4XEWEDQcjVhXkvDZM=;
	b=DnPI01mhqemJqmZx6EDc3YcAYoeYAaGWvudpKg3bspMDnyBW5JzMQoXaMcYHJsaaEumiOH
	5agQaZsKcYds9yrhmT1B1WuiBIlhZ8eW3SMewOJLHU/aoJ3EuI1FyTTjKAszJTblzywddc
	BAkzNx+pgdJxa9vCSAWzSXq4U+UL3HA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793722304;
	b=YYtoyn8+qVDIm9wM0UNg4ycLURAcNTtNuaWJq21NQ789tjv1gWngsLJv1l8unjZb3YsI3r
	U6WxiEkt/Ca4s25JjMS34ib7Z38esIgXQX15sOA+YD1aB32SFdLCs8KQj67H4zSP9PVlkc
	yz16GSKvLWJhtuJD5TaEdl0p+XZGixA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Hmt0GuJK;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s//XKhahjsd3vJTNemz3EyIMJrnkMwD1hOuJ4ozbkjTFxSys4t1i9G99vALIGB2xvhPLEqNfMSxrTnfyyTopJ3Q/Wx6o2av+KFuBHewEDP12k7uwcFE3yAcNyjQcQ55lLF1YjeCJTTS+Eg6f2mBvNcilXmVjklCYee8gNYd8jwpuQDfOH5PtcFS4ikr70zaHW+NqnLKwWikhlqWdJ+TYNovnGfCP/dWSKQn3J7ss+/+AOcWoIPrP4SDmy2YifEvD9WlmWH+Ua5d3E+Psqf2nKeLnzR+0btGNd5xQG3JIavjnTS7+/TeqdlVfkaZL/Qh0emQrFp4sVYyDu8YzkLIfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knVfMihA34/swoT1UZQLVmq2kD4XEWEDQcjVhXkvDZM=;
 b=cfM7c4IhQxWcAPaglzXWN4qRiZelvMEfcucPhdiaT9sLNkePRDuE6Xwof9a6ZXNHykhBGsF4OldliNuE+SvcZwX8GXCsV8NDgiPZySC5+zGIcJ6k7bvxjkP04enaulVHf4+CScBIWNFHplkIbYbTW4NrKjTj1qYmDDtsmJl4zyZFDvygpdviaqDY3a4Ed9UmfurQXV+/Ubf8fq9XxKC6dmq7FszA8r1cVanjHECPI+/UJqX+OT4RNWRpUQ8SnguOCd7AAJJOuxNIlt7hMclirAlk6c678F4zJisln6QVhQSxOvh0jnuWmgh6hszBVqkKpRTWUuZPhlU0FY7zKJDDqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knVfMihA34/swoT1UZQLVmq2kD4XEWEDQcjVhXkvDZM=;
 b=Hmt0GuJKlBBcGyePUJFsses28r88zPOlkFMGKxI1zoWc8Wp5gJMCjiR7njDCinuN7ZtO3Il9tDwR0Y/zIlMxSgRC5W2KoCz80+QHejggVicnObVYYPB47WhsmPjfF2jNBM/ftjwqqYj6nfOg9+vw+FKdkd3dNv1rnlfVGp5FMoj58Klh6sm4M9/IlIR51N5QW6WfvTE//t/HZmPRmp2yBltD5pAXQ0lzAJ9naRGaQAjVoeiCWlfOZxQXIEa/1M9ASHhpoivinutkzTgeRjAKJAaUymQ9kfqj5OIs0+DAbKbv5HhVlsqRt5MC4yedD6OGEDkj/R6CgSqCsaiJl2UL3Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PPF884E1ABEC.namprd12.prod.outlook.com (2603:10b6:f:fc00::658) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 16:11:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 16:11:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: fix format warnings on 32-bit architectures
Date: Tue, 03 Nov 2026 11:11:32 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <29C315FF-6C6D-49D1-9C6C-243903B425E9@nvidia.com>
In-Reply-To: <20261103155451.534587-1-sashal@kernel.org>
References: <20261103155451.534587-1-sashal@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0368.namprd03.prod.outlook.com
 (2603:10b6:408:f7::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PPF884E1ABEC:EE_
X-MS-Office365-Filtering-Correlation-Id: e306d695-9cf9-498e-49fe-08df39c5214e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|7416014|1800799024|6133799003|18002099003|22082099003|3023799007|10067099003|261102123227099003|56012099006|11063799006|5023799004|261021123027099003|261026121527099003|261026140227099003|261022105027099003|261028144727099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	txqsWMVIuPYeqGtXG31Iukyp9vCZtGsibCi8ooLXEfrNkQLnjEgS5VtqaJKxYgQAAHT/0VWZo6H/dUZAtTD8NzQ/6U4ctC6p3HYR4Rb6YgThfNOjvVgLodzq6uZTGZtdBXtvW1dJztSBfEZGgIoe80eAsfq8mHsJUsc7YXwuy8dQLoCEBzEEFipGQ0po+c2Y9PR9c4k520qPL1tSxKho54FpUZhu8pcUCmw/7cbj2F3Zk2plHw3EfGVAA/W/V2vdu415cp/KN+rmblxBhFB8CpOkQFv00j3PjftVsqyma27iyDfdT9McCtSjSafcmzNyfSkPRfXXHY/w4oj6OvGg8e2Sr7/W9Oz/RwxWOcc13x9UOrtYTUkVNq8w7Nf8AgG8ss6Zkz6VFw1WttxiMEz95XDBa5df2zzhmqGUwxxOj5UOJ/r4K72eyPHa7xqabREB0GA6RVyLoHTLz/nhTGtU/QcXXjzzx1gjzcusOuNwlNLn11KTgvz/HSkNBwc4y5EaFlOgze+IPYzVqpW4W9q5WySZCrwG+Uy/ASKSQxW4k3t8YMAkaQO4tWfC7q+Wb1TdRlAi4Jkg4EmBhZFCfFIGdCpKMaGMZUwPCwN+ToKTnNtUfvW5Uc9rfXqgFzNcWN361EQFRcESYljyD4gDubthlJ9kifWP3uhLB2tVhLQvrbg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(7416014)(1800799024)(6133799003)(18002099003)(22082099003)(3023799007)(10067099003)(261102123227099003)(56012099006)(11063799006)(5023799004)(261021123027099003)(261026121527099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hj56yKpFuMMJasqq6zJLMlDgYgXjV8l5zxU+wSbWdxKVsEIhqJ4ouhz+IQbg?=
 =?us-ascii?Q?Ne9utpUZY1Wl/rASt/0h2P93bw2du2tXl7PjiJyymJUnC9kvgpQTl0Aw6+KO?=
 =?us-ascii?Q?1B/kCCfqd8M5hVat09U4Z/zWEqzIe0kbLcegjdY70EQowrxZmP98gWrPYPI5?=
 =?us-ascii?Q?sQbmn9KVrBarPR07r/QENwxwHMgFRNjEA1tT/QgUWIIyCfrCxZNlekiVODFu?=
 =?us-ascii?Q?1H9/qnIDgiuSkCoF6Utp9l37wHmIm8Dv/kepLh8XT2JzRaTxHikXAU6Okain?=
 =?us-ascii?Q?cQtYX6xQYcvEVctTumfyiYfzFwun122zRi6CSN5IQMpiq8WRGVohIgAyII9+?=
 =?us-ascii?Q?m7cyGNEb8tfUCHWXgGzqPNTfjcWdhOgjKJ8GUucalOkavc1/HhIuPiNjlVBj?=
 =?us-ascii?Q?cUkWe9aLtiR557G11ceHBuQ4DJdvdgEaA/0oXmDC7c/iKtzUkKeJOsaF85cJ?=
 =?us-ascii?Q?HkHWLWNDbIMc7Ydn0NkRg5+3OQfej+I2xH0zXTyFXpYZyjkPuW73aakU1Ito?=
 =?us-ascii?Q?a+PYN/Qk29KmPJcnvdZMOaXTpUHBiPC2ynrLoj3OsyBl4qVvokRVkp4FPljF?=
 =?us-ascii?Q?pr7mQga6731KOdVWrKrdaTN9C7+p74SpREN5Z0qksf1UtHTWDpo+SyceUYvN?=
 =?us-ascii?Q?tUU9qrXoAJavIT1xgRAL6ztmhH9ijecBvEBGXZW6KW2BmC3lsakjfnukFrvU?=
 =?us-ascii?Q?Rx44/OAlYASrL5Eg2vJEEcg1FrLXGyKk6vFFo9k4qE5mqujkRV5CfS4fwonR?=
 =?us-ascii?Q?H0ROuuqjPzoc5TAA1osh4JOU0Uhl178Py5zgkjBQtsDMqX/azEKGdPeYqpBg?=
 =?us-ascii?Q?ruIZ6JEctyWAvMwnd1y6TZW0zZlwCShJbzlxs4JKzwxKoINeDxG/QycKVuN4?=
 =?us-ascii?Q?FPGZ6fpzzPWgPV6ROoYdxMZGA/J0GFTHK4q2/bk+7/cHolUrt7xtz9LEEmyv?=
 =?us-ascii?Q?xryPmqg5LqDF0Eeak2ytkREvAo8PEuz53paZRZjV/JX19kz2sz6d8SmpItKw?=
 =?us-ascii?Q?19cUXqqA/IY/8I2U1cn7ZnTJtY0N0EEJmQ1n39raYHPpyPdbaWvl5mWc6TpM?=
 =?us-ascii?Q?/ihFb4buk3AB8SL0LT6Vkj48hL55F+Wxv44oyN1x08lK1V4iTWNyTsOjBKbr?=
 =?us-ascii?Q?s82FHAiC6O5BQi+CsyHomIlMnrPrJiMOwmsPba3Rl7/tT1JvTeoBNc+cH+Os?=
 =?us-ascii?Q?OnCjlFdepPuZBPlUR9I2HFYKsXgukdGxBEHDlYVOAxM7FNlnEs+fJk0xaN3I?=
 =?us-ascii?Q?TTSPeRcmUVsXz3MnDon3MJYS0XwLerPw6aLaMTC+zSXs/7O6u7mCdvqoZ2Iy?=
 =?us-ascii?Q?EVwZTpTejq/g2Tyku8mGe5K7iEZD/RTKNCLJwVGp6fYnxAVLARg17NhKLsnV?=
 =?us-ascii?Q?l45WnY5fpIIaqLAtaDgYXAAjAggSSiVM9p2oTOUd8u7i1U6Jiu1jSIZthCuS?=
 =?us-ascii?Q?2p+zvIKDxyJBN4EFHvAbHI5P2F9lTS7D5Gw6fQWANHKO4gyZ64jW7uVm4tSz?=
 =?us-ascii?Q?O7NFOuArRRyFOV5ZXxR/KDnBWA21jCfjpS8g2E9H/+HVBFAexjaLZvOB5KKm?=
 =?us-ascii?Q?At82WdvflVkBKRSsgUFxJRxJgQjpkJ9nDDwzyCVwnQj3qhksx4NmFBTTNp7y?=
 =?us-ascii?Q?udgGaPxCWlEEjz931fkTKnr3+fV0X+rZS7xEtRqvYbXNaqG+ss48v/tK+Lh0?=
 =?us-ascii?Q?ChPwiYlcBij7P6THxAjCM9oSS7wA6es+miSguJoWgmfOwaJV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e306d695-9cf9-498e-49fe-08df39c5214e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:11:34.1647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMiHqqmmT8F4ce+oxaJObpoInlFECMgP40n0fM+ERtEr7mC5BpgeTLfHXWqWyTO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF884E1ABEC
X-Stat-Signature: gutkeg89fn6yd7ok8s1hz914rep8xejp
X-Rspamd-Queue-Id: 9E3934000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722304-700596
X-HE-Meta: U2FsdGVkX1/Zw0ps7dqErmDibKCv6y3PKZGoGzwRFWB8tN+S5XUvHvW9RrdCnQiHV2uZN+8Q5P3Y8PsG2syiqu/gG5QajzV6u0NaPvLVAIMdUup6M4bMYj1SNcfrR1Kp/I9mZH9l2/lvC/12snbnIeLK9uj3F/uTr+Yu6j3s8RaEJKracaA0hRym6sYQCkRnvtEpQHVrUrLZaalZgvCBzN2eG7/+5YDPls0vr3VM+iyUR4GoUEqhYwlr8pEpzhWSs9rL2lhY+ko+HIrFYC+xSQ0UDjK8x6zEIET2kN1BENcG3FVYi4Bcxc2M8+rM//Z1EfJkJM1A/xnpa+zM1GDtBhAKj7IX1/mJPO9k3cfXT+PjTYMwI1JQY3zB8Bjrw/fw/BtrFmM4p2l2EPDqJfPJseb6G+DTJkNRc09yuzWdtfsD47YupKLJWOnSZ/FR8cvoMJxIyDI9rBB0uoOJdFAE2rE+6zYENBbiI3MbqyNfly6twNixyMuJcYUL1CeKNah4Dul+pdegZvcU1TewUxjHGNdUaF8G3PIyjUHNrKaySG7N6f6WS5o9U9f9kdjdBHxr6yTRyKdVTmGY+5H85iZjQ4Z081uGEt16rNo5l0a3SJI3+75VoRaROjQtCBdmlngWny8eu3WGoMO0m4fdxkSev66unmObbADRBxpb5EfzCb2bZ9BK6xB+XCDPXLI1UBA/UhqGzsfF7reOwurfkTfLOp2DsxGqWmPX2oRSVAxaSl3PwglprjFbO4YpDYyk6mOF3G+j5SF92oA4T0c/022ETthpnLD1tfGjmdvcFURVWGD1WZxeB7dIJy5ZQhgCOL3AeSDdjI3afm077PS65qn5IJjeamAdP2akrtQ+91m4yk7VjZ60W4TdPFc/NYLn1RyE/Q5prQwiEY8ydDcthN3iTqlYbhAhq6rosNb06uu6Sh+07bTdNfqtoFvk9bB6bsNWsiO2YFFtV5Sy4d1RgTw
 OV0lOgYG
 Mq26Wc7z3GjJv9uRtVqL6GyeDK2NTQ8VO8NiakUiYd2Aad6DCgbw2fgvvo5ApK6RSLxQqL/DAIv2miCYLG6lFxHH+WzHSOnws/jf61Rdz+IaAsIfeR5N/bhs4Gm53SR9ppVDnFQYHAjCHewYg89iQlRjjmA9JcHlzr95zItZdXZxMRtRU74rMoUwP3DRbjFlQAr/YBpE1/K9RFp9d7yDnLzUdqGBR3bUejFfmScfSKvDc6hj6OnD2wwDTQTzvccHQbvnFFQAB/VQxdn+eY5ryK0KRCnYqaod0Pr4XbP8w8xLM5XYQ9Vvs4j1y6aZiP7TKyzllAPZGtD5+bhyICUkrtLtuHAMGFildCnYuWYJdAQmkEkgH85vuEVdYGrJZHKN8AZm0yN/MJXhuEFPD9PKSctBbTMvJ6PnkVPHF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 3 Nov 2026, at 10:54, Sasha Levin wrote:

> On 32-bit architectures size_t and uintptr_t are unsigned int and
> ssize_t is int, and with _FILE_OFFSET_BITS=3D64 off_t is long long, so
> printing them with %ld, %lu or %lx, or scanning /proc/self/maps into
> uintptr_t variables with %lx, warns:
>
>   hugetlb-read-hwpoison.c:32:58: warning: format '%lx' expects argument=
 of type 'long unsigned int', but argument 3 has type 'size_t' {aka 'unsi=
gned int'} [-Wformat=3D]
>
> Print size_t with %zu and %zx, casting the nonnegative ssize_t read
> totals to size_t, print off_t as unsigned long long, and scan the
> addresses into unsigned long variables.
>
> split_huge_page_test also builds its debugfs commands from uint64_t
> addresses with %lx. write_debugfs() has no format attribute, so nothing=

> warned, but on 32-bit the commands get the wrong addresses. Print them
> with PRIx64, add the attribute, and cast the pointers through uintptr_t=
,
> as casting them straight to uint64_t warns on 32-bit too.
>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> Found with a 32-bit build of the selftests with a 64-bit time_t (gcc 16=

> and clang 21 with -m32 -D_TIME_BITS=3D64 -D_FILE_OFFSET_BITS=3D64);
> KernelCI's 32-bit arm builds show the same warnings. The changed files
> build without format warnings there now, and the x86_64 builds don't
> change. The other selftests get the same kind of fix in separate
> patches.
>
>  .../selftests/mm/hugetlb-read-hwpoison.c      | 25 +++++++-------
>  .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
>  tools/testing/selftests/mm/mseal_test.c       |  2 +-
>  .../selftests/mm/split_huge_page_test.c       | 34 +++++++++----------=

>  4 files changed, 32 insertions(+), 31 deletions(-)
>
<snip>

> @@ -70,7 +70,7 @@ static int check_after_split_folio_orders(char *vaddr=
_start, size_t len,
>  	return status;
>  }
>
> -static void write_debugfs(const char *fmt, ...)
> +static __printf(1, 2) void write_debugfs(const char *fmt, ...)

TIL, __printf() tells the compiler that write_debugfs() is doing
printf_style arguments and the compiler will do the corresponding
checks.

LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

