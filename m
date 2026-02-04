Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793FEE8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFD76B0089; Tue,  3 Feb 2026 20:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86C56B008A; Tue,  3 Feb 2026 20:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31A96B0092; Tue,  3 Feb 2026 20:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9126B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:14:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 251F9C241E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:14:19 +0000 (UTC)
X-FDA: 84405003438.03.6D04BD8
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011069.outbound.protection.outlook.com [52.101.62.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 431E5C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:14:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DmaNZyl2;
	spf=pass (imf10.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770167656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irDjtoDfKOfBMgOBOQ9VwUZzle2oIvWGzAN4OuATBds=;
	b=bhxTmkawTsgWf26eC8PqKSnW9njDM2pNis4KZ6DQZF6W7xN0E2NuxlOm9XmQtXYSCe++2s
	8CaKp6QMeXrRtlJ3OCETpb9MQMXsJo78QKNT5ksUv2e6zxuX3yLR/WOQ7rWXMAr+P0puWH
	AJ9CljZdS77SDcZWIv2AA1UEcAcAhpI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DmaNZyl2;
	spf=pass (imf10.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.62.69 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770167656; a=rsa-sha256;
	cv=pass;
	b=TBmHpG10E4GQgxT3585Yp5BkK0tclY1EfgmK3/6ZXhZfNte4ec0YDiekPnzID0Tooc33d+
	QJNS1igxi/zkJtAveDmW8JNe/J+gsxgEJUWFsv/odt7cUPEH9QTDVPmTHyXXjBUIvwbqMF
	p1I/SSG6rr5OMvZAnMzQ7TOdz3kSprY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCe4IADIqwyyAfLvRyWa5qjOGOuJ6M4JCwZh9mcJyxjrXwJa1cP6plI0of71YffWDiADREAkn5fPKjizdQHpHnBK1dPahb58SnG6csYw0j6xaN1kZB+8n3tKCjrijtKu6LkhEiwO67Ftw6OaoZVY2J66kXwTGzvSntOjNyKBLGvQcJ2I62Aqb9jmM2NM+O/NsqvtsgOViLQDQEWg3oX5Sa1vzoVYBEwTuIf0mkf6eDl1yv2/srgOw7PMqHWYHa7x+fzE6V3Eq4ACq3hAdCRTDY3aNxB5HpBpPpPF1uiq+uXms2Ls0wi6OEjc7ZexYixmp6BI8vLR+5o4vPdLJ0n9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irDjtoDfKOfBMgOBOQ9VwUZzle2oIvWGzAN4OuATBds=;
 b=SqP+uLk5jHgw63R42j18xKn4EnEFEhfImKC2Xkzm6LBIDEbUtoxqTLsxI6Y3OClgh9tlSQdd9wQIz3v5FgQND7CUu0IGk2j9iCKsktlzJtQ0V2GvHRlUx1/E3WFPdAYfCPeUj5wBCcCvoLEJTveByFsJt3wfJmDtXwZpKl7f4o8g3Ml7cKT7b10rffPpYu5D7/UpTiyr4OkWZFX2GJ8UhNtzU1PtWBk/DxzTApmYi0PIyfD+eMBbNhQAYP9B86Pf47qVmjLJBD11F5GkL6HR32cL0G3VCG8asWX9zpD9PAlDBfXz0qngTRWmGEFs3L9DLk4VzWmxrxff4PNJ2U9s3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irDjtoDfKOfBMgOBOQ9VwUZzle2oIvWGzAN4OuATBds=;
 b=DmaNZyl2BOzEE3iGQK+GK8FJzBxGbsJFUNXS/XlS8DJRWICclC4Mg09YZOppo0OGha7jGtK5c0a6fogiK/WtDO6sVmrvnIBBZwD9eNsBekMVAbNTiLAGNz3z/A3O0p/CPJdsuTql2hXopshtpiaFrsJM8eIhpKjpcnaw1PYseDFiNphGSUmlyYzxP9cTGB8XUGJYsyZvc3nj3vCIx1EFxRn4lQaka1CmPFpIeq+0sHYoZLkApR7qPLcq/IFV8iMBL158tNRX+PKRQ8wRKd4LdHBzz1q6rVxZ9X6XG8cpZ9kWKadOBq/VWON5R+0fIeYBcf6U6wcfMDPjU9P8/jncoQ==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Wed, 4 Feb
 2026 01:14:11 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9564.016; Wed, 4 Feb 2026
 01:14:11 +0000
Message-ID: <49e42d3c-85c5-4aee-8323-9361a9d6e66b@nvidia.com>
Date: Tue, 3 Feb 2026 17:13:42 -0800
User-Agent: Mozilla Thunderbird
Subject: pincount vs refcount: [PATCH] mm/hmm: Fix a hmm_range_fault()
 livelock / starvation problem
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 intel-xe@lists.freedesktop.org, Ralph Campbell <rcampbell@nvidia.com>,
 Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@mellanox.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-mm@kvack.org, stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
 <a459f147b461c6e6e806282956b7931f74a0aa93.camel@linux.intel.com>
 <a5b71dbc-9e3a-4098-8821-21a9a02ec235@nvidia.com>
 <9a9853a320a30802ff35803a574aab037aa2fd92.camel@linux.intel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <9a9853a320a30802ff35803a574aab037aa2fd92.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::34) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|MN2PR12MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d759f0-5d40-4f8e-be50-08de638ab42d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTV4QllsVEpyWFMwTFFvNDdMajNjQm55cXA0alI4SUMzenZuVTNzbk1LN1Z5?=
 =?utf-8?B?NExPaitVOWJPcDM0WWYxelZqRnk2YTNsUk5XTTdFSHkrK2FYRk5TNUsxNkVP?=
 =?utf-8?B?UDNXbklCZW9BTEkrVHdKYUZiZGhzcTk3Z1EzbTRQcDd0cDhYOXhZT3hGN2hY?=
 =?utf-8?B?ZkpYYmpOUk5ybDExUC9XbW80ZS8waFdGVHYrM3Y2WTBxQm0xKzRYR3JaTG9O?=
 =?utf-8?B?YjV6cUg2T0s2V3VxWnhwdDdaRW05K1pvbXkvQWVWdHVEeVNRMjZYMEp0NEpn?=
 =?utf-8?B?dnVvSUw2OE5xOWtKMVYrK2dXTnd5ZWtiYnRTZ2tMMytuemhpWTF0WDNxMjlJ?=
 =?utf-8?B?aUU5ZkJXbzdVQnU2bVpDR21waWVUV2NnQWhWY1dCdEMweFBqeE02V1Q3OC82?=
 =?utf-8?B?SDNkMDYraTBsSFV4YkRjU0M1MEZqZzFaQXJHdjFwUVZ5MktSdERtaWttQ3lD?=
 =?utf-8?B?alEwZXZOVVJZVXJQa3Focy9QOXdVRkxEYlhTSXJ5UmpEeEIvSDM4bVd4dzhr?=
 =?utf-8?B?aCt5ZlZ3bXZRdEpLQ0hVT3dmSHh1NjdWaFArTWdMdWUzY2ZCcFBvb2ZOMGJu?=
 =?utf-8?B?S0g1MzU1K1J6akpaZzNGQTBiSHFxQW9nZkN1ZFlPU1NMc2I5WXYycEt1MmVw?=
 =?utf-8?B?UTE2TVU5dG5WZkNGNjY1RkprWlpIejkrZDdicFVmdDc0Q1FjM3BBbkE5M3Vm?=
 =?utf-8?B?bnFlZEdBdUlua3BPckFzd3dJWUZFVEtFWlJBc3M1bXZ6ZFJ0T3hmbWkveVp2?=
 =?utf-8?B?U2hXUXpHUTFUTmlpUDcyWW80SjloQVBRclArMUp3UE1uNmVzSXNmTFNiVHp2?=
 =?utf-8?B?SVVzME9KQXpXZnlBbXh5Y0g0RnRtZXc4Ui90dlhDRFg2ak5LZkVFZGZ0STlw?=
 =?utf-8?B?cjJxREM3SXhGMWNUYjlBUlcwNDFmdWRuUUtYcFZOQjVuSFdYQmQvQTZ0cGNO?=
 =?utf-8?B?VWQ5VEpVMnp4MmtLOFg4N3ZSRVp2U1puc2haNW5JSVRvWW1KSzBmN0xHeUJ2?=
 =?utf-8?B?ejRoWStvMVZIbVV2azhyWUxpaGJKaEFOQXRxSk9NSTQ0MVlHcHQxRVp6TmZZ?=
 =?utf-8?B?V3BkSTV5aDVsTmJvSldrdHh5M2pIbXdpelY1aVcrSkNBbkJCQlJObGltQjVG?=
 =?utf-8?B?Tmh5ZkQ2Q240bzhjSFVtYlREUTh1QWpDenVRZm9IMXRNWlVPVFlseXZDdnpw?=
 =?utf-8?B?d1VtUlVVR0NxMEdFbGRhY2k2eWh5YWlVVkgrL1laYXkzYUEvOHV1cHBwRHE5?=
 =?utf-8?B?OTltMVYxcFRZeS8rL1hiekpjejlSVWdMcjJBL0k0TWIrdlQ1ZjJQTU81c3kx?=
 =?utf-8?B?emJReWNCUG9DUE5CY2dma2ZOSjNMbEZ6d0I3c2FBLzZxaE1HOEpyZ3IvcCtr?=
 =?utf-8?B?VStZUnUzcGZXdHdFeDFVSDlwbW1rTE1DcTZ6eHg4ZmErRzZCY1FtNituNnlD?=
 =?utf-8?B?WDZqK09naGd5NmpJbkxjOXV1MzZ5OUl0ZGpTQ3I2aFFVdUpIeVR2aStJaEZZ?=
 =?utf-8?B?VUxuY2d2d0Rmak9FbnRVaXppSlBWaVJyYnVGdStuUERaU3dhVXBnS0lEQ1VZ?=
 =?utf-8?B?QzU3TXV3RHByNkJwMDBqQi9BS0RwOVlQai9uZkRNZ3VFMmNKUXVVRkp3aGJP?=
 =?utf-8?B?ZzZCMzh5UjdaSFlPeGRTajgvU09HemVxYldlTkJnTHFWa2kybk43djNOUmVF?=
 =?utf-8?B?UVRUeFJ3MUxlWXF0a1prTFhOd25VcUh4Ynp4VTR0Um5CV0xRczBRSWNjMDhh?=
 =?utf-8?B?cnlCd1lmMU9OelRYQi9VaW9TekJiWkVDRGtWbjVUOGZ0SGdCMjdYbEY2MWcx?=
 =?utf-8?B?Y0xZS1VUNDFhd1FXZEVkZ3BHUzlQMzNzbzdjM2xJODdzWmFScmZmSVQxa3Z5?=
 =?utf-8?B?OHZwTEx0RnJueHNPWVdINEhsMkJwWW1YUXMwL256SVdnTng4bEExenVBOHpa?=
 =?utf-8?B?SDdqMnhvcHlXQU5RdGJTVzVTTTVMSVRFS0U4RjdkTHFqNlBkc0FOS25GSit2?=
 =?utf-8?B?MG44aDlBb0JjNjUzTjJ0WTFhcVBNVmZNRGJqUi8vTnM5b0JpL0RCZzBuUVl3?=
 =?utf-8?B?amxLcHA3VThjank2UVh6ZUJVRGc2MU5keFdiaDlPN25BaGpRcVYvYjM3ZDZJ?=
 =?utf-8?Q?V8lE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vzg1MGRCd1d0VGJxRDIrRUF0VEJxNmg1SDVrV0ZmT1ZwREtWYThGMGdjRzRB?=
 =?utf-8?B?Y2ZDVkJMM3pCTVZHTDEyaXp3YlV6bms4N3pMNXFOSzFFUEE3ajdWaGxFUFV3?=
 =?utf-8?B?c1Q5VDdDbWlhL3pYTDNiWStIdVhObTU5WEdNL0FPYnpyalNlRnFBMTRHcUhJ?=
 =?utf-8?B?Y3c5Tk9iR2dKVGlhb1JzRmJrbGdSMi9NSWJJaDZZVXRPUTRUbDdqaXFUL1lZ?=
 =?utf-8?B?cWZTNnMxLzZ1M1BGMHpWMys5b0Y2WFIySlZqS09wTWY4TnFsdm9GMnZ1ZENB?=
 =?utf-8?B?MjEzOWM2RGFLZmpUcUZncWY3U3J1dTFBQm9mQmhxUG5DZVQ0M1dzdVFXSGEw?=
 =?utf-8?B?M2VNRWRNajJvMllIZS9Ld0xZZXRPb1lPSmF2NW1BVGRRbXVXRzNGbUlmWThU?=
 =?utf-8?B?LzNnVjVBT3dJWnpHYWFjT2Z6dW1KY2t3ckRPT1VtbzZ0UlF6L0xVL1lQclBm?=
 =?utf-8?B?Q0NWK2FxZlV3blZaR0JDRzNRVEQrd3R6VkhIMThFQ3kxbzd0eTdGT1J2Vmlq?=
 =?utf-8?B?aUtLNDZPbFp2S3IyS2NSengrNFR4RU9mVHlSZXIvRmpRMEFCVkFISlV5UVlE?=
 =?utf-8?B?U1NJV0J4UjVPL0oxeE5hYzFUamszV1JQKzUrS1A0SmNjMzdXMnkxdDM1SlJu?=
 =?utf-8?B?S2N5ZWNSRmIrRTdadmR4UzBiVm5PZnBZUU1laExXRUI3d0ZaOEUzM3BaNnhX?=
 =?utf-8?B?RGh1Z0Qvb3FtbDgrUUhnc0lveE53Q3VYdHdLc3VDRVBaa21BSkFzUVVqcldH?=
 =?utf-8?B?V1VCUG1lSUlVVWIvOEszTktrVTBRclBpcEM5cmNzelFwVDFOM25ld3lrUStU?=
 =?utf-8?B?R1oyOTRQcER5WmtNbWJQeVp3bzJWNVFKOERMQUNGY0N6V3kyTUpxVjZWbXNn?=
 =?utf-8?B?UW41blVzSDY4bEdPdG8rVkVPVjVjYlpCRHIvbXlFSlZkWndWVlZZUU5xNkhM?=
 =?utf-8?B?dU1BRmpIZlNnREg4ME50SHdkQ3crZ2J6NmQwYkxWWGFhY2REaXdWTFJpa29I?=
 =?utf-8?B?YmVyWWUzUC9Za2M4dFpnWW9PaTMyOUl2RVV4ZDZPSWdQRG1mTzd0RTZUZ25q?=
 =?utf-8?B?aU1ua1g2MzRRdVRKNjl0Q0VqdGZLelZZU25CbGxJaENxaGdESDBuTnRxL0Ja?=
 =?utf-8?B?dHJ3dGNBMTQwNEdQU2szWTJlNXJrRkVTcWhsVFo5WlFwTlh5dVJZOTN2SEJJ?=
 =?utf-8?B?eXJybjhyS1BXOENnUzNVSWdDOGtFVzR0THRNK2dOQ2hieGUyWWRqSUs4cmZN?=
 =?utf-8?B?c2xKWFowb0gxOGNxK3ZvZE45Rll2ZW1sMjg3cmZvQlNtU0N2aUQ2Zk9INWph?=
 =?utf-8?B?VW1VVzlDSkZaZndwZXZmaXZGdmZvWmFBbXBKWXFaY2VneTk1UUNiQjZDSUJp?=
 =?utf-8?B?aFlUNW1WVzZyclBCaE1tZjZyS2tvbDl0bEZrWEFEWkEvYkpvZ2IwTThwa3hP?=
 =?utf-8?B?a0ZES2xWTlo4bXBUWkdWenNHMUxwYU1xOTlaYzhPWWw5WU1hQXp5RVU3VG9E?=
 =?utf-8?B?QzhIaGxRdEVhd3Z4azQxNUhlSGV5N1hoZHlJV1VFV09veHZVcmZ6UEhWM244?=
 =?utf-8?B?SXpGNFpONCtSaEt1aS9aaDR6YU9YVVlUOTlqS2hnVlJOeUxiT0Z6U01QS3N0?=
 =?utf-8?B?WGxIUFBRMzkxdzM3S1BKZ2lPVEp3NHhUcUUycytzeENQZEVJRkEzMHhTWWlF?=
 =?utf-8?B?NGw2NHIxV28wdnJMaWwrayt2ekdXbEs1U1czQ3pjcVQvZFhoMmlJV3JBdmY0?=
 =?utf-8?B?NjhyN1U3dVphVWdMV3pKVnEzb3hlcWVPT3ZZYU9QWEFvMzhQb2Fvd2RtRHlV?=
 =?utf-8?B?Z1NOdVk1Skc0aTFJV3hUTVZLbFZiQ2Z2TnZRRkZvZ2Zid1RWNkRMelR6eU9I?=
 =?utf-8?B?eEgvRkVvc3d0bU15NlMzdGFBSUNxR01sMEhJRkZENmE2d2dPYm40dC9CYUd1?=
 =?utf-8?B?QnMrYWdDOTB2VnFMVzVaVURZcTdxUTlCUTVrSFlaSWJXRktycUZjREJRZUo1?=
 =?utf-8?B?ZjY3ZE5HK2ZsL2ZCZDNNLzNTNWtKelpMUmFGd2twNWU2K0RsZmN2cTBBZ0Iy?=
 =?utf-8?B?eXpQZ0lLb0VHbCs5eWF2U2JwbGVZZ3pGU1FkVGM1RUVGeVU3d1N6amw2allz?=
 =?utf-8?B?NlVvK21MYXM0T2xGNm5meGx0bDVHUTJhRXFQbXdBOFNMMGdqakdvU0pPK3hR?=
 =?utf-8?B?Y2Z2dHFnbzRjeGlFeUxRSDJKS3ovWkdjL1p3amVxN0N0RGkyRmFTeTltaU96?=
 =?utf-8?B?bDlJZE5BSjRGTGF4MUt1NTM5SjJIQ1d3MzJDZzZrTE9LMkdBWGVlOUNmYnFt?=
 =?utf-8?B?YXFHNkorZmd0eTNRSFhLbGk5K3N0NmxhanJZWHVMaTRWK1hYQkNnUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d759f0-5d40-4f8e-be50-08de638ab42d
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 01:14:11.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uqFT3b4ir7ClYREQYA1yu4uNvpVZWmC1hT5IM23a5TQQs8vq7OwdKxuhLmhEgSsn+z0LBS3KyTzSVDzfuLLs0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 431E5C0004
X-Stat-Signature: 5w7o1fyp1nma1u4uhpejui4mfy738rm6
X-Rspam-User: 
X-HE-Tag: 1770167656-999083
X-HE-Meta: U2FsdGVkX184NnumxQoYQXvZwSanQvS7p3WJAV23ZOexS6d/EzzSGGCfdlRhLhs73tUt6jPrzCJMqUeHL5fhDJ17lwa40hO35oNA50k2hwUsZmF8VVEcUaLa47bAs6NlWU44/lo1+G44xGZfPMAs+5QmdmmDPm9gO2Ka47R+ftEmZQ1sDaoOIB+5kGX9FHCHJ0ybV8pwp9VwhllyY0nC3aRi/8MoJ1ZGPP3YuItJ8J1/yDaeCIsPI9Rjxc3ePM19XjJ6iFwLN463KCSReR9hTOm82QF0Y3W8ux7MCT9fBpZcX5LGGMgImCRS97nOVR2e/1zEoOcC++TX/yrgvpAMuKfFSTE5oIPThKF3eBtovJJ+lAxYQK628kHYT1NK77ZuStnT5CCBFW9vnzJ7ETdvbj8WVyRZhWLC/yb8L+ge80Sfwe4JYFIP1fPy1Ki2sf33/aSOogpIddHDg4wGUg1bSycrYmRSwP+rrdJZwsoOeJpT8AN3tpqCWSBV3Z8L+ESW0n/frYxXHRiaGbXroveLf9rN/um4NofH5U4YYKt9h6YTSsz3K0c7gApN63Otox+9wGzf21T8HFOmh1Yp7wXpBoFRkzxoNexc7dHATTvB0VnXlMMlpE0sIguHfaNZwvGyLKfkNsXxr/w5CXH6Jvq6v3bdteggckAO7zWmHuJuP/74FagN9Fm5iBMUoO8t+M4w9zYzveewKw2Snloe5JDedHV6Fc8+BglJQ9KKyHiYYA1hjnM1GU1/gfd/4a13Hiyj6WCHz2bW96075vDkp2WoiB8VA05+jKNHU9Vy/IJ2TUfd27qZoheYrpgAHxWXM2xGCjm7BdpXJDaYSF+qQm8CPJeNq7yfevMxLQ4dt+5Ek+6uMHt4Fycq9Fm4QEQwvMxDv/I0FytM1CFrTkeMRsAGzrv3yabYn584w9USsvmYoE+g5wtaljBMTcEDQhNL1EzjMOmQ002lxW/GI7LVEgg
 12sFoZbW
 IxYaSoZ1LvP97U3ZGynVaqsB3fJjTiS3KKOUvD5xYn29VdHYBaFcdS8xmJuPEpl/3gWMqksLqb1NkkCzT9vVVkdxED/gf1TnHSwY2KERXMROO119BGyaZQf1woY8kKXiZKcuKaWHYX3fBbI1rZ6SmWy7cEgvu4DfejPKsNxjnlXAbbrEMvwFtnXnaHKV424eJDyJT4T53QxYKbo21FdAAIdwr5rugYOso4uL1TzCKukM+FHeTj66d/rWWLkDHxopPTo5OAgn+DpZ0JJRjPN+TUNi8uWYzN+HnJa+k54oGeQPXehBaa5NfmqRyNTdqVfEX0Tewz9pdfUejHMAQYhFUBobl871BOgrnq0eUpCEHWDai+2mlQYbxQlgK84ELorUCKvUu+bE79YbnbYWOQL2jJlfyYcFrq9WBjzUxcksAgNeeBoALR3/ely/f5L0s5m13QgXoF3uilH9TXCFjoUvRRBbPhzKR5NfLdpgShU057qKMmX3/yrNNMYfVMm9u4CnpsBfTwsi3CHjNVAGdyvWUQUvDDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/3/26 1:31 AM, Thomas Hellström wrote:
...
> So this is what I had in mind:
> 
> I think certainly this would work regardless of whether pincount is
> implemented by means of refcount with a bias or not, and AFAICT it's
> also consistent with 
> 
> https://docs.kernel.org/core-api/pin_user_pages.html
> 
> But it would not work if some part of core mm grabs a page refcount and
> *expects* that to pin a page in the sense that it should not be
> migrated. But you're suggesting that's actually the case?

Yes. The migration code itself, in fact, uses folio_get() with the
expectation that this blocks migration:

migrate_vma_collect_pmd():

	/*
	 * By getting a reference on the folio we pin it and that blocks
	 * any kind of migration. Side effect is that it "freezes" the
	 * pte.
	 *
	 * We drop this reference after isolating the folio from the lru
	 * for non device folio (device folio are not on the lru and thus
	 * can't be dropped from it).
	 */
	folio = page_folio(page);
	folio_get(folio);


I'm experiencing a bit of local-mind-boggle at decoupling refcount
from pincount, but part of that is probably just bias towards "but
it's always been that way!". haha :)


thanks,
-- 
John Hubbard


