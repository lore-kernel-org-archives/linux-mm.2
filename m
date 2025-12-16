Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 990A0D609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0F7B6B0005; Tue, 16 Dec 2025 11:40:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBACF6B0088; Tue, 16 Dec 2025 11:40:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2206B008A; Tue, 16 Dec 2025 11:40:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB1256B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:40:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CE21C0744
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:40:01 +0000 (UTC)
X-FDA: 84225896202.21.4BF1846
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010018.outbound.protection.outlook.com [52.101.85.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5C918A0012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:39:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Npo5bBfb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765903198; a=rsa-sha256;
	cv=pass;
	b=H6eaD7uowvIfWB/fwH9rtpz/ahziDOTYaMmvIZVYad7W2IICFNCR6SqSglBp+lWXNuPwRI
	X+dRaj9d9kDT2cCR+y/Lf+Pw4dqo0yFg6+m0tD6oHuO+khtE3WOO0oKtuP2EkwMTDlJ0AX
	AZ1K3QVxMxhJOXAn65YEK1h9GQfGaqM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Npo5bBfb;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765903198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZseFmkM8Mggu2jdmeVUphRKdgNT1TS0flDlhMrjMS9s=;
	b=ckrMIrDO4GLRdi5x3LtbxXGyuXpp0TRbdjUjLHJY1hMfti3FSHxZIieGMkFjsOLKEOn8CM
	FSKV39fa38oS6Uh1YfmPv0lyzjHV3qpodzDPPX0FD+9UgAYwCIK081ITgYFWu720UX7Fcf
	VTE2FkCr20gcRiTxQgO2FR5mX777WYA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVFRA8ClMCF4uOi6xF+IVXym2tOt8Yzys75DoCWWQ9Kt79gkhKrmwSfdqH6plSQ6AwZFOwAf53eFdqrpi8x00WmyXedSBoP/aHxRq9V2XuSa+BqeYJQ5CDPSOl5bFGg0RDayje/+tUZm2rt9oT2/+Ptl5MlSyWbw6iGsHNAMl+0kej6vapqkQlRY8Xwr6QOUPCWFZigreoM6+PPbt+uRWDDi+l30qfhfGaLPjMyJOg4KARdseT8U2Fnx+nH0vjQ4+gRzXLB4BoAQpwYXsyNL7OpkfAmnj/oo5UwcA0JU0T5k0wM/RTWluKunkhTs+xj64e916z2HXHK7veWvxCLC/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZseFmkM8Mggu2jdmeVUphRKdgNT1TS0flDlhMrjMS9s=;
 b=ZgsFmA8uhzNybMUawAzcNfjH3d0B8oGC3weQ+tOBjm9WuSGKF+V46a4gaZ3Wv9hGz2tErU/qC31nGuWGHCc6d8MfHbQLBJJb2AfSKlb5NZl2TqYkHtygKblTFDR1ihvUXAlE6Hj0YS/V2jGlnxEzXKA0LiM4u098tY8YX8d4EnSNup1uiFA1NupdfQm2hNL/dUVQJUW6SIgiJZePqpKaOnwUYJiT/LiKH9Bvfwm6SwapCbi6w48YUl8VTQAa2X8n2WKBUxjwcHTbAN9fejOflIQGD6mDZXBQhUZDiirza3zQZ+wYfdzhJnI2/2jiy+U1HOtV4xT+BMOYhSr21MGYxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZseFmkM8Mggu2jdmeVUphRKdgNT1TS0flDlhMrjMS9s=;
 b=Npo5bBfbMVG5mj23/2f/eBve5o+mcg2FNLwhbCd3Tse4ImV/qMkgJV9Hycllinon337/CR3rGusrjDoE6Fo3ZzOn7wg4c3bSSPQeBoHrXIpIXDf2W0fMRmBM7tUbs2omRCtyVa8HDllqLV5yRBVEmCXioSxFj2+XiBmmr/cEXHdnZIKQuDA6fRYWxFDNL2kkHvw4xqHXyqB0qAOv4Xiii9Eysk5ZOcA0DTAObjJEYbiAnjgNJKL0jhrsGaggXGjX2Fl8kUVW04wFPOseG2CcVfzJl13+GQ5xWclqsphx/ETGJJ98rv/AcdUFthwQFk43V2zx+E36yUTfGgaMfRnsiA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7338.namprd12.prod.outlook.com (2603:10b6:930:52::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.13; Tue, 16 Dec 2025 16:39:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 16:39:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v4 3/6] mm: cma: add __cma_release()
Date: Tue, 16 Dec 2025 11:39:48 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <AACE333D-DF96-4BA1-B9E9-EB743053646A@nvidia.com>
In-Reply-To: <20251216114844.2126250-4-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:208:52c::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7338:EE_
X-MS-Office365-Filtering-Correlation-Id: b95ad53a-1a2e-4f1b-a6a4-08de3cc1bbb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1+r22Z/EwSPb/LvbKAwEodZ3AnLc1cXc7aujoYtzcpJtImTTu2bt/8JcwRO/?=
 =?us-ascii?Q?dEBSi9jVoM+erEFJOoqzRT3DO3FI4bKapWyQf+xdjR2LtbHr2JSg7fxWA6T8?=
 =?us-ascii?Q?/GdocZAnpWvHlKWzHgjs9IRQ/ja3Yx0dQ1B2JFjCpSuqmoiwrkFIced7JcZO?=
 =?us-ascii?Q?2Hy7wQuYs8qgo625LMlgbgvnujO4XJDkAW1vLbLxTprJozKHvACSqfFaS7t1?=
 =?us-ascii?Q?qnG4VnyixFyer1ImRuO4cDFqRqgbeQregiwlaxyM/VxYaZGkEez5RyBQmM9u?=
 =?us-ascii?Q?6Kg5Ge2WHRipdOzVKyB2AOZKPtx7i/FgvO5h+iBCnO7RYxNby8HOLxeP/Pq+?=
 =?us-ascii?Q?Br4XzBw6hvh+LU93tM3RDO0aw/uMCGioZC5CM2zAa8t7+Rda44lBEWQ9durt?=
 =?us-ascii?Q?yNe5OU3TG5SgEPsH6Z1qcRk4+19x91acqaldt+rCIAKxLKq//UZqkZXviss3?=
 =?us-ascii?Q?aTz4gzgMiW5DicGLGBUnDRgwAw4E/p2jj5Jn9/fd5QWhYsGMqEz2E9riRzdy?=
 =?us-ascii?Q?D223o3DmfKN0xlXHTV/aMnaJta28iTyUU5OVXKA9PEZn5tWpyXgBVFWp/prP?=
 =?us-ascii?Q?WE8qsyLJp5LiiMUwHPPMEZ7NtAqIfhANX6rzXb/Cj38CC9PH1VBg3DVNGEa+?=
 =?us-ascii?Q?vjApfzMnNgKOUugrmYsu4l8W5m6IeAbHMnh4rblOLsii04XJhhvALEEF0IHp?=
 =?us-ascii?Q?9qQif9TD9FWVH+7mvpnE9arAzd36GYIqpc1tHmWapT3bbzIus4tKue0O3pCl?=
 =?us-ascii?Q?TqR8XjkzOGCUvOvAxdMNHT2HAIlpoP1eUYaEEISVWOva7cq+X3RcHjuLcaT4?=
 =?us-ascii?Q?69y19GHDMKdYugcozUJ66AEW2iB/SEdvZo62tDj3iCzDbSUEQrFKULBmuLpw?=
 =?us-ascii?Q?AdJH4+QkbqTLShaSoXJdULMprLaILLxJVC4jeLs4h0o6ECAVFNN4UxRn91Zt?=
 =?us-ascii?Q?dZwHKpoksEXY3PQ6AiFS+aHgSN2/35788pqTR8oAA0JJmsXBNdGR0kECTsIs?=
 =?us-ascii?Q?nYqHwkO6EQvQ6LNTRNtPuPOQpYnvpKpvLFzD26CURtZFjtPPAavTW3A58Hkq?=
 =?us-ascii?Q?fOrIX2z0r29DHD39yT2be+BP0W0iPU3TtL8c7OS75N1Zrx1Mt891t99PBQDS?=
 =?us-ascii?Q?ncbC53kop95IbVet98o84Nu79Grh8O8LeoXuFCdSaP+7ZaOcxye8PM87O2G3?=
 =?us-ascii?Q?xpGazOXQYFTO0/RPpLPY9/GH8dxxYcH6O1xClVXslDs8JtiBvUNdFDGq/B64?=
 =?us-ascii?Q?H2YhHfr2f1d6gKGYJ0jHWRLSsjDy5X/VG5MfjqWhbqbLCtq2YPGbtaMVyF2P?=
 =?us-ascii?Q?wkYdHVmpNDax3Bf33e2k3PTp07IfAxOhjkxkU2NS9yEBSOJNRouIsNfJFLgY?=
 =?us-ascii?Q?olJ4LabZ6b/5Epksj5MbgP/W5s860WnL+WsoojECD+WmBevqDZpvhwKX0+mM?=
 =?us-ascii?Q?kAxcQLoGY1l80JvcHQUmc05mQgRvNqGJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?baG0sLv5OG+taTQCJwjYV6R8dg7wE5ky82406dtxvD1mfxKyR/swgXcqD5VD?=
 =?us-ascii?Q?yEiGrWQN+jvRUbLNqHd71LLrfg5rLqVLgfC3ABIvBrR1MHGG5JfEqG/B/BNk?=
 =?us-ascii?Q?+88OHuAo47Z2p9PfI8n7hqrm2bIe5Wtc4DOmMIsXozvBDaAxGDDVjLZhrO8t?=
 =?us-ascii?Q?vsn/gVn7FzsIBd4isajBKOjbLhWgbdV1GkLBqpIGSCV5Q1GEW955AloZdTGa?=
 =?us-ascii?Q?R+qkxZlNmQLCarJoc8vj9hAZpjgeGusbkn03fdxMo0Z0j4tkLNrQTRHI1z65?=
 =?us-ascii?Q?VnJ64eVF3vbQkpQtiHOuyrrbDAfwMdSHwWv5mRqvZKIiMKkkyObU0o7as82x?=
 =?us-ascii?Q?+sjOnZMds5AaEtzz12uYRfMHpiqs88SGYq6Eqdoi3SKRwcdZNIc0IxlV3ZaU?=
 =?us-ascii?Q?TmPo0rlfnjjeOEx4ASY5nPMlFCUcRldE6Sqay4n92sSt3cjNqRxxifW8vkV6?=
 =?us-ascii?Q?vSiqjzqaVwueHbocwfs+OkMkEqLUXj333GpGEMNgUGOrErXcIfK5e4sLUr/G?=
 =?us-ascii?Q?FxxUUGZAwxMPmKk4KT4Y98gntnO5i7is9aRu9IIE+oz3hlY0Mplhzr3KRmam?=
 =?us-ascii?Q?7ORYQONO6gCa9xZL1PJU7CWM3r2KP3hUq5PCdZdMJxLsKRYNUu0oqczyqRac?=
 =?us-ascii?Q?izbGhyhepqm3PsQc0aD0dQ9B2DiAoA7id+v5R90qltyBJYZNa06WTkIZuCNA?=
 =?us-ascii?Q?OZq3o+T0EUnvkMSdcauJdiaq2MsJwoB0EShRFVLGaM8Yhgiz7Xlxt3W1sG9A?=
 =?us-ascii?Q?hGyOnP9P8MWUg10G75sCZLua8Bi+vkE4A+2fdzpFCgXwibCyeey/g/p30rgN?=
 =?us-ascii?Q?afH14dI7M+eXTq/vShmd875haR+NKikN14MjeNgAP7+1yhb+wtLeyxHcQxAu?=
 =?us-ascii?Q?4q+J2Q2/IKUDz+lDbOj4gyUkJTmJjduLYgw/NcYNNOERn1GQzuq6g4ueT/Vq?=
 =?us-ascii?Q?nJa0RkJkO9QHgsuipgrBFdDZ8s6Iji8NPyeMzkmPO6OSCgVToRFkjgOPvHJM?=
 =?us-ascii?Q?JkywF1ZHr95rN2NCGWxppcDB2p+7Kv3xzEV9gCzwjC4fjO2/bLwJ5ck6eCTD?=
 =?us-ascii?Q?Z/ptgeqU11QM2dIDRXwUVyid7gpcpexXINBiwCFxEx+oukR47UzTp28gYLWH?=
 =?us-ascii?Q?oCI6ma5KsxMPbOwD1ZKwxlnrBMRYHwy/EZOyjbRRGHJLM1WXamUwmh6Rd49d?=
 =?us-ascii?Q?1a53pWUdKsKKVuvqJM8sG5g9h1tkhU8M8Pk9lu39vVu1LuY/4z2xq8VFrREJ?=
 =?us-ascii?Q?AmL9cAK4JsCRdNOpKh6IAqr8Qr9wNZzBGb30ZwHJQpFNVz/steeL8iqtDifY?=
 =?us-ascii?Q?2+OQ0VD77WgyQ6ZJUYY1H1wkFaS5AxrbYC24uRNs4fejsTxXX+awwWSeGg29?=
 =?us-ascii?Q?LHDyh1A5Xfj074O+C40AWMYpb/hIsDoS3Ri12x9dx0u//EIW4i04gBK+9njt?=
 =?us-ascii?Q?VYgosVygTN1DGvgiYTyCqfntVYqGsImJ1IVaTYTy82BT6eXR3BFCca5drNJu?=
 =?us-ascii?Q?SF5TTW3GkzolqmoB5d13oOD8w53SnerCItfzMP8ivRPWEmnOX143BicQlNa5?=
 =?us-ascii?Q?33Y6TjMXkboMWhOiHVDw01quthmEme4S3DvauQki?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b95ad53a-1a2e-4f1b-a6a4-08de3cc1bbb2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 16:39:50.9917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I62qy6jn6ytTdevxk4pn+6bq+ByVdkQNP1CZgftduYfZw53M169yOnM/h7JMXlrp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7338
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C918A0012
X-Stat-Signature: zdug1efcwfig1x7hgoqoq53cot1je7hq
X-Rspam-User: 
X-HE-Tag: 1765903198-613627
X-HE-Meta: U2FsdGVkX19ibZFxlLflmE+JRcIYMJ+Ybf4M8JKFnBkyWuWAXHN41ngW5f2Bk50Zm8NmpaEjPd3j1ifgueri/avPd2DMj+3p4AyPFp2jO+l2sg0KugVD9n1SyIoVLJRSo9oNuwSR5R3c6SZaR2xkl0TqM3ug1N+ztr2te27t4z8dL1kk6BVYrXXTZccpMR9Wl3mfZWDLMk+cX3ZyeIgYqFkUAMa+8hyimR2XxtnD50nNwRagXDzI4jUBX+fpaopPbgPmbZoGvnveu9XNOLC3/6w2bodEKW7e3dcAG1OZCHYUstI7l+TwFphCh92clCpZv85LD/4LqFnSJMpdw9kn4CUKy6QR3/Wlddq2ffPzTUYq1mqIAAfi0V7KzuM8sFs9hl9XC6xmboxcYn2QDwfw9xsXPlC40LSYDP2C7NXj6/FcUI09EOeS2Unxa7ShaXcPIDk3IeJhdS2yszduTZIuYU1t9pS0vknpEuOvJJUUflmZeaPNGRye6HXPVwmmwfiC+UwlDOZFbU30xSmC+qpBwa5hoWmJPO1zerw+a+uluIe+ZeKoWvymEOTmCzOiqT1hMy9swlmTJeD/Ag71to5hkXfQC0ZVFnWTgZxz4/sfzewrbXjGsqsjrPdcWLQvxvtXPB3ReKUHw8HSD1qj/udk5EBIofqNYjr7CafOabkrOyG/V1MfEFmQwyOVIJ4CqyrfezhXByRIEqpkt65FNGFPNmizpu19LUvjvCeVxMthU596sR4DuOTUkislJhuGyCbfKCa2ZPlpherDKIwcT7cdn8H/3j4ESSjDnagJTnTfRScrLTJuksTUkKncMahNfhNoqoW9wweFMOJz3LgotWoUflBNKSqqwuMNA96/s9VGgjtdMO5EU41AZrddie3GxGAlaVfLo0eEyAHgZNkLKcSqKNWLDAv2ZwBba/cZzjk5qErGsAl12jVeba3bHE9XObb7JjRk0LZ8k0dVUWCALFU
 IAQmEsI4
 4zJKId9AZPvVDE3mCAVDH8xl67YGyo5ebQFf/jAYw4b9Two3XqaCdUY2FWOPE5n1BjCF44PKjEWktu3fPgCQWFT+eQdTkDk0aod2uL6Y0Vc3zziLk3N/ABU5PAcJWPSI0GvHwdZgehpfINkMI2LhFIQOlhaOPyT7Nw4DSSIw/poN/Qz+SE1mokWQZjk0Nz4gJRANa3SXEeqm4t1DKdYu8TbGkIYuCmhczSDd6fCkWhOEO34UJ8Fpp9x5WLP+M/WuCfQLYgyA2pnj64WW0KL8BLsQ+k4Qnr7qQLjFPKRaFPevRprpp5hEXH11O9VUikuePQ16YFofk0qOk/962LEhRIWnEMXra/VFEBiptctF6jQXipxkc9RIiA8OBq/PwRQRhKlWCmL4vhJiB0hGJcl1aaYHimf7AU+CRrd5VZ8StaD8ekumx5i4v2hWPE7nSq7Dt255vFl+6e+qZ9clQdUeVXvEKOmAAmO8yAZBJeDVt1bWLIT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Dec 2025, at 6:48, Kefeng Wang wrote:

> Kill cma_pages_valid() which only used in cma_release(), also
> cleanup code duplication between cma pages valid checking and
> cma memrange finding, add __cma_release() helper to prepare for
> the upcoming frozen page release.
>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  include/linux/cma.h |  1 -
>  mm/cma.c            | 62 +++++++++++++++------------------------------
>  2 files changed, 21 insertions(+), 42 deletions(-)
>
LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

