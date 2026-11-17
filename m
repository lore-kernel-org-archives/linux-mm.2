Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F32ED606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=WFaR7AfV
Received: by kanga.kvack.org (Postfix)
	id 1C07E6B05B0; Tue, 17 Nov 2026 13:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 171296B05B3; Tue, 17 Nov 2026 13:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 061146B05B4; Tue, 17 Nov 2026 13:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D70DA6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:18:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A8C2A0563
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:18:36 +0000 (UTC)
X-FDA: 85445421432.09.EC8730D
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010009.outbound.protection.outlook.com [52.101.46.9])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7EB3F2000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:18:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WFaR7AfV;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794939513;
	b=ioQq73nczGGGK8MlM9eEHkE7iYtz6VT3imSam3lMGMvMQmQcDYlDsXtVQN6kxKBCWrNrkq
	wMGRfdZ78jC2lvNMiRZnyya3W3yyecX7EOp/VJB26wZ/GnGz/h+QRqc2DpN0c+hnTMFdEh
	TTtUt6MRpvzN6PXp2Z8ltcrynRzPvis=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WFaR7AfV;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794939513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxYddlKLlR7hNTa0YjcjpFyJFrmv2MGCYT9ssW5owmg=;
	b=WNwkns9FvWg/FyA65pplR0YOmk4tqVIi6T2fIR3saHHEylNmub9Y4THi5ZBsRUh1XsHkhX
	sbqDruZBhagY3y2/WsNoXwbYIZ2a9oS8hkToAbS0qO/XTMalHiitHXZtzlwgjqRsTzW9pJ
	4zDj3E7eebgnDCO3R6EOoiPrpFKfzuk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R31tpIWy4woDT9Si6HRT61pEj2AQDVqOK+W8M0Wo2xPAHAeV36id7TI0RoNk1lh9xiyhOq/pbdlgjmnf3EuRXjv5Utfbi3pVnJguC44zfv74DPaVQUM9C0E7gmsN8a9v5TAHOsrPck6Ud97UnR5gGNdFZ+JbUn3kvVjkYtkNPqKX0qmMmVozSE5laYHm5Uife19P1rMM5CldcQVsPwBpcmD0F+q9HpGLJu5dS+LBEZ0iiw/a4XLSrmk+ZYKLZbAdPue0zMr3aPwn0TyvJNzfDJ8U892VVN9k0UrpCP+S6LKEjFYQoMkjEXqr+aDJk2AVkLWayyI3sX2SNzdV69s6dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxYddlKLlR7hNTa0YjcjpFyJFrmv2MGCYT9ssW5owmg=;
 b=Kg0XJu5yuGJRowKPNqJ/usK4cAH+tETzK2dQcNojospGU0zRRpRzy9AJOGnZWw1WkPELZGtWkI6mk/GdQH1TjoIBJhUZL4hxneVOlxb7hvjOqUaq2lx4cECBYjo1ufPRp1+pl62S3WL1wcMGhKxgccw7OqHpXwWPS4R4rDpYbddpzkpVeECQy38zVSLhsMV0fMTC5aBkK05RzcL6NWys0a/bRYpWQlDRec36qzFBgNjQPuBGuVWD6Zi68pzae9vMIz5okuO+wleeo7xNC0+3lKDuZhZvOj/tVnWAdiaBMwPdQpT6LCQc2qBVs8KuBVMmzvRxo1XFEVVoW2VzRVVMBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxYddlKLlR7hNTa0YjcjpFyJFrmv2MGCYT9ssW5owmg=;
 b=WFaR7AfVoX5WWYfezXIEWGx8P6rTwLnqng9+7ijkfbg0pS+03zyjlGhHWTbhqwvt026CrmAUUp//o3LZz0YzbRNYFu/6sOyiQ8fMaOJO4UNMV/F4yScJeyml/iBrRJUMVev9RaYOZ0srEfZWuP1g7e+q4hP/+Oo6I83j+jFc5XUJTO0/Sp/sU+DZtSv/Wg1+kqNXJ3SldnvJ9kzjlrTfC6MrUQ0cvXMB06r12JOLQUedEdf9FaVG7J+0dXiEOKvcOcdOhb611TQgaLtffJk3dW8pEFexNLOhWNt+SAR3hfq8ynzrdN12VFhwLw+GWO1KOkNUJHOHe3wF/iFJbGw9Kw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYYPR12MB8869.namprd12.prod.outlook.com (2603:10b6:930:bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 18:18:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 18:18:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
Date: Tue, 17 Nov 2026 13:18:23 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <69AC0B53-F34B-4FE7-99CF-6AA36A689116@nvidia.com>
In-Reply-To: <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN0PR04CA0150.namprd04.prod.outlook.com
 (2603:10b6:408:ed::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYYPR12MB8869:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ac32bf-876a-4672-1f8b-08df44d72ba4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|11063799006|56012099006|5023799004|4143699003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261022075727099003|261026121527099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	HEUdeI3SSYgSdVFOxPWOHcpDaUiuJm3AXNYnrkdjg1p5yCEFHi0JIkdJj6hr+W+h7GDqvN/IfN9XRGydde3hCOLV6cmVDlgbEIm8ylu3qNMc2Av0YqZGBW/TpMUvy9HFkp9Jee04hWQebuack3lLtTdcFmMbihQTkex/O/BR+VUBzOxA3Vcw7qfGIml247Meu96+cVHexzZ4rF56ycwrCuUW5TV6DAg124OC+YXeQJFdbxKlGMbeuMEXtKCT+IzZ4sza8sTNfo0+9j6Mgb4hCDrwk8QspYlEUbAwAQAnE1MKv2ofet9IHdUffUO+Z248KPkiWtn3WgCGNA9jmaNfmYNhqyvmcyv1bKWz2f8SXvEiD7TLvdaR+7qeUQvXcywbaqoY5Nb46b38cy6WAZeTNVYs8vER+lH9spdfM6OGjbH8d31c4CMf4pr7aiOlJCfMj9vkX4u7l6X31GpAUl71AYXrgqMTtQsmIUrUss0tmg6pgYvMFHyILoDKqcFWbqf0lNFHQk+pJ2MrZj9lFVZiqlOZTlD64SXDYlsMyEYZdxco8YNjmzEOHcChD9LPfKHUA5PdgY7UoOO0NFQYv0zwqY0ROaEYMNBIq5ltuEOWdAH0mAedqDOagJRjnCoVcP1JdaaHfB9Vd+DjLQPB3jiXPS31nJn2b1pCq/5y5NX4bBo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(11063799006)(56012099006)(5023799004)(4143699003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261022075727099003)(261026121527099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L7BIS3Xq9vpKNoM2j8fuoj2y5PAAK0gTfT/dkSVqDNLGbL/OXy3UDOjs+Vr4?=
 =?us-ascii?Q?xO3+vd6SKf8MJxTdQor13Ye0hiJcNNsSiYKIDg3A+u01pmz7oSMS92dZCwI+?=
 =?us-ascii?Q?JtQLTq3qWWyzzpuIN27o21uJY8pm5yjInPx+yMzhTnXnxNyiGbwt0P35MwTn?=
 =?us-ascii?Q?GVWKZPfcGP97xXcDx7BTRLky7sz1D5irtC8VFPQC3EEBZlgWKe4EnokRipGm?=
 =?us-ascii?Q?ZEoHaaYG+C4DD/rWHvd9QHbu+aEYkdmgSCZGWemYF59axROuBAYH8DBjbrkU?=
 =?us-ascii?Q?fGd6rfVSioWZZRwycNIOS04PcTote9xBA/OIXIEX0Kt6OaeuR/tdj6weHr2j?=
 =?us-ascii?Q?yweAzD68XxOUJnALf0DgGlnvKWuJjVGjMSbYnwB2meOFpetNjJWO/rqTTaD+?=
 =?us-ascii?Q?sWFc6U0+ijbCtqNDCz7sApjQJ5Oe+Mb8o3mDo1UZUU31WhoXgpYsLEh+70g4?=
 =?us-ascii?Q?O6NhtSor2o36ZyX3EVnPI3+LtiIS5LlpNDAlvfdnfMSvl7T8jdozQ1njrDSQ?=
 =?us-ascii?Q?gFeNqq+fW6j69P/WTFmmbl4x1B8dy7JyxH33DUfBjcrpIU3mP950Ns+Bet8k?=
 =?us-ascii?Q?4Mr/EpUjdsFmla9oFF/cWw6Qvg6U6mS3dQBTJKcf0q2J4HMCoY/SvYqKDt7w?=
 =?us-ascii?Q?sjHQ9T/64kf/U6u6I/HyypwT4oG6yNGAiWEm+/F5OZxfcpsY8MgZDhSYCitz?=
 =?us-ascii?Q?N29vPjGR28hrLqVFzt5GPdyIqPpCV145JVEwAFx8gxZMU29uODhMvILpUkN4?=
 =?us-ascii?Q?utQ+DDp/w1mYoGjNS3vtXs172Ny/I4fR2fJQxZxLM3hhzLf5YfyH1XxZOB97?=
 =?us-ascii?Q?lZwlubvpIBEDmGJvqqCv9CBDOp0oj+raYIs7KMdnU7cMKMCh189NMj5kqixq?=
 =?us-ascii?Q?ffcCBhbXEihYf/gOzczstcJ/FjBrgTKOdXiBKVzc0+7xUcycsiaHc7nqgdZc?=
 =?us-ascii?Q?e1xwjbg2IMwreqWnwtx/xkbjIe80X4+RSeHNjNCw1DHWxRiEoKg5u0hyZopE?=
 =?us-ascii?Q?aMZwI8l6X2U0+0nssMKXn4+EGuSMPJx4+5DptjR2rAT90xjlXQn4jl5DG6p0?=
 =?us-ascii?Q?OJGYq5VFAPW55xqjJ+0A770ovV6V1/E05z7+F2w3uIpO/YAPt1g8LKNk9WaA?=
 =?us-ascii?Q?s2FHdoufo7LKhSAM1dBOclcFlQ9lrBc7G3Ogb/dqowZekhZENKvZbsJGvAmQ?=
 =?us-ascii?Q?gPN/bo0dIVfKKGEAfFX+lbQU/4fvertw7pZO4N5Pg/1GUnEEpWaXvdBXcN15?=
 =?us-ascii?Q?ckIPCWDRImO7W4Xi1iLcjQlFW2Eyh3qQO2vVAZYMHjUHkHrkLNgf0G2aKi1R?=
 =?us-ascii?Q?If84wsxr1UnHnTVgHgAut4EqWjTL9+p0AgfYI/U+oS2CibEt6qbc1StpBU0f?=
 =?us-ascii?Q?QSC6nhoOPVVWWJlA4f6W0qxQwkfXNR2VQXMOGLABlRvVXWGTCkb5fOtUarJa?=
 =?us-ascii?Q?lQwck+cVq4Uniyky3+7qIOfB9vBFdKVf6qXbraxMkWst2e8O1qPw28KFAhEE?=
 =?us-ascii?Q?NR7iaiuYGPkkU21193EQyByFaSzu3iZgnoQC2/CLHf2k7SyaR0IHCUyIlYHZ?=
 =?us-ascii?Q?w8Qb3eBeCHrn8jIwvThl4jDQAoy6qTVi+V4W0yLF63Z3qClkkCzloY3ipDQM?=
 =?us-ascii?Q?WlHHMKv2B2IF1ZxxeWcNMOGMDmJD+zHWW9O5OZUscKLfHnQrvot1PP2B7Vwc?=
 =?us-ascii?Q?lKdgF6IlelWcItkZmRVeEaGmntTDCCl9Uz/yo9eoxUw71lRi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ac32bf-876a-4672-1f8b-08df44d72ba4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 18:18:25.1686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XXnhqeYRraGOzfjDa7m6rXYMjuxydMtJ0xUn4EETWKM/iU4fOfwQt86AvlLO/JZg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8869
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EB3F2000F
X-Stat-Signature: un8ajxymenei8qo7m9536789aqupwxuw
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794939513-633721
X-HE-Meta: U2FsdGVkX1+8dcPY+GQ00UH85zI968ba3Kxhfr5F8Biz5+1O7+Knqvr2kbyWZJHcAvr51RvL8OcgGzu7ltHI5PbOag8V5U41GANombJtuXjppFHTzcbZbCwA77VgTBwHRTIHTwmZyf9GakWgHeeXm5eyZndroQEoTZgj75nnZGM06nYCS0SRMaQN4ecNh5LWoTB9U9JGE8rwt9Uhl+PdP4R9NseWSp7bTWBeQuVSMSIvrCFtlxZ2KLktfUN/SqKjEijUx7PPSskhSAYsoTgxPFg8mfP9jdlc/D0YZRs8NVgeuymRDH8u8OHLYHFRczpM2sASgFSR1ZIzc+e7ZMHTZwbzYzvFZdYOKlOEqAlQ3UEUC/DLRzUOddNk9RXuZqKtH++wyrwcehnARqq6QC9XAH8q4X7tmqdzKXkevFwm6KigNKemN2ohuplyGTLqsyozzyHvUl0xOAzInZkRiidGuLDqJ0wxYoEMJ07Bl1O5cgB/4F8jDgtV6fJAffRKPC2CHvXCu0/nVqxKLazXMYMM6Cc6XEih3FamjAHYDQBE3YNLATCNwgUe7CVdqjyxi2ZWYZ1H4KBslpmm3bBFq7TD2Uzyrk7S7iVjG+l6+Cp5YoKJuR2VECjy/zMNW7PvONiTpqJF9q/C08ihoyob0FdR3tRUCEjetz168QGSYepoUmVCurxUCknbkODJbWJ3jmzN5ADoZu2y56tEU9l4+y6zXsxTRNNCR7OHMn2xTZDWVp6l2H7gewlDp1W8dvwouAnWLFS6zxdeJlBUJSwBo6gp8YQHaQsN5CeN4mmbs6WFgNX5SMkSCG+jCuZqfkKv0mRxw2U3gD664Q5z6D9GAJKJGrReu3UAyUyZz2eMHWc9Dnvvq/GUcCCzksI9T/sQ2kjclEBDWRpJBZkTNJ4WhC/iDFEN2jX/3zlocDLA4/KarkuCjmaBGqmbHKCoqZaQDiFD6TiN2BJLORwPHvtqabU
 EPOS/JSx
 Uz0xr/VvL3tBOl9B3HmG+MVc0U80TYoFvlUEMivK77ktTcKgIPCx2K53BDdKpo2sJaTSXvJ8gi0cZ0kixa/GpXw7TpcOOB2rWoowSpQpiqCBShGRuCVh4E7/1siuV0CPxQZy0Ddz/InJwM5jswe4sL9204KmxsC2KQq4hdjtBFvQBqnGPj/RKx8HURAtz5BKqBIkwHHY4i3qPw2LksnOa1f7vO/9iOb33n8BOYmvU8Ao1eDBl+8ViOBh1g3sy+3A7zQ6dokqzk5XMfO6bXfHDMwHg0SqaoB8cwtNsasxtJNiBVCIUG4FlXnJiVUuvfEA1u1fUM3XmOP1KlLJpD+F/zA3HrlXeZxRd3qh/YZLYj1gkiBMRJUZpCRUmFLU1rrRnoBqqD6TQkayxBGsVjXT7xjsxPf91BOO9rGha+g4yA2BPNWULoFzygl6/ieGWc021ASrWyhzaoZf2yGFuEcUXaL21P5fUCbWWkOx1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 15 Nov 2026, at 15:58, Lorenzo Stoakes (ARM) wrote:

> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.

It is always a race.

>
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
>
> insert_pmd() and insert_pud() have issues with this as they both assume
> that, if the page table entry being populated is not empty, it must a
> present huge entry.
>
> This is problematic as if it is a write fault, it compares its PFN against
> the one being inserted, warning if they differ, on the assumption that the
> entry is a huge leaf.
>
> Since the entry may be a page table, this is invalid and can result in
> spurious warnings.
>
> Equally, the entry might be non-present. Nothing can install such an entry
> in the VMAs that reach this code today, but there is no reason to rely upon
> that.
>
> Therefore only examine the PFN if the entry is both present and huge, and
> otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> at the appropriate level.
>
> This is what already happens for a read fault, for which the existing entry
> is not examined at all.
>
> Target the commit which introduced the first driver which both mixes fault
> orders and passes the write flag for the fix (since this commit, both
> drm_gem_shmem and panthor are prey to this issue).
>
> Reported-by: Eliav Farber <farbere@amazon.com>
> Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

