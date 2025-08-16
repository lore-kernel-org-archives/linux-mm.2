Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E5DCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 08:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB788E000E; Sat, 16 Aug 2025 04:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66BA98E000B; Sat, 16 Aug 2025 04:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE8D8E000E; Sat, 16 Aug 2025 04:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 283F18E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:06:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF391C03BE
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:06:11 +0000 (UTC)
X-FDA: 83781887742.28.6689915
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 38D0414000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:06:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M3LWys70;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h91hx1el;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755331568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqChrVb1H77xzTHbjqLOLGkSYfqLC6t9MKzZJ7IjW1Q=;
	b=H7ZwbxGKlHjk2Fm4BG9IdOxyLzxZmd7lQdlAnbe7BKwEN0Lbw7lGC45EYcmf8VbPD4A+OX
	Bb2Qiz1nFpuWACMCFcwh/TVcVCKHgsgDafMZsfL9QqUDTuFqfSsIXRShCt0A8w+MDajU7A
	r3DSEfx57EVYpggHhhmAV8QyjFnb8s4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M3LWys70;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=h91hx1el;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755331568; a=rsa-sha256;
	cv=pass;
	b=tZnfZMp8iaJMzY3knBA6hZkXRALpyziY99t+yYiBZOQ7cqNitdDJ6P3H5CjYteRPap0tzM
	YPOuuaVimurPUnUwjU3G6nLxEAo86LB2q/iHbsVLsnHIorzNlskIErkNpMiQEXYPuAL1a5
	gmtLEJg1d39MaChQJgSIVkr5ng+5bV4=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G3ghX2012778;
	Sat, 16 Aug 2025 08:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iqChrVb1H77xzTHbjq
	LOLGkSYfqLC6t9MKzZJ7IjW1Q=; b=M3LWys7025VuUHB30QXx2a5MH0S0UzyHrb
	L7Tgt+f4T7NyG463cKDYhFWgGP1+6cMf4DJpc82lXF4Gi3uXRUMp1caSw3vLEKYW
	2GCKkAIhSFjsDtpsQwV5HBLkndyUdoy3YOHuy5FKApf2Rm3lkw7Y0139p7bjgIed
	3iNd7QX80pEEQqKFvDYlfxSNq9CDGvraKWdtV/qLtFCmoEqviyAtYkdiTc7sUVpL
	rOcdxDVCkSWCW3hEDHJjiJn2gMfJdBfsdNy1kn9ff0aIf0v6lYVt7/z3XzUPrdRa
	gzrmf3DvAWX1dh3cLjinTKgKwEgHoasDuAIou9Pcfq/Le3iQdHHg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhvd86t6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 08:06:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57G559Ym026169;
	Sat, 16 Aug 2025 08:05:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge6yhn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 08:05:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoiPqHyQ9jHAtac5tdXtP9XJIZfdRY+kkXRWu7rRq1AUgGN0cGy/tplPdrSuINqszF220dLRdDR/yPlWrC49upLC3CX4f/vGWYa1bDRoY4YLqwJJsxuMMyWbxOPp+PsLOkUlNxWDlZbkdLCYGSats5Mo6EuflKFYKyi1ADf5mHRAroRK6xL4692yrZOghF0nLMtdQQQxQhUjHq2BwoWUr1dxEiKieg91g2suQ5h8M7m21dEhTeN8GXPbhXVRCXoSncATPbpQebmmIGH0SCZujH9Oo3mXLc7ol2IYo+tb4h4logHSE4ejkX5HG9pvYBi8hEKGtdQZc8Xyw0DU7jpX8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqChrVb1H77xzTHbjqLOLGkSYfqLC6t9MKzZJ7IjW1Q=;
 b=fl4tM2xXH4Lz117WcTkdUQZq/SaEjZp2BTHJ4WWhBDE/mri+Qa0naRmOmQ7DTUPL+t1RNUlUWwfBuuZUFT8x5VXh7uY9JC/UbLcSCFAwDNtDD98fqGB20/NABvtIP1ffHKyUkyXW9RnXYn0Pfx02grOAD8q0GoyY29go3hCBJLVpi4iTDooFyNRMB77/nquI6ONr/zfpMTW0F+qpUEucsOYHFTsxbVJgUGxpNKp65gKjSF81HtlKpi/zeIP2X8cs7k65IouZIInj94ir6SZBRfRq1WiBKpdcKo0cbRQjzuMsCeNm6/iCSJ5iKcuvkGQSZCbck0r66C2zqnBmRU0Efg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqChrVb1H77xzTHbjqLOLGkSYfqLC6t9MKzZJ7IjW1Q=;
 b=h91hx1el+LZ4lLxisz0O6EbsRgQJELXFmcN+OfhrBOxjVant4FtZ1IgtayK06ealUSMJ3TuJ+CabH40EX86QTq+Ftncs4scsG1cmpM8dUbKA63phAlo6wqeusjLXjl8i6vYZrr5+d3YSNXnaZS9iC0Iz4PH/Q8G5cxZeEp0oIzI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5004.namprd10.prod.outlook.com (2603:10b6:610:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Sat, 16 Aug
 2025 08:05:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9031.018; Sat, 16 Aug 2025
 08:05:53 +0000
Date: Sat, 16 Aug 2025 17:05:43 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Sudarsan Mahendran <sudarsanm@google.com>
Cc: vbabka@suse.cz, Liam.Howlett@oracle.com, cl@gentwo.org, howlett@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        maple-tree@lists.infradead.org, rcu@vger.kernel.org,
        rientjes@google.com, roman.gushchin@linux.dev, surenb@google.com,
        urezki@gmail.com
Subject: Re: [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <aKA7180s0HdLfOKc@harry>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250815225259.3012455-2-sudarsanm@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815225259.3012455-2-sudarsanm@google.com>
X-ClientProxiedBy: SEWP216CA0043.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bd::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: cfdffc14-9f8b-4b11-20bb-08dddc9bb86b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5YNgwkg4OG5ynM/yRmNpDeIFWBgfjxltnuVL/dlWVAmDEgCNB9DtNo8O888S?=
 =?us-ascii?Q?GizA37NnB8WGY3k+6TcaPk31jLdNiK+xOZ27rq+ldbMov60TRHXHqmb2P1m+?=
 =?us-ascii?Q?dSDjtWeYHiu31TZO4K+uLNgO0dn7NnUCnyGMDEnpKgT9iqvWFgAimpsCNYj+?=
 =?us-ascii?Q?1Mn1QRUVg5W9AX/jjCuxHjtQsr31jgElBFwSknQM4vtzFdyvekb+VJ3bxyYm?=
 =?us-ascii?Q?F5l8ERbNy3ojE1NaVtTaW/Cv2eoSrLDddyVVjRCn7fb1RpedZ3H7B4mcQb5h?=
 =?us-ascii?Q?ZFvcBZioIloiSRt0J2be5Fk8vybne13F0M7MejlgdbwuSOQ26UVkdcQWWO1r?=
 =?us-ascii?Q?w3HKTSrQVgHknoA5nbNA2nJtu0mFcd+CgaqJFgWB0OUB7B0PREPiDct3lbTe?=
 =?us-ascii?Q?xNpgGkq1coipBCHB5WZfZSSePLQcuU6vczvWCGoV/9PQDr0gEwtmiFota6xw?=
 =?us-ascii?Q?T/E+FTUKfwR3Fq4Xr6haaAdcC4pfUGsXzdXeDFNZx+yogfF0IiHQ6fi0egne?=
 =?us-ascii?Q?zdDZgI+DJwU8FaBbGYfZIBVqD2wy4RvKYu+p9KHbN3qtbC7x0U40xf+RfaH3?=
 =?us-ascii?Q?6NoaCR6WXJh+xD8BESzPlAItz92KxUPLRtBRu6PVJFyc61WHLB/gZ+gaQgl6?=
 =?us-ascii?Q?YaVzNkwKhYZVzU3nAP9RbWwNx3qoGIYo8WcGwrHMVDVgrkCz3QKYiCs1UOQ9?=
 =?us-ascii?Q?lfl/AlULhQ67VDkcX5mYoU816cqa1oAXlxE+TfSmlPsob3QcsfNRQ0Ioz2Vj?=
 =?us-ascii?Q?I4BNin1QD0CiRZNMMZm3np/rFXpNkQxtItXbKuF8uWcoqFA1z0OxEYmVZ/hy?=
 =?us-ascii?Q?rPl5rtRNs+znbP1puz2+5CV48Og607yKQEs9WZq6wqcqWZoQXu3jL5qX9pWN?=
 =?us-ascii?Q?vrs4ycUGDwFNWpP+JCt0ejFgIlbIFmVWu0y32pNCam3G4SRhGUp0lJ9gLxhY?=
 =?us-ascii?Q?ZsmQR9RjEVH6uN5N/gQmgvAD92i12qiK+HxHNLBt4g6GFlcAGdArqK6arvGm?=
 =?us-ascii?Q?nxxnzbVq0hQ03RXSOizuSWgeGyId3OZQ9Sy3hpgmVS9RN22MpMVp42Eev4+3?=
 =?us-ascii?Q?dUX9PhtJ/KnKOTxg2H/qyUpK1tx6dl8dBfgc3bEZwY5Jx0f2+cb34mx7NkMr?=
 =?us-ascii?Q?6ju8g5DYniwshKnz1f0xdVwOG/DU3xWfPXh29U0mBAkCSy2NFjecnNaiG6ho?=
 =?us-ascii?Q?g3FVgICKG6A58ROuoUh5rFgaUhKxkQpf1+ALe1nGolOyRxHONPlP/dcfnMnh?=
 =?us-ascii?Q?lD7gdNyZdcIKEZmfnuk4mGHfODjmRLHS2PHHjhfv36b4loJB3sVpPlV2KBJE?=
 =?us-ascii?Q?XV991djD73LOlPFm3Jp4bg3BCPvHsFrp8v0J8laSTTKt/KzHmrVB3XNDBjMx?=
 =?us-ascii?Q?udZPKkv2URa7+Um4pTvmcjj8O6A+JROqGcQ7pqSF08x5g2hWJdvRwva5O/Z9?=
 =?us-ascii?Q?sOYtlRdENDs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qy19CfKMNUioMQgKdSNFLG8j3wgl6mqE6Go618D9WtU39Bp4TSijbswW6pdZ?=
 =?us-ascii?Q?KDeEpHRpHa+LJOFeUqm28v9Y9s3fahbhB8x5IaEoQeFmFCsDcK45JGVxXsQt?=
 =?us-ascii?Q?kLSLBoiJ9YU6jErqKcXxaw3SL45URnkzEKI/Pvcjd4QfBYnkcY5R3tm9RWCs?=
 =?us-ascii?Q?QcXJZzxocLsuY4k9+GVmf8TfsbEQ2DXqTL+NgfTHiLcB94p283FHZQFeWA71?=
 =?us-ascii?Q?86KLSc2Lqov8CJkEJksYWwgZeMb5CxkOmH2Xr5SPnPW85XePJO5t15Jbva1Z?=
 =?us-ascii?Q?5EBrUoQz3icLz+WqQsmyfDAJ0/M/FW48BjtMvUNp5OWY05nkvPM9QVr2CA93?=
 =?us-ascii?Q?rhX43N05syRsiUPXaIJmmGk8mrIhsmcKAqarQOf810oosW2lsrFwpAZI5aPZ?=
 =?us-ascii?Q?AqXK1mg4Izmnc+SmMx/cE20Z6ouEVdqeVliFjn+Zr2pymI/kQsjf4sbPnGlo?=
 =?us-ascii?Q?PNvNrnMNdsmcgp3j3btPCLR/FkW3KmSd/Ls1grDrukhOjOI0wBwrqpKWw+ft?=
 =?us-ascii?Q?AYbo57vt4OOF5DdRyqmQwIzfpMr0vyGZZIBsDw0js6OgyXobXeNISkiVbSvW?=
 =?us-ascii?Q?bFwzuL48ytBonbRiUVwQ2v0ePy4SLcgRm0nPgIRLYzO2CKJFoiPhBiR8nQ2p?=
 =?us-ascii?Q?shJcvrv6Uh0QwIYTJhIhFT9FJttOmcEt/QHdJY0xFR5pCIC3h8vSZ/7Y1v3G?=
 =?us-ascii?Q?vjarH+lWxDiTHb9EgaiVPOGYwyUXyhOFzzZldHLVUu5zHh5VJf9jY7O4YGeL?=
 =?us-ascii?Q?IeXnxZGBw9aDFtM6N7nrCU1qf4M+eKrX9rIHqSq+tUTDeWXZxzmXyLbyBXS5?=
 =?us-ascii?Q?qsVqienD35S5OJeE0zTzSeKOd1h9m8dH4SvVU/Xs9po5SZrLimyA9Q8ATtrb?=
 =?us-ascii?Q?Fb3nvuhCeXCqbDd0Tde7vtB45r5Y5zU3IvkK7LwU5VkTA7G+/HN22G7+U6Uz?=
 =?us-ascii?Q?pH/75qz7Xyy2noo9Xj0YRpPEg4w+Ee9a2Mlp3MyPRFTKAUP4/bat1gW6J4wv?=
 =?us-ascii?Q?nZyTs09JMavjqlV/sPpSur5tI3HPA2bN/eMlz90l68z7TAPEn5IE30iaPd3R?=
 =?us-ascii?Q?kLq13/yllYEK2Iy6dpDAsKNB5Nmsj48sn+iX4kB6uMerjGB8KhcGxqwgy1BK?=
 =?us-ascii?Q?4u6g3pRJqD+yVA3q2RHNKn7Szs9M576nmfxV2u5JIFC61Nn+a8dZdo/egnbo?=
 =?us-ascii?Q?y2WOtqTgSBH6Odz6sDDrkYXY/R2H9XrKStx6uPB56zhZiv7dR4jQw3XwCIN0?=
 =?us-ascii?Q?rlAC5JTqwUleLcK/JtKxulYg/nQDT9K1xsZDt7kEOViNuHIMgerkSZ5XZyVb?=
 =?us-ascii?Q?jlQ199OyUTZl8qLXON6VbMooPOaWOKAUNAuPBBn+2PdyWM8IPSG6Zz8dUUH3?=
 =?us-ascii?Q?NrMDEIBIx2f34rO5zAxUrbf7Bq5r7Lu+BgBYiKSogDe/hJXtrGBuiGWqMRTL?=
 =?us-ascii?Q?Wquyiet33Pt+PDMduBvDcqokh2WrmuFsGu/uQvWHpkWBANZDfpcyalFZl6zA?=
 =?us-ascii?Q?7nojqAbrmA6wXs46kSDJ9Mcxv8R0tzgh/rs0urk09pGNvj88RjEGh5U8WNad?=
 =?us-ascii?Q?uDpo/RaYTDMWFOyYn1/HpWCd9uxosDfv7rqdG8ywN94OaaEku3Iaf615EHF5?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jQn5j2Tx1qYYhMZ5TQL71TcQ1sqCCND8WqjPdXsggbKzFuneTwF8igcaJH9inT2Oj22FkAawyndb2B5QQoQ6ChSrLr3yo8u8AW0cvf4Bsl4s4xLOF4/DoDDtkFYuw7GnxeVygaP0sS0hw32bC59QetO0vA8BfnJyhFZ4km1/+oqKQxW9j/2E2btPlU9RtXmLKJK/6RRjxkQD1h/5MHPo5X1jkzJzIepWdojqDZLnRJj+T2TtZxkIH2/P9XSDRllTpZTHi8RzwDKoJK5aJKB9dHyh7dRpQX910QHGYbaLCxAwOIGcMKc44N7x77erjYqaNEIRgDLyZNSKq/E/bwH7VTbpqhVQtUFBPe56XHAFTzd/MiWyjNCiX41EmOnSFmHMXUInwtkcBrqn+goVJS4KsJYzKHtoHFpBggkujAjai2LZ9o6OG+Y3vsI15mAuDeby6V6Y+X3Sm1I9mdJWSPxjl9td2V1uTNtimoxkodJba9zotQS1sMAa0livr626JRRikYhH0weexu998p5G/Y13bEbmyYAw6fIl+RYai9938DlufqAe/+MkfepG5eNqk+Z57hcnwwDP30+naEgoXLTwPMKpIEYSd+VLh5eYTG67v68=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdffc14-9f8b-4b11-20bb-08dddc9bb86b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 08:05:53.3927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFjRKj7LKMH1YwPKT2BTe3yKo8O8ccS3CnXZZZ5DnBhOoD47PCDLAg0D6BLLJ2fmroKxkGO8PwH9rZncRh9xjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=805
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508160081
X-Authority-Analysis: v=2.4 cv=TNZFS0la c=1 sm=1 tr=0 ts=68a03beb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=wkACr0a6giL7QQyJ8IgA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDA4MSBTYWx0ZWRfX89WXwRgTwgt+
 AjfsN6WZALIw8MfMKvQXnCyok/vD+KBLBq6nuVrPqjj4JLbfiEuuMxEuZ8UsXu95tgDff3MqeJS
 gWVs4j0g3/wmQgNBc9GtCja6USnNITwKPjrai7ZkSmCG4KBPa3g95dBotFTkYsbpYRZjYKTeVED
 pQkvvA56ZTZ7edPSwVn2SsWz6rq1fx6XS0gvDcbgeRt94526urxwfQ0C4aJ/clNkHuxVJhFr6mW
 V2pZ+BHLxPMvSWkHP1z7PTViozZQlThzUen7VFr9c1ucWj3PjCxhyFmg6okeFeYoTnZTi9+OJnc
 wwcM2aZLWb8PtHm3PnPcBlm+YJF1WizG/xPGB87ZQnrUIYa+Aw5ztSnP5xt62XHpjWEDEFnGOaz
 TJSxzV1hsH311JTKiwUO36mDUlUB7TFF79p5A7aggQICRO1oL13Q9bBGkr6jmXVG3TWQUo/y
X-Proofpoint-GUID: hrEdVerUxjEZkIc20YkOSQcQsx44O7Ms
X-Proofpoint-ORIG-GUID: hrEdVerUxjEZkIc20YkOSQcQsx44O7Ms
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38D0414000F
X-Stat-Signature: bmcmaaj6wpo786ehm4mutxyrdcifb51u
X-Rspam-User: 
X-HE-Tag: 1755331567-595509
X-HE-Meta: U2FsdGVkX19F06a2n/ZjA33hMbSqF1YR5oFEW16LqRF7PXIVixoKOb35edF2PSv+TgBOwP9jrG3dlLDvhZF1D+z5R++UA2AjDkNbJvpSsmrh2ZKltQU+NxhAhmfV/tObwNyLdAs9D487/FTaJwnH3tlAorZykeD0BZl44SRbKAdHtLJ2b/vLnvaWpXspbZGBqFSrAROdaUjhekm+i5clqi54eXXBbxQmjI1BvOiw4jdCmMdI+DSr9Zxz2XlLgtAgTVCKSpqEJdM+/URZ4+VqWYD8/2BQJfpi/xidaQxS3eqlzEXq7HV8uYybig4GegyiRqS7YaIqQ2ZvRZ0+gnYoonwOcAn6uW5HNKbb/qtEetFPFETC+8/JO+dicKX3FPNPT1oBTONbkPb1ciw7ZNyuBYqoFUcFoWjNlG4jt96a8r+u+jkV47LDU12KL1oJSlCqUr+tdIDhZMSARcG0/GyKGBIU9nSgwpVImfZZ20b4fBIrL+eNcpB/bMynQlxiltNsrzOqOMKMJhv1O24hN1tNZ7+6tGaXugZLPjdPRqe7w8v60q68bA75+CQ6N/TfXizkjYMYFVziRkWdIFu1zw2xC53DBE2zZTG+0tng1JrF1KWJVctiWl/i/NLshoPdNT58Kqh1npOm5VTXMdZvY++7vyuXQArUvRl6n4+IbH1bBNutE7Dop4PrFb7wTLSIPmVqh65XlLL09mx6OXlPW6x9tS05I+1GOAp3lmsP2MR0ZcSY9s8QpcsT6wY6XTF+/T+MDjvneaX1NIEfJnXxT+AmaDNA2zvXhTymw9yhZjvpXEuKVHL2nmpOvnrpZUbmDJg37kpCsEFWNGPSbQetwc/rEk+t/Eq/guigf8IUHRIHUFk3GzN6jx0Bmx2DNDokaVw4hmhka9xSkkQG61E+RIhF0ItPU0KhihhJbtw7GW5DSVzCefCR7BN9fIe8htL1yMRfx5vLmC4UXcfR9SXUXm2
 P+dci28q
 CRNnT+ztOCd/VZsjrRpT2/s14jwGvsTJ6NR7J5XLoqS5pR94tFgGMLQv4jTWcYCItE1xPEu02Ui5TuRZCRiBRqgffrv5Aqvm8m7BTJM0VbkBsHzf3cvaA9WGvx/lt2/FR35KH5f3ilkWCl/wU46/ZtlMMkaqpx0TP5BFeaMrmCpKARuRi2srV5CKimOO8LfZmCSebg8+KSQl/ilab3mw+r8a/tzmnTYt06SUf0jdU4YCT8xq0lrglsyXHU72l7u039HlctPgCYvx6vKh8GfAiJaZ5Y3LglIBH+tW6Tf6fKAitrwlB21CR21UEGSkC65+cAmzOXDikSlYVOHQKJV8X22sb0VbcjlEH130yulNJGxOkqU4jaHrtmAWkcATz1qd6V16KdZfFZZG6ePATJlCeP00UUi0K8F/kPuKQIJm3zBLmQyIiEQAifZTmVZB+fS1aHuLNt821Up5+xcb8jAI1TAcYHW9C9el0zh9oeoBYTwAhy7UU4fuIdkro4KVREJrIiiZpBAPay+myrc2Rat5+yttDGnfIcWoblDsN0Tq0GerMglsSVPZubMm8FKFvrJOVtIGF9J0Oyso5rRKqdll9gj/Djuqy+jOoOQF3872n/xbTNfoTQ2Qb6mbnO2ZvlOkFUMCKbboJavgviD79lZwGgZZ+yXk0XM5I2nckBysppcuiBaAWiIXCh36W6FQg7joU/1xJu+uzaEnx7Y4NHhU87NaS2OG1tr68HPbv7WuNcIsT2AW/WEmdEStKMR8fqEtrhHnD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:53:00PM -0700, Sudarsan Mahendran wrote:
> Hi Vlastimil,
> 
> I ported this patch series on top of v6.17.
> I had to resolve some merge conflicts because of 
> fba46a5d83ca8decb338722fb4899026d8d9ead2
> 
> The conflict resolution looks like:
> 
> @@ -5524,20 +5335,19 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
>  int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
>  {
>         MA_WR_STATE(wr_mas, mas, entry);
> -       int ret = 0;
> -       int request;
> 
>         mas_wr_prealloc_setup(&wr_mas);
>         mas->store_type = mas_wr_store_type(&wr_mas);
> -       request = mas_prealloc_calc(&wr_mas, entry);
> -       if (!request)
> +       mas_prealloc_calc(&wr_mas, entry);
> +       if (!mas->node_request)
>                 goto set_flag;
> 
>         mas->mas_flags &= ~MA_STATE_PREALLOC;
> -       mas_node_count_gfp(mas, request, gfp);
> +       mas_alloc_nodes(mas, gfp);
>         if (mas_is_err(mas)) {
> -               mas_set_alloc_req(mas, 0);
> -               ret = xa_err(mas->node);
> +               int ret = xa_err(mas->node);
> +
> +               mas->node_request = 0;
>                 mas_destroy(mas);
>                 mas_reset(mas);
>                 return ret;
> @@ -5545,7 +5355,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
> 
>  set_flag:
>         mas->mas_flags |= MA_STATE_PREALLOC;
> -       return ret;
> +       return 0;
>  }
>  EXPORT_SYMBOL_GPL(mas_preallocate);
> 
> 
> 
> When I try to boot this kernel, I see kernel panic
> with rcu_free_sheaf() doing recursion into __kmem_cache_free_bulk()
> 
> Stack trace:
> 
> [    1.583673] Oops: stack guard page: 0000 [#1] SMP NOPTI
> [    1.583676] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted 6.17.0-smp-sheaves2 #1 NONE
> [    1.583679] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
> [    1.583684] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
> [    1.583685] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
> [    1.583687] RAX: 0000000000000000 RBX: 0000000000000012 RCX: ffffffff939e8640
> [    1.583687] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI: ff2afe750004ad00
> [    1.583688] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09: ff2afe75368c3b00
> [    1.583689] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12: ff2aff31ba00b000
> [    1.583690] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004ad00
> [    1.583690] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000) knlGS:0000000000000000
> [    1.583691] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.583692] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4: 0000000000771ef0
> [    1.583692] PKRU: 55555554
> [    1.583693] Call Trace:
> [    1.583694]  <IRQ>
> [    1.583696]  __kmem_cache_free_bulk+0x2c7/0x540

[..]

> [    1.583759]  __kmem_cache_free_bulk+0x2c7/0x540

Hi Sudarsan, thanks for the report.

I'm not really sure how __kmem_cache_free_bulk() can call itself.
There's no recursion of __kmem_cache_free_bulk() in the code.

As v6.17-rc1 is known to cause a few surprising bugs, could you please
rebase onto of mm-hotfixes-unstable and check if it still reproduces?

> [    1.583761]  ? update_group_capacity+0xad/0x1f0
> [    1.583763]  ? sched_balance_rq+0x4f6/0x1e80
> [    1.583765]  __kmem_cache_free_bulk+0x2c7/0x540
> [    1.583767]  ? update_irq_load_avg+0x35/0x480
> [    1.583768]  ? __pfx_rcu_free_sheaf+0x10/0x10
> [    1.583769]  rcu_free_sheaf+0x86/0x110
> [    1.583771]  rcu_do_batch+0x245/0x750
> [    1.583772]  rcu_core+0x13a/0x260
> [    1.583773]  handle_softirqs+0xcb/0x270
> [    1.583775]  __irq_exit_rcu+0x48/0xf0
> [    1.583776]  sysvec_apic_timer_interrupt+0x74/0x80
> [    1.583778]  </IRQ>
> [    1.583778]  <TASK>
> [    1.583779]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> [    1.583780] RIP: 0010:cpuidle_enter_state+0x101/0x290
> [    1.583781] Code: 85 f4 ff ff 49 89 c4 8b 73 04 bf ff ff ff ff e8 d5 44 d4 ff 31 ff e8 9e c7 37 ff 80 7c 24 04 00 74 05 e8 12 45 d4 ff fb 85 ed <0f> 88 ba 00 00 00 89 e9 48 6b f9 68 4c 8b 44 24 08 49 8b 54 38 30
> [    1.583782] RSP: 0018:ff40dbc4809afe80 EFLAGS: 00000202
> [    1.583782] RAX: ff2aff31ba00b000 RBX: ff2afe75614b0800 RCX: 000000005e64b52b
> [    1.583783] RDX: 000000005e73f761 RSI: 0000000000000067 RDI: 0000000000000000
> [    1.583783] RBP: 0000000000000002 R08: fffffffffffffff6 R09: 0000000000000000
> [    1.583784] R10: 0000000000000380 R11: ffffffff908c38d0 R12: 000000005e64b535
> [    1.583784] R13: 000000005e5580da R14: ffffffff92890b10 R15: 0000000000000002
> [    1.583784]  ? __pfx_read_tsc+0x10/0x10
> [    1.583787]  cpuidle_enter+0x2c/0x40
> [    1.583788]  do_idle+0x1a7/0x240
> [    1.583790]  cpu_startup_entry+0x2a/0x30
> [    1.583791]  start_secondary+0x95/0xa0
> [    1.583794]  common_startup_64+0x13e/0x140
> [    1.583796]  </TASK>
> [    1.583796] Modules linked in:
> [    1.583798] ---[ end trace 0000000000000000 ]---
> [    1.583798] RIP: 0010:__kmem_cache_free_bulk+0x57/0x540
> [    1.583800] Code: 48 85 f6 0f 84 b8 04 00 00 49 89 d6 49 89 ff 48 85 ff 0f 84 fe 03 00 00 49 83 7f 08 00 0f 84 f3 03 00 00 0f 1f 44 00 00 31 c0 <48> 89 44 24 18 65 8b 05 6d 26 dc 02 89 44 24 2c 31 ff 89 f8 c7 44
> [    1.583800] RSP: 0018:ff40dbc49b048fc0 EFLAGS: 00010246
> [    1.583801] RAX: 0000000000000000 RBX: 0000000000000012 RCX: ffffffff939e8640
> [    1.583801] RDX: ff2afe75213e6c90 RSI: 0000000000000012 RDI: ff2afe750004ad00
> [    1.583801] RBP: ff40dbc49b049130 R08: ff2afe75368c2500 R09: ff2afe75368c3b00
> [    1.583802] R10: ff2afe75368c2500 R11: ff2afe75368c3b00 R12: ff2aff31ba00b000
> [    1.583802] R13: ffffffff939e8640 R14: ff2afe75213e6c90 R15: ff2afe750004ad00
> [    1.583802] FS:  0000000000000000(0000) GS:ff2aff31ba00b000(0000) knlGS:0000000000000000
> [    1.583803] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    1.583803] CR2: ff40dbc49b048fb8 CR3: 0000000017c3e001 CR4: 0000000000771ef0
> [    1.583803] PKRU: 55555554
> [    1.583804] Kernel panic - not syncing: Fatal exception in interrupt
> [    1.584659] Kernel Offset: 0xf600000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> 

