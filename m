Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0035C55822
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D8D6B008A; Mon,  3 Aug 2026 13:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9150B6B0092; Mon,  3 Aug 2026 13:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803CC6B0095; Mon,  3 Aug 2026 13:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0D26B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:55:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B7FD9C075D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:55:49 +0000 (UTC)
X-FDA: 85060711218.06.41E2C86
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	by imf04.hostedemail.com (Postfix) with ESMTP id D342940008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:55:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q6vo5242;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785779747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECbeD0ihyg+EEX6ZY7MvMwOUN7Ib1i4495IFUmM0Qfk=;
	b=5GKiNJieUhqxg2Qgv4uUZ/R8YCLo6JGMOYtvpjkRQE2ZTqgjNy8O6TECtA9v2iIFZNdV5f
	AZ04zLPMKIdkYtTHMlg1C83tEAXQAGMX6ybfMUMN1bBJlt7wvpR7n0GC8FaH/N0a2wCniS
	HtpY3h5jESmUIz37narAAxjh9VgUWEE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q6vo5242;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785779747;
	b=B+zYvMtkcie7Kdx4VAqTC/B7+KBmkZW4YcUKiHNU5SqH97rDoNEMWGSDqFirA6MV/sx+Jf
	U+mtFuWVEuTs5J+ET6sbyT7t3a+6B2D8CTniAtyNisj/P9S0fjUZtQTXmTu6lW4vmEweaE
	2wmcK6t2QSZ7myz24pRIO7MhSsNQ2jQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wg/YwywHnUfx5ROyIPbyctSh5+Q1efGSWBJZz5nfvF54tgLfbaP9ocKmt4ng0rvVP04+TweQX8sgC3ACUKwzOvaWSmcZ3jAe46tSKRUgdMQiE6gYH5Rvxq3/5dr2VzqBYDktNgKpg+BpmXZZWGsXvZQV501452pcQfuyUxOEtOPmQhKqIfHFhZ6jd/36iOp5TkK5HKHgMTGo33oxTz5zUq74ZwYfNPLuIhfFDIs+io5kHmIvQNWyK1qEI/DofVo6PirpmFSZ83V3Zaeydwj00EIIEV6t3nqHhvBD4EoYJMGZ1CW9pDXhPe78hBsjYY+LSNusiKxPPdRRLfIPqgf75g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECbeD0ihyg+EEX6ZY7MvMwOUN7Ib1i4495IFUmM0Qfk=;
 b=r6PZ5VmhPenR04cObJ/C6YD9ZIPmWcs9C+zwULY7jAFnRxL9j0g3pATA9mLXdD3JjFYFkorcR6gPYPNEFkAWyLpOmRn5ojjh+9tM6+5t78387ZeUNaFafSBfl84QoNUGH/k+R7Ji+fcwuVRZMAYb1cwW90GRZJ+hbuImlP1z9NHGlzP7z+U7UySiX+NMo+WgI3iLkl6E/BcJZ1LQkIgk3Dv+UDdI+lt97hk6tfY0DAJ9gB0YDU7iy5jhjHGQRZBXGIYbIshVCKU0rUeDrOL38MDPl5ElI+KgvMJgw8872G3cIwmLq6GZUTqb2uBBCeldBquvuCjoH9v3XWvdmw86Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECbeD0ihyg+EEX6ZY7MvMwOUN7Ib1i4495IFUmM0Qfk=;
 b=Q6vo5242YWSa0BoSfq4/qhzTmPRM5IBa6I4FqV2lKn2bISNBiw5FwbyZOzmnRKq832215PWfc70TyfLmFoKbBKVSQoUOVvJlhzyxYlIbbP3uvCmifz04FSS86pGdz1LnlNL+NB4mgsvGCkEREt9FWRXHZ8QgtVIY6mO22hZvKjKiSgR0cTW5vWlUvpvLWwWsJ/jSvEoQTQ9wpw575/96R1DvY1r1ZyE9+UEDEmSr91wI4Wyyz9iEUKly51xzkKcmqX1m9DNULgDL3LoRxTSlZO5H0BQWGbLUkNsfWONRRBkyJ2tP5hclJH4OtW5hpzOTnxFsWKNmED9lZXr/bVX+uA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB6223.namprd12.prod.outlook.com (2603:10b6:208:3c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 17:55:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 17:55:41 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside
 __folio_split()
Date: Mon, 03 Aug 2026 13:55:38 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <D6EE6133-8B15-438C-8616-4639710F8973@nvidia.com>
In-Reply-To:
 <CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com>
References:
 <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer> <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
 <anCtxQE5hDUH5N6a@lucifer> <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
 <CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:408:e8::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB6223:EE_
X-MS-Office365-Filtering-Correlation-Id: fe8dffd6-f556-4082-bef1-08def1886ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|6133799003|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	y50MYpjHVBKFJSse2+iXkNITZb7rOleEUR95WTejh90pDoj9BM9q+t55zbzdS9VR66CmVBuHFD8GyauQi+pLJMnTT5Wt+IQ5/ckcnHAZ3CsPBnrVx9Aiek8h9mU5o7nFEgWJUtoN/2ECzQBea7S2GqZXMoXCtYrfNP/34xiB2ALrnQ/R3yJKPiZCJinlbII8+HlEwFkjvAQOr1ZbSlwGgKXJ9OnHHdDNjyUESBnqm5EeMAf7kzR3VfrVG0M9FWpbkVlS1EfGJ2QZDamDlv5DG1IdqRSSV7z+m81wq/b5/xi4sqG3O3ryPc1Sn47axjPGe//ukxgMatxz7X89oO6DsZNK9AKcVKZ6+g8eVlxX+w2/S7fF81y3RyXdkQCpKzCS7gLwq/KvZpkYBVzo8qsBN7XXBRc6vdKd7o/kgSvYRo41o3lqrD8JZCwYr66teGrBjNVwHnnjqyeN61+fuHrCliUF7xKmmd1Q/l/s8jDicdf2TveBpgNFCfcii6anlfsj8ZpnWfc90nAVf3jEnJYZkyqzc1e954iaN53QxavMQc82V2vGXXq9gQPc4MudEGXdxfSLEEfYi3+4z8zfS6PygMQ63OvdvFB6iFBUY1lh3Kz6Pm3ySEfiJ/XR+VcHIDiWk/f/IlMsflpeWC413xhDV4vMJv2nemstow2cXUnieOg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(6133799003)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2dJR0tQWTZ2NG8rNVc0Vm1HSjJLNDUrN1lobElTbjdncWdwOGQrcVJHSzRq?=
 =?utf-8?B?YUU1cDZIejhLTThwSDZDOEpOTFArNnJkTmNhUXJ5WFd1cUJVQVhEcGdwRld3?=
 =?utf-8?B?VFZZZVBpQ1BzWlpHRVY0elJwMDFwaENJb1RCM01ZempLTVZ2ZkRoNVJVZEZQ?=
 =?utf-8?B?ckN6MlNXcVcxYWYrc3UvWHRzUDVJRGIvVFZxdEhVOXRJWmd5SkV1OW9aQk5o?=
 =?utf-8?B?eHBBbTk5Z09EdUUxYTJpdW1Ca045R2Zhc29nUDIwckFZV0ljOTNNODd6K25s?=
 =?utf-8?B?RTJpOGsyVXJBWWJnR3NnUStSRkFHT1c0ZUEwUFdRcmF2d1cxVHh5WHZnN1c4?=
 =?utf-8?B?NlVYTnh1UnJZYUFWVnlaOFNtdFBMV0lKREdDMEswdDNPdXJCMThiY05JaU94?=
 =?utf-8?B?QUtOSVJ2bkdYVFl0ZkszM3p4WEJPcVpoNlExNlpvN3I4V3lSVjNWeHhFVFpk?=
 =?utf-8?B?S09qMnZPaWpGNnIwdFk4ZUNZd2c3WHVkL2FMVXR1UnVpK21zdVpibVBuMlVP?=
 =?utf-8?B?S21mT0lmanZwS2YwMytnYjNNNnVoSk5ENDB3RDFMY0tNVFBoL0V5bG9hcnlr?=
 =?utf-8?B?YlBtUlVvSnZpZmFPOGtxNWk2UnFPZGp4TXp3TTJjazNGaFVFYmxyWTYvVkh0?=
 =?utf-8?B?RlcveG90c0pDTk5yd2pDQ1RUQzVUWit4RlZNdjRybHBRZDNsNXYyNmEwTW1i?=
 =?utf-8?B?MmVUeTBRbEt0Y09JTllGYVFZQXZvSGsxTVUxNlN0bXhBYkVzV1JmREQ0U05n?=
 =?utf-8?B?TUUwM2RRY3N6aGFnaHkvbzJ4ZThNeFpYd0p4QS9LbVlQZ3ozUS9XTU93cTJ5?=
 =?utf-8?B?MVJYbjNTVjdDd1NUdmNwQmJuUXVQR0ZYOHZGK2Q1eEg1Y3k5RG1pYU5jQWlR?=
 =?utf-8?B?eUt0QU04NURnVTE5dzM0dHJlT2dadVRUYjVRd3pPblF2YzVRN2NQMFdEcHZC?=
 =?utf-8?B?c0VJVEMrOGpUck9yZmQ3RTVqRWNUYjNQb2t3aWFtUGZ0M0FEemcxRElGRzI3?=
 =?utf-8?B?OG92NU9qek9SYjVlemx3Q0IwcEZnMHhQTlFzcmNvWlZ5MC9PRTkra3BPb0hC?=
 =?utf-8?B?QXFlYzc1S3ZucWE4aEVIL3hLcnRPdmRyL0NrSWhXOHVkNGlJZUFFaHpGV2tE?=
 =?utf-8?B?QmFId3ZZTC95UmZvcWROL1ViTmhRZ0N0bGw0K2xQcExpMzZUemk5WHM5ajRE?=
 =?utf-8?B?Z3IwREtUV2VpSU5PYWN6by9Ca2h2L0lXYmNRaEFwT3c3bEIrNkcrZlpLZFp3?=
 =?utf-8?B?d0dxUUpheGRCL2daeStucFlBT0xxbmZBc0FCKzhhbEhnRTUwZFl3MFRyUWE3?=
 =?utf-8?B?dm44emdFT2ZtOXRkRlZQUnBxcmNMR3VTUUxBV1E2eHJSN2VSUG1QdE9hVDZR?=
 =?utf-8?B?Ym9jYThhSFdwR3F1WFRHRUpKc3BIYTRDTWl6TG4rdnlpK0pHa01jVEJyTzRp?=
 =?utf-8?B?VmJkNmJVTWE4V0pmL0dPY3pVdExzdWpJWWM0MHM1RUZWU0FZMCtYVUZ5bFl0?=
 =?utf-8?B?MnpXdVdXbkNGZ0xlOUc1TW0xd2FPZENIQWZ4TTM4U3hZZm1sMjAwTDVwNEVt?=
 =?utf-8?B?Q01VWTRGNVVBVjdtNUxOU1hLSW1wMW1yR3BEUFZRWVhMa0RZQW1oYWxQbGxW?=
 =?utf-8?B?T2hNM2o0SmZvR09Zd1FTNnAyNWZiWHloTlB4Vm5zMEQwbWxIc0NPZkhKTWZm?=
 =?utf-8?B?bmo3WjhFaEdNR2RlMVVqa2JReFM1OUlnYmlCWHU5YXBBbllKU2ZpSDdOMFlY?=
 =?utf-8?B?aDI3U1BUVWpBYnoyYU9tcEN2Wm42WnJOd1Joa3JOOVA1emxxUzlrS3I2V1I1?=
 =?utf-8?B?RWtwck14a2JOY2czd1YvQzlhWC96WUVDY2lNdVZOWGt4OWlzVE8yNUtSZ2lL?=
 =?utf-8?B?c0tPYWpPa2hYTEh4WnZKZXYyOVF4V0pSYVVyWmdmK1NMVlc4RDJXaDFkWnVy?=
 =?utf-8?B?ekhRd2E2M24vWTM3SmhLS2t5bzZnZEEwSDBUQXRwZFZNRmRYYXlzOXpnOTRY?=
 =?utf-8?B?SCs3ZFlBMDdTTWF4akdndHlNOHV1ZkxTc240ZjdSOGl6L1ZHUjNIZWdDQnk2?=
 =?utf-8?B?UGNoT1V4alhyUENzVERIQ1hXZkppMHdwQ0piY2R4MklTNWNCMEF1L2l3MDQ2?=
 =?utf-8?B?R2lReFlWSTZleGhEeTlDaGpzY0JUTE95MEx5clJubVNMQ0Zsa0RyU2NqbVd6?=
 =?utf-8?B?UDg0d1VKRm5icGxkUC80a1dxakxHb0VjdWdoeVhDSkU2WEZ1VllPYkwzVHRP?=
 =?utf-8?B?MXlpRWpjUlB2am05TG9mbHNlU0pEZDZsanZpUHRkN1ZYUitBd3hnaEo5YWx5?=
 =?utf-8?Q?NZyqIBW9mZGj1YVwaC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8dffd6-f556-4082-bef1-08def1886ef5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 17:55:41.3932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPw/4d0VKZgLJzgzUCbwM6ag/wdSlGX8k/D4IgoWy6gKX52NbP7Y5yfGbhj41X6a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6223
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D342940008
X-Rspam-User: 
X-Stat-Signature: s8a8yx99jhrkag4wau4assn8cm9h3gh5
X-HE-Tag: 1785779746-803330
X-HE-Meta: U2FsdGVkX18LmWXY3arR03d/OdNivPzKM83z0dHvu/SjPV/bngmOKKVNZi+e5NS8lMSWqcPwq6RmVrfYp5cPrXW4vq9LvQ8cSscyQ/YxUc9HMWS14VBmuGIIRO+yJbDNYIhKVjAZZgH2DiTrggomqh0oC8uZ42VnGiMR42RPUFwl7IclISZG5xP1+nIFL4LscQtZ+YaiFK38hubcoH6FCsysHLeAGk2CMm9zDkNS2ZcPEDAM5y5fgYx3EdLiEVNe8IvWVOCNoCbDbOL6NC4f2InWWjE+AeQZGSSOTW16fvjjKRLhQJMgnuU1BwDcIAf/S3lWHyejDsaAFPJV0Tbm4BOb/yi0r+E1wOHxzNSSpN5CJMxwoLQa+XyKn/q3sQs5K8KIxvzyykgrLAcARf9+ii2OCxDVmHKNRtprGwpyQlMwIIUjlCH3btBvAY9Ce+n5/+DEbcx1mAZRcR3+0hqRnFDeWtkn5c5EQ4Mdvml1C8p805Tkw9fvp2/gPBxzTKCPKYbLyBey6/U7aNvB5rGxH4ROIZEMYDCHijMoY1HPy97ZJj/yprUecdWVuGuMnMoNCo1EkehrZZw994aNL6u81NAsMJwF4flN99ZCVNwkdwK11qA06qsHykhlKyK05KRV5phs/L12f8D7Fc3qR1N0o4ivLPrrzQ8cCZTjcD/fOKWgEMVQ3Xvjm2YmZ2b9twZYo3VN22vpW2QruaaS1BzEY+Pmk/cS1suVJ/msKulQJ/XZtNuB+wTFEPHBZ8MGkpMU/fKE6jpwRtM3dCuIKDMPgN+v3tLFXu0u61tgOQP5Mx9U7a0W5T0kgWpvsjMlqblMk6B9Qg+x68r0MyZCepKlzmv0bCgWr5ja1giPyJ6xmjOO/iO0vIoOE1DV7hAEd6vQB3KvpyTw2GzSCsP2ExS1Ln2UxAvypRJhq/EWtRjGPwXlZHtBo6jUOfVa/q3RfouBl74Mik0rybWSOFI0wzx
 efLwLa4f
 4q6h/5Ag2dA0UVbRiv0FJ7p6JnA2QULhvcJwPoS/8esYIFUHd8H92JhpvlPYBT+FMdtfh+RJJUDa5rHWHP1BiOj32skcAu0xz/93zrlKL5wQFKqskB2D4RbPQppph1YU1RpvXUkM4zvp7C/7aBAUju2eeyk4L7aMH4ggL7ffTebdQ8/jhFqvAKdLQsdRypeE1kPYhVL7SeGdB1rhxfcidn5PJ7XLRVqDUH9hW5czL5Sd++4Wz5C2kIGTavla4ixr3gDE2tCY4FjkwngujlvLPtGdyhuiV4lnGBQz1OJeA6kL6C1cPDrzi8LLTRoI76+64vJG2ti3Z8b7uoDdZbKkjbcRiRoxHfnAtiMvTGH2ha2WPrZbfM7UXB8iQkV2A2sFWDueW74wgdCGKwxzeQ7nS88O2Mulhk5prK5emfRd6sBnsQAZzVKlZy2fke9WsZmwn+2uJwztQ/8XtgbiujxEg38CLRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Aug 2026, at 13:25, Kairui Song wrote:

> On Tue, Aug 4, 2026 at 12:53 AM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On Mon Aug 3, 2026 at 11:07 AM EDT, Lorenzo Stoakes (ARM) wrote:
>>> No __folio_split().
>>>
>>> Comment about cleanup.h really was the whole pattern of goto xxx for various
>>> levels of unwinding things.
>>>
>>> But really I mean the folio splitting code in general, there's a lot of
>>> massive-complicated-functions with a million things going on at once,
>>> __folio_freeze_and_split_unmapped() is another.
>>>
>>> Feels like we should really have this stuff in something like mm/folio.c anyway
>>> too now that's renamed :)
>>>
>>
>> I agree that __folio_split() is handling multiple cases, anon, shmem,
>> pagecache, all together. Do you prefer:
>>
>> 1. split __folio_split() to handle each case in a separate function with
>> some code duplication, like xarray for pagecache and shmem,
>> freeze/unfreeze folio for all;
>
> Hi all,
>
> Do you like a __folio_freeze_split_unmap /
> __folio_freeze_split_unmap_file split? :),  I'm asking this as I'm
> currently trying to sort up the mess about swap cache in huge_memory.c
> and found it will be much cleaner if we move file related code into
> __folio_freeze_split_unmap_file, and let __folio_freeze_split_unmap
> handle anon and swap cache, and then saw the discussion here. (A bit

Sounds good to me.
Maybe s/__folio_freeze_split_unmap/__folio_freeze_split_unmap_anon/
to be specific? I assume shmem is handled in file part, since you said
below shmem in swapcache is not worth the support.

> more detail on this, I think we ca just assume we just don't need or
> want shmem swapcache split, because shmem swap cache is meant to be an
> intermediate state during IO, and shmem drops swap cache once IO
> compete, and hybrid half-tmpfs-half-swap state is really ugly and
> should be avoided competely, swap cache lookup is still fine for shmem
> just make sure the folio is not in shmem's mapping).

The reason looks good to me. Can you remove the shmem in swapcache TODO
and firmly say shmem in swapcache is not supported due to the above reason
when you split the code?

>
> LOC seems lower with the split and swap part cleaned, they really
> don't share much logic anyway, except for a for loop for putting the
> splitted folio back to filemapping / swap cache, and a folio freeze
> check.
>
> And after doing that, for swap, splitting clean swap cache and
> splitting swap cache to higher order are easily supported, a few ugly
> checks are gone, we can't do that now partly because the code there is
> really complex.

Looking forward to your patches. :)


Best Regards,
Yan, Zi

