Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D8CECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C0F8E00F1; Tue,  4 Nov 2025 02:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33E48E00E7; Tue,  4 Nov 2025 02:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB5C8E00F1; Tue,  4 Nov 2025 02:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8ADCA8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:10:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9ACB58DBA
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:10:39 +0000 (UTC)
X-FDA: 84072051798.14.0D31EE4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 968A440014
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:10:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Od6bTi/K";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vA6Fhn71;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762240236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9I0t3VIA6lmdzbJOKX9m9wyPaP0orWt9KaKs3n0gmY=;
	b=S4s9xmAOG5K2rlIYeaTMb53mzrx5+zd+YXYHpnTgji0Ulye7gjSg+G1SEw5x73nAd+ilHl
	6kCRrA55K7V2QJg60lBD2LNezTTi3JVargCHEWpIIYWdV5CBhSYCSLqog2CuDPgVy1EGTI
	U6U95Ts+NyjJf92lzMMiH4mg50IlkM8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Od6bTi/K";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vA6Fhn71;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762240236; a=rsa-sha256;
	cv=pass;
	b=0mGngPBc4eb/T+cGTOjkAGXhNEv3GITCchImtacy/G2GzP/gkJpT8KKuu1UW9n8W5rtAqT
	niH9720y5ebOQ2iv5o+BCFOO5avvE2AliCCUHVTss4aYvN9VLu31CLT8aCxjOVJi3rexQ4
	tRmXuKxViZkoy18sF6wseiaS664P8RA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A479JWX012554;
	Tue, 4 Nov 2025 07:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=z9I0t3VIA6lmdzbJOK
	X9m9wyPaP0orWt9KaKs3n0gmY=; b=Od6bTi/Ke0oX05YSIIsl6mK/cXbiZQipbF
	bNl58gbHWzgvLEv9QNQUqdJMZwrha0DZdCu25GTz7HXB4GBWdoOGnX6K3bue8dAG
	JrqD5jUUrDtBTWFoV1V2jxLIdCcCVn8+iHyd9zNxjWSZ8zUEiMgApBsDi8Fll18x
	grQGkD0xptmiMiqmQXlZ8SKQ5MsWla2pMMeYwGNUqvYMycWMQ3GnQkqadlxCqN/2
	fekIhp4K5OWS7OnJ0ToH5dEFgOyewKFyxBLU8MQlQzePAq4X9RsaRr541+RFL1Qj
	+/T1EZezDi9/SegD3XWPzKu2T/wFp+ESGMbjyn1nPBFEl6b8uG2g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7cumr05w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 07:10:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A45jGDM015121;
	Tue, 4 Nov 2025 07:10:28 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013052.outbound.protection.outlook.com [40.107.201.52])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n8yayx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 07:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OVEMCsMV+JpkT9LaHLg9SseK7SsyUAT6SGvj+rMzCafL+nfp8WtIJl4oy8v/kvPteZNsyQHWYBt/oIqfPGGThX9PqFiMF0J+QQuLyGBDSJO5uYJmqrwHmkaTXeOESBcemXSi5nrctFuV2XqdJHKT9XRC9PeBjrlIh1gc/h7vK8RYd60jq1b3kez7VxkLPSqaJdDA89RQnWRo0Dh475oe2DVjupjIilv1GMysiWGCttHg2NZMd05g/sR3M6QO+Zmsb4x5q491QGxY3qS6CzQanDp6PaGs6azory1ud7nwzNEj0L4xraFsuqIvpApewXABWDeRt1kLqVHBvIq0bUsS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9I0t3VIA6lmdzbJOKX9m9wyPaP0orWt9KaKs3n0gmY=;
 b=UpmYtKWSbPYAyvEMOYfAe4GWrSxc/Duesf0KPxepaBbB8qzW0vvYSxuV/TkCfsasWopBHQ+xban1XAIbFJjs58Fpb0p/HAybmgp/u9ILkl+iT8GGfBh7Kf8aXHCxeLkZQQOymNdgZRR0s9jOs/4LC/ceB4OjnZZoSeJd8rN9TFTKF8ZDKsON8CXkehVNnP88KN8/BimR0/tIAzQj7iWmVV0YRWL6AunriVHDTwUCTII1mz8VzA9GGhWmEnq4SZmfdHIGxsCyC5Obi58YMn6byR9LYhLN0t8e3nVIp6VPFrlO3uK+Vld1bv9YAc+RjaPzALHuhz5DF7Z/Rvl2fiRsPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9I0t3VIA6lmdzbJOKX9m9wyPaP0orWt9KaKs3n0gmY=;
 b=vA6Fhn711GmXBPLe3ySFc9EJ+8D9QDk81gjRebm9OSwJ2WgI+pgJDMAq9ZrffGa5t2O71uNO9mkFjVfeeGwvZ2GUwOH/M5jl02w7b9BqvDbSlnV1nWsbPIkmSbYTa7efksVpObAo4iNZoVnWk2VZpnVWM+5YNXHpM01Cm9vagfU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CY8PR10MB6681.namprd10.prod.outlook.com (2603:10b6:930:90::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 07:10:24 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9253.018; Tue, 4 Nov 2025
 07:10:24 +0000
Date: Tue, 4 Nov 2025 07:10:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <565d955d-6797-4c41-bd98-10fd5aca3374@lucifer.local>
References: <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQkxioBXJtPbuJJ-@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQkxioBXJtPbuJJ-@x1.local>
X-ClientProxiedBy: LNXP123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::31) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CY8PR10MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: 33aff0b2-5313-434e-98b5-08de1b713978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lc3a/FPl5+jLkPe9RC20U58bhHpIG7REInaYsPWBxPJlIAsoAVjra/3T/EnZ?=
 =?us-ascii?Q?mJJrcUAnQslDhyL9fOjEmOqw8qn3lVGh+IhJmS9fjRf29p6Bj7WsvRUNKEIc?=
 =?us-ascii?Q?Zhr7fcv5LCcFeU5Nj7Jum35qGrKO271OEo9Hcf6u2h4g9xlBW9finEenBV9f?=
 =?us-ascii?Q?/+ilbXbyI7hnR0M7oUX5kO84wi/NSPwCnGZTg00VC3VkoWUMCPC9Z8eBAD1e?=
 =?us-ascii?Q?AAynfVP8pySVjMFz3K7v43yoXjkL2nOeG3f38iu1AY2CqEs6G6vngU2CQP47?=
 =?us-ascii?Q?x7LaJVFDAoAJ+Ae3ZAZo38woTujGEk50CCZAv0vf7HikRfvNy02dsvMZWzr/?=
 =?us-ascii?Q?jW5qv1Ws5VZulJfzHt1xdCNKJcIEt1WHAgPGivqlsw23ftZfufBncXHP/nMy?=
 =?us-ascii?Q?nev0aHqZ13D18JkTi2PXQNnSbF37EPDJlWN+rJRp7bFCu+cQfFrDwvTTX7zU?=
 =?us-ascii?Q?Nfhj2taeQF5UR3bAHiRfjyVgtMDHpqS3l/rftl0AQoY8tT1Ht9CJoShQI8FP?=
 =?us-ascii?Q?lI3mR+L06wqwEWv1jlaF4xzCjlYprSNaeRgh+2OvaL1DAhqK2vPaWQxkmXSP?=
 =?us-ascii?Q?AR1Qx1yjKlrNMZsS7ZyFInAvNC61qVnNqQ0Cx1K9OI9OK8BoIzqtO0vqsTTN?=
 =?us-ascii?Q?/IYaj0k4z35gz6UzWqssYDLUcg7Udx9zPGBOPhYoEr7rRzamJpIIGr1a/pU5?=
 =?us-ascii?Q?R/NB7BwevSVEQa5AURquGnnnAJLDOTr3BwxG2A1/k/QQFSTifxSV1vcP5LO3?=
 =?us-ascii?Q?hr//l8ClS87dSfi0BjLw5GGohlL2u3bIygKdaOelLuedf+5KVvjAjCdw3QGP?=
 =?us-ascii?Q?C4unPmWNK0WepvveOyvGWsAi08OsivXq29Y1ZuTBiVUtmeowcwIET4KrNvwQ?=
 =?us-ascii?Q?kOqnBgoEpk27wFZGCt3E+1BDPK7cq1ckuEhINGpg2q8+bGGpLyiLivtGMoP3?=
 =?us-ascii?Q?SJtgcrcoU0Le6pVpB7UOngaNTSCbeUORZoxUCggxWe+xKNq0c2mh91o0cG+X?=
 =?us-ascii?Q?ZH7pKJD8eMkA8TaJkadPPlfLHNVA3G7RIaaJU6u1TEzzlSaQheT1KBPL5wMz?=
 =?us-ascii?Q?zaH9GetWI48qX0UdSx0l9B6ZZN0wiXdN7VtI8E8YyBtL1H3Og88e/3PQ+gIE?=
 =?us-ascii?Q?3DJnnJAlQzvBVfAjjrSSRH4Gsm/aRHnqhhFbCgm+9hHox7EN8S2Vu49Y5cUh?=
 =?us-ascii?Q?7UiWozNxpYbBAvFvA/2UGOVdmxVgoaR2Y5D06WF2u0+vxC1SgCQ/GWUWs0gS?=
 =?us-ascii?Q?l1LHK7433qI5LL4zaMKn+VQKRVYyXSDDgJ38S+WSBaElcJaKCRqoyw0Brguq?=
 =?us-ascii?Q?1CWoBXf2sA0yAmzUUF4kX6Lnf7gdL/81oCAW9O5sF8LusqUu/2/C47ZylA6X?=
 =?us-ascii?Q?lDcBjeOv007Rmp9jk5si6+xX6Co2LLQfglhqtZbZw9MY+btHL4ym03WzJ5Px?=
 =?us-ascii?Q?Ygw8gHe59tEMRl5m/fBTCoT4xs/030GV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JccGjU6Ki4r0v2C69AO5GfCMEqUfed3MvlgkpytR2uKulFsKa/LLMKB1LnU2?=
 =?us-ascii?Q?zpbshv/XCN2+Xq3SfCOWGWMGNwNy7XjMU5LvY5GG4hVZ/5fME8UazXL9jWhX?=
 =?us-ascii?Q?rMo2EeuMszq/UmVF6uEX0LnPjSyrDJoUflpnza6JcvI5MEJKMKfb/fXEYhJR?=
 =?us-ascii?Q?6cMe1LJfdRcGB1ImMbpABCOseugsIFmEtozn0DqiwtrPbW9arkI9JWw8LPXi?=
 =?us-ascii?Q?mFI6BSBcq1HMSCUT5YV4JKpLhsdpz8bwbs0C10FHW0l4kZp8MKCJVdDzVpCK?=
 =?us-ascii?Q?ryFuAra1Ii+/aWwPxL7wy7jS4nRY2pyO9c54Gzj5coQL3IVrf6dhSsXbFcJL?=
 =?us-ascii?Q?L3oryg2yzCppOGjApFK4Y5CWrd7NxUyTsv7bIjNbb8N7wwiyTZTLd+kp6nrV?=
 =?us-ascii?Q?OOFua9o1wTOOG2F7clwYKOeQxdiufSkudnlMXeaGXFrj1Zx1I2scTWqiGhi1?=
 =?us-ascii?Q?zCrOM4xAXI1uTZ1iNGu+yih2oHyDduUxF62K6eGkRU88r176T50qaPbPptSL?=
 =?us-ascii?Q?e7+sXjiPF+GJMA6hsYeWKyS0srOAO/5Du3cTPbzn4QAdvaWqPqmMvQsvce/9?=
 =?us-ascii?Q?d/sEah/Y12xdGROxb82obSd9ETBmsxLgwXaxY7Heve1gACYln7vynEZO5qM+?=
 =?us-ascii?Q?umMGiLNHkQKAWduW/1aJ3qYoKZi0Cib+MWpjcG1eLe+88+/gXccsESHVRWs/?=
 =?us-ascii?Q?h7l38JFp8lf77Xd6hMfDpmFhuBkkoDTzWJQoJxMV/eH+px5jQScHA9tee4cY?=
 =?us-ascii?Q?UUaG8xJjEH62vRmWWuZAptJVa9tWODrcYJMvNlrdgIk3ZSnT3SoKoNuNAJlu?=
 =?us-ascii?Q?D619ynF1yDZtrEulaMCVMFAoc/Y4KIaBPNfxs45OQgb8qrV2Whznf19y9oq/?=
 =?us-ascii?Q?OYJFpzPjE+NbaUoGP3J1s8RBJTlMClbpV2V+v7vzlvkkkDh93/Nl+Fv96OIy?=
 =?us-ascii?Q?Cb3ab0ZQnG46ze8pPvSQHbM//+azl7kc2s0J4IdIOqk177oki4m7qhVhUqg2?=
 =?us-ascii?Q?Kkfb3TEl6FtJIjqXee6xcZlKA/GcXCSTtlaCNf6J5rLF2MByLWkM0/LjaCEo?=
 =?us-ascii?Q?0UGxbw2FqkLPsfGyYJmD7uQozrCQ3qdiZojHb2Yrc5Q4CC6C/Q8fuYzWfr+g?=
 =?us-ascii?Q?GemLMV4XAUjB7/vzE2AwRqAFLkcTsKDAiTp2uVmrq0ADv32heyyNazS5hACa?=
 =?us-ascii?Q?ECFmiXAKBsmqQwUcS1qD956TKzxkl8YxSbDSKe2ASqiwADYskou/wWj+v+Qv?=
 =?us-ascii?Q?916Kjy4paInQPv+mY3EuCG5lZh+W6kDLS6b8kG62nUg5Kut1hEq+kXgD1T3U?=
 =?us-ascii?Q?IDf5ZMWeifM7BXETyiMPC2a2kEAaa7mjEDty9nrV4HMocFx0oJu0xUjEFbI4?=
 =?us-ascii?Q?D8oJORfSJz6MAruXNLacXFodR69hChn0ekasKozFmzT+6CENywrnKl3B3jnw?=
 =?us-ascii?Q?VWxWFFCef7JnI/YhmRiaHptdouHf021O/eYxtEREeZiWKA4MK670wBBEflTp?=
 =?us-ascii?Q?IhT3IbP6qN5MNxX7znEk+TSWAe1xkxLerwk0pK4dFqv3W3b26l4ugyM5Sobv?=
 =?us-ascii?Q?KIBs+pT1mgNxw6rtDXcYjN+x+O06wfL0iXebV3Zl+KzdjeYkDZ7qnYV4mQfz?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aXOJToPPRGRgi9VkzSnJyMkH2uS0xoh5X1Wda6CJNAhl4gIJ5dAmsI/b4R1KvJvFiBs7T+ydqp/nEVUaoM1bNx3ug/Hip/trvA9E636O5tQJHOsV9IEQEq5B398qp15n1yJs+1q+oJdUPcnW7KNUdqbXgMDSVpcB2FomzomVE5UVhDaChoy6Si6fcj8j2tYkiIHQlkWhZCEpxneOQOYmganpcBE71ettDvZvpAH5LxochiH3uHZksdnPVW86uPM9otlzIfKcDmC4hrXy9t3Hpc++OxZwt7E6v/bryNPQ+0t1rDGhv9aJ9vWZpblJzho9v81gYL4gpvbxn6GTH3IjqqhEgcC82mOZdXa+qzcB/NVofSUQKJTBTQhpOcURNQAtuhm63EoP+i2T+lzTwRbNL9Orll2pXNYWmkXbY0mDB8P3cTMOVi7a+h9zCkMUjTKA0WVeEEeNYh2URVh4NEgBoeQX+E0e3Ef3ByNrO8KJ6xGILl3jsj2gzCPsQAvpAdnK1BfLtNS99cerqhDGtGVsFWUzd7/EAEouN8sdt4aGdvKtVgQUVbVO8+xPKP8HUA3cCYh+DgIEcsn834kFL5OGNLMLZowazcSpeSbFQ+HZun8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33aff0b2-5313-434e-98b5-08de1b713978
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 07:10:24.3993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qVGjdGEEd8o2jwV55mRK3khSpbWQQ/+dQnernj+zOxoibH+oTd6347XR90D6Tt3/h9wzQCNm4R9Pp9OUDkCDg/26x4Z1mMXBi+aMINHxPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=2 mlxscore=2 mlxlogscore=180 spamscore=2
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040057
X-Authority-Analysis: v=2.4 cv=CY8FJbrl c=1 sm=1 tr=0 ts=6909a6e5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N_CD4KFcaN4A7V1e95AA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA1NyBTYWx0ZWRfX1udFtbOHGM6D
 8mLedMNFmS0iGzEoRZ3FiF6HQBRGJL7cqRnsjmWAMtaqt10xQaKIxrPDVsjOV5pcDUCp6D0UBZU
 oEDyhZd6nZ5+XWrEyjU6gL3zBKCwEMkrwbNh9pNtkxKBC/ecIQF+SU1t1OvxhlDhndsXm8SKNVN
 c1CQ3zw2negHmGYPovSqP39+5t944WnAp/ZySwukgo2yIdDxcWMlSQuOcn6iuhx5zOAqefYms/I
 8vCuwmAXNiuzBmGfDkzfk1pMuf8VQGP1q015k69L33Z818B9pKluqN7yTqlIiSnKc3qnqGuVI2p
 SqE7Jx4CwZXzagZV/TY1xMNhRKhAfGzxVdP23jJv1X6pBKx0NEOayEX57m1WgcqyOsfgdrFtgrr
 ooCvgLIikSQCR8b3tvOQsCoYrHwsCw==
X-Proofpoint-ORIG-GUID: NOUMKTvrbnSJbz253hHti1v-fLQ-xjMB
X-Proofpoint-GUID: NOUMKTvrbnSJbz253hHti1v-fLQ-xjMB
X-Rspamd-Queue-Id: 968A440014
X-Stat-Signature: u8wjqzpsra5e8dphrkyazb4diqxhjmka
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762240236-997506
X-HE-Meta: U2FsdGVkX1/kYhJzx5mHRT6uqlFIaSwicrHN3iYiUTLKpdoYUQNleMNpktDf6R9h6GKB7a3xijaqdZevK+Zg1mt635JVXS8PR3Jgcbz/5ArvmMBFhpkuOsdNhWulJ4kLfNybqulp5NEkpwR2aqyBbOP4UAsehthos/wG24zd2DrMVhXZlGZOmyHgdkWVxrI5teurfgxwuUrWgaRABpnsy9igC6CIkSlsqrKmJAGUmOh3NW2ZHIzrchAGHm7wntWkPk6AJ2t9PLGF064k+UjrkiosWmf9TYuEDp+eu839R/54ns/ELl0mTtounZTw60P5chSfTXUfoLTJiFqWTf3Vn76WCeVHRXiCR0JZ9Hj8SCnQTaNZGZSfp/lfZD/CMUgC6LaR5YqqKvwsTHMnjNkkNJ2Zr2uTKj7NfSgVMASkmRICjRNfMYQhL+ewTn2VeY7x7R9ckslqXDT/lpXHOnq/Tcjp6EdT5okyvw/CtQCuPy8fw3aTdN7fD1H31ejRh2FjF7W38qEXOnC05x8JpQZlld6Lv1dK6Zpf2h349vIQLphGnhPqZdAtx3dwfYcSaMlryYuFmtA0L2w0DHS/eVJFnOH/iIuMPcqVcsIEm0Ertsnyef+Voci1YsmyZWBMGSPmwCyffqAk9wLjr1cLYjWrxT018+BFQeEpw3z9RPTElxyayzhzMeICGXIUCs8PDlkPOOhDirps2A7mPW5OV8zZxSxPvnMEHdwFbue5uZQka6eF7PwGVxMkLCMLVKIozBhqdPYrkdJrKzs1ux90PpyqA7SbO+fO5MQHUqubUsVbL+7w3DSmludIIgMMkKhabpoN8P9OwHUJHDlqhRmUQ+rQcfx5TF0nItwauqGOAhKDu9/D7YF40CL58dtD0bDZp3WLnnwFy2t2Quuv+8324dB4n7S/hBh71kPduKH5i5Ukj8fS6ENeqAU7znyf2I3IGaJ0c4a/vkE5DEYeXgqxfQk
 ar9UeEfk
 lTqElRopscOtpUGMtcdQbtmpUdOzUpzg+g7hDCWy0wA9L49h/m7XS3/MLRAVez8dExFn1b0qpdEjyFpwhmZtqw4hsGmvRDv7eNc2d7pR8y73+A+9d/FvaoGC+dWMS9kJhztKVceWOvlEnN//4Og0ryxGC1e5AHos2sOhRF+K3HPrV73gQSGpHQJrN2S9kzyl4eoFFFutscp5mFjvELm3c5RGQKik53jDloAtWhS1Jk1SD+ZLTDs4/WOB6GU6ytfsb9d5PwPkgbc2gGiDSS1yBcnr+SPaBULx93vwEIqXuRijxfvDNxsppnySN3VcbWN3O2PGc7fsahKihVOYPYoGOoZTNcFrUuvlVij1wPu+QyqLnPBndin/DrAdeb8hweMQlPyMNzd6+1uUgml0kWfcvhuIU5abfa4wFVuZqIsh5cgYYMGM7ebJUMWOiLD3Mk06NVGNU48gn4+dZvaJ20zHRMo3I6hk0zw4Mjy5MuJ8LAObU9DD6/MGaicZWu72mt2NnYHhpyOFCOQwEjaQgDaMRUv9LB1mva7Lp4uE6+8r2J1d+ZTsZitOjrh//MBtT2sOynJKaVEdIRGbkZ8dHmf3ItJTJa7PvLgcB8j7Nr2HLyYQawtcnVmjIloVUA+9bwR44+EbfHGmyPRZcoOY/to0CUBQI4PiiybyY1Fr2+4RtX3OrmoHvQQwI7kAte8K6J/NZEuvJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Peter,

I feel like this is getting entirely out of hand.

You have three mm maintainers telling you that you've crossed the line,
with respect - might I suggest that's an indication that you in fact have?

This is perhaps the result of some level of miscommunication resulting in
your being defensive due to you misinterpreting good faith technical
feedback based on genuine concerns as some form of attack.

They are not, and have never been. A couple instances of exasperated
reference to UFFD code in need of cleaning up (something you admit to
yourself) does not amount to this, sorry.

I find your comments about 'familiarity' deeply disturbing - UFFD is hooked
into all of mm including VMA logic, page table logic, in fact a lot of the
issue with the code is that it's coupled in this way - experienced mm
maintainers' opinons are _entirely_ valid as as result.

But in any case - you ought to engage on the technical points. A blanket
dismissal is wholly inappropriate. If somebody's 'unfamiliarity' with parts
of the code base are an issue, then you should very trivially be able to
push back on the points raised right?

The issue here is non-technical, having experienced it myself, and as
exemplified in this thread - people provide valid criticism, you respond by
essentially refusing to engage on the points raised.

The net result is exactly what's happened here - Liam has (entirely
understandably) decided to no longer engage with the thread.

I've not been engaging on this review either - It's not that I'm bowled
over by the technical arguments, it's that it's not worth the effort
sitting down and assessing the technical merits because what's the point?
You don't accept technical criticism and I don't review/maintain this code
so am not obliged to.

Your desire for a '2nd opinion' seems to be more so desiring that people
agree with you. You have received a 2nd opinion. You didn't like it so now
you want another.

Your series will likely now land with review comments unaddressed having
silenced criticism through non-technical means.

Rather than all of this nonsense, we could simply have had a technical
debate - with strong feelings on both sides perhaps - but constrained to
the technical issues at hand.

Instead we are now going to end up merging code where criticism has been
silenced.

Again I question if this is how things should work in mm or the
kernel. Perhaps something to discuss at the next LSF/MM.

Regards, Lorenzo

