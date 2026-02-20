Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08A10C5518F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 11:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8286B0088; Fri, 20 Feb 2026 06:34:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B4C6B0089; Fri, 20 Feb 2026 06:34:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF066B008A; Fri, 20 Feb 2026 06:34:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9806B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:34:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B12C1A0106
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:34:53 +0000 (UTC)
X-FDA: 84464628066.16.2A95EFC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8138180007
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:34:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=acMrLj4D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Xg/YMKFM";
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771587289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XSo0bx6+v7n717Cpzgck1e7wIpgbOm3FZVtsrVMK+I=;
	b=x3Vabao3lw9fRn9QDBUrMorGlezf6yzH5TsL81Wxl5TF0ROsA4xpMxNT9bTLo9+GCHwmLR
	etzwU0FFEja/L3qZkNRUdYdI7lsVU55EPlLwMyd3MEZ9eXOsuP7rw/N9WPtGLMKB2x62hr
	dWtFqMDIzTZRn7+9gW0iODx/pqDYsfU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=acMrLj4D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Xg/YMKFM";
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771587289; a=rsa-sha256;
	cv=pass;
	b=m3IyidF1gLMo6bpFAOIY/hgdxD0lgNLvj9TpCyXTi1IQwwuSl655Drw6srh18aMntleqdm
	EDSEDPvxLs67vXh5pqJtdyTEOPp2ucniTUP9TWRHmY5xds7WC6RME4xaoQX96bYwD9crz9
	2gylGKb9uhay05qm7XqzCyvX61MuUfs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JLg8la1623375;
	Fri, 20 Feb 2026 11:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5XSo0bx6+v7n717Cpzgck1e7wIpgbOm3FZVtsrVMK+I=; b=
	acMrLj4DkH5P13YQuD29GB7vlCLG5W/akIaKznpGEyncMOmxn9cBbC/BfW3RonsQ
	pRrK4s5B1sY/HjJVZnsYX4JuqyPZpvnPSMCDZqAHEDujHJ9EO16HRi2OFZYS4SJA
	HgiYgfAkbke+f2zL3f+GyBo04hyJzE+opvQWUIRvDpZWfdScacjT6hzyBMIi02Cv
	R5m5T/55Un101rjNhWW0Q/NybFZouXsxCKqv6kCmdj5P/14Sezo3VcKqmMsE2YJy
	z0h5P1UeylfjW8RVzb1f/9VO9WjbJ4e5EYc2jgLgeZv5TwX+0AhnzW94PdixHVO2
	Pch9ACBaD4GQ/yEqRomQdA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6mh3pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 11:34:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61K9WeAu015698;
	Fri, 20 Feb 2026 11:34:39 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012031.outbound.protection.outlook.com [52.101.53.31])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ce4ay5k3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 11:34:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bInK2fiRTDpis4kYtnURBKmOlJjidbFyExdKdhKWVDbS0+QXMnkPaoHPK3sxBi55kaaRU0hXRBezk6yaxEKxjXO+kqj/eENDWhsuENizhTBDBZ14gkYEob/81WD4tHv3LALLHtqPvBcqFJVNiNp+OOomYYP52/xLZs7SzGGYl7rCu+SLzmxHQ2u9mhU12/TvX0/s95ySJkyklp/rjNJ7jRbgDSnulzTtr7pUlv6SmZCcFaLN+cL7wFw7xd0FePJSqd8bPEzIgM+TWe/Tqv1mLu7TBw6gTZcsD2lr3YRagyj+e607YglJ3ogJpeLH2xgna8AqIYRVCeBfCxvgcJJNvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5XSo0bx6+v7n717Cpzgck1e7wIpgbOm3FZVtsrVMK+I=;
 b=TnOwCCBCLU50O8D1QuWtlNFIx3ZNmlN4rJmYwhKMdDIn3MzI4lqX749Fu939VaitLJ/nkbfic34kXBzCga5FdN16DkgyVSuclT6bq40/skwi9HMzPs/TJSSjfWV3U2nER7wD/4WWaQMlaVvCHHBsxsgFsEAy4LaRz1TDrkO+5DbAhm8atA1+rN9z0k5+6qktYfKjn1/3kkg73OC71dcw4EZaky82RYo+cUeabc/Qd1aoIbDypnP0PumfIJ6JD1lR+qGrpPxcsqaXUv6FGlDTaVv7p+Z3cgHwmHe709WY/gbek/gc3lFZNJe8lddOQ+9R9qOQmGoyLn7/0XdFTM8S9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5XSo0bx6+v7n717Cpzgck1e7wIpgbOm3FZVtsrVMK+I=;
 b=Xg/YMKFMrAUbti90iqIUirHZegTDxQL+Jb2p7PBzxeuZ3ylFhvz3MfS3V5OfxzqpqDq5FFZuZe7Y1kR5AGyQjJnL87OU/vEzyL7dOyE3w3ktWg8jW9U/dJpx6M4CQQwqbSSDQ3hHwM9RB9WsRgkF8fAH0yRnx1rMiH+H4YZ8V/A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5015.namprd10.prod.outlook.com (2603:10b6:408:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 11:34:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 11:34:22 +0000
Date: Fri, 20 Feb 2026 11:34:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
        Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>,
        Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>,
        Chris Li <chriscli@google.com>, Barry Song <baohua@kernel.org>
Subject: Re: [LSM/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
Message-ID: <c521c18d-c5e6-4af3-a06a-4adab56b69b6@lucifer.local>
References: <8aa41d47-ee41-4af1-a334-587a34fe865d@lucifer.local>
 <CAJuCfpHfkDmnLO3u25BaUcRE2Hv=WE1HrhKhqNxu81gFKJ_t6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHfkDmnLO3u25BaUcRE2Hv=WE1HrhKhqNxu81gFKJ_t6g@mail.gmail.com>
X-ClientProxiedBy: AS9PR07CA0049.eurprd07.prod.outlook.com
 (2603:10a6:20b:46b::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f50d10-1506-42aa-d75b-08de7073fe4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlN3dXhzTG5sQmNKZjRWSncxVWhDMFhRYVhScFhWTzUvVDF5aGw3bTcvbDhu?=
 =?utf-8?B?S21pK1hNdHB5UmhpeGdFeFNkT3JyOG5uUFF0RnNxZHh0UTVpcUhFYTJKR2xU?=
 =?utf-8?B?V2tTbFM0dDc3RGVqNmgvS09RT2lxM25WNHhETkxBWmZkM3lwdGtscXdwRjhn?=
 =?utf-8?B?bTVuN291YjYxVTFiRWRnNHUrT1dUT1d2cFloeTNYMkVsRUxkZnd2OXZlMllS?=
 =?utf-8?B?cWpkL3kvcHdyS1V6T25CeDVJdVBhZmtTRzdLa29YdzhZRHo2Ukh2OUhJemlX?=
 =?utf-8?B?SDBRUW4vZUl5dXlXdWl1QmpvRjZINStTNEhMMW5CMHhiVHdKWVhlcS8zOWRq?=
 =?utf-8?B?SUdqM05sOGY2d25Sekc4S1hqR2o4MFBZSHhQOElVK3Y2VkdMejM5bm55bWNC?=
 =?utf-8?B?RTg3bzkxcytlNzI4Vzd6NzVWaVJTck10aGg3OG1PZHlFbThkRGVjZHF4YzN6?=
 =?utf-8?B?KzJzMzJyZWd6SFhxS2tZeXRyZ2doQWRCbHFSU2d4czU1TEMydlVaU1o5YWU1?=
 =?utf-8?B?Vk9mVkx4UHJmTkxFVFdKSnRMcEJNWXY3V20ydXhPL3h1REI1RTZVUlMzU3pV?=
 =?utf-8?B?aUFxc3ZZN01VOEpxU3V2Vm1IcDVOdzhnNnNWR1VzdEVZL1dOMTFUby9BTUYz?=
 =?utf-8?B?Vm1ZS2M4Z1k0VmtzLytNKzVac2dxN002aERJd3phNlZPeEVKNXRZTlYyRWtj?=
 =?utf-8?B?bTVYZzNsbHBoVFpVbEZwVjJyUG1jUGp4aDdENUdGYXF3K0EvSVFWK2NJOHZY?=
 =?utf-8?B?cy9ENmhENGdhSFU2TE1uRWdqZTJ6ZEFMaU5zaGZwa0twL0F4TE5aQkE4NEox?=
 =?utf-8?B?UHBhSURtWW1vcUFIdVdoYnJWb0owek5DbWtEYjEyb2p3ZzMrTUV4SVVJYTFa?=
 =?utf-8?B?akRudU1tNTljU2hnd2ZhYjA1eFhhTVFMUkQ3V2R6YWFKQkxzOUorN0U5eWgx?=
 =?utf-8?B?dnkvcFc2REhsZklNZWJWZ0R6Qjc3VmxQMmNiK0xwWktNVTBibjVBSGRycW1P?=
 =?utf-8?B?L0VxeE5MUEpDYi90RVYrTklLeHBDeWdKRmlkakVCSjJOVTYzMTFUZk5HNld0?=
 =?utf-8?B?NlFiUHpLWDRReG5xYSsvenhYZ1BNaHRIMGdOL2ZxL2FWNGhxTGJrczFIM3hV?=
 =?utf-8?B?L1NvZG1YMTE3T1RQYmE0QkRVRmJHdjl1a2orQ3psWmZBSmV3QVU4aTJKcFA1?=
 =?utf-8?B?ZGsxZmY3WHBqQjJRcFZwdlJqdERsUWFjaHQ2OFBsZDFWdmw1SFVUSXIyWjQx?=
 =?utf-8?B?RThuYVJ2K2w1YmdjaXNHWTVWdTJUbWdNZTBPRENBVUFiN1NoREZyZHZnYzVJ?=
 =?utf-8?B?cXc5bU10OVNmY1p5Ylo4QStFUjI0QWFTbGpUWkJhWEViNCtqQVl1czJJeVU4?=
 =?utf-8?B?VXd4RXZKdnBYLy82OHhRY1VOcDFmSkNUKzAxTGwzY0duaTYxbDVVQzljSUtE?=
 =?utf-8?B?SmZ0RWIraFk5a01ianEzWlhqemNHWmZ2Tjdra0I5UmNhWmRCMmovVjFSVUZH?=
 =?utf-8?B?UWl3MXdIaVJ0aXVPWlArWDJxVUxyRGRBM0E5ZkZScDhrc0RzWlFXSFlpNWsz?=
 =?utf-8?B?ZGVuK0Z2ejJKbXA3MVlzeWtlRXNIVGhKK2RjeGZTa0pFVVpQRVEzNy8xODc0?=
 =?utf-8?B?N3ZNOVhxRHZlZTFBK1ZYM2FqLzBRZTFwNjRGTnl2MEoySFRQYXg3REcwZng5?=
 =?utf-8?B?YlBIcXo1QkVBaUlmNXdFZ0tBeWx3THNVZi9oWHIvYStaMFVOalNzTTEvcG9Z?=
 =?utf-8?B?VWE5b2hKRUNXMGYxTFlkR1JNVXpnTjViKzhiZTRrQjZRVW1GeFhxMGtFcHFI?=
 =?utf-8?B?aVpQTWJQeisyVWhWeEdyMmx2eTlVUmpkNlowa3lCZmdzR0UxcWZPdkNTTGtR?=
 =?utf-8?B?V3JjeDd6OUg3RTU3S0EwNHBENkRXSUdOKzhwOEU4V1RKdEhpalFXWmRIbm8w?=
 =?utf-8?B?Q3EyNWFTUWhVRzdxNGJpaUh6UjZhcDZxQnd6VE5qMm8yRjg5T3A4YmRJdlNV?=
 =?utf-8?B?Tm1YU3RYU1k4ZlNLc0ZPQXdWZTQrWjZPWFJTRXp6QXNNRG5HT3hMUW1UZXU2?=
 =?utf-8?B?ZktMY2xGaXNFY0d3OUNwZldCd0UzWmhBeW9WRnY5NCtyY1htYnp1eTkyMGFp?=
 =?utf-8?Q?/NHXj/ESARfIbbXoHRxwJ550i?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q1llRFpnK2MxWTJZZnB3YmlrR0hBMC9IV1ZpbHhkWlk2WWNsSlFJNGpuc21t?=
 =?utf-8?B?NDQ3bmliTlpLWGk2R3VOa2g0RFpId3BMcExUYm1YY0pyK1ArM0RsYnJad1Zk?=
 =?utf-8?B?d0tiUVhreFVhZzdIVFFXc2Z3SFJOYXMyZ0d3ZEV6VGk3K09SK1FFUEZYSVM5?=
 =?utf-8?B?c2Y1RkRTeW16Z0haWUZqTExEa2VYK0tUY2JMMklCQi84bG0zNWdBQjFqTmVw?=
 =?utf-8?B?ajE4ODlYQTgxQXJ1bHFtTUFENjBUblV1M2lWMStXd2Fjdm9vOTMvOWw1cWt1?=
 =?utf-8?B?RHZKUVBabnE5a0RuYVVJSkJlb2E1cnBmNW56OXNybHBFUUg5OWZiQWlvODRr?=
 =?utf-8?B?VjYyVjNoamVEcHFWZll6blNQVUM4TmZXZmNMb29RYlpmQTNpTm9HYXdvKzk5?=
 =?utf-8?B?dk5jRUxWUUhEaVhwM3dJZTFkOHNaSTlzSmVIZXo4MGg1NGo3S0l3MDE2aExS?=
 =?utf-8?B?enlhbGIwWUhPZ3VPcEplNmUwU1RKYkwvaHduZWd2NkRXK2pnV1JTK0hPV0pC?=
 =?utf-8?B?WitrZjlhUEphaVJQMk9tZmVOSEdTaXkwOE91NjR3OW84ellLclJYdklJYit6?=
 =?utf-8?B?ei9rL0ZXazNKTHBNcVh0dGUxWEk2MzQ0Y0VVWjJDanJtQjE5SmVCK0gya09T?=
 =?utf-8?B?WGtlZGxvUHB3SXFEdUVIUXYyNHB3VnYzemJUQkhJQUFOL3NvcnovaFdsQkxP?=
 =?utf-8?B?M21YNWlLSGdiME5qUVZyQUJnZCtZNERZd0JYVGNmOGs5dUNxZE1lTHEwMFp0?=
 =?utf-8?B?VUtSdmVwN1BiWFpKTURUZitkL2NUUW5Lb0pSbE1SS3EvZ21abnkvRm9ScGJn?=
 =?utf-8?B?ajhZYXJ4YVdyVmpUZDQ5VmYwSXBMMUVlbkwzeVNkdW5NbTFPTHhRS0FYdTUr?=
 =?utf-8?B?M0NrVU9BQkt1VzhvbnV1Q0swVW1JZDZTTEhuaVl1cHdiTG9CdHRjOVRpeGRQ?=
 =?utf-8?B?ems4UWtSQTc2UGtxUVdrdnhaU2QxZEFKM2w5VXVLS3N6OVIwa2NIRkYwaXls?=
 =?utf-8?B?ZnZweVZMamFhcGFiOHljeHR6ZTNoNThZRjNCUm5jUlJkQ3BCV0hVdFBHY09s?=
 =?utf-8?B?L1Jtdm1vNENIQ2k5b2ROZmordHNWdVB5ajkyZEt1NmxSUDlqTjdvR3d0dWlk?=
 =?utf-8?B?ejZvZ1BKcjR1Nk12aHl5ZHJMSTFUcGkrNHNDVmJMMWY3RW9HL0kvbTAxazcy?=
 =?utf-8?B?aW01dHVmdHNzanFNS2lQMzN5NW9laGJQTk5vaWQ0ejAzNUk5bWY1M29WYzFi?=
 =?utf-8?B?TW5QbTFZWkFNOS8yQ0VxUVc1YjY5NURiWG5oMlQwNERocjlabmVERTNjSkQ3?=
 =?utf-8?B?K1JLK0dNSU9DQmc2VkVlWThFMWlaZUhjeWlpNDJlQmoybmpLYWIwdmZVRDZv?=
 =?utf-8?B?UUY2U1pQNFZoSURJZ2hYV1RJaVhnRjBPR1VoSGo4TGJreW1PeVp0MitSeG1S?=
 =?utf-8?B?WUlISCtxTWl4aHNBTHpESXZoNllEdGpwQnh1OGZSWk9ueUZJcmlyWk9kNEJR?=
 =?utf-8?B?aS8ybWRFVGlLL05tYXhGTzNhbDhqRVFwRHlzWE1oMmZ5eHBiZUpwVTQ2Ky9O?=
 =?utf-8?B?YWxJcW1odFlxMWgvK2FnSHUza3ViSUxkRy9uQUs0UFBESlovSTJONENRSTJZ?=
 =?utf-8?B?eWYwVVkyTmYzRkF2TllKaHpPZ2wyLzhSOUNEL1Z0bVVRdWZiTnVwUmNuVnNF?=
 =?utf-8?B?N1J6WnlVcDg4SlRpRGxxS2h6aHJuUFFWckdOQXg1aGJJMGlrNWozeVNUS1A3?=
 =?utf-8?B?UzJTbXVqbVgrVkUrbmRtUkl0MHovckI3VzV6ZGpDaVBqS1lDVkdmTlU0UWVl?=
 =?utf-8?B?U2F3TXJ5UWFQSXlFM25XTnB0aWNxblQ4UWNuL2VicjdHdlgvUW5hSko5SzVa?=
 =?utf-8?B?a0hNVFIrK2QrS1h1SndpSy9zN2V4aW1TUzdwSG1kV1dRRmFiU3JCVWpXWGVu?=
 =?utf-8?B?WXZLV3BwYnlUeEZmN1FNRTkzS0haWWVvN3U0alNEeWtYME1LMDZ6RjZ4d1RP?=
 =?utf-8?B?SklCRnZoY3NYQ1BXSEN3cSt0SHdDYjdzVWo4RkVyVnN2YlpvbFlWc3AzRlI2?=
 =?utf-8?B?ODFINXp0czdlUlE3NjIza2hCNS84UnZZU3NNSU1iM1h1d2FFckc0TWJFR0cz?=
 =?utf-8?B?M0FwMjIydXhKOWlTa3dCTTBLYTY5RDlCRDZIdnRQc2doZW4zZnlVQXFxRWZj?=
 =?utf-8?B?aEh3d1FIaEFlN05YTC9KSU1VSlZVZlQvR1E3WkFPQi85dG90Q1dMSy94ZGhG?=
 =?utf-8?B?NWlPUUJXa2R5dy82SUFETGR6cmVkK09wQVhmUnI1VTRlSGlWbE4vZkpSMmlw?=
 =?utf-8?B?c2VidVh2ZmZCVkRCSE1NYTFhdHhhS1Q4bEFlUzE0K2Q4SStyMnE4enY1T0ha?=
 =?utf-8?Q?miJ8yj0J7NbQlVRk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MLN14Mpf9A26mIMaL2q57FovVjYFipilYL/PIR5IgPRb3VrQmNjtG8FcilDK1lx9uCsdgwiJA6/c8jnIGdkc7KSNUd4S34QY8zmzxt3OaLgLDBB4CYCEJ7R1MUY3ay9o8OxJ83lFYdjAHVSYTfd98b+TGJGtPw8vvCJNZlFbYfzkj85lQhzz4K/Nit2RMDPaqnJrwGQwbqcCx4vRp9Mczxn9iZ5A/etq0R2P/qh9j3IP428fL+2xXXhbUw0BAs41s4fMy1HI+mwdSgMsFrG2QS5eXxF0ioA7qcy622vICBjBcZXwSoWsxoqlDEH1X9ZsYFCrBGmBjGXoS3bSx6hkol2y6ATCLlrgW4zyzSQVWuxzvLBiHLj0Rx6ngGxeX47BnbkTUoxUYNcfUhqZv7+gKLQqhFMzPVg3BYKC8DYZ1J7010pgCMcANhlk+7UQ+aAJOYnC1vQ+jvLpiRaJoD/IMjFpAycDAgUU8Iy0tfTMJnrWaeKybpGR41wZ+eW+aH2/bp1fQeAMBjNYlpNbXnvPRocQfAj7t6aHHyVpk5EIDC+tWva2nEzhqtcWfeGii3Pqg27TAnI+RK10C4a1Gf36NOL3w4yAqm/6eNi1KlX8Thc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f50d10-1506-42aa-d75b-08de7073fe4e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 11:34:22.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pf1uvtNO5x7ycwnFOjVZrsGMUiJkFTSCYvjPSlJlqqOsrdI0Zkk6AHYy5bfo0u7mGO0ZqGDaV1KTGaCLwn+N/65iUvo3kfgZUf+Eoo/CvU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602200100
X-Proofpoint-GUID: DuoPIkYgtcNRm3d37RxXFuOEaYcX5ud8
X-Proofpoint-ORIG-GUID: DuoPIkYgtcNRm3d37RxXFuOEaYcX5ud8
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=699846d1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=nUpw-eX2llXsecpCeiAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDEwMCBTYWx0ZWRfX9+TsFT5tWuZl
 SHdEpVRbD8kQXAuPJalqWW8neFR0rz8zLYRvvbmOeJ4v6z9ySvwVspXCVeOCyermi8e0TvoOqUH
 KEN/vcAZokHoLD3skUToaT2SlrOhaSnYr4MPKw0HY0XsZ/bWmqklZMd4li+aF6z6fXF8rQgDiGY
 jIM0qImUfe9B7DYGARBXqPSiBu6XO0jbwXBdVEBVHt3UMwyGuS18R/ZYqbIWPSHkq/VsZNw5iqJ
 wnOVaupNdae//M6rxkT+xb9ES2H0pUcahJx9WaHECm4DFZ2L/fqgGDS+rSgQm/Id5iQgIhvvRKN
 hK0qqx5uQNCR0CUT0vTBOHaezC9BAsPyo4TUf78ewbtF5yeEfa/2RKjbyYPE3mPLzApJVv2P913
 Ss6zo87UeMZu4iwT9Wt6UigYlfuHU1EKAM5fl2ZtFp8/FyrL+dhl8L7P8yTcwmGemIKmFAPqOJu
 FsN+HcfHTxXyjpGQhpA==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B8138180007
X-Stat-Signature: yobjtqxhrrse4rd9tfex9y9jptegwisp
X-HE-Tag: 1771587289-496672
X-HE-Meta: U2FsdGVkX18Duk6CVrE4boQfCxaxzfw715UZAZpllnMUYsT6/XchSqGQ2HI0XIKYoyN422gUUhvCY4DYrrBp3z82/Jz7h3qBN9aJKQfDJm7qBlLwReswxGyDY9UevbpJnNUMpYmIltRxNAL/quPjYPTLFKGQzu7Yt6ONunhZrKA+VCzo+1M0OePL4aoQ9G9ImzQMIgU84cs7EAvLcX26xtBA8MafgwQ8Iwq3pxsswXFkhFEBq8t3Or1u17ljSGJ8GcTJ5+0WiA/TC/5yyTJS1fGXainqYTQ5mSmHUR5iUYIYAmKVlIWRijWYEZwqloN+IMLFoAtgeUb6FqSGf6YiBEsLQwfuvqX8krJMQmL5gJC3wIz1K2/D4jKmoDAh+U2GCHlA5mIEslCgHgugEmzywPY4AZN7RXgt7P+6BFg23CvwX1zRjjxPVs948TiNj2km2UxSuNb6ixXMZTyOvyySaV24xESFvZ72kdriuMTrx4PbA9tM6spIwK5mQoKtT8EQqCNlSXZuKm0079M4j1WmjD85MKtIS61vDRW7azbAwJLrXPfk4ycOhEODmuXlyaHgvdrn4dBazpx5X6nSXJRxFa0lA2otJeGVrc3gT4/E0Vuzr6IVrfgv1qMNVIZIexH1ovqav+Yp6uUOEorSzRBSCwZpd2mvCmnMKqPyFhU83VAYTSccat3ct6JQnCkidDMgj7U08Q0EOXc1qWDURyVettTelh/KfvdWuWiCvxYijEEg+GefewkKPTd+fy/sg15zJqLjh07P7l0u97+os7WDDZMO3NEnP87MhbOSOrXfrA1tSisLPYiSGQOm0ToyNSSGEkifdtRDiEAAjfd1+uxA9pXae2xdAizLh4TkaSwJZWMNvSMwpR8EZXofTbgSGq9NScQX1EqritSSWp0Xy34zUqHP6TI26XN7OfzYfU8XLX443bxgsZ6A8cfdOGHqATh5o2FGERP8hcMJtxMXCF5
 oLAHztwu
 m+EELiNYNk4JZ6TUw5LA8a3M6UOH7l8u843FP8BzeO+tAP0WkLN/hEoMcID4yJFZCXkzu8BsKNC5QEO+vRur7HvIlxAJrNUTw9MpSbg+pYpT5KtLgEBKCGSxswgkKlFsE1c+lsRL7i8c82ycby0gDx8/Uptwtg0wmg8BDlzGZS74Dxy9O1X2U6Cf7w8JaKACxjmp/KripAmHNGz/XY9lDkuQ4sk2aAmP+QjiNjZ5FPnldaIIK4IHfkDQr0lJRxV1bUkflPoPfTfwRa+aGfde2qynrjELRuGRlsV96SmjML8w9cGhEFDOGhWL4LJjFMGcukNZAGnnkcL6O7mGQ3H1fY+J4RxXFzct4b3Odf+GMV3gs3+/LJIDPd+Rd5TdZW/GoeNRAjybSZKijqT+DRr68LOQSuoSkaHqPqfR4J1fhNjcwvYY7ZqbQc7EzuB7oTRcbtPHcSfDePOPBarCfvLXVEPTWUzoWyxhTqi3ebk2Gw6A3XOheL9GoOYYSmeHcLeLG2QvYwD8ggKSOQ39w3hAyTTS+BrfHKYMm0zpxv9PefuQoipQ5vkD32ZjkiNMNLRngF1Hrx2Rdu82F3HCB8/l65RjtkSqo5Hlp+quvLTXzP4ZURq476Ni+15C8gDotFXKbmCt1cslntdBg1sDB9xotcYVgSrJUQAM9tY2b5p3HxA7fURxuoi1X4uqUZn/pNvacCltjB38QH5vNr4ltfwyQI/VnuYWMwyPtfwKBsLglwdxjTjU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 12:25:47PM -0800, Suren Baghdasaryan wrote:
> On Thu, Feb 19, 2026 at 11:28 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Currently we track the reverse mapping between folios and VMAs at a VMA level,
> > utilising a complicated and confusing combination of anon_vma objects and
> > anon_vma_chain's linking them, which must be updated when VMAs are split,
> > merged, remapped or forked.
> >
> > It's further complicated by various optimisations intended to avoid scalability
> > issues in locking and memory allocation.
> >
> > I have done recent work to improve the situation [0] which has also lead to a
> > reported improvement in lock scalability [1], but fundamentally the situation
> > remains the same.
> >
> > The logic is actually, when you think hard enough about it, is a fairly
> > reasonable means of implementing the reverse mapping at a VMA level.
> >
> > It is, however, a very broken abstraction as it stands. In order to work with
> > the logic, you have to essentially keep a broad understanding of the entire
> > implementation in your head at one time - that is, not much is really
> > abstracted.
> >
> > This results in confusion, mistakes, and bit rot. It's also very time-consuming
> > to work with - personally I've gone to the lengths of writing a private set of
> > slides for myself on the topic as a reminder each time I come back to it.
> >
> > There are also issues with lock scalability - the use of interval trees to
> > maintain a connection between an anon_vma and AVCs connected to VMAs requires
> > that a lock must be held across the entire 'CoW hierarchy' of parent and child
> > VMAs whenever performing an rmap walk or performing a merge, split, remap or
> > fork.
> >
> > This is because we tear down all interval tree mappings and reestablish them
> > each time we might see changes in VMA geometry. This is an issue Barry Song
> > identified as problematic in a real world use case [2].
> >
> > So what do we do to improve the situation?
> >
> > Recently I have been working on an experimental new approach to the anonymous
> > reverse mapping, in which we instead track anonymous remaps, and then use the
> > VMA's virtual page offset to locate VMAs from the folio.
> >
> > I have got the implementation working to the point where it tracks the exact
> > same VMAs as the anon_vma implementation, and it seems a lot of it can be done
> > under RCU.
>
> Do you have a link to the code we can look at before the discussion?

The code is in a really early stage and being constantly changed so _not yet_
but I'll put it somewhere public once it's settled down.

It's also currently just a case of the implementation is side-by-side the
existing anon_vma stuff, with code in rmap_walk_anon() also kicking off a cow
context walk then comparing the count of discovered matching folios.

The code will of course eventually

>
> >
> > It avoids the need to maintain expensive mappings at a VMA level, though it
> > incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a TODO
> > (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracking is
> > pretty sub-optimal).
> >
> > I am investigating whether I can change how MAP_PRIVATE file-backed mappings
> > work to avoid this issue, and will be developing tests to see how lock
> > scalability, throughput and memory usage compare to the anon_vma approach under
> > different workloads.
> >
> > This experiment may or may not work out, either way it will be interesting to
> > discuss it.
>
> I'm interested in this discussion. Hopefully this will result in
> simpler rmap code and reduced lock contention.
> Thanks,
> Suren.

Thanks, I am keen to extract numbers from this and use that to guide the
implementation - I want this to be an evidence-based improvement rather than
simply a rework of some kind :)

If the proposed solution causes meaningful regressions then I will look to an
alternative approach, either way I think it's important to base as much as
possible on actual observed numbers.

I hope to implement benchmarking/test code as part of this work which should be
useful regardless of the approach taken.

When I have this more developed I may ask people to help test this on different
hardware/clusters/etc. to ensure stability and assess impact, so don't be
surprised if I ask for a favour at this point :)

>
> >
> > By the time LSF/MM comes around I may even have already decided on a different
> > approach but that's what makes things interesting :)
> >
> > [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/
> > [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> > [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
> >
> > Cheers, Lorenzo
>

Cheers, Lorenzo

