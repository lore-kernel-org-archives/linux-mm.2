Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E578C79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C266B0132; Mon,  5 Jan 2026 07:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A196B0133; Mon,  5 Jan 2026 07:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B82F6B0134; Mon,  5 Jan 2026 07:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 398A86B0132
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:13:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C69E213D57E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:13:47 +0000 (UTC)
X-FDA: 84297801294.02.3CBBF44
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7D85120010
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:13:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dgG8+xgC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y51hH7Nv;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767615224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WoKK8PxCEm4tJWQIjgPr3MmivhSgy0FqFgEdLIRcsN0=;
	b=cQAcTfTTNenHq1rysOVpl65bOwmucxIemhVuR5kOFskjzgmbE9kv8H4U11et4tXIq5pTFg
	q+XEdowKOHzcqPWRVXzoiOu8Q52brkKkWi3IHztw511CP+m8u3UHvWPmPRGcohFhWRvdqO
	YNTAo9Ti5dWtExsq46ipMvYz1HTy3hg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dgG8+xgC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y51hH7Nv;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767615224; a=rsa-sha256;
	cv=pass;
	b=n0QlpryA29nUqJs0zqqb2Gf4phJwS+yTyX+NSF56ZTV9YROEpHbsBLFM9J01QyUbJQQmXl
	ePxGIdO8za3ByIGHkz9nDMOaFSBZqteAoRJgVxdsRsDUuknnAGQT9DLCMzluWJdFXoTgim
	sGom4/jJ6jMyidlx5ckIPEtYP3KGUG0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6051YPl0340095;
	Mon, 5 Jan 2026 12:13:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WoKK8PxCEm4tJWQIjg
	Pr3MmivhSgy0FqFgEdLIRcsN0=; b=dgG8+xgCTz7FCfw7TdLndKEbgoZz9FFiCT
	aYuKOhIjY/bwahMri4NR2FoqBRzAhU9w/0cXxK9fK1pwcjC50uTIrZvAuS9dhFAp
	J+VnOHzks925VuWQCeWsVv1WHae1zHCRsMo7RNNmnO9RqAY8HKpEWf4CNRTZeWNi
	nJzIOl5No2zmyJ8XlxB+uVYkQZxp+Mf1D7urzvAsKMdIWxftCqAxfSpERh6l5QYI
	Mk/H5UzWF9zti8qBrwuSOXa4RfXTG4B7KeLmrnxUHf2FnO9CfeG1IaEERftxp1dz
	mc9cuwRSzAYFjFIQt08EFwO/mlajW7AXDz//yTuOzC9k1lG5A3kg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37smqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:13:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605C4Plj026266;
	Mon, 5 Jan 2026 12:13:39 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011064.outbound.protection.outlook.com [52.101.62.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhjqsd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:13:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBd3+wasnw/USfILXbPA/uddGSHk+AMBYdaSnjHdHPRkG0xVISP4+L9k/LbQiirvkKsMejQjKpOMlGFeOhDpFq9Nnv+VmA7Trk6l9TAYFV//zZA5R+breDD3+42rWlYzRzWzoQlAKUsQqhywbp4HbgCkDEoyMs0jxqpH8XgTZ7UNlefSlvGFHSz3/io6dszaaHF/ZuNrYzDyeB+3BTxcR6M+hORhgZZIl+exo5I0EMnZBtOBJEk27ASIo18G4hbizAf/ZAN0peHrRaWICpD9yqkKCm4IxYFkLSwxEjoaCDufuNiHZoSFgP5RBoh/D8PFaWRVI2G6ZeJuMCFR8i/2xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoKK8PxCEm4tJWQIjgPr3MmivhSgy0FqFgEdLIRcsN0=;
 b=zN9D8f8/bGlPolVz05wFJBnXfJEkLvtrq2CQw+aJPk99GTK19hcXo6rmgshngf/gKhAKm5mDcc1Kv9NQyXRZwXEJIeIDUrtdoWFwDEyEQA/2sqG9xp2ud/zYIHg7gd6tNQ6JTrNDC+0wUAtAp95R0TWkpwRRU5pv09L46slfz2hEi07Gm67tbfHg1T7vzq2bbj9XURQALoC2ksWXDfqZSOsvRyP/WLtekXToGTt6NfYlq4nFeqmVP8DKL2J0Sl2JflzmrtBWGzKJcBxqOrFF19HZeaTBXGFbG3PTP2iyAEvxcFZFO6N/1YnpnSGaWkZRDM95MRKetuXOhR+Z/KWIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoKK8PxCEm4tJWQIjgPr3MmivhSgy0FqFgEdLIRcsN0=;
 b=y51hH7NvedY64SxWpvBfVypaWRTGxHloqIPhJaeS6C0NAxGp7WDWlvnDnRIJqfqFnsj58LxLuclQqdljAs9Iqmlm7lJxz3KSA+iq6zDK/k3cax7Hk/ofHvzbyxd045hA35kCeWbo1KIUMYsJiCmHkBx0Gr6FKjjIU5l0URXPwi4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ1PR10MB5977.namprd10.prod.outlook.com (2603:10b6:a03:488::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 12:13:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 12:13:36 +0000
Date: Mon, 5 Jan 2026 12:13:37 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
Message-ID: <22d31e56-f28a-45ab-b7d0-4b7a6e511197@lucifer.local>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com>
X-ClientProxiedBy: LO6P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ1PR10MB5977:EE_
X-MS-Office365-Filtering-Correlation-Id: dc6250f4-b1d9-4201-46c4-08de4c53da47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+V/cF+unp5Wo6FATG62366fF210EutQhPh1FvRrxhfCsn5yivnwN4ArNgMCb?=
 =?us-ascii?Q?eTkM1gpZN/pTLfxM9e94NdaLBJ+s4pzWazzhPoisU66lfi6v+enTPV0GrdT/?=
 =?us-ascii?Q?6waKYOP6YXjpgNnojEULvdZmXrIkvtMsQK5xP/ZYucSHBN7B6Jkbws5k6kgw?=
 =?us-ascii?Q?JMYy8IdIJ39asgUc399M/PP3AIeGnx3UC2QN3Px/QWlCCFlQQQOG4evBvACX?=
 =?us-ascii?Q?b3yRaKQh2ry8pxCrzYkQN1/JtQuOgD9sTkI+Tn7Ukn55dBNwO6yGNZoZBMit?=
 =?us-ascii?Q?RN8dSHplCRnpQlUC4XlFcL7VeEXM2pVQdW4BDWlcn47mbkAqPKKV9DYPC8pb?=
 =?us-ascii?Q?COi1Rw3/Hv7ra0EgbuOg0XwqbkFRfvlx0wBwbyOjF1vgC7qLW+I/glto/y1M?=
 =?us-ascii?Q?MUG0OhL8L8Ls6Eh8xpP+1SPXDm6UqTce/nEEj/RaHJKhEt9bmyJprVB7m/RO?=
 =?us-ascii?Q?fkFWlHKmq+F+CwfSYSp1pgnqoqv2B02v3LiACwVsUG9BE1SEG4hF6PYvnzH0?=
 =?us-ascii?Q?M3PM2hJ2kzk6wyMeZRqabNQMuMTlm8HJjanc1/u2hVwZq+r8NY0XCMSd1Vdt?=
 =?us-ascii?Q?ZOKxBvnmX+cq4rQJhqK/Vefn96BP0XpT4dzxel+45ySCphg0qeIfSYzRc5aF?=
 =?us-ascii?Q?RscPNWHyMO1CRYDl8TsWzMMvA9eWfoFC9e5Z2I0PJgVBfrhQvpTWJp3qEl5I?=
 =?us-ascii?Q?OgwUdH8TzUQpyU8u0h5i8IjY88JbxfALZ26ULSiV5ZaXSQt+qCrL/QvvYu2H?=
 =?us-ascii?Q?sg5tfXlzAhUa1D1K1xr4BHwcFs/52ZtbsCcwlZVcjByRcqwpc/OWHuUwRlb1?=
 =?us-ascii?Q?jrhzN1EPwwem16L2MjX5VKLZj2HvOonyV6VXfKz3XRUlhbxFEWzxVsWYCfCG?=
 =?us-ascii?Q?EENzbJqYl7qdBWBj7fbVutMAnH5PYpNqD1m8iGg9N/Ew0NyJjm4akKMCwvTN?=
 =?us-ascii?Q?7F+XCP67bcz/yl1B69jAbFG5DQa3Ognn9al2pzZnooAonSoowxNan+C7pyGg?=
 =?us-ascii?Q?mw9Jn3+S6cgcdqbVu0QraIt2olQV+kD32lmT/d26qB1Wb7BjyB8lQ3UR8gkQ?=
 =?us-ascii?Q?nrsmJlCXAF9T/c/eISgeDHdnQHjdah/xtDmjFgDvqVtM5s+JmG11TplKp2iF?=
 =?us-ascii?Q?KhQRf+vfwnrpJEUxIu+6Ks4ZVhzHCx4Ids9vBZyfD2f4IADaeLw1pj9PAIRP?=
 =?us-ascii?Q?/AT+spcW8DyqPZv3RpwScBoBahuID2ct+bR2yW2vZUVj4Q+gPmksMQQACXXO?=
 =?us-ascii?Q?Itp+t2WaGzbThtBQENdx7hDUaYEbY9JD8Ej/9i7DRsBZyXpjES4u7i56WL7b?=
 =?us-ascii?Q?PWR+YSNxp/Emly6vJNFJVxqD8G88T3mTqZ4joj9q8EYSc2qGiJfJO6PZ4c18?=
 =?us-ascii?Q?QHpnKP625h8Iee98L6ijDyjLIzlqcaWka4+8TIMGQXmyx27Nhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jJG5tEIb7UQRyGzoDqAfC4h7NClz3yp6/XwQ6PrHox+cJOmj2UleVOabr2Sm?=
 =?us-ascii?Q?j/YO+k3YQayTZdPN7AlxYhLTpltl/jQ0142B1TRBOMnTrIuIApLxd1T8kjXn?=
 =?us-ascii?Q?0e601mMLFu46BDGM9YJ8YngUGNrScPTGA1SpAR161rf8QDTC9410WbGbNWhw?=
 =?us-ascii?Q?ixGGnh5WsgHPhypLGwUzdKC2EGSCFCG3eevBJPgUOD+oF711yot3Hq7aX3g7?=
 =?us-ascii?Q?unQyJsrMjbmbsX1r/BkLyd96zP4zBQXzqVR6g5ZyL6okeru1OoPlqq7XpdPy?=
 =?us-ascii?Q?aXxatJ3bv1AZrJHfUs3C+RWaQvXe/K1hfzl0JJeYnPsPGWMOygeVIsveUCMk?=
 =?us-ascii?Q?9qUep2f1jibTn1a+WsjqyuAFQ+heMTx71oSNsejkO7iYektRpEId0B8B4Sxf?=
 =?us-ascii?Q?Rpbxic+HxK6vbV36WAGDHpa7dI7smVfseSjOL2NqzgaFYzAWNWFW72es9TVM?=
 =?us-ascii?Q?JMTsQwgrxQKpomRz718i9rDWcyUTuddRDfD9buh6GXaZlzUUbgRnfUxAQu5q?=
 =?us-ascii?Q?/VK39wQZZ1zSTln3Oib9FJj9oprjwe6xZFKMqMwuqWDqQSsoByoXd5mL2wZF?=
 =?us-ascii?Q?zSlRIgFxgA3RjZB/m9gJicxp7ToctCYXEHdo3D1Tyn9Ql3cmI8eoBk4qngsj?=
 =?us-ascii?Q?/1L8VRde6U+maOH1I4PUYGqiHU0anqA6zv+q1ZVBTyjjmDmkSF5TdGH4d3SH?=
 =?us-ascii?Q?25lFEEOCGwKkZovz8O3uxCvzc6orPNwKQ+SQ8QDWRlpVaVotfxZDm5MM92ak?=
 =?us-ascii?Q?La0bwX6YwodwwI0MhBckc7kCqJClhHX4uM5nvJiZdVO7s5dKMt8PAeHsath0?=
 =?us-ascii?Q?p9NLYCLiPT+X3WiuSmzbx6fw3LmePbq6tU7KtyZJe/H2bilGFG0kqUdbHiqA?=
 =?us-ascii?Q?U/CHQLT79ZXjcimnkfQ3WchXVdl01CgcgBO96PyutzMhWeuSv+GQJGEic14O?=
 =?us-ascii?Q?a8E5gpD77AkDTidYwa7KOt3fYCReFCKKVLAuz923pYH7L5xBBB+Myc198Rqe?=
 =?us-ascii?Q?FAITrAS0guT4PVnxNyimdnTnKN9MGv9S0I91FxbBaANHQ+Kw39b5vI5Ma6CT?=
 =?us-ascii?Q?qIqQMgskTVSZ/uxYVR6oxqP48Y683EmRAezBnd+h36vDSJGiguGB2yONH9DI?=
 =?us-ascii?Q?OMqB8+7BnSt18n30Yb4sao2Yb9fuVO9W7F+HBq0/GpNEXY/Q2BJCWevbk1DH?=
 =?us-ascii?Q?h+LfyXz4Yx06icvLsesPWuamlzdiQrOVRviGxnJt0zqWV6UnNEfXfkAmFrnA?=
 =?us-ascii?Q?MRv5b8WwaA/m+tkRUI20TsLx75SKIrT5ZvdH9nWo6Oy097+73mTfpneMbtOq?=
 =?us-ascii?Q?+WC8Mh7i5X+86Ba8+6tq0FXKl2MiP1ASNhova8WgRISH3Fl66RRLdy0t0nQz?=
 =?us-ascii?Q?KCyC918M6ZTFwCKhTg09WAyyFj7KP3OesJ4tkEav5bW/5NEOVaiiFb4kHF0C?=
 =?us-ascii?Q?b7MnOJ4fD5G6X/FSvwhf1p8u9RnoWV0xUy0czdQSZ87TCnBxJ4f9+UpZci/N?=
 =?us-ascii?Q?iK1W8P6SL3TcxB2V2Xbr3WuKl8jLjxjHb7syUh/DwM5+OnG52p888Fzemk5y?=
 =?us-ascii?Q?P3zbCVToyayInaG57kICZgsQmZar8t7SDWFiveN69CrGnA15BYPIG+6ClMec?=
 =?us-ascii?Q?9q/CBBh111zKoU0J+FWhm932GSpnJIPv7zS+FLdWzjnEpFxgO4ip0M6s35rP?=
 =?us-ascii?Q?Z9riwL5yMQ+o2BbZujcNyjuqSJUK00v9GDQctbipm1skNQ37LypZExlkr3XO?=
 =?us-ascii?Q?boo46aNTa2OhlQf6dI0ZL2Be/XaLK8A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Ow0tYmjhC8ylyEyhyQ2wuXfb8haa4mKTIkw0HpCJUqp3MG9ebgXWbDtQoa1txoAJa4WzvVIfpz7AHQI/TncaY5KxMlsRuGxf88Ph2l/8uxStSLuiWVqQUYZhLBwMW1vcuZcS8FG0QrJInAtlFF2BQCIRwCpY74BnFpXB1e5//ly9SZK/cff0UWA8fMkWwJgfSSRyWERzMzeoMONsIlvVAzI8LD5bLIETlP09B3LNZI8qQSyAxbU8f7jIOCJ7/zDU9CCIw1kxMUGp4XJUeLRKUK+MLq3CJy4JIlktUf37XuBblTDzL8o1PlFycfUmti/CMIw/Mi4PC6CZE5evyDjwB5Ir9M8Sw2DxWvlUcR1rFKz8b0IcE4qWp8lR694dDpzD8BzqCqv/rrxObZIt350J04ttePJpYRCX0JyqbFohOonl5Snv+fUcXxWDagZEb6N8ukCLcm8JMwgfDBRkHrIJRiI0TMYT3QOADYbhzwjaRxbmZuBDYfFI+xE5wqX5X2XBcQbqrEEBIS9TIZ/U3hsMrcDdRQ+9uR5fJsEBjy0GC7IxQeMKWSiZIC7B11539zDjuy2sL4agLC/hce34ZXOJYLCv1ZhQgSeAW8pjqqilL8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6250f4-b1d9-4201-46c4-08de4c53da47
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 12:13:36.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YGGIkGOaYbbFmuQvKtAr36CHORvVzlCKrRboSCBruRFazkhII6MyGHsMp2Wk6jojSwLSVha1qXCHpLK8JB9eSGqwOlNrOfdXQJtKVdHk8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5977
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=849 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEwNSBTYWx0ZWRfXyqc9o0HbGH+o
 UhxpZ/E/KpmrKnjTQB7FFRFYF+Dv4Z8G/BbbMVxHFtjeUS/8AeT0ZK+CSNCy231400dWW9ohlXX
 fDwWPZWXHZz6/BIdN8drd5VUQyIbBAxYM1GNLWi+wqYQYw6R7pcNerS9V1ZvWt4sAo266jjCf9i
 TS3M4czO9iFQ9IRpbsRWwNXMA2vrGpeuOsPs/JMChIazmBNJZwzEPw0WnZZtc8xf2R0lJa1zVvC
 PKGqtddO31p9Q5wDLkvZuGxjnrCCtz2N0xrx1/siACVhvd3YmToX5WSHjEQQmNAgsCY3aWdpF2U
 Cgu9b1gVvdfDMTx1KrdawUFwsIgyUYrcFgSYnQUPJ+yyMglc8oeaUVCTPBMd+y8k7/Yww26TT4U
 iP+nYhXgySyPv27PpW43zF4OfnVOLlrDPJyH4VEdjl2WjyJO5X/70GMy3jDVDyeKRc3XdESyv+a
 mXGoQDSeujlAAjr0aY51FUv1yaQiaCUNKVmE4M7o=
X-Proofpoint-GUID: hhQB5xfi6b6khegfgYAe4-hG_FZZGrw-
X-Proofpoint-ORIG-GUID: hhQB5xfi6b6khegfgYAe4-hG_FZZGrw-
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695baaf4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=95lX09yStPcFndA2:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=3trtME2BrhobO9Jhy8EA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D85120010
X-Stat-Signature: q711o43z6tq9cgtuxuwfghckd8kggqzm
X-HE-Tag: 1767615224-951502
X-HE-Meta: U2FsdGVkX1+ns/n9DjpNe9chQH2qK8WBcaOvowvvM0IQA2Ktnpzd0yXO7MY0eaGMK5UXAEReFB32rB4Z5gL0lTad9ZYJIsXdnRnlRzkygxl+ElWW/U4YqazoQoSr4TVfMiMWgPvx1th1cIs56P8EnFwao3bAZJK0wi23EWtIzOQy2Nf+wdTnaG/A0VIli2b5qCwz8es1XxNg75Ai0tvcap5ZNUdOhGLKsWkdT/VzgB6Jjx8grZZRbyFLhDMoLY9cA+l13wUSeXN3vZ5SRvZzX2fA9JhCFMrKcIF2YX060fFG2Ts/yrsJM3ajd+IeY0acYmxBEhfb1+OvCmKAbjDe3FhL4qnULslW77JipXFoAHYcI1nOhtd4jB8Dx/d3gPF+wOFBHeZMp2tx6ZvEzVRFI1nZRJJuNzWjIeexboL++/HItABB2ZN40yswtcvInJq2BkrxXnN47yE8wxIga178eCq0gG/qqKVzZBg1096M0PNkYvUmd/IIM6q/LMpS+v7BTjwIFxIGt4vg5GZS9jeKXexKgLecbcalbOkd+UWWPWUknZCIl+0Jh8hgu4zZoJDVLgwSbu1N76AGE73Yc14i6e82OtvvN5SCjPni7wF0k+RieWkbcNSpLme1gyr8OGw5LsXPbA3FTHgtyJLiZaBpCfp1v3GBL7InXGqWO1uKOkF02tqPK2MgMqYvH0exSdcyNrVJbLKYTu8JcwhHdKTJkGRnCuCrf9GjAj2NGdBwOhtf1qtQGFSt3C1gWlb0gV7yKCLCtzSnTzLGv82cgL9xDGxIjyuxBM3FtPi5PBzVlrf1OpmlBltpqmQQLLc+83lUkPp4pBu41yru9CRqT3DPXyfSXbj8RUCTsRhkdTu8Irph6Wnx0ZTAKmpfjm8LEXqDo8OEh9TUAPECfcqQzZBw+iOUinaUOD7G+Ocu5ZU7XLI74OGoCSFdC734+Xi96xn50dPOMSs9PvecmHHWLwY
 WIuVMv7E
 8etlEgHJZ0CuKj6HBRLdmEAqkaHB0mol8pPhJxU9fbzSGs17+WvXZzm2fktyhutRVyNe/SBRFdgYnMmRQZQ+bGgMw9xO8ytqJS+h5Enj+UFIOGLU/e11/vyu1UFzW/3bjygZ85FV+Jji1GB7jmvHQWZZSQ05ruiYzncxr9yTZ0L9rw9ooo3LJBTaB/BMaLVcexix/qHkQfmNLWPd1IabJnZNQwedruh+W3qhS9LL9ddxwxJiryv5Zu3f6u2hGh3jGaME3NVbbIHmXAybHg01KVs6mxlxbiGjsk7b7z9wef4tfbjqkTyLLT2eVOZtNYZY5wyJfwKMhg2ZTHxLN3S6hYzPXz5vVM8Hwr7EnkDOIxLZPTuuAkots595WDnsjGwuPvZt+xMUut+NOfvAtZDcNIM0o90oW6NtC6q5C4DUd4Ox+INC3VDWVh94CNH/zOa1Hc7RKFAUrfufMPF9vq9FLhCYsFvaEg9rc0LLd6QJEF/dvWyC5ogMqNOlltsYXgB7hbB2nwjYQn/Tu9habciRRyvcEJg2N0pa/LCkos1oZl8ud0lV5CAXjvidvCN3Yx3eMAfKw3KAaW+BioBTEDOhCDVEOIK0tJ7DrDrQmlSeTKJz0sdlwt2HJp3qvc1DtoUgsKUSAlzg5QEftHezM+op3KnA6IwRUCR5dqBrQLWHFCxBg7221hpxdltYVdOfcO7cEx0t6IRq+9P2KGwh3FWDEhSdA8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 10:17:52PM +0100, Mikulas Patocka wrote:
> If the process was killed by a fatal signal, amdgpu_hmm_register could
> return -EINTR (the -EINTR comes from mm_take_all_locks).
>
> Don't log the error in this case, because no error happened.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> Index: mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
> ===================================================================
> --- mm.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
> +++ mm/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c	2026-01-04 21:19:14.000000000 +0100
> @@ -1070,8 +1070,13 @@ static int init_user_pages(struct kgd_me
>
>  	ret = amdgpu_hmm_register(bo, user_addr);
>  	if (ret) {
> -		pr_err("%s: Failed to register MMU notifier: %d\n",
> -		       __func__, ret);
> +		/*
> +		 * If we got EINTR because the process was killed, don't report
> +		 * it, because no error happened.
> +		 */

I mean, an error did happen right? It seems reasonable to report that you
couldn't register it because a fatal signal arose, so not sure this adds much
value.

If we really do want to skip reporting it, I agree with Christian, the
fatal_signal_pending() seems superfluous.

So if you want to skip reporting a process killed by fatal signal I'd implement
it as:

	if (ret && ret != -EINTR) {
		...
	}

But I generally think this is fine as-is, a user can see the error was
-EINTR. So I'd drop this patch personally.

> +		if (!(fatal_signal_pending(current) && ret == -EINTR))
> +			pr_err("%s: Failed to register MMU notifier: %d\n",
> +			       __func__, ret);
>  		goto out;
>  	}
>
>
>

