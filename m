Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74808CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 19:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0A08E0003; Mon, 10 Nov 2025 14:48:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA7678E0002; Mon, 10 Nov 2025 14:48:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EC68E0003; Mon, 10 Nov 2025 14:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A452C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:48:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AED9138F32
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:48:59 +0000 (UTC)
X-FDA: 84095735598.04.7696958
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 845284000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 19:48:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YW7tDULH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="L/hGfOs5";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762804135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxOZV8bd0tKnrvTaGuZq2lWkzFu2kDixRrtgSdDhvLA=;
	b=5MzFCNVsbeK3eHbKZNh8MLv9CCQWQh3J2/jQDfWqZJ8x9Nzw54ELA0u+YqIObiWRMUKdJI
	36JZPVUUSSFkCq8KcULXKelYe8KBODmA33OplUGzXq7dD3kr2FpwPWeB5s68sdyQP++Jpc
	79qL0wU32B+6HRrKZKiziWnTnzIVYvs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YW7tDULH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="L/hGfOs5";
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762804135; a=rsa-sha256;
	cv=pass;
	b=xHkgbMSBmXa6tRsW9LZC4S7pMcWJ3UPzkmFDXHXh8WX/qj8aqh8jWMUBCc0EixXSULQ0NZ
	5Z0mlR68UNlJUbYJIzTO2m0Um61kCdkjlGF9fvqQHbms1dl/Apcmd30zDsexfwotZBMaZj
	bWrbfz2QrGyQJVpvC9Qs9goXibVQQYw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGuu29006744;
	Mon, 10 Nov 2025 19:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mxOZV8bd0tKnrvTaGu
	Zq2lWkzFu2kDixRrtgSdDhvLA=; b=YW7tDULH2NBo9mKGCdDfwAciNOWHzaRlNN
	CTrKSjsRu4kRUWI3gfg4zszEt8m4cCCs8tprVmB7jqf4RPM1593ScaIZnK3i1SQD
	FU+gLzf8TrEJ4EkXaqMQufMLEn8I3nlFjVNkAoAgZFQCxpqwiHKrGDH98lu2QV44
	V4ZBOMaO8iEHZjVisXJJWCUbbSL75dHrEikeac7mQrZkgGVd+R2gHrqpX3sBxKsJ
	a4lzwd4P/ZBkNvs6Xcoioov8Eq00TDuRgdYCD+mOTGUa0OtVU1M7+fXbene9F9aG
	XxM0h2mD6Tk33G/GDFSfEwY3cU7SDeCqjzrnvpEz8/lkB0YDOdHg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abkb6gjj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 19:48:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAIT7GM000936;
	Mon, 10 Nov 2025 19:48:41 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012042.outbound.protection.outlook.com [52.101.53.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacm2pm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 19:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYkgTnoFc2t7bzzaIs6hY3c24dTKjVpNtKUmKNbf3UhKbFERvTaEnfJ3+DSjOVlQ+Uv7sWi6uayM81/n3nmJuNBeRd2wcluPyOSpUgnD8lgnXQvMDYj7SMieWCsoI+D7Xg5UP2SpFELeG+DVnjI27gprRTTgZhdjpZG/enckAfgwiKIF/J8EqmzzaMXAC2KEXASTtrxdCegyJAUcYiuY3DE36iO5mvjCwWMv3VE2u1/62C+PG4y52CGayFDZ5otas4lMoSIHJb+HeFfJvbde3NNZMBSARR3FofyPV8V9V0d+GtJIZ6Xrr+ebkoyLl6hXbQLwZwrP6O/ZfZtl14W3yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxOZV8bd0tKnrvTaGuZq2lWkzFu2kDixRrtgSdDhvLA=;
 b=CGeXJTy4nFbRmWvXG/TvadFnTlPKIOMyR6Lqc2HJCCJl9nblpfrvPYWRlVo96udUZ9X+Z++ETmdKjH5XwKDOkFjHYeZhNQGcIsu/3UPbpjWEveu6CXMHSl8D+S3+dN3GE1+kzRb4z8pMsKEDWyPQuXr37Q2DXK1gE8t5zIqhQ0zO3NuajLqmEJlVrmvAf+5gyPYUmlVt5jYb7I/z3PiRPdFOlDOl3iqBMLf11aUIp6aOdKEUXtc1MlBKMrtk4PqkLywfB9Yi5eywLY/uAaca6XsUewxChULOepI6ITFjciE3AwbJvBaK4cY2JrGNCSNWWBPVNkcD0JvLfB9oc8irag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxOZV8bd0tKnrvTaGuZq2lWkzFu2kDixRrtgSdDhvLA=;
 b=L/hGfOs53TXGUhnOoI9gXmdd3YcLOPs+gZVc8upzjqUpUXbcCKQGHLuR0ZqZ+sxDEqqOn1by+Dh0VbU2jY+W+f4FcR4med+xfmqwzYgMDIu0dQEVCGSY9O3pny9uA5LGbyKMOgLcfq0YlC3EefOHD0Yc8cLW1QocS0QoIL5E2cs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6708.namprd10.prod.outlook.com (2603:10b6:930:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 19:48:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 19:48:35 +0000
Date: Mon, 10 Nov 2025 19:48:33 +0000
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
Message-ID: <27920b64-240d-40f6-a02a-0a8c433ca9e1@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
 <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
 <69FF5A7F-1414-4DE5-8A2D-09ECE240711C@nvidia.com>
 <77925a0b-fa06-4200-a967-a66bd93201db@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77925a0b-fa06-4200-a967-a66bd93201db@amd.com>
X-ClientProxiedBy: LO4P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: faecf99b-a1c4-4c56-561f-08de209222ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P1siYTv8wWY4gN0RM43pukabnnQQFRHTF/j/kPLSQ39vz8vGvyyxfmuf4351?=
 =?us-ascii?Q?gJjMuxSipnQKJiarzk+tUHZHdmhh7TkUme+VXVgtrf2phpn9IoND29qZ5Jaj?=
 =?us-ascii?Q?izM5BPUg/13FlzIV9RveP8hkZfcgucJ+A1s6jJU4v4jm+FbPyDFHPB1Q5FH5?=
 =?us-ascii?Q?6sSLfGazwVe/b8dDBJJf3FQBPRTl1tHd4dP1740DV83+jHMSC8NFkvGFiusf?=
 =?us-ascii?Q?1emPGAxqgp9gZX1wVTh8bznyYUYneSOChr55hQ/msEVzZcgDgYeotl6IQT+9?=
 =?us-ascii?Q?Xh4GafO0UdAeVet1TlhMdNdO1lw1B7EWVtQB53deGffZJgvPE74aws0wM2zZ?=
 =?us-ascii?Q?TJXIdz3h0VizSbYjY2jO/WBVj5noffjKJDeJsOvoD+z7e/IOYDBQ3W0sPAYJ?=
 =?us-ascii?Q?tS+RRh6v8/3T09T+4T61HZ0APvJGNR+8l+5bQfjWj3+8m0kgV1SYtYyfyyh9?=
 =?us-ascii?Q?Hg2ctLT0/ELUmB4rSKyhHTwN9K/8EvtvwAikn9q5b4BRzPEm/dWFPG8jJEJ9?=
 =?us-ascii?Q?c7jWw+Ubw0k78bKGbru8h1M4LVH6Zwy5fyKUFSCYV0SJcupfdzAWf+FunjDN?=
 =?us-ascii?Q?GTViS09C6eN8HHuqTst81XZLZ+3SKCToAkRGsUCDQlqlWFojakHuIk8dtK3t?=
 =?us-ascii?Q?M90hyKbGmj/ePvcAp0KKJ19jMzFwv3+p5JXjRVpt287a3Sk9lPsJTis5qiKD?=
 =?us-ascii?Q?IX2RcGY4J2v0BdBxntjVYtIQtCO8jBzBZlRCqUZYJj6LmqIrpQijq4HHWG5r?=
 =?us-ascii?Q?ldgvCqTciL/p5+3HiOmLQ0/Xq8itzNFUCnEppD/qjVxrPj1TjrNTr67FepM6?=
 =?us-ascii?Q?lQ+GeGH9a16/NR/jMzLnQdMjsQQZ4g+g6QgoYn12elKg/bkZQjgtwKsthWP9?=
 =?us-ascii?Q?rA7wnIuriOoyPXj5KcaXkrBcVlZUG4oeFPzQtZIvMPHIOOUDgfsLvxp1VoT3?=
 =?us-ascii?Q?PNa9f76sNy24Zx5AjIO5k8Iofj3ZjWtZx9rdIq6cJAVMO+DyDVahvkWLC8Zv?=
 =?us-ascii?Q?lodenvKrybwrCBNdnwCNNiyraS2/9GPUFyMScYts+jJWbK1/lBEcLvRepRjf?=
 =?us-ascii?Q?Yh3izaIX6jMyb11XqAKsv2nFghTuus33Rqlyx7GhLGTnFXCFOl4h/K5c9olT?=
 =?us-ascii?Q?Nvs6jIl0fZxVYKjEbIDyrkThSUQnHVuCj6hsoL8bILjgRiyL9rjft262wv0L?=
 =?us-ascii?Q?grnwt+R51ggnADi+SI8ICm4aBAqPt6ciyGS3gRPvKCdBDkQQTRedUOaotR8q?=
 =?us-ascii?Q?vhBbUAtZ2KwbDoJEFVar9VIHjCkU1UlSl0l2ZzEsU8DmYZg1O4RYzIGTFpAT?=
 =?us-ascii?Q?uA9MFCjQvzDtr7jHTuU67rFwX4Y90LaMtUU0uhfeUu0nQjIJcrzMDVbBSIhi?=
 =?us-ascii?Q?T1FBZX0Wf70jzpN00Cjqp2arebgdhBjiPuKuVH3OVLHB4CZ50Zppt0zIsZqY?=
 =?us-ascii?Q?I3Ja9kZTHWfAYwmqsANoB01GmSXEmHg1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9TT5KSPYZl91/DT893MXIQXkCToH+lQhQiELZAt/xy3riFizyF86XzYZYjNu?=
 =?us-ascii?Q?G4utALI1ueU/y2il14+itt2z8ufRCh4HzLZImUGoLdPs5nc0VdSzaffbe29v?=
 =?us-ascii?Q?PBKewW4SNlf7FoebX2ffwvOt4KhROH8rF8kv1DySl/GSUmpysemXcr/flpL/?=
 =?us-ascii?Q?ujeXM0gOVbOGngmQAvuswFXZesdaktAk54odEYKzlQyeK9Iaa39hCjctHavF?=
 =?us-ascii?Q?IoD5L5Ai5JGn+nAJIUyl1UCUsb5K1UdFfHvzE6xAhUeAWerOWInE6ZWjfOEH?=
 =?us-ascii?Q?ME1F0inFBXHRluO36KJWk/J2MLwmITCKRoKGO+9wBy77Dx3HYCcUQRgRLS18?=
 =?us-ascii?Q?vEIFqessg7QHoitBhAh3e/NVZEdZvAN7SYxtcwRRztdelzrPi4bArGRDG9GG?=
 =?us-ascii?Q?r7KC6IT6/I5Jab1j6C4wGvOfuOrwOowclPo5+/fWkls5GWsKjGmJcF/C391D?=
 =?us-ascii?Q?byQpTV9ZhOdrlZ4qnv8RfleTJfy+cYEGjsoh4lYWDA8zc/g0o/wCOwpYiBib?=
 =?us-ascii?Q?7TijwPMsErgY+JSKTq6ABQT6RJnLSE0HAOW46Pd5r/cBB7fbwK9RzOpGHXsp?=
 =?us-ascii?Q?K4LFtvsYMA1mfvkw9gXMbdYwyhrznMZ4BdLgJO9x9yUV5Vx+921meVCWCakr?=
 =?us-ascii?Q?PModrXuWRjCONO+ADEPDfDL1OcAyEzV/wImnAqSEdwu4/UQSueAttJMVWtsQ?=
 =?us-ascii?Q?jD1UDSITF3pZLh6mM9IqAz5nCveNFr1a+QvrQi1l2rp7Dq9DNx5CfGiNDMoS?=
 =?us-ascii?Q?jcrRybXZXiftS89GEE+HLXeqcCsD/41RrVTn6CsScqumm35zcERi5vix8Jzc?=
 =?us-ascii?Q?NyS1S+AowzK1OO84LXOAVCKlPsHSktAs4uBpmJa7FR2Ncd8QYp6L/DtL33kX?=
 =?us-ascii?Q?95IBIYYtFEMFP234rgvaNmkzXiBsLo0M5RU3J+6wfPkujXvs6JOW6/0dyqLe?=
 =?us-ascii?Q?8w7AJXVTsuJJLTVQXfqfQeVCgP34EJ6PUPPXsYJwlou0gVsjWFdSfOkuW4Hv?=
 =?us-ascii?Q?wF1OyQVPQfIEYR8QUa9nmMjrHMtRlb/yP8xn23isjEOnUWqHU455RCnqOoKR?=
 =?us-ascii?Q?d7oOLBu/4JUcrc50Qs2g4hmD/QC9iV87tL09OhOzT83wVU0d3nrHlnh+acqM?=
 =?us-ascii?Q?DfjG6+Rv7MQBgoISmtSm5JqjfWkXmP2PJVoLk57+uhk7LKx93UAyeeBKz/fo?=
 =?us-ascii?Q?MPofqzNyEfrZNuGZiyqPOHkFd6Clq3Wey8k/Gk8jhVMrjxPcteKobppgyNK8?=
 =?us-ascii?Q?G4f/QkShHQjhjvHNMnAV4CPGP3RFdDYek3GnjgffmdyGrlkIaPwRBH748nCN?=
 =?us-ascii?Q?BiYqfiNatpzG1trrdArOl0eoRK4bZOxN5FgaVNSTf6WKOTfL3Lk0ZoZ3c2Uu?=
 =?us-ascii?Q?m8ipjxWZ9/XJKYx/OH79BLcUQ6/FnVOnAXMH53oJ385ZFNahshUgq10igOFu?=
 =?us-ascii?Q?fNqmcbxv2AjKJOqr0sGxzMCgj0jabglsaOYJMKbv4GOW78+2/fi5axihK+CM?=
 =?us-ascii?Q?QfiwniVs44Bhb1cPDAETfyHKZY9aLuGE/WnSw8RnnHXDo2WqYzcfeTtvORxM?=
 =?us-ascii?Q?8oEep1lMA7isRwFzwkzqOIVq/N2W9z7B3Q+VKU+5kji0fxjVERnT2oXYo9lo?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4CqP+mJhMRLGdBJc9ZvpHbfiW18UAWuJksvJeLVagdgL58p8x6oj6A+id8p8yOcoANb4N9N5f0MYlJbeBOxXd+QVQArm7yKMwvvrjx4X+hIc6KbKabFY3tRscjFeAs2VBG9goXy3SBAvbRBWApZ2nm/MoxHnpcb2Ks9jMuO18wrDlJbbbUU6Cc5ZdaVVU0PvL5Fl5aGAom6DI8vBZBcOnUz9wrAJ7H1QfPRWQScGjns41WMDhmk60+vx7S2nUED/4kBEDPMFpYMwsHHjkrQJINA+QBmAl7medYX/as4p6yWQEPsOgz+xw9nCzUegkbFWaaUiujidJvYr2/3cAq6+KJQVJBgDVnnACAEn8SwVgaS/5mApfFu1VjZ7fRjIlfflNZgwHKqZuttEUkKkyzHy1A5OVvDV7q7Wowpz1geY55yuWk6FLuC+0u+gHPc9ErTbYu81VdBcvdWjoYw0Z8yKgu/fv8wObFwwZcfOfvCbKO/HZlrFJz+va+Y2gVd84YDkSC2MIuxGdqsnhbKW6JX9lpugynPCwaBDBYSnrPMD3/EXyu2hKuXuXREgo4TL4KktWf6Cr3AQ+NoBbLecBdT3yJhmsKZRu1fNfFhFogQZdQs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faecf99b-a1c4-4c56-561f-08de209222ce
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 19:48:35.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zb7/C/3gWSn92uc84zwJfXQghmCOp+5lOZywC9OAwx1TdGSfjw9R8iPhp5LIX2arrWOZGRf8MuTan1xdheHDrwhsZeOk8ySX9016yiU+ox8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6708
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=914 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511100168
X-Proofpoint-GUID: 42jVyHXsPx8Hn4a39cLw0DVF8oJoAyRZ
X-Authority-Analysis: v=2.4 cv=ZLXaWH7b c=1 sm=1 tr=0 ts=6912419a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=_X-QILFMyjUVmRmmXL0A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13634
X-Proofpoint-ORIG-GUID: 42jVyHXsPx8Hn4a39cLw0DVF8oJoAyRZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEzNiBTYWx0ZWRfXxuwTiJzdI7I9
 nn6180WT7cku2M8pFR0AxZlTmoN2sNLu7x8IDiVIzlxHsST8Cc5n4O6eNFni4wE+8LmK50OIRoB
 +LcCuBUMJbMYuZT65XUKdP+wm8eZlIjO9dMkIlLiN4+1zp7+H7JqB+FnMUgYKYFG4p9XSmNoxa+
 st93LwLSn67xdHU2mkSiRTuLHDrAYhiMqBSXYjkKXnG35sauDa1bOjL3DIsWpzDLhAOhbagyWIp
 BR3pTs8CMcCer0zAyu0Ymbk3HO4vaPEUbOKdSLu+3kD9OMJGeQ+42seDs5fUMY2s31z5Fa0C5Ps
 QQ8wd+ofcrLR3/kUGfyJsC2qOKGqrQ4n5gHKyTgcVH3KcEfD/Atwlh+cKJjwsoFFLwbvZ8Pdhf0
 f9CRnIoeReohgQ3xNzTEwxOnW4Y1877RuiqTkKujAOL7v2KnHUQ=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 845284000A
X-Stat-Signature: bhndo9zm88nt19qtqxpw9fzmqhx7rn99
X-Rspam-User: 
X-HE-Tag: 1762804135-850328
X-HE-Meta: U2FsdGVkX1+L4cpSfWJED1MyYM9pto8tncbddeeoW1ILxnLrHu5T7ZxJQI/r3S50jdpzkx9ETtA0cZDbpmy713CklEpNoVUZqVCp4nZFZLjgULWysGsbutbgngENFqyGtgAZoPZk8g+hL9Zwh5b71IrPbmWoGQBHuY9RUXU9s9eGFoRGERlGdBmlRoxljwtf9SfKY8R6IDs6GlB49VgP8hl/RMuv5s1z2viidR2hE7SWWiinHKVRriRacaZyp5UUr0xrkb5wkduej2GDMQtk6WLZ0y1tKWoTFgqBX0Nap2u1Tj3FWFQ9V2YvlPEIYM3o/MSOcRdUIw5BjX5ymVb643J0AUOmHOPhR7bP62aJgypGbo2fFEbHCxgMXYAwwNB+1m1sY0+c2dTBaaTKTrbk4rtkJ6Vknjqf+v33mMtTJBoCyS1QE/BWzbY45bWpisT6OHcjMfdNotnmtxEtFVxncOQ58C+nCEY4ahnN1zXQ4PhQ0AZmoKJMDVMNwy7naaQcKIX+YFfsAbN1LVAehYzOhyLpxzLrbgFpKuiZOJM3rh5hlC1Uu496KZtQY7GW4DKUlEQELpP6J5k3AaBKTrGR+4vqX/1NjIErnrMXXQSA5C05CGqhDfh7sSGVo8w0x8DwnwRFJCQ8nEdef4mPKIL7uV6+gbt1Mdgm9LtsMLP/Yz1BU0sUP6S8Fx0jHIZdkFZeW4LIBQP9BIuesHAhL0BjTWnOo4DVY+IYBdqW+vKXjUKxo+1cxcBFwudTnprz7kftrXtb6GJa5AqnfdfNAS4XTR6ZVJeYkJ2F8FSQ2q1bEe+PtK+SPdqBmx4V4AT433meTL1AOny85FSyj4x9A8YqyiEHKqk5Xvdj0E+6lc1KrGc/cBLVbr5q2uJSWyjB1EBaYGOTcg68ckLNCBmjw7gyBi+W5XC1l2nH7H1DMv48cesljwpqm3kchQHyiZ+CXsXstlpQIOIW87zdgk6+vqd
 x/CJuYIz
 52nKMe6a95z/NuqUwrfmDfkwBIEQyJEOB6LHROdwQEnYnArrHj0S2v9cBGJLyVX8F73K1FP003EnZIyIuhb2DjLJJGhxbpyIM/gCphVjJHIXdlfhQGAbbTKz3HrPQMW9z/g4/FgsBK2ibDkt6+JorkosediiRsXPlw+g1CATY8BXvH3TveE85zKPc1tdfB8oQL2rX9gavVnvvLgil1dU0JaKvXvcavl+qAaWGY2c2hA3rVC3hwLGQPJ0M4/I5hS72XlhIsSenw+G8rC4xG/rFim1OdPq2LByGYE5dCGq5BkJ1usYSWMCK4sFf06Aiq6Jq+VUMW4V22Fk7krVxFUteohf6WDgrRLIMhLeIyxYFyR2dsKYaAPfKunny/hMepfS5jj8hOHMSvg7wToH+aFcYOqrLBnhVVoZLKvMdQw99/L8pE5/2HDL2+EPE+s7ah9hEBbk0ca5zoMAiri/71MVFrOfHFr9un+WOV6P4XZBY3AjSDKldbYgcMA8fX+gb3SeeumbmJtbwZ7FbknBdZf+opECrX5u8z88C2QM4SgJW3cB6757UPRcJLVvK0f7sPqMZSK9B65pUE37mURy+wFz2kbEutybsJUng73yZmcnI1QGW2MD469L9N5FgJ48hZwajLESXpq4IPVT1WZLa289umCLof3gexycJkuqKiplL7M2ZQxtGnLCs/NHeKJUthNCcXEWe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 01:10:03AM +0530, Garg, Shivank wrote:
> I bisected the crash on mm-unstable
>
> b14d61d8fe442b1cc2d7591cf040a6dcd7fe2dd8 is the first bad commit
> commit b14d61d8fe442b1cc2d7591cf040a6dcd7fe2dd8
> Author: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date:   Sat Nov 8 17:08:18 2025 +0000
>
>     mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
>
>     In cases where we can simply utilise the fact that softleaf_from_pte()
>     treats present entries as if they were none entries and thus eliminate
>     spurious uses of is_swap_pte(), do so.
>
>     No functional change intended.

Ah fun :)

Thanks, this is very likely a bug that I am about to fix in the series that
was reported on review.

Could you try the attached fix-patch please?

Note that this might not apply against mm-unstable, in which case replace
'softleaf' with 'leafent' :) as there was a rename in v2.

Cheers, Lorenzo

----8<----
From ab4d93d299f0a0ca3f1fa5e75b2ac646695b632e Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Mon, 10 Nov 2025 19:46:55 +0000
Subject: [PATCH] fixup

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/leafops.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index a464a7e08c76..325cc87c3363 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -56,7 +56,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)
 {
 	softleaf_t arch_entry;

-	if (pte_present(pte))
+	if (pte_present(pte) || pte_none())
 		return softleaf_mk_none();

 	pte = pte_swp_clear_flags(pte);
@@ -95,7 +95,7 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 {
 	softleaf_t arch_entry;

-	if (pmd_present(pmd))
+	if (pmd_present(pmd) || pmd_none(pmd))
 		return softleaf_mk_none();

 	if (pmd_swp_soft_dirty(pmd))
--
2.51.0

Thanks, Lorenzo

