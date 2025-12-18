Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67CBD68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 00:52:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C2E6B0088; Wed, 17 Dec 2025 19:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090086B0089; Wed, 17 Dec 2025 19:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7CDA6B008A; Wed, 17 Dec 2025 19:52:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE9E26B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:52:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73BCA13B0F1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:52:23 +0000 (UTC)
X-FDA: 84230765766.22.BAEE145
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0FE7DA0006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:52:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NT81OU4o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IN7ZG6c3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766019140; a=rsa-sha256;
	cv=pass;
	b=7Gm/4UP05y6zi2ACX/wAUWeELCunM4h2LpmwZnGT/jelWFsxWc+EPo1dMEqSpi3P36RKXr
	8/d9CtCBUClTkjPEjyMoMO2yps/iz6v1LCVEafIvvkbBySPqP5Tn3rWgwZiraHdeORe4ZE
	AwlTtfj1DLkizXbxhzMt0wr/GLgxBSg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NT81OU4o;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IN7ZG6c3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766019140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GV5CLFq9cPSq0nxkaz+1AGhJODekj3ocf0LxrCzVt4=;
	b=MCUO9UsPASGmf6ffVVdEUL1kv6Xz+PmQBvxF5qA5h0DPqXTxMpThuPzoJQz4dglEEaCDfh
	dvTDdGLVGb4i9IdQD2ncQSEpgXqkNfYQuhWm6ge054cpYXn7HfHrAg3Xkr/ACwQcyUw1at
	RxJLCGxR2JwalJu0ERAHfEL8eHNe0Lc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BI0iE7q3963116;
	Thu, 18 Dec 2025 00:52:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7GV5CLFq9cPSq0nxka
	z+1AGhJODekj3ocf0LxrCzVt4=; b=NT81OU4oBnHoJfAuV8lxGYouPmZl2VaC5L
	rzbcbwYBsuhAuEHqJiF2icPXI3HywmA8NDyb6kP5IHDhHGVq0M59ohaX0GrtRAqS
	wUZ54G2JF9Eh1wp16gX3BbthNUHQkurkUA1coN0VpqEBZXlxxqCMBD1dIWtr2Rtx
	CywcbXG7Osh57A8TqODFfYWPsCtkA2NNHCZOkX0hkw9fFQDrImNipKsm0fwexFOp
	WQAoL88VKw1/Yt2uRZNs1tYdVWYHnfmgsRLh4bVUMW7L/pupUNgSW3nnD+iaoV8t
	J007yuUt6yQVEZ7BgLHKOIMdBELfvJYbRkWu9gm1qEoFLSxQ4AIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b47ay807h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 00:51:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHMxSOq006139;
	Thu, 18 Dec 2025 00:51:59 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkf8frx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 00:51:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dnhO+1FHowqp/kBD8FqIBKjVZ6xJzYeuozZkMUVYjZPa9fIG8oJNBh4hxqgA6It1dnr02Z+VUOiZAcOp1QclW+Y6c64qnj2DGVORtGqX3Duro6NxqQfazhzqeztGshFVPiJroVqE2hlzhOly2QYkugH5srJT3wTKvoLmTbB4JfJzxNOabJI1ZUID3PQFFb1sIMdrkTUCQxJG0i6rGgJ7/BtSCr8vp19Y67zg7uYhPkTrSGPOXwXYzeCX2ScmapNR6mg0zrDy8AzNVMCgO38LfyD3Vx1nJlk/2MDmmHFVTw/2Mm/x7DJ4a9dZEAsRNxKoqQwRY6Vghjd7uDtVjoJSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7GV5CLFq9cPSq0nxkaz+1AGhJODekj3ocf0LxrCzVt4=;
 b=gSkfHrUqdBitNSX0iGcXAohF/hmVbl/htB/PDm3KrN0P931oDvAcZ2UxLrvZKsDUbmbApwLY5txuWhiuNe3DAhRS0CfFhochyUJH+bSjO7ZRxR9EaGsXfuzbau5L4Q0cux+5TEM6uYJsxKBsJnmbFCrLZs/GtSPH7/hTYTsSbUSnsCw31c7aDqgUJx5mjovXtK+V9MH0gDexp9oyMi3C0Yzf4XBZr1xv7UwfXClOPoBlZMDaO2eanfZGTQV3Qo1zo5H3z8i6BoZVPiWRGsi9+kqC2DQJfVnwbTLjn4cj+4cVCOK6zb/S+ksO9H43OieKqgy6CNvp5sqIxP0P8WnQTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7GV5CLFq9cPSq0nxkaz+1AGhJODekj3ocf0LxrCzVt4=;
 b=IN7ZG6c35OVGotqVaSPD8wx7tb9De5llHLOPwcTo9KnQJ0fboxTWpvwsHAb4lSy9DM2lVxNLxo4mjY55uODBvNtUVU6d1bWGyHlG1g/0iSyX5atpOwZjhf8J6G1tlwipEwSxNnwJuwXt+raVPBADONYDth39HnfJF1DjJ75X2YY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by PH0PR10MB4632.namprd10.prod.outlook.com (2603:10b6:510:34::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 00:51:56 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 00:51:56 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
 <20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
 <874ipqexai.fsf@oracle.com>
 <20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
 <87fr994hot.fsf@oracle.com>
 <20251217105426.5f03b5e8abd2e50faee9f49f@linux-foundation.org>
 <87345851kg.fsf@oracle.com>
 <20251217122602.ecf88868aa473ff1d4905a7d@linux-foundation.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, kristina.martsenko@arm.com,
        catalin.marinas@arm.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
In-reply-to: <20251217122602.ecf88868aa473ff1d4905a7d@linux-foundation.org>
Date: Wed, 17 Dec 2025 16:51:54 -0800
Message-ID: <875xa41uj9.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0321.namprd03.prod.outlook.com
 (2603:10b6:303:dd::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|PH0PR10MB4632:EE_
X-MS-Office365-Filtering-Correlation-Id: a2367100-93b7-4f7d-fc08-08de3dcfa464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i8W+pwVxZAhILbOgJtD+3ImEScyqUCsMZrrXF7fCF2su83eAbZNpXuXWz00B?=
 =?us-ascii?Q?WxJDHUiScgDof2XCz6FvLSQ+sycqCqECzQ7UAofaY/S8h7zDLooX3wfqPQ58?=
 =?us-ascii?Q?s25GaCl84qPozyZ9pjrAclKQTjNzSIuxeayNNiU3/UHdcknK+dkjuqgRUfUS?=
 =?us-ascii?Q?O+i6Dj7aY/fanXBM1rzwv7d5wm+8uRlAIUhrNekoDVDH8+5m1gDEW8ACDXYX?=
 =?us-ascii?Q?CEqpeH+bLvMnZZOflfJbtFaJxyIMneAoo7FPfLHKUateSwXvvOgRPONc2ux+?=
 =?us-ascii?Q?nYdBWyiEXesHQ4lVrwZIMwYXuqZzW/Rr0kyYQte/8wcNhKBZVzL8zf/zW1j7?=
 =?us-ascii?Q?X2OPvBE61ce4tzMgYUAUtLNF8953W21R8bLb4/ktglB+92f7uKRScy311tbT?=
 =?us-ascii?Q?8kudp9UqlH60rmSfOByWpVwkmj6V8SLNeb+zDBdWZP++tasM49doQSJZdeKD?=
 =?us-ascii?Q?0j2N7rZ+Ucwqmhr7/dN0MmwAPsmXU6b3u0lfm8Wt7bDgGm5sdQ+jGwaIffx/?=
 =?us-ascii?Q?vc8Mv6m5W5oGOH3rwALKZ5Hcde0LLJlTGBQ0188qEXQplXXSqFU7yTYjqje6?=
 =?us-ascii?Q?5kNyzI/22kNBigQZBMXAn2Ylq9y1LkBt0UL3a85uk09456zrpA9fH5dTb+uQ?=
 =?us-ascii?Q?K9DKNbl11i1y0UujNa+waZK3Re5lTtCQtnxa9d/2oAS27IfLjLMkFK1oOU/V?=
 =?us-ascii?Q?67qr7i3olLHJDSp1dWZgspdpJiXJrC257PoM8YmJUe84aFqrpZLtkqzQMIZ/?=
 =?us-ascii?Q?wUj3CESUczDpBcs+kUytahUDRcSJNq3AlxrwaO5tSU3wA5OZkLzKXkbKcf4x?=
 =?us-ascii?Q?tA56c+LMEKMRtcdnYsVNwskrYLvk/GEy6EatffEVG5LdMctUtK36tJnOEqUm?=
 =?us-ascii?Q?z3MeZRxSTPYeFe9k3khIkvCpEb244atD6HaYDLilodAaBccvsOUxw8NCNs0C?=
 =?us-ascii?Q?+i1grAOCmbPC0P79kmLC86RFfM+Lw5F71YGhcuOFfIasupo+4KlZ/ZpvEqVz?=
 =?us-ascii?Q?cNJ7WPl8HXRhCuyxFUsjkB0bwZtex95BpvtO+euY4GPJzQtfzJiwTRo/GPg1?=
 =?us-ascii?Q?HTq0q8vrW4L+VAy6343Y9uEq8yTVjzRSxbGjaFF/lEd0FFYbHyoSd9pZaMSR?=
 =?us-ascii?Q?TGM0thzBIQL8FrrUUnKlxs30euOmcdGH/q8WRvsTvdqeESRUmlrR91zvyOeG?=
 =?us-ascii?Q?oDLSkrwuayA85qlHWStrATFP4JsOerUyddXuQYdtlKG5bHfA/ALivlyARLTq?=
 =?us-ascii?Q?HSCvLhc8XXW8dDL35myxM4LvXDL47ua9ZzM1lWofLAYWRkftMeIqlWMGh2BK?=
 =?us-ascii?Q?eoW7lqS5z8hMO5+fXskmyZl3d9nGsvkz0iuQdtuj5JkZIK1+nvDKLGxtylLg?=
 =?us-ascii?Q?REQKtXvif6P7DrDAaXcKSE9toX8x8kbMmn7Wr1uNLUcDv3CmS7BvZS5nE05x?=
 =?us-ascii?Q?AMjkQ0ZyeUTPj4GeY2MpaNEUfOJpJiRJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?35WVjvB43NPlZFKjhnCLQWDlAxCmN3u3Rw+bvVheaDS8cKZYuo9/V2KS5357?=
 =?us-ascii?Q?huoAXZz1AFQe0JkowKl00NnjyVV/NAJARC9pPA1JhoESGHpgoV82KhDDXqkV?=
 =?us-ascii?Q?mck++f17HbWg1WxU8pIvS73pT28OVpfCAL6wj9TKGtBT7qys3WUxJKPFgfZk?=
 =?us-ascii?Q?DYRit8L9A6QnWqx0tjFa0MuqqQBkaI7btWmyCv35H8c4uppVFMv9Wi506Quv?=
 =?us-ascii?Q?GrsfzrOYWyb0I8pdZcpmdXDRIhrCZXV48UVX4ef8/OigGpbesQyq5L4jvRYQ?=
 =?us-ascii?Q?FYv2qb/0Krx/z+bO4UmCS6YjazUKB4MDe/yYtZtYjnyPO6jG0b9lzZj5mA1u?=
 =?us-ascii?Q?TpDDJXbxrteYB6X210k9Q0hflooj8eNt55kYXHSPbxTjae7pHMg/fU/2/P/f?=
 =?us-ascii?Q?cnZEzy+MD+EtZtkRaQ3adwBy7yKctT5hzfqCJ8udKYO3pPtxFz8CumKOMCTl?=
 =?us-ascii?Q?z32vRibSgb3SpJSxN8BG4XpvHXgOEEqbE6d+cDnPYQJJw9AMSz3TDaXJs7Ji?=
 =?us-ascii?Q?U/mD19OwxrXbJ6BlnqxABbtFBYljSqLI0q3/aCvZqmbEe9/Ax6tTd4mBmsv4?=
 =?us-ascii?Q?O1oigCxkYKpzHdNfUDGh9Fn6d9AATqFAv+/vDPKz4Ihhrv5j/ZeOH04Klgub?=
 =?us-ascii?Q?H8+EdK/ygaqDqB7dvH1kXiYadX9l4hm5WsXSZVqcWoGrELHWL25uTnaP1ZfN?=
 =?us-ascii?Q?L20TuyAl7Zow0PYCfstrvGqRivXcBVLrqReGdnpxr1IaB22KBsg6MuXfBPa4?=
 =?us-ascii?Q?qDobo/Cg+odQRCYq8ITCUTobjob4TtdbMd7T2ucjRiTR37t40nKyi32FsJ5q?=
 =?us-ascii?Q?VcmwxHDuVIDqjnvAocBR8JEPOf9xp/naxOZWVFN4pEyho8iB5MKnkqVqejzi?=
 =?us-ascii?Q?7CR09k6Nxz2zD64DOhDkq/fSSJiABSy2lBYpfhj+dPBLbtRE7Q3Ma2EyIUdp?=
 =?us-ascii?Q?GuWU8jkVN4udcQL5bK7/k9LV63cjByO/di76b9knh4JutRSeDr5zjN0rzOdQ?=
 =?us-ascii?Q?xpOZghMN7YGxLsCQEmWPdhkKSHQdy+JjbQY0heN3vY8uGvmld6YP1Z0yROdh?=
 =?us-ascii?Q?NE7Tziaou56rlTy4qMu7w7Cbl89YZv9uuDXu/2qozeeQoG1Bi142fI18W7L0?=
 =?us-ascii?Q?KGWQ6oEIi0hiJfFQ6NnKl2nX2tpBQqWyZ4T6AMlzn4ARmYvOF/CTBxfmS0Fk?=
 =?us-ascii?Q?DNRC41rHg/SYqwRYk0fr7oIlov9wiqwIzpX1S9YvFuOyszfuHl7vxiI9JWjR?=
 =?us-ascii?Q?Km4hw3mArlcfwVSBXl192QI4wffubPI3q0pYlO21mL6wY89Ijk5wPencAVKs?=
 =?us-ascii?Q?Utd0sTaDQ7UsYdwJwKs3AK7C6VzctIPWOR1UPg7Kmg087AvOthXER6ps/VnZ?=
 =?us-ascii?Q?Z6tkAeX68Eva6QQ9RE8qALHPEH+8sqvnd+UmJi2d6jTG5tjvDK5WGAJ1bxeA?=
 =?us-ascii?Q?EDNnzKHaloZO4y+XkwmF9DQFk0vUQok8aIc9PGWCDD63TOxvS3oGSnnQyxa/?=
 =?us-ascii?Q?DcO+3jZSY9fzrujZVN2+EaocvSV8G6xuHTgCjbSHtIJaokW83Oe3K1kpFCv/?=
 =?us-ascii?Q?RK1gJq2E7JXiLwdS0UplpVqlacEE8R2j7QezcgiUaFPGPiLFrGgPGAMTYlT9?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s8nOP0NKXu5CtxRygK2Zpf4UCJ4K1PLkTIprWTyOeWQyunQ61wnftpHrMJgGUyPir8oNa8KqcoSaZul5LvGN8y8jpvMIdHFGxwBJXjMVv/5LnVAQP6DuU0HpiFyxP7if+bn4wfBX9hyrdgDsX99E/HVbu5fengZQZtDMiV4oNrJPdJGl8ekuwoT1UW05NMcInJDTyHCBRatqZg7v+jYOkJLWuAJEoxFHP4dQrROgKDIaAwRDHneHQrBFbzzThysOm48XmIUDByBtLHhlOsCNyxqEhj739x2zpjwpLUcuDmeOLvNNh1NRjyakhjyEzZrKPbixBnrw3VzLWX7bcZTF7hXV0VhIIiUgQgekH3NPKfUhfao+/LsyuOjPJRekYE0ijicl50IG7tvX+cYCYfrYEaaq66o8ey2KwnEc2oDmcpVLpg1p5BE/xEU1/I+nayscaGQ1SuBLPCaib9xkqilkKc2uR7kv9zEf6xnu96iVtFYOq+PR765Nb94YKi/pD8uHFTvg8ztuc5msIgQaVCc689uZVF2TFhD7NTTVUUsZx4tqOzvwUd6sKwLKw/ILz6ucnPcq7xEsGBQ+G+kFDCqqr6imd4fMGvggULK1rFOxpjA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2367100-93b7-4f7d-fc08-08de3dcfa464
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 00:51:56.0720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjzSc3PKqXJ1KDwjQpAarJKgSNW92bdQ+HUtSbcC5QhjoQvBOiAHH7L8Htr5X6rJX7/KVXce/Aj+7vJyjucYijUJW3nPejZO9trNKpnuC30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4632
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_01,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512180004
X-Authority-Analysis: v=2.4 cv=foDRpV4f c=1 sm=1 tr=0 ts=69435030 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8
 a=8nWFG_u2Y5897_Z6xFgA:9 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:12109
X-Proofpoint-GUID: ArifYDSCucoIo7_D3UCWrbv3fPVnkcas
X-Proofpoint-ORIG-GUID: ArifYDSCucoIo7_D3UCWrbv3fPVnkcas
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDAwNCBTYWx0ZWRfX89qULY6NNVJX
 hAzfTuaGrg3rRuajO9mfXNJ82HWu9PEEEnK0t43z5O+AD5QHnCc8VXG767xPOf+5eApf3N1Grrk
 LDSY1APl783F2XIYzrRJ5b4XaToeShjfwBgO5JW/e7RWtOOPr/5JtGXNoEVlfmCkjET5dhvz9vv
 kkexFxD142Eq4PFDcbchdwyuw0qby9my5RKF2Ls+Rnrm1Ykayx3uQFhw7V1dUkoLpq+39EdF3yX
 6WNs7vBV1H9puJYDrIWL+TVQOn4/pAtDZS1FGIzNkN184R3TE3D9Y3dMKH0GSaIhGcEt6DNi3TR
 bhEyTlr+/lZl8UGb+wLgZ+JgknGIz/ZNMqcYdHsbWYJuniHgK3CULLnV2rT5pLWHRHlnR/cuIF2
 lFzBNOTepqe14Q8vu8aplnCGGWhz2dNiaqjdZK2mVmWE9jflR2k=
X-Rspamd-Queue-Id: 0FE7DA0006
X-Stat-Signature: 8tntktdmzspjdfgrupmnz17e7rdngint
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766019139-33285
X-HE-Meta: U2FsdGVkX19oyvvBc3hBsJLM692NRFtLZ73dIGok6Qta1DQUyk+EYMdly71bNo2s/3IUKBXu5HxhYgFOiAMDS5xJiKgDVLBJShQDLHGoiXSIh9ivhtg1LVdK4nudLWEzJicH3I9AAj6X4k+uY9URD2jwsMfMTuvpZzzU6dnMvwQG17i/lvn68HT/iaj4PggiFryWtmxknOo4szU62tt7SFQidCn8nFcXpO0QP8EJnY73MWRYVeNGew6bnCIQdnDM2hx98Hq/8WBkTxfjsgfrOcwZpFATBZmAzfOSNvu+PbuRPAs+iNH75Rns9gPKWg1zdTLGSa2UNys2y/XH0QORrBcv9pEg9AcHO2QXED9l+LVYsRvZ0dT8CIKedrKxvJ7+0nJBeaWWZxq57q4vYRHlkrNSwBGSG5pXbe9Lq5z22W2RqlAqKtshAP6b+Rf8nOxZvUotHqACW0FnNSAqnd4sVeXF1x+WAwUJJPCcMGWLtl0TAaAvbjrCCQ9qdbOifwR9Bjk6Odj1EC739KVn0t/I2FkHI47hQnaR5uaHfLZBog19qRPICCYuYb3Knaj8Xa+YrRlmoCeCsNwiDlw9sCp3aEj8Fuammn8z9tL/xsE3LcJaYcbRJk2gx+j7QsN/n1LjBnp/DC2sAT4Lu5J7Xzd0o11RJScs+0RIKLsPVGoZLJ4+tYUc68NOuA32cx/ooTlOSjQGBRM8jXxX5aEeeUh4KpTx63/TgBcOQ5Q8paDQUW3CMaViQROuVHj9GEpysXWD2xTmJEWlBI0gnwylKpvfBcyrsnwPsOthXPC+vbk8EIbCnNcFB0OJjfJ3IU5ETrB63+drJsscvEmi3Yfpp72qA/Gjk6KAqipyxDZdfazmejnhBwm6pMeVBRkgw8iJ2LrJtQFUL9y6bDola9R80Cv6stbiga4hChW9awl+bhZkX6fj6nBK7nKyrq1tg+gAb7J2otgrzNvzaZuNw5FBT3k
 /yyjw8Wf
 GlCERKmPPnBOTSvDhNOQcgNHMPoEdUEitWZS6N9ZhMn/V/O1V+XaqNg/KGidTmpcFsiTaVgJt0BVh6DCXL7nvU0W4+HJWCJNi9uuO7pNHcDPZT9NIrDKutHMsaMnlhLMab5DeODCFH1bASmF1xxIPIOxf4qbc6H9kbIwwqWPoMj5oKUg9u48Ktrghs5ucLwJ9RXUYCppKPM99DXeXBIPvO7RYovW5/Hre1qQhMOIDixoeElBJs2i/yhBvgaskv9At29hNofDujJ98Sgw0UuAzVECOzVWNlUYT2WZyS1vGJs+wDA4Fm0dQrxw2OsGDe14n6WSE1YerIc6qEKbnyDEUXggSl5TTXOGujJJUzWrMSfKMlsrFQcXXK/fETbpG6WCBc7PADygFBqXZFdUSIIWjeQ/onLoBsobp6phs7b8O15Z03Rt6xqs7tr8XgIs5HSin6bX/MIsSCNfn981e/VzePHGl7CyMJogLWLr2ELkAUoP5XP0Wl6Vp8jrss2W3F6W35Oo7tj1pdUBVs3fNSNKSEuZ38UB0OSfu2Yi1c367ebExYjzPhBpFChWyq1KUyHWtmO4AxRr+0CtXiRY7XpUuMsOam2MM+3Z0m5LuSN8ka2pIblah1Q+fhdUN2y/HjGPAipqk8zjQXS0RjN9Zb8gYXzkO7GmAF3mdIUx8dypXGdU002+pnM4mhqO09HjmzLXGQ+aE0X1wGjMooxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


[ Added Kristina and Catalin for the FEAT_MOPS question. ]

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 17 Dec 2025 11:51:43 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> > If so, what's the timing on that?  It would be nice to do it in the
>> > current -rc cycle for testing reasons and so the changelogs can be
>> > updated to reflect the altered performance numbers.
>>
>> I can send out an updated version of this patch later today. I think the
>> only real change is updating the constant and perf stats motivating
>> the chunk size value of 32MB.
>
> Yep.  A tiny change wouldn't normally require a full resend, but fairly
> widespread changelog updates would best be handled with a v11, please.

True, it will need updates to patches 7 and 8.

Will send out a v11 after rerunning tests for both of those. Might take
a day or two but should be able to send it out this week.

>> Anything else you also think needs doing for this?
>
> Nope.  Just lots of review, as always ;)
>
> What's the story with architectures other that x86, btw?

The only other architecture I know of which has a similar range
primitive is arm64 (with FEAT_MOPS). That should be extendable to larger
page sizes.
Don't have any numbers on it though. It's only available after arm64 v8.7
which I should have access to next year.
(But maybe Kristina or Catalin have tried out clearing large ranges with
MOPS?)

Other than that, the only one I know of is powerpc which already uses a
primitive to zero a cacheline (DCBZ). Which seems quite similar to
CLZERO on AMD Zen systems (though CLZERO does uncached weakly ordered
writes so needs a store barrier at the end).

Just from googling powerpc's implementation seems to be pretty optimal
already so probably wouldn't gain much from larger chunk sizes and
removal of the cond_resched().

But, CLZERO performs on par (or better) than this "REP; STOS"
implementation especially for smaller extents. So maybe in the future
we could use it to improve the 2MB performance for AMD Zen.

IMO the fiddly part might be in deciding when the cost of not-caching
is higher than the speedup from not-caching.

--
ankur

