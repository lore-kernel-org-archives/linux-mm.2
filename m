Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5A9CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 12:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FD98E0006; Mon, 15 Sep 2025 08:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717A28E0001; Mon, 15 Sep 2025 08:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8048E0006; Mon, 15 Sep 2025 08:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45D2A8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:11:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2F791605F9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:11:20 +0000 (UTC)
X-FDA: 83891369520.25.2C0728F
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CF3640005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:11:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJOhYeDv;
	spf=pass (imf07.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757938278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bx4uWWlu8yYCugcQZW2osJLjgLaur0EGG/CnxUsdqwY=;
	b=CRaF7euLgDgoJ1/c9I1h8+KibKLh7/1GgB9ha9f4sgmRH2BHhuxElzI8m+VebNeC11uKvF
	9Vnl2coFeku+uk8Ah/YIsjxGrXdsdtc4M9/piu5vOVzlebwd+nxwXK440Ga5viSMG7wsJM
	5JbVMkDLWIkn0+9PUKYNssyV72+Aahs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757938278; a=rsa-sha256;
	cv=pass;
	b=D5mPXSFsohJ9zdjfgrhFBmkobGpaI7iq/dbUgoNPbotj+CIOqdfuE9cXyHw0IeogcFMPjn
	8w9Myb8LB38J955XWSl5hPn3PDUOhWdIqilARctonG76g/8F8eDHxcjihAR6sU0dFEFAdD
	Kz9as23n1PrFXSJAFfIpw0bwgKC2NDE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJOhYeDv;
	spf=pass (imf07.hostedemail.com: domain of jgg@nvidia.com designates 52.101.56.17 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FQrQAg8fwI5o0BvmZDCf6ejxPbckcuaEuPFHgzp+/YlfS9GfsRR93RKMBs0dRfo7uoMisVc9OFSCC0UXqkwx3sx1Jl1/zKDkQSVhm67UqR7u9pafURXw9SdH1ImES9+LWLtVJuGImJSlN09HdIvaYoPt3exBdQjiLEayJ+Np22Q7rUiFpTrSDnehV3GtVI/mmtklLMjZYpaO7M7CwQBVaJSSL/AYeuuhpq4zi8Lg+f48eABtincCLpTyyBdJQmElouv582v+dJKrdEsulbiVl3jfmffTdyR8d9cHUclGyCQGo17Y07ciOxH/1SqlWoTm46YvdQKtkcsE0aVULILVEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bx4uWWlu8yYCugcQZW2osJLjgLaur0EGG/CnxUsdqwY=;
 b=PKmTj/blt8jcKrf1rlc1cK/EO5bkvltofj4ygUhG9D5JCd975xU5tIpsjfapmVj2kOEFgWUGL3mtoWGi5SXTkxb9JoeHEH2V3wBWMbrTLhlGvTu712WXPhulMfzULn7tWSMDeXMKfvVayKmiHTlfcqomck3VDyf55dw4hfEgVl0sbsAhycKQ1nmamEdHuam+e+szHqEU/JG+FwGwTnNO5zH4+/x123/gjNzGIN6r3RCOw3cGLXG/xTWE9XCHK2y0TBGZqURTdN3AKhJg1IqDW02aIzt8S5wG3COpetkMQTzdihsMQebCu98U+/BJ5bFCgdhA3m/OJv746PfisyM6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bx4uWWlu8yYCugcQZW2osJLjgLaur0EGG/CnxUsdqwY=;
 b=IJOhYeDv7fc1i0khuTADP6IIOn43s3DgckE0hMs1IMBXi/vvIwG64gU+XqgqmVk9jOKtRBJVKMrINs8IV3Ui2bccifyujPtLbosoxrc1g9rIx1SY4HxAeBy6jNZlGm5eSmr4P2GS+vwFx3aIoQvYq7uAHtBz+8d5ED6iqhBwuo4q2RC9G7iY57Iq8ju5nDtXp+EKXKvdvTrnOBm3i89FQGNgZyaUT4fEvJVNIVQELJtAAaq2MiavvhUGaGe6QieV4mswrDmiBEtwc/Ynkwnjcl6r0bC3LdTNXX9hdY9AiraErsA5anIl+lJO+r8k3joOKxUd9Ii2IC/xOCMm5oDmyw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 12:11:14 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 12:11:14 +0000
Date: Mon, 15 Sep 2025 09:11:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	ntfs3@lists.linux.dev, kexec@lists.infradead.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 08/16] mm: add ability to take further action in
 vm_area_desc
Message-ID: <20250915121112.GC1024672@nvidia.com>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: YT4PR01CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 4082ca6c-3820-453d-8a18-08ddf450f784
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dzsySAwkFVc5J7k/gJGmr9YXF6rld3I8L7Y9nzDZoHSX+fOgM2GPdL7EA6Vo?=
 =?us-ascii?Q?uEfz5IMOPZhiebdbzHEQqpCp0DIgrbnKx6Gg1VLLudlPB812S0nRIZZdn2N3?=
 =?us-ascii?Q?2v0qvhxj5uhB59qpfseTP4JXSuHKBhVCtfTbGBUBBSSsPSZQf/vLzC0ABy7u?=
 =?us-ascii?Q?aWFLqLYcSNBanp3S3/DxXqmq7Zc/F+M+/kJtGMEJWsRIp/zogAflhHMANvI2?=
 =?us-ascii?Q?gpjQDXq3RzrpWHonIx0jZwZmSGVbSdYQp9s0DkZQkOV8khbb5Gunr9IxXTPs?=
 =?us-ascii?Q?s6hjVz1EVX0j3A/MUM5n/etizjl+dkPV94A6JSem07417uQNyisPtyRdUwFw?=
 =?us-ascii?Q?OjNTmbKM76+zMjs+SVaLoGIF75dtN7fxxGubaqWuvJngyrNop5Ha0md23JH3?=
 =?us-ascii?Q?VNqrT+FZ7PBmvSCxDB4H02PXnhczW0cDZc9wDeg9tiYIxMHC7ElibLqYlj4K?=
 =?us-ascii?Q?BxLa0G5d9IWSEx6TQ4mLx7utF6aPJ/6MQ+Pd+gQAIJbu7ePahUgxUIEmuBx9?=
 =?us-ascii?Q?qe4OIG7RkoCuv6S1gg4Z2OCC/v3unmoEFG7vsUAzwCb0S6qQAVNlglYsR6JN?=
 =?us-ascii?Q?hDwRVkV4SucBmWUdtNTAkPzgZQ16W3zhFEBH9fufRf1K3ioe5ofyEhNBNmyz?=
 =?us-ascii?Q?k1gI0ip3MEm4bqv33iltMrFkluE+qG7+5qpzLX4OaQ3N98zoegTuLp4eipGn?=
 =?us-ascii?Q?G4sAesxdDI3LD3wJfKjF2aUmqfl7aB4lkiIp5DxoyePdaX71pvkTYZctJebv?=
 =?us-ascii?Q?Moe5bGlKESGR8OC2FxkP99MZ7om/VsJjgyWCHzEsYAg3dNF+wSqMhdLKT2bU?=
 =?us-ascii?Q?5lFfWtpo4bOKJqdH+gJPQThIdwww73g8kcCyBxHY8X6U4IretMj1eY1buWEL?=
 =?us-ascii?Q?vWr7LvY2UlvGk5o9WZQxrNmaASoauxkCMSPqA/b816c5XZj1Cza8tq4tCHCX?=
 =?us-ascii?Q?13KSJaeFyTVbGt2sFthvhM7jWpsGI6al/VPfMkHtBMU0rpnf1I14ogSP2ozH?=
 =?us-ascii?Q?CM31c1Y9842aL5l1uCArrjJeB5SUNZUcicoGvQiPR6qg3JKBm94N5Ak9YHTz?=
 =?us-ascii?Q?mcbtm59LeiPUvWGizY3/nD6LAUvKcd/U2fqwojr19p5Ws6uwiHoDAHfHFMpV?=
 =?us-ascii?Q?gjFMlCaOqXJmyb4PE8wAcwj6kvAEl+ry3hgtWoIOrjxSSBYrnMijXHtvpauO?=
 =?us-ascii?Q?Icpps3DoUt11a5X6jK2EeRj/R1mTEbAjLKCXTlH5Zbh5WP1dEDcMwsPThqgK?=
 =?us-ascii?Q?vaWFBvPIpkfzXsT55X8OJNo3sxHZff5bs9Ostg6jQREMZOk7zUnwkp5ueGQz?=
 =?us-ascii?Q?Rro070McqwpY1VxHxZA+uIZA8gqlGcadtmgo6OZF1t76qM3W73M8YEfV1Oeo?=
 =?us-ascii?Q?GHaOt2yVk4xozs/fOg9Tn7eoK62JpndnV38f/1SuQhR1IHdTxFF2KtIqtgsv?=
 =?us-ascii?Q?450zTlfE8Ak=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KVKj9+BouTdnTX+BdH9uwWNlRf9+k8iuqaBjUMna9pcCNwfSgbFkdKi6mnDu?=
 =?us-ascii?Q?0KWrnnPW5mBGhx3N5ojzL5bio7BSpG+yFFG3ATjikBcXTpdRqv7cIjiNo/qJ?=
 =?us-ascii?Q?EeAKVN7kEyc0ipGhxEJj+C6i0pe1hWFUOGDqR4G3e7IcmBAhU3xtYMr6QsZr?=
 =?us-ascii?Q?DOXPiU2zBdknVJToIxQFjpG8kRepn7u+FgXhklLePUo7JTrIUbb5SQzSxZT4?=
 =?us-ascii?Q?M3VehJ/Mqwnz/JyBYW/DSVpQjc78jWNX9EOBxRt3FVxHkGYlCdcy2ZECydal?=
 =?us-ascii?Q?SYKdLkbJA8Nhof8L/6DYa9C1bvG/Bux6TV/1aq9s7fWSuMGN7DaiZS1rlAAA?=
 =?us-ascii?Q?g/fbF+/Pz0laxRCtEOxc9hoKz1DKiiGYPBTC9jIOfjQk7pyZD9+5ZbV+zXpy?=
 =?us-ascii?Q?7VGq9Uztn5fCim+5jXc6T9pwFW5wYSJmSUqbukuo4iod5lk4IEWqe7/6zzDl?=
 =?us-ascii?Q?nPFT2iKrR9LceG/0EvAcJEuJG7pByPcMg2Efp7zLkMuP50waGHq/PpFAorfK?=
 =?us-ascii?Q?HvPq5jikhZp8XCFYeYzMFnotwJpj6gzs/8k4STa+oxrnd2UAfOq1ZQ0bfVHL?=
 =?us-ascii?Q?Yu/DS4OULMx4D8VI6B1AAI00+hoyNAt3vJCQbzLhAPG+ot851P8FCITNvBgB?=
 =?us-ascii?Q?owphiWVU/VAWls5uwEtO/OX1u6mo1qO8tErti0AWa45JqIbNxcjX37pp/4Vr?=
 =?us-ascii?Q?f8mpZMQzTwGKOCLaK9fn5V7XbcPUGqRGJk25bMJuJ0M2Jhx88EHRPUxXRPNf?=
 =?us-ascii?Q?6l24bvhY/l7qhrKYq9hMEnqEvHABfSmx6oMOne6dBh5+ghbm0JWm4Kgc8Lbo?=
 =?us-ascii?Q?aPmuO3BiJIcmi7kx8WIPiLlrwbc3bGNLimhzciIXYh8GKaBroFxh2SGntcUf?=
 =?us-ascii?Q?m40Jj1YNgW8VdTdyfwVefbVeTuQ8s/Fm8msHqZlfoz6D2sTdNfXzmLvD7at8?=
 =?us-ascii?Q?EP1eG/dgaz8ijPbA1ef6WP7a2CkjyjDGomOpytuHEqHcjlzg+Z1Z54ptov4w?=
 =?us-ascii?Q?yLiFAU0csnjarMQcN0ZBICbQcHQpqJsKeMseNJkM9wj2EowGhICS/c3qoc5o?=
 =?us-ascii?Q?iXOp5DcaEwX1Au4dW3Q/h5P+fRyT9/Mp33e6qnve2DRO4+7XRGjIX2+vpl6r?=
 =?us-ascii?Q?UStMCjVEOSaNqubJJwosATdQptN2ZPgx8Y9Th41jaW81ttGgehAW7gxEUEGv?=
 =?us-ascii?Q?PahBSxPzmHwUv2tjbZ/bqQ6L9U8f+CLPx0RB6PVvnuH08ii0byYqIF+SU59d?=
 =?us-ascii?Q?XRyRmkpq34ONsM7RzSgFO7uT+LOQsSGvRCcBsE53lAcSbz2k4psjoi1tLejl?=
 =?us-ascii?Q?QkVX754z23S5iQeTP8T3uNBfcYA0JFGo/kNW88onTJ+i7xTgXWq4Sjtw3yA+?=
 =?us-ascii?Q?IAS4fWs6gw46kTfkI3mIsk2z/vqm//0Dubcv0Kl//PMoWUHlnKQSwGt37ANG?=
 =?us-ascii?Q?li3Onq3S7Fy4H8wE18n4C7amp6T44Ia7KJLWxHU5xhqhOItsMm54ZxMUqc8Q?=
 =?us-ascii?Q?+XXSHM+OuSmfl++PuzBOA1KATMc107FR4b/poyW1UnjKPxX3DrsQcAZAVnmu?=
 =?us-ascii?Q?IKXCdpSj7k6C3fdSZPc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4082ca6c-3820-453d-8a18-08ddf450f784
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 12:11:14.5370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRRlItnu8SXrt4No5ZKs065QCVFt6ZERgEYfgL4f5Cw3eSNI3JMMNoyv9KZ9Q9ns
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790
X-Stat-Signature: abu3qgxc9ez9p4z6nea3xocce1x7qofx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CF3640005
X-Rspamd-Server: rspam10
X-HE-Tag: 1757938278-130037
X-HE-Meta: U2FsdGVkX18ivlRDLN/bkvUsKySPJio/p+oH5lS/TuHgoZZ0lBh46tMuh6Qa6PUUROBLIMhVgyU/jibWvxOtekbk30g79xk1zucG8fExeb89gCVTLdC7mymEmeTcKPDIlMuzcwOSKwGU9NU9p/w5p/UMfRevJXdaI8yz/+tUnEx1SmJLgXIMdt6LqHhkIWd1mFRuZ8c6/lm89BSY3xMnEAke4x2o15+darpgmjc04flmIRV+O+v7kLQKO31gZ0Upyr6+cw2iYVnRl65oPr/MFd1ImYKAHJaLvfnwUXe8JCWX5oWupdWeyGb2M9kNsRGOZoTQ2LuDSIUFxso1r+MzR+8tZdmsifYqPZH6YSoY7S01wfAx1WPqMAEQ//RvjybE8FtY6pJi19gQXmOsSMZQ01hgOfLo78FQD9PuHgFeM5SIeCMQRgJwoSFFJ21Tgw9R0HTKHWOW3l9I1rVpD9exnLCsuJvoVlsze5KKQsbHZrPQmAnXWdkBHs12XAeN/6XvfDo+kuaaG5U8aeWHuuyC8PGtJAOsgcufIwqUqRo7xSvW7KwG8LdEMMk9Z5gCFmD6c77uUZxTif2RdPmacRBzhIo6Udu8eSTKAej6JIAKjnIeSKcLRjUIktM6RrnHImk85h8IKGyvnuWerAiOMS/qNlYyGBzlKrsDTwdNZG2fPvTi8l3NBd00zIwr9Go4w75c6Qj+MnlGHGPkQaEQD+5JpvJA0nW0qQOMeSzLWrcBWmHhzk+ybEOmBWyOgXIk3C7e4zudQCT75z9DSYzqwPJVc0i/dwv2PIJ90ZIkgcR09bU+DLHtxmH4QJvaSj1Tsfi+h5N/Qy7FW89e16CoRyzxYnYcL9XJPuJvJ9zi0blgAhxYVOfkvCbyZygAeUIazoRozVeQAlve3F2Omc7GGsoX7PEmtScoOMWWAV2RJiFfE0XeSVCP+WHwRnBeOWIWHCxBZqUM9Lf3EjV2411oX9g
 fhxCFLQl
 V4Y8TZ2D6McxU3PIGciSeva7skZ15wXXZ2gxMgYtJs5C2FMzyB6XCPDkFl9vf9R6yU7fvHjAD3zAKI5hMM943meJIlrsovR+rgHlbYYbqRGbhA+FkHsK2npcgiN9bv1r6WfhoNwAAlqW3YgTIR6RVptZy9PmW4EaHvb2EBq1tgazz7azyTWZ6v726kvxkefOnVm4YpJR3ZGYrkFoH5rzWYb9Y+vErdPn5kYWV+wKuYnow7gY+ptDWRwQL//j3xyJ/8BpSEBLpbNW9tVWyy4p/K1kP0PJX/gG51kbH4reUrwz/n1P3+i09fiTOPYxAWwt/N6oTxodG1R1tTdSu8kDrjDCgJe4fSRptz3ho5lWiHkj4RFec1utUGmIRJU+XsMZkoFzB1ZslNHvr+s7iFKNeiFzlFM1tyoNTw9dPdyUIxqfi1Hd+BetXnmUYiDbwfie/tytysKM2pIjFEz4Hv89DMujEUN1GNXuEGG673q77RPiyxWL7obpHmAt2Ao8wjXjTS/ZrQMRxFX/6C4ZroF1wBoomGd3WO5AZZ3FpJa3i5YRThoA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:22:03PM +0100, Lorenzo Stoakes wrote:
> +static inline void mmap_action_remap(struct mmap_action *action,
> +		unsigned long addr, unsigned long pfn, unsigned long size,
> +		pgprot_t pgprot)
> +{
> +	action->type = MMAP_REMAP_PFN;
> +
> +	action->remap.addr = addr;
> +	action->remap.pfn = pfn;
> +	action->remap.size = size;
> +	action->remap.pgprot = pgprot;
> +}

These helpers drivers are supposed to call really should have kdocs.

Especially since 'addr' is sort of ambigous.

And I'm wondering why they don't take in the vm_area_desc? Eg shouldn't
we be strongly discouraging using anything other than
vma->vm_page_prot as the last argument?

I'd probably also have a small helper wrapper for the very common case
of whole vma:

/* Fill the entire VMA with pfns starting at pfn. Caller must have 
 * already checked desc has an appropriate size */
mmap_action_remap_full(struct vm_area_desc *desc, unsigned long pfn)

It is not normal for a driver to partially populate a VMA, lets call
those out as something weird.

> +struct page **mmap_action_mixedmap_pages(struct mmap_action *action,
> +		unsigned long addr, unsigned long num_pages)
> +{
> +	struct page **pages;
> +
> +	pages = kmalloc_array(num_pages, sizeof(struct page *), GFP_KERNEL);
> +	if (!pages)
> +		return NULL;

This allocation seems like a shame, I doubt many places actually need
it .. A callback to get each pfn would be better?

Jason

