Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784CFC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AAF78E0018; Wed,  6 Aug 2025 06:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BDA8E0001; Wed,  6 Aug 2025 06:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17A98E0018; Wed,  6 Aug 2025 06:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBD618E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:45:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 90BC0135FE3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:45:46 +0000 (UTC)
X-FDA: 83746001892.17.0D10818
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 383A1180010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:45:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=liUKq12X;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X4yBPnsF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754477143; a=rsa-sha256;
	cv=fail;
	b=BL/ofjHCdNoMYgiaGrxGYlHE+UE6eRh5tnVMQj/lZ1eWfk3kwHi2wCIC8zfGLjDoQYDA01
	cOczFq9b+oyAXY96eM/gWnNxC+1rYnNg7SS0UXRU03/srS2w2JkHmmbZ7z6VdSjh6ZzP1s
	Zxf2TWTtU3qpOFGEL+X7b+ZLuolIb44=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=liUKq12X;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=X4yBPnsF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754477143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/I0VyNryTycVsJMDTquDoGcZ1ilRU9+H6GUbm7YxKk=;
	b=u3Z4B1KjZl4wpqNvJpAA+LiXDnMNG7Y1eBEVerFxRPRmqFANwY9+d8mgLzwbwQ0ZutJzDM
	m63tv14xW7VQLrte0oAzkYjwQEiDNmXZhnuGPTy9sFM5bYseTvuq0Fk6ywch6InhK5a50O
	LgEsMBtQz4IOw+ZPKwCfowSz8LDdg9c=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5768RXiU012859;
	Wed, 6 Aug 2025 10:45:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=f/I0VyNryTycVsJMDTquDoGcZ1ilRU9+H6GUbm7YxKk=; b=
	liUKq12Xm8NQy/ert7aLX6wq0xg0pOmwv0tArKXo64FUKbQb6g/oVZJhh6CDFDJA
	TG604LIvFEw6ceDyIv7WesrWzjml2F4D6IIQXZoMF7Voh+E9EvJ6WKBKyso5Axl4
	1pwBBCBnwndHnZCRDOjt27nPNFS9AL8TRBc9Od7Tcn+l5JrxdZHXyayK0wD2TdGG
	x43VOnLGg7p3wBfgCGfnYJhgXvqIIe2cZ72i/iGJ93dnqFELssc6JtA0e/lYnC6z
	TfSqc2HNRa3oMN3qBCIMOEKB9RW4T/sL60wJPC+JPIMqAqBguzHffXAQ4fucoq2U
	u761vT+jT3JKSTLKpds16g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvg1cns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 10:45:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576AFf5d028233;
	Wed, 6 Aug 2025 10:45:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwm3ndc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 10:45:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=II6a3d7m3Ncqtl9Xes+GDn7KgOiOl+wagGy1ysck6vTTF8ua+hz9qFsb0+Hoch0Kju/IfB81QMVdTv3tRDh613CRU2DNdiBd5H/zqD7QxS7H1aCWuyI8OvR+jgRqKfdV3NQlLg56ONgHI68oTODpC42WTsoMe7iU0TFBgvKWI997Z4Yjx8rKW+ZfCm3DW5ihcefeI8H9GWwTJ93wRgP3OIyqO7jCDtnBLJPHM9Xp2xf5kaCd17xK0r9iywnj3wbnAgaztiGFaZR1kZXmwqNmrBM9eSu12JFzhWatQA81LX5jviOVAuwAEx2H5j77HO7BjuGao38CcGUSY+MZ5E/Xtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wqEaz1w0Y0HbzPr3NzkU3YxKa4Ki1i1Lve8H2DpdiQ=;
 b=SYbi0h02Ik89fjzs2XAO5wW78XdoL67UvSY+Ucp3eaXk4wgWmXp9LMp+ljDyl8o9YM4oTNu7IHagcVZJFa9Hc3bYjKyasUnKp+dpdgKxENAuWOQ+++z55yG0uI5a7+WZPCH7dlFEEwnI+yTSwDq1mWklFeeSlElj3euxGjxzjFFSw6jIyKir3C0C30nw7LCywAw1rr/BCeDNOv2wfTiNNDEd3kH/N3w7L8hxTsX2kSiyrYH8UnG2udiA8OYsgUfayjcboln+3NGuwpe3TcCx0DBiOMNny0Ew5U4AixOGl9xH2tmqwE+WZwdbSRcOEnfig9YitRbpYpEqJ5t+M77D7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wqEaz1w0Y0HbzPr3NzkU3YxKa4Ki1i1Lve8H2DpdiQ=;
 b=X4yBPnsFPCnI5ooxvkgTAhxahUWNuf+cKnrP1uSMslGv1vpLgI1ywNJ5bDRs9OmcLJIUhamLxF2dqzJV3h1VKEFe/lPawmNxP+hUOhi8QaRvzOJuGg4IK+Mv3tMSrujzJqXhhkycV6+PAnuFN7NIzoe5609SoQXE9v2oKWBPFSU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6318.namprd10.prod.outlook.com (2603:10b6:806:251::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.21; Wed, 6 Aug
 2025 10:45:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 10:45:17 +0000
Date: Wed, 6 Aug 2025 11:45:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
        ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
        anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
        ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
        quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
        yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
        hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
Message-ID: <2360dd36-bbde-4e7c-8054-24a9e4a6962b@lucifer.local>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
 <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
 <0d52d680-f3d3-454f-8c12-602f650469ab@arm.com>
 <9cbe9c6a-0013-4239-9347-bf5d43021fe3@lucifer.local>
 <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3d13396-8408-49c0-9ec9-1b02790959aa@redhat.com>
X-ClientProxiedBy: AM0PR10CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: 79e54eb3-3cea-489b-8bbe-08ddd4d6553c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?ev1YTjp8UNN/GPki/EwY+v/frSbOmPuAhYTLxkv+8l27010/ceIx/arRIp?=
 =?iso-8859-1?Q?bKu9Tg7xGujGQFlZhnLLiMdDjAIYLt2q9Z0lcCNWbANl6Xqt28uDS2tNkb?=
 =?iso-8859-1?Q?6nTsKyKjajhK4YzODXs0y8i2IXW0ToQLHmEemVKGIWXKvGP19f1k7r4OWn?=
 =?iso-8859-1?Q?SWtUfktk7lTgeDPfWS82XRJUYfJ3zJkTbc64ee0SxgIfKznfatOlR1/628?=
 =?iso-8859-1?Q?nbPREft4mkw6tdVjSd7gF3jEGEJ7N2phi4LH0VaJBZUyzymaBaKupSrEfF?=
 =?iso-8859-1?Q?VkRFS4hr2d0wPSGQ8YHqOU7V9t2odAldAdU9BrPTB7FQzm0gLPPnKtWqoD?=
 =?iso-8859-1?Q?CtgUDJ/1HbhbnjjGYc774Ipq2WHBgE0qXxEDOMLBBAkQTrLJCxhVgpAvF5?=
 =?iso-8859-1?Q?73y3K+Lc0NVVEmuCekJW8z2wUp8cQVFgmSgDsl+xoHvWkiZ48wvUlntnWi?=
 =?iso-8859-1?Q?sT0xM3Z2bj/zTNa7Gns7Z8sdoMmRVCO9n6Jn2gqkV8RpmNokoYEFf2vrm1?=
 =?iso-8859-1?Q?B3lxNDFT1CK6xlTxPTxjxn6Cr2xxBBqNW7MHbC2XAK+9UEJMxA1TU/tF4O?=
 =?iso-8859-1?Q?fLT5hBWvIlQh7/BrQWNbjMwfLyERGsE9B+V1SRK6Bd1gRZKXNMG2gzD1kZ?=
 =?iso-8859-1?Q?kgKdHFE6PPCVCu3q1Cck6iqhxtlNEOjBZowlSnOOo7/KmhrHeAXGHxV6Ee?=
 =?iso-8859-1?Q?nwfwWn7rJRlkKIyfiH7Pll+E19/VGPEDbr1+y1Iv5YpulCaXNibzfSGz5i?=
 =?iso-8859-1?Q?8QlaV/A3MKiwxRYq+SFsn+SItKXqULxB6NyMGgMaRyVSsInnF9DdmrOd3j?=
 =?iso-8859-1?Q?j4diexuRbEpMK+49T470d/OZXdQJEKlylP4GSTTeJL4v+PCxZLNv5H+2SV?=
 =?iso-8859-1?Q?3RjKBpz/1hdPLtuW5xgmYy1cfOc31O3PaN1LAFw3/GvcocbroAShJIVaz9?=
 =?iso-8859-1?Q?YFmO4mFumpwMsN68ql/TJAYaRzBO9NJ4NRpZeHpG/t+nKwS7AfCUqMP4xb?=
 =?iso-8859-1?Q?GsyXwF9Z8fdiK56/3utEnck4Tw5Dvg7E0B5VuZQjZu3hlOKSisCeVRJozv?=
 =?iso-8859-1?Q?lc7iaZyXU/jDZWNV8VkwH6xL3pVe49iQDi1jit3wur0GjAq4J/IsfjfRSf?=
 =?iso-8859-1?Q?IMApVYygff4rwBTgVUuo94C919HxjjbWDdNLyK7HWmXrJ5hzkWJetBs6QR?=
 =?iso-8859-1?Q?Im4BbWCGHNrHn5L655OYO05mQhkSFZBb4LCiz4BGC/ipQw4KZq0U//wqmP?=
 =?iso-8859-1?Q?zGhjX+oqLRZvKrz1vXp+K7BvEaz99M/DTDt2mFrsLlzWvZnngXC4Ra4xJo?=
 =?iso-8859-1?Q?aqRmbB54VeV7WDAwEcRXGOwLg2qE/o2K/JsmJlp+O6n/WvQcQM7OMkaz2d?=
 =?iso-8859-1?Q?dDRAXAx3DL7H4UTR70UkGbmNV8Ap1iP9RSd2ZDRbUsPuaEZmjC21eLUWB0?=
 =?iso-8859-1?Q?D+7JepB/AQ/lHOxcYwFprHBFsjAlFf02hHLtgA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?Zmjl8qUe1+OuDBJCR1t8S6GPkuRPtcGXdFz/y8lAS9ET1ywuGMrcrVTykd?=
 =?iso-8859-1?Q?xLy7c+4gb4fgJYiIypYm+asZ41KuDFxzlga0Stlmz7w2RWvICd4l+GjN8D?=
 =?iso-8859-1?Q?/Ghbc/fH+i8XzX5KOAveZUpyqjOXWPZQhfOPPAufv5rC0rne5Hpz8lm4lI?=
 =?iso-8859-1?Q?NOA1hhObLKeexR8R43Su6QuLKgyhJ8uBPXrwBwoR3n80U7MlcMiWQbvxnn?=
 =?iso-8859-1?Q?zJ4N+tW48OOKWn/gVVDbkklHu8uSMVhS7TGHUHSLW9fP5f0Fgw+CO49oCh?=
 =?iso-8859-1?Q?n1UAtLKlyyefVmPtg3lfyJFTLVLS4HTPwY6qaWjbJXu6BbnKGktcu6G12I?=
 =?iso-8859-1?Q?IUzSV5TlUKEApJ60iKwpaRww2IZ/xh+o3qaizdHdE8rn6HQwQ33dv+aH32?=
 =?iso-8859-1?Q?uTCQAnW+OekmuvWrE5xOhyDeMIEUNtavF89uC8MSaRmFhaT29lpKGQIr33?=
 =?iso-8859-1?Q?hTnAv+uG7A7UeWK/Wv4sLkZ9SblG5Te7Z4WsG+aEqYogQpdr28r1DEnhqi?=
 =?iso-8859-1?Q?SOYyt8IfNVH+mGasWPIaPbcn+minG+fqKYzBMzKh/hPBsMG4H+/oKQPq8s?=
 =?iso-8859-1?Q?Sb2RsB/TkRToUYo9khN5YfJ/OuW6iuxRzr6UOU8saR9ZLbTyFbZxzwLVpy?=
 =?iso-8859-1?Q?0hmwEGjZorJmCiajqGF7U/2KEyTWsKip0hEeeaxH6g7hEUAQZRTqZkF0xN?=
 =?iso-8859-1?Q?XMek4oxtpNY664Pb9gvFCdMW/Ky7o2kKM2bhhzCneBiJl3FJ2j76HVNT1i?=
 =?iso-8859-1?Q?3gMxPM8fm0CRpgoaiVzU3J4/U1JkbGY/UFesxgC5/p/vi8u8PJHASTUm5C?=
 =?iso-8859-1?Q?8Van5/G505aDc+MYqnsxIp6dN7iI98+0j8YNEMF37eWsy4X54QKBjgS7sF?=
 =?iso-8859-1?Q?Z1W7RyvUilx0nZPiKxRYst5yU4r3bWs8vXfJDxO3xfdZ8zwGiEArhNJF2U?=
 =?iso-8859-1?Q?6FpUh3tmxq0eB3LKOByG0sUVlr/Xflnf+XAVqUjGcrnm8XdVa6omzW3uYf?=
 =?iso-8859-1?Q?C+kVQRYZvwfUnV/f7ICTEO6s+se9KQHigCKZdW8IoOtTkN9Za0ev0ZAeKN?=
 =?iso-8859-1?Q?IyzYEHlovqiUdVaRueblCuXmXTsUI9/DJyL1BEaFhwLZxqKSAWRSKDS++W?=
 =?iso-8859-1?Q?F/+LggZArms9gibCJU0IawlNd+zSMuAzxozXpsJAWry74OQRlCEO84mgmu?=
 =?iso-8859-1?Q?62OMcISull7CPVSqf5uGHUZV+BmwUmTsehSQCm1sx7BOXwewj94WYSzYZh?=
 =?iso-8859-1?Q?GB1Oixe6B7U7XqGRrTyppujDkMXcKjbwN0EaSchWBgfraUkXt0EiNfcC0i?=
 =?iso-8859-1?Q?mnMuWqSB2WskHriFpmzWU52v2BYYdzL76eLHkNlJDGY81TpDru3kOF9U16?=
 =?iso-8859-1?Q?5cwUZvDZHIYzk3i5msi5uT2JkJz+2Y9KcNY1CjRNHn2J2odTFpa7lK/FWE?=
 =?iso-8859-1?Q?1hEeZ7skB04AjioiXbo9KC+ESLZoxFlyBlDzgR2QtIp8XKPbWaveMShgWb?=
 =?iso-8859-1?Q?zHZD6NOMXVry7tgaIYCs9Cl+Fy2xSW99i6KHMSmQ/zrdOB1tKwlNhm+Ua4?=
 =?iso-8859-1?Q?plvva3SeODWB0b8q3KucMNgvWHCmPYJMNjhSf3guh0+qCd/R7URWJyqOlH?=
 =?iso-8859-1?Q?UdXfyQ9RJET5UJD3uQpZX3SXyUDLvOzEV8bVK+gQLYKfloPUn66APrpA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ho4b+/LlSxFky+CkocJ9+tX6QYbesJVn3mlCoVp3SHs/R58LG4eXYf1DxY+Xkt5G+1Q/0VJ2TYX3aH140N4V+XpS0GgNl0+X+nUpTz/kpJ2z5NislohMpJvJZXI18eRlYt8Pp++sT+H5KuREcHZGIqdsbyG1DqLlcqqHJ83iaKjclYFf+ubYLvmhrChNOrArtM5vU5W53laIABAxZYnwbqlNZEFJU8a477WxItVd5JkufAb4QZ1qJVF8vzsMdI0QkjulJEqE5Eu13Bi/3nePkugjjvjrG2eQt4i3HjJOwl8k+HTmcsVgJKpw9+v7RER5GDWiIMY68WBeN8IQrm10wsCAFtw3CUnQIiqughrjc/PYiLY2deyY+bDu5rFWew/F6D2JThSO6fSWUzjoKN8Ry9xeDzaKpm9Lq7obRYtizrBIFVR1j2WN2GHEl3xem9vw2ub1et8A/FQZ21obcZCZKIcRv4hB5A0ZOBzcw8nnK9jGNAZ4NVYz0swGfEpII40rPiRsg4nAycmspkVR57Q9b1z/+ZO0HGMwumgdtnMNZvYPrtgqD76glbrJIpiqyIUaF0dk1SzjVGhTDu9NJNeFnQ4XKq3uGQ6Pfp2m1vtKshk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e54eb3-3cea-489b-8bbe-08ddd4d6553c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 10:45:17.6251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oS3HK4h5cBltGUcx6KKlU9aqH9mnl4haTQjQ60l6ScNYQRfsGkcRV6bYy+Jcwy2RapFR5PWUdoalpHVeV+ve8kadMxic2JVU1hoiCbcX7x8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6318
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_02,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060067
X-Proofpoint-ORIG-GUID: 9L7i9vGROAkb7JknKGhE4tG4qS3utxj1
X-Proofpoint-GUID: 9L7i9vGROAkb7JknKGhE4tG4qS3utxj1
X-Authority-Analysis: v=2.4 cv=QORoRhLL c=1 sm=1 tr=0 ts=68933241 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=PmB9KTzeyHu-84eJYosA:9
 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA2NyBTYWx0ZWRfX004UBgtRpj9I
 NoqsBuyZ8Pq4XYAeQcNEbn6pYI+TSRNZeG12BWfBkjVbMD+YGNYDmJTGwXoGFnUAK5SNEs2kn9U
 f5ndIo+kR2dLP+DEUu5vJWoYlM7u7etGbjLQXILqlNXhfW3ot/OFNS2v1FaxwcMzBhEzAfqHff+
 Ay41hbdUkqZwxPyKRkgVs8WUx8iD/RTiaTEXF5lUl+4d7Zf9Jokpc3IFYlWgButZRDhm6gvRJ2S
 e3BgqNDXSMWs9rE128f1yjbUY9NG6GqsNjVQcs4b+cOa9TilYJi83+R0hP8b7vZXQY/j5mCUGWx
 xVSrjhhl73N0aHO39XL+fwy69YNQQYcNCgtimuI9eK5kGjvhqkOQSLEqRcjqZoqW4nYJu5Jgo0k
 aFBKdQLIt8aT1tYMNXqigcS4W830O45Nti8DpaANIPDUsIU+dTTT0kjA0GNgGLAqrBV7zt/q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 383A1180010
X-Stat-Signature: 55jg6tmoq773weckujmu769iiq6k7eah
X-HE-Tag: 1754477143-403576
X-HE-Meta: U2FsdGVkX1+3uI2API2O1Gx/1XlTw7bfVZVwneVK9ZEcb1AScf0vItkkuYId4nom4vNIuFVVoRZUqqkGchZmWwuTP58OTQZvzgmtuDob55SKo9w0cigeV6E50XuswHbJ12+VYCXMVuL4I2l9aEcyIfdWSZQ340FrkEe8BM1nPS0yHYerwvKb5fmBku2DMmh2+X9G9HjDkgzVvIDL7O03e6sqbOyfuJ4U3ThrWbndTuyraqrEUlXLHxglTEDdrqLP2O29OL2Qu97Uwx9MSwYnet8TYgGpNlMxVWsStcqzoh4vS/GWNRKgA9kS0EScWf3Ls4ksERuWMKhvjoIL0n4OQCvJtKg1KkoDloZwBK91PXidyGQuFlsBHr/yE0lQr1uS/doYenIoDbkiZKnJA2n/tlHVcKr+/Tj8GaG8RslR3brbyhD8+O+KVwrIA0yUUof2RHV/GnkX43tc+FjJFrEprNQGNFkeTIwCNs+sgMKkRh0T/L0MxMV2fXwfPEx3dpegZ4EoBO6r841GfO9qJXHIjAM8fpEzYQOoYZlyGP2FSokDB6BxEKQGXFfHsmzQ/vUkPxR5+QoQIlaGXW9koblyIooNkzOm6hCM5eXNWQfyD8WOgqrlqpU4cR9GDnVovab/8ZxfqkN+4auOjMd3zwkUgqLDy9lnw3iis8Ij4TOL0v/KbJAYwLbAmJyU3y70+D+nAKwmt5Bet2vynyCLfWn/81EZb6yGA2eZK1EEyjgDiL/6mV/CxsyWK5r8LcHu9dyypM9x6panyk7cQMCsHppwEEJ/Wevi5ftkrDog/nnAbB/dnNZjj0sgeIE12Cdexz59zyi8/C1vc0AnuaOP5YA8RHxXc9EyxrUZfOvVZEa2CrqGRhJmlDUsJS2jpUR2NhJC16+qpL8zf3IgrD7wmOG1VOKDYkyKp0eqBnBra1eNUnXt/pl3HyXS14Ndw4fiCwvH5rfQ5goYnQIBtSofftc
 LjOkzAvP
 dNESiv3hoNBub9RwVwYvtwd5h0WtQ1nvRKxFtmOs8NZkRqmgeAg/MavOGnEYBdm6wANnt2fwJjvE4gXzOJ17ST43bz7Pmbfzs/boqC5Ufdyh8PYBK5gH/7X9mLqTNFh1hj5kwJ6PPmWe0a1vD4EIBRML9mrg1zcrnYKx4mQdGB0qk7ywBtH+adEq0XPxNTe64B4Kc5Hm8EsTWh8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 12:11:33PM +0200, David Hildenbrand wrote:
> On 06.08.25 11:50, Lorenzo Stoakes wrote:
> > On Wed, Aug 06, 2025 at 03:07:49PM +0530, Dev Jain wrote:
> > > > >
> > > > > You mean in _this_ PTE of the batch right? As we're invoking these
> > > > > on each part
> > > > > of the PTE table.
> > > > >
> > > > > I mean I guess we can simply do:
> > > > >
> > > > >      struct page *first_page = pte_page(ptent);
> > > > >
> > > > > Right?
> > > >
> > > > Yes, but we should forward the result from vm_normal_page(), which does
> > > > exactly that for you, and increment the page accordingly as required,
> > > > just like with the pte we are processing.
> > >
> > > Makes sense, so I guess I will have to change the signature of
> > > prot_numa_skip()
> > >
> > > to pass a double ptr to a page instead of folio and derive the folio in the
> > > caller,
> > >
> > > and pass down both the folio and the page to
> > > set_write_prot_commit_flush_ptes.
> >
> > I already don't love how we psas the folio back from there for very dubious
> > benefit. I really hate the idea of having a struct **page parameter...
> >
> > I wonder if we should just have a quick fixup for hotfix, and refine this more
> > later?
>
> This is not an issue in any released kernel, so we can do this properly.
>
> We should just remove that nested vm_normal_folio().
>
> Untested, but should give an idea what we can do.
>
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 78bded7acf795..4e0a22f7db495 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -120,7 +120,7 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  			   pte_t oldpte, pte_t *pte, int target_node,
> -			   struct folio **foliop)
> +			   struct folio *folio)
>  {
>  	struct folio *folio = NULL;
>  	bool ret = true;
> @@ -131,7 +131,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	if (pte_protnone(oldpte))
>  		goto skip;
> -	folio = vm_normal_folio(vma, addr, oldpte);
>  	if (!folio)
>  		goto skip;
> @@ -172,8 +171,6 @@ static bool prot_numa_skip(struct vm_area_struct *vma, unsigned long addr,
>  	if (folio_use_access_time(folio))
>  		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
> -skip:
> -	*foliop = folio;
>  	return ret;
>  }
> @@ -231,10 +228,9 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>   * retrieve sub-batches.
>   */
>  static void commit_anon_folio_batch(struct vm_area_struct *vma,
> -		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> -	struct page *first_page = folio_page(folio, 0);
>  	bool expected_anon_exclusive;
>  	int sub_batch_idx = 0;
>  	int len;
> @@ -243,7 +239,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
>  		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
>  					first_page, expected_anon_exclusive);
> -		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
> +		prot_commit_flush_ptes(vma, addr, ptep, page, oldpte, ptent, len,
>  				       sub_batch_idx, expected_anon_exclusive, tlb);
>  		sub_batch_idx += len;
>  		nr_ptes -= len;
> @@ -251,7 +247,7 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
>  }
>  static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
> -		struct folio *folio, unsigned long addr, pte_t *ptep,
> +		struct folio *folio, struct page *page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
>  	bool set_write;
> @@ -270,7 +266,7 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>  				       /* idx = */ 0, set_write, tlb);
>  		return;
>  	}
> -	commit_anon_folio_batch(vma, folio, addr, ptep, oldpte, ptent, nr_ptes, tlb);
> +	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
>  static long change_pte_range(struct mmu_gather *tlb,
> @@ -305,15 +301,20 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			const fpb_t flags = FPB_RESPECT_SOFT_DIRTY | FPB_RESPECT_WRITE;
>  			int max_nr_ptes = (end - addr) >> PAGE_SHIFT;
>  			struct folio *folio = NULL;
> +			struct page *page;
>  			pte_t ptent;
> +			page = vm_normal_folio(vma, addr, oldpte);

Surely vm_normal_page()? :P

> +			if (page)
> +				folio = page_folio(page);
> +
>  			/*
>  			 * Avoid trapping faults against the zero or KSM
>  			 * pages. See similar comment in change_huge_pmd.
>  			 */
>  			if (prot_numa) {
>  				int ret = prot_numa_skip(vma, addr, oldpte, pte,
> -							 target_node, &folio);
> +							 target_node, folio);
>  				if (ret) {
>  					/* determine batch to skip */
> @@ -323,9 +324,6 @@ static long change_pte_range(struct mmu_gather *tlb,
>  				}
>  			}
> -			if (!folio)
> -				folio = vm_normal_folio(vma, addr, oldpte);
> -

Yes :) thanks :>)

>  			nr_ptes = mprotect_folio_pte_batch(folio, pte, oldpte, max_nr_ptes, flags);
>  			oldpte = modify_prot_start_ptes(vma, addr, pte, nr_ptes);
> @@ -351,7 +349,7 @@ static long change_pte_range(struct mmu_gather *tlb,
>  			 */
>  			if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) &&
>  			     !pte_write(ptent))
> -				set_write_prot_commit_flush_ptes(vma, folio,
> +				set_write_prot_commit_flush_ptes(vma, folio, page,
>  				addr, pte, oldpte, ptent, nr_ptes, tlb);
>  			else
>  				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
> --
> 2.50.1
>
>
> --
> Cheers,
>
> David / dhildenb
>

