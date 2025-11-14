Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADCCCD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:22:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1E18E0010; Thu, 13 Nov 2025 20:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9D18E0002; Thu, 13 Nov 2025 20:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9984C8E0010; Thu, 13 Nov 2025 20:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 854F88E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:22:33 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E27A1601D1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:33 +0000 (UTC)
X-FDA: 84107462586.18.A3457D7
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010047.outbound.protection.outlook.com [52.101.201.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86B4E120006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:22:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="h/pEpWg7";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763083350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OThvmawgphxly6SPv5o3jeaEqyzdRNg6g76Fjp1KIAE=;
	b=OZXMjbXkeqff1nvIYKqFv64T3HLlExNjdchIMK96llVGmTzVl6PZcaqe36oN+2sCbylapg
	kO5ppi63zVsyfpeNRU0UJka7x9lwJtLDdS6/jg8sJcquzYCNKwT/qTLElnVIaiJW9rZHv/
	BgryNQEk52ViGNP3qDSikIyVTXfzwxE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="h/pEpWg7";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.201.47 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763083350; a=rsa-sha256;
	cv=pass;
	b=C4Hs0oC/hqAD8jA0CxvPkX2URdwKCmtqUWDyth4fDmK7K0bnxKbtEfzCvx9mzrYCPHyQ1y
	ze7uqnEVeBIp33rGQA7wu8P6YOhcNyQN9zMI8c+akziH2nbaRZetfvmKv4M0D6vMZQAl2W
	nYAI72ES+aBUhC6qroB2gh2LLUHQl9Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VKzaoSO7ByY+oVNKItoIjB/vSOZzcsR4zt7fsB1xS7sd8T1pwjdoCMyA0JU+m/SiWRRAYnZk0EhDmQ6AWX69jSsBv0ncLL6ND/WZ/XwHAWnyO7HYxZJkOO+povenzKUxb3tbnFkcLmm1c3rnlPtswfRCt9nOgMn+zrhJZc783ENJvqpNuEyPKHLV4XvgWObol49cH5Jdx2S75WksG1yiH8Z5VlwFU1Q7CenP7C6WwEr6MklTRHuZvnGNN8JOG/RfezvmShABCHwvzdmmBq63dK4vAloBh64Nt8o+8SfwagElBI0FcIet2FNLjP3pZZhlaD0HIrfELwKzdhbsk9DXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OThvmawgphxly6SPv5o3jeaEqyzdRNg6g76Fjp1KIAE=;
 b=j6rU7BZ2X2yxgqONwNLpwJ9QjsglIj3r0zVsvv5OtSVgQ3xRyj6c1bW3tw2D6gDUbJKjosjoAQD5jD+7yFVjR47YmpNew5XQG5Ow4z22sJu6UYdvs/xa5AM68Aes8T/gyBo+zr/8knZTBaDZWUWoXxXJzrFl6cExcfjW9esGmIBpXzie5TVcoRsHvpO/5boBH+lwGjnt6rQWfkNM1mNeCr1Pi5TFMNZf8SeZv44+wPBHq7yNNoU763o+GdoLsd8xmnJDKSoFEhzmuXCw3Atu2XKAmRGaKjVDhWvmKiz0m6Iazelbleyp+/NyAC+A7+QzgdLFdKALNZIcsPuiAYlFrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OThvmawgphxly6SPv5o3jeaEqyzdRNg6g76Fjp1KIAE=;
 b=h/pEpWg7OywAhPV/+eYT4S/cCnDg0fyRbbXIvoFbkd4cmvXym2Htx99CZ2JgFlwQbPu+SUGuo0oQBcxhSCifFkw1ceefXlSQzvG7Yy2P+AEy6BsgIYSvnT6OI+in2J0SJwkkmI6BFyV6sR31e+WxBVh0qWhsQ2D2QT56kAPxh5qPBzRmRwcS6LRyZhUTsb7Cc065a4kjvEkq321teU5iMyEpFO+ZNoai2UrM05ObGEo40WMCvt4cmXKfnqy+bMLfZhqUqw+ZBoiWltVP2esug6BZSu3TJrB5c0xdeX8JXpbvyAn3vIc6Yr+Dw1e4cZxIvf5gaOozsuslXcMhazLQpw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:22:26 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 01:22:26 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org
Cc: Balbir Singh <balbirs@nvidia.com>,
	kernel test robot <lkp@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH] gpu/drm/nouveau: fix return type in nouveau_dmem_migrate_to_ram()
Date: Fri, 14 Nov 2025 12:22:21 +1100
Message-ID: <20251114012221.2634832-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5P300CA0092.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:248::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fdc4166-957c-48c2-059d-08de231c4530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnMyQXRScWNLVUYwcnR4V29qRGFWUktqcmg5T0dLZU5sYzBpOEFsMXFjU3d1?=
 =?utf-8?B?V2tOVWEzVzhTcE1kOVM0SjNpZkVRTkxTQVFNN1ppQ3U4M3dBV1BDakVCY1JJ?=
 =?utf-8?B?dFNHcVJtcitBZlJwc3ZYazlPZ1I2a2IzSy9NVW1LZzdEZGRYNk01S21KWXFR?=
 =?utf-8?B?dENkNmxwR3I3NGtGQzlJVHcrR1hLSERLYVFoRnBHWnFpMm9BemR2ampTb0M0?=
 =?utf-8?B?Wm5pSkYvb1JxTGRPdzRycnNSR0NOUWQzMTRVbmpTc2VjcmhHbStpZzh3SXJI?=
 =?utf-8?B?NnB5aFMvUHczV01Hak1Oa2ZXelJBM0NlZVBJazBoSHM3bU1YdGx3VWhGSWlh?=
 =?utf-8?B?dHZ4ZDhvQ1NobkJyeEtOS0lTVlQ4ZEN0RzF0QXE0MGhXQ281NGZMUkthWW5x?=
 =?utf-8?B?QmEvMmliaEpoSWJ0MGd5MUIwUTlmQWttZnpmY3g3ZnBTb2JselJTUDdwWjVw?=
 =?utf-8?B?SzhHdERKWXMxc0tXSXN5TVZBVnhBSFpEQ3FPY3ZqOVU4dHl2SjFmRlFpVWF3?=
 =?utf-8?B?enp1RWtxSmR2RnU4MWJFN2ZUd2txN2kvMzlIQVBZU3Zmd0RUdkxlbUhpSDlo?=
 =?utf-8?B?VkxmQjZHOC82ZXNCdUNaS0lQdVVjUXRtQjRYV0ZSb0dHVSsrQTZNbVRZTTl4?=
 =?utf-8?B?NUh3OWZXUWpucFBnTkFvNFhqSWVyeGtOV01WQTh0SFlZTnp6ZU9mZ2NRZG45?=
 =?utf-8?B?U0xSMWFkeVBtYU5SdVY2cnNUYnQxdmN0TThhaEh2NVAzNlNWWC9CNWxXcHJV?=
 =?utf-8?B?dDRrUzdTaFBTWEVVR2hjeEREZVhDakxzNXJEeVIwTUlSeCt5dDVJSk1kcXYx?=
 =?utf-8?B?NzlWTUoyNjlKdFh5b0FYaitzelZpby9TUFdxYzZEMnY4b1NuWEUxYi85d2c3?=
 =?utf-8?B?M0FJdk5JUm93VEVRRmw5VE5kSlVTTWJnTWVVd2MyT0twaU1pSXJPNUVQSHBF?=
 =?utf-8?B?K1loazFvdUYwa1lHblVsTk1NMk5jeXk1SnI4UnpsWC95aktNYkY0dldXbnNi?=
 =?utf-8?B?YThqRkdUNUsvOE5nTGo4dW9OdDZYQXJBRS95OFRqVENEZnZkZjNhUU95NHpW?=
 =?utf-8?B?c3NzSytsWEh3OHlWQ3REYWNSdjhmQlpkc2hUbXpycG1XUldHMGZpNVNBNnU4?=
 =?utf-8?B?aGJMSHJvYk1UN1ZuUHgvc1NaaUk0NzZNdzVNVTg1WVBLWU1Ed2lEK3QrL0VE?=
 =?utf-8?B?dGJBWWQ3UTlUUlRxNXBTVnlvZi9iWXZkVElQdEpGN1JNK0NjK1NNVTJ1VTc4?=
 =?utf-8?B?ZGFrSnAyUitWazVSOFhLT1AxZ3lrN3JXRCtIaEJDMkF5aVlYdFlUWml2UW5s?=
 =?utf-8?B?N25PYU9OOUwrSXgyc0svZStyVFNoRUFiRFMrOGtJU2xwdHBDd1lnWmlXRC9H?=
 =?utf-8?B?Rm1COElWLzdZL3RUUDRKbTc4NURYSlY4SGFWSEhZQUU5aEY4cDQrS1NJMUZW?=
 =?utf-8?B?R0tJRkZZejkvcTdCMTJnZVZLT3VuWGFIRVNERW1NRmxhQjRCb2YzNlpTSjBo?=
 =?utf-8?B?ZHJ4N1dYeHVQV2RvQjZEazJHUks1K3lnZ1hyK1FzUVFpZzFrOUdZNU1IeTUw?=
 =?utf-8?B?MndQazZPMHpQakp1SmpJWUpWWWtQVEhNSzVabWxNYlJSbGtOQ20zcHBmSXBZ?=
 =?utf-8?B?VzhpTFpmamhrd3Z5QWh6d2VxYU9zUjN6aXFUUlhVdEtLamdNNzlNeEpoc0R3?=
 =?utf-8?B?S3R1R2hxQXRqc2hCT0xVODduNGU0ZmZybGZ0WDFxaDB2MldMMm5oaGp6c3dr?=
 =?utf-8?B?aTRnOTVXa1ZyNnZNNU90d0p4dHM3QTBZeHo0SktaUmRjWFdkalo0MU5Zb2NB?=
 =?utf-8?B?dXExQW0ycnNyV1AwZ2xsVVpHWDhjWHA4c1dscnNDOXZxbkhwRFRORUNnMFZs?=
 =?utf-8?B?blNYNm9DMFhkQ3NhZzhkSTg3djg1OTdKenk2T2R3UVhKY2lGZ1dVanRjY0JT?=
 =?utf-8?B?eXY3ZFlwN2ovV3h1RnJ2Z0E0K3ZEYll0a2tEZktxbG9pWDkyTmY2WDMrSXda?=
 =?utf-8?B?NlFSZHFjQTdnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ME13RE4xcEgxZHB6a05KelJweVJQdjI2STIzYjRINSs2eVV3REJna0VZRW4r?=
 =?utf-8?B?Y29Qd0VBQ2RWMDVVYVZ1dzZiYk40NzgzTlRzRjlaYTRJS3U1RlI2b2NYSVYy?=
 =?utf-8?B?NnIrWFg3ejdSUHBhNHJWOTQ3SFVtR1p0QmJSd1VrK25Oam9nd2xxTkdUZGlp?=
 =?utf-8?B?Y1dMSXQ4NGgvT2ZDUzh5TWxVZExodjZXOFQ2ajFyL1Z0QVNDTWZMalM3WXhM?=
 =?utf-8?B?WWNJMVJqS3RWaStLQ2x0bVBMT1dOaWZDUGluTk1nWEFidzVKbFZETnFBOGEy?=
 =?utf-8?B?aVNFbi9TaEQ5MWdycXd6cVE1UGhwSEpCK0YzOG12bDlNaEpvVEJtMlNuZmZ6?=
 =?utf-8?B?Z29BTmVmY3Jad3hROU1LZm1RUkYyVzE3bjVsazJUcllKd2Z6NWdzR3lELy9a?=
 =?utf-8?B?Wmg1c1M0cU1LNGkxd01SQXp5Mm5rT0xSbzk2ZUxmbUlvN2x2ZlpIaTdkQmgz?=
 =?utf-8?B?K1dqSXltMldZY2d2NUtPbnpBdEluTWNKQlpDZFp4WTJ5Tm4yTWVjSHVGZEdP?=
 =?utf-8?B?SWo1VWEzc3p4WXRrRXRZeGFCeWZXR2o2bmNubW1HSG95Uzh2YzZWbnpJNzZn?=
 =?utf-8?B?K2h2azlMV0YrbGVFTjQ4a2lzV2tZRUpxb1VHT3BnV0FGMDNnbGVPOTUwV3Aw?=
 =?utf-8?B?aDY1SWxmOHU4YjBvWGdBTUhJQlFiOFhqYnFGaWNxM1U5eFBFK0ZxWjlJQWI1?=
 =?utf-8?B?UGdrT1dZb3IwdWxMOU9USDFtbE1xT2tEcERMVzdDTDZlYlJlTGU0UVpyQ1hP?=
 =?utf-8?B?bldoTEZXTExiWGFod2FUMkRULzFqeDRhVzBUTzhhQlRWYVQyWjBiMFAyQjE1?=
 =?utf-8?B?V2VIQnFpVCtPMDdHYXoxbGVSaXVyY2N2dldPejNCbnlnbGJNUFl1L3cvRllv?=
 =?utf-8?B?VUY4c21KdFFCRDc2cDJQYmRWdkh2d0dIUGlYVWRUWXBwRFlOS01maXZSUHpk?=
 =?utf-8?B?b2lNbEpuOWRUb3JWY1NUcjR6YlpKSDRJYlU4alNJLzFvemFvTDlFbE9vc290?=
 =?utf-8?B?UjFCR0N2QW12RGx5bnVxZnJhbkl1Zld0UDU1M1oyYWRBUHpyVzNxTXlvTUxM?=
 =?utf-8?B?U0o2TEVZQlBrZVhPeks0MW5BNVNBa3JHVHhxR2s4ZFV6L3JkWlVUaHd3ZHAv?=
 =?utf-8?B?M1dNeU02QVFFZFBYVFFzMVBFR3dON2tONHRxZkxkR3VRdmx2TXMwZ255azlB?=
 =?utf-8?B?WGg5TW9QRCtUQUFSTjlqK2RzWTZoR1RWOUV1SlNoUXZUUHFpeU95U24rQmE1?=
 =?utf-8?B?eXp3cnZtVVBLTWt1YUZoeFdDdFludzZnYlB1Rmo4UTRuQTQxNDcydWdyMEEy?=
 =?utf-8?B?Z0lSN0FuT2JpQ1dEQlJEWEVvbTY3R1VTTGtnVzZOd1d4UkJSNU1TeW5XY0Zy?=
 =?utf-8?B?Y3VLaHVueGovUm5kNEpubm9CaFZhejdTYmZEQUd3T09rQVR2aHNwMllvZzIy?=
 =?utf-8?B?Tng1ditIL2pIK2NzSlV6cjRuclJ1djRxWHo3MzYrZm9HdTBkTktqcWlwbDA5?=
 =?utf-8?B?NkxIa3FrSldYSVNaVDc3Z1RmT29UemFyMW5qK2U1MWs2Y3hkc2Rsc09MVEw2?=
 =?utf-8?B?WElEK0pNSWhlaXZ6QUd1a2pOYkhFMUdNUnJSU215QnlCL1RYRmxqUExDQXk0?=
 =?utf-8?B?c2lhOFRQOGJzS21oT0I5WEpWanNRcElZRmpVNnRXcFNFTjVDSUlwUGt6NE5q?=
 =?utf-8?B?RllVK0JQLzBzbElNOG44MkQwc0NSdXA0TUhqZGh4eHhFemRrVDVkM2R5NnFr?=
 =?utf-8?B?emtwMGRMd3BqL2NCNzllbUhFb1UwenZqYVBnZTQ5VHI2ejc4TndETDhMbi9q?=
 =?utf-8?B?RlpHdlFUUHllWHd2QU9mRUhlRnNjWVhSZXFQcVBoSkNvS0NESVJtemhlYStn?=
 =?utf-8?B?TjNtaGQrMVVJTCtWMFJCNmVvL052RHRFeGtLOVZla013ZnpGNnlSNmhiSkdj?=
 =?utf-8?B?QU05QTB4MVUrQjBnZXRqSURkVkZVYTBVRHRuUVREWWtHTHJXQVMwVmFLdFJh?=
 =?utf-8?B?WmxsdTl5NFZ5OSs5UzAzK2I0dkY1R25kYS9DMkZHQ3BUN2tlZ3ZxVTh2dDJ6?=
 =?utf-8?B?OTRZcS9Jc3JEQ2crSnNSMEwrclVJZlM3YUM2aE95bVZwZDk2MmlsRThnNnVv?=
 =?utf-8?B?QW5CdlRjQnUya0xPbGd4c3BxaFFqYjlZaE9QT1REMm9Xbm55ZFZxa2dRWm5V?=
 =?utf-8?B?SlE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdc4166-957c-48c2-059d-08de231c4530
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:22:26.4143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8R3vYf/BGi7HOL8Id9mKSFWOsbcbsal5m525ZuY4ZKOaLYsfDi1l2BOzWyph1C5E+9A4dL8mEHZiyKHx67SCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 86B4E120006
X-Stat-Signature: cdwnroooqs35q1oytpi4ta3e6mgaq3h3
X-Rspam-User: 
X-HE-Tag: 1763083350-317199
X-HE-Meta: U2FsdGVkX1/L0JimSjYw2aocXcgHQPi1HbgFd/N5S9GEvL13aZS1jA04CaxuC90HzxT+nxdXh8OHPlQ2zkhqqf5qkmSzqlMnwLL0m8PKl/5WxNU7u5SCkYGyF3M+nobNKf8K15e9OAJg8uY0JTA2/Xc4xkCdC00ngMgr7jjx3tENcXPn10aHjuo8Occu1e0WJys6k+VUs+lBh6HDPVUTgjIAAxLIhcE4I1up8XnScLisynOZR2vZzLQQpAGc6Fqyc5tmifQl6nzxA3aSTx8OBm6M7yP9RcZwlGxseK9ntSNm6Of+wOSjBPGfP6STZ/hoooadxOW1rljYa75ehPv03jC0Kn11UauXQ3YBCOBaSbrSMAvYW9Tr/ppmBZBXDCyttaTNmMA7JyRCEcdzG1BcPjuhyYzTZRhcpaoqT6Q564mpl2qryvfKVtGjHe1JIXTN9HmdvS7GjOWVSGX6O8WjctqINRgV0mp7sKnyjSOxA/LHNxow6XYyd8rJXWj2Vv4tTh0cDp0xv7Civba/7PZXokTXEEXO6anaN+8/NZfb2w6JMDYpQXey3sNPI7JeFHv5oJT+pJZqNbBua4DT09KAYJ+t0HBEIDh8qVUbJyxVgQJlPHuUEFcWaGjsvncX80YjtLU19vieIv05KT6dE6iAzic3xl9McGBdr3Ra9nrMC6Gn5xOZPjqwGY89B6QQe5DlMLKcGaxAeIc6BYn+jT9TdH8yhpRvcvZtUE/7pXj9W0cnbkohdJt0dQihH7rbdCXLe4xng8onVAP4/MGn+ek2LxtdLW29fJe7Es+YYFjCZoud1qeZMHQWir3+i1J9vkpOcA1rZKSbHERww/ZsUbRPrzlUxdWjgOB8gfiQ+gkMc/y350cp2/n9K4wRLTtUWIjQaY8dC/IkvR7QN0tuzxHltiO1td1tvEvTApAJh7mcJNPb9CPG+b0ZcuMZLkyUqhztB7TdTcgLaCss/epozV4
 +S0UsCl7
 ZSuEc76AfDwhb54FirRPY8qnxXr3JYnL5oZazNjQCGU9WhVeRFWpq6CGMiyJgTUxLGIOQEoRN9ySCb8e9KvhNcZDpSFOpczH6dNYgUgaP1F+o3vpntqBAzB+pePmC9zUzLSVOclAs6uNHg1YDA2XIr3FeWnLzJSm+4Uab3IcfUD3QZvoif4SKX+e9B+QLnejNRndQi/uKjbS6yLcIzLl0pqSLhxDRI6opfOZ2iPN/G3SiLf7DxiOPLMZotalJd4hF/yuxA7NXGOL2iDz+CKA+/X60CFzQZd87BzyKjnlochiMB5HmL1XT24bv+xGPCMI8Ba0MeiRHozREdbaX6F5ETRN2Cnny7NjFdEQ+3NrCODP9mJRa4OAwbqU0mJNNv5FZnknhFApVMoVSnYYav47e/m+ayK0c7aZdaiYQEBPLvLhsCrADZXczzj5+HTB/rwputME6QmSJe4PijOueYPUiAj2bcaHmoIpA4qHo1hRQt5yS0CnCQpCwB6TJwoUBiMA6+84xkA6bXzpe2qS3CqKR52KL1mBspSo+93G+uCpub5fppema3gnHfMZS5MljgMX7e4oM+voMUQWAMPieoa9uyd8Hqivgj0O2A3cITAZwJWLG56jbB19SKxkGC7Ttxam1C6t+p6qh+okEksKg0xjOviNKRWjlpNeL+L55hWOWqkRWhAoLvxmCcYa3lipCRhwBmWlPzexLjeQJOPgzF8uZN4JhOo/fpTWk7796iiGZOHPQYdwJT7isn63jhGS1ADRHit/+cVWhenN3+eh6U6p+E7119T8WTWaxHuzSiW309WkyyIZNtMzoHDm7+TX0ceM0lD2zVbqZUv2ZNMOn9HQGnSz2xKJG9Tbyy/eszd0ZPaXcR7zClDRnN2SxaTRY6AG7jM20qbwQ56R7aEWs3kCyI1UkzgVZCrQlTTs5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ret of type vm_fault_t is reused to capture the return value of
nouveau_dmem_copy_folio(), which returns an int. Use a new variable
err to fix the issue. The issue is not new, prior to this the function
called was called nouveau_dmem_copy_one() and ret was used to capture
it's value.

The bug does not cause a real issue at runtime, the value is used
as a boolean to check if nouveau_dmem_copy_folio() succeeded or failed.
The different types should not impact the execution of the code at
runtime.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511121922.oP20Lzb8-lkp@intel.com/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 244812e7dd69..58071652679d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -188,6 +188,7 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	struct nouveau_svmm *svmm;
 	struct page *dpage;
 	vm_fault_t ret = 0;
+	int err;
 	struct migrate_vma args = {
 		.vma		= vmf->vma,
 		.pgmap_owner	= drm->dev,
@@ -256,9 +257,9 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct vm_fault *vmf)
 	svmm = folio_zone_device_data(sfolio);
 	mutex_lock(&svmm->mutex);
 	nouveau_svmm_invalidate(svmm, args.start, args.end);
-	ret = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
+	err = nouveau_dmem_copy_folio(drm, sfolio, dfolio, &dma_info);
 	mutex_unlock(&svmm->mutex);
-	if (ret) {
+	if (err) {
 		ret = VM_FAULT_SIGBUS;
 		goto done;
 	}
-- 
2.51.1


