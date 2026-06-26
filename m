Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB4FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6049E6B0141; Fri, 26 Jun 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF7D6B0142; Fri, 26 Jun 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB2A6B0143; Fri, 26 Jun 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 251946B0141
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:55:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BC27C251D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:55:31 +0000 (UTC)
X-FDA: 84922967262.12.DBAE93B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012049.outbound.protection.outlook.com [52.101.43.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8A38C0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:55:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NnzswM86;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782500128;
	b=B8v5YAZlHur4ZKTkVnE8xw8PndBhojNZah+ml5prkSo1dUfDZBBwpE/IcjIeGd5cRJKMft
	uXbqcw1J4Iz+FTHBavc4t1SrnJTyZRnGwiR4iXgaesmzRkqJyok8E0BXNjqESbfQ0RuNxv
	iuFODXmPT3NQV9DJy1kRgJekc3UfDRk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782500128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qxMJ66EDdCVl2db7nIoMhA5hb6CbzRj9Xriwtb/40A=;
	b=eAypVnATrtovCch+JVkMBy6MINyXMIpW8+jYiBZ5hlBEYM9S7Xh45ZVJYjS+07aVRNpcIQ
	HaCAfMVMagZmibL+pF8GN28Ff7nHXwoTw3WK1rs0roiMTIM6zLnbb0we6vfySbsVeUFrIn
	8mI6gvYqWNkxT+2hyqxC3wMuuBFpG0Y=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NnzswM86;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdpwcoMIbOhdu5KTw+vU2qN/5Ad/UR1mlCaNqGv5oGiXJyLP2J3JeZkpztNubSKbreohWIBzt74L4KaFcx14NAB8N23BFRTkzjrIjhHpq6Py5WA74Q4BGmthYB0AtJeT0lFMcrc3C2AA7h349DW9ZMS5LBYbHmOkl5qJc84wOp+O/JcDVXWXY8U3PS2+wzOBjrzXa3NcLDhIzWD/MAEsZDGprGdCnJDvxfkZNJTu1PZH1b+UCvaDx03iTbZVMZZDpLK5QxqCiqjrXNz/MokohfVdVT5ohGBZwGQjGckkUrwt/+YYX7bkLi0ckAL305in1CAZQVFmfk3WCRvnk5c/tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qxMJ66EDdCVl2db7nIoMhA5hb6CbzRj9Xriwtb/40A=;
 b=kfXoo7bxbKZkJf6OwnNCtrl2srMLdVW2735WyqADMk+NaBZ2tWFVm0RBlQsImtErOAad4e1ih1sfs2FTbFgkihm+Qp7yHeq2WWRlm6evQKKGH9rPj5c9Ozpaf4HuQRoFxoKkv4BI2s3o5oAgBI2RiiGAI7p59YyfiW3RucM8tRY7TkCIUzjoqfGg75la+eCLn/K3JW2skZKUn+XHN87s3ifp5kgTGVPwspP2XEOC/NqKKteuMuK7j7Q/CjAY9w+t3ogOELi19QlEEvrwB1QPEAJjeW/JP+fABHvqXmccs+cQpZ/9wwTYQfB/QhDLK8595lvl1ro8jTUIDfjyeGem4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qxMJ66EDdCVl2db7nIoMhA5hb6CbzRj9Xriwtb/40A=;
 b=NnzswM86R5u2FSIFEIn9BQmaNK0NHAefkASIRzKSvYlnpvwUVcMKu7l865x/Stj13ehqqRGdABJgQa2bIH8EcT7QKja7jmRh3PBAoBwhjyP44TWylH4i/35rwH35xZfBtlXhslVOW7d6r0os4VL0WCSZtqJbY1slPIRMob/hln4a1AFDXnV/fUVqiuOQuFpFOWAAUNa5LhqOisVfOS8XlsyPxvPn6w0OT9sK4jm0zhH1tdFDAHuON42uT4t9taaAnBoWSINYIzQEHSOACQSk7dlyST9ax/fg5uC13hjUm8FWZI2nuGAjwnG7NmhC3w0CaS1KhYXQC3dBH8olNASVwA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9109.namprd12.prod.outlook.com (2603:10b6:408:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 18:55:17 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 18:55:17 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 26 Jun 2026 14:55:16 -0400
Message-Id: <DJJ7K125ZT44.1D6ZSH2JPWIES@nvidia.com>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko"
 <mhocko@suse.com>, "Brendan Jackman" <jackmanb@google.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 5/6] mm/page_owner: move free_ts_nsec output to free
 section in __dump_page_owner()
X-Mailer: aerc 0.21.0
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-6-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-6-ye.liu@linux.dev>
X-ClientProxiedBy: IA4P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: 58281d25-9b33-4667-b190-08ded3b476d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|3023799007|18002099003|56012099006|6133799003|4143699003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	ZcY4PtaWZQGLkaj7ezqkhp/XQchPXu7IzUNEGKg+QHPNn1hnam7hZk7vvrv6TDRMSEuXRt49K04wzW/JZ7qJbi/c2OmRmFjLEcCAUwsBlRvEh2lkCnHf38jB+2R3s1a82hXlK+0NXTWwz/rtG/CH2HL6DLwHQvxXP2/Pd9VHPweSIRrmUT/q8x+Q1Uke+ZzzuKk9FvQJVzCV5/0mt02r619V4Qm+pItyuznZKKmLkZuL9h7gKvSFKtQBEZP0eenggrKmqm0fZVSJuSVpsg5qz3w9QxF3Wleir1hT0tR7wBqSLdTJS8jJpY63axD1aaMNyaJxPiKp7ZE8/4AuR8MDm1sqklJzRnRQMo97bCAKBrNnqFbH0tL7iQeFFqtgxoZAbRX5vk0NOAQEEDOq/xnYzEiIy09Np3yhwSDQLpvi+FqhQI4AkLDeIdFIvdfiJ42akJz7mQsNci/Kn6t/vcvgeJ0i+avxvT0yJwrUgzNjq1FFLRhkyPg1gMQnZBjxrVjLZVov3ZOIR5sH6svNOGrNjWvvcaBKdLxSH2tOhlmqku5OWkwHWONgf47Beaqs28aG2f7IVWlIrvW6uNTxdtQxPK1PuQUgDvHeExWg5ypWH7xO/A9FK2jePfY6atj+3R28njNZaQwfhV9bmGaovm7/PWjwZv82EMXB7KLZe7HNsoc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(3023799007)(18002099003)(56012099006)(6133799003)(4143699003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHIyRHZnWkRoaVpMbmR0OTcyR0V2UzhhNUFZQ25GL2M5RnU3N2NENGpNbzN2?=
 =?utf-8?B?LzJZQmZIWFRoM3lYM2Y4NzZXUmVycHd0WEM5Vi9zWTZOYll6UXJQV3RzeC9G?=
 =?utf-8?B?V1U3dFk1S25TZ2NMQjlhMlNURkx3QWd4bjBNKys0cTY0OU1yWGo0L3gwL0Ro?=
 =?utf-8?B?UE5oT0xkaTZ3dGxwcTZ0aU81dEVZVUtOV3M3Y1VNVUpObW5ORDYwRzNxeFlF?=
 =?utf-8?B?Ky9FclFCbHZYOS8zbHd6RzRhcGNjM1VOc0R6dUg2alVodDNEd2c0SmJ6bWRN?=
 =?utf-8?B?M20xL3czQjEzZW1BTlF3dEE1bDdqY1ZWc3ArM0ZEK0xqUTNKL3ZJTEZsM1RS?=
 =?utf-8?B?Y2dQL3dibUtuaG1uWnhNRzZWN1doV2VjU2toNlpvT3Rjb3VMdUU5YW5lam5G?=
 =?utf-8?B?WTVrUGQ2aHlhSUpKSGhYUFY5ZjN0YlRyakJIcGRSa2VweXlFWDFDRkEvODh1?=
 =?utf-8?B?dEdTNHh4ODl3QkVrNlMwdXYxZlhYNDB6RHIwSlRDT0JqYmZQZXVhQ0dZbVZU?=
 =?utf-8?B?R3NuRmJiN0VESUY3NmZZb0l2bEJlMVkzOGQxTUNGQmpkd01iekV6Ym1aUEpv?=
 =?utf-8?B?b1lFK2pjdjNGdDVBeWpQb1EvQWFyZGZhTzJ6M04rV1F3WGw2blFOQ2ZMTjR5?=
 =?utf-8?B?ck82VUY2dS9ubWJsZVVhbUF6TUt6bUFXL0wrU0Q3NFdkWTBENVA4cDJGUjl2?=
 =?utf-8?B?SGVkSVRjZCs5dFZGYnN6blBvVk9SakhQbEIxWGJsWHFlakU2TnBZbDFYUURj?=
 =?utf-8?B?a1kzcWNVMmJOWU9LWXZhcW5tSmR2Qm11TDNUVTcxMDFSYjdjaHd1a0xkak9i?=
 =?utf-8?B?c3pQL2E4bXUyUEZaWnlQQmx0Zkd5N3VHeFFTNTdZSFF3M1NsTy96bTRIS21S?=
 =?utf-8?B?dlE0RXp3Q2QwYTAvcFROTW1kZkRyVFA2UFZKOXI4TkR3R3R2cnRlNGRYY0FI?=
 =?utf-8?B?OEtBWE5ZN2NEdEkzcFZLY1d1TWdSOTV5TzN6QUxmSElhaEtaNFpxYXNMcG1Y?=
 =?utf-8?B?d3BqR2xWL2xKbUduemlLR0x5Rld2RzhxM2RoeHYyenBIZmpva3NWSGUyUk5U?=
 =?utf-8?B?U0xjQnVweXVOWG4xS3Nsd0dqMkVRckVnZk1rNWNsS0h4WXR3cGlFL2xidXAw?=
 =?utf-8?B?TjhjZFJjQTdjQzUvSmJvckRtdlZwOFpQQ0x2UGdFK3RpalVRb2tvTUI3Sy9w?=
 =?utf-8?B?RmIvU0FBM1VvdnBIalJYQlRkZ0tZcEZCSll2TjBGMnc5VmZJa2hvaHZEMHE1?=
 =?utf-8?B?VmozTjRidVBxS1c1MWc1dnFuYzZ5N2FGWXZWZXZjY1FpTHZVOUVKaS9DWmRx?=
 =?utf-8?B?Z2RKdStKbDQ3OGZhQlBFTWFuTWhYTXNKVW5laC82L1VGaFhGOTRPNFc3U05E?=
 =?utf-8?B?dmpTZVlEb0NQT09lcTVhQitIZTlZTThZdFVESlJ5SG5hQzVrc2g5M1ZWaXhM?=
 =?utf-8?B?RVNGNkpReTI0M3JqWGk0TW9TeTZxWms4N3YvbFJKL3hnMlovd2tyN09JTFVL?=
 =?utf-8?B?cDhjRUtyZ0wwZnY0MjhLRlNKSGU5VUVUUmp1WlJ4TWFnbEc3c0Y5Unc3VlV0?=
 =?utf-8?B?azR6elhHN2QwZll0UldoVU1EelhpRmlNQWVNYnVtZFVhRjMxZ3Jpa29lZGdo?=
 =?utf-8?B?cDFMTjhLS3hKbDhlQy8vMmEzWm5YYlNYbnY0d1ZiZWtuRDYwRHpuTTR1anMx?=
 =?utf-8?B?RWRSaGdkMDhXS3gvMGNYN0UwUS9uekpJZUhVTXMwVHhBelNhUWw2MkRiUE9j?=
 =?utf-8?B?RlErUTRGZmtObFVwV0QybnN2Tk5SeGE3YnFFbzgwN3BTS2dvZlNGNHBOQkR1?=
 =?utf-8?B?NFE3NDFhd25hdU95Y3Jzdm4vbGNucUhlTVFxalVQeU9nQ0JVeCsrbUpsa0tK?=
 =?utf-8?B?NHZxN1lPTVlwbDFhMUg5TWJPOWtJM1k2QkpCQnJBNlRPWkIzNEovb0Y3MG4y?=
 =?utf-8?B?V056b3dhcVFJeXgvN0FQN2hrVFdEeTFKRTNUTjRjYXRwc08za2x5b2xPcHZT?=
 =?utf-8?B?ZW54SnJhc1FTYmlxMGxHZVNMei9SNzJ0Yy9aWlNlMWpYcS91QkdudDRaVWg4?=
 =?utf-8?B?aitCTFpxcjN2TFgxdTdYcUFsMkhMeWFsaWY1bEVFcFFGUEhVN0VZTzBSazRi?=
 =?utf-8?B?bTVrMm5ISU4vSUY4RzdaMkVMaUFkMHR4YVg4VFdqU09ROU0wNmZ2cW9lenph?=
 =?utf-8?B?SFV0M0NxYm5rOC96UGhKVHlsRmkrbWZBSUh4YU9Bcm1tQzc3Smw1TlYzbjZt?=
 =?utf-8?B?ZTloMFd6YzFaWUFTWFliRXBDZXVVUkdRMVNCcytrTVVGKzVXdW1hdEk1Q2Nu?=
 =?utf-8?Q?pxSX374Ja8wuSmsHXI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58281d25-9b33-4667-b190-08ded3b476d0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 18:55:17.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AGaVr7l/WShfxQBQKPUnIKVFV5ttIgijrE0Q9MgXZWHD0wr0ZuUCXUJEfaWQ9g0S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9109
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A8A38C0002
X-Rspam-User: 
X-Stat-Signature: 7toa413j99e6out6b6rad59nh8ehtbab
X-HE-Tag: 1782500128-443808
X-HE-Meta: U2FsdGVkX1/h0ISKcxs2dEgowALvZ3FwaikfPGrFenjd0U3gTwhYSrb0rn9biRa3ShyqoXeY6r7OJCJsIpcCaLUAv311Ip1zj9f5GxQ7Hzj7kOQ/8/00Eixj0Ysjo+vyonjbD/Z8mRExLiCmwRgrcSlNm2uH0ZnkDXUi1ZN+/0X9Y4+0/LwTw2BsHqzfB4bkI7PcCXqIAgdT4LfHUQtRkE8Pie6iyVh3YuPpFTP2XEtLP/COcqorApAongYmeAli+UhTCJDj9i+EYOWnge+gb0IPjxlyQJNGnxQM+KiI4X7hydJOvvNEtmhbxNfFZ7sbqVEWNQqzm3Pm2vVZc+wmWK1O6zaUNp/HRNjGiHBBkcMmIKlfqYV92S1hPaeZG2A5IUVlj5k6iPggqwitD0MqqhIJWwUJnmjcpbZdmujIPWfEbMC5bpDb1/E0BJCzvZ03U83RXMmlbptu9rkMkfQrkLhAAxxt9hgQeDDdwBx8YccB3L3+s7TeUB7dWfpubHr2kF7MIJ+MAOvFv6ItxKd83EmvVdRW3HyE95dt93C7QnwLuamvohoRpl7nHhMqRzM5RZxOTo/137EUgjbSqUGvpvysKpDhac/hANUcjv3Zz97kptxK5gSzsmmm+dudiprzOvNriYQwStlahUqTiIE9Nxe5eoHHgz+bSgLrXej1R5XkbARzbVhKQZ5ckZPm6PIWB/1b0QYXiYMS+uMbkuUfZ4Fdh43Fj4PzVpFENrW8SUrJRGNNFIeeBFDOCwxntoqfnLN7JsHTerrZHAtz7UCd8M+bnj07pCEOXuoFgmhCWABR3GIY63vaLy75Fjb4bJnqI/rrWLRde0Sn6KrOzdJlx4sdwlGr52x/RasZzm0J5DN8PFPv9hjK7eeAOgYABO+7V9G6xdibDhrtVgKr0YntRVXEV6cEqcOr67E0L/4+mS/KE9/5SLpq0peEJ8aybTdZVBdukRkiWeV2ieMCcAl
 zuwmGsP4
 kG3dD30VCkUql4qO59Pr+5pSTy4H/skq565lx3Sw2soAdd+cyEx4LfREElXuVGC/3ia7hamt1cNDI9gsPc8npNDm145yKZZQZUWXizAYMeaVxXjEQmkFjvUEPZKmr5LqiY3lY6wZ4I3ke9oUiAIMapt/LWYTDobh+wlN1gJNs6cYic3O2j3B8mL+wqQBL7/6pxriNCeKeSzRJbDDo9XA7GPvDHDKFBis4CCqbTniptCJhJj8CyBjkmt36qWVHBMpHxo5Hghl9bHVJ69GQO1ke1f+rl3PMo0fzrmWR1qnISMhA6cKu5jiVZNxlpH6Oof95iLrBY0a65hmJipgo5YCENVTPsBwBpoMhJMZhpHxbZ5gBfWHLx2yjokPOcL/5dcfurIwW6McrNkZmqEQmu9Jbgv6Bfn8E1uLLpj1iRmrVCfaTTjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 10:45 PM EDT, Ye Liu wrote:
> The free_ts_nsec field is a free-event timestamp, but it was printed
> in the allocation summary line alongside ts_nsec (allocation time).
> Move it to the free section where it logically belongs, together with
> free_pid and free_tgid.  This also makes __dump_page_owner() consistent
> with print_page_owner(), which only prints ts_nsec in the allocation
> summary.
>
> The output now groups all free-related information (pid, tgid,
> timestamp, stack trace) in one place.
>
> No functional change except output formatting.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  mm/page_owner.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 958151ccb587..eaccff355cb4 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
>  	else
>  		pr_alert("page_owner tracks the page as freed\n");
> =20
> -	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#=
x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
> +	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#=
x(%pGg), pid %d, tgid %d (%s), ts %llu\n",

Is it going to break existing programs parsing this information? This is
under debugfs, so probably does not matter?

>  		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
>  		 page_owner->pid, page_owner->tgid, page_owner->comm,
> -		 page_owner->ts_nsec, page_owner->free_ts_nsec);
> +		 page_owner->ts_nsec);
> =20
>  	handle =3D READ_ONCE(page_owner->handle);
>  	if (!handle)
> @@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
>  	if (!handle) {
>  		pr_alert("page_owner free stack trace missing\n");
>  	} else {
> -		pr_alert("page last free pid %d tgid %d stack trace:\n",
> -			  page_owner->free_pid, page_owner->free_tgid);
> +		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
> +			  page_owner->free_pid, page_owner->free_tgid,
> +			  page_owner->free_ts_nsec);
>  		stack_depot_print(handle);
>  	}
> =20




--=20
Best Regards,
Yan, Zi


