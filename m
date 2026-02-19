Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDBBE9A04E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 16:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424956B0089; Thu, 19 Feb 2026 11:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF2D6B008A; Thu, 19 Feb 2026 11:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290416B008C; Thu, 19 Feb 2026 11:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15DE06B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 11:49:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD455160609
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:49:40 +0000 (UTC)
X-FDA: 84461792520.28.D0A24FB
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D1B780007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 16:49:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NXRmBCpo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771519778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnzRg4UqNzQVcvCr8wKUIY4a2xiY+Os++t6S1q8rWyk=;
	b=UMfFygTwwDa9b4ppnkTbgOiNACNAJ/oi5dGpbhLeTnHkLxXy/H5e2GtWarihQdP931NTQB
	HVbL7jq9i4Yl4kDQpGTSV7n3Czr2kLOIcQgcNHTtoMEmPP2fn2QE6xmmUaDV3myN729fHN
	KYAr4jav5XCBMGk+wDLmn2j5gtnj1pk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771519778; a=rsa-sha256;
	cv=pass;
	b=oEMvag9c05bqamwoCKDS8a2jvd1WEQqNsDHPg5p/tqcChqTECP3WzgkhYvc1RLn6QjlFgz
	gXOgY/n/XpJQMYTaD2UxYFiJtW/Wqr6jrtvoQdn/A3xO7TJUgFZTlKifUH9eb+O/wOawcB
	CsCjl0QEllXyOJ9DEnlpn+OinsVX4No=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NXRmBCpo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sl2u5EYo0ucGa6Xoa1nzk5J7d/I0DNGFDxr4Ani25dVLy+Mz97jlHeYvItVcY4/qsVM37WIi/Fr3H+E3MUPD4Xim6QC7+rLp4NDYdhLfZKDEdl9IuWxXFylxwvYaMjB7BckmkRgbhYEaBu/gVejsS1hz3FzEuCWSK7bMCoQaqjVX3RsIXntNAZz9eqYqOp//hylFb3mV2NZ1jPrkDKdRi9kUiYvaSLzdpTBhEsP2JBekKwcoidO5cmpRj0ssIJPtgACEl7XaMgkZM0JbS3W3XNrweNYnIM0TzebNGI1c1guB5bZ1HYYfIwqnwt44w3VluWTNF11yceTUNImqZKuhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnzRg4UqNzQVcvCr8wKUIY4a2xiY+Os++t6S1q8rWyk=;
 b=EwVY8jSmCD7TmcszcpQrzTvreyP/MJKSOtCw7iYCPYADfGagmAU4zWDRYG5zv4X3ZyC0dCgceVtKYWBaiGP6HkxoexbYT9ny4n28Iz7gxk5ptNTchwSEC6IOgKJr0/ltX322arEGmTo4G+gkssIi7U8ESCe0sJIOhs+ZuyKzNdAlvVX0RZtZALH4BiglLs9An0hrODJd7c83RY+EN+bkC8OlRVYhRX2IOpr7v77uTjcZngoHNWSbjqvV8zEDV3fY7EKz/IxDaZ1+JsH8kAFgPg6vnQY7HkEpb5ucFCW3ymJE9k3/nfDJiMJ1zVP4lftH/jGj/noFhjvIts5w/c5Rkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnzRg4UqNzQVcvCr8wKUIY4a2xiY+Os++t6S1q8rWyk=;
 b=NXRmBCpoNzyRURHAd0m+BfrhWuGGQ0I9GYB1wzOE4wU1Gm7v6Sm9Eikbf7WZyEbqEuXnoajMmYmOoou/vpS/UIkPwtZn+WebRrspaPIw47ggB6YhbxUZpAcCgHkkeKfj++SeEBhI6+N1uE4xUuELTHNLO2oaR2gEB7pr3xUfSJMqXBFGUC/WeblSViFBhmTpt7Oeqqlxs1vDOGDHqopB6j3qbITO558B3+Avybp9ZgAnl53yUfIG9fTr5i0UwmUfwxPP0SMl+O9R+DE1cRXbpPTQ/fjPygAbIAH0LeCCoQe4G/IiN9J1NVo/o/2rz0kz7AAZCeJe/opKGE7cfwwdnA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5656.namprd12.prod.outlook.com (2603:10b6:510:13b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 19 Feb
 2026 16:49:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Thu, 19 Feb 2026
 16:49:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, willy@infradead.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, riel@surriel.com,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
 Lance Yang <lance.yang@linux.dev>, Frank van der Linden <fvdl@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
Date: Thu, 19 Feb 2026 11:49:27 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <87DAD8A6-85E7-4BC9-B81A-4A842DC546E3@nvidia.com>
In-Reply-To: <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
 <3485c8c8-9bfc-4725-885a-626e79d0aebb@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5656:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aa0370a-64d1-458f-0794-08de6fd6dba7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jewk9l9Ll37y6+eV+lANFa4t4fbt1Zh+6AnG+HT7iPB7RrsWWxj/YKTFvMXh?=
 =?us-ascii?Q?Vcuap2qLaCpYDT5KEnWDtSOroeGRdBccr/CJtz/zfE9kLMKerVAE4urnYAle?=
 =?us-ascii?Q?s0/1dpTOG6EoUvL17N1J3CLY2pR/1Q+ipXC/P5QoeNTSuUxfNegOYhu5LYD3?=
 =?us-ascii?Q?o6A7cx3PNcr3xoaR0y80xzy/NvRSYO8h8OrPNYY9c+5Tgh+gql/RB/ME7Rae?=
 =?us-ascii?Q?Pi2RQZCeJdqbIUkq1DqfAcLW2PT9dLbCuKH4go0XDzHfKhegHaqeU0K8rdpt?=
 =?us-ascii?Q?1CbgvMeDOBUWKKRm3B8hceWV2A9bh+3YxTPJrujqvOuXadn9k7U6BssvXID5?=
 =?us-ascii?Q?MhsLbNMgEBvYB7AkEEFZN7s2D8v2Q5k6+V6y/O0my4kL5iB7MP8phgmih0Ze?=
 =?us-ascii?Q?Y1fC/XtmHGSYmf40cZS+83zaYzxpWc0m5illCikI2fEAbEncAQr+dw3QClVU?=
 =?us-ascii?Q?e2ADjmopS5quANNNklgdWNAn6uj0WZJ+8w7aZ69OuZdiVK71lMOOfrzPYrN9?=
 =?us-ascii?Q?jjqhSLOmVxhRYH01wNmzXhu2KRvzb5z/gWhwk/z2R+NCUMTeTZZoN2ZXqBVZ?=
 =?us-ascii?Q?kYkIq4AiGDmud7+5YWrk2+dNWxAAn+/NpX3AdiLB1WNPmP0SPkaYycputbgE?=
 =?us-ascii?Q?0QTPV0P67v239MuUcMhrVoRIwtFb96M5PWTqGcph+d3jUWMqaM7IwtcISmTD?=
 =?us-ascii?Q?QePtDC60cTfAO7sExj9r5nXuzs7kpy4sltbmCMZpncpSbyaMjtLuTgwewdja?=
 =?us-ascii?Q?AshtwQyF47cYKlkGKTODJc2nV9eqpFyQfOinUp1o9iKSh74FQlf06f6IOVy7?=
 =?us-ascii?Q?72F+F/b56AKGPq10/9YfId8m0tE9UzOCImDIUSdu+WH34nEtEbug+IHN7/6C?=
 =?us-ascii?Q?HlEpCgFWsFl6sPfbXUwnh5KUcwU8NH7iAVHN8FsyNVJxyV10uN0T1k8nkzWq?=
 =?us-ascii?Q?dS8/vqCOJl6WQO8jIyTQ29CHO2zhNLyfEqO/WeNYfJPsiWPDCQ2yzaPJcyfo?=
 =?us-ascii?Q?PaI0aJbhNedSCd8wdKodMavdppT6pt89f3mBjDzU+ej6r6wANIWLNC6GyqoN?=
 =?us-ascii?Q?q1aNj+A4d2z2I89fFz1zjQgst9zLs6/IuyINL4oW8phMqyYyVlA/6LA5rGBs?=
 =?us-ascii?Q?CVJ1I6A+ByE8fbGBi5kAHQ+4Rek3OgsT4ET2L5gHIEbcgjgPiJC+0wLu6+/V?=
 =?us-ascii?Q?+4Jsp/EKeAkCZ0xW/m/pAaqTMzD8H6j409Q2QoFYnOZBiqz1mHGdKX/iUATn?=
 =?us-ascii?Q?GtJwBfLoPvKjCqfvnXjOU0StskpsoW6nCbSUob79hPADdu0ygSwVG6YO0awx?=
 =?us-ascii?Q?FLN+ZKkIK7F+lOBnwT5GsDNJOVlJzfxDSr4kKOtXdZv5quzBxX9lJvwhKm2g?=
 =?us-ascii?Q?pTVh2MZjwaziDVoP2+KOCa+49+zqsExGXueFsnNGErlZXsaKqOMdHgjSmBiX?=
 =?us-ascii?Q?tgC5QmrFzz+BEJE/myXm/ieAl4AW5uuYU1aYEPZsDUtA24LnNeU0OMNN/YjM?=
 =?us-ascii?Q?ufBZDLrK+zRwzEsoeUONjsriLU6S4V2aXHwBUpB99t0zIvGoxV1UldYXLAbz?=
 =?us-ascii?Q?ARV6WMPiNFxwKmKkbkA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PMxuGONH+CA7n8ZfN/i6nmsLU7lARp6mVRgEki5B13eq7ZoRcUhcMIgIq5D2?=
 =?us-ascii?Q?bMOJMZEUa10Weh2HcTT2fWYeMrTehkl965QXSTrnoYthrmuNq2bOkv1QmjnD?=
 =?us-ascii?Q?UYJM06qWcMlzoY6cmJM/7J8EcZWyvVG/fx1JsK8c6qeeS9J9IL/YvZkIuPPw?=
 =?us-ascii?Q?M1GNPw5skdAVMkMgPweJglkaYJvJGtnFklf8lKFkh9Z7AHQY6SHpnqh9UHun?=
 =?us-ascii?Q?NSbLeIOTsvfGhrns7Oh8HzskTRWOodRovy31ClRs/IShyv+VlSw2OEf2f3W5?=
 =?us-ascii?Q?J0gygtc8DrMTKc0bUIlYNKTxWuhlv2A06E83u/2YdRarWG3nvhNR1fB3X/wa?=
 =?us-ascii?Q?GhVSwrsjhH3UhkQ+Dznpld++RPUJz68QqkF6UQs/NybpOLIby8yc3Tmu3Mzk?=
 =?us-ascii?Q?DbsmcP2dmkiUvarQdQMk4HwT2h4v4nuhxu1doFaw3oogZXeKDUzx/BCHVr+P?=
 =?us-ascii?Q?DdYF1GKefyA4/k8zjXsdGjVtoGlHptLSvpeobK3CtRqIrGAsSH+ap6/Vvuj+?=
 =?us-ascii?Q?fERcfxyXTQ83pn0yMvDDzOh9jAa3qhwd5yoSw0n++QHyCUpkaf1jREmIRMLT?=
 =?us-ascii?Q?lqPZyNTaxVGBOewPoByXbDZndNkQFHO+NcSbT5VDOAeeq2oC2zZkcb+LINu3?=
 =?us-ascii?Q?792Fh9bGrROS+XSmWJgzLoF1QZ/pBpbjF2GpxGB94b5B9WFb2Ubx0Wzcf2HG?=
 =?us-ascii?Q?8x8lpoef7in5YsO8YyrMZIBCgPJLLm9V4HaUHJZyTyd/BZqJLhQc8LOWbL64?=
 =?us-ascii?Q?eZy6AE/Zamn29r6lFfjLLENL0DaB8M750e6g/uCdUMJMVqgzMqhpI0j3/QfW?=
 =?us-ascii?Q?pDC3wt0m/kwOxunwZY275AAQrZDCqcYEiNDXwKVoUZOJKvFocOT38CqqZXPe?=
 =?us-ascii?Q?sJZUe8ys8L2sBSZs+wElR/24N1Qsv4sowGm3evtMjpzdTUtFYvRi2V4JrIoj?=
 =?us-ascii?Q?f7rbY1gAQZmXmRCpdSSzErvtQatzvxgY9w/cUmeRP7qF7f4OwrvsLg7cJ74w?=
 =?us-ascii?Q?6CoYfpD9KAXRIArknTmTcgDcuybsG6ZTi3oi4S0BO7Jy751eFaeI+9wy1AkH?=
 =?us-ascii?Q?ImDXZRbBPB99EJGUaHj5TzYLv9+UichHKiZnrB/mhKQLYxu2/FTYnxiQgXzk?=
 =?us-ascii?Q?eNmuiQVqm7f9rjtggqimFPVlwr55ldrM2blaD7xoaG3Np/RlLNbU+uw92wc/?=
 =?us-ascii?Q?9XyRuG6ibu2KTG2U5PLbEvu9gqDfZgYkFwHO0WgrjEdGW7ROETwlfROuoMNe?=
 =?us-ascii?Q?IemV3/KPYTVxwbHZUc6upNP5aZKtv8R76GTBdnYxIWSYB/cstpXTRdoPM9Ia?=
 =?us-ascii?Q?9gtjLFt0iqo4K0INli1vPyi1UBvQj/kSbE3S9G/S7M5uC19byLLHeaN+Enll?=
 =?us-ascii?Q?f04khAT/aSqtCaK8lJg6PXlH5CT1W3gLHfCxmDfZG41U1zM9kXvtqiHHLX5R?=
 =?us-ascii?Q?/sf/vAkwBFw+9beqpDEj+1J9FaQznzuH2GWoxdFkGwHAFz/S/X9cBGbSGVJZ?=
 =?us-ascii?Q?HggJm2tJZXIh0HYzEvVdW2UqDPnmBevLjud45rfSNaUxI9/CgKSo6C1Lv9c2?=
 =?us-ascii?Q?5I0cSSXZelG1+wRB4U4q6GiaREFhJQXqhpVG56KsWE3HizbCMOh8Bo9Q95CF?=
 =?us-ascii?Q?nmYiKHrByp2U0oQh0vcVxXfHyrpbdbaKD352BOp9EheJvdtFLFN7k+JZSCiZ?=
 =?us-ascii?Q?j1YFBeoPwd35kPDyMicaX5zS68AaUBi3qUIziqGoa+AhHJrL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aa0370a-64d1-458f-0794-08de6fd6dba7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 16:49:33.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n20xqWSBhBpI0y1a0Q2ZfKPbeixXcTqTQQ2ny6cvBtrH330gNg49uzu0H683eAU7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5656
X-Rspamd-Server: rspam09
X-Stat-Signature: gopnbk5u5ufhay7xibp48xn66j94axi4
X-Rspamd-Queue-Id: 0D1B780007
X-Rspam-User: 
X-HE-Tag: 1771519777-161697
X-HE-Meta: U2FsdGVkX1+dwJPV0lJMB9LY9m1Ej14BhE9VwmKpV9MkUgf4bhrd+yKrdFQScAy40lzPAvxu4UKffeJFoyE2s3//S13bJ9GtccMUu8CGLee0vFSONYegoio8Z4DCohEeROnwYoXPBKt3DkKmzhUjuOImT3Ug/3p2OlXa77dSCEepPAgg9gDkykAcfsv+cIoCp9iZ0kxW54ZO7Ioz01p6ITwAWV4YOUCP+ii3BDiiKhWiKxsWLsm0tfgEgNj3tUbo1YPxrMrFeIpbgreeQ4aF6AfSL1am7LxaBFieoH6JatGZilR8rSDeECs9CKnqjBqEdEthevlBHuYGdBUASK4D92ywU+MtQR9ZTBLCkixPLd0Gs9e7te7cvR1eX0Z5anBh3sgeG4wXMz5L9kLthcIyPoWDIoHkTq8+maBpnu7VgbHzt4Qap5JbEvi5xD41TtKU4EnVYEQWjcnYXgHIqqUw1YwQv1B1FCwQD6hsCZHqNS8oswxN+YP6S2fT6c8ESCD8zgJdDe2hGM8mYL/n1sQ7IVuLwpZdG7q+MYao4JKXsQk9pWCCMsZ7KLIi6e/UjBC0FFSDaSRXD2FM+58VpxrBG8OIl2nCNBbQJ8FzOPYvMe3pPFljGxvKKTlf1B4OOSapH7vo8PvC3iH7E3a17ba3H25T376l3Db6wuRTcHWhjuKChHuDQbLGw7Gs29Xe2izuJlfHslBTZwfLhb7JcZBrd0HKPlUZ4CThqxS/+ICwOMEakvWcTFRkHBYOLeVdeQd5FZ7H43+FlOXh1RFE7rQ9OwoJwaJzEupUHxtnh1yeODlrjs8vrEOpzVTX/RmDfroMvXSZ+jeJ/XjN7zhI9JKpNjCRgyNQIwQVtHXgY7T9Cae8oJXoaYqI4FaxD+32RjoFIFSB+QJT87saec5pNUOlTzanUm4cuP+0Syo2hX7vXtNqVpI+Lo9UDdk1liGY68Igok7AqLx7eMZbsL4TA4E
 FRl/2ou8
 MKl5rj4KzBNn8BjLFy0KkL+66nc6GGeCkpRlSwMwaUenNyLWR89+Iv6w6DSSsLzMVhbaFjbf/dZu9rbJpsbDtsZCbv/AxTQAOo+eoUCj6e+uM8g7grHD5N0xZKYnuPcXaDanr5oohC8LP4NETPPpFW9VqoyWWtgryIAQHVVQwsUTlFSEu0DCMOq18HzSfWL/oxmtWG23Hxc9uxuEAOMam92XjupK9qzQgFaGTCY0X2uZoDbOmKNX3NRp1K1Y7hWVjT+w4EJfHjs4Ekr3y7eDZFIsn7UYFYs4Xz6CqqhqDPm/j8BzI8x8Ao5o/7uogdm+gh8vNuHtaGVV5CjeQ8NJecq0rFjPbu+xhTNxl8UrzC9hQtlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 11:00, David Hildenbrand (Arm) wrote:

>>
>> I see 1G THPs being opportunistically used ideally at the start of the=
 application
>> or by the allocator (jemalloc/tcmalloc) when there is plenty of free m=
emory
>> available and a greater chance of getting 1G THPs.
>>
>> Splitting strategy
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> When PUD THP must be break -- for COW after fork, partial munmap, mpro=
tect on
>> a subregion, or reclaim -- it splits directly from PUD to PTE level, c=
onverting
>> 1 PUD entry into 262,144 PTE entries. The ideal solution would be to s=
plit to
>> PMDs and only the necessary PMDs to PTEs. This is something that would=
 hopefully
>> be possible with Davids proposal [3].

With mapping of folios > PMD with PMDs, you can use non uniform split to =
keep
after-split folios as large as possible.

>
> There once was this proposal where we would, instead of splitting a THP=
, migrate all memory away instead. That means, instead of splitting the 1=
 GiB THP, you would instead return it to the page allocator where somebod=
y else could use it.

This sounds more reasonable than splitting 1GB itself.

>
> However, we cannot easily do the same when remapping a 1 GiB THP to be =
mapped by PMDs etc. I think there are examples where that just doesn't wo=
rk or is not desired.
>
> But I considered that in general (avoid folio_split()) an interesting a=
pproach. The remapping part is a bit different though.

If HW can support multiple TLB entries translating to the same physical f=
rame
and allow translation priority of TLB entries, this remapping would be ea=
sy
and we can still keep the 1GB PUD mapping. Basically, we can have 1GB TLB=
 entry
pointing to the 1GB folio and another 4KB TLB entry pointing to the remap=
ped
region and overriding the part in the original 1GB vaddr region.

Without that, SW will need to split the PUD into PMDs and PTEs.


Best Regards,
Yan, Zi

