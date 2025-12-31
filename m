Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA70EE57D4
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 06:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 864E86B0088; Wed, 31 Dec 2025 01:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8129F6B0089; Wed, 31 Dec 2025 01:59:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CA296B008A; Wed, 31 Dec 2025 01:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5938E6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:59:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BDE77140588
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:59:30 +0000 (UTC)
X-FDA: 84278865300.15.A2541FB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4431E80006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 06:59:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=StZfptpT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gyuz+MJz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767164367; a=rsa-sha256;
	cv=pass;
	b=HBDaVykmQSN62Ck+1+RaLGyDJ3BWCJf8Y4j1gDb6br3uj5NDrx97G8tcpcYSEb5NrEQ3EE
	wyoIBHnbJyYNWqwHzYMCxdMTQ1NXIGV8gwwYLk0tthUwdDlCo9bRBkVXBLJppLjOjsO8kz
	mUnqdMX9xA0p6jey3dZAa9hd9PIMbSE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=StZfptpT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gyuz+MJz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767164367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVmzZj1ty3kTowskiOE3o1nVOKE3549NtYJcoSb7zZM=;
	b=bjzTjpICuJ0IgyCiBFVbtoqKcxkSj9/mJiO5rBKhg+OctHaC1DKcFhJRKrz0KBNAoBSKLq
	PhFXmvfpa2+tgw76lDdM54N7h2y3JauUmDZBW5j+MLg3r2qR2CjHw4Rr5SfG0MbZ9amlOW
	xH20H+JJZxb4y7iBoDayYnV1r2vaDtc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV0OwNn1138384;
	Wed, 31 Dec 2025 06:59:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iVmzZj1ty3kTowskiO
	E3o1nVOKE3549NtYJcoSb7zZM=; b=StZfptpTBf7xCTjISvnHjiFBnR3c5Z5/WX
	mvB9D30QCclvEpWlKCXlXzxEwg4KrZRIaVk+iZmHN1EpVW1fSFKSLynNnI9pFg7n
	ddQCrd9OC4Kkmc9auQHrlN8B53kZz4TJMfVvfvzQ98pOJyOfMzZpf/t9vq6nrdUg
	plvRIAVK6dah8++YlmFCEDM7USyl/u5TSX1cU5XxSwFwFudV03mBqknfoYBCHWzb
	PV0hNNqTooPW1UbwBhjWOCWbgD1xjeqGlMyfkpykc6y5bHyBHe30shPppqQuyn3/
	dv+AebEJlPCObdNnLSN/wP1bD5TShc7JRhFSwB+RkCyAdJ6zJF8A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba6c8ue9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 06:59:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BV2QiKS039039;
	Wed, 31 Dec 2025 06:59:15 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5w8cjus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Dec 2025 06:59:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yo8d+r2pLTKYZeY2wwowgPzl2I3vgdqw/G34Xfm4UQu0VzmO7HJ2VWjUDn5y18CyViIarf6q9o4axdpPs8bkE+MRVnf9DUdlGPG8f09hEKT+CGYYiwEHND/UXUDVSsvIPnPNxxrHwDq+ZY6GEI2O+60/ncLbxYVzwTM8QzKxfHFWtSwCO9uImWpMPFeuh4MBJueS2aI3uwObDh72wIh2SdM8Y3piVCuKWMEQNvkLhkIqaEMHJTx45tRIUjohiCsZRXCSliP7uOojhBsty2xnsI3EwawHenMOHDnY+7bQ9kr+Ogql8k00yd9kglB1uaWJMHlSHDf8DKS7r4sLVVeUlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iVmzZj1ty3kTowskiOE3o1nVOKE3549NtYJcoSb7zZM=;
 b=f8KxtdKKacF/0bg6tqnwrr4OEaM9Yoqtf+6zB/Gku3GPsb6E4/+frboJ5NiNByHcvR7lICHPWx7qkkaaK5/fdWsS5yLU8mAcxBiSSgns3lriN2dgFHBr3/YRn4UrRk+JTw6WwROteDUksNFu9y3A12/5QCF5fPuTYKnJardRfxsz1DUFE1Y1/tRbJ/Pm8XHgPw/O43Mtg3vfEkY9MTAeX2lh3THyn3nDN4soDuiSDJhX8rmRRhuXqS/1OkK9PUpJ0Q0N3Xk73/zLLe7Kn9gGzSfHWMlKEGhisY4S5AXn3lEXpXA8Ws5lcLT1bn2VTOcHvhrD3haJ+GADaWuZXO7V2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iVmzZj1ty3kTowskiOE3o1nVOKE3549NtYJcoSb7zZM=;
 b=Gyuz+MJzTEmBA1DyYLSjWGlyjYFNt3jshWt4bmmCe6tc/9uF29TwSePj8/4DgFJFI89m/i6PA3hqytjtJE2beBaBLyIHYVdn+yRnTdfHnTfT0Y/r28wCEe+WoSekcmXPzGqfktEffXRHMGN50buexxAIaW0ncJetCxR/cDP/QlA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB6169.namprd10.prod.outlook.com (2603:10b6:208:3a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 31 Dec
 2025 06:59:12 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9456.013; Wed, 31 Dec 2025
 06:59:12 +0000
Date: Wed, 31 Dec 2025 15:59:03 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: syzbot <syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com>,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, riel@surriel.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <aVTJt9M-A1BL8w5O@hyeyoo>
References: <694a2745.050a0220.19928e.0017.GAE@google.com>
 <aUt7jbCP_KQtjSbH@hyeyoo>
 <5f05de8e-04e5-490b-ab5b-0260d17d3b3a@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f05de8e-04e5-490b-ab5b-0260d17d3b3a@kernel.org>
X-ClientProxiedBy: SL2P216CA0166.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf0ee88-b53e-4e77-39d7-08de483a1a3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5gCuDGeserras3p0QhAqKyjH0zC5mADN5eHvKgtdOkkJrWf0vkWM3hz1jQdW?=
 =?us-ascii?Q?t/yYIPplJ2X5/TqXhYfT5Xy+jEcGGuEHEzUNlrZZNK/Ad/R1Ov68gLfj0UYL?=
 =?us-ascii?Q?sBnvOSUMLCVQMCthZwqmZt/rL+2uYP7fWTPYBN7Xwj813BCy3KuxiGTSZ2bx?=
 =?us-ascii?Q?n/Fejx79MlbT39iNY3a1FSh9HHZ1VkZoPPK3qk5ymIWpkJmadTdAY4xme5iM?=
 =?us-ascii?Q?YvMeCKLDPJsCTyzYvpl1fL9m7KkEJU4EM2kSrJCUJvQZaoLUTf3VB6LSq7wp?=
 =?us-ascii?Q?qXAlNz7R/dhQ42r3THvMJLWPcu2hpfeUXXMycTStlKXQys317XWUTKTmEkP4?=
 =?us-ascii?Q?5+8MvnLF8PE4uHrmzfquOLF0KPars2Bjc/rAbXjirGrmDRZRzLF+WDF9bw0V?=
 =?us-ascii?Q?lh9RKKKIpY54QxYLxFZ06254M0C1tnD/aenVbHIya/VwsPj0FohY6w276UPY?=
 =?us-ascii?Q?bdCUHfHmiOXoUgIrJ5QRt23HGNh1uBZLqLEq6yRvxaRDErrU+so5I/tlw2GK?=
 =?us-ascii?Q?17eBsVpwGkyaZbAoXdA9s0zOoIwXyaaIiRQ4DVmhOAr0Rd/O+0xZNLzZuCUK?=
 =?us-ascii?Q?DJCvc94XXbXJwRjnUeT/GPfonpR/N7CIEHqFTV7PMuuhTIjMpjqIxD5QidN1?=
 =?us-ascii?Q?n6m+c4q0XxetO9Qq0LcYEcE5C5Qq4hZMxArcvcRxfP4TOqIxDvXg+T71aWz4?=
 =?us-ascii?Q?DLyNGNsXb64xwmJOKggVc33U4kYcY1sekTsvLj90tSXOAlXaqJFB9cIo3qKn?=
 =?us-ascii?Q?bKZYubeMu15kpWcMFuUHatHyndjQ1M7Yn0OLCxKdlurnFSUNKmk9BqRVD5dZ?=
 =?us-ascii?Q?ShRXuPX2BB7YvQI9QiLc6KC/d51vlbt2T1jD0MeGJ+V9d3zNfr+yFYRDpO23?=
 =?us-ascii?Q?YcWZxcAwy2lBBLiYKiaHxiOuI4f1Ur9hO1uZ3itHzwQ3IqFeUbfZGRJwDZ3W?=
 =?us-ascii?Q?1C3ebPKNWn1NSk87Back/yna7L39SxMFlmcI4UiafXQSfc2exrfZKqYQ+JOg?=
 =?us-ascii?Q?hDu91p8S0A0QQCHWsT2CGU9R10yERwawJp3HMZBpvPpzOl8JpmcHm/vcdMpo?=
 =?us-ascii?Q?3wYXBqhVhFW5/etkaY+PyC4a+eOeNwEvmc0HoPne3BMIOH59kPa9Z56ocKUI?=
 =?us-ascii?Q?ywgE0+cJLT97bIssPbbKOAJy8soTJS6i1rnDyZwO7R3ElkPlU435FQtL5K5h?=
 =?us-ascii?Q?6J/aY5IVwbuU0W6poJ8s2GWNq1EwuKjoucR7yNg5/ehDh4+Radbp2BFA5h4G?=
 =?us-ascii?Q?pj2f9ymKjJw4iHgRGjAGsKGQhR1w8sG5q9eiwANZ1dRTp8+s9d1/5PuWBsFJ?=
 =?us-ascii?Q?UPnEqcuVBm/5d5RoOSir/STJqn/DA/H/TAtlbp2bXF5pXmek38AuDfgcKXDp?=
 =?us-ascii?Q?jZH4Ryx/hHEvqRPmVg24MuzgHGv/iaW2TPr+6SK4cpincT2qPhqPAButHH8I?=
 =?us-ascii?Q?68hyJAB/hOE8IRk8oGZdAo4rhq4i5BXE?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EusbA7SpjxZSQmCX5kgpjCFORNmAJ5mffU1Xe4V3XcyanQ8i0YMz/4U7/CNq?=
 =?us-ascii?Q?szniqYb7Is5DiXtV27ZllCzVk7r9Gv5JMJn3YDBKLt8OX9GKD/4jtkbJ2oCB?=
 =?us-ascii?Q?d0AEz25DSZzmf116DSzsCHuEk578x8WKjFKioL5fldStiVhVWR4tRwc7+DUd?=
 =?us-ascii?Q?FClnKBaeQ0Ey0lyKLvBD7Eui3jywPPmnT3lfJCXQZ3H5EYACcHn1YN3si+KF?=
 =?us-ascii?Q?PiZuJu/PfFxSKy7j4cyHVsQFSAwY6CErHjkzMSnvEqnIqPQfTxxrVtDs/5Hx?=
 =?us-ascii?Q?s5Bn/UBzG9u7kRWwXABJszf4+xuuTAzeBerHuSGR5MOXL8Xr+C4T3cK8GG6t?=
 =?us-ascii?Q?1LfCisqUxYJyT5ilKa/cjwjuuWdbJ8aoyJ0M60kupcHyflXJpX1wiyOf6kqJ?=
 =?us-ascii?Q?K61EWzq0GPsd1AituMYKkiDhtZJGhCYJmcWXAVAbl7x9b3bqfhO+es0m2w/0?=
 =?us-ascii?Q?P5yDO+nqHmTYr7HhJPHIC40Jb341lvwZkfmPE1XKtGvPen1Jm4SHqNcSqQWO?=
 =?us-ascii?Q?Ok+TZtb9FtF2SFkIcg3BT/Wfauw5xjMykUsu/ZN0BQAXoihm0hetZROwACNI?=
 =?us-ascii?Q?j9DpBFK6C77XOwnUEQIpGh7PoD6vatpBgwhW+ILYfM7Wsjo39IOOKv9COJRE?=
 =?us-ascii?Q?HKI+vTMOCxRUvQoKdCTEx2M+tn86GN1Hcal/C/XYstooBfsj3Zu3VcULvwiK?=
 =?us-ascii?Q?gdudTtY3qDluUZOsNbWuZYPD9nem/kkeZHLeLuY5JVUqbkWqZdoYeZcROR5j?=
 =?us-ascii?Q?55sEhsPPvngSc0nHlQQNn/8Ug8ArO93uVT8YueFSZqjoSAONKDKdqYetrKTX?=
 =?us-ascii?Q?H8RX1bMx4tAVocZuHVAh4uoo+tW/baWPAqjQHsRDIIuqQzjHluhDe610M4v5?=
 =?us-ascii?Q?J4lGDfDm6vpqyhbponUmvPO1B7Jzu2ZaEyoKdQRvg9YyW+5hC81z02ufgl4z?=
 =?us-ascii?Q?uyOUhjngBAtxuGR/wsHlTpdqEq/0F4uUv0d/GfK9qSAMuU1avnTTY+4joj8n?=
 =?us-ascii?Q?bNJSr6Ev8lnLkq8XwJECwoORyQNjDlkvbp4vO0IFyrMkeGLw/BomPpzxStu4?=
 =?us-ascii?Q?Lf6qfpDtOJQhs13xQ1mH4wWhSimYL3PuX0Kuz6A9iZAV8YxkK6JbGg1qqkFI?=
 =?us-ascii?Q?D4nc8H1Hwsg/rSgSkqUJNsRWsOcE64Y/X4ctHdTrG4W4iTk3UiZ5l0XrTpwI?=
 =?us-ascii?Q?I1wsqSnuvIelTj2pgNbDQ3Ww2SS39v/pednKvTEltS4/HEDoVEN08DMs9k/C?=
 =?us-ascii?Q?B99CEHp19Nj5oG5Tha0nV/hnjYYBAQ0e9NWOeTkTq6qmL3Am3jtGBmWKdgAx?=
 =?us-ascii?Q?S7hgl1pvEXads4sdc/yxX8rdScsbuQp7ibAfEtMjWIjUv+Bpf4dd9e9uoJe/?=
 =?us-ascii?Q?tQ3NAxgiux47ERT79xWV+1Mj8nQYnrNgCnQ0sbhZWZ+6z8K8hRX95T75SsQ2?=
 =?us-ascii?Q?v7sONhTcjVmnfF2Iy9jsZnz3U1l3dOVGBmoYUW7OXHJDGIVMUOqzLNb5J3GN?=
 =?us-ascii?Q?VrpnvSQmO66gbH+0lzonJgdsitA+of9wSwvzau2NI44TAkymDNDjwPeiLjsF?=
 =?us-ascii?Q?oJlzzgKRYd2VEBcegXkTQTM3LZ2GL8GaWIeDBJom9RKjueFKeA22biW+KPq9?=
 =?us-ascii?Q?yFf3L85sswQL8S9pw6FblB/u2dTqx219gD8Z9CPZZZJTuSGk2l4LH//Parb5?=
 =?us-ascii?Q?3u9ByL0t70fmxwirAlrWfd4CF1CiPMOxf8S4usIOonI+/yxnyk1vUE1OFxf+?=
 =?us-ascii?Q?FESaiHV9YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2FEtiEmD3xXja26iBQXP5EsAhBsCCC7CR4s0KTTX13scI1BU8APN7wv0OSssqGhr2nXzmGvGRmVe4cef7zsS5aR6z9evuHdstlSSaqlMzQSfFFXhwSmv9lxyvPT81RdE7ZJS3iNO8ez94mmwqto2UV00MnEoe1eqFBglQ6eSNqR2uAlWQ58P3+igu+VtpEaKlmQJ0YoIQwYQ8fY+RW4iFhZ3LXM9EVqAMhxCKaDDKhuM2ph7p1BXwHprAdlJBB4gnWsv885RlQe8K7qbptmjf4scQrUh6rh6K2QubQDQFXbTYReU+z8J1qc+Q/CeY4gl9wa/vS5fHlGZbBUK0MAPmH89lk8wlq5Ir3DfCxVEBVliym2M0bkSBO0eWKECXypZ/PGJS0PPaSI6Hi9YRiYI9L12oNLZPedAwD660wBPjkfmaJxdACgyZUxAzYPM8Dp1qGY7JqCWx+ObM3m7XjDf5ixaH8Wm1XGMlTE3vlyOO8YZJvS4MxrpSIbR2Ag9ymOP+JrLamnXG0G7lapnB+a9a6iO/hdc0YOWEnlmGOO38jHQxIDJDNgUHOATHCdmo9jtfrr9pycRRMnG+hFobur5Eeo8w9RWgL9CXba8QnPyNF4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf0ee88-b53e-4e77-39d7-08de483a1a3c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 06:59:12.0199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aOkilv4G16TAPDw7t4/WF+Qa/14ltSXYL7xRt5+AQn185DJaAGdFRluIAgeM1sYkaBQxXnVcMDETGLN+oA41EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512310059
X-Authority-Analysis: v=2.4 cv=a4E9NESF c=1 sm=1 tr=0 ts=6954c9c3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6m6mo79m6GPYo3UJKwEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LuDzJW-K8GmrsRAhbacW_2Xl1ppXijje
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA1OCBTYWx0ZWRfXx/OXStX5E6ux
 +BNIuCR2VkPxM3n2eopygDbillykEzouuKwJtHN6F3Mp05QNWzf66SJALl6C/NFwKmZos076J1Q
 8bS6nY8NnHlbSCY1zeNOnzC4vwX8LmOO3ImAdv+6t99vBwbM2jJpBUeYt2tMSl7CLrKSYamn3A/
 FRiYlp9wVIAx0WBkhyNBCjbNPQUlVDTdX50PwEnLrsNzWP0tJe5CCdNW2FOF/0N+AwT6LsGLN9H
 ec1LZXuIpsNgmW5f0Bu7PiDFgAQTtoVfJgiFNLWRdEIKqAFWjad9lYq6U4nb3HKnrE618PBQOu9
 H5RkAlEpZy8ufcWfTQgesX6x8+BqLzcqcuuALpDrY/XSd3u0gzEoWSFGydyvfXGI7JYn/IWthAK
 8pYJV17heuW2FIr/F0moFDSWZAij+s8G9MTjkqvBOC5E82hcEwcQFQ87gYw2sBcTbcAopRKIcDk
 jJtLrgofo10gVvAUvZA==
X-Proofpoint-ORIG-GUID: LuDzJW-K8GmrsRAhbacW_2Xl1ppXijje
X-Rspamd-Queue-Id: 4431E80006
X-Rspamd-Server: rspam03
X-Stat-Signature: 6aajt7b4ws5sptq13bdf1mpjfe7jcch6
X-Rspam-User: 
X-HE-Tag: 1767164367-565919
X-HE-Meta: U2FsdGVkX1/1B9odkYGepJsKj/rUgGtq4tfVlfP/u12NK8BSARdRfqiy5ZW5yxLMc2z90iCxK/gnEhj6eUzAJdWqobuM6FVlxJBm+YOyNAIo6v7945CRIT+Egg/SEwsa8HAM0G+q/GlIkexctp0iLgLxf2uN4hU/n9d+LADBVsvB6OiA3guouU6g/pR9uuHv6RjnqtvOeDEZGBpBpcuu/d7Sjo/66+0rl2ExpYHJ3UrQgDPhTVdiKrawdrznAe3x3/zmb6HDybyP6Uq9zDzCXXkEwVUl84XngHIMYzw1qf7uWh4SyeWx6Hr3ZpnWCHZXFj9HyISRkuUaOps6kXkqFtLgsOb8X+fDcnrHAN/X7J4pMZeDYylmPtTl1VJ62qvtIWNN9uaLt8G4wLQWIo75X+LMy9pWa3s0CQeS+O25BPZQJcV5Yh/nq6lrk6ygU2K8QZ1ks/1pPO90bWNFq/JE/bXM3nqn8fx4HwQ6cyQeN2ziYVMrtikiCRpNbuzXmckwWF6IO27FmAqxFmT3DjvCwkLWly7YYF6hg6Kckb1HDMsyD/eJjQVH2cOu+ot4ODH8BTtFlhM7vNRlJrWpkRONrji9//ZQLy00irUN/8h67wAvv8WxB4C80ZSJ5NrXRkmBLMo5uShilLY8c8RFB3diEmn5cuIsFhePfSN530FYD2GD/e/chQ99lSh0q2CToTjuINr0QKQdYqlaYhkEuOuLxFfRSiXhmsLDlsMvvqTyftQwABhBFsLjfLGBGsHqUA18a6XTv9YaU23MH/Nnn5k4jI6xKRQS/nFtt52HHKfF2D0J0Pkde8RO4P+1F0cTS1wTtOBNN5ia2Z5XBUVPoACpPtwZn159LZaPDsimR9Qz1mM43uCEZdQIMxZeuWqNnXifLYkGSrEFbDnBto1e/IIN7V8cPh5IS5xb3gsPPW9MBNp4EYznOq8ZJG4fjhTSfef/87BCHyNRT+SAdp1ZjZQ
 E++8ctzA
 As4+anf0piwT/XEgXYGKEbcY7UrkWPauGL9EQ14IFVvUXIZSlbOHpNM4vlQvweIC1zd23NFTcBApxp5TnmwNSoYG74+Fu5iF9CkQ518O/A6iCsEF0rEacWFPjNrcJ88ThldPGvkhm5wozL25ptwb9lUkB/dGrnysebCV4G0yQZ91RF7MRKgzpuj1/fkDsWKxCLtwBhMLz3Wvcj14hUHhFT0VQEpMUv5FZNEV20EBY4Nz8aH/wSpsBIGPXZjBv6FfF984Djx0u7WV/Xz2cpaxd6XhhxlHGp//P5Mil73yZHCQyP/eE+fEaI6DM583yuxI1bc6YCSOAVH6IwFaa4a1BHYNfBcTEMm4okNaRd+btIC3YehbXPheZ68/g7itd5PzLbwnukTd4ZNZzVQ1305rdxXO1bGQvDXBgP6iNAT8xeGszER06pEpNM3ANQR3wdSNOfmUbeJwne8alhH2QfGqGtPmBO62eRZSBvpH/38jm2jyat1Fh14XfIYSeT/HO8jd0FOj4MJF6qOjSa87J2/jdvrCmQ/UwbFFwVp0OQNrQy3XYVydd9Mo7aUVAP4HvYYete3nkav3C+uRuZJU6TYob97pxMtzns1LGEW2C/S8VJKQDe1piykGrXlP6aLj2FdiHQWx6LX1L5owjQCzEQTRQFHVliL0pnyq+PQvdXxhq4IsN4Hh+Wgl83pzp3b0HxmVWm5mOF5K100AnvatyAjmC4+kQaY4w9gxvoTmtpj0D1n0nBlRyOCGKEQXQ8Ubv7Gqahaj4eI9zbobBsu/uFBIlNWjybqXpm9GdyY9C/qfgBdo/wRXTAFGhsenGBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 30, 2025 at 11:02:18PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/24/25 06:35, Harry Yoo wrote:
> > On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> > Perhaps we want yet another DEBUG_VM feature to record when it's been
> > dropped to zero and report it in the sanity check, or... imagine harder
> > how a file VMA that has anon_vma involving CoW / GUP / migration /
> > reclamation could somehow drop the refcount to zero?
> > 
> > Sounds fun ;)
> > 
> 
> Can we bisect the issue given that we have a reproducer?

Unfortunately I could not reproduce the issue with the C reproducer,
even with the provided kernel config. Maybe it's a race condition and
I didn't wait long enough...

> This only popped up just now, so I would assume it's actually something that
> went into this release that makes it trigger.

I was assuming the bug has been there even before the addition of
VM_WARN_ON_ONCE(), as the commit a222439e1e27 ("mm/rmap: add anon_vma
lifetime debug check") says:
> There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> walks that seems to indicate that there can be pages with elevated
> mapcount whose anon_vma has already been freed, but I think we never
> figured out what the cause is; and syzkaller only hit these UAFs when
> memory pressure randomly caused reclaim to rmap-walk the affected pages,
> so it of course didn't manage to create a reproducer.
> 
> Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
> to hopefully catch such issues more reliably.

-- 
Cheers,
Harry / Hyeonggon

