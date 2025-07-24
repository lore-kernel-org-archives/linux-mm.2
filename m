Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B81DBC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F948E0093; Thu, 24 Jul 2025 10:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FED48E007C; Thu, 24 Jul 2025 10:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379118E0093; Thu, 24 Jul 2025 10:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 217BC8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:53:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3BA5160405
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:42 +0000 (UTC)
X-FDA: 83699452284.12.10384C4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49B041C000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N3GupxnI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gD7CNhlw;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753368819; a=rsa-sha256;
	cv=pass;
	b=CpWaEJBt3NAI+CkeQ1e31++/ekbM4Sb4ByAU5mCfwFo7Xw8zFm/LeE2Jfbr6BmIO22vJLS
	xGkQybQXKSWTWNjGVCVt1WT4SoUtQCxszQU+uVbSDnAdFD677vp0ft+g/7vFDaaxC/+pS9
	X5F3wCiBOFNzV0Igib70YM707hYQ+yw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N3GupxnI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gD7CNhlw;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pPppDYNRwg9hkc+SFV3hG9FWVLWMGWZwBpfcGwupk3o=;
	b=JiAxuArVQ/8dVaWQLHqAx9IVZR7JFYBLh6UdLv7JSnjCsc0apj6RtKiGRPL8vHOnAsZHa9
	Qki6rqRDNxePKLiqsNCzl/9EGwQoNO0GycebHLexaNJ9E46U53mQjy8nPhuZ/rT9+8W/jP
	B6KZX8l8XUUXopUAdpXSqry3SBKpEk0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56ODRKPC008380;
	Thu, 24 Jul 2025 14:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=pPppDYNRwg9hkc+S
	FV3hG9FWVLWMGWZwBpfcGwupk3o=; b=N3GupxnIYGeEbOFhDvZ5q9vGC/GI5T8K
	qD5zvj9+w5hPqRmmTYEQ/GSmEAvfww/Kuiu/lQuk+LL0eFBk8aYfGPHIOOdOTspQ
	AAflwWs7WRH6WFkCZdHZlhCYM6SIH9mVNLLYFxI2Vi87oBiJUSqFf/DYgvNW0YuX
	8SaLkTgx1icL8FmXnwNzMHyYg77WZ1uzaRKMnp3m/ZPnTWe993ElV9JWy33ShPmK
	KwvW9MaMYckgCVK0iCTIHALSWCpQwb3f26pQqH4UhOl7vDoSOMHkgWuS3SHfQrK3
	QulwqfFtjurwvXPFn6VQZG5kE4uz2jmKzkpZ1Co4KFhS18lYjasGmg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx9tnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 14:53:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ODwVcd005987;
	Thu, 24 Jul 2025 14:53:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbxryq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 14:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TT/NpJhvvO5HdI86yWJlJScrUHlbcorad2JTZfW9sBFCVzYPvQ04+vV/lfy/y005mKjkcRDyvJ1UjgKUstsl9DtkyhTzLGe+4ekWsqfxkmfnN6ZehzDthNSipNn8aDPuvh9bj1hD4DnlCAbrpBK3wFTLZy/Kei3RUoOlUz41gWPUQBR5jFF3QGqEA/tO9nWF6TuaBwyZzaEMeiSU9yeOU82tHG0PQJ7RJ+NFSKTsMPWI0hkhwnVLtKMBO+DF7DtwFVgM2/yzFFhvoA4wUui7fOd838XPbsNsBIYTLp5dqCpLDP/XnJMfNkUSsJWMkdRc/x2tBSz6ANWCA6FhHp6CMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pPppDYNRwg9hkc+SFV3hG9FWVLWMGWZwBpfcGwupk3o=;
 b=reZrfXHsmlPort+fVc+1rsZ5Wy3yfk4JE6MVmU3kraGPrdCggCb75EVUTHY+v8Rm4/srKSR6+Yv1x7d2cdFgYOWqgXQUOyBolGe+sXcY6vy8oY+GG5TGjMOo77qTHygNuvgcbfFollUYi3WtPdR95hIPnwu3w9qpvlw/45ocr4JbJH/HyvnrrLmVFMD++djzzjjIilgWMIVAQW1E7Zg1Em2xZuFXOU1L5wHQOiCplQ6FeDbAsNezMFUE0XuLRXDEcuWSjp2AKing7woxLu44PaUEOfZe4X8JRSNVLd6wD+BrkyWKLn1XGLSWa1fsd31HMR3UXGqIVQbI4YjBF6/nAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPppDYNRwg9hkc+SFV3hG9FWVLWMGWZwBpfcGwupk3o=;
 b=gD7CNhlwqrCY+6jZBtRxKQxsXsirR4m/mzxGFfca8aidRDSQrw9Knkd+iHDentZKTzYSxaB05hY+1zn1zLpnBteR8o1YD9Mm3H5eAAp9BCtR/Lr1JhPGvNKArJ6sxeC47QI/LYu3fs3pCmmOi4aolXPo7Zr+63LvBQeqcDNIu1o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6740.namprd10.prod.outlook.com (2603:10b6:610:144::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 14:53:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 14:53:26 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: remove io-mapping
Date: Thu, 24 Jul 2025 15:53:12 +0100
Message-ID: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf7d53e-b1bc-424b-e409-08ddcac1d864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWhoVEpQN3QyRDBEeVhuM2R3MVpxcW9EVE9Ic1IzdW55UVFPMHJXc0hHNTJx?=
 =?utf-8?B?NW0rOFZFTjVYZFdsK1laeXpOSDJoM1RSQmpUY1JyREhxT2tyNHljUUZVOFR4?=
 =?utf-8?B?ajFoZURXUnJPQzFWUjZKbkpUbWFZSmE3UHczT2ZsRGZVMFYzcE44K1Y0U0sw?=
 =?utf-8?B?RDBWRnFCajgybkJlQlhmbjFVRisraTJFNUFoN3hTSDE3Q0NMSEpqVTBQR3Za?=
 =?utf-8?B?VllHNUZGclpsb0haakhOYkx4cjUrVlNtTXFnUUpkMUpXd3dDdmd2YU5sckNS?=
 =?utf-8?B?RkZhNDhHNlVPbmxWNHBXUTJ5Qk5BMUVJOHdSMTRhL24zbUMrMmg2WWpHM0NN?=
 =?utf-8?B?V1hmcGRzZE9GeENnNWpRY1dnR1Nnb2RmMWJLR1pFNVVkTXNiZTlsOVBIcWpP?=
 =?utf-8?B?VjZ1V2RyYTlTNmJZbWFkWDZhK3JIa2ZzTUhhc0xPVHNodTJmOVJJQTRtVWk2?=
 =?utf-8?B?NkloOTMrMHlXOHJQVzRwbXlSOUlYb2hNUDYxRmU5TGxxeVYvcHhyU1N6NFlm?=
 =?utf-8?B?bGw2aEQ3YTh6bnUvU0RoZ3ZhZGdHZTBqRDVnaW5YYVorN2NzTnBlY2I4UUZL?=
 =?utf-8?B?dnhVTmtydEt1YVNEMGxnd1FPZlJXUWFyclQ1aHdxbGN6dTJlVWR0M3dkOWgx?=
 =?utf-8?B?bWxQVzBUWldOOFo4QlRiTk80bHR6Mm1BOElTaTQwUmswdENLcUIwLzlEOWRG?=
 =?utf-8?B?WGZaTVFMM1RnQ1FTUStubXYzVG1vYUZxbXdmMFRkSkwrL010eWtpQjBQVldY?=
 =?utf-8?B?UVZBZFJrU1RBNUMrdVpUZWs1Tm12eEYzUHdpemtCTWwrU0NHanZpVTVJRzFw?=
 =?utf-8?B?K0hTdXAyamJBY0dPZC9nRThIbWV1aFFMb3RGSDNsZ2VnQkxkYnZWZVZKMkJh?=
 =?utf-8?B?SEh0M3N4QkxuTHZYaXpYbyszS28xWkxtdTZsZHlMK2lsMXdhZktHRTN6NTMx?=
 =?utf-8?B?ZUd5YlpoR0lmRm14QTgwbE5zSjFRMDZKb1ZSMktNRHAwMllaUzFaa1hOemkz?=
 =?utf-8?B?NTM5bkExcWF3dE5qYk04bGFNVlNhOGhodzNldzZXZ0JQVUFMTXN6Z3E4QWJn?=
 =?utf-8?B?MUR3ZTEya1ZzK3JEa2ZVZUtCTW1GaitkL3dMNUZDY0FkT1RWUmVQQXBwRHdQ?=
 =?utf-8?B?djZGSWg4RzFUTGdFZ0NacGhjU1hGREdEUE9wUlc4S3VXMlR0TmxTSlc5SUgv?=
 =?utf-8?B?R2JrOFc0NzM3bXZqSVU5V0VsY2k3WGpLbnhoOS9qb28xR0pJR2dwU3lyUUNT?=
 =?utf-8?B?QS9rT2VML1laQUUrSDQxMkMzUEpUMDdpSmpBVS9iM3k5bnlWYjQ0eXJPNFNE?=
 =?utf-8?B?Uy8zQWZwdEI0SnRUdTVxYTBzMEthV1V3Z2JuQWwxYjVLaEt1ZlZaVW9DS0VC?=
 =?utf-8?B?Y0crRldKeU1xd0V1MkR3MGljcmpicFJKa3RIV0ljaURZRHNLTlNNc05ibFN5?=
 =?utf-8?B?MlhET3ErVmFRTHZZei82bDU0R3pyRmhsbzVRa3JESHYzaGlaT3FmbHc2VkVJ?=
 =?utf-8?B?d1FBVEMwYThOaytpSmlZREEwdTk0UWxSditxY0EvTjRqSi9ETWR4c2RIZVU0?=
 =?utf-8?B?Z25ESHVPZEJYL2dNQXVyZC9UWW9KdTJlaW9CSW5kNWpoYjk5cmJncW9SaDdJ?=
 =?utf-8?B?SCtVbndhYUUyTzh0S2oyZC92OEJNTHVDZmxFWVBWbHN5QzBrVUgwK0hFZXpo?=
 =?utf-8?B?dVAzZ05sVnAxQ0hNQzFNTVZVcU9TckZ6VHgzUS9aRmFDcTl2dU5Ibkc5b2wy?=
 =?utf-8?B?N2lyWmxqbVZMS05ZMXZaeUdIL0dKUGVjVGtCS21mNURTSW1sUDBCZDJ3OVVQ?=
 =?utf-8?B?OE1sdnplREtHUFRyZnVDVTlzSm9HdmoyOUlGWVZNbjJYMC9RYnFVNTRzeWNw?=
 =?utf-8?B?VkhLcmRqUkd6dHJYNTZCcUY5R1lueGdRU1VtYjZabUtiVkFSTVh3d0dhWFVq?=
 =?utf-8?Q?+Iab17qVH5o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGpFbEJzanl3ZVhRZVAyVWJWN2owRmlUbFVNN1NLaVhGM2dqdFFmamhSYXp0?=
 =?utf-8?B?UjFvTXZTek5VVVA0Nkd2eEVWTGVvL2xHWENJaUtlR3lKc2VpUEZXTCtNdldY?=
 =?utf-8?B?T00rWG5LY3dzc3R4aFR1TUJwbU0rb2w3Q3VsSmhqbkpJWnpiVlhtcjBKQmEx?=
 =?utf-8?B?cS9WeWxKNFFmM3pCMHRXZDJxUHBEdmtXbXVqWXo2a1NnRlFzam1ranhBUzRm?=
 =?utf-8?B?OURhdWxPZGNxeVJKZ3JIemp0ZDNEK045WVBDZHJHVlVFdHFlSG8rdzVuZStw?=
 =?utf-8?B?VUdwWE1pRmkxWWU0WGNUdDlJc0JhbjFlaEx5MHZseEd0OVlNS20wb1I5c2E2?=
 =?utf-8?B?d0dnUEpEcGxGQW9KZHZzREUxN2ZpNEplaFpXZndoM28wSTZ3RGZsK01ydk1S?=
 =?utf-8?B?bUc5aTZKNTJpRGM4ZHZyOWhXL09FMFpINzl3MjVrMmF3MG45SG1yazFJNWd4?=
 =?utf-8?B?MWNLbVIydEpyaVE3aGxjN2I5eWJUV281Y3FDSHpxbG1QZEhLNU9yckFqbjBJ?=
 =?utf-8?B?TnNnUmExdUVwUjFlSEsyVjlmaGJUL3ZRYUNHcDZBeGhJTms2eGs5VjlKN29l?=
 =?utf-8?B?NUc5MDRjYlByb1BvTzFNdkwxN3d3YmhrWFpOcGtLSUlHa1U2N0FkWjNWR1hq?=
 =?utf-8?B?TU0rOUQ1VlA1aEE4L3RHVDlscENZV3ZCaTI5QnJmMndWalZuYXlMSUhzay9B?=
 =?utf-8?B?SE5GbWt2cW9jNEtPc20zNmRkNWhJSUxYdjZMdEsvc1BFVlBQSlk5R2JNSmFV?=
 =?utf-8?B?ald2aHRORnN3bFJDVDVnL1NCTTYvbDFpd1l2dXBEZTc0ekc0WS9tWmt4MWVY?=
 =?utf-8?B?bnBjODdwY3N1N2UzN21ITDFWMW0xNk9MYUNNaE5oZVlVYkVkektwOWJCcUJB?=
 =?utf-8?B?Z055RnIxVE9XNi83UmFhd3ZyKy91UEl1allYTlpUSkhQRTcxb2g2SHJhZFNT?=
 =?utf-8?B?Y2xBSE1jajNQQXhOa0VpZ2VrT2M1K3FuNVYyUnR2ZDhKMFU0Znc5a3Q3RU9x?=
 =?utf-8?B?eGJEaVhNWkUvdjVEbG01N3hVajlMbWQ1OVNjRGpHOTFaOGwremx3Vm1mbkxX?=
 =?utf-8?B?QjViNE1qTmJEMmdqV1k3WmpyQ1VhMmF5Y2t2SzRhc2pvSlhmOElON2x1VWxn?=
 =?utf-8?B?cHZkdklCdmc3aDVHWURRYjVmcU1CbU16NW9wRFBOZ2J6eW1SdHVaejZHVTk3?=
 =?utf-8?B?TUh0WkgvNkxOT0VZWVJZWE1wRzhCS29hYmdxK0ZtSXBUNStXVnZSdjdwNnI2?=
 =?utf-8?B?bnhnOXd6V2kxTTNJMmlNTFRCRXVqejBGUUdvRE5yQ2szTE5kamR1TnhNNWtX?=
 =?utf-8?B?VVdoUW1IL2VsZkVSYUE3cUw1MnU0ZUpuKzVKeFEyRCtSVVl5dXFnd0ZCSVRY?=
 =?utf-8?B?RjEyTnZzbnFtd3pMTytSQ2JjREZndmhBRHk4TkFvb0Uzc1ZiSERDdWZyekdL?=
 =?utf-8?B?Z2hXbThvN1NDd01rRTEwZ3BaOFlSNEUxMFhSanBneHgrUjVvektIOFZad0Nz?=
 =?utf-8?B?cUJxQXQ0K015ZVFDVUNydEJmSzkwQXBIRDB6QVRjdjdZaHFwckpURHVFcE9T?=
 =?utf-8?B?K1o4YkNnaDdVbm1wZ0IrTHhpUUZFZjVlS2ozd0V6ZVF1dVEySHFUWEg4V0xr?=
 =?utf-8?B?YnJYRXR0NGxzcEVpbjZEY2dRaGE0QTZTZWwvdmVGQWgybEVLU3grSVFWRjdi?=
 =?utf-8?B?S1pLVEdvYmowQ2NVL29jeHg5NWUyZnZkMjRpemx5RWNGOHVvUG8zODJBRkZF?=
 =?utf-8?B?amVkcyt4ZmxTQVk1YytBNGY1ejJpeFBBMlBERVA2TTFyUUhicm1XSW1NUFhp?=
 =?utf-8?B?V1QxbDdLRGloYktDTkc0OWxOYWV0QzUvb1I1bjJrZlZhSGp0dUM4a0pyYWlp?=
 =?utf-8?B?M3BXUmY4SlpnZzNMQVhkVGVxeEM1S0I2OTl6L0k4b2txbk4zRHNLOHN4R1Z0?=
 =?utf-8?B?aG91RFdIZ0tzRHJmaDRDWW9SeVdYVXJVdndCWjFkZkR0enBicDM3TGJoY2FJ?=
 =?utf-8?B?Skk0MEtBWnlCOTVMdG5qMk9ScWVtVkcyTm5pRTJFbkdlY29URlZDT05KdnFq?=
 =?utf-8?B?WTJCdFlROGh4N2VQamhaVy9CZUpBYTYxYkFzY05tQzVMaXZqYkE5VWo5R1VR?=
 =?utf-8?B?ampHSW1pd2ZsRWFMU0tsWEpoRitBSUZnVkl1c3dNLzZSTk9TMEh5N2FMOUZj?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6aVgoPhltetsi+FqyrBsn4gN6JRdjEFftyjW9NUGjc9euPoak6t/7M/7JC5FMqVa9DUoDY5RTvRaOlsluEpHWyPePFw27O20dGi61xa43jEzMiTZRy4KTLXvngl4/Hf6aWUtFKlPtHniGhEj5nd354cYSnlMDOmggSjojJS8RLlwa/tZ8KSVCzEKAhiR6Olo+iOvi3RvMTZ7hMppTjuJTRhAkrMCzseuTCvZrueIYB32xX/Yasqy3Fe09bgQTHBlrxvd85cgdnd3uyyzhdRZt/A9jUj8ET0xb1YsnUvYZtICigB9EaJQRg6gLglWKtHTWkOc6aiDG3MYILYtLMABhddSkCifkGf2qVDOqml6Lfs3SU8RWPVp/gqOSPqIlAg4HAkxNq/VZLo3XUSdlDRkhN2Q9ze71B12xwy0EgrBM64wSoOFxP35a+nMI/iY2FGNFg3adXAnrA9+uBXTxS1bHyWiP0/GMse4LNwr3PG75licRgVNhHUQ5HUT6LuGdKxG7xkbhdI9gu7r0PeCl8Pq5zgfeor2ldv9q1cjZNlb+Rg+9YXL6aYvDq5/qpF5rPFp0HdwqKuSS1Phw2vZdkqWNYTwr2qRznGhqyLLpyMvb70=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf7d53e-b1bc-424b-e409-08ddcac1d864
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 14:53:26.6348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZAYGG0+piVVssX7hHzpeB4xv2O1gIgfVrjFjZAMJqQIzG3KVVa58sMggJH/NlTm4S8u+uvxu0ZsMDTF8r6mBkzPn4JTk2LZT712chm9Ix8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDExMyBTYWx0ZWRfX0rTsVeWSe0eQ
 o5N8f3TaYMkPtzsTJXXTZVBjE0lxiSh+xW7KM0g5I29RXw7hHAi6WisRF1b5Z0pHZiZlO6yzMKE
 qAxOgPmN0c1WT5WtLBARrgW40O+NKqJH3Pzpr9Q40yBAXFRvRC7LleOJUxRjn3Dg2YZ3EVnumU6
 aMOfIR3fC9FYc2UHgHVnuqN8nc4+bcKzsdKcIpDz4H3+dBULnIiB6H3MgGmLZnVh+l8Zkx3CHu+
 4iILA5/G6V4w+oh9QDe6/hOhe30s0gvkPedyf27XkWC8LPM/WW7x+07k5o0PLJYfe/bl5sVZ8bq
 tecCQQYxC7T3wpTaS295eEU7qota4Eoiy4EwK0+doDcQfNAd6tnMdabnjpK4+EYz/QqVQ82GZh2
 6HJC0Iw5fBjj8rG4NLv6vHELk8nnMeadfRbB2kxo7TYDZEACfHzxHX1GSM1c/aOvykTAl0Om
X-Proofpoint-GUID: 92xK-cPVTd1W1pEtK9h3gqsLnGkc5bEI
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=688248e9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=MhnL__LWAAAA:8 a=rjjMuZ98ym1AblxbKSYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=DArMNfZabhNmbrQIurc0:22
X-Proofpoint-ORIG-GUID: 92xK-cPVTd1W1pEtK9h3gqsLnGkc5bEI
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49B041C000A
X-Stat-Signature: 8dc6wwr7febp4nfg1akiti8ckqrocjh7
X-HE-Tag: 1753368819-672240
X-HE-Meta: U2FsdGVkX18XO6DhJZsT7ByqaeEg9ONAEgyMIAsIeKKSIuEpDJedvfqHUf8BhfBy5MP42qrpni4E+HugzeBnL6Vm4YMkxsb3uYpBxbrNV+HXoloiwAAZ0bteeZdwLMV/Vg0bJuesqFzWbANPa499sfNjptzroyGT8tzZ6KUXAi+446ok6RD7tvexSHLKc3M6LBSytCbWYYnEc8XBEV3VxzP1L5vinoFUiRxk/Hl/QJMqj9iLK81IJq3d2vLrg9HYaGWhshCoWgF+eYYt1LVyl35JsKN6Mpff5PvN7Jkdr0xe8XKgvmt1FEwm1mp/4ugsK/nfC1hCZgaGGc0Q2Rw9iRvaThtw92YAPoB5g0NkuxO4H48i+tnnAbnB6INZbwOTKbqUb4j1xxm5Cny3+xcDpO4jSDhzL64GosOpovPRlELNW722PPO7cd5/bzETGf0tSwjAdFSjf9NJVOZVkZtu4rTdIfQp7R9utUOa6n0Ly/IAqwt8+SP6Bzo8y3qicrogIB9sddYmCU6fzCbG/4YwKd68yclJd8J+YTX6vffx7Q75+ApQ8mwO6nax+t21KBjH+5/zQ2ZGM0Wo1m+vrwMzQE3SK3SpjkxyO1+XXEsppJqch8qe3mh8o2gBIkLFV5RIMauCxtUUAQvLyrdRVFoKBAc56pbGn0jhCli2kog9D57bfafrIjIJ93Dd00deUtnZoNew2g3TYLYMMYH46xszJn6jXdLtK4l2T0N/lylHyX/gCP5MAZ/46iaFYI3s3SbEC+USFrReQhDeyCs180YpuJaekmYl/cEVytUv1xghj3smyTMCk/3DwxTPK75kN7jCTclSwkNSJP4PPX7euZP0Pat6d158EGLAwphk/FHZyRf9XV++gGmsh4nIX9KNiTmadyF7nyTSWO0vdLViBegsF9ihvk3LbTAidyqTtB+S6+KKUOjNNF01DgpbXGLqW0jLBEtCHX/7Wpadv/43yh9
 wIac4NSz
 datSe4FkPeYqc+G/DPsKcmq2NE0+pQkSsIC4ti/qErJEf4AO+i/E2UMkpAqdzQfz0ujuOgKERLyG6viCGPDcKXFTfB1WcA2w3uG8kpmbmrKm6EVrnqnfwLfHRDBLDyWicHmvSaaw802RsNokUE+dShWdA0wlFDudlk5lsVdq8Ot1LEKJMqHcuLBohmbNajaZsDyaEAB239l95vojSmELh6HLx5KSzRZIkJXpDCeq0hssoWSJImuWqBJy8s2scNz5WWpvGp5/qkXnIReGDqW+FY4Pp8Dp8GS82RvTQvq0R0j5mU4SVgCPkmNFFOUD6KFjj1ujc+2kgVvcU4+8ZpBWIpqboiENpJ3mqaK1CvQtdk2ZroPGPmQceyICTjGmx2e5uEI62nqQOL4GCLtNAlRq2uRiL8U+RTHTlv8NZNXVL/Hte9vfBbiZB1xrRcUWHylQfni5g7y70+gKZfpS5oy4n0MEBWTknnyyYIImQ3NJPTvy6BJUS8e6byw3/p1GOlXeklgkGT7jWip8Yen9UzJBXuc9N1F/DumbB8+4n5l9qNAQyVukIY7SllG8uUvWTU+hHnSQ3fgGJ6w/LGRQY/l8N6UgZCsuNdR7Y0oOHpOgD/MO7ZtRgVZHN+PwZ4+Hk9jRizItiwcfdswre88quvO7TtWE3j95sjt4zsOYjBx8HwkY4cvvaea5IxSPDBVZZ2I/md5XVrFnBaMhq6EYcBMJ7GPPS4InJw/A/UQhpUA0tck0A17itp5AdA8WoyUb8uupNSvlMweSeFtcXJAbe0yeDjvh7Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is dead code, which was used from commit b739f125e4eb ("i915: use
io_mapping_map_user") but reverted a month later by commit
0e4fe0c9f2f9 ("Revert "i915: use io_mapping_map_user"") back in 2021.

Since then nobody has used it, so remove it.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/io-mapping.h | 231 -------------------------------------
 mm/Kconfig                 |   4 -
 mm/Makefile                |   1 -
 mm/io-mapping.c            |  30 -----
 4 files changed, 266 deletions(-)
 delete mode 100644 include/linux/io-mapping.h
 delete mode 100644 mm/io-mapping.c

diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
deleted file mode 100644
index 7376c1df9c90..000000000000
--- a/include/linux/io-mapping.h
+++ /dev/null
@@ -1,231 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright © 2008 Keith Packard <keithp@keithp.com>
- */
-
-#ifndef _LINUX_IO_MAPPING_H
-#define _LINUX_IO_MAPPING_H
-
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/bug.h>
-#include <linux/io.h>
-#include <linux/pgtable.h>
-#include <asm/page.h>
-
-/*
- * The io_mapping mechanism provides an abstraction for mapping
- * individual pages from an io device to the CPU in an efficient fashion.
- *
- * See Documentation/driver-api/io-mapping.rst
- */
-
-struct io_mapping {
-	resource_size_t base;
-	unsigned long size;
-	pgprot_t prot;
-	void __iomem *iomem;
-};
-
-#ifdef CONFIG_HAVE_ATOMIC_IOMAP
-
-#include <linux/pfn.h>
-#include <asm/iomap.h>
-/*
- * For small address space machines, mapping large objects
- * into the kernel virtual space isn't practical. Where
- * available, use fixmap support to dynamically map pages
- * of the object at run time.
- */
-
-static inline struct io_mapping *
-io_mapping_init_wc(struct io_mapping *iomap,
-		   resource_size_t base,
-		   unsigned long size)
-{
-	pgprot_t prot;
-
-	if (iomap_create_wc(base, size, &prot))
-		return NULL;
-
-	iomap->base = base;
-	iomap->size = size;
-	iomap->prot = prot;
-	return iomap;
-}
-
-static inline void
-io_mapping_fini(struct io_mapping *mapping)
-{
-	iomap_free(mapping->base, mapping->size);
-}
-
-/* Atomic map/unmap */
-static inline void __iomem *
-io_mapping_map_atomic_wc(struct io_mapping *mapping,
-			 unsigned long offset)
-{
-	resource_size_t phys_addr;
-
-	BUG_ON(offset >= mapping->size);
-	phys_addr = mapping->base + offset;
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
-	else
-		migrate_disable();
-	pagefault_disable();
-	return __iomap_local_pfn_prot(PHYS_PFN(phys_addr), mapping->prot);
-}
-
-static inline void
-io_mapping_unmap_atomic(void __iomem *vaddr)
-{
-	kunmap_local_indexed((void __force *)vaddr);
-	pagefault_enable();
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-	else
-		migrate_enable();
-}
-
-static inline void __iomem *
-io_mapping_map_local_wc(struct io_mapping *mapping, unsigned long offset)
-{
-	resource_size_t phys_addr;
-
-	BUG_ON(offset >= mapping->size);
-	phys_addr = mapping->base + offset;
-	return __iomap_local_pfn_prot(PHYS_PFN(phys_addr), mapping->prot);
-}
-
-static inline void io_mapping_unmap_local(void __iomem *vaddr)
-{
-	kunmap_local_indexed((void __force *)vaddr);
-}
-
-static inline void __iomem *
-io_mapping_map_wc(struct io_mapping *mapping,
-		  unsigned long offset,
-		  unsigned long size)
-{
-	resource_size_t phys_addr;
-
-	BUG_ON(offset >= mapping->size);
-	phys_addr = mapping->base + offset;
-
-	return ioremap_wc(phys_addr, size);
-}
-
-static inline void
-io_mapping_unmap(void __iomem *vaddr)
-{
-	iounmap(vaddr);
-}
-
-#else  /* HAVE_ATOMIC_IOMAP */
-
-#include <linux/uaccess.h>
-
-/* Create the io_mapping object*/
-static inline struct io_mapping *
-io_mapping_init_wc(struct io_mapping *iomap,
-		   resource_size_t base,
-		   unsigned long size)
-{
-	iomap->iomem = ioremap_wc(base, size);
-	if (!iomap->iomem)
-		return NULL;
-
-	iomap->base = base;
-	iomap->size = size;
-	iomap->prot = pgprot_writecombine(PAGE_KERNEL);
-
-	return iomap;
-}
-
-static inline void
-io_mapping_fini(struct io_mapping *mapping)
-{
-	iounmap(mapping->iomem);
-}
-
-/* Non-atomic map/unmap */
-static inline void __iomem *
-io_mapping_map_wc(struct io_mapping *mapping,
-		  unsigned long offset,
-		  unsigned long size)
-{
-	return mapping->iomem + offset;
-}
-
-static inline void
-io_mapping_unmap(void __iomem *vaddr)
-{
-}
-
-/* Atomic map/unmap */
-static inline void __iomem *
-io_mapping_map_atomic_wc(struct io_mapping *mapping,
-			 unsigned long offset)
-{
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
-	else
-		migrate_disable();
-	pagefault_disable();
-	return io_mapping_map_wc(mapping, offset, PAGE_SIZE);
-}
-
-static inline void
-io_mapping_unmap_atomic(void __iomem *vaddr)
-{
-	io_mapping_unmap(vaddr);
-	pagefault_enable();
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
-	else
-		migrate_enable();
-}
-
-static inline void __iomem *
-io_mapping_map_local_wc(struct io_mapping *mapping, unsigned long offset)
-{
-	return io_mapping_map_wc(mapping, offset, PAGE_SIZE);
-}
-
-static inline void io_mapping_unmap_local(void __iomem *vaddr)
-{
-	io_mapping_unmap(vaddr);
-}
-
-#endif /* !HAVE_ATOMIC_IOMAP */
-
-static inline struct io_mapping *
-io_mapping_create_wc(resource_size_t base,
-		     unsigned long size)
-{
-	struct io_mapping *iomap;
-
-	iomap = kmalloc(sizeof(*iomap), GFP_KERNEL);
-	if (!iomap)
-		return NULL;
-
-	if (!io_mapping_init_wc(iomap, base, size)) {
-		kfree(iomap);
-		return NULL;
-	}
-
-	return iomap;
-}
-
-static inline void
-io_mapping_free(struct io_mapping *iomap)
-{
-	io_mapping_fini(iomap);
-	kfree(iomap);
-}
-
-int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, unsigned long size);
-
-#endif /* _LINUX_IO_MAPPING_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index 0287e8d94aea..b7a47bb593d6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1254,10 +1254,6 @@ config KMAP_LOCAL
 config KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
 	bool
 
-# struct io_mapping based helper.  Selected by drivers that need them
-config IO_MAPPING
-	bool
-
 config MEMFD_CREATE
 	bool "Enable memfd_create() system call" if EXPERT
 
diff --git a/mm/Makefile b/mm/Makefile
index 690ddcf7d9a1..e4ab5ca755d1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -142,7 +142,6 @@ obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
-obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
 obj-$(CONFIG_GENERIC_IOREMAP) += ioremap.o
 obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
diff --git a/mm/io-mapping.c b/mm/io-mapping.c
deleted file mode 100644
index d3586e95c12c..000000000000
--- a/mm/io-mapping.c
+++ /dev/null
@@ -1,30 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-
-#include <linux/mm.h>
-#include <linux/io-mapping.h>
-
-/**
- * io_mapping_map_user - remap an I/O mapping to userspace
- * @iomap: the source io_mapping
- * @vma: user vma to map to
- * @addr: target user address to start at
- * @pfn: physical address of kernel memory
- * @size: size of map area
- *
- *  Note: this is only safe if the mm semaphore is held when called.
- */
-int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, unsigned long size)
-{
-	vm_flags_t expected_flags = VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
-
-	if (WARN_ON_ONCE((vma->vm_flags & expected_flags) != expected_flags))
-		return -EINVAL;
-
-	pgprot_t remap_prot = __pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
-				       (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK));
-
-	/* We rely on prevalidation of the io-mapping to skip pfnmap tracking. */
-	return remap_pfn_range_notrack(vma, addr, pfn, size, remap_prot);
-}
-EXPORT_SYMBOL_GPL(io_mapping_map_user);
-- 
2.50.1


