Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86A2EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1146E6B0005; Wed,  4 Feb 2026 15:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEB86B0088; Wed,  4 Feb 2026 15:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2176B0089; Wed,  4 Feb 2026 15:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D844D6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:46:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A4E257E42
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:46:04 +0000 (UTC)
X-FDA: 84407956248.04.4A02759
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013040.outbound.protection.outlook.com [40.93.196.40])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42376160005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:46:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r7XK4f3B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770237961; a=rsa-sha256;
	cv=pass;
	b=EQgncIjpZxBq/zn0Vhxt2OkZ84uPRs9lsr8SBwkiUE5IKD1k6Gl5NvieWiRPLIQWHqtPDX
	yXvlVO3JzUU7tUeTgEftTWMEBz+ieS5wo31+vZ8jR/gstRxRaicOWcyDVpZ+a6e8bMkmuK
	AyoIrWnZdHgzy647AkJ/QO6PH0RELDE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r7XK4f3B;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770237961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLLGZngAGW3lTudk6h2fflK0Imd9T+6Lcp60Yz0zxaM=;
	b=rhyP1V1Xhv44Ow+H1u80NCBZRSj7i59+ffLnyzB1cK9uuUcKiGkfLckUZnQAbOYWE3sL9q
	rSyW7NdRjPgAxGo+lpCntMuz/X+hf4SGYorqeTof8tpM3ea2m7mbaXR6QeD0o44NnRcS5D
	wEX9i3lP9GmhYTRnancnjstPIyIjzVo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpXgnqzJD3iyxOkNfK9XcnMsA0Yb8Lv2BMkovCZCoGJeVyVDJ5dQPpSMGq85fkoBCtr+YU1MS0qHc6lf4t4bDbNANDA+x+E5dh0fPtcoSaCM0mjP6Hm5BnHCGCJtNJiUus1zIy1nnMuiIE/3Ng+rMLLXmXc19ybxVWLYC5/e/7GPJwtV55kEC5cH9Qwiw3vjd+BK4RVYPEZdN/HkOYWFtsD3M18H8DGNZ47V/Bm0P/CpsLjq++FmaYACUqIkCMUATbSk1AnOODVFd4GY1j/Y/b1tNbGD013lvZfueENwQgmLEXTTq51LeGAfbGnknDE8INc1HObvIWEpPF94mJZSWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLLGZngAGW3lTudk6h2fflK0Imd9T+6Lcp60Yz0zxaM=;
 b=VDZusYVrsGv+7LntI1L6D7UD89UJWnNMv3RPt3RDTtkt/ffIRcIVbcIYIm0ukBnCI5bKBhWqBHSG82K4VW3OwnKznSSspUj3JRvbwaJ57NYcUZkSCkmExgpTiLdHPn1/ygazuVDZ5lhGVSHR03NouKo+wY6KmRTgichvSOsEjMrW3FJoMM1hNeg3EWuuu3Tzkv+w0B1AEHwIikrqv4DXDAfNTFSyoIUZEn5QolANVEQffSKRLdyzdifS1MkY4tgaVUJZNLShkKB1WTXmIjoxKn8eU4hnVSp5JyxzjUn9Edi1/jEc2Hs0sbrdKh9SUAJQzlZGXSeDEYY8bSqN3TyTHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLLGZngAGW3lTudk6h2fflK0Imd9T+6Lcp60Yz0zxaM=;
 b=r7XK4f3BXiRkQn4Xm4YWl9deAsUc4g4YYzGKAxjvYFUsRBPDXpciVlOWaMqx1lnPip9ZiHnwiCADSwASaEPUXHsax04FtntB7psT5ppZZT1+kJjn0OOgcn7bTzBo8BJxeXU4PNmIJKjqA9SI2vN4ynxisBRnnoalq1gsO5Wp3y4ZZb3nYdeyFPWmfnp16QJjwAJzQUACN4QMJGXYsMlAl0dVjth6Z1j2P6cpQ62LCQMEs+HkWRwqhW/ZQUr4ljNGfP1lQh7fHIgT15ZbaWn5AqPlUk/W4eKqO4q0bw1U7zsu2cBHKjgGv8hXviz7B/F9ySWeaLU011nYh/LiXoDtRQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 20:45:55 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 20:45:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 15:45:51 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0BBB65F0-7ED4-40DE-9949-761326993D7D@nvidia.com>
In-Reply-To: <7bb98650-cb7a-4230-8868-7da2aab5923a@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
 <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
 <86002E57-58EB-4940-A7F0-7AE4A60484DF@nvidia.com>
 <7bb98650-cb7a-4230-8868-7da2aab5923a@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e388983-2833-4a90-870e-08de642e6452
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EtddxDjAlTtfJs1ngYqcXNT3Ezu/wbVi3BPNrKOFvwN/sFu7XCJ65m+vwsIg?=
 =?us-ascii?Q?wJxI6Aj181Rj7iTQMUoLryNNts7wIJQJYsR3PMAjABKrK3vmqnEPK9UQB90s?=
 =?us-ascii?Q?VBn8yQsgMghq4bMoF9fkpF+tFy6/TcYveqOrBg0B7Em8GrtBQl3IEPS4qSgD?=
 =?us-ascii?Q?Xkqk1228+xywvT320/OsbmzEwM+/5MCPVeem8Wn45zhqiCEL0wxkOJoLODe9?=
 =?us-ascii?Q?rohi1FrJ17/CoJh6L1UOdB3iW2QzaadOzaIxzoDCU8G0DoL2GRf5MqIPo4LK?=
 =?us-ascii?Q?0egP96pAJhaq9XJk76wfikejqBP8igRz3GAJmPnftMxmwDyfMSF2rgRpnJAd?=
 =?us-ascii?Q?br85FEhXcdZqtTZjFxI5tlusbif9dzSR9lG4yQuuLvqM4rUN/apF0DVbY3fH?=
 =?us-ascii?Q?TBh9AXuyqMxoFVa80ksFmRejyyhh+0g6iFfHDz5V9j8KofJTWOyF46j66yyE?=
 =?us-ascii?Q?6TtgJ+QOcwm8P8HKNZ1V5d7v1bdQRilqoqFGqmwFDlTK5LPxb3AwMLOvOJjK?=
 =?us-ascii?Q?XEnZsWT4TbPtMHgsAbcophDht21hQG61WmSONerEo8MXD0YAePOmcvwKaPSz?=
 =?us-ascii?Q?wSHfl/nHQKFdQbRLbIv8luMDzE79H88hPRmx4JBSh9UPSsF2oWZc5f7I46iI?=
 =?us-ascii?Q?Csw+oRxitNv/jwSWNfsgVcvVntbrxqguNL7HJyeWrMNNMfN/LKAscO8cCoK2?=
 =?us-ascii?Q?y47SQyHGnp7PQiJ+zscTUtJIbNvQGczbq9U+cBGm/PL0cJEEfsAEEL1LkpAf?=
 =?us-ascii?Q?WROpwgdNPwLkpI1pc5HZCHSp5eaKDLrboPCl98s5h1zZLSYZyhComjx2R5gM?=
 =?us-ascii?Q?Whpr/O0QxnFU41DPPOS8wyOCOvSREeLzMFjeF7Mywz8VUsozjfC6HDsqH4Z2?=
 =?us-ascii?Q?b7QcAJRWhYN4IpUH2CApysvPdljSY8lq+7mTUq3iQKnVpC42VdxvSKnQodME?=
 =?us-ascii?Q?rTJCaQ2+8WgxZI4WGXYNFxqmZRdGrExqP5PQrxT9gD8aIdlZp7qbQwNYj5PU?=
 =?us-ascii?Q?TTWIMHkrs9heU7jNGzjEi+DbKOKLnd7rSOeVQbENs02CP55h5a0oKbqIuGso?=
 =?us-ascii?Q?orj4jY6IQrx0xSqJucp7RRYeN5LQFqBPIjD6odVKdhA2IPetIXG2/+bVnh0E?=
 =?us-ascii?Q?X0oWsqltN+i3z++UD+G03Io/iZiLrOKCSp99CRuiFTDd+r2tzZLOmm8u/h+G?=
 =?us-ascii?Q?q7E8dQaHvmP5f+Omh4ycNENc4W69B/JzDrQxzQ1iQTxKzpYk807JjDH3cp7D?=
 =?us-ascii?Q?Z5k1VIGVYIScafwb0KiJ5ZHt1K9dFCVPiUq+zlL3JaZfgAmNsr2ystnEsy2G?=
 =?us-ascii?Q?nVpoc+/hvll0aJ9eW75jn4HV6jOMk8e3u1jsY43LG6nYH+jjqtjKJhwZbUdl?=
 =?us-ascii?Q?+EZvbWjDsC+VrRQ9K9nliVT61OZJRCQ9iAJhJuPBKPaBOHihDxkF1CXbIaSH?=
 =?us-ascii?Q?Fxr9TbCoGUSnX5JLFrOHQBHYdBPUe6vETTjVxfNaCVGoMYkhP1zibTzkjJ16?=
 =?us-ascii?Q?dZHVGFta11hIfu33Brgtj9m8BwXwB/IyAicLaJyvSfQY3oVCU2kAloeKGsxM?=
 =?us-ascii?Q?xwYsdLkeySVO9gTAQLqIjTp10ir7U9fhm8Pt3lBH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6+nAQ0643cgkVPQirnrHsIE8rCEN909c4qLwV4Su1X6eeLmOLRGILQZC//R8?=
 =?us-ascii?Q?GramfSwPOySX7mWPQ5tVTxMTVALxKBoLOC4yoquJaRo5jg81ZowgWqTC8uvf?=
 =?us-ascii?Q?z9RE+UNX0VL5a+QsADBDgtYEnlytP7v6D011MvQXdM9AkaLKhFgyutpA6s7d?=
 =?us-ascii?Q?sbzIDk/HQYr+ZcQvqok5VotiiXh5WgIMeLqZicOThRB6P0PNDX0epjfRdlLv?=
 =?us-ascii?Q?K0dAyb8/ERGS4wSNFdgJkNzXiu/jp5at1u3oE51HpMEdQulNoJrujTykCybU?=
 =?us-ascii?Q?KAxacREFdRtt+RcBEKlEkbuEMKuo0qbCcADJ/MxifLMv8guND3cZA7OeQKSe?=
 =?us-ascii?Q?xYap+lVFBZyDeRfTnz9iN3qliFpXYTOxjN0ruro/4SR4enlGQsWemKmj0Ujd?=
 =?us-ascii?Q?OoOSAR11cmz7eQQ5PfvOfag0q9oz3wqLyghwUfBvCvDOe3BB4+Zh4IHbYH3G?=
 =?us-ascii?Q?9GWjxfUchn5GwnkQmne7dL+Yize30N7hy/nG4ziCGNwKHIZ1jy0/1sD4vDhb?=
 =?us-ascii?Q?Tj297ml3r8kwzUAQmHHXSTPQHOqS+kYIBGBfGlPuoUJVgugQ1SaR5yP9s3rK?=
 =?us-ascii?Q?OhQ7bANecLgGpV7VK49NG93hB+3pebh/BS/C3llM7ZbELHd45q/16DqeLouI?=
 =?us-ascii?Q?VP9WJTVsp5IZ2uxLiqLUyaFELJXwj79h2pPaUjGmfAInLs1XQnB2UrdRa09N?=
 =?us-ascii?Q?vHJhsHAjZUOZ/g8t7sVJpft7OYXiKNrAR9q13rzKi8R1F/Ahbg1qbU7vA8PK?=
 =?us-ascii?Q?YQnk0OfhAJ+UQ9xyDYehYWMBWjhQDITI8Ra9skIUsddy7qRIeSlTWX8aib1r?=
 =?us-ascii?Q?8Ee8y1U8E5tOD3lVvegIhvtB8vhMuquMWTCTh9a+g2ykVtiJjiILTBNFj5zJ?=
 =?us-ascii?Q?F0zYsE1UkhYYKEhJYXobN92BTS6k0KeWnRKViSG1HoYnlECHqjouxZTWDxOA?=
 =?us-ascii?Q?yETL+Zi2D9YLmhnA3S84xJAsNz7cNHSTwzj8kci5O+qS/VBwOFPZeUGSXgrG?=
 =?us-ascii?Q?iGeFTsRTB5YVY8N/hJMENGJre91ECMIsFA+YxNCCt7z/lSAAfM0nG9ruFrFQ?=
 =?us-ascii?Q?XQb0i7WXR3HHZOBYH6Cl7AeoC1WyX/THcHjbvhIg8UmMJb+O2DUEuGEdQn39?=
 =?us-ascii?Q?GWkxDIbhFpDNZQLtWGcLikPHfekUuht2eY7E6Lirhr1HHZux79Qozt2WWaUT?=
 =?us-ascii?Q?THwOdSGQkvn447Yd32nhSF2pZCxirzQJDCqPhn8w81rWjyqVUe+7q0GOJVph?=
 =?us-ascii?Q?CX+s2eBpD4JzvQrTZdlAdzND1R2OTYpxFqOHM9N68Yx0VZ6c2RhQbngS5fRT?=
 =?us-ascii?Q?TQlWNYj8QSW1u1eoIVdrLPj8v3FKEYHn0yPyMz0isZxTbBmR8WF516AZLsjQ?=
 =?us-ascii?Q?3vBVOfRjYaT6/ZYAclzESIuOL4p9yKpZjhBEjS3YxkQYJVUtyTOI0HioaYtg?=
 =?us-ascii?Q?WstQRRsHpMgNzCsA9jAqfNAbCnlZmJEUgc1WmpajnTsw2DJNznyN4jyW+t/g?=
 =?us-ascii?Q?Yh6ANqS0zbxaQ8eVTaQ1F+yul4PT1Kvplrf9aRTS/u6qqouab6HF4QLBMRFV?=
 =?us-ascii?Q?j7u+sTVksgYYo5fgzYanxKOc7+flJIQuCi/gWiblOVxM39ldpj4S66Sg7ml8?=
 =?us-ascii?Q?m4AumfzZLd3fPeEzR457R6QqYLkeNz+FWAnqoWTZlOQZnwYs9XbgjOcqihmd?=
 =?us-ascii?Q?DjGfXcBRYQCzKDT0AP2auqcoDabn6yT0EirR8/lvzcoCt/IHWc9LQH4Il8r1?=
 =?us-ascii?Q?OC6Speue9w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e388983-2833-4a90-870e-08de642e6452
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:45:54.9262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FM8kXURISqz07uNN1MB6dAKjqdRJZpsw0zGuEBhwf3zLs4No4pEak5snMv1I7hI+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 42376160005
X-Stat-Signature: jhz7h7dchopq7huhuqkopcg6fkxdr4iz
X-HE-Tag: 1770237961-182570
X-HE-Meta: U2FsdGVkX19XGgCg4O0GpMwRwUfhTXqxoaxr1A7dHCKfAQz7CmCBsAIYLczBDempXRlfgz/qfc1Raro1zTzfJH+g2gsbkUuEz6ExmBHCPff7S8dN63RhN1UTrj3j9VvvIckPymwknw+iYfa13dbkkZG+Z0Hxqr9nTsgCLHMpeqcnwG8FTl+vsMh4rvnmQAnkPobz8xKDZ2wTIxaql2OK1zfdEwfkOJ/8/3N5SquZKJSZZFuV0kgJ/BlGam86o6htsZFUrw/OyEg36lWZBID6PC1s92M+S7/OzyARkzYTZoN2bMM2TX8CIfUfLb4XGuJt63iA3KIaU+yms2YUZOp/TyTak2r+ZzdYxqz2v1VW0QUHY84+1kDCKl/IzzmTeibba+xjp3b553Lqkf3lnPf5Vb1r3IplKbflNca1lRK2lgJlS3tHfrCz6IbozwcH71/D7gUiccEtklKHbUEsNR6E1qRUdFC/f39XRb1TnHlBVnHxzxU4JjRqkzpDMx+8EhQTvBopX5d/9rdglxRL/+5uBNcc1ratwDC0kOx7vayNNoc2O/EynaKmXzHcqWxhIlPykTgSNrelvZk6FjcR/mASh6gAhEETPiiyZen1uxa0+3dvoICbDP8d0RYYBi/3KwGzxUX37bhm6RKrsny1yU3sr9U9MIT8NNvcOD9HSOduSSDSOn4nqoAREcveIyuupD8md6XJO5UY7e3xjkGMHWsVf9oZDLQvzHUvmA+S6zD3ulVn6ThFJIDXhZjkPcFErsRMAeDG143+Z3IIoYo28HTRkseOCLupg3q0OZCc+4xBjLy0AXNNKw9uD9aIzgfQxC1wU/rfJJeG4Oyd0GJXfPvJpOoSVyL/65ss53PRhdJk9GlKJlG963lTXRe+c2VuhNY7wXzlDLB2bWeqmataJb+q9cwLXuDSKTWzVeF7YObGAZ0QQY6LYap3wLOQDXdchRjf0JZoJuCb1oy+7PWUDrM
 iy4Xcmvq
 Hv67enByXYR9CDsztRDsGze/IJluFl3vDINAlLYECwKh2woADYeyiP+Kjs8xFcMf/ioNvu2aGjmrmkgbtJjSxkdn2W+wB3r9MRHodTPua1wuHzhP10VJfgS5JTK4wnDlPIkIk4y7TswkfiC8ZhW7FGaxAZ16ehxzXHxVLIfSI/rFk+5aj3S6LonlX4t315y3EPN5k6G4fJE1RhkBfRzyHjMFsiE4bzK1hmDStwN71PtzLUF1u7ERflxM0yKglCk4RA6NgOOn1muPF600++/G6SM82zi23I1ag7+yK1+B2n4xIrsk7WijiOEotAStjnXpbaeBU6B5TvjgXt/4W+S438G6ScqdkMUbYbSKpsm8cLBpq/LdyWF96KZae23Ss/AQFgykK24g+g3oOkwKXN/jYtTgrvIC3J/WNvWXzPPkkM8onm2ym19Yr61AvdE4Hl5GwkYDFka+xfh+tczU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 15:31, David Hildenbrand (arm) wrote:

> On 2/4/26 21:13, Zi Yan wrote:
>> On 4 Feb 2026, at 14:55, David Hildenbrand (arm) wrote:
>>
>>> On 2/4/26 20:48, Zi Yan wrote:
>>>>
>>>>
>>>> What do you mean? Changing memory failure code to only handle large_=
rmappable?
>>>> large_rmappable is a folio flag, memory failure code should see such=

>>>
>>> Did you mean "should not" ? :)
>>
>> Yes.
>>
>>>
>>>> non-folio but compound things to begin with, IMHO.
>>>
>>> I would say that we could right now reject in memory failure code any=
 compound pages that do not have PG_large_rmappable set.
>>>
>>> I have the faint recollection that we don't set PG_large_rmappable on=
 hugetlb folios yet, so they have to identified as well.
>>
>> Right. My patchset[1] is trying to add it, since hugetlb is used as a =
folio
>> in most places and large_rmappable is a folio flag.
>>
>>
>> [1] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com=
/
>
> Still on my todo list :)

Sure. Wait for your input there. :)

>
>>>>
>>>> I think we need to be able to tell between raw page (compound or not=
),
>>>> mappable page (compound or not, especially for those used with vm_in=
sert_*),
>>>> and folio.
>>>
>>> We can't identify (small) folios just yet. We'd need another page fla=
g for that (just like PG_large_rmappable), and we all know how that ends =
;)
>>
>> Yes, I am thinking about removing mapcount in struct page to achieve t=
hat.
>
> On my todo list :) Stupid CONFIG_PAGE_MAPCOUNT that is still around and=
 stupid partial-mapping handling.
>
> I worked on this after LPC but was distracted by PTO :D
>
>> And only pages used for vm_insert_*() and folios need mapcount.
>
> vm_insert_*() won't need it for non-folio things. Only folios. We just =
have to teach the zap code to also leave the mapcount of these non-folio =
things alone. IOW, identify them when we map/unmap as "not folio" and not=
 touch the mapcount.

Oh, that sounds great. I thought I would need to convert all drive code
that does vm_insert_*() to use folio. Basically, I hit
__folio_large_mapcount_sanity_checks() on _mm_id_mapcount when I moved
_mm_id_mapcount and friends from prep_compound_page() to page_rmappable_f=
olio().
IIUC, __folio_add_file_rmap() can just return if a non-folio compound pag=
e
is encountered. Of course, remove part needs to do the same.


>
>> Code
>> uses vm_insert_*() on pages would probably have a struct mappable_page=

>> with mapcount.
>
> I don't think we'll need a mapcount for them. Only for folios.
>
>>
>>>
>>> With Willy's work we'll be able to identify folios reliably.
>>>
>>> How to deal with that vm_insert_* crap, especially for non-folio page=
s, is also future work based on that.
>>
>> I think it might the other way around. memdesc does not have mapcount,=

>> if we do not have a separate struct for these mappable pages now,
>> what do we use at memdesc time? folio?
>
> Folios will have mapcount related information, yes. Long term, memdescs=
 will for sure not have any.
>
> Real fun begins once we start messing with refcounts. vm_insert_*() wil=
l be "fun" on non-folio things.

Yeah, maybe we will refcounts for every used memdescs. But who knows.

Best Regards,
Yan, Zi

