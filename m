Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D00CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 15:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB2C6B02A7; Tue, 26 Aug 2025 11:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BF66B02A8; Tue, 26 Aug 2025 11:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E51F6B02A9; Tue, 26 Aug 2025 11:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FF56B02A7
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:52:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C086FC01A6
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:33 +0000 (UTC)
X-FDA: 83819350986.18.59D3B2A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 516A4A0014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:52:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yta+h5Vc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eqdg6xWv;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756223550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/xuoPN8jET8onMwH0FFSNa60hMfTODJIHCZP9Xiz8U=;
	b=bLkwr7DqttENVAL0qLGOixBQVpbJvkoc6LEUa9NZIhn06g730Y8zafiikV+GwkgRA8Hbhx
	8uCPYZp497GiqSof0IQKMTiIeIo6bi6IBJGZMQtYwWVi6rosK2p6T2+DvMXvojMJ9M0UJx
	oYTVWBvQLEvDQCiWkkf1gdj1ZLRX57g=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Yta+h5Vc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eqdg6xWv;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756223550; a=rsa-sha256;
	cv=pass;
	b=LjZbMy7jMXuj0/3n0havoZFmeSD3IcHyBu4cAL7etxENhTv8n4bJSNk3tPQIO/eZMNMEor
	f3o6EOkKBIT8iFS2lfdTwpcGKVhB1CwXa7kozQtIuuLTFLsvnksH3PamS3lmrry61gOAsq
	lvay3k3oY11PZ87xL8DHReEdCCVQ5Rw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QFCW7T016403;
	Tue, 26 Aug 2025 15:52:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R/xuoPN8jET8onMwH0FFSNa60hMfTODJIHCZP9Xiz8U=; b=
	Yta+h5VcX6W0hahVtr4qDI2w2mgNt2LGgWShCfL25J9xhPxXGbdV7R3KGGUNtszH
	IxyxSu0AIK2DAzbVAemAxoNTht0e3WqGAbsDcRSaLDzK9GyihLo+DHCcXuGdJQOt
	3ZmIlb2n1x5tMjrU8izB26+aOQchAXFjxm5MNm2cKll6xq5MwXcQ6ahSkZHnrcU5
	Eo574o8t0fI2kDgRaXW0D4NKOdxaxdMpTpqLz36issS5WZjm93+bQ0AUdI6INQ7P
	2HXvJgiT45ItvlDpHYJ9tl86RSpkfccKiJdIDyOaqKCNURY9rNCMHOobIEbnbD86
	loOHk1Pt6xJMG3CXchz/kw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e24ukf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:52:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QFRTG9014636;
	Tue, 26 Aug 2025 15:52:26 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q439prru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 15:52:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o5aLeVbc/BnpeGAC2A2Cm/4f7ez+Ki/6LfaqV6mT2D5znPsK00A2vPxWaCbwlgAx26v6y1bS0bwh0XVQXtc1eHlOPbKfZj8z4qhQtRouGwJe8YzI5kwhjdXC4KiizjX9TSAiIlV4Q5XjBEXFfVG7Wa4E5wnY5ijtL49cNq6FIxtaoUrWTjNDiQ5zP5G8rVH3slf0zIprVJz+CsZG2Zbvd2A/NO8fn9k4Hoj473e0WZ+lT+hqQyJi7ffHVPjo8s+us+5CHY5IY/jVU/YyP3GNA7wdMWIEVZWluwxzg62z44u/dQefo4yyu5wDVLZ2nGVj/sQrL0Dqz0cHbZFR0RZBEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/xuoPN8jET8onMwH0FFSNa60hMfTODJIHCZP9Xiz8U=;
 b=Jip0eLO7VtP1qyFuTAkOaRLY1HYJ1TynNjcogmcknRYiu6NGGdlLlttqDX1PNx03VQAMOsARlJw5etRR8LopyPPHl+k9o/kQf9H0ody3R0HUWLLaregGO+xkejI8l+8SOvjzI4M9QvW5A2cMJTaeV3RYs4TsaJvqSXXSWCHxTqwIDaOgfrU81aXUu13sSGuaeielpQhgfU+SpggkfQtR9/1yD6aCi5xbrLA9XOf5zaCdClHZoQjhT+TAiWrUSPonNrt9b+7DGED0yfwHiomGxwmFo8RaHy3lqdGorLYCdvkI5Nx54HOOG4pwN+xnErSCeCC0jEHb0TCr9RIzVoBF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/xuoPN8jET8onMwH0FFSNa60hMfTODJIHCZP9Xiz8U=;
 b=eqdg6xWvQj9m6s1A5jk4Jipks8nRnU5M7l+AWXRg32Pda+a37AGcr+IIWCjFF/B1/t4yjTjqjpxfq/6KUXkHw3kbFex5ji/vL45hFbaV06HHZPKCIP6xsbu7JoBExEVoOw7UL3o9ca2bLbPx1ADcqwS94Bud/+KJ9KJO1YTlXWo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7456.namprd10.prod.outlook.com (2603:10b6:8:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 15:52:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 15:52:23 +0000
Date: Tue, 26 Aug 2025 16:52:20 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <65dd5d54-87ab-49a8-8734-2201a0014feb@lucifer.local>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
X-ClientProxiedBy: LO4P265CA0219.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d0f4b7-8df8-4325-cb15-08dde4b88c3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzVQUGJwRGNVeDBBQVAzRy9uRTZwS25YeU1DMkFDa2JwaUxUS2E4bGQ0cmdF?=
 =?utf-8?B?U0VZNkVvVlRhckhjTTNMVi9NZ1krVXkvSkNPNEZ0bGQzandEV1pDdzltN2Q1?=
 =?utf-8?B?Ty80Um9zeFpkajk0Y0hqMmtzb1J5eE03NTJUZWN0cEFKTFpkN3ZJWndlN3Y3?=
 =?utf-8?B?R1MzUE92clVJdEJSOEJ1bnRneEhNVmxSTUxEYWNpT0hjQTBiZkNVWi9DMm4x?=
 =?utf-8?B?bEx4aW52ZFNQa0VDS0RqN2pYWktHc0xOTC9wcVlrVlp2RzQ2VW1nQ1cxdHFq?=
 =?utf-8?B?YmgvN3hCSXI1dkRwd1ZNVWRTbExHNExTRVV0MWFyV2I0OCtoYTBrV0kxOHZO?=
 =?utf-8?B?aE1QbFFzVEFBdytrSWNsMm1kSzYxY2dCOXRVZlZNSEh5ZjBkbHlFTytPcXM2?=
 =?utf-8?B?ZjlMaURBaW93b3RZdkl1eUxDNUp5NEpyU21yWitYWE5DT2p3UDBZSnVLWmJt?=
 =?utf-8?B?S3FCTjJMTXZ3WDlTM1IvWFBaWTR0SUQyYWZXSFpKR0phODRUd2N6MkN4ejI3?=
 =?utf-8?B?d3BKblhRZGRHL0I3L1Q4L214MjBSWmhadGZJbC9SOUMzdmtFRE1jZk1NNytW?=
 =?utf-8?B?U0xWdTVjZUswREFGUVFCcGVMRkw5SFhqaWdtNm1lNVNJaUVvZGxPM0JQVnB5?=
 =?utf-8?B?NWdBRXBRQWsvUFZ3YzVHcjZYNllWL1lxQXZ2NExQOG0vTldzVE1vSnA1MDJp?=
 =?utf-8?B?L1BNbDRoUm9IZEpXWWFObFBvVW4vWG9TaFU5L3hQYUNYdTdzQlowcWhpWEpG?=
 =?utf-8?B?SG95dWxSekFNR1BMMmRJeUFlSmRiYlZNTWluTnppaXNDS2Q1eGY1R0Nab01H?=
 =?utf-8?B?Q1A5QldDY2l2elRyL2Exa1BkUm16RmNYTGswMTV0NGdGSkhNUkxwK0tMMlc1?=
 =?utf-8?B?ZTEwdHJLeXo3SURRYlNaZ2t1eFJaZ1FQdHMwSm1wQ2RlWnVySDdKdGtIalZt?=
 =?utf-8?B?alp1S01GQVM3a3RZT296am5iaHdMYm9sU0MwaU9VSVRIRnhwTHhFN2xxVXBt?=
 =?utf-8?B?WmQyeWRhT003Rk1EOVhIMER5YlNSK2F4S2ZkSDVpNHl2TlVzNWxGSGI4RG51?=
 =?utf-8?B?M2ticEpLOVZ4WHYrNkRUbVdZbWVJUDUvQldyUVA5amxabzRTTjI0SG82Y3dI?=
 =?utf-8?B?VHl2UlZ4Z0tnTDA0VHBCcFJlNmVMVDRrT2oyQmw0YUlHdDZkT3gyUGd0Q1Vm?=
 =?utf-8?B?MGwwN25LRWxQb3JPRnNuZUlYcjVBYXRuUkd1ZEJuOFFyMExSaTlsaUVhWlRi?=
 =?utf-8?B?Y1RBbDU1YUgxdWlqaDV5a0JZVkZXNUtJdXVaMEh1c25yNzA3NVdHQkIxMnEx?=
 =?utf-8?B?Z29qSkJXaW9aMXZHUkNZazF2dkw4ZCsxTGVpenlQNWhoVnpkNWppQ1gyekZ0?=
 =?utf-8?B?MlQvWDBJdnhvR21wNkdVdVNaZjc5cG5SRXkyOWlBQlpGSWxPRDhNNUU2dWlH?=
 =?utf-8?B?QWZ2WXM4YWE5cmVpUjEva3RhYjV5bW1lZWJFTStwY1A0M09RdzdpaU5VTW9u?=
 =?utf-8?B?VW9wMjRUQTk3M0tIa1g2MStFWnNYbkxNQ0ZKNDJ6czMvNWc0S1NIYndGRkRQ?=
 =?utf-8?B?YVVnZ0Jtc3AxanRWc25PQ0sxYzM1TlpGUGhvWWt4SDN4djhwUHR6WnhzUFdv?=
 =?utf-8?B?NVlHYzVnakRjZmVrbTBxbDR1dUhEcEI1V1RENkNVa2VNWnRYUzR3VzVwWldW?=
 =?utf-8?B?a3Q5c3BUSHdsS2R5RGdqcTl3R1N2Ym1DQ0NSekp0NkxRUHZnRmtRRFVaSXpt?=
 =?utf-8?B?RFN6dnhxUzFUTnl4bEF3ZTdGUlpUUHY0Q3VOWUxpUkpkUTBSenVmUkV2TzZT?=
 =?utf-8?B?aWxRbUhJZlNvWng0NE9lc3o5WXdJN040bEhoam9jQUVhWjI1ckkxSVFXWnlT?=
 =?utf-8?B?WG5nS29vOVhJeEd1SDBFakpSS1lnVjJ6YXg4d3lhYUJ6RCt6NVVFQXRhU2h5?=
 =?utf-8?Q?ppKTZzg6yqk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnVia1J4TlFGbGhSTFlKT3NkdlBnZUh6YXZ4YXNxRUxIejg3NGJQUDZoaU1j?=
 =?utf-8?B?VW1lNUhpcXhCWmlXUE5PL1c5c1hZNHlRUGhpS0FTdE85VVowZ082by8xTWRL?=
 =?utf-8?B?bmpKeHZodGpoQlB6MXlLY01XQUVHdmpwOXVSSytMcVhiSFI1RWVOcFNmOThI?=
 =?utf-8?B?aDJPTXU2MEdmNXplbklyRDluN1JxVk9YSkhZV0s5QkhLdlhnVnEwSkhKZ292?=
 =?utf-8?B?QzdtRHhjdTdZektOdmpiZXlzRUxxVWtUTUJhVWhtRVRueEdER3ZnM2c5ckRY?=
 =?utf-8?B?Y1NTUjZhZnZwMGlITmhnRjR3OVZ0a1g5Y3pIeHFBaW9kdk0wT09LVkh6MDFK?=
 =?utf-8?B?ZnMzcXRsTEdONHJnZTZrQ1ZtUktCUW5SbFJTM2JXUGcyUHcwZGwvREpXYkVw?=
 =?utf-8?B?Um9qK1BRTzRUVlMrU1dLMm5CUjM5ME9hSGpBNEVBWGpNbUFSaVZSSWh4TjN6?=
 =?utf-8?B?eXRYN1QrbExyVngyL2g2NWpIVElhbWpEWjlxaHhLcmZDV005SlVTUVJQb3lk?=
 =?utf-8?B?ckFUZW5iYkRSNVdNd1NVTXF2M0d5NWEzaGpldExiRGNmcnNGTmozSmp5WGVD?=
 =?utf-8?B?MlR1bTlCdTNXWXp2QzY5MXo5b3NCRmlUTDU4eWlsM2NITkZyLzMyRE5rTDVu?=
 =?utf-8?B?cjAxZmlPQ2RhcUlZU1FHYVl5QkNtL2Z2aldzbVFuR0RmejBMQ0V1NDV3WG51?=
 =?utf-8?B?MFdQTjFSUW1tcUZjQitJV2h2RmNMbXN5ZVlaRTJ2NlZHN0gydFNNK0FhQmZm?=
 =?utf-8?B?bTBVa1JVTkQ5SnFpdEJZa0lWa2JlQVhRYzFaUDBJY0xYRE9CM2NIYnpTQzF4?=
 =?utf-8?B?Szg2aTNpaXZtd0NGYnAyRHpFUno4SGdUNmdSMHorWVptMFgvWWVPR1VBMFZs?=
 =?utf-8?B?azdNTC9hT2RrcnFMNG1OUE94YnByamhlTVRucEIvMkwxOXlYOGFBeHM1T0Mr?=
 =?utf-8?B?VnAzVW9XL3l4b1A3Ukw5NktHcVVlK1JBeGJnZ0RNdnN4eVJ0THdvR0VsNmwv?=
 =?utf-8?B?WHVwZ2ljL25MNlc5alFGN29zQzNnQ3BGb0tJUngxVG1zdkdnUFFNWXZ2S28x?=
 =?utf-8?B?aTR0M3ZmQkYyZHRiK3NyNmJBS3dVVVpJTlBYd2ZNaG9iR1l1UHp1RWxWdGV6?=
 =?utf-8?B?ZlkyYXJmVGVLVm4xMXpiZnBpUTlvNU1tb1h2VFYvbkhqaktod1BxbTArU28x?=
 =?utf-8?B?S0Zjek96dWd2L0ZYZEQ4RDJ6MUJ5ZXB1bE1sRFg0akljYjlIaTRzVmM5aUND?=
 =?utf-8?B?bE1oUUlYS3d6UXI4NWxLSUttMm53TUg1cVdEY2ljNU9rTTVsUjF5bTNWTnFu?=
 =?utf-8?B?cnhwVS9hOWlYNFVRRURzWUlnYmZaN0FpbjV6WUh1Z0xmbk90eWJsNHZmUXlw?=
 =?utf-8?B?QTZYRXBRWG9tc2FuMlBQTjVmZXBScnVSUUpsTUJKbVhEdDM4Tm9zbWhLL0ov?=
 =?utf-8?B?L2RSY0p1Rng4RXNtNnlJbnVCS1JYa1h3UTlaTThLVHdPMmJodDJxRHhaQ2VG?=
 =?utf-8?B?REE0VGlvZzNTeXNTMTJiQU80TjhXMjRLSGt5QjJFcXRzdXRONjU3SndWYlgv?=
 =?utf-8?B?LzQ0MGNycWhWM0JHRW9WOWlmemJSMjJydkZKdHhNeTk1TTlhUUk0bU1ONDlz?=
 =?utf-8?B?NWphR2dGb1F2b0N1QjhxVFQ5NkdjQlVmaFcyYnFUa2JRZ2xrRUdnL3dSOWZS?=
 =?utf-8?B?MFZDWkRpYVdUUS94c2VQY0VMcmNaNlVOYWxlNHowc3Ftbms5RCtUSThkck5t?=
 =?utf-8?B?OHlnQVBwTkdkQ3lWRGRzMFQrTXBZcnNGdjhDeEJ1S3VsSnRYREhlemtmdlp4?=
 =?utf-8?B?cHljcmREb3VDTmswTk9WUFRyN0oxOVlqU3lVSU9NcTRRcWc3bjN4ckVKMDlR?=
 =?utf-8?B?NTNVQ3cvQVVDK1o2ZEl6dFlQeW5xYXY5YzFzWVJzYS9ZUzJNNVJHQWxDOHNO?=
 =?utf-8?B?dmdwcjNheTc4MzViS29yaXpLc1NUNEozWmhOZnRtd2JuWFhBY0xFbUhCemNv?=
 =?utf-8?B?L3AxeS85SDIya0Q2aFFKVWdFdFJkRm5jRy9FNWVrcVFITk51UGZxVEdJbkM0?=
 =?utf-8?B?ZmpUaEYzT3NFdGU4YVc1Zk5vc1Y4cWJQTVJvWFlKVTFqYlR0VjNROXJ6cmdG?=
 =?utf-8?B?MWZEWHpkcDJDWSs0bGg5YWtJdkxVU0d2bkI3WUlIN1h5eGNFOERYSlFVNVgw?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u7ZYW1/BeLThOO+L3eCnmHBlRrwC/5zpTjQIbKFp8XbX1jCFWKGPUNUx424uUWNicT/f9kCj+bVmzcpVP+wLoMnVni6ym8gsxANs+3XqSDIW7juHPWM9TTwvQ/24/X61qXT/DlyUSJs3VT8CvT22P3p7XFcLpUyk18UssEqbKp0g+bcb1xtbDTvvd9o22fd0D2L33f+RQG2J1kJRkhYgT3nKu+UnkWYyp1qMb2GztvzWH4iRUiIJ6tP+vmrqKP9KNQZKbiGY5tferZUDkY6jfuO1a9EBSi1SEsPZGWgJGpKPAGjd7EjCTTjJoZ8tLstPb4WlJtf5mQom3H/Lgb3DLxCEdhXLpRBA5K709Uc6ungeoyy/+EaPmYe4GbI3lFXe+sOSqnIjuX5hUjvY/3yfCPRUeXBRTAXUKRZvt8N7Oe5hRwlNhralaIM7WZ7AiJIWjiqf5YFMihf3dKfllGf5hQxTSOA47IBjDGX/VThJ2+S3Qfz+0jA+Wx+8SUGWUopzKZrD3FpbUYccZl0CeF7q2Pkzr2MLyL+gEwkrkXKIb1ssPibWdNC4gvd7qMN82zZMm0Dli7vzc3S5VCWSK+PQnZIRkzH2zRnTYKySoARIOfI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d0f4b7-8df8-4325-cb15-08dde4b88c3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 15:52:23.4986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frVybtW5xcbedbDnRGPSyfHW+6rBi1IY/e8n+ueLZ2xvu3C+/Hbq3E9nNWjoslU0EBBqyyFq0kExX7OOPSoOKmMb6dLvGW7Mik+5YjMEnyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX0AXmeTadJDBD
 b/0XVi1fujECOX3fGTBs6UBXjQk+4wicPZ9hTixtmy5d/djyqbyrHUsfDs4O0rCOUqi7rKB2Dmx
 QMOwqCVqkWT7BQyKinGUJRyIK5Qe1OjYL0+Sm4hokwVvUdYmSSg1qy1zKgGlGyUueewfzsaoMDA
 OFSkEaCCokAwWJhuvwNe48XoWCfCvChsePzierlyT4NU6hEgBRHEqeHfeCswiCtX892LctSUnfY
 3zZbiD7CzakPH12zanVJUCQsGY8LJYCqMdLxpEEESjhGGujM+1R7N1E8x/MywWDtj90qtCIxXhJ
 RYbKBjxxWfXUlj2lYp5R4bSvPCsOoI0jxitCU4SNzGcMAcK23eSodpAln+7WH/1FCaiq0OjYmi2
 8LWpK/nqwJfK1sgf4F8CCL+JhDI5cQ==
X-Proofpoint-ORIG-GUID: jGMSbkO10DgF-KEcp_zOjAbSA5aFme0h
X-Proofpoint-GUID: jGMSbkO10DgF-KEcp_zOjAbSA5aFme0h
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68add83b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=FSO2O3GXqfr0IAyAxZoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Rspamd-Queue-Id: 516A4A0014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ap4rt11y3yn91jie5jz3r5qy88fungpn
X-HE-Tag: 1756223550-622910
X-HE-Meta: U2FsdGVkX18tszi69ukugHb6J5YZWWojCTU8e35kLEFvME+XnQc0LoObXWmrxPsljkAgPaGt53czBNiLKU7Iq3Z/HMwC5UlTuuNnQFQc9Zvg3JIgQxxeL3Vgr5yWs0tWUcmCMsrUuJUUoqQnNQSr8s/r2IoU00H4zA/3qwon3SUQ/uo/yrVT0+KUDL9lPyLKlpdopyC3Vpks9Pk6503sUMD09WwB1Mumejukmxy3wgUO+BF741hvKTMPyWCNKLE1eOybt9cZklRjuNYVrZEXJVTdIvuWzAcl+g45M6WcrWdPYk64aPA+sbsayrYOyrgjSKgFQbii/3SORyqcHbBTpmRw01WTzL1EBOZjZyZOIXUrlkQSy+0MJ74vC4oqilEH39/Qpo5IBaIf2p6SMDvhB8nn16BuO7jK/njpL33vGknDiFvBLmmONF4wp4k9q8HNK0fdxgQblAwilLnbirLF3YsYAwbtOEQZWWCiaLF5oDyxWwC8FzWK1UL4XcZOPThzxlTIJjTFgl8J4b8UjhEn9Z7vV/1qNIYoUQv2xMqHdDrGrhcWKa0vCyoteLLT0POkvqh/+ecmiUFJ6bta9PT1rPPMM/BxvUoWdx54hEhh8pfPMeNs/Z64QVlsx8zlnEljv1NHrZzmwnlsgtqXFKXrLFKNVuNJVBpz/hGQ5tWjuSkFmQivhqxxfjvqj70mQvSA4nYUEuA36/LTPcX9g/RLYwaQ6kyxNsbsnQZsol0Xn8efoNM9lligtVujZB+lb8mdZh2w2Uw/rdHcgn8exatjFRpD74hbJfeiTuivvRU17pZgRIrMn8n49D6Ag6OjLKZIGWtUFI0Zqa0uPxJymq3KSTx4s/eKj/rUwTXUHrMT2EHUcou75c+/T6/H/oeCtnkZdYcJDsJZMvRVFDJm2G9uKGkxkdbIVcXT0TbNuQjzDeZIguia5psM4CSzije3O7MWAo+OZGwYLVAS4+k/ne8
 hOxna0WM
 oWXK7fEFh9vPsQiTCSdioKvIQBvUbzMrNXmQ3HdP7qcnJtfW96DusYrpFi0miTfTbYWZjzNZcFlG1A+GASlSonhCO+cJ82JB2rvFX3DcEdkzy5omyODegx5t+cbYg8OVvFU37EhL00LOt5MNlIRtOULzdlQg5o8YI2vvSmALWL6p9wAM5eXP45yMMIKjXBytQHdcFJOTlrsZdvEj1mvRihMiNiNtTadk5B0yac//rtfSH5T3OlIQd+ssk+mWK+DIb56LaDRffsboV6oKDplM8UNdpoUP6yLzUoU0Owbk5RafstKCmATvB4Ac63mcD9QTSK5+39S3R0PfwT3fvziRp+RizSwRE6I0e+LYzl0OoUDTzwsmI65arVxwdpSnb+c/zmLnTSr7g1Cff94J78D3yf9KTwVXWl3WLc302pbzig2XOaRFbFKdyjU1Os2RsRHfPeqIAcYL5n7vws+yJPR1L+/d/Rs9v+1nte7ADjrrdOs5IEoJjPTdLUCZ+ZyK0E0QexYGZoPL03TezlGakmOuJEhcgmobWGTX0+n7b8tnTQ/1IIpSDsICvHiE4oUDqK/NQR+FuaIoW+V4Vw85okVTx/morlF3maXE+ssi5K8HodC1zoqLHJ0RMwGFNbCZ3Sbcm/kSlE7+nfCHDTHHDU7plfW+xqE7h22pG8EGbAtJtAVJcxuxxdQvvung37d2992FYPvaRNIoNthWEFeMF1AdwKWjoh2gQ/7f26M1cdJcFP2eBV6SU1VxifpEc+l2OH7P+JzMPtJfEtTR3ZUBaGFpe8K+HKxEKhh7B0IRc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:29:52AM -0700, Lokesh Gidra wrote:
> Hi all,
>
> Currently, some callers of rmap_walk() conditionally avoid try-locking
> non-ksm anon folios. This necessitates serialization through anon_vma
> write-lock elsewhere when folio->mapping and/or folio->index (fields
> involved in rmap_walk()) are to be updated. This hurts scalability due
> to coarse granularity of the lock. For instance, when multiple threads
> invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> from the same src VMA, they all contend for the corresponding
> anon_vma’s lock. Field traces for arm64 android devices reveal over
> 30ms of uninterruptible sleep in the main UI thread, leading to janky
> user interactions.

Can we clarify whether this is simply an example, or rather the entire
motivating reason for raising this issue?

It's important, because it strikes me that this is a very specific use
case, and you're now suggesting changing core locking to suit it.

While this is a discussion, and I'm glad you raised it, I think it's
important in these cases to really exhaustively examine all of the possible
consequences.

OK so to clarify:

- You want to traverse the rmap entirely without any rmap locks whatsoever
  for anon, relying solely on the folio lock to serialise, because
  otherwise rmap read locks here block other rmap write lock calls.

- You want to unconditionally folio lock all anon and kSM folios for at
  least folio_referenced().

In order to resolve a scalability issue specific to a uffd usecase?

Is this the case? Happy to be corrected if I've misinterpreted.

I don't see how this could possibly work, unless I'm missing something
here, because:

1. When we lock anon_vma's it's at the root which covers all anon_vma's
   covering parent/children of forked processes.

2. We do "top down" operations that acquire the rmap lock on the assumption
   we have exclusive access to the rmapping that have nothing to do with
   the folio nor could we even know what the folio is at this point.

3. We manipulate higher level page tables on the basis that the rmap lock
   excludes other page table walkers.

So this proposal seems to violate all of that?

For instance, in many VMA operations we perform:

anon_vma_interval_tree_pre_update_vma()

and

anon_vma_interval_tree_post_update_vma()

Which removes _all_ R/B tree mappings.

So you can now race with this (it of course doesn't care about folio lock)
and then get completely incorrect results?

This seems fairly disasterous?

In free_pgtables() also we call unlink_anon_vmas() which iterates through
the vma->anon_vma_chain and uses the anon lock to tear down higher order
page tables which you now might race with and that seems even more
disasterous...


>
> Among all rmap_walk() callers that don’t lock anon folios,
> folio_referenced() is the most critical (others are
> page_idle_clear_pte_refs(), damon_folio_young(), and
> damon_folio_mkold()). The relevant code in folio_referenced() is:
>
> if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
>         we_locked = folio_trylock(folio);
>         if (!we_locked)
>                 return 1;
> }
>
> It’s unclear why locking anon_vma exclusively (when updating
> folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> with folio locked. It’s in the reclaim path, so should not be a
> critical path that necessitates some special treatment, unless I’m
> missing something.
> Therefore, I propose simplifying the locking mechanism by ensuring the
> folio is locked before calling rmap_walk(). This helps avoid locking
> anon_vma when updating folio->mapping, which, for instance, will help
> eliminate the uninterruptible sleep observed in the field traces
> mentioned earlier. Furthermore, it enables us to simplify the code in
> folio_lock_anon_vma_read() by removing the re-check to ensure that the
> field hasn’t changed under us.


I mean this is why I get confused here though, because you seem to be
saying 'don't take rmap lock at all' to referencing
folio_lock_anon_vma_read()?

Perhaps I misinterpreted (forgive me if so) and indeed you meant this, but
then I don't see how you impact contention on the anon_vma lock by making
this change?

I think in general - let's clarify what exactly you intend to do here, and
then we need to delineate what we need to confirm and test to have any
confidence in making such a change.

anon_vma locks (and rmap locks) are very very sensitive in general and
we've had actual security issues come up due to race windows emerging from
inappropriate handling, not to mention that performance around this
obviously matters a great deal.

So we must tread carefully here.

Thanks, Lorenzo

