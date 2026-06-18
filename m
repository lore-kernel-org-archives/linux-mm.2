Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08E5CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 01:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B73D6B0088; Wed, 17 Jun 2026 21:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868AD6B008A; Wed, 17 Jun 2026 21:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7323D6B008C; Wed, 17 Jun 2026 21:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F3566B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:20:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A83DB120567
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:20:51 +0000 (UTC)
X-FDA: 84891279102.26.1346B59
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id B731E1C000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:20:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dQGfBKWk;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781745648;
	b=WTUi2POduA6fnVxbaXACbAol+flkPTAV26uBwDZg5856TEgGKzLBcmYRO6F44nrTCl7SKQ
	HvQ3H9RRgV2fGaBPoBb2ikEoZltatcyEau7tePrDUlrzPSPAnAnE2XbKTQNNCs9tuaoMrz
	DFFy69hVd9rZQnzvOsa4117MjojCKa0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dQGfBKWk;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781745648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYeihnkAcjkXZSscOr5XuXrtU/QllhIjdg2fSogTR1k=;
	b=JXF/47lROCmEqLBSgYM634+cO8OFXKeQ681WJ+Ar+Z88tm/S3kuhhaoafJqShbMOoneHY5
	a2bHj3BWa6p5J/39TXnhSwk/OI/WHQyE8XE5C1fNTQrAqarOJTjfY6SRj/6Li4MXeToKWN
	yW4Afvv6rpo6lyJxGTDCVnpMlyrWpzM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CDFevjMXUiGcMuvGqfwVI7rm8O6fScgPVxSDn6feR+8OT59jGkQtx+f6va0433C8yv93ULfCyqMue+3nEgksHO8CNMDAzmsE5er7/vEpSA1s1UyfxT4ikzZuxnipYAluiQGqp2Ot0IGE+X+pd35H6R7Tw6X7jh1gWqp/V9/vMzPynaw33xm8j/uVqLrcQWCXGT8TGB+DNQvpU6LYmVAdMMJX4e0FgiY8J2NCWCbvaIB/6afvOPj0X1BJRyNhnWjlvhhyAooDipjUoi1WwTJEZskKxK9m4w9bQzlQpKQ8Pt9JAo3/3h+/1A9W2OH4Nruq/6nhVP8oUQ8Wi+ICvTjlXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYeihnkAcjkXZSscOr5XuXrtU/QllhIjdg2fSogTR1k=;
 b=ABlH+eCydz+pBdAL9zXuWE2G+pEmrj6vaIGlZjp2PLIIxmbS5JOTWVq17uDFGUPLLr1KYa2ZHaTvYcnj7hj3eHnBfWVVVhHR+Djj54iIqbgJ+e1LR7eGtawR65BlurFM6FbIjZXv30RzHAMCTgfemP8OyUVjbL1w88w9pH4dcfzZdr867A+UHySZJMyYmQa8APA46SaOCrnrZGt4PzWmM8gHQq/jFgMgEyDYMVDKq9geS+LXoZDgZiLNbEVJjPW5EaJgFokypG4QpJXpUFCF3P8WQEnxrEpLhCHIeJwD+8r1/986GMwbhKdhLYRZcPxPBzpAmkLt55UHzebfmc97Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYeihnkAcjkXZSscOr5XuXrtU/QllhIjdg2fSogTR1k=;
 b=dQGfBKWkjrqkMOS8Go0nXHipne0XoFH4yha0b54Q6MltTEzXPQaeUm7+aPnG7vWyOGvR3SXIZVSxOkncmD4E5MqPPS2aZGL4mhJkCMvtT+cjreFVU+Xujj+gHEYYZh2Sn+VUFsOxOA3lByafDM3dFHn0nXpnkbH/3s+gOKQolCG/RMkIo6JG55sWQ/r7uEbjFIzSBM/r3XUYE/Mf1yQIhZv+ZSaI/icUJ+/U3ZIFzse1nu5R25EQkA+xv7s7oXuAFT0ILjvr/kRauntIsDcF7RjnUvG12Y+AeyPcxNzeFm6MaZKD+IL7lqQMB1w6JtOMQmV/sxDIbYDj+zpmSr2+eg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7382.namprd12.prod.outlook.com (2603:10b6:303:222::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 01:20:42 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Thu, 18 Jun 2026
 01:20:41 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 21:20:39 -0400
Message-Id: <DJBS471022MX.L7093MILIORX@nvidia.com>
Subject: Re: [PATCH 1/4] mm: mincore: try per-VMA lock firstly and use
 walk_page_range_vma()
Cc: "David Hildenbrand" <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Zi Yan" <ziy@nvidia.com>,
 "Andrew Morton" <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-2-wangkefeng.wang@huawei.com>
 <DJBESGC086ZC.3JSQ5GD3ALCY6@nvidia.com>
 <065b1900-1a4e-4d92-b588-002b844f1896@huawei.com>
In-Reply-To: <065b1900-1a4e-4d92-b588-002b844f1896@huawei.com>
X-ClientProxiedBy: DM6PR21CA0013.namprd21.prod.outlook.com
 (2603:10b6:5:174::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7382:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d110b3-5a77-4a71-cbdd-08deccd7d03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZsTQNfc0qLjrxQotZOZ7ZwnoQYN7/VM/Z8P7VoK2kgA6FoqurNcArSN4m7RBKGOwv76CFa5zUjAbZFxvqUlK88Z+H0rmbEoYQH/ZdECqSjGNlufC/5kZTY0o+9GQDldsmf+AaLQZStgogCwyfjUjghqeLKksPjs5bpcoj+7DOI7BTAvaVXx8DNCtaJXWoUyo+zy8lyz9l1CRQ9Icblwa6HUtqMtGR+3zmrbhR6I2k21n+AG8eY/4QV/rDuG5EHsl2xp+8hMjwQUsLuc7NiF0QSy+jaLjZzwihnB+YtL7gQ3ou+wmL98FM5VRi/JkRuZ4CfZJ1+rBgoHSRrJrMGnUDSPxgwOKFlj9NbRXW7hoZh68Z5RGA2NdpXXFTDH+X8m1wvG1Phvz0EzwYJxWN3ypK6DaSSBnTZz46CijbxRfeYCPjZ0wiPH6MUKTST4QIKjvx/LD9g6pMxbDTltg/pkHxKKuYs4UhLpiodAlf5WKPOKGBLRU25bDtfVnXt2fLTjR7MrSJryk6kxqiWwRdtglDfc/1Pzf4XSH+k1gdXkDvUnJ46r1Mpry5AzOi0NElQVXLC9Qq1bQy2dhaaFDfLQSMNLq2JV/U7Scda88FoUSCnsA/1Zxpj6Ufj1MMhZPXyhV7jXYQO93AMXd5n+rYSkC33vSLsk9/461diNBXDJIC0n3q8ZAASC2j5OIHiYPbo6H
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3JVVmtROGtrNzdmc214VndLalpIZXhSNEZyVE9QVFUvVzJTUXRvMUdPaXhu?=
 =?utf-8?B?NWRzeGRiR21BMnErcXJyR0tucWhJV3ZieWxhTCsxYTRwNnJFUmVjNVZ3U2ts?=
 =?utf-8?B?SU9ZQ01DdGpNN1RZbTNKemJkdlNBUWZuSm9OT1NNRUtQYmpNdy80b2p0WVUz?=
 =?utf-8?B?Rm5hM1RXQm5nNGd3eHR3bS9YYXlmVEpiWnZPbHBTQXd1L001WlFZcWxWV2FC?=
 =?utf-8?B?MDhiSm8xZEtzMGdYTFRkNVJhWEIrQTJVNjhIdzcydXduODhTTkI2Kzh0dHRj?=
 =?utf-8?B?WEZIdDJlSW1rRUxGSWl4ZGFsMkxidkFyWWlRVHU0VUN3anp6ZVp3eGNadXJl?=
 =?utf-8?B?V3kya2tkY2RZd2RtcXhEYUJia2RYdXZ3ZHBaRG9aOUpKVUZUcFFES2MxYW12?=
 =?utf-8?B?RW1wdFdGVFVublZET2NRdnZHMWkzR2VTUXMzdHR0N1NYWWVUZUlaQjBSNzho?=
 =?utf-8?B?eXppVng5REZUY3hldW9idEIzZjJDYzhlNkFyVkhpbmFxQ2lIcnc5OTlmZWpy?=
 =?utf-8?B?dURSNWZDVytQbWoxM1pIRDFTT2xjM1ZUU0VjOXFYNk5OYjFxYnYvRVExbmp0?=
 =?utf-8?B?RnFjSnhHRW5nWlh3YUtXYXJ1bS9xZ1d2TStqZWtORWk4MUJOa1F3cmJNc2J1?=
 =?utf-8?B?blF2b0NqdHJwMWdSYm5DRzVOaFpqK2loVWNkZ0haQTVMQll2NVUvY0RPQk1m?=
 =?utf-8?B?emtMQUtVZElLZzBxOWZzcUc0VFJzbXhPdXQ3aldwM1pQZGd0RUpLcks4R01a?=
 =?utf-8?B?MDJ6emJyQURIK2hQSGJuaXFkb3VaQk96RG9kSlpENm5TdWpLcGdEKy9aS1JJ?=
 =?utf-8?B?bXNVc0FlTVovUUpGNGJZUkdtUlpVWGcyZFd3UERkaG9jNkRxaXFvb0d1cU8v?=
 =?utf-8?B?VTlOZjcwRlBydlRlTzdwS2w2UlZJeW9wRW9iS1lPUWZvV0VBcWxydlAxaUNK?=
 =?utf-8?B?R2VNd09vY1VkTCtQMDFwT0ZVNllCSktUQlhUb3ZIWlJJV0J6cEpJZ2h0QWZt?=
 =?utf-8?B?VmZOc0ZmaWJyd1NQbGcwcTUwSmphNFFrL1lTRlB1MUF1aXp0cERTVmhRNDBB?=
 =?utf-8?B?SGFiNGEwWDBGYTVST0FrcjFGOURXck5yekJFVHRKaGY0Y1NMdVArdUprQmZx?=
 =?utf-8?B?MHc3MGRtdWo5MnV6Q3FNa05NSEFXNG9IdEcrRG5OTncyN1Q5ZnQ1dWp0cnV2?=
 =?utf-8?B?cUt3bE02QitUTzVtWW1sVVhUMkYzWk1lOCtlOVBuTCtGSzlpRkRTTTdlN01U?=
 =?utf-8?B?d2JQTTVYaGcvN3pralBpenlSQ3JRSFZBMHlORHIxUW5uVE1CWktEMWlKczJN?=
 =?utf-8?B?K0ZEM1ljbUFSSy9rKzdiemh6NC9mUE42alJpd3p4ZHhBTTExVlBNRldjclQr?=
 =?utf-8?B?NFNwcUw5WExCNkJVSFQzdXJ0OVN2S3NBc1RZZGhIcEJmNTlFYm1tcmNnS0N4?=
 =?utf-8?B?K2NlbHVqUXE4Q2hGb3N5VUZSQ3BoTXF2QTNFeFkrRkhPZjV5bzZaa1FuRkdB?=
 =?utf-8?B?alBHYWNSYkk0bTM2M2hGbE56R0hDNDhVT1VSR1NNVTJaeUptK2FEMjE1Z29H?=
 =?utf-8?B?bVNBVUpHUXZBSUJqYkRPUjQ2NmRYbVNDMUhhVk1pRVN6K2pBNmU2dmo3MjAv?=
 =?utf-8?B?QVdWdlVoblUrOXF6Vk9QejFQc0IyWWJHSzU4bDJUWmJQY1Q0R2h5NGhaZFZK?=
 =?utf-8?B?dytyRmdjWEVGZk5QU2w1WlFRMFpxb2x2bjhKSjFiL25CU1J1Nk5TeHVmeVR6?=
 =?utf-8?B?M2dqT2JXK3NBd3M2YWhIODBGR1VGRzl3b292RTZPTGgway9EWW5NQmRTZ2VZ?=
 =?utf-8?B?dnprUzRINnFkZHFCenlGZmppeENkQVgzdzJ6dTUzR0dhQXFzc0pZdVFid1pD?=
 =?utf-8?B?SWphM2JOQlNaVzIyUE5zUDU5RFdCaVRLcTErRnpnQWpXUkhlMkVxU3EvTDc4?=
 =?utf-8?B?VE9uZW55MjNUbGVIN09iUVFtbTNDSjFiR1lNS3ZxQ0xzNGllZnE1amJTWkkz?=
 =?utf-8?B?VEZxQUVtVmhUaE9TeEFIQWZCdFY5dG0rbHpNL1lPdk5JMmpaNVJkMlpPbWdO?=
 =?utf-8?B?dWlSeVlkQncwbEc2aVZtOTE1a3FOZlVKclJvUGpidUhaeU9IWEhHK05rbW5v?=
 =?utf-8?B?ZU40UzNIakhLVEpjZjJvUTJBbkJvOGFMZFJkT2dXYzU2dnhLU0JRKzdoUk1V?=
 =?utf-8?B?eUJJSnFFNjZCeEpQbDRmUHdtcS9KOVFQN2dHb1g2OTl3U0pITzZnMUsxU0dV?=
 =?utf-8?B?ZlB5dloxeHhjZHhPeTU5ZUE1QVdJMHZnbitYSzc4WkFSQ0F1TVZGeHMrVVRx?=
 =?utf-8?Q?Dw/DAPeWJ2wzxxsUd3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d110b3-5a77-4a71-cbdd-08deccd7d03a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 01:20:41.7977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEVVtLFOal4BTLSaID9FfCtCvNFKnfQ+LwPJan5ggYRILFjlfoWnTxqeLBkdVBSP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7382
X-Rspamd-Queue-Id: B731E1C000B
X-Stat-Signature: k7y9ndbdnemrioosd3kjcne4heaaqiji
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781745648-716343
X-HE-Meta: U2FsdGVkX1/909ltIfLJpuva8yDhxAuNi2bYjeVg8e8ly/Kbwix9voNAPn9OnVIMJP/RbfR7c5Y/vFJCneqHCFKmbt3gtyFz6VJntO5nOcAuvatcDRqaXYJMmS8j0Uqk3RV1NMpAq21QhH5dvFK5qVZ7DoweXgOFb53orlFfVK8rv6TpqpfbzCVFlDq+U1AozfFOcjB0LIjZtBIUUWF4ob+fByb5/vBbw6n27at51i+AGlDWYgkyOY6TIPmyvZ9NSh9X9bNzg0UuDJI/rtI/B+RVPhtdw625+kIfYaPnDVKhf0BaUk2z6Z4KgNjbScS2H457QUfwht9+JpyeqoNzyiob+c4BU02UxRXp0VZgVKVHbZAD+Avlfexy1zawBdsCeEyftkNBBLIFFJ8P4yPNCouVVRT6a0NdLLesHPCSYymX/AKrLMzkcbvh5ZBeExBWXumSCbu2s2cPfEE501M+821dzU3CiZtTypZ8yYLjnrKlMbkhgrfj35HaEc1mw88NsHlv7Zb5Mrio9EMw2s1zgZrFpz+kHuHr5adMzbz3XMQznrhInkBbcW/LOmNKEfw3LfnOCpX4Yic/N9vLw1nUI1ZL7vQqdsa8zOV2ulQ1cZ4fTUxIMXNW7+RITlhY7iMSYpTL6hEiDYMeCaLW8k+M48F7HrK/OrADkaKwtIvFEzfIzehwvqakWp1uPgNU/PUMq2De69qbVJIAYkcOEE6gTEyH8D+d9fRNuCn6xeSu5qijRM+vfU44NrfvcNMBANpBfi9PS/RLshwxTfrJyj05M2ihgYx7fLLG/mQ9THWiSsSpXLG8s5TwTHVocy37XDGNESL5QyN0r/uxwwo7be1NcAiLoB3LIyxVYl+KlH4cOGyWYc7mt78t6rcDD9vMeK3/iaRiJr2YkYb+uyM5eEPF2H9GJBelcHK/J+ZfebU1Q2u7uIlDIfOfx8j+OlLOp7kdE1ofgal3uk5yyoZNdOG
 xGxlk5nm
 bAWkJJTTVOzvsSDE9XJtOjzVHC8IYmwS2c0r9QqjbAi5ezjIv109EFYunuSxRcgLgSD96kmq8rs80hSzf2/6qRf8OWAC+6rOfa4uzoeh6MZXWcP9OMALKQillGYIpKvtcHhxCbzTKoWPIhnyJ9+DT7SEGog42ov49DK0D+zdshMSFQLUhGUFY9gy2qs4zjlOC3nTLl8eEBvrIypa0NDQY/dFBAj63RoPx1YuNhQ6qF4Bt32+BAVTcq7DvmKB5dlcaCes03Nb4u/q7ztJbDsT/1SPPPhAMfc1YTwecj1mbunPXmVtHRKSOrSTzz2CBWja4UQsajoJekux8tujw/H+xSs9fNAwuD/noVS2nmQboy7oMlKt9ND2630ePuW7b9mBrL4w2KVbKUo0bOwBQdMsKvzxcpYhl3KcMeugyXPxCL8/+aeHFc6A5jHEBEwFQU0kFLNIThVD0VekPV3b2TwCNxMCllg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 9:11 PM EDT, Kefeng Wang wrote:
>
>
> On 6/17/2026 10:54 PM, Zi Yan wrote:
>> On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
>>> The mincore syscall currently takes mmap lock for the entire
>>> duration of the VMA lookup and page table walk. This creates
>>> a global contention point with page faults and other mmap_lock
>>> holders in multi-threaded applications.
>>>
>>> The mincore is a read-only operation that only queries page
>>> residency from a single VMA, making it an ideal candidate for
>>> per-VMA locking, so try per-vma lock firstly and use the
>>> walk_page_range_vma() in do_mincore() to eliminates an unnecessary
>>> find_vma() lookup.
>>>
>>> Unlike walk_page_range(), walk_page_range_vma() does not call
>>> walk_page_test(), which handles VM_PFNMAP by invoking ->pte_hole()
>>> to skip the page table walk. Without this check, PFNMAP PTEs
>>> would be treated as present by mincore_pte_range(), changing
>>> the returned residency status. Handle VM_PFNMAP explicitly in
>>> do_mincore() to preserve the original behavior.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>   mm/mincore.c | 71 +++++++++++++++++++++++++++++++++++++++------------=
-
>>>   1 file changed, 53 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/mm/mincore.c b/mm/mincore.c
>>> index 296f2e3922b5..a786a073feab 100644
>>> --- a/mm/mincore.c
>>> +++ b/mm/mincore.c
>>> @@ -12,6 +12,7 @@
>>>   #include <linux/gfp.h>
>>>   #include <linux/pagewalk.h>
>>>   #include <linux/mman.h>
>>> +#include <linux/mmap_lock.h>
>>>   #include <linux/syscalls.h>
>>>   #include <linux/swap.h>
>>>   #include <linux/leafops.h>
>>> @@ -232,34 +233,47 @@ static inline bool can_do_mincore(struct vm_area_=
struct *vma)
>>>   	       file_permission(vma->vm_file, MAY_WRITE) =3D=3D 0;
>>>   }
>>>  =20
>>> -static const struct mm_walk_ops mincore_walk_ops =3D {
>>> -	.pmd_entry		=3D mincore_pte_range,
>>> -	.pte_hole		=3D mincore_unmapped_range,
>>> -	.hugetlb_entry		=3D mincore_hugetlb,
>>> -	.walk_lock		=3D PGWALK_RDLOCK,
>>> -};
>>> -
>>>   /*
>>>    * Do a chunk of "sys_mincore()". We've already checked
>>> - * all the arguments, we hold the mmap semaphore: we should
>>> - * just return the amount of info we're asked for.
>>> + * all the arguments, we should just return the amount of
>>> + * info we're asked for. The vma is already looked up and
>>> + * locked; vma_locked indicates whether the per-VMA lock
>>> + * or mmap_read_lock is held.
>>>    */
>>> -static long do_mincore(unsigned long addr, unsigned long pages, unsign=
ed char *vec)
>>> +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
>>> +		unsigned long pages, unsigned char *vec, bool vma_locked)
>>=20
>> vma_locked is confusing me, since I thought vma_locked =3D=3D false mean=
s
>> vma is not locked, but it actually means mmap_lock is taken instead. But
>> I am not sure an enum vma_lock_state {VMA_LOCKED, MM_LOCKED} is needed
>> here.
>>=20
>
> Maybe I could directly pass the enum page_walk_lock here?

Sounds good to me.
>
>>>   {
>>> -	struct vm_area_struct *vma;
>>>   	unsigned long end;
>>>   	int err;
>>> +	struct mm_walk_ops mincore_walk_ops =3D {
>>> +		.pmd_entry		=3D mincore_pte_range,
>>> +		.pte_hole		=3D mincore_unmapped_range,
>>> +		.hugetlb_entry		=3D mincore_hugetlb,
>>> +		.walk_lock		=3D vma_locked ?
>>> +				  PGWALK_VMA_RDLOCK_VERIFY : PGWALK_RDLOCK,
>>=20
>> An unrelated comment about PGWALK_RDLOCK. Maybe PGWALK_MM_RDLOCK_VERIFY
>> is a better name since the code just verifies mmap_lock, unlike
>> PGWALK_WRLOCK, which requires vma_start_write(). PGWALK_WRLOCK_VERIFY
>> might be better named as PGWALK_VMA_WRLOCK_VERIFY.
>
> Agree, I've thought about it too, but we can do it later.

Sure.

>
>>=20
>> Otherwise, LGTM.
>>=20
>> Acked-by: Zi Yan <ziy@nvidia.com>
>>=20
>>=20
> Thanks.

--=20
Best Regards,
Yan, Zi


