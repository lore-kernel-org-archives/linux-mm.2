Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F05CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1A28E00A2; Mon, 13 Oct 2025 18:51:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9608E0024; Mon, 13 Oct 2025 18:51:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 971698E00A2; Mon, 13 Oct 2025 18:51:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 828BF8E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:51:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4543DC0677
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:51:10 +0000 (UTC)
X-FDA: 83994588300.11.E09050B
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4B22F40003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:51:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="NR/EyY1g";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760395867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3SYHxvCTYzvtPBD9qOPSQKXkNgPynvZ5r/OghtiMMk=;
	b=gVFPbTE+Que+EA2e554PhDH1/opkSj7ufniL1O/lq7ieNPLiWZ4niIG+ZBx9CgHQcJ+zm4
	qjjotTskEZHIOPQihNiIhS1sumRqBqt6wfWSoNG6IHIbLspz7+Ily4AvztADuepiDpVjWX
	u+1jw7rKov3quqh/Ed2S3XL2mbv7OAY=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="NR/EyY1g";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760395867; a=rsa-sha256;
	cv=pass;
	b=Ntox+TG1GhhLK25piwefVnKOQu5UjsXgWD2LGlRXRMqkQf/IErmqAY7SBpzyK4nxTraa6Z
	TsvFSQdRwcPFVpBogtToYxOyIIfize7xpsnqrxrttVkdDAZcYJKdMWEuxG8SzSEukAEedz
	smHQkg1xg00vwEoRfCqhvd+uBwsr+f4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JGLYxjw5cz8qBERGWYlYwdMSWvINT+o6CQHzojdk10d4VxV3kP5uH0+29IIsVED3r3d4mFhk+ly4F9CNKTaKz9jSYy4GVkMTStGrQn+I7fVNXlLpXIM5oVl3HcmFqaFOHblcJ8nPDzeuUk47kHoY8hT4yAF2RSvm/INfGyZ9uX3WVnc765EvIMKtlCafKDquZC5B+i3KNZhVCyWZOnT2FlpdUB/+SKhDouo6fB62mgzc5P9E+tSsg1KuRueKh2i4AiBYkIyNkbogX0ymJvPlxnu/kTayu22VF8/3n/N9xqwvvrbMURnyQjrTpGzj2/z1h2CveQwABjtLwsy2P3T6wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3SYHxvCTYzvtPBD9qOPSQKXkNgPynvZ5r/OghtiMMk=;
 b=RDy3ronoAwKqy8aKBJGMwoYtrPp4l6e84bxi/xszmEnD0X4RkIA3gxfTF50p+YwrOyh3WqN1n4QIGseACRCiIWrwULy8qB2rjKTFty+iSNVbpllWDn1J5WMKBhoKsmnG6r2hdF4FxPNg6ZzQHNdpXz/XdUxy3zcuO3ifp6fT3dCWs52L8kCQ3iNfWMbXJ3Uf04lKfTpPrcKArOXtHXfNhAjccdmx78ICIUbiR2xOPiy/Yym74ElU87PxWv+PWEr1weO5QhLimkV/l3WKbSVmTuLCot3uorDAJSdpSiRN0fqkrcChrlPGYLoV9oK5U7UvwUzruv7bw7EMeg8bupGHag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3SYHxvCTYzvtPBD9qOPSQKXkNgPynvZ5r/OghtiMMk=;
 b=NR/EyY1gTAYnvnaUaVlnZkQgngKbw1VJWoh+urZOu0Fix7DHXcegQBBPJHwC0DF4tkIQp3JeSQryzTfuaZ3BEOAZFvQBlZpv9lgmnrZmByR0gCkfO01/0Exu3xUiIKuueyX+HWXsLb5rFdwiYkAMVXnsTNLlWja4RwEbpMS3x8ZI98e7F/lI7uOyOryiGJxyQEYfPrlSOgOHOqGtG+Z3p6TENM9Sh6vY8jd2Mgrt5ta7UR8/9s2l49vL3vYpJ6x2b8w2ffnARE7PfdE4yhKqW/074a9FT9fC/opXYFLUKyjemj7dERr7bqIW4jGYT1uzEE/bmp0F50tgnUYyM95Egw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ2PR12MB8652.namprd12.prod.outlook.com (2603:10b6:a03:53a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 22:51:00 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 22:51:00 +0000
Message-ID: <f951e913-290e-471e-9e7a-8af38771f27f@nvidia.com>
Date: Tue, 14 Oct 2025 09:50:51 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [v7 11/16] mm/migrate_device: add THP splitting during migration
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, akpm@linux-foundation.org,
 David Hildenbrand <david@redhat.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
 <20251001065707.920170-12-balbirs@nvidia.com>
 <FB8D8651-639F-4882-9868-7FA0A8B62397@nvidia.com>
 <7213aa5c-7129-4a3f-acbf-ab922f0f6cac@nvidia.com>
 <D2A4B724-E5EF-46D3-9D3F-EBAD9B22371E@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <D2A4B724-E5EF-46D3-9D3F-EBAD9B22371E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ2PR12MB8652:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c11cdd-0258-4717-cf7c-08de0aaafac1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1BoMnVuSVN2UFYySERtSDB5UjhjMWxBOGJBckRFS1BQVzRUMExsL2FlWXZO?=
 =?utf-8?B?T0Q4T2JPQnBtbDBBcUp5V1RTMjVUQjR0Mjk1M0E2SXl1QnVDWk5tNytDNzVS?=
 =?utf-8?B?WVVBTis5YVpZSG1tUHVKZ3ZTYStHaloxNEJiNmttSDJOSGJqdVMvSnRDWDhm?=
 =?utf-8?B?YWwxaGI5dWwyRkQwQmZqTzR6NTFhbmU3Vnd6clR0SzRXYzJWUGpaOExMZVgv?=
 =?utf-8?B?b1FIaUlFQ0hENmFyRFJsOXlvdUV3RnVQQ0NFaFJBSUlORWhRck5zdVREV2lt?=
 =?utf-8?B?Zm02RjNuOUJFaWhqSENFSHBoeG45WmU5M1gxT3U0cTBJMmlRb3NrcmJqRkhM?=
 =?utf-8?B?T3hrVFE5djJJbytaajRPVUNLTzdIWWxYZ0tDdStPbGNDV0p6ci9PdGNuRHFu?=
 =?utf-8?B?MVhLUVJZMENFakxRZDEyT0JzemVvbXpMVXpXM0dHd0I1T1dMc2s2Z2c5ZGUw?=
 =?utf-8?B?U0JacStRZWx3OEFmVHhpR0wyMW0zditHTit1R2RuWlN6eXMvRFcyQjNITU51?=
 =?utf-8?B?Ym5YcW5kRFJkaUdsdXdtM1RhTzBSLytyWVBFNnFmSGxaT0xmOWhRUmovWWR4?=
 =?utf-8?B?eE91d2JLUEt3ZGMrWUNtWW9HOExvekNVOFEvUGYzdEs2b1RLZDdPRnRnQ0VN?=
 =?utf-8?B?N05FWURhWTNpQzByd05tWU4vZWlndGFQMmZqZFJ0VldPK09aOWpyN1lWLzdp?=
 =?utf-8?B?RHJSVnVKSGwrQTV2Rk1qaXd4cjRYdzNWZ2hhSmpjQlpDNVQ1VXIwNmEzcGxr?=
 =?utf-8?B?RjFubTZZVXRMT0c0TVRQcjN5YmpkUUFDUmxiZlB3VmhhaEdVTGZsTnRPTFlz?=
 =?utf-8?B?NjBrRHYvc05nQWI3YWxvSEN6NnJxbHRIUDc5NU5xVDhoQ3pJSDhrekRGUFRD?=
 =?utf-8?B?N3FFaUM3YkJ2M2J3OVd3K29RNUg2SEtady96UTN5VUNtelZyTHBKN21KdDlQ?=
 =?utf-8?B?L0FDY2p3U3IvNm9FSEdpWFYzaEpta3dURGF3WHEvK2tEUjVqNlpKM3phOEVu?=
 =?utf-8?B?aW9FcVl0RzJCSlpGcldIRnRKdW1QK210WmFPZlpSZUIxNVdNbDFSclVBZjFP?=
 =?utf-8?B?c0psQU5OWWgrMkpiNGZ1L21ZRFlPdHhZVFJJRFZLbCsxMU15Z3FOM00zYi9v?=
 =?utf-8?B?SmhaZnlrcGUyZGdQNFE5b3VodTJlWjFuVk1ZYjRUazZlQnhHR2pzaEJqSUJS?=
 =?utf-8?B?eCsrQjRVa0EwZkdkQ3Vkdk5iOFBuV0ZUTkRwcW1ER3kxTVJYdXU2cGJqQXdk?=
 =?utf-8?B?ZXIyUnl1UnlENVFBc1h6ZUhlWjEvUlRJNGFoUjhuUGxhSktTZG5HVU44L0tG?=
 =?utf-8?B?Sm9LMmtnYjBmWFZyVFVmS2pkc0ZUeFZjV2NhNjliNXp2bThsanEwVWROSmpT?=
 =?utf-8?B?bVFqbVJOR1k3THh2UUxXU21mT2xWcU9TTCs2M0RsZGM5b213TEgxdldUemht?=
 =?utf-8?B?aUtvdGR5dFdaMEJ3ZTF2Rk4wWHZweFR4VURNLzcxVlNsMkNuTC9BQkdwbUtZ?=
 =?utf-8?B?a2J5enV4c2pWZmtWNVBqOHRncFZGdTBKdC9YMU8rR0xLdlBEOTltQ1VDdDVo?=
 =?utf-8?B?K2JaMWtyTFE1UUl5SjQvZ1JVU2FTV1dpKzdLMUZNWVU4L1VEWmpNMklDWFBx?=
 =?utf-8?B?eUU5ajVqTG5vMHpuZUlUeUU4T0R2WkJ5NW9CZjI1YU56aDc3QkRybTkzbURS?=
 =?utf-8?B?NFVGeXYrRHJSdVF6Q1ozVHV0dWVva1JxVG53WXhyRHlzWFc3TGFseXBnc1RU?=
 =?utf-8?B?NkhFSjN2dlFCQUUzTnRKVUtCQVJsL1dxSlJQelNjSm5nZzlaMnpBVDlySDRO?=
 =?utf-8?B?SGpkVmhKdjFQc0xkdXl0eTVCMVNBSXd6dE5uS1FXUXZSZVZGUTk1SlVMUStu?=
 =?utf-8?B?cVhpRUN5SG5XVFhzUkp4dVZ2MzdaaU0zNXU5Ukp6Q0IrWDJQSDRwWlM5RldI?=
 =?utf-8?Q?lfeI6Gt5taSqDi/5RI56LdU0pS8glT17?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXk5N2FSYkhuWVVCcURwT25aUlJkbDZ5dHJuYm1uWTVYZGVXdEJJVk9DZG1m?=
 =?utf-8?B?YWZwUnhXVk9WRlcyU0MvMktNcVRBUjVsUGE0NlRTRnJCTGs2V2hRUXplUlVL?=
 =?utf-8?B?R0g1aEZ4b3ZkODVPeDZOdG5aODlnRnlzb2F5YlpVVzlDMWUwMTlRVjBZVmlO?=
 =?utf-8?B?R2RIdVVZMjJEc3J1VGFSK2VXNWU0Tm9QTkpDYU5EWXBwNDdmZ2ErckJUcjU3?=
 =?utf-8?B?bTAydGM0RnZpVnVFeXJ1M0I5S0VBdk5ncThOTUhsUE5CbjJpelYzZ0sxNGU4?=
 =?utf-8?B?T01WcURlVU5KY3krbWdIMWUwL29uVUtubUVnWVhVVVEramRVSGx5QUJ4cGU2?=
 =?utf-8?B?RkFqanJ4R0kyRmtGYkxxdStYTW4vSVV4RDgrLy9HZjlac2llaHhhSjVSWGp6?=
 =?utf-8?B?VlEwclA3UGt5YmdxQjltNksvL2t1RkVGbkRlSWlFTHo5YmpFVXgvWmZGamxY?=
 =?utf-8?B?Y3ZNMXl5TytzSUlnY0JEY0VCcVZoMjBwRnlLbzZWU1lWT0dsZnlWOTZSL2w4?=
 =?utf-8?B?VjI1QThEMzNlNFdxelkrNjdONFhLZkJjSTJoWWxCT0xTdk90b1paclYxWnIz?=
 =?utf-8?B?U1ZjOTlDVSt1dkZ1Nlp5QUxOaGdkb0VJT3ZRTnVMRC96TTY5WDY1eE0wamdX?=
 =?utf-8?B?YXNjRXpsZndlVkVoUDhxbTBrSXZlRlBxY1N1Q2VEa21GOGliZ0pIQzkrWHY1?=
 =?utf-8?B?ZnRTNVR1b0xYWi9VTHNBV09jTkljM01vYldWK2t6WVhvRzQ0SkJuUm9tNzN5?=
 =?utf-8?B?aUdWUkRXSFU4RUJNanZXeTBOajlkQ3RSTGJtTXpKV3cyNFFpOHVobm01MEhT?=
 =?utf-8?B?RnRzeXhUZGp3dHJsY2xHUHIxZWIyQkxkSzF4K1pER1FCdGoxTFl4a2NRRktF?=
 =?utf-8?B?clYxUjdBaVNGb0xxdElVR2wzN1NURHFqVnc5aEVhSHN0dWVsQnBSV0EzT0gr?=
 =?utf-8?B?eW5TYnJ1THdyeTdra3d1WWhEL1d0M1IrWnNNWFRCTHpXYlJ1dCtKMjlwL2Ft?=
 =?utf-8?B?YjF4SEsvRVdtZGp4TGVjQkd6Q3BQMmpBZVdPbG54emxUTDZJSjlTNm01dFpH?=
 =?utf-8?B?VE5pRE5WN01OeURKazlFYUhpdndLS0hxbEJldWV5TDZ2R1VhUlJGL2d4dFRG?=
 =?utf-8?B?eDFZc3BOamVzdzIvL1FzSUxFUkpzRGRrQlVOaDRzUmc1ZFpsaEtDSjhmNloz?=
 =?utf-8?B?T1gySWRUWjhqWnFFMW94WEl6OTlJL2RwMDhTWi9NbjgxVytPUTh1eFpob096?=
 =?utf-8?B?YmxqOGFQSG5pZmRVVjVjOGFJTFY1NzVWZGd3b1ZJeGNTaDZXbmV4NE1ua0RR?=
 =?utf-8?B?bHhQK25UYnFoRTZvSkh2ZzZnV0FoaHIrdXdpT0FoVTJLRVpSV05ZSFJPVkll?=
 =?utf-8?B?a0taL0RNV25xK2NUWGtnU1VpOVJTeXpNNWMrT2ttVTkzSzdaUm9pcTBwQ0hq?=
 =?utf-8?B?NHJmWjRXdDB6SFAzeFhib213MlBHZUk4NHk1VzVCTDJxd2xqbWdWeVFBdTd6?=
 =?utf-8?B?T0h0Y1lPdEtvbmRLYnlvaDVwRWJmWGpZUUlyRnNSYzZzb0RUVTZqWmRBZEoz?=
 =?utf-8?B?bXJMRXBYbGFnYVY3bVpZaFkyckJvdGZBWjRDRzhTNXJ2UjU2UHNKa2NoSHFV?=
 =?utf-8?B?MFVmMHRPZHErSCt0cnZjWjZ5ZE5acE5lRDQrWE5TOWkvUDg1Q3NTS1lPdkt4?=
 =?utf-8?B?VjFwTlI3ejVDaGF1RGpNSkRqcW9aOHFpQks5Nk9BRUJ5RVBHOW42V2hoeXp6?=
 =?utf-8?B?QUdyV0FxSjh6OStvRWxMeDIxR0tYTXpVU3hwSnpNeXJ3bERxcVpMdFh6ZUF6?=
 =?utf-8?B?bDVxcGJQc1hmRSt3V04rQ0ozY2dlVVA5TmhFRkZ5MXlreFppb1pCcHdWRVFM?=
 =?utf-8?B?V2lrKzhHOXU1bXoyQklodVZqQ016Y3F1Z3RuSDJCTkI1QXJyV3A4NkpCVnJL?=
 =?utf-8?B?ekdaUHBPMjhqTVhOc1orK2FoaVlxS2Y1dkgzQU5mOUliOEdkTGJYU2YranJP?=
 =?utf-8?B?RDYwS0pHL1doRlZpdG01WFJlM1VYTlN0N3NkRnBUL2ZERjBVVUgvUEJzRXls?=
 =?utf-8?B?WVlNZ3g5RDZoSVR4N3lsVnNBV0xXb0thVzFTZ0hFM1lVMDIzYVdBT3ZWRVA3?=
 =?utf-8?B?ZEY2Q2RqcTMxSTRENmpTWDZHai9uazJVR2xjLzkwUUZKLzBIRndCM0tYR0FE?=
 =?utf-8?Q?iFafdJvrOPafGPVnYE7cChvMpaK8JfQ+3WvKt4wvI4St?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c11cdd-0258-4717-cf7c-08de0aaafac1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 22:51:00.2839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnwzJg6iIOsYjLdNHFNEAZuJWcqeSvgPhXyxcA0It0FlBTT+LwKagJZ3usNEP69W1uXsL4DzzTYsCE9n7ilDlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8652
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B22F40003
X-Rspamd-Server: rspam03
X-Stat-Signature: t44rjfxhedh6bisfzipks684bnttbity
X-HE-Tag: 1760395867-23065
X-HE-Meta: U2FsdGVkX1/DDHzY4emQk+efgmX/satfsaar4ztGFUoQC2xrRgqMrXL3DopCa00VDFOFfocbOcG03QiGRsY0Glp3HpUzBIOUAwq8nAc30x3pFC975/Pih03xf2Q8lLXoudaalwi9lt3Pj1vG7J75rk8wV07Yd9hDR5bYeRywCiu69H5Vs4UHxMz3W9BvJhTpaYNtSSlYamvAtZ7pShFAn6GYDLNsI8+JWoPgTmChPrJuxvukMWsNtUW61NVE6iJgpfgq4wmmqeYla/OMP0u0ZUtNjznMFmzhNi03D1TKUaBe9bZ9JBKGPtcqUkmO8giqJ39D0770SJ1XQDPoRGZs2eHyr0rvUN0C6/ECfWDbJasrFfWtAy3elty+nmTClApHFFC0jCzgBZeJWjjTGTSy7+gqlldkf9Px221EK9qMS6wAAW5qOtQOLfxgnI2YsPshEvegf64WQ9O7pAmLfK6be6b8BjDhiCrt65W2t3HEUHafXsP2DXdYKDTcsqBzZJD5uuQgxJgLMjS06teugLJel2RveWuLRH57d4bF92JT4mdc8K8scZNeXIaxZjzQF9iYIq/lAWTNA8dJF0H7s7PHF99ZOzESUxgWxN9r0yhOHTIuLIz/8+VeylGbDhgLlcbdNgia3OxPsNoe9wANp3GnVDLkJjGGpcTqDH3jaDXI87i0DZWJ+Xx2QqGhNTK1xqFIr2p09LX3/XB0qDmVUGQpuSwgXKDm9UTg7JRM4vNjNJYQJKaoXXO9FbYqFFjvLHVWohEDWbFbFeV7T+ZIfHhSBbvy1PrDB+S5ae7wREkIXciPYnna4oPLboXdTh7UDF8J332JVubgmq5hc+mmV3V2IA6LTvZzLyxNi2qvcZsgd2RafKn+w3mEsJRz4N6Oo8CzhdMGRWAfcMGauaqyKmwajyQESXDJF8/ikYDf/BgdKCxQ1J/Wf8003ceqAqkAqc4Jy9oZ0+bmhVQjlRLAvAU
 Lu+ipkIG
 wookPcn8+XFHIr7598FC2YfrtL8ChcyVuRBd3qEP7ipRxEKGy7wsHYRybz7NsDvHE6t19btpSc2rpdvf+wNwfTjalskILKf39/8avNrr9fIlaEIGsx7vmifUnjS7/uVGcFJ+ZOFFPMIRcl8Fagtbh+K+mcSa/1RoSbda7TjIL4Ak4pACl8pinS0D20tVRdFCKKyK1oKhX8EjMe2zidW8lPO+eeqPQM+x9I5140OaTpBgGxHFDRwsuRTGKCA3n5yfiUBrTA68q5jn2lTAAdYRM9PK5MmUyXUm9JLgSSprO3Ys2BB0p/lO2TmLYQ4vHrFHZSfhnfhPA9pPWjFKfl7ux65VHTsuKUTaEmhNlRqYmGgdorXS1RTY+JsDh1aC946Xdc+LYzd3Tzx6BHzD2h5uwPsR4NxGVUFYNME4Zx18zDWip3/EhTTiNDNZ8Njym59FJWmOLbsxFw7tDmkVbhIUn/JWi/TEyXojNYKYuWpx+MdfAzEutu1VE0QklvdMiiz4ukYBRoruicL/S4R5865W+fMkESRSve/vQw+r0UU7tCecNo+CU93fy7OP64F/UmV56KT2nQgpwhw1/5tcFonWFyLreTMJVYhwasghqLgAGGl+ZSt1aghTOcH0azxLiTPOj0RaOmt2ya/rcVlaFFaBQbmRsg8ip7TV7ohs/WMLwELX0Kr6a+TbGyELYplMa+6309NBzrZJ2H7wuaRO+uZY6DnnJ4nu3j1Iof4burqSVBHS6X0yVZ8vGWnkUkNDe5WpcFDIV411kMKvekSBjtpe3NhdVk1czXYpUU8wcjIUGryAB/oxwIEg+4VMLliRcFBoifz3iH7Q49dXdeh3MtWu9PwjMr4HTK1wUWzT5njA4LG7+UBiJD/a2Gpu7Tw3Lz3z3W43n6/HHzMHz7R+VwKeyPquLhvCiHeVfNjs8UpqRKl2K93J1R8cceCBnLZrf42f56g5l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 08:55, Zi Yan wrote:
> On 13 Oct 2025, at 17:33, Balbir Singh wrote:
> 
>> On 10/14/25 08:17, Zi Yan wrote:
>>> On 1 Oct 2025, at 2:57, Balbir Singh wrote:
>>>
>>>> Implement migrate_vma_split_pages() to handle THP splitting during the
>>>> migration process when destination cannot allocate compound pages.
>>>>
>>>> This addresses the common scenario where migrate_vma_setup() succeeds with
>>>> MIGRATE_PFN_COMPOUND pages, but the destination device cannot allocate
>>>> large pages during the migration phase.
>>>>
>>>> Key changes:
>>>> - migrate_vma_split_pages(): Split already-isolated pages during migration
>>>> - Enhanced folio_split() and __split_unmapped_folio() with isolated
>>>>   parameter to avoid redundant unmap/remap operations
>>>>
>>>> This provides a fallback mechansim to ensure migration succeeds even when
>>>> large page allocation fails at the destination.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>> Cc: Gregory Price <gourry@gourry.net>
>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>> Cc: Nico Pache <npache@redhat.com>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Barry Song <baohua@kernel.org>
>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>> Cc: David Airlie <airlied@gmail.com>
>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>
>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>> ---
>>>>  include/linux/huge_mm.h | 11 +++++-
>>>>  lib/test_hmm.c          |  9 +++++
>>>>  mm/huge_memory.c        | 46 ++++++++++++----------
>>>>  mm/migrate_device.c     | 85 +++++++++++++++++++++++++++++++++++------
>>>>  4 files changed, 117 insertions(+), 34 deletions(-)
>>>>
>>>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>>>> index 2d669be7f1c8..a166be872628 100644
>>>> --- a/include/linux/huge_mm.h
>>>> +++ b/include/linux/huge_mm.h
>>>> @@ -365,8 +365,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
>>>>  		vm_flags_t vm_flags);
>>>>
>>>>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
>>>> -int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>> -		unsigned int new_order);
>>>> +int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>> +		unsigned int new_order, bool unmapped);
>>>>  int min_order_for_split(struct folio *folio);
>>>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>>>  bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>> @@ -375,6 +375,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>>  		bool warns);
>>>>  int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
>>>>  		struct list_head *list);
>>>> +
>>>> +static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>> +		unsigned int new_order)
>>>> +{
>>>> +	return __split_huge_page_to_list_to_order(page, list, new_order, false);
>>>> +}
>>>> +
>>>>  /*
>>>>   * try_folio_split - try to split a @folio at @page using non uniform split.
>>>>   * @folio: folio to be split
>>>> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
>>>> index 46fa9e200db8..df429670633e 100644
>>>> --- a/lib/test_hmm.c
>>>> +++ b/lib/test_hmm.c
>>>> @@ -1612,6 +1612,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
>>>>  	order = folio_order(page_folio(vmf->page));
>>>>  	nr = 1 << order;
>>>>
>>>> +	/*
>>>> +	 * When folios are partially mapped, we can't rely on the folio
>>>> +	 * order of vmf->page as the folio might not be fully split yet
>>>> +	 */
>>>> +	if (vmf->pte) {
>>>> +		order = 0;
>>>> +		nr = 1;
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * Consider a per-cpu cache of src and dst pfns, but with
>>>>  	 * large number of cpus that might not scale well.
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 8c95a658b3ec..022b0729f826 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3463,15 +3463,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>>  		new_folio->mapping = folio->mapping;
>>>>  		new_folio->index = folio->index + i;
>>>>
>>>> -		/*
>>>> -		 * page->private should not be set in tail pages. Fix up and warn once
>>>> -		 * if private is unexpectedly set.
>>>> -		 */
>>>> -		if (unlikely(new_folio->private)) {
>>>> -			VM_WARN_ON_ONCE_PAGE(true, new_head);
>>>> -			new_folio->private = NULL;
>>>> -		}
>>>> -
>>>>  		if (folio_test_swapcache(folio))
>>>>  			new_folio->swap.val = folio->swap.val + i;
>>>>
>>>> @@ -3700,6 +3691,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>>   * @lock_at: a page within @folio to be left locked to caller
>>>>   * @list: after-split folios will be put on it if non NULL
>>>>   * @uniform_split: perform uniform split or not (non-uniform split)
>>>> + * @unmapped: The pages are already unmapped, they are migration entries.
>>>>   *
>>>>   * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
>>>>   * It is in charge of checking whether the split is supported or not and
>>>> @@ -3715,7 +3707,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
>>>>   */
>>>>  static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  		struct page *split_at, struct page *lock_at,
>>>> -		struct list_head *list, bool uniform_split)
>>>> +		struct list_head *list, bool uniform_split, bool unmapped)
>>>>  {
>>>>  	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
>>>>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
>>>> @@ -3765,13 +3757,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  		 * is taken to serialise against parallel split or collapse
>>>>  		 * operations.
>>>>  		 */
>>>> -		anon_vma = folio_get_anon_vma(folio);
>>>> -		if (!anon_vma) {
>>>> -			ret = -EBUSY;
>>>> -			goto out;
>>>> +		if (!unmapped) {
>>>> +			anon_vma = folio_get_anon_vma(folio);
>>>> +			if (!anon_vma) {
>>>> +				ret = -EBUSY;
>>>> +				goto out;
>>>> +			}
>>>> +			anon_vma_lock_write(anon_vma);
>>>>  		}
>>>>  		mapping = NULL;
>>>> -		anon_vma_lock_write(anon_vma);
>>>>  	} else {
>>>>  		unsigned int min_order;
>>>>  		gfp_t gfp;
>>>> @@ -3838,7 +3832,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  		goto out_unlock;
>>>>  	}
>>>>
>>>> -	unmap_folio(folio);
>>>> +	if (!unmapped)
>>>> +		unmap_folio(folio);
>>>>
>>>>  	/* block interrupt reentry in xa_lock and spinlock */
>>>>  	local_irq_disable();
>>>> @@ -3925,10 +3920,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>
>>>>  			next = folio_next(new_folio);
>>>>
>>>> +			zone_device_private_split_cb(folio, new_folio);
>>>> +
>>>>  			expected_refs = folio_expected_ref_count(new_folio) + 1;
>>>>  			folio_ref_unfreeze(new_folio, expected_refs);
>>>>
>>>> -			lru_add_split_folio(folio, new_folio, lruvec, list);
>>>> +			if (!unmapped)
>>>> +				lru_add_split_folio(folio, new_folio, lruvec, list);
>>>>
>>>>  			/*
>>>>  			 * Anonymous folio with swap cache.
>>>> @@ -3959,6 +3957,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>  			__filemap_remove_folio(new_folio, NULL);
>>>>  			folio_put_refs(new_folio, nr_pages);
>>>>  		}
>>>> +
>>>> +		zone_device_private_split_cb(folio, NULL);
>>>>  		/*
>>>>  		 * Unfreeze @folio only after all page cache entries, which
>>>>  		 * used to point to it, have been updated with new folios.
>>>> @@ -3982,6 +3982,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>
>>>>  	local_irq_enable();
>>>>
>>>> +	if (unmapped)
>>>> +		return ret;
>>>> +
>>>>  	if (nr_shmem_dropped)
>>>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>>>
>>>> @@ -4072,12 +4075,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>>>   * Returns -EINVAL when trying to split to an order that is incompatible
>>>>   * with the folio. Splitting to order 0 is compatible with all folios.
>>>>   */
>>>> -int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>> -				     unsigned int new_order)
>>>> +int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>>> +				     unsigned int new_order, bool unmapped)
>>>>  {
>>>>  	struct folio *folio = page_folio(page);
>>>>
>>>> -	return __folio_split(folio, new_order, &folio->page, page, list, true);
>>>> +	return __folio_split(folio, new_order, &folio->page, page, list, true,
>>>> +				unmapped);
>>>>  }
>>>>
>>>>  /*
>>>> @@ -4106,7 +4110,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>>>  		struct page *split_at, struct list_head *list)
>>>>  {
>>>>  	return __folio_split(folio, new_order, split_at, &folio->page, list,
>>>> -			false);
>>>> +			false, false);
>>>>  }
>>>>
>>>>  int min_order_for_split(struct folio *folio)
>>>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>>>> index 4156fd6190d2..fa42d2ebd024 100644
>>>> --- a/mm/migrate_device.c
>>>> +++ b/mm/migrate_device.c
>>>> @@ -306,6 +306,23 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>>>>  			    pgmap->owner != migrate->pgmap_owner)
>>>>  				goto next;
>>>>
>>>> +			folio = page_folio(page);
>>>> +			if (folio_test_large(folio)) {
>>>> +				int ret;
>>>> +
>>>> +				pte_unmap_unlock(ptep, ptl);
>>>> +				ret = migrate_vma_split_folio(folio,
>>>> +							  migrate->fault_page);
>>>> +
>>>> +				if (ret) {
>>>> +					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>>>> +					goto next;
>>>> +				}
>>>> +
>>>> +				addr = start;
>>>> +				goto again;
>>>> +			}
>>>> +
>>>>  			mpfn = migrate_pfn(page_to_pfn(page)) |
>>>>  					MIGRATE_PFN_MIGRATE;
>>>>  			if (is_writable_device_private_entry(entry))
>>>> @@ -880,6 +897,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
>>>>  	return 0;
>>>>  }
>>>> +
>>>> +static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>>> +					    unsigned long idx, unsigned long addr,
>>>> +					    struct folio *folio)
>>>> +{
>>>> +	unsigned long i;
>>>> +	unsigned long pfn;
>>>> +	unsigned long flags;
>>>> +	int ret = 0;
>>>> +
>>>> +	folio_get(folio);
>>>> +	split_huge_pmd_address(migrate->vma, addr, true);
>>>> +	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
>>>> +							0, true);
>>>
>>> Why not just call __split_unmapped_folio() here? Then, you do not need to add
>>> a new unmapped parameter in __folio_split().
>>>
>>>
>>
>> The benefit comes from the ref count checks and freeze/unfreeze (common code) in
>> __folio_split() and also from the callbacks that are to be made to the drivers on
>> folio split. These paths are required for both mapped and unmapped folios.
>>
>> Otherwise we'd have to replicate that logic and checks again for unmapped folios
>> and handle post split processing again.
> 
> Replicating freeze/unfreeze code would be much better than adding unmapped parameter
> and new path in __folio_split(). When it comes to adding support for file-backed
> folios, are you going to use unmapped parameter to guard code for file-backed code
> in __folio_split()? Just keep piling up special paths?
> 

Adding file-backed would require more code duplication and hence the aim to reuse 
as much as possible. I am happy to aim towards refactoring the code to separate out
the unmapped part of the code as a follow on patch to the series.

Balbir

