Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE3A3D4A5EB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 05:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677386B0104; Mon, 19 Jan 2026 00:08:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624C16B0105; Mon, 19 Jan 2026 00:08:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC056B0106; Mon, 19 Jan 2026 00:08:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3C56B0104
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:08:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89CA08C208
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:08:04 +0000 (UTC)
X-FDA: 84347531688.16.6B11129
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012005.outbound.protection.outlook.com [52.101.53.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8B852C0002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:08:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UIH2dD+d;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.5 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768799281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMEYtJPf00wXAQES2TRPdliSLseENsNbzxbOA4RjEj0=;
	b=Jp97WKiZzkRyOG3rlycS6pSwgYfDLkKCbh25qOl6uf76r/1Y9d0kEkH12qhVkzsiKPjdJT
	A+QqJfjxx+9L4ZWyZTvzVKnfZnj/Xh3jEn3WfHAtIxdVTJQWh5sdI7P/h8fd3PpyiIIYGK
	wbYdaxorI2Bkx1DRAlZ78+dMxExobkA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=UIH2dD+d;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 52.101.53.5 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768799281; a=rsa-sha256;
	cv=pass;
	b=Q5hISJN2vfNi/PzFy6+BSPxRHLqo++YEIz/AyyUG6w1SHMJX00q3gq6FszW9SOkJ9Emxg2
	NJWC9KKEB9qM2TO+uGf5aYrfC+IVZhWCTULux7VbL0NboilhHVrg6qtX5nCH3t0+ZEK1yR
	7/TUd2J2kSWtDBMYXsaDqsGX/5uU5aM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvXviXdFOueEILoMjw56ljfV83J5h4Qr7SAEhKYVC3xr3bTA8LhWEUDpWvjnhc+cS0cqOtPmTZIgfeOzBrnrUsjzRVP8eT7Ev9J3yHIkU1fLwpgVN0W44rLmIq7Utk4byDk0OTfmbfAZ8dWbwE4gXQWP97TRpV15Xg0SG3oxtnS41ABYRu4K8BzjF/Qe6P3cUTJcxt4IZuRwYDkoKPdmXjup7/EtSioDwiIn7XOowGFKFe5DnmqEF0DBNwC7BRxeWG8OtHXY3OzFu4TUmkGgROrrI19suGsbMDmBJbnCK8LCip11baDamUbAoEcJAigl8qDRZUHSj9qnhOVwO7GgcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMEYtJPf00wXAQES2TRPdliSLseENsNbzxbOA4RjEj0=;
 b=cox395n7QDaYHv5LgqBs7vW4LW/8hF4Wkg8xxDcu/dJ1TAGTurcnJDWjqAaWnlmpbPb+DUlCKWJBsxWr6wMVzd6eEXjbI6D5UBrCxadDtMqiNeQc6DYle6r0KvjBj1fcG0xAfOuHuGgyQhuB0CCdIkjVkcugBCFcFdR9FmuLDWI5+VV6b6O9Ak//7jdhdxoN7nIR96EVqH94mBvpJGiU9uyt8l8KNYYorlRGY7l9Nr8+tsF+J8otBDI6JDj+3niqSjo44FIEOKCX7vxdZ+ib67TsZLRDFzso1hqjuAzZbBEMNRjlByyYeixOyzyLxKOJ0s+WtfzIoIxfl6EkJ5q8Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hMEYtJPf00wXAQES2TRPdliSLseENsNbzxbOA4RjEj0=;
 b=UIH2dD+duaAntOKPcxojE/npR/0mDcrdL2piZuMuDawwlTg9YWFH78AjWqxJ038enfOqKPbx0q6RX2sWMgq4KBsyDugBU5LYTHTYk8HbTB9M5/MJDtmtzsgzfv24O5YKQERNZjAexy/FGbt1GcDnjJR2xlOWv8C/k+3tVRG/edE=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by CH2PR12MB9543.namprd12.prod.outlook.com (2603:10b6:610:27f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 05:07:59 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 05:07:58 +0000
Message-ID: <12b6747e-b844-4931-9918-fd095a6d772b@amd.com>
Date: Mon, 19 Jan 2026 10:37:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 0/2] mm/khugepaged: fix dirty page handling for
 MADV_COLLAPSE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Masami Hiramatsu <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, linux-trace-kernel@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <20260118190939.8986-2-shivankg@amd.com>
 <20260118122229.dcdda884bbb19a9c30ec6f1e@linux-foundation.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20260118122229.dcdda884bbb19a9c30ec6f1e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0088.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:2ae::10) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|CH2PR12MB9543:EE_
X-MS-Office365-Filtering-Correlation-Id: 630b8ff5-e845-4291-442c-08de5718b690
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFR6SkQ4TjNzOERnaEp1Q1RMUzJpZEYvNUhodmR3ejVUZndUTDkra21rQmx2?=
 =?utf-8?B?L0x5dy9yMlVXZGcyWFFwalQxSU5YM0hJWTlPV1ZjeG0rKytSVGlxUlEvdFJu?=
 =?utf-8?B?bGJGemYwZjVRQUpNZVdNeGR4emFwQndQdVZjZWZQc09qWUl4RDBvNTBvZjJq?=
 =?utf-8?B?eFVBdWo2aEN0VDBwcGl5MU5RSlEyOThwRUJXMkRPczZXK052MVN1L2FobU04?=
 =?utf-8?B?RnRJaDFKNjRUYnZ4c1p0aCt3akxzYXlGdkxldkZoa2c3SmhQZHkwWnBtb0VG?=
 =?utf-8?B?eHU4RVFLSDFkVUVBTExKWEpLM1FOQnd1NXUxUitNekwwS0R1ZUU3TUc5WXNj?=
 =?utf-8?B?UFVIeTJHVzhjU09pVzEvbS9paUJWT0puVUx0UnpabEhUWTlSVEwwZDVYT2R3?=
 =?utf-8?B?ZEJMN0RzblRHdnhzRjdjcGI4anJSa003QXBieVN5M3ZkMjdCU2VxdlppTks1?=
 =?utf-8?B?SlJmT0o5L1pTc3pKYlJrWmhOK3c2R2FsUXd4Y3NreHBBNmd4YU1XUjNnaFJO?=
 =?utf-8?B?dXVhSmJCRHVlbFVUcUZvbEF1R0ZxVTBQcnRmeGVySThwVGc0dVNnYUIvcWc1?=
 =?utf-8?B?aUhDZWt4cVAza1hZZ2VHZWNWMVIvVGZXZzNrS3FPUWYzVW50TFNXNDdQaW4z?=
 =?utf-8?B?RGJYZjFWZnhNa2hHYlNsZmZhV0k1OFd3TTVDY2xaVEVBWlpxYjZsSXIwNmpx?=
 =?utf-8?B?QUZ6WGphTHNZaGEwNW5YbExOQ3REVFdpWUI3NEhzZWJTSGROVGdXYzVEQ1kw?=
 =?utf-8?B?ditkY0tVcGRVUW5VdHJOcGlCbTIvUnVzRC9mTGF3NGRVSHlVYldoZENOaEwx?=
 =?utf-8?B?dzVnNHIxSG0xZXFMRTI3WUFSZ0dPNittTEhVSXIwRkhZejVGRjlyWGE2TmlM?=
 =?utf-8?B?WmU5QTVvWWdjMkpRaWVwV2lkcVRvRThHR1dHUnFxU2pITUk0aUkrYTZvYlJT?=
 =?utf-8?B?VGI5dkVpdUlaWjNDRzJnNmNSdFFzd0hUa20wU0hsVmtiZGNUME9aTFc3ZUFI?=
 =?utf-8?B?Mkp3aWNhRGNaRFNINHFWTXg0YlNyUU9zZzVHTStmUE15NVhqU0UwNDZRakhy?=
 =?utf-8?B?TEd0a2ZXQzhKRSthYkhIYTkxQlpsb1NIczNzTUQvdGhuVHFYQ09oM0VxcHBx?=
 =?utf-8?B?WTRRUlVhaExxMDN4T01TdmdHbzFiSVRsRVpTN2JOT3V4SktLN1hSdEFTbzJM?=
 =?utf-8?B?VW9DaVFYbjlERlYrVFliMlhtQTFMaVM2c2oyZmo1cWNaTmNqS0FZamYxS1Fs?=
 =?utf-8?B?M3duNFp3WkxRL3Y1MUI5dVR3WkY3RmRaSWVPb3JQMTFmbjFGbUp6eWY0cDFo?=
 =?utf-8?B?Zjg3UTJNazJab3Ftdzh6aEZZZWo4Qjc4aGVJRkFabDBmWm1WN1EzWWVNWWFO?=
 =?utf-8?B?RFRacDMvdisrVmd2ajlvK1pndUtkQ2VlU2M4Y2pxTzgvUWw1eEczeGNBR0tX?=
 =?utf-8?B?cmVneUdUcmpTcVh6dTcxVm1vZVgwREZuaWNiM3dWTW0wdG54STlNS2lpWTU5?=
 =?utf-8?B?QWtCdHd2Tm5uZ0NqdGlJbEFKV0NqM2RIYVZ2dHhpY0ZEOTQ4RmdsaGZSQWRR?=
 =?utf-8?B?S3gwcWVNekErL1E4S1VLMnlybFFicjdBdDE2NFc5OElnY1BYMUNRSnVOc0JJ?=
 =?utf-8?B?SG56b1Y1RlhUaFRIdUZuYnNVSUtDVTlWenorU01OcXU0SENLRGNFc2FmSUFy?=
 =?utf-8?B?YnRoSXNEcmZCd3ZHYTJ6RS8rUGw1eW9kMXVMWFYxbndVRExxQ0U0MW5CaXNK?=
 =?utf-8?B?d0FIUUhHM2tNRUFHME5kQy9DdTBBd21zajRKelFvNkgwTFBocVh4eXNLaGlG?=
 =?utf-8?B?ajBzcTVxMkxieEIrL0ZabkszUURJclJPam9KZ0lndUVjSmZPYmtkUlIzeEpk?=
 =?utf-8?B?eVk4cDE1L3F0M29WRXJ2ZkMxVHkzNVczWGNLMWs0MXJYYlZubWVBVDBuOU9W?=
 =?utf-8?B?c1hkaVF6OTBVSmdyeVpGQjNmcU5Rb0dzZ3kzcW54UlBCNVdqZDROcXUwN2xv?=
 =?utf-8?B?enRlMTQ0NUVIUGhaM3lYN0M2N0I0eHQrWTd0QitoQStJb0l4UmdyekpjQ3BH?=
 =?utf-8?B?blJldWhSQVBHa0MrQlM0SDNOREpES0hvZTNyay96V3NvTmJtNWh6eEFqNU9X?=
 =?utf-8?Q?rgNs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUpYc3ZsZWFNNWN0eGkwL2g0VW5rR0dRWlRMdjlRVkFpZUl5RHg0TlQ3WnlH?=
 =?utf-8?B?cmNHSmwwdjB6akdrOUZGUnYvMWZjeUcyV3UraFg1MStnVjZrK3grMHJMMWRL?=
 =?utf-8?B?bTNaUGJvcFVFSVJacmNDYnVnbE5NNjQrNmJBaC9oV1FqeE5MNENlK2V4eW5Q?=
 =?utf-8?B?eG1BckduZ3FESlE1SU9JcE1RcFR6VWNFeEdFbUpKdzE1ZWhqQXhiS1RJVFJG?=
 =?utf-8?B?K0VwVW1kWWxCZ09uRHYvYVZoYUdkSW54UzZOMi9yc2d3ZWhkU0R4ZHBBa2pL?=
 =?utf-8?B?SGJHcmp4ejVUREFObGczZjYyYzUxbFlwVzJhci9mQTdldHE4ZWV1eHVpRTRL?=
 =?utf-8?B?aHd3bUNMY3A2c1RJSEVhUGNIOC82Tldwd3ROZFBBaHlXODNRUmZWckFYRC9U?=
 =?utf-8?B?aHA1Y0pNaXAvMEhITitHNmFvUHBOMXZka2dBVG5HT0pnUzdEaDNpWXh2RzB3?=
 =?utf-8?B?d0VUenQ2Zkxzb3BMeUpLZ0JQZGdGdzNvZkRycExpOFlRUFhweVFkcVJ2dDds?=
 =?utf-8?B?eWR5QzJya2tqbXlZTElMSmlzNDRwVDRlRlR6T0o4VFoweGY4TU54RG9Yb2Jy?=
 =?utf-8?B?TWROb3MvdU8vWG5qaEthcUdRbkNSaGl3aU5yOEJvTndKZDkyOTM3MHNldTNh?=
 =?utf-8?B?TXdYTjR0Qkx1R241aGhoZTc5WFk4Sm9NRWFCK2xTRnhLNDUvaTY1WHhaSW03?=
 =?utf-8?B?ajFuV3BIZmVheUhJbXl0bm1JcmY0QzduVTJ0d25DRnMrbGdla0pTL2VWc3pZ?=
 =?utf-8?B?Y3dBekozR0IrWCtwbVh5OElHL3R4ajhGTmk4S3Z5T0Q3cmN2ZXFCaFVINTlL?=
 =?utf-8?B?TU9GeGlINzd3Slh2YmpzSE9ESHB2MWRoYkRjeVFaU1NEeGNQdnJpOVoxUUFi?=
 =?utf-8?B?Wjh6M2dUbDZVSmxGTVdpdGQ0ckVycUF1N28wd0pyN2hxNWNJakowaCtneFdD?=
 =?utf-8?B?TmZkVWpqcWMzaUhwSExRbndBdWU0V0UzNTlTTkVaTmpyS3RKenQzUDlaYWV1?=
 =?utf-8?B?N0hMVmVGVFpJZm5NTEZmNGpMWk10TEgybWFBZ0p2Q0x5K3NKcEphdmFOb1ZP?=
 =?utf-8?B?U00wOTR4RE44Q3Zuak9nM2JYS1MxcWp4MU02eXM0bXhMUy9YZFdLczhyWkxT?=
 =?utf-8?B?ZjF3aVNOZ2RITHpRRmNwVUcwYlJOandTTEFLVjlUVU4wems0UmpPSGt0Yk41?=
 =?utf-8?B?aVdaMjYzRVdpYVFKa3BnYW95bXVoZ1gzUHdMUkM4cmRSSVhITVZvcGR5Z01n?=
 =?utf-8?B?U2FaSElUMUErOHJqUHliWHZWNUJRQkZibWZJMUpOSkh3YjBsTVlHQXpUSGVP?=
 =?utf-8?B?Ty9PYkhRVEE5SDBZYTFVeTMrZWkvTlhramNjdEluSXgzTnJSRWY0V2s1UGY4?=
 =?utf-8?B?elRLM0duUlZIR1FGMmdoR0VXNDlyb2FYUEtHaFhQaUZmaDM5M1pYZFBYMmJM?=
 =?utf-8?B?WkZTdW5WNnArc3pvV0xVVmV3U1NyVjVUVXhZdlNGOW5CdFZjbTdlZU1HcWVl?=
 =?utf-8?B?QmtES0h3QXh6S2REelVEeWtrKysxREdtbFBFblYxY3RlR3ZzaUZnL2Z4R1dF?=
 =?utf-8?B?V1M2VHFhNzRCZUx3dExJNUxkQlZ4OU5MZmdKQjIzbGRZazhsS0hGamNSaHY2?=
 =?utf-8?B?dmJXWGdTUVFvNzk1b2tRc2lWbHA3SnZMUFZBSjVVcTZlMEp4RWJSVFY5d0FV?=
 =?utf-8?B?RGZnSlc3bUdyTnAvalZmeFo5OFpSSkNkUzJjem45UC94SEVEcndYRWVFNFpw?=
 =?utf-8?B?RThaMGVvZFJOdGF0cGh2SzBraUl0Q24zQkRsRGg1QXpPT2hOT0lkN2pTSVpl?=
 =?utf-8?B?NVorN1QrcURpY2RXVTJyK0o4M2N4VFNEQW5GM2t4Y0xSMVJhcVBnVUhiekor?=
 =?utf-8?B?THUzWkRpM25vdWdrSE03NC92V2d1bWFNbTlLTlJsRDI1ZXlXcGQ0ZXJPSDA1?=
 =?utf-8?B?RHpFZ2tMRG4rS0tpdzM1eDQzTCtEWmt0RXVJK2hSNm9BQUNRMUZHSjJoUHc2?=
 =?utf-8?B?ZHAzQ0tUYjlxbUE4RnhMN2Z0ZUhYT0tIWFJad2x5aGlpd0pjbytLa3pidlU2?=
 =?utf-8?B?VXJXZWFVL0FDT3Z1TFJsd0htMzZpaG5kTWp3OThLbHRFR0JnTlhLSTZjbTZD?=
 =?utf-8?B?QTNXUlRTZXBoY1dtMG9qbXhxNm9ZM3lNaDdHNkF1L3FiOEVBcGs4R3BORW8x?=
 =?utf-8?B?ZnZ2TVBnL3I2K3RTbUhZMGhpU3pUeTNoekw4VnRXWk5hU0xKQ1lCYUY1SzVH?=
 =?utf-8?B?V3N0bDlNT01oK3VxdG83WEVSUVVWaWtMWDBtVCtNbHFpQlQzNDladkk4WUds?=
 =?utf-8?B?S2NGVkdTdWpNNWRyd0RoK1dnak96aTg4bDhuOTlBcXMwMGU4N1p5UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 630b8ff5-e845-4291-442c-08de5718b690
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 05:07:58.8530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WqLhNm3hIUilGTFOij10doqYcy/anYu7s7h+xhtqvQ2FWFS5YM6cc14RDxkZEffYfrc6Tk+Xc++3yGXWc8lKkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9543
X-Stat-Signature: w8qy9e84qy6sp6pq866y7wps1akdzc89
X-Rspamd-Queue-Id: 8B852C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768799281-992427
X-HE-Meta: U2FsdGVkX19c4HXDY7kCVXALViOt0GRjHkFkxiXIjR8w9/0jqaZObQZELNvfWiSbd46G2pZb27kElH6OUXIO1uEGBeTF93nR7nWYhEkt5qFpTK+noBkEc8liihNLJBj3BEg5Gk8W8xPD5tURzrAcxrdF0DIez6Gw9HEfzfaHLaC0WnhyW42vRnyTjHYTuDoB8KlMscyjJy4m+lGc1ouGxj06zb58MH8Et5BgUWI8Bd41t6GsvkOaJ/jdiU5gJ22l0WurNrtvNBp5SVheVNxwDGrzj60xo98cvMPgp/uzYSZiHvqyBv9GAtYmL6s8LkI22/c6LBFuFQImSmu0oYT7cw7iEk6zasU836iKBm8oz0iUvtWqNXLhmzqR0XMUwI+QSzt9m6LodJ304E7sJiXxi7+/46zg4kaeiE1kLoLTUUFnRdQevEjPJ+s+qL3btt3vSX2M/0w/Vb+mhZ8u5+RGiSYV7rYINkvNfY33aHR4JjwMgBKGG5/cCbHnfhL8MQ7wu3iLg0dCv+SPTtftGvOCU12HPkaXHZQpe865G0bL/MS3K2b1Ap7RAvyDQ4/L5GgtpqkQ3VuKwqaHdyZA+D1fUfS9Rty1rRzuBhnZBvNSUyJP4sqKCpKp07o2A0SChpHPdA54e9tgubg1dMGCWnVFztM1BGBe7n7X5H3NgnVIe68NCSwCfk3noqvjdP1NVicxxij5Q1o1cgNH8AKWQBW6MMXh2nFG1cmqEP0E0HgARJ5kRxMpL7oNbAiMr4t3Y/K14Ys4U9QgHlmy7Mqlk0BiRa6g2ZCBmvKEfYxq2AQwV+Ke39TeVpKEEq5xE717ZspZMB0HoN4ue72XR9KbEFUci9dM+9Mo1xdy+VKikP6WGfIabUjMGc9aWYNq6Vhx6NcnOeSivP1heF4ez/GadEPEycYiIot2rZxWBR9L/5TvTnWWq1YFZCBzIqcr/ctlV0Zt29juDNfqZiELDVN+Zpj
 PisyL13V
 uxDPZIdpnwJrLBcF/I0Y04f82EIHJpIHc2DAk2ZeVIUih9pY6GXQ7EBR69GRaZUa64m7yD6oYxHyUT5nOJm3lxs3+PqXXM0XBCkCMDXPDPR17H2JInOYIYFgpsryigUuqTyiG7F8x+sDCU4oCv9kBdjwh8Dil+zWb+WFvgjp/RrRbvQJyjjJdb0vo9m7bbePrJXi5x18Hmh7Rm/7BhK5axfHU/XKPt2sAWDeyU/EA92ZnLN8sRx5ui3syxu/zC+hExGOtiUTLB481JgKq04x2G9sV1W5Zv31ZPYbwS823tBM84SEl1yhY3R1Qq7KXMCQUtz1gkIL8Spe/Asq+KtG04HS5NWUn2PwMuUsYeHbc8o158mS4UF2LmHT5bB6Yf9uWH7a+SOB6BbVR4RNq2s7ACCs+M2DeUrwo8IusgEwGep+9jn/X84jqjEtIsteNDBqbOcv8BJL6aZ7wQZN3FlAXjoY0pZgCbinCJXwVgcU088EzsJBpGl3JaWrroA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/19/2026 1:52 AM, Andrew Morton wrote:
> Please tolerate a little whining about the timeliess here.  We're at
> -rc6, v4 was added to mm.git over a month ago, had quite a lot of
> review, this is very close to being moved into the mm-stable branch and now
> we get v5.  Argh.
> 
I sincerely apologize for this.

I had this doubt on sending an incremental patch or V5:
https://lore.kernel.org/linux-mm/7a42515f-ae57-4f4d-831c-87689930a797@amd.com


>> V5:
>> - In patch 2/2, Simplify dirty writeback retry logic (David)
> Are you sure this is the only change?  It looks like a lot for a
> simplification and I'm wondering if we should retain the v4 series and
> defer a simplification for separate consideration during the next
> cycle.

Yes, patch 1/2 is unchanged and patch 2/2 is the only change. 
The diff looks larger due to code movement but logic is actually simpler now.

I completely understand if you prefer to keep V4 and defer this 
refactoring. I'm sorry for creating this late-cycle churn. Please let me 
know what you'd prefer and I'll follow your guidance.
Thank you for your patience.

Regards,
Shivank

