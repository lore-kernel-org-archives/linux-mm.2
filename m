Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3C10CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 22:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AB18E0007; Wed,  5 Nov 2025 17:16:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125288E0002; Wed,  5 Nov 2025 17:16:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06CD8E0007; Wed,  5 Nov 2025 17:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8AE78E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:16:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70FC21604B4
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:16:32 +0000 (UTC)
X-FDA: 84077963424.12.8BE21B7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C2E22000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:16:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qz7s09nW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ncNb/MUR";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762380989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJPQ9R/G5HGMkalso8NzQK/xjaorbiGWgXJu292kO/A=;
	b=QWXHgYZQxTLUhXuFAmYQ5+hqKayVe71zSQUrb99uPYA8DDx0ChrVg/y2KgfgGiDxdDqN6o
	p6pxnVJGKyBFi0W9iyKuUdOfB9GG1aND4SK7Zmlsb85xKImb69vMstSyhQyMamuYgUO6Xz
	UOA++Ne8sQEbbcaa5xZjQ9+a5/EPhqY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qz7s09nW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ncNb/MUR";
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762380989; a=rsa-sha256;
	cv=pass;
	b=V21Q6RdP+/3Pt4NEfLpo76Q/1UkwA75EYpBIgkb0fHmmK3fd9xdq6tHZn2vNZL5sXGQOcf
	t+Y5nAaRd34jFFq9kJuWH6h3H4a3OxWDWd9laRNuyp7boBjkie+dkMLVSJFZvEyFR9lkTz
	UE3Wjwe+PlSJ8YsOHFQud6ZHEFI+lZo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5H4TQr013944;
	Wed, 5 Nov 2025 22:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tJPQ9R/G5HGMkalso8
	NzQK/xjaorbiGWgXJu292kO/A=; b=Qz7s09nWcijMITv0627E4rGg4YKpghI36N
	WSg2z2KD6GICfQ+fFvPaL/niMt4UlVDz71TU+b9X3rCqooksEE5SblzR0VnHNhAx
	YApquB5FDrlyBVK03GsoFy+tjjpyoviJATiUrjbFzWy42BZNs4/ab9sSPkNeK6qG
	yUgrdstJx2GIJHDgmWZPo039+CO7MGazqS6ddv/kHsg7e6hv74llWDyR4v98fj9x
	wZuznlAhup5lx7Fl8dTaIbYU5EJtYRvdH+egmrXCEeSDoBKio+7ESvG94Lgxs7a9
	M6ISzCF0S3/d81lKIC4zuQRP5v/wlJgrG/9966q5l6qieFb+3O8g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8anjgpck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 22:16:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A5LmgvR023040;
	Wed, 5 Nov 2025 22:16:24 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nf59hw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Nov 2025 22:16:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=exbx9wMJOpTnszrwVuddHpEBIBlJclvrsWXisRXvzRYlfnwvR38iRQlukyaatqCMNHiBFZbKNmrygsZEbtn3LbjpPtt3P7SmnN1yED06JHNoUeq4Xt+yxZYvOGD5CMLfk4RamjPxWyepVTN7pbG25UkFFHndfWwpH6fQwouWocmasOXT3tBMwFPxfZ4MqHgM/jmLXf/Z6KV2/RvJ/KTfuW3dxdv9StI7iud8m35rqDKaXE5bQOg+yui8xHiWDFTpGEOzX1XF6bYZmFEJQ3PCIWFBhfgL7ZFQDDJIZKCfzT32kZMUJghli6ufHP1RGQokiPaGX4IYm1wk6A+Ie6EYHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJPQ9R/G5HGMkalso8NzQK/xjaorbiGWgXJu292kO/A=;
 b=JIVInjQPcWj1CbRXLYwpxgXQxASG5o9DqgRIuU+4C89q6nt7otLZn1lzH9At8vkrA+815o4MozaPTNtrrLRxwG9u4lk+DgHJeOutFApE49LykbZEwM0cWM+HTdM1qbqjyhzwwYVr4W5EzjLuYcgfpNif9wRllAzqfV+WYxfn45kWjAloZRdwAooIj46fS3ITtdvFcZa18LNSAYJ6uk7t3HX0LD+1UbLBEUzFmajaBqm2dJwAF6ePKemeNg8emGcRYpYo2unQhZqpazz/Aq3rl+R5ntRYFPe+gzGlcCII51CuEzFFy+aHUi2BaZGHzDBz6V/iLYyBv6k9/svJdBHPYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJPQ9R/G5HGMkalso8NzQK/xjaorbiGWgXJu292kO/A=;
 b=ncNb/MURfNc4OgQOYiOyRuG4HVafIoSamlb7vgMjaOUc/KgZWw87w++bxd4XyP3Guhk/tG/1EOUnPIriTZXzfgmpyGKN8GrOZ7MAhaMpCYo7VFcq5/n9TRIgg8uqukwzLyser9mWc0ldGZ8ezTssSttFIpPwvBvCDXa1IZIqGR8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB5685.namprd10.prod.outlook.com (2603:10b6:806:23d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Wed, 5 Nov
 2025 22:16:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 22:16:17 +0000
Date: Wed, 5 Nov 2025 22:16:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@redhat.com,
        thomas.weissschuh@linutronix.de
Subject: Re: [PATCH] selftest/vm_util: remove unused variables
Message-ID: <9c08ffec-81fc-47dd-8830-c81b28f4e9e1@lucifer.local>
References: <20251104062855.2468-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104062855.2468-1-zhangchujun@cmss.chinamobile.com>
X-ClientProxiedBy: LO4P265CA0196.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB5685:EE_
X-MS-Office365-Filtering-Correlation-Id: 563904a6-bdb9-4910-1ace-08de1cb8f0bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6rDnZbrRliyOQqy5+uc5fbi/0dlawPgv+pYnqDzNW0xGu305sOC39kbQ5+Ir?=
 =?us-ascii?Q?kQlyZwsbr13nU29jKVJ0H/rwZlXX6Yjk49eaO206NpaB8tBRSbJ+sI15sAM+?=
 =?us-ascii?Q?x4C37TNn1juiQvbU21tL8YmmPDGn5rvxsbqIGXQ5/xkVAoX0yZeEMbCKHWM9?=
 =?us-ascii?Q?vxU4sRLjwVmg4fz4NHXnrRueY+0vGtVcUTwQaGeARZRm7canEQbN9xZzJjBt?=
 =?us-ascii?Q?EoDm97s91BX5ziEdBFCbth+G9+8hPvwF9ZCb9CB3e0UXTxZ9l/Uz8FxoaaAe?=
 =?us-ascii?Q?xYHuLOMGKbsvLSyndYZONOq/1CsW8VMNv0jxGha7aYMGNBNess+dog9Y+Htt?=
 =?us-ascii?Q?bmGcuaZLxjo2WpId5nDTMoSbD//Yueb2+HTdhu7nuQPbNXTnazzJM4Zlc6Uj?=
 =?us-ascii?Q?obe+Z2qmaPkg7fmVSukpk0h9oe0veMnUm6F1ldE6E9VEjNWdiha38/lfBe6J?=
 =?us-ascii?Q?+MtL2BXfv0FEpcMc2GfXaZSXgEgspT5gqjb2Tnc0IVNKQ91GnjxuVyBNgjdB?=
 =?us-ascii?Q?pKAEfIApLLz9Bh1RJbr+806fY2niooBNJQcatwsvwNYCuEnzPJ0yo4DGUkpG?=
 =?us-ascii?Q?vCchlM1kTZXDbOTjE4hTJ6dQ/I0EIX4s2SiE8F5N5HCoA+BlVRI9pYf92OHw?=
 =?us-ascii?Q?4jn6rGSXf0Jqr247HOQPUN0MvyRavlByTVRidPcyTQAZ94iJemrZ7x4Ct2iQ?=
 =?us-ascii?Q?2PTY2WXjuV0uuADHPQgyoousYAJknGKGK4CG3MwMW+GBdeQiglWmGXnYgDew?=
 =?us-ascii?Q?wHTTMbjM0zVU69C7tfia8lwP4wdjuKjH/6l47PHHGWZU+8wAccROtbLbjivN?=
 =?us-ascii?Q?vBTpW4u3azkrJSxefThsx5FUDxFsFiIHWLwzTZqN+BUV3nbHx8ytWnu2PZR8?=
 =?us-ascii?Q?ik+F9ReaRoUHUFrHnlHD60LbsAZE4Vx4Bl3OcZy9exmG8hbqKm9WqwJdq8Zh?=
 =?us-ascii?Q?DwqchOy2F+zO3owIdXthoVhBBzhuhqwu8s8GvumqvmU7MZ59MMiXN2ivEG23?=
 =?us-ascii?Q?rjysx9ct0Uua79qcMY6S+u5Jaaq7WiQ1RWWkrkUg3kZAMzIJc1YqM/9E/e6h?=
 =?us-ascii?Q?rx6SJx2FVqjXHo47y2BOVrVEi0feXFHizXp1pIhljoiPmOnYwUF4PWudX2K3?=
 =?us-ascii?Q?L6ANdJA56OUHyJcVPHx1qaEiBfGaFL+Kfnz+ZbQk7IFlOuXL+7XstzUCQPzR?=
 =?us-ascii?Q?RdVc8WI+M/qB821B7F4aib1sP+n6M6wu2acie37nsprJaEgKLOfvkVAmV/Pm?=
 =?us-ascii?Q?1vAEXi7dwS3YwzVILCgF/M1p/JHWn3Qjgcz/IxfkcGiwCu42G9zqUCSv2q3w?=
 =?us-ascii?Q?wIyVNgy3FVaaDt10Hy9vzrmvJEx98UtI2pb/k6RdVPJID6tygKZeb7u8I1yk?=
 =?us-ascii?Q?YeNakx8r0d1H361NVWiK595bfVIpyW16fn0nm0zS9+CiG2vhswPvpcPL9i8m?=
 =?us-ascii?Q?jvpvoWrZ22iTRP7rgNaGnccr75FHcNbM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GkyJjRqlTP0vCeEyOIPpbjDAVkYH5wWgPuiOD5A2e/kxOQNvAEa379ncZZ9p?=
 =?us-ascii?Q?I0V+z03XkDjD6d84vY7W20jKGPExTBWR2Uz8GMFCkgvk4cZ6m+gRb714CgPP?=
 =?us-ascii?Q?qnSsnkE8KzMv97RU8vBOFgbBO414N6LuqLfBTd5h3c/Zk+VdXo17RHAUDfSr?=
 =?us-ascii?Q?g0wJBqVFZXU+SnICwHTddlE25XppBfVDVv4SJqqsSK/cIfSEMrP3PrOyZFrg?=
 =?us-ascii?Q?kSAEssWPS8Z6M7wKK6U6qgcbxMpXNedLtOcKET61vH9RwW1V0Q5S0IMWQdtH?=
 =?us-ascii?Q?MFlUVviOqQ+igFRmkw4FppccxGhl8h+ol9Xilt4uQ+B5teTrQuuS+Jb5B8VG?=
 =?us-ascii?Q?k5J6xNg5oMZG5kpuDcjNeFw0C8R9yCIBpOyUZ6aLITmcplSbvUi/mDc/8EMf?=
 =?us-ascii?Q?ji65tncbYY1VqP6HQGhWe7TUEcktjTAWUt/2LFGI6eDFH9A/Fo/xiIPNv+yP?=
 =?us-ascii?Q?w9w+6YjG31ti0/vxZWYsKPL18oyByWX99oGD5z4GAfXynVnU+lA2Vmpx8jYz?=
 =?us-ascii?Q?5NMGt1A7yoSrQqOqwoKuVJXt1R7WG+0Ye9Xv3F92+HzzmuHawrL7d+FV/++X?=
 =?us-ascii?Q?104REpjI73MwPMIndKM4h8UDtBno9fJkIb2/ELB7vy3x07Qh8DIz6eX3VxWS?=
 =?us-ascii?Q?EDdOBlKhu+IL5bKeTotUpq4GhxBASZoNYNdDN24dIGLcekQPBPpPZMIVh/w5?=
 =?us-ascii?Q?uTnmwNdRZSbUfThzrf9n5f/CcZ8qP4m7MTttqByPW3rrtNRXpitv+Jde4Aty?=
 =?us-ascii?Q?Tt4PdMiRuWxhGij8IXf4dQm9evzVOzABwUXxLHNFLFndGt7lfHNoOvXYzDaQ?=
 =?us-ascii?Q?RgRV2uzKq9inB/89Zvw55VQTvviCFcLEJcqG8r9AZPPNhYM0OwCHf1WWXkHR?=
 =?us-ascii?Q?kE05JHcqOQDNT3UpyFLZILVc3d9TACx1IUn6u0HDkv0nkiL2To6vXw37LAl7?=
 =?us-ascii?Q?Ig0RZs7txXacCnYLzahg82NQkanjQDQ9tvPtHmNNKo9wsbqqvg2mZUaU7B67?=
 =?us-ascii?Q?ADpeIp105mgqY+arWLPmMseidVMwaV0kGlctLE86SuP+099ugdhLbRUMQhht?=
 =?us-ascii?Q?x+PVyxyemv+ZdudlzdXv5QKgkRGPeuUSZo6+7MBg8wsxhNzKZHpg8Th8o7Ub?=
 =?us-ascii?Q?Zj1ozcUkNzjnF92OWmCKKtLQgMvsOGUePrpblK3HXyE1TymOK+F+f/bmGeL3?=
 =?us-ascii?Q?A/8A42I5jOsy7SM9pKu0I/xJV+rd4emkTX4CPQPfkkOm6dDPmm1wb2mngT4u?=
 =?us-ascii?Q?lh/egaZBMwg/3Y0C1lbz3HIgzfeKEmAtKDYrtsT5EwUzaq4G2D/H/X2GJRZy?=
 =?us-ascii?Q?YYQpy7mwJ0sttcMvoCQhRvTgMzHKSA/UIwSr3sDhceH0LSVonenk3Hz0yPgj?=
 =?us-ascii?Q?Ys+z64mI+yfdOBpld9vcVn/TB3jPgLft9puFqTADSM2zU8TYVbhTki6IdlMo?=
 =?us-ascii?Q?wV+WiRIT39QIWfReHSWjt48bLfOlbS9qdEOWBeiDSynbFeyV7cKw0AFS1i72?=
 =?us-ascii?Q?qJV+z6fTuI3PRyKIcSa6mWdugnRzRlLMtXDpd9KGiX4GfreV+jpXKY5UUdia?=
 =?us-ascii?Q?hH7IRoc0Gl0CIobqiQ9Jwz9n/uNNMrywzR9FcbpbmZnXarWCxPxTuy8k82j6?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qyU/TGOpcE5KeuDwCT+ZnwoVQySxxEIjDHObG1CsTamFnt4o9nIf6k4NlcsHSJG7quHtLP1ILm39ReJNb65Zdl2i55OUOG+HJH+5hKVrGfN22699/SXHuQRDqVjPPSVhIL981+EukJ+tHoT/QqcebIkgca/TxYsHfw8pV/DBHllfask1QxYmy5GHXmEEhjhCkMZ0eChsrDCZD1gpMW6mxPbV3QBU2byq1onWldZolUqI5mpyyaPTEQOV5RcGdD4xu+N2ZAbLvUtvYWtFRr7yCjOOJgKpvbO9a+JJNEgEv+YsRGWRTn5SyW7Grqlq2Mev3xeYt59l6raMX9qEgpTiiMnkWrD07CAlIAULnwamDKGJVjrwro7Cx/5vYxXFx+/xN50QEV4J+sa70WvcG56ZVL+HuiUmRXlT29YKeZnCNsMvEKmNlTvFBnww5gciVe7mKAvFWBGrpdWxNXLWS5j+OPX5X37/WEmM0wTfFplAoHXxjDr92SHlxZX5KGUrBjy/xJGF6A/7x/pWfFjIK5cBMf//S9lhfgQxyht6S60Xd8efPwvbd1grtIKbZCoWFOQop6BK2XXxCcc2iY1h2Nw2kT/7w5X+zdiaTXvZ3C21wtM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563904a6-bdb9-4910-1ace-08de1cb8f0bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 22:16:17.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO3ovzVg/99EjHVu9uQJT8ibI+HpZs+XDJlPm4YMR+rQbh0JcwlDzHCXVuy6+ezgfgcx1MLsCvaQi77HfptBvhNAinxZUFvW9xUOS3/EBdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_08,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511050175
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfXxoAYmCNbMajM
 eu7taIpn5N+LaSpqvr4fbelCPNpJydJ+inc0kj7AYemJ77h1Gee9ntyQZaO9UWO0jL79VgBFhPn
 El6dWtr2RwR+HApgTyZMQd9DYdMAOh3l3eO3JQfY6En9OlcASjB4BF5/RPoSs11qwWPkgAvc5zH
 5NjG/wM1IRJjPn0dj2aw1MUiGVY88tdHijwZfZtXRfmHNp/cH0iUYTik1yu9zJtdFmT7OIy6/Em
 Mbo4Epw2D6sw2Re96x47QwxL0eJS6ZZt77K+syEtyGsLA9l2Sdbbuda/hOzYxk1D4yr82brH1I5
 6YfbCbIoqMKMj1717VI3oRcNiAH3Y2PbMhjtuiAleVHY8Lg8RLqO09Z3Kj7llwgRYnxFiCCgobV
 OIHWZqcJDHMDgn8DrtUAN1m32iFP6eaT1IgKl/tQxdGeG086NmA=
X-Authority-Analysis: v=2.4 cv=dfqNHHXe c=1 sm=1 tr=0 ts=690bccb9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=R5C9hjxsAAAA:8 a=jtWEZiDzbQNU4cJNAwUA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12123
X-Proofpoint-GUID: Pjb2noe-jf-uBfG0QAMkEZlRG8rxjUwx
X-Proofpoint-ORIG-GUID: Pjb2noe-jf-uBfG0QAMkEZlRG8rxjUwx
X-Rspamd-Queue-Id: 1C2E22000C
X-Stat-Signature: dipttks9qrzw8q9sfcoamge3838h57o9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762380988-417060
X-HE-Meta: U2FsdGVkX1/kqI1vAiEThhfcP67wDgoNQX5vtpj6+OOeQbj4/wEK9UV3P/DSopskKnUPsJkphJSoTDp2dSCLGg48hWjnLej7HOfPbTDvW9brOMXEQAmxYKWxZY8sEQawW/zDnWYr2GZMD53Umv0oSZmxsJzizUKmmbZ7IYKRWDoswB1ROXQ8cpE0Y/9Y6fMcd4KXAUDiusMTYlvaga4ZQ48oHhiIG3SNdLsgI3fHC4P2EA50HWrMaZFTzxQqmQsPggaN3o4W507SFzkkcQMNp5l/ZL9n+rKkTxLWCj5MyWLHjKeihiohoTxC0YlHRuqzvZrNaUAY9derEPQ5YilTYuL5/4sistdqUVZEMZzbgA28lggW3JhR6Obt4YedhiIq+vYx58KzfMtabGFQDCBE/ihvIr9tWqHE0HiLhp8irFFV2Qw8yT/z6Psu4bVOkwbDVAmtfoL13GA+vS+yHSUxXyrRGxowXNwrWz4He2wVqvJPo6wrgETiIg6E0iUG1tQuJTT54akI/z06nxfGs9tF5E2ahPakteCYdrfd6R1YX6h2AIC+Atf878OZal0l3n8TalQ6Lj9+Un44+DwOTLmm4erxnr7XRapCSuXH+SY++g3n/J2+m3OJJ5+ibZ+nREozpD3riVCtnYj+EyT0yjL3ajBVC82+goR+J0AlmUc9h1oBpUGi1A0jqmlclJEK29U56g9fW94G+6zBtX1qgKJozgKVhSpOeEEPFXa6KaxpfMLyPIPixpGLiYISaXd0gmXV0KgHAE/d44ciIwEnNvnqmX9joIBppBL9udjWFkM+W2u/kpxM8+lDnjY+l81wdeTBlDl15cCW1jRYktzGqCA89V0rYov3mkTKNWoLxVClo+86tSuxlfAVHAmxcdcPtZU+B9vUAtxgdGALngf1YIAkq1rWB4mkRPkOXZ2JUrfXprrzJNPqKVpx5v1Ss+B+hZu1LxVqF7VR/R1PtYpttex
 CNsR0V9L
 8aGLsruiRLtRVSJToEPXvJhw6vTrtBn8lXOHssfyDczralvlRL6pksOqYzh2hympdzIwYibXi32BMcB4o6DUPAgDIQln2QW2jVtRzXaOg6yusohR0cHVfMkqgehEBS+FAe4gNqPl0QS26m2MYnXoZBTOqFUyw2jfuNURIqGFit3RRKCUwzab+qAOEhNDZG6o1EU2Hqj7t1Tnb9AA/kMCA3GJtT2ReoXjXZJTHpr1az39oSstIIm5VZxKzzoQfAy3Qi4KvN0eMIE7aCV7fFyAIAZ7jlsubKJPQ5d9tsEjYSQBBSmsnmwlI0nfxyiHIuVYTXpwnCOMqpVTIpfbP/+y9bxRjzetx9fOMKsYBxboZFHxjGqukpxfO6fm81okM6v1l1vI59Q6FXgXpyAOZHY8yaZxOFMnj2vZcd5vtMlFs/NiTFWqD9whWjkDOHkrKdFO/d2Uiy35PuAx+rDdfIyG2DKzUEyTRKLSBUZWLVRYtg5pVT4BGjP7HkvXT8uKANCV3CpjxanHNsmKqShfAuYyL33c8rDUvJJemtRQkChZRUt/P9GAiu28vgdVQ2MyzmJO/joTRRhdnbXaBDePw9BBkU2zKmTGa6Weuc534VgUwNZp9DeMWsyxAZ5Y3d5FhA6rKwwHOu/9SBRbnFmogSx6b9SbLZKIYul5pjFp5+rIPg0OIBAgTUh9cVfOIsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew - can we drop this from mm-new please? It's broken the build.

I get a splurge of linker errors building the mm selftests otherwise:

/usr/bin/ld: /tmp/ccA0DyGC.o: in function `__pagemap_scan_get_categories':
vm_util.c:(.text+0x1e9): undefined reference to `__page_size'
/usr/bin/ld: vm_util.c:(.text+0x2bd): undefined reference to `__page_size'
/usr/bin/ld: /tmp/ccA0DyGC.o: in function `allocate_transhuge':
vm_util.c:(.text+0xb90): undefined reference to `__page_shift'
/usr/bin/ld: vm_util.c:(.text+0xbfe): undefined reference to `__page_shift'
/usr/bin/ld: vm_util.c:(.text+0xc52): undefined reference to `__page_size'
/usr/bin/ld: vm_util.c:(.text+0xc67): undefined reference to `__page_shift'
/usr/bin/ld: vm_util.c:(.text+0xc72): undefined reference to `__page_size'
/usr/bin/ld: vm_util.c:(.text+0xc87): undefined reference to `__page_shift'
/usr/bin/ld: vm_util.c:(.text+0xc9c): undefined reference to `__page_size'
/usr/bin/ld: vm_util.c:(.text+0xcc4): undefined reference to `__page_size'

etc.

The idea that nobody uses these variables is simply false, see vm_util.h in same
directory:

extern unsigned int __page_size;
extern unsigned int __page_shift;

static inline unsigned int psize(void)
{
	if (!__page_size)
		__page_size = sysconf(_SC_PAGESIZE);
	return __page_size;
}

static inline unsigned int pshift(void)
{
	if (!__page_shift)
		__page_shift = (ffsl(psize()) - 1);
	return __page_shift;
}

So this patch just seems to be completely broken?

Thanks, Lorenzo


On Tue, Nov 04, 2025 at 02:28:55PM +0800, Zhang Chujun wrote:
> The global variables __page_size and __page_shift are declared in
> vm_util.c, but they are never used anywhere in the codebase. This
> patch removes them to clean up the source and eliminate dead code.
>
> Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 3869e68bb8b5..3983c368edd2 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -17,9 +17,6 @@
>  #define STATUS_FILE_PATH "/proc/self/status"
>  #define MAX_LINE_LENGTH 500
>
> -unsigned int __page_size;
> -unsigned int __page_shift;
> -
>  uint64_t pagemap_get_entry(int fd, char *start)
>  {
>  	const unsigned long pfn = (unsigned long)start / getpagesize();
> --
> 2.50.1.windows.1
>
>
>
>
>

