Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB2CD29DF9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721B96B0005; Tue, 13 Jan 2026 04:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF586B0089; Tue, 13 Jan 2026 04:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D836B008A; Tue, 13 Jan 2026 04:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 411886B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:51:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91DB1401EC
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:51:12 +0000 (UTC)
X-FDA: 84326472384.19.10F8C3F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6CEE5180007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:51:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=prRsz4FG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xkq+Vzwo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768297869; a=rsa-sha256;
	cv=pass;
	b=4emOazKjWlmebZIxQMgwgddpF87TFUiiQmnrRqQMnbVYOZvBY+AGGSTnwF/PUHWckNd0J+
	EqFNgFz2v1pxdvqBjgrU6G/2P5Sc3eGA9PLHuHcz7OIUEQQlx29CNQUWhnkcv/WHnGnrdk
	cdpV0qDU/9OLOVG0APATRnesOByJ4xY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=prRsz4FG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xkq+Vzwo;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768297869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1VxxlkbbVThkvarIRtS5obMDCEdnYdSRjS1/6hAOE/8=;
	b=fLnHCsnHfhZbEmVywzK7CiePRrBXXceslUgV72Nz3ougSeJww31V8okrRPAKDg6f4gkrfK
	gwwmYhkqp4xblmq8iSb6C97U6k8+ypNnWhbfMnoFkOueFNx6baHnRqlaLooI9QctxrR5Sd
	LZsnzLt0o7NteNqQGLo3MPtHcH5BsmA=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D1ggZb2395980;
	Tue, 13 Jan 2026 09:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1VxxlkbbVThkvarIRt
	S5obMDCEdnYdSRjS1/6hAOE/8=; b=prRsz4FGyESzFEfbXCKw0T4kZj697SNIjh
	a38ZHKMbTSArH+AZ+8u8ZQi4rm/RhR55v4qYRZcjCpihuH6TvOrI+UHXctqJEKGm
	s3BcFc//WaH5WFtovGW8O6gnjIXDvf5vaxnGXBXYxAs2D9vqHSPJYd73L1H3gqlE
	nPO7HfFxTsGlB0D4SczdgO28z4DYJa+HYKSQhBGjAwByNCA7kJ22X2JhpAZf1C89
	OFt0yJtG8uGSBqtsn0EC+JqMfI1eekOtxTEkTBiPiouWpEMTw5E4Lqpy5gWlpXeV
	6G36CJNsK0tjFhSNQB27yIEPyDtI5CFkdXBiT4wgc/ZnX/6tl0aw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq534ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 09:50:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60D8SUub008170;
	Tue, 13 Jan 2026 09:50:57 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd789n4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jan 2026 09:50:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbpNac8+zSgaR5sARuQXIe4dwBEe72vOglrdlVdnHZDTyE08J/1epS09FNn7CwdBBOBxqRlgtsJesm/e3BXekYuKg5bPe6jb03eF4DfiY42e6kD0OFIkej+lBMIFzUrsXhQQxb06H6Iyr0L9s9Mh8n+tVD9A1acj3GhJPnSBh+rZet6SnfnaZe2UEK3rmGR32HmzAIzZ+hRxgFzhz6OLOKn3u7VO5ShhMSlwsfDcvVd3lI5187wZuq/hUfK3Ca39sjH+dPZsaRp8VOk2kaHsCezEP27QOist8dSleRGr4aZ+XMn5UKnbvIVVPzwGlNqDQNDFLTUDCDpuFEmU3w9How==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1VxxlkbbVThkvarIRtS5obMDCEdnYdSRjS1/6hAOE/8=;
 b=U/0i3/ydK72jXttGdimxWpHGqapEheW4wVz7k5hR9NSJsq7WSfsfvtfSBtotwaJZoiCTru7nZjm0/fcIGzVwF5TRvODj+ZMuAIumZhrvk4+gTOvWzNcEu7+cruSQjF+HhwwY0f33ntay8U8NpiX3glhaxzUFmIEy1HlTiT3GrtwGiud35l27ERVG+Qsm4xgmoQHqoU4jl2bX/6VlsScWpZf5gU/q/rBUV2SGflLOFJqXESZQnQoLF3iFR9067dAmtuwCKAoGsQTaM2Rwy3/MSzVm21D+btHWhHBekFEMXvFF1RQWHxocWirYyoOMJOfSawFF8c8bsowcSRs76b+HQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1VxxlkbbVThkvarIRtS5obMDCEdnYdSRjS1/6hAOE/8=;
 b=xkq+VzwonBHLD8yZMmwfFQoLmKMhH1v2LRT60WtffeD3H2s8GIk5w5WkmT0HIuq0kb0tljM1SBxBTnrUc1NKaFcrJKm+zfS8MEsnkQkP/1NTx1t0YGTgWz9TehSP5WvIKW7pfGbNlvRUIxqvC4X8Nzv+CBmbVcwZCGm6l0p9QLw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8043.namprd10.prod.outlook.com (2603:10b6:208:511::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 09:50:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 09:50:54 +0000
Date: Tue, 13 Jan 2026 09:50:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org
Subject: Re: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
Message-ID: <80157a8e-eee3-4e03-8319-990c3d4b784c@lucifer.local>
References: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
 <49229782-acf5-4e33-b317-63399deb6f6d@lucifer.local>
 <2a289c18-b5b7-497c-bd6d-a25602706b23@codethink.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a289c18-b5b7-497c-bd6d-a25602706b23@codethink.co.uk>
X-ClientProxiedBy: LO4P123CA0370.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8043:EE_
X-MS-Office365-Filtering-Correlation-Id: 83063bbe-13ed-463e-041d-08de52893e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ch4zFOnKFL1eGZtwCrLkEwQsgwKyp4KmRDgeRhwGYw7oSTlU6S47AGFMZVXM?=
 =?us-ascii?Q?k1JCDWBM+Mg+wLICYgIL1uWE//O6Ci7eTlrBC/G+HlOTSWaIW1SiysSWiFy3?=
 =?us-ascii?Q?mqF3/Q22OW70d7uPg/jkCT952KCeb7KgooQKOzEo2FjMO49Wv/WY+myLyUoD?=
 =?us-ascii?Q?53vabwoGuT+KbthLr4YDmQ7yivee5Cbqmydrigveg4MqE7aoHEmdKPPYptbi?=
 =?us-ascii?Q?2oKnve/97EEvhGKAB/QYpekEAK/vuGeRpDhzvX2EMwdkiCYbCg1X/j9E5M5g?=
 =?us-ascii?Q?gzNVAB9klkC5ZEvJKUWeEO16GelDqdNPyP631H9pLC3PC4NbEUsKPdAlXTms?=
 =?us-ascii?Q?lzCfHB1HUWdDhU4bNiwGAwtyBexn3J3Gqq0lQo6wiUCIgIuUKisgycvWr9rc?=
 =?us-ascii?Q?P15ZhoowBudWJ0Mv0xnQd8vj0SeXBPxr18PMZkmJpOYJhxlRQUTEldNSa4bz?=
 =?us-ascii?Q?ovVna0zmWsYrTkBZLsIp0XRcb37dtV4h1qtRgmMXde1wbjSQW7joNStM0gxs?=
 =?us-ascii?Q?VaDsJVDlvCNUVgtM2Ai/Zg+C1dmrcfJsykrP1lfDcxTfLdQ20LAjYpCxrBEc?=
 =?us-ascii?Q?cthYiduB3OCA3TkD6WQMOIcFt3vFbAFm2q77T40eSY+IDxzfZHjeaitGLCqO?=
 =?us-ascii?Q?mBhkdnmXCVJt8e6frChfVx+hRMEuCspIutkQs1AGp90JdYIwPeP+48Qq62Gu?=
 =?us-ascii?Q?jloC9M4JAM51P3ehvddEJOuH4Nq2+BsNoKNt5JmiJO8kzQNuABH3d0yyzAmJ?=
 =?us-ascii?Q?5zwjrAM1aG9l4tUAAVF15iwjrxUV5DotUZdUJ1F2Go9iQaql0jDvnzsHL0SG?=
 =?us-ascii?Q?EwvtoThDDpp7DsbzzDrpuAGwFaCikVc2s9ZlEk+ljcYicstiVO0+Bz8EibSr?=
 =?us-ascii?Q?wjzqCIKhc2hP2UiagfNLLCvr8e6lzJtYFbDTxc/5LHsiJpCOq7VmrAID3LTy?=
 =?us-ascii?Q?5NBxgD/jEhcZsFfx3qQq/yyRR7h5rzn6XyKX25KRvwQrrKsN8SNOpUERzdR+?=
 =?us-ascii?Q?eLzKU0/kivuUJAaEtAlAy7ms0N3eLLPPaErcfUs7WDvVWnanBW9RP5kW70sJ?=
 =?us-ascii?Q?U6d+g1gNsWnopmtdXtvO0KHEn+VkkamB4s/zHLnPIsvS09G074Ot+6Dqyt+U?=
 =?us-ascii?Q?vJ9+RqblftZ7LT386aoxH0Q+DpuXSOUbSzgIpRXehMJqj+HTVPHUhgQ9BmA6?=
 =?us-ascii?Q?ceyQY8TFw0lyHhIXmzUgrKGcULYiiV/UhIfBrJrM4Ut9hRmggpT1yVSnnbtU?=
 =?us-ascii?Q?fovifqBDyoib41D0KI+EXfG97znagf0dyxFqh1FTE5EM/JlDKgcFqtSwEgei?=
 =?us-ascii?Q?khkoAdNO/g0XXzX33F/DH1Bqbkq9HV1jyS4/1Z4C1b/onHobWZKKCilQRmaA?=
 =?us-ascii?Q?ZtVkMIrJjLBhqhVITgsZ36YjmIDwSxEmy+UjYLlTSIru1NO+SA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n9UkoYrVj6iEh0LyRjhkoZK/KqXMLBpdnzeJrh62y8Jp+08vOyDEFZ77sN5e?=
 =?us-ascii?Q?1DuKAAis/ClQpw4x8/hId8qTf8iiqLPPQhI1nvKbdswphXO6d8XwfBmBxNHC?=
 =?us-ascii?Q?kAas86D7VYECoWO/nPMHZ5deL7T/rHqJeagN/5zPfgyaLfKVeZnudo+AyEer?=
 =?us-ascii?Q?8Yp4PjjTJdUISu1dS8GrRwWpkA9VvMJe+qiOAp+uRslqcOBSI1FcF6pLDv5A?=
 =?us-ascii?Q?YZliUUo7mziTAMRMaSVy/3XjGyXi9Tfo40itqPiUyD8RI33x9x8Ar+3TUjzm?=
 =?us-ascii?Q?enl+yimnyLVnRjsD3MJkgW47I/kw55/jwyTYXhf4/pRVX0z6Wz9u7HJIj7iW?=
 =?us-ascii?Q?/Y937MoFCS4le8/vol3Yd0/nd+GDmYLU/2NFQFI0u4l9rZB986/NHHhyPrFC?=
 =?us-ascii?Q?m93dPIcx4iB4esBOgKBAJ5vw9nvgSBwjkHnWw3eFFg0SywF7so6t4rSridjJ?=
 =?us-ascii?Q?PJhubLaa4uGi/4a2zsyNdKHG58l/3d1/f9BxsZuULecNDVpvxc31hPjNZat7?=
 =?us-ascii?Q?7JJ5GF8eSol/3fU2tisJzmOpJE01Cd57Vsz0ZW2xyQwrNlnJyf7aa6XrZNlL?=
 =?us-ascii?Q?Rrwt/3vA+ev0vGw0i/qdEqp633HWoTcfJzMAhMV7G2dfkGYZ5s9/JPT+XjzI?=
 =?us-ascii?Q?26od4j2F0LTRv42yBdvDlZwuoUit0J5zG8/8RlhG1xv3+1YV4COtOxvtQuXr?=
 =?us-ascii?Q?h4Fnt7QJy+2BBC7FTdUNW/1uEFZYB6PlYhIZ9RU51FvaXFeqLTxw16eeUgqG?=
 =?us-ascii?Q?Mr0+EJrSjpX/hHtpxxd94ZXpP696u3CPu0iZ2qGz+uNwKMNxhCKZ6oU1TZ/f?=
 =?us-ascii?Q?yxP0MOh4DSaLoqgmwO1aO9e6QtKiGuwhuJCTGHLo1RoM5TezagcKCsbWz03v?=
 =?us-ascii?Q?h8r26ew1YH+i+TBJbB5nLj6TzjKQjkk1j6tfpWQSKZkTdzIEg1btv0OpQClI?=
 =?us-ascii?Q?TZ5WJfnsqCtXx9wLCT7lEgWjelSUO9Max8FVhSyAZ0VIdlJoBCYOquVsnGFg?=
 =?us-ascii?Q?a+Co8g/NuUqTsWn30P9HgmdHKhUlpVlkpJcJU+GCveSxu3YDN8//n8KBoJTd?=
 =?us-ascii?Q?1DJiU0JiUWfrqVqiJsWqVr/hslPR+33Lo3DVrRNVZGydLrGzUCj7PoZruQYa?=
 =?us-ascii?Q?pW4FuQRn8kC7UgycDaQUyaP7D7XSMObzAcO8zgR0DlCl7XdSIjSv2eBZn13S?=
 =?us-ascii?Q?3XDi7Jxv7JExqGwHECRgRbKWhJdf7hf5kUUn3LLj63YgkWIi3eeKlLIE7boX?=
 =?us-ascii?Q?Fh8jwYJl/fpd93yMd33KGWxjtio2krFgfFJBL/oCzdQO9NXNU2Wg/B+oNSjd?=
 =?us-ascii?Q?iWcctAxbvVdAKBqDp8wawePQnw+mIR0n0a/8mraaOS8E+KbwoP+4NYpb2idZ?=
 =?us-ascii?Q?/Onn/+YMRhyS1AHox4ien4CdlZLt+yodihIdL7sOeDxT5i79c0xZVooJ//YS?=
 =?us-ascii?Q?ESF2zDGXYz/daEbey1f8eJfU5EQklA+20iwoIsXfe1oPsa/4vjPC4nEPy8GB?=
 =?us-ascii?Q?2DbIsuE3mYySMv938Gv0qHrR2Gn9NGy9BI5TXajG3ZXSknjpv3CSDYnn0zBk?=
 =?us-ascii?Q?zdC7Cmu3xxvniAV8RfK2qCHOI0/p5+0XHbbB30ZKcRBz9VLLTpg6SWHBTZRp?=
 =?us-ascii?Q?d20LxU9xPW9W1ukVkF4sYpfCddGu+SmYD52qXvgdQJOWbdOFRE1FsatoPN6Z?=
 =?us-ascii?Q?6AdiECf0l6UebMWM6ABOr0D/3WLFp/slCYm1cy92hajSwQw3G0SimUnEVjDu?=
 =?us-ascii?Q?IM4RvKgilNds3IeR38xVoi0vvgMKDjk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jcNAMpNFNAhKVmOW4zJ4mo2kdTMVOk1TTMDpl+rcetcAmd65Gs2ihCCF0zrF7r9uQGBsdjOrnGtONfFsEGzpPX3uxyQsX06c5ZJQglVgGvNrBAirq0GSezgjSJZT7UkX2WQO61aDoYa6NNmoii/vAjCFBhjp7f9iS7MfBfARfD0IgtdflgIUkVwE/kG2OXDuThSuXJy/TchLIheDjTARmvn3pIWDcfzjlBHfhblt8bYISeqSiwW4ETWUq+S8HW4kTAjmy7kRthteJeLT1z92vbnu7N9CBdUPQGuMmDCCqHHkcwrCNpl8awceWNAKz77qIxNtj7cbFmHCstxtJKiXdfj1orMoM1cJdzroxApldv0PWNVrJw/fmUATn+0/MNUa7l9bs3LannK4fVHuJE4G2y2R+6gBlzAhRsZGIBrwieCD3gs4W+ukS/5h7/hTcwoi2xkEruL/apJ7zmcRsPzRQSTfVZwT2RAp8bZF2VniPP4ZXf6cGDBc6ivfIs7xP4QeHmON1fzquKlud4f+4y7866LXN6jzIFhh+RBmCHGdGac0YQSnpxBaEvF7XPRWnuG5/UeE00LVTcRm1YnrjfngiYa+qVvD5PulFWDaH3EkNF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83063bbe-13ed-463e-041d-08de52893e58
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 09:50:54.4231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/tYov+LHt3DDdc4ZbEDYJZD6yincca3THwOlec/ibI5gFNowsx4kUAG13hDpYSLkLGUkcyn0mvnNOPGQnbkwvT3gXAvyVNlon4+3K/UbJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8043
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=700 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601130082
X-Proofpoint-ORIG-GUID: Pev_yil9fHsot5yAnLjATKqoMfwNqpt6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA4MiBTYWx0ZWRfX5QesSiySjlTA
 PWjmas/8mjtWxH/iZJAN904zjPGIUJhGpzUsHeRrPmAOZeSdCVdSgwcami5eR16uJGgZWyaxWDb
 9nARkJsMzxdBdeh2DVtNAsiLDUTqSSsMyEMJ7mcsDHPxVpyKtiyYbXt803k1846IBrlbReOcpbm
 m56SXwuEhn/87UfuWDIGY75XDB1PvM6u5QeI50JSxcRv5+0xt+CprJjCz7OpRhC+D/J8WTu2sa+
 85llUF8i8V6hGGmI+rK8MLzo5NTcglGXqpBdzJGn58qOnY6EaXO33ZloPFfrcrcFzsrgFOjG/Ux
 IbDLNK/94Czjvi9WLWyF51jt78h7+jDos/Q5fRgXKCOc+qjnnASaHVlGPDjHkrsNEEsMmTQLrP5
 IHYGWcK3M2XIaNPMDOkn21aKDpiyTynBQ9AT2FwZOHigW6K1DCJRPjmxx2U4y+hM6j4TmqXtOLu
 fOCDvcboiNjzFMCrG6Q==
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69661582 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=1EsaE_6oAAAA:8 a=9RQ4q-x_2KqJBmE-au8A:9
 a=CjuIK1q_8ugA:10 a=-_B0kFfA75AA:10 a=C_uGWJENdLkA:10 a=UZ3JVYxZSQwA:10
 a=3ZumFrijQQ-2J9H5h8ct:22
X-Proofpoint-GUID: Pev_yil9fHsot5yAnLjATKqoMfwNqpt6
X-Stat-Signature: 97381kdtpc8ebctptdsjd47koiwp7tcc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CEE5180007
X-Rspam-User: 
X-HE-Tag: 1768297869-59023
X-HE-Meta: U2FsdGVkX1+k2LumuulJPVATNNjOt6p5sXvkvoOq7XnObMeMBk1/zpq9M2hvNgV5/0oR1cRqA/vKcC3cTve/hVf7l91hg5lo3y3qufSSfjOtfg5h/PaMjbpnCX7tEDzI3kM5EP/TGAVXmAal9k7pcqFVB72+oONc2phO94yHiAikjW+g68Vv72qIxWnakz3Qg86SUOpPtawm6lB+qdViuPYlSsYzgR4y9JIdhKQyPIwKkrN9/2ApTbr8JH0hzIwPGQyxAeECIjEdZ2TaJKVB3oqdK/F3rwcgji3ClzOwQR8L2tH0jAIeTdeeAvbCvZGqKy6Dx39s6Z5aREXWZ/wRojmGsY64x0Qw9ocZAWlZiLuBZBoJ+AcSbAEPdY1D+vqOKkqgrp56Zwp6au2EZSCUkjcKnmBbn9z+qObGiZH6Rp54oQvQup2u1YqLNzqhXSJ1LhIj0D8C2du5LofVgBDS8JCD5at7uUkTJaR22NrCJ0dzYmKwjlOWv2QbIdjfEYuAiGzlEXiVCdewzeFBe2uoEv4buKPEKPeFv99ekhbldRN+MxMLUSfmtxml7n1Ls4c3j0D0bxIGo/DaJrQPwFBhFQ7MyuDksBQmSz9wBIXk9kxrdqap4GCPJRCIoy3kuFvz3a+bblN/jE6nhYT8HfQ9dXMvD0Jdnny5Em3OcJaaFRQW2n5IgfnPGhtyn+AkhtNrwx57d6dJEgJlcCdT/j1PCN40i4MRV5mxQanJfK+pm4YG4jG/TDAZ81J9T83xqFvMe31YTkiHkoK+BbKGR19xEaDSY7njYQFzSLZekWsUyDXkQs00CoMC2+2KetKVM6sQoO+FHsRbiORmUNKsjYsrU0so7DguogMCw/TiccbZOsCHw3NKHUJUPyRCwZblbK8rq6ePFxhQkjEzEQnBflrc4Cbll4WQFqGUKXb2Bg0wSnk/ztU6x88VvFhZbQSkWEjWSZpCQgZUWPyeYqswad0
 8jyXScIt
 a76bHqQTf/56/opeGEUF/JTUA/LBnwpwObwAklIPc3Tz+gvNSa2t92M9qJh3tNEGNhhAdQ3orFcIlTuHY2bU6J44ZQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 09:26:37AM +0000, Ben Dooks wrote:
> On 12/01/2026 16:33, Lorenzo Stoakes wrote:
> > On Mon, Jan 12, 2026 at 04:18:20PM +0000, Ben Dooks wrote:
> > > Make khugepaged_collapse_control as it is not exported.
> > > Fixes the following sparse warning:
> > >
> > > mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?
> >
> > Thanks for the patch, but sorry to say that this has already been addressed in
> > [0].
> >
> > [0]: https://lore.kernel.org/all/20251224111351.41042-14-shivankg@amd.com/
> >
> > >
> > > Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
> >
> > (Small note: for something like this that isn't fixing an actual bug we don't
> > use a fixes like this).
>
> Is this a subsystem preference because I was told I needed it for other
> patches.

It's kernel-wide see [0].

If that's not clear, really you only want to do that if a bug
(i.e. something has runtime impact that breaks something) exists in a
released kernel that you are resolving.

It's to help us keep track of when bugs appeared and when they were
resolved, most pertinent to stable backports (if you fixed an actual bug
you'd typically want to Cc stable to kick off a backport).

[0]: https://docs.kernel.org/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes

>
> --
> Ben Dooks				http://www.codethink.co.uk/
> Senior Engineer				Codethink - Providing Genius
>
> https://www.codethink.co.uk/privacy.html

Thanks, Lorenzo

