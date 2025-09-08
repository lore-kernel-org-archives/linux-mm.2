Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F481CA101F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 00:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7628C8E000E; Sun,  7 Sep 2025 20:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713428E0001; Sun,  7 Sep 2025 20:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4488E000E; Sun,  7 Sep 2025 20:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 427658E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 20:07:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CD0A5BBA4
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:07:18 +0000 (UTC)
X-FDA: 83864143356.05.FEAD680
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4649F8000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 00:07:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gQbmdZTJ;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757290035; a=rsa-sha256;
	cv=pass;
	b=UR59Gp9P+0wptqJKUV7fVgFyiYnfrK4GIqAPLU3FrG0L1EaKD8wrv+xj7EIuNp6nPuoZyN
	ISyxaNv2gm/MRlVzBcWfOJ4w1IURcSMWUTZ1cI/U5nm1q6IXXHl2aLf2IRittgVkQyt4kM
	78mbc+YUH6zS6ZiCLTF5VjuF3xelXlI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gQbmdZTJ;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.223.59 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757290035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17VMiiTWH9iustx3+EsefuZ2YdQauUDEUX7tBWMJi0A=;
	b=BB7dHS5Ffu9aHRPPkwuTCbhPIT6x8snF/4Muq416JCRgkM6mjb+adruJ3y1M0HLJgOzfUK
	f/1JMmmClJfokN3u13neYkUZoSzXmDwX2f5VJxN+iW+SlhyRvednPQgUI3TF/Sve3pOtOc
	wDxImdCZZNi9P+1yVNKJvvQ5M9CgTkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTh01CTa+2slb53FveC15LRm23mBvLi+eI1tYnlnMOHocAGAk9shwPea9FjmOEd1jHGTJMQZh260oMPFMUJw5mvQlkpj4TrPKy/j2JmhBxMUT/6OwDnyA2hhUWJ/TbDyerUivwCLHJB+H/3230Gr3ll6W43epR9zB8xGSOa2+4bLy0jOWqOK7SQO8Y+OkXndheDkC/KOad8RYGh5Z+GQtrP8q/8aXgf4FjdZUVIsfYhNXWCZl5peq2zcRwZICSFyVo70AsGFfkB12JacFqwZQ85SRCdLIo4niPMsssdBebvQOdUOTrPIRSzER1yHbF6bhwDNvQKppjf8NW+viI/+KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17VMiiTWH9iustx3+EsefuZ2YdQauUDEUX7tBWMJi0A=;
 b=s3FO4UvK8Km5TmLDrlR0GHcA8tEu3FhmLOd4FlHSvA8a9aT6CfO6dQkvg+2L7t+3CxKMA/q3yvHISniAKCRpbLc0/7/UnELVPRyTyukuboAKu5LSZLOo15REuMoc4TZLLQsIsSDFwXUQlfunjE4BcFHGtIDi1vW2pMQaTasLJwHtIbUQyIkvLwOyHjmHbTHVCsM052fVKsZ7ak6jiYqJnSgQRmSaYfLE42h1nmi9DogvLlIHJA04xnkEVXqOH8k4yltvErOcmhxn9b8+DxovpE62ugXKu/og+N3qR1SamF72YW2rJTL88FavdSI1a53Pd2qPQobJiyHvUsfSwq7QOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17VMiiTWH9iustx3+EsefuZ2YdQauUDEUX7tBWMJi0A=;
 b=gQbmdZTJ9VBUxYR6R/bGLtvR5eMbIxGIkfOcJDOQ155OlB/woSgdWP7DqMVfLz/aOBNPow54uHv7zlTE6oxDHjHHefNPYbMOmfT17rgpGhCrCVKUvxZyB2YxYOYUmxiLmMc5Za4a1p2TG/l5/BARuyrfjtEOsu3RAiM+6mA1oT4HDa7vG/8dacKyGOh5L5YgjPz3Rq7RKzP/Fet431KIK0hB1M3xXRpI+DXFhtO5v0L6KAu9fvSXiv8VcLoC/oZqlpvZmEBRMIfb6HDO/5eah0pj/+f3Sy2MSSA1P+0iRVyxZ1hiSs16eu+qf4hWyr4taUoxNGmn/5uC3hIBHXBbCg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.19; Mon, 8 Sep 2025 00:05:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 00:05:17 +0000
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
Subject: [v5 05/15] mm/migrate_device: handle partially mapped folios during collection
Date: Mon,  8 Sep 2025 10:04:38 +1000
Message-ID: <20250908000448.180088-6-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250908000448.180088-1-balbirs@nvidia.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:40::15) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS7PR12MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 65f2dc7d-2424-4de1-bf96-08ddee6b6465
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RURISHhMUkwvVmIrMzFkWGg1RVpDU0Qzbjh5blRkZGlxQlNSRG8xQjdUaDM3?=
 =?utf-8?B?RlpvQjk4SzRNeWh4YzQ5RmkvQjJYMHFtTlBHNldyZEtzbDdwbHpZOE12WDlm?=
 =?utf-8?B?VldRQUlTbGVtdW5mMGM0TUIyUys4OTFXQ1o3QUpHZytJQTIxN1lnK0JyTVYv?=
 =?utf-8?B?azByeHlsRlFhdXY5R3MwVWk5ZExnUmFkUUc0MlgzTHlpd3o1dXN2bW4vSXY0?=
 =?utf-8?B?dHpxKy95YXErOEYvb29xSGhOZzBiNVpHZE5vVmFnRGpEYkJnQzk0V3loRko0?=
 =?utf-8?B?QXp3STJ4REp5V1pSSmJmQUt3VXRBWFdxYVk4NkpDa2FIc0UwM2tWcXpwWUo5?=
 =?utf-8?B?YURLVUk4dmxteGw0b0JPWlBLdWwzNjVyRXlKYy9hbFI1SXArVW1JQ3lyR25l?=
 =?utf-8?B?eVZMY1hkMFZWM3VtQis1Q0lMN1pTckxHNjNqdi9BMjdEY3FTM3NZQzE1cEFP?=
 =?utf-8?B?ZlZaKy9CNWtIOFdVUW1ubS8yMXVtUVgzaHl5TzY2TG00b1c3QU1yVk1xeFhT?=
 =?utf-8?B?WUFFNURpd24yeU96UUVINms2aERuWUVSRnpJL1dmMDdybGcxaVNzQVFLN3RE?=
 =?utf-8?B?RTlwR2J3MGpHb3FXSnpQL3A3b0w0a2RFYkZmTlM4TjZwWEJIMUt6dTRqM2Zq?=
 =?utf-8?B?R0FoUG9EcDhWSEI5N3Nwdm0vMUJGNDd1VlRRT0xzaGZPRUlhM0VkZU5CNnA3?=
 =?utf-8?B?N09uQU9Ca1p0T2hEYk1xWE40djRvR2F3T3ljd2FBb0xGbXJmNVVOMFE1d2s5?=
 =?utf-8?B?VWxiQkgvUHYzeG1UWFZWSEFTRitmaDRWUE92eXZSQ21malZtbWx5YTFCNm0x?=
 =?utf-8?B?ZUwyZG5vTEFRN09PUDNtMUt1c0dIU2JrbjNZcjN1cWZQbXY0U09ZalR3cW12?=
 =?utf-8?B?ZllzRk9JbzhnVnRObElTL1RId3NYNDdoT3FxUUo1YW5sbU1yLzJGVHBPWTlP?=
 =?utf-8?B?NDBqZ1ZwOVQwRVlhZjN6THErNHNFclFPY29Wbzc3ZDJmWjNpZEpYQWpFWFRH?=
 =?utf-8?B?ZFRrRUxwS29heENPWTVreVptZzAvUUFqSE5rZlZGajREcXZKVGhMc3hnbUtZ?=
 =?utf-8?B?Rzc3K0JTdE5BZnlmZkw0Yng2RlVCc2w2Y0VUZ1kzbzhETHV3M3VCWnE4aHR4?=
 =?utf-8?B?SDk4cHNmNGhWOWRNQlU5aG5SUkpRT2MrQlAveXRBR3JaMi8xWkVQYTA1OElM?=
 =?utf-8?B?RkR6UmZqR00wMTRHNCtQaTBJTVI5Q0ZuTWFxVXNIYnp4Tko5YmxHNDRhRjFU?=
 =?utf-8?B?VGVVdElhV0w0SW81QThBT0t0V252aC9td2xBUC9meXdpQ0s4UU1TR3IwQ2s1?=
 =?utf-8?B?azZUbUhxN1g0RlE0eDNYTjVIOVNhZGRucWJLNkFuYUY4RTJySUp3NWJXYThi?=
 =?utf-8?B?S0F2eS9tYTYrUWpxaWdJZzdRZmZYWjJKN2FLU1RyNk5QMHU1QmRnYXhiMXA3?=
 =?utf-8?B?QllvT21sTERzS1NqdEQrQlBSd1RjSkYzV3UzRnB3bVRKYzNiTWRMUmloUFBW?=
 =?utf-8?B?a0czQjNCcEtQVURyeFIxN1hReWdQZUs4aDVZaVlGVWFSS29VZEo4VXV2aXJT?=
 =?utf-8?B?N1BTVWVSc3pSU1dRV0pwZmVmRnU1L3cyVEVvajFwcERFWkVsT095QUl0RFBO?=
 =?utf-8?B?cXpGUldhM3BGNFpxb1BSQmdieERvYUhmR1gyWk8reEs4VCs0UUMyTmtjVmNI?=
 =?utf-8?B?SjZqR2xDNnd6VllKRGpuZ1czMmlQWXNYTmw5MTk2cmdoZ0VUUDFXWWQwWFgv?=
 =?utf-8?B?YTBWK0N1NmFKaEdKckdOL3EweGxOalFSTVZEa0JMY29xdGVDZXN4bU1KaTZp?=
 =?utf-8?B?OGdUYXlxazA0VjhDb3BtdkJCNlIvK09HQ2VLdlVjcGlLUGpHTlFWR0thQjli?=
 =?utf-8?B?d1Y1TDBkU3p2MjJmU01YeVMycFRQZWdXcWpWcTQyQzBBSjF5TmM0UEZsZlk2?=
 =?utf-8?Q?EPkx+SoSK4s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RENvcFRhb1p1WkFJRDB5cks0c29Xamt1TlpZUVgyZTlETVFwQzJyU1c1eFIz?=
 =?utf-8?B?NHludjRUbkg4TWJmMjYyQ2Q1blcxaDNJU2pqbEYxN1A5MHR0eCtzZjM1TGdP?=
 =?utf-8?B?V1FFNXdFd291bWp1a05jcEhQZ0tJczhtRzFxUTBEVENLVzI5TU5kSkdHOCtI?=
 =?utf-8?B?Kyt5ZGZIMS8wYUExbE1BV1UzTDlPa0hFaFVuaU5yMnNxdC9SN3pYMDhmOENv?=
 =?utf-8?B?YllVVXFvaGNxeTRFMERBb2tkNmhrcnh3VHFYczFBaWRwMktra1RNMFZ3bk5P?=
 =?utf-8?B?ZjVCcGxYUUtxaXRXS2NHUEJob2xkQ2ZiQTZDU1gyZk13VVEwdkNKc2ZUdEwy?=
 =?utf-8?B?OTZJbTRYS0QvcERleGQ3VUNNdWx3aWNHMmlNRzUzNFpOa1dBOWptVFJWVWhE?=
 =?utf-8?B?dW43UHozZFFKVWFtN0JtT0R6ZlRxMHJjak1iS1lNcnpzNDhYUjJOcFBQOTJi?=
 =?utf-8?B?YnFaaVIraFV4TTBmRHB5WnlLaGRTL1RNUkwwNURoUUV5Tmw2TVZ3WUMvQXln?=
 =?utf-8?B?dDFMWFp1VE5SMFNNMjg2a2pzSno2aWM0SjBxTHJzM1ZaVWh6aXlCa3hJaTRY?=
 =?utf-8?B?ME5LYTN6NHdrNFArNHRQOFRWMk5BOXh0VjBESU1qaTJSSEFsc1BTbkFIRTh3?=
 =?utf-8?B?RmdPOUpLUFdnNGlIbDRCYnFFemE1MHJHektWWTJIMHZ0amwrL2pZZHExcXhy?=
 =?utf-8?B?cHU5aStWRU9KZWJydmNxM1RQRE55Q25EcW1UUFdJUkE5RnZ0VFRjcjgwbzlB?=
 =?utf-8?B?cmNZMzZkMzZjOGFEMmFoQ1o5ZUh2dzRUL244VzZ1NWRITjgyZm9kRkFhQ1lw?=
 =?utf-8?B?L2xvRm5UTFlDQnQvV1FWV1BIQXZKS2Y4N21QQWM4UXJkMUpCZTNiQS9zejdm?=
 =?utf-8?B?QXdBVGE0ZjJ5ZVRFNGV2UXZVSXh5K0M3Rnhwc0Vtb3pQM3doTnYzNnJvUnh3?=
 =?utf-8?B?ZXJ5SGlwdVhPT0piZWFBd2M4UVppM2NLdlZUaVNkOC9vOXNiRWFEa3c3RjZy?=
 =?utf-8?B?R0prV2o1UkZsVEZSR1FNTFJPM2w2MW1pbkhhL2NoT0NsUlE1WUFFd3dxYk0z?=
 =?utf-8?B?cThsWUhQWnRueWJqeFQ5TTZjMDR0d085aExjRXV3WXF5bHE0WExmakVZN0Qw?=
 =?utf-8?B?UlNDY0drM0l2RU1waU9aWTNrenNCUnlSKzJvc1EwaWN0WVlhTUgwbTNYemVP?=
 =?utf-8?B?dFBRdktsUHdUWlB3alRxaWk5cjdTSkhyTWtxUEgwMUFWbmJaWExqR2MvVUtu?=
 =?utf-8?B?TmRtVXZESUhJZytBYXFTeFEzL1M5UmU5V05adzExTWdKTERyWlMrTndYV2lQ?=
 =?utf-8?B?bS9meFhwa2ZnVHZBR0N5Z0o0Q2JUQTFKd2phbjRLbjV4VGh6MzJpT2YzMWVE?=
 =?utf-8?B?TEZPUXo5RFRSRDdubTJyRzc5ZWJZMjdNQVUranJzU3BHeXZPemtYLzhiNFZY?=
 =?utf-8?B?VU9BczVrYWl6bXR3RktiV2ZiQllTUGpOUUFhUnF0Ulk5all6RVpQbUhSN3NS?=
 =?utf-8?B?SktEY2dyS3hJcUt6RjVOUXVxaU5GZ0VyUEE0eVdzb09TN1p5VDFLWTlPZWhY?=
 =?utf-8?B?KzkrV0NnejI1VERVeXNydnpOaWxKTHo5cGdpd0NaVUJPOHhiemNOUzhucG1C?=
 =?utf-8?B?cG9ZYXlaVzhLWUpSVXBKT1dsMGNkZVRwNXdQSHc4cDVPclhtb1grb1hqUUZV?=
 =?utf-8?B?N1Nsdmo4emVBQlRIbzQzQzA2RVRWOUgzbDhVOS9ralE3bzRaRHJ1b1VjQUVH?=
 =?utf-8?B?cm9PWE45YktlTVpTNy8yb2pVQUhadG1wa255ZnE0eHMrVjkvZzNDTHZhTGJ3?=
 =?utf-8?B?Ry8vMUdldzRTbFFtQ0VBakpIMWVjb09tMzlGazNKOWY3US8wZUhoWHdVYmdG?=
 =?utf-8?B?TFFVYnZxcktwVkxESTZSSkRYdDlnMy9tUno3UllEeHpzNW5OU3lIZStRT0di?=
 =?utf-8?B?QTRQSXp5UHNmeDJIZUVJTkNCN2dpVTkxYkJIRXVLc3pGcDJSbWxCWTc1ZjJu?=
 =?utf-8?B?YWhMb21DcFZmc20zTjhqT0o4MStLWmNJaU1NVHlXUjQ4VHZraEtMSDFWTi9X?=
 =?utf-8?B?amR6Yk1YQ2MydzZFMGcxc0hGR0FFcTA2eXhiaCtJZXJHbDk3bE5aTGdxTUVn?=
 =?utf-8?Q?GhH80a5u7GikM6pwPRTiIBvbc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f2dc7d-2424-4de1-bf96-08ddee6b6465
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 00:05:17.2344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y96BweDBdNyFKd3WOGF4J7hLOumdmjNo+EraMTDbX1hqm7mmbIlK344M6B4JmqEc/ANZqhd3mIsYghMtotMl+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4649F8000D
X-Stat-Signature: fzn9bctykzztkuxbyfyot8ewr1cxu7ab
X-Rspam-User: 
X-HE-Tag: 1757290035-285681
X-HE-Meta: U2FsdGVkX1+iQUG3+J7vZOvmstez9x2wTJvvbq2gSnO7HVT042goFLv7bUgr51ey/FOCDrA2iKooo8x6FI2vwPZQMOkxukS7NEJj6qWyirP5wn2L/5tBpYVgwwpf2GZtoO37CPklI367/SVdbqnE2j5Uwak4SUiio+SWYSw6WBrIZs31nRlDzk1cOn9JQ5pBbCK9vwz4GDL+e0PGN6YWkBG1txEwB0Sg6cBTwkNzF2AE1251rXUQh+5avk/eiTnNld55WqFY55mUas4L0TdiFq6Xgytns/nbwxRTOoNsAY6HUNMXPTmywiFfm3Cso6WTkTha9N4vJVFuq2IYjdA2KKOgebEHM6/osJJlK8v5s7W9WfyJAFcQ0itGXLMIEFdcAk2auLP2qP99SfpmiM1NYDyt2fikdQSdQVkCwgzoawwCDY+ONJW/U9x8Ygt60OkVOOP4T6vaC5b5JTa4Net+wS6IqHZTO4O/WLA/UCnISxrkF988zRjcdYIPWe6MZBQsw+O8x/yZ8+HAFjF/kf/yzbyvT2XAmSGJ1ufiWoWQ1dNIpCsfAXMy5P5toLfhOJ7mEsTheQ+yxeYRfrEJGDeo7TwMJGxJ2FUrXEeN+j5kyos+U88FHJkrkIQYa7Mgk9Rn6xUdHRZsi+/TZOcHdjVGKH93MhwEmmFZoTMzUMSgRb9YbqJZoaN/U1c3CL6uIP7XawY0omIo6PdbG4rjNybwG18idNdZGd/S+eDd6ah408IBCCC/uW+NNUcCWm5PG1B+37wggl8iNGn+J9iCKoMlDghyZbyNRAozo50qaH/+gGh93HiZkufWC3HIYaGvQ5TelMVWngntT8x2NTIBbTm/2y33nY+uF5xrN/eRS2+WYcobsByz+nH2rPfTQHsSFwn7c8jLt0FJqv/sphfjtW+ORiF8RdY7fUvRW9csKrLfivtXjFlEoJ6HOT2m3tGAslBCs2Y9mIO8gHaPVJMmhMF
 B3SD6flR
 wYnDbiTCMV1vsms0xOZbeOiBkvjipcnHwKPjNUh7YMR5MyX16CWyxbuuMX77d3+69nL0r2jc8NNNs29obBR7t9+uMdwuudhmGlWP2gnwaVyvepvEphoKXJ4Yt90Fv5zjqDZBIXa+uozrwJwnkz9ogwQUFgThHiYZYo1mrzkn4C/bmKnwIl4FTpDosNTv24Mj+OfWBLDUGRAUjD0VxGPFJEAcRx8FpXKLrtHvTHBTHxzxML83bvdoICFCJ4jB5VSkPbGnALMo0bDXv4acHp5rZ2iluVCDR8tdKQnQnY0pJasSoVHkomFEzDrggkKbFGqhurSTtN2IzOUx9fDCai5xVR2hw9zO6/nHJocPaJnogiGJq/whpWreVbYloebBETJX7pzkpZR7eweoLCQ8HUqMrz8V/qwA7f0boF0rP+dBA6LoefF1VnjS6Jfd9gUv+OEd6l6ld6DJXqYctEgXxlTrQDWr0NpSs75y1xHEL5DQAsjhS6DlGTvY+NMUn5rhQNSxsMJ6uV3UctKrYxRd9xFq6pAOXoAt+ARFsuzxZnS1nPuQYkJ9XRGEwuUvO7fn4QhKSw98h8ecK12JMIrRHio+z9zdSJBjSaky3AFC6D9xySyelbTzfGFBntcia9LmrAJwB248pvg9EjqwC42jb9m74/lBfhpaKeLVboCtZiumxEEWhuJYL4d61GvVCWBJt89/7naNtnM3srQeN9mgtTXLD7N3f7nvDJXampIlqNyegNwAohuCRjF3xu+41YU3cJNH/gIJ74go8bdZJoWIPUH3y1inTu8YB6GPA3a0fnIuyiKIZamE3a+EuPpw6CDAE0qmX6dhD9FdTKoQU90tmyNsA+Gy2oZjdLWoIM0aB1T/zNLhWFWwVNo5HGxp26bjLx4vvhW8d/LaRT21tO1n/vpTIsGjzX0wXvPdzJgIbXt1GLeNz/+AQo4MCcP2BISinenJ+EGPFENNE+fySxN51Hsmkiqn1O1fQ
 GDvzk5+n
 TT/EQY6UC/gqH3CQOdZcBxye7MVO1nMUv+bCj91vjnXb6SbqZ9Wz3VVBtPozqN7X1hR++bbuFBBhA6+5p+QGJHr5D+Ei1e/IDz7V9eTrKpjwB++l8EfS5a952orwBPzvnSCbUzSrXpTrZr6otNq4L8kULAJBxWefNbGYZsiKTPSqSAEGcsTGO8Weswk6ugVP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend migrate_vma_collect_pmd() to handle partially mapped large
folios that require splitting before migration can proceed.

During PTE walk in the collection phase, if a large folio is only
partially mapped in the migration range, it must be split to ensure
the folio is correctly migrated.

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
 mm/migrate_device.c | 94 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index abd9f6850db6..f45ef182287d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -54,6 +54,53 @@ static int migrate_vma_collect_hole(unsigned long start,
 	return 0;
 }
 
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio) {
+		folio_get(folio);
+		folio_lock(folio);
+	}
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		folio_get(new_fault_folio);
+		folio_lock(new_fault_folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int migrate_vma_collect_pmd(pmd_t *pmdp,
 				   unsigned long start,
 				   unsigned long end,
@@ -136,6 +183,8 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			 * page table entry. Other special swap entries are not
 			 * migratable, and we ignore regular swapped page.
 			 */
+			struct folio *folio;
+
 			entry = pte_to_swp_entry(pte);
 			if (!is_device_private_entry(entry))
 				goto next;
@@ -147,6 +196,29 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			    pgmap->owner != migrate->pgmap_owner)
 				goto next;
 
+			folio = page_folio(page);
+			if (folio_test_large(folio)) {
+				int ret;
+
+				/*
+				 * The reason for finding pmd present with a
+				 * large folio for the pte is partial unmaps.
+				 * Split the folio now for the migration to be
+				 * handled correctly
+				 */
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
@@ -171,6 +243,28 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 					pgmap->owner != migrate->pgmap_owner)
 					goto next;
 			}
+			folio = page_folio(page);
+			if (folio_test_large(folio)) {
+				int ret;
+
+				/*
+				 * The reason for finding pmd present with a
+				 * large folio for the pte is partial unmaps.
+				 * Split the folio now for the migration to be
+				 * handled correctly
+				 */
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
 			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
 			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
 		}
-- 
2.50.1


