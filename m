Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC730CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 07:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46EF86B0088; Thu,  7 May 2026 03:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FE56B008A; Thu,  7 May 2026 03:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E81F6B008C; Thu,  7 May 2026 03:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE636B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:24:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FFFB160458
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:24:38 +0000 (UTC)
X-FDA: 84739786236.28.3117CDC
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011002.outbound.protection.outlook.com [52.101.52.2])
	by imf14.hostedemail.com (Postfix) with ESMTP id C46B5100003
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:24:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IzxP5Vu5;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778138675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxXE89YdqNhSUWAeFfB8+0p6OZ+pxOiBJsZTeBlQo3Q=;
	b=XULPLiHPmhzIx3dAp9fgJNWOvPe/V7E/+QBHaiZ7dvfQYbieFyuZMjOIHL5wc7KCfPUJHk
	6XJHCpVfzAugNtLQ/6QC3c75VNa6yKQsMVKWGfVLB01r2YdlA6dmq7CT8o6KHEKgeyMSxP
	AtrTsi+7UjhPGtIRGi08tunJ0zqmi18=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IzxP5Vu5;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778138675; a=rsa-sha256;
	cv=pass;
	b=Lb4NTCFYdmMV8Qe9dEMzP2NMYxm9LWO5+FRgiXElrn/PEl4mSxTQsVdOZgDnI/YaUEGgh3
	9W3trmYrVYELo4LdeWlKdY00DRbCoDjqAdjyrjKhpLjFzdsAnftDrioQdlVGEIHJ1FxtCk
	sxr7wcUpAam2LsJ8/JvaOu5E+UjUriI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ro5haiV6wGIOu9T1INT0rBvucXvVTQ1nDLy7+TEHe8J0Gi/YmH198s7NREwcC7gm0WvcwTUp4SKV0AcvAqyczCKuVdSzT4QYEE2s5tzic6Jk5HQ+Y5Vz1YnNDjVp1sOglbvz7qJRcDDVUgmOwVSGD9CgG7kztA+fAJEakwBuQ5nB+qU5sZJwN6nTKqCjy/RSiNBaXxr1jaVUw6sLG7yzOn81NycWMhUC7wfG2OvVrSDor17uN1hQs3izaTWdakKY3ZXOaW5bWgRhWQ7tp+BgChRn8S611hbPj300AvmPx1k0HHhm8g0D63n7K84Oh6k6PVitOxy4vN3XeeWRJWdb5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxXE89YdqNhSUWAeFfB8+0p6OZ+pxOiBJsZTeBlQo3Q=;
 b=RSGseAHMieagr0vjFcCDuqc4RPJGfaF/QVJMWbWQ1BygfOx6g0nn0CBI0fPZ4lagFNzTPdODwEtnhKOBbciX7K9O5Z4sWMffuW29GKUf7tuCXgmmTKEuGNBlOrRA0okim7S6lHJfPIrdskcMlWPT7j/85G973BaLWvPLIu8RbwRST/PcBKeBcc4Ca8/7fifGZu5mdn4vCWj1xUqyNxiU24uyPmIeiT+jlWBWLZJxrWkG1/FxFSMOsmQPHiMEGSwuGtcRN6Z3E+Rd5xm44FJkjiFqOdDKqiJX7acmGs28wqJZz6ibuy1czUQIzdcccyqZy8JEj4uUBe214eIzwCgdTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OxXE89YdqNhSUWAeFfB8+0p6OZ+pxOiBJsZTeBlQo3Q=;
 b=IzxP5Vu5qhbzmKIdR2cIf47zqGGv6/R0FLv75+cWL4AoGYuedDSTGnpvHTIWAI3YSckdJZHhjoNIOeuKLAwQl5khNsGzdM0fWKLwkaqYOUTP+GgoPHjXTyknPVy9A3/Y4DwLVJjbNouk9GVnqoFKrqSW6NooZw71BVk24Y7lkISFRVI2uJywnILc9+SUvlCIhe/sM6eayh69Hflgbh5ehMSrISV+/15m4nPg/pCPRKko0HQ63qikizdW8Nn6Cw52zGKWOftHGNuX4fVFHBWkoj8DQi3H+0ebgI+nKYkFXRpsJeLTCBXzsR1DAcEimJS8/5JCRnNWwT/UoI8zKmZvXQ==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 07:24:31 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 07:24:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, Nico Pache <npache@redhat.com>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Thu, 07 May 2026 15:24:18 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <E44ED51F-D250-442D-A89F-B90A671D53ED@nvidia.com>
In-Reply-To: <20260429153538.727855-7-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA1P220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::13) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA0PR12MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: fbe40016-ac4e-4be6-9fb8-08deac09ae37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nDI3+hALIvdl79sMOERL866em26w65JOS0obGeXvEB1lQjnR+d0lI9KRwViKBMGp3D6wNbJjWhrJbp0JWcQrmMI+rO83Tan3eM4xP3U2KPpkoTBdnap2Th89T/8snp2vBd6HZSUqfmBCQaO8LAT+n49JPrEaTU67Ub6yhBSVhvq+j5chcZ8f+uZWDI8xN3bCZ6Oc+gRFffPlbRoEkOtV8cpMyWeDvy+qifNSuQD/wJbWQ7CpxTfSUZStVL6EpM0UVwCboKVpxbcf+1H4IS6gRJNd8dy5DJ8rP7s2EX/pehvfdoy8MD9/rzOKwaQhWQb3cv3yxkpUqH3BvPfBXlAVonzPOLoHKU/1uAgq4Ryq3Lq71BgnnWTKG4iQXKUg2MduDmLS0yB/j8xy9X2tNlvZVcJHN56JeKnbKBGV8yR/OOVszE+HfHPafpSZUdfxi3eQm7MVGMmQtzxfYbENsZ5xTiQRO9vzZgv1IWzzYlFx2KlLtaZEkBTUwyLB2MvpkTKxEY6Puke0QZq5x4EwjUwz2xhzLkx+eKlKUuWVFcNr2ofgVRM9ZsZby8JoV97RNV8NB9oVRB/0diEpI7pshsYiTWlHmr/uoeTrZbFppsooFGNJzZN4b//i8raAbYp5JejVkLr1Go6kXY6vosBKGY9tMhA9TyjXU8gah90AJ+4C3dHHYk0Cwo5HvLa+JVUHHM1F
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gqY7btTaokpaGt5ljVzYVHCt1h7ldSQLa1hz5lsc1Y08KSrJn5qJ03cP/GaE?=
 =?us-ascii?Q?B+C5/g8PZha1AtPpyBo6wVVbyxMT/DyStGdI8K0Ryp8/XDWEZUbP6jUroEXP?=
 =?us-ascii?Q?KhPeEa9byfvANFB77rXsczH+c1dgSnArnaq7bWcBJqXtwwCwkiLSlTXxDF3i?=
 =?us-ascii?Q?P6fk3IJvcNYLdeiTvOsogjLm1vY2lUjs1E3GfBdZ00UrjIwCh6lcThP3QuAs?=
 =?us-ascii?Q?XDDYiTsHnP1ntvzwGP8B5Bv2qUVVvdNIKfGEkxqf8aQgf5xRVUhYy20mgoY1?=
 =?us-ascii?Q?bZLQ8QFprIfNDcx8TltDugt4GQ6BceN4J6hPOzxZX1gEYuFmE2B4w+t5z8/G?=
 =?us-ascii?Q?YthEQ/eorRlfLs8+Ef4M2umSfTkZ0zbQKD09NgAs1n9rED2id/vu503Ai0Vf?=
 =?us-ascii?Q?ZUBRtgX7SKaR7qsrvQd8aUXvaER0nSoMk0eEYP6EacyEugLTT7cbPwQgFUHS?=
 =?us-ascii?Q?RBTTgwlcXLJzHa8MmPMs8jjT+jg+lVMJ6nbPDhu37QMk/cSU/FCKItQC9Z63?=
 =?us-ascii?Q?Vk1n2Uu7huJZVwgEyBNuhy4Hq3Ko2yw/Nom6wA4S0auK5bPBkvgVAyHARPMs?=
 =?us-ascii?Q?VDPxrBbIf22+rnXbXgaNMwTpC8tX8wtK3TwunmqlaVMa6DVWcnlb4EhXTYwm?=
 =?us-ascii?Q?DgRoUnQ7DjPIoPz45LFDi+SeoW900Gd8HdGN1js1GKBv9+s6HbrYI2m+WH03?=
 =?us-ascii?Q?dCisT4GFIEoB44g3bd+EvNy5dS5nsPv4FrsFpQNBBo3xcUjN4jKNnkD6VOWc?=
 =?us-ascii?Q?odvOfP6ZzIchOoM68PEVj3guSF1l6dUqoL+bL1rRoVEEWQ/V+Eh1ZIGsPUxC?=
 =?us-ascii?Q?HRBzlfnNiGp5WyhfkwDFpvXxvLjcRvTde1hKOZB8TFA8CN2h/ubEVNXXiOHZ?=
 =?us-ascii?Q?NnEKNyq04kXxo7ue9qmjFx4enyyToFLm5/O/aCNw2zSqeogzEiwfUsYt7zXq?=
 =?us-ascii?Q?vJC8930Gf7XVPfkx9Xgd2l9gGDCB6erDN/yYzsyMIBt1Tpo7t8LLsk8OT5Xx?=
 =?us-ascii?Q?hTFXCUD81C0kgyllOF2oCZ32FDCuyqjVVHqtKXg3Je2YMazIi+/KcBFY7sz8?=
 =?us-ascii?Q?J4CKDzgrzTEB97mkNOzrmsS3v34gj4W43t7iVI+8DusSHemHr9p+U1gsBhzX?=
 =?us-ascii?Q?aXinU/Jnq6P+a+70lJF4moHTudOcbpXCTOKcdlbW4pcEfm2e5gJ532iNcKAg?=
 =?us-ascii?Q?qE9IejF29mqmicvpHkOltmh7fOikJGKveqEl4uOZ51z2Vtm/9EZQDDsgkgVa?=
 =?us-ascii?Q?aH4bjeBK9mFfDjHgIAcw5aCDuJhzX1oPu2LRuplNO+bORO4Lv9MSBAMzFmYp?=
 =?us-ascii?Q?/BjCR3t8Jygw3/x/CLt/v2Ps5g7o40T1BVSE3sD8u3E+xr4FKC/IANhxyv3u?=
 =?us-ascii?Q?BaIorF1zQXjfIxoOeI0HhGs+hlJszYiobI1xEkq+O5Sq3gnuKEh+AJ2hwwaz?=
 =?us-ascii?Q?6JiTUcVPcaLddk1mtw6ijQimTa3tVxjZePQRhrG11cnS/cx/uizuHu9aWP91?=
 =?us-ascii?Q?bDwHuodn42laID56fS0hQTTlQd6uAx/JNGv1hEEIkKiTfOL8WDeLswGt+ZES?=
 =?us-ascii?Q?3klKX8EjIpp2BitOA9qLeh+Dr+y64CemqU5DFbsvts9+4a1xu48o4TVT2j0E?=
 =?us-ascii?Q?xLz4BMaPRnQiRMa7LK52aMezIXBqiZ7rI2Y8WWy9T1n5bza1ErLXdlJ7n2Vy?=
 =?us-ascii?Q?B1kN7QmRyYF0R2mfGkU/zw763jkHEKGBWaAFpJdvY9mt5/ixYGonlnGIaFC9?=
 =?us-ascii?Q?yX/1ooI16BAjZcQBgp2eRxlU7hig95UYJGyPSfZRbs3mpSp3eB2V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbe40016-ac4e-4be6-9fb8-08deac09ae37
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 07:24:31.2198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CXMbCIHOa0tHCR9HIG1jF2Syi/rmguGxNCjEXjk2OL0aDDQA9ZTtlDJCYltmjv+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C46B5100003
X-Rspam-User: 
X-Stat-Signature: 4jjox65em6ne6jseei556cf9n5z8nq8w
X-HE-Tag: 1778138675-102144
X-HE-Meta: U2FsdGVkX18LfQuA/sDSXBUt4T7u8pYLpldAnFKxLh0XJTTMEAY4E3U72ueczl4IdXaCslI3x8svjaSA+UxyIhkjMUJ0UwMon7bwiDZrU/ZxLMgFz7cREmDsLuQGoZKqaTOsUXbFwP/fOoEznAMliSneujWWxwqmDqoMaNLw6ebqc5gOeTjRZD9EGb5LIAOOzMQT3E4ySiV39wRp52EJrmdMZ9LH+wC+pe6VT5SgtRUB0slbo6pXu5Cz8hciImjvP4y2KhB78Piydb98oRRLOx3H4H69jXnINFNWheCA4YHaFm/m/+MCSo2UeoT4DHWiMDnuiYvBU+7MDfhKhuxO33CGBsAEBA+fqGFaSxMCmcWzOtHR9yUQ6Kn6VHEDRzYxr4CHzG3zQ4t8LYnYC97fuVJfgMmSx0AHLbm/aGH0ULjDgP2s2a9/RqncugJCx9+NVjVC9eP/swQ3Umgz/SX8vRWki16AkByuoFub49Yus0QGLnyAnW36jzsJ/L/AWV8QPLLWE6/y7apEpQXfnj0UYqsD/sYbI82QUiaoRM+yKFokj9TZXepvbWDLK3pH5KmxDOEPtqNNRMuZlVKiGdlm+5dkjJxjrEToxzZ1b1lGBQqHNSrfP+zVntCvqYp1hyNeQdBi4YEFQa3RuvlMAQn8rzWnGctmR/HTJ8760hAFGRe3Snd16fb5JbmzFpv4c70H87tpQee6XW21FjpYOQNVmVy9a8Ag5J/MA6NGy3/QidS3YZ0OxTwjLoXUwpaI/eNZiIVozJ727eNa/CFSm2dM4PVwApI7mRQttrdT72wQ03NmTOxha+WxZAEEehllCDFhfsgIpqQn3II9z2kQfll2OoMKEmY5pexlHQbkFyQaTwsQzNxrHjcQvJa6GtzLBYUqd+LS+Gg4jk0Z66ZoSgkhZwhUJ2orfyFyVwBVuDll7rbJoDDXTGgW2KeNVJSKJhjSRh4cHdTbc+PkdwvT8ag
 2hvWtGa3
 fVkBZk1I4ushz0foHlDwikeCOFHSMcTbpdRIadeAGXrKPOQ/J9Kbj7FRKm1oXO2m5o9ti1InT+xv8gUTsvBjosHUB9FO9w4ThGYczwagGzbjvHspm5fcTaz5Q1WiK7fRYmMOuA1aBtTYR82dcmb5dZxYoBtBySVs+J1cCDl6nAP6HhU6NEJG0IaTJ4RtxdfRnMLD0mPnkY/XtZdltsF0zP2EN1LkRYrjCmODq8+n3sAFvq+0AlTNyT1RhoK86BoOTgK/W880/munJ/52JAQsjn2hc917ajGUni9Map3ktJliW7E21XUqN63IlePAa/0i2OOgEKjFvUbbmoA9DzL2FwHomyPn8FcCTcNCMIrrFsNQQA3GqN+m33T6Mc4BcVgovod7Q1gSPr1/FjiYU0hDe1dxSufN4M4HvhVTgfIUp/aOrN/ymlEWwHZmrjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 23:35, Zi Yan wrote:

> Change the requirement to a file system with large folio support and th=
e
> supported order needs to include PMD_ORDER.
>
> Also add tests of opening a file with read write permission and populat=
ing
> folios with writes. Reuse the XFS image from split_huge_page_test.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-------=

>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>  2 files changed, 102 insertions(+), 41 deletions(-)
>
Hi Andrew,

Here is the second fixup to this patch. It addresses an issue that
[SKIP] is always printed, if XFS is not present, even if khugepaged
never runs, discovered by Nico. Thanks.

=46rom eb9a5c25434e3882423f621dc46281156eac843a Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 7 May 2026 03:17:51 -0400
Subject: [PATCH] fix run_vmtests.sh to only print SKIP when khugepaged is=

 selected

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/se=
lftests/mm/run_vmtests.sh
index 854c5c3e3a6ae..b73921b2cac02 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -508,7 +508,7 @@ fi

 if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
 CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TEST_X=
FS_PATH}
-else
+elif test_selected thp; then
 	count_total=3D$(( count_total + 1 ))
 	count_skip=3D$(( count_skip + 1 ))
 	echo "[SKIP] ./khugepaged all:file" | tap_prefix
-- =

2.53.0



Best Regards,
Yan, Zi

