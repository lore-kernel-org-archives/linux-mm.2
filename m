Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30339CCF9EE
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 20:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444C480095; Mon, 27 Oct 2025 16:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7BF80098; Mon, 27 Oct 2025 16:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB0B80095; Mon, 27 Oct 2025 16:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E445F80096
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:21:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A93541A01C5
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:39 +0000 (UTC)
X-FDA: 84045014718.08.50C0B9C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C7F0160010
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:21:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gtcp7i2T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="vvA4/Hp1";
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761596496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bknBLPBuO3NbGUhn2FA2BsLXM32BZbsWn4nAoGLowlQ=;
	b=3MrZMigP2XT1O8XFr+82J0UIYfnLHpyfvO2kqHFTaqZOYXY7uwpikVxfPMfCQMKbaVYsod
	kKvZXEbofB1l6ZCzlQvDRE7b/ngERdrmupW4wCCZvCA2/zaCfvoRaCRlDJ1UTFMC57+kpZ
	bK0/iOteBq1qz6M00/lJxuKYyI3t56c=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gtcp7i2T;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="vvA4/Hp1";
	spf=pass (imf08.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761596496; a=rsa-sha256;
	cv=pass;
	b=8WRyREtRbQXFhro+7dE7CdMnZfX+dUd3eYVZd/XA2cdWqd3btEwI0viUEM+InvCluqQMxw
	+Pn3K5OD+tVGsdbGBZLPZervgaGgt/MWYmWCeGyeFVPNg/W8dwuEv+/6Vj8eyXQtZv/8I2
	n7lMifgd96yN+5cdbObJ3N0gfs+MnVU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59RKCgRo008134;
	Mon, 27 Oct 2025 20:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bknBLPBuO3NbGUhn2FA2BsLXM32BZbsWn4nAoGLowlQ=; b=
	gtcp7i2T3m09u0S6yA+hmFlmaEmgoYbCmCy1ygMFRSEQ4AL6sPDRmYxXS/huBiEe
	G+j0v3NSPUNU7DtB3i5pL1YCOiBMJ1frLW+4YBza1CNF4BYJoiOLzleeOcrM7kX8
	2lFj0zr4RaqprZnNWmoXCbjoIL4dRUKi4hDu1Zt2Qks8SqiaQFtF7/AjNZ/44/a6
	d7X/i54SU3nM1QFWTIeG8+YuLEGihMKcyww8JANFETSIfLo+mkiv1fE2ZcEOnFht
	MAV0Udf4K9HrcD6+PeFi4rCIW1caQFpHmzvT0W9GQsI7/gOv2sEF2Z8xlz/SsgS4
	EfZ2gZOjyEdr22Qyrz993Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6sv5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59RIu8Lt009148;
	Mon, 27 Oct 2025 20:21:14 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n0eh5a6-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Oct 2025 20:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=naCHQb9t8tQ9lVR/JOvc/1sjJR5jVyQOREuikCNTExFlxz1R4rCObwRp/KegdRfn0wOt5TJ74lHJlDMr55HWQ9M6HTBu6dYLGsXONI/HcFNoqo0bu6qc7d/5nEdc8Zig6ZINGRSv8m4aTb6A0pngZg3S/rwXTV6RMRpneX9u9gxP158SBUj/C2EGQ12l3f86deX+ysaX7cFXzTspOfdq7deoKxdriiBoPP5TwtE/Qqpk8Sdd1JyT6VU7hBI7Y6oNleAko1h/o0TBpLNMFseJh6CiZpJb087WLOyiKVysezwl7Vyc1wceKi+5WL+cm3K1aTUfVEcGXf6f1ASDzvGzxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bknBLPBuO3NbGUhn2FA2BsLXM32BZbsWn4nAoGLowlQ=;
 b=j/xydjzI0qVrKcdDgLtJ1RGh2oaiQR64531HCB+Mx8Ud0s9b9kFy/jUQLoeYdcIp3X0ueqia3Y9uFrOhiXK3q3oj2dlQFRWsE/neER/6uaEFdmidKJgJPznYdKDD+ZDvURB3WRYFSmV4u9mx7Cpzi9GO5uNl5AIG8Z85f+cbUiids4dIKn+8bNw9GhQ5W8DyLSrvzXgBZG0gHQJj1G1AXVUbbXU6N98/Um2osxQqmcYRqhVFGwq6akcJDSkOVUMOHhwvB208IIOOKbJPtfrFRGgG8yC/T/DX5NZkgsMDl3xlPEuiHItc16u/pRyhEyOP1ccc1+pg/iQdRrk9sxEpXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bknBLPBuO3NbGUhn2FA2BsLXM32BZbsWn4nAoGLowlQ=;
 b=vvA4/Hp1Gb9Fak5wybD40lflPqEBz3b0KOUQFTuDIV7hg0nRLJHv8gKkdKXMVTHlwW+ZCTIke/tMg9BWJ9K8lwPh1s0P+7XMaQqNlla2SnGbTisYx0bvKWWJ10Mw3mSG/MNrWDPVofsjz5qtf+mkK7BnmXpK00AxbNUMbv9YvOI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM3PPF1A29160CF.namprd10.prod.outlook.com (2603:10b6:f:fc00::c0d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 20:21:12 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 20:21:12 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v8 1/7] treewide: provide a generic clear_user_page() variant
Date: Mon, 27 Oct 2025 13:21:03 -0700
Message-Id: <20251027202109.678022-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251027202109.678022-1-ankur.a.arora@oracle.com>
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:303:b6::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM3PPF1A29160CF:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ac1f2d8-6273-416d-8387-08de15965f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QbnZPgr1pWtzfLNDB1tsMY5jWpNzutA649vJgNCJDifMqflgdrn5cee7h8C/?=
 =?us-ascii?Q?lazqguaz1+HuUxiwjHt+P8Wj8tTJ0nhEfHe50orSt/4fkEsdkO3QZ956Mo7c?=
 =?us-ascii?Q?I2G3jAR3TdiapIovbcenBfdgI53uOjn0mZbRe385Pny0FCe/ZApHvgZbtjyq?=
 =?us-ascii?Q?FbKNTWRtysm7KmEz1wFDd6nsjD5tIVR/8y2jBagtIfpC6+n+e22TllYcvpcB?=
 =?us-ascii?Q?JyW5DmJl4XNdGViiMnxoXNMXNsM1fu9jf0aZFz1B3F8oyeXt9nI1PW4XEZud?=
 =?us-ascii?Q?FhS9UatrH4yd31k7PBGeo5aGOYU40FO1puRUCiO9hAcTi2z/zb6xFokZtVC5?=
 =?us-ascii?Q?c8GT7gatCglgX42CBCNey4fRbHz6vk+xfvbdgCPj0gx9IaETL7zNXaiNgDYG?=
 =?us-ascii?Q?V4kFd0BJdtQZB1+bbx9l1AbyQy1MSO/SodIFeNthppLpluWNFJ1y8XdZo+at?=
 =?us-ascii?Q?MaZwDxnXJyjagN72lACRp9jpC5q+u0uQ7oYpRdOsI1jgZow+jHjSEnIL3dkm?=
 =?us-ascii?Q?QMoaNwHxv5RsRcTOTBc904XwE0AGr+kFpJxl2Q9sZzdskQ1U2BzkYQAPS0yZ?=
 =?us-ascii?Q?KRkg9EMIU1Mi/b9qFLCljcafdQRjWMQpcc93BDBB1oUQF/m2o+NKbf9P6tL3?=
 =?us-ascii?Q?44qft3eaPY0C6Uz8zSaPZBARJOjiPCH5Sx8mhSF9X5CWdrNwI3inWds2B24h?=
 =?us-ascii?Q?uTz1zpUQQix19oOiPtkx2OLzNa6rM0wfZIbd3gBeCV2Ti91K/dL9Gb04lOSx?=
 =?us-ascii?Q?zynOYtDdFg/pIcq1X+SF6P7MkvEAvJpOEtpAuo33snw/4sMrzgqkGBNequuQ?=
 =?us-ascii?Q?LQAB2k1fFNUQZiTniV3Y3QDvu90nNroDrZ5M3/tMRf7E2fCQPGy+cFpPn3Uw?=
 =?us-ascii?Q?cTUjoLoPb/a5YLWk6EEgg1IAmg1Mvk8TwbCv+n+Cihv1oZdIE1fMZrcWyCXl?=
 =?us-ascii?Q?3c802LldrkeGlkenzXvniQu/FFm3JhAD83onV36cND/8U2F3+60TdcZfg3d5?=
 =?us-ascii?Q?lDZHi1wAFxy9pbh37KAiaAgg9ZSu3xmVyxAeOvFWPaAuoD2Lp8C1/tiG/WW4?=
 =?us-ascii?Q?2px8W1leuPpE7IWZ4djzKJwSMWtK03fWlIBT7aI4ChLLbSpSQeOtHRIascW8?=
 =?us-ascii?Q?/nNqBRptAWwqgCm0eUI1fQMvmQS2AZTombSRn5GVC44s/cvDF2CKcbAyJ0lk?=
 =?us-ascii?Q?K1RC/O+3telld5ZIz2quZzVJU5j219580nvYhxDmL8plcgSizz/tgYLl1Mrw?=
 =?us-ascii?Q?EYEyMeGYjAU+22K27LvSRm5wrIZF2XbjHMNDF2t5h44gwIkb2YtJp3sGgRq5?=
 =?us-ascii?Q?ndhHH2hYp5shuPPM76O4wj4PAtTr4WGi3dZR9txMJMKPudMBEH/4RkuIDqSB?=
 =?us-ascii?Q?q2BtJi49Q/KHfE8eA564n/aj6nG3asDDB4iOpyAiNanXbnCOCWci0IasLm6m?=
 =?us-ascii?Q?VGC88t6RYK0eT1IU444APmqZTieQHGwG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ewvaYDbZqhgXQ7qiavsPyRqOa1Cf60FtjVjWoTzfGzgwFG2igYR6P82mEnPw?=
 =?us-ascii?Q?+JFIU9ime4HPhb7DrkT7SDdOc7qdBf7xEZ11qBvdp0yxubivlFoqxJiMXF5m?=
 =?us-ascii?Q?5kEQ7aNKLboL0ugSdX+LhNG1Xmuilov9tPZuuMWTO2SlKnaWHGFx+vM5J1BO?=
 =?us-ascii?Q?72DYte5/S0ejxZBGmJnmlIP5CBMwXb7qO5SwLVNLYGDMtECBKTQFGOr1SCnX?=
 =?us-ascii?Q?itkGeGURVtX+nF+DP3Jx/GwguJPZiuI2llk4kxVA5tQ0WXdehJeNVZQOLTNl?=
 =?us-ascii?Q?bwEGAcwZVRGEYfS9taHRu8chB4QHCY+LZcjKw7AA4QnBKxLGcGS9l9zuqIaU?=
 =?us-ascii?Q?Ve6A8/4OqYZi6mhw/3xCzd7wQwP29mXh56yMkOe2E76ewZIoXAEIS882SxPA?=
 =?us-ascii?Q?wJgx5YexTYM9fQQGG4Xq8hc6zRpWBD/X7AYL9vvdwG/K8axwTdsNIZbpP08c?=
 =?us-ascii?Q?S9DT0T7kRHMD/DM3TYsuO1NTO4wa2P5BqjBqE98JIYWIajBm++D4zfeD2ejw?=
 =?us-ascii?Q?Xx6btPT0eUpXcY3kVTPMzEiAZ1RVTScVcW9YJIZb9E64B0TNPHDmsa5fFwP7?=
 =?us-ascii?Q?PvhQ0BKsy34d+NSpNQ4RVuOrbRfRSRjwLM0PWBPv2Gv8ob86JF8N9SPCZzGo?=
 =?us-ascii?Q?uReLc/gDQhy4p/OypcLxwpiMERAh8cgCO/R9ELkoxKPi0SY42+CjHyjrjdDW?=
 =?us-ascii?Q?XgD1bBtMUcJgLKBB9ppix3FoRHHXbUf/JKOcqlV/zOqTwX2v45GKacs89n2n?=
 =?us-ascii?Q?SWxbzQUxTT835qIa73hCqvbH1bY1XuTTpKkZQyjOPEDHP5Ntd/sJT+YDEUoP?=
 =?us-ascii?Q?FDQ06UjUPR4BN7WVmMBkFbkFRiLAcX8KcP97qUvMZq08ZaL6uUNV7ppRaSFv?=
 =?us-ascii?Q?ssWXuwqoC5BfPYC6KWY4cn9e3ruzfA5u+diNzVqV/HiHcOqUc0uiHW7NrV2Z?=
 =?us-ascii?Q?+AkuwIVBOBysP5CMV8E4KI6qRSdvRIdzu4j47yJQK9EsMJcgMFH02kMn0Sv1?=
 =?us-ascii?Q?jgWqIhEUlmmpt3GfbQbnPxISozdojiSZMsRYfXu1+cbQ1DDgQQ0/Dyeya3h1?=
 =?us-ascii?Q?7IhAWOX9CJpoPf8LT4anCJBMbDALdqoLr0WQgo1VCC7xn3lZsSPwXHYp8dGS?=
 =?us-ascii?Q?aNDpVtoOR43wOXJXmXZyBOuxRONf/V9lBjS8ijS6uwbW2S1a244HDPy3gy48?=
 =?us-ascii?Q?ZrtHooZAC+yGw7YPVWtYMdn6DhHsKxVGnPvG5EQ2odWpa7vjP8VVD3Bn6Aet?=
 =?us-ascii?Q?wDk9QaBZHPP6w1UsGN/qFdN63oic4m/f9krfYVkhBYTLLrX+UsGHncNb67/3?=
 =?us-ascii?Q?rlvBoo29OFxNnlFxWBFRyXxoX/CII4aBQnFXC1y83fZRHtIY/fnLE/d5BN6z?=
 =?us-ascii?Q?9t5LzAWZASrplVpbqFFBQwXYdRGY16PNe3WCioGu6f5UOhL522WJJXg6jaa9?=
 =?us-ascii?Q?hoPfcv7Tgmd3qGGpnT5RftLzyIICdzEUgOChQ+zX78X+qSSOWahnC3tOMIGc?=
 =?us-ascii?Q?fHpN7xEOYX3Zd7bPa8svkLUd/aY3u5xCmTcQQhn+aZ2WgXcwTONM1/rSy/I5?=
 =?us-ascii?Q?FFQspfngO1Ys3uGDge15Dp/f7lp87hLVT2cJ5Yi5Ea4ZASh6zdB/0qrwIAtE?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DKmgAfzWAt5YMNcKHXXUVxox33vncmZCTQrsxLKDXrcYK5ML/DqH35TtyEFU8je1LU5nNbkrdErwt9320RXLzAZlXrBLxHelWe2BEogPoWc1LRT+7YlCnWnwu4pX0mpep0HMXGr5lqeZlcyHDreOis9Owlx5wmiRQBC2i/3s0DuGG2jg/m4nptQkSE/EOCJwacjC/NIpnvee8TJjwLYtAZcYms7oLPAjmiPOE/8ceDpFFCQW2vzMd4sWjxBfpjvpQ28hB2NBRYwC1bP9k62Fsz5E0L+sDnr3Ldz7zmSqC1a31pr77vZ84Hmyvxg3oVwInChOlka6XcmRfEY+izFwwXARBie2R58sRQJ/r4gg6QQzT/Y68FFCVM3rIfnkmEKrtaXpq/2ltmfiOdgHVu6RoBn3hB9WSi3aJMIF7SfM7CW5V9cLNgmAaaADFUhOLoQIiRYZ5VZy6WZdDtmXys/RjLf/rSdkVQ3iX8zWgn+Yef9s/OPWT/QoO/CQ7+XKwxYwEkEafS9/WOe0Xi1EiYzZWwtMqOymvBDnZkhY5rN//7no/17g6pKTwr9aupsZVskTvrESlKPQAUkkOb29Z8RIX31iKPf8etpkgk3HWwWWEW4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ac1f2d8-6273-416d-8387-08de15965f3e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 20:21:12.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qWdD5Uda94wSk2rjaULVfnwRMiSHK9bgr86OT3EeaSO7rPNChxAdgp2DN1ErEI1/D981saq++wC90qLa+NgpBCyDdNOP7Ormj56JLCtFRo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF1A29160CF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=914
 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510270187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfXx66Km7WHdgBJ
 kkdlRSiPhtj9RXHqViaxTj0Pe4RDMljOp5ZkTRPic2To+3zmT/aaV4LzPASvd1Wm/zDoX1sSI24
 isb+OzP26r6yd3SE3yy2IckvQizXdjPAV7X5TfKGnfWB8w2YEb0xXpMcaxdibdfZSMxWMBzEJn0
 nTUZN8+/QyoA9HYreOv0rXQjAeoP+gP7hSSh8J+G2ZZQ8HxHbDVZrtiDT1N1UN5TfI863KW8oY9
 6Hx54Xqam2QGidWdRHiGbJKraIKtinOXbqgHNrBytSHUbL/btNKvujiHFwBKcNs3QAePMDZgxcq
 X8JxuI0pxSXTCfEfsu78fJ+QArFZ2Bgfr2F75LAAtI7V8FhoFDcq8egnkv92tI9uRd4LJ28E7aa
 sJF0tTnT/GY5ESc/szAAfG6WvH12Mc2tWlVf31DpyBPuiJZCk/w=
X-Proofpoint-GUID: 2ztVNufoXELHgXCTu1cgWeMckYVWkh9k
X-Proofpoint-ORIG-GUID: 2ztVNufoXELHgXCTu1cgWeMckYVWkh9k
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=68ffd43b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8
 a=LYJYA6JT04DgVVByVqkA:9 cc=ntf awl=host:12123
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C7F0160010
X-Stat-Signature: 6rbjoqg59fjmwhd58xns5krf6ie9xkkx
X-Rspam-User: 
X-HE-Tag: 1761596496-602190
X-HE-Meta: U2FsdGVkX1/57Q2jtFC+llIm9wojSGbh1ht/Pa6+oVFgvjpbtZ4a0Utsgc+DaT9ZelKVx3b3E4SimJ8GtUH2QIjwvdVWmWmFrq41nL/35f/J7XCJepWewxM/DntiX2crDiKBOjvov7ybLiwUJbXrZvNZlojEBZREmH2MuaNHDixJnQWirV84pbel1AN06po+hA8srm7gospxBrr7YS1nYl+7C0lzfOUhAw2LWYXRdajvdx/eYgrlpmFpqunMre9ttNML5BsnelTmj7mKsmuS1EDLFSb5GMAIjsKUOJW3x7Cvy5jOUTZAKOns6Gg25jLA6NyGJZoYEjG9XKurIyGYamBR1nWYEiyZ5ogE5vy9d0+Feco7xpAZgURt+Xp3YmAwLRW1ApnnDfEDzfccAyuwap3xhNL8iIbERazjuHn5XtV4YDbWCuRbQNB/rpd3QvMdaelJ+5gv7ySBPTssD6M2F66i6aNf4qKv1n8+edOEBqA/UJfu5gTFUe//ovFVj9tFmDv74REVn5tAqrqQ5NrijQhzGnp4dBM3N/7gYlf4Y96QSWWkAgKme7+2iCadXw0tjqr8b3XFt8Dt2p7c72jzwngRvlCbgqH05+8HHI6nHaNe7Ausdx9GJIHOr7pDZbkLQT6B7dy6q4s0HDrRnxVVaeevvN8t6kmekwoaqorTVLLfdihtjc9haKAWTRu5JYSQMRBsjAHXc1+wWfTYcGrKN1v5F2Dqn3rNDDKPXbYo+VqD+Mh+UozDwcfEyZRXY7kTAjhfOVB+hTJVxfZzAcU6+dc6Wib1XmjtIXiMiYnQyw91pkXAW0uX6QCLqVkuaUelHJp+gLnOS5kkyvVvOtj6O4HIkZ2ElqwnM7QRzoaTX4Yt4XSHbzHGplbC+0yjqUoamI2r43dNg6JLxWr1rbvXR6tcV/PGPv1+aL/aG4ZsPtRDB20tVOQ1Yf1Se6TFAehxjYh1Pl19BNeTHr1nvPk
 iy8s0jhk
 PIxDwqQ8AQ/5D56dyrO7qrvrNNVwvzvnJ+/nBVyyXoM0WYHZugYMZGFqhbu3Mp0O8XTU7s+xTWst4a7Zh4pF3IO0MTDXAFxprw3W0llbPgj536B8im279j2dj115v6+79HSHZzXE6iEdGTMs8TsMrdy5eMiTwfpcxE31/pWjQIVVDdcpUEjog1uV++7mZFI8laYMgLF6A6pdzsfOTZ+nkJ9xzVDZgsrSRyJaUJI3MjbkPvPfy8vCKxVSYtPtADWtg0M160Or3HpRUdJdqjk3RmATtB44J0Fjls77OwjWMiRCeLCUzdmYQphox+6KnHKpqsZKVDLDtrgUOjt9fDNBdQQ1ZbThs/RnIEXkkxsAIh6L8MZhiqpIZO6EoTu+GZJnkTARZ8C7hplGYkg5tpHnciRTpDcYRGjn/vCC8lfZLv9TzTsKWMlSwhNdj6Vlig22MZw1hJ/f4qBg4iKRqHcYiHVznFejDVjlwTl8Httw9Auk8m54PIk2oedtPVmRrRLycq6f5yQ3TBJDe/O0rSIz5uO/LMlmcJ/HVvNhi23mkFDoO1QBzCvbKXLavleOsXcf8NMkMEbV2DxUdcKFYjOLqbrmZCYW3ThQJ1kGuBK3jaujI/50sQdRkAfijTKCH1LjAjjO10HiknYGJ/D2K531uVT6OkNtBxzzwkRNf+Yl7ycyCdvXIBLnB01pB/Z/mv+pb5lc2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's drop all variants that effectively map to clear_page() and
provide it in a generic variant instead.

We'll use __HAVE_ARCH_CLEAR_USER_PAGE, similar to
__HAVE_ARCH_COPY_USER_HIGHPAGE, to indicate whether an architecture
provides it's own variant.

We have to be a bit careful if an architecture provides a custom
clear_user_highpage(), because then it's very likely that some special
flushing magic is happening behind the scenes.

Maybe at some point these should be CONFIG_ options.

Note that for parisc, clear_page() and clear_user_page() map to
clear_page_asm(), so we can just get rid of the custom clear_user_page()
implementation. There is a clear_user_page_asm() function on parisc,
that seems to be unused. Not sure what's up with that.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 ++
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 -------
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_mm.h    |  1 +
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_32.h   |  2 ++
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 ------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/mm.h                 | 22 ++++++++++++++++++++++
 24 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 5ec4c77e432e..d71ef845deca 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -11,7 +11,6 @@
 #define STRICT_MM_TYPECHECKS
 
 extern void clear_page(void *page);
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
 	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index 9720fe6b2c24..cb4d69b473e6 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -32,6 +32,8 @@ struct page;
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long u_vaddr, struct vm_area_struct *vma);
+
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 void clear_user_page(void *to, unsigned long u_vaddr, struct page *page);
 
 typedef struct {
diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index 7c2c72323d17..e74415c959be 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,7 +11,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 /*
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 2312e6ee595f..0cb8853c0af4 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -36,7 +36,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 void tag_clear_highpage(struct page *to);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct page *pgtable_t;
diff --git a/arch/csky/abiv1/inc/abi/page.h b/arch/csky/abiv1/inc/abi/page.h
index 2d2159933b76..08a37f5990cc 100644
--- a/arch/csky/abiv1/inc/abi/page.h
+++ b/arch/csky/abiv1/inc/abi/page.h
@@ -10,6 +10,7 @@ static inline unsigned long pages_do_alias(unsigned long addr1,
 	return (addr1 ^ addr2) & (SHMLBA-1);
 }
 
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 static inline void clear_user_page(void *addr, unsigned long vaddr,
 				   struct page *page)
 {
diff --git a/arch/csky/abiv2/inc/abi/page.h b/arch/csky/abiv2/inc/abi/page.h
index cf005f13cd15..a5a255013308 100644
--- a/arch/csky/abiv2/inc/abi/page.h
+++ b/arch/csky/abiv2/inc/abi/page.h
@@ -1,11 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-
-static inline void clear_user_page(void *addr, unsigned long vaddr,
-				   struct page *page)
-{
-	clear_page(addr);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *page)
 {
diff --git a/arch/hexagon/include/asm/page.h b/arch/hexagon/include/asm/page.h
index 137ba7c5de48..f0aed3ed812b 100644
--- a/arch/hexagon/include/asm/page.h
+++ b/arch/hexagon/include/asm/page.h
@@ -113,7 +113,6 @@ static inline void clear_page(void *page)
 /*
  * Under assumption that kernel always "sees" user map...
  */
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 static inline unsigned long virt_to_pfn(const void *kaddr)
diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index a3aaf34fba16..b83415fe4ffb 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -30,7 +30,6 @@
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 extern unsigned long shm_align_mask;
diff --git a/arch/m68k/include/asm/page_mm.h b/arch/m68k/include/asm/page_mm.h
index ed782609ca41..10798156121d 100644
--- a/arch/m68k/include/asm/page_mm.h
+++ b/arch/m68k/include/asm/page_mm.h
@@ -52,6 +52,7 @@ static inline void clear_page(void *page)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 #endif
 
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 #define clear_user_page(addr, vaddr, page)	\
 	do {	clear_page(addr);		\
 		flush_dcache_page(page);	\
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 39db2026a4b4..d2532bc407ef 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -10,7 +10,6 @@ extern unsigned long memory_end;
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 90ac9f34b4b4..e1e396367ba7 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -45,7 +45,6 @@ typedef unsigned long pte_basic_t;
 # define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 # define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
 
-# define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
 # define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index bc3e3484c1bf..6b41650c27ab 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -90,6 +90,7 @@ static inline void clear_user_page(void *addr, unsigned long vaddr,
 	if (pages_do_alias((unsigned long) addr, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)addr);
 }
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 
 struct vm_area_struct;
 extern void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
index 00a51623d38a..ea9cac9e1bc1 100644
--- a/arch/nios2/include/asm/page.h
+++ b/arch/nios2/include/asm/page.h
@@ -45,6 +45,7 @@
 
 struct page;
 
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 extern void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
 extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 				struct page *to);
diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index 85797f94d1d7..d2cdbf3579bb 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -30,7 +30,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)        clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
 
 /*
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 8f4e51071ea1..3630b36d07da 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -21,7 +21,6 @@ struct vm_area_struct;
 
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
-#define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
 void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr,
 		struct vm_area_struct *vma);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index b28fbb1d57eb..da56e7d42e25 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -271,6 +271,7 @@ static inline const void *pfn_to_kaddr(unsigned long pfn)
 
 struct page;
 extern void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 		struct page *p);
 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index ffe213ad65a4..061b60b954ec 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -50,7 +50,6 @@ void clear_page(void *page);
 #endif
 #define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(pgaddr, vaddr, page)	clear_page(pgaddr)
 #define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 9240a363c893..6635ba56d4b2 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -65,7 +65,6 @@ static inline void copy_page(void *to, void *from)
 		: : "memory", "cc");
 }
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/sparc/include/asm/page_32.h b/arch/sparc/include/asm/page_32.h
index c1bccbedf567..572f62619254 100644
--- a/arch/sparc/include/asm/page_32.h
+++ b/arch/sparc/include/asm/page_32.h
@@ -17,6 +17,8 @@
 
 #define clear_page(page)	 memset((void *)(page), 0, PAGE_SIZE)
 #define copy_page(to,from) 	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
+
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 #define clear_user_page(addr, vaddr, page)	\
 	do { 	clear_page(addr);		\
 		sparc_flush_page_to_ram(page);	\
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index d764d8a8586b..52213c92ee94 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -43,6 +43,7 @@ void _clear_page(void *page);
 #define clear_page(X)	_clear_page((void *)(X))
 struct page;
 void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
+#define __HAVE_ARCH_CLEAR_USER_PAGE
 #define copy_page(X,Y)	memcpy((void *)(X), (void *)(Y), PAGE_SIZE)
 void copy_user_page(void *to, void *from, unsigned long vaddr, struct page *topage);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 6f54254aaf44..8cea97a9c8f9 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -26,7 +26,6 @@ struct page;
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct { unsigned long pte; } pte_t;
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..416dc88e35c1 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -22,12 +22,6 @@ struct page;
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
 
-static inline void clear_user_page(void *page, unsigned long vaddr,
-				   struct page *pg)
-{
-	clear_page(page);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *topage)
 {
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 20655174b111..059493256765 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -126,7 +126,6 @@ void clear_user_highpage(struct page *page, unsigned long vaddr);
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma);
 #else
-# define clear_user_page(page, vaddr, pg)	clear_page(page)
 # define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..683168b522b3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3872,6 +3872,28 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef __HAVE_ARCH_CLEAR_USER_PAGE
+/**
+ * clear_user_page() - clear a page to be mapped to user space
+ * @addr: the address of the page
+ * @vaddr: the address of the user mapping
+ * @page: the page
+ */
+static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
+{
+#ifdef clear_user_highpage
+	/*
+	 * If an architecture defines its own clear_user_highpage() variant,
+	 * then we have to be a bit more careful here and cannot simply
+	 * rely on clear_page().
+	 */
+	clear_user_highpage(page, vaddr);
+#else
+	clear_page(addr);
+#endif
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
-- 
2.43.5


