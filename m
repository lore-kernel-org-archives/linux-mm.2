Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6786DCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C14A28E005D; Fri, 17 Oct 2025 05:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4A98E0016; Fri, 17 Oct 2025 05:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65BF8E005D; Fri, 17 Oct 2025 05:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 891748E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:07:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 25C8186885
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:51 +0000 (UTC)
X-FDA: 84007028742.22.4904813
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9EFED4000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:07:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l92K/x3V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GRaoTxw5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1QKXq269HM9J02YOFybYrBNHdfI47IY9tm5VjyxMn5E=;
	b=zkwCPN7WXh3n2mI8xj4L7GA9cL9W4/YmCmbral/Y1r9jA2vT3k+2bg1SEx3BjxXydwuMpN
	RFsUYnMv/IMV843b2UYK004IkUP1KR8lXgsmD6icO3Xfd7GW7lUmE/l3/94wu5858o79eg
	Hnfxd0qNvLAQ1K3sPzP/5RFNNfCkOHc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="l92K/x3V";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GRaoTxw5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760692067; a=rsa-sha256;
	cv=pass;
	b=EIMcKw2N7SbaN2Jk83iuS7bzFKRbqFiU3dbln29BefGCEzC9GYyMl/KbMVuvSjM6qhhirD
	7XNHgsrfXafXu/SHzc0ozPv1lg8OGbHiYV25/eSGEen0rJ2UjYDM1cIhaT6wS8akzE/Gqo
	13X/kpd0uWc4HW5eQ+p+Pr5w9CZs/GM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H7uA3k020487;
	Fri, 17 Oct 2025 09:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1QKXq269HM9J02YOFy
	bYrBNHdfI47IY9tm5VjyxMn5E=; b=l92K/x3VmfVTu1RtzJwhBG/hTSwv2jK0mz
	NHVBCDpcztvZ7SVt8XuZGC4fkrl+OOYtoZbxeQNSk2d/hi2iBuyCqXL5M5X4eXuy
	NS9bHlfSHyCIKbRBMLSJ6xavRIYkhKsIxnzCB9TzoOb2i2hKAbhV4bDjCRg8Whs5
	MSE8YzVxh3V5nkU85jn4E2KkJ62xJY4F0rHNTk47sqAch+pK84Bb8Xpw/VgbEl5B
	MoWlnFwDtsIa2E795pAEFann+KyPw5zHH9BLRdvOOzktrje51Ak38A85TcI/cPsf
	ePj84uie5Gud876T3/NZr6VWUh/c/iUKH2NyFxeSctpDkflUuYdA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qfss2hpd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:06:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59H6WUFo025776;
	Fri, 17 Oct 2025 09:06:49 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpju8jm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 09:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BIvowuU5spyLtuls9nO87dl750CY8UFLY3es1CcP5xpa3LKUC3rLSkdTLhBp/w+k0I9D6N6vKjOjnoj+5i/ZMZqJMymXnt4qfHugj2vYEoVjWtB3k6gKxuNwOFsZjyTheT71Jeov+Ah7l6ElchrcpvOolVPOQxlk4cnTLl6F7fESgYBNn60+loN8W5Dw2/mv4D97Og5Oht9Pjw0bK1hrktStHhDh6TnKjPEskN8eHcY8FhFRyNE+uKIbORnyCqmhcE2/l1jWPPiYlrA3PwJg2ZJ/GuLAXd7KLgiMP5/UYiGrYNst1Kf0KKdoeoytV0kcRn3WNCLYHV4tSe4O+/ILug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QKXq269HM9J02YOFybYrBNHdfI47IY9tm5VjyxMn5E=;
 b=fmKAEm2agKp2tikyLTwcN2bBP0VP6nirnkA9n9s6fal3pNz0hM2gfAWr4EPf7NYeogXsaXZO7GYp7RWRlyGgc1IOvyaH8CkqZ7HAhMfE0u0uibAwoBx2XfaEa2SNLwQ2q8C/WBK4FyDe+BEvbfEm3ffB1aqAwAVcxkXEnmtjHP161oX0Ys2oRaeLo5fWMNERasE+3WvILamDfPPOmHtZ4RlJQJtIKbtM5QojFL8hW5PSzlhUwGr1NXrTwTnZT2W7LHrkbbNTqHSVAC1ufesnM6ps7CyG8dgfgQPf/pTO/rnW+cM4mLYr1Aqw2BfAEDYlVIzsKLcg5N48qGEIWM702Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QKXq269HM9J02YOFybYrBNHdfI47IY9tm5VjyxMn5E=;
 b=GRaoTxw5NXRL/9NhzB7aYTzvaC10niLp4nYbtjcjkSBD7NoiZFto3SfiKyIcci8/CxAreNc6Nh7i+6SsKtKXZ0j1D8mJwvXNjZNVDhAP3cywwmNQpszR1Y8WC5x6uLrHHUsh8SjnVgy1XoDpPg06a9pkswy5P/QFlXL/yru2ET8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7351.namprd10.prod.outlook.com (2603:10b6:208:3dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Fri, 17 Oct
 2025 09:06:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:06:45 +0000
Date: Fri, 17 Oct 2025 10:06:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Wei Yang <richard.weiyang@gmail.com>, linmiaohe@huawei.com,
        david@redhat.com, jane.chu@oracle.com, kernel@pankajraghav.com,
        syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, mcgrof@kernel.org,
        nao.horiguchi@gmail.com, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <16b10383-1d3a-428c-918a-3bbf1f9f495d@lucifer.local>
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-2-ziy@nvidia.com>
 <20251016073154.6vfydmo6lnvgyuzz@master>
 <49BBF89F-C185-4991-B0BB-7CE7AC8130EA@nvidia.com>
 <20251016135924.6390f12b04ead41d977102ec@linux-foundation.org>
 <E88B5579-DE01-4F33-B666-CC29F32EEF70@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E88B5579-DE01-4F33-B666-CC29F32EEF70@nvidia.com>
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: c5111b6e-d96c-482f-4c2d-08de0d5c7ece
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gnwYy2SHA/ZAd3wcu+qkmBymq6ns+tU9lB9Sv/4tj4FvaxcDffRH5+3R8+cv?=
 =?us-ascii?Q?Xl4cDP3ntxTy6aT9/napaIDy8rjIPyNjsas3Dz7nUOwP9qs8YEq3u8ZOBDvX?=
 =?us-ascii?Q?KnLZDr1r385Sw7slnIdpFYkbVHitPmg2E+bEZaEhxqZ8qTmdpWxecIirrvpc?=
 =?us-ascii?Q?U9Eqhs3tRVJMX3FU+CK9+knzKDTMfMps0Qopq81tgLCc3z9oO8yRM0eTmRYx?=
 =?us-ascii?Q?K7VcS0+fX+eRceGXqtnxKtppfNHAT9sGS7iQrIzwoe80jC1yCfDF6nf7ITQH?=
 =?us-ascii?Q?A0+YPMBBpB95bXSfIUjMoMJKKnRetVYmJLKAQB2XftmF0SDlKLuK/kJLVZdM?=
 =?us-ascii?Q?SjgIY5hdgzRK1cQ3KA2HUCnvuVLzDRolRXsFowj2gzIkXjinvXF/+OyScy75?=
 =?us-ascii?Q?1DmumWwjspbTvBzTzgCJHYKBR993+ztSKhwINuasLF2GiBQKB3Ls8iY/XmIw?=
 =?us-ascii?Q?hJ6MC0UBhx5bInWHem1GWA0ygOvoDijiI8tdHW4arvvPNhVPL6JzC81UIiEb?=
 =?us-ascii?Q?JIQGJlgvviF3S5gtOwef38boX1+1MHILjJ0bMrUuvHcjz4F7+H9KvexUKQHK?=
 =?us-ascii?Q?+WcQBToCwmZdWU9vXoUzN4xecOtm7OnEj5aTzbrH9Ox2l8ZmDtczibksulvd?=
 =?us-ascii?Q?ymo9IgmPKLiLw2IKaqO7PpE5FQkg3XvIJO9JQWmzN4AsH5Fi8k16kHkrFK7x?=
 =?us-ascii?Q?l2k7DH+ppqDymf1S3R+9nYQPhrCReS0KSg01tgt2inJJE96D7gVwpm+b5Pew?=
 =?us-ascii?Q?bw5jaoshql1lN99mliNPTqWETyYjgWg66qRHr2n8Yh1IuuHzcJlcbMrz6qNR?=
 =?us-ascii?Q?Wk6+J3Qn1sNYxdJGXTJ7DLeinVTIkjwc/F4/1O4DVyyvWh7RMeB++T+tukm5?=
 =?us-ascii?Q?1bwo0LpOvEnh22RxscuoIgdgwj5e0JSgaFmkLdVs8swOUbXJt01Vf24Bl4vO?=
 =?us-ascii?Q?Wil7NBnC9b2xXk75O7Ombcgyj5reO4z/td/iTmYIZnUWQPtH2KvB3SrM+FEL?=
 =?us-ascii?Q?msS6azC8M9hNFKqkcAf1o24dTmfbKzCFe3vrFa3zwGbyqY/Cl0Y9XNpOxFXK?=
 =?us-ascii?Q?Cq5dgTP4VduOJTA3cZqE8kKgDvzZGStx7+r7/MZswKb0Rvd9VjNn67WkeLp+?=
 =?us-ascii?Q?5fG+KN2049I5iuHRCxY53oC2EgC2bXFyYDKIv3qZkx/eyW2zgAuppdfWe/S+?=
 =?us-ascii?Q?oYLLEQTC/4Q7G0hZ9kLJrdpmOGPtlnD1CVf1/HLGHsDuSNZwxENt6F42FuBa?=
 =?us-ascii?Q?lxCwGE9KdpTw5z+pKfF6/0BS0dx8aGCpzWbColDgLjqoFJm08E06/81x8XU6?=
 =?us-ascii?Q?1NjHiRshxZRwNF4RctOWoVzFKNaT6cxA9JAtMENgxKnoITp3xXPq+RoT5I0y?=
 =?us-ascii?Q?9mbnWmpOR8H7mt/3ptVwf2jTcb5k9ovz1kHEAs+1O6VhWw/7QSED/pjVU9La?=
 =?us-ascii?Q?UPS6UngX9e7bpCWGheDCVVT7pth15nnj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vdzYaOoIe1VYbFgzPJzqk3fmw41M04znf21+XQZwgmhF3/HkkW7lH/PfhW8D?=
 =?us-ascii?Q?7lTIB3MpgWHNAtttxXJCYFDBHJYyY+RKo64XvRV9Mva7CV5Jg0uHZVnCOZVO?=
 =?us-ascii?Q?thihOiHYCRyTvAiDLpkURcJcULkc8U1vDnAzq0DIalK4bJW+SbZhCp+XWyie?=
 =?us-ascii?Q?Ys2Su0Oa03A3mJAhx3CDkN81yEcpnwzuTfTFthXHm4hjhZsO4PsWQbHh84gW?=
 =?us-ascii?Q?whK0bJiHT/HXMZ7+Z5vJ5FaAVkBYdIHorH49c1rGqdk1mjJqTHamVKhGOw28?=
 =?us-ascii?Q?b2qQAW0sFRrwWYvaBm9nkaf3b+hI5iUZckIIQNiGMheEhfJ8W78ZRhKic7gt?=
 =?us-ascii?Q?ygF3n0jPAW0SLNF5x+3V0axbMVOaWF0+TOz6vTVNGuvlQDV/dJqKE9tcUw7u?=
 =?us-ascii?Q?KbrSM3HBKnqfZ2L5Olr79pvn3ovy9fVClLbAnNbt2c4m8jueemulDnvjEDV5?=
 =?us-ascii?Q?D+U2rT9UW17tUeQJJYKgVMbS5PyZ2eOHihWCEjKbd4sfcOfMhcqhNDETOtdh?=
 =?us-ascii?Q?Pn6xjz6+l5vp5fOSCcgula0/Y3vpCPhANPlZNzsD9JCEu2vPXXpnD1tga15+?=
 =?us-ascii?Q?02Lt/9fyS3SDSg5zEJuHINvB8Dgg3FofM0TIuBr3UPywzGh4/qdQXwvANbKg?=
 =?us-ascii?Q?SnQXoB2u6tvx7OjGyAUa0lHsbtjxwCFPttV5DRELWl3VsJhMsa06rEBrmIZK?=
 =?us-ascii?Q?NfB5ETOle+hyZNN1uW6bivZh8obS/eCu4MiVVfyusKs4+EIqtVafAwSnDeSm?=
 =?us-ascii?Q?AiPPWBGFrh8utvBHEgOHNrGBevQLWTiIwQWYCIosoEpm5BjfYQgmMhIVW235?=
 =?us-ascii?Q?qJj7jWFfIPOuQtPZI3HUwhDM68xEfywiB6fJX9nmREPKnVHgcixQ01QpAZCv?=
 =?us-ascii?Q?PL5Jk3wMCxLabML/y6i/wED5ojcOVDcGoGyWaM+dHZt/s3XoXS3rMCkFKUJG?=
 =?us-ascii?Q?uS4xh6tQ4Ck/Ueykjg2V3fVs15hysYk2Bbrxrr9VZtZkVdTsn+qncSS8fzdL?=
 =?us-ascii?Q?1mvWr4dirCRs3FAG+H2UbyuRQY+9Y7YNpkpXlcqtomuIuk9DnTIakPc7C719?=
 =?us-ascii?Q?CG5kPO2d7r5tq4Os37R/xUAguV4azG2m94H3ztq1DlA2mIo94q0z/59kaWC/?=
 =?us-ascii?Q?xN1hw8fb8JShCaG4rRTyCFJbzf0T6y6OUbOCstBCiggcbOoWcFeiHboP8Fju?=
 =?us-ascii?Q?NuwkAGJuwx6yLGExbkCc1HiWoYx5oOY8rM1pu5qSP9IbOEDnBJn8ovV7w5xA?=
 =?us-ascii?Q?+/7cybKNV8CsbqG2oeBChrOGwkWZ385sRPBehEAC3e7LfWWL7MqamkU/VUEn?=
 =?us-ascii?Q?4FSrclZAuqFEO+MAXxd7xrS7rSqkTiCP8GwPYIFY4ZEYEYpixeRa7RpH8Y3V?=
 =?us-ascii?Q?h1LUKv8/n/tSokyCrIBG409L2iI2c6PGX1wdN3Q+R89EgqkDJYaYPh+kIDac?=
 =?us-ascii?Q?k8PQ4JunNmvY6EmGHLGuYV34+Pc+gGn1pJWkR4NsifLOgOHZ7wt2xSboIn76?=
 =?us-ascii?Q?R91NnjRRC2NJ6P0u9ZlLo4UjN83k1XevfNY+hOZ9lt6bnP1tIuqrCYCjqmX/?=
 =?us-ascii?Q?+F1g31lYBc5N60gR1vS9o0FE8caoBm7FnBp/dxzL2mfbpkij507PN2GWHL4k?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UCI/Wxqd4opED3imINafYDN1jjstmeC1oHPAyOOfa90g5nQktYSBvOKxi9XH3SvoMuCW/TqvXQX8qWhHz20qO+Jb45varH+7UikEHkvH4w3wqdZtj2WB3WWz4OY72731waplQEGpdoW6f77rC7HhS0xVCgKubdrWj9b/bmA0X/SPqb288irbzaaG+mcunRbaURF5HWvaFVfa2Drn9ohxy92trPawHCFskYL19m+WLekz7mfhSdUh5vgt0nx6PP5tKw3vqoqSJIH8nJSCuoHgze2cbzlaUraQki8ooCYzcg7VxgnlsEE7eeMRuxzm29h+dxUQxo9VpAjOlQYT0ebdPKl72IsxP4Nj9D3BrglR3skcnK2+NzJYiGgbMfy+v0IhbWzXfsdwkWeAZmVnhvyaJkm6IxSLKl7EB1sCX96cA+kvgXYasKATBzhSIsPFYPmWsFffU3q5dl3rBEXOsHYyXCpjcoAqfrqcSFjGY2uB1jp9jk9BQsp4wQ5To3FWSRd6QyXYWjoZNdPrxb4rdCwF4EdOo3UwhPgii+pZehbT+McrDNs3HFZDt6l1dATZpRUQ86Je3EFCVvvwTMtB8vGnh5n98UG9WGwxy111LbFFIdM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5111b6e-d96c-482f-4c2d-08de0d5c7ece
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:06:44.9409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xba1qCyedmBzsg+GL73Y89NIgYq5uHtJ9YWBoSSWORqL9dV20yaHcZ16AJDDV5nW7vksXS4lI9JaSNI3LrsyjhjThOOfylrcEQE6DdvdKGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7351
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170067
X-Proofpoint-GUID: SFXi73FHBG3D4j3mvDiTi2HnT8DFy5GV
X-Authority-Analysis: v=2.4 cv=APfYzRIR c=1 sm=1 tr=0 ts=68f2072b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=uRT6S_nvXbFMe3qWU0gA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAyMSBTYWx0ZWRfX/9z2ofubKE/c
 v6r4tno/6oB5qtlkHcGHuDiJkCFubkZyLs5hBR2bmc68OM/tUXGBzWCwUOUbpEC+9EuYl/yCGkn
 hlbDyhyLzF3asLx+FLUu4PTDvaABUZ+wfZMtZhnrttlbKEng6c6Qh33C77ItSNILjFld9BoxEWR
 8vsOBJX+0WTXnjO85X4QeEuveYXBtVjANzwIFx/DvwvnmAW3xoyY7LSP32vglLK7cdB9HntU69e
 VJuha76TcwesLjmIE/Tgxam4PlQpnEbqSFq8bGUU4LFS7NRLDChdTDtDSpbB47PlD1oYpy/EvKq
 9EyafpmYeVh5u5ZkJ0HZ26z8EtgFfATBL24qTdAiaAdUaTut8K4SFAP3HcPhMSu60D8ANR0P3b5
 nJx4SfElewDCqHpWg+Jp9WXyjvQq77fFGq+w/iEPYToV2jqRyBg=
X-Proofpoint-ORIG-GUID: SFXi73FHBG3D4j3mvDiTi2HnT8DFy5GV
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EFED4000E
X-Rspamd-Server: rspam03
X-Stat-Signature: dgpgdbuou7p9reachi4orh5g4ae7u565
X-HE-Tag: 1760692067-295164
X-HE-Meta: U2FsdGVkX19ByajxeI49dTOMU4sY37bCRUaZCVVmMOjUpRJj2eoB/40u49yxQNvMS4VMFv2KK/uQ7BN106Z641zHI9zB+B19Mku4ZieLqpuwCoh7T2WYpzkysVXi56zxXx0EGaEbGXCIg2/n84ZDaA/0pQAw0O5+deJkbCQN5eVhfKpZPk0aZgg10DCUTDdowboLAo1TTpyisk86uk4b0ZqZKS4f4iSrw1jmWyvJ907cb0FkGPd/AvUep4Fpac/Iq7DY66bMV5/zzk6IJuSPM59eIhhSff19avITNWwcfZ884hO5s2A1/gvBxIzIvYXRTGAGk/wyZZwg+jRl6lbtl0G4gQsQ94MnknvQXTJOipOK3T21ajxHNh8VLOaQsXnZ9kfnrtb8u4AK7+Fv9L6leh8PmfrdcA+X7I+mQ8KsVPgtg9hrByrTWX7ueswm0ksyt5Hdett/46SkWc/KHrIkL21hrYG3gQIHbn9/tvxiqcICvPzctERRwWkiejnnYNgrpn67cVTFncvyDcdDPTry7c/TKkAjuxms9qfaW6KADc38loq0dbzPUEe0Uko1iGivp7RPgmtXcDneZa2B8nzSzEyHKbXGmowm+qbiHVhD1WehFmQ1BRBDuyI+hGbGzYv7/cBHLRzygN4yuxTy7ujVtc9V/AoBVlYkgBunew9J3iDxP0kKHn6MBem94c8IRaHFqB39bqF7NBfmCey5tllnNfk3ZS+MrmnV6vCFD1aeABEhQwxoa7wLsoh4V2buipG81B4Ln+jPR5Z8d2KewvYws+icym/au/ytJxhPhHs2NSPG1fxNp1JdM0maOSHO/GZdoYQClN9WdAafiQALBOX8tTstjE39ytgrHnsZI6tmmJBfriW24oyfNFcF5sD0cz8FTogFLN+kdLRH68tXhhIYJ9IBmGSYeCt5iHfkpn7PaBKXK4IdsLcpm7U2Zr9E+4iiLh79H2XLLJyDXTlQHCw
 Y1qnOhSj
 q4JF7L1M8mm3UzLaxq5q45OliSpum0ywGnEwdq9lf0So6bkFt7nRWxwmCwdy3mrrtopfsFw0YLjgJrgzJA3mGJHK+PP/1aoXOESxktWlpstVOV9dYWws79/pmb66UeNCbetPpGGeKqP1ZfeFB8lq8xL2we9QS1zQcfZOmvfffvMwxNxSyDZiR3LrftzEEllmx25zT6b9ml2xt0+yjopNF6+okdYJBcVUry19rWHcPbtdCZwn1H7UiXnr+FCQR2znHSDLCiFnePBqzhWU5ArN5PVI2HTzci6gR/1kNB0ti6G3Theh+IvdYCAz/z8/RjLIAvxF900HkHbkui7f8qLw32dP3/8sby1DWOlY2jXXkGl4Bo71RYudG873Ou5okVZ3UnZ/5ToRdk4DfhmE2XyFINl1pyn6Ah1drTEKv0b756IHHm9hhFL2BMDbLpNcUgeAC4iyg807v8PgF4HgDcPHJjQCnmDuhXKlM3OL6+TfkZSeickXjLK6RateMx7YZ/2+tkgca0OtFB6hM39KnZpGMCwUgh0fy+nogTaCIz1kbVxNqudnPLpdrRJiDRRPtkwFHHhzr6L0A8xLAf3JD2u3URoeOAc02We0IrW3MJxQQpyuDHvqQubYIwHYuiXvMtNovmobM9Wi7qOpURrEqm1MUm2PwJ2fOzZfHXEoVu8BCMTiLXGrb4x9BWVmwIojRInVzX7wfRQR6dX6KLwbf8lAjVJaQUpweM6czH02aBP+1XXwkjrui4sx45LpKd3it9kBR5TH8QIYpprMUsvz6b7vGNPTzrZqkpkjy2hWjFcKPGA5f1IitStNB6anmJozxyYnm0z4FsaCoiNx2cSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 09:03:27PM -0400, Zi Yan wrote:
> On 16 Oct 2025, at 16:59, Andrew Morton wrote:
>
> > On Thu, 16 Oct 2025 10:32:17 -0400 Zi Yan <ziy@nvidia.com> wrote:
> >
> >>> Do we want to cc stable?
> >>
> >> This only triggers a warning, so I am inclined not to.
> >> But some config decides to crash on kernel warnings. If anyone thinks
> >> it is worth ccing stable, please let me know.
> >
> > Yes please.  Kernel warnings are pretty serious and I do like to fix
> > them in -stable when possible.
> >
> > That means this patch will have a different routing and priority than
> > the other two so please split the warning fix out from the series.
>
> OK. Let me send this one and cc stable.

You've added a bunch of confusion here, now if I review the rest of this series
it looks like I'm reviewing it with this stale patch included.

Can you please resend the remainder of the series as a v3 so it's clear? Thanks!

