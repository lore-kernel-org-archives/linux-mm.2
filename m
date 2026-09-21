Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65716C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E955C6B00EB; Sun, 20 Sep 2026 22:28:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF7716B00EC; Sun, 20 Sep 2026 22:28:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C995E6B00ED; Sun, 20 Sep 2026 22:28:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C7C96B00EB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FE9CC0534
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:54 +0000 (UTC)
X-FDA: 85236186588.08.9C1DE75
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011018.outbound.protection.outlook.com [52.101.57.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id B38F440004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g7FAdaT5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g7FAdaT5;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957731;
	b=aOexTXclZVorbiILAcgVUqex+ChfFuRswgqBQ5gG92mSbZSRudWwH8HzElYn9eVMofmmoP
	yqDruYbd6vmuhgD2+fD+szfu5nYxTpoCADHZ9HSZJ2nRFuK4KIQ3uVWHb0pBbVZ2nBrf2v
	ijnVv3/UTKKi781sm7YDnhqE/cMWVCk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+PRy2ELreVExLdlnYTHzMwDmQue/RiuQNVZqx0e5VI=;
	b=semFKWqvcsO/fjqfvnlJEchqkd/flcU9mgu/QCxZWFME5BRa1OIwCD/sZ2lZylijIAEOdM
	cHjTvQWreOK2h7lJObhxPoFSyIOxWQt4sjN0YdDYW6bd7i1jGJkERCNMzglDrZOV7RF8/5
	C5PdjU5CcAp6oIslrDPXwpr7rQr+vh4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgofCVb0PvFahCLsgtc1JHB6quMCGHoUd94qhvKtu8xf0nAn228o11uV69RpMHbu+CdvdtlkCTvlRsGsCIkEy+Vhp6S6yCEJea/0H/7xfR9A98DBpgc9AHE3g+8FanYVhLqaj/cC4+UrUdEGDknSBOHNgu0MS72CZJ/3+o8Uv0Mv1+pxhe6mLmeS+6PTABmANCmwBvJR0U0dMxVOcR52PqY4UIrN6axuyRs/yFVj1ofYmjUfanP2lZY3v5vC1/wnmWpDWInR0U+TZLHrcPFQyg35/MKim2azK1UC891g7Y8/xUUZuJd9k3YSofoU5RbPRbEvmN39nReNQbf6oRLq6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y+PRy2ELreVExLdlnYTHzMwDmQue/RiuQNVZqx0e5VI=;
 b=T89Fi8Q9lN7ISP61n1fpa4vDuBa+1hSnRPYbajwFTuj3jYqXEf1UN/qsfjzMekALSHcEE7OtfQH93jf+9yI/fjsTG36VC3q9Jwjui2JRnXvE/OPysRqCg6pr7B6W2tWBLBsr/p/BuE19eWNT0MheyVtdD7/vSrAaVvSiYZqUF7ghOG0YpkOTGEU9bYqtj/Nt669pDP4GsgwBS8dYKjOAAEmawbUIXka2JeIiphPSnS9Ma4i/xFXc0Dta9MkssurqvPYktZgDzX3WZ4kwiJNOzhHE0tNpK3wWysWrCFq8VqR5wA994+dhsz3879+cd/vP8+N3JJ09U6BLP9klS6vibA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y+PRy2ELreVExLdlnYTHzMwDmQue/RiuQNVZqx0e5VI=;
 b=g7FAdaT56OUbM5c6ZpQKWg122janu7lFjC7Id5bWQ24is7Ec5TLdcJkAV9wsfjkXQsroopAq2tDsSKrVc2fq/w7iLQ48/wDBLZRU39CT6fYk9ChOzq//Vd70XjGA6KoD37nlQuaKKa4DR/7MvWzNDfGw7ZePjTiwmG2UpY+6bTMa+C4DeMO2LCwYppdbqsGPCpPdijzaHStkn/JsRVggpz0YOg3GASC6egpjTr28AcILAG9F4auuCSzNplsK27VaEP9hc0JksuCzcNq298ZCkfmbAy2dmxdAIGEYFGg9kTGzJR1kijDM5gkhXdmrIkyn9+2dXu+vQfU209zwK6ArQA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6097.namprd12.prod.outlook.com (2603:10b6:a03:488::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Mon, 21 Sep
 2026 02:28:45 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:45 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:13 -0400
Subject: [PATCH v5 17/17] mm/page-flags: remove PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-17-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBP288CA0008.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:6a::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: e1bac2e7-131e-4073-1eaa-08df17880f3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|921020|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KLVN453UEi4zYmT70aboqVE10m7/2ztmB6xdO7KrhY9X/LcboJknybU7oxqn6ZPVFqxgd5pVsUOTU4nPvrlOe1i1ykWSzWDeSPRKiE3z3fztLvysE9u3eHbFldOFzWdm1YNBixSviDL/XE6vhy7MkvPNRMNomwEVLFPTFZx3dnlg7j7koEZnZtGQKBw9232utgjNwI3LfFlIAubuB2KLFf1AhvDRp+pC4PQ0k+h9qxklGKd9kgt6r+wWJ+0ECdBMCdsbZb7YYE4anDUbT/kV0n+LrFEitGx5MVhCBSlRx0Ha/2LmXbEQ4bb91bs2WWQekzvkhAe7v5+/076hRCiPEwhJ694bi/1PcsWS83Ynw55l2VyThfRe4n4X6ADSiELx0fcY13Qko2CSZwqCOaEFXuleETuQJjWyLXlO2QjBSFFmTTy9ogM2Sra82TquQmmWYqn2msutFwdxZvyq1N8P66Gsnkgd6Bw00jixNCVWZPxcy1Y8svJ7szOubjDpwIWk5jCfqxr/oIz7yZ8HsEDihEmiC9cpCv+bPpY1vAhqKz8nlbZ3XxIQERkO5d49T6OhdLjy2I8Yh56tr4vLKgSXv8aSW9YWPbPmAZPNFjvyegTo7zETmlpMZoZAo9pQX2fsVqcjNbttaQ+tmcMtZwL+QrE20OHYsV466Sp3+eN4KpSHv0FOCKxTrPGU2F99IY4A7OaDGl+SVsM+ER6WBybVjw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTFQQW5LOW5XWkk3N3NPYnphWFRML0xNaW5uNHVZM3N0WEo3dzhpNHM3RWZY?=
 =?utf-8?B?c3RSY0xaVUUzaExJUzhxdlFkOHlLYzBWSUVhdEZlNU85c3FmcCtUcVJUTXdW?=
 =?utf-8?B?WjVzS2lxSEdweHNTaDhUY240WTBadVBYRm4wdDlhUSs1MHpXZzJxdHRPVW81?=
 =?utf-8?B?WGF5dkRlSGZMV3I5SG5nVVRLRGtNWjRMKzFLZUFoZGN5dEZFMkJNMmNNVG4v?=
 =?utf-8?B?KzZLM3NQeVBzL1JWbUlyY0ZwZHJQemo3OE1rUE1CeU1SaTc2cWJabWZmdUFm?=
 =?utf-8?B?MW5UNFFMWWlwYklWRHNCNWRzY3loNDJzL00xeEt4dmJGT2V4UUZGL1VUK3Vi?=
 =?utf-8?B?dlFaMDI1R3B5UXkwMSs2elBja3ptZ05LUHRpTmRuQ3B5ZFhxU25WQWRrYnJ0?=
 =?utf-8?B?NFlMUjh1RE9NWnJjZ3cyZ3RCZUVLSlZuRHFJYngwSlNRSWhFcEF4UCtHTDhl?=
 =?utf-8?B?WmxkY0REb25rVE5GbmY4MzM0SEJVRCtjTCs3V25VZTMxU0p0WGNsVzZvaGda?=
 =?utf-8?B?T3l0N282WlZTbUc1dVIzOGhSU2RHdjNpSmtQZUpBcGw3TXdORXd4SE9UOU9I?=
 =?utf-8?B?aEN1Y25BdXJhMVRuUEkzeU5wMExabStBSEJHNFhjLzJraVYxZmZnd0dpQS85?=
 =?utf-8?B?R3o0Ri9kUTN0YzZtWW5ZaUEvWHVLQTZzMnFzb0kvTUlDK1FqTHR6bmdNdjhi?=
 =?utf-8?B?TDZDcjRXdzJPQzFIbUMzb0d2emhWS3NYY3dEalQxRFIydTRMMkdkUFdRL3Bp?=
 =?utf-8?B?d3BIZ25Ucmg4VHhzOXRYcVpRdFFTbkVTOFgzZ1ByTmdLVDIzUGVHVUk2SUVT?=
 =?utf-8?B?QVcxY01FWDlIQzZCTUpoL05uQTJ0SkN5QXR5UDY3M1FUNlhuOVVDZW42T01k?=
 =?utf-8?B?WVpXanR3bCsyMTRkTlZ0Q2JSYTU4Wmw0MStnTkwvVW5XdldaQkRuZ1FCajFW?=
 =?utf-8?B?cjEwQnlCOGQzVjJLS0FDT0xtVkc1UGszeGdvZDVmUUx0UXp0QnpmSG5IVWtz?=
 =?utf-8?B?UVpnQ1lRcC9PTEFaSEZwMEF1dzRMTFdBVXN3MDduTWZFV2FIWEZlQzlUYjRG?=
 =?utf-8?B?N1VrNW5ZdS9qMWZYUW9jNWtFYVFvTmphNWpKQUg2SVJwVTVtOGFMbjVDWEN1?=
 =?utf-8?B?SHpKY2hMNlJnOTV0dTNVVExTVjRlWVVoVlJ1bXNqdEVqdUFCM0VlV2xxTXdW?=
 =?utf-8?B?bW1kak13c05Mc0tCcG5hamVUU2U2VDVoNjZzZmFtaDZlZSt6WnVsemFXSmRh?=
 =?utf-8?B?ejRCYnJpak9KZXZWWEdHcnNFY3Jla0hrdnY1Y1BiUDMrUFRjNGpWdnlZeUFD?=
 =?utf-8?B?RitYUlFFQUxtR1NNQ3dFdkJ3VmNWNWtPaW5FUlV1TDh0Um5JWFNYc0RVbHJu?=
 =?utf-8?B?ZUt3UE5DODhDMW90YzdINlR1ZzRSMzFESEM2WFZ5ZG1TUXFGaVY1RkdGZTJZ?=
 =?utf-8?B?RmxIdERqaWhyMTFFRDE3TEx5bjZpT2lxbUxEM2thVm9lcG9WTTlCT0V5K0Nj?=
 =?utf-8?B?dTNrai91UEJMMmxCOFQ1UWlod05HcDd3b0h3SjIremlVNHhvVkxmTjR2OFNi?=
 =?utf-8?B?Y3IreURVc3NUaTZYSmlVUzQrcm5YVENGNE0rTGQyZTg1cXlxTjNGUHcxTnlT?=
 =?utf-8?B?S290Rkx3QU1LRWIzM2xQelFrbEZXK002RnhBaDFyZ2pCWnJWVHg5SnA3am9V?=
 =?utf-8?B?SDFjd2FDaFd3LzVWeFJvUmlEQzBRYVBnZitaVmR5SU43N0dUd0NnR0lCbFFw?=
 =?utf-8?B?NW82UUIwdjJEMDFDU0pEekpQb1l0Y3RIRnBxZ2J6OGRVbi82VXp2KzhXM1JH?=
 =?utf-8?B?bnhxUlpNZ1Jrek9GblpOVHMyd0YyZlBUeER2bTFHN2phVDN6bm51QjI0VUFl?=
 =?utf-8?B?NXVRSHhCZGNFMHhBRmh1cDlvNHNWYnQ1OTdFZElsOTVkMi9iRzkyemFxKzdy?=
 =?utf-8?B?TitZWWx6bkdoOHFadHpjZ2lhQUE3LzdsUUNPL1BTbGFEY1FCUnEwYnFkaTNV?=
 =?utf-8?B?R09CeE1Ma3BuMFE5Zm85U0JvVExBRndXWk5qYXkrVlExVTV5Qmdtb3dTRU1p?=
 =?utf-8?B?RTllakl1ZDQzUDVNNFQrdXpSN1czY0E3ZEN2N3NPUkY4bloyK2o0N1dGaXhC?=
 =?utf-8?B?bmVEYkxNd1JKVENkeGhHNVNXM1QrdjF4OHZVZDd2TzBDTXdZVG1NNlByYXRD?=
 =?utf-8?B?dVBpc01pOENpOGFIMWdaMFVndzB5S0lTREVUR0h3dFBPWFJYTEtBVWtOcWc4?=
 =?utf-8?B?SS9LUkljeTc4ZjIzbW8zbXZ0ZGxSTVFWZk4zODNWZTJ5aTBlVE5Pc2dqTEEx?=
 =?utf-8?Q?2pNnGfYsD2UnDqdZ+9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1bac2e7-131e-4073-1eaa-08df17880f3a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:44.9362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uzum3gihbtMFRgvs/Kyl1A5vPdpe0oXbWtSxFYS+jj+5aN7/t8pMoyHRGV81/1U/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6097
X-Rspam-User: 
X-Rspamd-Queue-Id: B38F440004
X-Stat-Signature: f11x4h7hijcqamqe9cweiwr9qoqdp64y
X-Rspamd-Server: rspam01
X-HE-Tag: 1789957731-898862
X-HE-Meta: U2FsdGVkX1/PLyrE4YKxy8ko/kDXJ0PWyb61ONhssF5jteVLMlUYAeUzTt88SJoaRuf7JlWCXuj086DRUIuSu7eUJYgv+7k5KVKu/b8eBFk5/RBBGwC+R7jctTawkBFSTj764G6NRjD582J0WmQXEp+JyAyECgB1wgUPaTgo/9alYPhfEbVGSy1O3eTiWbc05J+JmItyoDIWt0YmKulXKFJzlVBQpG/UIwIB9kDV1CwaGJ53Km3o2s1Uv+W9XRG1y/HQJcLn9p3srDky1PV1HBT9JB7HxQ3G3M81fCWjK0PDjfY2HyEbd/eLuPGAuRno9nLvTAYG2AEe0ITCkkdeEEZZOhLG0aJ/4EScEmYjFujn6CiMucS11Or/6uG/bJPyoqt4Wy29wi74dsE8QTvTcedG1BFCVcJMK+8WaiEy8qvvbpeQwJwrykX/20d4wU5aZsv2YAxti/gQ9+uTU1LQ99Q/JifKUyNPnpum5Y9pR8krie44l7WDl0SrZAGqhlLbiHHNUJ1XgVdobtyo3VzIZhHUB2Na7u/+rCW/73XZY5jPyCuktAEKatIEMRW8IQnwpU+wOraiF7fMOKSwEVAuM5MYHDfVNEQ42uy1xTinKdVFhPF3LJFMpcnrVc9Xl9UFsP+ub3mTR70nfAozziE0oHGqDaoPAdJFPwuZtTb/oT2GccqPPtu7PWmWTsffrNIE6Q1vunZuTtS6vj/cTdRt59wg7KHF90hmsuUkEz8/o6hv6eJ4FBnGBK2gikOHgWB55MKXozb9N+L4DM3UCN5Z8B1EU3PTdK7ujhU7v53lfmj3DJ9ZWRNPR9O/0NXAdvtysEXhU0UVCEOsqp+5m4c9X60vb076c/VrjT8bA1NP6rY7OUbXVKWQ+IoZUkbbXmSsx3bzyyascGnfKE6dfXsNURaq8o3EUJMe038Z/sRBDTOuVF1THqg8bP/juhNjqyorpLg0J5KiWVtKXtLiuKa
 8qqYP6z2
 hzJFnFjdZQK1kHAumqXfXgEiBmXro8ntewa+Ixik6Eo8LpVjhfrQ3JCeqHGWy7s4UOPvExdRydZqHcBNAUxYHDxv7Mx6v9ptoi3Vp7uHCuiBFdoXOiWvCEHyzq2X1rkGhBtKTCJtlpH80ASJ0H6mR0P090Bj1dueEuggHVYGfIx+FswpY4Ja6bdJDKWpeHAlwVMvlGkfSlKw4GfYhM/O4cm2ZXDEWMuIDDRPPcmdQj2udAqGoJJtKGyJUqZ373ppHAoUvBaNQuWVToAkeLRbKmS1bhPoHTB9TK35OULv/2z1QlyCAZP+C2/XJO8odEAFr2mbjmtIsDRE/Q6k90/PperAEzmPEgNrOdE5yDM33uXdmkbGdjKX2tODMI4o2T1y1NmBle77jtXE45t50NedIXqLs49lR8grZqbDqvxM3uIq3RK0NDxn8r7DudItVNQJFEKNDTKia4962d8ET9G+O/wigw/5l6OGIwdbrnVGLgZn+Ej1KPCaqnx/aEDttTONoa2qAn8fVEf8ceazAS0KWvpDwmSZPCML9NUwuxKltCYFP8f0fIHC/YUAPxoY3q85XPyEYBtTmt7KHEycPXaKVKTWlun/Mn5FZz/IeD7jZAC6mGOirmZ5YiwbFqCtJl3QxEZOoU4Xiwojv0fvoa2B7mkp7f38rsTGOD16hBAXwSUOWwzQfU7lZ/ocVUH+jALKe4PkQ25MoKEXI/jq//gQCSSSx08k0eqlVTcG6gdq9vuirfSXULoZJhexNVGnHoBeQL6q1887xjmR9JSKbRE+7m+qoPtsosuHGRZZeYbqYyiNHANqKCYWYrARK7WPL3HZtnO2ptlN/D1DcLJWkEuCtkrSavWtEtNtw13pJOtaajE/HLgx3/WZMOk0NrpDYLexoWL5myJcVa0ae7uzJHAqjZiQMIaBB7dc7LFSn+Fi3WteDJTzbx54Skst0QFMQLbtk7uMM5O4g4ANHWEZLFSjM1/kfjzie
 VyEw8ZUi
 Ft3T9u4TX575ape0aiLqRWzNwkf2rOoL2vi9Td3cnpGkQo9/BNYP4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio->private != NULL indicates a folio carries private data, replacing
PG_private. All PG_private users are converted. Remove PG_private and
reserve the space as PG_folio for future use. Unused PG_private functions
are removed too.

Assisted-by: LLM
To: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dave Young <ruirui.yang@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: kexec@lists.infradead.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 include/linux/page-flags.h     | 18 +-----------------
 include/trace/events/mmflags.h |  2 +-
 kernel/vmcore_info.c           |  1 -
 3 files changed, 2 insertions(+), 19 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 6d839f50bdcb7..b0ddc652e76cc 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -44,10 +44,6 @@
  * Consequently, PG_reserved for a page mapped into user space can indicate
  * the zero page, the vDSO, MMIO pages or device memory.
  *
- * The PG_private bitflag is set on pagecache pages if they contain filesystem
- * specific data (which is normally at page->private). It can be used by
- * private allocations for its own usage.
- *
  * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
  * and cleared when writeback _starts_ or when read _completes_. PG_writeback
  * is set before writeback starts and cleared when it finishes.
@@ -105,7 +101,7 @@ enum pageflags {
 	PG_owner_2,		/* Owner use. If pagecache, fs may use */
 	PG_arch_1,
 	PG_reserved,
-	PG_private,		/* If pagecache, has fs-private data */
+	PG_folio,		/* Do not use: reserved for folio identification */
 	PG_private_2,		/* If pagecache, has fs aux data */
 	PG_reclaim,		/* To be reclaimed asap */
 	PG_swapbacked,		/* Page is backed by RAM/swap */
@@ -588,18 +584,6 @@ static __always_inline bool folio_test_private(const struct folio *folio)
 	return data_race(folio->private);
 }
 
-static __always_inline int PagePrivate(const struct page *page)
-{
-	/* See folio_test_private() for data_race() use */
-	return !!data_race(page->private);
-}
-
-/* no-ops during transition */
-static __always_inline void folio_set_private(struct folio *folio) { }
-static __always_inline void folio_clear_private(struct folio *folio) { }
-static __always_inline void SetPagePrivate(struct page *page) { }
-static __always_inline void ClearPagePrivate(struct page *page) { }
-
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index ef9aa388b84f7..3c153b3ad8450 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 	DEF_PAGEFLAG_NAME(owner_2),					\
 	DEF_PAGEFLAG_NAME(arch_1),					\
 	DEF_PAGEFLAG_NAME(reserved),					\
-	DEF_PAGEFLAG_NAME(private),					\
+	DEF_PAGEFLAG_NAME(folio),					\
 	DEF_PAGEFLAG_NAME(private_2),					\
 	DEF_PAGEFLAG_NAME(writeback),					\
 	DEF_PAGEFLAG_NAME(head),					\
diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
index 8614430ca212a..5a417f8a922ab 100644
--- a/kernel/vmcore_info.c
+++ b/kernel/vmcore_info.c
@@ -216,7 +216,6 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
 	VMCOREINFO_NUMBER(NR_FREE_PAGES);
 	VMCOREINFO_NUMBER(PG_lru);
-	VMCOREINFO_NUMBER(PG_private);
 	VMCOREINFO_NUMBER(PG_swapcache);
 	VMCOREINFO_NUMBER(PG_swapbacked);
 #define PAGE_SLAB_MAPCOUNT_VALUE	(PGTY_slab << 24)

-- 
2.53.0


