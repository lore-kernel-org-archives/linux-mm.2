Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E8AE7315B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 12:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B19F6B0089; Mon,  2 Feb 2026 07:16:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B296B00A5; Mon,  2 Feb 2026 07:16:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFB26B00A6; Mon,  2 Feb 2026 07:16:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFE0D6B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:16:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F8AB1A00E8
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:16:09 +0000 (UTC)
X-FDA: 84399413658.04.809BA73
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3643A18000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 12:16:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SodLoKZp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXbh5BPj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770034566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sot4ij82uhyGg93RkK2QPAH/guPA3+0fJJmvdiKxFx4=;
	b=SHa0OIfeApQf1NVx9TeLcTfgjKGrgWVd8NpTEBuxRCZmkr9Dv4+vsfKvtCpkwo3XuMDpjh
	fuL0MtAOlOhO27r4y2P9f93BAS5Ly9uC4ROrR0L6jEO8zfA/GzKprhUGzG46sz+GZv+q4d
	bRF8rwjEDvQZ1cHWvalR66ChXWQ6Ynk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SodLoKZp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uXbh5BPj;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770034566; a=rsa-sha256;
	cv=pass;
	b=BfKTIasujl8jCCzslQBZ/l7+zpej+hUEcJ+JcgB2y0M6cOJjW+97uZCcPp+i9gRe825Ffm
	CMLR9sfZ8SH0EsQl5vKRw9foHHa1eC5ab3A3sOrzomhJMB6/GcnaNE0vR/ojpHw+9nJbGf
	FNvxNvVxcoDUuodh9EAmRinlV8CYo2k=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uODw1267721;
	Mon, 2 Feb 2026 12:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sot4ij82uhyGg93RkK
	2QPAH/guPA3+0fJJmvdiKxFx4=; b=SodLoKZpWnyeL7tyJrNf0zkXwKC+GK5GUS
	U4aJTTTWbq6SQS/9Dv9WD1TxQeX+8F8k+47Xl41wPefKrIJ6TQGpN/ptwtfRwNBH
	TPLIwyhenCIjZsBvvYiMAe685JUD/nV0IIKzBj1NJzZ572NNuhGWDeNuuBzKN8hm
	UFIkvDPo5p93e3qnvQLHv7GWjy5/XsCPsTfHQ06jW3Yeny9bjJ6i3UeO8OGJerO1
	bOJR2ogx2znATxKllLIKA2d1AJ+TRPQYJLwqnbfdgUp++/AjTF51EsSM8M8wmcDJ
	ah6t2vc16gRJfZ32wLL6+jLimDRrSj7rSR3kj7H8cTULNH4f5uXA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1as3a35p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 12:15:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612AZvaO023854;
	Mon, 2 Feb 2026 12:15:45 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013009.outbound.protection.outlook.com [40.93.201.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c1868b4c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 12:15:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGCdsnRkNpdOOJhZ+M+GKgxMf+heUPheB/1N2FmVwOYzyihOyE/X4YBcvUHi+TIfU8t8L/rKionTxpf0+a/zUKJ5TbFBt14EZ0UCIgtbzWm9Y8Fype3UXpLLA3ljQUQR0Od5tCQ1sKRn0Ha/EZtiD8wQ2pboDd/njgQ0vJgdMD78TTR1gqalBZiAauysZfe77tu31XVoVONvHHDVWq9Toe8ZWOoaGPK7jPr9a2CgIXxOlXM/v52lfMzPU/AGTE/9AQ6Ifofa1Zde9x2EQ3dv0KC9X2KuTBfkSaUxSvT4N4bSHdEkx2dowTeCPzLmhI7jNWIEWOFwPg704iGzX5r3uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sot4ij82uhyGg93RkK2QPAH/guPA3+0fJJmvdiKxFx4=;
 b=Nu6DsSnPLKgjVWcCEOJmq0i06JiphaAhLitTu5zXdse5xHR1CjcSPIPan4D8aUDgl0GjX8+hDPorh+F8UwAKCQP2M+kib7itckGFDZlY5j1ar/IlMZ0I8RroQNeq2l3YF23XghFNR1ag9vHK0MkNNyapvF1CC0qKnsLvbXFE7sbRxcwnZnsP/YYGBT7x3JzrH2eG7kEkx9N2ci/tFMZ3gLuBpWPWTIx+VdXHFw3+/yv9vWJQhqZXl4DOQVqn6Ihj9hrUzLqPWIvcO7LfNfYs1giYJwppC1cve3ngNWaQY3SUKHW18EIl3U/Goacdo8jcWWIaH/pUJjbsJwhYKw5+lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sot4ij82uhyGg93RkK2QPAH/guPA3+0fJJmvdiKxFx4=;
 b=uXbh5BPjztiJiMlJMsfesE6h1Ny5A92YbTV732VwDcEJNK74CXvkinKlbAaNrhf1Q1Jt6FlInb4plzl8L1L2RyvZf9z5BAO/ULxnC8HoEJuS/Mw6EFxNyMH5AysUP/WNKEIae8Z40AVy8aEUu+K41L4uSs90BpiTspKivsHjxIY=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 12:15:39 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 2 Feb 2026
 12:15:39 +0000
Date: Mon, 2 Feb 2026 12:15:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Message-ID: <9033fac5-1dd2-49ab-be34-c68bde36ec11@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
 <20260202005451.774496-2-usamaarif642@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202005451.774496-2-usamaarif642@gmail.com>
X-ClientProxiedBy: LO4P123CA0607.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::9) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MN2PR10MB4303:EE_
X-MS-Office365-Filtering-Correlation-Id: 4093bff5-2ae2-4bea-2bba-08de6254c755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?96Jleuv+hzqGHYXIoDFPcA1E8lOWJdvxACADLNifXV7HvP8WBRAy25mLmUXs?=
 =?us-ascii?Q?TQIQGpJkLUmen/Ih3nRlTqU6hlSoz7sNxI+4Y/FLx7nTz5e94i91mBUBEuTe?=
 =?us-ascii?Q?DD3mGQmob0DWvkv9PkqvpQuSm2pYcd4dFR44JNvyKRmboDR8qFzXd3ejXjV7?=
 =?us-ascii?Q?tfw90mQ8KMwFTOvYgQVZqtvqWUHLtwEZQHBUtQZSD2RvodzjGwHgd+mj5Inc?=
 =?us-ascii?Q?37dL75liQ3myyWJba/3WJJwV4KxLQDPo5kiF2ra5FudIkHehIEOPDWt/J4jU?=
 =?us-ascii?Q?xTz1Lw26RY2VrOAIw68neD6E5U4YizQNaTNa5h684u4EjDP5jtRHZFvmF2hq?=
 =?us-ascii?Q?6XSsWhu3E8d6+ZmyKUYbIkfOgxF1be/SrBGeyBdcaCEyPJwE29XfJNwxCRxH?=
 =?us-ascii?Q?NQLz0P6Vv2hp2VHYrmlnBI3u+WkSh0Lz50Wb+CqdEJFE3IiF9pNiRZRCU4Hu?=
 =?us-ascii?Q?NawQVAqqqtYB22ZRGBWjEXYC5v8jNXm3TZ9KJd/Ta0jXFrRpDohvf9vmRvBb?=
 =?us-ascii?Q?wUES215pmekiZRmuL6o2Pu/2R8I1RUNYMtdMVjLRflNUrm7nHPKGJ3uPyh55?=
 =?us-ascii?Q?1urGlZdWIbfsGvVXfMP9fp5P6u68NPDKHoSrW5JuOcEPwSLntuGubEM1nNZi?=
 =?us-ascii?Q?JePTpg6OWJa1eyMBtK2ZlM6ZZFKb1xsadKQ5UfLueJziwdCCYSN6TWRBH0ED?=
 =?us-ascii?Q?/Y5VXapNiL72+vYCdhmQ6Zw9HrDSx3CGGTZhChH6lIBtTGgDd0ZHrU3kRD+2?=
 =?us-ascii?Q?Nv7sjQMOE0WXtdmHARPCLV300iwkH7dGek5GScmufXUCgK32Vs3zm3M0yFK8?=
 =?us-ascii?Q?vJx809f61dOa46rf6rcyJFK+zv/Tq40g+koz71n15xzwuGuEp574L2Em8Sl1?=
 =?us-ascii?Q?IA+ppKsiHpc+ZC4fMlnmPuolfhxvzpSsLN302su7gm0zZpJDQdT4oE4oxa7e?=
 =?us-ascii?Q?EZ6Ks0Kb7hCKLf7yscLdtiVYwFHWe2dmqiJRLrz3jqZRkAUTF8kTg4HELIjl?=
 =?us-ascii?Q?aMCdEEozEhj5qErAYfDzvObWXRnKaAREnWp/f9Ym7AtEU06bZ02VzV5CEvam?=
 =?us-ascii?Q?DRmX1FKcORdVSYPeaPmdazBp2nQ9DrsbZzPbb2XGRuON0JXwzym+2/R7InlJ?=
 =?us-ascii?Q?UQZqxv9OSTN+kbNbPI+kmCgCpSa7I1I3ew479MCxFf5n5RzIdT8B6t23PGtz?=
 =?us-ascii?Q?EeXUYjHdTQ84vswupoC7whzaBOYP4Th1aTj2WSOEPBx4n/UaLqC+0gFHJ94k?=
 =?us-ascii?Q?2LzAKazPHKXXQFIidmUeIo8VywX0VVvDwLpZHaMDmLFPFvz0Pp2STuRSmnvr?=
 =?us-ascii?Q?7yR/8fRpn1lJQLgXWkEn8Gx7DUpYtO75qRQoKLPPtZXQPY3XaF2L5l0pMBV7?=
 =?us-ascii?Q?oLrIkSDb55YD01XHF8zeuxNWWGpDGMC5WBG0CtfL6vfuzSSVQmcVNaWJ5G8E?=
 =?us-ascii?Q?DjbLNrpdi6M61+8wygSLqBBmc6pASzP6RQuQZ/v8pg/esoQryJh4LtwtvwuA?=
 =?us-ascii?Q?MyVj5RvCkLSox0Py1Ct5gm27aDT+T0/YQCsAGpR0q5nzVQky9cWhKwlOyfR9?=
 =?us-ascii?Q?6kjzQtKmxp2NrPZDEHU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PNLoUFqmIDnpxd/tT9oKHUcPe+vpJL3BysZvZmT7jmUB6eWfpErIahEz3SCJ?=
 =?us-ascii?Q?MRrRZdIsep3bk3vFHFB3jTCy0ugv3Ts02X//dnUrX+io9RIkGlcbARL6cO4J?=
 =?us-ascii?Q?CDEGmZFWtTGOXwbGRtqG9t2QfbZovXY1YPqaSD/ooW623e/2UC0xoIcyXBK8?=
 =?us-ascii?Q?k2Cf4rvq2PvSJAJHOeE5Hj6VhMkNfM2uv/bdPaK83soxVNz4qD1J2EbAu+gc?=
 =?us-ascii?Q?olb3fRtVwgUkRyFJtDqa/Cs38Y1kY3UOWfckvnZd9586xxVByD0q6Vj32A63?=
 =?us-ascii?Q?z3ADYWuMtJPhZKW0vsD8fRsiXxNHbPTaDHvRMESSDhRgS9zEXcKIlvL3DUF4?=
 =?us-ascii?Q?GnWscepwlpLWN5m5pv5sfE+8IopwsIflMIcLn4y9Ht6wJbfSml1/zZMn/ry2?=
 =?us-ascii?Q?8mC6YweRROinDrhhkas0gE+e8hLZZT8DR1NWGUlcavphF4loHIZQQr0FYr6S?=
 =?us-ascii?Q?bTh/EKfDoInVrcbABqwnk2D6Om1/K5Lags/Vy+BsCltF7C1LdToZL/fsp3As?=
 =?us-ascii?Q?5pfIL6aUKEb6xEFaUNnPDLKMDV3hNdV9tgyorIS3AbX3JTUD0F2z62W4+XX9?=
 =?us-ascii?Q?sGCVjdbxPMbY495qu0Lu2UT7zr+9ZfcUG6Eb14cstixsG84k5k//1pAkE8kS?=
 =?us-ascii?Q?qsJ2c/gqPw+L76MW2Rxoy0t4VVS2kb3Ms1EO3h7kX38+s1H5PHrYMuiJCTfX?=
 =?us-ascii?Q?fBeti9KXPJiQri4OByrnfKrrxAWDOv2dqkH4Q1zmYa+yvCc2TXaHGEtgbrp5?=
 =?us-ascii?Q?sxAodb8OySyR++FIF4x6XlQ2ovBYve1LGD3yheX6uh5xs6daMkJsvcqg3sDm?=
 =?us-ascii?Q?jEb1Qu/bP+31OfsfmCIqDsh1NIqdX+QLINHCTSmxmpOdVPqn1eqCE4iwDoj4?=
 =?us-ascii?Q?q35HGpxdEcc7DmUGq9AsFVamss4x8KA3shPUkXWuK7ewBd+iHybsAvQhSPkv?=
 =?us-ascii?Q?JuS+ttSrtyAFpVHJ7ENuf3SSBctKThODRf1ukGwqsTNsr/UjtNqjAni7pjVx?=
 =?us-ascii?Q?lI+sJcjK0ltCmIDKwl/2CyzA81LHwArAtibi6UOhCuL7Bk9Fn+F1HniAlPP6?=
 =?us-ascii?Q?rJe/r4VaxdwXFTSXsHYSK6oPKotwKLXon8Q9QjOSP7VhswMy+l92CkjPemUx?=
 =?us-ascii?Q?UZH0LSjtaqMg6Op+7DLpQyBG4BLOLVCqiUJZlgwek4BtTI5E+vxOh1BMP4vB?=
 =?us-ascii?Q?8KM3fE3YzMHzJ8lmZSaFN30v6JmXSpyM3a8dviN5+rhKCZxZSz+OpZqSucKr?=
 =?us-ascii?Q?hlvKmMnpqmT5x+fyZOGbFBIcoZyqVzsCwEt5aHo5Xw1IrEcl7M8MgRHIIlMa?=
 =?us-ascii?Q?1ELiKqfKhCjw1kE06Fs+644mWn7PUNNnz/ezSK4GALFvfGQe3+L6iNGLSY/8?=
 =?us-ascii?Q?S1Na2r8kwFgZq7B+8ou7/Nan9d+rB2UrS31cYoWL5WcwfNi7c29iX7457gZm?=
 =?us-ascii?Q?IEca9W7rkOdBZyw95f23uJncRDzNilCG3xcACU4jEybkzJO3xyZpXBBL7LH7?=
 =?us-ascii?Q?/Pufmk/gHnvMoNlgrHmTXjj5WgCgMYM7Wqx288WdFrh8H+rfvpVkLkmkvO1w?=
 =?us-ascii?Q?/yKZbE/FEoGPJGirlJ+T3XnnDXsVSZ0IAExB6gRehjznwOb9vZgMa8gVXgc4?=
 =?us-ascii?Q?Pjx71uVMw0c1Bm0tpIVMYAarqO/1CAPqR5qIqbHb4Vbw3d+mVvXJhYmcxp1s?=
 =?us-ascii?Q?QDY0xpDLtAdTyhMzTTlXs7Romf+Qp1isK2LweMbXKxxeP3qJ+vQLMZ4A4ZtQ?=
 =?us-ascii?Q?OACG6YUCnnXmzunD2E/Qmt15lTY9yI4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RCdshF9M9Z2MeaOZyTI5QY+GdFgD3y8Q9nFUAYznXojjX9l+SnjL4QSR1/R1PeuPowSE4ifSlTafZOeu2WmeuT0kmnqUaiBULb+Wmzs3aHcvoqNJFRCZL3iH6iOBQEHKOWYAr9Kyi2OC11l2I+7woDCqVpaHIwBgZ2Or/XdvhskryfGCT11ApNCZKaUDDKg0NzSIqJdAplTlRa3ZMZSWiJ3A+zexeSuESOfnI6I7Tbp1LsOAlTEsPTKI037HtbUUCM/yBk0eT50Eu6fvNOh3bto3PupPePlWeOpSsCQ8iDgs/Xep0QvQFDo3Z5Vw+1Jn7BZJHBVww+X9LQeVCLjjuMpC42DGNSrn1s7DdYTr2PpLq7pCLJTUUQFv4LH6DaZioDt0oL5v4GcxJRFw0E/07JYNhkxEcuJXkJ1/jDjfjesx85d2n+o61WzEIQaHDHU6HPmCq6VUZ6NTCdUfkYA/f3aNa1GjesRQluObrljV619/h5/DzWza7pctMatbte7eJduh59WihhK6ScYF0+LiB79WWYsv6dsg/MdOT6DtsDyRQaxg3M5qxiU6m8Nz6vQv/ieAUPNbVly/j+rjRqTXuKCoUixCdzl7MRgjdTVS6QQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4093bff5-2ae2-4bea-2bba-08de6254c755
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 12:15:39.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0z88404/M8/8saUfwcBnLV91QU/xcJMiAArtC/5NHrrwJA70j7hYJWycxqNPBNd5PU1+KS0X7IJ46A37+pW8h7dYLO+KHXqzVQ4hULAUtmQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020095
X-Proofpoint-ORIG-GUID: 0wXF2KKTNOp2ASMOPtU-GetJbWBQWv9M
X-Authority-Analysis: v=2.4 cv=Sq6dKfO0 c=1 sm=1 tr=0 ts=69809572 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=uVORocJFfuSVfEYRsqsA:9 a=f0c_FN_cfNrMCeP2:21
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 0wXF2KKTNOp2ASMOPtU-GetJbWBQWv9M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA5NSBTYWx0ZWRfX6+fHklnuqlV6
 +/XoihKgrAeshxCGHYXn+Tv2cN18hUtJLiGUa9KUGvcc9/+4lWVo9XWtAR1E6ngQ3rBOHwmrsQt
 TUqYcIEz7fJuJCFi79q1z9fa8n+6OtmqpcMnAEZ98tyrTxBhoRpNDUORTJnnUAtYQ16Fr9cislF
 RBB78U254EIIDZ/A3bXetUQ8zo+K0YbiJP2mq1WGzi/jFtaylI/2XtEkMlqDNANIoDIK0ISS+uZ
 70mQM+31dA9rgeYSnj/pS+C4yZ66Gwlze9E1vIvdP/6jIXZm2zQhGob5BODHAVub0AyQTg3xMVB
 Z0mjsuADAx1bUHyJ47uWK0rIV+Gjsuw0dHgZoKxzXopia+zYMz9+aTQkD7yq+KtMRmqzFtN8XuT
 F0i+Yzx39F11qEz9p02+GfYOBRE2xdnEQ1HWsHH3L8BoHJ+NSryajVHB1VH1sUB8cBQ1/lTr+DO
 OM6nWoNQ18dd+h8ar/A==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3643A18000A
X-Stat-Signature: 89ep6ygqftzsfuecrad3t5bgwgnjyk1d
X-Rspam-User: 
X-HE-Tag: 1770034566-118149
X-HE-Meta: U2FsdGVkX19ViMX0dlqdv9HTlsWhtrkFFWw3uTmyCVJwzq9gkyF1MSbqrclJ/8/PD1rMuceQ0fWPuWEPI6KXuA3veDHQpmBZj8O8o0I6Vdi8uF96EjSnt1fFlfj3Gl6AGQ0In1c0fF8Z+/nDXNCK0giwd8M705+7gOnvqAsWnkpHQyliC1Y3YIqk2j0D0NIYUImVDGIXhH6O5t3YvZO7TiFAso6VDe5q7/dQEXEeo+HOG28UtvYVmQYW/yfk7KOxtFHMHx/lcDzJFXLqKKkcFIsEh/iy0Vmxr/lBlhlY6n+GYZ8QSWJ4eIb/h2Owv+CJBNeo1NDHbuSKZEK0nGQz4fXN6qjpbxGbwDCsDO6+pOB/1HxLngr20xCsgBOITfyaKTDHSKKr3NtUJKfzYN78k/u/JMBj/Lier3jXcqDmHc8vAN7Oe2ZatKKs6jEvSWkrfEvNY0YlOrQ3hYC2nDJTMd8sd/hU7C+Y/1coA1N6vyrnVUkECv23rMxoBNF7tHtGs8bH+Kw9CFS16TZgleMUaMTNU2bew5YzfL0SXC3RfN3DnOQQbigPODDkUAFsfyS+dCF63OqvcTQx8wVwLkgH4sbdTObzACVoIOPeAUbQMblgkWzzJU8ZavcxlRRwWp+WWWBU4D7UJ3aJNDOgLGOHOF0z3cg2S17DQ0AhKEka3PAxiBVz7c3/u/vkrmTjpsU2/2iZoCTYFn7HMcmnDmZ72EvoMsdwtckx0nRYJ1f7DaNKepTzIS/DyS2uCsxAQSPWKXKzC4rjG7r/qK1GgqCe5XVlBv3X1iOSMFsY1GiJ5iSlQN0RT2bEpiTOAS1kaJNdVRq/wgX7L/enbtfo/AQC7e0btAi1ImXfNUKqi9O1EYmMaP4nrM+UvkxTqySiOsmzz0lMYQfKRwH1tXX3lrWPnUy0VCBCV0nIJXHaoq4gtq4iyr4f8MAwXVTTpNO9/3HqqkjkOAPQHPZKSN85W6p
 uSxuzb1K
 DU5jPKzkpF2DwfC0wHW+LnWK5yzrSfjp8ENNZ+4e/voe59D4yqGSfesy1uXENzk9nfTC1J5JmahrPa/M8wUn2JE5yWdohDFsRlTDvvfLPZFGLPzOfXhg+rO6nYo+xlNvcozXEpL/KSmjAPXRQx8I6oJiTAQinnsMqP89LazrlpAN8DHLNHzUb8uOuGPyPRJSfy5Qu1NLQ/qfRAjhA+aHhA5AJS+xUdY+IQpRPqCQ9EvIg+NxBSgw4syAWTF2BbwvF2eKzIPq26nxBD5MmrdYw2caWE85sqTkjmLPpMlhGAMeF5vSrm+yIOosP1ySh5cctV3ISZjtJGoYqN8vAawRSb7WABxU7hL6toFxuZxyN8rgLYz3RGKVySEZ7M3UkiC4zP0/ETmpDpJ0t6qiBfhtHY+bPs0Kyr7EkoMxcUPglQaA/jgncqSk704zzCNSwWVuMGrkA6k6U3O1OaTSIKLdfe7hOPExQJElTSsntcUd4vYwUrFv3PP94WVtN7YRubPM2mKEM0S6LKuTCwM8Ji58aFs6Nhy4P5/mJDdRZd/XN8hhK/ZqNff0KS0Kn1vpas/hEOfPV17iL2UhY2hq9xtwf0Yxf26nIf6i2xLfq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I think I'm going to have to do several passes on this, so this is just a
first one :)

On Sun, Feb 01, 2026 at 04:50:18PM -0800, Usama Arif wrote:
> For page table management, PUD THPs need to pre-deposit page tables
> that will be used when the huge page is later split. When a PUD THP
> is allocated, we cannot know in advance when or why it might need to
> be split (COW, partial unmap, reclaim), but we need page tables ready
> for that eventuality. Similar to how PMD THPs deposit a single PTE
> table, PUD THPs deposit a PMD table which itself contains deposited
> PTE tables - a two-level deposit. This commit adds the deposit/withdraw
> infrastructure and a new pud_huge_pmd field in ptdesc to store the
> deposited PMD.

This feels like you're hacking this support in, honestly. The list_head
abuse only adds to that feeling.

And are we now not required to store rather a lot of memory to keep all of
this coherent?

>
> The deposited PMD tables are stored as a singly-linked stack using only
> page->lru.next as the link pointer. A doubly-linked list using the
> standard list_head mechanism would cause memory corruption: list_del()
> poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
> overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
> tables have their own deposited PTE tables stored in pmd_huge_pte,
> poisoning lru.prev would corrupt the PTE table list and cause crashes
> when withdrawing PTE tables during split. PMD THPs don't have this
> problem because their deposited PTE tables don't have sub-deposits.
> Using only lru.next avoids the overlap entirely.

Yeah this is horrendous and a hack, I don't consider this at all
upstreamable.

You need to completely rework this.

>
> For reverse mapping, PUD THPs need the same rmap support that PMD THPs
> have. The page_vma_mapped_walk() function is extended to recognize and
> handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
> flag tells the unmap path to split PUD THPs before proceeding, since
> there is no PUD-level migration entry format - the split converts the
> single PUD mapping into individual PTE mappings that can be migrated
> or swapped normally.

Individual PTE... mappings? You need to be a lot clearer here, page tables
are naturally confusing with entries vs. tables.

Let's be VERY specific here. Do you mean you have 1 PMD table and 512 PTE
tables reserved, spanning 1 PUD entry and 262,144 PTE entries?

>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

How does this change interact with existing DAX/VFIO code, which now it
seems will be subject to the mechanisms you introduce here?

Right now DAX/VFIO is only obtainable via a specially THP-aligned
get_unmapped_area() + then can only be obtained at fault time.

Is that the intent here also?

What is your intent - that khugepaged do this, or on alloc? How does it
interact with MADV_COLLAPSE?

I noted on the 2nd patch, but you're changing THP_ORDERS_ALL_ANON which
alters __thp_vma_allowable_orders() behaviour, that change belongs here...


> ---
>  include/linux/huge_mm.h  |  5 +++
>  include/linux/mm.h       | 19 ++++++++
>  include/linux/mm_types.h |  5 ++-
>  include/linux/pgtable.h  |  8 ++++
>  include/linux/rmap.h     |  7 ++-
>  mm/huge_memory.c         |  8 ++++
>  mm/internal.h            |  3 ++
>  mm/page_vma_mapped.c     | 35 +++++++++++++++
>  mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
>  mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
>  10 files changed, 260 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfdea..e672e45bb9cc7 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -463,10 +463,15 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  		unsigned long address);
>
>  #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +			   unsigned long address);
>  int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
>  		    unsigned long cp_flags);
>  #else
> +static inline void
> +split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +		      unsigned long address) {}
>  static inline int
>  change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		pud_t *pudp, unsigned long addr, pgprot_t newprot,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab2e7e30aef96..a15e18df0f771 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3455,6 +3455,22 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
>   * considered ready to switch to split PUD locks yet; there may be places
>   * which need to be converted from page_table_lock.
>   */
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +static inline struct page *pud_pgtable_page(pud_t *pud)
> +{
> +	unsigned long mask = ~(PTRS_PER_PUD * sizeof(pud_t) - 1);
> +
> +	return virt_to_page((void *)((unsigned long)pud & mask));
> +}
> +
> +static inline struct ptdesc *pud_ptdesc(pud_t *pud)
> +{
> +	return page_ptdesc(pud_pgtable_page(pud));
> +}
> +
> +#define pud_huge_pmd(pud) (pud_ptdesc(pud)->pud_huge_pmd)
> +#endif
> +
>  static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
>  {
>  	return &mm->page_table_lock;
> @@ -3471,6 +3487,9 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
>  static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
>  {
>  	__pagetable_ctor(ptdesc);
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +	ptdesc->pud_huge_pmd = NULL;
> +#endif
>  }
>
>  static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 78950eb8926dc..26a38490ae2e1 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -577,7 +577,10 @@ struct ptdesc {
>  		struct list_head pt_list;
>  		struct {
>  			unsigned long _pt_pad_1;
> -			pgtable_t pmd_huge_pte;
> +			union {
> +				pgtable_t pmd_huge_pte;  /* For PMD tables: deposited PTE */
> +				pgtable_t pud_huge_pmd;  /* For PUD tables: deposited PMD list */
> +			};
>  		};
>  	};
>  	unsigned long __page_mapping;
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 2f0dd3a4ace1a..3ce733c1d71a2 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1168,6 +1168,14 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>  #define arch_needs_pgtable_deposit() (false)
>  #endif
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +extern void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> +					   pmd_t *pmd_table);
> +extern pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp);
> +extern void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable);
> +extern pgtable_t pud_withdraw_pte(pmd_t *pmd_table);

These are useless extern's.

> +#endif
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  /*
>   * This is an implementation of pmdp_establish() that is only suitable for an
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d9..08cd0a0eb8763 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -101,6 +101,7 @@ enum ttu_flags {
>  					 * do a final flush if necessary */
>  	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
>  					 * caller holds it */
> +	TTU_SPLIT_HUGE_PUD	= 0x100, /* split huge PUD if any */
>  };
>
>  #ifdef CONFIG_MMU
> @@ -473,6 +474,8 @@ void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
>  	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
>  void folio_add_anon_rmap_pmd(struct folio *, struct page *,
>  		struct vm_area_struct *, unsigned long address, rmap_t flags);
> +void folio_add_anon_rmap_pud(struct folio *, struct page *,
> +		struct vm_area_struct *, unsigned long address, rmap_t flags);
>  void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
>  		unsigned long address, rmap_t flags);
>  void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
> @@ -933,6 +936,7 @@ struct page_vma_mapped_walk {
>  	pgoff_t pgoff;
>  	struct vm_area_struct *vma;
>  	unsigned long address;
> +	pud_t *pud;
>  	pmd_t *pmd;
>  	pte_t *pte;
>  	spinlock_t *ptl;
> @@ -970,7 +974,7 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
>  static inline void
>  page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>  {
> -	WARN_ON_ONCE(!pvmw->pmd && !pvmw->pte);
> +	WARN_ON_ONCE(!pvmw->pud && !pvmw->pmd && !pvmw->pte);
>
>  	if (likely(pvmw->ptl))
>  		spin_unlock(pvmw->ptl);
> @@ -978,6 +982,7 @@ page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
>  		WARN_ON_ONCE(1);
>
>  	pvmw->ptl = NULL;
> +	pvmw->pud = NULL;
>  	pvmw->pmd = NULL;
>  	pvmw->pte = NULL;
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21a..3128b3beedb0a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2933,6 +2933,14 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  	spin_unlock(ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  }
> +
> +void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
> +			   unsigned long address)
> +{
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PUD_SIZE));
> +	if (pud_trans_huge(*pud))
> +		__split_huge_pud_locked(vma, pud, address);
> +}
>  #else
>  void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
>  		unsigned long address)
> diff --git a/mm/internal.h b/mm/internal.h
> index 9ee336aa03656..21d5c00f638dc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -545,6 +545,9 @@ int user_proactive_reclaim(char *buf,
>   * in mm/rmap.c:
>   */
>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address);
> +#endif
>
>  /*
>   * in mm/page_alloc.c
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index b38a1d00c971b..d31eafba38041 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -146,6 +146,18 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
>  	return true;
>  }
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/* Returns true if the two ranges overlap.  Careful to not overflow. */
> +static bool check_pud(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
> +{
> +	if ((pfn + HPAGE_PUD_NR - 1) < pvmw->pfn)
> +		return false;
> +	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
> +		return false;
> +	return true;
> +}
> +#endif
> +
>  static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
>  {
>  	pvmw->address = (pvmw->address + size) & ~(size - 1);
> @@ -188,6 +200,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  	pud_t *pud;
>  	pmd_t pmde;
>
> +	/* The only possible pud mapping has been handled on last iteration */
> +	if (pvmw->pud && !pvmw->pmd)
> +		return not_found(pvmw);
> +
>  	/* The only possible pmd mapping has been handled on last iteration */
>  	if (pvmw->pmd && !pvmw->pte)
>  		return not_found(pvmw);
> @@ -234,6 +250,25 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			continue;
>  		}
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD

Said it elsewhere, but it's really weird to treat an arch having the
ability to do something as a go ahead for doing it.

> +		/* Check for PUD-mapped THP */
> +		if (pud_trans_huge(*pud)) {
> +			pvmw->pud = pud;
> +			pvmw->ptl = pud_lock(mm, pud);
> +			if (likely(pud_trans_huge(*pud))) {
> +				if (pvmw->flags & PVMW_MIGRATION)
> +					return not_found(pvmw);
> +				if (!check_pud(pud_pfn(*pud), pvmw))
> +					return not_found(pvmw);
> +				return true;
> +			}
> +			/* PUD was split under us, retry at PMD level */
> +			spin_unlock(pvmw->ptl);
> +			pvmw->ptl = NULL;
> +			pvmw->pud = NULL;
> +		}
> +#endif
> +

Yeah, as I said elsewhere, we got to be refactoring not copy/pasting with
modifications :)


>  		pvmw->pmd = pmd_offset(pud, pvmw->address);
>  		/*
>  		 * Make sure the pmd value isn't cached in a register by the
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index d3aec7a9926ad..2047558ddcd79 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
>  }
>  #endif
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/*
> + * Deposit page tables for PUD THP.
> + * Called with PUD lock held. Stores PMD tables in a singly-linked stack
> + * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
> + *
> + * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
> + * list_head. This is because lru.prev (offset 16) overlaps with
> + * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
> + * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.

This is horrible and feels like a hack? Treating a doubly-linked list as a
singly-linked one like this is not upstreamable.

> + *
> + * PTE tables should be deposited into the PMD using pud_deposit_pte().
> + */
> +void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
> +				    pmd_t *pmd_table)

This is a horrid, you're depositing the PMD using the... questionable
list_head abuse, but then also have pud_deposit_pte()... But here we're
depositing a PMD shouldn't the name reflect that?

> +{
> +	pgtable_t pmd_page = virt_to_page(pmd_table);
> +
> +	assert_spin_locked(pud_lockptr(mm, pudp));
> +
> +	/* Push onto stack using only lru.next as the link */
> +	pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);

Yikes...

> +	pud_huge_pmd(pudp) = pmd_page;
> +}
> +
> +/*
> + * Withdraw the deposited PMD table for PUD THP split or zap.
> + * Called with PUD lock held.
> + * Returns NULL if no more PMD tables are deposited.
> + */
> +pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
> +{
> +	pgtable_t pmd_page;
> +
> +	assert_spin_locked(pud_lockptr(mm, pudp));
> +
> +	pmd_page = pud_huge_pmd(pudp);
> +	if (!pmd_page)
> +		return NULL;
> +
> +	/* Pop from stack - lru.next points to next PMD page (or NULL) */
> +	pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;

Where's the popping? You're just assigning here.

> +
> +	return page_address(pmd_page);
> +}
> +
> +/*
> + * Deposit a PTE table into a standalone PMD table (not yet in page table hierarchy).
> + * Used for PUD THP pre-deposit. The PMD table's pmd_huge_pte stores a linked list.
> + * No lock assertion since the PMD isn't visible yet.
> + */
> +void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable)
> +{
> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> +
> +	/* FIFO - add to front of list */
> +	if (!ptdesc->pmd_huge_pte)
> +		INIT_LIST_HEAD(&pgtable->lru);
> +	else
> +		list_add(&pgtable->lru, &ptdesc->pmd_huge_pte->lru);
> +	ptdesc->pmd_huge_pte = pgtable;
> +}
> +
> +/*
> + * Withdraw a PTE table from a standalone PMD table.
> + * Returns NULL if no more PTE tables are deposited.
> + */
> +pgtable_t pud_withdraw_pte(pmd_t *pmd_table)
> +{
> +	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
> +	pgtable_t pgtable;
> +
> +	pgtable = ptdesc->pmd_huge_pte;
> +	if (!pgtable)
> +		return NULL;
> +	ptdesc->pmd_huge_pte = list_first_entry_or_null(&pgtable->lru,
> +							struct page, lru);
> +	if (ptdesc->pmd_huge_pte)
> +		list_del(&pgtable->lru);
> +	return pgtable;
> +}
> +#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
> +
>  #ifndef __HAVE_ARCH_PMDP_INVALIDATE
>  pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
>  		     pmd_t *pmdp)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 7b9879ef442d9..69acabd763da4 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -811,6 +811,32 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
>  	return pmd;
>  }
>
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> +/*
> + * Returns the actual pud_t* where we expect 'address' to be mapped from, or
> + * NULL if it doesn't exist.  No guarantees / checks on what the pud_t*
> + * represents.
> + */
> +pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address)

This series seems to be full of copy/paste.

It's just not acceptable given the state of THP code as I said in reply to
the cover letter - you need to _refactor_ the code.

The code is bug-prone and difficult to maintain as-is, your series has to
improve the technical debt, not add to it.

> +{
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud = NULL;
> +
> +	pgd = pgd_offset(mm, address);
> +	if (!pgd_present(*pgd))
> +		goto out;
> +
> +	p4d = p4d_offset(pgd, address);
> +	if (!p4d_present(*p4d))
> +		goto out;
> +
> +	pud = pud_offset(p4d, address);
> +out:
> +	return pud;
> +}
> +#endif
> +
>  struct folio_referenced_arg {
>  	int mapcount;
>  	int referenced;
> @@ -1415,11 +1441,7 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>  			SetPageAnonExclusive(page);
>  			break;
>  		case PGTABLE_LEVEL_PUD:
> -			/*
> -			 * Keep the compiler happy, we don't support anonymous
> -			 * PUD mappings.
> -			 */
> -			WARN_ON_ONCE(1);
> +			SetPageAnonExclusive(page);
>  			break;
>  		default:
>  			BUILD_BUG();
> @@ -1503,6 +1525,31 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
>  #endif
>  }
>
> +/**
> + * folio_add_anon_rmap_pud - add a PUD mapping to a page range of an anon folio
> + * @folio:	The folio to add the mapping to
> + * @page:	The first page to add
> + * @vma:	The vm area in which the mapping is added
> + * @address:	The user virtual address of the first page to map
> + * @flags:	The rmap flags
> + *
> + * The page range of folio is defined by [first_page, first_page + HPAGE_PUD_NR)
> + *
> + * The caller needs to hold the page table lock, and the page must be locked in
> + * the anon_vma case: to serialize mapping,index checking after setting.
> + */
> +void folio_add_anon_rmap_pud(struct folio *folio, struct page *page,
> +		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
> +{
> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
> +	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
> +	__folio_add_anon_rmap(folio, page, HPAGE_PUD_NR, vma, address, flags,
> +			      PGTABLE_LEVEL_PUD);
> +#else
> +	WARN_ON_ONCE(true);
> +#endif
> +}

More copy/paste... Maybe unavoidable in this case, but be good to try.

> +
>  /**
>   * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
>   * @folio:	The folio to add the mapping to.
> @@ -1934,6 +1981,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		}
>
>  		if (!pvmw.pte) {
> +			/*
> +			 * Check for PUD-mapped THP first.
> +			 * If we have a PUD mapping and TTU_SPLIT_HUGE_PUD is set,
> +			 * split the PUD to PMD level and restart the walk.
> +			 */

This is literally describing the code below, it's not useful.

> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> +				if (flags & TTU_SPLIT_HUGE_PUD) {
> +					split_huge_pud_locked(vma, pvmw.pud, pvmw.address);
> +					flags &= ~TTU_SPLIT_HUGE_PUD;
> +					page_vma_mapped_walk_restart(&pvmw);
> +					continue;
> +				}
> +			}
> +
>  			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
>  				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>  					goto walk_done;
> @@ -2325,6 +2386,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  	mmu_notifier_invalidate_range_start(&range);
>
>  	while (page_vma_mapped_walk(&pvmw)) {
> +		/* Handle PUD-mapped THP first */

How did/will this interact with DAX, VFIO PUD THP?

> +		if (!pvmw.pte && !pvmw.pmd) {
> +#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD

Won't pud_trans_huge() imply this...

> +			/*
> +			 * PUD-mapped THP: skip migration to preserve the huge
> +			 * page. Splitting would defeat the purpose of PUD THPs.
> +			 * Return false to indicate migration failure, which
> +			 * will cause alloc_contig_range() to try a different
> +			 * memory region.
> +			 */
> +			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
> +				page_vma_mapped_walk_done(&pvmw);
> +				ret = false;
> +				break;
> +			}
> +#endif
> +			/* Unexpected state: !pte && !pmd but not a PUD THP */
> +			page_vma_mapped_walk_done(&pvmw);
> +			break;
> +		}
> +
>  		/* PMD-mapped THP migration entry */
>  		if (!pvmw.pte) {
>  			__maybe_unused unsigned long pfn;
> @@ -2607,10 +2689,10 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
>
>  	/*
>  	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
> -	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
> +	 * TTU_SPLIT_HUGE_PMD, TTU_SPLIT_HUGE_PUD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
>  	 */
>  	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
> -					TTU_SYNC | TTU_BATCH_FLUSH)))
> +					TTU_SPLIT_HUGE_PUD | TTU_SYNC | TTU_BATCH_FLUSH)))
>  		return;
>
>  	if (folio_is_zone_device(folio) &&
> --
> 2.47.3
>

This isn't a final review, I'll have to look more thoroughly through here
over time and you're going to have to be patient in general :)

Cheers, Lorenzo

