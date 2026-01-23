Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A74D72379
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16ABD6B04B4; Fri, 23 Jan 2026 07:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142BD6B04B6; Fri, 23 Jan 2026 07:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B996B04B7; Fri, 23 Jan 2026 07:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE1886B04B4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:10:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8573F1AF461
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:10:03 +0000 (UTC)
X-FDA: 84363110286.07.0D2543C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1EFA640003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:09:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hMdjIYs8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wJlW5Lsx;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769170200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=63l8M0GQDbp2K5oF4n+pEeIVSfNb4KY5rBpgqrCNRG4=;
	b=Sq4CVcub+DE5Jrm1r9UpPfWrURzTQZZuGX3dHaceKz3uOcZDzQ03eIFAZv6eGUzbnbomlR
	e2NYYDbXX8e9igSAuRRV4IwfXMgogAVhxEZwsjQGgePLObS6gbGSk2mF+nK41uYQl3lzQz
	fc+p3QhKyWaDo0G0Mh1Y76DMVyILCYU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hMdjIYs8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wJlW5Lsx;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769170200; a=rsa-sha256;
	cv=pass;
	b=XudEg492rjycztbFoMV8SzLnotavjncN7FEBDcBmgKjzIVBtFvX+s79vnVcJv/xiPAcrVf
	ZKm4u6M1mKJI6V/8QPsBbrGyLs61B4jUFR4sDKtJA1T3kIiIcx64F/b2UMpjIvQO5UtxJ3
	VDt8W+VImN7PaHlAx7NUwTLg9PCVhz4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3EIN71631833;
	Fri, 23 Jan 2026 12:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=63l8M0GQDbp2K5oF4n
	+pEeIVSfNb4KY5rBpgqrCNRG4=; b=hMdjIYs8F047DSeLuozF/Xyr0Zpay99bwP
	dORoGiZmLurmxuvC4uvbuc1wtOhBodTvizU8XaYbByigGZXJ7q30PdCTntC40JK2
	aSku5CkF9Qkj7OymmcixoEGbbIyKUuHLkRKPcvk58lMY6e+LADYp+6SsYmAOFfvs
	4NHC4K730B1tn67tMBN7Nur2zCxGp3eiVNDh0cCxzQO/VY6DfT99sZcgrJ44h+vH
	Egso9lQ/8Dx+y4f8CU2QzaGxVqmRmCSRPVDjlg/axw5jMwelGy2nzunUv48vfqui
	FEQUUplrWTfW+UzdLBnZtkSF83h7i5rZfdgqFTHaD0JlQLJsMdfQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq26au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:09:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NBE0R7022766;
	Fri, 23 Jan 2026 12:09:53 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vj21cd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 12:09:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kvb3+Q0fKMjfYrL0RSMXOV70QXUHZ81RxwQnW7ie1g9LJJVHvFjkcMgPQWqDO0tG4EHpm8GqLY9K4HLCVdZF3Hplt/uqA5rQ6YXRVP1jLBXzyq5TB4X/z42WA2SFQBPfsHZPmIIycAW1pPAOXFHaogN9e/VyO7rU15kvP7rY+6usJnuxeLzL8p7uKXV2UIKjST7ye32iXc3Jbd+ZbyHTGta3gSQxKCBoGxMMg/ZITVAXzigTkNmfeXFwqS9ZNw6hrkXr1t0JsCVHMtaslUHpgCfCBdBnzjZjSSB1NVHCvimA1BYYR2cfErbctEiDEK9gaWw4I/kfXroWj22lD20HzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63l8M0GQDbp2K5oF4n+pEeIVSfNb4KY5rBpgqrCNRG4=;
 b=cfncrY5+8Ohs4Rc9n3LPwHSCeHcEmnYT0nHzAOsTNk2dAstipVtamCpbTj6jIMnuGYsO98AKu67geunWHeh1SzMamYNNRDq7KIInZaL4eFxXzq9IfXxrfHfrSEC6PBUdvpXrD2a06qQOXZ4RKbHpjDCJk19hQHnBmrF+FM+pcTGsx+EXUjy9FAYeTi+eU5F+7K7f+TB9N2NKy4yXJOhLZWtrRzoZUpFBrWClMUyqx29en7+QFjqf6g7Us8FUiqWd5mclVH7oKwm7E4qKn7DyFU3raxlSEveYsw29IuhOczJD6e+kTjouU9qcQ6rts2s6QTfSYYVot9h4x2dntjGcRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63l8M0GQDbp2K5oF4n+pEeIVSfNb4KY5rBpgqrCNRG4=;
 b=wJlW5Lsxxk8vDm6l/AP7iOFqtRTVqX5HZSaiG2wQ279MEfpGNeXexMMbXZl1Jnj52Kn1B7lwY8P5JPekDjz7LeMEbK90GD5h+qOT/WAIRlooZ3QJaSssWeT9rJJKwc3T38fxNI6d90rovY5bo1XY2ZiwvSZrLMcjB7034AyN1S0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BLAPR10MB5012.namprd10.prod.outlook.com (2603:10b6:208:334::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 12:09:51 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 12:09:51 +0000
Date: Fri, 23 Jan 2026 12:09:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <04fc8a05-245a-4422-9e27-704ae2d2894a@lucifer.local>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
 <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
 <99b95c45-7bd5-4fc8-892a-cf9c69335706@sirena.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99b95c45-7bd5-4fc8-892a-cf9c69335706@sirena.org.uk>
X-ClientProxiedBy: LO4P265CA0288.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::16) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BLAPR10MB5012:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1c105f-ffbf-47d3-ead1-08de5a784f88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CCahuHM21so6Jm/F7gMuiVcHX77A22DW8xdKGlVdxzYnI365SluVijEIr2CO?=
 =?us-ascii?Q?xtg0USbmDR3iAjOsPkBho4n5vpaKroHRdk0HuGmYesk/3MShxalPmyrM2w3W?=
 =?us-ascii?Q?I2yvQx/OvN5+BfTyGvpSeSYodAHEVf+1VGCSamhOuY1oa6nsWDIV/METwT5N?=
 =?us-ascii?Q?DfyLgQWjfXYRVFnxUUymCkAkixF+I98hspj5lt5/YulitEj4GknjsfRywkOc?=
 =?us-ascii?Q?+cQ/onh/UuCA6SPjFRe/dpzzNX7Pb9LpHNJBgqG0zFlygKllasSP5H4Vh7Pd?=
 =?us-ascii?Q?aT2hjhVFVVVJgCkdLYxx0VRZ9qwtUCYLojoUXjwLC20YEolyxZJmOHdJpfzW?=
 =?us-ascii?Q?KKKaLqT3V8JXDP2YInUE92rv4mttUsdAwblGZgEu4g1EKAs5G3TG90BxNK/C?=
 =?us-ascii?Q?NoHgLkUl4TuRthxEOtcRgkpt7+EzlX1OSlQWaXmCyIG/Wb6E8mBPc4LM3Hhl?=
 =?us-ascii?Q?aUh8QQ0sNgGvxxb7ksORvA2HNqIfyzEqm2QeAWxEk/RvDQxSNVJ2+kENH8Pz?=
 =?us-ascii?Q?7bS6DN8CbKoz80LRO+qa3RL3Sx7e2jWkLSvQBLQxpYxV+FvQz9quKRw1C4oT?=
 =?us-ascii?Q?9gsuXnR/BUj3NJa+/CFYcWxGKMUIIeEavY2NvDVbhLxPHjDHVoaxPJg/0mfj?=
 =?us-ascii?Q?oM6BxOC9NypNZ9DrfVUuCSZEdVkas6n8BPt8S4rWYXFSk55dDRJFoWaTe7mH?=
 =?us-ascii?Q?wu9yj0FXMl6hONNyCoZtiaOyMRqxzhJ+kM91DGdmDbSoXNHag/gWGKNkLB6k?=
 =?us-ascii?Q?jO+O8gNzsi+2m23PAecHLayAe/aUEzrTDCD9lSO1HZwqLv1z4t4MSis38zEh?=
 =?us-ascii?Q?RrASykKMoIzneJ8HzF5BfjEakwCQDcxFRtijHg1vAr50Cy1SyUre1z9mgxXp?=
 =?us-ascii?Q?DdFRT1nJ9VlpXcvvjSmtL1vUG1H1B6AWKNFL042Zgnt2nh5+jkdRLXYmiEdE?=
 =?us-ascii?Q?JUJz9HIhCpqufa/vH/wR4R/b5+qWsFzhf8pxVFk6YhnMxwDEDnqjKpWON0Qq?=
 =?us-ascii?Q?0U+C8xOtXRCIbwn9OsshY1YbUgSK4T53w1PUiZT3o6EoilErSsbGjex7PbEf?=
 =?us-ascii?Q?DsZv9n4MYm+1Ek0nvp5ap8+05yP3Stwo03ElgFb0XS511HpNHTzQusQ1SgzC?=
 =?us-ascii?Q?4pdasS2gf82+QJy87FlrAGovNfkvaaUw3W40NDYHWlY971Peei7RZLRjFjxq?=
 =?us-ascii?Q?PVRG6JCrgbfQOVUL94CV0l/O5bRg+sXMTxOijJi0U3dVhw/BBFcHUK8GS7OD?=
 =?us-ascii?Q?EBwYHVKfqcnIJ+eikEtp0HKVtv+Zmg3VT/bVxn/Jxx6K8CEccNP9xQVesOv3?=
 =?us-ascii?Q?DGrU46Di0lOy9lAu9EQUGIu2E1LtVveVCPJpfJcVfbiFFz29HzFSIio+k2PW?=
 =?us-ascii?Q?mG9uUaxweOmrxFqnBAfoV0l7wndRfJsfDhaYAPcikwZIYKeK+kPEjQLl9yqe?=
 =?us-ascii?Q?MB/o2X9VQARRnGah37ibvx/XVhL+BYLhEvnm1gBjVhUaZmfMwsTI6WMFSlIA?=
 =?us-ascii?Q?cjVW43LX8IVK11V7FwT/3Vd3p5+Ku5q6trzX/4z9Br4I+hbt/02R8JEvh0pm?=
 =?us-ascii?Q?Zu9TdXppK6CFatoqhWY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bLDfW5lWXbQ72xLj5ICfRptTkVUIxGxU/59Inkj1Bvl5AzVgJSnpVkpEaQB3?=
 =?us-ascii?Q?K9qTub3iqPk2Xf8cr4umwGLkdzwSvkANL7IBwxKdQ8Q91klPlGW5GwBca4Al?=
 =?us-ascii?Q?tGcC4GL1FJBkACU5uo6U+FWYeX09gxQ/+UdxneDO6xj2+w8lo4gc7cwmLtVW?=
 =?us-ascii?Q?s3951Uv81YSWyB/NKCwHulpzL4eeryVzzwme4WLPNzUAVb4uz/Es8B+eaBh6?=
 =?us-ascii?Q?ZIHbgG6XfIK05X8iJ72T8SxcSDZYjG7zhDUIJpDySbXLM7hw9lniEnXlOYO3?=
 =?us-ascii?Q?iO7reC2g6my6tVjsXem0tz3ZuvEiXSBKculOQ+Q8ce8j7fdDpe/KOG76HgAV?=
 =?us-ascii?Q?Tik3+h/WPcdHPdPA4QvxDo6kPsWpSM6lUDvn2uybQyGYOd+y7mc+MGSz9pBM?=
 =?us-ascii?Q?DbgfzCYX8uInnobvG5UL5LvKKB+VIJAF+7oKWY/dMUg/whmUXM7SjCSVjuCA?=
 =?us-ascii?Q?WL0UgztlbNTz8QuCm6a3iS1GFA/ibgwZegeeCfzA4pcBzmvUP0/fb63EicO8?=
 =?us-ascii?Q?G/DZuQ8A0iHR/RjybCzuPzQm3U6fO6d6GC8ndrrpxvOo+or4abIjmNP9hHF1?=
 =?us-ascii?Q?j9e6J5V9IdfEOjLQBsMtHDmtMyZherUptMm7luReQCjERjdOMqObiSbNWFn5?=
 =?us-ascii?Q?uXh9/F79Hw7eplQkU71cC8swToAf+lacsrZdXjGSTPYyBllt/q3gGwgaJmH+?=
 =?us-ascii?Q?/MOeCq9O1Ys0dT8HQ7O8/cefzuNil1OMjUWrXhs4BEIe8ZC/aqomSzUz2ysS?=
 =?us-ascii?Q?NBuieYyJEkALt9r5XILlTsecLwXP9IP++GuhJFCoodnero/buYI2SDQUHpQo?=
 =?us-ascii?Q?KeJPP1iI0kLSMsyHHXMZID1y1Z+xIdY3ErvIrsXaE6+k16eeJrRq+FCQ6FHn?=
 =?us-ascii?Q?t6R5AJr9AmK1ajdVsZ6TCYz/peuVFlDcR9yXmPtUzZ4vGpKgkRJdo7MdyNhp?=
 =?us-ascii?Q?UF6SF4i/7I5Cqe6k4xoadrr1jpajzSXrqTecS+kbzKn5fx9sxUBrfjWxhLrg?=
 =?us-ascii?Q?Z1M+fnJxCH6ZQwFnBDVyTzQ03OuNfL+jrjxm6lSDVhfok7Aa+BVCaJEmJ19F?=
 =?us-ascii?Q?VU+tTx5ERxv1jpfXLgnDYsbVnpO8STyez41gFmeg+I/FNO3EEnz+uTig04jf?=
 =?us-ascii?Q?8hzZLFCssmILY7QZl3TzOdKEksB0pAYlSKs8RYY5jUxGu6OtrLqryT1bjVCO?=
 =?us-ascii?Q?1LIKXHviXe5/xajonoLh4ofq3Zb6JwBFtHqAOlPmoN4zSgxrNOFNr9gAllOs?=
 =?us-ascii?Q?2+elz/Gi/sjdKh7VX1M705nl28K/zHVA7QGd90vXjIv+09IBn737MNwspIb4?=
 =?us-ascii?Q?ptzjh8//1QhxLA1ZbdytqwZQ3XdZeJLn6u2Fgg75cvypKSrxdkOKhMbegRgO?=
 =?us-ascii?Q?mms/Fo2PeDjR57wIqCG7LnbrPGAlqhz+4vons21VlaunJHo40iUFpZezZmJQ?=
 =?us-ascii?Q?L2VQo0xaKuE0U1zX5MmpsBm+UOmwYztf2kKorTbRWRrkDTFyTi5T2llha9f1?=
 =?us-ascii?Q?YklkR7kOssS8dX62pdHwpshxXghVDIjTFr3KwkFBIvOAMniTRQeJgEiDhLl9?=
 =?us-ascii?Q?uJR5eQmyrO6kJueD5dqeL3hEQmQ8L+clAKmEl/ivAhyij6s8LCX0Z+kHGI2d?=
 =?us-ascii?Q?tAzxJXHyOufkJPmLfScrO0/gYp7qM9czOavz1m0BuQGS5CERv2oQJqK1dXDD?=
 =?us-ascii?Q?r+JzKOO9uzbTNj69Q5weCLWC9FGfi5uH3L1pDD1lh0Qk8ZliIcVk1ldf0kCf?=
 =?us-ascii?Q?abwgYm16JA2CA9XtDEsWamuKgJ3YSeU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YYjZPUvk5FC7drlP6L+egsCjPKdTLFhqZ/C3ZMTlJNHXCBwoYN7AhhEEzN3MeZwZcygJ2I/6QSb1aoH2ZfQwMwnQ9iEYweT2iIOUwp9UDqAu5iBgaGfeNCQAiCVxH5qL+KXuTnBfsg+zU6pl4Qcd13qsVQSr6NEGSz3bVI7Tp2Av96yHtZ+G4UDQknCN00lOUw3JB+QvewQPdkv689DmC0U42gOj0/m3f0NOUHBTVtoBl1ubm5OIM4GYv/WjvWT9/SFSOyl+/6pia/zrkEvBnduDz38OPA8jkjQEA5BpTC/NwDunsfZEX/77UewlmlQH6K6zgs+0K5YDBJp+lFclMkJmc78inwZ087P7HeTaasXUHcN7Yle+BLQLGVeSZP1s+ad56TLWzSFBJDkdnk4CQJSd/8UqUw6xAeTMXGqdnqgQ83sZqO9oculEvnAVuXkNjPLOpFEg3NIoh0XSeSdJbXTva/suotSC+CoSKE5OznHqYAxfGKdFqfSkCZfPZSkCUr6f7W7pUfR36hfTuoHrQWEtDB5K0XER8O1cjy5Km7hV91dmlFQRQ8hRWuddUifiUaXM/QyD6p51SDIJNZluqXN0sWqFJrOqvx2l/ToPtog=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1c105f-ffbf-47d3-ead1-08de5a784f88
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 12:09:51.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qL0YI+dus/TPKuSYMQl27adHSNrTj6dBSiYdHPytdd7ZzpbS+yVryb1V90v9AM8lo2Nzv+5DIdMjywiJ8u6JiKxpQwv3AGTTKKMJC4WCTKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5012
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDA5OSBTYWx0ZWRfXxKamCH/nmxNr
 TUA0ccT4gHG7mxCmKk8ITjbHCBGisTY1sGUBPrca70y5FaPmdfJVFYVPRpymCz6uRe5sCzc5Rh9
 rnqE9a0gXQVMDbXZ1uhG1uy7iLT/tLuaSNMdbhnWaZPnBDAjLxwW1VRPtmyshYZ74JrUFflHgRu
 Z+xA1z1I8kHo4pSt7mHfTeEd8F2/8hpnHiUgdZs+LJTZNXR1q6c1ICovxVuecEKl0V0bXaZWzZH
 F6YVBdiVpsYWwGI6p9QDKMzOVAH+o9UFPRJkMi/7/cT1ClwI1077SgOd2fRkTeVdnzY/Yvi7dbF
 4OAFfQTTjeUFZmBEj26fKG/kC0xxuNGKgFMC+flmV5e2gjnY5DydctNsDPkNV2OZBMJtjCI9kN7
 JmdRKR481iWv7A9QkM0DHvYXTde87T6r3aSthv24JBL87EHvo6zzXFpDcqYc5z2GbJOvhYZpPF4
 B4p+M8GJYycZ01H4cLMIsKhlah0WRzXpYa5Zo6As=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69736513 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1vdk3eQUXgcuT1abvrwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: qogwcAXLKkywWMKB8hLcgRwEOeifIZRq
X-Proofpoint-GUID: qogwcAXLKkywWMKB8hLcgRwEOeifIZRq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1EFA640003
X-Stat-Signature: 7s6ejbmm9g4egq7sodjq43iiyhbw6duu
X-Rspam-User: 
X-HE-Tag: 1769170199-327452
X-HE-Meta: U2FsdGVkX1+/O2FG6SObsiTkQ+uiVi0sYGi/sPzQyFpZ/TS4QT2NsJ0/DNMCHpjvttCro6ldUUGfomciB2DtNUEikp0fbimnP4UfxbubbEurkgSgFntxcLbWIulNPJCtlXY/2zhfj6AnAlgi/RY5FB5XCrMLXqDLLaJXe+oXBb4WrErxP9QWUkLhJR/6We+CuevefxT6/2rEDbXWshc4iNiWwzo5DAk/TjEKHw6AQDfS928/b5/HhOCoH7lOFrD3ya9XvVD2U+XJlL1x/MB9l9nhmvn367N20gUqbMQMgpR54nDPJ596DbpTw9oPqhsnZsi+daz/bXf6V/5HKXRLuy6/w2zT/S/aEc2VXPKh7Is9mdIrDP3DjKddnW/jLOPYlSbwKxqXFq5Vv/0NMGiCEB3xLShekrAI+MxofC9qC86XlgLqj92d3TDw9ebLJPpzfif59bPVG/W9qbGcK3YXYdUKM1mhs989/N9osjtnc9P2FgyiCf6IwyOR0z3vU8hwl8fqC6ZD7U9wexKtM+uexDNg6RGHKlVi4Xb0M34J/Vz2WgrTvl0YbT+TbnDf5p06ht4HYswdT5kkBzeFTAJd07rpwSJbFIoR/QDclU+Nu7X4EKK+Dk0dkGmsW73WxMKuWqkRtzaARQ+WSuqG1aEIg7PCJwbdVO8zTMSQb3cuybhSmf3TmeHtY6TD3fObd0xlgzz2b/SSDNQVPAw1P+fZnSkZlPFUgMUz+4RbIMzTYAx2Ht9MLjlz4G8V/mn+G0Z00RpwLpnTc50Hj1dF1d9fbmm8Q3IA/u4aLznDLkWextiEoVd6H84xJm+viWE8pZWAdnVymvIkwGRgpwss9gWCrhQRixC+XjY4uGj4cRtcJNWcdSLy3W7/BomoeUmdhJafScp6mTyTuXKf67uc5w88Zm6K0NlWRpMBv7Mp3XEVsufGunOS3fPtedfe1Ggf6uy+In8xzj3wTzDCdey3Mrv
 +7mLWaIK
 Nk566LVKQO2IAOvWaJi6feBiLQJNxk9FrsQ3+mFdLtgvgSzyapUwviZto20Ff6Ga5GQblbYm68tqzpGUP4DYaO9z/gdOpt0x7PSOdOxwkMxkufQEgq2RvYSukbqmq858kl4SD8GyYydlvTihnyRCWslHvYL1ievNddJKAkeaAV5KMcU7oWC3eDbd1IGgoUtKLkjufWG+lR6Za7ga5aUwfXRVDAl2eSZat9eLNIIYmYm+gk3cr0DDp1izZ+tD5rjeehUmkL7zAUPNJWsPmPHsxIAPYOR7KzXnPFckMDyEDZSNJ43/6T5MObmyzBRAzzEOPdBdmMu3ASQgDLcTWJOIT0VuIwCz/Ed53MeSyIxdxo4b6dyWjPN+zZjMg1vhkPRNL2uQbTdqArCZDnljcuzIa77/I9gL0CWWlpNuV0GZpE3xr6/ydSngwyNkZJ7SQL6PFYdBL4k8dl0l3hBH1c2832b8hxOS3ns361hpWGmN84QYlCnhkzmd8JY2pPSkXi114telgWTcfaIvBaYcTsbULHNi6WIXubQNsMC0sDvzodNWBMcBuFTQ7nAPaHmru1nQn1fL0AdtLI2B2xvRlV42pNZhu8dL3sJHZrwk/KOKIzT30cErgTDgcshM1pw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:21:39AM +0000, Mark Brown wrote:
> On Thu, Jan 22, 2026 at 07:13:06PM +0000, Lorenzo Stoakes wrote:
>
> > People have to edit this file to add a new test anyway so should see
> > it. Something like:
>
> > # IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
> > # script so kunit knows to run it, and add it to the list below.
> > # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
>
> Is the Makefile the place for that or run_vmtests.sh?  You don't need to
> edit the Makefile to add a category.

As I said, you have to edit the Make file to _add a new test_.

The point being you will necessarily see this. It'd be fairly odd to add a new
category without adding a new test.

And since you'd need to update the Makefile, putting this comment at the top of
the file immediately next to where you have to put it makes sense.

I mean by all means add it to run_vmtests.sh also.

It's all a hack, but at least this way it reduces the odds of people missing
this.

>
> > > +TEST_PROGS += ksft_vmalloc.sh
>
> > Is this something that only kunit will interpret, or will it impact the
> > build in any other way?
>
> KUnit isn't involved here?  This is just how you specify which programs
> are run by kselftest, this is a Makefile in the kselftest framework.

s/kunit/kselftest/.

I use the mm selftests locally by running sudo ./run_vmtests.sh directly. So I
don't know how TEST_GEN_PROGS interacts with anything else.

