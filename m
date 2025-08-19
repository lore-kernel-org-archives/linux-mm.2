Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD36CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131338E005B; Tue, 19 Aug 2025 14:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E21B8E0043; Tue, 19 Aug 2025 14:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F128E8E005B; Tue, 19 Aug 2025 14:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E03F28E0043
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:27:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B36A1DA853
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:27:37 +0000 (UTC)
X-FDA: 83794340154.10.BCBB490
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BD82180006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:27:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VOBPHJnu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fmYw6I2L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755628054; a=rsa-sha256;
	cv=pass;
	b=h3GOpYXTr27P0mrPxB5o3Wq8U1I7zMO0LbgOPVk5trLnKb/nBUo5X1ADkSGeY9+GuR8SvY
	d96ayJL4tkI9F42XGwDU0k/MXf/PKpFX2iw4SE5j/ShJnqELp3thRnLG0RdyvAT8e16D9w
	fBitzS/TJHf3WSO5fvN4/hx3L1cPzWU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VOBPHJnu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fmYw6I2L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755628054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoE5KTi+fUVTIC68RR6WX3t+Q9P1w3/oALLJALToS7w=;
	b=i+XnNhlEa/m63LsXnMrq+LkPwfeMqD6cwxwsr84+fivas2NV4PpXDtj1sAcgc1l8St6tGQ
	KKqnAM8UqqUq+gAkwzXK+aUvaH2CBfcWJp1hxNK1dk9s/kOXg+brOZgJMRDctWHC4HDgnJ
	8ItqTvhtlQLeesWp0Hn+vc6tyXY0PVc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JID0Js013474;
	Tue, 19 Aug 2025 18:27:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zoE5KTi+fUVTIC68RR
	6WX3t+Q9P1w3/oALLJALToS7w=; b=VOBPHJnui7SzDbzWFNIlquGQrF8l9Y1ovB
	ia8ayXn+wCKXXJjF3OPBzHVj3GMDO9o0/yjxJ/vglQMePaiVffn6D22AnyR7kRR6
	EVgJDcNl8W7vbuEghRPC/xDN/obieb3UnxAi3teX9+oiCnpu+Rr0IzDrBLd/A4SR
	NLp7ehyl5vVqeOIDv+Vmrt4+5770Cm74fHeVN/aBD1/FX5OJOP8DgBBNciNm+bDH
	vCjMclBHTXAhfGgxKP0IiJs8vuZlijc03YvjuoZPq1zQVL/n5JiLmOLmgD6w3uzt
	CnH2e9l4oxOe/A7v/o+EBmPOD4xU01LuTN06QCa9Y0yfKNkIxq/Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgk4p35s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 18:27:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JILnmE037215;
	Tue, 19 Aug 2025 18:27:16 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013029.outbound.protection.outlook.com [40.107.201.29])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgebaaeq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 18:27:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlmRFbYsnpug932oqEhtpjp8sTeJZlKxPkudzP/5wDJb0fTY1ga+pbX78Q37DUtmwGj84St6qgnynmhGCgORgQNKhvsgTXKHzPV6HDGbR0J7qu3sctbxANLzBM5lZb1YD9f9maT/Q7W8et1rE+8auva/Go/QFryRBrhM2yTeRttIwP5UlbcO5Ptgh0qtRJiVIoL8qcDqujKnagmD9LnJ0y4DGELusQrQUrDvSfTdl2HVIR5qeZrw7oNo+EsEGYDdT0HyiU+0XtRtLS+8hJks194qnY57BvtBG0JaM1aKZcc35s9VGcLtFIGgqR8ScMxhdc/y5Swn1jvCrqYZpL/88g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoE5KTi+fUVTIC68RR6WX3t+Q9P1w3/oALLJALToS7w=;
 b=AjNsvDRMcUPueUMaHG4WqbxuLYVBJdoqGOM+aidpQcKj+37lePbkG/9rFoVKiTSGhhaQ1VYJS1ArxKocxDpjh2aMltKXKnwLOGBShMNEdDsjhXozuKdeqI8t9uiUpIl5oiIIkzKjRHTWxZWIyCtHrjk10jAj+GayP73xDFUWeW7QA7bINvFN7mzFtT2D+PbyN8RbwiVYdnsMcx54NTCOBW5t2WI8UllrEQEbeB5oCbLV8EYa8+bNOztcYj48rUmNtjeVKBdsaJ0/3F2OBjCH7q11XCoJxmgST4+3YxZgSDVxta/YurdWIjsNAN9BtGcdBnKo2hEEUupyWwug4lL+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoE5KTi+fUVTIC68RR6WX3t+Q9P1w3/oALLJALToS7w=;
 b=fmYw6I2LEeCiYvrxPobB7ZUyMSnDE/7Gov3lnBFVWl3llSSuEj+92BGwxpjqB5gyeT08etw2JRdJPFh/49agVq9xOlYQzhdOirjxM6o40Cn6FISo7I3kTla9r9YPgqotnYBs0DjmzFuKeNZ4olaI0M/T4tqTzq8WbZ8t9x2OSX0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB7533.namprd10.prod.outlook.com (2603:10b6:610:183::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Tue, 19 Aug
 2025 18:27:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Tue, 19 Aug 2025
 18:27:11 +0000
Date: Tue, 19 Aug 2025 19:27:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 1/6] mm/mmap: Move exit_mmap() trace point
Message-ID: <ba868e21-b206-46c4-9641-70491f598554@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-2-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815191031.3769540-2-Liam.Howlett@oracle.com>
X-ClientProxiedBy: GV3PEPF00003668.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::384) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB7533:EE_
X-MS-Office365-Filtering-Correlation-Id: b233e21f-fd90-4d52-74d3-08dddf4e0393
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4w9drZwZzOpS+MZR0qzPYHAblxin4NvCLdBS0JIvxywIu/ONnCHtHafrVhoa?=
 =?us-ascii?Q?L+HkjU/Oc03nMY0xE8VT2cXaDtYj5ihOA8y65wCyNp+LZoaUeIFreK/iDw9E?=
 =?us-ascii?Q?05TO2GSlW6dpVw/1CTzIf5B2hEHWys2GsxApsCrL4uwcypmDu8Au6Fo4wY0l?=
 =?us-ascii?Q?vFf+7VUXqcTnEsLHizODgT1MGqzbPlomc8FCr0F4Oe5jaTXrI/eyEXPAS0wX?=
 =?us-ascii?Q?Tr3unyGW6m+3gqKBUK3uBZAt0U1rHyWGVL4A4c8TQfLeThMMAfHEjh93wXYD?=
 =?us-ascii?Q?VbX3u+ayTZ0VA+3ECm8Ewk+CnHGyj3SeGC2nqJ1rLumtrVaauAlgvcE60Xbd?=
 =?us-ascii?Q?f4NUEo8uz2/4PM2fhFlr2fOKlAsI5cjETaqQtuaKic7Va+p2y8uZUbg2nBQ6?=
 =?us-ascii?Q?20fO76sLl6R29WyEZqf9tTbz2E6daPJHqhrmt6S3Snn7IR9QaM/cE4uObjYD?=
 =?us-ascii?Q?0gcyHm1Ae6b+zNVZY6z4CAOPaIY6sXfid0s98ArwSwDJtuB2HZ8ZMeuNfFaW?=
 =?us-ascii?Q?+grSgyMMDpcNdy86eEp/LQGOGu9VzKecgt68edLHX7ypnWeray4j4OHEwisk?=
 =?us-ascii?Q?Xdsn9W446/Ks5x6RFl3M+FqE/1w9OczeberATGnKy46sRDryLyan0Qk33R9J?=
 =?us-ascii?Q?HayDqAWhiR41zgqljNriUk9lmAksKpuUFyGD6SX4qhlP50tFP9BbhtlrgaKN?=
 =?us-ascii?Q?cDNAGfNj35iisFqv3KC0kQZxw1UCAEyljsu03ZkQrvjf0QXiXzwkFMS7e+D6?=
 =?us-ascii?Q?BIFWA5V7hHk6A8bEznwmMgLbce/U370Ec8wOY8BRVJtK8iamLxrmVUOjbmNk?=
 =?us-ascii?Q?qCCzr/S5wSOwEFDODh1Ng3uqkwp+uBk6m+k0px7xGrLVKUsiSv7kdmOduitg?=
 =?us-ascii?Q?0sLM+Zep2QBVsnbEIUCzzqyU6RtKfqniBH5U3ri0lEdCQ79RQHyE6377ncFq?=
 =?us-ascii?Q?hrGx/dw+QUE7sUUml97iw27jHlvLbmN5yz8GFLzdhypZ6oTApLbn902Vz5Yo?=
 =?us-ascii?Q?OivrJgmyh9yz3jFtv0He+77ReNY4m5pOm0unkMpjjtxq2CndKmd5ss0eakYz?=
 =?us-ascii?Q?wP1oWk9xugEQ2/9RUy5e3GNiUQw9zbjziAd1Z/QIYPwbCPdp+NUXJ8UIAAcr?=
 =?us-ascii?Q?/AZJ7lc3utPDRNZSrIZbJAuOnQUINcazpMdXXx8t9xzVKttErMfNeqChZQ4p?=
 =?us-ascii?Q?hsbJ3OHIFy7ab6qwit/oHhMiq5pb52bU5TqhavMzM9f3Kdar1GHy0YJ/Krnf?=
 =?us-ascii?Q?weBIyBrWz0MhmfrtaECUotLiWPlhCweYpnxFONalU11lG7ab5jHP0FFFA2OD?=
 =?us-ascii?Q?BqpekPRuBVnxAO2ryRMPogI4XCZ4FKotopeTKRjuXmE6pVkjzJVFFuxbqZAX?=
 =?us-ascii?Q?4K0TUSJ1BjmY/SYy5HGwAiJ21kMZDuFokBajtleNUSM/8YrIVXjdYcn76/aR?=
 =?us-ascii?Q?gzqaCauaGTg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UZmF/eJIX/t7A67QhRp4paRHAXqhW2TbYbfH81Dj/DCJ00WC13ths7+ocMYF?=
 =?us-ascii?Q?lz1IshU+2DF/cVJyBaVZl3g6d0Maqh0GP7Gy4dGT61LCAxi+ajJhBQ/heoQX?=
 =?us-ascii?Q?hAlHM1hRbUsECiojeSyIvA797x/nFUXbHWrSZJHbEdXDEkptsHPemEiws39G?=
 =?us-ascii?Q?WeEyKH2YFvbBQkAU4bfPJweuSMSt6k46P8+8BpEQuazc7GKfzDEVyRtaVYf0?=
 =?us-ascii?Q?viXq3+PNdntI1hDb47fJZUdqVfVk+KNOpX/jQd1T3UvViHJoxgqBWkeEBD6P?=
 =?us-ascii?Q?2oz9Lt3GrUJQR+vmUrWXphv1Pdu9lkTsMMUPMttlzznDyMYtzYna7vZ/2oSE?=
 =?us-ascii?Q?jTEZzYG7oorA1bSQJoItNTWsOklXv7Op0i8x248j83fG4Mu35jtWjmmLgFnx?=
 =?us-ascii?Q?F8olR54K6r3J8QcZGSxToerrv+vqHAvLYqpVp9t9r+WaB/+5Gh9XVJEGI0op?=
 =?us-ascii?Q?zOO3PqvJgGu2rZpexRPKH3AjXsp8UpCrWMxKaZopYThyd4eFrhDi2UUXg7Gp?=
 =?us-ascii?Q?gd670X5W76UP0K7t1KwPL9Utqyd5/zcFBIcdMCxRL380W3Wk3sqOet5HnF7X?=
 =?us-ascii?Q?6sxipOZzgU5wpk8cKk2BYRQGxlnM2lWlmQU3YZvcblRzbAgNCWk6z+u76ejH?=
 =?us-ascii?Q?t3OM2mruiBpZmKwuufryaKsXJUpmQBEXR5TtkvhacJouBoIo3uMNsq7JpY3C?=
 =?us-ascii?Q?Ip8fzN5s5JOe+k0b4DVA0OA+yiyn7A3zmoPbhrjfvVTe4/xZIpaEld9aaZ48?=
 =?us-ascii?Q?wIt2Dqa/tg5RTQp27XxYxTAp1X0Wa1/IJkKN4n+FyL3oqCI6qC393hdWUkS/?=
 =?us-ascii?Q?yYLdkxtkPFNV5aJWFdX5X+Btw3wmX8UyjRAMfawfg6l31CNlLzoTlVD3Wejh?=
 =?us-ascii?Q?aNr9uT9MfMv09SGP0Mm+fIdnoiiP7TxzBMBHLIZsPQ5NUJBtNUJii5sM8T2S?=
 =?us-ascii?Q?A5YBE7bwQTIe2Jb92F14FgWP6G9r2LuPCollM3LB+fhWq9XXQORmtM06J0fY?=
 =?us-ascii?Q?sH1GDao0VDuiCU7NG7tXOY29iYm0dpPzaSLW++N2b4+xBeqT59VvW01NFyWN?=
 =?us-ascii?Q?hqOlMu8iPZifNHLDlgvdKKvENvl2y8uuwxAITVcW6k15d1nshcAK+bGxAXwB?=
 =?us-ascii?Q?ho49Gw3SSTgMttl3OXaZFUl+Ywt0wpruIyIMquFup8MAn1X02IpDd4DXVZMd?=
 =?us-ascii?Q?4iYdjUJmezTnYmqSAY5GuWAiv/gbI+dpSsIq7ZYJM6qD3I2Da/QJYcTddYMU?=
 =?us-ascii?Q?6QAY5DrTISlUzU4qMfQ95DcPgR9SuDO8/pH15PAQIfLtR3E+OgY7mNDX5BWP?=
 =?us-ascii?Q?WDivihFemDqlds1ENO+nw0Hqqdv/5e3IXwcmHdrNwffznPkSB6RU4Pdyh1bR?=
 =?us-ascii?Q?XRuyj1k5/R1V94eIQiRIPEyZhYeiLZd6jNjP/9grxfa0rXWemHBoASnojrT9?=
 =?us-ascii?Q?aZFbYXC01mTizJRZqT5d2FNX7eKBD1ovRKUzx2qjNgdIFmSGSRKIxFMV6Ukk?=
 =?us-ascii?Q?Oi267N+0jRilDi+UdW+vRDA+lgq3r4gPDXLHDRnZbXhJ5wWLP5t3Pf7tU7xm?=
 =?us-ascii?Q?ysd6ijRQLpVTOETBTQrulGY8HdEAnvb6eVqsExN4ukqYVUgpd0sbILd9V4oh?=
 =?us-ascii?Q?Dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7mXA16/9Y9ZLZoHFwCAH8TdgyM3sk2UPJ5kOim22wz+kIpMZYPqH4f5eZSZwcYPuqch40YYpM6kTKt22KZ+glZkk5E0srGWEWQkNDIGCscVctUFRrM1n3i/CCFyVnUzf8gb+KXkut6cMk6cYcnTr0WeJPrnxSNM+QFC1eoIO+jNq8/uxGGP+bYz85OLwobTM8vgfaKO0PaTvPu2ZMA/q/gFGzoRh0gxvb66pAU/yTtrtMOGznl6bRcjAK3QohSi0fiq+HRNjtSo+7wFNxzXHqCJ8pDSx+s+3S8LH4DXEpILlhDdUX6b0FxmGSOAUEBVOWA3gF/1nqTGFYAtBHHskTQdU0Sn8ZgyncrkosVmYaob+5t8PbC+N9kHyshYwuO0sCxzVPgfjnP/2aV30PXB0ISpUcz/u6VCVyKricTwYOoEkSRZnTQo6DhLoWlBUHMMmTrQk1QPRwSle2d3+IWF+ugY6P/JtV+C0JRq4izTa7lmi4w1G8VmHdWbe0/HgwK+BeNiKzIJ3giO3HTxLXJDj50CpCX/TA/szaqK909geKVVK8AUqyod74LGsDYy3BKDOeXSRlFbK6XNMNIF/+lIE6MgaF2CwKga4GKHnfVpuftE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b233e21f-fd90-4d52-74d3-08dddf4e0393
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 18:27:11.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 84UpH1PnkN/nZWxgQ+JVywx2heTomb4fk5R5UCx24+X421/OvuxMqU3pkHKORrlDtFv25TT6NVrmS7SykPtEhI2QTQNjdoPMvICOfweZyfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190170
X-Authority-Analysis: v=2.4 cv=FdI3xI+6 c=1 sm=1 tr=0 ts=68a4c204 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=umr53z0iOdrg486WCFwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: weDgzy50oMpTrmvRifuc_4dsl1BtPba-
X-Proofpoint-ORIG-GUID: weDgzy50oMpTrmvRifuc_4dsl1BtPba-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE3MCBTYWx0ZWRfX3Li1jaqoL+Tb
 c7Fj86GBz05ZW2UoDVrSEVLSiR0M1MD/US3ZC6Mgop761g04bS1OQECt8efUXx+TMxlX2KgcKKS
 t/vYZbN+R5BGy8DyIsafsUWqSoielLIgmBjnYz7lLmcppkTAXH8naCrpnqQH6AW27nL+EsYMVUJ
 s+dQH9q4b1BOcYO65N9D2wEbEnsmEmGzCqGDScEP8J6EKwAzWYBsbQPeQDmZjach0Vzi00WMu4B
 sLW1JJ3lkjp9QpfVDOaewpKn7X8HWr9Uk2dKrANjBo7ZJrV2V/Z9/l0CVC7jqg9UrAYyv43yNgr
 a3GxJVdF4iyJPmnq6TPJf49ltB2AZlai9rztfxvgBuiN1F1phm6dAPyBlUaKFR0r7gSXVB6RY2v
 tzj5pPrGPfKSCeinCbFxT5sMIOyMMszS+DWayqMJU0Ua4AAaUv1DlAUU47WL9OD0hLJxYBEA
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BD82180006
X-Stat-Signature: 4zre8uc7r14a7tns4ygi13cf9ftn8xh8
X-HE-Tag: 1755628053-103854
X-HE-Meta: U2FsdGVkX19CIFUxkiQZTVUxO7QkX/OWeNkrqfvvYKUThuX95fwRBN68s7nTElMJSgPClmsClS33KNwnSDxmak98CO5wmlShjXM+UOeSYPV8hB843rdhqRrRMTLPgwVAd36lM3N3tSoEFSZnLEo96Ia+H+kc997IsUAclN5tfGaOKNW3OV7E315/zw8fGArRJw6hXtuxSs2KwZSds41ys4iy/5i0FnuATIRuMwPA5ZXclvv+Kg3B9o9ZnXmfx3b0begCX8LNowEf8GWctq9dx4eUUi4TdcFgYf7LVhIbXag7x8m1e0usvctj+N+8UBXtROZv0yu6EmEHYskNEaAbKlJFYF0Nnun5gPxU6raACzvLd8R/mQSffQw0g/IPZm1xQxCjI6LJMXT17PT3DTzkuWtpOoaS+n5hRdXJ3ofTpEqiiRC8M6ik8CYbumyo6LxHe7K7sEAUJZd7pN5f6lJjsbYLL6NfPwVzjLMx+wEOHpKjPAuM0s3rCYcm/YXTEnCY+G4PvUhbamvIaF0BeGy061Q8lpaRTEFfyfXYTuWo7aAwY4M/K6K93kqRQ6JBGv1VEvqIeJTMUPop5AfBXfh0d12nHe1YGaCbaktq0xMKj+L96sq+QAwpzzOdSXBszKENTuPi51wOb0FeKWdlJB/sXRNc2GDT9MSuM9GfQqvzIrssS2ym4IwEw21aJo5ZvQjC+wTYpcmgw0VVzcrUX2QsE17PHriaXtB7hv+iHebzQayVQVTtmQjpHmml2y954jBZYxtz1Qi8WxQb7l4oYuw8zShzrrSgHfcud3xRcuYj4aW4hcxoTjj1eAadlHF65HhHrDxLPvF8zVIpIIrG+ZbHr3dDH0N6nuRly1ViQ9K02V/+LZVD8ikuzQ7MwI9bEkrpOY0ZGN3qzwC6OIY94b8tYc+9RK1fCO35SQ+abHiyWU5I+ZQ3mY6/MGedkRWezn51oDvm/7W3FSg/LO3gvOk
 +acgGdCb
 pm8f1PCG12nXydrFzxoIKqE9cQFukVswTn2M++F4M5Zkk0sRY7M4SJbiKfGe1+wmiD2IvX9YIGidHUcasrh+5TPmEnfvJLUJmwR+uxUjs9HGeQjzCE+A3PsBTkbwyy2mVgX1m8i1nyWbYfBkaR9QnykcXRcgpQPBbhQEDR+WBUmjj+wgo0wipaixLXukt5yXsJVZYdztlG7P8DIKD5B/XU+mYqK+AX9XrkhxLh59BKX07O+FxUmoCl9nnK/NZKcOuoEf1xS4KlH0VdAvv0cF2X2ioYNfU74472vwM/BSJOHK3Tha47HlZS3kHUUUij2Cw+mrowHcuJG0mVNy8TfuknwtH6Ngh7dRglZZMxTmE2LRmclIFgEqhy4CVa90PF55/TRAkOh//FNpLajFQA0b8mCOF+D07vVV6QqZkLvPGrgeVBfUCUu1JRhVSCiEzWD2rITQuvomtDbEK5QE57YITKuEEdeCjra/evOj7L2um/FDcjzVqW3kuBtXQ923X9TRuayylWmo7054rwZFcyxrYYHSUwN2gKBqOTrzq8CMY6rfG+dnDKqWRXJE7rklfhQh7OwxWJWcc+4tQ62Ci2bRvDGRAt7ftVqEShq+O3BmnnsT7gk9/Yso6kLDm4FsrQXxNycuW+IIDHXhKsTSz5Gro5AUoRoKzNiGLo5cE984jzfYlgUTXBYS2Olr5KcWNDcMf7W9xvqNHUuG3ydbwpFojaLesA22FSAhyBwQ4bVteS0e20R8gvVcdOyJKM1H2K4xtzDeIB3qiq8+HR+8ZeZW49kEbH+OeboMfvjPa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:10:26PM -0400, Liam R. Howlett wrote:
> Move the trace point later in the function so that it is not skipped in
> the event of a failed fork.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7306253cc3b57..c4c315b480af7 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1310,9 +1310,9 @@ void exit_mmap(struct mm_struct *mm)
>
>  	BUG_ON(count != mm->map_count);
>
> -	trace_exit_mmap(mm);
>  destroy:
>  	__mt_destroy(&mm->mm_mt);
> +	trace_exit_mmap(mm);
>  	mmap_write_unlock(mm);
>  	vm_unacct_memory(nr_accounted);
>  }
> --
> 2.47.2
>

