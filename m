Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 552C5D5CCA5
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A805C6B0005; Tue, 16 Dec 2025 05:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61F96B0089; Tue, 16 Dec 2025 05:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B406B008A; Tue, 16 Dec 2025 05:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5C46B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:17:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C15C135D49
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:17:08 +0000 (UTC)
X-FDA: 84224931336.18.16A9C46
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id BE547180017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:17:04 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QD6cM0Zo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tolsymdx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765880224; a=rsa-sha256;
	cv=pass;
	b=rypnJdmIRpxdqW2dkZ7CVX7hBK1oHQ4rQ+FHzgbcn7g4eSOEQTZVOSFJxiDEG2A9LpVx/S
	EJr/os0ZnH5qHjpPuGobm5c1y2z2RHqhcVIninekub5W2dmxGaatXwpS5vDA9pMsfhrzAy
	hrLhYCDQfULP1hm7HxQR4bpDit/PfKE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QD6cM0Zo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tolsymdx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765880224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJbKk4ETVZIkGBJ+Mf9jCOh3EEZMMGkzIx5ASwJ2IAY=;
	b=u+TfXM2fC5kI4Tl/GD3SYsCi+PiZ0VLOjwG0YtSjXt3JaG39E90EubOOLXN8U8Z3ezS0Qg
	9/OC1x6kfWS5ea8dAQBAr4JHQeBIYof2xu3IeiDf6HsGyEZ9D0rWvkEHrfiye1bcdk4V70
	neKewpRi9rk2/QtQYFbilTcP63/YrJ0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGACMYK074902;
	Tue, 16 Dec 2025 10:16:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FJbKk4ETVZIkGBJ+Mf
	9jCOh3EEZMMGkzIx5ASwJ2IAY=; b=QD6cM0Zot2f4AmuwlR5AcchQysDEADxlvQ
	fZP+eubcA9ITVRQEuWPdi0+wvbM699IHhysVKEh342fVxHTpNFea0TpgH/l9lRff
	aqyfxuPgpheUVslXqU6picMu7lsCcNE8eujswXltHNJgQ7z4I8eKwyoM9TEwgqb4
	Sr6L1BmxoUt/ocdrRccYG3u++kCiB/mlxiRFO62Sfq/ZsBSxdnuLexKfQGwd+xAp
	NgtdE2NMroSVVyaTJwOyHTD2bkG6CJ78FMV4jHEW6j2p3ykp9pVc+K7IZz+f657w
	PJUXdFaStcqe1BspJqPavlEQw1ohHQ8E9XhQjsHC11x41Agt3Kzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xja3pbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:16:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BG9u64n024790;
	Tue, 16 Dec 2025 10:16:57 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013030.outbound.protection.outlook.com [40.93.196.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkaa3dg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Dec 2025 10:16:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MMd4rlXFqNjs72ypvd8DDZayQaYfQDlsCgt74Lku0Q4AHeLG3rTiKdUiWlPL+1c9b/QVEXVXdIhggCot8pk+cSQSew+uLUgu+tmwiEToK81KNtWXANi/+bxUDTK+ioUKKrDwXx3MmC26E5qKSCS1c1MTIv7fRRmVD3vF80KeY0ob1Bd81kp4W3FT6/OpxFhAv3UkJZp1vj/YS34262wmkVgIVomv21+UzOfJQPsrsHkyG5uBY1uoYevKBYmyyeXYollnlbmdGRa0062Mtx5UpR1mbfAShU99OELuIG2zlB/z3Vntk/51RLNvYN0iFMtz686EIfoJWyk4tP53uVY20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FJbKk4ETVZIkGBJ+Mf9jCOh3EEZMMGkzIx5ASwJ2IAY=;
 b=J2OpCM8mh4VuSfG/KUxjw8UpPbz7F5FVl6k1jA/mD2sRzarJzveGfUw2CKnjeU8HYBP5ggOW1avcEuZNKRHjAlmaK1FFQTExCeLb6uQ0ag80jwlqGGdjDovjEiVifVB8arDGU/xom8/ANt/Q2p7C0Zbco69MXGW9ImJ3kJsrCT+BWikU/CQVk9AzUuvAIv79V4mL9StsLSFhCYD57eSki2I85C9QETF1lesNwK2bYLouUzbvmUZ242Pm/JmSEAHLUslpCiu3PnFToquDNaAr1rQpOt7HrxZPaopFAibnK/fbs6kpCtqqdr0ZFo582bV1Qkv+ZLi92uSw2HIhkCI4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FJbKk4ETVZIkGBJ+Mf9jCOh3EEZMMGkzIx5ASwJ2IAY=;
 b=tolsymdxRjt+SeYaIMtC8wFu3sNtsifADrojdA7B8MqY/VRDBbod6LBxut43vBcYnBM0+GNgty+J9b2hWCZiembZQ9+DVAPOh6B0P14aGO3KeOH70r1fpRtx0XUFPPkNgE4GBI1+0w/mqzsUPrtzd3hlExzbYYrx1Q/Ra3iKf5A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8516.namprd10.prod.outlook.com (2603:10b6:208:57d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Tue, 16 Dec
 2025 10:16:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 10:16:54 +0000
Date: Tue, 16 Dec 2025 10:16:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anshuman Khandual <anshuman.khandual@arm.com>,
        Gavin Shan <gshan@redhat.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 2/2] mm/madvise: Use set_pte() to write page tables
Message-ID: <7b37618b-74ae-4806-9b3c-3ecfedeb257c@lucifer.local>
References: <20251211081117.1126521-1-samuel.holland@sifive.com>
 <20251211081117.1126521-3-samuel.holland@sifive.com>
 <1b7e682e-86a4-4573-b423-65f9755f71ea@arm.com>
 <5daa9569-a3a3-40ad-86d4-ad47080fa5aa@lucifer.local>
 <6c76b8e6-3e39-41a0-a4fe-9012c3eb8446@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c76b8e6-3e39-41a0-a4fe-9012c3eb8446@arm.com>
X-ClientProxiedBy: LO6P265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: e733386c-85a3-4966-4fac-08de3c8c3c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z+Bf726ipO0mFcnX3VfK4cfPmklJ3cjbGGPv0VjJa5d7+Qi5l26AZ7epRdbk?=
 =?us-ascii?Q?kRb/LmBwSkIRrruresbZ56BNcjjhirrggilaVN5EJ4YVwMoo8ot83IFT5+rP?=
 =?us-ascii?Q?LnmXanRD+FYwWvQXXhjS5YNn7RucVUeMcleHZeFN6HBwmK+ncWBepWdIklT+?=
 =?us-ascii?Q?CcXiWi+sxdsO9NiRoJDbSiW7Ep+Q00M3RWSD+TTxMEPdtYRz5SWwsApnput8?=
 =?us-ascii?Q?FXLxIL4LbOis4C6BKUkG9wgZ0eLJLLNUObrMW6awpIrpKp2mQQN2n7zM7GbI?=
 =?us-ascii?Q?gphy/VssBAFPK2xSBLBF8V7MwWMLoaLDW14xta8cupV7L9wxV1eMQNL2CVlk?=
 =?us-ascii?Q?BsCX54YGYM2siG1BAlNFMfmpYbaiHx23uqmjDTpP4a7Kd8iKVz6HR1RSgW7l?=
 =?us-ascii?Q?6l/iMpLLwBTM8444hIAGJxZySCFR2QO+4yEhK1PRY4KMx5ya5LuMXVxt6z0A?=
 =?us-ascii?Q?l3NAiwjLaTu4IwgALoDAHvjKlPWn8NAc1qeliHBR9HNO9td1VYev9ErCcgp2?=
 =?us-ascii?Q?cNE7v/wtLlyri+eB0NvpE/ptd4UzcxraKuCEQPtikFwYBKvmapIy6hLJtcPp?=
 =?us-ascii?Q?v/1vSUgJP7ZCflN7IrSNyGjJMoMerCnkIc4N98d4bK4/3DbKEfVnl8UBCSIA?=
 =?us-ascii?Q?VXqIvnvjd/azC1Pdy9RK7jbte47jeR7VsD43CRzywbuhEaXO/m7b+vbre3pF?=
 =?us-ascii?Q?oZ7WCohsb7GkvRbQHOTaPWp4/+sb/y8alLoTgEi4tZPrKSTXkmZ8c1j7GpIh?=
 =?us-ascii?Q?/2+RReKWDZ/Zj15ZQkqN9rIsIRZxu3Kn4dWEe/f1MYJJiV6vhaVTg3So7tUq?=
 =?us-ascii?Q?V/pUo/acJNYLNzwJ1VhwgwZtgYr7NS7C9kfbbOg0Rm9aSdNJdJmCNrzc0BB+?=
 =?us-ascii?Q?rjyaF/sQC82GHoqha//mft0MopXrdbBuNl18D68CmZTvW/nDidtG2jDGXEgn?=
 =?us-ascii?Q?CGYq5d+M/emoFD0ygla2NA2cFKWUdLQ6TR3YE+mj6266OL/tqHXn4oXLlDsc?=
 =?us-ascii?Q?aN7prVksGFWUkiO1xkL/wsSMLRW74upALjBLOJjnQ+tSn6e5x6eaZPbYxz21?=
 =?us-ascii?Q?i8dMQ/rOA2NYzZ/lDv7Sg+nyh7oIV5uYYzLXwCsP6AFn+FysGVzkktPItYMc?=
 =?us-ascii?Q?PrgZKXwPoAf1WHLoaE8kcaIgR5Vjd1/W45CZh6+Z/cdL6NKdhlMDM+dmweA2?=
 =?us-ascii?Q?zkWk6BKaGm0R8Pfrhr9UMfW8J5ig0znhK9BaUS4VNXscAl8tLib45rWuAwQw?=
 =?us-ascii?Q?Q7g/81yy8i5alNtPHrGsTClK4pBuESZQ0lXgSrW9yXXDMbYZKzYINngMNgYp?=
 =?us-ascii?Q?UDDA4huzGYQFjrLjKWnPDYOuSLDbW7Lf0AnbSiGvcJ8Gf8jLxbO1R9QwSPeO?=
 =?us-ascii?Q?jhl7fuCtMCgmSkeFc4CTegxprTWiczJdc+jX6IdP6OOIAhalcoWDsMgi9Qw9?=
 =?us-ascii?Q?228Bj8vKfamPDP1PC6hh2dlt/oFZPzupDrZKoms1DswqhMpbPX0fsQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?19lFwgE/jyLza3l8o6g1uGwKfIg52jVW6GqgfMmRIg6UC73TnyLBL9y1LUZV?=
 =?us-ascii?Q?p+AmMgPRtqARYD5nWdVt6eNs6Yn/+DEvvHABbvRRv3lWEcQsVnI/hA0cB0lQ?=
 =?us-ascii?Q?fj9d3jMyK8bc/0WiXrfDG5IBVqwJwuGd+zeO9gy6xeq3yeThg9MXAqhRAdvd?=
 =?us-ascii?Q?aLYQWTxJmVHGPv50qhSPQY1K71VSUjq09fa5zFDQSG2jyiV4H2ujcG3bdw77?=
 =?us-ascii?Q?xoGhsSLBoiDFgEzGNiegTb3XKBIPuk4gTQ6Aa0aioxxJSOCoGZRmSw7Vq5Mz?=
 =?us-ascii?Q?/XzeWojnPvOsYHuMB5RYmQDlhzC2I9spB8eIhHeEQWNBAqRfShQRv3VDVLOF?=
 =?us-ascii?Q?2IX5uQH99fJB78SQ9JU9VOCS5JlPD2RMu7ZmE9G6TLWyfXcXiYoUmTZxYN2y?=
 =?us-ascii?Q?kDBM+KVebUo4aWws9akvq6ilNUXfV4MC4JtdWcLfLKgKw2eq4I/88qT03mfU?=
 =?us-ascii?Q?/058lrCP9eZwJ2/E0loJm6A/bg4qjIUhLql9F0cqOwsNsa4sSNU8DoY5Ghdv?=
 =?us-ascii?Q?cd/9rPcqWwxiou/tu1w7tgdT4TN1pgIjUn7PNcvARC5Qxb541yPhd5bmwB2L?=
 =?us-ascii?Q?toDnNRwyrqEVgZ8yAown5EExg38AS56PLAqVAZvFj4mBBn0vU7yBpwLcy05f?=
 =?us-ascii?Q?2/lLivnj6HcdgkXxke9BK501xAAC+2/9WaZJcGl6jqeLcKYT3/R9vTgNGEmM?=
 =?us-ascii?Q?0QjCoYiNzW3xxDRM4OG63iBVMelwsvItgOlFpE/SLrkzADiuFwSTHB0twl4f?=
 =?us-ascii?Q?rqRVX2CSb5VKatR3LCpOO/EqSiHjXNVmE+Nid4YcQCloSzuHfS2eEzrQEdE3?=
 =?us-ascii?Q?lXeznp4X1rZ6yHij+hg0mFY3VhudCJOAhc11smoxSV6HTwulSuORkwDpf8dH?=
 =?us-ascii?Q?Jz44CiEIZP4oAxolUwn8QdDZc6MJFV8W2G7ddXjSs+nfS76LINq+WXdLqT//?=
 =?us-ascii?Q?s0C64FXCsOlxTiuGJzWY3uNW7n0aXmTF4BoFDagXErhyQDN0tp6W2lbs1zE9?=
 =?us-ascii?Q?vuoM8MMN6S4yMer5U4auUAvy9/QtndICxJLp6BdEq019Cz0f7FTNH7NbILxQ?=
 =?us-ascii?Q?J6qb4stQjwGA7ncOZQ6LgrEfrZ2dl56Y3MljRFNfo0fN6uGYpijLOWmgpMtX?=
 =?us-ascii?Q?+5JSjgWHnBL03x3cexPb6bHjxDiIOV8QeNrc+c26YD+z7JF8HfJVhYnRdkLD?=
 =?us-ascii?Q?sgvJn4AKEVT0zTluAHvYeU9UBnn+xVBAp+BW+XuEWRaMfQwNcXl/sedPFFfg?=
 =?us-ascii?Q?LWgZn3Em6JRZB+UYgqBEadG0Rd6DEA0d4G5oaW84ilSiBg+CmJn6bVvYi1qt?=
 =?us-ascii?Q?Z+EvkNcoNDlcoS1Pm703vTQa0P9c55HWsN7C16einn9TsgYd17aXdjpOBykT?=
 =?us-ascii?Q?OqMEMYiRtAFYeWOIoihjCcFIAcybmgoelCk9Cdfcn5cM2MxVg9X/O6A8lHdC?=
 =?us-ascii?Q?6WeD57q0RjGOJZXv8iKWG8XsmtlfWu/OutyxQILe8Kq9m9Aag6ltZmQ9CPn4?=
 =?us-ascii?Q?DrTK2yIOwV/0PSM87zorEp6BmM5mbH6xyScLwZSoaTSAdq7Vh8uQi8nljsW1?=
 =?us-ascii?Q?mYRIq11UEhmKH5YqfOSNau3RYJMyYQCEdQ+5RH7vTubzUCdnuLlBzkocjh3/?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uyAYXW+W6VDYo+37+XhcmkUX6/OdzxCjjopFLWL85lZaVvURAVO4yjo3lOOn+foGl0uRMi8S0zF/G7Ry3YjLgzX7UCW/V/uECl0DhiCZeIdEf+lCvz6BBge9I2EAeZZQXA1+hgeyyTJxg1nIsud/spiowu6fgWYYebxKCj1fBr+pGfbpC6JBhB9XJBmILQkfERHoUaGWzFiuZ6ep+yYKRBxjYKNEK8HKkRHsJgyH69QHrFVpsXGhWAVf9CiYqqY/ZdEZ3n3qQDQPMFCW71ZPZ5qNQLnbTG9Irn85K1EcJAacS/sE4iGPlkYe0qpaGZvfVr83QrByyBqdpHsU6vdoe00V36yrafqsjh/Fd+ghE5lnENmkpPWoDPWerewEJP05vICokcd2JZOwrPaWTyXlpUeOqr6CrNW0wf1F6spp2DteY3QwrLj2MmI1UyN3FG4kOQhLjvavApEX8QiAFAKB9NBR+35EfzMtpn9luue13rgWvcHdXZZaoDUwjicc7QQZFJDMWWe8eBeNtrvf/0YR0hYp54TrlhO6w5AnpXmCbmbNI0Gc9dkvg3ZrovPX9bCc3b3rxGrTDeX2REe90dMcTMCUoQ6NNYXIquIhaCaMzYI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e733386c-85a3-4966-4fac-08de3c8c3c73
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 10:16:54.1488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tCW159eA7rFLlwVxbbk6TeKvD569g9gh9OENz/d12CzOo6l/ng49UsFzhpePO2oMAdmZJFps8kjoY1axcMsHYgwIUHUf3y1zsvz98E1TeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_01,2025-12-15_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=683 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512160086
X-Authority-Analysis: v=2.4 cv=TbWbdBQh c=1 sm=1 tr=0 ts=6941319a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=vxLGz6E6o0KWfnH8qeIA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=CjuIK1q_8ugA:10 a=zgiPjhLxNE0A:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDA4NiBTYWx0ZWRfX4Obe6t3zPpS9
 LC6CCS8TzI+BfY8pqJ8TTfd/CCCb6dpnQ+YWdg1gzm7hsuU9maQ1Wem7DU8kL7/yAQf2PwO2DeV
 zMlOwxgs4VW5TgkvzbOLTYa9pafM/EqluisVqaEyPqwXy22haQOMzM7tI6QM1Vhy2zENsqlRc+x
 9HDA3DOgXeU3brFRGIs0B+NaABGqFpyai+P+AKq5nuxJDBEeCA/ws6I2TiwZbCH4yK/pNw3YRMA
 AD5EUPCk1cRKAmPpopSaOKss6FLg7dDTuqW1uWcAnuXKR/z1J2CIvxrP5HrpZ/6uWvF+bpRFoND
 2AwoOvxr00kI/ndtLTdolXfowFELzhqW8JJkUOp32XGMWjUWkBw9gNLxOCSxBdZjLE3jkmHCtQ6
 XuRkjoxHmQ8zC+pmNrAZU1nIH2wDhQ==
X-Proofpoint-ORIG-GUID: yMaZTA9l-rXYLOdhIP7Axei3IHxJuqtB
X-Proofpoint-GUID: yMaZTA9l-rXYLOdhIP7Axei3IHxJuqtB
X-Rspamd-Queue-Id: BE547180017
X-Stat-Signature: 8emh7pfz19fm5g4oqahfwzuoqm1xchow
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765880224-55359
X-HE-Meta: U2FsdGVkX1/0b0gduGPF5hWVTP3Dr3QSclfLFh4zWLmaNm1qjdawwRVu1sTgIDngOG8Q0wirqRA1keK3Rlhy/tYHF823rW3PSnDrGOOR/gI9HH2JGeTA4AIUD/Y88X/EAIJpZknRsaT7j4YCLw1vete2Ulxdq+Ow2ngsv1zBDNdQb7qM0Fla9je9mS1GdnTNQzKFm3S/nttKGx1vW8MOTiwQWPawqWhq9WwCcKjny7+jBpxlTlvkIeiEpu0qL0FnAfhdh1q8ACKr+KE/8seEyRN3sfvVnSGbJqA/S/bQ8dRESXFiwP1Iei0FzywbEqHbvbD7/oprli0LZ/Iqxz/fO5qujpUFzz5kXMpP7fndn4az/Cge/7x+KKshZ0rSrofi12Ib7ER/LErvN3A/pXS8qpqaGnJ24InBAp3vzq2MdJXGapZiz0Uptld+lA9c2MQfJN328BpnuYTdcLEuveU5xWC0voKu+Rm3KCuh+6jv5LHR/rzbRWgJLe7txzXYO5Xg/0ln4Pu7SGkNxrCNdBdJx1t8wFA007sQRou4ManWkM9KpPqGtJYjzHeZQXKeaBX/3NhuFmSc1i01J7JhQJ6IxwP+EnXSvt/eOGMVisWGvrGM++Ss/kcx8Nz4EsyXELfVLk6wYuZt8z+1s0UJ2qLD3WazGcfazbKKuNdSW4QiVwRf7mQjaKigk7oIqCj9jYDWt2RS10D0t9/R0qbLIRU+C1w/aZHzDcZhIm2sVO0YmDtvXac2auCIDoPmhNgDryWp2liHCVG1x/BOAXLvZ6egEn1sMdQ2vfbipXtAeDEHX9kQEbfIrgKSY4wYCF8kUd0Jtj4inCeUwDXE3xk8VV3M41/4SI6Ag7nL9l08Bsf8dFLt5t4HgndoAIQtn0pkdpHXX6mBXVncVwdcMM9FWHfXuAVVip5KjweTrZ25MlKbsC0T3tj4T00dq57UarGVNLnym97nQw6DF/iUg7I3YEe
 xWMAOzhB
 lnmc+uiLP72nidwNn2B1mFvVRFxwjnTGPqmdfHRRX7fdcdDHsP/8EwE5LeHrwWHckJxXzmn5tRy184KBeQDnsUC2UkTmj8978nPr9TYfRQ30dxlfYrHtwXRuzgjjIjG0iTRcxbsHd3T4ers0SkRULNrUS3dYKa8fZAWrKtb+LIcQ4c9sDqgJbVJGzH0pLnyUERjWEF+EP0na6tZ1aqNIhrs1e6TY1wXp9qsvtsRUAjMhwDfLLMbbl66LVH5BbsOVdEpuip5qo8B4HvzF5xwdp1uG8quUv4erkHLlUzudQJNabpBrhR0JAVZWhi2WaH0yBv958PB+a6olEEAJ9KA1Wn2Foe4vrrHsS8yXI5PSwfQpktonxzSe3xcWzGSD3SsQFKhMP9geJRaj3t3dDF8MAmrETRGCleN5z06Tdh1E7GUni2p3MtYgxZYZIwpaXRWzKCB9uztI8j8XInHYwxcBjSQ8TSCRFleY5+g2DAc3/C/Hv1slZsmSQxddjmiQr9zuAWXN/rz08bvD+74QSKTA54cqu1wTM9roO9MfTpDDJjFs+jybKzpVkSnntjy5GnOFHBEwc44+bTKbsFrlxhTith4RmP6IyHdTMVY3+IG4VZmlzBJTyMcR4bz+adHFNh6FE4QuSrsP5gwC1H5u9ijpDDGlS9jUHi01hJPBpMdIkwQWAi4x7WcmwksmjmiAWwIa3CKR1a+xPSBg+0kDFetGl9pqXFal2jDU1HBcLs1IEOuf7oKTIa6fH8w8X1TkcuQZPt62ECqVh8pFHB9ghhwftBsU6jxscTd58Ciuq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 10:57:31AM +0000, Ryan Roberts wrote:
> >>
> >> I agree that it's extremely confusing. Perhaps, at a minimum, we should come up
> >> with some kind of naming convention for this and update this and the other
> >> couple of places that pass pointers to stack-based pXX_t around?
> >>
> >> e.g. instead of calling it "ptep", call it "ptevalp" or something like that?
> >
> > Not sure that'd clarify, we already have a bit of an inconsistent mess with all
> > this :(
> >
> > Given it's a stack variable I'm not sure using a helper is in any way helpful
> > other than I suppose to account for people grepping around for incorrect page
> > table manipulation code?
>
> I've proposed an approach to clean all of this up. I'd appreciate your opinion
> if you get a few mins:
>
> https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com/

Sure will take a look!

Cheers, Lorenzo

