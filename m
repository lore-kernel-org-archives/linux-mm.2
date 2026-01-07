Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5184D0D167
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 19:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13EC6B0092; Wed,  7 Jan 2026 14:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1586B0093; Wed,  7 Jan 2026 14:38:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978256B0095; Wed,  7 Jan 2026 14:38:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8707C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:38:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C0161B73C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:38:42 +0000 (UTC)
X-FDA: 84306180084.06.CB6348B
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012058.outbound.protection.outlook.com [40.93.195.58])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4BF7D100002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:38:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="MduMKH/s";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767814719; a=rsa-sha256;
	cv=pass;
	b=PJbRfkuvtqvKGOQd4I98yrPhOvuWI0nXKghPkxWRg63YFt7QOeDRPKBGVLmPJQAnTFcXMF
	IjisxCkQYrx4kcVwfg8C+XzzKfiXNpAc0NxqE8ufzwgkQf9NOPyFB7CijkEx+vgtvIg2Y0
	k6EfiN6iMf70wLLU3f1nCo2gKXUAkRU=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="MduMKH/s";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767814719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kA5b25bgyjynGpIRYY5mzqYFD0m7tlluTK4AuigJnU=;
	b=3HbT3qIWGhDr+i/ia82ZVB8/Px4CooyPT2etWhJz9vgp2pHB30VtfIMcyrWGK6bmKwSdHM
	8xNlz2jyBonv1H7iof9EzGnE8mqjOcm+FKJvwsrJf3QKjDJIAicKYewM2ysyxL3NTM0dy9
	zRC5eUeBbcKulY3g4QL6VbSyL7tw5HU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QATFoVSmJ9wXxhRGN4Z2EAEqpqo9G5yUZttjbsgcUPMMRy/ZL0blvqClfL03eja0SBcih2QG+ikm99u9slwowoznOrvXc28u+egAWgVZhhX8gjD/mYFarvSv0D2wYZ4XwM9zCpi84/ZHuOeHVcQXkguGOu5N7z842zARAP8Aq/St2ohNJsD35hAbWpBbS3lcaJq3ioqHfswCsCKZaTnIOW7+0+OUIWWgacshzTdPwzX/MMStS5mqV6JmCke3V0WQnZYMWNwVyDUo3b05pWQ3VWpo82m1oIGrSC155o05XANDNYOmY7PwLDlRTy2Jy4OpMugTCI+JdvrR9h1bZO+6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5kA5b25bgyjynGpIRYY5mzqYFD0m7tlluTK4AuigJnU=;
 b=pRKfShctMdgp+8EjqfvnOUCms8fsPE/Hn9sqCmvFeqz/DuNkinclp2Ytlz0V88SPN3xnwC55X46RvmKwPyoPwCy4f+Dff42OR8GlLqSahne5eO9svzWqnKj618/+U/2zjO6XEh7XaUlaQsOJAmach9jcrsHOE4UkG3FqD+/HQdXSjot4HcWPaWszOtxfDsVW021K7gCAwBFDf1anpgI7OIXfW3hhv3n58ii2ejNbOnAdafMhij1llgIFoDwHaF3S0ElKOCO5TlB1cJknfWUZQYHa9Txj3OI+IO09MzxedrMsyMkKJhPa06OLdRtFU+zZ8PNKH1QaxMQsK5D+dfPofQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kA5b25bgyjynGpIRYY5mzqYFD0m7tlluTK4AuigJnU=;
 b=MduMKH/sZIjtaDZNQ8OcRcBBqyv28yzV/GItV/zWUhHqYOeZqNEE0g4qPsfuquSnOThQXJxw181NJ4ha/ZbbcCH15oBEj/+4NxZLWuE0+8jD6e1yJwnbfjCnpXuKysXjUoy9Z0itd671RhdSoBZay9OkiphSKfibd5kTI3EAaYyXzrOXzBALyYE4tA4uu0VvgMnLcnvZi/1TfXWc3I7q+DU6N8e3lTa2sq+DJBcPIN8wK6uES1soEfGqoCmFBs7Qq33F7bz5JjJQ8Jk9y3v/nmHQTasYnJqv/uuICl3rPGzxMGNOuWEo5xZdvnyP7rBibE894b7uBWvRujg9lvjT3Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL3PR12MB6548.namprd12.prod.outlook.com (2603:10b6:208:38f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.2; Wed, 7 Jan 2026 19:38:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 19:38:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mark Brown <broonie@kernel.org>, Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic folio
Date: Wed, 07 Jan 2026 14:38:29 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
In-Reply-To: <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
 <13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:a03:338::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL3PR12MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 86cf70f6-4153-476c-b568-08de4e245885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PFoZpTUJ9zS88Tz/WaAmetaKUX1sqSCPCqOwQnZAhVslRKGDE3pmHg20lZsH?=
 =?us-ascii?Q?sxU2ccYBmJ4E6mmr4mTC0DPLCewZgfo2D/qwen3y/0ufEiLGJQaKppza7iPr?=
 =?us-ascii?Q?BVvTmWkWilqvCESCqTjMa9QVXZxI5HPulk4TmpcHt2fbG3Dko1i/DOLG3NJv?=
 =?us-ascii?Q?wnTPMyWZGyJVd/CnaEVESwwZ7Nz0gI8O+pD53JtyGjTuIiJvNq9Ou2Ln1k6q?=
 =?us-ascii?Q?dr4vA4C+pvh1JLuhBmkURV5OOTFBuMpxVOn5wHurBOaWfQErCgJbKGrGLS5p?=
 =?us-ascii?Q?Y26wuKxK90R3hLRgrf5XtzhJEkVqlDnPVwtYQOGZRtfgP6KGaDsUH6wAIf5/?=
 =?us-ascii?Q?aMFUFct0MS4tRUW2nqLLws7yC7wIGnFM9WnVyQHVNlpC8NndpXcsjQK30hr7?=
 =?us-ascii?Q?3EtdkKDavR7+45NHJ9Drt2PIafvks2swlvzDTMXjLuLdf7N1q4y85a5k2Wee?=
 =?us-ascii?Q?QibWvoV3EtGiUWLz3pq4TjpbdauxUvSENpSQxoQ/Npno+bzXSDKQd11nX1ue?=
 =?us-ascii?Q?9wrmyKR+o3Ee3zUnIUmR7aepyilmKVybTEI2DaAOLZZwBH0d/3RVgv7elmOG?=
 =?us-ascii?Q?pYNwIfBoatf89+cv0X94STGouduRQci/1btVyt/ANONyqYnJXnFLX4Q5lUUr?=
 =?us-ascii?Q?zMdQ2LZTzl2JcyXEXdeWtVr+VmI5XoN60ObfvUIQrcJ2qf+ED5FZ0UzeADUo?=
 =?us-ascii?Q?OrNRRIy6HNl5XG8+ZbhNLBMWJxY3tXndUUZLZFFDI9LFFXCFuEuLpEI6tlq0?=
 =?us-ascii?Q?AbF5Op56Zosldc9MWhvGWByRBOp/86eXk6MdAG0xRqAL9qk8dJfCL7DuyZZE?=
 =?us-ascii?Q?YFE+JAz/jtQyh+zF2RE0a23HseEd2vDndsMHOf2HNKSN4pbNS1/D4cVdzylW?=
 =?us-ascii?Q?L1MncNQu5Vhi0TU+BR82VsMg0GQ+flWF5DcHs8c1Go8Wofm50ALeWBXDcNWv?=
 =?us-ascii?Q?H5rrB3QoCL4Z9GPhLammdjiI7yJc8ztr/Fu2vCDRMB6LUUqx8gZ2z/WdQplu?=
 =?us-ascii?Q?1S+TWwSiueJL7ck5unGnmnsVyaUrJGBo7SJYwAlM03rm7rtVlvyJydS8fMRM?=
 =?us-ascii?Q?lhSfJ1YqsAsjEVAFuP4c7z4cPH6/pSXbWb03JGA6vN2uJdHGULTQNDzmPyuq?=
 =?us-ascii?Q?0oG9tqrHpHf7sOQ3aFsHOn1ppbQb6eSkHUJYbP+g7zzOL36gQ1d16e1uEGy8?=
 =?us-ascii?Q?ShXLpcfw3JuUNbT4570+8L1IH5KhP3d5OilN1zz2aFpqyPXpudzs0zHBbiyj?=
 =?us-ascii?Q?9EI2TmLcis1NbZ6Ocv4wWbWUoljzXPUUmerOIqjPumm0zamdVICPNnE0TkaL?=
 =?us-ascii?Q?9HvWaKZJjZad/CVvfCHkwkHagjR5O3MXXJTNFO1wq7t2Zbu2xzkSjqNOMPfo?=
 =?us-ascii?Q?9jj2pktCFp0HpPYx3rgy7gx65tz+/QGcHDde+l0uuyBvKAVwMInjlJT+UoSb?=
 =?us-ascii?Q?jkDvJVt1pXLVH1al2CTEmaN4c7SZD8CH+el4rkrXe5iVOMB8/wxiCQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C4/vrRnqKmqlf1r/l9V1zmtpJfCmeAosyiYkELouUdS97xGgNxw9FLEdh5f1?=
 =?us-ascii?Q?qHa0gesmguNV3KZW90BslulTZRqPrfMnOwrAZJtE1Wfvqt1MRcjf7hZs9qtq?=
 =?us-ascii?Q?tkNC8ruEcJz8omdgOSUGnoxtnhXgq3UcryVDN/QaWMTpG86cN5yL9bVBolNK?=
 =?us-ascii?Q?FfKzeCIwF7eiyualveh0DJ0OFZr90hyVvXAmDhq2OUc1Fo55kXdAm2GO70gt?=
 =?us-ascii?Q?bgO0FxjxJXtMZO8sO1jhR9AZot9Ex7a36AtwN87bGJWeHg96paGZ1zJRDMy/?=
 =?us-ascii?Q?JdyJobj13i26WrhvFq3ic1WN/sEFhvS4UsKf6w2vZ0VwVm6r8mv3F/t7lnbw?=
 =?us-ascii?Q?vVoccjKvIVkx5rmJtxKUn9JJAgyjoSRFN0zZRvRDZo1CmoK5J2P/Rkmvlsi6?=
 =?us-ascii?Q?WoDb+HMWF6AkjOUZ5hSem41PVDGY7LMfpSdHf5lBj0as0UPB/adz9QeBVWeR?=
 =?us-ascii?Q?AKJwMd+RdGFDagjr8gWuDzY/FADqOKRoKik7KUAxhiKxr8elCEknc8MFjwIH?=
 =?us-ascii?Q?yZKhKcgE+xsg+vtyzM6iRaYPCP0EXHkGo9KYtTTqKhPLGAyY63n99EFqrC4k?=
 =?us-ascii?Q?cmqvSRc/Cvq4EeDNADVC9biP7kudxG6sWtM7X38vCdFLN41Y9PSXQIg/lmFp?=
 =?us-ascii?Q?BE/PuLZ7u9lMWonf6KEaGhOAU3z2Dk6mWlaG5ixG5jyPyIEnRnbBqvIWD9j+?=
 =?us-ascii?Q?3xXGOJHsQjqoGqnxCvFlEK6Yb83FUYGZPBSwufdW3C6g/BGv159PHZ1lYqmq?=
 =?us-ascii?Q?cJRskDCk7Mrcf/04EOqrUl543DTY6RZbPoSi034DHQGlL6WzVY+tBOE07VzW?=
 =?us-ascii?Q?g4sd9o+1XCLH0Bgc3Dad+1sd+zN9o1BHkwIcWsevFmsivibgewggtklKLbwT?=
 =?us-ascii?Q?9cDL0Z0zEq3/e/M5X+ubU4lzwiMSOB46H+d+JQ7ssxbrelxrsSKJBsNiDzLf?=
 =?us-ascii?Q?ig786KZ2D7hkTSDprXXOmGErk0lSVeFu1tugqJhObpXHEQxJqtCM4JS+vK4V?=
 =?us-ascii?Q?86TLBJ2LwPExoxgheMSwNJJsHncouvN/Oe44xYqgg+DoRvl8lX6NcVs27kKO?=
 =?us-ascii?Q?WTkCrNkSm8jDldrSTN8wIKOI030H0/8ZCXq/V4x9z6rOxdoF/++mhBwdbEY8?=
 =?us-ascii?Q?xSZDzEVIYlY0g/sc85nqBW3FZF6AhyQARJ7uzlSAfFCYUBl/0U1fvIvu1gDL?=
 =?us-ascii?Q?RO8lohSKI9hoReeCwPyl3pHZ3r4zD7LsYyzJ7Bg/mP3iSr2uJS5eKhi/RrI8?=
 =?us-ascii?Q?O2sPSGwpjUSji8BxlxTBPRPkIt1DlHZnwQl0QPObcfXtmQc7lQCjEIHNT56m?=
 =?us-ascii?Q?pUHaG9DQmjMivzCEBFyY4PDRVT+Jczsv9LHt50gJsHkqGYG4r1R9VP2z9Fs3?=
 =?us-ascii?Q?28SCdRtMTuy3tam2wluTPwJrEZ43T+EPyqHxDfUf69gAcsISyAj4YPer4zo7?=
 =?us-ascii?Q?UhS/lwhIZe0IhMlBuqNUuBuOrroNQ0J0LJEQywsTeh90gTCkGDdIc6AlNLV+?=
 =?us-ascii?Q?ARr13L67B2EIkZyRJJQ50cEB7sI7hCvb17b7jnsyuGy5xCEojpp3BFJ9XMrc?=
 =?us-ascii?Q?lArH2527jBEmA2ZgI0VXzTiqIJSwjUBOjRl92XvA42ND5mAl6SUsxcOmCE2F?=
 =?us-ascii?Q?ODJcATX5d3S3PO5P8+m2y17xsZzoc2RAmlOPT/w518mUhx/GXxPXsEsFkl3G?=
 =?us-ascii?Q?tE9YNEwlHjdaEYMWKGgROdJvJHJP09lZeh0/HZtnefLJOAbD5ur39NM5umkD?=
 =?us-ascii?Q?tl0jZV7g4Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cf70f6-4153-476c-b568-08de4e245885
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 19:38:34.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NMT/92eKgQckfT63EUXg+Zu7NEZFvWiU1FO2U5c9SzKdcXZODPkTQ9bKDNebZjNd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6548
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BF7D100002
X-Rspamd-Server: rspam04
X-Stat-Signature: 4wy8gsidjfshqjio9aekspxap7rraysh
X-HE-Tag: 1767814719-977032
X-HE-Meta: U2FsdGVkX1/8JKqUqgy388H5Y/AaRcpWeVCOZvK3NqzTCKSbTgQTsfqToJYfptoL/KJ1NzGxLx7VcBlJJhOcbYy23OrPBxmZ/kdsrcMLsVhmEu3A1VByxzIzh+h6ARaWuMdR9LBHioVNQNbAEgw6O6It04uAMzccJ96A38BcqmVuqsBJo0pj2oZ6NWmT9WuuNgMu3Lur0tpv4TVmZ+JoFyDyvZi3+NIDTtA3/tDB3h1SbAvTJ+bKpwkG1WV2KS3APpDdj1pk2rEzR7sMyXebsEolLuSR3D/xDFzo4GoLGb6gQ2zrNkR3HwRwiYQ2yIjQJIIz3h0HEyoBfPOnKC0T/dG961NJeguQAFaJIozLsv4dXd4HBGIxvqKOLSuFvAsw1Eb6EwINVG6ipXjrLw8BKJpzEtpCaNM9rnrlh1cpuZAzOsoL1esrvNzY/LJmocjyLLCyDq6BJ44XwpdY3BXn3llgaCvxYSs/ayxQkiO280s45C92ihF1whUdP89pAoe+Ic5HSUl1jo2fQ+1D1vUsaWtMiv5HKbXmAVUzahwujKCvoHB8N/tknWh5WsbHmTvDKol612mF840765uA2gT9L8AtcWV3v3TzvgitcyqRCMJz38bWos+WyOPoZipH81ZTnuq75EsXxLsi90BYPmr4iOPaZzat2ZQaym+tBFpDYBQ+HqaTDilNnKtb85ksSIUG2eEriyXYlmpRDbGD2ZXabpFAMzG3GebuOVhH5X1CL4FOY8HLDw0St2ayRrAMXLq+GeBrYnOhSqstEREaH3mM3Z+WWljMrlh2/7imdt3RADKNwjCDKZP2eKz4b6s/lTiNYFh7JjSm63YU+jb0cEI5/2yF8a+fJHZoBh/bhYH51q9JzAI97FegcacVFo8gqoSNfqawFaa0ChZd07HZvHiThVko+MkF3190XAKOgCoNz+lyyoQDH27rdpwg88d52gx5bv9u8TE9A8bBMy6CIVK
 MLWZdULX
 SHjHy5KnVPcY+ubUdoJm3rrZouf5zDQdvvj7Ntn3uDYCA3iTvcMz/6D37a8YiAkJrtrmpI2MU+I8imrTNfaU9EzxNV3P8iBBsMOwm85rpqnbkHK+HRR+RMuIgvvNfVU1BLSUxqGJh0GIuNd2yOgeFzBGcDP5EfIMPVtNIcbHDd8b0fxWj7rHfZSx3JF1cOi8GzBKyKTk2HCAwVeSG8Nqo666UooL825PH4NVb2eHFBHZFdHlFI2nzZtRJkjjh2yr2mQ2fWI3fL3b2SiSkurs/CTMANZEAaPd15/U1qrT2N7oR9C+3ovLkmDKx6jLiQM85nu5DjSX8aBVOn7mhnUUzxZrYRRmZZpBSZMztfNPgp2flLFxpylq15BylyjsA6MtSAdanyUo1xqm6gW2Ec7CiH/mP9lK6/VVu2+qrhhRhb9oMm/ZzSnL7DTW/xCWBLNEZHZaP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Jan 2026, at 13:39, Mark Brown wrote:

> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>> On 12/30/25 09:24, Kefeng Wang wrote:
>
>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()=

>>> which avoid atomic operation about page refcount, and then convert to=

>>> allocate frozen gigantic folio by the new helpers in hugetlb to clean=
up
>>> the alloc_gigantic_folio().
>>
>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing s=
uspend
>> to idle:
>>
>> [  129.636729] Unable to handle kernel paging request at virtual addre=
ss
>> dead000000000108
>> [  129.644674] Mem abort info:
>> [  129.647456]   ESR =3D 0x0000000096000044
>
> This is also introducing OOMs when doing at least audio tests (I don't
> think these are super relevant) on Raspberry Pi 3B+ running NFS root
> (probably more relevant):
>
> [   64.064256] Unable to handle kernel paging request at virtual addres=
s fffffdffc1000000
>
> ...
>
> [   64.087583] Call trace:
> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
> [   64.087598]  skb_free_head+0x9c/0xb8
> [   64.087608]  skb_release_data+0x120/0x174
> [   64.087615]  __kfree_skb+0x2c/0x44
> [   64.087622]  tcp_data_queue+0x948/0xe50
>
> Full log:
>
>   https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>
> Bisection identifies:
>
> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_froze=
n{_compound}()
>
> as being the comit that introduces the issue.  Bisect log with links to=

> further test runs:

Hi Mark and Claudiu,

Can you try the patch below to see if it fixes the issue? Basically,
in cma_release(), count was used to drop page ref and decreased to 0,
but after the loop, count becomes -1 and __cma_release_frozen()
is releasing unnecessary pages.

Thanks.


=46rom ece23da65ea7210e1fcb51ee9c27aec19b84811c Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Wed, 7 Jan 2026 14:23:15 -0500
Subject: [PATCH] mm/cma: fix cma_release by not decreasing count to 0.
Content-Type: text/plain; charset=3D"utf-8"

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 5713becc602b..408b07f6fddd 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1013,13 +1013,14 @@ bool cma_release(struct cma *cma, const struct pa=
ge *pages,
 {
 	struct cma_memrange *cmr;
 	unsigned long pfn;
+	unsigned long i;

 	cmr =3D find_cma_memrange(cma, pages, count);
 	if (!cmr)
 		return false;

 	pfn =3D page_to_pfn(pages);
-	for (; count--; pfn++)
+	for (i =3D 0; i < count; i++, pfn++)
 		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));

 	__cma_release_frozen(cma, cmr, pages, count);
-- =

2.51.0




Best Regards,
Yan, Zi

