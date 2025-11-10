Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CC3CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 21:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EBC8E0009; Mon, 10 Nov 2025 16:56:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D263C8E0002; Mon, 10 Nov 2025 16:56:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15098E0009; Mon, 10 Nov 2025 16:56:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA7F68E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:56:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD18A861CB
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:56:47 +0000 (UTC)
X-FDA: 84096057654.05.97DDD5B
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 257361C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:56:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jrL6PgTo;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762811805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v80b8ph0jcxmlBnv/hfCssKKCOPyMqRiQE3BP56lrjI=;
	b=5xIPUd5rpBlwA5hs4v7JdLdAf/NvwIS/I3nzsu0cMHJ/ckNVZGdREmfJvzSXQVYmOg/qmd
	nOsTewoTzvmG/RMKu9zXlzMNFCv3VPLgHOIVkgtC5wpNtdUdsVPEXokQsR/AdI3zxSXERG
	X5zOImRZM9/FCDnj/9pkDtI5jcT+ur0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jrL6PgTo;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762811805; a=rsa-sha256;
	cv=pass;
	b=BfdgXfhxy63eeBxttJcljjSpe0qXlGlha5lozd+6jz/uRnfxkp7K2Xb8iFY7O4TdBnjl35
	pKFe5Sll0MxhhCg19nRGX8ITaOXGA1rIZF4xv7n57XNnzwO7Whu3P9mu61sg6LCNDdFeuE
	I6EmTlOKg3N1WlzlzFd0v4cx8SBc1Ec=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seqhDvcVPzFos/u58hJ3yiCCrgtu7Ppy5bHU8mQRMcFfwjWfiruHpXXUQohUuTKiyiWhqO4Z/eT2bBBDGRBqieqqn/5tfpB5QrcxjtI8QzaM8Lh6ItM3Unn8gNOFzy8qqr5FbU71WvbNLnBj4WN5pUT+00yWAM1NkJHG5jkeDJcIunrUVRlJ9EFoFfmNDO53oam857WvxsA4++QYd+RUIA0qNU+LcU71Keo9om+pCitHvmrxfG/DDtIzDb2Kyc403Tqt19wpVXusfx2IelIXeefv1FHjcxAtFjRggNFQ2rWB0QHXFDY0cc7ixkvySTwtOXQj90MNlyIeTubf8BVnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v80b8ph0jcxmlBnv/hfCssKKCOPyMqRiQE3BP56lrjI=;
 b=KpnvN3r/PGuTqD5c1XiRCvzcTxwBVLxR3FoSLH6CsDd0yPu5ACrnJXuV55QRmjVkQYkdL133aMRdO3iYgJoMxbuo52E24lqW9IRhRMxx3TzppL9x1ZjyT5yWdRADJDXvuZt/F/DATYcEfrO2wsu6YWeEYru/EniYWzn45mQ4EB+zLEXEqvu4LDbEEdFF9zXXzj4tU604FlREWl0y1vh/4uYZQhBcOdpFcI8fxn69dnON5p37McwYcVwPaiZaNyoNKsd96jZO74uqUttZLabgmtWdQaSzVkgVvwcIOmeUf4IxWoMZi/JXbPd98jN9E1vbvSqi0xMedqHnELm8bUHfuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v80b8ph0jcxmlBnv/hfCssKKCOPyMqRiQE3BP56lrjI=;
 b=jrL6PgToqYeSrEYeutqrwe47zBnLJRjGubytj7wBelwCRg6NIOXw4zX+IcJB9Anlp5vFJqzIuV6Lt1fDjpnWQJcUJjRvYOGRyxGeaJazVp7lTm2Z+DfcxcEXv0Kp88+SCK+SmxLtD99wdIIpHXP08jVkFcqh1QW5Dv5d0qIEzTxkPOAk30GbJpxHVOLIiLGikgvdtJrwH4Kc4/5lxZBIXDcpWN1rsJTocW04vjXxBl85rMvhko2VzWLukwYpBlpVzgtnexeamA7+P+wMYm1QiWd4/n4zElOXxrVlIVK4k4bOb3cSl0rxu2yYJGeRUPryKOWXVIyYLo2hkQqqWE1Vvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8986.namprd12.prod.outlook.com (2603:10b6:806:375::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Mon, 10 Nov 2025 21:56:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 21:56:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Zach O'Keefe" <zokeefe@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Date: Mon, 10 Nov 2025 16:56:37 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <05CAD17E-CF58-4825-A36C-EE428390AD23@nvidia.com>
In-Reply-To: <b12340fa-358a-4799-a040-636994beef36@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
 <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
 <69FF5A7F-1414-4DE5-8A2D-09ECE240711C@nvidia.com>
 <77925a0b-fa06-4200-a967-a66bd93201db@amd.com>
 <27920b64-240d-40f6-a02a-0a8c433ca9e1@lucifer.local>
 <ec53bd13-42ce-46d5-a1b8-c4157663b60d@lucifer.local>
 <b12340fa-358a-4799-a040-636994beef36@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:c0::49) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8986:EE_
X-MS-Office365-Filtering-Correlation-Id: 128bb7ad-0580-480c-8b3f-08de20a40759
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mdpLr3TqNEOHxMV/ZCUdiHdAtS2/wqtRKMrCGvKusIRDdpwcVc55fG8i0TeL?=
 =?us-ascii?Q?caGtXaSSF2IPfXDh7ozAHaKcNX26cw2nxiqBGdFLqGL9FQPRs/dEGWbbxVmu?=
 =?us-ascii?Q?UxmsNBak24ovnYk0UqjoukI/Y2jvvCEDuNCRfgOL/rkKojJpwPwgeEZJMRBQ?=
 =?us-ascii?Q?qDsdFUjQ/KO6Hl01rVoWfiUjxZoHHlMZaQWLS1Kb99O3RlmIR+AknyqL3cS4?=
 =?us-ascii?Q?lHNvV5vT+c/grKqPgRU3wvF39dMc9Yn6dsi32jBgAWiRInEara9OseaMeLU8?=
 =?us-ascii?Q?PDR3LIo4x8HP3QYqnNGn000i+niUjTFPEjHkdxUrbfijtYBhmgi/0vY985jM?=
 =?us-ascii?Q?7VCrTBmrEgx+EvAF1GbmrIZJrxOf7yLjGKDSr+eFBrdaLEoZWKax3dn/yAsM?=
 =?us-ascii?Q?LOZ6DtHt2WZPPhfnaAEsEinsi1aHlg8itPXul1bRymJAVn2W7CcqoQIzvked?=
 =?us-ascii?Q?tMXFB2VTZeu0U3vUZNhRgdImA7QrIWglIMDt1TccArg8PArWCIxrn6c3mF2e?=
 =?us-ascii?Q?HS8gjikf/sMoPGN7urLtahMbiMWNeR7PVoOMsF8nr6y9H1qwMt3qVCsGLw5c?=
 =?us-ascii?Q?QfYep80daiZjcBv+F7qBgYXS6lhcYbl1nRaP56SaqvRFL6J+RDqhd3DIAr3U?=
 =?us-ascii?Q?zikwUAeEOO5X2C8o+lNeJs9Mhu0y07cZm+fRYPuylnAQjMD7LuHsfvF+/BZ5?=
 =?us-ascii?Q?H2SleEuVk4kOKjskpE3JgBxX89GDIeWfHs4xTKgVNQ1++D/GuzIJuzVntPlp?=
 =?us-ascii?Q?fvhXgDX0cIKV2a3FgG32b65WA2DzTWsPdPQLIAEmJwoclgzgAMVgsn8sr2gk?=
 =?us-ascii?Q?QJjtJs302ABg8kEOJTkiPlz4VsI1toewoJb2+bOcHkXLmny+6Bbk7oK1enxt?=
 =?us-ascii?Q?ismIh143g9VUzHRMkS/Z1MZQaBUmfE9Ush9/Vux/bDrU9v4+TPLSr6geRD6S?=
 =?us-ascii?Q?QoZmHQhn6wuSvS2o1rz7B+g8ye7YeJwNPpYTPHUYKFBHpMz7GNXgcHH0Pl/i?=
 =?us-ascii?Q?nzb2nSc2wTwK5HhLYeLN8QZ2gSVuHRdjZfmLTwO9eDX9kmIqXRKMmvlA4UJn?=
 =?us-ascii?Q?Cwno38f8C9kzZYNjmW4Ls76CmjArD2z9eg1a1Ng48dzvswoFDQCPzmijZQQb?=
 =?us-ascii?Q?/S+2EK/xJCMcMeC/3gHH6+xWhQygjVAHRDanf60LpTTi2Pse7/VFQwGCWd2/?=
 =?us-ascii?Q?EIu3SIkHgnUOlLl7aOaWyAwr83znqCx+kc+JR2K7jNMDHhvgTWw//rHgWoiX?=
 =?us-ascii?Q?UlkvEFH5aLHeOOX/1lnfJpGb2Hv7x3IJ2ZkqYarTzbZPwXlfgnOOT2aOycNE?=
 =?us-ascii?Q?DJfpEbTCnmrz/+LhXdnXXMRXkj43QyLj9JRmdQzA3jk9JktT+xpA8nj8KYNM?=
 =?us-ascii?Q?McBDhOWfdFmgZ+4UF1ke/FAfDkVHpBWj5wz/Fe8FIU/6fJRJ27U+TdXCNS0l?=
 =?us-ascii?Q?kvmQALidPEeVlIa5FQoLaftJATSwUfxE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5JIJ+jT34mfhWZFpLCDjlh11IH21Q2k7oYCjYKMKL/WLCMmc7q2ntaE+dJE/?=
 =?us-ascii?Q?knN8kGPDZgvO9JwLXiwrdCKurU6eNNCWl1G50UTexjxJX6C6U3vtHBoqnX1W?=
 =?us-ascii?Q?88ip6oPcNAKK/dwOXEH1pY+JtWFi66KyuGTaoNjqAQlu2PgvexUr7atMlpZ9?=
 =?us-ascii?Q?/xkv72fOZdPgmvPrHhSFfaIWClJVIlX1FEkvc/1a+Ngn3MTL/PC/s/bcGHf6?=
 =?us-ascii?Q?4r9oytidMZriSaDVbF8Szhlh2Hsp6+pa2Svlnn+mOJN/9iek++9dszOYOr8L?=
 =?us-ascii?Q?P24+USQ4m46wrANUxhvRB3SNuv/QK/lomkbmQz+7wjrzI6421f30LAq2f5T8?=
 =?us-ascii?Q?2c9QiN5rYe2rj6A5Q7Qpz39y/ZWjuFHS2BnMpzkB+clYy8apConghhWkfEvp?=
 =?us-ascii?Q?qQfG3+hzf9HDEQ+DbbhE4x9PyB3ZmU9yQiQIS9/olgmmyizCtj2MUy2w4SOp?=
 =?us-ascii?Q?YnpIvd8tO8j2QAL2OLeUjTIyVjCWnP0i8cf5SnDOlELpuNZaboKNjfo4N/gC?=
 =?us-ascii?Q?RXTq1NdRxxXnPXQ/Zrr+vnlSMdikl8kOsmuFXhhsvkPYL47cyquW0MSM6DwC?=
 =?us-ascii?Q?ZVtognBM50jF1Hp+aeAY6gclrqQisW0PlpAlURaBhhpv7DTBQJo4E5NSqfLW?=
 =?us-ascii?Q?eALmVPvkMM+dGIaD0zX8y7UHMFzG+LQka0LGbZul7Z0f9fJF1okId+B/lGSH?=
 =?us-ascii?Q?/QxUp+aA0fJrtyae20KrJ9w9eCSRPGLghToFhIuFi1rsfJNjA3dP17ZJSmeC?=
 =?us-ascii?Q?l/IKJz3iUYDdRFUgR6hBETfuol+CbeHonlQYl2TQADgKFGUJylF2jkDptLSS?=
 =?us-ascii?Q?1TH9xASHeHWKI6Ghu6rsu2sHHZVqg65kSU7EV+u/vKGEhtQbplXVu9h9bAbW?=
 =?us-ascii?Q?lF8KtcxrrOa9xo6QU5Q1HepD+GMPzJj0kpkLiuvIcOA94r7+xtlDYKh566Qd?=
 =?us-ascii?Q?dsXelszYRGTISWRLwx/RaSjGmCeUAGWJy5luHzmlahJkS5zZPaXbi/AgAtba?=
 =?us-ascii?Q?xdnqlXMgNcEtbnQm6PvAFP2LXfHZEHtdbKcAofghQ8dNwE9uqPWYD64eB6UW?=
 =?us-ascii?Q?id85uT4k6F4iUtKOkT04h7lLCtvY6CbwINj1G7NjaL8fpQcKcGd6pauQgsW9?=
 =?us-ascii?Q?OrpCW7jkz1udWb+iG6jv/V+7T7CoXKrgTOccXMrmO/yxdGi6brqMgYGvYoxo?=
 =?us-ascii?Q?c2idqPCpHsVxetRX1ZOAIu25qb79Lcmn/8RmWtilw4gFwEaUtk7+UyxrI9hg?=
 =?us-ascii?Q?dEB5pnWMfb+2o+P0dBbjlXsi9fJjqoajHSEfNujUdgrRnaa7lTwN1H8cU+nT?=
 =?us-ascii?Q?lxnluxgzBMKP+bFKU5AjZOkwYcZ3Y/4rhz8mY0phouhmd93mY4FFMZl0FSHb?=
 =?us-ascii?Q?LMdsKiZiam5AWWqFBUnTnO4jG8MQQ6Gc1/YgMTRX9L5zqDp2hy2ltc98wQiB?=
 =?us-ascii?Q?cJlRRzzV8Q3PqKigdCdY938aUN6L1tXg4wKP1XSRjHUskjz+1hcB/M1ftwkm?=
 =?us-ascii?Q?kQUThW8MRjCI/VpMBghPYmPxq76dmmQcUoIVxIqIIaQzvwakff1X8SxxhS0S?=
 =?us-ascii?Q?nFP1SLIoPeHrK9jfk6jD9+9l/TDgV5EM0lqhPO/3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 128bb7ad-0580-480c-8b3f-08de20a40759
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 21:56:40.4551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3+6XzEaYXTSVU37GimgTodXYtbZXnwf+yQJIRXdS4ZhdeDykdvLfbniFt7d7dczn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8986
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 257361C0004
X-Stat-Signature: kn9kk9r155p5ohnyscj7jj3ibxrtad48
X-Rspam-User: 
X-HE-Tag: 1762811804-462155
X-HE-Meta: U2FsdGVkX1+uU4+iDTYOqGkHuxpZ9a6x1/Cd4TfMDFj4B4bJEoJGN/d33gxwFUNzwWaC79/O+kv3EZ+PlrhholRF4VedT/ik+DUbNHRac2u+FC1yDJ5nxFYjHuNxWzadrrsqQ0Icjufev4J+Mmz7NEh5tAHKx81U2U4wGuIiLlHzRr3R0AKlfVHkt1+G9ZweHMgJxtR0mRi+rQtX/2+UrlYiBzOiaZo/S168bGBoCn870SfcK8Ywvt0YP1KfA0Zmf8x8jbANGnaRAvD44pPhJmL4890qjgyOw1P12s3LIL+E4nqs/tHldKRhnyLwpAwPDsbB75hAYDGhEKxMdU4hh34SReD4hQYa7U+b31iSCz7IqYNDhqAKZuIs5MpuHX9/pMXLLqQmmhmc5HANeQSbu+Rtzm7SKsttWP0wJ3UkHlKTfLMfbV8cKqBfPLXNtqr/zBy0IPL5z+DqYXvqtMIVTDHBBzdnkn9VPyadNuv8gAjs/lT6or+ayVyEgO6qKGsu0kKDLrFvQyz4S/OCofMDcfBcRhH2sM1sflVFXB6gIvqJLOtQ2L9qbjFUrKOxMP8a35obvpdaq7LETVdzSp5GMmP1goqeP/K+8Fz+h5FY7UO5cDwDIfFtIrX0jdK7T6Cwdc1bCNhrXQS0DUlFZwMCTXXHh9dpTZx/PGG/5UQK3AJl++R5/chkOXov/LzwwEvMqKkiEVDuKTL16XX9jl1/0yZruA95FRiBNwR+FmNwvEfItZBd69djvp21n5qoPwZ9IEP8r152Z7fC5fIz9onnE5Nz4bZmIPEzoA5bcCeNuubT5fuMb1yfKG/Z1GVj5e4JwZSb/VUjQmIwmG/M9kcbkwUpX+LIWyutUPZ+lswqrEeIc0aea3gGUd1y2tUwsGHJJK39ZThXcIYcC7U5XOMkUkSbIFqiDrafyrejZTYt0ZcFfgTb78/S0mNdU7gW4ZqqrhwV3Ajmabxs548sV4V
 ewK0wUZr
 U6h2FazHoJT2mbXQXArKwu5KyfAPYmzTryiuOx0esmCBu9b15Fp6fr0iLUn5hFWF0sX7m5LcBmHG/lFKx15HCsO02FlfTqfKVG91Qg7CHRPIfj5wCrkWqPfuCTOmcQLJ/HTfqXiU3p8FirSleoSNhyNMk371K7cgldkGaau8qeMbmlnChc5GkDUFZWtWHFpIg9Pk9fktVIFcBmhcOqkG+/uiMx1AXLZG7UojiIQi3PRKyzTdyeoI6aBir8b7Tp+d9NkiAF+0ET9i3eOr+enFWr9IZXj1tm3X0Fftoo2pqnP2bPB9yY9Dj38oxQBf2ZB2gBG+NB93kNWj3Hc4G2XQE950VKhSGen7vc3py6dA9gK5AsHj+NS5XhcYdsp8NNOQZrcFjHgsaF5mMr33s6e/iJcNRGVM0VQKRbFn9MyCNeL2q1qTHElPifpOXypgAyQcu8xfD37OzsiJTHNuVUZiOzlRw6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Nov 2025, at 16:16, Lorenzo Stoakes wrote:

> OK ignore the past mail, I have managed to repro this locally and have =
a
> fix.
>
> Turns out the swap code is doing something quite insane... I will send
> fix-patches to the series shortly.
>
> Meanwhile I attach fix-patch! :)
>
> Cheers, Lorenzo
>
> ----8<----
> From c705fd85a806f53017df31e6b072c4bfa839e3a2 Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Mon, 10 Nov 2025 21:11:52 +0000
> Subject: [PATCH] fix
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/leafops.h |  4 ++--
>  mm/swapfile.c           | 12 ++++++++++--
>  2 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a464a7e08c76..c4cd36760ea0 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -56,7 +56,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)=

>  {
>  	softleaf_t arch_entry;
>
> -	if (pte_present(pte))
> +	if (pte_present(pte) || pte_none(pte))
>  		return softleaf_mk_none();
>
>  	pte =3D pte_swp_clear_flags(pte);
> @@ -95,7 +95,7 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)=

>  {
>  	softleaf_t arch_entry;
>
> -	if (pmd_present(pmd))
> +	if (pmd_present(pmd) || pmd_none(pmd))
>  		return softleaf_mk_none();
>
>  	if (pmd_swp_soft_dirty(pmd))
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fd23d9f7ae10..f0dcf261f652 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3202,9 +3202,17 @@ static int claim_swapfile(struct swap_info_struc=
t *si, struct inode *inode)
>   */
>  unsigned long generic_max_swapfile_size(void)
>  {
> -	const softleaf_t entry =3D swp_entry(0, ~0UL);
> +	softleaf_t entry =3D swp_entry(0, ~0UL);
> +	const pte_t pte =3D softleaf_to_pte(entry);
>
> -	return swp_offset(softleaf_from_pte(softleaf_to_pte(entry))) + 1;
> +	/*
> +	* Since the PTE can be an invalid swap entry (i.e. the none PTE), we =
do

So softleaf_from_pte() returns softleaf_mk_none() instead and causes the
issue?

> +	* this manually.
> +	*/

This comment is not aligned, in case you plan to send this patch as is. :=
)

> +	entry =3D __pte_to_swp_entry(pte);
> +	entry =3D swp_entry(__swp_type(entry), __swp_offset(entry));
> +
> +	return swp_offset(entry) + 1;
>  }
>
>  /* Can be overridden by an architecture for additional checks. */
> --
> 2.51.0

This fix looks good to me. Thanks.

Best Regards,
Yan, Zi

