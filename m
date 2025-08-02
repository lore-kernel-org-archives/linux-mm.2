Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575F3C87FCA
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 01:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BCF6B007B; Fri,  1 Aug 2025 21:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35F66B0089; Fri,  1 Aug 2025 21:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6FB6B008A; Fri,  1 Aug 2025 21:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA1F6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:17:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13E3C1144F0
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 01:17:28 +0000 (UTC)
X-FDA: 83730054576.03.6DC1417
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25E2EC0007
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 01:17:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRZkAm0I;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754097445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9DnfheUUZ+yoUESqsi8NnKPr6uBgpMVP2SMPmlUR6dQ=;
	b=d7K1LRrv6cYvk0DuzCrtX0+382U9NIilViaJF6lht9rXmXeVZ8mlFT5XvtY+h8Z7L9J9vN
	8ev0IW0eDgeRM/KH3wpB35iSrknAbCsIQbPUv8MEP3w/u3j0ty3uJfE/8wKdNIXCn+xSRv
	2Jr59XRt6fKZ01ae9JGy0WzMFkWJtsk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754097445; a=rsa-sha256;
	cv=pass;
	b=E0kqwgDeVqAcsk8msPikdZNLMi6cQg/4hydIlBP5LvhI9JI3qSzbdY5B+C7aAGrR583Tck
	eb+rsiegB33uLakgtM1s73OYd7XEepEPBuj1jawaVEO8eo10w0+NfeiwZzUOE/X++2Ltp7
	fx2AEzniAWuGo3pAPs7J9Tf8MM0CZxM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QRZkAm0I;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.96.43 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QggDrJDlL2laSFZ8nBsi3sVqviOOkJixmQV/UD0y3wAbeklz6o9iSfRhw+lExokLIQLQYbuXhxl9jmn/DYIHlZ/6Q9r2JCLmFPwoLXYdqA5HLC72Yuiwnx4b/fkc5fB20iyWrrzWYrD0ELa+KI0plI0fWSI9rGjaNKVR33YrteEfcxxWhIN7Yv32uRtT+LpUib1K/uc190rYL+DLikSTHFQvaFM2k652owsx9Q4CFbwdsrdSE9RfOYlaf/Sq3+/adzCm8gPMeVCG5MuGQRYYv6yNhdqYUsuT/5Zf6miUJ7TfwKsoeRSJwRcXXHNDqduhfYX2ab4DobLHJHYCuDWlSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9DnfheUUZ+yoUESqsi8NnKPr6uBgpMVP2SMPmlUR6dQ=;
 b=gJlhrFta7d8qMxPaBelb925rS5GnJ+mK5C+/FgWRG35nvIJWv01vqf4LqrvouqZr7xAPip92yr9uSA8g0Q8pu5X4h91TeMzNbc/rSQwjV6ZpXzVQdRM+/zb1Lc3lxh+ZAD57my+ER8bW2OdTKcqBOZLTan2CjmKhCev6zp9fICRzVAGI3IyJXyhE37LPIprsAKd3R2Zwf8uaTPkxPeiiFED/v/wZT/4AGpXzx+6ZmhHmc2Pi3hewlM70bHh/jTUZ3EBuyrToskmkT9/kfh0t2I8MzK866s1vYLPmhgDo4G8HfHHH6gp254B61dQxh1JmARRCBLMmeZCE9FOS+CcyCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DnfheUUZ+yoUESqsi8NnKPr6uBgpMVP2SMPmlUR6dQ=;
 b=QRZkAm0IAYvbMuG+Ri+9USKUYVwzZSN1nXfNo/0HCXFKEjMJ+PVUp+bu/ljM1njBO3ud/gjr/WdauAki1H/zxHXXiGUxXVOba1CMUDJ8d9MNgllG9cFA+da/0SZq+z36yXI+jJRx7fchNdxg7yRiXe4gR3N19Cu8pDIppKGQQnbdwikd/dJ6MGUXFJ3JCATw6OdqIEtv+AJC8K6ANph8H2rl7Zw1mcTeJnR9Is9VI/DYFVQF8gw+CTazKNAC0/ev6rf2MLldB1bLcMh0npxXgpoK/dknfbE6ASEzVpLSpJeyARC2cojwYYnyEcSfZixtXyJ9eSzwPSwb7/l55M5beg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB7258.namprd12.prod.outlook.com (2603:10b6:510:206::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Sat, 2 Aug
 2025 01:17:18 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Sat, 2 Aug 2025
 01:17:18 +0000
Message-ID: <3dc80c0d-a2be-4222-a578-4222326f75ce@nvidia.com>
Date: Sat, 2 Aug 2025 11:17:11 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
 <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
 <e5dd3f46-c063-45ff-8be7-64ac92534985@redhat.com>
 <71c736e9-eb77-4e8e-bd6a-965a1bbcbaa8@nvidia.com>
 <edbe38d4-3489-4c83-80fb-dc96a7684294@redhat.com>
 <e8f867cf-67f1-413a-a775-835a32861164@nvidia.com>
 <ee06bd19-4831-493f-ae88-f1d8a2fe9fa4@redhat.com>
 <47BC6D8B-7A78-4F2F-9D16-07D6C88C3661@nvidia.com>
 <2406521e-f5be-474e-b653-e5ad38a1d7de@redhat.com>
 <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <A813C8B0-325E-44F0-8E30-3D0CBACB6BE1@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0132.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB7258:EE_
X-MS-Office365-Filtering-Correlation-Id: ced4250e-4e98-42f1-4eed-08ddd16252e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2QraXhuYWlOMFNHN3F5RnZPTVFSKy9HTU1oeTB5L0hRbmlvS1NGM0dRdThV?=
 =?utf-8?B?U3hoYUM0bFpUVWNocmVJaTdZakpzMjlLVWNoUE5remxIemQwaUtGYW1QOWU2?=
 =?utf-8?B?ZEY2WXczSmF1Y0xFNGpucUFSM2JCYXNFZ1NrVVpUT0tUVHNCYXhXTkk0V3A3?=
 =?utf-8?B?Q2NHWEpGVE4walcwdEhmbzkwL0tac0ZGSDg4emJYVFZySUQ5azV6MmU5V0Rz?=
 =?utf-8?B?aVQrMnVYQkxUc3drUjRzODQ3eVVQNjBWZTJrS3VPUEE1YTJVRW1ITVU4bEJ2?=
 =?utf-8?B?MmltRmFYOXdmLzVNYnpzSUx5VUVUTXBHZkJMa2xMNlREdUNXTGpJQ045ZjM2?=
 =?utf-8?B?K1NGR3NBWG93M2hjV0JicjJ3UnNRVTlvRTV0K0JQdmhSeEIzTHVqRk1XSjN0?=
 =?utf-8?B?V3BlOHVhVHVzV0ppMVcrUG5xKzZvcmhlSWFNMlJhQlhmM3VQQzI4VUJQN3lv?=
 =?utf-8?B?cHJscW8rSE1JdUhsc241QkZiR0NtZTlTQi9OeTEzQ3MxTTBvQ2lIRGZjM3Az?=
 =?utf-8?B?ZndCRHFRaE9USFF1a1Y4WUYybU5IQXNSZEpmUXJKVDE4RG5PSVBNbFgwUkRH?=
 =?utf-8?B?V0dBd2RJNnJ2NVNNOFZyOGhqOW1WYWtqUzFFdTRPTzFjTzRjYkZYdi9NM1hz?=
 =?utf-8?B?aTJtSi9GaGxWR3Bib2dtMXRUVWN6M3NLd3VYQmZJUk1TdndyaC94ZVFBVVNo?=
 =?utf-8?B?d3doN3hZTlJHQjFuanFkT0tIZk1DbnQwMTRFOVNvRTl5MFV2QXE4RGM2SHFn?=
 =?utf-8?B?YmZqdmZNbFlaZXpOZkdXc2JDZGlTZ3RIRnNnQ1g0aTJmRkNqL1BaMG1vOXpH?=
 =?utf-8?B?eWtSOFpTMHF0VlJtTkJMeUZodnUwaTlvdnUwcHVMSlNReUhwTTJOUmU0MlNQ?=
 =?utf-8?B?aGxwUnhaSmZYaHpicXA0QlV1bTlvbkQ2em9RUVRYMEUwR0Y2b2dPTUZiRFVJ?=
 =?utf-8?B?Q3RjYlpFNHdpU09PenVsNzRVY2taK2VmSDBHTzFPeS8rTnZmVjdSVDZXQjYx?=
 =?utf-8?B?dVRocUtwVVhKejVoS3BEa1hrU29RVlhpQ0EySEZZUHNXWlRhcXhzRjVYZWN4?=
 =?utf-8?B?YS9xVndnZ0lGakF2YmdRMHllcDFaUWFxaXY5UThJV0I4NTlrTlQwNFlRV1ZU?=
 =?utf-8?B?L2V0cjlrdVpkQk91bzcxeEhrbEI1OGdHTnVkM3FUR0piWTg2Qkhyd1VDbHBQ?=
 =?utf-8?B?RUZvcTF4RkZob0pMZThHUUJ0OVRjNzMrU1FVV1JOMWMrSlY0bFNBSDVBaGZR?=
 =?utf-8?B?dDhTZlFXVS9rcjFxaS9hT2NKSGl4MW90bWxkeVJ4WFdYTFV4RG16Y3J4SCt3?=
 =?utf-8?B?dllMMEtkT2h1cVJ0YnlxcDNYUHFFbVRSeVR6cXFVMWZyMGZsMjBwdlVNMWJM?=
 =?utf-8?B?VzR1OWNBTVVjR3daUlBaRnBmOWlvbGFBSk15Y1BlSHByV010TXJ5Zmdxcm4v?=
 =?utf-8?B?Y2pIMmZuRVgvQ0xSSHVmL05VWHBsRVh4aFdyN1hiV0JNVDNER2tKaEFyVkdx?=
 =?utf-8?B?VjcrNzZiTHNWTGp4dWZNbi91VkhMTGRnWlU4NVM0WHlRL3k1MFpjcGN5VjRQ?=
 =?utf-8?B?aFFabmk5R3hQSnU1RnY4aDVvb240YTZRcVZUUTFVVHRCMFErTm4wT2Y3eXpO?=
 =?utf-8?B?SWQ5Z1A0WkpYb05XNlBJcE1oZmJvV280ZjdKMUtwdHg0TUdlNGdSUHBESHF2?=
 =?utf-8?B?SGJVSVhORjJNUkNERWxTbjR2TVI0SkMvUjJPYm1FQWIrU2I4ckF1VlZmTVlu?=
 =?utf-8?B?amgzS0xpTG10b3Q2d1I4SE81b0w3QWJ5MkZDT1RTVWQ1c0VEbWM1d0t2VnpZ?=
 =?utf-8?B?OGxzY1pkM1l2V1lPTDlKT3kxWmsvcVdxTzBraEVGcnZxTGZxUXZQTGNuOUI2?=
 =?utf-8?B?UEpXanlNVDg2OWpscllUcnh3eDRvRm9zU1g3RU80eG1IWnUvVCtPeHcreTZt?=
 =?utf-8?Q?ZaUFnze9an0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZlI0WlhIaFoyRi9MWTIwZU1hSGVPb1dpck9KRTdQeUVsSWFnUGdkSWdNd2Yy?=
 =?utf-8?B?QmdCbjBnc3hYZ1laTElBRGdBZ1QyM0wvbEN4clZ3YVJGQmQvTW5lSFloU05T?=
 =?utf-8?B?aUw3emtFVUlTVzlyK0VrMUhTUURsazRjdEdqcXY5bTM3VkhuOTV0RDJSZGVw?=
 =?utf-8?B?YlN2QzBXYS9MQVdma1g3enE4TWEwVW9OT0E2M0xZYjlJOHZmTkhnWlJPeFE3?=
 =?utf-8?B?eXdoZ2pBQ28vOUVPa3JSOU1IdDhRQ1p1YVpDbk5CTWVZY2ZscWpKWGxuZkNV?=
 =?utf-8?B?MDBRenVoQ25BT2Fjb0RkL2tqYzRkRFhNVm0xME9aRnMzVFZwTGoxL09tMzJr?=
 =?utf-8?B?V3hhdU11ME1WVXdHaisvcmFrWFNjWVRLVnM0SnJocitQYmZlR1E4MzJHZWc4?=
 =?utf-8?B?RzZZMGlWSzZRZ2c3NmFPaHFoOGpQNjhzWlpwY1VxSWVnc29JS0JKVEdZNzM0?=
 =?utf-8?B?RURkMzA5Snlsa3pKMWxoU0l4YkUzUTRHYU1temdPVm43dWtFbGxoank2RlM0?=
 =?utf-8?B?ajQ0cXFJenBEWk1ac2NrL2JPZlZJaC9pV1NESDlybndRQmw3K0ZVS0dIVnZx?=
 =?utf-8?B?T3RrTlVOdEpZZS9kZUZHK2FVTWxydi9FVW9PNkU0NEVhRkpMU1dtb1gxWk4r?=
 =?utf-8?B?Zm9PSitpcllXNmhRaWpyd1A5d1J3OHZEeVN6QUU5cW80RWthZmxJdkRnRVdQ?=
 =?utf-8?B?RURqWjdXZk9JWWRheVJOVHR4QlhvYzF1U1hTemNROFJ0bUhrYVNhOEpBSlh6?=
 =?utf-8?B?bVFYNEVTckhuejY4ZVdSVnUwdGJSNTROVjE0VmJKY1I3SzlXSEdCZlJ6a1lj?=
 =?utf-8?B?MXRtelBFVVR4ZDdUanlnQ0V6RkxLNktnQnY5andudzdtcmh6Mm5BVjgzL0Z2?=
 =?utf-8?B?U3pxVmRJcDdqb2VQK1NxbDJJY1BaMzBhTXZCRTAzMlBHYWJmM0F3ZjBZMVQy?=
 =?utf-8?B?ek9SK2NjeU5YWHYxM0NXV2Q5aHRUckxzYnp5WUw5U3hNMzBheVVOSHYzSm1j?=
 =?utf-8?B?T2FuYWYxc1hJcWt6VFZRcDNYbGFwKzRLbC83bXRocEp3c1lPUDBDWVp1clBk?=
 =?utf-8?B?U05OakpINzBNWEMxY21NTzR5OGlyQUlwZStBdjhLeHg0VDdHd0ZhUFhPTWVp?=
 =?utf-8?B?Ym4raGxCWU1wZ3lNdEZsVEZlT1FzS0ZsSEp4aWZUQXc3UCtPU0FIWmNnQTht?=
 =?utf-8?B?TWVHS2kvMlVNVjNpWnFjdk1YT1ppS210VlFBejJoN0E1U0cydm1wdmRlaXhX?=
 =?utf-8?B?cldEUGRVU1I3M3FSK3F0NnVURzhoVVJDSGVrWENuWmo3UGNuQkRQWTkxTG1i?=
 =?utf-8?B?TXF3OEhxdm9XcTFDV0tEMmgzemJyTXJBUjNjR1JVZjl1N1JleVk5UzJmMEk2?=
 =?utf-8?B?WXZSVVRMTE9KK3o2aTcwUUJHR09ITzhwd3lIbzJZSFlBaVE1Nzk4SDR0OWtE?=
 =?utf-8?B?SUpaVkVJSXFJWUxkZHpnT0p6ZWZzSXE5QnBCTGZKNlI5NHVtdlpsY3crLzRZ?=
 =?utf-8?B?aHUyMXZ0Qjl5cHVTV3IrVnFBYmNLMkw1NTdVUTVFbnMxR0RPUXVRZjhjTFJW?=
 =?utf-8?B?SVI0cXd1OU9XWjR2RWFWNEhHY2xGSVp4RndPZW9BQ3FudXRiTVFlWmY0UnUv?=
 =?utf-8?B?MVZOUjJ3elFqa3E0clcxbGN2N1lqbDZrWWV0TXMwaGZOMmxab013L2VXeEpa?=
 =?utf-8?B?TFgrVnpxLzEvVzVVYU1YTlM5VkVxRTZOU2ZlRi9qT0ZtZ1F4eEdNOHdNNXNn?=
 =?utf-8?B?YlJ4eGpRd1hLV21WcWp1SUNwemt0VWNXQjVIOUFMVU4vTzNVRFdKWVY0SXk2?=
 =?utf-8?B?ekwySmNaNlI5L2ppaFRJSXI5M3BKYW11eEhUUWlwT3Fma0gyc2VnZy9aTUxD?=
 =?utf-8?B?YVZScHIweTVRaUE1SnR2VTZIa3RvUytGcHczOXVYY1l1U2ZQdUQzVU1mRHRh?=
 =?utf-8?B?TXRqV1dGNmgvQlo0b3Zsc0VhVmNhRFBLUVNvNnVTNEVzRm1PRHREOUpZRU9Z?=
 =?utf-8?B?YzZ5YndTbDVKSStkYnh1dnpJbUxOZG1tbkFuSjNuUFFqQ2ljQU15T09wWlBv?=
 =?utf-8?B?Ym1GQnBjTFlqbXVqTTJrcEpKTjR1WnBWbW53QURtSDFuQjVlTVp6N2RvSGFp?=
 =?utf-8?Q?K3k4rORWIPwESZt86FL6iAZ8V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ced4250e-4e98-42f1-4eed-08ddd16252e7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2025 01:17:18.6356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csdCiMVpluNokHIHIOaAK9DkAyW59LkZHazLGe6EoYuG4kI/q8WuwNli0sPf7TtZPJd+8gT3e2DES4sITREk5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7258
X-Stat-Signature: zzs4y4q65r6ex564818knyncak4uz9pq
X-Rspamd-Queue-Id: 25E2EC0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754097443-671422
X-HE-Meta: U2FsdGVkX1/BL+tun0EONW+xOIaddnXCqN18XpfoTrvOPCTtCqyGpeS9f1ivOonDN2FNVTBI7XLNhaiNDBfb7NWqwcw8JaJzpzrKGX0cnkRRe8RwM29MA3BfQrjc0IZQjcPaVYoSuFG0ye8kjumL04JPC5ZvpGosYZfAAGtrdbllmHSmF+NQfSORhXGhn5m0wZNX4Syzzt9F7v+yKel1AHc0gxkdV4lfbLA+cUVn0ueTeSkv0tjwXJPz1Jxy3T2C4asZG0D3qT1+BWAR3WbCjLCbQFSAUaFenDxUq9KT1lQVu92KJMnUFAqB9J9540GYWx8Q1l7kZa/RWGsETqM6tME+4KunsbY/zB6ER7PQXnbvaCUFIbQXhupnSfjr0bRLoNsxcYlymXWrFHVwAJOwV8cab+QNNtZMOrrKndLhxTG5MEUZola8PxzS3xVgWnrK9myV7ZVhE0Mo8QMxR7IuYs9CHEu2m1C0Tvcf0jIU9IsdBv/A+OOsS6AgDnHQHSHWLMS3xHwZRrnkajeOQUHmN5/ej/9duEc4GEXzIv6vdmcGon6QTi0EOcVuqB7LZK6GdfQSC3MRW6EdEXuUuSIKsGaF9QleSka6BxXrcBl12EL49iKXwmfzmtL95ssbzgwvtJ8G+LHQ7d74RZv9h1zPW+A0nutEJ9D66WVL9L0okQeBC8za1x+tZDCL+3RfaQGQD3JsYUeZz+yLnOCu6n5geyvhvWujxsZnC/7WdPFCIIj4zxUB37IuQl72zv8WA/uiUChGkKHsJ3lHJCxZGmGCOofd+e47gBC5pBW3HX2JCtAVLGKfeIlFU98ujYBc4O4l7Hg1lHGNkHRVZOk57kps6BnjxnbaZ6ZgI5FnXJ5h+ofI2WcB9K/IcxhQzmtTYCgB8xI4XIEkagOR1z0Ht4o+TKSzkHXrSmve7LFnnbS1Eqvs2xtmdpAo1KV/l1QRDk+I4Qn+MyKWJYXAH7XXulU
 ekqCaAj9
 /YjbcNaIHtTeJwnpN9HoZpLInQ2Jxiv9Qkbi2CRYGRd8qqR57RwW32NFMVuq5LApfE2ACZ53sq+crJQ9D62VP/Lzzv/V/vc86R9krGSDxnMQyiUq/R2aoikRQ9R0IcFwu4Gw7pD6LrHFxDGrYGy1KEbFHVuvqvmEa2TkOrNe7kUpFB3pbDIqSCXXcTDQSOS+p4U6k6brDElR/tpVJtRecfWtEElhKzUMA0eGcNIGtxWW5PQfkMx+7H7nEXKyajUay/lH0K8kMG8CseDgdoJlmkWCp3/g3uHadJNwViFcShP+KDRCHPdITdL5GVYx1xeFTQh1Ul+LpdTtEKJwgm0JLLesXmLP9H6uTOcN4zHKZUHmtTIYMdA0SRFOJnvmI6FdD5mpTYRtZUauHgDBRbMdUZWiR7Kl0avEOCBaRTc4tjUTgsLraLGvdvwukIr9xRfxmAHaFnL5m5tIA+yDX9tpfjTZq/neJiuorgTXSMGTR3RL5aA/OiJ5f3YpeCCN1di5ugCBNpZFobM8AZZWIVKbevmYNUom8WZYSgazLYxnHtkZ0CvetHoNjzVhcgbtcW/EZXdSBCyx9xdquI7pElWpxDjMRZr5pzNMXKJTvrk/ee9jMHzJawGRW1yJXM1nz3yjKn3xGib2v1FAZmrShGE5JggaUTEdm82W/KyOnDRTDmry063TfQsmCFMhMDsqGrDuUA4/9qvi2d88B1sEgoF4t76TQ5/pwoOCg9tRWuR/uorDXZOT8qJz3YAVEJCnId2cAEQbgNkPk+w9XAAMi6rXCNmCrboRVh+Zi8OX6iICkcGJS0mQ9v/Clt6Y7nrWy9SlMQ75jOoYeiRKmjUgbKva2YeqkOt2ic//hYTWNzVjdwtXnjrkyn7jxIwqF+5KL36mdkFkV8kahF02gY8uadKMX2KnIcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/25 22:28, Zi Yan wrote:
> On 1 Aug 2025, at 8:20, Mika Penttilä wrote:
> 
>> On 8/1/25 14:10, Zi Yan wrote:
>>> On 1 Aug 2025, at 4:46, David Hildenbrand wrote:
>>>
>>>> On 01.08.25 10:01, Balbir Singh wrote:
>>>>> On 8/1/25 17:04, David Hildenbrand wrote:
>>>>>> On 01.08.25 06:44, Balbir Singh wrote:
>>>>>>> On 8/1/25 11:16, Mika Penttilä wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 8/1/25 03:49, Balbir Singh wrote:
>>>>>>>>
>>>>>>>>> On 7/31/25 21:26, Zi Yan wrote:
>>>>>>>>>> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
>>>>>>>>>>
>>>>>>>>>>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>>>>>>>>>> On 7/30/25 18:58, Zi Yan wrote:
>>>>>>>>>>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>>>>>>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>>>>>>>>>>     include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>>>>>>>>>>     include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>>>>>>>>>>     include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>>>>>>>>>>     mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>>>>>>>>>>     mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>>>>>>>>>>     mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>>>>>>>>>>     mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>>>>>>>>>>     7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>> <snip>
>>>>>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>>>>>>>>>>> +    struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>>>>>>>>>>> +    struct folio *new_folio;
>>>>>>>>>>>>>>>>>>>>>>> +    int ret = 0;
>>>>>>>>>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>>>>>>>>> +    /*
>>>>>>>>>>>>>>>>>>>>>>> +     * Split the folio now. In the case of device
>>>>>>>>>>>>>>>>>>>>>>> +     * private pages, this path is executed when
>>>>>>>>>>>>>>>>>>>>>>> +     * the pmd is split and since freeze is not true
>>>>>>>>>>>>>>>>>>>>>>> +     * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>>>>>>>>>>> +     *
>>>>>>>>>>>>>>>>>>>>>>> +     * With device private pages, deferred splits of
>>>>>>>>>>>>>>>>>>>>>>> +     * folios should be handled here to prevent partial
>>>>>>>>>>>>>>>>>>>>>>> +     * unmaps from causing issues later on in migration
>>>>>>>>>>>>>>>>>>>>>>> +     * and fault handling flows.
>>>>>>>>>>>>>>>>>>>>>>> +     */
>>>>>>>>>>>>>>>>>>>>>>> +    folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>>>>>>>>>>> device side mapping.
>>>>>>>>>>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>>>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>>>>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>>>>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>>>>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>>>>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>>>>>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>>>>>>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>>>>>>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>>>>>>>>>>> at CPU side.
>>>>>>>>>>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>>>>>>>>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>>>>>>>>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>>>>>>>>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>>>>>>>>>>> CPU unmapped and device mapped.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Here are my questions on device private folios:
>>>>>>>>>>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>>>>>>>>>>       perspective? Can it be stored in a device private specific data structure?
>>>>>>>>>>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>>>>>>>>>>> common code more messy if not done that way but sure possible.
>>>>>>>>>>>> And not consuming pfns (address space) at all would have benefits.
>>>>>>>>>>>>
>>>>>>>>>>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>>>>>>>>>>       the device driver manipulate it assuming core-mm just skips device private
>>>>>>>>>>>>>       folios (barring the CPU access fault handling)?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>>>>>>>>>>> by CPU and only device driver manipulates their mappings?
>>>>>>>>>>>>>
>>>>>>>>>>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>>>>>>>>>>> someone could change while in device, it's just pfn.
>>>>>>>>>>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>>>>>>>>>>
>>>>>>>>>>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>>>>>>>>>>
>>>>>>>>>>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
>>>>>>>>>> Thanks for the clarification.
>>>>>>>>>>
>>>>>>>>>> So folio_mapcount() for device private folios should be treated the same
>>>>>>>>>> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
>>>>>>>>>> Then I wonder if the device private large folio split should go through
>>>>>>>>>> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
>>>>>>>>>> remap. Otherwise, how can we prevent rmap changes during the split?
>>>>>>>>>>
>>>>>>>>> That is true in general, the special cases I mentioned are:
>>>>>>>>>
>>>>>>>>> 1. split during migration (where we the sizes on source/destination do not
>>>>>>>>>      match) and so we need to split in the middle of migration. The entries
>>>>>>>>>      there are already unmapped and hence the special handling
>>>>>>>>> 2. Partial unmap case, where we need to split in the context of the unmap
>>>>>>>>>      due to the isses mentioned in the patch. I expanded the folio split code
>>>>>>>>>      for device private can be expanded into its own helper, which does not
>>>>>>>>>      need to do the xas/mapped/lru folio handling. During partial unmap the
>>>>>>>>>      original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)
>>>>>>>>>
>>>>>>>>> For (2), I spent some time examining the implications of not unmapping the
>>>>>>>>> folios prior to split and in the partial unmap path, once we split the PMD
>>>>>>>>> the folios diverge. I did not run into any particular race either with the
>>>>>>>>> tests.
>>>>>>>> 1) is totally fine. This was in v1 and lead to Zi's split_unmapped_folio()
>>>>>>>>
>>>>>>>> 2) is a problem because folio is mapped. split_huge_pmd() can be reached also from other than unmap path.
>>>>>>>> It is vulnerable to races by rmap. And for instance this does not look right without checking:
>>>>>>>>
>>>>>>>>      folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>
>>>>>>> I can add checks to make sure that the call does succeed.
>>>>>>>
>>>>>>>> You mention 2) is needed because of some later problems in fault path after pmd split. Would it be
>>>>>>>> possible to split the folio at fault time then?
>>>>>>> So after the partial unmap, the folio ends up in a little strange situation, the folio is large,
>>>>>>> but not mapped (since large_mapcount can be 0, after all the folio_rmap_remove_ptes). Calling folio_split()
>>>>>>> on partially unmapped fails because folio_get_anon_vma() fails due to the folio_mapped() failures
>>>>>>> related to folio_large_mapcount. There is also additional complexity with ref counts and mapping.
>>>>>> I think you mean "Calling folio_split() on a *fully* unmapped folio fails ..."
>>>>>>
>>>>>> A partially mapped folio still has folio_mapcount() > 0 -> folio_mapped() == true.
>>>>>>
>>>>> Looking into this again at my end
>>>>>
>>>>>>>
>>>>>>>> Also, didn't quite follow what kind of lock recursion did you encounter doing proper split_folio()
>>>>>>>> instead?
>>>>>>>>
>>>>>>>>
>>>>>>> Splitting during partial unmap causes recursive locking issues with anon_vma when invoked from
>>>>>>> split_huge_pmd_locked() path.
>>>>>> Yes, that's very complicated.
>>>>>>
>>>>> Yes and I want to avoid going down that path.
>>>>>
>>>>>>> Deferred splits do not work for device private pages, due to the
>>>>>>> migration requirements for fault handling.
>>>>>> Can you elaborate on that?
>>>>>>
>>>>> If a folio is under deferred_split() and is still pending a split. When a fault is handled on a partially
>>>>> mapped folio, the expectation is that as a part of fault handling during migration, the code in migrate_folio_mapping()
>>>>> assumes that the folio sizes are the same (via check for reference and mapcount)
>>>> If you hit a partially-mapped folio, instead of migrating, you would actually want to split and then migrate I assume.
>>> Yes, that is exactly what migrate_pages() does. And if split fails, the migration
>>> fails too. Device private folio probably should do the same thing, assuming
>>> splitting device private folio would always succeed.
>>
>> hmm afaics the normal folio_split wants to use RMP_USE_SHARED_ZEROPAGE when splitting and remapping
>> device private pages, that can't work..
> 
> It is fine to exclude device private folio to use RMP_USE_SHARED_ZEROPAGE like:
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..b97dfd3521a9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3858,7 +3858,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>         if (nr_shmem_dropped)
>                 shmem_uncharge(mapping->host, nr_shmem_dropped);
> 
> -       if (!ret && is_anon)
> +       if (!ret && is_anon && !folio_is_device_private(folio))
>                 remap_flags = RMP_USE_SHARED_ZEROPAGE;
>         remap_page(folio, 1 << order, remap_flags);
> 
> Or it can be done in remove_migration_pte().


I have the same set of changes plus more to see if the logic can be simplified and well known
paths be taken. 

Balbir Singh

