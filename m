Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBBFC87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27BF78E0002; Thu,  7 Aug 2025 13:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253CF8E0001; Thu,  7 Aug 2025 13:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11BF38E0002; Thu,  7 Aug 2025 13:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3ED68E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:51:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8AA8160A25
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:51:02 +0000 (UTC)
X-FDA: 83750702364.06.4E0B514
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010021.outbound.protection.outlook.com [52.101.69.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6C8E100003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:50:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qLDE9wXV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qLDE9wXV;
	spf=pass (imf14.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754589059; a=rsa-sha256;
	cv=pass;
	b=0tuGqOFQCco67Au9WssAivGd5+ng9EJ0YMYzk8pBg0Ot7/FtCP8XklrvhhKqAnwgKpJRK5
	8o1IisNVN115Eh71dsT6oep2KGgzmYPFdsBbdD3bPB4D2G4RtdBznINiQWBn0vtffrHNTt
	H/ie1xvqKd+duoDBZAmRGNGPi/SlKPU=
ARC-Authentication-Results: i=3;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qLDE9wXV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qLDE9wXV;
	spf=pass (imf14.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.69.21 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754589059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXt2NjBarheGzfQviG1GRrBVWCSA/Kb+etNr3C+KOWI=;
	b=wc4eEsxdwYYwC84nkA347taOm4z9OPqBSxqivwfJrvkuyvfpsGtcUj+QM2NPM6dtamN/eW
	eCJrnV4lqt7Ugb4aik+bNhTBg7hf/EsfZsunRv7eM2XI7Ktf5QeR80sBt4rXKhYCv74EP8
	y2Jca+IVwGM4H5dVvhCvDAK7WhoVAnE=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ADiI9JOiWezxPb1VoRHneogRcHDEPgxeLkChAsi3Mal80ZaBll2tt0juDDfqIgXbYWClIkOIIN8QTqDsPSjZQWI84UOseFYOcTG6mDBsCHEE8QPVTwyUHzMy+sL15kp11YQ5VcRALHzrkbAMF6oXU551OWHly7SH4HaxoHGS1GITraCiridj8yH9eXOYNp5WQzho3aCn68iL8+ky/MvS3T4kgnneBlMuKCZsA0uH6C7o+DBXwRijmGX7oDWYGvd2Q2RnGraObTPQqJyihd02kCg7C1jdXHPKZ/yPjbnVFGghRKQlGyrhW4ccx0Sc3v80s9lejKuISPPPYFNPhzB+Qg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXt2NjBarheGzfQviG1GRrBVWCSA/Kb+etNr3C+KOWI=;
 b=DSc7Azzwk8uGoW0oxrdcF6e1cFwT68yjlQQlRaNjnZ9BuLVUXEwx3b+61Qh5NqoiDF3KdrjVL5WrOjgCG8ddwCm+X0kyZ9m3RxlkIoRXE0xYk9FcDsi/hicrthxzIVBuowpzGBTuDlqwRWACdu/UTrifzF+qCJYWQ0tOBzFniss88+HxWcemeYCMN5oIBLviOQEvZ/e8Z2PEF+o3+ZJyJGs0WdsVoheLdcHUJC9CwsZzLwfzKlmfFpWk3qop/+G+WGxW+JyXRALyhXajwHOD578sgB/bEtCSVdY1XM1opeR3RLrcDvwtJv+N5ZOjXfIUBJvBmzooMpjjMhbvzvlHwA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXt2NjBarheGzfQviG1GRrBVWCSA/Kb+etNr3C+KOWI=;
 b=qLDE9wXVwTb1hOPLRLX+QG2PFyGEG2P8EHU0xC6wwrBMRGCAetYkMYIdZDzygVDZbGaKt/d4BPKMNbAAshI0iT793uUiOOfnVcXiCnFT3s2IWZIU8GVTLkpoxsyHpPevF3qEDchrZrzLwmvEYCQgB7PV2n3U0F8QNdtCEnFTxN8=
Received: from DUZPR01CA0276.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::25) by PAXPR08MB6639.eurprd08.prod.outlook.com
 (2603:10a6:102:154::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 17:50:54 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:10:4b9:cafe::a9) by DUZPR01CA0276.outlook.office365.com
 (2603:10a6:10:4b9::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.15 via Frontend Transport; Thu,
 7 Aug 2025 17:51:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Thu, 7 Aug 2025 17:50:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b1ibY4D5NbZMnvEqrfVQ4X8+iGWMLvKWS5mlSBlXqbiZlS3Qr3XOfQmuK3FgelgIOnj9MIEMgL3SvdETBlga2w7Q8GyuwmdaCdh+lUNBlRYgCEb2Aj5E9MFDchM8MCdXMGTrrVVlNRGL389GJZYJ9pXdrS/1HGd6JG6Fl2oBfCmn7iTbvq3bgjUh1EKczeI5we6WdZVp7RYmnvyslL4LUyF66VQCLtyD1vJpiMgQJv+5HwAgAN+FOpZBjtbbf+ViH+BaMU0sehydCOKyBmTegSccVLyQcBv5gXwZHKX3ytJ982ncsOER1Rqrsv9MNeZcluoOLOi+/VgkMDmC+vqLPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXt2NjBarheGzfQviG1GRrBVWCSA/Kb+etNr3C+KOWI=;
 b=HLoAlPJOAqjFwIXQRjGa2qnNUIfOuqwX2DNkkzWcDhDVFSwU2Rx2l3rbttvlUbbC9yKAiZv/LK68qWWU31yGam+FHIZMoV/5xTUMzBEgURwRP6L3Pw09MciVkYp6ixqMJhicrJHx2VkMd6AwtvPkbSPS6mgypjxSoZjRfSu3QL30EApX5MzxGmeeBRyC/Li7MNjFXJssoL5ukFfm/3w5rIFh9q7YOolVG7k06CDFqBjwElQdYdlmIJRmmaVlZ5tglw4AtQhdPGB6F7w2aiZwWVTt6i7C6ln2Ix+MxttTUDMc8EqUvmNWoG5/7+V//eRc8QFQ6+wky0qgXg7pmG8I7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXt2NjBarheGzfQviG1GRrBVWCSA/Kb+etNr3C+KOWI=;
 b=qLDE9wXVwTb1hOPLRLX+QG2PFyGEG2P8EHU0xC6wwrBMRGCAetYkMYIdZDzygVDZbGaKt/d4BPKMNbAAshI0iT793uUiOOfnVcXiCnFT3s2IWZIU8GVTLkpoxsyHpPevF3qEDchrZrzLwmvEYCQgB7PV2n3U0F8QNdtCEnFTxN8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by AS2PR08MB9415.eurprd08.prod.outlook.com (2603:10a6:20b:595::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.13; Thu, 7 Aug
 2025 17:50:20 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:50:20 +0000
Message-ID: <cc727530-8535-4d98-9fc4-f6a36941ca75@arm.com>
Date: Thu, 7 Aug 2025 23:20:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: Jann Horn <jannh@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Ingo Molnar <mingo@kernel.org>, Lance Yang <ioworker0@gmail.com>,
 Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
 <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
 <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAG48ez3=kLL4wBxAVSa2Ugrws+-RFQMdNY9jx5FAdbhpNt8fGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0014.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::25) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|AS2PR08MB9415:EE_|DB1PEPF000509F6:EE_|PAXPR08MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 714dee2d-9c67-4567-96b3-08ddd5daf4a4
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?UkdQa1I1Zy9HS2d4N2xzQytSYWZuL0pkM0N3Y1NOZnNLcnYwTzVIYWx0QUxv?=
 =?utf-8?B?WU9yaVhCWjhpVG5sY2JBYi9kelFHT1k5dncxNzFDcXhwamd3SzY5RGJid0I3?=
 =?utf-8?B?SStlRzg4aC9hWjlJUmdSaVp1S0dRTXQ4WHZlS21aNjMzcnRSazJldTlFL0p4?=
 =?utf-8?B?SnhNdk5qWTdWTnVaSklLMFhiaVVqVXZ5cWJ3cGRIQjVmL2ZHKzNzSWdGVnY4?=
 =?utf-8?B?SWhrcG1uU01FM29XZ0Q5c052WlByaVVpNHVMRXNqNk5ac2g2eHFlMGN3QTNo?=
 =?utf-8?B?SzB2OExycktvSHA0UVhFWE1qWXIrcVFhVXI2OW5STTRmandadGtyQVdmOGsr?=
 =?utf-8?B?c0dqbXNRYjJJMDV2TkgwT3pqV3djMVU3ZjBBYjhvTFJhYXVpdGViU1k3cXJa?=
 =?utf-8?B?Mi83RUJUTERQNGVqSm1ZS21ZaWU0ZWVWTGtiUW5wZXNFTS9OTmJ3dEF0c2Jz?=
 =?utf-8?B?Wll2emhyUUZRa1kxbUlROG5ISFdiRGVLNHpiVlRhM1J3RVBEVmZMU0N0alAv?=
 =?utf-8?B?SHFES3JVYWpIc001Wjh2WEF3cTAvZUNMbHVIUEM4OU9aTm55OUtHQ1d6NVRI?=
 =?utf-8?B?ODg2RmpkVWNFRW0zREtHaUQzY0dKTDdRY3lRRk9tTkZ6MWxYYlhiNVhkVDBT?=
 =?utf-8?B?ckQySXJOc0JzMjRLOTF0a0psaXJCZ3dvdHlsOElrUDVKZHUyTVhGVGxHbk1T?=
 =?utf-8?B?Qk1qSkZMK2FmRklkaUZ3MmtzRFFBZzN6VnE2OVN0UGpCUlZtSzhKNFRnSkxj?=
 =?utf-8?B?Sk1lZFA1Y0ZacGlRWFcrNFZqYlFORzVJeXFIVi9OOEtzMG1lWHhkc2pHbG5Y?=
 =?utf-8?B?U1MxaFBiL1lHVzdCbXBvdGlxYTFDTEwvTkN5YVBBVE9OQ1V0RG1aSnYxTzRk?=
 =?utf-8?B?VndGL2g5MG1lZTh0T1RSaVJQaDE2M0Q5a1Z1d0JSWWRJeVNDQ1lhTk04alRu?=
 =?utf-8?B?djRyc3NzRjVFeGdpeExINWhrMWdXUnlSNS8zclFoTHRWdVpuRzFIQlVRRFJt?=
 =?utf-8?B?ZHpBQkVMYXVLNldDRVlWRnZpcUZ2akRXZFc5OGp2cXNrc0xDQngza3piN0xE?=
 =?utf-8?B?NDIxcTBuMXM1YXc4d084Y2FKSU96T0E0L0RQN1JjU1pJUUZvQUhpZllPOW5F?=
 =?utf-8?B?Q2R2aFB4Q2JHT3l1UUpsNkl6b3B0Vmlsajl1U0YvalUyZW11YjZTcW91MUM1?=
 =?utf-8?B?ZjVYM1ljVEVwdlZnSDJLU0ZhMGtiUXZUVGN0TG1IU0NHWFBOSzA3UWR3NWxy?=
 =?utf-8?B?dTBLYWhGa21mNGZWOGxqcEFNb0YzVlA0TC9kVkRPOFdEMjJtRXJoVVkxQVp1?=
 =?utf-8?B?VzZ2TnpvbzFKS1Jiby9oRXZ6VSt5SU1Rc1hXdUoxeWZDYnA0cy9VRkxGMFlD?=
 =?utf-8?B?djJoK2czVHhnYnRyRjVsSTNwY1V1SktSd0x3eEJCMUZMUUpNYnhLQzB0VXBH?=
 =?utf-8?B?VmNaZ1orMW9YakFWZ09oWGdoSWg1Tm9IVnZHODRSTjdmQVhQa05rNE5MN3Vr?=
 =?utf-8?B?QlAxNjc3N01HSXZqdjc0UGtjZ1RuNVpqSjJlUDNkVnFNLzNKU3IyZ3BnYXhu?=
 =?utf-8?B?NFRpUW9oVzFSYlcvLzQ1RE1JOFMwWWVrRWdCeUdpb09YOUdBajVQZWJZcFhG?=
 =?utf-8?B?ZlRsYWwvNGt2dHdtUlpyZGpSV0NKdW40YWxndFBJM0J1VHhRWXo3dFRSV0Q3?=
 =?utf-8?B?QkpNL3NsbDNXOStBZEFsNTNMQnp4S0NvWURIZ0FnL0NremlQd05JTzVQMVhq?=
 =?utf-8?B?SXptbWFrZStMR1JOUVJNVGovdHFzbWsvdkJjMEJwN3VLTEkwZDJqeDlodU1V?=
 =?utf-8?B?R3pqMnZaV0E5dFJoQW1XOElNZ1JYbGZJZGJGNVNkL0RYU0YwT3p6bjY0SE5y?=
 =?utf-8?B?OURIcWJhOGFsUUs5V0lmakpzT2o3a3hsTHpYbEp1MnpsRXB4VmlBTXRNNlAr?=
 =?utf-8?Q?zyoctEEGTfc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9415
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	753ce27d-2934-4897-64f8-08ddd5dae09b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|1800799024|35042699022|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2x4dkRIQnRQS0xxaHpVZFdZcENaY3FBcFlMd0tyUkVLbXlVSEp4akxBTDl3?=
 =?utf-8?B?UkdVb0t4YTB5MDQ0WWlnMTZCNUtlRnNLeTIxdTlnbTg4enZ0ZlB2V0tvb21l?=
 =?utf-8?B?Q29MQ0tvOUlVQlR0b0NYOFdFdkptcXNDdTVaMGYyN1NRRzB2VG5RaHVidkQw?=
 =?utf-8?B?dFhNL0ErQVJybVFrM0lKN2xsdW9RaFU0WXBkSytOSlhCTzJCN3Vrb1lIaXk4?=
 =?utf-8?B?bktyQkVxZ3hSY29qV2h6R2ZQTVg5RDBkekJlNUtFakVvaGVadXVUbU1VUHIz?=
 =?utf-8?B?VjdkZm1oU3dyMkhVNzRGVXloNUdJbmlqNTIxWHlIdE1YVE9QKy9TWVpZMzJL?=
 =?utf-8?B?WnRyMWJVblZPQ3RQZm5lQzFIUFZ1U3l1VWM1WE8wcUlQWnZqZEpEMURRRnl3?=
 =?utf-8?B?Ui9KQUhnV3FCdjRuTUdCRzcwamFpeXlpREVIMWxVOXRoRjBUOHRueVNSMk11?=
 =?utf-8?B?YmdmN0NBZUNVaVRxZ3pSZy9CSjhiOGQ4V2hCYlhqTGQ3S3AwRGJTRnNkQ1dV?=
 =?utf-8?B?SmNmVGZJeDB1N3NzU0JIMnRHS0hwQUc1ZVZ5dTZZNm5zbTJSc3RRb083ajdH?=
 =?utf-8?B?QjNLTVJrNVNVUEVpeURDbGhJMTFOdVU0UTFhREVvOVRmWEgzM3R0TkVwTXM4?=
 =?utf-8?B?Y2NzNGJBeXJlYVdidno1UEM2VkpjbFNlNWw5THBQbXA4RnJqNjM2MUZUY1hK?=
 =?utf-8?B?dDZ4a0NDQnR2ZThHUnMyTVlCcWV1QkUrQmVzbktKV2ZUV2lDb2dFcnI2UEFx?=
 =?utf-8?B?MkFpUXFHWHpZeXVBRFpZVkxQQXBLU05jaFk5OEtQRWtHM1hyeithTHNiZXAw?=
 =?utf-8?B?RXhMUysvU0F6SVdEQktXU1lrNGxIMitoTUtZdmkwWjAwR0dmV3VWR1hka1F1?=
 =?utf-8?B?UTJPMWtJbDQySnlwTTljL25ZL2V0TUNUZk1GaGRHSkg1aTNFTkFRNE5VWFYy?=
 =?utf-8?B?TEJ1eFVYYW43b1Jjc3VVRGx5M2FyS1hQMGRVc2xXMWljalV0SEZSYk5idkha?=
 =?utf-8?B?eTZIQ3orUjVhSmpHanR6Qi9mZHpFbEdvQ0plUlNMcm0xWU1wMGcxaEtoZ29Q?=
 =?utf-8?B?WU92bmpIODcwRzdWc0xHNy84dGhzRlpldVdUNEdUajdHaTRLRVN6U2pxa0tY?=
 =?utf-8?B?MVBqWm5GK0hWTXJZU2lva1NKY3VTZVFPTGlQREpZdzlNSFhIOWQwNXhta08y?=
 =?utf-8?B?aE51VU41Nml4YXFNaVlrT0xjTUl4aXdNRFZkMTJYVU9IdUdxTzNmbllBV1Nx?=
 =?utf-8?B?RE8zaGJ1YkhHaFNGQWxaclZkaXhINzVqamZOVDVSWUo1TGdsN0hZZjhlQmxr?=
 =?utf-8?B?bE50VEFWRjVtbTMvbzMwdGV0aDA1WFp2MUJ4ZmI2YlFhRno3cGxFY3M5OHgw?=
 =?utf-8?B?TEZSWFpOc3Y4T1phQStvRTNWZGVlVXQ0QkxHUzhBNW5FSnN5YWl2SjB0M3BX?=
 =?utf-8?B?Q01UdlF4QmloVzhBNklMRzI5azYybFlXMTBPa1JCM2RHTGxDU3pFRk92WDRO?=
 =?utf-8?B?WlFMU2dmSzl2RUNJblFFVkxhUlJkZlZLYm5ybVBWWk1zZ01KK2Y5bS9sdVhy?=
 =?utf-8?B?TVlLd3JocENBZmdkcHJEeHNmUndLMEN3VWtYd0Q0SUw0UmEza0daVDF2Mk54?=
 =?utf-8?B?MDlPUTIrWDJVV2dXUElJSjNUVnI1UVlMaktFeHFWcDJTaHh4YkZvNGIyQlNy?=
 =?utf-8?B?QUxCemNLTzJuajhCeEhHUVN3UXAvMHdTYzBYd0x2RXFyTGhaUkdITjBYZEFB?=
 =?utf-8?B?dTJ2bFUvZHRCdWl6Nk1PWWIrNnliNE93STN3UGl4T0lkTUVzbTJUdDlzcHdN?=
 =?utf-8?B?Sk84WWh4eTBWcXdna253N2tvZUxDOWgzeEplM1hORmJLa1N6d2tqSDdjek5F?=
 =?utf-8?B?WVJwNHp0VVkyQWlhL051UFl2eWY3ZCtYNkNMOFUyVU5mb281S01PZHhsaXp5?=
 =?utf-8?B?cjB1dGIrVnZXUlkzaTU4K2tYaTBZaFlod1k0QmxTcVFkOXUrOUFSTDMvWEhp?=
 =?utf-8?B?SnJIUVYrc0dNeVFoaElqNkNWVnp4TUdlWC9HN0dVTCt5ZG1VamZTREtEMEVX?=
 =?utf-8?B?SGgyYkdZVzJvM1VxOVhTa3dKL2phTU5QZDRhQT09?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(1800799024)(35042699022)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:50:53.9419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 714dee2d-9c67-4567-96b3-08ddd5daf4a4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6639
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6C8E100003
X-Stat-Signature: ezhn9ers66n9exkso64gqr9gmqhubsk7
X-HE-Tag: 1754589058-386159
X-HE-Meta: U2FsdGVkX1+H6KU2yHxHTU0f0AkK/i8Vc0JUhHAfGfC6C9fDOqneKDa16NWWE8ZAGRgQ1CzNdo7USQh52mg2DdtwEt+/Za3/WjuDmF0P6uY0tHcM+FxqPCoGxSwXz2reJfpk2HQS2rzYJP1FJzxgoIZRaRiR5t2/2KbsMCzcG4cvJ/JuSC55dbBH3q+STbAvWtkDG6pIsdbXMUhT8xXieVTB7GmdqQBS2YFByjDKQPmX3x2y6p/BByT6lmV4hIOFvDLx5mZPMXPjbiyhttRg5jONRfmVf4m9xEas0BjEL7KUNJ29JRKq0RNP1DI4TeTJUm1Da+3E4ThndG41AFg9d4JEiPNUBKv+Q2ckJVarTxX/qtJ+sMfkdiMYcRKCdgAFBVLe8qJP5hCVmT3bW74X+QfZ+tNqr+uiQZTPoAyfYoJeL8YjnFMMNYI3KdEHDEzFzuA7lUnN2GouRzSsqrnYOZZ5rFtasKait/2Sl6qpSzhBfLlQrRMy9kPxQOVpjTvQ1gqfEE/foXSs/l138/fsiKy5NweFoy+ixL7lXlRIu+VqYcstu/gavCHI+GFJsseLWiHLPDotsZHo5LohVqBV5RA2kECPSVFw3W1+wAEHLo1vSszEVCQCLahVDolfprduInIOERjEXuh4rIv42XI3+uBzGtHkBJGrlr16QswsKTgGVE2PX1+LzfZvchAIvVIVBqRJqWyL5UeABveQwbVzT98uoyJV7Ntk75vjFwresrGissaBVK+9Vg3+YZhYya237//Y+vmTv/v+zSpWWrda/0bA3NavRRhQ2eEJb90Q3I/lizryfhAKfJosMEKlQEajUV1XiV0GSrLihNH4z1Tp1Wet3oWcJg1ugxjSQPcopG12r7ljZ0B+glzdxuIC1N0CbUTMtBWHaRwVLLzCcQWtgC4xEhfZ3kRuj8biN11GuDB2yUE3q0vDA+Pt3LykWmJ7zBHJLCdmDCawMKOzOgM
 svGvCyuc
 MLppsPEvOZG5PmAv4sf1tPv+D5CCVXMh/SRmweSLHoexvqoSJOpjfa2CAcRNQoIpcouPKjU2snJYfC8MnzioVmsf23vaOn0HI+U4fUmhgYp/BK/zh5Vn+HshoN/yzlVsS7AQuacjCxYA27P9j6zZVRb81IV1+5bIuz6qH6uSDRXVElDu07hthNe1nO7nXjyuaTZF5EkoBkvntvAF4m0KcDrUv33xHPu0cT+lbUPaPKg30ceOLtxoys00aS+BhRVIM6JcVodMSxOUWW6qakbx7jJgTZfSO8tbxETdXjdJcP8EuOkhr3lOwyFfSl1xETWdcvBKuq2IkdLms8ln/vRIODRxHBVAgdggrmzXwKCjKdBEkQ3h16ulSqh5Lx67tauUrNSIvFrG0zvdPH/B4c1q6SQVUmN/mG+Z+ZvVyE70vM2jeaM1jWS8WVyLeFq6tyI6sGUc47LWoAYzYHcETIhXeML0keXaAN1WXoEeg5WMNHTGGZIU0WKUKLNTmiK3E6iAMLyUFbD05EYTEFbLQJe/tLhktaxym2SsaKYx+agYAhs9sjhpNTxZ0vU7kA8GoaNBQd1z4eYv1sOG4oVMmbrGSMENcTOGXhKk8bzYzkn3NGNG1L3RU9yGGTV+2heuum5WyDeK3VdwQyvUugU1rAlEqt1OdcUImthGyEiO0AkEmOiFfOEiUkT01i61k9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/08/25 11:16 pm, Jann Horn wrote:
> On Thu, Aug 7, 2025 at 7:41 PM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>> On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
>>> On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
>>> <lorenzo.stoakes@oracle.com> wrote:
>>>> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>>>> ---------------- ---------------------------
>>>>>           %stddev     %change         %stddev
>>>>>               \          |                \
>>>>>       13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
>>>>>      367205            +2.3%     375703        vmstat.system.in
>>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
>>>>>       55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
>>>>>      559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>>>>>       11468            +1.2%      11603        stress-ng.time.system_time
>>>>>      296.25            +4.5%     309.70        stress-ng.time.user_time
>>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>        0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>        9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>>>        5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
>>>>>      388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
>>>>>        1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
>>>>>      135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
>>>>>        1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
>>>> Yeah this also looks pretty consistent too...
>>> FWIW, HITM hat different meanings depending on exactly which
>>> microarchitecture that test happened on; the message says it is from
>>> Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
>>> meaningful than if it came from a pre-IceLake system (see
>>> https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
>>>
>>> To me those numbers mainly look like you're accessing a lot more
>>> cache-cold data. (On pre-IceLake they would indicate cacheline
>>> bouncing, but I guess here they probably don't.) And that makes sense,
>>> since before the patch, this path was just moving PTEs around without
>>> looking at the associated pages/folios; basically more or less like a
>>> memcpy() on x86-64. But after the patch, for every 8 bytes that you
>>> copy, you have to load a cacheline from the vmemmap to get the page.
>> Yup this is representative of what my investigation is showing.
>>
>> I've narrowed it down but want to wait to report until I'm sure...
>>
>> But yeah we're doing a _lot_ more work.
>>
>> I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
>> especially sensitive to this (I found issues with this with my abortive mremap
>> anon merging stuff too, but really expected it there...)
> Another approach would be to always read and write PTEs in
> contpte-sized chunks here, without caring whether they're actually
> contiguous or whatever, or something along those lines.

The initial approach was to wrap all of this around pte_batch_hint(),
effectively making the optimization only on arm64. I guess that sounds
reasonable now.


