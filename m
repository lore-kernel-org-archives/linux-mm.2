Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13543E67A9E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5733A6B00D4; Tue,  3 Mar 2026 05:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A9B6B00E8; Tue,  3 Mar 2026 05:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402D16B00F4; Tue,  3 Mar 2026 05:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB6A6B00D4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:20:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFBE7C1B83
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:20:12 +0000 (UTC)
X-FDA: 84504356664.07.C982B5D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5EE9EC0006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:20:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eZ0qnZKi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J7BFc6EP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772533209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLkoSpTvAT2Fb1SDHIWBw2gfqxlYdr29qlLjqwbeFjw=;
	b=qAwXvBP46ihXbbce1oGjllJpX5FshxNgn93vii7csSWsthasTahfsy5FEK2Z8D3gH9MiRJ
	Vx9W9DJy/l4MHg1HP7hWJaTleugRwlwvvVsF126fBuvOn6sTqESeaoXKDxZtMg5p7WyQxz
	BTMxQDlX2d3FxJqMOhBPQf3MVwaZUxs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eZ0qnZKi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J7BFc6EP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772533209; a=rsa-sha256;
	cv=pass;
	b=7gcAuxwJVFs/h0/1xP5rwhc9BGj1lw4u0I9RlvbNcKwiNv2zMnVogUVk6WWtCuK7V8O9i2
	Nmi2nzf7Ji0GRhBSyHjcu4o5Wl0GJWlVa3en2cqFAGADtjUVAhkcVUh5Gz2Vz/NJS4jZ4E
	23xhdGTr2JcJNC9rnoslaNCJ3OFupe4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622N8s2w308871;
	Tue, 3 Mar 2026 10:19:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xLkoSpTvAT2Fb1SDHI
	WBw2gfqxlYdr29qlLjqwbeFjw=; b=eZ0qnZKirxt+Lw3YrpIRfT6HphokBRAuzS
	9Vyi7x6Egp9dJstj1SoaplNApRZ+sjSqy7SUop9XAIAqTWk709cQSl/Gre41iUDj
	VebFVlG/GjQdroU2Iz8loi20tTN+inHzTHwj4dgWvUTz6DFGyr32iNiJ2pyC8Tch
	PuzEM1p/pvjXXfv9bxnImm+Ijmpl9jJIS6f3LWhpXgw3lB79iFsu8hobk1sstMqP
	IoaC9Q3GFYSWDz/EidW06EtYdHl7R+61mz+EB6q3v2syw9lonuZ0OdoDQO0VtYEi
	axIZvJTFrlV7o/nPnBMD9LtuEASwAJnABRwDFUSRv02f+faa1YyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnky3rppy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:19:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6239hKsp037818;
	Tue, 3 Mar 2026 10:19:58 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptee4vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 10:19:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgvMTwxCaX5nkE7PB04SW/xgpYRHFzJhHWYyKmMqYdYC0RxblAgFP+ZLQ3pII02DU0xtoIFM/LTt1n2MSIbdPFl96DiPbJHwicarb/flUKHmsdWsCjv9KksYI0B5l8T5i+qBrRXf8IxcgUg2tCvAVCx1iBZ3eU++tqfRx+n2bcSiZygqSpu/R1XrGgwkTmdq0HNm/hMdaW3n2PDJtICmK/7La1EpuKB9SIwEf8yR6YPxeLfImlUeeD6EKFyPL1LTPwufdRsdrVPZr4sXPsIaBBcF04bRJer329lbU+wUPx3s4FeZ2bWkWRopmbl9NqaIJZ6vMw1IlzXAA/OvCYiPMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLkoSpTvAT2Fb1SDHIWBw2gfqxlYdr29qlLjqwbeFjw=;
 b=mjqdmsHacK55RLrMNifWC7Lc41BevIfHI43xVLne/c8ccz+wsh3kzwGSYzqxSIQZfH65EvXNqFIL2PGG/wopPHZoKOl0ogTm7D4oSFYLfGNywaIYe/+92BhxDp6bskEioo/s5yFHiwLQHK42ozFpASX1rlj3rFL2ZiXA7wKCu0dEv1rWYPzbrXr6OCAckQ73FugYzY8ICO5lh+6R0JGA8xyw/IAqB8FVsGqDbIKtLcPlq6TDb1/TlXv33LOOprF9p56YF0rNxTEI87TIzsLJ9le8bviD1YqZrDVqdX6ojgezUjHuer7L9qkYYHN6z4CrbRRE/NpR19WAFOKvBodUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLkoSpTvAT2Fb1SDHIWBw2gfqxlYdr29qlLjqwbeFjw=;
 b=J7BFc6EPgSM0dWWZBaLwAMDsPswIU2ZHzfOW861iQCMWl26+FuZJsoowKd9ICUPkP+uy/Dydii6IAMhUHFckC7YKyc7EimQai2kzpGYqulzrhtuudzW422Nldbu/XS9bo9NHiuSvLiTizFdLiEgDPf4UMMWLz98X5tQ7ThQ+UU4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8709.namprd10.prod.outlook.com (2603:10b6:208:56d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 3 Mar
 2026 10:19:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 10:19:54 +0000
Date: Tue, 3 Mar 2026 10:19:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vincent Donnefort <vdonnefort@google.com>,
        Qing Wang <wangqing7171@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        syzbot+3b5dd2030fe08afdf65d@syzkaller.appspotmail.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH] tracing: Fix WARN_ON in tracing_buffers_mmap_close
Message-ID: <71c3a923-dc00-471c-9555-c08d5e135dee@lucifer.local>
References: <20260227025842.1085206-1-wangqing7171@gmail.com>
 <aaFrmHzIAkEe7ufy@google.com>
 <aaF0zS3xh5KgM_yy@google.com>
 <aaF-bhAIhCgusG9k@google.com>
 <20260227102038.0fef81e9@gandalf.local.home>
 <20260227155601.18ebd3ca@gandalf.local.home>
 <e4deff21-2fb5-4f37-a7d3-ede5f69a4489@lucifer.local>
 <20260302115220.163f1249@gandalf.local.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302115220.163f1249@gandalf.local.home>
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: bba8e1bb-698a-41fb-e667-08de790e69f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	gbu+4eEeyn0rvDKmmlD5Z4O2HNtu9biptlhNeV3EKi1tN0VhmrKcBEtDFo7GnMKGaIcRF0qe6nu4ZgBdkJc2TE1j3fXZBablsI9GIIOJKZ5A64nKRAObxXXX3oT1tFKWzPJcdREkkS9NLvm/LAWgt1RkWYtNlq1EUgPYWmGsnbqcZD+aFhNjwy+RSUwtqWx7z6viKKKpe6B7ytd9dff3Gm3fxBlCruBgiBFKIWqjBNZVPg0b+f9g7xV0AIT5wvrPwFg/7XgSc7aed6NZSybg1MOy2mH60dbbVABb8P3pimdq3wZBORwQbsQ39CDaM2xa4+5oPO1gUhLw0aEQUc2t+MbJznXL711pCXOsVC5Zmkd1BPywOEAqjRV4+7jgfEB0JkF5YW1iTsGl9K9mpGQUqbOMaz1OrGuxArP2OwEtnTQLe5pPoRIz7PDY9SbAmjysgiSt7wFqAIJRw4IfBR+SafWBonLt21RdNv3su7PnU8i/MbtslicAMVrpIPkQRB3gUNB5TV5ycgyZOmDWGbauRbBBmfFxL3T2tqx5lqeqzsJkXdVULRkRVWLJ3MYzp8Ph9OhT1PyYbkBnn1ifm5RvNEThVsArchajPxMvdUiMGBw37MYw3cPstkOxZKyT7K6ETcCoEY4IX0gn6kaatS087zzughhQTxg4/V+xDgxB4Go0QRVFSUEoCB1/J8LrUpZ9NdZ2HCOlCkVeBLyn97eePurLusN/4K3m89HYHnCe5hU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lPCDDl+txZZooRxYGJBP5TH4BBcgkwjO1n+qhmsZXMwglgpEx1Btw5tZt6Fa?=
 =?us-ascii?Q?p1wfhbRALcxGrYeIufgngPFAtluNOn1cF0uePcZy9clt3dyJ/gCJzu7s93dG?=
 =?us-ascii?Q?zVpdOw9vEYU+EXsdRlwuRkJZ7YrPGm+UVGUmJEDebZSCJx4RG10Z4rlVEUfj?=
 =?us-ascii?Q?dxFpRraJ4nBj+yuxETsNNE1vMqD3oLdgOEei/wmmq9/xjBzAWZjlvUBZpquD?=
 =?us-ascii?Q?lK7idjNi78dHcB6eD/KN4CLq9+ZOzQUTtoV6B6B3JjckgZZSHWs0BVRgKVx7?=
 =?us-ascii?Q?05CllkZLLgithQg7OeOYnFxEBcnPq9lPTiZNTsw6kt4pCFyjIZOBXnYmoXAj?=
 =?us-ascii?Q?a0pKPUJbws/dCY6WkUXzAQy48bAVw3xYPNmMydQaT11IRxRzsLi4/B5DzxgF?=
 =?us-ascii?Q?2tgYkBXz4eo7lkmYRJtunkBoJu1+IrCpzYrG8AMVsux6XQUQGwjMcnfPCoLP?=
 =?us-ascii?Q?JQuBxtZGkA9DfgmIbutbkpBPTmoj/0JkJK/3XP6WymmTJlXzYuOTv2Z9pBEv?=
 =?us-ascii?Q?btDLoKczWpOC5Jdo6uekQIAfO7pHAcCRf2s868JxzCGTSj73HPh4VXYBLYW2?=
 =?us-ascii?Q?t/899DxUJakFtCaC66oHqGYZepBJPgX1cE176M98sY9HXy945yO4nWt+MDJ0?=
 =?us-ascii?Q?FBD+rH1J/vxOaVdy1bHjd4qOvnir8SmOONWbksJFkYvGMR7S2ZXGGMXUDkX2?=
 =?us-ascii?Q?nN0/YYQmSJxd9JKsTf7+OdDpsFe9LnFQekdHucpeSjb+0MW6M2ydke8pK4LG?=
 =?us-ascii?Q?CX09e6oB55Q+xt393v3QX2e0V8KJwAhmYvb2PBQedBsGBbots5lVidEplDqZ?=
 =?us-ascii?Q?Nu9Aw0/5s2SN7kY0IH4iickwGOz40c06OOItGC+5YSN3Cp6A0lzJL/3LIEwI?=
 =?us-ascii?Q?BPXndsTYO5Q9rKn+aEuHVXhlSccdiAasyQo33Xa05zHzpm8pG7ydVHCpEWsD?=
 =?us-ascii?Q?dHxyCJMq0fB+n1Hc3prp4WkAJCmHbB58NFUfK1EPMgOhMpoI/CbiCnQf/hGC?=
 =?us-ascii?Q?8OCxw9r34qDVd7yh2PdeVEO0E0a7r5XNvctT20JPxGFpyoby5p8AG743fcP4?=
 =?us-ascii?Q?ec/q3gu4n1n1rMjOOD3tW6RnsOh7LPcGY2HUHSd3KFLuYlkizo6MK+sn0DRK?=
 =?us-ascii?Q?sJ2p1kahR3/t0N7lWPSznKaPBKyw/N5YqGsTth/CsCPHNpKbJJ7qX6eVCxi2?=
 =?us-ascii?Q?8DHGUhRFo8VgYWTOqdO7UW/EE4W+LiXwoa6H7qCsMaY7iCU8+5hZ6ipscg7F?=
 =?us-ascii?Q?SfH0W5nOhCLNxABBBXqNtxC9vPrQ+rhSLhqzBzCKMH7BV8bBQ4C4RTjFWrG0?=
 =?us-ascii?Q?aOTD5SIew+RVeaPOaxuSUPoY6oXUObVy32xMoe8MTnl1OkyP7h9uxymXooby?=
 =?us-ascii?Q?MDGOHj8rlJ+0lNiX2KYwr6sJij2PecNQNNgneTJkIJK8NjzRoaYdvXZUCdWx?=
 =?us-ascii?Q?xwU6hHkVUSv4OxeikiE6JsOlAEwrJeCYsJMxFgdfXu9/y2YjdcttZDJ1KTR3?=
 =?us-ascii?Q?vJdumgZenucxsMPjKnsf2tV4RLYL4xz/exWV8S7iTNcP/W8prjLiMpGTftZ5?=
 =?us-ascii?Q?7RG5DDnU/B93cR9fCVEjEMtoj4p0KntWRIL5DObGQi5T4Wc+OXt60FoOoosf?=
 =?us-ascii?Q?iyxTeQn/NhmorspanBaBZEliMCeWi+rcblowtrj2p47KIQ44TzM17jjlyArt?=
 =?us-ascii?Q?NLGmqLee4Vnn1gXvT2/H9BMzT7RL5mjEHgWRe2V9guyAJpeGQq8t7qyBZUCs?=
 =?us-ascii?Q?pzFQftF+cmPE0GGQohy1V9npB4lNMy8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jPcTWzRM0E8b9IYVVAIelIDVmtuEpSNQZZ1desvcfCW4eXsCDNqWisUHIUvwMS5jYMo4srlvsKyvpNV2JE8B2qbblFlxA1WTfiy8KAniXbGRs40PYq3T7mEOcHy02PMjXT1Ozoz7aakNNDCJepS+xJH11fDI7exXNa+hRbvYGL/T/A8WCSfiqJfRkaTMFrN7udWxTkAG9Nqnt1ifcmefyTtGvY/xILdZ7Xypm+uzunKyXHq7WrK+YUMWAU/BtezygmXD2S5EzuEaLRvjlHAJaEzCHu3bQczTASpppkM6MoGLo8sSZ1gO2HWCiFR9UQB9W3i9mS7Pvh3zAXepmonn2T5d5bmhR6WvBswrDUT1MAwjN+V05bolEqsuwBj43cMN3U4LSfrzXMj9AbtqL/K2RpXDgpXtLvBdvEjy+RU8R4Dm9anAIJYgBm+MurlkGp3jcCREH9BZ0WKY5BMv5yFb6kVcwT63HRpggsjmbtjVah9ykYQL2WGf78uqodxttqwdp7Y3MoQDhS4d6qOlnX7ASuLK9rHHYYZqe8u5rSPc6Tri3l0KtFP1q10u96O0gK6lU81oabqp1z1wJsqBV++wGV/4PBH0G+90eBiDxn18LvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba8e1bb-698a-41fb-e667-08de790e69f5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 10:19:54.8629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWbH5UhObHKuhWTp9iVBSKXZql6WuQNTwADahJWfG98TEZ3s+wi3TJPgwFLrNrQ72/EzB5/NyoqDcoa9j/u6OrgsHFWh3/hQVbsL9opIuJY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030078
X-Proofpoint-GUID: 2VhnF4Rf1AYJ5dvmfkQiNMtUdcCry90m
X-Proofpoint-ORIG-GUID: 2VhnF4Rf1AYJ5dvmfkQiNMtUdcCry90m
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA3OSBTYWx0ZWRfX4ODRxnMWOYVr
 3TnDHJlV8fZsIWrHD9eMbXbuWaCVgyf4HVdJJwm2y4BAMg7KkoXjytgqTQHUeVLEfLqB+oJwliK
 fA6Aerpl0MTsyBRCF7wiHEOm8v48yqj9nWltVsgE4/zeVEP0LW7Xze8Ec2TKVjX4cd1kiEm+aus
 BAcbDrzLubGIb/b96se9zw0TLM2oTYkFibtYW+qQsQxEpOQsF7q2mdtIagT9yPPlNBtg1bJTurn
 0pDpNLPnRyvmSz/aio+N4GLR/OpKm9II54jZ7HqhgTNyPL4433xKAZKtlOPIUXrbqQ3L7JPTE54
 XK1gECVi697t4sW1tGNtoDaVGjdrffExWeK4c/wEk8HwXdFs+a7BSKq77skox8h1wZVXN6wgZx2
 Da37jzYbVCSyQRBO5KAdXowDGmqfiVMkzD7Rhou/obi3i0X+3I88hEN5sGR0b2BPoFQaUiZMa84
 cf6YcaeOROQ7d0u3Jrkojdcgi1Ntw7SXGZPg6KDE=
X-Authority-Analysis: v=2.4 cv=EMELElZC c=1 sm=1 tr=0 ts=69a6b5ce b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8
 a=-QPqpQXO0ahWoVRtr00A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13810
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EE9EC0006
X-Stat-Signature: z65aggwwdazsf3sdg695rri13d6dbxiz
X-Rspam-User: 
X-HE-Tag: 1772533209-469999
X-HE-Meta: U2FsdGVkX18O2uVAM0G/AO886VaxRd5xb5Gq0zKrMKDY7uKTLg6MfVmLuu4HwPGbJ8MtpdgpnV2Sq80cKoQTnRlekqYqTZ9RrzNRRRccxeZyy4F7FI/gDNcmg7nQHyHKw64nChVdO6hTCoyHME+3y4OPhC6f1/MMLr4U014MK1PnQQpvt+o2jGeEyCwjQ/pM1x+PVMmoPLIlD3xgmxYIb9saVHLpBBzhfKHw3HEEYfatHqDQ2RohARMjbmP+8zg6HuUlu7xuCjSJl76gXysb5SFSTO+6QaK708bvLE1eE8c+SDuaOq+ql53wFzxRHANzxOP3GfhOUoZGvraL/NMBWfsR7B2gLDzP7OHtyBIZRl3ZuqMbZv0K9CJwR+I41hkUJsm2C8eodyL0A+K1ji+kTs33oo+RU2h9ReKRRGRYAzq7x/iVoZSZ3ctThO/nRaxczPlaCXU8HLeFwnnHjrNV50Aault8uhOcETCUJNOUSHVv1wWN/i/epCASyyTtHa4cESlsxiMxXPZpTLGRu42QyxPtI2zjjU35mDN69Zzb8BvhUZEpTtHrgSSOQEbSufmOdKbsbk7LNuvSGAEw+5pBoOo84UN+2wYDJZnlt0vyYH5cSeGi7hg8GcGiaVbrrvrK6ArfVgO9ICPntBq1oyxkrFB4/i8n+NSOmzwH9px2KmhIJebu8VB7RvKWQsX93ghEIVBHLz9E6k5+whkFqUIVF4LboYI2WPfrDpLJbWIpGYc4z3eh/3FeeDG53EIHruFqxVXI5F29r7zHNjr4EivhtiYpKVvMDYWr8H0qwAk2M9hUWD/Y6q3GKTb9D9iMZsIub/vMxhUnGGsw2Y5nRxfJA4ZeLlJf6AcJkf7X+PkiKrpvbDXCg9zxTR0DG7qR0lqonK+q5KcXbkcN9gm6YitUE0kKoATxWWlokPlLITgaFbiYgspv4wHbMRVvLPnRcuE2TKdblqwssMv0YMjy2nW
 fMBMsG1k
 S79cEtJ9ppc2re/pnTN4ZVLQE9f7i4zLCNvA1s4BTzPVB23fARJQRUycF3xAzfdOGqCaMFAwUkYwiTyra1IzEa6nN7gBlE2jKV0uT1IoDnjlL2kkf4++mZNc8RM4VeXhNsbWqvjbhhFkTxmCTqc9ERj3KlQIxFsmMvj4O1LEAynYq9R+pRw7jDxRHiLijsVoo31yPRoC4u+uTholzWqR7DArEMG/ePPDVxu44Y2Kbnb0vyGnIqeRsAZyq9LnIrE/9teeM1/YayckKnJ65NvfL/m9ochulDj9XwSupemWwlnYnhZ1iT1xvmTBsg67aCYwIUY5/axOjWFBJX2AKAL0lmXLv2BuUyuMIgAomvI5luiWEyoNkzLa+m1noLf4NLRkyloqL0Gh4O3MgsP8k8R4eqEB25dF5517xEieVKQoMJy+SGXfUclU4TkLMm3GFogcBtsaDzwH45fLhbF2dkVJofR2/HKguWgpq/z7wHXOS2ops2QpOfnFqNHK5qKmRCY3OtCzGKKv5v0/fqXkacD3G6LVWJ4jBqR79tgXGU5yUxm58bW79e7w+UVZwLLtEsLW5iN1YJz223dzX52ydpemlWN9TCSNbADQSIGNIZUfFkGsdEnxWvFVX04XjVQNKQfE7mae7ZY7WXCUEUMqWWksY/nHtmt9pPCoemZurLEpgS5TkGpJnXteud9iH5F7jQOy+x9xtOpgqWaLsTvNLOZ4KBHAkGFOzbO+QCixCQBgrj4MERcz7DRDRTrNJXR9kupOwwc7qVUlpcuh3NMEwS64YOX/okeWXxcM9339T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 11:52:20AM -0500, Steven Rostedt wrote:
> On Mon, 2 Mar 2026 12:13:24 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> Hi Lorenzo,
>
> Thanks for looking into this.
>
> > > But looking at the various flags, I see there's a VM_SPECIAL. I'm wondering
> > > if that is what we should use?
> >
> > VM_SPECIAL is not a VMA flag, it's a bitmask of all the flags which cause us not
> > to permit things like splitting/merging of VMAs (because we can't safely do
> > them), i.e. that are one or more of:
>
> Yep, I knew it wasn't a flag, and actually picked it because it looked to
> have the flags we may have wanted.

Yeah you shouldn't set that is TL;DR on that :P

>
> >
> >         VM_IO - Memory-mapped I/O range.
> >
> >     VM_PFNMAP - A mapping without struct folio's/page's backing them, e.g. perhaps a
> >                 raw kernel mapping.
> >
> >   VM_MIXEDMAP - A combination of page/folio-backed memory and/or PFN-backed memory.
> >
> > VM_DONTEXPAND - Disallow expansion of memory in mremap().
> >
> > You already set VM_DONTEXPAND so you get these semantics already.
> >
> > Setting VM_IO just to trigger a failure case in madvise() feels like a hack? I
> > guess it'd do the trick though, but you're not going to be able to reclaim that
> > memory, and you might get some unexpected behaviour in code paths that assume
> > VM_IO means it's memory-mapped I/O... (for instance GUP will stop working, if
> > you need that).
>
> Well, we don't reclaim that memory anyway.

OK so maybe not such an issue then! As long as GUP not working with it wouldn't
break anything?

>
> >
> > I'd take a step back and wonder why you are wanting to not allow copying on
> > fork? Is this kernel-allocated memory? In which case you should set VM_MIXEDMAP
> > or VM_PFNMAP as appropriate... If not and it has a folio etc. then it seems like
> > strange semantics.
> >
> > Are you really bothered also by users doing strange things? Maybe the solution
> > is to tolerate a fork-copy even if it's broken? I presume somethings straight up
> > breaks right now?
>
> Yeah, right now the accounting gets screwed up as the mappings get out of
> sync when it is forked.

Ack, is that in a way that could screw up things from a kernel point of view at
all? Presumably there was some report that triggered this work, like an assert
fail or something, or a warning?

If a user is explicitly going to an ftrace buffer and madvise()'ing it in random
ways they've only themselves to blame for being so stupid :)

As long as it's not exploitable in some way I don't think that's too much of an
issue?

It'd be nice to keep the semantics of 'don't copy on fork' if we could, even if
some crazy users might override it with madvise().

>
> >
> > Without more context that I don't really have much time to acquire it's hard to
> > know what to advise.
>
> Fair enough, let me explain everything then ;-)
>
> This is a mapping of the ftrace ring buffer to user space. Until recently,
> the only way user space could get access to the ftrace ring buffer was to
> either read it, or splice() it to a file/pipe/whatever.
>
> The way the ftrace ring buffer works is that it is made up of a bunch of
> sub-buffers (must be multiple of PAGE_SIZE and usually is a single page).
> There is one sub-buffer called the "reader-page" which writers never write
> to (with an exception out of scope for understanding the mappings).
>
> The "reader-page" is a sub-buffer that belongs to the reader. When the
> reader is finish with it and wants to read more of the buffer, an operation
> is performed to swap the current reader-page with one of the pages that the
> writers have. The new page is now owned by the reader and writers will
> leave it alone. This allows readers to do a zero copy splice of the data in
> the ring buffer.
>
> Now we added a feature to memory map this buffer to user space. The
> reader-page and writer sub-buffers are all mapped read-only into the user's
> memory address.
>
> Another page is mapped called the "meta page" which tells user space how to
> read the buffer (which sub-buffer is the current reader-page and the order
> of the write sub-buffers).
>
> The read-page is what user space will read directly, and when it is done,
> it does an ioctl() on the file descriptor for the buffer:
>
>   /sys/kernel/tracing/per_cpu/cpu*/trace_pipe_raw
>
> One command of the ioctl() will tell the kernel to swap the reader-page with
> a writer sub-buffer. The meta page is updated and the user space
> application can read that.
>
> Now the meta page is unique per ring buffer and not per process. If there's
> a fork, any change to the meta page will affect all processes that have
> this mapped.
>
> If two processes map the same buffer, one process will see any updates in
> its meta page that another process does to it.
>
> Now there is nothing wrong with doing that, accept the user space processes
> will likely get confused. And we currently allow two separate tasks to mmap
> it at the same time (maybe we shouldn't have!).
>
> What we didn't allow was forking, as the code didn't update the proper
> accounting. It needs to know that the buffer is mapped because it handles
> splice differently. As the pages are mapped to user space, the kernel can't
> just allow splice to steal a page and send it off to whatever pipe. Instead
> it makes a copy of the page (basically killing the performance splice()
> gives it in the first place).
>
> We originally added the DONTFORK so that we didn't need to handle the fork
> case, but I'm guessing that you are suggesting that we should do that
> instead of preventing it from being duplicated on fork. Am I correct?

Thanks for that!

Kind of separate from the question, but I mean if it's kernel-allocated memory
which you're managing separately it should surely be VM_PFNMAP?

It depends if you want to have a refcounted folio underneath though. If you do
then yeah don't do that :)

In general I'd suggest supporting the fork case if you can, or just let things
be wrong if a user does something crazy and undoes the VM_DONTCOPY flag.

>
> -- Steve
>

Cheers, Lorenzo

