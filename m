Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CAC7CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB7E8E004B; Thu, 21 Aug 2025 08:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2FC8E003D; Thu, 21 Aug 2025 08:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AC78E004B; Thu, 21 Aug 2025 08:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 928038E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:06:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BFCF1A03A9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:06:36 +0000 (UTC)
X-FDA: 83800637592.27.7D9F557
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id B0299180010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:06:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dTk3LNY6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nWeizl9p;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755777992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNAQMR3uGnWbNV/nsmK2QPybnBJbbMQxR0ynQy/0t9s=;
	b=wtDQjtG4rIA9xxLa6Nzvmy2W2SC3gvSqoqIyNfEzLrgZmdZStFKjG7gxqAPof+sJs8756t
	gNIdbh+U9vLWoWOPpJqtDcE46w2pBInDQ55fk4nUU3VG0lobYJVZ7LHZdyla7TlcOUOhXL
	0959Gt1UlYHVLTjXm2QNfoITMzIgV/o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dTk3LNY6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nWeizl9p;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755777992; a=rsa-sha256;
	cv=pass;
	b=hW5RSHmOP2WzLGPiBkoNwAQhO+z4fsNrfUp7ESbLct9xZeGNTk99V4//K2AMy526p8uJ+V
	FBpvwBImn1Y3ewjjMOBOltsvU/MtJhteq8BAWAaSrVS0vjrc2+MSISMzevSU5vKS926zwT
	QJtkSbQZuQ1aedY8x/+WVg0qGuEXkpc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LBfXw6018513;
	Thu, 21 Aug 2025 12:05:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sNAQMR3uGnWbNV/nsm
	K2QPybnBJbbMQxR0ynQy/0t9s=; b=dTk3LNY6Aq9tDoFrUALThGeIrhbqhZnOYY
	PXwsD8eb15CSHuyZ6NT2TGiGyNUunWtIp74JwpVsKhxT64h68OhzwR/Ar0AVNiuE
	AerS1hwpOFVQonaOUN2Pz3JuABoF9BrJVE+aSyTCtfwl9MPYnKi0xS904hnNY+Iy
	JP7ho5yB/2X0i2BdUvsKPU6Z732nMEmf0EaBWgxw8h+W/krqkK5Qei2AVE2BlqS0
	0cD2xX97tilyaszMFBh7bdJXeuk0EJWf24jp8DAGadkJMyPuawNZeUkehezqk5r6
	yOsn91RfglqIBDHfmWXefn7lD6dUzFVIUuOdDNe/i9JBT2C7yzOQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr39k7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 12:05:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LB0IuT030239;
	Thu, 21 Aug 2025 12:05:48 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3v9nx3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 12:05:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vvoVxhQcem6wyma2/6sxfLFyDapKkdmjY3Br8Pld+SIWufgcVXqqyBQ2CyvKjJnCxLVgRZQROWEkMm9pkcN33wwK5tlRxuQkRArBQBATJ6PldP6UcRNMi0MWYU07P7Z/09D5VRiTpZYcPdSlcGkvJQMh5wR/W+7/KYlL0OHphSHovj6hPND2+GK5CaHjRnXLpYPpRKgGki1iYvDBidm3nHwq6wxZzkWmkBiEQBjnEQcfSVHySROuCLIcU/dqBftHFLjvewugJsqWYzXq1RqDBilWr8vKS1BB79eP9GBqjsfLg87+ETPZTx8eJpOQzc1DruQa793eycdeqBfrEJaJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNAQMR3uGnWbNV/nsmK2QPybnBJbbMQxR0ynQy/0t9s=;
 b=GMQrQg8hlLwrcrqZ8q3LLSD5DvAKuoYcewASQASJQ7ErQij1fTSA9/qs/a8cp/6IUmizbNdRYBOmdUAaqxvz2ZuasgYXoV0b7zDlnAH9hFNctfuSfFjxnb94P/wZTbZ3oWEyYSNErBbuM3Rlbmmskq3l1cKQ7N+s67fpUEP28fKeDkkGbEqslD66KEA6BvnP+EpHjFpydnnkEyoyXx4GKWuNOrLn9y0lSp99SYfiDQuf6TebqlSws0BRuzpWFAFU0RcaRCJtSC7IfSCVhP9eFl/TVr0nq4nJqFnOe/MHFMjjrZFM6aofufFM+q2bSszO5u3/NZX8xdnje0SljyCP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNAQMR3uGnWbNV/nsmK2QPybnBJbbMQxR0ynQy/0t9s=;
 b=nWeizl9pAfAMFScJvyBA+wCka5AnapOUgb+DH+YM4XaBLPCtbAoIV3NStZ6xIFaWCZv9KyaV9egAht99lDInU/UPemZqp3yYE8wVP/5+4lPjG1SM6KKDyoD3PxbQ0YBzwIxCF5lBLJrejHwjYkL/yLj+d3YdQxHBFSsI4brcwIw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4562.namprd10.prod.outlook.com (2603:10b6:303:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 12:05:44 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 12:05:44 +0000
Date: Thu, 21 Aug 2025 13:05:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 07/13] khugepaged: skip collapsing mTHP to smaller
 orders
Message-ID: <b6ebe641-0a0b-40b2-a34b-07393f883985@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-8-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-8-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0014.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4562:EE_
X-MS-Office365-Filtering-Correlation-Id: bb75c59e-f697-4ba1-3e19-08dde0ab0eb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hkkRrouedwyK5OkYVvLYeOLs5y73s/28Qw62pgw9x/tYnAZzLF60TyEzoXkb?=
 =?us-ascii?Q?5K2dJwU+nIgYZKPmzqs4daKoFBLGGT/g8Q0vh3GvSSazKO2VEmppw/42ALuL?=
 =?us-ascii?Q?eK/yytMQ3T92RyM4q38Z+ksOnMSmTkLOiwpu/zUCjQd21zFOmQ/L2sJ6pDmn?=
 =?us-ascii?Q?SBTBaTZjaEW7Y2fHLEv98IjjqLOFvgySfp/QlfnwH9A5yNiFjncyONw9lWgW?=
 =?us-ascii?Q?dYD5+VWg4QKFIQQc8tz/O9VdHDK+5Kj0zFMEDPtkp5z2o/2AZF9oophOConm?=
 =?us-ascii?Q?7akT74R02iv4OIqdGiQygsjOQ+dBVKDdErfhzGjHlWVCzsraTPeZ983Su4R9?=
 =?us-ascii?Q?/5275auoYV7GfgWaMi1Mvl7QP1B3bvi5vCLWI+D+M5VvmxMiivc0E2xJ6qKP?=
 =?us-ascii?Q?CfbfOn6/S3ny3jTU7e5nQY6/1lmBY+hcWSoFF9VZ8xBmlrAhSKUDV+dh7RFC?=
 =?us-ascii?Q?68pLpV1gCfL6R3jv0YJqxzGRXcKeCRDKBNHtMH2jMc71QWqQyqyRo/yfYJjY?=
 =?us-ascii?Q?i4kqtraM30tBaU2axDjxDQ3Ik91P2X25EoK0KMhy2Mpde/VyOr3ZkAx5wEEy?=
 =?us-ascii?Q?paF6xf9YnL+P16xgVdtNsPwKoO4euOhD2gYDp35H12AlW0/+Gp6Ny2KI60N/?=
 =?us-ascii?Q?YrEv5/hpNcJAnKkm0GrlhKu8cojfDzOQ5KlabJh65hSIJpFc9jreh4gKFL5V?=
 =?us-ascii?Q?+8tJVBaOknk2uNN7k5WueC2tzOeqbqmcp9jTp1hYAnX35jdSIBT/vaLieUHP?=
 =?us-ascii?Q?guUYpNrb9AnNx1IOzuGELEkCLR4hACCBpioJDSzT8dAl2RtzIdjkNO01lO1A?=
 =?us-ascii?Q?dG2B2gijyff4fufeI2AKGfaFGypr+5tOOUNw31M0IvlCl6hyKH99cvYxFB8q?=
 =?us-ascii?Q?5+XIxfDSvAsaz9tRnLUMIK8wvNV4TTWJqCo624nRkQmsK5/lj9bdHIM9Ccng?=
 =?us-ascii?Q?UJ2J7JL/Pu+AvvWtcDC+v8Hx/q2nwhRBr9la2JJY6rTZnNyLS/iVFpqHQPst?=
 =?us-ascii?Q?MXaaeGEvncK16xof7mN5q2Dt05gS3TrkgIKf8FgPqHe+47nEeInCYIMbKaSC?=
 =?us-ascii?Q?yo+Tzz39xxE2Vhpo4fEqhB6dx11owdtJu5IJoG0Ec5q/966VFI1jT2LxlYrW?=
 =?us-ascii?Q?k0MT0qMFUssZTaQvdDMF7AHSW5n5qJrhWPo5/B+m8BoyITTcPzTBCtiqjiot?=
 =?us-ascii?Q?SIZiA0eJoaJjJAEcH4zkVARebtuKYMDdU8wIP8E712+Dmj98ikk1lFHIHYoj?=
 =?us-ascii?Q?exOK6KpYJ5uJ8j5o2HiWNPT7s8twiTd2lNsHNRVXrH7kNu8hAg8+fQCabgrd?=
 =?us-ascii?Q?pLOPRHVCgJlTmvRdmAXFfkqqnSrU8V0vzL4utgnOvV+Z1Fmi3UsqaLw5BtHo?=
 =?us-ascii?Q?moYJYo7C4kx5aPnrxzeuZsqWGLDD2tNYpQXMKHD1xEndlp+pbWTxXUvNgBIh?=
 =?us-ascii?Q?PoBccMbocoY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dxxOVSvSC2xQoCgHhoQppzFM0JbEfEmVs95VXjCln4LlPuY2IgA6wnW6q85a?=
 =?us-ascii?Q?PkSRFlqaFzx9HDwvpmjzUjNgm1AXINCGYhz0U2oFDLGsJgwTPjAMyFYn9PH4?=
 =?us-ascii?Q?Hx6SeSDVpbazrit2qnRzFAA+E908BF6xS/4cLU8VfAvyehkF3magD/f2Kvlz?=
 =?us-ascii?Q?D6+JPuGRlH+NqKnJRBHytPuoE9mzyXyLMu5vRO6V5C0Kwuv7KXcEaM31Ujj3?=
 =?us-ascii?Q?n9P22tt8OYjQp0yCmUh7f+cb/6iWwit7g/uwCsHiqZxvzzEYiqbxQ9sW0tIP?=
 =?us-ascii?Q?4ghueAEjTVczuTxylVLR1MmlRXXSBKLt0Qc8asDZyLAwmCrz4BsIgP/LvwD9?=
 =?us-ascii?Q?pfarknDdUwa9vFqB7IAHobhVAkFu8Cgqy8NlENgtfdK69NBrTJu8SZVjJkOi?=
 =?us-ascii?Q?i7CgwXmoYro12sB+Sk44rsubWl8hrae33EGg8ETgoV0/LTUqLXr7bQSGrMAf?=
 =?us-ascii?Q?Ru8cCNTBMmh2lMYMNRqO0YWsQ5Wi1z5elZW07YymiDuyKRp96Xz4BKgC9F3U?=
 =?us-ascii?Q?3uo8p/0KQLt1RlzCxP/O5p0893M4S4FpXrmPbPn9C6QPfpL18EC5rn0Ko2Zk?=
 =?us-ascii?Q?0r0sol13R7+CPdTWUMQ1f3OgKY0GShJUzpsH9dCq6Q0fkG9vQq506Ta9/+wa?=
 =?us-ascii?Q?0UjJUzGuA67k4nK3LbmaWPX4g5+SxqfawVmxCIOMKRRK4mYD9FWVErioSU1J?=
 =?us-ascii?Q?Rc6VLYDVHYbAiIofkgsxo7tz5Q+zSwqhQNLFJfY2Ejg6YR7l5gOrT5YimfXM?=
 =?us-ascii?Q?zAle5LHIa4UplxhfceCi3tVeQBCimUf6VNGAfBI8MNejxAqz006PStGxHcES?=
 =?us-ascii?Q?YWfsML1gxv56nXwpV9lAPbm3NZVhJZ+8ISbtPrBLtOe6KQ7sv1Uk6YPgbGoe?=
 =?us-ascii?Q?IWp9xRK6r7Tv4JKVNhjBYypOcnB3VBy6cLa4XVEMNJ/kSAtSPnzjPi/AzBSO?=
 =?us-ascii?Q?W6kw0DMEDDc38bui33a7Gs8wJUrY7TpjrLV3ZxbLe4wQYrJsKMk+h+a2owm1?=
 =?us-ascii?Q?sk4RFdb09Rl05V/qYueELqiPya2WJEBEkbFKFtLOtKPrdjvbPkUnOEQPqE60?=
 =?us-ascii?Q?zZ8AVpuu+AuM644Z9RxbSzXp3RnXfhPFGQXC5A3hiqRRv3cXcMsWTRarwQ/i?=
 =?us-ascii?Q?cx8gnHEiSHWBvRFvf+PSq4QNaS0QnwMeiuxaktjEtllg4iny2cG0vNhSYcpX?=
 =?us-ascii?Q?7SmSnJTr+LJBO2Asp17byw24E23a7MoRFX/YDnn8jbu7PGeKAyG2IcAH5GAZ?=
 =?us-ascii?Q?yo/vVqZ9CY7haKXODl/b4ImSTsDGZZLfh3oqhBz4UD/iIOWiA6c0SXQ07Oyn?=
 =?us-ascii?Q?toeZ5rSHgZ3vQwbkMfEJESZ0Ft9E0LjkWKRCj5u0iREbL3E1z74m6sSCY4nm?=
 =?us-ascii?Q?IMcyhd6VGet2DZ42miFWhD9RxYgcJM5NPEYjUwvUhVZ5F1GLX2wbAvsO2Ozl?=
 =?us-ascii?Q?q5myU63iGkMFaapTkwhmCV6nxneCv5be3la/9pOTNnEdRU/5s4L3jbE/DDD5?=
 =?us-ascii?Q?eonl+vxdP7MUl/yXEZl4Qw0/r2wZI+eH3L3d9NtBVh4gGiX9LmdUjH+VhlZd?=
 =?us-ascii?Q?f2M2V1fIXVnG1UJGAJrpp0AiY8zyBrcS+qPRECOvrenSPTIEgHVR66aXd1rR?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6fIVtWorZMYOYxUlQPPk5Sx1d789X+c9+HrDjWTQZfjqFxg2VvKflYXzoHtb7Ov3zv12TPTUnM/pKlVnoXpCo+Zf2xRz9PlGQ/XylW0ghpxRIi7NiECIvJXOceZK3sea6Hs5sEOsBdZiEwdLVZtccmULXI7ucGPEl9NvKVPKu+PvW0mzvGRTsafixFv0Sv4Lg4Q8pIL6gieVwFGgilOSmFinn88zSAeCUEKGxgUr7ki0MTxgFatJC0wScwtFlowxnKe7jm/16GGdoeVE4DMjxOMFWJb/GPWEXyKmaP4RmZy/HoKv+um72OxzMLiHr103JRlDvj0lclzMXA3m8Cn8ffUFWtdqGis/kZHapVVUNCDE+U6Ujb30aIvqu8dY6Waekqj4skOCbCwxHjfbpJOslj/HlovO4StKU3RJn4QXdTQxrHopF5BVk9tHQxcd1omhOm9INGCnI/OyEGtcWXaludvzcwW4JI1Vp6XB3c/yIC51WbRmZgBAr/yRnCNB/ZP+c7O11vZkWBXeMG68QqRYXp012+ymW9ii4zJsQ2hLzi9/kaMjJp2vYL+gimZ1NsrNjildvCVNvFcT95WRMMGNjIsLZgp1S9w6qXIZbghIKDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb75c59e-f697-4ba1-3e19-08dde0ab0eb1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 12:05:44.7671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 43PY5iIlDrFfCOCRrX7pzDYohA3J65BdHrN5+6c8AN4v3NB3M6VzdlwtSGNFNgEc/pRq6olcyeubY/ATpbRyHd5G8pKasv9tdbN77+jHm/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210096
X-Proofpoint-GUID: 6x67j_PuY8uo00kKK-MLJ-nRngqouZWo
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a70b9d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=Uente50hndm2D6paeE8A:9
 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: 6x67j_PuY8uo00kKK-MLJ-nRngqouZWo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX1yq1B9n/ofn3
 PJQNedrkrDp0eryy8ZAwQT0o1vqJdJ95WJWf2c68ak/qlGCPIvhP9+Mda8IQ3P/f5uw6dJ5Fz67
 c90M8m8AelKT6Fx3yqVnhYxtgNLK88Oak7xZPNxvQpC3WxXyR8Gt0e0nfpl4Mb9y3J2xpw7wsb9
 9Ynsb51x7IlcBH/oaLw0Rm5G8LxMsp2hUnzDtbBmMYmUMAJW7NQbRh2zkvPlUqHj7d7kt34dHgo
 o1hpMhSKYue5L4vysPUtfK/43Kbfg0mpKgGwRcmYzjCDF7JFWwoiUFgssxDHnZd48YbPWXDQW56
 nyyjGxVByY50qeJKgyt6aI3/Owcqd5PSXp6FNj9aGMZ1uRcJHwC+MpcdwoPxhhmj12bX/3KaBwQ
 Yg+R6rSIPgKox4+lbhAzSnpgghDUu9GTFjI2Qz7prykrUVOf1FM=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B0299180010
X-Stat-Signature: qmcrwtzsj54x8dgo8cyeu7jozetp4jxz
X-Rspam-User: 
X-HE-Tag: 1755777992-494684
X-HE-Meta: U2FsdGVkX1/qf1wFPFfNIX8HYvGcSOtLFrhPyQmo4GUkCUI7xcH+PaRhm3yN0sM6EwOIgV4XvJLKiW2sOECIBIVSMO4sTDQG0cdYHxKdQFrmNgM2wM1qHkfPsbQaR5CBMkLfL4uyxGvdi8FmDTSgL1EVw8DdGZfGmxM1IUGZZuYfXRrBrCPphYD1J0b7gqjSIztP234TGPeySFZfwYsMNKatQhs6Cq5tGodLhcnamBI1IVQhdiX+NtGx9+LsMJkpeiKVn/CPD8jSCKIAjfcMy+sHQxD23B6+ruSjf3SZvzD8hBqN6JVtgdOfyYZD9CtVpDl0QCjoYzr+QZ0sYnkxYTCstfr9dHEgUnjOhVh0zPQO4U8BzPt8N8pA9/yhwwt3AP/TT4LHHrQwqyYQ+nCqcLZBDmBIZ+RFFXnEuieVtDIADcxGS/cpCkXEvWxy6mSnAbxrlI69DcPplLitGozDhnaMHh1Ze2isM0YqC56oOLp9lkqxZvdoG/RWOB0OR1QNTjgV58kOAGoEZlZSGO1bL78G7vBYAUusOLMfosAlSY9lhebWQZwukKW2Y8Jk4mUtW6Dvbe72ntsp4guwH4PLF0gkjMHwUCHqhPfjQbFlNXouyW5UktMOttOEfNwdGijEOZXqZ/6xqbgSC5SLwtFp7YJ60PmRVpNUuXhTI/WvmfG6NIYoeuFU6EEPf5JZiMZEi5JCrutFSu+FLWrLvupsiLnHrESnkF2KhSklqTsIhHjw+JAv83n21dXYB+lCmdAYkz7y9jaST4Y4ZIAfN53T+xyidG3oyczH93TLbYhxDkEjyVBNEHQe1GOMRsRQswr4D7y/81m/rdgg6LbQZmgxC7oHewiox3TAxM0N8bw8z1jqvWGyvahCm1LiH3V/DQFVyQUXDOXSt3YvhjZK9kyWyXvDL07fjgmz6e6/DAMIeeECm4SxBZoU1fkRxBeu/pguC781PAxDi4VNF8o3gyP
 M82XVkV/
 FdqZre3CEmBCt1RL+S5dMMW/iYvoIrRFOaoqgSuI45Li0XDTLo5ZMSe0ipKiR0QmdDin79BHNe4iBGQwjp15Iv/qfbqDmpU7l0T9LrupKA8UkPvJcWipu6q9RxYOSEHGar7XBkLunthtp85SmUupsaZcVrx/XcDlcO61dKsJB2CK84IzhQRgIr6PQdknJ3IrzqMtGnOuMXdscMKaTfQl3yTKuLArhIeWhWECOrO51iS10/KRDtqUe/nv67bmCMA1tSRrtRcoa5QkN1XuNo1Hu7POJ4RAY6bKciQtvnChE5zUpV6NH2Lv9erkNHligssFI7hwfcWlZ9kYANOyX59m8qUUv4U3QB7u1cgSXPU51lGjkcyG1TMfytExy2koJdGmtGvHJFN2D5QraegWrEBZ/E+bNeTpjd47V3T/xevikT8r3068ON1jrpLnvBu/LzDOnLs6GU4BqgYg7wn16PJEjWpr6FnTOUbZUIkvrCZYQ8SGwL1zt9igFtj4o0HYhJVBARvC7w0l2x2qIYtSWi43R41NDSDxKjo+ZUPqrfPGlCLRx8KSpJp0SGPu99y2ByCE/zmavRFMNKaMB8QplIrInNsLj8qZFf94bDrPcAHn6EL85XtKUQuWuv4KfGZO5fY5JjY0SAvxKMB2VqqcSKER1ITghNprHN8c8TfKzv2bzHaUlVisVz2q3z6EYBxLmREz9l6jhMIKySzSiv+I26Isj4kD5Geh+4o36492kfLTRE5tI1BoRBQu7FxAkBCt6bxqbI8LgYbaTRvkHHMWEicXEsbD1iwv2vRtuSIPdy3qT0RBCY7B6hTJcd1VqG+RS4uv5WRdioMFRo5IRrmYmGhuBGI8IZ/KWh2fG2+P7NqoTcsOaGbivbNzdUUjEJfwL94IgCzkK4Omg4G1XP4phz2+NeZT3NQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:41:59AM -0600, Nico Pache wrote:
> khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
> some pages being unmapped. Skip these cases until we have a way to check
> if its ok to collapse to a smaller mTHP size (like in the case of a
> partially mapped folio).
>
> This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].
>
> [1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Other than comment below, LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1ad7e00d3fd6..6a4cf7e4a7cc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -611,6 +611,15 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		folio = page_folio(page);
>  		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> +		/*
> +		 * TODO: In some cases of partially-mapped folios, we'd actually
> +		 * want to collapse.
> +		 */

Not a fan of adding todo's in code, they have a habit of being left forever. I'd
maybe put a more written  out comment something similar to the commit message.

> +		if (order != HPAGE_PMD_ORDER && folio_order(folio) >= order) {
> +			result = SCAN_PTE_MAPPED_HUGEPAGE;
> +			goto out;
> +		}
> +
>  		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
> --
> 2.50.1
>

