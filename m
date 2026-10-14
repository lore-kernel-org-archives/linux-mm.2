Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E05C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55806B008A; Wed, 14 Oct 2026 13:23:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2CBB6B0098; Wed, 14 Oct 2026 13:23:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BD56B0099; Wed, 14 Oct 2026 13:23:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A6106B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:23:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 229F61406F0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:23:21 +0000 (UTC)
X-FDA: 85321903002.10.C66BE77
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012069.outbound.protection.outlook.com [52.101.53.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2FCD0180007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:23:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVb1rV2Y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.69 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791998596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pU+Q0ZM+OtCWWIZfUckYUcSDo0oKVok3eFxG30959Fw=;
	b=6q1O9DNcy2P3satN4lKeNjRvJLAz597h/yP8OX7hAXM8DcuVOJHtMZKJY1ERN0vzxLZ2vd
	RoLCz4nxuqcfRH8gGbbf5SDljDLnffDgd/twSoGfSixQsfSuqNFiS1EYsDdvONCEEe1p/n
	ZFOW0ms8K+3S8YNQq+tq9VmVLt2iWpY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVb1rV2Y;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.69 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791998596;
	b=Gs85L889Y8JdkzXis6LoNbwuILOWE7Q1lZeDRn76CSofGSguOJASZqcVv6sptBS/nCn5Ca
	fBc1eq79percTdkzDujwI0fMIfL0leiqlwDrG+8LqCAJBtJkVo3jD9FnLDddyKntIWrxLd
	I9ludrWXg+PxSwxu7jcFXgkwbfdQKJI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/kdN7tyiwnjtlCf1e9V+9vBvyugFIdGz9p/7DeTaGKyeHhC+0/ZT25k5NXtmDuCRtHE7fipqp/SJmxfjfLHIj0z0i8m2inEKeJlj6DwYgPPJZKpn1VdfFYhRy0zCRkhbdBXZ2gmQKAzQPc7TYXX2FJ1F98duHi89EXrqJ9ilZOC2/mxRSLJXR/57e3wY8898FiGTbk550C8JZyqnAjRtBXRqj6ePY4MJHbR4J8I5ooAi/8SywVPfXSP4MozYPRK+A97g3yhssai7309C21T+Ga7GSKTm1rpCIPcstHaOCEU/kKbGy42C0sD5rmzgWtIAX+L75OupEansQdz9X/kDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pU+Q0ZM+OtCWWIZfUckYUcSDo0oKVok3eFxG30959Fw=;
 b=XHqo+ELHVS2bLufhv1Rr6p2K0pjK8YhD81bEhoEwI3E82izUIJoimfmaGq6l5naLlfJFU684TtKkhjaSt9APLhWuU70MeZYacwg2pHZys7MW/HsrdLvTwC4BKWA71AKEFCAQr7toS8h6hqSWtJUliGl6JSmKHQTLDzsTuRTiJCaKVo/5Ah7gGsKzb9dFXUrjQWfpvVPSbzzc7czq4OSh8kttJY+MxUtA3+J5XFywn6S9cQVxm8trUGNh9BzuJ1NwDe653gS91Z61ylZdMGnhFUCJ8jOASoktTj3N2sve4K1C5xeI7/Pe2zOSph3Zyv5LXYn5hjvF7ShQt9JYIugOJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pU+Q0ZM+OtCWWIZfUckYUcSDo0oKVok3eFxG30959Fw=;
 b=bVb1rV2YB3sYdyPeaJ9s7bBe118hWmsUCT60Duj0ombLjLAoxG8YVaoBoIoz0wZ3GnVBF/ldbodVfZtLJdT1bwgh5QsZ0+vXEzl5mMaillUZNvzm6TIJnoYcoCAJE+dL19j9aY/0Z1r+bsVRV35CGh1zilPQ/kdsriq0FfXOoXEEuVlV94XgSvBy7fTuubj50BcH/+WIeURMDndNzoQlv6NlZlSToBA9AWwbz2EOihCHt2k5YHJYAxGmpRLJ1sR9nV6PPp2/MAujZA2C4aLmMfKT6Nsw+AlFpoNRAcZFojd4G/S++GfCyqNmgkLQMMvTQLe4i4Sy6KmiPEg1PEgwWA==
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by PH8PR12MB7447.namprd12.prod.outlook.com (2603:10b6:510:215::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 17:23:08 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 17:23:08 +0000
Message-ID: <52a702a4-14eb-4617-bd29-e3140fd36780@nvidia.com>
Date: Wed, 14 Oct 2026 19:22:59 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC: DMA_PMD 19/22] net/mlx5e: Use DMA_PMD memory for tx header
 bounce buffers
To: Luigi Rizzo <lrizzo@google.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261003212241.3432303-20-lrizzo@google.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261003212241.3432303-20-lrizzo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::19) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|PH8PR12MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: a86ad3f3-750b-40c1-a83b-08df2a17d09d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|921020|56012099006|11063799006|4143699003|261009223027099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Jpc7nkYl+/Q2vfpm+rCIIhwidKrjEo16BaCm2gD4ay+fhx+f5FJBsJjJpsBHRt7AW+tOzbp2lL4wUDzHya0A3ZScVRreeKscojdhh/2Ke73mGgwBVLRpRoSJE3TOlMJrsFHUvuZvk/4agPLe0qRo8IA3iHSdxKMk++4ZWyYqatvfy0Mp2D9GZibIjom4fqwqwEBKw3hC4Dyr7bOecJcMu2lKVQ2DX1cTfQfAX5+9upmEa2q5rNRZzvpOPJVVE3VQI2+IEXW+8+lgemyiu09kiO6Zydt1gJp4KUBejTzChltSakVPhsYw55syVgHr5skaW5zVwEl4mcmY0277ZKVRWtZW5uAnzwZDLlN6IoCpDXSl2Yc8/thp9Q1n3hx3HD/0M5iA/8ysLHhfcBZuJAa6vCAQ0/+o0EbvxD99XGzx8YANaejBymnA0hkrl3SSbauNjRO1tzw7eG9xCfdHTmbPE3JOw84IC15oPYOWG/5fY2poGNpJhqnpRXCFEm5YrD6DYs/mnkaKrJfu32ZhqWxxMaJPsnLm8FIoUIo4OFahLwHWnTcvvM6GEbYLXLImijKDG9jVfW8gLJt+kDTuzwDenHLCPaY7CZ8GCg5VTJaIvNF2mR9Wsb1QNdCr5V+MXTuc505leevTZNMBiZQFrUj8S5Udn0gr6Tep1m+kQDrVwCIDR9Vgq4YmPzooCJXFC0syy5ggRjh7br688FFNjCueOA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(921020)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTM2WWhDZDdHakxBSGtmNDdibWtXYmxnbHpDblJJVWpCV251aENJRDFCbURk?=
 =?utf-8?B?ZVp5NnNYMUVXS1BKdnVsVFc1L0NocnNjdDVWcVliWFRhK2dvWnoxWDgvT29Y?=
 =?utf-8?B?bHhuSGV2aTYrY0d6R2Q5RHd4NXd1MTM1NUl0Si91V3MrS3lKWFlvdDgzaDB6?=
 =?utf-8?B?emRzbWFQYmIwNWUrWldnNmZBaGVwZ1R3L1FxNmREVzd5REtkbUdCSTFBZERu?=
 =?utf-8?B?Vy9hcy90cDNsMURzRStqeDdPbjdnWDJWQmZHeEtFZUM2bm1KOEFod1dyTFFj?=
 =?utf-8?B?Z2EwMWFMNUthbGloTEhwOHF5WEJCcTB5ZnMwOFh6V0t0ZE9RSXFFU3JoMjVO?=
 =?utf-8?B?KzdGMFVlTXd5OHhjSWRDSURrQmpIZHRoMzlVQU5yZC9TRzFvaWowK3QzeVhm?=
 =?utf-8?B?d1liWis0RVhxK3FZQVRwZEhSaU5zUy9CTUs0bFk3ZzRoZUFyeXQ2Si9LN1A0?=
 =?utf-8?B?VENxQWpJbjBSSk5VMEI5cllnbHRYY1pYcWZnb0NXcTdhR1Fpclc2bWRyck9G?=
 =?utf-8?B?YWlUWXZ1OG9tbHJudGhXMGhFR0VuZ084VXdOaExnMkFSV2ZBd253V3d2ZTJU?=
 =?utf-8?B?NlR3aWp3ZU9CZFltRklGalRNVUdVZG5GWWJHOVlUU1AxcGRlaktkUmhvY1FI?=
 =?utf-8?B?NjdGMjZqV1I1eTJaaWMrTnRTeXE1cnhzSmFEMFpqNkh6NVZEVXJvSzNwdlVJ?=
 =?utf-8?B?OHdhQjZiUjhnamdVV3BaRFl3VFRjMStFd1c1MDVMVmFtUkROWTJOTEcwTUxL?=
 =?utf-8?B?ZmxSMGRBUFNjVXY1eG1UQ1RSUXJ1ODlWeFBHdE1PbTBia29UbmdjZkVpT1Qv?=
 =?utf-8?B?V3RXUTdCdUQzVDMxVC9XQi9SNHNQS3JmUnJnd3p1UG5reEp5bjhaaGdjSy92?=
 =?utf-8?B?bzgwS1FXYUdkUFpnRVpMeHZGSlh2Nzg3WDk4RzllQ3dDYkd2eFlvL21MUEls?=
 =?utf-8?B?dDFTOXM1VCtXNHF3aDEvZzEzUS9xVVU0em0rVktrWVEveDdHUzVDNU9DcnQ1?=
 =?utf-8?B?QktTWWFBc3djT0o3QkQxajk2Z3ZoMVFiaWtleDFrL3E1V3ppRHU4WnpwTmtE?=
 =?utf-8?B?UXhvSFZoVS80MC9LekFtelhCZ0Fma2hqM2dKcHA5Ym03cDZJVTdkY1RPdlFC?=
 =?utf-8?B?QXpGdVFYVERvdHBiMEpncjJRVmNvRGx5cFFyNEZObnpmZnlSaXNxUFJudXE5?=
 =?utf-8?B?Q25vU3JOaTBzdVo4YW1jaWVuSzNzQmt2TXM0T3R4VGp4RW1TRUk5S0RmKzVz?=
 =?utf-8?B?VVRXU3FEZzRXbFoxcTJVdTZDSUptVnBueTdNMkJIVjI1R0hGd2t0N3ZDdWpV?=
 =?utf-8?B?eTJaTjlZUlNacHZ0WkVrVUNGUmJMVGNGNjdoSnQrK0QrRm5OQlVXN0tnZ0hy?=
 =?utf-8?B?Q2NlQnpReFduWHVsRXBIRlU1RHBlK3AwYjZQdmJxaTM3UVA5SmpPU1B1eFor?=
 =?utf-8?B?ZVNraUMyUmRkdk9CdVJrVE0rRUZITVZQWjBMOE1MY1lodHllVG1ZekJreDJQ?=
 =?utf-8?B?Yjl6SWxuZzdsQ3FpOWdvdmVwdFRZZDVCUG94aDNyZWs4ZGtaUCs1UnpHSzVp?=
 =?utf-8?B?S1RaY0hzdStkV2c2Qmh5VUcrN04zblJINDZVZmpnampMTU1nN2lOODRIam93?=
 =?utf-8?B?d0xNMTBuK0g3UFRWT2tGNFh4MWplVzFVNXJNaktOUU5nUXA0UFpadmt4dlEz?=
 =?utf-8?B?K0Y4MGluWHB0RXEzUkRkZFhnRURVNGNDaHBkeTZzOEI4dE01QlpSdytIZXlY?=
 =?utf-8?B?Rm80ZXJvRWNWSmtEL3FwQlV0ZnAzMnBKSTR1TG90VkxJN3pWZll5RGdMbjM4?=
 =?utf-8?B?bkhGRmtDYmUrcXFpUStLU0xiRG5UVzQyQVE5S3JVK3dNLzhCL1hqMytacVBz?=
 =?utf-8?B?VTlUbzRaNWM0VWwvZXZ4Z3labDduRXhvNjNYcGR1V3IwSGRpZ0VCUm40Tjc1?=
 =?utf-8?B?RmdHRzFicXV0bU5ydndobzU2czhMYlY1VzExcVVnVnU2OVlqNFpUa1Z4L1hK?=
 =?utf-8?B?VGJkSjdkbGJUbkpMVDFPT2NkVlNhaFVGMkc5bDRwOXZ4TkxDYllLc21mcEtC?=
 =?utf-8?B?SkxKWTIxTnc1M0MxZU14US80UzdrcG04YlV1VWx6Sm5DMlJhUi8ybGROUUxn?=
 =?utf-8?B?TFE5NjFTSDZRSm51SWYvSGZjSWF6azNSSWRBejc3Q2RtV3FLekVIODRUbUFx?=
 =?utf-8?B?M0ZRUkNoZmFxRWtzZnd1SktheDdJMXlYMEpqZ1V5eUp1emU3ZDc0MlhRSlRu?=
 =?utf-8?B?a2hJQnE5aWkveFdqdmFQby9kVlAxMXJGUVFoTHdwR0s3RzVRaFhsdnhlZDlT?=
 =?utf-8?B?RGl5UURjRUFveDU5SE9SN2VFdmVuNUI0WXQzVjJzMmkzeE1jNENsUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a86ad3f3-750b-40c1-a83b-08df2a17d09d
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 17:23:08.5465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cxCQXw2m7xsnSltg+bUip43cPkYNIDDR7N+YMg6s9sCmWbfKhDnJfDgc4P2tt2d09kO6v5Rbpv9o/iMkz/qLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7447
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2FCD0180007
X-Rspam-User: 
X-Stat-Signature: mo1wy4q6xd33dsfarmusipoyjgh9gnpd
X-HE-Tag: 1791998596-576228
X-HE-Meta: U2FsdGVkX1+SsJLKQm4JGp9eX2g6NSps55ryEZlpzqDtE3nMavBSqy7pzs1hQuDU9ncvCBZRf54QXNKvmip3z2uDaGeHL0Mg6IzGHLA1AmZnB60VtNVDZKJJrsVGFU7nD58ImYTJMHrMsjYwU31P8Q1SCytKpfinyZShMWxFNNihVIEH9jyXZ4kTm7g4hJ77N84bCnAAHXCeOI4UWzAICf/0agmcnbXVTjDXGg5FN2QF/EHOE2FgTvQ84Jm+ogY23uylPZnmdwWtEYo+NSG/C2uqYOsi3XPWty/W/UYkLlw1OLtNJT/vnVXPpkpZcawV/0Dmeea6DyvneV93R6TjFKMJ5MZQbb23MpsX2SURP0RphIZUYJcgciIgK+LMzhSTNT5yhyt2Z4iFPCpHC2ovmAibpssIcE1xpDiI4bTr3jZZxQt5eOOu4js7E4LYlNAr6vuV5SrRlbLLMEb8ODMK2EfgHPPfcBQmoQQC7Dvb1GhIpvk8HP1VkSqUmBwvyVUztU7HJM7H2LzuZYDJtF45tNSwWZYni6oERHfXTvxjUHnjOXkSus20hmjsP3h8jv32BxHwv5ceSz5jPe/9cnulwLzwop1dyWYB/glVpKa9miz4IPTalwvMyiuF169Y2jpmwnAN8ChlRCkWANvww9k+Hm+LuWrd06SDEBU3TVGLjy+D49/XeUAGrR5k41+CPiFoJmFuItxTI7mjS/bIyOQ3a3ZANUPq4UKAu1sOi9MMtdbIEspQuN1n2VLRb1miR6u/Lnjg4VioF+EPd9aoS7VwLd5cVqpEiCBnxbhlNTdVrnh1XHdXSO9X5lATbeRPLl5HffAq89xqRxXHYamok2bI4OnLJD9SFPocNXrvuBgA+8TtKyJSrxu4Fzihqcgm2H8yqrEiKZPnebNsXb9kT/UITPzCyxOwi9Emqqyfx5A+bNWpW8fXlPjFINAp6YFmHn0oyyM0CbvrfYLW/Wls5Fs
 TJ5/4rqK
 vsdRc1WNgxLY/HXub20IdAtcKrdVQee3JX8L0vsfLKXTQVMH8z/EBpL/w42neOS7o8o6wbF/euVD8SxxV5tTtAk4npwSJfnr+RZdR7iJhz/tHYRJFriNwuOPushy9It1fwoSAQ6Mm1h2+VLfTDr+j79/X1XMi96Nfu4i/uPfcDJLsQZGSz6ZrUCj1bTJRRYjIoC7wejBd54JGJVGWQzDx5Li0eisbT0rsNzcIEJ2oPXbmRgbALTi8IUW218x/Cj+BzagT4qqCkgLmd0UcEz7xdjptqjw0dO+kmt0X/2b4empzrn1+8300tk3tmZoxfTpb0u3b4Z471m7DKwODE2GfG+nENbMpaMsHXOprl93y6nex6FRgBP+Jmkx66hEM7jOFWPO5+OrU2i++9WzxIxxXrKxGdilgl2sMP8SBQnNThPFduH2D4yjfoQzRZs6nVE4lYsZxP57y4dmy3HxpXDocatb1yAljwAX9IxDLFURuX2dCHv47oxg0Buxt0ieOlSwVFKk3zxQw1AJVDlBZjRA3HROx9zKvMreWd2486waxR7xSVOAdfo8+bGq3UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03.10.26 23:22, Luigi Rizzo wrote:
> When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
> bounce buffer per TX DMA FIFO slot out of the DMA_PMD arena. When the
> linear portion of a transmitted packet is at most MAX_TCP_HEADER bytes,
> copy it into the pre-mapped bounce buffer instead of calling
> dma_map_single()/dma_unmap_single() on every packet.
> 
What is the difference between using the DMA_PMD pool or one (or a few)
coherent DMA (2MB) buffers allocated by the driver?

> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++-
>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++++
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 28 +++++++++++++++----
>  4 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index a3945195f454e..d762ad1c1ffaf 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -442,6 +442,8 @@ struct mlx5e_txqsq {
>  		struct mlx5e_sq_dma       *dma_fifo;
>  		struct mlx5e_skb_fifo      skb_fifo;
>  		struct mlx5e_tx_wqe_info  *wqe_info;
> +		void                      *tx_hdr_bufs;
> +		dma_addr_t                 tx_hdr_bufs_dma;
Why are only headers considered for bouncing? Because they have the
highest mapping overhead?

Note that TSO/GSO packets will copy the header inline in the WQE
already. But not for small packets.

>  	} db;
>  	void __iomem              *uar_map;
>  	struct netdev_queue       *txq;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index f2a8453d8dce0..6de7a2a430d72 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -365,7 +365,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
>  {
>  	switch (dma->type) {
>  	case MLX5E_DMA_MAP_SINGLE:
> -		dma_unmap_single(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
> +		if (dma->size)
> +			dma_unmap_single(pdev, dma->addr, dma->size,
> +					 DMA_TO_DEVICE);
>  		break;
>  	case MLX5E_DMA_MAP_PAGE:
>  		netmem_dma_unmap_page_attrs(pdev, dma->addr, dma->size,
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 4c6060d54fbed..efd766aa43a02 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -1666,6 +1666,13 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
>  
>  void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
>  {
> +	if (sq->db.tx_hdr_bufs) {
> +		int wq_sz = mlx5_wq_cyc_get_size(&sq->wq);
> +		int df_sz = wq_sz * MLX5_SEND_WQEBB_NUM_DS;
> +
> +		dma_free_coherent(sq->pdev, df_sz * MAX_TCP_HEADER,
> +				  sq->db.tx_hdr_bufs, sq->db.tx_hdr_bufs_dma);
> +	}
>  	kvfree(sq->db.wqe_info);
>  	kvfree(sq->db.skb_fifo.fifo);
>  	kvfree(sq->db.dma_fifo);
> @@ -1690,6 +1697,13 @@ int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
>  		return -ENOMEM;
>  	}
>  
> +	if (sq->pdev->dma_pmd_tx_hdrs)
> +		sq->db.tx_hdr_bufs =
> +			dma_alloc_coherent(sq->pdev,
> +					   df_sz * MAX_TCP_HEADER,
> +					   &sq->db.tx_hdr_bufs_dma,
> +					   GFP_KERNEL | __GFP_NOWARN);
> +
>  	sq->dma_fifo_mask = df_sz - 1;
>  
>  	sq->db.skb_fifo.pc   = &sq->skb_fifo_pc;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> index 0b5e600e4a6a9..3b6a7a8b0128e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
> @@ -177,6 +177,27 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
>  	return ihs;
>  }
>  
> +static inline dma_addr_t
> +mlx5e_tx_map_hdr(struct mlx5e_txqsq *sq, unsigned char *data, u32 len)
> +{
> +	dma_addr_t dma_addr;
> +
> +	if (sq->db.tx_hdr_bufs && len <= MAX_TCP_HEADER) {
> +		u32 off = (sq->dma_fifo_pc & sq->dma_fifo_mask) *
> +			  MAX_TCP_HEADER;
> +
> +		memcpy(sq->db.tx_hdr_bufs + off, data, len);
> +		dma_addr = sq->db.tx_hdr_bufs_dma + off;
> +		mlx5e_dma_push_single(sq, dma_addr, 0);
> +		return dma_addr;
> +	}
> +
> +	dma_addr = dma_map_single(sq->pdev, data, len, DMA_TO_DEVICE);
> +	if (likely(!dma_mapping_error(sq->pdev, dma_addr)))
> +		mlx5e_dma_push_single(sq, dma_addr, len);
> +	return dma_addr;
> +}
> +
This looks like a form of tx-copybreak.

Thanks,
Dragos

