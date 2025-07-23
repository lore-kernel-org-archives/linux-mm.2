Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1767C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 605056B00D5; Wed, 23 Jul 2025 10:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD5F6B00D6; Wed, 23 Jul 2025 10:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3A96B00D8; Wed, 23 Jul 2025 10:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40BB56B00D5
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:26:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19EEB160688
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:26:02 +0000 (UTC)
X-FDA: 83695753764.15.1063F9B
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
	by imf22.hostedemail.com (Postfix) with ESMTP id 578AFC000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:25:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D6EHIOEF;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753280759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xggzz74VhrGJVZh212xhWqbyvpgt7mcbG1OonLM7cXQ=;
	b=gv69Dga5LaH80PcBXFssXOEvbyl5Qs8+sp4AP+gULO9AaJMZ3lsdfbcLU9mdirjuL+cB/c
	cjGd7DZqgeliH8pQCsQxhJ6uh+oV0Axcy3CqKTtW0avJI/Rru1Un4+hXgEX8LJINVJBUM8
	V5NslTOBAjuxUr1kctMaitIfOIO5eho=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=D6EHIOEF;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753280759; a=rsa-sha256;
	cv=pass;
	b=PJYCrssnCbI9r6vrEpIlfgCetHBW/zi0nCdXhP0PaCz1F3H3OJddx5iLmZZ/RJEqlSs5W2
	RJgUtJbWiyhYYiZe/34lhbX8pDKxPasg91jljvJSfCfXSBIvkpd9+1jIosPF5x8LyqYk5n
	2PEnJ3WYgr51F7CDT3La2I+SwNiZCGs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLR6somp83MDgbo+M6+VKbbHtx9+IbA0Z6LsxGagXIVFR2CwqxhWkJYYu5HGDG9yXbKx7L3MYCfBpKxxGFwlGbx2srlyTzVha8acK2BnMty+MaKZNGBk2rL9hWewJxXOvxd8AyfP7APs5EJLwMWGeg7Sqc+9CknH91laTwBzx2qn92NqZXfyrRYNlk3D9YAQ12s4GlS1zbvDkPjW1+Zps/K/Q575zVXGLPIAGH/LAfSCsN/kh4YsZB+XPtrbd+jMg6NLHk4NzqRwEz4M5vGAWd4H8xn5pLdQf8KSCzAztBpeWEIH+ptuLI4xh8tWTGHW1uSy8INH59Ru5aD6Z7sS1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xggzz74VhrGJVZh212xhWqbyvpgt7mcbG1OonLM7cXQ=;
 b=nmo6iOWG5UOm5blrYSw//pglmI2CVjEX4fsdkaquEGU05pgJVvWXc+TmeiD0/KhOzUzk43B/NLFesuslpNMSeuIP98OWoLdshA9o5ayLFsl7KXEskvJFrXF7WT8AAQMQMuNfwqJ/iA2HOoRvbAv8vzpFL7zMPmwAzJwz298phqJIrXT0shyB3+uX0RuMF7B/jymNXEg2ihICA79/lwvhSgT2JqUSZLSE/pMUJuRm7pTmJiiX+AbCTFbsxkTcGMLXziyxTu56MvPo7sFpTrzPZMD5+zT4JDxe1dsUbBsgL3ZztgUGs6atuJYBYjl9t8Xuij93jK5/wP/exA+8/XdaaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xggzz74VhrGJVZh212xhWqbyvpgt7mcbG1OonLM7cXQ=;
 b=D6EHIOEFHDY0cngeVAjl9bwWaRubDuWOy4Hk0pQ49iFVhPml25Rh8Ysc8ytw8kqH0jy6BWeSrB7X1uSk2M4S3qngJn4/JY5r6J7MTC8bAKYTeUxStOGi5AsfwlNogzYv/+31m72O73Uz5DGTH6PGIjoR66KH8pN7pdnhYX0lrJBHu+52A/ZKNTDnMJSJFLSD4EYopkB8/728P/9Y+v2K/IO2JYCHGhElni0709DE9/gXIhjQfOzGE/Dnz49o6RoBq2qYypjonueQiWfMkmIPkf+d8yA1UCoqR4Ww0VPVgWCCyv97eM8lyeOP79z++UUkB2BNjfOKq44mLjlC8C1b6A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB8560.namprd12.prod.outlook.com (2603:10b6:8:189::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.21; Wed, 23 Jul 2025 14:25:56 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 14:25:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ryan.roberts@arm.com, david@redhat.com,
 willy@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 catalin.marinas@arm.com, will@kernel.org, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com
Subject: Re: [PATCH v5 2/7] mm: Optimize mprotect() for MM_CP_PROT_NUMA by
 batch-skipping PTEs
Date: Wed, 23 Jul 2025 10:25:52 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <463ADA54-E6CB-4B63-B306-E108E303F07C@nvidia.com>
In-Reply-To: <20250718090244.21092-3-dev.jain@arm.com>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-3-dev.jain@arm.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0003.namprd21.prod.outlook.com
 (2603:10b6:805:106::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: 156169fe-4baf-4605-4e8a-08ddc9f4d682
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ORzCh3/NHfcCWOUnRC5ZTcar5QIURRRxPgWidXEyjAwpagxBhKXYhNftGUuM?=
 =?us-ascii?Q?R+Or/8QrjMYwaRiAgedeUKrmOA0HU407Ee0POuwrKn0jfubMbyZz4q4AzkuO?=
 =?us-ascii?Q?WT5Inmnw/Xz/QG3kZr9KXXNbk6xLgjpHDE39UYz9g/txiA4C4aEHZdtZKILI?=
 =?us-ascii?Q?fviaQbb92uMJ/gJt+gH8B3RRYbUqjzjshYbduJdYjcH6XBHHV5hBMa1b6uQY?=
 =?us-ascii?Q?8oM0WQdlj6VZ798bpkGTXiAk37mTM5NNl4gVQ+sQMV6pUZ+1OCD7VhUEZZIw?=
 =?us-ascii?Q?VKpzl5l/l07Mes05bKOKnWBiPBJLH3o6+4VXiLsEQ7XQvZ/1esSWuwDdN4TC?=
 =?us-ascii?Q?mr7rDRZCWHWjWO9X4vKyvazeCxxuXwx2Z7jyUXLB8m+w4RMMQ4JK74jqf73J?=
 =?us-ascii?Q?w+DsdKzOhzfxHvhqMmTneuaUQVF0xM4uUU0wMWwGRHiOb0xWqluQtVq3G6bv?=
 =?us-ascii?Q?bInc5KjnYXgRMGp/00lxrBJbWA9vAuAVNAb0G2Koo5BbDQmqzUAviku+3wfg?=
 =?us-ascii?Q?1sL1axqJ4qO2MnBUtVjPdm6sguXdLf2zDBsFsEj57FXw9Y3qmzJCTy4TolCe?=
 =?us-ascii?Q?Hs88hDIbNE7ktiJxT7dLXuz5fxt770D9yNuSyE3H8xZT6SMyXpxQaANJdei+?=
 =?us-ascii?Q?w2r4E92uS9BCP8ziqbxjux//O0Jjkal5jOu0c1W4ljsWWtpRFkEvxzlMo1q1?=
 =?us-ascii?Q?ce0OK4zX/MVIrdYoFZPhCwaf/p8r4eFLStpdAs807TNpPZBH0F8yvs24wSIN?=
 =?us-ascii?Q?nxcRdP2n4WGhs54NUZOfHc0cQ+cfvFfPfLZwKnvEvsgGQIMZzCykQXrJVuUF?=
 =?us-ascii?Q?1sdJkKgoDUMKNmmVNHu17R3Iy/t6hfQ7l0UgCVCDlF9gE9Qt+7zAFavXw52P?=
 =?us-ascii?Q?0tLTyNu8wU//btsFVEZ638uj8NN1mnBqPjnBsyPPLbhafOFcuyqRwLqLTqWJ?=
 =?us-ascii?Q?0McdVTZITM8C0lYh0OUrdOd/WA/sOlS8tvrBZivNmtRR7v+cTIM/h4tHibss?=
 =?us-ascii?Q?896dA/h5nXSYNCDZwy4eK7ULay54OZqwSqGwReMb8mj4EVfswcCTfbETlYYu?=
 =?us-ascii?Q?kFyMqjfUyizjtLUQAvKt5QFPEehYq8QXs5gJb7vwVUUUykyp7YSU/h7VHFQy?=
 =?us-ascii?Q?yt/pkqGe3PTm1wdxTsilqQQ+/8XOdn6zfbtaBmj1vA59zpM9y3ubghqhPQ+w?=
 =?us-ascii?Q?PDDdyRmSYiuc2of/+xR6L5ng2eOFAYqVyxbyBhuqagN5mH2JBDW8ZS6/08jS?=
 =?us-ascii?Q?CSsdDRvKhlLt01IulrJaYT6NlP+Be/42MVhbMsW8XhRu0smERjMcnx+V9d0+?=
 =?us-ascii?Q?pUcJaVFufXbVrQvktOk1xX1yiXUrVnYVUxgRkTnFVzbx/Z1NwvP3ohQXQ6ch?=
 =?us-ascii?Q?I45K3H7KPN1OhFR/OXOmEG/iBkwG786XSWPLLql5PPvO3rTdlw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lXj+s4SJ1PpVPUhL2s2FpSJNDGcBCyst3CxzmMo1Oedjbusu3ocVA2xGREtT?=
 =?us-ascii?Q?ua7kq4cvKgwR6kJWl5njU6H+LmhaShFRP0SzySjLLgy8wYuK63/ORaUoxQnB?=
 =?us-ascii?Q?gvb8ti3RI6iLu8Kd+hoPEzny/8F9sRIXMUbKjEIYrvf9dYYNUxI7JrRSztgC?=
 =?us-ascii?Q?ESkef/t3Di81lDuZjsROjloP7iBqWDnX49DhkO7t0IvI/OCRCLTZl4IiPFsB?=
 =?us-ascii?Q?aU40nmg9tidAp2Z4Kg9zz/zrrJY5011S4/1SySYH+zd1pbUidSZzlB1dHwUs?=
 =?us-ascii?Q?XpUu73sckmFUkmI3GBUBnsq6YBJ0sm+pQkziMZX7IGPrwrGo5CIdb7PAZ5xJ?=
 =?us-ascii?Q?rymkReSJWp57p4wERg9psEYUTtnK/I06mHm4jrpobmQl7ixlJolxHF3tDw4H?=
 =?us-ascii?Q?pzaFc/R8usQvxt9cJLsTLNDe5at+maMmdqBOT2TkOU6VP9HH0bwwIKXv+ICh?=
 =?us-ascii?Q?ZI+wZLz6wyjfyr+ajg3Um4l9rtmgbWLHUTM/BqyICpFUWw0wEVJMMkCpM5Tk?=
 =?us-ascii?Q?xYKd10B+2EC2ya6LEQ4LQU9WSl72B81k0IPjWpMhSlym7PJi62TLxeE67nnl?=
 =?us-ascii?Q?hRgpiSsbnxSCD/ofMZfrriGdU1wanYyyF14ydYQ9lJHItRMrVYT/K+h4OPfb?=
 =?us-ascii?Q?kzHE5Y45dUlCStDnUCBDyQHdHFNU+srBDCXmIxmL3l62ziph8qEtJZ0A7FGx?=
 =?us-ascii?Q?YVHlmkFpZe6Eeyo7F91JCM9AwJLURmI1tBK4URV6GSttgm1jRYWnejSyAa3c?=
 =?us-ascii?Q?aKQ8CZbZ759YnMyEy2ClhsDigLS9/lpV28YTFj5IgMpclK1XlOTSB5+ezRvd?=
 =?us-ascii?Q?H5B809lwjulGTA1vZwMUEA5i/+kluDBEyTqfBBNa9+h1EZko8KFqzIurLAev?=
 =?us-ascii?Q?u+LX5gxhXJnjcNRVaIRd2PKuuONyqVy9RKDIvIsPIQQlcgNiM1Hi1zXFP4LU?=
 =?us-ascii?Q?89ALI70OqwvgdDWvsX58y0YsvFuD5BmNHUPQ/MSs9hdHxQREK/iZTscgvV6U?=
 =?us-ascii?Q?wzZAH1EIogQj909UAanWg9431ywtpKZ5TA+yXYO1lmGgLbuntd5aMiRiEqid?=
 =?us-ascii?Q?dU7h6WNGQuQQHHlWxs/kn2VOt+0zayptc0LJOghTOUG5aDGkXRtYGETFl/gs?=
 =?us-ascii?Q?6GW1m9lIynASfO3h3TTkG/eYCeOss4HFI2VLm+cPd3fnrgeR9jMSAsr6tcZ2?=
 =?us-ascii?Q?acAals/4EieKwsY2uv8ii+ARhWkgwQQRmYF4juK3mwXSrGfWaltU/Pvr/Zhm?=
 =?us-ascii?Q?GpbXcKjQnDT27Ry7NAgD6QAIG+pwf8tFn1/hbQ/0S6Vis/tUhJeB2peJGcCD?=
 =?us-ascii?Q?tQq5740Ef4IOFeyNpPOENWbVAzjuj2GZnGasclP1IFz1TtUvtQC8d6/HHIJg?=
 =?us-ascii?Q?pbCCTkO2xAwS/LGwrbS+pHhNpxm/HAXBImbPT1iEWTOPsb3hRAH+WOuzvegW?=
 =?us-ascii?Q?VCIxLuHT886upk+5hRCWyD0Ww93j/f1YUIzO8etLEB/eIq2VvGFh8i+puObO?=
 =?us-ascii?Q?+1vJO/OihxLcpH3XxKfFSGGoItdkkP/ivi2OZrG+t1mr0wXQB1G4x7N+8AkR?=
 =?us-ascii?Q?mrp7bpFfr7M3ezDguGArG5WlguDBjG14XJKYfaQv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 156169fe-4baf-4605-4e8a-08ddc9f4d682
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 14:25:56.5581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGEudM55H0inIYhY7Kpdmxw2yQOHv8KaIqEAaalfC1/+8MBrYN1bGQZ7GoOnqCFK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8560
X-Stat-Signature: sgwrf8bwkdhr6mtb88tbpr3ycj3fqd65
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 578AFC000B
X-Rspam-User: 
X-HE-Tag: 1753280759-879035
X-HE-Meta: U2FsdGVkX1/Br3egeLfLiwT9v/BRQrFFqbT6RcTOfTjp8S9q3jTK0k4eTfMPlPs9De+fVaq/mQV8SGjgrz66BHPBeGVwQGVU7ta5ldaHwMfNVNZS1tloUV38DJ/WBH6A4Ch4UeBmBCg7/ATkGnktqPpWgLDezpppJHWx1kBGH4kOTy5Rp0s6chBkuYf57jTxsl3BLVZzcbCutEQrfmOVVI75mXK+5MhEcIEr5C4ZffogzqtY13VcmDyV0A03uEmVnc8Ci8zRzR/ZdMQzRSKdRDnlbg3xe6xTqcgDVJF+XD8Xc1GXTiD9Hsva++M42wddW/Xylm5xFOlea1AFF3v2UZerjk4EK4ojs0QU/dI4oKYtgkv1qSAXardQ6KXYCOd3vsbQadFK5yL5Cp/s85xDzVqHiKtYTc+A3+n+1Sn6lDenrt1I+cPQNp+/NcnEuSulHyhTuBN6hbK8dXpw5oReua+X0jruHvk/Z/BZiFwf1cTqJrDKX/j6QvmMW+dGVooncSaIeFmAAhFHQd/4JdC55ysEpTwOJkY4Q27GOujwKxxSQkY5JgP0QlRFAFjo50f5hRNsAE2s1yqYmJIeTK30YE5lj+iNmyYwNCAgsJgROSzLxi7SlIlU5nyaRS5ZSVnyNCX3Xoct6lu/UZiC42T0An41Hwd4qaclrGRNwMrlInbC8zMDLGFakHL9OikEP9xOoXde/MuF6GWa+2Ci0CIPxuVdbGFnkS2wZ26qNrZzVEQ+fOGDftmiOBY/HUPhEjThuGW6gROEWDJhpZPUJ0nGrTSK0Uk2XDoN13dmsok3ClQVy8kAmCun0ZEBhn/ezSvHdRcdkhJCjKulbj7Qzz0bs/cBCt2wlaLC9oJDrbq9idx0jv5CKuwYInOIncJfRQm3ka6oOf5JjjcpRe76NTMYC6NbxfqdjuT+9JUwLvmZh25/dP4hNLXQXonBnZTTlII2IxE535LgJsN6zJqDann
 rotmCaDx
 YkXdydwW9ZOAAgGnMkGMbJ6y8DtjAerMRP0WsKe6M4JK3Uz89Zt9B7j/uju90LaDLwQX0mbCFbuswHubTn0mHf3/svCsxCerUd6Isb/Q+9Efhecjeyo1MApfr1YEccZ8OYrYEaL+BlHh0fvW1bpWgsYVd15ihWCeGuqy0oGwkVWejuKsN9WfDmyQ5Km8SgOGudevXq+RnVeO57HIuq6AC7FVN5i7YDIP/GzYgopTYNzxWcK++u7OMaMwH4YtirzOA5LKZPCzmXfFM7N5CT9Bj2231RnGC6BnMQZsRPnBZuxBkcRxFe6flmnaEp4RNtkPewwAPTq7vQIeKTSTErrK8t7XQTEx3HxxzzuLezQeqc+b81AXSPumvlvh+hgrlKoNnMllzlrVJBmg2SvcoHYwoHjUoqTHV4C/qiKG74c58e1Lqj0H+ORF/W+HbQvEZi1tkcTYmZ+ZGaCRq51HWg/qf9mweo8EUw92aPeMjc9ZevT7HztmGCgDHGQoe+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Jul 2025, at 5:02, Dev Jain wrote:

> For the MM_CP_PROT_NUMA skipping case, observe that, if we skip an
> iteration due to the underlying folio satisfying any of the skip
> conditions, then for all subsequent ptes which map the same folio, the
> iteration will be skipped for them too. Therefore, we can optimize
> by using folio_pte_batch() to batch skip the iterations.
>
> Use prot_numa_skip() introduced in the previous patch to determine whether
> we need to skip the iteration. Change its signature to have a double
> pointer to a folio, which will be used by mprotect_folio_pte_batch() to
> determine the number of iterations we can safely skip.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/mprotect.c | 55 +++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 13 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

