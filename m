Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6759C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 14:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512AF6B00B3; Sun, 10 Aug 2025 10:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA7E6B00B4; Sun, 10 Aug 2025 10:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9E66B00B5; Sun, 10 Aug 2025 10:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 271F66B00B3
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 10:24:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C12EC160528
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:24:27 +0000 (UTC)
X-FDA: 83761068174.06.3F10A1B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39CDA40005
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 14:24:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="sEIR/n4y";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zYEOZd9p;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754835864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6e8EQYbjQ6kdOjUbt1SHx8VSHf5614RhOJF0FLCtVBo=;
	b=0tcCPpi8LUuFQe5GeBKvZmOGdRCCU+1wffW+og4tJ8l9XwwcQ0S897qQXOFuokgfapsqU/
	FGr7BgljaUOekWSDQ/a0ZxkdQk6o/JnzuwWxc5H/ON4VNEkkjRiQNQD/9yzU5xxN8Cxk1u
	qM9xkMQ4ZggE5l3dMT/mvatRCtPNvHo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754835864; a=rsa-sha256;
	cv=pass;
	b=IhKoLS2mSUVa61LZdoP5fGULC1z49Hubzm+QAk1JgBvHPiUqyppjYhpY9HECocXNPIkrU0
	GXiFPajC8bXm+L0yezxULmxvyz7zFhXgr5OYU8AXpTJJPf3Pzh+fzhha7fHoFnx4anwjXB
	WVNmnPx/WyhBDLuDdae5Bq4xNQQXkMI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="sEIR/n4y";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zYEOZd9p;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57AEFRWs021661;
	Sun, 10 Aug 2025 14:24:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6e8EQYbjQ6kdOjUbt1
	SHx8VSHf5614RhOJF0FLCtVBo=; b=sEIR/n4yFU61tVdqHsIDlU47PCyU5h+wNb
	zUAz0/pMaiNIDZKjABBTrL2MJJgNZh8K1Dv2tHgB0Q5HsMF72tOoUkKgKBFdrsKS
	0u7bVJjOZRTjRg/K6wY73QkEaI1Dnk8UGGBNFpcAJB3Mye06iR2bDEeEBWvos07l
	Z1kvsrA7bCvN4LCuHnFuZbfsI3AWceY6HmwPsbwKLQ4CaljdgXaYhWWusWyNOCCY
	U3ueZVkC7EH2AFs3nOW3sshJ/djW6TrPIZyRrZhKFNSyWa/jk9GU8Rt8fFt2vN5b
	sakF6z+1cu7gOCdJV5HWyN5Cke20bFLRUvei+r5tu99oH3aHUH9g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfs8j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 14:24:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57ABY0nS038546;
	Sun, 10 Aug 2025 14:24:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvse9dnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 14:24:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clJZ5w6i9pCpcdPKaYjySa325ieYPDePKVfM4yrb1yjBGC4V3/C0B/wFGjK4zjte8oqKfLkTat3OY+qRW6LOBTiZFDqMavhqi2zmlHWsI80BTijhYO1lkY5JTv1TvuwnBlcOdekCC88wcS3RdI9nbaKIX9DKkJuSIG/KTvBG8/S7OQHtuTK565vXZes88JWt//Fb9zkwJVbrB6rYDxcnSYJ7oGHlKpFgKRN7bgw9/HrzR9/dvpNIDCxJD4ozPVsmlYJqPZfWDZjgB0qjS9Um1lgDpD+acUQlJb/kcPsOjJdPcspR5+4lu8m1lt17CKaynnWSvQfN2a+aQcQPJsTCxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e8EQYbjQ6kdOjUbt1SHx8VSHf5614RhOJF0FLCtVBo=;
 b=Yq2mV5jTZOcl9+8mj/fwzjnKtdfk3ZXZXm0fdmHLIxpsCzumowKqMtRMXuuDYRF71lCzZwBDz9ATU6iEZqcYDpj4TTnU3YwO5A92fdgm1IWw21qkH9Z+k5YCAl05azV/qhVsywZoQKNMyJ+8EKkD/Rsm9c5vpNnni0UBa2GtVH9FTZW0nikrR307m3VutBi9MwQ1ivtdKU6lwUdt82BDTRjOKaOXu9ft6BXYQW8KzWJdUjyvw23qvGBgxrGgfIm+6dBjI1p+ns2DGcLBBZvjvAu1mPCEKTA9M39Mift1me7EB7sm7DWLh3gt3HzDwiaVwgCsuwN4fFh+JOXk71fpvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e8EQYbjQ6kdOjUbt1SHx8VSHf5614RhOJF0FLCtVBo=;
 b=zYEOZd9pT6v68+TVOnYbSoSjPIEdqZUulR2yAe8hKnkcYuSzrgE5uRYWBsYf481PsYtsUK/G/kzVIOWG4g8LMJS1MLbFgWUOBX7ldtXYxVV5QXfFY+2WyLfyGbaINW2Kaj03/GtCwJW07ovyxrGHolOslzYS23dHg8870d+3SYM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6797.namprd10.prod.outlook.com (2603:10b6:8:13d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Sun, 10 Aug
 2025 14:24:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Sun, 10 Aug 2025
 14:24:02 +0000
Date: Sun, 10 Aug 2025 15:23:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH 2/2] testing/radix-tree/maple: Hack around kfree_rcu not
 existing
Message-ID: <461f1350-7fdc-4136-a1cf-7f1f0d01d9ed@lucifer.local>
References: <20250718172138.103116-1-pfalcato@suse.de>
 <20250718172138.103116-2-pfalcato@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718172138.103116-2-pfalcato@suse.de>
X-ClientProxiedBy: LO4P265CA0134.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: f27977f9-e38f-49c9-5473-08ddd8198d7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uU1dfeAzksjTC4JbhWQNOSVzU5MiyWoPTct5dy/v8hso8210jCdXq9REioQX?=
 =?us-ascii?Q?vyKGwDbDeUIK6Thq+mHVCZmPrLU1PD5YLMNU12WxggXFeZxcBm+HvBJK1aTk?=
 =?us-ascii?Q?OuxLAy9F+wDWIpI3x4+iNm9LuCwPmqdcpde12mQOAWgcsXorvvReyB5g0fXg?=
 =?us-ascii?Q?GnQAqNIfisWc1xZXLBRuGZ+WG3GvozQuNAozaqkmYVJr6CEp9CJrRFC3VIlh?=
 =?us-ascii?Q?kEfwIrgW0kQ3ag1z92nqyLTG0jgpl2fOeZ4m0RHNNvg2HaRfBnyM5VG0LnwY?=
 =?us-ascii?Q?YJgtB2/FaHNjBKfrfcUQ8WoBRfdpQp3tTij9WPRmKxd5rdDSzpaSphHwIvWx?=
 =?us-ascii?Q?EAaLaygPKCNhw0ApXG64wZu+kuVXaLzjsLd1SuW+pmnp0IazBG3DFDHcdzSM?=
 =?us-ascii?Q?wWTGLS3U+fYSvyvIuAXvvzsadgC2hWdurZpG5+C3Aii8KAdFVPRNc8Kvd4uU?=
 =?us-ascii?Q?BejiBbwZ/hMW9g+IZybpnn61IDNYyi2RJyVv9YVcgR9n31qN6/8TxhtxTojd?=
 =?us-ascii?Q?QcbFrJ+wHww3ldZIeTQIwMnCvxFNovCNmN0sAk0ctRmJJU6I4NMdhkpUIQ3S?=
 =?us-ascii?Q?VcowWIABLbXvpj0BQNMONoTOPJZZ70Fxp3+mWycfVFE903RrwBfnykxK1JNT?=
 =?us-ascii?Q?BvdM+8FDjKGZzEUgGBIODjveZFkOPw3Ym2ivkPuROnMcspuiZtPM2obNXSxG?=
 =?us-ascii?Q?Z+KHxGD+i6YwaNs5YmIHwYX0GAdX2XRblpcl9oxBm2rvZ5aBGSdFksTBK2S3?=
 =?us-ascii?Q?wbhW/RNY/JctgiR9XfDqx5xsEStAeFLnDgq+JjTas3aqAQMy/2fMEWZWI9XN?=
 =?us-ascii?Q?O/ni50nsbWGYHThs7mGWP2GCVqVxqlSrb4CLpS7Ghslk/YYYFXtqmIExqOlS?=
 =?us-ascii?Q?JuhvoO52bo6yGnaZ4YETG1jk7SmqGNjbOvVz+FLrTzmbZ7JhP3sf1oHUYusI?=
 =?us-ascii?Q?P1uAFDdzgFBjrZlgvR3o4CWVmuANKrI4Ab0waABviFAtUioXK5Gm4BCBukzr?=
 =?us-ascii?Q?5LXZ79sIJBUmGofhQn9axlEZaWtOC36TOUuw8Y/3HPzUVv/lKwmYozpKcIr8?=
 =?us-ascii?Q?Mh8LB6cPma4US92i4gP12qUK2N43sRDFbfEOcH5jl504xm5ZbXZX3/jnFZor?=
 =?us-ascii?Q?zfHV4TfAOjyPprI4tKsHPwF87UIwWzrXAxa+1UGkqnrrmI8UHd/CVo56P9Hq?=
 =?us-ascii?Q?QHKCTElxmjs7fDoyMIsLQpUXklZq7Cz2+AhRcBgfTx/UbSypWx8PL105redC?=
 =?us-ascii?Q?X+L8606bz872/JJ264Jc1aiP0qcRcSvdMfZFAodkY8SxxaW3e1LoFgQcQlDG?=
 =?us-ascii?Q?TAkvF11TqBR5BGXlkUYbUrkE2ESUcU8o5r6LSVvciyCt8E12wRZKqh5iSOZj?=
 =?us-ascii?Q?+ANw8wRDWexrZ/H9QuWRCKiSLHqunviU7bn0i9BU6qT9kPgTF5Z9vGUsqYXi?=
 =?us-ascii?Q?d5/CTCScPZ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cn2s+CCZLxV3lwbxuBpZ8172TBxNAr6YCmrikiIw2HR4Fo4I95Fkp61sVaVG?=
 =?us-ascii?Q?197IxKRS863HE87E/KZl/y79urCpG63jJpTA6f3jVL47ZK2RPMaFnrRcW/OB?=
 =?us-ascii?Q?RJhCoZJBFADrbbgtzsOezkOUCIHehs6Yfc/kq62RGi3z/IwALlvdeMjhdwto?=
 =?us-ascii?Q?Zj4PIaKAbVyJYM2JoUqalagCqPV/DpuBfcdM9rUfVCq1lqM9rrJbvpduy7vf?=
 =?us-ascii?Q?yem9CzaCYmvmIISeuu3c7lwl8sNki05k03YNhr6WQsdDgYj2HHcPmVPI4LKZ?=
 =?us-ascii?Q?XpQ8TCyGIzv4agYD4zpy44OZMHXPy8+CL+m5Qk+LIns6CChsPHP8UCmuLpCd?=
 =?us-ascii?Q?kyXrCL1x0M3bhhJqO94Y341b8pMICn7q8V4qHnpPcTPGbyTRqgzsAd5dTJfa?=
 =?us-ascii?Q?zYwql2c86uSlkuP0SupNcb9WqYAEmYEFSnIivCSxCqqzN2b1x9+BW/yBHFYT?=
 =?us-ascii?Q?ctgAtGEjFz32T6BPRVOZGZxEjovtqhrFvVLR2OmlTYTjFWvJ4lrldK6ZD0wb?=
 =?us-ascii?Q?fgkS3WlMiG9ixZoyowV+ShfNIe+Pl/JgnGc2PiottB6EZgMBZoe3t5RbBbbF?=
 =?us-ascii?Q?EqVWbYtU0fZGvRnRDQX3Ag9DpS/LdTLdEXgBb/6/PC33Q38Rpc0qiDuPZIQn?=
 =?us-ascii?Q?JSElROKhznxy6anwr5E4X2Zb5azZl6LwF5Pm7cEcXOLIQkucYTpaE5avuabs?=
 =?us-ascii?Q?dSbSVB+ZHq8ZUK2DYVr06b84AY1KqI62yKIwDRfZiz3/uXiRpIKpe91dvcig?=
 =?us-ascii?Q?eUa1QvXgO1e5h16upAgpov0VMfBoIBennsCZzhzHDuZt7UeHZ/TG7Mw1ahEt?=
 =?us-ascii?Q?XP4loi/LtpRUu+OYXLOU91YcCNZEpmJrnVAv9D8+67Gx76QrYZ1kiyOxDM1Q?=
 =?us-ascii?Q?flfc12AUA8oXH6uzWMXSfIyX34g2mCm1wnJCPrr3bqwdc8n38iEgQ9pDOoRV?=
 =?us-ascii?Q?NlTJtoy/Wbcy86X8J42WiuGndxoYQlLaj4g6sLa03fqH3xjKeincZnX6BejH?=
 =?us-ascii?Q?sOuyxX0z5GX9BYcFIp38yCNqN5wAJwo5hKolwFfvAnZ78zPMe6hCMM+tTcge?=
 =?us-ascii?Q?bMKZnFif4kasVUT9dxbg5AKcT0NPOWMB+EfsgFycxtiT4w7up6Hpgx7uuoc6?=
 =?us-ascii?Q?QlRluMnnpABfXnyhW44BCNbZJkWpRkznjL0N8AHCD0x4m6jpb2VHq5K2IAAo?=
 =?us-ascii?Q?gnrDMjWr2aAFtbhkXb5veXn0TMH6LgLS8XkzUtoXudwxfNzBId+/apNqp2Fz?=
 =?us-ascii?Q?CtVgntYhGf+1lkKGYUIx5MbmVmyOUmhNnkdgM/F6HIHr+o9jQtlvLPMo53Y7?=
 =?us-ascii?Q?EFWZWhjc/7oAc2hwpXjYYYTV3NQmuBBGmbhKQNJf4iOeIc8OvnV1nQJJxBBy?=
 =?us-ascii?Q?vKGUYVswwKfBRpsuH7ejuUkJgCxzswpVHm5YMpO79QrePEkTxaH09piHj+1z?=
 =?us-ascii?Q?n3H3jmLUG7P1ZqWGfy72/DNFuCY2NP8s9mD76em1khxVap990gyC/TXxtSFt?=
 =?us-ascii?Q?jthx0eACIF2ooPX1g4w8h0nTGDs0akU4I+qYTEehzYT47nKZYpk/8eAmxVys?=
 =?us-ascii?Q?N3NvaKRuJJKS9ODfujbm5bj23RX02+8dywcHKtl9Njrr45MKKkryrPSOCrT3?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OQGm1fk5rFtJOQh6UWDD7utCXeVUAjSxl6LiYof/g9cmyDK9QA6KbyHP1Ra4k5IVEiit4cGiLyd2CoBpV32h21upEUnD0W/1KU9aD7Rpqw+1SZs4mcqk58zwO0pZfHZRdhCPVymi0UZ4w5z/cECeG12BD8sQQ1ZXSxc32JbYu54kLwZyS/sy2/VtIYxD5cnC6gQG43CONaTqwIMfIdGQeII5PqucCOwU8gMbYr7nOvSrto9e+r6K0aB2z8aQisBEJw5htu8V/qkZ5488MPwaj8spVJ6L2elzpDMgGgAUZKxBi90a/kt7MiJmVS8HpRPulB/aozZpfbm98olsmtpv2cJUDahnIISKwBWKOdiwBuPvF0/HyGRlOi0D7gnKBsav/gHXDA/JIBMxumICixJQrNF9qIuy2JpC04XEXzFpqeJuaLD1dFcFVnaD0ZUSsK9qj2E/9pO5xMbHR1A3ao5jgCSZ6MAvAn5bMj7SzIVDGNG3XVClA3yKxmtLOhLEq6zBhuR+7ya2nYw1gIi8qWzaJwhzwzONQAzRBqmx/JUzgI4Q+zND+G0HEKWLqq7GJ3jVM8WBRFjWqL0TBJVkKn2PaquX2kzw1W0CX66FFKBvIoc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27977f9-e38f-49c9-5473-08ddd8198d7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2025 14:24:02.0140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzBR4EXio+HJKaebJlclhkyvY6Z0/0xhfFCTchWpq1YrDwsp0wCC6QFqFC1POzSWHpGU9wzxwdmNyKhnRYVd7pdhMGOnTbcKyR36KIgaN74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6797
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508100104
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=6898ab91 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Jwnl56gWlS1zMxCLhLwA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: hewBDL5NIBt_ZdfF4BDySmQlJ7vrshFI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDEwNCBTYWx0ZWRfX5g7on9fTUXU+
 9Xk9mb1nltTs+Ukt/vAX/fI3DOOyOj5w5YOjd8fBh3YyCATXayupCW0shzvXGe9rFZDBP5oXUa7
 w1wYUaj92qWp7xTXJkEiRVzYwKmUwikwUeVd9R6WqtVViLHyP395sWEx05HRVYWD2bT7PChbcsM
 iRdVUdC0A95/c3L3RfLxAYCUvpcM0tZl/OBLTvhV2D5QMYba6qFWQgbxHCX2UFywJaABXG3xTNH
 DpDhuA6Zr6W4+w9KH7XLuGE+/B2WDdTfAL+u1/gAFuo3HnQxX7n4+MBTUBO3v4TkKt3OVM6oZAI
 Mnld9sW7fdqdikxnSE1Dq5cmmnQ0Xpn23owp5A2GHeO8dmF7RQsZfr1K4OH9qx6odWMfiVcGoPH
 f3HIxwdKqLK3mZQP8X8ZEHXwzKfZPtsHO/ePORXtW6dmc0Xy4akwHteTFo6I18HtnYM93MG9
X-Proofpoint-GUID: hewBDL5NIBt_ZdfF4BDySmQlJ7vrshFI
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39CDA40005
X-Stat-Signature: bfb6dqbr6rrgqtqb9qp7kc64rqmpcyo3
X-Rspam-User: 
X-HE-Tag: 1754835864-461457
X-HE-Meta: U2FsdGVkX1+jaQ2y0MzvKDKb6oJK+wskehbuJTIt1J9VldoW3HCQltud4axFQDRX5n0rU2H3qIARusWydLsTCQh/gxUGoy9gdS0usJYW8wQ/EsXkDYelBG5g3EzKTBoWXfUWUs6Ja98GLWqU3rGT78Xk8NmmJ6sQrla05rP2Crumm/1zfXvdOSPQeY6V8n/wAFxLmXCGD3aq1IsAdEy6luNHYaDLajmZHPYu8QEgrUrV5+uYSDr4Fxb7V3Ev7uKMJQj6HML57vd44C4UGpaQyV3WpNapKFYofncUHH/42NY7UzviWe8yoZoF5Wk0maH3hunZzPGW6ydBUcjrjTtZ713XkOnwp+XTuQ1eSGhAfp8sA5JVl02/+kqrM/Teqh2SGbybXfQBe1dMnei9dRvCmMXikx/eBtQsqTfpuuVmnthEkAFRE5788443bD6d9MdqCMd9XMhIehOYVu2D4VGTLTrLSASk3ZTuttDgnFkVRk+4nz0BAIlddHgatRdtEuXhuVUe6nEWM6aOcC4gMqR3yhzF+Yg7GAXbL9ZKSanvYgORWFxTVtnEts7OmWSkCm1HcIrkZvv1c/Hp/JJ3SRiY+2JAlUeDZKah/gmwcEFV6TWzfUiHW0BqW3SMlBat+656tOzgGFBtvSEztIB0T1uenXv3/pir9DyhIwEGMOJPsAazbSLw0CRmmfNWPav5+hEc2D3TrvotT2bMFfYQTRVrrFyHphjWRdBGPrms8sTWiH3l7ZEDq9vv+febwm0aLH8h/P6Ym15HoVgdx56X8g4dPfrARAP+bg7rgs6lxhcAiJKgqNGvMj/6P25eCsKcVlTpMOGDQTVFdTAskKFzi2Td90BBRoJW0sYHFc/TgiriAImX4W3TFXGXZrN2fZfXslrxKQndPR0MsTarcw5dy7Ya6e1haRZWdOZJBeWa1Kt6koN96keZvBtqgkWiB6i/l37ir2BTO7ARohuIDaVMnHE
 wJ6JaZx0
 xHz23bqcsXupGb9B9jbqcoBGe3v3WV+oO2bO85efTc6m0X4MRzr1dw0fu/MqFWfPxLXEsKIQZ6RxIiNpYFwg8GYvgXb8QO1tbBLBin5uaZg4Wdr4J+ak0iqnBe0brhk/+8rUd8qo/NKLKSAOmyRAjgQH9sKDUySaN8fZ+9ShUmCcUJv0ammGsPvOHPivkWQ+oFnB8l1f6x7HF1SObNxqnhnn43/zBGQ2VMjk847bHT1zq+UIKyPTeS0w/JwZRpPxXpx0WYwRy7MNEEi7umobDQCoshQYgcDIw+LWiKJeDJlOkK/SErZQD9UegZK9mkA5k4FWQjV8rHzy61xA61/CmEcInE/tKZrC5pDuChKha8HDBL5HELTV7o3gLcs2PZgjSsErn0rfGKVodAoPcY6prR3vQGi2fJFN0S+C53gKqMtaUMzwFX5U0tmKJjGO3rN3Ez2RSsknW4Hom8XPWL2OfLk67APX8ps3Z41wS9FyFPe8q6M1+ASXEnlRZ2rx5HfWbTC2iFFpIPRrOYQEpDVe9pCK7pAvkma8JvZWunppaRHdLZwFmsjfnJfSaJ9FAK8mPiMgkjdEvSFbgU9ImkMOIdZqgg/KQCxIxImhkrQOEe5GRwmtypvwAP0j4uEAxvgZNvb4Fm8etsgKYdkWR5mCN+BeMtKvWNM/sVhWcvcIVQYsmjFob1u8PabOgJ4TvMBCYL+yvp8Md7rhDPqSvKUUH8YXzFWqRY+bjYwzRDYOmPy6bjDcFHeUCweoJH4KbI+k0Ixh0POIsy2x0IOQxcc7XKfCR3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 18, 2025 at 06:21:37PM +0100, Pedro Falcato wrote:
> liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> can hack around it in a trivial fashion, by adding a wrapper.
>
> This wrapper only works for maple_nodes, and not anything else (due to
> us not being able to know rcu_head offsets in any way), and thus we take
> advantage of the type checking to avoid future silent breakage.
>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

So, patch 1/2 of this series has broken the VMA tests for the same reason.

Let's fix this by putting it in a shared place.

The fix enclosed works for me (assuming the patch is reverted).

Cheers, Lorenzo

> ---
>  tools/testing/radix-tree/maple.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index 172700fb7784..bfdc93c36cf9 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -23,6 +23,23 @@
>  #define MODULE_LICENSE(x)
>  #define dump_stack()	assert(0)
>
> +
> +#include <linux/maple_tree.h>
> +
> +static void free_node(struct rcu_head *head)
> +{
> +	struct maple_node *node = container_of(head, struct maple_node, rcu);
> +
> +	free(node);
> +}
> +
> +static void kfree_rcu_node(struct maple_node *node)
> +{
> +	call_rcu(&node->rcu, free_node);
> +}
> +
> +#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
> +
>  #include "../../../lib/maple_tree.c"
>  #include "../../../lib/test_maple_tree.c"
>
> --
> 2.50.1
>
>

----8<----
From 7bbe839b520df5e9aa350fcf7ea96a0c1806729f Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Sun, 10 Aug 2025 15:21:42 +0100
Subject: [PATCH] fix maple/vma tests in shared place

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 tools/testing/shared/maple-shared.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index dc4d30f3860b..572cd2580123 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -9,5 +9,20 @@
 #include <stdlib.h>
 #include <time.h>
 #include "linux/init.h"
+#include <linux/maple_tree.h>
+
+static inline void free_node(struct rcu_head *head)
+{
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	free(node);
+}
+
+static inline void kfree_rcu_node(struct maple_node *node)
+{
+	call_rcu(&node->rcu, free_node);
+}
+
+#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)

 #endif /* __MAPLE_SHARED_H__ */
--
2.50.1

