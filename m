Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9062C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D086B0098; Tue, 22 Jul 2025 13:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F49F6B009B; Tue, 22 Jul 2025 13:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC326B009C; Tue, 22 Jul 2025 13:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 493D56B0098
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:19:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 282EF1DAA40
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:19:24 +0000 (UTC)
X-FDA: 83692561848.06.1C2CF27
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id B84EC1A0006
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:19:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MqXcfyBf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mGnfa4/T";
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753204761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ug+RWYWu22VoX1QMTsBE5/3fZ8XMHk6upSOUQQTCZJI=;
	b=FOsePpghMOqSCI1/UBSJlx6CvDW9tlneyisVf8OsnmwbDjcRE2D090VLr1raoZI5eddD+t
	MzDYforKAmzSmxrqcIrCVzBKiARwq3YP3uA+LGf/srkkHdB8k1yYF2r6FX2xpTcOGFzC4U
	2ASde3LS4ZQbhIcRPlPWwyo6v5wsFWI=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MqXcfyBf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="mGnfa4/T";
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753204761; a=rsa-sha256;
	cv=pass;
	b=12czQEaVPCeedQOrE6o17tvkK9MTARFhCwbaGgUxkjezG+o88T0/nguDeA4XQx/yNDNr6v
	LHCpfW3hiD9Sa56gWTzpOisEcIDv6SoakJMVb7jGDpaIwLOgTi2WEWaWEFp+OuAzt7nJXH
	6zu4jMSZ36mkY2kbDMmybEokBsmdc+s=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXxDx030293;
	Tue, 22 Jul 2025 17:19:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=ug+RWYWu22VoX1QM
	TsBE5/3fZ8XMHk6upSOUQQTCZJI=; b=MqXcfyBfgLOjV/z7XyzAWXFIdkxJx0hn
	ok6o701Mto1YKlxxHU2lR9t5vxw2RuVPMyH8AeRcP1eQs3vhu9AaWYEAMc6ZGe/a
	5u2+5djAhOxrt/vWby+P1CTJyetqxXd+VVEbxj4PG1X9MXd/XnqCiMaGRpG2TXiM
	ADNZB7m0XfYvkU+4ZFjJf8AoEui9oekTJQ/70Y3gR5ueJ8DlqPC/ZvYMj/j18v3X
	Z0ZlN2D3LmEu1C5mbwFBNg/niqBL2s5YDdQ3PkGqEhxMPCSwGpppJyuKQhgfxzP5
	PYqiJaBMiijFvhWa4X6rcGrT1cXGkKydAaMIRtaOTieVA+O4IDpCHg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9nxf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:19:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MGI7os037682;
	Tue, 22 Jul 2025 17:19:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9m86j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VkL8VKeVRL+iGI+j05Fg5MxSA707uiS7Jusly3u4Am43vUj81uG1FXlDk3+mPtUXmD0RrYhZvC6UCa9YR4lRbJ0dIzhq48gS/KC7GdYJG405FysI1FL8r/2zIXaSFNLtEE1gcmX1y1Fg1RgFHYvp/SlRmDywqdR3Oa0oyakDcDT3uUZec1NmFqs0yLqnT6z2Jtaw+kOQnYYJ1m9VlV74X91NpRmOJjsofdBJ22tKdpL41a56nODQq7cnIx9mzTSZ0wh8CKyjjXjxWOGeHLrkry6DSEYEi8VLv2NWC3xgGHqmD77WTnhavSZd/Tmv/D31sc9N2/kMN/1kAiDK3ELFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ug+RWYWu22VoX1QMTsBE5/3fZ8XMHk6upSOUQQTCZJI=;
 b=ipudQh+HsLBbeIEKW/piX1HnKFDpIERSEW6rpQFYcEvraPIvFA7geL7qMxB5WA5J66leQ4tgcW8GLnYJN7G9zA1tCgDfX7uka4Iv3cUTpJbkE5VnM5CK0+rRfPUYmcaBTGBORnzitiaQpBYLY+N34al7aeJ/stgTAR3J6glznwFyeXdQdi9CO7735nfYCI1FrhUaNgAp6yolxRhMmePb+mEXrx0LEXn7nEJQwahhUU4H2JYl/gys89QuEzAo6VZu3GA28LEMhJdiZwBrHmhR/i1wuONhhakPP9McR04C0B+r2hBSKjB7Z+K8/vf66z+i9SbKIPG9GemoiDtg8bcW3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ug+RWYWu22VoX1QMTsBE5/3fZ8XMHk6upSOUQQTCZJI=;
 b=mGnfa4/TDv+Jasi0WDzMD70HMIK290au0kVEyrq/KqfC5m/pFlIqJZmTHNt8HJGo1UjKO61NJysBHhBi2ZMJczwilb+lJfVe5KsOK01VNh/MbJLHvik/wqduw65nJvthw9xrs2FZleYcV5whreUijWAKvMPrpKvA2f3WRMy4NHU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Tue, 22 Jul
 2025 17:19:07 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 17:19:07 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>
Subject: [PATCH] MAINTAINERS: add missing mm_slot.h file THP section
Date: Tue, 22 Jul 2025 18:19:04 +0100
Message-ID: <20250722171904.142306-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0260.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4408:EE_
X-MS-Office365-Filtering-Correlation-Id: 56b86355-47c6-402e-2517-08ddc943dd56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wIShEbRCSiYXaDQcCYb4zA6Go8E0u0W0U/DYWKIx8q6+MVcW4473/wTcdcSG?=
 =?us-ascii?Q?JJxAlXuYQLRY+VaXszUFIpzhCrhfZ4ryYg8ZyJfI0Gb5gVyPLkrVAOAthd0m?=
 =?us-ascii?Q?HhHXjyP8QyrV44+8lgP9VTyhHosHnlmmZCLpPfGZfMkqsZsf2M3lvBUypFFm?=
 =?us-ascii?Q?8iW6YhJplmMgOnnvfxWSgNyCCXG9MURQXdJWLLmktt7y7McrijasB4pWE1eP?=
 =?us-ascii?Q?j6RMV97qdXpZ3hpTosfSxs29by1WLL7TR7KiWDeKklOtACPdt2gFrnMhwnU8?=
 =?us-ascii?Q?iHqKfR5HpomZqFQpXFUshtmML5pxMLCNnWvLVS8t0FpOxDXikdLf6grqMYry?=
 =?us-ascii?Q?id9yo2QcIcCAKMg5SQH0E9sxGGQxKuCLM4wi4qjk7aaqWhi93w5/bdyrylME?=
 =?us-ascii?Q?bYBtC/JXLfmY2yaJiLXdbtBci8WAVgz4te/nNAzPH76EYe4TYXDqh+dyJcvy?=
 =?us-ascii?Q?80y7yhodJcSnH7mNYr/EPVbDr8HRaoCjTrO5jqF/SKf6c6Q8luM88gfDaQqq?=
 =?us-ascii?Q?MpTgcVW6rTTN35Ni2FDjuCqO0DldaEPZFCG3fuTYGb48eukzH5+Rlbp9aQ7X?=
 =?us-ascii?Q?xGlYHh2WrvNhfyxBMNyOaYNGfPbrruuGAW/IxW5AAgNQ0s0YuQGtvuDogtEy?=
 =?us-ascii?Q?LGGsCRNB0SOEUDckzOo8AecIWACIcksH1BTgg1czgWJHishgetkmMcWQU2da?=
 =?us-ascii?Q?ZIaWogQtQbzjVXS2jl/wMwUycBTtgxu+TanQHzrvYcOwWk+EPJveL3yvngBw?=
 =?us-ascii?Q?muF/HSJpC8ykaSwmvZ3QNV/GY/Ej9Face1ukL5Dqvh7ztlr9DmxkuwHKkxz9?=
 =?us-ascii?Q?WntLfdGP+RyK/BqxfiVkiOM7qJMNScV3ZnnIcWg8fmILq2HkEgLABJwUeuI0?=
 =?us-ascii?Q?LL+mE0Xv8tsJZsxuPxHwyPHG416oYkIQpmXXE62xPn1HX3pI74wNyWpxRwXN?=
 =?us-ascii?Q?P3xNE2gwyKyQGAHx1muMpQJTMgLl5qHX/pqngg6Prv8fTYk+2qkJqrD2D++a?=
 =?us-ascii?Q?aUfDt4oNMRuQtKlrP3jPgEkAejmeg2idBrY8QHESBLWRYb5y7DurPhHjGwWC?=
 =?us-ascii?Q?xXqFiC7IFL2+4UbqYhQ4L05N2P8eGKFPcxANwKxU8jQP2rLAoHB2BSArFzpf?=
 =?us-ascii?Q?aY7rZVGZwy2hXbh4ecmn5BxyYfJ/GpvMqBg1KQ6kpqttl1gdvI48gY/FbHAx?=
 =?us-ascii?Q?Ma25neO1pdHsDGscQNaCnGs12xul+M6NpZcff/scjMIZPzJR79cQoNZ7Ke59?=
 =?us-ascii?Q?f99d+h8bBZ8Sn+YfmiQhhdaf23locy/K/LH7uxTUiPFLeXo3PO4iUS53jrZQ?=
 =?us-ascii?Q?QMJUKWwp0WFt56SS9xQUmcKUeuf3T3YIYoKMGLo2YXz0b4v8Y4znvtkLNUVv?=
 =?us-ascii?Q?CLS2f1vXTouK1YA1M1bF9RvG/sPXvtesCWjZWjHqG0bl0ZfitupY/U51uxVd?=
 =?us-ascii?Q?81NlHOUwzjQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BaroBbAZ1OtYTc5A/TzpvTLSI6muRlyGTlb4+4JWGGzuGsErua0rMZCkeoek?=
 =?us-ascii?Q?tQdVWnPZ0U0h8fYc4zu8Ata5ciQiH55VR62gNjyWeeza8GJTgQSKdYeLklKz?=
 =?us-ascii?Q?2G07HXJh5Xlxpt8Yuu2JZPuHQ5i5OTKZv/2efunqOzQQLMFMox4ptoMDnYBU?=
 =?us-ascii?Q?UsVPmoAhAmaJNmiqCF11cPDg0jfCHg7Oi3YRRxtwjzseJA7209I7hxsj+WES?=
 =?us-ascii?Q?LqkJ3CLV7+ki/csqUbukWFgd8ExP4oXubSMjytBFi26k8H6mAXhRC7hxPWYJ?=
 =?us-ascii?Q?n1dxDlE8NLpjneRuu526Cca8GnSiGmKoUrID6XqNXop7ejXt+geaxOS3cF5k?=
 =?us-ascii?Q?mX3qAEoldJGIhLpeYwiZyjhT0G49np03HqPzFxlle+vseOd4Z3vUozvgUiGj?=
 =?us-ascii?Q?PTDZyGktoHE3VYgfbtKlhxaqVeT/xBCAXjzQZV+zFaB6vQEm550sEx6oU8J6?=
 =?us-ascii?Q?bTqRIQGOEgq1++MsOc+slT4ylvlpSvR9wHJJIITl1opXoiDWFQHwrP2Rtzgo?=
 =?us-ascii?Q?c+m5UTplZkdtplhdWU9tc0LNseK5537sSHQgWi30To+sKIo78JiH/l3hqXPk?=
 =?us-ascii?Q?cSCjB61BwvqUQrXD1oTMmbFGiGh2sEc3laEE5KNN/Dx5FrbSPW92XLjWbrCJ?=
 =?us-ascii?Q?2J1Iqjiguxtje1PNnN+CxwFc3MGw7H8jbNL+5YwlglmjM4vLuuHIex43bfaj?=
 =?us-ascii?Q?r9fBcjTJBUKW4oZxW3XqqefUa9PBxWBjf8myzdgZopLGUT6u4wuRlmPZxp4Q?=
 =?us-ascii?Q?hw2xMF+98eEenOYjocmH8+8YFTlrca4UyLSIuyRfrjE4b2bnyyrCKvoQUi3L?=
 =?us-ascii?Q?eDCkx3YvlcwMCQxtcsoxoT0nkgopqnUjtuJhPoS8/veOvPPpqZrhWOqt6C5q?=
 =?us-ascii?Q?utZEPUuF7PPu0kvL0WfD89pzpw0IggujwtILySWLXTlkc8j9KrmfgGzfTqxU?=
 =?us-ascii?Q?duwjfFYN+bNr03U37+DEzSqSsoQUjIGN/LY1p82hg5mjsifyhAzabsMeWHbP?=
 =?us-ascii?Q?4Kwo0Pw+NI65vOy2D/fNNHC3NKO7fM/S/4CDQnF2i8HODS1leNq1UvhnAAtH?=
 =?us-ascii?Q?I82dF34t8RI5CHygWbYsjtw6OvmckCGVYeakncuyrkznDG3n2OFFmTdeI5AY?=
 =?us-ascii?Q?SnR4xVFFiFLs59GqWqNE99uSNwpsLyhX0IBWup1YOY4uJteK6q+8WFf/A8ul?=
 =?us-ascii?Q?sFPwKxwWxV27SZ4z643ZdDn5N1/Jjkqw6cWPf9ZZYzW07zs3TGKfXqIvatyw?=
 =?us-ascii?Q?VPblo7dr5VZsf/UoZmyHFZmlu6HMYDfE/4Ac/JhQXDpOSOF06AHXI6bh7Mvz?=
 =?us-ascii?Q?4IKNzXcLNh3ZUYnK51a1PIx46cPvVN+dbo+EGKdUpp0LA7envuC7VDdnjHuC?=
 =?us-ascii?Q?Nq/qWWAURJJFLDUDQv9R1bNhN02DxGbx6hgML2xbMCFeOXsagg6cjLIoB1tP?=
 =?us-ascii?Q?2+AA21zyY5SqPunbozfK0zipdabFXBvQ9QOCBVpt0e7iIhy2NMs4rGoxNGmO?=
 =?us-ascii?Q?rdc3lt74Oe0Z724ozb7/jmjRXN5q79vkD/GgJDIWW6ehHSp3rK4S7mq3oUbM?=
 =?us-ascii?Q?jOu7wPbcIcnxrzNf2gDAhNqMciWWfKG5mHzKdSrNFBeaLC+MkRKemLu5hDKZ?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CvNjDQlj7MyMlDqOOPVwvULd2BaOJnVuwKImOKvPYA2AVrbu5Dmpb5Q2c9bT0zkVNEJMeDS/slZvQLdbDbykQuYbHj53bJwKPsbpJaQKdMnP+f6QIEkQSSXrvuzQxG1dXOa70V5rLJfM99594vSF31FjtrRE7rMFfEkbVlhxbPQi45IcLH/49OmEV0y/KAyv7wMG5A0ZR7FRxaI8MmJOiA6ZytvBUXIUK0SdFrJGEgl04MGnWWh//mMr/SlV8OZ2W/KUvcCnAZFRI42tU6RCLWdSLmdu2BmnOabkZNe2keztnY7ytbgN8oh+A3CRy65YhGVmom7xVhK/5jKuWByK48gdP2Rjt7JUyoxWo4h3DzgD8x/62zTVzOTnev5JexJXXzNoBs9yPKg4WQalbWaQtP3vp/L+h+Ou7dCBDp1hqH/fNeimLH1HJ1p3XxQdv/PhtiWw5wMqH7STRb38WEIsKQVxeL0z1ZZUiQ0EMqIFNuwWIEz25CV15f5gQhiLhE3jSCdeq0U/lh0awxKTrUXXsEQq0yqEBOSCeEPZ6EmI/Yeh2MHekvrsbGbMkFUS5q4l4/85sqDHbZdfCz3c++7nzIKnd+PhAt3MDQCvpG2uNak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b86355-47c6-402e-2517-08ddc943dd56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:19:07.0473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zLu+Hz65kEGJaBAaVy+VN5fVRudmRt17DBe8XvxsHV9qTKoxRcBujgaL4qQomocd2THKmxeH31WkY3KstNJNX1n1Q3Wd3HQRsvYJQ0hZXPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220146
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=687fc810 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=AALVElXCgEnTsNbEWNsA:9 cc=ntf awl=host:12062
X-Proofpoint-GUID: WnA3gGOhVpVugPF9eP4FJjShYmhPclYP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE0NSBTYWx0ZWRfX++w5wAgkDtZl
 VTmfb/zP0UCJMGdg4cq+qdv2ejDBtikHaKJJREizfBaZoOg25ECgmCfF3sertToHRctzlZZb4db
 CRoCa/upfUDJXvlOXAW1JBpntNpo7yhmUcYwm+HdE4RS8eXMIjOigimmT5n7/pwD56UvXKF5wgA
 VcenSu4ok+Xlo7SyJTI1fNDADzZhWWpT4ps4GIcvbCf+CYSuM+bmUT4Wt9mT5bU46gIIRgiusv7
 59+hy3Uja8dAgrWvsBrZZBNgAdNmCU/ztCHZyfz1cb7e5ad0I5+Ccx/3WV6jlCrxMqo5O9EHJlr
 1VaV9dkbI9GeMMsLnw905WgQfo0QdHFg04oYEsz9qh4oqJiEdxC1j4pQLriCH36sicbQYUDEWfX
 GU2soliLLcnLaArjjnKbNkIOVA5TlegPGdZMP5ApzNqcxSHF7uxpRGvumvP17b2OLFRUVRx+
X-Proofpoint-ORIG-GUID: WnA3gGOhVpVugPF9eP4FJjShYmhPclYP
X-Stat-Signature: hg3om8yiwrn3drhnyez7mceyhob1z33e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B84EC1A0006
X-Rspam-User: 
X-HE-Tag: 1753204760-166459
X-HE-Meta: U2FsdGVkX1+x9AewRZ1tDXrVoFqjMhl8e3JMN3gQu+Cb2h7ZWvfuZ+HZIW7aHuybhFXILYc/Xk3EK3EncaQxUqWfRP+79V4jGEQ7iE3VUfjvmO+FPq/QAPPD7Yoiee3BczdWtt+oNN0tf2XuJKdPT2rLR+TV3C2gtMau7zHtIu642gsTJ+7ile4FFLIai/9zXbLLfs1C+dvJyXQ27fLWXBRrl0942xFUCu7knsCeBSpAFApNw7DSk3JcKaXy1AnS/rWsJ1oY8/vdWHWjFMwJzWvybgCoUmw1k5Ua7CYFzKKVt9fdHX+5GjtBMbSnw2Eszrh3oEIKjYqmWUR2fjx54yz2aPFI2B3hokEVDlN4X+G1gG3Q5fs7lHYk+Tj8+GVp6Z25eDQUTbhJI8c9/fHlRoD2UVOBc19brOk3z/a1Ex5p5EMzSrGmPwcpPzZ/CY9PQHyLGgLrJgkisEF4wV2m7rAMsztnGKlscHISLst5mJ0w6FPKPyC3o4dR1g/v6UIhA9TOjwiD6DsRllglMyV0UUBEsUoAaEitvC8ZYTm93uwQaJP/n6jQsWf/CVkPEkbhbcFzJOjWJH/PJ+OPIOgxQGDuqp4jGMdNEfVqWqN9TpgJxdMTkTP9RiHABvqJcgXeKgHRgv7mtlLTUR/EkP2dAFyCBW0DQTbEQlp98cqXqmFcc/V1Lsqwf8ehu5XhvgSGnMgwX+q8Wz40LzJOHnV4QU6Bmrypyqq0aBfbqWPahl25FaA/TsnkHWV8ii4uSF8NXvR22AWxhdv+RZZHhATs0ip/IjBCfwkDfYABN9Y/yAHuLR+f8dZBfgEHDflNXJud2iSnUIEMHc9cCUnS9P4E4uZgdYGS0h5jX3FBlY0uV5y7Nf6MdzGQIRGB/6gsFF1png0FFR28YrlYd8njBlf3suWrvj+UMixDFKJ/BaY0dS3duSCszfMRbdy/ird5a416eFvN+HsLe/duD3f2THs
 5PBa3U31
 pGaFvmWCBD1BUk6VL/jHFG3j6MBEFEZoxMLMt5IQa53FFaq1KJhdAJ4DC9WBtH6k/N+YMiD4gIgQN6oBaTMqAQJPPlkN0+jpIstoz/H4Lzk0qNm3ExSOy8jsU7loxvHtVPdh2f2Ad+AwsB/UlkVXgGCLdGs4YYD2FuFhywJQ/ToNuxzzzoxdKCqGjzDm9eO4igGJG/XV4pgyI+iTIxEs91li4/5uDF2RQIJjDzr5YV2rIrUbStTGMOzoPKiJgubLGkf13oVLO2khgpmIMfuSkaz4ah94jq0GHzIC9Us3WirgpsnV724/tyfPqtYQgtFfe5A6B3HksejxdpiPyV+YvQvKvsYBQReQHSaA3Vw7m031OvnWEA0RugDJhLwuIwYgcxSmfDu7eb5GAGiQf/6fhKhGC3B1wu9uwwxM/mP/xULqQ0sIBegz+g8CHTVzU6GGdiq2WCEYBlCuVgKxhAEplpmvJZfCbI+DSxeEzsF59V/6mqaarG4eqhI2qqDsKOdbnpa3DJVa/JLSox12pmGw8iaNo8d7s7h4CBS5+imt7s8zwWwlc8khrWp8bs7ZkdC1SSv9YYGSVlC4cnDU0udsgXRblMxl9/p83yiGbLUhnuMnOhoobvaDHmLEyylWsj782jgZr+xCFVzobgWCbsNpTefm8++I9mSFzr4YDgoQnGVHMQnzCGJTC4FDQQ1eW4YNvRh2g2Mixr90duvkx6IqWAIxRXDjrjgoaUHZzabf/DgmYssum4bNvJ3u8Gnw/WKqafzxY/nFwdGoXeysf/gw2WzsV2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This seems to be the most appropriate place for this file.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 837bc5cd6166..3f83fb317f51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15966,6 +15966,7 @@ F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
+F:	mm/mm_slot.h
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
-- 
2.50.1


