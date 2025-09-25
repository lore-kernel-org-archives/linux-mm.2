Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A76FCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:02:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF058E0002; Thu, 25 Sep 2025 08:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896558E0001; Thu, 25 Sep 2025 08:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E458E0002; Thu, 25 Sep 2025 08:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BF488E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:02:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0817D1A03DD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:02:17 +0000 (UTC)
X-FDA: 83927634714.30.1DF2C7F
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BD5C40007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:02:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sPl5l0vc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758801734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXp9hEvgAhql/qmowNbSIAM8P7cT1c5Vc/bQB0ARNl4=;
	b=dDayB1u5ycnAcmIc1veyxKmT+9pw2Ur2HtxJqHv2qXXVOGA+XAzHmntUTf5BqlOzdS+Cm/
	EO18C9w6I98U5wlHK8tTUTjx1J7oD4JcQABRpkT8lnDfoCpJ/pPPkvqGermvIRmePAOlc3
	BhK//oH8MHgO3M46ZQN4ghiEaujUMRA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758801734; a=rsa-sha256;
	cv=pass;
	b=XretdQzhkQu1LDR8kLKSoFy5fEb0cjmQYpZlxCGbvajLc8ZvzXSlbH2B7MMGKSufg93b5H
	AqR3MvJOm5wuoeDu326DTZrIVTFoE+bO8glWCiNIDYZn3+buN6gxhLBlIDPSxpzf06HqDb
	+s1IiKoWHEwWYVwR6V+EwRvohlZFZT8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sPl5l0vc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.16 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kV2sKJoKHwYckhegfhKmny/CwfpvqhjtLCnSyLFDmzPzKht/mNZOsYuk0UyE53EdNrdgW+zVJaXNNMoVeZpoDPokc1iNFmXCMCVp1B9Kcsq/Ktl/tj0drEgJttJeRByNj+G8fausMaNaTHDi/TGwDAcIc2s/6YxMAQnrf0EOGontfVjMMomhkmkrhqT7gQMvoksJsSL4DgtGD7zL9erKIFdp+MLsa/PPCQiR4u1fR+dx0MPpKOZ2i1zsA244aav+oRTriJpH9qeNlWlnhOa9X0XtgGvN3VahZZbP0GQivVXL7UpniKhuUs37moFJYbm/Zb/aVbzjsK/iNzQo8+doZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mXp9hEvgAhql/qmowNbSIAM8P7cT1c5Vc/bQB0ARNl4=;
 b=X5bDYUXI13DdgKrGKED4OM0eTQBbldfz7QSCXCgVdKzMsU5fEtuyQCY3H3uc3pXF8IZsLhQyTtASmSJtKdh1IQVIUCG2JzLkFiYzoTV8X1vKr989GclXujRzndQj4jKsY1OQLFCVqP1LBJj7dRV0rL0Wy+0IU8Bu9421iVpcDrLIpy38MXI5A5CZ/EmXgS1bdP2SZmAqdFqa0O9si1kU/BdkeQGKtp9Ducu4dV+H07yV9tKVXihPvnHBiuSR+t0JT4TBNZgWn0m09ehaac4FXqmJv4P8E7ChBOFpSXl0CUaCpHO3YH9JD+68LSeiJIqFZI9Y3fbdCaZZHdklsHIYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXp9hEvgAhql/qmowNbSIAM8P7cT1c5Vc/bQB0ARNl4=;
 b=sPl5l0vcW87nymyk6s0iFxGR6yX1Py8GbgtPxg0j1Qi1xZ9inpgED0XXuRlALq6vWSxhNwOoloOiRSsmVvY2IipQwiXRYBb+QRs56z2MTihY/lUroBOoe6j9kQaPGnwDjMOIuOuEYdoyIMhwnFlQvL5VWkNLbJ8bgVVPWP4gpyxZfd4ac5WEXZajA1BA24YOeSDNPjvO4O91NAQuVzL2U18/gK4bm/4McmPQJ5zLL+37v87X/oHGWYXv3Y9EjtfIGHR57Hd90EbIKsMt59Qv4SznTPuDX4CQPVvxiXbd2DxB3hj3f1Yx7UkafwNZtcW3q0lpRPnB42/KRdlPFlRK7g==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH8PR12MB6723.namprd12.prod.outlook.com (2603:10b6:510:1ce::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 12:02:09 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 12:02:09 +0000
Message-ID: <ba054cb5-33f4-478d-8005-799e8dcd7b0c@nvidia.com>
Date: Thu, 25 Sep 2025 22:02:00 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 01/15] mm/zone_device: support large zone device private
 folios
To: David Hildenbrand <david@redhat.com>, Alistair Popple
 <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Oscar Salvador <osalvador@suse.de>,
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
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-2-balbirs@nvidia.com>
 <882D81FA-DA40-4FF9-8192-166DBE1709AF@nvidia.com>
 <9c263334-c0f3-4af0-88a8-8ed19ef6b83d@redhat.com>
 <66A59A5C-B54E-484F-9EB8-E12F6BD1CD03@nvidia.com>
 <lcuuqa3e3txmhb55c5q3s6unugde4hp2wsmvkahgddeicyn2tp@xdx2zqjmd4ol>
 <1b6741fe-20ed-4a47-8e9b-24bd199f23f4@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <1b6741fe-20ed-4a47-8e9b-24bd199f23f4@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:a03:254::16) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH8PR12MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 4661a99a-dfed-4960-22f8-08ddfc2b5a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eE5HR3FvS1hWbmRwRHg3MW5QNXhtc2dCdDl5eEk0RUpaUXNuRlpBMFVsd2tx?=
 =?utf-8?B?dHJaeWptREhyTTRPT3p6eElYczU5NFZyVnFmaThBU3FSTkhZQWZpbWdBdDlk?=
 =?utf-8?B?ZmNpYmg5a2lYWThxWEZ2Y1VXZURsOGxEU0JpU2lTQy94RWNocnllanVTT0c3?=
 =?utf-8?B?WnpTNHdOdEJqZjgrcHJxYzZneGdHMXVXdTI5YWJ2QWtUdkZ3aFVPejF2UHRX?=
 =?utf-8?B?SE81MjdjZ3h6RzZwdmtWNG1QRWFYYTduYUxDbnFxS0NJRElMVlZ3Y2g0dXN4?=
 =?utf-8?B?YTVuR3lQRnE2ak9MQXBkblFqSEpBY2JnNmFzRnFxWEZRb3FHQUw2YnhpajBz?=
 =?utf-8?B?cTI5N3d4ekdSMFQrekMvV2VnWXM5cW1DOTVKWVdaME5YQUpSZmp5Umc4QzJv?=
 =?utf-8?B?dC9HNmwzRExsb0JzWTJKWkVFK2lMNkhqUW5wOWltNDY0VXgrbkRzb2xNWjhO?=
 =?utf-8?B?ckhJQmFQYmhxL216bHZHMlFNRWhSd0hpUmhLajBET3dWY2FTZVRaOXpOc3Ni?=
 =?utf-8?B?SHFQdDZtbXZjb1FraEpwc3Era2hBeDBzU2tWd0RCTHc3dzRvOWF3YUVvdkhZ?=
 =?utf-8?B?bDRHOGloMWZqRUUySm85dng2SGttYjhZK2lDTzY2ZHJvQ0RybWxjcGI3TVE3?=
 =?utf-8?B?Z3Bkc0tqYm0yOXdaZEx4RHRFblgwUG81NEdtTGoxNmZSQnZXUGVjNHVJdHIx?=
 =?utf-8?B?S2F6cVYxREVCcnJBMmZoMUlNcHJmdURoeG44MHQ5RTlEM2h6c24zWk9YOUZ5?=
 =?utf-8?B?NVNKUHUvMnpWZGJreHFlYUE3YUhsZENRWkVHWTBQVDZQcm1tOWM4N3U2WGl2?=
 =?utf-8?B?MTAvUzNRUlkrZnVwMnBMdkZnbERHY3VhUEhlc2pMaklFWjZUSmMzUUtxa0NW?=
 =?utf-8?B?VStUcCsrSHNRYUNQSXIrTXo5T1FvYzFBY052VS9lcC9MSUcrdW9TWndlbUt1?=
 =?utf-8?B?NTA5K1piQ1IzdXhFb2Z5bVRuam1WV1dFdm1CazBpeW54emtmMVIwYWZVN25s?=
 =?utf-8?B?UWhxMnp1b3pJKzlmZVhBVUZNWWtpdGFnSENLUDR5TTZZbm9NNFBqQ3hzNEhJ?=
 =?utf-8?B?SmkxZkVZZEZIZEVodlJaTUdNT2ZYRnZlT3Erc0MzNTQyZ3lXWGNHN2lXUGtz?=
 =?utf-8?B?TzVkc1BzZXFSa2ViUnhWcDBxUzVIQXdQNWxTMXMyVGZIblJvYmFaZ2tKdkt0?=
 =?utf-8?B?YmVFOWJCK292WkkzY1kxZjVTQytEdnZsR0JBbGlnR3hrTEVwcXlKV28vVWlv?=
 =?utf-8?B?OWhSbENrdjVqU1JtNERmTVF4d3EweGo0dVorK0lQQ3pxY0JSQmhJcDcycEx1?=
 =?utf-8?B?OHZVanJXdGZqV0dKQkxVdmtUSVNkWkhKQnEvdjVSdG00UDRiUXNzS3ZMWFpt?=
 =?utf-8?B?S1VDZVpEMFpYT2hnbHNnOUc5VS9rK2hMU3RqbWJpZVlmYWZGVENKU1BzUzhn?=
 =?utf-8?B?NTllbGIxbXdXMGt4SDFhbUdINmgvVzcxbnNOK2lZZThMQ2ZxT0hUZTV0SytX?=
 =?utf-8?B?NHJQQW82Mlo3OGtaZER1aEtOSXRPWmVGdWcwYkFZaUpweGFHNkFkdXpJbnJ5?=
 =?utf-8?B?ZzVjZElFOUp3dTV3amFDYTZwdE0vTkdKOFM3b3d0WjFPZzJEQmo4MERPeWtB?=
 =?utf-8?B?NjBENUV4TThEODV4ZWUreTJXaDZnb013MlhreXBsUUdhbXh1YmhJTjh5Y2lR?=
 =?utf-8?B?YzV0blhkd3Q0R1VFOWZOR1dDYTFCdmJnSnVYYUVyY05vNUpYSmloMTRaRVdk?=
 =?utf-8?B?anZ6dkx6N0JXYWREWGF6WU1aTFYyRlQ3ZkpVVDRZVVNpbkU5cDFOaFNNRFpK?=
 =?utf-8?B?SXlvMGNPbzBlV3QvbWtaODRSdk9Jejc4eUtHbW5GN1ZqeE5DZlVuc1RPQzR5?=
 =?utf-8?B?TjN0WFRWV0N6dVhSRFVya00xNWlIcFp0ZkI1RXB5dGU2VjUyR1hjSkt5WCtR?=
 =?utf-8?Q?3gkUUY0vawc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YXBXc3Vib0k4WC9JRFZ4YkxsdUd6U240TElPbmpUYTIvQkFSTVB1ZkZxbkxU?=
 =?utf-8?B?YUZLcWN5QTIycUxUT3g1b1lMNUpSNlRncWRqKzBQUUpFc1dYNTM0UmlFcU5X?=
 =?utf-8?B?d1FmcEJpRE5VdG5sVWhmZlZnbWFrWXhFc0dsZUpsbnVNdFhjT3N4RkdFVk1V?=
 =?utf-8?B?cFpHS2M2WHRTQmZOVGpGTEhYeGVSYUlTT2JEcDROcFZuU3ViYVFqdVVYaFBr?=
 =?utf-8?B?Uk1IQlVtS2dFT25XUjdraVZGeEdHQnZxZlc5a3BVWHMxUXJFMFFrLzc0WHVs?=
 =?utf-8?B?blNPUitPajBzUGoxVnJjVXIrVVRIY2FrK2NOWkJSRzNJY053SHZTbVdSWTg5?=
 =?utf-8?B?T1puR1ZRREk3NjhHcjNUM3lrYzJOZ2dvRzdjZEpucUt2ekZ5MzlUcUZDMTA2?=
 =?utf-8?B?bVA1amVoY1BwVmdPVHhzeS9RaDRyU3FXaWRxMkptc2hIZWYvclVOKzlQeU1B?=
 =?utf-8?B?VHFZNzFTY1E4ZG85eG41Vk9TT0V1MjNTNWhpTk5EMVN0eWp6TmRXc1dkblJu?=
 =?utf-8?B?bEc3Sm9BMXVSZ1FmL0VVV1NSSHNPT1VTNjFNT3kyZkVySVJuZU5wb2lObE1p?=
 =?utf-8?B?Lzh0bXRnc29rRUFGMjBlZEVmbk5naDV0blhhU2ZwU2NLUjlnY2tnQXVRK2Vk?=
 =?utf-8?B?aU52eldPa1hSMDEzcGRib3EvcXZPR0I5cCt1NFQxeHpUQXIvSStleDFZMExO?=
 =?utf-8?B?L3pLNlBRUXV5QWVZcyt4TUNhKzFNZVRVTHNvUUt0bWZuU0NkK2QvRC91Nmh1?=
 =?utf-8?B?dmRNMzN2d25SbkR6ak94K0pBUjRRcWVzVXcvekt5aUNpN2JISzhRTngyQ05W?=
 =?utf-8?B?MnR0dEUxWlRQbzNBTFVJeEllS0trTnltSnRvLzduRFY5TEthNTJleHRtNnhv?=
 =?utf-8?B?WEpaSC9KbzB3UjBzMkdzWldqUXRQQXk0TjNTMmVkaUt1OGxYUmZIZThhazNW?=
 =?utf-8?B?OGRlQjd0TmpLdEFpMHRpclgyOHljdmFaejBHL1RGSmxXelFFbEpualVoS3Rt?=
 =?utf-8?B?aWZHYnJGVzdtdUJxZG04R0c4Z1hkd2VXazgzWXpYR3dFQ3N6NUhPMEJmcytS?=
 =?utf-8?B?Rm5XdEVsQlk3NjhWQVRha1lWTUpranZKVE5NWmo2QmdqeERPQWtXclhxMU4r?=
 =?utf-8?B?emIxMGt3UUtSdUZudEZ1WkhQNmFNOXRRWndUTkdGL3EwWStxNWRCUSs3QkRy?=
 =?utf-8?B?UWc1eXBqUnZHaXRyUm9WUENuUGtLUmhJVVFKVHpXTXMwOVIyb2xxbmxiT05T?=
 =?utf-8?B?Y3FMUGUzd0JqdHZFNnBobk1UWG8vU0dEei8vYzhPOW8wbjN4UVViQTdRZlJF?=
 =?utf-8?B?eUxXVnBTTldwdVRnNFl2UFZ6ZmwzaXY1QTdhSU9BbWxmRktpemI3aHFvOWc5?=
 =?utf-8?B?VDgxbkF3TjBoYis3KzR4UDg1ek5MdFY0cTNLUXFjSWRmeW0wOE8vWjgwaGc3?=
 =?utf-8?B?eHJ4cjlPZGZ2M1VJQTlQNFJ5OFQ5dnArM3pwRU9OVGlKdzkzMG13TlhCWHY1?=
 =?utf-8?B?aWFBenVXRjQzREcybFp1TmoxcU0reTNlM2RBWUwyQlhybjlkUi9DNDdnZ3J1?=
 =?utf-8?B?UFMxY2RCWUhpVDVlYUtMeHJOZUxZdlUveHZrdlNkMkcvS0dtZWJKa2UybUlL?=
 =?utf-8?B?QkY3SjlYU2VmR3JpQlozUEFIamNIZWdhZHJjRS9JSExSV1N0Vk5rMktnNFNB?=
 =?utf-8?B?eHdjMThhMk14a0QyWE5iU1BsUk5KSHdpa2NUTWFKVFlBWlBVU0FSYzcwLzh4?=
 =?utf-8?B?bmZCRE9rZmEwZlgrU1JwU3VQNEd2WDRmOW0yc3k4MVdPcEJHTWR5YWlsdXI2?=
 =?utf-8?B?R0xUZFk5b1gzdnR2Qkwva0p5dGJQMnd1LzV3ZGxPYWNvNmVNSXhwUGszLzFw?=
 =?utf-8?B?UWh6bHBxL09DWlVOeVlkM0hZNnVyOHRtUXJ6U2FWV0s0elR4Nml4Rk9pVjNT?=
 =?utf-8?B?VUpWZm9aV2VtQkQ3ZGxKRSs3cUxFblo1L09Gdmo5U25hcnBYWm9SaDBBTTU1?=
 =?utf-8?B?dENkLzVWVEk1YjBSYUpUS01tQmd6Z1M3VFcyTmE2QzZyNUErWjd5RHpQa3k0?=
 =?utf-8?B?SkZqazkrTW1vMmlhanBGenFXRXRUeFNkZ2RXTlNSWGFIUjdvTjNsNk4xQXhD?=
 =?utf-8?B?TW1CWWdkSEI4TjNXSVhpQnRUY1lzcDhHYXc2bmY5dTdoNEhLbXhSdk16TUxH?=
 =?utf-8?Q?Rg3G2/qNpIdF3E0AiJnTLr8gvdWiMOQqCzLnt7LXmAqC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4661a99a-dfed-4960-22f8-08ddfc2b5a77
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 12:02:09.1429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFF3MqjUy2FVsMkYmS6CG5eSK/oureFUbzh4DyLNR1aPhP3lEqkBShjrVZXx8aH7C+IJdL+AM2bFx0ZWG9BXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6723
X-Stat-Signature: k83mqjcp8qwnzktnkxpb94yzqqfbbkkz
X-Rspamd-Queue-Id: 6BD5C40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758801733-658680
X-HE-Meta: U2FsdGVkX1/KXYm3AQZzexav+ihJLCbgVJa5kgcGHxlMkgPFLTn33Fk2fmwhQqbG9Lf3RoVABnCvBsAuLATsFSlVnBnxwGHnaj9oW1gqiRTLKG9+zOraB3iElCeW9p9atafx0m27HCS46feYfIV8TOljo0g8UZkChdMa+ZrXgfkECNdd/lXFM7LQeielRU9k/1xlAmVLixbEvUF9ZucXhsyRQWmtJkCanu6C+oZZs626vHFBWEz6sgYKNQmIvrx46D07e4aT3XdotZBh1b/6qXM++Rs4vcI9XPTB8svoQ0NR0KuE8j333+S5VKmIviNPbzdaBOCekTzu9KkEr8GCy3lMdLHqlFl7M1rj5sWqkqdjfjxS9nJ3qFC1oAWQp1qIRC5m+U8WBhS0FwdLNhwgPL/oIOfITnQAQfpO2zFMqlAWKg7lDRf2wIcpYnZxLRCKKvFcs4wD4Z9ODqWZxopuIx/H97smqf+ZdJ8KZAWb/22IakPGwhAHjx0V8ROQlONlSyVY9tUc7/5CSX2cPdo1YnXxWNlofAN7cTlyrH3NlrBij6dRE2QDoefYFeuRc4x16XtTvMn/M879kaQyiypqL5pQS8TJ1bO1hTVQdqNGUBcMrP36kEe0PCEg21FbmCYKaKxbJjtxHvxj9THkqEHoGMtkwU7e9okNdf52lS5/RVvjvYE7aphCmASmiVDeedQYjm3Mtyz6eiSebLVaJXwVBKzAoRMVaCiTYFXmpfVOF5Mf67snTj1G7WULOdEjKrVuXv4ksNrYSmJGPyso9RlQK2VSoYMz3JLMNf4VB2J8I1OPKhuglXg+wvML8hhx47KTx6WeMGRyg2o95ehAoBR8S+tGK2cSssiMEFshf69qIITf/3X3byMLyQ5LpqTsvwTB4fAaH8TJAnT53VVnbc/lSb6ANzyOjNsz53SFOf+ZXonY/K04HEDh3fEPQeOURNkz0UryIYBU1Vf42I3J6Yj
 xYdDIh1C
 OqsaLSD8F1N2WsTs+xkn9nTqOYz/6D1uCsc2OsYpPKOrbEy4byFmD6qTasxRST8z0uOtA2WBoIjVEJa1BwwVvYWa0DnJlIOF2S6GR1GLwMUcKTi6fgiYEpAZddeHiZWX6ATJizKoB87stDM5iDZKGm1xrjlBq5tLL6sApEV3v3daAdnn3psuu+beUfzoKxIH+57At4bvQ3cKc6rECW+Zj1YkOt6p48rpQtUNwqTq1DOwj5rZom/1ILRLX3jttcGk6ZG+4vun6CIAWL8+Y7/G6iqN4NBA3RoF/h9w6UxycY4I3olfZpfbPuAA2jw7AKpVAE+wou8XgBEO6TcxlePXFQXzhYBp7mx8ud6cuo96/Di+/gxO+Ln0Qjfb7meUOtvbeuNBis/+o+esr8ex5xprRTPdayfFsqTGwne7SmAQ/NPeqycO6/MgNoPThdikilP4XLpIfnRsc27UpqSRdIhUdsK5ldGCLwUAT9XHuykgYdl+ddY+LTzdYFyC2KKl40Sc01QWCKS4z34kEMQ5H/LF4V2BaE5nF7UdBMHcWzxSIkVFS9TWcf1S+eLh0VB3YeuaraYbc30Zbm6j30EqZnNxGKhLE0fdnM7o9lFaTHuZ4t35b8QZB8GMMPxr346EM5kxboxmMLkahRRHUQHIE1pI4XdQ/EAyJNzqhWcqyAHiSx9CUmcIG8kv2SVnRvrZSBx8eDKT9A5nv+ecubE/d38yuGQ2nWOG7H1CpXE4HR4BjdofMd1orEkMihdA8JEGHmYvAM7O5ULNCPI4m8gwsfUrEP52nKG10LDlP7WnqeLdOc67rzD/2kRbs1AQquFUDGwB9y4bsxffLKFoj1Ic/AqBUIcOsaYaPwo6YZHFgCOnx1iaZvyb3Sp3wdQqMzmRvILW4hcrQAlBWieOX6LkMjHvNlieKQbjzqjfG/ypf2Is2Q0pyXrWm2hO79jUGfL30cBNSwA83+zXUiWlu7ijCdztYbgWC4kJd
 DC9FmX1h
 C+W/lZjBGt8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 19:43, David Hildenbrand wrote:
> On 25.09.25 01:58, Alistair Popple wrote:
>> On 2025-09-25 at 03:36 +1000, Zi Yan <ziy@nvidia.com> wrote...
>>> On 24 Sep 2025, at 6:55, David Hildenbrand wrote:
>>>
>>>> On 18.09.25 04:49, Zi Yan wrote:
>>>>> On 16 Sep 2025, at 8:21, Balbir Singh wrote:
>>>>>
>>>>>> Add routines to support allocation of large order zone device folios
>>>>>> and helper functions for zone device folios, to check if a folio is
>>>>>> device private and helpers for setting zone device data.
>>>>>>
>>>>>> When large folios are used, the existing page_free() callback in
>>>>>> pgmap is called when the folio is freed, this is true for both
>>>>>> PAGE_SIZE and higher order pages.
>>>>>>
>>>>>> Zone device private large folios do not support deferred split and
>>>>>> scan like normal THP folios.
>>>>>>
>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>> ---
>>>>>>    include/linux/memremap.h | 10 +++++++++-
>>>>>>    mm/memremap.c            | 34 +++++++++++++++++++++-------------
>>>>>>    mm/rmap.c                |  6 +++++-
>>>>>>    3 files changed, 35 insertions(+), 15 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>>> index e5951ba12a28..9c20327c2be5 100644
>>>>>> --- a/include/linux/memremap.h
>>>>>> +++ b/include/linux/memremap.h
>>>>>> @@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *page)
>>>>>>    }
>>>>>>
>>>>>>    #ifdef CONFIG_ZONE_DEVICE
>>>>>> -void zone_device_page_init(struct page *page);
>>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order);
>>>>>>    void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>>>>>>    void memunmap_pages(struct dev_pagemap *pgmap);
>>>>>>    void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>>>>>> @@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
>>>>>>    bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
>>>>>>
>>>>>>    unsigned long memremap_compat_align(void);
>>>>>> +
>>>>>> +static inline void zone_device_page_init(struct page *page)
>>>>>> +{
>>>>>> +    struct folio *folio = page_folio(page);
>>>>>> +
>>>>>> +    zone_device_folio_init(folio, 0);
>>>>>
>>>>> I assume it is for legacy code, where only non-compound page exists?
>>>>>
>>>>> It seems that you assume @page is always order-0, but there is no check
>>>>> for it. Adding VM_WARN_ON_ONCE_FOLIO(folio_order(folio) != 0, folio)
>>>>> above it would be useful to detect misuse.
>>>>>
>>>>>> +}
>>>>>> +
>>>>>>    #else
>>>>>>    static inline void *devm_memremap_pages(struct device *dev,
>>>>>>            struct dev_pagemap *pgmap)
>>>>>> diff --git a/mm/memremap.c b/mm/memremap.c
>>>>>> index 46cb1b0b6f72..a8481ebf94cc 100644
>>>>>> --- a/mm/memremap.c
>>>>>> +++ b/mm/memremap.c
>>>>>> @@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>>>>>>    void free_zone_device_folio(struct folio *folio)
>>>>>>    {
>>>>>>        struct dev_pagemap *pgmap = folio->pgmap;
>>>>>> +    unsigned long nr = folio_nr_pages(folio);
>>>>>> +    int i;
>>>>>>
>>>>>>        if (WARN_ON_ONCE(!pgmap))
>>>>>>            return;
>>>>>>
>>>>>>        mem_cgroup_uncharge(folio);
>>>>>>
>>>>>> -    /*
>>>>>> -     * Note: we don't expect anonymous compound pages yet. Once supported
>>>>>> -     * and we could PTE-map them similar to THP, we'd have to clear
>>>>>> -     * PG_anon_exclusive on all tail pages.
>>>>>> -     */
>>>>>>        if (folio_test_anon(folio)) {
>>>>>> -        VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
>>>>>> -        __ClearPageAnonExclusive(folio_page(folio, 0));
>>>>>> +        for (i = 0; i < nr; i++)
>>>>>> +            __ClearPageAnonExclusive(folio_page(folio, i));
>>>>>> +    } else {
>>>>>> +        VM_WARN_ON_ONCE(folio_test_large(folio));
>>>>>>        }
>>>>>>
>>>>>>        /*
>>>>>> @@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
>>>>>>        case MEMORY_DEVICE_COHERENT:
>>>>>>            if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>>>>>>                break;
>>>>>> -        pgmap->ops->page_free(folio_page(folio, 0));
>>>>>> -        put_dev_pagemap(pgmap);
>>>>>> +        pgmap->ops->page_free(&folio->page);
>>>>>> +        percpu_ref_put_many(&folio->pgmap->ref, nr);
>>>>>>            break;
>>>>>>
>>>>>>        case MEMORY_DEVICE_GENERIC:
>>>>>> @@ -480,14 +479,23 @@ void free_zone_device_folio(struct folio *folio)
>>>>>>        }
>>>>>>    }
>>>>>>
>>>>>> -void zone_device_page_init(struct page *page)
>>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order)
>>>>>>    {
>>>>>> +    struct page *page = folio_page(folio, 0);
>>>>>
>>>>> It is strange to see a folio is converted back to page in
>>>>> a function called zone_device_folio_init().
>>>>>
>>>>>> +
>>>>>> +    VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>>> +
>>>>>>        /*
>>>>>>         * Drivers shouldn't be allocating pages after calling
>>>>>>         * memunmap_pages().
>>>>>>         */
>>>>>> -    WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
>>>>>> -    set_page_count(page, 1);
>>>>>> +    WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
>>>>>> +    folio_set_count(folio, 1);
>>>>>>        lock_page(page);
>>>>>> +
>>>>>> +    if (order > 1) {
>>>>>> +        prep_compound_page(page, order);
>>>>>> +        folio_set_large_rmappable(folio);
>>>>>> +    }
>>>>>
>>>>> OK, so basically, @folio is not a compound page yet when zone_device_folio_init()
>>>>> is called.
>>>>>
>>>>> I feel that your zone_device_page_init() and zone_device_folio_init()
>>>>> implementations are inverse. They should follow the same pattern
>>>>> as __alloc_pages_noprof() and __folio_alloc_noprof(), where
>>>>> zone_device_page_init() does the actual initialization and
>>>>> zone_device_folio_init() just convert a page to folio.
>>>>>
>>>>> Something like:
>>>>>
>>>>> void zone_device_page_init(struct page *page, unsigned int order)
>>>>> {
>>>>>     VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>>
>>>>>     /*
>>>>>      * Drivers shouldn't be allocating pages after calling
>>>>>      * memunmap_pages().
>>>>>      */
>>>>>
>>>>>       WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
>>>>>     
>>>>>     /*
>>>>>      * anonymous folio does not support order-1, high order file-backed folio
>>>>>      * is not supported at all.
>>>>>      */
>>>>>     VM_WARN_ON_ONCE(order == 1);
>>>>>
>>>>>     if (order > 1)
>>>>>         prep_compound_page(page, order);
>>>>>
>>>>>     /* page has to be compound head here */
>>>>>     set_page_count(page, 1);
>>>>>     lock_page(page);
>>>>> }
>>>>>
>>>>> void zone_device_folio_init(struct folio *folio, unsigned int order)
>>>>> {
>>>>>     struct page *page = folio_page(folio, 0);
>>>>>
>>>>>     zone_device_page_init(page, order);
>>>>>     page_rmappable_folio(page);
>>>>> }
>>>>>
>>>>> Or
>>>>>
>>>>> struct folio *zone_device_folio_init(struct page *page, unsigned int order)
>>>>> {
>>>>>     zone_device_page_init(page, order);
>>>>>     return page_rmappable_folio(page);
>>>>> }
>>>>
>>>> I think the problem is that it will all be weird once we dynamically allocate "struct folio".
>>>>
>>>> I have not yet a clear understanding on how that would really work.
>>>>
>>>> For example, should it be pgmap->ops->page_folio() ?
>>>>
>>>> Who allocates the folio? Do we allocate all order-0 folios initially, to then merge them when constructing large folios? How do we manage the "struct folio" during such merging splitting?
>>>
>>> Right. Either we would waste memory by simply concatenating all “struct folio”
>>> and putting paddings at the end, or we would free tail “struct folio” first,
>>> then allocate tail “struct page”. Both are painful and do not match core mm’s
>>> memdesc pattern, where “struct folio” is allocated when caller is asking
>>> for a folio. If “struct folio” is always allocated, there is no difference
>>> between “struct folio” and “struct page”.
>>
>> As mentioned in my other reply I need to investigate this some more, but I
>> don't think we _need_ to always allocate folios (or pages for that matter).
>> The ZONE_DEVICE code just uses folios/pages for interacting with the core mm,
>> not for managing the device memory itself, so we should be able to make it more
>> closely match the memdesc pattern. It's just I'm still a bit unsure what that
>> pattern will actually look like.
> 
> I think one reason might be that in contrast to ordinary pages, zone-device memory is only ever used to be used for folios, right?
> 
> Would there be a user that just allocates pages and not wants a folio associated with it?
> 

A non-THP aware driver use case would be a potential use case for zero order folios (also pages at the moment). 

> It's a good question of that would look like when we have dynamically allocated struct folio ...

I think for dynamically allocated folios we could probably do away with pages, but not 100% sure at the moment.

> 
>>
>>>>
>>>> With that in mind, I don't really know what the proper interface should be today.
>>>>
>>>>
>>>> zone_device_folio_init(struct page *page, unsigned int order)
>>>>
>>>> looks cleaner, agreed.
>>
>> Agreed.
>>
>>>>>
>>>>>
>>>>> Then, it comes to free_zone_device_folio() above,
>>>>> I feel that pgmap->ops->page_free() should take an additional order
>>>>> parameter to free a compound page like free_frozen_pages().
>>
>> Where would the order parameter come from? Presumably
>> folio_order(compound_head(page)) in which case shouldn't the op actually just be
>> pgmap->ops->folio_free()?
> 
> Yeah, that's also what I thought.
> 

Balbir

