Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0FD7CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DC78E0003; Wed, 10 Sep 2025 22:28:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0556D8E0001; Wed, 10 Sep 2025 22:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E863F8E0003; Wed, 10 Sep 2025 22:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D7AE68E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:28:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A70214036A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:28:42 +0000 (UTC)
X-FDA: 83875386084.08.6EDC8C9
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0085C000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:28:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q5c1MHCB;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757557720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTF/LkZntMnAwuF1n5S+0DkuAzP4GjcW8Ztek+rgLEk=;
	b=5OoCoWVq3cIOM6eFH80ZbliDno9B8/b3WnvnUER9PeYewpdPFGC6p0ZevvL0bIai3rjiqb
	ck9/kINL8qrlPik239ORSErUoYMBqHgSjPwvG2wewiOLSFS5kDmLI3bc9bXDWZqtJr4urS
	ASVuwsF7YNJ3kYdn+Fa+VW4BGQS2t5I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757557720; a=rsa-sha256;
	cv=pass;
	b=WCp0oNkl2ONlX1HU9sxLt6N6Lh+rQMSQe4/aYdNpgCjGvmg8z1G5L2WjiXPuwwmrsRJork
	RBXMfvzGI13OTYqHidIJ+J+JDsc9CH/LcTozIU1HD/SlWVkQsv7uJUqJnNTOhxMtxSjq18
	f+ltMdz/PthXrXWrfOOFlu9vnXGL1ew=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q5c1MHCB;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=usjXpkL2oW/fe2B48XLCmz1/YXT3+WiziQW6WN8O16z6roI7MB34+PoosLwobHYPLM5OUcFa5A22Yo5RnjcBFKwfnq2aZ7rkmeH0uh6OOalFEPUFGl4hr9FfVZiUr56HV96aieADk4dn96jxxTi+spD11oTX9tTGUVRLc13AC+zuA+SgIqQ4bMMIVnUJ3VGAv1APWmTDhdgskDyhSTwY5vcsxu0wfPuhIlutKQZImb4GUORZN/vBydyioA9m4tFoX2pOXOedHYanJCQXoFBGWJ1/ZuMlqbI2ZKTgkykMgn6pAqatQOg6h9s0bKp+T2mdDcbqk0OccXTyOInfbcdZcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTF/LkZntMnAwuF1n5S+0DkuAzP4GjcW8Ztek+rgLEk=;
 b=mq4/rn+DgPc3Gui3o/JLEGF6FNppcbUi+ORW5ibFyDoKRRw4d6LpLYdUTvKkxpO8w2Kn3Tdfl+RqfmXLxMUMl4JzGIj/pWz1UKM0M6qoa0l9Upe8UjL0PIrCgfHu6B6RcljxBFLJ22nrgZj7FEUN6TgC5SfVvJEjCAgmT5qgEOkB+i4VWayP9qrHbe6kJzCI/RndKzNlVvMvwqJ2HxTWFLSrDeWsCRPwHV86KLyISNwpLH85W5+Tkg0lJLiXHJf4ESR8f+P+PLyyV8yw79L9Bbh5RMq/J0wRqBHvTKnpeUVqroEOjacxfSDsrcQmDkRAYXezpknCaOg7vu4Wr1HGbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTF/LkZntMnAwuF1n5S+0DkuAzP4GjcW8Ztek+rgLEk=;
 b=Q5c1MHCBXvuexdh1FmfNWoShviFn4fBJAzK8tewGGv1UyrQkZzitinmAqVKjOfZgdVVY3usI7YsPuWJVPol3zU7eBVcQrVboS33IasStw0B/MJ4y7+IagRVOEAGeKB7HtnyHdlzizvD7TgYe2U2O8/jMi30PhDkde0ev21kYhriq3dB67dJdsEhJaerkbZpTlnwEw/imBf7nWq/cCMs9oE46fshsucS4I/jCmDNG+sS0BPIkDI8FbRLUBXJIPFS2MjY7OcY8DJB6LTjiI3jKwuUJ5sqy7KdS/Xw7cSgc9RAFaMYEB/wETRJrkwVwTfjzCGNLa+haQKtL3EQTYG03Mw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6049.namprd12.prod.outlook.com (2603:10b6:a03:48c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 02:28:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 02:28:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Yafang Shao <laoar.shao@gmail.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Lance Yang <ioworker0@gmail.com>,
 akpm@linux-foundation.org, gutierrez.asier@huawei-partners.com,
 rientjes@google.com, andrii@kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ameryhung@gmail.com,
 ryan.roberts@arm.com, lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
 willy@infradead.org, corbet@lwn.net, npache@redhat.com, dev.jain@arm.com,
 21cnbao@gmail.com, shakeel.butt@linux.dev, ast@kernel.org,
 daniel@iogearbox.net, hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Date: Wed, 10 Sep 2025 22:28:30 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
In-Reply-To: <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev>
References: <20250910024447.64788-2-laoar.shao@gmail.com>
 <202509110109.PSgSHb31-lkp@intel.com>
 <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:408:fd::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6049:EE_
X-MS-Office365-Filtering-Correlation-Id: b961a1be-ed7c-4b80-6224-08ddf0dae8bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kIn2C7blM56LA+HDboelSZDlg2/aIBa1KOl7MVQcDxejoLVstlKi+3b8TyQI?=
 =?us-ascii?Q?DgExwL5CUTNme8VeEwbvopcxhsbyh0KcEqZsiGjTE7pu/FHFyXGmSg1Y1kXh?=
 =?us-ascii?Q?+st1d6/5URG2BPmrsTwzkKEJisT4goHHN3yBEVE69mQk4NI8S7rm+9PPA05m?=
 =?us-ascii?Q?nL/FcGUl42GP16qjlqqUx24W/cLyEq9p+n4fhbbnGp+FI9rQ+XBIH/++eu3s?=
 =?us-ascii?Q?BZfP7baM+nRuFpDTjLxBckCd506ZfYs8ErlqrMWv4w3rsP+bXFg3KsRiv2/D?=
 =?us-ascii?Q?JuFHOed0xgXKhUHJX4MLQ3qtokDVe/fb3gPkff541vBDlIaEmUo7SCbkVH0o?=
 =?us-ascii?Q?HsRBkm2TsAe4uad4+Ej6JMmKLAmInCr4kxgQD5JtZ/qshSzBndGm368ujO7I?=
 =?us-ascii?Q?B/N+SF3VSMKgWCfBtq9kTkgysCstXvzaMcB22o17GAbnKBPQFub7d/lLF4ug?=
 =?us-ascii?Q?fxpNCtVEhJmlS5z0I2Iytk9vDbS158TAAQ2/EOxxq5qAEBEAXL2JKVq79LCR?=
 =?us-ascii?Q?Bbmt2rvNRWeejWdUNzHLTyz5UFHQxuDfNG27LRhv67aav965wf5q/HRFLaz9?=
 =?us-ascii?Q?C6xbN5RfAAPvjGsSd481jRYdBOXlUuAbCRHbVIE3DWumKSg8q61UVXP9lMha?=
 =?us-ascii?Q?dyxTiJHPTibEid+bSpuOLXzwQ/UKsav7TYuC+P/YXMJmLUof9T6ulwtP12nV?=
 =?us-ascii?Q?Dkf0o2sSwTdVpxe7IR6gWa4masuXwYQto/SL2YNNBX8kgMN7tVbvUkBOwNmc?=
 =?us-ascii?Q?99EEYrAPDlIe9NAaYm/Ukj8sfCJSOLGh2YaxzEq+tme9seuw2qTw0mumnpBc?=
 =?us-ascii?Q?p8UxdtFvUxJDNDNWle5gQsC7kM5gx/CksYiXTwD1xxh/4uJXonK/ZvW6ekgv?=
 =?us-ascii?Q?uWAsK8Xc1NVBzVFUREXeMw/0GOzOHvZd7OH6pDlarGBSelKVslW8/mRMrHn7?=
 =?us-ascii?Q?r2XMLeCw6lzZYZB4AROLs8E/f1h++AwnTnxU/r6n5EHBz3aOjVZTXXX3pbMg?=
 =?us-ascii?Q?wjLblwz1Is6wn5XGrk+EwJykafkjn2U4Q9FW6CmOVGm3A0Fouwu0ihLCd0EB?=
 =?us-ascii?Q?S6MqilemcAvM3PYRkOb4eZHlwmzrQAz1o4iAr3R9U6ILWG7YwDt50bFIAefj?=
 =?us-ascii?Q?2FeBU1yYTUbgcW8WxQ3WuqHOed/1BTV0UhfFmoTJhmoBjRDK+rcYU9Fyx/vz?=
 =?us-ascii?Q?xxQbT46/ohUd+H3w1a+PuDuAoYI8skX0Rtfdce360hsgJod6Tj4YbL5N/yrb?=
 =?us-ascii?Q?Th4PBrt36/THpx+XaMNdUth4U0oay8p1JpgGYNt7Y19gxNNpHcki74pP433s?=
 =?us-ascii?Q?yFc4qpMSBsaOBjWeTZ2nv0PNuEzc083pk4wVdJJclNPccvvdaoA7DTZ2q/WJ?=
 =?us-ascii?Q?seewRy7sYTs1HSNK41an0Ou1nMQiCT7yrrFGs3lZlpH5J2gaK+r2bHy24aih?=
 =?us-ascii?Q?UTZGZGzfiyVyqHhmBTvZVYmUUA2Vq7QQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q3oQY/ZZydBjHLY2wQSw7VO0n5O8SPXL8t+I8TQkhbKRAD2Hbv1fpdZZJxBW?=
 =?us-ascii?Q?V84fpexQlrytdt3Ni4iOLiMq7oX+Mg5e+ujRoz0IkDPmV8KgCGRLEoXwYRLR?=
 =?us-ascii?Q?igZdXHlbmGnjXJyJQbOi020I63hNyXExbGpHD6kMvdppGvGwEBD6JrKwOHnx?=
 =?us-ascii?Q?9fghm8+tywc/x8o9eI6Tu+HZiTKVy01ejvQyZLiA6isPsLwFs64bNL2xycmh?=
 =?us-ascii?Q?X0Zv7xHjXgPgQYCAbsboMcWULfTLo0/KS3TlN4Q9N+iPrJa6v40dwI2L5RO/?=
 =?us-ascii?Q?01djKnBl5J8d62KtzDoTcOWL7JeVZPln48mvcgcp4ZPut9LAwFwCvL8pZzsT?=
 =?us-ascii?Q?KqPElAkkfJtXVcIM92dOIoldUu9ApTKthJxMPl0REsRYQEkmi43OEwawbj6Q?=
 =?us-ascii?Q?OlRwy7NijQj2bqzFy9WRfE3DYL1M3GVN7HgyuUdKX77HZTjf2XRFSUlvnZBv?=
 =?us-ascii?Q?5uBbhMvOZY6mC+xnLTmr75uzlauaT29/FGLbpHKmk8YssfaYOetiYyU7khih?=
 =?us-ascii?Q?jyZlRRxG1Mb8NnSKtnQ+nXZ8hLQ/N2pDolC+b/DBmtBjqDllc5xNp8qG8q+X?=
 =?us-ascii?Q?w88jpSvuZdOGJAUnyFJyJoH7MtBt0H7WczYsLDEKYRUZpXbqNKbLXfI+WH6+?=
 =?us-ascii?Q?q2ePTj2ipFxbgBuOflOeBqNCLM2WCoauwqrU0zYlajrKg4NY6HvPwowflaMD?=
 =?us-ascii?Q?XsQdvCWSNdpHKjtXK7HlXT10g+RgNkH6hJqjiVXLJqCTcvOWKDdSL0a/5PKX?=
 =?us-ascii?Q?3dW/QOv7FcwEhdP5uPJVPAVLemcD0wxB+nRMKbGnSqbJYGZ0ntnH4IYR1rjM?=
 =?us-ascii?Q?+EEK6UPuVOj3SwXq1rmodZi2X7o0k/YQaVlBLZ/B1wTLtusVYtpyFLeYl01B?=
 =?us-ascii?Q?aTjjCReldMZKZzmgzN/IBohi7fouAvfIO6mruA4wtj49YNwoCQ8+E8NCjMCO?=
 =?us-ascii?Q?uHL4T+uBic0JaF6EcUUwNyL7u+HTCTZkWr3laFpDa8tmD+JhaZBRZBrFUnFZ?=
 =?us-ascii?Q?6U4ffF8VRlpYQwizesFhEeFK+0ZFDrPAbpqRXmOnqqW89QYGpouDiJ42bUi/?=
 =?us-ascii?Q?S9YdH2E2XuCIr7Zg4S1Uf25mEQJJtVKs1q+cAX5stCRDNCUyG7PF1T3wXlMK?=
 =?us-ascii?Q?dcrEmwGwoM4qcSwbIGfvE75B/DFiV+O/2OiaBDlaRKogfgiKgUuG+Gg4kE0k?=
 =?us-ascii?Q?AFVX42WSZs01sgRb+Lk1wBdwQo4In+ImoLjcdBjRbGFYo5nhKwmt5tORznJp?=
 =?us-ascii?Q?9Ut2CG7ZC/0SG5YCHQWT6xWyEh9/JVh3/V5GSoYjqQ4imK/jZswcEbvepfTV?=
 =?us-ascii?Q?zu6J4aouuT4PrK9EZ6YISOh9k58oTDIeSNnhUev4pkZIpyy+TGU8k8E9tvET?=
 =?us-ascii?Q?aIRuKBXI7tsrqFJ06i9al0nRHNjJaOEjKOp6yBBX11T6fq6pAR21xXKwqUCK?=
 =?us-ascii?Q?/PVbBaLS0FE83SSq1wpL/Qyegd/1xZVafgVbAWn4H8/cEdxHjrGD6LYm5SUd?=
 =?us-ascii?Q?SdRwk73RjlLA9fmEdmFY6FjdH6+Tyz/tc08lgoaFZreAtsZlMZxIWzeSh/dM?=
 =?us-ascii?Q?bvmh0bfyzTAveBYuDuaFWpSVF7rMVS/r0VhRr6Wf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b961a1be-ed7c-4b80-6224-08ddf0dae8bc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 02:28:35.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tx0XAhgsFDR03ZdoGp+EBWxlV4EDPp1XiysOtk+/HHlrlwPJfyrDPQU7pR+epwnn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6049
X-Rspamd-Queue-Id: F0085C000D
X-Stat-Signature: s1n4gijfb8m4ba9ow5sumjmanmar4tyy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757557719-689868
X-HE-Meta: U2FsdGVkX19AQ/fV9jQXVFa85otO8ut/p7U2wltk2kYaPhNU6E7O4HnEKGMpE1W7Oig4Xnrv5sqzvAs2YYvvyK674stfTLBdoB6SSFkFEW495nQ5U4xJ18/xg+HuEP/dWRyN9VeJJb4bqFeAOc9pm/zgmxTVSna04SzF8bF8+y/Tw6WIOvBZLbNJoE/7SSjiWYdUZnTW5R8QXjnbf21+zIOkNlVQcrPD7XV46ZNISBHgnCo+Mrg8nuMwZMz8Q+0LV13EyfSyn5OcxTFD1YBevS7Y+oGKmoNZyQR4rXdK+5/6pR1RIa9VIzCf1MfhCuaGIiFFL0dcWy/CLeyP4SbvqRmqVsoFleq5ARjeqYtTZq9hnjhm0ywMvJB7u2bol52m5zDIpb1SRFVlnKaoOUp14h2ciu9LZ5H8Wof0YBSLMGmJkXXbwM90aVuNB3liqqt73S8/kbGqzzO9EF6HblZdkNCk4vqY2Hjw5GRlLZbCA19XKq1csdVkA/PA+ET1FfaSMi9dXuKHZB3E1PSj1Q6YjysQILwWTTRFtCFL859/oj/NEHdZKpbaTupF5DPsGxSdATz93YpuFEPPcL98NNHNal2CHyhiz6aB0Zpfje7ibyHRYuqTGXg2qaA/5eqECEhRsdq4mMB1zlg8xr49VUDM3NR1HFqsHtFfx9XpU2sGr+Q+us/MymkYb4XNzTZSy5ViY2SSG3uQlKeRdKdjSWEC6gtZivASSAYO6JNW2tP9th1ckEpO9pGaC/u3brfG0cR8rGDVpC6U2hbevsCtRXRP9H3hqvzVy9vR8td0LtxhYL/ljAz404x0YgkQntc5J/IMIiaXfIycN6Zyori/jf+dhYkReLNXwn+hhGaZNbi8OSq0JbfkE8M1vfmdy8XhizfEn6J4PxB+XyRBPMTDIUFBqFudu8BX0KpfvAfmNqlaIkGiZfkRz4veUmbrXm+Hb9/Q1tiG90KodMQ9BewMfrw
 QWl5tuLG
 j5M2FOnO1tKpk7O/i0H48HteS/Pk7JJcUA0l2KqkKcrOed0Eu8fcEYAlQjHzkDt4k6REHnM3EYc3ZyrL9j2r7KNcwaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Sep 2025, at 22:12, Lance Yang wrote:

> Hi Yafang,
>
> On 2025/9/11 01:27, kernel test robot wrote:
>> Hi Yafang,
>>
>> kernel test robot noticed the following build errors:
>>
>> [auto build test ERROR on akpm-mm/mm-everything]
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-=
thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm=
-everything
>> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.=
shao%40gmail.com
>> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task f=
rom khugepaged_mm_slot
>> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20=
250911/202509110109.PSgSHb31-lkp@intel.com/config)
>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 8=
7f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/ar=
chive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new v=
ersion of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-=
lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pm=
d_enabled'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
>>      2500 |             hugepage_pmd_enabled())
>>           |             ^
>>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepage=
d_enter'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
>>      2501 |                 __khugepaged_enter(mm);
>>           |                 ^
>>     2 errors generated.
>
> Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are on=
ly
> available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)
>
>>
>>
>> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
>>
>>    2471	=

>>    2472	static int prctl_set_thp_disable(bool thp_disable, unsigned lo=
ng flags,
>>    2473					 unsigned long arg4, unsigned long arg5)
>>    2474	{
>>    2475		struct mm_struct *mm =3D current->mm;
>>    2476	=

>>    2477		if (arg4 || arg5)
>>    2478			return -EINVAL;
>>    2479	=

>>    2480		/* Flags are only allowed when disabling. */
>>    2481		if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEP=
T_ADVISED))
>>    2482			return -EINVAL;
>>    2483		if (mmap_write_lock_killable(current->mm))
>>    2484			return -EINTR;
>>    2485		if (thp_disable) {
>>    2486			if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
>>    2487				mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>>    2488				mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>    2489			} else {
>>    2490				mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
>>    2491				mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>    2492			}
>>    2493		} else {
>>    2494			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>>    2495			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>    2496		}
>>    2497	=

>>    2498		if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
>>    2499		    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
>>> 2500		    hugepage_pmd_enabled())
>>> 2501			__khugepaged_enter(mm);
>>    2502		mmap_write_unlock(current->mm);
>>    2503		return 0;
>>    2504	}
>>    2505	=

>
> So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE b=
lock.
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a1c1e8007f2d..c8600e017933 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool thp_disab=
le, unsigned long flags,
>                 mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>         }
>
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>         if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
>             !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
>             hugepage_pmd_enabled())
>                 __khugepaged_enter(mm);
> +#endif
> +
>         mmap_write_unlock(current->mm);
>         return 0;
>  }

Or in the header file,

#ifdef CONFIG_TRANSPARENT_HUGEPAGE
=2E..
#else
bool hugepage_pmd_enabled()
{
	return false;
}

int __khugepaged_enter(struct mm_struct *mm)
{
	return 0;
}
#endif

Best Regards,
Yan, Zi

