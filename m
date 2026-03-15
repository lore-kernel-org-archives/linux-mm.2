Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7653F3026E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 18:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF7D6B00A3; Sun, 15 Mar 2026 14:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA81F6B00A4; Sun, 15 Mar 2026 14:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D895F6B00A5; Sun, 15 Mar 2026 14:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C66C86B00A3
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 14:25:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 594A81B9355
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:25:42 +0000 (UTC)
X-FDA: 84549125724.19.D60E107
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FAD4140004
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 18:25:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=2EfeFRkE;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773599139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPkN11fb2kYuCZR+ZM6VOHOZsBiAT1kcWZfTMF4ClJY=;
	b=yGm9iJQHaWnp79k8x3xWwr/9ruvDu9qabnP9Srvecl6JDDCvcHS4aR5KQgAkHxDddYlfkd
	KRAesTpHAtlVCN1+ft+3YG7XPrG0yzZ6nu76d+qreBov0uLhV7MUXrDZ5NlZH1TyhrVa2U
	CPFZgS9TMLGy/U+jArmq3BIQqzU/e3A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773599139; a=rsa-sha256;
	cv=pass;
	b=Qx1/bauX1bSErgS6WaYdPTG5gJNLp66PDILCYwF7b0iz45HvAV4qCJVu64xEFpzVW4vSgI
	5+t4MMld8kfDUZNK7wCg4mCpKA5tD78shvndg5+xDICPqHe5QIekZKRWXOpHY00amERUOe
	xYP0LSWCCWhr7gBKiw2ORuvACowWj8w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=2EfeFRkE;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.85.35 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v52K4IvoP8cRQID2609qsNB5tNhKC5Bo9mKjY5DY1c1TIwX0kp5B3HkuGNASPe7K+C5GsrkUOAHBTaYqiPv3B0dKNuTsF+6T0rUXlpOok7DGHjkytRELmpno8pVfi+Tw7I+FXiNfn3c/KdtxV7g4ArInh9Yhpu77GRxBz61BnD0mBlx8C1sTRU4Pmsf3FPdbw+HP1nYyCahq7JDazPQgmqPQUdHKEBY5NFtecs2QqkP8ZyayEtgyhnblmqxINOSxoStEqcY+kj5n6/a0CzWWjA2L92A2HEqnxibHeWGr1HasiY+PI7dzX1JbSU9G3yRNMaCfZYXFqckELwHuMK4EJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPkN11fb2kYuCZR+ZM6VOHOZsBiAT1kcWZfTMF4ClJY=;
 b=PI2UkGG46IdiC0K4YJGas0YNhsh7/0Bh6D1Nr9OTgLxbiOPOOHsRVt2iBYWoG0VzyVLt7u70FVDn/xjS/wsNAdf14mlQigUA65jWAmSpc0S6E2syaJLMiVc69+ImEKoRfqgzcPTLmQqzUG8Qt7VNSNqAShqH6SB5ffZPaqTtJ5/jMReAUgrd0Keq92lKsxen7e4/+r5VgieR1lKTpW7Mrhm4JlblbzQ2RKQRwvBd5oeE3aVMdHSzxfjxNo00nC/+J7lNEVUBZX+5gMlLWVp0PwMx2/DgHBOKDCCwc9nDbS9N8yKwpR9lmO/U2ptdW3+CA4mV/dGoyZRWNJR04/RaXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPkN11fb2kYuCZR+ZM6VOHOZsBiAT1kcWZfTMF4ClJY=;
 b=2EfeFRkES21w+FEABHDIXfE628FK2sCmXgt2GZg9Ght50CwAApfe/8W1KfLzEOSDDmQD9XG1AwDWBjjoYQnWTZljZjiB8kj2D3d6Rq+bsvgR1/RxFm4l/cP0vb0DRjXTukVvE5IUqjGI2cfqfckzH3nZmxPHKyb+H4ZziF2tn3I=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by PH0PR12MB8176.namprd12.prod.outlook.com (2603:10b6:510:290::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.14; Sun, 15 Mar
 2026 18:25:33 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%3]) with mapi id 15.20.9723.014; Sun, 15 Mar 2026
 18:25:33 +0000
Message-ID: <99d3a0be-d33e-47c8-88b4-3f0e21f4a1cf@amd.com>
Date: Sun, 15 Mar 2026 23:55:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for already-copied
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 willy@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-8-shivankg@amd.com>
 <4bfec2c1-9747-49d2-a490-87ab204cec1c@kernel.org>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <4bfec2c1-9747-49d2-a490-87ab204cec1c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0213.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::7) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|PH0PR12MB8176:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c9c429-0b33-4679-6577-08de82c03eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	AI7GgwOZSJmaAzJXblbqr9peeURVmvpjkdSvvVD+P5A0t8E5tLFhl4CQbVzFqhZJwnTaPL75kl/cmg/bcoq4JKREzgMjbb8PEynQ/JqzvKDiIcNDLdM91xJECZ908BW2AEhyCvHgX33UdOPdHJvF///8Ti9cC/cvfjoAojz8bJr+mDEPnNNWLlccmn8054PfPmPrN45dtoXxG0tKItzsdwKWusfypJNq1tyJkd4mTp8aKbUXR9dKPiGMhXWbdeq1h/ho+Cd+McwyGojA5KSHYhXoKE6Eeo2euwyUjmWJOWrfdJa9KKlNUHJT+KxVIP4MSJ2CqsnjTPLclDk0u0JumHrDaO42L/tvRZqmwD+YYkn3Z2cFYfBksWz4KZwhn4vUCy0+JMLmJyXly8scKbpM4tr4oeApYTtp6t0n9Vv3cb9U5d870JAZC8q+breg/0oChEGXQZTInlXRCBVTyTP5HSnlNY73M1vT8cZe1ofQWsDcOVMI8EtQdP0DjHLgzcSUvlcskYzYwTFQPfSsuh78dQO/rIxa00SiLeOmSPJAY1fD77/lAq9ez6ygbc+BodD/Jyoyu0t7e5c9XI/FUaipoUGihz5eZG//4eSBYdVRTSuBGGy1E55gCS43k9P6dzojijRd7Pg/xwiRvwP75up128fk+/lLvjiMMd1gpMi1pSiCnQP4u6cCGt90bdnhXqBshNsZRlMvE0rQFhiS6lvUX1IEYG57E5x0UAcn0eZwjYU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N0N6Y0JJODRHK0ZVeXI1Um9ZelNRbTQ4Y3lnNzROSTVJcFAyU1AzMXBGS0Vi?=
 =?utf-8?B?UWQwTFErOXBKREJ3U2s0N0VXUlhOM3JmR3g2cHhVWDhQMzlkUHZEZktNS3Jp?=
 =?utf-8?B?c01UTUhGdUF2Tmk2VnN6ampGeGg2NjlHd2hvc25RYXZQam4rRFZFak5mdkhx?=
 =?utf-8?B?TG4zd0VFUC9vVHgrYkhRUDhNOWhSSkFkMEpCT052cjQxSFZkU0tvNkRsdXc5?=
 =?utf-8?B?bEZhbERyQTJzZ0VxZjR1N01nV0dvS3BNYTNacGpZZW5ucjkwejEyb296Yng2?=
 =?utf-8?B?UEhWbzVJckZONlhhTUFVSS9ramJWM3lxaHM3Ky9JTUU2emJSSjJwVmFDUEVv?=
 =?utf-8?B?SXR2T0tKTm1DaGtsU3IwZktZQ1FtQjB4YWJDU1phZ1QwdmN0S3VOa01YN2Zm?=
 =?utf-8?B?M05vOWV2b3BoejNaR3ZFUTFUVTNlb2F6MmNTTGEwUWhsdE9aYzBkUVJzS1JF?=
 =?utf-8?B?WWJKejFhZ2JCZGY5TUYyL0g3N0JjbnU0QmpuWk13SnpmeUVBMHBtNWMzdmE0?=
 =?utf-8?B?eURVeEUvOHRNQWFrSkhNNEo2bmlpS3lyWUdlMjJrL1RHcGRueTN6am1IWkky?=
 =?utf-8?B?aHdhUTEraHBzKzNVQ29oRm1Ba0tSSzRVbGpMK3ZEVXhCbXkvOTF0VGxtZVlO?=
 =?utf-8?B?SElwandpNUFYWnJhUFh2VVFlSXBzd2gzOWFvOHQ4dGVadW1pRVdBd2xaajJC?=
 =?utf-8?B?S1FqUGt1MWllRWZPei9KdHgxNk85Mm95WjM4THd0WTR5RnNWMVlWbmpSU1JT?=
 =?utf-8?B?UWxxa0pGdEZDdS9zS1p1S2p3SmR0cTFUazdKVk41ZUd6R0hTeEZZZVdNZnlI?=
 =?utf-8?B?MDdqdS9ROS9TOUZtSHQ5dnFyZDd5VHNGZkoyUzhoRDcxYWFzNEc5dlFOcVgx?=
 =?utf-8?B?bXd4OEF0UVlKUjRGSEp5Z1BSdmxSTnlRcXRHZmtKZG9HRUVkeGlBRnBSY2tL?=
 =?utf-8?B?LzlqRVZkVktqU3liU0JZcldFSXdHMmNoTEg2VDNzQlZZbnRPcW40S2ZmcEFt?=
 =?utf-8?B?NGl4OUtRd0lvb0lLQWVJNU1qb3NnelJSbUVwU0laSTNuNWgyajBaZGd6RmVT?=
 =?utf-8?B?d3pseHJieFpEaS9Pdmwxam13NDRPRE1odHV1V3RCek8xMzU1K0V0V0NGdHMz?=
 =?utf-8?B?Mk56NzV4TlNGWUc2SnNkOEplanlNS29wQzhwVUgxaDgwZURzS0dYUFAxbU1H?=
 =?utf-8?B?TEVLTHBPTWltaGREUm05TzNWTXJaenNtcGtxZXB1cHNHZ0V4bHpUWkZBKzNV?=
 =?utf-8?B?dUFFOC9Ec0NSLzFBZkl6cXdQOFRycFZpVjRHL1Y2c2VrZ3ZSMy9HU0taWEtm?=
 =?utf-8?B?bUY1VUZXRXNmd3h0Y29VVXVIc3AyMDRwaXFOZVF1dlkyM0NIUERCTHppZFZ1?=
 =?utf-8?B?NVM0b1ZYeCsyU3NDRFUrUUREOHhPZTZwcURabVhvNzNHK2VKQ1d2UUZPb0hM?=
 =?utf-8?B?OWFRdVZtU2FEbUN3akhTb3lObGZ5QUxlU3RCcWRrTUtyZFFIckNqZWR4S3RI?=
 =?utf-8?B?eHp4M0Rpak4za29mV1FzV2ZSd2QwanNXVE9wMUxYSDdqdjhlaDJiVUdadm9u?=
 =?utf-8?B?ajJEaVJzSFpFOUN2bGwvNk5rU3NPNVQ3MWZaVG5rY0JyUkdRSkRoVGVjV2Nq?=
 =?utf-8?B?b21mc0Z2bjRTL1YyWFRIbk1UTjdSN09NcGE1RWdSV2J0L1ZlUERHRERxb2Rp?=
 =?utf-8?B?UDJQOFZ1eEZ0K2FES3JPUXZ2UEQrc21aMHVLUnFWejFndXdhOUsyMTdQOWhI?=
 =?utf-8?B?ZFJaUkRLM2RjVWgyenlMako5VEY2YVRqU3FyditDRTliVkMxT3JCTXhnbFZE?=
 =?utf-8?B?S2dXMW1mZFRRNm5SaG4wQ2JadGxORFFDcHc2N085ZldyeGhQeno2VWN2Q2RB?=
 =?utf-8?B?MUg5T0tIcjYwaXVJc1RDemI1MDlGOFcycmp5Z204U1NrVmRVSS9BTExjRkth?=
 =?utf-8?B?WFB2TzNlZXdCWW53Yk42eThnbnpVdWxaRHFra3pwMTM5Z1IxMTdtUGJZbXlG?=
 =?utf-8?B?bDdScUlROEdMWDlvbnh1dm5xS0VldFlsZlFqdk1mZDg1dGw5QS9zS3lRWHY4?=
 =?utf-8?B?bDJldlZLN2tYYVhvaDFmb0NMbkhCQW15ZHo3WUpVVGM0ZjQyZVBLQm1aaS9F?=
 =?utf-8?B?OUo4ZERNTUtIZnhpZ3RGMnRSS0R6djhyS3FlYmZ6eXQyV3MzcXV5U3dSWDlt?=
 =?utf-8?B?NnJJd3hHWXBSNFhoQmIydm82aGxsNkJMM0dKL3RyeUdhSUNSQlRQU2FkekI1?=
 =?utf-8?B?RlFEc0RKbGx2MkVvNENJMmtVYXBCczcvbklmOGRuRmRCRDJCZWxhMnJnY0Zq?=
 =?utf-8?B?SHluQjlCQllBZEJycmhjSEM1b3ZURUk3TzFzcXcvN3RvaHRhaTVoUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c9c429-0b33-4679-6577-08de82c03eb9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2026 18:25:33.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wlPOFk9fvDj7/K8Ww5zt6EiWLcM0HIy8PTQxJjkqe1EueWXFjcKUifrgc+VCN6ESOQ96orb1gdbSQZWkabrNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8176
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FAD4140004
X-Stat-Signature: yso71mc9sni3x9b5j9dwanceuih6xkkn
X-HE-Tag: 1773599139-542307
X-HE-Meta: U2FsdGVkX1+SZQKOEEYy4MrSX6bf09FElM2LFE984u9duVy7fZocbPcv1iSQSWFLFpDWenJz/KX0W7bjIXqmVrK8grSNAIvMjmzw/dUEIrplM1NmiiBmv2z2bNpAXm5tOvYYe+Za3Io2olsBSSFBaMtoogLP8Qn1J2vrpp+X/Jig2pzbrEyER72DMvVmbc6v15ofXsuNu3FUIb4xhhl7LCncH7bnqpbEBZdNk0uWoupAdn1gp2wPnTYstHBVl2+bfoRNLmVH1wSLAQLdgS1cdUOo6y/bchtgpbHJtvEPIuTo1FlNRKB4wea4IkHGWqU7Adi0eDc3RAxJyB+N9QumT4VjtjZVaUeifksGdGlwo8yhvU/2r71h8NEn1Oens0obUOq2fmBT9X4ygZ5dDn1/OKYiOg1S0gdVTegfsncs9VK8pbtM4fOpajPNLEmPO2Nk43mFXO6OAgJM3IwGDErM0lt1g+l6ez1NHwsL8N9nFAr3l7ssu6MhEhl54n3ZwsmYvC0LtH1KZoC5uFpIRBwgFI2lTuAhLw/QrVO0kYPvjMn+k21yFX56O/7cMEBqDSTg4JGZgNm8EEP+nXRlysTerGIaCkwODKcjOSENs/p1PAO6dFKEIDYp2+KWu0LNeDR4Y8drZVV6TgG3yM3UNVoJd+2GRsqFii41nTEBvTQIeGrbYtA9AONLSQ2cKAeKxzRtC4+bxgfFK28yzmZmpou2WBi9GnmTyvTVpcaVweoBKZH/BrVIRuQ75qleubve0dtwSBD6AlvULEvHQ6VvjFma2yU3GEdxbFa76UOgIoXAY3SJ5JTVly6ls1jO7VSj+eYa+CTks1Ku4bsYKQrJTxvpmqaO9FHdk8+PBljAbUePTnKk+9ZQUcoawA1DG6thKOk38I/YTKzGRSEBS7NRXzC+rJsJ+4d67M7NA0ZdCDJE/auVL47wpX3xoJwEQtElxBpW8IeH+hF4Kx+7Rr16DZI
 EYFFATcQ
 XEdzItTDQsDq5xkOEm5PKDkSPNBxyTroDwzrgvcS9BTQWztqPSA3AGxClH7OSG/wnTM6UaK/pLT/jRVSZ4UrXTDmGMHCa77oLtMGh5E97Cs15hpxckXktn2t80m5M/zGDL6roFurmSkPj5aM0ZPk+FFSnJqBGXXtO+VIAl0zbo8rvvRWvHPHpHdfKQvhihZLcl7sdW80D/l+znzvufM6ZFe62RknssO2p5yDkUXRkMyZIJgklHUZRrU8vB5fvmzaJmhOXA0O690G5LdgA2Dw0FcyZNMhTTlpKP5puF9rAhs3o3dTTq3ftY6CxCNkSVz/0+/ZHEnMA2bLbVHl8X3fgkOMHaRJz156RLIL0WexSLQ32p2F/NcX4RGaJsfKYgKvitfiEKmJQ6tj5bsRrkIJoQ1Yf2MIVXJFtdiweWUJ4FJT2PNOzJGTP34NtklHJZKscr/SykxoScjnf63M5YGUxZ2fF0IXPCRLQxXwPBWTFNwXlgUObmU39G24k9JmDS1HIPTvmLPl9mC7ufOVzJ96eSvT9hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/12/2026 3:14 PM, David Hildenbrand (Arm) wrote:
> On 3/9/26 13:07, Shivank Garg wrote:
>> Add a PAGE_ALREADY_COPIED flag to the dst->private migration state.
>> When set, __migrate_folio() skips folio_mc_copy() and performs
>> metadata-only migration. All callers currently pass
>> already_copied=false. The batch-copy path enables it in a later patch.
>>
>> Move the dst->private state enum earlier in the file so
>> __migrate_folio() and move_to_new_folio() can see PAGE_ALREADY_COPIED.
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
>>  mm/migrate.c | 52 +++++++++++++++++++++++++++++++---------------------
>>  1 file changed, 31 insertions(+), 21 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 1bf2cf8c44dd..1d8c1fb627c9 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -848,6 +848,18 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>>  }
>>  EXPORT_SYMBOL(folio_migrate_flags);
>>  
>> +/*
>> + * To record some information during migration, we use unused private
>> + * field of struct folio of the newly allocated destination folio.
>> + * This is safe because nobody is using it except us.
>> + */
>> +enum {
>> +	PAGE_WAS_MAPPED = BIT(0),
>> +	PAGE_WAS_MLOCKED = BIT(1),
>> +	PAGE_ALREADY_COPIED = BIT(2),
>> +	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED | PAGE_ALREADY_COPIED,
> 
> All these states really only apply to proper folios (not movable_ops).
> So once we complete decoupling movable_ops migration from folio
> migration, these flags would only appear in the folio migration part.
> 
> Can we convert them first to state it clearly already that these are
> folio migration flags?
> 
> FOLIO_MF_WAS_MAPPED
> 
> ...
> 
Sure, done.

Should I fold it into the series? Or send it as independent patch as this series would
likely take few more rounds of reviews and discussion.



Subject: [PATCH] mm/migrate: rename PAGE_ migration flags to FOLIO_MF_

These flags only track folio-specific state during migration and are
not used for movable_ops pages. Rename the enum values and the
old_page_state variable to match.

No functional change.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Shivank Garg shivankg@amd.com
---
 mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 1bf2cf8c44dd..8c9115cc4586 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1133,26 +1133,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
  * This is safe because nobody is using it except us.
  */
 enum {
-	PAGE_WAS_MAPPED = BIT(0),
-	PAGE_WAS_MLOCKED = BIT(1),
-	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
+	FOLIO_MF_WAS_MAPPED = BIT(0),
+	FOLIO_MF_WAS_MLOCKED = BIT(1),
+	FOLIO_MF_OLD_STATES = FOLIO_MF_WAS_MAPPED | FOLIO_MF_WAS_MLOCKED,
 };
 
 static void __migrate_folio_record(struct folio *dst,
-				   int old_page_state,
+				   int old_folio_state,
 				   struct anon_vma *anon_vma)
 {
-	dst->private = (void *)anon_vma + old_page_state;
+	dst->private = (void *)anon_vma + old_folio_state;
 }
 
 static void __migrate_folio_extract(struct folio *dst,
-				   int *old_page_state,
+				   int *old_folio_state,
 				   struct anon_vma **anon_vmap)
 {
 	unsigned long private = (unsigned long)dst->private;
 
-	*anon_vmap = (struct anon_vma *)(private & ~PAGE_OLD_STATES);
-	*old_page_state = private & PAGE_OLD_STATES;
+	*anon_vmap = (struct anon_vma *)(private & ~FOLIO_MF_OLD_STATES);
+	*old_folio_state = private & FOLIO_MF_OLD_STATES;
 	dst->private = NULL;
 }
 
@@ -1207,7 +1207,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	bool locked = false;
 	bool dst_locked = false;
@@ -1251,7 +1251,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	}
 	locked = true;
 	if (folio_test_mlocked(src))
-		old_page_state |= PAGE_WAS_MLOCKED;
+		old_folio_state |= FOLIO_MF_WAS_MLOCKED;
 
 	if (folio_test_writeback(src)) {
 		/*
@@ -1300,7 +1300,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst_locked = true;
 
 	if (unlikely(page_has_movable_ops(&src->page))) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1326,11 +1326,11 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
 		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
-		old_page_state |= PAGE_WAS_MAPPED;
+		old_folio_state |= FOLIO_MF_WAS_MAPPED;
 	}
 
 	if (!folio_mapped(src)) {
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return 0;
 	}
 
@@ -1342,7 +1342,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	if (rc == -EAGAIN)
 		ret = NULL;
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_MF_WAS_MAPPED,
 			       anon_vma, locked, ret);
 	migrate_folio_undo_dst(dst, dst_locked, put_new_folio, private);
 
@@ -1356,11 +1356,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 			      struct list_head *ret)
 {
 	int rc;
-	int old_page_state = 0;
+	int old_folio_state = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct list_head *prev;
 
-	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
+	__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
 	prev = dst->lru.prev;
 	list_del(&dst->lru);
 
@@ -1385,10 +1385,10 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 * isolated from the unevictable LRU: but this case is the easiest.
 	 */
 	folio_add_lru(dst);
-	if (old_page_state & PAGE_WAS_MLOCKED)
+	if (old_folio_state & FOLIO_MF_WAS_MLOCKED)
 		lru_add_drain();
 
-	if (old_page_state & PAGE_WAS_MAPPED)
+	if (old_folio_state & FOLIO_MF_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
 out_unlock_both:
@@ -1420,11 +1420,11 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	 */
 	if (rc == -EAGAIN) {
 		list_add(&dst->lru, prev);
-		__migrate_folio_record(dst, old_page_state, anon_vma);
+		__migrate_folio_record(dst, old_folio_state, anon_vma);
 		return rc;
 	}
 
-	migrate_folio_undo_src(src, old_page_state & PAGE_WAS_MAPPED,
+	migrate_folio_undo_src(src, old_folio_state & FOLIO_MF_WAS_MAPPED,
 			       anon_vma, true, ret);
 	migrate_folio_undo_dst(dst, true, put_new_folio, private);
 
@@ -1758,11 +1758,11 @@ static void migrate_folios_undo(struct list_head *src_folios,
 	dst = list_first_entry(dst_folios, struct folio, lru);
 	dst2 = list_next_entry(dst, lru);
 	list_for_each_entry_safe(folio, folio2, src_folios, lru) {
-		int old_page_state = 0;
+		int old_folio_state = 0;
 		struct anon_vma *anon_vma = NULL;
 
-		__migrate_folio_extract(dst, &old_page_state, &anon_vma);
-		migrate_folio_undo_src(folio, old_page_state & PAGE_WAS_MAPPED,
+		__migrate_folio_extract(dst, &old_folio_state, &anon_vma);
+		migrate_folio_undo_src(folio, old_folio_state & FOLIO_MF_WAS_MAPPED,
 				anon_vma, true, ret_folios);
 		list_del(&dst->lru);
 		migrate_folio_undo_dst(dst, true, put_new_folio, private);
-- 

Thanks,
Shivank




