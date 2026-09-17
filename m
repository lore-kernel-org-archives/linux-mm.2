Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33586C982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 15:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060CA6B009E; Thu, 17 Sep 2026 11:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037806B00A0; Thu, 17 Sep 2026 11:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E76DC6B009E; Thu, 17 Sep 2026 11:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07956B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:31:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14A0E803EC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:31:45 +0000 (UTC)
X-FDA: 85223644170.28.8428436
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012007.outbound.protection.outlook.com [40.93.195.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23FCC180007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:31:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=enPni4yc;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789659102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAiINy5s8ng2Z3DADwRNewZtrCntHTICXSn/ZkK9x5I=;
	b=V6RX4blmQKE6SJgDSHyrBS/NHTV86XCXPSp1K8lErJmcJNn1lcJ2BgWHFSwhMrHTxP8UYl
	ebh6sFCiOdiBd8hBXoKkNbXXoQpVOseFQMX4qdMRHsYcd7/81ROiBZb9INT1s9ZNfhI3OW
	OJP1Y+rHmCfkIqi8ELmpu5YUouMn88o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789659102;
	b=h6yK9U8dP73oCJE+adZDutd3HjGg5GDvq6I5niXz95Zco4FQKqw7bQliyBT/r9z5MI5Wl/
	UMKtoyfRUQuVPhXFycTtJsytmZ0scNgXBBk9Z52ygLghjNJUjx6yggKwnxAuD7xceP/ym4
	3l4qfCzfWj9A+T5EXVfcufvM8jM9Zng=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=enPni4yc;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYwf1EtFnWnF9p80pv+Ba4e4l5D0QcdarEtWpXFSyVKHd6N9wNeQ0AioBOeXMkZsDWoQODVjRz/sagZpSGFlATQX0YcJnYrgf/fcNR5wLB4D7uZZZp87jj91J0zSwjfG09rWoerYGYxghQLnYgIz1jPENj/NZYYU1uQgjyJx8K4TKp3YhT73sxe7P8Kv0Sh1siTMKh3CYD5laegAXeozEdIf2U2Df8WKmvD17UD5f5MIu0eOh9nvfvViIfnDm95rjCu1zETXyf2E3A5WPgrSZDx1YQFuMm9fkzGnzeobZWeZjYhXd9yjp0tBQo41+OExNaDQUK43HGH1UYx/c2QXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAiINy5s8ng2Z3DADwRNewZtrCntHTICXSn/ZkK9x5I=;
 b=KaWui7nUTO/2bYOtwvDaEclbyXThyw1JpWYMxe5J4+ZCo9sRqya9xuVqjk1+ZfMcMeGsBKRqv5HdEwpyL+swZh+PHSu3vbIyogEJ8uAFn5GlCsjiiKmvDEP1NPbBC5FozBfcKwqf7gPhlsr60AR26VhVnjGXYVQUqtn17WqWYuYvH8EtN/jbDGeaZMUZMwaraA9nKFn2/8may7ACKz3cVIXDfXWnJJHxKu0gB10kYiCAAvJvRejZdIyyH1QREhf+h/2/efivnBkM+7x+ttDipAIlJYIz4yo2q9UZO7iCXwdqssbff/h6yxWkj3kZgDP2lbdnWi/WX9qmNwuqagcSeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAiINy5s8ng2Z3DADwRNewZtrCntHTICXSn/ZkK9x5I=;
 b=enPni4ycdWaQuKoFgg83i7tE+vNkg+205WXlSOmhzITQ2hyCPR5J5rv7Vj8Z9vR5gc9E/OQdHxrQihJZha7G54YCp87/Y+3PtDKj6UiFJVIRfZOQ8A1v0SKNJXehVf4X6kVd0sWRVWw83mXq4JS+ai0oYwKEsCOuZo+m/CFUFqCQJMyDfKMCWfyjG+TsNSMOPhg7de00vZBQ69/wEsiTaNkze7XN2d00vggZrpiu2IqTzAyc2NAPaZViy/2Sk/A+f1DwHZn5BB9KBk1M3SovpA6eAXS/D0vWnjpL1AcuwE4RkHcv6wHrzX+WpCMdJ1zOLGz70QXm0E+ChdqtcM3uVA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6183.namprd12.prod.outlook.com (2603:10b6:8:a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Thu, 17 Sep
 2026 15:29:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 15:29:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/huge_memory: simplify pgtable deposit detection
Date: Thu, 17 Sep 2026 11:29:36 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <D86534C0-CE1F-48D5-8709-A4432DA1F0CE@nvidia.com>
In-Reply-To: <20260917054015.23553-1-lance.yang@linux.dev>
References: <20260917054015.23553-1-lance.yang@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6183:EE_
X-MS-Office365-Filtering-Correlation-Id: aab4182d-f257-4a3a-6476-08df14d07a07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	J9+XCXUYfJDW6HzbAGrSr0dEkv6FuzQNOwOIQxlgese4lO7pp7a/fQmWHMqx7iP6Tt2FJ6IhzQ7vH0blgYQZafp2H+RIBMgpPKU4teLv2Vj/Ldce+4CsCXLe10iikeN4TCYKusgUHqNzN3UczthDX1jrih4s1oRygypFk8gQgD6idfSkEb75OiOh+mVk5c74Zxo2W72jg32jgPxU1ly4JVn/l35AOOFxUQLjVm5Iycws/hqvqS905sTbGy3DyWxUGmW/DjfaYjK5aZ8s4mG887mAR6C/tY/R5AKdH7XqcCJfT6esG//xecsBMwlLWRutNha6HyfO78osHJifUe8ls8DlbVuzM5WtlFd4FfsBdz5ljvAy5dO3f0rYvkvR1JM1pn0Mlid+Ej0yWGi5xubGjBfPNZtGk+Ys6MiqhAYE+T1AA6JWJNkUa0hcSeZk86kw/ocaq8o/cLdZKOc7q+jRELeNozw5DTVVnOdAbkCzrmN4SrLcRkYWJ3HZY6ZRH25DwItEB4dmW15yKL6teN+WSQDu833yUdulVtqUevK+jjc5OR9hs3znep17ZHDdF4r6wSjswvP6+nBOJpXr8cEWI+HVsmxssLi2pyJzorV0kSHSmlvVF+z/UA+oUPglSQtF3ye0PKl5/yna1yvtqQ477BDoSjVu5dF7vHD0FBSPMio=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IFUOlzAWo47CLAEMc2bMwNGnmkZoXkDGbbBjErVwEc3Nv/pzAgKfp04BEfao?=
 =?us-ascii?Q?foxueDY967qBUXDmMA6j1FldYYf4HVLcb0CClHBV5FG5HZbXRun3WOrpFR/4?=
 =?us-ascii?Q?adknGqDGP1p/RqJtqbvgIWJDsSP9YAoRjoCaqATWm3LP01C3GGAv0Rc9cq/C?=
 =?us-ascii?Q?OwT6wk7Oe0w9KbUu0P5VaDwLj+tL8AbPgJYZhDuzMcZH4fnMIiZrYTn/iYWS?=
 =?us-ascii?Q?EMK7wNmlVF69SFknoajkcKrGTG+NZaSHgph0mq7tRFRX5WLfkNgedyDM+xzH?=
 =?us-ascii?Q?mODCVnam2XgK5O/s+Mdep8pB8aAKV+akhaRYijr89k+TEH3qGoJpWwT1bQKW?=
 =?us-ascii?Q?w1xmcxFLeV2Dj6vqBwG2e0q9nXGxC0wU7LMlojmAMTikWLSTkXqm0kzyk57b?=
 =?us-ascii?Q?GTYxfj9JGUF7L0B4naN5G8kx5tYGqNU4SOg0wbda/DRDYmClYdOWQkVcYo55?=
 =?us-ascii?Q?69VVYOFBuJVaIsGKBHBiGhnHGWDwxjJCz3tZfyJYBl1LCfWDcKAJfAt0the7?=
 =?us-ascii?Q?u4iIleehnXy1tuKp/fz1eWqEtH5YGb9Juni1w8vfpbSPt8d0VukI1ReL8f6L?=
 =?us-ascii?Q?Y+5TjppACkRU+R3X57Aa/hQz/bS5T4/AAmVJouUyu29S1DT8AEPUtNcWoCAp?=
 =?us-ascii?Q?JlwQADOxdBUW97rjezk0ez0HwlMREjSrB9InC3Mbo6Z8pQXKpmZQ14DIdwIe?=
 =?us-ascii?Q?hhn8+WvZLGKPo34WbagILzWo0mNJ9YkvsE6T4mkO71gJa05nEnRU88uIwgCa?=
 =?us-ascii?Q?ounCM/vrD1Nw/OYaU2YF47b3bGpDQJRQOAtr3eHMpjYoNxYfGqc7qOnELGrc?=
 =?us-ascii?Q?2LCc7X/MxWkUsdP0ZPTw5VHruq3Vf8JJWBMRQQp/YiC59RgOsi6NdlNJlV8Y?=
 =?us-ascii?Q?YVEEJTaqoHPkL/DDRglOJ33cVgmfCMrR2SeX1jh8CwgFyFklmCGfXfENJTFf?=
 =?us-ascii?Q?8KZqXtgCBw3a2JY9G+pNo2NKp7YQPz6IKpT+HLDqXp3ML5mVzm3TAGhIUNhQ?=
 =?us-ascii?Q?9C0phQpsEHem8noFtCuS5BznBUqFXbHOilg7WCydIB8EdbzXnlfH53b1onXP?=
 =?us-ascii?Q?8i9FRAJbDHI1vhkGGWgwgcMGWo21+PkxaZfJdbaoCr2I34g01jNArXdAuMjv?=
 =?us-ascii?Q?V9VBMjBwZjgn+yrYGfQbq/JSrUAFwg9Uxb88d4yrwKpKQOHi6stvv/WxV9tH?=
 =?us-ascii?Q?k/Wgi7WelU9OQ5Jy7y824AX7oU5v/TPpusP84PsSPiAlY9YnZxz1ZdcuWoDk?=
 =?us-ascii?Q?VnQfx+SVbyO2eEeY8430iIKgovXeFe4PS8F7TmeVlDMN5Kjhq/+bp4k9vYa6?=
 =?us-ascii?Q?CU5nGevt48GIO07QP9hoZESylutStdrPRWax8Qc86yqVpiO8MpYy+Aslt8he?=
 =?us-ascii?Q?1JWkQvnxUKn+DU2SLJdXOe99kwPcwVQShWH61Hblt6so73BVjE9Zmov8cv5Y?=
 =?us-ascii?Q?/UN64LS6SJd1+P9MlpQzEIihZJDZC5eQ+0qHbsLiVnmAT9AIohxP8vGeHhqs?=
 =?us-ascii?Q?egGwa8laVy+xcoxwhF9dgX9nFWbMtCLrmOzKyBEUHLHdB+kveLqbiwufD/XL?=
 =?us-ascii?Q?DEfEfk8GFsH5n0notOYI98crCfgRiASYWG7P23RJ/Qt/5bDaemp41aZZY9dm?=
 =?us-ascii?Q?u9TUJbydvBGQIXJkcFFkXfJI+ziYqsPFk474OhfB2oE7SCieCjXP9G9L3enU?=
 =?us-ascii?Q?6vLzlLmF7Gvi8rkB1rNjGFS/YfdUs+Fr/SrRaoZ3pwk9NAf1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab4182d-f257-4a3a-6476-08df14d07a07
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 15:29:34.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLmAX3fguobWmeE0SP5RWeMC9A+ZvitTicwUltIkRqtvpW76a46Wr9HVOwgPEJqX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6183
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: g1w9xyemzc6rkyw5in83fcj9qj7tey44
X-Rspamd-Queue-Id: 23FCC180007
X-HE-Tag: 1789659101-686725
X-HE-Meta: U2FsdGVkX1+7oYMIHyWyVzOXcKX8dwkDfcZjIAnwLm/xgaWbRcLzKtogPDvWKwjQ9wIWgz9OllolQSWW4WjoQyD94vPleFRoqtvJq3rAIArZmhpZBpBl1uvY8IlQ75fv+JCPkylB5Vtze8dRZjGkOqHOMjIj7kdxlo0g0VYZfPPY/LaENnigd1UqC0bsMb/S5dmESOYnfZm4c3rlYNkbmfHqTY+VZsax2NQPEHMrVlKG7+uqez+lynrhGxlbFoSBa84XFt14ZO6mbTKZRdpXrP0yz9q6o+3qDvL4Ehke39gCdaou6NP0LkKtgOd0Zpbt/pr9kJglV3UMsZedch9kU5raWFXAUKJ1LDipHr+7SlBsoq+A4Co9jfYS/Dl6PxOsCEhzBlRMdSVJbgxmxvG9DMh3giaVIu/coiL1IyC326gDeFOvMUo5/kUS9W26CyB85SLDc/RRXmjUisAbR3JQKtJJlbvB8gzI2gwItZ0lFt2kZZ2qnLBDp9A1bZboiCLMVj9sBgy5dwSwhBWK7z9cy/jbKKNQwrx8q0WdiA+m5Luq4MwVrr68hGGGIXlD26CVsJzHSW9jn+w7mCc4zlbWHf46kMHW+isxIE/rVXs9a9kUQ90EXhVQXR0osC2mIG4sPrPUzIkblSMpraPhzmM+zRUzRK0gGmdYp85c9D0DclmoBrl5TKgUE0kivFZCstAz2cOX6M/+Uj3wdHYeQjpWdYiG3LeA/pHVNEPVjAAiIm7vOpAP62Slf2AgdemYz/VSywW9Sgy2TzkMQntQWWhU8gG/AfWA+Q6FqxZF7eM5Meg/ZSmM3plDgogWhCldRPlBP/G01aAHGfsUgBwvYMWFN+N5dbnOVbaXDnB7n7KRyUaYUUBAvm1fQ7ulQa1j/vBe7evS5kaSHEx8buC7fgqgfBiN43KsPD+Dx7rToDaaimWeAbH0Jnx3d1TSKPvCikAREQTR4SE0sKj6cwO9+Wd
 PJLJdY+Z
 8KPJ9Gs+EIq6BzfJGHoqJRLhnUnNKqGGVUhIjsGEoMP8ezoDodL6wkx3+OkVsdMv5FMcZRCFtGooJ6QyexYryPgsqObAW2vNwYinXnaSAD2wkFL843bBou+AtouNLVed7a/b40e/lTcRXqQogHzuwhHN6r/4Y6In6XZxCDLsTrOLzFr1KNDrWfTW0XtXKboNfPHzykRMgddaFzfwU14CFiAGMb17jOiELUuYximVzICsX1Dtat0b7ho7aYCesAawsorFcWWwGjq4D6kpCGRGOettev9QzKEXqlRTpAUVlwE/X7Ebx5yQOu0w826vUxMuGiFl7nt2/KLTVFlI35Ys9StKfV3Ostc+nM/z9dJFc6+leYvwgQh2kUog5YKh9d1J2yHl9eC69BKxKYaelMaKdp6aHrG5GYG9ae6z6fGAP2LyMFeP3/UCGNppRrOS1hwcws4ZXmftL7Hb6ndk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Sep 2026, at 1:40, Lance Yang wrote:

> Whether a PMD has a deposited PTE page table only depends on whether the
> architecture requires deposits or the VMA is anonymous.
>
> Implement this rule directly in vma_has_deposited_pgtable(), avoiding
> mistaking a non-anonymous raw PFN PMD for one with a deposit and attempting
> to withdraw a page table that was never deposited.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v1 -> v2:
>  - Simplify the pgtable deposit check and rename the helper (per David) - thanks!
>  - https://lore.kernel.org/linux-mm/20260913051942.40889-1-lance.yang@linux.dev
>
>  mm/huge_memory.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
>

LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

