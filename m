Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0529CD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE38A6B03A6; Tue, 20 Jan 2026 04:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FFE6B03A9; Tue, 20 Jan 2026 04:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2B76B03A7; Tue, 20 Jan 2026 04:49:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB04A6B03A6
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:49:06 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57073D1950
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:49:06 +0000 (UTC)
X-FDA: 84351868692.20.8BDAF14
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 86E371C000A;
	Tue, 20 Jan 2026 09:49:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TiLqj+w2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uyby0ccb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768902543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0yFw+Z/K3kY/oVR572iCKdHI1e4mwcGxVZI6ZJk0/fc=;
	b=IcmuXFKkAyUmqBZjk5gL7sa81biLBD4qHoqI6OQEhb14WMpqbypuE7yO5ZhZckIZ4oD/1B
	j3tUJHuWhqKgSSItGqS9Bo1d7LCEwMxJqq/UdtwXGLoXz1elwUmOwjm7LXv9+DKx6agcTI
	Wzv26nlzDP9nXLcP6aXuLwQ/AU2JTvQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768902543; a=rsa-sha256;
	cv=pass;
	b=opTsPwbHJ4E7X32fDpZru1y6UXVH0sj4i+yZlChdconLRoubuLSATPG1VMGw9s1vpE7YZh
	32+mtpZ66FusQqOEul23vDv9X8thLrxjXfFeeaXUixSFR+ZIDBu4iJlSnmYjV8nGaqSgMN
	WcRbacNuK/av3lvlAPYDhD76qmYgpwY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TiLqj+w2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Uyby0ccb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K7wBgq3432314;
	Tue, 20 Jan 2026 09:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0yFw+Z/K3kY/oVR572
	iCKdHI1e4mwcGxVZI6ZJk0/fc=; b=TiLqj+w25IW8R7yqpHTkd0pfVTrFrmd9oN
	6XPdjxyX1vMdG+ABL/vwRgCR8tt/c7UNjZwtvsUATJQoC4bBRatBmiKkTiSCFTW2
	/09SesKvXbeOnwHPZxmcWajWBV21odJy/0GbzTDkAQ02PgpADTXrzNJv+yTTGvNh
	moQZP9lYb0H1d0JzrB0Oi4BuREzdfnble44yvcqVZAbtevnmK8QKYBo/nrNKYkfw
	yV/1EaRfjTLEc3R4Uk6x6SUgcKxIxAidXeiQN0mcpJwK/gskC0j1/8vTa45wjw6r
	lo/6isZDjefAG1tdsUzPbW8Yv2EccNW2uoGyfmU/hQvI1zMonQbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5k8m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 09:48:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60K7d8v6017996;
	Tue, 20 Jan 2026 09:48:41 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v9csx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 09:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ol284LBiLpbI8xBgFny+PSrQgMk0byVKFkFUDsJugU5/V6OKRqgReHEuYJmC0H6PV6C90/1pWqc0G+9bhxwpwNoLVTsGS5MIdNAn18q3ckcvH5iNulFZjsj/tDusGJIocOdBy7uneJNPW0OcniPz6+6iRIVdxT6SCaYW+FydMeKOU0Sf4gmg3RO0qoukjCDxy94/YS3mXFmalekrmD842PJoJ1xnhjYDKmKSUsX5o8A635Dtja31nlChZ1626GgOctzod5cKhgpUS9EzjV4FPtqcFl2VZcYJbPWKhhmm1zszg/kliRD6pO6jAVigvPrtuG3+vdcO21zuxLIckjyHTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yFw+Z/K3kY/oVR572iCKdHI1e4mwcGxVZI6ZJk0/fc=;
 b=Cm2gVJ8170R6GBTe6korv7KjH6iFfGxP8yPKoBtpLLDoonsHyHqv2SCs6FLrmEeJD9RmTk0899w04O5RpYEa/jR3U80YaXPX6W+/qFq317A9PAFupJ/0KvWkkW9RUVE/V8LTijdsNfQOk9G8rYo7UyM69fH2A7efbxuah1rEX2xs+T99HB2kYzMGyvleeCmkQdTAI79Fadf9gQns4iTz9zwfNRnPYHrXRECz48HONxfoOnP0C9tXboX2WXR3sK+Zg73hqQ09J/0VvfU6lYouAXzGePKXYLUkXmtP7y3h7ToiLKrtvUxKr2gHWS1AEep2ltenNOTXQCV1fFnH6XlwyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yFw+Z/K3kY/oVR572iCKdHI1e4mwcGxVZI6ZJk0/fc=;
 b=Uyby0ccbIuHqYxhX3cJgcPYD13qkqfVB4GZw0nxKpOyWPp4a7bNzQeIIZqjjh/kF6UEZZFXF5gkgqxIfCL0oEDJUsr0my36NUGUkE+pfmIwrYdXCjsTFN6pCcPdsYBvUEXElaDcJP1PYjetuaMpz4l1unyZn66r9aWKPQCAV5PI=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SN7PR10MB7045.namprd10.prod.outlook.com (2603:10b6:806:342::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 09:48:36 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Tue, 20 Jan 2026
 09:48:36 +0000
Date: Tue, 20 Jan 2026 09:48:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tursulin@ursulin.net>,
        Christian Koenig <christian.koenig@amd.com>,
        Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
        Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
        Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Babu Moger <babu.moger@amd.com>, Carlos Maiolino <cem@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Howells <dhowells@redhat.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev,
        devel@lists.orangefs.org, linux-xfs@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH RESEND 00/12] mm: add bitmap VMA flag helpers and convert
 all mmap_prepare to use them
Message-ID: <36f98f66-aa9b-4a02-96e0-2df5c026fe44@lucifer.local>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
 <20260119231443.GT1134360@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119231443.GT1134360@nvidia.com>
X-ClientProxiedBy: LO6P123CA0053.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SN7PR10MB7045:EE_
X-MS-Office365-Filtering-Correlation-Id: 74d3a176-f955-4803-18cc-08de580914f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S4wrVhENBTAN97KjpL0UVoFEO4TCD48q3GL2RQYZi6ZZ28MZpxfftsFXS8xq?=
 =?us-ascii?Q?Cz262rf+BdqqBG0OmGQKeA4BKyls6e/gvzC9vw8Y0h9zeqCfwJepDqDa6shk?=
 =?us-ascii?Q?gHZTzG4lMj3K+GkLexSJM5pfzGsF9dIXRPj1gfkyGSvHMw66ahl1ETUMqpnu?=
 =?us-ascii?Q?jdD8uIdwJ6Z8eVKC+8KtJo9w6Q8JLhSBW331AtDVMie0vArscOQkWURGSNU9?=
 =?us-ascii?Q?9ulJtRqcHTAeDJu5DMjTu56zxaxhVwYhmu64mFwo7y7FuORcoSgZm0Mr4BSj?=
 =?us-ascii?Q?Y/oK19DKRj0Zt4zK5KxcYGZEHjWs0Yjc/uyRt6GhymDjCWYxL5HkrhMSAqta?=
 =?us-ascii?Q?CapHzHn4cdwdtWdWYX9s/Gbes89+rLdFhWcIeMLxKP7qqNm0PruWkvH6ELUk?=
 =?us-ascii?Q?i9LPnMKjJWFROiSlMCnY9UUIocFw7OfFHLtP1zR1qEIhdej+w7VRd83uXsCn?=
 =?us-ascii?Q?MCKbmfKPVRdAd66nnoQ5HCDZJTWmVsJVHFEbsiVzeg7Vz8YO8w/JE2ugF8a+?=
 =?us-ascii?Q?jXqq/wB+MWVgsin4Y5TTAMRrW2ZZ6RCbwSl9TBrZek6TFc8CXQ7FPKb1cWqR?=
 =?us-ascii?Q?WSVVebZqQVAw4jr8ptQFf6UdVunDCamBCAsnXKDLkQQhTNKofGVY6Q7GnBCc?=
 =?us-ascii?Q?sjhAha+OG7ckRg44cxxkGEPkg1ZVLBBSMFfMeItKveRJVdLUR+v+fXXlqJ/K?=
 =?us-ascii?Q?WO2CkLAR6zaYWutpcgxhNivoMrl4BI4O2SOcMjPVnjPo7VtbcmS7oNE26tss?=
 =?us-ascii?Q?yikN7/VkQD6rxBP9jsWOUhLOia7gDjqBLuqYbzgQjX8N+cUFVBhinZADgHT2?=
 =?us-ascii?Q?MKujf28rACR2magKkhctdB7Kaz5kbyGZWrR3KXPNlmvMSrORl4TZefkrgJaJ?=
 =?us-ascii?Q?uZcjtb2fbi2n7BR/9NLE5+/2npSNL8QgwDkdF2/5JCuvZG+OjoMSHZ8GQv/u?=
 =?us-ascii?Q?XZHHiZWb6eFs9S86dtmmuqs6+epcTtV8rZWoaYdupDnXQ1/Fwo/zvkzLsI4I?=
 =?us-ascii?Q?HpczD1REXHbwCheHA/u6UUuxgPhp/R3dJNgyS5hyimKzjpKN7DsJCCchI1nm?=
 =?us-ascii?Q?cM1xPspMR8sKjEjOItdVePxa5sEPzBmEa9la0HzHNY+3BvVbrBzSHISRG+uB?=
 =?us-ascii?Q?rBKZAMTWtnYXrLW82Od8Kcpe9j2AhWR75Qv+zy14JUhaeyNSJIOvni9UJzf/?=
 =?us-ascii?Q?Q0NYv4dLqagpbPHf9ooW5dAMVIFXer4RHdO+mi5y/7LuRYALWGnz5+f9st+O?=
 =?us-ascii?Q?eL5d6O5Rm+4TiiTlKKeyLxbRSWrctqsSvbV3GIL0Z3wIQUQaHdVpi0c8QFH4?=
 =?us-ascii?Q?zxCou8w92QorEjjaZvnuwQjPa5BeF9/3uBt9uPY9+ErqN2EESQ5gCYXuN+gD?=
 =?us-ascii?Q?6GNVYtjYQah8O+tK5gRgsnSk4fPNMW69slze0HDT4MvCesXixj9mW3hPnMmp?=
 =?us-ascii?Q?OeuZ7jzq2Z49e3vO0Prso46MqDpPNWegxyP6UJ/8hB+oKoV6fnPdkkJGpPKB?=
 =?us-ascii?Q?ACY47H6oqic2sLeUrt8yDS+6BlgkfGqVibD85O5jqXrufnv8cjl1PZ1M51Az?=
 =?us-ascii?Q?6ap5XH8I4nGMlUQaHGk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wa6kd1MZW/Wl5nJ6pUL6GoKJauI7jzc5tKvSb++dbkw6BrFdmZ1cPD+FMF5V?=
 =?us-ascii?Q?avTWGP6yGMtXYTdFqsvDK2+6HKDnBD3JAlOKqxrOVfEfd2fRyMWIw+1c7vNW?=
 =?us-ascii?Q?VLlzmlmGC2Fbj6UYH0MTp80U3Fs9wMmJp/NlfktjWiB3SjdP1oSmyOMi0QFN?=
 =?us-ascii?Q?6nOFPZ7x/WDG1GototvLeS+EeCXScW7vmDSkm0IA148+11YQzY66nUoqUCv9?=
 =?us-ascii?Q?7eHbi9V8GDpq3SXu9cn9Ek2Rof3i7Bf7lGWQq/+tSw9xjhDCxLlaeRH74vYz?=
 =?us-ascii?Q?JX38XREgvJ5Y4rhcTxDeouG4Hn/zZa8FkyMCTLnGJWEBGuqYlvPlWe2Dsd3n?=
 =?us-ascii?Q?zxMwYjlanZ+TR5FzBbwNl0mvdse9yMxt433ZNR6QBWCjXrRkpW57mL5vrKLa?=
 =?us-ascii?Q?gvG7/sEuNGd8PjtZ+tj20xEIVfnALlBemP0q+J8bz4gAGqPeZmigB6vNY9LA?=
 =?us-ascii?Q?uMORrBQO96S/h65PM25o0UGRFp1kzFFyME30aHKXrCUeckSDKgMmAY8WtBHn?=
 =?us-ascii?Q?HoGmYyeZNn7dhc4xIeTNrJl4QLNzbWoIcUJXHj5GD7GGIcHZiEe2qwAZkh34?=
 =?us-ascii?Q?v+vYo75PXPH10FIbc0GDdPkWeamviHWyNMtKF+bR7oXguSykzgUKM+QtKW1b?=
 =?us-ascii?Q?ojy5fKHNstyC8xgXiiLr397sPczg922okOJTjl5TwdCnYMuzpKntOVpdMxKk?=
 =?us-ascii?Q?UTwQJwufjIicjG7R/8jf8gP9aks/YVE4v5lSDyLeDe6pfKUou5LZ5zhDB+fV?=
 =?us-ascii?Q?1Lyua7m7+hm+UO27hz7GvJC9AuZ2xfvz/RSj2HQ1cYxCfUvVR6qJ2TrtqXiZ?=
 =?us-ascii?Q?Wj6iTqxLMsR12NCcohdMtsxZ2A2G2ToE8S0WclMqyHAepUeh8lr0PgVbLaQI?=
 =?us-ascii?Q?edBlQl8eM3t+wWybdZXbxJa+TdK2FGF77AJxt8m/g5kQEUQCDFchDv2Oc1K4?=
 =?us-ascii?Q?TdN9scsPQ4VodIjt0x1XCXrcIYbba6l7GGTcZD7GB7oyOsT4IZvr/MpWH29j?=
 =?us-ascii?Q?VMuV4fJ/UMkNhjPU2jdsYrg2DYEYSrZloZoEz8gcCcL8uvUeOLDdIJtpZ1rF?=
 =?us-ascii?Q?IMEwulFNKZEcWLDH//NsXLsuZ8fNTxFirEGQ4+J+wkeysOZkkP74WXaW9AEP?=
 =?us-ascii?Q?YMjwkhd+8MJ7fUqgjBovyBeMDTITQBO/obWuYRGAcXY874HnztDXCiONOBq6?=
 =?us-ascii?Q?CO2rnXnyTNt4tJxZtoe+/7OxKN1p2B1xmtK2YL4ncywgZ+x21U/iTRaYg9zs?=
 =?us-ascii?Q?xyOxd6i51TA+muzL1IkYm94bRZws5cMrxOoIQJyCV71Ktn/ykW0ZWizs2UQe?=
 =?us-ascii?Q?rzIt2aA7qe0JPPZff+13lnmJUnnp4y5D1msTFytQsjI7+aqycVQDKPtbRYhu?=
 =?us-ascii?Q?E0MWIwI0jvQUpXNdbF/bJKXVZh5vvfiPSE66J/+lhZumjkoiDdxYRdgtN3vi?=
 =?us-ascii?Q?PsCzm21KciNNGijha1aOKTqW09/TM2REd+/6nP+DhV4/c8RwgbVVeAsBy/nV?=
 =?us-ascii?Q?2K4HsPEPOFdD9SoClCxJGEeoLTxvOMNZc4uT+0Zu7ojsyL2Eu3j0ZjEO/REU?=
 =?us-ascii?Q?U3PAMkG4bnDrPsHdXgSnWarY4+Oush5daJZUbAODkX+lc0h5yFfobOCD27Hl?=
 =?us-ascii?Q?g1Zyu8F4v4+akhbW+fYKiAirGyw36xwnXyJLt0UgwuRJY/nAvm4afQSiot9e?=
 =?us-ascii?Q?ElUwK3YzONNErdlAQ35BFrXxq2qBO+tCVOvCMVLGuVvU3yrt83OcCdr8QElL?=
 =?us-ascii?Q?+0WrBxcnbwyeIyfaKXzLhJuhiaMLN28=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A5hlk3JghG0MrXtUAKbeAIkx6vdqFptuENSlmgNaokr0eZNKsakFV7n1j/Vlj7Hnwj1QpFngIQvExDDwRogKXQ7O0cEuFTUI5XbowG6CwwlOGAVh4zRf8J97/pPGY/EgBUkdlDZmrnkkjBNk+KT/aXVMj6lUsYNzNUdtYR1XWF87SrFgQkAXXhH8hRrGZbZcSqFHmAqIvDKW8MEjRlId0cFFCyNLHiNNCIzH2gU5oyOsBr1sRJAJvrEAJzdYjkSQSHarLt4dzTShGpP7bAWghBUwcJ33qSO7dOm1RS9NYeTjwpohcs0bSXrA7KNyzh0ex54I4kB0BgBmNF392wKmEGgZiaAhc8M2tkN3AAiNeCNLKC0Bp6nsdh5uVFIJ7rAYASZOWU9+xrH4zNMJYF/ph6jHjCaIFxLGjOvvlsYUTHxXACqJCKOPXsg1y7eh1q/+qYHVrDoEH59DfRUPce+TWvcBK88yDcCz0d2EhdomYddv6rHUMfrp6cAl+SCdqDouxsjfpAmsdqeT6bnj2o0ZbjKbQ8cSKlPP19Pr1nC4qhKpZOQmF7y7WrIR9phCnKd1xbJvxNB1H2NaNDFfNXGifyR/zHmwW8azXZaUrA9eZMQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74d3a176-f955-4803-18cc-08de580914f6
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 09:48:36.5590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBQ3nwMeDk1f7J6ToezCe3KmU/Nc0o3JhiyQa14CExY1AIupKmOCstVbgXl4dY1LzcB6J0I5i7fsIjHPXziVDiQeoN0xpCe0v2+N9JL1gpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7045
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-20_02,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200081
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDA4MSBTYWx0ZWRfXwsfBKRv1bYhq
 D0G8X0HlueZyo3LDreLOMPt1ICC6WnTSiH8xLW0Q175JPmTVpPqnvrEwvUN+KU8dT7NYEkgMC9S
 GGHODQvCglYANjmZLHa6avSZ6+vl4rUOrSAeZBF37c8EalbkJP1afCjbDVoyZw9BATNbYIKxGjY
 6ct10iPtPhJhfpt7uky8WIFqGJf2jakbyfCCXHYt/M8ta+i7nb7o08NaL64LE3IUiHk3RZxpJrB
 zyzkb/F41IwtPd6BmKQjBzMJv5qjEFHR/ff99+J2tAxpc28nl6T42CyHdVfxeG0RnvzLIWY5Q0/
 ++ZURKX1fbRzlNuZBVf7fXjEvoPDbdIs0JE5VeNzKILed/pNSfv1WwM3ebu661QgGw7PGwI7QjN
 g+kHO5TZ67DX5KZpom5/dAPcIAqmGELfNpmB0wrLq6BLtXyF4uW2vmwrk5UG6f0ZGj0/epBHKiD
 3Hk8HHUt6+Ry+jt4veg==
X-Proofpoint-GUID: ZNm9CEh3sLfTyYk1vPSB-rZlGV-6HUpW
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=696f4f7a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=AwvjBm5LquQCOghq348A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ZNm9CEh3sLfTyYk1vPSB-rZlGV-6HUpW
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86E371C000A
X-Rspam-User: 
X-Stat-Signature: 7159g8mack44pr5w4ihwsoxyhwga1kao
X-HE-Tag: 1768902542-983669
X-HE-Meta: U2FsdGVkX18yhUcoswLiGGvIrws2q5IhHoYpnLlyTnnoevsqvOF0wW38uLCPQIctw+4lXRbaESc7AKRfUOG5G7SYWwJfjUaWxgZsqGBsfCcmVsyOz7dR2M5ZowusoNcF3HTF1dxuk63IVdB0TpO2kWBvTCjZwjoQBkbEROQx58wfOTFFt7Ix2qb7Rl78XKj4+KhAPsf8jqviQLw+gPKgJfrcwDOZpZvPXnmctnei6IFNBltue38iuM+8tPXFGvNBCfA9JMxmWLJOalpSpIK8+fzOruA7bxhTus042/iHh4heCXY4W88/T3ZtiVPFltf+irkdFwiLL1lfYlYVjc4/hKQ9X1EuONdPiTXMDp+wOwaeKmfvVel4WpSbP31fmj0L7s5ehdalVlNXcvgIIK7BKf5mep731bui9t9uQTIpUbGMgH9ENwAr+zX0vRas5ZcFGH3/FrCmO2qyPhKMxDrD2VZW3V4m3ZAqMs667bbXrv1QNqecXUO5DVP88PkNOmIgQ/d8edrcCtBQXEY8hRZsJyJml14m4nxdxbwFD18FabtYxSzNm1Dxtap+FIrVTvaA6/V4D6X2XI7bGPsnY8FcWrsATOG5HqgrjuuDW+R/lu3+oWSFx44wG4sgzjlCTYyLgj8zNDqTtRFMQzIz52PJGMzC+kXFTUiDtPMtt7OMHSMk9gvEml7SXl24rNGCzLrtmb4c77gR/gU9sfmw7YNoZqvJhhIGxkTeayAMt9TdnU/ri4Am4X8lWf7gTQRuxM26e3B5iOAylOCfIrgjADd53mz50B2R6CQCWBBWhW89V6NfUpjfjpaRg1k4O65RKs8ZKBYvKof02xR29KooZTyP8twyllV5AloKZ9ED5PSBJ8kW8qfVEdPqjcdk7gdx5gVLZ17VznhIoCPHuW7fWfyI9FlLRt8lORJc4TgsbNktKo+pBAB2lhliL1dEckTvmtvp4rxz4aIS/mxEu4H6DfE
 24cFaycb
 zzDX3/B09uyZnLssFgkqKbCqQKnbs0mans2sAxKgLs8++QzqWqYDhY93WbESNHMm7hNqQRg796zjQ9Lee/uOq7IH213Fua/AhihpNgTJm2pYVjynlF/vzXC9xXd6TRhQ0w5dc5G4CzF+VROmUqD4wUgukFqgz3oTHG//ceCQNj6Ldii9k7Lk6wzOalNbIjnUlb+XGIPVI3gMQW1Uv4qPdBHsll47i8fs89sVFSf7lRw1ZEW6BLTZHdDb1/zJZQcukIZWmchoXX8/frlJdBB+zW1u5Mre9Cga3UWvBYdK8ZbIh6Rmg2KYOFYPBut/3uvChBGY30RVJCnHIYxtoC080RdP3oRxowJmmba1szOwnlz6M/dwWJt8Wx026h0XY/SoslmFubd/U5buHstoZtk6pW0ClCOe9k+rWkV5KxawwdIH0Ws/UMxXdaUKWuJThZt4sFsMEl7RN77fzN5kZ1r42qQe6/0TKsEeaSr5vgUrpYe2OOcyCA9TkyoQa9Q0imLl0UDq1HR9SByM8Ln8SEneDgwnKyQaCEYiuGeUhbFsG74SD57Q9VrOIANy/PhzEcNAy2B+2hzZhtF1IH7I5PFwoC1oj7Q7Ux4KrRUCKy6I34OX0+G2SbrAXzAUIRKs2QdtG0NIK8vtbbpHz9wweVKDr+pj6pgt+3THAckvdD61xr4LaDar9539sHbhNKw5OR41aVWYwUnBKHvOpSnI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 07:14:43PM -0400, Jason Gunthorpe wrote:
> On Mon, Jan 19, 2026 at 09:19:02PM +0000, Lorenzo Stoakes wrote:
> > We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> > 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> > future growth in VMA flags and to prevent the asinine requirement that VMA
> > flags be available to 64-bit kernels only if they happened to use a bit
> > number about 32-bits.
> >
> > This is a long-term project as there are very many users of VMA flags
> > within the kernel that need to be updated in order to utilise this new
> > type.
> >
> > In order to further this aim, this series adds a number of helper functions
> > to enable ordinary interactions with VMA flags - that is testing, setting
> > and clearing them.
> >
> > In order to make working with VMA bit numbers less cumbersome this series
> > introduces the mk_vma_flags() helper macro which generates a vma_flags_t
> > from a variadic parameter list, e.g.:
> >
> > 	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> > 					 VMA_EXEC_BIT);
>
> I didn't try to check every conversion, but the whole approach looks
> nice to me and I think this design is ergonomic!

Thanks :) I have spent a _lot_ of time experimenting with different approaches
and making sure the compiler generates reasonable assembly, obviously inspired
by your suggestion that something like this was viable (I lacked faith in the
compiler doing this well previously).

I did initially have the macro be even 'cleverer' so you could do e.g.:

vma_flags_set(&flags, READ, WRITE, EXEC);

And have the macro prefix VMA_ and suffix _BIT but... a. we #define READ, WRITE
and b. it means the symbols are no longer anything to do with real symbols that
exist in the source so would be confusing.

At any rate once the conversion is complete we can drop the _BIT and make it a
little nicer.

>
> Jason

Cheers, Lorenzo

