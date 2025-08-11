Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE35CC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 10:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6E28E0037; Mon, 11 Aug 2025 06:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 450738E000A; Mon, 11 Aug 2025 06:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2098E0037; Mon, 11 Aug 2025 06:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7D78E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:38:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2F9AC06FA
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:38:56 +0000 (UTC)
X-FDA: 83764128672.24.184D2B4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77BC4C0008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:38:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HdMtAGb4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Weduu8bV;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754908733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3yEDIwOjomvU75EwblOuMVw0QpLSrokVkdO9CeDodg=;
	b=1ozMHrfHpZ77np210GuA7Y/r7zGJCJX19StPevE/Ybj0bAtbsBI+tguEDvtMJ9MZfQKwXn
	Y1KkDniyFKRLM/Wq7kZCMPjFxy/mvqfN8BghWZIipE8o+Tdfq1AYBB35wFoAqNYDcm3HY1
	7O2SjdX2v01ho7f5J58AewHqd2tZtYY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754908733; a=rsa-sha256;
	cv=pass;
	b=u0MEpFheC5ysid0AU+w7s4YAxm1/Ai+rr4ezaIpeJgo/vuBmEbtUYtrvmcHQcWgUfR8FFc
	sinruniwFC5jqqHn07CLI1e/1LLMXaIChYsRwTs300PcTDWVEWugAL00A3vYla4pEUPzjn
	OTOmN/QId981wQfZu3l8NcEjcxaYWGU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HdMtAGb4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Weduu8bV;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B5uEaV004960;
	Mon, 11 Aug 2025 10:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=U3yEDIwOjomvU75Ewb
	lOuMVw0QpLSrokVkdO9CeDodg=; b=HdMtAGb45b9K30oDKW+c74iptYntQ4Wjgw
	JGG9YpNry6dFAbYX4OmkQlpspsFOV9ndXrQfVLlaM1n1L4ob6ymkizzZqtwpFyFm
	4eM5GvaIS30Qt81LpM1sxcvj5pPS248ppMD1lZjWd2boivMYRMn+xHGsBDgWyaIW
	pm39Vd1NHmQ3//OND6fezX+AJAPY+lu2xrUBYAdJdaGMlQzQ9TCim3JOpW66/S6p
	wiIpHMyoigIviSRLl4CNoS5WAnmqr3IWdB2tiDQUL7/it6qdqYEv4DP6co3Icm50
	qSArvOd9TyNQCbui5zeCfWUdtNCg99YarGF9NLFWUvWLTXmg1oEw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4a7bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 10:38:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B97jg6030163;
	Mon, 11 Aug 2025 10:38:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8fm14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 10:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pesSEt4iFtNLk/6yS/QjfWnCNDKZC5UoIMJ0jzFLchvIDkmlbbxyGY0GWXLASfIg+Fqya5ViQ7vbBmNaP5MreyP7g8wS/NBjIij5DGEwbW2NeNpYCtwO2bepKla7ahtJYmhW2L7qB1JbiwUqgl+pD9N+Agu+JcH614mybX551LmMkXlfkIF1n7MiIKHIhAXOp+X7sqm7qFPDsS55RScdpR+bivsqzTM+LpxtJpP7gQBlXdcOWUM6pMTqKolN5k1IjDBGZCz//Lr4CfgB1CXRtszmIu7Wo6XJhva+GqzcAGt4HrQGnOPHNg16OeUOB4tkzWdTA4Yd6DADEMeSNIFBug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3yEDIwOjomvU75EwblOuMVw0QpLSrokVkdO9CeDodg=;
 b=nRxy+ziDxZQFAUS0/20G1L2LUxQJsJ2n1v6qZiLYRCT8MzjHnUMgZ+xZj4P+83nQATKx+TNiMutXyV7zzmX7z3a3uPFMDiaSgQRKZDMH1Ak/vn8MRwvgE66UWAoSglAzoiG6I89pCemCFc0JoqbxR6kiCJBVKG52xhDUQtkoC61wh5KNc8V6+HpBim9/BXWSxfTkzyC80hoxQ00r9BlDKCvyhExPiDveUIA3t6SeAzpfnKPR1q/8zLbZAufnpASi6pWpm7N98bNo7kX4VR4qmEKpIEGOH+xkQln4i2iEdVcz7zDAm6WJyZvbCF8l865m+UAQDgpz5AQIjYGfT1dhYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3yEDIwOjomvU75EwblOuMVw0QpLSrokVkdO9CeDodg=;
 b=Weduu8bVk7Kuez/BB9J+EVhl4LRSdx6WB4Q4zcgNMmBMHUEOnv3TcQvOhaaQ69eBZKqYjxydmtd23BthSGgUJPjtHRPSjioGT2ZKWrhEPkIfanfrtLWjHBCveLAKydrhZ3nOIFjqXbwYDbweY5n6PsGtGIlr7pE7CFjWd90Mm2g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6531.namprd10.prod.outlook.com (2603:10b6:510:202::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 10:38:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 10:38:39 +0000
Date: Mon, 11 Aug 2025 11:38:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>,
        "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>,
        Dev Jain <dev.jain@arm.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, willy@infradead.org,
        Ritesh Harjani <ritesh.list@gmail.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <efe936a5-aaac-4627-b227-f844b1267297@lucifer.local>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
 <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
 <dfb01243-7251-444c-8ac6-d76666742aa9@redhat.com>
 <112b4bcd-230a-4482-ae2e-67fa22b3596f@redhat.com>
 <rr6kkjxizlpruc46hjnx72jl5625rsw3mcpkc5h4bvtp3wbmjf@g45yhep3ogjo>
 <b087814e-8bdf-4503-a6ba-213db4263083@lucifer.local>
 <lkwidnuk5qtb65qz5mjkjln7k3hhc6eiixpjmh3a522drfsquu@tizjis7y467s>
 <57bec266-97c4-4292-bd81-93baca737a3c@redhat.com>
 <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <osippshkfu7ip5tg42zc5nyxegrplm2kekskhitrapzjdyps3h@hodqaqh5r26o>
X-ClientProxiedBy: MM0P280CA0033.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6531:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e58e47-1bea-4cd1-8c92-08ddd8c33bef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jCUcnzJnnlD7cVbPWR2THIOqJwrHlw8RMul2eys7U/AUYTG0O/aDkwn4znAW?=
 =?us-ascii?Q?Kxk+TrKcLZPT/HYdQ2jGBQKVzLCmbh9HRn5JQAVBoUjJevbwUM/erfLjyLdJ?=
 =?us-ascii?Q?6yutmIKDuM8p0GH6nW8u3YiAmC7GulmWcTm51xVqsgXeEVJ8GmnCJrHMppz1?=
 =?us-ascii?Q?AGn0jvWn5arXdSDyRO8PXBMujl6a1R8oRoFaqzpiNdJtwU8QvCqrcEO5QNhn?=
 =?us-ascii?Q?BWJwcsXhu8es6bV75OB4aIIJ2D5pKZcf1ZQeS0a9c595RHiRv5Z18rGLcMoe?=
 =?us-ascii?Q?5o06L66uQCuoC1CKacPcIA+UAZSgul4I93ISeVzAM+QAht++zkKn+jfQ2j+N?=
 =?us-ascii?Q?L+yxjsZk1BqIGTUvkqVFEpsVOsjgmW8LMSWRfRelmUej4gdH3a1uq/dELMgu?=
 =?us-ascii?Q?HYVQ1EVKG9HH8NEkhW47j1ze+4ODfoBEgCSagHjL4+xCBbgM7N8DhWM4AxrO?=
 =?us-ascii?Q?AchMwcrz7/+97EdIicpnU9FG2t71UvYuPA3HHmFtSma/pGtUs/42nFsH5Q1Z?=
 =?us-ascii?Q?X5AquPjo4545cftc9ffXLXhaDq1ybZXLNadOVo8C8O0k/5LmIbwVDV7x93S4?=
 =?us-ascii?Q?C+RnPAoV+Y90yI4wKlkChMUllFxphfLa6G0y1SbFiR0HJXhDrqoc7C4gLMtS?=
 =?us-ascii?Q?/5IZQ3cCzIifsTucrS7MiaTNwKZokSW96LkDKj4bkteupHZyYt09HZ47UrHN?=
 =?us-ascii?Q?ynKPYhew2yS1H33SLTy82olv0nGkJ/m+yW7jvrMcyJTBFhFfusROQUtjfolQ?=
 =?us-ascii?Q?oAbbLNQQJ/f/I+M+uIZ/I8nUmXQuOrWK7/0AIA2L4ckSTaCkGls6kTDt5ArO?=
 =?us-ascii?Q?pcBMLq0Q5WwGAShvmoxx9Kj4n+Z0ygyV8XeyiHb3t9HbZPzUl+zMnaMRReZB?=
 =?us-ascii?Q?kNdKDZdPAXyCQ3Wj4cFmuRcs3Q/vJ437MBbAPfOGHsRiMJlYmNbsOqptSHBg?=
 =?us-ascii?Q?nj30dQtA9YGpHI8aqq9JmZ3TuFrSQwoSdJ+fO3F6TrOJJtwrzoi1JKS03BQc?=
 =?us-ascii?Q?Bn0EwuBVkzD5xqdd01HzF9ZsFJHeshecs/+VjY9VpfBEFgFmQzQiSvtL7oJA?=
 =?us-ascii?Q?ralT3FWuxZ5KmcHsKbk9JefvqQ6qkHLtSb/RTh4S0IebKoMTqD24l4iO2liS?=
 =?us-ascii?Q?kSU/l/jjFMuUNHyDNee4l40+MHNEJ0ouTwTEs0G+FDdLAsVJRqU4KqVL59zb?=
 =?us-ascii?Q?7+lexV3WKqmIzAr24GXVkpNBaopllh384F9r/mhLLNvcCUQmHDozLl2JVKlr?=
 =?us-ascii?Q?NHdms/36dzoIaFSsVOC39e4j0qAoOl0T4tdJuGAUL0kjFH6W0nPpXfSshwDO?=
 =?us-ascii?Q?zRhyOCmoXLYLs+mDBoq+lFS8JDmjsMEkEyMJX6F+IebW4O5cRu259yYtPgAi?=
 =?us-ascii?Q?lXgHiv3SYHfhwqiKzcn3/Q8JpwVxvaGiYigJnyG/A0Zg+YinPHF1ux2+ncFe?=
 =?us-ascii?Q?QUWKwdMxpuQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ziOlrw22PsnoOLZGrFlvW5Gjs3s9VTLrnTarmnUbNZEvJ3Ci1LVlXHkaR4fe?=
 =?us-ascii?Q?LkWL+eR7a45no2OCQY7PzGIgFkeOwTkCBBomJJyr5JnxsvHsLI0ZykR7r1u1?=
 =?us-ascii?Q?1ajhzWXuc8a4Yq1mIUrjg9Hh84+ZjiYZXzfbWPBAM9OCUVGkpsEKAGQVFQ2Z?=
 =?us-ascii?Q?U7HAPsjz8DHPeoY/wOEg19Zn1YydDM04U+op7pRT2uMvP35E+SwqW983jmd5?=
 =?us-ascii?Q?4KzSqDm4XxN4hfHIrl8c9b+uCVCPGuhmL+iudvkCSlY3MNDSvGwFx9YbDJET?=
 =?us-ascii?Q?Xxn2hcc6D9cK2XDwdmarkVhdF2QLAq77B0/+BwSkdK6y1U3xwnxNpgPXSxKK?=
 =?us-ascii?Q?ZjBl6V4fTM7vQxPV6waKEgNurVzLrJ4w0YKenudPfLWic3wvzlRH35tyZJ3S?=
 =?us-ascii?Q?7QEKAmOUOSe1ptaQp+jMD2kVAlp5BSyoINmQoJvMfwqrM5DyKiT3vQKPle5p?=
 =?us-ascii?Q?S+mRvx1ZzduuqTO1E+pzhkeTC5zGNIEXDxCyAFkkbrTWctgTTuyvn8KbHbIr?=
 =?us-ascii?Q?/TkaOIVcPRlCkD6fK7wsLcD2gOnJm94isoJsxrbnNCkhre8E0pnhdHqf+SXJ?=
 =?us-ascii?Q?iTQ9VEjBk8hipyzTPTQkDYG+TQ5GrZYb+KDkMY+1kE/Dnn8eSxLT7YwG9zV+?=
 =?us-ascii?Q?/f7S9LM3WZP1LnD1qfg5qRwjeTV4KxPvsrgIH89ss5DlwaOGJXG4shf/syqa?=
 =?us-ascii?Q?7VVWdhxJlS4Nw9Fq9arr3aiib+DfDic7PrtjYrif7Yn/+nY++oO/4UHPDJUG?=
 =?us-ascii?Q?o9u4dX8tv2h6uX1O1gUCR/dLF/ElyI4SUVGD91bHv5/0fOuFYySnKSXdg7a6?=
 =?us-ascii?Q?fxa5op0n7i3fju4LV6e5tPMA1puPXptZo3oKtHBhN5obh50kHJ+H920hyWTx?=
 =?us-ascii?Q?+oy6Ow6xttkIQ6lZ0RQICB/+n5rkYLdrWj4BhkQsQro+UY8fxPaCzhsDME/j?=
 =?us-ascii?Q?2IynLG8vkJuQwmZSO/HcDk2bYu1AMUdSaxOW4G/ZvNQPN1QCCNcEsBTvD/ew?=
 =?us-ascii?Q?ZWjg65hcMDplDTDXAkWMiNnP1pva8CpRznsj/Ul2k8F39ouEHjmJ/uHgdKJm?=
 =?us-ascii?Q?wor58VNQMGzcrhzPXCP9tOBFpWwMNmMrmQW9tmI7JTUsVF2//eV8ShwnSi91?=
 =?us-ascii?Q?D3xSIBdJs0/Hy2+TbyTm/TAk7IseO0z/rxKYYEonTCvamk1eoNkZPJL2nnR8?=
 =?us-ascii?Q?vpHiN0uSE8qndI0cvnPyyfNeXc9JKLhDvsQ4pUAokZ+FkIeFYIA60SArAzzB?=
 =?us-ascii?Q?8TucAf4BMZ1bf5EJ/4TQivUoSiyJXrv+vpvvtmLeFM+H9/TqhatGX177/h7W?=
 =?us-ascii?Q?4VAYIgD03bEPUuXTagXYJ6SkLnD/U4tEubFYiVk7IFcZbc/87W3Ud15lc9NS?=
 =?us-ascii?Q?/V5owh0XCo+IjcYmMTgYKJK70lzUroeUTaorjZ0DjUEGZjsyNajFGA3WQIXU?=
 =?us-ascii?Q?WnGp5P7yT8c3Mz/IvdU9L5OZcgV6pw9+AyuLgJuXxZULeWYXh2Imyz2Jpe6S?=
 =?us-ascii?Q?H3M+/z/HbvEaZz42hxNNRzO1Myupr0u0tJDTX+ju3FL/KAYf+4eDYp1q887E?=
 =?us-ascii?Q?dLre2YVF1qidSb+88QQFN+z1Y73E6So9hphWF9eiqyFagzZ3A2Kxar+DdfoB?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u69ZCb1hI+HSLPsoUfULONpiITfaXI9TwLAFZGqe0YztJvKLUupj0p9s6plcorG3KPUOt3P8409OKleL35uk9nw6wkUlSfkMxOqfjGoDNCkCj2EDdI+3OxW2P1eJxLxMoKaWXQ/AmxZZcT490yyQXpAfgl7NBZ6o525X/NevD6Ayf0jqznpXcVtqTv38/skt8tDXmafxzvACnPvGTz2s5QNGSAqOmJJKJ0uVTKmf+SH7MiAFS0mR1oSptHVg0KsQ24MnFcAtCfjUTCPtSOmtUDTJVqFljleqHeOa5UrA34NDixq1113fIVTtV7P7ebJjXbPTfzkgaowajIN6EIibjlhaAFXf0OiHRUTULQMA8pQh86BvWbLgHAkEadGizGS9TrGINLsqXgmEXZOQhbGXOq+vA3FB9qYWbMvoRdNfweUyx408GkL/1laM4f1cy6G9G6a2STihOUhwMGpXmwW8odNy9Cj0KE/mC2ZVnLv0ntKM41y3kmZml+9MkdBl3SWbLYGM6hUMVJEWF1tFnBSm5tBnOvigJBXcSM3bqs7Ed9eiwiPrn+1P3ngNmCCIOI8iGZbP48xQXdpVSuiZUMg8i2leNIfBtKRcei/ofIcc8s0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e58e47-1bea-4cd1-8c92-08ddd8c33bef
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 10:38:39.2870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfYTeP+rv0xACz2SOztHagLA7JymJMttVgylJEsHLSXu9hHvXVmvOMveXfP4NTqqzM5Y26JSCky3K6ZnQZOIUARPf5E4DNb9h1wMp3ACclQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6531
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_01,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3MCBTYWx0ZWRfX2y4HTCb3DBKY
 /M6egUlXkjQEYLCyBIrEHG5OehgmqRdXMLcZf9m51XSLaZDkhqWQEam3Fanfpl9aeS4jRxuszRJ
 uUA6vDZZSXgsMkFava1VzkiEZ9VpqJ4oCATJ8ZWm3FANNFjksSyCkllPPuJyOTfuVjXmfizgGAY
 MRH30ZDx7vRjdrptM6qB1AwfWxXIzGnc5FXFN025jFFTEmDan4G8wIlWdOo2gpFxchsfI69ej4h
 2sKlLOBUZV/ZWQHh9vIJSxu7cVxekDzL7zI1o6UxnD9kYNAhIw2MpHzcbptvpJpCsR/qeUDKZD4
 RCC+5/3qkyUEkgBjZjc3wvj1SgN9aZIHFTkPwmDU53GrC6t3NCKtjecWIdHoO4QL/1oNkyHAFAW
 PptNdfvk399u0MaJG8BvJ8flcivdovfZzYnmyW6Q2zX2+kCnU4iHiSC9ZZKeSu4Ca6sRSGyU
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=6899c833 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=b9kdJWguJiP7UNHyFtoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: JFBfeBRCK6UtDUBNFJXeqf8hfyKXHCG5
X-Proofpoint-ORIG-GUID: JFBfeBRCK6UtDUBNFJXeqf8hfyKXHCG5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 77BC4C0008
X-Stat-Signature: 7a7tup9wuwzc9qzbteeas8dhx8nzh1z3
X-Rspam-User: 
X-HE-Tag: 1754908733-79401
X-HE-Meta: U2FsdGVkX1/wUhR73hVV8BWvgGjL/dNsDvez2Xsk4P2QUfM6B6Cpj7XDSJ6c60RuZj/xOa1BUUBcw0LqfBolxTtgKJsDaHGdVJc8J+p/kvWLu99FduIVQCqUvUJgH7/HYw/AHhWJZoQi41KKVZt6DtJhgczqprrMtV4pMby0E+G/y2k0i+KWK/RfJYFyvK2Z/JuE6nCACzN2OH22JeQ483U55sDT/ROHJc/5nozS481zGfL2pkjerty1evJLbyAigVFwpKDiFtaacpm2fw/rRKUDm/BN/0SzsZ79NDUzfQ4PAL8chmfbvQNoYz6LCaGJdfMiXphexqfTu0toImUaMEw/l9H59g8qfIxpaySlBeqDGfd2G5JHLwbtYvtclESNpcSrnMRHUTckkNi4Mfff4kwEm34TWg71cb2iRVH9ZXYeqBiiyA2fhNQFEcdrmV8IMc7IIEuP+IZdTIeKHjFTp4aw0US210LcBL/35UrR+AwBNGyOLua5FfZPDXXIOd8kqkRhS2jIAjBU2t4o3nAt16G2bcIW8v6CXfWN7RaGVNU3Lyj052KD5jmqAL8/vYu4K0exhJGju4lXSbVaReGql9TaQPT8XP/O5c2Oc6j/IoxBvmlIOH5ZUYPlWmtRdTzAirIyavLNfpnI0Ijun1B4wVk6tZYDYGxBoWA9sgd9jQjQd1nI/6lBm4OESrCw9qy1r91tbt/EtgHXgR6y+V7Smj5+Lwimq5Sc7v0PpEzjhq7I6HPO/JF1af6T5D5fhoDZ/O33PDUt+Z5YZMCR0IZkZDHzPDiCuGKLzxU4r0yePOSnVIj9rvLjIDWlvI+v0ypMixVf7H5NObdjpI2H6zplxTR4lPiSeJ/N6qL9GVSH2DwrtbXLqIxV4aDTLBx3ISpx2fcbHT3+9rkNIGzMpTD1JNSjvBpTtHOoMfnRTRU1kQG10YNZNorYdfY00lT/EwMDTmdDWU69PGXyGTMUSTM
 jMPz9N3p
 xOOuoqXVVlhe/afHib5uNqMHaQSHQqmThuHOPfuRNxUYAkRdYM7AshtZ1qNoeNXAoi1DmFji4z8vyB1ue66jahcykL+yb4uplTM5Cp0uwhoJqf4LYSl4spK95fYV8VTx90yuNWGd+5bbNe3H9kR5nSQw8eeJQ2TNeFQ7ng6bBBq/u+EnN/RpBDUte1pRd7vhrLEd9DiYLSRwUJWev1TX+3osVKdMTgTT9g3MyDNYG76by6V3VcHb2bPY2NTpZ9XIee/4PxBLYkpmNXPWMx6ETp7SJoScnkWryH4sfXq37uxCpgUb7E/2piRewyRjShT7nKzHDTjCGQZ1Rf5Ect9VDs9FRbKtj3QdyEJQeaUubmHcy/JnRFCmZqrgMNMAGwZTD2KNdErZivC5KvK2wWLnrYT+unsoRW46bxyyzaucT1x5P+uRhwsELCBXzBSYcbA5vXV2CPSntXF0KGpqSINAKtDOf1dHMCqK9nQJ/3lAHpCirYFnq637DRpBddm7ZmyPrYmLIq6G49/ez5RFEcAVYwBaY8KE/JibnBvrDy0Bbhs8b0NWvavba6EQa8ki8BCmDQzOOI6LzJCKN5YUhPVM0hXr0N3LYVrYq+uzwYdI2DCCXOjjI/TuPAccRzlg2sU/ykMNociKpQ8RVhtITdcRMLX9c0pyWgG/ttZb9z1c8h8MeAkQ9BXDlzmfJlUZxTuqxtdo+mmHDSmlH4FUzlSy08nsqpST1hKBJOO19avq99WsHoBswkHWDV46uyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 11:36:29AM +0100, Kiryl Shutsemau wrote:
> We have 'totalram_pages() < (512 << (20 - PAGE_SHIFT))' check in
> hugepage_init(). It can [be abstracted out and] re-used.

We can decide to do that at a later date with whatever heuristics we
like. Let's just get this merged, it's behind a config flag there's no harm
being done here.

