Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C0DCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A438E0018; Mon, 10 Nov 2025 04:54:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013448E0002; Mon, 10 Nov 2025 04:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D908E0018; Mon, 10 Nov 2025 04:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9E3D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:54:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C5D1140CC5
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:54:18 +0000 (UTC)
X-FDA: 84094236996.02.2D38301
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 014F9C0008
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:54:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oydbHTQP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGDmh4jw;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762768455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfGibePj8O7QTRpwz0RBLnLO32n7MD+f0y5RLmU7uzM=;
	b=qwbavrLABIc525goljeyEY3m4rgmiM8ShtC4M21zJSMI6CoPMRHNjrq62AKJJ4ga6xJm0N
	cJTmYVq9SmNhEsy1pDf4/0ch3EZTnVcL5IhE1lVBt+tU3Bl6VhWwRx4RBh9s9Qt4LUXtif
	6oGy8IA8Ru1LYiMXhTQzNs7TJ4RtdPQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oydbHTQP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGDmh4jw;
	spf=pass (imf10.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762768455; a=rsa-sha256;
	cv=pass;
	b=x9M9litjp8L8k4XE4brJ6FecB9XruOVvasDU+QIWUgoIppWOtnaL3VLv/jcmRjLzFQmSGo
	Jy730vPROgAzSH48IsvLxU02uvmJwESRkJj/6pNnI+9OjzTINBRUsqKDju453p3NFtQdh2
	/Yp0hUbEONzxBeONAHfbWiU8r7Q7n6w=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA9NbuL010590;
	Mon, 10 Nov 2025 09:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=IfGibePj8O7QTRpwz0
	RBLnLO32n7MD+f0y5RLmU7uzM=; b=oydbHTQPEWdUGheiRr+yjW3ej61K+GjuXK
	npF/ptnke9QQNV5JZzE5FBYR0jE/6hFniA2GaGOYYyy71q7XBFegFCWBbHupNBmb
	pP8c/Mbh3uPoT+8cI2nbQWwM2sT0NtVfWGilvG2Hrq3L7ssb7OatYtcoP8CLwLbI
	CpWrpzS7n2yN/2/mitJeBNLchKx2VkvDAOXbbcb+JotiloZe7P3GYvIeM+2Ogwwa
	Ajl4Gci7R/I8pu/MIfUYt8yC1q1hNDr5rHQHlhpH0t9q2Tq2ZGGIlTVvEPNEO85A
	CPjLiRCJHWCNRtpxAqETdZ18/I1p+iPILX5b4hleran3Pa+7subw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abbss09gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 09:54:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AA7eVhq007388;
	Mon, 10 Nov 2025 09:54:07 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8eshm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 09:54:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mmFa4y4jJ/UjzH6Rpb1ooF35gwm0041+DpWGqfpetNcLMoR0ajKo+Ikfgj7GMzqa1sXH1Ylvo6dkjAaINcffKgh/mlVDjjKQgzDt+KKJUBXt5O2WcVH91l87vyVxyFI3hc0aJ3FM/NW1gqFGiJJZ6nkMTfzNdEVpj6MoauiOWTaGCLyG2S6Oxan8LzUSO1KfrRUDxdqWFUwJoM5hSFUJP8HuPOCdYmTIoF5FTtbapAGGsMNqSQ7lM6oOBDCxO0EK1zUHY2BOnJfTcnrxrSx7l/resGZWi/zphQE2DjwG0thV4xu/DTXGcTRatK+USvHmu3iTk4hgUhnMu170L0WSOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfGibePj8O7QTRpwz0RBLnLO32n7MD+f0y5RLmU7uzM=;
 b=cypoiJQ2tFiSKhgVAjQg8DLbw01V0GyNd7CJ1LKBZGfgX95nzN+FQqWiqrrXzkglK7A5gGyV3DurPuHMThgfqj88JO/Me+gSc78IYQ8LfGK8q1tQCG6dbzTXVFF34Tm3cfjxtgW8obWI/MOxmmli8UZhUofn3sWviIBh29kNP73PJ6DmphLxQ30VDg5OLZlsXUEpZUVdXI/MRM0Q7J8theJZ1xST2Bearjv/okc17flcbURUruXqtp14rZopVoKnKLzrYGn4FSlMZA0Uldx5xI/0EVGm/QVBbe7+fIj+A9Y/HgGIFYsZ4VXL7HxsB7vo3YMD7Os6uk7kFdCHkIz31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfGibePj8O7QTRpwz0RBLnLO32n7MD+f0y5RLmU7uzM=;
 b=eGDmh4jwnntPTLib+BYP30zEvqzGEBokSfrRFbEY7s/v5rL7yskOYPMZk9oH6tXPl3Cd8i7gHqf2oB3OugkSLHavRee37lq374q9l4p81+MqWJ1tfey+HuBCDf8yVIPEjJqgG+6adS6Bf97kc4iylH6S4Ip5omw5s6Pf/ySvgRE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB6903.namprd10.prod.outlook.com (2603:10b6:610:151::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 09:53:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 09:53:54 +0000
Date: Mon, 10 Nov 2025 18:53:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH 3/5] slab: handle pfmemalloc slabs properly with sheaves
Message-ID: <aRG2K8YCqCZa2Yfx@hyeyoo>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
 <20251105-sheaves-cleanups-v1-3-b8218e1ac7ef@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105-sheaves-cleanups-v1-3-b8218e1ac7ef@suse.cz>
X-ClientProxiedBy: SE2P216CA0036.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: b265e0b0-ad35-413f-1fc6-08de203f0ec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ecfb9c3SQGSsVXENOeU7fk/wzFGX7UKlebO9d0wo/bCigB8kb1PluWoSKOHG?=
 =?us-ascii?Q?DnKB5M91CHNnFBPyYH7oWTlgnU+ZabVsIAfZYGDT9EvVUU+OL0VhFI+FMrwy?=
 =?us-ascii?Q?PPdEVIk00G8qfVkI2sQLX8Ug7fH6ztli2XQMnjmxszsbNuYl+TIM6/3ERyds?=
 =?us-ascii?Q?c/bEvTuhq3kDfKSyflMBCfqFSTzVb4zyuFo7wLQ3Bcsro9ubKyFtnhalnhQm?=
 =?us-ascii?Q?68gxHxRF8yq0oUPxbYmlazX8UNwBzbG3Ev4D+J9HDs4p/OJOABEXfxX4vKxk?=
 =?us-ascii?Q?2mrY30VcIORxKQ5eeP1Q3geNiYYeCoV4T3ZJ7s4zikdzuzmsB87O+IWR0DE8?=
 =?us-ascii?Q?+XXIKoWS0iZGNJxUXqohQUOY52hUnSNMZgBRpznW8kiLsG3sPaGhGSKg2vmD?=
 =?us-ascii?Q?1v9tBcQ0xF7LFxgLuJ8nXY8i/joyH58+wCx8QIpn4ZyCwrdYV8Pawmx8OGYP?=
 =?us-ascii?Q?z52DLOpJ6xirHt1wY/8Ugdc/grPG4+FXa1rf2DqyttAE2HdbuNrDmtakf9Jz?=
 =?us-ascii?Q?BrubDseHaUCzCMQbyzE9hMz8BKi4+ctmnnsY3B5FVm7gwaHGMhfRc/5NWbqS?=
 =?us-ascii?Q?ZtLxNt8qbDpMdybQu0FVjPxBZw6Kx3d//3uYyNp/geos53owOQvThZGPYdv6?=
 =?us-ascii?Q?amPFBD/WMO6NIwCIeqJq1C70RHSfDLXfvM7U3KF+v4cSEmeiqlv/0EJYAs0E?=
 =?us-ascii?Q?28TBfIa072WQ46FgpHPRGn0H+09HB1XJYdX+EAR0ThwJcP6r2I+X7nLe44zN?=
 =?us-ascii?Q?3JOYPAlXGN9cGJMON3RXc17Z83bc1kKhTT837uzwpTauXyKx6C/kAjVTz3z3?=
 =?us-ascii?Q?EULiDgmpZ1jKj98dF/PoF0kuSYzIDJTp0kSYMxPze/I23F/Hwywjn2B9Huo+?=
 =?us-ascii?Q?cmm9DTzS+dPLE0EZ8ql83iBrjAsCYCnWldKjGxaG7+UyHyTne8dHcycAibum?=
 =?us-ascii?Q?g2s5DmoSOYKuvnJaDFw9MKEalpQNinRVnAPP94oIysWQL/oaZMRAxpF4ePsy?=
 =?us-ascii?Q?J61H2zN1JvddpBhl/QTDme8C3DGFj/jyzru4YTiME11dH7tQEjtICLp6AYCj?=
 =?us-ascii?Q?WfUx87gqIH2m2/MWEMYswqmAtrv8aEvAlYxEisF+hRmnsf5zDnCvF9IJh8td?=
 =?us-ascii?Q?C/o3D/gnq1PjqSwJetF7J9nNQEyj5piAi+fom1HID9Kkwb9tdHR1jSAw1okr?=
 =?us-ascii?Q?dpkWzI0skaBs15a2nDvweu1xnWuIl5STWskW/NL0lj1oMJSIJTxvsxcnYd+C?=
 =?us-ascii?Q?Gpyaf2cXd9/DjvHMtor4DVVNJJJZ/viiSO75B0T8tqiJUlSkDWwjIdRoc72z?=
 =?us-ascii?Q?uo6csHGPHXPa0EKXNsTu9/jryqyetQoTmnUzLNZeY9uvtV08dKhNxypD97g+?=
 =?us-ascii?Q?0AoaQ/t0tHf1bVWP0dblkRaFKCkPNuuracHKsRabjCNO51O3QZPOJHCSE3g3?=
 =?us-ascii?Q?tDv3Z1zJNOwujAMOHOk7oo8NsoLa/eDO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QJgi0468xbEVaUw9gyAjOsr2Zh8ZcbN5aQPmTfp+G5Rwf+G/VUnxQEowr5XU?=
 =?us-ascii?Q?HElPVeaA2Cf4hB96spGirs5GZOJ/0dlJJuRPAmKwPtwgyM7Q+08B40rF6sg0?=
 =?us-ascii?Q?FzhGX3JK9YELSlEIT7IxseClXvFr8nzYf+aXwSeOzD4+YDY0M9kBsV0AGaY/?=
 =?us-ascii?Q?F0ZpQqmX2zHTgGS5lSmviHljmBghIT1PEezLgfIjAK4ItHvWIOTdQjGDFTvE?=
 =?us-ascii?Q?PhtifQYvoT22XAMV776ZFokHck7nt1xi1mlf5mllxc9Cjo6kK1zWueybrJBp?=
 =?us-ascii?Q?y5/3mHogthZC/DDIBh66Li9ADr9wV5ev1ngRsfIx3rdxWlHtnexicslP44c2?=
 =?us-ascii?Q?VE81GInmXjOsj5vyAMa7fogqhp+NEoZW9A+7DRQUx1KItRoVuemWVMwaHlDQ?=
 =?us-ascii?Q?f78dP1vcH/quXhEkHAv2FQ9kugFeuPAzVPhFZnEenuwM8yfXddV8qsf6qqHp?=
 =?us-ascii?Q?tjwTnN63c47N7Z26fQhyOR18xmTcrQAiRqMRt5NofXItJgTK3ma8ODG46RIw?=
 =?us-ascii?Q?fTbsBxQZaOHikpfvwyZoeVcyvZYkkg7f9vvoMxuaa8Fx3OBTQB2hhCAKhm9/?=
 =?us-ascii?Q?hCYpZ2QVwra/SeGquuuVvjCNc0GcEmPq7K22lklR6glVz8rNWg1/JKu6shBL?=
 =?us-ascii?Q?CtXWSP2oNb9glcObP62Io7LLNIheH9LbT4LM8S0DDTqRa61mQy9rna5q0KSw?=
 =?us-ascii?Q?CTlxGvtU5W3ze3Rc8zRcnkq+GZvh5AlmjtffQZ5UXqnQOr+5no01vE9W928F?=
 =?us-ascii?Q?70WOjsgNmQLWshAdF+yYeXzwPnTSch1eiPNx/TrHZzSUd0YwT9c5rlraF3lr?=
 =?us-ascii?Q?BykvDcu36Os+CI6V09fzx7av97kQ419txKFL92n5Xda0BIVE71iduwFFHMbV?=
 =?us-ascii?Q?GA1fmbB4TDHs8hqZG4OfEIGGtqgaXeeQEmSFCYElZ3O7SObPJq5cvxzFMfPN?=
 =?us-ascii?Q?54wTPHvsVx/LBTr/+Fhimdl+v/xPGxsfXXdS2yLqG/I4dZF7+tS13lxm4iw1?=
 =?us-ascii?Q?pHp+xCuiTteIsU4YAKfS2m/5FUtqTGCn94HC1Da55+oXwJY3MomBUsHCkMQP?=
 =?us-ascii?Q?71ejIDGZqsZS5gJP3WDnMQfYl5UDfr8vXjabmvOr6c4+1S9dQUZ/SGMRJrud?=
 =?us-ascii?Q?WB0taRtPyRG/vZ9v9Z/L5PFeejbXrA335yn0RbrUyKQaQY3sX8AcVEPzv1v4?=
 =?us-ascii?Q?TwOnsCrpjmQyWbSvDfnCv+0RKd53G08v6eUsJdVp6wCaBLG0VDz+q2SeAn+R?=
 =?us-ascii?Q?x6O0PaEYw8WC/9UwxZGCtAftMuozYt4ybZcnnXqcyisqICjQUFGhfoAzElVd?=
 =?us-ascii?Q?NVbjNklu9UbyK/BWOFqVzIBoZCpPeRUskdRj6GrDDht6yP0TJrIEZ+ztVRjA?=
 =?us-ascii?Q?2zDm9muFC7P+f6qJycBeVIY/QltRe68u+TcOAMaCHRS6mrM7NcrPsN2yTvzy?=
 =?us-ascii?Q?smc3MuMTqMU7jiTtzbGQ7XSDmn4NNQGtBeQNO9L2uVpJ34GmFF68hr1r4CXJ?=
 =?us-ascii?Q?9W0ysp7LHfUUZ/4zucR2IU8fmkWL5FS/jOeDN42sgNg6Bm1WBFubYJuAIWdM?=
 =?us-ascii?Q?csDot+XCK8PydcGJlfQ3KDj1GmO5lW7YJWu2+1tt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f8vZ/ZFLd+qI+S5W+c8UVxXT69foYD2JC5yHcf5mBdVMRrnsSzQRBKYPf6ZMWqH4ixGY1RfbuYNEUPxQBUhG4igRBIoM/SKQDVed6U0f/scF1jPn99AidKdNVVkHuLy5E/0nyQUxRa5G4IXbr5CmzXWAfNvJkOyzZ/XgIajDNyC78QDs1HyJI7sBNHMcvmSGeuXEMT0umDrKJGuvFvUstyapwweR4keadZvIOcjvaOCzjEyqOqzDbhm/Dq6cW2+gplGPU+jfq6b6GHrPSkbuwaY2jN+AdbqPLb84Br65H1HxMNLiHoDwAElfTuRAZvpb6eeGLv1QYnVsT/+T4NUmjeyZJiXXCti0fdMeLZPDAUS4F1E5SNOI2KsT/CUwF+gBqVUyAHAliV36GpH4/C13S3lXKsnFI6qW9TvchjSSqMlaROcUGy0v8V6pX2UiHMrNHBJssClYE6YgZ3se2n4cW3QSloUTA2isy3nk0/ASTev+cU01psgq/7IbOYkFW04MWVPPEMgKVdAGxUgNoemza+qBScyXvSUmCOWNojHR6c4cYGyOC0i6ZFIuzCzn4M+CmUGV0IVwmv67V1cgdoW/it+VxE2gdZjIuwYPblTW+og=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b265e0b0-ad35-413f-1fc6-08de203f0ec9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 09:53:54.1554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vwopuvu71u01svUlGSoD1Dx6oNBUTIieLlHsKPp6zOrP7R1OMHV/+E6gjD0qZ9pnUZu5x/iKk9hfa1VxiYk9lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6903
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=924 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100086
X-Proofpoint-ORIG-GUID: avIVK6MeXggzdI4ey0PDGhG7gOfsgRgK
X-Proofpoint-GUID: avIVK6MeXggzdI4ey0PDGhG7gOfsgRgK
X-Authority-Analysis: v=2.4 cv=f+tFxeyM c=1 sm=1 tr=0 ts=6911b640 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=HqxLjavZxCgagS_tWHYA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDA2NSBTYWx0ZWRfX2tB7iniY8jMw
 zinHLodhV9OyNhQlKrlHX2PfKsmS0Kqk9xRUIN13cO1ixaXx5wuA3xriN1EvJamCcLpwjSrA97v
 12iDoMgAwwNeFDIzi9oscOJbaB9jiExYrEDCEjeDBEhjgLyWVshA1Z4KiXoGGlnztIemf5vg6X9
 ikD1wlzP9JAu146CgH6bHv73wDSNEW0E6fToy10nR+yijZYsDR4hsQaDHtoaOVQewDXIsaeRDuS
 RqtZ5HM1MObIRXyMetAQE/exirWvSP+3TJaYaM7/d2/rwWd9I02x7aoJANRcUn+7aStgKcydJJM
 AaMjlTRwdHPcJjXcm8F7ZzlP/t/BTHByfxQoVuB+VfKQtOzSC1BEs9WOyHCP9n3er96X8ZdVdK/
 Bhix79bwnm2ZKkZ2b7lvPWbpunUVDQ==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 014F9C0008
X-Stat-Signature: ep41ue3u4zcpbgk8aq8gr717wg8gzi7y
X-Rspam-User: 
X-HE-Tag: 1762768454-76920
X-HE-Meta: U2FsdGVkX1/gt5G8P1zPs7OAMz07awcMHeG+Z+SZ4NDK1QndrQ5gkH1iL1EdgIdZ5x7sCElebBp1RaQyTbV2xLGUBJAsOvDlSnqzDLqnWNOGoSsUs6ntfwEsSqW+KX0mTc2v+XU7jrQhXDPInO15phsCd9FkhWk/OcYatas8cVdEgM6RBdnD1P5uBwg5tltJYthYmj+snlwBdgoNdslqwU+6qAphDYmpEBWV/U+OD6d9h089FuA5DzZhvCcbXR8tlXSAZfRk6Jn1Fkj+ddFBlS3EcjM0p6iv4knlbPJpXQjmG8QoKk8c1BENF9fqU2SsG9z82UxHW3a8IctufmHQxXmB2IcdgfRGWI/wYFSvjqfB2wOZ1F9KlL3Rme/KsUWE4L/AQHRyl7dFPnh4A4hwJ8Pglrhaa3p+PgLS41wE4qO4ryK99t8B8KMjDWsqUuydecKoKnbk4oG2WrQNmb/Recsn7bvFZDx2Oqx9kS6NsI5Ukz5STPbhh15KbGZgA+dWmM6AgPO2gwTLUGLRXPguYC8M0R2uUbpdpBm99jmL0OxxuU+gx4sIzBktNtj4OlKIQPSRBngqANHgb0zQ/Lny3nfp8knGeVATGGXXf6flE/SGFpGdgb45YjRPyylp/RVXiYepdZo9IQv8xaGSJGKlnp/fRKy4ABzpJGhhSEwkZURq3qGLT+qFgeA2cWygNaZ0E2wlp8Fit1ceZEp43W65MidxGj9jQCBoaFr5CXqfKI0V75sTUJZiqrF7lRpnPCaIfD9JzNsWW/KS/SxrL1P6JGx3ry1kV63zOAW3W4GGVMh+/ZpsSaSo41Vz1jOyXtcu1aJcZqX3ddgkYJir8EqtwjxpFmKbCYp+zZoPFA9LtJEizNWDpcGVBI47x5QtQadvbCMyNQwqa8v0UVN704/VxzyGEWS5wzM/gYWxafq5gnmBNe8DJGybQ4lW0+TPbdhn8GX3syrYVofks/lkNnc
 Ria4NC5d
 Fgw6FnVlha2bb548CQggsgO1VyfGjwRLlPikwQ0aedvPY0aWjQD6QmtDrVODtp7ijxuifMibHAKMWMeHuSPhbP63w0+zVAONrjIp+i70CMAxiUmLHB8OSuyyUcICjw5NgZD0XBZ4GhBeO3Ci6vOGpPewKGlBT+TjZ7aoCKxvGJCE6RZDG60L7EcfU4JuSAmskF7MphN+Ld4N5BXiy956722f0J029/X6V+plwxz6nLIeGTrKiNUCuHHFF5xW9IWtUe7YM01I4xKu+uaVK8nNGjBJhs2OJM7OZNNVqwpD73tEvRmcapQGqT4zPCLD1Q9s8KS4FdIfR4eSbaleY1Nd1iDMOAppALVNgwAgvs0xqWyUAX7YwivIDRDdVYCK4rtu5HPhkWaONWALU3uijGkjagqmg4RzJaiFF2/SOgUNq2Xw850iYrQxajpBn1fyBFrcm6EUeWAjbN5NOo4HDq7G2fbKGKMmS9CTmzhG3fX419JoEwoPZU45cLhCn/5SIX4AMUcWge4lYT9hOkE2FdAGkDUFr5PkYiUTCua2bSzQW9t1UzC9r0GDe/l4P5QaMK4breEIyALkPKAvx/WSojJz3XyXIjzUqy2SwHNeZWzCAlhN1zf+EqUITY/DOsXWlpioOv28E2UOB2tOJDuWVoxw+Elmr3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 05, 2025 at 10:05:31AM +0100, Vlastimil Babka wrote:
> When a pfmemalloc allocation actually dips into reserves, the slab is
> marked accordingly and non-pfmemalloc allocations should not be allowed
> to allocate from it. The sheaves percpu caching currently doesn't follow
> this rule, so implement it before we expand sheaves usage to all caches.
> 
> Make sure objects from pfmemalloc slabs don't end up in percpu sheaves.
> When freeing, skip sheaves when freeing an object from pfmemalloc slab.
> When refilling sheaves, use __GFP_NOMEMALLOC to override any pfmemalloc
> context - the allocation will fallback to regular slab allocations when
> sheaves are depleted and can't be refilled because of the override.
> 
> For kfree_rcu(), detect pfmemalloc slabs after processing the rcu_sheaf
> after the grace period in __rcu_free_sheaf_prepare() and simply flush
> it if any object is from pfmemalloc slabs.
>
> For prefilled sheaves, try to refill them first with __GFP_NOMEMALLOC
> and if it fails, retry without __GFP_NOMEMALLOC but then mark the sheaf
> pfmemalloc, which makes it flushed back to slabs when returned.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

