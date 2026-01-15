Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09CA0D46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B166B00F7; Thu, 15 Jan 2026 14:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5156B00F9; Thu, 15 Jan 2026 14:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5C66B00FA; Thu, 15 Jan 2026 14:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76EB26B00F7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52F9A1BB9A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:45 +0000 (UTC)
X-FDA: 84335210610.04.805FF2E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id AACFCA0017
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJ5dqktu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BQ9Cjahg;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sx5VkaNpAExqgEkw5piLMn+7NTyL75IXIw2yxItIHAk=;
	b=eC3GvIa47bXG0VvhK7L6ssXiRt9mDbuSnCqBdqzhpoN1zPyMY4SC/cr+ZshLEbgO1EyG9u
	LVo+RLvzgF6Rs2P15F0xZHcG/+gSqIQG5Uy6vNIP5dboiD3GtO/YkKRIOLN5/HeU1r6Ubh
	1VFPQGg+1LPVsgngr5FU0PjpF5NULvs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BJ5dqktu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BQ9Cjahg;
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505922; a=rsa-sha256;
	cv=pass;
	b=DqX67wjbefGpERxVKRdyAggW+mFvU/MTMMxXzrek8dNAzI3z6JMcdU1ubCyzMH+5v5pAgZ
	0CP/dPd2UNZsGYrLDYB18+bnkmVz5aPn/whAkfRLnVMv3oniblV2zPVOCFEIg+n+iXmKMs
	e+4MR5cpo6DroyKUY0xPaLwnTFtG8Og=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEM3AV1296007;
	Thu, 15 Jan 2026 19:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sx5VkaNpAExqgEkw5piLMn+7NTyL75IXIw2yxItIHAk=; b=
	BJ5dqktuRQ9tFvJwzi1Q81QlBtQpjh9SMprOsgeO2yOgyEgpeZ6CBitkluAflHIc
	QEjIf/l9jsFK2h/jvv0MY/C8NqHFBBkUngrbJDQ9qrcBD1VsY4uI+sUP6BVs2Ydo
	3/O3bxMU3MEM02U7W59Cr/YMo1IDrkxqSzXSnYVCqWGNOhCOwO+cg+f1iCtAv2A5
	gPb+IJ0Xe813/nc6WMr42c6XahV5/Pylavj21ZA387/GaQtRWEBYUNOdU3vTlfCe
	psvYC5Ag+6cJe7uS/IlGpdSgycXTLsMKhOGkE4+q2FDr8KCEe/QtrnAuhLOuzqzx
	/VHHaT96vUq5e7LxD/S7Cw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc3tun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJbCBS040448;
	Thu, 15 Jan 2026 19:38:29 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011033.outbound.protection.outlook.com [40.107.208.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgmdy-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bm4TX5oFILxxtBHlzThL1a+tgY2ObZ+s35i1/8aR69KrdzbvHX8YzF4gyJWGLw0lxU85fuqZbvTU0JpuF18/NE4b+oqQMfq0xLy7sGZSooGb8TS/WR8qNPdDTZhaAw7NkZ8i4euaOkWAIibwF75oS8Vc2wuTOM2P5DyhnurX6bEyKGCbAcTups/YVFix0uGl7cqOerK7T3SSIKZjGdh7xkLiGF3TblWe8KlL2u8bouAcF+q+o6GtTib6a+eMrLohJxEFYxHDPqpN1m+TeiP0KwgZsFDGHqJuknv3LUgm2OXi+NQCH61RtueKlDMEAMidF6WIjLgzDfdF8ZjTRKrvfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sx5VkaNpAExqgEkw5piLMn+7NTyL75IXIw2yxItIHAk=;
 b=N8pGqLg/j/Upw5GI9OwwlR6/68nT17DeMOYnYwh6+Bxe081DYxvjZf792ITErXEN+OTNrcw90WHynI6fNOTXRSSrY6Lfegv0EBfzQreHAWOZ40bPx0ecBpT1AtPrKd60wz7bradfmVSxkAvoKTkWk0w7USkKeTOnzJDu1GPs9o7jbI8FdWxleOwjVAccA7DsbMBavtkRk60X6xxbEQwRWWnIlC8fbQIp9+wlpLSf8jlTJcbaB7Kc8sb14X8JvAxS8UVJxjgh6fZ3fp2n+bvqigQubnOGZlLutjXc3ALVIicIFakP1DirlnJ25q2cVsxQjFIqm9hM0CJ07HfHHJRegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sx5VkaNpAExqgEkw5piLMn+7NTyL75IXIw2yxItIHAk=;
 b=BQ9CjahgHuZgVqQKWBzrVvCmOkAWBalGT4XkU6H5il0U3eu3uZ7a/lysrxeLlYr+gH1XTSQRgS7baxSG5TS0Pp9AhB+zmmYxORZAnD5BB5pQYgB14d0y2soSWQo4qXPEJ8VQU7V/kiZ2SiJ/CcI7eV6qqvrQSfF/BYR5WmS/mSU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:38:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:38:01 +0000
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
Subject: [PATCH 28/28] maple_tree: Clean up mas_wr_node_store()
Date: Thu, 15 Jan 2026 14:36:47 -0500
Message-ID: <20260115193647.1695937-29-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0372.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db8c693-3277-4c29-2de4-08de546d985b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kp2usJWcgm+hKM3IKpSUnWhxy02vXSazgyxD5lQjFQWenj7RN0ilUq9uf47Z?=
 =?us-ascii?Q?3/CYI3Lcgri7EPrzis0RZHLLIfTuzR9WqR/6goMp5TVBDalh8/GG9jtAN88o?=
 =?us-ascii?Q?wwmFc2bZu2CI3igUzQ3zg2KKwlayikHIY3KiCyVHuJC9RXLNEslpZQF4xaOP?=
 =?us-ascii?Q?j7jS6dnXAtnakCTbNO50Ei1R/uxrxHF4ciJ9BWjwLRSeOcj+W+/2hvJ1mHnz?=
 =?us-ascii?Q?bWlwYqCZUj1ZCv5J0Klp/Ernf7oL/ttOvrCi0YugrqFdKd8V6OF5UUJN5+RI?=
 =?us-ascii?Q?2iZzixwcmqyZ+kP8p9N8PYYmc/8Jwmv8D11j7SIhYOonlLisC7mCIiP393eG?=
 =?us-ascii?Q?rP/wZXBstm4lG8xht1gRxN4ASeICPpyDUDk4xg1tYrWBFm2znLLQIxM8PyRX?=
 =?us-ascii?Q?mnQ42XJhQf5n3mejewsvtBCsC7RNV+chQG/d6xfdb04VeC8Ydr6ekAnlYqlE?=
 =?us-ascii?Q?Q/gpP9SdUsFqZgZpP9WW4O+KG1fqtQlcRT0Jbw4wC9hfzClWlTXEA7NHgFoe?=
 =?us-ascii?Q?lFG5ozuY68kMywP3WuysOqBF1TLBJC4KTsMNRQP0MaFYoj/nSDPnPFpgmbmH?=
 =?us-ascii?Q?uTnr/a5m0/aqEDZMNBkzQidZ4I4Y7usVRp7XzTu3m5a0m3HJXXY8w4+9PeJn?=
 =?us-ascii?Q?Tu9zODABP/lzV4V1QZGt9WAbpiXcbu1c0x+SguNH8JpJmrErFocbhvJjZ2dI?=
 =?us-ascii?Q?QKwarZbhx1vVvTWFKZ/N9AhmUz+49an8+3yN4Enbj3Rv7gwXPjzwPxK5Ypib?=
 =?us-ascii?Q?1v7kYf560FZ/lkshxadpPmWsKUv2c/5PnIeJYhxEgVyHMaDs5OCaxHXf3Zvl?=
 =?us-ascii?Q?t6VdhCJzuQcgys4LEgrQCoqkqVGm5wVfGOucuy8WclviHWJsIDD3g1WrizMP?=
 =?us-ascii?Q?9WTSPuvWE24tmhNy7La3xJ1ifVdP2wdB+JJ55YDGDl+tjp8DqdHu3LeKqZen?=
 =?us-ascii?Q?lXFFhBBM/BGZsUYOgvRMKTtr7zk5rW2v4G/29LTnub2sMq0UeMsnsw27179k?=
 =?us-ascii?Q?0FV+0xLcSNoaFp0C65YNYlg7TQ2h12nAcz7Lhmf5lyCA5zCoXdiqy+0IceiE?=
 =?us-ascii?Q?lRGIp15rJJkK9+IIuiq7jfnvrcKfvRFLLDpX5hfr3YjjDkwzWuVcuy6GIZ6u?=
 =?us-ascii?Q?Ll0qNq8ExZ2A16I5diQnIbMDuSxHj1off0BI/MYmVAGe/QIhQYLZqoFJi3jo?=
 =?us-ascii?Q?cFETXKbKta3K0Byj+YmKc+eHZpoRK7TO1BLqcSNmak/WzZz1i+l0jKB2Dm2u?=
 =?us-ascii?Q?eYgH2OG1rH3aFk3zn9oFYeYF64rysdUkQeeAo3qmKn0ND0bEtBIcZHeZ00Tg?=
 =?us-ascii?Q?pUoGX7wT3ecsCURAfK/IVGrjG7AJnZtargkrLn3YXNzwB1leZv4k9IZBBKQq?=
 =?us-ascii?Q?3VM8DIdYTZ+iCKh1dTbgqYNvZYca5yMvqsskCwKDSF+QRuUu4UtyThvPBo/A?=
 =?us-ascii?Q?t+0cY0Ioomw/RHXVqaOpBKfNHgzn9rKv8JFT/vfXcusQdZKehWfXm+zhSYcP?=
 =?us-ascii?Q?WR0296922bIljbniU3a96w5ozBWNDmekPsfQ42+JjRWyRY7m0Ih43n0hT4fp?=
 =?us-ascii?Q?hC2tg7R/Viq0psmpyGA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yr192cqOoe1VCzv8fP22ELtSXSbq69Ni2uGyaYSNhqWw+y7dDhxxRlGczhCd?=
 =?us-ascii?Q?bDv6e/gSMPlZHa+Tro82StmwXWkVJRN5dSOe4xBRcZQdGVL5YVsyghp4bJS8?=
 =?us-ascii?Q?2STWBIgsmKi+AzK/YScWKKIjuHYOmhaaP/X4oGT21NGyTV+LU2DosHVJQkpc?=
 =?us-ascii?Q?zhevS+nJKM4VAmuhdV/PEAbxDup5k4kUKuI3/0t7ks0t0UCYxa3Ve8Xd71r4?=
 =?us-ascii?Q?OH56L32itmpJiA48aTPE6DrDLa+W5gZduT3kuaU6BW/4Sbnu2f723YDfQ8Fy?=
 =?us-ascii?Q?P8ybUPnuAfueHmomqdcv+MQ1tNyottPFFtWIIhwEXkmgdeQUNP+z6hCxPwax?=
 =?us-ascii?Q?ijiwRfhjhw3CQT8jhpFddUzbv8W7ldXJUd+1BgX73WJD42eMQ8hu+VnxptAx?=
 =?us-ascii?Q?wfD7lz3jFtlWfdWc1GvP5P07rvmF+pMAw9oju52Qx5YDbTrXhPBA3GFqe0ek?=
 =?us-ascii?Q?HHjEAk/M2NpPVbOhL4UGtUkBwmVeNUY/j2xXZJfyTDo/ooqd1fCSrgOnokg2?=
 =?us-ascii?Q?PtJifSWMnzuyx/s6CIwZaaibgcpJdn28DRC2zAXb0pnBVTyCGkM52OfXmTfr?=
 =?us-ascii?Q?DmWaxD2JegS6dPSKGA2KClLDJ0EGzxhhSXu6E+q8Fe0fxpAP/R29NjwfoUBG?=
 =?us-ascii?Q?rvNZmf6M98MFfuZfLFm5BtruEyf6YmO7QhVrJHtM/U3dZdBGG3dDgd/gcx+D?=
 =?us-ascii?Q?7XHL4+4kmD1lsfR1+H4T4MPG8iLvLvjXTwYwDmqVFfh4As9fOnrJJK4n7N5w?=
 =?us-ascii?Q?SORsbOsxjUcg0u/w2SINDD6nD4hKKRMUt/rsTEEPmUSJYny6Qr9O1hhL7xU/?=
 =?us-ascii?Q?fMoig3X3G8tRYL+yIw2nTcxPmGZdYHGW89czRljkKs3Om02+1+f4kNW8LZkf?=
 =?us-ascii?Q?iMcFMhTg/AsLs/5OiwAy6EmfVYBz3E1HjcZuMiZhALsgWNtjSY4ZIe9KKbe4?=
 =?us-ascii?Q?vBxAYic66fn2QYkEBv934t66POuU24HRZxDOqffo9/G9jWBR36zTYbrfBMHN?=
 =?us-ascii?Q?AQ72FsZkCxBWcG+zN+dQqLewkl/LECad8mJa24e59nPmh5dTNPkJRdsKM5tG?=
 =?us-ascii?Q?7oo/kt5ezXEssuig4ne87EKkQYF865B1cOIkgsoghuJrF3yNY61BcLIhipqK?=
 =?us-ascii?Q?mYbiP49dYjcC8APb85dCvS5UYllHaL4gXZxuglXL1b2Kl2isfHZK5ZJoV+Uo?=
 =?us-ascii?Q?1W6gbMxWohlOLSM59I8g4SPpw3H4+0JXsfbuhntLBNFyZH9+zALwllOzsCHc?=
 =?us-ascii?Q?BQN1wns26hRXnY82YvXUvNs6EegG/WM6m1BnxPKIJuaomjdPDINUIkGKG/Cs?=
 =?us-ascii?Q?qVP8bg5JAkMRdaBTS6PmQOtcTQvj0KExA8yMIEYnfJfwUO9KY1PbTYZ3dJmB?=
 =?us-ascii?Q?AofyIp2nu6GsU00Cdb0Td8huRso0GXSjcnVJXk7a40LG49ahMSovHaFh3nRa?=
 =?us-ascii?Q?X3Huhi2vBwa4khJFkK7TqSNU2GlyeeVheoH/FGc1BF+/E1y8bemeMz/V0hVG?=
 =?us-ascii?Q?ur2Jo92SyEAY7q9jPw1hlJ9/bVMgHwrIF7bobZyH6WBFIq477Rfh+kAbwco4?=
 =?us-ascii?Q?V7HnIXltWgRX/ka+lLE+odYk9TmIjgv2n6sEsxzDDGltPDflIc04wERXoHRO?=
 =?us-ascii?Q?oLtxCyML3PaW6Z4hRs8SWI1xjESqscQb3w4FChm1zST2uhjmug3SaSmo9/Eb?=
 =?us-ascii?Q?nUqJt6hBWmXUAYaVq3OeAlWz5HZmhJhcRU88VgtrELnFgS5viUsPLdMBd95M?=
 =?us-ascii?Q?vFt3oW7r2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e0sKwr+3jmj+++T4oziZ2OZuDC3tmlmO8hwOjIEXhT0VToo39AAWrxYmLZe9cRKhxpBNABPUwEPSX+5CstzleOvJxneoRfzu4fIdKaYFgv86rtKA3Mxil9BGdZwSdtu6AGUs/BCbBgw6mPXG4Thn2v9axQp1GH0wzDTkFPRBWxGI5p9xvcNpNarzONsEcqlFPF5TF1+sbfKs/Enbh3kyeZT1c5yw2sdZboi86aF1uPJYsu1kcBwLkYd26GeidR6BFPgFH1eMRytSShNw1XhNVCMeolPpy/udTdc4tiZDF3CFyv6ztlwQypXw4aw53rvj+/FAOWm0iudcGwhJI5o9IMH3C6a8HnWdDWp4REw8EYCx26KUPk9CKNH/ELftKQdRkk39HIjeHPU6WYWgANjSIFhES/NaZFaNcy43cBH8p5lhQGFxzKY2QWSO8ke4bPB4bvimx+phwf6Mb9g+8C0Fu3iKs0vWpd/7xzNCwA/Ko4GSkaua2khNIhgUA7/iGdfrnw+3t7Qu3mrY2EgBB8aE3e9pXWBQy5JvMpr10kALMiOlOjXUBTocgUYjK/Lu1N/X9uKlWUBk9fp5JVTzbNj/5V7LvqX6rdt4p+2vwAxCGEg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db8c693-3277-4c29-2de4-08de546d985b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:38:01.8636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bpv/77BaPgdG6z7MeoLUxFWYETG4LOzOklhFbceoGfB4e0A4g8/DXdlgvd0BLs0rMYl5+U5RpZCChlkn4e5IHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150153
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=69694236 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=I3VoEf0meaw97abzItIA:9 cc=ntf awl=host:13654
X-Proofpoint-GUID: tbQSHNVNTAfPheVR7yDGosGIKVHWvFzo
X-Proofpoint-ORIG-GUID: tbQSHNVNTAfPheVR7yDGosGIKVHWvFzo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX7beFC9WUWdJr
 WNu3wNln9fl0951fLVc02nf/RVJcx3wXZ1FFOKo9mhCncP1ybazqv1XP1dCBgP6SzhukjfSksh8
 VWVqL+saFZTddrZQF0qGgKVLmR49r/EEtrnIvEg9UtaMkGZzLA9z9Lf1SiZwP5hU5hkZjjRfrku
 lloXNG49QMG21YD7CQzOqwqvgB8gMZAL3M31NVU/mwl8vv/po9fAV9gnPNm3IWFClgpO4KAssNX
 9cXKsuZOBm1EjBRiHK+VRrBbeqGpuTzzvBQmRr04g3EKgRwMjwNwINrdeFl3tGSShBDI4lA4C07
 g+zuw03oln3FsfLr/ZGU00t19xzz07uaVzy3ekbQBdD7xzWk2gatGX9nWMlGs6gG028QDiilhDf
 yWqDpB1vTqyBUERns+ZpXCHy6OfZgSBCoH8ZCfGvfSLJR0wISOiptobqN/mp6WVDiaNzLwpQios
 hp4vD7mLSDZiEs8tXpxQK5+Bz2WnJVC7LW/7C2ek=
X-Stat-Signature: fyas66gb7ajbimkysdny8w4xwzn4citt
X-Rspam-User: 
X-Rspamd-Queue-Id: AACFCA0017
X-Rspamd-Server: rspam08
X-HE-Tag: 1768505921-172307
X-HE-Meta: U2FsdGVkX19b2jDdcpiA1uhpoSNI3ymKMfBcsVkq2YNcHCmhTsz/5XMw4Esr7zv1+9v7hcpBqU0QOfNidb8mubtT11+vRr21qkrSyrmy+KJjy2Ix373UaC4qfl3xYSrCykOXjONj+8xwYPVa43hIlUHWpLcLlF/13vh3u6hLvnLNCl+QBlXTkAM3IqG4Z4kgnz2UOCa/3QV8tNfNeD3TR2m811tz3aCo9TsGtoVRj9F0ppxn/htSa0J9AFPAuwDGtGy72sQIcQ3jV10duElrYNH7bSbS6qY7XJrs1TddyQcK/xa8SfyFIamT6YkveZrMqUIRMablvuS45L/PuEi943o/hXoePFl+Pdb6UsodesIjfjeZYutO+0DjLqI9Icz4bT4cEeNJXa8minoGCgaY2nEgZRLLvLOtpoyJwfrwwAI8/kcW0SqHSnhkPqvYyB47FRTfrHCB2uGs7X3wxGT5RN1MuDv2os5P9bP3csZWfC/uW76hAjCCtMszXkVgKgTLSwYjAzvfdzrrUKsC3godJCb8QoLqlrNhA7Q9EOxl+J0fx3aDCt+1NAZjdw1BHWmiMRcm5kU2PYs1w06xJlqRyEy7jWZ+xHOkhX1e1wU08ZL0b4ZivMu+JNg/zZXiO6GKSt750vF5SLzMQxLhHmOGTQ+3d6Wh1zUwBp0y6RfOH8HIud9PYW1aihaII80ZyXFnnflz6WGayNbqIjdXgM+zbudUPXEbX9yaBtPjOwxYcJZkG3AigSsQ86ajdM23Jz6ONerLV+SbvN1VxBCrTyd/GbNt+oJOwg1morZShg1nYoZXexqFG0Fvbe9AYsA9/KJtXGsU3cTMJo8JU/GjxAqNMYUOmcZjVQR06ZQyNCyK6Z4rLM4WYtAhep9ttM1lWJRB7MGFqSrmn1D44N9SsMTfy2LihxsVQIr1V7iMbZ7c8jApGsaN3QU2bdY3hN374qC9LrdCBrpKhW6VDb04X7Z
 fLbOpJvB
 gBLDBh8T6KolhbR/ooNDDRdIdV9WSnvW+7ucWNSdn9ZxRNi1ztqDfMnAE6afjOLZbtK+MFtLjgv/7PS8zRiMO5qLg92M2PtLBYKQ/cKDns1Tstm3RdP8J7JzQg7zjYumOK1zJgkmEwTl5wvQxE6oU0gHC7B2aP0fJ33l0BWUshKVR6Oaah85LzW4yprvP+v4ojkFotMAfhDINvp9z+glQKoOaK69Ze5AZH25sKQ/pHVCb00ZuJrp3GLGm1JO6E5P9yPWElgSX3WJrdgtKwW6QIhcHodc0dmWS6+RYtizXvbifIVm5H/fQgGncpfZ0qpMBZU5q3Ef+3P1LQEcqiLQVhacqVOHfw8UCryJSivPUHad0mJpHcVnA2Jx3tbLUGsrfiDeAjCuGPBBfHELDnJO0xP7KH1Jii/QM2Ly1OBH+hNi8kRP+XbSjIk6rYLlrLe5ifF0tl2RMf/eZPEVUwBX0If8dU0Ch5PM7TA2YFUxnf55RCYxceO/9iMDIlyvuuToEQhkxtKrchYoUe2db/dQbhXq6+nM+Bf0PbLfDhBOsjU8+EC2OC32p73ozzqEie41lYBVKe4lQ/i2gpw5SGWEyvSokLdRtLYhEp+IIpLOWLtrottv0yfUGrxe+nSjnzQjFiGHxQ84D3vUYD+nNMNVtu2E7a5N60G3ApdsLkjW9edIguBkvZeUg+OVPVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new_end does not need to be passed in as the data is already being
checked.  This allows for other areas to skip getting the node new_end
in the calling function.

The type was incorrectly void * instead of void __rcu *, which isn't an
issue but is technically incorrect.

Move the variable assignment to after the declarations to clean up the
initial setup.

Ensure there is something to copy before calling memcpy().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 4e6ddcdf9bc62..c6890512e1a22 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3091,20 +3091,28 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
  *
  * Attempts to reuse the node, but may allocate.
  */
-static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
-				     unsigned char new_end)
+static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
-	struct ma_state *mas = wr_mas->mas;
-	void __rcu **dst_slots;
-	unsigned long *dst_pivots;
-	unsigned char dst_offset, offset_end = wr_mas->offset_end;
+	unsigned char dst_offset, offset_end;
+	unsigned char copy_size, node_pivots;
 	struct maple_node reuse, *newnode;
-	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
-	bool in_rcu = mt_in_rcu(mas->tree);
-	unsigned char height = mas_mt_height(mas);
+	unsigned long *dst_pivots;
+	void __rcu **dst_slots;
+	unsigned char new_end;
+	struct ma_state *mas;
+	bool in_rcu;
 
-	if (mas->last == wr_mas->end_piv)
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	offset_end = wr_mas->offset_end;
+	node_pivots = mt_pivots[wr_mas->type];
+	/* Assume last adds an entry */
+	new_end = mas->end + 1 - offset_end + mas->offset;
+	if (mas->last == wr_mas->end_piv) {
 		offset_end++; /* don't copy this offset */
+		new_end--;
+	}
 
 	/* set up node. */
 	if (in_rcu) {
@@ -3118,13 +3126,16 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
 	/* Copy from start to insert point */
-	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
-	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * mas->offset);
+	if (mas->offset) {
+		memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
+		memcpy(dst_slots, wr_mas->slots, sizeof(void __rcu *) * mas->offset);
+	}
 
 	/* Handle insert of new range starting after old range */
 	if (wr_mas->r_min < mas->index) {
 		rcu_assign_pointer(dst_slots[mas->offset], wr_mas->content);
 		dst_pivots[mas->offset++] = mas->index - 1;
+		new_end++;
 	}
 
 	/* Store the new entry and range end. */
@@ -3143,7 +3154,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	/* Copy to the end of node if necessary. */
 	copy_size = mas->end - offset_end + 1;
 	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
-	       sizeof(void *) * copy_size);
+	       sizeof(void __rcu *) * copy_size);
 	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
 	       sizeof(unsigned long) * (copy_size - 1));
 
@@ -3156,7 +3167,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 		struct maple_enode *old_enode = mas->node;
 
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace_node(mas, old_enode, height);
+		mas_replace_node(mas, old_enode, mas_mt_height(mas));
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
@@ -3472,7 +3483,6 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
 	case wr_exact_fit:
@@ -3487,7 +3497,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_slot_store(wr_mas);
 		break;
 	case wr_node_store:
-		mas_wr_node_store(wr_mas, new_end);
+		mas_wr_node_store(wr_mas);
 		break;
 	case wr_spanning_store:
 		mas_wr_spanning_store(wr_mas);
-- 
2.47.3


