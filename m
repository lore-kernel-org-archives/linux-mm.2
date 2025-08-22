Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15243CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EB5B8E006F; Fri, 22 Aug 2025 00:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275338E0056; Fri, 22 Aug 2025 00:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF918E006F; Fri, 22 Aug 2025 00:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB6788E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:43:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A15A138D2E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:43:27 +0000 (UTC)
X-FDA: 83803149654.30.647C47D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1628FC000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:43:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NhInyjNA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qRdv9Juo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755837804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hz7xF+GUD7jozmBM5+5aye8/I2xj6zlC2EdDWsVu1Tk=;
	b=Swspk/FKNqXnyp/XWy0rLh/p0iivmFlrWeLwzOJLoDkTrte0UXTjmOjMvfIPuVFKN+/wTn
	yWboGWtwMUbh8oO35rcZs+PL2DtMFFwJlA1n4o3DpW4fDy4+terPioH6DggFbw0HUrRJYP
	XHD3Df0nFmGBsZa1gYXUlpOBJ5uXvEk=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NhInyjNA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qRdv9Juo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755837804; a=rsa-sha256;
	cv=pass;
	b=rghiA5p9uhsvZ4AFGoTB01lEtMoVQ7j+5ETB/uNUxhriwxvuZRiiLD2WGysPUymmP0dZPf
	/Jv3gKNi+xTjVNEATMPEDbPabeKyQNfhIIJZPht0lbIBCypZCGBoXECyuorz81h+Uzuc/x
	lD0LnLUm5pGifbKqjB3cZ8OK+5d+v54=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57M4fRTL009903;
	Fri, 22 Aug 2025 04:43:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hz7xF+GUD7jozmBM5+
	5aye8/I2xj6zlC2EdDWsVu1Tk=; b=NhInyjNAsUpm9dd878p9RAYnQLmrVj+3ke
	gwjFPJrZm+22sUzUEiUTDZjPmMgf9KMLhew3nUDpjwfTTm7BzhvXsIhhp7xlBgpc
	vLxIGG6L68Y0Dn6sRI5meCqgmo6Jmdxcdy8hSNsTSul/zA5GbLkFzdmu7KKfzItX
	C/wO5sXKapgcOPL2VTTuwDFIM7SYSyTqJ8E6MUlWHZpnZFZceQHJmRZ9S7saeyOQ
	B82Se/TpfvkgplL/GSzUGQx2zRQnh9S6FXOaET312T22iCI1klxewydXhNifC7tr
	6uB5MYCPX6Dc4G1qUZ41EeafqGhhjamX6Tr797V0gw3uBylH8VQQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr4rq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 04:43:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57M39qDj039513;
	Fri, 22 Aug 2025 04:43:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3sx57u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 04:43:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NdC/HaOA1qx5x9EAsi1IUB8N/oR1T8+Ft2qO6/ymc/NuuewiEx6PONQ2IXhLroxNZ2wNX6KT36WORkKVtp1MhGFwBpommVB9cdWO7kMdCL3hkAcUT9GvNd5A49egP5wn8vjE5HgL9raOtI17641Vx9zcGimteHjBhq8CBpXOLWiDu4mENWyVCdm3CRIioOXVdRNGnMfHshR3VOreduU6uBvDL0ScREijGzlyC2QyH0cGTmME4Rji/1Kp2QWRycFZMODZKWz9OvBuhTlZYZku2FOlb+eJki7Ud18W38nvIcDja7R6YB+24CjNXaWIt4F0/YIVr8umA66ZrOUOzqfW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hz7xF+GUD7jozmBM5+5aye8/I2xj6zlC2EdDWsVu1Tk=;
 b=w4DwRGXAx1i5ymqY66XiEzZm9AlTi9HjXZAsXOljBGG01yPZnDL1Bc3RPBpcndM70ravF0Pbhw2ymiDteStOuWD3p42sRLZo2hQl7XTy3HM8s3ru0PWpDkL6u9tAq/c2clxhjjwx/XWFxwJ9tWbb52cV434ZGvsg/omYUFGkW6bVC6tKqh2y18k7GKhHAfUCrQHppKE8eISMX+uHKqT5uJInFuYg+yd00QFg/aXq1FFe3okJBVR9fpDCqRwkcB+GYIJdhK3sRIjIYgc2FuwgrzEX63PoK/LCmKO2kNnBjRVwN9/pJOlHlLumXB3o5+FEAdakkRJKI2epqP0Uo/kjEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hz7xF+GUD7jozmBM5+5aye8/I2xj6zlC2EdDWsVu1Tk=;
 b=qRdv9JuoBeqQ8hTHUTFSPVP6j9G6rXW0kMG/KVy5rHz64ka2GRxLmpq7Z1eZN7gLlYpv7Yj/gCXkzTJKfHA+PiP0GyrcTXccXBTkXGd/U/JoAlxBK12Clyk9ZRtTU8Qh4rxLt+v62P3ZZfN5lXX1cUeZy3B5EBXS9FVOKvsqZwA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6580.namprd10.prod.outlook.com (2603:10b6:510:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Fri, 22 Aug
 2025 04:42:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 04:42:55 +0000
Date: Fri, 22 Aug 2025 05:42:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/khugepaged: use list_xxx() helper to improve
 readability
Message-ID: <3f723eef-de87-4f9f-b9bc-5495be504f9e@lucifer.local>
References: <20250822025732.9025-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822025732.9025-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0014.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6580:EE_
X-MS-Office365-Filtering-Correlation-Id: be3742b7-62ad-43e3-fd65-08dde1365cdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TYiG7WsgVCWDnRpg+IPRnv/lq7Zjhag6zFm2O4wZCqEeRf//8drT+Xu61pe9?=
 =?us-ascii?Q?OuEKK4fhrmFiclcVeT0YAQhdPUiN3VkIFkqrWs+A3t7Xv+grovxr6EGY94aZ?=
 =?us-ascii?Q?QKPgJM8tHQ7oTq0s8EQrys7gzsXdKhHhRWOwK9iXSFkUgJ8mdD1AQ7f9rFRq?=
 =?us-ascii?Q?i0psXGQnJevmNu+WdAMAuenYuW06hzA71jaqJcofTAYXBD3il3CM3bQgSJEO?=
 =?us-ascii?Q?Z9qCFM1x2i7r8SiLUkJ/lsLnXO3hDdZcsk7SthocRFZRSLhG0WGNYeDEPNdg?=
 =?us-ascii?Q?oyaL65q99glGVs3gh01NR2XydtSjoXFhli9B4gpzvgGUDddZwVajvhVACyhW?=
 =?us-ascii?Q?oWUETa1Wl5bS3pxG/8Pi2xtZubNv0XOsoHI9GSSEkVoSCRPWh9/mQ+gkKg1P?=
 =?us-ascii?Q?jXVa0X8Sjg2ZL9t/tL+f3LNxt88j+ssYNnzAyOpq+1/+um2FrnE/tAyJshsU?=
 =?us-ascii?Q?CIYMwiysfs3gmDj+ey+cxqSmNiFokYwDrMrMitdWUH7N10k1vRVPTkVY6tOj?=
 =?us-ascii?Q?q0xBR3Uu4fm4XGNQEuCA0SmNzJCFSPNzsvHKEaVdm/uoaI1iyg3Uhrfskdt7?=
 =?us-ascii?Q?3CiEZxgO81vNCDVJXFR2FkwXoy+X9EG6pT91gdgsri3dFbBOxKEiQz9bC3Wm?=
 =?us-ascii?Q?E46/KHH4iM9vUPCuV/vztVFSt4vEnYmqQC1EeVEgNrxtAQEgR0sgxnJBLqNt?=
 =?us-ascii?Q?+XUF2F67FXE34+H80CS/tJ5f7dEaiDZhdAPV0VXj/TwBdcfMhbwOcNN2p8+P?=
 =?us-ascii?Q?7bbsOtfRrKs511xJpd+fUK2jQH2KqGZG9npILiOV62wKs/zOjc64Og4AFPa1?=
 =?us-ascii?Q?BVRs6zl93sb6+ST+YizPFSwvEkSMp2mhomGkMd62Px2n/6DdpBjFvAAUu1ye?=
 =?us-ascii?Q?c/yB9H9sWA+q1zCjOw21dQ9MgDw+C/0PewIRrSihK8zGRFKDBZbVozlBchyy?=
 =?us-ascii?Q?/ZyEHMabkJKb3hPQsNh2pL0rAN3FObSz0rs7ipyewpxSYVKof6FjsJrEqGbc?=
 =?us-ascii?Q?J/YRehOv9RNcbrpYMgvNWPdH5wsVWeYmRfGSJ7EbX1blrJWaslbD7eNLOAMj?=
 =?us-ascii?Q?N+wU5VDjuHcPxd9cZhJkdrk9zKxKBr1g8U4+y+4c57voCon6h+jhppNjMQsj?=
 =?us-ascii?Q?tOUEoCkUSb2CMQIxDz/CnAdFSdoDhiXapXqkdUOBo76Q/qewIRV5pCJ9f4jN?=
 =?us-ascii?Q?YcuBqIkEB9s8JYxYL6stE1QAvbo3JDphvib7SGCD/UQgNg99v49PkI6HOY6G?=
 =?us-ascii?Q?gjUA2MxCmtOdAwM9G9nMj0SKci1QGh8ADy29n0ynfJo5q8dDyqf34QShHKSZ?=
 =?us-ascii?Q?QQOf9yBZUOAIj7uSlSEDiyxiYmsWecPThI/n1/+UC+YsY/ck6NOCEvgi+AiJ?=
 =?us-ascii?Q?U8eje2vhCnM838JGQ7iisPNtHkSBwQtJSuTppEZV5nJOC2Fe59cv5Pr4VBtG?=
 =?us-ascii?Q?BX/CNTy9iUE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fZpl0BrFoB3PjJVIE++YgfhlnhkNv7jeLmcfZcUVdZ/pi+/zAf9m+zsz7Ufc?=
 =?us-ascii?Q?rtRubxVEidqpTZ/xZhY6FXkCiQ/G+qRRvOtvetaGLRzQn2hXsmz9gx0ZQ9i8?=
 =?us-ascii?Q?rMSbnX9cims/YmWlrGh1iS6KcfuccnpgEv4xMhO7exQsw0ZmcK8Ept8mML4s?=
 =?us-ascii?Q?Q4IIZDi8h4kOUWl/zJ5rc5iZBawRFOjv0NTsxDE8upTIT7oSKrLsJfKavTa6?=
 =?us-ascii?Q?Nx6x4uKNm/BOhuEpxJXDAZY2Fv4Y1XrXIuuELIssimULYkTsneduLcRoDmq7?=
 =?us-ascii?Q?sJ6LrUwanOQ++bsEIpjbA+WkVCb+s9FeXALwtsSyAeZGE5u8drZRpgajXgDt?=
 =?us-ascii?Q?meEQU0MNwjyEJR2ZTvVDjmMt+5NS973rF4Tw3DZfWxzR1/L9+pFeFxq4UWiC?=
 =?us-ascii?Q?wrPSBKicNsf9A+CzvobIuyxWeueV7Cvn8HpRPnUeXtMeUypICZWJTdUTdPke?=
 =?us-ascii?Q?47EIIpShgZIFoXyG3IpwoNm+WRs1RyQUfkhNAHsBqcrya0dFm31Yw4yCQm/+?=
 =?us-ascii?Q?doI0J2l/XjYbuwZ6D+P5D6DQPhcEx8D7wOw21y9Whdz4GWn+6yRjFkymKli8?=
 =?us-ascii?Q?wMq+5DTb75xnK/ls7m7XL7OkAmSeCEJmZD+3Ynqf0ii2XL5hkd0EF0dKHgVn?=
 =?us-ascii?Q?4Nc5E6vscDpAXlLP2ZzicLs3hw6H4pXB1Asc4VjseziswA5IXzE9UhJWsheF?=
 =?us-ascii?Q?oAbrn4xNCuMFqt1EwD0PEPmtQjUsiyR3D16RPIM7Tg2zx3dnDJ5RCcdw6BSV?=
 =?us-ascii?Q?oowvgqsCttUMr+AbTE16mc5Bw9zXGbxQg/wjzrsMW7oPBa1ncbavzZgGN9Ou?=
 =?us-ascii?Q?MFQy+ED7s/uNmz6vh+9UNwj1RbPjK1mBM2Kcg4FlW1daQRi4xfM4SzbJYkVs?=
 =?us-ascii?Q?uYSbOlbI3mqyq1FklbGO77YjV2+p21k9MJH9CTzs46bDeCFBloVxP39OhGqq?=
 =?us-ascii?Q?38HPFt6KrI4rWeUZN/7VCJ/NqunotUZNVXc1D3xmONgQs2kUj8YZV5sHo580?=
 =?us-ascii?Q?808L6d4wdseu6sRhu/yaRAxgwn8AjHfMp3brCsuqwkaLfTNRaoo2HrYglo/9?=
 =?us-ascii?Q?NeR8Pb+9wmK8qXgZBdPKep1wuv8KoDL3KHxN6gPCzYeeS8QjszRSl5gIo81J?=
 =?us-ascii?Q?50GUNyNqAuY9KqaBQn8gGpi7tQBPpmskcCpfyZ11a1NZoC2ll4VYhkCODPwY?=
 =?us-ascii?Q?gaA39DbGmosFsy5/3FgCgCIWX8i1FL7wwpvUzv+ks9CM5rpR7kxbOibGc7UO?=
 =?us-ascii?Q?lkhqz+VQjCamlWheAhvrhg+hdIYBPA9IoWF7ZKywQdJxWZ0DHvw8413C+TJh?=
 =?us-ascii?Q?tU7JreBTdYN3LtkEt/qiAUK0Gd/9mrwBePocP6JGWLbFMFnne5MCK2wWwrbf?=
 =?us-ascii?Q?eTibkEedD6oqZwIgfdaQG130C6fGU0bLB49glGeR6Po+FHXg6FhFMpHS8xbl?=
 =?us-ascii?Q?wueDYJtZb6z7/amovs44Id4/HJEaWRhNEM3k1I7EH7MTRLBBEebLedoeDQ2U?=
 =?us-ascii?Q?I3TrwItlyT8NsT6muOpor3teC3VMHsFOB4BcNP5J6YdZuvBAOejASMn5KMBW?=
 =?us-ascii?Q?6S3mAN26LD9PbMxw3mfvKpMr35dR9qAh5d3NsZaIylZAq5OTEYjpgjrZpZUQ?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OR/R1KPYYzcvpOxdC1tO4L4w++yo9xiPG2Vm1WQA0Jxb06819e5mc6zyIKSBXdchn11d8mOzV9PsMrnRxFPawimNAiQW+fFnegr4XXle9r3yRApNPGB9aloIs8NvUv9p1Y/y8irVvazaM59QQhPdRD50qhKd4KOPVvNv0KH07oTOpKCXADpv8Ux5FDWbvt5th0NmbYiuXEUkIv1vGdGds+bO79aAJoycCiaqr5O4yaCke5fbRYyT02P386N+TNN1Yvnrj7bxv8/pkJbbyuYsEsnD1tuBft24n7yahmeBNWVOrpiPZg7jBMuQ7jklMqQm1toVyGYUzpc6WP7/b/tKiV/dXrli1ybTHp0jbXghn3BwGi4uSrvui3G+oUL8FivzzCcYk0uCQO5lMr1pZMG7EuMmGDVj0UZGsaniWQNIfYOtlYOnYgt7ldU1cvA1uNEmI4M06DYd16YDq0pjUtAmR0dJWY90EMYOhlaCz9EmbsuEyFh83dmM3/HiBf8jhF1x0mKmK/LLqbab0PqBVz6a1qVqcxh99h+CIJRLOSynUoHd2hw5rI2tHiU1O9D5jlKxFhxmjNhPplT5EQ1JhF8+4U1IjjIT3KrQ29/rJ4B501Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3742b7-62ad-43e3-fd65-08dde1365cdb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 04:42:55.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpWe6Bsm06sQBXMWfGPrW/0tGGxwaYYy1RuYjMjiS1fXMoDb2EpTbMct88GEW1D3jDL5Wtki2bjP6xQFgQQ5ejBtRcOAS1a7E4af/tgpgvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=819 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220044
X-Proofpoint-GUID: AmmnNduqbM5ndJQcYcrOgQD8V3Rl6JZX
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a7f564 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=bYdsiBq2WQWcLDtAwaMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: AmmnNduqbM5ndJQcYcrOgQD8V3Rl6JZX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX3SyXwjUfXxJA
 kb0kY5VW/0haAXna3Z2yRUKiA73qDaDx7dgxEtptKXyjDbcyH9rAwFg5/4cS6SGc6FyvfUDG4Px
 UZShye8tflIRZEotLTtkZWKET3Am5hU6pHfLlMRDL1j+CdxDhIQu5+Vx0mAlwdOdqF06aZL8VH4
 1GuK/XKCndf1Pe3ldMXd7vvFxwgfR1AkhN/EU9rPEEdSWDFPwIlZdpvvR2AzONdfUwEKghNKzn1
 4CNojlkwcy44oEi+ThaSeKUcoAxJDIyUngmaI+bAspX8mCd9lmbGAY3JYBN80z4pwZ9EgfNQpfL
 YX6iEusJ4z48qnnSCS3RM0BSF8naoifQLByG642JH/3ylbWos4XaWTmUv7zyuDiBGripJwWKPEf
 BntZhK/7yKdkb8ZV6gY3iK7Hiejjlw==
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1628FC000B
X-Stat-Signature: oi69kx913mum63ai6jp1gxi8my6z76ty
X-Rspam-User: 
X-HE-Tag: 1755837803-608217
X-HE-Meta: U2FsdGVkX18JSiHhcHTQ++NHUls1alQrxjUnnY+beGmF8MtfNlD+S7m3nCUzKWoRKU7bmsOh6dPHvctty9pPcArP//q8+qwfRNyAHm6wb4B8dxEvWQBbAcF+RD/LvEmU8gfGQq3MDjA4bTm+q7KDCHFcr6kEcBu+cLwdmgCHVyHlfdy7YbqngYw0LtKdAewgvertU7e2lRwE2FNZ2Qd5fFmaSDqTWI64+VNzZK9efbZAgBW4MRKvg6d5Mb0rYTtpUWXzIiTDUYO0B0/ZxiK3hCxbCtHe8/Ykxs4EAQv501MObUziFjzrzFDReNKBEiPPGKxlSigJp1SsA+D5opZ0U7VqmHcQRpvFvd2v3zVcz4jGqfrS1rQuZ30Cz0hM2L8CnHL20pGQvmDDJUuLkPbRIdviezEiyxuRknDy/twGw5nvQt9OcpUtBMwgVlHmGPrMsQA7adDQ2q9cYRvucVHJ7NHfXkbf8H6p1HKO+IVyqo/QTwXMYIpAwmVxAi690WWXScibykEqnGVYBTaYD1OVAVK0yIpa5HFyuDgELOsYqXaRgMm/qZ0PbWSdtzK5PMp/YaEGJ+HSdMpLgUKg5i5UXqCeHqAvk2wylStJfDPZqWwncE4y1+aTLLJJry4k0X3MwhXeg3JyZkEKzeOZtIAnKwKvvdZUV0QtwBTX/3V+IEbpcvgW77sxXgjM1/YAlHBxuFA9EHgfECfSJtHEJYa/otdc+qxSSq+SbXrUCUTckP7dtVEIiKMVNWLaPyGA1NXGnYxLHGhqV5s/yE5UndCbt1vL4pMLG7Oidcwqhumnfm2p+bLsg8JHmtuBp+inFGPDX4gA3rReDRVaPWOL8IjAouriJKcAysYEiq5ePa7xr2PC1DJe7LYeCHJVbsz0u03dcPVGtRMwfdvcY6nsTEzJTVuyvR+BbyDgKFIHWYNTu9ckRTNgREqCaOjjcyj+UnGm6eUgAKhDNpxhH6VV4+8
 hp1UC8kT
 8MzvpLg4ZWM8pC+Vpo7ar1lzPEEIfHw8i6ytCAeLsQLWOe6WZrUZPUeA2qQFxL9RN+MqUQZ0cqns734mH1VeSaV91oGn1gm3L2s02Q+7V8ZwAeJD4DbKZ40e6gzh31mGN5+6Zd9UJW3/ERVcN0N26tphRMRhTaICEWZtQuqoE6ttPHgOrVXjnd+/N6fw/Rprm6eG4sHONZYtBjDO+Cihan5PupFRQza2VMJOZ5vA83INErqHbJCn5Fe4D9RoBotXmM4+nMUmm8LfAYYnSyHUBEnbIHugKEGvL+gM1GD7BPbs6smet9wLp0eL7EieOGCr1xSHQXF2ehhTNbqBgEqO2UhGxFia5vYWYsMZLYA3upyU3XtQxBYSgPnKAciVwWACXJVQHr5yE8l8EKRmGV9Q5UsIOEQXnNS8hPNEieB4Wj0XHysjcHh+PZtjFS/DuFslSocQA1jjAMFBom9lW4emEkCwG5vj/GCfRCkrHhy0nC+Yh5hd+A02C6Fm291dT3bVD5+sjX1Rtckcqsz5q3FKQndpKEXbdtXsdfx44c8Z94u+vIWAyyKAw3PTS8iZ4YZEAQQmEZPk15AMpc0HfcEZomHkGWuLu31/1Wys56Tmms/daB2W9pO2VziSbEVvK6lessS7FEkJWo/i0d/B8dvH48PxBFxZHdfMJNGeP6NMCvctWvDg3QALbd/LapqkXxrZ5IBe299SMuY5SM3o24Jcz1tkK26HWlgD8gqnt4BNCEOSjk3DcKxH6xDFisJxYvgIS7r4l0Rt2PpjOpVXWtMS/ybQHuiBN4UDObamcoxso7vO3TgcaTh3ecRXmE7e0Hhe95SoMo+3N7P99KwAo+S8FGuQfOe9+p51JXOemHHJrsectT11CYMpTQOLV7Afv6fvc9V8f8BHgL4Q4fJ1Rl3mbk16R0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 02:57:32AM +0000, Wei Yang wrote:
> In general, khugepaged_scan_mm_slot() iterates khugepaged_scan.mm_head list
> to get a mm_struct for collapse memory.
>
> Use list_xxx() helper would be more obvious to the list iteration
> operation.
>
> No functional change.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

LGTM so,

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>


> ---
>  mm/khugepaged.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d3d4f116e14b..24e18a7f8a93 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2402,7 +2402,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		mm_slot = khugepaged_scan.mm_slot;
>  		slot = &mm_slot->slot;
>  	} else {
> -		slot = list_entry(khugepaged_scan.mm_head.next,
> +		slot = list_first_entry(&khugepaged_scan.mm_head,
>  				     struct mm_slot, mm_node);



>  		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>  		khugepaged_scan.address = 0;
> @@ -2515,9 +2515,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		 * khugepaged runs here, khugepaged_exit will find
>  		 * mm_slot not pointing to the exiting mm.
>  		 */
> -		if (slot->mm_node.next != &khugepaged_scan.mm_head) {
> -			slot = list_entry(slot->mm_node.next,
> -					  struct mm_slot, mm_node);
> +		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> +			slot = list_next_entry(slot, mm_node);
>  			khugepaged_scan.mm_slot =
>  				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
>  			khugepaged_scan.address = 0;
> --
> 2.34.1
>
>

