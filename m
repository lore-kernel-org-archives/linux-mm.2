Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00FB3CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 00:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6CC6B000E; Mon,  8 Sep 2025 20:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5771B6B0010; Mon,  8 Sep 2025 20:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418116B0011; Mon,  8 Sep 2025 20:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5326B000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:35:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D952F16031C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:35:06 +0000 (UTC)
X-FDA: 83867842212.26.CB3FDAD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id ADB2B120004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:35:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EXO7N9az;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rkByTJGQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757378103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sgk0tGdLcxeSeRA6Qizws3Ip393jDHirzE2NJO5jEDo=;
	b=lP6wTvfjNa0e2gyexgczVU4sTSGFSRsrKPs6EhPtb2vCyFhX3QFrrAb4gpBCIXSMzZXTVE
	XJUBcrkcO/N1z51mVWoa+GfteUVlOkW38Bksd3pe+LeBLpnFqwwHroWsXCA7/OYRkfSngO
	FtSS1anK7u9VzEjYvSh6co99T+jO0qE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EXO7N9az;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rkByTJGQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757378103; a=rsa-sha256;
	cv=pass;
	b=GhiCE3uRxXk/va11oBy0gaYC0IBBHyOZZwtQ02JKEw7KnKa0eiWFZAhsKZGXFRE6bZeyJA
	ZvKcN0N/Hxc5Q5U0Jo7GA9WK/AySCQS99XM8H3cUdQObhSyDGTDNwUJL7fsMq9hhaibiD9
	52wPL/yr+pfAIOgeXyFNQOwWSf2D0nM=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LBh1w026472;
	Tue, 9 Sep 2025 00:35:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Sgk0tGdLcxeSeRA6Qi
	zws3Ip393jDHirzE2NJO5jEDo=; b=EXO7N9az9VtBmwR9eoaRi2sij41VlaMSgW
	0qjtX8utNwxBejmj3Il7oEXYcIJx7P6o+N0CmuK/aHsK6sYjKa/CwiOFrvzwjXM+
	w313C2XZCkeUOy9gdwFYfEaxbxUoQGbgEJLflpY1CBT7DV3RybFzxfHvavxE6lH9
	VUeK0mWcS47sC5KoWR5mNHEXd1ZsSYK03kP1xEuRjDav4yzK7jyxuGHqrjFgQCtt
	EzVO6DH5oixYAw8Iw385oAfMEaJlTu7Kjh/Qk7tPsiUtyQgdjf9OELu/Y4Mpq/73
	jNCpkfcf9Tdk5OCFZo67JRM01XkDjdrSGL++Ks8Dg7x0ZS89ns0w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shrp6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:35:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58903X2t030644;
	Tue, 9 Sep 2025 00:35:00 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8vgjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 00:34:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QzLl8PPWnvr1euFITxw+0SSOWgBLDVhDcMKQVwVwYLKDqMmDiCwWewves97fJusVT2PmYFXKKi3jcUE6Cf97/KjpClJQizSU4L2ng77WxNuebp/AL7rLQpLb7w6r9l5OV8qejcBSIRXqeW3hcDgM/snIyEjT6kQTdeA20gDTmPQeA8Xy7eA2euwY2dn6ngVWGNkfy/C9NiGBZ2Y3P5DVQCVCxPb4zE1671yhn+VCQjc47Wln+41yW6YHSWDtecEkQ8KsP3v+RJEO7P2uqJVDfM76CuuSdryVpuHGdp7pocT85EhDEpOAU87UPW9nNfmtuEsJonstH43hxP2wElU1jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sgk0tGdLcxeSeRA6Qizws3Ip393jDHirzE2NJO5jEDo=;
 b=y4s55umHiVLYJqt2W+wYodxYHTk52LX61A6/D7dknrgwrNSCbuT/VS9esOhNwV5gdzeFs8Pzd4zhJ2o6Grgw0fGu4kkSkj+qyqy1oexBsrO8ZTu/RhCAIIdST9cM7fofT8u5er4nSqAqinWkUJylqw4W21eRbUTs2Zun9XtPeSg0b4RpddT5FRDBlOGMy/sYBobmJFs/7A+0s7h5+1UJEoKQOFQE+gbc8YoF3aBljKhnQD67cx9fkFfvLyncOrM+SFnNf62omoYi0FvGUG7W3cN1mL7j9fp4fsBd+4WbTW7gLxl3fykDsV1e20LB6mk7eMSO4gTgIPFW/3CYClWVxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sgk0tGdLcxeSeRA6Qizws3Ip393jDHirzE2NJO5jEDo=;
 b=rkByTJGQvN3uBct5cn9SwoE3zPifwtvoR27bYzJADbY+dqa0bGPFfat2RWY/QYe4y6M3jbnCiAFem22oJbqxzBn0Ec3IbI0/OL0XdQ6JTrrL4tVMCPpIzjrZNk9CGiP9H9viCXw0IvDZkgrGuBabMWyrdfIDOTLJ7FrO1bO2n6s=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8369.namprd10.prod.outlook.com (2603:10b6:208:582::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 00:34:56 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 00:34:56 +0000
Date: Tue, 9 Sep 2025 09:34:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: Refactor note_cmpxchg_failure for better
 readability
Message-ID: <aL92KnzMIHWkTydc@hyeyoo>
References: <20250908094251.1080646-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908094251.1080646-1-ye.liu@linux.dev>
X-ClientProxiedBy: SE2P216CA0066.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8369:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f1f3c18-ca8a-40e7-75da-08ddef38b337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WKmnq5Us/cyCNCOIj0/oh31Tqa/458cNf6OJiNKyuABOkwWBY9XRo76Y3bcJ?=
 =?us-ascii?Q?AGrX51o/dXIg2/nVpPihaPPn3hE2Cen+2p4+u4q8DYK8AdA0D2VY45Je89yr?=
 =?us-ascii?Q?s+4CPwwUI0Xfv4OCaNwQ3pKLxsZ25M8daA6RtR4HZ0cUM9rr85k5IhWikWoG?=
 =?us-ascii?Q?En3vLCeH++uy1LY19FJXb9GAfSM4WFP3rzWdTUjj6rROUxca3w6FI53HwnAL?=
 =?us-ascii?Q?ipb//R/3VXilVLkyEYl6C5qevSZFp//9Sn9mMt/4p3mGFNv3DDCRnpIx92bX?=
 =?us-ascii?Q?wE6/B6/lqZeQLR0dvfCnF8JWR1RgWBhgg37QpzUvn4QSTT2HUZ08/OzV4CTB?=
 =?us-ascii?Q?S/22aVRjjJLb1nBb7687nA5F36pnLevvmbJkJVs2IDjBFGe2ZcV0oO+vT+KW?=
 =?us-ascii?Q?3zV+GfaGnSMOKFWvFDopZ8Vh4BrrT5jZPV5utnKRj251rBQ3L31L8/cSfBDW?=
 =?us-ascii?Q?OIl+E7C0dVRn688e7uWDhEca5X3AEQ3HCuQ+C1P7Io40FgTy0ie4dfS1t58K?=
 =?us-ascii?Q?ALFYaZJU3/R59d4sTVkMcGD/svOvCViP7XgjXsrVjrqfdOF7yL31SP28AtgI?=
 =?us-ascii?Q?Po5C9VGBTZLQ590GwP7eId3DpdHvRA8gMHPEMcVuAtrv83HjhgPfQDUtr5OF?=
 =?us-ascii?Q?7P7ai6i1IIhO7flY5IxZU59HM3pyaEvcPIpQWhQkufH7pajqXi9uCPZzTwgh?=
 =?us-ascii?Q?c3m55xnANed7pWESHkUcggDP0rnJ2rA7YWwXx0TrD2AMwy2I7/B3h6MoZvND?=
 =?us-ascii?Q?MVk43inLn1DOoL+fbTjszk75hrGhsauwM0Tm7qReRAJRt1REf7d2WrGi/H2M?=
 =?us-ascii?Q?W8TmGWOklexlt71y3kZdAmLQmuEaWmzfC+3PcEG9t7flYAdbv3/LPPmQt52i?=
 =?us-ascii?Q?9qB7m9UgLwfFI/Jd9zvlRbLJFv8i4CXip302dRnFrnjWCnwK1kxvz2rh+HuF?=
 =?us-ascii?Q?bmsIOqXICFIrMT8BYVtWJZa0O1Jwp8jnsrL9+kpGYlOT5VAoUXMOm/2jnzEs?=
 =?us-ascii?Q?0c0OP+ucoPIxHjYPdrmYWhj5zRzORxvZafnoJjBBv5EfL/we7lhdBf1jWKh8?=
 =?us-ascii?Q?LqoH4kNzit9ATRpjP6N5sxebB3lbe3M0RDimKPp0A4yqWzmBNDzNCsXzukFu?=
 =?us-ascii?Q?f33wKR5IvEaf16A9jzGUPwS31pk3ctfRxzjIVh2a40wLT12KA4DlWrlt0K6L?=
 =?us-ascii?Q?7kLuyHar7m+Bymt0t7qp4vgk/ReqKUU2Nm81zGBB7lv5J1JvmudqMr0jARvG?=
 =?us-ascii?Q?i3erwyWwPXEdtc2ICggzLtJru7LTdXVDXAZzkt2jgBHEuhdbN0dbHJ2NsBg0?=
 =?us-ascii?Q?Ft3VLhx7g7vQjQ9nE+JSmVAzxt2c+ubew2X2Hvy/mkkZaSfaeN6cz2lBGymb?=
 =?us-ascii?Q?BOIn8vNhSPM2LUYujP5Ho66z1RVtc6Ekl7EElp8wMHHVwKDUHebeuI+s6UOg?=
 =?us-ascii?Q?pnMl1NOnvsk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dVB4PhMOaz3c1AhVx81TztP6XaXcCUhAYqqtSAXDDUSz3tk+e6NIESVTf7ay?=
 =?us-ascii?Q?OdYyjq/TWJ52v3XMMmVlIFiDRNm2HV+pqLgfqmTCFh5imVN81oyNBsKf3Mq/?=
 =?us-ascii?Q?8EOHEcywVAlUYkwamxDTyM1U86Q9gyezb2ahgWQrGGMqesLNWNSnJpQmgsau?=
 =?us-ascii?Q?p0H6cQtZ00I1BoA53WjPTT0dEHugFdtWn/giLiIFcuVV03x4Xyb36pAve77C?=
 =?us-ascii?Q?W3ujVBY4FQsyzq13H+BscOMPV1sgTsiOLrUE7DjdMKYsTqhjbsrCI9p8/5yg?=
 =?us-ascii?Q?pF8fVB35F0sqd80vGYgHDI3Cu4iwaz2tCVH+fnMzrkty6nX8Aohmkyu+vp+0?=
 =?us-ascii?Q?jnnpkbxJp8wVqg+gM+HMyXds3AAN20xmVG2aPRYTVoaLzsaI/b3gukYw1/w2?=
 =?us-ascii?Q?ylHkjLEz7m9ZxSMJdpAy7zISQ6kBr48QjztDPxzszSiLUZ0z2mfy5db2+tT8?=
 =?us-ascii?Q?1o4hb0l54kMJZIylzfoewO2ImtlYwVgvFad149Cqz28YGJwq4rrbLjNBGpNV?=
 =?us-ascii?Q?Sz5VRZKHC/zW9/1STVIno99M2rUcXtyuftL5ImaQWhdysTrVPIe3UUx2L423?=
 =?us-ascii?Q?APmCWJvLPcl0ssxDHF0hSyJwoQbCieKFZzzGof9A9/DjQ+KPgswotF07MJbC?=
 =?us-ascii?Q?VS++zcs1Pps/aoGaHwDpRaY0LeSEPxL8D2Qse5K+l8x5K3XNK5fxuGrYmlY1?=
 =?us-ascii?Q?KGiyrTuX7lHRuTggT7W9r3HAmZu37PkZmkA+h4xNnOvNZ73hCz/htsV1YmvJ?=
 =?us-ascii?Q?+MWCsL4minoI8CfLm9+a1hVpL2f4qtSIqM41Kevq8J65Q28JFadQd0BcA4RL?=
 =?us-ascii?Q?bbDrpbD0Uz5XvahXHzLMlMGA7JdgHULkvl5bjtKDdSk/o89nV7EFAbhK/4gX?=
 =?us-ascii?Q?kxYfVBpE55Yrx+AefxttnxjZojQz/0zkIwbOxE961NBjKphU9iVgNGXMRf3N?=
 =?us-ascii?Q?XMU+at5cwCxEYCg/NmIZblSM9Z4w0C+5K6fETECSCuMmARDyVkD43UqtKNdB?=
 =?us-ascii?Q?5POq4ZQD75BMYk2ebBxPK83v+uFBs/ajUYp9z0+41kh0zagdpTRUMB53R/SJ?=
 =?us-ascii?Q?swhW8bOCvOhhL5lRq5Kfm2c+B3Ux35sbAQREgcLO3CMTX2M4sjgKEZZDKYXP?=
 =?us-ascii?Q?teKTgXi+YwequrjNWIj+BxSvaFBevmzb8iIX/nxWn1d6boUKF8YjtTu6YLCc?=
 =?us-ascii?Q?/OWAb883t4nUu7LIa4KOX3zIOYbkQL33KJztTYiQzdbCI1fpkoGhGBcj/UO/?=
 =?us-ascii?Q?yXZKy82JT2echaotXhQ00qtw80ATA3Su/pNx2AYsC3D4UyPlX9w9gMQGv/+F?=
 =?us-ascii?Q?pbbtTopdzBTzjX7MM11zlZHs0jjKfEFZUuoEMBxFtieUyMpgj8Du6VeT86XI?=
 =?us-ascii?Q?8rJWtuTdgaXuYEkzaxnDNd4bo74avEJ2pER55p4nxRcDnMDSZPpOJIv9ZKtE?=
 =?us-ascii?Q?J4AC1Eh4Yjs5Gu8L41QJqoDlnDGU4AbRBhW1ODrQXQmoCjda0wFAQ/+EYhHJ?=
 =?us-ascii?Q?mNlTzgexOkNHcwMp9Rxys/VOR+tzVGaa6lOY9O2LH4Zl7+6P54+++RV00lty?=
 =?us-ascii?Q?OQT9dDgr5tvf6pk+q5E8A80lx9F0t8kB7es2e8lX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VkBfj6W+p/Wm803HKGnLiSHYjbQbOYi9g8p4G+9aY8hz/jhOPEecwa4QattTdXQsWSWmfkbTPVDdgnXV4P5wzBcCP4m2luyZZVtvMYXtE6XycBx15lVgcFkYdmYncuNAr0JhRKw1RxS+z0qcXXYwaUJN9sHl6EaZ5n8KB5OZP+VjAmf//T5i/1aElB63EfrA0VXFTzHloRMwUivK2ScTlomzsBn3qxdTtyPXyHGZBQyDttF7Lys/9rScr8brEl3jsyjSB28yBI5XPtJEKKGTlooqCp2Qs6OA7OV2LRcsF+5qtPoXGkfiKGXtPR3gZx3mpJCuurSkejL4xbdu3zejLMEDmQ99lZL7Wcvj7tvOsCvXU/oJ8MbzWh/cmKdCJ8O1y2aXjm5AoGz+XaV2S2C/NC43DMhBttfcDsnkF0xmCD/Y4uTXYYmSFGft/I8i7Wt5bAHWU+/QrseRiAP6MG0ci21xZQu5/QXTsLTyf+ASZgon2HFKTkWsKXKBc1HVTn6XWRHdZzNQkgJyXoeiEvygdJrBV0c3e8iFXf8Ch/4RWrXY8LuRGCCYybBvXxG/IvLhNBm9SNmaW3qg+g2ES8bJQo79sBWCRTkVqsWUGAdrhKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f1f3c18-ca8a-40e7-75da-08ddef38b337
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 00:34:56.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8IMrY+qVkJsHbJA3iAJzTA8hFIdGvBg2ooYYBN8/HQErh55bUkGDZNEcq1CRxukAIGLtiNr/ibRcKrBhQ0ai3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8369
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509090003
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68bf7635 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=btiNS2NtoEkqwWShb2sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX2lWiJ4jna50T
 GbCoUqW7l49WR6a7HcUUx78Fcn6K/ZX7dwBw8c2wP84OZ3c1qG4b6LYHHhB+KjalBGDSNLX7aCT
 sZezvoc3NxQ3fA5F8bgAIQNUwcunEFuiHa/ifnRyrsUHw8GJqzFCXPLTp73j9wckxhs4If5Bopb
 6aBu7bpS1/Uf6G0n6BVGKI6KbjWT2uswE9ABN8LFGn7ovoYMtTY5aZGhP2eawzW6tQbr8o3uHne
 D29WVNQO1mP/mbcRNVsYNSqc/jl1vYQ0FokKNYs79NK40j27VwCHec31EBlTaH5+7Sw20V1wmY8
 5AH4ZPHldM4+1HFU05AElCzL4Ejv3aRB5amKdqPd08phJQB56SrV2zd4R8aWJtKguNZKvFL1f5z
 6687aKOW
X-Proofpoint-GUID: SC9vomaHKOA1N_l1QI3kGtmlAHd1QQ0a
X-Proofpoint-ORIG-GUID: SC9vomaHKOA1N_l1QI3kGtmlAHd1QQ0a
X-Rspamd-Queue-Id: ADB2B120004
X-Rspamd-Server: rspam05
X-Stat-Signature: 7d6tdd76a8neis1d8ji93apqm3z3ydde
X-Rspam-User: 
X-HE-Tag: 1757378103-881832
X-HE-Meta: U2FsdGVkX1+esOlL5ZFbq5p7o986IiwTtMS50Q4Q42Aae14w3VW5UeqTQaqSJpGcrnxb1gQdRqHExB+SavgNihNZTzU4p3pVOx9xFbSzEmrUlNwjzWZwmE88qa3q8z+AyWVLrSzPJk8s2yblGs/2xGSTU9I7v9ZpmA+cKoIne3vvG6a+HH2V6dyFBTdfxl5bdJL3LWwSc4pPyXZORD01oOlWUtPaNG9CM1kp1SGTl2QBK6RZIQgrEcD66xXvMpv6sqoKGWm4inyKTxFIeLTYOaFBFWrImHpbfcFCu5wkFRoqzCSYK3PVfQow1UofxeLUyfaWo5vUZehBrs1qoS0GUtlQrnINjoX2zB+0ST/d6mHmFdtvQBHH7Gc4+hY2lKiGKTlBqQ4j3aOFimQtWiPUwWsn2bGvs5p0jKw4yyDT2vMBOYHXZbCYs3HoZ7Re1xtKj4Vx/A3jOo9NZq9RpfYvwzsx061jjkWM/xU0wMGZpgCQVMaD9qLvZOw5z9rzqQ8PuTJHqczGKbnZfZGooc7hAKhYwGZZ4bI0wKS3MtQhIw21j8b3QGORIiCoIeDop5nWHgpFZWAP3Bm3nOeHtAOGK1NhMkHEqNl5jeKkW4WAY46DA9Vc7jqOHbB4KinR+RHLsl5ukMCOQiLHKKCsYu+7Ja2Ong7BOrvRgrTEk8A+saYumEF2nrczCsOcxDZ86F2tD2vvC0dDSZWIEjYSM6fwEca1s1NlWTDYMyADO7/qq80WFwjTsjvHjsbos1CuVIrGV2s8avl8TmtrM1AdbJiLbWQ1XUoOt1m5bfPjJTNx5/vbF7vAJspNrFaB1iz8qEEpr6Iyu+IQeJwb7MHTOb2dNeB28z3DoFW289/vILGoXUK6BJZCLGAC7t0+mPMofuvSmauNNlAPCSnL3w1VpEVm6kFsf4oEfyAlLe1iQNW+MzBbNIsv39QkgNcP8MXCKj2MQK17EK4G0VERela4zLy
 56Pf3rkx
 bWgWPBI72mweRhyWXDvINIyrfDrgdoFDZkUcLJcp3qAQs4Lc7FAcdwQKtxXiiyAwLG+xAHYjiISumB443GRLXhEQ5ZNjVIPAM09kabADBfAfpC31RCZtTF8cNhSf5nUPuQNXZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 05:42:51PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Use IS_ENABLED() and standard if-else to make the code clearer.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> Changes in v2:
> - Insert newline after && as it's more than 80 columns.

nit: This is not where patch vX -> vY change log goes.

> ---

It should be below '---' line because it's not useful to add that
to git history.

Other than that, LGTM:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..5711d6d29a3f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3064,18 +3064,17 @@ static inline void note_cmpxchg_failure(const char *n,
>  
>  	pr_info("%s %s: cmpxchg redo ", n, s->name);
>  
> -#ifdef CONFIG_PREEMPTION
> -	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
> +	if (IS_ENABLED(CONFIG_PREEMPTION) &&
> +	    tid_to_cpu(tid) != tid_to_cpu(actual_tid)) {
>  		pr_warn("due to cpu change %d -> %d\n",
>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));
> -	else
> -#endif
> -	if (tid_to_event(tid) != tid_to_event(actual_tid))
> +	} else if (tid_to_event(tid) != tid_to_event(actual_tid)) {
>  		pr_warn("due to cpu running other code. Event %ld->%ld\n",
>  			tid_to_event(tid), tid_to_event(actual_tid));
> -	else
> +	} else {
>  		pr_warn("for unknown reason: actual=%lx was=%lx target=%lx\n",
>  			actual_tid, tid, next_tid(tid));
> +	}
>  #endif
>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);
>  }
> -- 
> 2.43.0
> 
> 

-- 
Cheers,
Harry / Hyeonggon

