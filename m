Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6F8D25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 02:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CAE6B0088; Sun, 11 Jan 2026 21:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA466B0089; Sun, 11 Jan 2026 21:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381686B008A; Sun, 11 Jan 2026 21:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 275676B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:50:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C291A161795
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:50:57 +0000 (UTC)
X-FDA: 84321784554.30.8E2BBCC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	by imf24.hostedemail.com (Postfix) with ESMTP id EBE5D180004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:50:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z9yCEjj9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768186255; a=rsa-sha256;
	cv=pass;
	b=eCTGL7vAIGIWTbY26YEe9zcmF/q8f/9o9b6m6fsCQ9++ItIwbJA0+slLlO/Vo81St6i7Zf
	GvTykZjYjwTfaIdcsTYXLETxYdqzPao9ow7KwwjDqKOI+uxMvbPgIBSSTj8EFSWbS42i2S
	yvCaf0lc1vrlvX7pCYtcav7DVPHfOx8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z9yCEjj9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768186255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBaVyC4tw5TNyNPJVlOKVdNRka5OPZ5n15XC0RwsSKE=;
	b=HMISeME6mTouwlvs8QxbRbZBuaBWqQHF+GdX3anHPMyFl+B0gqBhMRe7LazX9W0yNYnUQY
	1IIek9HPCZ0+ug9+NFVvTJzA+isOxRgfjCuyFnngVRynAWpAdibVdVYisTzcLyPvKyJAKV
	WCrSrcBr6kV66OMbR5bSznqtV5CHsTs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RiDZueL8APjW8JLqdYQmNh0ImYcQZxuGRLYWoFDuKCBttslG21gI7gQQvvTOzIghK9YkevJh6mr0xyR7MCnma7owQHJkiwRfPZBqhIGaRbL2RwF4/7OwYvTMk+Yl3DdgSvVMfzCJbyLIYEFQqTq4wqSAonoAe3a6muuVFK4tnG1Z0SgXwiGuDODmAxc6zAcr6/KPetAs/WYreEmEZIDTzEqFt36tLlYi60OfpPlj927MTsNQuVECQ9mMVfaTEMlooSiXaL4QXeJa2pbYbGLcmrPzhl63kmQ+emSW+gyX7NPpGoPPlOrO+Mu5UBQLfzPeJr3hGPHIft2uRzKazXAT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBaVyC4tw5TNyNPJVlOKVdNRka5OPZ5n15XC0RwsSKE=;
 b=Wun9g5Y8u3/LzAf1po5bFtMEL/BJ5IUkswUOVjqIjOlpSnMS7VXbybzvJQ1SHvi4A2ggKDWQeToBEZOBCsPMQHzpmZ3S8kiq5JBKH12heZIqoXwh1d/Z7Mq79tQFDK0qGSwGkyf08+HSPOiAcwL8cj0fJeumJ5DFIS4raJrXLoBsdtjZK6sM2OoIa3Md3DigdNUvbAXQh/DIBNpMWH7zil9SgAR+3VnMcEqC82SE+ukFQOTkW9NXs4Bdx9U+IYhckLGUXy4PvjO19G7Q7w5OtB8QUB4dpXCygtgX5m2XYdmdXe1HeaxdnQdMPps21NnFdMzrOd4UlKd3GOW8EPYF1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBaVyC4tw5TNyNPJVlOKVdNRka5OPZ5n15XC0RwsSKE=;
 b=Z9yCEjj9i1qwtW6oliTWKE1Bln0tiJztBwQUcqeWs7vuz9Kwdx7ECV4KQJjaY3JvvjQVRMVQucHFqIVc5oCd1xtSO90iX7JnfWYxvHkaRffnB5VoQVhAOGmGMp9H6/yJ+eNdrvWysn4fKzL3epjEnzPNnMYOhUf9ALeNVAABtOIFymFa4rUVsQo4bH/4orrX7OSDflQBQTA7Ew79oTxONG+5YDxrYawbybplVPs/1v5r3dWEAEryIApwPpGwZQ5DG4hvbm9MuEN36xlMpfOHrYg/tC3/sooDDsDCP0zmbdRYUrW8Akj6nV7rZGE1msUHvYmdquPFGRH28/hKozDmxA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY8PR12MB7219.namprd12.prod.outlook.com (2603:10b6:930:59::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Mon, 12 Jan 2026 02:50:51 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 02:50:51 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
 harry.yoo@oracle.com, willy@infradead.org, nao.horiguchi@gmail.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
 tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
 rientjes@google.com, duenwen@google.com, jthoughton@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v3 1/3] mm/memory-failure: set has_hwpoisoned flags on
 HugeTLB folio
Date: Sun, 11 Jan 2026 21:50:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <44A610FC-3154-4FF4-A940-12ECB63068D5@nvidia.com>
In-Reply-To: <20260112004923.888429-2-jiaqiyan@google.com>
References: <20260112004923.888429-1-jiaqiyan@google.com>
 <20260112004923.888429-2-jiaqiyan@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL0PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:207:3c::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY8PR12MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: d31d5969-f45c-45f5-38b9-08de518565da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?863FuBcQcOt+IAT8xm0t87OTdjWNt3zEng4YnbRidhNFdBdnbQmMy0AOChrY?=
 =?us-ascii?Q?uwld4u9IlzNEmTQ19EDDbpK5+qqVfL0zLyfOqlv8W17CxzdFdYlvfrSGdlmk?=
 =?us-ascii?Q?9JC1KWj7lsuzuHmQ/6lvnvIW/+kVgzHpWkDHs3UhHktIwG7f5SYsQr+nxto6?=
 =?us-ascii?Q?T4FaxhtTg7acJv2qrb2rCFcqf4ktqOBvgAF7JHTk27ktNt9DXATeRhwMcfq5?=
 =?us-ascii?Q?8zgg9oYA7Kuw8YudR0XiwJIV5D4hjpfPvwTvlZAU+ynudiZBhaTyt/+qv3+T?=
 =?us-ascii?Q?JvkIkQheISrJzKehjH35jwjMmtb5GbjnZ1ttLDqvAJSq1zEOSLWT7AbXdoJ+?=
 =?us-ascii?Q?ucs2xCBhY0yLM9/733XoedCqN8Es5V/q8A9PBTT5DmVRZxzmtTRsTlO6R3GD?=
 =?us-ascii?Q?Q7cr4ltUpnFiN4W2Yh3fEWUt2yG+aQZmisywBo61UeEHkLS0lCPw0RD2qmiq?=
 =?us-ascii?Q?QrS1hfklsVpmXk01UAocKjiwQxupLCEqo0H7FdaHZLslgyy2/ZThEWcnQvwr?=
 =?us-ascii?Q?mT9jXG7knFJ7RzPAPxJb+3ZxgVcQH1aXC/EWGMTopqbMIN1+0RYz5vpeFY9R?=
 =?us-ascii?Q?0jr0jTiCSlnAr0mOVh4eBNN3PvmMAHjJiwhJCxi6SJgNKJ7QfL230Lcb62G5?=
 =?us-ascii?Q?UVIUjawVChVMDKE8NLVjBWFXQrg5wsvyHdeMhiIQwT657De+nqtigjXfFHrH?=
 =?us-ascii?Q?+PAvOuDHzp8n2fh8md4mfbX//ZX8y5WgEdjVvgz7/47ebfMmRB1K6Dq6TEq0?=
 =?us-ascii?Q?7dAm8fJ6SS9tPWUk2b40Za251K+MZt2+0eL4e6cG9JiyEIMER3U4FIorXwQW?=
 =?us-ascii?Q?NIeluv2G7tC0ZTyVify+JsPTAcNoAjzwfclHC4hvltflgtzSDsOf8bTd7gI+?=
 =?us-ascii?Q?7mDSF81tBW7wLQ5VJQCkyV7KUJrz/SUuHhDnKtRnXjgpYOkkJxbeovUjKHww?=
 =?us-ascii?Q?bQg/zEjvMLcT1HGEVeGvyBhnmi61ojvOhEQor/XBGo+THmKeBhiUfUm/9FB/?=
 =?us-ascii?Q?jUDNaClWpaSbzOaXLG2b7Ck16etvtZ+y2gnq0uy+AooKEi+Ouwf9O71Cu7sM?=
 =?us-ascii?Q?rdM432Ip85M0CklvJL1Tavz3HS21Mj4Hiexvi6RMYpPMkELFeb5eY0lXffay?=
 =?us-ascii?Q?bh1NYz0Ml9flqVB1S4T6PV91J3yOfoiRENmWd8gagX54U6kZE6IULlaok3f5?=
 =?us-ascii?Q?B0D3LKWMMK9AqbATSBpAItS3ajUeYdH7zmJH6G3KARidYn2NOmn6grEPWjQo?=
 =?us-ascii?Q?xog/l6YbU4utQa6+FXDlcUoQlThjDZqGeA3Gk/cIUEZOwSWV7TyvQTlrqozP?=
 =?us-ascii?Q?MQVAXg0gsXlZj++4clUeOhzsJcQ3RP/OzF2XoUZ4PGfyZQ1X3mR61FRJlVER?=
 =?us-ascii?Q?Xz2E6hsCInFP/I5ZjVuNyOmkXEaoiK/1RhvMz0lsAOj6RK+upSad0ua5aorI?=
 =?us-ascii?Q?+hp+fCKS7Ta+19WjnX8HQ3EMK4XUgZyN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rte/YcM7tn0XNPVO8Z4jnbkuKWIyMwlLN2Koml3xwRC5BmhDz+wGxwqnoxJo?=
 =?us-ascii?Q?yTLdLIFCdjFM3yE5oQgSPF8nz2C2NFjyy1j8gdkHyL1xPFxv+G6FdnsDBnKC?=
 =?us-ascii?Q?LdieWcAmpW3Px+/p/mSCkxlRAr7GZoE9uSUkk0P8Ph1idzVfyaIvC4xcggKl?=
 =?us-ascii?Q?ndO7LxjwYVnfJDJpJPGQ38HGTfFdK+spM6Y7oVTD63KLgS34vjFo/Nx80yhM?=
 =?us-ascii?Q?MA9f+q13AYNAdAwxoKzUgrNMLsd/iGTS4ezIzgCCQ6m0bJDgIDNLuOPscwPF?=
 =?us-ascii?Q?auRA0umRbRTA/c6iqpV1odEAibies7ymz2gvHV/GKiVfvvXT34GM+foAKdoD?=
 =?us-ascii?Q?qZrPJvoTIiJf3kjvxNjpC34u93lpwvofHgCy8Mk/Zgbfih1w6J4f0dehSQVa?=
 =?us-ascii?Q?52a7Fam8G8+W5Irk1tuGD1js8Hw3nwaWzl8UQbp5gIxww+J4oTGU8tWxsE0f?=
 =?us-ascii?Q?Ewne56FrxP95s0XJevLpQw0bTSPPMjfd0fh7PhqKjpDwULDvX/ziQ+DAOjkV?=
 =?us-ascii?Q?7TKMzFZOuY+IFDyHU3hIGGLNeuCMaMBoGLrWrwlHysXA6fCmuFeopISvKmx/?=
 =?us-ascii?Q?POTE45GaQCiwC3VFS9z3ReRv4y/b9Z1Om+vzVOIxbz/DC0XYIV9aeg7zsHKd?=
 =?us-ascii?Q?xEtI9ZXuDpvdiL4EQw+2pFrsYPITbzC0LyZy5r9FnxZxZop5kO9Gell0EG3y?=
 =?us-ascii?Q?n20GAgsTFSdDgu7LTShUokP5i1+aMqgqkte7/QjKCq+ci+aD2VBdgpYYauLh?=
 =?us-ascii?Q?6B1ux/zgLR9kHUT/BvGni3ZMxJbI+fEPs7QwZeSmiOfqEHTIAYgusEQ+aWIk?=
 =?us-ascii?Q?dvDTHa5yp/PfpP9wZ79UColv2YLcDI5vE+QE8raBOmGz5BPdOHz7R5gBGmBX?=
 =?us-ascii?Q?/Sj4MMABjB6PhE73ri0XtX5G4GaiWjt7ZNJtJa3TLVI49XCnHYDo0rHgOaDE?=
 =?us-ascii?Q?MW399dVXH6jlvZ1h4XPVGqRTNm6MqujEo64ND0PlkDVB2bCVMZD7O0Uyz6YA?=
 =?us-ascii?Q?82YMwjLprCA/nKnckYvGqIFBtxLxbpNenv/rTr0Jb7bmds6MBH2a83kMY4WW?=
 =?us-ascii?Q?unnSNGDdpr6Jpteo7TISUpoJRdRfCZ3/q56w4qeM4HCCjvFsJEnqWLRaSrfj?=
 =?us-ascii?Q?IgbmOcdODsnT7AOXGK/DnKB1NgbmKFxTiYUjkCeMqm8XITDcfkKE3YOdWtwZ?=
 =?us-ascii?Q?sJy/xn/e8eL3XtvRbZpXQA/QQeMfa6ubPcDU2vWNDZzKSYseLBM+6KPyIy07?=
 =?us-ascii?Q?BwXk70vQUGwa3rEiAy0FVolnBIFAPfxHi7Dv+YeRJ5POaJZbmCarrkDEavV8?=
 =?us-ascii?Q?aR/4U9A5qlSksHAFWdBXIv6kFgOuJQtnF4YlD0ucPDY7gbL8dmEOOpZB5OeL?=
 =?us-ascii?Q?ncemO7E+R/iYUcX5tABSWrPO/3s56j4jV4ZPDSzupsMuGCmP8jdYwNwLR0UX?=
 =?us-ascii?Q?HSqcQNlSh9oCfBHbqgTW3ktB4w2Voq2sRzzn7wlV9DuhveNdb45H9dwUNixJ?=
 =?us-ascii?Q?zO0lF+Rxq59MIxY6DYucuZPVennJ8XRgK7IilI5YEK5OWLqWdBXlbXI53ryB?=
 =?us-ascii?Q?YoPhE9Kh3s/GV12VoNhwlrQ28mkfgo8t88QGQYRn0iDMVO/gpPWTg2fIy2xF?=
 =?us-ascii?Q?b9TyhzwhW6f2oG9q/pVYmKhbD+h3NHe6jR2hVGjN6GxAs7vl8Xzrc+9mSLHd?=
 =?us-ascii?Q?RO9DuBE0aCXMCjfdFJ5zo+bifZo3v7eAm3+wDsx/0HsuV0yH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31d5969-f45c-45f5-38b9-08de518565da
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 02:50:51.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YfpuJR05VpTfqri1N90GMCzPhPcO+qqvLeu3YzAhDJHcjsGBK49YCd5TBCFDDIKE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7219
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBE5D180004
X-Stat-Signature: kx67rpc4x9nazt7x9ctkmd3hrp7ihmrb
X-Rspam-User: 
X-HE-Tag: 1768186254-525915
X-HE-Meta: U2FsdGVkX198BxRwmZ17Fx5CWBFeAgtMEfPmlW/Cw7KqUrJOVwC4WUcDG6OqV66IKm2YnkqiGsFTPQqvii9C1jrQLUyMZkMORZK1eUef/ExDzeN8N8rIIFO/ePXwjCbQNW0raIo3b6pYRtp+m/HXPPj9GhDJPixtyD7okYGlW/ET/8WB/ugNBaVGHRqb489YwGIjtT68gr6kPxHAxFONm9Xd+bIvacwGXKW76uWNTQgA8+NifoBjbRKyu5JPdgUPehns9N+rA3XrahKaDUdhsWJj2WSn6zckLRu3oSVUiPUry0PkhfHGEjtrLfDMQNp1oRi3kjZeqypnYzAEZkSkJ/f88ezvJ0NpP0iYgNB3itBvI72dpFie6RDMZYUVLJ8lMnCWXacIEGR9g+bUQpwxoHDkz29Qd0dbBiprhHgakMSHHtWNv+CfwUI7Mm+wdNPdYvvWYc1/ZkhZHGbps6/o45vRhiqQxhDGie5pkd5Erw/KhzndaQdDI5bbz909iALOZTUiAyKB8dfwdk+2P+f8GTsgDe/Q5wv4iQiwbYd6zVqowT0fjYuuAZBIGurZESn9+Qp1vfvEVXabaRWA+WQ7fDWFitkQgKrXNZntAUg8BU4vEFBDo1NRBOPmsh4jkYPAIACMZLFYoaYm8RkHTJ5BrdJYDTOig+Mm0/VQW0cUvIgfkHjau8ytnDSnqTnLeB+tJkziRU+MK1UfxZM64FZeDtP/D6t5cOHYdm3kYE6hTFUkRUTUA+tTdnGNLwTzT2m7lkxoySCy/FGdP0GPYSyAOV4eokJW9o5iUAF9IMlbglUUD9YuEsQuvlHT9vHnpjwFUBN2ZUxMNH1pruCU7y1DSyOMsgFTJSbEuvjl1U26EB4pncxuJC7wxxIrCDkF8dTUVVqt+NOPQEnhUZXw6P+OfTbiZV+K5tzGNMvf7FsJIFYKURDdVK6hg7kRPJ1nIsKCE6rEczbIjbZCy0QNky0
 e0dtg1bC
 gwKBZpeJ6wvqDcmjxrNNC2s6uRT5+ZrGIgyDBHzfp6oXZZ5P+k9h00Gfg2KP2NPrd2xs/qSg2343h3u78kL5V8dgvjz1cpouFwRb+ZYAUKPemYkMwt8g//G01bkP9bStOp4BRwOTw6acGSqG9MnKzp/9RONRjzpmT2IkieLKwOy+NvrzbmHKK26hA+oF7JZ3kWHSpp4v0+B1NZKrGJNjTaTVDjdjD0BSKLMnBBcEtVe0Nh+DftGBsoZz/OAS1h1/t4mkRtt6QNktKFj2rmX8uBVcRniXf1ARgQf945gnmK0lvx2HRbL/UE9lIjXZhpz5irlcc3EGD0YwzxborvBVfGsDc7eiYwE6xbNZqYyp4u229eIWcNC86lFxSUYjCkgXYjBGIADcx7gs09tqtcv6kI/9wzb4brlUv7Bs33AMeOZ/0Zk+AuISaV1yl9E5Ou/epG0BYEYyUJPpCnxDkXW4NZXDa79rjx2e5cqwN5wollNUL9/2VyfO+h5w1bCtT9nWvca90
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jan 2026, at 19:49, Jiaqi Yan wrote:

> When a free HWPoison HugeTLB folio is dissolved, it becomes
> non-HugeTLB and is released to buddy allocator as a high-order
> folio.
>
> Set has_hwpoisoned flags on the high-order folio so that buddy
> allocator can tell that it contains certain HWPoison page(s).
> This is a prepare change for buddy allocator to handle only the
> high-order HWPoison folio differently.
>
> This cannot be done with hwpoison flag because users cannot tell
> from the case that the page with hwpoison is hardware corrupted.
>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  include/linux/page-flags.h | 2 +-
>  mm/memory-failure.c        | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f7a0e4af0c734..d13835e265952 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -904,7 +904,7 @@ static inline int PageTransCompound(const struct pa=
ge *page)
>  TESTPAGEFLAG_FALSE(TransCompound, transcompound)
>  #endif
>
> -#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEP=
AGE)
> +#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGE=
PAGE) || defined(CONFIG_HUGETLB_PAGE))
>  /*
>   * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned=
 in the
>   * compound page.
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c89..d204de6c9792a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1952,6 +1952,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *f=
olio)
>  	if (folio_test_hugetlb_vmemmap_optimized(folio))
>  		return;
>  	folio_clear_hwpoison(folio);
> +	folio_set_has_hwpoisoned(folio);
>  	folio_free_raw_hwp(folio, true);
>  }

Should this patch go after Patch 2 where has_hwpoisoned folio handling co=
de
is added?

--
Best Regards,
Yan, Zi

