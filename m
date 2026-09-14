Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF01C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 02:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86846B009E; Sun, 13 Sep 2026 22:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38226B009F; Sun, 13 Sep 2026 22:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD6876B00A0; Sun, 13 Sep 2026 22:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 867546B009E
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:24:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89966C0EBB
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:37 +0000 (UTC)
X-FDA: 85210774194.21.43CE371
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id BB95B180007
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:24:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="g38Bk7h/";
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789352674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HasRKPn3UDqP5j5UF+LW8uyeu9a77x8SVglJqgdfW8M=;
	b=M1gA2NkaPH1Itzx2g4gOLFmi4SnQQpOGFrzEaduzpxIJz050hr8S469CeIaSOR9W5croTp
	kNmPcA5Oty2B+lSHzYiD5chXlQpV84YhzZ588SsIq1j+oE3mSUiaN+htxqcPEC+Rn0WAZz
	d99Rt6SdW2zEPlcYvTAkSkv+ktoHTkc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789352674;
	b=utzvLZ89fbXl8DuHKlc8+OT6FkO0gRJAcFrJfyclM85f56eg19A7A+tLyDcUSdoZvzXS8K
	QlKbMLc3kJ+m8+8eGbgWjJwyh0FYWWWT6gnSHm1OCO1Q+934TP5AJeF6pgTmAwtLZv85Tj
	Ue8Zpx9zVn1FRLDs4mtrLaVOTd0S7qg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="g38Bk7h/";
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgp73E2sj2Hv8jbKvCB3wBmyHiHwJEmDetP+5PkqYMUR9Fk5EIU7G/GdlXqLO+5QGtQzUrnUfFFsqTGdeP2qrqx/pj2GUHD8AT27gnX3HfnIn+JE83xhoweoUsrUNw8ziOfME1gmdcE4O++04MSj5Pe6GiwRJLYjTxFav/uVsy/XWzDCEQ+BH+hAqQKH3yoEeWhQD5T6wZ+vM7+BZhqCQ/KcANKQlhl+8ptifrCbVeoQkm8RuuNiayeFT45d9uNw+0+/Gb+b9xQP/NdXD40x7Delvci1dCONWG8VZEdoVe8nCDMGTc8FF/EG/ZG0iQkzMBztn3WiijlaqjFdpJrFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HasRKPn3UDqP5j5UF+LW8uyeu9a77x8SVglJqgdfW8M=;
 b=UitOy4NiMyJ5pSoAq1cOwAV84ygZY+PUivIk2AFcKfb4H2bpE+sh3dwqbFaffNYAHSVz2evzM5TL8ANwzqr1UkKas0iacVDNZgv22698bCrpocMWtAIdx1Z1BePsJg0aVm1ZtK/WDvFuzwd/X8d5gdgNjQdamNK9hzAxWb1cJp5c2N28JfjqHRk/f9LT0ybXvPYxkH7aAx9ox+J1Si9aFMmbfSPesFitE7X+FQ6X0oJZYo8qgU/uVXP6idcxlTh9sj+FOOh3uNNGyQeEbBKzoJaHE+qVo4vhZaA4GBSeXIH94RFe11RMl18u90w2WBd4HUc9AOwaQJxGBaLxOI2IWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HasRKPn3UDqP5j5UF+LW8uyeu9a77x8SVglJqgdfW8M=;
 b=g38Bk7h/2nsGglUO9xeMYGgeizJzm5ah0Di5VUmdcxYfq2dBlujfcuV5ZwwG93JCLbPQPbRYKBW+KetYJEOTmaVeosWdZCmuAsG6COLF43C95FJJfCpBaniiwn8zq32GKOzle5XTqsk4Z9gS44zMdodhQghVomU1zVQDtEiDTetgRbLOGqEHWPmJUqhn9PocD/AaFAcchRyeU9fTLMc1lAu0ILIkkOyV21zy5wFRiO/IN0Fano5tc+UgCGBXgcNDsF5FD6oHcN4r/KLns3oBKBmMIa/GT6dYRv5lq8oLFArzxcwpTLm6HRFFjchjpZFOmwflfFj2TihPXQ7LDRUWRA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 02:24:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 02:24:19 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 13 Sep 2026 22:24:04 -0400
Subject: [PATCH v4 06/16] f2fs: stop using PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260913-remove-pg_private-v4-6-848550f7574e@nvidia.com>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
X-Mailer: b4 0.16.0
X-ClientProxiedBy: BL1P223CA0019.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c02016-ad4e-4665-c382-08df12074840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|366016|376014|1800799024|22082099003|18002099003|921020|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	6xaKpcsb+7Ggr65nmvoxRDgpxTIMa9AX/IXn9IPXGPfIyAQKocr9uNvmxMcACkfekf65Gtndru7w/M37mKzP338ZfYTjrXx41F37EKHKFBrgP4V38pD5tiItTUWHebqKl0A2pp3+jAXgsahSBAsTRISuC02Mnom2LZrrua1X8Zwq++LPapoDUhdoYYgP8o2WSLbJjEbE85RQBkMnW/tZwUsX4aCc2T0btH7lSlr7G7FcVe0lJYzor1yXRcyee2+TkQYCnCnd3ZlpKRdjYSuZGEeuNdYnI0Tu2PIoBUyues3P3gnNepo00LjvN+C9LLf8a7YU+TuGdsS3ltxiNfPTMIFWRtRkW+ND96JmPsWKh4MFDe3jJvLMC3ohVVY/fPsWenT1AKapYxc/CGUkACFJ/zSopHuPiKzFAApu7IRxfzZre71YyfmMSU7IW+3BAsSQss6oXh0ZK4yGNP4sh2FjD55zjNmLsb4xVuwsnMQRRwj89HrbrKhFu8SHpCdeJo1MFsP8Xhx6Th6ye/RgsUUPM2rE+sBBTHQtdode/PDL8M0Ax0dmlaQkHm/V2ZRCYX6L/iDrQLZQJwsa2gJB3tOnjlaHXqvj/1RU9FrhK9Cn10iNb07OhcrlR/dgObGXcl9IJBFh4N9DpjP4f59wS29dE+/I6dbIgNK9MMFGMaT2wp+YYRLJ9pYvA693DCIunWZWA2+ygME93Fw/0QBrpHF28w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(366016)(376014)(1800799024)(22082099003)(18002099003)(921020)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU9YYjd1SDNIMXpScGtUVC9EdU54dElhVmdoc3ZVMU45bnV3bGMrWTNMM2Rx?=
 =?utf-8?B?cjdQWE1kZ0FCOTJxWTdQK1ZqN0RFYUVHeitHUkFKWVJXMHIreWo5S3pjcmY0?=
 =?utf-8?B?S2ZLcEVUc3I2NXM3NE1NL1p1c1ZuRVo3ekdyUWpxcDhyZXhoMVFFdlNJU1Vq?=
 =?utf-8?B?dWFrTmthTEJRWE84WjAwMk5iUXNlT3h2V3k3WmFQWXA2b1NxY2NpR3JrSHhR?=
 =?utf-8?B?NXF0aGw4NDhDSUxzMDVrZUhkOFZqWko0RmdPN0ZsdzJUTy82NnVQWnVHUzhQ?=
 =?utf-8?B?MWZRZXhqOCs5Y25Vb29hczdlem11S0VyN2MrMk5iSUpmOXhNNG1ma1BOMUVI?=
 =?utf-8?B?ZXUzamRSdnltVzRXU0R3UWxHREEzNlNQcFJxRGNSeTlydytKQlRyNjhGRTdZ?=
 =?utf-8?B?MVlzdkpSQ3lHVmhhRFlaaDNTU0cwM1dSdFExUHhTNTkycENUQ044MU5aeWsz?=
 =?utf-8?B?V2E3R282VEtzNm5oREJlb2x2UWZ5TjFvNnQ0RjN0MlJ3cEtYWW8wZGpuK1Nx?=
 =?utf-8?B?ZUNZS2kxZnQ1dTVjTHhLak1XZ0o4QUxrT1NOM2F3K0VvaWcyMllHUmtjMDNt?=
 =?utf-8?B?WkozNjk5OVBDdStjRjZ5VkZKb0dyVTZhL0lPVjhOMkVDWncvcmQyRi9IRlpH?=
 =?utf-8?B?WmM2U1lzVFlzLzJKOHl3dG1SWlhSM0hCcGV1SEs4SThGZnEzTWtDVDBTUXNZ?=
 =?utf-8?B?Z2MwdDBvelM0dHk0Q01XMC9GVi8xWG12UHZDM2llTUJjdjJCeGVZQ3ZocGRP?=
 =?utf-8?B?RTJES0g1bTRxVjdXbnlPZGc3MndqUHpKa0xkQkVEeTlzU1hDK2NuSW1nUWx2?=
 =?utf-8?B?VkladWNFL2VFT3NNNmhnS2hlbnVjNFd2YWJsUjY0c1JvR214aTl1UmVPbHB6?=
 =?utf-8?B?M1lCZ3JHSzdpNi8yVmZoMXA4THNHZ2ZPbCt6Ym5ncEkrcW1WTlJsYURna0NQ?=
 =?utf-8?B?VitaYUEzaXNsSTgzakhqMi9qT3Q5QVRJYkJpKzY2ZVV0OFQvbm1KS0dZUGlX?=
 =?utf-8?B?MzlORTVjalZrK1FRUG5BbzEvc0I0RUdwUTgrWHE5VmRnR1JYaGdMM0d2NHU1?=
 =?utf-8?B?eDR3cTF3Zno4aFJRbkRuZTVqaTdEUHdic0greHcxRlNPdmt0MDY5RlI5ejJm?=
 =?utf-8?B?Q3diU2JUM1RqbTZBNkFhWUhFVzZpRVhpSHBZZGNYZWpCVXUrK0dVUzdSbHIy?=
 =?utf-8?B?TlIzeVdiQkZxemZQWHRoMS81U1V1cXV2N3hRVEtCb05WTHR6RjNPcGZLNWlN?=
 =?utf-8?B?ZUExb2dQUXNCUDRFL1QvMTQ5YTRSdU1heGtJT2NwNGoyT090b2JRNDlxUWM1?=
 =?utf-8?B?QjI0c1A0citvZThac3h6V3EyZTNKeFhraEV4Y1NUVlJkdERrWEh3MEVrNEx4?=
 =?utf-8?B?d3JpcCs3cHcyTjhoNVlCU05mQ2wybjR1Sk00eWp1M2s2dWhIV1JJK1NadVFQ?=
 =?utf-8?B?K1FCWVRPbFBGRERsNytXWTY2Lys4SmlnZkV0SExDV0pHd05sMCtqdEg0eS9C?=
 =?utf-8?B?clpqTStYVVF5L0d5dlduYW9OQnMrNjFMazZsek5aMGQ4WjA1VmFnU0lIWlFM?=
 =?utf-8?B?d0tiQU8zTStNSnBaY0tpTnh2Q3ZLNm8reVVhV2ZrNi9vZkpGZnVjc2RXNUpt?=
 =?utf-8?B?RnBIK2w3N2h4MTgyZWlzSC94bDNCVFpGSitJanhBSk5wNnA1blpJY2xwamxz?=
 =?utf-8?B?d0tsRHhEUUpNaWU1SkQ1ZEJ6QmRTMDcxYU5lVGp5ZDlLTWFER2trVStwSFk0?=
 =?utf-8?B?Mk9ZZ1lDL29XWmFvZlZ0eGgrbGQ2U1Q2ZldyTHkvRVFaaU42T1UxbEtpcC9x?=
 =?utf-8?B?d2VVdVgycjg0bGFsUkxtTnNlMHlHY1MwSVc5WkJBOVhFaVBodkV1dUJrSFZp?=
 =?utf-8?B?NU1MWFFNQWtXUGc3Smh1STIzTXByMUMrYks0bEQwcmQ4cGdldURHOVpVZUxS?=
 =?utf-8?B?dEVGMytha29sWlhZVUorbXh6NTZFRkcrMVdXVGJyaUZ2ZUVSN0h6bURuVk1y?=
 =?utf-8?B?Y3NxMWNZWkExdlFrYmphZjljd0UyUGhxejRmNmxzNlpKMVB3NEJKOFZzVXIr?=
 =?utf-8?B?bFVSQjJGUTZsNHF1aVBzc2F6L3RCVUkwRm1jalY3SVpSTTJ2SmFFVE9MaldG?=
 =?utf-8?B?a3ZqVTgvSGVKWkdsTEFndkU1amdyT2pCRW14NEZFdnBFbGdqZWNuQjEyK1lX?=
 =?utf-8?B?aFgyZlMvcklFR0JHb2JPVEh2U2JKSHlKYWtyT21qcSttckx4aW80cTc0cEwy?=
 =?utf-8?B?SE5DSXZ2WFNzdGtqcmF5MndRZ0VZTG1nTXJnajNTRmNLd3QvUitUeVlGUTE0?=
 =?utf-8?Q?Xl9gqi+Fj4JiNsIQOd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c02016-ad4e-4665-c382-08df12074840
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 02:24:19.7050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbwsFzFzPyqTf+fHpyVZmiBojpPjl1DMt0nJVyjSaSoIIOthZ8VwvQjvhySIKTx3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB95B180007
X-Stat-Signature: o5neopzfpd4agupo386ecf7ajbxbwep7
X-Rspam-User: 
X-HE-Tag: 1789352674-525656
X-HE-Meta: U2FsdGVkX199BfJXqT8qVm/wCTYJG+nMUExnUcGRHLbluG4SVzx+K96uFqWhtd4rJUtA3NHxltlBKMHBBjb35kU0mQtSOsqG4RbaSX+prQHZuREiIVSTHc90Ciy4AuPloojoTBbEGMus/ZMqJGq0AEULGs1AH9DeD7v2FaCjsmMeYPYUUCLSf3tLWfw3GEM6TnR5y1bo7mCZ3v3Itfzqk3Q1XOtFaNHeMcMqhdXMrraMjWFUA5S9XU12FDj+7BMWcN5Isqzw/BuR1TMcewiomy9V6bNjjmrLEDyHz/zNub4FyH0fRwc8uNmgSYZTc7TnYaCXjr93c4dT1IDFqZ5d8Hkgx3QsV4UCKj36sxgdRZ1iIzt0wnX1NA1f2gbjrxsY82c9tgdUt0rv+hSW/mDw5uSXJ+tfddVzH7/ckws0jBxO7Y0p98E6NpQXrhhD9BgFAP/J2QFqdDOUjrJSe7kbn7KzJK7o+V9UYT+nnYoQwmzp0Am2bgx8QeaikrTZHfjybcX2I7MUw1qI6UJiW1uL95KsN0QrU0hoVC7UBmpkGoaaq6CVVd3V+8P2hoQDejESJIwK94ja/FwYIh2cUlIw766+35MGN6vOxnniSp5ROEDmJpOG3fk0qRyYzIBEu/NNk5uGDx+y+yy/+Y/K/0NQQD8G3xszrDJDmJ/XcJebY7PQDE9r3uHt+41Zt28kmy5UJo+9a4ehKSuWMyshFOA5JuUS2q1XxLqjQ4ihc3Ona21RMzB3KriHChJrQ09Ywt7tvw3gLqC4hJM56asymh6OcST1GWUT1z3S0mvcgW5FCxvcQwtP91TWkapknu5IwHg6HcPqXdPsreFPIZrjVH30Z6t2wH7CU0lC+dR2V9K/yOAmHWFBjPY8BUaqY7wCmpSZlUptQCafc+LdtIqYphNIWdhsy6l+Y6Wtu2U/z8WyNUQV25mTfUeIcoae5o904XQdBp/QxQoODUSqHcYtVqa
 tB/admNP
 u1gGCE32UFwltdBXKKQt0AV7rA+kP/B0JqEEXsnhRCENcgf4MgPh2+CNtL2d4AqG9qFqqvVd0THT0X/rnVY5gfxUTRiHuh9g46T58Re9grlFe8A4CcSvq2DcfG27gKiZ41195JFGlY82pLC9122PKuRZjEdBzECPWsNAXTnPYUUtor1LYxpSZNFShrOYA2SAY0nl2lxr7/cJj/5jnpGwUlh6l0xLnD6pi43Bt4fu/KhYAQ49wfgYQ7sHfYSuNLS0cC1OxNJlDp3XFKk4bMeO8x6lNwsp+OxTF1Rco1XG3uLpSFbuUTyJUR963CUNf1FCY0lCG0u//jCnehMWR25JHGOg32gwOQ/FjANbbBmV2oTNrgNcLf97CYIELZlbKbPCzRVRPCdTBTyM/JSRigxGHqSe4LiiWzcK5uQ2sQnRlHZALK2Jt47RprxB3K6cci6yJESGNfVb3Ltt+ixiFTj03oeq2wZKsjb5qsEreG7ofmiPGD/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
page->private != NULL is equivalent to checking PG_private. Change
PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
but it can cause confusion when PG_private is removed and
page->private != NULL is used instead. Change it to initialize
page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
semantics.

It prepares for a future commit that removes PG_private.

No functional change intended.

Assisted-by: LLM
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Chao Yu <chao@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/f2fs/f2fs.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9940a6cecf1a2..2f7ab5888b078 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 }									\
 static inline bool page_private_##name(struct page *page) \
 { \
-	return PagePrivate(page) && \
+	return page_private(page) && \
 		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
 		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
@@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
 }									\
 static inline void set_page_private_##name(struct page *page) \
 { \
-	if (!PagePrivate(page)) \
-		attach_page_private(page, (void *)0); \
-	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
+	if (!page_private(page)) \
+		attach_page_private(page, \
+				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
 	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
 

-- 
2.53.0


