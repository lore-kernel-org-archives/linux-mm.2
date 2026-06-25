Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA43CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210A86B0088; Thu, 25 Jun 2026 09:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C13E6B008A; Thu, 25 Jun 2026 09:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BD56B0095; Thu, 25 Jun 2026 09:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D11316B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:59:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A9A888415
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:59:49 +0000 (UTC)
X-FDA: 84918593298.21.E8337A7
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012056.outbound.protection.outlook.com [40.107.209.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 575034000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:59:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ng7zoqk7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782395986;
	b=IH4KSrGSFchlUcbS9LgesrlIOXH6lklO8MYPgDz2gov1pLJOvsIHmg5SDCHZxokq1b+ULM
	lHqy9XGrHBLCEvWld60LHcYO+lVm4D50/oqknkzEEphIHk4H+qguu1G47F+RiPeSEhMYcl
	iINXb6i58b5ALuOml4pbmJUn1kIoMXo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782395986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHCCR22CCRO0YRgIyXp0LAnbt6iT1FSSLm9wxgZdXyw=;
	b=DLOeC0kTaPDnv2tZkSrNRuaWws2/t85WTB7OJSXJkSU9suW6iZ4r4459mDdrYF0B8/q0iv
	CP1n/hrkqk4mtFcGWfLLMnKkaVrOpn/IwuRWd0wfbflGc+824uh5ApnklXv/jXznGyKOpe
	4YJJDPQGfUsi+A7x53+lftkd8sb+tyQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ng7zoqk7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7HB9FoMN9Jzf8kAI+yE7T6RWNA7REhKRmuoBcVpETGr1U3JJlL56MKLBoqG/0wtOFMHkKBuGv84CHUGKkEu1XfTba1lisnmBpyC5Y/RS1n1VmW/OvWMYajanLnOel9pQ0CxEi8mLfYBwRq8wHn7EQNufauiLqfoAGWIXy0Cr33a/f1sxBpRLNrKMS22bgG+BgcCRD/Bs2ddjFVAIRkHA6bLreupB1jN8W8FzCvnGLofzrugw9ASv/akvoQeHHttJzSzrrjVcLMDbApl7CFuF9mUOaaMu6Bsbss0EMkvVn2LbdNO61AVgrBGCBd0H6H5doVExAPA90XKVzAcj/dXPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WHCCR22CCRO0YRgIyXp0LAnbt6iT1FSSLm9wxgZdXyw=;
 b=bqmcuI6WM/6vWYhFdEKiuCdqqMOLfGOLB8wKt25fXw/l02fAWfx/Buh/xwFmf7tgGs6tsUaq77XVWJdif62yYCUybrYCpJY2WkMQ2xr3jJtTyNQCLikSqqXjjLg6O71CHxb9+u1rHzkU0lnOXldJ3flx1+OUQch5p/qQk6erJENNbMAOPppYm622hU/zRORPOJU0lSelzAbSQvjacZHYMzvf67OCh60ZI+Q5A7B7bmnYXAvJsjiD5r6qitrNHmJR/exoI/K3LM/b1Ov7F3XRlPYw0oz50WcB+Rn+s8JW5SCJlTo/LEtwsFt+ix8uLXFUH8t91eb3KKnEC65YncmRPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WHCCR22CCRO0YRgIyXp0LAnbt6iT1FSSLm9wxgZdXyw=;
 b=ng7zoqk7YzuCHC1KUQbM7fC3gIkCuqmrhLe4NsdV44eOU/oPxPv+FeIyYjE/eP/kBS5DjrM1htYuU/w770Yk9l2cQGTwkQ3495AIvPpdFw/9Peb++iZvAKNK9tpwsi6E9u5Er04lKo+JXovqcdJqjv7dAD2+u+1RO0iXX4/oy3dt7fSoslREM0/UfeMaPEylv+UV2PMTsIl6zgC98w6wPzR6vaoGibc7EyTzxShOD3oiZvWxSIZiH1AKvy+TChtSt9hM6YR4iDMireOlIDZtsxIQYJUC6qQ/B+pRZh7qcLACwftP1JIBujn2VtBnMt+dGQtZDfyg5JdD6aVhFwRsVA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PPF8002542C7.namprd12.prod.outlook.com (2603:10b6:f:fc00::657) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Thu, 25 Jun
 2026 13:59:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 13:59:28 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 09:59:26 -0400
Message-Id: <DJI6MYYF7NOS.2JRWBWFWEO4AO@nvidia.com>
Subject: Re: [PATCH 0/5] Fix incorrect access of hugetlb pte entries
Cc: <riel@surriel.com>, <vbabka@kernel.org>, <harry@kernel.org>,
 <jannh@google.com>, <lance.yang@linux.dev>, <kas@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <rcampbell@nvidia.com>, <apopple@nvidia.com>, <matthew.brost@intel.com>,
 <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
 <gourry@gourry.net>, <ying.huang@linux.alibaba.com>, <mel@csn.ul.ie>,
 <nao.horiguchi@gmail.com>, <ak@linux.intel.com>, <j-nomura@ce.jp.nec.com>,
 <pfalcato@suse.de>, <dave.hansen@intel.com>, <tglx@kernel.org>,
 <jpoimboe@kernel.org>, <ryan.roberts@arm.com>, <anshuman.khandual@arm.com>
To: "Dev Jain" <dev.jain@arm.com>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
 <david@kernel.org>, <liam@infradead.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260625112955.3254283-1-dev.jain@arm.com>
In-Reply-To: <20260625112955.3254283-1-dev.jain@arm.com>
X-ClientProxiedBy: CH2PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:610:52::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PPF8002542C7:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d06e6f-bbc2-4771-b6d1-08ded2c1f933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Dli/7rXflY/sHRfa5kFw7h1zpvakvUXjrizU1FduK4A8sn755KjdCz2yO4cZPgQvenpZfWInL6l4sb6bg+BhF2vWB0jyq/mVWJPBBYLVeuqxWEJKBgS8drk1lWPcDZqTEXZAmBVtL142PdHUNt9KR9NPue99F58jvo5B/TtvEvWOuZQTlDZvepo/cKEEQifH+Qw7LYmEO8dlRgvy6x6LkPU5yxXYtyc0bOYtWwpqMXJoI4XhX0/scKFVJlChTJ9NCELpdNqPC6PlSE5eD25ASeSfLMhfrVE/1CMUNJSdSEzPh2P8THcPTsz3nV3deaZ2WGohwLD1nYqlEmdmUrPMqU4EupTD05xkxe42CXCkU4fC2FHva3oLml1Y2l1rL5wD74c7bvJtAg/iORYu8GLKrZXQlrJOScqWLnXqTA3kqd7p3+eoKcAyJ2x6Kj4Q+yxe3pMXSux2o8l468iDoWAbVr5oWx82lmNWxV/ADpBnUw7OTFPKGlaUWzLen/rqPgC7kTyotKgFNeZy5KdPlz6lIYnyLuB3aujKBKEol3rL/yjtGc0OyozsURzTrIG1eDVwKHCf2ae0a9vkk1YBD4tSt+R8DEQGbU0cAoQWPclzLzoNYGCs3XdMO6y29lDeybcD1rq5F4G+rtCsYe3zdaWO0972XLnZg36aDgmBCyHeYmo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmJ2enJ0b2sxYnM0YTl1UEZwd0w2dzBXV1lnTmdXZHhZQ1NrTHNuTWdYK0pa?=
 =?utf-8?B?eWpoWGtNeGhYeTJQaXM1eFZhODY2dUtlNUdxbHIvcG1YSUdhcFVYaW5GRXQx?=
 =?utf-8?B?R1RkTW9GeXM1cUF4QWhNbXVwc204cFpTOUppeVgwVDdGZkZ4WG1UZzNFWlcx?=
 =?utf-8?B?OVQ4dGtKZ2xsUEU1WThTNnlFa2dYa1NhbTg4YmMvU2l0d2E1eUl5Vmk5NFB0?=
 =?utf-8?B?NVNuTkJ1eUM0bmNoYlJsWDFjL2Q5eDI3QnRMUlI4enlxYXVMOFYzL0Y2Qjhk?=
 =?utf-8?B?Q255T0pCSUo4RFJkMVNCMHg2UEEzZ2J3QmxWTG5NemhJVCsxOEJINHpVYjhD?=
 =?utf-8?B?SjI4eHQrUUVtaXd5V3lTWk9reVEyQlR1ZzRhcnZRZmlSYVp4RDlHS3ozVkQ4?=
 =?utf-8?B?OElrNlJwb1JFSEtyUXExQzJVUGFNOFNtVU1ldUZEdndzNWllZHh1aGZNaEVj?=
 =?utf-8?B?RjRsZkZ5SjJjT0s4Nk1jTzY0VFQzUEUzR0dJeE1NUUFMWXpZNDRXMWdqeXZm?=
 =?utf-8?B?ZDM4WlA1VktXWUlKUngzbUNXTTlLVHhNRzBYZHF5WkNxd3QrYysyaVZIaWlS?=
 =?utf-8?B?T0dwQmQrYWUzNENrOFVSN2RjWU1PT21xcTc3VlBxWWNNMnovRHpodWFQN0lW?=
 =?utf-8?B?WUpWaDRnLzdCUWgvQ1VjOE5leUJGUEdXV3ppcDBCWUJBeVdxNmppV254ZGwy?=
 =?utf-8?B?eTBJYXNyK2JUMHBucWVZajRVZkV0NzYyQVYybXlqTUV4S2xRVjRZY1VYdWw2?=
 =?utf-8?B?a1lUT21EUmpzcW5VYVJQd2VNLzNOOGxEd2RGZDFHN1g3SmtMQjN3RWsyV0VO?=
 =?utf-8?B?ZFpITFI3WG03Ry9Bckpua0JFSmJUd0swb2dJUk90NitQUG00Ri9GS1hNNnB3?=
 =?utf-8?B?N3lSL0llK1U2YVVaSURKVDlQZ29jUXluMy9QTGlPYTBnMDA1ckR3L1I3bnBX?=
 =?utf-8?B?ZnNGbGIvcTM1aTZ3UWVNWnZtanpPcGd2YU5OSTFIa2FZNktjZk5RazBEaGEr?=
 =?utf-8?B?NVFFbExEbGVRYy81SGQycFdPOFJ3ZDNCYnRBR0s2cXo1SWJBN2RFOTc3dUlx?=
 =?utf-8?B?T2xhTHJ4TktmS2tmKythbE5OZG82cE0rUUozUUZvTDJDRHVaMWNlbzJYK3g2?=
 =?utf-8?B?d055cW5nWFp3ZmU0dlBiTEZYSGx6aHVHZG8yNk92MzdPWnVNWnFvQWZ2NElC?=
 =?utf-8?B?RlErcVYwODNkNXJtT2xaNStGbTR5YXg5WDN4YUxnM3FsUDNSenoydk94N1dy?=
 =?utf-8?B?ZjFIaFE4YW9ZNjZxSTIveFUvWlV6a2R2d3NqcUNFVThEUWRNclpwQzBnZ0gz?=
 =?utf-8?B?dUZTZWU3ZzVjK3FpSWpUVVlrZHdnWmdRSDhtVE9aTzlFUnlMdFBNQ0NmRnd2?=
 =?utf-8?B?TTh1RFp5R01YZkVMMzA2TmE0bnB2SU5iTEJZN0NxZVhIeWhWWDlTcktIOGQy?=
 =?utf-8?B?QXhkTEZNQ3ArU1pySCtwdFZBZVd2N21kS1FaZjBLbW9JNHpPSm9OWEpuYlVY?=
 =?utf-8?B?Um9Xb3NMenJ1Yno0WnR2dUpiMGFCSkI0STNYT1pFMENhajdGdHRNY3R3cHRI?=
 =?utf-8?B?dHZkOFRYN0FrTnZGQ3UzL2R4bEU0amprYjdVL01pZmM2SmRvZFYwM25XSXQ5?=
 =?utf-8?B?eHZRd1hyVlBlVDA3Mm1FRktxUW5RUElaeHZVMDZ2YnJDZ2xUamp3aGN4czY3?=
 =?utf-8?B?V3hhc3V2aVV0bDhaRUpnRW5pRmszdklqbWdyWk5pUk1aQVdEMUhCR0g5OWow?=
 =?utf-8?B?ZnZDUDNKOFpsOTdaaU9SM3RDV3l5bm85SjZXNlppam52SjduaHdBdkM3MUYr?=
 =?utf-8?B?Z1J2a3dsNzYvbzRVOXV0TVBiTll3dFo1enR6UFY3RXNPaFlJQTVWcjE4ZDJV?=
 =?utf-8?B?ZGRNWWZMMEhGMlJoeUdLWlJYOGo5eC9qcnNNTkI5NHZLa0U3SzZndElyQTRl?=
 =?utf-8?B?Tys5dEdoRGx0YjBMZ1g3dmpsejJESm1Tb3JsVnVaZW9GTDZaTlVoMGVvZUo1?=
 =?utf-8?B?bUR0SXZvU1FlRzkzQUdDZEh2SFZTS0R3THp0THN4MnRrUi9ERWdNM2lkMlBt?=
 =?utf-8?B?N3ltWm5Ebis4MEdUL1VJdTU5OUhkdVJGbzhqWjV3N3dobURjN1ZWZ0t1R0Q1?=
 =?utf-8?B?dEpRbGttcWhBeEplWXQ0UW5CQ1dtdE5FcFlveGdKL0huQ3c1d0wwM1lYS3Rp?=
 =?utf-8?B?RXRVaDFFMm9jdXc0cnRlVldmejZIZmYyUGwyd2lNNVhPWnVzYVdYRzNRL0RB?=
 =?utf-8?B?KzRySDROdlEwUTk0MDBnNjUvVVg4VURhcXlmMDZ1SWNINTVEMUhKQU9WNk40?=
 =?utf-8?Q?baNo1epMEl2fYWGt7Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d06e6f-bbc2-4771-b6d1-08ded2c1f933
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 13:59:28.6044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dL+sOB8Px47+CASv1owD0fhRv0sI2SQ+qTAeMqyRfkzwm8s1gPAZ+ftbS3TmGNjV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF8002542C7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 575034000B
X-Rspam-User: 
X-Stat-Signature: c45u3k5nfmcrhpb8f7yj3jutzygekomk
X-HE-Tag: 1782395986-387155
X-HE-Meta: U2FsdGVkX18v5YP6mK/GLGBBW/+/+RD31AKaQwmCyKIiQc0w/T1ynhnQxvR0NOMnz4P1UWPM0SYmIbUJdtNYupY/MlCCinYRo9Zf2amlbdJySS9+pFHtS079fKT84zlRV4a2NrfYXkbIsVXdb3JkWTZAfdEZSLr7sSowfl+gtY/sH3OjBYireNhOi5nA5I6ctzKithuW8alLnCr/2jTzuRkpRvFgnFqX+G2LjkubiraBzAwQwlFGufY5C9vJu5+GBEokQO3G3tGqWbuuMDvFPxjiojOtONX7Zb2UwFFG4LyI+8OzpAl8iby561MKKdOFR+wttwS9+jet+2pqFsiQl9BkrffsUxMMPuthSvIBbPzpQPqBpTXoo7JoJTZ8UQ+VWaTe/Ivas43K96zrlFkLrwQqRUx2DUqXgoOJpnzqT4jjxmFtPvsQV/LACwo3yB2bOw91b7gYivxIaMC+hKq89tu8qwwWyQ/qLxaSNiiYsfVUTOufIrTvKFWUYl/Id3+2HxKtVxXZEUe/cg7F42a3yVNKMtLWK220Q6bvkl5valgqwxRBBp02KaZ3DiH4Af1zpPZgUVkerXWGWEu/5KVJboxggmVD/Nfbwd9NmwhOPhiD+3uHv9U04kfGeSSazSgK/BYNq7vEGtdNRjfTdVj3mHiAnJgTBUZD/SYCRVMvgNloukCUP09bcKNa3k+Ls8Wxy6Tr26L8RywURjVMViS2ONwNxufH65szqr5tfUsWaNVaDIzXyx1f1pi62DQ9DY59pScnHoEgOtLG5LSKfj9GdzjTpuD0N4ZQ0zRmlKiVwGSMaT9pTwBbtmmi/Q2I+yhqJ8dSo7sg4C3JglI2OTGCFUzIMEmGMZg44YIIh2i19HnBGPyMLrAJxfN9mVl0X4jW7UHj6Lz+DZsYKjSKnXzGcIkBoTnur/Zh1WH/5aUpceXtDUNgEmnOEAiLa9l/bGJVoBN7OrYymz5v4xDcpj3
 uNSSQfYg
 +IwGgWb5byEx1bmcOKNQPf2pAibYQpBx8fNZAubioTv1GVSGRZlGh/ZE9qU9Fb0gAOKOZfgXNQ1DHTxoRMCkhr/eMPHbaAa8tpmjviZtkd7hQL5kD2aO4DeOQtd64antnSnPpKUXf2sHVtFgbZ1WnOpIiTjzeXBm7LSwdM/QavfaqpBt0KPLdP7CJPqR+KnxP89b+iu38Kd547Yc6nKPklTNoRsb2EWQ2LlkeuHkTViZOfuuuJVxPVE+ApLWXSNYMkglLEQqWdaU1OP4HnWpQnhkP+YToPBDyrPuPo8Ls5KZpVS9+vDqRo7OAod44OJ/6c+VfmdRLFtFbOsKz7qn0FNXSbgYFwhxyucV0f2Ks88oulcpRcbhJOC3YFv9BucLuFV1PQdITwbKM1HwNLt00OSGrJp1PqDiNTdvKENBKfvNWvDS1OT5jWDo09zqgcSEQ0fzj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 7:29 AM EDT, Dev Jain wrote:
> There are various places which use ptep_get() to get the pte entry
> corresponding to a hugetlb folio. Some arches have special handling

I think it is better to mention s390 as a concrete example.

> to compute the pteval, so they provide huge_ptep_get(). Use this
> helper consistently.
>
> Dev Jain (5):
>   mm/rmap: use huge_ptep_get() in try_to_unmap_one()
>   mm/rmap: use huge_ptep_get() in try_to_migrate_one()
>   mm/migrate: use huge_ptep_get() in remove_migration_pte()
>   mm/page_vma_mapped: use huge_ptep_get() for hugetlb
>   mm/mprotect: use huge_ptep_get() for hugetlb
>
>  include/linux/hugetlb.h |  3 +++
>  mm/migrate.c            |  6 +++++-
>  mm/mprotect.c           |  8 +++++++-
>  mm/page_vma_mapped.c    |  8 +++++++-
>  mm/rmap.c               | 32 ++++++++++++++++++++------------
>  5 files changed, 42 insertions(+), 15 deletions(-)




--=20
Best Regards,
Yan, Zi


