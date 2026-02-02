Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE23E73158
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DDDE6B00A2; Mon,  2 Feb 2026 06:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BB36B00A3; Mon,  2 Feb 2026 06:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70ECC6B00A4; Mon,  2 Feb 2026 06:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5666B00A2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:21:17 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB5FA5B8F2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:21:16 +0000 (UTC)
X-FDA: 84399275352.04.3BAFBDF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 74DAD1C0004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:21:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fwRNH8sA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hom4qEkq;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770031273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20taoVo+w850oK0XzjIpPmHn3do/FBVI/sjYr2en020=;
	b=Z8fwKH2RxY02nlYVPGOxLCIGeVl3hjHoCwtJBcnX6YH1WPvrUQkFmYE5m4crmJVsuP7feC
	gtRt1sBP7RVV4PjRSGIDp9GbtKhkAAQ4BghiRu/I6Gfu/b4nebuzwSVyqgAf+e8nwTYOa7
	JGd7wt8X6rFQRPbFbf8wys7DEFNeNl4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fwRNH8sA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hom4qEkq;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770031273; a=rsa-sha256;
	cv=pass;
	b=eNJK9IhE0T6TFzdWzy7oDSKRo5JnjV1FFfj569EjHM1vP9nied8lminKwj81EOnbI/0Ugq
	2m8k7Z9k3rxLtquPJptzvOw1MgUUKs6/MYotgIeu4bC3WTCqg8scwBRths6tKQYAb8JdJS
	7XLi9B8JoxE1+Qlx5En6UtB5eQo9nCg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uT091114028;
	Mon, 2 Feb 2026 11:21:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=20taoVo+w850oK0Xzj
	IpPmHn3do/FBVI/sjYr2en020=; b=fwRNH8sAEuxUiuZQCiXV5vb5LrBJ7kwF2T
	VtIQNcq5izHHcl7pzycTdavOl/IOBPO0HjhibWwKdrnw5K40EG79nYGxF4r6sn+h
	9Csdf4Z0wUXqAhi5pj9FzzeYnvkM3enatKLmkItQlpg4zKwWY3gthy06JaIjBfiE
	uy1cvQkbB4dMnnmD6VmfonFmmr1T5E2IFmbXycj0BXU/Gcx39fmCPPksGo1AyxJ9
	u6R7fhy2ciSKwzb+NYW3XIqzFhRJU0z9rAa1z3FFb42ydMec8wa/hlWBeUokhv1J
	XuLghn0GiMN6OY5tUET2wDurLl/DgOces2ierJomK5ETMtFzzN6g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1avj21v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:21:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612A0IuI002107;
	Mon, 2 Feb 2026 11:21:00 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012066.outbound.protection.outlook.com [40.107.200.66])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186jsqcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 11:21:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iBcLwlcYKC/SeVFrDqkC0i2SWGUZ94yQ7YKLle7iUBL9AMYaeoosyPQ9ivcg2cItadXkrrABLR1Jg+8ciPKtu+Jt5H1okWY/JmKz1ruMrnaDNYxd0+7ZTFoKuHuUIeJgakcAMwQYK9/hqmh2BSNYh643Hwn8NwBta4A6BRSpJLLn54zrC2BvzT24vq+oQuxQeifTCudLuTFomhC71NrDJDBAwtU005I2wYBKjrxrNgFyvD9XLB8cj8RvL6SOQFB3My2D6kCO/y3XnW+inf7izB/FOMC7hOtL3/1WZDi5XXulHgOg99F6/UvzV2kUj9MZztWYDhAhB9tdjA8N0RCcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20taoVo+w850oK0XzjIpPmHn3do/FBVI/sjYr2en020=;
 b=hVRQqf8eDaAT1XnATwxVTM3wnEK1lWjOsvNPsOaDsAfbcEbCMDUusWrqhNlnIVFgWQMHyewgbBwVfXQptcscBr2vV3i2GMzvVYI8LhG/nDVcEgXHhurpfjM2dP859+/mvCG9blXc6NtvZvjQMY1KzoTManEWQftDYGYyq5S+J7w24LeXnVBaraByeY+LoSyZjpfZKaBnStp97E2VXB4SimMbdsPmnL5cP9brfNGBUvNSLWIysDh1SG8m/Fr21Xo/najSXSe9sjXg2Pb3Mj5Tf1Eksd/txVuChFLZWc8xAkZ4N6JTuqrdEXoiO9JNR0yBdDhHV3AOnjUpENHVWrhfvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20taoVo+w850oK0XzjIpPmHn3do/FBVI/sjYr2en020=;
 b=hom4qEkq4zQ3Lux0GGLs65LZr+NmJj/e3lMdQ84jy9DKGzJDbPrM2BlL/eWib7R6SkwqrWcIo16fmXLRRxvqW+5eJbO/iB/hWk+K6K1MwWRJAeqYKOQ6ERHpm6gEgiZfQpXKl9DPnbndYV5pwOCK7Rsho8d1SrWMnXLC+hY5bQU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA3PR10MB8371.namprd10.prod.outlook.com (2603:10b6:208:576::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 11:20:58 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 2 Feb 2026
 11:20:58 +0000
Date: Mon, 2 Feb 2026 11:20:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: ziy@nvidia.com, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
        hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
        kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
        lance.yang@linux.dev, linux-kernel@vger.kernel.org,
        kernel-team@meta.com
Subject: Re: [RFC 00/12] mm: PUD (1GB) THP implementation
Message-ID: <e65bc740-8e20-452c-b66f-0e13cd4e9c59@lucifer.local>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
X-ClientProxiedBy: LO2P265CA0275.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::23) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA3PR10MB8371:EE_
X-MS-Office365-Filtering-Correlation-Id: 69b08924-a7f9-49c7-0dc3-08de624d237e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EHH6jcCQZpjta2t6gcCNT1xTsxczGJYaU2mROHT+9ZWs6O2JLb67nyUPJpT6?=
 =?us-ascii?Q?MwG0OMPwJx2bGt0n24EcnEWWJ2Okxod66AvCNt4pxnWTrcGZ+Wp4a0cuAMLu?=
 =?us-ascii?Q?mWEAzBqMz49/wGFk9+pO3yKCGLSr7bK5XA8OSgDV78UM5ytcmXvN5CVIue7U?=
 =?us-ascii?Q?81XwCx36Fw6Hc7hP0eT0pjD7r8SNsy8sROibX/3ay5gpNSEzqGP0FobUcqzD?=
 =?us-ascii?Q?sgOKS7fIEUrMAKrAsBUFMvFsEHpJQXT8MKonI3tSJu4SjizAKh7UxmZxp2+e?=
 =?us-ascii?Q?LLnshMZbnn8zqovojOaCUqKmzOLNNtSiZTdUeENk5GHnnmqiBds5skkMmMPO?=
 =?us-ascii?Q?ZNdGHiBk47MqE4f3YTUcCFovE253bjilNyGf8hm8hzkko+fbwyXpV8Kf9S24?=
 =?us-ascii?Q?0FOGXfdeq7Be9eg+Arydx61eFIpXItR83tTX7q92H6SRe3h8E44rHE7wI29k?=
 =?us-ascii?Q?4SyCaTvfClIB1HU+0QAikc/CqpCAqektE4kTlrusUtTES1kwvuL2HA8S7G8u?=
 =?us-ascii?Q?XCZ4OL/hc6zeX3foLc6rybSt/oPFyCnUSJdCAAneiqm60lH6RmLb0YufKAgC?=
 =?us-ascii?Q?4uzo/9X2qgpjIMoZh6TG/IUaKZwPpKCrraClR5OeJ9vYO1lb5mI0WuANZHMD?=
 =?us-ascii?Q?3C2YNTn3CwReSuHeDOXhsjV5WyKm4rYzTxiqDh0SZ66Leu+SA6nIsMUsjHKu?=
 =?us-ascii?Q?OZ+ZH46YsCxgM5U1Tw26EMIvgy44kvB+NBuOU6c0qbCWJIKRi7kbqqynsTrO?=
 =?us-ascii?Q?t9SyxWllUC9LRqpfKechVpOJBWCv9e4RN53Yx/l9FxxzNce4u9KIRAmtOj3B?=
 =?us-ascii?Q?7dhQuY7b7frliN8mL5Mon1LT5zKVZS1qwd+777CiENFmd1wB4GdMUSLvH6AT?=
 =?us-ascii?Q?XD/g2MGTcig3Ew+THu2ZngDVUcyOoy2XDgLm/rnIq8cMlzcgCUcJ++MWhX4n?=
 =?us-ascii?Q?76dVH8MXNlCBrZHwijlx04MdZGkJ5u0BKylO8CcC9K00v8m4v94n1/fIrOxA?=
 =?us-ascii?Q?rpUli0Sip2f77gN8QT1rk0bJEPUi9T1Foy+KtXCNEXum1uBJQ0hEy0I2bU1S?=
 =?us-ascii?Q?/qiKdio0FxSI0Yeqkxn2cagq90OETt8UAu6t8/9TWGepbkkC4ITTcXGjXbfF?=
 =?us-ascii?Q?HoFzWXkLJtVRUFR5X6gYVimFO5AR1o1+w9SjtcTYZT25lUX4WEf2WNcIchJb?=
 =?us-ascii?Q?XZ2elq9wXs50U4MamrU3Bd+uorUboE4RcMiKnKEaHZWtlSmfwv8gZiG/skL/?=
 =?us-ascii?Q?3zINbB7WKXDkL8QQq5eBEYIR93EmXekZm8huQn8i4RGc73JM2wDcU3GlspNi?=
 =?us-ascii?Q?gWtydRbpizc/Y001EwZglqzf77j/2lapd5dgfReo374eaim5iER8PlMrPq5a?=
 =?us-ascii?Q?BOlnYYjon4OLt/PSpL0n6RVJjMH3ZFgkMWJzERKoECXigPiiI/R8hNCpoX3/?=
 =?us-ascii?Q?n+xpxF2oWMg2VgmCCbE7UL37qI4+z5EJzj1gEEEZYYUGlQDbWa24ngrYPF/t?=
 =?us-ascii?Q?ZX25KNrFf9mUq66E+36Sg55JbbY8NKzK2XFU2CAfFNUVI9xt1VghI0NBoPT4?=
 =?us-ascii?Q?gyDawxTx/GoC4z4ivM4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5tGBCigHVvcBiuE/OkYT7Ao5wg0VaJjX/XIrm9HnNBo5lJbp3/cnqe9j4qkm?=
 =?us-ascii?Q?qJjO+JkaOeyGV0JI+Kvtl8LZnobpyii3KysPZ99vksiKIM9QJ993NjGQYezS?=
 =?us-ascii?Q?MOFL74djyKD6u4Y219lKAUVxjXj4I1jcxj3xnhYXIZJJkrBEwOpGNATawaB0?=
 =?us-ascii?Q?hsaQrEhCm3+U4g6skNl2cYwYTDLxIKKuevFc6KiI0/ef+8Zu9bvXpxw24m3G?=
 =?us-ascii?Q?9FwyMMJlB5e3AiSmNrGkgVmeitNJVQDmKeaU1Z2duM077vquNR7rNFxnoHC5?=
 =?us-ascii?Q?boSm/wCEzm+yesDY7NPD+pHshyTiPgUPKYVvWSd3Wu3br4DARYvij0EhrZRf?=
 =?us-ascii?Q?iNcf6/NviSLNOP7W6v4DE0uVlxKwxWh/aanWBUZ5WZU6sGmdyKBo+oo/qQ6z?=
 =?us-ascii?Q?ouoTeDghZUgZWuYwtRdmRq9nLgGzfw+vgWEYR29fbBTmOYk8tpafLE5XIwfZ?=
 =?us-ascii?Q?PhAF41A86lrqHbSCP2yqtDi1YiZubAuzIE3KB9C58DtAsRNFaBrXVVEMSRHU?=
 =?us-ascii?Q?13UJVAbPRRr+3vq8CoL9QRUBHBV5gVxds3BlMi6n7/vIRR/bDR/4uKd301YR?=
 =?us-ascii?Q?gxo4r96MtKl+FcQqJBUrnt0WA6XX/C4pXVdUIDJA1ZFopIqXcUP4fUFvvTgT?=
 =?us-ascii?Q?MIBV5mM8narfAUrFeNdiiQe0fg0vYDHtoR1nmppF+ATrXjszDijG3RgA7n8a?=
 =?us-ascii?Q?300P7s/gT2s8aAZB58ir27ysVFUlxVLClO6RJUvf5+BwSvft7pk9NeA0kWKW?=
 =?us-ascii?Q?Ka0t5JAoOp+3XgmNjvcFzqkPBdz631IDJRiOLeHqems1IkKTh1UDELC32Qx4?=
 =?us-ascii?Q?oRwSbZ5iCnGYmybt2xcUWpdDfaUPjc1BMD8jP9hKQTp8QcZGID5cIWfL/Lig?=
 =?us-ascii?Q?DZQrO7ER20N83Lc2O+joagh7IXBaaXrFCJOIeNZSk41p76uyypv+3RGVu9Zj?=
 =?us-ascii?Q?WWeWtuQzZ8aihdhZMiZ+6R4Pb2hD5zAQkpVF7+Jft/Z8uPtr/j4AGnZxTe21?=
 =?us-ascii?Q?89mN9iBQLfUJV2JquY2GssQhM+TVT9J/3u7g4UytXGIIbEkKYZb6xR99lyi5?=
 =?us-ascii?Q?fdxB8UgQCG2//s8l5+UUJfa2XyYRa3uyN325oZ15zhlzjiyGjzMu3hpOgVg4?=
 =?us-ascii?Q?GnaWy6BmfjdJCvOt67V1bnqWdOU3UnxSn0LRSfsg5eSePkJYuqAJcQHS8k+K?=
 =?us-ascii?Q?CCK5/vInWjTiuzipemSQxFbt/M0pxDPiwgF1VrBn+CVGpS81vEoLxx80bXl2?=
 =?us-ascii?Q?YyyEAE5McuLYyvAS3zcgmuzQVshq18D5RIk2jhw+IjkbamJx6n9l4V9FTw4u?=
 =?us-ascii?Q?fgJ72NQGgRyCh2oomYIY41y0knQ2iUf7M2rXMz9/APm3HcfkYESld0faaBph?=
 =?us-ascii?Q?II3TAgdHujFKvJNQ9QF/UYya5UQSZQRK+lF0zBbx1A9+nXLCaXCERyFssLYD?=
 =?us-ascii?Q?0eUmKK0LOanDYmWOo9sDTpco7/IV00SpiCGQTggDnEwr3FHcd89Q94xSNsRm?=
 =?us-ascii?Q?7WBasY+rGByw++OJ27m3ILOHbybtvtvl36MFgtEBuKfqt+KgOGEk2KmLl4B4?=
 =?us-ascii?Q?N7eJe9d/0VRGhcmnMvYYJn2Mhr1hr3lnh2PIEgxCX927cAJ/EdCddSlgkUIJ?=
 =?us-ascii?Q?tHsvr2Msj+3V/kGifNDkw9G5gXSKWeYUHsphsTorAzqlzRIYTcsVOqi+WkaA?=
 =?us-ascii?Q?E2rpc2y0pnyHHl57uflsTIxT2+0MAy4ZfAyIAQg808mxOT9EJKp2i7uQRZLm?=
 =?us-ascii?Q?gC/ebHgoeXSh+X/eLNsuZ/wz3QabvAo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CCk7MzwLJDjqZGjCJyZIul5c5nJ4B0XdA5o2vR0AJtJ3AgkW8yYlJKIn4qAQripExwossu5Q8V7MxU1mQhvha9kqQU2HRKlAj7ikCW9RuQ48P43VHKoHETpwvQ9hUZMgXYKi7otcQ8ZZA2CE4j3BmY3mJkF+PYVjyYT7E72SZ26ffqS6U/byLAr/TnTrLxDqwFw3y1W8HaZjdZzBzXeo9u8+OFJWuni5sP0udvceO8E/DLxim9TQVA3DvR6oduWSxS++04RkMT2VjtDgBeCcJFOQIHw3UcaDWdmYThBBpXJQzlEsdBQH73MNPRTu30tTugBNobYuTZuqy8CCHM7YJ7qNcD1/Gg3LgKQA0ozOjtuagNF6co2Zagsp1AK4SP4FCGQrvMwyVckInXcjrEpDhSkLA16G9+nVRuMuCY+RJz3ZN68AXgz+0jA2pjeGkIs5do6wf2hoLTfQgLPjCm4CjR5vf4ztCMPq/UkyK9vL93RaKK7zK9CMSh0I2sU/RY1F0d+cSJvEnHxZJT//Bj2WGJ1xAtGG50/fkzpUl8kipCs3IBEcrGV9dKi6yGhfNnjOP0HsjhuNPsCIsQ4tNEtGN8fWj8v3ea17Rkoc8QADjOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b08924-a7f9-49c7-0dc3-08de624d237e
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:20:58.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9e2rl0yLI8/6nxgelbQQPc9RbMqAAp7EEALDpIPJJr0PwRDA8twH+lDLhrCa+NF+AlZZtjcgA11GKExL41Z26ADWti4haSDcoUJ3SWZR2Ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=636
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020089
X-Authority-Analysis: v=2.4 cv=C5DkCAP+ c=1 sm=1 tr=0 ts=6980889e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Yox3b6TdwWAfVB1T11EA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA4OSBTYWx0ZWRfX0cLV8eM2fDBq
 dP1meqEnUR1hsK7nClrfeFsvLeaMEBnn7Yrfd9g800QQ9BmhiFVIe4QUOlVREdwJh3O/+7Zr8I+
 tVJZucukNtexkWD3JFQvDHhI/wMBC56Ie+RTYIpWpjD16KUAFCgcke+OpJPS6hb7T/YKIXFw7/G
 +6QDHxvMXxvz8Cr7wV9m7T4FtfmpFwkiWl0/Zk/Nd7gPT721gTPzT+/e4cHH0wiY92+eW0iB/BQ
 8qcoH3vzTch/WBuE27Q/9qpuDrICtA1krsWKMoOqqaXAfATxt1g3oI5kIuq8ck7Cd580Q+iG7tS
 FgYFI0MLwIX/0s28V5m5sLijjclGXs/KcBWy4M5DOIh5J4cMKTtjnGq8z52dhl0nii134FYD/d9
 U32f2fwOK2WV13kDtGFlnMVf9GSg3w2bU31MBwR+16P5UUMJa1Ega2uH4ANVQejNLy7UeU0LgZn
 DJ/HxPLg6G82uqsq835BA4sXsw+veVI2BtOfYVk0=
X-Proofpoint-GUID: QOiGSmOmJK0Qr-txi8K_Ckj0OQHvuL-S
X-Proofpoint-ORIG-GUID: QOiGSmOmJK0Qr-txi8K_Ckj0OQHvuL-S
X-Rspam-User: 
X-Rspamd-Queue-Id: 74DAD1C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: csn5ki6wdyhit13i1a1y8hddncp6sser
X-HE-Tag: 1770031273-240616
X-HE-Meta: U2FsdGVkX18Xyp3Gqlo4C7ptAsqNf+e2HJWhWKiZDpebSaYqIsSpjgBgMOPnHcXbF9+rtlujQg08gpQAjnZ1CW0rIKLHFeMCzBmahfyctTmpH3Pi3AaC6DX3zG4SWkhE6/l5QAPtMNuifnSxXUXwSo39WcDelYIZI8zZ8qdFZEaztv1z+hlPwdpW6fyj54yQ/zwS1qZbYDMmmnAihLM9qhfenczAdOVrd/WncRIVkxs90FM7S+imHAkeufncbYgSUFp3Hcdnx9VF7HPbJw8gQDMRY3YnQq8spMXZKbonyCDJNPqsHJ/uJ0c9UOKFk2HmGzUoOn/s9XZO9RUnEqYC8KOmfCLGXVRgKveZu9qIEiErd6UKQFAmtDSz0k+pOF4/r1BG7VR4tz6b3ov5lk2NcyBJ2aPyiDriplbr1LugN7NgiRggldvyBEsEXJHsL1TsDvCyu+CFJzR1QYNt6s97MH3pq1rjH4+jpgtT1uFyeomtchyE51c0a4BmNb4R65EvtU0jSgfLziqpyXESmlf2hwWeeJqjae8hLrzPVUG4hK9+na98CXl0hCJzMejSXNzqvzikt33qER3BJlnVMjJWUI0Qkz22ebXgJ5qhcJFO9TMvU/VL9gyssppR1v6gjpHkOSUML6pP17pS1ZNge/c/YWkIYCPcDI4T3V/kmC5wIwwzFIr3fHOrBDY1H4FKidU2/+pXIl82dkzMSTC2mgWJw2o91Yuoll2upVOcWHW18Az70vtxiG/FL3ucNLmsxlf/bCrFEDKg7fnICUiriLLGlSk40y9yqB3dWybMouqEcNsKM5tgQvavz/rrd2p0RrYgX7dhrdOXw5wPMYg2T24HXWzyHyZwKXTgMQVR5kMWRknRe3eLQsR/4yvzC5mUcjHalU3wrog36ECw14mGEmySIjdUDWiW5n9qU3OLGygAdh0vSSfyzHgsPGpNxa6+39A3PxqBlsGNgQ41iX+kx44
 rISlWbs2
 41Qz9d2GPnEMMxaHa94gKe49RFNeOx0nQIkdZgVRnwN22+IQWIkrFMm4BVV6hRFyePtS0HFf5NbPVqcgZ2Z6VB7ztRh4wYjBptMVQN/5gZTmDmmuoqX9FXtCEpVTf1IL2z/GQ2lVLEZ5QBLUxXHiuRbGpcYgeJnO5MHYAw8hUwAhC4ChWPcQQcSqOAHTiK41AlgKi6g04ftad/UgniK9PxsDh4SP7wzO7YlrF2VjYfck/7GtD+KV+4CDIkwGgnFz0Kp90sUSmN8GNRlkhifGEOe27HNWbYaPRDIEFg/YoIPP89wU8VavWvz0V9K0w7vYQ/X1fEWLw2EMV4s/HwlleBxuRX9+qDisx7G3AD178bX8b1EU0siEzfUfK5ueR0q33NlSXHCvaK3FB/12lR9wIT6lh/+TOPYSMv76gwMqV5gyM40rGU4H/Rkzd31Dwz3kBl4cl/B0ED1OzAXmEB4d6gsSoeCztRKaW07XQJ4WilytRPb//UhXySBo+8fYU8joxORsOCfx+pHH1sn9JD14cGaqaYdsF3ZIhR0FgsW4LasahhvNA9YOYUP+3yRhyHW08M+M7O1DhcyumW4mFXwDiBjrnIHjf+43GbEJnV5/BqNalIuWpu+p4L08Qbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK so this is somewhat unexpected :)

It would have been nice to discuss it in the THP cabal or at a conference
etc. so we could discuss approaches ahead of time. Communication is important,
especially with major changes like this.

And PUD THP is especially problematic in that it requires pages that the page
allocator can't give us, presumably you're doing something with CMA and... it's
a whole kettle of fish.

It's also complicated by the fact we _already_ support it in the DAX, VFIO cases
but it's kinda a weird sorta special case that we need to keep supporting.

There's questions about how this will interact with khugepaged, MADV_COLLAPSE,
mTHP (and really I want to see Nico's series land before we really consider
this).

So overall, I want to be very cautious and SLOW here. So let's please not drop
the RFC tag until David and I are ok with that?

Also the THP code base is in _dire_ need of rework, and I don't really want to
add major new features without us paying down some technical debt, to be honest.

So let's proceed with caution, and treat this as a very early bit of
experimental code.

Thanks, Lorenzo

