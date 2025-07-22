Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61866C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3A3C6B009C; Tue, 22 Jul 2025 13:23:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11D36B00A0; Tue, 22 Jul 2025 13:23:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E002F6B00A1; Tue, 22 Jul 2025 13:23:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D08676B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:23:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 554DE160492
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:23:15 +0000 (UTC)
X-FDA: 83692571550.14.201E296
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 15F6C100005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:23:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=o7+MmAbh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gTaFkcGL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753204992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9ixRXJF6JOzK+hMS8zv1RncJkgUNFvkvOpDPWWzKYmg=;
	b=2Vt25xOOb7Yn2JZ72pSC/CJiJpQZwK8fKZbneCTczO6Z5PniaeY9mP7GNhGtz971PhEfhf
	x+qJ3jYQ1pAnU1r74kj59W2K0YPeRWIWXil9sas3kRi33RG8SI58COQrC7yDLcaQBdTlZ+
	e5On+1Z3VmPoW30C//Zjo49/zzRdZec=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753204992; a=rsa-sha256;
	cv=pass;
	b=VgGaTVIpiiuHDqPpGWBYZw3tcYAuuZWL/ibrBveM+UswtsVUnhivwygnuqwNWPDwzDzUpN
	jLSUfItkhopXpFE5Q9PB2HJ/rD6hlsJ4XDu+yuETYWTEv4pzn8mGhpsbUM2S1/refqxWKn
	pyR61ZaWzXSaJUv+mIdQNCLZ59F8w9I=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=o7+MmAbh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gTaFkcGL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXmpx001248;
	Tue, 22 Jul 2025 17:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=9ixRXJF6JOzK+hMS
	8zv1RncJkgUNFvkvOpDPWWzKYmg=; b=o7+MmAbh/93p6pxJ/zi4EvLGoF5eta6b
	GTGYIFOcGIZpYdSZhDSPRUfTlAXHehta4L7jtd4UTUcpKR/NdH5EPGYS/2yR5jP5
	zU/PhElmCe9gOP/ZZTQDTgIHN242cEYdxUT+zK/aEPTvrBvul1vzkfd0pOCtyw0v
	/hTedMdrI9o3WRRLGqKvsXeZbrmMsQQvLqbh3duKHrMPlG8ZLWXOvUW2nYB3WARO
	Mxw/035DjKeuE8nzml4VotMGojl7IYGzr4mDC2r03NQ+yS4XP0ftO1hLs3smPUGi
	xxvy70wUFPm+oEuNMkJ7dvvIkVboR6TsV/TudFRcduNd+M9oetifTw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpdvsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:23:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MGsYZJ031468;
	Tue, 22 Jul 2025 17:23:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tfw7dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fG5lqmTxRZIMnsIaZ80yvHcQRL2P9aRXWn4hHQsHxfGCGcT1yteMYew+kR/hm9TiiU1VhMym75VBYVErbJm2qL1ULZuB+OhTQqHWo1NXLbw9N/Su7k/fV6FqntIzhO7phwec5dyNW7QC1UG45jA26PZYN9CaOUz9/zB1Vcxwl/qdTkRiJOS7yKNjJaVnPjQ05EqIOopEVY+5YfE3UKdLA4u3DetkJvWToO9dzBRSiLhkh5J/GUu7/tE5HN9rQGN40n+DnQUJmzNaHme2XtM4ckgn65YcdE6ECEmAyJTv+zoU9IBYTlSm1eNqHIvMzTEq5jgwBlrG0NUGfB//lRT5wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ixRXJF6JOzK+hMS8zv1RncJkgUNFvkvOpDPWWzKYmg=;
 b=qoiJ9KtNZz1rup3Ksha8Vy0yki8hqAxASi922FyC4kgsV4WkiDGI2FeCe30bSglU5YVT+ykdRdO0ozqiHmFYggkJ5iSAuqq8tstAXM38XKvo2AcqZ8IHkYqH9hrfHrBcQ54uih7WFir7E6ZrNhN31jjB+4G1pu4LbNJnCw9NQTGcN3nUYrcwTH51y5gmTD2D2kp6FB15tTGU6JSYsx4W0DAN0NXd52oVI4dLgmJ2c7i97qY933sOH+Lu3lUM475Rk4yJj3Uxt3J6U8UHUALDX4fDmSYwrb+C8jpo18zpI+x1spf+j2dEDkSb912L087mnP/r5hHghqtq7bqlj8oKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ixRXJF6JOzK+hMS8zv1RncJkgUNFvkvOpDPWWzKYmg=;
 b=gTaFkcGLroGLaiWaRB8eUBqLuYYbLa+Z11K0T8bSUr5zr0JbnIM3o1Q7aUuhDk2WXuEn5JTzAVa29R8/ifZgrryyKRvnJV53x9D2sX8Bsf6QLlRt0deRjsFMCsyBi+IQdXEQoBppm7qoKzy2m+BEj1sdSoqUOlPvRTkvYN5iPaw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF120DC3FA4.namprd10.prod.outlook.com (2603:10b6:f:fc00::c09) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.28; Tue, 22 Jul
 2025 17:23:07 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 17:23:06 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: [PATCH] MAINTAINERS: move memremap.[ch] to hotplug section
Date: Tue, 22 Jul 2025 18:22:58 +0100
Message-ID: <20250722172258.143488-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF120DC3FA4:EE_
X-MS-Office365-Filtering-Correlation-Id: db12b2fb-ad87-4bb3-3b13-08ddc9446c39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V8lK1q/zFHp2APftxZfR8RN79pe4otkPO+boiuJnlBwTj661dDFcWnBK5zAi?=
 =?us-ascii?Q?eaEBkFTTRoS0lE1I3jE5Eawx8UKNfW6TtgFJevJLWkm9C2/bJqXncvD5ttvk?=
 =?us-ascii?Q?x4qIc20I6XrHk8h7oRA1fOzcf7VY12eBD6D16jEqbsGNiX7AqhXBE82dzX6r?=
 =?us-ascii?Q?0ag7ANKMR7RwOO4Yr4ydak0/8vxbM4VFoIiOvrvVAbmKEnhfjp21/B69z3Nr?=
 =?us-ascii?Q?/p7/yXpfYARfMJbxJGaC4zKZBfghG6U8MvkxFqIMtKTfLQAWOwnysYB3wW86?=
 =?us-ascii?Q?BUVQE2hcmhc1305D0H7sp7Kg2GVu+lJBgNCcpAp27vAadhFPzxVTCWjiHjOY?=
 =?us-ascii?Q?pqHvj7J2Jufz2z9Xzfw61i/fhNNYk1LglYLrS5MLrVNXYmpLAV9JL+bPXo+B?=
 =?us-ascii?Q?sWuehDKlNoMSK6HjSOh/bpykTUmx5Yup97lJu1ml20Aaikx6uXpzISVH8BeH?=
 =?us-ascii?Q?+sfEBS2Vq06Lg8nUMslvk9SdRRUc2xnChxDPOA2jYn38oi/vv6g0NhA+mN07?=
 =?us-ascii?Q?ADZbCeq2yFRFpVNGRVbPwCB5IfRd+3vTEtmBBE9fCgfiawsvUplE3WMHYhAY?=
 =?us-ascii?Q?FRKVxJH7oMQgpcB4xlw8MSK+jv1P/6VWjhINvC8Vl2+AAm0p2ytf+FOwbzVe?=
 =?us-ascii?Q?JJEd90n2qHFX2nLRpjxqj7S77xGWUEXfVHUXw0GHi66iLBhVu4LvwLqwAHaM?=
 =?us-ascii?Q?QMubdcAKdtKa4qcwBSy/43VYphRnvWoNs3waXVUsNW3Gl+tOC8p6oDPa2UIF?=
 =?us-ascii?Q?KcCSe3r4cokvmEeCu6iCUjKqTq8Hqt8aOxSd8j/1Rs4/F2D6KzruerNEA/TS?=
 =?us-ascii?Q?RgflW365pGxySmMkYxcfkLA0ctqMKD3IGJhIxsV9I5zMIxIFwwTkP9medJdU?=
 =?us-ascii?Q?0/6XlnnJ6tStDGULk0StmmX1plO4nwq1V8eW3vQUXQfCxCgnl4+Phv01Ce6s?=
 =?us-ascii?Q?MnV+3xcntUsvdVp8opUp7M/Bo7EUVZxJus9wWksI57eHTg4DOqhTTLgkBUWB?=
 =?us-ascii?Q?73BmX7X4O9KGyiZooN3QVneT2VmojZR/H2QRubAPanGMDnC5ETx22W5kBtM3?=
 =?us-ascii?Q?qyz2/wGFp6jdSibVJVdDTrH8NWr1K7K5WBO5y8m9BmM1zz4Z4bJqOjEhtpVo?=
 =?us-ascii?Q?Df/aFPpG2KD3Owu56tU8bd9F3xn5f6gcxBwRz+6eDBqFcdrWA986oRRGDIcA?=
 =?us-ascii?Q?mxEusbysDxyXGUFgNJcnTbJv/IiKhxZX+hmS7hb3CW2DplzkumPjU33bdVny?=
 =?us-ascii?Q?NMpzSOZ8MjSIPqH1uy5znJrOV+/kgY5LjIuU0Cc7hPCh57hGWj/RjOx3HMAM?=
 =?us-ascii?Q?1CLaNxYumnSaJZpblY8vSEFPo9etgMW8r2i/8CUEG/TrT2edfQI+Oiu567Y0?=
 =?us-ascii?Q?PBqo8UEp5k3ny+kRFotbuksAhN6U9uXDS69Qs+aPolFhJ7dR+q6qpHmzyJIB?=
 =?us-ascii?Q?AB4sQSmrAzI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k5w/V5kEWSHW4VSuu5S7PZ17CmYxlh7G97Jzy4ZqxubQS/Ung4LR41rZMiDQ?=
 =?us-ascii?Q?4ZHrKGngVz2UEMtiUF8N82hxpZnFt3RObqNzEBEoz3oM2bTrQER83MlK4+dB?=
 =?us-ascii?Q?SrdBOEnLcja+ltsp3X30NEqjczWj+0xOaWnFmo+Xz+5xk6YnJFA2pHjgI8vp?=
 =?us-ascii?Q?JUhfIxV8IMfgIX6n4eOPCczm1x30up97wO88TKIswieSwQ7oMxGEMNnyIiAS?=
 =?us-ascii?Q?G7YuZ+FHUBNWIFenEvG6bGNngXwG8jQLjGWAT6n2JeSySydL8nKNwEjtIPwl?=
 =?us-ascii?Q?93hicd7tleV54A9uY4T9qJSzrRmFywjplp516Az66q5iblsHF0joVDg6qlYs?=
 =?us-ascii?Q?WtH6DVaTY6YdOQW3B7vhY6wnZ7CC4FlQtOvSCwFOASnT7dCX1buV16ZLIwZm?=
 =?us-ascii?Q?lCt+kgVEhxG121UPWjA2Nb0FQ9ywEii5ecBoy+C6Xsi8b9Q265emW3grMEAC?=
 =?us-ascii?Q?HslGNy5/Z2R5FGMlLdWkKjCmwiGxUJ77rNv03olHwE84lTcNvssXW1T4vfPW?=
 =?us-ascii?Q?5x2Kd5WHcJQSoRJSp1ja+GznTzxfYKTNCAAV8qfHxpGiVqJBDH9vLzq2YmQS?=
 =?us-ascii?Q?yH2OrKmAX+0gYHC+L5uq0hfg5zmhnDIrk/slFgR9IgbvnxATXA5roVVVV/gT?=
 =?us-ascii?Q?MGWNSkO2JHoe8GheQOf3pfaBPJF5vCICUNUuol8/Y9XMqGAAAlxA0J8cr1oe?=
 =?us-ascii?Q?GEkos1hPYL2o9FtO+htMhmu7ce2ygO3Ixz1WnV7q9gaYX7xsjqe1+ga/G5LX?=
 =?us-ascii?Q?JyrTT37k2q3+dhTjy3YAZX7g0fFesFqd9IiPLQMrZhtd/+L9gzOwrXahTpIe?=
 =?us-ascii?Q?0yeoKnBwWoTZukiHwRgUTX945mK6pSIchVIh7MnOfhdtmIw6542bNvpBLB06?=
 =?us-ascii?Q?ac2c3Xh8jg4sQPy7JZFTDeWZgR559V+UthwlwRShULbwwk9kE3zPxBA3Kgty?=
 =?us-ascii?Q?FVQMBDHfz3t3Gscb0idyIdleAhc0jUpjcXS9/E4u0gfMcUD4s7yc0Prl6XJW?=
 =?us-ascii?Q?+wn6obgb5ewwZLjw8uplihDpdifCteVvIjsvjjrITGZUlEAWBzvMYlc5Ff5h?=
 =?us-ascii?Q?dQm5tNHQwXNrO+BPybIYcoZtK0YPlk5wdGWvvxnPsnfRwoMwCZ54h/z8Tvhn?=
 =?us-ascii?Q?SYpRQ2112bPY2VqS30LhqyOW5JpNtUao4KodPff8D+XL4b7tTLWIq0ZL0Nua?=
 =?us-ascii?Q?noZny2yMeZ7hYwLftoP9IOd6Pusm+EUbgx3Ie1J6TwaPXEuVwUvkuY3S0ELL?=
 =?us-ascii?Q?2viaL2MfPwC8ZPDtTI8k0AzOAiTBRDHb7zNtUCkp5AbS3vl7mVKS6DVyPASA?=
 =?us-ascii?Q?pPp2GbqQr0H52yYnwgBINyIzWSEW073cRFhJfeKyWNddDXfVHjPKb39INceA?=
 =?us-ascii?Q?tmxk+fPTx0wfY2dqTNqq8gHoBT1P3h57yqBI7Dn2iY+QBqE65IH9H8gvx5rF?=
 =?us-ascii?Q?YOBuBBUIwsOxZOjdUwIOvgyNoYGcnGSdQPoPONOm2t9ZoQRoTEnx8ErToA0x?=
 =?us-ascii?Q?2ETxJgaUlbxiPjKoA0Nmtj1avVbXTzfBw3EeSCRTYlEXUAfC9Pi2UQzLAlDz?=
 =?us-ascii?Q?4eIFPLY0KatWNd4biWqYZq1aYefoVAo5C/FkUyYPS5g5F5uO+YVUYilxkiHN?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vM6PZZuQHjHuW70u6l9o9cDR8Gjcwo6nkeMotpAlJXk0HuaQWdzHjCFKqm298aZmBxf4liqsFC7pfkKXrsw2/oRBwn+5ZK/iXJuWiD4rV8lvKQ9arnXcHn1PDuBxkRvSyZmiBIUFvAkobh1UPRoqNO6P7AwfVeN4ibcS1Y2mQqhG+z5d1kCdn1scbP3oYKHNA47oDES+E5yo4oGYqnGhtBYC3Rsxihw5jV1BI3BEsYlCw9/rZIAaUPvc1LTNzcuhiP3HU7Df34La2dHez+q53GRBnHnjKP0ITRNfAvK+rUz4BXnvQ3W6vyKWbRxEizGhSAQbP+z+Qc1mfhzwFTkxSHGVg9FSuyjB+6J/PY0esWq6vZkFfQQDEhk89atoRohe6xinZo8wTUsgUN5tlWlM6dosBy/Slz//QSoId3FTvoUvvoHxZoZ/vfcNYhkrAmKbZuVmZuEwmKg2Yp7YYo1MNJfmsDatcNAVYn8woZ+QhzKC628FpLhFtdhpWAoU1MIh2gzcz/JyniV3DornMw4LRAdqCvSTFSujJOHqg/Xivec3PV2Mw1cRnkGvA5A+oIHhUOoXoKYLXmFE3qhKgwLJEumS3ntfNksTID65YxDSdnA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db12b2fb-ad87-4bb3-3b13-08ddc9446c39
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:23:06.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKUXXmm77rT0QBTAnQJB1cunKP/3ydco+7x1JAylQ9p+Svkv1e48JFr6YiiltP5ryaghZkOA7pjvGaldG/d0C+7ROgurPUpDlYcS+1N9kIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF120DC3FA4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220146
X-Proofpoint-ORIG-GUID: 1sc9sGZHgaRHBr59AMSSsVnjHPGbNHlc
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687fc8ff b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=z6576rNVTJVoBPOff3AA:9 cc=ntf awl=host:13600
X-Proofpoint-GUID: 1sc9sGZHgaRHBr59AMSSsVnjHPGbNHlc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE0NiBTYWx0ZWRfX+KNMFMd7/TVz
 D7nf3PzgWHEqPQcFqr7MlKJhTncZ2O8hKJRG0b9q/95+dRKIt592kxqT8fIPnk4CEcgALYUztR6
 rFlCxAGKjb7G9iGKO8dEXvsUQ6dXCcQgZ/CIR6wwZVIAli0Y75Yr7fi6hCLQ5K0hR8YW/A5whok
 rHknSofCD+RPyK/Gal/5bXtY9guKSB0s3By6e8LOM01G8rleaOCUGdq9fB/HWOvFTtHPk4Ozn1C
 pMgznTWPHKL9EafvB+4mhs7p+FO8+i/6vHZp5UGkcfNj6YgW7fWW3hQfLHlHPFSGyxMdiv3AEfC
 Y/5CVnHOWGRehFzxcTWxxjsuGKVlhc7+HGqOWKET+xVuHI2j/WAR+wYmO0ySiZhmfHHeUX1mUjL
 99vrR05SLKsciohsnbG16xVECntzOQRmvdxGeKyq7z0hYPLkruMl5CZnrYaC89XYIWuAsS0p
X-Rspamd-Queue-Id: 15F6C100005
X-Stat-Signature: 7sr1cjwyp6jk583t8kdophst53rwpafk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753204991-715624
X-HE-Meta: U2FsdGVkX1/X4JbEbcdG+R5dk8Ufv8+VlAJUEu6EdC0Gs7d+BehACSUg/mXVp25lgOfJIOx36OhvIosOCWGqLYbAKB7/Pv8dt/y5uQQOMdPfS5NR23rYSYjnWTOwgnjLHvshmAsU77M06ZfQGRtSKlo70XBahhB7zb8qDqFgAZp6rO5deIfRb7jcQDdoBUSwNIB9p8g0+NVAXbl6qUFY/er8aXDJBmxohJtBL4n3NSPxhNV2jJvbmteXUjUiDQYJ3q6xNpmOMXJ5K8vFXZ8k3mpCuGLMm2i4dZWs73PWqAIhsHJ02/knpBYaLDRkSmz3V0EiNhVtfYf89n9RyafvheheYzQXONyTMPNxqYhdlYvMQlDXS/kSIo4DHgJY57PFk1B2SJfayauy9LAnVAt1ytKXJ+Ts2fkLQt0cB9sbcwHtUGY1q/nKnKMdBVhf7DmGUrlC66z6I/k15rKhYnJgiBxEpB7AQ54bY8+iK5YGKo2uMSTcRdpzESdx4bwgSv/dZUtSPhgf7ONImQ6DIKyr3dAfSgk3OhB9J90v07vFM4+fF4EuY/0irXpscOiq64ZgaP7QWJQ19lPUltOUZra0qrCymmT4psGsn1ZqqDvhY6C5N7nyvLf4rlEDZOfAKBNkcZd6pp5mWRVaNJihdORvCalDe2MiCePOADp8FYZGG9z/67+tcPOAGcCR7kOypo+KyfbUyQeVU8Z84jfqYXJd6hKi7R6rmCH305PJCrBe+T1XHRzLpWGj9UnXbFSU0S3p14YO6IZDssUNquaAQkzvVvF4ThiyAKewDudj0RGmahMGGSoA0RdbHtxhkD+sN/NBfe30/Ki4aS5JLs6kEoBH9JxZRPLYJfTPX0DQ89gXO0uBFllahxjXI7ZGfjYlRN+r3B2TY1yg99yEH6dzxaszxhuULt4kXvv038mtidNwvSRJHXDw9CIb2YvIsCKRAeOvtyi2fiGxNDYJWG0cI6R
 o9jaaGzP
 ok9czr6RcMamTvSA3H43MMzAFOuWFOe2ncItjYbBEd+/U25R+iyaObO3W5vGAPW9px5atgS+q1Zbg+qxLUzUtM9uTRd6PEnp09nodF8b8kSuj2oWOQMKt0HtQhvs50ovHfYLoE6giDdrdeaYU19C0pdLCaN5Puink9QGATJHta4++HG7ObuyRaPI975qK5UCqRhgWFLTcDYASzuwddi6U1cER/wGlf2vnsYPbkVM/iyg2jpoyaWGAq0c0wUw7zS02alprCSxh4pNoXIX41L33jMD+kLigktcjOL0sz0N1fOqIrscp7BIT0kpB4njZ8kOYG1nhispc09tAEBJN6NGoP2Slbw/WIOqPGWrtvrAiHd/sL/o3iQnMztAgG634ilGHS/pF8T2eDhqDeZbs9BabqsotXF1jBQutSPBXTrXugZ5HATcx2fVErbrbbSsfi8oCzRCYADO6RrVDFSodCKON6uapqXZPRCTyJ56mrvpL3izsywewNkuQVwJ814L3Ay4yMH5x4iGW5w5o6eqQbuERqDdm9CnQnIhGwXtNXcRKlFk8tgyy+UszBnbayOHDgL5qfUKl8/pksh3hYMlt2QVm9rdTEkyi3DQEUNij4dMTsBg3dAxvHt9GXzRYYhwh+3ry0yFe6ZysTlxNjsE9u4b23qTIfh+J2wRolea15u3eaKqclvvaplIoIjtlZ5EzWrMi1epzbFYLJFy/btQROIuRuiT+V6sfbwwZkOPf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This seems to be the most appropriate place for these files.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 837bc5cd6166..68b8407926a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15729,6 +15729,8 @@ F:	Documentation/admin-guide/mm/memory-hotplug.rst
 F:	Documentation/core-api/memory-hotplug.rst
 F:	drivers/base/memory.c
 F:	include/linux/memory_hotplug.h
+F:	include/linux/memremap.h
+F:	mm/memremap.c
 F:	mm/memory_hotplug.c
 F:	tools/testing/selftests/memory-hotplug/
 
@@ -15747,7 +15749,6 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/linux/mempool.h
-F:	include/linux/memremap.h
 F:	include/linux/mmzone.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
-- 
2.50.1


