Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1775CD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AFF6B00B5; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B3A6B00B6; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6FB6B00BD; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4178A6B00B5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E76F558E84
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:15 +0000 (UTC)
X-FDA: 84335206830.10.9D501B7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A1EE2000A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DtgFWS18;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OsIcbwJA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505832; a=rsa-sha256;
	cv=pass;
	b=cchSh3e/btivEYVfDoX47AK7XtnRHIONRnc7mHwykHsjCd7mlC+FhqQv6s0ldsdxm0MjIF
	PLGMn7QGIPu+QzVld25mxMB2PsDebGtYxdwcTjOiYnhsLUZluEml30b1XA/vOBAyIBiZcK
	KP9sHGlcneR9XbRnLg2tbLMn5debBRc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DtgFWS18;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OsIcbwJA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B4a5I4Q0d+ZbwwDK7/2DdZuz082W9KnEhMJ8l3ocyeg=;
	b=kOUn57+byeXMaYaqzjdzMjCbrlhaFfllj5qGQKu3nH/QqnkWqaxLXfcZEIL+c3xZNz+02t
	QUsm+YJhFTIt3M187gDyCXUpLN6O8g8FG5puyuTMHp0b6KQSdqIAs+Zg/6tMBS9Ebk3pZn
	xxw4RPlRQWsd2KpoZDyw5TVzH31KVzg=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGnSWY2420224;
	Thu, 15 Jan 2026 19:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=B4a5I4Q0d+ZbwwDK
	7/2DdZuz082W9KnEhMJ8l3ocyeg=; b=DtgFWS181GN+yOKtls2BQ1mpC1vpN6Uy
	X3KON2Itf0E3yttPc86vC3hC61oTz2ftparx+yjtKFs8CIt3HFv6kX6qO2rPHBkZ
	PVXyoRM56eMbScOE2dqXEl5C4WsxVsUrfrEfjTCv5GKUOzISdOGDBEdaW7FWBKCZ
	dOfyulpmBoN4bDm5VO7Y59Fm737vgzUYdQ0P6/cBtD9VeSEcpVhIwKcOtr+L+tlH
	VVAsWvn9vPCI6blqT8d1IwzYyY5pho9nyPYeJEljdFEUNF92pQdn8KEpCMomQ/HH
	AfXnr3pXsYYeZRFvb8mDKa0D1xlgV8de2SJIYoKmsDYCv60MLw6m9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre40j0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJKQPP004292;
	Thu, 15 Jan 2026 19:36:59 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ngtwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:36:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MWr4GXjlU1bhzMTbrcOnlcjJKJvOBk6CwiPDnPslCavQ2SqVEfXJRYVAFB9f/3tdPcuhzmg7sWWNwK7kDDM3mn1Prb+Z6j4fn6JexemLaeFXYyx3sPcM+XLKBvgHPNhvxMvKggnbFc+oxQWVgA/W6oJpRKcmdUhmMRwt7R5quDne5Jc3tKBWdqh2WDUu/zyBITTJouyyhce/BiiA6iJAqvBvwqNUTPz0FbM8BWc7xNDGhnwK12SLRfXi9L+qFjAqq2hsDTYgx2eund2BNEN9udkTJtKm0dxJPwaSloN3+ofssS8kHpTndMg6qucHfAf1r3B7HWAaQqUgVgcMqz+RbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4a5I4Q0d+ZbwwDK7/2DdZuz082W9KnEhMJ8l3ocyeg=;
 b=Wp2Ak+r3oYNvnenLqcLhnJbVwe+iglKLbQW1gEjPkuGuXJkrZDU3DLSc+II30qWmelmqEKdjzYNNFNBtK/WWEg19+4CCBzCG5NlJnHSdvQ0o/xJxf2YshNpkJea7W+B5xAHFMK4TGE/7rSEJJ3Z7zlrO/+xu77DJdnaQjIFEqEQwfQB+PkNy6Bt7NYaMWgJMJSTDTaz2IV1FAGYCB79GY6S4DZtqoSOBmLULC1hT7hrVFcXQCZopNcvxmfdOA+p0AfAt2X1ivesrDr7GOEgR7PV3oajIuxuKHDQLs1QWJ5AbCEHJZsOaUCvu/GOiEQgAvDQPaoQfSFvfB+fEF+k2Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4a5I4Q0d+ZbwwDK7/2DdZuz082W9KnEhMJ8l3ocyeg=;
 b=OsIcbwJAwLh2kf7M7Z8TLEaZMEMo06q/qMbgRv6C8nss9kI0LEjwr/YANS+cxuYQGiKLqNDRKxpDjiyrG95Qdv91cBWaK1dyQfNtHHTJNNqnUB4MYnTI2W44ZPRJr2w7bGg0OCT4NmmrCLWEtvdZWb10x//fjboHgjkidO+x9nw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7703.namprd10.prod.outlook.com (2603:10b6:610:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 19:36:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:36:55 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 00/28] maple_tree: Replace big node with maple copy
Date: Thu, 15 Jan 2026 14:36:19 -0500
Message-ID: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0069.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7703:EE_
X-MS-Office365-Filtering-Correlation-Id: 929a6486-9f91-42f8-2cfa-08de546d70f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mzhcf/AmviQ5QFkEysuS4mB+KaavsNDhO21mml/DGyFnbb5pmhdjSdsWn8Qb?=
 =?us-ascii?Q?XtfIIY4oKwxW/N8ycCEZq0PwsPwRUNeQz1SZ2iFPRygy/By+DO+DhWaQb/kO?=
 =?us-ascii?Q?lewyl75RBEHmqvUltru3/1UP5Wihj8Z7R+8N+ry4Qt96aNKSc05j8uOpYog4?=
 =?us-ascii?Q?zXHydOEmDSfcw2EWgOqJaUq0/C96gA7Qfavxv9Q+LsdsJwFruIUejMSj1RNS?=
 =?us-ascii?Q?VJnFJw/qMGxSMIyAwj5qcPnEnDPTWSRtIYcu1QNbJ6HSHsuq8AIRizg9dutU?=
 =?us-ascii?Q?u287w43bk+7tRhGG6vKsdAmQt3tDlOU4Edb8nOwhO2ljAicuxGDEMoDFCWcO?=
 =?us-ascii?Q?M4kwMAlj9C3bA+g9iAtSb4qclkpM0B5hnkhuBMpsfO+TX91ncTVn9ePC7BRA?=
 =?us-ascii?Q?dxkVrUcVV0y2BMF8nuBBn7BmvnJPhsaP6aHfBZwdmR2OuoW98dA2PRSrdTIN?=
 =?us-ascii?Q?32/nhsb6ZtI89D6YL3/d57Yu5QqZBOd0N0xlycJwhPXxIiYfs4r95mRI15ei?=
 =?us-ascii?Q?5mVCc1sXrkysE+DgjT/5Q78RrO7gX3naAvZchmeCTzL1QSzkElKmxC1casni?=
 =?us-ascii?Q?vekQkvRCpGdFt5SaunFQQwtJocZMpFzbqbU6WFd3rUU/OAhNokUPCSlZKrU3?=
 =?us-ascii?Q?KSbIfi0z1qcSV9kKOo7b5rVa0j2hC4mm6FtN6K7N1gVGC8LoH2SG3hfIZcNB?=
 =?us-ascii?Q?v3agxgxIsSidg/5f+SdEp7n7CkvDCB3RYs9u82DFbth9jTxZSGbu8J7wDnmr?=
 =?us-ascii?Q?lphks6q3SgDxhAmT7kJs6XVw9E/kOG+lwZniQZFOuWy9ZLz5WilnRSO+1Lod?=
 =?us-ascii?Q?22+3cMwI/qZdQvJxAug6UrSca6B6Lz+1v9TOi5LHZEjLywTZWWSL2RE+ByL2?=
 =?us-ascii?Q?MfyxtVYpR+1RhBSYTudZZ5D+Pxg1wXmHPhXuRyi5tFNk1qn9REQTaVY+oKEl?=
 =?us-ascii?Q?VyYcm8haPFq0J3zPi6xono8P7kNIgg67OtzwGgowflTVq+SjZB4A+j9Zlv1z?=
 =?us-ascii?Q?PmTWkgGdFkFVF+0frcQuYkrkmRwLBsUuQb+motYiBwtiqWgp2H//v4WP53Xu?=
 =?us-ascii?Q?NSlUhAbtegkDARY7PhQF7rNZ7fedkeTOUHQyxwb9cP8DC4XqoczlnGv/H6iT?=
 =?us-ascii?Q?TyNtVCr2bCPCq1iKbVRuRkKv3Yq5r4iwcmTjUJAeAED42leIVd2U/6XF9vtN?=
 =?us-ascii?Q?xrRB3Gd93Uw+fOPlscW+2wEChnkSyGrQxpKBroUYSPc1pdOTN5EeazEKiWSt?=
 =?us-ascii?Q?9nayggmhDIF07HfauytZjsw4hpSLU9dTFaVLrlV9oZ4wT32TEKMkwKtRQXMo?=
 =?us-ascii?Q?Mmk+FeY3E1hrwjs3zTaoqJ6ase0sTYgHaINItcGaGeNA7htivp+4x8OV4hZ/?=
 =?us-ascii?Q?ZuKFEZGshmcx3EiHc7x0RIVbEELU/RRy+KhxzAdSccX0Gje58rHgRTe/nnxh?=
 =?us-ascii?Q?O1s1Gcpn31Q0f3W4CWxhx/NXHFDcTnYE+oX8z4J5fyMt0vdb3Gv8C+TXIRgl?=
 =?us-ascii?Q?6w1UsCz++KvgWQmVzsyH/b1XmKI+1eXlI+Ug7aCWqu5VoSlBpcBieUZ6RAaZ?=
 =?us-ascii?Q?iPxmQvf5ylEPRmWCRD4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AazZQn2IPe6Hs0VEYnfAtECOGTIImXtq2mQBsxQ3r4+nSoDRP3qjm8P+ovQc?=
 =?us-ascii?Q?BtDZ7TT/BXXadV1YcxMmu98Cb/d/5dFYGBT0NzNsfvvd1gotrnIgdzRMLg0i?=
 =?us-ascii?Q?A2PpjvEkrazFxBsjS4Ca4iIuKw5Ly8bOmD7TPqSjmx65s8m9qGgLxGsPgCUC?=
 =?us-ascii?Q?EGSB/xXr66xSDRzOujTYcJb9R3I1FfNUGMhZh5cU3KwDwRfzB3En5Ow7A2cO?=
 =?us-ascii?Q?jc+Y/MB6lEfzQEbJ3d3slGNDAzUmY34OYUCTgkZg/fMAThoMlukeRNetZpnb?=
 =?us-ascii?Q?xqIggP1EieHAAy4REXMPZxaxlycZsqDgwJpugnT+HmUp4JObiDELXS4XwK63?=
 =?us-ascii?Q?DLoJJ6VK34RZ5a/MdBkkUfpgDkBLlqU7ISci3APG+wBFEOaJMQDHIoqKG5Vf?=
 =?us-ascii?Q?ggXmliRR2XiGtpqrkFEsOaDHrECdPsDSzBVAjo+zk47D5O1IJxgwA3qdRWbU?=
 =?us-ascii?Q?GU/5jkIMRGyiLtY6svE93k22iSvYRxUqTpb9TXmFMY9YbOPMMuOQefosFCZx?=
 =?us-ascii?Q?fCcUEHkb8r7toD5U7AGrTwWrQw99CTVkZvIlJACGP0M5CzVxydeKj29TjJpU?=
 =?us-ascii?Q?YhdQCymZgzjvCpKm9255NARrLrLJC5FSxz7zZ0zO77ierbvv7FrPRXdgC0YZ?=
 =?us-ascii?Q?hulNas/G3j6eH47ACA8IdVaWGK3mMi3B/FySbUT/DPXHIkb2pUeyjEJoyinO?=
 =?us-ascii?Q?sMV+SokywDiJi+OD9M3mk26M8ctUR7mXuAMaseCr2W2sNlFfnG96z2UCZufF?=
 =?us-ascii?Q?+iUMWhlZYnKurxAhJLI9RWA3QgbGVdLR2Z/mJSqtSZ2HGTGLRsau28srUOls?=
 =?us-ascii?Q?VgrFLm54Hkz/5/MAgQUnaUoxnisJu7u8hM1Fs60pl+AUTB4cicMs69COFSWU?=
 =?us-ascii?Q?AEK7XTB/lwohHVVFDdw5kQ3DtbjVHs4YIZwGAQR/ReMvR0z8+9X/SHd8rQm7?=
 =?us-ascii?Q?slt6WL6OnK0lGNZL8vcwcjP82fQKNEQxA2cBufwBLEkg7eg9cThpiTnJlIO2?=
 =?us-ascii?Q?HxFIsS1R2PJKCFIXGOAzySIKdL7Wug3tJhAYPhioTXSNYGtHlFWXqK8xcdMR?=
 =?us-ascii?Q?ZhPugxtIIX9zWTsORMD6eRPfKI8wahwLwv7gxBxLEJI/iaKoSgScil9QF1LR?=
 =?us-ascii?Q?0/F1wB982ar3e3O1+rEX9eoi++NsxNoHEMdjYWF2WtN9FY/+B41Rsb72mr2K?=
 =?us-ascii?Q?NUty2FUH8xsOaCDLpxpc/XR2ZvlcmLIjjvqOvXheZIl8DVpYB+GBzFv1Qd8d?=
 =?us-ascii?Q?+3/8ThYQ7f7EWh0CF1e77YWc9Qf/C8xav9Dna4RgjqFu+XkWZruNmZYG/osT?=
 =?us-ascii?Q?EUbyZk3By0zHE4cKbkjAVW7n3R5TpmTZqoqPG8xJZemX+FlGj6Lz1vIJgG/s?=
 =?us-ascii?Q?SQotSEwk/XImbxUA1g+7LkcJVuNvFLWYj6g3/PGYqm8RtYpZPNFR4F8inESq?=
 =?us-ascii?Q?lLaw21wTIAX310yVuYU4I0ezKhWZghVDK5Y7oIpL+/KEjEsGutUnpuvvn0mN?=
 =?us-ascii?Q?63Umyz0//KOCBU2A/Zc3EsIbiCifxPT+3s6APxCxisb4MZShRdLKypgGrmLr?=
 =?us-ascii?Q?TjQLI8cnsNKEi/a3reGMlyjkvSQgmmtUUSyQbKl4dviW4VxhnH+IzUBbOah8?=
 =?us-ascii?Q?j1nJG55z3sZF/paS+56XXLt5cWcoxU86eXdFa0At8QYNH31zoC5ZLDgBp3+O?=
 =?us-ascii?Q?enMHHWjJyOTWUVRM+bBTJzWLJHgrHHqsHlxDJ/2NE79HkC+UPf92+kBq1kGA?=
 =?us-ascii?Q?67cB2Qip2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lC0k276JPLelkHUOsUR6fjag8CMoqFEy1DX6U1kEfdnBHYKr8gOD7nS0sFxWAS122zIaC8M84rwfdNve1J/pTFiAsudQyPi34mY1aEG37k8W9wTodOMJMuTeUaj/Ip2M22AP8OPfjlOpVlndKwjvk67aqiqjyW9jE32fzfasZhpB5oo7EPCPPaJCg4zCUKACBOsBmz/Y8W18iZgVPcNk6KLjEQckZit8ZYFvb7clbn6u1MwGixU0sisLoRpOgcJ5J12yipQ0xDj/TPKPs4RnnBUAUziglcVwoGsOBDI5S64msecNsSw1C250XTSMSfmZ3Ev6xwmNwrGw70SbfwtSetQoR1SvgjycHAq75WVisMsP7ZXT//FebxNXBE4EcbReJM3YZlPgj3/z2FnH1WuaT9QabT/fc6on5K+BpUkd1w4+ugRYuRWhLucFS+P4MdRp47xhSwbfBwq+aCdCSMA68cnbWa1POWj++knOiErk0dOHy6xZVT+qJsu8LriE8GkFtjltZPiRrLFbOkcr1V4knDLRNarLjX189Mxo/J3V7OcNdi4q7iFXBxNtA7cfyIiyhMl+urmCLSLWgAs6R/wp7AWxuqhsL9G8z2tC2iv0EYk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929a6486-9f91-42f8-2cfa-08de546d70f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:36:55.8399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SbZ9Te/yiqQHufXluri4x18gpnylXG8WNvc/33PNkkbzNCSv2wq1iJQDrml1VPmzqx9+iz8xZ5OIXmCOHG051A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Proofpoint-ORIG-GUID: wO-OC-aiciXPrioLNq43vV_DP3TtuePo
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696941dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=_FideWHkrVRX3LgMxWAA:9 cc=ntf
 awl=host:12110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX+jiCm6AsELJz
 Jj5b25hlJPSbEAPU/fCedJJB6X3JoXAoeHsk1jBEVLrEwsHd28F8tLsG8w6LCFe9mWNP74/FLht
 ZCvd+A/SZx6NRuYiMa6ufQcdcRaw4doxXKseCulXaEtAcQ/p2pMoJBVqJ9RAhHHTKnEkeYDsdn5
 FpP7rSu8puUsn8zfJUmyXhaWpN7/abaYxX64gtqXDzSkO81VtgG/WPs5TnNSLZ8W2EcI8//S4xF
 2SI4TLxt4avh9RF9HgEoHZ4zVYD2RNFkIAw9joxRuA3ECNWIaWZ0/mVl8vlYb2FgpbOHSgUvFWn
 EztGqUj+iHACp62UDEqiD6SWaWwxf6JST0lO6LvJ87RoxEjBCYxXAgAx766N914FdAI7vWYj5q3
 /CX62umzpadi8f4eW6nmeG0hFfMEaCZjWQ0WAeJvSooAu0IXx1U6WWjpUZaqziMcgmTyfYbnKos
 ePoE0LUlhyaiC6TyOYdoBZ0okeID22ThrRF4PZYc=
X-Proofpoint-GUID: wO-OC-aiciXPrioLNq43vV_DP3TtuePo
X-Stat-Signature: ouznoyxrcji9z4dzheawodtpqhnnmhmg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A1EE2000A
X-Rspam-User: 
X-HE-Tag: 1768505832-281041
X-HE-Meta: U2FsdGVkX18p7Dl3kyHPqFvEYH1/AjhIKfHfPVoKOUxzZ+yZHI7Yl1DCT1vV11gfvfbdd7hLOPHAM6wAu31CG3e6osgr/W7m7zM9jpcf0Sq4bVDYbjNOxYBFhsBq/AkW2xD4erRrHrsYqP4ajZuBbLJTohGbwHJoBtvSp6UPn8Flyfv3ciGqVh+Mz8MhesRL7VcuyWESemkA/eb2vRn4rFP/0udsAIbhCfC08WE7TmgzShsmiD6XBMPPQGV95EOVh2rXaMCGqY22c6cNN7Nh/9aAEWZN7msMQ1wocfkTBUMXST/xYHyp1RfTUIctSQEZZ9/sP8dDqK6iOOtzZEbgnoCOzvQVhiSFHWy5OIWb49saYdVAICYrFV6QtPqILYKxcrRZgtbHMaqdWmvIw1VASw2inAsoJPo9DQxXt0uT5oJO1Uo501+2McifcBl1+GrOmTC6APAuE9dbeavVxgqS/Nz5+VLbf3uVN5EdvoOfJVETizEK9VQdJB2oVFKQLl6KtKJhpHiE9Hg0xKRnJ8/wEVoO69i+7bbangiQOmcsM0QcIplB1n9nl7GKsmkLZmzAavcDErCZ80tmqJ1MUS+68UTNNG2wLXPTq7eihCdn3TizNQKEBFr6nYK8mpOghX4HQvpX6dylKWP8oype0EomOfnyqcUzFT2OkDMTBv8LTLIrhe4oDCuV0hImJW+AVjkcmFW+GcIBjVcRBneSQ6GY2zRRCVHZBhXEUS3IRxiVEE/zXgxHJEaOs8ROrqB2CEcN/qb4297A5/GeiTstzcdibQvCjv1sXpp+/ILK509QTFauJjKGR2SYav+2kl4Yn/feNNV+KIY0M89ppqIPBEsszVztZX3Pp0eoW77jMCCMQMfAyNMJjATuKaR/9PuPhiEgDwuzDw0EpfYtlhDAdril2/V63b/UKaAtZucDwKwaYajrVVPEX7xeYXzcZbrKTA0ZiMyTAnVPzA2lPIVeidW
 sSblMrOV
 0RKF2+JUF/UVX8g0R8IlwY6VlTM2uNdcEhEo5Icj5NfTr7/IZjjlc/QulkMInTYpXHkjA9HvOQyK0o5X3T2XM571RRAfJ0/P9cPKR8RTtl72IR/anwwxROz7Isdf3Y6XcqnOiPSDBRDuDjCEreAG/xb3PHBReq2OQvvsgtIIMFK2Fuq5U0GOCnPUSH0uaB+lPzH7/XXH2fBwNpcf5IWfiuysBcbNbYZITXUB3jffvghQeAhcgDLxJN57WXzQ2x8DUuUjGLOzwnGkfjZ9Vhr8W/4Qj00+7SCwC6Wvdut3y5Ntt4iUnX0r5dfHQxFWfZgF0OQm1+DqL+NbSPjiRW0QTD8zH8sS6vGc2+B40rJB6vn3sS5HRSfFnl9KIYOffp66ZAXzawmr7d+G4Jf1tNDAf2Fi079NMihuexpMrsysFWHQMTgAObm6OnauVMaufOntYMPyvAvFZthXaODFwiP816/ajL7ZQpQVJ/qgOsxJvAl2fC31MXEZDpXfcMcDVdaRpurI6WsSJUrGVel4qQnB69F01v04OyjJo5AuT8jCAXH+OmqN21TWWpqCLSvbP/olqUm/3BL8TFt77DujyC3cyvAdnnpaCIw3cZT+JxAP8SG7ypnjzD6GblozzIS9iyh1Koe7AxCdwqDUGJj6X1JxhEt1qeU3OBVaStBrd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The big node struct was created for simplicity of splitting,
rebalancing, and spanning store operations by using a copy buffer to
create the data necessary prior to breaking it up into 256B nodes.
Certain operations were rather tricky due to the restriction of keeping
NULL entries together and never at the end of a node (except the
right-most node).

The big node struct is incompatible with future features that are
currently in development.  Specifically different node types and
different data type sizes for pivots.

The big node struct was also a stack variable, which caused issues with
certain configurations of kernel build.

This series removes big node by introducing another node type which will
never be written to the tree: maple_copy.  The maple copy node operates
more like a scatter/gather operation with a number of sources and
destinations of allocated nodes.

The sources are copied to the destinations, in turn, until the sources
are exhausted.  The destination is changed if it is filled or the split
location is reached prior to the source data end.

New data is inserted by using the maple copy node itself as a source
with up to 3 slots and pivots.  The data in the maple copy node is the
data being written to the tree along with any fragment of the range(s)
being overwritten.

As with all nodes, the maple copy node is of size 256B.  Using a node
type allows for the copy operation to treat the new data stored in the
maple copy node the same as any other source node.

Analysis of the runtime shows no regression or benefit of removing the
larger stack structure.  The motivation is the ground work to use new
node types and to help those with odd configurations that have had
issues.

The change was tested by myself using mm_tests on amd64 and by Suren on
android (arm64).  Limited testing on s390 qemu was also performed using
stress-ng on the virtual memory, which should cover many corner cases.

Liam R. Howlett (28):
  maple_tree: Move mas_spanning_rebalance loop to function
  maple_tree: Extract use of big node from mas_wr_spanning_store()
  maple_tree: Remove unnecessary assignment of orig_l index
  maple_tree: inline mas_spanning_rebalance() into
    mas_wr_spanning_rebalance()
  maple_tree: Make ma_wr_states reliable for reuse in spanning store
  maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
  maple_tree: Don't pass through height in mas_wr_spanning_store
  maple_tree: Move maple_subtree_state from mas_wr_spanning_store to
    mas_wr_spanning_rebalance
  maple_tree: Correct right ma_wr_state end pivot in
    mas_wr_spanning_store()
  maple_tree: Introduce maple_copy node and use it in
    mas_spanning_rebalance()
  maple_tree: Testing update for spanning store
  maple_tree: Inline mas_spanning_rebalance_loop() into
    mas_wr_spanning_rebalance()
  maple_tree: Change initial big node setup in
    mas_wr_spanning_rebalance()
  maple_tree: Introduce ma_leaf_max_gap()
  maple_tree: Add gap support, slot and pivot sizes for maple copy
  maple_tree: Start using maple copy node for destination
  maple_tree: inline mas_wr_spanning_rebalance()
  maple_tree: Remove unnecessary return statements
  maple_tree: Separate wr_split_store and wr_rebalance store type code
    path
  maple_tree: Add cp_is_new_root() helper
  maple_tree: Use maple copy node for mas_wr_rebalance() operation
  maple_tree: Add copy_tree_location() helper
  maple_tree: Add cp_converged() helper
  maple_tree: Use maple copy node for mas_wr_split()
  maple_tree: Remove maple big node and subtree structs
  maple_tree: Pass maple copy node to mas_wmb_replace()
  maple_tree: Don't pass end to mas_wr_append()
  maple_tree: Clean up mas_wr_node_store()

 include/linux/maple_tree.h       |   42 +
 lib/maple_tree.c                 | 2184 +++++++++++++-----------------
 lib/test_maple_tree.c            |   55 +-
 tools/testing/radix-tree/maple.c |  183 ++-
 4 files changed, 1221 insertions(+), 1243 deletions(-)

-- 
2.47.3


