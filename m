Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 556EACCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 11:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8F38E0010; Sun,  9 Nov 2025 06:16:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A078E0003; Sun,  9 Nov 2025 06:16:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A2F8E0010; Sun,  9 Nov 2025 06:16:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 229BD8E000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:16:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B852FC0950
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 11:16:34 +0000 (UTC)
X-FDA: 84090815508.08.6E11D7E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E8A5C0003
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 11:16:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2b6Nxp1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SCu22Cf0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762686991; a=rsa-sha256;
	cv=pass;
	b=5eh7rPyndLBv9mk6nTHn8pb01gMfSr6Yf0sO/vhaMEV/m09QRx5zo3zcqRBhO4kOmDpxH3
	/DhRyPXTsbDF9wae5qgMO1Fy9MC+CPPM/dhaD2EhclPq3NRVkOE0o3JUalaabbVIiOYgbx
	a3bOaupZwx2/7LIBlFfhvNH7iUf5Q+g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L2b6Nxp1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SCu22Cf0;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762686991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+mHo3MAhJ0IPTW7Gz4f6z89NWPJplQ4HtKDRIEAY8s=;
	b=INzUHzFCgWhHh6vjzyxc+/uofmVT6G2jo/7VOTptHUEdxmglmayhpYFHtiFdbYxm2prBmr
	mR8iA+o4Vvig6UGv0rubaPVcc7/aU8mMxfI4nwqBdQiCs1vYPZ2YdtS8a6tlu2AGVCSM6Y
	i7tBYX+e4YQpxlG/HqHX/2BVjsGaqYI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9AQPFA008548;
	Sun, 9 Nov 2025 11:16:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=X+mHo3MAhJ0IPTW7Gz4f6z89NWPJplQ4HtKDRIEAY8s=; b=
	L2b6Nxp1oV+cN53jjH/GJKZBEhm9AbW1eeC4qW0uAC5J6f62ptAQH9aiiY3EWNJP
	GTFIZiAUxo67hgqmkqLFhO8I1zr5ZH2VqBtVAI8YreC/cUHYGEE27fxwnoJ9juYA
	n+47x9i1oAiUtasYG9uBv947qu3GEA8fWoMUvpQ9cSqRI7exLUWSERoDlHgFqAlx
	Uqr2QDS1G4ihrXCMvqIk273WRVRBylJ9qhBTBqovfaYQ3mVRAj2uBjtY2Vg6F19+
	OYxhMf7QCGCuJdcUPPhyH5nXDgEw8mw27ACWYI7OLJI0ZqHgQg5V+OXmnmYS6B58
	kW5XUvSCYRhKP4PXls5uvQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aaj7rrby6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Nov 2025 11:16:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A95n7NY039984;
	Sun, 9 Nov 2025 11:16:18 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va765rx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Nov 2025 11:16:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZfYScWspNWpivDkk6iKZHcNpfyWDFzynwfMN0bkp7aVU0Kil7Mp9bddK4HaYwMOUeK0sNgfpaoLZjNL0Tqe3HAf2MQ+YLHixzjl9OEi0EueVU3iWbX27nGi3XAla6rp+CoYGSgSCmZbEGw8C5qVXN8uKpuhnbyRGAmo4SUnJwgij3rYW4KBqtIAVpcJ2WX9QxC2rxRSA7AtkUd7ULnjtvsiNoiPumhouYp4GCJaQWee5iQ8sNOnYbuDw8jzZLr3Pjnt9mDfe6euiy1pbjOCmdyMMoOX3bVkumkuxf0Su9BLRVmSIdzZzcmCk/NGjFlR8BP4PgNvx/OZOBSnnr8qrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X+mHo3MAhJ0IPTW7Gz4f6z89NWPJplQ4HtKDRIEAY8s=;
 b=Tr7h2Q8HT8fPpu/saC/cKRjSjJbN4NuwHxKRmbNvy34tyQHB0P2VUUHyB3z7ymyrY3f3PlkFt5Sl+4y3gkE+nJGPKY44k751VSPQOP9WgnN3GdTXffoTrPjZRoJkltfTjd5UM3SP7aLKj8yGUKGiUK4JSA3uB5ldJNSGosDeq46GxSMseEMTHqfaow4LNrSoNZ3SE874OOUtTe1K6U8+4gqZnMpe3JN3nw+RDqFymVh9SW8e4c4vJLNRVjnZLZySRbqGWbbQk0qfopiG8X1+ywFLXcSa4wGNyracpFftaUIYxQ/wlKF1VkwaKw6sMqNyxZ/dLlaLEpOWWpoPqU3jlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X+mHo3MAhJ0IPTW7Gz4f6z89NWPJplQ4HtKDRIEAY8s=;
 b=SCu22Cf0ID7m8GKfOb8IzHFGwvZka0FF5MbGdQK2rXmjTeUsBIk+o6AkMEI0nNAmfKMEkt4m+FRC5C050anT5EbO9BgOi4DjbowW2WLve3706A+/WZwG/xtlS8cjY7+8gLBbIQbW4Je273BipfcIqazIHGjOCaTAGOlSIChTKU0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6410.namprd10.prod.outlook.com (2603:10b6:510:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sun, 9 Nov
 2025 11:16:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Sun, 9 Nov 2025
 11:16:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: rename walk_page_range_mm()
Date: Sun,  9 Nov 2025 11:16:06 +0000
Message-ID: <2e48c7ffbd2ecec8ac189569636173fb44ed3631.1762686301.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
References: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0446.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: 774c39ac-9ef8-43c5-edfc-08de1f81665f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q4+Rchy99BPiz6wpSaLNe+vhpIqSL0YUrGxYXFs/HKZyd9GiKtLisYbkUClw?=
 =?us-ascii?Q?A9+n5UKfdDQM3+VGV16hIud/c29y1dK8k/qPmSkxH9BmWsFobZ6Lf6pfNKFP?=
 =?us-ascii?Q?C67z3wWdohZKMxRMT0Lo2dT9Gdn9QEEfs1YRaUVa1EFAsVNQK7PucDDx2Sie?=
 =?us-ascii?Q?S4JOSN18xyQ3DW5bFr2WGSWNXYZLOs6/JzW9m4IAVwZni7FP004Eix9fVKkd?=
 =?us-ascii?Q?R19/AyPLaUujlWqDaFr15jGOcc3h7vD/FNw89+q0ebs+pf2hXip/QKs4C9bz?=
 =?us-ascii?Q?m3Ge/jlCTsEYg88mqP8K7qmRe+Wgk/EhtEEF9AvpjMZ4QQ94lia/83rEgprY?=
 =?us-ascii?Q?6vawvJwr9FNygYmxPikPOkVpKsofXTntLa8J9SwJ6EelrJtMFzcVhbu1Zq0n?=
 =?us-ascii?Q?jYkAnZ4zquvkMebuHKbD2K+IAdjYMUj5ERUUr39u9xyc6MnA7VjaRHj8mSXH?=
 =?us-ascii?Q?a3OBlA52ax9zN5uYeosS59BntUjxV0GgIBdr3i2FDZiH2wpllPyu4U8iwe+h?=
 =?us-ascii?Q?drThv5oriZbSJYBjHikEsGfAPFNB6bKna9/rnUZanJgFis5InY/8/CvfVeTi?=
 =?us-ascii?Q?1VgVtOX6NvlH/sWqjGLpiQC4x/abzs0gJjpVtBuLAH9aER8a72/o1QJ1Wk6u?=
 =?us-ascii?Q?ddcGS44E8EBmwKsyrLjcTyo3M1e4KQvLwSW119XCaNX/6VRsGQ+NDpQlWCZk?=
 =?us-ascii?Q?lonuajh/8dkGkIru7uQL3OVNeWXeiYJHzY4UVW+ksf4eBi8nEMBskOamj438?=
 =?us-ascii?Q?rmmITIQ0zTnNnR3DQhYrMV89wZ+YmSRZku/bLFcuI7SOVDDeP2agl056EWqG?=
 =?us-ascii?Q?slgAA/Xzf9JK78YClrprp9cXLlEfegJYXyq2xxipZ6XtX8YZtkmT/KhySiT7?=
 =?us-ascii?Q?8SzDdVxNdaScDwotx5csMTO1VK88m/0jI+od0cmyCaD/jzT/aEoNjIpnhaD0?=
 =?us-ascii?Q?lQRUBihLe0Oy7qkhiYG8q/I314QLmhzGHgmNqr0WtvhLjY9knsNGM6o0HZrJ?=
 =?us-ascii?Q?31uecdoobIcSinyt8iYbogHVkNZClwftK8fAcAUm6nuf2pI6Mpb+Gfra+jH9?=
 =?us-ascii?Q?O5dvUY+h32eidYN+fJz3DMH9g0JWitpydTorgrvaHhLmzqNfY5MwBQ54mGgr?=
 =?us-ascii?Q?NJrezGrQUf5klEVoVkAuzfoG8LoOkCT1sXHCgUNOhlMbwtYcogriDmBneTly?=
 =?us-ascii?Q?HIsIIyUjojNxXkF0VzUI85HDZ0yFUuRli8Ue+OFgTyL3wYJ3NtOGEg+rUAav?=
 =?us-ascii?Q?Ur2BCoW3CkKCBVPE/W4/414XCy1l6nlh5THi3bkl5w2eMEhc5OC7QkvjVp3x?=
 =?us-ascii?Q?Jn0eYud8waiEC0zQZZ0N4NhQNxQmdvgPS0oQKU7ZFmZbF78d0vF1M1dhujzt?=
 =?us-ascii?Q?BGBeJ49lZsojfeoml7RwoqRShBjRMqeyr0FxkyA1scUJrb7ANhB88eHaZKi8?=
 =?us-ascii?Q?FSX9pI6smyjrhmda0M2jxUgObPzIBGZP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yWP3IddDCa5NK/hFxertYLSPfhsXkXyjt7x1bzJKBqpfacc/jvft+EnD+a6b?=
 =?us-ascii?Q?euJaGE0wm3MME6Lejh1ge/ydcVB8PiffHDO4yy6Fp6Aflok0PxPkAVKf5w7D?=
 =?us-ascii?Q?sNAkdri/yr6untwohP7sLyh151Kvxhzf3lqsytZsUK5M8Q5ULBJ22L6PQuxq?=
 =?us-ascii?Q?8njVFqCuxwhhM6maJXe0ekYD/MQlxMV7mrEqyRfgVs/Ppm+rFxAASsnVQcZ8?=
 =?us-ascii?Q?Uazf3BZT0bhfmb32/S117EIEvz3vE8WtK0XyGVagR4LHvah0u9bCt721p8gh?=
 =?us-ascii?Q?/gBuDvja2WoEvWkAQ/srd045IOS3dDRlhCMhbxi6J0r61WvwwVc6xiqXalJv?=
 =?us-ascii?Q?JxosR/xoDVSGDx63CjsAGQgeqBmbJyCMnGgOkSkVmxUoWB7ED5gmVZ1UQMWb?=
 =?us-ascii?Q?DjpmnA40PimZ+jh3D6635O50UA/RXIy4Ys/oPeJK5BjE8tNcXRwdzV7fi8b8?=
 =?us-ascii?Q?WTOxs3CvdLG15jOtTk53ngjjpIMRuRUjlzKeDMq722N2kfQekiD1oM8f2/pI?=
 =?us-ascii?Q?s3g6ObR+9s9DE6hSmlOI+3+UJ3K74I4wYrDDP2u5DDqC9tkjUrZtXE/4mrSi?=
 =?us-ascii?Q?3xTYqacniLxEM2sisIgoY52ut5elwVHI9BOlRZ/zV/JSyE5cQpFaWm9w3dot?=
 =?us-ascii?Q?XIUC1DIunlNc7TcfQeeEXbZzAAADBexTk6NnsPyeN0s3lEEwRwVuWidXJ+k7?=
 =?us-ascii?Q?TIucSh9G+gcIKzBgf5RAyHPgMgltt1WtSFpIaiDtnELWHU/f7Hj4lObkpce+?=
 =?us-ascii?Q?tDAxcYHK/p61cyfArQ+pSHKmAwi4lWgbgN/o1yZyFzHivwi6irBmP7tYmkUV?=
 =?us-ascii?Q?/j7GqndECkrpUqLWLD4YE0V3xKHCXY3h91iCgJSDV4jBClnY8xZ0ZjDnsV4s?=
 =?us-ascii?Q?R/RTooFJm+VudsBuRJOhoJOtJIRt3Sp4im/cckdXyJIdMxdgpibGmQf+fu2f?=
 =?us-ascii?Q?0n7TQCL31Jk3fLS4+fk2onE7VrdSPu0abHLLPy74qv9M2rW3bOtcu0twWK/M?=
 =?us-ascii?Q?B6tR/6g7K4HebPLvQ/ogxsafIeTRh73l+YZg6ZQJoht82JAGxXeoNcjW6riB?=
 =?us-ascii?Q?+QjJ6T//7Rmq4g43DuykQuYz1qOrJCBvRHEHQ+qonrIX7eCnycGuRk1iwG3I?=
 =?us-ascii?Q?c3tdz4+X0jhqCN/s3F0OCd/3FGm9u6t9c0S2E45GNtqEuLJpE8Rb/BBfEdBG?=
 =?us-ascii?Q?cP61nYJNXYvfZCF8oWxr//QOpn10AM7ep2R4dVBHA3NXC2vLs/Qc25bnB8FM?=
 =?us-ascii?Q?fQdzHVtGKOzHPgw5KtPvYwIwvgVvby8BHXvCA6puQ8fzH0AsEO3jhGyecJgl?=
 =?us-ascii?Q?7B0GrLpfZl/Dv+lHuH/mQUT7Q1qFeviD2EFiZfzvg5Wjzhu2JNJ2WyZOvrQc?=
 =?us-ascii?Q?g4R2Dd+1TIZWlM4H0+32FY4Ne1LIM7sDQ7BqKBUAo04qdoFbDcALNSstCGBI?=
 =?us-ascii?Q?F0f3xwTJrDLH2CDKJ2y7oEIFii8TdmV27ncpkZz16XfeCDbSs1fHYB8D8ghf?=
 =?us-ascii?Q?PAh0oABtrkd+/DZqoYfVnddF/3I0J2tnP8b8jGAsA1hJSvjyZjb4D5QzSIDg?=
 =?us-ascii?Q?hnvw31qfy9NAjBWaq/BAWv3n35l4phGXfZArhb/xH+YOafEq3LmrryaOSLLT?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dNH+tDvrU/Hd0S9wfjWUpfjxN0gtF44gkChDdrqwCGY1SMCjXYuNAp5ZcVOOx60IlMHzgh8y5qRT5MLBcX6v/A8J27x8N9G5F2ROQHWDZNFG5nFg865z53eh1OeP0O/dzLcKxfq7QSDALx5OPBRX83mXw3C/Lg8aJNzZgDwEiEvT5V3To6ksuirW1i5nUWqbs1cgyQ7NJHQVCzaWmcszPaSR45Q29YxlMRHWo/oICmpvCt60QkuVhY+HcrlYxe5tS03Z9Ar16RR27WWArk8kB7PZH5nxCQb6PfjQ+P2yE6oWFk/x3y1t6sO+BcwYvivtVQurWUwtL9W5384DvYVldqFmWpY79Ee2MrFMVN/Ibe6P3IGdiXmUqk5ACqq+W4CEuaJ1WbufnTLYrmcJ8SaY/gVod2gaQPpM2aIO/e32QIZdnEWcxHBB2gP5iemgyMDTEJSpePeH/kWIB02EI8wl07sv03gwzOhs4zr364k4KroxahHE3LsH4s8zOaHO3jI8tGf5rDGAazhtZI8+Sdi2Wa/WpBDcP4KTORz8UM33rC84qx2Am24WAAKeuo82BNW/1vqKbNgbmYfgDij2FdVMIKndHhataDjAy5pSm1YGr/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 774c39ac-9ef8-43c5-edfc-08de1f81665f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2025 11:16:16.3293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8igkn0yRyRgCfZfjvEBsItwM+9gLCuLey6KBlv/gI/frbvVhgP0A+JoKLlrBZg1cK1Mgbczmq+nrLMK4rH/qlOJL+F8xJxhNF2JD4Du+wtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6410
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-09_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511090099
X-Proofpoint-GUID: 8xM_uhK5QuKjwYwYvmEiwk136FxKLj4a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA5MDAxOSBTYWx0ZWRfXxPw+ZyasSTcw
 zlTqMAl7RZZujZhBREskc5Vo57uX68ugrDJWyaV65ISlMN6sSa1J+Ar5vPwcodJxfFvp4I9DdHo
 kEyFw5Isk6UtZUStITewOnVzoOQtd4ybPOquUWWyM7B2/KwUif8y+7NQscr4ggLtfKPT4kF+GtA
 CnvxKK6jmBhbRyVvhRV7Z4HV1mom1j4TAJmEcQSKNG8t5yqyTt6e+8Mf62t+wWSzpLj9dUxK8vA
 RamqeSCBWidRsGc7ZJaiNS5p4tF0IQPkfc1hVQPHsNY4bDqFXPG6vUy9DpyP/MnlsgRbhvzoaU9
 j36HR6J/AuDZO4tCPr0PVGfp64wkOLsBnyQGNS4vbsJ0VmMRC8gNJOUzSqC8zBMZexxAgFa76wI
 DKW/oIuNsHdL7u5sm+FbedAPmMWeWQ==
X-Proofpoint-ORIG-GUID: 8xM_uhK5QuKjwYwYvmEiwk136FxKLj4a
X-Authority-Analysis: v=2.4 cv=U42fzOru c=1 sm=1 tr=0 ts=69107803 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=AiKqYkh6zsRRk4LQ1F4A:9
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E8A5C0003
X-Stat-Signature: eipje11cqits3bxqnqjy4mrgog3wxfth
X-Rspam-User: 
X-HE-Tag: 1762686990-742182
X-HE-Meta: U2FsdGVkX1+VIOdyGDJB1gOFbOP/eANGavh0wIDCn9RqIRJPEK37Axxzk+6/M6xhKUN2M0aEE3WWHR1Jy3in2rFBJ1WolKF32WR6SsG0jv1h01bULlKfi1beH88xeIqRSWLrHYy+bFIiN0e2KzxZ+B5ah9prCVQcPsqndp63JrfGHOiV4j0yJglo9oqttWc30JhvNK60FmX8xci1LFpcoHKOWEE5D8uuFkR3aSBHMFAHR3LOMUbiy16WmXaSAiMJ8m+sodMhXavvaV1yUHYg9qIcCo/FLnpRiM/HkorkH6ryz800dcMfl1HeiE5Yv6K9MYoArD5kD97HDELm3tdd+pi5e+I0x+/SoEVg2t9wVtdQDOkkU71koY5vY3vEPzSmckoP59NPv8XNcE9XKeD2AMw1WerCS42lPQMm8BFU/8ymyjtfJsp7yjmZxFN0GmtuO4cUnZfnlp1/gmjUDX7VKTRNbZ99Dw1yyrtH2apPxrqruCdQ6vnwnhtcz44jyOU2wRoY5IHS5GPQoi/tq+IoKbTxXSnsfmqbRYxC2/yJGRgvgJqMFbDXyKaJ/QuVlh6kymD9e99SB1SDv7Um6Q7RBLjw2NoF5uDpUnPK2kENoZmhxfE1wyPTZ+YP1rmrJO93BFoq5ruabqPtIsUIbLOe3M67bK3fbnkdQ7uuNtNAmaERfObOAMoMzAtYSKiHpLncxQvj48t5cltXXtbpTnILkRYOV5VIyU4aLVumkD31teB8nVRoKMi9qOMrR+SX30+x1UYYtVrkWTC8mxDpBqBLgWL/auYeYjuKXW5MRQP+JvubUHBBt6gvyHNBIkAEyHciFL6Lnj/w1KZ/AO1/SasJwZw7Niko3cRgzJBpFeBC3sozrE9OeWlBrelmCX2SDi/SfQWlo/Nw1cUiM4aN5/BT2rWHpD1F8QS+GKU8WM4Cm4//IE+nn/mj6NotDTh1nsuz+PMWkpoxz3kx8ugvdV+
 afBsSjr+
 rOzTUqdxbFOmNbBKjqTPsf1rWzq9toGxiWPB7An6h7SCQYyR8qM78YUZKmraBfgjtG4Xnam40/OwPHHU6vka1v+Yo3N7ahfvP+n/Pp7xr90PM/sjM/CN9Z38YCAkr05G+RMvhq4dViSzkGhJeg/XyWzvH0CfEocLz09X0m9AFZC3bh72bFaiXXXMWiR/jYSjA28qa5aTx+qRILh/GKtsYU3m7IWi1QyQPODT5+AUUjinLbrC8xGUj2stUfAAlDSw1/ssUesIAj1whtGXLrVq7QLmbj3BwuhrNrWiM4LtCv58aUUij7HdAXsqgKiFixnGzWG5hmKYqLbAdgs8bf7IZ9dL1b4lywc5ui75UJ6gudxx5jUJGM+bML7Gpu042hJDBb1kf2EHCMBrDkIuwNVtiMCiQzwJUt0+zHj4MPOxB1TElHeJ2v7v+2/NqhWiEE0LDPLVONmcsx9a/ovBPNWijtVKaNm34xGOjEHIC0GqRgWnGYkACfcZa+F6bj7A3tw06zXW2Q4evtrKGBfKwXS6qbbezFsqpjkhGXPBFjoRMfDEsBsJRIAnTtZwFBtA4lhvA1bwOCTGDljcrSUqGfoZJlD05L8j9CR+GjG8Hpmt5PqR8JpzHyjdrqMmX6Gp3/MunGvYCfTv3kj7HMDmNXkPKwNh3RraE61RNGVpb59ulrGW30jVama97Swe9Ykt1x2RDIAb63foYd3xN4KxIPDgHsiGMMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make it clear we're referencing an unsafe variant of this function
explicitly.

This is laying the foundation for exposing more such functions and
maintaining a consistent naming scheme.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h | 2 +-
 mm/madvise.c  | 4 ++--
 mm/pagewalk.c | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0af87f6c2889..479234b39394 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1652,7 +1652,7 @@ static inline void accept_page(struct page *page)
 #endif /* CONFIG_UNACCEPTED_MEMORY */
 
 /* pagewalk.c */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
diff --git a/mm/madvise.c b/mm/madvise.c
index de918b107cfc..7b938ff44be2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1171,8 +1171,8 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		unsigned long nr_pages = 0;
 
 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm(vma->vm_mm, range->start, range->end,
-					 &guard_install_walk_ops, &nr_pages);
+		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+				range->end, &guard_install_walk_ops, &nr_pages);
 		if (err < 0)
 			return err;
 
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6cace2c8814a..6b6ec602a916 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -452,7 +452,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
  * We usually restrict the ability to install PTEs, but this functionality is
  * available to internal memory management code and provided in mm/internal.h.
  */
-int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
+int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private)
 {
@@ -518,8 +518,8 @@ int walk_page_range_mm(struct mm_struct *mm, unsigned long start,
  * This check is performed on all functions which are parameterised by walk
  * operations and exposed in include/linux/pagewalk.h.
  *
- * Internal memory management code can use the walk_page_range_mm() function to
- * be able to use all page walking operations.
+ * Internal memory management code can use *_unsafe() functions to be able to
+ * use all page walking operations.
  */
 static bool check_ops_valid(const struct mm_walk_ops *ops)
 {
@@ -582,7 +582,7 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
 	if (!check_ops_valid(ops))
 		return -EINVAL;
 
-	return walk_page_range_mm(mm, start, end, ops, private);
+	return walk_page_range_mm_unsafe(mm, start, end, ops, private);
 }
 
 /**
-- 
2.51.0


