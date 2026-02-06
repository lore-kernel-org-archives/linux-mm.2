Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50ADDEB28FE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28646B0099; Fri,  6 Feb 2026 04:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1F06B009B; Fri,  6 Feb 2026 04:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F436B009D; Fri,  6 Feb 2026 04:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80F7E6B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 490E81C6F7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:31 +0000 (UTC)
X-FDA: 84413524062.21.F68AADC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0E54218000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="bkf2zLM/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PdU10YH6;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG29MvHNcn8aQcHmKzZMH2qnxCkEwIJa8UP/cW8BGZ8=;
	b=k20xSwWoFEHeJRjDIR1FaiojwbDy1IJWo8DXx+5I2jnkhOJMWiLB9yR6F+BZmXR+yKgc1J
	tOlomr61mgXp+r69UYrydceS7wGuj1svdnwJct726J66cA/q6NU/0Q36wLUHAR4GPzWDRF
	lbwNezUKrVeT8Y8RfsHRPxaZU0MUNw8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="bkf2zLM/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PdU10YH6;
	spf=pass (imf24.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370528; a=rsa-sha256;
	cv=pass;
	b=31vS29wb4AqEVKbKYulJKXSB+hLsJYIVwDDXYiX9z4C1GCUI6Hu18rr80K/0XHdCQWKQWm
	LVMUMtJ1KdHqmzCigebHIxOsdtUq15fRvEKLE5MLR6fIX2kJRruSDWwQz6pgqHDHoFjZn2
	BDwzo4A/BsOFdJqtaitEGHzu8s4fTJc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6165Piew482359;
	Fri, 6 Feb 2026 09:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UG29MvHNcn8aQcHmKzZMH2qnxCkEwIJa8UP/cW8BGZ8=; b=
	bkf2zLM/y5JNC08c8uy1Aa/EMbWHFmuewIORC9xy03ylnj4g4pntu8GbN3/g6BZ8
	pRCqR5KZGPwI30ESk5vmOrdsoIAMkIEfIv3O3LiP8h8l64vhOn+1VQaKSN38YUgj
	jHElt3inqIw0D+ift38na/Cno6QG6hvr4cU0y4LZBVusuyPHcRaHGqKXHPuMjJqO
	wq6jG7qczAeWVEQotU2vznSzkLJaC1RDOdNHl49FpilxcpsEo3ul50v8+UDBpVW1
	AHRozuZ6+fWnAp0jbhB22wxH04ZYXSchRatxClPHrMYaKWcu7vV9aKw4jW+oAtl3
	TktWKo+2EInGEqnquGRsMw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3jhb5602-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61686Av5006455;
	Fri, 6 Feb 2026 09:35:03 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012056.outbound.protection.outlook.com [40.107.209.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c257d0rgt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:35:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQzszfiyE5CLTxFETKnsk+f90iAIhfXRvXN0jB2zq4QM3t3DZpJ4YX10sRfXW0w47YSd8rMLy8tVjdTuFIbMeuZXdOqMKB9Pd50gFKY3es0Z9z5L1mNz67fc6L81gIq0HqP5VI4rTL0tlbgnp3WfS5uwPoBHu6mNd98ZRxW3Xc1bCeNE17aYP36sFxB8MVoiAYbQ2SsYmhDU9gILqyOe3FU6fIcjfFvzUAzZgKaJd+0F2T2MRutUAMib3wC8JmvO6P7TMEbWHGKzFbbG88PyLmu5owhazWCa/4bBNSNj5tpS7K56z75DB5uQ1VRyVDfh0CPnijrPQBYX2VXyFvflJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UG29MvHNcn8aQcHmKzZMH2qnxCkEwIJa8UP/cW8BGZ8=;
 b=tKmRjq8+G3urHEdnYvAFSuukZaJS5WdnWLjvA7nP0m56Sfv5FKr+FvKGg7MmK+q6gxtjGA1F30NjrPh0EQlJwpPTk+HrfIsV2D9m4GjVEMVwIFhDEKHW68VbnIk67PwIhi5y6xRSpi3QZREqHsbqygWwyEqEHU8MGAAK45RVps6jMn0cFfBVYxo6+zdd4rjK6wIsx2Ae7ibGC2mneJTANVRgjfSejlBLvDoZE+4zfhDxtbHc28d0/rcy5toG/84836nMACITr/x16yEw1hbKXLvmXrQkZ79RCjUvD9MZ6QuoSIIz0zq/2LCy7/Dp9+pzzssEtx1jXhZJGjfrhbBbqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UG29MvHNcn8aQcHmKzZMH2qnxCkEwIJa8UP/cW8BGZ8=;
 b=PdU10YH6JB0l/PuZ5Ltyde/NTnhQUaDSBKaBNv9GlyCbjEi9Y62HWgQEqsi3tmTJUHqR/ng3kQr866+nou6Jv97hI82Ss1PL48mwdzqV+3xOW6nK2zh6HkeNkIT8jXA298BmF97TF6dVBNb9ffHj26vZrG+LV/hhmd3u1Y9Pll0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:57 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 5/7] mm/slab: move kfree_rcu_cpu[_work] definitions
Date: Fri,  6 Feb 2026 18:34:08 +0900
Message-ID: <20260206093410.160622-6-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0092.KORP216.PROD.OUTLOOK.COM (2603:1096:101:3::7)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 8288fb01-bdc8-4c15-c467-08de6562fe16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fYVaSxOqccoeJDpbrNYvvrd7Vr9eJKFmoedEC2VOdGMxdzssKl0N2HxV6Gqr?=
 =?us-ascii?Q?flpYG8Z2cL9bvnqgrtFyc9l1GYU0CKb67RMnUHENeyUpm8hdO3hyF0E6vg2K?=
 =?us-ascii?Q?Xo7RgNmnzRjVESyYYQJjsw3OPfi4UPMJAGFNKngtBTDUJsh066KJUrvTxuX0?=
 =?us-ascii?Q?zyIAY7Sv0vdUMbTk/eMyaiZ6N3PQOlYJMi976dvxxSZaI4wxIDzvnHnP1ncF?=
 =?us-ascii?Q?Eff8il+Md0dBOPtPBOL3lEh2tO3tbjo+zjMHTkQSN6+05kJaTf5oBUPHpQwf?=
 =?us-ascii?Q?bwz9Fk8Kj9M+c7u/Do2g/yQwlu9nL9Ad9fOPBWF7CRaZ7VaA64eUuHrg1qjO?=
 =?us-ascii?Q?S3De+XCY3rTM4p8AhyvLnnqCYTJL0r/8EwPb/HWHg/gVn3WU2svBRZXxcAv2?=
 =?us-ascii?Q?fFPA5f2MxWmB+HkdXOxvhOzAsWdINCcKvH0s/2u9R0iNupq6bbPBrnyLRKXm?=
 =?us-ascii?Q?+cFgoHVLO8qkZAq7GLJHf5/RkYXSCId7Xs9KlFOl/NCsm/d1RJ46tiLUMTEk?=
 =?us-ascii?Q?RO2ct/AsjUUkDB7Mz8VmM8pPxGJwweH8tCSEg/XiPM4m1pNbpydNl2OvV3MU?=
 =?us-ascii?Q?xHhi9Kl4PPKI3XFj6AplS44vIntwBN3XLjmpJ3LhTIQasXul9ecvdY7y5emU?=
 =?us-ascii?Q?msYF7CrBD7ngB3y9aWQSFFict6e3czrHObODnTlkBEnPMoLEjT9d44zs0AaX?=
 =?us-ascii?Q?oo1N6hhgyG/c6yQxqvsJBynz8hI+lwuKdXkZs6kZlt3DG+mcGBJshgWsLx+8?=
 =?us-ascii?Q?Gl3dd4kdQNHuKhEAwNwHPIAsHM49KtQc0CGvS3tb1e6yM7jHbmorQ3I1vQe9?=
 =?us-ascii?Q?UmV22OJEMmbuIRXaqwGkee3BV6CDzP0R9kZbUMA0ormIOBZiN1YTtY1eZAli?=
 =?us-ascii?Q?ASxKNMW6hcaWYFKa4DK/zPj9oSkhmSJjU37ahGbPK5JQWk4W5+ORSuDS93bL?=
 =?us-ascii?Q?dokYRvIbAWiucalsfBk6yJKFq+INYsr6Gha+SQ7MQaLkK0JFHq3j3YJlrI3q?=
 =?us-ascii?Q?qRIL5SJeS5y8R14JrTRbvlmKwYANzYY3LU6Vhljt5hNOGh7JbZDlYYWMyDgL?=
 =?us-ascii?Q?vUyUcKY7kzsSIC/GLQxcMfJ5mP7W29LpisaiBwPq/v7/nH76JEsOwWLzY9k4?=
 =?us-ascii?Q?3qaVafuSVKsIxW2KkWdpR5gXpJXvp7f6iRNiTg5B4xTSs6NpMEPql/mkxzeR?=
 =?us-ascii?Q?KHCQTokjqVYvw6EtpIzyUyPd3WYiwpgWoJvvH3Nc4PHbzB2VOXTEnDOPOCez?=
 =?us-ascii?Q?S5WFmTk6mKAC8Dux1MxIrkxD2jAJxqMzRPUHgePa9Ag8cWELrPouPcToMtV6?=
 =?us-ascii?Q?GwFjbaD9rHnCqnhlfHmM0gLwmSJxlw7gQqipeUUnljvKlag91Lpdf6lDKA34?=
 =?us-ascii?Q?v+z3SovslIVSHMwBSKE73epNIQqYaBlFpV6Ln9Oq94okM536nSHqLLi48Q9Z?=
 =?us-ascii?Q?RxstPs1iuTQavGcQMqWgRq0St6yG9UxJJl6SQMOuEWfjp7wnDmYQTdWXKMAr?=
 =?us-ascii?Q?TyMOTNaoyXAy1ywJd99anxkgFmDpMfUfc7KTSqih25jaOY5qds9E6u/NxouN?=
 =?us-ascii?Q?pZOB1QB6D8mxqwUx6WE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fFSRRb3fNv093e5ACOYFTGKm6UKd3wiAQHkyM6IhbxJOFYMuEG/V1uVuwvrW?=
 =?us-ascii?Q?CW7Qey2zvm0bbk2qouzO6VNTWtoWMDknHscDcjvruZVG0ZBr51A12E5BSQFb?=
 =?us-ascii?Q?Onsg/EXMWzfXF5KEu81Kfj5xtxFNrJ6IiS+3Ty9jLNizdaLFM9Fa76OX2ROZ?=
 =?us-ascii?Q?de1UiEJlaC3kPxgJfJgKvzdBTr0i7AzJXftniCy1wRieeNgZyd40iABLzNDt?=
 =?us-ascii?Q?Os6D6mO2bebOkFAzwW6Zl3gtiRR2J1i7OTTMpxX94sOL1v6D2uSz8Anlbg7T?=
 =?us-ascii?Q?VJ6ijCPpVOWVkStlr3Bu2N0vtD8D4ad6DxDKpx6vJKbqY+yZ7+vbWt/VGJno?=
 =?us-ascii?Q?80JWO2WPEZrLgpH99iAGnXZpnQpaTczB8RObMsUQsgmxEmMxeP7AKClRBmZb?=
 =?us-ascii?Q?jcT9ATErCoJp5IwpDP4B58c01ye7x37JIYrrMnAulC0l1esNNpFL+tS+wOxw?=
 =?us-ascii?Q?zKQ+p42LMroVDOeMsw3oL9IAJAk9vlFrT/oNV1NqKjCPNnHQp6c08ibDe/Co?=
 =?us-ascii?Q?wLDRmaA0aYWpde3Dkti4CjJV68h+O+K0pi1lDtsF4QwpYfGoY+yFJBzV5HTt?=
 =?us-ascii?Q?k87fBAhwGBrOMcOlUCohHO64pTkIShX0eeog3DHhRRBJiqJv4pgT3MMRPYSQ?=
 =?us-ascii?Q?9/Bs8BW7PwSoQMg9cVH47U+ssxlMXFozVSUKTmBxcKBf1slLa9HNETKq7HUo?=
 =?us-ascii?Q?3PetROJOLuoYMxNSIbRZ1SdmhC7m4JcJ4Y7Hs93r2ezLuAKAIxNrEE2A3TBU?=
 =?us-ascii?Q?vFk2MKxzROkitvsx5DO4kzNoLPWxXq1azmVqlZTkgt6ueO9ZvvocLc/KvD8u?=
 =?us-ascii?Q?kXO3R6T629YZok9GpByizdBkYkmuuKbA6Js3BpRL44J64X4VywIbqqLL4+w7?=
 =?us-ascii?Q?JNUupo/lO7xL90Hf5rZcEQPxBQ1hx7len5YlNkfLWY4FWEFT8bgRc3CmjCkV?=
 =?us-ascii?Q?GogNZXjJ29qnInAArrdJxLvPTc9lt40uNnM4Vi3PfG0Dxk4O9BhGtIYcDyn6?=
 =?us-ascii?Q?1cjyRSxUt2yGaNphhbs5y18p/k5wn3xkMOmmtBlivN4PpYPONMz4TnhqBS7L?=
 =?us-ascii?Q?n9LBLdVs/eTM4H6Tli0KYay6p/o7jsyw7XQ4eHg8tNDQI9kEVaCSujvhs2Ap?=
 =?us-ascii?Q?IrpKQAze6TJD+992vvtIh/QtFTPjZerE8nVV3Vp4PhvnyjFWxSBdR0Bxq5j8?=
 =?us-ascii?Q?ZhFgBRC8pEmghU4+8tLvAIEHMtAyRhi+c6JwWQk+c9vXZqHK5KrIJW4CYem1?=
 =?us-ascii?Q?edYpQDEHNGGe/kf+NNRIjTpxD70O0avrEOijIIKqdnO8R7joaljPKOGVzlaj?=
 =?us-ascii?Q?kjf+a3AmiRxxEmQq+YdUHVcQOVKP1NKrKD66c3jaKd4j71CReakMlk5M8b/D?=
 =?us-ascii?Q?2blxBDCGA4p5N5qrkli59uSw2xvrYLaWWFBdLs8cMXdH32DCbyR3Wl8GDenn?=
 =?us-ascii?Q?xVhO35coF05205Syfy9ipFjd1svo9WibOzJIiS1RZEz42UlpbztHhmDna+1k?=
 =?us-ascii?Q?GNfn2vsUFiCdX2qCO+7MJpI1bjMtL6CFmo0Ed/sXSua3r2SIxZQ+lbstEraS?=
 =?us-ascii?Q?PleUp3zm8P/q8F0y+YJG0am1ZXenmTwgcMBwJ/JT4RrhMVOjf5/tZQqPqHiy?=
 =?us-ascii?Q?I7ryy+6wl0ohv36XZ0iGAChTY0rRofJ8MjyZxITofKhgejNAfU5+nIoXx7Om?=
 =?us-ascii?Q?oAH+YW5C2UANLvrXR77F7cnq4nGgF2DJrm9q3e9KOKdXXWp8FX+jRTk1Cebp?=
 =?us-ascii?Q?pk3WW3QOdQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I+ZmLF5ac3Wfh4ONvRf5uo6Hj6QTPEwpJO1pnXBcOVYCuLboKnKcss0M7KaF90sV3oDKuq1jm1FeBs3UILpQ350E3wIcfQLmd1i7Pb7Y0CY2sTWtgasqXFPMmSTxadMbrk6MNUuZbPsjhvJYpWx0r1EGhgnxerue7QQd4duaG3cABT53/4giGq/St3yGHcMRoQGLuDTeYdvuqQgd/1gqG1gZSifFeUP4ff25B41A1+l7uQ6+8Ubml1rJX895TPP0qxz3Ojb4qFv88o3uyT/86TW0SccxM/AQDFNWtQNHYPaXW1VlJsVIqU4UyqIhM+zhzqbxVdzQyDFr4qy32NNNhaz8G3tsutnw/urJuVLEDX5bcL9Eu+wisDUf/NGGOc/NGPjalT7S50Bi7GBQhya23Wsm1VFDeogcsMfIF4Ddlech2b0P8i3K3w/3chnefCW2Pz8TTH+STcA3ZaXoyidCibJv9AEnlYGCotG49P+np7l6WhuMlWT4AsanExRJUj0j42xuACJTvAI0dcZ6lq2hhaG3l5uwMKKUpI6twaKS5SayMcKPzPwobTyoH1SY09TQbmiBfqob35/d2aDpz9IwqNFN9yXU8+xPjSIHR86eoOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8288fb01-bdc8-4c15-c467-08de6562fe16
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:57.9062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dEBGwHX2yDx8pdQQZP/LJVLWbYZYASXu5SvjKgqMhXl0HaGOemeA4R/9+z5s6zpr2xFyaQeFk6gnl/Wyt3kPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX0mjDOdmGXSA1
 H7somqHmVSaLFj9jJFwz1ui/A99+uwPpdKmBz62LFVL8IxAACLsj3QPhPzg543gNkKKE3h3KYJu
 mhnmmWYDhayr+XNLRivU5LkVKtOWrQEAnXNoN9S8KfmPlw3w1++5RyT3brUlSkgDyB7oao+LTcS
 2TMA3AjXF9yrLW9EeK6oDG9FKc0p78EdE6vptch2yxuAoEcgNJt9tQAA3BSImMk1A0xwn2nDwUW
 KFtdIUY7skO2wlV9+1c1if3hiflYjAqFdBtlMOAZFAzbg7VCElPyOJVK3h7g4dCRb21fPZcRnFQ
 23I2nFR7OwGY8/nOfChfSHt7ZZbKPioJrNuz5BVGzlpBxeYW5yLuCL7msqLhXvNAbgxvB6NMv4/
 MoznwV9zBif/GKe97yzkVvaw/AYT510oc2bDYsr4th+bQkCdwDMQ0ZSuu7HFBprimN38MOQrniV
 rVw36PZALka9lCPHekkdgS7xQAb8lzKwWHSmB8xY=
X-Proofpoint-ORIG-GUID: MKzr9tQfqUWsZiYyay9zqa-tslzKofuI
X-Proofpoint-GUID: MKzr9tQfqUWsZiYyay9zqa-tslzKofuI
X-Authority-Analysis: v=2.4 cv=CaYFJbrl c=1 sm=1 tr=0 ts=6985b5c8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=wSXzSQS1JhNKc0FCJe0A:9 cc=ntf
 awl=host:13644
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E54218000D
X-Stat-Signature: nr11wsprs9qzqcbxp4ut3hkr86xttg3p
X-Rspam-User: 
X-HE-Tag: 1770370527-716511
X-HE-Meta: U2FsdGVkX197zbRBzYTxQ0jBOWkwUa5BjC9uU/F5I3mspzqGbUbuuDdwOo/7Ww8RKMh4mgGQD+ZYNei14xPCmEHe3KanXcnhnOBg1YNCEpTJz7ElxSJ7BFf0OzLssse085wsQUDxxozGTFhSqZ0nwY9zfUb7MGqjfshb2FDbzwqU/J1G59uhb2WB2PvcFxn7VcBFp3PuYswrl+Zp8rzmB00fgnMAFk++0m/5/NomZYBPAoNO9Y49vgi2aA6PDtS/9bjeNncM4YyuHPk87My96foPn7WAf6Bt3H2qb2btiw67/zai8zGXEY2fM5umarlaEwAMjOM6MSwtb+kd2uPANATuTpN4nf9DyOz89fqJ+A0qTMMvgiR/2kCtXhM1Sc6C9I5jVYNkalHuNlqCwtUpBTklU/wFAzIqgEb/WJlzkHLIIyA5LsYZR0M/9spPZq5gsQOa3g3JQaEXkYDHqx/hcU3nvQ8XgME7yIoYT/ZdAxYE2JKxFmwR0xfsNW2A2qbyd6FqCe8LFAcKCm/VyeOyukiYfQPOs0kjgC6tdhCBR9pLAGud8gDyT1GwLnIuCEI4Wk9BXSH4gyoDg7/LDd0ohm8ETysIHcO2kVsWVpGIWC8pAwRFkNqJZvf1goDzt8inyRYd2SIixsT5PlCE+jpkPgRqBLPyt9e80FQ0JfQrO77artQFRs8ar9ahZEoOkbXD4AsjftKhtuJtjZJvXSEPUQg2JLg7psEhYX/X3HW05R0ANH3djhkBIe7SuBNfkgEEVEANKA0rEEW2gFns0rvmoqbhhOI9iXyRMh6rp3om+gRJQzfXt8z8kDgeZDNSKSvvOuyqnrmNV75yBqy+PxjBTRZwa6yoANRXfZk8lWn5liwppxLNzeGVdDvijRkwnD7kuTOQu2yhuulki+NXghi0/8t5WwknYKjSZABi3KmGnoLpEpIwvDUAlEgX9aIUtsC/5Tjkn4wnCqdXGxa/Vgn
 H4li8iHU
 dyEHAwY+EGnRpAhgXbEvU/e/DvdDf2SS0eZechGH3wHJ0Sj6APyCaSNz014A47GxxV9wwCutlCxeDFG6XmdjsD+om7dDieBXKYgVSo3jZ2qZM0zi/JeOUgmghNJN+z6mNOdDMCd5loQt4h3jWD9GFZQEJIRMpOey3uIno/P9LuWZx1q/UUF2I9HuyASc5RdNLQGGv6uevURVU4SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for defining kfree_rcu_cpu under
CONFIG_KVFREE_RCU_BATCHED=n and adding a new function common to both
configurations, move the existing kfree_rcu_cpu[_work] definitions to
just before the beginning of the kfree_rcu batching infrastructure.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/slab_common.c | 142 ++++++++++++++++++++++++-----------------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 3ec99a5463d3..d232b99a4b52 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1263,78 +1263,9 @@ EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
 
-#ifndef CONFIG_KVFREE_RCU_BATCHED
-
-void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
-{
-	if (head) {
-		kasan_record_aux_stack(ptr);
-		call_rcu(head, kvfree_rcu_cb);
-		return;
-	}
-
-	// kvfree_rcu(one_arg) call.
-	might_sleep();
-	synchronize_rcu();
-	kvfree(ptr);
-}
-EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
-
-void __init kvfree_rcu_init(void)
-{
-}
-
-#else /* CONFIG_KVFREE_RCU_BATCHED */
-
-/*
- * This rcu parameter is runtime-read-only. It reflects
- * a minimum allowed number of objects which can be cached
- * per-CPU. Object size is equal to one page. This value
- * can be changed at boot time.
- */
-static int rcu_min_cached_objs = 5;
-module_param(rcu_min_cached_objs, int, 0444);
-
-// A page shrinker can ask for pages to be freed to make them
-// available for other parts of the system. This usually happens
-// under low memory conditions, and in that case we should also
-// defer page-cache filling for a short time period.
-//
-// The default value is 5 seconds, which is long enough to reduce
-// interference with the shrinker while it asks other systems to
-// drain their caches.
-static int rcu_delay_page_cache_fill_msec = 5000;
-module_param(rcu_delay_page_cache_fill_msec, int, 0444);
-
-static struct workqueue_struct *rcu_reclaim_wq;
-
-/* Maximum number of jiffies to wait before draining a batch. */
-#define KFREE_DRAIN_JIFFIES (5 * HZ)
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 #define KFREE_N_BATCHES 2
 #define FREE_N_CHANNELS 2
-
-/**
- * struct kvfree_rcu_bulk_data - single block to store kvfree_rcu() pointers
- * @list: List node. All blocks are linked between each other
- * @gp_snap: Snapshot of RCU state for objects placed to this bulk
- * @nr_records: Number of active pointers in the array
- * @records: Array of the kvfree_rcu() pointers
- */
-struct kvfree_rcu_bulk_data {
-	struct list_head list;
-	struct rcu_gp_oldstate gp_snap;
-	unsigned long nr_records;
-	void *records[] __counted_by(nr_records);
-};
-
-/*
- * This macro defines how many entries the "records" array
- * will contain. It is based on the fact that the size of
- * kvfree_rcu_bulk_data structure becomes exactly one page.
- */
-#define KVFREE_BULK_MAX_ENTR \
-	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
-
 /**
  * struct kfree_rcu_cpu_work - single batch of kfree_rcu() requests
  * @rcu_work: Let queue_rcu_work() invoke workqueue handler after grace period
@@ -1402,6 +1333,77 @@ struct kfree_rcu_cpu {
 	struct llist_head bkvcache;
 	int nr_bkv_objs;
 };
+#endif
+
+#ifndef CONFIG_KVFREE_RCU_BATCHED
+
+void kvfree_call_rcu_head(struct rcu_head *head, void *ptr)
+{
+	if (head) {
+		kasan_record_aux_stack(ptr);
+		call_rcu(head, kvfree_rcu_cb);
+		return;
+	}
+
+	// kvfree_rcu(one_arg) call.
+	might_sleep();
+	synchronize_rcu();
+	kvfree(ptr);
+}
+EXPORT_SYMBOL_GPL(kvfree_call_rcu_head);
+
+void __init kvfree_rcu_init(void)
+{
+}
+
+#else /* CONFIG_KVFREE_RCU_BATCHED */
+
+/*
+ * This rcu parameter is runtime-read-only. It reflects
+ * a minimum allowed number of objects which can be cached
+ * per-CPU. Object size is equal to one page. This value
+ * can be changed at boot time.
+ */
+static int rcu_min_cached_objs = 5;
+module_param(rcu_min_cached_objs, int, 0444);
+
+// A page shrinker can ask for pages to be freed to make them
+// available for other parts of the system. This usually happens
+// under low memory conditions, and in that case we should also
+// defer page-cache filling for a short time period.
+//
+// The default value is 5 seconds, which is long enough to reduce
+// interference with the shrinker while it asks other systems to
+// drain their caches.
+static int rcu_delay_page_cache_fill_msec = 5000;
+module_param(rcu_delay_page_cache_fill_msec, int, 0444);
+
+static struct workqueue_struct *rcu_reclaim_wq;
+
+/* Maximum number of jiffies to wait before draining a batch. */
+#define KFREE_DRAIN_JIFFIES (5 * HZ)
+
+/**
+ * struct kvfree_rcu_bulk_data - single block to store kvfree_rcu() pointers
+ * @list: List node. All blocks are linked between each other
+ * @gp_snap: Snapshot of RCU state for objects placed to this bulk
+ * @nr_records: Number of active pointers in the array
+ * @records: Array of the kvfree_rcu() pointers
+ */
+struct kvfree_rcu_bulk_data {
+	struct list_head list;
+	struct rcu_gp_oldstate gp_snap;
+	unsigned long nr_records;
+	void *records[] __counted_by(nr_records);
+};
+
+/*
+ * This macro defines how many entries the "records" array
+ * will contain. It is based on the fact that the size of
+ * kvfree_rcu_bulk_data structure becomes exactly one page.
+ */
+#define KVFREE_BULK_MAX_ENTR \
+	((PAGE_SIZE - sizeof(struct kvfree_rcu_bulk_data)) / sizeof(void *))
 
 static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
 	.lock = __RAW_SPIN_LOCK_UNLOCKED(krc.lock),
-- 
2.43.0


