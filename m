Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70968D12692
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 03:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E896B0028; Tue,  2 Dec 2025 22:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEA16B002A; Tue,  2 Dec 2025 22:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6626B002B; Tue,  2 Dec 2025 22:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B67A6B0028
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:07:48 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EB2BD13AC33
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:07:45 +0000 (UTC)
X-FDA: 84176674890.01.DDF7A1A
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	by imf18.hostedemail.com (Postfix) with ESMTP id 34AC51C0014
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 03:07:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k3DVvi7K;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764731263; a=rsa-sha256;
	cv=pass;
	b=5xe8VZA7MrkG/6moqFP7iR7yepSLSqvjR+fERHGFZvGFYKKy2Ir//uXMqcYyhjVMcIuVXE
	oSttvv2vSIf4JMV1iFjHEPx9jEA+yTbDvVhqVEEABmeJry6lgOvkvwQ3Fq+ZBolZXj8HWv
	OY0oGZ0WTIndu5uAoFWAdfnaBlysIvc=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=k3DVvi7K;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764731263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhXNOW7BYWaEhiCnjJhGBzKeO6gVI8alk1Jox1N8rYE=;
	b=f1NKz0ZKo6dQdloEBwshr4aoJfexvfNjObgrVaS6hTtdz4LLaEHRjGE0tlDslZSRLrYiSR
	2vUa8S3ztIfRFOQC73qhj9Ozav0pggRmpqdX6dwtnUHde39KZDo8LCbh5TSw44iM9mzVsM
	osF/7L9WUWJkgmtH3IGJaqMzsd2Ch58=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SlXnin+WBm/pajsTv2rqRe2j1WCgIj3EbO2t5yGDV3lL6l+Dl39dKocegO/Arf7ckrDNvszeG1P+4wTsPFNeNMjoZeNFHF3j0gNWHWNpxaoHRKFh+vQapWtL127Nxld+UaH5XPPn8QUNDo5+hLorgWqk4Mv7+YhcyTnQTDEE9R5n++Be8luUYP0OmgYXk7zo+Q1ufdkmJk+pRG3oPr/Yd4nehPhu2rff1yZKZ5Q9csxSbvFFra7WXKOCi8SRq791fm4xJA7ZC89W9d2mb1jadIesa9ptBKsFY19rFKTFFLdRW/kemolk7yIOmj9KntU9d2QJuJaaKcllo+nmPk/b7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HhXNOW7BYWaEhiCnjJhGBzKeO6gVI8alk1Jox1N8rYE=;
 b=XajAF6l1+gg77gVj+NKQd61fAsO6jCOLc1jTbbsz6PDRKtR2Nqk+93fvPClCuwPz+0PwBAazF7wo6dDwZShY6lkMXuJ+X6ypXxchyLN0bl2dyHt6D1wxW5JuWL+KACB/l6rF9EVofQBzB8H9+T/mpKTXDc/YmmSea5q82hiIVooCEYFt2FzHPeEOASPCHbebKNbOencC+38BmlNeP2BN2MOnWaMH5WwSiRckcpgLt0KUecEAaaMXWt1BdZ6Zzhgh62eU3SHMDVlrLygl2KUs8BXPv66ss1VnMAHBAlb/qtmCzD7DUB4lbQFeSxmrGj1ubZuVfBfVdTLL+FYqL3OFoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HhXNOW7BYWaEhiCnjJhGBzKeO6gVI8alk1Jox1N8rYE=;
 b=k3DVvi7KsM5U0pmv48K84vLYvInia5xyMzmGrybdHc4otB1azB8fAq8VnvqoKxZyEsTvFSIymJdFOuLpW5HZSZuD5DfgyTi4PF43K5aZA56nE+sBoF6UbOgmNHLEVLx6UkyZAy/kN1MqrEGaRu41qRs5twy5vuVNxpReQbhgEDAuIrW8fhHGer4FOAwJ1j//z3ayNpzO+NnpjGccr5ZKW/UcG3zvXTGCmzygHtIg8pRAtUT4H8RDYc3ovNuS9+vtaJlidR4HUqVge7cFmT2UoGMm+rpOIj1cp78aA5kRugrUgHIrQMhUXqDSxjrfwiRzR7PaXzMpvQOxYhyJGtImHA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8827.namprd12.prod.outlook.com (2603:10b6:510:26b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 03:07:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 03:07:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org,
 willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com,
 usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 04/16] khugepaged: generalize
 alloc_charge_folio()
Date: Tue, 02 Dec 2025 22:07:34 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <9902A348-574A-41BB-8EBF-26CF728FAEA0@nvidia.com>
In-Reply-To: <20251201174627.23295-5-npache@redhat.com>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-5-npache@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: LV3P220CA0007.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::29) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8827:EE_
X-MS-Office365-Filtering-Correlation-Id: ffc21ecf-6fca-4b68-73c8-08de32191def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k/UiolhU8sGI7Dcw+TFdd8GrZ5ypH22HHZzpXARBntY6FvwvkMCMu2aKmMOK?=
 =?us-ascii?Q?Mq3/o1KFYxceb5Fr775BMEby5mfWeiv9qFExg2PFxJ6NMSt94SotZBzQBJuP?=
 =?us-ascii?Q?mC0CZqJjYBLdYMH0GjKbwC4v5xDqjIn5Xtqy7G27gIW8948DRnK6WNGYjRSF?=
 =?us-ascii?Q?GQoeX1zsQqEBwHWpu++AFMLw2eYCd7sxaUqiIAb8LVoHzLlkZMyqVSN2W6DH?=
 =?us-ascii?Q?Y14i4++HHf4D5cvWEbj/MK73HCPZ3q8vM6dr5okmkC3MjfduuKQ5dtp75bw8?=
 =?us-ascii?Q?dlepyBpLj7dg5xRkaxjxvf/59ItZHGtnbpHoWLGviCyuTv7g1oyqpWIuVnmf?=
 =?us-ascii?Q?L/U5PVEnFOlHPAXMAsWDGfcyhp2KCRD72AgU6ESVvI8mO1gV+kjN0rAqFX9s?=
 =?us-ascii?Q?ThvsgwL9REFk2uckLHrYLDZZn42fUC6+KsvSxxFckTrCkdE6FRsofGCKtWnB?=
 =?us-ascii?Q?Hdz3Gao5uS+JIgz59GD+0bLl2yU3GT3PI/WnpyNjbFoDI7DlBOwUF9KVdtv3?=
 =?us-ascii?Q?qWnuTN/pl42lLNjtDZALHqj06KiFyg74vZVuhCZk38nxupeXt213AauZ3xRm?=
 =?us-ascii?Q?lGt5Bp0z5nqPTDlzHnT/IKHghS/sb1w4jcG3jq0LFK8IUMcytMvhO5uFctzZ?=
 =?us-ascii?Q?5fWXm5V790K5jFpj9QiwvVwduCeQIj/pvr/7rLhcWFRJjO0RejvSDxDofnbD?=
 =?us-ascii?Q?LUfcXMPHDpcEA6DU2/xUOOEaNeOPUL7ohFsVr0ogTB8hO1+GRT5KEUJM1a9o?=
 =?us-ascii?Q?7rrhNSQmpWJd+znsMxzyrxO34lECGNx4UI+Iin3Wez3qqCI/njUruKZRbxVI?=
 =?us-ascii?Q?AcchozeWeqOJ06MsEAeyk/WEkGGSPBX75zh7Uh9xB1HCOgbPEZAWfLYdFPvK?=
 =?us-ascii?Q?KYBBOHy7KutTtIXEhidL3pteEBar9QvjSLy6oystMc1YfZL8MpOnL9sjlLdx?=
 =?us-ascii?Q?W0kDfYIJ/xUgyipsMctlaToSFAgglgMf3N3Y85l8yAcWXv4NEMWBkrmzqsDO?=
 =?us-ascii?Q?/KtlF0P4NNu+XzXkjz1miexvnB+jUv+aht5lGRL2FFfS/Q4KCcd5h/Ggaurq?=
 =?us-ascii?Q?kgzelD0SmELWGt7y4qR+IOtEZcofU53IObHgeJj5eipv4QqkgkS1aflVl6W4?=
 =?us-ascii?Q?tHX+q6SVh0bfDuiuKw2xz2t0UMHVhRxkoK04bFIh61X4tibsW8wQHibbCaAF?=
 =?us-ascii?Q?l32Ok1pDFOxqWBpFQNAzglktIkxSVGPKDfYFGWSsc3ChQj4Q5M1cMEn62xgt?=
 =?us-ascii?Q?hCILSXV0c99fcXOuQ8oEVIBH08x4O5VIGuXpQH1hzL0g8lQ3Fo5zzzhugMkh?=
 =?us-ascii?Q?2VRnPgeYeulwZcAk6auTAE8pibfMwIuvejpCGqvRciGSm4n7udaXtaCTcvH9?=
 =?us-ascii?Q?5K7QJYcf2vFF8KAAtKO3rUNl+lEpE1SUSL+iw5ngWPCNJeWQlgQmeCznM34f?=
 =?us-ascii?Q?iv+nutUr/FOXvCVeZ6YtkQ9tuNQloiRW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FQo+WY5GIOVFtQ/oUBgipHTG38d6FhIUjG8ENsmieNmIhE/1XChNQ80NM108?=
 =?us-ascii?Q?dVqax7fJpz3i6j1dpxE+m7rG6mliU/9IqeLoffMS/zT4sKNqG9AOJ/IiMujU?=
 =?us-ascii?Q?JiGX1fd8vHovq5x0AtYq+Is634JswMDKAzZGo9QHW6GE4iJCGDrgr7yMpPji?=
 =?us-ascii?Q?pXmHKMkLwFYfPhPSsIVty73SCY2KmzdKBs6wlN1t1L/K9lN4zCSiSZTLty1A?=
 =?us-ascii?Q?ifOwZks1KwxG4PxwdTGnmoxcJZ/orfruABmH69Pjv9BsCNSkLAvPPfT0SRzA?=
 =?us-ascii?Q?4IX9A3HhBD+ac11flzDTMnbEWn8dBwvoSrNTxsJRHfuiW4hVbqOFVGn5Do7U?=
 =?us-ascii?Q?YhvCnWdoIH4KurEAnnQMRdFMRSejSHigzLgcMLS0zY6iAtaakRlF4qxiGo2o?=
 =?us-ascii?Q?IGUc5iqJN73dPd2ACKHPKJ/vHY/7t9WMRmSWUHzHeL8NtnFUaW91bVQnlzR4?=
 =?us-ascii?Q?+ZH7ycG9kZBnfJy7QkA7MFv5apX28zDMGM4PjaFdqEvrWNo9TZSEsftyfPjf?=
 =?us-ascii?Q?8TOCIJrD44v5A0wfwbWYMIT+an0DJkofIXvUPHYwhUQnIvxH8GSzHC74IVit?=
 =?us-ascii?Q?/7zIXoxo6dQ/pykYXq7XYpUTY0Um4s+6YwAnHbOlkINkdImicwvxnehIc21J?=
 =?us-ascii?Q?dJJvskO/nx5QGdZN4R/LDdNbNM/tGL1KEegfo3Vj0ygTquhTn26TBEH5h7ff?=
 =?us-ascii?Q?mbT5Sw0tzjIC5ZhbduOhlNxh7+Dux1Yqme5zwezy4wbpCyrdgflX/jxftwvc?=
 =?us-ascii?Q?PbqubkxrRgOqd6S7u/t/YygHsmjDwbiTxccJTjsM/rwUJfMX299jUvKac6ad?=
 =?us-ascii?Q?OJAkv8YsOcNvjQeSQQSkXBlko7g+hPlTNHl/QQgj/LMV172ktetPASXv/qUp?=
 =?us-ascii?Q?GzhAPkseZHISXd9KbsFnwrfsyi2An+j4mXdzmeJeoaEI8o21wEHjXmlcc9nF?=
 =?us-ascii?Q?VXwLuZzS6HVxtQlOhRdZR201y9CUVTlYO8OABdGtf+CGAz+Jd+3QXv05uW4o?=
 =?us-ascii?Q?q+VOQmwLyWgHs1qI99nIuIm3iALQCs7ZXxyfbJZXjLzvh0XhQuhEwEtn1Oxk?=
 =?us-ascii?Q?deHIc+rkFiHbX821FqodgbhrDIzuGzzewW3LoPGPAFY8zMjTGDPTetOR53PB?=
 =?us-ascii?Q?alQtVbzJqvk7D6CN7yZ7UawG+GdrUAe3oeK4WONp5o9vveQiSwG9w8p9IkZc?=
 =?us-ascii?Q?9yd2jN8ovX9RkNHFsTnZagh9ARX8iCITPzyJtA+ylzsNmw+QPzcloAIJqqpA?=
 =?us-ascii?Q?8JzHESsgXvSfDvFSd0DpQIQroPjM23GQUjGSEnD6rPKtbAF4VEgDJ8Ijsf7p?=
 =?us-ascii?Q?+UR41qBEFMy9v5ULRo9K3jBOTRVjXdN6XJgVqrUbZm4YsSGkBHB/8pG5sID4?=
 =?us-ascii?Q?0XGnGOZPKim8FWvsxeHCSJcHcPvm5YF1RNEjbvKWi+S5TMEFZxrjeMt+Noz8?=
 =?us-ascii?Q?aOv/D622U+rmghVcsKejSyYo6oaUp7etHer3GN1c1BxQ+iDmLD4FLp8yM6Qj?=
 =?us-ascii?Q?Nx/Tcozo/LRrPNKuce7ftHxOXafBiKwpD1YJswWs1odEcbKrj2hQyTICpVyl?=
 =?us-ascii?Q?S3M5yM7zZivK7GlVVwSDY+0iRKfzDs1XcZAyQPTX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc21ecf-6fca-4b68-73c8-08de32191def
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 03:07:39.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLkDUE3JqBo41BHDKWG++KqdIH/dcBPSPPXNEgIGUP/8m1V3BuwQYkdUUPMrE1B1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8827
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34AC51C0014
X-Stat-Signature: q89s83nmzqkcfxs7qws491prydoy6hhf
X-Rspam-User: 
X-HE-Tag: 1764731263-219347
X-HE-Meta: U2FsdGVkX19phMrqqcuL0KEVp07gZhHWfrYqUQKVxEStMrjlHCvVO0D/wSaeAhdqYQlyJhtoeG7dFgzODIJVfhPvZB1M+ttrIR9/XbG5ajdtv59pzW0PoAhGxhb/kf6Ozc1o8bNkWibcFErDWV37HPe54nNA1ale+5f+5LdW8V3wILIL1ZtLcbWSCxCnipzl0iemPMP6xD2stHv2XVZR0WKBO8jH2nz+bXJJcbOxqVyDPuUSJFICcAnp/owKFi1G9PB8gBZYBrz/5JG8io+Jd3Z7yoNsQOA2DVmP5jnejpibR5ojFni8Bqs8bo5PkzbiANs6dRoUx75ZbRMmlVXP9bsrgzFuD/P+zzs6tkBC7XlrUYajwvsuLsFjNDhu2TWiEeGtOsI6HcWnBpHXeMSnoJvTHWPzzMK1G9VwxzZn/bMwfBu4Gv/4qiehDtzGtCw0JZHVF/JjI4ztjKttL6fhSNZFlJ47nwwhceeagOMai6tdKKQJ3TDtBVMT39gOOZFlbd0oWn/v1JfqXG6ka3D3/kcvsHd2Q6ZG7VdCCV3DTf2eWiKg+Cl7hZDqL1m9sOzz05sDG1gLg6gHAdggC/pxz2QTokTbFUhY97ULeBC/sxnIgo98l4dZEyxkYFrU9LhfuvA760LarPa0z8JGnqPIGwjikgQ5Daucaz6dxSGQjI53KrrD96TKi71WYXzeEq8a2mPIHREhEYEUfBP349oGbzieWJxb+KA9GvJvA2ffghS5HJG+3DSp/TaOFsc+Yh/Y+2ChW+p9HxxYMW0Mb5la6reVDHi0sA6iVjh3kaHvMVaGY9q0U0XNZuQ6uSSbuCUzToWqyEF4ywNGC7AjYVwQBbNkL6wpsgOFCurD4zeWoZV9nZlVg1TSEVzeAhdH4nrh2Jn5VyCJ6qLNQac5TyfTYI8YlPC/yKra5K8eCUAO+qLDFQsUxX1gzUemOFbr4SF8ptIFjzLTV6WIshlrRUk
 qvifwz75
 84KVdSowY7ROPXT/OqxcZ6OSq1X/MDuCFrlM85i6qUzwC+uysSZ6WpY/0f+aokkQSu9y+tsUWUMNqdHa13oEAs6hR8fvsWTS78GNaQZdTZDsgpJ/bKdudZzwJ3WgRwgcvWAfCdwWpd2kRegl1IYlyaPEGRjHQKLlvLlnX4MoxghT41Zf/ULf9lj/L/ihdn8Ozeg6JTIJMwjIDXXiO9YKf/CMsPYr7/h9lSaVqlmZI9rBxFzJdto35F+Sry3VY/MvypFX63UlbP/CAblkE6qxcmGN6L3hoqsWbdVjxY08Qf/HBX++TZ+cwF1MA0Wzpo1j1/cTcO//gH9rMlySCTUEoFF02uMe159NYaoSatKY71rqZALDVON323xXoSh2Lqxpy1Ly6ooENJn7nHbmmjgBDQ0VqaWth7l4xJD/ZOWcH/9msW0qSopypdq9U/eQQ1HXj5zYznzyumngJxoJAQ1PuBfcPRoqMYbB0/L6v3Qa8Cp9TMBQ78sXbKc1N30iZ2UqqvjSDAoIjO7HzvC58Rqzw3iNT8g0Zpk+AV+LoFdzNSkbBhidA0OTC80mGz2ve+fWN3O+5ZpkYsZTJiNqsi0IhgAuCMJ3kOBo/o8aBuncbxuNXtmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Dec 2025, at 12:46, Nico Pache wrote:

> From: Dev Jain <dev.jain@arm.com>
>
> Pass order to alloc_charge_folio() and update mTHP statistics.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  8 ++++++++
>  include/linux/huge_mm.h                    |  2 ++
>  mm/huge_memory.c                           |  4 ++++
>  mm/khugepaged.c                            | 17 +++++++++++------
>  4 files changed, 25 insertions(+), 6 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

