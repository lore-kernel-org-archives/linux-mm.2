Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDED4C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 05:33:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8186B0089; Fri, 25 Jul 2025 01:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9336B008A; Fri, 25 Jul 2025 01:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2496F6B008C; Fri, 25 Jul 2025 01:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13FFB6B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:33:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B35471DB834
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:33:30 +0000 (UTC)
X-FDA: 83701669380.05.7595E37
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3278340003
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 05:33:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e8d1ED3x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=izWS+jDY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753421607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQHBOJs7KEjfC5vKC1aSwbhzkWtpMLUWM4SFvbmmxZk=;
	b=7A1WpmkGyn6SN0oV4B8Ch16CK64qHl5Vl2NAddEqqK224i4qVy/1iGcZGLaeuI/STeC14o
	8Ls5x/PKHoCZ7If/8EnnFXBM78QRRNF2aRqOX0A3Yx83Lx75XKFuvyfV3tFH0DUB9gtHIz
	+yUX4+1MGV8WdDQoRkxnsnXhlRkQbg0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753421607; a=rsa-sha256;
	cv=pass;
	b=C2Hpsntnae83/gN2yU4PQWmIYS7W/V9E3T/il6Ze7tQJdFsmRTHha9ZpDWNKnn9ie8AuAb
	DlC70Syw5m7ipgzJ5cpmt5jduCGVsb+MRqGyhQYiZf9A+GG0es1jaXyZMx7ggwXGhsEAZq
	xYuDuN6OOBbad044I/ZuTFjQIQLXwew=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e8d1ED3x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=izWS+jDY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLkFVM011975;
	Fri, 25 Jul 2025 05:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nQHBOJs7KEjfC5vKC1aSwbhzkWtpMLUWM4SFvbmmxZk=; b=
	e8d1ED3xzOFeN+umKY7kp2LIm/0pAnQ2fPGtGqxFL/PY0mt4LQPIcP2Qz0sF6ZoM
	QOw1NQfnaMeKCiafDaokBNEJLS09GbmQwI5iwNlLfpu3FPSbVb5HOGLxZAeIrP+s
	isD747TkPTt8HOgQ1B0cfQmsYMVsXTFO0hacGbyJTl1t+2c3u2PPO+9IB35pt73Z
	P4nAcclLHFEi9S/9QBmyX4WiCGzq1jc8Z77sAks2UiEnso2sT41kZ63tshAG4uIt
	50rjfoGM/7djGT6Tdpzxz0k481MuitZlkxYFXZJsapjJU3fCqGKlh+gOyJHzcu2C
	+K6ee/BM49hyvRmyyBEMFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k8c4f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 05:33:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P3rVod011010;
	Fri, 25 Jul 2025 05:33:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060.outbound.protection.outlook.com [40.107.237.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tcnpqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 05:33:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIWgfPHtYzDphYP/szGXwoVt4EWaiVeBXjdj7IONWAr53iEX5KzZxiVzmZ7fwVyuHMI9r3sfytVdY+Vz3HujHLw3VMVMOgv5ElVOEx3G0qeKcGVeWTHDlLqpopV3voilILwnpfyKNl0EKC8mDJ0zRBPRRmGYuW3hEt33mvz/x/RXsUIc5t0E75ItA72ckf8Bg25G/bAJ7xDba/roFAil6CVjb+a45t5cmmFExGE9qmGKqIpLgu3QyWp8cmTEOAWfK8sKrtMv7bpSSc6i5pQGNTT5KW39rtfBcIMIoa44ag9DYqmE35iANWabAbVdW2ImJhLR9iaCoJK3GhV5mrUvMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQHBOJs7KEjfC5vKC1aSwbhzkWtpMLUWM4SFvbmmxZk=;
 b=beGyhZsQwcs+6cLlKNWJz85o38B3Zq9F4hNHWzVHkJo3uZ4TX1ayxMt66vq+RhhUIboHE+z8n2crlEZdpOJHaGBW93c/BtKJx8XPuJre+sdYXKlTvbexqC6nhFUrk1/REhheADbaWNHgaKk5UWkLZ78pDXIIZtfXJU+EAb23tGCx7bZn5hJk2M2CxmV/OtmcUSpNNjByQMJMoL7JNu5YfovQOrg58UCWDsZeKV7WQ7WkJmhCuLDQq0dZ+P2Ao3hH0Gqvc7V5kGU6ZG0yB7oUPcYCUCvCNmKmVQ7O4EZBwinMAaXYwy0CjMCF0tuLWN44nc6LxRtIBhnZiY/JpH1/UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQHBOJs7KEjfC5vKC1aSwbhzkWtpMLUWM4SFvbmmxZk=;
 b=izWS+jDY216ZNB/AfStcH/+VHNFa1bmbA/dQWuEjxgzoMj8B78nDQ1+cd6Dl+vB3SXTxRDO+rbuJ3gksJh7gGIaURl4M3lOdPjWHypIy9h5Z8gZU8xJbTeol49U1g2Hu8tp+QcswSj1tb+HmqEKouCilIAnSuoeiTHteZ7/i3+M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5811.namprd10.prod.outlook.com (2603:10b6:303:18d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Fri, 25 Jul
 2025 05:33:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 05:33:17 +0000
Date: Fri, 25 Jul 2025 06:33:15 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 4/5] mm/mseal: Simplify and rename VMA gap check
Message-ID: <00283a52-4aa8-4e0e-8ec1-62fbbca90479@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <f4dda4c4840c69b2ea735bcb6d54ae70d527a48a.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkWgp1M5FWbo8p6_byF+5FzQtcSg3ui0rQ9Mpy6z2_BB5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkWgp1M5FWbo8p6_byF+5FzQtcSg3ui0rQ9Mpy6z2_BB5Q@mail.gmail.com>
X-ClientProxiedBy: LO2P265CA0051.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 5850c0b0-0649-45cc-b9ec-08ddcb3cc27b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c3FKWFM3SXdCYit1NFRxdVVnWmhtVHhJUmhZQkJlbWxPU1ZNWlErTWJqTFhW?=
 =?utf-8?B?bWpQdWNJbUlkQ2hrU25rTmVqYiszNDZJRmxwNXVtSDZRT1NpcGN2QWhUL1Vu?=
 =?utf-8?B?aXZYK1BJZUpIL0I2VCtpYVZYYUFSNnpQQnRFdWlHK1ZaeDVwYzlHcWJBeWhB?=
 =?utf-8?B?U1krN2FJbnVkSXhjcVlkWTNFdzNlQnFxY1R5TVVqR3ZtOHRPVmxiT0xkaENV?=
 =?utf-8?B?SzRYN01qQzFDYlFOSFVJdkhTZjlZV1kzVG1yOTlEYjl1c2pVeTFIN2JrOUZu?=
 =?utf-8?B?bDdLZDQ3MU5YKytYcnVvK1FKKzh4bjMvdTlDQ2duSTVsSnBRVUdWUEdtNlph?=
 =?utf-8?B?R1cxS3RiQkJ6Y29YZWg2dkFoT1lzbFpXcXZ3YUtOaFZ0TzNhK1pSQVVwTWVw?=
 =?utf-8?B?VU5OWXhPTnN3d1JCbEZyL29vR2JpRkpDRE1DRDNEV25VdXBldVU3RmhFcmwr?=
 =?utf-8?B?cFQrajRNRytKZytiSllFMnZFRWErMmlnRVkyTEN1QTVEQzBPTTdsSHZPM3Bs?=
 =?utf-8?B?OWJzZkorc2l0aG51MU5aWmoxOENucE1iT2p5K3pHT1hqMjFZTkR1UjR3MUhW?=
 =?utf-8?B?M2pRb3k0Tzg4WElZOHpEaTMzRVMvZHp1OWUzSU8vVmc4Mmw5MUZXczRwMDFX?=
 =?utf-8?B?cWZXTkg4U1FFK3FwWlZxdlVsWkh0QUoyQkViTWNCb1FKT3pwQklsQlYrMTVa?=
 =?utf-8?B?akdFdmdlSjBCSHBjN0xmRTBMaGM3TjI1VlVuaFVaNkQyQVJZaXZhTGIrK2E1?=
 =?utf-8?B?VWJQNkQvU0JZSWdHMVhlc050YytPdHFXQkJ6SnFkdUpwY25oeWQyR0VBS0wy?=
 =?utf-8?B?T2xBQ3ROMHZJT1plaGlLVjNBRk5oR0xjQmoybFlJU1E2ejRGY0EvbXNMdzhB?=
 =?utf-8?B?VGZJMHNnaWxXTkpvME44TEZwclJMSG10anRpYXhFcjc3cVMvNEpqbU1TMStL?=
 =?utf-8?B?R3Bxdit1MmpiVjNFZkJSM1BUa0hSQ1lNVlIwYTFrVnA1S2Z1T3p5YTB5Y0tV?=
 =?utf-8?B?MVhTVmhqR3dIOWFIWkoyTFFwOXJ6STh1Y0kvc1pWTFJRbkNBOHNKMHZYUjNQ?=
 =?utf-8?B?aDBNaDQwRWNIeTVCcDk5Wlh6OGI4UXFhVVFmSkJxcUE2USszc2VYckN4SGpN?=
 =?utf-8?B?VjVIcTE2NEhTakx0eithOUdmWTRIcmcyNmFRZWFmeFR5Uk0rNnR1allURkNp?=
 =?utf-8?B?NjNVQmVSdTZaM2Y3alVReGZKSThORHpYSldKbDB3Qld1bG9aTjE5V2l0bEFt?=
 =?utf-8?B?WGdHNE1CRHJhWDNpc1orbjM2TFMvNFEvRnIxUUFrc0c2UFlzNDY0YXBOSkNz?=
 =?utf-8?B?RWxSWGlOb3RGN0ZwcE9NVXJhWU5DOGZjWTNqZkVDaFpWOUNveVpCYkdGNnVS?=
 =?utf-8?B?aVhhb2dFd0QvZHhrVzBIaFBEN2VaK1ZqeUtuRGYzNjJlOWZlQWgzTlV4K2w3?=
 =?utf-8?B?c2pGaE5jZ0FZM3oxYW1yWkU4QzZJdGVhRzJPSEpHSjRGLytlOTNTT1VLTWZY?=
 =?utf-8?B?NkJJUmErckN1KzhOdWhleWV0dlJ2NHV1K3BiV0FlbzRPTWlJc0NqNlN2U2ZP?=
 =?utf-8?B?ZjdrUUorRS8rRnF2N2poUXR2Z0ZnREI1OXBFbkpkWE9EdkVrYlJsYVJqVHVq?=
 =?utf-8?B?NnRWWmRMajhQeSttZTUzSGlYa1VpYkd4ckdiTTREREp1bTdSN2NyREdwVDgr?=
 =?utf-8?B?WkNMb0g1ZTBEak5XaFRPdU50Qm43NjF3eStFZ2tYYjZvamZmbno1dnpWbDYx?=
 =?utf-8?B?QXJveUh5dlpqVG9FejBGMGZVeHllbXZ5KzFwYVhXajltaHVSek9JcUxSYkdT?=
 =?utf-8?B?SmI2SHYyNWZHeUlSMW03OG9oODlHWjZESTRvQ3BpOVdyM1hLUU52OXZUUzlS?=
 =?utf-8?B?NnNweS9wN3JoVnVnWHNlM0hmVFM2YTFDTndrTlJoS1BkUGYxaThMM0tHMWpG?=
 =?utf-8?Q?XBZvB4IkfkQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0FCZzc1cVZrUWlaWGxVVDJOU1RyMGQwb0NYeUc5dlRrMGF1MEd1ZURvVytn?=
 =?utf-8?B?Q1BzN3krV1ZYSVdWVkE1RWlvWTBYbDlwUmtUNWZkZURJaXkzaVV5bTBTcjYv?=
 =?utf-8?B?Z1BnaFFZNmhSakhJNzRhNXJsZnBGUURPenF3UzF3Z09jcDQyS21BQWxFQ3cr?=
 =?utf-8?B?d3NaT1EyVUxBNjFvWFc2NzN4dGVCMGl2Z2RpTkJrUkhrTk5hOWFoTUM0NW5Z?=
 =?utf-8?B?VXBaYlhSNERUWWFESENrWmdwY0I3MU1RUFIzdHFQejlhOGNpUmhpTk15Q25E?=
 =?utf-8?B?d0dTbVkya0lyd2JjSERsYy92WVFxTzZHZWVCM3hhbnpRS1BJclZlZkV4aEVM?=
 =?utf-8?B?a1FEekRUcmFzV2JpNHZ5SS9xa2xNL0Yyd3hRSWg3T0VjendoOGJCaG1XUlRy?=
 =?utf-8?B?TnZRcnFYNzl4K0FaZjJSZlRUaDBRVG1wTkhCdGgrc1JHRExCNHJkRVdNV085?=
 =?utf-8?B?bXZ0ZE8rcDEyN29uM1JPSmloSTdBbU9jSUdWc29ZSFN0b0RNM29mYXRLeHdt?=
 =?utf-8?B?VS82SlRJQW01cWJORkNDK21wS2E0QTl6MVlNRGtyWDMwV213OGhORXdPQ1Jj?=
 =?utf-8?B?RjdvL1lVUGE0UkZPQzlESEZZVGxTb0pCNUh2aEtFKzMyWWNnSkRZWjNnb0Jm?=
 =?utf-8?B?aGV4Yzc5eGp4UW12THZQZGptZHdoNUFraGFTK2pJVmFMU1FWZnlJV2wxWjlX?=
 =?utf-8?B?VVVxNXh2MlNaOGUrODhEMi9acG5ZbGxYNXhxcEFiS2Z2R0Q4UmIvNmNXZk00?=
 =?utf-8?B?YkJXWlNhM1R4UktHVEkxZlJZM1lEczR0RHF5VEhvRzJXUTZaMlgxcENkM1gx?=
 =?utf-8?B?UjB0TktmODkxM092UFhCNFdvL1RzK2R0MEU0N0JqcTlwNHovNHhlL3NncEJO?=
 =?utf-8?B?bHlEYkRqQzZ5ZHBDamFVc0M2dk9aUmJYZSs0NEVrbzd6YTdkVU5JdUwxL0E1?=
 =?utf-8?B?bmdjYTd2Wlp6OWhKa2xQMnFIN3U2VzZ3OWNUZXNSd2haSk9VSFZsU3VtTU1R?=
 =?utf-8?B?SFJFRWV6cm5RVTNCYWpNcnZXVkRZMCttWnhmL294VjlaUU5tWE4yN0tyRGp6?=
 =?utf-8?B?bStCd0dsM3QrWE1LMXY3TVEwT25XY2VIT056YkJnZWo5Njh0Z3RybWE5amE2?=
 =?utf-8?B?b0hzc1oreHp4T0tDRkhoVk9mTEVBd1ZRSG1VTDVsNUtMWXcxM3VzYnorNHI1?=
 =?utf-8?B?Q1dhRXRwQm5sNWlMUlgzUG9BNWZxUldqeEVaanF1dm9rK2V1eUJKVGcybXRo?=
 =?utf-8?B?OVdPaXpDS1RmdEFrVHp3VHFVUVpGL2ZBVW94cm1TU1F0eSt4TUpPbllkUmg5?=
 =?utf-8?B?R0M1cFllVlRGMGdxbUhZajRQUVg0VWJwVzR0Wkw4b0RCL3g0UG9iZ2RSRjNi?=
 =?utf-8?B?d3dTUGlMWmlxU29sNmNpOGFjaTFRemFmVnBSajNQRCtaejVuUmhwQW42WkZ2?=
 =?utf-8?B?ckhLazkxaUkvRXJnd2ZieTVsV2NYejZKemJMRUJNM2Y0Y3YrVHJvYkMxSGUy?=
 =?utf-8?B?S3pVNW44N3puaHVkQmpvRkcyQjhhWG84dm94YkdoTlp6U2JTRnoxVzZ1cXVG?=
 =?utf-8?B?Z2h0YjQwdWZSenFCbkhtc1JLcnUvbEx3V0laeCs2OFB1VVByVHU2b3g0Vk4r?=
 =?utf-8?B?blUyUjVSREpnU0JwTklsQ1Z3WlJhNTdaOWdXakp4dTdZTUFjN0hLN1g3SkVD?=
 =?utf-8?B?eWg0Q05tT2hHRnZyME9wZGxNdXRDMS9ueTBkeVZXNXk3Z0lONDYrazl3STZt?=
 =?utf-8?B?V00yTUFWdCtzZTIwSHpVZjJVYU02MmhwbXhXKy9OMU0wZndpS1Vqa1Izc2xF?=
 =?utf-8?B?ZEx6SWdGdHhDbS81VElIVTZUV0NoMmt4M0JOMVREaFJUVjVjRzg5TldNcVJ1?=
 =?utf-8?B?bm5URXVHT0V1ekNWNGtIWUh1VUxRckk1ZVFOYkMyb2dJaWFGRE9lVjV0aUpB?=
 =?utf-8?B?Sld6bG5yaUdHZmZ1VDhmd2tRSHh4YTdVTXRJVXQxeXJEaDVGT2FGMHFpRTVN?=
 =?utf-8?B?NWEveWtCeXBldXVpMjVobzRxVDk1M1A5YktPZm1GK296Mk8wbndtYzJJdHNv?=
 =?utf-8?B?Tmo2SXRQRFJJY3F3UFpGcTEwUE9DU3BCYWxYeXUxeU1KMnlJdlN3ZFp5eUx1?=
 =?utf-8?B?bHM2ZkZnQ0gxMHZrOGlHTXE0cnI5Q3U2eU0zNWFwWW0yU05uRmoreHNDNjZ0?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ADYUOnUEMjrrEhkEyuTNCEMVor1/8zhoZbK8kRus946Jjcq2JwOu0eiBK7LwQCY2jizMkXNVCgEpbhkoXqK7tYQBgjRed2NS5LY2r8ATA+03QB8Bpq7aGeWrFxBBoiut+O0lQfKgheJqW8MRFnifP63GRnf5bh3mpyBGO5S35A8c8LAyd2CawjVX2BtdQGa3SK70UYzxl53/KoQx6iU39qdAP1Fa6QLfUtY7ON5YOW1uOZIna+MHTU/ygFTVWN7Icwa19oGP2zLd5lSo9nD6jQDWVvti36HzAXDUXF2KT7JWwi6L9Vm5Pe+l3FevNBoGYKSQZfLC4Z6ZgOzSNVyPDmwPVnD1CklPwnlPpwXKY6zB2dR7j4aGCoW1/BPbVQ0RDBHnJr1UsYs2kNHKYksEt+1Gw1jWatCYTXERlNAcbAiqRwt5tHA7IBdBXRxZfLY+olvuyYzPsDMqcgwTjpQss4SDQ8DeEnHc/KZg4QC4DTIJ0I89OIULhf1a0IRQIyipcTg8KyfHH7DZ7M8L2Piy9yXvWtyyG8AF/AvWnXR+bd/IkcH9huNrQJJ3fZSaMBGf4dclkHoO97EeAayCxArAgG/RV8u7V7iS6wbpYxcUcUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5850c0b0-0649-45cc-b9ec-08ddcb3cc27b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 05:33:17.8510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EGPMkjGExo8TAzD5B+YYq3cgDvVEnTy4h7RLGsHRXfpD5tsou+dCDxBKH0U/K5gALnE7IP4MPz8xkPbhNiYXGuYz1l3Lr1s4sl6ynGOAe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5811
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_01,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250044
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA0NCBTYWx0ZWRfXwft6BV60vEl4
 pG8L+/ts+7c+jC2PAFvp4HifoTUAgbwdUI46WIoehjHPuHTSh8m9oYFc6JuAsHeZyrEbhJ+yenj
 MGEb3XSqy/FnbWH0qSNMTrklvdSUiuycwB8WminpAzY13FC6avPxKpB3jXqtYkuJeHu7l2caJoO
 R1PUt3I7IJ33EK2PiI6ENiTpy8FIEtm7fcguvM59SNp6wFCnVaeGkD5pPuumRFVorIW3vFogi4a
 yce1+tYNIv4s2Xra3ShtnUwOp3u0f5XePJD/IqQ9tGRWKIXUJYYf4grD9Ssk95yM2u9lxyH4eY5
 oqx2+V96WcRiA3UPHFBs2L3pHbsgcjIZTQpbZrC5EUg7MZzxkC7Azo/zU1uRypu1H5yX2ie9vxp
 HC841RL7AALKZp22h/2Jr2eBhKlceOq468zm8DrWvNerb77/y2O2f0jwFBFxAaPyks5Ib27t
X-Proofpoint-ORIG-GUID: rmIFc7xxe8lXV0lOicKLEEEvHJu5KWTz
X-Proofpoint-GUID: rmIFc7xxe8lXV0lOicKLEEEvHJu5KWTz
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=68831722 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=guNBp5aQCFJKCgXJG78A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: 3278340003
X-Stat-Signature: e1r7icdraymq9og73xqhjwb3igr5iegn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753421607-17347
X-HE-Meta: U2FsdGVkX18glQ3TZB6BJQKr32LVGc7En32mf7UGAA7ADiwnYqCz5NFJLcHqjj8I2KcM+hjRKd4xKlZAsS0EZ15b67KcHQ/B3fUzvNllZm38G1D9c7jcv7IJJO61CoWIqq0+Pt4Qr5EhuSY6aW0AukvXg31Mp7FuJq8RD5hfG/yk/f8H+dt1Kuz9/Ag7WED57/mXnH9qbT6XUdu/B9ha0isXYwTp96Zr6FIr/pQ8M4hXYz/Z4wpNJj91AHd/jOlAKthUu7EvCcgIomSS5hkC5i60Ll+PNtesZJVzrqUfOOjC8bbbyhhlArD9iWv2puyFchfyKga911yu5oCD9ijFZxSVprM5n4DpTOkq6aezIns00VgdZ5dcVWnRjqdgpFedli/Sm7tXtIc0u5NwKKfaT26utu/iAAau2DCXOjElMDkjZUKmzkE6B4r13t4bvC0LrvVHgqrvV2FGLyramXoLE77CvHrNFCYKpNeamjJjoM2fgjQH4zhZ0d247ue4bFWB89Nba/TceN1CBf3BAzFu/soj9/ci3mWvhQoAvKKzDI94pXFTFZWIhCHZmx1a+n8e6V+7QWxYeTwY4FU82dcRVeurDAXkMzqegPz10EeieyGx6gKFURXk56aDqveJOzNhZlBxOLXaehdsjlE+Csffd070uaGuV9FB3/d/T7guQqY+O7yNWcT/49SaNjmbmo2YvraCryBBgtyaaX8QGOsbfmo4wOiwuY9ApKMiPl4ZMlqQpcM/Xr6BpBJPYcjF/Xjd/4T32K9STFlnlOITMDiOrObG7wp0kaVzWL5P1GmzeQkwgxzKTyCV5JAItMZjK0DrhroNoEvH5LU43X8IPNIxt3yg42qvsNmK06xV84EYk02jZ+HUlI8QzJWa8qw02An8VcBttdVv1FD5wwoeZ9TpMkdZ7T1peR5sCihqkEvj/OeFcXTig03FukofEA+58DJEr4aiFbhWhlmFSww9MK8
 qOWboysV
 pzX2Fhx+U8vEvUf7keSNzjO2igpbTIE4eYHMtmjtGQ55OAU8m/iyh25N2Bv7dN6lQod1ofCxJXlNYxBZ0WclUGGE+geLs4KoXw/QZFwZmtgWRXGZbioA+h6OjG5QRe1eLB/LWhTN4nsJ79JijBVn2AiLbFjw2JkaYn6D7bvl1dgNMO0bpKTEXEpjmtsEGW3H9MuEZbwlvI35NIGPKXAFtkdjfAIrisF8T2JKLuWNtahO5U4DSCoiVvhWgixmNeS/j4RmFl7K13gLBLz7AgjTF3pkDTQpiQrzK0x/jgjeoiEfJi2yTvrShtzWtPJwe5cLs6rjMiPkFLKBzr99VddO5Lbhq3LjqCt1KAxQFwMNGdxzPYgRpipSvJoVDD2iAFuL3fEmBObiYnBbFvooLzoluEVqNlid/UipgkojBSEQHmM1LDXwVNfZ1Ljv001fJnNWvBIJr6kmRtOJmn61WsEAjyyued5W6952rTx46J0NgpmGiw/vdkvkDeqmKKYHQGDiWoiwicYM4a/uJEnKuGoRBgdQLh9xqEtBb23XSYhYA/giQvvLDHLdVNmS57cPV+oQTht9I6Lb8FZWFPjno5/d3hEehEVinyGiKkyWZH+6LX/GIn9iTAFImtO+8tuXd2T0GWrSqcDHMz5zavI0jPInjxlogQZMYlRq2h84D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:40:59AM -0700, Jeff Xu wrote:
> Hi Lorenzo,
>
> On Wed, Jul 16, 2025 at 10:38 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > The check_mm_seal() function is doing something general - checking whether
> > a range contains only VMAs (or rather that it does NOT contain any
> > unmapped regions).
> >
> > So rename this function to range_contains_unmapped().
> >
> > Additionally simplify the logic, we are simply checking whether the last
> > vma->vm_end has either a VMA starting after it or ends before the end
> > parameter.
> >
> > This check is rather dubious, so it is sensible to keep it local to
> > mm/mseal.c as at a later stage it may be removed, and we don't want any
> > other mm code to perform such a check.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > ---
> >  mm/mseal.c | 36 +++++++++++-------------------------
> >  1 file changed, 11 insertions(+), 25 deletions(-)
> >
> > diff --git a/mm/mseal.c b/mm/mseal.c
> > index adbcc65e9660..61c07b1369cb 100644
> > --- a/mm/mseal.c
> > +++ b/mm/mseal.c
> > @@ -37,32 +37,22 @@ static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >         return ret;
> >  }
> >
> > -/*
> > - * Check for do_mseal:
> > - * 1> start is part of a valid vma.
> > - * 2> end is part of a valid vma.
> > - * 3> No gap (unallocated address) between start and end.
> > - * 4> map is sealable.
> > - */
> > -static int check_mm_seal(unsigned long start, unsigned long end)
> Is it possible to leave the check_mm_seal() function together with its
> header comments? My original reason was to have a contract that
> documents the exact entry check for mseal(). That way, no matter how
> the code is refactored in the future, as long as the contract remains
> true, I won't need to worry about behavior changes for mseal(). This
> could be helpful if you move range_contains_unmapped into vma.c in the
> future.
>
> Note: "4> map is sealable." can be removed,  which is obsolete, we no
> longer use sealable flags.

Sure, I will add in a comment to make this abundantly clear.

>
> Thanks and regards,
> -Jeff
> > +/* Does the [start, end) range contain any unmapped memory? */
> > +static bool range_contains_unmapped(struct mm_struct *mm,
> > +               unsigned long start, unsigned long end)
> >  {
> >         struct vm_area_struct *vma;
> > -       unsigned long nstart = start;
> > +       unsigned long prev_end = start;
> >         VMA_ITERATOR(vmi, current->mm, start);
> >
> > -       /* going through each vma to check. */
> >         for_each_vma_range(vmi, vma, end) {
> > -               if (vma->vm_start > nstart)
> > -                       /* unallocated memory found. */
> > -                       return -ENOMEM;
> > -
> > -               if (vma->vm_end >= end)
> > -                       return 0;
> > +               if (vma->vm_start > prev_end)
> > +                       return true;
> >
> > -               nstart = vma->vm_end;
> > +               prev_end = vma->vm_end;
> >         }
> >
> > -       return -ENOMEM;
> > +       return prev_end < end;
> >  }
> >
> >  /*
> > @@ -184,14 +174,10 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
> >         if (mmap_write_lock_killable(mm))
> >                 return -EINTR;
> >
> > -       /*
> > -        * First pass, this helps to avoid
> > -        * partial sealing in case of error in input address range,
> > -        * e.g. ENOMEM error.
> > -        */
> > -       ret = check_mm_seal(start, end);
> > -       if (ret)
> > +       if (range_contains_unmapped(mm, start, end)) {
> > +               ret = -ENOMEM;
> >                 goto out;
> > +       }
> >
> >         /*
> >          * Second pass, this should success, unless there are errors
> > --
> > 2.50.1
> >

