Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A0CCF64A0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23E56B0011; Wed, 19 Nov 2025 19:38:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4926B0023; Wed, 19 Nov 2025 19:38:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C816B00A2; Wed, 19 Nov 2025 19:38:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3B6E6B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:38:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48150BAD72
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:38:26 +0000 (UTC)
X-FDA: 84129124212.24.103DEF8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id D4F5A160004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:38:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DrgRkSrl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LbLgPLQ7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763599103; a=rsa-sha256;
	cv=pass;
	b=R95tc7ZZSJc3lWY8nLR4E8Pd75QvkwiOegM4tgHGL3NXpeHO70Tfu28p7DGXoXOgA0BtCi
	aP2n/efh8WETBH542l7k2lB3cSUX9yI4zMGUadulk0N0uQGFF9BX7kd66Yxg69eXQNfj9A
	I4MLnNGblkJbtwHHx38qBwMdftcrw8E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DrgRkSrl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LbLgPLQ7;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763599103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbKyGuMeiIOtu3sExZREvPVdlnnNpYmPlNmUOliFoVo=;
	b=KVSDzmxnP6QtrTq5/wGjByGCzWbVZQvN2jTSsebJ767fHSHWBs7yfvNknX6rDb6CuwJglv
	TApp3zcfw1lAroBorSx3DRkWFqCqWTUA50L7ubHTDhqUB1yX260qoHmjCRA9f1zA7+tz64
	IbvD6AxvlUlP9YcycV06SNVmoiZZRd8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLPYAo002444;
	Thu, 20 Nov 2025 00:38:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UbKyGuMeiIOtu3sExZ
	REvPVdlnnNpYmPlNmUOliFoVo=; b=DrgRkSrlzAABLIBHQqg79RrUYCObhcFO4w
	q0IhC8Zb6QZcS3eOejvt/xYxj16ssdFv6FvcUwjX2nNkjQnLLPEelb03div9FC/Q
	+tQBp+lhU6Q8Iwl8KnMRH//ULeUG2aAPIZjcLY09cEZ4I7oRcHPBSDiO1yMup5+L
	DMWEeGq7eumtsa5MP8Xtfp/JGKFGcUa1S2NjgZg5UYz9aAhqfqB3DvdlferbJD6K
	0pd5DSsLPtqEDVM8k1HfTX5znFoTJqTP6nieMzP2ZB2ORKSExgD3qXrLcFuLfZpj
	igfTzWgs783EOuYq3h4UyVR9/DC/+9hsVEWLNaaIcT8yxY36qQ4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej96863g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 00:38:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJMOmlL009587;
	Thu, 20 Nov 2025 00:38:14 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyfdjgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 00:38:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kjEGPzNwu8tKmVq4DBi2SxAjoLJ/rTaY5hj6eNggC95SFViP6vXdtO6/RjV4V3GW4qrEAL86XaSQl6W1tqEUY0sx1h+H03RyHWMbHGBVK1O4ObY7L2ZSJGQC+xs7+Gurf/YcGqJ+BEFvjd+J34OfkS/bXy0z7gLpYX9nTcc7E7zRHH96QOWnAMsFq5hiV58pg6SOATFzHTJ3NWz0DLU4Bci3+sFlzwLq81D/tkAc8XiA00OuTmxRKlbldoxjwheBia6HYv97YRckBgpt1WmPVOv9mOzGymJXZCBRddsPOdDmJT/dgou9QLktJGsWHI9Y194vDP0mWTSU0Y0a5H+aNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbKyGuMeiIOtu3sExZREvPVdlnnNpYmPlNmUOliFoVo=;
 b=FzG9qaVu1fobvnGrLxS6RZ5AuHA8enCUJsc79Wmb/c5nScFZkiHRyYcOMmSiDVpmN02PzNa3brPy2F/T60QcTQPowGDazR7hfziG9tUTQNEqWv3MtdXfBqXmOKNBZdEb+aVUvmASnFxYoBlHUcSUs4Jf77ZJDDZKV3lp3Alu1fE9FLQI2CG75dyjEvcEORb+hWkE3f8KVUC2Mv4pEvpLHtfecQkoO3mf528NUx03sZR+posieDzGjQe7ZcYOX2XdKg0/JELmt6212exY3rjuX+3i1THk5vSPepUwhLPxsXO/DBIiS38eety2bWQSDLM6ob0e1F7Dl+X9vo6nIecTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbKyGuMeiIOtu3sExZREvPVdlnnNpYmPlNmUOliFoVo=;
 b=LbLgPLQ7BN4zt8Wfrl0h9wSvRl0n2Tx5rd4AAynKmMQjLDrKnj9Htec3vqPx1EzuSmi7k/Fi66hSxI60H6sS2NkcY0vUy/eu1etgrtsy52xcJsixK5CIijxADw6m1T3hrM5X73Ori960DPS3RZC9ZuKc9yYaHI19vSWbBqWByXk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7371.namprd10.prod.outlook.com (2603:10b6:208:40b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 00:38:10 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 00:38:08 +0000
Date: Thu, 20 Nov 2025 09:38:00 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: stable@vger.kernel.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
        baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
        hughd@google.com, jane.chu@oracle.com, jannh@google.com,
        kas@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, npache@redhat.com, pfalcato@suse.de,
        ryan.roberts@arm.com, vbabka@suse.cz, ziy@nvidia.com
Subject: Re: [PATCH V1 6.1.y 0/2] Fix bad pmd due to race between
 change_prot_numa() and THP migration
Message-ID: <aR5i6PdVskmgK-gL@hyeyoo>
References: <20251111071101.680906-1-harry.yoo@oracle.com>
 <ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac8d7137-3819-4a75-9dd3-fb3d2259ebe4@kernel.org>
X-ClientProxiedBy: SEWP216CA0109.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7371:EE_
X-MS-Office365-Filtering-Correlation-Id: 9219efd0-26a3-43ad-049c-08de27cd138a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K3F8db15Z11514/Y/V0jg3Sn2e/EN1ofsUe4VGIiY5T8fnD6H5kE22t8HyFU?=
 =?us-ascii?Q?D/gcfpltr1xOewPWxqzVISEN71UPdyE3mgABuW/czdY8qkgZQZCZefKcQh10?=
 =?us-ascii?Q?W9Cv5rhrqHSvxbxUCp5Y4CGouvaAJR0nTdVyMmNunb7aVRP+8/9bTL1vhVZg?=
 =?us-ascii?Q?Jg9JYY4qAgrE/jFzUUzIqxQLJcjZQtBR0CiUl+9wB/Lpg3eglIC4B5+IOQwg?=
 =?us-ascii?Q?KcePTIQJATd4V2SHEB8mHuel93GGIqEc+ZrmmkfOPDXtynKUZz8PpUIG9FHd?=
 =?us-ascii?Q?c5Y0tgBx9W0fOxiz7WEcK0KkXogQ4J7PWMbMQluQet7sj5oONCer3eNqp1rG?=
 =?us-ascii?Q?G5PROpZCNjh46ZYkAQooq/7GMiCyiXnAqjtEB3ZoujD7iRGdFvKZPwE5vuMX?=
 =?us-ascii?Q?nXgyA2DlC6KynFLc7cJ0NIfxMbn3Mz/ga0p0dRrfbfomVC/pnAG/KO09tcCz?=
 =?us-ascii?Q?lSLeQeEy8tmJ9VwJzxuk8SY6mg08AVd4dGtz3IduvRAIlf7WcU+zYvqjfFvh?=
 =?us-ascii?Q?7SCvtCV0xaGQ1mEjHlsYI5NAQeMnXeMsrIS4TtlZLxr36gRImcaD/zKwRm2Y?=
 =?us-ascii?Q?1nkjXWHW76UM7X2B3kmLU5eeuO9yNLlUbjf7DZbSLu5wx9+Ps0YspCcqmF0R?=
 =?us-ascii?Q?9zcOdxsg1dtQiaUR7JxRcvdCNKp3dky18BkBDd1SDWTnn5TiHcnc7ZZKidYs?=
 =?us-ascii?Q?gan5JJhoZ9mVwadMGWZ1mOMKGPPl6V/jN9cDghNgdhLbfJq363MZ9yB2yilu?=
 =?us-ascii?Q?4sKq6/VwTZ29FZhLE8BE/weFpCbYz8mbmuCrMaEPK3Gq9yU3Wynw69l02Tmp?=
 =?us-ascii?Q?hH1sjTns/WFth80gXg6YhpgCQna+229lickm4yrtis9Onloqt2BQknLg7Rd1?=
 =?us-ascii?Q?G58GQiQzEvPBY92dH5zI7SHqAEiO9rvayZTi//O691fE3RaigIS6TJulvawH?=
 =?us-ascii?Q?y+Gag6R2irzYSHf5FkIAHp2A+geQ99UJsBfYbQUJ/k8DPIcsAp0FHPRuB5SS?=
 =?us-ascii?Q?0KGoFmLRQBfTzfwW6W7TB3olAmJQytA/MJrxIRhtccyCJqahZKUt0J5hOPf/?=
 =?us-ascii?Q?W0WxIg/09UFI8fFItf8qSMAcDx273zWSHv4akdcfc5QDXxpxfdnK28ItGP/u?=
 =?us-ascii?Q?WYc2eMw3KYkMdTydvitQQsur9t1dxu/pq/S6rmGm+ZctXgskjYKbT6T8dJR6?=
 =?us-ascii?Q?1Za1F+S++4o9sbpHpvJ3MaQD+8FRgBB+9NCRKNXgC2FEkJWBv5AeYigUNCb0?=
 =?us-ascii?Q?djmbnAvtDHPt0nESK3WYQ62QhE2rHGJVHZSKCz5z0rwOxhbHdqn/RH/2aJb9?=
 =?us-ascii?Q?LDtzkC2fAT8f8kX4VKrC5wHIlu7ja5oVA/l6Qcr4spVfx0DyrgA7Oo0P2GLb?=
 =?us-ascii?Q?Ow/K2lAAw91o/lceEpYMdZiPoTtBDV2nXx5GI6wAYXIoZTGoq1CDEZhpPHre?=
 =?us-ascii?Q?Z9A6pxpSUOn9hXHyhsUvKUmKe9XUUQlD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5qmhKJP9cKGzOZN0loZhyDQruuLAJEmeVMVqSevWPXDndMWFhJ7J+sUtmpxG?=
 =?us-ascii?Q?BUdz2gzU+ELYd19Mj+XDiyni7LaQL/bEYZk5M+60tt6U5uY0DbWNb/OUoID0?=
 =?us-ascii?Q?4Aj2dAR9XpaiT2p4MwyoW2P9UeJkKviCGStVkFMPnJCFwGhxocqM2VSyNxmy?=
 =?us-ascii?Q?4twmJt2ldfGNDldTbYcqsDkJlhne5flyenJqi2h4EQ89FSLXqxJVrVtoyar5?=
 =?us-ascii?Q?pMwh+BRAT8mhBM+ywCITde/kiSa3XrLfKo0pRzrpx3FyeM5veFQbDxJ7INLt?=
 =?us-ascii?Q?7nNASF/5x0OvVY/oH8TlPPEvVQP0D6O6px5OzcYeinpG5W/ozLqHsiyjycF0?=
 =?us-ascii?Q?VJIQjEnWJBf7JQlqzHHNfdlzVfla9ZjqiN0zVHjQchRtG8NkHRHXtXXPIy3F?=
 =?us-ascii?Q?uJ+d7Khdb7wefbz34qRGDtRdasPP1Wujz0arc7+Te+gYE41XMJa2u3H8V9iN?=
 =?us-ascii?Q?mVFgUQil0UAcoHl7QQjb8IQHPdO0p+0BZTIII6TrGYnJHmQMyYolpCET5YY0?=
 =?us-ascii?Q?PPGIFGF7pdqyhMFeRV5doIbvCcXztp9cJUGuuZFNTIbE9dZrUJl2JIwy6Zx7?=
 =?us-ascii?Q?I5ifgFZ+E4/m6k/pYfGxVwVpEBFKgKz65kGulv+hmqnRRN7XrV+k7eACXkp8?=
 =?us-ascii?Q?Pz/hdynIfqpa5rBQQebQdvTsed+ts0Vbxe0vEgfI2QjYT4j0eIHiRR4H/6pL?=
 =?us-ascii?Q?fFq/IZw5v34IIH/NVTQA9wkAaHMMUOap3Uhc57qJegnnAIXW+JarqD2Z1003?=
 =?us-ascii?Q?Ylb0REpMyC1qbNHPLDJ9wifxQ6rs4+XWyfFDM++BDjVdDJL2kBNWDHv6Zh3d?=
 =?us-ascii?Q?q3XlqJMFFZe1SZU2d2sy+42oG5JxWxWhSQzhKUvhokk7fwMaHmNYyBnZO/Kd?=
 =?us-ascii?Q?xZxMDqa0VLUNVXa3Oad+3aXCvdz0wBQA3Gu3B2+paFB/Q8uOnjl4mbO7tbvr?=
 =?us-ascii?Q?78GsiehJiHhsrNf17FaD8IdySgnCPtq6omhbisqldsIf0bIU2OYMNU4VZ3BZ?=
 =?us-ascii?Q?jMzw8hLnoW5ttDkYVJT03nv7tr2lr5SS0QBZf0sL4HOIHiiIQhxQ1tu4WxZ7?=
 =?us-ascii?Q?YejQTn1kMK2H1jy1ou6LbgKrsP43t0xIPZPXbkYE2ZZuKP3mz6r/TLI3I0iy?=
 =?us-ascii?Q?jzN7ujLclNCm9+ZxkvV4iDoJ1eihuUKdPLzT/QOdJSaEvLEd6B2F7IKGJ8gE?=
 =?us-ascii?Q?e2ca0uRFaCM/p/dNxictkgFGBvmqWzPFVTJTRpVC+V5+t19TJo+9mfKAuPcc?=
 =?us-ascii?Q?5n9hgCMbSdoJFC6wTExbEDb3QGoXAjnjbbV3svPrpFwMnV+NdCZkxJDUfkI4?=
 =?us-ascii?Q?V7jjdbLNzDVKgCsr304meMGvSHUd4XVlJMerV4e1tuR59ZH+0osnDat8/NCE?=
 =?us-ascii?Q?CEZzMRrRx9DuRE3mmCRrJ4Sl0PlgSmjshYnNPbXIJllXkyMkEa8zivsRhNM6?=
 =?us-ascii?Q?4Wk6UQEmFaDMYQ3Br6WNgUFJEKTow24OwdCJYQA8pGyKgEKS0PEAk6SEB2/v?=
 =?us-ascii?Q?RHo/yjH/39Z8AVSrPjEjuzTYf6yz50Ns83To6hmmNbHQvR9JSgOOu8Wwpzbv?=
 =?us-ascii?Q?De6muCTTmyxptdAw56j+iKFQh0B+74nFattpCrPR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CmA2TjkAPg2tWCf7zio5Yplr3Ec9sabSVtxczjpLCgLul1B5Qyu985d1yVsIk2RB0orbnZxd77xLMu0ZRh1GgDsnWJucSKE1jhsScncxuZEivYjryWlNATQqOyOpCdG0ecYbAaawabc8TSzOKS7+hwZNqvzfbNoJGjSh9CuAPBmidd998/t3d1dyLMBUbgQJVxcBE5na6gMjSBMvv8tV/542mQi1WkI3oPbvG1d0KkiDFgU41tr662RPYtwkQOS02Lvb+fk+Nmb464nxV7AwGbYqj/ewnwcRouo19SyfXl1FLnZrRkx5RtTQHZK7FIYNIZTGyByhltW5Eaowbc0k49SFq3En7G/wsrrtZ7L/l8wE8OP6R152edDhYE3dQDTpXi8cStG9fm1HOoGu40O0T396uycToERCwYniqiKd5Kxm5wc1iYf8pVsBbCon5rnzrT5E4wFcDYrURcU6mDqDMDrtN4mu6WboDfmkKSJrUY31xCWjOfkMWLRmKeV1oB/Hs/BL+w2ULFKxqpTHnG+cpNTONT6KjN6g3IdQ3hrmkLB9ulIJ8yPSJLI4qpTnwbqggBRWFSUq8YVEGDOXOwAdjQjuC86eRR2ANG3N5U5IlDE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9219efd0-26a3-43ad-049c-08de27cd138a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 00:38:08.6616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuwZqQiQ68sayJjukBqttvj4vghSmn36k344H2288fOwt9I1ZDhv7Wr5L/zDWZ6SJco/t2nIFnAQnohSaw7K8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_07,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200002
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e62f7 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=-gQ8rbEe_-M2IbPWjmgA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13642
X-Proofpoint-GUID: 5XRcDQ2XwFIfvRYpew20b4mXc-p6NDLN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX7bslGHk00/PC
 8wy5eyWI0EFzP8pr8iGOwItxbVqWILROMB6+nXjMnAUAWHWUNPxLbvEdNBAfFXFcCKrY58s0GoR
 lepxGvUFoa3sRvQpUj+/vPQJBnmJRqj1RKDu/oyhoqx3m3xN6dAl5ZSqN0Zs7zM1BN1mavGTpGp
 yBx30Q/DQ8JZbEsuRcT8gBhVwrlovSfArmzPvbaNFtkTJwlCENww4b0lHVU1TSPw5YveEjsPiez
 MQW7XZsVZekKOTfW2McChmvg2jUoLU+qvnTaKwY6JDOdIyaiUEFDJVIQlBR1hkKuKNB8NmozPgT
 1aIx6XBitvFjjcWanwVFP3eg7uNFp180/pxM/xvEpIK5UmQjR07tCgCsxd6Av5ioqr6AgKmVhIC
 uUFfvcC5PSfHgyQwO3ZRudSZMnBoabpnjdMlawzIVL3yRC6MvOQ=
X-Proofpoint-ORIG-GUID: 5XRcDQ2XwFIfvRYpew20b4mXc-p6NDLN
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4F5A160004
X-Stat-Signature: 3yzetaamqk1meyfzpyihnoeua3w34a6b
X-HE-Tag: 1763599102-156183
X-HE-Meta: U2FsdGVkX18q2GnYeAVCye3QJSPmmbxHxSTnrqx9K7zSYeULKsCMiWQZDFfKf/kLxWdeplKOY4NBO0O/Vs/qYFRGYmdhvc9eb4SPnObnkh6mxXdDbghDNkA7b167fcUNqinhRtP0EsLgTDMfSXfBttdxQ24+koX6q79NZpn11ZUFgFcOJxPKxWetmw2JywfsIMoSX6a7dz+5tpnd1gyY22LWTF3/njS/PG8l2LNEDMrvvk37lHEcZpKGD+SPTKPVv34W2cn1w/hgLb7LThLSwmp4UTVlNF6wNcYmS4NRcPilWd3YfGN6r/CSgpjsPiS1rpLBr+4zNPxdvdikRwp7f17NJ57egKEb3qI6vXyvMsKBlydPgW9+SBVWXA70Ap6aAiz4ySWFvD+Q7Y2/aKIZKuL3Cjof2rAAy09cQVKm9FAE18PvSoXk13yJSwIRJgmI8SkwCNVKrqwWHdBl7OeVqXqgD/Y8GWkYNjEg4yPEbBxGpc7ADmoHur4x1ISu5shWKkK/oXIYuihvoVWWbMa6ClMQN0ObbEHcpFnkC8hL6he2K7otcuTeQzss+Swz3jvAHUk/15wZw7k2MqbbS8r2qxPx5oNfN0czg0Bih6s5yeaz+9cY9irzLSVyGef6KDaS7mZZ/OfP17fIBngBxln7yx+4MFuhmyxRNmgvDspuyZnutwwTdC1EK9eZlNf7H/F2aQbQiKvbkltvYxDlOhUqXmN6QvbWsbA4dKTZIAm5iopSVoJ10FE6Znpxj1H9lE1rTpDFQ/cF+abiCl3ij4R2wEYP6OJ9gOy6PD1wVDtBA8K52L3Oj/tCNH6D2k/YbmnL/DTUj+4RkCkNsOt88WfldU22v5J1mIKsxKYvH0f8ZQutTd98zO5KbcHACbX6FAgV/lOA5uKX8wcOXkUFPWQ8OjwOu4PegRKd5Ox2bv+XH1cvrlphl+JxFenWo9VAH+g/yn+ao58jyZyqYuYjJlj
 emCDk8/H
 +Fs28M1bThaV7XzfjMTs561zKS0ae1w+f2toGChh3x8/+lKLMhqI930pQeTJPZ7cnt/SXKegDXuWV4Dxy1gQjBM2DbkbUmU7ZfoeJMoLVLvPNOzji3LzJRHZX6FTsmT0xCzySO9o3d0QX508f58oHMdcRS75gzrfcUiqI45ylsOSI0fkHDE5wo1UqK3j8cqRh5tFkhmGKTIfvyEosRulJHnPZaRCfPqZJABPEuj1rEohwa04qRzvkQGa5S9dbxjsOY9jAPcnBd2MdEYInlt6/HSdlie4trdOGOplaNyqrgse5kud9BmzasCuFlsMUSKP6/++q71QyQssXyFt7Dt9rH2LBI8AjAZkOdBHsSExWqcoliNWdvKCaLxkygWJrToUdhLYKt0WuGIZCkklYO8qjbooY4dGtYyFc8WnETGCoVWJ5Z3/ZhZMl6GX6Wb7cMgbQXaTTbjioQUGhtkE7qOxj7zSKEFbXFb1zVdt4aSqRMDHq4+1XIkJA0dc3f20qg3l9H+yzIzsqYBokhz7PXW/fUAFFTVa3hrJ7kbUhs3fFZk8YsQnvIwG3TQrJ/ccvzihz9Py2wGCb+jvdEDbijlZATqjRLKgvS7waTdpcIX77d+j+jVUIZDPtjoJ+eRrTfC8potq2iZ1a/p0nsGzPhvz1pYSpVt0dbcUFDvkPGx9gumvEsg67gP7YthFUonPZCorjp9RWg4ADSiRec3Z+wLFgCvC9Xn37Odh6KfroGnQHWX9ie/YKRex9TXtrmfx5W63Z1QTt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 12:06:57PM +0100, David Hildenbrand (Red Hat) wrote:
> On 11.11.25 08:10, Harry Yoo wrote:
> > # TL;DR
> > 
> > previous discussion: https://lore.kernel.org/linux-mm/b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com/
> > 
> > A "bad pmd" error occurs due to race condition between
> > change_prot_numa() and THP migration. The mainline kernel does not have
> > this bug as commit 670ddd8cdc fixes the race condition. 6.1.y, 5.15.y,
> > 5.10.y, 5.4.y are affected by this bug.
> > 
> > Fixing this in -stable kernels is tricky because pte_map_offset_lock()
> > has different semantics in pre-6.5 and post-6.5 kernels. I am trying to
> > backport the same mechanism we have in the mainline kernel.
> > Since the code looks bit different due to different semantics of
> > pte_map_offset_lock(), it'd be best to get this reviewed by MM folks.
> > 
> > # Testing
> > 
> > I verified that the bug described below is not reproduced anymore
> > (on a downstream kernel) after applying this patch series. It used to
> > trigger in few days of intensive numa balancing testing, but it survived
> > 2 weeks with this applied.
> > 
> > # Bug Description
> > 
> > It was reported that a bad pmd is seen when automatic NUMA
> > balancing is marking page table entries as prot_numa:
> >    [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
> >    [2437548.235022] Call Trace:
> >    [2437548.238234]  <TASK>
> >    [2437548.241060]  dump_stack_lvl+0x46/0x61
> >    [2437548.245689]  panic+0x106/0x2e5
> >    [2437548.249497]  pmd_clear_bad+0x3c/0x3c
> >    [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
> >    [2437548.259537]  change_p4d_range+0x156/0x20e
> >    [2437548.264392]  change_protection_range+0x116/0x1a9
> >    [2437548.269976]  change_prot_numa+0x15/0x37
> >    [2437548.274774]  task_numa_work+0x1b8/0x302
> >    [2437548.279512]  task_work_run+0x62/0x95
> >    [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
> >    [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
> >    [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
> >    [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
> >    [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b
> > 
> > This is due to a race condition between change_prot_numa() and
> > THP migration because the kernel doesn't check is_swap_pmd() and
> > pmd_trans_huge() atomically:
> > 
> > change_prot_numa()                      THP migration
> > ======================================================================
> > - change_pmd_range()
> > -> is_swap_pmd() returns false,
> > meaning it's not a PMD migration
> > entry.
> > 				  - do_huge_pmd_numa_page()
> > 				  -> migrate_misplaced_page() sets
> > 				     migration entries for the THP.
> > - change_pmd_range()
> > -> pmd_none_or_clear_bad_unless_trans_huge()
> > -> pmd_none() and pmd_trans_huge() returns false
> > - pmd_none_or_clear_bad_unless_trans_huge()
> > -> pmd_bad() returns true for the migration entry!
> > 
> > The upstream commit 670ddd8cdcbd ("mm/mprotect: delete
> > pmd_none_or_clear_bad_unless_trans_huge()") closes this race condition
> > by checking is_swap_pmd() and pmd_trans_huge() atomically.
> > 
> > # Backporting note
> > 
> > commit a79390f5d6a7 ("mm/mprotect: use long for page accountings and retval")
> > is backported to return an error code (negative value) in
> > change_pte_range().
> > 
> > Unlike the mainline, pte_offset_map_lock() does not check if the pmd
> > entry is a migration entry or a hugepage; acquires PTL unconditionally
> > instead of returning failure. Therefore, it is necessary to keep the
> > !is_swap_pmd() && !pmd_trans_huge() && !pmd_devmap() checks in
> > change_pmd_range() before acquiring the PTL.
> > 
> > After acquiring the lock, open-code the semantics of
> > pte_offset_map_lock() in the mainline kernel; change_pte_range() fails
> > if the pmd value has changed. This requires adding pmd_old parameter
> > (pmd_t value that is read before calling the function) to
> > change_pte_range().
> 
> Looks reasonable to me, so I assume the backporting diff makes sense.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

Hi David, just wanted to say that I really appreciate your
acknowledgement. Thanks!

While this bug doesn't appear to cause severe damage on the system
(only a "bad pmd" error printed to console due to race), that wasn't
really clear before closer investigation and I think it is worth
backporting to save others' time.

I'll send v5.15, v5.10, v5.4 fix soon that does the same thing.

-- 
Cheers,
Harry / Hyeonggon

