Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65377CF8563
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A639E6B000C; Thu, 20 Nov 2025 04:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16416B000E; Thu, 20 Nov 2025 04:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B68F6B0010; Thu, 20 Nov 2025 04:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 784B76B000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:04:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37AC6C0787
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:04:37 +0000 (UTC)
X-FDA: 84130399794.19.6E6833F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id CBB1C1C0003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:04:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lzTmfq3O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QDV4b1Ed;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763629473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOTHbgVk2PXYtjy4uXA6ngbnwrPGDbpKAVysMWU9JPg=;
	b=SzSlM9x6Nt/9fMxsGaSMKwXdi4QAm78xza0F8kLRdooq24XwflUO5EzoBW3Dppa7ClE8CE
	46zNFZUlkwWO3jAIgqner42A/Pj20eNFJ1AkSdXfdNoU86Av4h29Asq30XjQw5fCkYu+ZY
	oGn8ixOzsuZRZ11mIpbZm3xCnZAlLMI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763629474; a=rsa-sha256;
	cv=pass;
	b=MwOkAlOTSzsrgNWHV+8yYJ72bjQNQzksLxaqR8yJm5pEMfyER9fj8MNheUL67HqyqftPNl
	53RHm24Y//TYXnqe7aoXORWiU7C/HHI1sb0qe50oLnpz8d9rF5jj86/kOfWwQ0NoBNaiEk
	X/r/gnu7ocu2wVZECTrwg0DH6uw6q+Y=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lzTmfq3O;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QDV4b1Ed;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK6RFmx027041;
	Thu, 20 Nov 2025 09:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NOTHbgVk2PXYtjy4uX
	A6ngbnwrPGDbpKAVysMWU9JPg=; b=lzTmfq3OWcjW6ZVRC32r/KTZUW/drg16oc
	aMN3Eh+2EhfB2aWTgdSK3qDghXY/jZGuG5V2F0nLn9gjwS+JKYHyUl9wauTV9a/W
	3KpmPQ/+d8qJvyT7CIVnPjtcmmJNFzpZvoUpAAbE+QE/MVAwKWKnHFskED26RufO
	/HiIoZt/xiEPmLBfrE2RObh2RsXSMr9b0tcdhvr/B4jjwxtwtoWX4357WMfMZrpD
	4ogwJDOYhMHiv/WVdu+KnFaOEFKTep6xUWmUY3O6GOKGxHSrg9qOKD2L9zE4anTR
	AfUKSa36xXtjTus0jIJlhN8mq49yRJMK6FLiB7d+yK308gmi87UQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbc0j9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:04:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK7wdeR005173;
	Thu, 20 Nov 2025 09:04:27 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybhfgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 09:04:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UKSOnC6CGnnLC8GjSeOZY2lf66h/gX+JYsFqtr9ZqZ1Bh+hgfEKQGiXSXhp+/jSe1YISH87YktFPhks2hVra+BIdczGGaTNpDJwQvWKiPrHAEYBY6McuMZofk4XGZtsKaRW0NvePE2dwps3N5KFqvhemOqYcJhkJaQzFVgwGbCsV3LNLUYgEnWgyjk3nbKn0xmfIB4xx+NyjcESD4qglgI6T3I+RHrGMbr+5PaLyPw5KxhgHuSXgObVfQPjirrHoakzNOWVjQ1Jb1YR3CYZ9dyTJoZXmcGIRIuMU+/KZIQjlayi2g+26YhjL1XR4tvtNOZ1rwuHS11wIEgeDpCTO/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOTHbgVk2PXYtjy4uXA6ngbnwrPGDbpKAVysMWU9JPg=;
 b=P5/cb7Uiiuv29zxXR+1H/A/o0tbjI1XedYChcWCF1AccyMf6+XsQenLBcjpYC1zvXHDKnqM6O95kY+MNZiMzPBFfbMlDBeyhcZvOUMHbpQiSQ8CnwZnudxWMBIXr1PdFcHpZzqSO/wKSkgjBkRWp3zBmdtF5fvSuvgfAc5X0cg3m/ABumC0NXAZxQkZ+dHwVMYEXabAXw4tNyfSZBU61v71+0NgCx7eW/HgzvvcVs0wk87t47uckXzok8MALYFEJZxZCpSZHROVNl2cJCi8Zq+QFhy7spRlcek4MN9P9A9u1kaKwEUOJ5rpRVF9sO7tqFWhsC5UcMhucm6h1J69AIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOTHbgVk2PXYtjy4uXA6ngbnwrPGDbpKAVysMWU9JPg=;
 b=QDV4b1EdMD6dHHsXbkwADqg92w8EyR46/ctZ88C5NBQKDCpfqQ8YqGBM26ZhpBrRMWzNRCJvOZAE/twlIUJ6i0YkB2j9v8avEmpGH1V5AYbf6RQlT8TGDfNvvS1xnzB/PSCmcb/3idRvKdw1sVPzGdS2r+pPVcBBolelGkPNLbA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6458.namprd10.prod.outlook.com (2603:10b6:510:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 09:04:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 09:04:24 +0000
Date: Thu, 20 Nov 2025 09:04:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
X-ClientProxiedBy: LO4P265CA0251.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b474f47-3a80-4ec1-13dd-08de2813cce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qK+gtzLfu8LlvVyDaIS82HAZm5uNvhQN8aVSmmlOQI4epjUfeUb6LFHxtXNE?=
 =?us-ascii?Q?ZGLZi27s1F0Gqnuu8L9xLg6z3EecS6VV66CgTVK6cc3X8xBT5gbYDDoYfkEg?=
 =?us-ascii?Q?XIVNmNB9kl64/AeJZKsZl7AIoCt1EEnxfUnwaISmTTfa1BwohpuXgW4lae3Y?=
 =?us-ascii?Q?m4044g5W7wKKUreslSpAlAwin96iC+N7iXq5lH1gbxDegdPgvAnG576kfBFX?=
 =?us-ascii?Q?n8+h/gD9atywshlr9wh3cyR7eDYr1O0qCiLb5b1oZAj1VwngNtkl0JgsNFvx?=
 =?us-ascii?Q?GdhjhRO8NM2JBlGFC3fSGBycphFAAymjoL1VMqMsw3MyVaysRFm/YenYRRJT?=
 =?us-ascii?Q?KbJzLDUcW3hucJ4OKjYixfyXyv6aaraAP+usDmEfA11ZFyr9gJOLBV2zerkY?=
 =?us-ascii?Q?KuPm7dYpc/jFVrAbXg68a9ztwFil1/Ht1fSO75w5UFdYzEhWdJgxTtTD783U?=
 =?us-ascii?Q?J2w9+c5mZwdeQgqmnssQmf9fC/p7Liz1Smuc9+qiuP/69luFvZ4Znter+6O6?=
 =?us-ascii?Q?tpicNhuBoOW+9JGdn4wZaAO8XWc6or/5isZtMjmdh7vbc/W/XV7PrjY16+7U?=
 =?us-ascii?Q?+SfH9QAQveyIBOWO9i6q0ojfGNHoETMQ3X7V7Nl/Zmak5tOKMr+FPyJLt/li?=
 =?us-ascii?Q?e86cdXHw84ZoFM71d5PMHxvBbXz09uPJj6w9dstQZRSACz21Jto886tvOmmE?=
 =?us-ascii?Q?iyOpY6hwNSk9Zs6thV3gnIlUrVgxzmA8bqQKf8GU/KSxsdFJz/ko8VVgIz1S?=
 =?us-ascii?Q?UkiG7CmuMzSgQ4TotJGauUm8WqJUrZ5fiUeVBWWVXnoJtEt41eOzO2f4Czf2?=
 =?us-ascii?Q?T0w74UQNtfVudjEo5aRXoA4Vi8Md7k2wHS9snlrD69pHLFf3n09MjwsULjUY?=
 =?us-ascii?Q?fj7rUDBq3GDxYvSwRzEETCKgf94qNso6l2w/xgZjJIFpU4lMBmddJe2bd6nM?=
 =?us-ascii?Q?S0zwj9pfNME6ZvUMEH6ceY0mq4DWcc7U76X+T3lEBA+kNfS02o6IlB0sOezX?=
 =?us-ascii?Q?08G7pPdgdUUksxHgsNWyMS+p6FkXhfXBvXNWJGxDHTy6swx9dWZ26qqFMhmD?=
 =?us-ascii?Q?LdCPGg5QHt81z7sdZV6+MbP9si1/O3MjVCT7hb311UPnVnPJoHk5mFz11Ac5?=
 =?us-ascii?Q?fPl2oiNqXd8h4oQVgsLHcuaWw2KNElXtS6gmDzEM6xyN1j0lcJOy66wmQzyY?=
 =?us-ascii?Q?k16mQ/JjodKX0jP7VKUxIFrgimIm1UvWgBPUSvMikS9hun1SKg8aRlro71Bj?=
 =?us-ascii?Q?i+CTwgJKaaFqsK1RuJAwvPjzx1ifioOKBYIrLOUN9ohfFce3TjKvIM84obqr?=
 =?us-ascii?Q?tP+tzNE6oDteDAlKvf5IvsSp0m7EZFHc8jmIoPH8Bw7/DoRhGlkox4bXrGnU?=
 =?us-ascii?Q?U4phwXct0OTpo3nE3+Ab0qXHMxiNWudB167ZbkTVKKm+HXHyjMKeGYqaNBuU?=
 =?us-ascii?Q?mqoLjAJB1RrJj7ACXwgOM+Sootj7mZSQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1zUCIl+Y+ELtmTOkBlm5SWxNXstKqOZMHJQcXNz5byouMw7EfvcaMf0oBX8G?=
 =?us-ascii?Q?CFBbaF8/dwJTX2PDiiaZEapfhfA69kYQQYFnTjF7FVfg2Lae3tfJfrJosG+K?=
 =?us-ascii?Q?8H+6HTZlou4WZH3q3xBjR1uA3e72TEzWagCaCw+ENMh5Y9QDpPwH8kL2RppG?=
 =?us-ascii?Q?Jfep9hcMldoF9nDy5NXdJi9NL3w+7R4kPm4F4Pk6BRU1Y3v1rppc7E4JhVh+?=
 =?us-ascii?Q?lW+MGZT+cbAGeOyqgnLH5ovYFqRJ9NNjHSE8kifAayHAwkHlLvNX9uW7S+F3?=
 =?us-ascii?Q?/30k4Uo4xgeHnzbYIX89n2bBiOY70ffY5meldaL4y1OuEgUiEOqOMWuwW0Gh?=
 =?us-ascii?Q?rxIYQ9gBCrqaqhm2q1l1MPW/x19/c1ceG+JzzUB1G+kbADDoYwTwHsHnIC0q?=
 =?us-ascii?Q?+6zyftHOFe8dgElQkFAdeSdbSTZy80ouhLrOMHbvS0aTj45yCnqtqWP5TmvJ?=
 =?us-ascii?Q?Wcf1FOKO7a1aJc+O13Hkr2y/ZxChrpQK6VR1Sg9ctGOxaByoJN0FH1V0T6qr?=
 =?us-ascii?Q?dqQBUTElaD5dy/U7KngSqdA5L2eIrU+KgazUTKJ9+EehnMxFTWKyyfLwVljo?=
 =?us-ascii?Q?c/1zD+649cN0husi0GkFhNMRIoh71FyQ1V6S6gJhm8KqaWQLwhQMDsB+r3bG?=
 =?us-ascii?Q?KxyenTgrdOD5Hw1zg0GRZmGSf4r9N/Am2aEH3GVdJTpB3n1QXes7guoYgOuc?=
 =?us-ascii?Q?dXwt5RXtU2z4w+HhI3HadkWZTQT7/r2NtTQWdPgibl1u3/ZVsDo13QYjKeBn?=
 =?us-ascii?Q?QckovQzsaEIFyXg56AvoM0VeAOR+CcAU/rJZeXsCy3G5b/Q3XEpQrGMHDmMa?=
 =?us-ascii?Q?0KdMLnixczoNOPopLCIM6jsCToTQ+t6loQE8bj1AtpNOItjOArhvf3HcPBBB?=
 =?us-ascii?Q?vaFYrUDRrO7BWlz0wAwfZqSoTHCftcqJkHPdjT/riYQrrkaqd7RviDO+TOwH?=
 =?us-ascii?Q?SL/LZZzx8N8zLtSpM/nX/a6ndGyKqtjNysOsS+6moxO64f59rBfBp9RmdY/V?=
 =?us-ascii?Q?nJQ+GGYmPedDmW+XtvYJ01vodY0M2dCiOSVt38v9Wk09L76ViBpOxcmkWwjy?=
 =?us-ascii?Q?W1V6UZDh8BOW7HeKnAeogBN5WuxKJutoYppHLRKt02zcueN9qHkIa7YrdC0N?=
 =?us-ascii?Q?GmySpFbQB3xBVe91eB8O2LLWsT1zzAiuS8Qmd5OaoAnIQ6TE4TlrRYvcBFfX?=
 =?us-ascii?Q?E8sVLt/d42XCGOvOhKF/8QStZmr9zNMt1GDswVG2GuUiWIpQzxpro08C+/GV?=
 =?us-ascii?Q?PuAhQNvFBK0UmYybg+kFfxouG3NtJAk7lwHmyJH4qogoSdpxuhfYvorHK2Xk?=
 =?us-ascii?Q?PcaPygG8UzqDvTYSo+pJJB0fDQgpJlTS/0BqP4LUM1E0r9LcVC327vaYLsWh?=
 =?us-ascii?Q?ze7+IQWsstK6g74Zwl8K/aKc0+RwtSzqJ3KURfT8qJBg2GPZza+g5F9EJu6T?=
 =?us-ascii?Q?yfUV/3JxODnV3bROtzIAgzM6BBP7gQAF+5zPfC1QfUz5j4wYDg1lFG9m2S/o?=
 =?us-ascii?Q?UhpxuCzqDIyVkpiFeMKx5rY8TzdGV8ymf5Zof8G7WNVI8LH0V5nUwOlaMKiW?=
 =?us-ascii?Q?P7/P1AN8ufTq//TShClFsbRHXWwgj8bCBtX/k5aXSjJsJJM6e0v2zIphfuKJ?=
 =?us-ascii?Q?PA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XEwCVW/Jfy+A/wliSGtT1eL6DkUn3EHa7OSDqEmTVsXBRjfgQG9p+Ymi29SkZmr3t0J5VejSnbYCZwv78Gsm4zjOkuPqjC+KlMyQ78nC/ZxL61/6LPu5lIfAVhaOn+CLjH2qUR3WkjI0kxM2HE3/5siEbEu1qe6ABopEfJVvBzLQQEQqImugvtDhOPytvJrGnDbKGOjMr/NIS6Yngr7Om8q4e8s5C0ZfGIU1eWD8uSDqlZgkOR/23PXjkt7veh4J93c1R53AXX4tmwCaryD1IPqzTEtMNS+14IBnt8oSYsnJIQJml/B8vRRPjTmI/VGKYOnwSZ4thO56afy+/TsSHdS7vXoyYfYI01mDqGtbwgx4zdc1T4acJxAPe8K+ek8VLMDcUkLRsjg/ineVoj78NHW0pyAU7X7gVK+3SSR5fi4eRR5qcckwtckdfGfCRt4iEA0wEaTL/HdTBttFBBJ6zxOV5o1Z0ypnh4OgpCiO/JswBlkLo0vKsgXxpcovH9ebIyOTnBbIUDKU7gQh/Dn/N8ZFiwChWkeHXVHqAY0mHJCt1b/CZoonrDlqVO5gKH6cZHWNMudC31qCyK+FGme2Sm0cDO5QoS5UD+gHx2EibxA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b474f47-3a80-4ec1-13dd-08de2813cce8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 09:04:24.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FX67EYYrNRc/E3svkQZrRVyZI4n5teJzWAsq7hH8E4LzN1LZ8oiAf8Pj6lZSXM7nedzCJ7AIadYPKbd9uLQ34hCYo9LgpObwcYFMQizpzME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6458
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511200053
X-Proofpoint-GUID: Aeq_OctBBMFec6aFYZSni2oMsa6bVUar
X-Authority-Analysis: v=2.4 cv=JZyxbEKV c=1 sm=1 tr=0 ts=691ed99c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=orH6H9KePnd4ZLc86MsA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-ORIG-GUID: Aeq_OctBBMFec6aFYZSni2oMsa6bVUar
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX7OrKkGAv4Uxv
 FS4OZTOWI/RFMa6YUapBfowuESfkSAyVS+t2geaLH8BMP66ZgKfP5Y5z8TUoWcdHeiPCdKo6RnJ
 Ct7nIiWU+zhdXVIp6PwxAlz2aLyPsQpbvbJtgoUeyncvaD2ggfO93LjftxWJYwgYvULQQRATOQh
 7toSr6gNEt+5g/VcQRccLKyXBNOqGL25RGhHrpWMjFh+wwUHFbFdiWCdnC3lZnhY3ASMaRNYS41
 c0p2pgr3+xY8tLMVcDNnseLDd05KnwCs1BDfPGnrWaz25YlhGlqAg6SZUjlafypP+uUaM6QVWBh
 m00lavg3l+TmG0r0ngB3+c/wgoSnBpuDOBfj5bNspODwgBeFxc9I+Xpq1rl+lv5RzZ3TCRrg0XR
 VmvTPPFAdZ2tyQZm3JH7VXtmy2+esQ==
X-Stat-Signature: taqs3xzy1ywi66nkfzu38b7omp5i4g7y
X-Rspam-User: 
X-Rspamd-Queue-Id: CBB1C1C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1763629473-543687
X-HE-Meta: U2FsdGVkX18H67EhklZVFTJEA8uE7P5Er9YOSvzxPSxP/ItSqBxwYPS1oHhLoepYDyJEdrazVjz/7hfjnM0bMIhStDc6sGJMJtyQ81rp6u822qY3V2fnf+4BsbIwjud/5/M+56cU7La/QHZqgP/e++zp3aEw/bJZ58XL5mBEZCxDapSoRo1YJ/IFFE/Ccaf6vUJxtSDG5MAhPHzmu8cJBfYYbYGwu9b9ILYHmJh1uUQbSj+xxuw7ML+TyDuaw690bq+UTURoyLPYYDV6Sp8REojJRAbcxALTxP1Q3nV4uXKt5DWooyFJsfmh7rIZEwLAL6TeB54bXuws6IoGGoQsbYMc3q4YP4vRpzzDRlD8aXUw6T16g5pEk72zGPGHXqTDOp3dGlFYVXc08gb0OmJX4ARLYshH77u7dxMBjG9CCEKt6yUtKp+GpH9ykc6g/az0CV4Pcfxga96TBnEAB5l6S2RoyrXAV3duQBTqmc0u24vONMzEexrEvd0FDIvw6ytVyQGpdO5TKT12klGz41s7reo+UZ1YuMpyVe6gUVMQj8zQL+QiyOuH8TF6t8e99e+9PrIvR0j45kQXe7KY3yZEBWTyTB4lD1ZEB1b6Q1uLbaVyWc1uK37HQQiSqNeAxSQQyw3w04UTzyhr59Q9FaEchamQ6Zhs71lvDPV25Hgh22yNuRkof+JBNaaY6zcZAjdaqxYxE4hKtYv+G/LUNgdsbZzgT0T95isy8ix1AmFojA2+ImbvFn3J6H81tNJ4wb6x1uHY83U7Y4ZmOf1XVaj5eDTk5IUcpBN1npfxF7mbIBQx4p1TwpcVfHrLKwaA+RtGkSSjQ5aZhQp/FD9+Lj0vqIZKlpDFX5rDVdMcBx/T191E5YIHIYDDpGArsXdHj3UQdDuDTaYqm20XoD53N+/XNa6dyzHaeXcu+GjxG9AIPpEJ8E5fpmtMr11TgciuDrY/b5bj5Fo+OX8A+WvESGC
 6U3/ZcMp
 Fscl8zsQzEA/5WZpFn4WFgjRy1D/gTfaR74CP46R9fqdyZ0j/iyW0GQDR7L1hxX3U4IMG7AFkueI9U2G63gvBmzVnjqn+vg12YTGdCyi9ar3aEfjmIuxuIYuD8lUiuFTajiNIqBfBIjEXTJDFKBfZVdYbOxeZa6NIiQGgn1FO/mZPe5qFlB3ubbwPgiBL2p/5x8+w8LJTP7Pn/XQzJt7sOUwc4zakzv2vBHEZGm16h8EyJstVJOYRi/eHutvcHjJbPV/iaii/pWlnUdvCvPCYKg33g8TZp/pj2U0VDYlUbnSh/9HFxz4EmNhr0hqha8XPS/oMqjlagbBU9vtS2a8j2ddWfRWvacLKKZaHYpJHydOgkPOgAxhVq/D4M8hM83lrQJ2lTtBeRyqoxcTF19jGskLUyT5iCvN3hSn4HTB+ihPhPU88Y0AzAKjCohz2CJP6SUWeaLBbJJY3sHmdr2sb/pJS18yuNNGGgvc/vEnye42veRku1Xr3EoLF14Wxzi1gm7SUr+ojB5Ni7kF0Lp5oFaWoN5tPqo7SBLMdacMunOYe8d1rcbo8Fyq2s3LI2RTC90t7IbDI2f1j0HXOESKHJ5O4fAnxSm/fnCtpmDahDMdnGXQK5LnGezYZJ+hGm6eyhxic6w+91+9AgpBuZENeh/JP1Vz2OuuEPFStp0xTxlZ6VTRztum9TtT9CSlnYOigcdq5MTW57J2T6CHfGIa5DbnsvQVzdeiEHKlhrSCKY1xXraTLV4Ssf2DsTCkhSpagdyIbbdOIwA3+QQbcG1J/dN2T1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vivek, thanks for the patch.

In general though, let's please not make a fundamental change to mremap()
behaviour in late -rc6. Late in cycle/during merge window we're really only
interested in existing series, series that are less involved than this.

On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> When mremap is used to create a new mapping, we should not return
> -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
> the old VMA would neither be expanded nor shrunk in this case. This

I guess you're trying to be succinct here and 'clone' each input VMA using
the 0 source size input.

However this can't work.

This operation is not equivalent to an mmap(). It may seem to be for
ordinary mappings but in practice it isn't:

(syscall)
-> do_mremap()
-> mremap_at()
-> expand_vma()
-> move_vma()
-> copy_vma_and_data()
-> copy_vma()

Essentially copying the properties of the VMA to the new region.

But this doesn't work for PFN map.

At _no point_ are you invoking the original f_op->mmap or
f_op->mmap_prepare handler.

And these handles for PFN maps set up page tables, because PFN maps
literally do not exist as VMAs which have properties independent of their
page tables like this.

Equally VM_DONTEXPAND implies the same kind of semantics.

> is particularly useful when trying to create a new VMA using other
> existing VMAs that have these flags set, such as the ones associated
> with VFIO devices.
>
> Specifically, there are use-cases where a VMM such as Qemu would
> want to map a non-contiguous buffer associated with a VFIO device
> in the following way:
>
>     void *start, *cur;
>     int i;
>
>     start = mmap(NULL, size, PROT_NONE, MAP_SHARED, -1, 0);
>     if (start == MAP_FAILED) {
>         return start;
>     }

Err, MAP_SHARED and -1 fd? Doesn't this always fail? It does locally with
-EBADFD?

>
>     cur = start;
>     for (i = 0; i < iov_cnt; i++) {
>          if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
>              MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {

Trying to cleverly clone a VMA I guess.

>              goto err;
>          }
>          cur += iov[i].iov_len;
>     }
>     return start;
>
> The above code currently works when mapping buffers backed by
> shmem (memfd) but fails with -EFAULT when mapping VFIO backed

Right, which is expected, as described above, you _are_ expanding here.

> buffers because the VMAs associated with iov[i].iov_base addresses
> have VM_DONTEXPAND and VM_PFNMAP flags set. Therefore, fix this
> issue by not returning -EFAULT when a new mapping is being created.

We're not fixing an issue, we're (unfortunately, incorrectly) introducing
an entirely new behaviour of permitting the remapping of page tables
belonging to VMAs posssesing VM_DONTEXPAND and VM_PFNMAP flags.

>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
> ---
>  mm/mremap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index fdb0485ede74..d3868d941f72 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1736,7 +1736,8 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
>  	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
>  		return -EINVAL;
>
> -	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
> +	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP) &&
> +	    !vrm_implies_new_addr(vrm))
>  		return -EFAULT;

This is just incorrect. I mean firstly, as explained above, we simply do
not support this kind of operation and cannot correctly.

But also here you're allowing !(MREMAP_FIXED | MREMAP_DONTUNMAP) VMAs to
expand VM_DONTEXPAND, VM_PFNMAP VMAs which is really really not right.

The missing context here is:

	if (new_len == old_len)
		return 0;

	... all code below involves an expansion of a VMA ...

	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
		return -EFAULT;

And making _all_ expands that aren't _definitely_ specifying a new address
work correclty. But you are in fact 100% specifying a new address because
you're setting input length of 0...

So this allows _anybody_ to try to incorrectly expand VM_PFNMAP,
VM_DONTEXPAND VMAs. So is wildly incorrect.

>
>  	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
> --
> 2.50.1
>
>

In any case, I don't want to try to support this behaviour, I don't think
there's really a sensible way to be sure we can _copy_ page tables
correctly, and even though the source size = 0 is a cute trick you _ARE_
expanding, and VM_DONTEXPAND is very clear - do not do this.

Additionally, please if trying to make such fundamental changes going
forward _always_ provide test code, it's absolutely a requirement.

Thanks, Lorenzo

