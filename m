Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8C9606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=selector2 header.b=fXmxL/RA
Received: by kanga.kvack.org (Postfix)
	id E6D256B05BA; Thu,  5 Nov 2026 08:15:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C856B05BB; Thu,  5 Nov 2026 08:15:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3E56B05BE; Thu,  5 Nov 2026 08:15:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A582C6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:15:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E31A1609F1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:15:25 +0000 (UTC)
X-FDA: 85401111810.17.3D14E0D
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021110.outbound.protection.outlook.com [52.101.65.110])
	by imf07.hostedemail.com (Postfix) with ESMTP id 29C144000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:15:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="fXmxL/RA";
	spf=pass (imf07.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.110 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793884522;
	b=IYrTB0uBj3S8jqZAVmypJtrW/K46QOo4h8pfdSS8bovTaNxtnxLo0m6wJc7YE4Ao5Cn9uo
	y3Bqcowfc3VCEJtyrIBpCMjFShcWQTFOl7AXWnniMUX8ryxeq/DXpk6bYKidxP36NgpSNv
	N79225IDsgThexSOaTA4fa62Xa/ORXo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b="fXmxL/RA";
	spf=pass (imf07.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.65.110 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7SG9w/r52br65U3O9apzJvPdoY0E0NdQOv4AkgFZZM=;
	b=hCYCqmEE/nYwmDcVnmkyPQQ4LAWIMeoVUjeD4+8zkMsA+6Rewbftu5m5HJQPcHk9OVl0ji
	2C23X5mlmx2SV7SgEIqeDXIr9JVH3o3igOSJ+07hgZU5DP30vWZSYZleFZnf4s/ozdZL4H
	9WOapFmPYS2rNYQ+l0qGMYkZK9bEe7A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5s+IByKAPn+P/4/PsoRwp30BB8netdwamvr/Hh3lAdvD0C4Uo0N7aTYDej4HNTyLXTbmSe0qBl2cHtyKY/SsWmPodN9W5Gv3SCCSDv3L4H1cgCxCelIfPOaQFmV7YG9IJoEAmYtF30tBc9QvUaakVIfrNrJ1hDynh+Y5ekde4iNmCv2frXr0gC/fuBTyWSA7qEifF7vgxUkSkMOVaorUqmvAEjnoLib7dhzVZAZWz+O8WztpvvcU9/15jMaJpskzcM4q1ACBzb5GnEwfhlruVpLq6aAFtZZ3VoNqK2hJBGnbOZbkbduHpVsbJFtOg32gIlQ9f8UwHz/299nihA9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H7SG9w/r52br65U3O9apzJvPdoY0E0NdQOv4AkgFZZM=;
 b=EEco/6LMfdCJlPbKBmKzoaiq8CIUSO1YuzMAup37QXzcWwP3Hhon5kmVHfqXMI9eCR100gTk0viJoaCYc3uoTY/EnjJWYFKT0q8CSH1gJo71O3kvXlVqAdMt/cfEwrE2Woz0HD9V6cW+9cCxfNC/6zea/7qf8I2uiboBxqlf6EAYW2kd3sZvo3nocHnV3GcDFgKICLtUpO2yQYrmRPXSv7cR3ZVvF/7DwFAD3R/602KHcNyvpamgkbW8dKt8ovyjhUDutJDdgYsc+uCGGdVXQnW8hxzfkNg/JWPxh1GgnTcfGs7rgO2L2RAYSmaC+bJ3NJFaKiFzCoU2UompGRnDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H7SG9w/r52br65U3O9apzJvPdoY0E0NdQOv4AkgFZZM=;
 b=fXmxL/RAOBMlPJWaD4PvFNDOwwGbMApLmwWdC5XdTtbHpSdIKSPLoqVJOElL5jjTryUx1EPR/9hMIA5+ZMBWVnzUfkFo391MlEr75jY1s81Ht6TV8tKUcM2bCe5flU71hZj2gTd85yDDrEkacTkyT2ISqTZVAYdI0gWeGxRT+4KhDlYJty6o4sX01nSlOA778lbqXKWa2LJKGnSvB2AxArQN/I5L4syk54C8Zf6mwfoaoa3QqZOoUTxP9GrYq38VjSlHX+Xh0mq9XpnrkxxqfsGY452ERhMoENPdzqMOJu/SJO6QMVgAyOhRrIUxeaFPDEmELB4kRwk+QQbNJpibMA==
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com (2603:10a6:20b:5ff::9)
 by PAVPR08MB8893.eurprd08.prod.outlook.com (2603:10a6:102:321::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 5 Nov 2026
 13:15:16 +0000
Received: from AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8]) by AS2PR08MB9075.eurprd08.prod.outlook.com
 ([fe80::3f57:9ced:7a37:1bd8%4]) with mapi id 15.21.0592.007; Thu, 5 Nov 2026
 13:15:16 +0000
Message-ID: <7a7ae5ba-a57d-4024-b642-7b9798aa6311@virtuozzo.com>
Date: Thu, 5 Nov 2026 14:15:14 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
 <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-4-c56d0d26f970@virtuozzo.com>
 <ad6e93c7-203e-470f-804b-fbf7ac9890f2@gmail.com>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <ad6e93c7-203e-470f-804b-fbf7ac9890f2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0015.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::20) To AS2PR08MB9075.eurprd08.prod.outlook.com
 (2603:10a6:20b:5ff::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2PR08MB9075:EE_|PAVPR08MB8893:EE_
X-MS-Office365-Filtering-Correlation-Id: beebff2b-16fc-4dae-a729-08df3b3ed56f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|921020|10067099003|4143699003|56012099006|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WFP/hKWZhOvZRNMRpWsRHDzOR7Wsx8nRBgzBIOLmlT0C9VThG6TT+PRxCTZpCQhlzC1AbmPivQ8TwgvRnoLYl9AZZvX7M6U45SMna8Tu76i7z5lNZP35FBLKkV1VKto/8HDF7Iowfrz7y6k/dJhGUFj18QJCjyPo2QAutP6SbSYMuxm5bFQcS4yl7TvbLB3UToXjcePYbRN6Rwck0UBcUMr8yGVjG5vhNcUH8UzCKLzlTP6LmeTdJNf1OrPsI53/zDVAGTe6SZ+T2lrNUK3ouuIsNjHy6EpTPguNFyJSpkdlir7szYcp6ajFRCI9yVbeWb3Z1URpY3IclbDyunkT8hLd8regD5+tfGuuPYq52DZJX9ouZ0fMbzxYjFNR9ODe4U6xOc9jlOgXu+0Bk2dpTvGEQfi/2wbeeTqD+oWAAQHupZSRkl6OUOInaCjqvKQ5iI4BF9Tme7jSyhCvJ5yEAOzPnqNJjGf1K72e8OcbNTkZJwN/3qah3QRjG5s2ElA1zZLW5gxcT/zyHz/7XEfy2RLpGYKjJyP+eJ0OrwsFPjBkHzLb/dHOhp6Mc0jQM9O5RkhT5z+kCsmDLtZaowFNpu1ncfkbD7RBUWJE33rONqVXdqpx7tBbjpcqg3yLtori9qJYcvrZUgb9xWj7QxlbPlcqpYc2ujrwY1TOT69gyNx6XCANAndRg2aqBgAEsOj5ZT8whTOimFi2rYp0ZuTH4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9075.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(921020)(10067099003)(4143699003)(56012099006)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V29SaE1oOXlaMjMxY3ZTbVFPQ2xhT3dTSjJnSnZCOG55K0NKTlJBdmpTSEla?=
 =?utf-8?B?S2g5TG0vRmdBbEhMMDhpZEh0VWUwQXVGQ0ZnWWFlOFM2YnZqOUxPa0xPc3Zj?=
 =?utf-8?B?aC9mRmF6UWxwMDBOblpWU1hZbTIyVHFrU240TVVPZmNTR1EvaUozajl3b1My?=
 =?utf-8?B?UjhsS3JvejZSREFxTWtXWmFQZW1NSC9hbWZyVFA0a3lFUFdSUlhqM1IzR3hT?=
 =?utf-8?B?NnZNdXBnTWNhand1czNRc0dDOURBdTZnS1hLZks5TXdsc1pDbGROcGwwaXJO?=
 =?utf-8?B?ZVRuNExXYjFLOUpkWW1ISXFBUEU3M25Wb3BGc0hXWHJrUEd0TDVNZnZJbitP?=
 =?utf-8?B?bS9zeExsblVzMlZxWXNoYnhGMENMMjhoQlI4SkwrcUNQMXhjMFpCdHIrUlo4?=
 =?utf-8?B?WGNjM0FZbU81enNCYWI3RFNhbUo0USs2U05kbDFQbGNuTXFZenV4L0tXTU5U?=
 =?utf-8?B?ekJmZHRCL05JUzRrdzVUM2Q5dU5RS0p0SGRRZ1BEQTJ2dlA5cStxZk1Bdnh0?=
 =?utf-8?B?d2RhMU4rdG5ZV2hMT3BlK3YrSjUzbzVKcTkrMkxMc2tPeDdLZ0FMYzRlcFNl?=
 =?utf-8?B?NW8wTVRaaEJLMEZtZncwRVQwazdtVmtyeHRHUzZwcWQwN3dnb2xoanYxbHR3?=
 =?utf-8?B?Qk1hWk1iZ1h1QURGbWhIQ0ovdmJHemVGQnpVdkdybUR5S21GRTg3eWt6cDUw?=
 =?utf-8?B?aDdCVSszWDU2bjV5NWNGclhkYldOYytBWVRSc0xTVXdlQW94YjRTVFBkdnFT?=
 =?utf-8?B?ZHlyQzdzTGF5cE54c0hRTVhPWkFZMHhLRHZqakllUXFhczROYzFKRGNsdURV?=
 =?utf-8?B?bGp4R0I3UDArcW9NWEFOVXcxNmZmbzd3QzkzSDIrMzRQeC9xMTY5ODVPdnI0?=
 =?utf-8?B?S29pM2xLeTcrdmRrQTB1UG91Y1QzK1U2WUxPM1VUWXpNMCtsb2w5TTIyV3hG?=
 =?utf-8?B?MGRpTmlsd0pwdEkyeHBUNnJabjlwQmNkV2Z1WlA5T1RZTDJHbVZqci9CcW9r?=
 =?utf-8?B?V2NwNTIvSFRUdWNkMXVPMk9RQUNVeXY3blAvSklieFpKUzBmTjBIVmVycGpu?=
 =?utf-8?B?eWt3SGtJKzZpbk4weFJYeEpsNmhpeUs3Vm9pMXVvQW9hZm1UN3lqcmJtOS9l?=
 =?utf-8?B?NnVTaHBCb0NYVWtxUlFyODh5Z2lvMVRBbEdOaFBQbC9KNXF2V2pkRXBCTXhh?=
 =?utf-8?B?RGp1cWpiV0xBUXN4RHhIcmFtQjlQd2FMR0kvMGtWMXVYRGJIT3hsT1VKRllF?=
 =?utf-8?B?YWp3RDd5NUloRmx2REh3V1p2V3kvbjFtR2c0NXdlQklZdUxzUVRFVzFnSWNy?=
 =?utf-8?B?M091c2hWdFErR1dpTXZFbjhQTXkxdmtCMVBvT2lHcWUxZHF6bHpKYjN1UVAy?=
 =?utf-8?B?NTREdzBsMkRWWlNMK0t1VldabmhNclN0eVVLTHFGd3pCYnRPOXQzaVI4bEl5?=
 =?utf-8?B?SE52MXQ3ZnFDWXRTbHl3UW5ONHpIaFVYYkpSRHRLOTIwUUhGdmpOa3BwVUhD?=
 =?utf-8?B?WXFOVVBOTis1dlVvWXZuNFBkV3k0eGFVeFViTHlPRW9XZE1UdFZhRFlSSk4w?=
 =?utf-8?B?OVpJNWNTSURiWnZNTmNpaW13RlhnVHJLR0JPVktmUEJLMXhMaHRJT0hOakNE?=
 =?utf-8?B?WlgzM3dFcW5Ec0lSemo3WmpQNVJUeE9qbG1Za0YvdDJLL0E1R0gwckJKTXFT?=
 =?utf-8?B?R1BaUW5JYTFCZXlnK0tmZHc5TTJiZ3V1RkFjQ0prZjlLRSt4RGRNRWpycUgv?=
 =?utf-8?B?RkJ6NXlOeWpYL21DMTBTdlVvQ1lQTnIxSG1pQVhNM09HZnUvYU1BQ1RDYlN3?=
 =?utf-8?B?cDlKZzRENXM5N0NoY1dzcjZMbHp4dnFTVXlralplRFR2U1pXL0xoWjlDdlk3?=
 =?utf-8?B?VUdYYTB3aFpIM3Q4NjFITWUvQVgrYUpLK3F1bHRiazlpZ2dmdTNHejJKamVn?=
 =?utf-8?B?M2xzQU9EenczTU1YcmZUQjVwZERzYzVTS1ovQjlCRnhZWk10cGsvTysxc0sr?=
 =?utf-8?B?L1d0MVpwRkhhRFREWjhlT2I5Q0RGWEpoTS8wZVk4RTVUZzJhem1DWHA5aFo0?=
 =?utf-8?B?TndKMWpXVVRLcDVvcDFHcDQrRlp2ZFJBQmtNVE85c3BGem5TQWtCOFo3SC9C?=
 =?utf-8?B?RzdpdjU4OXFRNkxmMXNhUVJwOStZcGs1SWRhb0l5Nk1qeEYvNWczRmYzajNZ?=
 =?utf-8?B?V25CTkFKNXdGcDFNcnpSZGhlNHJUeHNQSUZMeFoxMVo5VDFDNUhLbmhOUlAz?=
 =?utf-8?B?RGdRYWxwdk94TzMzUWlnaEVnVHM3Nm02MjdJeTV3WlJLK25raFZzUmV1QTJH?=
 =?utf-8?B?OC90NElibzBJTHRESjJZLzNrTDhNdTE1MkRUbkhGOUg0b2xmaWZpUT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beebff2b-16fc-4dae-a729-08df3b3ed56f
X-MS-Exchange-CrossTenant-AuthSource: AS2PR08MB9075.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 13:15:16.7384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GY/GM1gca1yOw4lXEgMb+tx39FFTQ/7adYjNhbw14C/Ecm9Ds2ApZAeJDLmF5cJOfrhSXFVTv+zFyfx6bfkdkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB8893
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 29C144000D
X-Stat-Signature: 6fsxehjxp5hofr7m8aywo55mcwxwkag5
X-Rspam-User: 
X-HE-Tag: 1793884522-75471
X-HE-Meta: U2FsdGVkX1+ys2TP40ElVvL+ZbjPdHUQ+VQElrlj6YApFnHYhU5niFuWdwSced6P0aZWHpFjC2g02PcZtR2Pa3xBzh5LQJD2I4evBxAJe0J2rwE6E8z9G4LLXCAACDzYGgpHMShWP0FSZMkDQ4f/mr3F5QxaQmvi6PuexG2z5mWUHo960CGhR9UeD6Zpt+fWTbm9WKBk13apAbITDxEGHI6zG9ZZOoulk8lJZ3ogw4GJpNtrrd8R6Kn2g10yYyaq36WnakT2nInu8lLTgkl0rvtQ2Xp6Rrck0JlfYEW3+O4LdYO0q7LHpqoFH3W++vwTS8pkl2ApJDD+jBMK+vELO8Pc43jwMoyf26r7JSF8p/MBr5jhR8bV4Eah1emUil5XYLOqM1tippDaXCefnZH2Xie1psFm4Gegj9E3ObO2ruyKJVLQQgJuSRoitsHHGTcb2yLBEBitoZ9DxarR4FYqxuwpn1x96E45hd5x6l4KDqX2grFFey/ANb1bH2e1QA57bGQ+Syhkk3SbyAN7nHaFGFSYVKwT02yfLQx9uqTtCp2KXIAmLfY5A06KHYwS/KTLCWHXW2byn/6H3eP/L/zCwVJ3e2dj7BSYoe43+pRpzse4Eff2oRPUWgs2a2FxDyA2P+IjqLeoUmcJPhlZsoIlpniAwHOr1U+9sHMKuEmEWUdxx2vun5wVqfrgUZ6OHR7aP2foDYzcw12u4CrS38yr6jQLPW+yDyfzB/+B59jq637+kgTSgugnH7vDyknMJoJbRWPk3BHJlZayPlPFCwFz1ejh3+q5dbY8ECGR1vB84NAYpLsu5tGwRYvPVZKWPEfG+CyBP0AMHJ3dpypZmLQvOeUTJV9OC7vtP0e13oeuHSP2DlBhm8NJXRic1CcdRqONMuLJGC8udFXCk1myzbJ5Up+Y8coecxyDDa0/w668ueaM5Vi3U36tTS6Ft/PLmYT2gjA3Uo1IJZIo+KJG9rN
 c7AQsqy+
 iFVpniZedH2+/AcGGXJbVzLgNoemyxe4/kCwkRSU4f0hNf1oN+EbEzG04o/YZbzKB4/amiSvxzHSBlFj5cuS/BoRmvCGcP+TFs/8HBaM0CWwdgFHnyZe1yOj/MpIM3A+L5zncTZjxBb5fVVeHUdImKJ2ZIldNelToHuyDKY9/7eti9KRm9BRB8Cv9iyst8YgcspsIM5BoJiFNGKTroSG87o5EzLs62DDuXgncbq8XtuIR8dSA3UPdw+naSyDBWTf8TfuJ1rnJ6yNR9SrzZMRAVgA10gZsTXPg0si4yVjDVslGhEiTzLsYoEVeC0GEGSXtWhYR+k2ylZEcr+ownAk5Va3VT38BIrkJSJF8wvc9WOEwDiTF7yX983WnNzH9eQHNK/Rdm2lLmvaUevZ5JveSHAWJblCaqALJYUsXbBDpTrifYCBlRnD0USaJWJZitr2lwcIKrPgmOU46LxDD+AjINOiTXUpM2OKI22ZIIrtk/3eowkdfbXJc3nesL30iDp6ADisy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 00:15, Jose A. Perez de Azpillaga wrote:
> On 11/4/26 9:40 PM, Konstantin Khorenko wrote:
>> +	pmdsize = read_pmd_pagesize();
> 
> read_pmd_pagesize() is pmd_psize() in mm-new since 5d123bb07b18
> ("kselftest: mm: rename read_pmd_pagesize() to pmd_psize()"), so this
> won't build there, will it?

Right, my fault: I based all the versions on Linus' tree, which still
has read_pmd_pagesize(). On mm-new this patch needs a one-line
s/read_pmd_pagesize/pmd_psize/, patches 1-3 apply as they are.

If a new version is needed, I'll base it on mm-new.

Thanks for the review!

-- 
Cheers,
 Konstantin.

