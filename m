Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C83CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 20:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842A18E000B; Tue, 19 Aug 2025 16:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A1B8E0002; Tue, 19 Aug 2025 16:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB808E000B; Tue, 19 Aug 2025 16:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 532AC8E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:34:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A113140205
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:34:30 +0000 (UTC)
X-FDA: 83794659900.27.B0F1C75
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 374641C0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 20:34:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=juZf+13r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iVtD019z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755635667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4GrLahmKun9YkPBHEBcmqcV0flm4tNhovKUsLCg9pQ=;
	b=pR2lneGoF7NpLjkiO1huDua5uua9jtchxAwrPG8RbDWHsiJlBGMspigBYXyT2TAyuAlQk2
	4NyfvomTQNJw0IIndGwGUOL93M+Qxkprg2Lfp3gL4qhZh+DoKVceBVeyEt+o46zKdz+BUd
	XM5XZKT1gjIkW7+Hz4vuC4GW1a7/0L8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=juZf+13r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iVtD019z;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755635667; a=rsa-sha256;
	cv=pass;
	b=qXhmNQkRTh5eUBmf57uSruK0a3P8x7YzL+Eq1AR6eavay4Ae4FBidAp8veW09y30BPmzwx
	jDtzUSIis00zH9yxqhx1GMFwqtNgtWSjSaEEiA2mghboB3/IU6UlHdhVMl6AelrcGqpTGk
	hmMMrf/BPfVdAmg1aFd1dn3FR8DaYwo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JIC9fq020859;
	Tue, 19 Aug 2025 20:34:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l4GrLahmKun9YkPBHE
	BcmqcV0flm4tNhovKUsLCg9pQ=; b=juZf+13rTqwaLxXpxiZ9pZyh4xehBCFuvy
	5frxUmg9thI8c/zJd/nrj7twzM9pU5lXgUvgAI37Kh2Qdo7isiIF7RTaeTNKRKxf
	fCghZfMBE8V9hOtcknYq7CwZbkdBjVgrXWAkTeCYiW0ZdvBhB2ZvnaXzIZ4W6hPN
	72DzBFK7t6lHFlYIy9bNi8sT7Bo17Z5n/OuwjE4yPwjzOGFxowKOLptrvgrYUA0q
	N6UHbH9fY3av9Vg5i5blKOrFrdDkn1wxYL1jGQM/zzH3lfmrgDkLxYS6x5JkZ/uT
	m+0UYRIiK1FkYoddlB3QGXUEIerWGufZLdL6WipeQ4c/MMg08ptw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jgs5p96k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 20:34:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JJ3ued036646;
	Tue, 19 Aug 2025 20:34:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3n30b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 20:34:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALznDT6GHoAJ6PTxe9usI0vHTN9+8iAwFKur4e32KJbmz9HGXWT2PHNonXzcEfJJUc7YsNmz2DVUGYVW3vpK2Ir0S1AWlrhSPrv3bWPpN3ZzRBssgjdnXrNR+w/iBAo2LyIHQhNFbMOQ6TH9wAhzhglj7JkV8NyWe9c5jme+nW2EOUCqR3HT3zPqRqFapb15aL9SE8hRNMHBWNiWQx1aFuiTcuYgSaoXGMrvgV6BXVLoOY+9Vw9Ofonpl7Yo5TrVKe7BXgWIBERhH0+bCTPFPP+qqvd2vYQyTMXg/TLU1ZaunSoo8VfaZHcLLbaI2w8SWxiV3jsl0QKnU7t5sLrCAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4GrLahmKun9YkPBHEBcmqcV0flm4tNhovKUsLCg9pQ=;
 b=cqpOo9G0mo8sH/b0dWyTBlw236Jful0DTut2ljI+9gCefy/KW1KHSELIALK/tSFLjOddk4IO4/uXZnbh4wp+XO2vvFUQknjfBXGUQDjrxn8sKnAcekhVpVQncrgph16xOyWZFsgs0+u3WamGDXKG9hBIJFPVR6gCwRyVhxf6vp2qisiZm1X/TevKrP3j69I1v3Mf5sG4nwzU1UjNv1rqjcDZllypgNBqRMZWWzuPpNmBINGFLw1bN4ijIMmvQ1XbUHwuWAjF7SE4EpNM2m9PpNR6dlSDHD4piMNZcLFS3aNBux5I2IU8iGDhlCMUDqZdQUA06X5tloWWSCsXndC5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4GrLahmKun9YkPBHEBcmqcV0flm4tNhovKUsLCg9pQ=;
 b=iVtD019zuGH3YlcPeDtCbpjIBVQwES64+ZLjFt7LJJpGkYXbesrnswIF0lAsHhEojAV3/J2oLEP17U36K4C9ImpzsRkNoyF6G8qOUW0NJbqXhX5Mr4upsqXPkK26qPxrrjY7veKFs6TmQDTTwdzjhfjb3iYktKy0oWGObpNb9Qk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5714.namprd10.prod.outlook.com (2603:10b6:303:19b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Tue, 19 Aug
 2025 20:34:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Tue, 19 Aug 2025
 20:34:03 +0000
Date: Tue, 19 Aug 2025 21:33:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 6/6] mm: Change dup_mmap() recovery
Message-ID: <de385044-e9a2-45a1-b74f-68ba80bba146@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-7-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815191031.3769540-7-Liam.Howlett@oracle.com>
X-ClientProxiedBy: GV3PEPF00002BBA.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:6:0:14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: d812ea39-4b9f-4fb2-e40b-08dddf5fbc50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h9/PS+ORyabzhkRvnzkQ6i3BYJDEboT9axUJGekymdBgE+e+B67i+jwXzdwL?=
 =?us-ascii?Q?siA0FGWWKYZjQVJm0Blud5uEioVRVPOzc2hNilB5TgXso/RR10SUEsvF3syl?=
 =?us-ascii?Q?y/n8xPM5Cifu08a9q4MwdTTagVnm6CW74Bd7aPTlzLLL6d5Xz/6cMxiICROp?=
 =?us-ascii?Q?3JORc2kRUp/Fro2y3VH3qNsSi7BD+bklvMR8od94/P2F8y7H+0XoI0dopyLq?=
 =?us-ascii?Q?g5HCW4b9+TOfSPNZfQJcCjMMxnqHaa0hbBEPzV0ZC92XqCnmYyxnpLGry50r?=
 =?us-ascii?Q?LkSXfOjn62w/JGIeVaL6x4k18eBHxzCnUR8T8hwtmi75iCtjRveOihIpQ1gu?=
 =?us-ascii?Q?IxcFGQwVDTSajmQQKK+l2bU/jX8q/igJJTaMLZSctXnMO2AfSrEJZkmQfIh/?=
 =?us-ascii?Q?TtDTuRkAPFdZ4bB5uecaaK2CmUodfSaCmvbChXBg0LEtE9nJSlbQmdOLfpTV?=
 =?us-ascii?Q?e/lnF19fJuBwt2IVlN+eI9nFrhLpB//5MgyPJO7yJ8MBvutmwhKh7yVIQxYV?=
 =?us-ascii?Q?ISxNkz/0KhqAihhfs/E3j4sM8mDGSA7G3/SxljCoBc8dfcJNYmY0gXPArSVJ?=
 =?us-ascii?Q?3Gp+ArdLuP7mq0QHWNk6A7yY88yb86QoFHAU9J7wdfvvTkm0FlNIce8tXd0M?=
 =?us-ascii?Q?KFayznNeqauEnE3OEMEHc+fcxXtm0OhMbE8a7H7dCi0xB+LDis18KaHRuGuS?=
 =?us-ascii?Q?PDKLgFveKMVaQ9H/I8XouBHTBtonWqZcpQjcPfcJgJ/FAwxF8OtKNSKilB/p?=
 =?us-ascii?Q?9jMG6cr+z+KN2dRO/elcP1LxVg3bH8tysmLmWnaB6EUSZ5Kjil8ur8l54ja3?=
 =?us-ascii?Q?Yt4m397rzGwncO1C8an+SANDpByis9SCAP6Bn0L08zidXyRo9W3qgX4/r2md?=
 =?us-ascii?Q?rB9NLVGmY72Y/Cga0+7tLv5po6SURbvZNgYnzgq4ym8zaUqv0+3LGvli8Ktn?=
 =?us-ascii?Q?Ghpfczq0rbeUOOM0g+H+oYzdmzieryxzMsns6YPaaRBsAK8z5xOqZNj09O2g?=
 =?us-ascii?Q?IhQXg37l/oJYcWBCJ9PpdA/eeBKCY11tjq/CCamWCHmcWtCxFkcbYYyMPZfK?=
 =?us-ascii?Q?IFkxxLPjq86Ub9L4hgAmqp3nnQSXTyvQlsgMTvE4cRhfheUhkgMHZjLkAdF/?=
 =?us-ascii?Q?HC6TuLtdw2s3R6LQlqdITsTUxxnZGlkbqMI/YfSCd6iB7wJe0pVa8v8WcbOU?=
 =?us-ascii?Q?T46LlewDL5JkhPUJlu074dVwMrpYlgmMxUmgJROlTvSRR0GPdI55OTXdiWcH?=
 =?us-ascii?Q?cl7rcc62b/OX9CZ/gVn2Bb68fd+88cFcs95RzmcSRvDfjaN7nhySw9LpHiPh?=
 =?us-ascii?Q?u1yzSa8mnEXwvU8N6hmuc6GnTcjAMaiewrUx4nhAW8LN/TvUT7gWvV2/xqmQ?=
 =?us-ascii?Q?5SxRgQtbcwp6SCuWFiwqfJhOgKDWdCMJiaiUSKrp1BGwO7DIsF0ePX3kvSMk?=
 =?us-ascii?Q?3L0WJZZBS+4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gsbUN4XYtNhqbOV3dMoG4Vxj/2yRjcqAeazFKd+WSM3WTLRrSsKV5K0N3Nv9?=
 =?us-ascii?Q?sVurgd1LzBz2T29dYVLvNd7/kLeLIlMOCUSog/KvU+8QoAVCGmnH/o+C5AWZ?=
 =?us-ascii?Q?/yjttKzbfPmZHEBug0YyOZOsl+cU2JE0lEd2Ogjz5zpnUOhVYOdDlHGzanXQ?=
 =?us-ascii?Q?ocDXYXQYfPYJP+BkS6pAXgYievIAHNGYhOqJmfCrJnIbUopAvLlRouCFw5s8?=
 =?us-ascii?Q?Azh+HDn4VudNI1LCtW5ERuWwG0JnWLyQms3q2dFXZHiOYXHAcxwuKtp3v7ZM?=
 =?us-ascii?Q?sVMK89WBiI6d+DneoSKErQBHITlwdIEeE6yHUKtVxVcEZCWHytunTqTJcntz?=
 =?us-ascii?Q?dDwMBfiteVxnh52wedrmGiDg/22ZX/4OA+WgRCpY+LouneiRQNRL8S9v2c1m?=
 =?us-ascii?Q?xz1zEkVnETit+hAs3c3SRHrDtURmRyZJUAZ/Jq3uWCJnSUbsjY3Kme4kUbhz?=
 =?us-ascii?Q?yTyMAzlu2iNmS7WWJ5JXfXfOQZ5DGCWT8072oJ7RCG0E/Tseg5utMOv9U6Iw?=
 =?us-ascii?Q?YHuvYMlRwR2JuSeyX5mKdA0hFKJ6v4RJh/T4hZjxLyFT2ZI3DQb1qbrQ+IcE?=
 =?us-ascii?Q?MUrCTCoAonOyyj6ZslmF55CeEIfGh1WvIiCJTgw54CZwBirH4DNNFavWCD8F?=
 =?us-ascii?Q?guWDOv8vJIAcJ3f7XAtL1lh4Nqo2K5gYaRXRd1wSYvWeqjhsJZUU3ra18HrK?=
 =?us-ascii?Q?6/QAi6hx1VKnrl7fADlW9AXdyYJXV6AAWPJzZjRqy2t9LzwT8A9mzr2LF0J4?=
 =?us-ascii?Q?/qsKpcGpIuo4SaqF3yTdLU4dFkPpvwMkIODJH9xR9i8PqpF73e7fIHp0gYn4?=
 =?us-ascii?Q?S1UdiualDJqV/BKHmwV4eYJprvMrlWbrh7RFzJ6YFhKf1jOBk8MOvU2aRGjC?=
 =?us-ascii?Q?crtgmA6Ua0okWB7t8cQhsayGcr0nnNr76mfcQxeLsuoZomUEKBJzvY838Bs3?=
 =?us-ascii?Q?IK/UBnoDJwxv3EmEYt2xBlHkecgiv04LK5ihrRjuqFcEDcZvbSaVX2QuagBo?=
 =?us-ascii?Q?JWlSWJ3QobfytIqA941azWZ4ZKM8QTxJyTJHZgBztgDeEgSKRGP3NahgvQpS?=
 =?us-ascii?Q?mStE/CO3kCL2tYosPxI2ooTRdXv31GlrJiWDcn5VVJBMEuAz44YdNqIdtRgX?=
 =?us-ascii?Q?Aqj6WreDH93CN5Kxt/lZYZIgcUTPq4ZY3EAWVsEL2He8XPYj3KsxbvUYT7mr?=
 =?us-ascii?Q?DwO/AHWNpSOc/LRcScTx2C+poegNJss0Xpv/jdGwZoyvMtlvFblLhDhbHa77?=
 =?us-ascii?Q?QTdpnDi8Pg838jnGmBonm0Vj6XCYQup0A4Ngn42mQ3ldqP48LubqojGJdI9U?=
 =?us-ascii?Q?/cGJSjBdV8r/rxVY8IYO5IJ6A6kA78q+hjMmmgJ6IzIrSoxyhLoJmTxo+ok7?=
 =?us-ascii?Q?wfKrqAXWpljendTWLUw9a9mSQnl5KfkpiH6SRZKsuB/nl3OFzYlL2VYCSHl9?=
 =?us-ascii?Q?wyk4koim0QVFrLHCZiwAl5zJS+hH1fAkW6prl2OFRHodLXVGJ8nhOzEf9uUo?=
 =?us-ascii?Q?Jd0C+1wMe8FxGvxk2ScRGkoSZ1AUq8MdjyUNq4xd+FKxONm57McJsqpY8XNH?=
 =?us-ascii?Q?dOw7Rw85mkgIwW70UxiWHDh91TKkLwBoXSLVOddjNn63S0ktSyO8dRVH8VRF?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vjRQsTPrn+NyAy3HO9CYgvzphkohPQb4YIukzUJY0aHnIPESluvla5AoA2IWre5x+bbE6ub/IKQatG2E2QP+0qGN1eEcJNejAhFeJu2n0dGG5A3WXofwQAX11PaLN0NYxj8iciGgjBCjrKcUHhSfxrApXK7Q+TBfBVYAP5E5Z9zEP4ttaNSKG8GWAjVuGFI2ufHWSz9y7slW7NGDWe15jv4apJIjA1Wz9xu0iez7HFTNKcuesN47Z9DLQUYtQB6hOfxxOxbms+evF20G+XZ4faboH6pgxtcBng8nCOMoAIbYF5KPHbNpAlFqS7rE9uwijhzsBNbv0izKC3kgf4ctBmV8oqM78LlsZPOLL41Hap3nZPxrQ584nolmG0M052ijyA9RO9yMF+m/aGom0VNI3xdbX2qWoMse27OxNwBLfwRRXnBxT8Rjc3UWDgxgGXfTls8bvm9/cCrrrGLhEjNwrFx2rU6KoOEVNOw5sr4tnEmff5f8W56ZlTdzIJtKwm5chCi0FRyBLvxvLKeHQjuAQ5TZmf7PU5PtODjqkE3kEoRg0jFPbbDjg0ryK1Z1aa73937jQSxglRvslX2wa8Hmp4QBJODp/fjEHAhpVhn05t4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d812ea39-4b9f-4fb2-e40b-08dddf5fbc50
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 20:34:03.2880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCvp9qzA39/IkmFX2TtWSlC3sin91VI21caKCKtZQJr1oN3fVwUy3SASL66ViLxrKGYZJXurXiblMqLU0fbRgq4DVtWhn+0n5sczl8Z+L94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508190191
X-Authority-Analysis: v=2.4 cv=DLiP4zNb c=1 sm=1 tr=0 ts=68a4dfc0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=XcDxuxpSIFaeCmsN4e0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5MCBTYWx0ZWRfX7Qy7FzZeShLI
 2KVMIB3vlec50p/ji/9R96L8VTTI3EDx+dHHKB8NTgSpJFfv+A4plSBH9R4LfQB7XcEaDLB6kl5
 Dj6g2CSq/ARscAQDkXMbKtRWV3AhS+l+pmJexfFJCvVKEhr1pRn3/Y3TL0y+97XOB/VaJ6C/M6J
 a/LBUgouFjjU6HKEzKga5vodEXPUzU8kyt7Fd4iS+yZRHIlLqPFSB5t+3KUliuvzoM6/p+P0RIN
 CR3a6g4Ym3562lWAGUfO6jrF1dGGxlOsSuQInP3n7ECvN2ep4DazIsveOZ8IVzkv3SS854qgdou
 QGN+1b0oubHZexvvdgHdLBdc4hHwYovkT9/2z7CokyGHkye4bRKfKTI+dADPsuGyaVgw9zzpkm9
 KmDPWFmUJ2FweKmpbjbO1BiCrxX/RfukFzH+32UJvHSlamN+slVeDH/EsmetDJsmZbPTTDwz
X-Proofpoint-ORIG-GUID: Oo5e3yyeolJd8wrC1r75o6gTIssD79sf
X-Proofpoint-GUID: Oo5e3yyeolJd8wrC1r75o6gTIssD79sf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 374641C0002
X-Stat-Signature: 9phetshu5w9wn73fhj3nnt7n88fufayy
X-Rspam-User: 
X-HE-Tag: 1755635667-282549
X-HE-Meta: U2FsdGVkX19Hjfeg8qYg5iFrAxp/sS2VQqmIg96vQYIinerWWnbTYj7WMOtpe+rMAAo7HfF2jieZzlMnTVFk7PMwDgMaJYhcushJ0JCOE7g+qg85a/3S8cgsOFK8a5Bb75qXEApaNo5nftSt3v9Tq3VfOgQqwivrqNPGmSrfaonoSAczlkhZcj6MwF411UjnPS6168B80Z0IOkLjaDnJZyhDuC1ITX17dEgyQ/PzoTlwhhJKncEaGmlusMzJPLuAKolIDcyMMjiLfG+2LpjA5emdsAcQ7/21cSfJE5y2YtQ2O8pRtrUyjbvkoJ4wpj8ncBk4ntYuYUluEWKhelA+i0C3CRzdd/9f47s/nlNFD8FdFQhv+n4XaPvy3BRWlgdVLoLJp+sp3WA9OyvEHqDosY2glLz+F4bRWn7FACkCj83MyqFSPTUVyOe0G2+tXoK1MCn5/YOE3Ov2Tmkgl6StOmII6uccNTI01lqmFOEb7R377jzfiiK9a4f8lZVdWSa68P0g+Ze+D5jGLS4i/kFAGmNULEb6TlY9SquMdhhq6Fve6fqT3xIm5s3m2Me6RMI/Tgi8blRkZ5x/L3E3fMMhQ7AMCJRJhGoFb8qx8g8ZrmRGz7d5hs5bJsOd8UP64Pjd+W+GBkWAizImMD86OpK/YU+vdOmmE3mKERtt/1WkHepbZMyyZQ1se0++OTtf+hqCYqCO/Xl6P1+/kbbv7flJ9CuYPs20PjTJVol/udOXZ2XC5pYEXKzWmHJYhlcn1kVjOkwkkkDr5AF2zJDfhVXRm/gIiYviJLGFxMPLSursPhirChQ+A0ayX4spSMx8yHjUzTtiXFhUZBDn1/0+7uZKIXmhI+ggV3wDa2DERrET8i7ZLQLyBnKI04W7Uo64riugTxge8y47OkkTl4BBAHG/yvHK3QZNIAa6PHs4dFaPpXk9KZ66TRBPXGBxicJR9CtqacVh6lO++C+VAMX8+Cq
 g4hLuuaH
 3MKw2o87/ZrNI+CaZflQbCWCZ0oFq7w6CWkSqHcr/aDObGlH/FoOaCZEcZmGbCkYa564/HrtuHVz3cw4rO48BcylY81uNbdIFdeOFIu693btG9x6g+cKEV9TZbl3M6r3qR0dnJLe187EuJKCVn0VuAU8DDQ5MaGxImHVYhYRlLSrkLJ5nFJxKhBQ6mKeClqv1Jw0YBefGPcjwlUw/rjSEFjxRnCVNivv7EtEqDHzh00y05dgCca6mefn01ORfQmvHviaazmBZThFZbQfW2SuKshcA6dtN9pbty/lDog4IsyXY5O8CRIxijDGy6nopy4Ontnl79GNEYcmaAdSKXVa04Ug0hh4CnMl4WkQzri6QqpppAIVx1M1H4pgvkYFy2qTacLu6K71VIVl28zFqHiZ7sum82CI/SCKQXcK3lQpcyQw0UnLgxQYUNppVtI9EueftGqsS2c0XUit4w/DAIW5GaY90h6dO6tDD5VnEjXiZsKyNh3ziREJxF5wwIxZKkiNlap04XJz1uqbNb2kZZnHV8/R9joiCPHhnY1Viy96DlmbdGBmMJRDT6A/edcaBnjOsq4zR6U6G9VUDIxbhgCvA28x5JAt6bEeTx1CsqdF8aj00flCHps9fwLG16YDNoKgVroYnc8sjUogvwKpl7HGapRqxMXeIWfvjB6cp1r1ZOL416PL/uv4ajE7xNRBguP1MRYjSAcbOTYICabmdnONUd1rLEA52TZJpjLBCFUGI58Wmue4dG0QialwbJA08H02Nc5Xh92k7qKzUkrkgzW7JoIcBP++qaNKNSsdg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:10:31PM -0400, Liam R. Howlett wrote:
> When the dup_mmap() fails during the vma duplication or setup, don't
> write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> free the new resources, leaving an empty vma tree.

Yesss like it!

>
> Using XA_ZERO introduced races where the vma could be found between
> dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> race can occur because the mm can be reached through the other trees
> via successfully copied vmas and other methods such as the swapoff code.

Yeah god.

>
> XA_ZERO was marking the location to stop vma removal and pagetable
> freeing.  The newly created arguments to the unmap_vmas() and
> free_pgtables() serve this function.

Nice.

>
> Replacing the XA_ZERO entry use with the new argument list also means
> the checks for xa_is_zero() are no longer necessary so these are also
> removed.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Ah finally the 'action' patch :)

Obviously my review is on the basis that you fixup the rebase etc.

This broadly looks right but some various nits etc. below and will have
another look through on new revision - this whole area is pretty crazy!

> ---
>  mm/memory.c |  6 +-----
>  mm/mmap.c   | 39 ++++++++++++++++++++++++++++-----------
>  2 files changed, 29 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 3346514562bba..8cd58f171bae4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -387,8 +387,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * be 0.  This will underflow and is okay.
>  		 */
>  		next = mas_find(mas, tree_max - 1);
> -		if (unlikely(xa_is_zero(next)))
> -			next = NULL;
>
>  		/*
>  		 * Hide vma from rmap and truncate_pagecache before freeing
> @@ -407,8 +405,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
>  			next = mas_find(mas, tree_max - 1);
> -			if (unlikely(xa_is_zero(next)))
> -				next = NULL;
>  			if (mm_wr_locked)
>  				vma_start_write(vma);
>  			unlink_anon_vmas(vma);
> @@ -1978,7 +1974,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  				 mm_wr_locked);
>  		hugetlb_zap_end(vma, &details);
>  		vma = mas_find(mas, tree_end - 1);
> -	} while (vma && likely(!xa_is_zero(vma)));
> +	} while (vma);
>  	mmu_notifier_invalidate_range_end(&range);
>  }
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index eba2bc81bc749..5acc0b5f8c14a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
>  	arch_exit_mmap(mm);
>
>  	vma = vma_next(&vmi);
> -	if (!vma || unlikely(xa_is_zero(vma))) {
> +	if (!vma) {
>  		/* Can happen if dup_mmap() received an OOM */
>  		mmap_read_unlock(mm);
>  		mmap_write_lock(mm);
> @@ -1858,20 +1858,37 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  		ksm_fork(mm, oldmm);
>  		khugepaged_fork(mm, oldmm);
>  	} else {
> +		unsigned long max;
>
>  		/*
> -		 * The entire maple tree has already been duplicated. If the
> -		 * mmap duplication fails, mark the failure point with
> -		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> -		 * stop releasing VMAs that have not been duplicated after this
> -		 * point.
> +		 * The entire maple tree has already been duplicated, but
> +		 * replacing the vmas failed at mpnt (which could be NULL if
> +		 * all were allocated but the last vma was not fully set up. Use

Missing ')'.

> +		 * the start address of the failure point to clean up the half
> +		 * initialized tree.

NIT: Is 'half' correct? Maybe 'partially'?

>  		 */
> -		if (mpnt) {
> -			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> -			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> -			/* Avoid OOM iterating a broken tree */
> -			set_bit(MMF_OOM_SKIP, &mm->flags);
> +		if (!mm->map_count) {
> +			/* zero vmas were written to the new tree. */
> +			max = 0;

OK I guess this then will result in the intentional underflow thing, maybe
worth mentioning?

> +		} else if (mpnt) {
> +			/* mid-tree failure */

Partial?

> +			max = mpnt->vm_start;
> +		} else {
> +			/* All vmas were written to the new tree */
> +			max = ULONG_MAX;
>  		}
> +
> +		/* Hide mm from oom killer because the memory is being freed */
> +		set_bit(MMF_OOM_SKIP, &mm->flags);

Obv. update to mm_flags_set(MMF_OOM_SKIP, mm);

> +		if (max) {
> +			vma_iter_set(&vmi, 0);
> +			tmp = vma_next(&vmi);
> +			flush_cache_mm(mm);
> +			unmap_region(&vmi.mas, tmp, 0, max, max, NULL, NULL);

(An aside for the unmap_region() impl, maybe let's name the pg_max as
tree_max to make it consistent across both?)

Hm we could still use the mmap struct here if we put in vma.h. Just have to
set vmi, obv prev, next NULL.

So:

	struct mmap_state map {
		.vmi = &vmi,
	}

	unmap_region(&map, tmp, 0, max, max);

Possibly overkill and hopefully stack ok but makes other callers less
horrid.

Maybe also good to add a comment spelling out what each of these params do.


> +			charge = tear_down_vmas(mm, &vmi, tmp, max);
> +			vm_unacct_memory(charge);
> +		}
> +		__mt_destroy(&mm->mm_mt);
>  		/*
>  		 * The mm_struct is going to exit, but the locks will be dropped
>  		 * first.  Set the mm_struct as unstable is advisable as it is
> --
> 2.47.2
>

