Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16224CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 10:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE446B01AE; Fri, 22 Aug 2025 06:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441326B01B1; Fri, 22 Aug 2025 06:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1846B01B3; Fri, 22 Aug 2025 06:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 150186B01AE
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:26:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CECC2C070B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:26:42 +0000 (UTC)
X-FDA: 83804014644.01.F4B08E7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id B02E3C0007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:26:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WWHbfAnt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mR14SWdO;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755858399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7TJ7MV/lvkC4bPcy52AG8vdQpj4646zOP3TQNQ+tCg=;
	b=3ZY8T8keoV+9Hc0NTyiSwcqzYhPjwsY+LcOxoqzWJ7BjArTepk1kjkRsmvlBf2HjDiRquG
	bqyFGF8JD75ufkxHqEIn11judMX6dIgfsmKzrbcMktRBoQ675ymV8JwU5FRfEFdDzNy03F
	gG7TFKkBzEfmbrcFUtci5tpM++3pI00=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WWHbfAnt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mR14SWdO;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755858399; a=rsa-sha256;
	cv=pass;
	b=ixTmcPI+UlnmGUXcB4zP88XXLBeav0mM7szefct3MDEf5JKwL83JtZWz1XmM3af+lJkK5J
	6CiOMWlxNU6Jax/mst6xxLR98qQgNWZIdVmVTskeXcsa1WexDc3j8oxgJriRtCI4w8BhJ0
	j13UHR1FJZZHYitBQZRB+pj/lkEuJys=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MA233O028088;
	Fri, 22 Aug 2025 10:25:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=R7TJ7MV/lvkC4bPcy5
	2AG8vdQpj4646zOP3TQNQ+tCg=; b=WWHbfAnti73MT9ORmimG2+8ni4XB6ziY30
	Z9fCgM/MPeV9SfdYK2PxmrUJnQRymVVtfeDCZJDrbkoKMxqsoOCST7MdC7nSchBv
	F+790Sq75OjYpWCc002Z5vIU9X+xhP75p2E9YkX7/vfEiNP/ONbUz7m/mRz9McAU
	d+mhyWc449DI0ExESn68SnjYHDTH0hUud6WuZz8k4fprlAv3HGpXHu4Z+BJNrFso
	dK0pFPWJx3PislZ125Esp3xsIDOB6wYl0V8rhFLcuoX/psYmD3OiCzHu8vPhFpCs
	v28RwjulvCMPBGB1YutW/l+bkAKlsuY7UhEjtjbpcbwXZS/pQ7Mw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tr5762-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:25:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57M9IfAP026993;
	Fri, 22 Aug 2025 10:25:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48n3synrk2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 10:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QBu9n4KAIgZsOQ8/Z2h+mgmL6X/duC7aCdw3g29BL+6QFE4+k216L3UKpw/hX8wcFcyqEhMBZ0AoB1qcm2L9AIfka9VHwWqgWghj9X1TCa4YOlzabx62JwxlySjNf9UobQ+2JG5RUd++9nBHFlM2Y34K7P0WlsNUBpZJNKbPPbNSUeUz5kNhR4HNsPfBoFrF3ndP/my2fWzH4j5/aCK3SKh29Vz1EwQLX13idKyyJfujGfP44Rcdf1PRTiBqiZRpgdEFmYtqgjLcvEs9ZKRWA0khHcyw6jzHATPZIZywc4r+j0tgjI9hpdgU673gUAqLcVxTQ/2r3RmjtHdJSmTpjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R7TJ7MV/lvkC4bPcy52AG8vdQpj4646zOP3TQNQ+tCg=;
 b=fF5TUnNzisPkILV336RSSmFDn8uTB0NorLt8VmLxYof1h1O0sKQ/bseT6I5/RbwFgqR5Cf6D/HVw8vbz8SXHmqQE5EjhDgOObL6n89Pdj9G57s5C0cT0taAcjOtsH3Nx5nNEHDcQXhXm7DHE52awUgL8RND8Yent298If0NQJu1FHpPre1pz7QcNiFAqq9wIn/8n7o+capxhDV3QhRSBivMCG0A4wShSy+YFyqfFLxkuLkQWvyg2qqkt0z6tjtZh+B+8eG+owSp+iTPW5ol+c4mUhZ3PftrC3SOXJd81V44hK/daUSbBxVSYt+m86S0RSLHWZsLtFfz8uINhxqtN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R7TJ7MV/lvkC4bPcy52AG8vdQpj4646zOP3TQNQ+tCg=;
 b=mR14SWdORq5SEWBmDgnAVMotbjjqRSSVNHw/Nbr61tDPEg9dv9iBEVNSxTPyXOEXdVPqSyNYlp3dQsOGzgWuNjthizvIeaCLTcnLm84z4shRugTouwbMMEEednMymYyq9WrVOuKdO8k0e0eIuZsZJHgresTEkt8L7Xx5jhh2hmM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4757.namprd10.prod.outlook.com (2603:10b6:510:3f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 10:25:53 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 10:25:53 +0000
Date: Fri, 22 Aug 2025 11:25:50 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, baolin.wang@linux.alibaba.com,
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
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
Message-ID: <e17a64a9-eebb-4d13-9c39-bfd04a874966@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-4-npache@redhat.com>
 <cd4dd743-679f-4c55-9635-6d32e6fa5ff7@lucifer.local>
 <CAA1CXcDORXqm4JoHn4ZSEhT3ajsuY2MAPwefMXk3+YMXcpvqkw@mail.gmail.com>
 <20250821034153.uyxjy5yvxx5no5sf@master>
 <1D4FF375-08FF-41E0-9B59-CDFCA6293438@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1D4FF375-08FF-41E0-9B59-CDFCA6293438@nvidia.com>
X-ClientProxiedBy: MM0P280CA0110.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4757:EE_
X-MS-Office365-Filtering-Correlation-Id: 534a0a74-0ec5-4346-5a80-08dde166461b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VnC7PFq1tJMuvxgKqWtCbAUpJOJixkvMxaFHS+i27sjwuxhtXSLkDbG+uz3e?=
 =?us-ascii?Q?rVdgK8yK9u+1zvLtWMklldGZlDtsHRW+OheAq3MqjAbHhyX1MUwTz+uFyANg?=
 =?us-ascii?Q?jfHil4/ZS3tTledgdI9EAVOVvol5XdAx5HDPFVOCOIK5lYBbol1EpWmyLz+S?=
 =?us-ascii?Q?1PFd53CV/ms1BEbxD/O/g6D0GgTTBmi3hCxxysZsllC/13brM+RcZus0d7b2?=
 =?us-ascii?Q?XM5Bo0v2dPOJGW/Q9m90FoHD+d1P1nvjLoHVVdl4mUGNtknfplrbo5hxkuLK?=
 =?us-ascii?Q?rCtFu88gn294VkI4PCUzPg3QKxmtNrnA5ELl2xGXheFddKFGsJrWLqIPTtZJ?=
 =?us-ascii?Q?unfbYnDv4uP4hxpntmfoP10Mh89gCn+E3j84mlm5OqBOn6Ud5pGK/xNJatEJ?=
 =?us-ascii?Q?h5tXrAP54AflEYdvWRvFVgDy1PGN3Zpp1zggzmoVOD4Hh57/HlU5OV9R+ID6?=
 =?us-ascii?Q?8ATlp8xVbprODGjzYPP6OkY6GG0Ehmy+gNoiiEo9+gJCSC5pzuLDtxC6pZMq?=
 =?us-ascii?Q?f3nRxB4Q4/TYcvWSiVbhCQIqcRZ1HFjbeqPoErqfCjckQXA3zPifpwQRyoB7?=
 =?us-ascii?Q?wDJU/HjeJwOna9gPo9quctbwkRClSHwuE4YgdJMZGemPkF6VyhLwcZiYXpUl?=
 =?us-ascii?Q?G9Jv25Q4b87I0TNCbpuFK+X6q/vF/G6OQyFTnaiX4PvBNpsn85cwDBR1sqzY?=
 =?us-ascii?Q?tSmh4hvNNrT4NLZygU4S9rqBRMwVmpicEi2uDi5Ww16ofibR7Z11w8AYWim2?=
 =?us-ascii?Q?7xokAwpmm8od66BOlMWVtdGbwSJNLsZCgyiWpEjzEFl30RSQuZ3erYbSlY1K?=
 =?us-ascii?Q?mcqCNyIUO5nWVdASzckgJc2k/BIJ78LTzwsz2tf6JONPT0eB9SJTlGZlv60E?=
 =?us-ascii?Q?6KWHRvLSMk5pGP1dCIG8SiyYQDYRVmUkipYq/ccU0+WUX3qN2l/QTIc9hsio?=
 =?us-ascii?Q?6XtHivu1kZQ33ovC5srgBYQfpiGIn8kEQdW+Th6Wfp7SZvb+yKpnPq17qN3u?=
 =?us-ascii?Q?xUZSOQa6a3EYQbzGiXeyF8EQHayOA4TafhNDEBVseaL5SZ2avwZcGhCbekVp?=
 =?us-ascii?Q?PqGCFPxlk+8XlvhoL1PhQNcfV5ngKrskW3evtl/1c8ZWNeBCrzRdP2BzT2Jy?=
 =?us-ascii?Q?HbjwnNqFAWF9jV7zNar5+ntsuP6zJ/2E/37ATFi3elZNGis7gHkfUCms6RPe?=
 =?us-ascii?Q?nNkI5b8OhFDqUysphZUAoomlcjEzzpRNy9myP7+VPNt0S8k24Mg5CM97r4S0?=
 =?us-ascii?Q?G+oDAJuSPM43TNimUcKE+hP3VZnC+EgBt2OkcR4lBEgHS5kpB7jMTTunZcKW?=
 =?us-ascii?Q?FLjeC111V0jH4BWMfPF+3PFAU7O+7cl12y/10SM/YTZjbPU+I1GC2oZ7Vbwl?=
 =?us-ascii?Q?laKBHffE3Rb37aqZkIMaGpu3tpDtH/5X7Zjqb+ag7A0pp+lbO8AvApOzdrk2?=
 =?us-ascii?Q?HrRWPxlrjnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sy9ZL11oRRrVpFJ5BB4yA9aiXhx6gJ4JjYC5MdnavtOpw6qCqUgR2apWTKcN?=
 =?us-ascii?Q?ncwt8lSh55L/5W86I3nsA2FBC9f4MN9PHEElROZCYqOEmODr+QSg+oHcwGdF?=
 =?us-ascii?Q?vHqXVHFwzYC6QNS8JAIovFuNHYec4JGhz0Y+MA+dwxY/AWDG4NKbThxrDA8x?=
 =?us-ascii?Q?J/YG6xlBcl55DosNlZkSm90KXTCtH/dtERlobyTQjT98IltnYkTEGsNvPWIB?=
 =?us-ascii?Q?JlhCsylOguqfSdlTJmIU3WaYMRIJEhsh6t7598F9ltYo8D2SNG+HHQCjaI/g?=
 =?us-ascii?Q?QVwIMAry+wHOgQ1amDZL+pYqppnr0qnQI/kHC+YyKHb0kHCpWBnELLV/e1NR?=
 =?us-ascii?Q?2iljeBDVG/JXOw8n37sEjfT9bhuRCgn+DnuOXfWaTU6nW0FEKZUxhj0AoH+v?=
 =?us-ascii?Q?7px2pKwpxBBkxA/6X8pmqwrYha9udyd4wLdVdQs5jrDuZ4n7rQkCH8/YFSpQ?=
 =?us-ascii?Q?3ez9fQWmeq3k95VQk/P2z86k7mNdpJ7XJO0ddmEthxDVj9tPjju5c2jBuI6Y?=
 =?us-ascii?Q?xBMESvJxguvNwl/S3wAs7ZdzN2x3Vw0xtzrXE5xY1HK4JfSc7WsaOaWFSscs?=
 =?us-ascii?Q?jvnLfBfJmjJ8RyS0wvi0urwS0lnJaA78sJvG0fws4NTDXZDtebxN4qQEF8FS?=
 =?us-ascii?Q?U9LHb8qzwXYtJ9Grkk4p7qaYNN7J6WAw3Yq7WxmUfglth51TuwvyQmFV1a7O?=
 =?us-ascii?Q?pzzyhD1/8U4PqRsPO19X4M9/L5DY/dIaSDpjOfh3XuSZ25GmBFi2SzNQiIQ8?=
 =?us-ascii?Q?zkC6Cr4yY6O7URY1zPFOJICIFcW3VUVpDu9iTHf4lMCmMEuidOQPm8Fa5/lp?=
 =?us-ascii?Q?6FyW7Pk6qoc9jUDwgVJFU+/I5YimLeGwue87WxMyosOOkbPUxVEm4cw7nZMv?=
 =?us-ascii?Q?kv91EiAMbnjTT24uXdpA6019heNNPGdDX7hfKla9cWHA7r80GLGFYuNCqB0N?=
 =?us-ascii?Q?KP8ybPu8mA4IKf+a9FJdtWbAk2iRPXGRD1mUiqC/VUZ7uS3YDmlfOElEVek5?=
 =?us-ascii?Q?4sRr7vg7gYsIJr7iF6HsqdBKXnqSqVNFG3YSC4Xzpi63pPoEAZM+eD1jU3Bp?=
 =?us-ascii?Q?er/0g+mjCWylZIhNjKxnnkS92psgxTuocCVvVIIqh5wwVn3bqexpb6hRpyNz?=
 =?us-ascii?Q?h3w8ttZjkXrgGQCbdaUpdfed0dWkyWyuP7XOtscrlq4uO1033XmuI+Yn4E0u?=
 =?us-ascii?Q?bZUgOHlSq/eOIoXMaQzcL441RhfcD8o+BuRIcg8tCnWTO0JG0/z/xADdHw32?=
 =?us-ascii?Q?5XXOcZKPJSTrn9CajWrgFkoiTMlbK9wFC0EjY14D6HpKKQ+OgNpvQfoC+D0w?=
 =?us-ascii?Q?go9UrIKXQDFOhbYPtEzjNhXceNKcH+Zy8Ulj1nrZ4x59Gwm/pV8bGKa18pUk?=
 =?us-ascii?Q?F0bFY6fOfGW9wwVDwzofCUAUdsGxwqSr4vZxBOAgzxAxI9e4L+gkma5yIwAy?=
 =?us-ascii?Q?f3cxgRVLUIKCRPpF2WI5e2pJ+e1x+HeMlpX+XylfL4CCbuOdAl/FwKvvdTdG?=
 =?us-ascii?Q?E+7/kl7QqCMC9+hREpMlR07jvXZHzaUt6aW9ktG62TNrQ0QPxNLj9Ye86yEF?=
 =?us-ascii?Q?y/SXoIqPDWEtvtinPymJfmtQs+Y2n/GcTDAlRAGLbTsT/EFWLuVvpSZD8UhN?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R7aCh5QhbcoA2rJb8LWmKVtG9tZmvgsip0C/fNjWOLEhwKIShNg8SV/0RzyEWJ7tg8Ipyu2i++y30AiCmr7lgk9v4n8XiKmNVCzcOVe17Xgof8IHcKYEKUR6IprvjbS9f1lv3kZrSd07+c+XZ8TxTTEcNgJgopC3Q8KcAuKAUAhA4eaz+HaB23VRVHZwtzwPY2vxXdBevFRZLKY9y+kVoP0RAVrM6RUakom7C9jtgY6xu9+BNByZyFgv/slN7hcyGDnUonXgKjTelvaRJ3eVqPDya4g2Xa9LFecu8UeVDcsFhNNbPr4A6lfPeJmNzvoc0zNMyGue15QwdO+1LkgQn+2VNeR6vnzHgNKzJI3F3PVwfUun0VEPerrMww3CLYuTG0uEBkXcG6Syz3usnHlCuhC3tcqvfF/UD8+O/UXMWwzv8t8Jq4cWh0L76ET7u+3T8W9vlFezaOsX8Yok4/wucr+OQCKDbgHiM4F0cPM/dzgShbSNBscEXb4Wapejpe4FRu7XqXdxk+8liIuDknP2Opg0nuA3/kF+PTT/JeSu85yWXY8AssMVWLQertMz/LQK98qTNGqfFUCWc4H80O9UbDwFPsaTzXUtHPuN4VAMnUI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534a0a74-0ec5-4346-5a80-08dde166461b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 10:25:53.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1lQWQy6Di12zztlkTvVjbGJjShfzkiigKle7OHoEKQwlJYcWfIfMSvpbM4HV7INZaURhTJTFBiIb1kYolih74wHYlel31GS7x6t74tTyJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4757
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220098
X-Proofpoint-GUID: FKNER3xpzYz-9yD-RVx8HnLZZ-6OUwc2
X-Authority-Analysis: v=2.4 cv=FY1uBJ+6 c=1 sm=1 tr=0 ts=68a845b6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=bDDuK8iFC3j3pFaeNBgA:9
 a=CjuIK1q_8ugA:10 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: FKNER3xpzYz-9yD-RVx8HnLZZ-6OUwc2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX5C+53v/+uR7b
 DcRWmCoxq+/IW0VnbgRV9MnEmXhYeDh22a1Mp2Ni+4kzcNge3O/Pfp5ZFPBNRMLm4EeLqwy3ZnL
 DzckFKxo5ksPv+hN+Kcl1KhS2lU0IxEam2nEY7eqAFJXcVijHiop1dS26c647tGgv5H2r1mqyr+
 KJQMkE5Gz9hiBdBZN6Oy4+USq0L0u0wvaCAvOzMsFATTvjxbBJRflczDU6YZJ15Q2znmtSd3VGC
 8XPCbYUewZObLmsqqO+RCSZsiA6yAezcQXNfxfPpR8foZnGEYjrapy8eqQEUzsq97tPKe+qKvjg
 xoE02C0jPaHZ2v7CComOrlqywAMOibdyUS4gGTW6wZmwu32NG+YVg+xTmvHYet1B6hwSgcXWT36
 vOXmwd6BwEhry8ZOQAd5qocCBPs56Q==
X-Rspamd-Queue-Id: B02E3C0007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xh64keuf4j5u4577qxrc88ngdm578sz3
X-HE-Tag: 1755858399-524633
X-HE-Meta: U2FsdGVkX1/M/SMpB3Q5P/sMpC5eLb/odKucQAacegAsfLME2oDBTh8y35gYsEpPAtcr6LIup4h+ITn3uMsVEI5knbYAI8BAc25Gy93052Ge/9Z5XyWBflF7IGYxkDZFgJ6rEewEH1e/HC6Bw307oYAWKYGe1jOBfKC8fRYWe5jxFrLlTWOlOrZ/vwjClz1oZKWsOuOMGs496kRGq4/JDxrhhMtdNIepmPqp5xlZhWc7Y+JVoWVUN6z/qsZZbiT6wT9LO00N86B7GL3dFOxrnAFvSoZ9y0wT8/xQdppQN7R6UC4bv+ICCLuBqmuVtfXaQeD6UIR6SwB6reEv7wW13FWWucNURGIrLiC28OVhW+t2byZZMZ/EC8iVKQHuz/RaOCuD1palxux0fFLC3KW7tzTnCu7gWWRR7DXomP2+VVvwQ08rtqvzuPHxdYeJmBgvznz1ZutCAckpGFcZx9HZoCFCLI16pvJ1qxjM4YrotxCe9uDKTfWC07qt2ncqXKwnagDimKnOIq3b5SvEITdHqEBMzO9W9+bhO2We5K/L/vsZMAFnSfE5dJIJy3akbf5JYN88m+C+esJp51nkll5UswYhH74VyE/pRrNtuyiPcmZlbOA+RRSwDFCkGro0qbLAFFH9Ye3RPcadfOT7+JygMvtmmxyFqrQcof71aeS5dwtjOEx99Ql0CJBJvS4ePQnC+kRkikHNS13qhJBsYsswDOotMPfNsArR/oNV5VXmSNn8Zy4Pbm6o3jyLb6HWU45pINWGsXHs+ZsAX+hg8WFH2apcw/2xwKeAcySPe7djvFhwKz1ENIppd/PQxGjgPMHF1SDmmEJzjqeNTI9xmofCAUX3yzjvB/nPlnuHIRxcCtnSP6+lWwsC0ZcKu09ajTcy2CBXSt9b0+pFkSnWzafX+xzj3Cl6cLXJblHeTAwXsh9SpC6e4HHK3kK0lPNzCBRmtHoe8bCLaXun+/doBII
 hiZvAavz
 NxfcotiRK6jlwgkLnwN4AF7qNzlsL5U7VE+Zszp2GnZKWlrDfkYFEZzWtBnYtuxFZPEiT0SjO7oSXiMwrGqw7s8dR16YS4/Qcwaa8D/xdOAP5lkdyvnXTnpx2Uv+vZtgu3aLUT7WckOxJYj+qwO+mXL0v0m2yoKIS5+nf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:09:10AM -0400, Zi Yan wrote:
> On 20 Aug 2025, at 23:41, Wei Yang wrote:
>
> > On Wed, Aug 20, 2025 at 09:40:40AM -0600, Nico Pache wrote:
> > [...]
> >>>
> >>>>       if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
> >>>>               return SCAN_ADDRESS_RANGE;
> >>>> -     if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
> >>>> +     if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
> >>>>               return SCAN_VMA_CHECK;
> >>>>       /*
> >>>>        * Anon VMA expected, the address may be unmapped then
> >>>> @@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
> >>>>               goto out_nolock;
> >>>>
> >>>>       mmap_read_lock(mm);
> >>>> -     result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
> >>>> +     result = hugepage_vma_revalidate(mm, address, true, &vma, cc,
> >>>> +                                      BIT(HPAGE_PMD_ORDER));
> >>>
> >>> Shouldn't this be PMD order? Seems equivalent.
> >> Yeah i'm actually not sure why we have both... they seem to be the
> >> same thing, but perhaps there is some reason for having two...
> >
> > I am confused with these two, PMD_ORDER above and HPAGE_PMD_ORDER from here.
> >
> > Do we have a guide on when to use which?
>
> Looking at the definition of HPAGE_PMD_SHIFT in huge_mm.h, it will cause a
> build bug when PMD level huge page is not supported. So I think
> HPAGE_PMD_ORDER should be used for all huge pages (both THP and hugetlb).

Thanks yeah that makes sense, so let's keep it all as HPAGE_PMD_ORDER then!

Cheers, Lorenzo

