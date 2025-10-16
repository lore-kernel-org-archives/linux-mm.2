Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F628CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A941D8E0006; Thu, 16 Oct 2025 01:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A450B8E0002; Thu, 16 Oct 2025 01:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5A48E0006; Thu, 16 Oct 2025 01:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 741F08E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:46:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10FCD1DDD95
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:46:37 +0000 (UTC)
X-FDA: 84002892834.24.41C1955
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011021.outbound.protection.outlook.com [52.101.62.21])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38799100002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:46:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DdfStuAc;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.21 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760593594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d0Mt7nQrCSneNNnmfgEC0tACw+GMZ3moxnf9t58RQ3U=;
	b=IloisAm8rD6Tts70F/bw2DTFzcWCwQgXtPvdRyIAfBjMRwKMX6smdW847SVYce7JLJUZQK
	zIbkVQfXy7sc40pMFrcK2QnpqIKSN8Lj6ASK6ujqyQPA7roflPoPMLoYENupXLALI44V3Y
	/uS0uhXi34b6ZBLDixm6JWAHaLbppIE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DdfStuAc;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.21 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760593594; a=rsa-sha256;
	cv=pass;
	b=ZhQ0m/0NXJIqfWhb4oe2w9MoO12byfYozWnQOUnf9tmMOZur1gMeWGniL7YrN4p1NgqqXK
	IpyvD4Y6XKztCpjdevPmigp3UsLGRg22EFNptpybFAjiUg7KxegVkK5SqeoELbwGTV/GfD
	q9i86+Kpy8ZXfqMfvlefGYKAcrptLco=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PuitF33ZvdgstseA6dEioAQ5nSZMMsE0/+kduQLVKQ28v3/aTFxp7E7feTh0vEG12iotE11jyIQY+ydcqF6nqdMJJovbTdgFo5UJFIbVCpn/94Sh36V7nJkkVR3gvSqKj38Rld4n4ktjTPJ6alnoxH4eGr5IIi5KGwgzJAI9kzKl1CwSM/4/Ltqc1LbKcm69heWtDBQe+/vDwHBEgeTFy34JqswRk4py+5hgS4Jy4SHqIENZHJ2T16zd3zltnhVEk+QodpfCfzkpusT6iHsBLTXV4txpDQG4EEavE4AtVB5zutqSpSmphI63QM0dWjK+WMEHc7NyWLK9SbC+oR7FSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0Mt7nQrCSneNNnmfgEC0tACw+GMZ3moxnf9t58RQ3U=;
 b=enaxp5XyU7fhkCMkF07Vrmcu02bUkLnfKairxfFkjHBpZ8aQqc2TkBYiBWZJAe+j652mStW7/7ugUhty7JP9+ZRRMyCpN3ywGuRUJoXUvy7wdxbCg0kjTBpxJCrqR0BSbb3tXA6EnborjiKKg+7Ez+laGQllbacxvHJukGyKoyT+42EYxmQ2uzubXcpn6PsMo4k0+M/Ca86wodv/3Aynxbqn8Tqcv3nGZcz7mpvaRzpa6EWd0CPBa1V0y30STY+bbKyLie+niW7uKF/oEtpLPL7UpVkXKuIAq1qfPSdrndRmr9+N4v1rRm6hc//QMoKW2MetY2poqNNEOkUbfA20Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0Mt7nQrCSneNNnmfgEC0tACw+GMZ3moxnf9t58RQ3U=;
 b=DdfStuAc/BQgZGi6n7ci4pd8RpOleH9vN6jtwiXXIyhhS0UhTVXM7UzEa2CDdif2WM/gDbDRVQBvIfgbgF49V6lE5HB4cmqhXJdEd9v6lvNBF7in0nJ1dG+7+emGo5ABrFwQBDQpbLH57nBMn8oUlGuGi0HA46FpH6diytcMGaDolZcm0krBntO3xEJOSHO6CwT2/i4kyo2OVLhPUytAOUkGV4/1rECHLzyuikL55CmC9RKA2as3r0RV7dJGdYUj46pDPXYV2vDJ7W2TeoYtrFq4UQmZ/QCr9HJT9dLiZlTe+8vlUcwxhf6/UEDT4Z/JzeAwNC8wwiM5Q1Rm29eUxA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH3PR12MB8281.namprd12.prod.outlook.com (2603:10b6:610:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 05:46:28 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9228.009; Thu, 16 Oct 2025
 05:46:28 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH] mm/migrate_device: Add tracepoints for debugging
Date: Thu, 16 Oct 2025 16:46:19 +1100
Message-ID: <20251016054619.3174997-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY6PR01CA0099.ausprd01.prod.outlook.com
 (2603:10c6:10:111::14) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH3PR12MB8281:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a70cab6-9a5d-4a11-5dd9-08de0c7759c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?McGBzl2kX5sYJ0LGAQCZ5te09IUdmxOZzqFnBOaPG1fzKRoKU/p4tbSBtoW3?=
 =?us-ascii?Q?lSLCt2oe8I9KNzrgtAosnvy0QY75zGTMZe+RcudEQF0NNDJ+0o3ciLQ7prSh?=
 =?us-ascii?Q?6svUmhvsS/Lzj+WaJA1CBbyRSgUABcPtw7kwAtSefl9KH8pIbM0Xfw+V+syx?=
 =?us-ascii?Q?ixt0ZEoTFxFR7Vcg2xDbJhOHl9mLSRnEjayQlpG6a7/XOElr1Y74rOuEA9Bd?=
 =?us-ascii?Q?CYkpXk084pmxp3H4XkfCjPsqpk9wDroOJrbd455rw239T6MRhTQp0KPWATgR?=
 =?us-ascii?Q?roFi9hCj/PaPIseKZHRYd+OgAX4qGXJ4J4X9F9NUH6lNnfaux3y/FQzxlG1S?=
 =?us-ascii?Q?dTCF7r+SZCIvmoin5ievPq97NOPiquBJdxDQjk60AtY7IhOPGLcPmTLtO01n?=
 =?us-ascii?Q?qz5CUBb63iGak34cFk84IRIyWMkh43LANsFh4Bd84b5iGO0qCvpApXgrG8CR?=
 =?us-ascii?Q?mRvNeBvAj2R32RteCCKFbkrmwjFaoX5f3eyTd03pruYunRTLEaPvpiTOKdmU?=
 =?us-ascii?Q?1LrtNbovDIhyJKYLlOv5X51v4/Tcu5Xlt42qYcJj8sOInbOn4v0xBXDdm4Zi?=
 =?us-ascii?Q?wPIsEL8BBq/QHKrrGBceuk0PoRL/AMLoQhJaC5U9rip0+Fkq5SknP3/UK2pH?=
 =?us-ascii?Q?iaDJJ3s/6NZqfD/QGW35A0jCnijIhefqMzWLd4elaKtvGbOV07dkJ8I8MMaI?=
 =?us-ascii?Q?DLTXQ9smNfouITF5sBKaIJCVtsAGIITShQhowb7TVxVN7599WxkHYkbdlK12?=
 =?us-ascii?Q?CpbVuGChPF41NhoyXeTkm0fasatOoOrAeZrkfWQNyiu+qit7tMzssPPuWB46?=
 =?us-ascii?Q?BEfobXqYrGb9ryx59p1ZcAhe3WqslOHbk0ax80DDa3mh9lafyPpPlKvwJPib?=
 =?us-ascii?Q?+hS6CQYtKG8s56JuwWWu3BpbeCP0nmbVsIEOCmKo46OZy8PXT1f5iqIHgagI?=
 =?us-ascii?Q?U+Z3+KHy477Y+uFd8+fHmMnHtQq+sH5pYmlPYpHvhkrXpeIsPy9uDtuzgcF0?=
 =?us-ascii?Q?IsgX4dyVH0GpkepImzAeuNzxxt20B8rxA0ciPoS4Rb491d/rx+XLQHKb5LKV?=
 =?us-ascii?Q?REucMQeHwy1Zn6yTwA67hq+pSPT8vIWIg6Y1QcC4BOHMmNaWb8CXd+U815It?=
 =?us-ascii?Q?pDqTgu5tlmrjQGPpWN4+X21k7gDq1SqDgyrUJ4ognSZVRvOBPAgb4DEp8tU2?=
 =?us-ascii?Q?2J99xFCRYte/Ssrj3FToLl/9+IJG4MCJhLPns17duiYI0MXLVVAkWJHNKOXX?=
 =?us-ascii?Q?l6Ck9hIemccKravP4MAO5GtiqGPEgFE0r3AgQE+l7ypH7J/JmRkqpU91tDHB?=
 =?us-ascii?Q?xXwA7cHSc35yww3lpZcEJ28DeF06HFNjd6srQowBIhqiLk4fkY7Q/M9hjH3e?=
 =?us-ascii?Q?aD0vcf0wcjn1YszhmL7D++IN0cUhDZkXQyCyYJs5J74b9hnCbDHPzcyReOyy?=
 =?us-ascii?Q?bWqXbzv7GS0ac9mz8W4OSn+Szscouzbm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pWlDL8+SCTKBI1tdSI6t4g2wNYW4w5LAr8iqsnPyIdAahuv03hslH6nJUR8z?=
 =?us-ascii?Q?SrchY9ZiLR43YYxHSZSd60/0I2OJ0zZP8R1RV2O2WPPvT+SWzlmiPGfs3ZRa?=
 =?us-ascii?Q?F7a/S83iOZFH9E+n8UpEeku5Oe9tXLBMGbUsXxA7EdzCOiK7dLt+wnuu6e6O?=
 =?us-ascii?Q?Xu9JxYhiYafqMrc5WvtVxoEzphPYhNhY1limq3ZzbXvKLPWOtjKfFHVwvvkS?=
 =?us-ascii?Q?RpqqWURks9Yp/P/GLaWij+2kD17grKpzKYMxH/sgywxH14M2sFyyzWnywkOs?=
 =?us-ascii?Q?vmfrfVPrDxYOtNaShpRVT72///8NFR9Q7/UcIydFukbwk5CjxkLvK614Smxv?=
 =?us-ascii?Q?vd2mAg986lUd6GfaLTkWzExJjq2ToLeNPtNOb6Ihv+Z653k0IT1pTPtEAsOG?=
 =?us-ascii?Q?+xxqJb9TtYa12ApCqDeUbw80/gBEjrPdMXc3lRFTSpEImi8LXJrFjqLVf799?=
 =?us-ascii?Q?mUzK3chI9Ato0HRd/d1Nt9sefHp6UB7X7L+Hzs4wCHN7XhTzy/OWmD3zORR1?=
 =?us-ascii?Q?iaOSpOlqT/7XqUt5ODxCFBpNFJ0L6SvsfMh6t50LTMLkNSHkhF+Y+aEG6XDb?=
 =?us-ascii?Q?GwtYo0vhlREgxWr4mq9fYQHovOor66c8cOjSC3oWh3jPW/Wg+JQZH6v0cviy?=
 =?us-ascii?Q?+2Nl3jlMxdXZ6x5sV+vYf/NRdDN1BjN7kMdP5c4hGpiMut21DLL2GOtKycus?=
 =?us-ascii?Q?XR38FwzAqNQJJQOl1oHVKKIF742efDfKoi6Rx2niBfv5ktgYxwmBBM8wQIWm?=
 =?us-ascii?Q?ucCx/fmvGCLlhaYj8PxlvD4KFueUuoX9Dx4NP7T6iRZ38oQZawPh2NDFktTl?=
 =?us-ascii?Q?T93y2V6XzvIIqUWlzU+liC17nni9RxECyGUzOx4gL/QnrU3D0f6YEbf228gm?=
 =?us-ascii?Q?h9qN2NqjNcOmbYpCFdyodgC02GFij/OF47ICYzQN8yzQm/XlLhynEowyPC7h?=
 =?us-ascii?Q?HqsDADI19QMywxRBrmlf89kWII2HrdlLMJaPqDe8q+QdEtEDdW9yClcz5Cmj?=
 =?us-ascii?Q?JY5+Dlltpi+NNTLcrIH7Q7PNnsQ9GdEWuzVps0ODN4GBtMi3fj4DCTq/oA7h?=
 =?us-ascii?Q?+G2BZQO/D9PWaQ8yCNbKxqYQjNPNEgACx7atbKj3YxUvHmewRk20cRgM+F1A?=
 =?us-ascii?Q?3GcKTDmPBLOrKhl7TGmqTBvcWYHsQBmQt7zoG8DYklqM02Y45v8VJrDvwACY?=
 =?us-ascii?Q?VceRuLcUzqaDt3cve7HaTWhJ0VwKoBwBYkuBh/k1/5HjpN5VJ/IW9r1L7zpN?=
 =?us-ascii?Q?TcsT+LqwRDCQxSwA8msGN7+cT3PIeUZNF5MkplamHvlI10cO9V8zlpBSm3Pz?=
 =?us-ascii?Q?XBdRtzuPRAy9tU/fRpZnRj2qkl+L9h/tNqDEwETRhwAgt8huXe1Dz71D8tqe?=
 =?us-ascii?Q?XHjF3KFuvKxsE0AqgGmdhqavAh8kRE/Eh6cS7g9b1vUzYdUj11bLq2zI0KLN?=
 =?us-ascii?Q?r6rNXHL1KjSZR/IcXp/PbHSbvhQCH6WgUr2K9tjjwd020GQGUdTy7sstaLQj?=
 =?us-ascii?Q?2GH+Bt0Qvash+7O4TcYJiW+DD85N53nESFVDrlgHKsRePCAmRmYgDbrR4m1Z?=
 =?us-ascii?Q?FzNf2+rUNZvpzt/vcga5cDtOP70sjjAjWmGj1Yp/iH1SA4eiH33bCXiv7AI0?=
 =?us-ascii?Q?4w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a70cab6-9a5d-4a11-5dd9-08de0c7759c9
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 05:46:28.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iego68kMxpixOlmjeYpbLaI2y1/yk7wUQw2xvbb8FfeNdnBLhTmLR5SLGasL2qD+DHEXqgMYJPdKYQiZMnA9SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8281
X-Stat-Signature: uypk58pd6snf3jpn7heiam6myyajxgwc
X-Rspamd-Queue-Id: 38799100002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760593592-212906
X-HE-Meta: U2FsdGVkX1+mbHO0qcS32GzWzy5V4Uxslr0+/P8L7nORgKk3uXw1Pa7agIUapI2iIYXsdAPL7hfOv6PyJfIdf4XuB8jEpan6g8mHoNl6M3eHcVh8NZgVWQZeXZ/R0vESVdtxyK/K/Ec/u8rpGxD7ndXAb6knXessWrp5OGZazXBYUCHUpr0sqoZUFFqTxmmirlQjVmgOT25c7w7CAzysYBp8KEhOVx8OI21B59BOQUvQt98iU4TZusZU2DbdGadKliG4tdOmlhDiXm2Rz5vP1iQNu0EX9EVQAsDtznr0Albua9+Fx/eMSqzBkqiCIBi4s85LdM062PwgDTzWsmXsZCx3fWLsclq552vb68s3AT4k/MvfExSBYJGiaWXDOTpijQiCgEIenG3K/yngmk3wNit8SZAWBtQQSI9JDspSBxC82J6lhrcaGemvfQp2qo8OzdMAFypaXEW27r/iHzhzlphkJV+uxjQhwMKAMfqAMCI1cPWLgbJIsTN69WY7Llvhf6Oxmu8mHwvnsPqcNz7d5qJLqT39l9snQxMr1O8AgYtwSspqViA6dpT8mmDbovsF6sil8h043oct2DdqqHhyFsFl/yaieXtHUcGr9FzGX/Pe1RgBVEE7a/8FM4aZ01WoItZMhVUOEOkMRAB8NRT5JOvhOtrZwG3rsN0cvF1MbEwMGyrmI4bWZ0xX4j3fsPc0v/X2HKlWtbOMfpthWCKU6ue/dfgjtVTC6aRG1smff1qKeGxOP1M0rTCXfeHvKDQlurmnY26+uT2sMDgpv1sC8L3Agf+HEjoyI/7/LzVAL3EnhwadREYMRkh+0C3dPHA4O4XpOoTsDlYMH9HPVWuWVY4nIKXOCftl1LHR4qT4sXxqj/XuDdJOj9jdQmpyuYxKwm3eVyRa9uIk14N7PasWpmVoAOh4LXZfr0vP9jvFzmx/FBG7JGTTHpf4g07FolcmYP8YtnmkaZccf6atpXp
 5v3TscFd
 uUAUp7tiIIESrzW7KfCoxPACghwDtEVlgcdxijXOYmMbUjfVOH70PLjQAId8zsWT4kxwenzEse3cjyLg+V3791rd/7oy7tYXGt7HhmF6O8eaVaJFvp6NdIdzPYWUKdROBzGA2X+f6C6D0YguqAx+c7ItfvrjPeuFCCRZHzpJO0y6T7va1TSP8Z89BMXw46kZACYRIeKYDX1guddgq3CU7yNh2dzrflOQMMG/xaQT6iB8r6hRBGA+M7agbc1chiRXQdgkp6gQxF9FBnCRTqoUh9gTAeJmd6BnXUpu5kFirWqpis4WVyvw2gY5s/kYzAv+MxNJ4YJTn0rVUsDj5Zx5yFA7BKwyQ3jFcRtteGtRUkWJWDw4bJ4xEfA47qxu85rmxhmUcYUZ0HKgfgfXOPBTl4D+4/IVXUnzI5Ud/4iL+BOS3eJERDPbjM8fNxbXRhcBQMfSGE22Ocdabl0eLZddQP+jsrPusGUcCr4N3plBN2n6gJK7/5GqsTtS71hyP5vdaOt0SwIgFx+7GlYdTsPfgXRxS9uK2is+LF0TF1+y8bgDItV/+mnLZ/HFnPjtb5AscJhPBmtUSR+uLXpxpDVezxJEQFIRAW2IJpkrHrTr7rKe7UEoHBxaQTBvez/YLutJWm8gBmsY/XMgfg03B41mJzWfu6lOCtHLjpXgKo+2tO+tDzKgA53LuEkirFzZUeFzMJFUABaGD9diQXyYzaRp0jy06764GAVw+h6H3LLmv4OdsQ1+P0cRvsWoztnifOV2QWerEcycqSx/gBFZo7J0hgjzxZ6QizKKJSB9CB6637vr7767TO3E5+ZylGNuBsC0whT3onoQHW+uTw+XLnX8pFKW6qF7nPoN6J1n1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tracepoints for debugging device migration flow in migrate_device.c.
This is helpful in debugging how long migration took (time can be
tracked backwards from migrate_device_finalize to migrate_vma_setup).

A combination of these events along with existing thp:*, exceptions:*
and migrate:* is very useful for debugging issues related to
migration.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>

Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---

Sample output from hmm-tests

       hmm-tests-855   [002]    50.042792: migrate_vma_setup:    start=0x7f2908a00000 end=0x7f2908c00000 nr_pages=512
       hmm-tests-855   [002]    50.042800: set_migration_pmd:    addr=7f2908a00000, pmd=dfffffffd39ffe00
       hmm-tests-855   [002]    50.042801: migrate_vma_collect_skip: start=0x7f2908a01000 end=0x7f2908c00000
       hmm-tests-855   [002]    50.042802: migrate_vma_collect:  start=0x7f2908a00000 end=0x7f2908c00000 npages=512
       hmm-tests-855   [002]    50.061929: migrate_device_pages: npages=512 migrated=512
       hmm-tests-855   [002]    50.062345: remove_migration_pmd: addr=7f2908a00000, pmd=efffffe00403fe00
       hmm-tests-855   [002]    50.062371: migrate_vma_finalize: npages=512


 include/trace/events/migrate_device.h | 196 ++++++++++++++++++++++++++
 mm/migrate_device.c                   |  11 ++
 2 files changed, 207 insertions(+)
 create mode 100644 include/trace/events/migrate_device.h

diff --git a/include/trace/events/migrate_device.h b/include/trace/events/migrate_device.h
new file mode 100644
index 000000000000..9b2782800ea9
--- /dev/null
+++ b/include/trace/events/migrate_device.h
@@ -0,0 +1,196 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM migrate_device
+
+#if !defined(_TRACE_MIGRATE_DEVICE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_MIGRATE_DEVICE_H
+
+#include <linux/tracepoint.h>
+#include <linux/migrate.h>
+
+TRACE_EVENT(migrate_vma_setup,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long nr_pages),
+
+	TP_ARGS(start, end, nr_pages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, nr_pages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->nr_pages = nr_pages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx nr_pages=%lu",
+		__entry->start, __entry->end, __entry->nr_pages)
+);
+
+TRACE_EVENT(migrate_vma_collect,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long npages),
+
+	TP_ARGS(start, end, npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->npages = npages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx npages=%lu",
+		__entry->start, __entry->end, __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_collect_skip,
+
+	TP_PROTO(unsigned long start, unsigned long end),
+
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx", __entry->start, __entry->end)
+);
+
+TRACE_EVENT(migrate_vma_collect_hole,
+
+	TP_PROTO(unsigned long start, unsigned long end, unsigned long npages),
+
+	TP_ARGS(start, end, npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->start = start;
+		__entry->end = end;
+		__entry->npages = npages;
+	),
+
+	TP_printk("start=0x%lx end=0x%lx npages=%lu",
+		__entry->start, __entry->end, __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_unmap,
+
+	TP_PROTO(unsigned long npages, unsigned long cpages),
+
+	TP_ARGS(npages, cpages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, cpages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->cpages = cpages;
+	),
+
+	TP_printk("npages=%lu cpages=%lu",
+		__entry->npages, __entry->cpages)
+);
+
+TRACE_EVENT(migrate_device_pages,
+
+	TP_PROTO(unsigned long npages, unsigned long migrated),
+
+	TP_ARGS(npages, migrated),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, migrated)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->migrated = migrated;
+	),
+
+	TP_printk("npages=%lu migrated=%lu",
+		__entry->npages, __entry->migrated)
+);
+
+TRACE_EVENT(migrate_vma_pages,
+
+	TP_PROTO(unsigned long npages, unsigned long start, unsigned long end),
+
+	TP_ARGS(npages, start, end),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+		__entry->start = start;
+		__entry->end = end;
+	),
+
+	TP_printk("npages=%lu start=0x%lx end=0x%lx",
+		__entry->npages, __entry->start, __entry->end)
+);
+
+TRACE_EVENT(migrate_device_finalize,
+
+	TP_PROTO(unsigned long npages),
+
+	TP_ARGS(npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+	),
+
+	TP_printk("npages=%lu", __entry->npages)
+);
+
+TRACE_EVENT(migrate_vma_finalize,
+
+	TP_PROTO(unsigned long npages),
+
+	TP_ARGS(npages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, npages)
+	),
+
+	TP_fast_assign(
+		__entry->npages = npages;
+	),
+
+	TP_printk("npages=%lu", __entry->npages)
+);
+#endif /* _TRACE_MIGRATE_DEVICE_H */
+
+#include <trace/define_trace.h>
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fa42d2ebd024..c869b272e85a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,6 +18,9 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/migrate_device.h>
+
 static int migrate_vma_collect_skip(unsigned long start,
 				    unsigned long end,
 				    struct mm_walk *walk)
@@ -25,6 +28,8 @@ static int migrate_vma_collect_skip(unsigned long start,
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
+	trace_migrate_vma_collect_skip(start, end);
+
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = 0;
@@ -69,6 +74,7 @@ static int migrate_vma_collect_hole(unsigned long start,
 		migrate->cpages++;
 	}
 
+	trace_migrate_vma_collect_hole(start, end, migrate->npages);
 	return 0;
 }
 
@@ -517,6 +523,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
 
 	mmu_notifier_invalidate_range_end(&range);
 	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
+	trace_migrate_vma_collect(migrate->start, migrate->end, migrate->npages);
 }
 
 /*
@@ -748,6 +755,8 @@ int migrate_vma_setup(struct migrate_vma *args)
 	if (args->fault_page && !PageLocked(args->fault_page))
 		return -EINVAL;
 
+	trace_migrate_vma_setup(args->start, args->end, nr_pages);
+
 	memset(args->src, 0, sizeof(*args->src) * nr_pages);
 	args->cpages = 0;
 	args->npages = 0;
@@ -1259,6 +1268,7 @@ EXPORT_SYMBOL(migrate_device_pages);
 void migrate_vma_pages(struct migrate_vma *migrate)
 {
 	__migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
+	trace_migrate_device_pages(migrate->npages, migrate->npages);
 }
 EXPORT_SYMBOL(migrate_vma_pages);
 
@@ -1312,6 +1322,7 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
 			folio_put(dst);
 		}
 	}
+	trace_migrate_vma_finalize(npages);
 }
 
 /*
-- 
2.51.0


