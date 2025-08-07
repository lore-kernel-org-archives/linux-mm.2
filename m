Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DF8C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 17:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F3D8E0002; Thu,  7 Aug 2025 13:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06C68E0001; Thu,  7 Aug 2025 13:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEA08E0002; Thu,  7 Aug 2025 13:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CBA48E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 13:41:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 53F12160A4A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:41:43 +0000 (UTC)
X-FDA: 83750678886.13.874011D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id E58B4A0019
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 17:41:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SsoWm1aO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k7RBhUAG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754588500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODZRvUhYNdcxKKOpu/AxAoctH3LdeGwuDNrupzrSVLc=;
	b=tpdSRRuUdL+uTI9xwTuNsUT/78wEqXQ82em47bBODm1JYsTF9VoKTG4d+xy7UcCnzkTGfV
	xLXi2tAfqK1gDovIgjLTPOQ/cJmivRGCzmwcpFKyS1aoDHcxJOHg+Mvu5N9OGvmdJXT7+z
	ilwdQDM9hEutzLIXQvgqPllx7DJp8Hs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754588500; a=rsa-sha256;
	cv=pass;
	b=tBwkRopIZokiTguz0LQyPmznki9tHbNPKdgA3+ZujZaPwXYv0yN8dEpshLRntRwPtPxhqn
	53p/YSiUd/pcPh4co8hb7msdQik0H5z0BcX09XPafLCDrq3v3XhAJAzLXIDJktU55SF7Gv
	q91SDYfewBmC2pct/HPRTfuTP1T7xSE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SsoWm1aO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k7RBhUAG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577HC7qo003050;
	Thu, 7 Aug 2025 17:41:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ODZRvUhYNdcxKKOpu/AxAoctH3LdeGwuDNrupzrSVLc=; b=
	SsoWm1aOHptZ7YiOy/6HmeBvBt+2mmpltt1VZYGQb/66F7S86YqisJmVq9gWfFFE
	8Z85MqWiWo0j0Je/FO2A+ii4hF4kw0pjbSSvixOL8QmwVkQe0BlWIvGSMVC2jUJs
	nLwwnK5lf1xtD45r86KfsNfFOCIHIUv13zXJoOVrxeOJRxbvkz5WIa/Wfsf8mrEv
	cMGhvjXZe3fjp1jiZ7xmueX1dLizBG4MsVbZy+nJZaZIjeRGys4AzAcY//vFvT/D
	3YU9p2xGZIz7bd0wMLuYm2QrSvjBm892TAHHvE6KrZIoswDGu0SRmPngDiHG+LPi
	m17g3P+oP87j2sks4lMrOg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd4rj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:41:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577HDkTk027432;
	Thu, 7 Aug 2025 17:41:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpqhkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 17:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gt/WeIwf/9UVQAsmTuf0SZ6h5iQ4Q5HO2P9eHb6yGMy3PX2gzUWhBMSWdPqVOQAUsDa7/Z4pOFHmL4AcA5gAfm4yyak3BExNz7RxsN89dVsWcuRa5/8hHFJiM5QcbcoQe5jNTyuudWFrP9gKVYbT46uBQ4l40CpNoMaqYoE1UcbSGlITlN7OkorHvC7ciH0WkNvnQcWWu2FQBGvzISndiB074a2QovQKZuB5gRSksgF4N+36P2oFSuS2ZwLe8nYr3kClDe0FD7+BO58r+xE/1SPGYYbqyux5UXvPgrsw9m+omyfzWVvTaSthWSWVOItraYkiDHlT+vPTgdHT3llw8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODZRvUhYNdcxKKOpu/AxAoctH3LdeGwuDNrupzrSVLc=;
 b=sSDvFNAVk2xJmwUM74GahlEiWxKA02jTPp0LPrlGDWYuLGFg3e4Z7AEWQ5Lzyfp3G8X6UWmHhl/XWoSN7roLIVM0Wpan6bxFl3sr9/I5wT0xsfGrgrv2zcO+2cSp6sA0DWGXLS8wL4kCJYd2vV/5VETDduPZSy8zzA2fUz7o0cO+eyycVx7utpTghzwJnLbg15yAh+WMUdT5V7mrNqqcVrpJmUVexHqCJiNI/7mtLlTGIqICUy4nbH10hGUri7oxqDPP7x8Y05INvm579TqmIYpNcYn54QbSgV5xYSR0yGHTyGUfZPm5Hxo61Goj4XaIKbFh88Ad+mHj2H4DM+hepg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODZRvUhYNdcxKKOpu/AxAoctH3LdeGwuDNrupzrSVLc=;
 b=k7RBhUAGDCzyo8WEr8Hqh7Gr5WylsIrXcmipiqpjE2v0lAOzIgvWfJMctAbTc43EpnxYOa6ZA1crXBMGBCaRFWR108ZhHg3jbtmHsuIwp6eRl/H22l6U/jzz5U7Tg/U1+a7IV6bcreKrT+VVtX3JeUhgSdW3P3u88s6toI1EzOM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 17:41:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 17:41:08 +0000
Date: Thu, 7 Aug 2025 18:41:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: kernel test robot <oliver.sang@intel.com>, Dev Jain <dev.jain@arm.com>,
        oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <be074809-e1fd-43a2-9396-8f7264532c4d@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3=8f3eShjAe9hrvivP+Dvyisw=X_Tr_phc-OX_4MzeDw@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0348.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 895f576c-e323-4e06-2e74-08ddd5d99768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVJCcnhuS0tHbEN1alpjT2xoNVpIM05Sc3JuTDhyQ0ozelR1TVRFWlY1T2Vm?=
 =?utf-8?B?OHoyNUYzdkkzeWUrdk52eGJkeG5YZk92Zit6Ry85TXBPeTZrWVdUaHZSR0ZZ?=
 =?utf-8?B?Z3BycUVFbWlNRlBlTHVOMGxDTS9jRklLL1pxNjVnc2plUTZKQXJTY2xvNWo2?=
 =?utf-8?B?ekJyUDNHZnZvd0RrNzNocWJYN2w5aXhrRVA1Y1NQdG8ybCtMOEZkVWVQWVd4?=
 =?utf-8?B?T3FWVXJVZHVQSm1pKzlIUkg3V2h4dmNrcXFkRGp4Qlh1eFhZVmdQbmYrRmFt?=
 =?utf-8?B?VU44aWRTbVhiN1Bsc2t4MlhJTFBHdWIwNTUxWW1MNDNVVTIxTER3a0VDN21N?=
 =?utf-8?B?SENvZWY3L3lrbUNIMEhJc2NrV2R6ZlZjbUhFYVo4TmtKY2x4OGErWk1UakRj?=
 =?utf-8?B?YUM4OXlmRTUvZUY5OCs4VGVEcHlyQzBBWHZlSmNXTGx5bk04aWwzTkxZYVVN?=
 =?utf-8?B?WjZBS1ZVU25TNGh0eXV3N0FpTXk3dGNORmNNYWVQUlorb1lDekxVWmRmZzk3?=
 =?utf-8?B?US9zeUxQWUZHaExteVZsVEJKVlNHOWcxeXpwU3hHSDN1eEpvUlJRYzNrYUpB?=
 =?utf-8?B?SXhlSHozdkRnRHJ2Y2c1Y3AzMWhjUHRoRGZFc1FDWkxJZDVkbjRtdWc2K3I5?=
 =?utf-8?B?QkhBaDNaRDNDV2syeUtrQ0RzT1BrMnliY1JreG9VTDRZTzZsK3BPYTNJR0RZ?=
 =?utf-8?B?b2FUakxhS2xzcW9TR1lEMThnN1QvSDNwUU90a3RORXREbFh4bnBuQzA0bmVv?=
 =?utf-8?B?TFQrSGhnSE1UMTB4SWFSemgwUTFkVzdmdXg2V2ljYlVuV3hsdHI1c0NuOHZT?=
 =?utf-8?B?RE01bEtUeTBkT0FZQjAvRW9VaG5kVzl1YXpHdVhxYW1IcWZDaGRZU011Q0Qx?=
 =?utf-8?B?MHhrQ0FEOHdIRXpYUHdqOEVhcUNsby9WTEY5Q0lzZjh2VjFjQjNuR2NyQkVW?=
 =?utf-8?B?Tzc4Ynl5TVJ5b0h5OTBMSzczZys5d2NtUVd0TGZ3L0NWUXBrSG1GaWpRM0ZZ?=
 =?utf-8?B?TDVWVGVNMWQ4MVBRczA4SWE5R1R4eDVjVmJzVWoxc1dsNHZrdUNSSHFFUlpP?=
 =?utf-8?B?WTNBa3dWdk1YZGxuSkRJaXdwdGY4Q3N4cTM5N2JXcmNQenpjdkF3eFBrNkV6?=
 =?utf-8?B?Qy9OelBub0M4Z3lMV1htRDBXY25pamkzR1pMZ3g1aU8rbi9xVzZObU0xM1pR?=
 =?utf-8?B?bTdDbVhYc3dTSHRtdU5jL0huUWNDYm94dFZSWEJRaU84SlN3UUZIcVlUYmpO?=
 =?utf-8?B?V21Gb3Z5ZTc2N25MYlhHUkJ4Sm1rMFRpUy8zbzJMdDN1czNHd0ZlRVNQNDB0?=
 =?utf-8?B?bS9ERlJsSVc5TGpEZjg4bTlQVUZxZ294dnVyOThmMVQ2alJtZVdmTmJQaVd0?=
 =?utf-8?B?ZEJkMnBMZjZEWTRtTFpKTzUrdEdTUFQvTzdiQ0xKSWNUbkYzaDIzRW92aVF3?=
 =?utf-8?B?bnpEejRPNFpGM2hkTDhGR01QMjNIeWRjZnJsaldnUGI3UUcybjdlVituTFRH?=
 =?utf-8?B?K1lkMEF6NktESGtLTVlKdlRLOS9aRGtCcEhrSExWaThUa1hmdEk2Y1NRd25Q?=
 =?utf-8?B?TmRMdDhkSVlRZm1xd2QyalhBaVZGbmRVZUhkbCtPZEVOQlQxdk54NU9ZSHc3?=
 =?utf-8?B?QkFmZWtkRGJOVTRZQllUNWdNckZ2ZDB5VlRtU243ZHpHTmtJVEw2RkdPVTJj?=
 =?utf-8?B?RVdXVHpaUWl0TVBuQnRUVFVLMUNuL1dKMEUraWtncm00MnF0TGE0Rk5KSUFm?=
 =?utf-8?B?VWI5SDhJcDMvZyswQWhFTElCUHhPR0tUZVc5S1ZBMnV3N0daSytYTk1iT1h2?=
 =?utf-8?B?UFBxbU5ybTFla1B5WWdVS0FsTUNsY09kdnVUZ0dqSUI1WWNQZmJnV0xXMkR1?=
 =?utf-8?B?U081aW9uancrbjB1MVJxNG5sanBzVHF2S2VJUkQxY0oxYTNQL0FVZUJjTmR2?=
 =?utf-8?Q?GrY5y7T7CKg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MHNlQ0szak5OZVA5NUUyN05LKzN6aEFrUEpzbzl1dExYYTVrTjVZaXljZm9T?=
 =?utf-8?B?TlBMbW1JS3VDZkQ5QVRsNlYrQXRsR1gwQm1lWEZyUzMyTlNqRm1UaWJmLytC?=
 =?utf-8?B?bmMxN0N5Y1lQandBVjhSRDA0QlVRQjJSOXY2Y1dZTUJTZTJLZ1F0TmlNd3BN?=
 =?utf-8?B?TnRuWVZ0Z0dJYzdBV2pQWDVWUURKZzdrZWpkNUZ6N3VhVVd1UXlneTRydmJ1?=
 =?utf-8?B?M01iWktrMVRJN0h0eHZ4eU1yRjBIcmtyc2JSTmtqSWhCWFo1RndFU0cxUlpI?=
 =?utf-8?B?L0Vsa2RQSnJQb0lWdGJBZmh5WDQwL2xzMS81NVBSL0Jab0tBaGtQcmExbWlw?=
 =?utf-8?B?aDZwcWxXVXZpbHREOTljTU5Pc0VTMXJxOTA5K3NDT1FVdkZYRHcrWlN2RjEy?=
 =?utf-8?B?VEYrRUFTeGpZT09mN0cyZWd2em1HQk9SZmhLWUxMTjRlTFRBMkkvMXdSRHJB?=
 =?utf-8?B?TTZ4b0l0eCt4RVBWL3p5ZUdhN1pEVmMyaDNzSWpodmQ2VnJsTG52dllNeWZq?=
 =?utf-8?B?RXJNbi9IOENzY3VmY3drcnZLV1hIN3E4OXV4VlZ6alNEWkhsMmRZeHNxT3lD?=
 =?utf-8?B?TFNyVUtXUmxnUUcxNjZtY1RSa0MrMC9FUndoN0NwZWtlRDVxTTV6bWlGV04z?=
 =?utf-8?B?QlN5d1VUZ2ErNE5YRkkzRXl4S1N6UEtZRVpwN0tpZUx6UG1lZFFSNFEvdVI3?=
 =?utf-8?B?d1NKVjFlZUNLZ1E2NW5BcU8zelZpTk9YTkFTdDVTVlFiQytqZUhEdWdmL2Iv?=
 =?utf-8?B?Rk5Ub1BsSEZLUDcrdzNhUEMyOC9vNjRyYlFHSTlMWWw5b01XTVJ0dkFDeTFj?=
 =?utf-8?B?dm14LzU2UmxTKzVSNWJIcVRFaVk2OVJINUgyRW5WaHcxMXRHZlBCWTFlVjVZ?=
 =?utf-8?B?SElxcUZDcnpoUWFwT0RINmpRd0F1a1RQZEcyTmsvU3dac3UvZWtnRFFsZXM5?=
 =?utf-8?B?L1QrMzlvQnhSN3ZlREtZL2t5NFJDVHZTc0RvZDBWbTVNbVRnMTMxdlNOR0ow?=
 =?utf-8?B?UmJ4RHZ4VVF6M1RKdEhGc3NGVFNib2tyQytNSlFBdEkva2FzbmN4VEJleGww?=
 =?utf-8?B?VCs0Y0xSeEVmVk92Vkd4SkJLeDdjL0JLVW5CcU8xbDdmV2UxSXJBOGsxSnVn?=
 =?utf-8?B?T2pEWG9DOWhrWGswZTlPQjJ6ajQ0WGFTVnRKbmQ5SGVoV3Vid0NtZTc1bHZr?=
 =?utf-8?B?M3lQNXBVY2NyM2NKR2oyOVJGZWttRTlHejA1dUlveVNYVXZjcFhFYzg4NWlS?=
 =?utf-8?B?SWtwdEg1STc2MHl0ZEtsNkJuQkdyV3VEbnhXdi9Zb3ZpdGx0QlI2MmFSbUg3?=
 =?utf-8?B?MzZtWWxUc2VRQU1VSkFnS2FQMlgrNlQxNXBaSnBUUVVaQi9tZFB1U2piZUFi?=
 =?utf-8?B?ZEJXaGVDVDNOb2JDYWVBclUrdXdTaXZDQkxPRmFySWVzZjV5Y2twN2Z6M0hR?=
 =?utf-8?B?UVJsYjB2WmRwM1dDZVVvcXRKNlVxd2ZjamZBVXZ0VkM1czM0aU56UnRCbHRh?=
 =?utf-8?B?S20rQXFiVFlqN0g0Q25IM0QvOS92RTBkbUYvOGZTTmF4S2xmYkltUFMwM3RH?=
 =?utf-8?B?T1lLZnRFVXJRVFZCdHJWUW0vNkNNOS9ib29KOGtXZ2dFbC9lVVRISzM2T0pj?=
 =?utf-8?B?YU5qZ1E5NjJubHRNMnZIdHFrMmFiNkRBMENibjFoZ24rcUpTbmtPRmFsR01F?=
 =?utf-8?B?aWhjUVdBN0RTdFNUYWE3T3ZEVy9tNmZKNHRnbnd2MUg1TVAxeXBNSjhRd1Fz?=
 =?utf-8?B?cmFJNWRQMWVqczErdXJnMyt6b01EWk52aWVUaUZQTzZLbDZaUWRSdUs0UVp0?=
 =?utf-8?B?cmhRbEFSUkhxSVNML3gwdU9GTDI2Vk1vTVhZM0ZYb2pOeXNRc202Q3prWFND?=
 =?utf-8?B?WmUwdVE2aTVwNlUxaUVna3dvYXlkdlFZWkJ2NW8vUUYxMGFEYi9qaS9CL0wy?=
 =?utf-8?B?RCtOYVpLYzVRWS9Sb2ppbHBPZmJRSS9pQnZuR1ptaE56VU9OSzBpTlh0KzhZ?=
 =?utf-8?B?YXE5VGJKWFpZdWFuSk9HWTdQMTdYK3hwYXVXSmgrVnRmNU42TkFBVFlPYWV0?=
 =?utf-8?B?L0E0d2d3NGxFNHdwMGQzVC9qM2poWW8wbnN1V055OG1xN1pSRHk1cmR2MGRm?=
 =?utf-8?B?cm5qTnJKdG5uTEZNd2hnbDEvRm1lQitPbk56MjlRRGE2bE1sNGc4WEVON2ZU?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gXgHolmfyqaGfYEqDyLKDPSkwUfGy/SnVkBdYlgw6uKwOQOA8CBGNpSEqY3EeEiBHndo/TSWpx5RckvTQnm2hSsESuL6iSgDCTTtr4w+t7r/aHkdgmYEgiJ4LNh8+FpXFG/AbZEBAqn5KrwE5QhYDEmw7UB921l2lCJnmOJuYHioQzJIlw1AdIIKjgzEyjXnZygk3Nud8q65NqvICVjUm6QnN7KIXZ5TxOqS10vbb2hCcOdPFuT9cjgYUT1zkxQgJpG8pc8PgEi3QlQDduivIm0wmgyATs2MrZszHn7vAndiCT4+P74DZ9WfPjlpWFw3r2CBbv4+Y8TSRbGQnep4Psbh5N3mrU+yOBB+7VxEauQlXk+JVph1ks2Asl+871uh5CRHzW7tSWZdIM3P14A+vB1FejQ7hQBcfyluVMB/y6dfoN/otq2uHp9KyTUIDBIxNdonDJzgvaf0Cfi+EeEBHhORwGWasvA2rq2FfbgEvvBcLY4cXZ5aJoXkXzYFodlK8IKjYxiuliQ1hhpR37WPCOOoCBXpleV4sXFO4ebW9MfnqfrcACkLRWknUs33wRePXd3xSykbJIGvxIa+hYM8htVy+AYlMmM6ytQ0f2+fr6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 895f576c-e323-4e06-2e74-08ddd5d99768
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 17:41:08.2022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A94qbPEy+oBs8BuhhrItnnE9huQ/jg/YNw0HHtHwIgx0OGQkSKa35ZfKvlHLJTaFE8ke8GojAPpl3u0++nBZfal3sHNBir7WpNNfsr3uq0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508070143
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=6894e538 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=yPCof4ZbAAAA:8 a=CB5h9B7SOj1RGo8YwmsA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: rBw-qgDi0qWsvTAJhp9GG1T0fcwxSKp2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDE0NCBTYWx0ZWRfXxuqxGlFudcS1
 33GilODMDvlrC3grXCqEcFpzpShi+IqIlZ+WEiDnTlSxQBv2JQ0J2EJpuOhDpZm6EE19slhL3J7
 jslXZSTi2JamXGWorN0J8scgDjYFwE9P5Ci+K5DLlqVj8oF3ChlIs4cTBc4IXdFj+yFaw1J3GLj
 bPd/+0iXoZ1IVGWgGVT7EC4BxdvxqGEJKe675BD7OEVpQurvN1oU8P30ikTd1zdAQo8vZ3IC/4o
 fPL6tXZzypmxBDPuQTe6/19eNREimH9vved63oo1xXxwubSwXylMDFUWCc6d2Iko2c2upnYRBhV
 6roSCqqmrjLMS3vSTHi19E3GY9hN3pyRoGnFEC7eFr6S5C/PwPfJbpegE8HivdQtIw5wTsfpPy6
 ab51CZBihELbbjM7gXIVpApz7ig7xpmHrfSvFbmI9iOWuGvPHY4e1M510KMb9Y/okAyWQEzx
X-Proofpoint-GUID: rBw-qgDi0qWsvTAJhp9GG1T0fcwxSKp2
X-Rspamd-Queue-Id: E58B4A0019
X-Stat-Signature: op96wd7arqwaxrneng8abzgitw8snjqu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754588499-61301
X-HE-Meta: U2FsdGVkX193R1miMDYukcZ5zRMEziKDYj4v9cBFLp9CbeLQhbCY9ru026sMkWuTVx1t2LleRJ4vNzrtAv0t2AuA069WHLzX4eRqfUq2c0H4b6CSUEG15Ip4CpDPh3CQ4eMisJ1NHgLYjcbA5bZeRXMCrJIWavxDPK84pLXN9ILNqVtREEq5oblyINctwRBGq8q3fBYF8x0Rr3ieZ0QB71m8Id4IHbGxlCmUE/IJtzGvYXPAl6DqAcHSIT6GgdDaQGUqLlToncdySzNLt2rhrlAKOLK8Hg+ORWd4FRFDbVyR0MZZo6AySe0qb8sDAU1Tg/+IpnFPSJi/zag38hOAVM6GWZSlcVN0pKeqY89eLi4aBIr0z3cEO3DvAsgULjhsGesvbltkXrrMRDxvuLbinx48+vAlCbzjRZiOTl5c2I+8zvTSCdB8g2WorhxEirdO5egMv1RmdClM6VCqTIQg49OlDIETbY8BLvCoyVi4MC3n9mqUGUtvhQNB+6SaGD/DYGcQp7Ae0S0L7uJnnpSsEiToLpWB+7oD3ob3GRrcWp3ND53M+AgCrYst3AS9RGfyEw/HMx0U9LtgFV8Cs5adwNDCYgYakSh0hkC6dkIblIh2Bzj8dkNQNSTlus0D+TNftfof1DuxQdc2ViqrdzsgxOSos71kiaEoH39ayKMmBwhVXyVAwTx+mAw/L3DdEIhzwHeW0MMC/xh6HhlvCl5brGx30845IbrUNnU9GzMy4+Yo41pXKptykcvd+yh0hwhRY5hj7sN2/Verw0D3gNpM4x6s5PfstUlBavAJDIxcleGSyqsg9R+ajSf6jpQXPFSS1M979aaBRdQ7ZogZLJGhonh8bHFzn01+4n3xjriQuDezx35Kt1kqZA48DoQSyB8tUMh0J5UJUsoq1lUFNkY+aqavlA6D8cHoaaMcVULzg+x+vZSVtI/TwSQWdKobaXZRSLN7yBPKENPYltWGqU0
 Nqizj6Ro
 ntLrDFwk7+7iAtCnbsr+5cqQ1vtIGVIFVQo1jKreniqPXUBGebYEnDlK6SIqbfn9pTkToP1vFUjHYRlYCQfNn9Tq7V+w40X87C+vtMV1je5z/6E10yQIee0PEVI6da+EF9og34zi57pG9JCeyLnwAvnyWUAP0DS7lVWqNdkO7QMTLqqVfsUxwNjyi4V44YRCVQg/zX59d8SRpNFooIdmjR9FB9mjlXyKrxHVQTuX4RwKZ4bGGLBr8F3KRInNQC5AJb96Q37R1WRae+v7zxH2Q2nk4GVD+JV/HUaywCm/ORX/+5oKpuxVXx3by8BBjrduu0vC3qK0yxZGvRxUmrarq6zYCIkk5/sXsCqK/1RKRJWs30aW4EGpvoWYkbKF+poaGv6wqKQOIqk3f/5I5kH4ls6nihfxcGS08i6WDnRmffxbSp2qVml6B9d9vtNR6uzd8Xt7T0nHS3NmC2sOHaHQHGXZE/awBdRQeiqygrRLzKsrZZm1Y7MCop4OQWRU+XxXSgVA+NwzDSUBJkR9lb3rPawSSyHL/+TrmasekdehchyHyhMPH7Qprs2WGF1ycCoujkR9Xmiy6BFeGxWX8ne/5f0eWQ2QjLvdkZYWESzsOXkBLWTDliI0c/v3qo3JTK3rMyCFJXqwuy+ca2DdTUPcTftPv+0Torupv9gokhLzJoT2ARy0+/+15z19GhQpLZrwqDYoaTdCKmBFb9Uhm42posl5lu28uw/CXC9TSj0a9hLALrIYlOe+ZWAzktooya+hvMNpVsQP+04x98bdkRHA0I0R5QyjH2lPsCJD4oh6/Lbki/JNvjViPFZvZYqqQeYf+9L9h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 07:37:38PM +0200, Jann Horn wrote:
> On Thu, Aug 7, 2025 at 10:28 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> > On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
> > > 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> > > ---------------- ---------------------------
> > >          %stddev     %change         %stddev
> > >              \          |                \
> > >      13777 ą 37%     +45.0%      19979 ą 27%  numa-vmstat.node1.nr_slab_reclaimable
> > >     367205            +2.3%     375703        vmstat.system.in
> > >      55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.KReclaimable
> > >      55106 ą 37%     +45.1%      79971 ą 27%  numa-meminfo.node1.SReclaimable
> > >     559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
> > >      11468            +1.2%      11603        stress-ng.time.system_time
> > >     296.25            +4.5%     309.70        stress-ng.time.user_time
> > >       0.81 ą187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > >       9.36 ą165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > >       0.81 ą187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > >       9.36 ą165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
> > >       5.50 ą 17%    +390.9%      27.00 ą 56%  perf-c2c.DRAM.local
> > >     388.50 ą 10%    +114.7%     834.17 ą 33%  perf-c2c.DRAM.remote
> > >       1214 ą 13%    +107.3%       2517 ą 31%  perf-c2c.HITM.local
> > >     135.00 ą 19%    +130.9%     311.67 ą 32%  perf-c2c.HITM.remote
> > >       1349 ą 13%    +109.6%       2829 ą 31%  perf-c2c.HITM.total
> >
> > Yeah this also looks pretty consistent too...
>
> FWIW, HITM hat different meanings depending on exactly which
> microarchitecture that test happened on; the message says it is from
> Sapphire Rapids, which is a successor of Ice Lake, so HITM is less
> meaningful than if it came from a pre-IceLake system (see
> https://lore.kernel.org/all/CAG48ez3RmV6SsVw9oyTXxQXHp3rqtKDk2qwJWo9TGvXCq7Xr-w@mail.gmail.com/).
>
> To me those numbers mainly look like you're accessing a lot more
> cache-cold data. (On pre-IceLake they would indicate cacheline
> bouncing, but I guess here they probably don't.) And that makes sense,
> since before the patch, this path was just moving PTEs around without
> looking at the associated pages/folios; basically more or less like a
> memcpy() on x86-64. But after the patch, for every 8 bytes that you
> copy, you have to load a cacheline from the vmemmap to get the page.

Yup this is representative of what my investigation is showing.

I've narrowed it down but want to wait to report until I'm sure...

But yeah we're doing a _lot_ more work.

I'm leaning towards disabling except for arm64 atm tbh, seems mremap is
especially sensitive to this (I found issues with this with my abortive mremap
anon merging stuff too, but really expected it there...)

On assumption arm64 is _definitely_ faster. I wonder if older arm64 arches might
suffer?

