Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B50C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FB36B00A5; Mon,  7 Sep 2026 22:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE01C6B00A6; Mon,  7 Sep 2026 22:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5A8F6B00A7; Mon,  7 Sep 2026 22:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87C546B00A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15C89A40DB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:59 +0000 (UTC)
X-FDA: 85189082958.10.FBC4686
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55EA61C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="p4k/9Bu8";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
	b=m/T6ZrR22vo5ois0eOj3BERgOHIhbJnA4HyREzK00+dQqzNxFc/PlD8lUqpuNsVtPCYxuF
	/UxA1Zyseo/JeIiprpD/1vfbbg7GhpebAvzwAGxuuZsYlZAMTLf1GAuBrXcsbNIftQ4OOy
	6c2PTYeRm0V8gnAYjt3FQ06XvduXW4o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="p4k/9Bu8";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836216;
	b=FbBlmPoI1HMSXrlQrhOjjkzqnL9yJlsjiM5nmrVEK3ycEk+GjVv1+/5FHurTNfKksNChca
	HlH+kJWEZSQEKYObuuFmqzDtO+dxwzDrwB78AbbABmdZ+Dr3GXEL5mfcf5S+aCq9z+L7Sl
	dXEXR8SmFCLoU/ydunec6YAlR30TE4E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YsbSLKAPYyRDirhE0YIhAq2Pt/nXG/I+Qkh17lplBhNRplVmVRZXWIgdToNLHO+yuVRTJy38Qv3Oed9JtI7rdD0J7bbl0wSwasJEVAMPuTNEtYweIylSRx4nhtfCaQFz1n5pAm8g/NB7LcVwfRSbKk3tQBOEbrlKRSb0fKdxW5cHB4/6s6vOHRLmrsJcHS6yCvt2Oy1YtZknOJDGpEVX9FDwc5/0mkveA/Z04643AY1gxBShr1r+J38N6uFpal9WZXHrcrPsT/Msj6G1ISmadouIEfrfECZEaOAL+No4PbpWLj/sQk638jr2V2cnZk5sWiqt1sbcMp1lXyMPu96bZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=fe6/NEYnYmtVRzdmrwGmMsoylNd50uHufknesREGiRz59TQLpFlgioe2geBSPSZtVBOcPE1RxIlF1qwKJ2UgLKTWt5R839puwi4oOmjeMtHugl/LOZzmCSZ18T2yXrgUMdV5AXM78a/TBmMQO8uqegr7710xo95SKkh8pZMHzedcU2w1nGHm0w++29ucnMdSXhSQsZwAXwPGxX2ajrKgKvsvAZzzDKIUaNRHbxYfByphduJnEi3QsmbfM9tEwl9Fht2AIDOXEJwrzN1JwKAfrpFFChBgZSJPmcxjlxroexr+GfdcY5Q2xDeYnww0YjxPJgzPhJI8AA3SiMcDrzeOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtBmGbUOYFH+i2ZpQMpglFnrKDm5AoKmlhUbiDdRNIM=;
 b=p4k/9Bu8BqPShWyYYC/efcA08jGG+GNpzHFd9/XeYPeim/iwfPuqCGcFSWzSuUdzeKrJ0iOHDa5UI/BZV/4cw+/ZQ/4jQUhXoFls7Rc+u8tUQOcAFBMsPSysnBAgkL5FCoB4HFt+lohKvCCrrBqH/dI9H5DOgOGvjq9OFLYiuZeq/1thSfPsfwdRf+6a+s/kTmXH6OyYlGarDvTorEkjl9IYfCQ7W0L5PxcNykREQ5f8NegxIN81ZV4/HVHAKL84weT8F9Qgox/id1CVLtyfdLk3Q0ssp2OOyX2PAxbBfMFFDI/oY0mVwc2SA/2VODAwBjOEgeNzRvFbqmZ+RgjeRQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:44 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:44 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:19 -0400
Subject: [PATCH v3 12/14] treewide: replace PagePrivate() with
 page_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-12-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>, 
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: YQBPR0101CA0346.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: 631bfd65-f308-4edd-db12-08df0d54d0e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	sw1rZleqqP7c3P8hBKQNk5kE6H2eoK3BB9aWKxoYkMLoAH4d3Jq3WouKTANWncRwtCNZd3IUoCXtzhwg3+GhqxgBMb9k+LkIbeIUp/KpFSFy4YwYhhL0zxvZbnFm72gUEYUIIMVxdfoW1+EZDZePCH0jYJn60hpCvwZN+3h8Kvq3y4IC1m88T2S8VTFjXcKnKBw9NoNPmGbBCMMdR35icMwh1hdg/60xw4RzBi7MogmeG1BBOWOZTZReOZ0TYa6j0nm3laTrUnFUaIAGCOwbkT+3C9L1SWFEsOPHsXe7q+QEV/lYOPdwxgFbdvIJLo7zCNL8Jus0pmyCAcioyjTa0hkhmWqlSdi8TaX1+rEcO+v4KZWCHdNlTWHYDgpB0Zuy6Eg5Pk0TLJ6QmZ1iknfSUB7QbSVXBBlN2M80CjlgZwFGMnlZGdGoyTBM4Jz48X0xYvFgtNlEo+IW96nRaK7jnzYGiKfONr0Y3uLKz1ROp5ZOiISvGo4SCVWIPgsXfnComSfNMAfeg/EX8gC6pwE6jfCeahNE0iNuMJbixuUCm5OrF+QzxVVhfR2P5cy3U6c1hgiwmUJCejuci2QycZLqIbnLRV9+VBSlZfezbntgAdOOfCRMFOUPw+eovv7El1aZ9vgd0r2Mb2V0mE3ZMsPgcetw/Vdb1SOzBiV3HMTjhJMg99lfMH6aTuZ2Em8yoiCMjK8za3An6WdFABQvOI9JBw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzBxRzg5SUZpWEM5akRyMDJzbWZWYzcyK0RTdTdCdWFxbzgxL3VLTDVPMGQx?=
 =?utf-8?B?K1h4WHUvRlNrcDcwUU13VHlhSHR1M1NnWnNkeEJnNlh0Y0gwYUs4UVlvK0VO?=
 =?utf-8?B?UUFaOWUxQjFNSEJYTUYycTNSVFFjZTh1WVoxK1JQYTJGQkpuY0ZjUkFacGZ4?=
 =?utf-8?B?NDNHTEhjWE5SVytoK21hYVMxV3A3VzloWXJaM3l0cTlkMC93a3NyNkFCeWNF?=
 =?utf-8?B?TXR1OTJWSFFDOHcwUGkrZ3lQYURVdzllV1lBcU13SnNRVHVUMUVIYm9EcDRl?=
 =?utf-8?B?MmJKWUZXRkdVRmhERnl4UWpYdzRFeFBka0R3RkJsQUpXSEx6aC8yRTVyRCsy?=
 =?utf-8?B?VjdvV1JoTDc2VU9XRUw1SmZFbVVsc3VqNSt0cSt5OWFNRkJsYlVramNndUF0?=
 =?utf-8?B?SDhRa3ZzcjZYandlYjRVMmRSQlZGc3RPbkQydkpwWnV3RWM0ekhUak9LMHUx?=
 =?utf-8?B?TlBiTVRlN084dGEzV2RKR3J1TWF2YTJHWlZPcWdxYk9WZXc4UE1FaFZLdEk3?=
 =?utf-8?B?bGlkSnNtY0tlVERlb3ZaelMvUnd6VElWRUx2VEpEblFJUWp1V0dhT2hSOTZP?=
 =?utf-8?B?TTVMbnpOSG8yN25pWWhNaFFWUWQwOHhKdXBKdG5lbU9GVnNGdW1VYVhrSmli?=
 =?utf-8?B?UGtJSFF1WnlBYWZSSjVrSmxQZkhxSUJ5bitub1pPMnJ4YmhkSi9VeHJJTnpR?=
 =?utf-8?B?Y0UrcnZFa0NyVzM4YmV5Q1BYSGdqOFRSS3d3dHFuak56OGNuUDk5ZnNNSnpZ?=
 =?utf-8?B?Sm1nOU0yWDk2eERNcTczU2hsMi90aGFYSnR2akIxNmJnK2JzU1J2WERBNng3?=
 =?utf-8?B?akhXbUs0SFZmbHB1Wm1JQWpXVVgySzBaRXVjbEgycDlvci9UMFdnRmZwekxs?=
 =?utf-8?B?ZGo4L2xwUHhzOG9XNXl2bjRQM0tEeHFKU0pWN1IzS0kzWktsR3BNVjFGYmtR?=
 =?utf-8?B?YTJvV3d1OFkwU2Y5RVJoOWRWZU4xSzd2cllIYVkzZWZkL25ob1lydStkL2k0?=
 =?utf-8?B?SlVmaHdOWWhaYm9XbUYxbEc4NGdNdjQvbHNnL2s3TW5QVHg1Ym9JaElLcjlK?=
 =?utf-8?B?TFRkSlgrcTExRkVxUm0rdnYrM2RLNFFOQjBLZ284V2UxQmo3RzRCNHBsNUxv?=
 =?utf-8?B?VnRTVFQ3OGxxVEJwMithOG91dkVWZHRSOUEyRi8wK1ZEN3R1SXppYWZ5akw1?=
 =?utf-8?B?cXh3ckxIZlhZUUZpNEhjZHF2Zyt6eitUS0RQQWUzenBvT0IxNlFwQUlEUEtx?=
 =?utf-8?B?WjRLcGhqcmp3RE1kbHE1ZHhrbGtDc0RCNEcwclBydnJ1OWwwREVSVi9UWXJC?=
 =?utf-8?B?YXFoRThjaDQ0VnFlZUJRQWtCQ3F1amlPUUlqd0tkTk84UkhUTmdTK1Q4ZHph?=
 =?utf-8?B?cmdzaTJwcmc0UjZSSjhodUdMTDJNZUU0WWwrS3o2ck5VYUJEZ0FOeG9MRDdr?=
 =?utf-8?B?Z2tXQnhsbkJIaGpOOHBZdDRzUW9SeFJXRWJKMkM3dVg2WFlKUTRtaEt2YnJ2?=
 =?utf-8?B?VjFZMHZCM2RKYnU2eCswVzVwNlNrTmhiMjZvZlkzM2V3RW4yS3RRbWo2bllw?=
 =?utf-8?B?cDdwQzJPdjV5TzZ4ajU0WStiNHlsNE5xaTBxYXVYWkFHcis0RW90bE9RTkZi?=
 =?utf-8?B?NTdiM3B4SWhPaCtsYU9uSVdiU1FxaDFzN2M1c3JCVnZWaVJSbHpHTFJ4WVE4?=
 =?utf-8?B?OFFuNEJvVHZSVnZOL3RQdG9mcitJNFJjRE5Qb3VrUXhJd3grV2dNbS81YXND?=
 =?utf-8?B?WjlUQUR5UXNWd2RCaWhvQVZqM0ZVM1l3QVFRTEMxNmNwMXA2a3VpdGZaLzJ3?=
 =?utf-8?B?VEh1ai9qR1pZYXpLUkk5ZjNxOU4rbCs1MXZaeHpvTWh6ODluYVZVMjB0R3ZQ?=
 =?utf-8?B?cU5FdEpjVVUvTDVLdXhtcXhLNElHckVZcWtmT2ZGcFpyTlVXNnVjRFNnOTcz?=
 =?utf-8?B?UTFkbzUxeHFqcSs4OW9GbEdlOFNFalRIZm9zWVYrbmFHY3BzUk1pSzlyUlF4?=
 =?utf-8?B?T2FXeHBTN2daQ09ZYTJhdkhKRDBCZzE4QUYrQWljSWZUL1ozQjg5bk04WGcv?=
 =?utf-8?B?L1BVeU9CeDNwcjFGQWZWU1dPd2FUc1FrVzY1K1pzd1BwVmdzay9TbDZzbVFy?=
 =?utf-8?B?QVU0dVhkc1FOdG1yWkMycWZwNWZMaUFOT2xxeWgvNXU2ZXNPRjE4T0x2RWNC?=
 =?utf-8?B?QXVMY2I0TGpwMGpRNmNkU2orZzg3NVB6bFhoZG1rVXBxRlh0dk1nenFudjc2?=
 =?utf-8?B?UWdFdEl5ODFCanlKZm9iRHc0V0c0dXQ5Z0dzMGlJY3ErVzF3U2hUN0t3cFBq?=
 =?utf-8?Q?13MuuGX0HBHcmMgpLy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631bfd65-f308-4edd-db12-08df0d54d0e4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:44.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKjgBCGuEFkEfOc+C4SvHM3tzkrKZa5O3krHDUrn27qgkrfQkYhASkbhGHITtlST
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: sg5jd14rj647rxgfh343hxhbkpzqmqs1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 55EA61C0002
X-Rspam-User: 
X-HE-Tag: 1788836216-680225
X-HE-Meta: U2FsdGVkX192VJtkBClz3VSUmBGnju9bfB6uVgCyGPilwSAreeB6lUn76qlHzpVTmIkZ1HbRl24tyefu43ZKS7RyXIFZuQ7tZF09+ivDsU06vZvRw6HIp5TRyyevRQflx8yiiuYsUOWHgYG/kzTfQSL/CRwpoQjPgeIhsUfuG/yH1ClFKL/7/8XgXqSsI9nGL55DLXqgCtnnMgSkvTvU3gGlBDN0aao5v+64aLckYLz32e9tznItbaTjA3f3kNhB2ZeJhOib+F6FrkiqXxLiHwT6rdVVT+IUpGozbyv0qcFyz7LZEFwtHKLCEsa+Vr7k0E76uTM835IQTwFjkLDOr7+nzoS7jcyu1Ya+28qs8n0PxLyNty6BEiVVNhDNuOP3kFbTP5d2EDzDIb7Fz55nvuLO+oGjcwwuNxYRIZZziJruqsvhNtFMau5Quw6pNQUVOOFwn5p1XnrnNRGjSAMONzWRjJKqe8poAEiztbzCKLKOyYE+pJQyoLTM7Cujkh44doDm6uh2+oLBoAqiO2PlaA804U30rnTxXZIUPG0ZcFaXE9SkrDrl0ewoyuFrLUdkiVLoMugefbu1urZUJVgySyocv7ua4PmWwClpn7BPUVNrI7T51jZwKq7g/x+izAHSTXbY3+FkaHa1guDVAt6eyMoWV+ojP401W+/JI84xTHVgm7kYSX0tn1vNgnm3m1mXnHZt2il1nSopEvGi9lchlmvGA98BEp2+Bw3KcdM8Y0DQvtq8ouA2Cp8EkMkrwCu8WGRGUr/30eFGr8V4QsDlgG00GbmRMFeBEm6gWXj9OdwDnINd5yt/Dyvp9Em+SHtxQfuJT2Jxo75jI4gIW9kbMcqChnmY9BYjPan/klvdC9NLgm7tab4VLAd7ryWeKVFZXwJEKr27hx36cnzrgS15C+ivQ0lVh6cW/G+uIJSOxcPbY3OAkffwFBnJyeVorS3BYqehyBtJUNBjlKtIQsc
 hm4Wu6Gf
 B/fLz/JtUAu4tByozrGP7KYOAedRNMp8cBq5ISjHlhjW6ZFEfdb0eL9/AEAVtMTdRtxDjc9RY/CcIXnpcnX+3nDRxc1t9od/yoVpWNkr/28azHxRMJZK9ItvnFCQJF7jm9EuizJ8ya2jP/YAaXmsZz8YS3ZENEPkG6sR1VWyfEHHtt45b3e7kyDLNWeoYaZ5IoiALktSpAcbRC+MJUueoXyzMYJDcqUpX0Rl3vlK4ZrAkrBnh2BE6lVrH8gU7P/S5pZ2p5m/zve8bWVmMXN4FTWweyzG2+le5pN4MKgXdcLGz7wtRhuJSBXa0Jef6+2yzUW8W5QNosyjk1c8hUWYcuSCap5vWiXW66HdcbeqphWt1a/KB47Ie+uYt1RM6mE+I8b2WyR0Idj2U5TFUZyf2E11ybd/qoN0CL0amdjuc9f/beumDSYRZRtOc0KO0jYMJxAVwVvsLOR+B6kqvU9luRMlpnFkgnOsMNfnAVbiGfnx/r09f+FDd7Ibhv7M8Gp46FyJ3ngfJmOloqjzcrjl4W3hvdlU3+yQy13D/avMn80FvCT/RGsrECvAF5oqkOeaw5RzBK8iA/JyuVHfjWJJxowkn0EccTN4OT6SumdCoSYAfsLWZvI0S8CiyyZjb1TRvv8KO+kT7XgDV0O/xUJCpgyDWew5BBcSKqPIuqIwARJ31JlIxWNDcpg/brV5iVZoqe7YAmQ9gyZ0i7L5e4rOFROV1hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PG_private is going to be removed and its check is replaced by checking
page->private != NULL.

Replace page_buffers() with page_private() and delete page_buffers(),
since only two users left and both can be converted to use page_private().

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Song Liu <song@kernel.org>
To: Yu Kuai <yukuai@fygo.io>
To: Ilya Dryomov <idryomov@gmail.com>
To: Alex Markuze <amarkuze@redhat.com>
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
---
 drivers/md/md-bitmap.c      | 6 +++---
 fs/ceph/addr.c              | 4 +---
 include/linux/buffer_head.h | 6 ------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a371..0cf14bc1cff32 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -516,7 +516,7 @@ static void end_bitmap_write(struct bio *bio)
 
 static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
 {
-	struct buffer_head *bh = page_buffers(page);
+	struct buffer_head *bh = (struct buffer_head *)page_private(page);
 
 	while (bh && bh->b_blocknr) {
 		atomic_inc(&bitmap->pending_writes);
@@ -535,10 +535,10 @@ static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
 
-	if (!PagePrivate(page))
+	if (!page_private(page))
 		return;
 
-	bh = page_buffers(page);
+	bh = (struct buffer_head *)page_private(page);
 	while (bh) {
 		struct buffer_head *next = bh->b_this_page;
 		free_buffer_head(bh);
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 657c2cb0f8811..fad17df1d5082 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -70,9 +70,7 @@ static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned
 
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
-	if (PagePrivate(page))
-		return (void *)page->private;
-	return NULL;
+	return (void *)page->private;
 }
 
 /*
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c0542..e47fbd0387b69 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -175,12 +175,6 @@ static inline unsigned long bh_offset(const struct buffer_head *bh)
 	return (unsigned long)(bh)->b_data & (page_size(bh->b_page) - 1);
 }
 
-/* If we *know* page->private refers to buffer_heads */
-#define page_buffers(page)					\
-	({							\
-		BUG_ON(!PagePrivate(page));			\
-		((struct buffer_head *)page_private(page));	\
-	})
 #define folio_buffers(folio)		folio_get_private(folio)
 
 void buffer_check_dirty_writeback(struct folio *folio,

-- 
2.53.0


