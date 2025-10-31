Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B72DCCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 16:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D788E0114; Fri, 31 Oct 2025 12:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDB48E006C; Fri, 31 Oct 2025 12:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785F38E0114; Fri, 31 Oct 2025 12:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63C9D8E006C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 12:19:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24D781DF507
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:19:53 +0000 (UTC)
X-FDA: 84058920666.03.5B195DD
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E939A000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 16:19:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z5wqdC7L;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761927590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEziPsmbFReoVEYcuS1prmy0gSsXz2mCmZJbs1RkcaU=;
	b=HFOU3DfnwfYVS2vlbaBPcSMTz0uG0wddgcQVCej/pcEnH1isOYWW9mZjrinPa+gJUNmG2S
	UBtLMMLNzz3JxNH5dOkTg7/du0sjjybRpWrYRARbdfrWACkCA7+ySrzDqrg+cnuLyul02Q
	LlJ4TXLgAPpDLAd4/xnA4tv9kFnvL50=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761927590; a=rsa-sha256;
	cv=pass;
	b=i0tQFOlXwkm3GdsMSb7pvZRaC5sGODUEPR8rGtt2wGNBN1ZA6puLkkwa/WOtZ3wadG8N0O
	AKYz6hgfNsH6K80gSnPDRbq6z7KPT90KksKXcVoxyQ+Kl5z35wnNymIYHkxsrmbZvX+wOE
	jVg7txroG7vHundj5OuSgDZzYwW6sMM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z5wqdC7L;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XYEk8mOrJzDpLAjXfnyw1wYL1qs2k10zZgwbh7nkK1oYTHp1oXh0LEfOh4AgoxosgxTnb7Ke940FBzV0DBWkCVzzHvjpeasX3P2aqE0rgYjE7HM2xLcdbFaaW9tER1IqgZd1BrS3ijYYTIfkgQ4ryN/96wAEPlxkkHYgA+TIpFvPgLWFz6Ll8f09WAXP6e3X/tJdAQn9Qct68ajN7xIL3ERQGq6r4DppmObh/p/uD0R1yhRpJivvcoV/OXGCP7KECqXZbgQvMkeJYSUgi5PwXACJg+hFkAc3X72+B+H6qFW7aU1WoOAJBe+I+4D74Vmd3Vbral84aWWzbEB5dDO36Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEziPsmbFReoVEYcuS1prmy0gSsXz2mCmZJbs1RkcaU=;
 b=IfXcXKgS3DHEr/RkLjmPjTK3xq+GGNvLJwynsGEfD+jfYa2B4IJVRrRlGq7nIBJ5XaRbftWq9pWjWMTi3DEq1v7I3GE6byEVZSxlY5xoKukYG07v6x45e7VliEflz6/P2je7bUmtRIH36o0OmptyOn0Ua4oaYYE0DGKf0wPRgCDM4/MrcSpY379WsrTcAGySkLmaTYsXvt9SqqcBYiXI4kcjGr8IEsvUyplZMTtIohuHVt+R+/A5BLGypaWgh4WPrC1L4/cRY5eWmaLXUrrxSXx/VLR60jjC9ZypNbMXhs+zdY7zvE5WnujdkQgp0dAwnxQpYeXx/VpOfMEQUogtsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEziPsmbFReoVEYcuS1prmy0gSsXz2mCmZJbs1RkcaU=;
 b=Z5wqdC7LTGvs9tHZzav/BSbipx4CJ8SKmWtHgyDIiRxSoolAN3SDCkgfzpGzpcFtDaYxS9/9Y2IShQ1ymiPq8mczpAD0F0mhnSAhpw696Ijpx6wga8TTSVNC/AtgYqO74vKPGR/DWzLE1AnVmj4nUw+KDyX0hhW7zr+fLvKT/fllv9w4YGXYGfwYc/3D/XVsgiB2XCS21ufzm1Y7/AQXciPyo1HjSMVmZPVz5uyrl9Jo/SGEDEAbucOoVHxiJ3RwerinJbdLZe944aFLTH3s9r63mC/a8gatNWoDk+x6bHe9vvPvhl/bArklkbPwg9uMy9/5a2hCvixF9i1M650/rw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 16:19:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 16:19:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 1/3] mm/huge_memory: add split_huge_page_to_order()
Date: Fri, 31 Oct 2025 12:19:59 -0400
Message-ID: <20251031162001.670503-2-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251031162001.670503-1-ziy@nvidia.com>
References: <20251031162001.670503-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0302.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e68f3b0-63e1-466b-9441-08de189945fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EnEBibC+ZNpaFMVOo5/+C8m6bS1YpRJyvK6Xwd10LB6vgFeO5QkQ8jf9yekK?=
 =?us-ascii?Q?fTZ+pEZMPNlw1jmA9EhLedRTgmIrSiJbtmrRwQ7CAO4tOjSsaV+/sTWbP0Un?=
 =?us-ascii?Q?CnqxTuLQUncriIJNjlwVFvDm3/2u+kfnHOD39+sf1YcZjWy19xkaRoRRWSnt?=
 =?us-ascii?Q?6agR20wEXmFPLjwsVfdBNemDf6mnZZwm7Zt4s7UqtdFW6KIsaXZj8w1gHbEl?=
 =?us-ascii?Q?r8MoNkZNt097zutfFB3SMW7UmyPKz+IJMPGQi+/IUZd/hpqb5Jtd0NT8s09D?=
 =?us-ascii?Q?Ce5cpSgIoT0CNbCXMLaR2s0Yn64AlDQR7afqIvLrHP9DWN5m18wB6r6eOXgK?=
 =?us-ascii?Q?c7fsYG1T7knkxl7ukHlrnw2qg0scFrg7tnP41S0q2LQv40xWHi18Fknb1ESz?=
 =?us-ascii?Q?6juHO8rXRtkzcEYzsymkI2nKLul5Bqbfyhwtd0AW6FZ6CTh1NR/Ox52ioUc2?=
 =?us-ascii?Q?3T26h4t9jZ2bWmfAPPIgpVbbarfs2fQeuEXZAM7JBfJItKjcTON8pGnsO8o/?=
 =?us-ascii?Q?hsPOoOVioLmdmHaCSeSsGqPgkIkrhfxaq39HBFc+q+r57jzOleZL8qc6pufS?=
 =?us-ascii?Q?Vv68yRdECBs4JP4WLddNe4kPmtiGn7gLyKQ7+tHckkWIrT7AulPal0LMvP0j?=
 =?us-ascii?Q?TN/3lT8glvI3m0qTimytkMe3dBZtZtvXlLI7eVSAInTSINZpLT93EqwRnTxv?=
 =?us-ascii?Q?V8QdS4cc8pW06DoK6LfXboBTQfbaX7kTQwjtS8AxhGKtVaygyIdC0GKPapR1?=
 =?us-ascii?Q?VDYax8Jy/NCNSI0km6MRZOSpwcXPBCzIPQ2/aHIObiuO//EQy9WRwQhQbj81?=
 =?us-ascii?Q?BbRhtfZEW96OiZIo629DRyLsIY9CQpCPf8MPhrfP7UlZvL3v3gcjegNRqwI2?=
 =?us-ascii?Q?1r0IQ2t05TuDb2LD4zYL2EVHOmXG4vWeLaZoY6iw+1ehS8cy+o82x8fzckaZ?=
 =?us-ascii?Q?DbKRYCLnGcWi7BZ1SxboIFFBBA0qIa8lT9KKx5s7vGVP3T9wgubixGRXb7mV?=
 =?us-ascii?Q?ZYKZrrPc2VZe6Vv7VL5t//gBbKB0yugVReIomyVWVxi02e6OLFRNz2rLBS3A?=
 =?us-ascii?Q?w9Nt2s8fvfRAMYRiAcUJzewJcC7HX3vvlU5Sya0MlvAjn3KPm5T0/evyjcwp?=
 =?us-ascii?Q?XUnsmqj25lWMdcXtGZveyvpTXZvfyKyuwwfujRDGbgtM09c/GC6xi7igVcbW?=
 =?us-ascii?Q?QosyvsDp+k3I1clJPDpUJjpof/1jl62eMZ3c0WmCcIlNxNRraYAK9TJ9bBxq?=
 =?us-ascii?Q?Xrkq69KxGema+jM2ozsNDpQV3f7K8UWNScsaHLNlGqf72eDb6vLF6tXKv6Gp?=
 =?us-ascii?Q?OtaFcclQNPncYdNRGx011AEhzUvlQOf9kc/q2QmkbTW64Na5zQZrrwk8gf9f?=
 =?us-ascii?Q?oR4TCdzabolAjlRo82/wf01uHoIZgdetQT5nuwR41xTnU1FRNX7GDejxBwYg?=
 =?us-ascii?Q?1qo6fPJawoJamlmZLnRqpssXUD5EZ5+J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zXl4crG1hRS0UYmyzeY781SbtYcEaVXcwtX1RO51Cb3Q8CVZiz8sUV0h++0K?=
 =?us-ascii?Q?NfcvOZOV2KO5aAWSLKjXGFfBTHb3ZzVUtetn2yKCPRia8XCrwOmJ3VWDvPh9?=
 =?us-ascii?Q?ZOPulqllbgXmFiGgUQoRRperKjRqb+i+QGFSynA06xlCKftTFFdNin6O3rR9?=
 =?us-ascii?Q?KKA2UVcBnbBPc0ZSxL0oO3hOkR7lyue3FxMC/trH9kRgrFTbWI3QxkdHlOn+?=
 =?us-ascii?Q?mCk2wEns123Sk12uH0vK9oTAUempp9Wgl17NhpfhPlHzKIFWAohVxL4w59Q9?=
 =?us-ascii?Q?3G/n2O42Ygg1fNgPUnGSCGNkj/sHrmJNfCnNY34E0jQPnx3hsLNTvy2Rjf1t?=
 =?us-ascii?Q?n7EmN0aDCgLtAcFIWsJrM4mvej4IqR5dyshPnCEO0aHkarJ+qaotbwtnHSZB?=
 =?us-ascii?Q?RTmZopQsLZarg05iGR+0lcwxX5/V3dJIYs70J7FrtfZJNiP3okw0ui5Ncma9?=
 =?us-ascii?Q?jv+66eq0lBpNEyiMK1/pZguSWdGAwL+eyKfoIwLRxh4IDJSlfPGKJeCAwi8Q?=
 =?us-ascii?Q?to79TrhE32VKauW/EvDq5bKi4xijbVlok0rY6HN8mVhfyc3D00Otd5IcBGf9?=
 =?us-ascii?Q?yqbgUAmthzsPAxC+YDIwempEihygvb/xkkjTzyQ4OAiGiydMrHUGbhEOvqOI?=
 =?us-ascii?Q?G0MkxywW697qAMxlSFH1i0zdysCtg95XCw6kClUaYelEhPMtnKJjAXrWjFxf?=
 =?us-ascii?Q?l9DYyECgFjOujSM+EAtuvB2gfl2/jmN32E23P8DQxrQIrER6mmBykLlqwPWt?=
 =?us-ascii?Q?/RIF3bTRL4+Ik7oafDeScD7zx24On790AZBkURu7FriJf8TI5OWfB3nUa3pw?=
 =?us-ascii?Q?XLhHSQLn0uPvjhUHSZ8Nr/Jf0kf39hoYc1bow13Zyb/py+dHqZTvf3pQL7fi?=
 =?us-ascii?Q?OPjuY+kaeCfIwOX7cFY3U9qgq+mZyCFHKKPyTjqGdJZdtk428ZrgMa9f6mFx?=
 =?us-ascii?Q?htO7WPLZ+3ZtWh23XKtyXWdH0Pr2Djf1PYCU6Wf4NAeiLGjsH/wlKa12xCQF?=
 =?us-ascii?Q?C/XW2vxrWN+wAzsvHH164sex+cFiZZaDIOQ91LNdxVeGBuj5nTg97aHDnCx6?=
 =?us-ascii?Q?m9WDfHVDOmEC5spIpsKPW6bjABUte+3eO6yTHZyRfOrty+x0SmbZNx3/9HLi?=
 =?us-ascii?Q?AkJg2xp265yHzkDZOb0qny7E//f4NmiFhrkV6otfzQs5YarhANpFuZ7BpXDH?=
 =?us-ascii?Q?X3K2tFHasncthWsX5qpn98Uz/3atJm7Oklu9pc4qZVAJvIfiaAz98s1o7OHt?=
 =?us-ascii?Q?QIBan5AEw2mABuutEqAgvr6+LkFUPywUC82vhgFAVbRpJltXEtFbZArOKZ50?=
 =?us-ascii?Q?YjSkOfkEkVL0e+wPIl7ifwbOpNE8H6aGZD0ABFof6H5SIRHWi0Mh5d5Nmz/s?=
 =?us-ascii?Q?jliQPa/uD/7rjXpCLZqhm/aRaPtDR+eAc/ooaVzex7ho/y4yxjO2U9a5QIs/?=
 =?us-ascii?Q?x1jgZI/BLB15ozp5TjzeWCTuGx74M90dJkOlcyq7Y5B6nEJelTzKiLw62F5E?=
 =?us-ascii?Q?KYWPNkSgLiRAnZNX/yhwJzmN0mByeqb9RdBKOjpRINKI/LFzS1/MG4n1xipv?=
 =?us-ascii?Q?ga72lOfrwivl3p6b/t+1IZtujwUHrxmO4fujWNe1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e68f3b0-63e1-466b-9441-08de189945fa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 16:19:31.7512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gRsBBuoFUbS8rZAPi15XAOPbtRZx0oNORAJq3rmsA4SuEIjJJJj8PVppvvoeIKq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Rspamd-Server: rspam05
X-Stat-Signature: 5ki84ey7x4gasqp7ffk3duy4ny75s99d
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E939A000C
X-HE-Tag: 1761927590-540205
X-HE-Meta: U2FsdGVkX1/pWpP0HFxRNnzaFL2GJCvoBXwGoD8z8YJtEIDh1/6P7JbnUMUwoIDlqlAZDnMog80niub7PxAxjTXnLgXTS35CqLfMWYpAGarGaPJwXZVrymB+vKktmu72DMkky58DItdi2zUF905i2P8B7jKI5heAdS1jIOcd6uXSkKIXtlGPdnLZVHXDIRr8DFsKZgmJ3S0tPixsos15m+d+MBecH01cKawSVz8DbH+I+yhWGz5JXts0F6JA2ZvxGGIP5dQvzwB+1r17T9HZVpWpE/g0gTwm4Rh/SZemOZL07WQuEJDd8QFXyjDIXZGOKSyfSd0UFXmCCKdX507LKKnfhXfu8dS6GpAwAvRQrRZ1YPb7t5+EM2TV+ljLIFl0nPSMeVtH+nxe/bTWaa6a3uXgzkhs70iQKgtDx2/zaPfUXnxP4FmxK+yKJlWagm5t4a9gYjKUzfbQxO6YwjxJdVvG5/QJYWlcJQ2AyezIDtUm6WlUr6CKkwbbVeeztb97wDCiPhSNiKBQtuJSutCHMaMOpJd0FU2G7Ghl7Tkh14J+/tvWSyvJRA49/nICGT8mycI042e9Q6xBkz4TDDarjc4wm1oxfF/arOrYW0FESsGhkpdkUNa9WZoKem5pYx/DKCFDJ0nIeOHnVPqU5zgd0rSbA0F5kQHClTzClpVOW4rtf0oXwKfTqlE2VtoOWrt0GgvxwRTc9tSQTTEPZogFnkfFw6pBuTG/dPzU/fwDAv2t/VIgx8WLnQ4/cnwXFxSPlUT56FXtAonTsnGE19uXXgnDiF4VyciYOVYTqiwPYidpG0rpR9KtbvtG2YWGfPGhO9Sd2mXHENWGRAHC/b6qlCapnVqlArg7toq6Jzb992kNduO3zov8GqKw+k9PoX8ZkvNnQHDMm3n0HKbDUN5jXK7OxBslQwgm/iKN8DvUeFldHlS+pnST/RsGVAbyb/lJKt1P2oqsJn2t0bIzfiK
 2s9rLixM
 ef+DC7kFWnGpztjge43Uel9OKDIhugWGVkpb9t6VZffqqRMCuVc5nU5/E+Osqyoj8JAVgGGwzT+GapM0Lns7fCbIIaTpejHMrBNnK2JboA5+IM+i9wTzPu8/Wu6uJITxumOR5DKkDFfrl8ZBcaJnXSrJJFnIgpL5aH/ROA99UdLAD0so5AADlFZwr5bDvWIz64sgT/s3mhyI2j1AowxdRgNO0/uuriz1ijfnGmOLHpuDB8T8aZqHd1OFNIeWd7LwDMGHZXTAPTFC1IZ7+HojSJvTXykdB4p2I8X4dgpG0e7IIMhGlEjmWHGhouy3U0oLA6LDb76HnbeEs2sYkx8pkVCfYRMQxg29P/pwlNN2BDe6wDWWwzcZ8XI9fTTi10xH/58W/mdYVa2Nb3kiC9TNmxGDbF3Bc0VYFKph9BE3193Ns2n9EyG18nG3g0jlDijkW2XcRB7AN4yZBpSzE1kedmQTtZByezeanDkSV/su8jJLGHlB9brOtCJUI67JKUqEkvmhi0chr277WtHNWxtjx6UN+R4JL7K/bpPWbufQDlp+QuaRAA56xVzonlezekTfP7PUMbt7kID/Hj6+bnR8JKBJiNF8BNHbEVCO34uWuXMznXrAnVi6QGxugPGFjlkr0E1UWwSSbP56LWbCXKDjB6U57UA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When caller does not supply a list to split_huge_page_to_list_to_order(),
use split_huge_page_to_order() instead.

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7698b3542c4f..34f8d8453bf3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -381,6 +381,10 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
 {
 	return __split_huge_page_to_list_to_order(page, list, new_order, false);
 }
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	return split_huge_page_to_list_to_order(page, NULL, new_order);
+}
 
 /*
  * try_folio_split_to_order - try to split a @folio at @page to @new_order using
@@ -400,8 +404,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
 		struct page *page, unsigned int new_order)
 {
 	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
-		return split_huge_page_to_list_to_order(&folio->page, NULL,
-				new_order);
+		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
 static inline int split_huge_page(struct page *page)
@@ -590,6 +593,11 @@ split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
+}
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
-- 
2.51.0


