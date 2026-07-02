Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3504C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583AE6B00AD; Thu,  2 Jul 2026 20:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0826B00AE; Thu,  2 Jul 2026 20:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C3B6B00AF; Thu,  2 Jul 2026 20:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2F7E6B00AD
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:39:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACD3F1C0F32
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:56:48 +0000 (UTC)
X-FDA: 84944289696.22.FE57DF7
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012046.outbound.protection.outlook.com [40.93.195.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id D1499140006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:56:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Aax0+9DV;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783007806;
	b=Kbziw4v1FxkH43YdBbSh+aGK0OS791/gdxKNz5FUC8XN8hmPj/pQ7u9pQQhJffaCX0rWcG
	DRjYHR9L+344vN2Iw5y7WXTG/KorkVfPMW/+4ki5lOESuAhzjElzMHTblMOqYhdrYUJCMg
	VR+gZSAV2NNo5kyHO3JgPhAg4Bkvsa4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783007806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hRBb02wH7755t1rVBLbDnP7OfujBrJewysVoSDevJk=;
	b=nTPE8yGkJY3g8gzPC74uTtKpwvMK2SNmE7aaIfc33cEXXW2G0nTo+cm+8qSG+dPCWbDAK3
	VolXAtu87gc8V02ZHd11KXEyiD7GI6J+ilre9B3FxrpOWkKnBxXsy8ZVFRqHD1v25wkwTR
	X/cr1xmV47zr6EQJME8IO7ADdtOfmGg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Aax0+9DV;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ia42XNzd8PA41RM5NzP2034StEKJXTuV3BmXhBeFpxUtbVCXtEyeAUv7l/OrP3RNtyWibbZCAh5L+Aj8P+NkGNPChk5T/KFKrFc7BIVVRgf8983eU9NLhjEqN6m8r5ovW0GDcwjS7QBG8PvqxTc3OYyASClYc49B6lrs4DoxD4xBx7ZIbDOq9U7xWg06SZPOgJnXQ9euDfQkETMSgrcxRO9mfwmJH7cBte/i/OyhCBJ/W6WW0wnfUcJR8e4yzpmQsM6yovJ1qalP9R3I/9AkQUFk46o3R6JRMyTDnvzZ4GOf7MFT+YSsmUVK/+Ufl9P62rfXTACo4+j6IfxrQnaQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6hRBb02wH7755t1rVBLbDnP7OfujBrJewysVoSDevJk=;
 b=ufRYXFHwJyAKRrTAsyn+TS1nZmS8HDD0PwnLcttvpV5UFni8mlI6MXA0IlilczBSymgAUm/iWpNMaxSR1V+Ky+I/j6KC9AfxRMkKY/c4Ak8gKxoEBbXp15ZQZhlmc08iDIEJ+FuMOPrj4oSLuwqY7jcloNhnlv2uJCEdX50k6pN3g+woJEBwwhnvc5apIbJs007E+scUIDJGA7bYI2a/DWZWZvqBE2j4POZnPB52UQ4nzBIHICqiVuiJ81dKFeI9v6fLpGQoc30Ae3fuJukKPLkpLnkn2ycwvNL/PhBP9xynQgJ/TtYOJQIzwK59eUnqGFkQpaxsxeyF8MnnUNBCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6hRBb02wH7755t1rVBLbDnP7OfujBrJewysVoSDevJk=;
 b=Aax0+9DVTA0u6C5smREFK0G1NVdE8+qHWuTFaJeathdYNvN/oRKRdhMB2PrK1PQHG20qFiARSu+OvD6t/4TcxozBZ/3MzA/RIdqdC0bxPIGcM4vnzaVoZg1Sia0sXgSAwxQJeFwZMCZcspWhz0S5DLfNjxFrYc0v4scf0RoQyexnBkT4c1XoFbxBIQ+NCsWJKDUSJ0htM3nWMuJviZZksECfjzvxAR20XSq6PJ4tfQOdJ98z/Y6pIRtBU9VV2DC6DPE0ZHHaeWCa38wrCHSrNf6C2o6iBUyc/4ljK78eU8LHGcO5otw3P2fOgJC/PEOoWDr6ADdOgvGrTpRSIrPqrg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4399.namprd12.prod.outlook.com (2603:10b6:806:98::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 15:56:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 15:56:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
Date: Thu, 02 Jul 2026 11:56:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7EED2F06-D536-417C-B9F5-DD0419E9DEAF@nvidia.com>
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
References: <20260702140257.44780-1-lance.yang@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0028.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::38) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4399:EE_
X-MS-Office365-Filtering-Correlation-Id: 66281ebf-59cb-45e2-73ce-08ded8528081
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	lo1ikxk+u86djPih+8Mc8Xg60xmZuwZbKEGOvvZperdJE2QtUXEYUNG0f+1+MCkwPY8KPL1fByvV+rnLX51YTxYrSNKcrTb+Nly/jAmJlwPX9+qu4kGxaW6+6zw7742pYKHJGRt+sQ65OPIekKkinMr7u0Ra55zDNjYanmLDsp3661f+Vv4r6ykMAHE/jZMbFM+6amhEfThB7ffh9bpFAgRgWWaQwfdJijEu7nQxRRmC7b9S/mUw6Bep6iHGNrq9HVK5Qct57MJrdv57KXu7iq80+uuzL3W/XNbIAk4nzM6u9rpazEC+xYx8TGviNmuwHh/0awvNwVWl38jgHb8B759MEhDinppKbEs3uBWbvDdwiq3gsYk1pt9VI60iUB7Znpo4dh+HnNrByeSiee/pT0hgkRqsT8w1/9ZefA9Ycxckn1ANH7o0PrBJf6QEHSGaAZaRLS9pIWo0UOH6KKJwkslNrLjPdqqJ2nhMpctAoW9AZFi4/0fYdczoHvsgNQ+PqcAlhbUjZL4H4et0nizR1HqpXFwLGqFHaakpVonDAXr3Pc8iOuqJBX4QgkIY97nQn8bCGEYRTPBOO3p40gQUeg0kK/Dt7K7rqyNGIL2jtKS5z6BeeQGc+m4W2BPKpNcaUyVZnKWBKXWUE2LhIP69TxLOUGyq+wSwdo4SF2YO+iY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vgNo4/NwQnTzwzqVSK087cOZjA0/Mk2K7e9H2ALl+X1vEdqXpI0HCo2+nD2j?=
 =?us-ascii?Q?HTthsLObW1vnmNutP98jon/sEL9G13nZg2drvGI+qEgXAruhehy/VKiQECgg?=
 =?us-ascii?Q?9G99NIda6Khr2LkHByygdk0dptEP8s5zUfQh4RQxSGHIx4FhGRA/2AypTJx1?=
 =?us-ascii?Q?jPfXt8x0G2Zk4DMbgH1UILl/jd7PJWBCTcwZDnBnW1XLMtaMaEYyg5Tho2g7?=
 =?us-ascii?Q?whIRCUOH7gMH26USWwapwATvibeLxmCFkGWTs12quO2mA8KmDgmXUdWwmHOU?=
 =?us-ascii?Q?DVhLCUAf56DtxAXgbtOQ4IWWI2eGWOBnStXNbR8HuQDdw/H2XDCjosCdgJT6?=
 =?us-ascii?Q?x+aimiI4puMU5iU1YKf22fR/pMeTwVfRKq7rFcvtsXgPg+nSFYZFJ+lIJRbI?=
 =?us-ascii?Q?ZJj33HmzOGHQP9LFH6Cg16EtWi8SbYQuK73t4Scpa9F/Gf5cPiphIpLpjcLZ?=
 =?us-ascii?Q?xDJZ71wy7v4johtOOF7+w1QkqeQRRLbLGEIrR+tyvj2mkiSBPCbVfTwNyUpn?=
 =?us-ascii?Q?rq4XXa+OV85CVCvC8Ju7FDht7xNPQA9gaRa0fRjs9wqjzUUWYAzrqhvLhnwN?=
 =?us-ascii?Q?cpcKWOguKrkgftl0B7QAwRqq58SO6sG0Rdi/lo0jOBPHi426qsycKfCnELx7?=
 =?us-ascii?Q?oXRdVKOhiKXIlGo76JADqjbQ6f2DK5a8TLGZzmSpEH+8/q4kQpKDbNnsMKxT?=
 =?us-ascii?Q?GTg8pvFrmyjHKQLYHJ9ylVAaHCOp4lXX6idI8uZ1IAuzMXk+N4Dz5+DvZiV2?=
 =?us-ascii?Q?Z0mjm5aqKEH4KMgSng+Zm6J5f4y05kRdV18ZyHK/CCMTm0l3/EYxiTF0tjRg?=
 =?us-ascii?Q?2KJsrG4rMvoXXsc0hc5W+XshoA9EzuYDqy8IWqfHLli7f91Fd2KfKJTmIOEt?=
 =?us-ascii?Q?yDd3WaJWIPgtWYJFykt6G1myLNZdK3GKXLi/h+Rik8qXjItMQh2p0hmLJ5Tz?=
 =?us-ascii?Q?mI8VIfL6RlfH39c40j9rdVLIuqXi81KcDBcIEsjjZsZIoK8+ZE/sTTIeZDlv?=
 =?us-ascii?Q?n9BxMNsMstNr3P/Vmovm9gsO6nHJl1dHEEqktTwdU6o5pf10zsRerK80VJxb?=
 =?us-ascii?Q?GBlgVN6j0tFUmk31awEdKIsR9aT7G4/HPgvifL8C6d/1uiIgpuOm17mwUxX3?=
 =?us-ascii?Q?tRpYD569se9at8VeVkwnhTYOHktbVKB4YtxAcjfiM0rwIluj0rlFU0gil72l?=
 =?us-ascii?Q?DbhaAI+HTrmUC9ukbcy9OPznqovJYx+LZQLTTRHrekR5c0Bd9H0DNpS6LSvo?=
 =?us-ascii?Q?8e6aea03ZUl/xiXBX0J+69PBZvX7EoJhwAgAkeNjxoxWiUkjn5phS9oEhhwF?=
 =?us-ascii?Q?U3OeBQmVhJdXEoQ0c3c/U3dr5opOrJl61u0Dfg39m4ciqfnvAwDbd7Sipmpd?=
 =?us-ascii?Q?dNvTqctwk3qmYORapAC3zR57DQVW16EjqAbcZjkgti9W2PBqyepCj3sjddY1?=
 =?us-ascii?Q?NJWo3HJ2p1/ksObGroMDpsh0g32zntAmzn1h1AFnyOofKG6PoXIrcDBgodvy?=
 =?us-ascii?Q?tch8FPXj1pOQAq+rSDW98NHAMdY2Y6AbNyGaZnKOBY3FbmbqQjMoen5wGQnL?=
 =?us-ascii?Q?TJWGgTkVbwdCh5axp2rHtmnHm6j0yKmYPv9HC+fCC6dehTas3SHc0frevjD7?=
 =?us-ascii?Q?Qo/GOEwERxIWqMG7z53/HFZ3Z1r8tEkf/dZuYMizuFfDLvx2SozRJQeOKtRf?=
 =?us-ascii?Q?owKXs04IrA6eQ6hUEON8UHqBH+P2EznkgSmaHf5KdAfm58m3nAIFkF9wXplX?=
 =?us-ascii?Q?MePzihNR7g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66281ebf-59cb-45e2-73ce-08ded8528081
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 15:56:38.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2exiPy9sA2O02ThA0LBDweQuIZT0Ag6zFxqUTe5flG2thM/H51eZZ4E2Rx8Xk3Sa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4399
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D1499140006
X-Stat-Signature: qu54kyrny4fp8ubyu6ajb3cfau6bg4bd
X-Rspam-User: 
X-HE-Tag: 1783007805-761738
X-HE-Meta: U2FsdGVkX195houInBfrUPUvh8ObmFj/kqbYWYq7WuPQiLTqmsQPIVSQaxxHoluyn2OvyJUWyRfVdmxddDYc0VNjhdDc/rksZkytZ1stJJZlLyeGzTQadD49gvROHJws3q8CROK+v4lcd95Cp5YYUCGBWhmF9YzrFa9wfq1JS9RuRI6EL368qkQ4HbkfdinnIE80i+E04gAOEJaVZi3VVJCrERYWpgUv2+kski4RvJ4ROgR4P2ptJVqAtBR7MXZP1vvcCTdLqPNWX1Ik2IdMFOohLcRRn+COeFltCmptHzsJcQdbpOOXNbHVybkRqMcrNtY/C9BluZ4azOM5ygdpFxk4URfJUzJRilgctQGQcviZglA5aZQ3+Qld8gftIfh/JbGgjtEDqycDdSq+lSaqm4RVoCHNwuX4C1/2sBcKdNuGt6VhRAAQN3cSZtLLyD6gcnnLEut17zJBh1rpLDBIbd1ugRAvFLrQvra/IPPd2RFKpE/CEYwT3dh38elCrSK9TO/ncE8ESdg+MDgfJKUHgyiE9gsRcxC0q9DuA9Ah2xZbYIyvhyf6UhHIwiYGFF8brlHbenApLZDtckyGW5xpanz59TSYOND6o+5uHroNDCB/gfrD41f6VQFXJKqfk0Nr6HzO65JJvtlXvYkADnvwvWFx8hY5apFlTvCM2gzjEB5fxxa7xGSIg2WmK8g2jgLl+qiXEv4aJe06Uq2qeVKXO+6O1Uf8xPtJYGJwHo0eICY8CvKE1KV0hiOaqEEtWDNHKLsCSMKvrVXG1UsaFXybisLi7J3XD1AJcKBfnsnCP4Ct6S5Bm2sbGVYnpNb3L0okIbUSZif8urKary7a1L02iHaK5cZjpM6aszCODNHI0rC2Flmf08Ct72gQOAP3DNA0/vJNS5poSnOTNuP62v8Sj6Chzli5h0n97Ri/Zt+ozhRZQarGamj/XG4Nkq3Vp62rAwuBygo1y0y0GToV/Wv
 2AIurFDk
 94pgdAp5KoguiC4tNF9M4ZvVs8Zxmwe5yY7op4VXdqOcRJJTC9vzZBcnGyCX0pT5fQRL/nVchim9b3SUKVQnL8f1bS/KOEWuD7nYnaKzS3uEE641YEsMWAebywJWkwOhYMb5rEJOEZBmDc1BP6xruux+sGkxsk8Swy7JSEFyOjV6LF8MDGrZBR4Ss2qGC417K6HxxsIUnFvKGgBrEGF/s4AWH7cMcZGRwV/8k+iHAHDF/UlUwgBZXcsnzFCVuHMNyJKquMHxAdp2XwTWh4NOKPs6yXiE8Q4gfauPByzy/ES++RMhcJUVxY9WsgWWUU1waTo6IdiFElRSFd4VPgjLMYcuS+KK1cqkKlIPSMlTU53Ee0u+auwJGNmzsjotdM4NPyuTEWdbqONztmiOtUsG6hjiDVS2YVDrlzwNsSe+evSWBljCVqUfmw2+hYU5IyekX3ShDf9Jqf5xIb/JT1a5W34hkcthI2pUz3nS2t4RUo4VXYlLrji6PHOO+E9tYdRb0vPTo00jcemilJGWxrz/KYLr8vkwkFrSgjXk17P6tsv/kaqZFgonH/uzZNJu3JkY9vYo+yCmNgdzJe6mP4PGIbm6vDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Jul 2026, at 10:02, Lance Yang wrote:

> From: Lance Yang <lance.yang@linux.dev>
>
> Usama has been active around THP, really enjoys working on THPs, and tries
> to review all the patches that come in.
>
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.
>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2acb019516eb..29c302e9c17b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17255,6 +17255,7 @@ R:	Ryan Roberts <ryan.roberts@arm.com>
>  R:	Dev Jain <dev.jain@arm.com>
>  R:	Barry Song <baohua@kernel.org>
>  R:	Lance Yang <lance.yang@linux.dev>
> +R:	Usama Arif <usama.arif@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
> -- 
> 2.49.0

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

