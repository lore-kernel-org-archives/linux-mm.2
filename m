Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C945CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A601F8E000D; Mon, 10 Nov 2025 09:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A371B8E0002; Mon, 10 Nov 2025 09:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE638E000D; Mon, 10 Nov 2025 09:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0E68E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:23:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19D6F140119
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:23:50 +0000 (UTC)
X-FDA: 84094916220.22.2A277E0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAEA720007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:23:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ElcXuOR0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ehx54NoZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762784626; a=rsa-sha256;
	cv=pass;
	b=eIc8lGW/+WVgCPp2gHkIL+A+xEXQhe0lTDRLbT8TAIBs9ubaP5PIVv4EtJdPn1sOLFulDt
	s+AuYNiMVq2mXlzGP+8j26XVghv8c60X3y+b4m8E31JPViO4dhlMK9UIVlWWzMKJ1Fb5Pi
	sWk9zubLb9kf7ymAWFrx4Qz4CWa0xH4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ElcXuOR0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ehx54NoZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyA9HE6UhA4BXMw6k3fWdc4Ai60pT50uzFRXl2mbunI=;
	b=zAh5ErqGJBFLQa9y86NdnPMsvIkpMD1VOBML4foIpBmX3IuNY/MEmyQU4X6kllCl0IMol6
	uzABUGhWnf89bQjLGznvqQrOJsMdfEd2g2TUYdELPClxBv1i4JWhRL1Ns0DZOmDaCv/8P6
	ZGj1s33S2WRZHCqin+DS4eTPrXjAQqg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAE1lQs022757;
	Mon, 10 Nov 2025 14:23:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WyA9HE6UhA4BXMw6k3
	fWdc4Ai60pT50uzFRXl2mbunI=; b=ElcXuOR0P+gTC65bRnEYgEXwzjqQNAjQ90
	OyOIZ04Dt2z17XMzTEywoHYT3NvWWWomHGv0mUsMrpuTIccpZo3DEQtn4gW7Zu+U
	TvUEwvu/ZCElcVzTns63lZs0uYzi5TIRtyGTTUjoYykqh6zUHVU9gCgzHkwmPQbe
	EUP3f7sTKccVQsxoIeaiKPel7ap9+6dG+cQlLRa8BaylBTBsVa1zazCAuyCpJd+d
	31eZQ9F5o9yxqrTtSU2Rwuzyp/kk9RHUPmX4j2z8vHlR5uNuKKhT5AVi170pNJAf
	DtKXAZPoeF8dCtvzcoULi2+YwSaLSM/z8QUnpLQCu4gYLBd/N+yQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abhe981e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 14:23:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AACJrdh039940;
	Mon, 10 Nov 2025 14:23:27 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010000.outbound.protection.outlook.com [52.101.201.0])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va875he-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 14:23:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jnmxULExwzjCKFE4F0MtStGftpIYAUxJ703BLX3wvb5lyHAdBG3wPOrAxgwxLNLul00fXP+YqdKDljXhpCUQV8IM2Oh9UIO779VCAuRq2uIqsVdKEHXdIFCHPIBX4fcuGPTmes+HjwhiRsiK30M2xj25gdzrPZ5tPF3kiBg8hBoi0PMIQtj0MXgG2sJA24hQJpLmxCtqh3xtaZz9FGTTFGe9ngbH6zgMNLfLjUXwMsRaZWUTmm4Cpzh7zEd83ZnEqImch2D9MYHElx9CTo+lnSHV0Lx4F+i4yy/tzIELD5SQ52MZKHaoF/1vgrXd6O1mKkrtSTpe1HIzEq9nwAT39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyA9HE6UhA4BXMw6k3fWdc4Ai60pT50uzFRXl2mbunI=;
 b=C7Xs3q7uuyi9rG6TVq8th/WyI8d+EKWj0MFFluJSJYHN6YqOJXF4PjDlaxRbMliupJ3XzNTj4oRv0ZAOr/usAa0/UfyW7AqwljIiGaCQSrmLOzIIoZD5caElU2i0XsBaC+EQ4S1eGNHvbRMUCgnmXM73Xc3JtX9MdjfwF7LmXa+76nS/5R0YQG9E9/v8wI5byyuOmC92QWUAj72qkMtSnBc9VnkjmoX6bMZwhcyxfnr8FzK9WRepLzHzYMB56kNsuuf0CfBOfaTVfWQkGnS2t1P78BrTHLiFyfckCn+YPmKxjh15mOFhZ2f14pIRYnQGqPfjF9HC4v/TTpZaAML65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyA9HE6UhA4BXMw6k3fWdc4Ai60pT50uzFRXl2mbunI=;
 b=Ehx54NoZzZOu8gkxBaUhX8pX4K4XyVI8IdJS7dOUNlep7R8E+ztCFr1R9fjellcKQ/5J9KygDTfpAqVv7QTKY0quHz1sYJeQvARqtuG9G1VYX7yPTrVy2bXDWWPb5l1gg3kqmJSz1SO5VFGmbQZNHKt4Ncm9lLIb1l0Ymz9GmHc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB7526.namprd10.prod.outlook.com (2603:10b6:8:17f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 14:23:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 14:23:14 +0000
Date: Mon, 10 Nov 2025 14:23:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
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
Message-ID: <8f0ec2c7-e209-4664-822a-6d3785bfd4f4@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
 <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
X-ClientProxiedBy: LO4P123CA0467.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB7526:EE_
X-MS-Office365-Filtering-Correlation-Id: 102e6756-8fbe-4a5b-dd4f-08de2064af0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Vvc6eYwg4I4tsSwZKmxXsn6eiEePz6yzflMnMt2KN3EQN5Z1bS+FqtPgy07?=
 =?us-ascii?Q?qgdGUA5a8zVbokh0kuSrqNCs4YjhGWAXk+omm4VCp8YRhewOyjjHMNnaFu15?=
 =?us-ascii?Q?my6zp2GdLpjLIwV1g0N7alpBymD1vn1/frCkhmbNDXHN/XVrDxed7lHhEUyT?=
 =?us-ascii?Q?HCoTMFiSGtcvcG1tZKC4WUtwv1AaJkkF4ekr3js++wadzACt1KkCnEdL2BrM?=
 =?us-ascii?Q?ULlLxQRJroa5bN8zOfj7bpQJAe3k77hKONCKm0UE6ZlKwRHScwcE46IMJDwN?=
 =?us-ascii?Q?/KKETpgWBWMTP2/uoeRaZDNiciJojEF32RTCkqqjpmc3kue6kCUeG34cngcZ?=
 =?us-ascii?Q?yBN56YyUIPnyCcsEGgdArjIdMkEDfAvXDXZ38lL6dS3qaqgJfgB8hWSKNmby?=
 =?us-ascii?Q?b67vgGNoWrhpylhxCeCKMsYeyqICr/4lDqEgcYVd/BBKwCdS8rLz5mg+FT6h?=
 =?us-ascii?Q?dP6FWL5GaENMSIApN3IHACCC0G8o0lwqK6+BF6haMInM+XxBBxRZC4nQEpiR?=
 =?us-ascii?Q?Yg0hl+hQRRqREblYsozjhNzvLxkfwN3Ak7P2A0pYJVz9tS8t249HzSgqZEvw?=
 =?us-ascii?Q?O9U8gdx4A20Y17H47QWmaxKVE6IYKk/JVI+0oFyoYaYqoQwnghEmQmFbrKxs?=
 =?us-ascii?Q?4PVJaqaw4eK4sjbQLfq8EUkyorVeXmkNmFPfK6wp5oesAP0kuB+tlX0LTh2X?=
 =?us-ascii?Q?+dJYlyXlj+cSWxMAw3PsXiZoCMhaexJoJZHEm/w1rKMkL9iLSEPzeTHVJchK?=
 =?us-ascii?Q?lNIEtpVymB4okZ9rvlXxT6b1o37fC99nJIQgV2qqL5EF8ar0/ARcO9KHUNfO?=
 =?us-ascii?Q?TWO1kc3JJXFtVWORm+MJn7828hn6vUSGRh8Amre2EbQ48VlW/GLAWLHDWCnj?=
 =?us-ascii?Q?zat4f+6CX2ZVL/yKHEecweXOZIYW0E9qJc4ehduPr0dxZSMtM4zr9uymc6CJ?=
 =?us-ascii?Q?P3axbh/qRgAz7NY2QVFWpTLeMXzk7BxmqeM0dgo6srHOmpEvYqq6vnRs6oDB?=
 =?us-ascii?Q?8l15vdQ5N2uqnKIpTlZ5brdF8qMCORmaPlsBl16d+9hHGdb3Fy13V1L9CE5F?=
 =?us-ascii?Q?/TZh3/y17nIq/D+sKaWC17yjMkHO1cqG5UKcd1G07cssgn6ohC+GkPgwhxxI?=
 =?us-ascii?Q?2J3dsoEQYbtxmSWh50/ScuC/DvhQ7Rym7OgiiK2czrKsj7XWy4zbGHZJBTRO?=
 =?us-ascii?Q?hSHxCkpc11q+nDQb8j3xyZHyALcoQMSnl1G2xEadGGnEhmjMM3KP9nGtg9VW?=
 =?us-ascii?Q?Ex6lkLtIRlcSlm/YAiU3if7BaNsrJ89+0DaC2/sjZgD3Wrol7nBW6aGrysLH?=
 =?us-ascii?Q?HrDfopbYSOAfU+beXzL9zA99Y7Z+N23yLHhN7om4whpk+/EnhvFQYtc/1J2m?=
 =?us-ascii?Q?PvLJoWdSAo2bQx04T3Q8u8XDg4FsL9nzhdjw+FletME85Ff4hY7yEcMr59Ii?=
 =?us-ascii?Q?+q4wb5mho4AUj2aulm5uf3FFa8rXzs9r9Q0jwRI4IVzlCpKmCl0ntA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oMW8quiizn8tpK1JZM/9922Kg5eZEX9yRkBvb1/vY/H5FVcTzdJ8de/j6yHn?=
 =?us-ascii?Q?hRPQSy2dYPh1vpC6lAmLzEn0oSns0dGl2AtgoL2ILeL+P3Is9bajrmQD6f12?=
 =?us-ascii?Q?USj8js9BuMxPSBPASD0fMaNCTElmhAvUGAwm+/GHKCtqpaxt16AmFHRVM1Xr?=
 =?us-ascii?Q?+XKLXJM4bhlpLzMT6ZwyrNH2c3OZETAw+vq++5Uv5IA5HoVQuKYWX839L07/?=
 =?us-ascii?Q?oLUsOIiHo+9/5FMACZJDQ9nptQUB3Opn1Nc8phYfj2jCaFpfp6WeKquMNHBr?=
 =?us-ascii?Q?j4cG+qElNLzKMHnctmJN2XlO6O/E0ia5eqNK6IEQ0hKcZMgKSMKogT7jAd0P?=
 =?us-ascii?Q?S9febJXEYiF/ZbjbvTYjdSqtfvn8BCkq+U60Ntmq/GtqF2RWMD9soTEH7kbl?=
 =?us-ascii?Q?AyxBuTqVMavx4feZGXDtPhSoqQL8D0TAKTOL1T/BiW0k/fjPWrkQrUuc9aDf?=
 =?us-ascii?Q?aZw6EUfbgy3zvZdjalDFtq7QKVrp5LSRsdAIo29pptXzXWt8M1qNxaxb/mFF?=
 =?us-ascii?Q?XvuMjbC5pVkbv4LQxTdYBjTF3kkl2GPjFHKVyP1FIsY6DMcVYEBuT7XEwGGw?=
 =?us-ascii?Q?7CN0rNkBWuMZvkwbJPdw6RxvfzNToxpLHhhv8DDdDgqfHowT9HdX5SV8KA1m?=
 =?us-ascii?Q?9ws1WIlBHrkGSXKpWJDPFf/yxnohQtHNPQpSK1t6eTs4MmofazsbscBPPn9B?=
 =?us-ascii?Q?MhVT5KyQ0tdITbG8BHpx5q6o3QtLHYEneB46Mgl0JaEwRnbFIoKZespXIHMA?=
 =?us-ascii?Q?q/fVRMQSYsY2ND9QH9QOf92WeIAQ8fslZeCCDTLOo8cSAudM2QEThzyp3IEv?=
 =?us-ascii?Q?fKgis6g5+SAYvvwwoC2H5DloTXOIlN/tgYw6cayN1313D1brlRbYK1UGRT91?=
 =?us-ascii?Q?2ArY0lDH97bDvecs/4lk3ZwQh+/WegC6Ca28b27zV2CDkeeY6LrmxblYZE+1?=
 =?us-ascii?Q?SC7zxLNDD3AysL7fSydSZsEFnDMkW1NxqahA5o4a4WYnlwg9zKVud4zSo529?=
 =?us-ascii?Q?k2ZmoFYjWcN8C/Y0fK8JbPUL6XuejD3EYshY1Ej58+qVX5235aQ6I2ETPwyr?=
 =?us-ascii?Q?QkYKHby2NJiFq0cMvzby6M3nWrhx590/rL0XK3Z1/A8/mfJbxLjsZ2cA48S0?=
 =?us-ascii?Q?Uup7Kj6qX2o8uoPWxZhjFCCvvA1QTzJQAiMhxtPmzisP4Vpk8MFgaY1cZfyU?=
 =?us-ascii?Q?ZhDnZSGnj/an82pIMEUOx6yUzQfThnW2WacpaNNKcR24fdWEgYgnE0Yb+MWy?=
 =?us-ascii?Q?Lxu+5ln6NYLSUN4dXUz5yRHSJIyuJz9vWtGprb1/NbedfWcL1mIQ2vjin3tP?=
 =?us-ascii?Q?SW2sdrfdmONz3+hRAs7B+v8LL+tA/lGLnSDSEMPSGeexL6blLL2b/1WXC0rS?=
 =?us-ascii?Q?/dp2EIVoXUv8quRluMMmTNLv8hzSDW1JYThJnPWzrfX5ifMhdeel4j12Ljpa?=
 =?us-ascii?Q?Mik27yQQqfNZnc4lxaggTNtE+n74TDC3vqonIgKqElss+D40FQZzGQPcDkeU?=
 =?us-ascii?Q?8V+Y5c1je21+6+rTFjfKMeCoj2lxOk/bz/lDa0fBbYfK98UlaFVDc0/3f6EQ?=
 =?us-ascii?Q?31JM0SdgiLJPhDfmlpJ14CHaGfL6b3jH+nVyblxdKaOnMFdO6Yiv6ocx3W5Y?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VxjB2tkHqSW3JFtEeSZ03e3l+fNvYdtD+expOytVSN5QuKuWBczct74MvLTmhyqzl0I7Y6KqlsAeSpSUG0xaCWRRHQhmSYTnlN52a123FP/rSN1l5IHsEKmG9Um84o3YkhfB7FYUiV/h1b3uElNyGl8WRVgyEeyIlR3KQrcjOEi18VOAyYoNQSX4Fl894RkHbt5VKAud7hNu4I4Hd7xNQaJkz3rCyLi7bEhwNot1UghqmOWarid0t/aFdNJsVvUs3LgJoZ3EAj+nI54z3JpRNDjjGDMTROJ/UiFhauODEEYSri1Bg1LYcP7P//NBM0tM8Qxi2hmcRsmnmJfAOfDxUaP3s6aDLVslgXKTrYnr15fnY6/MhcRRqVYv4NCuXM3yXkT4NGwbpiaZIAnOYbnm5BFAm8EtgDjJca7WBQEcqUSTFEN2WQ92fp8ZMV19aHHQ0ToOHIjABs4d5f5QUmR3LINs8fJJ4bvIFnIdASZw8ZFtkQGjg0iULdJaiHe3NQp4r27M7CEyF+JknR81/xlXvrQyCluBgN7DO5dgmJANh8MdPyFa1GGiXG7VJ2rAw96i6MsBoCz424/1fwX7I+co6SiT90duxDz5Ox7GqryiVU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102e6756-8fbe-4a5b-dd4f-08de2064af0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 14:23:14.0434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSzPoxoCKNHS4wGYa06zVUWFXJV75X4c7MQbPRErOe8d+L889pMWLB8lhHmpjo7R9ooGRQHysL/A5kQymhRu/9LnYRgCFjQAT6lKgPEQxUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=988 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100124
X-Authority-Analysis: v=2.4 cv=VMTQXtPX c=1 sm=1 tr=0 ts=6911f560 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=D5LNX1KMGqXAqGQp_HEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: GPdeNtU6qJT1hmhpr-5SdEY1vWKxbfZi
X-Proofpoint-GUID: GPdeNtU6qJT1hmhpr-5SdEY1vWKxbfZi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEyMiBTYWx0ZWRfX8c2jUbhwC1TG
 NpAuceDx7FHe56fKfeKwkaXLUXpr6WrZym8XLQbxXJyhW5uEToINBxAcfCP8warkdsMBffFJNXF
 Dg0DcxtMMrsqzcQpu+GukcmrHmPGANL5M/rndJwdSm82hs7keJYYecXmYT/KADnpR1wCX1PqjLc
 7WKRMSN519R61cNtkW8WeCiXA2GyhH/E1UQHC+PV+WvWsdszNjkmtdutqEDkWBx7hFBZMB8Qh88
 LqOxa709cQs5/lPkOWikD+mNsMfDfnVcpify3kw9Ey3ERCtrAgM+xyswoG5HXVRo8hVGAVR3pX5
 OR1Vp8erHJz5GC8K6nNz/jk/2vQyiXTJa4afxKF9b5llvjLFUccNUqYyTWqTN/ibQ6jCJGhNDpu
 E37+aN66y9hrztGZuJa0Fjzzyw6cIg==
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AAEA720007
X-Stat-Signature: hsiytzr3befoxbcnceigamk7xcj3gqir
X-HE-Tag: 1762784626-836634
X-HE-Meta: U2FsdGVkX1/iYPkcaB/lD7/WFUO0Em+YAkcckCWcWQSl9ltgkprNr4lgpz63vm0XRf+JL9oFzHf4vxBXDtnLWft2mqIeaMUEzg9IAhgaCTVNP3847PHyP85MxL210krL1lbRDsp9DqkNUpj/LKU6/SlDlOlgApreiMBmdVdXIfQjNinY5QTtA2/HaDlGJPTa1XQUhQdPYEXYBfvq1ekMATXzUZb7n9DeftP2MpeVWtoGQZKiPcm7kPI0MPnU0rdULij4fg+JOCRaI99WUsQ9kRE8BDJaVQVzi5k9qjrLYeUpgNRud+YarghGAbgYtYkJKH92K0nGcDzSkzd88gasr/4IdPCPqZOWWAI6r+ZRAxVhgyRB1utBZTlucErAdk7DRABRWaOAWA7zk0QUuC0Q8KpyfEpFOBaTKZ3FXL1J540oqW1HXhd66ujXq88e1mBjWNdtnW3R31voPGJRUuCEyXs8Fa0jU9GMWsthA0fH2Y5EuuYeD0YxjGY2ECrbsSy4Ju9ECfgTd39BXC8VexR2f/OAIcyPQBOnUXBgTHjsH7rAG/AlyDal/U2AOPA1+qGofFcbv0gyCIpuen1Sjym6c3ZtiGMSK9N6/ZqBcxNqe8KI17Ua4jp2tiJYpupXsS38pQ2ecZn/Vp19s8hb+hhEuZvKSoPGdmrUDqAs74ZoJxSnuLecXMQQF77RnUQLmqFeqH7G/dmkSVoNrofnm0mwb1Ckp1JEZ5JS5+D+drJWAgvTO3afM9qW+bm2yQgMuOXw1D5+Co/C1JcSNMU6+UXvLdT53bmn/vdKGdkMoawtX0d5jnhAK9KH2SAGsPm29Skfe4fLgrcM5XhHWeAlSn8lAUBpNBhSdrgml8FTjGse3Qz80bvfsn94vnri7V1Ehu1iDVljpdcj4HqLcQiWpYE00jiXbvJ2+mCS2uqSz2mZLmjUHlbuqHcsAkLfomj6G1nVyYede+727Bu+BWA99nW
 Jqcs5ufa
 ZwFa1YrDJtYE46cclqCUvozO4jFp9Cv9l8po5iM2hWhrOgDsco2nWNh2BhMdr336t/Z1CN0HcdKL4wKcR8QwTDjZP9z82MLQIiZOI/CAFBUhuLlXluxC9Eco1zZfM33R44urFM+eYO0yLpUj5WZODOrv+9dRYnPLGAqVEJqkFJ8qO9JovzedJWwcMBUZSZwDihYeaRlvlCKnaPDMw1drwrG2uJbihOZrQJfN7q6QtyWNMPsG5xB8+/HU/xKcIF3McCwwuX6EYAPenx3Qb+ZgIDaa/bYL/9o1bXwzlHkdfK1TFKmUK94iJnFaXtUhtxgguMuuMejnMpBR6BG4AcdFPC7xMr3RHjjU1qhl9/Qffqm7OJIsg9pWRhZhTtxf0Y9sknzHpWVXgduTd8zoeguZqqXvzrbZ9h4oSoN8BeU+RZqid1HA5BHLzg9yxoZ+avMIapfavJrsjYPotYE9bBiy3YYad2YKRSvFhrprSq27h6X99/W7nI+eqZ19cj2OR8M/i4zsZNblxJEtD3SkErL496O/tm/ce297nMGW15sEJ3cxKxYovWsLsBV5IKtVIjLuoNs9rOhnNDO1C46R7cGhIVMmsJpQm8lqE0Xb3FMEcyowK6/LrLfFUmPVJEkOMXcNdhVjeXmCJH3/1G7kZoPZu8mdm2zSaZpWQRIJIIUhGU0n3vfHglbQ9qmJ15If2Z8I0Pq/0yWKIpJo7HRyuWyi8p/wkkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 07:50:17PM +0530, Garg, Shivank wrote:
>
>
> On 11/10/2025 7:22 PM, Lorenzo Stoakes wrote:
> > On Mon, Nov 10, 2025 at 01:47:10PM +0000, Matthew Wilcox wrote:
> >> On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> >>> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> >>> text sections), the pages may still be dirty from recent writes. The
> >>
> >> That explanation derails my brain entirely.  Text isn't writable!  How
> >> can the pages be dirty and file-backed text?
> >
> > Because they just compiled it and it's not been written back to disk yet :)
>
> Hi,
>
> It's not about compilation. My binaries are already compiled.
>
> The issue is copying those binary to a freshly mounted filesystem.
> The page cache folios remain dirty until background writeback completes.
>
> Reproduces 100% for me: fresh XFS/EXT4 mount -> copy binary -> execute -> MADV_COLLAPSE fails.
>
> Detail logs: https://lore.kernel.org/all/0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com

It amounts to the same thing unless I'm missing something? You've done something
to write out the file and then immediately execute before writeback completes.

>
> Thanks,
> Shivank

Thanks, Lorenzo

