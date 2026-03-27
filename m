Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB3E10ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7254A6B00A2; Fri, 27 Mar 2026 10:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D66D6B00A4; Fri, 27 Mar 2026 10:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E036B00A5; Fri, 27 Mar 2026 10:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44BC06B00A2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:43:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 182B4BE821
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:43:39 +0000 (UTC)
X-FDA: 84592111758.20.63D453B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55769C000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:43:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P37fgApj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774622616; a=rsa-sha256;
	cv=pass;
	b=Og9EOeTjQleFbvCgFpQF68Ws8LtUrEVBKCejE9uSh6MU2Z0wok6gF8EXpYO5eFkXvk9Z+a
	wNJgKRVxAJdvxuAYUto+DexPcDitGqDMiz2eI52uB2M7RBkM4oszxbDWgNuMTqDbnPL0g6
	O27LJVbfsnEJYHxiAlo4SDtOKrCm5Jc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774622616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
	b=4B+QEKiqvU3OCr6iHtdrZ01BMKQ6q8GXmHFqFlZXj5wGJvgyAulZqdGXLj+iZNbGU8tv4D
	Qt6N2xg2IXk9/Onf7i6qTBAEf32lqYDKUKIbaqgG4gt5wDidjQ0OGwqRqieoop4H4AKcDE
	OlB/qNltTH5Z6bgTmBYRM4ld4RJgW2Y=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P37fgApj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qk1/Mnazgh0q8PUwrIqpRtkrxHJihhpKvALoiqIcVBxxxDa7jXggzBQCvzQoMTTvOUHQFEPtBrAj02bwJe/fbRK0fnXJ/TvJcOMKGYMGbPAurIJRyfKYa04ghZTVFeBjyjbaObv5OBG3GW7VwrjYTZzcaTseY5d03x+lMBb8p23Hw3ntIKWtnxmMnwmCqpek0lJJfMUj/JjNXnVJCnGINeoKyg+DCxh0aDfmYVdptemLmOoM11FZZoH8cjI96w1pHbcymXcg6avcu08RC2e5xiXV5CvPXTQEWB+egPS1T1GX3f8NEy8SCQnf/IXRau0WwOJNyOSPdECGHKEHkhqQkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
 b=C0BUo9iBv+mEoT3K9wJPCH3m8o5hDm8g0RSSLOdaOd7XCmrUc9Fabp9ZJLBkhxd4rfNFwAvgSolWPyFX7dVPscTHtkXaLlgOL6FCYcPWgFg99wNvsQG2bGsHu+RHNlh7oc64nP1bAtN7/wVQculgiHtETI3t/hM53hyA6ZJrnlAJTOgpN1m862mb8l6w+cczBNQ8uxAE8jZjEuM14kDv9kLWbeNY+E0PLY28d/TXMxH0WtkR1P6qAhPpGo6caNesdzsFiHYq7BZ2SNg11/gyoRtDw+R4Gn8xC1k8dZbZXITGAWXZHQiQ1VabdcW1SJjkg8NaIEO8b0AIm1LByAS8oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1bfrcLEcxlj8jvoUAor+cDviw7fZYGTsQFkKuHtRrA=;
 b=P37fgApjbfGxWwGkJCDly65EfARyxMphHxdXI49I0knVJ2a5H4D1/VeYNV1y1CaMEafJ7kvvolvDVh6IUtP6pKAF1bHlsp4uEHFIp7jlhA7VuFRA2bA+hkEswkWdTnDT0nPN1jK5DC/tzFWTybjDjU9xH+JRiomVxCicP9PIt0HvNfOma2S+B/GA3zzpHPYG2TCYBy7gSXZpEW0yXRIhPgUYY6jWrNjZNOlI3WDCZH1g4WMDbG7V9Eyjm9zMTU8kChMsX/9EM5i7HRckXVbPpAKDiAXIQYEM41S7jk0u43qJL7gDZFHL/zIZCqBZRTZMenVYlqE8P/c8AA/oE6Xa+A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB999109.namprd12.prod.outlook.com (2603:10b6:806:4a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 14:43:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 14:43:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Fri, 27 Mar 2026 10:43:28 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5AA0D400-B4D1-4223-9A7F-41BFEA176F35@nvidia.com>
In-Reply-To: <f3602a65-69f1-4d80-82f9-c0c5b56afe00@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <f3602a65-69f1-4d80-82f9-c0c5b56afe00@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0350.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB999109:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d05382-098f-46a9-6615-08de8c0f37ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KUiPwxKJ9XK8u6RX4o7dH8qYORVCzH3EQSi48jvfsE6NtA3ksP0PC4JGTrXNcgRxSuERSIXf0K/WUU09EPp1Y5RrdRZkyncVrX/Df8amQopVKnGkfVEGg3MAg76jr2G/sk86Ve2uKQR2QVfMmpeOeDuCmQhvcykOpyUbFB8YAYle0I+yuN0dxQD+Xju2qYtAduziTFJrj7ejjrqFSXMUFEzobLIIPzsirPwtuaDCpjQsCf1G3GyH3F50sNP5yqfX3QNywX4PotGzk02hq0f3P793iv+0DnJ40aTVoxMbx9dA1vSbpBYIRXKqFEcjAnubzEbCgo2aOaMHvjT9IWZvBGKs0oFQJ2mF9uN4eMXkvc6M8fnM2e9mSEcCbKg1BMyP5ce3Lbn2FRAm9UDwI2ZsdPPqxmfik/Ol/mK+DO9R6RR2Qa2mDboTGZVIUomm/BB4/ikSpAEVVhxNj0Trzuy3VMsTt+DaVP+E9rqb5R6JK23TIjl8TCqS0An54fFtclQUNUcAlzWtKyZw0DrCzOna3b7fOWpW/BLNQhteyFizitEdJx+dNTZHJmYI2J4Mlu/pmzktpuY0ZyV79bLK9u/u3uTBpR8yBYmvM3TGjKsN2TD3NVbJ/AUWShrLcAbFDTsEcTk10RkFMmaxxBl/T/xPFPTYjjsM5Au9ZfmH1zbpXisHvNQo7yRdIoMxSynfXiokg4SrYCV5El+AwR0bbdom2WbFrNp1QR+2T7dgNAyBSZ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dbauky83FRQj2eqhvu3aRsrOUlGCP95pFfxbRZx7sRFmesDXOy4fy9xk+Owe?=
 =?us-ascii?Q?V+6lrz8y2ie++o064NdoToo/FNhPu+ftqTO5D0xjL4+mlrLS00s/+K3YFx65?=
 =?us-ascii?Q?vg54movRvdNDGrfIZl4I4p4AkCPKwKEe8xnAV9MDb+aPdLXfgl+hiNtiriji?=
 =?us-ascii?Q?twprn/wy4aw9CLGLN3tL7Mlpaff9GWmj6GCy6svbEmprT+yCcBoNsQZso1cJ?=
 =?us-ascii?Q?QX9ulNGxebWrIdNCp0Sd7JRIJ5rOTAh61huDDcheu/Ji4JGj7lkHkaUyVfPx?=
 =?us-ascii?Q?lC4p99BLr5LBMmu80Nhdvny14gjPAwlU4ow7vss7tdqwUdVVay3fmPFKhTdK?=
 =?us-ascii?Q?kp6jba/x9BQ8dK/61kOfsGTZQ3JB7mcl+VVCCe777FhEI4i693ZNHO0LrflH?=
 =?us-ascii?Q?MyrPeh9Qednks4jJ1r5Av+5pHRaN32860FIJrOBKD0LFf8IY9HAdRXstNhPr?=
 =?us-ascii?Q?s8H/Zr4UoNysL+fPEsIcdtX0EoCvc7Yj58s7JXtpZ2U2DU512DeVJBxN/v11?=
 =?us-ascii?Q?fyjDgKbnY2N0M0kyJRTje8y90N80CkfzgPtO3+OLnBWBDaFvkD3io3ZakVwv?=
 =?us-ascii?Q?679Qu3UDOqdOsrf9w6+2Z5EBi7sLC6fowm0QkFUvKZQEEzYVrgVl27gahMzf?=
 =?us-ascii?Q?QNMfQUt2ce8uePGelYkE5U+WnRfu6/8zH9CYopB+LSsGI/AHv2H26SVaB8rB?=
 =?us-ascii?Q?xrPSpiDEwUcRdHfVuEjQ+NqCW46+i8hU4WFlDi47jyQf+pw0/xoNU5Y8O/TN?=
 =?us-ascii?Q?MGC7HLH6nBDn4x7vV+MtD+4BdKanoyt1oedfiy+GntA/771o6o+Ql2uprikl?=
 =?us-ascii?Q?pATPThUln0Hlk1ykpaJfmiz8YI49RmZ0F/9B3Hx+egRaIEnPE+Bl69EOtCS/?=
 =?us-ascii?Q?oxO1s6pBiMKd8J/a2/XQR5JcWoah9+7rkiOTb6MVbwuDUq9094EmyQtjRRkj?=
 =?us-ascii?Q?+FpOIn8b8l7DlHyNzRr6toCpY6zEH/bIYSWRrFItZSKhcCNHtRQMms44+Bnh?=
 =?us-ascii?Q?TSMIVUFL6AN/PfgcyhjG19BWO6GUSs+ElFqsb94X6BUwaOEIWUE9oV1x8hR7?=
 =?us-ascii?Q?GNE6w8ez/xlifIoUwyLUO8Zv68c1T7Zx/Kzx26bnFu7Nz8rDfxFtwlJIVMkf?=
 =?us-ascii?Q?MO2lDx0OQYDE5mAiSWKakgsg1BY01jibk/QwMGKxIRhUIlSIUhWO6t65knfC?=
 =?us-ascii?Q?L2VMDCygdGZjRFdtwmB3xV5WrRG29zLeBqgmWTtHUDF7iBG6U+AUq1oVAgAX?=
 =?us-ascii?Q?USn8y6kcM+5R/5CmneSy1uZLQZ6wNyBWd4U8xDWHVY7IFYZFqyMd4IW2u34C?=
 =?us-ascii?Q?lkAITAR3nlz0RraCd6fuo6INQNkZ/vhgZhp7ksINb3PqhNYyycLVOo3hnRpO?=
 =?us-ascii?Q?v4RMe24QyzyFKCoW+A9fXwfe7Y7QpdPMMp+Zc5/9BgAZnXDDQ7Yeh4XUf+XD?=
 =?us-ascii?Q?1EpoBzhOEviZFT7UJB77i4n4Aa6uxRmE4m39L7JBZYXwOu7Uzap4tSFiDFwo?=
 =?us-ascii?Q?8joHEaRwraElRHY/qDggf0oGFGHh1dUGwrr8X9aUoUQ3qrltN9PHdzRWgHCd?=
 =?us-ascii?Q?3ei6FodXU8OF+/jImqUnJmNokjo3ydSbBtLU7zR2leYqAT5rdGqCvEyadIwf?=
 =?us-ascii?Q?qfr1YgoAd4JgpgagEjuUvwYZurYh70e1K0iTN0m5gX451zK87v4qF931g3ci?=
 =?us-ascii?Q?DOkvtJ2WJE2qEdGm+82lBnbb46LkhS0TPUE6rOtbjsqHcpUcCeLOhPNPRdHG?=
 =?us-ascii?Q?0dP5d8fBUA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d05382-098f-46a9-6615-08de8c0f37ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 14:43:32.1286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtmJnp/TaSb1guCAA51jQ+b7KiRpyudtiM0g70P9RpMB3eBv2GI2PwkRxOm1XFo5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999109
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55769C000F
X-Stat-Signature: 94c6m68t757gu5ssd4pkekrkyidcz9ka
X-HE-Tag: 1774622616-242523
X-HE-Meta: U2FsdGVkX19lxwYCx0HHKHEnGHu3rLbtODX0o3aIRMXjvSsjxTxMCQlVcw1H3rq71p8WBf6K8maoHveVKxZCpm2dBupJ6Eteo9y+Vbor6he5j0iBRu5v5H7dbXkG2mGx+N1856gyF5WFOBW35ThkSN/kQdC8vLmoSncd6oHBKAJkkxnHx2OrpTBUPFwqde7p8WtlhWruYl1RyTTclHMIpY5LZr7SeJhxzSaBCaO+HoC6xbV4pQ25oeQkaIMSpKqfrW5ZG7RzV5FM24vGbcLg0O/gDHTURcS2+Swj8EiYpP05WwoebrrqiNCZPlDBzVBkWSbcliXZq8I3L/+Ikfr47QYttEq4MMBE6J/zL3CyZjxf9sB1UkzqhPuNlDGwNZGu8ULwhd0dZF2BJnusA+N7mCok/sfPr1opb2VCEFz0usroZRP4SBm8FVA+0C2YbMqgayPpiQa1o3m6Fsqc+f11HiBzp311mD73KygHAscgzs6Z2LwVytyMjaIzvJC5B9syoSa9B5B2eEzplhefZrEhXUemBeWyO3Ilt+fSZKQx6JFNe2J+ANSr/GJ4C8QsjHcl29ZPIPVAdamV2hlri6j0gh0qEvsMVUS43BalurGiattamfSRY86bC0aIhw0T/GLbRlHkzWG2qUAvUAJv9h6i/HDyQuHNqsF8mwTc77CaYvyWBaTfGGIQPMqDIceFD/PtuIObyj0v3Lol65U4oJoOQUj7iLfmwLtrAanuvSjHTEi3tUpPQjDS+ccUjwx1GXiZZh9YLCei/vFbI43e3aiYZJxcygNp+P283bOxFBFgZr1LhtvRs65XZDwYUv4Fr4vy+cO5TDgMqX3N/WfbWUeWREhXU+qrjhe44Gt87QUPqHIE2sGUPBSbgRVJXpDOJyA677RMqn15siM3KXEy8YpkgSNFAIbqxjBYwuNHRKU8RqwYlPSSv9fLG1Ct/Fh+1pFS5srBw5aeMECVmrXKb9f
 LxUazr5e
 +hTd1hyNxoNYsyuIAb/E/Qcy4sVYCs3ekwY1o4sje/VHkaEPvWkzp3XaaXjmxHB+GejQSynB9CC7vKuePMyS2Q+t2hxgfJTxQTXxc3fJZUqgWKod+YAtSMOGYiQXfnXGIe0auRu1kh6N91qiNp0JHpkXGlSwocqn1Ko59sinOFcQofWMejZmIl5M5v5UmadPvFuWmDhJqsSpMtQUMNinOverNrJZDUOiNTecc7LagTMnPh+ddYDkB0auhqLGnjmumJ7sEVClh0AU3eQoWXqEgfRAgWQNcXGT3SmXRARixgahaFumLl2iBMTyO4+5DVSBFm6HxbakuoRpzU9+sNr0alKtQUKSQpcA3v+nRDlkWA+kNmLJIASPuwJihog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 9:37, David Hildenbrand (Arm) wrote:

> On 3/27/26 02:42, Zi Yan wrote:
>> collapse_file() requires FSes supporting large folio with at least
>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>> huge option turned on also sets large folio order on mapping, so the check
>> also applies to shmem.
>>
>> While at it, replace VM_BUG_ON with returning failure values.
>
> Why not VM_WARN_ON_ONCE() ?
>
> These are conditions that must be checked earlier, no?

start & (HPAGE_PMD_NR - 1) yes. I can convert it to VM_WARN_ON_ONCE().

For mapping_max_folio_order(mapping) < PMD_ORDER, I probably should
move it to collapse_scan_file() to prevent wasting scanning time
if the file does not support large folio. Then, I can turn it
into a VM_WARN_ON_ONCE().

Best Regards,
Yan, Zi

