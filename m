Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFB8CCA474
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 06:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350E68E000B; Wed,  1 Oct 2025 02:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF918E0002; Wed,  1 Oct 2025 02:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0F38E000B; Wed,  1 Oct 2025 02:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 021E18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 02:59:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3F86160961
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:59:00 +0000 (UTC)
X-FDA: 83948643240.22.2F48807
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011023.outbound.protection.outlook.com [40.107.208.23])
	by imf08.hostedemail.com (Postfix) with ESMTP id DC6BA160004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:58:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WYfBC+Jj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.23 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759301938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0SNmbWmKOtD6qcIGLkPBaaHNri0ZoWVLd0PORGmh0s=;
	b=Jln+ailT49lCdb8jNEuqmNSprAG4PZcVIX7wiGDVTwcNsptYx09V6qcIFWIKRpASsAZZJz
	EzmL5g9HWWr4Cq3lxH9sQBi8Qpq56i9rYcmWv62YPoIIuZOGRoWtfuqk39/SWwVIm3AQZE
	73oUKXlxMxSgywKGhaSLRp5rCqJji9M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759301938; a=rsa-sha256;
	cv=pass;
	b=0eQmFHkAwdn5qQW9mptODsIOnMFS/246u0Yx68povRM+Wr1LzoQ9d2t8hXYuhSDnWPRW6M
	KnVM3gr0rJGUcSoEsFY+YvYwIxqs9MIZbQY1NVnFvXez9JKtx0ZGnl1oGcYmo/u6SOWgKW
	KrUb5I3M60JLdik+1UEkM+qpSxqsVCg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WYfBC+Jj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.208.23 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbY3a1XS9dW/HxrtHVCba3NReD6teiPi+1QOH0/RPs+G1zv4aZ14bZu+yP1h9qOvGPb8A+cT/xSWOnTmr/RFEVKybwn9DuTSAbg9FCyp98gVyvLb43wAypVqiXrOx6/TrZgZeQblDINGsgIGQqhlO7NUNxN9oGhJtMMmaUU4zt+DfZxZ6cjPT55rt4pGiFfA4e5mBFxpJ8nGChnYnngjgAkMGVuvUm20oq7ELgYts2P6MOYCIJIOqo9iJCua5oJLGP8mQW7rpr4W3r6LAVXB3r9OkL4dUVI9n/+N4wJjrXyvtzJOLAPAf4eZAhNmVMPuNRnxFllJEir7UJU62GahJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0SNmbWmKOtD6qcIGLkPBaaHNri0ZoWVLd0PORGmh0s=;
 b=G9goat3RDPStVbDJC3zkcwR2TqayDrOKLkYArMBqhvS7Dmb24RbIJVFYaA09aZY9iY3ihOQxMPxWgr9Gq0LDmZybSypXAIRE68kxhfyViBgR1SbZqtKLIOwJiGaaIbS6PA5vnsMGKtVRgskiVDoTMDs5EvYyO9QZg7hh4RgZzsacGdrbbgAZEV2xuu+F7BjAf6U40xi8ZZcFcUFZ52ZDfXTUZl3FAohWxNDVfzG25WMBsxasi8Z9uvwuNS5GAbmauCFQNgCLMgl+Sa2qGv+55RHdl4iyLmYmdvNvcxov8fduI8ha/9tWaBbgfqIo7hzwSat9aV//Gq/SXj+EW75rbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0SNmbWmKOtD6qcIGLkPBaaHNri0ZoWVLd0PORGmh0s=;
 b=WYfBC+JjK3X3Qzg8w3zvxRmPWY6sM7Mbi0+/a0sbR47FK5mrcC9zkL/PF7I0Deg7FrTi32nTgz751lliOsqTU+1GphKtmrTcj5TknbNoxKUwtq4YDWt0wUoBnHNhi6gCiKEHWiTK8lOV/gHRSRoIg82oVUCOgyiUGzckJ44Y9zJHuFR4Zs3wEo547kCX9FbVqXuejEKVgI0ZVlwmwWaDk/MX4FF4LNEIMQkWGK2htOv9Z5Pqek34g1jUDCOOO0tyPkCkaw0cmwuN5VuKhGLK+YIbmG8i6FfNhHpg2hrB9H/hkrta8LOrvY8HU2gr11jHC0QX5xTWCsjBmCMLJC4PIA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CY5PR12MB6299.namprd12.prod.outlook.com (2603:10b6:930:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 06:58:45 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.015; Wed, 1 Oct 2025
 06:58:45 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v7 11/16] mm/migrate_device: add THP splitting during migration
Date: Wed,  1 Oct 2025 16:57:02 +1000
Message-ID: <20251001065707.920170-12-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251001065707.920170-1-balbirs@nvidia.com>
References: <20251001065707.920170-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0146.namprd02.prod.outlook.com
 (2603:10b6:5:332::13) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CY5PR12MB6299:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a61169-e42d-4441-ddfb-08de00b7f6c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Um9YSmdFdURvMnRSSStzWHhLNXFnZXFCV1pDSzFQMzkxdGNYRDVaSDZGd2No?=
 =?utf-8?B?OXpYNDQ1Q28yTkY5cjF5d0tVakd1R3hpWHBvOW5kUXpqUDQxWUc0YTNjR1RE?=
 =?utf-8?B?VXBEaldXUlN4WEJ6MGkvMDBQZFFGRFRxRThZbXRpRWgyRFp4TXhPNS9sMjdz?=
 =?utf-8?B?Z0NZdWRSL3NRSTExMEZCL0N3ajRJcUZOTlpySVU5VHQ5ckpqYVZwRndDMlVv?=
 =?utf-8?B?OFA5UGhOQ3gvRVZoaGxqdmVrVmdTV0o0NWlkZmozd1l5c3ZEZHdRcFROZ2pO?=
 =?utf-8?B?b3F2MEVrS3lVdXJyVmh0SE4xcDJrc2d2NkJlSmJNZDdaMStiZVgvYkFqdnYz?=
 =?utf-8?B?RGtsM3VaM1pzYWRyeFBLdm9PcEF4MVlYY3VVOVA2QTd2dURUeHZ2TE5WU1cv?=
 =?utf-8?B?L3pBZ3g2YzIrS2hSN2wvMXlOV3NVTlNtb3ZyTnRtNG5rclBWRDBWOENaaDlo?=
 =?utf-8?B?RS81UVVnRzRuNVprZXBSRjVjT2Vham43ZjNWTzU4UEV0NVc1UmM0ZDRUM2ZK?=
 =?utf-8?B?aGgyWjNJZWRleGFjR0lXSmJQdEhLTXhFVGpsVTY2MGx5NnN6WmxxSmprU1p6?=
 =?utf-8?B?UW10a3hGSnMrWDljZTNrM2lHQlFZaGxqRWpvWnp6RWhBWHJwdUpwNGpCNThM?=
 =?utf-8?B?Q29mOWJMSi8rVHdRRFVLYnFGemJUeUdTYktTTk12WFNHVS8vQVcrK2V6M1pR?=
 =?utf-8?B?RDBNQkJKK3RxQmNjbFRwVDBtem1RM3o4aXBibXBJU0tBcWp5TEdYRjY4K2FV?=
 =?utf-8?B?T2V6eUkzNUMrVUFXZ3FWM0NUTzQ2OFhRMGh6WituZkZOMi9McGVEbEhvUXV1?=
 =?utf-8?B?OUE2b0U0WjdRaGI5TzVmMWtCNnVuZHJKTzlETzI0K2U0WEFFblcyT1pvNXNO?=
 =?utf-8?B?YWg2bExZanRJcU83SEhiY0ZEMlFkcFNYVUV6NjJlK0R2YTd0N0ZocXRhSUw3?=
 =?utf-8?B?ZEdweCtaOHR3ZG4yQUlmZGJJMWlINHpJQS90QjN2citLczExSnFtWmV2N0JT?=
 =?utf-8?B?WHNlaDErTXdQYjdxSnNxWlpQaU9OM09ZUDMyc0FWZzQvTXlybUNGVGZyekJ2?=
 =?utf-8?B?R2hNbHdoUE9XVjRWajB0a1BQTUxIY2FSUzVMcGg3ekNxY1BkWUw1emI2S2Jr?=
 =?utf-8?B?cDJqb29aTjZUdTVWK0tYN1hZb0dlNjRvSE9KMjBxUDROeWtOT3FSaUxnbVdY?=
 =?utf-8?B?ckc4Zkh1U0k0L0M3dVpscW42MXFaZFFINkFzV1k3Qnozc2xrclFDK1NoYzR5?=
 =?utf-8?B?VVJzWVhQeFgvd2hiMVJBZHVkbTRIc1lFTVhjR0l5VDVEc21RSktqVENoV2dX?=
 =?utf-8?B?RlQyOFFGSS9jVmNqQ3dKK0tBNE0wb0p0TEhUVWpUZHVUSDVacVBpVElGUjRl?=
 =?utf-8?B?YUdGd2E4M0pDRkdUc1BXVG9COWRZWXQzcUZBWGZQSFYrcUt3UmlkZ051a3Rx?=
 =?utf-8?B?OU81SExnYUMxbGdZUzlnVU1KbDdLbHhtNUdHcCtnNXlkb2RpSHF0ZFUyM0Za?=
 =?utf-8?B?NlhoR0Z3dXBwM3p6SEVPdlZ1RWF2WGZQNUZJNGFKY0dIckpKcEMzcW4xakt6?=
 =?utf-8?B?c1ZvN1hDcmdVYSs2SVkrbFhkS0J5MHlsU25ZdytCaldFRDRPWis3WGs4SnJD?=
 =?utf-8?B?RXJRSUpNTDdJRGs3TWxQWXA2YjdXZTJCdGxPK25CWXZqaXRSdzNFT1RQZXVN?=
 =?utf-8?B?SVR1azZwck1JbjNVUjRpSGp6TEZxQ1ZzbUtKTXB1VGJzVUlGdmNVdlJ6NTRW?=
 =?utf-8?B?cjR3OVlGbE5xUXFWQ2tIUElpeEpDSk9VM3VIQU1QclZtWnNhdmFLcy9qdXhN?=
 =?utf-8?B?bkJDS1NvRHZ6Uk5kMTZibnhodFNJdm9wWUkxODZXN2czRnZWYVp2ZGVmdjFi?=
 =?utf-8?B?aVFORVZWb1pRcGkvUXExZ3BlOHd0enI2NkJ3U2VWNGRadXZSL1I1VHFhc20y?=
 =?utf-8?Q?CSANeTCp6VcTu2o5yq/WsEtK0LvLjjLg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUc4bENzZHpkYk16NE9YS0dsemxJMFRtNDFsNUdpRUJWRGpuZVRyQUtBNnRR?=
 =?utf-8?B?MC9mNXRpem1jNGxqMU1oVjdEeGJYaXppb25rTjgrQUxKa2lpWDhuR3dZSldy?=
 =?utf-8?B?a3lpUSs1Y0lVN1k0THZOd2x4UzlFWU1YV090OU9VV2hTSmJ1dlZKNW5wMExl?=
 =?utf-8?B?L3pTcGNlVDNoZHpvNHF2Q1ZPczF2S1VteXpGRjMrdklaOTBYMUszNkdYWTNo?=
 =?utf-8?B?aGtqNE4yY3VzWW9VYWI5ajVjRFQwT3JKaFZNTThtYWQrNm9ETEgvNytmRVVo?=
 =?utf-8?B?NW4rbkZFUGhyc2hFeE9ISDlUTjFCSDhBUUFVM2tJVFFNdC93QzMxc2dNL3pR?=
 =?utf-8?B?OTYvcFRwT0pDZWFJQ2xJOEtic25zSWpqZGx5cDZxaGtEcTNZd2tVTHBBTG1i?=
 =?utf-8?B?eHVrYXJJUGVvYnVmUHpBV1lZUzZQKy9BR1hCa3NDaDhzd25RZVUxSFNmenI5?=
 =?utf-8?B?RWVEZXprc1hzVGNYK3hvSmZFdzU5UGZlUUNLZ2lVckFFNzM0RE5WTWltK21N?=
 =?utf-8?B?MHE2YU04OFBMM2cybHB1amZCYWJ3VDhCbXNFajZQMHhmM3RqcldhcDNES1Jm?=
 =?utf-8?B?NU91TWlCRFlobkRqQVdWSFBuZllOempTZllUMW03R3I5M3kxdHhOQU4ranRi?=
 =?utf-8?B?THpYdkJmRmdPTVQ0eHIzOUxvTGErbzFqR1duZjhTVngvUHV1d3MrRkM4bXdL?=
 =?utf-8?B?aVBwVHhBSXU0bUxQcERMbGV6emZjRUdVOXRHTFFjcFNuMDFkMlFGWkpwWjBJ?=
 =?utf-8?B?NE5Ka0VTaXRxZk00RGdla0FGMm43elBmZWx4a3d5NEFubXVGbHlLcHU4bFdZ?=
 =?utf-8?B?eUlZcy9lVVlNYWgvOUFtcnJvNkJIOW9VL1FSbnVBTzNEcVowc2ZXcXMxQ3Vh?=
 =?utf-8?B?VHBGRTF4NS8ycitOYlpvdHExOEhaQUNCRjY3ZFJGQ0NNK1c5dnFGQ2RXU29I?=
 =?utf-8?B?RG1iODV6M3oxaGxoNUppYnBSZlU2SFViQmhaSXIxTjRKSTZ1MXlCUnVOclZu?=
 =?utf-8?B?UVRTQnZURXY5cXlYbmtuZzY2a1VUcHp6bFUxZk9zaVVPSVIxeS81bGhKMDdp?=
 =?utf-8?B?bzVLVXRZSk5rTjRndy9jbEJpOHAwTVVHR28rekZYNFAycTFXaVo3RTl5WEdq?=
 =?utf-8?B?cGVsYitndWREaEhGNGV3WnVlL1l6Zk5pVEdCdEJJUkdiUTlEVzJQZVpYcDN1?=
 =?utf-8?B?OG5tS3Fpc3R2MGpjMmk4ekc1QmYxMjE5RzNHQ29CMHc5UHdBYys4Y2VxRWlR?=
 =?utf-8?B?cGdIKy9RY0lsdlcrMUJLZkJURXZZVzRKRmMxcGEva0N0aGc4VmJBUXlOdmhM?=
 =?utf-8?B?cHVCcFoxRFovdmltWnBGYlU3eURPOUNBMkp0OGN6NjNzZHg2UEZGOThBeDNM?=
 =?utf-8?B?WGcxc0RVVHhwOStielozWHB2amYzbVlabHZiRDhyQ2ZjMXZkOS9QWG8yTEFi?=
 =?utf-8?B?cGlUK2duZVo0aWZ4aVN0Vmw5blBvTUVuU2M4MFFuZUhwV0xyL2RQL01oS0JM?=
 =?utf-8?B?YXBCZjQxcGxlZHBpWHduZHlKdllXZXZZNUlXeGcrL1FibEIwbGY3VGpYOHdZ?=
 =?utf-8?B?eFdDWHBjTlpJZmFnMGh0QU5aTDBBTmVISXNnSXlCUjl5alQwN0x6aGxYSUJC?=
 =?utf-8?B?a2xUK2tvV3hQSFNiRG5may9Namw1VlVPZnZXR1JrRzBNV1FmUitibUdLd3JD?=
 =?utf-8?B?UGF3SVhaTlZKK0UvbU9TYlJ5Y094V0p3WHFzQVdTMVUzNnNjaDEyMGpldXhx?=
 =?utf-8?B?VldnT1RvUVlhd2FTcml3VC9WS2xBamR6R2sxKzFPdmZXRlR2RHovNlF4bTI0?=
 =?utf-8?B?UHp6encvR3dobExkU0lob0JuNm9RL0IvQWdtcFNjWFg1WEl2SlNaUGVSWnNB?=
 =?utf-8?B?SUNicTVwQlBTV2FTWFJkdGg1WGp4Zm5HeEdEWTBmQVpCTk1Kc1h0WDRCVnpV?=
 =?utf-8?B?YlVvNzRWSnU5MnlwYU42YnNIeEJmb1lzc1FNa3VFTTFyTi9hTHRNV01sOXlp?=
 =?utf-8?B?bzlURmt2NXh3VEdjV1h3K1Z4dDl0STVqdUdFRU90NVB1anFpZDhFazFORVIr?=
 =?utf-8?B?bUhZSnVZMDVXWnp0dHBtYU9LZEppbUI3TDZGU0F0REMzTkxMajRERjhLVUhR?=
 =?utf-8?B?cmtwZ3VrVUltVFdGSFJFWnkrTmJpMXU1aXkvZkhPN0FJaVFCdEt6OHJ1ekEz?=
 =?utf-8?B?NXc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a61169-e42d-4441-ddfb-08de00b7f6c1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 06:58:45.5956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kk4ovcTIVDOe+yyWYV7UFbzRmaqfMmd4f6nNn1zqrzcQMPhrJToHJnVL9jiJ7XXgyhRldocS0YkrDnoMA7t9wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6299
X-Stat-Signature: opt4ceraykyqmjughznwmxkzuu9nzqyx
X-Rspamd-Queue-Id: DC6BA160004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759301937-776149
X-HE-Meta: U2FsdGVkX1+VgkeVXOzvtaxNqL4M0CVEI1m9n7Ft0xzj3eEhnmfF1fyX+slaITQL6euNLKs1jYlyhV4Z/FgMq/UZhCFV82JoIkBaSlYH5ICCeGsXo7pNBY63xZKU+KlBv8NcW867UvNROVKEqhwkED7DO5Jjx66Q8fIlVCVk0HJjZegJZMmGBbUixwebG8jlEloAbaHevYcI6Y/l5A6/htwhituJEBwr9lYw8YZFZbijIViReQFOjZAzxz4wvJ4qpvLkWK4+vq8bmNeZrDX0k+t3nFdn3ffAHjFIp8nbzrwAFL5l9pAYmp7cVhn/TcybDppJqCT9heqxmmw3U7MMNvMZto7JENFKfavgGCaAQXp9KKZHogNZhElZXW7rhtJQWeoTosDmR/yPDUDA+nlHHn41GdlxQq/R3kgTRYWZK8Qtd+OnNkoEif60stcbC0FiSztLRL9bkBCStB9/8kX8ExJDZ/KBsf6ruc17ZRha190hBDvY2y6rsobBgCAenlIbU4p0NOSUYhFsgHtN+NIkGw0p78cb/0YjtKZaOnmIktmpA/dluxOdHfk2Ht/aemhiLEjDUFcFwENiFjzNZsXrz0bCDuqDcXaYXxXwydOakW8m9fNN7oAwc2qpr/9I/6o6APYZXZ/ew9hv/Mx4h/ZV2C0auulFenlaFkd7n7D2RjYkrtaZQ3Z8kZMtInylh27NcQawFKIP3UxL5I3Uk2PSzUd/xQXFdLKVskDLbfp4ksohDY6FE7Qjug9UV8UoQDsIrBQ3pukTmp6U18N7dXDuQzJOzlt4Lf1IgM1utld84h2e4UqzcESVsbvSoiOA7hCE9NO3TEsnlT8+E6n5Jyov4g7TeqNqlRHVmkNIiKDccN63sDMoIkCDPw901xZNavxN+0ihwu3efS1BW75RomFuVdsd6Y7fHJT7MZ1Op+hasF436V7jzmenuCv4geIjAb/YG2fdUW5ztkplDWNttAB
 rSv3wUWU
 JceLISkypOyQPSGes9e0eaVtYgAINURO6yYVrd8CWsvumfJwpzEvaBBlnFZ/jj4Fb+RZxvkBKFPxMS6dW84kMu1XYe/AIoLfGv4uX9X4hO1/9gSovwp5hfx4SRTJkG+UuVgwinHwVw2QOvvxzAk8YUsEcvkSY7cvxKqsyg3VYmo2l+gmu5Wd2RBZ6ZWKmy4P2OOJyq9gjYS7OLzdQFAtKuv3INIVywuvaAIHE35z5nhnWihw2DNJJBO60vnqb+PRf7he/0UEHSy7YhOt9+5dTNgvP7MRHo9pjzteJSRWWIul6Tf3V1csNhLZf/oRLK4JmUrRLdarNCIUJvywBMqnP9j5p/3i7UV/36pVw8830Mw/GFMhqJ/S5A0a/tqaBpAp8S17bE0nMCQAP6RbzyOYMz2yVtKpIsR/StJidwAhUigTkQkaIMVMs3StJ+RXEMoMV4VnQaQWr33mCqlhwIG4I/mjtHmct7RjgimX5pq30NMmsmHJF77VwAPtjcdHfU0p8oy8tudwc6RDjM0lVGnH5uqvbWsDIRJFv4KJvNa5mlPysTYw5/7IWIyvrxl76wJfAnv60EdNi8f5LiEtFBLvErMgnbdDHL7eGe+/xV2QBYPppZFQtw/95fOXm8h3llZGQyaYkOFTVOH8Sz/MVC//h9f8gVIntf4/bGyl7qX5oR5mDyPemvxMYYpSjot8ILxtk7LvU9YzLZwqvBIT1u+1UETjbJ6j0oLoiOIc7+4fm5SU41qdTmA9OySAcUwXXtCZzfV7ODiKgimheCuEZ+WrUbZP5g5sWbfWHHLuoNyMDp9zrvNOR5GC1PubjZfvLBIgj3YNVLrm4TaoZqLjbHuFDq5+UnDRnO/8k1LoLT6GgONuONL3icBM4XEGp1cVchQhGIbrnL6f81dFz1OVjPNGmoLcqvJzXs7bBQ2ZEjFRNr/ze7Ai1FzfUn6xL5taIYo/UJ0Lz0QzbnCiWG1VLvul9ikuSHXqM
 HC9jnT9l
 VtMjYlzr9qAppNH6oeHqbsMG7r68VySR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement migrate_vma_split_pages() to handle THP splitting during the
migration process when destination cannot allocate compound pages.

This addresses the common scenario where migrate_vma_setup() succeeds with
MIGRATE_PFN_COMPOUND pages, but the destination device cannot allocate
large pages during the migration phase.

Key changes:
- migrate_vma_split_pages(): Split already-isolated pages during migration
- Enhanced folio_split() and __split_unmapped_folio() with isolated
  parameter to avoid redundant unmap/remap operations

This provides a fallback mechansim to ensure migration succeeds even when
large page allocation fails at the destination.

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
 include/linux/huge_mm.h | 11 +++++-
 lib/test_hmm.c          |  9 +++++
 mm/huge_memory.c        | 46 ++++++++++++----------
 mm/migrate_device.c     | 85 +++++++++++++++++++++++++++++++++++------
 4 files changed, 117 insertions(+), 34 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2d669be7f1c8..a166be872628 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -365,8 +365,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		vm_flags_t vm_flags);
 
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-		unsigned int new_order);
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order, bool unmapped);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
@@ -375,6 +375,13 @@ bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
 		bool warns);
 int folio_split(struct folio *folio, unsigned int new_order, struct page *page,
 		struct list_head *list);
+
+static inline int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+		unsigned int new_order)
+{
+	return __split_huge_page_to_list_to_order(page, list, new_order, false);
+}
+
 /*
  * try_folio_split - try to split a @folio at @page using non uniform split.
  * @folio: folio to be split
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 46fa9e200db8..df429670633e 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1612,6 +1612,15 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	order = folio_order(page_folio(vmf->page));
 	nr = 1 << order;
 
+	/*
+	 * When folios are partially mapped, we can't rely on the folio
+	 * order of vmf->page as the folio might not be fully split yet
+	 */
+	if (vmf->pte) {
+		order = 0;
+		nr = 1;
+	}
+
 	/*
 	 * Consider a per-cpu cache of src and dst pfns, but with
 	 * large number of cpus that might not scale well.
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8c95a658b3ec..022b0729f826 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3463,15 +3463,6 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 		new_folio->mapping = folio->mapping;
 		new_folio->index = folio->index + i;
 
-		/*
-		 * page->private should not be set in tail pages. Fix up and warn once
-		 * if private is unexpectedly set.
-		 */
-		if (unlikely(new_folio->private)) {
-			VM_WARN_ON_ONCE_PAGE(true, new_head);
-			new_folio->private = NULL;
-		}
-
 		if (folio_test_swapcache(folio))
 			new_folio->swap.val = folio->swap.val + i;
 
@@ -3700,6 +3691,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
+ * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
@@ -3715,7 +3707,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split)
+		struct list_head *list, bool uniform_split, bool unmapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3765,13 +3757,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		 * is taken to serialise against parallel split or collapse
 		 * operations.
 		 */
-		anon_vma = folio_get_anon_vma(folio);
-		if (!anon_vma) {
-			ret = -EBUSY;
-			goto out;
+		if (!unmapped) {
+			anon_vma = folio_get_anon_vma(folio);
+			if (!anon_vma) {
+				ret = -EBUSY;
+				goto out;
+			}
+			anon_vma_lock_write(anon_vma);
 		}
 		mapping = NULL;
-		anon_vma_lock_write(anon_vma);
 	} else {
 		unsigned int min_order;
 		gfp_t gfp;
@@ -3838,7 +3832,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		goto out_unlock;
 	}
 
-	unmap_folio(folio);
+	if (!unmapped)
+		unmap_folio(folio);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -3925,10 +3920,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 			next = folio_next(new_folio);
 
+			zone_device_private_split_cb(folio, new_folio);
+
 			expected_refs = folio_expected_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+			if (!unmapped)
+				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
 			 * Anonymous folio with swap cache.
@@ -3959,6 +3957,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			__filemap_remove_folio(new_folio, NULL);
 			folio_put_refs(new_folio, nr_pages);
 		}
+
+		zone_device_private_split_cb(folio, NULL);
 		/*
 		 * Unfreeze @folio only after all page cache entries, which
 		 * used to point to it, have been updated with new folios.
@@ -3982,6 +3982,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	local_irq_enable();
 
+	if (unmapped)
+		return ret;
+
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
@@ -4072,12 +4075,13 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  * Returns -EINVAL when trying to split to an order that is incompatible
  * with the folio. Splitting to order 0 is compatible with all folios.
  */
-int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
-				     unsigned int new_order)
+int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
+				     unsigned int new_order, bool unmapped)
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true);
+	return __folio_split(folio, new_order, &folio->page, page, list, true,
+				unmapped);
 }
 
 /*
@@ -4106,7 +4110,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false);
+			false, false);
 }
 
 int min_order_for_split(struct folio *folio)
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 4156fd6190d2..fa42d2ebd024 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -306,6 +306,23 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			    pgmap->owner != migrate->pgmap_owner)
 				goto next;
 
+			folio = page_folio(page);
+			if (folio_test_large(folio)) {
+				int ret;
+
+				pte_unmap_unlock(ptep, ptl);
+				ret = migrate_vma_split_folio(folio,
+							  migrate->fault_page);
+
+				if (ret) {
+					ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+					goto next;
+				}
+
+				addr = start;
+				goto again;
+			}
+
 			mpfn = migrate_pfn(page_to_pfn(page)) |
 					MIGRATE_PFN_MIGRATE;
 			if (is_writable_device_private_entry(entry))
@@ -880,6 +897,29 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 		src[i] &= ~MIGRATE_PFN_MIGRATE;
 	return 0;
 }
+
+static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
+					    unsigned long idx, unsigned long addr,
+					    struct folio *folio)
+{
+	unsigned long i;
+	unsigned long pfn;
+	unsigned long flags;
+	int ret = 0;
+
+	folio_get(folio);
+	split_huge_pmd_address(migrate->vma, addr, true);
+	ret = __split_huge_page_to_list_to_order(folio_page(folio, 0), NULL,
+							0, true);
+	if (ret)
+		return ret;
+	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
+	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
+	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
+	for (i = 1; i < HPAGE_PMD_NR; i++)
+		migrate->src[i+idx] = migrate_pfn(pfn + i) | flags;
+	return ret;
+}
 #else /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 					 unsigned long addr,
@@ -889,6 +929,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 {
 	return 0;
 }
+
+static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
+					    unsigned long idx, unsigned long addr,
+					    struct folio *folio)
+{
+	return 0;
+}
 #endif
 
 static unsigned long migrate_vma_nr_pages(unsigned long *src)
@@ -1050,8 +1097,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				struct migrate_vma *migrate)
 {
 	struct mmu_notifier_range range;
-	unsigned long i;
+	unsigned long i, j;
 	bool notified = false;
+	unsigned long addr;
 
 	for (i = 0; i < npages; ) {
 		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
@@ -1093,12 +1141,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				(!(dst_pfns[i] & MIGRATE_PFN_COMPOUND))) {
 				nr = migrate_vma_nr_pages(&src_pfns[i]);
 				src_pfns[i] &= ~MIGRATE_PFN_COMPOUND;
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-				goto next;
+			} else {
+				nr = 1;
 			}
 
-			migrate_vma_insert_page(migrate, addr, &dst_pfns[i],
-						&src_pfns[i]);
+			for (j = 0; j < nr && i + j < npages; j++) {
+				src_pfns[i+j] |= MIGRATE_PFN_MIGRATE;
+				migrate_vma_insert_page(migrate,
+					addr + j * PAGE_SIZE,
+					&dst_pfns[i+j], &src_pfns[i+j]);
+			}
 			goto next;
 		}
 
@@ -1120,7 +1172,13 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
-				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+				nr = 1 << folio_order(folio);
+				addr = migrate->start + i * PAGE_SIZE;
+				if (migrate_vma_split_unmapped_folio(migrate, i, addr, folio)) {
+					src_pfns[i] &= ~(MIGRATE_PFN_MIGRATE |
+							 MIGRATE_PFN_COMPOUND);
+					goto next;
+				}
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1156,11 +1214,16 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 
 		if (migrate && migrate->fault_page == page)
 			extra_cnt = 1;
-		r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
-		if (r)
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
-		else
-			folio_migrate_flags(newfolio, folio);
+		for (j = 0; j < nr && i + j < npages; j++) {
+			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
+			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
+
+			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
+			if (r)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
+			else
+				folio_migrate_flags(newfolio, folio);
+		}
 next:
 		i += nr;
 	}
-- 
2.51.0


