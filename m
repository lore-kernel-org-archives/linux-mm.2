Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91A6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 05:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC5DB8E0003; Tue, 21 Oct 2025 01:10:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B76358E0002; Tue, 21 Oct 2025 01:10:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DF98E0003; Tue, 21 Oct 2025 01:10:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE9F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:10:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1AF01A03B4
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:10:04 +0000 (UTC)
X-FDA: 84020944728.02.1F7EBAB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7F1C140004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:10:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l5d5BxFj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EJGiFt9T;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761023401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIBN/q6kyvAKgqC4zo6MXv0OAoVWi3jV6Xisb36HQfE=;
	b=jaEam3sAp3/Bj0wWAOm4SpxYyW0di3QTWqYo7uUA4IIz8ricxOMsPzd8ChaEj6SH7G7yTd
	M6F7YsUrs/1seLnHoF9KmPFoSS10wQdvvMGk3LHjxyl/ipKauvJurzZw5v6UvYj196Ui2C
	mYsO8C4cZKYlt2xA7Bm2udkKllPd+IU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l5d5BxFj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EJGiFt9T;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761023401; a=rsa-sha256;
	cv=pass;
	b=7AwToS1Xd3mLl23W+Bqb5DCOs2oPutLe7g/TFpWRekvOpKbE2L/RVILMsxsLlYOnhqN357
	eF1X1TZ9Kk5xn2T/oYm+3j6Q8R3isGuFzGfGVvJKVKX8LrbQi8P/ZX9DEwPF2c394a99Bb
	LlKz60CLVGB28xodXZcN/PlowZGnv6g=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59KJupBm029393;
	Tue, 21 Oct 2025 05:09:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=pIBN/q6kyvAKgqC4zo
	6MXv0OAoVWi3jV6Xisb36HQfE=; b=l5d5BxFjhOvGf0gU69QF6qWTgb8kbEYxAK
	Wtm+x6wJEGDVhHMS/cbwR8N3+tN026EpVDBl9T+SArFGgqugl7oiA2DeYm+4YrPm
	E95ZNTljSVoao7e8T4Ktsit0BAw9HAesDn2XhM0JFfKI12pAYGS7Je0m7+3pyPYO
	zYgCSsWlV2WGunWBEDVC19u2ZAI+Td/w4EhFUPIuzQwWwGuCctjTss2joi4BOsYa
	QC4qJRrD9prLXpogij+D2OG2GGWo3VYBV5OP26D5pxf4memsQM+WeDHm6P627nHY
	72dP0MQ9CNtotpNR66BXaTuYJOaUEJSArB4vvvAQc/d6HwRvhdIA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d3w1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 05:09:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L4BETm013110;
	Tue, 21 Oct 2025 05:09:56 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010015.outbound.protection.outlook.com [52.101.56.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbf61t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 05:09:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U9ABnYx0Yciw95lbx3/vu9QIFeJ0wM7yPKkyTFa28zizgnQU6AuBr2U/N2KhfJOs4P7Zd9HP1srCIhQJEYhusjW80qYuuc5q6L0CqvkeJUfkGfuIABE5Bl2+drzd8DfpFeJbYLHD0GrOO7F0xg6e9/JHm+4Pe3bq4isG4CmocjHoOfutaOLfQki9P3l3ZS+KW+baQvt1uzpmaOhy/o+dAV4zqb34/KzIqutU7ECbwvX1D0hsw6OrlKsKVl4k/tBGh4KEL1jZ9y7TmrrcX+extqmR2S59QTWg9jOns/G59SYJRSHVTjmJM0ttUtH+DVDAVvTSAIaIlVcDjQsRdGs5NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pIBN/q6kyvAKgqC4zo6MXv0OAoVWi3jV6Xisb36HQfE=;
 b=X/u+dX2vSY3J6SkGvFZWMI9jONRMu6w6BIDvb8+m6J32OSCW9IvCBhpmIT4xo9hjw3NsqRajkpfuZ8dxJrmVCkn8r9ziMVRlcHOFKPkv/ukC3CrZLewihdjDujygLabcG3ejpjjm8E7ASg9cbzCZT6zPE/a6oBsEIT2lNoMkfeSp83nNvPQaKh8PmmxaW2fcIBP8e9EXE9PI3WPM9Eo9UDteXwTn4cPoaOvCjrN9kYm/zwyH0Gnjv2CdYBVtIP80SQsYaDXOYworudWPnhBPy0sAqOHt5mWc+GgN7o1XQDOR35hllLhOl1yb+Wk8LoqTfc0JNO3f3EUNiGGz+KuK7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIBN/q6kyvAKgqC4zo6MXv0OAoVWi3jV6Xisb36HQfE=;
 b=EJGiFt9TX6zXfUHHirN1a0W4r5oL5gWu0YifgVlzugwJPjDD80E4PjrW6MpZZ1ZEH29m5UNbcgmuj8osmcHnLVzSqg/omlYzkrrYVIO/n1qB//dZs00YlGk8rOOsLQtCC0iDuTxh0E0dZ2b11VmbCZ/xGSxMjT1CDDumHUAX0/k=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH3PPF2B2347B8A.namprd10.prod.outlook.com (2603:10b6:518:1::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 05:09:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 05:09:52 +0000
Date: Tue, 21 Oct 2025 14:09:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of
 asm/pgalloc.h
Message-ID: <aPcVlz2Auk4JK2ds@hyeyoo>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-3-harry.yoo@oracle.com>
 <aPZKuOKlb87yX0du@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPZKuOKlb87yX0du@kernel.org>
X-ClientProxiedBy: SEWP216CA0013.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b4::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH3PPF2B2347B8A:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b13f9eb-635e-47f6-9f80-08de106010e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b2tS2/7rEUYMxPb72kQDnvjSidxntqeKjZjbK+ghlYsVB0crXmB4eoiWSEpH?=
 =?us-ascii?Q?nlOvRg6cE2gNuRQnFamFAQuvteYRZlAplgc+msDLg5wSa+JmQNxrZvbOHoDX?=
 =?us-ascii?Q?Ndmlrjv2WzDnmLMP73hTaKNWSzcFJco4Gm/BzXccphqadrSjslX4WpGIasqh?=
 =?us-ascii?Q?KTKixdD4h+KPz8PCNyHHbH5DHgbCnqPXoBeu9fCLveZj8Biuf/hvPBVadq/L?=
 =?us-ascii?Q?8pcbx/0Y6GKMwZqZKuZ+KkJB9C45w0W+apdo37iTnNW9FkAQ4TqBOPjp/dYu?=
 =?us-ascii?Q?Wq/MvgG0tjYRSqx7+Z1JQLr7e+VV7igYUhKXqa6Dt5N963WiK4JUc7/C4EPg?=
 =?us-ascii?Q?StAg45CchGjEFbTxZ+yUVgTqeCynsy0H0aIK5LwsFaFGlGznD9TmrQPr+Nz7?=
 =?us-ascii?Q?iqVXp6m2tJ3ZIwTo/93EVEtxJWeLxXPqk/hVZVssOWDQD0D4xgNL3G9EDAxh?=
 =?us-ascii?Q?IJcGHJ8lLvN30bq9y1qJNcYW3Xs13pzdYCjMFrS6Sao3fHE8eLWp8G2iahel?=
 =?us-ascii?Q?uFN63AzagrAoj9KPUZP5mVuSNN0RMcqEfTKEAXY6Wgy7SaCWJpcbNKJOjGHE?=
 =?us-ascii?Q?ovi4RPlOVlM2DYt+bXsXJCBt9mZMF1cRSS5199BDbnQ2PEIIvjaSYP4IES0K?=
 =?us-ascii?Q?ez6GAFNWeHiZQuskI7vAfn1WjkOsrwBM7WWAzI2vYPEwyh0ubNQDDxAVJocE?=
 =?us-ascii?Q?zuPk4/3K2FzEqOK0qCnpspb7DRGfF0h5mPptuwJF7IhVWfbTQshG7M4tMRnQ?=
 =?us-ascii?Q?NsdaB9vIkScuQW3vjD5WjlqOCX2tCVKU6e8gyL4fMD7sfT1GbX8RfLnG+IAt?=
 =?us-ascii?Q?g6d0KZvjJS9gwhzNKr0dTxbyeSqF11V0QhWZfwBmM3sO1CS8z05c5/XaHgtU?=
 =?us-ascii?Q?UWhzOjLNbQiWcZ8pXqo9Z9V99mOiQAIHc52lJYQHwWMWCTBfg8jxvI06T12h?=
 =?us-ascii?Q?oXef/li2ZjqfxLpK6OgbxXf817kYnfooQSOnuLFyeuSxzJQJ8OJpc5tCcKKY?=
 =?us-ascii?Q?SzwsEX46L5fWJ/DBfWb+1SvFYXLVer4xSiImfEchSMNq1ZaByxoDbeavi7eu?=
 =?us-ascii?Q?nmrj8eqb5Hl4QCRj4bZu4GwW6nYiOGWDgj54zYXWB9CR+psk/gDIhNYGjOKG?=
 =?us-ascii?Q?Z5y/nJT+EvOSUa95hT1y2UdHAb9Gq1obk/ZBU2h2Tr4N0zuJmvX9Bu1gN0Oo?=
 =?us-ascii?Q?li4GjeQzW5Mwuzb+aFNZw7GpkM9y3FFhM6RDVcpePFhMI65W6rYofV3SlGnP?=
 =?us-ascii?Q?5zo57oXpUXF5ffAz7whYkdyX1ulIOtapLkzCdfyx+kvacoUmZZ/ff2VJMJH1?=
 =?us-ascii?Q?P9ZfTDw6B/aLShIHEUY0Ks7rzcF1jrQuWgi82Pth8r1W63JJrxTUuDcbtxDv?=
 =?us-ascii?Q?Vd81Ry0nNlbQK3SbfGVXjYBdeZNBcmFGmIzhkjKIhns4DxyC/iy9u2Eg4fGe?=
 =?us-ascii?Q?rDoezReKIZ+t18xDvO/9oPV/kPBz8z1B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3uv9FjUMWnKsrs9RQwNX5nr10MPTKsCkZp4FyEI+xP+qUpenwVW9B5U083sf?=
 =?us-ascii?Q?fSxre8cKdZ7EtCEIhK/KsOzIyqbz6C3sEpS9zwdNVzr2wMtNNiCK+CRpiUPB?=
 =?us-ascii?Q?S7NmcXGb5OVuDjvUmYnSSpcSzh9z3im3qvLBGgh4EQj7xitflsFu67mhVEuD?=
 =?us-ascii?Q?9YlMSMwz+iESEDmyEamzYTkDO+sEjK+5zh9ChBco/q9zEipt4lzsdhEIrPlJ?=
 =?us-ascii?Q?jSYbprjarLZVO0BuxvJCxyxVVLgFJrMRiJfKYIZeNQZEbijmxeRAVxZpA/zA?=
 =?us-ascii?Q?6YjBlmUw2Iy/649KOVpkKw7o9uVZlLSG4HGT9/4ErEUtUsCZCI03eLo0hcXE?=
 =?us-ascii?Q?Om0cO6d4JdHQwZ0oM+pKd5pTvDFgZ/YPpKCPi09DtEy6Zjt18MCcoNyVMU7m?=
 =?us-ascii?Q?sznW8DnSI9la/NmllTxRxuwLF7d8hmpg+9BTN0vmkvYi6cVFxiLbVtLSvzES?=
 =?us-ascii?Q?Ai+xOthhbUY/8hno22d6pSC49xb3flZvLuQesE/RM+VRybLj44NyHm8p8W2e?=
 =?us-ascii?Q?+dE1JOjVn5yDZuhtlDV4AVIoNlLDIBTMgehNbdZUPVhEGKna9cegQmy4Omjb?=
 =?us-ascii?Q?BXWE75abL7qFfeeBsvLrRwxaOgT81TCFCeO0PswYUH8Okd5ZkPZNUBUm8lTH?=
 =?us-ascii?Q?GuS0nQhz/F5ADddO3+VVBoP0IV3rp5thkv5HcmbbXErVy5flGnBOGIEZr9A8?=
 =?us-ascii?Q?wE4MZkCHhqrFw54ITiGQEgxVQfrT5WZz6BnYQlEeEp/GtkrfPqpAzlJZdQsb?=
 =?us-ascii?Q?F9HzsdZB9CgtZq5vDxwbq224MIa6B438D6V7pizEIlHhOUmFpSLDHuorCk5Q?=
 =?us-ascii?Q?+sxWNoFmUsZngAicmRNTmMG0nOeCDZYKu+jIoS01EmlpliZj1LTXQpczCj4I?=
 =?us-ascii?Q?aRCau75tPWQDZDY774eM7qwIUeR3Zhs5wb08OHAZhh29MEAiaFC5zgLGPDPL?=
 =?us-ascii?Q?PDEC7es64PjLVr44nQOW9WS4w6KX16RDZKjI/UgfqyH1jw14vZfua+b/3bWq?=
 =?us-ascii?Q?9VR25xbFyZaj6c4fzt/EexaveNh24AF3PoNXVYP9kTT70BxsGg0stQHzH2ZM?=
 =?us-ascii?Q?M8BmERTj1ljz0OOtHV9b+gS7HosjyL/pVzzLOgRZh3Y0rX3QgvYGiMisgY2K?=
 =?us-ascii?Q?K/JfbYl5ZErQFuydFgG50rEyQ7gzgySMQe67MaLxZ8WfO42bqMwuKMber/bz?=
 =?us-ascii?Q?rvScDm2S3cbkCHv7FVpXaZpkNzyVDxupa1UVsh4FsvE2pbhrIef9SdXPw4qg?=
 =?us-ascii?Q?FZ0WTQd7YJ4Yvnky0iMJ2zfjE5VoztCtpb5xnOlIaMpc4RZRoM+X+ZZjnYgD?=
 =?us-ascii?Q?FAEu7NVMGM/xeqcjMQUmeMmm11FTbeJUrWyNJwEPd++2i4GQpzJhJymCYjzT?=
 =?us-ascii?Q?ErYblN9Neh8qm/UTq6yQ9v4NzXfRTaqkb/WECzU0pDYmcGagHfASFLMVQ8KC?=
 =?us-ascii?Q?t7gRFqCMawj7jszBz7fhx6QNohXi/ZcyQla67g3oJpy1e8iWxljYZfpaq1BZ?=
 =?us-ascii?Q?AZ5AfRGnpXpvWl/4nWLIHs88xBzHWiwtWA+M1wCRFMNMxFWy5D7Josw3ptMi?=
 =?us-ascii?Q?Ltn5OrTL07t6qZ2dbOmbnYhubyKgEbgnqUuhZIxp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9jme29w1Dsq3AVebd2cDu/ttGqCCXdErUh1fQbMvCBJ7f1fPWuWNnYvViS+MUJcgLIajubJwMriY33TLWMCSfMudflNDIGPna3NQoBw4C+XjkKHf05Ih6lAxmkqbCbmcGjm0RB47/vgYpQbgXwBiCNkUeTnEpBauSFsTS4l7q1JwFmzU5KS60hfRbCAuY6V9LDFl/coVmwwUVhNJ0s7jrcFOh4kNIvbnD2xut7BV8mE6J4x8LSv1HUb/O0iNVytaLsLqw8KygSIOQZ7b8S4MEDi4C5qP4jlE7jKUzjsyvN3p0bXubnuXBOM7656hsGPpCCovAvzDywozQpAR/Ah9G8iNw/AB2Ij9Lzqx/+dBR80aPI0I/U7whem4mxDZmCbOT+O1KRGtb8v5+uSc3y/ggKijv7U5L59PEXhCKZS5WYXkPm7+TO+7gl29QY/YtYQg7up9ku9jNcp9NJQbJF9/GpiKF01d8qn7SY7n74OP8cxBwi7M337c8x1jZthsZEWj0NLK1mc6h2BC6fjEKmlYVp71Xv9Vprf2miGYxMFpqeTgVcZMXGayiR+vA2kNSjnu8sH5bAr2xsaiY6fpkBoXDPqndnwn3LMzWRyWubkD6nY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b13f9eb-635e-47f6-9f80-08de106010e2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 05:09:52.2660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9xfgHNgSM/KPcsiUKuEjYKVTUkv6XJb1g9KfCuKIl+tmxP4YMheIJeLyr8I+vr/XtQv9+5F4CR7yg77UP9bH1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2B2347B8A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXwYrUsWZ5jLZ3
 celgGgfNdiV45AwO6ptjKJ2ppEMU+1Jgsadta3ny1CCsK2vVQeOhY4QJBYgvq7l1gwwG3tUDil0
 Hf2Fhw4Fo/mmFhGDNxNf4ojba0zZg/1kInhpsS6lwu61UBkUnwLTsfc0k6EogAiRo7DMw8WTcxC
 IE4v0P8/qOK6cLLkwtuLGzhzjMn/QtZCb7qkytSon+nrMGSi0llEmEFrN+s9zV0ZmgO4nHbitPn
 solhtjupm1XifRlQurtzUUHwdELpMWGpB+iNTeFk3MxeFVT9oyQ0z3epmiL1tY8ARouQAimTzup
 3FRkLimT7sYjejWrBVStAkS7HGbQPtADH0OfbYBRGGOJHdhg376tbOH0crJhRb3N/ZOMCGH6zu3
 fy4R592RIEgBOvKsIlDB8cuR5Z9XFg==
X-Proofpoint-GUID: CvZL5J-ZAaR-CKda6l6t4N8vJV-54MVM
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f715a5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=baSYNNwnnnWLHd5ZVXgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: CvZL5J-ZAaR-CKda6l6t4N8vJV-54MVM
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7F1C140004
X-Stat-Signature: f9c61wfj87chf51bes9b17b7e5x7p3cn
X-Rspam-User: 
X-HE-Tag: 1761023401-106025
X-HE-Meta: U2FsdGVkX1/N0klDPzneGSboYwwRehwGjXBJ1VTQwk8QkosXQLKln2BITve+VOc9hykNj/iZaFygeTHvkAYwE4z4uhMZlVc+AfTBbfQ0GbYZvZDhAcBW2VNmFLaeEOMiZmsVMTOT0eN45OnpBUHfskZzi4mygd8XBEpbSVTQwY11AkvIbyM16cwknYGd86/sXtJgP0XK6W3IM4PDYazmEAODjTdLWLRD2qRjX3GHyrwaVUG1aWUTsf09kd5+YZS8J+VNbvmnrEBK8VzDHyYKaQnzosp8rj04vRpjrRodnZpq0BXvbMXCjYLVr+P71cWij8zaoeD7tqhc968ovnAhanTiqnYoFkl0tUlnrWiCbQvlOwxCjwjdR3t1VQw9ju8Uryo2qtJZez+DgLGDhTCjWx1DQLBztl4HMgfWNrbi5LFW0lA48ofOE3DbYtZ5IuvsGzc/qEGrInopqZx1Z2EtqaWPtXBIZ/grIDQ/NLJ3dOmem5eCtLbyswIc3ee0k+BJJYhlQ9FoFVigfor0E//3r+77ANkRV51nY1l29US2hdwvbrcDM225X4JrJZhED2dxsZxCo2gZrFH6M4uxlFFIm6x+CO5MP/fceX5BXcQTxPLa/BAoyQJT1HYWkYKwJMN/MT001Vvd2ZDp1PuorY410TppBsHPYif7CiYFoTpxL/e3M07x+HkyWeFTkiqN58dXGWFRfGksLgG5Psu/V8tHJuZnF/K3VX8QLJzgcaunF0p+dP7hJBy1S1OfJOJv2UtOldLJxNzYFloGx4sKTAQQbRNdRyr5A26t0vwDVrwcxk3Mg5+E9oM9ZybX7UJFN9UgM8B91mPVWX/TddtxwoLxyI5mqTJhZgVD8uet8ZYyobpCuDpAAyzDHu5ksrH17GovL2L6dMMPMv/2epOu1CxipBcxRfEeJrl2gtLHNHJgQVmd9qPyLcpSn2Twa45L2PF4wqvrliKPjoJdIpfc+ni
 4QkdrYH9
 iTGuPr2T3RXBe/TXzE5AnJtmsLDjqNhtOWGTW6XSLLfyLkAOQFPgdqPvCB++xz+J8g0jYW6DB3Sgtm1n9dNRUUAM6vRZ5n2NF97vt3f19rzskBXPTtrOBV9lVATwQzu8phmrNn1DbeTL8EWFOvi5lN716Y1vy5Aai7CUOnQN+EpsAGSQS6ucQ2L7+HY485Tpths5P2oNYDC+et6Bxm4MHh02lwncmmUDarWjebuU30QpqviHu9efQe3byrEHfhIM/SSzFnN0usaisSRYZlm9hM9l96eGqA/1UBDtRkffvSAjt65X2sZd2WjT2rhX2zhLRMhhlqItmPz4WcDF86cMmx1lrVS9czQE5VWA0XWACV7qC7H8NBJlQMhr+DOzYOpGAQRKfByTsD7YlUmv1SXx17Nf7I9DcVaCARlKN75kGcM5d8nlIr6CA0TsOCXs/L+SATlrAHHAw2uN/re600VE9/CFgSTPJtRxDcQgI8hP44rjXH7ggYv+rkxdRLFLquLow3b0n4o0stt645M7gTJvLBB1xARooz9npN2Pv0/CAUGbVvYy2qT8B8K8TBR06KyFvoYVKmJzTzf0fSrC96/m7sseRJQRko6M7DbCdgJ25DO7IYUfQZoEbzixkPjxyebE1jXe45PRw/7PEaorTuhOxiLjwmwAXhsapKlxR/Cw2YMAqVEPcgdvc49gHkyOCfz58s0zR37683fq/hBNXSsdtYfBiCQPL8QidL/wU1WzHF5UxOx8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 05:44:08PM +0300, Mike Rapoport wrote:
> On Sun, Oct 19, 2025 at 04:25:09PM +0900, Harry Yoo wrote:
> > For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
> > is technically fine unless the .c file calls p*d_populate_kernel()
> > helper functions.
> > 
> > But it is a better practice to always include <linux/pgalloc.h>.
> > Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.
> > 
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  drivers/firmware/efi/arm-runtime.c   | 2 +-
> >  drivers/firmware/efi/riscv-runtime.c | 2 +-
> >  drivers/s390/char/sclp_sd.c          | 3 +--
> >  fs/dax.c                             | 2 +-
> >  kernel/fork.c                        | 2 +-
> >  mm/debug_vm_pgtable.c                | 2 +-
> >  mm/filemap.c                         | 2 +-
> >  mm/huge_memory.c                     | 2 +-
> >  mm/hugetlb.c                         | 2 +-
> >  mm/hugetlb_vmemmap.c                 | 2 +-
> >  mm/khugepaged.c                      | 2 +-
> >  mm/memory.c                          | 2 +-
> >  mm/mmu_gather.c                      | 2 +-
> >  mm/mremap.c                          | 2 +-
> >  mm/pgtable-generic.c                 | 2 +-
> >  mm/pt_reclaim.c                      | 2 +-
> >  16 files changed, 16 insertions(+), 17 deletions(-)

Hi Mike, thanks for review.

I wasn't really sure if there are certain rules for header inclusion
(yeah, they are not very consistent across different files...) but now that
you mention it I can see them, thanks!

> > diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> > index 83092d93f36a..2e3b5131df32 100644
> > --- a/drivers/firmware/efi/arm-runtime.c
> > +++ b/drivers/firmware/efi/arm-runtime.c
> > @@ -19,11 +19,11 @@
> >  #include <linux/slab.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/pgtable.h>
> > +#include <linux/pgalloc.h>
>
> Looks like here the includes are sorted alphabetically, please keep it.

Will do.

> >  #include <asm/cacheflush.h>
> >  #include <asm/efi.h>
> >  #include <asm/mmu.h>
> > -#include <asm/pgalloc.h>
> >  
> >  #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
> >  #include <asm/ptdump.h>
> > diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
> > index fa71cd898120..5b8d72885fee 100644
> > --- a/drivers/firmware/efi/riscv-runtime.c
> > +++ b/drivers/firmware/efi/riscv-runtime.c
> > @@ -21,11 +21,11 @@
> >  #include <linux/slab.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/pgtable.h>
> > +#include <linux/pgalloc.h>
> 
> And here as well.

Will do.

> >  #include <asm/cacheflush.h>
> >  #include <asm/efi.h>
> >  #include <asm/mmu.h>
> > -#include <asm/pgalloc.h>
> 
> ...
> 
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 3da0f08615a9..9d48646e659f 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -107,7 +107,7 @@
> >  #include <linux/tick.h>
> >  #include <linux/unwind_deferred.h>
> >  
> > -#include <asm/pgalloc.h>
> > +#include <linux/pgalloc.h>
> >  #include <linux/uaccess.h>
> 
> I'd kill an empty line before include <linux/pgalloc.h> and add one here to
> separate include <asm/.

That looks good and will do.

> >  #include <asm/mmu_context.h>
> >  #include <asm/cacheflush.h>
> 
> ...
> 
> > diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> > index 7e9455a18aae..ec6fe4eb2644 100644
> > --- a/mm/pt_reclaim.c
> > +++ b/mm/pt_reclaim.c
> > @@ -1,7 +1,7 @@
> >  // SPDX-License-Identifier: GPL-2.0
> >  #include <linux/hugetlb.h>
> >  #include <asm-generic/tlb.h>
> > -#include <asm/pgalloc.h>
> > +#include <linux/pgalloc.h>
> 
> Please move it before include <asm-generic/tlb.h>

Will do, and in this case no empty line between #include <asm*/*.h> and
#include <linux/*.h>, right?

> >  #include "internal.h"
> 
> With those fixed
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks a lot!

> -- 
> Sincerely yours,
> Mike.

-- 
Cheers,
Harry / Hyeonggon

