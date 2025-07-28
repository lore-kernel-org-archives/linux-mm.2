Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B698C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 14:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26836B008A; Mon, 28 Jul 2025 10:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6AF6B008C; Mon, 28 Jul 2025 10:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEF36B0092; Mon, 28 Jul 2025 10:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA6B86B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:05:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 545CA112CFF
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:05:26 +0000 (UTC)
X-FDA: 83713845852.12.1FD488D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B510B16001A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:05:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f24I09zH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=itkVuuDa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753711523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAV4vevKfuGXtaOlcyf/R3o2HV03EGn8eDqHc+QoUJI=;
	b=eDWYck/xawBtosgCAAioBB+/jHDolk//5S8pj/OWJLrxS0QnLleRwlfUeL1eg4K0SAvtnN
	O3LDmHupLsvwKRZwdQ2hkSTbtaxt421MT4TUbb92PX1I4MWNd1NXqlWDufa9wiZy2aoqEg
	a4IRfVfaxuj/LYxEm2jF8k+m4aTf294=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753711523; a=rsa-sha256;
	cv=pass;
	b=yxB1t7U0xI0CpXT1dsG5HENmhtWXlmIVT+9VA8b1FDzuSj2cW2y0eaYfzm4JRfuQDMxw+X
	94r1HtivClbiTBAhF3aMK/DcPyKuHVTE29yPWTnYH1Xg033QYKMchtDLY9srA1wEkQzSvV
	dx7HzbLWjvSJ8BKPOixyb3Ar5eu3ToA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f24I09zH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=itkVuuDa;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SDCTpZ014190;
	Mon, 28 Jul 2025 14:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IAV4vevKfuGXtaOlcyf/R3o2HV03EGn8eDqHc+QoUJI=; b=
	f24I09zH5UZr5jNItenvPNLYiOIqJaN7/Ii/R+Qi2aI9Bioe1SAUh1uviWQiqpxj
	ImtRw33gEKdgBKZWe/5WKIkyTpO/8tBd4Kb/XmJMIftBSgQyIwevlQ0IAPdx5dzv
	iwbYULvTi3lgVpLEsDH1wsgm9vtgNaU86KTZb/nK5e8RBAEB/P55tqxgVttwXBpO
	al/EKcfqeeTJEONiYKdWkbOYnzGr1bsrjg1t37IvK7i0RU3V9zcEHzNFSth9ttOb
	2EYFZkSiLPmr0rgryZJPiSUthQLy+M8+fa9m/31IZYgeIgfgqR0dfgjzubU+Y3HS
	48T6Wzdk8+O6h9swYMad3g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e45gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:05:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56SDwwmq034448;
	Mon, 28 Jul 2025 14:05:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf8us7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 14:05:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QFN8sk8pr12lTQ44RDRyp9qOOg9egfeTC+2IJdtbnr9XFHn+on+DuX1lXRig9GyQjyJ6HsYYJSaT6evO+FFarFOYxCuEKEOeiAJOSUAbmi8YNww7lq+V37fgoZXJgwCwwVsBKUVPSnud8htei4fEv38WTli8+J7rLLHayrbtI49Bpo8XXbaRj3DTcNPiAF12zcDQoXy5QN0IcNAMuWpZZGHkOFPwwIZQ+NAfj6x64JS4Ef7BhUPlaBkzeCa1D/6np+5Jc/VOqRt5JlkES0FbyCcHXr8jtCBvbkIsgdjZxBN8T10z9E7P6Oz288knghKcdJDr3/JVGAlu4hK7kE5zUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IAV4vevKfuGXtaOlcyf/R3o2HV03EGn8eDqHc+QoUJI=;
 b=bRHu6ALuJ0nL+WaHExkOBWawpr+qlBQhdBaT+YVcFol6TaESghr4ZkE6AJZufI/i0WCUkS3a6Qrb9YlHqdYZYlIdbjMhkKlhyMZL74RXEFIgWzqgmF9iRljGpX6UGCIvc4YTuhHoHpOBPjpahaURb7w85wHRWNiXw3sVQqqcdJjKD7QM/Pj8+fg6ekVYurUeOvgj76Fuv5uHKKqHzMiv+HyuZahqL4xoPKCmQqP+x15CN+7p7qeyI7jKFgfLwujAkp+icMKTUmImKzXbVPEqem2En1cro/RhxAZvVQq4dX657qJO9V3SYeucC9wxtLa+FbfLYqx/pQQ5r0rZ5Jjv1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IAV4vevKfuGXtaOlcyf/R3o2HV03EGn8eDqHc+QoUJI=;
 b=itkVuuDajh+5NJVoCkiTWiQoUN5wwYKsUmxti68aSIwZKYBpnp3dhHIIkce9oRDrWix5pScnTGccCpLKTFyEklKVUYbx867FEU5+yILefmFu9UQUxT0RV6TAu4fB7RNBxDElLIKSX/L00xFY3FjgH8+9OCHsBNW4Tc4Rqr77TDE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8964.26; Mon, 28 Jul 2025 14:05:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 14:05:04 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH v2 1/2] man/man2/mremap.2: describe multiple mapping move
Date: Mon, 28 Jul 2025 15:04:50 +0100
Message-ID: <386ba8fc99adb7c796d3fc5b867c581d0ad376c7.1753711160.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753711160.git.lorenzo.stoakes@oracle.com>
References: <cover.1753711160.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MM0P280CA0069.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:8::6)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: efce62bc-46d2-4306-e36d-08ddcddfc02e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hUoDoXb9Kx9oxlhA9hvXMfHcQjCA0uvxO/Eg3Wpbrhq2eMY/7Kr86v9HPWzk?=
 =?us-ascii?Q?EWkTam3ibWVlPKPeKDnpWzZQgiVpQthOmNPMAmhkdyOsSOrTnJ+df4FszJX2?=
 =?us-ascii?Q?FaSlnhBAU7HmMM6vo2fu5shMSoivTXRZG9x9uYAB268gHS8XZFWmTxYtygrH?=
 =?us-ascii?Q?8KHrTCivmKHA7PLjp6ZEGIbAvSz0EoN/WjYHDIYSB9TX6Bgkc4FflZPlxJKv?=
 =?us-ascii?Q?W7kN4cqsCK1GovYiSv0ZIitTdDPxD3jsr90TmBOszsFTJZO4bWwGvccr5iaI?=
 =?us-ascii?Q?2ocX0UFXZNe8gK2ONjoB2C89XjuADSr6XtUngv4UG3HEN/IEP1d4R0PJAoIg?=
 =?us-ascii?Q?9YUp/m6pf0ksMJECugzfU5JDPsoFnfwtzyCErfGv+8jIjKn19dLos36rh56j?=
 =?us-ascii?Q?RqMMNbxMT6jILa8rT5E7XGxjn/YfsHMT9A1nOUCSULBpP/92VVjPG3v94Jf8?=
 =?us-ascii?Q?kcJjaehc21dILCq8sgJ8mXcTuD4QhoEe+StnO8qTI6as0jmdEA1mDlldMqIp?=
 =?us-ascii?Q?BbgMFUtjoabNBURfdLVs14mCQYWF6nZ8XAMjuCURAouqlE1E8eOm91xIbR3R?=
 =?us-ascii?Q?w4pz6MMbscoMIVlSIe/Oz9yhg6AtxlOfMxsFEyXX1bVI4V/rN8VomyNTvZQk?=
 =?us-ascii?Q?oR8urS21fdk7NrbL9b5p+AwkAEQTKQlubTW3vW447ZbiLXvUWsxqEQUBlMup?=
 =?us-ascii?Q?XbNQ5kiuSsqzoogedYOd9xDGkACefh8+T0sOF1PDAGcELf39rNU2rdk72oDW?=
 =?us-ascii?Q?jsfGwvWtpDdIFPi/QAcjtJ7/g8kzG5B5KLxyZWgHQGbXCuMaBWpEGzlqdV7E?=
 =?us-ascii?Q?pye2vlCNnpmxK3ikBtilVbnIs+U4a/y4kWb7eRo2Jt8Iw+cS4+zR8tJnGJsf?=
 =?us-ascii?Q?1TXg153H9BcEousX8SM5Uma8HXpeRXkL1xGtb/xqVo3dbshdRWXJnnImFV46?=
 =?us-ascii?Q?/GnuMKMROM1u7+Z5V5dSFPtyKdfEslK4VsxvsJt6ZHqHI1YuEQmGViD/Ydy/?=
 =?us-ascii?Q?cA+8s1UHPcRfDtV7ePNZUoliAq3weoyJwcjJAg62QkrKlLJTE6/t2gjoNNwM?=
 =?us-ascii?Q?ERIrLuO+q5Tyl+1/+8agHkTxMAfF+EtUE68EUJ6wHKxM/PtPqQ3vYDXzsWYh?=
 =?us-ascii?Q?kOK+qzU/lPp0L7CBeEIWLSWuAQy7VQAty15FwdRWOuDxqyyVEoQfruhDDLAl?=
 =?us-ascii?Q?XpMmb98+v4OvZO5Q5n3Ftb9697hAGNr+vgb934s3nj9OgDuB8SUof7CCqYhm?=
 =?us-ascii?Q?3EKheejcX1pQx+gLDejqCw8qHr+mijPiBv+0BTzkDRGDuTpxBtvechLOOvhS?=
 =?us-ascii?Q?8L3VYhiH1+wxKCGK6gPWgIRNsr7Hm0k4ReVKFtH4ZGhRQ6CiCa2FJzq66MkH?=
 =?us-ascii?Q?6aLibtPlC0RqPDPa5uYXkmyR4D3o6UhVXRGl41Se5fSVYBR4bZcPJChy2ipM?=
 =?us-ascii?Q?5tQTwJwlYbQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vr6bCwskqCT9xfEq5nPMsptLuG8RXi2hOTMCKkuu4TWuXGMMKTb2oAwPsFlA?=
 =?us-ascii?Q?A8XBfYCf6PXs3w25iQGyANpFcJxz9Kn1Ij1FD2gxbfkZz/04SYjZHbIYO3ZX?=
 =?us-ascii?Q?aqkI+aBc/WjcWKZKSQkS4jx9pfjZW+VVY9kVd+epKZn1nPiXdFRMx6yXw6M3?=
 =?us-ascii?Q?U4aQ+pHmOFMGvZAXRmP2KECsZymUjITN6kKBTNGAlYiqotlDoVULdc1+nnUz?=
 =?us-ascii?Q?etJ4mFZEh5bYh1Dxvo7qlUaood1M1JTjjAj/3qhmPYTOKFgeKtojQfY6bv4T?=
 =?us-ascii?Q?fy0FKRjXOo0Dw+sc/2KD1nOnZe4+KltUubSrgg/rG0EwKMpydbLM71BPENQe?=
 =?us-ascii?Q?vY5pgFuqJlMdg702DkGho0NPzWTbZMpUtW8ifYyrFn0rQG2D1dMGGeapfItp?=
 =?us-ascii?Q?FRB7Iuulqj+9BzI0HNcFhvBNs6XGoTQVGE6k/MmzfiwDKC99k4sMzB6A+sk6?=
 =?us-ascii?Q?93XVgyJdFTcSeEEucCJ/W35KuIBlkem2VayAp+cxW86Gayt7RvKfCBt7U10z?=
 =?us-ascii?Q?BN2up3eDcL3bCu/lKpS95sQ1Al0p6IAxH6tQx5o0p7lX4+giTcD0P8oUEoC2?=
 =?us-ascii?Q?Ln3GZbXzpw+2ucJnNVALcnUbi2ktK9NgLJ/H72YWIoPZxYNOFj9UzyUM+oTU?=
 =?us-ascii?Q?VqqXL98+Nx859dpFa/9xjyNqUGfg1phL6KIIeoFGHIzU7NdQwPAAT189h+/Z?=
 =?us-ascii?Q?ki8PndO6wT/abwd/Zdbjtgi8xwI9gNo6sXz4jaLYE/4neIu8TYLX/PKteWJ0?=
 =?us-ascii?Q?YQxvBje7L6Cdgzu5jlWRc0iyT74WpZzZgwKuQr+fQ22u5zl7tnujQiqDSCFw?=
 =?us-ascii?Q?xkyK3ONukXUos0ihOICv4WSHVuxvuhyxtIDG1K9MPxOb+fPJKamaVkaZyelY?=
 =?us-ascii?Q?MVuAxqgoz2RhjLni1m1G72XBI070ldQwWn3PqitCIgSB7i94K01G60PAHkQh?=
 =?us-ascii?Q?DYV1fxsvbhtz7akdeiCrpJEHpSPpbw3pX7ujf2R1D9LM+mH4ts+qrhMJ1TVA?=
 =?us-ascii?Q?aaOY/cJ7bS6BXd+K24lPkgSuE/0VAFVL/+9gBKtDJjoovjkdhPxQv378yGvA?=
 =?us-ascii?Q?RkfWlxIpWrNsP6hQlEjS1PH+Qc6tReuiLuBaTcG3/gM0Zvgc/btTQeK82y2z?=
 =?us-ascii?Q?e+1kJ3BoCscqCvtYS2uhVkSPC5c8bq+8+xkoSpBLBCk6vRqnFUxnW+4ytvPP?=
 =?us-ascii?Q?Rlr1M2ZaJPVniEA5yQCxaKaRBaTGupznkGTALjXW9K34nRc3Jm5rwarXbA0R?=
 =?us-ascii?Q?3wRnHOOY1rUvHK3gU9D8VWlpBVhl5t7Iv2mqCzV1p+c6/vC+R2pdaIPyED3L?=
 =?us-ascii?Q?oSfYvI5B4JMhOAd/kp25pByQ2sRFCN2tp1MpyBXV3Bmj06umagGwTPWhMHrx?=
 =?us-ascii?Q?UpoCq2s6lyJz0+CQI2Tkp3pl10Kxp8BRD3HnkBtYpW3XObZcFEOxqVsqiXnT?=
 =?us-ascii?Q?6ZUddQtEtnZg8yRy0Iufv/buYSE8GG4xdp1Y7NPgtv96G61ydrBq24Fx3AkJ?=
 =?us-ascii?Q?6pZCZRmeYGRsKqyo5r1fpJgiwdU2LQ/1FsXSJF2KjkWKP1x3ymoFzMrJNJF1?=
 =?us-ascii?Q?QqxcBMJVt29g6ddxXRR6drQFOx7RIVp9n7p67ncixECRd/IA9g/Tt8GiOPYN?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ec0relkQ8d40JXfoDDDd2QIP2w64S2IHNROHyTt898vLtRkQyfDTMmfv6Gc4x8HLJyfOzUG+SMdMfIAF4G4qEW7pxorUXU3BSrUJXtfRwAoG+2uzYQx9ZgandPHfq4420Ok15WII9AB78qC4fBHyHVnwKxZ+8eVXdNC/5PCxvkieS3Wc01/r0LUKTG0ML6LjUUtUO52bSn8T2PNxugMfM2vlrtVROKYx8CXM2IdSv3n7Kd3ENgttmkxs2yN5omW/qE8tp9dXeJLrmHOJAkv8T7VV7U12mJUSZZ4ltF58cufHQHk9xO0DMVVePOX3PFCdenaSXe5tGVFPN4echZhTmi4FvOFQXrfaPza22Sa797qht3ZltsnSDhTtYgCZvldPFDutTLae41e7S+pUcloN3FVv85tSvQRoGbD9LuerFMWuxAN/YJprpJELlrnfPDTjCifvpdUSQyitzks+sKW0HJ7RDsUvyLMiJZ8bk7Uisi/L5PZIA2cxFW434gEoUFtzODRkYDHe2XHGrU4xIe5lJ8iEbjNonBU0KbKH3F2OT/94fo4A/cUtm0ew1cYFeK85PhbZwm5fGtApl3D0/5PSghTC6pPE4cqLr/m70xWUwS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efce62bc-46d2-4306-e36d-08ddcddfc02e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 14:05:04.3643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHzSQZpqCFXcAG8h0CCGMI60J/jsFEzQgsz5/cFlv8g0WPtmQXjrpBz+GKLWdnV4Mw3lHgRZZ5cHj8poi0E+zsP7de8MNM+0RL1UnWbJVTs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507280103
X-Proofpoint-ORIG-GUID: fANH-S5R6ZMm_25hFIpB0UmYQb1TSDkE
X-Proofpoint-GUID: fANH-S5R6ZMm_25hFIpB0UmYQb1TSDkE
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=68878395 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=VAqEK11FdZ_IT4zXH1QA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDEwMyBTYWx0ZWRfX1BcL24TWjWKu
 EJi1iVqkcVm2YQVNUHQmrlIA4AgPRyJbUbMaWBk6xBxvBh7kx5klttbaviKIDiUcrN4yc4m/NMV
 QavM7aBACatouKnEtPZOt2TlowgGQ5NBnBrsLqcmkgDC3tlfZQ2dgLSreruxUm9Op1noIWvAvzg
 rXTEewk1+MpXJqzjAF/OWx8WI99F1cC0q+zc1LNLCZdcWZa/P5hy2udemiWTVsX/QFif78BEUnp
 A37lDfsZEC8O0G8S9a0p/o+yyLfQwVwoTLFjUJ88lLAEHHqaV68XM2IH5lpin8Bl7t3YTlwYr4b
 fcWm79u3DxHDOt4APMwZ3Ll4MQCXywHGNjeUj82d9dtPa62KX+HZVuFc07ejqtSDINbCNT3zJyJ
 1yDmxscFumBrSu0dWeLdhEqpOPn6GeKTLJMPWq3Lj9AkufJjTw9AacW5u3j7w4FKQCDFD5r6
X-Rspamd-Queue-Id: B510B16001A
X-Stat-Signature: ht6z4mjkrqso6wgtsuzfchsxgtu7pxg6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753711522-660091
X-HE-Meta: U2FsdGVkX18q4QOmmX7JuAs+lBdHrDeVZwQScCBrq91r3SdeAs1lmb2X3Du3Y+8gzCk/R2b+76LLbp7j7CSk6jbxZy8gCYkhRR9wmarCt6isL8TD+CZo/clRe432Nsiw2r0o//T0hxBJGt5Cpa6CeLYNYtkrY0gPWP5qShYnBdFgy4ZHylA+lopE0a1EI2w0ZH2qdAxhwHWmzzmO93QxwFQZejwbA0BAZ0IIM7aVhUXwa+IOJbrM8rc3dLEGGvk79wp36Xmaof8+aT/VD6WixHEzF2sd+nMTmT0BNz8jrrcsqhJrwB0PsESaCl8JWx3Jov/kkFFjtzJAq9Y7RDYE3leovg7qHEbO/PSk/t9IUUHrXqNI+k5PP6yKQaHKYli9p7x1z7P1YdU9Jrj840z08iXIcNCikRMc3DTlrmi6PEo7nb+a+F/Uz9+oT9NPmTixR0+gLbW8GXs5if9WVGR+6N+vsSo0U6ak7eKwVglkCu1CQjR49P4Iw+YV4RH44V8pnTjoiGH+YJZLtJOH4iTkF99V5JEmyzr/STev6kmzQwMvwFQau3cW3BRLP2zML7TGKsEJIquw3pgoI8HLA5SReiJjnwljCbGOQUw3LkEE2pnP2nItph3rV/ndEYl7GMgWa9lqQKSwqFGZ+XB7wyrePKeJOKWTBFl5yNwPANcHbjwa9OiRIE5sAKGrbGlqzF3TMBZEID47EUXMkTHtxe/hEPBkwtfiQrOLdNdZR0X+jhcyILlUYxTQ1CWzANsfalPfH1P9xYNrRNEw4mrWECKnpRDW/UU9CDUq2VCf9PQmnShI2k70hLkNGn2mSv90EPskA8/8jRsYXGZrpCqMd/OzMtqBuSWTPgfCr9TKyM4UXDobS0Q9mNFohjGvuwENwc/gSxIpCMdNiRJd2QEWwzbBzgQAenmErhllWpq4qOkEHg+msGmndkBXOs8wcN2eYRYjLrzdnQAExR2EkXY6ias
 jk3m2VhN
 60hg4UdG9gdUB9BwfLJLqhgRjbgVDR83X5CUpwATzYIZesm7JYQRyzRrq6xXjnPvCwM0sYTTG5HYBEgFazKHhQUdQMVbqVMcedd5U+Hw60UecAznrHBhCHAh3SbeZuKZxz71N95ukK9SLDIz26mZ6RVnrzLZTn+6/DWQlssLClcMbOE1q2PdvrMDNBr1d0CzakPDuFuxIvBa4TZYvtpmTBKPbYl904CtMotr47R3K6wzn2RnUvOjhcz72AL5Me8B5EJM902aKA7JM3p8ZC2rN4YQrAet6xPiixR0Qzq3QNua+XHxtbITaG5CAm/MVz5JDc+uccuMgvSnaZW+zLwkHIrYPTqPdtdrw122REjgUqfEJ/Pugqc1JNrq3wTnTOj1/1HNyipPOb6SKmL+MVC8pAGWlivjdBcOyAt7cz4pa7hPVb4GRUg0d6p4HsmS01ZWr90vg6BQ6tuWlQ7FrLc/Qu3FKbXaDjVgoxH2MTxi5K+YbnTdiY5yAKdX02tpNpj7Iv5FmG3BEL3LX05EJssSdCD60LDyb9kyzKXH5dPFrulO8+BqbTYMeTPi9kMrsv281/B+n9b158o4MXHhgR/Ubapcca+WXzR6L7sUonG4zVQKBiq9wwbHvgSh025Kea8HnuIv2JUO27Fy+gF6+rYvEMSDFyeaotsoWpqLgPOuajm/KxihAZpIA8uuvuWwB9PcIq/VzrU/dxIr8VgfCXpIs8ImW+pK3kBJKFC9EzXH/6eEKS+8P1P5/HkjeHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new behaviour introduced in Linux 6.17 whereby it is now
possible to move multiple mappings in a single operation, as long as the
operation is purely a move, that is old_size is equal to new_size and
MREMAP_FIXED is specified.

To make things clearer, also describe this 'pure move' operation, before
expanding upon it to describe the newly introduced behaviour.

This change also explains the limitations of of this method and the
possibility of partial failure.

Finally, we pluralise language where it makes sense to so the documentation
does not contradict either this new capability nor the pre-existing edge
case.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 man/man2/mremap.2 | 78 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 11 deletions(-)

diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
index 2168ca728..cb3412591 100644
--- a/man/man2/mremap.2
+++ b/man/man2/mremap.2
@@ -25,18 +25,41 @@ moving it at the same time (controlled by the
 argument and
 the available virtual address space).
 .P
+Mappings can simply be moved by specifying equal
+.I old_size
+and
+.I new_size
+and specifying
+.IR new_address ,
+see the description of
+.B MREMAP_FIXED
+below.
+Since Linux 6.17,
+while
+.I old_address
+must reside within a mapping,
+.I old_size
+may span multiple mappings
+which do not have to be
+adjacent to one another.
+.P
+If the operation is not a simple move
+then
+.I old_size
+must span only a single mapping.
+.P
 .I old_address
-is the old address of the virtual memory block that you
-want to expand (or shrink).
+is the old address of the first virtual memory block that you
+want to expand, shrink, and/or move.
 Note that
 .I old_address
 has to be page aligned.
 .I old_size
-is the old size of the
-virtual memory block.
+is the size of the range containing
+virtual memory blocks to be manipulated.
 .I new_size
 is the requested size of the
-virtual memory block after the resize.
+virtual memory blocks after the resize.
 An optional fifth argument,
 .IR new_address ,
 may be provided; see the description of
@@ -105,13 +128,43 @@ If
 is specified, then
 .B MREMAP_MAYMOVE
 must also be specified.
+.IP
+Since Linux 6.17,
+if
+.I old_size
+is equal to
+.I new_size
+and
+.B MREMAP_FIXED
+is specified, then
+.I old_size
+may span beyond the mapping in which
+.I old_address
+resides.
+In this case,
+gaps between mappings in the original range
+are maintained in the new range.
+The whole operation is performed atomically
+unless an error arises,
+in which case the operation may be partially
+completed,
+that is,
+some mappings may be moved and others not.
+.IP
+
+Moving multiple mappings is not permitted if
+any of those mappings have either
+been registered with
+.BR userfaultfd (2) ,
+or map drivers that
+specify their own custom address mapping logic.
 .TP
 .BR MREMAP_DONTUNMAP " (since Linux 5.7)"
 .\" commit e346b3813067d4b17383f975f197a9aa28a3b077
 This flag, which must be used in conjunction with
 .BR MREMAP_MAYMOVE ,
-remaps a mapping to a new address but does not unmap the mapping at
-.IR old_address .
+remaps mappings to a new address but does not unmap them
+from their original address.
 .IP
 The
 .B MREMAP_DONTUNMAP
@@ -149,13 +202,13 @@ mapped.
 See NOTES for some possible applications of
 .BR MREMAP_DONTUNMAP .
 .P
-If the memory segment specified by
+If the memory segments specified by
 .I old_address
 and
 .I old_size
-is locked (using
+are locked (using
 .BR mlock (2)
-or similar), then this lock is maintained when the segment is
+or similar), then this lock is maintained when the segments are
 resized and/or relocated.
 As a consequence, the amount of memory locked by the process may change.
 .SH RETURN VALUE
@@ -188,7 +241,10 @@ virtual memory address for this process.
 You can also get
 .B EFAULT
 even if there exist mappings that cover the
-whole address space requested, but those mappings are of different types.
+whole address space requested, but those mappings are of different types,
+and the
+.BR mremap ()
+operation being performed does not support this.
 .TP
 .B EINVAL
 An invalid argument was given.
-- 
2.50.1


