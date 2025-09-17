Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A58ABCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BDE8E0012; Wed, 17 Sep 2025 08:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023268E0001; Wed, 17 Sep 2025 08:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54138E0012; Wed, 17 Sep 2025 08:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03E18E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:23:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8465B1A052D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:23:48 +0000 (UTC)
X-FDA: 83898658536.29.43FD623
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf18.hostedemail.com (Postfix) with ESMTP id B72B51C0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:23:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MNh3mCPm;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758111825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+8gQLIdLt/aH9rVtxf72G7JSm0BzInQ1KAeU9N4iSY=;
	b=NykUHLFivPoUOdmqoy4ALlB0ZayGA2WJ00yRbwk3wagzSgL9dv8/OalVeI753r6sz5T67t
	b9JWRqMae56mSAS836aSNb90t+vZJ0nQyIJfU5ehMSQDn+UeSDISvdwiNndnBXSol02CyT
	4JSQnUouzP43rIrHFuBi0cwIv2kVjuQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MNh3mCPm;
	spf=pass (imf18.hostedemail.com: domain of jgg@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758111825; a=rsa-sha256;
	cv=pass;
	b=DvdUa4Vcxzu4n0ZRGPypF3N7vdE78Oyhg3mcgOLEhVdexDRU5SDNuXuXZa7TMCYFIPK73M
	Ri1eP6cAL+Hsp9O2I2zqEkTTDWaQOysqZO+g8ULIo9Zmd1ZI9lbGvLkQSmE0QgdnyVL5pD
	r4MYCoYo1esqnNpEGaYlYRjXmWzJG4w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uw7YUwjqmhY+O0eHsZWHBrRiWXWTN9Bzn1u/TYsCvIQd2JulfMjzV8DH9UByqdEKFeZgLlP9IAXBdCzSCgfFEOFEpIBmBS+PrW+PBxK7sxpfSD6lf7QuPo0SPymxwj5lMviHcENuvbuzDKNfCtcvUqFqgJiOBmy3NULmw9AxsFE42lIcBJ/RBGikHJCS9+Nh4+pflqeFFRtMkypIVlGH0k3V39KK+WKqzVleh8oE9wzjfBMWqMVc6ooNSaUzfiUnChnbUva8OG/pH43ZNrFT0C3XPbU66nRWWtAyf3JdlsPoBr3MNeRZl1xcMmcMm5pj+0+A8s6Yn48+IoOO0BdGxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L+8gQLIdLt/aH9rVtxf72G7JSm0BzInQ1KAeU9N4iSY=;
 b=AJgur9gvv5FHJB2Y9Zby9Tedj+lZ5FzfjjTR1I4rAObL9NhzR9U7jEZXOp8+Ol3qC1u2a1hhS2k0xm8MRP+dWJB7G78fJdTodCfP1kfR4DUO9vEYVw3GbJLm8/JcZ8j3qa75N+Pf95Fp+5EGRbpnWVkVoDX3Yk1PTAtdCvl4Y5JiD6BBe+d93BwwId6EFPZ4EFakj3w5NGl3NZ/MmPfdisEBT3DIyHsdpEzJDgHAzRMlRSgxGZZQMZOo9eFgw7kzcpt3/7mP0gp+WBQLKMsp+0g2hoY1YDaFXThQzZ89S7fsqRVuSmYpb2B1+BC4UZ8YovCDd/H2hz1idh9M9zXZUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L+8gQLIdLt/aH9rVtxf72G7JSm0BzInQ1KAeU9N4iSY=;
 b=MNh3mCPm9p115fUP1TYRlayFxLNkos902NcG+JqGpscGdAVjfEJhpxdnK3zr6cnohbFrhsgbbTuWr49F/02x/WJts8qF8HfpjicZNreBwgFkjcNtUjw3LfID6S180HUF0cS9zaYdYN84Kcnj1Pk+6II/Q4ZZgmgwwv+W/jmWsJVoio4/bzUu4FCaIHWCw3coFflNbHZ5pdHC1m6owXRxQko/WdabKh+/tXuk+kz+XBoP0sYQp6Sj2v0uJXf7xb+CnDmx8oTCg34AaxleSG+TGZ4q7UI6+6QQJSUBK/dfwdfMrMNV9JqApw3XPs3ujBBCKn5fvPHih3S5sb7Hu0PFaw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SJ2PR12MB8112.namprd12.prod.outlook.com (2603:10b6:a03:4f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 12:22:00 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 12:21:59 +0000
Date: Wed, 17 Sep 2025 09:21:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Joel Granados <joel.granados@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Petr Mladek <pmladek@suse.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Steven Chen <chenste@linux.microsoft.com>,
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v1 1/4] kho: Introduce KHO page table data structures
Message-ID: <20250917122158.GC1086830@nvidia.com>
References: <20250917025019.1585041-1-jasonmiu@google.com>
 <20250917025019.1585041-2-jasonmiu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917025019.1585041-2-jasonmiu@google.com>
X-ClientProxiedBy: SA9PR13CA0161.namprd13.prod.outlook.com
 (2603:10b6:806:28::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f7a667-5391-4fc0-0384-08ddf5e4ccf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cw1CXY1RGZ5xCjnrNRvp7ssEdYehd+OgZg54tZVSJtbSU6r49I5YojeNMOAg?=
 =?us-ascii?Q?PFEUjwLehnGQaj7vPhlaRdTX1RDFz9UQF43R/ux9xH+HbFfvmOeaK90vPgAI?=
 =?us-ascii?Q?SY5DXLLMyIhUu0ptdbnIr0mo+6VZ9Z9+ienq0iYgfH+IcxScx7sYvWxzElqk?=
 =?us-ascii?Q?9iMuajexLHQyCe0ayb93jUd1th8uK/kYyN6ZgZC4V/eD58p+eANmzoST1NFV?=
 =?us-ascii?Q?XzLzcldMR4BP2St7OnfIOVwUE8liQGGuCc0Va/lUuNAgP2c08rovGKDJ8Isf?=
 =?us-ascii?Q?KUGdCO7C3Ju33pCHO3mcipOZS1ZAMeqI36ND7ZwZvTyx3C3QQerxaJoPnEuQ?=
 =?us-ascii?Q?EOVZSQntTeJbyZ467oY6MgWUv0xGAPBR0+Sk57MieMQWYj3pHwz4pIeAl6Sl?=
 =?us-ascii?Q?imNCuzHQjgm1W5esJZLx2A4uZhEB6lNaX6YaNAAFLsNVUy1PlbdXTgbsiizY?=
 =?us-ascii?Q?BjVdsnfjOqcFBZqVGXBM15ZCmR3OIWlOFLlPAEDsUNGhPGsiGtsd4bW81s1M?=
 =?us-ascii?Q?bG3nsnWjPiuKyi9Fs+KU+KmIKQidZchI3ujH6V/Htqmj8ILjqZTJxpf+7pas?=
 =?us-ascii?Q?qh51TlIEOSVkLvnffdNf0GUkhjsHk9QXQ4FmGiTQ1fF19FkF0HnEJGdxRcty?=
 =?us-ascii?Q?2xv31WLMQriLbC/DzlKK9Y4aXtNYvGhCqyOYepiz25DjNB9gvRnlt/gvgm1v?=
 =?us-ascii?Q?VjOUWSHHtJUuOslqkHnBImyBRylu3n2v2u6bEX2dTJg97uVBm4xuHRP3oier?=
 =?us-ascii?Q?wEBnBZeLnq3nN7BJw+9GpUIOdZSXQOCBkp6ZOYCI6u6KOlvOxOZhxd0KlC0J?=
 =?us-ascii?Q?DLNQPZKCSJrUAFbL04AI+8wVozdblAkG0F+AhFJHErXmtGMBY4hx5F018cWS?=
 =?us-ascii?Q?PiE1y5IowMxzmLwyJJ5kplhOsJVCgG/F9dBwKgNUZqrEoE/XwwhMO05Pbfpd?=
 =?us-ascii?Q?dI+ZMi/9bQNcQFA0V3/O/xOBHuydW8J3wAZFmwzB7Xjop5svccCLtyaC4qpv?=
 =?us-ascii?Q?LXZQDsTrk2NKWfU3MX1alZYZ+M64HMS9EvjnLUad0DVb8ZVMXYaUmb6hm0Jd?=
 =?us-ascii?Q?jdloaHHDLcdHJTyMR7Ygb6Imj60rvCaxOb3wTcAUhlnrG/euN6yjcj3ExvOC?=
 =?us-ascii?Q?4PUOCDBfGcEk32FcV9cZrH1khIjESWx+TvQcS464jUEZCocPuNZr7iay3tIQ?=
 =?us-ascii?Q?ZzNwIg3kuhvIXPt4q78ZlOd2FurQRNGllnXy9+SBdqAJ0wDT8SMVjAmgt6zC?=
 =?us-ascii?Q?Y0UDz1zTsacDGIHbs7PUFFP60vkcPCHB58r6oVx0KPFPs1sHSC2DDOSd/d+L?=
 =?us-ascii?Q?+mB25YG7pCde7+Y5IyAzCF50C3qN2rVRtXHl77tz6yDCINzg4Xb6BQXrQ/vR?=
 =?us-ascii?Q?Fb0kWMgxfvda3PbJO0Yxyg+LnCtkfVyWPdVuPKP4+bVOhK4m8PBad2lZiuD/?=
 =?us-ascii?Q?AQs9Pcl9jcQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p6FIib31jcR4puSKeD0fdXwKiDMuF1XY0CR9gYneC9N0j3IUnv2UllXkVDdj?=
 =?us-ascii?Q?63/gziZK5RFs9uWYbY9BP9dPwqV1UZ/af0RsQAoRFIquJyrCJEU5XUnAX5FS?=
 =?us-ascii?Q?7clw+TzoWjyQ28V3HzRzPKqLhEOQGPNHa+unwfXvSKj3rhLNP09REhpKlCVy?=
 =?us-ascii?Q?5WI7dGFhu7qbd95/qqIFvPwwR44WILf06UtaysMNhT3WOIo1zaY4LDyop3MF?=
 =?us-ascii?Q?XwgTOnbD/1wjp2sLTMa7Q/7sBbukjcPNTdsYYEH/E+DMNTdrljHm6diAOBhL?=
 =?us-ascii?Q?O59rEUJK3v6EBHY4Boh1urUWESeTeHI30//pV62YszR08Z7Zp7YvWl5A57o0?=
 =?us-ascii?Q?ynGdsbtcmZUQuNieQQhN1BbbYqJRoeTlbYliyc8sO0xR4Umk9AJb+PMZSvMF?=
 =?us-ascii?Q?ATmxNuV16L3SQOVUCaJ0ErNeoTNOXccGzjTEHt84VumNBWG95tHTST6L84Bc?=
 =?us-ascii?Q?iAvwVzb/D44Xey5iVC2OhLyPBrZ90/PRaHmLTewJBbcjTiauwdXQOE1PqELb?=
 =?us-ascii?Q?Dp0u7LoNAOOVo35PDx83//7mcspyEDuFI0erm4wdjlTIPCNL7s2AAETKtuaw?=
 =?us-ascii?Q?zvMcAagn5rdF08t2F8Kf3Vs7DlxXk16ssT4YQrVa9LLgZOOId7SPFcjDu+mH?=
 =?us-ascii?Q?kStJhoK0K2N1pMlkP67fwTtF47hSVi+AGskpFP3Is/cZdIj6GuZuXK5ylZc9?=
 =?us-ascii?Q?kazXRZUDIPsomCu+4lJoSoiUR3WJUsVAIKBtjVZs/IqaIY5GPitfkEbk1xks?=
 =?us-ascii?Q?NLWRcfoIRdX/aKRIjJnkaWgFBcreDe5IbW65qCxrQciQt3J4e9nvfiAD6XYD?=
 =?us-ascii?Q?GZQJ4S+gSbJQW0uOT/nZDFaWie3jvuto0loO22ECiiC4yraM3AsGTjnhE7ph?=
 =?us-ascii?Q?jjamoZ3f6jgoNrzULLu0SJuvAAr8mus3XMYM6WGIn3adX2lUacgke2lmTP2o?=
 =?us-ascii?Q?YwQLbJRKCBQYMZw50WETWKft7SoiHbdi/5HlHJNDuKuX5iva1wYu1Ts1SsE9?=
 =?us-ascii?Q?NAXx01n4s0RdJEXJSka9JphAx+t4oMqorVl6XUJbosSEC0MEsdwl4Mi+NZSW?=
 =?us-ascii?Q?ljGoEx5DG69Nfq5Y4DUg0gwovkf0fPxGwa0nj1dHHj5X8P6xQNGZh/fivTRJ?=
 =?us-ascii?Q?CbYntECu5KHTlKGK3NpGyiZqFwCVAu6axQpx7Ms8XeBM98ixJS3f1UidikPr?=
 =?us-ascii?Q?6SHajriFlF/W4/IyZPwhBniRF0vtG8a2xoNHxr53I94QBENf1UWjR485IKP3?=
 =?us-ascii?Q?vsMCL2EFd/KevDga75jsh3xN51EnEYOhhsRxiOVFOn4J5pH33n2XDNQWyk9I?=
 =?us-ascii?Q?JOK+wiw+31v12Con7M+0+CMgeOqvMsY5jufkqMsUm6tB58zJ0IoBIQhI/dLZ?=
 =?us-ascii?Q?z3lbgVK7lvpgyUawK7zcWKQdSPd4M0Zfqq7TRS+zIHxIYTVLA0MvZfFuN0dO?=
 =?us-ascii?Q?eSs+BmZaTxhY7Zaszqhf96zySOOKeHFu5WGnUhvgWTIf9V5Sj7OAca6aG22Q?=
 =?us-ascii?Q?grbzWhepxsjUa1EqGUTd+GTft0/vWc9xFAADKyCNIL0a3YTUcdRrHPvIMsbA?=
 =?us-ascii?Q?sEkcfjgBEjMBpynSyWdG1MbgkNAoGvgU+N0LFN0b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f7a667-5391-4fc0-0384-08ddf5e4ccf6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 12:21:59.8263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rql0rGKr5bRjF+7lXyofBBeYKXpCBAOPhErDUBuXCYYIaFw4albekL4BIW67qu9W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B72B51C0012
X-Stat-Signature: dak4ngr957a9w13yy8iar54333pcshqx
X-HE-Tag: 1758111825-95525
X-HE-Meta: U2FsdGVkX1/VZjOJLZNhYPvHonosc916K06uYa/2Hkpqyb87yzE9fo9nX6WncREIHf90xJkHb8vnNcHXslttrdBvjvKglGZu702sldZ+yE9wGMHxRjTCX1RToxMuIY82AYf8z3y5MZTqPrbDZpgH5yKthcBoj9opkOwleuSRykXUvc7ey9KcV534JbFp8mt7nEGAzixal7x9v85c95MxujArmWsEf+Ic5oWtn6n2fbCEbrasgh7i2W73KGQJJhjyXOLL94ofMIW8je5lNjU2SQLq+NPDnzT690HZgjUfW11p/87fDVOO/3UPrc460LbrVSxh3TPHY7SwK/iA0laIg/jom1vqLFCckkXOmww7x1orlJe/+ychD4aNEeHJmtIxMRxJxVpti9RgATjLJRfCIuIV6HOYdgp1Z8FIbj8xL6YdkXMNEVGzbX1bafRgi5UeW1I+fKn/WzPbtECc3HRQcGehnfhEIZnVddwLhPuhua4Eiz69Zs5twuhj3zqIkQOhAaYnFtZnU3+C6WuL0Ygq6X+flcag10Gw8fpp1wrKe2z/dj6U1BYTVLofXMmXmWAS1UdfmftYlonKX8DfO7zvUVAbolg995fPxPKN8Jho7+tq6NY6WFZ4f7epkgvGpmqi54FVH7WErJ3T+EeRgbK7qkTFTJ7FU3a4SsnflFaihxGprNTB+Wo/Cy77y430jxP+Rg+sWkRppqiP2Lcr7RHXLceBFtHqVHuWoxaH4MNapk75skySSCon/IA4xQuHjQBAPs/PtzbohuazZYHeRJYZ3w9x5Mdi7avV34h845yryFFjkc9cJDBfmu0RCHz+6ZkbFez8j9hayYa5LY2IRxXlg19MnZncHCMMV1Vns1orncD4Mj7TtuQRI5SF8RkmICdKP4LlkBMNHAVpV/BvoJEro6swjRFq5fgwpc1M61/Nw++0Si0u5Ke+/+ecQM/3UY3EtB69jVSAt8WCP8HzAIS
 ejLPhkug
 GsjDkMOUW0vVaSwcXMo80+qmGGa07KdUgDet0MKxrI1wml5llLD6jDdsF3yraahNn9+2UIMA0Oz2IvazlmUQJD0ElWtOB7Y6GbvaEnbCXD/7yxw8y91a0Lpnm9uEmcxRCruSZncp65ZhtRSDmhJ8pIdrlQi24+PSJclDZOIxLUAhpbvzxLrMMUXxlszRId4+63/rwESJPlm/tUK6I3zbcpj5XzFoUX5qkkUmUaUVkZHguZTDhONCOrKw5svcqXUkRCeEsDDYvq/f/iuTs2GAzrLSIhpNB+cPVBsMG2DorimXqJBzC2hgTDDhmXl6lB/mln1iR+SiFwmyztB1PjdwOiZdXF/8HMwcLVPrNJkHDT+1nyS6syKcdLixW3vvLpUKprTlL+uk95nuu2CDOzsaLW7vb68yeOo0zjB+U8HSsK2ZQPBwuaL6LGVZMtlJOgAScPIHdQjtzyXp1wMyFYR+dltOKQCsRFAaRj5C1aywH2E1K4E3KrQNKYzCWVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 07:50:16PM -0700, Jason Miu wrote:
> + * kho_order_table
> + * +-------------------------------+--------------------+
> + * | 0 order| 1 order| 2 order ... | HUGETLB_PAGE_ORDER |
> + * ++------------------------------+--------------------+
> + *  |
> + *  |
> + *  v
> + * ++------+
> + * |  Lv6  | kho_page_table
> + * ++------+

I seem to remember suggesting this could be simplified without the
special case 7h level table table for order.

Encode the phys address as:

(order << 51) | (phys >> (PAGE_SHIFT + order))

Then you don't need another table for order, the 64 bits encode
everything consistently. Order can't be > 52 so it is
only 6 bits, meaning the result fits into at most 57 bits.

> + *      63      62:54    53:45    44:36    35:27        26:0
> + * +--------+--------+--------+--------+--------+-----------------+
> + * |  Lv 6  |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1 (bitmap)  |
> + * +--------+--------+--------+--------+--------+-----------------+

This isn't quite right, the 11:0 bits are must be zero and not used to
index anything.

Adjusting to reflect the above math, it would be like this:

 63:60   59:51    50:42    41:33    32:34    23:15       14:0
+-----+--------+--------+--------+--------+--------+-----------------+
| 0   |  Lv 6  |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1 (bitmap)  |
+-----+--------+--------+--------+--------+--------+-----------------+

The order level is just folded into lv 6

> + * For higher order pages, the bit fields for each level shift to the left by
> + * the page order.

This is probably an unncessary complexity. The table levels cost only
64 bytes, it isn't so valuable to eliminate them. So with the above
math it shifts right not left. Level 1 is always the bitmap and it
doesn't move around. I'd label this 0 in the code.

If you also fix the sizes to be 64 bytes and 4096 bytes regardless of
PAGE_SIZE then everything is easy and fixed, while still efficient on
higher PAGE_SIZE architectures.

Fruther, changing the formula to this:

(1 << (63 - PAGE_SHIFT - order)) | (phys >> (PAGE_SHIFT + order))

Will shift the overhead levels to the top of the radix tree and share
them across all orders, higher PAGE_SIZE arches will just get a single
lvl 5 and an unecessary lvl 6 - cost 64 extra bytes who cares.

> +#define BITMAP_TABLE_SHIFT(_order) (PAGE_SHIFT + PAGE_SHIFT + 3 + (_order))
> +#define BITMAP_TABLE_MASK(_order) ((1ULL << BITMAP_TABLE_SHIFT(_order)) - 1)
> +#define PRESERVED_PAGE_OFFSET_SHIFT(_order) (PAGE_SHIFT + (_order))
> +#define PAGE_TABLE_SHIFT_PER_LEVEL (ilog2(PAGE_SIZE / sizeof(unsigned long)))
> +#define PAGE_TABLE_LEVEL_MASK ((1ULL << PAGE_TABLE_SHIFT_PER_LEVEL) - 1)
> +#define PTR_PER_LEVEL (PAGE_SIZE / sizeof(unsigned long))

please use inlines and enums :(

It looks like if you make the above algorithm changes most of the this
code is deleted.

Jason

