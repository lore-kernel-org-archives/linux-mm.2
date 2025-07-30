Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEA9C87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857896B009B; Wed, 30 Jul 2025 05:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806CC6B009C; Wed, 30 Jul 2025 05:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680206B009D; Wed, 30 Jul 2025 05:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3506B009B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:22:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED1C5C02E3
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:25 +0000 (UTC)
X-FDA: 83720390250.18.775098B
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2083.outbound.protection.outlook.com [40.107.244.83])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CE76A000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L7pkIxkW;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.83 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9W9W5ccmL78W/6gizlLOdkf96mkjVtsRmN3cCBQhBh4=;
	b=F4x6GZg2mpeeLauJcAs+B7hVGPE5RKpUMRqhbaxWR8hwhA22W43DABNh94LwjteTpkPqV8
	0XtQ692+e5siwdF/CaQLm4Nned6iM7co3/wkOjtEnz3IcGoeipas+r1bqwxM+OEhNCy7Gj
	EBLhTWXcrKVbhGz4zf6jLGVd9AVI4VM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L7pkIxkW;
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.244.83 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867343; a=rsa-sha256;
	cv=pass;
	b=yccgWXSrRBeF8iclrzgMGgmdge0SpFZ+UeyWp6ILvhZ/nvdy/2DjjQgYS58QUvdtkkEamh
	d6GuzOVBfjGDU4PO0yu3ABVZ4MCCox3M1lzQturzXkYqaF/nHhZYPk2QrmqjOGbaFxhqRD
	WARkx6r/0j+35vLgjPxLsUWSqyT40po=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFCGbyqrO0tKn9zPR91Re2hSXqp18k8Kz+IWVUPq2EX+m54PIiBzRXA2wMF0A3xyJVy62kcaqpeJlqfTYa2e8k0UiyUtSmJqYGHAlLka+/Htz5c++v6jYnLzkNaGJCDx2+huns9aWqP6kplmg7CJ84GY+g2Xt/dYLWcQPqmp2OWRMBEHRvk+ZwynpzsZFVmE6vVCXppNs1rDlz5Jep3jy+r/1ul1rHTdwbMqUUh/c0Y513JQe/8UmEmAZEutSvnC92yr8jDKL/y+m/G6qyL8iJpvnXSQ0jA9myr7uh96eUYwyNednhmXIhyVi6QIP9S5vro+Up8rAcb1UUv9axyweA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9W9W5ccmL78W/6gizlLOdkf96mkjVtsRmN3cCBQhBh4=;
 b=gRh84MlEtteIU99WBdWC4Z6TbG+7bXcLEbQ/o0fFIBJIKk3MKZ3ABz24jDFjDdrmVgqSB0Cmddqni5dpZurX7yJ9Rh6UKHJGXDyTZ6cXms2Q6nyZ+Du3sCAuBxoPexLHDtJ5XhaAJ4IMPiYIA0wZnUvr9CI+XIWNshH4e0Boe7tVEF9JLKI4ttp4tVqqiQJRRbeYOpgu0UypcHzvzOMpDgcsCiiVv/YTiD33TFwSx//WEhmTHOR/G+Zlvhty/bHKyDAsloAoLz2guOndWe2mUD06ZjpCO6gazJ4qELyA9o95ZMahC5NzTXJioL0j5KfxiJtrexUkpIYMMWPJV3LvTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9W9W5ccmL78W/6gizlLOdkf96mkjVtsRmN3cCBQhBh4=;
 b=L7pkIxkWv39B88nLETjHU65vYTY6MqEHz5FvprZ+4pT8Zecu2zZJjAX9gUOAusQssHjVBKHxYhc5RGJ+ZL9naJuoYbdMGjDTIAupTXa3/r95I9FJ8HJyc5Cg9jxmxXVdT/cDRrkNDImnB3ek5sO0lEIFdZ2l1R54zmq2oWOlI0H+3WkqaG9ASD9mFNGWq9LtNETiPqLYBm0cWUeQ6gSV4vsQ7SfsXXY/r+9LNBTDrpfisoC8oe8L/BBascY1/fd3VtGJNm+LTl2M/nV+N6A1vcVdp3wvcIIOjZ9kSWGx0Php7WSGXfyjwZN01/1FDJ7/867Wg8P+M1LgW/G342kBsg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:22:00 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:22:00 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Ralph Campbell <rcampbell@nvidia.com>
Subject: [v2 03/11] mm/migrate_device: THP migration of zone device pages
Date: Wed, 30 Jul 2025 19:21:31 +1000
Message-ID: <20250730092139.3890844-4-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR16CA0021.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 1dc2d1bf-eda6-489e-7a40-08ddcf4a89d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0NYbHJyc3pNak11YTNlMnExQ2tUbmszVStSNnVndTJCd2dQSERVcnp2MUpw?=
 =?utf-8?B?SUpLNDFvUDlYWlE1WlRBS1NERlFLVUFYdXNQNmgxUEFZZjFTMUpDb1FMRDdI?=
 =?utf-8?B?a09hOVJIMVBPS2J5UXVBUWxLanU5blFqNmFlYkhIQ2FVNXY5dkhRYlh1MERR?=
 =?utf-8?B?RzZmWWM0aVl5YnJjOXlzMHY1M1MvSWcvODZwaEoxSHc1MHA1UGF6YVF6RVo2?=
 =?utf-8?B?SlV1K01WTTdRZ29ISFdkYzlpbjNGQUlDY09zRVpoODlFOC9kY09TZEg2Lytp?=
 =?utf-8?B?eUhJTEpFdTd4UCtsYjRlZU81ajZHWmI3dkx0bjNEL1R4b0dPeE5mNk9DTDFF?=
 =?utf-8?B?OVB4M2lGdEFHZ2FuYll5V2R3N05mc3djRnl1WDN6Q2hISWU4cjJudnJveXp3?=
 =?utf-8?B?WHZNcGZTcXRrZUxIRTVyTmlhZmNIbXdlOG9SNXN3K2VMaGd1dVQwOWMyb2Vx?=
 =?utf-8?B?emhtTXVkQTkxMFdHSGtvNGNiN0M4R0dFelZOSWx0WmlzRHVXTnpmT3VFNHEr?=
 =?utf-8?B?K2N0SjFSNjEwTlB3RG1SQ2dCemlWbGdXZ1dKM3dURmZHUm5ERlFQaEI1bWxJ?=
 =?utf-8?B?bXMxWFBpUEw0aDM3bUV3Y1VTZUhGMVJaY2pYdzdSdUR5UW84bW5QRFRubExU?=
 =?utf-8?B?MzNCWXA3bEhEVmdVMmFVdllxK1o3RFNMRW9DOGk5MVVZNi9STXB4eWY4SEVr?=
 =?utf-8?B?b3ZwNGJrUDRNY2VFc1phOUt1WGZtZVczL0JuRExCNENxUXpMUVBKZGtvQXhw?=
 =?utf-8?B?aDlXSTkzOSt3ckpjUXI3ZUhhWGhlRjVpbU1udDVpcGlJMU9RcTZHN2FpWGJR?=
 =?utf-8?B?MFMzMHNyTjhWenBuMWZQQkFBRm1LdkxUa3d3TkpFUTFmRUcvSmZYZ2hxMnhQ?=
 =?utf-8?B?aVpvS21XdjJ3bG9IcHpSbnBoZ1dGc3FZQ1l4QUx4bVlweDhGRWwxMThMLzVX?=
 =?utf-8?B?S2d1YlE3TlpaZVJLejM4bk9kaXZWeHZvcnkrLzkyUzhLM3hITmhkTU5kaWht?=
 =?utf-8?B?WEF1RWVqYnVIcERQc3JsNVFmcUZ4WnhMay9CdEcrTkVGS050OU9Pc3ZnVVZj?=
 =?utf-8?B?djFOU0I3K3FTWEw1YUFFdSt6M3VmbGd3ZlF3QkN1d3dEMWVRd2UwRFEvZ3Bm?=
 =?utf-8?B?S3BrUU5NNGFQekpaK3dtYXI0YTVZRlc3M0xxZk5uTnFYS2RyS2dYYklqMXVG?=
 =?utf-8?B?Q2Z5YjZLN0tvY1ZjZjhqQnBvcmxaRTVxeWdSL2pBaDVRWUMxTTJmcWV1QVVH?=
 =?utf-8?B?RW50VVVlcy9FcU9Lb00yZFFWTTQ2RHJRclhVNG5BT3NycFRPM3VkVWowN3NE?=
 =?utf-8?B?UUFOaVhydWZWbXRSc2tQVzZ4a0xjdEhUU3d0TnJGRk1JVDBZN2hCT2tQRkVW?=
 =?utf-8?B?MnlhTGV6WUVsWlptdUtzTFBseGNDcjlQc1ZPcmNrNW9VYWp4dmp6bVp4Sk9N?=
 =?utf-8?B?cWlwdnB3THZjbWdiKzNJWkk4R2hVNlM0d1NXUUZaV2YwekZMRVk2dlZ1aTRo?=
 =?utf-8?B?MCtuUzY0elBZem14TjJqUmx0TTlmU3AzQ0t2eU9XSVlUYlhWTG5yTWFlR1dr?=
 =?utf-8?B?QVRFcGxNZTROVHhIWTJqbE9yajNFT3ZjanJweDBjRHdidFV4Z2dNNmlVREln?=
 =?utf-8?B?dENGWjhsbDF4M1VjUDJwOG9oeGlQTjhFZzdLOHVtT1J6SkJ6aVlvQU5KMm1V?=
 =?utf-8?B?QWhheXBoRTRtS1V6UTlaY0lYTE9SYndaY3lYald0MDZVMEwyOWJHd1pMcU9V?=
 =?utf-8?B?cFlQZ1VlMk94M2FjYnpnSjVSdWtOeDRtZk1RQ29qV2F3QkZ2YkpvQkZxenRN?=
 =?utf-8?B?MkE3MWxETmRxMTlrSmxTQnVpeXlHd2lqNE4vUzVkNEF0UFBHS0ZxakhIRFNG?=
 =?utf-8?B?YzBHcTFXT0pqWSttcGlucUFSRjFOd2hxUzhzSWY2eGRLM1V2L0lnVTNGRXJj?=
 =?utf-8?Q?+MlzUFIuaeI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnV0clFDRUNmUXpaeGp6N2xyemxsWWVaN2w1aGhFY29FUnl4K3QzNzdQcDNj?=
 =?utf-8?B?cCtjMmwyQ3pDYm9qSVpVVFJZNjVHaWVEVDdtWXJCNHJCb3V4SmVPRlFNQnV4?=
 =?utf-8?B?QVJjQnJ6M2dUUnJNWE9sS2k1Z1lEK0wyTXdVa2hUNStVUDd0UEgyNDVPVC92?=
 =?utf-8?B?UVM3OVc2L1dVaWt6Z0M4dzNlOVhTTmVObXpqNytQNGpjRFNyc1FZaEUvUklU?=
 =?utf-8?B?dit1U0doNml3a2lNMnBPbTBBbU1HNW1rcjJsSXRML0FqSW5QWERlRlg0VkZx?=
 =?utf-8?B?TXhscDd0M0kwRnRtRVV5a0tDQ3UzVHRYOUJPckZkSklrdHc0QVhMS0pRV0VF?=
 =?utf-8?B?Y1ZGbkRHaEE4QXNmS0RPNTFUOHp0RlFqNVBwUmtpd2hlamRwdm9RczJ0Tytm?=
 =?utf-8?B?ZDZEemZNS3drWGdSMmUydFM1VHpKbnc1WE5odWMwelJnKzNTS2FKMDZnV3RY?=
 =?utf-8?B?R1FFUGs5QXNiZDVlTzNHOFZBbTZxNDZiL1JGSjc2c3ZCS2RCMCt3VkRET3dT?=
 =?utf-8?B?RUFoSEZjeEZDeFQzalBvekp3RDFud2VJUlF3akpveGQ1K1I2UDBleXRxekVD?=
 =?utf-8?B?emZYN0p6THk1N1hQRmJ0MGtueHNhQ2ZLbjhiM0kyTTVMUGwvOTlQeDNlK2tm?=
 =?utf-8?B?UzladGRSa01rY3R3RVZodVkyQVlLRGZsdG5zVVl3QTBPQ05pNytNdzByUWFK?=
 =?utf-8?B?c0JrY2VTR0EyMmkycmtZZ1dnMURrcks2WGMzVSswZGQvdHFZSk1ObnIyZzM1?=
 =?utf-8?B?WUNrbVhGQkxQaDNFU1ZwcnQ1ZEtva2JmckVscU1mTWovUS9aZXFpZEc1QURm?=
 =?utf-8?B?QXVSc0tsb05tbFBiZ1NkbUJQRlFMK0M0TkNJdExzMFhONCs3UGU1WGNhVTky?=
 =?utf-8?B?NXQ2cVRhZXU4bVlnWlIxRjRSV2FEZlovc2pSZmMwVEZyV0NoMkZZWEt3d2c0?=
 =?utf-8?B?STE3QVlmNnByWFAwTHpnWHhuZWtCK3NOVWlkQUtOV0ZiWEV2aFIrNFpyQ1p1?=
 =?utf-8?B?eHZTaWErNmFsdzh6VFFvb2VYZHR6QXAzaUhTOW5Odkl6QTFFYlliVmZVbXJD?=
 =?utf-8?B?V3VEL0JHc1VnSUZoT1h3c1Y0cjk0di9POEFETkFoSW1jRFFXL2JrY1BKVGVZ?=
 =?utf-8?B?eGFmSEtOdzg0L0d2d0k2ekVuTHNGSEUwdStNaUlOWFBCeXNVc0lqWXI5bDJj?=
 =?utf-8?B?WXNxNDIyUlRtLzlHMFFGUzgzdk5JcklDeUhBT0wwRUwya25wZjJ1UjlQVnZR?=
 =?utf-8?B?ZkJHdG5MS0lhLy90b2FZbDh0VEZteGNGZ1U0dEl1ZHUxVU9jWms2NGplK0o0?=
 =?utf-8?B?YjNUaE42K0ZXTDlaamY4a1FLWm1vdXdyRit1QXNibUhwMGU0M1hCRzU5TEFQ?=
 =?utf-8?B?a1hJaXJkQXNpcGx1RW1JT1RneWw1NmdBQ05HbHJiQTlWWnljZWkzRGZQNlRh?=
 =?utf-8?B?NEo2Ylhrak1HQjlKL1VSNUhTWFlTWGhEaUtrTW5Vd2xYYWNFYVlsUkVmOUlI?=
 =?utf-8?B?TVYvT1NlYXpMcnBkRHFrK3pWekFJakM0RksyazFtWWQ5NGNuZWVVYkQxcjBq?=
 =?utf-8?B?VEhKQ3cwQ1hQbjh1UGV6aTJGMWdGak5reWxDN2tmT1RWNmVBNzRnNFVPRjQ4?=
 =?utf-8?B?T1hIS3dWMkRUU0puN2o3TEE1Mml0MHhvMXVaK2hyMHhmYWNzUjVvZnd6VXV5?=
 =?utf-8?B?cTBBVUtzVXk1WDJneS83R3hjMkc1R3BQb3FjR2kvOFJVdUlZOEdySVJpdDdF?=
 =?utf-8?B?eGV1c0tFcVRpN1VHZ09PTGtVMW1tRkdwTTJTNm9uZFd2NzNNYTF1VjJxWFMw?=
 =?utf-8?B?RjNUS3RWNURJWUkrSVQ1K1pWNEt3bjQ3cmxmZWhwcHAxd0ZsNEs0alVEQXRM?=
 =?utf-8?B?VFVCNmt6RWVxend0ZmhSSVNLMVBqRXJuc3B2TmJqUmRpTHJlcXQ3MU9xLzhh?=
 =?utf-8?B?ZWJFNXJmRFZZYmJ3MDhydy85WlJCSE14ZmdlbGJodkxoanpNVDh2UUo0UHZ6?=
 =?utf-8?B?alp3Q2pMRS9FTHVEOWZ1TENyeEJyazJWemptQVRYTVlEMi9OQUUzaW1wQVVo?=
 =?utf-8?B?OS9rM0tCeVhtOTU1R3prby81MUxwTmZic1lQQytIbjVjczJEYmxVTy9aWDlm?=
 =?utf-8?Q?vZ0GXzM+UZA6/mQr8vivm76kb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc2d1bf-eda6-489e-7a40-08ddcf4a89d1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:22:00.6699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHFRzX6OtF3bm8I39BAPLIVyYUOhlPXMU0mPX+e9roUihGPAnqOKbBpar5Mj8eSrXbemIDd04cQ9BL6qxhj1wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Stat-Signature: sn5i74rup7qkrsjea7obxtchek89ejaf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CE76A000C
X-Rspam-User: 
X-HE-Tag: 1753867342-479456
X-HE-Meta: U2FsdGVkX195yhpk/Bxy6BBwHeOu+uwyvJaiZ7zyPOhR5LvoEn4Erziquk4uWwSR08XKkuX/9IRCfh7bKv6zBPhb2HTAlvS0FCkY31fMIiRVVt6gmRShDiXlS8o/fFMYmLF61yvoj27nwTuPrdE/0rMnIQ6KOsqAwz+PyMYOu3EJFAMfQvYumsqfFAD04J6MqRIlMhA4V3dG6OaQqPmvc1sO/CD/jl7L6Gfd5P1bFppUJOslBvwHrJmdfa2TO5GO3H88MFHKa3WeYgm2WebnvhXbfzScq8HKTNDsYGu5IudJ457UfkK9TG92JwHcxCGAQHWKwOzFA+asfZEen4k9gzRrWbozP+Q2plwBhLQvWkVYUyfJiz2/Y7Op42wzxmfQm2HG4RqLDQYL2jvDWN1gBr/gL6wEj2yoOYmL6LjViMnjHuYnAYNIqqknYoExgTHhM14IOCbbh0KZJCS5CTSXbtXLGg1ExtV5L/C0wb6Nbe+IEiSuu35qC5xUmlZaKP6zZAgIXYiL4gdv4YdzOSj0B5WlqNjqwCqKQ6W4xe3uoQCbmGMWvXcCHT1izl+YD1koBg88tkj7LOaP+DPE66lNPy7ccie4XzTp9iF69cJkLshQtnVcG1g8oM9wH7Un3fTIjW3sD4MpMPcB8LXwvKj2AqMsv8M9nvtw1hQR7ciDEaEh/ToTg6JLll6ONyANrQyGa+3pcQ1RHwV1aCO/ScevI53JFfMUmt8wFdhZ8ly3LuYosyBO6FUpm72+GNUvNYhiJIyka4U+bhMRXJOHCv2qWUqivvtDBRq9cIktXOnlxIuT8DhXxsX2Q1x61bWIrFXWPM+WL8+eqFBxtaXLRb7cjxKOvhh05puM0bKZ+oWHqRdJOm98EUJkIHeEZnnDRbAhRtjah8DEdNLQE5ssTgUcVb7aZwLDClqxJWO547juCIBIkLRGaxwsxX8TubLBp3ImBnf4TTsNnmEmWfbjmzd
 Ancs6I7W
 q0eE1RWTFfWjwj/LwGnRIYdJSZghmoyfbMMUSFxiHXQCNURn6mYTmLaicXK/3W/0L8zrdP6WVNvDh+WXt4p3UQQONxtMW8cPNGD+A5EknBREJZFYzcbo8pCE5vYIoUKMwM69W74vyvotryHuclP5WkonKFshfqQmfHOMD/piU62Apy77k6gYYdGpPgdnHRCbtGt9q/sDfn6yxuQOJ1OJ0TLZfcZi5IjQusyGT5Xm6sR1kDvK9TiPg+fLQTuYwfd+xoqyrXx0Mm+DDf/g+yqiAZsjtwM7ggmxtHXR1sd/4LyoNwzX4DQN+u8gaczlYptXbcRIHx413bQRZT92gwk+J6RMIYLxCU7ZpsAtUruxHOFFqwt8aZm1zz6ZPwYlNqXDKJw1QxTu+oyWMaUCn4q7ekQgB44C5hdwl6ZFsTs+TeOgjFsJoznCSjup1A0474FtMZNlVZNNk2PuFyjGf8Y8ANA4kzEu4FET1NkCJBG4JJBgiDizIQWvNb3tDMWfah0d5YAGWjcor59fjigaF0jatVSV154LtydZXYpOaQ2BkYrwz+wCvYdimx/iHOoOPJuZRSGz+Hy+C6gfou12Oz5xQxPemYzfH0vLb2s2hNrpxlZtXPJhzk5QUEcHmtnJvylHpbwYsAhioHcpwsPD2/SQyGPswlt7pqk+CMp5bvTV3aVVob8bBflDmH7MVtcjsS85aUGgD+Lx1g17BSIrhOsk+TLCZpdkt8Lpe92Z8X8NDvco1mj9c0bZpA6+/ZUT8CNeM4sW2jh+ZhxaZxFyEz5L3YuZaoC3UfjIkqc55xgekSySma7ghHKnWun8U8URpcdvpiZahxiYqgbiWO4xQQLTmwNbn4vqY0yoDJs/QkZ8ts1y/3sStOY9QUX/eKeATC2gmo7vLRvZaXaOFAZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
device pages as compound pages during device pfn migration.

migrate_device code paths go through the collect, setup
and finalize phases of migration.

The entries in src and dst arrays passed to these functions still
remain at a PAGE_SIZE granularity. When a compound page is passed,
the first entry has the PFN along with MIGRATE_PFN_COMPOUND
and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
representation allows for the compound page to be split into smaller
page sizes.

migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
page aware. Two new helper functions migrate_vma_collect_huge_pmd()
and migrate_vma_insert_huge_pmd_page() have been added.

migrate_vma_collect_huge_pmd() can collect THP pages, but if for
some reason this fails, there is fallback support to split the folio
and migrate it.

migrate_vma_insert_huge_pmd_page() closely follows the logic of
migrate_vma_insert_page()

Support for splitting pages as needed for migration will follow in
later patches in this series.

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/migrate.h |   2 +
 mm/migrate_device.c     | 456 ++++++++++++++++++++++++++++++++++------
 2 files changed, 395 insertions(+), 63 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..d9cef0819f91 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -129,6 +129,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
 #define MIGRATE_PFN_VALID	(1UL << 0)
 #define MIGRATE_PFN_MIGRATE	(1UL << 1)
 #define MIGRATE_PFN_WRITE	(1UL << 3)
+#define MIGRATE_PFN_COMPOUND	(1UL << 4)
 #define MIGRATE_PFN_SHIFT	6
 
 static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
@@ -147,6 +148,7 @@ enum migrate_vma_direction {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
+	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
 };
 
 struct migrate_vma {
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index e05e14d6eacd..4c3334cc3228 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -14,6 +14,7 @@
 #include <linux/pagewalk.h>
 #include <linux/rmap.h>
 #include <linux/swapops.h>
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
 
@@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
 	if (!vma_is_anonymous(walk->vma))
 		return migrate_vma_collect_skip(start, end, walk);
 
+	if (thp_migration_supported() &&
+		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
+						MIGRATE_PFN_COMPOUND;
+		migrate->dst[migrate->npages] = 0;
+		migrate->npages++;
+		migrate->cpages++;
+
+		/*
+		 * Collect the remaining entries as holes, in case we
+		 * need to split later
+		 */
+		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
+	}
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
@@ -54,57 +72,151 @@ static int migrate_vma_collect_hole(unsigned long start,
 	return 0;
 }
 
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
+/**
+ * migrate_vma_collect_huge_pmd - collect THP pages without splitting the
+ * folio for device private pages.
+ * @pmdp: pointer to pmd entry
+ * @start: start address of the range for migration
+ * @end: end address of the range for migration
+ * @walk: mm_walk callback structure
+ *
+ * Collect the huge pmd entry at @pmdp for migration and set the
+ * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
+ * migration will occur at HPAGE_PMD granularity
+ */
+static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
+					unsigned long end, struct mm_walk *walk,
+					struct folio *fault_folio)
 {
+	struct mm_struct *mm = walk->mm;
+	struct folio *folio;
 	struct migrate_vma *migrate = walk->private;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
 	spinlock_t *ptl;
-	pte_t *ptep;
+	swp_entry_t entry;
+	int ret;
+	unsigned long write = 0;
 
-again:
-	if (pmd_none(*pmdp))
+	ptl = pmd_lock(mm, pmdp);
+	if (pmd_none(*pmdp)) {
+		spin_unlock(ptl);
 		return migrate_vma_collect_hole(start, end, -1, walk);
+	}
 
 	if (pmd_trans_huge(*pmdp)) {
-		struct folio *folio;
-
-		ptl = pmd_lock(mm, pmdp);
-		if (unlikely(!pmd_trans_huge(*pmdp))) {
+		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
 			spin_unlock(ptl);
-			goto again;
+			return migrate_vma_collect_skip(start, end, walk);
 		}
 
 		folio = pmd_folio(*pmdp);
 		if (is_huge_zero_folio(folio)) {
 			spin_unlock(ptl);
-			split_huge_pmd(vma, pmdp, addr);
-		} else {
-			int ret;
+			return migrate_vma_collect_hole(start, end, -1, walk);
+		}
+		if (pmd_write(*pmdp))
+			write = MIGRATE_PFN_WRITE;
+	} else if (!pmd_present(*pmdp)) {
+		entry = pmd_to_swp_entry(*pmdp);
+		folio = pfn_swap_entry_folio(entry);
+
+		if (!is_device_private_entry(entry) ||
+			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
+			(folio->pgmap->owner != migrate->pgmap_owner)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
 
-			folio_get(folio);
+		if (is_migration_entry(entry)) {
+			migration_entry_wait_on_locked(entry, ptl);
 			spin_unlock(ptl);
-			/* FIXME: we don't expect THP for fault_folio */
-			if (WARN_ON_ONCE(fault_folio == folio))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			if (unlikely(!folio_trylock(folio)))
-				return migrate_vma_collect_skip(start, end,
-								walk);
-			ret = split_folio(folio);
-			if (fault_folio != folio)
-				folio_unlock(folio);
-			folio_put(folio);
-			if (ret)
-				return migrate_vma_collect_skip(start, end,
-								walk);
+			return -EAGAIN;
 		}
+
+		if (is_writable_device_private_entry(entry))
+			write = MIGRATE_PFN_WRITE;
+	} else {
+		spin_unlock(ptl);
+		return -EAGAIN;
+	}
+
+	folio_get(folio);
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		spin_unlock(ptl);
+		folio_put(folio);
+		return migrate_vma_collect_skip(start, end, walk);
+	}
+
+	if (thp_migration_supported() &&
+		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+
+		struct page_vma_mapped_walk pvmw = {
+			.ptl = ptl,
+			.address = start,
+			.pmd = pmdp,
+			.vma = walk->vma,
+		};
+
+		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
+
+		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
+						| MIGRATE_PFN_MIGRATE
+						| MIGRATE_PFN_COMPOUND;
+		migrate->dst[migrate->npages++] = 0;
+		migrate->cpages++;
+		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
+		if (ret) {
+			migrate->npages--;
+			migrate->cpages--;
+			migrate->src[migrate->npages] = 0;
+			migrate->dst[migrate->npages] = 0;
+			goto fallback;
+		}
+		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
+		spin_unlock(ptl);
+		return 0;
+	}
+
+fallback:
+	spin_unlock(ptl);
+	if (!folio_test_large(folio))
+		goto done;
+	ret = split_folio(folio);
+	if (fault_folio != folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	if (ret)
+		return migrate_vma_collect_skip(start, end, walk);
+	if (pmd_none(pmdp_get_lockless(pmdp)))
+		return migrate_vma_collect_hole(start, end, -1, walk);
+
+done:
+	return -ENOENT;
+}
+
+static int migrate_vma_collect_pmd(pmd_t *pmdp,
+				   unsigned long start,
+				   unsigned long end,
+				   struct mm_walk *walk)
+{
+	struct migrate_vma *migrate = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long addr = start, unmapped = 0;
+	spinlock_t *ptl;
+	struct folio *fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+	pte_t *ptep;
+
+again:
+	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
+		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
+
+		if (ret == -EAGAIN)
+			goto again;
+		if (ret == 0)
+			return 0;
 	}
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
@@ -175,8 +287,7 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
 
-		/* FIXME support THP */
-		if (!page || !page->mapping || PageTransCompound(page)) {
+		if (!page || !page->mapping) {
 			mpfn = 0;
 			goto next;
 		}
@@ -347,14 +458,6 @@ static bool migrate_vma_check_page(struct page *page, struct page *fault_page)
 	 */
 	int extra = 1 + (page == fault_page);
 
-	/*
-	 * FIXME support THP (transparent huge page), it is bit more complex to
-	 * check them than regular pages, because they can be mapped with a pmd
-	 * or with a pte (split pte mapping).
-	 */
-	if (folio_test_large(folio))
-		return false;
-
 	/* Page from ZONE_DEVICE have one extra reference */
 	if (folio_is_zone_device(folio))
 		extra++;
@@ -385,17 +488,24 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 	lru_add_drain();
 
-	for (i = 0; i < npages; i++) {
+	for (i = 0; i < npages; ) {
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
+		unsigned int nr = 1;
 
 		if (!page) {
 			if (src_pfns[i] & MIGRATE_PFN_MIGRATE)
 				unmapped++;
-			continue;
+			goto next;
 		}
 
 		folio =	page_folio(page);
+		nr = folio_nr_pages(folio);
+
+		if (nr > 1)
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+
+
 		/* ZONE_DEVICE folios are not on LRU */
 		if (!folio_is_zone_device(folio)) {
 			if (!folio_test_lru(folio) && allow_drain) {
@@ -407,7 +517,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 			if (!folio_isolate_lru(folio)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
-				continue;
+				goto next;
 			}
 
 			/* Drop the reference we took in collect */
@@ -426,10 +536,12 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 			restore++;
-			continue;
+			goto next;
 		}
 
 		unmapped++;
+next:
+		i += nr;
 	}
 
 	for (i = 0; i < npages && restore; i++) {
@@ -575,6 +687,146 @@ int migrate_vma_setup(struct migrate_vma *args)
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+/**
+ * migrate_vma_insert_huge_pmd_page: Insert a huge folio into @migrate->vma->vm_mm
+ * at @addr. folio is already allocated as a part of the migration process with
+ * large page.
+ *
+ * @folio needs to be initialized and setup after it's allocated. The code bits
+ * here follow closely the code in __do_huge_pmd_anonymous_page(). This API does
+ * not support THP zero pages.
+ *
+ * @migrate: migrate_vma arguments
+ * @addr: address where the folio will be inserted
+ * @folio: folio to be inserted at @addr
+ * @src: src pfn which is being migrated
+ * @pmdp: pointer to the pmd
+ */
+static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
+					 unsigned long addr,
+					 struct page *page,
+					 unsigned long *src,
+					 pmd_t *pmdp)
+{
+	struct vm_area_struct *vma = migrate->vma;
+	gfp_t gfp = vma_thp_gfp_mask(vma);
+	struct folio *folio = page_folio(page);
+	int ret;
+	spinlock_t *ptl;
+	pgtable_t pgtable;
+	pmd_t entry;
+	bool flush = false;
+	unsigned long i;
+
+	VM_WARN_ON_FOLIO(!folio, folio);
+	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
+
+	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
+		return -EINVAL;
+
+	ret = anon_vma_prepare(vma);
+	if (ret)
+		return ret;
+
+	folio_set_order(folio, HPAGE_PMD_ORDER);
+	folio_set_large_rmappable(folio);
+
+	if (mem_cgroup_charge(folio, migrate->vma->vm_mm, gfp)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+		ret = -ENOMEM;
+		goto abort;
+	}
+
+	__folio_mark_uptodate(folio);
+
+	pgtable = pte_alloc_one(vma->vm_mm);
+	if (unlikely(!pgtable))
+		goto abort;
+
+	if (folio_is_device_private(folio)) {
+		swp_entry_t swp_entry;
+
+		if (vma->vm_flags & VM_WRITE)
+			swp_entry = make_writable_device_private_entry(
+						page_to_pfn(page));
+		else
+			swp_entry = make_readable_device_private_entry(
+						page_to_pfn(page));
+		entry = swp_entry_to_pmd(swp_entry);
+	} else {
+		if (folio_is_zone_device(folio) &&
+		    !folio_is_device_coherent(folio)) {
+			goto abort;
+		}
+		entry = folio_mk_pmd(folio, vma->vm_page_prot);
+		if (vma->vm_flags & VM_WRITE)
+			entry = pmd_mkwrite(pmd_mkdirty(entry), vma);
+	}
+
+	ptl = pmd_lock(vma->vm_mm, pmdp);
+	ret = check_stable_address_space(vma->vm_mm);
+	if (ret)
+		goto abort;
+
+	/*
+	 * Check for userfaultfd but do not deliver the fault. Instead,
+	 * just back off.
+	 */
+	if (userfaultfd_missing(vma))
+		goto unlock_abort;
+
+	if (!pmd_none(*pmdp)) {
+		if (!is_huge_zero_pmd(*pmdp))
+			goto unlock_abort;
+		flush = true;
+	} else if (!pmd_none(*pmdp))
+		goto unlock_abort;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
+	if (!folio_is_zone_device(folio))
+		folio_add_lru_vma(folio, vma);
+	folio_get(folio);
+
+	if (flush) {
+		pte_free(vma->vm_mm, pgtable);
+		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
+		pmdp_invalidate(vma, addr, pmdp);
+	} else {
+		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
+		mm_inc_nr_ptes(vma->vm_mm);
+	}
+	set_pmd_at(vma->vm_mm, addr, pmdp, entry);
+	update_mmu_cache_pmd(vma, addr, pmdp);
+
+	spin_unlock(ptl);
+
+	count_vm_event(THP_FAULT_ALLOC);
+	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
+	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+
+	return 0;
+
+unlock_abort:
+	spin_unlock(ptl);
+abort:
+	for (i = 0; i < HPAGE_PMD_NR; i++)
+		src[i] &= ~MIGRATE_PFN_MIGRATE;
+	return 0;
+}
+#else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
+static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
+					 unsigned long addr,
+					 struct page *page,
+					 unsigned long *src,
+					 pmd_t *pmdp)
+{
+	return 0;
+}
+#endif
+
 /*
  * This code closely matches the code in:
  *   __handle_mm_fault()
@@ -585,9 +837,10 @@ EXPORT_SYMBOL(migrate_vma_setup);
  */
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
-				    struct page *page,
+				    unsigned long *dst,
 				    unsigned long *src)
 {
+	struct page *page = migrate_pfn_to_page(*dst);
 	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = migrate->vma;
 	struct mm_struct *mm = vma->vm_mm;
@@ -615,8 +868,25 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	pmdp = pmd_alloc(mm, pudp, addr);
 	if (!pmdp)
 		goto abort;
-	if (pmd_trans_huge(*pmdp))
-		goto abort;
+
+	if (thp_migration_supported() && (*dst & MIGRATE_PFN_COMPOUND)) {
+		int ret = migrate_vma_insert_huge_pmd_page(migrate, addr, page,
+								src, pmdp);
+		if (ret)
+			goto abort;
+		return;
+	}
+
+	if (!pmd_none(*pmdp)) {
+		if (pmd_trans_huge(*pmdp)) {
+			if (!is_huge_zero_pmd(*pmdp))
+				goto abort;
+			folio_get(pmd_folio(*pmdp));
+			split_huge_pmd(vma, pmdp, addr);
+		} else if (pmd_leaf(*pmdp))
+			goto abort;
+	}
+
 	if (pte_alloc(mm, pmdp))
 		goto abort;
 	if (unlikely(anon_vma_prepare(vma)))
@@ -707,23 +977,24 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 	unsigned long i;
 	bool notified = false;
 
-	for (i = 0; i < npages; i++) {
+	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct address_space *mapping;
 		struct folio *newfolio, *folio;
 		int r, extra_cnt = 0;
+		unsigned long nr = 1;
 
 		if (!newpage) {
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-			continue;
+			goto next;
 		}
 
 		if (!page) {
 			unsigned long addr;
 
 			if (!(src_pfns[i] & MIGRATE_PFN_MIGRATE))
-				continue;
+				goto next;
 
 			/*
 			 * The only time there is no vma is when called from
@@ -741,15 +1012,47 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 					migrate->pgmap_owner);
 				mmu_notifier_invalidate_range_start(&range);
 			}
-			migrate_vma_insert_page(migrate, addr, newpage,
+
+			if ((src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
+				nr = HPAGE_PMD_NR;
+				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				goto next;
+			}
+
+			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
 						&src_pfns[i]);
-			continue;
+			goto next;
 		}
 
 		newfolio = page_folio(newpage);
 		folio = page_folio(page);
 		mapping = folio_mapping(folio);
 
+		/*
+		 * If THP migration is enabled, check if both src and dst
+		 * can migrate large pages
+		 */
+		if (thp_migration_supported()) {
+			if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
+				(src_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				!(dst_pfns[i] & MIGRATE_PFN_COMPOUND)) {
+
+				if (!migrate) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
+				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
+				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
+				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			}
+		}
+
+
 		if (folio_is_device_private(newfolio) ||
 		    folio_is_device_coherent(newfolio)) {
 			if (mapping) {
@@ -762,7 +1065,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				if (!folio_test_anon(folio) ||
 				    !folio_free_swap(folio)) {
 					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-					continue;
+					goto next;
 				}
 			}
 		} else if (folio_is_zone_device(newfolio)) {
@@ -770,7 +1073,7 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			 * Other types of ZONE_DEVICE page are not supported.
 			 */
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-			continue;
+			goto next;
 		}
 
 		BUG_ON(folio_test_writeback(folio));
@@ -782,6 +1085,8 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 		else
 			folio_migrate_flags(newfolio, folio);
+next:
+		i += nr;
 	}
 
 	if (notified)
@@ -943,10 +1248,23 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
 int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 			unsigned long npages)
 {
-	unsigned long i, pfn;
+	unsigned long i, j, pfn;
+
+	for (pfn = start, i = 0; i < npages; pfn++, i++) {
+		struct page *page = pfn_to_page(pfn);
+		struct folio *folio = page_folio(page);
+		unsigned int nr = 1;
 
-	for (pfn = start, i = 0; i < npages; pfn++, i++)
 		src_pfns[i] = migrate_device_pfn_lock(pfn);
+		nr = folio_nr_pages(folio);
+		if (nr > 1) {
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+			for (j = 1; j < nr; j++)
+				src_pfns[i+j] = 0;
+			i += j - 1;
+			pfn += j - 1;
+		}
+	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);
 
@@ -964,10 +1282,22 @@ EXPORT_SYMBOL(migrate_device_range);
  */
 int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 {
-	unsigned long i;
+	unsigned long i, j;
+
+	for (i = 0; i < npages; i++) {
+		struct page *page = pfn_to_page(src_pfns[i]);
+		struct folio *folio = page_folio(page);
+		unsigned int nr = 1;
 
-	for (i = 0; i < npages; i++)
 		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
+		nr = folio_nr_pages(folio);
+		if (nr > 1) {
+			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
+			for (j = 1; j < nr; j++)
+				src_pfns[i+j] = 0;
+			i += j - 1;
+		}
+	}
 
 	migrate_device_unmap(src_pfns, npages, NULL);
 
-- 
2.50.1


