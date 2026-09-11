Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFBD3C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D376B008A; Fri, 11 Sep 2026 10:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E036B008C; Fri, 11 Sep 2026 10:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5486B0095; Fri, 11 Sep 2026 10:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3B46B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:34:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B86AA1A0295
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:34:40 +0000 (UTC)
X-FDA: 85201727520.18.CA06A42
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010012.outbound.protection.outlook.com [52.101.193.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id D84252000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:34:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WCPv7Vck;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789137277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cx825lV1m5kDyC9LW1BOghhObtj4WdsGxcZSYm7X3I=;
	b=cuOicapPBhnKcgXCBtzWKcxPbAn9e5UkSDVLjNYLYbU9pxwWqACWmstVDh6452np+d9A02
	9up+4c2ULf6zvBkbk8FGLz95MebI9e0m0GmhXYJYD8YT7nAXg46mU67qbMQGD7a0NHBsCu
	r2eMkDnE1uL4udqNATF21tqajEcejjc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789137278;
	b=m3yU7+LhULmJFUexlnCR2xgF1GMCXDOnDd93ZbmVK+oMneglVQlHq2UwiykBWVJ+oO9wYd
	fUzHOw2uKoqiirg4vMxM8b1hcJU2Pq3DVLRHOe1s2QkyX0boHdkY91GS9N0ucMOpReassO
	Mwggi0Dw/c87xsB4CEZiDYd5oFLD3pA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WCPv7Vck;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bUSh6w+YYZwd8H/EodBdjhz75UStckdwzpm6vpezvbyKrMxRg//hJZQ6vhl7ywnpvd9SDuupezCdMz2BBaVL+OKlLog4ukcmQ6D4mXyqfkjxhW9RdZfwtH4Rs6X7kKUVrT9NWezRfuNDZQ471lwdO7BHF1dar/VQV2D2U/imnoWWfycnDZQFZwI6b0nobg4OdOStWnE7YdTAAm8MUYj0LRNwBuc3ejjmvlfxuQxtV6PPnJKt4ONTRUfputjuWec56JMekNU8gN1HsfAZFgXrGzWdgmrIggBhAIab/m3Dh92F07x3NNvanAoWQv/IZA0u2brL4hs2zgov34M6K3nm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cx825lV1m5kDyC9LW1BOghhObtj4WdsGxcZSYm7X3I=;
 b=qTvWBtMK1j/qgJRvt9y/YfLJJ/9Jk1prL8SFDIvfZyNYtrKZwJC4K+cEOt+4KjCsItxX1Sp0+YhNQw92fOCcsb8Gq6QbxTi9shMHFgPZMYyN4PX4GFZGkZ3pCq1Jcp6r5N3lpZOZoTRDii97WGQnxywqnGGkRwUqDbSsulq1y2i7dLrB/wB5cZdTqdchHdXAD2326hhtsWAG5q4f936gEN2oYrsi2vCGALzKyW7aBXCfRnxy++6fpqRLm8un3hsBRLOEGBBHsGMIEm5JB2kDu1mcWpGUIpRO6AnssAKwJhkwbW3mWBOeptb9XGbQL0oxdiePUjd+LBnyZ5X1MwNo9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cx825lV1m5kDyC9LW1BOghhObtj4WdsGxcZSYm7X3I=;
 b=WCPv7Vck4e/lVHRHKZ/u3jkil7PfjOxUuuuR66bzTUlVnT7NY5O+xQPjbIwpL+/VSaHzMDIWt+iuupYAgLMRuBdg8aaqVC99EGe4+vuWPTYBgPKPfIDFQX9roRoGghJTF+5ZKyVr9YVAuPCL0NyCamD6QKGEt+SKjr2ZxLLSt0rRPew30CbMXqVnKIr2wxdOy5uQAbqQ+T1LD7T12nK55fohBPF24ScFZn18fqTLFqHAr1paMr63o6/XX6WFCBknKRBV8N7ZqvrAqBRFnmS4IV/dQw3c7Xn/4PTydUnDSLxNQrHnUA8hz1sDENMMfyboffScfTcKg0sWHD1osw/e7w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PPF4D923B935.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bcd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 14:34:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 14:34:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Fri, 11 Sep 2026 10:34:36 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <05182431-A4BB-4842-86CC-68B2E14A4F33@nvidia.com>
In-Reply-To:
 <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
References:
 <b1829ac0d3f38217f031854ff0f40abef614ac0d.1789098446.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0639.namprd03.prod.outlook.com
 (2603:10b6:408:13b::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PPF4D923B935:EE_
X-MS-Office365-Filtering-Correlation-Id: 5faacaf2-9caa-45f6-11f2-08df1011cc4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|18002099003|22082099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Dg5lQskHk0HJL2BLooB1chMcgFRDMEUooG2rf43pgO7DgmY3M2EhGy2/IU/0bAAh2OyosUsKd92qafJph6eIoajPBxvzVKHLoMHf/KuY2VpbRnQRnBv80/Ly576A7Jn/00aA/c7g7lKLZu612isMz1esFAIc28u68wkB3DFZ86xP/q9zey5Tp5LAgX+/nNe9NMuurDlN0Ho8mEfAdlbHerJJZTyi2ziJOq23OFTAyWdLSosOOiUL/tRZkRI31DCWg06Nr9y1cGCH1s1+/pZgYTejWQJhUvxnr2H5LGdnX4rotN9KgZ/uPYSv7cazMXnFDXrBEFuaXqXCDzTTdx/BoaMciCXRdLQ+2nHwOIJWdw0yslinDDpMK+1dhD0kc5AIBLKaEnvzzDhF6+oLui98LX3a4HgHU69MRiwaU4ZeUsVNE7uO6hbO2PaIMerNNRUIw+BbanQZ/413CEh8QuCldvs0Vv/evxt26eyUbnATbWESEgRLIXuFfxZcSKJg0B+aHCVrbthcQa7JwnoygxYb6fGPm++6NDzYJgPvP7U4nzKscp8K5a2PeNcft9PLPLHHTeFcOK3ZbXiA5W0mbxdta7jIFgH+23qAeHJwv37QVCRIp4xRlDnu+Xb5ejggcQyqwiXQQ/y6UA18LHy219uaJGRxKARgYDFaG0661I6w+PM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(18002099003)(22082099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x2Ne+bILIuEu4dngwBgQhRzjiAaVCVaEmH3jFuxMqsWbdTQb6fTbKf0FFJc5?=
 =?us-ascii?Q?Fv+KSzm7TE0YZV9eCP6spmV4AmllIcMtKeT9Q2GFBVJuQooK0nNf9N+b61xq?=
 =?us-ascii?Q?T5LOHCCBSm7VAhXM6Nf0WAmhYSrfsfbubo6RI7Ttnoog0Rjk2EqYs76fLtSp?=
 =?us-ascii?Q?z/9Nyiwc7prgQ8Zyr0ceE9ZHrbJD1Jc75o9SWk2Az0+HX4SpX0XN7G5thuKD?=
 =?us-ascii?Q?O2p38Q+rxaQzLca8PXWcOXuQmABJisFfeS9JSC8FoT/Vd9MzobkfJQG/N9Oq?=
 =?us-ascii?Q?uae37a7wpP/C2xhaSrcvpgcTKM/0MaoqJK/QHJL0IdiAOm2BvdVyQPynJpgI?=
 =?us-ascii?Q?lhVRRNLumn6W+tiro2W8rORkiEOkWiUhbLnacqZlpkwdsNX0ZoXaCHSS19IX?=
 =?us-ascii?Q?I4p21CSUzHFDgRERENwSV39ZNcQg4Nd8LdU47EfGgjGAYAXqpIYd65qh9SVv?=
 =?us-ascii?Q?sJ3q+PEng7pgrcrAuzrTsocEYxeO+e1XW6VbnoJDCRqg2rffOhLfej/gdmg1?=
 =?us-ascii?Q?+4DJHFtKEnN0dM8QtXcO8oUR8o0I1o0DJLeDuuANJ1p1Tnkd+Id5ZeEa7AhY?=
 =?us-ascii?Q?RfGr5FegGfqBQCIhnCn6PxAIPfevO/Rmk0G6O+Q5lHbaF9mDqjH1i6nY7XHq?=
 =?us-ascii?Q?O25vCP/ohSNhaZG+eyw/GD9/Db1tkQtzADDSl4+wovJ/K929Sr2+PXwGqKRz?=
 =?us-ascii?Q?tz0hqlYiVPczRnFAAgOGP/5H4XwpWNByxP3wD/Nx5IaRrMKpPfzn/dScPKev?=
 =?us-ascii?Q?7l3PcWw2gT9JQLF6eg+AxqB4rGu6/pBU7l2Ypk2Fdn0xuGw8mB/ytbIr0Lc+?=
 =?us-ascii?Q?WCoygHdIk9CXPYlgEerwfNvDUI3CbK9gAN9a3xIfzK7Mmc+Mzx57oje6gntS?=
 =?us-ascii?Q?kzc9+t8tiNxlFD/JmSLfJoXZTe+Nry9kHL/A654IlVqa0X35u7VY3FJpyBe4?=
 =?us-ascii?Q?tBkTH2cHrAT9PW84F3Nq8lKbWbmWxiA18oc8bMohCoPPUgkwe1iAq5cXUXzp?=
 =?us-ascii?Q?gJJ7y5n5Kau2l7x80Yattb3zrN0SJItX2MCXlJrNVju5UtrfVLtjbSfSD/4m?=
 =?us-ascii?Q?BtEpPcc1yr10rSEDubJKq3+MLrhcBNnBgp08gSXgK68LzB6bb0XoHnPFLXtg?=
 =?us-ascii?Q?ZZtCKmA/ABTTMJ/byrUqk8iQDjbKp7xh4RukcrSKLhk1UdJHzh3kH2uRnI4k?=
 =?us-ascii?Q?tdt8CW8hSZ++pwJlYlPN6u+Aq96lcrXwSS629gwUewOP+LZK0GCKoq/fER2m?=
 =?us-ascii?Q?SQ5VvAv0LpsbOdoVr+4SstM0dd6C+WhEPihjcFEW5ZdjcF0zUjnbNiuL6VXe?=
 =?us-ascii?Q?QrsEd3NR+73vzde7s4mYCOu2+sAmEyKZ4Eidqufv+ZO3tygXB5AI3AzDuN5I?=
 =?us-ascii?Q?F5hARQc2Qz1CBc84WvuPa1FARpHfKJ2G+ootW3wbbHNNDAEkFEccpjLOBoqa?=
 =?us-ascii?Q?ouLvwSmSupL1AJQlOcnR3Kvwz0SIU0CXE6Ub6Y5MbZO1LKs2YNyNtUQbOU0U?=
 =?us-ascii?Q?1dmsoQMfKRE1u4178h5CYHAhunZ8Ke86zn0ROOxDGpKXD/UriLcijQasNtil?=
 =?us-ascii?Q?eAF9OkzKnNBSZXzbE+c0rfu6O5+wJnTfj6epIciGiwzKxJQZN61zV0yUE3+9?=
 =?us-ascii?Q?XCxkT0Zta1HTOLnHfjVHv3gDZoCxKcFXK1kRIrzGO89ElIU/+c/1dOGooKx0?=
 =?us-ascii?Q?1C14JMGJEOV9fQFsbL4/wRfbkqZxkyZp/Lj91IuBFd+LBV3/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5faacaf2-9caa-45f6-11f2-08df1011cc4a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 14:34:34.0022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BZiipEPDe0hkiyylbmuDzxtCcv34pung/5a2Vmf6WiHVWb6rSIIAPxw2DQvPfF/Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF4D923B935
X-Stat-Signature: xzct5n6nfn893x1spz9hx5x8h9a6fzz4
X-Rspam-User: 
X-Rspamd-Queue-Id: D84252000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789137277-80951
X-HE-Meta: U2FsdGVkX18AKXGGPi20rkGP5wynGp2K6qQDPLVsaXKYUDTubsDoQUsAC8YOtfMNufZqogog/rFcQfbdTZF+nqYhBkSFEULl+5Ur20PCkySQOmvsltR2eiEE5o2xNdzaflcMM40EElG6m+1TDTbnU5yAw3pXZ0fAa3qq1Dv0MEBpznOUE7E6r2VMseLqHvJFJQpZtjDKkcJ7bflzNWXgRSsRqF6mA+QDVILKXh+0qKDRjI/pe8dM27GxMppifSBmaVdKTrVyHAA0GTy3eZR+pmUfU8Vj2bCwJZwXNiWhFbU+3//+qbnCymwHK3o6ieGNJy7Jh0oXQaMPkuzxthUtQ6C4cQDO/tKoiav5XYIE+jUx3QFXUH5v59spJHgVEmv+blpCZUrOcEISfV8Ru1umt5CPeA82NuYz6GBgcVV5BA8b+Ran8LqzoQf2Aaut/Yg+zNvKiF7EpYPRS+J5MqIltxx01/BHmvB3Q/p9mqB/0d+Fq7JkiIat9rrmyZcs16txtg1byBQa7MRq17C8YeEm+6H7HPPcnqM6CtARDsGh+T33OOSPWa1Vik3xztnTaXasqv/+EKbAlF1qzbX5c+Kmt8PEHSEXtEatWycUu3qcJRXigw9sMbtqOhd1/o3qv1nyGLMAavOzm75P/2jod7s3vyzN/tK++JtibEolgpECfTqs5Gv5ARV2/sZOKf0MO14OMJhmSSFbXKHUhhl8W5d+UrbnNcPgy9PzTSNn+emIbRYDS8N2z8j+5R5/bib7Bl+WX6fXKQi+/JE/QUJ+GoyeSJGt7BFFSjbyIaDOGy4Uzye2ZaMcObsaHQoAbVs6kIipffWu2oPNDPO92P+KlVFGmuT4ILBxPBLVxPdERFVcl+MmYbMm2MnoyOYBkl6sS/6wEppbX/O+8pGoGfMPXDTX9HN0jImIyuw73KYLrW1r50kSNSP4qIqUlTBgXwtgvABs0MTmyFeRnZbVrVAKROQ
 Lsn+ZiZ+
 q2lldIrCzHCZe2s09txJVLAg2jTaqS0aIaSayeyCJ49q6yzR7kqCSI2UlX0dbHMfCAX+o0WIHnTgD/gZMzxPpRgrGbz+Lk5lAqKhaFl/hWMNHwDli47BmNz/nHNyfiaHC8k71UrCw26Uyw5O2jh453Urebri3xmgfLdEd6VJHwbYF8d72/tuOyprdoceZkC2UEEQs/94S88NGBD1vZlHcoPLumY9ZWP19C3ngp/eI1LMSK1utY/xWHovV2VvQJ8J/zSPv52ESB158AFDjJUXeipUXVtWPX7bW+CZ+71Z0n8qyEKCE4xkW7T0E7iSUrccSq+vy/YkVJ/fs92WROSYjcojpde4+jBf307/7mIPaG0p4H0ob3z+qXz/lNiuto178yjepry9elv0FLWphgJW1XwxCkC+LoBFMbnnGV1+rK5dKbGJhkjVM8nUZgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 0:04, Baolin Wang wrote:

> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected =
to
> ignore any THP or mTHP interface settings.
>
> However, after commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_=
enabled()
> into shmem_allowable_huge_orders()"), performing MADV_COLLAPSE on shmem=

> will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "in=
herit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
>
> Fix this by returning the result of shmem_huge_global_enabled() directl=
y
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while igno=
ring
> shmem THP/mTHP settings.
>
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into =
shmem_allowable_huge_orders()")
> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shu=
temov.name/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Hi Kiryl,
>
> I did not update the selftests, as I hope this fix will be merged first=
=2E
> After this fix has landed, I can send a patch to update the selftests.
> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

