Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 334A9C982FD
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1EB6B00A4; Mon, 21 Sep 2026 22:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9C56B00A5; Mon, 21 Sep 2026 22:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9CF6B00A9; Mon, 21 Sep 2026 22:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4D596B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:26:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D2DE80359
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:26:47 +0000 (UTC)
X-FDA: 85239810054.17.2AE9A6B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012048.outbound.protection.outlook.com [40.107.209.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 682F940002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:26:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ge6tW47h;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790044004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJ/vdy9uGmQLcel9fYnGf8Ws3cx6xUjgkhPvSdYb01Q=;
	b=QXtXwzv5sFuFt9j3J4UI+mmxJVG1WfRVdcx81jYC772WEzAVbdqvLeGA6dmuVJuBU/emQi
	98hchlKjvn+zUtLPv3rbkEgKXA7uszxOeEqrHsvBCVa+lJ6mK2OC+aVKGMUAEGY2XavKPD
	K31PEOiN64XVFYk0jcXCfU+F5jwbj0M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790044004;
	b=pfbWhb9fnS1plf+v5SwvqSjbygxNwsBPlzr3cQ2thchQUHj2LG9XLrFJxZpBZB656haRUy
	aTmwscZzi8r36VWs8awKhrJmLoswP3cLpUWNNAD3fuoQRjKlELxNYF5w88y9g+HHgNFSK1
	SIz9tCW8hTC9oWB1RqctVnv/4tBuYIc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ge6tW47h;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MTLtRm17MmkyAaS7h1mnx6yHNOIZT1ZQ9aPQvsat2nWNY/HTbX4nvG8/VRXUZtn1OGMxqlXrU9JGyUIZjAgYRNUf0TlBYfCYtVQfMamp+RP9HQa5dc9NTruYD1IaTwe6qt30fkK8ZKk5TAzZ7dNRHM2tUXCohQ1BJbhr5lKaFJyNK5pOSEBJU7s7uxDm53YMh5axXEwyJ+pNwGmzDOgqNBOFvGAYUA26Ss5Dh4OLTT8rhLs5tW7VTS7BiaLcn1bUPLs82Kf7L8/mm6l8lsRo8RSsmFoos9+Qq7u69W/IQg1tqii20pY4W9ISd6B7UQ29hhOgNdXFxyl38ZYS98vYrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJ/vdy9uGmQLcel9fYnGf8Ws3cx6xUjgkhPvSdYb01Q=;
 b=nprUf1Nrl08tVE7ay40fitvov6aB4AXpeRWLqIOndDZ0HzffTHuAEcAmsp9Q16xGhR0B01BuBMBS4PbkAiZ/L/ZC5Ds0jrIWsE6YSEsXfuN/RSGZqqQwYfvUyRwG97+DMzB/bOQYeCjP/azW5LZIwZgPa6kociMpvy2mC0eA2DJYayhUuUvc/CyMyb/lghrcmwn5zFRlTei0Qs1E+jrj7DmLc+ctmQ+GTlqchK26cGm5QvWBjNCOPze94aqzK9sSRqjvJXKkPR607BGRIabB8aBWd4cMAq4evEyzdtrJK2wc55AWggvs19B3NpmtHKopk1QD0hntwuBxYSwmh/VRPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJ/vdy9uGmQLcel9fYnGf8Ws3cx6xUjgkhPvSdYb01Q=;
 b=Ge6tW47hJhx6uODA8aasku963FE99MCfIOpkA+op2iO517fKucHi8PDm96jWZYaE9havl++EaxL+QtDH1WCPnORwP9cin2Hh1EBJIUDjjkKW+95PA8L220LLm7cN8vJQ5wCD/Tu5RrazB0+CqUl9w+gO24YVbF5qGl7n+6g/QTzZK/8KeMOTL7a+Kx3RpxIAhHr5/3mS7HRMVDkaNpDwisb07l7ErR2WdfUtLP8k09ksD7tAoVEbEoyurxcJqYRi1h1YnKdZvnpwKzwrXAXUjgI4EtuWHfXk4DLPUVP/zJwXMj5yklywNNyHC80OlYBNDK4LcgPIKOfxYFtKf2TVjQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7413.namprd12.prod.outlook.com (2603:10b6:930:5f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 02:26:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 02:26:36 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 22:26:34 -0400
Message-Id: <DLLHMYHNE9HU.ED6S3JI0KPF@nvidia.com>
Subject: Re: [PATCH v8 12/14] treewide: introduce arch_has_pmd_leaves()
Cc: <corbet@lwn.net>, <tsbogend@alpha.franken.de>, <maddy@linux.ibm.com>,
 <mpe@ellerman.id.au>, <agordeev@linux.ibm.com>,
 <gerald.schaefer@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
 <x86@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
 <hughd@google.com>, <dave.hansen@linux.intel.com>, <djbw@kernel.org>,
 <vishal.l.verma@intel.com>, <dave.jiang@intel.com>,
 <akpm@linux-foundation.org>, <yintirui@huawei.com>, <dev.jain@arm.com>,
 <usama.arif@linux.dev>
To: "Luiz Capitulino" <luizcap@redhat.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <cover.1789695931.git.luizcap@redhat.com>
 <50af0b07cbb36e911ecd1f90698bfebcdaa8a390.1789695931.git.luizcap@redhat.com>
In-Reply-To: <50af0b07cbb36e911ecd1f90698bfebcdaa8a390.1789695931.git.luizcap@redhat.com>
X-ClientProxiedBy: YQZPR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 35f296df-a928-4645-8c1c-08df1850ed2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|22082099003|18002099003|11063799006|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cm5lgEO64RrFVTx6R/Z8nm6LJuRnYb8b2/JNqveoDRucOmZdqDdF4AxQ55EfHitUUBYOKENLvIAF/bJuifvI48h3V0Jz8cmzuO/9kWVlPKLbtTANaBye5vDLYOVxq+IlUp6iHIC29Oq+MKNM12XBBjuYAVowE5lPJhS2W0UIxTCIaMoLg73edt21GWqZEDj79DJn0v6dLMfMaJb+pnEYyhqDtk4EUINTvM7fHzIK+fRbrVUbGpXngMWh9TF5oL/yEBHeezTIU254WK3Q9jDqnb6yX07CL+7hACWyrAf8LNPrRhOHdKtJTcynIaAIiiZ08BfqZeKt9SaftTpvXcUOJ+tVQon7Wa2W1cPc7PyvkGr376gwZnp2QWBDHl52KXDupx1180ux670Wgi+DZjY65lkzttoMJcooiICtkrEEmYYFNpxGMe2mKipntsbPHTupBnaxqq8OiVGsdIh3Vy8Ld4sBNmF9fl8qQG0hXD6uw20fLln51oeRZHjsaNkba1Tl1xaW2eU5RbBoRJ6SLwrYJJSmu8Tpqi200/lUzlTOW99Mxv89/b9u96/m6TONCKfY/52IpDv0huecmQVnGPKzSIK5fmAUBhEt/LwGceG19/A1HDk62k/buxMsSGSpwzM1RrIjOAf4ghgE23gJ0BMiUd5YXbAF8ClVbzDzANLBlEs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEtHNk9LRkYwRGFYR3BmZzlISjZCWWVORiswWGFuQmo4UXllYkJyQXhQcjlS?=
 =?utf-8?B?RllyTHJQZmpvTnJBTk5wZjBWTjAzK0F6aVhyeGNEeTlqc1JUcVFpTU1aL3pY?=
 =?utf-8?B?Yk1MaFFCcEFHdDhUWUNZKzN5Q3JZcG9KdkM0d2J4MURYK2pydUJScm9ySGwy?=
 =?utf-8?B?cGt3UThUNTZXTnVNRmorMzdRaDUwd2tQUE9RMXZybG15d2Ira0NQZEN6dDB1?=
 =?utf-8?B?Z1NIbUdibEczRGdncTdlQ0VlU1lSaUFYbC9qREVpVFFxK25nbm1HMHpDYURw?=
 =?utf-8?B?NGUxa0xkYXl1RlIyRVZOK0tYZit6QUFRbk0ydHNPUHp5MGJaRWJmekRRandi?=
 =?utf-8?B?MmpjS2dqL3pZT1hBaUp6UVU5MjcvbkIybkUvVE8xMktoWWVsZWVMMEtyZnZV?=
 =?utf-8?B?NFBiaGtKTGxHSUtxL0ljbm9MaGdkMmt5OVNaRkZvS2pZcXFXbXRCTmpmM2JT?=
 =?utf-8?B?Njc2VDlhVTZZS0lIeTVGMnRCVklZdGRPU0pqbXZZQ1Y5NkRDTi9FVm51OWFP?=
 =?utf-8?B?TlQyOHVsb1MzNFJwcGkyVTJpeVE0ZFhXbjhrbU1KVFMyZGo4dXVKenNocUp3?=
 =?utf-8?B?ZTY2a050azdjQTJocHZRMDFGQ3k2TG8zZGx5RnRoaFJLbE9JT1BobnZ2SXN4?=
 =?utf-8?B?Znc0Q1kyazMzQ0pDbnpYMThBdjdaQWw0OEJvNWpvUlBGdWVHb3FJVXp3Rkd6?=
 =?utf-8?B?SUZxMGx3Q1lvZnlOTjFNSnRJa0ozMmZLRkFSSnF0TG1uRzdPcVBxRXBzTnZH?=
 =?utf-8?B?c1dvZTVieHV6dHgyMVJYdE5zZ2VvQytzak04alprcGZwbzhmMjdkVDVBL1Fa?=
 =?utf-8?B?SnFNVkw2RUlGMlo1MHpoeWNUeXhSSmZJNVRjNHlLUVM0T0JCajlMQ2YvR1VX?=
 =?utf-8?B?THhvQklHZ0srNUd3SGpSSmZKb3pVM3FHT3V5bU9hUnUvcXdjaytOTXpTRVFL?=
 =?utf-8?B?bzU0OXgvOWNML0pWZkJsS3o5S3VKRTVjMS81NHRQOHljcHpZdW0vTDAyV0Fw?=
 =?utf-8?B?NjhEVzRIK1g5Wk1IeDZGT3R2SWR5dWhXOVdXSzAvdlc4TkNwM3RlRnZEU21p?=
 =?utf-8?B?aXl3RlpMZVBxMThHNzhnUGV6YlZEZW9Od0NUWVFkRFRGUmhPMnNnWGFDYjZj?=
 =?utf-8?B?RTQ2aENialdQTlg0dWh0Z1Y2cDJhV2Rid0RTR1JheS9zSFcwbWhQWlFiV2NQ?=
 =?utf-8?B?dS9tV2pCdHhVTXAyNVhQTWloVTQvR2FxVk1NQVk1Z3JlVERzK29CQUFKWE5Z?=
 =?utf-8?B?UnJ0TWFxWjhFZkNQdnRkRys5b3RVOVBsTHdZZVdwaUg5WjllRC91aFRpWmVi?=
 =?utf-8?B?VDlPN2RLeStPemF0UHVsc1drR0FtcU9LS2pKRjRHNG1CWEE0Z09hd2ZodWFK?=
 =?utf-8?B?WTNHbS9LQzVTc3NWWWhoVXRjVTUrY05NNUc2Tm9KcHVBR3AxUjl6d0VQSEdO?=
 =?utf-8?B?ZzdQeFJFd2FIdXdYZUdFYXJPTGs4ajNYWFFNTE9FUWpZbzdNcVpwbk12RVZ3?=
 =?utf-8?B?dGlJTzY4RGxvdHdLRFovUHZYSFRRL2lCM1g1azlBMHRZTW1rR1NNWktzUWw0?=
 =?utf-8?B?MjUwb2xSOGFOM1kyZm1MVGVmbVlYQlpqN0w4UFV0U3BGaytDODBxL1ZEaUxV?=
 =?utf-8?B?b3R5TkhPK1dMcDhUZlNMQ0txbnVVc3Z6ckdNMVBtTStyWUhlUENJZnllc2dv?=
 =?utf-8?B?c3VpR1FVemUraS9KSW1QUlJSL2FvcmNjNjV0VW84VVJySjRMWkRZZlBRMlFk?=
 =?utf-8?B?ZDVsWE9pSTJlcVN5eVBkUFpVcGRFYVQ2ZzNaSmlUbndhTkpjOXlGTzNBRDJz?=
 =?utf-8?B?OEFJVWdLZGZpMFIrcWJQam5RN1VjUERJT3ZpUyt3Y08vQ2ZOT0FIUVN0WU9K?=
 =?utf-8?B?ZzNCNVgwMUVKdWJHUkpuWU05VVdJOGdZbnhrSnh4bE4wUHd5QVpuY3JwRzNu?=
 =?utf-8?B?cHJaRGdIN1diWGNtQzBIbjZWbUJiaWREOUl4SEFXVUJWNFZZbHVWSTh5RHhz?=
 =?utf-8?B?dkdWVUNHQU1KeUN0ekZOVU8wY0xXc3Bsd0ZKNkUrL2Y3alRyS0w4MDVBbytL?=
 =?utf-8?B?RzROczJXVis0TFlySFpucm90Ykd5bHNWT20zWFgxS2EvYlUrSFR4K21YLzNY?=
 =?utf-8?B?RWtSSGdEa0pmekpqVGZWcjZvL2pWcjdhWWt3UGdiSjdYbHhMb1VBdTRxNnM1?=
 =?utf-8?B?dFNBZnRMRjlwaDVoMFNEb1FlWE9Sd2h4S2NsS2Uvd2haR0NYdUJsUnc2Smpm?=
 =?utf-8?B?dmxKR0N4Rk4zNGRHWXB3T2FMckR2RlNSNXBlR2RoRlpLQWNIUWdCUTVKVzF5?=
 =?utf-8?Q?AljuuEiZCDRdM+nY1t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f296df-a928-4645-8c1c-08df1850ed2e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 02:26:36.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WohOSJYWG3C8ipn+khlnfk4FK+ZyYTRQgsi6xKQEevOx3EQJKxZNVcqDZhia/9CN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7413
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 682F940002
X-Stat-Signature: x5fw4e736c3cwshqd5dksnz5e9i7zoh8
X-Rspam-User: 
X-HE-Tag: 1790044004-409533
X-HE-Meta: U2FsdGVkX1/oLmBSzccoxoQhoRqdVUWa7nxJovyFAUVJh9YfcmYbHLx4U3Xv3uHHitl1nC5dMyUPhWTypLcnOy7Yyq8XI3Uvd+EH4IGJmpatbqQ0vSZH7E/Yu0znYoTsbLGE4yjLMUsjzn0ZgleHmAuWQ5mvm9B2bBu9FF8Py68w7WfFWiPY0EHtND+m3L+moMCuUO/DaEI3/QL5fLn9FCjLn4iHw07vgXdPFAje6qHvjpBudM6lpXxPp5rjlsn+RVEjvBX2zz5OrlME+TbASY60FcgFK+z+bMDGlYhCr2WQbK6ioX9/QEe62Hfai/qcZR8XD2yTPKLpNxkYG24wCYitZuw1uctm75GYCdcTkgmZfwL9kcTYA5t4nbB7mJ7vBTT7TB0yD344A8BeXpWFyTivmv6C7CJa4kDoZv/r4T12RPw1HfHRxQtW+xy9vHh09WHAEUd3UvWcK30AiMi9Fre+SgJRzWYiiCQRG8vzfzJAqQlh0+x3w5Nlgq2MvGgMSczY8roc992uCYiLqKAEucJoQ4DWc+8Xqk6jMuHG11Y6jaTlnCf74o8FZ6HEyfhXmWOXfSV+U/JE/DdcUG9b0cyBDOfczx6WWSvUPZVlVCsjxgpT481WgPVBh53qbusvjPT+Iy93MRU+II111f5SCH1sGC1W7cfVH67wtQWYaNhWl8UgHuG/M8oVhxMscIoJq3rMH25l4Nvdd2pFz0sSCPqHDTzZkXdSKQZlxyctVM99iguRgJr+xVQ0tQKmDb3fgYHeyLdr1wJ5ICAE8/s3DJXqso6KxbReI8e6hDq6/0HAuc5KZr8qjhDxhl08GO7V67efJWtE61E3raF3c25N0wrU5PDRLwfQgu8zdYI/PIpqFNQZNc+hhIpQ0JW1Mit6oP4an+ZIsxJVeFtsJ1Qyg9pMhqwtv3qdgQaBrxbrAX7PBoGz5TgSdPt3y/vchyDo7SvW8iwyS9do8YldFoO
 GS5+YdJu
 33Qmlttpvg68hC7EFWoXMbTXQ0+vNjil5biJ8Z2uaXJotqemDpyno0kD+r/LhUd6LSjm4RUxXAjmTpL0omkLEKzWAgS7USckBrGekw5iZBdtyibeGl6+wgrHCfNyjPfcJVx7J+X/X+OFt4SUA9RB3rlNY0ypA93WdigHwKdMZxIt3XmSekuoqoFwOyC4UaBDFg2W1ISPgccIn9ZeDRNlqUtREuoRgiaQN+wb7ReFqTdEYG23ragjeFLcJu4Zlm730x4rUh25omy6BhzGYV5s/j0u3h+OvYo0OsYSup6Ix1uAqehd+yniU1t+vLHLTD997v7lX8h5qTerH+QYRAUSFtbAnWM2faJJVHeOMbGCLIqDMh/TTaDmIgPPVWcSOVeFKv57DOWBLSxLGEAAuuzYdSkfHy5dKzzsOoqGt1RWrDR3in03Vkg5qoThQKMaUNYQO+XVO4URdowAs8kDuyIJflQJvYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 9:45 PM EDT, Luiz Capitulino wrote:
> Now that all the has_transparent_hugepage() callers have been converted
> to pgtable_has_pmd_leaves(), this commit does two things:
>
> 1. Rename has_transparent_hugepage() arch implementations to
>    arch_has_pmd_leaves(), since that's what the helper checks for
>
> 2. Introduce the default implementation of arch_has_pmd_leaves() as
>    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE). This means that if
>    the arch doesn't implement arch_has_pmd_leaves() we default to checkin=
g
>    CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE as a way to determine if
>    PMD-sized pages are supported
>
> Note that arch_has_pmd_leaves() is supposed to be called only by
> pgtable_leaf_support_init(). The remaining exception is hugepage_init()
> which will be converted in a future commit.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  arch/mips/include/asm/pgtable.h               |  4 ++--
>  arch/mips/mm/pgtable.c                        |  6 +++---
>  arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>  arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>  arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>  arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>  arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>  arch/s390/include/asm/pgtable.h               |  4 ++--
>  arch/x86/include/asm/pgtable.h                |  4 ++--
>  include/linux/pgtable.h                       |  4 ++--
>  mm/huge_memory.c                              |  2 +-
>  mm/memory.c                                   |  2 +-
>  12 files changed, 23 insertions(+), 23 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


