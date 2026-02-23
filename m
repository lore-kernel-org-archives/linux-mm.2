Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7294EA4FC2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3366B008A; Mon, 23 Feb 2026 09:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A0A6B008C; Mon, 23 Feb 2026 09:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31A46B0092; Mon, 23 Feb 2026 09:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C05866B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:07:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EF2D56B7B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:07:11 +0000 (UTC)
X-FDA: 84475898262.23.ED5E7B6
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012011.outbound.protection.outlook.com [52.101.48.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62D9E180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:07:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BBMEkQyr;
	spf=pass (imf24.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.11 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771855628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Y7OdAywcCZTamo8JbTLm03swxtZx0YY+69cEgHxznE=;
	b=Gmhekbd08NfjnPWiDQYtGRQPfYQndUzY1M4ZQ5p5SAfacsQBwPZIrsVW9e+kPq4sYwmL9e
	a+rv9BKndf/3Qviz+zLBp953ADMKGAWYS93SITd7yxb4P0uGw9UPPJQdQGclI7NyCYpw7a
	jbPbjakvLKcYmsjI5iWHW3Y7qhIDyq0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771855628; a=rsa-sha256;
	cv=pass;
	b=8DIzEBZQPmTRV5Dho6pZpDlNiLuvv89PQuVDw6FNZL60CiqaYGwKajQ+pGM9XE8yRug4+U
	t+anoTFKy9LjTMZYJSB+fRpK5omcTfVSEWWqpkDtJ2OOD4fwWpSyIFrT0LzKxuSSy/yRD0
	aeIEV9LbU3/APYWRHmla7epKjQKVTa0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=BBMEkQyr;
	spf=pass (imf24.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.48.11 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vtYH6bIW1eI9fIaLj2spl6rWMr47QbriTAJWwXuU0/cK40GI5U30i65krAiPK2mZuB6Ekz/deib03Nb1sFe0Rec8wK+SWGLZbJWvX3p42kkQSxfI6IkBKaLVhIpdmtrz+lp3DSW4TRhLQNWHy6bgU1m7O4uuV3bvu7tZGo8ZAVvCs9Y4MNjV71lxSi8mqOdD9Za61yeLGLc5Vq/coYFvkgoIoN2CxWm35ZauaedMlanbzge+YjeZbMXCcRAMwiQMc498r4/BeGaLqTkbfEBt8huezimYFcKHxr/WgwPyOpOTymVeJ3GWtlyxc/p9jcg7SxAorphALJMhOS1xaZFE9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Y7OdAywcCZTamo8JbTLm03swxtZx0YY+69cEgHxznE=;
 b=lq+B6DgHlzyYp5snk/QJt5KaEFO/NXNQzfaKRQGyoUW+ccD7RVcKhxQlCAXwtghkdiZlfY8kSxmFlE2wV1EGOXODM8lhWbgXRUrofl+o6WTDhHpdJ2ofbSZAQ1vkA7L/KkIJoZfhtktKY9o2VYEA8zqx0rc0mEOmXvFY9g2V/TcKGvRqA1TfkKmsEiUyn0a/q2vyXi2NLz6GA/oD0xm3qPfZZgH3cI/KP7WbzVmeGvTnMKBy+kGCG1oY56/pLUjSyb+VmRZNXa5+LVXzo/xXM7e9Yg5ykAQ3AmzJ6kmU6Ld8JG+y7ICwNH9p7DNxrdPPN6abof0qNrEU3mF3ApsCMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Y7OdAywcCZTamo8JbTLm03swxtZx0YY+69cEgHxznE=;
 b=BBMEkQyrNI9JSGoxD/bI+esfVOGnIOBUDpDAPKPEVdf8CZsbgSQe8PJwcnImc/9V9BNzdt9dj4R+8muJwLjfk8kIyTq2LiOivldIYqI6iRUlX3XvmLRK3xTTmD5J9qFhpmgcQOp7dZL4ynFYP0jbog/Mnp7xK1okHbauEp/I5fM=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DS0PR12MB8071.namprd12.prod.outlook.com (2603:10b6:8:df::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 14:07:00 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 14:07:00 +0000
Message-ID: <cb8d6ee2-fd1d-436a-b934-aff87adf5dcb@amd.com>
Date: Mon, 23 Feb 2026 15:06:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
To: Christoph Hellwig <hch@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jason Xing <kernelxing@tencent.com>, Yushan Zhou <katrinzhou@tencent.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Davidlohr Bueso
 <dave@stgolabs.net>, Eric Sandeen <sandeen@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
 Alice Ryhl <aliceryhl@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <aZxaIEFZr2NvO2eQ@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0019.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c9::16) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DS0PR12MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: 49f83a17-4aba-4df4-9bd1-08de72e4d020
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eFdtcjlQWk1Odmd3d1BLWjlqeHlWelpKbkFaNm1EMTE4eldyaUYxcFpXWmJL?=
 =?utf-8?B?bWY4WnI4QjFUenhQMFpycjFmSGNSeEVvSjFpc3pZZE9tUGdqWFFNYkxncXZT?=
 =?utf-8?B?RjdCcGVTZTVzV1FhWWprelRQU21vNXZvbWF0OFA0Q3lVeGlmUTNDZFgyUXo4?=
 =?utf-8?B?amk0cGFlYXI0alBqQWNvTkNkZVFqMUw0cFh6Q0pZclJ5NUM0c3B3a1hKYVRp?=
 =?utf-8?B?c3JaV2RuWHVDSzlqUHd6WFUxS2xIcnpxd1VTODIrMWxuWkJtMFYrTEVGNyti?=
 =?utf-8?B?cmJsa0ltQjFwcW9iczF3LzVpTmlCbGlBT3ZHQ1ZVS09VTXRLZWtOM01XZnIx?=
 =?utf-8?B?U2x0ZCtSeGZYcHlkdlpseXBlalN0U1NqNEFUYVJuOHJWQ3ptcmFSOHpwalFh?=
 =?utf-8?B?MnBhc0llRDJCRW9qMGE1WXRVZUsxUWx4Y1NBMk9Ga1p2KzljeFM0VzdJKzNi?=
 =?utf-8?B?eUZ1bktETWpzYnZZYUJ0NDR1SStNbXRMcG93dWlTN1NsZGlHSk9vazJ5UEJ6?=
 =?utf-8?B?SlVIYUtmSjVhRzhmOUZ5UmFONGExaytWMjJidGcwTTY5MGExNE5YaUlCU3NU?=
 =?utf-8?B?R0dFdnpzeXN2SmNGRUd2NHZkVEI5N3ZlWVQxTmw0ZXdPWVFRbm52cmZ1QTRx?=
 =?utf-8?B?V0JNZ2crbzMzbmpUaWwxZkUvRHRSVGpKVVZ0TXlrVy9RUStTMEgrMVhEcFNF?=
 =?utf-8?B?WnFQeEExYW5oeTlvNkJpL2x1UzAvd1hCWTY3d2FlVjNXRDlMSkYzc2ErWnBZ?=
 =?utf-8?B?SDlaQm9WOUdVU1JwVjlUK0src3lUUzM0Y2UyRkZVa2RIdW5KbGJMUlQxOFh5?=
 =?utf-8?B?MmFVeWhxUGdSTWdLUUFya2ROWFRQcVR4RzVlYUxZWkMwQmlIOHROWkx3Z01m?=
 =?utf-8?B?ODk2bzdQYitLY1d6RzNXOUo0QnNCeUlLbXlzSWVSVHl6enVwamZQRVA0dUV2?=
 =?utf-8?B?NXV1bTYyTVBzMUM0R2JYQlVQTjdnajd6eko4VlFIcUlNM0Z1M28wMUp0QVZt?=
 =?utf-8?B?K1lvbWQ2ajk4UTFNVmRYWkZEN0I0Q0ltQXg2ak02U3p5UjZMSXhpUjhwT2hp?=
 =?utf-8?B?SEw1dWRxV1hOc3dLZml1Wi9TOEFCU1g2YWNtNTJNVG85ckkrZVVWMTI2LzFt?=
 =?utf-8?B?VFQrd2lReEhpaGZYTGl5ejZWUFVRaWdGbmE3M042aFBROHdmU2l5YzllaHo5?=
 =?utf-8?B?MEt2QUNzNG1kckp2OHV0dUFralRlL3p2N0FyakNoOHJQTDVvVnR3akdYNmR1?=
 =?utf-8?B?NmhlbWxYQ3Zxc3BCcnAwTndESTR5dVBwUTZxRXZPb3RkeDcwTklOME1LcDhP?=
 =?utf-8?B?YTFBemdacmpISzBJaTd6NUpsbCtZMnQxZkg1UGYxMisxRkdEeFlEV3NxbGl4?=
 =?utf-8?B?YXJwM2h1d1JvM01vdFhEaFR1dDBNUDFveTZxY1NEMTZZRFhPVWN4VmRJcDM3?=
 =?utf-8?B?N1dEWm91ZFhyMkROcjZHOWtHOG5VRExMQWt3SlhGbExScENlOTNnNGN5b09n?=
 =?utf-8?B?M2JNdnkxeUxEbXFrZmt1bW9CdmkzL0lMeTg2Tkx2ZFA5dk5XSDk5MnpOMjJo?=
 =?utf-8?B?aE1SbGZwTjFtY3lEaDhJTXhCSUM2MlNGS2trRDN2M1JWY3RVVlV3L29SQWRx?=
 =?utf-8?B?TVptbXFVSkJxaFNhVUxpNDZLTlUzY2taOGVZbkZseXpJWVJzV0x0VW82c0JF?=
 =?utf-8?B?UkttOHFjMmJObWpBbFNKS2ZONE1ZdzA5S1B3VTN2eGNVQms3NGFHVnBMeGpl?=
 =?utf-8?B?Zmd2b1pyclB0UnBXTTExK1huQklBellBNTlKdE5CU2F6OEJwcy9jUXRvQ25j?=
 =?utf-8?B?TU1rdGw0Wk1XeUxLU2Nlc1RHbEYzY25RY0cwR1RpSjcyNEl1UDlhNTNuSVh6?=
 =?utf-8?B?S0ZMMFE2N0ZkKzNjYlpaWjZ3azQ0R3MwQkNyaG1ud0YreVg4UzAzdWZkb0sw?=
 =?utf-8?B?WEVNOThjYzEwUWRGVUl2MmJjL2kwQ2ZaOUtBZEorNFNpb25MZWRObUUrSVZL?=
 =?utf-8?B?SW82QmpWVVhOUmRjckd5T1EwSDRCWG1BOW1BeDRuMGRwaTdUQW1RVzFJazdW?=
 =?utf-8?B?Qm9DQlpvN3pRd1g1dkZjY0RYZFlNVmswcEpXWUUzdTk3ZGJyOVhSQkRTYkpo?=
 =?utf-8?Q?p0u8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eE5CclBhSWlFWTZjeFAyQXlWei8zVm9kTHpRZnpXbHJOdWl1Um9ISUJwdjlF?=
 =?utf-8?B?dlVrQTFNdk52bU1oQTQyNks3MTBleW1pRGRWcy84empXeDk2bzRQVGU4WWln?=
 =?utf-8?B?a3pVQWo3SHp6bkx4Mnh2eG9DSUZQNmRub3Jad1pIYWJhWlcwT1dYc2xzcHFR?=
 =?utf-8?B?NkFnSngzTzNWR1o4N09BRitRclZyLzJHWDJsaElnWlYxYzdlaVE5ZW0wUnVM?=
 =?utf-8?B?TnBVNDJsb01pQU54NnA4aWlEREpIaHB3Wm9Ha2VKVDJ2dEJLQk1EM0RlVmkv?=
 =?utf-8?B?ZzN6ZzUzV3NPS1pOdlErM0w0K3VoYkFqY0VSdUxENXhveTRlTGZWNy9uMkFG?=
 =?utf-8?B?SC9tcnRrUzJCcklrR0VjeDc0QnJ4Yjc3ay9SMDJDMFZBZmlPSzhlQ1NhdCsy?=
 =?utf-8?B?L081Z3ZDZElocURsbjg2WjdoNmxWejlybWcxcGhxMDFkaXZqd2tWd1JsWnVI?=
 =?utf-8?B?T1RwVWJxZlZYNUp4UXNmQkRVcEVRTllPYWtSU05idHAwUkl6SzFGRGxnelYx?=
 =?utf-8?B?d1EyNzk0NHBSaTJWYlJ5VUJZN3Bpcm5xaG5SQ2NVaHZEUmJQOTVBUzVrRUwy?=
 =?utf-8?B?V3ZIZ2w2bUxUZnorOFFWQU00QjdHV0ZwRGtBV081Q1hWdEhWVHRmMmRaTFlp?=
 =?utf-8?B?SjBGcjRxMGE4TW5rcWo1cklmUG1XWVpWWko1MVUvZDNDaXdYZ3lZVXRDNC9W?=
 =?utf-8?B?RWJvdUxuM3lzOSs5NWI0OUpycDJtWjBUalFLclZ5THRBQm1YOTlFV3ZlRWJl?=
 =?utf-8?B?ckE2cWdEWmhEd202WGtCUFNnMWhrNUwzd3YrZm9zTVpCZml5dXgxOHRJbEtw?=
 =?utf-8?B?SVF1NDdydkptS1RIbG9MUU1mL3BaNHorVDI5NDVKRnI4S01Qb1lBUUZJVUFN?=
 =?utf-8?B?MURzQ0ZkSHBpUW5zRldZbmhNRStUekVHTVdxU1RjM0FqbzlCVkhpM3ZnMHBS?=
 =?utf-8?B?c045VGVEdk41cmVDeEMrWHpCMmYwV3BYTHdseFAwN3U5cnI1WEVqMC9zdERP?=
 =?utf-8?B?c3ZoTys4TnJ1Z0pqZmd4RCsrU1FaU2ltYUtQM3F2ZGJoSWt6cnA2cDU3bXRO?=
 =?utf-8?B?MFNpYW05SWFyM2FYb1FYeXpnenRsanYvRkVINllpNWFQc3lBWi83TFJ3SVRS?=
 =?utf-8?B?dElJS1FsTlVWRVpvdnF1LyswUVIrdTkwc0xCeUM3UUYxVENwUndNV1RFMnRk?=
 =?utf-8?B?anFPQTIxNXdTcy9xY1dnOFdpSGRQbTR6NXl0blhSZkFFQ1hsVGJja1VFQkk0?=
 =?utf-8?B?bVg1K1BLbTR0eFU3WFBGSWNxRXNMT2h2VHkwMVdpczlsRXRmSmUweHRFTjY5?=
 =?utf-8?B?VmdNK1kvVXhWZnBkRXc1R3lUVlg2STRSdWo3YW1qcXZwZUZSTFNST2lFTkhU?=
 =?utf-8?B?M2U5eWx1OXFPTWxDR3M3aC9XSzJ0MHRvb1hDbU96SEJmRENMakRUVGw2YmJm?=
 =?utf-8?B?cWRkRTY2R2FDRUVCMDZ4ejROVWdGTWszeStHak45c0NJMldOTFA1SHUwcDZp?=
 =?utf-8?B?aWRYRnI4NDRROEpIWlc1cXlwcDdXRVgvWUlwNjdpeDgrZElGSUZYZHBsNnRx?=
 =?utf-8?B?WlpETVVmeURFa1p5VTBqL2YvSnJFNGxwYlhabDlVZG5ySnhMUmdqVlRHSi9h?=
 =?utf-8?B?Ty92NnlIVk02VTBxTlR2dWJVUUF1OHVqcDNrUlBFYlJOOHl6WmJIdUthczAz?=
 =?utf-8?B?RWVjK2FjNC9qbU5kajNVa2p4bzdkNzkzSm56TzV5NVpQTG02SEtWN1hGM0pq?=
 =?utf-8?B?TGd2RW1PTnhyYXloYU00bzUzL2x1dU9EekdGUW9ESjhFeEZpdHNzTFRhdlF6?=
 =?utf-8?B?RitCdGUyMi9KTE5nQmpqODByMW0yVk9FQmdBMFdKZ3BtN3dPNVA4cml4dVVS?=
 =?utf-8?B?VkVQUEVpcmU4VlBkSXFzV2VldWhOUm5kYktqM1VjbUZaWFNyblpVODJEc2lU?=
 =?utf-8?B?RmdqVk5xUjBYMXJQTm8yU2FGTHYzWWRMZzRTYStyc3QzUmlkeFNlTlZqcjRP?=
 =?utf-8?B?cE8xazlmM0VTRThSMUdoTWl0NzBHV1hjenFyNWJqR3E0VGViQTFEVDN4MWJx?=
 =?utf-8?B?SHlQc3JsNGZib1R5MHFrUWZRRURHV3pxZVBqTHhWbGt6N1ZEUk5MWFlUOUZB?=
 =?utf-8?B?UFZ4dnp2Mm1yOGxSRnpGazZwZnpSNjFaOUNlTnRPRjcrc2x5QWVhMnVqKzFL?=
 =?utf-8?B?aXlQL1Q5b1NTYUhSUHhTb0xua3duK1NseUFzNmxhNkV6cWtKZTFrUW9lODFB?=
 =?utf-8?B?L2lTRCtPdE1ybGN4K0RKRG1VaWtDa0U2WTg5WmswYVByREdxaUNFVEVXRDAx?=
 =?utf-8?Q?gXSsj02wfp5XlnYe8o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f83a17-4aba-4df4-9bd1-08de72e4d020
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 14:07:00.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXCpHyxCbivXXQtH5b7IK4mVPCGYrMQx2k3yIwvIsWt88XHoOeA5kWo4K5d+Mp8C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8071
X-Rspam-User: 
X-Stat-Signature: mcpbca8qpytghyhx1zjmptanhwame5rw
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62D9E180008
X-HE-Tag: 1771855628-943096
X-HE-Meta: U2FsdGVkX18ulyUi2VYk2GR7pLkNDyvQXCWpjWul6qFganWoiLASZw1sFcKG+NoDeu57A3MLvcsio9v8JMag+UCAwKI6j/a8HoAuzoQCbvu0gIJNv/4TsCVTCgcg7weulOhT8NUI9CJxxMdmK5qjpWkz2MzCVeat0CSzgezObek2Pe2t4TBxu1lnBf7pP2UJq8B1I9Wo/LMvWQDlRdzoRyoqqWR5cJT1nNYUj5LOFK7PCzbBKKkSdNImfNsSqZHJgCi+qIVb7Lesin/mRnHJ4qmwMSuADcVwcQOO3gxadcPBRb7Y7yLh05uPi4GVhzMvb2UgRYno8Uew1Jbqy5dbQ5wh4ItNsYCyE2za/VKWKt2HiLL9Bdpkgow3XlIukXji5pBQMgCT5IDnNqgYQoa8obHaTiZLBlClA9w+noEjn/WHWzW5r7wYJtJWnVELMMNla4S93c0Fu+QY9rSA+Bo7vaY989f4+JCUomZLUQ+9NJ1aklk3HRCh3je9gbyGf9HT+w3kq0XjhkxtWUssGJW0wrAGpqWQ8URrP3sGBRdWlsIFLbC7jFVJu9lA20hgyQ9yQUcGEIoIlMdcLCCD1GT6E+vYSiRD4c6YpCYQsyro6inpHm/YPxE2cdjUqbhQ9dTzo9jtzAeahp1MyfV7Pgt7m2z5bB7q7v7cidbyuq5sNmPgU534wumowbGOENjSKwPLo6K0qNV2c6V1Iytgfm6+zgiBtq84VYtasZdvtR0GhJ1rFoEBlEg9beRfhSM1NN23uTvArLJlsEd8JZkgXQG/mX7iAPem9WKI2tqRyet83yB+0hbj5Zh51p0a0O/kR8ornuI/gAGZN1LGESvYKYF+r83A/XfVwBStfUaQ2vp165c2K1CQq/cY2NvuMJb9jPF4bhWgmfHlNaoED95oWuUxNqAQgcgjPWsftbMia5jrlGlMamrenvdqPcT1Um/ZhsFAvNvHu45CdCfEjUM2dZE
 9XFs4IKU
 nfYO0eR9l08xqRBCsuGXiCOpLU5aN1A27X22ccifV9zt1C1Nn5CrOuiTQKk+eGWRMb1n3fTr2kEmzftfaJTIQndFydri2ynCybDxAUgafPElyMRop4BI7BAyj0XbRoyqSYzQ9KPOP6AUfi/yzku8N9xD6ZLfoD7r6UK9fzvlo/Qms9/y///IeOOGkXRzYb4Tj8Gtlat4er6GmP6r69K4Gd35DAqs8q21WyVIeeUEfEq4kIUo6/FKp0b4Fjf+rvI8FclSliLQ/tOZ+9WXjzmhjdCZjRJHoZ+kWkgBG7LAJIBcgocoy3NWL0dxiMb7eepOPzi6DHDN/z9lBb8Ck6cXW03B22Aehrdodc7gNWHKxxqsCMu9MVYQ09vI6xoBgbQZfMVQcyI+JjCR0NJYwkhBwJJYAtGCE2+ALh2KumJ1+KXTGIEXrRhulGKgDTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 14:46, Christoph Hellwig wrote:
> On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
>> Hi all,
>>
>> Based on a recent discussion with David Hildenbrand on page->private
>> is not zero when a page is freed[1], this patchset is trying to fix all
>> users do not zero ->private when freeing a page and add checks to make
>> sure all freed pages have ->private set to zero. For compound pages,
>> both head page and tail pages need to have ->private set to zero.
> 
> Requiring the user to clear a field before freeing is just a way to
> awkward interface.  Don't do that.

Completely agree. This is just asking for trouble.

The cache line(s) backing this struct page are most likely accessed anyway on free/alloc. So I don't see much extra overhead.

Regards,
Christian.


