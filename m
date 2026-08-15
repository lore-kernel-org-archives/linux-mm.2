Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3067C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FDB6B0772; Fri, 14 Aug 2026 22:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2FB36B0773; Fri, 14 Aug 2026 22:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91E326B0774; Fri, 14 Aug 2026 22:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 571E56B0772
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:37:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C07C81602C9
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:37:58 +0000 (UTC)
X-FDA: 85101943836.20.8849426
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3DDCC0002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:37:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nJ+Fb8Kb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786761476;
	b=A+hGplUVfcmj+WFtpMb1SBOz/fWvq+Q67/D+ZUUYDH5SOukUczDAIIKKAoxUj9uXSoFHdY
	aHo3oBtdcph6Ckrywv9cd2Oj5PGqZvp01gzRMM5kihguLWvFrfz2f5F+7FxwHVnSWD0vVO
	x9lwFO9o+HVC4fqnkW6Nkm9FpPU5cpU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nJ+Fb8Kb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786761476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkMOB9JNcOHFJBObAQj1uDjyxY+eNMT5bOF2X7qAlR8=;
	b=BcpUtnzCN9Bxw3YQH0JrvOYYTeRtInTdFWqqIKqRLdw25L7DYoOLLRxwV7Q3Agqg7claPe
	9TKC+ksKYk+0k7+yo9hRWtYX3R2RrMRtOJtwXS3eCO/g3OYXYOYlM/vdDk7MWJ0EixYam7
	cRYP2hAbrVwzC1/uSeYw26TDfCXFC1U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyE5zGS5mUXb9UppPru4QLOGI2P1M3vPD7+//BIrZM8owv7lAdMV849Moui/LKuTpdiU8lGCWxzTkydNpFt9ZlJOSCQYBl/xym9dKod8xeCMDSnQxNUcSc9fbpprrsqr6NoWUOxYAq3xXrpJa+MTIP7HByw3+IkSpQLGUfRonLVMuDDJYYWjNk4n2DtKnEg831vTYl5sZ0BzMQRSbQ2JFKDso55NUBm3MRoYzbmFGtFcvRoyJigx3sVyW8IUHiXZusbof44ai6m/4IE94VON4jv6fGdBoIJiXbo7cdCkXRpuHSRQWxvtPu/oHB7xCrWc/LcJcC5xU62fnnjPI3Nfjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jkMOB9JNcOHFJBObAQj1uDjyxY+eNMT5bOF2X7qAlR8=;
 b=odsr214E30cx2RbCwa9FKPxqlGYityUlPrqavms/g/1fIQPJSs+Hg9YjWC0946+HTHKpaerD5xpG90DMVUCfTGzsWYLQb5DF8KvqxAgoI6AQ2EeyN48EctTDFlOm7lfpAgL+jhNd0tUYYXTQY969Md5lTud58DZG9deZAZvq05Tx5l3f9JddpQrMasHgFUT0Tt0WBYskH7N4wuxGWrZpW7BPU3M2uLlWQo9ITSsC+GlDBgx5tu+Qk3BPo6KNxTfnUyvGqZeUuSR/5rPBTN8oPOKLl+Ht5Qp9xF4PQVcJ7tdhaf4zvP1riJ4rmqGQoQCe7O+G6NociPHHKIbxavmsNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkMOB9JNcOHFJBObAQj1uDjyxY+eNMT5bOF2X7qAlR8=;
 b=nJ+Fb8KbxLmN1pqRuvC0LwqV2eVbCoBXmK30GZpghR/H4spWi10LA2RY96XpugO0tvRS5/+FCEsHBQCE+r0mP06+YYEnIhG+sIgRlu87OL2HGtCD1M8r1Y8OxIh8FLDJoBIdRDEu+m0e+z2YNM0ucvCYoW2ZcCL6JIRUetnQwoHtnOF6y2ERREhnPRNtUVD2pJUI96jsEWwgvfUgfmePLdrU1yQjOUkiTZm/Pr6J+alDFQPaSgTaqhbqcN+wWmSVS6nD1g8/EbRELKotQWp4yvtBe/gKCW0w+qxQ/PaerNHJo9B23VIotHvZLRAt4IsP1JiuzEUPpqfqnbhBtby7hg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA5PR12MB999323.namprd12.prod.outlook.com (2603:10b6:208:605::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.16; Sat, 15 Aug
 2026 02:37:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Sat, 15 Aug 2026
 02:37:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 22:37:50 -0400
Message-Id: <DKP62VXU37II.ATZ38Y3PAIE2@nvidia.com>
Subject: Re: [PATCH v2 04/17] mm/huge_memory: split the routine for
 splitting anon and file folio
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>, "Shivam Kalra" <shivamkalra98@zohomail.in>
To: "Kairui Song" <ryncsn@gmail.com>, <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
 <20260813-swap-thp-cleanup-v2-4-d2ee48c6aa49@tencent.com>
 <CAMgjq7DD=xZutuKuL8+zVnBAaWMO2DHi9kbvHzXaDPZ4JLqt+Q@mail.gmail.com>
In-Reply-To: <CAMgjq7DD=xZutuKuL8+zVnBAaWMO2DHi9kbvHzXaDPZ4JLqt+Q@mail.gmail.com>
X-ClientProxiedBy: YQBPR0101CA0087.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA5PR12MB999323:EE_
X-MS-Office365-Filtering-Correlation-Id: f646b80a-4b59-436f-773c-08defa763463
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|56012099006|10067099003|3023799007|6133799003|5023799004|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	P6qqQsiAaIbQuj2frarfEdMkErkGpf+yvwQY7SaQqv0COUByxjmDC84/kCNH4qnZVyvsM+gjRr0H6bic/dtyR08xNB8F5NO5gZLyt0rQDMTiK+a27Gvh46lJ3IbQF6r45T3HFPe5YxMyDGy2r1JITBgokGj4QrUYcClkiVz15wZbgjES+aMkGr3J7fKIhEGpX8IoKrUXZeDg2N4zExY6dz3/sk2PFqtk5AYFuMPweh2L2H+fU9g7Tv8Qb3QvckLmpmEhlucTaZoSKyR/nvhAefOP9CXYePP9zMAX0cRU94CIR8N09T6r9joEjOvJFr+MBQumBgk3f21z8C1g4dBdtIX+l3E3KYd6aO0kReiM+Iad4EmFrkMdnkkBlhUTNBnuOXW1rELFafZxUhbLMz3sQjVe8ulUu91lioN5slou5BNtaTLEvhSBVC1+GBEX+XEOFlbl9m9jLWWCk2iuwL8XH4mTHYOnwsEX3uzee3odmHs+q3oNVbbGjT+Dafj+NEISQhJUBc1jHOQiEC2Xq8A1dY/VB6INrr3N60udQJU26fMRpe5Z4uqXTObR4HERWiN60cRSsg/FxcRhR+NyhdkLrTTITo73qv2u+fuyh1/C7kTd788qyyrMHLXe8MqaOypN3J2x1lOuOR46h7pBzkhcgY3Hn0UvAxo+51anm6Dg4vM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(56012099006)(10067099003)(3023799007)(6133799003)(5023799004)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFgrMlc4S0hFOEhHRGpOR1pkdDVBWEV3WFZ4TmJMdVJLN0pNY2FWVjlXZzNF?=
 =?utf-8?B?cllNamVmcSt0TlRMcFpxVjhvRms0UitpOFNYc0tMd2tiTnowUzBoaHh1NDBP?=
 =?utf-8?B?SGhKcGtjR0llL3B3bkgxVll0ZU1OZnhyZEtNRFI2eCtBZ1oyUkRLc0RzQ0Mw?=
 =?utf-8?B?MUwvcGZyUGpmR0ZOL1FCWFZ0MTlNM1BDcWUySThzUFJWU0FtK2V3enpMTVll?=
 =?utf-8?B?M1BMMWp1NFh3L0grVWxCREU0aEh6TExUOVB6VUNpVzMrSC9wVnJuZ0loRFZj?=
 =?utf-8?B?RmhmY2JZRUJCbUdYQWg4ZzJiVE8rSUU3K0xTUFhEeVNRWm5SbHl3SnRqSzAx?=
 =?utf-8?B?NDNCQWo3QlRUVjE0YnhsL3VNaUF4N2g0TVFuMFlGT3FjMFlub21EWWdUTVBv?=
 =?utf-8?B?dUNsUnNMSVU1aUpLOVpWRFlPaGJoYVMzWWFQNHlNcjNqbmF6R1dMbUV0V1VB?=
 =?utf-8?B?UUdVaHFtQkhnaUpLeGhkRWkyaHJSVSs0dDM1SkZHM05vajhDcld3dWJlU08v?=
 =?utf-8?B?T3IrZnU3SUl3ZTlZR0tjU3JkNzlxMDgzdjBNSVdROWRJVUVHZWlKTW13SHdE?=
 =?utf-8?B?ZDRldnMrbGhuR0NHS2ozZUNUSVdldExQSkZmdDhac29meFNxeUxhNGF4RDBC?=
 =?utf-8?B?cUhZMWloVHdvcjVFdHoyRFpXc2xlTHQvaFptKzh5b1UxMGdJblJ3azBFSU9P?=
 =?utf-8?B?dVpqTUNBcnBqTmUrdXAvbHJZME90VytpWlBFRDZCOXBDVWcxYVpwY1orZFRp?=
 =?utf-8?B?dnduQTYzVnBvQXpzQkVHd2hQajBQMDFNM0xmWUkveGxrcEpZZDRnTldSRXl6?=
 =?utf-8?B?WEZGN2kxQm5BcWUwRml1Y21FTzZEaVo4UGxVMlBqb1dncTR6YmRreTc5N1NN?=
 =?utf-8?B?dllVZ0lSdnJLNTVocEpLSlR2d3pnL2FQYWtPV0lhUTgxQUFWOVltQ2xlVnN6?=
 =?utf-8?B?NTlmYVB2N2VYdGlGL09YaklNZkZtZHFMcG50WjU1Nm5qRmZUejJ3c1RuakRU?=
 =?utf-8?B?cndJakFDMEVnZUhRZGxGaFVTcWFpMFBXdXFudEZUS3NrTE9kb2dBd2ptVXl2?=
 =?utf-8?B?Mko2QW5WcTlOL0RhVVpKQkZNcVpLY2pCLzV5allySDB4UjZCWW9OUW5jS09D?=
 =?utf-8?B?UllxMGhReWs4T1oxSmcvY1Q1TnpES2FXSXdsS2R3VzFzNXV0NlFZSnY2TTJx?=
 =?utf-8?B?RmhLaXkzc01zdSt5ZWhjLzlmaXNiRHlNdjRya2JHQUtrM2ZFbTVFL2g5NHJO?=
 =?utf-8?B?eXhXT3N2M3F4L0oweUhsUEJlckdIZFJjTWwyQVBQNTM4Mjd3MHF5N3podVp3?=
 =?utf-8?B?b2taSkNSU3VqZ294alU3QXR4ejRwa1Y4N3YzdTFSZVBSblZaUSs3RXUxblVl?=
 =?utf-8?B?b0JLR3g4OWFoSDVZNEJ4eWd0bGxlS1RSSzJuaXlsU0JxZVA1TG1tcHNQSnRV?=
 =?utf-8?B?UVF0d0hESnN2ODBYcW9yVnRMWXMwVll4UkVqT0c1anRVRXlMVm9YTjIwRTNS?=
 =?utf-8?B?SnIzaVUvMWdYSkJuR25xYVNZck1TNlhwYU83aFUvcFFDNUs4cXBnSkxWZTdk?=
 =?utf-8?B?Z2VyVkI0ZWJlS3plcXh6aUlhVklqOTFXWFJaNFBZRDlMdDlpeDN3Nk03V2JZ?=
 =?utf-8?B?QmlWUlZjQjlXRVc0M1NyOE5TY2lFcUZQcTJoN0FkaVNnYnFuMWZQT2lwWmhy?=
 =?utf-8?B?VFFFZGtFUG9Vbzk5UlBya0FTenhtaVpmeGdwOGtiREp2Z1dvYTI4SGQ2YTI0?=
 =?utf-8?B?R01pTmlEVnlVLy9odDVCN21rUmYvbVNFZU44Z3hNeWVUVjhBdnZCK0hWYWlT?=
 =?utf-8?B?SEFYZlI3Sy9OTldXajE3Si81SWNlL29ieDhGNEEvNFF5VE9NTHprQ0JMVkVU?=
 =?utf-8?B?Q0pJRkkydkZmVm95c2M3a3pKdXp5RE1RbXU3YTlFOHZHMUJuT2pGSTd2S1Fp?=
 =?utf-8?B?aG4vRG1CMTJUVVdmSTZCVk12ZDlpMmFQZllsVWZxUDgvZXJYcVRPdGFTVjZ5?=
 =?utf-8?B?M0VqV1Jvb2M5dDVFaTFIN2hTd2ZLdEt2c3psV2pLRXgxM2ZmcXliRHhMYjgw?=
 =?utf-8?B?U1gvdFArNTE5ZzJaSHd6V2hYL1VmUzZMdjdxeGlaNHVlNVdYRDhMMUR4VVFp?=
 =?utf-8?B?QTExQkJsS0FZWEtoNTNWdWRGeDVMcVo1TGJTZmk0LzFyRTduVGlUL0xPSVhC?=
 =?utf-8?B?bmMvQTJuTU9aam91Q0R1MUYycG9YS0JkZkdNdFdlclhic29yaGp2VmZvTEdi?=
 =?utf-8?B?ZGw0Z2h3b2tTL2VYUjkzc1A0aTBWL1Q4WUJOUlJFWFlpeXo1aTdYVkxhT2Rt?=
 =?utf-8?Q?nMPN97E0uGrByHYyxv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f646b80a-4b59-436f-773c-08defa763463
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2026 02:37:52.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Vuk3mxCQE/lehvXqC0+Juobpqb2xU9Hs4EVv2s8fByvkG65RM+5gQxjzPW0QStY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999323
X-Rspamd-Queue-Id: E3DDCC0002
X-Rspam-User: 
X-Stat-Signature: o18kzdpftygucjkpmze13do4j5gobexo
X-Rspamd-Server: rspam06
X-HE-Tag: 1786761475-359922
X-HE-Meta: U2FsdGVkX1+934wHMe4nxHUkTbFFGNM9hl18KE89f+BPvd9qESaKPHOHVtl/BnAi/K8cknUDjtwWp+iaetAPBXjZ/7BgKaV6rpALDNyg4sU7QRcXFoCDI3VTuILaFzSeesF+5dO2cQAadSRtsCLGdxo+3+RV3ZoRka5/xegDYq1vzepOlBqClRtP1vMdrCvp79SzBKpk6K/cq47hz4Lcuu5yyfHrMX7uGq4kAunRW2FajavBhJwjUpcnALlbFN7zuKeWf/EWaKLTrqXZl4+xeSkbnrBfhqbkWK+6DA/T+DoFPIDIh0xU0K7mFFZwN1a5q3bjp6i8AxeRsexMIyaAtn3gwaUsJLSCoUKIv2CNahq+HaAEIVvjUnq6VLHZJhLVqzVJi2YKFzVEVT2CTSIrKliQZGIU96Px9RyZCbBY9cImZJ1+ZFCQOj04em3suL7UtLCyVZ3O+2vy0EoBTi5oDjMc5uLfey5Y10TXBjmoxY9TJI0+SxnwB/k4Re30JWgUlj21GsRAieCF0S88dYRsJn+vVgioDMZnVdZtL1P60QmcgtnJSm0exzg6pmOktzKS+jO/EGatur6HNqeqHu/BAZO0tMHpzwSgHwrBU8mMiQEi7gpoYUW/KmHSPaVwYt3xTySKh1wlFfFpLcFXhR7HI9Co0Bxxgbe7ATO49PtWowFP4uRWK7+zaAWaO8exlahs+THwpshD+q1kGSJ3qjWc3hpDVayTLq094MKT4xUTO6taQ6pBD/Qy2Zy4fU6dlRy8zwIundupvWN2fifAH7SfV/HtkWKJGlVItP5HzXyvmT7uEyyycQo5ooEC+xWnxaaVKQFCssVgLwq0/Q2tv3QtFMFpEbtLCOieFHbeIKYEX23nfSqFiap88js0SOZkhyCbzG52gD0Pqv9oaAaMiqxdfckIjbL7l5I9xYjjtUMlnYg2X/v0G5cGp6iBztjRDTeDnhtk0qltWPvHvWmfiZv
 ny5IGgSs
 h5YxY3kmad0O44BG6sHDEK2RFQOlxjGHO5rQkXJ5+yvBik3EyH1Sz/IYZ1iphNGciuK/6ya+gFo9qGmGvAwTqjBSGQ3jwkrwT44vz3xO1sXOmjhpsfrcVgnkEjnU8d0Y6N6fYsfoY+QoDeLki6wxHT2DX9x7EAfNlQ3Z956UMknG5+ujb3TabFD/RynNOcAdTROVQysGSg1y2Rz6rJRVLQETXc5DOfIup+IsVbIwrLZ7rxxOWfWlDMsh+htEgoqibKEsyOU2OUDwY7iUYz95xpDpsjionXuipCAF5nVRMi0q7zu31ydZxuqUqFE8UuOXNxIsEDr3g6zfxZe5dTCtwTjlKk7L+aOFY3aw9QoK4WjCfUff6hVEq+5SY5a7Ymp4jC/7NOYLYewAqV5Bv/oQi7fvjO0LBmL008Hk7sSV6ocSJ6FMLnQnrO11Guh4ZEfgdZojzi/MrAWNpEBV8M80xvcYBaz9vnkCKHj7/TZUQgBTdMzivSQjH91JLso3YZsrbZRmP8LiqM5NFlWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 13, 2026 at 2:11 PM EDT, Kairui Song wrote:
> Sashiko reports (a valid case this time):
>
> --- Patch [4]: [PATCH v2 04/17] mm/huge_memory: split the routine for
> splitting anon and file folio ---
> commit 249f031b2182770a8cf754edfb3833e148a033df
> Author: Kairui Song <kasong@tencent.com>
>
> mm/huge_memory: split the routine for splitting anon and file folio
>
> No functional change intended. Before adding more logic, split
> __folio_freeze_and_split_unmapped() into an anon and a file variant so
> each path can evolve independently. The two paths shared little beyond
> the folio freeze call, the LRU locking, and the unfreeze skeleton, but
> differed in all other per-folio bookkeeping and routines.
>
> While splitting, some cleanups become easy to apply, and helped drop a
> few now-redundant checks. Also introduce a folio iteration helper to
> avoid a common pitfall of iterating post-split sub-folios: a sub folio
> might get freed mid-iteration as pointed out by Zi [1].
>
> Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.c=
om/ [1]
>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 7fb603ac500f6..7587eeb09e4a6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>
> [ ... ]
>
>> @@ -3634,6 +3634,18 @@ static bool page_range_has_hwpoisoned(struct page=
 *page, long nr_pages)
>>   return false;
>>  }
>>
>> +/**
>> + * for_each_folio_safe - iterate over contiguous folios safe against fo=
lio free
>> + * @start: the first folio to iterate
>> + * @end: sentinel, folio_next() of the last folio to iterate
>> + * @sub_folio: struct folio * to use as the loop cursor
>> + * @next: struct folio * used as temporary storage
>> + */
>> +#define for_each_folio_safe(start, end, sub_folio, next) \
>> + for (sub_folio =3D (start), next =3D folio_next(sub_folio); \
>> +     sub_folio !=3D (end); \
>> +     sub_folio =3D next, next =3D folio_next(next))
>
> Does this macro unconditionally dereference the sentinel pointer?
>
> When the loop increment step executes, it evaluates both sub_folio =3D ne=
xt
> and next =3D folio_next(next). If next has reached the end sentinel, call=
ing
> folio_next(next) will dereference the sentinel pointer to read its metada=
ta.
>
> If the split large folio happens to be located at the end of a populated
> memory section, the sentinel pointer (end) could point to the next sectio=
n's
> vmemmap. If that next section is unpopulated, this out-of-bounds read wil=
l
> trigger a fatal kernel page fault.
>
> ---
>
> Right, I actually hesitated on that but forgot about it midway. I
> think I'll just change back to the opencoded style, it's easier to
> understand that way.

Let's open code it. I also tried a similar macro when I was developing
folio_split(), but got convinced it buys nothing.

If the motivation comes my prior comment on code duplication, feel free
to ignore that. If we over engineer it, like different function pointers
for anon/swapcache and file, it might be doable. But that might kill
readability.

What I mean is something like:

__folio_freeze_and_split_unmapped(func_t pre_freeze_func, func_t
unfreeze_func, func_t post_freeze_func)
{
    pre_freeze_func();

    for () {
        unfreeze_func();
    }

    post_freeze_func();
}

for anon/swapcache:

__folio_freeze_and_split_unmapped(anon_swapcache_pre_freeze,
anon_swapcache_unfreeze, anon_swapcache_post_freeze);

for file:

__folio_freeze_and_split_unmapped(file_pre_freeze, file_unfreeze,
file_post_freeze);


--=20
Best Regards,
Yan, Zi


