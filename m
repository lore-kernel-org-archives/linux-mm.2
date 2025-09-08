Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC9FCA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 00:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7857D8E0003; Sun,  7 Sep 2025 20:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D388E0001; Sun,  7 Sep 2025 20:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64C138E0003; Sun,  7 Sep 2025 20:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 500F48E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 20:05:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 071101A0891
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:05:18 +0000 (UTC)
X-FDA: 83864138316.21.6B29C47
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 31DA21C0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:05:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kfDpbnV6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757289915; a=rsa-sha256;
	cv=pass;
	b=hKBOQ8v8gGycHN+sik0F+IBhmSczK+125Rxgbnw/MoJtDMOo+UupNBzlCikjtvwat48BBW
	giFZYgB8Tb0Cai3TtMW8CpoSLUZxRzSLirifiEj0HSSpigbZZg1yLxiY747iwvN581ii0f
	GOzLbI+ZOvHz2aFvi/FvRQpQXu9ahWI=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kfDpbnV6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.51 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757289915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtSGYdQ9cPDGmEq4xrPFd/0tHBsKpqGBMYzd/i6eLT8=;
	b=0hHhVxu4DkMh4OpKaBbRlfs9WoKGxrJepsn8OrTAvNfBnarBixW5JzvDna1J9x0xYFlCac
	Z8zunvxaRGHK9N4/7UF5NwjQpVH+sRfQ6o+kWFgbW+FzouQCrLKIZwXjEqxhwMfzkkLYzj
	G/NB7nVlBpBs2sTwrg5Ax0d41V2o/MM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVmc+bl5z6poRYwLGoSjaoQTFyom6q991tPJinuuL7PlFttnCERQq7CLiilrc8eeG/KlS2UJswt8dFgKeJhVxd3QxX7h3n6E973rdxQ7Rwzi1xaKpxGEdddhYwdVkim2YF49hme47bkMH+fd6X2fMwAmwDdsmAZWKh7lwJ6mIR82QZXVy7LooMiliHkU9mKqKqLpPAa9cbYVAhXqJchmoLnVPNhH6liG/zDjMNWK8v/rfDF3t/RTass6G5jguT/aZSt5kbxhd5AXt+pjK00wWUY+R5Yt2+C+IGjsNrJ9mQ62wJ/vQgOjnQnP1ANudsEoxOFptqYZOhd7x4sZVTnLDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtSGYdQ9cPDGmEq4xrPFd/0tHBsKpqGBMYzd/i6eLT8=;
 b=dtwqCkuMeK4lpIEJ7U+dTNq52SXwABhXYKK+vtBAWoMujgovGF1bbG+IDEDvoyUXYl4rsF5oHRmZfkEtHZCH7NkTpUA+3Qy1AXmjsjTbj/SUQqqSsuAKjaQz8iMTwxa++09JiHsrfsG1LZmv12pzq/ZmfJA/18SBsVJeNt2lzo/oyp8qlIDUtPk+trYbOQLdngZmRDscJUbKtz5bV2FfDazvbsaumo/zTqFGSskuFY608kRXQ1S6BAjon9rjJxyuNKmFzzhDBZI9THOWC4J74svHF9zjKYN396xPSlGfq6vllyncsldHnL7co82wG6e6aVIfTE3rTuD71wUlAVPdTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rtSGYdQ9cPDGmEq4xrPFd/0tHBsKpqGBMYzd/i6eLT8=;
 b=kfDpbnV6dI6+UdqsZLExHXT7uznUF5JICYxcApTJQmIGEudVNbc3ZUwgf7xhR/1h5+90llY7uKeNJdEfaKlXaC0qE/7cle26EiVObRtr1/ho9Wr0fkCWzATD4XNNGmGgz1OsPXwI29Djg/r4gNnMPEZumziuJCvhboopgS0WLtIYmjdZYQ9RSRcxpFKZXytblZePMPH5CgKKgJerDHLy4KvFDS9VnBWqZq9OqRGd08hnYxHmL180gi7hLpBWdbSHeLUmxP5RyTAJ5HurOm3FHfOLWZa4wp1Dngukph7dgfxB5xZsPBivkhXVOmQ2ZjzpcQz48YMg2O4OH8E5RKsHmQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Mon, 8 Sep 2025 00:05:08 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 00:05:08 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	Balbir Singh <balbirs@nvidia.com>,
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
Subject: [v5 02/15] mm/huge_memory: add device-private THP support to PMD operations
Date: Mon,  8 Sep 2025 10:04:35 +1000
Message-ID: <20250908000448.180088-3-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908000448.180088-1-balbirs@nvidia.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:40::18) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: cf8ff8e7-2f3d-49da-bc92-08ddee6b5f27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkhQVTZsTWJ3bGxyVTJFdWo5UVhxdVRDN096cEhqWHQ4K01tNXZVWnFJU1ds?=
 =?utf-8?B?YnN2RS9mbWtNSE9mWWNwM1hiSVN0VzhKczNVU3RDcXFqZE4vbWxpZXBvVWlN?=
 =?utf-8?B?U0wxeFZodmx5Z2sranI2SVVhYlhGVlRPTEtHUWJ2QklYYkRZVHNTeVg5NG5w?=
 =?utf-8?B?bEdKZ3BsSk9NMTdsWExQZGdEWjhGK0pLYUVEdWNDRWNoZWVYS3lBeVZPL3BY?=
 =?utf-8?B?dXVEazVkaHlibTlYMEorcjFQODZ4OGg3STdzb29EWWJmQklyM2dWN0FNL0xq?=
 =?utf-8?B?Z0ZCbHR2RDJmWG45bU9kTmkzeGtMYUdWdFVKRTU2YkJQTXZqVURqaHUzZGFV?=
 =?utf-8?B?eXNNcGZkckZ1S2lDb2FXTlk4SkVLZ2gyZ0Z0VUNjRHFHeEtTWlpOejlJSlpS?=
 =?utf-8?B?VzBzUkF0RlNTRjRHelFOblM2eGdsRGQ3cTdSM1J3SWF5TTFHaFRrNURZcy9q?=
 =?utf-8?B?bGdOZWMydmZGOVBiWlQ2a2gvOXBaR3BYVENhN3JzN1NiKzRKU0xtS3JCWU1H?=
 =?utf-8?B?bEZmbEY2YkJJME1VNHVwNGRwRUVjOHl1RTF3eGQrVy9idDV1Q2hSU1lMS0Iy?=
 =?utf-8?B?YXMyVDRsRncwdmtYRHdVOWZXUU1qczYzeDJtMzk2YkxMYk5uQW85aW00eXFZ?=
 =?utf-8?B?REdQOXg3MFdzdmhsU1IrNjkrNklDUWtpV3pkbEhLK2k0WHJxVm8vVFUrbVdm?=
 =?utf-8?B?dUkxdG5uVS9vTWJYMU9OYnFBeXhTaEcvaUVFQyszMkZkMThkU0VsekZ0MjZF?=
 =?utf-8?B?NWx4OE1EMGVvM2ZUWlQ3Ny9ZL2MrUjBhcWdyN2pLcStsaU43Y1J6V1FvMytW?=
 =?utf-8?B?RDk3cndPeTAzc0JESkQ1VmdsR3FJTmFqRDVUN2hpRC9HS25mc0Jnd284eEVK?=
 =?utf-8?B?U3QzZlJxR3ZKbi95emg2UjB1eUZnMmZ2OGZLMXJVcHJ1NDhIeWtjRkR2RERa?=
 =?utf-8?B?bmxQM1A5U2VpOEt0d2xZMEZyZ1Zadk84dmFNWTFqQWd3b0FQWWR1MzZSYWN6?=
 =?utf-8?B?N0E3NncrZXhCWko1UmhsUUNOYmFFTEhlUWxtQnJqR3BvWkt2TFFGbkViVG83?=
 =?utf-8?B?ZFJjZjBENVBVVHFPWmY5bUFQdjdic2RrcFlPWU4xa1pRSDF5YVJONGlsZmxt?=
 =?utf-8?B?REROZHRPYWw2RWJKNUNvcjdHRHR5dHIyUVJWcCtWbmQybW9sVVFmclhPOFlX?=
 =?utf-8?B?dGM1RnoyRi93WnpGclF0cHI5bjVuSHBrT2pDTTA5UDBNd0VWNGtxQ1AzQ2tC?=
 =?utf-8?B?RDJVdjdqQUlDWEk5QUFURFZGKy9LMElYcGJxZkxyTU45ZVFrd2FBYjBKTWJs?=
 =?utf-8?B?SFBJTjZPQUJMMXpXZEpibiszSy9ncmtEQ0Q0aUpRZXYxbzlKaGJqVmt5M1Fk?=
 =?utf-8?B?dlk1ZmxrZS9zd2FzR0pZd1pZb2EweCtsWUNGU1pQSzd6ek9RamdQdktVSmxF?=
 =?utf-8?B?NGdKZjhacklpVU5PMUlVZlpBSXBIcUpkaFd5cHhFVUJIS2tUTzRLb1R5TzJE?=
 =?utf-8?B?a0xPZ2hVR3p6d2FQWkhZUDFmckVJOEVlVnA1dGVwVG54dzdQbGNoV21XWlVk?=
 =?utf-8?B?Y3ZqdndZaGIxaytCcTl6Vkt2Rk80S0liSXVxcHQyd3hYWVBUWSsrVTd6Wm9x?=
 =?utf-8?B?dWRydmhaOUcyb1RPdnhxQUhlTmdSUFJIUUduTjRvR0g0QVNNcCtZY1h6NHg0?=
 =?utf-8?B?WWIwd1p1RWZhaTdWWXh5OEE2U3c3NG1SbEx2dndhb3BzakR1RzBqN25NS01X?=
 =?utf-8?B?TnZjQy9wYlVaWksvR2dxbFNpdWFaVWZnUnlFbXM0djAvbjNiT1JMUldYcFdk?=
 =?utf-8?B?TEdtQlpiNi9xbkRpMGgrcUliR29CR0FRZWVVNVkvNzNwMzhkMXJHQWJ4YUR5?=
 =?utf-8?B?d1ZhZTlSRkJvZFprMzB6RFZ4RmsxMjU1azk1c2djY0RQNjhGSXVqTDVMbyty?=
 =?utf-8?Q?IegFGc5yu8I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG9NVDFXTTNhYUlrZDcxOUtQNElnak9SQkY3Y2JHZFBWbitmZ3lhNE1PZWVs?=
 =?utf-8?B?VzRVSHhaajVZeVZEYm83UFFpZVJsc2k3dXdiY1pYY3M5aG0xOXFnQUJpMm1F?=
 =?utf-8?B?L1NIMEI5OHdzdzZIVkdpSWZGQjFyS2VSQnl3RFBXVG9iRzk4VXRsWnFZQ3I3?=
 =?utf-8?B?R091aDNwK0lGTWN4UmlrN09MS2Z2SVVueWZQWWgxNVR6MlF5cjN1L1ZEc1Jk?=
 =?utf-8?B?NXBsU1dUL1lzakFmbEdYSVpjQlU5V0Z1UEpJNUQ2WGtYZmlxUmZTampOYlUr?=
 =?utf-8?B?R0F4NHJGY0dFVnFPS1YvZlhhVHhCTVMzNXJuL2szb3Ewc3dROWs3Q0xkL0Zh?=
 =?utf-8?B?eUw4RlF0Ym90UlEwY1NmS0hGRnM2UHpYbXNJRlRVVkJpb0V0N09HdGFSTzVs?=
 =?utf-8?B?Wnp3M3JKWmNRTVNISEgyNnB3SS9LR25iQzBLK3lIblRoWnE3bjVnWXNaSlFz?=
 =?utf-8?B?QmpBNDlQQU9jY1VpUjdzc2JNOEJlUVp6ZnJrYll3MWNwd0UwSGY3RmpXN1B0?=
 =?utf-8?B?Vko1UzE0MEx4aG5kMVRwbFAyV2UvcnFTd3BMYXEwcnVINmFXdm5RTzF6SXFr?=
 =?utf-8?B?andzMjVvSUwzUTV6S2xaVWZCdTlFQ3I4ZTNYZjluYUFscXB6Q0k0WndzTnV5?=
 =?utf-8?B?NFdOTld3czMxc0Z3QkxzejA0Q09tWXRxTFQzd0Q5R2I3Sy9qb1pyMDFYVGdI?=
 =?utf-8?B?clZDbXE0ajltZkNROEE0SFl0enZIb3ZHZUxHYkhsVWdjd2IrVXFvZHB4ZnN6?=
 =?utf-8?B?dGhxbTlFQk5YamxzVTVmYWcyZHk3WDR0bzhlcUwvajVkMG9uWVdkMlF1bzA4?=
 =?utf-8?B?ekhLazEvWDRweVFpRGh3RkZkS3hXbU0rd0tJNmJkRDdUTG80NXR5emtpN1du?=
 =?utf-8?B?TW9VL2ptRTJLVU1QZWtEeW5xSXNrQWVJTXBpWWFhVkFwTkJFNlJzTzJkUEJz?=
 =?utf-8?B?clltd015em54bWxxNno2bG1GNFlZa3d5ZkpHMGY3dTd6OTlvT04zTGJOcDNH?=
 =?utf-8?B?WWMvQS96Ky9CczNjUGVMNEYzNnR5U3JiUjhQKzVQMXptM1RGaDdGMUlyeHhN?=
 =?utf-8?B?T25EKzBkeUs0SXU2OUdkZk4xTEdqTHQrYVFVN0p0cUhpQklNTUZKMmgxTm9X?=
 =?utf-8?B?QTduSzJqREQxNGV2Rzk3dGdkeXNNbnRWbzQxZVJ2WTBjN21zWTN2a0N4Vmd5?=
 =?utf-8?B?cDlYdU1WaDBvSiswMy95U3NjYVcrTXJhdjF1RDg2NXZtVDhCbTVhV2VmdWFw?=
 =?utf-8?B?QnJuU21LQ01IUnd5L2hKTWdNa3djckJpc3NEekkzTXd1T3JyNnR3N0RFUi95?=
 =?utf-8?B?ZThsQVVPeWwvVEZxMGhXQ1lsc2thVy94QzhXSUNaVFR1SjdvOUlFczJqT21Z?=
 =?utf-8?B?LytwR2xtNWhQdVg5R3ZFRkJoa2l6Wm1QOGk5SVphQ1J2UXpHK2lEdzdOWDQ3?=
 =?utf-8?B?cEpqZGt6UnpDVjBNTHFjT0hKSlRXb1dpK3lzeEQyK211VHU2Q2ZBRzloWUUz?=
 =?utf-8?B?bW85TVpQaFpoT0dodEZYMGlXblpGd2phWDQzbW9hRXk4RXJIYzc0dHVZQnls?=
 =?utf-8?B?MkFqRis0YVhlQmtoT2xueGpiWnRXQlAyamtCZXdwOVNSUUt6MFFVUEk5bllG?=
 =?utf-8?B?V1VPTlF6dE5ublA2dFhkb05ONWJDREMvUWxWVStybHg4ays2dFdSTGNmRVhp?=
 =?utf-8?B?d25tVnBpTzVNMFo5N3M0MzJSdHU5STNMMm40NUpZMUlFRmJZMVhpWS85ekRi?=
 =?utf-8?B?aGtwWUtwY3JCN0svNU5ySVRnay84Qm5rNERTZVNEWkNwMUVvbE5QY0djMUk2?=
 =?utf-8?B?cjhKdjRYc005Tkp2bElXUTNiYzFoRlhidmZvcEdhWmFLREUybGFJTWxObEhi?=
 =?utf-8?B?ZTd3eEtDTjY1UlRjRHpGVGlaR2tjYVJPNVRkRHE4Y2JObytDZ1BlQzdUVE9N?=
 =?utf-8?B?VTQ2RGFxZ1duUkc3WXBhOEViL0NudUowK1h4ZGR1S1B0VmM3TzRBRUFQU1Vj?=
 =?utf-8?B?amJ0L0hqbjNqajdMVlYyQmY1b2M0dWR4eG4zYUM4NHBsMFEwbXBET04xV2hl?=
 =?utf-8?B?Q2llMmRJYmM3ZUYzNXl1TG85dHIyMSsrN3FLMVNMS2t2UFVKcHFBNmZ2dnRC?=
 =?utf-8?Q?oFQZYhpK6Iy9930ma2Ok8UpYh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8ff8e7-2f3d-49da-bc92-08ddee6b5f27
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 00:05:08.4566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rb+TC0lQAGDUNL4D3jZoxT5tNAJuPXy0Th9aD/k3tgWAqok6bu8h8UlLN2ztgK3emw5QZoNK5Np7xPGQ9thk6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 31DA21C0003
X-Stat-Signature: 5sxc9y4e4q1pdg9g9zb7p1bnxw884wjx
X-HE-Tag: 1757289914-967364
X-HE-Meta: U2FsdGVkX19ZUoc9puaai3kjwwD5KUl1C8xjUjePMhst+54dBfiH/S2yEqDjOyzRDjInatgFfFHYhblYkNG4UUtdqFmlxD8crrvBEMhAcu0zlsFj6ETIj2cgfOVQ/MNzEAHoqcM0HR9AMaBiLZDp4vnA0tMqusnHRpAX8jmAQzBay49ZzWUZX29hi2yqazlbC8OG426iiEfU+He3UOA1+hvvAsU8naWzTecvbBTWYJ1eB2fXBxHP5/5juM7Fd26uZlQYSLHuPfUGG1gtOawp0Jn3HAOZocdhrogXQ7zRPkOELuRSFv54A1ab74jq5228sY44MAJrwlimeJbnP4HnrW8QMUSzA5ZGBq4q/H/LDMQ9Y0ffhyY7/xas2kUok+WDfhhcFwTo3tJI/0oWd8d9if3feaoXRq0D9I9D0ZkDaHGFLYSR1pjCYa04fcz0DyHqWZaY8gweJkllqusrJMcqhKca7m0JolZ67Ewqb179ukCmoj4aEj4D6j/IESWYPwpA+pEgQoXcP8POPDifkU9O8HZ+FoWlFBr/S3szJgSQCHtQ9XdN089JhnUlP0nlvvniWU/Xwj2p1mqsbTao7wHVcSKYfEgI8qxu526gPyJa8fSnMlVlw3HsMjnK6ug89pgOP/06bOpFMBq/i3DmmlnARwRMr2NOvho5bxrt8VYmeI2RwsOYOBA5X6Vsl2QDvn8TfpAUY/plZwMBbGBQmpmObKKQUB4gRHunaNFB8wI4dKImfW7uMnfso3SrL7fEqFrFE6gcTmhVfUAoNecx4YXbEbbIx2LC9TiUnu6E73AWnvIZ4Jmjn6+wGCUfFlltwQ6a3SLFzOhAiHNaBgOBgKcXoZAkYSdiobmHcQZS+m3vq88n77t4QBava/i5EhuhuaxlJx/0u7hDSvw99/HEH2M96tKFSdluCnyeTVwttAvTnC4rB6wzO9yN62bzncx1mXxeMGG1yQ36lfg4NtxKzK/
 EzNfDRX2
 bLCpraCScq1E9E4F3Wl9NZRtCWQIOmuGBbFTPIvGfYgNbQSYS57JuuRkmfM6lXLIPddXfQTaQPKK1x3uRMYJVPX9QnDAhklgnGnjcnibx0nHOHs+aynvv+YaQkCaA2hbsQJYtoIl+Fd+C72AkCzt8Sy3xcnwBeA/Rdkryl7aYTGf+AvqhZ6Z1TpYbmDBnN+G65Ko/OnixUnhhoB56rVgamCsU2jrg0zsajDw34eyuyrKzP0Vh75xG76Kjvy/94TywiqXfkWxmGI4VbGWnBmrhMqlLSawI1I+WVcm7CbnUotgOuEb6bkmvd2zD2COJJ3ZF7tVaOTSHz7+py7qbHianjIC5p14GwBpRUQ4mWkQJZXNgKprT9IQJ9uhxfqPsd0UXgV7EOC/BORlRsgqKmX5WLmxG04h0YytqLTHNU9a9wbdT1hIyUyTJgk448NQC+HsizyAaiEbYcboCByyzT9CW9kq+vjXc/qXeNGd2S8C283FBj8DoNr+aiDnl1rcrNF/HyBNouySRbN6w9dxTHBIUqDeh+hvs0SqoMsMd8U7OOwLH0x7x1LGJkHez0NaRp2L6HXRbQSh6bO37h1rd0vNdXvte6zrwvI+XsP6SWevlMjG7etpOeJuOYLhAM8bQDSWdDb1ycKqwFuaREd7gZQIspBBm9B7rlgB7SzJv9+a8uCxGLatVvrDUL6XZ+k8o1WzWQWuoT/0dxtEkMA2cWJ0PfE0zAJUjbwuTMdYf7JvAv9t3K4GCJJN3kERwqxhk7tSYHv8ersZ/xw9hatfHk745uwi0TSo+PpHP5QtsiYnc7k5o8zOt3cKXN1Bit3kkKCmcf54S72C1ZRW5j316slKcd1y/MuQcH9oFlTJSDvb0cDqimc3/hcGV+VUdnJPjfvmLx0rkteDT1bVhsjeuJYhNbFzOY00WfroI1LYZGQYnEWgZXcPnZWwSi86EZMqcuTewIsq8Mh/55NMYsEftkLTKc/N1pzi/
 CeRaQosn
 5rIYhW4sxu5LD7lm6mvrOyrZYUk4dr+rqpILUuhdZKnw1/SqsBL0SjWJ8q33N4SoPSF16t63/HLB+KeoIFzaezlmWbIK/ZNH8coHHqWLBkNZWkyc/A78C/DWaY1HN5PMW673eRaDW45etaamhkrXWoycUXwh5YSd2cBgugRMZfQU5F53fT/q4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend core huge page management functions to handle device-private THP
entries. This enables proper handling of large device-private folios in
fundamental MM operations.

The following functions have been updated:

- copy_huge_pmd(): Handle device-private entries during fork/clone
- zap_huge_pmd(): Properly free device-private THP during munmap
- change_huge_pmd(): Support protection changes on device-private THP
- __pte_offset_map(): Add device-private entry awareness

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

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/swapops.h | 27 +++++++++++++++++++
 mm/huge_memory.c        | 60 ++++++++++++++++++++++++++++++++++++-----
 mm/pgtable-generic.c    |  6 +++++
 3 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..59c5889a4d54 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -594,6 +594,33 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+
+/**
+ * is_pmd_device_private_entry() - Check if PMD contains a device private swap entry
+ * @pmd: The PMD to check
+ *
+ * Returns true if the PMD contains a swap entry that represents a device private
+ * page mapping. This is used for zone device private pages that have been
+ * swapped out but still need special handling during various memory management
+ * operations.
+ *
+ * Return: 1 if PMD contains device private entry, 0 otherwise
+ */
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+}
+
+#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 26cedfcd7418..2af74e09b279 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1703,8 +1703,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (!is_readable_migration_entry(entry)) {
+		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
+				!is_pmd_device_private_entry(pmd));
+
+		if (is_migration_entry(entry) &&
+			!is_readable_migration_entry(entry)) {
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
@@ -1713,7 +1716,37 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 			if (pmd_swp_uffd_wp(*src_pmd))
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
+		} else if (is_device_private_entry(entry)) {
+			/*
+			 * For device private entries, since there are no
+			 * read exclusive entries, writable = !readable
+			 */
+			if (is_writable_device_private_entry(entry)) {
+				entry = make_readable_device_private_entry(
+					swp_offset(entry));
+				pmd = swp_entry_to_pmd(entry);
+
+				if (pmd_swp_soft_dirty(*src_pmd))
+					pmd = pmd_swp_mksoft_dirty(pmd);
+				if (pmd_swp_uffd_wp(*src_pmd))
+					pmd = pmd_swp_mkuffd_wp(pmd);
+				set_pmd_at(src_mm, addr, src_pmd, pmd);
+			}
+
+			src_folio = pfn_swap_entry_folio(entry);
+			VM_WARN_ON(!folio_test_large(src_folio));
+
+			folio_get(src_folio);
+			/*
+			 * folio_try_dup_anon_rmap_pmd does not fail for
+			 * device private entries.
+			 */
+			ret = folio_try_dup_anon_rmap_pmd(src_folio,
+							  &src_folio->page,
+							  dst_vma, src_vma);
+			VM_WARN_ON(ret);
 		}
+
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2211,15 +2244,17 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			folio_remove_rmap_pmd(folio, page, vma);
 			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (thp_migration_supported()) {
+		} else if (is_pmd_migration_entry(orig_pmd) ||
+				is_pmd_device_private_entry(orig_pmd)) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
-		} else
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (!thp_migration_supported())
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+		}
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
@@ -2239,6 +2274,12 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				folio_mark_accessed(folio);
 		}
 
+		if (folio_is_device_private(folio)) {
+			folio_remove_rmap_pmd(folio, &folio->page, vma);
+			WARN_ON_ONCE(folio_mapcount(folio) < 0);
+			folio_put(folio);
+		}
+
 		spin_unlock(ptl);
 		if (flush_needed)
 			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
@@ -2367,7 +2408,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
+			   !folio_is_device_private(folio));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2380,6 +2422,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+		} else if (is_writable_device_private_entry(entry)) {
+			entry = make_readable_device_private_entry(
+							swp_offset(entry));
+			newpmd = swp_entry_to_pmd(entry);
 		} else {
 			newpmd = *pmd;
 		}
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..604e8206a2ec 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		*pmdvalp = pmdval;
 	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
 		goto nomap;
+	if (is_swap_pmd(pmdval)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmdval);
+
+		if (is_device_private_entry(entry))
+			goto nomap;
+	}
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_bad(pmdval))) {
-- 
2.50.1


