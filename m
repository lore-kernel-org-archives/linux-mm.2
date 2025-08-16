Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A86CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33188E023F; Sat, 16 Aug 2025 03:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06888E000B; Sat, 16 Aug 2025 03:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE298E023F; Sat, 16 Aug 2025 03:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD858E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:53:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B0341A0393
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:53:22 +0000 (UTC)
X-FDA: 83781855444.28.0C1105E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id C78FD1C0003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:53:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l66C4o5h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WNqB8e1h;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755330799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNz+4usCjnVM90ZUYounm0wmQM1Sujc+Yfmirhm/9Xw=;
	b=QUADK/IJTc+IdiMaNehvDIXW/A9h3pU2HzG82eX++A1zfUVuqXTlYCWK28frxAdxEiF+ZK
	QHyIelkgUOyTFsL6gEWRyru6wtBqs8cORmhfDW8p56frNkN3QZmSVzKS5FeGQZ5ywpWbdD
	91dt6zSn0vsCeuv9Ep0ily2mIgwKLJ0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l66C4o5h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WNqB8e1h;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755330799; a=rsa-sha256;
	cv=pass;
	b=vdsZky9yOcSkSDsJzeMieGcQ5AodB/BqvVUlYTjSiTJPzbOraKeEc6XkQqWiC87nb4lxnV
	tNxFqUqnx8n+T3Y49ySx98Z9k4KPc4YSLB0p9yM8cHgfehdXie6CSrv/S/Yw+czupjEBcP
	w4lyhB/pmeqUMuG4vjIWkJn6e9ymIm8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G61QDb024452;
	Sat, 16 Aug 2025 07:53:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XNz+4usCjnVM90ZUYo
	unm0wmQM1Sujc+Yfmirhm/9Xw=; b=l66C4o5h9KXblYvKNNgeiQWpBSK3WzEVky
	wI8ldEjNxo8quM+mKRjyMZ6XT7wvLIvLyn40BLNK1TRyiH1jCbEtormAOtaP5IIX
	kHnm3C7wEMETKAWLLActgH9dC3dWgRsVnpjSjobpKoQvQ4LJ+/lrjHe8J8Q56y5K
	oFiF06LW6ubJtCn9Tv8Dp+awfnkiAz6H6/Rt5mwuSpXMj7qNgHuEusCwKq9pYXd4
	kdGcoARYAJtecG08EWMXE9GsFnuta/yzWk5IsCAdUIDHvbUay4Xe1ivKdv3ShjHp
	z6BcYRYDHoo4Wc3pW+WcHu95er9GevjL8zxz/D2hNnt5yehX6PAA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgwe885u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 07:53:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57G60KNW024442;
	Sat, 16 Aug 2025 07:53:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012053.outbound.protection.outlook.com [52.101.43.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge6y4cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 07:53:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpS5DpFQsxDAOP5Qv/4YU8Ra0oiWi30A1F4jT1Q7TpmELpCDmMK9CS2yJepb/DJb55i+nnuKXG8ncHW3y/2INPH1q6yuEEahBGacfUny+2IdAbur0JbDgtBRP24rwbzgBM59QNeTMN50tpUq5Tg5+AbfpsMbXp+BjIKmh1t91KKXPbc+yKHctGofzfAmyCN9WubwCZUuNOtBhRtymYG0OGHsMj4IwgglUTpTrATvZhhjrdhe/cop3UEfZ5oIkvy6XLy9GwpJ/Zy9LQin+6Fq8rHnax8w0Muh9nytUVOjiGzJ/Sm3arf0vrF3P9OoBqvqOvVHiuxnESemq3xmrH63yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNz+4usCjnVM90ZUYounm0wmQM1Sujc+Yfmirhm/9Xw=;
 b=NWiijx85Uuk0u4wXgiyWeCfoXXOe0eJ+vDg4bL7Uyug94P0IDiebPYMd4EseTC5FNeTnusF0ZkD4uTlKRSr6oGvjqERF0/WnQ2xYUsu7Kgd8KDtKYx7PTd71Y1mLxa4e32dHGkNnqNw8BgK4zTVKnejXSB1wMp1xuRzW8jnc4gJ3uYZo91SR3V6vN+fY2E/9Ci5K/hXmD0bRhykh0epdUkTJTl3TrsgPNyhzOJI9jeJKQPGW8mOQOxHbSxEerj8JSu1C8r+KNgFmBBWg2d0ndJ6rCEq8zL/v8Oc/7Hoo0wLYxqVIwUE0uquOHGXbZ7u+YRuPsL/k+T/UAylhT8CSNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNz+4usCjnVM90ZUYounm0wmQM1Sujc+Yfmirhm/9Xw=;
 b=WNqB8e1hrqJ7RnMDpnntW9W/wg/1g4QnFAUwuzmAQBEmvSptj/xpRF8XPkW+oBWQc+sG1Dob/t6kRyZtk21jRxF3LsowB9INiJP/VKe/obro6rxZo24RAJgbWmaimAQjOQi9mZSdMg+4hqvWr/vqH7HkQlSSJD6ts6P6pBn+1aA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPFCCE340B80.namprd10.prod.outlook.com (2603:10b6:f:fc00::c4d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Sat, 16 Aug
 2025 07:52:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Sat, 16 Aug 2025
 07:52:49 +0000
Date: Sat, 16 Aug 2025 08:52:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.17 2/3] mm/mremap: catch invalid multi VMA moves earlier
Message-ID: <b6dbda20-667e-4053-abae-8ed4fa84bb6c@lucifer.local>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: MM0P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPFCCE340B80:EE_
X-MS-Office365-Filtering-Correlation-Id: 3af28ca5-3dbe-4c8a-7cf6-08dddc99e4c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CCRJiTNMZJoSBuqqKqWtfJGL44Oxot1t467qZvz1GmZ7yE4xYMsfc4YjmHJd?=
 =?us-ascii?Q?5/WL5v3JxqgDFLW9bSvNilBu2c+nD14fWIdifc10VacGtcV6J05pS1JvxOjD?=
 =?us-ascii?Q?9/WoNpDzqKSm9axaQibWuD/LP31eOlTFsygornF1h/pVn4ThqmLQvngM1Xch?=
 =?us-ascii?Q?D7C9KtuWSjRy3vfyplV1XRWTBP5mXfXzYTDFO/GVFnidABkI4+6gwMZLljbt?=
 =?us-ascii?Q?9lfTwGwODSsWQEkol6kxS35DZduBocFth8oZsrDhVz9oxDikCdHkqRJz2LwP?=
 =?us-ascii?Q?Pqg2V0kA1cJ8DhVbaMinsfiZANVVYWB6xWzghsqMNXefFJIJOA+VSVDH/UVH?=
 =?us-ascii?Q?6yNIxxpKAo4k35JkWo02WgG7HkL666wpNhsSWE2vmiUcagN/pgfZfUidEstX?=
 =?us-ascii?Q?ZiEH7sPsD1te1sNqsj6vl0/3x8kWRlcxsJ+2xUnWRsRAMRZLU8+m7bDD271p?=
 =?us-ascii?Q?+Lv61+WT0YqmkBzxIP+7T2Khy/xXBZe6zcKr+JxeCo1C7f8wPPqdQVUWKWHX?=
 =?us-ascii?Q?pC6AecSx+Xmvs2KHqD/mN9bZBpdVWudlTcqoCk8pPZJLMyhbrfrkQwkqUfvp?=
 =?us-ascii?Q?e/ripK8UCbRsCDtPKjGimDlMc3duoe76Xfngya55od/wKgwI2OnKZhK/Gy//?=
 =?us-ascii?Q?3SfcbI7ssX4AFJ/zA05EfwcSx8mTwTNdhFs18sHjpb9qWrudD/CaXEtN7toe?=
 =?us-ascii?Q?IAN9R7nIi11kTNymzvj+6japsyDn/wgBfGLGbUlJZT+i3knuAk1rdesSAZ+Q?=
 =?us-ascii?Q?+mUQXYuVCjEZyJLHr6N/F3xZw9QDwX5fYa6ry4mhp8wjjJLg8BDvjmCdXzQF?=
 =?us-ascii?Q?cRV9A1kRkpNsh2Rfo0DWxbcm8pvlj8r12c6/QNC8z/8XLFGCbxvcBZNThchq?=
 =?us-ascii?Q?Oe664qicsHJqUG5hn1DgR786+aixIOIrDtAp0UogWkzHipN5y7SoZRg489ID?=
 =?us-ascii?Q?s2uAQThOb/G2QhvCTn3LCPUBn5RymU4ydykTtxw8WRoDFOKslt6zbnXpfLWG?=
 =?us-ascii?Q?XuHXJtWhVUExOlS9WHTQkepssVFoXkRdz4KdP2uvJEd1/bAM+vpiYVUPuY6D?=
 =?us-ascii?Q?Y5Q7lsfSB7E5RTcUezl0TZv+QtVXsi8NeoWxmAYuIqSGMN5EGhzzhiE/5OfZ?=
 =?us-ascii?Q?UlofwqwDP8tu+WGoRE3quvDbzoeU9JN0CtgkNILpVWm45/USAxMXycwIgXBQ?=
 =?us-ascii?Q?DccXlZAw00XRIBhUXSoNjo7Wg2oGYac5TsZSgY5QF68wTG81mQK9j/1MKF8U?=
 =?us-ascii?Q?oI9yMz/h4p9ZfVra0NsOJSoPaq1YGRVyXfY/LqtAmt4JOZCNbRouTIZLh5Kn?=
 =?us-ascii?Q?pREuj8esddv2TfS9e7f5kG8Ce+B9EZPfgMk3lAAXZP6nkRwFYxclebZzAqBY?=
 =?us-ascii?Q?UrDN0MwqJV9hqyh3TWOQd2VEUoVsgEEA/tAOqWNiulk5cxDmJy4b3cUFsNAa?=
 =?us-ascii?Q?6KHfCmQJM7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8I2Ja/16QZE4TV87tjdrV5dj6Ns5myriHsFaY5Dr0eXaH6sntUJ1tdO+GVbs?=
 =?us-ascii?Q?z3W87NCBKyOoJg6NUnVKO16U7FDRtk7pUUWuxsBeX1kDoMPoNKhs+3dUW7MZ?=
 =?us-ascii?Q?RUJYTbo1gJkVP78z+5bQXEjfQoWnFe1r0Wfbw8vCuLSWa5a4Na/YArqY3PdL?=
 =?us-ascii?Q?MQF+7uib+OuTdDEtMEEHsN86E8pVMM/nAwYfxjzxh1ipt2vJ9kMFENpJ2Mv/?=
 =?us-ascii?Q?q88pF7qX6/bYmfxWkvLB3pQ5FYMRRkKfxK4ml2BMtsULcjGWeWBDdreNj+zg?=
 =?us-ascii?Q?pvMlcbXgwFMbIs72bBedwQks8cDa76ruKoN8z3mlfRHb1yhhbLH+SgQ5Ddus?=
 =?us-ascii?Q?rdB31Jq8xiE7IGLRP8KHr81keQveWO/W+/HwHxbsXR/7W/8xxqdIuL0BcOYe?=
 =?us-ascii?Q?ofO6YaFlly4zrvGl84KMm2jgyOCb7Tm4BS62ZLGUqhQKtsb1aPozStH2jZXi?=
 =?us-ascii?Q?+H8aTO93PIhs6ycVC3JjEXVHZqhUh7+HDSmivHwJ2w8kJPCtLodl24QM6Slv?=
 =?us-ascii?Q?ZXr49vhLPcvEjLAo6NSJTNA42SBPTk1bgxtLsoXq93E492p7MGzlKTIBawSY?=
 =?us-ascii?Q?JiMYo0Tyx7Y5164Bz19vonuXKrwjuPlskJpuW/zxIYa6he0dLnLG+Eucqn4d?=
 =?us-ascii?Q?VqFndIxxV7/W+uU/odP7w9/QowxMKvPsseahejRNbFNpCvahUi3h6uHa5jBp?=
 =?us-ascii?Q?tdQdqdRBzt86ya1rXh3hy/hTxLWptWX6YPG2uc16iXZA1uuFPRJkoBuqxskA?=
 =?us-ascii?Q?Kjkh60WLaWGDHUZGnDoWLqiWZdLRqOnMzkye0YMuzZhuiUjZwb0PAl/PhbiE?=
 =?us-ascii?Q?Rtg19DXkw4UIw5xzmkWsIrZo3srRs4UYaC9fMk8zH8QeaWlYN48oAHiexgb6?=
 =?us-ascii?Q?4u4tUYvgNfRIyAwz6XmONFjT+JEt3P4E6EM2kW46+VWTC8PKPL9cwUVm9LTV?=
 =?us-ascii?Q?+ZzZKKKccQjP/Rtd/Pn5ls0dS4EA00v0AoB9BRHhuy3aGMJYZnk8fuqlohok?=
 =?us-ascii?Q?im22FfrikEIObCqc8DklXxb+KXb44PdQaPrHAgCVx/MwOBu8Yb6w6o4Ycvpz?=
 =?us-ascii?Q?/rcoRNcL34cqAT65hZMl20xFRQiMs23PLv0v3ymGEzquK/8IFhYvsyPCzCOc?=
 =?us-ascii?Q?DIPOmwp846qDu4YIsvsQY/NxtYw1Hz0gbrIBZ8C2x7bonp5X99ckSWzjAgAR?=
 =?us-ascii?Q?W2H69TAKcW1rCgce1DRfwTS/+ODXFXqb8N5XeBhD10zOENaD/jd42ZJS4QJ3?=
 =?us-ascii?Q?1ocUEJfbVT7LVg5+fgjWNxsw2popw8m0dQ0k9Y1cvb5Ibko52VpdrN3N1NAP?=
 =?us-ascii?Q?bQZwq6USwjzed66m60AC3yROq7smikvZNnDoO8j4YjedHJ1IxRzHB6rvMhm/?=
 =?us-ascii?Q?bpHih3jnvcAWbPt51YbmEq8HS0MXc9/TjLa/NmvBWUVlcWIsYYNkBC54VDC9?=
 =?us-ascii?Q?nXk3TZrNZ70EKgLb6YGt5FmtUUFvfQ+co2MYB+yystaKjta+k8rynvdUwZ1u?=
 =?us-ascii?Q?JxY479nWSNhTMEIDFT85H5T94rOYYuYZnPBfgEfXCQFR//vx5L5ri0Or56OK?=
 =?us-ascii?Q?rqWXHaFmqgC2pr1BiHy/7JY971cYAdf5TQq7tQ39Mwj/alUuwQ9/Lbq3ak5L?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	X6Xx4fsLnbBbBa/V1qgFHhHYIn1/Acb8eNsSdhTWoXWwn6ojG7xOyBcsulyKlYO1+R1ZGFoSm7g/9uibbTFFjQHtZtoinqvCg7hpjAq9yJTmo9rAxZQWIJWzphicvAuDVm2qtMAYKAucmtf/mGDV2BqMFLaJilQKGfpGIRU7ncFhfDXUnT2DwO2W0DcUpCdTB6hrVq8iC3GFq312AiNnyHyl+yjfxk97kHBGCX8Aq4fLp30TOHWD+b1NKY0+i2g+3L8uwCDkP2r6RpGGNkkhMSvvGLaIg4Yp0iQNjmgOGniqg5fbw+/Q24vE3UhPYWSa2Gkg2EM/TxeGH/jEH0igMEorDr1jYbBISAYf2xPA4QbGzjgkkXU4iZIoDyX3ETDeY8ZgaK9Igks7OtYHi5jqNGkCUaz60vR8Aa4NEnNjKtMmdsBTmQSa200Z8ytNPAaEZDn4IG9WhqnxrpcWTiDqAy3povQ+o6XU/FRYS1KONoND4ZONIqBmfECOyc5Rgxug3yNU/yUBxL+bUcY461ikK10qyT92zlSSLQsjOABJ0M+MdPu5FhGnq/BMXsFxsnJXo/TvdbRa+IgTzURWXnHtO1VuOWHPES5heJQ9nc41Drc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3af28ca5-3dbe-4c8a-7cf6-08dddc99e4c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2025 07:52:49.2237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv2meuSEkxHk1iSYfVLhHBM74mRNGF3i4rigI6FRneGMssoVX+LQ9TCrTGqX0H5+igJpG7ms6tJsB1biLNZB9xXCM5UI2hJsBY8AmMjFj7E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFCCE340B80
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508160079
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDA3OCBTYWx0ZWRfX91x4ZHnd/nwG
 uyg7Zr6raumYkx6oefJ3i/qC1/SrLvqNngRUSO0ldCK1Dr53R1fKcPhUsXFNw/r3oIFCUudqvc/
 PiN3pvl9IVeoD882ss/1esY7W4gOgTl7NvZ9QYZUTdkfTYAZwxyhUXXFwZCkwd+H0U65eK+6AdL
 4gOUFH+wf12HcTflEC0v+eTglh5FACqS558WGf1tNP/rZryYVamNLmYut1cWJhgSyrbMe6XMRT4
 yXySb092GoeIczgpwNOtIueDqNrv2oZnPEiP4nRK/tOosL35nEuJGCFwYAGJQRDtMlCT5jqbyKq
 LkHVAlPouUVCt8Reri7yGOpz672DJycu8YnJOd6khV6hbZwkLduyPip3MHOGGf49DawWa8raxlR
 lnSljNEpbcSgT0hqLsexSUiJvzaKMSNZHDWJVZmLz+umdGgt7mPcZXDlPu6J83+YD4X2ZsiE
X-Proofpoint-ORIG-GUID: n-R7F4gLTkNuPMqxeypLNF0rcoa_AGVX
X-Authority-Analysis: v=2.4 cv=arOyCTZV c=1 sm=1 tr=0 ts=68a038e4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8 a=APlSODtWc97UeWhVmOEA:9 a=CjuIK1q_8ugA:10
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-GUID: n-R7F4gLTkNuPMqxeypLNF0rcoa_AGVX
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C78FD1C0003
X-Stat-Signature: hkynefjmnahja65uxde9t5mf5cshhnmj
X-Rspam-User: 
X-HE-Tag: 1755330798-469590
X-HE-Meta: U2FsdGVkX1/k/2jE7TYGtOCflobG7JqL73k9/zadH88BIVaHyho+SuMxfBm3Kf6bzZseqVMiv3H0UKI3iTm+yDxtUQ/Y9+IY4D7KDR6KJcVQVNMd1sJR/LaQB/ayKDMe8HbV88QTHc6C/7ZlTGXhnk98Mc9kvJCmEqk/km36TbhGgFhJKTnrmbfK+oc6+Nz4+OzT8AjMY91F99FRDrXwQP/+tw9GxzO19biVVDxawSJHD6XdE3LbtCw3/S9QOkTiyncQcnYbGzyd5w0ESYu+sbAgdFObdomNWtbPX64w2Dhn7FI0P7h3eilnUcWBsaagRRDorDoSr5ljevhv0S3/LWZujFmGOhscIbZmgFhl+a4F/PAfvudoeuS4RvsZ9gzxq8imST5THstnv5lzFWrARAcS2Z5DrdHd/rjv47eddphJxtZ6Mnm6PGwyfba1U3FX+ZEqcfadH/TDy9S9A4nBfWg+YoZogh3YkE5/EmQwRu9IIlpThviZVv1Bx+hRBIgCrgVxJs0M4MJa+/ymNT16J66FvNVTKsvLO4K0KmhIEs+y72jPwvlUna06psGux+GrHo8/aIuk8NImjVKLVS7Oz9SqePSTYuXF/cQE5sCWtE/gHa2A/942ub2JdBkjg7jo9ZKULC6nMXQ+n2SDVsDo8nN1jDOoX2uuOtD+pyFdjFQtAUUS5XCjqI4vnfucnjW1nXWksLEwLaFNcsTMuzr66023cLoUUsO0kaC4Ub5O2xX7e+20Agr19GPLJKvDReQIDhl+BU5D2fWulfCXdR9qnU/0uCXCPAxPPODSb0v9BHCfTsZKOVioMe7aI4T54OYtDSStmC59bfwh0Eb2ghZPMuAUUH0R1zYy8+E5OGHs+c7oUAy3tepC8ifYintpozFlWLHttiyheaKzmfAHBGoSO+9oKkAtye+qL9m7uFZeS4reIsBHwRmnaAihqltjGmTZJ0EAdq+Has+x84rImua
 Unc0Zue5
 O3HsVkhipEPw0tETUXolGvXyIhupAWCe88x6MU9oFZfUgC2cwKCaq4sarhmD1fHSVrhk7IfwoQlElk5JqSQlxfwHBH7HJ1+de3QCqXA/HjIY1kQjhwaXKY7c/4xHJx5Kphq3ToLdxHkW3kYycvrSFkZWzG+drkmfsZBtUA6+aq9JVjU2MAr9JZ1OkDnmkkPsfI7NzKkd/kGIwvObuMtcbcIjjNA4OKMUfadU3Ou62nvIsoqZ93S/0Z1QZTDAfMspaEM5KCZ5YH3bUASoqkYGOwKaq9fvDOPsdHEcfKAjhbqXzIuTXPKoucNNHNoqMtlmQ+MmP/aa0GtvIGHITaNcxmMiIznmpZEbmgTqDTTLGreu+IM3z5kG3zKzlApatW6cV7XdmZG+AUwF/RuezvJ6v25IeP+1vrUHPPT3DFMX2BO/X0ZvPkurVb3isbSC351/UbWkrUtviPpnI88sYQiQV3lBEMjxjakxfs3cN8E7opGoNnK1C696CVzrxD2SiCDrAAVACsZeck2XGRd3iTLSqyvatdemlEeMfrUFsvj7d6vVxvdw+XtVwNm6jKs5yuF6KiFFoeWbzuIX/oTKU2aUmvicclJ+1Ey1N6NkAn4HwKuX4XVGBlvfQJwqmSKpix3w7+yFg8KEbLxuZEfbrNKk2bGLO+hHS+vLcBVZD7etFuz/1xuh2bL8NVliq9vjZ9xQSjSSo4LP01IgXoo50A6FmWE9JndTdR3W8TXnuj/wEe1WeIDLET9fb1hhIf+kDp769OHUzznMhlhqcbVrXO39KZss6jQvCXFOui5ELb24LY0moXSmFqf6ixxdy/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Fixing a silly issue that syzbot picked up, I reuse vma incorrectly, very easy
fix, fix-patch below.

(Vlastimil had a look at this off-list).

Cheers, Lorenzo

----8<----
From 87fc8e42946938688d637f694cd6e80552a26667 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Sat, 16 Aug 2025 08:37:41 +0100
Subject: [PATCH] mm/mremap: do not incorrectly reference invalid VMA in
 VM_WARN_ON_ONCE()

The VMA which is referenced here may have since been merged (which is the
entire point of the warning), and yet we still reference it.

Fix this by storing whether or not a multi move is permitted ahead of time
and have the VM_WARN_ON_ONCE() be predicated on this.

Reported-by: syzbot+4e221abf50259362f4f4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/689ff5f6.050a0220.e29e5.0030.GAE@google.com/
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

---
 mm/mremap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 18aa0b3b828f..33b642076205 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1837,6 +1837,7 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		unsigned long addr = max(vma->vm_start, start);
 		unsigned long len = min(end, vma->vm_end) - addr;
 		unsigned long offset, res_vma;
+		bool multi_allowed;

 		/* No gap permitted at the start of the range. */
 		if (!seen_vma && start < vma->vm_start)
@@ -1865,7 +1866,8 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		vrm->new_addr = target_addr + offset;
 		vrm->old_len = vrm->new_len = len;

-		if (!vma_multi_allowed(vma)) {
+		multi_allowed = vma_multi_allowed(vma);
+		if (!multi_allowed) {
 			/* This is not the first VMA, abort immediately. */
 			if (seen_vma)
 				return -EFAULT;
@@ -1881,8 +1883,7 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 			return res_vma;

 		if (!seen_vma) {
-			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
-					res_vma != new_addr);
+			VM_WARN_ON_ONCE(multi_allowed && res_vma != new_addr);
 			res = res_vma;
 		}

--
2.50.1

