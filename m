Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80577CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 21:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A3C8E0003; Mon, 10 Nov 2025 16:37:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31E38E0002; Mon, 10 Nov 2025 16:37:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9728E0003; Mon, 10 Nov 2025 16:37:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6EC8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:37:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A61513A4E0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:37:40 +0000 (UTC)
X-FDA: 84096009480.12.7F34CC8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9283E4000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:37:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Xa7T/ziZ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jwujcG32;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762810656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDbYUXcmXbzT5A4bwDMxlHMk65wmR3Mh+tNApS8a404=;
	b=jodRE7dQ7a5UWgxYgM4+TETkdxr9fETJFb/dBs7jCEJae8PGTar1wFIIc/qugM9sDJ50dM
	huZoMrhKxtRl7Zl3IoyvW7zl5yYuzfq/qy8kSQhpHQV3KqMCzMOAeiULLcIHXCxea/HlFT
	D/9vLSmHAjX8LIWKMagje1/KNVcXGWg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762810656; a=rsa-sha256;
	cv=pass;
	b=rpU+YDo4jm7M1OhQ7oKGmL7z5KFdG1g5eeoUKDfUy3jJ9wDlLV+k067dTFyFd+Imjoqwg2
	R7f64b4oGDb+CoU6FwGCBFQfK6amj+AlZiHhBXQ0+y29pFfLNu1/w5vni/0nVjUsC4Ik83
	eXHt0Q6BY4BCxfzbgy3MwIp8lFUuvlM=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Xa7T/ziZ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jwujcG32;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAKc827002898;
	Mon, 10 Nov 2025 21:37:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PDbYUXcmXbzT5A4bwD
	MxlHMk65wmR3Mh+tNApS8a404=; b=Xa7T/ziZQBPjy25jWbsnts4dCZFekf6RyC
	9ql/kEme+x0kOOB8qmFTBD/qt7rgf61BQAAYSV/FJrpveDfBggVhkCYha/6buy/+
	EUbG9L7D9c7+A/lKAZYYgqHJe509AbP+6v+eEaJf+6UwT+EkvqCSAc9H0R6pWykn
	0s6oDmMWqHY3S+z1qnRPYon4mx/YZVHNWgIa0BnFPcaJmtiKNt6HVdIGn4W8Z3UZ
	f0bP7QLqAT7gERjnLLWWbExr1nKyKdwFpunFjJ3kkCqsCjdfa5uZq0eAbQ+I/io8
	NcKMR73i44XhIg+be8rt+BYMnX0SDN/rNeKW0wBeZYq6e80s9ZBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abpmn07hn-10
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 21:37:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAKST8u007604;
	Mon, 10 Nov 2025 21:16:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011013.outbound.protection.outlook.com [52.101.52.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va975cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 21:16:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FbCqV04VNShGzil5vqteZzsV+3rLOBLiuN1Qy9uLb/wGhP+lyceY1efRSfYqbkXR+VH+TEljZnTR0lAor/NfSnFApvSm3m1bfxyHsv97O8O5wNzobIP/K33aLtO5ioSq21sgJRYj2FD7+RTXgWoXAf7g72/vnM7D5sVS+yKG2a4C5iX1sAHgYo9h9wll+/mA/sjNacH2iGIj9ynKhX7L4q88lHWyaNOC/jpEfEMQHQmD2KIAa4UJNUr6w3l5gQ6rOwct2kiIxhWCaXBQRrnp9kE5dfVw1MIeS9cN7zYHT2g24MeofXB3qAb29TwKwISrjDxEAjiFLwalKxFB9EESrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDbYUXcmXbzT5A4bwDMxlHMk65wmR3Mh+tNApS8a404=;
 b=PhLqsHzzrloumFz3eA/L5O3wIR43P4EZ1qFLlYW4RRZt7LVigVZp2fsr1VBeJGBHzFS39jaCDbXJewwy+DqUNJLrrc1eBccz3ZmgNosYIUx1tKHdysl/iq1llTkP3ZcO8c9AxUjHy2gpTUJA+AJaKuQ+L2vmfzQY6SmXX5Zz3Po+SRTQ02alRNHxVCbuJ/vw4iqmUn5vePipXAe4XJPNTgNugOFV8/UUnDFBWeYQ659SSJo27GAx2HAOrb+NvoEj7WC8z/InPDCHJSO4/SHGkOaPm73OvJQMsEW9ytAH5Re0fYm5f8GNxsNyC6egIIN0n36WOD2jJhficBoFOdLHbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDbYUXcmXbzT5A4bwDMxlHMk65wmR3Mh+tNApS8a404=;
 b=jwujcG32slA6YKSLVweTdQOH+6Id/EXPcT0IUTFZVs7JX53X9LuSRWVnmNXuHJJ9u4pLU0DNQzDZK9m02IMmWU2K66LKea1nujee43++uSh2Y2iU/Eaa87j6j+mlWbNGiAzTRnqlj1rQAY/grl49MFGfXwK4XAGyfaVeDeZsn5M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BL3PR10MB6161.namprd10.prod.outlook.com (2603:10b6:208:3bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 21:16:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 21:16:26 +0000
Date: Mon, 10 Nov 2025 21:16:23 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <b12340fa-358a-4799-a040-636994beef36@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
 <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
 <69FF5A7F-1414-4DE5-8A2D-09ECE240711C@nvidia.com>
 <77925a0b-fa06-4200-a967-a66bd93201db@amd.com>
 <27920b64-240d-40f6-a02a-0a8c433ca9e1@lucifer.local>
 <ec53bd13-42ce-46d5-a1b8-c4157663b60d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec53bd13-42ce-46d5-a1b8-c4157663b60d@lucifer.local>
X-ClientProxiedBy: LO2P265CA0191.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BL3PR10MB6161:EE_
X-MS-Office365-Filtering-Correlation-Id: e0adfc95-5a9a-42bb-a5fd-08de209e687d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ON5xqwQ0lqVDlVmeR4/TscgvugaL41JnaYFc37hMUZwKRKsHHZpicmLXj+Ke?=
 =?us-ascii?Q?108XWtHvRP5WG7im1aHZEFfmPKRJFRaNXN3GoDmAQ0t3jymdyRJV0IVT+eFg?=
 =?us-ascii?Q?QGNQDPHNmKqejrFsnRxQ1PoBoSJ7j1PrkUp3OgOEUtpYHUdRmdWy5uPJMf1q?=
 =?us-ascii?Q?iXlWIaE3K6qdNR+EF16/fzojh8U4MahbK8t7AB5C2jP2Y+szTJA/BD70o+ke?=
 =?us-ascii?Q?pjjuvzY8p9QmGdqUkA+4hzeTU3wVJyzuGCGay959LPmoRNjg4amgiGA/7ZnA?=
 =?us-ascii?Q?8c3E4I/EgARJPEikmeX90/SYqJbFahxTV6e2iwQMrR9J/zZgYFVMKzQwuotG?=
 =?us-ascii?Q?wXSJjkv7szqlTmBfjQEySs1y3xYTtr15XRdfN5Y2J5z0I7O2r6eXJ9n0Pc8S?=
 =?us-ascii?Q?KlEDBSIH29+MVE2eazKBSHx3wMr1o3EDRzKTYUwGRQBMcxJ/Gi2ykRDa6hUq?=
 =?us-ascii?Q?JN/gocbwnCQKOWpzWF1F6k4X0PVLALET1fAhGcVSB8tfFEkEy9IPiVz+J3kp?=
 =?us-ascii?Q?KHB5i+/u/ZV/q3TBcMvstEZy/nCn0mV35hZtsyGcLJMyhH472xH8fhTQfpJD?=
 =?us-ascii?Q?SATHxfdhse9a8ir0NoRf3YGpqdiaqAMXa2zXOQYg8oDuawyMx87oL9gai5q5?=
 =?us-ascii?Q?g0hSZQi2XKCh18l8jpkWklWrxOjZUgzEUUTqmYnaC5sL5308IdupO3YNuPPG?=
 =?us-ascii?Q?wWgsd4GwA7hNRNmPs2V7pq95jakgh5eYfwtHSSZcYPsGUSefGlBW53I1neNH?=
 =?us-ascii?Q?bUvRwmKZqSad/xykf2AaS/gt1BwhQEaXAN3/QHoduQ+23/Pcq54T398fS2q4?=
 =?us-ascii?Q?xk8Xb8f+L5vw8wSSVyToImo2puVB4Yzsl2yWKDJkDdDeeMhbiqmwOOB2eIiZ?=
 =?us-ascii?Q?LQIJPAUqgZ2jHGtbDHTkVBzzLyZb7uT86Bc2FJHA+sICw9twYBDeagZ5+SyJ?=
 =?us-ascii?Q?/OSG6tFKrt/XTkpsbZhMfF1otXyUtNA50WbE6wM511Yct0CPifkpusDVzIlE?=
 =?us-ascii?Q?tq89k9sKKhPvIPDNfIwr83s72UYSgNgEzXHpKe3Wbng8gieg50KtvUKQRuYF?=
 =?us-ascii?Q?yMOOFwE3dCGygzvqbMRSHSKVt9rN2YdY5ylep58EvfGGaIs3wlODVuEjUcTX?=
 =?us-ascii?Q?aQzpeFgSteuN9CIAZjpsKi+W+bSGrkk7nHlcFkgwdHV0yEYdy7si+I7NOjjU?=
 =?us-ascii?Q?4VAyce//BNJNABTFuMV4DspN2ofKJFW621q0MjVvLxhQ1Xs9X4I139XvzoSY?=
 =?us-ascii?Q?s9wndz0H+Gfet0JvjYoz7bqixvb3m7Q7T18NMAiuOu8zldRSs18a/XzxyNNz?=
 =?us-ascii?Q?IklcU9DGk62258ESO6WXoHnEtJjuJv9f1d4gnFCNqJajXBDmRy9LRdhfAZvf?=
 =?us-ascii?Q?hVtJQ17ACbWU8g0M8ttMoXhO/ZNkfV0LsZGZdV30/z4Ycf8qty4lA6IpPhCY?=
 =?us-ascii?Q?UhULoLuzLbl16fC4V+rNdLRimAweo7Ui?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HQZdNo6beGp93W9oBw+A+IjIurV3PaUX4vDyyoVWv+B1RV6e+FmcGRbZX9Xj?=
 =?us-ascii?Q?3xtDtfuO/NAT6AY95k10pxX4zjajd+yi0CPymYumRgx2B6n4NZonviH3xviV?=
 =?us-ascii?Q?2VG4UZpIiTi4NKbdpgaZ8Vk8wLkBdz7n65u77I55LjwtkUNOHI3VYPZHwon7?=
 =?us-ascii?Q?BvMuWV1K+QkECGuZetbTBH6/kdfA6/USaYQ4RxvYQywxiPZLt/CKgKgZRZFK?=
 =?us-ascii?Q?bpFd4ZQQAtmSU6Sd976Q0Ic+OkKzSffr/26N5IxQ59ZBy320YMW4NoMKOJof?=
 =?us-ascii?Q?44hCYH03x8/2Cmy0ltgOzHCeFdvepQ8yo90Qt2rXpCx1a06gtGhX/X+3abIe?=
 =?us-ascii?Q?wt/9u0nJZ+Wf3oqINytiENV6uw5bQcdWdxhIHwL1wOQV235NjwVYOIkSsnwo?=
 =?us-ascii?Q?BPFM214rztZZTT24n62E1lqkT84ZfOheJm2XKFRpzzP78oaJ2E0GMyz2JB5I?=
 =?us-ascii?Q?+XvRwGEBBPMaUJmU3PqIGtlRv7R3mx18WuIHaYLPtgMYuV7XDo58nJbutsTj?=
 =?us-ascii?Q?g9hzlyA3Qb2+kqH9xZZMjG3Xq5EO39wdlt9cT55DUy7omvh4EoqGTDFQpyMG?=
 =?us-ascii?Q?ZesoBGzPbvy9n/QMOpd09g6AY6PQ/padHgENMd/oaHvNceXUHCeRX6QAWii4?=
 =?us-ascii?Q?GsZyVtwn2C2kBxwbwFwxF5pvuy/VxdxAbm+WYMqxuag+Y0IMXBS0/bK5ybjb?=
 =?us-ascii?Q?Iul5D5mxTMyjBXNEP0uM9Eb/SwQN3EqjXUDeDC56oQHTcVTIrQW+504RM82a?=
 =?us-ascii?Q?ZVpdZH3FVcR/R9Dq6wHLWtg46nmylhUGyoCPH/7AP3OphH1bUetqa/gK91EH?=
 =?us-ascii?Q?sKidwXt4ZtGwxLZdBjyFzQLp+a0Ysmu8yExxzodexvVUVgYVvizsjWOSoyZT?=
 =?us-ascii?Q?0ZhHy2m1EbSs4iG+moiOulc3ZykHC8m6FD0+ZGH3CdjmYiUEcxQZU1OU5JyZ?=
 =?us-ascii?Q?LZanW/rjovT3ijStwV2PYYSrHrgKOcaWYiycosEN4iFuXFmtUw/2woEuHZfO?=
 =?us-ascii?Q?vVOtcPrjNXKNuQfvbEo/SX51DpZfjB85I2BGYTPcrcwzxGS4pyhTRDBzmDWo?=
 =?us-ascii?Q?NrCa6Z9itI1M9EeO2ulEvybcR95PYSzrB1puegWSoh//jwTSBFp38F+128UQ?=
 =?us-ascii?Q?5t1N3zJ6OqEJdVGpBRsO24vaZah27hsSPqtC/qu1k9rZ9PSJAYcHO/dasgHF?=
 =?us-ascii?Q?pE0Pj/Md9GC7FPZsenHPYfCinYKYr6ViUC5twvCU+2XoF3zyxB/FIsGWQdk3?=
 =?us-ascii?Q?SJDL0xXykJt5t+uNz0ZCs4ubEcCfWfiGBUkyRe1XxTzk1QdqDAyCQA3HZQMU?=
 =?us-ascii?Q?9yI6ob/3mFt3RR9K/O0C9SxSuvmvcRYn7DElclGH2knziEMpOUtbruGyVnnO?=
 =?us-ascii?Q?1DFVIx1rlx32lPbXW55uxIi3LwJHIRu5SqM+jyAJC3XDr5YYX5rBZGodSh8c?=
 =?us-ascii?Q?Ytp1RESh1zCArtngU6b/RGSsfVhiup5jakWyfScpnmuTVg6WouI+cyXRPc5B?=
 =?us-ascii?Q?55wxJIzv4gORDtqT/ZItVNI5yvEwBf/6qVla5Bsk8Cb/u6p2++ZG8hw3UTLw?=
 =?us-ascii?Q?KtrwxMo2vK+Dm3uJxp8u4fbQWjsmbZA9tJYc5Rwb5FjVgSdIXdk4PmT7vFBD?=
 =?us-ascii?Q?Ew=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h/iXmcTPZ6Fdz5fvxpgGEnucIpcPgRbAEGKZH9tM9iAAwBqVg201qtvOtAA+Z1ID2dguF64xHlc9fW/SBkXyxqV9dVmPTd0ZJW4MAa/qyFY9/9QFNB/N4/KjxWn26mFcpbag9S6LyB5YW4wtcdWWadRrDDiFSuRvMrXe5HtF1OHWqYQNH4YbX7X2G3gxp3LGI8ffNZgWlN9inyHYBniF0ZbYkyajlXdmQGDaNmy2LG8wZH5q9dXd8FWkr2XFYwOrx0J4Bcier3tj+Uv2WJNOJeriHBUWb1gv7YPPCmO9vJEZFQNg0UUT18DMiQgzXRRP7iZqs11FKpwkE6kWUnbVPh8Krax9f40+NOYAzqlPd+2tflAjmbaZd1ZASqN4qDQIZzSPUsxWCYBA12gJVBi07zYN5Uo8KnofI+yfiOi04j5oSIk2ewF+kI8LvoapnjI9l0DxYqPEBdKDIDbSvvLBbrjn0sH6n6ORLHw/7yPuh8RUT7e03l4Ed0AarS1mX+yrLg39L5GUFObL3rgg0BDmpyGSzqsMSRa7crt12Pu3wxw9KwXMixZwcqJVfl4/0tfCrooFgMZ/Tlgpqx0MICKAIkaDOpykB0qBUejJwuuh9Zc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0adfc95-5a9a-42bb-a5fd-08de209e687d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 21:16:26.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhHU+ENP4wgwWrRsDmKuCDaoyTnHUjCnkF2TcdFl+BteCBHxHdLIHxYkKiau+uv7Ovz5FWmhjPn35wbi6VGnMo+xzLNBZgUCO0z5mlx9BYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6161
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100181
X-Authority-Analysis: v=2.4 cv=WP5yn3sR c=1 sm=1 tr=0 ts=69125b12 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=BEE4suQrrqTfocDoTAEA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE2OCBTYWx0ZWRfX7tp4iyw7imDz
 hTknqAGDf2ZhSqRxrbNHgcieMoH9pXW3ssTYCm4c15WVlxIQYyTRo641Ym6tVMN9+Fhjr23f2Ni
 FX/qh8vPSOTdzPXIakxj1C9azXJbaAj0hF5PWc3TfZn+V3eTl5orl6BhtxhoMmVgFYw8f5iOBc6
 xJKKUcYdy51Srx0SdnDHOjmV0tIiXHXaHm+fSGC2/vHfDR/QhCrP+f/pL+iisqEt5191lDlC/N1
 XPne0uHl8b9LZLOSAbb5tpSTDPQjo8xWaqBButXbyhreSgLxAFrlI7LfqOudBf7Mpo4s18Jnu4D
 iyJaqu/jGlFAtJozTbD39H8iFt4/WzpFB58gC6pvEewVxA4Y2yZK7Yq9LRAndT+zqc61xVuNjrv
 WGCciNjZBr0L/YHabunLcvwemIp6/g==
X-Proofpoint-GUID: 879VCRmA7PWfa6YJzcJrPyEp8M4JhMRI
X-Proofpoint-ORIG-GUID: 879VCRmA7PWfa6YJzcJrPyEp8M4JhMRI
X-Stat-Signature: 5ap3euoomn54b3ujpiqdfb39rtutgssc
X-Rspam-User: 
X-Rspamd-Queue-Id: 9283E4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762810656-311627
X-HE-Meta: U2FsdGVkX1/afBdyAGbUlU+iZPtfWORARmZxDa0UfAIFMfdHRVM8W52vB4ypN+85wt+1bNsi4e3r0BNQZlaTSgrp03DE/QJlh3qPZ3wwerhpcv2y5jfaCS30bkgyhD8v2Ljo+mBLXEU0XnbAI8VG8e9wFBzMWl/vfLlhQ9hqCCBnbAkykBwzOXTIIuYH/Z4UafOL5lzfoFX86P92ZQaxqwqAKsWkl7cXe1lS0ctCo7fZsKdm4/Kf0eERDiYHNmPk/942gRw02A+iFnSCkQjmMB0pX3fPd76xiNyTuX/xWbefjzyE0Jpg69Y8Ezwmtc8YOeNdCqG8xV1thG/2pXb4+Tc4LSU+ZwRydllA8HVi4IAXFUn90Dg25lnyes/qeIcRxNt5/b+9i+JSYmU2D+R6t3svPkOlF5DUfCM5zIVhLy6xw4QjypTrHkRIUD9clFT20dQn/7YMvEzlQi0fiw1XY7UPIFk/2yiclkmmTQdAOLwQjI4jDFWa26i86YgQ9cTilex0Z2e7Jp6ogytl+S8xAIz3VTsW6sC5e8QZZmR2SnuOlGgLnV7l54+OHAoFMIlVPFfbgSWtOHuzvZGcbSuTmFRwMjNxUQHh0EbzXgCy0BJzyBWaGqkPQY3q+8J6+Yk1FC1QMrFJVF3n7hrxpTipsEPVzByyi4kbUxGj5VopA2yGgnPkw+VvjTfDkGp67722aONIE6CKZFvcXjwHma9Pu0vXXQjauiMyIF5UVgR1A25yk7vcgRbs+JMHz9LHcrpv6+lAKhVElUcvlmLvv23EQ9piD+27dgsR9YNAlombY06pKTBIYQ0K9TRLfQwNNHOr1B1WJR4CUVEQtbjiIbC9gqK6FIgK9+bw5z+9b3ayDjiEDbEZ62US71jRd9bPCNrLBIZNZSA9anAwymvdcpJ3GB9phmJQ8OuwoQ9ec1vcZBPUFRLzWFO4O108xzl5JNOSUQ5LoxJn3Qjqb8M1Puo
 iirI4s1O
 59289gosz8QIlH2GDDeS+G1K0wqv/7HW+CIdaJdOuZstNfuLk8xIldxHJQgf4FZOdx50gPcqy5Wx4yg93LWnoQmzbVX2biUHytPfSTIlvdlNJLGGgHb5A2M4WjDsiDKUngxGuiAUUNkfnq92xCUaDMc4tq4cR62nqb495bbz7Gsv8//n2Xub4LMCZRFZBPWk5o2GswAposCCwYnM/7qp1AQeqVdd+4+nUwb9ghB7cpyZD7iw5H01ee33QRKhbdLK6Yem9+tK77Bazd5XBtFBhh9qKM/7Hj1rrpENJvcyp7nBYQiLjDTwCgGQzfhlrE/mxoDy0vRyJOyFcMHWCh+kZnffqmXKxv5Tsr2e1FgLGQlvLSPWaxvEwUxfIdwey43h34bmSje134ZQFhxAcSoMrKwqG0DjLP2rS+wFcE12S8n3g3B2GXXmlOZZMlal5FqAn13gKVQD3USqcVo39niP9JlPwBi5FNTtSlZsc75CIfMzGTGOwEAxyC8STfHahLCz2InUWSTHaOPjnbCw/hXmnX6zRtB3IxRR4C1syO3j4M92YxVBRp0/mS0EsLg/DuF+vhpGX5HvvDIehiaMEzjLi+C12XT9t4UXQC9vIq1uhkmBo+rgJK5AvfyiHjiF7uvEaO5hLMMI2r3vaFGMktAFQ7f6Pk4SYUAe/jRquPb+gJ5ybui5SEC3GfKqeyX11FBV4vFyf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK ignore the past mail, I have managed to repro this locally and have a
fix.

Turns out the swap code is doing something quite insane... I will send
fix-patches to the series shortly.

Meanwhile I attach fix-patch! :)

Cheers, Lorenzo

----8<----
From c705fd85a806f53017df31e6b072c4bfa839e3a2 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Mon, 10 Nov 2025 21:11:52 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/leafops.h |  4 ++--
 mm/swapfile.c           | 12 ++++++++++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a464a7e08c76..c4cd36760ea0 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -56,7 +56,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)
 {
 	softleaf_t arch_entry;

-	if (pte_present(pte))
+	if (pte_present(pte) || pte_none(pte))
 		return softleaf_mk_none();

 	pte = pte_swp_clear_flags(pte);
@@ -95,7 +95,7 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 {
 	softleaf_t arch_entry;

-	if (pmd_present(pmd))
+	if (pmd_present(pmd) || pmd_none(pmd))
 		return softleaf_mk_none();

 	if (pmd_swp_soft_dirty(pmd))
diff --git a/mm/swapfile.c b/mm/swapfile.c
index fd23d9f7ae10..f0dcf261f652 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3202,9 +3202,17 @@ static int claim_swapfile(struct swap_info_struct *si, struct inode *inode)
  */
 unsigned long generic_max_swapfile_size(void)
 {
-	const softleaf_t entry = swp_entry(0, ~0UL);
+	softleaf_t entry = swp_entry(0, ~0UL);
+	const pte_t pte = softleaf_to_pte(entry);

-	return swp_offset(softleaf_from_pte(softleaf_to_pte(entry))) + 1;
+	/*
+	* Since the PTE can be an invalid swap entry (i.e. the none PTE), we do
+	* this manually.
+	*/
+	entry = __pte_to_swp_entry(pte);
+	entry = swp_entry(__swp_type(entry), __swp_offset(entry));
+
+	return swp_offset(entry) + 1;
 }

 /* Can be overridden by an architecture for additional checks. */
--
2.51.0

