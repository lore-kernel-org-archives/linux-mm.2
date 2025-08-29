Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525E1CA0FF2
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944098E0006; Thu, 28 Aug 2025 23:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCDB8E0001; Thu, 28 Aug 2025 23:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBB98E0006; Thu, 28 Aug 2025 23:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B92A8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:02:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 327591A050C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:02:45 +0000 (UTC)
X-FDA: 83828297490.04.25F5D4B
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2B095120009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:02:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZhSVQjr5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756436562; a=rsa-sha256;
	cv=pass;
	b=iiW3/ck3Nt1gXzvxN9oCkq6D/OJXqYVhHllT2Q4XmsgrIE9VcvUpdgiuFICaHeoEBcDCyj
	bbQooCkJqBFZwy89ji+AYhiacpGD54ND0d+iDFZFIn+Jc9nX0MT9JiYAyTUiFKKaEOTZUw
	cVbq2xcLhR+siRxQ6XjpFnU2XexH3is=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZhSVQjr5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.41 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756436562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJT5EWyvzh+TbmIiBj014m6QhVQ7ugu8XvkMpQ4SHFQ=;
	b=S/+ljZXgWWt5gsHIew+vvL12algZF1Tro4ZpTPScCoNVFsYZLfvc/yS6Bq4AGj5OYjMYdD
	+V8TtkoZeelTcZll+LKUu9PVSSa7wQSY296A/uBSWxLBjiYfnKXvlqEaXmbdNQWS9VdhsK
	eYFq84YN2z4NPRaP6N0NkxKMps4GKFM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cx8wTejvEYN93GN4krJwWUgI/cwI7w4vWTC9vtn8XzSdHzQ1jAhs9GwzexWM5J13fq5BjOIZn5aOnHjTQjHtmm/ysq0JMD8o//qkoiv8XsoSQlecrJjG8OgBwFhZRNwnykFiZt+LMcTg4iQG0qzNiyE3GmILh9o4UOEqQ/bxbb5eyq5zCW4b41citPP36zMVBLYTMkYIoBW6SrFM7GTtpqB9rcuhGPRLN+I3FRlOQ1vfQrDL1mE/EO+jsG/UrJWompwUGxzhYkmLEQSOtcAtEqGl6/Z408JzlKVTV2IsUwA2f3Xo1Q83Qyw+bp9U6QFYtoxv/drlhW8gUjPaPV0Tbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gJT5EWyvzh+TbmIiBj014m6QhVQ7ugu8XvkMpQ4SHFQ=;
 b=dH8D+5h/XZZVWYeXvaHllcZ8aTmIO8GNmqnL0sqWt7UYgMAl7lY4aJJMfWgKgBoMEMe6Awt7jCdwM0zVKGcCnnMBLOo6Q9q5Cs7FvLuY5SYwJNkdRsDnSvuK/IcIos4a85sSeFCQfJP4mPP1Cb8WMxv5JWzHuLgTXr8XahGz+wBSmDTAa8cZdhw3Okv/OBSKWL6E6Yqs40xhYwyGDvh63T+EHIBj1vmPrJ44Zp9cpkd64P1BVU2BT853FzgRZdnNr42N0LtmXU1EBlUZ+mgJ9kNJv/StEK+gdgkeWIU9EEbnkw2vCK9cwod2t4HAxAOuyZ6Ajm3Dsg9cE93nufz11g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJT5EWyvzh+TbmIiBj014m6QhVQ7ugu8XvkMpQ4SHFQ=;
 b=ZhSVQjr5zsgy0V/tEUThodIcY53mVcY+hyfwwKNJBQ7NULXoCdwbC+ijRwQuT0arTplynfe+n1zfj0Bf8tXiqSXx7s9ytuZMzxly7XyWU+64CD1Mva+LiAwKrxdA2Y3erjkjPfgTNmg4EaHe22e94z8oFVVJ8a6ol21bU9TfKudHs/PWtkdJEZMePJqHxxh7sLdzPg46TkLyijuf/J4wCvNsviIw9acHDO7fANGkqNYWKSl2kqw5Aii+bUXaohtejRTKGWhdJ5UR/tBMxP0dxw+7G+rJjyKXlF05bao7aTdYC5GHcbvmWLRwTQggWWFx5V6r3spRD7CAFBAI3QtB5g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN7PPF8FCE094C0.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 03:02:37 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 03:02:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/page_alloc: find_large_buddy() from start_pfn aligned
 order
Date: Thu, 28 Aug 2025 23:02:33 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <489045AD-70D6-4167-843D-50A8DD19870B@nvidia.com>
In-Reply-To: <20250828091618.7869-1-richard.weiyang@gmail.com>
References: <20250828091618.7869-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0513.namprd03.prod.outlook.com
 (2603:10b6:408:131::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN7PPF8FCE094C0:EE_
X-MS-Office365-Filtering-Correlation-Id: 162fc4bc-567e-4109-cb03-08dde6a88225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aqLwBlNAT5+1oYsRFBvh/kocIWwZErISlVrjO1msQqba6Kz20V6tQIF5/UCR?=
 =?us-ascii?Q?cdZZ+tqteLJQLXVtaP5sqdzF5gTj6ISfEosT8KwKUmb2P4pgx1RXnRoVYPso?=
 =?us-ascii?Q?UonTTOajpdTBB1C0FAkFj4BH0cJdAxQaF0U3VIpm4nfmb4RjSQ04zN3eQCIE?=
 =?us-ascii?Q?UZ8H1VgTAovNstdoqQwBETaeW+VyIJnhsxlT8f4SS8AxxYJ/FdaErfQgSs6Z?=
 =?us-ascii?Q?xkViNFywlXP195ASOVdhRYmzBT/Elv3iKPwVi10yZLBkNjBQDUHo+cV7G+s/?=
 =?us-ascii?Q?H8R503qJL5zCfQD2afE3qJgsNQZmT+b9cpjH8fFTQ4N73bVmyCuflm1R2gfM?=
 =?us-ascii?Q?INkXlyQsic6270wtU5nzvtq2Z/54vcKX8rgVGgfk3DQ7gV8zDjdVfJv+T4gL?=
 =?us-ascii?Q?RCY3HlgYSWzlBbiyvRIqMeOVMejXZQTrVaG4D2HW4uzSrE9Mkh65FJSbGqvE?=
 =?us-ascii?Q?YEJqPM7wHMU+pVLdSMmnfDZ9AgUsaN0XCzQg+/7CjR2gwPDxT0jc8P89dFIj?=
 =?us-ascii?Q?s/nwJbqyp/vISAGPgJ0qS2ICYUN4d2DR6U/AlRbrETTOvWx7jWSjMUCAzcbb?=
 =?us-ascii?Q?+holLJdmShTY6NqConqX1larjbMoqnlDEccM1yDZ35a4vw2ExEV9gacu2iGL?=
 =?us-ascii?Q?BwdFitdoUqe9JTv7hSNDeMRv2ZVdIfTRJ3qeoalhf1KpIq5le6YXodJ/A+S7?=
 =?us-ascii?Q?FT5xTkuDMKFw20vVWssvf2qtEuMtdCpYB9sjDyIBJFmxgdalsLTV+AruLr+1?=
 =?us-ascii?Q?wIefhO/BZjXMcS8HAZKSeMKmixfMP0aOlxbbx4tuflzNFUM11EksT3j9mdu/?=
 =?us-ascii?Q?Lf8hMK431s0QE76V8cHwtNr+NF517tXyeL6HoXzt5MKqkXiQMP6B7qCz9zz2?=
 =?us-ascii?Q?O/8EgIFjGEo4cPFgxBNI2lTMreV4arFtH+zgjd7pejtR8wv6An8SKZveiDsn?=
 =?us-ascii?Q?6ViejLL43Gb2PgbprRsGkqGOCt3W0rLjQ9Rf6sDloMgw1qA+6iwQ/NHKyuad?=
 =?us-ascii?Q?rxa1gyZ5jKxwwLUTzngMccDzJ3a2ucZDvNA5zSFsu7URXjB9UzObXmgND+qy?=
 =?us-ascii?Q?Qe3yIDIFRz3Es9cZnlolJexGmNSH17dEFOfqqh4SKub7Xn3sH84fakDWW9d+?=
 =?us-ascii?Q?m+GlTIbDSAEsu+tQ+Y2InmK8BZx+QugXf3QVtez7MFEDLTvcuJM4IDWsrYaA?=
 =?us-ascii?Q?nH6QferaHS+dma0iYm94RTKo0pcQ16osvgd1EBMckJ+nWGIxT2XwvFGB4JkZ?=
 =?us-ascii?Q?514Jhgja2NGd5oy0C4uU0XSLIaHW6hMIkTCSVlPjoCWvu+dcCQU4qVHckLew?=
 =?us-ascii?Q?r/WDukxr5Gx4f2MwwggC7nkawzFIxmyUugniRXGjNmYxTXrhN9NaiM+UiIHC?=
 =?us-ascii?Q?4YPGwJNVpxOEFofihZ+cWAFqATCS1YVKR4A9exzRphu58tGqZWyBZPSTMDbD?=
 =?us-ascii?Q?WGDijEkKS7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZCG7klbxj7BFZqQJrzLyxzQwX8rqoJuk2n2Vr0zefy5k8BAgIt+TXAozeUs6?=
 =?us-ascii?Q?jFdmKAwu4rXtLeLfILEdrE2ZTfpoNidTyXKpTh6tA/P2M8FZJcE2CcfJdWIM?=
 =?us-ascii?Q?n5hnAFnd56bT+OytczLi1TibvdkSpE0bCp8Bkk4StFbW5iPUkDQoD/yiahzY?=
 =?us-ascii?Q?MjrZs01eBIABYNDnrDGUNJOBu2tJJSAPHP93xBv5N7U4vlDFvtuqTWWyrGkH?=
 =?us-ascii?Q?y1kWj8zGyMIrEC7CT+hj7+C5F8k4bv5lBUwGLRTQpNTkp/45633AGb0UdkuA?=
 =?us-ascii?Q?yowAln255IY7FOkGzadQV5Ok6MUWruRKJCPiMnS/SHQo0F6SMHd56/f1Vj1F?=
 =?us-ascii?Q?cMnJUubeBWSjSNPy1ZxOdIlpjb0f+yybjipPjUNCTye+d4cnu4wPM22LLlBb?=
 =?us-ascii?Q?WR0WSnvrNJM3UtWozYds444mUiKv5XmF3IhcpqsGxcIhl+xN+CNSE8BKcB7M?=
 =?us-ascii?Q?xK6Xrz4YtypZb/lINifka57ilUDaIz3x1xL75gr9c9Gg1p91S+huTRT88yxH?=
 =?us-ascii?Q?urtQLlRHjfa8e09N+tco7NRMNFIV156uUjewvmz3z0poDNJ8K3QQkDBr9mGu?=
 =?us-ascii?Q?Bd8wgraRG27cPgBMAYiBCerzr8iOJXPdIHCRFZauiLx6BHYsgCZd3DMig/ip?=
 =?us-ascii?Q?+6mSCEWwjJtRj6FXIsGhJEUCmSLxqXdxeqbUfbhPiamZaVrPUrAHgvBHNRSH?=
 =?us-ascii?Q?9jPBNB1N9wIAie9yoOm05YTOQa7w3foog5pBn1KviHdyQHWvVe7stLdprmnQ?=
 =?us-ascii?Q?nOecwEXuML5nXqi7TX4Icadud0+cAHIiwpp9otJMm0aPzAJXtg+5gKQMqNEF?=
 =?us-ascii?Q?hY6CsjjtzD+4Gh/2lTst//ew3uQmfgClKP/tyjG8ap5MVd9uofnmkbm8NJhC?=
 =?us-ascii?Q?ThdXxYU9eyBdZzbGbOQdkiT89r/9kK16pXG/4S0/1BzHdidfzvntYIR6zffx?=
 =?us-ascii?Q?54kk0zL6fTuGafO6FJIAEzvuhCXLG/fSvfxWJ8pmswXDCBe6uO1WUhmaMUFd?=
 =?us-ascii?Q?XGGE2YXQ3Dedp2IA7kgcToq72qRK4IKROH35xMVBo7RL5EXvqnVKM1RJO0t+?=
 =?us-ascii?Q?51OKEFpMTGKR0onGz8/HIrb3bkbumKfxTTpvgpfCzcsJnGOz3SUX2Nv5x5Ck?=
 =?us-ascii?Q?ikfu/BsEVpswYrf4QByxd68B5e3O470qOI4Nh86fktiFJeG+hqhFq2yNYBwy?=
 =?us-ascii?Q?H9cVIQfs0J+8tKNPgPHlsdVCa4tNgM03cQjwUNbamd+NlH4dIXubqOCULY6n?=
 =?us-ascii?Q?TP6dlexAXsjzjaxxUawceakKI1dbSClozCuoRmWKZumJeBnjsMVArUjQjmEq?=
 =?us-ascii?Q?Q7MrQwc2yxuCbOLetvE7ReX7ze5Q1sPTVgfJTyRGGeWLPmIXVitIz7vbDoHM?=
 =?us-ascii?Q?tsfftQoB5I4hContYsKSJy4SLKgMClAYuD3X3cl2lh9+1u7jWB6fqBmKgF3c?=
 =?us-ascii?Q?2ecy98OASVI21c4oCuvgGP5UL3rZMfsnrYtbeXgchRVcNn37Hr6K42KD+L+k?=
 =?us-ascii?Q?TvoBsS/h7Ka/hqXGGykRTlvc4sqN7x8xRhq98tt6M7rrFcF3sK5aJcbqLF0x?=
 =?us-ascii?Q?Je6AOBrlJHuBR+nMwuN638WUGmp7UgBU/WWTMF9O?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 162fc4bc-567e-4109-cb03-08dde6a88225
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 03:02:37.0248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J86RvW6WCMPqn1eLB9KIICew9lrfjDefs4ljM8V5X52yOQp4iTXS5lk3qnjXx7wj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF8FCE094C0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B095120009
X-Stat-Signature: 31pw86qze9nyimir6hjgdxtkti9tjcgq
X-HE-Tag: 1756436561-557193
X-HE-Meta: U2FsdGVkX1/8GgfUz4j7hV9IhMbSPyoyJrtjoXOF3s7ceCjtbuqkv1StIfTa5P8ZLig6cb81q8+ME4XQgdfNl4BianjJlPNsFf8o6vNZ2ZIpXe4f0IFRg4DWn6NiesFz9E2S/ShEvUZMDqufzxHz2hScA11A5QUojpdrysUKIzv/lbYsAoy2DTmrLXAZFcGrc/PCts31NiuFa3UDxaYh4ew86vQ7r3EChqjAsNbtBhZsHZiyZOi8pNSeYfnyotNtoPIzdo0ybNPsK5VpfwU9l4KeJ+DdCt9/16yf2w9EqtyR/Pu1C1KRAZXCAdV08NAHjP4C1PQ1nIG03suKwv287VjU1LD6+UcdcD4Kj5ZL5h2XghGPXuhbfO9VGuB2CqgqIOjOcSFS9lbrzlTNpWMRQAsA5QeZRWvE4TbhhVTS+kl+aUW+xc84LJKm6YfV6RRy4dt7HVkeBrZx6e0qSMZxlVwX9JotLSnxklEcLW/LirfEfQGxya7Jxi5v8xsY1ckVwrVrF3UWN2xlzkNctk6aWlqdc70EIRbvnZn+XxX2jrL1b63LCEKiFAKWSrumVgCzzd6Pz6JWnbIgWaO7x9MJKnJWyno4mps9M3w4wPhYZclFwCb3Q/pQ4h7jWH7kg6fdiOpkAE82xkHCMtGDOa7bUk/3JpaIw0gdWTPBBzKQAd5lbdDF+zKJvdYexF8HIrgzv0/mw0X4drkx5r9ANkpTthHJvJ3ZFpL91hHKrnE+81BM4kr6jC35OJwSRMfetIs0GaqTjfy2gS7zYIF85rLPPb8LcPXDpIrbxSPYHWZd/92b61nbzHPb9ojHMuv4CEcbYIMyMdOWr2OCYhvAEGlakid+VZ/JBZpqng+y3gsTVoLerC5fSugcyuDsnoheNkZKCqiZVxmaH4OSvsbwi1APpGKzmqmelmHI1rhhekFDxWB4jG4xqEjdi2bD6CErn0bjgxSY75R9qprjmg6/ANl
 nfJUSKOy
 0zDXVSF1dtqCycZt69z3vJoPpF4xGpZJdT18wG8LlGoqa/HzodCuAtPTN2mdliyPdAQ6MsZCm9jDXCHCQaxAxpQiQac/asVPT28jt+yRW1zNCw3OVhCMk8t2LqKugi3kt2BPeJpJmV2GcbA7lxIte+d1dmrLi9sZty2J2sThMGOKSuedeXK7ND+JVZR4jONUbweAM5hMGCKIqOiA97nfbb02IHyFth/WgNuUKfLVDiRRiQJmWAGT9PrPnY9pIJiT7muCtzSMJq/nhR4Uys2xuw9Z3itVaqDW54nbZF7NuVWyn0oigOLmx7pznCqLZhmRYgF+ND8s//kh22M6Nlouo2gXzm9mwQ5FWBf4vSrY2KLbZ5HB6rPb88CcUuohPokukDkg5EHL/yCtl9VzJDwFe9u7kpuMa9n+JeNOUuk+GnItGMQa4FC0r6hUe+K8fiB4pf4AhbMAhAtg3Jq6db2M9SX49kUtuK+WDCg5teaaRYty4fkalK4ViV/4RZeuyOvoqU8fN4X8wB783rq52J194icsRDD+WFaKP3ebPzBULyDbbz2i0WJ7+uTko77AHI7wRoVAoCv7DrTXnf0emwk9P5GfxluMha34NomRDkwAx26dDNFDooOCx63mgyZzuL0Npgj9bhqhIBwoVOvcJ13gdQ+/oqFoR/yU9FSiFVFovaFOgZTpkcDIHGCxHDzIlpz7RsRnw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28 Aug 2025, at 5:16, Wei Yang wrote:

> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large
> buddy. While if the order is less than start_pfn aligned order, we woul=
d
> get the same pfn and do the same check again.
>
> Iterate from start_pfn aligned order to reduce duplicated work.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
>
> ---
> I build this and run, but not sure how fully test this.
> ---
>  mm/page_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 27ea4c7acd15..7f2dfd30106f 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2033,7 +2033,7 @@ static int move_freepages_block(struct zone *zone=
, struct page *page,
>  /* Look for a buddy that straddles start_pfn */
>  static unsigned long find_large_buddy(unsigned long start_pfn)
>  {
> -	int order =3D 0;
> +	int order =3D start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>  	struct page *page;
>  	unsigned long pfn =3D start_pfn;

I think it is right, but the code is very subtle and hard to understand
after the change. It is better to add comment to explain it.

Paste the code below for more context:

        while (!PageBuddy(page =3D pfn_to_page(pfn))) {
                /* Nothing found */
                if (++order > MAX_PAGE_ORDER)
                        return start_pfn;
                pfn &=3D ~0UL << order;
        }



The code tries to find a PageBuddy starting from start_pfn starting from
order=3D0. When entering the while loop, it means PageBuddy cannot be ord=
er-0
and ++order increases the order by 1. Your change fast forwards the proce=
ss
based on start_pfn. If start_pfn is not an order-0 page, based on first
set bit in start_pfn and how buddy page is chosen, the next possible Page=
Buddy
order can only be __ffs(start_pfn) + 1. Your code starts order at __ffs(s=
tart_pfn)
and it works because "if (++order > MAX_PAGE_ORDER)" increases order
to __ffs(start_pfn) + 1.

Can you add a comment on your "int order =3D ..."? Something like:

If start_pfn is not an order-0 PageBuddy, next PageBuddy containing start=
_pfn
has minimal order of __ffs(start_pfn) + 1. Fastforward order to __ffs(sta=
rt_pfn)
to remove unnecessary work in the while below.

Feel free to reword the above.

With the added comment, feel free to add Reviewed-by: Zi Yan <ziy@nvidia.=
com>


BTW, I also notice that when start_pfn is an order-0 PageBuddy, the
"if (pfn + (1 << buddy_order(page)) > start_pfn)" check below would be tr=
ue
even if there is no buddy straddles start_pfn, although "return pfn"
gives the same results as "return start_pfn" (no straddle). The original
code before the addition of find_large_buddy() (commit fd919a85cd55 ("mm:=

page_isolation: prepare for hygienic freelists")) checks start_pfn =3D=3D=
 pfn
before the straddle check, so the correct code should check start_pfn =3D=
=3D pfn
and return early. But since current code is functionally equivalent.
Maybe adding a comment about it would be sufficient. Something like:

When the found buddy order is 0, the check would give false positive,
but the returned result is still correct, since pfn is the same as start_=
pfn.



--
Best Regards,
Yan, Zi

