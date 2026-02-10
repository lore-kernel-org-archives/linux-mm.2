Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0362DEE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B08E6B008C; Mon,  9 Feb 2026 23:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6511C6B0092; Mon,  9 Feb 2026 23:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF516B0093; Mon,  9 Feb 2026 23:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E35A6B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:47:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE6ADB895C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:25 +0000 (UTC)
X-FDA: 84427313250.29.A7E4FA3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DCF4180005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rxio+cAj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vQmHGIzy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URccC+UWeq3RSJfRDnlMZjUgM9r58LOpd7NQOIK/ss4=;
	b=JJo7LZXdAljZE/6gMH2lUpggvKuq+hFhBDcqMNfj2FyS6ZSWM3ibvg65y5hilmllBAdxwj
	tkBOYl9HeqKnIa2LhfuJqPLpJehf4KP7gtu4amt5yP2dm/uXjCEz/QWFyoYqXByukRPxXs
	ge2LbHfhymhidieJmJUFU2nb4E/W2TQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770698842; a=rsa-sha256;
	cv=pass;
	b=tSCOQVnGt+3ukTrtdSwGL7ziQRSJ0MLFmWZ0tBIDjHuWY0d97yjSq3L5+X070tqX5OoWWM
	ooADGxEv89h3/iNjFI3Koi7nwX4uOe5AO839Oy5edWehLtya2M4LBbxbBd+h18Nk0BPwO/
	ylR/4JEZs3fRE++JGGYtzFH/1U/I3Pw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Rxio+cAj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vQmHGIzy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MGQjm1559123;
	Tue, 10 Feb 2026 04:47:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=URccC+UWeq3RSJfRDnlMZjUgM9r58LOpd7NQOIK/ss4=; b=
	Rxio+cAj0BIGyVy83zR59xhRpDopPoY7wxcijxzfYgB29SD7n5z1bM7iB9/4BlwG
	HVfND3HXyS+fHGEKPMTAjWP6g6vNPw3kkWsw5AsvJocaARKV1CKW6AT5RUJcrs4/
	DCxOulrvhvFu8g1fCsWZ19YdOU1sVQUv1CXAFv/6jmEzjI368tzp7RzHx6Q859QF
	2TBDSjR6Ch+U3rrnfhs0uw76Shhvn+5+PzO/trNUomHjlZ/TjQPUgbqWgvnt+fqW
	Fx6jS+ukDFQgsAGvnOO6bN2Fwu1A5cfm6/Vbjz4kzCLySwkXh4QYiu2WvKZhibmP
	dF+R3IzeijMBHhrIVdkp7w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhub94a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:47:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A0tOeK033706;
	Tue, 10 Feb 2026 04:47:01 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012035.outbound.protection.outlook.com [52.101.43.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c7ctyfa7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:47:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5dz4f6C/zI6wU0kq+Jm8tYacMoeiY5hvOFoeAyjZ7XuEdTSfm0j76IEuViN0ba2HcW2L5uuMu2ekTgDKSPiFLn784aslQ86eh4Gm/Xqf7q+Q3MWC+jA/KHzNOIIPRuhvm4s66DPULh63W8AmUzIhCjf5o13DVo0gKcuD5pSNvaICvGh4BYD9iRvdGQ9lt5lmMhv9OYlhn1dOLOnx8zSgprlFzGEDktcE87Hr1/uKT0yyVy2edGy7s3YVL8mGim3p/en7P6qQRbp3jpbBx4vxBiftCxCpWr2kC1rYLq6pNDqM8cNXR0sdDtv0S5zjJXua60NYbLEnkkriDCnWsDtRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URccC+UWeq3RSJfRDnlMZjUgM9r58LOpd7NQOIK/ss4=;
 b=jDMvwX1TGRSAQUWgwCefxCQsqAsF6szEBkbrlXLK5yYnxS1xXLsqe4lbvtdHlV+JoXO7fFq5ReDj3bnrKZZ8KdBqtkvWMmxy0PPTIf7xQa7cIF7tOmGozMSUTg8tAaiuzcc4Wn6BZJFb9jVcJanz5TvQ5/XlY5unDAtSDluD+LhXInUTb29NC5di+0VLelALA4U40RGKEEIKwYv+2S/3Lb+GMKGa6AVTk8sg7fQ18or4ukGCX5DUdTMsnLuxTrWDLqEQWzjm3vCqQ/Z/Op6Z73q8C+zER0ooerULq6g82GgcEequzIXdgQttbfiusc97+GoFacYjaHjdqb9c/jyY9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URccC+UWeq3RSJfRDnlMZjUgM9r58LOpd7NQOIK/ss4=;
 b=vQmHGIzyAsytSF96gysCCvkky54STmW5wwBt2n5zlcLhBknizJwSyzFYrW50BVNp+9mqoLKVDzNFWpJ0fjzfGE69bo+Z4KSaO9f7KrL402vdQHzbbZR7mdL0njwfztlZRrN8vDZFNA2ogBlhAQe1s0bq8VHWXOC92Du1f4aKsgM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 04:46:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 04:46:58 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 2/2] mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from enum objext_flags
Date: Tue, 10 Feb 2026 13:46:42 +0900
Message-ID: <20260210044642.139482-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260210044642.139482-1-harry.yoo@oracle.com>
References: <20260210044642.139482-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0107.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9d574e-4d91-4ae2-8f5c-08de685f6c7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?paOIOqBDwqlqIEkRcN9Tf0gjAOv6hT4MI9O4zbNGA0IPSU4XM/46BwaqAK1w?=
 =?us-ascii?Q?+MtuIu3VSJZPCGNRJxybUyE8yatyog1hO5FHVNiZOnw13KgtUCkLSEosoJhZ?=
 =?us-ascii?Q?pDwDWBd8F/uVtLjqIUEkAaiT53YBNOPgyIv9i6fJG3hZ+Y09mWolqDmpkc06?=
 =?us-ascii?Q?QSX5RPrYL5qLFn5jZWZFkXkI15BeRo+shZVeAYMVEyXUArVZ5trqdcqiC0dK?=
 =?us-ascii?Q?ErSZ7GWJGRYv1oxGd54XifO2jIKTnUCyQITvtopjQSSP+B2Zd6mBjM0hOeAH?=
 =?us-ascii?Q?lK7OSp5QxzUrP+U5sLD+GLpMaipf/D4xCHdyO6nyjQGO+E/xs85LERfP9sii?=
 =?us-ascii?Q?bmNm6aawL1Tq+DqvzCxqO4MEHfmEpcxJl49cvsu568GbnUiplrfHJm25FLP3?=
 =?us-ascii?Q?uz3Lg/FrIT065iMZHfjU4LiFYUNW5N1OOHvBQxqcFiQyy0apWgWid2yM4+PB?=
 =?us-ascii?Q?MhtyTQkAIHsMFttAS8c7Go2DCLnSh3Md8MF7SuzADe3MrQyup73t30qDtm1N?=
 =?us-ascii?Q?ODVKz1IYX0BQU/5qn8K9ySgi+xK3Lxm9QGLQEQz9UOrAJ0xFTZWnfCLi7Gid?=
 =?us-ascii?Q?ZvTG0uh0DAEMtcu5Ad8DTeUKrgyfesl2y7Pb3nscqqFtfkSVFsh+3HGs/qOe?=
 =?us-ascii?Q?iPda5VHR0nSHXK1Bm5i47HJae6ZjBnAmm5sFIN6nktOZHdt47VDfNVnV0Ai2?=
 =?us-ascii?Q?rZkg11E37u1hjV/Xn+vXkIZteTBUPKxhEonAi7p/X/VzQNAyhhuo3PkbxHAD?=
 =?us-ascii?Q?gksxMWYJ6iAJNzrPIhPpFAMmnk0I5K4V/M3VE8f5kpZAzhQ3EEuEK7tDABtB?=
 =?us-ascii?Q?YxMeCZxiGI3FOjvqRkdWo57WIKRSi8WrW28nNJ9SyU4BRTWocU7EdRaNDwe9?=
 =?us-ascii?Q?90hyKur7vtnDJHP+j6qaq9QzC2NUrUO/7UPy2YTRTgO25G0iUcaT8J4MJ9r2?=
 =?us-ascii?Q?RWsGiLd6mUhyBWPRI76CRzzuO3Ypxt/nmqm9+3CaA9EfvWfUWKmoQJkzUk47?=
 =?us-ascii?Q?vf3ZhNSqXzQGKbRAcfugjZszqUIfTDqBtgLC6Owl4eKR5ysfi+tjy+0g9KCe?=
 =?us-ascii?Q?h4xXPg/44do56j5EMrwco/YJIFUxxkh9o5BTakQVYVNSDxb9113CJypaI6Sz?=
 =?us-ascii?Q?KlC9+SoSLqvrnqHdrhwQXBQvfZVPnDp3U9GbZNvrXSjV/TFwx9K+yYDGRcBk?=
 =?us-ascii?Q?h2jziwgxKpLRTHt1AGQL5/5R+lNn7N/yKEFmpkbA2g9hlbPQuVGh8xYtb+Xj?=
 =?us-ascii?Q?rKyY/1yKtPc+gH8A/gBxu1kf20BIR/NEs38IBe/UrWVnoWGSimKqFgm2JeQt?=
 =?us-ascii?Q?NU6odMljKm0FaW68jj6HA+JWhpTgODwV42o6RRTMxM1A4sfOLGDvwzgh7ptU?=
 =?us-ascii?Q?Dc8j/Zvv2+kEIWbJdIFhsenDS5kAqG6myxpYzXR9Wk/jqOeKK/URukIGEC+G?=
 =?us-ascii?Q?6MBI9yEBhm5FOtWhAAKdkEbt/IEkRv3hO3s+FUKnBgo2CvlVDrNdgIbV4KNw?=
 =?us-ascii?Q?FNRYZRGyvae73IWRp+290Mv4tOHkaF4rLRcUHn4i5lvEdKzSSUZi5bniAXi2?=
 =?us-ascii?Q?rw21cjfUFRq1KAzUPkU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QiVYzhqNQeUy59HPxDnC5yJH8PwdOLufAn2X77ZiBY+vCiN9tEFyyPwfEfCg?=
 =?us-ascii?Q?BwzMzQk1Z682zWHY6kfYVoREujOFsOTPH2Xi9SlrwPrAcsfHhFC8IeNk4IeL?=
 =?us-ascii?Q?11sCv7Lnoml2eXwSpzyXggQf83hafh1V9ceM/TgFlfTUYA1rV16vpx/XbyPa?=
 =?us-ascii?Q?Tn4UQ3PcUdMy7nW4VZT2Me6tjpRVAiDoe9NYcaL87euRIxsU2SL06kqJdLIn?=
 =?us-ascii?Q?grRr0miXxriJbzRf4rRSPetvPbC+pwpgbn56RpW77hcNMYjlt/PeKVsBJ+xy?=
 =?us-ascii?Q?+BDaFo9bTcKWJOB6yrA5BY8hwyBcCl4K11nIMYRLJCkX302TUX+8C8UdmUPh?=
 =?us-ascii?Q?dT+t78d9vL6kM0sEq4MtJVIy+aLHeLSYut1CIKiW5ScIXJ8lom8CHmngYNsC?=
 =?us-ascii?Q?v8Cix9AAxZ1cx0sKwk5xnRb4OFlzeuZDaHp5TvsotzJBIKDm4ncTmktZpypd?=
 =?us-ascii?Q?tFQi//QOUCEb9Tq+Pvw1ShBIkIQeFbFVtQRqgi/byNjPi1JGDyZX/P+J73G1?=
 =?us-ascii?Q?qiTvnA6mZL4gka2U5+RgvFCYO2ZQuMnVQHuiujrj+ppbObw72PTq1crKwyAN?=
 =?us-ascii?Q?b23SrlTa5spTU7nrS/moyvrFMMfG3Dn8o/updV9ngmuJdlTq+wIV/bjVWykS?=
 =?us-ascii?Q?aMjdF2CO0F+/iEVJ0bj1vR+GJH3NxK5kJyn56llpyJacyG+LEXWgNR8ZiF/y?=
 =?us-ascii?Q?avLPaFojhN7RTvhiwrp6Wk1xZLWnQaaueubtEyYM6ZxuTd+HRqtSFqlZAl9w?=
 =?us-ascii?Q?szwnuXlUhQUP7h7695yeva0s8ZWb6muVzJddEKRJlE8bee6O7EqTK7I7rwdK?=
 =?us-ascii?Q?05uOLDjgcxvpZjNUKjzWFdD7arVQtkNda46sV6/YruDSS2VQRcrnmbth8O+E?=
 =?us-ascii?Q?SjwfFXYzopuAWvec7zbqzUgeL8+H9U4+r8qTkFei3uX2UbhziVBo+qBXAYqe?=
 =?us-ascii?Q?rNMTrAkncM3cPsSGfKzmTe7/C6YZnrWIRRRPPUNR7nYlEk8VD9PwNm1zN9oy?=
 =?us-ascii?Q?I9ZQpI1x5Z4C11ET3y4hY9cjElYyjMlG6/VPWqPgReOqAsZOBQftBiwIQxbB?=
 =?us-ascii?Q?eMzNVswhgoKWnZwHsS+Tem165/NtcEqbvUJPDo9IDc7ZQo/PwQIMd11xVpLz?=
 =?us-ascii?Q?+m9G25f8e/qSQqB43meJz2vRwtLfSEPQS+Wg+QIpNhmYlQg2I0sZIHZ/pM6h?=
 =?us-ascii?Q?yvZFlPhJyuxFUa7JRKipIhVxi68zHeTcBrVxeWnYGJH4qKH7ZcURt62f3/rE?=
 =?us-ascii?Q?+WbMuzNNvKjq5Qcn3uY+fTH3/GRSqEwKtZhnwvYzNtgk1bXVdRWTiTTGgiA2?=
 =?us-ascii?Q?6HCajILDwqqDtVLTFQA78bVkQo7HbEe9EVQwmmsvsAgotpyP9NQCfR+ZG6cq?=
 =?us-ascii?Q?yr8hNtkKjaaU2Rg7kjmCWz1xGi8T36NXqygflUQy//HtdRGn/w3HYhns+3z9?=
 =?us-ascii?Q?FRAlpRMFVNXxK17EUROV85bZQ2aCFp9QC513gWN9su+nbs1uxN4LZN/BUEIT?=
 =?us-ascii?Q?Qxd1VM5bI/GdNF32CJKvZPWs39iBlWqjS3v7SNZOM7qqGZMy2Wkpsi5Gmr+s?=
 =?us-ascii?Q?0KppfGtR5AJ8exFLOeb6ZGFTBgvWnlB7q8KOAC7dygHIwpRV6IlNYcIk6BAk?=
 =?us-ascii?Q?ua9ZAQNkr0jxhFJJT1n6fjTMDNOtPUrPY6R5MKdflmaHPupufewZ+ZHbazQX?=
 =?us-ascii?Q?nXr64bmQHLSxOWUH9g+g/3NfktLBSu+GNpZnyHHZo2kVvxJIHsfk0KGxJ2Gy?=
 =?us-ascii?Q?rxmfc4Ihgw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JiFOnnZbZOvz/xNiA4jdlu49cj4zxyoSqYUDjgZXtuBIMM0EBpNeP2GKgtDprWjlJdZsvF/8GeRlSxkAvvdagAxd7e+j/uu9gb87/GlvXNKTvQlxqVh+5e0C6TN9+k3/OOhI2jZ2isf1Xh0zUhDKZezlixjPmGV3iQuuCYhs0XOQpUHwfVRg8hH3t5nnI0P+7OxreeCjje+rvA1X6rXHka9OJhoqQ59fsPDy7gBnLkV+EPlkSNx2gCoy6ebvn5lXov6IvYzqywtmQEBPt/emCfD6utKtBGJ03xdVlJmxoNDPiYCGWdeb/syQ6hbi4IitL2gUUxZE956wVhvT6rTbfsjse12P+YhceSVtVBqy+gZrtOh3oNnMakxNIAIxaLLD1Ruu1WVVYnPN6q/oWyilS3bi/875oDbltUK5EeKnyvmbMDQIUaY2GBlCSQNdNo3PF9X/o53QSF7Kh5itlwpwFtIH8/606ZKrWQr8ToctK7j6NJsuvWmGO6DWSgWC1a92MljwOTGj3UxYkosPGprrTGNstL7/M2bgiZBkFuwpbiazzPzgOEwqFnQplCNjcPCdDYjV8JgwddXg4PWp9uuRIRX9XwcPLMO99WXJBHNDTtA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9d574e-4d91-4ae2-8f5c-08de685f6c7b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 04:46:58.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cGSBluzzong43tY7HErG7Dtr9skxb1scMsdskQbKHsdAldrBqwPChNv/qpb6fU3YT4EbXvpTY2lguCYd5uWSuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100037
X-Proofpoint-GUID: uRZzHQmw43Rzl1tmAkmeCebQCdgKzKQh
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=698ab845 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=JlmOhekSyrAEfw6XPh4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDAzNyBTYWx0ZWRfX85kZs687ScMB
 tjyRI+aMOcn2I2mWTdhGpzMk+I3PBMmJA6pbCe7vewRdUsewDkoOSmRt8xITWcvwATmOsRLEiLs
 kAqR/Fwe4W+ynagprJD8Pqp8r9ZddsHgnmViWr5rysl2GUh3vc+3ghFrsCQ32R91SYZzvv3qogf
 Bzfhm/oW3tcT98vI/nm2z1cWzCrVnhxHekujA3ktfeihieFpDjUz9bzTrJOpCJHXwzkboWLl9RW
 pivQmXVbny+yK89Zwd+xVwWgGqRcps2ui7GOYHkJ6HNh8OI5oyWlqEGCVDm5AB/QY2SAJfQk7Ol
 MzjIOLpQZNvFjQCdkcjp9ab4MeuQtGdhG045scSgZ+ZrhmyXpvPNZxe9tEdYVs5SU3TmLqIpIuC
 95Ao/XCOwqYcorl3R2O2kHrDaUohdkgzFi22Ki3QtPWjdMa8aT5bTRc9u77RpcD89LZjSFOiGoE
 vwjqdQo3x4s7LcoiGKA==
X-Proofpoint-ORIG-GUID: uRZzHQmw43Rzl1tmAkmeCebQCdgKzKQh
X-Rspamd-Queue-Id: 6DCF4180005
X-Stat-Signature: s3kwmgpy3sga1onurajfo3y1skkt5mo3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770698842-619754
X-HE-Meta: U2FsdGVkX191Qs+T7lNOONsMQIKYDbzE0BTRY2HXUUUMuGKQIZVx5LEcsx22fONuzqGgCEvH0bMKGpgorPeWrZ5IYKvFwlqdHem9nDlsco5Goc3yJpPaOvFmxrqOViblUwWZtIwCSoN5exWOvZh5y3/luhr9yJKS022K6CR/9lDW4QXnHT43Y8vLWwdkcHCMtULnoEdm/5BsLGiTJGtQi3GustlpPxK2ktS6jBYbVcyro+m3c4rljX/dY/SV+UEP3Ghlj1iwKmQjMQcY/v0AYe7UDq/x90QFYo51bkFL3djMbhePDiklAdUEICxg90e0AoXd7RNoSZAeHn78VkeC9V3zQLnz0QAvC5seUoRY9wKD6xF2XO7mms4+wFQ11Nzgs0GOK1KZY9WOLBwIAjGlvnpQ7K4ljXWJHtALMA3nE3N4oLbV3epmiPhxv8N9l0MEcwJEYUB6D+adt7kUwijx3iTbqNz0aIm3sCpSmWn5ojG033gKgGg3LjvvhRqld9UoVfbxq+tmfEFvUcDgooM+enZwmVZoIwbg8kbfHXl5AkJvDFNJhGiwOWQQXDg3sLWMoq4BO16MavjD7y0U4z3cqmIvZSax8zZBYel7Lru0pP18CxHwSxQKMcc3j0ih5xFyY12IF5mwY/RsU3VU5bBabFd89uN/WZDZuzyZhrCuFz1GmpAAA6aLEP+H2/HsgedZTU7n7uCfbOyWd1tArDLU6QcrKTpl/yY5mLz2zibe7sawsvOIyVszmULdHPOfodelE72ZyR4rJ4Q1q7Lmory2JE4Z+GJ3hxr9ZQ34H2qf/Mx6LRhgJj0GeBZBv6D1recQhuDyr2CYbsgLX4adoYO627KCs6DEPPtdLfImj9dbbCNAXo6O7L4jXub6KbYMj9O7QebcKN5lgvn/FMHm5Sl8SKg/cVubTTr6thIvWd/XtdICZOJ1qVNRGHFswElEJZ0xFYltoJQtZiaayaOLUE4
 7JHE5tXv
 T7C/D+nxjJ6JhFusAqCY2k5z87PQ93A1E/zYR0lqtUMVbs9mrNGG3MFTzMC9vyX4/PwVNir6egx8eagkDkDaZg119q2rGBTMa7A3HgzUckAsbu4YePnTat4I/uYtIVgwFLJeWup6iW1BdulbcCuMVIWdOfCWPzbmEfk0ZrwZm/8e0WidVC4FLym49TLjJoSKCSALcAG+bSG7zzqPN+aof5ejHNunjuJ3Dc1D++1sbbvLXm9GoGdJNG4QBOojVKAaPjWKRJobWFkehnbk3H5sZWV7FUW/zvkJwH8szZer6WRwR7tCyEfup4OL1OdQ9tmW7KLoPiOUPtZK+C+qJ9jdE1Df0DQfXA1Z37Qb3pTF1hoAoDM/gKNLrVSpN4oFb+nYNt2nzqwVc+y3WDseyQKlxcxeaBENE4W2Zed8p/4xRy7oWbdFuSJFA1hZxEALl7GNxrACeD+SCKj48NUwBB3m2YEb4/x4TqYDBOoQ2jdEm4Vqd6FB/v7x32lumrabHptWw/igLpUGS7AdIr1hwtaDX9WMVafYne1xnz552HU1foQ0d2rQVxXoZBZ4Gixozjw+g+E6ixYYWdD7rzYVMXxfftgUU+LGl/fJ96pKadGu6nMsX7jn7gvA6NnsXhR/xFljLk8BCK95pj2JX3NYH5iPeRCDpeP0LyJUpcdvDvL+PdqyEbwU4uILXJEccP+EDzOMuweLWbjtol/LGSmw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OBJEXTS_NOSPIN_ALLOC was used to remember whether a slabobj_ext vector
was allocated via kmalloc_nolock(), so that free_slab_obj_exts() could
call kfree_nolock() instead of kfree().

Now that kfree() supports freeing kmalloc_nolock() objects, this flag is
no longer needed. Instead, pass the allow_spin parameter down to
free_slab_obj_exts() to determine whether kfree_nolock() or kfree()
should be called in the free path, and free one bit in
enum objext_flags.

Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h |  3 +--
 mm/slub.c                  | 18 ++++++++----------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..bb789ec4a2a2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -359,8 +359,7 @@ enum objext_flags {
 	 * MEMCG_DATA_OBJEXTS.
 	 */
 	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
-	/* slabobj_ext vector allocated with kmalloc_nolock() */
-	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
+	__OBJEXTS_FLAG_UNUSED = __FIRST_OBJEXT_FLAG,
 	/* the next bit after the last actual flag */
 	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
diff --git a/mm/slub.c b/mm/slub.c
index 63b03fd62ca7..a73a80b33ff9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2189,8 +2189,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			virt_to_slab(vec)->slab_cache == s);
 
 	new_exts = (unsigned long)vec;
-	if (unlikely(!allow_spin))
-		new_exts |= OBJEXTS_NOSPIN_ALLOC;
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
@@ -2228,7 +2226,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	return 0;
 }
 
-static inline void free_slab_obj_exts(struct slab *slab)
+static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 {
 	struct slabobj_ext *obj_exts;
 
@@ -2256,10 +2254,10 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	 * the extension for obj_exts is expected to be NULL.
 	 */
 	mark_objexts_empty(obj_exts);
-	if (unlikely(READ_ONCE(slab->obj_exts) & OBJEXTS_NOSPIN_ALLOC))
-		kfree_nolock(obj_exts);
-	else
+	if (allow_spin)
 		kfree(obj_exts);
+	else
+		kfree_nolock(obj_exts);
 	slab->obj_exts = 0;
 }
 
@@ -2323,7 +2321,7 @@ static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	return 0;
 }
 
-static inline void free_slab_obj_exts(struct slab *slab)
+static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 {
 }
 
@@ -3387,14 +3385,14 @@ static __always_inline void account_slab(struct slab *slab, int order,
 }
 
 static __always_inline void unaccount_slab(struct slab *slab, int order,
-					   struct kmem_cache *s)
+					   struct kmem_cache *s, bool allow_spin)
 {
 	/*
 	 * The slab object extensions should now be freed regardless of
 	 * whether mem_alloc_profiling_enabled() or not because profiling
 	 * might have been disabled after slab->obj_exts got allocated.
 	 */
-	free_slab_obj_exts(slab);
+	free_slab_obj_exts(slab, allow_spin);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
 			    -(PAGE_SIZE << order));
@@ -3498,7 +3496,7 @@ static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin
 	page->mapping = NULL;
 	__ClearPageSlab(page);
 	mm_account_reclaimed_pages(pages);
-	unaccount_slab(slab, order, s);
+	unaccount_slab(slab, order, s, allow_spin);
 	if (allow_spin)
 		free_frozen_pages(page, order);
 	else
-- 
2.43.0


