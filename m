Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60903D6555F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A077B6B008C; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991306B0092; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828026B0093; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 718706B008C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ABAB6079F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:37 +0000 (UTC)
X-FDA: 84228888954.12.CD9D09F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id E232D4000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ti84PXYm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MbbmhJoR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974454; a=rsa-sha256;
	cv=pass;
	b=Msz12BzNa/05ApEo+sh78WrdquL8xN7awli0XdNo63UvndMU+/KDDmKIWyvHfM+ZjBiP8E
	7UbgGRhlliueOrAX6d6BcWRI+6HDoDVwBWH0MZEUQs6cvdy3NVZkuNsI1WfFv4p6dqol+h
	m+biChEWM/nmz1SIUMZJXKfyj9dOj1I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ti84PXYm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MbbmhJoR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rdwzbw1AZYhkqTBEqmNuIC5pJ/BKBUkdJDAB9joqWyY=;
	b=LGu/kfr7WBKR2UhGYu9TGMYLene7s+Ut3U9RpzhXdEC6ija5GBlXdnVkQ5tzUMvaPox5/g
	E6DPUaz1qhobD7JrLGKmS0riD/I6CzyUefTBu2YGtmbMINnUuhriafmOzUtUrlMTF4FR2V
	ZAhdIHIZFyDmbZykm6G2mvZr3F7xd3A=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Ncb22068664;
	Wed, 17 Dec 2025 12:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Rdwzbw1AZYhkqTBEqmNuIC5pJ/BKBUkdJDAB9joqWyY=; b=
	Ti84PXYmKRzGgcfbf5ABMjVDsF2FbWd4F4/3Rx15gEP2b+hXIwaFi647TnGGXScU
	mFjujhj9MoO7ImZEOPRJziTf/xMww8bQaOgR7OtBtJb/PayI5L4vA6+N1KdLBNlJ
	yc7+1GJfR27XoqRrjbK0vRtWJ+x2MxS5xJzQ5a13rCpiJO91LfMapOVtzCb3I8xI
	oedYbbPHGaUGUTjqqcI6h8UVAoerH6M6NELtFW5bRyekKNuyoSs0YAK4t792HCeO
	CFwnZzNNGv+RIrfMmfxsFaEfg1RiS2/CUEkoRhGW+foz7l9dsx/qhlj8jTSjfYfc
	Z5Spei1WDmCW8v+WMq/tug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prnqu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBW3w0006177;
	Wed, 17 Dec 2025 12:27:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkegbtm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HrrnUMtFK7QSDY9FAPhDSDzml2AYfIqZrQ0lqkUMOLrPx9KaoTKwBeh5zu7hang8U4voW0/Ni7D2Q/lvKoGN1EBbSnn/Xn2TCk1/75HbksDMZtFSrrqCfziwrTUJCfCPiU8SRTBf1pDukGweYsu/AzXf5AE3xuerR/sP4ytCeaJx83AjX/DG22RF8croGZ8tVpPqNv5QhBEreHuCxsyqHuTwLKeRB7gSYPppG8kwTcoNcpl0BN9d8TFMBVK9xMBOQtC/hXKBi7/ELLAKVHv/YSnYe1bJ5OHvb7pOPTS93RySqcq4w2tEhxSLoGSdXwUomJtLTeAyPPzvQQgqFi5dNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rdwzbw1AZYhkqTBEqmNuIC5pJ/BKBUkdJDAB9joqWyY=;
 b=QQYsEJljzgDLOyTIFh7n+7aOEd/msfc183HJC7D1sEROnlGl2EaCaxdLwmawaYwKFEPoUZndxzfOlhbXonrKSynf2q2eDBXdSIFdPZdPHewVzPq/h5hZ4wQTdg2/Mbdrboz+5jHbTjiIl/H2n/Lp2c/SByQI5Xod4+UutkGeC/qI5K3x/oEUc0a8cggh/dAb5jHwz7ov1E0fT9l9gNbiUJL4iFZbiCfFyg/k1LX6qPQL61KD7VPOUDXV5CHkj6BsWSukIZr0mypvLnMbeqdV5/4tKslk7tVEKewkOJypUMx44QGJW/9vETheSAMdiBNhGHs03AHr+tIp59YQpfLHnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rdwzbw1AZYhkqTBEqmNuIC5pJ/BKBUkdJDAB9joqWyY=;
 b=MbbmhJoRkCJ7BBhBC30EgufX/6Zbos/gGmSUCaaMQJF6yXpKBtfhmNDV2k3Z6eLrxwgZ72BtTrvhvvnFiqGrwOfP7nCmoYJg17BxXi9LRlaQ7KKlCPXfVeQQgJ949fOMd8LpBghaYC/4EpinMZL/QTHYBg2jsIOYL0VDyr14Ccg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] mm/rmap: remove anon_vma_merge() function
Date: Wed, 17 Dec 2025 12:27:06 +0000
Message-ID: <ea57e3ee7b4d2d40cb7f77703baf0c3ef34bc304.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0013.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: 435e0e04-0351-4d24-ea4c-08de3d67a2dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RBbXSTV/ELmzH8GJcgNMKFSRuHv/yvYXFX49lJRzqy25z0Voo6Q/d8ipXcad?=
 =?us-ascii?Q?e0rcNZ9WE0aTYFhagdewN6rKLcs6pZCHNezLm7vXPusJTRlTJ3NBDCq6M1NW?=
 =?us-ascii?Q?Y2lS7bBb2Yw1+a1C7EVleRnu8NPBSaPwkpr3WgqYFWAI9+JXPUZPvADXi7Sc?=
 =?us-ascii?Q?qY6QqixjOkH36F2T+WPp7k6wvQ5deev8Qzb7aAVGdJTc6aG4MB4MC2vy9oeu?=
 =?us-ascii?Q?ZJbgk5IUZHlPzMFC3HLh8avVTmGAgTBzv6PogHLsfZU/WokA8mHzegfq0kL0?=
 =?us-ascii?Q?lfNuAZaGdzs74JI94UTWZziEF7/2lD900KLHAfJ4Z0RM62MKMtVAdAy5+9Eh?=
 =?us-ascii?Q?8mbA4K0WQlBnbdd2+mXKq7+PApyZ0BGw1FMsA2SATZ9TxTeRt9caPZd7Uvm8?=
 =?us-ascii?Q?xsEUlzmo3iaycE4n4Ku2s+/KWiZAvlm4Qh/VfQHQcAx9wh7jscC8lJCExF4u?=
 =?us-ascii?Q?H4KbIwopRECv2RdVr54qiQUQXVMWwwaR8rlwleWnZ+epzMiK1cOimrjpH3OO?=
 =?us-ascii?Q?x3uEbOzig2gD5nMlhTFVUhPyDJpDarKw0oSg0HE6y+wI4D76ODzYjPEUCTEj?=
 =?us-ascii?Q?PnCUWCTnI4DyvHYHvJN9j/ugAv61RFDh2hDoYCvayTb4Tg7WRiqjuHg7HWLe?=
 =?us-ascii?Q?QNW9XFMC6MMloec4nIB5oEozYJhYV6bdWqmU3XQWlVw3wYlvf/6FhuCVE1Fi?=
 =?us-ascii?Q?b5zdigkzIAo2VfEgkyCf67KSe+qH2aKHrgCNWZMME5eQ4KLTYZ20XJY1SIJD?=
 =?us-ascii?Q?Bl7O4VEqd7tXBp8K/KYfKcRxNDOaxMmSBIGy0cH8jxJTGxUNnSXoGGvyL1uN?=
 =?us-ascii?Q?AWWKDsmV86WbbykEV3B9hHGBqOnV3USzpJhB96RizHaTcd4oWYwW/9zPgfWe?=
 =?us-ascii?Q?JJhfwJipRbulluvJhaJmVBVKt6na5jEfqwQo4MFxTr7/8zA4L0YrNfjR7ZRh?=
 =?us-ascii?Q?eNLBDZjj4Udh7W+mvIzEGgI1JgYTrZDfpya1pMefqFR8zMOakJEDs+CfjiyG?=
 =?us-ascii?Q?Mq5w9tfFNQiWj5i9bVPYvdd030o9ilgUwwmK+G7lUnfi3y2HB9OOJez44bWO?=
 =?us-ascii?Q?zf5sh0I30t5fH4FARIAhU0fqWwLpGcqeiEpZLrEj+jRKfla5KzNBWHHymAal?=
 =?us-ascii?Q?u8hYiqr4CJCMV1kMgrWxO16TWbVFxZeb/g/8oC0rmw2o/ff+OpkO5WYNo+ps?=
 =?us-ascii?Q?+4HB7nq2bbcc7WrB1aEToWzP/xyhdxMSNbG9cJJD/U3NLeIGjkEKMWE4QlvV?=
 =?us-ascii?Q?Qw0Bj3LTPct5u8hO/5qEROasE23BpBmavHXTJuhB8FX3N9GhV2nCgP8x7NWK?=
 =?us-ascii?Q?cGjumhUM7iGPg9tHFDIK76UqhbavsM/NzR5+ig2XULlYM+2X2TM/doAIvQrC?=
 =?us-ascii?Q?+WPyh5zY7xmEhm1jdi7+NJ6Bh99CGvWttktgORuGWtCg8RUDnBk8F/GgJcmM?=
 =?us-ascii?Q?GPoe2zUWDt7ov1o4xNtgRVdS0bCrNkiD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rOprAMkhdfNtNYDBMtjt+ebs6hIj41vOaxoYpjLRbv6KQhqsJlyd2Hjr4SrO?=
 =?us-ascii?Q?xqTlkZRlSYw02XS5QO3xgee6GQvsM1MsGSYmYVdEb1GoK3U1blAjDoznxwmd?=
 =?us-ascii?Q?gRx9bC3i8smuiukZUzXHwpySzU8Zldc3Ob7Un/fOprBpvbwLmXtHxAzqNtZF?=
 =?us-ascii?Q?Rfn81Q/Z+/5BU9aOb7vHGgHOKJFzGlcptAlzOQ80HzCKqNw3aWkST+zZ1pRq?=
 =?us-ascii?Q?MROD8K8tbg4bt5Kb7gMx0wpHSaIEMQomEmcoHeom2vpaRYOfMPMfq3JDPCP2?=
 =?us-ascii?Q?DXSanAqSHoIXP/ZwKupW2Aqe6z3hPjWTRGB5wQej6qVU0I6P8isLNXXT6gFd?=
 =?us-ascii?Q?hOoWu1hFSogiWgAdSnk2C9EQQ3C+PAks/px6r1t2el1byrARpyNiHDbTQt+u?=
 =?us-ascii?Q?9mBAlQNfy3X+kitH6UGz1Gbiufy0boP5zO41LpT4fRDDPB6e/TtPjYKKGK7P?=
 =?us-ascii?Q?mYKdGj36ob0533TTqUw67Gj3ZbxoEo+v+Lcfh7nlmpEbbLERWvAi7jHzWMlz?=
 =?us-ascii?Q?633ZZZhIq9/o3nMRVhbgftWqFBljwxZANJbHF1OK5oVQ+veuBSanSppFjPk3?=
 =?us-ascii?Q?4G86AnfhIVRgrOoQtlGTJw+XroN4RU2PwdVTnMfvfFVAOGd+XVwyA0XCp/Vu?=
 =?us-ascii?Q?TyhxxcqccU1ocs8wFCOcdCVyftxQGMSuuBB9TfjoQdh4gPW+eClkNNh223ff?=
 =?us-ascii?Q?hi3pfG+NsxEqz7+sUc3eZe+vy403m4E8tEsoz5jrPT4Mcu6ZfKBWqe+oKV4P?=
 =?us-ascii?Q?yrFu1gEPfBfTju8SO+Msof/W41MmOS8uy95RwOfgrEOlpkMVRbp0B8+o8WrN?=
 =?us-ascii?Q?Om1kL5J6JvUGcFn9FqWrvl0dRNfUw1b8tGVDt5Dj896eFSAaFQq662ZMV2MW?=
 =?us-ascii?Q?s+urY8TK+nJyYSvzRFQLXFOV4xeOCCA0zpfC9VYJFwTGpBHsKAztUljwLInq?=
 =?us-ascii?Q?7af5/TdWEYaZ1Vy4C40IzHwutmTaRDfeOn8sDc/FkDiCAHqvn+qeSNi7hte0?=
 =?us-ascii?Q?lKsoqsIOg3ewIbCwVz1iVDPAEFVQOUMWYz4BzJ5zvzWtimrzxvhKE7DlWlut?=
 =?us-ascii?Q?ZLy2EiM0ck8y2ypsPRZQBiGFsG8dyTib1uUZx0yXMgQuS/9fGPusvqP63gV/?=
 =?us-ascii?Q?EVZkrDxKWUF/W/b0CyHW8ncV4gXcpTWODmOs95YquBvyxbeulLFaC4TUVG0U?=
 =?us-ascii?Q?aExGbYJDCxm8CKHRaHbA+V2fKYABr3rAK35dfQH5SKzf+hTNH5q15mi18EWM?=
 =?us-ascii?Q?4Yjo4WTm0CwQKVbvI2EyMbMgs5Azrp29kojSLiu67Jb094RhOaTxVRQkiiUd?=
 =?us-ascii?Q?0BUNkrZUfjtUe4l+WFgk8dBCCzA8C0NDVwmOYuVx5xnWLbzUO3WypYztYwJn?=
 =?us-ascii?Q?TY8Qje9JiSCc/ApNO729WKbFsf60GOAfzjA8MtDJwVr/bX0Mez5CMpLb+/ss?=
 =?us-ascii?Q?x5CJe2noUDhq+o7Sck/wZBkGhaULf7vHlesW2m0/yac5SMEMVSzjZQmgumCw?=
 =?us-ascii?Q?nA7/nj5KAUXLZMBJ4e3g4xZk/HijpI6Y/UcBq+c+J05UPSIMtmC71InC04NA?=
 =?us-ascii?Q?vrePiB/oUaiB7T6K12KdAAYmoMaZwEJQRtYKnL65q1hZD8VxB0KUXUCRs9x8?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2gHpMVIPG6nyBiQSethEVq1L5AAAUTdtY9xuegT9FeNz04QlSK11b9TE2484ojBwN0xkCuDlm/cZSYYDwatgVgrEjCA+L89dATKEdhdjlY1KsDYHY1RH/xgDoXOc6JO1NDPsneI6HlQnfmcX2nSQKk3V6xi4RWVz5uNa2+4UTzgahu09GbPxN3QQZr5em/5U/HGUN08Hsyla0/0d7fwKr1EWTgCTBvBo9maHJf3hjZgasgr9fRp4WDuKJyV/yIomPJTQJgCg4qMUqIPmvxHtR279zqehZgqKsiP4Y/IKBqxNBEU5GRv8w2bnlv7wieidJAOI7xaezYx4479IskdwyCDaLJNC1nS24ivpze3EkrEOx4zkjZy9/hxSImnZCj8/SCv8kCxBiUPW+rukUjSjOiI4m17HucJwVuq0WiBfEF/aVPD7q75MBPRSh96uVwB4fFCGZzjiLDlYN8ISahflz3VPb6ZbDjl9d8uvvQBmj19777dWLQHfUXZwLGw6niXRf8Il1mqY+Y2ehrFnDX6JtoLXBGPnDoqqHbKVy7WHsZW0rTfdZlqGQsFEJ2Ipg712Rh649b+ffptxQ3yWWGntKxlYTWUrnVYGWkaJZtHDzWY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435e0e04-0351-4d24-ea4c-08de3d67a2dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:25.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36OAYo9TX2KeLnuKDDhgwyfc1cu3mNB/FSvJawhhtwKzLUNhqJXhng3zvO3Dw/7QubjcuiXYMgBM8E4TF0xRZicqaRxkocKbK4XbyMjqVPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX74IUpSkZfSxR
 MsQ8rxf5wHAi3OkKTxZfZoIcuxiVsH6WkB/shVuLe0ShYQWaLX6P3MOdDt8YLjayf1d1tgS2uH8
 mqxo2C7mB/ziWHUUw9bEhTPLGEQcetPq9GCAKEBCGITdlGMzIpav7LCVjmCd2ijDdzBPmsLzRr4
 SLTkUlwz9/h0OT7Pt4eWggEHlY7sKq7gt9sd6/cOBRof6M9uzHBVc4zsbmk5g1/rVdw2dWD/+Cd
 uLsrRP7f3ajxM7aZPIogKsyNg5hbG+/N/LfQ6v4Uivmx6fOpTKhuUFDX/wdMWE4egE9D+B44IGW
 1FuVt6ec844AE7h2CXQLYBXAw2wklpYp4QLO/R9ygrsBiFBGDwAkgJ06V94dq7Sf0N4oYpEz6f2
 vmGwRO9cMhYBubhpa2zPW2P51iNDSfs8pMnQg44kmDwFlGhY9pc=
X-Proofpoint-GUID: GvbZYmmgz1U4zaWj8fViLhhm_PjN5qEO
X-Proofpoint-ORIG-GUID: GvbZYmmgz1U4zaWj8fViLhhm_PjN5qEO
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=6942a1b1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=yDX0O4jjIrK4UegQ5t0A:9 cc=ntf awl=host:12109
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E232D4000D
X-Stat-Signature: 1hq44jrhj1br8tw9mnjxpde3a3f33ime
X-Rspam-User: 
X-HE-Tag: 1765974453-449462
X-HE-Meta: U2FsdGVkX1+rthb6nGesPVltcPEpp7es0Wyh4qlCT9Fkr17GoXtVOfG8HNlPdGWjWyd7uDb1IONmXxUyou+z0KL5684n9j6tyyp96mJW7IbNvKQy13+RWrkVOwDH/ZL/F3H7muTkGTaioFzUghXoMM0lP++OUyTRK1syiL4zOl1Nfd0I7RG0JjYIBqVsPacoAs5Nd8mlB/dNJl1hBhiT34zNbNJ/w9mNUerA89R8LZEcRTFwAqPi1S4y80mloMuaeagySY28jN0KZafb46XwG2RimfDbZs0o0l76InampJkx7rso4AumxB9E5fnh0LsCPvcHwl62VRIV1ExGzDRh6atJZvexpVlvlXqBA7CVCitADvFlv9y0DSpb6GHufqFsyh1lX3JFMmIwGlq9HII7L8dUnSZ5XrRn87nFDBXhxDFezbUs3Dk3FiE11hSMMI2HZQUrb5uE86Z6K5f0CR7FaBk+0QZIkmplVDHiBN7w4RORyQWvTL0COs6o9f6YxcdQXf/mSxoOYkeb/ASYo2EOZF5Im4rgyN2swGE5zmg8ExZmufMa9V929NKX079kQw1N5KOQCY/9znuw1QZkXjltXq9mm2um8qG+/LRmabwp5QTw09vSs5U9FaYPAT0UpgrvfztxekkCFmgMZEL265FZntZPt2xSM5RHtE9fI+35rwcNV9eS0uOvsw/DvrA5QRj67pk72nOacERfqymn5spvqpBC7B9Ln82PfrrpeNduINTw/4oEJBIwSf743FAa6ljV+DBHtsujfkK4Kiv/XJsj4TeDodfgn9p6NUcW2V3ztnts1Mn5XDO5fggMX+H32FqLkmlGjiz/mGednodXdOCNd9+mYJ8v6/iUjGkRp2LoUBp3sFWBOkzBrMH5igdbxgYnGBa6ZQC0l/v/Qi8wUcaHLS5y4Ca4ViwMzGiRBT+2Y0dA2xy29GhY2IkwH2UeS1KjggWTUxcWIxtQZAReiOh
 qPBe7Ybk
 NssDYs0hHVT9ROEwH0bQ/Nd0T44MOt596AnqbbqtJNcLI/Ri2N70ua8ZmZcTUtCR3rnMeysUU1E6oimhSLyvkML+84QxZShdmn93dv9Hl3FripyqnLy/YJuojYwGdUe3PNye/Js6H3U4zvqCt24MSTADwRMcSo2OAN+BBupJKFAAlQco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is confusing, we already have the concept of anon_vma merge
to adjacent VMA's anon_vma's to increase probability of anon_vma
compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
as well as anon_vma reuse, along side the usual VMA merge logic.

We can remove the anon_vma check as it is redundant - a merge would not
have been permitted with removal if the anon_vma's were not the same (and
in the case of an unfaulted/faulted merge, we would have already set the
unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).

Avoid overloading this term when we're very simply unlinking anon_vma state
from a removed VMA upon merge.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/rmap.h             | 7 -------
 mm/vma.c                         | 2 +-
 tools/testing/vma/vma_internal.h | 5 -----
 3 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..832bfc0ccfc6 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }

-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
-	unlink_anon_vmas(next);
-}
-
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);

 #ifdef CONFIG_MM_ID
diff --git a/mm/vma.c b/mm/vma.c
index fc90befd162f..feb4bbd3b259 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -376,7 +376,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			fput(vp->file);
 		}
 		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
+			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 9f0a9f5ed0fe..93e5792306d9 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(struct address_space *mapping)
 {
 }

-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-}
-
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
--
2.52.0

