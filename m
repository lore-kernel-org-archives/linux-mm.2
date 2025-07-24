Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52015C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02E18E00A1; Thu, 24 Jul 2025 13:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDBB88E007C; Thu, 24 Jul 2025 13:32:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9E18E00A1; Thu, 24 Jul 2025 13:32:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62A28E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:32:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6401C1D9C0F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:32:40 +0000 (UTC)
X-FDA: 83699852880.03.CF47F69
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C3731A0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:32:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aM7qC3Aw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IclZOBhM;
	spf=temperror (imf19.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753378357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hEmU7C6VgfZHkwLrVrbsoCP3rECS0lt9HORXNTPmnD4=;
	b=YsX1zhPbxs/kxvgt8CtcJzZCJfAsZGR1CtU08rE03fIUmf5QR5a/wmpuXaSY5OqGriRfCD
	87tAzjWXGEEc5Ye0GnsvIW+v20wq+6yrnFcSrcJCUjmo7OuHWCFDMT5aWGkwQ8uPsAAGMo
	f9dw6ugovJrrAXNDmDXrctiNkfRXnhg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aM7qC3Aw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IclZOBhM;
	spf=temperror (imf19.hostedemail.com: error in processing during lookup of lorenzo.stoakes@oracle.com: DNS error) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753378357; a=rsa-sha256;
	cv=pass;
	b=iDdwDwuh0/M51PI7ZRFo/qz1abVRKoth0RRGRYKSGHfaCoH7mg55xGKwx6t3iKfpbAeIdc
	dDCarA2gxyP0n/Iqh+7VVoeDBuZ1LPftd2WDMEap48MbM+BskwTZMWrtGFsNv6Ci3F7qLT
	tAAwzomURveA5Wa5B4E+wGXQw1Ektwg=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGip3f000428;
	Thu, 24 Jul 2025 17:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:message-id:mime-version:subject:to; s=
	corp-2025-04-25; bh=hEmU7C6VgfZHkwLrVrbsoCP3rECS0lt9HORXNTPmnD4=; b=
	aM7qC3AwSEYHcg6BgwxctUHgLAmhTdYOGy2sBCDUVksIo8Jc++5gyaQJU7NxwWCF
	jwPfJdtK1ts3TIgSCajRUk1zmwpkqxNKs310w6VlYmDrJuby7bgrO/ftKJITE6FQ
	uWib+zXfP1vPezFS5g05Js6ua0o3UKIWS2DrNfuUPw0XKaDE6Mmf9xTAY6vWZyoD
	dZZhspI1stMS/VxEeYAiMxKqiOKw4gwz0S7aaToteBQwzu3Ra9xQgf9lrJ3NEbmQ
	aU1f3zxwCkNUGOLaZpBA9DPviV60eLdrN+cp6zmT3DCWjlwLT5rIDrHGPld71rOl
	9NiFq/WoJEQPwabUGDkS8Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2j2mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 17:32:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGeEXt037763;
	Thu, 24 Jul 2025 17:32:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc61g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 17:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skPumfqP8bpZX+0Rb0iksY+FGwbfyhJrYJLB1MhOfoXwAQ6cJ/vG8GODDglPX0YZSqo6mhBZkXKox+XLL+5LzMkp1zb/BUqVA/hW8SnU1fF4DsLg9JHUs/7viGjR2NzjI2TyJg/X4kwg1p0E5Vkpi23SOHEiufOva3bvZT59lMxdBQ/6aZdWnQjcbmQ/gPbtcMv5GugQOhtbxhjdmqtFkrEpi27tlAyCLMnXhNb4XJJR//19ghNCctXu6l0yX64TK4UlM0r7YLr/vOUJW4tW7NrnRiicnKX6Ax4Cw7GrFida1IgIxXiKfdj633dC0w1TfF966y1KsDQrUxZ4Tn+d+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hEmU7C6VgfZHkwLrVrbsoCP3rECS0lt9HORXNTPmnD4=;
 b=lmqlJcdnkF/auaWfpZG/sX8SOgi+RPwgtqSAt4kN445ZrgmbF/HQp3H0Tp2JpK1YihZM19vz8VJy50+WsKwdO/L2gpjk7znwYp38oMC9MuB4bOg/GKrKaNZBDiljKJDCfEBfwHRYDQbMc5+o+uLcv+rxlD6jTMMKl4I+vSJSnN3LHH6T3MWiFMM1OQV71R2G9jpc41gU7WW3RHE3nW9L7E6qvZCk1dhNm3n84RmBI6bjsOkZRtJHFG2nUZUb4O/uxWpFSTALRF25CMajdpDx6LljY7uuleOAnd6uMV+KtdZtdnKM7wW0FoadoAqOLX+FDeNYK6Gh+61DsU6Xr15p6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hEmU7C6VgfZHkwLrVrbsoCP3rECS0lt9HORXNTPmnD4=;
 b=IclZOBhMCHPMFahEwGeWhUEDd/gmJ5QpQhr3up02Ews1rsZkdzsr96ImWvB/N9g8MJySxg4POiQpeYTV4NfmDevIAFo34uGf4yaXN2/B9aYBjWtbC12LCUB9hvRjt6ZYEsn+7rFvhyFtPH3LlKsPmCb79KdOL+CPuNVUcpFKVuw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN6PR10MB7441.namprd10.prod.outlook.com (2603:10b6:208:474::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Thu, 24 Jul
 2025 17:32:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 17:32:26 +0000
Date: Thu, 24 Jul 2025 18:32:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
Message-ID: <kjveoiyczkjlm65d3agasjbtplezshwwjyudq4jbxhygcc7plm@dre33kse3y6g>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: LO2P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::33) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN6PR10MB7441:EE_
X-MS-Office365-Filtering-Correlation-Id: 173b34d0-8d4b-4b23-6005-08ddcad80ed1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kwIs/8KfeiTSZym+TZ5whwtvNWMNFWm10XE7hm534lvXqPLMx512CLRci/Im?=
 =?us-ascii?Q?iLEtkYg6zmbPVkK+P7XYLbFLbUiTbCx6nSXVZcyvpRozesXq3g/n5FrjC1iv?=
 =?us-ascii?Q?wFS5xFKg6fDeu3e9n1H9VGP+T+/URuSVrKbmWcYtj5kjs8StFkdx8l0JnoKw?=
 =?us-ascii?Q?ZAJZ2Vv9EUGkGqZqwavHISSyuiucXYJvHuKGvjg0204zTunOPGWiHVcMMPoa?=
 =?us-ascii?Q?hQ4g6cB9YXww9jyWvQXy4nDe6666xpcfoZGZACdgf0O2drTVSh95e7wYtFrK?=
 =?us-ascii?Q?IDNUMUjU15sinpnBGpCuzvp5G2X10Wks15r1FRhDA1FWIc9xZ9haVFdggH1X?=
 =?us-ascii?Q?7HrDUPQWcvDlbfE87KEJvZKuMFFQJXvUBI3dg/A3z1cQySCVR9Tppt7D4A0h?=
 =?us-ascii?Q?4yQTwvOsAntd7ILDSdNYH0IsqcVTrMWvScZ4QRWon3skyxg/3hfFsTA8dkSm?=
 =?us-ascii?Q?KeUNewmBU+rtDIDjzq3vy5OLqVFYKu1ISkDA95zHdktBdqsEOIKYfA5s02/y?=
 =?us-ascii?Q?zvfMRKHAnpzGA9nPi+1dIkvtg/O5UButBeixZKt0XbPvjLx5v5vi+AUz/jdM?=
 =?us-ascii?Q?6/UsxuabcunjH5Acvvha9lpL4CG51CcDJSd9IplXUfSR0cy+GUHPrR3idrKY?=
 =?us-ascii?Q?Y8qiCukMdVhWxHvNEeA+PbNCVOoVfprC5M31K62u7xE9OFMFTDmpswRfL2aH?=
 =?us-ascii?Q?rRgHe7khCMDkeJTTlN0ZieQwN6zwjDGNrNBMujdbbJiOb++62FvCAe5Ihnkt?=
 =?us-ascii?Q?5y0AtRbt8iBWMugJNsMYvCDfZ10bb/ZoTio3tpn7dZoFe/JzD+jMbsWNLqhh?=
 =?us-ascii?Q?OWp3iWaAvQFxgliMoTYawTkmmsSVIhRim3JNIccr07rWhvBJB4kl/jJFgVwa?=
 =?us-ascii?Q?t81D7SGgrcdDYFusHXDbGtVhIqiQj8XkP//loNFzRHdegxJGIPcuOQyLHJCr?=
 =?us-ascii?Q?oLeDxekYdorJfgN7rxUwgvoGGi0rr7LZiaGmkLjg84dgvOYCl8MCpq+UoabB?=
 =?us-ascii?Q?xC++5CoYXCMJJswg0G/5XOImx4SnS8hBYv4sNJ4liTGdjBFLnRwY1yiJ/tq9?=
 =?us-ascii?Q?kduCYlruvFyO4LsVreUNMIAuc5k5FbzI4mSdk3EmSk55GzORoYIHXUyc3Sjk?=
 =?us-ascii?Q?dd5kXKVe69wlp4CFV+crX+L5/6+NsfFuc9UqFcPH81jW07N+2A/BmEniQTj4?=
 =?us-ascii?Q?VEtSKdC8P0XgqJjPhsNaXEmBeFwUAaKi9FIDPKgTcRPJgW/FKQkm+Q6wGOSe?=
 =?us-ascii?Q?cfuKCi99wgOuppl6lWram7OUTp9EfAEuVo9UXdJc0oEoSDzM+lFO0YBIymDX?=
 =?us-ascii?Q?YkmJLhcSFkcLp+UKoZZbtLhGFkJtKz+SKIiDDwsfzJFF7bmK5ss/2czoyioZ?=
 =?us-ascii?Q?9NJl6vZoOfSaK0mCt2arkqs93M/MlalTjXGiPlaInDFRkkEQ0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D72urQ7h7oT4lxADd2kYLc+/1eYDgHdgBeAnQRugR9AyprNne2d8ehwBjDkX?=
 =?us-ascii?Q?5I4BeJa6ZzYspNfi34P+Dqr0wM4Nx5T6AGrP7oUT36udt7LySsvv2E9+072j?=
 =?us-ascii?Q?KYf06Pq4pbYKg+GbCK8pehcI0n8ynsPKIPJa4KznXkg2M7J3WmtFb9HA6Nzj?=
 =?us-ascii?Q?BTbVAiEnrn2PLOp1EhVrm20fajuAmlxbLsySgko9ZA/hkrE35o3OJ4RmWDZ9?=
 =?us-ascii?Q?es+4LlJwEGmrcMqwVVQTpCmm80vXT15Wt2zHJt1X0F/L2OJvFnmiEKhD8xuz?=
 =?us-ascii?Q?vZFKSLWmH5Gcl06Auxbr+Ir4R2sAM29rYqleeUyVjdZb4dgoELnTrEpKj50K?=
 =?us-ascii?Q?FRfWdwTfyounxtqwg+C8FryVOBkGXBtbDH/ccGeCPdR8QZP2SY8CgZW6OjSi?=
 =?us-ascii?Q?9irBGW/aMyt0kqmitJJlnjbADh9RUkg/Ht3E9pv3JXWrs1N9tnIlVmNbPez8?=
 =?us-ascii?Q?ixhOImrH34blAjxR0BpfiZL6C0BlyqkNCfDJ4Jk6pZwV235/nmNAu9RDUd1E?=
 =?us-ascii?Q?NX7BZWck8I2tdaqDLa9xSK9M+xsHdKwEO6UNHynUZUqeOMo6WXjLrJ4EzRP2?=
 =?us-ascii?Q?Hybs1heNQY3Lmu+1FT6GGaPKw+YkRvY00ISurM/pE88LLyVQA78fVNt/w8T2?=
 =?us-ascii?Q?PpYx/PxrH0uCyF1zv3sGnK+EjwRo/bcYDrtNY1kWRN0y7RrZcWteRW4hXufT?=
 =?us-ascii?Q?R3iREoXIt6OznGZx+LjE/nvqvOmC/U8QXgJbo1fke33N7XRTY0urXRcIfxGf?=
 =?us-ascii?Q?PLT/rkSvquxqAKI86Eluxn9YbVvBe5bb3CqPiUHThc0BYoy5HVEc+N1H9Eol?=
 =?us-ascii?Q?NgDkQsBsTJq0Dr3D/L+bVBDwk3hHDivRMODEyq3cYICthpUsl1ZjwkzfIO+O?=
 =?us-ascii?Q?1fMWz+xS7FSwJWicWhdsju7vWVwnkIpFzNijPCj0ZHVmm2nAQSRKfiLYdnPZ?=
 =?us-ascii?Q?+6+stmwYByjCHIpnKQzoF2Cx89OdvzG9L8om2voZvdf8QbYDHZ6DJ5l+MFrD?=
 =?us-ascii?Q?r+MW8Y4M+NnCq2FYmPCgMh8U4QtNfiVCxkUWHozNGfcxfxJ7OZlE4ue7o/7D?=
 =?us-ascii?Q?eKO8I4jKfcY0cYNI0s6XALSTzaq17g+tS8cfbz6Od7rwRDwh9TBszTaZl72L?=
 =?us-ascii?Q?CLyjvyc1UYtyEDJyztweCChs+6QNEIwLQwO/x2JvBP1dTR+l0xFbw1KKPTsW?=
 =?us-ascii?Q?YSApBzkvCyuJuvgfDD9Scx079H92V8z7YtZNk4rBiwCcDQIoHHTJxV9bf/Lk?=
 =?us-ascii?Q?Wx9aDJoE8kIv9IwzQmbsmMC1nb7K6/y6edk4PeBO0IFhrRmDtQORFD9YTt0S?=
 =?us-ascii?Q?u07GViykww6ntVHBdUrRmodqRojXZl4gqV8dSWN7XCz2rSRIGDIuwgOuE1+n?=
 =?us-ascii?Q?6v+M1i4gUAKEB91ylV6qVFZq5j0XtNxHQxkTp/NJz5lY8lBkv3BVaCX3SYuX?=
 =?us-ascii?Q?BVdIVNEjPq0ytQNk638IPNkXu5s0fdj3g5maddLtPVPMuz8/SeRtAHYLciVI?=
 =?us-ascii?Q?LWLaJ9byiwI8V3KDpHmPu8T2Zfj6CbNeAqtPqhSn+xIi9CEzrVgdjDjlyAUC?=
 =?us-ascii?Q?9k579s1KZ22mV8eckkW9tdAgOTkSJ19vCTpSffKxOAkZ8E6YD/2LDeOmL0eC?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Af1sT2yE55iqMBsSsrz2K/3+eNvSYLifMW6QPN9xzJMYR5+gu0+U5z6M3J6FMEwUpfU+Zwu8RpTeSE/1c7703hj5/LFa2ARkTGfLYyHadz14wFdNLDT+9Evk5+zw9UIkH9nTN66czCR32xRaVJ8Sco1alrRNGMC4Lsi2NL17zLohxpJTWzrdCwvH5X27BSEeMzQr+l15oZsAk6mK+bBh/Hr9xWpTqFcAyzu/9wtD2hYqM2I2WokqxRcUnqP94SKdCfcgzsG0E2S9khnozSeOVmfSrOGCccai3qgcxmIIVCLJ9x0OwgDZRu8LnZGEzyPdWX8QggF7AlXfw407aU3B36+R1fGmnN9c27RNypEio60lUsljodkdAYDLTtnqVU7w8bs+pdchTNQBbLv5uddFhKVj/N8WPyFHs6h8uy5gfJljyGFZX2RX9RrJQKRhQ6lus5mrjhm272OTRum1NZZPIYgQLBWz5qKKF8vAg9203M9cr6NeoC+k6W7HyTL1CxrkxYINFMH1tUk8nhSkjQSwKzFolwpqHgy2hbDIF+9bzyjDZFxADPCGbk3hFUMXD7G6/JE/IzCORzCZ46eAXzRvIH/uSJw6m0X+eMe1uWePoZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 173b34d0-8d4b-4b23-6005-08ddcad80ed1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 17:32:26.8257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBY9Q3rOuC09leiH7zSLJkE3bwxzrF+Stqh99OgMgAtbQJRjmAkSacaziIL+KaCY4Bx21J2AYC8N52lchYuILxSKllZdlT7rn6kxaBcD3LU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7441
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240134
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=68826e2d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=jZdpnXOf7zYeRcEhYLkA:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12062
X-Proofpoint-GUID: z9FAWTpP_g431tKgDNQ3PynUf68gUSBK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDEzNCBTYWx0ZWRfX+TtVr6qLRE8e
 /AgVU9UBB02VHvvmq1q3wLFAn6ffOvAojQ7LXhJSnLSkoOvcFjUxH7mtBluHm+bSVfemusa/ize
 VszjlZsLrtCqRsFMOcYSyXhTY6wMKww6I2C+7qLUvii/R6oLVKa2qeEfIQNWTgjNaYCBM3ZxfUQ
 DRGq7VQ/nNjOHCXihoTtGPRcF2ziZKa4GqVUUkXLvlUqkKzA8tmDvKbttAiRixaxVw69nlH3ZSz
 GXNePRU11zsPqZYTGh7DP62ALmZXRwg7MLN9djKMfCgkO2dV7AWkBgJa+Xwawow4dH6IX3BqTjy
 mJnfGHNuQM+/CYKTLbeJCsEWdbCRj9tYUL+mCzDaatd6GpPY/Sptzud4Cj3eAdourVQkaxOF7Sy
 aDzUCXrId98podRfcu9zpsyibhbX3hVnYmD2YKmt1FsXk0BTAut7F7+tlFq1FxqkZHQvoRgU
X-Proofpoint-ORIG-GUID: z9FAWTpP_g431tKgDNQ3PynUf68gUSBK
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3731A0006
X-Rspamd-Server: rspam06
X-Stat-Signature: magm4kmdjni8nrpk1qafgh765u1hfhx8
X-HE-Tag: 1753378357-78847
X-HE-Meta: U2FsdGVkX186tQz5AuIXQhjeBnM8kllfDnM99FuIliTVLsIiYd7Mh4KALVJpfn5HmInjsESwJAUScrmkfF1085BGtbLLpJX3dwXqpsCyyMsfaOWe9XThQv7KiBaQS6hph5hACIUgz7MjHxRKcN1aJoGVpPlNkmyUs4PLXp3p7FM20QNzIUl8hitqR3NFZ8eq9QJQujJ2GvkVLB2pHtwapmftXzUYyJJq4cNfadCKyoyR7S1gULpfErZ0xq9JE35OXqX8aG54e9EThugYTZrnEsTfx4L9vrnit6xAu+8fr38HAHN9QdpOAjK3eox7/WeCtN9C5OTox1uYy/wtyQibg1B3peDy3EstCAhDrE+dvAVseNiSKdoSNTmJ2AqpA7bZhycdpqWzF3DAcDTxgcB94jc3fMBXeEEeI6gG1CM3VFe9RBdDFOuM7GttA6ReI5e/jYylDAttICNkBSV6Owf2wppiybRUtsUTgOVla2ZGEOzVHlPyqMIEBSdF9cZyAJSVlhyITj14duFxxhohBn+prStnpCMKdJtFSJ8uziijnRzG05f0V6a9tOqewgS6QdtNcWBmVmnFULtzVe7zSwVuMf6a9hDFR0NtbMewZtSPhxlMEmV+BKn3PkVr7qDbZwepUSink0F/oNFtNtYjavoH0nsn/Kx4vxKJahgRe/GrYDEDIgIoH+jhCoenUe2/7va1d+G35FyKDrVxfejN3aAA/82Y/qRFSCevgLjDvN8YsSKhCdrQ+tRGpQlTKfZFRTb8xbhAltBzSbnWqv3SyARMxq8XmbRIUmnfebGJlSlUteFHXytOvpHz0n+X6esYVl/qXHpijaqDkKigQXoCZiH5bwAwKl27VoLYlMWmdklx50SKTtgBuvzWz3GpjFy2dG7ZPVmKEtVcbhG6EddeGb5L4jLyybOq2Lw6NFgKwr6VCCFrZrfQyz5RpTxrCCNAKUMA8uPMo9dgv00mW2/IkPW
 3DSWwLyu
 dE7ek+aD/Rn+Hge0sWkjKS8C9xQ56tpBVEt7vFRusZg2n8ck+deFTy/wYpeKHLCMcVeyJBhEENNLA8YqBi84oKK+/6PAI09p/0bWDseaSt3VY+qpTJqm3St5WKDKjLNuY4cv2jzAY76j7ZW/ahIH7G4ZOkLWIydni5ROPShWF8BBfqn5j3uSnuH/745O7vzOCj/9pHY8dK506nCKppPeXl6QFY8OWYry2+YkD5csfOUGz8mlsYHZSNPCop2tvL9irKPhqwSUYxQen3om2BqfXlqxGiJ0I99CdOlAbZ86nYxd9NzyY7zgIKEhrx66Ir5WZgZIJwF96qjWrsjDKIQKkGll29hRizzM3QtUCLyAk9tveQyC+OUCM7WfvYkYQlHhAn+G+TMrmAvoHJAcfhAMTL1LLnAULOknudPEpT9K1HzjDMkkRjOQNU4hbWiRRUf7yX/o7pGy5xfw96WTTtYdvUzzEy2NeBwvepmsTThrjdvzFwrrM+Ex2gomL5n5ngrYmj//92WBjx/KFFGTkWesh6YZF5NLjdWG6J+UUSLf+wXCVn1HJGUfe4k6c0FFY97NcqBWbx13O/IjQBovi1NenvskoS7pbTqUT9OfHg0vvKwipwXw7e0Qk5EIpy5ORbDhJ+gE1ThdZmFuLgWc7KRwFwMe2YYQnYqqB5RcdgNfJkUh7nUSpD28ENOsgiptCHIbfLIngOYQbgBviWNqx5hQoHFIfT6+5jYWHbTXPApsr9MvujAa6sgb0xGi2wZKkVJ3/eL5hvbse6jX/iExP3qSAxvsyPDU9+7H9Q/eicSmW4Q28/4ann2ZnFIfL0bQ7LvoePRpgb5O3rFlMON2oF8G+weWU0pKgQWx+jkeP6JKmabKdvYhJGpXVkEVYXFchBpynQ39KVhzbWTQkfsAegtCPb76kIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Message-ID: <32843cfb-a70b-4dfb-965c-4e1b0623a1b4@lucifer.local>
Reply-To:
In-Reply-To: <20250724052301.23844-3-dev.jain@arm.com>

NIT: Please don't capitalise 'Optimize' here.

I think Andrew fixed this for you actually in the repo though :P

On Thu, Jul 24, 2025 at 10:53:00AM +0530, Dev Jain wrote:
> Use PTE batching to batch process PTEs mapping the same large folio. An
> improvement is expected due to batching refcount-mapcount manipulation on
> the folios, and for arm64 which supports contig mappings, the number of
> TLB flushes is also reduced.
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/khugepaged.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a55fb1dcd224..f23e943506bc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -700,12 +700,15 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  						spinlock_t *ptl,
>  						struct list_head *compound_pagelist)
>  {
> +	unsigned long end = address + HPAGE_PMD_SIZE;
>  	struct folio *src, *tmp;
> -	pte_t *_pte;
>  	pte_t pteval;
> +	pte_t *_pte;
> +	unsigned int nr_ptes;
>
> -	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, address += PAGE_SIZE) {
> +	for (_pte = pte; _pte < pte + HPAGE_PMD_NR; _pte += nr_ptes,
> +	     address += nr_ptes * PAGE_SIZE) {
> +		nr_ptes = 1;
>  		pteval = ptep_get(_pte);
>  		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
>  			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> @@ -722,18 +725,26 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>  			struct page *src_page = pte_page(pteval);
>
>  			src = page_folio(src_page);
> -			if (!folio_test_large(src))
> +
> +			if (folio_test_large(src)) {
> +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
> +
> +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
> +			} else {
>  				release_pte_folio(src);
> +			}
> +
>  			/*
>  			 * ptl mostly unnecessary, but preempt has to
>  			 * be disabled to update the per-cpu stats
>  			 * inside folio_remove_rmap_pte().
>  			 */
>  			spin_lock(ptl);
> -			ptep_clear(vma->vm_mm, address, _pte);
> -			folio_remove_rmap_pte(src, src_page, vma);
> +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
> +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
>  			spin_unlock(ptl);
> -			free_folio_and_swap_cache(src);
> +			free_swap_cache(src);
> +			folio_put_refs(src, nr_ptes);

Hm one thing here though is the free_folio_and_swap_cache() does:

	free_swap_cache(folio);
	if (!is_huge_zero_folio(folio))
		folio_put(folio);

Whereas here you unconditionally reduce the reference count. Might this
cause issues with the shrinker version of the huge zero folio?

Should this be:

			if (!is_huge_zero_folio(src))
				folio_put_refs(src, nr_ptes);

Or do we otherwise avoid issues with this?

>  		}
>  	}
>
> --
> 2.30.2
>

