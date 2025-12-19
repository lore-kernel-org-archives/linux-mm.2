Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2F5D78763
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 12:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9036B0088; Fri, 19 Dec 2025 07:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6B96B0089; Fri, 19 Dec 2025 07:20:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DA86B008A; Fri, 19 Dec 2025 07:20:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31AE36B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:20:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC694136829
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:20:53 +0000 (UTC)
X-FDA: 84236129586.08.78E2E11
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012031.outbound.protection.outlook.com [40.107.200.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2B9B16000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:20:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="vEao/xh+";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.31 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766146851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KJIuGsBLGLFteJtVGcFk9sKEQoeG1jtq6h3GPq/ygA=;
	b=qLuJl7wvhoV3+eBOZ5Yaiq7W2sebbPQc3DItMyOoj2pGfwcuUiOn4frh/gpriNSDU5c6kb
	wHRwBKNX2a8HuiPIVzPSCHC+L+0V4FXBv32y6Lz/E2DoH80dHh5TosoU4mZpdB1kOSV6hu
	+NMKQO18BM2I7dH2Nyf9m0HEVIVwB+Q=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="vEao/xh+";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.31 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766146851; a=rsa-sha256;
	cv=pass;
	b=u+aWzvaePyqfr2exkvuNbXfSTFv7nhd5QDI7WwwRV/YU314mNesHW2jtphREuYAmFKrXhX
	RMyzQcgtkcTuBIIUzDdwkwo2+Zy665mQTLNCIIey99IQ31tIaCOHtDRbdrrgOhIYzDLu89
	JBDxP1JYqyXZGIWaHra02Wx0eKOYHyQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xwC5AMC3KjQ1fhqr+iDSTnNdvHaWO/fpy4N2dlxMmaSU+F5LG7kUO7sWpIAaw47R0mpf0gIs1aMZLhEAE7e9uF0y65DKlZuBPRi538zJhcrnW37+8P/GxN25oI3ygYStt9Yymuws0s72as8m0ORmHNvE9TvqevtD3n8EKRxbWj1QqR5zZKJqyqLJ4IrrxG2l7crOe6woReppqepEcde+kEqA4zEEYuLxR4Y877PCcCpbq/YdkWWJaP1DMoVtRYwi8twiOj75VODdiJPApdL5BF88E106NmV1A0R8I0RHXA84SXmBVPjhTMGqc+fccoqX4iIZ/t4+FUtK2EdSAb+6hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KJIuGsBLGLFteJtVGcFk9sKEQoeG1jtq6h3GPq/ygA=;
 b=DOT5jcIMwH5OvgMLvuZwWPylVm06c8Z8DNKl7ZKv+ROgDv70yf1cXYiZtnax9POEd3h2tu2/+uBvQx/Clgdc/uDk8Iwfj/YPDioFrhav8mqpwCgbsH4s8UNdaTgpkG4ZJ7kRpXRht9Vw4PooCKBvlFKCF6wUFicKn5w++lmQcezKyIKaOBdwXWkblDPscTJlORYbHi/65rhQGoOIlrQMELVhDtkGbDx7oAzXflf8Vtjq1mR+St0fc2hdeiB9mCVmt7ZTO4dBItqkMoMbJZJ27TCdmpL1b/LKQRZuSAcn/yXrloTxdqlwhY9qp9dZpU4g3AcWhIw6HUVRk3HGUX000g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KJIuGsBLGLFteJtVGcFk9sKEQoeG1jtq6h3GPq/ygA=;
 b=vEao/xh+p/1F3cdZ+aJXX82gLHDRcLxVFoF0XWIHZ50D5sk6Tg4IEySeisfvfMmin5hdMlG1/65y7x2+qPpSPowvIlGGGBEwBV89uyBhdvKr/0XFv7n2HqUYH7+sO104QITKiJYcWBao7QVFUMRXGl6Z3Kc3f+F6RJdhdVeRM5c=
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com (2603:10b6:a03:48d::13)
 by PH7PR12MB7793.namprd12.prod.outlook.com (2603:10b6:510:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Fri, 19 Dec
 2025 12:20:47 +0000
Received: from SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d]) by SJ0PR12MB7458.namprd12.prod.outlook.com
 ([fe80::83e7:e6cf:26ed:2f3d%6]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 12:20:47 +0000
Message-ID: <32f3f9dd-f84c-4113-b356-01750b2af80a@amd.com>
Date: Fri, 19 Dec 2025 17:50:39 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
 <848E8F85-CD24-491C-8A3B-474E4FCBF995@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <848E8F85-CD24-491C-8A3B-474E4FCBF995@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF0000017D.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::48) To SJ0PR12MB7458.namprd12.prod.outlook.com
 (2603:10b6:a03:48d::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR12MB7458:EE_|PH7PR12MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c346b97-a3d6-451e-2600-08de3ef90a27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkFIam8xM2c3WTBVa0MvaDQ1OEtkZEQvWXJqT29DUWcyc2ROQ2JXQUlBVnNH?=
 =?utf-8?B?NEdUQUNmUGJWaDJBbVRrbkFmcG9VWnhrQ29TbVZ5NCtzejB2ZlhxVkpTeUo2?=
 =?utf-8?B?ZGtNYnJ1czBFRjBlMGY0QWEvOFRoei85V2NsRlRRTUFUV1VXRnVQNk9DQytK?=
 =?utf-8?B?bUhjTk4rdTlYWkRCbWpGelJ4YTJiUysvUEp4NXlPUGV0S0lRMmNwT3IxY2N5?=
 =?utf-8?B?TFk1WnBLVDY0MVd5a3FKSGxibmh6eVVHcXdKcmQ4WExiSGdtdmhhSEdLVWd5?=
 =?utf-8?B?Y0JkcEFvQUpJTDh0alpuaEptUm15K2JTT29kN2JnSWd2UDlpNWFoRXRMZlov?=
 =?utf-8?B?OE1LWXN4QXgrRkJHOHhFOEwydnJ2K0RiaVBxSnNka0Y5NW43bkREazh0SE5M?=
 =?utf-8?B?RHg1eXlhZGFxVUhjRE42QXZnbVI3Qzc0NWpuMUVWbDZqWTAzQXZUZlFSS1Yy?=
 =?utf-8?B?TlFFSWJTYUd6akdQODdrYm9TaE51UTFqMHhEbVpTczFBdVVWUUJva3ZqRXhm?=
 =?utf-8?B?d2lBclBKMDNjRFpjQUJFaWpxaVR0MXhrUjZBa2dOQ3ZOREhReGpuSmlNbWx0?=
 =?utf-8?B?S1dvSmtQV1lSWEd6cDZmOEVucGIyaDRlVXZFRjkwanBKU2RZb01yRHg4Y2Jx?=
 =?utf-8?B?SVFZa1laRWU3SFFialQ0ZWpEcFB2YkhhYXBqNFdkclJtbCtBWmF1eTZpVjEz?=
 =?utf-8?B?WFlsVlhLeDlaaHhsWkJEaGRXV2UrRTEwdkVXTVptWHVhQXBvV2V2Z2JzQ3dR?=
 =?utf-8?B?ZU9xWlo3QkhxOXBwMGZhT25LS0N1UnRmYklCQ2Yva0FLcmJ3YWJqZE5jdVds?=
 =?utf-8?B?QWoyNnVhQnZqSHI5QmZpN1hmUDNuUFRGQVZteFU4Q3RqUE1uNS9qblV5Smxl?=
 =?utf-8?B?cUJqUUFoU21qR0Q5MjFyU2tCZEFsckk1WUdQcENXdTFIWlM2RnNXL2o2MU90?=
 =?utf-8?B?Ympqek80RFJXbnVZSUFkQXVmSWJCMmh5aFkxQ0pxbG5pbTJaQkZacVNVSmcr?=
 =?utf-8?B?ZW1mZ1MvZ2tyb3lOSnc5aFgzZjZ1NEVLSm5Bem93Wk1YTWE2ZlJFMklPblh2?=
 =?utf-8?B?TkRLUnZuYmcxQ2tjWVRhOXVUMm9scFlVdFZocW44SkZNaUgyZVNkMFNaTFJh?=
 =?utf-8?B?UDdRbzdNbCt5emsrOXB3THl1cVhaL0kxdURueERoSWN0S1M2NStyWHIxZG4w?=
 =?utf-8?B?c2VxMThPSHZqa2hQeUM0N05EY0loTlpJK3lFbUFRS3NrQjZNbS9neHllRVRD?=
 =?utf-8?B?aCtzcVBjOTZ3OTNhTDg1UGhyK2hJVkhVbHE0aDV5OU9KcEdwanVYTWs2OS9C?=
 =?utf-8?B?bWFCMjZPK1BCTXR2bWlzQTlaV29Mc1FlRzFxb1gzemdvNU9SK0V2NytjNnlU?=
 =?utf-8?B?amluYVI3UzR2QmxqbVBZTkU2WUFtSzhlK01wYUFhczlBb09KOUJzYkFmQUcx?=
 =?utf-8?B?T2llY0w1Q1VXOUxoWk5LMFF2VWw5aDhjSy9sT0V1UnE4S0JvTzVkVVlKSlN1?=
 =?utf-8?B?MmNnMjhQeVRuQzEzS3dzQjdkK3k5S2FjUEJPMnk1TkJKb1o3Sm9Va2hIdWdj?=
 =?utf-8?B?M3J0TnpEZjhHdm9wRzdCc1I4SFBDMXhFWURPc0EwZEk5d3pCei9zTmc4cUlm?=
 =?utf-8?B?Zk5TcU5Mb1lrUy9jSVZBeVlGSStvejdraEVWUUwveHp6bWhpeTdnT0UybzZT?=
 =?utf-8?B?aG1aN3g4dTk1a1NweS8rYnAwMW95aHRUVEw2b2MzaFVRb0pYK29VaEltbFdZ?=
 =?utf-8?B?OUZYTUhiM1ZSWFUyN3NYQjRReVVrZGgvYW1nWDFtTmp3SHhiMXNsaDdmV1RV?=
 =?utf-8?B?RDdFYSticjBFQnVPUGZYSk80bHFES1VGOFJnckR4SWp2Z09RYS9zcGVGMjJv?=
 =?utf-8?B?THNZMyt1RVNJYk1WMmZ5T2dYK3FnVlN0L09IajVXVWNmYTcxdFhRN3hoekt2?=
 =?utf-8?Q?olX01a2E9UVcUfNWeHo6J/9ECsp+1hJS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB7458.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bU5MdzhocGNmK28rUE4rN1Fvc2czc0dHWks4VU5MdnpxM3FYaGtXNzkxaGZ2?=
 =?utf-8?B?dXUrUTBoSnlGUnd2U1FmV2kvTVZYVHladTN2b0NCTGNsRnB2VWI3Y3VhVS9G?=
 =?utf-8?B?U3lZQWtlN2JZOTB0SDc1ZnNjTzIyb0JCYThtNk9uVU5yeDRJR0oxWmNkendy?=
 =?utf-8?B?QlRXTGJqRmNsb2J6d0EvNVZRSlk2MU9aQkpvODlNSDFGS0Z3eVNidnRQMkoz?=
 =?utf-8?B?aENTVkpzNXVwZnBrNnpzOWFtVVljYWNMUnJNRnBrd3djaUF2RHRKb2VySjlW?=
 =?utf-8?B?L3lFNXlGMEUzSFFoVDhVZXNxMDhlZ3dyVXZXdGVmelhIVE5UcXdxRDhXTU8v?=
 =?utf-8?B?aGZYYURtSHkvdHdlSkhEMjFsK2RRZ09hQWJMV3A4Ny9nZUc1MnV4bnc4a2NG?=
 =?utf-8?B?cEgzNjVkL2FFN0cxL3ZablBPZE5kZStvQlg4NFdtdHNFWUpBWFFST2JFeTZi?=
 =?utf-8?B?eW5XZDByVWxVRlpvbGRmS2hUV0RDbFA1UGVaOHlacEFBVDZ5RUI3VmdpTzlx?=
 =?utf-8?B?SGZpQ0RzZ0Irckw1YUcweXFhbTRBWko1dWs2UzZjQ1BRZ3pkV3FwMzEvODNI?=
 =?utf-8?B?V2JOaGEweG9DZlNRNTVDLzlxYk1LbkhBanBSMWV5bzZ5VFBiVkJkWjRJR0tU?=
 =?utf-8?B?WVBGWXlBRkV1Q3lTanIvaWsxQWNlbTl0T1NlWUtjc29nRkluSEMxVUdtSWRr?=
 =?utf-8?B?RUNkdHNLcFMwR2xDNjlTaWZaNmhXSlpLbEhiYjI2amhqODQyOExlcTNqcGJa?=
 =?utf-8?B?MnZkWGFwTnp0RFluVFlHWWI5R3orcW12NGhHVERBRU9hNUtXM3g5d1RuUlBW?=
 =?utf-8?B?enNBZVVKWnY4aU96eXNaNUNVTXFsbklWamlZemlJemFFQ2hhd2txUWJBR0Jt?=
 =?utf-8?B?WnNOYm5pOHRsaHpMbHQvZHBuT01QWUtSV0pCY3VrSmdXVDFaWVkzUjJwS3ZE?=
 =?utf-8?B?Y2tZdXQ0dW9kMUhkQ29oRnFjZjlDTzFtL1BDMjFwM29BTmttdTJ4R05RSXNk?=
 =?utf-8?B?bTZwcTJYd0dOUDFQMFIzUDQ1OWw0ZkwxSlFNcE9aRlQ5T25SdWJqL3RSTDNH?=
 =?utf-8?B?UCtHaEVoL1BXU1RDNzN2QXAwVHJDQW1kaURyMmZjY0NZblNLYWZtZTIySE5j?=
 =?utf-8?B?bzUyS1JXbUZ5bmZVTEZSaE9NYllHNFpMUmErTW1qSWhWL2dzUGR6WWh3NFNl?=
 =?utf-8?B?S05KODlaekVLMGpRTE9YNElRVkQyTmZHN1BLTDV1MXNwaUJaRjJUSG1vOFh1?=
 =?utf-8?B?OWVqV1dJdUVRYnlGYnUvTkpMV1FaUXQyY3JKTHhWaHZIa25wMzg4aFpIMGdQ?=
 =?utf-8?B?cFExV2tINmhhZXY5YVFWSllDYWpkQk1BeVpsa042R0tHTXp3THJFU1lyRU1R?=
 =?utf-8?B?aFFYdG56ZFJ3NU12ZUFBSlVGRndRTzNIdUxWekxZMXFyT3pYZHFqL3ZCYnA4?=
 =?utf-8?B?VnpXK0VHTkxhWVNkTE9HaDVKeU1pL240RFNSa3grRXcrZkY2dVd2MDNPLzc2?=
 =?utf-8?B?anZBRlRzR0xFSHBqRHVkVVFvdTNYbCtiTVRMd3ovcmpTRU1IZ25sMjlmSTJw?=
 =?utf-8?B?TXNaTmNQK3NJRjE0NTFaVG53TTNERkZEcUtjZ3lyVXJQOVNTUVhhemNySDVE?=
 =?utf-8?B?SDZMcjkxWVNjUURGays1SlRVcHdXeTlXN2MvNzNaTUo5aWFucDEyTStIcE93?=
 =?utf-8?B?b1k5TkhOUVM1eDdORk5WY1RoRW1ZVFk2VDFBUW10K0F0MWhsK0JpL3hlK1pJ?=
 =?utf-8?B?dVZTejllcTU0MlBmUDljdi9TV2FST0srVnNoaFZRQ1RyanJ0OVN6TkVlU2tq?=
 =?utf-8?B?ek1nM1dzdGtLVUlWd2I5bDdkdTNzQXovL1FMTnd0YktqR1dkcGRRK2tXMjBF?=
 =?utf-8?B?SGM2cVZseUtRMUllcHNFWlRFL202QkJFN0pTaURxZkdRQ3A0L1BONXpYdmRK?=
 =?utf-8?B?M3U5b1FJMDVES0dRek9mNnkrcG9kVlhqb0tiWkpjZTNnZCtmenFpOHE4a2pK?=
 =?utf-8?B?R1NGWjFCVXovemNlcVh5bkdTaUZNZFVQWXl0QVJ2SFoySUJEb2dMUThkcWZq?=
 =?utf-8?B?ejQ1bWRqS3RBZGtxVDJhQUJiaTF5QW0wTkdUeWJJaGgwRVN2MnNpZHM4ckhp?=
 =?utf-8?Q?ywrNMUe8peq9ftMBjCwDzjv7K?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c346b97-a3d6-451e-2600-08de3ef90a27
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB7458.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 12:20:47.4763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqioaxzJ+ArlDXRcqvpnHCp1eHGGJyeqpA1/T2q8dDviTWqgPcE7/QvyWBFx7Oj/61hRF4SdLZ4Pz4tbaKiyHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7793
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2B9B16000D
X-Stat-Signature: amepb7asp4gzkc81aqm61kjeotr44ohh
X-Rspam-User: 
X-HE-Tag: 1766146850-777391
X-HE-Meta: U2FsdGVkX18yUHaGTuXOoBDQa9Bc8X8SCAmVP26e2fGhosgP8EIWnCxANCA8tTB36xDm6dYAppaDsxnUU/YSz1jx6ndelsw1l2FZbkhD4Xo+S8lrZX//o36ifL51wOno2WxuLeQNd/y737eRSkCx5U59ycRIag4pb7RX2K41a9N7gK6mF8DSdy2DScnZQ2J+Ms5fRobCrHJb/hgLzsSvHcfzdbz3lOSyuaY1zbModnSkdIrgqWNIQwO+SY25mNXd6ZZbH5u4f/MfA6jKJW6DXm9ddETcqCr+qArc0i0/QosXrNyxc1W8uUfySm6PkydRd3pttl4Nq9/OxBxXVhfljgq2v8ZQD8pA1owDRx/e1kbjzDE7CFJRY3GCjtLM8yF7NSPEHWF3JI0D/mFLkeAFOz+QEOkb2h7I5QC2BuPTTAx+gCt4uskOx4E7S/ZCGZbWJw6BgT2WG3Ch6zihjDukpcXcHhtFlSwCmMO4V0TzvtVtv9fcA/8b2unRXoc6vEr+/tukzVsQ2HLhtNbH3RbFXLCV3WhFA+3WllwwNsnB6gctfj4o/DpazjcfyZSlzwh3UC2kfRFDREkQkn0LE8q2mquCZNDJ1WUHKmB/kfafv0JDhSpAE4iRJB6tJ1xgIwyXTlm+C/ErOGDwXn3cdDZPmE4angxLh/K9uCU8eEe9iNSEypLMcIYgwwtLjmj9cOyYon1KZu+htmbzUCmZtH4QCZYHrYbvxXQkhH3/1mMZXpw6byOgS0mQ71ejSWKzdxnYrxyT5slKElqnLbOlGA7/xhGSD0p2ai7Yh6EYR8xadri7URCn3cJQrQVNCYAGtr5qB2bOojgLZomCa5KySVR547nk1K2NMMMh+ia7AffLhn1nDXIb1m2pwe8wk+lEDwQSs+LPf9OTwAyZQ4MYKCIHF08Sy0yojufe94mFk4xhd76XdYwZYqogwUB1ybWhfz/P8WPocX2BcK7ucdyERga
 iDNF8Hhc
 GTwrUcHFnwwdiWxMAdm50RSSs+pWgxskyFtIOpyHRTH2IKlRt5BhhZB9xbALXAyJ3fpkwMT4xX9z10LykyhVDViRXW+IKFyMn+vXlCyGUt/6fqdSygLg/TY98gi7WKLnwAKT4gfgNtmg2Gnf5jRK7PZbBtFbyF2xXQ5awZdy15OxHleSAJi7JGhGtv01s+9q0y4nzr2gMCUQzkxHfTouuYuHuzdcuvPy5eEOUDt7wXp0LXFoSgfg3s/VGay2dWXdFDUX8CNbVtH0Dk/RKH8U0d0+vOxj7xwfYRgpkDKRkOqCN+pdVk9VPUqc0ccBT7/MX6QvjBnYmWGBUoJNJ5yKShUE56dfwJN7KFenByPWbhMdLORMLjFAyG8UGGEEdaBjLjqIi6RAeA8nwrD4+QgUzrNPpff5oYlWZyJftJPpmf1Hr6A67BeE+z3YODewLnGNGYTrSfVNa3PRj/Po=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/16/2025 8:57 PM, Zi Yan wrote:
> On 16 Dec 2025, at 6:11, Shivank Garg wrote:
> 
>> Replace 'goto skip' with actual logic for better code readability.
>>
>> No functional change.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/khugepaged.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
> LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>
> 

Hi Zi,

I noticed that b4 didn't pick up your Reviewed-by tag automatically (possibly because
it was on the same line as "LGTM."). Just thought I'd mention it in case it's helpful,
Since maintainers may be using b4 or similar tools and your tags might occasionally
get missed.

Of course, I'll make sure to add your tag manually when sending v2.

Thanks,
Shivank

