Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F76C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 11:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F0F6B008A; Wed, 30 Jul 2025 07:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B87B6B008C; Wed, 30 Jul 2025 07:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659326B0092; Wed, 30 Jul 2025 07:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFB66B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:27:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA6B6B95D8
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:27:32 +0000 (UTC)
X-FDA: 83720705544.14.80308D8
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id D478640007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:27:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YVsQ1Xr7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753874850; a=rsa-sha256;
	cv=pass;
	b=JuxAMkywqF4KrpPDgavhf40qb94BHtPeAOGlRoEaNrh3obkQiVTJ+lp8A0dn3QKAgk4De2
	gjuvto5nuUP9H5y2ZFQMGRGq4LImmKsvv88FI5OMauqPqg1Qml/wj3/OVWfB9tIhgiYaYI
	xgSyfaVPu8SD/BShdupnpwTX1F3/UfU=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=YVsQ1Xr7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.94.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753874850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=og0f+lN/Q28wSKiCZ2KorqtRy6z9RCAN1bVwHI+PcYI=;
	b=mckUFoTw/iFh2zsVVukBpls3g3Or16l4H+BCYuFQciDPw4eoCOcpFhem8J5HD89spJ4Pt2
	N4XXM6JM731u85oml2W6DGOMFVRp64Xe0SR3qW2urZq498vkYHdh5eyZWsIylcDv0agolJ
	qwVA3fpE3dkBEnwJq+AD0VYf5DY+hMM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA3MKgDWUabShWPooF4ij4Jn61X1pRtC1XFyMggyv8YCzMxaQn5glcQJE6qYd2+6w4DqFuD/OGQoCiK/Kd24qUulzQPyAkEmA2tGjN8MmfnNvfaBOHY41rhfG3k3V0ELoD9F66vzG+WAlPXfTJUzcycXrkmXWtthZ7Lg8KZV90LEx8rGn96EQ9sPLTT9D7x/hZ8OQB1BcYXjoOo+NGiMFk89D4rMJZiuFCRvFNOnLbSJhEUCkPU0b3aDU+kcdVIhJ+lvWiU65NtFXipO2UKhbyMKFKXnD6EBP3LS1SKoKOplxP7RjA0uS539Z60ZLmJ3hkLHs00VBIp3FmhWBAM7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=og0f+lN/Q28wSKiCZ2KorqtRy6z9RCAN1bVwHI+PcYI=;
 b=i4fGjlPvqKPwLngusKD9MTMxi/0ne55mqKYb0vumQfR2kxi8oFXu0/ULSdqcj9xQEG8NQ2rxLyQWiHAu7mUtPkoA17fh+XY8KRGIxMhKMirU3Gkid4yF9PL4Xk/OoCkif9EqE91hMI4tiDxQeslUvj9a9OFtmGMBswXLIXMSNsQMqUOB8cp6T0NzZPCrRFuzjjG1R1+IUX4Wwcb8s+Z12+76vVjqCK98GKkZtFO4A6FKmaAnW1gC8lW6qfUspAPcQSplNLNPNnefg6AnjZaGH8WCMFT6k/BqZDM+dMdA9UU/7mS5XYbIa/1GSpJcQzvf+mzcoyzQuFq5ZWQCC1NiuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=og0f+lN/Q28wSKiCZ2KorqtRy6z9RCAN1bVwHI+PcYI=;
 b=YVsQ1Xr7VNx8coDLXJh8BB8VZK5q932nNNqYKDSOSAQBOyF4igVttTkp0FaeXPTbtMGk8pWU4rWKk2ULOq/2iWwuRAlzoEF86xMUt4NA8sof7J99RaH3IgGvcYUwddFEv39JsilIFV6hba5j7lzPx7rMe9pQmSyDoN7f+7vDsqA6cwh/gkZ3oKUycJeEf+UJzX0dqrGQfqYSwEDe7/2UIeE7K/5yjbUtRW5GzzffaMLFnjfH12XzQ5P3wLTfJKYjqU3C8Zpsw0/i5Kc4hzMsF/YB1CyP79cah+OPmCM1U2vIsqgmkxhuA5rqG0CGXpkFwPziv1P9+BqffsDugrZVxw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB6793.namprd12.prod.outlook.com (2603:10b6:510:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 11:27:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 11:27:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Wed, 30 Jul 2025 07:27:15 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
In-Reply-To: <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:a03:334::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f71b31-89ff-4d9d-b3b9-08ddcf5c0e85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WFVyeExuTjhxYXYxYTdielNEcVY4TkxadkpKT01Td3FrL043SDluNkdSOE85?=
 =?utf-8?B?Z2ZzM3RlWmFGb1R4Z2FTNml2dWpCY2NWSkdqRlJlL1M3WnJCN3drazRsZUls?=
 =?utf-8?B?dWR6d1lncU5pbnB3a1ZMazcrOUZlRWZUQ0hBNzZGU3NNb0dQNWxhOXpIS1BC?=
 =?utf-8?B?UmNLRjdveG5PaFNLZkVMS2NIWTlLalVBYUUzZ0ZlMjJRSm5kd1d5bWV2V0dJ?=
 =?utf-8?B?cHZkQndqbmZFQjYyT0hPMzRuRlV3SVc1RzM2R3N1OXd5L3o4alhoLytLTy93?=
 =?utf-8?B?RTlZQXJkVVc2QWNMQzJwU0FZa3Y4OFVZRnJtNXdCQldQWExHcTdGZlNnMEMv?=
 =?utf-8?B?eW9OcE9PeGtFR0JsU3BiQ1NRbUNZYzVaYStiT3dXV0RwUFJRQUVXVFg0U25m?=
 =?utf-8?B?MHhaOUxsdVV4dVJsdDNyaE1RdkUrcUpZeDJPU1M5Y2VwUW96Z3U3Y0l4RlVy?=
 =?utf-8?B?aUQyNlpmKzhIdjdZNGZhMGVTQWVjU3BkR2t0MEhxRFp2QU5tNGtqVGlKUndT?=
 =?utf-8?B?ZXlndWI3WXo5blJLbmsrNElFWWRvY0dxYXg2ZmhqQklza1RaZEVWZUJGdnlv?=
 =?utf-8?B?SDFSY1RyUVJtRUg4MHpIcWNPUEZXWDV2dGsyS3JqOUVGN25zaFgybmV2SXVt?=
 =?utf-8?B?NE5ENVp1YXV5MWlsSXZ6T0NJUEQ4QUdMRE5tOW9mS3FsVHlqdFY3cnVaWDA1?=
 =?utf-8?B?WCtZS2NqbkVMenh6M1J4Z25JN3JXbTlEOXBuUDBheVlYd2pmNm1DcW0rREQ0?=
 =?utf-8?B?YlZIVmlwK3ZPMDNsYWNGeWc1K3RnT1ZpaTM1c01IVWJ5dmJjYmcyOXcxUXpl?=
 =?utf-8?B?cUFNeFFVNy9Xa2R4NDd4M3NqbEZvUmJndXhFcGtOb0t6cUVQSEY0bWVsNHJr?=
 =?utf-8?B?Ujc5LzZYNVE2RHZjYml4aWR6RHJZTTViV1BzZHI4bUNaMWowK29Ga0FmZGZz?=
 =?utf-8?B?Ni9KWkc3K0QyZ2ZhTHhyVGpnMkhCZ2psTEU0VzZZNUwrZkJicnlDRVFpNE9E?=
 =?utf-8?B?RTFNeHRyT3pZMEJkZEkrcjhFYWJPMWJZc2hzV3ZML0xNbVF0b0Q5dmpEQmlk?=
 =?utf-8?B?dnZydlN0dFB1TGIyRTlvcXZORUh3dEJ6SytJbkJSSVlEcElFWnRpZFNnYjBu?=
 =?utf-8?B?M2d4ZjhldXVJS3RYRkRiclRBRngwSHlOT3lxUW1qSkp6Q3hIMVl1ZEZUU3RJ?=
 =?utf-8?B?T2JpU3ZiUDlKNDR6Nm1aZzJMQzI4aXIrbHplajNZNFE3QWtXWUF1eXMyNCtj?=
 =?utf-8?B?SHpyR0M1WHd6cEhodUdWVmY3UnNYNlplaEhDS2hQY0pWUjBCQkpzN2Vtd20z?=
 =?utf-8?B?cGxnMk9RQ05TcGN5QXNscHVTL29zbmVVTHV3bEJqV1JIYXlDd28ydGJiOXJG?=
 =?utf-8?B?SUh3d3BnSVF4NVZMRDFRNE96Z0NWZ3d4dXRIb2cwbkJJQ3RWV2ZFY2hMZXZ5?=
 =?utf-8?B?VWRkSm9zdW52UmsyWVVsUVl3ZzYwSHhadFRmU084N0Y1UG1zdmZYY29KQU8r?=
 =?utf-8?B?YWdkajJvUTBtNUVRZE1lZ0txQ0g0T0prUHMybU4vZXI5Vk4zTEs1L3owcTY2?=
 =?utf-8?B?a1lISlRDZWp3WVBpOGJPbDZSNmowdEhQWms1TklyODdvTGpQRlVsYlBIYXdn?=
 =?utf-8?B?S1hPQTdBSFpia1JNOWFBWUdKZzBFZUVvQ0MzSmQ2S3NSUVZPcnhlbmpuRzNh?=
 =?utf-8?B?WWtrOWkxd1puQkJYTUJpMEhEeFlkV3BCak81Y2I3Z0tGSm4vTDBCZDQrVGhN?=
 =?utf-8?B?OW9MNm1ENVoxRUF6ZWhEa2JzOEFIZFYwUVVMdndxdmpkZUZOVlB6R1dkNmtQ?=
 =?utf-8?B?WXhqWGJGMm94b3ZhcnR4SFVKM29uZDV4Z3dJTzJ2QnB6bmJjTHUxWEhHS2lM?=
 =?utf-8?B?amhhYlNrQ2FTZWF3UE5mWkc2VnpKZEYxVU02QnpWK2wxU1NHUmxCd1ZOTUZo?=
 =?utf-8?Q?NelA/wLe2vg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UldKQmtyUHZyRG45UWJHNkZZZktSVW95cXBBeG9rV3BVYnAyNG9PdFhoenc4?=
 =?utf-8?B?TDR6MEMzWldKOVcvZ2hrazg5OTcreTRyaHlSemx1QWFpL2RqUklYVDlhOTY5?=
 =?utf-8?B?L0RzcXQxQlRiN3VTL0twU2E3bVZMM1Vjc0FzMTJpZTEvSU1FdXhSVnhlaVU2?=
 =?utf-8?B?TXpyQzlva1ZBNm0wVyszNkZSaTY3RE1KQUtMblhsR09lV1ZRd083TnF4Z1lS?=
 =?utf-8?B?NmxUK1RMK3EzUHFtdklVL3hwNG03alNHV3Z2aFBQYWRlVE5WeXludHUwUm94?=
 =?utf-8?B?akRIcHBZQXpMSm1aRzR6VFJjVnAzdDZNcHRMOUE4K1NrYmpyaUVXQTdRNFdM?=
 =?utf-8?B?d0NKdVgyMExpSzhDMFNEQWdGcjhDYmd1WThPdDhnZ2Q2WVRIUnFyUEVzSDdV?=
 =?utf-8?B?aTlha2t5aGJVWE9QWS9nd0FQT3krV043MlZDQmlQUk1HbUxraTl3SjZHZkxW?=
 =?utf-8?B?blUxMjBtK25hV1grZG8zR1gzQVNEOG1OWVdza2Q2WWphMmRMVEtsbllTblBa?=
 =?utf-8?B?RnNyckdWOXlzalI1ZmFkc2IyZXlzSmJJcTFHSXBpZjFtNHgyU1NiMmU3QlVE?=
 =?utf-8?B?LzBXNEkraUZFNHFpc2dVRWZWRGNnMTJDZENzKzhlQUkyNWo5RzlBd3g1dEJW?=
 =?utf-8?B?QzB5a2ZrT2FFd1BmRHhTTmhsSk1HTkJhOTB1TWs5QzNKbkhIeFBnc1pDbU1G?=
 =?utf-8?B?b2hwS1lGeXNKZU9DaTFXby9OMmtrV0xJaWVFTTNPU1lCT1lzWkRYT3cwNkMx?=
 =?utf-8?B?VktuenZoa1NoL1U1Rm1ENlRJVGdySDFFVnpkRm9yTkJrTThiQ0FKc1pYQnlj?=
 =?utf-8?B?ZGpieDg2WEhjSTAwMUh2NnZ0dGt2TEV2WkRyMmFFbWxCTHJXVHJsSjAvaHVJ?=
 =?utf-8?B?K21HWlpMc0YxbnVrZXAyUHQyVk1vWVVtRmJEMzRhS0U0dHRtZ1QvbDMwd2VP?=
 =?utf-8?B?c2YybmU4NjNiZUcrSkswdWFja0h0TEVLM0RMMk52M2wrdURxTFJ4K1lPKzBt?=
 =?utf-8?B?RHluTDdoWTJLaWJ2UkZDN08zYjBmNDM0bEtpR1UzYjZrSHkyUDMzcW8xVTFT?=
 =?utf-8?B?Rkk5b29ETEpFSTlQTnpLSDJaaTd5N05XQmdGTXR3SEZXdnVXcTlBY1A1bWVz?=
 =?utf-8?B?T3RYWVpuRTVMcHlTMFc0WUFEOVVCSWVKRFIxZS9xZWp1QlB1QXg4RnpHeUNC?=
 =?utf-8?B?QURtdmVJTlljYjY0dElHN0RnRUY0Q0p4bDFCM2dBdDEweXQ5QUJsbUErVXl6?=
 =?utf-8?B?RFpWWkNZK1c2aTV5clBmTkN1RDJza201Ny9jZTlxZjgrc2tjM2VKdkRHRit0?=
 =?utf-8?B?VHpHTkhWSnZCNkRMWmJLc0Z3b3hraDhWY2VVcGozbWcvY1p0bmhNa29ac09W?=
 =?utf-8?B?UmNGb0Z1VnVvS1BtY09QZVlSUUh6dDFFb2JFay9IUzBzQVI0OXpQVzRPcEd0?=
 =?utf-8?B?YVVaUjcvQjVZKzNhcVFSNkFVVzNkUTRHanEvbE9wNTNyNTh5NHpFaUpLNFNJ?=
 =?utf-8?B?NTVnbnNtWnRmOU9jWDMxanoxNGllL1VNeEN4NTZIL0FNZXpIaVcrYXVDbmU1?=
 =?utf-8?B?dFI4aGNnbDZxenQ5V2dsNTlhYXNuSWNJQ1ZJZEJndXFLck0ySmJIK2U5eCtz?=
 =?utf-8?B?WGwvTlVqdU5xRlhYMURlTW1odUY4ZUNoR2hDa3FwUWNDc2xQSzBoQWlDRkI4?=
 =?utf-8?B?cHRiUUpjdWFiMGJaVTlUQ0xuWjlQdGdSZUVaMEZGVHEzWHI4Nmw4VlkxT2pE?=
 =?utf-8?B?Vm1KRCswdDU0a1Znc3VmQ2Mvek9xbEJ4RVd0Z1NEVHJMMG9OTDVNWHR5N2tj?=
 =?utf-8?B?OW14b2dkUUFaTDFGK0t1SmFEMXA4MFlPR2EraVlwOW1jM2lwVmdzalBvSTdU?=
 =?utf-8?B?YlEzNkdqdnFUQ2JiaUUwUEltaDh5djZPanpWMklwUzA3R2I3MXFIcDlzZnB3?=
 =?utf-8?B?Ync0S2N5bk1XM3VwanE5ZGhDTlFMYnlHVUpmd201TGhid1lVZnU3Z0RQenJS?=
 =?utf-8?B?UU5wRlM0Vk9SRWRSOHlJOFJNRzkwb3haZTBmbk51LzFyU3VMRFl2MURTcTBu?=
 =?utf-8?B?YjhCOEdqSHRaWWpHK24yS2VWQityd0JBWTdmZE1md0lhbGJXL01TR0EwSXRB?=
 =?utf-8?Q?ODEw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f71b31-89ff-4d9d-b3b9-08ddcf5c0e85
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 11:27:24.5666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcyIMdlm0HKe8OF+EdAAY4Hp89gZt7B+agk9uWU9gZ6y8Ty8tbdIpXO/KmQ3zU1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6793
X-Stat-Signature: u7fgoyteyd9t8cn5tabu8j6g9ic3g9ua
X-Rspam-User: 
X-Rspamd-Queue-Id: D478640007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753874849-660004
X-HE-Meta: U2FsdGVkX1+Ize8b1anzfEXN+KGKg42RLUs8HVE07FWwkTPksJGJS9fm1X0iM42QIr6anm1//HLYcgMsFMxZidbH8mAYL5uadAXMU7rYi3aXjZETV7JXudAE244zVopfninoC3rvLo6PxQfoGFRcGh9Fq3pRMDma2F0BNp1t/Z6c2+Kv6mEyT57JX319DPQUZc4WcN/CwARYXcrVG4cwqxU3qt6ttWM2lTJIJuqqt/2ajTyfj/prvbI8YiL1PgHmWEBC/EFiLF9FX/V0r+8/FfPgCdpmijLs3xUO/F1sRGYjVMBFOX3i5Yn+q3pqPbxSoBQdu5vyqp2vsLtXJ5oObph1h4h36kxUnwvxSpOlKsyRTBQucuGuUbn9aqi6HJvhlqRr0i3pCT6w4dkf443Ehesyvo3FNmkZ/2Zi8rh5/oZBC4UzCbQRux00XfR2pSCJQ8y46TRwX4yNkQvRTOdQ4LEg23yUv8rZgU4Lu0HU3F6bdt7J5zoIRQfnO7UBkYcUBwi56TyKlD9OXBFms1QThIf15IWiD3jl1YGKlxKHeLd+TGeXLuUwo//HwraaAV8IPL8s7A5opgMTQ2ttgyHXXGoIRNc9jRS+1tH/iL5M/Tzo6EurNk+/g7RamguVx/imr5RlEarIjP6rS7iTptEKaIqkWH8qyq48N7KXfHK2w9QRZLMg4mT3tROzA7YISPPDZSn6gZ5N/uOA3vuT7pyKAZPi1un/dKJocXU07mkdrj6ldVstuJGFT1cFb764718/L2jMcENQYwh2OLHddGgHMTn9UvTua8ZZgi9WpR4944uZdTj6PA2Eb6Ptn3LCUmOx03Yn4ah+U6Px4Et7gCHIYlzf+uSL1Q2b8Dv2IPaRbmP6qytFmdVXBzcvXRzAWNAoGEcIa7UHpBwp4QjqZpLeyE0uNeNI3kXtibDatFZvpg/rFao775xttgzFkghOaKFUxk7ZY6IXlcIn6mtirD0
 CI+y2O5O
 28lXFj1aoyJuHD0Y/nvmyv8I4HF1qQFVynFJ7BH4KaV5vJChH8OdZFXE+tWgvJp9NXvzuZ8hFphCtIsuqbTiJ92L13II/flk0GKv30ITPJTN2SIQQf5o7GOewYm9lqtaIlbZkQLJYn2CErewVs17obtHZCcVQk2E5QM9gH0Sq3ui8F8gzOtPNIyb0i4TiytKDBrmVHz978sQuM9iWdbSIC7qF3bHRSrtx9emFDXgMCEWbHB8mJEG3XbE4MS7b5elKB5KJs0U1qiDWr6kpGwlCFED2i1+Pa3AMHmW7bZwueu/7HeZuDiY9hkLwSsPL1BOHeMf7ZWfZ+A1M0BH1BAeqr6/D2OHy26pZpSbff4HN/C7S3I466FNVsbibhgHTuJDpBvZqG1pkvRGLgyXgC8cyk+lbMULXR7GsEG/QZC73aYl57yBsLoN4jZskUbUSqqfvAGclKIiGToMgLq7J9xQppGJcqksnEYdfdcx+7LA1blXZt507EWP7RC0nsB/aLTtvzIeBfrQvfWqRyLe4+CELK3tW1+IO+j8YLIcpH5wKJMK2zRRo7UqmYYZe0dlVqLkCRiNbhltAGiU1aSiIHe7sPuO+70Og7i4ZN6PfYi0Ym7qPqsgTaK068ybWeL/J2zyiLrR6ekTwZJ9we5a9o+DD6oqmI1HEIh1/ir+asGd09mP/1fm9kXBDtg815it67jcmjCryq7MMCS4TGkmHtwebv2B0Zp+WzE1iL8QixpE+j44o2gtxDbwGKNh9ocrUkESSt7erWqyi/kSiHo8zp8rAOk1OxocSPbAVL82iSfUFdggJb4fO0+wqTnCGk2T/oVCU+OfYOc+WR4YUhDr3SIV28xL9Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Jul 2025, at 7:16, Mika Penttil=C3=A4 wrote:

> Hi,
>
> On 7/30/25 12:21, Balbir Singh wrote:
>> Make THP handling code in the mm subsystem for THP pages aware of zone
>> device pages. Although the code is designed to be generic when it comes
>> to handling splitting of pages, the code is designed to work for THP
>> page sizes corresponding to HPAGE_PMD_NR.
>>
>> Modify page_vma_mapped_walk() to return true when a zone device huge
>> entry is present, enabling try_to_migrate() and other code migration
>> paths to appropriately process the entry. page_vma_mapped_walk() will
>> return true for zone device private large folios only when
>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>> not zone device private pages from having to add awareness. The key
>> callback that needs this flag is try_to_migrate_one(). The other
>> callbacks page idle, damon use it for setting young/dirty bits, which is
>> not significant when it comes to pmd level bit harvesting.
>>
>> pmd_pfn() does not work well with zone device entries, use
>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>> entries.
>>
>> Zone device private entries when split via munmap go through pmd split,
>> but need to go through a folio split, deferred split does not work if a
>> fault is encountered because fault handling involves migration entries
>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>> same there. This introduces the need to split the folio while handling
>> the pmd split. Because the folio is still mapped, but calling
>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>> code is used with a new helper to wrap the code
>> split_device_private_folio(), which skips the checks around
>> folio->mapping, swapcache and the need to go through unmap and remap
>> folio.
>>
>> Cc: Karol Herbst <kherbst@redhat.com>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
>> Cc: Shuah Khan <shuah@kernel.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Peter Xu <peterx@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Jane Chu <jane.chu@oracle.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Donet Tom <donettom@linux.ibm.com>
>> Cc: Mika Penttil=C3=A4 <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>
>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> ---
>>  include/linux/huge_mm.h |   1 +
>>  include/linux/rmap.h    |   2 +
>>  include/linux/swapops.h |  17 +++
>>  mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>  mm/page_vma_mapped.c    |  13 +-
>>  mm/pgtable-generic.c    |   6 +
>>  mm/rmap.c               |  22 +++-
>>  7 files changed, 278 insertions(+), 51 deletions(-)
>>

<snip>

>> +/**
>> + * split_huge_device_private_folio - split a huge device private folio =
into
>> + * smaller pages (of order 0), currently used by migrate_device logic t=
o
>> + * split folios for pages that are partially mapped
>> + *
>> + * @folio: the folio to split
>> + *
>> + * The caller has to hold the folio_lock and a reference via folio_get
>> + */
>> +int split_device_private_folio(struct folio *folio)
>> +{
>> +	struct folio *end_folio =3D folio_next(folio);
>> +	struct folio *new_folio;
>> +	int ret =3D 0;
>> +
>> +	/*
>> +	 * Split the folio now. In the case of device
>> +	 * private pages, this path is executed when
>> +	 * the pmd is split and since freeze is not true
>> +	 * it is likely the folio will be deferred_split.
>> +	 *
>> +	 * With device private pages, deferred splits of
>> +	 * folios should be handled here to prevent partial
>> +	 * unmaps from causing issues later on in migration
>> +	 * and fault handling flows.
>> +	 */
>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>
> Why can't this freeze fail? The folio is still mapped afaics, why can't t=
here be other references in addition to the caller?

Based on my off-list conversation with Balbir, the folio is unmapped in
CPU side but mapped in the device. folio_ref_freeeze() is not aware of
device side mapping.

>
>> +	ret =3D __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, tru=
e);
>
> Confusing to=C2=A0 __split_unmapped_folio() if folio is mapped...

From driver point of view, __split_unmapped_folio() probably should be rena=
med
to __split_cpu_unmapped_folio(), since it is only dealing with CPU side
folio meta data for split.


Best Regards,
Yan, Zi

