Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 864E4D46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759B56B00B4; Wed, 21 Jan 2026 11:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1E06B00B6; Wed, 21 Jan 2026 11:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4176B00B7; Wed, 21 Jan 2026 11:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 371866B00B4
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC423C2A9F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:25 +0000 (UTC)
X-FDA: 84356561730.15.8BE487B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 802ED1C0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nQwAw/Nc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K6BDV8UC;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
	b=bBlqBn6xEx+secKeNtv8/m2NZAJ7irYpy8N2wSD9xBkrzg8rWbvT9rw9Uw8brnhD6wULLd
	XJdMTe7/8JKqoWTnj0LUGhpyd0Nqjubh+Fu3sB8jW4lsTHXPkOr5uksSa3D4rabtEuK5rH
	lIM2k/PEGJB7phs032RQtYz5tPutyRE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="nQwAw/Nc";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K6BDV8UC;
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014282; a=rsa-sha256;
	cv=pass;
	b=YTOvy5TGBwR4i0S+J5njUbjbcd1hSIh7w9qmNa2ysLa2D9CJXsuyUark7CJtzcTf81rij/
	PuSbmfvsCN8gLcAChH2hH3L92jlUEBgESYi5pUkWLKfa2KVZ8kMIJmP2tnSyict8J/prYD
	HcE6AQ3BRKJyuiv3J2gCgkR1YFed7nI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LABD4M3523773;
	Wed, 21 Jan 2026 16:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=; b=
	nQwAw/Nc5c6rASmb+0K6QwkGjpbX4D2r3reAcnAE3qxox22rDY/SgGNEmDUdo+xq
	wPvkY7vvCZ02T/at+Z9n6IREm3OExkqe8Pkfmepp0q3AwEJhwZSxTz7Sw/ljK9vO
	G3dir1oABsQVBJiz5mBDy3qpkxvKAmIidvMKLkAhmXn3WXm6qht6WUiEMER3rbeQ
	HNP0YR/G0ccnrWQ8EQO2oLLZ8xj7VwAI+Oq6Sz1JdKXE2G37ZzwVbTVRcRdL8nAk
	G8RbOjXr2YKwFZsSrck5QnHrjwcbfOgMoHlxNxVIpVfEI+pPHc7OSl6BcwnbD5Yl
	DOOwObK4enfq0QXj875xJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qedpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFPogZ032250;
	Wed, 21 Jan 2026 16:51:10 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012024.outbound.protection.outlook.com [40.107.209.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfad3s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:51:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRxPGcC8u3Db4hXWn18Vc724skzEXiLcO07ECGTQVgTVeZzBzx7vyf1+VLKrFOCzGcgg/IG0OOiAOPEC6+UUsqQSqYXpSwPXEFlH/Be1QvE5FAQ73y1lMVYL8aWIfH5ChWk3dHBsunRFu2oRjWSiiq2ZQ8cZQ/WijC9I/w3hOlpXNHWqpqC4kgzsqMoE/cbLR17JOdqv9aAVqN368ic1kDt1+/u3yQ22d33CyHWr11qbuOyv3Y1T2mnp0mAtNSE8vLmgcqxv/kwPhIlY21SABmjvX7oybdRJGXn9kqnwd46mFipwmlDSMg5V42SkJD9hE7zfxgBjS0UcRhTJLnmgfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
 b=XRYkx/lY82MzIJVDciRKgbyxoAfEMakeMT3SzIibVQ50ns0vtjv3qCunyX52XHo9vvxVcna1j8q4KIBYdy5MLoXuXuo4YdjXixW5IIH5k4lWoxGpe/aelNbMc2HLsbfxXr0t2E5oNHy3mkqMbHlj3l2bkv3kJopQDN4ERD6+ZiZlFMkEUzmOD1Sc+212dnMuVtScV/FfXj5bJhjtsu7iheM3HtYdsjnNW4UN53H+Gj2EiFj+NsA2Ir8BfVpgeA4HLf9yo2aixGKnvAmY+Pz7RbQcJW9/frvM/5HhYEtVG8wGA23IUNwD2sDwDaqxgE+13KbeX2gvxlk5Uv16ZUJbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SGfpH/hgveKKVaptQszPzRFK49ayroIMv3Dz0MEQOUQ=;
 b=K6BDV8UCUvi1xWK1+2twIFcx52PKRLhIn/GMs96J/NuZixAtwOT1VKZ99w9QpEeOAJPiVJdYNsAJyvKnvufXDQAvSH55oot+75FyzArO5krHFzSNVU9iXSTF+IfXy/r+v5n87wVCNoGMt6IUKMTrw24DWctRYdEMFt495rYwsUo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:51:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:51:06 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 10/11] mm/vma: Use unmap_region() in vms_clear_ptes()
Date: Wed, 21 Jan 2026 11:49:45 -0500
Message-ID: <20260121164946.2093480-11-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4414:EE_
X-MS-Office365-Filtering-Correlation-Id: 25747abc-48b0-4cfe-b4a7-08de590d4532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1uSbKa7mVFLB7NERRrHomdl83B1Nz1V0p+fJIBk8aocBe/UyOKtHOZy6ctUB?=
 =?us-ascii?Q?gYCGI5haI0IclFxwvws/uN7z9H+3EeoIOEp9uaHZP+SCUHzYfjjWHy3CiN2C?=
 =?us-ascii?Q?2D2kSyJe1I3WYIG19qptA9a8HVN5UQzy8NHBkTXbWK3OT/3lIr85aEWk5ckt?=
 =?us-ascii?Q?TiyIhuQHwcLRHOYQCiq7gB46TJMzCSKDOsBU8Eewa0T8pS1xwqqVttmoGP7q?=
 =?us-ascii?Q?yWiOI/NbjvuHsVbrYtQac01ac/JllMsZwQbHEXvAmDbi1fqehtWVvAdcSeRy?=
 =?us-ascii?Q?HXqJkCjyDVC9QT5Ns70YDWMZkEfQ6W2e+IxLya7eUK7VZ8Runp3YNzGvEjSj?=
 =?us-ascii?Q?r+inq1lG8VJai6vX2p7ExDoaPw0aMp5HyRymg8/OLLZ6MPwRmzAWFgQsj7JO?=
 =?us-ascii?Q?HPNlUmB180gM/4aCnXYtCQ3H/Vc4V1LWNpQZ3aOZCgHTvVnMSDbFJKbMoBbm?=
 =?us-ascii?Q?nEAqX3soyibf+BvTeeZ+3p3kf3D5VdelWTXgQa9NC3PKViPOPKW/ZI4O1fAi?=
 =?us-ascii?Q?ZKWxeYRZoSwk4EOyJqDjgq3qSfap4jibpiWw0jfLo+OAqJmjGQ0AP3z7tLZO?=
 =?us-ascii?Q?zSMZtmUo/uvh3bVME2CMNopkD8WIeO9+Sxl/8Ksg5PTeXNiSSiqe0JJgQrkk?=
 =?us-ascii?Q?5Ya64T06oQZ1RaM5Yw7msFvOWt9PCE/MUkw/07RGsq9I4gZQM87mz9uNrVVO?=
 =?us-ascii?Q?/95xo/SN4k2yoAW8S8aX+gNHqKkb9U3OPnu1VceZ01McJMuQTx10vCtdXkT1?=
 =?us-ascii?Q?ELIM6d+cRINqw6c7h6uDDpl3x3PZF0vuRjE0+BOzGEFKlQybzMFNKyp/BJty?=
 =?us-ascii?Q?vWwuwCOe1tPokFT5YcjDfgcnbEFW8JPEzAWVKf5tSw5J048ItPz2rrRODC8e?=
 =?us-ascii?Q?gG4cglCeJ3BiILQPbJcdnyndjnWezPsDHYBKDfVGrAvunsNdbvBBxv6Ok+QQ?=
 =?us-ascii?Q?VH5UM0N4aa/qzoGSAdJTz6a631DsS9IL9ioiCAMDL1W9B/Qi8vsiXCnFPCy0?=
 =?us-ascii?Q?vO2noL/rOSOdPlwLjoeV+2AVIOQtBx/WjBweGd7jxu5XoArIwt335J1xJC5b?=
 =?us-ascii?Q?5EeJajAi07YvKv7zR3fNJjEJV8U4pocZEqaEdDgSGiwUbDTQdENx5AWQL4pq?=
 =?us-ascii?Q?COxw0jztK4xXbbvFeWxz+SVpdEDp2lmnb0QOVJDNMUxvMxZz+pUdu3ze8v73?=
 =?us-ascii?Q?zoKmE/OTCe5fS4yjOan8Wfl4peXrmW/H6IsR9ZaGu0m3HSEwv0yKz67a1tLV?=
 =?us-ascii?Q?fpGeqYb1rUIJl8rfZsX3ME4SfkKw2V2/ZxC0iyBPQw8QGzMuYCcbMzHIsFCQ?=
 =?us-ascii?Q?yzNvQBHn+693R1oR1BBhgc8fBD/HY9MFZBHdVtOp6FqJcYM9gNjD9Y0xAX7L?=
 =?us-ascii?Q?RI2RkEknewh4VraPdFTQvc9zPGJ4+mGIKOCr19qhisH182hJ9dC925+tGKQm?=
 =?us-ascii?Q?70a6z1oVExyiN6IXkfgJB3FwNAJABo8nSml8JJIF6eKOuQ4AymdRq3JqAil6?=
 =?us-ascii?Q?ig031UxRvv6vWKxTzYTdDRkZH4xy2ytXUFyK2LoRRSyw2hiYREeSvIQU9zbD?=
 =?us-ascii?Q?7MDKxcNgXE5l95DJFP4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eni/QdZMg6WQkQ4h9NlNg8b2//7hB1kOyavUXk77Pkk2N5OJ5sY4qlhVKwIy?=
 =?us-ascii?Q?SbZKtYdvde0w2MQUHppAvBk3Ue/crcwzqiGP8vhc+aqKzxSQ4UktzxZ7HIWD?=
 =?us-ascii?Q?vr0kgpobEZ1NWrGLlXoKY7ipfNVIDLAi5HbW1varRA5udCp6AOF14ubMFV4C?=
 =?us-ascii?Q?xi9pm0xkYx3dam1rv3fYho+CyUl6ZPSaRyQw3F3X3J8kxGY7R45x6FQj/uXH?=
 =?us-ascii?Q?DEPOv3upRC+ntpsVBWNG1iCAvG0LOXVqJSyjM/Bv7b2MZGgqdFmOEoy4plFS?=
 =?us-ascii?Q?VtYBXigNhAAk1fbYQI5hWbRvdpaSuVifmuybS/KkkxzTPFwB/ZzRIIZ1erH1?=
 =?us-ascii?Q?aLxGpYRSVFDKoJn/q8mkxmJt8Hh4Qvzswul6d+ji30WcCqHkX2xO2PzcQBBy?=
 =?us-ascii?Q?Dg5K0DrM9ZgK8qAFDyt4B1yqZpiU5oP3lrS+jH1ss/4nnrlbkm7WouQyh63I?=
 =?us-ascii?Q?hAdGstcvf0qTPxb1J0zU9zrftuhkhW0Xn3OBtHbWfGiWlk6qdLckH9XEgDJY?=
 =?us-ascii?Q?ymQLS50hxVpXlu/Oyk3aXQsxcwGQg1V4z9gap/RpIuUdgh6gDlAC1bwUpQoN?=
 =?us-ascii?Q?V9D5CnlyjbSFIpyAje4k2lj3LLpjK+jImx4LLLS0/kIIHIicuTRnBiakYBoK?=
 =?us-ascii?Q?rSb5oCBq8ZzRNlW14VummgNDf7nhHMBa2umGtI55NTzHG98kNxXIuGgSZDx+?=
 =?us-ascii?Q?RN+7T54JYw2q2MkcoAIk4Be6UKBH43XDpEo4+pPsQWVA//l1JrEN5bndYl1h?=
 =?us-ascii?Q?NVL1N9gLwG0MT1TP3dusjwtnuRIzmRNeCLrXQdfxUTk6CZU6KUiWZLtddPK5?=
 =?us-ascii?Q?rJgStF2lVj2BMG6RXG7OX+VZ8KpF7H/ipTH071v1csfsJKhU1QeYBXAy9UEk?=
 =?us-ascii?Q?v5nj3dX3tOFGXs0xbMez6z86/zNeERdhC7bPmosco+sAjuDOfMKPREPqFZrs?=
 =?us-ascii?Q?DLoITOXrHtpWpYh6FkHG0Z85oDGeN3cZky5MfInnSW5o2RDbx4P/eRsFcTQg?=
 =?us-ascii?Q?CHLZCDpktTrhyJNHwy3sZ3fGaaqi7wQwAFcY/qKjgZ7pqnxPjb1TYGxpjIVQ?=
 =?us-ascii?Q?p48cTHq9FvI8IvQ2Sis8ZBnN3A+jCwWvADsRpd4tidRaMD1iWaPAffRJs2vc?=
 =?us-ascii?Q?+oOrsgiLpYDVg1Y8gNZ2mqgKoRmVAq51q+eJWYAny9+EzSOY0PbgRFAfHtIQ?=
 =?us-ascii?Q?u6UeSaC7QzUSsO5yo0a4bhqYH2T42Fm3/dWVTL1zahIwfNxTGE9U5DEWe77q?=
 =?us-ascii?Q?UwbSCRlZOm59bkrJSlPmRkqcpxVpiB8CErNHJwBIAHfcXdpl5IDe88dHWKIS?=
 =?us-ascii?Q?jrN5GniJaXdjUPz6saJ1SBJEKwkKM5V+K+ppQiJnXCjVApYpRUaCEPpQJIM/?=
 =?us-ascii?Q?snSlc8pTV5iu8oc/Qjut/sc27+pNTM+vJlbUihelKmSvKZN9ax4K+C1VTbWv?=
 =?us-ascii?Q?fhsTRsHIFbk2H9Ph70i9ZOEgbpIUOva3eu7XocS+e49W8Ozbv2E1cOzZTXGe?=
 =?us-ascii?Q?weu3Aa/TKvdLuchL71ByJGcFtsITHxFyXa9Lcr7XWZ5o187jo4scSSvS2AeY?=
 =?us-ascii?Q?h3zoMdiwDAG46Pno22QpCStqcHb4wRuyDoroobw0ix9tSdcIOiPqz6RLo64J?=
 =?us-ascii?Q?lIsWa2uNsLOVUKlD/jX7OUIbCC7+yIAWMsatQfxRAcC2b+Cqtl2N88YItneG?=
 =?us-ascii?Q?Hd8xyVF1bhQ6vpqxh/qLCK9RVZSc5YtucZBvQKNEuChkNoMPAvV6evR0MFE3?=
 =?us-ascii?Q?R/Ahu6Ceow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gFpzpnNuCsAERESUbZSGVdruJVtYnysva1Wu7qCTqTJVTIfmBa/54lnM8zh3SdSSiIkNQjZWmea88xleIrAZGomf514tkYISqn6k+GFkW2vpOqh89kBPaB1d+m19ic7YMsFphZQ0Kx3H5nBT2yAeNr0VZZPSM/drUDAOkgkVNpWGy7uD/jdB77ytZ/3j4MtZlUdKz1aWTzvb1cUi6Ja7/kf0oLFK2ixNeSwxDC7gTNcd7+iq/a2VshDhYlwXxI3WG4FZy3nuMe6UuUxBdQ4UoH0O6kS7gjGGKZR5ZsMFkkJNqcXK2MKSYqWsUS38oSUP2oXUX77v/OdT1UyMV4kMhGWfeOwRSLW8AJ91mVLbuHS5M5xmtUh8P3QVi7nR2eTtuT671o204Vze017lSvyetJHF84po3AEdWsEWfO5/Wm2B/JKVCJkt1V6LbH8oNtWHqEMTU7LG4p56l131yhwPl7sQiJj0P8K9Ltyab1HvzBZbQrjSLizwANqOIHYZUf7EG7Aq3aw7N3J/hDvlje1l6mkpx9AIxTeo+ENicXiSuaiyWWRca748J6VxxhVFDP/BdPyLKXqRIS13YgTZhGoIn8vKFjY6zIMJ7CtS9IYznrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25747abc-48b0-4cfe-b4a7-08de590d4532
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:51:06.5226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tmJjm5TpAUSL3TrNH7SqpDXLlfirUC61tJ2/PyT6V7eW3bmphzNjEDrxNVr/Eif3vqONY7loGO0Bhaj6h9sdSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-GUID: Oc8ZrntcjYX7JIoAHKZvp5IWkuSZCaeT
X-Proofpoint-ORIG-GUID: Oc8ZrntcjYX7JIoAHKZvp5IWkuSZCaeT
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=697103fe b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=uX-LFyyL9tsN2g4AakUA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX3U2esweBUCw/
 Vpn8uCOWOsfXrBL+NeeNfpAVvUh2nyStmywALbhsyXezgz3m2LPt7KA4mewJs12QzXtYin05pGL
 IcGYipBbK+hu+E307PRReZ9nqvwp2IgG70nErovIW0qHN/1KBy+FZpwLUEUr2iAW7BNeFjbHARo
 iBaGqirAdp9ApqngsV1aDIv0lfcKtdK5qZZPXBm85Os7mVzGjvM0oupAIAbSf+/+l3OhyimYd8F
 UWQiK/JmYYcj2wcWmSOporPTthkfD8vWkFAGDfYzXiU5pAT15uy/U517XQ9+lcq/vTwvZklBm5B
 /qQ4N9575LYDM7iuhpINWlznHAhnusJ3lWaMl/U2EGbCD8HT+BIfUXeGOmz1/TXZp6B+n/Ftmjg
 S6YHG0uuK27meeFldcyLuuxlT+LvS165xNoCFaRdTpdo6yZeSVaT9jqgsAaQUCOXcOPmxdMn8Hi
 XKIDxGM8f5bll5KMHp4ZcNawug7fyFurJKamIyB4=
X-Rspamd-Server: rspam12
X-Stat-Signature: irfpty1onnbtsquwhhxjk77uarewowho
X-Rspamd-Queue-Id: 802ED1C0009
X-Rspam-User: 
X-HE-Tag: 1769014282-969827
X-HE-Meta: U2FsdGVkX184qXrEK6lNbK7yF1jzuGWZaehaOZfdq8iIJemfqVBMgkAu8WCgWZOQEOT662w+hcw2lFMv0CTD9rhNAV/dVA1M2iTYXpdI5EuAxFPtDteqMtmeC/SC82MF/DO2p7E06UP7pL2xf+Ww36UEDDOYxsIW8WzdrVGrwxaGnmE1pr3w+wB3VoXxFEwMLcCfdLfAndCJsdSqSEiSF4QsUW6utFQnR20jNsgWWcFvcPqMb+emtTeXz8/9tfK7+3TMPXC0kPZdoZJERsENgk434TY3XwyyfJnkbgPkz9LW6qqX7O5elkYmMwhV6m4eHoIOHO7wqG+ArqaSGTlp0CQGQs08fljvPT8YQ+YLhB9/P39dqvMMROrYxSja9gti2zxUcPZp0WQvvnfLQrz4Wu8YJPIEHw5Wl5h9+GSi54DoLvOOb72+ehRyspjpxUSjB9Z5Wp9yUIOzVCnkEffSCFCfA2CKrIzOdmeMu5qpeDuCjXkl2asdOeB2Tiy84cnqu5dOEOO0V/Y3naMEKNQNwqzoIMhLl3t+m3KS/mEiNbO7kE/aOMcKE76DN9R3rpE7kOVTROBE89ayTdyaQTGoqwqa94OrlQ0PlBYDM4nNbQWyPeFh+Mt5lpvaiDPgsqTqfxzPa1vtmRh5/zWoIf3EwPmjqYJxZTRuX+cXNZTrgZAOjs9ASYUE47z1/Sp+JTXZ9BSSxEZ2iiIhmC90pNotfAMdvj3YOcXFUldg6gFz0Y4iQRRbrmUuRApLQEJccVBL0GLCvgrECMYYccE8EIEpeMfDLyK6Vq5bA5BceNR7Zm5A9mdNrxXFmM9EdJLQmrpmxYJDrc24/KoS4E4lHY3Ha+bUrjNExct1HnItgacAWUs79NoifLhIOF8k4rIs4mQqN4AJmI7MWppvWoJxlxZz6wWZlem3B7QN0raNg/7fXueoYjDyXgvO3VAmeImSf3IKzgaB+USDNuUbC9XUylu
 dUHPiuLq
 xySFnWMrbIIDAkHik0sJ6prbgAQl7Zqhh2AK4uDhZiQAXkJX9vFikE+3mGzx+rB86zdJ1WsU9A00vS4sCq38EMm/ufdL+PeG81JNO5WJby8nlgHFdkdvm2OScGxFnak6HCqflX5oQr8LVFtvfKUlg8dyG06rQUq5XZmVJ2M4J0lLCYQMAUkSPJRD3u44xfduLHMX79fvPq8Kit5aHoZr7EDhKgvuO/hwBGDDvjOnAWZAgxokwIv/6xk3BJ2bEuNKmEckdHUseiZa3fg/WST6qzDvh/0l0M7LwsDiRf2p+vXGVuBH0/yLiIopqAgOMA/FbAQUF0m4FenZrysQDLGw9DYeTTmZUf/oqMXn5Knx4rv6jUCB4hJRQbXZRGnDq9bejv0jUhNl66SU5xelvNjcaHa+Eq+jFsuXI+TA0wqYa1hs1i3TPUFo8sJ3VYpGizfdnw4aMEKBFCzk2Fp6Ez7rw8X9DtxSBIFtEWbfKrPWQANmhVTX8bkkIkxrwkjzgQbEZETqoMHhi5NtfjIk03u79gpJg3tx4bIpx9pXjUxfC3A250eacL6o1rXqagplLI8EjYMVhriiOWd3NF5Ts1Dtfvz8HjYVQcbLKnQQEsayeoj+2jA0jm3KYWPgsopQDih8tFSSxNL50rB1JHSjz1OkYEheWycd5Fhy0MUgGVEvTMegYOuhGl6BLmVgYulgJGckfwwxytNIyq0TCRvmI2uZ08DUuVXh49Fp8/rW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no need to open code the vms_clear_ptes() now that unmap_desc
struct is used.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b46c869d4bb07..876d2db5329dd 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1255,7 +1255,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
-	struct mmu_gather tlb;
 	struct unmap_desc unmap = {
 		.mas = mas_detach,
 		.first = vms->vma,
@@ -1280,19 +1279,8 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
 
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
 	mas_set(mas_detach, 1);
-	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
-	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, &unmap);
-	mas_set(mas_detach, 1);
-	/* start and end may be different if there is no prev or next vma. */
-	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
-	tlb_finish_mmu(&tlb);
+	unmap_region(&unmap);
 	vms->clear_ptes = false;
 }
 
-- 
2.47.3


