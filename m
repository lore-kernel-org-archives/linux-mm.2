Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48C6E81A2F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 15:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163756B0005; Mon, 16 Feb 2026 10:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B4A6B0088; Mon, 16 Feb 2026 10:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6D66B0089; Mon, 16 Feb 2026 10:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7B7F6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:09:07 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7690E1A0E0D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:09:07 +0000 (UTC)
X-FDA: 84450652734.12.90F4390
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9726C0017
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 15:09:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aBrNrEG7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hmm1/Xq1";
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771254544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RhYqTbC+u6Bw6lLs87tSRXdnItCzLn8wbsy4VgQih3c=;
	b=ibyDG4BPy8TP6gxT95G/gG0Eg6tW131BYQ2nwSFLGO1lJrn+JUs0bekhZETyGcZ8sVQCFs
	iLYZ2Ib+C3IF9rQNXzlobrH3eA6axSl1FCCecD9D8EoChxy03WdI3JKJyxSeQWc81IG7fL
	OdF7acQgaOYCkpEsIC//J08ZwGZtf5Y=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aBrNrEG7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Hmm1/Xq1";
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771254544; a=rsa-sha256;
	cv=pass;
	b=xS7j4M5Q3yE0+7tiSpO52lY+89kBjatox0xePMnLoYO5p2r7bkk7f29mC+EHdTsvftOW9+
	ZpbHPKGHkMHijSbhkoPe8bzyE/R2jsW6jVRtrmYhU2AH42+Tcu3/ERdlOw9S3yVxcduoeg
	LRRR+joKLIGWid+i8SVZ5O6TjXWHZws=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61FNQTRn3976109;
	Mon, 16 Feb 2026 15:08:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RhYqTbC+u6Bw6lLs87
	tSRXdnItCzLn8wbsy4VgQih3c=; b=aBrNrEG73/ZTzAwyacByOQotV7rHyFvOfl
	HsdtCua8N9GfUEan6AcQZI7tQaOBDCxG4c88vl8kVTwR48AFL8VQS9vbrpdXLPcs
	nqYzxdVSfJdXO+HNVB/QqXCTPYXZV8VYYZkrRe2GtBdWctrLo2fFCEVs0PBBsPgS
	Z3eT5H+wr23+sS81FLrsRXo15/PpTsFZm0IzTPDtffKhWdsHIlXgQPPmP0KqKL1r
	8QDIGRqwmFSQfCpS1U94N/Lr45KJwPskiTZ/d+C5aSnVCtjQAOHtmeX1gFWDQn8K
	3h20EwBLGVssA56frB8KyrSO8AIz10bQ4bhcfg4yjhAuZfKxglzg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r27ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:08:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61GDvvXK035390;
	Mon, 16 Feb 2026 15:08:48 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012054.outbound.protection.outlook.com [52.101.53.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cafg8fq2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Feb 2026 15:08:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9gET4d2CkYR+RGRkVU3POp/SxvpGjEqzhGrdxmb6L7nkLLZ0BnFY+w2Y+WlUq4QvnXah11VnRdR8O45mEUt+xuxHgoJhL9QWecExgv21eruUCeEZdAPJAFVnofif3YHL5K8jJmKH2+LVwzjhxbQdKGwCP1dxk/birdNgJDtgYiDjo+5FU0jADwlnVnChoXK9YOLsPdiD0Ki2lq/G1z6tHFpKz2zQomwm+oRF1fphmVQiCZt+Dgdt6bew9V0TVEjMa/HR65vho5W/W5DVB/8WdWK60GmRbAro6zy5xB7HNUoSfNcpH4hDDvMdviZFid3zZjNTKM+fTokYh/RQB63xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhYqTbC+u6Bw6lLs87tSRXdnItCzLn8wbsy4VgQih3c=;
 b=t3ypmASYjEy3QPLd09rMviUou+bBmbJu9SScIO3E5BqHhM7l1Qa/p2EqAEEUENy5psO2RS1UBAkswFRvm5QfkuFafYt+QtTgGbKCo+51LMLvflS+pq5CGc7tggg25nuTCflS9g9t2bhuLIMT6sD/XihJ41RdWImtZ5LaA9WsNzJxzKF6Xc7JMb+sc4t1JhJNknZjEdoqvHVuqfb1fE7CoapjjOBBPbNmFwTd0fJpHtsykTudnCR+40u27qqI15/oAvRMt2PO/BJnv+6EeeBosFN+eNmGnWVvEOhX9/jkiFEp91Re4dXTzIeDKeQf3xZaVI/kvjECMv5sjCmBXLXdng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhYqTbC+u6Bw6lLs87tSRXdnItCzLn8wbsy4VgQih3c=;
 b=Hmm1/Xq1aihPPN36HrvWKYHQUdsVL6IJfeLfWscq0f45Apwz2CmH5L13lGf1z60rVVY6uaCozL2LXcJXH+GSmBCnrOfpZUAeL33oZ4LVDql2QaLM07mgrvyan/nMl6SuFSeiQ3OSnKUMNOJqypQIxKi1H9hpYHMcx+oHbN7n7cU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5874.namprd10.prod.outlook.com (2603:10b6:303:19c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 15:08:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Mon, 16 Feb 2026
 15:08:41 +0000
Date: Mon, 16 Feb 2026 15:08:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: change vma_alloc_folio_noprof() macro to inline
 function
Message-ID: <866d4c1f-13a5-42f2-8492-29fc5310323a@lucifer.local>
References: <20260216121751.2378374-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216121751.2378374-1-arnd@kernel.org>
X-ClientProxiedBy: CPBP307CA0011.DNKP307.PROD.OUTLOOK.COM (2603:10a6:380:1::6)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5874:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ebbf1ce-dccd-48fa-928c-08de6d6d4565
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zx4OPBJxwydVTwNwSS+Rarm+88ofUt9gCeY1ntzPNXFnCbXBYLGOfv9bopSh?=
 =?us-ascii?Q?WL19hgHOfJmiCOoUbTjg7YpbZPed1aJ2QZeRQkjETicVI8qmBnv/MI/uOGCj?=
 =?us-ascii?Q?j4DXYhSJJHPPHTCMMER2pGSY6zteO+Zn8MbchZPtVzXY9J9Ui4YuWqyIRmNH?=
 =?us-ascii?Q?XXD3Z6d5mymR9RjGHlwQKpn9B++e8udpM19mgZ0NfQ8xoOC6jW1ENFtbTqoc?=
 =?us-ascii?Q?Sc3WTXakWBQGmE8f6F5yP8mIamCBZPOqIqSRvi3z7KEKd/lYO0Y2Ok4ayghF?=
 =?us-ascii?Q?XKcf6ZyGFTpi/YcSp8i/fDNQ5OXsMnxDg5F6gkb66jhqPUtr7iDBmtVTuINE?=
 =?us-ascii?Q?wFK+OClpNX3zbYNe/kxEMEGMWAqO3BZ+OC5ar+jM98Ce+dcEEIT55QiD+Wzn?=
 =?us-ascii?Q?xSQHYaoi+I7q7stK9MeeF1ofZChfeJDL/ggOcYy8SU43C4OAFbSJJYE86sW4?=
 =?us-ascii?Q?zJu0pKSQlzf3NOMagmAU7GpcNnl7QtJ1lFdUtC4ILc0ftnvRkncB6Ui8h11U?=
 =?us-ascii?Q?aDGW31QmJMnTYfa9HFMVCNHt2uXuLdlCb9ghlHicQnAHBKDZr/NgWmsxzsDn?=
 =?us-ascii?Q?NCDepNCmwpd6ddDfKUVat7+muzVKMTJVH8TQGujDipdz4qH+NgApAG0BUNFA?=
 =?us-ascii?Q?Tib7DJFWfzcLys6vEJxWeuPgNBRhg39BjdzC6DofWDm3Mm2hu+8Lm9WWIN0V?=
 =?us-ascii?Q?Ud3thY2ZOymS4aDWJjawwHNY6qJLqBpWTxQP8kKZZYPy7zOZpZ3j/ZPldr3g?=
 =?us-ascii?Q?uDybsMifV6ZklEd1V1Z4zn9yuIKWAa56/mC9dcy/1bW5QcmkTJce8ylhBrPB?=
 =?us-ascii?Q?eQ88mQAlytKoqtJhHCzjx8NhJA/+7oJVFElXdi3uqSvwKiGRtK6SS3Ab5C9U?=
 =?us-ascii?Q?Vw5qtJMjxP5EMNZOGACbU9IaUl1UJpcgZhfK1uH2JSeTbWpSHQHuJ7IaHTlc?=
 =?us-ascii?Q?u4Xc7woI1lmYnL8bf/OxWW/HPwh276oneAoGIJbr17z9yPoTot16phpBFg+8?=
 =?us-ascii?Q?g/v1Aumbfw820m676d3I55Ed0cMX7jU1kEE98WBO/cVa4elH1bZ64nY3zsf8?=
 =?us-ascii?Q?yAShdizVambtUIUio0o/XafpxxVOp4LnWREXo65sOgv89d0QywdIApR5wokd?=
 =?us-ascii?Q?rCoL8qsN+IfRXwtAi/MxxV4SyeXXPKVwdRwa36ZSHPVBBp2DhYJ9yp2+CsMH?=
 =?us-ascii?Q?Pq2FLZzLyRTZX7MET2Omor7Pvw7gJ/NpOXsHxWkieVfX8v2ww2AWqZ0P6t4u?=
 =?us-ascii?Q?A+pSLC04lAoDhgyx95pFYFJGHP9NG9z2n8USQnF2r15q7KVlHx5yObv/lhMw?=
 =?us-ascii?Q?wMl0KLx8QhcXq/ZDiEe4Pt5aWjuqeqg68M9pMcLMHsSlQog3M1t/Zzn6+gB4?=
 =?us-ascii?Q?DU6VgMkQs/jQAy/F27BcbjnbeZ9gO6tXfl5drp1uoX9OiaIGDYa3TTKRpraw?=
 =?us-ascii?Q?5kVjxGKI6NKbC1Mp1WYKAxmE5vyuKnttjl6i/yvcH4MhDgPDmK1srBdkPho7?=
 =?us-ascii?Q?/dJKsFcGXJfDaHdhlkOKyY7e5f7go3rp6bPC3tBckAJlmYaAnSgcAgH0niyR?=
 =?us-ascii?Q?UjidK8zqcEAljUc9hdo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Q19MKVL/VHAAQUs/gZpXZBDG09wM5oyrwDZ+6leO5l77CwJYbtjDzjwxd1B?=
 =?us-ascii?Q?4zolbKQUw+niLKcxz80nHlT274Ofn+I65nC+GCFbV2AmJbAIwrRXNaq1Yc0C?=
 =?us-ascii?Q?byCKN89RovECNC4YNJQfS2JzQs1bX7Q8LXlixR93z0RfvUoNpStXYVuY9M1w?=
 =?us-ascii?Q?IedEmI9KKyCBg1B0lAJeVCPC50dZMJB694cKLZN857MymuvhqDd2CbVPpu44?=
 =?us-ascii?Q?Jh1fx3EzzEIQUFEMEwX4lQje4LUvVe+lyu8HcNuT1xJ8RjtxWgJ1/+Z9YrCU?=
 =?us-ascii?Q?4cgowuHN/l1aXWu//39h/UDA6VA9gTK2/jdf/WPMJoXo5EdJuLJSs4JTlXbB?=
 =?us-ascii?Q?4TNM1GC3lnG46AmZYBU9atm7leBgr7Pe+wZSkZAFLnpmLRV/63WLrBi81K56?=
 =?us-ascii?Q?hyqTICjhGt9W9nn/BZPFKVVGJrqbFmSjWtibxx0362jqMbgs/CYvMMLKto69?=
 =?us-ascii?Q?8wQI7nxzRgSdr7IBLp59G8tQO3rj6Y+vbVG7TUzYKERg3Tc53SOVlazy8pOp?=
 =?us-ascii?Q?Mgy7PxB6hvLoxmOE3oDn+TLKZOanXD8q9bpdOx6dEESc1QG2wmDtCubrjqHB?=
 =?us-ascii?Q?XaMS1vUw1CYjvG2Ygy4Nx4A1cQFYc2eRcdPXuKiPbg5RpKPC35xeRbZGZCiK?=
 =?us-ascii?Q?7r5QX1c1wuBlEMBaykQx3+m1b+SKHMRyZhUDEuPtrpAtUfnYsWwWPqwjubi3?=
 =?us-ascii?Q?wrxwc7BZXD38ZHq7z48hUNCSn/M0PMLXxUnXYgKE71NiMcC4h/RzQgTTDinj?=
 =?us-ascii?Q?1UTlq09IuSOn4z8itn7l9eyCVdN5P0Os3oFrVFoC0R35Lh72woSiFxbeEUWf?=
 =?us-ascii?Q?p7cW5Ut8ybNVCp9aptnVL3Scg1wPbZwAHQIuceDIi/L11d8JOvMLTWhxQZBu?=
 =?us-ascii?Q?POBScPjwI3tXD/L2pFoNpHTnwWpr+TZ3OrODJxREWWHLAmpGG3VWQWXrU1U0?=
 =?us-ascii?Q?/InlVByR37EUO/aCyZWvtmO5EDXODJO9LiNTu2JypRZuD0k6aX3URVQx1Pdb?=
 =?us-ascii?Q?7udrWJQ3hP1Q5IN4vjtx6Wyjovp/kdnWXfFCPf4pB0H0K/fSdav3/zXuHAGw?=
 =?us-ascii?Q?JpEgxTlb9cUzdLHKI6mLhMMSzOi5IzLwBYKa27tCDyqQCg6QN3tEkdMJpq7V?=
 =?us-ascii?Q?O/gvDhfWf4xp7he+vBD6/7bgon7A/CRznTemshOKEN3I2zX7yidBpMb+4afz?=
 =?us-ascii?Q?2m+89HpsY5Mvcz10/264o7spWRLdqBQgHHH8sthXEvfegQwl7LOiO70kE8LI?=
 =?us-ascii?Q?bc4u7FzZRz38M3sJbSJO9AkEERvKB5AMIX7PFxRghVkT+VwB4SLSG5uuIcG5?=
 =?us-ascii?Q?t4PBGuWmI994WVBIrB1eZG52q5gYt8+4RC6N1TckqbNF9AVWNM2CFgYmkq/i?=
 =?us-ascii?Q?AyFcpQZ9IzRH1u+Lbz63aNBrylllZF3ZlK1YM/7noc+Al+nH7AVIUYEbOVRt?=
 =?us-ascii?Q?KZUqi4psnaw1NcnsGa/ddbQwI53PpTglovWfEO3kiGkcFdZGACKbPX0Z+wP+?=
 =?us-ascii?Q?3GpOpMwIjtJDVnVg2o1dYIhBy/wBZHD5z91Dq07RCexsRjcEAFSwxKRvf/Ax?=
 =?us-ascii?Q?IrjD53zRj6ZTf/FSZBcHogpGKqFFeHozIXOeUJnHSIuNaEpKwVdGX+josgpS?=
 =?us-ascii?Q?dLi6qJp9HPfo3SdNcFMWswyFbxLeFwfA59qjlpSqVdpo3pjtfV8YKbgI2Q8g?=
 =?us-ascii?Q?+X/GoFC8wOifpkayAyYty4U7iklS+7caMuzyHgfn7b6SzaSfR8ahlu53INf9?=
 =?us-ascii?Q?ZHYZRKxeZ4XH74IHbihOKD0lAgYtYe4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fd7DQ2QF61l8y97FGE2j20KhwXuhr/G3eSSTLzMJ7mWvqilO4HbWef3LlAGycbVU7EIK22EU9j+Vutt0StBXNI2a9jxiq5plDEX0RrWCvwDee4seMRI33cH8wwbREObvogiCEq9GzKX6ktuhhM0CvqZuXGwxqPHRGvOvKJles5ZynynCvqISk0b6XH2qq7Yktr99ar5A29uO7Hg+rZlIzwRJ4Fg1/0mH7HodGrVVM3J7rU4DSUCBdGtXTdSJ/Uw3WPbcp+qwA2wHij8KRgq0XQl8ToHJg2QFKIAt8PYSlu1OuXv0/uclCTnxvJ4bqztvXpZ1EMSC8FHykREFknXR1FYto46P4W7Mj7EZNnKOg9GQfgcGWlaJO6a+1XUeF/VWh9mbrG5+ppy9eEClhahFf7ewA1t0pB+rxZ9YUlFnLTUI2sH5GK3zkPMtTnE22XnkMKlQmavax1fg+sD2d3RMyK+LDslp6qK9yAG5EbXCSczh7HvdJ0J1Hl1rw9X/Aicej7pD+fxJcdIacNHOa6TXALaSbIKs44R5Vetn0o6D33of5PPxQY1MgaMQqiQakjhW47geFL4hrAyARQi61zfIfUlY1yn2g5O9iNA7EErm0Ik=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebbf1ce-dccd-48fa-928c-08de6d6d4565
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 15:08:41.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6PVVAzktjyfiPTgBAOv0/Jp/uK3hdTt9Gi0y9hDnUwn7NBHAun7JXKtjXVoj7MGKzbWZJ8S7XNf9EwXFYOV5SQYGyXBYkCOFXyl6gwQpJM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-16_04,2026-02-16_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602160129
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE2MDEyOSBTYWx0ZWRfXy515DSj5czLx
 Fz21Qy+DXy/XegAoP8Oyd0xaHiZPvh5Nv9ciS2GLyuFEcDvSBYgTRB4s3MqG443spT1rJ0sQYu8
 kuUjYZq8UOEqi6xZ+BltrUAwxJpcBu8FmEfB7gT0kufzJwN1LRS+Fyc0V3VEqFX7Fzmzme83SS4
 RV8Bm7n4+/O5UaUQi2EpwIuX6BhSGCDILR8U9VDGH8eKo6zzxZNnNpIZyfwQduo+oaXY4d6fUcS
 h4K7hE0P/MKWhgnvctJeDcYaLtWC06sEpenkde3fUU5zYNtMBa7e2JQaBAThmf0piF4fsPuQzCr
 pbRMcf4YZzCBMZ7J3Mir6vOwmOhqBSLoOdiNKBr0wo5A6ce2HWo/iXDUyjfTT0JUd8FV6fkADBy
 nbXbFckGMpTF3IL9rH3hgL6LQzMdWB3dK1iXADSjNLNizoCjzY1ZLzuoiFtqwucFUZyzr2x4B2G
 Oe7F9IVyJ0+6g1fBavw==
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=69933301 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=_gBygh9F51wg6DkgC6UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: NYp67STpdCE7u7w1MY5Upa5etiS8dS2X
X-Proofpoint-ORIG-GUID: NYp67STpdCE7u7w1MY5Upa5etiS8dS2X
X-Rspam-User: 
X-Rspamd-Queue-Id: D9726C0017
X-Rspamd-Server: rspam07
X-Stat-Signature: r4uc9usddj9moxmow76azeeu4qjpzgjt
X-HE-Tag: 1771254543-657356
X-HE-Meta: U2FsdGVkX18RYcMgQDiNZuwDjHwUrS2+SYL4Pe2sEy9VbqA4Np/bf19cU1Ipb1l4G1o1Znqrsem6txvR1TaKK/z0uPSN2ow1Xl7pHaQXR1L/FpjXlFBuHAupinVWnt46YG8Ct44QlC9vVccDTwR9TGuAZ7Vx3wHnsGXTb6Okbu/YBdLIe73gKM9mTgXCkhZt2MdSPwyWqBfRpQW1i2miiyYCRiAU7rGjWXwC2deHm+AvUP+2j9fnLDJ+SLDIj11Ej/FraMbBAS0b8YvArixPRXGLdN4dgxdfGxxXzi7cWCx5TN2Js+lePbrkyFOeltVTu9e5EkF71vaVjaZ1XmJDR1Qs++TnmAprrAAs9ZEHh50SDBtmaZVXdpSAGR0gx7FOUqKHxQlYx2P4lkPb7nFhI9+J+aVb78Blmf2Ou9k6HMyuPzsghfsD4qLipa4jlMz829LldgUdD1/GhpYlEBJspPfTGbElWOlkb4UkNeTuvq69A2TkEnGcbap7B+lMglYmEDn2UuS6JZWrntpPETTySMslL3SfwRsUcGL/HbiBUm0floSUk0uljC1u2QagTvH3ZVsDpsfW8KbNQTWnhtCC3SmRaAA+duTuCk0koqU8QkEowwb0EPsL5szmoDbslU2AIIiuhwq3CcRICuSFliXZyynGVhwao68Kw115RNCZ4ntOzkk9ms2zNgVpcJKGdavLjfZhxZ4hlAiHwmhuWAbxM7FoJZwUd+veXW8/ttDp/OFGSF0xrOxs78L6YbJOkXLS0B7KoJR8OZfmEj7l60TOajdhMFuIcCdqMfaTmVYEFhNLd4C1SuUeFf9fLNzkysSFqFCN9DRoJw+ZjC1G/xOua+rPZaxD3a4eMTrrU548my7bDAzF7dR3Y0jhh5xzog4WwJ5MKM8H9tVEtEsbakX2shoO0JHypL0I88h85wXwb5DnmDVA5H1vuFpStXSrOheWmgK/lWlDJqyiAKS07xH
 I331A63U
 qBNtHA8WG5I9/Q6qEXqgguxIJ0qGj+AdJ8qWeevkcEgCHaHknc4NAF58N3YHxJ/whbGSK7z8yzdqlD5hlch7V6J0wdh4kCG0PLBAHLwNBx1YAdulA0lT4mUMd2dlW2s3emHkt0+zSKLtlZxZx3nmlAnXH85xijeo/NdyZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 01:17:44PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> In a few rare configurations with extra warnings eanbled, the new
> drm_pagemap_migrate_populate_ram_pfn() calls vma_alloc_folio_noprof()
> but that does not use all the arguments, leading to a harmless warning:
>
> drivers/gpu/drm/drm_pagemap.c: In function 'drm_pagemap_migrate_populate_ram_pfn':
> drivers/gpu/drm/drm_pagemap.c:701:63: error: parameter 'addr' set but not used [-Werror=unused-but-set-parameter=]
>   701 |                                                 unsigned long addr)
>       |                                                 ~~~~~~~~~~~~~~^~~~
>
> Replace the macro with an inline function so the compiler can see
> how the argument would be used, but is still able to optimize out
> the assignments.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

It'd be good if we could find a way to avoid these horrible _noprof things, but
I guess that ship's sailed for now...

Anyway, LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/gfp.h | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 6ecf6dda93e0..23240208a91f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -335,8 +335,11 @@ static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int orde
>  {
>  	return folio_alloc_noprof(gfp, order);
>  }
> -#define vma_alloc_folio_noprof(gfp, order, vma, addr)		\
> -	folio_alloc_noprof(gfp, order)
> +static inline struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order,
> +		struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return folio_alloc_noprof(gfp, order);
> +}
>  #endif
>
>  #define alloc_pages(...)			alloc_hooks(alloc_pages_noprof(__VA_ARGS__))
> --
> 2.39.5
>

Cheers, Lorenzo

