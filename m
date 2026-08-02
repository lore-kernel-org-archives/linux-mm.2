Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFA6C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 22:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C546B007B; Sun,  2 Aug 2026 18:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1CD26B0088; Sun,  2 Aug 2026 18:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C356B008A; Sun,  2 Aug 2026 18:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 689CB6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 18:44:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4BB1C03C7
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:44:19 +0000 (UTC)
X-FDA: 85057809438.10.0DBE9A5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011016.outbound.protection.outlook.com [52.101.57.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 32BC840007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 22:44:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J1dcpUsR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785710657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXJCsZD/jXbVpBLk7mx0hG2Iz4fY8O9lNJ0vIvXmoP0=;
	b=sK8bxuEjPQtq1a0mj+H2jY6ByLsJRQbH0VKeAaJQfT7PEeVS++QmB2SbxVl2tXIW3deypR
	XXJLoUyCSYRbuQHRKts2TsoeHtB/kWWplVgFiED/18C7+jZA3IOwzLuqu9Y1eeVL5JFq6a
	i7dz21dcD2rfEoVI9b2tawi403XZEyI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J1dcpUsR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785710657;
	b=PJS9P//DCpHocCYIr/aqRAD0INHh7lcj/uQgENOL2dPfkxuYmiCXhB/0g+zxj03hWdCInq
	LBs3TeEqhsGkOZCLAuSiIthMkfTfcpfEMq/7Ga6m1jU9E6k738SMTMtLnI/aHsXmXfPmoP
	biU1lm/ew24PIMxpm+cssHRU67zRPsU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L4oVndwd8SK+8TNbIjdenzqvPnA05NSfuGaL87lS7ZT9Ng8aviF98FmbT4+kcMj/S81aFXKz1Ln+jRS+ZXFOkcKc0ODjzHUVTX0EFIC9mqwU1sH7uAdviTGEhqHeYvAo/Ky29ddAumJA5rVpN1ypYtjqFt9MOhTbpoOjK+cLdjK57iG2RXyRfEPNua9exXVo5zpKThVefIEwEsdboG7vcDS5EQ8X3j0g18bENFrDIdDUy5gc3rH0pYJjb+OGUEykcZJgyEaXByJx4VAcLQklIcQYJm0N0+kD3ZVNk7Y3zmTSPAGjdcXcdIYp3STQmqkFg6Y+5T7Rkkwzf5nlIqnDKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXJCsZD/jXbVpBLk7mx0hG2Iz4fY8O9lNJ0vIvXmoP0=;
 b=uekymOafv5UGFr85UkbGwUM524qUkIF9ycnDKvO1en/5yDCcIuf5vRRK8WXq+rsAgcWOp0Qkv0QBw8kbbVPAhvgw3/4ZJWkONzfmpwjVB5ZrdTfM/qgM7qS3vN1YnZv1RRttdo7cKq0dtMDAq5qStdEeVBB0PGEY8JrL0o8NTS3uXY0oD/tMLgeQKqhGONC5G45BPL0ZqjBdM3bLaHg2thXwpvUqKhLEHQdwaQd+cE7lHOdNK7OFDFV+9m0zc3TGKg7ijFLeizt1urWWOO6kW2dZAVHx+ilYTqJdosik5wgKIg2JCBnJAo0+lXyYt7am0AiiROWfjd27M7XeV/bepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iXJCsZD/jXbVpBLk7mx0hG2Iz4fY8O9lNJ0vIvXmoP0=;
 b=J1dcpUsRPjoVAcjM72IkBEWfX9Etnlk1sAVkxy3rVXx/cVvJmy4tFVmK7Z3xU6HS1GJZcoxFmH/7xxeVgFH1lYMT4Q8Q1YgzhD4EQ71hvoxFf/RLNfQbYHw8ER8LfIHxc/ff/sAyeOnv2j6SIHGeyy0PtfILumJvT13sTSE1StSBkc/Y2RfGwRa/UY+pGFlxVeQ3iGAUmQl32rPBNm1hz5wCnz81kOg3KwjujUpuCmbJffWO/eTnT6jOFENDv6dYnOMPCmRFaLXn3uHbVRmt6rWBtZ0Y00kKlCP4qYe13EE7MS7HYoXP1PdpGzUeqCbvcrnqzY+4HtZ7Amc4+e/m3A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB9037.namprd12.prod.outlook.com (2603:10b6:8:f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 22:44:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 22:44:11 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 02 Aug 2026 18:44:07 -0400
Message-Id: <DKETLELGS8KI.1B0MCAPS99CXH@nvidia.com>
Cc: "Ilya Dryomov" <idryomov@gmail.com>, "Alex Markuze"
 <amarkuze@redhat.com>, "Viacheslav Dubeyko" <slava@dubeyko.com>, "Jan Kara"
 <jack@suse.cz>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 <ceph-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
To: "Matthew Wilcox" <willy@infradead.org>, "Tal Zussman"
 <tz2294@columbia.edu>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/4] ceph: add ceph_folio_snap_context()
X-Mailer: aerc 0.21.0
References: <20260802-remove-wait-on-page-writeback-v1-0-6c35d6b3ad36@columbia.edu> <20260802-remove-wait-on-page-writeback-v1-1-6c35d6b3ad36@columbia.edu> <am-8AaWEHm7I9b7N@casper.infradead.org>
In-Reply-To: <am-8AaWEHm7I9b7N@casper.infradead.org>
X-ClientProxiedBy: CY5PR15CA0162.namprd15.prod.outlook.com
 (2603:10b6:930:67::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c5271bd-63db-464f-fc06-08def0e79215
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|18002099003|22082099003|56012099006|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5ApD7PVEmuksINXtxVOiII6THSa/pdjWPDb6IPARnuFLoBrmHsR4L+JkJ5NTJhIeypXsYpzO6S4+8rwPv4DbssNUUfQX62GBBqRRvVrNNhM0shmat5xEymBsYgrqiCmpz2S4e2MrMzSQzVRucJolDXB0DqOXK+BC+ZysrOXRRCgNDk1l+UWFiQzt3tY5rLN9aVt5uhWQZBrj/zteRKPQ5zWXySw4S3hMw0TjOUcmEzAGwPxmQhY+EGPYv3rxOfpVfIx6UFn5KcE+fFsrmVrp+6oMD+vJFUsZLEGYXrPBVQqTMvtmtyeRuf46MUzlxzHSCHXqgpwle4bWfElknZJ3AwPd4eGIZWRwkKDbfayxIELnO2K+sTKZ2ITviI/1G05Nb+VppT8EnCPRpKqI0LfB7p9YBxXReL8O+RRy4jfTeraE1bvXJSoFQJP8Z+Fef8m1YFnNR513xhVOSPsN0qx4/rbeGENZjM/Jrca+Ufu7FEnKlcms98lG3HBjl9KzYfHXECSA+JtRBB8tl+zfBelzZZAFSnm8IOfet3TPlIHK69k4wfwliJ8aCxezpnOxzB3MuVAwizAG3gHRjovRQwhlSsykI2wj4gGTSUkxqF6OeyhQXXzgR5M8pnXFVis+lE9jWpIbgALNZOEIIgLj26ZbB5x4QbXAN5r+jtrC0O7/v2Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGpKYXdwVEQ5SGV3Tm9DeFZIU09GdFBYc2VHME9oV1lXa0Uvd2o2RUZudXVP?=
 =?utf-8?B?QnZtUXJZNGJJTUNmS3BrS3JQclZNakRnNmljZXZJQ0U5TjJ2RjRZK3NRaHJx?=
 =?utf-8?B?L2tIaXNkMGVEbVIwUDI4VnU4dVdiK0dNbzRrZC9HdlAyeU8vTUgrOXpyMGFz?=
 =?utf-8?B?aUZzMElIamgwL1B6QUc0WG5kNkprY1hTK2taSUhJMzRJclVVZW9lTnhnU09G?=
 =?utf-8?B?Mk13Z1g5Wlk3YzNQNTM0VGVlZ2RlTjFja1RqOVlBS2VZU08zemZaNUpwcVlz?=
 =?utf-8?B?MEUzV1JHT3krMGZZdUZoWmhIKzN1T1lZV1pvNjNTK2ppWGdCOFpvdlYvNFhI?=
 =?utf-8?B?R1luM3UvUWY4bVZTMUh0ZDRmUU5KQmFXM2RZVmx0aXhFQXV3VzBWd1EyVmVT?=
 =?utf-8?B?bGhlSktQNTEzU0c1NTU5VUhjZkhOOHVpMnhNdllnQ2c0NlM1RVFCUlUzTE5j?=
 =?utf-8?B?OW4zb3lSaVBuUWJVdXVJc2dBNFhBYVZwdkhYdVFFcWVnL3NyZFVpR0RxWTNk?=
 =?utf-8?B?NnZFRmNNdWtHcFZNTDMzTDRic1lsMi9BZGNsQXh0T2ZsQStoR1YzcHVDNGkr?=
 =?utf-8?B?WFFSMXMzU2oyblo2OXB2R1ZLaU9nTllnRlNlZ1Nrd0FDQlJGOER4QnRNUkM1?=
 =?utf-8?B?Zzc5eUFQMDd0MlJORGJ3OGNkNGhHalc3WVFJc0FRZTZSWG81UHFFUjlES1Mv?=
 =?utf-8?B?VDFHN1BHNlRDeC90RFZZSkZabW9nOWg2Uzc0TjhMeHMxZUlxVGlFTTA0SzFF?=
 =?utf-8?B?a3VTZDN0WDFMeGttWkhJM284MkRLUndiRzMwS1NUc1lYTVBIZEdlV2lSSGZi?=
 =?utf-8?B?TlE4RStBaXZSaEwzYnJFM3VyS0lzUGx0UndUaUtSckRsRDFBVm1PVFNmNVBT?=
 =?utf-8?B?bWl1Y0xZRUdxVkFDMVgvWEVaT3BoanRsMy9RSzRCMCtCRE8wdWZGSDdFRUt2?=
 =?utf-8?B?d3NCQy9hWExPdWVUTzd6RzRsakNLa1hieGd6ZmNvQ0paZlltRGphQlNDR1Vx?=
 =?utf-8?B?c0k2alQzYS9OQ1pnWG9UdEVtQ0hhR09FczAxWkVQcmdVSXZpSHo3anJDaENF?=
 =?utf-8?B?WVdDVDZuSit2U0lrdkxTblo1M2h0Zy9ScllLdlMxLzBydks0NjN5OU5McW5P?=
 =?utf-8?B?QWMxSi9CekdobUI5VkVpL3JvOVdneGd5cXF5QmE3SUZZeWF0K0pRanFRVjA0?=
 =?utf-8?B?MXYyTDJ2enJDaWNudHplMFZoYW1jc3RXL1hLZ3IvL215bWJYMTNleldhNnVo?=
 =?utf-8?B?MVN2U081cnZOdy9ySDc2RkR2ZllIeTVXSXpKVmNFZEdjTnhnVndOUFVuZTZi?=
 =?utf-8?B?NktyeHpwU05Ycnpuek9ycmp6cHpDWXJDMklLTy91MUhIM3VIaXc1c1NGVFRK?=
 =?utf-8?B?VFZHczhhVStzZkdaeGVwZmJEOGhtcklMNzJES2VIcmNpUmxucEhjZW5RZmVP?=
 =?utf-8?B?cEo1L1VMZHh1Qk9nSHNGclpQY2VTN2s2N3cydnJKeHRIY2pPS0FHY3c3L0c2?=
 =?utf-8?B?VjRZUmFpcHFOTDdHOThHM0JVdW92UHYxVDhOYWtSeUpoTlQvQTBGUmpsOE9s?=
 =?utf-8?B?eEtRRmVrS1dnNTQ4K0dZbmNPOTJHeFpDZnBlMTNRb2cxVERnVHhpbXM5d3pl?=
 =?utf-8?B?Q0xEdisyb3dPU203OGY4bmplRDl3bHRqYzV0T29EVnhKUmZMOEhLcm9ra1dk?=
 =?utf-8?B?Si9tM0M1ZE9LajFIUmdTRU1YYlNTU29XNTlRWWp6SFJpM1pCTFZKc0QwUngz?=
 =?utf-8?B?VlNxSnNYczJ0bU5BYS9ubnhDY3NPcE5XU2VBTldJcjZnOSs1dmVhciszTDNZ?=
 =?utf-8?B?MlVpaCtuL1E1QXB2cjVrWGJuQkxZMDVBa3VBdG9QMmtuRUlnMzdKa0tTejlO?=
 =?utf-8?B?NkIzMHcrZ0FyWTl0dTBlbmJzbDdpMmZEekJ5aVF6dUdCanRHSGNmdmIzNkFa?=
 =?utf-8?B?ek5MKzRkZXlLOFFaVEI5OFpkWnZ3Wk4vc2RZY1Y0Nk1LWGVwNFl2ZjFxcjhW?=
 =?utf-8?B?MzdobXlsYnRIMnFVdGlNNndWdldsNjF2YWpCV2NUZUttanhJYjJ6VXo5dGZy?=
 =?utf-8?B?Z0p5LzJBUldyeVB6ejBhOXRGKy83WUhqWGhiTC85U0RMK0pwdHU2d0hlcVhv?=
 =?utf-8?B?aWlvY3dqZ2Y2MmlaV1NpT3dEUG4vUUdtdmRPdmNRWUtPYlVjbVVaNWY2T2xt?=
 =?utf-8?B?UFMxOWZkZXRPUlowbTUzbjdZYy95cGRVMGh4dDN4elhWSzNqUkZHVEdrcW10?=
 =?utf-8?B?TjcxK1VWZGc0VFEvUW56VmJ4RDZDcWljcExQM2FDMDFCaHRpdWVMRkZ1OElS?=
 =?utf-8?Q?nZ4wdAyyH//3j4T5Fj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c5271bd-63db-464f-fc06-08def0e79215
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 22:44:11.3295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYe4A5qjJ7KVRZJDIAs5AYJeyJAUbd6YcxZhImYE45Q0lsilMRZ6qwQHJARZsHnI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9037
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32BC840007
X-Rspam-User: 
X-Stat-Signature: ey45kuh8s4ur1otyh6p4u1wrya7hb5zy
X-HE-Tag: 1785710657-369963
X-HE-Meta: U2FsdGVkX18UZt3su0NRKaL5HKmKmSevVjc4Z6NgS5+yvI/zgaoHv+f9WfJvMUZqGXmgTX3+dFF3WcTjHH6tXjIhAQL9FfmUF5Cl7DFhlmX2UTyBvoEMIKuNKCiGdQSxYMuKCoBNVLSwuj2se89k6/aBBmZ1IAsyncOZ45IG0Y/aZAqMzk40n0A9U8FcTAqcPgu1uBpLS8HkX4xPX3mFEz4UOLWtl9Os6T4NBikk0B/9zR64TTgoVfK98g+1aPRhOoxBKZWjAA88AvPBC7Ly5Btao57EuZMhZkfc32KoCM3vsWkapCY9qDypTdt3wAfOTRFReWbsWSk8T5j4LgRSXzb2Eqw4yvxzSN/arf096dShg+AMxKt95jT/Gy2oKjBnDOncLNPhrhKvHOZbDDSpqyjfVSWxt1HEKakqlP+chKFWCsN0sW9dRo+drBTcBA90Xm+o7OTjjMCMO1f2aB1FLfnJLQEN4s6ls6qmthaqPsPGM9wVIHbkzy9SMnwh9EU4NHM8kDq1iJjsDkF25cCUuKkTcr2PYJ4+zzXnHZJl3XJtdMR11hRhwT4OtkI9r/TCtgWodE1jbHEvdGDHPNy1+MUjpd2D8Wl6Dee9uUcGC05PCGNb9E0TdQpXzzwKh9yS78GrrYGP/N5mVTNAQeE39rOysG74YUUqG5QqbXFKAl8iRRqSTVPw+xc5fRkX1xj0z4Mv4wyNKx+wqVrML4hOfY+GHMwUaz/n1tIY4EN/6JgGMZ8igalXeFjyDcqwp9mq35y+wQKIqM3HPk8JNi+czzQ6f+YRSc7xzxG5g1vO5U8S5x6yXnZ9Z5zRCEgK+/TqK+JP25kDb2EYcU8GWPubaRWRCbsC8NfpEaxVobUeKzPIjmgrKmoyMi0Nlu+Tlcxt/9h98ek2jAQYC3uA+QsKuJz3B6YzVdxfwEJs+fyTAAP0uKhhSTAVz7MSV9uT1oZPAAIxxWs+KcJH8syAYAE
 6mb+PQhg
 bfzDcMur18swySL/DYLNBzDwL0DGpmAPysVrR5SIQBG2QlcOX6jBzhFe7SESR/RvYyT5rM2KqJ8dNHup3XTcJ1z3pDcdO3q61xqRatHQyk4O0hCPN48mQ+bKBOFcx6i2jcma03l46idNNaPGdfxY/WHibyvYM0+8ww3HkkkR8r+OLjXkdY57MZYYqVlVjPok4Ag//zQGihp7qtgBCLugfEbSsBeO8M4FtsNjm0mgBDQauuK82w0LYUX+tRopfF1kAM/1ie45cL6ZgRgHih382sHxrACk1JR5/S37HtwuO9c6RrhbJV3AjyddXHbWuew3/zeJbt/ynP2WvNzJLXqU7MjiXHx6T5BGF8UFO/yqSUee+FoEZhrWoqM9L+vcc5taJYHGvXzgBdhaHWTY2vDcaTvlpj0nCUOz3EJHGy4GaVs6PSf0Dq7BmnkvX17jnhXdc0Oo+qJC4xyxoMUsZEWavU1HTNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 2, 2026 at 5:52 PM EDT, Matthew Wilcox wrote:
> On Sun, Aug 02, 2026 at 12:50:02PM -0400, Tal Zussman wrote:
>> +static inline struct ceph_snap_context *ceph_folio_snap_context(struct =
folio *folio)
>> +{
>> +	if (folio_test_private(folio))
>> +		return (void *)folio->private;
>> +	return NULL;
>> +}
>
> Filesystem folios _ought_to have folio->private as NULL when PG_private
> is unset and PG_private set when folio->private is non-NULL.  Now, ceph
> could be doing something Bad (I believe hugetlbfs does not honour this
> for various reasons), but it looks like it's using
> folio_attach_private() / folio_detach_private() appropriately.
>
> So I think we should just do:
>
> static inline
> struct ceph_snap_context *ceph_folio_snap_context(const struct folio *fol=
io)
> {
> 	return folio->private;
> }

Yes, please. So I do not need to handle another exceptional user when I
am trying to remove PG_private[1].

[1] https://lore.kernel.org/all/20260731-remove-pg_private-v1-0-142c97ba356=
2@nvidia.com/
>
> (folio->private is already void *, so it doesn't need to be cast).
> Splitting the definition where I did puts the unimmportant information
> (static inline) on the previous line, so somebody grepping for
> ceph_folio_snap_context gets the return type, while not breaking 80
> columns.




--=20
Best Regards,
Yan, Zi


