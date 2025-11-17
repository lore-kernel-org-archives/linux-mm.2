Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D8FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351288E0017; Mon, 17 Nov 2025 10:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328E88E0002; Mon, 17 Nov 2025 10:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0708E0017; Mon, 17 Nov 2025 10:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 02C2B8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:15:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B21B1D8DA9
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:15:53 +0000 (UTC)
X-FDA: 84120448986.27.142AF40
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3439C0004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:15:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VndREyID;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mIluxgNJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763392550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rftimcRB+f+17fJXy4Lq9OaRfDPfx9Js+X+tkHNfrw4=;
	b=m9o5abSfiLzrhI/D3zLg8/s2hSiNBeGxpYUC9KYv0ZeBrEX2U7zdAekHAcQeBGKjHaPwPc
	cWzSaG5GYRuGJLxkgO2dKuRfVuIWi5VRTOresSZhVELZjfWfYJf+1oy1/uxIHq0pwgpWfA
	3HAWaCbduJWSYAxkpMrByrp9Vl5qQUk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763392550; a=rsa-sha256;
	cv=pass;
	b=74ejZDVRGVCkzfl3ZK5LUDEU/PrjqJnxDy24wwc9GvteRqXBfDAqo9lYVeEYDw1OpOwsyp
	JrWp86J3sJjx9fYD5EzatlBZoox9bVABGcycmb+Ji4iR/wFha9Qqp3RoQA/sctyNcnLEUz
	cun2pW3XJdcNmS394Z9Qz4ekShO3vMQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VndREyID;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mIluxgNJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8Sjs002257;
	Mon, 17 Nov 2025 15:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rftimcRB+f+17fJXy4
	Lq9OaRfDPfx9Js+X+tkHNfrw4=; b=VndREyIDec+VazoQ2gRTnVrgaAHMUScfWn
	GSBtv3gSkhvaASZuEnYy/RbIZ/Td3fjtKDzV0rQsEIUHevmrsdoYA5kzJA9Tviqw
	4xckcV+nF6rLkwdlfxamRQx932akFWhc+L98r6cqsL5yKMckTdUwCJEgdtAupMXh
	3iUx9WjRNndFRpQ2wuE5HjExq2VgwDji/hd2XX8hnWnbOAvI52Au0E5XfVaQVOYW
	QraHtJpLd5cD1q9r+n+JDKoTI4GDfflms/fgUawnA9tsM4ITWpzntyjNXxSjJCY+
	8DiFyolA3MvZb5YxapUwI31Wmkf2oh57XSp51pc7CuMDowwETeXw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej962m97-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:15:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHDUAhx004250;
	Mon, 17 Nov 2025 15:15:44 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010070.outbound.protection.outlook.com [52.101.46.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7jd0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 15:15:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fkRKPlUIvoYyZVwHUvtvJYzPQIH+UHlUhV3Rv5GhnnRKQ8xqkRU37VVuueM/1vartcVWvIb/JfDVa2XrFasY2q744q1niP/WNsqtNxMHL9q/h0S+IXf4uMtxsHCf0LIJVQC+FIlDyy/gAq22/fqvVSqOirTtOFzALf/i5LpwRoKKrxDV9xK1bBBFrjfOkLPydFEZHvL9B+mF0AbGFzf74y2Mlh5a/aP6VEd8U0/qRVY4620HLkA4AyedBQa2PUraYv3Txen7kbrvL9aL8NBufw3zkEweOsjqTShUASXLtHhd/iy3nZT3kp9pniD6MWP9IL/xTXMr077PZCUZmqNpew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rftimcRB+f+17fJXy4Lq9OaRfDPfx9Js+X+tkHNfrw4=;
 b=aCgv5h0Ik4y/ojALpPNyFircKG3MglBvrHANdpZklz8/pdrl+oG6pgIxZl53/tPK50Mta9pUD+5LquU9pRBi62JFZagrlfStolVn8AYAiemFoWp0rLC9A07cUj9EQHzIWreEgZ0lZoMiX1RkCNLvyvAweaWNp/smAsNI/DPFq99Lz/WQVIvgLydw15fYmxAy5Uz9WIhUIpoeLKmreDZe9u2tJ9Hn3Wn4XYDsm+zAP/yV9beZjBKViUVVf41WTl1576q2vJGx13fLyrKO24doqHIu45nXCzj0sngE6rIZph8DZtSf6SIpYaUWsQO6TAUStUZLp/kM9g2KfwV9SrQ5cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rftimcRB+f+17fJXy4Lq9OaRfDPfx9Js+X+tkHNfrw4=;
 b=mIluxgNJ3TdfYQvFlCcAq/2G1nbg1sFQvTnNRN5mVgYGq2/EC4BGaUe8z24VqaGPD+3G1b1DlLYlh4HsEfWo8ubvpvkD/zVj4Zg6wn0vBtkm4Qn1OTUpTG3joW2WjXO+UOZyMnOR3tgVqs4CFoL+JC6ipLhhwfy5LwdRJAvUpA8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV0PR10MB997613.namprd10.prod.outlook.com (2603:10b6:408:345::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 15:15:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 15:15:42 +0000
Date: Mon, 17 Nov 2025 15:15:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] testing/selftests/mm: add soft-dirty merge self-test
Message-ID: <c5c31abd-98ee-4f10-8990-0f935035b3c3@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <0db6aeb73d42876756ba73163cc0cc6e7e8c6100.1763142412.git.lorenzo.stoakes@oracle.com>
 <5c1ef450-c9ba-4249-9eda-b38efbd76c3f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c1ef450-c9ba-4249-9eda-b38efbd76c3f@kernel.org>
X-ClientProxiedBy: LO4P123CA0028.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV0PR10MB997613:EE_
X-MS-Office365-Filtering-Correlation-Id: ae413fb0-74ce-4c3a-f63b-08de25ec2c56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z/dWFRgHxjC5DNbz6T959b4LH9gjTfm4AvgMrcVto11GFWUkvPOdbwyFVFvv?=
 =?us-ascii?Q?LEHQha0HmZneTiNqmw9MolcZO3TwYniLtMkVVRSDp8UaOoHEvY5G8st/rpJr?=
 =?us-ascii?Q?+nnAp6Kuve7aNOj5y1ABG6FPy5VmCwH105ryPViQQRAKPunMrFOZrze/F2G+?=
 =?us-ascii?Q?MV+BK4kM1Lh31eF2Tq8PZjy9YgOAKJbkxWXPqDJH0El5pF6Yb2vedLxttssF?=
 =?us-ascii?Q?Yj/A8Qm4P0fDFmgs5R/4uieUnjDBh+Q2lshHO0/odjfa3dpjPQD3SivVV485?=
 =?us-ascii?Q?w09fnhq1HPVgOs43b0SVaHwjulgBvINkMx3QdNX2/PPw3zry4bVkiL02F/9C?=
 =?us-ascii?Q?D9ZtUQY2dGjJ+Ly0iR+F70BoSHMTAMGxPX92qIYz6oqFdkHkc71YKDtz61Mv?=
 =?us-ascii?Q?COX4zEM+wWBnMCySzdGh8di8xZ4cagQt7Ea8bFv/xSfq4PKFxKwzBr8Zc9S9?=
 =?us-ascii?Q?warLmEGdhfK65zy0Wrv9zgxudNzT+BN/jKiheI1bUWTS8m8FSDBHDaf/V4rs?=
 =?us-ascii?Q?VT+54TE5K9DWJgdfDp892766FUb1l68f1Jzs9LBok/OeY+qYvZrcrOsNVnII?=
 =?us-ascii?Q?j7q330ad4/YkjwklNR6BA2IOSYqpCElh7TO1FmNLhNoPYfn17HvpXtCRAu2O?=
 =?us-ascii?Q?0dMOGD3m442yCIey04+7SPbz06hLYH7snMa2vRkQyK6/dE57SuDh998Ag4Of?=
 =?us-ascii?Q?6rzQn8fE799oQ8AVke6dK/UpupyBD2GaWd4ew933zmLf4OzVWN5jF/sQvmrg?=
 =?us-ascii?Q?NllFaBRLyjzPtXcLpc2+SFhpYrL4dM8tRCDomvNBjIzI3gynZDhjRD83tgAl?=
 =?us-ascii?Q?eGNOQ61kB6uxhTiGlxNICxpGlLyqptDucn+TZIYxiVv5f42cO5eT7UIyTmAE?=
 =?us-ascii?Q?u/FM0Vj+Ps4NzzJfkvNmqF6kbU/0eUgoidKIe1a5+Y0qJFwke6xh6XrpyDmF?=
 =?us-ascii?Q?/nCeiVsZCiUwY2EUeBmtMh/GNNUaZIIVvQNvH5bgG0wyFp2WHmbNwMtt72yZ?=
 =?us-ascii?Q?1LXFRSeG1tAPNYe+hgu869ukKkcuFgEOiQJFf2RDQHuUxKlaE0GKyHnAZ5cN?=
 =?us-ascii?Q?85SJz8JQqbdGMyp8PEFEDYVc4LBuREQ/e7B/v2sDjLOvO+uyY5WXKeQZUow0?=
 =?us-ascii?Q?fW5FKcUXH9sfda3/S2/7JFBwmOhUSvuDrwcvcTIkD0jPRZCL5+CVK6hAMQvF?=
 =?us-ascii?Q?r9CXkmn8fNyrNL2f190s/4NPfb+PTSM8x0Y6qdxxagMJZ7ALrfF/63dLuN/0?=
 =?us-ascii?Q?CFDUB2sm63dIfsQbC9nHTUvaf16iZfOwuThYc6QQSN483bRdwd8iIG0CoZWb?=
 =?us-ascii?Q?fMpste1QdJtSze+FN5GZdCR/bG19PXP39ILPp4mOGuact2Oyi5dvH4qWgeWp?=
 =?us-ascii?Q?ar8C/tvtSOSLad4RUnyQUU1eQaPGpmnNRS8ckdC4uiDSZL4SseDEImkYfbtg?=
 =?us-ascii?Q?tcNiBCZ4NBLv4Hwd+iaq6GpdHBIW8XhR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JP6OKfw/+n7whLezxrzat6BvcjicZq37fZnxqSLiM2A60PCOAhJTN5L78fLa?=
 =?us-ascii?Q?3g1lWr2YgUx3k7V9tqHngxwPXUTzEnON7kD6h999sPGIIYJyiMd8e9i2qxtH?=
 =?us-ascii?Q?+C3jgVz3cVBpvKDnUaJ7/GTpPIK+kSMvPzqkUQgxOXf7HL+KI9Gu+V1sSv27?=
 =?us-ascii?Q?6x7CQ4rDBGkh/97K8c5aBUpmROeK1d9VbBsi9W4dTS1MDkxGNY55AjlJD4q9?=
 =?us-ascii?Q?0k9zFMIXQ2ddGGcpYxaZc7EPEY70pp9KC2N+ah1C9+Vrkb1WaYIwZgAX+dAz?=
 =?us-ascii?Q?GCAQaZh3qkI+qwIsjRXvOrJ/xvO648RD0ENK2cKgRzQRiCyM8VCOeXSDh7wS?=
 =?us-ascii?Q?NJqlM8mzU2x6DLP0Ms7dOQ72vVoI7wpaYzTaaNjyhpuBZbcd7h18odAjvl/x?=
 =?us-ascii?Q?5SIkcLUI8hdPRCwlwIKImWh8zKVyLB2vhaw8sIzYJ/C+Qw+Qn9OJy8K8M2Kp?=
 =?us-ascii?Q?bEGYVifCWGi9Tc3yGqLEPUR05vhGu+M4T1AX6cjjPvF2n3RpR+v9VLWB/npL?=
 =?us-ascii?Q?2aQLceq7rO9OKRY1DSchZnulDCOGohEFRDA2mb0HLg+BTFE7dUO/x1gc/U3G?=
 =?us-ascii?Q?fB6ASau3S17kQWGvBDFpZOsA21nVjley/s/ozEBlxM56UZCNGnFokTLTnV1Z?=
 =?us-ascii?Q?A6VeMgvGNsvqPtbFJoX6tqZTWLH7b4tlJZpJ1wBZElac0/sJry0jr78Kffsa?=
 =?us-ascii?Q?Sb0QJGI6t/V4l1OtOPUJGGzhPrDYWdWBx+dpU2t0GPVX/y+qzqSGw5BKAE/s?=
 =?us-ascii?Q?2T/VCQUnLwk5F0+jMIbMw+9qQBzbWmrPsEmEm1GRhrpm20NzP5R972l3p8qX?=
 =?us-ascii?Q?ynb83CcWakIlr3qnCmNXMaVeVl4n8z9zJX4ZMSKbsnfGzI1U3i/Ve4WntqIH?=
 =?us-ascii?Q?XJCeIhv0b3rt7ri4d/2uCrmja8NLbXdZTDEImz3OshA9xceR5Jhcje8BtuXa?=
 =?us-ascii?Q?zByYX5lo0m4cJuQfQo8X/vnQ3oB62J6G76v+8Yavls2jmwgOhuY8p2LhUEy6?=
 =?us-ascii?Q?Wuz3nwVhu2FrztKEfCmDEXP42H82bpsm6JFRQjwUygl0JQ3OnVRkrWrLpul6?=
 =?us-ascii?Q?XQsZJRFPWOeilAMbCWvVK3Pi18awEOGt5pxHIqyUMmUMJT8XQCT+oHCdnw6k?=
 =?us-ascii?Q?8+7CD303cu5z//9TUt8CWgzqCx7O8Yr+GUj3TBdrYrY91vu3nBUexr2RxmTR?=
 =?us-ascii?Q?5UikugsvKvEZM83VH5jtbqphOGN4LWkq3H+kqtJIJZTSe3GtMHSsuE64uzz0?=
 =?us-ascii?Q?oUKuEi6ia4cq6SP9jmbhhxJX+VRNdDByBJ0GiN3Vujmp0u6a6PdYbpdUhm7U?=
 =?us-ascii?Q?DtZlwvXgbEqGXYAavd2h1JRIy68FKEkgbJ8SOBx/0nL0JQ5dnMewVdaJgb/M?=
 =?us-ascii?Q?68u4CSe5ipQQ8QWIRe+EaZnmrxqXi2JgKFKON1b2myRpqJyjqBCm8enDXguY?=
 =?us-ascii?Q?FxvOSKCQTxCeD3BKw77scR3A8ztNhOwnoQVBT4Tz48Bqh2YLfhizlE/E5sfN?=
 =?us-ascii?Q?FMJVsRamouil6PFui1hf5mDOYSVGC6i5o37JzLePTKXOgUKJfCUDFhLKY7cY?=
 =?us-ascii?Q?5dfCjpg/OISqSFFTkmPz5AhOb4qffkQZajAbf5CEI53GfaZVLCqcdl6BtG/A?=
 =?us-ascii?Q?pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MbTKw+A85RuFCktm3Z4nHTKo/MzGipeXy6Dr+vQeOlXD5F8Vq9NlDlrlTWFqKOT56b/rzywNu9LB12z1JdI3dBE/L6TVnVt4R8/MDQ6tcgdZSOE98MCLtStHiCeP4WT/3Z66NGQ9RY2UhnPWR9/mRzC7PDk2G5kt8futppEjwc69kKZfhE7nZHsKw3Z/VFTFticfVhTbUcd80Y0BehcKKr/u4YL8wyoclbYYVI7W4xEqT7U1sMQEG4xqQcaLoOvDutwuvwUxD3LnL9NX99+7Cy9K7gdbheD8qajMR8bXu0+E3uEeY2qVq2h8AMJdAY5V+2jv4md/V9w50z6b+3GqsdU60RMHJQ7wItHfrxnFBFdudCurSgXD7EVrec/mFBoQtvq8LGKNYH3z4dNNlBTbTtzqhw9T9sw5J3TyKMZgZIMJrB/vSgxwNJglIHiHRu+e9ACs0CdMaNZI+XuBQrmvsybf2m58s5xSR/dvismjQP2ZpJiAwpaYOXwQ4/KZkb3kj1OSBk99c4n5OF0vJwZFU/kXfLqcisOHxz7qpJD5pLA9jVoG7C6qQ9N8ZmeBOfsm5umUCNr4su/LJvyd/ceR+fKKrqzHfQj4ZC8h4ErSQBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae413fb0-74ce-4c3a-f63b-08de25ec2c56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 15:15:42.1529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7nbf3hRcHN0jtV9ihfTy3wKy/KhmcrDpJKs7DCjTDDE1tTyueYKq+N/Zj4xtsc4DYM9pk19yK5NxZmkASTT+tN2JBWzdqLkDFIOzWEnVgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=946
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511170129
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691b3c21 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=lEwFJ7TrmBIjYf88vTQA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: LfkO-x408tzgfoWNNSHGgPhseusuNrvH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX+6YP+WL50Ute
 15UjEUeY1hezO+NAG/s+PCddwjt+CUEbjqMyntPWlPnoDpJ+sQ+GH1FLlkDzfnKk322gLEqKdrc
 xUs2EA/swzZGWIRGdernj5dzyk8ZivBGsqCRy2S3bs7h4qcY26VRkyELhVy0iNtTz92SWFP++JG
 XDqQHMwSNW+dMSByTULuvlUkIsdAV9Y2/CLE7bmp+LO/5A80dQNxLjjXfa5ROcppOXVsZ3zFBu3
 4FQjEzO1jkJx5ai6OoJ44pKHndr2YmZ0i0iu9fkH63PToqxK9g2U3T6OjZFL/TMA4oToICqVSho
 vSexOqD+1bFx0Q0PS7zM3RUcpGpcx0F6QL+lK3I1X739yiIKeyhi4rDW1Nd3dbpjMpxo91TJ6P4
 8S+FyuwLP+eC5R7niDUDdM5cLeB+YQ==
X-Proofpoint-ORIG-GUID: LfkO-x408tzgfoWNNSHGgPhseusuNrvH
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B3439C0004
X-Stat-Signature: jx9kwxd9cq49nhggjnjsd8suxu8d9bks
X-HE-Tag: 1763392549-111661
X-HE-Meta: U2FsdGVkX1/A4gX1ZrkSxown1/MA2CId+Bzx+4bGfsrdKv1jdJHWPreTsmwIvenuqbxeV05hoBzRr+iZvwyDBKPvINPSkU25ycYU+VlQq36/Xprd8oy537L0mZzxfRRuRwqtaBZhlqqFNhC3Dlk1P6ZNBqTgpOLv0MCCRLYIb2G/Wmy6IcJdcEbAHBZOJxDYBG8PuLxjY5s0VgApk5b971+16qUJeZUOyY44TnnI4aNNQBFw/6FKFmhBF0OWJ2ZIKxt6o9jvVt3sahgcRCZtEQvb+g5Z9tgd8gmbV6xX3g8akQSXFe/GfA9rKgD2Jb2mfrUjut1Mak9Xrm7TIvk5eb4/9Wit/ccB2ytzHsy6kxajOCPcvzMP31yAxw+NdB2Nrh3ImRcxifF/j3ULL8ash3fVG8fyov7QMfhnPRh3n3EcvwVHhAUkVXjYfnfax6rFHzvH8vzfN+2IeOuE2CGZ2ppbyas23ETmw3rXugN+jT1B1BS/U4cduFC/p2yjUQla+3qV4wTM6gx+E7b5jNQ4FDlqfQl0d9sc5uiyAePXOVOO5/MS9sWzCIqVFo7h4mVWvci49hLQFBMhyPqWfFhGADwF4Syq5XzWklcKLysi/zMn1CK0m34UnSLtvGQ9gpcQbLMp5T3syO8vhbekC4t6y9g7mCXbZY1qlojYNxwQ7ObY1oUWTGahCx7Hh06qYAo7/KcSOewZUtFIVj6hmHj42LSxknHNA7Zu5fQ/+jxVN0kSAiY3xt3fOLG0IDklYfIHRCTxWpFtfPqrsGFy7h03RkT8QFT7FrRWwBe2lbHcRFkfceP8PqUd/0xPymYWwff+sE3zj6MZm5SytcnS3vXO0fW4Lp3F4RBkEFCprAva/NkpRIzkN+Elsb4PbZmIjF7nk3WnD5jbRsbotw6K24YqJw7TrJ9aikVxTyxB4pavNbhOA7hAFZrTl2yTVt7T8bIS516dckPo9U9K5cvUzTq
 0mCkz1pM
 IxoAsmYJQ+GRpcsndWZcbr8YUj9gebT/FHKpuycnl4cskYVA/HPVXdaeHCyyiZ0xcs51U5gIUwCo4sqHt1oIYbWB1ZmJBG+17KWPMZNDxuxy7jr0BgyAn3TNi8wE/Sw9f5fRGbJOkT7QRBFU9l4M6MOybYpxSf+yd0ooSapwHoGJyUVa29mgVkP/ucH9ehgXmjbB0RUhyag/CvUBsI2oGXBHTZlF8UwhRydux1k816fKhxvquPMPTTLHCAPY73oMZLOUbaQ/52kshLSycf2T3Ob6tN8B5mB0/2DZstrWPpgG80wOUrYp3XFrObsWJL/Zcro0qyYXA+R6m4GKSOe8NVr5RlTNa5i+3h55OtXMbzGx4XDd/Yn8UIxEYU/tVHxQH8SG9NF3zzoGmOGOGjN7gnBIy10ISpT6fUiQBJ1MJdr5LqGymxpsD3qJfHNcPJcdTVWjPyNulOwDutCPWy6yvqAA6CP3fsLGFaU1jIcLjIcu2zniIm9X/r/NdcUsRvHfOuM2EIU8U9XNultO0O0GqMpJB8YZWGEvdzNMOLfCB5aV2+tzwRTf58Tb9RGytgAvfKa+eDnkmgtMPCcqHGay4roOsPbZhH5/hGNo70d9O2q1VfQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 03:44:46PM +0100, David Hildenbrand (Red Hat) wrote:
> On 14.11.25 18:53, Lorenzo Stoakes wrote:
> > Assert that we correctly merge VMAs containing VM_SOFTDIRTY flags now that
> > we correctly handle these as sticky.
> >
> > In order to do so, we have to account for the fact the pagemap interface
> > checks soft dirty PTEs and additionally that newly merged VMAs are marked
> > VM_SOFTDIRTY.
> >
> > To account for this we use unfaulted anon VMAs, mapping one VMA in and
> > clearing soft-dirty, then another separate from the first which will be
> > marked soft-dirty which we then mremap() into place.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >   tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
> >   1 file changed, 50 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
> > index 4ee4db3750c1..bb29edb1e2a3 100644
> > --- a/tools/testing/selftests/mm/soft-dirty.c
> > +++ b/tools/testing/selftests/mm/soft-dirty.c
> > @@ -184,6 +184,54 @@ static void test_mprotect(int pagemap_fd, int pagesize, bool anon)
> >   		close(test_fd);
> >   }
> > +static void test_merge(int pagemap_fd, int pagesize)
> > +{
> > +	char *reserved, *map, *map2;
> > +
> > +	/* Reserve space. */
>
> It took me a while to figure out why you are using 4 pages. I guess you want
> to make sure that we don't end up merging to the left (or the right). A
> diagram would have helped me.

I have spoiled everybody too much with my ASCII diagrams ;)

But _just for you_ I will make one again ;))

>
> > +	reserved = mmap(NULL, 4 * pagesize, PROT_NONE,
> > +			MAP_ANON | MAP_PRIVATE, -1, 0);
> > +	if (reserved == MAP_FAILED)
> > +		ksft_exit_fail_msg("mmap failed\n");
> > +	munmap(reserved, 4 * pagesize);
> > +
> > +	/* Map a page. */
>
> Note that we are not actually "mapping a page". "Create a new page-sized
> VMA" or sth like that.

Lol depends on your definition I suppose. Not in the sense of page table
mappings. I guess this is fairly redundant anyway so can dorp

>
> > +	map = mmap(&reserved[pagesize], pagesize, PROT_READ | PROT_WRITE,
> > +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> > +	if (map == MAP_FAILED)
> > +		ksft_exit_fail_msg("mmap failed\n");
> > +
> > +	/* This will clear VM_SOFTDIRTY too. */
> > +	clear_softdirty();
> > +
> > +	/*
> > +	 * Now place a new mapping which will be marked VM_SOFTDIRTY. Away from
> > +	 * map.
>
> Could we have something "to the right" of this new VMA that we might be
> merging with (that might interfere?) and if so, do we care?
>
> Just wondering if we would actually want a reserved area that spans 5 page
> sizes to rule out these cases.
>

You're right! This is an oversight, will fix.

> mmap1
>
> [ empty ][ VMA1  ][ empty                   ]
>
> mmap2
>
> [ empty ][ VMA1  ][ empty ][ VMA2  ][ empty ]
>
> mremap
>
> [ empty ][ VMA1  ][ VMA2  ][ empty          ]
>
> which is after the merge
>
> [ empty ][ VMA (SD)       ][                ]

Yeah this is the purpose of adding space around.

I also want to add an additional test anyway so can do both things at once
:)

>
>
> --
> Cheers
>
> David

Cheers, Lorenzo

