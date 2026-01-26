Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A370D19510
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 18:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C38B6B0005; Mon, 26 Jan 2026 13:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7700E6B0089; Mon, 26 Jan 2026 13:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0746B008A; Mon, 26 Jan 2026 13:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD1A6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:33:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7912D3B3B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:33:01 +0000 (UTC)
X-FDA: 84374961762.03.B1B1ABF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6595540011
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 18:32:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nX9MDz2M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rRpZtRnL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769452378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cGE/zerwk57EWQIPcpSI2c6Hm6SIRP5/7452e8DeCQ=;
	b=v9uKmN7aGxh4+upUHeP5BjEl8zr0dBz+tcV4rvYnLlnCLaIGSUqwmYa43FLL2F4AaCvR6Q
	MDVk0N1aMaoGHasOzeHmTpLW3mMpWVB1PTBfcc+savIEWumWo+7lC1AieCup/S4BLRDN7n
	kbHXxb5KSzI69AQvztl21ZXJTXmoCb0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769452378; a=rsa-sha256;
	cv=pass;
	b=zgPAcowlrMbtlw2xyJqBSW/dS9fzbxxy6ecq5cKtxwFwLyoRhvNjSNZ9eHyr+Om6invPrO
	7lGH29K8bY+BnV6WYwKdvl7as+5KmvzgeueOK4xJRjq5CHbh7Dlr6ESnsyNk3fhielCjyb
	Eoph8lOFKk7vj2JO9SPVlHqY7m09RqA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nX9MDz2M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rRpZtRnL;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QHTtHY1030005;
	Mon, 26 Jan 2026 18:32:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5cGE/zerwk57EWQIPcpSI2c6Hm6SIRP5/7452e8DeCQ=; b=
	nX9MDz2MWpdWGMMT0+hlZgm+DOA+8d20goAS0UjziCLIxBrbvGAtex6TZAAZGGP/
	AMdBIrG9JbAebw/xngMWi+8L0ex5HiX7kSMW2AzqO0oHFI9HQ/iPp0T4wif2EKSX
	FCkjdoF0OIFjx1AHfulbAFu+f4CUtBjLomk3EBdvnh8GqkfnVkVCS0vMyicXuYt3
	bn8y1Jc2nfcRmGk6BLCJFjAHwMau1D44jAwgSV/SNfSmGxmzvTvT7p2e+FRLyebf
	TR6Mw4/n/yhF/rzeFhVkW+2tkUXjMbakjR+8sczajTLg9+jv+BYzsMj53E9ymsyp
	Il02YCfOQm82fOJ3VVtMgg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnpsajc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 18:32:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QHNQgK019784;
	Mon, 26 Jan 2026 18:32:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011017.outbound.protection.outlook.com [40.107.208.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdk737-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 18:32:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dD8dfoa4tzgvdkQDvIk60U9iQXrFz5fLAI/va+WWk40wTryeUri7NXVBruEJunIqa2JKZeVFY9691MM3xambHA9IMNAudY1ALn3YvnRnYhrKWeZ+BtrU6lPa853hrU4waxpaM190L6pGNC9QwTeJc11cxG8nt/90oy0QDomldWsgLuMHKKz/wxjEGpSE6Wq59Gyg3Uf2yzSl8kU1d5sz/OzVZcFA6wjlBVDWIvWmVge1zxxWj7uVK+svCMfb1d/Pmd3EHtngvFuvn6WIscIDONB+u9wOyfUBG4BfhOvorQfULkQ+nEZUWDvJ+50r0wjpIg3LqUDM8SCRMqqrLNnxBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cGE/zerwk57EWQIPcpSI2c6Hm6SIRP5/7452e8DeCQ=;
 b=c3HQ3MEGa/V7JptiTV4MXqRFnzY0Me1EdzAe+YD6jkdOuvRg292Z3O/cgB2ApqrP5uLtG5oNPwiw05TNb6Efn8r65Ulqs+zKqt222szff6ny+23l2s7URJ2icNcP55w42YJAdI3VS0jzFECE2Z9rmUU3cTJI0lVnJJqeTEBIEl4fN5HCcUfYit8zi+2z1SLUKnE7ijgWoFnI5CsSZRGUDfTwZr6EgckPG8gT7TdUZn4zpdFxlZY2xlTGe3Lb9L9nXajkq66SVUXxiFn29m5ITci+68uJktVc2DGgxmUANzSKzMpHgxqNo4c0vsBE5/MNvwAGExffH53OvEEmXGoLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cGE/zerwk57EWQIPcpSI2c6Hm6SIRP5/7452e8DeCQ=;
 b=rRpZtRnLkhwcp/aofxUG2ejD0dO0cL6DVVUpsBNWNfwCh5U3J25mlIHNiZhLl9iuou+sWRISJ9rzn5Mhv0BMsoMyUCMrfRVp6e1cBRG37+XJ6eWZ5AgmeUYFmWeHUbHnEqEMW6++41I/NnvB/Ba48E8q/IBYXgSc7sQpeYs2OpQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Mon, 26 Jan
 2026 18:32:13 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9542.010; Mon, 26 Jan 2026
 18:32:10 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com, kernel test robot <lkp@intel.com>
Subject: [PATCH] mm: folio_zero_user: open code range computation in folio_zero_user()
Date: Mon, 26 Jan 2026 10:32:12 -0800
Message-Id: <20260126183212.2366596-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:303:b4::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB4852:EE_
X-MS-Office365-Filtering-Correlation-Id: 83e49875-49df-4b02-1e09-08de5d0937f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eKthZLfCeHAcXm2q5h+XXrlz+CW88Gi3YQ3bQzIo7UlFqCAi7Z4o3WsL+YR/?=
 =?us-ascii?Q?Far+Rh4CV5WkdkfZxOdPXVi+FXVZ5HyqSIgCrGETdqkQC7c2FixJyCnFA3tT?=
 =?us-ascii?Q?09Yy7wl1V1Wbq1Mx3hUW27IvWUqieqS4CTB7P/OHvaDWwv4ettZ+ubN5oV4u?=
 =?us-ascii?Q?kpDS9ZSQBNMy0UYhMvE989h8xA5RxjuRE10srpUtXqT59YhTVAetDTn/fgv9?=
 =?us-ascii?Q?LgB7uis/yRHjDdqwXMfr/1mp7jxDvoNcyMrJQSrdY/5HPV9DaD367VX40zce?=
 =?us-ascii?Q?6oN+xG2I+HFRiQets6smFHPUA+q1CCZTViicauI9lvGYzrHW8Nz/AdPO3Jw7?=
 =?us-ascii?Q?nvwxONcHFMbkK+c3m17Ft6V48h2gnDBhLnuNWzHfsr11F45hDu8gUCNCxS3M?=
 =?us-ascii?Q?8ZwI/qZP1MHmSbNrd27Jb+lTeYv8ZJ5AhB+GH9DQUiBBfUT3PvWWkwEE9KTp?=
 =?us-ascii?Q?ewfqarYgDwB7934YQDLSC3GevvXzKKsXR3TCQv1Nkxd9TmTmKSXgJMebKHbq?=
 =?us-ascii?Q?y+3ptgto5dFdrEos4EogM/pwrd4uucBqezYHaDbU/c1BXeRCxzA0IREnJJsT?=
 =?us-ascii?Q?SQvHxkI8FpkFv3XiGUaPFvaVIULulR8ShPBQlEBLlNf7F5LHcPvL0ph+ADup?=
 =?us-ascii?Q?i/fGuRomXCw6fB/4sfXootchxbQcmh2ucTuuttX9FM65R3Lle2yyo9Zpe0o/?=
 =?us-ascii?Q?iKrgTPA+71USuiI1zVxa0NtjjbWIhLeIJ26JAoEkc4uaYwzJIFsnFTwpwazZ?=
 =?us-ascii?Q?sZNwTA7Uvk6nHeCni0AiMyPQBUWCKVKihxFrI6+BN/bzMOJd9EC/uUFeeBZy?=
 =?us-ascii?Q?Oi2KPmZcp4R6idfsVjBr0A7w9SRiGvR53/+TbQBDGjwnQ0DBmcdRN11Ig2aL?=
 =?us-ascii?Q?1ZKBJEgbavSIWJ156DgYwxnMxWdQelFqAiUrRKei24K4e6II7XKVsq77CqBR?=
 =?us-ascii?Q?91EuabYsqHhAWjflHMpqZyw36rxbH+bleFNHXAOJuEtSx22eZ05gjT35Ypsn?=
 =?us-ascii?Q?O4sDbeNLUko/panSOb40e21ojUvUVbDTJMuRZzRhlDT+4cvlsvuOK7RJ2ilf?=
 =?us-ascii?Q?Iyhs/183846m9QqOjlP2XaYmCPrV/f0SnDFdLL/M1xZHctopZX9L2vYDD/8O?=
 =?us-ascii?Q?nd2pqb7ATkMnU5gfRrnMd5T0Ori+Lz3smPqmecWrogWEmm/Bfx6xbndICeW2?=
 =?us-ascii?Q?7PEv5dqdrLjA2Tss7GN9V/13IFmUHuD0/rcgw4BiXiSGoXtNNeVdsJhIeKqG?=
 =?us-ascii?Q?UqiV79ff2Yh6Jinr6P4mbd7a1MwBgab3q2zyTnXWyhSDjbRbjzsxI04fQ8jm?=
 =?us-ascii?Q?0ieQf6SxxVhujeQHzolseWEoky1n1leSXreD/WtcYyFTGhIk9C4EMVsWG+X9?=
 =?us-ascii?Q?00my1sbREPqFMmmtYeWqCpcclYB/RTdqhVJIyAvfViJj/XZ/Y/a/fCDshbaD?=
 =?us-ascii?Q?EklS20WHbhL/UuJhbc2kTxW4A8odFEHbLlludn6udxmGAtuIhEoyLQzMI3mw?=
 =?us-ascii?Q?dtPJfbLy+zuk01WS4CJHuSzXCySIAIjNh6OU4Ld0wyHSrDvY10kdzxbs59Us?=
 =?us-ascii?Q?UswPBIveinglTSvSQTU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qq40+hCJcjSD68toeGb050CmdnA4UTWhIGwHcyUotXiY7h6plKTB5X9Hp8uY?=
 =?us-ascii?Q?04Tw0495iY/kRbBhUYZKfrE97WYfdKqJ5jGj/nzXS83mMQctujc1fbcgYJ/0?=
 =?us-ascii?Q?i3Z7HjKBEFanW1QtUh1op5fjla7hyPywkV2MWSeIzZnvKVPDM7YWcU4ot7r6?=
 =?us-ascii?Q?zvOt+OxNFktzoqwLp+dMIwe/Ude1+ZbhLlWUc41aJwm99RXBL8TD+BaE+ES8?=
 =?us-ascii?Q?y/3td1WBsxPYNjIrLgIwSl7UpkdPsXIkc3XNdGnRMRbNMqzlCux2m52jBbDD?=
 =?us-ascii?Q?YlZsHDIf7S6tZ4fd+hPA7nuDF2AKv2Mx/T8lSOhUMa19of5nJ8CY8MTUYSg4?=
 =?us-ascii?Q?vCEUZaqTMiEi2+bkLcIaGbH8OKeBh4OPr3mhmRV3lPE78B06ovHu7et82bYq?=
 =?us-ascii?Q?wEKZYhvrmRWsWUzx7gZvGgUUyHhERU1AWnWEXhAnhxKjWtv6FElx84Ym2sAj?=
 =?us-ascii?Q?+Db8SygBa6rn4Xteq30wkRf9tLbrkbVKEc/S28a55cOMDLcNVcfvpw9YvEIP?=
 =?us-ascii?Q?Tlt/dUq0jMxbO0SOpJtnEhIAH5a4tk7r10QLYsMDbSEKLtFYwpOFGSJ47UzK?=
 =?us-ascii?Q?ypbnVkqv0YNg06vHc434vTT1deIUMrZbJazBeRITSSwZKgBzCW+Z+wVyPqOO?=
 =?us-ascii?Q?eMAHinOvCDGsSa48A5mjDya/c8RtBE/6ZNMgfKTs6gXdt2fwKbml2M2wXFfh?=
 =?us-ascii?Q?+HI9rQEAypbDRtV4TUn67L2CmhjJDQzAjrX+vbHEjv8YCD8ZD4dG4dRQ/V86?=
 =?us-ascii?Q?POAQGQiNIQB/JK+4lvPBkhm1yA8aRHNldoeKLVhH2jvDPmn3A3X+dKHHiINU?=
 =?us-ascii?Q?ywwefYGJcDLPYjvq6ddUMt3GVa5VsEeSfWugM41AjOBEo/fuDrJGYQ/Qj5tl?=
 =?us-ascii?Q?Ntxyz5+Mdvj3BkLy+/U1jlZgyXH47VOskGrQ8bylqy9zntKa+lpQF9lZdBvH?=
 =?us-ascii?Q?/TCpAjIva4jD/9myXSRd2EX3vxIJtncQJkJdvBg298Wx1+73JrOZ4d7B8ILU?=
 =?us-ascii?Q?AcLKIgIsC4bJsBJ9IFZBfzCIsnQFsSuYDUC7rRXu4vVMkR90jp+RbzkQh2N0?=
 =?us-ascii?Q?HtoFApS0gB1Dw4ynYTjTNe5p86FnCiie90plZkV5JFIlaJTm1mTZsTbjGp4j?=
 =?us-ascii?Q?bI3wanrX+R4gl2DM4B0Uov963dA5Fs2YBPr6BSKJhnUPrWZ0uLKZm7GQChmc?=
 =?us-ascii?Q?ayJhIWSWuoO4yGqjOOsA93unidIshuILup9evGBf5lRVp5HMvAjzyzPg8uOS?=
 =?us-ascii?Q?flPtlg+nXf/8D0UDiY0x5YdbvmGNZKGo/H1f8e+nWRv1X1gFlCImPfYzvbkx?=
 =?us-ascii?Q?yweiWkBibqdJtMedCku+fl9+RlX5GV4kyL562FTAchs53oKfAZoO2tbjTdoU?=
 =?us-ascii?Q?OL0j4IxOjXov7sX9c9NPS8jlX8cED8dhZ6nRWUNUuddEXaAmTauwb/GYt/o1?=
 =?us-ascii?Q?6h1mEjjFQ3/qs3CSzeh9/E9TfW0wMvM8FCelkbNar3fc6RZUfbpkeZRHpYI4?=
 =?us-ascii?Q?Nnvh19CZ2tgpRFT1fTZFnFBjnjsuOVoNL4q5R9YcuFifWiJzMHTsNeXQ9r/G?=
 =?us-ascii?Q?OF6vO043+rVqgPOR0jn3wc/QwQ4JP8NIGKQkNNpRUqbDRQTB27F0IJPJ1qTG?=
 =?us-ascii?Q?nhbjt+Mk+BlMj2Fl4NayvMGPvnBi0rfvLNsoLFVz49g6fejR/hoFcUc1opTy?=
 =?us-ascii?Q?XO3apVHPxeUoNBmcHpsWjuB2ezAVEupvsT5b1eDRic+BAzwAn1g7tb0+P0hF?=
 =?us-ascii?Q?Wtude7njyfXc9ckwDtIJSeI/at9gpfQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ryYDLqQkiJYhzVkH4e47tRGasv4abKIa9V7rtYR484Q2Psm1BLKmflYVR1V4pF61Zj2alIJ+bqppk5Dd/X4hsGgh8cclFDh5dda7x+YDTYM0vQWToytU7xR80sDkJP1BrfF16B9rK0HefvhsnfL8A1+xZG/4ieNrdWN3EjbK++nF+5Lx5P1kyqKFEKryQbdwwpKRPdjvqprfm2Ec3Eyl5dwWfGWD3VRilZ7hVR+F2J2wVwIEh9ceqnopHa1ynFguxSNsMQH8zdqGtIzBYwlUQj7tPIa0HLJbHlvGLEyFXP6EDTVnAuK0chyHtvF6HjhKAzHSEMr/9lRUELXz+N89gf2yG4m4Eqw54I6RFoAHz54Vmh2M7KRcxPWmtEa2v0yUFAtErNxOyu0/5mhgUv4TErVDE5vpFbzqQ79oWrting7hPnIbWEXvYfVg34j7SewiOrw7zjeMUXs81KYslwH1uywpQnwwyibnwcVkavDcDsKuxr8FPSB2f3NnADxSN2MkVqWZqJ6TOHPy8Ai+xuIDetjoWzXAk+uheh/1i23jQx5+qdRefLtoCPMT6i/ayLuuS9veOg8J1M9QvSfh9i9WyMCtohfm9Vbwc1YxyCg71U0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e49875-49df-4b02-1e09-08de5d0937f2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 18:32:10.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iH6tmzQVwXIN8kC59jfforc46zSQoFrAhPtXpBAXzEMdGaXXFrroJWAhBKDRr1Tg3cVlIdMmDkV+iSwj3Smov4dgqc/IbhnjeGJiXvDmS60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_04,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260158
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=6977b334 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=UPAns4q9ObfJLkRcdUAA:9 cc=ntf awl=host:12103
X-Proofpoint-GUID: v7kWxC88QUgyWpGi6ym8-B9V4fobBuiu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDE1OCBTYWx0ZWRfX8YpoNIZ4zfz2
 vZPHTChGtl+dqoH64d4c/sg/z9FOohj15i1fBYi7AOVxAeJ4zekIYjzKbnw3JBjy35UeSW8zsUE
 rMdVouz1DgwqMViq+JkeQg5ONR8OSMmGFGqn665XWLOb1Axu6oA3APdj7SpSUlolshsD+X8dlrv
 aLRr08dIcprCsKhrsjmLUJ52Z+iw2L0tBpNjTj/WKOVMU8XAMY/ey+9u1gF7+USSQVjIKTbr57s
 hSZDL4tjXkXzE8xldHh9LPKnwUvDCQzaKJ9kRpcK12C5Ozo8FVKWMxE+bjAo8h/s2QWObAhT1rD
 xEqxks81fptnKQDDh4W/P5C5tbEeSXGW+yqNhmeq6Kqog+ERy9J6bRoUIQy7sT66lSTwZxIjdeO
 ORPKB5dfxFVLV5KNej9FT1ChLT5imcurlh3u9GYG+srebJjeJd8iR9gg5V5m7AZqL8Stb4HM50k
 4kkBtrhI68woXTw9VG8sldFJCT+OoExy5uFPepwM=
X-Proofpoint-ORIG-GUID: v7kWxC88QUgyWpGi6ym8-B9V4fobBuiu
X-Rspamd-Queue-Id: 6595540011
X-Stat-Signature: 1kbbhqbj9bmsyosugajhwjp4nxnqr4kz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769452378-319565
X-HE-Meta: U2FsdGVkX19B4OYvwK7pe/02xP4iT6SGoVqElfF+xVfy9WtnNImFX0snddWGgScmRfoO8ZfurXdmcbkfdq/lOUY8uN0ZFxKLExVKcJDFYcQ46M/K79decPWTXyD7mYXko82A4N5UDpqOpbQhD6493A0X1Ko67dU2vwoXgXTii64SAqZYol7iKkjhcLg7kELyXJUJfb7f06NgeGFNmwV2PmNOhEDhYseNlq4CoIHuEbdabalew/DlH1FmM3asuDbgxRs46rvoHVzXBG0FTR8UYtGRPYJ3y/8AvalCGZklyxrdU6jIrQcgMDkyyKuWx61SKY3QgjNj161VUil6BGZOx3IrR64Un91aQ5ady9yDQANKQXZ+3GQGHth8zT7vBfxxgTQEtr+agFkvfhnFRHHcinEvWmotn6KZR815dafB9t+50pZlSGJypd7ab8vktRQca2m2SB1aI4XWQ3QpQt7lpVD4kTsSlAvduATbQkliZwAABGL/ErR8hbMaMzgU9GytoWUdf1eA1FEgrTeiSBBXpSmMwdAaQpL99cpMQf8dQ1sDgT2/8XRpERlOR9I6zL/OVZIC7vApg9eP8a68DnLvY0pYSIS5w4Ee5H53p7ZFS3+FUxe/XwNvIZWPAJXEgCWQgMuVO1/CmTPdVxJgZJz+YEzDpeeiGPPLZxbOWSC8YCMc/iUiisg/3Bvr5xdZQmOIZ2TPWQShoz4VNYwgF+PZJboXXW/nrsjkHJFi0Zm6nXgYKIIJ+9LkAynQ5T3x8MdfWwAASnmMhdpGnU0iX5F5kcUEybewN5pAfOv/2GXzIpPg85sv5buxwFa12GPLWzwFhIN3BdPxmz70PyZ/rOUN4l/C9RhC0Gq9wxkkDfh+oRaDGzzWgchE2d82wRP0dJzdrT9ngXNNetUwYM9mTK+jUd1goUFDXAGxey7o1PBp5ziV2R9TuZgDpfLz/N2ZXEh22jnB0YxkF+b7K17fLCG
 Q0kyn1Yo
 FQSKidr7fUX5f+qbMUd6rqKIarvnvcveZaed3vVUyI9LzR3v457ool/T0u8olyHWwg8njRVTeJknWAy3Keb2lysBkWfD9LtG0Ll9Pf4ZJfYI+tZpfYJ206Wp0tqm0gfmJNkckSmR1IvH+wd5quMawsI6mgv+KTQfYx5AUGZjPW8zLb7ZzzPtfWDzVV2HNT6QsdQSdTQUJN08q9d//rHTB4KgmwxNhDSFVWpuR+egJQAxzAtHqyAqyyo94d9BAmTwgEIXlAUJnKi9/0FDvL05PKrWYY/8w2h9keN3OseQuvbVsL1w9F2RqvlmIkSolLyaZg9RFQAQK0Afr+KOP7HodYLkJzvHDUG+9IktIbuoQpccvzqj8dISoQgHSlW6lQJqDFPKenFAKk33rR539+pGrK4Mrjp3FTem/z+//RDhAhGshwmJbM9u4trsmDYWutBc3tqRyTmSiLJUXFzTswdOT87/P8r77h+ExKd9Tqr3YMmniVOlevMEfkFHIrbxhUAFP0pFiseTNh5FWKJhonosbfPPyPVD/z7DPKnmB5NoIoW4Jc7W0Q9m0uKDfSKzALasNMHANhz6fpBF0et0OrQ0WMJiMKS9vl6Lr/nH2THN2Bb/Ld/tN0TK9/7E/NbXiCDHioAVDuzRVJO52cfkWksVWYy5Zv+m8obblM0rXG5tgQUFsDVLv8kqXlnt86dm8/xiAInCRADxW8xOTNyRBRMs51oed76M4nSx/Xu2Z276U0p2cEyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:

   r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
 		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where it decides that pg.start > pg.end in:
  clamp_t(s64, fault_idx + radius, pg.start, pg.end));

where pg comes from:
  const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);

That does not seem like it could be true. Even for pg.start == pg.end,
we would need folio_test_large() to evaluate to false at compile time:

  static inline unsigned long folio_nr_pages(const struct folio *folio)
  {
	if (!folio_test_large(folio))
		return 1;
	return folio_large_nr_pages(folio);
  }

Workaround by open coding the range computation. Also, simplify the type
declarations for the relevant variables.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Hi Andrew

I'm not certain about linux-next rebasing protocol, but I'm guessing
this patch will be squashed in patch-8 ("mm: folio_zero_user: cache
neighbouring pages").

The commit message doesn't contain anything needing preserving if it is.

Thanks
Ankur

 mm/memory.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ce933ee4a3dd..e49340f51fa9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7282,30 +7282,29 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	const unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
 	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
-	const int radius = FOLIO_ZERO_LOCALITY_RADIUS;
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const long radius = FOLIO_ZERO_LOCALITY_RADIUS;
 	struct range r[3];
 	int i;
 
 	/*
-	 * Faulting page and its immediate neighbourhood. Will be cleared at the
-	 * end to keep its cachelines hot.
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * keep its cachelines hot.
 	 */
-	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
-			    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
+	r[2] = DEFINE_RANGE(fault_idx - radius < (long)pg.start ? pg.start : fault_idx - radius,
+			    fault_idx + radius > (long)pg.end   ? pg.end   : fault_idx + radius);
 
-	/* Region to the left of the fault */
-	r[1] = DEFINE_RANGE(pg.start,
-			    clamp_t(s64, r[2].start - 1, pg.start - 1, r[2].start));
+
+	/* Region to the left of the fault. */
+	r[1] = DEFINE_RANGE(pg.start, r[2].start - 1);
 
 	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
-	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end + 1, r[2].end, pg.end + 1),
-			    pg.end);
+	r[0] = DEFINE_RANGE(r[2].end + 1, pg.end);
 
 	for (i = 0; i < ARRAY_SIZE(r); i++) {
 		const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
-		const unsigned int nr_pages = range_len(&r[i]);
+		const long nr_pages = (long)range_len(&r[i]);
 		struct page *page = folio_page(folio, r[i].start);
 
 		if (nr_pages > 0)
-- 
2.31.1


