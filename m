Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55281C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C078E0006; Tue, 22 Jul 2025 14:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3CEC8E0001; Tue, 22 Jul 2025 14:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADD3D8E0006; Tue, 22 Jul 2025 14:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C42F8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:14:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 445D2B9BAD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:14:29 +0000 (UTC)
X-FDA: 83692700658.08.AF8F794
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01742A0009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:14:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TeQWkpBU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gKKkLm0D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753208066; a=rsa-sha256;
	cv=pass;
	b=PqyJ6JTE2NdC389OIPv3nvzi3ayM+MMjnsf+07kW11PVe5V4ZL15ta3ImUjiLcy2hP9VvQ
	nTl8YIdRCIZWMuXcyXuydrKwbvJC7kZMt2SFSVo1ltPfzwfDmNaSIn6BsKlD0zCwclD+MG
	YqinqIeztNXjDrDXV79Q33swQAoGiB8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TeQWkpBU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gKKkLm0D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X1x0PkOdo0N4puQAl4GZ3VTUJ3zCCnWjN3ezvb2WwQQ=;
	b=lWy/VrZw4WJ43gqwE/ZxPwbo/ND3L0Cm3sgxPo4/f86MeP+4vsJdRpGTL12t1LbvFA+J39
	wPB2NG6eWeMZ94ttEHqK/yM9EKZyGOQ9UXDOpWN5dxvL/m4tVVfQzv3KANt5YeMyGeG2Xk
	0eKx5g6OxbWx4JQUmeJD6EWfV58tqGk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXmts005757;
	Tue, 22 Jul 2025 18:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=X1x0PkOdo0N4puQA
	l4GZ3VTUJ3zCCnWjN3ezvb2WwQQ=; b=TeQWkpBUqMmCeFKL0P5Mu4VnXcErwyUC
	B6TYa/z2CVLLTQ/SsJZDWr6FXS8CEHqUjvkvAQCMWDwd8OYtOnktZInpnJ/UOTws
	6V51jYWVYeveqV0/bReJ12jh11wo9QmqKQ+/M6G3EkCYPASSyse0WsidecHPAqhD
	BxzisT/uEsVwjUZMM/Oa0VxSeP0kHnZ7IgpeL8xr73V2Cz6kG6JE8rzBMCG0kbQ2
	pSXz0yZRbtxINsb1H+tS4KUXbinjjHiZzOMwmxXkTVeX4hEqoYrN3q998NGrBo2Z
	Sr+G2AiSHC2p3TeKhWNS+Y0fUJEhJneckqo21Qs6t5aUsykNNdwaGw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2dwdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 18:14:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MHMu00005971;
	Tue, 22 Jul 2025 18:14:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9nhju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 18:14:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zVk6DER2/cpZ6Rf95bFekKWO7IYRjAYCBW+0O5rBUDstmsg2eEIDrxty5aXEmNdPoyNCYenQ7GZmOM+QFC4+YgNS6sZ2qCoo4cY4bXTesjJltoXqxgqtnhIfIgwzLYy2lTdaUYL0SfLtYkBVq+JLMitnZcnAQCU+YoRc9VyzvtzLs/fojzFKM0tiijanuvP9CIsXtAYnVkDhx9+g8M8yqxpSPua2M6Wz61YJj9VO2Blk9cIYkriKhK2Zbw5ko2Gyndtl9DJlzdMxEBMR4N7+P6CtHG3AhlzN2MYo9tRziIscXHYXUkqN8pFHuPvwMijo0vxpsBT2Te5JDlwZdqm8Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1x0PkOdo0N4puQAl4GZ3VTUJ3zCCnWjN3ezvb2WwQQ=;
 b=vksDpx7wERLl1z+UbJ+fvVyLnHVmGoDld7mkKJx6T6W4V7BVt6AfHxzU5c9eQBolPYrPUaGC4r2BfB6tRFbAevgxkpOSMJA+o3eJjrOZtD+1eDj+681x50Eq5ui3G9fRTXOToVj9KkIQPu+tUp4+OdGKtC/TPA1iweNOA2k4ph1SKVEj3/yWBZUSj9vxnMkrwiRNVtFAROYAHDmC+mPT2pVQHIC0Ls3JQWhm1i8q72Cr2jZz2YobPBlFXauue56SuDahUamamCHGxZEy8UDe5wHVpA8+TA7xaZ3xDk9L5ahlJbxYal90OieWsF1NCTBHvs7gEBbXoRCIZkIZ0ZKqvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X1x0PkOdo0N4puQAl4GZ3VTUJ3zCCnWjN3ezvb2WwQQ=;
 b=gKKkLm0Dzfxe7hVgnQfqrSWWWO2gzjetKq6unUAHjFDSb+nXfekeYIWqOPU48bcpy5V76RoQx5AEu1ExPXfX0/lwmgHo1sJVsupPHcy6tmc0g7o9fp47NyxmdOKPmqgjT2SG71APyFigCGwmWCSBk59TxOJmpd/PHcrDvGZ88VE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF350708D76.namprd10.prod.outlook.com (2603:10b6:518:1::794) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Tue, 22 Jul
 2025 18:14:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 18:14:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Subject: [PATCH] MAINTAINERS: add missing file to cgroup section
Date: Tue, 22 Jul 2025 19:14:09 +0100
Message-ID: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0036.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF350708D76:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d2375ab-b98c-4e5a-27ee-08ddc94b9351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WtUoosuDvuHJBrpxESRZ4v7K1dBw2pIm9jKU3ULzcP1oK2+q2o1h8Au885UL?=
 =?us-ascii?Q?1lAeraXbuXfWtYILJHWAXNENor5jLtHeLGvmvQrLe1IcmEQ1YYSF2N0upnbG?=
 =?us-ascii?Q?LgowAgZpBKwY05bfkeRB/KyXHwd9QxczW+voaGEov3rCHvr+3dCBoGg6oCJU?=
 =?us-ascii?Q?th1dr5Es8HHpeCuPJOUhyUhN3+H4BvkRTevawd09Hgi/+GTER1iGa7pZMtsS?=
 =?us-ascii?Q?Sgw7kCCAoQlwkR4Ead12rsQDnv53mmwgPWIlSkQN7KQ9r0meERNx5OIMMSSM?=
 =?us-ascii?Q?XrIkK9/5c9gtNpwD15zFH49WBNmobVeykhuxgJ3n3B9eQD6o8Aua+XbSWqiC?=
 =?us-ascii?Q?izJj6R4DacGHFsnpRusjggSxb5jJ0gCD2RSSaV0Ut+r45Vm/4MTiTCJ0UAhT?=
 =?us-ascii?Q?K9J5n85dW0ZQE36zSuLPSKCAAHVG+CGH7Na295OvYfVlX4/8krUpyhASf0Bx?=
 =?us-ascii?Q?xlTNMPxv9EAJxrG4DVcmp+1RgYHdbFKk1+VPkPSD+juTIwkk91tl+8gl9C8g?=
 =?us-ascii?Q?eD1E9fZJHVc2fNW2OSTmj4innzt6Kcsb3aXFnzZL5aX8VQFMh6hBErVW3JhJ?=
 =?us-ascii?Q?5WfNm1Z9kuVp9IY4Jr1Z2f+V4PUHKCr/xyIGu7llnVQ+5Fz4JoxZFG+GgEYN?=
 =?us-ascii?Q?YHcjr0ewlkD3NISMr4j/FqHUN59cNI2sMx9NPziVDBGHmYjVxR6LbbG7vGNL?=
 =?us-ascii?Q?zTYMGshNhRgc0MIOAcTQQ9Pl9wGIFojwImW3ICJaZV7Aa6AT1kRpU8jPLfUD?=
 =?us-ascii?Q?RyqZo89vtpLYf8LWRX1yOcKsBVcTVW4AGbzeVhzIGa7K0tkvaLFOx4J1/Y87?=
 =?us-ascii?Q?yu2GDVwoi2FJM6vhvqBNHZFlWPwfHld4A4oyMLpdmWf2MetkmWyoOC13fIKp?=
 =?us-ascii?Q?9fbVCA+Tat1XgiUFYevJinh96AY3QJZucYj/j54JyM3vXvPKJDukHBR4K90G?=
 =?us-ascii?Q?uqta+EzqemDCGZkXQc6Z6jSbX0DI1RXhcDroKUY6bqe9sHbzm8F1vDDx0J0x?=
 =?us-ascii?Q?RkMz2Hmzw1UwIT+jSQDYg78W26uevaDWe1Dr5Im3CQlZkefHaMMVEwBAAGDr?=
 =?us-ascii?Q?clMNimssu0FRIGMei/33OaFL1dhpe7TtA2VKTuJOvqq0W3rsYppP/av24fhO?=
 =?us-ascii?Q?aBjjePnLsjOSiRI5lpK7YTAXSZL/VgU66uSv9/exfY38qOn+aAEHPFeU9G+b?=
 =?us-ascii?Q?byt+dGHawmlDe8/qXTIsLUQ1xrRHSPk+WxgpQYX0hDfLmOLeP34lVlZ3bNJZ?=
 =?us-ascii?Q?KFMcW0QdZ0E/2WLH0nsLrNyQgMymU/4yZMmmFcDNLgQg+cZA9SNEbIqrP8VC?=
 =?us-ascii?Q?ASAtbqNMLZPMsMxdEce8luWclIKokQoDJ18HwsYRcjtSMIzatTjPuqmBYr9D?=
 =?us-ascii?Q?ki0u9JbW0OnS9cFQDfVO8r3Po/yGaRmISE88zbx6VtkbP4qaUxwKSPI/FX6u?=
 =?us-ascii?Q?/GTtJ+W1PFM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ljcaKYEwxXVe2FxI5ehSDGL0UM80Z1mYQ/uuGqqJVvYTqHq+OtFQQr8lm4Rn?=
 =?us-ascii?Q?GF6A4j08YX2WhyvEC9DxpO2IrRnciLqDSY+HP0ZZ+QhetC49WtZUSSWWT10h?=
 =?us-ascii?Q?EpZKgMDfrXlTVWQBmr2JAd4XWEcbtXbzhCiEXwZaGp5X45nIbI8yghZhkKxa?=
 =?us-ascii?Q?CXuxpIvZz3DksC8PKJXQJOvn7xOAF7cl4jqwxIwWZGelB/d4koUuEHXwZQ1R?=
 =?us-ascii?Q?JXBrxaOTuBEJgVVXW/9wHueg1m2vDL53Dy1q9vgKpYtWElsR558bDfXCMQGa?=
 =?us-ascii?Q?huQb85NlWefctMvmbyHFkUMDU7kbuXz3oMEnOanEDFJmEFbkIrS2BtCIhSqJ?=
 =?us-ascii?Q?idY9Gg0xGfptMr/74Qb5EPBEwOzEwgtVhCmbVhW08y0waStSZX50g4FLnx1C?=
 =?us-ascii?Q?t/RnTg8WjK0bqfPWC/GYmyo9b2BasqXiWKKgj9gRPZOVYqte5CyiY+VguRB6?=
 =?us-ascii?Q?BtcPv1m1zc4O/xhoqFiIDY6GcETIZWjvohEQWE7vvD0TX/i8V2lh9HPAWUhF?=
 =?us-ascii?Q?b3SufjuB6QVn8dQtIVOwAc5TxkR0vxCPyES3CSMX/dxSCF2Z///e1q7BTKor?=
 =?us-ascii?Q?GqR9S9i/OsyBMGqTIjjYI+t1FtwJv6w+uuwC/1MVeSEjI0if6hGsBqNvHTCo?=
 =?us-ascii?Q?sPrrlaXuO6e1SuwvD3u7KlVMG3YVAI5wHpXNbrMa3c4BAYak+oVIZ+17q/Ye?=
 =?us-ascii?Q?dugEXLqQqII4tLqCTm46q38mDPLsl182KRG4LRQpEFbi59MMfTVBc5NTUCVl?=
 =?us-ascii?Q?0WagVX5IrWsLukzSpvJuc/th8FKMb+QJ2ojE97f78lgIJxOW3lOi+28+GXKo?=
 =?us-ascii?Q?z5Whtx5y4K3jpYjXPYwCCQzFy3ICMQMvYyb+bzhGjd1rEVVqRc/+Y2ikF/99?=
 =?us-ascii?Q?9phfzOCVp7M3+8hmCIpQRCPeFzad9WaAL7F+9GbsCOPtEbV/QWlUYN2dS4/l?=
 =?us-ascii?Q?/3rNcKOh/aqjNNRv7I0ctyaZYV3heap6FpdooWWO36tJDxsk2DQD0oXllofg?=
 =?us-ascii?Q?6CDNI3WCiXzHc43lZbQ9t1L/dAZD2Nv2pl68NGTOmJk00hGBfzkwokYXgPQr?=
 =?us-ascii?Q?6V6TQz4M5itQniNopy+h1NDxDJ4bLx0bJxTPXLom1nzlWr/EtrLjCdOCDVWF?=
 =?us-ascii?Q?hM1FJLEjWyDdYscMbgeuT7RpDOEsp2JzTpvNIPQSAop2ef3EBsp1Uw2J/fyn?=
 =?us-ascii?Q?0Kc/YyZ+QRE/s/yrv5aqpJkibWbKe7agMSWen5idka45/G//mdgP+0KpFDMq?=
 =?us-ascii?Q?LsyL/fKIFpv+tvpowTcslQfbNsTt90cHzzpVWMrBli5+a9wMnmaqiKp33b5G?=
 =?us-ascii?Q?ThOkYiSrAl2Zxwi4iHApn4Lf3nysCFrGZL057WqXQSeYKDlAskzXIwgRWRIR?=
 =?us-ascii?Q?GpYdL053gbgyvSS8roajzcBbFgmyB8dkfHblvH+eq+ZSP9upd6+21Yuxyusu?=
 =?us-ascii?Q?qJeBD+QxKKvFjcC0dM4d6KGA7PGI+GyGXxj88BA1P84kDQoT1JGte5cP2JUa?=
 =?us-ascii?Q?gHLhm8/FjB0xI11NbHXADI6xwBN+xbVTEyu5lkH42U86crHmPk1Ea1JMFDFJ?=
 =?us-ascii?Q?Cz10D43dHWEJvayo9rhZ1YY9uEnJOP12lWVhQ5Xpej3haxm3SYRzJC/fakrz?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yytO7x9RX01wB2F3v3BThnSB806Tqz9CTlbb8OlRSBh5lOpCO8KUmFhAZ7EAZppKWefkFqvUrfa+r/xZ+1gfZuwngWJgQS3hEzNIeCyu8Gga/5CL9A+nMT+Zqwc83DZSd2O5Ivvjn3xQ++CdwZ04jFT2igPpW0+iZF/iFI3xlI1/SGMoTwcNQiue8W+SakcxQJUf+x6ZCxFzzCUwKA8h8ej88csydHDcApmODp0850CJ1V5f2WIq0zB/JMe4zu9uEIOEdhAWgm6ku0EsVDuAXUKP3GGa7Z5XvCntcrp8ncROYPzB0toyVpFul/KUpB/1KIpnWmOG5J3Z+XndDK/bRPfH+9wxsNSu19KtsR/K0V50fTXaJcVImVSqzALN1RUCQsNtdmv4VzdT7lChRjRJUc0XDpNf+QgVthECQn7OugVnMWqacrofpAxzQcQixz76dcgmXxC3uVSC180h0wSFQBckiNkNdUb2lofAlR/whw07Tka/jIhUkEl0uj8zl9bUTL4+FcelGv6IEfWqbLCP+PXq1c2uXlIBY4AEmaFMmswBe0iF4TgyeKRz4e8e0DTlEVIj33cxPTfBTQc1zI3e+VIDcSH8a0JmQsfPzSK1B+Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d2375ab-b98c-4e5a-27ee-08ddc94b9351
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 18:14:18.8509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AovI1ZBUBj3oQ4bmKKE2uqP777ybATZPWZr7u7YteCgSj2LBi/yjfrHlCO/8tg4bhkkvWbmo1Lmxort3iaYxW4eqXl9KQ8FCCIKO/nWmpzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF350708D76
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507220154
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687fd4fe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=54c5P5Ow8AieZu530QIA:9
X-Proofpoint-GUID: N7ua5XdeZym4JNf4PTWKptRHvO30NFNZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE1MyBTYWx0ZWRfX07Up9+TOCo9O
 GZoVm4tSrs4my9gBBehmdYDlDD+A0vVb4Xz6+JV0Bg4aw8gbw7beQ9WzIBMg/x+v2Nwl1IKj/dg
 fjJXBLCpZ0EgCdIQct+mHifbozhsCFcGSzR1pJI+f/+U0B9kMyS5hZohaD6D7LuDSIr6IytYKBG
 qHyQitWwDPs7RbNHRrjaOmBWxUsWmbiN2ROd0IeDqS+R28JjdwzJ8Ym/NkOUExE41RoRlolx7Mx
 P1RgwYW9Lxmpg9kKdkPLSrznNfOQ5z5c5YOs0gnPW0W7tICLFtzxe2Mr0dkVunkCE1xRaWhx6se
 Yksax83Ss0kijHfJZkGHtAiJD3AW2DYVfXUdOeDyfd2ypqZYXmeaR5M2AnEDInjQRx8TA/6WUk3
 x9MKTwAkx1lYkkZDl/F1PSd/MaI08hHYPN4wcJbP7tH44Z2nuyxlNSaiHYl7sPgjrd1Rt+Uv
X-Proofpoint-ORIG-GUID: N7ua5XdeZym4JNf4PTWKptRHvO30NFNZ
X-Stat-Signature: ynoz11z11j1szgdjbr4oux54qewy4o9o
X-Rspam-User: 
X-Rspamd-Queue-Id: 01742A0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753208065-846067
X-HE-Meta: U2FsdGVkX19iK/fh9d/P9qz06sbuUZs8jyrpIGCZSk3ZsSZfGXeM66kjLhfQSo47IudizwlnNYqVoPWmM+tcjl3BpCHY+rJdXWFDTN88ifIcteZzbI2SiNhxF+/jzpkb21uqP0b3VOxuLtoh+QN1S0IYpKX8YKveFqNhxqR0bOisinmNxhjV3JNHtB0vlIiwJ9b1qXrmRfDTDn3x5ijST/dmBNPAtcMN9SRq651+WkehTMezy0c1YYFR3Wd0AYRG70BqLX/ZHDBYU2ZkwDjB5OZAA7QI52At3XWVwU+deMO8b+xekyCHYg8AdFhGxSURLW98Fl4f3WEl2TliXbHJpcU5ICU4rT7MtY90KsRXf341/hNqHhakUyEtfoMUdptvZzWMKOlJzkVGUlR1g/1yGEMR7geC7gkzjLHVUUXyuVor78RKI7RNP33GU6zmMrFfg7IuMpW0YPz6Pw9LE7WNjE9eSH+HpeSKL40HS65LQis099rkvs0Bma4K/Tcgqf+R1PMWWTfQ+gXVjAcQyyMuu6z+k8BhgsH15rkiIg+unaHYt1aQjIj7bhQuPKHBCJh/JazCMwk3lC8N8T1GdKsuOBgtu4+xoodPUo7WWHrDgHCOissobN3eaQn0cjD56WUeS8WV46MtOXo7U/k2xwKwQmedPxDNksKJ71n3X+wU50fz7RtVC6D3T3js6go+1MfQFJ+SJ/RnnfO8dbp0alQuttCo4OqgTSikVPjgclD2tWF4Hpp6yK3chJNyHoYQUvFKoMlcnjwAGL87idaw3fMl+v/VjGzIGnn0dJZIAOmlWzniXVISDOTSh1t6AGBUYA9iNw9KodVq5l5fGk9hObUKYXeE0oDyPyGt4XGdRNuG2PwXBzHgUwOrxqwKnKUC+W6nhAXC6lOUefWPt/cW+0WtZJBuyE80ETpyIrzook1IOwy0uLwJZqSYRlQj6/IFci1xFdE3OW2oZLRI5irNMtC
 3JVUlXNt
 yr+XjyF7LXOQIR/K5nv6iEwawQMFRU9ndBCHFKe/q+zbitGaPfqJvDVbJyiLXPEhwh8EC0cdw7nwKBJv84dEW56kPFm4YZx0ThmyOe0fl5nr1DApUsJGabZkcrNdYWzrw9Qbrk10w6o+jLRPOIe4R8GDaLI1eXMv3E7D4Y/gQJQdwsdsVPl371cdGhvy7u2Ll+rS4iZv31csTonuRZMQ7cnP8E8pAxvv7eXGmVhEl5ed/ll1LiK9FAtoBP26QNqk+sxjLZVLZz3cV6DJoCFMSdXBwjyLMbBjlLKdk2oFIUYn4j2lL8w3t7sf6FcpwlRIoep9fGDaFhWqY1LIuilg3ZVI04196hqzaR1K/FaOwF35a6mG7F0ueBjGC/gAbm1jOb1jOuVoApikayC/HhocNShOjXXUHXc/uyI6v7QGNdw0KnGsEQwoqTZxjWhnMSmknU1S5Pn6cUILGxoofJDLBuqgXYCYQWyuQULq7MdFtX3HVWb0igVVFjXWXauUUGnBOUFijD8rdzWuiR7g29Ex7G6KzqSAwPOXRRhb+volAhaQRhOYWgZ7QvnIYpB2Be33xBTVJsbKI59Ta/IenYnds700GwhIINwWpetLAVWCJq3GeAAIXWsMvRSAV0ZNroE46jS4xGMl6jfbGsY+36iuN2GofzkS9Ag4rPnxPg58fD2cnyRuFBHXFc5uEWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_counter.c file seems most appropriately placed here.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 837bc5cd6166..d062318b6d09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6166,6 +6166,7 @@ F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
+F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
-- 
2.50.1


