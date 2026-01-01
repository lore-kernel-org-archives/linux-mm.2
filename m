Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 302A2EEB599
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 13:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54EB86B0005; Thu,  1 Jan 2026 08:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525AF6B0089; Thu,  1 Jan 2026 08:45:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4082B6B008A; Thu,  1 Jan 2026 08:45:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA5D6B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:45:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77DCCC34BB
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 13:45:44 +0000 (UTC)
X-FDA: 84283517808.25.99ECA2D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21FF740007
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 13:45:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="QI/5BFqD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZeEnR6cO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767275141; a=rsa-sha256;
	cv=pass;
	b=B1FcSTN34ZNaXbA5+NnBid1MH517+6ccFhwig4tNx1Nk+cI2OIMtwVUsYfR2/zP77sMxtF
	47pzy0W1i/Im0UjbE6wTFTAuBhrK5tx2AkiJ6xTA1mSdzzaIl49C8aEr2j+SDnRNpGKC0h
	tHHW5l3yVZp5RdLVdU/HsvIrByKCI0g=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="QI/5BFqD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZeEnR6cO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767275141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DV2hcT3K1k9VfkzGRAz/lUay7KGkxtjVYKm/r+/SS7k=;
	b=oTmhVnT/aE5bKT00aom++V0tfLLpLLriuuIolTB1gAbUh8bBmKR921xZFLRbPDbwnJcv/I
	kyArfff9eGJkrw2W4X9HH/C8c7kdXqBltkFVFJ+y/eN61SXD7lz1kSUW1X7Tavq5WK14QB
	g/zpLt+4qTBs5mNxWvCke328kBcs6E4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601AcfxZ554246;
	Thu, 1 Jan 2026 13:45:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DV2hcT3K1k9VfkzGRA
	z/lUay7KGkxtjVYKm/r+/SS7k=; b=QI/5BFqDGAuG6RZzCy5CWTjBtVexRMik2/
	AvxNPi2ZokeSpVIFgmj/AGXW2L7BH0TwADLfdZVPpWhIN7H1CTY1k+wmWGpj5mOA
	5AsN/fnr7eTAkPTx1m3FRHdYs2iu0w2NJw3HafdgJhygbFovlkW1TpbnZx49QgSo
	wPcB9FYn0E1AJrbXePU1EHjpEt///eFlztX9McR9+/kTygrxSR2GtLBz076bTg1w
	XjOplbnndOoTdIbHj3W3jqS3T57AXkkq2tVuIpYFEYY4YDOokY11+g9iQ/BPl4Ef
	BM17oN3sjOqUe/rzwQDv4W+zm/SirQbJtSTMrV/72n7Ncia1KeUQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba7gace4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 13:45:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6018bnr2013601;
	Thu, 1 Jan 2026 13:45:34 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013008.outbound.protection.outlook.com [40.107.201.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w97tmb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jan 2026 13:45:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTUrPuP79QHQ6OwBYADOFaQAvi6hLACpuI5RwfrftQGLbsMyoQ4aQxS6JCVviuJ32A5poc7ptrwVyG8ODuyjsjKxxWk2aWth2kSqX9CERwvW8DXlCOiNiyW3vW1KKsCFmTGdB4tQ0070QMRACOOCjst+mrE5W7qaxrv8zsNYiNqYU9zfulRLxr/T2AkMx2bzP74IPyhhXEdlwaC7iYbXJchw6argFeGRms7ZsCgkyvM6uPAmdpn67CYiYzjiJFWWMM4Np4LTRb1LnhpqeP6jsft8Ee/+j8ln7qJ9A1Qj8UjEIWO1JzZ+/khr8zhcrO3Z8aN7wWCN7H2fkZea9e9sGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DV2hcT3K1k9VfkzGRAz/lUay7KGkxtjVYKm/r+/SS7k=;
 b=ufRmg4BDa02JIJQRrKH4gR5O5BTBpnAQaEtSQFeRSoM0llXeKVOwF0/e234RyiDlcr+tMGRjYsDtJMjpQDRRNAEZLdOzLSMHPePof7+MrejCuAnOtSD8G2/LDChkqzRyXeFFXL1KixuCKeeOqA5uwRg+uh5h+iJXDZmKdCrs6YlYJpC7Js/1aumT4ULxa+Bo/tCGkVQwtyPnHsyq4jM8PQ94CrzzA2J39CuqgUkK9OVvxalSP2mBXTWA0g49X7GHhsBJvRTn0UoacUjnQQO/BXy6Ruw/+yXvAumMVGiGszIZhonEL+mkgTX1FhCYc2yuwg2mtNZMt3MGcyyKpcFOxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DV2hcT3K1k9VfkzGRAz/lUay7KGkxtjVYKm/r+/SS7k=;
 b=ZeEnR6cOke/DZTKnLX81JgrPm8P0m2knSmjSA/RTBU+ZyxSUnytPcJkCl3OkTiLs3AbAdxf/YzlcRabmPa/2Z1mg3Azc3QzVwYR+nzntJrhcajf4fw4fM3z2HZBWTqL3ySHV1MUOgxxiAg/lCztAP6Pt6qQ7Jdk6kIiE7be7n58=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH5PR10MB997718.namprd10.prod.outlook.com (2603:10b6:610:2ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 1 Jan
 2026 13:45:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Thu, 1 Jan 2026
 13:45:31 +0000
Date: Thu, 1 Jan 2026 22:45:19 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jeongjun Park <aha310510@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org,
        jannh@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <aVZ6b2ri1iRpM-7y@hyeyoo>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101130906.839504-1-aha310510@gmail.com>
X-ClientProxiedBy: SL2PR04CA0003.apcprd04.prod.outlook.com
 (2603:1096:100:2d::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH5PR10MB997718:EE_
X-MS-Office365-Filtering-Correlation-Id: 2552f6d6-498b-4f0b-5392-08de493c07b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z3oeQwa8y9SpxGNotH4XYqayfmNDpFjNVQb1GX0EOuNqpkZ/cmpUhwxfscEL?=
 =?us-ascii?Q?+0f4a9/+m0XPYOYV2W1VS7wsiMY6o/kkLdaDoICTAu3+j4pfwMB/d6wGUy8H?=
 =?us-ascii?Q?S7oX5PjbvMddIdeTzmNo+k6pq/7ZPfV9Bnby/0RmFZ2LuyZW4Z74Nulrs53h?=
 =?us-ascii?Q?I8oia42ABjY45DyT9G/7rj+GqclhD81K2T4aZjunOYM+kZDaA8+ZKSz+V/9a?=
 =?us-ascii?Q?qBiee1lhijinkYegXxjyvhvBBgJRKlw5p0pPOK1LSpUJAwxi0J+9EZU2qxoe?=
 =?us-ascii?Q?3mW7IU9V+LYBFy359B/8LqP5TWEKGU/qw9LvCEz+rwVavGuCJ3ACXFTY9OXb?=
 =?us-ascii?Q?TPfp9TCxC3T20kxqDv73Xog2SUOa5rbEf+ju4oERYQJaEXRuNp5scALxIMba?=
 =?us-ascii?Q?j2jN6372OkNEsWwq7lr3GVEst0yj5/ErROxZwjPjtJ8HtVNowT4SpfO/cjKF?=
 =?us-ascii?Q?0YqdKD2wdmHc9jsYDK1wpPnwxXj8nSFMvkHwcOdLJ/5ZtZCF412JZhQOngqu?=
 =?us-ascii?Q?oRc7v9s2UKy9GW4P7HuswP6fKZI0Q1sMqye0Jg/29v1n5J+yrxUaIcLuE7uV?=
 =?us-ascii?Q?LOlPBV+rp+0i/UZjAGJpTGQsu3DpBg8kI+TwCGsDGiQQaCgeZKIgkjcl4/kH?=
 =?us-ascii?Q?7f6rSLS0vRGVFYLlhB8Yw5HUn7sYkJfBFt8LaYTeNS0PHDk20vlOdo83k0Qy?=
 =?us-ascii?Q?plel3TNWh+ge6k6i1rK3upN9+KB367zrYytGWgk1gmBLj3+di2Fugq7lUU1E?=
 =?us-ascii?Q?voErgiTXVstZFY5LBYkETNLTlB9AyUs1ngo887we2r2v1XwuMJG4Lv/NgzV2?=
 =?us-ascii?Q?W4FNQuaR2lv2y3+P9hsqqcsGHJyf9cukqVE726Hdx0IkzvN23aXjIkI9hPib?=
 =?us-ascii?Q?ZuNJ/z0IZw5MFQr1WNvgUwPkOgnZ8v7daLUP5C6fET670+mP551KdtfBzYFT?=
 =?us-ascii?Q?CwfhNE04ZaqJKpreLvGdNCSE7vl6xgd7fQ6j+Nvadj2Qrsv7oW1MJAs4XTT0?=
 =?us-ascii?Q?hDObx8OFbH11xQh5/yvdfDZ06aD3SLBJ0ziR65AusRbHayUOwc6IKYsYT3qY?=
 =?us-ascii?Q?tTK7wH1qzWtSZ3pVPkqPMClMfVDCReJIjuReBUt40gk7v6XiBif2oAI7yaJa?=
 =?us-ascii?Q?ozkw/tosAltwoPG+6WFrp/RezFnHTq7K74ErbKNOx7LEgSxeP9dQcQpeLlgV?=
 =?us-ascii?Q?IuPfgKZ5xLIu3T30ix0BHmoG75SaxJvf9K06l2HzsFnUATm72VCZe4MEdZ7m?=
 =?us-ascii?Q?k5swH7Afp8+YeFCTKeYeVlQPitCygBT36ECoRpUssN2R+MwoVcx6wNYOBXev?=
 =?us-ascii?Q?nWFJF9MXF9fQDoWSnNmkmDjzySOI5Yv5t3yz++z+HO3wNslP15qFeJLmSq34?=
 =?us-ascii?Q?lo/qBJuHBJK4q4s0zKhOwvpGWIXkXr9xqua9sO9q9MGDTxbNCzTkDSZUsSGy?=
 =?us-ascii?Q?/AuTWhwTpn+Mtt4kxydNKfpZrCuLSlX+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xN7jNpbdvr+/FDzE4oWoB8ro6spMtM9W5aF9WUfnWoMUCBNCRhKu0+CDneh7?=
 =?us-ascii?Q?qJFAy6//D1lH6l76jgRi80/QK8lLa485A3AGLYG2UKOFthY0DSnRlWc1Jyj/?=
 =?us-ascii?Q?ZHyI0yn2Tvuby2pDgbJOVCd4LBr06A2mq8HklFbf0ORPwGB3cbP8ZMrytaTC?=
 =?us-ascii?Q?fIMbjjFJiD2VHhybCDU3zTnide6ljnecCI4Rzken+R921lZP9rwLgCKhRaHi?=
 =?us-ascii?Q?TmrnlHD7tijs/HHKDxTv3Gnt3QljPcAiCrU4BFv/we/oH3IYwj+8NUsOLVHk?=
 =?us-ascii?Q?0k9Af3dxsPvQHCmmtzZgxcSZojxYwkJahRMSJ9GClZ/+VHjMxABhDxGCoA5p?=
 =?us-ascii?Q?761m13uLFN7wi8I8Kdng7RRbgOGGiJMnK8mIKedHmVGUP0poYKzM7UsnL9hS?=
 =?us-ascii?Q?QB8MdOMZwPq5/7FUECkJFGtP+p7xacOOIhCZXGao4JT0l4/s+4uQKfTzFm7p?=
 =?us-ascii?Q?JkV8SSydOu1vFdP+U+UpUx+LwwM//CUDNaO8yQmlurZAbIdZDxCqSo6EtMXi?=
 =?us-ascii?Q?gbvnDlH5L7nb6PKlbUjTvg6uC3PeTbrnlQL2rGZkdvgSKIxtjmrid14UX0mL?=
 =?us-ascii?Q?mSzfK74Cy6d2Urdwp9BBYgkNfO71eO93IA6zcK22wIYWbOEyBTysAvswKDP/?=
 =?us-ascii?Q?IMDIpmA7PX9m79FWZxDB+8MkjfHe68jB4uGjO1t7He7xR8GLq1aEF8YWwH5s?=
 =?us-ascii?Q?Q0FmD1jwIAkROQuSzumD+ZjOW9H+/I0lPE2ZgheZmXWaMJlfrK2+rb+OO2nR?=
 =?us-ascii?Q?9mzoesPzOtN4i+voTDq+N+PcVAzFCVU3aYzbQw9XeAU7Z40F4PCyWiCHj+xg?=
 =?us-ascii?Q?+Pyz1tlUeSPyBMalJFoET3aM9O67yOK1cXHA4GtPPGuZRNn3MaM80fWt8uvo?=
 =?us-ascii?Q?+dZT6c47X4JwcV7NYBZaHv047UkG6qRdZd0WDS3lf1Czcq1r6T9uf7iNQ5vs?=
 =?us-ascii?Q?qxxo0PG3luQ3AelkkROYe0rcKv1dqgvJcYulS3RXjgEBTDfl4nZbkOILEK5R?=
 =?us-ascii?Q?kIa/KDbW255+LS6o3cIaacMij3mJAXUhQvzyPlvcD0UCeRrjYUGzFMBpScTZ?=
 =?us-ascii?Q?SbXZIaQKyqpzjuA4jbvuUb/weEM5pQxXIckrQNV6CeooVvM7ipCdPEAzo91O?=
 =?us-ascii?Q?b/OpxxabEXkpU1p9yahFm65iNR4NEQvE7Wozyh69UR2+ggcGCDm0gcMdZ+DM?=
 =?us-ascii?Q?h3fyu3sVtkRfIsBfH9GrlFcrOVg8FP4p8AlQ+Nch9ItwBEV0CCctvH6wJnPZ?=
 =?us-ascii?Q?tXxfbIQOpFYrieCUfTQSC8yJN5tzHCqyjPwGwojV559NIHOSUSpE54F/CezG?=
 =?us-ascii?Q?3UKQOx72mdkiqlSwq1XE4E/ED+GwLPzpU2AaedBhr0rQzGh7LJqKSD72u2zF?=
 =?us-ascii?Q?inw0BCKTrMM+41zQMd9faMofFFNI12NPFmCso82rlZt800XR4/IScVjtYiT6?=
 =?us-ascii?Q?tyRRbxcFC0/g25AUKsHHT1+rZ9KxQMSnnL1Xw2W9b9CcV/yAffjvWeOsIXDe?=
 =?us-ascii?Q?ghNM4mv8Y6kGs6JeAW6do81fAUzf89NkEAfgm3AdNTWsUz3HrFR5ixXHaW7i?=
 =?us-ascii?Q?iZu3kWZE7aW0DNoi0bD6X/ANEixGIv/fpqAFIxeI0VVALVTSrCUuwNmPPvdx?=
 =?us-ascii?Q?ktUMpy+wdReKtfJ0XoaJC32nY/r8RWY36HO86uqb8TGTWU2dHZDuE04a3gVX?=
 =?us-ascii?Q?m/UQ2S+jhiqvpYYjqMz+6zlmGmi8+5lDkqAu9EKRe6AtbuTOF8XFUzivtFXp?=
 =?us-ascii?Q?LQpvQIjdDQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	99LWJMXy8/ACM68CWvtz/newS0sQtXjPHyjdGpTjQbPuvWULtRgA7fSHAe52zsl/IJLv8UW6tZIcwDV61OkUauZNjheZsbMD3z9hh4Y2Rk3ZLJ42FjnMzOPlu+fIkB0yE+U8PKSus3S04TFQKTgiHnqRP2I3TtEsnW3ifbkjdjCAjpGrhyegKd+elrQeMcZR3VLaz4VPi1/scS/DLIR3TMxnusuTFJv6Y3JmsbaWqO3vzY6DSaG/0w5+0aUD0KpH/+C8frJ6vc67dMI+qFon+uAymk6wFFM854XAbj/m6ZxV5QOfTvnI4NVcmHPOBL3MLyq7ftquBqIKfZu31V99f3hs57P3nwyuW7jOCFfTUvCZojsSuVaqCFIfzz4oabHLtAGKDjfdpc/lXBN1avlc2SaHyscZQNyKRB1q8CW2QmKM9+agro5nKzbIlhial6t4d6V+6etSjEPYS4UUYJbw8O0KJfL+tXpbQRJTsRAcW9QsXEYpZdm95nXfbA5eSaQiYIgGV1rOYl8NK2+FxFtcIUmGN8KCad2UlYFtbujfyZzMqNbz0aqQwF8GkCg7nJXY3cCBvFoUPoYpZitltmmHUIaaEitjTQ3y4PmGRrb0bTk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2552f6d6-498b-4f0b-5392-08de493c07b9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 13:45:31.1210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FF4Ez5x3zmtfJIv1zI55dFNVitGCJXNRdom7ssAlop/ZPf/xEgohz9EEcGlvHmLywo1V28g+qcV2DS8jenzCWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH5PR10MB997718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_05,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601010123
X-Proofpoint-ORIG-GUID: GP_2myFUhnbtCGscjk4bE2CNfeSEwdWv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAxMDEyNCBTYWx0ZWRfX57GFAoNZQsxM
 KuEpKKrYCDxJY+FRYIE3OYPY/jwzqZbskmyTdvIdqognnTw0hd8VlOC6cLD+RVJL3GXDLHcEIYG
 31O43YjotwRz/gzKpgBLvTZErSD1TJEb2PAgTKJrPbIfP7o4rcL4Q02k8UUWKJFnXlFDKmXJ7CL
 GF9E+TUQ3PXGlaRqUwe7XzX0KyoH9mJp+eamRvQd27gwNesioCQMUZExkqI8s8hqkwzY9UM5lYT
 oTH7qXuHYOKJ9N1q+tOuM/4H3TbBLzy0DI7ugUpG+oXtlyn0fUTrWldog2MN5Pp3udsOG0NDvoN
 Hcmv/xPoreAj47t73fdrprJ19Z0RallQN9xYRl+Y60+IVE50l3L2E+N6PpuK/MhipdafxeHqWEd
 ytIlRHgYVfyv/kL1+aBskTA6rS9hjrDTTe1cF0ZZuNqmzI7a53N/X2pQPK0hC0X+ak6fNRRtm9K
 dxZ40aSg4MIVU5JJb2A==
X-Authority-Analysis: v=2.4 cv=T9eBjvKQ c=1 sm=1 tr=0 ts=69567a7f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=xCMjttNzpmZoBdlRa1sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: GP_2myFUhnbtCGscjk4bE2CNfeSEwdWv
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21FF740007
X-Stat-Signature: m5sihpffn5jgc9n9bg6prc7xisf7eyjm
X-Rspam-User: 
X-HE-Tag: 1767275140-934270
X-HE-Meta: U2FsdGVkX1/VszWojEH+gaVeGq9BhLCqakqKMi7Q+TbhS8U7pAyNPJMIQNC2ajwEGYIq2XeSy7ACvqJTOZI3l6H6GgoVW2VloGLwx7cC9+Xs6n6V3qWcQY/61ixtmobkPKQIGWnPiX3LzbMt1PQGb2JZHkkBeqxx/JVQ7cqQtojHYTxkyazTJkrZsqbp/IC34Q4Wzpmakn8AKfhpRLiT74TQBwp1mv82TxdF0TokCm60SuJko2yQ28ZZNDKoWdUCYmrijEjxeui1ambdRt7Njj2CG5WIY7sMCWPjLcDJgYZZvhax8KsRsylSrc7jPZkV7/VOtGisWjo5oKnNS4k7FDRVwpUkSHdiNbO7Z2WhZowdfy+AlBwAVJcenidc5vbGBOuVlK7KcuDStZX+/ZLTEj6Ww/EBdvBocOcCOHj8zyrkPVu3hmgp5gayubTIXVPBw4oMkroG9ddOu7OsDc4H1nHNwb6jibZhQmNRpXYdHjQUw8I13MMOLPXPD3bPnetZLSSWRxu9Vfm1R/tia3N1RxuPm7KIquoo+zB4UBZgqvb/nsrtytN7xsvUDIUKxYi/xmfDD9c/oX8hub/VvIhjSJ9EKhuNP7MqOVDfXtnErjEVzxWkInBRaVBY71qg43Nuc7nxYDENleLFokQVtsKappqtOhqrFcaeYazOi6DmaZ9t97szfbESmFZIZ1kZggYRhKV5mmamLTAWMYOTf/X5GbdjvRrDIG6RxZvmcYEUIhzWhegYzNac8NlfqXs7UHM53CHU8hATSYP4OOvgxTYTdQvPlGHS2Imh60YbptqrGE/0TlPQrkiU2eYz6lZ8N2D/IjxhHhf5Xl+NQzt7d/wMjZ8dSvvMJ3GOBQcEs4SifwMjGsU/CLtNZZ5gmkpmWJP80n3jAmR1ac9HTk//rd2ZsqEQF59+cKrPWMfj/GXyeNIb15fn57osKctnvxEHq9sFmLIxn2/X2Baw4ZaBo/5
 vUik1fzD
 PslMRMKarRP35Ls+jE98PShRayepa9iXRA1l2hBd/we+744GLFItJp2zeY6/iyTpuqfPmU2P60P65quYG1OfwDjak4wB+DGJpMqNF6299yRzafWMIziMraR6XcVBVQvAqRuUB29SHaTPRaTxGhtbBbk/ZPtAWia0NvW5XlRYvOj5kquMCpLijQ13913m1aHEzhWW+FbhbWRZ4WPMVwfJf4zecJXIIWqoLSLW3Cn32+fWIsKmgwHvJg12qpvDAkv2cG5PLLroWTfb/D0vUO6h3KmD22O5WmPTDw5ibMm28bXWAlTntE1QHvtEgjYG0yK7t4qj2XS8KDt/c1jDCphw4FdlxHx6fnMKwkyTVDdDw9o0+JBjIvXzdulxobpHS0Y2cgwvdvrPADNWkSfA3G9mCT5tVPn+5dzUTu3aJNajfLCS8NDDbnfGfk2v4lS00pLEkeKK3kBC5MXbMe3ZKm8hP0IZupwe3rsKMN9DSQM2zcq9XRazw1YdzoRoZ0/dv7Z0DFx6dXOfX5MWSLlFg6O8hFYDkt/j/mgZ8MDJXVAiFAAo7bw1ZndDwLxUeHbod4/0YB0e+D1uQLWXG6fMW1kRQ5fCvLMNgx0Ll+/nZx1ptPu7u6uwenC62lz2U94xi6TCganr0mcsaqQ/FDzsODQF/apK7d+uJLkYjBuDYYj9cgf1OHn9hrEsx8Y8JGoEx8rk+mn3cSgzBXP6X7wU/3ijPHnX0eotNHDqyYwEnDE3NVvvVTqESyFEcfoMzvQMALieP/gj2kIMVosE8tjfO/ROB6csNzhvGRKpal6FYvDN9YWq9jGLKbiZstYiQo8+TbCLtbiiPkmbgDGMd9yM0mnEBTQIktfLiPuctWa3O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 10:09:06PM +0900, Jeongjun Park wrote:
> Harry Yoo wrote:
> > On Tue, Dec 30, 2025 at 11:02:18PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/24/25 06:35, Harry Yoo wrote:
> > > > On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> > > > Perhaps we want yet another DEBUG_VM feature to record when it's been
> > > > dropped to zero and report it in the sanity check, or... imagine harder
> > > > how a file VMA that has anon_vma involving CoW / GUP / migration /
> > > > reclamation could somehow drop the refcount to zero?
> > > > 
> > > > Sounds fun ;)
> > > > 
> > > 
> > > Can we bisect the issue given that we have a reproducer?
> > 
> > Unfortunately I could not reproduce the issue with the C reproducer,
> > even with the provided kernel config. Maybe it's a race condition and
> > I didn't wait long enough...
> > 
> > > This only popped up just now, so I would assume it's actually something that
> > > went into this release that makes it trigger.
> > 
> > I was assuming the bug has been there even before the addition of
> > VM_WARN_ON_ONCE(), as the commit a222439e1e27 ("mm/rmap: add anon_vma
> > lifetime debug check") says:
> > > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > > walks that seems to indicate that there can be pages with elevated
> > > mapcount whose anon_vma has already been freed, but I think we never
> > > figured out what the cause is; and syzkaller only hit these UAFs when
> > > memory pressure randomly caused reclaim to rmap-walk the affected pages,
> > > so it of course didn't manage to create a reproducer.
> > > 
> > > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
> > > to hopefully catch such issues more reliably.
> >

Hi Jeongjun,

> I tested this myself and found that the bug is caused by commit
> d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs").

Oh, great. Thanks!

Could you please elaborate how you confirmed the bad commit?

- Did you perform git bisection on it?
- How did you reproduce the bug and how long did it take to reproduce?

> This commit doesn't mention anything about MREMAP_DONTUNMAP. Is it really
> acceptable for MREMAP_DONTUNMAP, which maintains old_address and aliases
> new_address, to use move-only fastpath?
> 
> If MREMAP_DONTUNMAP can also use fastpath, I think a sophisticated
> refactoring of remap_move is needed to manage anon_vma/rmap lifetimes.
> Otherwise, adding simple flag check logic to vrm_move_only() is likely
> necessary.
> 
> What are your thoughts?

It's late at night, so...
let me look at at this tomorrow with a clearer mind :)

Happy new year, by the way!

-- 
Cheers,
Harry / Hyeonggon

