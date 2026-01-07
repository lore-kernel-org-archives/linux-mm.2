Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8362BCF6BF3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:28:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2586B00A1; Wed,  7 Jan 2026 02:28:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4326B00A3; Wed,  7 Jan 2026 02:28:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44D06B00A4; Wed,  7 Jan 2026 02:28:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07D26B00A1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:28:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5886F139322
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:48 +0000 (UTC)
X-FDA: 84304340736.29.CA6E547
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id ECAD3160003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:28:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bJUejl9Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fcn6et1y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770925; a=rsa-sha256;
	cv=pass;
	b=1QUhEx2nxKBRJGooBp15T6+bTvrOPS6ac9SD0obwJBp63D8cX43WIv2C/UVmx3Ap1BmQ+b
	y6i0nHs0HPH9siG7v9YvO84B4G4ddMxU6qtHeiU4TdS+dCR5YtlIKG2mcE15aKSvkaK44Q
	9gO/p9yrAr0UQeJwVhWOxfEgG3IceF8=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bJUejl9Q;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Fcn6et1y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6qcG0jLXBFxrp9e+/pCcAn/g8VFoJRQPcZ3cx9HSYM=;
	b=pR0BmlgM00RC7F7Z2XLQe6YM5b1Qev0OiEhtakxbsu7FFUGuMBqj6dQ7x+Ist9U4Fclogj
	MBMotQiAoRWaHK/pxeIigmoAHqOYI2CeXFtrR13HHZbBYB60Odpz8D6PTnAtrzd1zz6VBy
	+3dXOh9FunmHKQZi/5WsOhp9WGqIIUo=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6070HOVL770591;
	Wed, 7 Jan 2026 07:28:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=H6qcG0jLXBFxrp9e+/pCcAn/g8VFoJRQPcZ3cx9HSYM=; b=
	bJUejl9QEy1LaTX4OAbv4G3E0IGkwmWPnJkJfIN4TbU7E5VTOKG19jctk10Yc8M/
	cnSVAnEOAu/5bbbjuG2rm5LF1rN7Sjl167PT0j8DAtD5RJ1LD5BYI4VJRoSYH/il
	bJX0tJrH2u3H9mJqKDR7ZjD+4vXVbXFmnceFsC8Dp6iiQSe5OC6o+6eVLg5Ygn4m
	6YuEBLfq6DWO2sXX49tNqXpjChop2tJTuzqGF5xB8k/5cq99x5hh3Gi1EzLmG1Zo
	dPOOCFFLNJZDLbCnjnzXndNf+la3YPXj+PN5S6EqMkouVgou4pFVhDujrI60o8bK
	72/hZ19gXsH6ghNsCQSlMg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhc2fraq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:28:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6076txVI020387;
	Wed, 7 Jan 2026 07:20:30 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkhwjh-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMOBS0fvPbSvyNYqgQzeOfyu1cba2Sv210MHD/Dq4KanegrSL0HuZgI/uZyRe1ybIrHSNAOGaxPmjPa2CGHPsSKdGRLTlELEp/zkRR/+BkzszgoTotwUq3glrsk09phN7CT10Vu5jmUlsVbsVWn652qu/0GT2qNEPU5X5l1Ny0mwerQCdpC64WMYvt6PE3Ipty70dDFl1FzsT5wTKps8u6yjzPZpjRRX907OjDSqgSIKZthZs+t1WQRoSKPFQaS5w5Ph0DrKlULehl2Jrr0VDswyq6L+YSY0OsiH+DeOmxERVwm3BGXJbnwF8HNXU75dRvP27mlj81AJglyDek5sLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6qcG0jLXBFxrp9e+/pCcAn/g8VFoJRQPcZ3cx9HSYM=;
 b=BckSVdtbQhkF0Xoww0NbvF/f1diL0BhAnSYiZVwNF9AY5QKFvw9pbm06QCIExAjMCsrvHGyJVRc8D4my+np7cGBwOK+58juzwhLmAcq0s+0Ntou9DruitZFH3hKjLmuDygi4p7GGIoDishWjE16nBe0i/9PD/x963nNN65QgO9anyj+5rtPm7eNRniFHRzhA0Py3/cuHhROaeZROsymbSeJZoZDEuLbTzUQmIEGb6UO4AFIwZCX3wyIpawTb+j+ASeRx/cjY83ml5tqmMiT5AZOa5NRW8vSqNJBN0cflflv6kPkeSrM0Yi3TkbLfikt4h4dMbGbtF2/VXwQl5USXRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H6qcG0jLXBFxrp9e+/pCcAn/g8VFoJRQPcZ3cx9HSYM=;
 b=Fcn6et1yzgsQWfeCBA2zBJ1oaWM0Kxi3CYlJt3P2OgSyAlTZDmjQ6dFQ+ApRCzy2bLewKJZFFr1LXnGw6B5WbSz4205zy+gLpCvhmKiOjVTsiJYO/cVUf7kWQIieANYBjKjlvsS5znpBotr28tSiB/rnHbEs3X2r9gzr0r6Wn10=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:27 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 6/8] mm: folio_zero_user: clear pages sequentially
Date: Tue,  6 Jan 2026 23:20:07 -0800
Message-Id: <20260107072009.1615991-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0045.namprd04.prod.outlook.com
 (2603:10b6:303:6a::20) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: 58eed92b-36a0-4589-9787-08de4dbd3b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ANSq3eGebHLk63Qr5A7Zb/Nn1fk2OJUIYh8g1Y1jyz7e3+2FJpTC/JS/Tyw1?=
 =?us-ascii?Q?XW7kK0smfmYgraiegEWsZQIuUP6EYkuPGJ6nfEtO2Acnu+oEPMEZ2vzFI78b?=
 =?us-ascii?Q?cPkD1F63EyJziA4K4KSH605O4if1t2hBv54G9hKIZZLiWv7kxDF6S2pYbjrw?=
 =?us-ascii?Q?l0asNtlEHGu0yR5z+hW7ieDFPvm4x+4EMsRypJhizhejMaG9A4DyUB9epPtO?=
 =?us-ascii?Q?dwxlZ+9Ks5czUtuqeQjQRIHYAtEdTGiYsz+3vhxQJVoY01PxI1CkB6GUTT2E?=
 =?us-ascii?Q?D6rCfK5Gs0eS4SvC08nTHx/DQ3dCMUwb8UucGXM2rZJkxX4x6EXkiOLvBFM6?=
 =?us-ascii?Q?zm8zhbTfmUEExsN5Vbh3/w3MmUYQed/gBBgCB5D26eYkfDQZOcRYCDDwPohI?=
 =?us-ascii?Q?J1d+4YZIPIdc6nb3yJQI0b6FNbWLce/UuSJDYPS9vE6dcig40gnExxum67pE?=
 =?us-ascii?Q?zDFN85IeXUBWVVYJLaC2szy3bMvX/+592TIUNd1VgJmOSwhUZbLFm95j8ldi?=
 =?us-ascii?Q?uiZewz1CYeb81pu/Bbnmsv4E7Pevh20lbr63Vbq2FZxU303dNLuUGSXHcO3/?=
 =?us-ascii?Q?ZZlX+5Xy4deq7Nhfm0aHLFcv1Gmyme3/vlIamtbehcuDxT7CpycOwEuFnAgt?=
 =?us-ascii?Q?JU4Grs0gYEw09torDsIhV2COllm6prVo+zaCelfUXfvl04v9YoUaEKJ2s4qL?=
 =?us-ascii?Q?tfxXcu5y0OKUQcxxlcATYTtBBbjWVV+7A01C8KRYIl1081jdYzNKXCfwQYq0?=
 =?us-ascii?Q?WSALKl0PZm0frmTCwDPQKIz1UAG6yRfezr+EcQbZYZIHK3U6JxjcWv7cee9g?=
 =?us-ascii?Q?+bwsePNvg3ZxJw548uhpyWkcd3YQTYH+od4Nj2GX6GcjmkRgGmqAThheo4Zy?=
 =?us-ascii?Q?VCjglQory3Y1P5BHLhKHDdJTR9JE1CQ2HJcbb1WFeEdOSzG8H/6HFDfcmhZ1?=
 =?us-ascii?Q?e4TFFxkzv2XZuHqPTuHbZx3tMVoVSoKCDSlEkmaR7AkS7yE8D3dQRJnrfMXS?=
 =?us-ascii?Q?xba8tVtBQH5K+ylKyOomXBuVz7IUgi6NJkTd1noQicJsG4uAkQqfSug9Q4Zm?=
 =?us-ascii?Q?jtIVlv99JBw+8uvimMp82T9MxSUUonI2mjgTyscpCFXhBdj6LPJWQ1Ijjms8?=
 =?us-ascii?Q?L4DqkMA5XLF7LtQINwSuC9g6KQOxpbk0AbMa+zp9aBzBFSawI39kDoaT5Ezc?=
 =?us-ascii?Q?DflcUx+cYmFDlXlcMGMKggKQ7Eb8k+mNL9UBYDH112femD/tRoRiQp/UX4bk?=
 =?us-ascii?Q?lsh9aFz/5+5gP3tO21HG8sMyuKfx482pi/jfs4RhSu0o+UqxoSegwMYfZs7Z?=
 =?us-ascii?Q?iberrukeF7Z/xG05vrGctGUGNo4oZ5wCG/dZUU08SJz3dvfJnHwNiBT06hcf?=
 =?us-ascii?Q?riFLM90QaVuwHgtaM0Bf7VTwL1IMq2sMRb3KtvHlYr0I1Ps3Y3uAyu5IOFfz?=
 =?us-ascii?Q?yeLh+P8ZTYKktGTX4IM4KT63MU2LQv8a?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PB8Er832zwMNI46aL2Y3tVJLz2RUd2oUAMOzymrKpPBIcupmBZAN91dKIa0z?=
 =?us-ascii?Q?Eqp8N9I2N3nNqPE4ZBVU2IY4EbDv0q4D1DzAbugRI5HI/ECO0yuyWLysVqwh?=
 =?us-ascii?Q?xCkNT9dFdaVxzQZBdeX1pw62ven30Ymyp+xQkHqlOFRGdLtm9Kq9DE1HdINm?=
 =?us-ascii?Q?PlNZhmLys0CRLUt3IVl7uQZC3fF15alLbFPhdPBsk25wQmAv6UGSty64BYAR?=
 =?us-ascii?Q?poacNTSAJJYLBDKa9TG0Wf4JkBaaX+ItCQ00qbru6TG+NcWHeYWRZXHS17Sj?=
 =?us-ascii?Q?eIRdJlh3er9F7jDethwlsHEmoM3zHJd6FDKTLvVD5yYM2PdbIRdx9RhDt/Fw?=
 =?us-ascii?Q?qRtb4AHooQtr/l0yu2vzy8QSoAqCcETbt81dzhoYTK7lIEjBHNChu8Hl8OE6?=
 =?us-ascii?Q?+mVVwdz+BdTQIU6XhuEluYUTXitgzAuJP5EoUEruE9vbbynUyUz0ODM8SLNX?=
 =?us-ascii?Q?FnWx2PWvvXSWoszavO0tGACPnItRVu4k1U/0RyaOGEOb5+DWfsDZulFi3ltX?=
 =?us-ascii?Q?nwreaa3FWWu3GJ2U8Jsq66WIgfgotFj/lbwgd8q7nMQ3nakgLBc4K4AcQ+VL?=
 =?us-ascii?Q?OHJcQkjDgQgy/Xko7jC1oykVOlwW1s8DBSo7WyB66Y1Lh56JWGM9MS6vnQS0?=
 =?us-ascii?Q?6hBullTqUdb/n0Cl76szOt+J5xyoGiOrwt/B1YN8dWhDbpP4wtvuOalgvjUy?=
 =?us-ascii?Q?dSnc7tP8aQmgYhkJbzcZfHe1BuOTJ8qgzyBy79NObJGRzqkXxBpoVQkgVvUS?=
 =?us-ascii?Q?WoZ366VXOr9bZUMB9773mf/Wd5IH5slRfHIyyoaBNMQQpH89FEDSdIntORYO?=
 =?us-ascii?Q?S6fCa5NryOQQMZdal7wCVJWGiW+ZSjRAcrwmqZWSJrAHY2bbjAx1CEytkOzr?=
 =?us-ascii?Q?TpGOl2/kcpdc8uOz9W44FotWafIlz31D1aBoY5NkyYZA5AKRmh6Ydi4yOd7L?=
 =?us-ascii?Q?/ih81mYrzhAl64KxKbtX+e6AoEIXKq/d7x0GvopM6u0QHPz3Ms/qLdrwcSb0?=
 =?us-ascii?Q?j3hImAVtQ78981y2yvsPrPMLBYMzrKToFQ8ghtgDXKh5Y6sQt8vPhigme0/T?=
 =?us-ascii?Q?CLFfw5D4/18Mse4AUamyp7l7BYMlB2GcLPCSOJuyzb8mlf0/K+eaRV1dN53u?=
 =?us-ascii?Q?TYzumRd0XuzVPn9yZkXDhxWbCyb+vV88wlL559jkFeZVc17TxgEtC8IfRPES?=
 =?us-ascii?Q?wGNbSJwgtMig9SaT9abl/iAVaDwRbs7PhniwepSOePk3XRxjYPoo2TW+MFof?=
 =?us-ascii?Q?D/r2E+ETl9O5A9bRm8gtwPJDPQTy5rq6mH2k6IbCBoMBsX5Fzvu+zxo6THkf?=
 =?us-ascii?Q?eADMgDBJU0naw9vhlBGhCUZDoey70QJGteYPRF5iVz9apS0XHq5VPox2aooi?=
 =?us-ascii?Q?m4JG+LrHtD+AjU55SzJH5IGpc2k8VC/U4QmTBdNfqMOfWloAj4eIUB5chw4n?=
 =?us-ascii?Q?QDd0FLthldkzDCOVslRrsSyjGAYr+rcgfS+VqTwwfi51dxtfcXh4ZbEuYrt4?=
 =?us-ascii?Q?VlDSPAmxeuPAZDvhR9KWAKLWmMDp2nXHuDO8vtUZN7yIqke4bIg4FEzjuCiV?=
 =?us-ascii?Q?IMhMPqYLg7hT1XItoC0eXJyfBIwQMHGWFIq0bixdGAjIjIA1jFZqIbPmEJRW?=
 =?us-ascii?Q?Nmh2RDu3J1gnI5qZMo+5s3YtZDSXdCeKfsTiYjMZyIDphpA61Eg4DA0cmmh1?=
 =?us-ascii?Q?IzhXd3tUUFnSjWsEnEVoU70qAceaYAZb+hSBar1kGz0fCbes2IcrQ9vL4jaB?=
 =?us-ascii?Q?t3/hXGPPzLXiSjJUmq7IVxmfPwS7Z9o=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jjn6P8DvTfU/xqPGER8wW4JjBvr3GT0ZfwKEmdWui7HSTnSZX7Oc4PGszGLgJ8Xl9pvlO6iDwV4+O10ky4TFwnNwqNZfe44AcNorNcRq65WXq8E7LqlND09dPzzuwX9TDYRXdzXTD1pIQpsoGbQPTWnUuIB8qhMOTh1MNaskj2MgUqzFomAtNyA6KK2pMxZPa/e3f3Cd/smHuLqVGqI1pkspilIm5atEI0oRBRx3i6ynj+giN1zg+OHSjrPSfrnbXX+cEgCzO2OogzmbL57kvf0Q+jJ/TZnE/L83T/Yd4H995WsXVzxM4cLkND2KrjE6GCDiiQyUXhfYh5Vy7CKF2Yq+M6G0K6uE8Mo6FXxH5SOWAvqmgUdH3fvJugFVGZbScXXyGY6Puoy+6gqPMoKoCTJy45IbjgSv8FJAZAoaANQ3eUYwOaorfdNaEGiUD1cQ+c2qXVam1KzJrrhOXABEXBBx4LGSXAVxZa9qhghfHhM6Ttc2GaBz1iJ1sHn2FHVmww2pjnXTYLqfKW7jAn3rl+JWK2qqzGHfooF3qMzEfV/Z94hlnsEV48g4R1Sc+PKGM9I17OKnYgrIYSecf+d/Rlw1cGyq6DlhOB0/72gLqpE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58eed92b-36a0-4589-9787-08de4dbd3b54
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:27.3957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79rnX6WDrfaZuQg7XybubVC5RWOxdZsTp/87REvmM1+IL7pdKbev1T5yk6OQrzPTKb4TglXUPWScGmJaa809h0JLoEV9wvk+TflJK7S45mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070058
X-Proofpoint-GUID: WlCXku5ou1FREs9VMHg_oJkbHj_UeLwD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1OSBTYWx0ZWRfXyQm1xzTjMaab
 VIMpauXDxYj64V2pZQ/S6xydn1RjOtnHZFGQRnuIVUcfKU/88m2g3tYOPlurkRMzcP5HS3koCIn
 mwScvIeVAhfhq2Vy56TVhVzjCpSn6d44sTpVNg4MJDkADywkoiJfOEJD6U0TRJf6RUwiGOPIK1y
 uHl1XMP3KuSvs4stahawnLUs646UUfkaF6KNBDKPspAPWQQqASkkDsI/GVoXWPZAxhy1ccz5Dh2
 6qJjys74wJblFI+Z99x1nZmOlaZLqmaz7aZSnIyOkbvV1meZ36rrS19I8xgLhDvN0253adSs8dc
 2zxrJM4la8OVpQGfwuLyWwMAjQY+zDrPBKipBhho7OeSmAjzIW8yOT7nbNvTM2wK4jWhRURr143
 e5/mjgH1p/tS1lrjfTE7uxHdDTxcGaFKirMUfs04EACb/zTxo0FVQU2lXlTuEuzdhFEYC1iBPc5
 PggA4IRdbEF2JdX2/htnnq2eH4oI8a6PeIk2nKNk=
X-Authority-Analysis: v=2.4 cv=KtVAGGWN c=1 sm=1 tr=0 ts=695e0b14 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=QIWs6u34hG4Mh4SAT7kA:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: WlCXku5ou1FREs9VMHg_oJkbHj_UeLwD
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECAD3160003
X-Stat-Signature: hdajas8twe1cd95484bgfanpiux6pptn
X-Rspam-User: 
X-HE-Tag: 1767770924-886433
X-HE-Meta: U2FsdGVkX19eVqTFoz1xe67YazEcZyvVxaL0E2T+owcJlQUdhdk47gSVv7kjupsZAqXM4vijo8vHSOmJ2EreA095HebhXJf2ufBKtf45AZezSHzXNOyhLGXU6dIISugHFRirSHjR0EJyU9uml+ElvnE51Sj3GROJoDN3qOuD1M1ou+r3qYdg6tVqXIhFg0gOqYV6rnoAbvQ000fK6fjrS/3nX9IR8awngPdMPi6kFO3PIL0KujFZHX4R5jUucuj63buqEDxRizFTB64gKCR8+KrBCjZs7rK6fgjF2p0dbl21kxQ2LFEUczb0WGrNngcoKFpounY/SvDjqWwjbdjbk44+/ZkqDqBQU3WiFgxhI1YVSizcEggQegv/Xyw0RoDHxJxb5p5AijC+gp24um3/hEvRy+xmfRa+sv6rVRBwOgVQQQMe8Zscr9CmSUpgK6fmUEccBS0h7YqrelrbtEU2iXEecc+T2nFiEcIZ5niX9CL65GxoGM/MgbiSM/PJQTAjmH3H+ixPD7nzsnU6TZV+cSDgig2QW38UuA61SPvMkSFFFwBO12vFVA9mSHMNp40rIAC/wYrEfvQ/IUiN8xChwpBtVFH9r3CJauejTwun8NDZbL83rBg0wo+FQ5O8620X2JUqMykfSJeIbAoMDYVyWEVgZjzjsNz9i7dUPGkKaUUMgllxI1yxHve8P+FwyeOILuqupcl+cgNkwBBHvcEsB6CW76tc2HueW9BldFY24lok1cfVKVRcQJ3wQi5RFnUZJplP4iIfFXBLTN6XsQui8ZQ2GwrxOcWj9PaN+wxf3zmUNTTqzQelyBiDyaOnWuVF9UxwXEIVLX+pMY8UNSjqGFwph90aZ+AEezLXf9xyOWf5KqSMu7lT2PrtxpWqvSUfKL0+lZbv0m3aioO7KUSo7VjiCWhnvFT/7QBhI7kZakVtq79Jk6Q379gDngWK8tKwGI8k8J6aBau9uLbtiUb
 FMmzOpm8
 YHRj7aXlaU4E9NQeirBcqrScBHlkSB2koaKBFbkzV47ujB3EjGmIlaSGGbSWNgc4+QIrfQIdvI8WkLrIs00m4AGnMQGQ4IgUKZa/8HDiTIN6hHtAq1m+nKuNeVLm9MpyO1m9Kd3AixjRJF+EFP/VirJtK6M/YbetI9vpro3bOn2EXk3UGeMREzoy3WdCSB/zR0jgNJT/NXM0Rp34bASbC4f3BQL1G+xUkqQAho5B1oMMynbOOJCYkQcadth+3z4/Y0ivF6xG2X21caQGYCay85Yef76btTleMH2MFh6dwgZTdE3v3+BaWxTDUYpSSLxjX1bn3vD1djM0R8k5E/aInFgeP0hrqd5NMlVRXEUcyPLtocidtbm6hIhXEYwTVcXL/6Xr4soEF5tMYsoI4B1GhKn/tGJHTFMqHE4fWDUhEe2SkNCGWt9WtsH8fSb8AtJn0mWr+ne2JdVK3JMpaDmq9aBzicFMWlI5gP4o/Wk+l395ad1L7r4tHl6YajEnpQ0R0Kq3JhvbQBj4Y0T8jq1EMsu53ZZa1bxf+6RiKC9h5qMYycWNwl9xSlGurhEMNOB+3bX5wDuzb7H7uRf0lu4F+vRgLK1VcLxhT4vWK+JOfsKJJaqZeoNF7/nFDa/AHhE0G1ikPMA8a1q2jJ+zlXpwKy/298ey+1rLzjR3KL2JrQUQgvxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

process_huge_pages(), used to clear hugepages, is optimized for cache
locality. In particular it processes a hugepage in 4KB page units and
in a difficult to predict order: clearing pages in the periphery in a
backwards or forwards direction, then converging inwards to the
faulting page (or page specified via base_addr.)

This helps maximize temporal locality at time of access. However, while
it keeps stores inside a 4KB page sequential, pages are ordered
semi-randomly in a way that is not easy for the processor to predict.

This limits the clearing bandwidth to what's available in a 4KB page.

Consider the baseline bandwidth:

  $ perf bench mem mmap -p 2MB -f populate -s 64GB -l 3
  # Running 'mem/mmap' benchmark:
  # function 'populate' (Eagerly populated mmap())
  # Copying 64GB bytes ...

      11.791097 GB/sec

  (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
   region-size=64GB, local node; 2.56 GHz, boost=0.)

11.79 GBps amounts to around 323ns/4KB. With memory access latency
of ~100ns, that doesn't leave much time to help from, say, hardware
prefetchers.

(Note that since this is a purely write workload, it's reasonable
 to assume that the processor does not need to prefetch any cachelines.

 However, for a processor to skip the prefetch, it would need to look
 at the access pattern, and see that full cachelines were being written.
 This might be easily visible if clear_page() was using, say x86 string
 instructions; less so if it were using a store loop. In any case, the
 existence of these kind predictors or appropriately helpful threshold
 values is implementation specific.

 Additionally, even when the processor can skip the prefetch, coherence
 protocols will still need to establish exclusive ownership
 necessitating communication with remote caches.)

With that, the change is quite straight-forward. Instead of clearing
pages discontiguously, clear contiguously: switch to a loop around
clear_user_highpage().

Performance
==

Testing a demand fault workload shows a decent improvement in bandwidth
with pg-sz=2MB. Performance of pg-sz=1GB does not change because it
has always used straight clearing.

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                 discontiguous-pages    contiguous-pages
		      (baseline)

                   (GBps +- %stdev)      (GBps +- %stdev)

   pg-sz=2MB       11.76 +- 1.10%        23.58 +- 1.95%       +100.51%
   pg-sz=1GB       24.85 +- 2.41%        25.40 +- 1.33%          -

Analysis (pg-sz=2MB)
==

At L1 data cache level, nothing changes. The processor continues to
access the same number of cachelines, allocating and missing them
as it writes to them.

 discontiguous-pages    7,394,341,051      L1-dcache-loads                  #  445.172 M/sec                       ( +-  0.04% )  (35.73%)
                        3,292,247,227      L1-dcache-load-misses            #   44.52% of all L1-dcache accesses   ( +-  0.01% )  (35.73%)

    contiguous-pages    7,205,105,282      L1-dcache-loads                  #  861.895 M/sec                       ( +-  0.02% )  (35.75%)
                        3,241,584,535      L1-dcache-load-misses            #   44.99% of all L1-dcache accesses   ( +-  0.00% )  (35.74%)

The L2 prefetcher, however, is now able to prefetch ~22% more cachelines
(L2 prefetch miss rate also goes up significantly showing that we are
backend limited):

 discontiguous-pages    2,835,860,245      l2_pf_hit_l2.all                 #  170.242 M/sec                       ( +-  0.12% )  (15.65%)
    contiguous-pages    3,472,055,269      l2_pf_hit_l2.all                 #  411.319 M/sec                       ( +-  0.62% )  (15.67%)

That sill leaves a large gap between the ~22% improvement in prefetch
and the ~100% improvement in bandwidth but better prefetching seems to
streamline the traffic well enough that most of the data starts comes
from the L2 leading to substantially fewer cache-misses at the LLC:

 discontiguous-pages    8,493,499,137      cache-references                 #  511.416 M/sec                       ( +-  0.15% )  (50.01%)
                          930,501,344      cache-misses                     #   10.96% of all cache refs           ( +-  0.52% )  (50.01%)

    contiguous-pages    9,421,926,416      cache-references                 #    1.120 G/sec                       ( +-  0.09% )  (50.02%)
                           68,787,247      cache-misses                     #    0.73% of all cache refs           ( +-  0.15% )  (50.03%)

In addition, there are a few minor frontend optimizations: clear_pages()
on x86 is now fully inlined, so we don't have a CALL/RET pair (which
isn't free when using RETHUNK speculative execution mitigation as we
do on my test system.) The loop in clear_contig_highpages() is also
easier to predict (especially when handling faults) as compared to
that in process_huge_pages().

  discontiguous-pages       980,014,411      branches                         #   59.005 M/sec                       (31.26%)
  discontiguous-pages       180,897,177      branch-misses                    #   18.46% of all branches             (31.26%)

     contiguous-pages       515,630,550      branches                         #   62.654 M/sec                       (31.27%)
     contiguous-pages        78,039,496      branch-misses                    #   15.13% of all branches             (31.28%)

Note that although clearing contiguously is easier to optimize for the
processor, it does not, sadly, mean that the processor will necessarily
take advantage of it. For instance this change does not result in any
improvement in my tests on Intel Icelakex (Oracle X9), or on ARM64
Neoverse-N1 (Ampere Altra).

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---

Interestingly enough, with this change we are pretty much back to commit
79ac6ba40eb8 ("[PATCH] hugepage: Small fixes to hugepage clear/copy path")
from circa 2006!

Raghu, I've retained your R-by and tested by on this patch (and
the next) since both of these commits just break up the original patch.
Please let me know if that's not okay.

 mm/memory.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..c06e43a8861a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7237,40 +7237,30 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
-				unsigned int nr_pages)
+static void clear_contig_highpages(struct page *page, unsigned long addr,
+				   unsigned int nr_pages)
 {
-	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
-	int i;
+	unsigned int i;
 
 	might_sleep();
 	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
-		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
+
+		clear_user_highpage(page + i, addr + i * PAGE_SIZE);
 	}
 }
 
-static int clear_subpage(unsigned long addr, int idx, void *arg)
-{
-	struct folio *folio = arg;
-
-	clear_user_highpage(folio_page(folio, idx), addr);
-	return 0;
-}
-
 /**
  * folio_zero_user - Zero a folio which will be mapped to userspace.
  * @folio: The folio to zero.
- * @addr_hint: The address will be accessed or the base address if uncelar.
+ * @addr_hint: The address accessed by the user or the base address.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
-	unsigned int nr_pages = folio_nr_pages(folio);
+	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 
-	if (unlikely(nr_pages > MAX_ORDER_NR_PAGES))
-		clear_gigantic_page(folio, addr_hint, nr_pages);
-	else
-		process_huge_page(addr_hint, nr_pages, clear_subpage, folio);
+	clear_contig_highpages(folio_page(folio, 0),
+				base_addr, folio_nr_pages(folio));
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


