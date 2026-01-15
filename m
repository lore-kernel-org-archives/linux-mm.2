Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0BAD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC7D6B00E0; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FD26B00E2; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E8B6B00E1; Thu, 15 Jan 2026 14:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD3286B00DD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:50 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 905331A044E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:50 +0000 (UTC)
X-FDA: 84335208300.14.17958EC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40E5F80011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nPDbe1FO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ACqGB14B;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4m4O1qll0dL5RC1W7Wv9TsiogoBB/C/DMxH/wX4Cd4I=;
	b=MoaPOX6NCIjTFjypxhSBIuLzH8C26q7b4kb58EeI7tJv22D3dWXzOXbZV5XwvUNUhVxJLX
	FkTGvxeU8oApFJIQgu+BSNCn4edtr37jWHdg7IZ2q0SoZ3R3Q12R5kJCdfhREGi8LprM8f
	/N7Tw9etMmoyZ/FVHHG87LqcxO/Iz/Y=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nPDbe1FO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ACqGB14B;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505867; a=rsa-sha256;
	cv=pass;
	b=TFq7sGke1uaHMPdNKRCLdWQN6CSBZS56TPGSj/dzzBTp9YjA5arrLgNsa+tlBuUYtvPYkX
	F8cIJ1bJtZibbbeGkmiGVqz+sO4EMqK6sufMC1U/rf15LH0eBeld21vcwSaOLi6g71C59W
	mWLmvqj9sCPJzuNfSproB2Fde+iSUoU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FHKid12811661;
	Thu, 15 Jan 2026 19:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4m4O1qll0dL5RC1W7Wv9TsiogoBB/C/DMxH/wX4Cd4I=; b=
	nPDbe1FOn8ZqFC7/wWH+dhRFUF/oR/dLLNUFxhKFvCLKVUnt5oSN9XsE59TRaO5l
	QWkDgHT+WDmoGYNIO68AWdkz83+Kk+/doUaCbk+sltzu1sStdnGehpUG4Cd+O2mW
	pY8tjiATqQMBdWwBmFk//KTKSVi/mhYR6gDZID0olCCl6WJ0Ni3kq2UcbLTSgnR7
	SmnkGlx8o+W4tGpBj5VSj/SX/nDJe+FndRGY3XmTfLLFsmQfXTkVTmwLZttlDChS
	++WFoYgALa5J09B5nnYxLUbtrlzQCCE8LhB3cdlqcTZz2LTvFmcDffjpRSbVDHf3
	0Crg1UpPFaGEym/mO9HJlg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nrnr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI1DXX004234;
	Thu, 15 Jan 2026 19:37:38 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7nguhf-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nIW/s+WtxVTfFUW5Q2oeJeVDbt1nfwQBEIkqLvKJ9UTtH3OHC7WfR6I1A2/CQYDnPvNZLVGQcw7mUuQdr91czNh6ayI2pGSfZLFVX5xppBOLxFDCnkhRZqq373pQcqhFxmwTWkb7lPNuBc7jWefLPD1lH+nEDR6ZgDe1Q2shiw0f95V2xwEpiqlVu6ApqqV5+OUQPY/9qB+jxDruT4Auc1eBY7q9DNeowlfEsAs1QU6neTEE4HejJ8ZDF2EjSWyXZPT6B+Zm4qxi9nIfdjI2ZkvnAlePdeSqQIJGvija1PlR7hL6e5fUcy1vb3P6DjvNoWa5evEpsBcGj5USPEN77Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4m4O1qll0dL5RC1W7Wv9TsiogoBB/C/DMxH/wX4Cd4I=;
 b=ADD1lB+qxPb05L0Al1r/h4IsavTFyvF2yhD4QjnRonaALAIX8Ys/IXQthWaXJfQOHqraWht6EA9rDSmXrieTh1F3sPEKkLiuTa3E/XnLq+yri91dDslcT7A0AG0Dvb13Bwl0gu9lXcgj/amGZ6R3ZrcRNSnAYC3HiywAUH7f0f0pFC9Ma61W9Kl88nTS8unigi+oMO+ejx95rGGSbH5uyEB67rISmriD5YjohBtCaptq2W7CitCnMiGdaLGrCgJowfvVdR3oOSzTqgmnppAaeyo970XbPhZeb2duLWyg3iaLdV7VIWk+n0jYXTNKb9WdPn3RdYwD+onzUfkYDsOGaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4m4O1qll0dL5RC1W7Wv9TsiogoBB/C/DMxH/wX4Cd4I=;
 b=ACqGB14B5nhvH9/3DWeY53X3QH6sEpqzAke7/hk4jT3xVMXtbIee7k5zoB3Zv+z0hV5hqVP0BueZY87Hzb0+p73hoJamsGddB4ENfzGygYunMW12iRl4zzqVOHXKX2Te2ve3o4IkahV1z1O7J7T+sDRrScQRAd0OT267a0D0nbs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:36 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 17/28] maple_tree: inline mas_wr_spanning_rebalance()
Date: Thu, 15 Jan 2026 14:36:36 -0500
Message-ID: <20260115193647.1695937-18-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0341.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: b058ace9-0638-4695-9412-08de546d8912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pjPIrWAR8GBrUXCTDrLvHEk7tGsHgUX0auIaUnOzk0B/at/Ln4JVIG4Pt9Kw?=
 =?us-ascii?Q?2RKHzT5z6CKzzK/5stIln6uA/Brx/OsOUB9gIl5TyK4HleGqW9+Iyov5njo9?=
 =?us-ascii?Q?ofVBYHFMhcWgG+6moykzIdgyr1ze2e8H8Y+fgMo4WJOdsUCAcCQAlD727t1D?=
 =?us-ascii?Q?MxWWLe8iJV+oXGExtB7ttMViBa6/qFCyBM2y3QEiNima48x57DTxWdzzZp7j?=
 =?us-ascii?Q?KWInlDaqzPhUd1L86Fi3OYGOcmafSDlQGw368eczfzwVtERUtPJLImJpPNrI?=
 =?us-ascii?Q?uIqoEhVCBTa6Bkv3EduNboPuTXGAEI3aiMZBPUZ0ZTpmCQBEQ1gI7hvXs31i?=
 =?us-ascii?Q?IRnKWg9ui2y8wQ5SD/v02berUluVLoBfTJHsRjCXF3nXvjb25F1WGMWeUQG4?=
 =?us-ascii?Q?bekMQkOwXQgCZPoNeiQRc/x+CFwnOEMImlI5yVQTfvQXOx3/7864vnC7Rd/N?=
 =?us-ascii?Q?dIAtZ1j610kFIH9FWpvjxru0lGUrBwDdX548ToLJ1oN0MokWZWOB4FTn4CV+?=
 =?us-ascii?Q?lea33a6k3mAJdPmy7jFIYcAL4UVpbkJ8y5djWmo/xkV7skwe4fswPvi5+TtI?=
 =?us-ascii?Q?XIyvkXQ8LD37sAgMFIkHsYs24PLIwgwdzY/w56rFtNivRW60fq6Ff8CIs7d4?=
 =?us-ascii?Q?EMUx+R8hguiruwLDxIMkx8zMdUp6DXcVRD0pedU/0BWBcaYRZYIaNer8e/o2?=
 =?us-ascii?Q?cWk/mO4bh7VDuwbeIq0wc6uNUe7j8762lWgEoRLLZRltoYpzyFoSfSTvY0R1?=
 =?us-ascii?Q?8SMqZkRQq/2U5URRY9gGPm3jbD4alPjb+wy3xbbrL0HrrxhJefgTerJZ9vWn?=
 =?us-ascii?Q?fcNIdR00V2261pF0U60lTbQ+gXFFskZxjOWt5Cr3xI8szsWLZywgnIkRnWCu?=
 =?us-ascii?Q?lVTucowXruoarfChHYx90J0ETnIc5t9stuXCwhpfApHCdCu64T4tGTYwVox2?=
 =?us-ascii?Q?4RTzOReA0L4Q5Z45UZR6PoAkvyVPwYAMeUh0BbUgXRgJ5C5IIugKVV6cFzlN?=
 =?us-ascii?Q?y6w1Oe6AtMM+MH+bwK4Wi+4dUQLk9C7JioIGallC0XZ1pcNDYf6TFEVbNcsO?=
 =?us-ascii?Q?S4yOpCrX2+obwO7YD2VFUtaGIsgyB7aTGtYPHtj+0vS30Do8j8O5cM/aLaPN?=
 =?us-ascii?Q?rzhu45zN6t0ADkhVFUU3rbb5z9h++ZOFG5OGB+4Y+Cf1I/6DV8V7BnkiHjwx?=
 =?us-ascii?Q?unnMeqlS9IZbCop7t1z2Y77J3lDqvUkBmkyoUQxNio79ivEsoO7ZpdwicCGy?=
 =?us-ascii?Q?EEdSR5soztGuv6VpT37znq/sCYWiPAW5CLTpFqYW3CVaK85Tq2KYixPvJkId?=
 =?us-ascii?Q?wMc5e1cBWDag7xgdEEZIrg1Xn5jtzBXi9xBjepB4TZr81Vege7OxAhQ2QI4B?=
 =?us-ascii?Q?zBR438b/PnZd1S+snttViCLnTt4/pM6/VFVqM1aqKExYKMcnsqSZTSWRJuHF?=
 =?us-ascii?Q?cpYjmWw8T2d5FeOF9MOiRwMQJB03POwiXA7/m32QJmB36EbB6lA04RuXLX1/?=
 =?us-ascii?Q?pTV7a7wfDjrR4LtudClCUFVLNW4bctT/aWg35xtwc9WAPWK1xrQcc6kbYFGD?=
 =?us-ascii?Q?Q3jewJQu5F8GjSQUbCg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EzX4LB3F9K8sAQHv6QPXt07TzeIz/BKBBBsBJwGnmT3s+XBPJtpCQIQ4YCAh?=
 =?us-ascii?Q?T8LCczWr0djd4UlvO1PhQ9vakNP2snw/3fMYoHZ/XY4qGC6y4mqTuiyAFf72?=
 =?us-ascii?Q?saW+azCvDvhLgrVb/6SEe6aqqJeORTeaMi1IsyWpQhk2FBZxVPrxXRayY1JB?=
 =?us-ascii?Q?Q5SFA5Y3aJl68coZwcwcSy5yakHovIq4dhL2XWIZvr8oL2/T6w8WmTMHq1l0?=
 =?us-ascii?Q?3B8jIUks3RMwhrbYXRA5FQjbHwx9TvCYr2P9uJooCrYAAbcaY//8/QsWW76U?=
 =?us-ascii?Q?uelrQIRGLSXZocLYIyIgavEFiDY+R04Wq/5Eh1r1V3svx7F9H9dHZ3bWcIVJ?=
 =?us-ascii?Q?gqNXePu1/SRIMKlgKS6SsoMLiMSDi9UoO+O5JYf2HDVr7PMcNRBhf0Y28pW3?=
 =?us-ascii?Q?GBzNs0Sl9no+i+AVYdWyRaPf0UXwSIdhvJVrMrMp72oy40GLmpqogX6qIwF4?=
 =?us-ascii?Q?IaAicQ5fRUYoSEeO6sZg6gWGNU0Be6aQRnJkCxW1EmJWkRGgU6c0H5PUYGzs?=
 =?us-ascii?Q?K3Fo76dce3klvdtCuZDUv46NP7bMIxsuN+Okq19Znv/Mp4ABjQ9s6KFW1CJX?=
 =?us-ascii?Q?WOMumXy++35wZwUROct9OiygvJWgteRlCdLNdpDqVK3z8l1CbHna1n/+/qQp?=
 =?us-ascii?Q?lp7qPi/q8cCWP+nTxl0pCuofcM18B9S2FfoVqLg7FyCk+Vj89be1lPn2iyvU?=
 =?us-ascii?Q?CL3ZzcU843B6nOdIe6AXxIT3mhz2F8ih+A9EBOIQqUxTLVfJs2P4tMs10UMD?=
 =?us-ascii?Q?YmSbSEQAen0lLevA8cLFkMXvVrZFrIVbeeIAViEWWuaqKqXfnBP+ZnZ0WZw2?=
 =?us-ascii?Q?cBF7rb90+aUH+4KlPcicuj9okwQr6Ovjo6diAiPLmnLHUfMMhRnq7V60F07H?=
 =?us-ascii?Q?CSrwNR9Qd1Q8Epp+0aEDUj6oZnrU91bCexXWRkUwnhfNGSB5pnQO5xT/D3Km?=
 =?us-ascii?Q?HtEjuFQscI2MdH7ffkULWwyIojDfNcVhy1C/RvsIInF+MebjrwPJojlp8wzP?=
 =?us-ascii?Q?HjBOcaymE5vb6Aq5kwDd1suYBtqcWo/2rgQ/X2L9z2uyP85PHkr9+6pC5YMf?=
 =?us-ascii?Q?lop2PRkGbzOZ+C/+Zrgc/fIXgkGa+5eoj38DOnSwbAICUIXXm7CyFERsEOlR?=
 =?us-ascii?Q?G34MJ/jRGpJaenn7ojHuMToFghNXyZ7i1jw9qiUWaLtoxUBzP4ZvF81OBPDn?=
 =?us-ascii?Q?uTRuhCQsSDp7xST30NQZ8XuornhS958Ljazev21Eh8185GX23YneD7Bo9/jx?=
 =?us-ascii?Q?U2MYZBSvpmxc9v9dtZzE9LoOuqygGhE92bysh1dudxzztU6jd2g7paYQwMRP?=
 =?us-ascii?Q?5WRiVXmHNyWtaPTP8osS6vv+6VHPZkOqmauq9Z3Q0tWNtc2u+U58jxx37k7b?=
 =?us-ascii?Q?Th3mLcFBzzCzF4rcj4pNrDfzsg+rRF38D8/Capkg1D29oyR7rkfQKgDq2Iaf?=
 =?us-ascii?Q?Kr1edCZuLicN6ZA7Krq7KoGUZNG3ZMtDYUj5UCG5ZIFZZiWhuaj6adHjW0ge?=
 =?us-ascii?Q?gTwAMHpxHvmJR1CyvTfH4vleptoLK89VvxZgF9Wzs3/OkcEtvLr70LleBChO?=
 =?us-ascii?Q?dgePgF037GGRtVAMzuniXzp21w2tp8D/Xs7xpEgh8OGxRDbF+ocuxdMNCp8E?=
 =?us-ascii?Q?zH+BP5lMfBqoFrBOGJOiw89s5ddBzaBH5xQCZCbtua8lh3BrTCsLn3H/qo5p?=
 =?us-ascii?Q?T8QFMNTTbhpNPHQG+kdX9e0gArL8JOLSmwuhd7d92yQvB8iyMuZ5vOtPmctb?=
 =?us-ascii?Q?LppwxsiQQw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wladQ1RMre8gWCgy/Fgw+XiXMiivR8PNfrbxZToWjGVBtCp0p9Pz4reqogg5jV8+BI5aqPWD/Wif5mwZcGNRJ+FCULJh4zFtrymcHmoktkAgRXf+HQ6YQj6GQfJimgp28BaQS3M8ZYzMYkJY0gZWdVrEkPoTtI88bGlCgM+zxFhDNEJr/F60WatszLnWA8jL+gAjkswzRef4PfRNYFaoM3o49myoCJPsrMPls+xbepRertRnH8x8B051SWS4GIhX6r9WRxLWUIqzn8OJWvaP8wTTsCSVuysd2+LXNbp3B3Dz32aB932oRo+Nx5mGi1DRBUbiFdRl86H7QYrnwXKTZJdmijwhpIYRjFN8+I7EdY3tXE6f40qA03uNfT2rJtRWWCm49mQ2l3JNFcH9z43pFKM7U49/DFsfHSy3nsakrq4ri44jt4MjQKWB4JSq51Q4sL4JGnhIlVyB2LG2fegq8DOnNLcQNZA42p9R+8QxA9DcIq8O3vw//lj46S2PeVL/roRiRlPMflLCTntA5IgQ8eiWqbxYGd0B4Xu3933mH9XR1dxmwqfQfmgDPEQQNvuwk0VFk6NuhCYL3DbB0G9/pAkgoONFbhgJdesjrB86oDY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b058ace9-0638-4695-9412-08de546d8912
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:36.2404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAVCKQhb2xCywOo5oj8Uy8C5XvdKDbP3ZBOKbfjSwlR6F/ECU6I9LmCsY/dLpjXO6PTxUYjwMTn4uPgF0/nQwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-GUID: _fZE_fcS48SN8vZvkEOLYWi-gJU_hu8W
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69694203 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=rS4Dkz7vSkpNL7l-vQcA:9 cc=ntf awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX2dF55y6nN9jC
 MX3ast1q3gMwL/Q3ZouF4gK5mUBifCC7l3xkQZNNfbF912rRje3asbSLWWTcrYnSGLBgpiXEyt3
 QCA0WYe0WySWKiCFDb7OtEsTBs7wmN156myP576lILeDgMlID9TVGkjGC7Yh16qdrHAKtfcb0Yx
 1B6qDQDivXh73DK2gi2LI2ClKs72RAsPRnU6LtDgnJ/36c7jSZ3JOB+6c9nfgRhBW3fD8zdpdHc
 +aWeYdCne+CFZ8mcyjIJmFddMEOJtRGJZM6pkbbtvzMprlge4w3YXAjPuBnvJ92FZYrUnylhZ0b
 g3F0YQl0BUNkXVz8O5krEb6RC40gLTWY2GmCCRfxflIux7g0BsXmeSR2/Mezf01fxvC/h1mIICL
 nuzo4yMq+OA8VgXBM5eURJJTjbnx/1FdvZA03XLw7j2k68I/XGtS4H5PrpckhRrIxN6cnTyGmkj
 yXBgTyL4xbyp6iiLl6R3JuljvI8F6ICqjC+eWlBg=
X-Proofpoint-ORIG-GUID: _fZE_fcS48SN8vZvkEOLYWi-gJU_hu8W
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40E5F80011
X-Stat-Signature: 7sbnz4pnndwj5ehnpmfrgh7jg6pdw7q1
X-HE-Tag: 1768505867-706015
X-HE-Meta: U2FsdGVkX18izs/7ZqwPexGA5SwkmjxRsbTnEClgbtEA6kUpRezrQpYXTc0tGOupUa5GOQGbcd3eYyfAr2zzSDR5nD+r7g5LNoEXG45PYmOiePSHCQVhbSBTxmh8/uZkS23yEOd7S4KGngXX3fD/O9un51/dCvm9n1s8eOK32aAsnbgudU3oNq3hRWzonU9bty+RhEsSzQsbB81M013ccnzULHn7c1VI1qHELSXCMQbYWeDBgoVRtg+oeP+xNPrsexhmLRN+LIbUvqmoAHlkIeN3vFwNdJuJf08rA0ok44utFSpQsGe5u55pgnygKdSw7wjbE2bIsdoTgvnM5P8MGipr2c405y4LkwTZrOkZmq31xMFAyObfSJgT+m7Fvgxd/TdNocYFfw7sOrEo0Zb/KQ4M/4vjYVjU1nDR16xHOrZmV5Z09If4+8zI7PgyEAfoDNQpIbVSMXjZmoBSjdNZMCWejuY5i6lj7nTZp12LDGgRyKgw5jlHgDvGV1odjZuW5yHVHBdHszmdvsiYQh4uJKh1I8zTxOtZ4327HXK1l5S7dt2XRvI8VbzpFP/dc/jMhF2IaOF0Gl6oobZR/8Fb7NRksOoio2qquerciV2SV0iCmf2isVhvNmEP1ZGaK7NsUD7CoG05dMw4BtmnacdIKxrgdz7GD5Z8oP7yug68XiFZp+Si8KqnVtA4g9ySvXwEP4F5G9/8rKI9Eao+gE9Zvr95UbkFzn+ma3tck2czo+be7DY4LHU+N2Jo85CthL6tkw5U2fpbu3YahxZyeSBkhzhb2QaEehrpJksSJOX/MKjr1f8J2o167WBGNYdpcf225U6LqCHQzvuRMf2ikRrad57LbuYSOfxes3mImoK+dZNTcRza/J+gA4snM+rTXrvuttvEuPMPEPmocGhc72Y8Nbvv3PGt9to/dgXw00Bd+stmeNSvkEVegCX8KBGbmYK+TexMBnyajLkDlIZZU4Z
 X4Czs8my
 NNgX95uF+1BirUZYnueyAtUlCSvVRdvBhUlbN6ajIeT/0Pm8jiOR+AGHRvwAoGslUNUPZtl0PrlB/zAkAaJ9v5oimOQT+GFdiF3OE5LguidfelJAnteY3nqHhZKPr+6KMvGOtLDG493KPifFtl5HzLE6wMZY1A4jFrZ8bikKX7rVaYHC/wR59d8KRnKs3ldq6TPQhtj31VN8y7J/OcpVb2nP23synanisegt2DERjSNyT0YsZHGAwmIbwoN42sky85qm3TA+sle/MPdBScRslohmU72AgLloFq/kIzUeRuExW+SKky+9YCZJId1LX39YODvAZhrqZkPc8k4CIvRNZleN/AEkdp2lWvV6RqMbVvgPGN+jEL/GBWofbv5D/ZgSQ3NfTtCvShIpKTkX6KHp37SOWb5zx57b89LYqWlYbYzI3qE3vJDtve85vHredNoUAdQ8Aozk45vDMlHCPnH0IlS/c1iis+3XH/YfrPgPFudzXWBQZ6RYT+A8NFRqReOYqVLsI/8lkdci86QlR7GQt7Jo97CQL+7YHWlFQ7QRAJPU7Km5WfXxpAzWBHmzBdiuLmuuiLGQiErHYUXBH4woAB01XV/JnxRell3W86ZwiexxoLdO68JJD5ajTpmoT0SsWAXrAJrU297jrUS7Jo8UKBnMb3iH9iUkEmdV777LPwuQyW4GzODmLeNqNrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the spanning rebalance is small, fully inline it in
mas_wr_spanning_store().

No functional change.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9bc921d99340a..18d1312523896 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3377,28 +3377,6 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
-{
-
-	struct maple_enode *old_enode;
-	struct maple_copy cp;
-	struct ma_state sib;
-
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	do {
-		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
-		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-		dst_setup(&cp, mas, l_wr_mas->type);
-		cp_data_write(&cp, mas);
-	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
-
-	old_enode = mas->node;
-	mas->node = cp.slot[0];
-	mas_wmb_replace(mas, old_enode, cp.height);
-	mtree_range_walk(mas);
-}
-
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4055,7 +4033,10 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
 	struct ma_state *mas;
+	struct ma_state sib;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(r_mas, NULL, 0, 0);
@@ -4112,7 +4093,18 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
+	cp_leaf_init(&cp, mas, wr_mas, &r_wr_mas);
+	do {
+		spanning_data(&cp, wr_mas, &r_wr_mas, &sib);
+		multi_src_setup(&cp, wr_mas, &r_wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, wr_mas, &r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = cp.slot[0];
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3


