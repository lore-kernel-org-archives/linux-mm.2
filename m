Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D365E81BAA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 12:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50C56B0088; Mon,  9 Feb 2026 07:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAA66B0089; Mon,  9 Feb 2026 07:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B5D66B008C; Mon,  9 Feb 2026 07:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 887046B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 07:10:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CE5713BAF4
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:10:58 +0000 (UTC)
X-FDA: 84424802196.16.C191248
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A55384000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:10:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MIeyOs4P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YEK4KpE9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770639054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DoramIqBon95M4uMPqqTUFlJEVCsY8epak9+7ir1nwY=;
	b=lyHvfH5ypAf19rS1aAQdQdH0N/JObVMu/tto8V2ejRbCk7RteIFIt9jCT78uzyMYaI3+vj
	xAEY8C+Rd8m5p4FTJiVMrV76EScWUj9ikM0ETZvSTIcEmPuSBmBbg4EH3nr8D4poFuavm9
	L3kC24A6nkO6tQ6sBL6a9gh8E/3pLgI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770639054; a=rsa-sha256;
	cv=pass;
	b=Aiust55uHd3Ro1Csjl2r28CdndSBMJUwzSvysI60M2Z52OsBwx5pcgc7Ev/GMwvBZfBEPm
	71rJgzepdu8R2GOs9hCJ6qGA4NmhPZ5aMorOYqpJyAZS2TZmmunVGPZip4tS9W9lO3YJhA
	1Hc1d9q+pTX0SvS8wYpbUyWXzfdi0do=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MIeyOs4P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YEK4KpE9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619BvANJ2699348;
	Mon, 9 Feb 2026 12:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DoramIqBon95M4uMPqqTUFlJEVCsY8epak9+7ir1nwY=; b=
	MIeyOs4Ph8CtvqT1gjnr50qdq1KVdDRU4FrBWuWoRNKd1dSjtlxtv6hyIEI1EuiN
	VM80Cc92T/RHVCuAKaXvxJxdFe+9FLYg4zwT/FYaJLzvtXxpY9MFA/jZYgTaTsdm
	VtBZanzF7ie67jxq3noOwfPH8Zfsm5Zvk45AeFL7qtYKjvwYPUZt8fGySmqlfC0M
	9cNvR5mhKTxD/rnZIdykD+uhijJMnIQtgMgl9f4BhPamElbKmRIz4iLMvq7v4LRZ
	diVucRe8wGh8GLldmrLFpHDWptVD664GwGQDFSAPQun9jwIqw0sp9/oKK4vlXiVs
	D0VwBj4P+gaquXgOUcoPrw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xf3suv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 619AYTNR000510;
	Mon, 9 Feb 2026 12:10:37 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013059.outbound.protection.outlook.com [40.107.201.59])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uucxt2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 12:10:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2XYJ1BIswz07QGVPlbj1wgrVOC3/Ey7ULTRM5cLPWganEPiHuKfujWbYqGYVIpbOhh+E9Bf5oCJPqmk9kVhjpIQG+vK1J9zrXeW5ZceKADWAvJSUvljA0v1mpubtCCq8N01eZzMeBFl0E5rUVKUq0GF9hHl/FbsZ++Q9ktuqlix6F9zRpr1PTWu9DivUNbtywgbKq+bpY74woxyu3DCrju+D/9F81T3aAxaPNHqY0HAGUjaA/7ExJcMRt485fcHU1COw+UlR1olcthE4h8aXwg9AszSUS6UH1kPvMETfOLvIWVCRnVQUZ92UBhYdoxx+eUjTG/bkAy8k9el7OppbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoramIqBon95M4uMPqqTUFlJEVCsY8epak9+7ir1nwY=;
 b=IB0NQnVZ9nff+nfNLyhyMp5V8v8hbjUuDj6LY4J8hRPpaWigUueecHV9GkGWf2cyMp88hyOUqNaj4I336UcVjlYZP92txkBYjhcWEt0pLQAGTIymBM7NeNMPLuZOinj/BuQscqEm/wA1Nj94Hr91OHgTFUg0g3yl4b9YDZ0FlM/VG8K5nIMbZyHt+nID1iieke4FlkZn77sXalKfMDcpr1vc8Sm9lxpWQCZou8GmT2xXaIwcE1OfV7PSSg/UPJFDALzHnQJO71+6rjXKYebWKyysUMFadpNi+mOT5VL0Rg0ZcK7wRhuFfYBqOfOpJM4iu7KCVGOYnxh4CQd6sUvfXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoramIqBon95M4uMPqqTUFlJEVCsY8epak9+7ir1nwY=;
 b=YEK4KpE9k8X3oTQKbpcVPxVef6MBChmJ5PxXhrrq68OM2FbkBdLI5S6fJFDPDs6DdHhy53k+PJ5WHtsQJq4Gx2NDRYlXr01OBww5BejNtBg6MKQfmboYYUjwzeWU2mhAkXxByE0NxFcpJJkRtJ2iyEv+5kdkdHxJEAtqVu3wJS4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS4PPF376CF97B3.namprd10.prod.outlook.com (2603:10b6:f:fc00::d13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 12:10:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 12:10:33 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH 1/2] mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
Date: Mon,  9 Feb 2026 21:10:12 +0900
Message-ID: <20260209121013.50475-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260209121013.50475-1-harry.yoo@oracle.com>
References: <20260209121013.50475-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0048.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS4PPF376CF97B3:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f8c6b12-113d-41ce-b2cd-08de67d43a00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0QHfCitBPV6YH4AgSt0zRERAW5RloNwbGJZPPUjcJ5jFGSSfQJfr9dK8Unos?=
 =?us-ascii?Q?ypxwrLPdCHhrx/MvD2+36Y9WIwSSPrWeuRHkX5mZ9VHpHWbaSnrAH0TZlsMN?=
 =?us-ascii?Q?BkUJGt4EwgKctd88YW/ULXUgD0s71y8MMF93bl5ubyr3/+R3WLqhF+BQwM1c?=
 =?us-ascii?Q?ZMvU70bmzHfFJEt36mYYZQ5YETO8fx2WwKNLGB1w30GVJLCEnKJiQaySBKiH?=
 =?us-ascii?Q?OWIeW5H5AxLOy5OnSc1oJ41082p3lPv4CLhHgVX9EXCwwpjGVImAy5r2pJPf?=
 =?us-ascii?Q?gkZY76bE8IbdRnE+sl0QCG+kCppzJIDGXjNP9/Qs4xM1B8XFBnQ0AmRSvn/+?=
 =?us-ascii?Q?IgNHxF6/H7FiinijcpHZKxZxwnWFYrvdq3Txaw+wZLZI/mVS5doz2uc2b957?=
 =?us-ascii?Q?IQr8xQfxOI0vzhOFSJGSUbU3dXaxRw/93D55xYpkT9VwMeSnubii3UXeRnoU?=
 =?us-ascii?Q?wWDm3jDX1VMPvi+f0S/i4IAAlXq6cWX+2ITImhFQWxMLgZfiKFYto5KPC37x?=
 =?us-ascii?Q?pxMhG8DRfIz05YBbdPD2+EjtmPoQwcY6sEPg1mjsEXH0AXC49mY21/fIoEw8?=
 =?us-ascii?Q?o1ToAxK6EHbifspaykh2J4805H5G7AAVxCqzEq7oT3/3v0Rwh9nT7DkVDnFl?=
 =?us-ascii?Q?ZjId3u5zvGXyOeHr77NICHUSv9QV2kcGp1jjocOOfJvRvaFWLW9XVKM4FOww?=
 =?us-ascii?Q?JyIlkmLUNpxHxDOW0Hcxcaz4FdUoSptn1AjNnKrgPGKACUJIGrQHFQuFcM/P?=
 =?us-ascii?Q?idQrYTSFrNR3DZPSgWPpET43QGkecpnuYia8e71dmdeYVUjtRhU1LBvoNSJ1?=
 =?us-ascii?Q?Sjl8LUmQnaiV2eg/EErB//p2KbT+Do3x+T8cSPq7uuEkq4JsBq16hF/Rby2H?=
 =?us-ascii?Q?z+2yyJ2/N8kPV9Bmea3Uu2ufFyJnNwz+6qm1IYqg1Zz6GHpOWR8rYYOnWC2c?=
 =?us-ascii?Q?ZTcqI7At4XmCIRdxddg6O0fzNPPjmpbC+O6zJY67ktq2BMT8lEitTkAyO/L5?=
 =?us-ascii?Q?HFo1nZoNWUtUC/v97/w80xwv9s8Otw2vDbaW0CnU/BaZMEzwOWoRcjqBEbe4?=
 =?us-ascii?Q?XW9fFdYjqZbUSsnbrQc6a703OcTUQ/CEP2ZGYEiaXx8zZHttI2arWbUjJwbE?=
 =?us-ascii?Q?zUe9UmQmcfTBW3dwzNTmJHgudIZiTsaOS9g6DhZLyxcnz6UrerMM3Q+v0kDW?=
 =?us-ascii?Q?nRCtLO6B+1yHyx+TYJtC8nnt+JNZYeEPhYGIfES47dh5SroiztaLvoBkNoyL?=
 =?us-ascii?Q?IaKNmi2wCRcbfHXdLSG7FOSHzJkld4fnN+kJPtrFu/59xNR5jj/NwoRZQN2A?=
 =?us-ascii?Q?A6U69wc11KgMxgJF5XlDj6icwx4Jr8kz42V06XZfthXTAW6hRJFGp84zWW3S?=
 =?us-ascii?Q?hwwxCDXfMgVdkB1d5iM0re6EbXvU9lIMz8AAC+5EYWo/J1LbGsBvYy8dRuFH?=
 =?us-ascii?Q?zDlfgzEfqV0Ii1qenaec5rIrnnoGYH1T31cVNDTKIUq/55+fND6bjXC+CQaN?=
 =?us-ascii?Q?8/LhuZGigqFVar0yIFkxTrmPFoQkIxl6lHpX/WSyI8vvYoPMLP7LUp8Hebr/?=
 =?us-ascii?Q?nXbDgMMZ5yMP+AA6S08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+F8OUYHKKjcspxs3CO5nEw2I66J+kZ60pTuwdDgZ2na2Gb5gXn5/zdr6IwY5?=
 =?us-ascii?Q?NEz5B75Sb7iRTWXEo4lUDdrAmPwMUNxSlD1L15O7uAX3HyPtpstRL+2HVVW9?=
 =?us-ascii?Q?7+yK/KEVD0ssDsdS36y0c9f8lBGPQGpDg5QURhGI1oPJCKHB2825sLYL1pqe?=
 =?us-ascii?Q?sm2j6SX608eA1JYDctPjc2a+pvKk/KQ6suMfIhQq8mXSiX1MO8wPEM15eEpR?=
 =?us-ascii?Q?9QrfV6NO6+cjEHDQwieQqqF/lpciEmREuNORCquAhlQJ89sMFtHADr7AkjmU?=
 =?us-ascii?Q?HwyQsCi9zZ2NvFun8t8QWRVuNaRwgTVLgSJxlT/y9Kp+3pG2zg3hAknNxJX2?=
 =?us-ascii?Q?FW3egib60IKw0oBHFD9r/lQ/Hxdfpg4VXriUSrHkQRCdCl7sjJGuqlLU8+Bv?=
 =?us-ascii?Q?i8nrLQ3bkwWKY8rpv9gUW3yWPw/0YiefFWRxj6MTKDJVscXL+s+TLvcHE2v3?=
 =?us-ascii?Q?5wb2gmNOIP8BBCSLp3lLjNPYZXQqTHrJ3LQj/8xN59d7j8zYhqCqa7ljlBT1?=
 =?us-ascii?Q?5iQasGKkmN/lkMuOhxYIz9lK8AGokdSRCzgco1XqEe6wJljhgBJSEb8E8ETS?=
 =?us-ascii?Q?XMqfYMMSdf38Gn06ntjNxjc9USlDj5er3vMJLZD4agV/Jr9zkbSvpIA/seZA?=
 =?us-ascii?Q?PIxYfmwk4GIhQfZu0JvRGdVDF6tXnGM7jH/hEyRYUlpBoRlRq81e4DAcwUgG?=
 =?us-ascii?Q?iQb89OR8tWow9y3c8IFvLfErp0P+txbGAI3aAA8qn7Uut1aoNFpyFB74z16B?=
 =?us-ascii?Q?SxKCIWqHzeiy1pWgCwb83YdnFzaLZ9TS/L+sXUvjy+kp37BwLqX7CM/kTp0c?=
 =?us-ascii?Q?RxLL7B9iI3GMbFpUVsqgyWhy7hcwairZe9vU4mA0ZA9FI9YB8o7EoPNRtSw0?=
 =?us-ascii?Q?UMeMhTUcEo7gFV6cFegT1VccmZEMDB7uw+2/QtCDaC3oCdRxiDJ1Kfpd2zsV?=
 =?us-ascii?Q?CYK4lU1N+p6sLm4PYtTZkQkb1TlMnrZxNmpo72JDZMKPlnBNbFnWRTkrdFmU?=
 =?us-ascii?Q?HrmoALhEm/MC3C1dkIm3v2z+MMHtoUYhGKO6QIpP3uMptP2XDiy/1pn62tbT?=
 =?us-ascii?Q?T5EcJFtyQY8cZC9j3Ueyk6dgW8Ly82r/HwYlh+FPgB4NgzV9sGOPoGAfcqyp?=
 =?us-ascii?Q?7gFUSDTAvgxQwTi5PQY4duVcgFaeK0Nb2qNQFqWOolRWqVeQfoIrT2/DG+FF?=
 =?us-ascii?Q?6s8SiyEsZSVDGfJFCBe+e6BYai9reO7FF+BzoVwbNytkJiXE/QRjr44m2GfC?=
 =?us-ascii?Q?GItIXYTUca5gQ3O7q//9VNxiKkOiq7wdYC0QRP8pdxJLowb5RIUK4tihLDUU?=
 =?us-ascii?Q?hA1lysuzNvS2ASKEtF15GgU7APaozCocYWfYHR1YlyZF2B6L2VOz844Jza38?=
 =?us-ascii?Q?VPP/OqKfUpmDKX/o+Ep+uds7h0d4RCurdtT3Vhz3pPorALPdlv8VyU7qobd2?=
 =?us-ascii?Q?7EoW0qi9idKutO4hStQouyVSYJTmaHBbijW3Barc5mI2TP9cYHY+1pTMtcPk?=
 =?us-ascii?Q?1eb/pe/cp6DTlyNIWqatPTX8jZQ4vnvLnwZaOnZgJ9THhK7j5XFZzZI/w3qm?=
 =?us-ascii?Q?MKMqfexJXnmEohKAfCw27grsJFsesDFJnvYa/SSu/Ufy2WFSogsWpyhX4mwJ?=
 =?us-ascii?Q?XCSnj02E7axwZ4Y0nVFF8tO4vHH2MgB0jeZ5RVCy9vf3LBDqf8w2YE92q0ZV?=
 =?us-ascii?Q?BdAKSzMYSVOHTfJTCMeSiyblGShbo19TiCHTk5yS+G2fLSnewz5ZoHIlmt+g?=
 =?us-ascii?Q?o2tmsYZXng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u/DFXeNlmLbOf7eRXo0JtErfZXX2uoAic1C+4onzLODVkahxDQWgJqR3W6/yAtVv/toJ0nnRh2DEfveiJ9JNKn8Jtlb+0gz0Pwd7kjupXIUeoqhSts12OXzbiur28AkqyGIEpCriONGllsqy+R1TLTijRP6U9yHSL2EXp87gJLk6E+JeFmV6beqUjF21pyxeHlrIXcjC20mGLftkqtMqbE0A08GpBDzab7oMKdm3SckgQ+/t4wyCIm6gXSQNnXIGkNeVW1NHvctk2k00k9f8ACEcXUJEIVr+wfqtJl6Uu1tSvlhiRx3xl6XslNOcVpcRnzaJyGc134rcMcVqsH2VojmPjNoDBQ6U2DF+pF2IYlLRYI+6xYxWLRWopNE9Rxc3Sv9pp88xayPG2aEVvbp7NsQ3ZCNFj+UOta4gzCr98pqvSMgyjCng/p5MT/zH1YT4uA2yMdTio1x/80vNCRkksiPm5hkDTLJKS08Z8LFh/TeREurMFYR8efoZyp8m1+FSBPB4O6zn+4X5DCXfKgO4wdf4Dsznav3T59cSz+afCAYruZAsv6PU2Asmx3c1CLTyU0qOGK7NGDcHcgsN38Wkbpfx5xQswXCJEJ5ALRz38mY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8c6b12-113d-41ce-b2cd-08de67d43a00
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 12:10:33.8269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UNrzSNaM7nrDepE6np3ABYgtiUsgYgoAwg7r45T3BRI7jI6BSlCY4CqA3jsFAWAr9uSBWVODrAdNRHH5322LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF376CF97B3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602090101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDEwMiBTYWx0ZWRfXz3QSsyzHYO+o
 wmB0pSh0HQlwoaNik9vgcKjU+TYCLyGUEm7nEvncmoArHrnxvEgA+sXGJrNXJ9Dub6lHqoLTpVd
 Tx0VS9IOKEJKgNNGyAYOxrbwNR+Tz4xpo7sqtg/2X1jsrg62oj7/KwXsuzumUyti057mDowZwOY
 LNfJLm8Dwcy2VyqbA9U8ieWIRY+SvQePnpROGIq7ZD42kj8G9WyAOOG50bs3iGxt8HmGHTMzOfw
 K1vypIj8YQYEMGdJn8HXCAs6nygEBlhukbSpBdGQSFPlKb5cWjg/rm1s3+y9QThM/YmKzOMRl4h
 b+VfREr5W2fRyjCd2nHN+qWW1m5QH8rGF/hYL/kZASzJ+kqF5QTSfeyobKjBaVbBiSckr43MoOX
 aSNIiVUn1zTRmVrnenonLrXkAMizdx6Nbi0Rc/CrMo0slB1dv/D2SM/fhZbFvDTUSGrRZNU7lyX
 AccuTqe+FDErMy05ny1FMMh4kM69fgKkFacY7Xl0=
X-Proofpoint-GUID: 9F2nTAajTjA8o9xkrXS6WMg-m35shnYy
X-Proofpoint-ORIG-GUID: 9F2nTAajTjA8o9xkrXS6WMg-m35shnYy
X-Authority-Analysis: v=2.4 cv=KLNXzVFo c=1 sm=1 tr=0 ts=6989cec7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=MQq_-n8oJk3kAu-yCuYA:9 cc=ntf awl=host:12103
X-Rspamd-Queue-Id: A55384000B
X-Stat-Signature: 36e3u5bbfw3hnxnfsemb5ud4diwgh4q4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770639054-994738
X-HE-Meta: U2FsdGVkX19rc4pSgNSYcCOYNvSHbcZ7Ml4wG4Uxh6bFXjcWt2B7P2gTaOjEPOU25kQaUCssoHy1aPkkeEtJ6b4TdX3dBoQSMx3g8O6O6nBOyIcU9VVyBWlQ7ZkpJeAvDXFe63PaC66ZODIYPMDm1M0z93Ww3ncSFT95pjtq1lLw1TGKzY9jI7teBbbAMNbN7EcLDq745B5lTUcR9PL3jgCTpcS8+rCGxJcNlChmneU+xEfLEE0fR6OcbrubbXuobOhXcETpjeQFZBfRN6xGMbblbdYmVqBx2m49YeOoZJ1Zt+Hip9CohO2DTd+t6SmEuix6+FosOZan0bo2qJFNOswFP7PfbYUpHLiER1ImuBGSZXLQlafyOmd1k+mXyY3ELpejjfUNkOM8eeSyedkEfDjvZhODaHV8wqGz0Dy2gi/jc5M1wtID3lblehMxUXj7HzCOeZEi/Ky8ToxjWvsDoN/3rWC9Yrl/dIM2bLIHFnvbbK9JheDKZ+vvRsnYLWIgJUosKL20HBMcuM9IpvqDWWB+X0ZclEb2pDcGZWZQVZ53myE5r0MKgBL0EA7fzHeMmCESvwQUTip2bicpJdOrLLlZoTtoe3SPOIurmBUm0tLBSkfVBn6wluGKsV8b8k9IJq2EjbAilyxJIpRe/6k91eG5P5B+d6Dc9F3PxF5AbB0wn0fwQ7aezJmYuXZ3PsQJZtwgUueYupyQuw0Aoj0iCER0IwnP/OEGp+Os2h57kcrlkkrptnMguOq3OPMEmbxGVjk8QYI1iG6f4ntdrPD/EDHQTKpQKO9SEsvW8Jbh9Ef9EOxIbMwnSHcFPEB2QRGBPVMz6MTl5vq1kBO+KnAAMkvwYDZqnVJEzxoZlCvD8msdgdtZaDhCb/6MOaR4JJHJLAvSt595t+T//87YCZakyB3GZQqJIkZ9vJxgmX6hMJIwKr+5e/AWckYiVD8Xi1yXfSj72t8pNt5anVuD4JG
 DeJ1y+eg
 HBEQZKSr4zB2GbtIJLiJkOUvSC3tKYLdVtqEyrHrCXOHOkvg1kgAnldcAimS+duPIeqgqL/7jfuIPEKUiWCMCIQcHrgyZO66oieQxFzmzYLd1G846Syqdzu9QaiprRa89/crAxSOJGEAv0WTDmBxPSrGPnsGxcyMHi4qxqpGCEZuV/6WsS+LM4SbSKN+tplM74xb6z5SZm21kTKSjjBfolgQtndK9TMUFcqYfwwgHM4Zll6CjqwcSFll1q0TfqE0MOB4c260A57fBSgriKWW1lGg9HZ51ycrChbyPLvNUcNSHXD7YQx5yhFZItmHpz4v3bw3juMFAijee5j1cWNoQG56cJoefv6tTE34D19Uk2fdpVKjLX07paG4OKHjBd4gT85ggBMo3qAmITWyvPXJxWlOkKkUGOl3MBeWDKLuQ90FzqNKe3s/7r0VGkUfCdwbFYgJxyIWvehUEg6wCVt1lurbv3ppvB07LTFpNRb75ofqgf/c5gvTD8SV6CV6EFMIu35Pgk6tEItbBJH10L+SAeeAhHNumg/V4qQI9elmUDbIT5PcJT7QZ6Z0Ya6llZY1rv4zCskwp+978Kxvqf+eYjtWcgQ3keAU61KE8MtLRW5ahVdMZU+ZGoiuSbTRK1BYJFHN7xWbk5tbDAbB4ugVrwKlAZTUOz1an+VUsFaYUI6FIajhx1SeUB9HSYuHn5GYLER1GAMpWHxyp7o+tyF8negNnzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slab objects that are allocated with kmalloc_nolock() must be freed
using kfree_nolock() because only a subset of alloc hooks are called,
since kmalloc_nolock() can't spin on a lock during allocation.

This imposes a limitation: such objects cannot be freed with kfree_rcu(),
forcing users to work around this limitation by calling call_rcu()
with a callback that frees the object using kfree_nolock().

Remove this limitation by teaching kmemleak to gracefully ignore cases
when kmemleak_free() or kmemleak_ignore() (called by kvfree_call_rcu())
is called without a prior kmemleak_alloc().

Unlike kmemleak, kfence already handles this case, because,
due to its design, only a subset of allocations are served from kfence.

With this change, kfree() and kfree_rcu() can be used to free objects
that are allocated using kmalloc_nolock().

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/rcupdate.h |  4 ++--
 mm/kmemleak.c            | 22 ++++++++++------------
 mm/slub.c                | 21 ++++++++++++++++++++-
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5b30054cd01..72ba681360ad 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1076,8 +1076,8 @@ static inline void rcu_read_unlock_migrate(void)
  * either fall back to use of call_rcu() or rearrange the structure to
  * position the rcu_head structure into the first 4096 bytes.
  *
- * The object to be freed can be allocated either by kmalloc() or
- * kmem_cache_alloc().
+ * The object to be freed can be allocated either by kmalloc(),
+ * kmalloc_nolock(), or kmem_cache_alloc().
  *
  * Note that the allowable offset might decrease in the future.
  *
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..95ad827fcd69 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -837,13 +837,12 @@ static void delete_object_full(unsigned long ptr, unsigned int objflags)
 	struct kmemleak_object *object;
 
 	object = find_and_remove_object(ptr, 0, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Freeing unknown object at 0x%08lx\n",
-			      ptr);
-#endif
+	if (!object)
+		/*
+		 * kmalloc_nolock() -> kfree() calls kmemleak_free()
+		 * without kmemleak_alloc().
+		 */
 		return;
-	}
 	__delete_object(object);
 }
 
@@ -926,13 +925,12 @@ static void paint_ptr(unsigned long ptr, int color, unsigned int objflags)
 	struct kmemleak_object *object;
 
 	object = __find_and_get_object(ptr, 0, objflags);
-	if (!object) {
-		kmemleak_warn("Trying to color unknown object at 0x%08lx as %s\n",
-			      ptr,
-			      (color == KMEMLEAK_GREY) ? "Grey" :
-			      (color == KMEMLEAK_BLACK) ? "Black" : "Unknown");
+	if (!object)
+		/*
+		 * kmalloc_nolock() -> kfree_rcu() calls kmemleak_ignore()
+		 * without kmemleak_alloc().
+		 */
 		return;
-	}
 	paint_it(object, color);
 	put_object(object);
 }
diff --git a/mm/slub.c b/mm/slub.c
index 11a99bd06ac7..63b03fd62ca7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2584,6 +2584,24 @@ struct rcu_delayed_free {
  * Returns true if freeing of the object can proceed, false if its reuse
  * was delayed by CONFIG_SLUB_RCU_DEBUG or KASAN quarantine, or it was returned
  * to KFENCE.
+ *
+ * For objects allocated via kmalloc_nolock(), only a subset of alloc hooks
+ * are invoked, so some free hooks must handle asymmetric hook calls.
+ *
+ * Alloc hooks called for kmalloc_nolock():
+ * - kmsan_slab_alloc()
+ * - kasan_slab_alloc()
+ * - memcg_slab_post_alloc_hook()
+ * - alloc_tagging_slab_alloc_hook()
+ *
+ * Free hooks that must handle missing corresponding alloc hooks:
+ * - kmemleak_free_recursive()
+ * - kfence_free()
+ *
+ * Free hooks that have no alloc hook counterpart, and thus safe to call:
+ * - debug_check_no_locks_freed()
+ * - debug_check_no_obj_freed()
+ * - __kcsan_check_access()
  */
 static __always_inline
 bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
@@ -6368,7 +6386,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 
 /**
  * kfree - free previously allocated memory
- * @object: pointer returned by kmalloc() or kmem_cache_alloc()
+ * @object: pointer returned by kmalloc(), kmalloc_nolock(), or kmem_cache_alloc()
  *
  * If @object is NULL, no operation is performed.
  */
@@ -6387,6 +6405,7 @@ void kfree(const void *object)
 	page = virt_to_page(object);
 	slab = page_slab(page);
 	if (!slab) {
+		/* kmalloc_nolock() doesn't support large kmalloc */
 		free_large_kmalloc(page, (void *)object);
 		return;
 	}
-- 
2.43.0


