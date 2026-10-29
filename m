Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 640CC606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=E24w5rDJ
Received: by kanga.kvack.org (Postfix)
	id 785D76B05BC; Wed, 28 Oct 2026 23:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735EB6B05BD; Wed, 28 Oct 2026 23:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD7A6B05BE; Wed, 28 Oct 2026 23:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 380CB6B05BC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:00:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3D4BC02B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:00:55 +0000 (UTC)
X-FDA: 85374161670.09.C5B4503
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9D164000F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:00:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E24w5rDJ;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793242852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uFJpG7TccakKvQrmjtVFkUtgC0R44/OJ46skeKOwvLI=;
	b=pT1nOnvO5iGrL7pnb8mns7zLMt0oDhYSVHov1t/SgceFWc2D4BKJI1sDj/1CEXEbLNuzpY
	AN2i06z+s9FRP17WwgE4+/JPKCbAnS70uu2Pb8ozk59j9bF5ozaUAFPw4RIndwHLm5TtoI
	AIanX7NTtVrk3TGObc3SHazhmNMJ/2s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793242852;
	b=xU9xXDolELZ1Sa5cs5MSujGQQwXrGh3cAPVoI9wPM5JiPFBrHd7gn8H8lek+CciqAq0FV2
	EG0Hl0doDByM4BAtFwiMQ2AGT1RNheU+hppLY++72a/z2BuIyz/8fxLyD+y22mQhjudrDr
	bwy9i5AtyTZcIgBS60tSfRq0iGKNh8M=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E24w5rDJ;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUrshiwj/nQakDj8oCw+KMhpatGjbbOrfbX80UzHLbEn3qPIyjadSdTDNfvvq6VuV/+JalvFjd02Zoc1YMLfBfudtTsTqzs3vBkI4grbBgkmfoc+xe7O97Bjbqb0GnUMZ7Ew5jOqsqfp+9MEwQZWr5KpX8coMxeGBbXwo0Ora6czXxTjJoAJxM0OQli8GPHZZOzQ9EdXs9YPsFlKROx/XW+btiymJXqy5E2kT9XlvXwiR3b3Z2SwS/0EIEru7ZvDpQDp58GBYCAJflG6HL5b059r7WGN1X3DDfDbTJDqXNEtMYybCUa3D5yrrex+mCEu76Tyf7kxpMJ6XNEmujj5Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFJpG7TccakKvQrmjtVFkUtgC0R44/OJ46skeKOwvLI=;
 b=HMTIXNziFOFm1l9a5Wbwsq62zSevKcV3lB1b2Ulg64hVRzC/pFLM684z1Oi3spvAo6+U+vsa+YPrOzlRklBGPWL8r2Ne2+InSq8E3fW9AABP+eW6fCvspHjIMCq/XliRLDURhbbmWlunuilT8iIneE4Iu51G8irsAfk/ACWdp73JE/2/AmxLWHBHv4NvPq7m7yM01eaHS5tPQAAfrFKASGJbR8nPQgHZE5PQo5XUUvOjzuRFGsCIjn7Aw7Tsq4eugRlkAdEHxWFc1D/9xSAS25YwxOUWoIcG+JnKYIWIDCRNj6qw3EHCJ/DE10IexZlDIVOwmdYHYdvXA+NW6v1sCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFJpG7TccakKvQrmjtVFkUtgC0R44/OJ46skeKOwvLI=;
 b=E24w5rDJ2p8bDy9lOLRItODKyI4R+a25Z6O74W8M7kH+6lraizBeGuU6f0h+S8Vl5Ni1SGsZV+efKDUp9DOY9r7LaUBHDWvvhCZtWG0CSHD8EjCcprlNlDGfWJNc3yM7IOSdpahpT5tCfILusyBTURWyEbMSy6b8IgK6l2wJvlTtZi+xIjz1gq7AhyBwM16ezZWUaDPra31OSD02svu4xXcJyEQtgUgvUEXEwSvjTTKjEZSlBBfwPlFMw8kXXM/dC5GUAaH+2FS3JQvA/6E0s74A757SccF9aDoRXEvV1a+S9eSBvq0F7cK3jsMrALJQJlF0Gk8jskodhqnc37Dhxw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB5782.namprd12.prod.outlook.com (2603:10b6:510:1d1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.8; Thu, 29 Oct
 2026 03:00:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Thu, 29 Oct 2026
 03:00:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 23:00:42 -0400
Message-Id: <DMGZJ921Z264.1GCMO7EYVWIG0@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-arch@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
 <stable@vger.kernel.org>, "Josef Bacik" <josef@toxicpanda.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He"
 <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Kees
 Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Hugh
 Dickins" <hughd@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Lance Yang"
 <lance.yang@linux.dev>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau"
 <kas@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "John Hubbard"
 <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Will Deacon"
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, "Nick
 Piggin" <npiggin@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Minchan
 Kim" <minchan@kernel.org>, "Muchun Song" <muchun.song@linux.dev>, "Xu Xin"
 <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Chris Li"
 <chrisl@kernel.org>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat Pham"
 <nphamcs@gmail.com>, "Youngjun Park" <youngjun.park@lge.com>, "Gregory
 Price" <gourry@gourry.net>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 05/46] mm/truncate: look again if a folio left the
 mapping
X-Mailer: aerc 0.22.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0329.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB5782:EE_
X-MS-Office365-Filtering-Correlation-Id: c9465010-dfc0-4a3f-11b1-08df3568d416
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|261028144727099003|4143699003|56012099006|11063799006|261009223027099003|261022105027099003|261021121427099003|261021123027099003|261026140227099003|10067099003|261026121527099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	k0y6vLy0ku3Bu+dQ8KaZ+myKKht2W0DEoIDG8U/sOGxN+FPl4a0w43Uzwi+Mk+7lzZfakvzW+vF5pD3/TO/GqhQdAvZcwXCFiBmImKUP4EkHhCH/YmQ85TPqTNnaT5+4j8JtRa928v+yOt+kxwgiNIcSc7Fq4NtNYHXzy13Wcg6oRNJoyN3+qWuQ+G6bMKWvxs12Br0UAqsw3JNIUkT2ung1IVpapVc9HhAycQCdoZIOpZHdHWaFYxgHCwHYPZjko71RtfIUMDhR3cZOHfzJOygkj3/WKspV0lcTJALuq243CN8/GPiP04fJdWpiaHchBFU0UPVR6P9hNA6cQrhZyvdOzXLHVwUNqDcNjMa5zM0qJRd7pL8eFGV8YEmoNmBUEkZ9TgvDk3gktrgcYnhWe87Q7bfcGmutC4/OEqWz4XbUqsGfaBq6v0BBl68iOd9LpXITqNUzdcGIuxAJoWAdq55gPSjTRESFPynTsDMEkXfl6aW3ToJcBtQR+w8xnZtF/YDKgCyjPQFLOyHVSd8U25DbfyjcpZK2/FTI7+aAmlINm2+xhBy0XhiRvNZtZBznpzJt7gPLGX6XPIvyqTkGcPbHWMg3PW66fdzGGJhnyOv7Rr763dW1OQHepV7MXu8hzjBaOVqDjtCH2Q5Us76cGhszxtMTTKRunlGVUwBwDUfycEuczfh2xrGXxCo6NAvAHGVejB1DPpb5wrVqdXUJ5Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(261028144727099003)(4143699003)(56012099006)(11063799006)(261009223027099003)(261022105027099003)(261021121427099003)(261021123027099003)(261026140227099003)(10067099003)(261026121527099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aTEySDZ3dDQzOURlck5CdzEyQlBQS2dMUks0Q0U4OVJkRjlkMEZwMTR5K3Nr?=
 =?utf-8?B?NmNJYzI2emZMQmpNOThMNTBIR1Q5TTZKREFYaUtXbVdUL0lodEtkbmQvVjNl?=
 =?utf-8?B?U0NpZzZ0RWNiR0psWXdVNHowUFFFU1hGTm9PTW5meGFxa1cya2lsWkZvLzlF?=
 =?utf-8?B?ZzBzOVE0T3FIY0svM3c0azh3YllwZHdYTUU2NG1yTWlyZDhiQVAvZi92amJ0?=
 =?utf-8?B?ekhSOEM5dUY1OTZoRXhQNktsbEtObUFmMzlwWkQyZngzUmFrdm5OejBiWjRX?=
 =?utf-8?B?bzFFaXpWWC9KNldDcmZEREh3V1V5ekRJYzc3Zk1DZzRtU09Da0ZEZE1aSGF1?=
 =?utf-8?B?bEMrNC91QXBzZ3JycHpzbUcyTm40Q0hhWEZjSTlpc3QzMFlobGk0amZTdWVz?=
 =?utf-8?B?NktHVlBwZzE3d1UxRndjaWc2cndBMGZiSGhkdXJKcTJ2QmNPTzZmWjJodWZC?=
 =?utf-8?B?WHl4TURHek5ZUE9sKzdUR3RhR2I5ck1XVytCY2tkS2p6cG1leXN6RDBvWGQ4?=
 =?utf-8?B?VGE0bVNWYUlpcm1WK2ZlTHBsbkhUejhBdlBqNGF3ekhQZEdMaWg1aWdPLzd1?=
 =?utf-8?B?L2hJNmVpRW4vYWNMRHB3ZlV5UlJ1dEUrVXFFdFJDL0h3YjhSaktYZ3Budm1F?=
 =?utf-8?B?ZzFZeEJEY3N6YmVXUWZMK2ZSQ25pK0xmaHpleldoOW5wb3pEZVNPeVYzcHhQ?=
 =?utf-8?B?aXF6YkgyZi9Sb0JCTWxIR2UwMC8vTXRtbjA3WDlibkovQW40cFBzZFdwdFA4?=
 =?utf-8?B?WVlqMDRMMnFrd1pyYklLdE4vN0tRZTk0YW4xNTltTW5FRVk5RDZraWZNMmRs?=
 =?utf-8?B?eXVzeTJDZkR5bWxCQkExdUxXeVBpbS93M0RpMkFCaGg4NlhHRDRseFNrNmNk?=
 =?utf-8?B?MVZPV0o4Z2dIcFRkT21NUWo4cHBybkJJWDQ1NUhSTFZWQ2ZDbnVHUDZCQkdi?=
 =?utf-8?B?YkZGQ09nV2pTWURYL1pqMmlYL0Y1TGt3clBmWmFLMmk1K0J3Q2JHeUFNb2dt?=
 =?utf-8?B?RWtpZ3VSeDAxT1NiY2Q0NkQ1aFRSUG4zdW9iNUFYN0xJZlNwRGU0Um9SU2lD?=
 =?utf-8?B?eExzdGFIL2ErM0NHdkt6ZzVyUzg4T0IvekplSml2YzlEZjJCM3FWRXhvVFJP?=
 =?utf-8?B?LzlGeUx3cGdLL0ZCM3BnWHRKMVUzTHA4ck5wQzdENVlHU3lvSlNVM1JRS0du?=
 =?utf-8?B?REtWSGdsdzJ5OGk5aS9CR1FkMFJnc3lIWXhwMCtJak5WZi9HOEljeTZCU2sr?=
 =?utf-8?B?NWtWanhnNnhmTjR2bThzN3ZMSFlHVDFWS2FxejBYSVkxWjBFRzBkM0Y5cGZW?=
 =?utf-8?B?YnNHNFdqc1lBdnR5aTJIaGg5RFhab3B0TVhQbittUnhObGtCdHdIUVRYN0Iy?=
 =?utf-8?B?NEMvVkp4VDRZQmFFT2l3UnNYMXVLejlTeEtQZjRLanZ0cExuU0QrQTQ1eUxB?=
 =?utf-8?B?bTlaRzJpZ3RJNTdpcFByb05sa3ltdUFqcVNPRlh5VmJscDU4cUZzczJPRExh?=
 =?utf-8?B?NzV0WS9PQmpMTlRjU3IxTW5BdExxdWlESlNzUExwQUFIVVZLblZLaXI1U2Jh?=
 =?utf-8?B?c2JVdlovU0V0QlIwTFpDZWtIcmtqanpwYnVEUlZER1lPSmx1OHZTcC91dTdB?=
 =?utf-8?B?TUpOSU04OFpScVVQTnpXTHRZaW1qZ3JNb0hUbzMwZ1lkVGJkM2hHVTM3ejBo?=
 =?utf-8?B?VStDNDQ0S2I3cnZXNEEvR3h0OWVlc3ZsbjB5b0k1ZUFYSzFFVC9RUTc2S0Nw?=
 =?utf-8?B?YWcySlBGNHh0dDFIWUZQVlY4YUt5dUpQcmZUWDd3eGtQK2lVb0pHOTFCam05?=
 =?utf-8?B?eXdkZ1UzR2ZOYUJPQ0FDSWZ0ZmdyV1lFRmlQWTJZd2UycVdsaE9KSDhhUmE0?=
 =?utf-8?B?MUFJdXN5N1pnbzNOaGY1UVVvYVlheFBUZmpPMmtrYWZaSjNoMmVXYWlxVkRa?=
 =?utf-8?B?OFRnR2hvMm9QMlBhNCtKVEduNXdkZ1MrVEJGYmJPdnhLZWlGMkZabXo5ZzBF?=
 =?utf-8?B?SVdFWVV2dGJQNTZPRFdPL0R6cnlZQzc2Z212bEQ4dHNqVFBwTDZyVlhrWkxr?=
 =?utf-8?B?Q0s0aTJUY3V2T0QrK1VoUXJTRnBsdXFYRE93elFkREFhb2ozN2JDZ213Wi9i?=
 =?utf-8?B?d3RFSTJKNm5nZzQ0bk0wVTZTNHhtSmhGTTVwYkxKdzFudml5Y1VySlMvZTVQ?=
 =?utf-8?B?RlF6QksxUDhQOUNMVkx0bVBvanJrVDVrRFhzNjdOeDFEdlB5Y0kySXBTaDNC?=
 =?utf-8?B?UlhJVzJ5aW5hd2ZQQTlwdWxVUHdXNVFZSDVxT2dQMGNlWEcwbGp1a3NESGpX?=
 =?utf-8?Q?73k3Sbp2byV03imYQ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9465010-dfc0-4a3f-11b1-08df3568d416
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2026 03:00:46.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQMbL1UH/7g80U7gDIJN0XBH45mu3jkSmYgT/Q65hUhYrx5pFcndQlg1X/Tq6Kbq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5782
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C9D164000F
X-Stat-Signature: 8z149kb3hjqfof9btfqem8pxcy31q3w9
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793242852-910355
X-HE-Meta: U2FsdGVkX18KSLAGVhi36XD8F+HyAXZl/ciibRNcVDDBpNbt94nAk4FoNzSAPXrC4+D4dSKZEKQ7uuT+3D5G11X5+CM1l/3aKp/ZC0leE6UjFHfP7IQ1qcIyIym1HTNl33znZe5zbi4rTUZwOTm9UcNYl+D/+MffY0cjUgVRjCccoeFz8iHwiIMW1DNyFw/f76IMZF1cWPLuds+8LYX1Gr26Q5ynLJ81sckuZbszMV2pXmLzPVQIKAbSIev9ccBMa7ENedchf/8SAUyo0Agmr5GeH+ItetgZQIjNHK53jjDfGVJynsdmq2AALARghhTqlJvw4z4K/0A2PpjCrwWez7st6DfvANWFxbjHmqsnVk0hwJIQlopr3/pjJGjao+/SkK4tQ4OhxtT3qg09/b/bkup+2Tmq0NNwCD8O9Bi60ks+ImVyUPq3ZAVM6mdI23mdCPh1EfEsVH73vybtpmSVauC+1PaS+VIO05AkRdpp+4ZxL+OT8JBGjqUhsrt3S9pkhX1tiYpiChh6g5+nPqP8p+gTv4dbPARL9m7cUU51C2wRFPkULQiMvyx8ZWjoMdUcIF2xvI1xFoYke2YlYbC4SDwIpWJiHUn45KJ+DzwEsE8CVpqshV5nj3fnMtt5eXwoJpesIrK6+noz+cptCFq/zsKIJ6SeOCFVWr1tFBWvUJwPDMNmZN6El0ELHMxHHBAPwOUvd+XWnSnCz8CR49neoHx+QHvV7dEjx1NBnM7GANXB2Vp9sZOl3mI/TqJbs/Cg3ssemV2KQgRyh/rRAWoUHruEsyKE3mVbxa1eKKiJJ4lbRDQcnz+rYk3J3FzzBafm0U9K43jz10F8OwcuXCh/KRfbdIGxXtGS8c+0Z63xIWSS2/7u9HVVNwGqrMsiFjy5uMI5v3wh74ynZ3akYVSw3N5W2IGxZ3gr9NlGxtxmt08J8nHDcAYuixEBHulqO1WymjSG3QHa7qYcwVpT+HS
 /XqjKCQS
 H8mmopblULCto4L6qhAe/nGwkiB30KD7eQv5YC5Sp50tDX9mHddZQiMIHhl2zNgSX87eVHGmMp6/q9CWYShjt2jCXb89Gg4gEfH2mbbk2QiIxfKYheNP8iyeKUE041hgn5P764HDivPj29S8lT42U/cDmTZ4qagvijKAR5mDAKVh7DV20teQDUBVxXmQ+B1NzbKBqmAmzXy5Q1lP3zENh8512SyrIRZGRaRMnU7ZT4h5+L1Al3mO0TMyTNBoboKXRfPm45jQ/nUbvpPtU0lX86ILOER/w+JryJLYVeUR3JtZ+CpnNO4itEjwo225CUp0eCiOIp6eNjGe5NTUyrFn4qZrOYPS7IbMsS9AriUwl2ATUkz254xpp7WdXlu2RH2Fe9R4V+RwYQk4ioGdhjZH/y16kiRaGl2YyCi76wyL4+KsQN6cAmKEWZZ61pHJQrDp4Swg/8n3RsuAnETno4faPri6gDk1ZAwa6AeK9+57h6kTtj9m2dYe0YQVERGt8n66EjP8x7113r3M7QemLrQEj+9++fl+IwyzYx8UakY25fhq0Dz0Y0hs31XCKfHKaE5A4Se06PHmpD13sXIM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Oct 26, 2026 at 7:17 PM EDT, David Hildenbrand (Arm) wrote:
> invalidate_inode_pages2_range() skips a folio which no longer belongs to
> the mapping by the time it has got the folio lock, on the assumption
> that somebody else has removed it from the page cache. But the folio may
> have been replaced, and then there is a new folio with the same data at
> that index.
>
> For most cases, like folio migration, that is impossible. However,
> collapse_file() only checks the refcount of the old folios, under the
> i_pages lock, and relies on their folio locks from there on. That works f=
or
> users which repeat the lookup when they find folio->mapping changed.
> The following scenario is, however, possible:
>
>   CPU0 pwrite(O_DIRECT)               CPU1 collapse_file()
>   kiocb_invalidate_pages()
>                                       read the folio (old data), lock it
>                                       refcount check
>   the write completes                 copy to new_folio
>   kiocb_invalidate_post_direct_write()
>     find_get_entries() -> old folio
>     folio_lock() ...                  xas_store(new_folio)
>                                       folio->mapping =3D NULL
>                                       folio_unlock(folio)
>     folio->mapping !=3D mapping
>       -> continue
>
> In that scenario, the collapsed folio with the data from before the write
> stays in the page cache after the write has returned.
>
> This used to be impossible, as khugepaged only collapsed files that nobod=
y
> had open for writing.
>
> Restart the lookup at that index, like shmem_undo_range() does. The same
> problem seems to exist in truncate_inode_pages_range() as well when
> truncate_inode_folio() fails, so handle it there as well.
>
> Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio collaps=
e for writable files")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/truncate.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


