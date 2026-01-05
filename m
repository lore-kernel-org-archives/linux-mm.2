Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB74C79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795E36B017F; Mon,  5 Jan 2026 11:07:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7403B6B0180; Mon,  5 Jan 2026 11:07:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6049A6B0181; Mon,  5 Jan 2026 11:07:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 472F06B017F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:07:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E08C61401C5
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:07:12 +0000 (UTC)
X-FDA: 84298389504.23.3589E8F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 49AE14001C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:07:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D6A0iCT1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qICh9dV9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767629229; a=rsa-sha256;
	cv=pass;
	b=Q+KMYC209OGAyi4hpwPXT602yZ7hyQv2wHrdufH5Kh9Df8BQ2Zdga6rculuCymWmefqqTe
	sCqeYp02NiUrUpVKg52aECte+aYfQ4oVeZptMJsDdc5Zess1/FUxmy09IH31o9iwX24ddb
	dSDiiHHvaZ+ICZmJnYXYyIScp5YNH5Y=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=D6A0iCT1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qICh9dV9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NXc55WBBsEM2wEW2zoXxsaZrV4R0oRrhn8WzzkjoeY=;
	b=tcdGnaCemn4s8qHWLBclVrd9Zk7s17HrFoni28g9SKg7Sb9XJP4iBF9VoEt7hk4Ec198ta
	JyMT5yXSWZWQSuun8X9EGhnE/omVNAlc27u1b27y7icNiH7LWViNR/esUs3gTSN17g12hb
	fCP/N264xHUTiBemfLJ0uMaoNoPg6Mo=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605FpZYC1515388;
	Mon, 5 Jan 2026 16:07:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+NXc55WBBsEM2wEW2z
	oXxsaZrV4R0oRrhn8WzzkjoeY=; b=D6A0iCT1xi7G/Z402HzCNTA+P6CyI810G6
	VSZ5kyyyGYe3G4NWDR402OpVdXkxZDcSl4KwH9lCUDe52i9xNAzdbhwV86zQKK0k
	+X6xux76WTR7TukcDahZcoz8iG4zvGXxkkVHOyEYDHAUHWUF9mLI3kFZkf4asgRy
	jEkLQcY4v9qv4N1ygtbA+hwGT704IzLl4ieiR56i/Sf0PuALvLDithT20YgZhP3G
	Ahv+KrPQPE+b3uLhZLGNWOQxy8i+Tv/0qmZQ83AcTvZgpXsIEaPEL1wqJlK7eucO
	u22XRkn+3QuZIEGssTUonhULAcTr5XbWWBvrgEVVxUTnMjBjD1Hg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bggagg0uw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 16:07:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605EeVuD027538;
	Mon, 5 Jan 2026 16:07:03 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012049.outbound.protection.outlook.com [52.101.53.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj79g4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 16:07:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f4sV1CX9ypyndrESDFBP3G7tmR8XFBLhqMbE20cuq5W8f0xjn8dFNTXHf6pPDwnz7ewJ6LI3U75Iw8Ojal43yc41+h2CQr+BJtWzxQ//oRGXf7apH0kgUVnFwZav2iSPmNpdDChV/wIoyg9ceAhwNuCF4LE4Xfko2td6N+bubmpzJ31bW9lU+t7vviVgiNsULA1Zeuh7KMiwO1j5qwXjkVlnbRXuGVDq6kQyMwCI2qjoVMug3mI7I4jE/lqLDSX0aotLCeYCThKNV30aKgdTty9x5nLhIRUIna3RUaw34UlOl+A6Ig8X5DVVimTK/Ht8jtYCAmccN/oyiCiVFGhE/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NXc55WBBsEM2wEW2zoXxsaZrV4R0oRrhn8WzzkjoeY=;
 b=IwtmjtQUuFoUQzDQpVCtlKN9uhGrRkiO3WzfOxw40iU0cPvhd3RrRfHYN83isI7QD1cKBGKaQWrJ6zx+vDo6bJDh/9k96jX5L+WDca/i5XIkvVhg1V3zIGtmcvuC9K0mrOeQR43Oa/aosFXQ6jxMN1OMwi+mNL2kbQglcoA1N7/9Zscwp+jeNoz/dVi+qxUK/8tCx6Ivez6JXWeur5K3NB+8BmgVOG+cEVl0K97cs39vFZ6WXChaDH13tKAu/4Hqq6uov+/MBBfxbQQ6g7YhNndGNvYIWCy8OuKUxu9bCsGN1Cj1DGBtqkQ1jlau04m8cfs/DAnldCCIjOzMMoiVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NXc55WBBsEM2wEW2zoXxsaZrV4R0oRrhn8WzzkjoeY=;
 b=qICh9dV9W8ngi03B20WCqTZCsnGmQuDEn1C3tkZL+WHPOVDbTw+xs2tQYnlSWcEbYsM7jvIIuTc7NyQztcbsHHybqypKnFhhuJ+MfikD/ewbahoEWY33WCBTBCVh3zeuPx0LQCPCIcvZdHpEz9iYj9gCbYgeqgDhXWu7l13SErY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4427.namprd10.prod.outlook.com (2603:10b6:806:114::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 16:06:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 16:06:58 +0000
Date: Mon, 5 Jan 2026 16:07:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        amd-gfx@lists.freedesktop.org, linux-mm@kvack.org,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
Message-ID: <6ca21d7e-4654-4f8e-819b-36b5153608db@lucifer.local>
References: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
 <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
 <7014fb92-0d46-4c64-b3ae-0eb9d6b81878@kernel.org>
 <a09462c7-af2d-4282-89e3-2cc43777338f@lucifer.local>
 <b7425b3d-f614-4099-9f15-51c6c2cea68c@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7425b3d-f614-4099-9f15-51c6c2cea68c@kernel.org>
X-ClientProxiedBy: LO2P265CA0512.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4427:EE_
X-MS-Office365-Filtering-Correlation-Id: 10bd5416-801c-4fde-6697-08de4c7473f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1NEyrp/dEa3tABN6s2Eh1GGmmV80lU13Db8PUr6AMsur15KGwP050Xrwxbpb?=
 =?us-ascii?Q?LnaSw8hiywytSIZIa6Xe4e0qVSTRdwhcejeCy4+K2ei213CHVPUcb+3i4s+A?=
 =?us-ascii?Q?5TDAS61N2OUA2cGs7b1pnUGnVSfIAEge9C9YwgwtQ3e5keIWDQ2GWWBopX3d?=
 =?us-ascii?Q?QvKSbFip8y2wuLgkqsvXPLLvcI0mq0GBAV/9hLeSnt5KilSDczoFCzpd2u6d?=
 =?us-ascii?Q?V9WhqwYGanqi8W6dzCR8fcO8zUoQPMBMHoOV8mqzC2IAKyTVCAolfNrNBh5H?=
 =?us-ascii?Q?gSQxEAG8xDkLxBCsFSTJuaTvMjT5Hp6iX5GZvrz8wCIhqtKvKxXYJU7iaocN?=
 =?us-ascii?Q?aog0rILBMT5aDwupwQIawlcwSEKlEa7mVrbV3vkMM9Xyp1Vbxsd6N/DVVktF?=
 =?us-ascii?Q?TePXyQJ8V1OQFxbgto1TAZpdcmLq6UB7G+NqsfP2hSIt8Icxm1xc6x0xYwR4?=
 =?us-ascii?Q?nSLzXbGFyBLWRL2covOWX/PhoH9oPnrL0rzL3GGKhlw4MY1B79Mwgq4bibg8?=
 =?us-ascii?Q?U4u1UfwHysKAJkDRaM8Ewav1xkK8rQgs3pRyZ+l6M/cm27eahSZFut36W2mO?=
 =?us-ascii?Q?v+7jnFHT/F/G6VeqoDnn0X8pDcAthUHMYbm7iwFv6HdUKIglXWt9WPI5/hHv?=
 =?us-ascii?Q?5cPBqrY86+0TMpyviY/0xmVwj2Y3M9jf8821lA7qHCR50EkVZPOS4n6wpMN6?=
 =?us-ascii?Q?vUgebKrQJrkHyNKjshFxVl9I2n1ke+Mi9fHBBd/kVFyv5a+3WGz2ruJRKfrd?=
 =?us-ascii?Q?VtjFwHIcoP8w0l+ktq/tIg75I3cmS0ujfAV0lKyZSMLT02v+z/7XeFDEq+v9?=
 =?us-ascii?Q?KCCVy7py2jYNY1U3Vwnu42owQ0o1oC9IYItSYYbEEKJPlC13DuqO83rFV7I9?=
 =?us-ascii?Q?9RzOd6cRJGCUAK+FYSL9YIJMrFcnbauUQogUHefOo60Mif4YtCi4oJ9LcfKq?=
 =?us-ascii?Q?YnzQy6UDE8zqrPW2ptez5flhgzdI7fLYzzCb5g/X9qYR95baW/r7FmnhK79C?=
 =?us-ascii?Q?/p/uJ8gxaptPD6/j5cxT8qI/2ECDlGYW722CwluWw86kRQPT7OnlZ9r1EHlm?=
 =?us-ascii?Q?JShcvEtSukTj2dTu2ERGbN9QQjbBbTlwSOhdjqOS5YEj9/alpkPA1zuJTCYF?=
 =?us-ascii?Q?uw/V1wCZ2/++1dwXv3vvhu7Ajtin9VRmLTa2L0UVFc65UgGk4L7UmWrEut8N?=
 =?us-ascii?Q?osyT1HMTsN/ceaFo4btJ4Iwa0KHefUlqHQqT0oHOYKGfJEO1yvimYsNA+xUj?=
 =?us-ascii?Q?VJaAMejpz7nx8LFaSYTgTyuxGEdf10xyG8ZdG8/YOAcK1kGAMi7DMkJvRyav?=
 =?us-ascii?Q?xmISyjoRtGtFxey0JUrpVWn+FmiNn85cEJMoCGI2pBI4cnESjAAlR3yXPm9+?=
 =?us-ascii?Q?H5oZ7gZ6bt/dhSD8kVMXXEPla5JzHPir2XiFWZpwHs53oKORD0eft0izaFp1?=
 =?us-ascii?Q?e6Tfryz5ObDys8HaKnM/BsJ9dvosnvH2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ohcfKpatDAsXtCvJ/t0o6WGxmuYflXTGT4UGlZMW4D6UNSATh9AmPIrtsy8h?=
 =?us-ascii?Q?eVCQTStcB3rNMY+5dxWqZaUoBpGtSd+/OfE30WQeXbcVIid208ZURkSXeO+L?=
 =?us-ascii?Q?6eotmoClEB9cltl8hw54za4BklP1RIGbBivIjbrsBziKsoWxGDEjJU+Ov3Mi?=
 =?us-ascii?Q?Z/Pf63fLDqNNJMTjcVKPmGF15RTkbqpb6c4CoTJrgt4B5eRuJkTUnLvJavie?=
 =?us-ascii?Q?vwhlrvSE5FURbxo3Jc7ZHVMKhHS0zq+fkvQY3JMR2Y9WFJPlljOMqKnfgZK8?=
 =?us-ascii?Q?RY3ttpxRFmv+CByChUTng28z5SXKReinId/rbzrUjBSRFiPNaR9XlyQHt890?=
 =?us-ascii?Q?IP5pwolhj0kql80/X1xrs3RafLjm2fk5cUD8KvFo6pMFZtGfvLP7QKTQRvL1?=
 =?us-ascii?Q?psf3h8PjWf1FZV7LQrMB9ujcFoCxtp9CciP4v9yUXblt+gecqU4U0FpQAlwh?=
 =?us-ascii?Q?VqObcitjrLKKoOMKVweqsCih4fcCfXKQgwx4sfQfTp2F30HAu83GIqt4D1zf?=
 =?us-ascii?Q?nym1Dy8nCw1LSanqiezXxPH/XmtwJGtjlqGJHzHjo/5cHxdgv2di9Dvq3l2I?=
 =?us-ascii?Q?jKqQ0AKQ9ifsBFmcfukEr9fiQNdBXjqUQzWEK7XyYKc/EHhOBTvA3xmIkzUH?=
 =?us-ascii?Q?PRnGmXiReDy6AGEjXW8J7QwS7A5mrXXqOwt98Ki3WEvsxz5UWadbuT3XX7fa?=
 =?us-ascii?Q?J1iKndN+abPchoaob317UTRT2Mmq8+phUpB4f7w3b1m8lMsU0MnMqBLmcUJh?=
 =?us-ascii?Q?ErKjHcjMZU04leavzqxqIIZx3jJWi4am5uZGcbdhTRp15wYkyALhxWaoWkhc?=
 =?us-ascii?Q?qccsX2z4EENTxPJAMnoE0L2FjQYrnXaISZy6VRFcFsLdTxmlNCTcxyzyxgaS?=
 =?us-ascii?Q?jHw7BWGToO9n53AsOmQkP5qdO9rDgtO8eH7dgd8Njp+W6TxWSdObRBHxdwNA?=
 =?us-ascii?Q?yeC9JT0qR5brkmJforknzxYl0dRbgTp/YR1Yf9AyMCdsc8ePYnSxh2Hbq7eL?=
 =?us-ascii?Q?eX7kbzhYWWAZKAu/GDjFQA8DQrVdLBP05CFu958npDLVUsek5SOeukH3Bum1?=
 =?us-ascii?Q?FKvxmb6W1+4r1CWmt0772VTK3Kp+KrQBtapCz7nSz9WwFZfjWYj8TMjinA2a?=
 =?us-ascii?Q?lxl5NPfHn/0Fd9AeKSzHYqdenV3lcyGuB5uriSt4O5OUWge/r8VNU4G0/b6r?=
 =?us-ascii?Q?u2m1dLC4J2Tq8UQyZKT6tuHMnhRn4JXxbayvZJF/YxfPSJ3oN3HHV8+8mMq7?=
 =?us-ascii?Q?aFEQwZBjstRxMq0bcFnrJZiVLGH4DRazTHgEUNuH6bvy2sWbQutRBgT4jUUz?=
 =?us-ascii?Q?kTLWF+/FMF+pRT9sU5ZEMOUANW5y56nuk+Y3jLn5ZsD1VIA5/uQLqkclMEyQ?=
 =?us-ascii?Q?tiUq/bJf3a10rWPxX+N29PgsYuP/C1krnqbhJIk21QUH+VUy0XjKEwOQEY9H?=
 =?us-ascii?Q?UhBZhek/yc/i1gbhhEPRBmnRGOcHgfbKcGmpFvScdKD32Oxx291jzarCcus4?=
 =?us-ascii?Q?8UANdjRxdSRodiIXSXKlc+EDQKXtUMFRFXSbWh90IFaeeHa2ewMY5f33unWO?=
 =?us-ascii?Q?79NVeKNhsoqWg3k62GXCqKV+a2qhe1n/AYXEg/0TreeLq1rF/3ANAwlhyE70?=
 =?us-ascii?Q?GSAsHP4p8fHDHlpQ1xCyF5p9oJUdmgoHUQfKU6nwDecV44QfBO8E15bn6ZS5?=
 =?us-ascii?Q?dooxLVqvp5XZScPXM50fcn5ZKcLYsG5BatWCh73o9g+MBvPnfHewJLEbV/Bq?=
 =?us-ascii?Q?Lvz4SFWfBbk4gJ916etTi84KWdGFp60=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FiJMg9Lw6AkbooOK8iz9RdrJBiqRa3PV4E7LoQ3TcJLPhUFGFB5QP6+dTBi2wSK5xa6WsrF7vVELCB5GJipJkIoNuWqbSi4GovHvAYfjJuHAOxYl/5i9VPuhMVqjJLkkmv72dgc2O2QUyV8JABQKs3Mto0kW8ftRc9v07z7yhsiLoWLeJMKo2XOOrZCGEmccNCJKkGXZDEW9UJnKPMIdV2xxVDgWVGimlayZUN3XNvt/O/42NP1edBph2CQGtslm041fPgqyockpZI8jfwGmxYDl+dWYXzTr114uBTITcul6BnqybxCTYDLUqfiicMNqzULL2T6AQHrVT4ybnMAHL6NgV9ewkupCjEEaTbKzPiTyoM7IXpyyo5NLNZHDSmbzKsBw8q46KwxaXDU7O9wiabAYG5MdxUxvwsZcihuoCK7bZsYZ5oi8w33zrQGJnCqRypdmbLaOirah7N8jb3UoGe4PnQ1uuWAZzBCYi25aPyHYCliK6n5vkwQd4LVw/daA8ZqwYpMNOOEiToj1c2qd64tjmuHdW6z2zWxdb9MJcDlZ8hCQGNIqg9h/dkkYspFSWDUNe4JFFsCrSCwadFZJ+q+xut8clrTLimnCYyTh5Ww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10bd5416-801c-4fde-6697-08de4c7473f1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 16:06:57.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A9/CovyZYPo6ZIwABhrlgLyd3dVPRM2i2EbxVXd10Uf265EnEzdeIkrndmTKAht7gSXkfjveAmBDlbaBVn9bydnLaYoZ6qlAMRV93ZDGyUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4427
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=603 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050141
X-Proofpoint-GUID: XscfxGRi9JELkGwuk85ORwQLi-LaYswN
X-Proofpoint-ORIG-GUID: XscfxGRi9JELkGwuk85ORwQLi-LaYswN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE0MSBTYWx0ZWRfX2SqJFGvKke+L
 7SxTl5kIL+1dzI5W4Urg/TW42wkW3RsNozvM5LXQ6f7Dmf8pYx7eY0KVIMq7jY8PZP6Mx+VqGJl
 Oi1fiEg1O1+bvbQKB9dXUJGueHX0RuvwL1DriXz11bQ0MyHtAOGOM7y6uOMaYTQlAToleDOFrTt
 vCC44VWxPJ66ga3mrDP94WY5HqAq19cOjshhWc2vSQF+kFw5XKlLHuwAyu+TMPEMk+lpgdvI3Ak
 t8kT1f94noEUjA04pfxFmpIBmNsklE5eY8xQat/Acs6h/iCSnTlKqm9hr9h8YDkAx0YWc3PZxMk
 PK06lJshPj+mX6gHbPZSZJud8YILnPRvhcDYaTdh0EY6w4rmnRbhRhMSsbn24hlWXfGlAg5oojy
 ci6Hg3G/nXiXo/LbsRGkFwvQX8M7RpM1/XERy/rGBknYSbJWQ1YzQIyCqfQINWR/moY/lLZ23Kw
 67DAReqh9NpTyX3QFCA==
X-Authority-Analysis: v=2.4 cv=ZcIQ98VA c=1 sm=1 tr=0 ts=695be1a7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=ovwPS-R_xNyBXl15NLkA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: 49AE14001C
X-Rspamd-Server: rspam03
X-Stat-Signature: fyqk3kifhhwth86j4up4a5ep4awqww7h
X-Rspam-User: 
X-HE-Tag: 1767629229-451935
X-HE-Meta: U2FsdGVkX18+V6VZDgVjPW6aiFaZlVpLjFmSUUvoEnKg9RU7cPp0Z3eYr/VO05bTaqJTmksNGTetytff/lNIwGLDTo42cAxNRHYUJgAmL/IjO6X1Tw70VUZLsAoUuWJgiq+M93Aywtl2qd97md44wLqhZdwIBUVgmSyvTaryenpzRK916nhkyw5cc348Q0wng7teKpMXNapX7paITUk9MabUtQIHIb+SD3o6zfMkuanpGWHekl4KQencI4CoawL/8VzeqmhFR8tXu0OMUwE3KSLjwlQWk4s+8c/yzi5VYSyC+sYku8yTGEsZPKU0x9nW6XB2j4VmAwpOQhCA5fudPfLgjswDy9vp2OAr+BD+psSQR90wM0ZTiglqBmALwhoBx0pJLFjy3PhF97SWlEyPELbtqpI67RRmk+TVHgSGdB7Z81qHht5CUFM0vBjh9SRDutat72jjOBPd9YZNRXWBX+9sScFhO3ApiwddkTqmSC5B9OxdqmRLMYnJuAzCR1/Vkx8WKtQKm2d5m5NJrLyLu+QM5nXMdrKXV9lxePJCs0qkCnomJ3F+WK5J1TPu3CmMtFHhAZ85tTtLomhDsLIunDFOgBnFCRhihnHibfTcPiB3edhfUY/ECfbwmv9QhjRLs0Q4e87IGkWOA/cT2jN6XHWuhyQg9dLqCQN1CIB4lSQOo/3NxKHffzWA2ZOJUpfT6REnUT4QlY7sz6tFXO7pMJKVfb0HV06ydq10o2jUPrBP2P4iq8QgJym07cOBfsbu9QOJrT4g8nl1LQGgt3qJ8UQh7xN9rUM7ZdYMFYoJnIkZAzELJSmuOW1vyZkF9RcB6j43X2yGWvl4EdTaNdBGxYYMCHE+kBwCmC7N4d3BNGl30vqWuxG8q47Ans42Nl6lq6rNuUJJT9di2tczOSI8UqYLAazcXSQL1MEHf5ODnv3kfyZ4IZVv/TbGQY5H6lN3To9ZoPJ8UUr5yaIFOEm
 KT+hKTHP
 TKJODvmS02s4HZts9EEDjyVRUH78WMYCyQXPgDOXi+fSmAnvL1JE8qgobQvyrBnK76aL1MycNJz9zNEdmAyAQlxgy9Lq9NZQo5qN1/9eXunhyxZso30WY6SD6WPTxCGont9QwegdrJDjRlg1oikR+Cz0LyaYQ54V38FoNeWtiBd7JZyeQIIKik9gwuQjkfPWgkcgzUTj8oQzcKu+EQS1DBqZUQ0FkDD+KggRyi5pSaRivDtwbbHwpMMPJxUYyije8e39qVFRhHWmcZYesNm2GG5N+8jR0mPZeYLwnEfif2csLZhYR6eDzgagNv9b9KJCaDa5rZs3Cr/7mYIL13dGAHm2rpveindAXJqPQt3gSIODtHye5MpqGKnSkZ2eH0ZsnRvlghbwUpCCMV5Kf95rFvZfGJr+u+vmrSoykccabOvrdRA/4Wv+NYlekCgVtfAppOuEpOW4vXyERD3vKf8D5gF6oHemUqa8ReurCCRQoZJHzpkDa095bWj3xQr5a4vo7L1n+cfrByRwBZbSrRVSLcPAfM2mkdKohTijKNndJu0m29vlZxU+W+spKVTgI97M5pJCnTUH4pIGd+N97ld+ATb28S51wcWKKLvnyuKSak7y8AZcGNKYruv/QR0EP8jQFIsAa/TDhQtgKeIlv9tuBdakh1E68w17W0bk1sXH4QdP6V0cRXOrUr1Yirw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 04:47:30PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/5/26 16:36, Lorenzo Stoakes wrote:
> > On Mon, Jan 05, 2026 at 04:06:38PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 1/5/26 13:18, Lorenzo Stoakes wrote:
> > > > On Sun, Jan 04, 2026 at 10:15:36PM +0100, Mikulas Patocka wrote:
> > > > > Provide a dummy function fatal_signal_pending, because it will be used in
> > > > > the following patch in the function mm_take_all_locks.
> > > > >
> > > > > This commit avoids a test failure when the following patch will be apllied.
> > > > >
> > > > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > > > Cc: stable@vger.kernel.org
> > > >
> > > > No, please don't cc stable. Also don't cc stable without a Fixes tag.
> > > >
> > > > This isn't backportable given you now need to backport to 5.10, 5.15, 6.1, 6.6,
> > > > 6.12, 6.17.
> > > >
> > > > I'm not sure how Andrew deals with a mix of Cc: stable and not-cc-stable patches
> > > > in a series, think he generally doesn't like, but I'm not sure how exactly we
> > > > are supposed to express order here otherwise. Andrew?
> > >
> > > Can't we just have this hunk here as part of patch #2?
> > >
> > > Backporting should be rather simple, just drop the hunk on kernels where it
> > > doesn't apply. Sure, a bit of manual work, but better than making our life
> > > more complicated here.
> > >
> > > But maybe I am missing something.
> >
> > Because the patch was sent with patch sending-101 issues (yet still merged to
> > hotfix queue inexplicably) so I assumed manual fixups might be problematic.
> >
> > But actually because we moved mm_take_all_locks() between files it'll need
> > manual fixups anyway.
>
> Yeah, that's what I thought. Backports might not be that easy either way.

The point was to assert an ordering so in tip this fix is done ahead of the
change to prevent bad bisects etc., then to leave the backported bit as simple
as possible, since it's a total pain.

>
> Sending+testing stable backports is not particularly fun (I have some in my
> inbox ...), but sometimes it only requires one backported version that can
> just be used for all older kernels.

Yup it's ideal if it can be automatic but in this case it just won't be.

This is also why I suggested separating out the driver fix, though I think that
patch is probably not even necessary as I reviewed.

>
> --
> Cheers
>
> David
>

Thanks, Lorenzo

