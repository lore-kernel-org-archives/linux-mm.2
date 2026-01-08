Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CCACD185C7
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54DA6B0095; Thu,  8 Jan 2026 05:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25716B0096; Thu,  8 Jan 2026 05:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3F86B0098; Thu,  8 Jan 2026 05:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A879E6B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:45:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53B731AB2E6
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:45:23 +0000 (UTC)
X-FDA: 84308464926.02.7D2DBD9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1DB840008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:45:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mRGGq+48;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KeDOuqSj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767869120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng9AGSrbjuYprUsqnrZKU8+XPt+luFx2EKK9bRipizA=;
	b=kiYnTpwbtY/NrkmcsBJOJV963lhpTr4otSBVm9P4MpdPeiDuz89F84U74mReJNPdHMa90c
	BDwzX5SQMn6OcIGIkkOoTaEX3qTiVUSuyjvm7i22pQ+fVw1gQv1dV7ffGLnvhoACnj2C0Y
	ThCx5iT4mPWg4uky5bxz4ET+NveFb88=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767869120; a=rsa-sha256;
	cv=pass;
	b=5mu0ZX1yzdM7TADhYR3UN6w8uV7trKrjuFsIOqXfVozo7mHfydidJFgPPfT9OW7v1w96Hd
	opeuZJivQ+aNZldrFmOJg2C8kMhJkpdkvZF0/JYfELhCfb1p4i4skMjYrh7J3vY8E7Wr05
	v3mJ8aVLLiK79HMLKuVbM2MXlEIQX1Q=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mRGGq+48;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KeDOuqSj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608AYp2r120013;
	Thu, 8 Jan 2026 10:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ng9AGSrbjuYprUsqnr
	ZKU8+XPt+luFx2EKK9bRipizA=; b=mRGGq+48rddCiIs8dILJEzPHRC4f8CmaQr
	xEp/atazYSkcC4uiBAf6dZmi9Q3gkNjz2JvlmmihOOfFhzeiJx+K/FD0/9woyP0K
	SyjVe4C1lMKLY5juHihdKrZhumONOMW9VHSEiJfz7Di7LAUBWoLDr7iIlMvBRrRu
	vfUjcqJi8OnU06azhXJ38Wp/DfFEr9jtuvaa5VRkDx9ajUTqUCjGFdElmCAQ42/W
	TrS4qXVY2az3sk2V25LVkzSFYRafWCQhMxtJsWhs3r54Lwjx0e/3REB8UufEOde6
	Y4nC86fCjC4/LvSS5FtEuO886hZvtCb+t9YxdMhCk3x5Uw4VqbZQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bjaxv009q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 10:45:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60891AL6026417;
	Thu, 8 Jan 2026 10:45:05 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjn78ce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 10:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbpcVniExbRpnGAQ4ynq9xlpllZkqqG+IzRf1PG0M1kSke+PWZ/BD77iQpFwv2VmYTB+I8/i1OTrULoG2Jej0nyX+KVlHdkMlxFP5ntzj6sFynHvt4ZjjXQdDeM7xQyqDohf/QoP1jp/dJvepma/75YoeAsjcrWPSecgq0Rx0S6cg2VtvNiwjibhznqzrrjF0uNWfNYaGdTGZQV+sKJUL2663ODzPgo51o9GwIy8zWBsSWrTy3QO44sIfzBLrnSks1+PJ/4cVuWIfc2741lBGuWxlzlcLUt5d/RF5P8HqNsgQUTpXvYxJbU7r/LmnHtvhxeW1FdSJJu1wbwjhS0XIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ng9AGSrbjuYprUsqnrZKU8+XPt+luFx2EKK9bRipizA=;
 b=Y+FKtEonLW/YSGX1EeX7NQty4X79Dq7FpgiVGANY/lRnlNm3LrpQmjcj5qw7TnPZZ9Td0rG76DRE/tcteRVkfqdeebLYZZb67WZfeV5NN3kS+8w4wZwnhHA+tfL3V9HtXdDHUYBv1nDKmO6r8sI3r3AlL7KY2txc0A0HMaKgpz9bXjKjNhB0nD8goD+2m08L1CPSG+pC4V3Gye9Q4F3+VctSL8gtarMKBcn8PfC472r9SJghik9vWr1Q0rYbUHzknNpwWlufpvksfzSbDNnmx68Z5j/17wmo6yAiMVRs1vNbSeKXsUWAZp3n73zsg3gAJN8knvgUqPybVm42LX/xTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ng9AGSrbjuYprUsqnrZKU8+XPt+luFx2EKK9bRipizA=;
 b=KeDOuqSjBwlREr+W5xeCT4Cqx2HRgqtpRrFhSNjm0ifwGOntKA37mikx9UfZQsyMfN/mpxqScGudpcZeiPHIbZ7HrdpGfSdZVKobiHIW1Y0V1C+DQf0fCgYS0oV3O/yH/St++n1LPcPrhUMuK+UNLTFGHZOC3CeFFDydFhS7qXY=
Received: from IA1PR10MB7333.namprd10.prod.outlook.com (2603:10b6:208:3fa::10)
 by CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 10:45:01 +0000
Received: from IA1PR10MB7333.namprd10.prod.outlook.com
 ([fe80::e8e9:f35e:8361:ec06]) by IA1PR10MB7333.namprd10.prod.outlook.com
 ([fe80::e8e9:f35e:8361:ec06%7]) with mapi id 15.20.9499.003; Thu, 8 Jan 2026
 10:45:01 +0000
Date: Thu, 8 Jan 2026 19:44:47 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH V5 8/8] mm/slab: place slabobj_ext metadata in unused
 space within s->size
Message-ID: <aV-Kn8vfyL5mnlJv@hyeyoo>
References: <20260105080230.13171-1-harry.yoo@oracle.com>
 <20260105080230.13171-9-harry.yoo@oracle.com>
 <fgx3lapibabra4x7tewx55nuvxz235ruvm3agpprjbdcmt3rc6@h54ln5tfdssz>
 <aV9tnLlsecX8ukMv@hyeyoo>
 <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7uiizca4ejiqw6zegjwmou5va4kw7na7wivy4kxebrju7dsdwo@5brr7vhwf5oh>
X-ClientProxiedBy: SL2PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::34) To IA1PR10MB7333.namprd10.prod.outlook.com
 (2603:10b6:208:3fa::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB7333:EE_|CH3PR10MB8215:EE_
X-MS-Office365-Filtering-Correlation-Id: 152f86b6-29d2-4cef-ef7f-08de4ea2f935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wFpz7jZko4JehKfCENLe5ZKWbm9haixE9eyM8DVB+0ZdNguyE3ChVhkwZpiO?=
 =?us-ascii?Q?1BOd+gUbwQo0vbR6tbFl7jXsz/p+VjmUwNgHUAkcaRp65pGV8Z/op/DVbvug?=
 =?us-ascii?Q?SUsZmZTgqZyDd1fdCfmb7qCcBu1i6GcylJStootfEv8G/yeExw7wIRI8txqd?=
 =?us-ascii?Q?ERcRcSPcIgicj45Z6wNmEYuTqKqDclqmnn8phtuZFlpQq44LJXDd7EK3eDo+?=
 =?us-ascii?Q?Z+zODw/cR19PuSPSrsGZETyH8xWsTpldTUOOVACo13bxlMhcxaCJkCBu1x2/?=
 =?us-ascii?Q?5U0v0NclEK8Ctr5HRM6aE5rn+hIaHGooM1eGH+H/7lqJl9ObEa93I2CZBNz6?=
 =?us-ascii?Q?pxT1yLDmlWf2le+3LZGD07A1928lxk+dPpmxB1XtPcA5b3/eRQR2M8G5Tp+i?=
 =?us-ascii?Q?T6YgXwKrW1SCBW+KIC0dSLLoHk33N7XyQZqqx6FkXM+odYIcwSWEFsLzQ+j2?=
 =?us-ascii?Q?4vIjCNDMiv3dkYqtSKZyjVHlGkKHJuPpWeZAGgtFZlS1f0Vb3Ra5pAEf+nic?=
 =?us-ascii?Q?3tFLfOW12Jk8dzY3XE1PEBb3oLxw1lWg5Z7C/ODf80olds+llCM6HOEWllju?=
 =?us-ascii?Q?e5K+5dnKR+2imyIa9Iq1yDSv1Zr5aQcwt3MtFe8EXbCrr8kFUpUHEvmsFYAN?=
 =?us-ascii?Q?gCdOwY4uT9oFxdNEUacDoTxWjz54B/5DyrrS4aGtE1CD5IX9yqvN8z+lsICI?=
 =?us-ascii?Q?UGpMt9t2+VkL4wNjJYW40XJNxmeFS4n4S6cDo8qEacn6JEzkuG/y1pRxi7MD?=
 =?us-ascii?Q?Y61cvB6qljoeP1TV/jd+wCHaEp0i/EkRzE52fyOCWYUVfmxXOkTXLmIhjNd5?=
 =?us-ascii?Q?VzG8d8pwkEDbnPirQXJAp8SK7EHXzoN0YbQ5+u0Hs21RwXRtNYtnLdZH/gy2?=
 =?us-ascii?Q?qvrNbfws7sw02+mbdxeMiODGx8FGuZmRdSfVJiX6wcFaxsMUiBT+TGWIkHBb?=
 =?us-ascii?Q?oOL0u2ZX0KN86EJUqgb1oQiyEV62tmOOU6q6XZLwVIxNCD6rXZiE8ai9tC5w?=
 =?us-ascii?Q?r/c0E3G2hq1duLxloWkxaYMyIAr7FsoiYQinwf7zfOrJ2GRNo9cVX+ErLG01?=
 =?us-ascii?Q?EK0aqkOPlw9KkgEV67aUAMmTj0VoD9dJ8oyPEZoku0K20p64W0VDN6tM1bY3?=
 =?us-ascii?Q?a4khGg4f+t/koK1CND3SsW+aBqK+1DT6qsKb80YScz007ubtq3ygiKa6Zvul?=
 =?us-ascii?Q?UICSy8mJPMecp5bQdicNc4SqFKyvq0WybDzEFkOLn1qD+dFsCvSB6J0LWbTz?=
 =?us-ascii?Q?bljtyJ1r+VLWbEnHFzUH68a3+INlNQvaJ0BweOUFBQ0Wnu36w6S4UO/fD+q7?=
 =?us-ascii?Q?VAWntYBXkrRM4joyICBG/Rv+EGSyZNbQ97jdvIdQSc8mfWVOHoTbvDqUdcwb?=
 =?us-ascii?Q?CYeXNd1ffKud+CP/AsymGOZvYzux3nKv0/wyB4Sp98NM6FbVmZhkTm2WDDrg?=
 =?us-ascii?Q?my1Cv0TMNWZCz6mWC+jhDBYTgD8MwNEC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB7333.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X+ciXESkbMpPAUGbkqMl4qzy/oa1uh+HfVnPUwI9U0bW/4RAls6MKJDjP59P?=
 =?us-ascii?Q?oNXN4e9rmKZgrBRuRF9K6UMRWebVRSbrIl1q4jxZt6hh2/JtnfLKYhzLhrVg?=
 =?us-ascii?Q?n8gZB8p+OtS3TlQ6oUt5cZsPPCBukvx5ekooz5SJZk/nJUvRrcx1ObIe8Dcz?=
 =?us-ascii?Q?ucwKr+ftZZPLrtirIpXzVxIASdzdrRpOguhj1v8JGuSAaXoyHXDKisYOjFCH?=
 =?us-ascii?Q?qYJyWHPaTBGpXdmXzEoofpg1xUkhylEmhz9CvHDDLi9Zxt/xp/mv4atoqTys?=
 =?us-ascii?Q?BoPGR5XRm+2Azop8VlLWjDbuCz+PAhBalJGpz2U4FKNQnzTwTUthyvkdo5Ai?=
 =?us-ascii?Q?Rk7/xDLMuloFzVAhRxnfwvZ+bjYA4Arrd9zW04L2sEYlcI3Pdoei+8ZIPpNi?=
 =?us-ascii?Q?2GdcvAqUMR2j3FTpSCAEhUAxZqiqCA0cWgRUKYPVlXiU6K+YNyEUA716JZL7?=
 =?us-ascii?Q?74mgxcXQdDqfhFwGxbWoWCJzPPQAemNFs1BhGxT1cCsY+P5/OTd0RJrnzRSn?=
 =?us-ascii?Q?DEaLkNpJPeZwShP+N0ZS1rCGcpfTe1d74dpy7ZUpdNlpurrvaYV/9D6MHCwq?=
 =?us-ascii?Q?KXeao0EzthqBAghhgEFGHJPcce1ytUxwO0xnxBE4RvibAzUN43J6cauI+Dc4?=
 =?us-ascii?Q?5TfLi7rBO2Q+b+RSsz48PMzZsckRl8x/tcPieXQv7EBHCpGQ0UcfBdtXNECH?=
 =?us-ascii?Q?WzUzIXhxVmqyVmWO0gJm4e31lFg51i0A9i+Ahpeq4lYpkS5iAThY+QxDZPVu?=
 =?us-ascii?Q?TrBRHbcr6hCmjVWk2I8K+PRxSMSJEhrPpTGgbB5Yw9PSqY/fwCib7PQfddsS?=
 =?us-ascii?Q?/X19yUCE0F2QPrIi/VSJAKT2UiIWFSkofTknMPHBbo+oFY2JdvS7qpPkw6/c?=
 =?us-ascii?Q?I7pzF0sg8TYHqejUu99dOautqm5hUwCnVVsdQ1hG/YdWLdmHk5+0Mvu1c9kH?=
 =?us-ascii?Q?gvHdNuXFwm4GGAZphfOT2Z9U6tmtjkEO5qfj90zE8czU4lCCqoJy8sxFV2f0?=
 =?us-ascii?Q?xKWe+rLhHr6xpaJli00vwBCZ5UNNrWBXnXs2SNJQU3E93ccxDEnhKanStA/m?=
 =?us-ascii?Q?Bj6VIek3gUR0kfX23yrKCudsECcCLEc1FY7kUo7WAdT56sPgC846FQ73+Dli?=
 =?us-ascii?Q?xHnv3YiuLMXHaaQvSKZEmxr2k+D3EdGZSQVddRSBIAbTrisMvziSEUDurIKW?=
 =?us-ascii?Q?K7Lz1qXCnudguYTjgSYbmNUqT8/449mHZs47Hml7fLtIca28nrHpzLNqZuGY?=
 =?us-ascii?Q?FsB955KChG9x8Lg8FfaXzp0yb/lBWWF+HV3WKEtIIMqG184EmrzYH7Vh1mmG?=
 =?us-ascii?Q?vSTizAFIyUoyUBrX1jc6oIQ/JN9SNQWNiWD1fYSfDmjhuKCkDu1+2pqhrSTn?=
 =?us-ascii?Q?VDSOQyP9MGvksE1WAndUVKDT6N+M/0nZD4tMMkLeMFNAloFZKN+D50hfSu3u?=
 =?us-ascii?Q?Tc2PeTpR/A66DpAXJGVrMtf8FMKbaujeIBP89QZqlHwo6j0pP1+8oynuDkhP?=
 =?us-ascii?Q?nlr4q9ZHwP0MpqU0i7T/yWcXc5cWrSLK8buV1YRIGZLFbdXN5UDgr2idP1wH?=
 =?us-ascii?Q?BF0N8d2hiuRTjGYaUxD57CMfVT8ELg77gaKUqwJGMFEmfRuJi7YnOurdVM7L?=
 =?us-ascii?Q?pU9ZnEO4lrzeZ2fwBgJKcZbQgjLjmvUR7RAgut1TCUNuBU81o4kJFSjA23SM?=
 =?us-ascii?Q?+iLmBSIGZfXqhFTz9YFqMDivwaZrkkse8gMpVkiXjroMIToJoj4ry3SpoaE5?=
 =?us-ascii?Q?deuoHhtm8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uy3qApV8cWSLtMtRgJoe65wAlk0tNj8cdzylIbFe6EPOEfnz7OAAITlNAtgftUQdnHxQRBIricuhGV1egwhVguQSVpkPLQ4tkKQFF9r/xHDkIFRqJ894nsiIiNIw2JyaSaz+EhSLSm4QR1pOQH3u10vNPuLkzZQWwbv218hruYx+iYgsQd9Y5XGvc6KS/lnlCp5QGwE6aUYidIbqrXCC4KJBurrmq1cO03MjLjGGoo5PDhEOhc5128G8Xjs4iO3eLHLwvmK0uxW0RbUu0gACZpJBB9NkQNz/4BC6qN8WS/SmlQKA4+pf/0E8xwPPtsV4IQsCF6ft38Vw1AQ3M8/eK7Yn0/BgW2SlcjrEIXFmqFTU+IFnMwALkCp1EBRmT2KXPKD1Jzvpyjovni4jAbF/7VWFfBysAKozO+IXSGo8qkNgkZHW1ieb4AQOsKzevunHfUdVQze6WS9b3pK3m100yuy1/a8JeehQNQnamO31VYD8OddWmSNxL0ex6Vs35WnrWyGiioHrz6/coqAGORwEs3zKk5lr+RfbwEmIVJJJaYVRgccegtCKRP0J1Ihr2HabYomnHyhsufNjzVJtpoTSyjzsvbECNowPV8xDNZ89CrY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152f86b6-29d2-4cef-ef7f-08de4ea2f935
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB7333.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 10:45:00.9379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfsJJvXM1vYHs2aQJuvSWVbeRIvJIDqrRwhmeIqC7/2CtuoNSRobjlI67W07Or80XqfPxPRtTqbfoNhax+dm+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB8215
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_02,2026-01-07_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601080073
X-Authority-Analysis: v=2.4 cv=JNg2csKb c=1 sm=1 tr=0 ts=695f8ab2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Uf9Hg8gT9vsuyMyUGiQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-GUID: cAMONXikz6wvq3KxTVsLeA75p2mjLTta
X-Proofpoint-ORIG-GUID: cAMONXikz6wvq3KxTVsLeA75p2mjLTta
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDA3MSBTYWx0ZWRfX1/V9e38vpEOv
 GnSs1sxel7EdyW1nCdTMqb+132o2RUnOF+fOLObtoTBC17gDLC0JRR3XsUiz27aoOCAiP8E1DTS
 bt9Wz6d1xwg3E7t3J7oTF+9uX0vP0k9kxE6zr2BYo/rycXWyi5WjwBa19LCGkrrLc6JgIh3roJD
 YtjFiqkZVJdmRQ/rJnK+SbpOh2IiTRinqr6p+8QHUqEPBwty6kMf56elhHSNqAeNbzCA0P3UYxa
 nyOI+SpvbA/xCWALLZys5A2R90eNjcJmxc6DU94BLuLN5ShQqGiRkLAf7kk8/GxucLmjMM7atXX
 +B0g5iXY3AoXd+iFc4p18xuQr4b52shkNiWzlid3pbGrWENebqvPiDUFULNeEGwWCZO6yNfXjCa
 znuYHmZgEMO1knhXQ6QK/7Ww7sczxIXJdFcRQg9T9XZbEsIiwtW3FvaFM/3WZLRTDAo1QgWa9Qd
 ryRrzpeymBHXurSVc47Hsg5UToYwLpP+u3fjenmc=
X-Stat-Signature: fzw3wry7jakdyfnwx83mbri479h3ndwg
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1DB840008
X-Rspam-User: 
X-HE-Tag: 1767869119-139357
X-HE-Meta: U2FsdGVkX1+PfWr6dgjFEfGo4VTNCEtrzFYUs78MwgzJbMMllCLYZcLmPbXFJafgFIJ66tfilDLVaT/6m7aULWD7AGJHsd65r42SNQXFukkUgh0Sjdz5tCG2o6pXd/Irrb7LOTkJauQlKWmpMulwNx60gO2HNHEv4ttcszrigxOg3+x7mT9AOGdq2I5cRqZB46GLa0gK0kIAtPhs6NUbHS8q21FNlYa86WUUHlL6Z2kGHd3RXz90EF+cLm8EUuXDhe/TT23+Z/V75a/LPmiBOitxbzI4415oov1jmwueY9OGdSGfClEOhhF1NxUBPyNuTW8lyhMX6SK+ibl95wOYgs01o+G0IieN5K3SkT1ihEb7TDHD2UKu6ESudWCHKd0FdbjekswIysgfpex2Ip/a7IKojCeHMVsonDqNwMh9M8G3WP9ap5924wdUuCnvtZWieJlxEqVlOoJx0Sok6FiXO3gcmKtPpTICYpWexKDz0AWxw9t98w+Bi2lIcoHaHtLIKU7J1h2BKAX0KdwBY/UQTkRvch2yH2IQhQwAUbb9WAQ1UJIblZf0PZpc1dUNU5zD5OEQWfhJeEVgG/qj9NrcjLZLSDKPod3nJRTmDwMbwuWDU56eZbEjKs78DEECBeZxNGmppjk2yk6b4ECDF1Z7qWScZL91xW7XYz6PcPsfxpxMluNc7NJon6e6CQL9zCU0wxykQY4977IuC7oFh0fc7w4rq+Sbl+XWJpP0XLXmaOBdReV2+KD/ulvrbdRvxec02Wa8ElzxZMQi2yLiihqyCwkWz2lcpRaT0B+FXt9o8psERf7FOvUHZEj8CIm1XiVR1KzYKdup6hYFWHtNJ4d6xZKkc24/Ouf//FOdsngeCbTRYBgdJxgsA0l5/DoXKbkenvwlbXTlqfaYIG9avH67UwM2dctMUgGnaRro+6WxkXkz1yGrcmUnZ/VVcpWnRETOTNlyFWkN5zXrFSk6Q5L
 c6+Ar6NV
 y3N6pYSzMoXNOAEHtscXkCTlBBVXIjFEiVqyVFJ4QfA0EdoyJThZvkkbs9pVCtO11aW5ZJO6qsQtJd0ahtnFe4eA9rtan6KqbJOP9Y9HyCGKtN0VydQd4F9321WHGQC7VPDtLnYv77/Gs9c8kFDtTp/meNV6Sd7kX0FHUT7/zdwiAyEFCsRq5ePHg+jJ1mi9k6K+d9mnRj0LHVa1dFqKMtyCfQVuF43PWV8ZG7K7Ezl+ARoVJswYqGdHbJWxiy1STYqOnLbv2UcC/oMnsLvR1Oh+aIBW+DOtErjV8GI8wkuizsDSs0LCuPFi7x+Ho6jpK9PShNFMcItiJdCmF4JScpBD/xE6FGdDlXyexeR7RQjI2tT3LKUId6XIC9gb0ZVEewATMtvEajZ8azK71wAfsp6+qKxkTab8mpOzwR05Q+QUSK3rA2AP55sHyJGZ/FjOh3nTUlVY7p8dP/D5G5BN/e43+wVRByKJbpiJTyLoSuzANPA7Qp1vysg6H29Cylzg8+rEhldu6EulCmW8A8Rp8gYjek3r8t8nvOmlTGe3VJ6o58Cq4w55LLJK1p/2FCvgiy9NBRCG+sqDnx3eWIO8YD/BrPGBaxtfGXu8ZMN3QGwGOTo4IrOuXbpnMqOxRsLDRntoiU3EOVQxBEphQDkDLaDIZGxSM9hFINfl2+wOxZHUG6GI0/+SwQnL8VW9MggDnCrcBVzo3kT5wsVLQ9DerYsOeWuI/9nVN6jSYoLwHx5TzOEWMq7xjqXCV5HVry3PzGuXRJkWbzOZN6FV4NKPsp+mzQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 05:52:27PM +0800, Hao Li wrote:
> On Thu, Jan 08, 2026 at 05:41:00PM +0900, Harry Yoo wrote:
> > On Thu, Jan 08, 2026 at 01:52:09PM +0800, Hao Li wrote:
> > > On Mon, Jan 05, 2026 at 05:02:30PM +0900, Harry Yoo wrote:
> > > > When a cache has high s->align value and s->object_size is not aligned
> > > > to it, each object ends up with some unused space because of alignment.
> > > > If this wasted space is big enough, we can use it to store the
> > > > slabobj_ext metadata instead of wasting it.
> > > 
> > > Hi, Harry,
> > 
> > Hi Hao,
> > 
> > > When we save obj_ext in s->size space, it seems that slab_ksize() might
> > > be missing the corresponding handling.
> > 
> > Oops.
> > 
> > > It still returns s->size, which could cause callers of slab_ksize()
> > > to see unexpected data (i.e. obj_ext), or even overwrite the obj_ext data.
> > 
> > Yes indeed.
> > Great point, thanks!
> > 
> > I'll fix it by checking if the slab has obj_exts within the object
> > layout and returning s->object_size if so.
> 
> Makes sense - I think there's one more nuance worth capturing.
> slab_ksize() seems to compute the maximum safe size by applying layout
> constraints from most-restrictive to least-restrictive:
> redzones/poison/KASAN clamp it to object_size, tail metadata
> (SLAB_TYPESAFE_BY_RCU / SLAB_STORE_USER) clamps it to inuse, and only
> when nothing metadata lives does it return s->size.

Waaaait, SLAB_TYPESAFE_BY_RCU isn't the only case where we put freelist
pointer after the object.

What about caches with constructor?
We do place it after object, but slab_ksize() may return s->size? 

-- 
Cheers,
Harry / Hyeonggon

