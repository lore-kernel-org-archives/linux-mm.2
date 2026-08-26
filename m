Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC78C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79ED66B0096; Tue, 25 Aug 2026 21:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FDD6B0098; Tue, 25 Aug 2026 21:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616A46B0099; Tue, 25 Aug 2026 21:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 366E36B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:58:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9979A140246
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:58:01 +0000 (UTC)
X-FDA: 85141759962.14.4A20E77
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	by imf21.hostedemail.com (Postfix) with ESMTP id C60961C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:57:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QFFX9Ou6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2G3chJ4YGaCDoZk2NVQfyWRhoINDvK2rL8gspdrGpDk=;
	b=XLlxIQ+DKLoEOnRUhwTPkvQSSSEVUFDKsyK9PXWPnOJ0F3FNlXfYOz7Xswu7bMcCH6A1mk
	c5dU0m4cJMSoW0Fa5yRCOP3CHNkZ7uJFuL0YGUuYcEl31ZrvD/giXUW0hudyBFa4gafyl2
	IIQAzPZBYbRJ34OI5C9x2io28izc1DM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787709479;
	b=iA1NICTGumEvpYDAxqHyVsDIF/9gcChWnV+A+RGQHh/i6NdVW96Is2FmSBNjLnXIfWMOIm
	lw8JIX3XzeeUeRorfUCoRl7McIHUtNJN0s9NsgsxHGk22Y2IYYq5dadQS4CKpaYavyFT2z
	uAKRkIaGVlho0WVRAiq/9JkEMzjzEYw=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QFFX9Ou6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQXCd4Xs/RMQeKXJT7nJFIjlPFKURtkunu0nVETKlHVRS/aBM2Lmya5nUqO32IVR6CHDTIRsoVQc5h6leGbqgJ42OY52RHGMSXR4fNDT8CP3vZuKXfO3AdaUho/2lSMph3hv+OMD8SZ/gzec6xM76eTKWzP56p6RGvLUiqCLetqfp4yFQUa1WwjId2Kb8m24jq+gheUfmYV8F8PVCnJNLywXU4HRvPYoLMmEsePN6TiiKRtue8OnBrN1ZFT/cPtrQu/kpNr2NfI7d8uOC0SwKaxFvwSghMZNVm+nD+7wv73q/TAbUEeQJAeVFYL+lFO5VODy+7mFcc7+ZwyHfUX2+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G3chJ4YGaCDoZk2NVQfyWRhoINDvK2rL8gspdrGpDk=;
 b=F+AiGYG2gGRoR2eHE6POG4XUKZPTsIBzdMF4579svZcR0H4mCftl3BJjIRusgbEh6gFL6Ux9wKEpL6OdA2NNc1G6Ha9GSuBSCe61uldEWjYVaL4MwX++AZ0j0kGEb1WcgnNOSt/i4LhlOdAcAsTulgzUhKtbVluPdcODYriz3Sm3E9ecxLu9rZFHhpp6XCZ5r3mGTOENBTsp0ZQ7iX1VmKqwzkev7aFuyhqRHv0nULvY+045/6FR5wAQnmkegCdaFhCXAF0VrBiawPkD+15fe3q8F0CFrvNoSJaU9CTPZfV2Zy7sVrlsKl5CF5+kDrJFtMwBPQCoMHWdaXQlmx4+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G3chJ4YGaCDoZk2NVQfyWRhoINDvK2rL8gspdrGpDk=;
 b=QFFX9Ou6HcFts7rIyTj5WqiTpZ7iGkQRawynfeQ03tiGrmXUUVxfdZEHMVS0JMHu0spkOWaBeVe0WZe70iGd7WN16aj3s4rcaE1UOmdJe2fYFU+OkbkFQ/7EvxuqDcag31Jjs4J51YMSHNkqLD7JfXeNpgZwp1C9lb35ytn3o25Q/XtHDgtt/lAN1eVH0rc1XZvTo7UPElHNW5UiHY0gJ8cLE3MaKBexuC4nRvbBxfEkBygPVSw7CywY5T4iHnO2bwdxZGR49SlRZZ6FbBx5Gu+rxiQNsvAHCamNWpAOq64dA3GsxRDv0q1ZYzRt6CQmJ7Q6Q4HmdgEU5QSfgabDnA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4421.namprd12.prod.outlook.com (2603:10b6:208:26c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.7; Wed, 26 Aug
 2026 01:57:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.006; Wed, 26 Aug 2026
 01:57:54 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 21:57:52 -0400
Message-Id: <DKYI49ZQ19NS.39QC2NK2JQDCW@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 13/18] mm/huge_memory: drop the unused do_lru
 argument of the file split helper
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
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>,
 "Kairui Song" <ryncsn@gmail.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
X-Mailer: aerc 0.22.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-13-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-13-9b43f5163238@tencent.com>
X-ClientProxiedBy: YQBP288CA0028.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ee99330-af12-49a0-1f7e-08df031571cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	AK4K3+FomqId9CYMKl8Outj7rGJsPanch/ccJjTkw1mxstgToHoRsplDk567ZcSVKV2z2eWpnbmJ5fXp1wnLgTSOx9BHsfkDpSMpY5guh4PtClsCPMPZcXFa1yzS5P1FcwF8eDy7n+FvU09ssWSPIKwtTRirXcYltFD9gz/kLMpFexm9IjYY/yET72xAg++dYNcYxGLmG3wDSeFQYpmxlrcKHy/jdwRTIXeFSpGy2Qzu1bBCiBAXEw5zx6SME5IQRcQD1wGapLtqy36LKNOwdQEAYks6q04bBoOvbRQ4NvP3ObiZYOJ0aBPbn1MUKJA87tZnWGVhkDm1n/uB4gXFuI40dfDY76+NGD0AFCEhAqNwGJ5wkoKl9YHJJqW+uRYATU1UDKJc+0wq/iAPfnzN8R6W6N/PRwSznN1fHQvJ3lnAq399A3vapirVyqSHloLV2ZLzzWmMAMKIvNrge80R49SshNsqv2xYCnyL2UsRYigXyU7AP6dTCwR5B2bMEhZUW899rHryuWWi03RYVzRnw1O1nLQGdp65JBtr8nQOSWeAjbwGsUd4nKh/gCOEZ0pADvNwRr60/6JH3K8D7j9B2rlcHHmnNlMLsKYQy3BpUFsq8przP2t/E99TGZyK12O2vglNLE7Tj9wHZzK/QetiMzoTzspHbUBK5CJzGh6uSog=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWt3SjRXdnZndUNVcUM4TDVvOFNreFNiOTF5NUM4eWFLaXVJU3c0VTFmL1ZI?=
 =?utf-8?B?eHBGQm15Wm9XeGljMElXdFJFWHo0SWdzWjk3cVFqYXlxL2FWVmNYWDNpblVi?=
 =?utf-8?B?cURkbjJpUFVSLzRWMXhGeE9UN3ozeUs5eW1yVll6b21jWFpLMExZMFBjK29N?=
 =?utf-8?B?ekdKME1jMEJ1RnRuTTU2cjNjcHNCNno3TU1LM1JrSU9NWmNubUFXWW9DaEU0?=
 =?utf-8?B?ZXAyZk1UY09oVytFUnJ1ajIycHg1MzFSZHN6U0VTY0o5YWwzTzBjbHRZbEx6?=
 =?utf-8?B?MXYyeGJjQnBONlBpQWF3YVR1WFR3Q29SV1ZkUlJFaWc0M2xLL0hHei82V1p3?=
 =?utf-8?B?NExmbWpibTQ4Y3RieDgreTdZUk1WczFJWEZRbU9mYmE1UzlVb1BEdy9TZWxP?=
 =?utf-8?B?b0RjWjRTNjRacXRJWnlWekZIV2prTndubXVzTDN4NG5RRTZFU1RCNVk0S1Jh?=
 =?utf-8?B?enNFcVVRRUYyUWtJbkdDYWZMdnNucnBGeG1ZaW5EdmhvOW9CSFlaMkFMUzhz?=
 =?utf-8?B?Zk10aEcwdG5yQWI5YzlKbWNvRzRnanpaM0F2YmJMakZvd3pQcldhTEVOSUlY?=
 =?utf-8?B?UjljMnFGaXVVakZNczkyRU5vNU5qQldNd0hJMHA2NTIra0VPK3BaQXllMG5U?=
 =?utf-8?B?SUM0VEVkT1JKRHB2L2RZZDFpb09QQ0RDR0VYQzdpd2dFTERSLzNzUFhNUjNW?=
 =?utf-8?B?VFVjWDlBNWN1N2NsQUhWNWp5aHJWSS9rYUJFdGFWeGlBT3hiR1VjUXlyK0pO?=
 =?utf-8?B?YVhMQ0E3dTkxdFU3bENySGJXdCtOZ21ieTFEWnFlR3VOT1FuRDFzRDJka29k?=
 =?utf-8?B?Rk5yU2hmbW5Za0ovZ3p0eExXQjhaY2ErL2JrdVBsV2JCc1lLeEFlaWRHUDlJ?=
 =?utf-8?B?T0RScFhCUnZqdDE0Y2cwcXNOSEo2d3pmcXYzSHRnQ1VTSUh5M083MWk5akh5?=
 =?utf-8?B?Mk5GZVFsNUtJRWpwb1MrWmxqZXBYd2FnQ2JHTk1sU09mQU0xVlozTWEyQ2FX?=
 =?utf-8?B?d09MbGFEK1RKM0ZNT3QzcE9zakc3azlMalpaRmFLZjBvUGhoZGpiWTc5OTBE?=
 =?utf-8?B?NkgrMnovR3VwYis3QUlIanJBaVRPZHFsd0NleHFWUG9NMU81TENqMDZGNm1m?=
 =?utf-8?B?KzRUVkVlbEY2MzVLMDBnTlhieTd1VGtXY2ZsWGpLb0t1OTBXbHFXbXQ3QzBJ?=
 =?utf-8?B?d3NsK1JkWDUrbzVjcFZBTUkwWWloR3dpSTNyUkJ6b0JYeTZ4Q28vVko3Vy9J?=
 =?utf-8?B?MUk2VmkzL2VXQ3hBcnVPRXU3NjB0T3k1K2NlSmZ0MHZ2ZmZlQWxySFVNYW50?=
 =?utf-8?B?UFlhQWhxOWk5MzhNVTV4UXVNV2RBV0EyckVkbXFIVWNxVWhtY0hMcUlEUkRR?=
 =?utf-8?B?WUlEZi9Ma3hXRGQ4bk5ibXpkbnFNdTNhRFdDaG40QVp3WTgrNUM1ZjU4cmhi?=
 =?utf-8?B?UjI2UkRiMDJvdkNkNEk4ZG5tTURJYnVaSVFad0ZjZ0VETTBRa0lMdzZ3Yk1o?=
 =?utf-8?B?U3pjN0hEcTRQYlBvSjlBTDlueW9xaTdCZ3FhRXZrTmU4VmU0azJ6TlRqV2xQ?=
 =?utf-8?B?U21MOXFXOG9rMGc2SEJ4V1E4YmROWk5LT2x4RVUzV0FjMzVYR0N2WU9pTnBz?=
 =?utf-8?B?K0JTaTRmRjFaYkg0MGVFUkV2NnUrd0VBZWxmK2FqS0NqdDIyVlNabFdTdUJU?=
 =?utf-8?B?cEU3dWxTbHZDc2k0Zk9JZGdEK0JKY013ampzcXl3MXhSVHBjZVFrYk1hbXdX?=
 =?utf-8?B?WTNBaTlvMjFuN2FJNm54Z0hEc3R1aHUwYWVrNGFuL25PSkIxRUZiSDQvRVNS?=
 =?utf-8?B?WVVFL09qRnRWM29ZSTRxTUhKZ2FrRDdSQWk5bGppWmpTYllEdVovbXppVHgx?=
 =?utf-8?B?ODJNWC81eE5SWW1UMkx5dEZBTnROV1ovRE10T21HcWtIcHZDZjNkd013WHNB?=
 =?utf-8?B?aDV6a2k5dUtkdndqWEZZZ2tlNEJsUWdvZWxvR2tyMW96M1R1OEV0dkkrM3d4?=
 =?utf-8?B?L3RBdThLVWtkY2JXTEFkaGFkKzVML1pwakNVUXMyZmdGY2tDazNqbzZHT3Zz?=
 =?utf-8?B?M21mdjRRa3FwOEtka1BBWFFVeE0zYk1tbUc4V1NOYmI3YW1EMFhFRHF6dFJ2?=
 =?utf-8?B?aWwzQlpRQ1l0dVdFUWhXd0dMamVHTzk1czd1ODNxbm9nTndhbG9EckhIK2pK?=
 =?utf-8?B?R25zNkhqNEFJTFYxZGd0cURtUlFLVmdlSVFtSnk3QzRXYWtQdE1QQmVmbTds?=
 =?utf-8?B?UysyRUVvR3doTWg5ZGI2VHlXNE8xTVRLaklIa243ZnEzWWpxNWFNSVJOUUlU?=
 =?utf-8?Q?nX/8Egbmn+g3PjpGoo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ee99330-af12-49a0-1f7e-08df031571cc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 01:57:54.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMsNSNLwvWEX7h8NHnbH0UtvxNmSjCKMnDBDvfH/kMfq6vl2Wb5ZRZE3DLn90BvZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4421
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C60961C0004
X-Stat-Signature: b1o5odw8fsses9g8etrhws1goe6ga9z6
X-Rspam-User: 
X-HE-Tag: 1787709478-701905
X-HE-Meta: U2FsdGVkX18rBx9c8RUlZgNdf0drnlnsvAsa+7gI1edtqDlR7TtyVoHrG2foFI9kiI9+pKaU6l3wf0z9PY5Y5hh9U0xzFu4QBLpS8EJ7EOckRKjjechMf0t4ZlNpgly4S2hzjafQ222a3UoIkHUJQ9wN6/60XqtTyKktaMtAKzxg+lLN333BVEqb0COukNqj9b/xVwHBDps8z/LAT4sRBBGp/uT+VyZfx2MspTsrwKZIlApbAFqgjZMkgYRnZCRQdStewKw1Vl8xwZz9mSJY1Ea9OFmMvytg42nPahqjuPKRD7fyzrlLQuRgLigfagG/abfJvRxyyCPUMN3jAsPxjyPiEYJzr+ydvfYC9DnrU9v0abeWX83oovmSRdNkA8VHebwwg99cIVL3ku2x6Em3v+O0fz+ZlEtO1hGsr6ynUjScKs/Z356aGsxUp+bjimpGXCUpRXxS+daZEYifWGbmxtyzQWgpUv0PxH57MVcPApmnKl/zHcAodcvmsjv2OdlnJ0eOa+kT2NlRczCPchek19fMBUI+Jcphctv1L/lhh2UVIKrq7x1PTuz7DBAVy+/bVfL5QrFkIHF9IvL9WvoL+uNq1e9Zo2yVFlfGa+PcPGE5S0hl8sp2kUcPAaOh7Sj5Er8YxNQ3b5IyZ+l16rTp6cAlywYc+o8x3hC+idw2z3g5gZq/qwjJeJAWus16+Y6efib8MtJR6fX6T+ArXnMcS3QaQ1iyOuLwcaLAveGTWwwtW7VDL/FKyby03v1w72ctFLTOb3T/Er0brfzacjoTFYBUemlwBeZtnMgsyhLO76iSi65hq8uEdMrds+tvqhPqTvpZ92FMXiU2kzxSe5xybFVzU2r2LbWOd4ugAObtxtkqPiQUt3Uuq5P0IauwPAhObBPMzKq/7hvXR6eVzKIuTCNpLROI9zYyIsJRn6xoNGVYuSFdFrOjVraJ8mEVWOrZy0mdO1tGIYTLf0JrVek
 Ae7umzKc
 43Mmw3rTJ+AA987grWiVl/ZvpkRZaRHQo1xpg4DqkBIVoFSTmZad2CUbWhnfNY9Y0qPoUvmnURV4P21+6VPfWR3TkgjQnXdmjrlee5RZtiHxDEQvC99ilRaE0j2F3Lg8uVdETM5hdfM6/tG84wJluis22gsTSv928yjNXdLExm1RdYWerqhxOBWQ13mW6VxG4iVSGex9WQQS3fMa2QE+pJPETECKSrjIc6YMhBGsboZTeXsCiP+Cfc/UmbHw6thpHrxuQkN5wZTEQ48D357mkPGlH/texptg2RfN/EbmyPSW3fl6ft7gT7tv4vXP7wXN1UWBlt7bvAnGxoKzeP3NuiU/+jBl+gPbMnMuDNsY5QIi7tDHMcrO0sgbo/2DrQRniEOxnZTTjPBocG/sfmWyJuY3MeY6oCscNV6rlzt8u8WNs/RHB4v6ltX9a+OnLrs0SQItIVHkT8Ag7fIreevOh6GH2cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The only caller of __folio_split_unmap_and_freeze_file() always passes
> do_lru as true, so the argument and the branches gated on it are dead
> code.  Drop it.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
>

Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


