Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007FDCCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 08:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0158E004D; Fri, 17 Oct 2025 04:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577338E0016; Fri, 17 Oct 2025 04:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418688E004D; Fri, 17 Oct 2025 04:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 299FB8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:46:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF03511A6E8
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:46:51 +0000 (UTC)
X-FDA: 84006975822.08.A679C98
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id B60DF40008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:46:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Bwzy2z5/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tOSB8CPq;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760690807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVBOH0Jx6RQhbWXf8x6FP2F+zHNkPZD1EnWxtbaMlkM=;
	b=7sg+pyUd452PK30/oBazlxKi7Uxspqoi12ycuaipbUwg3ususzFgtfRZH3wCix+p//TWSo
	Bikf6Od0XITyDz0dxd9W3Lm0kQYnidxsT9PPzI52ssTSMf/5UFQi71NofEpYeTZqc2SDgM
	s2L0KeT+fksyIvAhSts0VkCSq6dao7k=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Bwzy2z5/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tOSB8CPq;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760690807; a=rsa-sha256;
	cv=pass;
	b=D3KqSOQxeCJFrkSbZWXwUmyxmxicsJlesarswaacWst1oaxC8VohvFTQ2r87CKmPoOFaI9
	crC7SB70kT560LxJ5iegVV1D8D02OVqmilI9UeECxq+3xz4zRxXVoi1RChwGbcxuJIplbw
	710eOFE5g5dBJhJPF3eJ9gUgRzfRqBQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uROe029402;
	Fri, 17 Oct 2025 08:46:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dVBOH0Jx6RQhbWXf8x
	6FP2F+zHNkPZD1EnWxtbaMlkM=; b=Bwzy2z5/9gAGMHrta0LzyWVckeJpRhxEi/
	mxKMIzyRGggwPwJRLs7+LwmkqytGLeVD3pbija/XnXEkCT/6vBUT8EUMA/O0Vspg
	euDQjjQVmPCvymY4Koyiwmqz22ToWzUcXjp82O+AchEvX1LCzoT/MGgS/DcWI1xH
	NQyCZNjgSIUtvlKG1rYJv9w+lNsybiUEwyPIRGcJsoglEAw6DUJeNuGr0YJSP+Xy
	2kvusmilbVrBG4A/cu/wQMndc8QWxJ2R5d+I2xhASVTqh489neaFgcM4IBdkQqh2
	1SOUK2NOlnWgwTnhcI4yRnhZbSGlnP2BgGdp6/DkVgmJx64X75cg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdncag89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:46:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H6IwaB002339;
	Fri, 17 Oct 2025 08:46:34 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012059.outbound.protection.outlook.com [40.93.195.59])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpjsq1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 08:46:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnK9xvfEPECORhhDi+aqrZ+FL7C1QbbdYGPtXhrDmQPzIhLaNIbyFptpAzUoDrYvHyVD+7KQtUFWyzDakan2uhufBSkAq6s7FZXMUy9iHyVeFl/17wVuyb/3M13/4jg1WuKpDrlfu+TgCMD4MmJsF93V5RLYQI17IZ229crFMWEhAJy8gRQ9MCU8iKsX/b9tew8PbbiuPb/XefN0kf94aqGMrxkVpB1XaFdlBoXGduECyZNRCuzlWyMinHGnDfuTmvWt1jWeqkSpEk7JBH/Pum5qAbo9mnz5W1DuGowZDl2xdfhcZmqK94X+w/mTD6sXVC2UohGbskRRgawJauhHjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVBOH0Jx6RQhbWXf8x6FP2F+zHNkPZD1EnWxtbaMlkM=;
 b=DV2xNNIxHOiDDUBUv8En4xz1ga8vHnI4MITCpbAGggoYDP1Eh+GwsaA1bQOW3w5vbe4K1B06sjTRzAIcrUIuEWuTVCMCMABqwDNkD0xJ+z0FmtkqkoYWz+tOKy8bNFTNfhCmRs71wD6CAgAREvyjd5cjs3vIjHORuZbqxeetutA3ifcysdvxAeCfoCV9HKWL//mpKXXDfSuSQLY11jP31k1ETjRlp0Q30T3n0qrPXfE9LgwjNmweV4EIoARp7ydp3kUAYoYuh8hBeTQN7tHz5p3fL1TwwFj5OkVZrovDsAz08UFJh+P2+kgHrGNwkKhRBP0Izd6PutwXaEXh6Cv3RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dVBOH0Jx6RQhbWXf8x6FP2F+zHNkPZD1EnWxtbaMlkM=;
 b=tOSB8CPqmOMsNv2agPxz6s7ec13ewRkxd6DiYsM3x3Rv+0dt7iv5WITkdHcER+yWBa+4sSxhuYGHIt+E3rQRIQZNJKpUdRmoZWOD9GQ72wCZZoLbhS/yeHjkJ4nGv+UFkaA365Euz1ZsYABDqgJwT4wbT71ZGh45myrUNF9MBvY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6862.namprd10.prod.outlook.com (2603:10b6:8:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Fri, 17 Oct
 2025 08:46:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:46:31 +0000
Date: Fri, 17 Oct 2025 09:46:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
Message-ID: <52d75c13-b55b-4729-a5fb-8454937a9e60@lucifer.local>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-2-wangkefeng.wang@huawei.com>
 <47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
 <0d26ce96-2c59-47bd-a034-d7810ce6aa5f@huawei.com>
 <20251016141051.27e9ce8b47aa242724ae97a4@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016141051.27e9ce8b47aa242724ae97a4@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 82104656-57c4-4124-fe81-08de0d59abc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3QaTkibqjxcrf/1+Z+gm7pHKyJStzodC3dS9esz/KaaFseAwCsLFnIMxfL9J?=
 =?us-ascii?Q?/uUQ7aNW5S6J2YA7alChY6vpgXmg5h+w3Mf9i6gL/GVvGC2rFKdMYcON7DtJ?=
 =?us-ascii?Q?yyTrONW7cVJepoLferr3SoWsxmTEKblvi3TQJjs1NYgbJVok4XmhXwIlvKym?=
 =?us-ascii?Q?OsrKbJQLLO7aCJ3Uz96GVEJUdMlV3Q31sfxhPkC0YjPZdCH8d4T4T2aCcuGO?=
 =?us-ascii?Q?AtMIZbu0hlopbpjTSf/tJ6dK4l6a/A9r41N6W+eYy/7IVLUdTD60EzJotIib?=
 =?us-ascii?Q?SOnwzbDQocGH5Bv7LvIUQ0CDQOAc9J9zZbsV9YqQx6E40v7cr4J9dZLYtJ4n?=
 =?us-ascii?Q?FuEnNS4/zSyL8Bi097zUXkYZXFGH1sQlOf5kpLBCkE8z3rtO1JCsnNu0+j07?=
 =?us-ascii?Q?AiIPCye+WsQDs+vT8Q2Tt0C2nFiHeet1lrLAKWK2u/dXx52ny7zBpuIhQxLA?=
 =?us-ascii?Q?jge6gS9YzlPZ1eGOgrHxVf0G4w6cAJeOF2godnwZOHEzBNyq5hJJzn6YuDl+?=
 =?us-ascii?Q?In88RUqpX0v0aMRMJpcb1rsHxsKRjpMPg32nqGBdJv8yFBy49irZMVWgEQ76?=
 =?us-ascii?Q?8oGVqc+Ue65F6wIsFH2YzFPOjWE7x7405othlyiC/HXV5xhSho9TYXgFcedE?=
 =?us-ascii?Q?b8UCsIfDbtBMMUeul51qYczI7aEqQaY2lLfhYTwjCMw8bj6URe7+JUmq9G8V?=
 =?us-ascii?Q?6ILfekRW3YDuWNlKMH71A44vktDzWMlPRg2HFUqxbcKBy2cgdgYgJ+FXH7t3?=
 =?us-ascii?Q?WFxT8hdoiNxjfDkk49Jf8jAll1R4TuwbRz/99WFuChjg0dWiMVlrfXsajS5V?=
 =?us-ascii?Q?xPz/vxfxhEx6o94k7NNtBJ4yztJSuAhu5D2wm9TEIxp/rLwQwC8Jbp/EGBuI?=
 =?us-ascii?Q?go9kX3PCeTOUxWgiWkDi151cTDm7fZph23g0EIFDHKD4ZMZL8h4Z48jk5CjV?=
 =?us-ascii?Q?TpPFjzgVl1AiUZMD4Ea6ZYmDQTTuQw2hojcY9WHoCYoA3PeIO3gC4uv5Y1ub?=
 =?us-ascii?Q?Bk/CQuuWEwDd19flmCIUxQKkM+F/R2tvZ44MtesyoqkS7knIoQyxs7o4ZFf5?=
 =?us-ascii?Q?tINb7Ou41kXkJMhgo9Ggr+oAb8exDyy1H4acsPqF+rB9NQxYN18sCIOsFzU7?=
 =?us-ascii?Q?1uNQMQz+ZZOxtE1zCbJX7IhV5tHrUnQnwjqoK41PTgoh2MPC3GJVKNhnqwA3?=
 =?us-ascii?Q?tbI0uZfdkMfx02BUXSni92DJFcL2+V834OWI1Ly1KNAAfQNXoa/fBbQUofzl?=
 =?us-ascii?Q?TjraJjzPTmOhSr95LKyZ4VjVGZY9aYLy0iuIjkyjEd9ZLGdJUDzL75cVNY34?=
 =?us-ascii?Q?2431SFww251o7vui1407Z7/yTfz9ddR4zKsPi/L7IEqeXruWvBMT0Gnp3UWy?=
 =?us-ascii?Q?DFKJbGCs7w7eSiwWhQ9FlI7W48jD+/1w7V05BGaNPF2a2zvONpx0rk+yUFn4?=
 =?us-ascii?Q?UlFrxyqKbGojqImkVJ1ZaSMfMQnQDuFr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?07325xO/NwX3kP7V7A+VTI2tEjTbcOBqcUN265Eb7HqO++o7QwYvaHw18q3X?=
 =?us-ascii?Q?xXMZL0vDrwKDjU2bTUsZXhCtM/qMhWd9oXIVEAUXbEbFcgp4GL3Xg+I9VRk7?=
 =?us-ascii?Q?aWXn/eqUgbMPSJifGrLH17tMUBMHQjIYv9Lc/xN7q4llMIBvd7avvuhlQXsX?=
 =?us-ascii?Q?9lD94ndIcYw84qJIdTy7fd/Ha7C+0iHEz39Af8u4DABHNvxaPBAd/AgkzNjb?=
 =?us-ascii?Q?zYMhKDjabuvPtwrqW7wiDfdOWHxbUoJcQoLTIMQeP1RCHXul5ok89XL9Wm0D?=
 =?us-ascii?Q?kUXIoFGjqafGs8qbJXsCFrdAt0mXIkojX0LJIT8R36O/W+LaDhaVpzWo4AUp?=
 =?us-ascii?Q?+zhur5qwpw2X39dz6/iyF95q2bW0VxUXgHSGBIOnf6BeUGDRnS4rF+ZknF8J?=
 =?us-ascii?Q?9CDx1nWujFQ3WHRaj1yN9I0X2iyN1ip4/fPR6M6FZw2O90J5so+7K8KEf9ld?=
 =?us-ascii?Q?IXT9APF3v67M4W/TkyCScUATokqWtNdFtnUQ3+nWgb+NdBaDam/Q4+4xvsoQ?=
 =?us-ascii?Q?IMc5WniN9yYHfFKww73nGJZ97fdE8S7oyRfyYIvmgiQ1g4pCBpSS3l50c8GH?=
 =?us-ascii?Q?ZEtJjAr+H9KZOmYgI4cNfFWd89rqn9+lL63+dQUvyAFzxeI2SmurD7npMQCx?=
 =?us-ascii?Q?51jsNQqm1DoZV23sVgwzbRSNJ9rzCuXjKocu57If2mToaPhHOjNrMyFq+qSn?=
 =?us-ascii?Q?K9kNEzu/V+CWn8YqnZ8kclSoQSttzapl95LIdP98NpSPu7c+GqV/Ij10WoPg?=
 =?us-ascii?Q?c0Hpe+kAa68q9NOaZX4zBbvZUpDBjRld6greN9IpGi6GI/lWfJLhIOkGWlzT?=
 =?us-ascii?Q?TfXltYvLmntatY3gsyHfMrED/mFkzSwCC1elIEp7OnW43hxrNwqEeyvzwDsR?=
 =?us-ascii?Q?BvDk5XjRc6fCp3B9K+JzZ5NOtHWA1DGhVRiiHMO3zI64MPYk+ZfVilGjFHUz?=
 =?us-ascii?Q?ykZC69j6o6CD8fMeOJ3fPqbuQo152g2CqZjUgXZ9n0yZfCi+1vzjjAqsY4y6?=
 =?us-ascii?Q?5XS9ftU65o6mzKEArMWzuvzTQSPS09aGTI/sW54eAuQv3OrY2jgqNOATYw1F?=
 =?us-ascii?Q?N4TBZpvksKmZcxS5X6rdMXt7ltBzN17IPdBXntILXUKhkVW12ge2GOYOK03v?=
 =?us-ascii?Q?scp79Oqryknz9UxCz9xQomFfvZcR3q5BxS/izZl8zgljbLe+VJ8P5VlBmdIz?=
 =?us-ascii?Q?BWgF9OE48TtEI8DBwaLdeR+vYj8w2H9QEGNl/qkp5Od6Yl21rhDwriCbJ6Vu?=
 =?us-ascii?Q?m0VO9NkfFbdWW9fCz0IoicLDx9NDyNhpPJZqGliY+0ORUcuXTaVp0JmnSYyW?=
 =?us-ascii?Q?zS6ZnVN/E43WtClbBe1CHqxB+B9vRiIQGq2vXy0rJ78t9JZXLM1pdman95Rs?=
 =?us-ascii?Q?HBC7P6DUIVkYzagOVkJa1FfvJFBpn+qLOhUNTiqSj8nQ7DihDtd1RsKAa+3M?=
 =?us-ascii?Q?NFcWbi7YvWyKZqjupul2f5jOP6t+cOyl8edrfDpogJvoRisalYr4+hJk5M6E?=
 =?us-ascii?Q?TsCKOJ+XUiYbSCVfe37i90frOqLTCi8QOytjG2eaRpEmt8F6DrzlQGDWsFbO?=
 =?us-ascii?Q?SNVmvgNTaUpwSXMFBUoy5eTgmYR3lYPa7qYJTsJLefaDmrH6KmlrytgKPePW?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3n2ADkrWyVjONFkyyIng6hX1jwkq783rzE7v6h782wvNCJQHyNXYceTnblMZtbZSvQ64lNkB3zebRdwNQ8rK4QgTz0NXsO/VekR4JIH9jYlRirEDN4rLnfllfLze3k8ammmLffuAPZmHetjNzqjciEzJjtEdHVd0rTUvaZpPMoLEyMZEZmfxkztrfXJKWKxRTEsltJ1F5BUg5ehivsVnQYfjXQqeFrt9kgMmBFf7tQBZbj0r81Mdxpj/0sNf7K7HlAK/p5qsShTWmFyWfoc2RVxEF0nwrUsp2HEoHzmZTwCRwOK/uochl9T4noigswmJoA79vpq7vtFuPvxkfpH3eCUAtaPV8PfRi6f92bZVI6da4uYTUXpAshK2aDoS5ArGfYTwLDW+xPOmdgCdHQdJFCL4/xnO846vw/HBe96BToP31Hu4HQNaqhIgrZyxXP6BP8rHS7H8m0f+9qx5ZfAKVaj80lfdy0Th/FSfNHRfOn1iQRwJCPWgZfwJpPpks0FvbTb71TDFJVuX1e1ib1FTM1NmAtQb8elLkbPbjYfqtejimta5jDPOZev0hZ+50IXvXi1GsDs4oZw1ATqGQe7YFdzq5SLB/z73xFuVBIdiwM4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82104656-57c4-4124-fe81-08de0d59abc3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 08:46:31.8852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/zxmaQKQb7tMamtr4Z3F3gSm3LD/tizNnjmVcLzzm8V98Jzktecxu7EiKlAbvcLJP4OpUSlNoQDcg9WP7muz5dhSCRq+k+cLk0feDdgyvA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=906 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510170064
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfXxs6zzNRD6+YG
 NsBhZ6ZRrpjQdOb7/wrH+2iPkIa0bc3d+vSBV2VKYCmoGiFIeHtzGOPhvpH29oaqjtg4bAkoG2u
 T5h+WBxTfeLKg0DLm/0nAlkjfoupf4aZqsL3Y4CHodsavMUSbK9aRt3lCcyMbr2eXiNRAxbf7td
 kfujN1pAlqZYRz7n89/v58Cqc9rcvKzPZftdTLqZOb+yyYW+Q6QLXuLMp2OKTG857M9+HdZlC8u
 I3myjSCMP9N4j6or6tM+4072LUiMsEeXvx4oJQTT34RBgaOheQq8t8o4z/xgAoONmeRSNWEtzVc
 7x6wYbKwtZzs5gMayS4xi00l/Hheg+eEztxVzDm0qQWTGnbOaI9o81q9UAPGEIRa7BkF4ol7SoB
 /+MKtJnCuv1+le2XIPKpuGtAOFpcXHNMfQVuMXHMJ9kc+FXqvnA=
X-Proofpoint-GUID: NuKoSJ8N-v9V5yD1KAJuNibAwk4V5tfI
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68f2026b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=i0EeH86SAAAA:8 a=d54vCWh--04AKFuDDRMA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: NuKoSJ8N-v9V5yD1KAJuNibAwk4V5tfI
X-Rspamd-Queue-Id: B60DF40008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wpurrpyeix4nmutr8cg8kfq9arwqohbx
X-HE-Tag: 1760690807-700204
X-HE-Meta: U2FsdGVkX1/nniDkU5E64NYrCtD7CmbZCeeW0YV7VoXWSSmuun1NsCReqLu8ZM/0WMTK3d8Q+JrC7u/xiFtHOdb/lRXABrhpa7uc6gTdRYbRmQaxilYzHpd3HVElzXJSYpW/aXc/R5657qNaIm6ViqQBpGE8h5TQqpAg0fllJKvXxQsjpJ1drLZXxjDPLVf+1nObCYcSC3ORVKE96UypfMXywBIclVFVVaYbJEBtxFOicCUf7qDYrl6wr6p2huage+nJpa2KKPfNZPVNJUwEFALqWwsq6JDKXTO+Nf0vI1iKSQHjCafdL+eGXjJqRKz441ILdi4t5szA2+MBCjBbhpJ7OKXevxyWMIGvP9fte5UF5UfP1PghAZiU+lnnKqYQMV1CABQY948ZG6bpAoMWfFOwjQdkX1WGvO2k/eGs0RgbhY4qAsD3eZVtzpOtLBEjB+ZWZ5oAH8DLymiQQsVdWP2ZhFvutSLCoT7qgJRZuUbiSIfVrasctuejOAOUqrrvpAdD9yvT85eqxUkrt6fLS8P9ZZMUaTAdA98nG85iXmtf59UiEd2HmP6Y9jrQcLWlwD5YxnddbPXl8eGK9OqqANClxaMP2O7IjIKw4Hvl4xaY9wXCwH31jL9V6W13hVc6MjYEMQIpDftP7a6fQhefegoqVOcvkvlQqqAg0YDPFX+iRGTTeWKvdps3ULknCtlaspWdQ/oAMeyhy7A71aVgU8ziwqj+noSqJn3IIbS7CC0Hu6uTqKw0ZRlhevO2fwD6tgt0+IRNt6pji1jmbx8f41P1SQ4+1+SQxLyVI9Up6xptTtPVmUrBe1UR8WQVbfVr4rJnMviGxMPB01SH/H5iGgmu4xCQrnhH0wb78tMPfkyOP7E2NUe8ZmKgRY9dAMndnAHkf0PeQU+tgoZlsk6cGRG+4wfS3Zz7CVCOIPQzr10042rr6RxUgJA6aFZ/0aQEPVexbjMhR464R2gP4MA
 Ybprpmc0
 LxZL3289BQCaTHUT/zVFVxhBUpX/7feF3Wk2UMNTjdJxz9TIcHoOhFVTmq5K4w5Q/St1mYRfwDi7xUxT1YehlZ7WVAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 02:10:51PM -0700, Andrew Morton wrote:
> On Thu, 16 Oct 2025 09:00:34 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>
> > On 2025/10/15 23:32, Lorenzo Stoakes wrote:
> > > On Wed, Oct 15, 2025 at 08:35:14PM +0800, Kefeng Wang wrote:
> > >> If the folio(even not CoW folio) is dma pinned, it can't be
> > >> migrated, so always skip pinned folio to avoid a waste of cycles
> > >> when folios migration.
> > >
> > > NIT: 'when folios migration' -> 'when folios are migrated'.
> > >
> > > Maybe worth saying 'due to elevated reference count?'
> > >
> >
> > Hope Andrew could help to update the changelog.
> >
>
> I changed it to this:
>
> : If the folio (even not CoW folio) is dma pinned, it can't be migrated
> : due to the elevated reference count.  So always skip a pinned folio to
> : avoid wasting cycles when folios are migrated.
>

LGTM from my side, thanks! :)

