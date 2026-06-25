Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD883CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:28:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB136B00D8; Thu, 25 Jun 2026 15:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C856B00DA; Thu, 25 Jun 2026 15:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C5D6B00DB; Thu, 25 Jun 2026 15:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20DCB6B00D8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:28:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84AC58CC24
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:28:07 +0000 (UTC)
X-FDA: 84919420614.11.7A330AF
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id BAC40C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:28:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oxbfiH1/";
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782415684;
	b=3mectNeCmbMQ1naXxDwAjgG7YsEa3Bk8snSTWbxeUZii5VbJ2kf8g2NLDab0fJVuT2jlf5
	DwsnK3sGP502v+7WLqtqaRKN0jQXzoGRRVRrCRz31dupqbc0QHMpChUQhev+6mTcEgaJtX
	L8d64cpRY2J9Nmmf3kdvyGm+ZDX3Igc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782415684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6w9rw1KRdnQP/6lGbLWWy3lZC+x2MCcYY8CmAO6tW8=;
	b=vVigBZ6I3UFU2veZtC9O9wo9HJu8wVy/WYEgm9dBZYZScGMGxXFbQvT8hwTdxhnY5s5yid
	CqN7/olZMFyMB8L7QoXectT0RMzsLRsvIkbXQPevx+SLBPQTAA0IB6pOPJVVTdTznerYxo
	fMe32z3dIm6LLH6bXk7YblvXMvJV7H4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="oxbfiH1/";
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0peyKxsyDiwwGj3sDFCUmdjMU9CtNiK/d2M77JWXMtD/tvJH/EgkWBAWj2XU5onYbreRTOs9+1ErZhWkoOae/5cyoc6/esdFEsK5y6hXsJTMQXEqSP2XkXEo/g6xjFxiw3w9duJCmXtu6Itm/lZ+ro8nYQ7WXQe2R+jqLvOyWqYR8qekssaNlYG/X0fufHRUznuSRvzcoRiI8b9uUTkyzw3j+Ux60fe/8hI2QflrAQIpe8urPySzOFS3cqUobnGcqNwoteH6fxIc5ouGdA5giKRX+7t9JzbhvckW10ue2pICUjt/mAgy6ocFI7qi8WX532vx7IMkbXVVuYDmumHtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6w9rw1KRdnQP/6lGbLWWy3lZC+x2MCcYY8CmAO6tW8=;
 b=XVcLXfrasuNNB5fEqufrFUfA1BzJyIWstsQzgEQUJR3CaqLbbGkQnNFww7YnS4aJ9Pnhow2PScnEEnDu/evn9ERT0/L1DgrDIBUVyp50mtLSumT49Prf/kzgOOnxBE4X2gUpceBLo7kdcYhnto+9HeXAyZI/ksda/WRFLpwCaOBPQKXN44sgcr10US5ultGJ3V9f4XwaBg+mC3tEgg65Zl1x0PS/dTSHrLcNApEk0MMSdhOmFqV5AHFQu0w5jdzhwS00kT6sgnvRn+V+1BincPyzVqNP80QZwLekWMkFlszv4cEr0qMdVeIxWqgXewdwSGMsta4EhJxe6ORjG2ttDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6w9rw1KRdnQP/6lGbLWWy3lZC+x2MCcYY8CmAO6tW8=;
 b=oxbfiH1/vmR3oKBq02b5LkTHa5G4Fe1rCRs6kSMM7zvQhUzvXYI+MRDR1LDTRoMwkzIKlv8mOmmCEgYmWgnIffsMPb8C/tsSo1ozT+YaJ4ANPmv1criRuXOFiE0bMPBW1wYkrBo897ez8FoVtvLXWXQQfqJD8LCI7A18FQ5T8qSLrEUf67S1FSr6RhaSwwkdGe51Pw/f6V7BRnI5H4UL6h9nNO4UuZEwBLEL27VsbEIDqpIu/DbVFwgETNC2RjlyO2BmaAs08XSJ9rMHD815Q7Qj2EV79DM8UCCyWSoHaudna/YdOYGZhyJW72amRXoIgkcZ5SIQQs+u7ihZ3LzRoQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5781.namprd12.prod.outlook.com (2603:10b6:510:1d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.12; Thu, 25 Jun
 2026 19:27:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 19:27:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 15:27:57 -0400
Message-Id: <DJIDMIBR7QP0.14KBT460GECAV@nvidia.com>
Subject: Re: [PATCH v11 2/4] mm/page_owner: add NUMA node filter
Cc: <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <jackmanb@google.com>, <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-3-zhen.ni@easystack.cn>
In-Reply-To: <20260625043101.338794-3-zhen.ni@easystack.cn>
X-ClientProxiedBy: YQZPR01CA0186.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5781:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe86651-0b56-4d7b-38a0-08ded2efdda5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|22082099003|3023799007|11063799006|4143699003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	bhXUqzAbQv90CAySvee0p0NYxtv5ybIK7jpleA4PY0mjbAFYgOSuUz1fLT+GErtX47IltTpd4g6A46fbOH/NemlpNVN6tlGowVOByKGz1Ah8RaZo92LeSzj+LzwFGKGn7KRQ9D79t+4GMUCRRlIT45kCQy3WjHLiw6kHj/z7WAbEkVDwNIgunaCia5G693rT0GW5rn3hSjzD2nWfBVro+s2MxpJ90rFPEcTgpVkCp6lU8a02s9TTVaEl5x36hAtbjv8R6cplklLZiKlWBIfBL2MZ4tJ4eITJyPEcN6hQY6R9ur3YEPyB6b2VjcydbsNwnen66FVto6rDtLwSNvvmaGmecDme3ZMV+jbaWyHZP/bYv9tIpRwa6XpQdzhH0zaT3i1Oy6skW8cmuhrn9nOkasJQnMrF/AP5Dm9ZPeiogqSiCu/H51LuWRn5h6WYmkHI7WgfAt88O0WFz6qvwVc20ZOge928QfPg/C+aBhYRxMeBVe0x8XlVhLtxSAvmAeBqfGh2cBHhJxyP3bLF859RvL5avgtES1n/o5+g3ARmeGsGOc59bSG+4uX6yLbUI4shfmBWLWfa+oBSJtQBWBeRoZgNVZ2tneVxAz+nH4ZrCJA9a41Je1wgf8T9vdlx+7ybQPQElBxJkVc+gFWzZz1XiLCKb1sHKuQEQxPl+Nc1s64=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(22082099003)(3023799007)(11063799006)(4143699003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1p6K3A5YXJmaFRzMnFrRHlMbUZSdStBM3JvdzRYdG9WS3lVN2ZmdTdWNld1?=
 =?utf-8?B?Y3RBQ1krc0k1RGVUdjZtZmhJbzlIOEg3VlRIakcycytFUnpvWHE4UlBDd3hU?=
 =?utf-8?B?V1RaTVVYTlQ4ZnVVcDk4c0puQU1RT3licUFuZzBCZjlnZTNoYkdobHdmQjZ4?=
 =?utf-8?B?K3hjbExZSWNJMHpsT095OFpoVHp3RU80aU5qc3AzSUZ1emE5djdLQm5TU1U2?=
 =?utf-8?B?ZUpHVDZrM0VEQW9BNWZFUUZpeFhBYndRUW5NZjBickxxaGhUMTEyMnpya2x6?=
 =?utf-8?B?ZzdVZy82endxNmg5bjViTUkrQ0RmNk4vNmdoOXdvUEJnR1R6QjRlK0JxSmx5?=
 =?utf-8?B?Y0t3ZStlemdDdE91Z2VtZk1JM2FwaEZNU2UzTzN4NVMrZ2plcCtDK2lrSm5T?=
 =?utf-8?B?dlZjMnRaTndNdWxMaEJrZnNoMURaalNmWlp4bk5QTDJMcFlPcFZzbzFsaS9o?=
 =?utf-8?B?Mkx1Mlluckg1OVI0T2wxUFR0ajc0dkV5RlpieFdCQU5YUkQvTGRTSTh5YUlJ?=
 =?utf-8?B?Z1VsU0Y4SFRaMXUrU0FkYzdRaSs1N25qb1kzU2JwaGhkeDRxVTQyRGhQZUx4?=
 =?utf-8?B?Y29kL1ZtOFF3RkE4T0RSSEVnK1hpRkg5RkovcVkzTTdIeWFNT3V3RnlaaGZi?=
 =?utf-8?B?V2dCUXROb1lQYWdjc2xiVTh6REM5VWhXSGZEaU8xcW9VRnVHMWpkS1hLckVj?=
 =?utf-8?B?QWRuM3d3QlZCR0lmbjlwTVRTR0QvZmloWFlzTVpqUXZ2T2Nqdk1iNUo5Nnor?=
 =?utf-8?B?d0E3RWdnVFRFNjZWcDhFemhqVU9MdWtBU2FUQXluT0p4Y2kzbHlucDh5T3dh?=
 =?utf-8?B?V0p2Zjg2ajhhZk42dEVXcEN4V0gwWk9VdHJEeVhLRGlJYnYzbVJDY2QzVk5L?=
 =?utf-8?B?TUNYalBIb2xSL2l1bVJCMitDQ2loVFNDS0dCUTRyZGlCYklsd0VQSW1QdXd3?=
 =?utf-8?B?NmovRkdId1phSGFOZ3dMWnFPalJPTFBLY2ppWEtRbmt5RXlhNmZuSEZHWHQ0?=
 =?utf-8?B?WEhobEVETFhqRkU4Nm1iNHZpU09xeldrWDMrSVV3TXF1VlNqb1djR00ycHF4?=
 =?utf-8?B?cVNnSWF0ZlpZN05CRTlGbkR2Mk9LTHRzdE5aWC9lOUlMTzNld1Q2SkxnQ05L?=
 =?utf-8?B?c05RNS9ZUldDSlFQTE1tSHZGTTRJYm9RL3lhcm5FMzFRQjBHVmhPbkhJSVZr?=
 =?utf-8?B?cEtiTWVrWDhuRUtacFlZVWFjakV0bmhBTTBPWG92MHoydXhxbDJTSU53QVps?=
 =?utf-8?B?MENFZFZxZWp2SjNodnZRbW5oeEhtbDNLM0pEbUNySG10dk9pOHZtVUc0QWd2?=
 =?utf-8?B?cXNrbG5zT3I3ektlQ0cyUVc0VW1xYm54dElVa3BnWjhKMFNFaDkzbWkrNG5y?=
 =?utf-8?B?L0NxZkZKc3ljRXNtT2ViYjdzV0RPVWttRC9CYXVPNGFCTU1vYUNvdlhnUXIx?=
 =?utf-8?B?R04yTHdkbW9DdFJiMUV3bHBWMXU0UExLdng2MTZ6bkR5b1ViaUdBSEFaaklH?=
 =?utf-8?B?MnZpcTkrRFdTemhEaVdtU2w3UHI4djNpZUhaNkpCNFltaC9RQS9YempudjYw?=
 =?utf-8?B?RGJ1OHExVGRGcWpTaFVCUHhqdldpVWUyRlZ2QUtBMzhkSFpPdHVoSzdyNng0?=
 =?utf-8?B?OGVqWnhKaVhNWkY4eHh3QytYZkxpcmdxazM2Q0VxbWZjRTdHeWxIVTZyZStV?=
 =?utf-8?B?OFhWbTlZb1VJUHBuK0lpVnJGVGlLQlpsSTE4bXlmenRKWjVzNUJlaGJ1NDFY?=
 =?utf-8?B?Y2JKZERKVzJHY0tES25LWTVaS0ovbDZMRngxTTJ3VHV2c2EwQnpMTjk3QzJz?=
 =?utf-8?B?anM4dG81eloyeHRNOWRjQUhLWWNXbzREbWphNm51aEZyY1VkSW0zYmo0aGMy?=
 =?utf-8?B?OUM2b3EyaE11V1I0N1ZxSWR1ejhGUmgyVFhNMlhSS0tWYWV4NUt5RXV6UDNQ?=
 =?utf-8?B?ZHAwenFxaFJRNldlNHhZYUpOYk9sSTdLcXBwaXdxQ1hXNHppbGE4QkRwUUVl?=
 =?utf-8?B?bTJsSzBNbnZNTFlmd08wYTZyVmFJOVlCc2RDOE1RWW5ORGpkK2p3Q0doelNO?=
 =?utf-8?B?Q1BJdFlIRnorV21HQmtnZUtjb1JwMGloS2Y1aFN5WnhHeDNOSVJPcmplNkwr?=
 =?utf-8?B?eDI0blQ2a3NjM0FLWDdyTHEvaStpUDBWUVZ2TGczZDJjVlJFb1czY2dsUE05?=
 =?utf-8?B?eE9ncjU3SmF0VWJiS21Gei9COU9GK2lkSDRsTzV0ZGk0dlR3NGs0OEgwRkNa?=
 =?utf-8?B?OExsYzRQRW1idnovVFU1Y25vS0pNS2FINTcxYjBDbUJzV2dKazQ1SkljMVkw?=
 =?utf-8?Q?0fhYF1/j1AX6q7N/O9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe86651-0b56-4d7b-38a0-08ded2efdda5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 19:27:59.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6ldVT3Wo12MRCdwx9XfgOJd3+XxD7237o7yOvOsDIn29g6d613P2PqaDEkjSsnl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5781
X-Rspam-User: 
X-Stat-Signature: uw8t3699jipwwai4bxrkr7u7zbdquuio
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BAC40C0009
X-HE-Tag: 1782415684-363465
X-HE-Meta: U2FsdGVkX18s32GfAfl/nQ7JvnpaR19es1msQ3wiNlJmUERfeUd5+dpaKCkUZjZ+G/NbxXs8ssvshimvgwmklnFifdsff1cyGkI0+uDSU0UOG5jafWkVnkTjljwBP3htTcln4ljV48xoyAgOpchTDG/vZHpOYBJK3bcjEhTIoIEBd7doBMgNdgiukkOkA1fmYp/jUZFmqU2/EQniupUrnAnkzbx7zwHhII2CwOcJqQtTpXTINmbvhMN/9aCCoEZcUzZ6Y4uvsTE2zVe1eduKSygfkQuEXd25lf1rdqXjto7FVFHXBQ8x7rtN6e26fYI1QtJW5uAx7vItdxEIY7PeqTll4zPpWPIjpPH69kY/sVg3Fh4iTl/KsyUiVGhtlVXTADgxIy0yI1X0x9HRFQoBGgfGwVSnXT/UVT5f5rvPqis8BWy/Kf8ApFq4NHa3PsayajQv4XhnpLRtnqB+RUBYznEXvCzZWobeV8JAr+uFxKSXxclT4hz8LZOiGxwZo/9voh4eD1igl9TBAh5zuMf7F8XxSlrFwFuT3BWfmKzcCeo99xioBbyLo9nTEwlmKalFqNFpJGoiUFKQ5tWlKmjx4y9z61zjiCEpc3G8j0wFtkydgdhz0iTd9QKzUCLJuKvHAfrkQp6yqlBU4ioJUamu5Scc7S/YiqHMtziShCQ1un1LaQe+E7qbONSGa28ZZ/LzbeloD6BqkZffoc/ugGwsB6bx+U1gRDsqwUWAeBkj4zwRcPdHlgu0MSTz3NY1YMuyfcta9dxuO6ICUcnABV2hqJOCV9CaQpb7/0Xs1X5D4g3p/tU9vloHOhvRagajB5Jz0k1xTCrg4yXnCgG5B7Fx+b7R7IoJZWLSZVj73kqVSbNAStOViMnopJWm35nwsJ1BKqW7esPrZYUzbsYyhg/gNsqU44pVWgt9IeqI1EQ0r8yKXIxBq+G4o/ijJYoyDrvj3XRmxOopYJJFY+b+coZ
 f6Tyru16
 VnGzib6scbpM4gfqm61lCGy4rruBfuRoVYgXWpR04QIc4SsoN8MaWHJ8wd5v+CB6J1d3mnVrQPZ7u8JzycUFvPT2BoRwSHtSCxkJIsosKhQ5ZLOL6fDiDTdAhyy2R92En9vc/I4ywhUL4uV7h55dEycsxSe8zU83t+YtcUkkUQGl5ZbUPXY4pXFJTbuu9H/BshnFDxqRJWBvQsWBWy87iEafdL0s4NreGiDvWVL08Y7UHKT/ckVlP7uXcP7KJQCAkSEOaq8gauUlLSK2bikw8dl7ukZTlWhzFsL/4S6h+dLF3fWS/pTk1Y4NEV1+la8LuFzeujbDF1jHPkFAX0d0yS8lVsXRXKcKyOXHYFvRzDeGr17ebOJj2vinluf5XW5EkPtMt4orY9AAmFSRyVdYECcBzaePXcbwq5PKpFemkbKM4Vgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 12:30 AM EDT, Zhen Ni wrote:
> Add NUMA node filtering functionality to page_owner to allow filtering
> pages by specific NUMA node(s). This is useful for NUMA-aware memory
> allocation analysis and debugging.
>
> The filter supports flexible input formats:
> - Single node: nid=3D0
> - Multiple nodes: nid=3D0,2,3
> - Node range: nid=3D0-3
> - Mixed format: nid=3D0,2-4,7
>
> Example usage:
>   # Using the page_owner_filter tool (recommended)
>   ./page_owner_filter -n 0-3
>   ./page_owner_filter -m stack_handle -n 0,2-4,7
>
> The implementation uses per-file-descriptor filter state stored in
> file->private_data, allowing each opener to have independent filter
> configuration. It uses nodemask_t for efficient multi-node filtering and
> nodelist_parse() for flexible input parsing. Node validity is verified
> using nodes_subset() to reject nodes without memory.
>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
> ---

<snip>
> =20
>  	/*
>  	 * Maximum input length for filter commands:
> -	 * 32: print_mode command max length is 17 ("mode=3Dstack_handle").
> +	 * - 32: print_mode command max length is 17 ("mode=3Dstack_handle")
> +	 *        with sufficient buffer
> +	 * - 6 * MAX_NUMNODES: worst case for nid list
> +	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) =3D 6 =
bytes
>  	 */
> -	max_input_len =3D 32;
> +	max_input_len =3D 32 + 6 * MAX_NUMNODES;
> =20
>  	if (count > max_input_len)
>  		return -EINVAL;

Hi Andrew,

This needs to be fixed as well.

--=20
Best Regards,
Yan, Zi


