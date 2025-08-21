Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326F4CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821538E0018; Thu, 21 Aug 2025 13:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9248E0001; Thu, 21 Aug 2025 13:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7DE8E0018; Thu, 21 Aug 2025 13:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56CD28E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:29:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3F9DC04E7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:29:23 +0000 (UTC)
X-FDA: 83801451048.12.8CF9F3C
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2106.outbound.protection.outlook.com [40.107.243.106])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06D9B80006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:29:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=MWvplzS7;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.106 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755797361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyTLMoA6+3gpjFvfZ8K3Cp/vrevPKOaxbhfZLiMk+Eo=;
	b=mhqsprhyh1IElgAEor7WzfDU61GSbfq/YKmR9U04ZdcloLpYB4b9Zuq9wtWYND8SqDSBuB
	4bdmH2yeoo/8I6HV4ndt3+z76RkbsmO+3iRm5qhxhWFw1VAohdWsDoX27LIzRBsJXK4Cin
	Tgi0YobXzF+NzdZ4KygJLTXwRIqWKHc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=MWvplzS7;
	spf=pass (imf02.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.243.106 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755797361; a=rsa-sha256;
	cv=pass;
	b=GHO4pjfVqUnIlfDqekRV3pNgpWd/srgRiUEqz/NoKRrjEu3RqI8bHBGiebr0FfGtBqCZUw
	0/DFriB27mIZqetvS1xa/hljdw3ulIpdWjbosFqwkfg/RUO7fOOLN3sT8GuTEg0duq2uf7
	gIYTLx4I+dycFR3pM1U8nWPGqEgKH8E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BGR6/5C65cObWN/0/o+uMPdKyh6VaoRHi6XWP5w82FH3F6hq/DjJIsv0ROjC4l0KwEc8fB/lB9Zgr1fEnbNL77yQp0+b8e8Ia/SnmJGvxumTsAb5MCapFnmGsFLg5PH90+miiQzVu/z3c8BzyuObREBX9agKNtsdEEoLecmaTYjaItKeEooINOAPbAdmcyffew/YJOiQHDWE+ypSw0UXHY20erS23lEicwWO4vPdhAGDJX8xcS+dMH00GKiefWKJSYfJ0nSptQ52f41BacRXdN2GvfGzpbTeH+heO70vcVA/ZjUUCQAi5faLhI25CEVY0O6qvm9cFnV0zZBZ4mvpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyTLMoA6+3gpjFvfZ8K3Cp/vrevPKOaxbhfZLiMk+Eo=;
 b=RjBfq8BN7Rv+DUU1SKLVzzuLvfFgGGFvuZ/N/6c3PQY64nDa9wupHlOebsM6G/8bje56+Fb6/hSqh6ezmngTC/BK015POAvnsJqEhzc4ru4KGhn+PyodsK0QIywH3qgtl6dDPWZjh1BCxIIuuG9ViB3pqaLOF+SusX37Ee4DI2l7C0pjD3EipQixRxicqY+nDKgKZ/EhpACKcZHV5T9XUnbZTZcx75mRp2auqG6g3ogUOj3QxKng/r6zxl1bMFVofPUEvD6+W9iG8ZU+DmmpOvuu8Jutgn5II8UPC7jUhylpyubwq3jjbv2cexlZRdrpbJ4GLyyzkEd3gnLqWM6xnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyTLMoA6+3gpjFvfZ8K3Cp/vrevPKOaxbhfZLiMk+Eo=;
 b=MWvplzS79TWGF9k/M881WqVMBhxvxDv83hu8Dzj76EcnQ/lci1+fmDGuEeMYZT0pw917dlMADo3ZxVxAT6AhYNdW8IDnWWnAHXAwFr0lTWa0AujeWEOwOU539nMe9mcSLNtMlK27VMmw8KfY1wcZ5KqCgRN77FserH2txrjTQrs=
Received: from BN0PR01MB6877.prod.exchangelabs.com (2603:10b6:408:161::22) by
 BY3PR01MB6657.prod.exchangelabs.com (2603:10b6:a03:356::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.14; Thu, 21 Aug 2025 17:29:17 +0000
Received: from BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0]) by BN0PR01MB6877.prod.exchangelabs.com
 ([fe80::91fc:9877:8a2a:d4e0%6]) with mapi id 15.20.9031.023; Thu, 21 Aug 2025
 17:29:17 +0000
Message-ID: <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
Date: Thu, 21 Aug 2025 10:29:08 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::21) To BN0PR01MB6877.prod.exchangelabs.com
 (2603:10b6:408:161::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR01MB6877:EE_|BY3PR01MB6657:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e6ecef-0988-44d1-5f33-08dde0d84125
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2JVeUdzQmRNTW9jS29jQzZ4WHA1L1o3dmljaWs5N0lWbkhqWFVRa2VyL2Jv?=
 =?utf-8?B?R2dLRW5tVTN0RWFMTUhtMTdISUJrTU41WFlXZkNLQTlHcnJrWFowdWVidERO?=
 =?utf-8?B?VlpsaUZlSWR1eC8yZ29mTFpaM3crQ3M2RlNRcnhwSGpSalloRE0rSGp3cnJk?=
 =?utf-8?B?TmtHTmhwUkpZZndCUGhlaCtRVnFmTld6Nm5NV0hmSGFDSXlzbkt4cUUveW1B?=
 =?utf-8?B?SXIrd0RyempUYkRCMjBQaU1aNmVNSmg4MVhJcGVnS0dvTGFhdXZkWitRNi9v?=
 =?utf-8?B?d2pEUk5MeTgzcmo4eS9vUTlZcmlzZGRIZlhuUWtjaGE1c2lCR29vYkswVTdo?=
 =?utf-8?B?Y1E4UHFQWU1uRmE5UXJFWSt4UGEzaHJSMUFNZnZ3WDBMSHArQms1OTlGMjJO?=
 =?utf-8?B?eWFNTVRIMFBLSndrMXZQUmp1ZkJ6WS83QkQxWWpYSjZpVElvczg0OWt3enlG?=
 =?utf-8?B?NW1qWHJxRkkzZmp5MUVlOXpoZ2FpRlEzQTJLcEN2aWZCeWZlSUhKT2JvVEZ4?=
 =?utf-8?B?b3diWHp1OExFbjArMEF0aTRBTmZuN2U4Yzk4bFM4MmRzYWpyTlNCSTY4N3Mz?=
 =?utf-8?B?b2p3aGMyVE1xTWRJLzR3R2w2ayt5MXlwQzRpbmp5bGxzcFF3SUdJQU94TlJ4?=
 =?utf-8?B?eEJTTTd4a24vVDlGODRFYUd5aklUMjdKUHpHUEJMK3NxZjl5WGFJMXFHb3d5?=
 =?utf-8?B?dG9FcHBpVWc5YmtYTjJKNlZVQ0MrMmMrZTBiakxYeG1iVDBiU0tuNkFWbGNU?=
 =?utf-8?B?U2dISW5GcDZ1Qld1dzVCdDZuT1dPR3NIRE9tUmlSdUp0N2VoR28vdHFNMEpr?=
 =?utf-8?B?N2Z2TEJ0Q3QyZzJuVzZPelRVTWtISnhoVTN3L2pkcTJJaktkS0ZFRmY0cGlp?=
 =?utf-8?B?UzE2ajZiMW1LdDlqVnBsNVNUcDhiaC9XTnZjM2pKdFptY3gxdkVqKzRiMHNq?=
 =?utf-8?B?aERsSWZjM0I5d2hXbDRvZ25hMnprUkxpQ3BUdnhhemFKcjhsa3NRQjNqcHQ0?=
 =?utf-8?B?V2JaaG9sRmV4RTB5N2ljcnZ4S1ZRcjZONmpFVVpJS0pQZk1CL0thSUI2ZXhl?=
 =?utf-8?B?cUZyREcxd2FieXpNUVNSdVhkT2R3MkpjeTd0eFlsSmJtelh3WXVsVFJQb2N2?=
 =?utf-8?B?SWkxT0wyKzZVc1lHMlE5blUyYXhvTm0xWjFUYXE4WWNPNXdmV2pNSWt4bk80?=
 =?utf-8?B?ZGI1WHFhdCtNUUd1ODRDN3pIaXRYdG0xZFF3ZW9OODhqOXFZc3l6aUlLL2ox?=
 =?utf-8?B?cm5WRTRja0FYN25ZMXVlbGFsdHpxNENnTFhJbURXbTU3cFZUeEx1SVRvSWlD?=
 =?utf-8?B?Rys1Qld5alJUbXNxbU1SNXF0YVE5TlltYitWWnV3S2krZTlSVTEyMXk1eVo4?=
 =?utf-8?B?b0N4SUFmTEF4M2pnanJ6UXpIN3Z2azdEcEsvaG9MTTlMSEVDdjBmb2NCY3hJ?=
 =?utf-8?B?cHpwQlVNZ094OTBDelpSQXErckk5bUp0MTAxYWhLMDlzSXZqaWtoVDZ2eXFr?=
 =?utf-8?B?RG9rQWZxNTNzQlJ2ZjczNFdIWTE5aW5vOVZQc1BLTTV3QW5Eanp5L1loNGlM?=
 =?utf-8?B?N3U5N2ZtOUZHdFpMUlNHYjZDdXhZR3YyOW1KNmNrY2MzQ1l0RW50UGgxak1u?=
 =?utf-8?B?NnU3K29IYmhZa0NTbDczc1lucFcvRS9Sb0VmZFhzck9LNHc4QW1NMGlVYWcw?=
 =?utf-8?B?MFdyNHdJOURKakI4ZGdLeWZaRUtQWkFBQmNXV3JmdTF1OG5xVFNNTkJMaUVT?=
 =?utf-8?B?VWNOZ0RtUzFWREVrTHJ3SU9PSFR6bnBJNmtub2o3WEdNdWh1VG1yQ0FhdldL?=
 =?utf-8?B?b2x3NVc4LzVWdlpVT2d0UkZ0WGo5b0pDN0NyODhqdUcvT1AzNW1hREkxdzl1?=
 =?utf-8?B?SVpzWGhpazRMVVhSZTROV1M1WXc0MmlncjZrWTNVRDBsaVF1TG5IUGRzdDk5?=
 =?utf-8?Q?U2wxpkwgSG4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR01MB6877.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2hZak1SL29VV2d0TmVWNWJETEVFWVZMOUg2L3JmVldzMTdFam15NUVPbmlM?=
 =?utf-8?B?a05XMEhLNFRLZEllNUN6RlVvOHhOMnptbVJ1SWJROG92K1libW1naFhIb01B?=
 =?utf-8?B?RkJwNDhQL29LbEd1SVIzYTM1OVEzRmVqbXErbTJGUlVqaTBua1lSZHJIdFNm?=
 =?utf-8?B?YUVycWFNVVQ0SXdkVXRmVVFSZldoVzhWZVVUajhobWVULzBDNEFra1UvZ2Fx?=
 =?utf-8?B?UFkvb0NhdVZvbXhXZHBEeXM5SnRuZDR6MVpDMlNQbVdPVlQvQkFKUHRoTWRu?=
 =?utf-8?B?RlJuV0xEWEFIaEFBUUxIWjVjSlBiWStkbTNFTVR6Y1JsaEhqelk3NE9VcXBI?=
 =?utf-8?B?SnZ1T0FBQ09NU0R1Q3lIYUNqWk1SaXNadjNabmpKdmRxbERkWk9rZ25rWjJ0?=
 =?utf-8?B?bXNEWTBDQUZ5MVNvQ01Jb29rUDk5cUdyaGtGNjdlNHBEWkExQVJoRVVaQXcz?=
 =?utf-8?B?bEgxVS9XNnVSMTI5TExKVUMrRjMyTSs0L1RnSGN5M0ZXZmU0aEQ5S1JxcEdH?=
 =?utf-8?B?ZXk1cElEdW5nS3FZNjMvcmttMVBhUjBFNEg5bHc3YnhlZXVRSEkvaEpnWHVZ?=
 =?utf-8?B?QnZKYmZtbmNxZ0o5RmhlTTFZZEVXVncyZmZqdFFaei9JaldweWdtaG1UdUdY?=
 =?utf-8?B?Z1Z2R1VlZnk4eitwNmhMQ1d2ZUFTcXNGQkdOSDBVdTBCempNRnZRaDJGK2F6?=
 =?utf-8?B?ZUpFZWw0cVc3ZVdzTXJLTjkyU0g2RGFWVk1LbjdVMk1Dd1NpWTR0aStKWEh4?=
 =?utf-8?B?SFVQdHBwQTI5SVhKOXUxTjhoTnBBeGFqUndOeFJrWmhzdVFWdklUWG5RenZW?=
 =?utf-8?B?ZDNtSmRrYmVMR0Z6bGk4YlV2Y1dnK05jeVFKVTI3RGJCZjZIRGp0b2lUbDRR?=
 =?utf-8?B?M1BUOVh4Wi83MkR6K3BYQUJqOVpPU2p1c0hLVkw4L2tOQ0NLajAyaU5HMWZi?=
 =?utf-8?B?NUJYNWJUN3kvemU2ZFg1NGJucTVZczdsVkdVcmw1TjZ6dzBlQ3dadHB2cTZw?=
 =?utf-8?B?dnU1MVVUU0ZYSzB5UndadnoyOUhrZ3R4UzhuQmY2azV4NVR3QVh4MzZ6UTZG?=
 =?utf-8?B?Qzh4VE55anRONllMblBLL2tWNjZLdFFHWDc5Mm9tMXNLWEh3MG9RUTF0U2ln?=
 =?utf-8?B?V1lpSlFsdTJhamZGTVgxYXAvdm9XTjg1czdSeGpDdzF0M29JbitzVFBwQjVQ?=
 =?utf-8?B?ZFlVZXhsYSthQkVhOWJ1ZENjSXZsdlNkQnJ5TFhpVmNMT0UxY0xMaE9sZWFT?=
 =?utf-8?B?dUxOdmIrWkhvYnpjWU52UlRqTEdWa0FLTFh5R2R5MHRvaXQ0SFpReHRqUkNW?=
 =?utf-8?B?WW15YmtpamI2SUZzdzl2bEhpTGd5OXBZdDVDcUZVazVZRmpJOERwRVVzRTBu?=
 =?utf-8?B?VE41cVE1VjQ4MlE5UUJwUmNOOWVqWEhieUJJSU1pU0ZML1JDdnZBTSsvMlY1?=
 =?utf-8?B?WFJJeTVTMFRKOWtualNBcWQwcXo5Y0JoSXZMSVhFZmMzNFNHYzRiVVd3NXpX?=
 =?utf-8?B?VXI2cXVpcFYwakxyQTl5Y0twYjZ2VzQ4SnVITVN3dU9WNDhvUGloSUZKZFdn?=
 =?utf-8?B?WGhBeXBxTjFtTC9WdGxYekdQcVJvM3VQd3c2VUJmMlFtRkFOcmUxUjk5Z1gz?=
 =?utf-8?B?dzhJd2VibmFTRWpZOURwQ3Fvd2hDUTRYb0pnOUp5cWJDdmVnNFF2OFFMNDJr?=
 =?utf-8?B?REo0dHhJdGlWSUsyZytTeDlCRi9nVUpQMkFXRUNrbXlieEhDemdvMzA1NGJH?=
 =?utf-8?B?OUpvd0RvcWpTN283VXFqSGw3K0VCOUJ3R2RLQ1NyVVJtWndRTDRhVnZaWmo3?=
 =?utf-8?B?dTh5d3FZbGl1SlMyZTJVMEhNVk1ZN2pLUEZtdVVkbDliV2lPQmtVby9ibjNG?=
 =?utf-8?B?V3BpOHhkOFZLQml6YmhGeDJ4T0xNZHVvSmVBbkZpNWs1dWVSRzhWc1ZhZnVs?=
 =?utf-8?B?U0RpSXJCbGxDNWpJOFg3dG5TWkdpWHUyUTRYZ3hoS1pQcTlhSEZHK3pYbmU3?=
 =?utf-8?B?QlFyNjhWZndIcWdjdjdxRHEzS3BiYXB4aE5MMjRtNXJ2SDkyZDc3emNORXY4?=
 =?utf-8?B?TEcwdGkrUjRBNDQvWWl3SmZMOGhyWUJCMDQvczg4L0NFVXlkMEE0S1llcVlN?=
 =?utf-8?B?Z05pWmJvT0V4K1NlWVZjMDZ3b3RyVXZLQms4ZUNadzd1OHp0aDZsaVp1aU1Q?=
 =?utf-8?Q?pea/G5uaizTbNqaVtWA1wIU=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e6ecef-0988-44d1-5f33-08dde0d84125
X-MS-Exchange-CrossTenant-AuthSource: BN0PR01MB6877.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 17:29:16.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4HjRS3+yos1xSeXiiuAh+89I5oJ6MxKTGowRoxTYtbC7tCMyZ/TcfSobnwcJYU0vFrQLPeN18t5ANu3VHcAGw1vwPArGDWKSTlNlHaBpow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6657
X-Rspamd-Queue-Id: 06D9B80006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5emhgzbfwrdxqunth9no3tbwdsyhoe6u
X-HE-Tag: 1755797360-239609
X-HE-Meta: U2FsdGVkX1+rKvlZFMKZeR+h0HiH35oE4fXKq7clL5xfuBBRTAb97HC2mfdD/BdnHd3BCoENzjpX0G6NrW5gsWEPpAzDGRMoBWOs12NFkPXbeTXAB4q9owA4Z0Vq0xZvb+TgzA5LGHOK+OxU71oXejTbT0YgajdDp02gzorfyfY+I0up0gmciVJ4x//5TZgvBW86q+cV4FBi1pp2WcTsZnfbOghv0e81YLo8hIMb74QSRG/7OCRA2NPLt++NqHBt676TypwcXZaWcbRWiHZlcuqEAY/T1cnOCIgptc7LWDFWomHPO2cGLIM2O22MantXz6gfQrR2EL+HddmPZKoKAyJPpEXZ1g+bxBvTh+Y9UEHDR9m/CUD+lTKHHjk7okrhUBOThgjdSE5XyzKpCfuiPbom3RhyhS9vzuZcRVgY54S+XFtddlcMSZ/e4Bz82r9Q4XsfWc8wV3TaA4dLYvoGgaMixyega96nNGrMfGCXKTNBFZ8HLhVcs3QZwLvqbCgKiAph4xjaXPCysglR3HKsyG+XYaJSDRs0CTp7TTPizmCLxKIfBloSP+Y5CDUOimodAwAmMSfq7/vVATxLOO/px0IJwf5RP7zNIKnl6zpJQaaXqcsElM6kW+WmKCBcG1LzbI39Qo1ZbreyceWn/SsjdL64j+NnoGJH/E88FLKp2pBA6KVDseyJwiYiCddI7Y5EGekQtCHWuhjkTcs0ZyVxGNe4pHMd1oZ4zrRVZ2WT/FGFuBHUVdPJOAhhNSy46ZMNBr3/3mgQA2EPa9jEYQw6xAd5sukDcgAr6HlkrwYnW4SU2+gr2Mh7r3ywwgba+Dvlofq8FjznoIcICC9N1oRIwSIt+vNa9QQmG9hrXPc5Ytm8W7xsERUVfuLKLBHWHiAdoWWRiTFwfeKHlzRijbAewEQVear48RVRFZbnse0jvLxygL0sREszd+Ri6lfTALn9vyJxZKO3z31y1FWGwF2
 qWuOJFA9
 J9I2kxyn1v6DmdbbZ0XbnUjGsd7M1CC6FRRCiriYmyx3Jt2ElLiOUfgboUhSUCWfuPYhlx2Tnscji1v5XTUMolsVbERm0VqcRxANsDp9Qho6CBwKJJi3G8kG4xHo8btP3Rnje289QNeUKWChqJL3mgChE1KrixCvy16GCuoXuq4RiktUYNpDza+L7MfWQ4nlhJ3/ElXfXp2YPNxb+qrICvPvlM4sPVRTbI8eMBg0+Zh6AS456ZzKsn5CpzEq1t00LwpPKy9uazLk48692LllHY+EYHZfN5LUYgXsTWfxTvQRmIX1p1LtSx26ebz1K/aGezv9tIJo0105WGf42vuU+fRkD9bS5KeKCBgmwgWgsMtX60mVwRN/oPPan4/F5tePk3bXRZGWv1fQDZPshbbT3S0jzEfqP9VMckaHZP38hPpkPg1R62jBqAoUYOQMjs/K5T2d8BcSJDJJtZoRjgoIk1ltbgQJv+wjViu48jq3/xO1DLXk1D5ndFOl1vAzXmRalo88ohx2LyZVs8qmrk8E6TNJ1TLO9BtToiMYJS45N4v+0FsJZkxwRzAkhTeVFtnewP0wmOfgNezkTU7M6ESmUCeuCZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

On 8/15/25 1:54 AM, Kevin Brodsky wrote:
> This is a proposal to leverage protection keys (pkeys) to harden
> critical kernel data, by making it mostly read-only. The series includes
> a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
> as well as a page table hardening feature based on that framework,
> "kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
> concept, but they are designed to be compatible with any architecture
> that supports pkeys.

[...]

>
> Note: the performance impact of set_memory_pkey() is likely to be
> relatively low on arm64 because the linear mapping uses PTE-level
> descriptors only. This means that set_memory_pkey() simply changes the
> attributes of some PTE descriptors. However, some systems may be able to
> use higher-level descriptors in the future [5], meaning that
> set_memory_pkey() may have to split mappings. Allocating page tables

I'm supposed the page table hardening feature will be opt-in due to its 
overhead? If so I think you can just keep kernel linear mapping using 
PTE, just like debug page alloc.

> from a contiguous cache of pages could help minimise the overhead, as
> proposed for x86 in [1].

I'm a little bit confused about how this can work. The contiguous cache 
of pages should be some large page, for example, 2M. But the page table 
pages allocated from the cache may have different permissions if I 
understand correctly. The default permission is RO, but some of them may 
become R/W at sometime, for example, when calling set_pte_at(). You 
still need to split the linear mapping, right?

Regards,
Yang

>
>

