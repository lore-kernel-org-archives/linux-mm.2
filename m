Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7264EC0489
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121686B00AD; Tue,  3 Mar 2026 05:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0056B00AF; Tue,  3 Mar 2026 05:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94F36B00B4; Tue,  3 Mar 2026 05:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6B9F6B00AD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:04:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E611B84A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:04:01 +0000 (UTC)
X-FDA: 84504315882.06.941BAF8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id D9E26C0012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:03:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZiMvAVmr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dmy2YqmW;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0ur+uTM/Corn5E5ZxmJVDEZN7uAC59hjHLcUU0kfbI=;
	b=ipXCCIG5XRVUGRqPav/9KqXHH8GyGLwWMg6FcnRSQrG7c+TkyzzfQy9n0BzpOiIKwVGxL+
	a9Uk+7Ug+E27j1BZwgTokWTdu8flFu0JjS5C3SUayDIYfd4NXRkmSfLj+1ie8pyuPWFk5p
	8Ls/k3XoaKQcKLLGKzZTWOfrKu3PF6U=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772532238; a=rsa-sha256;
	cv=pass;
	b=2ycX+N9o4Z/6ZNd82LDy+gVHm3tEhdHhGkTvbkbggTFfrBtzAHw+MRzg7DVgQD5kzz5flt
	Z6yOyL27UDy2lMVUkV+1PgSYskp13RR5KzuSaS+8FkJXkRW/h+SfGY/dBSYsnn4mJeWH59
	edQgnJ+TpkuI72wwPl/hqG1giSS7yjM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZiMvAVmr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dmy2YqmW;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239RJn73121919;
	Tue, 3 Mar 2026 10:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l0ur+uTM/Corn5E5Zx
	mJVDEZN7uAC59hjHLcUU0kfbI=; b=ZiMvAVmrAH8T/N2m+/mLrbWMHLS/4e7Qgx
	Gd4Q7BWlDp1ULfleP7iScJgj6uSr49kAsWd+uAUAmVm+92Hj5wfR2XE9coCaxu+4
	xNuGLmZYn/A3YXCWjiNu34TGbJaGn+zzGEHg0B9jegquTYa6TAy8Ew4XVy8g3O+l
	5vkIDyBUl7X2Nl25Q27SdcBAzr+Naor4PIXTA7V7XPTMz8dUqK0/3QWGdYdwIXY9
	0cigH+lBvFfbeKw0grtCnKeU3BDATnm1L4sWqTUwcogAsj/Uid4jh/UCamTVh/SS
	2MbrvciAhKoA+Y/lMfxRz7dIG45JmE106H1UP8KCoBp42b/hkgzw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnw1br289-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:03:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239f0bi037770;
	Tue, 3 Mar 2026 10:03:46 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010045.outbound.protection.outlook.com [52.101.56.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptednpt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:03:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJqM0+FGVGlL+xU1FVNvelTq6WKHBI/DMaXZX994baPQeIJwXYNDcbEC9KGna+p1RJKBzg1eOm+p2f+ZLeAVVpV+20ZbAcgEfH/iP4E0lJrnncFb8TQceYVANloeggZX/JzOuoYL9oYNMDZEhWJsum8nAQqR2cjlMcOgNCexB2DHGZGcMou0DNqvmhn6J0ETgmONUYw0yDwU3o7jVk8JAAxIXYoK+AKroUKOxKTrnM+4Z8gLsEIVWllsIpVdG7wSxQ+YzmaUDWdbn2jEJpyhsD+lI4ayqe10lweKK1vOtMRfanTTUVJhfxZ4cRl8API+rFUPZEbJdUQbF4VR2U+TFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0ur+uTM/Corn5E5ZxmJVDEZN7uAC59hjHLcUU0kfbI=;
 b=a4zBWrVDQJH/WfQ2+tC53D+ep1gZph8W5Q65hxade3V00eLElJJazQYUbDIvUkQ1D+a5EzkTXlPMqWuswZwkHnuYLJz7tIoiFqeNYX/nHDkYJyILY6x6zyRclDlSI67qCAV2TWtlLKH8DhSpsd0I0Fxq+9ss8kzXqsdEIrx9GcuNUhHsxTDUMuRQFSb4PJDGs2gHkmVvunj7QRjHutHN+UnIsRE05pthtAnF/2dthkuF6S59x+siclXBhAeJIld55eqlnvjqTSnfeEzsOmjgFJ9Ahid8elAS+xl1+mPZ3amgtMW5J4n3looD4DitafkYTEllOl0C41M88ztHcWDcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0ur+uTM/Corn5E5ZxmJVDEZN7uAC59hjHLcUU0kfbI=;
 b=dmy2YqmWm2TMmGRRtrEDD12ru2bMrBEnLdw3FdSIlMARjdQxWnXXVV6sNupK/Qg4hEEBDY2hcgBLA/hKSosj46y4MdiWSjrffZ4M8750w1AbsrH7smcl0Kaomczl7NrvAuhXLmIe/NOY+HLsLvAg4BQmVHb6GSJetaN27lBo2ok=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5177.namprd10.prod.outlook.com (2603:10b6:610:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 10:03:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 10:03:43 +0000
Date: Tue, 3 Mar 2026 10:03:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        jannh@google.com, gavinguo@igalia.com, baolin.wang@linux.alibaba.com,
        ziy@nvidia.com, linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
        stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <1f3a905b-c50c-4412-a396-967c73c7432b@lucifer.local>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
 <20260210032304.j4k5izweewouabqb@master>
 <20260213132027.wm75sh6trz7n24kd@master>
 <20260222005018.r4xum26tfxgnnvys@master>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222005018.r4xum26tfxgnnvys@master>
X-ClientProxiedBy: LO4P123CA0696.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: acb30fc1-db9c-4c91-5ddf-08de790c26bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	ga7lkkHPQoGnT/mtncQRgIoWSovWOGuZebGIJRgf8pxGCP6RfVGtMbUkQVQkd5fpXYpvVxL/VqrLk1fLbX1Y8PA9DVGLlQFdD9maMvFeQCO8Q1IyJYQWGe9nhQjw10/pVmFTY/9ySXfMAK2BOkOTM/RWdAHB83qIvhmYBOa4fpulU/rJEGkXLjFyv9DLMnpPnfGj9bUv8q6c7R8C38ULU4E3nXZLjlog01scF0HOC3QfkvzG8qRyEESpedMZX+xBSumwfC31Px6B7DWNlJpdLkECI9yA/srNk1dJveA1fUpsw3uBAVtP7hYbqfzmlaKClN4qf+wdoUVm51u91DnjlS0HOeg+5wWXaKWGubg3tGxEsgh7lJMkGL2gveH7r/oNOxFQKysBfzITctZdDFyGX746QNHPkBcCeBvspRE5AM/TFmgJygmt1Vm6bu7okvFdYoU6jk48ClJMlFu4DNsSfhYh2mUyceKw6L7KzylRZ0ML/qknfdomPdr94ATNYSU1qFNXAVLb93itwv8hvivacpcVL5rCFmZngXdCV5YHIAjmilnqgLRyDZoDZbdJAPjuaFXyjRCBQOmi3flD4SoZJUPu/jwoA9A8jy7YUPPmt7dBIoMG6ubFR/0fe8aZgadYUVu29yonGaWppY7yizEAvii1y97AUQ64Cku4V/i2HOhcpg6CApcW12teLIRvTglF3FNepLwVNdvU4XdMJ12mAnMS2emA/f2a8IlY+0W6Dzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6Fd8tW41sV7RcAr/tTyivePaVNY5bln6OLnjR9xWcJjqMi/NuZi8K6z46Xlk?=
 =?us-ascii?Q?7Nnf/gD+aO1fpzFlUeEspXftFwhtdWV4/mWiufPnMu+XleEKWAm+clS4LU6y?=
 =?us-ascii?Q?1M8Z4a+Iwo6bz7K1dukEzTH6AhYBTmqHNUiEHyaenkjeR0R/iL3zwjgo3M2W?=
 =?us-ascii?Q?+ntITysLb+XGGv3YrHFwo/lqqwPX7m/Z+JVqdkLVb6OtR0C3cc+al+Pg/98I?=
 =?us-ascii?Q?fQ0VY2K1+ZhuYtpIMzVJ79DVEw7YQqicuI7lbZ/GNfjjSUUk+S2LymmLwIGQ?=
 =?us-ascii?Q?okpHRwEvz1htKzO+nul2dvpeVeC4wNb1UEIbVHPTGqXZoU4Or866DBjOdzij?=
 =?us-ascii?Q?o7uoVx2j+rksnUSetVbEr67bVPnDsE8xUduWpoa8aF5/UenfJKi8BzAX2tKg?=
 =?us-ascii?Q?DuPToBKxSy+HCmqJy1QRvvn5SEoTwtkOV5N9mdWMirzpzqlKV5mScH22s2O1?=
 =?us-ascii?Q?9j8RoDBqU5fLfzihGWeZ1CUuXkyzv/kUlwr1idTnVHv+4/2oSYG36HV5m4h+?=
 =?us-ascii?Q?3Dus9HUnKLAMiUskfbEHqo8D/x1RXSVa7QRZLyp44VSYPd8C3WPbc4WxK2+L?=
 =?us-ascii?Q?gYLo6h32jblOTYYOYQtkmJm5s7YYChBmML3iPngHQ1UolCcz4BE7MQNVymTP?=
 =?us-ascii?Q?wtf4PkapDNyuOFhgaAL0ncws5zAszbmkk689Z7Ze/Mt76jSjmxABfq3vgogP?=
 =?us-ascii?Q?QFPeO2doQCYL/HWJwrK9VuEGPOQTYbrhM+BqQKVg6jw6o1WnLIUt4zILmldp?=
 =?us-ascii?Q?nKlzCvag1pek9oBCSLpEXPdmV/YHxo0V8whRetIF15QzOMR2WTbwEYNPcih9?=
 =?us-ascii?Q?mIXOsgKCiakfMSrH+Zyu/4Zf/PFYBkPr/2abqo6qs7NawlLUPeXT+Sz0l7H/?=
 =?us-ascii?Q?HwrQU9JEtd+vi+hK7IFMdD4YH0OW2+KDgJrh5zr055VuKnbMc3Domx7VISet?=
 =?us-ascii?Q?UPmO2bkWpoSZS3Z46YVd5aYhNlyu0oDgIPiJIaVtHXIjn2a6TuYcKedrAMgF?=
 =?us-ascii?Q?SaYXferKtFion7Lp7sDvSISx61vrqoRB95HOc3bj9w27x0F4AeKWliojgqp1?=
 =?us-ascii?Q?1crfTpd7zs2hcIioNMmDTdqIYzHiYkwH4UC0DzhOs2SB6RyIWeJuho/IJKTY?=
 =?us-ascii?Q?ugRZEMBbbfNT6i5ZQ/F5gMQpwphfz+obeftJZd5JQsEPvoSYLs93o3H1fKKs?=
 =?us-ascii?Q?Vh7NRex7iFe5hC9n9zSvVrh2CzzCTR57jsC5REsDTq0sDtPSWrcEgYn2TpOn?=
 =?us-ascii?Q?kNrAfw7d/ODnPrk1LAdrte+XDlpvek7V2ctqs/a2EzcYIokiGBaFYt53MY4z?=
 =?us-ascii?Q?e9o+KVR7KSOyw0Xg/r/r3pO5TMVOYI9bgaFXmcji/G6xWwtt8seEPUozQRo7?=
 =?us-ascii?Q?7KYrr3zQgBCSPnyMzKZ+y7LrizbItAjbGLHlGWgtxM+hDgS4qx2hzVNCM6X1?=
 =?us-ascii?Q?EyhdhbJjaJcyHcI13vaxpOgJ2MBdIvQDNt1vtTFO5pLsRtbX2u3Cj4fLPZ4Z?=
 =?us-ascii?Q?/orugcD23cQsHvfhI3DzD2aTipeGSSWM/ZNFseh9SjDL1rcUEJjYU4FCckYK?=
 =?us-ascii?Q?hG5YbCEHx0SjOcu5I3tY+pEtZxQf7X5v74SIUKku4KeZ/dJnBUlmz4I2QB3V?=
 =?us-ascii?Q?EfnMS1vSqrkl5mC2bFCetQnzUdmLN42wHpWvodgABcaw2DfIjv1JIZ08v21F?=
 =?us-ascii?Q?J3bgxO2f7NoxSFemMd6vVoa2PhMpaiyZIGAZRih9IVKD6QKfv46L7yha1PYB?=
 =?us-ascii?Q?qlv1M+YD69A/a5mpwG3SriSMFXBvnr8=3D?=
X-Exchange-RoutingPolicyChecked:
	MaKWrkGdOVNXjTCHfTMsrc02kYNR9708/ylHDEPX0cjfKIww+dejGGvAtgPXJ+WmsZ+ZTgnH3WPDtpoL84VjxTFWSHXy0SvaBQ9XZ3/GUjrJ15t0HMJeq3BnfVvS2oDqKCp5c3zqsRvdGytmLQeAJFh2GwpBVuMOOSPy8blsbacogrCpywC6xqyjke3gxq6LC67LA0MVf//hM+FP0bW+vgf3eBqFpqj4MsdIOdUY0ZuQuoL51QkMUfuYEBAnoECVE4DxMc97pvf2C9QqI/t2Fy1Q1QqvCibloaHx0KzVXCcVFgJsZwOEJ1mVTvD4SZHOV5178amU5M2g44DVSuxsvA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	y2M5o1aQJSNirVC4LWIvUe+AyNEbjOdCc8xCdPuUWTYEF+tCzue3B1EvY6x/fasqMPCPTXyMa9jSBaBlMzI5/eqSZl5FyLyZl9h4f3Tx5o5K9GarSWYrrj7QKJ+9VfzpTAM4Vtwln+B8ZZWYLaCB97fU4GM2uUCC5vlikAWBsh0J31+G/ZmNzaU8ctRC2WwMSM8JUsHcACTKJmTkHDUZ/WekyR8CkziPn7vVy9QWcymAdAL1GGEybPhJLVePmw0rB8/V6vfBCMjIyxhyyr3z3KAI/juV+7ICiesKBmPpvORcJieOQbzhq8focbUBNg6wcDz0evYJiPH/CE5k6eZv5Og2Z+VwKVl5L6IFS9Trr+K0awNbNVf6aIC/vu31xjwILoBqYHpkqsX+OsR1T0Ca/c5ONCBbjfVjHZLJ1zz9shMGEjhB+gWQzVkYIyUPtfb+SB+c8cqNQq3VFL5o+tOlBmSfarxG86zkVpH/ZErVCEoQNBWosnYj/R9139EipLPZfe5CGBGTc8BL3UjHBKk2Ac8P963zszk34zJd2rWcdjVu8sMbuX7n/bdc0is9BF1FGcrsYy7vodXOzQMEdBfZ+dq9smVt5myuxCGZ0C668EA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acb30fc1-db9c-4c91-5ddf-08de790c26bd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 10:03:43.1313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cUQhKx4KPhiN2M1HsTS+ln5gNCo0axxiRXPvJWbGU53qF/BqBfPds52Hk7EQyacoW5oTnGbOdQDUT8BPMiTJxBB2ckH9og6sQklNPzR3HYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=933 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030076
X-Proofpoint-ORIG-GUID: KQZ_U-i-UhZgX0te2blMRXnUqH8ltC-p
X-Authority-Analysis: v=2.4 cv=JPo2csKb c=1 sm=1 tr=0 ts=69a6b203 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=KFak1-8efCVT4wJju-AA:9
 a=CjuIK1q_8ugA:10 a=QYH75iMubAgA:10 cc=ntf awl=host:13810
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3NiBTYWx0ZWRfX4B1jzDASuu2n
 RuAxCQ6bJL8ztIeh5m7eTn1jNyB5Ocb/CQy7A7pss1PLkM/wuW89P3AaJEKp5nZfyHFT86vChi/
 RBxdQ83dPouUEIpoavNWgilA8hOY15zlW4Qq8ZoTCrC3JnTbWv3JnuHscSWhEH6pzZ9XPrlEqv/
 fUYd/+xiwzyA/kxpBobyD3cbBMzQpdB+eFoWVbKLYPXf4Yr1coBAX15yj80DdoL8ZO2xI22I3T/
 tQnlndzfHpEhZWcE7jWTmYTjQ3iQEnl0ApT6NiFZbNSPvU6PkHwsUza0G8LNlF/R9AZY5W6Dm3Y
 rh17bFIWbBg2pVOEypVjtlfIPhdgTmN1p4HKu/8WaU+x8YBQAw0WaHELZDyRaIiOpLfFRJgKIql
 a4dUUF0lU0rSoD9/sGmWEi4Pyvjn0kMJu4GlAMy/JmiscUJb2VoLBslFe2z2yUg3h+HKbcNVapI
 WGrKAbczwbeE0WEjaaAqw6k/4B3stMLznD+9e2Bs=
X-Proofpoint-GUID: KQZ_U-i-UhZgX0te2blMRXnUqH8ltC-p
X-Stat-Signature: epdqjqobustf8i35ax3pjxmyo9mzzu3d
X-Rspam-User: 
X-Rspamd-Queue-Id: D9E26C0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1772532237-431651
X-HE-Meta: U2FsdGVkX1+Vrc5ACoQXPH8H8CIotJojimGTfSr6ZdJDqeIhPTZRo14pYKkkSEBFiMDpJzaRBBIZkQXoV4BEYyjz5P2Qb4ldSm27AojJHd+6twDuH2j83YRHuGR9HL/K+ywv6Obuvevi9TIBkCnjee7FDutULZQudamUz9hlgjNbhjciY9NySWvWffW82S8X0jhfRD6JhsNYOrScNiDfl7WLkpH9AFyXFLoaF6eGpx5c3E0SXIK/KkPFgBcMl6O57V7ZuXfA6QPEEbt3cFv9HkW6P/R45v98eylz+2jGcTDqADW4ODzoiQJMEr91sQsSRkjS5LvstbMLC9hOFyiPbaowbYomK1no3GddLBhudVTIW/0i0QQoL8HLR9oscO/7IpKBAOij7BrV2wYSeUUj67jDdyR3p3mWfyJNcqr3AjaEFAQdh34TaBWi5eSz4md1W/E1nODwQvtNYoKvQZPGiZS2sZ/b4ffW7RKVNX8x8It4vO7cnjwAdppJgOPEvwXvQOFgmBIvOnksYgBNbIpkPKx/Q72z1IDbnLF3ZEbw/e76w5Zj7Nkb9DNcOoRWGDgV/W5A0i49MfGgF5atujaQmrR0JeQlgFZ03IC4MMt7CqVBJrFp9iRLpkxnoYW7XMtv8V3YOgUZLxcVrk2COAkymIozZ7kYqcjOducbt1COgG2RkW4DyqwRl/WRZLmIueU0ohbeLO+Ib4XR1Lj1UCL4bMWEwya68dzTKVXx9VEV+CdxGiybhTJ8jE8jnYNPAYOh4XSI/jWBPlhQyVbLHrB8Rx0SWcYAbuy6qC+LQ9LExtjqlU02f2LhrCLcx5wn60ngzUEyfE9kkKNOrrnyTG/XPupqkx9m41eNCbmY1PlyLQBilCB7LxSY/OPCZw41PHzJKw+ho2oG0M27Ctr5WUxoAxiBYz+rG9gCPfwszDjXWVdznBUApd21EBvvQlcy6UpcJso3AqErdNvLPBd1e2C
 AusC87oO
 rpLNlErUQT1wiCHm6ZbHMONQTvX65n+X7ay0XjypBt7FSSmzUZTSwyVNZkvMu/dO/L+kr5+0NhK/Jyy52FgrGKC3h8I82cJjjEqLh4Jj+X+jYSgBXbdNtkzgyD7VgEMWC83M/nVlXb/lDe35nvCIWqFkPwDK9Qds9aj6qat5C1QW/iTbOVcbYODNqFAAi6sOBDLBc4POpDeiarFR6TYmBcWrfevtzhfM0X5cF+sVP+hif7B9tSaPtlUMgeBdAVyrLGZzDTj2qc3f5j6fGhOMz8XBOpVF40htHGTzpfDI/lxXRd94TOksEP2S1MED2cZwj5GeQ/XaZ818CfsrsZ9LMZTpC8HwWoXdfydHZXW5Y8CWvCHSiiXwQdow58h4Jufa4Gx30C+wzLFOjmOZGDasCjntEbGezgI61HkKblwcVqeCx8WcQVlPtbhi/TAyoYFQ4cctqfkkbIPeMfVS7kdUUxY0krQD8kxXlkHzKllt1C71Q9Qaf31K/LbLKW050i0ltmtJd4TXmwoK47ML3IHCsUYY3QyfLw5LpHr7RcY+320yDIjx1Ak2gWq14lK4f5coahWc5+LEtdaH79SgcsdJAT5UgWLcay5RVlKk+PapVxGZ7GyAHbggrfAiBxEBa44Mj8leSgDZFQz1PIPuXjQ7nb/AfL3OLK9f5L6M4GR75mjMmBv88NfOlQ9+cYSQlFtyRUMK5MxHDqyqINmVShm/R3v/FDx0eYYTAh9Oc3OgAh5EDsa1amEGbQoQ3yp88+27qBnuQBnHHtNtMs5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 12:50:18AM +0000, Wei Yang wrote:
> Hi, Lorenzo
>
> I am not certain on how you prefer the commit msg, would you mind taking a
> look at my question when you have time slot? So I could prepare next version.
>
> Thanks a lot.
>

Hi, Sorry about that, just tied up with other work/had a few days off last week.

Will look at the parent mail now.

Cheers, Lorenzo

