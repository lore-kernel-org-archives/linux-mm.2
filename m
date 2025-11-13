Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D62BCD4F2F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0F68E0003; Thu, 13 Nov 2025 08:20:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8C68E0002; Thu, 13 Nov 2025 08:20:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66FA78E0003; Thu, 13 Nov 2025 08:20:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6E48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:20:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A754989D55
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:20:34 +0000 (UTC)
X-FDA: 84105643188.29.4B571BA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4B8DDA0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:20:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pi0re19m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BUCvxEqJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763040031; a=rsa-sha256;
	cv=pass;
	b=59brjnXk8fpvVFdzJwpmgtDydM+cVoJNwvdPIc4XQuj83HLZ+2KpWdZ5AvwxditQF+jKVI
	54axKUZY6UMwdFpzbyk9lHJRm302Z0QL3MPNy/phgGMyitUuZ8fNXmoARbop+v96esez9f
	5fCjAHn4FP/ou4CpQO65gtfS0ELykMU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Pi0re19m;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BUCvxEqJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763040031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ebVUy14P3d7uQnvRoJ60E3FsrevAjg/AoQtFNUT/TA=;
	b=fkMPG4KaM0pw6RGVUmOMAnx75OW3NG4N0hAM5kQiJFlEQHDQSJfhtddOUIDDe+iQptdtel
	P1udMTzV8OMAK7fm6/ixxcZUKHDlGWuLl5e29lkqphOdr0ye79I+bYaBFxJ/k2mQuyUcdS
	vXOoU1ASMUypGWK219x9MUDjqEUCGBo=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBkMEw030748;
	Thu, 13 Nov 2025 13:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1ebVUy14P3d7uQnvRo
	J60E3FsrevAjg/AoQtFNUT/TA=; b=Pi0re19mxs9KAImPEkQwTmvmBjsIhCtaxJ
	5t5gWyHH7FSmnqGUPShnhedxU6mpCXpH9ZQqlCUzmrDa2QilzdjrfHC9hA2P7kvz
	vOoI7ofzJ1OAGqf6Vl9VJQCIRS9IIgcU69cRNfYjGVQw0YkVnPs7OIfFvtcVjZ7m
	6wJ1kHF9kTTouS8Q13KKt3QrqzZDX7SqyrIcPEQ/3Y3WZf3Zlk+yAF/9zbxEc1l+
	oQcCPuXSmP1YnShqyB02Qb0favUqzjk3HKl4nETLo5inz9bSjtkAmqrvbiWoHLoh
	lAooP6/t0bm1fnSam8PLfrL6+F16GztZffBRrIoRt7NRB1XlXmmA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyra9p6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:20:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADBu3ke039063;
	Thu, 13 Nov 2025 13:20:22 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac3fvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:20:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyCIHNjxq2oiBXsoJ9KOyRlBrDOsLzcXUfttowSEc2LpI2uVQyvGWOn2INRb8vGeD0IwZ0WZD4x4Svaouc3XW6opH9api4ThoP58p1EyHXhoTVEEHzCD3U/zPC/tLLySoXcw6Qjkz902zApp09kvbAhV/AiHufGbFPSm55rsacYKfMmhZxQtDkmBi24UspD/imBSF5Xgvg2bzqvJmMZxfCViTTQfNtNn5seQJKReA1ua2A6x3YAH7nPPzWR4p1XwtDO5nBsxQwWT2QW3wVHYKaBtOVTFZNJKcvAwL3IMH1zhQKjHSO/sVDAlkSueWWMjf1Xnj0WxEyqoMWwcCMvOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ebVUy14P3d7uQnvRoJ60E3FsrevAjg/AoQtFNUT/TA=;
 b=JtC7UfFWKGIcp5RVykOuMd5V0cGMIq/UcOBHkgSVDWsmXd9mXzV1cb+sEEZuKSRasjBxNIGTCyx4Bruy6OI8DUN/fE8sc+jg1hUID5W17UF42dboZRhX70/Di0QsUxcv+t6sTNzs7xG/UdZW0XCvpd1NBfO/7gNBUcmVSG0QBi+6OqngfU0fb819QCCr7lYPC8WegogiFnwVXNUtf58ezLjmH+HegJUKUmyCtUy6kiPOxEmRxO8c1QNvvXQWfCBLEW3EzAer1H5u3VE3xKXUkOQBxFJKJ/Segy6VW9xppPDlbZtsF/6wsF/mI9BToYgCqmp1IOnD0EA4cbo6Q7GFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ebVUy14P3d7uQnvRoJ60E3FsrevAjg/AoQtFNUT/TA=;
 b=BUCvxEqJiUA46Iq2ca4H4ZH9LvRGQo3FhAysx1K8scOLvmyDrCrptJzhz1wVirP2dN3JswWGQEs96FzX+pQNXo5vOaDpf2p9Xqz/no1nFszln9LqMLf92FJolNWE6ltNG5HDmyYOJOY3fw5WOEp39wYokXsQjQpecgQdIhgUp00=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 13:20:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 13:20:16 +0000
Date: Thu, 13 Nov 2025 13:20:14 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Suren Baghdasaryan <surenb@google.com>, Chris Li <chriscli@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v2 1/2] mm: Add vma_start_write_killable()
Message-ID: <894ad5d2-034f-46e0-96fb-135c847e4019@lucifer.local>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-2-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110203204.1454057-2-willy@infradead.org>
X-ClientProxiedBy: LO4P302CA0020.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c05fc90-cb96-453b-39e0-08de22b762e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bEIXc17VDd2q86N5LuRg5aA8v+B5feOWyrS7i5w9HgJfQu8x4UVZIXqEz8DN?=
 =?us-ascii?Q?d2TSzpTrovrtEXcMIMY0Qd7c909oqLj2767fimxuPGSLBZM4rgxXaqh+kOQu?=
 =?us-ascii?Q?pKwfVlKVSwLS5UfFQbq3s3exuKGPyW0tpYBitsmdjmzsouedgqPJ27bFF1mc?=
 =?us-ascii?Q?+0lNvamYPdcphgeZaQPPTBhXEwdBKBP8zbeROBs+TuKmGfeeaKFexe6GgPHr?=
 =?us-ascii?Q?n0C1QuLqonHsI05u7h/odr9sA/EsRzQAx456PDfRnE/OJ++gjvVVLSfWt7B3?=
 =?us-ascii?Q?GEh2qfl0CC4ldk2qd5bFQROMd1sx2Rz2D3Osv1/dWh9p6AQKS7kxc0LNGRkc?=
 =?us-ascii?Q?3acItfvlQNa9okYuZueZlDzNUA1sUDJDtTkJkykTLOViMi5sI5vSKx+q4E8r?=
 =?us-ascii?Q?IqN3a0TEFfSqcOuXDjAVUlIkgGBJgoo37DQqMhmbAYzXbpbYxDSTceNZejuW?=
 =?us-ascii?Q?1Ow0WW0PMT/8pMM4aqed3UrFace38ZQMxbOSl9i8z8793P71VR6le5rPvGyy?=
 =?us-ascii?Q?KQ1c92pnhu+A4JJP25hleDvd7kkEOFpd+bwp2DofKscQZT16SQa9OXNy5XTC?=
 =?us-ascii?Q?jKkiy8g4lgGiS7FvQz18QZChzP0gHuNtb9f++Ck0AcEyaZQ9ooL/GUocggDv?=
 =?us-ascii?Q?luGTBJUhiaoeMbbdytFo4SDNABaZU4cudWOrWvbTmSkRbnjusEtO5GzZoChB?=
 =?us-ascii?Q?dyaB1NnFSFk51LP0uEfKGDaxxj9Aj+NpwIZpBAv8HEDfFDrk01i847TUvN+F?=
 =?us-ascii?Q?QJznPYJF1Gt8C5FdZcIr5bA1haQpTE/stwMH0hNH8NIC9J6z9ncfBCRdwejV?=
 =?us-ascii?Q?t07+KdHRtg1Wl7aHd0/8wElQNXyvSYXg9U02eegrfia6KCM06RwxML06LVnR?=
 =?us-ascii?Q?QVfAwKRqsAFxLl26Hdejk/vkXDQ0AXMo12SJ3TimaL9tXdSpJrKvGgvaWtFu?=
 =?us-ascii?Q?gynN6OYvNHPEmMBabJpKgkdMrZ8k8fy/tvPCyydnkIcEi1UkB1mmG4mYxIHC?=
 =?us-ascii?Q?T2kDsOkFRD9IQTOl9MExUfArG/oZrVuFmLVOqqrHfXHPSDPOZu37AEwl3eY+?=
 =?us-ascii?Q?UYEzuIX1fC6W1qcag19ri6GXC2+bRri5GuZ0EavmsUuHQilTXUUpxW4gxws3?=
 =?us-ascii?Q?p+Y5aSoApT2Tkwsh74OucvFDLhQDZ1flqLzDsxOYTUgElpXBfH4Z+dstoXPk?=
 =?us-ascii?Q?6wude33teuZxzunR7rfdtREAPoI+0bC99J46I9xsh+0/osdEVHJlzV05q/ZS?=
 =?us-ascii?Q?3UN9+E2qGraleuSBNUx5VgaHCHrGlhN16GuXvGkVfQiiE0zU34V+93U7cDiN?=
 =?us-ascii?Q?KrHv8fW83NfFQTXubI0eRWk/gMlI3ne1BvAGJPLIhzgsWPIyK/DrnjLT5o3C?=
 =?us-ascii?Q?Pk2iB7vrxjf1wwlFh0AuP7UaX3r6PwSlfUjwd2YJCCQNNo7IZcX2lwcqYONr?=
 =?us-ascii?Q?MCQIszxmqaD+SEJtbBretSoWdw2laKW5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qa8XvbWwBfqSswC2DjLhusJxJ/2RgGrVPYRXud95qHMV5sZeWsOLUFX6FKOb?=
 =?us-ascii?Q?mtks8sXpijqHcf2RFlCvAeifnOYunzOUFUuB/hy1APQS+i+3NUmly6Hmi5Ta?=
 =?us-ascii?Q?XVkfETNV1iMk0/l+vzJ5SFziFiS3yiwcT24KvWRJt4PaceEnx48E7bPIZ423?=
 =?us-ascii?Q?R1fJXr9HuIML86qio9aDZud++y1GZY1LojcV801mgf2NHekY7en8mqiTyANV?=
 =?us-ascii?Q?kx+55nzbyc2uF3dciUZcpZjcvNh7Eh+md89AiYYDRUtNDF9p04972L+Gd7ws?=
 =?us-ascii?Q?O5SSpdJfJgE1+5Q+GhDJG8YirvxvWaNalh0c1Kkr9Ep+yoVm1db7IZmRI3Wa?=
 =?us-ascii?Q?fTPLHJicNdZNqEiPuhFWIy4qdQemw+AJ4vU0HtZx4LPnFNBp0ukTZLMK0rYC?=
 =?us-ascii?Q?CjK5NGC3P7fRDk0HG6Ca6+lEhwO7hRDMYjOEWN6i9hBYysofSr7EWELtiZZa?=
 =?us-ascii?Q?vP2yVNY7Lf2G+xjcjEQ63iYWtxy6/zf0juTqayGLoOJtzpCiD4GWDJ27mRY+?=
 =?us-ascii?Q?DOellPeFUlX2MFJF5njGFy8HRNeXNlosAo87Mg7Ye7oNx5Rm7lbJZMt9vEZJ?=
 =?us-ascii?Q?tYMrr3eIOVtH0LrDL6gMam9nxRh+JEcXv3tewbxTACzoU64SvGPXvIV3FuUk?=
 =?us-ascii?Q?+S38mJIcjxrVInePuojKGCevXOho+Fa0DyplEJgKozMo0pg7+YDdVYvSopwy?=
 =?us-ascii?Q?BMA+xUJzxCgMRoaR9OOhzOdB5TlsTEiBDilJgFZWNgSq7gybcjxPzBRHwYoS?=
 =?us-ascii?Q?tH4SPyr0BTumOiC9FoaZpfOZxAVmyKs1U7A6ftpgm7wefpcYldHm4hallW5u?=
 =?us-ascii?Q?aw0wDC8i5sndbiUi0K2Ww/ztp3KsVHWakhEuAaEeKxKzEl/UWPKluxy91sbF?=
 =?us-ascii?Q?B8iz4pj1Dqf0qLel5tZBYozZUUKmzgTPYInHP0FlXlSPw/KiE3zN/F3mLu3H?=
 =?us-ascii?Q?Z3GuKDsqMcTjc3hK5Z4++3Rf+B2HvZ/GHKax/WWwEDgYK7OBi1guBmsr7pg3?=
 =?us-ascii?Q?Boe8W3Io2B+gKngAdVCFkIiaRMrOWH4L3xqJbw9PBi5JxiYX+XvAy9l6Trvm?=
 =?us-ascii?Q?lZrZbt+jAQId3jZZKpJXMiXOoaplgnsjtFttiIeTH8f21It0XVLaLjZUrjP4?=
 =?us-ascii?Q?0qfygLBdU5hJKmpaQam7QSHa/QtV5QQYaRuGcCNOz11xeW408AeSkCzewcxx?=
 =?us-ascii?Q?V5i/seA5F0CmNalhzhDWu9HuiPSCJKpW88faXRUuRDjqTlg0rwjhJc0qWrFV?=
 =?us-ascii?Q?jwtkvm5poDWv1mjITsHG34nI+sLHmtiECLaqiGs66Afnx3NRg8FLQRl1TGUK?=
 =?us-ascii?Q?E57SP5t9Nn8On5ZaINAtHvgL4vzGXoa54If8jtQ0azpZktr+2C3CnKsNsJNs?=
 =?us-ascii?Q?fQJB3a8wqugGnhCGfA/Z8vQSYhyAjawkqM26E+DQ1o7PzlVy2jg/4mTq7CP9?=
 =?us-ascii?Q?R2VYFzxr+jsV3XLzwEq7ZUO19cyF8ZlllNbXbe5LrN8aKZ3sw82En1PDi/J/?=
 =?us-ascii?Q?yN5djaQ5bHI/Tw0/cgcZDYY3uS7kVTB56GawHowiJxRkMMfs5zVaAK7kL9uQ?=
 =?us-ascii?Q?oHaAdu5xEZ4RmhPXU2zsTF66R1tMYlMiTJDZcuUd1pp5dN0+bWYDHOR2H7YU?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fix3MnkOYwFfKJp45vjKea0u9q4fO/0/O2i3G9w506JIrZo7WSKxU9QF5bWsnlwRrO5S00FHilbFjIHzdcoDTFH7VJYSIKF0kr0ThfKOVUbqG5u6hbdrKP+VDt5nojN9fWz70r68dbJxhDvcyyWy8N3xz0sEDr/i716DUN6MaVKwsxltY16iDyW6ViG0sMZ+9jzfkh+bbfVRahoOMaGvk1Nn39WgQezLIdvASSrg7tWgMa2Ux8HYkfJc75hIa/mZG3Go8NiHWHcmQhcfe2V5EJ4rLUKQ4pn9tXXEg1hkfr8Y5k9RPCELvC8dz7YYl/XTEmHVG7PzbdO+B8P2VwTSqFeb/oVmLqCbdX3kP2FH8cyHS9fkrRnli4/PepoKViguEpIidp1K7XRl4X6EEhyRUvTYeYvslaetA8ac0ow9ETtCPZxTJJXZw5vu8I4Uo49V6WXP9MIAHWgD7w31KPPgCByakv6LXuVtipWIyeiBpij1bAPUPZeEO9Um07y6wd9EbK2kH6iPmUR4a4N0sACBNj88OEETLV9gK3FDBQqYe7GwVx2/+6NXLa9dxlHDMWE/BMsqZSGgBlVqwxzaQhjrrSGQ6ZHFGzbrk2s9deONCY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c05fc90-cb96-453b-39e0-08de22b762e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:20:16.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qhbhG7kfAau5q7tS+A23jh1GGeriQz9ab6MaBu58WAEFEMlztwKwjEgheYm9DoyWY65Jia3KnIYzo/3fumJKSCmmIC20V4jlZR6t7JNBiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX796coTSqG6WK
 f2Lmxo2y+31a/VjZwjkJFU/VLI87yc7BoRX6tmPcRsNfx9slHHBkD+2da9bikExkB46hyFG3o1j
 7402J08EwYXIN+SXWqezOKUK4/23HUZZ+oEoD0omzvPCa6Ftc65tudXe1Eqi8swiUX07uHqxhc6
 TH9TCrjSDJV9Wr4oTheUqurmwBazaacOa2QOZg3Q3jMiA6R3RLwXT0ukQEdH/HY6BSzMzEO2tgz
 R5wWda1Dy0Jv46X7621pDY6tCaHpPDYk7KneQ44XI3on2tsAJKshl5NVT+6ZleRi1SEDv8iCaEf
 N6bk7pUsuJkbrA3duBSsv07b1ipTbDY8StFHYwTraeI81jqycZxTLcoVg4P1P5oOeJfXQ6uxFST
 PxGbAXVNZ3jVPCjUwf6iaxUWrxUvEQ==
X-Proofpoint-GUID: ms471ntjYWeaa4WZF5kq1tfqeSHYt-ip
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=6915db17 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=il569WG-RGaYDSgk91EA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: ms471ntjYWeaa4WZF5kq1tfqeSHYt-ip
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B8DDA0006
X-Stat-Signature: 3qn6jujffncts3jmc9a4bu3x8gkz3j3y
X-HE-Tag: 1763040031-25889
X-HE-Meta: U2FsdGVkX18qKJlm9S+vaRA1HhLssFM1UQOxKX1RtBO9J49HnXOf5qJoOBCcVz5sxVmJiW4IruXMWPLyj3R8XKLRxzW9t+kAR8/bF5LHWag3Wu1NU13fb4zi+XtrcZjnT18EosurK+d8nUBM6xlA8OCUL4MTJiJDzgcX6jCisOUjLq68aMfO8eGLG64GnIYYaqeWLNUj701MQDE6CFKMrcTgOWZXu5hv/elvag+oHVh6wpEDdYMSIfQTveS9BoCXb2ES3XqP5I/0g75utUFwmzrXy1gZyxlZ+3WfBmbFrj2rHJ1355+WWXQ43Fa5EHU2PtsaqbxkAAceQmOLQj3Z16GiBObRam+zFdWTCACQNwSNakKHt67iK2sUVW/vL9EDS+TpOwgrHoq4U58mtAjWBmu9JrMnZnYoWARxVw75T9Oc1Ax+ePPIx707y1S3Dcb8ysW6pXyDWD/cEAy5lYGm7IJu4Yc1HLODMzRGgRrBPqJFv9njm0HJ+IiPngTnTy5rgbDTLJN2CsOLLENur8yzJh8J4IyT96a2gKZJJ80SvX4oS/Yk3LUceGGlMaCHYmYkuO/EvPUvyVHuPRxgRgTtAxFdtLPe2KUG6GGvVkmyND0krbyD+gsew8fQ3wNkbMmaVdPEX/Qi3EUr4WoPdnHej1Gge5WFJ3VpEH13cvNZ0HGoK4i7340kfO0g4k1NjnSMNPCkHGcUjMPaVbKUmWXGsj6lLJoReEe8apa+Af09/O+gUMwbs6JLA0f3dJ2HMek9U27gTGVQH/Q3rHDq5yLnl/6rNRtf10nD0XQYiA5xxhkakFKaguWEhxR1ib9V8cAxPWSJYNch33ZsACAgu/F/0Cu+WSjkdU/m5zQN1JP/lrb/cIXNCu5S1QTzu5F2aUm9AXEdYZYxQd7sINjT7CiyqpJbInswdwQFnNQpKjbrUjSGWotB4G+KCoyInvn5+N0/VW0VfN+jUVd7IswXEZJ
 yXzFPjSc
 nTSCHhtNa7r3rnkVwZfOqg7XiPIGF9MfDAR/FM+FPc+odhQXWSKhZte+Lg2XcfFvOU7YYOtJrMWGOzbTUo7Ykw516CqWAQC7SCc4xQoRzAMODGFvPZj6NNtmAJ7RGoXCHgsO8s6+HUJf6c5UwaOaxvHqe/StOT3huFMMHX6W031dHOCNGx/LqoJ5Ck2rrTDdEEzBLAe5faN2w/YSJOl3huk8/C/CkLc/NcZIrQrQnpjORWC00c0bJdf0WHEQdlsI0NLzYqfuw+rw1OtWWzsOjBJdhu1n4HtIRTwr5oacdkldoC2RGM8cjV/VImn9D8/5M4XKajqwbFQ1/gxv7ay+qvSRwduFISzdtPw7Zsbjd6xXQMdaI1aR4tGxcUn7/hhCzgbl+0ZCbgfHJPvcSMh9UYvj16QSTwtBvSKBVgYhfY2c2h6rqqdhLnwKWKLV2e5wfoNRaZYDrf+KYiglZGqGVMGds+wc1mkmhsgHORFNh3egWCWPHZYq1DwMdU9Gemr2kaJaInAdUprd97PVsuabnZOwneXGxg5SQglTWzA6w7B/VdYMT/ljLYUi4BRA05o439cM5gRBwwik4UuKJb6RK1DoHD6SjEmRVVCxT29iC+kCUBFxScMaGJHAFdqnn3U7k1B/eEeTKM6WMxAloptzUyz1AxBKKZLIwGaQon04ik4Ouf9G6xB+EXVRh+fKriRXRuFLzNWMGA9sJ+aR7bBaIKtoh4X9GFEHFkfG5buNNBTOFMVPNQCnfrK/5pzr/MvdJqQgAodXeXu1rWkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 08:32:01PM +0000, Matthew Wilcox (Oracle) wrote:
> The vma can be held read-locked for a substantial period of time, eg if
> memory allocation needs to go into reclaim.  It's useful to be able to
> send fatal signals to threads which are waiting for the write lock.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Some nits and comments below but generally logic LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  Documentation/mm/process_addrs.rst |  9 +++++++-
>  include/linux/mmap_lock.h          | 30 ++++++++++++++++++++++++--
>  mm/mmap_lock.c                     | 34 ++++++++++++++++++++++--------
>  tools/testing/vma/vma_internal.h   |  8 +++++++
>  4 files changed, 69 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index be49e2a269e4..7f2f3e87071d 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -48,7 +48,8 @@ Terminology
>  * **VMA locks** - The VMA lock is at VMA granularity (of course) which behaves
>    as a read/write semaphore in practice. A VMA read lock is obtained via
>    :c:func:`!lock_vma_under_rcu` (and unlocked via :c:func:`!vma_end_read`) and a
> -  write lock via :c:func:`!vma_start_write` (all VMA write locks are unlocked
> +  write lock via vma_start_write() or vma_start_write_killable()
> +  (all VMA write locks are unlocked

Thanks for updating!

>    automatically when the mmap write lock is released). To take a VMA write lock
>    you **must** have already acquired an :c:func:`!mmap_write_lock`.
>  * **rmap locks** - When trying to access VMAs through the reverse mapping via a
> @@ -907,3 +908,9 @@ Stack expansion
>  Stack expansion throws up additional complexities in that we cannot permit there
>  to be racing page faults, as a result we invoke :c:func:`!vma_start_write` to
>  prevent this in :c:func:`!expand_downwards` or :c:func:`!expand_upwards`.
> +
> +------------------------
> +Functions and structures
> +------------------------
> +
> +.. kernel-doc:: include/linux/mmap_lock.h

Ah nice to add this now we've got everything squared away into the right
header :)

> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 2c9fffa58714..378dfb9f1335 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -195,7 +195,8 @@ static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_l
>  	return (vma->vm_lock_seq == *mm_lock_seq);
>  }
>
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq);
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> +		int state);
>
>  /*
>   * Begin writing to a VMA.
> @@ -209,7 +210,30 @@ static inline void vma_start_write(struct vm_area_struct *vma)
>  	if (__is_vma_write_locked(vma, &mm_lock_seq))
>  		return;
>
> -	__vma_start_write(vma, mm_lock_seq);
> +	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> +}
> +
> +/**
> + * vma_start_write_killable - Begin writing to a VMA.
> + * @vma: The VMA we are going to modify.
> + *
> + * Exclude concurrent readers under the per-VMA lock until the currently
> + * write-locked mmap_lock is dropped or downgraded.
> + *
> + * Context: May sleep while waiting for readers to drop the vma read lock.
> + * Caller must already hold the mmap_lock for write.
> + *
> + * Return: 0 for a successful acquisition.  -EINTR if a fatal signal was
> + * received.
> + */

Not relevant to this series but probably we should write kdoc's for all of
these...

> +static inline __must_check
> +int vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +	unsigned int mm_lock_seq;
> +

Wonder if an mmap write lock assert is appropriate here. But we can defer
that as we don't do that with vma_start_write() either...

> +	if (__is_vma_write_locked(vma, &mm_lock_seq))
> +		return 0;
> +	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
>  }
>
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> @@ -286,6 +310,8 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  		{ return NULL; }
>  static inline void vma_end_read(struct vm_area_struct *vma) {}
>  static inline void vma_start_write(struct vm_area_struct *vma) {}
> +static inline __must_check
> +int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  		{ mmap_assert_write_locked(vma->vm_mm); }
>  static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 0a0db5849b8e..39f341caf32c 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -45,8 +45,15 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
> -static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching)
> +/*
> + * Return value: 0 if vma detached,
> + * 1 if vma attached with no readers,
> + * -EINTR if signal received,
> + */
> +static inline int __vma_enter_locked(struct vm_area_struct *vma,
> +		bool detaching, int state)
>  {
> +	int err;
>  	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
>
>  	/* Additional refcnt if the vma is attached. */
> @@ -58,15 +65,19 @@ static inline bool __vma_enter_locked(struct vm_area_struct *vma, bool detaching
>  	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
>  	 */
>  	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> -		return false;
> +		return 0;
>
>  	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> -	rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
> +	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> -		   TASK_UNINTERRUPTIBLE);
> +		   state);
> +	if (err) {
> +		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +		return err;
> +	}
>  	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
>
> -	return true;
> +	return 1;
>  }
>
>  static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
> @@ -75,16 +86,19 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
>  	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  }
>
> -void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
> +int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> +		int state)
>  {
> -	bool locked;
> +	int locked;
>
>  	/*
>  	 * __vma_enter_locked() returns false immediately if the vma is not
>  	 * attached, otherwise it waits until refcnt is indicating that vma
>  	 * is attached with no readers.

This comment seems to need updating?

>  	 */
> -	locked = __vma_enter_locked(vma, false);
> +	locked = __vma_enter_locked(vma, false, state);

NIT, but while we're here maybe we could make this:

	locked = __vma_enter_locked(vma, /*detaching=*/false, state);

> +	if (locked < 0)
> +		return locked;
>
>  	/*
>  	 * We should use WRITE_ONCE() here because we can have concurrent reads
> @@ -100,6 +114,8 @@ void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
>  		__vma_exit_locked(vma, &detached);
>  		WARN_ON_ONCE(detached); /* vma should remain attached */
>  	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__vma_start_write);
>
> @@ -118,7 +134,7 @@ void vma_mark_detached(struct vm_area_struct *vma)
>  	 */
>  	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
>  		/* Wait until vma is detached with no readers. */
> -		if (__vma_enter_locked(vma, true)) {
> +		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {

No issues with us waiting uninterruptibly here?

I guess rare condition and we require this to happen so makes sense.

>  			bool detached;
>
>  			__vma_exit_locked(vma, &detached);
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index dc976a285ad2..917062cfbc69 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -844,6 +844,14 @@ static inline void vma_start_write(struct vm_area_struct *vma)
>  	vma->vm_lock_seq++;
>  }
>
> +static inline __must_check
> +int vma_start_write_killable(struct vm_area_struct *vma)
> +{
> +	/* Used to indicate to tests that a write operation has begun. */
> +	vma->vm_lock_seq++;
> +	return 0;
> +}

Thanks for updating. A stub is fine here.

> +
>  static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
>  					 unsigned long start,
>  					 unsigned long end,
> --
> 2.47.2
>
>

