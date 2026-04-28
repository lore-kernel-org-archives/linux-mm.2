Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50161FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7871C6B0005; Tue, 28 Apr 2026 16:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738616B008A; Tue, 28 Apr 2026 16:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6005C6B008C; Tue, 28 Apr 2026 16:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD316B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:23:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA536C1BDC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:23:00 +0000 (UTC)
X-FDA: 84709088520.13.1C258EE
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011044.outbound.protection.outlook.com [52.101.52.44])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20632180007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:22:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NiDUrb6b;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777407778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Va9jm8B70jouFdzlmjsHkoInf00rKaKXEONb7j6LfQ=;
	b=WcYB3rcLL9us7bKttkCvyNVP/ASdNYsZr/kI3c1rsOdnQ+Qsg+pDU+AqFy+xQU1IPIiHPe
	W2YTCun9+VyCjXoZcpDzx0cnkfuMoJmCSHmmRBmb1o8FEuewlCN2p63nwGAs+A3UgHBFEP
	B5v5QMH3HULb1+ZKFWSDo5hezQwY/AU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NiDUrb6b;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777407778; a=rsa-sha256;
	cv=pass;
	b=0X9fPeVZlLNMPzzJbKGn4JA4TLx5ml5ERk/h2CF6PUcp92IdN9hWDR6Lx3CafHqEuNmB5h
	Ltf/KGhYMaNMiapZOAZcRvqS+b9nHSurq3vvp56gUKj82mWjYQiqtXuxi8Gn4Jn1fGQFz/
	LM4mnlkP3GZboDrfR0MT0fVfVExolU8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vfS5d+0I8/oOHG9DhU+y+qcmSbasSnU7wUbkX5lVRW1U2YJbqadgZLbDYuoYsGr7afcmcSs2/aK+uLK45vtMwQ1ImgkWX/geP9Vwm1ay16mOtTvXg3TD1XEtRfiRF9SWGL99AgjUIAMHj5m5NyqmIJSqSXi+NGYR6x/Oqaw5XBYg8RByUL73zRd6AYamyj/MaK7e9G/h064KaqSa17rMxjLdHCC8VV3xwAr64QT5qh75uqCcZbA1SafqVh3I4kzb1EQoLxn77tBUJv11rOA2N+MpO5A/jHVp7cx8ic23ft0PQEvxaFypgf3lpzEhTAIbgJSoZN3m8AcvrstP7248MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Va9jm8B70jouFdzlmjsHkoInf00rKaKXEONb7j6LfQ=;
 b=dg0cI7235m12UKNzT/bx5ASUhma1O1jpSamqrozqNp5L9gBJQ/j1WBsPL7ecbDsN86YvElTuZ7M92hrk7z4NBq5lD5CP4QE3L+oTZQsJXSfFt4FpcFO5kGN8q54odxPu1YaD8CVlyQMMdXJEiZb0XGvN6lQWRQSfx1bxWet0OKkB32dQydAX/dmH3dvD0j8RdhDAEo8lmkhBZR2YsPGapl3NnW6TPKSCToxhK9oC4zkwNIa/d3gzyxzjDhv+e3HXIHzomsVU1pjCnHrOJ/sqFJT41CtMFs2LLlRQfgGJO3j5//QaKsN/lUK9r9bcB6i0ZQw+qzK0G88FPCKpH9wLtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Va9jm8B70jouFdzlmjsHkoInf00rKaKXEONb7j6LfQ=;
 b=NiDUrb6bgkpwVafzM3tL9oS5+/1GEEM6vtkl4DsxYFIdb30E0gZkkxIUn5kgPpUOcWNRDoGcIB9PTPkDNSghNMq4pkJ+nj+/kMCI/NI4Re025mnPLLDphiOoCZkvR14w7zV0EKYbF3+n44pt+e6kgJnIZJ5aKD3lDS/Rf7q5obftyRcfDPZQgEOx3bN2JM5p09cgLL1fHAhhVraelT8BGzTJHWvW9CqS+sDC4xFdv1LjbirpSek2t2TsOAMQgN3bE6Ux8t2WhT666UmS5ARfQ6jKDJgF1b0S1qeTOZAvGaD0BBnRY6BYcgMooeAtiBxBQQHvjDnHxkHRinyj2k6hBw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.16; Tue, 28 Apr 2026 20:22:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 20:22:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
Date: Tue, 28 Apr 2026 16:22:45 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <83EFF919-7A84-4773-8C16-C51C15C3D987@nvidia.com>
In-Reply-To: <b4fad2c6-f2c1-484e-b6a1-97e763a39ba8@kernel.org>
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
 <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
 <95714cec-205e-4b56-b8ff-9afaf9408020@kernel.org>
 <0FA813EA-5EFA-482F-B8BF-FE65D4169C44@nvidia.com>
 <b4fad2c6-f2c1-484e-b6a1-97e763a39ba8@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:208:32d::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: ae3227a5-e79c-4218-93db-08dea563ea0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MVVHiwa3EJ279pLnayQsGW+8jvu3//PooYbiE5WFbccjoJ4+w0R4ao+PB9xfIAx4WUcbqbt8gCHrV3n5hSprD1pyTj+alLQJGEkDkmnpTTmn/c5I4be5OovcSDPdQAOdPQjA5qgBPleoc8RL9/26r1pBSOjdtMI55dxgWPvl4Dat7cSliN7krYm0bEYKULLCCXXM9kMOdJ45ZwQYQmUagdH5/hLhky1xpHFSF61wM6+aYh9SHDeLs6M1y35Olvf+M75ae4njoRfuMKCa+NT0zh7VdxdmyDLUY3Ewhz+NsFvU1VDNokMT033stW7hhbnXhdF4Vx2d4VVqdeDNp6//CKTZfV3n3bw91ZC7PQ0WAR+gMnM2MC01w4UqI5s/Kb620r0OyCakuBZpxi4l6DUhLU2coEPFm/EubcFsuA7emwYaD9QRuzkN5xSQ6ZyK0H9xJcpffzBVNAXcNCEbTBqoJytjWzu0ZUtc7bOm3qgtd5pFoRroAlWfBMVtnXsEuisArp4KL3yK8fGmZ8yxJL5bBTpyuwcCTXQe9FgR2t382CJ1YLDYAalUFrG8XwT0qOioGfQD6/38Tv97mZ6ZKwj/9svzCjuDJrUNOfZ4jKGrR+ri3ToeQpr0vP/ps+5Sl94RLAGdU+T1ulrW4+W21bzZItD7HjPQiDweZqeIYpVnFSHjGlNRn1nYfVAwzuw3vq0sgFDMPAcWkAzVFy9h3Zy9/Hw7C695BzyRvWaPLD6C17c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B+2Wsmt1/WWdFq0H5xuatIl7v121FefZrwraf+5elwd9VC2Zf7yKFhqZoMoe?=
 =?us-ascii?Q?ojEAkJQjnS74N7+bFYG6FjXNwJ+JxaFzTYhX76r5h2Ht1HyRrzKYmFLRDEbB?=
 =?us-ascii?Q?VXQgyrvaruSFwZBFkYBIJj+mpTJ4yWlXl/y1+S1PlsrP3z33AOmowHjLqPxY?=
 =?us-ascii?Q?u9F+MGm9RFVBHDnwMEipwLz3R37EitswXiosHD97AYwP8Jgxa9tLcdf4TGEa?=
 =?us-ascii?Q?S4WZDpjO5OU432hWD+Y+1xHvwlhh5rW1+Gpf5CqT5J2l1TMeZWXVVgc0+y4i?=
 =?us-ascii?Q?uqgkaqt64MUr3JKw3fok4cOTQcPssYVC8NY3OOBzgmIs0pK0pxg94LQbXzo1?=
 =?us-ascii?Q?y1npt6mKKBOb6aSiKbpH5tcIGsRibNzLrNEoyYQbmaRpDQsVzQOEBn4PJAei?=
 =?us-ascii?Q?AiOyVOE2FG2GRGVUAe+alWAuwye3lvChh/Nvp87nKOOniitQ3qyl+T636M1I?=
 =?us-ascii?Q?W0dosnbXeWd/3SN13127s2KJtmWh2Ybk/W13qclpiexFmtJG2DwDDJrf48GJ?=
 =?us-ascii?Q?j7Mr52KeSDDbcbsFgX/0MGRMecf+F4UkAM8w/uNUxCz2D/+6kRDU4fEFv1aT?=
 =?us-ascii?Q?6pXHvbofLO+ReP/aXeUfWiNTK598E8Q+DuJdy8CgX6moDxrZNOyfm9lqweM7?=
 =?us-ascii?Q?e3o4SNpfa2gZhqpkY6BGsY875aajvuvd3VN5tEYYoKbD25selRIhooY2M7wo?=
 =?us-ascii?Q?vT7GJRy/sg6Xg0O8jd6jgqTliFU8pH+YKeibbK149qvdI4+BQBDd1QK8U27z?=
 =?us-ascii?Q?F8Z1eeWWex9IgXuGU7ZutvYCCj+DQoQPkST3YvhC25iMpfdhVV7204O+IxtH?=
 =?us-ascii?Q?FizIlmBbMoOq9IPA3IKRkEe0D7wj93CkM7BFirbamGwgC+D6fzj0HQjSm8Ek?=
 =?us-ascii?Q?bC+YEK4IefJuRbQOjMSN2F0cx1G68lk+zpF9uGkg+JRIyO5cBdb4mXzz6r5v?=
 =?us-ascii?Q?ne2GRFmIiCSQSY+OrXRjXetVUXZVfSgzzcEhZ84t7CnNZa/sK6GAKDhWpzj0?=
 =?us-ascii?Q?yc6xMyvQmzcNTC3MLLWtzwkxYgdGG1jlIxVE1GaO34GhvwS4dsdDmKfEgQG0?=
 =?us-ascii?Q?aaU4g4PhXDoxWZ7u3I3KhvFpHxFln3IaInjq7s6x3l5J79GyKE6CGwjFNBKX?=
 =?us-ascii?Q?a8/LQyg+U+2Cl+XhWA7jP322qrRxCvqhLAcxxKXsbh7zn1jxQr9+F7GAIpUG?=
 =?us-ascii?Q?QTq1u0DAnMUiXLREFUcUgs9enYzhK2iJuuHeQQAWdDMv2LgnTjLEi+LaQiLb?=
 =?us-ascii?Q?FEzWKEaHoPdFiaETAaOYWOSrNiuAaRrDB1JglliO4Xo11xL/QtZNtZd11Deh?=
 =?us-ascii?Q?QyPGMSJHk4d9Q5f1yH0LVtyokMdKSlSKPaAt2yXxrfVoV6pdYvmfrb5XZGU6?=
 =?us-ascii?Q?Y5auajy5M/n9P4Jo5CqCEQoUPrHYjuvSHToj/Vi/MRDKcWbHZ2H/rEjRg9B0?=
 =?us-ascii?Q?Xh69ak0bZGgtfvdyN5J0mNQgyF7C54JiGBVotyjWhNb+PMc3gxU/FJFDdOSe?=
 =?us-ascii?Q?3IkU49MOYiuGqEuXmHXxmHSUrO99VvSS1tLew0HeAU5YwUlV8klEwz3JWlAt?=
 =?us-ascii?Q?RH9/jSotFKpigdeo001KhdyPYbNYyZKMQEIOlOb++Z5CKbIMkeK3A7g/c+kr?=
 =?us-ascii?Q?F5yoJ/rVWLpSNJmihsJYhnXRDAzBrIWFDBWYOAJobsNKMiQbpwTvHEeXakxH?=
 =?us-ascii?Q?1gEh2SX2Pzh5ZTtGez3Yq/sAvPql10Y8kovKOTXumzyYC3E8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3227a5-e79c-4218-93db-08dea563ea0c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 20:22:48.1384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7ugkE17OPTB5f9l/UjiqC1yaZH+AY8WOn/Rkpyfdt4yVrNon0WUDE5nK/JGTiw9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Stat-Signature: yzswbft1ya5knmnzwzju86iwd8q8owkq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20632180007
X-Rspam-User: 
X-HE-Tag: 1777407777-22786
X-HE-Meta: U2FsdGVkX18TPS4MRoWcncKlyFfvGqkEpyNqJyH4OngmHLozwkTLRPxlK3PGjmT56n54jLWbkXu2FGr51ASx2g7WmSLJBY3VJMaNnJJsk2zGoRNbY10vI/f3aqWQ15bV5/ea51E/tBvwbuXZJoDvZYH/ojUwZDnmixsl8nbe4bJCLaFu9gKN33na5o2x+zDWQV/nl/0xH53oCPj1arYtFJUIVujXwXVS4PyGHrLUhnvBsF5LYT4cTJdemLsA6B7c7/IoFQsp09YfUQzEUYvypP9E461Hk9mOPZcTlHHR/Lc22Qh5ftGml7EVctIBZbX6NSMkwoax07nYroZ2nt2KSV/0PhVXJgbCWYSoV3r6+rwgwyrVd5kLXzRIbRX4KkwZPzfrVh7UQvJpXnYl8RYeEQfMAyOG9+ZAlMnjMmSo27eFAb0eIObZFKw8RALK3bK7LFC79ga02zezzNkl/aY94IfvBRWiNmjHF/rvKsuZhPveyatwGpkBXHySTC4TGdVGNg3F1EKfN8S/C1Z+h+bdoXw0Yc+WrR5lQwLfkCgEYf4LUdclif7ztVI2HrGjIsUaamfeS5FU6+Jmn8TdaB1O5gJ6ox9SuSGOwWx+qn7fkdY3ePnbtPUrFfxa6tfSYSEXQ/5m9FzssrtGDTf4j3QJYN0vevcP3kwinpBeeIs547j/RAMBZvcsyUHthnoEJf+jLxAFU0m0rJCVQbBuNsvV26QrJFGQt/xGadp4MbNFDrPz76+uiad/appWM6zl6j98FpSg49XzVfFOi0ZKFvBgEXHL14h7CTw2nVPtxQUO1Fzn165jvkD7JTPThmxO3O6rQYggNh6vJ8yP/rNoIJHzKvKB8S7y4O5gnAXkN3UPDzOWsz17RpL5dlzqQQpp9T5cAEkOaqlrIuzNIIaVL3lFPzcC+QwsvsiWYuBYb1sEfqI0Gn3LGM1/5QCMpPM418j5T2XkkvGJbIYFOkpvoPa
 AkcmBaQC
 aBnDy/F3cqBVXA9tY2dfKw9EN7BdEsMpozwMEKujBEGmRZWU/WvkwevIYk50oYgcXxlF8ol2YBJP4YlDxruo5Qtr+/y+is3wNBI6uabLOlTOhkGTzZ8fT/2qkzi3mMoPjqtBl1tnni81Ulp/Y55DPglI+PfgSTXhDZk7pzMTFAOnv4j+sId4kw6d8MYC7X+SOget9yKRUluBz8nwBm3Gp1RMnfy9NzH52O0AjdGbcgOhaMl0EsPp9RivesPIy4+2D3djRsHk67woGnFeuP9zCjFO30MDHS5BlOddyG3AAqdt8l4+pWzxjZFebaDtkJWaQgoDJwEovOFtm/wjhU/4jSdkvrULQlSqg5i7ZDzyGc5wogfZR8rL8ZkqgMDnK5tWko/z5uh1QQ7GijnU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28 Apr 2026, at 16:19, David Hildenbrand (Arm) wrote:

> On 4/28/26 22:17, Zi Yan wrote:
>> On 28 Apr 2026, at 16:07, David Hildenbrand (Arm) wrote:
>>
>>> On 4/28/26 21:56, Zi Yan wrote:
>>>>
>>>>
>>>> This patch breaks the khugepaged test for READ_ONLY_THP_FOR_FS.
>>>>
>>>> When I ran sudo ./khugepaged all:file ~/ on ext4,
>>>>
>>>> collapse_max_ptes_none (khugepaged:file) fails.
>>>
>>> madvise() still works? Is it maybe because of dirty folios? (but that should
>>> also be the case on write ...)
>>
>> I asked codex instead.
>>
>> Basically, mmap(MMAP_SHARED) makes the written folio dirty and the folio
>> survives the later drop_caches. Adding msync() fixes the issue.
>
> But why doesn't the write() make the folios dirty? Or are we running into some
> race condition where the old code just worked by chance?
>

The fd is opened with O_DSYNC, so the data from write() is transferred to
disk when write() returns.

Best Regards,
Yan, Zi

