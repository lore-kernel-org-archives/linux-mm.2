Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10F5C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C7B6B00BC; Mon, 11 Aug 2025 01:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402C66B00BE; Mon, 11 Aug 2025 01:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA3C6B00BF; Mon, 11 Aug 2025 01:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09BF66B00BC
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:27:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B42738256C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:27:12 +0000 (UTC)
X-FDA: 83763343104.23.6635AD2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6402740007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:27:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DmPDxXG7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cm/4Igd7";
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754890029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F8OjoQjgnjz3FhjJrnQXNpMjZ+i8tsB1gWwjt2AqUUk=;
	b=B54nL+rD+0zeJnlXFQZd1EF5Wq/6vkMdtpG9TD5tZ1PloYqB41uklZcnYgmG5yKCfpGr6b
	TKAMZVw7H2VaJpmBsprLkRupYI+Du7TQwm+XTN19CayO6TFMvmk80673YbxWYyEYLRp40B
	gDALA8sCaMYJaSL+nwFlLZzFAkiJFvE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DmPDxXG7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="cm/4Igd7";
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754890029; a=rsa-sha256;
	cv=pass;
	b=GZpsdjU/jVOlBGA3l0bf4AstTrnsHL3mY6aTsN6NSwMIPgncCMhoHwkDaTMCrGuKg1i+qd
	npGLJ6hi36jqLFfKVi8zOm1/cRHOjHAYdgxApokFxXX60C5sUn1WiqQhpo6boC3fq+6Z0T
	kXq/bIKkTPIhzLCvkAJT9KheXaZSxOU=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B3NDiV021325;
	Mon, 11 Aug 2025 05:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=F8OjoQjgnjz3FhjJ
	rnQXNpMjZ+i8tsB1gWwjt2AqUUk=; b=DmPDxXG7YRlFrk6tBYX4FJLVy2ptCTvb
	J3QwM83vF0eYVqxSYNyo2x3Cpmrfgm6xdlSYAXkTJKK1JL1EIMx5GMMFzNycyIaO
	NWlDNFI5Sj7inXq5DCuq3dnqs8G3ZAjmmEVaGwH33GUpNYuxXk7S1/iQrATdQroJ
	lcsFd9iKpE9keQRSxAdyVOp+8c+5CklA4YhStSJyz8gLuSymKbDFDWi+pkqQ5IHC
	MKf8BxUOfyai4CyZ5stSEie2A2iZz9G121qxLCEz/56ALpTJMFnRqiZCGV+/Roc4
	dzBb7lmQxECRicvYd6KCZWLX6IF8SP/TBilXpXEWU9Nm2uTf6236xw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44srrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:27:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B3AVeS010434;
	Mon, 11 Aug 2025 05:27:06 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsefd77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:27:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uM/vlSpnO37pG7cW4ywUZsyaYO1pbIu2jxSDdq/NtZEdp929VBwkyXQaFFGr6c7gXKYl9aaBRpXJPMzQ95dxOloGuc3ssTDZZ05bu6u0IITav2UoxJAlXrQoZaOlZgrO84QvxWYco9cZcFX9hddkN+uPD5zHlsrhYGO8wMzd6tyHVphcVYx2sCzbpAGa/adgjHzHRDFKj7oSpsPOy8vaO88/LoqMJ3IVFaWQ8SDvML+sgZT6YDsATBiKpM6oScpifUz5E3CxUjDZOKYFkvNosi8N8shB+4s3A/FnM/cD1Xx9lhzcFmOww3qaa50Qf9s9bFsIx9fg3f87XBU12iAw2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F8OjoQjgnjz3FhjJrnQXNpMjZ+i8tsB1gWwjt2AqUUk=;
 b=Ilih6NthxGhz91eZAeyFNQn0UEuDLEBfOArvXoqtuEt1j+8pff7zZjyAP1QOxqdpBoXGS0TysqEnvGeFmxlGQaEVTIq68Al14bL82hdlUmc3yNyn5pGHnVZmo/M7FKCWn+y7PYId0GYFS/DAUcHHIQKTelmF1BvGyfQI/YdZqSjK1Sg29w6BQx9gvDYXRUSJ7gF1iNHBxGcmHdlF+mnnkd8SI6AnV0fhVUqpHIWDEKasBeu1RQZXB26Q5FZlfkX3jIGOlLlppAxNV1e6DTTxS/82CKkKq0VRXzhSGijmp2RbRPeJDaGDdolwel9Pe5sSrTlCxYslWkR7Cxe89GPWqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8OjoQjgnjz3FhjJrnQXNpMjZ+i8tsB1gWwjt2AqUUk=;
 b=cm/4Igd7lSrUv2bwBqQ5zYsmU5J3V/TIGlTyPvgT8lPPwk2I3IiSrWOq/UIsYWJF0zdxgzARZ9/ucB2gGumliCHt9LfAyuUJG+JUKZ/VGlxHSgqOV8JbVymyjCZvoQooV/Bo1BF82RmPsdvINFCdH5AAQKGCQUfNEUPY3d+2drw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6744.namprd10.prod.outlook.com (2603:10b6:8:10c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 05:27:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 05:27:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH HOTFIX 6.17] tools/testing: add linux/args.h header and fix radix, VMA tests
Date: Mon, 11 Aug 2025 06:26:54 +0100
Message-ID: <20250811052654.33286-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0036.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a02b513-6c51-4a20-c3bd-08ddd897b4dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oaDnaeSL3/1DFiDVK+QbKDN5cVH3HdYjGGBFIhylasnVzMtEdIxdHtBrsDqu?=
 =?us-ascii?Q?iWYOqeGcgXsJMmjYLA6ETp/65SlwC8VNDgLqm8pweNGgqIIRSemyAe0K7JHU?=
 =?us-ascii?Q?Lqh0cCysFCoKBVZDtaPJYNMUpBCiajrRYTcc9PaP1P86FgDPqACqm5pjotBQ?=
 =?us-ascii?Q?2Iw+dCMxLE1nVv/q0F13PijCHSIm8xr62ARDtYXxWFS1FPmApuQCWC2tBiVx?=
 =?us-ascii?Q?RvAFOCExrcyxeMcXZPOMzJkM6NAqYZvOSYK43a4TCMRLgO16vrLUSJPSP60m?=
 =?us-ascii?Q?zDSpGa8PWSiUCbTa4sEcX/lA4paoQ2mMuu7pVUfKqwyQYE2DIl9HiKgf7cpX?=
 =?us-ascii?Q?kndUADr672M1/CAyLAMuIhRJPgrWhnSr4LfyzMfAgMnSkcuRmQBkH2FJ/0Q0?=
 =?us-ascii?Q?qN+7E+vz7PR8bWNwys4WxNjgeEpKXaEHOGt0y8TV/xg0Ar+1tj7/zXncJTVA?=
 =?us-ascii?Q?l60d1cOxgTmcal+U9VsED7Y3ybrkUS1gSMJnGFayN12BzresSnW1ChXQEloI?=
 =?us-ascii?Q?LAW95YvgIYaiUg73ePyFzBsg/vKRonrykkC1l9QzqeqseyBVeSVO6JAdL4S4?=
 =?us-ascii?Q?fevB49nRWCPxDua4DJbP0jZVY9Zb//CDNkZN89K0kuFkdbfJVZ8X1DOjLjgz?=
 =?us-ascii?Q?eaEGm5qwWOsxaAB23An41IJF7uCY1jczXBd1iM/IovJ691SpxJrOOFs/l055?=
 =?us-ascii?Q?8Ly3uWeVITBJKwlkQ8kdvLh5vQuaJjExdEGrW7/p3oZ5GM6O0vs5VHHUISx7?=
 =?us-ascii?Q?crkLWTp9XINb4E4hAb/BOxd6LsvDCWFxxfKsUkC4Cys0JTw1zxZ8wkWY6rJ0?=
 =?us-ascii?Q?5INEbVAA257E/zk8oinpvin//cxRtOCnFdLGcZzUUAX34F8xboyIKO+2lqWv?=
 =?us-ascii?Q?0Qn+FhIBTAru/HnxyvsEgm12UQpbAuQ5eg7ATB1RCdfRsLe7VfiNRMxOU7Jy?=
 =?us-ascii?Q?I0DcD1YbEOLD6uvNBVd/F8dEnEzYTNbib8+BfLMGDMrKdZ6M6VT7d4Ww1GRy?=
 =?us-ascii?Q?qwxJ7MOzDk6WLTwqpC2seiSXa/fdFrynBLYIQkz03kP+31I/u9tyEvq4GB8E?=
 =?us-ascii?Q?kk+77Rw3QXJQ3H+HFXSDivy5wedh+tudZOK/DHHZ5HrZV9M4X63ybcTf16px?=
 =?us-ascii?Q?jvxbM0vLLe5MVxVejLt7REjxGDFaTyDKP3nqCgw4DXcp5GX/FsVVf8gvKKae?=
 =?us-ascii?Q?PAMYt91fWpvHHqcIOmpR/6pnvezJ8Ttg9EUmbnGVF+7Pb2WquxaPtBPFxnqw?=
 =?us-ascii?Q?YX3uT9ujGk9pYVsWCfSrjHsehvu69ip/8EO9d2fH8xHEnL2/pvrRRXJV2VIa?=
 =?us-ascii?Q?Twhi9r5o6Itb36uZ+JNXo1BEH8cQgxMOkomof4TsH2tJ2mow3i8mUKtBYbPL?=
 =?us-ascii?Q?hXMsKJhcG6nczwDxhMTAKKGISkJmg0eHgGNlkfFKY9Troj23xbakNWnr4NxI?=
 =?us-ascii?Q?Fcu8yOiq+/o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g+JCdVDvqFrl+qLdOZslNgbK0CGDU+dLHCz7/Btm7qjul0lUWAGMX6/oIpHV?=
 =?us-ascii?Q?W4fRFUdon66E2WcR70ZvsSinETFie03Bt4jmSLV/Q8jMCF2pH9PK9q2DoWT4?=
 =?us-ascii?Q?TR3gYM2U/Flw4MQEtloT0iTA/ksWmUr3OE7qlZKglAZQoIxcUuSmn4Zodky9?=
 =?us-ascii?Q?NyjbhnyftI3bVqVRxmF8aZUKSp7+M51HW26PfZD5Wec3EN6lfDLHW7TE6Epa?=
 =?us-ascii?Q?b2DLAHLcm+9d26/es5SijD0roNxLs1E7Ln40swHgVfkOmKxw3vWrqt8gpWpt?=
 =?us-ascii?Q?M/Wx70rxQMT1uDRYmXTRTpHMxfRSLZ97ssyQrk1wPzqmVKTU3F1TfZ+ErRQk?=
 =?us-ascii?Q?f7Wg/1L/ZvDj+RQOJcUJPJppQm9Tk0B177EG6dDrcxuP1hSYfiWl+s2Wfpju?=
 =?us-ascii?Q?X9+AVQ2Yfy0LbNCMW+1Anm5Hxp3rd/gDZYAlYgvLMJyvBVCkeGyUsEBCABBk?=
 =?us-ascii?Q?579nZQwUb3xOtaZ+0WBdhMI+uVVbDCFtmWRuOZaDqn/cTiHzDbkEynONcXqR?=
 =?us-ascii?Q?lWQxkZJ7AUme/zQcr5N/iiboLtKhe64wRjb79ohCyzWUU3/Hmp45BCuWvps4?=
 =?us-ascii?Q?8xNNe69PG+RHtEnJvVo/AeCEcJVKXXuK0FjnrhLXk6OnQF8YfX+LCSYqki3V?=
 =?us-ascii?Q?tS54QkPD6ukYOwInNVITTf9SopgZcuZ24vvQWpq5n65PmnIrfNRle5uUsAdl?=
 =?us-ascii?Q?rgL83/SPq1lKaDO2saqMXxcZCrPRnLKOz43OdppQrN27aKg/+AzsAp/qagZF?=
 =?us-ascii?Q?ZAy8WO8udfIO98LbdN1ex/iTvYPv6RlJr3x2lBkCaAgnnq4zWszQ1EtT6KMS?=
 =?us-ascii?Q?T5Yrwurqw4Ruk1GZ3h5oUVjatLX0JYwBoVQv6jtJ4XwxyP6lCHyimEeUkA4n?=
 =?us-ascii?Q?dpdeuf1l76BRvFYLj4Kmdh7c4o/CR6XdCzDqfM6iXkg+ShLoR7sSr9wxCJBo?=
 =?us-ascii?Q?ySiSbn1TN2f/Lx0zruXlvgNgfZE9ZwpxaSKbS51GW9z+jBVJdw07A8KU5SJl?=
 =?us-ascii?Q?dBSnFQiWmI4m60sU70v/3Lv6/4/qpcYuYFee/t+qADvHZ+rSCVRbMqdggQO5?=
 =?us-ascii?Q?+wSp+ISvMM00Dlv5wxy9W4enEH91gu0DCOxe1bxIkCXeiqquDkR0pCQ3+1xZ?=
 =?us-ascii?Q?zqJrMiqTWKLwGXkawmF5MqRcT8ybXHSNIwQsiOjxroc08kuExUp4x/0+IQoW?=
 =?us-ascii?Q?fIWuGUBVBrks6RDzGpxzJYA2J2Zi4oSEiOgsb7qzxuRS3FvfQjCcETOQ9rfO?=
 =?us-ascii?Q?Mn0hq+X90+lTG18uUSbmD63v9/9c0MEyfSfDEo/ljbySCGFABK7MlOAEKSki?=
 =?us-ascii?Q?zXlHCeggIV+kOxRL5IRudWX6wSIfk++b0oaFoTBTyU4Zw2f2OU8iEWQrMaBP?=
 =?us-ascii?Q?4zWbFRBLpNZWDCOIFUJpAfXfmXXvYdvGTDxoVZERtaQ91m4FIRqUjr+a3aj1?=
 =?us-ascii?Q?NrSr44mEZbqLv0qyWLiv7N4v91pdR4mE3n+YI6AA/G+YLs6kSmyd2tS4uUX3?=
 =?us-ascii?Q?M2oBsIOouUDc6gdkKTY4PYFWbUvWuVxGsL/Ei7FNqdEZHYX//y4rEDj7+tFo?=
 =?us-ascii?Q?1ApyWllW5KrV1MriX91FPou3a2BOhSXMI65Je6STA6Er7gokr97W40lBviyv?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J36ta1gFpviVdTPuZoI48GAwOKA7qkX1aQ/j7Y/UhnY9/vSgXvIeV+Q1ENwEMvc/o4sMBcq0ogC7JWMoPj4Njkoe9HpCwSSDx+rredszQ6SirNOhW/V9Vx5Af+8a197Bx8YUSa6FWaAij5Z73/zZ84lKuauXDXTb1dKVQXCfNK71Ak5snfaC/vS9gQV4MxcjobCQtwjWXDT/b9CD1PHbtceSak7Qm3f2Tsl9nhAfrS/otbB3kOIBASGZ6LvhCLtZYQ5OnTnM4NtepxABX/YXSN8dPMFjBNzzQfIe2qEiJ5Ye70EndF3byNKh3I0sJ8PNb9tA7DZAdwca2JGi01ZqWKBh6g0dHFFDCjR60RthYPI09a7zRC/qDDxKvnPutpMOjlwRwjuKG8vDqR+sshFedqZ52mKkiRGNUl46phCNAPiVkkpueDIXPtPbbPZyLV3RnuwF1ufrz2Jm/97FC/4whIB/90fXsJl+xjOQuAQl+2eFTTN6NkRTQeGQk5eRCqfLyWqIWuOC/opKJfmixpKlw4URzd5is13DOKx69XqhqTjMIqjtStyaNFHQHqboV4wGjjgS0TpNoM61Fz5Q2Cn0euGCW9je3c8yaR96Jcmrk/c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a02b513-6c51-4a20-c3bd-08ddd897b4dc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 05:27:04.3129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0a3YpgIcoSzmmbp3RJTw6Pq/N3WbiMJSvzBTXmF5aSa5JILz5fM/KPUmzQmA4RnGMmsgUL33rCNTzRcFTUf/GmByM9Q19oJOJLvCom4FYUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110034
X-Proofpoint-ORIG-GUID: 6w70C6fwDc1oKCdr_IaC4osfKpH8ljz1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDAzNSBTYWx0ZWRfX9qww3hmDpR3I
 5OlYVe8xoglgNhiPEbjX9rT3hGjZ0TkKs8AT7paDqgg5hc+UIfWzeFLgjfeVOu4NefiFkHxuQ23
 hR1I5weWp4w7yIshztaXuzzdZsCOah7fYk+X/u4DqBEHndM5Lqe/dsb3eY1WxYH/pz8IxW5jh8O
 cvkRoPh3FNE8IvQWTbgoqBB4hopuk4bnJa2OJoT/tmbaKxJ4bjUXF2cp2Mcg1npCbSx2S8h+It0
 fMq5NuhBI2PTypU6yJ2jKLMZDZBEF9u5NLqACR71QFFpvYhhUMmAiA+e2xJcHm82WS3S+RXhtSF
 7lDseSf7wyQZQclxncvcnuH8rtO66dHBpsYg52qCOv7xJ8ot230l4HsWkCr2jxB0d4+QdlTEPbU
 O1R3N+fUn+msIkS0hsb0K7A8NJ18lakQdOsZ1rSLeIE+yrpv+WZyH8ZPWEPAnPMgTFc1HejD
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=68997f2b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=xkLYnZLRtFSsgaPZKc0A:9 cc=ntf
 awl=host:12069
X-Proofpoint-GUID: 6w70C6fwDc1oKCdr_IaC4osfKpH8ljz1
X-Rspam-User: 
X-Rspamd-Queue-Id: 6402740007
X-Rspamd-Server: rspam06
X-Stat-Signature: 14e7xfzj3frdi1cnzuehoq4ns73dkfh1
X-HE-Tag: 1754890029-910821
X-HE-Meta: U2FsdGVkX19QlsDwVvRBcLd06czFs+XD4Rg3qW7hbaPg2Ru6BEidm5i9r7fVLuCWcUpICR7ynSI3Ene0eBl+m+EItO72aAVaISWzf25dXKK5LA6xGzuBY5HskEbNvcOrj9vUAW6rK2Q+77JTzc9csSdT7CGJrJtlf0H/+In2zlUPj6vY4YXYSH8pCm1kSzJ2OID4TqcokftTajAK/4BUraRongU+ZU16QGeKGm0HyQgoEzywn3y4qf5M23NjqzcwhSETVo0JVHZHQq0Kl5Bt8r1X9cRo+JdNrX9uSfGjQBT3cUQa9a3AdtJaTh0zFg8HbEotv7I8hCJYx83mtjuYX2cuasCpoFCf/1DBScJ1BZWrUrQ8OjrLtQNV5/m9rch0PZMf38gLOkzwa2CTJ2tpbKKIJZaM7KxVmmocODgOqfaP/kiCH7NKKKmt9Ya8qITbPoV8RkD+j9/SRfk6mtaNtcJD29kD4dJxHgpYskNiKauyWHpcRhNv3PO2Vc8GX7/4KCh0pum/MPmwzrJVBZe4FovU5SLDowE7nWOacAfNo1GeTjQjeI+d35CDeil31MJ+j6RO08GuWmVT3Y31XJRm6K0dajr0FKu2pFs1hc0CKvDvuz5s3/JEBr8jjShWHI6ZvAB3FvIND7+o2yx8RNvov5fF/9O8XaM0QMaguu1bd6lUkG/HKekJq9kYrE57doxa1CRLBcixKwnQr8hae6G0YV3dRaJw4bYS+GIGcRy5WY3uUebMXfHtnNVzcmNXZ+bXpN05RTzjVScTYhN3DPZbzDlSP8DEkEwBXd4y5VjFuZthrdR3Eco5EkY75/MFBjHz7SjQyAeC20VqvpMj9jbmVammVYqR1anNxtsaAkhrnTS4H7Lhx01IGvOYB2wv9zQSY6FgIMS8QX548IKdAb/hTP1TnGD5kMWRqeja8TBeWIgF7RNotPnhcmnaoLAgV00bb8SwGeC+okwmXB/BMWi
 aoyzPsDz
 6ts0tRS18X5loSoj6099opf8HIEmi+e0zZ7hHmj2ERetk04+LCVtTnouPFS/D3/8faycAL8OqyPn5xEoYlSSYiAgd7Ae3zQTFS1mm058J4fBPAA1c71Hgub1uVsLh+IKiRrmzhYuo3vTpLvHCL3QtxQGACWluTTTuxd4pTg2xyk6N5LxIIN+MS+q914hyNi6lyvZKZrL4utz6uSk/0rachAsTdzwgtOW1CoOFzg50roZ+/f06upHemice4J8Jphcq/+7+rf5r0J7sY8rANVerxOsMdPXTpZe6i8U7F2I8VJ+aQGFcRY5K/475hNPwm4IOHcnNPw+vKvXgU3HVCKecmBFFJ6yPMb/oUA0WGs6LZTb5Saoxo4bUl5FfuUOyTUhxA0nnyuvNxx/r46sn4k0wQ6DPSMBGQh23CpZsKUgr1XwCSvqFTVvdSW0mHFd6+ajfCTIqfm1hBLlW7YGU/vMKDkXOcith1xaCM1Sp34+xqqFp2nj3tlpytePL1biLPPp7T+axBYsrQoup3sA/SpkUKEbEJtE6+kLFdf+qCFFQg/XI/pfOYeOgEfjPGtB0HcHvOH0SsJ8e6kcuXAO3nCuR9WxwsJWoyI29cbKkT3SfZdqsWR32HFpZIO8x+cGrBXsmeXhzdA14dFYKuxLcuvkGW9diVcmhJ/9gKTAoIIFCNr16Scwwv/cv5xvSOoEYf/lvcprUN3ciJKL0EglSvSNGn8weAzyWs1lh2Z4tAfL8NDAv8Ps=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 857d18f23ab1 ("cleanup: Introduce ACQUIRE() and ACQUIRE_ERR() for
conditional locks") accidentally broke the radix tree, VMA userland tests
by including linux/args.h which is not present in the tools/include
directory.

This patch copies this over and adds an #ifdef block to avoid duplicate
__CONCAT declaration in conflict with system headers when we ultimately
include this.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/include/linux/args.h       | 28 ++++++++++++++++++++++++++++
 tools/testing/shared/linux/idr.h |  4 ++++
 2 files changed, 32 insertions(+)
 create mode 100644 tools/include/linux/args.h

diff --git a/tools/include/linux/args.h b/tools/include/linux/args.h
new file mode 100644
index 000000000000..2e8e65d975c7
--- /dev/null
+++ b/tools/include/linux/args.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_ARGS_H
+#define _LINUX_ARGS_H
+
+/*
+ * How do these macros work?
+ *
+ * In __COUNT_ARGS() _0 to _12 are just placeholders from the start
+ * in order to make sure _n is positioned over the correct number
+ * from 12 to 0 (depending on X, which is a variadic argument list).
+ * They serve no purpose other than occupying a position. Since each
+ * macro parameter must have a distinct identifier, those identifiers
+ * are as good as any.
+ *
+ * In COUNT_ARGS() we use actual integers, so __COUNT_ARGS() returns
+ * that as _n.
+ */
+
+/* This counts to 15. Any more, it will return 16th argument. */
+#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _n, X...) _n
+#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+
+/* Concatenate two parameters, but allow them to be expanded beforehand. */
+#define __CONCAT(a, b) a ## b
+#define CONCATENATE(a, b) __CONCAT(a, b)
+
+#endif	/* _LINUX_ARGS_H */
diff --git a/tools/testing/shared/linux/idr.h b/tools/testing/shared/linux/idr.h
index 4e342f2e37cf..676c5564e33f 100644
--- a/tools/testing/shared/linux/idr.h
+++ b/tools/testing/shared/linux/idr.h
@@ -1 +1,5 @@
+/* Avoid duplicate definitions due to system headers. */
+#ifdef __CONCAT
+#undef __CONCAT
+#endif
 #include "../../../../include/linux/idr.h"
--
2.50.1

