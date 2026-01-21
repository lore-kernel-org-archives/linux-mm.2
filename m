Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D031FD46957
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2676B00EE; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984526B00EF; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE466B00F0; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6E56B00EE
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:58:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 197FD1608C2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:04 +0000 (UTC)
X-FDA: 84356578488.15.AD1BBDC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 785D2100002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VoYXkwMc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ad9s1xNy;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYEh4Sqe57k4zsxhFOXi04dxvb/DRI97Aq828syFWsM=;
	b=8S778qtfkq5l+kn7OL5Q38e94ExoWI2qOs/5Pvirw74ST/i7lomdBK3K9jIzQ3FM/8AYbj
	XrUI/ewLi846fp+0ekGIT3CWD8oIX1tQIuIuH5uDzw0JwJCe2QXOJF4fNZPqo8mzBk40e2
	X8FNHmPYoXx5fFv8bbZy1B/IvRY+xRQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VoYXkwMc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ad9s1xNy;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014680; a=rsa-sha256;
	cv=pass;
	b=1VRn2lxRAhOZpiSK7y1tJYr4gIA4n3cLK5y2LMBYrYWvdwJ8AmnvXdjWeY4xfWRq2uD9DK
	4E7m9Ci7p8hzZMNCfFriqNKLebB8cdD4QMEJ5ACoyQS2N7XDH9GH4RAhVMF4bKC00kfVch
	0gvuPCaHFY/OQxSNShnxSu37YydOrFY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDLNev3029082;
	Wed, 21 Jan 2026 16:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yYEh4Sqe57k4zsxhFOXi04dxvb/DRI97Aq828syFWsM=; b=
	VoYXkwMcW4ybamiL55r4s51KQleaHBv8qbgnJSfsfBIigMvQwZvbyQPJ2BPR2bDg
	HfjKe3gT8rclHpY4YU72Um9Eg+WmBLPSzKo+Laj0hQMDBxdMkL0KnspZ+hFmAja/
	CdyAXkoAkReet2vWnnKSzf7+kX9qcVXApaAbev1bfN7Zk9+/2nfhUyCcFx5f/zM6
	FoZmMxF7eUIGTFj9TUms5J5PwXm8o09yffBEMduNPPYxyq3XjRtEpWtdKlE/+dIO
	1YmX7cqPu4RaumsvLWMg3Sj0h1pPcDB3Y+mdpq99ASO7KndX/GObGfd3l6c9Y0vL
	hZXO6L76H9I6k3a4UgQLxQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFshI7038732;
	Wed, 21 Jan 2026 16:57:42 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbgpuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D95610vfGhRcEtKeLoQ81dy2a7u/Og84pb3KI+bMx0qWF6eJuUJ6AJbi3eLyKH4R52q86G55gIHRcnW5Ul2GlavPWcLpjmJQdgeAlNaS51DfKtWqCStLIb/Ao519GQsFr/qFPGrGUgrJj7RAJ70IRC9psfYCyeaVGq9R9cgbGSK70G8BM64c4eg5nbXZXlEzcfKGAituJ2xp4z8/Q9wlz+/qkIL+xTTicqjn3bB7Rlef5ePqktjoNsr4bR0n35xphvUOlGyJjv54OFwXfStLmNX38j63ybf3jmiWbemdg6iNXQttEaTgd09uA+1S+w9gwOmOugDyO+GWNJhQ29Re8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYEh4Sqe57k4zsxhFOXi04dxvb/DRI97Aq828syFWsM=;
 b=Tw9WuT39hkZocDHtYCaI1fStl5KAm0wwa/1pnf0AIUtYChHGpt18NWtdX7pxdvk2DSiSTLEwR1UHnyeDVsLaiwuJibud+Bt3Ji5pKNz2uKf//b7AQkw0+U1ugn5FveVLFfTqeTKrKPsj2pWQR/mKW8VccEHGmnwv+I6zZXPVFXbpCMRHGRxlh4xzrrBvQ82WtZ+zZCl2zHOr+Fg19Ac+YQIIEwQgHDjDb2m2VNL/ZIp71V0AHt5N+yXa4nXMDbs6+y3Mh9GWeQBmJR6HedcCEv3KDSM/UPjfDhkH0KiamLvNImykRAA2WwulzA8nssY/ppGcZRuYnJSfrv+losZISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYEh4Sqe57k4zsxhFOXi04dxvb/DRI97Aq828syFWsM=;
 b=Ad9s1xNy1tJwGEXcCF99FUCei+dmWVozUiRkN5PrvpbkghFj5B+s4d5Mi7WKuXiEHoUqOIsOZTjAfpbCfVeOZwlqvp7kDcsuaFzCzpPKKIcbJViwYewb7wkFjaJE1FVo7WZsvG25uaDOWCRWm18rtGGDVwbh2oUIMqmoYlmWXeo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:40 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:39 +0000
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
Subject: [PATCH v2 25/29] maple_tree: Use maple copy node for mas_wr_split()
Date: Wed, 21 Jan 2026 11:45:22 -0500
Message-ID: <20260121164526.2093265-26-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0005.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: eab3ef6c-5447-4ad0-5ee3-08de590e2fac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uY3KWSJU8vJDb7w/DHIUBsLbOxRIBqK4clPtA2DG/N3UVdFb4ieMkkJzBSWy?=
 =?us-ascii?Q?yuOE0dTz/7MHT3NqRfV1sVqGW20CuaxUEtDrQUhYTNMSJE9Pa3237CgxV0tL?=
 =?us-ascii?Q?IC0QmI3oS5jtpIneCU5H6lvtkJcpQuFDrw07xyKUvY1xhAH5cugb6K//CyIT?=
 =?us-ascii?Q?U7sG3OwyCCYU5GhxzS2HEXYf2cIKQ+qVh/9q+dtAydDzSmzWXV4sVWE/9uGg?=
 =?us-ascii?Q?/9JzJw8lYC6hBxBilG/ArXli2E7S+w08M1nHNWHRY8/4odOhMcVy7me9lBc2?=
 =?us-ascii?Q?BQAXzw6XBw6YyUujGmEY6i0B/GaMEmZh6WFinlqdSRIlESD8K78ldmfj5vGB?=
 =?us-ascii?Q?DSFxdh0nIVGgcLNNlrRVG22uW00cKFRblMqh7tdMIzRl48s9bfU5k+wVYhlN?=
 =?us-ascii?Q?Zf1UmoDor75pX0i/fc9eh0ClaTZgXLyoVOvs6Tv5r+RoTKnsAdZGCdcggXx/?=
 =?us-ascii?Q?ZgjL1kNfpqrLSxadI+hq452Tb2TBUlssJNe0WRhEUMXnlUcy/jd8eOjbLzNe?=
 =?us-ascii?Q?7oR4tpPfGCaHa4iVJ7Poc1x2YPdMojsuSsFlJTvD++L+2CtXg64qGnPye07q?=
 =?us-ascii?Q?u+rXOWGa3ddcKQl6JKZ9ElVRErDEvZ8Mqz386boprbjCAgM9TqfejF6dUIpo?=
 =?us-ascii?Q?JdRMRQP/xccuDkZR1KCKIvmdFMrRLkXNIa6++hVE+qGkqVu0VDm3ZufL9TKy?=
 =?us-ascii?Q?w5iquNBsK7OM45h3SQ0XwhMIzz0SZ1hcymw83EmR+wj2QcgYXVW45fOdzWoQ?=
 =?us-ascii?Q?s5zr3xmr6R55iPVKu2KUG6JFDuVsNrMgBA13j9QKAHdNgn7fFgEZNsvJ13+g?=
 =?us-ascii?Q?mP1pnTQG++RBs25eY95P7QOvd7zuiLvI3kYM4obcAFf+C67DCojnbMjyUQrU?=
 =?us-ascii?Q?egASZtpWuUSdmiSF1cQ1exKTkZfxZvPWCcOJ9Y4P93IKuoHpvErXYE5KaX33?=
 =?us-ascii?Q?PULKVw3UjtFyVqe8HwDWA1qUzln1gVP8jY6HZ+IQ6lxE8wQNNwcADUKFQtya?=
 =?us-ascii?Q?X/dzdkb7t8XWXoKf8VXXB1Y+a2/d4sEoIqUYp2nSNMZXUNP6qgW3wNtofnP0?=
 =?us-ascii?Q?KPvVNgRZwt0n+jcvrhdKNV4BdXt6vjh2W0eVT7541EEFIOPe+84jnLKUdFBQ?=
 =?us-ascii?Q?nKUNqbTpbhmeDvUPGiAhglb0hlZDpiTfOYU9z2pXsu5I/AJEYNO8dCTGDqZy?=
 =?us-ascii?Q?ucQIgs9853kjNWlPsOnol0ZhlQAaf+IiYMANkBsRZkparAtX59zed1vqzx4d?=
 =?us-ascii?Q?0MpR9uTsy2/rKclorj1SojStKAwDXsZ7O2vf/B6zUrxpIdyvWsEzUC0s5D7q?=
 =?us-ascii?Q?G8qE2z1t8QLZlwCDAn0wlPK2ispXEHbF37VaT6LNhak8cBEprlj6ByKbm3op?=
 =?us-ascii?Q?ZVL+t+zKMZ5VX9ei4GCxKgwcakRcoIERO4gFpUYwAIhWMfS0Bwh9Bjlsvs3h?=
 =?us-ascii?Q?L21tr5sUUvrQFFOBPNja9g21xOIZWRrnAS8XGawQD5Dcu3SDo4o1Y3E9hxVI?=
 =?us-ascii?Q?EKTL/e/2uk7X1m5j2MbMpFIZB99JbHSIubEW+POkOQ/YCNIgq7NP92tGSglh?=
 =?us-ascii?Q?nPsazfLHB6opIyJQve8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qwerwRoFaPaJ+E3ERK9kRmvpJHIqXVOSS8LcSvFQsaLgd3Jj21dXL7pxE420?=
 =?us-ascii?Q?7/pIh0sHzx81c2eDwiKsJRGb6ac2pikFivKKbwBcn+4cfptBDaqt2qccJ9t7?=
 =?us-ascii?Q?K7wJrUyYDg1JPW/UprlP+xLbSI55VtF+3863bd+ZM2P4xEmTg07kuAr9VfyP?=
 =?us-ascii?Q?P9hqplNfvQ3SuVsuLn0gKJW/cInuuGR8F2719P4shNBIG9WfCPXNt1AtTUgc?=
 =?us-ascii?Q?W3ZH70bVuY7CSLOZQOi42YKp2ulJqrjJuHvDVSSiBtx0qXUcKbRmktPoh63o?=
 =?us-ascii?Q?XcVJ94zpzEN0xRtWCGe614Vdj1DLky+xYLAEWGZ8Ookooc8oRanttX79OYQY?=
 =?us-ascii?Q?UEQTR9KcerFqnH9IsugOOg7aSPdgef2kZyDH0dOGOKBtmdI4ml9aH/uG3gdj?=
 =?us-ascii?Q?WS1kUlU8eN/ZVcEAiSTXaCXeqDcxp7TnQxy8EFOi+RHAedWx6kNwqfR4+zdP?=
 =?us-ascii?Q?JqgZe7jt4nW+4M2xuf6PfYfgrkcJIqvxxxbDSeJ6qRfetLKpYaWBjuWOgYWk?=
 =?us-ascii?Q?HWxc1if2exara7O4F/27C65sNT+MAqj/v97KVyE+iVnPWUFnAA4aNFRM2lZO?=
 =?us-ascii?Q?5igJ0lLKaet3kxvVvl8v4FMYE2fJ7FRgCOjmnugZmGD0+R30vtno/3ZJLVoy?=
 =?us-ascii?Q?4xJiX9I+ig9+rtYCVt1TEMxlGzw7dLLfJ7F9vGkkhsOZaC9CqONgHcrWNJPS?=
 =?us-ascii?Q?5C2xGlyUYOIyCTyDPZN/qJ/PPHbLcIIMpTSNG55shahBWbUcfsM6WvNym8Cg?=
 =?us-ascii?Q?C3M+gYgCDa5w3MGgqR753SIhgyVq5luZ12ofzS3XReIA/s2qi7bAL7zYX5Zl?=
 =?us-ascii?Q?B6MJvEu6uCoglL2cU0OaO3jsFjq8bY9fJ/RAmaa5J8wXK2ae8EogczyhG111?=
 =?us-ascii?Q?+scdPO9uKACgSj66vRO6OBIkbkTU6wAUYDoTQ8/m/KJN2ODAKCJwhzCaihDO?=
 =?us-ascii?Q?aOqNZnYaC6tRj8bd1pRW+cOzABMoI9PSHasE0t2EjANVN2NwriRhkVb19TSJ?=
 =?us-ascii?Q?D+g7TVGgjPfbhvVh6BSofavNz6bPPpq/+I6nCDg/IsTlJeiRuyY41GqbIioG?=
 =?us-ascii?Q?Dqa9k4qAvCgMgCT2ys1MU9MYg0vB5rA+OVPaxS1ikJpGcx52WSRD+axlH5Td?=
 =?us-ascii?Q?lBsFxDEnsHttUpzP7CweqSe9KSad/gyVIHBdVPF1HNpJRntCXY3dZSQgZIjt?=
 =?us-ascii?Q?foBv4jbusHg6Ti1B8eHHpR8ZBXUHWkSGD14x8E7T9OQV+1yE7NA141eSKTPA?=
 =?us-ascii?Q?3ylU/gdYXkK68ay//L+hjCQsM38gVkRF7DACNRx7ULlnuoz8Q5KDyAkgV4N4?=
 =?us-ascii?Q?kG0KlETv7hyu1xIsKAOG4bbZm9XcaE9D7A9nnEDdMzsArhGDBymEywSCl5wx?=
 =?us-ascii?Q?K25my7ZLA9mIVRtysqxC1GM9bI//o9lKzxNwzkXwPu+yP5bg91VQKTr9RQ5k?=
 =?us-ascii?Q?fr12bzlZHbputbRS5PALdqqoEx5Ys7bdgv6GPf45Au8MXps5J6PK9BMlZAT0?=
 =?us-ascii?Q?cxOW76jN02lBgcu78PWweWcYI0eg5FMBsgYSDMm9DWM/CFrg+zHsHYqBDMD+?=
 =?us-ascii?Q?N8DrFV8qZLIfXYBZorq65Mr/lTMqPYn39R3PMIA1j2PB1vbkmAEQ4XgAnV4H?=
 =?us-ascii?Q?ieZcddev4YQatctYW2DdNX20D/Kh8vjSh7sxyp5uICmbvqu7O7UcUqaOFwol?=
 =?us-ascii?Q?gGdW2Rxnju/G7Hx6wmMCNxl+BbM+LEym0oYQCr54gfXlmqG09jEnJ8NIeKQQ?=
 =?us-ascii?Q?12qTj35lpA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LzrDMcewdbTOvSkrlrBj8guRrRHa3OFJORSAQ7q8aToldgX8ioKZTNehEd+zw6I4FmyUC407bCavVRA1ReCo7zb0xom6aOEw+hWMN/mjcNDNMH0r3lvkipgjrTkMkxKaejoRSyUVQv/ttx1WaPWK08HBjRtL5VsAzlJvNV7GE/P/S+gAXYVMSgwGG1iVEGstuB53fyefsdM/sj+J7yCWFPsULyy7FxlFvCp9ljesGXCvYAKwRFUwrY+or3L7ch16HEA69h6cwXX8Tki2QgAJWEH0Q5QoGjnjNyV48Gt+rKlGOg1WCLsaeRpbPSv1a3YjcEIFeIb5eE6OnoAAmmb47vvJFMr5Uk2kP31P3bT/eu95esAwNRNGry9ABtLIYg+SwEM/omqPXT9GphQ+xqLexGiEjWhq6bcXZpsGXfAC7gJeY5kRq73VmeQAHEEmX83p9G5oaVRSCi03qAnDGsMfaBNnamRcu0OqKG1aX+DzN8TMrhmM3Z53L6AxvxCGU2FEMzDrgJTSeb+LBtg5ATMVbZe4KjWQ8uexh56AmruRUHUVeHDPxKgJkSeshTdiTucrvhrGe5ZZhzl2IoHahXG77pJWZg5sdF7X2XYC9BgYzwc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab3ef6c-5447-4ad0-5ee3-08de590e2fac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:39.9147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXliE/eGFupQztOkx0+6CT6c22tqKDUlR/HV4B3N8xIhw9fqvowAo/4+nIRXxQzu3mvP5Z8paJbSCHpky3BQ1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69710587 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=tVZdP6cYBDUjvyGzC5MA:9
X-Proofpoint-GUID: kvzt61d8zHD2Jrnf4BnIMieNkwx2KLvy
X-Proofpoint-ORIG-GUID: kvzt61d8zHD2Jrnf4BnIMieNkwx2KLvy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX4Qwq1jKTW7QM
 Cc2+vnVeWwZI/upbmwDUUBqxEGTYUKbefn1CE+i34JhzvxbJ6b2odY3hqxFBNNQnhDrpMTrUrCf
 IfSAVyYiVWSSS3kDGEA4zYDR7KERFehFvl5+I6vKfNclEZ98Pin4zCRG4drY5vWU4iF59nCnUrK
 zeVRwy8swXMaobApmcC442wNbTak0npYILszjmNPlqk0HwvxHqPMF7TBvjXmsiNgOnT8WauPtng
 A5BbrQ9mvbX8A/PiO68JDsWJRiWyY+3aAWAdV1uj111wgrJklFZhjCN6qqXQyISfDoBHKEGgwMe
 XgsMZN44rbbNdb7h7qL7d3KWbokFwVKiNaKGm+306uZGOJaqfj1F5CDjwhy1JWcgUpnGRqIWjtj
 EKvSX1rYaSCzsRiCdUn9qGN99pvIdIhDG9KD9rjQNdFbxP4teAzmZz/7dr5xqI7MVv+vG85TrtR
 D7nNvyOYjiAR8oTO1Mw==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 785D2100002
X-Stat-Signature: 93wqjqiwufyxjnp9nn39q43yq8q7p3o8
X-Rspam-User: 
X-HE-Tag: 1769014680-318489
X-HE-Meta: U2FsdGVkX1+hHvehW1MdVyNyn2/Osslz+SLp2VGWAdPNL8Qu0wy5y0fNZUKd0Hc7ioB3iLkYAsCxaDB4cPYSitHBDACLFc3P/H6Nm1u4tQywNTYqvk47XGVdSEeTTcGIoF463Ky2O3GWLRj58G2MQnDzl15sSBeLdSz1pxdvGkWqpD8DxXLrfLjvfW6PTjFiJWxd4LD4ZOs13I8mEwmu6fRoz/sTaRV+UlTYv/h2PNiY1ghVUeQTPe40ZZVK3749Cwhhfk6akethiL+fEZqxYmJOIqaEEpmimQde7XYWrxEH8QOhhAq4Kyc5r7k0RQ0nJdgU20ZWtbz5ULhn9ZTy60RR4xaI9kFQ2uMJ97Ng5/LTrsrs8uyR2el9hXv3sspB/4JVmcwZz8b+S0eEbXFx9mVwNGRyh4fFQYyI8M6whDZrPmYBL8RuJHSMxSBrYn6KhWYy4gyZ/Ds5FIH/GJW8XRfuxuSFKLPChCu0VckiXVQ1AqKrYTFmHrGr23yX7nXEYXu/h0RpGGp5vN6i940xZv+8624FanmT29vseNT0sCpn2FI1gd140ti0Xe95Ue4q7lY0Zj08HQDE4W7gYwnQTXSIOIlb3M2enHHFgfx5+eLt0VNygR2pwpktFmhBx5vVbdZi5fUsTMucWfL4/15M0Os5b0u9CQb+aCQGnv78SuzSlLRZ3veKzhEDpksO+Bm5SRSE4D2+fH1sQB6W9w9tkRtIGnAtpaEZWc2saPDOE2EzvlCT7KKuorWlkyHjhiJgiB+JRBpupfx8eCDOD564O5rJZgMaxwv/6Met1oBwkan1b46rAJJ7UGDJcZOxRMh1C4BQPiF598OSPDZX/azMIXJ8U1QcqH9+AL77R5IP48hKyWzFZySIXXNxrAVsWap7HqiVzJ7vSqMuqnUfmFot6BMn72i6niH5v18b/G7oggnO4YlnyH8Z59MKsMY9zg/L+OG4b+nqfYmpPa/XgmA
 INIVo95x
 NIJs3gIYrCZl5Pyjk0gFCDf5bTcxifUX5H2EelR2DyBhveE9PkuIL70tWhFvXJEBbzfQX2HftA3jrsUVWQp9cRYY5nWU1c9R0QSAfxpvNTUrhoX/txJDOCArW7OEJF/LTXCH2ok1v24hibFMT8xKoVbbKgQXGKkWVH+4ZCpq3JNmyoqvZHfTeuafjgdNmeKfeH5OXccbG7IpVm7JqK7BN+yoQs6ra5Prnlfy8L7CNFVmsfKF2F2v86Wrg+x+haxSF4d5pQP3Yl2FGCcqAErjeRQsyiHMhUYghDejlqu2MCfjThQpvkVbeQH524jA3+1SwC0r6Vm39Eo34rWvyHCCgXe2AnHEH5M9p5VhM/u09ftOprSW/ZGsk6DPwAI5nbguA6Mm2KUsAzEcMmA5QbsSxA+Aq0BdymVh3XcyrVYjUwsKdTqFuA4WQIB3JZIN7+rMap99vc0scXuqMh4lPsiCCMnfzgsV/GpOelLeItc9Clgx1cKfbNBigsNX5iEK9L4iOz3RFC1/l7nj7gvLzBUQzX8r6+XRHUKd3iz2QBqGi31StLPWYrFb0K1573xqorlBEwkL8v9arauF+vXdXRg2PuR7JXDc3zWbHd8+0NqCns7Ica7UN0x3s9uGoJCRW0cz7el76QTXYbTg11rh1mVxED2+ojYpcZkvGPMbHr8F+Vx8sbPyi+RexhjRnQ9UMf1kC2Nmt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using the maple big node, use the maple copy node for reduced
stack usage and aligning with mas_wr_rebalance() and
mas_wr_spanning_store().

Splitting a node is similar to rebalancing, but a new evaluation of when
to ascend is needed.  The only other difference is that the data is
pushed and never rebalanced at each level.

The testing must also align with the changes to this commit to ensure
the test suite continues to pass.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c                 | 99 ++++++++++++++++++++++++++++++--
 lib/test_maple_tree.c            | 55 ++++++++++++++----
 tools/testing/radix-tree/maple.c | 11 ++++
 3 files changed, 149 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 191b855575650..8c97f2963b9c6 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4534,19 +4534,106 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 }
 
+/*
+ * split_ascend() - See if a split operation has to keep walking up the tree
+ * @cp: The maple_copy node
+ * @wr_mas: The maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Return: true if another split operation on the next level is needed, false
+ * otherwise
+ */
+static inline bool split_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	min = mas->min; /* push right, or normal split */
+	max = mas->max;
+	wr_mas->offset_end = parent->offset;
+	if (sib->end) {
+		if (sib->max < mas->min) {
+			min = sib->min; /* push left */
+			parent->offset--;
+		} else {
+			max = sib->max; /* push right */
+			wr_mas->offset_end++;
+		}
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp_converged(cp, mas, sib))
+		return false;
+
+	cp->height++;
+	copy_tree_location(parent, mas);
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
+/*
+ * split_data() - Calculate the @cp data, populate @sib if the data can be
+ * pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void split_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	if (cp->data <= mt_slots[wr_mas->type]) {
+		sib->end = 0;
+		return;
+	}
+
+	push_data_sib(cp, wr_mas->mas, sib, parent);
+	if (sib->end)
+		cp->data += sib->end + 1;
+}
+
 /*
  * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
  */
-static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
+static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
+	mas = wr_mas->mas;
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
-	return mas_split(wr_mas->mas, &b_node);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		split_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (split_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index a182e48b5f5e6..434d8a2fdd99c 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -1024,6 +1024,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	mt_set_non_kernel(10);
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Create tree of 1-200 */
@@ -1031,11 +1032,13 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	/* Store 45-168 */
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	check_seq(mt, 30, false);
 	check_store_range(mt, 6, 18, xa_mk_value(6), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Overwrite across multiple levels. */
@@ -1061,6 +1064,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	check_load(mt, r[13] + 1, xa_mk_value(r[13] + 1));
 	check_load(mt, 135, NULL);
 	check_load(mt, 140, NULL);
+	mt_validate(mt);
 	mt_set_non_kernel(0);
 	MT_BUG_ON(mt, !mt_height(mt));
 	mtree_destroy(mt);
@@ -1285,14 +1289,20 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
 	/*  Cause a 3 child split all the way up the tree. */
-	for (i = 5; i < 215; i += 10)
+	for (i = 5; i < 215; i += 10) {
 		check_store_range(mt, 11450 + i, 11450 + i + 1, NULL, 0);
-	for (i = 5; i < 65; i += 10)
+		mt_validate(mt);
+	}
+	for (i = 5; i < 65; i += 10) {
 		check_store_range(mt, 11770 + i, 11770 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 
 	MT_BUG_ON(mt, mt_height(mt) >= 4);
-	for (i = 5; i < 45; i += 10)
+	for (i = 5; i < 45; i += 10) {
 		check_store_range(mt, 11700 + i, 11700 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) < 4);
 	mtree_destroy(mt);
@@ -1304,17 +1314,42 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		val2 = (i+1)*10;
 		check_store_range(mt, val, val2, xa_mk_value(val), 0);
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
+		mt_validate(mt);
+	}
+	/* Fill parents and leaves before split. */
+	val = 7660;
+	for (i = 5; i < 490; i += 5) {
+		val += 5;
+		check_store_range(mt, val, val + 1, NULL, 0);
+		mt_validate(mt);
+		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
+
+	val = 9460;
 	/* Fill parents and leaves before split. */
-	for (i = 5; i < 455; i += 10)
-		check_store_range(mt, 7800 + i, 7800 + i + 1, NULL, 0);
+	for (i = 1; i < 10; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
 
-	for (i = 1; i < 16; i++)
-		check_store_range(mt, 8185 + i, 8185 + i + 1,
-				  xa_mk_value(8185+i), 0);
-	MT_BUG_ON(mt, mt_height(mt) >= 4);
+	val = 8000;
+	for (i = 1; i < 14; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
+
+
+	check_store_range(mt, 8051, 8051, xa_mk_value(8081), 0);
+	check_store_range(mt, 8052, 8052, xa_mk_value(8082), 0);
+	check_store_range(mt, 8083, 8083, xa_mk_value(8083), 0);
+	check_store_range(mt, 8084, 8084, xa_mk_value(8084), 0);
+	check_store_range(mt, 8085, 8085, xa_mk_value(8085), 0);
 	/* triple split across multiple levels. */
-	check_store_range(mt, 8184, 8184, xa_mk_value(8184), 0);
+	check_store_range(mt, 8099, 8100, xa_mk_value(1), 0);
+
+	mt_validate(mt);
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) != 4);
 }
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index dfd7099f0d8ef..d1c3b8fd83405 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35406,7 +35406,18 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
 	mtree_lock(mt);
+	if (MAPLE_32BIT) {
+		i = 47811;
+		do {
+			mas_set(&mas, i);
+			mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+			i++;
+			mas_ascend(&mas);
+		} while (mas_data_end(&mas) < mt_slot_count(mas.node) - 1);
+	}
+
 	mas_set(&mas, 47606);
 	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
 	mas_set(&mas, 47607);
-- 
2.47.3


