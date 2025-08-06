Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F67C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:52:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112286B0096; Wed,  6 Aug 2025 12:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2B86B0099; Wed,  6 Aug 2025 12:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EA76B009A; Wed,  6 Aug 2025 12:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5B4F6B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:52:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66A91115A55
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:52:06 +0000 (UTC)
X-FDA: 83746925052.21.42CA3FB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3D148000E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:52:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e896joMf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P5nva53y;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754499123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyQpaitEP7WxxPpmKDHg3tTdBULMc5CPL8rJASago4E=;
	b=xfdWBiKUDEQk6WRchlJnmFg9/HmJTPmBcO9hwG3JEB+LQAgOq3YLyfhKO++MahjcwgDSW4
	R5M9eqLSBXsuTK01R19wK0KrNKTdPZHPnmqsTAGg4JKUhO9v8nCOZVpesOrTJTDcvV1mMN
	k/MuYcDlWQlffZcRUa9/KONjAJUAJRw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754499123; a=rsa-sha256;
	cv=pass;
	b=Gy7R8zqZE1vVsdbFparThzSfBtuvxU5k/DR4dCVaco5jCbpnPPok0TROzxoCypjWVTeR/3
	F37E+UcnHeoh3ns3pQK4tzLT8QHJ8pSwv+gEvFzDHohvHKcvEO3mGnVA/2yg0PkI5oVev/
	HWj3FYK/R1jEgFwQAIH1iXpNuOaVynQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e896joMf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P5nva53y;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 576GRRfS022522;
	Wed, 6 Aug 2025 16:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fyQpaitEP7WxxPpmKD
	Hg3tTdBULMc5CPL8rJASago4E=; b=e896joMfzeC5/oaMatGzLb5a4J1x/VBVIR
	YnxE6tHVdiDHjadd63xv6GzmKEBD38NI06WUYi+9sS6Lg12GAL2LVoOby6dwb7A6
	aINOOQ5ayKx3Ira/IsYQKCkxlie3xu7uu4IXqKPB1pm+gayPbDyjMk3asaSl6Vb/
	mJUJ14n9u7COjTDRFAANqPFeEvIfchl1bR6BjsiWXeNM/GeSssnLzoWj126Lm/or
	hzou40xbUmB8a/FEQ2RkMBCEkSyIl6iNhyENZiJfovnLA/89jxbvBwcLhQc0S3Cf
	pByhpNAyewtGkv+3F37qSmtt7HfbLUVRhKwBgd6z0XAh3UigSmDQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvgt3rr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:51:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 576GXV1V018372;
	Wed, 6 Aug 2025 16:51:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwr9p0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 16:51:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knmfpWqQGqzNcp/f9vsb9e127zaD8sQs8/QKQbTFLFOs1RNUwZTKuB9UW62Q1gyvUmpldxwd4mxBPCKj7oqfhhU9IWUDzxHlw/CGJ55Z955SEYC2lov3mk81v+q/i1qehdfTWr5yIWZCWlSLe0nI3wLXZ3oLGU290s52ZgGQK9krepjgCK+AKdehmgTOogmJGK26R1oVBiTKCevApHevYI0vV3CsJY2KFFq/qt4sBU5/Seq4Toy9hR7TvGqEkjdExHFaszNQ/35G42VIeoLlbXqqFeyDm38VULjkSenyU2NnuX4/AoPPeIb6v1miDFYXh/KJ8OThv5mruVqQOXV4CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fyQpaitEP7WxxPpmKDHg3tTdBULMc5CPL8rJASago4E=;
 b=QE9sG6FxX2mt2FBYOxBUnq3lVATI38BUZd4XGF4AUm+vGO6RTLApNWeYKDw2tJfbKBQBEKmAHuUPVXP29VX0gaCT+UF0DS1M7kEK3PCasN9Mw818JvPFCdoQYjonBvLgFdAZF07jYeBvPKebYsbXX9QKDcKFjIViBtUuKHEgspJHxd9FxGtcEmB2kEQgh8byZH53Pci3oNeQVZNakJfREsRSWVLxj9iJQbFE/voUONAMVrTJfIUyHbRfU0MJYfweBsoJkc20rzjR8kqr0x33uMuciyD2N2p6HuOTrxdiWR1JiDUyOayCXJOrNx0hWpiF6wp7D3lKNlTtw6ql16x78w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fyQpaitEP7WxxPpmKDHg3tTdBULMc5CPL8rJASago4E=;
 b=P5nva53yUvKT3n8lhckQWkWjBJMDzfK7435BqeLkrF81RbPZq4itXFHqiaVFAlMrUv6CUT42RPznQpny0M4SsNKen4KlBCZQo7OYMo9CSdUE+B6jTIa8ZwBrko65xit5z7mSEpU3eZYzMVUv1VR7I1dXwoAD1A/WhpaJJu/wBqk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5850.namprd10.prod.outlook.com (2603:10b6:303:190::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 16:51:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 16:51:50 +0000
Date: Wed, 6 Aug 2025 17:51:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/4] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
Message-ID: <397d61dd-c682-416f-8f12-64f1ff9f84f1@lucifer.local>
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-2-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806022045.342824-2-ziy@nvidia.com>
X-ClientProxiedBy: LO4P265CA0302.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5850:EE_
X-MS-Office365-Filtering-Correlation-Id: 60d1f944-9522-4020-fb6b-08ddd50989c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vq3lcF3IhWlseJByh9bFjRSrckP3ZjaJhOJp6VO2xHT0ExAPclLNPo5ysKAo?=
 =?us-ascii?Q?sbcmzjMjfuAhXwI8c1KwuEMpRL9riq1b6gHlcGcxm0BRxxELXrlK/6SWL8YR?=
 =?us-ascii?Q?t4lKLHCT79RDZC9U+L7pM0SBsAcg62btmgAf0tkfEf4jMeoPlZUO6QCG8TD+?=
 =?us-ascii?Q?/uWDmi7cOBMyF3nxLOZvukbcTWiekusbFcLOJhBNJARPebqJCrU+rAzaPQeF?=
 =?us-ascii?Q?8NCUMGiw0vuXCzPjmCIjqWh6wjk61Vc5af3+52b5Bg4EM9YHeLM1EpS1ZeOY?=
 =?us-ascii?Q?wV6OqMQDnAcBheuzL5aeul05Yt32Kq8WretdWxwf6iOMc7MUc6NKBsMC7NLP?=
 =?us-ascii?Q?7ZoNcvlAOmKdykoaGEbHGSla+2KIsLSbLqguCOWoEopfsim63wpv7aheRhA7?=
 =?us-ascii?Q?Rr4uiLvBBpWCCJlkiDdYZT69W0c2QjMWOP1eFvGTM4NjZIGy5oee4Glzc0nr?=
 =?us-ascii?Q?0/nsecbGa+SAlEcHVSOd+m+6nPlqg/WWXu+HYgbdUnCcEWyNUvZIaE8q1UxX?=
 =?us-ascii?Q?jtCOuXUFxvyBbbncAzsTsCk4Py3vm7Rgs4NLOz+vqfSp0EI/gAdcuTTWb27v?=
 =?us-ascii?Q?/7dgp1yzdIbgUjW8g5aXYO9VB09BMNzDG5BRtzRtQHfoVzPkuPNUG02FpQxq?=
 =?us-ascii?Q?ScUVsPG5KH++uwmzV+EJxrFqdUiLcGY7LaDzjBBfINQP/WK1Rwm6k2W6WOby?=
 =?us-ascii?Q?+E8KMvUKkqbD2goTeDckOYBCzlJ6wYZxzes5S05yWWw6bDsp8uSKWslHN0VJ?=
 =?us-ascii?Q?iYMB/0hTohf3KIfR90jHdnx0Jkp5PdlfSYVlYV7tiqVEZXcrYWogUCHY4fpX?=
 =?us-ascii?Q?fowAH8q41WfMFeYtzJc+UQ4lcWoqdeIzoQhoVlUswO3B87mswRjNewoM/Dcy?=
 =?us-ascii?Q?uNwGGeMvqzSrxG8hee+TXqM58prG+cFxhBA5TMUDeQaHQoZ5Puv5hWZ+9fIB?=
 =?us-ascii?Q?jezc8XZMqCavJm2RLJkJtnTh71N+RBPivl16WCN2q5YMu1iNYwXRG4VSxXnB?=
 =?us-ascii?Q?vBDmI5v2AMzbgiyYY/W1XP7zwDlxURCKv2XxTFzIMNL3uoq4OBESfpnbFvyA?=
 =?us-ascii?Q?rWRX1WHlp4w+/NRM65BlZRz9iByHdqgTlxGZBWUvlFnicrYA07orP4IoF3mP?=
 =?us-ascii?Q?Tg9LzqdjEXkV4X8arVccELYZgabYjumlkHm97qu/+7aMTwQ2m+ntk34VSElt?=
 =?us-ascii?Q?Kru0mKU+min6WC/Pdunt2vXoIuwtbI8JMQcRD2M1UrrBkGfQbxhWtqFJ1+fz?=
 =?us-ascii?Q?jsHu8NT6b8n6LLKZKp7U0HgtCzs4jl8Y/TK/m8J3icEEwnYM6m/MPZGaTwm8?=
 =?us-ascii?Q?ZbsJGPBPIpJDEKZCFNO+07DosMWfcPAZEuZtkkjQNpbgVh9E55lvZRy/alPw?=
 =?us-ascii?Q?GUiU/Lf/PSY0FbsSfj9TjeZ9AfeuC70QCfR6gEvEgftRBlu48wZXCKjgva8y?=
 =?us-ascii?Q?PuaFTWFbqNU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QjoOJandj4YDgRi9uxtx0isdWY+I3xDmeZeRam8yw9fvpP+cU94E7lNkakin?=
 =?us-ascii?Q?4zq3UY+zVO67Fi3yNklZrGIhJjgD4G2S+18k+GDR2qEcm7wHp5qJ3s3QziNj?=
 =?us-ascii?Q?YV09Njc7XUofxF5HXceelFxpAmJkDBwS8Tonu+4X0LeEEcw/w/EQMgpHgzNi?=
 =?us-ascii?Q?N03A5A8fmmnE5HzdpKMnEMI7xk5sJs74pQPkVI+lpz9ND4AnEDPf+C/mWmWh?=
 =?us-ascii?Q?Xi5WDFipbxDFqAgaiQ6n5Dd9BoW/alvQyP00Z/E9Kv+Xp9AH7GtwUOZAbxPG?=
 =?us-ascii?Q?tEMg1ebhduhLvKi3zIRfDAVaJ5Y6OMcOMIm8cJ0Bt/YQCjmAir0Wjjv9f5b5?=
 =?us-ascii?Q?ebuOMGsqfEbJ7loHs4VUZgulq7bDNyohsQnvEcFa0A8Y5EVkzr4KIoUYg6qC?=
 =?us-ascii?Q?iZBg0mlyQGJY8VGcCzPGciTYhbZ0yy9ydJFjYkjecStP2aFB+Ym+JZDHtGeB?=
 =?us-ascii?Q?Z+USsaCm3JmPy4tLWwy5Vx0rYTfRsDjMH/+waMz3br6RUQ/RJubcu/EsXh7Q?=
 =?us-ascii?Q?b3IKq+MrZ9GZBS39hf6UEu0cs751kUmCocttoRbIV4HUgLxHGFgLTXgj3ubW?=
 =?us-ascii?Q?/rkdJdugvpzOG8qB27tbFXD0v+IctkGoXmREPh9Iy+NGQeza+LTj68AjRjxc?=
 =?us-ascii?Q?bJ+/Cp3LVAnlECQjTvF+FWnOCT7LZT/9GFnGQt4ROyM2yePg/++IPovIti8L?=
 =?us-ascii?Q?71FNg8T266MQ+A4ppYavGGTEhVALs3llWI6C3HrxtgWVmrA/0xo5ATYuMO3g?=
 =?us-ascii?Q?HAP6jZNHXey6B6PzWkg2fB/dGSALTR/S66J8+LLYE9nTJDO+tj7ejGlI81/U?=
 =?us-ascii?Q?yUcnxs4rIjOuyS3V6fNtwVhGYNr+81Whkzx5COHNSf4BcOjOVYaOkaXd8v0k?=
 =?us-ascii?Q?EdqJ8tcnltaUg/XH0wDekM3Q5dhAQXgRKMLHpcJx83bTp1llU8DQYDtp9gaj?=
 =?us-ascii?Q?rmvQ4HnJKgZdkZdhkCmnDd9IgipD+malFanxguc8AZBylG4aTwuhAIy8GjYH?=
 =?us-ascii?Q?gG/O0BpEGAjWGhMF5jP5b6b57YESMRtollj+tGoXml2m2UXA7d4VhPwryI6Z?=
 =?us-ascii?Q?b+XyZkVL3lNLfu94qtFwVhR3OKausmDxmWBo+rbHWHsh5PMJ4qxHXNzNJxS/?=
 =?us-ascii?Q?8qK+Djww30HQW9Y60qPbiCKXzQ44wCiCFlrvoyeRybdpIiWDtGlZjcSlMAGL?=
 =?us-ascii?Q?iUJXn6YSZnUE9kdvXGxFwlcMxMqy9lQAbwkpalQ13p9pP/GTpDYBE85ts/AK?=
 =?us-ascii?Q?TFPLIumFqTH3oeLlOCMYfbuIkbrPp++d1olcdJRhiCOTv+SZZm9z4hDFI/9T?=
 =?us-ascii?Q?yTB8pfEi+L2uuoChOT2kRv+I/C1c0qnx5zUs/FXAK99a57xMmNsA1oQcBJte?=
 =?us-ascii?Q?M6g+PPvyM6X+eYd9FoI5QPNZNmCflSeiqtry6RIsIj+AtgRWAAyJCgCVhdij?=
 =?us-ascii?Q?cBqhI0a2CJRnZof/TX++G77sqHDOEMU384tSDB1N0egq20/I+KRIOaX2Rfrj?=
 =?us-ascii?Q?hQm8JlUV0bytzxiAukEt+VDNU8XQUwazy0/4ik5TrGHcOJsPYSAmdZrXgpKV?=
 =?us-ascii?Q?BacVyIZlugO0/l0nsqbGArDo5caTWZIzoY4SSLIwfh0TAc5LIZgot817lu+X?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mb+g2PCYzrnvvV70lKqouwcU9MKPmwoQRQ/ifOhCt7hG+zW9NtQahSgSxkRqyvA0LB2Nk6Ju3fpJDV/ymdyG46biSiRKx4nJBnNrGk4fV3DQAEpuKhfzhVlb9TPmbEz5/XxxWe5ubdIW1n8ncyQVySUTqa6xiP4y3LJhjhKfYkiwU+DPQxO+QEc1FKlrYg/Rw/VJXDdUbS9lRf+uACVVfwS2ACwopBEX+pTdKSseYCZr8rwWPLLpQ5oaYTctyDahOQbrYcnTB9Nacn+Zm/aszCfjkoRP4Pa5puvF9Gfv/7pqeZQScCC4HBPhGzQBzpMquLK0QD1G/UyNaDp03vQoi3IrhLJcUwbCp3Fm2sjCTnkTIEJHzcM2a+rtFdsLs3LI1Rlc40BP/+U7W3IXcQdh9l3xZZCRhEmJni7eFdCxrokeNx/K42rarYgSX2gX/30LAZiaMXxPje5n88jCJQH3Vx6HxlYiAcTaEFlQUp7a8oKNn0wnWpBvaAqHQPfG3E31qn3J/RrzcSv6JmNtki4zvQnRXU+1k+c4fNvnSIAeowgE1ixsfCQU1Ra99wV0FyyMAZ9N+yFGnTXn4X/6me+GZQ6Mffu8Aho+8U+q6bTq180=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d1f944-9522-4020-fb6b-08ddd50989c1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 16:51:49.9743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPtvkjJw2tQjksLlmHILGIEdAqEHG2vMIFNwK0rAMIGX/uzuCyoYlp+M41Ib+2aYoQNDUi1tQzRr3NRbGjL+w5kSieqC+wZf0CBRe4kPLN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5850
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060108
X-Authority-Analysis: v=2.4 cv=WMp/XmsR c=1 sm=1 tr=0 ts=6893882a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8
 a=3OWgru3KW0tK-oYu2rwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: CLfAjigYh4bgRUQNLMefEdWd8JknpZvh
X-Proofpoint-ORIG-GUID: CLfAjigYh4bgRUQNLMefEdWd8JknpZvh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDEwOCBTYWx0ZWRfX5uedWZ2mueqA
 w3hKrmlVyz/hntUiRfdoXukHk3JgLNp2EZLApAGnif9PqevSoZG26AIHz7syP6vNa/657RR0p9D
 Y8ge531IuYCJA2rbfv9O1TZOGKwx6CYkaDcaVkZI43ENKfBZTst/jV5g7oUDVhqGvnRZStcXMSr
 vtmStdYia5IN2dRyqBN5VhbbcKmix228J/PgIpdv3FvkizJZxoEZJRrkzIgnHClSpcajaDVhKGM
 3r3VCc50q6kvlIp3h0pzIe28FTub76mzU8aUgKo7ApwP0SiiU9e0uJJ+zmc8uvqAo1J84Z+GSGq
 kd+ATuOk9MVyrWVHpe4eWGDXaJg1qphrRdNFwhL7BjU5zwAa8Xq3xTZWP95WtzCX/eBP+mrycUM
 g3ykIGL+0XR2ITIVvnwWMAeLFpZMo9l+NkrInXddzn7K2Ij6IGP+fIyQm6wDbZf0Fpxx6ZlN
X-Rspamd-Queue-Id: E3D148000E
X-Stat-Signature: ajs6ibzw81f6n1ne6356hugw856q1otu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754499122-793595
X-HE-Meta: U2FsdGVkX1+gBs12UQ/F5mkWIdU+w1QcJPwgG/i5WKcGO/xBsoFoai97S1cn4DvfNlYl3yfgsRQNEo7vY8nha8+jBgfbKyLIV8VV+Y3x/ZOqS9o+2ImFVtreBYSvJoqMIuWpM43vz2a203I1o6ZAYIoLYqHBh4vMZX1Rt4+uTrG3qHw8iXRTqpDANtT99jyqVdP127ZlK5Ux/p+NB3Zl1GQjYiqmaK4W2EMmP0dqMcEibyBcVv+mRCvxoGgie5D+qSjMB7fbtPpnzYkNCKWmxsY59GNAX3DjuWUGX2Nxyw4Q+3rh/qTQyjKkUC77wIm0etK889t1V0yy7g8peUrc+HznH93Rg9/fdWsNfadHgOta8KyKuc1CG3MlcI1N0bL7gwDIggIin7kO2Km8mDyMThL6X3+CAQ3cKVZEBFcXBscGVZtDWYg8rxVXTpajJJBerFFSjjo1k3NMBsRCfRK/NDhd0tYJWv+HONEphSrFH8zN1CVXTGavCSqSmixRXQnLleAS6I5r7GbojkyXVndJuSrfVBxD+4Escakpn+ocE6stQ1kvwPrqLKr4hUyAryMOm4TGJww2H5v/E4Zs1yFtofDobZkY+oWwy1Kk6thD5ByW+W0yNmNB/WU2/US1Uh+FIvEYWIz5SZe0XoIFMS1G9xMxy4nBY9K96Wl0bMmt5S4lNm6G+MpgJ5abBmIZUdIabGYsJs4VQTH/ot2sQeV9eXRaM+kwD6/iEYDZq/mSQP9DPJx0enTELFtV4w83RcOnPnuSrVo6Hbi8zjyMOLr03Q0rzeWIPhneN3jb571W1qAQHJmHq/cX2S0Rie7+soFDYmJXv0XqzjYUgCu7eBS+CY/nhzRC8CEMDm9e+zBCy37oYnyAUBtSV9c/Ka84vbJ/RSCA0psi+m1slJKYPWXfKUhfFbUE0+tH8QYnKw0ppNb8LfamehJ7pXOropOdpZvsH4V47d/IWwQuK87FtXX
 qCc/EK6e
 iD+VMXKBJHQ+rlPvCUQAeBIvjHEmhN3iJB17xd2bZ3HSot1rk6C+Shr/1FDOrdm41VxwNpNGi2wiLEWyaiHtIzIEnyY/ZDKqMQI3tNanPuSfzb9U3mAqG1J5pgTocA9obGodRcRigRvRtNq92sZpdSyaBzoa901QmBCN72/pyezdujpxJLn9EqiJb4YCfG0YHmeo34DfGZM+MJ3rEYEGoJVdFJTdWqU/b6TBP9or5swvseAFE6oABU1kxWZ4TGm3h3PGFLSLm3sALEeOM2VL/swEfEUASGFqd7FdVpHWGYPexQmjErHXl+EJr7z/dFGK/J3gqgZMyG3r9sm3naY6UcckZ8DDGO0dmexB8Qf10hw5lMo+u1GX3sYbRE3gv/f8+bdmmEtdLPXp9S3qhcQKGgYkuvJtleXHWh3EaiTL+88qQvyqXjOEJwb4LyRb64A8AnwZf369FRydPrOR/plZtL9m9rlv/x0F+A3xnVFnc2ZbYWtREVSnC49wSdYwzMfi4byxHPKxqiB1d52OMT1TGXm31s4Re/+h38nlU7z4/pb3QSIL1f3Lz5ELjglvGxynJniTfosPsU4duNrkHvP7Bli/G/L2I2K0uEpVNLgI2re8e+ghUBsIytM420Nb4IG/LcDE2WEnxh/lOBOR6AIURoXSgzb4uGh8gGo8U+CCyrPsRZdP80sYkWcvHocHiqPAE6ARmVo2lEfSvc+Xg5q9XWrmLpG/6m6hAsw3ParntfujDMq0qCl0GBMxwMgba/K7LID2aM79JBWTcOyiSEkR2Sxgs2QaPF9Gv7aGMPUxLgAXIYahh7DvHAvMNqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 10:20:42PM -0400, Zi Yan wrote:
> They are useful information for debugging split huge page tests.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Seems reasonable, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..8a11c2d402d4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>  		goto out;
>  	}
>
> -	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -		 pid, vaddr_start, vaddr_end);
> +	pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], new_order: %u, in_folio_offset %ld\n",
> +		 pid, vaddr_start, vaddr_end, new_order, in_folio_offset);
>
>  	mmap_read_lock(mm);
>  	/*
> --
> 2.47.2
>

