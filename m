Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4281DCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 17:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E2D8E001D; Tue,  9 Sep 2025 13:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BD058E000E; Tue,  9 Sep 2025 13:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636B38E001D; Tue,  9 Sep 2025 13:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 499368E000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:19:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC06C5A0DD
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:19:53 +0000 (UTC)
X-FDA: 83870374266.08.8A8D64B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53ACA20005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 17:19:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kdmhRkqj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DFF2XMGn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757438390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmEF3AAugWLpRDELmxKLvmT6YUk+24c+iJRAuDaBIbQ=;
	b=vARQnD3KhpsdNaDkte9bMGZdLC1SnpXHFGr93YnEaJKoysPFPpmcSxnQSQNfZBDw7maBSW
	JYQVm0z6eYJjTAEVcPvCrZfvjyCEcTzweGoKYKB8MzhSS46ZGUsLg1kHxDztdEBZQwLIBX
	YDAulv1x2zOjtSNA2KLDJeuiPgPMT9Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757438390; a=rsa-sha256;
	cv=pass;
	b=3U6E7xDCHw4UtSjP6GqI+ZTQvdw+lpkuRQwHdX0o0vXUbVh012i6Z+L49x9gIPYX1OHndY
	2MkrEdEamCo2vTqdH7wslpeg9wSGHZ1wNJ1rdfLA1qI8civ7Nsuil+bEwkUtro7TDQQLJo
	Utw6PwpDE1MwXOV6TnOuOQktSyuyUoU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kdmhRkqj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=DFF2XMGn;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtjPl014532;
	Tue, 9 Sep 2025 17:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=HmEF3AAugWLpRDELmx
	KLvmT6YUk+24c+iJRAuDaBIbQ=; b=kdmhRkqjRhBMujg6njbBMXRr7IelFVrA/g
	/mDsi2teuStBaQ7xsGo+PWq/6y+UGW6H4nhIioOLll2hqTxbhoLp+yvtaWumfQXf
	NEmIK3sk2luq2w2lFZB8LagH4LG7O6qnSLgMM1ph+flh1bIT/t/SyfHa3X6iSDZS
	GI65KeO2PKotwCCELtygX8vd4VJqK4oD/Sws5sCWl38HMustpYKdHaeTiYZPtaJW
	7ppCPIzEQpfzeeRuusigGFZMytNMFbsG+Cz6ovwoqUZPZYAkaYAHC2jXhpvyw6X8
	tSTdFKGrzVvZ1ZQTSScx3BuKPPmS+2hAG2EGfNKeEUBgJ6laP1cg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921d1jmcx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 17:19:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589HAIQA002897;
	Tue, 9 Sep 2025 17:19:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdge8uj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 17:19:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jVMv3T2a4nKid36v69YciPnmIFXk/aJN7kgKOiz7rNJ3Go093+Z6kN63QKqPWiL3nJxPie3Jy7kAwNLINrJGKFBWisSDzO3LMqNP2zNUJ0ySwQsJGfiGPA8uICyT29VXen7zk9HzUk1JijHvuS8atbvxnsT2be/STFUOS8u39UeamkaD465uYon3lYMVYn93b7dvXrOiin/bwNar2OY8Lb5Kb7odMGls0557sxVWGxfmgFW1s9F0nLvoQTMCEuDHKhRxSVyWzYIUKYV57E+KL+aJqlTNlihrvTJaaf3BxcgULXegVt+ISYqTEl7ngiS32qcxUDpEQnnGwSC+maxVLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HmEF3AAugWLpRDELmxKLvmT6YUk+24c+iJRAuDaBIbQ=;
 b=vSKFUtAyxEYqcY2e5HiXqUYl2uFGKIb3s/oeStlJFEIlqwnH8n0nTuw3ay1viuWIBpTkK6gzgsXGSok+vmipXH0mQls7sECNeRkSvKVBuiYHEqXg5zZ2UvlWj5ENaqsy9inSI3qQ7mSUOfTlDyL2iRhb3BEX1J9RVFEt7Hvo5eayo7unlIG73bZ3puI6Wf8JBwq/ozQq/K6dmd7K3f2olukEa2V+QVSjiaI3F4cn71eL/64PB+m0lLpq2d9lrAB2YqqoIVuHAzG6xulPMWEw7xBHnwfn4GMoW3/1EDOi1EgaMfsj38TkOEJHuzFVgK7NbVNSNRweNZzvPDq2OrPkEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HmEF3AAugWLpRDELmxKLvmT6YUk+24c+iJRAuDaBIbQ=;
 b=DFF2XMGn//bLeUEx5zZjSaP2oygIta1ym7jnafxtPGstlPBstvnep4d+u0yXO+pS1ifS8f9yfLbuZKCBDZYsQF9LXAjusppmfVeCL7N7JfJ0zuU7SrwN21BiJ6Qffcd2JFUm/w+LGoipcibLOnu/Q7HpbkeHHQmJVAW0AL6lpf4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 17:19:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 17:19:29 +0000
Date: Tue, 9 Sep 2025 13:19:24 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <gtt62i4wiflnhetv2w4kanbs64z2bdmxhth3hqdz5bcflfamkk@ojhlmqy4r3po>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
 <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
 <a3777992-21fc-4e55-9a5e-72b17dc86135@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3777992-21fc-4e55-9a5e-72b17dc86135@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0457.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: 546e1561-119e-40ac-2a81-08ddefc5088b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Au7TA6nA+r7xbVPid9nWHb/X2bAsFL2blIqK+ywiJP1Ocn0J86FCA2dvlpQv?=
 =?us-ascii?Q?a1wZCSjQby6/ErGKBq1V7wixUaOEOG3jy4i+aAstpXJAU3ZecTXHk+oAimUB?=
 =?us-ascii?Q?H9UzBrEmNeojZYPLC4B+3GJtGmSufc+gL1LbIpXKg24VT2HoF3VlkGTgCyMT?=
 =?us-ascii?Q?WC06UMpPvwhOtr4ZR4o2nHNVo5q+CHLQ3dl7Jfyes0tYzxH159Se93wUfphK?=
 =?us-ascii?Q?kaGAvXty1udOiopQJqR9/Nu9oWACoVCUX5XzYcbNSmzPGop1xwIeWpGto6IW?=
 =?us-ascii?Q?g2tUhja8KKB/G3AZ9f+Ea9Fv9wVrkQW1IP4zilepYFqOunyn+5OGnz3krxHg?=
 =?us-ascii?Q?u0LJs3RzC9wTcBp4w2oD6q9uPcuKma4NklyWBMYkaYdFSC9BMsowVRJ3m/Lp?=
 =?us-ascii?Q?YllCrGhecgT+IbfhxDFw/q0pJqEwL1E6Hoa6PNFfj1uIMn8/nT2YBCaWfd1x?=
 =?us-ascii?Q?YKFqDfrEDClDr3y88Z8YlkJOcROY46zjBp3/qwsfNEQ+yKEN0pdO7dC+TM8w?=
 =?us-ascii?Q?aC4oBZ738xddx1LYbszged0QqgGd4jypxtOy6ud4WAQwiqkFdQTCwDXPDKPn?=
 =?us-ascii?Q?HFRdKR/iSSWjQJzQfjQtDGIROL5eycXiMBPn0AtrcDIfqF7QetSSSMolNtwS?=
 =?us-ascii?Q?4Fwl1/jydfHjYalMkzwP/XRQWICn+SjOjlIy4e58kzhZQT2cvml7/zU6+rC1?=
 =?us-ascii?Q?XeHr1re2VWCe5v89xU03tQSNEnBgNH1J41wKtHt96A+BWT38BTjebtSEXINO?=
 =?us-ascii?Q?gZgo8YWc/Dh4D/uj2DW/JVKrYlBBZJjyivtRvP0ce/JAoRIcrRGjX6qxrYY9?=
 =?us-ascii?Q?srRHTYKvhHOEtjP11FPhNwmwRurkq6xj06uvo3o+aWqISDcq0wrxkbqb9DM+?=
 =?us-ascii?Q?vOxzE7zTuQP4Dw8aQDUkqDPl4SEepQ0i2dte3LrR8a635dJcMMQcUrEvJ+uK?=
 =?us-ascii?Q?ce06kRHIABEkHo/U2Mp+9dOCuYfeVWZe4mZlG5UHFZYp3lhmUQNma4XMf0lI?=
 =?us-ascii?Q?/XLpywrGvO2ZkuAgDE9ADdglqd8tR/QmyOyRhtPztHKajPIPJSAu7h1gx7Xu?=
 =?us-ascii?Q?3Bo1uTeXo6lqdeLwpDviLwhVSZFkgi29m4lHgg31/IMn5VOuIsUAS1As6WCd?=
 =?us-ascii?Q?AlWYeHuszAFcN9khCZ107A/qVJka7snBZHX8ELIXaQh9QJJw6g3onZxc1Qp2?=
 =?us-ascii?Q?WfvTi7H9eX3LhMHmS+ea1PEp6NQ1AOG6VSzgVLW/HmBHA+Q1yOvN401bMd9p?=
 =?us-ascii?Q?ykcI47CoiTzpH/K2FRSnE1+mMiNL/ugFjB9BYzfNCxtxiACpdgM7qhouyahJ?=
 =?us-ascii?Q?CTxo4zLBGgjsclVahvzYjEUpJa1tf3MTY31FAe0wKWfBnqUha4fFbH1VtSpz?=
 =?us-ascii?Q?5F2gDzZ6oblp1H8rxy7/eRpVZsaz6PKS17jX0ngJJUavK39FpDUuRfMWSWhu?=
 =?us-ascii?Q?9xPrI5U4RHY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?olRV9P8HMGUD/e1NGkc5BLGjhOVcflpR3f2KqieTudgv1DiptfyEqqrNYrkC?=
 =?us-ascii?Q?j1rLQ7iFGk5MqecHJx3dgzY3FqshssomsbX+97spFAJlpkK8K0ZVUGnWsa+y?=
 =?us-ascii?Q?o2gFsVvdJDxBgfKrserIZjFMrKQWPBQHNOizKhug14xrdsogLenWV7ECAo4Y?=
 =?us-ascii?Q?OPLAYeNiruAvf/+iP9JVcDe2tdztUn1a8CZagWNnfwIVPMeloJD43ZJ28SRU?=
 =?us-ascii?Q?wJAXTk+6CrUbh70l+yf5EGWMBWvhWhKIpV6ryyes1i5yuZOXjbawiEZqFDYB?=
 =?us-ascii?Q?b7qwjZIRlJI/XBUXpmJFZthVHAQSLbRBVxklZd5hNhzecm3vTe8S60O6FTYM?=
 =?us-ascii?Q?sbWRn5XOMu11C2kJ8yK/26FQC3/NCSXGYLswJqX18TQSLdQ9CXSn35jNQIEu?=
 =?us-ascii?Q?b//Bp9AftyTWkqlQJ2NuTIY/WEXl8PgoSa5MBuHYemmAgTLSJYTCHbBYJZQP?=
 =?us-ascii?Q?Ow19IX46wY2LEzR3QltmkBj3t1OTZMHWKHt9kM1EQEYrgokEYRLwOvj3447e?=
 =?us-ascii?Q?dI+O65iWcZWWuO69Nf10Lg5cFdf43PlJ8YWw10jknh8hXmVw/AjBxGjh/NkG?=
 =?us-ascii?Q?ETqYAxsZQp4O7Jjrp9ewDjzvx3WiYnJDTRSI4Cn0V/HhJOpP3tHBosQ1vf8P?=
 =?us-ascii?Q?KRPIBn7EXTfKndkhQ2zNOkg/Go4G/rOuxNF5VlIe5yEex1Gttnl62HhdOeSD?=
 =?us-ascii?Q?fCAnRvx1Ax/pvEMeY0X/Q71xcjtzdjE9xtu34FT196vZJar7IJ3N9Qxn16do?=
 =?us-ascii?Q?CrfuLnUX5aZ5fLRTVgAMDJfjSLdj9/eEOq9fLz3eUTQS890V3EpwGTjBJchz?=
 =?us-ascii?Q?MfVcs5A5pXfux3gpK/ZdA4Kwv1sZnbihsR7b6DBaLFjtfrJC9TWuom9UKpio?=
 =?us-ascii?Q?USVf1NefRp9d8+gJH1fn028x2mr+8P6uUNK2mDceeMuWEe6mi1RVzaT2KrJ2?=
 =?us-ascii?Q?WP53q8ZimfIZod5K4NOz8TUfnHQpmFYbH10VyDym1GKuHvVHytoR7QP3RKK/?=
 =?us-ascii?Q?6Dp7mVZed7LTEvDWzGalY2fcS67i38nWGLhTB6jMj23lA7W7kMFKbKPzTij8?=
 =?us-ascii?Q?hxJ8JdJmm3lWXylvENk5hNZj65f9xf4PamqpHpp4Cf1joRTb4eHtXVow+HRZ?=
 =?us-ascii?Q?E6HxrGzgopn3GPhWnBaE1EmlkgkAE1lEdhPkY1QGZGCKYTQZeng2p3GRkPFw?=
 =?us-ascii?Q?JTn7Pd14Qv+T3KJQnKpPAS/IjCe4+4xBobNDrFkIklOOn6kS4Ux03BY3nJkZ?=
 =?us-ascii?Q?0Wr6RVgeouU7Ggc6a9grbz+vLQfhNrINV/i8UchWe8YO5uJE+4+yy+8oBlcd?=
 =?us-ascii?Q?M1CiBeOLBdJXx/udBs/lgFwj5wSJA7lGcE4QmWzCp/1IG9I6dRgVGod+Pdr7?=
 =?us-ascii?Q?EtbLc4e0wuyKfCj4J4bF7wkl5pNly4LGtedz3V+JADaS7zWS7Q+SRT0Zb9f4?=
 =?us-ascii?Q?6EkTb4II/SXu/xUGw9NO1XdEQE4BOCnjisqVfPved6BdREenRn/DgPZWj+ig?=
 =?us-ascii?Q?rH+KOaQUVizSDee8aynCg3KjtNSXCtRZeslkQP9WoYcX+zJZSlJOx+t0HuBB?=
 =?us-ascii?Q?0HKaTYujSdZsTH61MDntVshKOEzvvMKSy8ZBQ0T+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DKmH5MspoYvts9XcjLPKaa5wTgE3cWyVvAEGakAlaV+6IWaXXsM65dHjlemkIXbQcSjlWFq1d4w24x/f7S5eO1nQUs0TBQVc3Zl8JVXxZPjKZx+tzhu3+VRKDTCumv2WUS2/ovSwzb2l+ltVCWewYVOUbTksfGMxCrdL3Wf166Zwx/3dJ0IBDmj0rl5r7B66t9uwgWugg+/iL6Cxh+SL/JnxqSudotXlGvx7oQEtsdGV6VoLEdcxiiebyqmr7Tz2E2e8ATtbcda72KJIX6iYMWF/Hr7f4vtyoQv0oSH1VwzrFULynyg8GJR69uoTZ4w2smV4Z3f4lQ+1GmC6suFSqp1RihEylLjcBhxagkrUy5CkbCkxEkhEAOIYvvNXG/t5M/3E/Hm5Xqkr8fYEJoc6wGZUx0UA+9NPsrJPTcgNtgKD8QuT6VcY3ZX9o0oxM3F2obN5iN4DES4KDvw44eCDuRJEVgso+AyfT1Y6Kumysgtw92nWM+WQV2LuE2yhd70J9u7P+JZR6w22z28RL5pk209E5vQah17Dgo2frIhbnMaU7kdVfXptoN+0zpUzrcZY03h9OP/M8c12V1DvcqbBfLPy6XJAMh03YwWN5XgES4E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546e1561-119e-40ac-2a81-08ddefc5088b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 17:19:28.9784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o6CekUL1UEx2JeCwqMicqt6e9VKUwAvYKPjlWxd8md6OKomiDafQyz+VkTM29jRwfR7LEFExpBzHjcZuOg51Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090170
X-Proofpoint-ORIG-GUID: gSJthS6ESpf8vl58tREtSg33-llMCYHq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MCBTYWx0ZWRfX83NAvbIWWSAK
 2WcRG4p7rsb7DkNqaeDS36SL8xeeMnLcYe4YskQUv0MFKYIjT4Kfq3gY2K/kvHy9M/Nl1QyMUDq
 zcvnVkPhuHueH0+xcRgkHo5yEjfnSavezxRu5J1sQ8I1F5Tx+OH9Kb2T9s9F2J/fQiHlmrkwWJA
 N72pizYClLLMOzZXYaFCmIjIRp2x5/MgciO91FNDWdxSaSvFPrwBmDZpFetDL3S4UCCDtWe8QJC
 dtVMDUYwchXxbUKRLinAkNxxXdGqVxc/TzY/DjIuSC37uU49EWoS8HNQYXAIj4rdMfjMZ91qkGP
 QWw9vha04OyN9cqfNhTuEz51rgGFE6xuYk2hgnVdQ7xqtB2mMiGGmqnKzFPQodQwuMWykjH2cMh
 yreXfQuip1dB8jLid0ocb3J12pipKw==
X-Authority-Analysis: v=2.4 cv=d6P1yQjE c=1 sm=1 tr=0 ts=68c061a5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=mth0E9nVuso7ZPQHae4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: gSJthS6ESpf8vl58tREtSg33-llMCYHq
X-Stat-Signature: eu3sg5yk4x8gbpupsx1w8u4rq1gh4tx7
X-Rspamd-Queue-Id: 53ACA20005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757438390-514116
X-HE-Meta: U2FsdGVkX19sjA/QO51MtcDf949TxaleDU5QfhgmInxhrTCG7P+vRbHdBWsdWIQcs4G3JKP7AMAoBQFXJOJ/P7iiZGZBUDd2oETksDLQxFCFfYxJBwaIYTv+k4ovkjh61YWDdJfenGpjyr04X3zT1m8W/VZIemFYA4vzz4b6wzVuMqCSBG/3VMPyRGHxEDOqSfvxvVLhM8Bgln3Oy6JdPC7hyO417cvCE2+7TtOVKoW5KItyGkLvWlDoX6/rxaV41P7mxefV4MVHAS2WAii+vsYwMlKHOVUdPsipDkpQ9kvgdARrF5Ycr0kW9CvBW7Jf4En7N67h+aHTwgusP2wvLKapiw3FGN6DBQfIQgY7B/aQhNa9AaVznoYHIexbNeA9KOI6ACsU8JIL76Ny2FSoe47wxOsogguHfGrolM00zAGLzDejmX8m1AdhbGQwL0Jq9/AcRRY41no6lyA5k8wMnpN+J38K8GDTUnJagiEXTphrIC8SDDakYdVF3XgLXAd4DHAoJoAVqVhxp3oeQieiD50bJJeq6LS8OKUYexZgw09HXaer2n++1vLCz8ZoIwP/ltviZLwJxpYZ8YTn0I6eyr1lZeoKiyar3Mckvjfx4F0lifhnnHxg3SjAxMxqNducsh51qmbR+XvNyy8lHWHyZRBlC6Cv3RWHyRGrWJPIwWkvFcJBOgonBEYK7F981sjW26AzAn2ety2ahxcj6qwIDNpQkkPNxXOD4dmNOT+t10ply65yuj6o4+BT+5gLxdqjcFHtsw97hzrRTOkn0Sx2pEbbvhvwqfZ05H95poq9J4s5+qg0hnhvfTC4P1puSNwU25tOS8n0g7Ck37ZqcMI32+npxgYnPMG2+P4uiLfzYC70YUlcXUmervr5y1+nFCPJ+CoTgpNe0wEJ5ORU5pnXXKB7AM9aXmLK6Ih/PJClggTnWg6Q7eq5zmjCSKGGCHui6EQWaqulhPccCDa2Y44
 FT7JaPYW
 F5WAMcjSYUO+uWR/5U7Oihsb9mYaf40c9Fzg7A1N8sOnoGBvuYoRORdUqeqpQX2P+dwJm/Cq0G/0nK8cyeehvPZlpIKv0oEMkTcTYobRQeJ0mOIjbAypXpjyHK2XuxJID1zcZSqjptAQQh7/mGKIdyI7ZMNfqv38afL7jIYzDAsXr7e8c3qpdSyCO+ANpAXQc+vmk7JA5I33VGurdrZvlmD2LUxD5Jib4BKdRcJEgh0X+iRHHixpFaLm6jG6F5+acKcVAlE3qzCxIvtKvDpXyn2x37jsnox7V+BAcxVikaaTpO85X02JkzoPUCP3xFI3S/p/qM49Hjo4lj0DBi1SGJSRHQ5zREp7HIX4W0Lc6+M6jxxhEQGa+pN9ik/LuzqU6sum229pz4C+1USUH2lT0i3O9gQGjuP8jbKq9Ku0DiBbtP+xtrnhI1l2lYlaKsg06EdHN6QF0T0/S1bep7OpGGskO9+p05mHtAHOjy2/gA8NEnO0puGcakQWnPWFp5rbo6s59/MsTKohwD/ow9zGT+0CsVGlybhPd5WI6nuFe2ntE2J091MBVOrUzzvhIy/0e9Qi0FaKTn4RvNbaPNkj9eezGPdttSgWkfwiqggNWTTTizvvl+tMyuQyD6WHMTX7LKyvmrQF0YZKKK8gUOEIf8tmfk127J5QzEhgVyidMUQGQpRbwTks4PJcPnRPbpLLLnjjw/PxSVkWJf2Ud0zY211wPvUgH6Df0S5yAQC4lXu7cvhbc2xvwpdLc2JHzICVOIGDANR8UEBEm6QOuoc1n9DZGpQ1CscC8qZdn+mOkKWLuA4unhV1ivq0WKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250904 06:21]:
> On 03.09.25 22:19, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 15:14]:
> > > On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> > > > The ceiling and tree search limit need to be different arguments for the
> > > > future change in the failed fork attempt.
> > > > 
> > > > No functional changes intended.
> > > > 
> > > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > > 
> > > (Obv. in addition to comment about broken VMA tests :P)
> > > 
> > > I guess intent is that if we discover any page tables beyond tree_max then
> > > we ought to just wipe them all out so, in effect, we don't consider
> > > mappings at or past tree_max to be valid?
> > 
> > Actually... there are some archs that map outside the vma and they are
> > valid.. I think mips? and I think lower, but yeah.. it's needed.  This
> > is why prev->vm_end and next->vm_start are used as page table limits,
> > afaik.  This is a serious annoyance because it frequently adds walks
> > that are infrequently necessary to the vma tree.
> 
> Hm, does that still exist?

I think it does?

arch/mips/mm/fault.c still checks for addresses between VMALLOC_START
and VMALLOC_END, as well as MODULES_VADDR and MODULES_END and
(potentially, depending on CONFIG) jumps to vmalloc_fault.

I tried to find the statement of the start/end going to the next/prev
vma that came across before, but I cannot.  It may have been in a git
log for something else entirely.

> I recall something odd ... was it that gate area thingy (in_gate_area) we
> also have to handle in GUP code? The is x86/arm though, not mips.

IIRC, gate area is to do with vdso/vvars and so going to the maximum
allowed pte would unmap that even when it's not in the vma tree - which
it is not.  This is true for most platforms.

But if that's the case, then unmapping the last vma in the tree would
cause the vdso to no longer work - which doesn't make sense to me?

I'm not sure if any platform maps them at a low value so that
"prev->vm_start or 0" makes sense, but I would not be surprised.

Thanks,
Liam

