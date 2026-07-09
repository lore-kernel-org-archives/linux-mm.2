Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A3BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 16:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704956B0088; Thu,  9 Jul 2026 12:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5EA6B008A; Thu,  9 Jul 2026 12:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580566B008C; Thu,  9 Jul 2026 12:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27F436B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:10:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC5A9140205
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:10:47 +0000 (UTC)
X-FDA: 84969726534.02.F4ECB7B
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0ACB180017
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:10:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L//3hA/+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783613445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEz0byVnTDVKIHRVRWwUq5zzqJohCCMBroXqpjwveZk=;
	b=sLsXan71t3x13062Eue6HYwJ2kyhMG9k0Itts0d9Yym+l4Yk+os95nzrt3412Te/eILCcM
	iFqqTxcwLyyTSiNJLb1bDDn92jzPEM2k7DCai9GYwE37JQs/pUTjLQh2J9aj4tED/lxhCE
	BsgxBv/j/jyaaFnVhpCC+2LTdorNsiw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L//3hA/+";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783613445;
	b=VlYZaBEh620noeKrIG816xIZOkj/YjChf/xjaSKyxGsNkraPH50rJtoae5koMHz/IOu6dC
	MjsWSnexzjDqR/ByEIAAtmAPf2XARNGJg6AFPgV3OmAzsKXQQMcolZFw916x3IYDH8EHdh
	L+I4GtmCQ95ZdwpjLPLEOHYoxLK8m2M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v47XrwGNu+/aeokZoZf976oMjOSIo/AdPmrQJpcwQ+GZrqtpeIehQ50pm+2yELtIdFm7sB2xBqMtVHXc+Awt3IoOKtdBIPLyTLtLs8s1s8frwFqBd4h3oggPg/KBz/PY9dJdr46hpWoHgqhY1qUmsEg93/HX0ZXx5dFnFwk1UNc47l9YEWPdTg4alD+MPL+l4/yhE59bFeXa5FvWNKqrEz4E9oniq+fE961a2dIi+XWNFoWsgBlaNyjq6ZEqBhAllo5yvDY8tSWk/pxjfODcK/IWOUqAsy9R6XsvhDdKqayW6wAgatA0J8qqiaHcPbTpQScjH1FnrJ/WLOo1LILIgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEz0byVnTDVKIHRVRWwUq5zzqJohCCMBroXqpjwveZk=;
 b=wp7UfJbR8nde+xS9WhMhZbh5Nu3DcEwXxQ9a9J0x6guF7F9nF2UPlD3JjCy0896Xo62/b9VFL0PAUdGlcxRvhF+qcDGgtr8egiwW/HIx0R81uba3gcyGk8Zy2rWJRMv2JspZ8IrSVJxQrPtf6qTbAOKc1hqbAruZrfigY2xKRGjIujLaBU99uGMSze7RYQ6lcYlyBS68ht/NGTR7qwwnojvGkhUJ2XxvZSioC65GEAIGzLNdWaubKYSDbptEKlYwc0hl5ADn8/LWVlv68FMhHSKfEx7XdUbp5FOPMiaIX0a9cfBMN2IJQizlmPH/jSj/onEf3qfsSw/s4WJk3NVdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEz0byVnTDVKIHRVRWwUq5zzqJohCCMBroXqpjwveZk=;
 b=L//3hA/+gdEAGxBrQSSLmnpLU+ZGq+G3rKFG7O5LN2vy2BqJAx8tA4rndLbuBjKt04RpwnxmZZ//z4oxR3UCp0cD3UHIooNWwoeXIKmhdn4DJCGbnzeowESv1FpjHv8CJdqJcerdmbxXYEEriwwGkVW5ysYOg3lCuxRe7hJNrOxjEZq92BM2qGWTAaejXELB6oz38X1j2ox05CRCkFQR0VGzHLBTZ+X2w/6vALVZg3DKCVnafZIeu1HmLgaK6eypNaKio1sfWCMg2jaKdD1yLD84p9/WCCrsLTcgByt6cWYO7jBk6NxlejMONBLP+g36E3LMgDSpHEB4iMYNwHC2Qw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6886.namprd12.prod.outlook.com (2603:10b6:806:262::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 16:10:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 16:10:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wandun <chenwandun1@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, vbabka@kernel.org, david@kernel.org,
 rostedt@goodmis.org, mhiramat@kernel.org, Alexander.Krabler@kuka.com,
 hughd@google.com, fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, riel@surriel.com,
 liam@infradead.org, harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 pfalcato@suse.de
Subject: Re: [PATCH v2 1/4] mm/migrate: do not migrate folios mapped into
 VM_LOCKED VMAs under compaction
Date: Thu, 09 Jul 2026 12:10:33 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6A08B6C8-E94C-4690-A29E-B9A0DAFE19EF@nvidia.com>
In-Reply-To: <c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-2-chenwandun1@gmail.com> <akz7ythMxfIZeT0d@lucifer>
 <c372e68f-2bfc-45b6-a431-01bf55717247@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a88e174-c265-43db-d824-08deddd49c2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|56012099006|4143699003|5023799004|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xhDqD7q/Xv1VjlQAFlcfXUFfr3m3lrEkTGITUC9CBd24w6XkuF/+o8SjtKmIfiS0bchI1r3k+YEgaQNTP9QMmAJRaidCjxnFlbK4HQaXqYsbMi8s0CTDDn+iHVgvnGzlmaWRR/0zdA+RFLfELg5wbJrmU/aqkYOHS6TMZVOP5oYXAKVbjrIdvMJwogx74iZkhUSg3Vd9QtcH7ggZMj9iWPIipBnOj/At5ol08qg4nhugroRYV9H+6qoUGDJseCyMA9c/Y5wIsXCuGJZ044JjEVqJq0650DM3N/08Bk+rq7LwsNFVjrzNmCzy3EAA4sl5NouD8nq32v1oyeze058gGPCDqKj7jCt2HUAbQHJbSlxuwU8ysPt+puMCNXgNN4PaP2r35EAeLn8jEYfkmywwHSbnELdsDAHy1LHNAQNTb/TC78z60alrro2sRDSkaKF0VgmQqjLDycHJmIJuzIC5K/2S98OpkWceGVTD2bkxCFN4WvxYFc+Typt7++sGrsHhrUE7vxzcpn2/yNPopr0KNOIL/j7yATpZlALHZV1Dut+pU/QM0Vmv6/XYPE8WWcV8Gkb3VfHV/ctu2cLppULAICfW3NT8R6DF5qlzgsnvkHY1igSWfRnMBdQtUuUz3iy18CzNUo44Juf+RzaDy0sEeI55MuS6Dy3v3dycWiepT48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(56012099006)(4143699003)(5023799004)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FlRcC4cU+YneCUO9BF7FR/BuQ0hibb6J6ogwX19EJZIYVqJqMejA+wLV70XB?=
 =?us-ascii?Q?crat7a1FJNhIHKfi9akLYQRSVVQfB0cnE21lkGiqoBiyl2AXYV0+1ugfLvFM?=
 =?us-ascii?Q?psWooYGS4IUnz7xbCJ+RNGKcIRvr+Rn2QdC8AlgBzq47UEy4qCsdz3Au3Ydn?=
 =?us-ascii?Q?DRVrUiYj4v+uhZKKGM2uE2kr51ZDzy4R8bqa53L64Pth3F44ABxO3GpkGNXf?=
 =?us-ascii?Q?m/DPotUM88G7YY+byrCePh7fzMeCgMGLYdCjyzJgn2HMBgLD69FrNfxw/xU8?=
 =?us-ascii?Q?1lQMBKXknNisTtqthkQsEAt5e8ofkb/xrk3VMPm382Gc7ae3y0T2su/Rc/16?=
 =?us-ascii?Q?I7BqpBmbueqwArfxgt9cJNVKSxhexLeWBEpCQ7LrSG1P7Jis655D2sFNJ5Uu?=
 =?us-ascii?Q?FrxMqNwpHtElNkvcDszylri0acGgiifep122Pw6OJgt+qEd15N7CiSMaTGsi?=
 =?us-ascii?Q?buw+6FGCx5tZLDFLrmgPzV7YQBHFXRMOVjeN5jyuZk6ZrEjAf7yjW6nEQLt8?=
 =?us-ascii?Q?OWKzFK1DmyDjBis3HmdR9gGl17+nYLmPWRFiFY0s3xfDJNrujqYKdOu6mKlM?=
 =?us-ascii?Q?brFFNBHmoMT2/uAiM6QnYkota3SCnJCk31i6s+Wfu1oe3z00gsPkrQUXyXBZ?=
 =?us-ascii?Q?z3JMHrdf4AojLNmtCY1KUCwIJyv4sDKJyMHgeb67oxYoOt70b8pAYGTOgxCa?=
 =?us-ascii?Q?+gC9pLLqtHFkS+tQ8NjFnhPFp8xCNw4hems3VldsfH4vopXYYnwXNacPt0os?=
 =?us-ascii?Q?LgUBaCY1b/H2JV6dyp/jAJC6vEDLnE/44dFExPZg7BH1AAXw8uNno9GF+RHD?=
 =?us-ascii?Q?G/skW/lHmhWp/Fr5LoSJWe7WT7ddc8bVtLdL8UaBb5nXOuw7oSQR2rvhbGRL?=
 =?us-ascii?Q?RZaH6WjuRs7K2YtxWJ4+iLvfclXO8prAIWzLJCE9QzRsXmx8+I4UHjWB7n1n?=
 =?us-ascii?Q?F7Wq3agCVa/HN3YBj8JoHdXMN8bYEXb8arYiOcZkg+d/8HeLw7BTKEtVUvI+?=
 =?us-ascii?Q?WUpTuMSgJ6UdHtXh+r3EQ1iz+rZ/Vfet/xF7x5vT4P56O3Xv8hOrEPVZdCi8?=
 =?us-ascii?Q?ShRzsvyjxqVjmlpKrPUKk7eKkl/FYCO6O0G/oMRHIRKPUPXXiAuB5H3g04eT?=
 =?us-ascii?Q?DbP38cgVqkTMzwmPppsO7tQdhh6qxwi8vzMhMZH/Xogipo5mSmy79awdBiSs?=
 =?us-ascii?Q?dDaeqRj8Vujge1ysWIrP7e5OWap7nJE4GsKl2dH1BRuH3vmCQ0063uCEefqj?=
 =?us-ascii?Q?ERgmvZKymz0GoKG7/XISSSWOal9ldekt/tZiflIw05J2wrZ++0dPuVB48/ou?=
 =?us-ascii?Q?9kI5da4D4wEqFTn9GHs7K0j037FljrzNpAw0Tg3bIBYbHs9lYrDXNjnuYsu7?=
 =?us-ascii?Q?Vhb7qBE+Suz3XtfYD1uI+bBKsnw7x8o3Q1aURBmh7h5NFu/ccAEdDRbFAUty?=
 =?us-ascii?Q?KFK00Wt8RN0TmGzneRx2JWWcd9avDw0RP/CmKHzc77z6/1qwg3nPNUVh9iXh?=
 =?us-ascii?Q?ULihkvxoAceYKWuScSewBK2GtqsIVNwTRKqTpPEBAMjVM4FjYqvEqWaEn837?=
 =?us-ascii?Q?ARMdSK0l8SD6JFf4Qpq2s5UvCkQqyOf+jQfCAFEe7zkmmggz4Dt9Dt8K9Lrx?=
 =?us-ascii?Q?KN0LYKNvLq7WTG/pTofaLdTRhCXYxL7N7PnJJpRTD7g18W2K2DFlC/v6hFqA?=
 =?us-ascii?Q?xSCac0ZBIlnkyQISbKEyXcSW3iXdg6g58VcSr+g63a7KBdmD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a88e174-c265-43db-d824-08deddd49c2a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 16:10:35.8066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSj2KQ278NIixYjXeyEhMQKzdjq5PDKX/UF8hRvDZncHuHZD53JxbIdgXdyqTCYL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6886
X-Rspamd-Queue-Id: D0ACB180017
X-Stat-Signature: 54ja999rm4d6w995tt4xe5ezh8y59bd9
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783613444-340033
X-HE-Meta: U2FsdGVkX19c8T/q4wECHr4B418RPHHn6c/LxTUyKRUdSJ2I0NNNc9eAsGwB3f4yyuoVj9yWUpoqIRsKTj6Ju/pE4rGyyTsFIWdKJ3ymkbbKl8YpYjnVHcgc/N6J5ozlxIczjoh9V1zeJYArfP6OmqbWRu/WI1YI1TtfOgse0IfMn0fS5VJc0tjV3E+Hpbk22hvLK0BZhtu6qK6m5XHi+CqO8zuR15vLLhzW5R3rqGMM8nCX0W2CcI9sfXePspvTw0iv1Vj0wJPZDAQVFX6BStv8GftTlc+X4i3BCU12a6GpyyhfKfOr64Iyp4dsAieq/sp34fQtfHfbIuBEiSPo2e0hdQbOsx8msk8yIPQwP+qmS+aRarz6oht5bZR4pK13mGUpGnRXqg8PMRdVMaXtO81YsQbJbtkRQCY+dqdUH4XO5qljnkEi6A3cuW1IV6m4OiWsdnSPxpVY06Zw2dSld7v32eu9kuVBWKulMJH1QGssBfcak1LhI1StaxbJnvLDxbTlsh4CgCZSIQMehV9qdYnDhu+3jT51Pha+Inn3KGYLI0XeHf5vliBKLbLwMZZV5oNJpJE4tXGTSPshptutPsaVwOvqVWEDO1fy1D1vFbDoczP2WXhq8w7Dyu6x1DgaKdZntS/JZPYeGcDWEzNc1UZ0TvgRjmbM4qwzJ72KDAJnGYWdSl85t+f7pfsYluwMtICTHyknvAf9eHlu1y1IGE46znGzom72v5SkNB/ryRz8+JX20bSMQGEmcvSbw46P7ZCyk9IjPFRisUxIWuir1odY3mrC1cVXcDWbHDrdPEXGCTm2pA2eRaqn9pPszSVEHvKvoOJbog50d4iS2MOf05Ho/zibFz5UNsxUP3CNku6vTWrgXn0EQQZKrrek88g4ptbFVKKeQQJJtzTSX2YaNr+ukIQnPuCunlXdKwQouN0M8oB0SIQUDFV6tvp3rwqq7utwULrTuJMDtH3ZwcK
 7OdyG8og
 +frNcJWHi+qQRw52WfbvU/XEi8Gf0o4Z/HJcQ2scwvyxyRzB6qtH5ZPin6hMFRiVWr7c15a4Bp9IU2p2PN8FZ3KfimKEOYOK2ChcH9RPDpnuPEzhQMXICMIovwZcJTjEcrTxCJC43ZgQCpvtuDOzgVaowmk88SacwA1C5SagJ9+FYqedD1AgY9qlPBe0/4/fm5LeNgMRYDlakM8ydvLdU6Jm88ei+sSyB44lrusWZou73Gsj6Eweufw3zcMhaBNh08JuHqxfkbX8J+EtL8VIA+YPKG0twQJeVzE/E7uVvNIiLtHwyPofGgWTeMwxLTQrEetDP9jbfyh0kV0hcvZv5QQBLNo9mCaM2mqFWdu/rlU8mLtz4vacKak6+1i2CJgM8KxEOkOQDKpT01ZsJ3OHiW6wxCE0ZEtBKOWT1jLHWFKmRedjBW0Ea/J5ytUglFxIUklm+C8pQpZsbQYv29sbfCQ1/fxyskjCLtIHrcXiDoHbEqnxVkC0ZWJYpx3BZtxVS96k7W0NtSRsKpD9o7i3jo4YSLrsSFcrgHAm5Q0hKTed92XURflAv1oREZJKZ2u0HHlrEw0t0LJsij5XA1DIlQm3CMSBn78sdx3YqszQn/ihJgOfvbSgpBzsby0D21bmOcW99atIbUmkSWJzM2BlT4dP6bgNAhGo/HM/gAR2X6Tv4uLrfFttTtLhkng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jul 2026, at 23:31, Wandun wrote:

> On 7/7/26 21:44, Lorenzo Stoakes wrote:
>> (Being really nitty, your subject line is too long)
>>
>> Please don't reference legacy VMA flags for newer patches 'do not migr=
ate
>> folios mapped into mlocked VMAs...' works just as well.
> Got it.
>>
>> On Tue, Jul 07, 2026 at 08:59:22PM +0800, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> When compact_unevictable_allowed=3D0, unevictable pages should not be=

>>> migrated. However, mlock_folio_batch in the mlock[all] syscall introd=
uces
>>> a race, mlock_folio() sets PG_mlocked immediately but defers PG_unevi=
ctable
>>> to mlock_folio_batch(), causing pages that are about to become unevic=
table
>>> to be migrated, which violates the intent of compact_unevictable_allo=
wed,
>>> and causes spike latency in RT kernels [1].
>>>
>>> In order to fix this, migration is forbidden for pages mapped into VM=
As
>>> marked with VM_LOCKED. In addition, two early-return paths are introd=
uced,
>>
>> Please don't reference legacy VMA flags. -> VMA_LOCKED_BIT.
> Got it.
>>
>>> filter out mlocked pages, return early to avoid unnecessary operation=
s.
>>>
>>> Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch interna=
lly")
>>
>> Hmmmm why do you think my patch caused this? That was just a folio con=
version?
>
> Oh, I made a mistake, your patch was just a folio conversion.
>
> Batching mlocked page was introduced in v5.18 by:
> 	commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page() batch by=
 pagevec")
>
> Setting sysctl_compact_unevictable_allowed to zero was introduced in v5=
=2E7 by:
> 	commit 6923aa0d8c62 ("mm/compaction: Disable compact_unevictable_allow=
ed on RT")
>
> So this issue exist after v5.18.
>
>>
>> Also I didn't think we liked having fixes spotted about a series with =
non-fixes
>> tags?
> Got it, will split this series in next version.
>>
>>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F3341009818=
88259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/ [1]
>>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> Link: https://lore.kernel.org/linux-rt-users/33275585-f2db-4779-89f0-=
3ae24b455a67@suse.cz/#t
>>> ---
>>>  include/linux/compaction.h |  6 ++++++
>>>  include/linux/rmap.h       |  3 +++
>>>  mm/compaction.c            |  8 +++++++-
>>>  mm/migrate.c               | 23 +++++++++++++++++++----
>>>  mm/rmap.c                  | 12 +++++++++---
>>>  5 files changed, 44 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>>> index f29ef0653546..04e60f65b976 100644
>>> --- a/include/linux/compaction.h
>>> +++ b/include/linux/compaction.h
>>> @@ -106,6 +106,7 @@ bool compaction_zonelist_suitable(struct alloc_co=
ntext *ac, int order,
>>>  extern void __meminit kcompactd_run(int nid);
>>>  extern void __meminit kcompactd_stop(int nid);
>>>  extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highes=
t_zoneidx);
>>> +extern bool compaction_allow_unevictable(void);
>>
>> Don't use extern. We remove extern as we go it's not needed.
> Got it.
>>
>>>
>>>  #else
>>>  static inline void reset_isolation_suitable(pg_data_t *pgdat)
>>> @@ -131,6 +132,11 @@ static inline void wakeup_kcompactd(pg_data_t *p=
gdat,
>>>  {
>>>  }
>>>
>>> +static inline bool compaction_allow_unevictable(void)
>>> +{
>>> +	return true;
>>> +}
>>> +
>>>  #endif /* CONFIG_COMPACTION */
>>>
>>>  struct node;
>>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>>> index 8dc0871e5f00..359c7426b6b9 100644
>>> --- a/include/linux/rmap.h
>>> +++ b/include/linux/rmap.h
>>> @@ -102,6 +102,9 @@ enum ttu_flags {
>>>  					 * do a final flush if necessary */
>>>  	TTU_RMAP_LOCKED		=3D 0x80,	/* do not grab rmap lock:
>>>  					 * caller holds it */
>>> +	TTU_RESPECT_MLOCK	=3D 0x100,/* leave VM_LOCKED vmas mapped instead
>>
>> -> VMA_LOCKED_BIT please. Also maybe just say mlock'd?
> Got it.
>>
>>> +					 * of installing a migration entry
>>> +					 */
>>>  };
>>>
>>>  #ifdef CONFIG_MMU
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index f08765ade014..5d256930e389 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_contr=
ol *cc, unsigned long low_pfn,
>>>  		is_unevictable =3D folio_test_unevictable(folio);
>>>
>>>  		/* Compaction might skip unevictable pages but CMA takes them */
>>> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
>>> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
>>> +		    (is_unevictable || folio_test_mlocked(folio)))
>>
>> Maybe just change is_unevictable to include this check?
>>
>> Like:
>>
>> 	is_unevictable =3D folio_test_unevictable(folio) ||
>> 		folio_test_mlocked(folio);
>>
>> ?
> Sounds good, I'll fold mlock into is_unevictable so both checks
> stay consistent.
>>
>> Also later you have:
>>
>> 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
>> 		    (mapping && is_unevictable)) {
>> 		    	...
>>
>> Which doesn't account for mlock as-is? Is that correct?
> IIUC, The is_unevictable check here mainly serves as a cheap pre-filter=

> for inaccessible mappings (which are always unevictable folio).
> It's unrelated to the mlock.
>
>>
>>
>>
>>>  			goto isolate_fail_put;
>>>
>>>  		/*
>>> @@ -1898,6 +1899,11 @@ typedef enum {
>>>   * compactable pages.
>>>   */
>>>  static int sysctl_compact_unevictable_allowed __read_mostly =3D CONF=
IG_COMPACT_UNEVICTABLE_DEFAULT;
>>> +
>>> +bool compaction_allow_unevictable(void)
>>> +{
>>> +	return sysctl_compact_unevictable_allowed;
>>> +}
>>
>> You add this helper but isolate_migratepages() still references
>> sysctl_compact_unevictable_allowed directly?
> I'll route that reference through compaction_allow_unevictable()
> in next version.
>>
>>>  /*
>>>   * Tunable for proactive compaction. It determines how
>>>   * aggressively the kernel should compact memory in the
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index a786549551e3..3a15eb13e82b 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1202,7 +1202,7 @@ static void migrate_folio_done(struct folio *sr=
c,
>>>  static int migrate_folio_unmap(new_folio_t get_new_folio,
>>>  		free_folio_t put_new_folio, unsigned long private,
>>>  		struct folio *src, struct folio **dstp, enum migrate_mode mode,
>>> -		struct list_head *ret)
>>> +		struct list_head *ret, enum migrate_reason reason)
>>>  {
>>>  	struct folio *dst;
>>>  	int rc =3D -EAGAIN;
>>> @@ -1210,6 +1210,7 @@ static int migrate_folio_unmap(new_folio_t get_=
new_folio,
>>>  	struct anon_vma *anon_vma =3D NULL;
>>>  	bool locked =3D false;
>>>  	bool dst_locked =3D false;
>>> +	enum ttu_flags ttu =3D 0;
>>
>> You reference ttu only in an if-block below no? So why are you declari=
ng
>> this here? Move it to the if-block.
> Got it. I'll move it to the if-block in next version.
>>
>>>
>>>  	dst =3D get_new_folio(src, private);
>>>  	if (!dst)
>>> @@ -1249,9 +1250,15 @@ static int migrate_folio_unmap(new_folio_t get=
_new_folio,
>>>  		folio_lock(src);
>>>  	}
>>>  	locked =3D true;
>>> -	if (folio_test_mlocked(src))
>>> +	if (folio_test_mlocked(src)) {
>>>  		old_folio_state |=3D FOLIO_WAS_MLOCKED;
>>>
>>> +		if (reason =3D=3D MR_COMPACTION && !compaction_allow_unevictable()=
) {
>>
>> This should really be a helper since you repeat yourself and it's not
>> obvious what this is checking.
>>
>> Like:
>>
>> 	static migrate_mlock_allowed(enum migrate_reason reason)
>> 	{
>> 		/* Only compaction is disallowed. */
>> 		if (reason !=3D MR_COMPACTION)
>> 			return true;
>>
>> 		/* If we can compact unevictable folios, we are ok. */
>> 		if (compaction_allow_unevictable())
>> 			return true;
>>
>> 		/* Conservative: if any folio could be mlock()'d, disallow. */
>> 		return false;
>> 	}
>>
>> Then you could self-document what you're checking and avoid code dupli=
cation below.
> Got it, it is more clear, thanks.
>>
>>> +			rc =3D -EBUSY;
>>> +			goto out;
>>> +		}
>>> +	}
>>> +
>>>  	if (folio_test_writeback(src)) {
>>>  		/*
>>>  		 * Only in the case of a full synchronous migration is it
>>> @@ -1324,7 +1331,14 @@ static int migrate_folio_unmap(new_folio_t get=
_new_folio,
>>>  		/* Establish migration ptes */
>>>  		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
>>>  			       !folio_test_ksm(src) && !anon_vma, src);
>>
>> Useful to convert VM_BUG_*() -> VM_WARN_*() (possibly _ONCE() here als=
o) as we go!
> Got it.
>>
>>> -		try_to_migrate(src, mode =3D=3D MIGRATE_ASYNC ? TTU_BATCH_FLUSH : =
0);
>>> +
>>> +		if (mode =3D=3D MIGRATE_ASYNC)
>>> +			ttu |=3D TTU_BATCH_FLUSH;
>>> +
>>> +		if (reason =3D=3D MR_COMPACTION && !compaction_allow_unevictable()=
)
>>
>> See above about deduplicating.
>>
>>> +			ttu |=3D TTU_RESPECT_MLOCK;
>>
>> Hmm. I don't love 'respect mlock'. I guess we only know about the reas=
on
>> being compaction here.
> Right, we only know about the reason.
>>
>> But I'm confused anyway. We have the folio, why aren't we just checkin=
g for
>> PG_mlocked() here instead of getting the rmap to see if it's mapped
>> anywhere with VMA_LOCKED_BIT?
>
> There was a race scenario without patch 02, vma may already marked with=

> VMA_LOCKED_BIT but folio has't marked with mlocked, such as below:
>
>
> CPUA: mlock()                                  		CPUB: compaction / mig=
ration
>
> mmap_write_lock()
>     mlock_fixup set VM_CLOKED
>     mlock_pte_range
>     	mlock_folio(page N)
>
>                                              		isolate page N+50 (mlock=
 hasn't reached it)
>                                             		migrate_folio_unmap
>                                        			folio_test_mlocked() --> fals=
e, but VMA:VM_LOCKED
>                                        			try_to_migrate()
>                                          			rmap_walk(P) [anon_vma rwse=
m / i_mmap_rwsem, read]
>                                            			try_to_migrate_one -->ins=
tall migration entry
>         ...reaches page N+50
>         skip migration entry (without patch 02)
> mmap_write_unlock()
>
>
> access page N + 50 --> wait for migration complete
> 							=

> 							migrate_folios_move
> 							....
>                                              		migrate complete
>
>
>
> If apply patch 02, mlock itself will wait migration complete, so checki=
ng
> VMA_LOCKED_BIT in the rmap path is no longer necessary, but this logic =
is
> retained to avoid unnecessary migration operations.
>

For this race condition, since VMA has VM_LOCKED_BIT set, maybe you can
extend rwc->invalid_vma semantics to return 1:SKIP, 0:OK, -1:STOP.
Then install an invalid_vma function when !compaction_allow_unevictable()=
=2E
The invalid_vma function returns -1:STOP for any vma with VM_LOCKED_BIT s=
et.
__rmap_walk_file() and rmap_walk_anon() will need to break when -1:STOP
is returned.

This approach will not require a new TTU flag, although it requires more
code changes.

Best Regards,
Yan, Zi

