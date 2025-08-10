Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12724C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 14:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388768E0005; Sun, 10 Aug 2025 10:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312058E0001; Sun, 10 Aug 2025 10:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BAB8E0005; Sun, 10 Aug 2025 10:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8518E0001
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 10:04:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84CF01A053F
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:04:28 +0000 (UTC)
X-FDA: 83761017816.17.4429D1F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1BFF120018
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:04:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SVNCSkYP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UsLpcE9P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754834665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGdytm5Pi918J9R0TvODYZrlNMLaZ4TIOvcBzIgLmlI=;
	b=SIB9nvwt4mvGmBSgVQihRMU+QxFUOlEnL96OcFaSW8EP5oqGBCVt65OtASvtzQURwhON8x
	vPb7gm7PLtG7JyPru/UjCQFzBbU69gab7aIHGPlBryElsmQRp7BNM1yl+sgwOiKLRKsq44
	QQoImoSaAWrlXxtwhY2Snwq0rF2tLtE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754834665; a=rsa-sha256;
	cv=pass;
	b=3NFup2KIeJKWU/MHHJ/YuL5UwUUOslCy+aU7s1V0rsaKR1XpU51nDvsgHuAm2BbgqFd4TO
	hx9cJPlqZEooq1HH2OQBh0ApioEa7uTQTzs4+hkNz8kNALn2yKml92QUTbGqK5dHbeiyCm
	HNg5dxdXam2z2XQeoD/WsqJLt6Dgl5w=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SVNCSkYP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UsLpcE9P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57ADkCab012172;
	Sun, 10 Aug 2025 14:04:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kGdytm5Pi918J9R0Tv
	ODYZrlNMLaZ4TIOvcBzIgLmlI=; b=SVNCSkYPRb6KgpzzSdAqYo3ZW1MC2KvYAy
	LumuHFlXzLDkV/44yaedh7ct1ztSuaU0C2LbyrCHNOsEqcAiIxzLGgVeGMOBwToL
	87GSO1CvfzLkrUJfBJP0NCd/2tHpYc1GoBMZEnod/McvvnN/L6s7mwpfcU3QW1QO
	JxIuN1kE6nnGfJV5IIt0xLws7k7x6wNoVo5i7fbMheOMF2EhpnKGRU27eAFzCv7x
	GYVDI5jB1Tz9lmRIvwEhMQxN4n1Lbf1GuPSDsI0Yy2jKEel1kaxRHqsB7hEmOxNO
	hID26B7EMAnsHmFC2y4ECbIH6nh4dRR4J53lyqWat1KAS84ns7pg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx497ss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 14:04:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57ABV8VO029911;
	Sun, 10 Aug 2025 14:04:18 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs7rj4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 14:04:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afdT45qj6u0/+VdPdwQm1eJWFXMfnTcNaAWSj9VKDxnPllazc56WYYwIsPHGFUnDGXFB9sUDDNV7bIDlSvXLab+vIvMacLYAYlYltwOKzPTXPF5MmvIwlRPzpYaobKmjRoYwQ2ZML3AnwD3NxwNOKFrUkmOaCWm3PtJ6n99R2DPvI8qvSjp4adKBt/pXqmVfqJzd8gUVlp+rgMpnsM7/5vgKhQxz58vcdOLAZIsmtcgrE5f/vXjvsgoy6QuNqwn3KdMz0VH7bVQ+/1ekC45ySKMsWFvRuIYjD7dK+DW8+/4ujb392/09lmRIPbFmHcoRCdwtXFj2p9fvIU/oOS308A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGdytm5Pi918J9R0TvODYZrlNMLaZ4TIOvcBzIgLmlI=;
 b=pw9hCT+kto1slyaf0FJCSNi5VUYtvo1Hdyn84RNpnxERDiA9tEVxXR2L5xZ7dxqAeCKPKaKa+qMQLzfxs1CUvluZ0QXPuP14L4BMycplH+67W3BmHxd1lW3UeIArgf/hfkBZ9Hbj69mNs6cAXf54HWeQ9z5H1IeziL07sNds0bJzCmoV1hgc8MNtbaKNEZEAw8HQ1ZuhQo+4QpdYWVnTc+Y1t4DYKrWUMBvSszTgKhUD+GTh+6ODQFSqtgrY+XLiSJ9358eQj9AkZrUkjhf5rkO49Qs0bZlIzYojYzpAoqziwmxQoz4JCU9ddYe0etpaNXqbpamKrwuEArLyhygtFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGdytm5Pi918J9R0TvODYZrlNMLaZ4TIOvcBzIgLmlI=;
 b=UsLpcE9PzJoaU7Oc1OOozNcZZXUNUL6EnLB65xpOjFJxMLHWrLaqVsWMO4+m2Urewe++kEuXXKdYwNA82P68rEthE1Ujo/Yeh7Yjc4nS2/hE4wBLQnebfYGlciBNZMa8qzJ4fsmDzNt+StB+11EREJOahu9Lra9xte0cNosK3bU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4666.namprd10.prod.outlook.com (2603:10b6:806:112::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Sun, 10 Aug
 2025 14:04:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Sun, 10 Aug 2025
 14:04:15 +0000
Date: Sun, 10 Aug 2025 15:04:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: akpm@linux-foundation.org
Cc: Wei Yang <richard.weiyang@gmail.com>, Zi Yan <ziy@nvidia.com>,
        david@redhat.com, dev.jain@arm.com, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-ID: <a1c64bca-9ed1-4d77-a838-4e74a35a1131@lucifer.local>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
 <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
 <207BD61A-5561-4E8C-B867-D1CFCAD37509@nvidia.com>
 <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
X-ClientProxiedBy: LO2P265CA0420.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4666:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ad9ca51-c503-4093-7441-08ddd816ca6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5CKNanhpl287Mrfde4Y2yVyDBcC6udbV73Nyf4U7BmvF/yhq+5rRKIiTIwaI?=
 =?us-ascii?Q?CjTI0tOirMMqDIxvqHnLgo6ZXOvO6vi6LFs7Tl6sAMZ0xXnXg9HbSEqCcrho?=
 =?us-ascii?Q?byJIKOhckk/ewlJwfNETXbeZvypi+pf/7KFcCxXpI72PQgpMQrJB9vJJOKPn?=
 =?us-ascii?Q?I7HvE6iLnHigGN/CNUEM58GMg7cOHYvCDCXg/a31rcXP0IIpFz2OXZOCi3mf?=
 =?us-ascii?Q?yjEDxkObiaGLfLAoxDf5l0YbXWh5uSbcXA+ygpYUJeksOaqz+zJpi+XaeDX1?=
 =?us-ascii?Q?bfeyclwV0P0oMLV6caEqTeUtkmUt1YNMULBHscAineL41EcDyo+NIdwnqdUV?=
 =?us-ascii?Q?+ofJAk9NUGnsL/F3JIccI7KQqOboyVzSQ/RWJTpCPOS5Fw4BCt1yydKsf0uY?=
 =?us-ascii?Q?5tpZ+eoDf89hp8GBRqb94bY0aJtYIJqigTBMsSe5Fpbv39zkWuceUFZ6f4J3?=
 =?us-ascii?Q?11fU2n2I60qRtw5vpfd/CBAkhG2JQvqsH9Q2PruTkv6oe5nHWD8HnoxDm6CM?=
 =?us-ascii?Q?c7jfZeHHZ8iRIkEaTadr06OOzfh3F9hglC4YyjeWQAUzD5lteCaWl+apNFbV?=
 =?us-ascii?Q?DQI7zjFrvN7K8ie5M9l74aQQeywFOuWcX0fnZgvZsZZvuwyzaCwBQiMVhZ5Y?=
 =?us-ascii?Q?PFXhYToekJEB2MOJinDF6LzAKBS025WdUlliS/TRwHvXZAm1PRq/a5JWVqGq?=
 =?us-ascii?Q?5ra2dqVlKjgCqsI6+qGl50OyKJ4N90BFkwoZ44RXFnJPGec3NToShddUz6qg?=
 =?us-ascii?Q?0mfdcMmVsB5k810O19ldN0ygyCsEYSDJ8bt8SLZTL0sk65Sb62fXzj7uHkTp?=
 =?us-ascii?Q?qOwZVhY0sh0aKwgeEiFFhEDUwPzZZ4+mlrVtGGQSBxqZfXW4fszVj2xHSuJC?=
 =?us-ascii?Q?wHg775+ilr9qY2cl7btJ71wAyYPCOlolDhUFlFKOqHSF1aXlKybYnFcva9LR?=
 =?us-ascii?Q?EDQrIBgNbNr1jN+MN9piUh9cI07lDGt0ScvtLuHq+yslRIyhEHZsCU7HokM9?=
 =?us-ascii?Q?CjiSyonAGdovs3u+Dl/7FXhLj4Zk1Z+4KscyCeQ0GVcI3I0vJbhOzQtdIUB4?=
 =?us-ascii?Q?7rIGR3m6oRd8A0z5EOvL/Tw5RuFwm4r/4Bkq7EF4ZFWsvnf+JMDdFxT3FBxu?=
 =?us-ascii?Q?o9/dbzlssnW38ROWdbDrG5HRA4kwWueEj24/ieeWGdHRAFA/T7uqQca/EV3n?=
 =?us-ascii?Q?4Q0d+Uh6+3b0xqjSBV5oOUK18zQIyObT3Ri14OJIsbFpBKDyN3AqPvT/L2fh?=
 =?us-ascii?Q?Ed25oQVD5AFsdifhLDshZacq8afxQcNKEokEGsTbMKTkZBXN2pyFc5r/jcon?=
 =?us-ascii?Q?6iBuxIzrYIVqz6lIUmYarpvFbOWdfbcg2NIp2ilwQWJcwbRb9NtgS4Co5IRt?=
 =?us-ascii?Q?l+OKsWDbUcsAkghCuhX/UxvrfOw8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+zoFOqV1LuN+hL0/yWy0j400erY3DM2sJniEZ1Jy2KlfZmrhBOORsd8R7kG3?=
 =?us-ascii?Q?k/KaF/d2u9HcIapM911eoz1qrsnBRM/lY1IH+mR5YoAva4g/wrQKfLOD7VGN?=
 =?us-ascii?Q?Ty/5DZTRimVZD28C3Fm5IFN4I2vd9VAfAcCdKMNSnL+jsT7cUBp+NC6tf72X?=
 =?us-ascii?Q?f7U1i38e01uDt3dvYlbycYh/GhnsZo4Ecpr1PVwudTbjJq62CbL9CZaVFkDv?=
 =?us-ascii?Q?FpA2YHmzl6f03htMhZ65Bqufi9hoCxMt5NtiaVNo5D9WcY6kudIiRZpXgLHe?=
 =?us-ascii?Q?TueTsaB+PhJ5/qbLecYlFeqnbrB/GDX97CeobO6fLcq+B+EqgOvaToxsJIWS?=
 =?us-ascii?Q?bIy3BMwOW6HcLTLq9dDE/PDpPEXmYQTwiBI3SFKhsKtk+9wzYJ4SdOtkeXh8?=
 =?us-ascii?Q?9rWu0/1nbIua6tWi8Wbb8YHRObDIM8mvtDSVGNezT1PuA5/L65G1yaLsUz2g?=
 =?us-ascii?Q?JI01n/cyDMbBch+3DOdiem1gzG7bnkowj9JMCVmOgIsxgCjSkNU2+hn24D1a?=
 =?us-ascii?Q?45l3m3fgA24PwEXgYdF9zebtquyg92Ze7RGykpKW65/JFIUK/xWcBnsVWUiM?=
 =?us-ascii?Q?+GrFImM6aZTCcI+0Ou0c+Sq2AmziaN0ubFTxpCbMKrLiRPqr9wxDb9ZyRL+M?=
 =?us-ascii?Q?oNVpp0L74GvfHDW1VtZ4Hg6UnszZmPp7mqKVoNz+5uT5RuB62thb5LACQPXs?=
 =?us-ascii?Q?KTua2evs4nrQvKGL1d+iMpuiNx8EaXdHt486or6mR5p/fpyr8gw5gPLKBZvU?=
 =?us-ascii?Q?iL95xvL6w+7esgf9J59WKuU75ey1hvSCg+P6vXTQ11bU3Bqvo3yGq7rdHdET?=
 =?us-ascii?Q?UUMqt4gmugRYcQd9VnWk1G36JyiyGSNUNLG6b8TwkkGjj5sZQ/PNP4czrAb6?=
 =?us-ascii?Q?cWIsn+KUON6eOFoZtRJXl33PFBdhYNlizAPQYIdUzpdoX9PqjJf5Gvt1xezE?=
 =?us-ascii?Q?xItREgn0X71mbAfkCCPfT+eufDxCz66exQmF8tbPzAepFzoBndOpunPdksgo?=
 =?us-ascii?Q?VIJEseQJ4N1lbrQR2yWo9fUlS+OXYMiMLCTdbl6nMfkWOph0EJJXlcZcvU0L?=
 =?us-ascii?Q?dBpIJ81yTKVAOOb+RaUsBas925xauRHEobFSHhdbL0pBleRvzUglzybpJRo/?=
 =?us-ascii?Q?hUY43hVq7T/zxYvfqP6KvpGGC5KUPtDVnGAATMytRYQEmqdtLr6v+NTfLAZA?=
 =?us-ascii?Q?Co5oILXrTpQP5IuBF4psEX9Io3snCThDlCdsMxBVMi/uhF7DR8Io0jFcHY2c?=
 =?us-ascii?Q?0QSiC4Ii8uH+SiyQixctm6JAiIl2Vr4KQSAacg6y4WatWrSU892jB7RqIaVz?=
 =?us-ascii?Q?FXNaidimgvkbKB90Ws0jPk+G5IVXYugZSiujJHxz/m8Yw/yYBmFe2L/Cu6Px?=
 =?us-ascii?Q?rzLUBIWLztXLuz2FeD6K9SNfTN/6jQPEllO8y/tDlATisx2/m4PRYt5e8PqY?=
 =?us-ascii?Q?ZiqFVWZ3R5mmEFcV9Rk65O3GpA4LKA5o6fjRlhiR2k88YYK6eXcD76zFs+3K?=
 =?us-ascii?Q?tRSHso/k+lv0IbVk45dLVqInRTZUU728oGzlGOOgsCSMS60l0q6JOOiHnX/b?=
 =?us-ascii?Q?CxSfAkN3CLq+xXSwCoUAzMFaOOlAiV6JdrxbUZGnvVwncMv95m/WIm7zkl/j?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2QPEIosUmJhRTa/hdhVd+zY/CmdZcwyeFbS87OCOVbDHiEPZW3Dkli+sp3Y2EAKEJZMM3xTIFg62OQ58ndBxVFBuBD9800J2ebJOhF3xPnCYdy3mroPLCI/tXXb4bdzEAKf/dB8wc8+IjUgJnCHFAav5vCxyJ0kmruWQE8PXKb7yOEEugnkLk6mgA1N3X+RDIaDAs6UDfhsEaI8R4QrvsqOM6fLfsStpjm3K2zmHb/E06TKaNk841hw3Va8Ox6qtDEWSNNekd+pd6Ws0c+QWd1umRWMQU6wwY2L8GrcX8Ip6QIwx/ufVAoqv09OHi+V+BM5xLfs8+PBt9BtAMfl8hPfx04diO6Ph2vKBQAmmPdT8pkj9SGZHbA0R9O52FwwzS/zGuOa5VoFb++GfWhZO/qdzZdoi+1wBqYr+MfbY7LtywSrUUoN6VLJofOzf7rq5V8UcJ4TzfO1c/TebV7DjZLC4zA+JeNS4t4S3PCtDjGuqfiiUfX37qdL2OwnFKZEF7H/EvE8K7vb3PACzSpliQg6mez7oc9TVWWVU6ax+kJWycbuNenr74GmTadg+dVM4hCOLVpNlB8ia3/s59a5CbGlYGnZNeBA/HHQK55N07Y4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad9ca51-c503-4093-7441-08ddd816ca6f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2025 14:04:15.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H53+FivxAxHbD4c+3R4lJV+zW1jMEG1jI8X73OTQA7WEkuD+wPsj9g0g5quwz4UefPIPdXK7bk2OwDf1nlUcxWIi3LZCL63T9+vzL4cPzDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4666
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508100102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDEwMSBTYWx0ZWRfX0Bo6Q3qwAc2S
 L78dsrxWrUxuTydtkdB0+TYzqutzv8pJgxPorVLdMWmSpr9NfxJaLYIdwd/W5+5+EC9VGZDxbPg
 u95vL1byoGaAvXYUuN0fidOzXUCN7w5UJotTiYEyf2TrHNwSNr8hlJZCt/mQ+T5++hzx8NONWWf
 BWzoRjVcbSPeEcMpeGpl4trQ5lzHF+kPTj+RLkSYZMkU5CnPwqkVRMvai6H7SiWzDJgHGGq05xA
 xMLmoVMLc0tp1ySbH3Dg5g/ff6fyTcdUmhvB2hwMWEM67u+lNpdCgzaOln7iOOxTwTM9vo1Tb1e
 8Snu3/T7swtC8GIH4ia+E+mi0BGAZ7IOYimgsOkvXoQro9SZyvKd/3odMaf0/CXx7QcXCudyX4G
 PKfOEOe1MA97PZXF9KxgpLkw+PWQeqHDykyuS11/qpP33nGCZppv5124qbTmHsDCLBGOSbqG
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=6898a6e3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QX4gbG5DAAAA:8
 a=pGLkceISAAAA:8 a=Wd0tvRF9Mloi_Z3WlgIA:9 a=CjuIK1q_8ugA:10
 a=AbAUZ8qAyYyZVLSsDulk:22
X-Proofpoint-GUID: 1-ksls2lcFLQr5kscYEGNLaCbBl10gLV
X-Proofpoint-ORIG-GUID: 1-ksls2lcFLQr5kscYEGNLaCbBl10gLV
X-Rspamd-Queue-Id: D1BFF120018
X-Stat-Signature: rfqyd5biangs79484f131w7mt1bq4atd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754834664-713171
X-HE-Meta: U2FsdGVkX18Nrm8uiX6fe8bwK+DZmWuBc6UDkg8DjxoNFY9Tom/Hu5TBxM/3S3C+SjYM/j85wY9TAftqU9/gsb2k/pumgeQYD++WNUxefmEQZvJ02j9Ny9RYbFE0/QoRfsE9wsT1t1tbQEI6g+8sAlmDT7V5GL8UIXizF8Zm3+8eHf3mGhRNCwoRxhmS6ny/0FLs+LMUFY34oamh5PP+8oJCIuDa5tWgo9f6k2iLDZzJL7OC9lEU3ESSnX6WDY6OX1TjdrbVb0XkXB63eGRI8TyoO65AmxkV3s0C7MKiLZk14M7kUBllLOMThG6BEyXbLREvNfaIB4M6/LTLMvitwGvXOLhBo/vyi4sGGNNCl2M3jwnS/md2o7hegkkMeV7wZ/JYo13+SMcGJK5vyCmx6o2+0o00jyzqnsLUib4+lDBwwxxQetIhdfD0RB1qVfaXp/WDLY4yh/Q5zAmiMEGQ5pXPGst/l6dafEIMORpTzoZS3qAyHza3n6CjKh2IcgVkI89yZLNcKEkeMY+DzOeo+umEOP28jLQ9+W1GeNEOomuvYimWft8nIMrwmh2QeAo+jJQcRjnPYd5qzND/B8m1dmRd7ZIp0vR4hk+ruSIMsfMHiV74v0/gc6injLTKaTXNC+XXP8QcaV5NcH2mAzA+u78OGxrvfjeKz/osafkpDEGI7GyUNkdGa2OdoUhrMr5X5juSo8kVa3+WSDY2IeaeoPiKklun9xBWi9S40zThUm0b2ZJxlr21Gsm0590nXOQ31elx/TUjy80+tzLy6xT58PMBAR80gRBsiFsgWEy2GJMav8x7LmXVq1jFmEvtz1HYvtY/qfKdyjcECmAa3h58PTmTCTCjdfU/CtIUpZelCAcifK9Zbt3XxDi4K6Hvge1zyrY6owqmS4Fp9GYZeetf7JL8ShE6CDlHVv+ivKNpA2Dw2VCtGcsBU+cz1z1pUL8g7de1rsyiBvn77qZSwNS
 sRpVQyTg
 aFHFUIxyTU+DUSPy10oHPqKFKUIksUxeKYtOE+O/yHHxDlJzQT6EHWQ8jCM30UeH8tJ2hlogR8Q+ZiJQX0jB2G6SHzwA2WK8W+yTurt2F0Y+kU1M+/IbuY/u0+r/4BUj1tehZS3wYadee04jpEV/TwyUG3AQGkWBmhLLRTFSnLq8GaSZfmJ21+DHvn+7gH3fVtt8+wngCmP6liZ8tSjBBsneRMhiVaPahOuvfKQaNzDarq5xI+HDcEtGS8LUYAjL7Bgea8455ucVCMVueqPIemgL/WhnJO4AxpvlU7epm4gcBMNtlh8beTcP/zwOm2/kS83o4lv0H98MNcWe5IY8XAVtAdditPhAitVFCjy0413QHve+GR2eCu6837qCamTaM/B8btJJbGNv/v6hsTNlhwpekT+BRfMJQ/FkVqfwYyal4R9DoPw0afSM6iWh63BG2QDnfs9h49Fp9qB9phjTBcvdGzwtPia1xOyb3Tlncpnroy3yHvGFnYE1EdbzS2COvS9cB3q3Hb3e71KGZKP1H2Vkax6/Ezq6Oyc7bFuXigfeZsyew3IcP2bXw63D/W+d62uSiSji95jY84E35OjHvuU3Woc5sr/EbyDVMLdkukpVB4wDEshM1P9GkJBaHJ3ibyz+OCCWDZ5E9npj9Hk7HjDEC7PJyjHPrlyeGg026ubztukQs490lQwMxbc0jXcfaRfcNp/lEstyenZ63tgZM0J0nvrCeWBkg/1v5UR0yr1JMyXskRaOeNL+6EJPevO+lvTk5cHYpAcgVV0qUOFTpr61AL4qSn8tyXE8PQitbtgsGrFHotUA0DB4OVqnI4FWXeWlnzgWAedihaMT4BdhIWLJ5w7Sd0j0k8WO05D86OlCx+y2v/8Cvsv/hKQ+vFpOI7SknCkGTL1AOVTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yeah just hit this,

Adnrew - can we please drop this patch from mm-new for now? It's breaking the mm
self tests build.

Maybe then Wei you can do a v2 rebased on current state of mm self tests?

Thanks!

On Fri, Aug 08, 2025 at 12:01:47PM -0400, Zi Yan wrote:
> On 8 Aug 2025, at 11:59, Zi Yan wrote:
>
> > On 8 Aug 2025, at 11:56, Zi Yan wrote:
> >
> >> On 7 Aug 2025, at 4:27, Wei Yang wrote:
> >>
> >>> Currently it hard coded the number of hugepage to check for
> >>> check_huge_anon(), but we already have the number passed in.
> >>>
> >>> Do the check based on the number of hugepage passed in is more
> >>> reasonable.
> >>>
> >>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>> ---
> >>>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> >>> index 44a3f8a58806..bf40e6b121ab 100644
> >>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> >>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> >>> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> >>>  	unsigned long rss_anon_before, rss_anon_after;
> >>>  	size_t i;
> >>>
> >>> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> >>> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
> >>>  		ksft_exit_fail_msg("No THP is allocated\n");
> >>>
> >>>  	rss_anon_before = rss_anon();
> >>
> >> Which commit is this patch based on?
> >>
> >> In mm-new[1], verify_rss_anon_split_huge_page_all_zeroes() accepts
> >> char *one_page and size_t len but no nr_hpages. This breaks
> >> split_huge_page_test.c compilation.
> >>
> >> Are you forgetting some cleanup patches before this one?
> >>
> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/tools/testing/selftests/mm/split_huge_page_test.c?h=mm-new#n110
> >>
> >>
> >> Hi Andrew,
> >>
> >> Can you drop this one for now? Thanks.
> >
> > Wait. It seems that mm-new is different from Linus' tree[1]. I wonder
> > what is going on.
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/mm/split_huge_page_test.c?h=v6.16#n109
>
> Wei, it seems that you lost the race to Muhammad Usama Anjum's cleanup patch[1].
> You might need to add nr_hpages back.
>
> [1] https://lore.kernel.org/all/20250731160132.1795351-6-usama.anjum@collabora.com/T/#u
>
> --
> Best Regards,
> Yan, Zi

