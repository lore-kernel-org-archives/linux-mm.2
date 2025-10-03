Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26915CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3A18E0023; Fri,  3 Oct 2025 10:08:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB248E0007; Fri,  3 Oct 2025 10:08:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6995A8E0023; Fri,  3 Oct 2025 10:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 549388E0007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:08:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE109140819
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:08:50 +0000 (UTC)
X-FDA: 83956984020.30.5EE5F8E
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EB44180003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:08:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bl9YLNzf;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759500528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yY3Jj416rYnJxkLlUjvlgLuqQf92Pi6yH958VjH2BNo=;
	b=A1SYzb0PBaCJDEFlc9dShnw3hX4xbI4q3xRESnbfG/3gH4w+xjjSGVRPlj82eg8rs9nXDk
	ZQz9Vu7MGKokTRrQxx6S0GhJCCh3uaj35e7QmhN/rqyzS0B6Rq31/3JAGUCg17u+xO8c7e
	fzV5hbF4w9DQmfijMmQ87wHzgY6bVWk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Bl9YLNzf;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759500528; a=rsa-sha256;
	cv=pass;
	b=hJa65riAe7ei7KmL8dzjT5i732HqIozqzFANTlAbns5f7pm0dBaMoi99RdcgASsMoDvR27
	14dc0UCrwurwGvQHCI/VputXxEBMgVpPGhgFdYWklpq3KKQ/b1DXLwhwD8HfkJNmJtO00a
	IILGXtYBeVqwEAjFc5/qsDoTfwD7y/Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RIsv33sqiIUGqTXYgUQcxme8V1RwpLGgpqw+09Q46J+3dtksx/IMncIw9cuClE0mUzdw1j99X4+fqTf1tMxqbWR+qibmAk2SB0s3chC3fj0ijCvbRh3R+UihHfto5kfLAH882tPxUH7OJ6ClXXpSKvDQfNbjtJMgub9K8P7P8uKk3tlf6Os5uJlckIZ/HOvmD40yKnKvHcwkFIPNKvQMyirkunQGYdqzG7ML5lslaQ5NjraV9WCFMUOe7o6XiQnu8L0RwxuVLQ7un8MDorYoMs6sFQCtbSb/2bscawYeoxFN1sbgYWNIpXTgxFRNBBa8Enda7jvc/M//8fOFei1Rug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yY3Jj416rYnJxkLlUjvlgLuqQf92Pi6yH958VjH2BNo=;
 b=T+mjYZ4lYx92JBoWlCivZ9ZfJFkRvzN2IWyRXJaZ5Q3hafbw2ZEfKv4bQpPqtOd1H8tXoL8RufFE+LX69+LE2oTLUo+7KjSLcCCyt5tq5GCH37qDy599BfKAplByYabxq19RDZ3KSHi3zrulfY/wmZfS6WNL3KGPKeoy0A8THv/s77uozca9IyCjBi5h5np1BxW1pb6UAaXDRx1H09n6k81aicvyzEnEyYCJ8A7S9yUWPJUYDz5oVuDdSqM0+O5pQfT5ndjPsADCMfRX4BM4Ma3FlNkEMpgDdiVI8FgsrkScNR0Q+kmp6mIRagjq56lv5RPEx/FOu2rCMBdILXLTIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yY3Jj416rYnJxkLlUjvlgLuqQf92Pi6yH958VjH2BNo=;
 b=Bl9YLNzfxnuXSGvfqdEkBxnON9xWTSyAiFjLFvUhDeqtcHPYOc9zcMyfRUzNviiVfPHxrtIyJC4aRgliq8DnHIBydIV0HZNDrQ0CxZ1RTCj/gF2/SL8hD6ID9ZjLBhxVPTshBEZNEkWVmMGZ5sx2APDsXLhccKcS0GbQG5ikBgrILV6MvNb6PGStTTWd/Hr+r2BZ6uMVJlvdRAFJ+B1vHdYMbt1AGnI8clqPLSpvPeWFP9Lc59JsUfPeKQVE+iuTN+b5UeBEqjrkruYNkHzsHhGW2g+sUsXRGXjhxIQgXbIMvTIHEENOh/wM13f2/uyZVCK4cDJrrKc+BoaOkv/Vsg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB8966.namprd12.prod.outlook.com (2603:10b6:806:385::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 14:08:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 14:08:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usamaarif642@gmail.com>, Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, wangkefeng.wang@huawei.com, stable@vger.kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com, baohua@kernel.org,
 akpm@linux-foundation.org, david@redhat.com
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Date: Fri, 03 Oct 2025 10:08:37 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <1286D3DE-8F53-4B64-840F-A598B130DF13@nvidia.com>
In-Reply-To: <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
 <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:52c::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB8966:EE_
X-MS-Office365-Filtering-Correlation-Id: f3736f8b-69f3-4104-96bd-08de02865a8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PSyp0Ute8LaKU8QSb8ZizCqXGWUDcLlI5e4iVhoOyJqnA3D0kcp2B0Bn7JXe?=
 =?us-ascii?Q?zWGLqlDEXEs8ixWFZyTRHaNOgSn7g8V4fCvuT7y3k8MobDTLMid58BzEhi1S?=
 =?us-ascii?Q?nlwAsb8Ra07fzBSwNNRhirZrY14ZJU3dVdzSWdUunKQ3Ip5rl/A6+1D7vKPL?=
 =?us-ascii?Q?WQjUhIjFW4n8ov9HIeKTpcOLWX/lz7mzClqtOiW7rig+3hxAJs8rvhEgg1zW?=
 =?us-ascii?Q?lPwZZ1Npj1LqbZYXUg7fECxYKmnZPjR4QutN2v4YIgDs+oeSaZZMnREQwXPa?=
 =?us-ascii?Q?Us+b01sNqllYxbTORuUxy2ms4FsruYdirBNKT7DjwOmzJHXoZ8Pd3lz8ivba?=
 =?us-ascii?Q?cqu2fD4GjT9PrVOS1CsiJ4u4hS53P2s91eeqRC/55m3sqEOQD02jCgUJvT+A?=
 =?us-ascii?Q?JWG/MIgxmX5uy6qm11lzaC/r3A3Idr0MjSPGrcE3fil7FLn4g8ptSu7yYeeG?=
 =?us-ascii?Q?NnQPBp5YeX8pJ7lHmkdO/0Z2rwb1cjj70dxkoxbUBFkfmABb2Jus7NaX6N4l?=
 =?us-ascii?Q?iyv0oZ071NLFuEPDqiDCK0yBePmI7zFJV+GwQ2/+JGu/XOxedG3pBd2bTVsf?=
 =?us-ascii?Q?eMxVXSQX79FNyBGofqBUEW3BExVrPUM/8or+JuNlymiR03TAgIOqvHBqOp9f?=
 =?us-ascii?Q?vpG1IGUoxSQZ9JSdFQ1KrqeXw2XCvCcaAC/NdYcliVmdGYOE5ZlcQ535BvJ5?=
 =?us-ascii?Q?9jeuPtiVjq+IVFAVImVo/7h6C73gy3TtduQ/3QV3I7Xe4SnazMgeQTaMS5Fv?=
 =?us-ascii?Q?N6cpJj4DZkov6wOJg+shkNLshSrblDG+CJp8UAmuZgTNO6o98V4vUKd4dsWm?=
 =?us-ascii?Q?S1hUciN8vmNNUMvq3M/Z7p9DPgDndkpix7ITMwUgde5m5nBbAFjW+hIvm6YI?=
 =?us-ascii?Q?Iav9MaGTv1aGB0ULUAPO+ORvydoeCSjOnOuI1jHP8knplIP+fRtWp0mXyLOQ?=
 =?us-ascii?Q?bt6WGI993Fzt3pZIlbDY+MqzGJ4FFJ0mDzjTlmdohlkWZqHLsCFLblmn9Y5/?=
 =?us-ascii?Q?6j0DxK1g2IQY6cjn/M7t/JWgpF/UF+44nRa1T5FWD1Eo5QCJ2FPahAqy4EWh?=
 =?us-ascii?Q?y9aeQdLVzoQNa8A9gWwIIvMEmBH1BRnBq3sEVSTRzEKUmSuIRjqMyskIigO2?=
 =?us-ascii?Q?bzYArFOndDNgk3rHVeKL1OtbCOuStzFgXGb1cmeulYdA4T9zdfV6VDrdq3d4?=
 =?us-ascii?Q?rwK4hbXWnoskCSRrTqUM52mfSsq4h/jdvJtM92MZgPIX0BQrlpwD9qXDShTP?=
 =?us-ascii?Q?YktyDSmVS8ZVCa3Rx8XWnxNvKGfIbT3YubUVA/17npdIfdN4wtIaQAYSW57w?=
 =?us-ascii?Q?fWnyueAtTW8wkq/Y87s+TiH1XS8WXDGG5OSLEaGVj6iPMu/2HfhYFPifVfjJ?=
 =?us-ascii?Q?s5Gtph76PedgvKkblzRCYuV8+QUpw3WXfN2WvpmrqDuFpkeQV+QyFq5wjYUd?=
 =?us-ascii?Q?P4vuysu7XxFqRRMs8HRWViSVFaSRKZF8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fqdYwv0fD/+STlH/7zQJ6D06sljaCCin2akOe9T6c6X6i1Pc/KH4VR3t4Wym?=
 =?us-ascii?Q?UYZPKEILS/LqCzhDHX7+mImp9umHArZz3UweqtdGADZ21OFca0YuioFIJpLW?=
 =?us-ascii?Q?YSYxa9VFLUYOKdg37VkghHIIoGPmsnAWNyELyrRG0h0KpSFvyTkHwLIvHvKH?=
 =?us-ascii?Q?3k25WEdCHXpxKzqzZVw+2kJgPF4OyIkHTzsJJ7HRWOw2l/eOMixdYMsy7O9x?=
 =?us-ascii?Q?CVIJ44NOoSp7OvqQHAlnx9Gc9gH0a4bkYa8ESa3N9hOO3P4oirPn2gHq70w5?=
 =?us-ascii?Q?2VnA0wtCkEVg/7C0K60LMSSDwPyevWh6c/nR0P4z8891CfGWJy4IwxxG2lwL?=
 =?us-ascii?Q?uhIMpq9DVO9oqGN8VCxVTRtTRTEisWrRYKMnLLPcZAyfzlqItkEAbeviXoRu?=
 =?us-ascii?Q?AFjTtiTtvCgbaPDerW3pUGHn74Waue8wjssnkYh/AmkS70171ZSdQmG7LzXX?=
 =?us-ascii?Q?FzZQElgrAIjSQ8p5PNDq2BIfyU+n/0ROnYmYgnQgYTYDqk3S8BmJZYTlrz5o?=
 =?us-ascii?Q?qc49dbEmzzfTLGV4zOFEKLGGfwXgp+/0GFyvris4eEOzvBxW4KgGc5lK2FLP?=
 =?us-ascii?Q?vdsv5S9Ny8iJN7K+kexCBMAzYgBjWnTHZdt8OlLfFW290Q3HGJpw6Dg6Xvo3?=
 =?us-ascii?Q?ayn74/SHPxweSl921ry0Tyu6Hbti5jHjw38msRVM4PsXwFfbWvC4XFYjHOsw?=
 =?us-ascii?Q?xIa2LhOaooW9l8BEFvR7C3XkCVfiZ5PnavBdE+hUq+5xRH5b3jsuepS8FXvZ?=
 =?us-ascii?Q?h5oZpGQ6CeJZYsSrjBBGi5ZB4RkNj2CItM4VsGbozB23m2fxlZSypKYO4lJ/?=
 =?us-ascii?Q?4QJ0a0g4pQ/NDCDzErIzgGFfKYoz0cuy6ms7fQnkF29mbGlB4P+UUQW64Jf/?=
 =?us-ascii?Q?6F5hfMeTjRTRLj8Zqp+PyrVrCP6Haq+sbFwN6epI5teKe2DuV7qsbwj18m+M?=
 =?us-ascii?Q?LDhuLMxX5Q+ar39V4UhCvgBUZpKeEdgo6rZJsIVLdutBmIPSWILo/fvhrIKS?=
 =?us-ascii?Q?oRg77nQ0ze/PqNrYgzYGJSoxxHDQina8SgJbnKIOaoKHLgBec4eIHx+xdXww?=
 =?us-ascii?Q?Dw9NheZbi43DmR5ia3QsqGqMaEh4i1GmBApI1Dm01tl9meXhSqevtD0/pg6e?=
 =?us-ascii?Q?BHPEHZ1RJaweoppQTvuLqUh7Frk5HNEqqExBItzsyyBiroo4k36vfHb3FH1T?=
 =?us-ascii?Q?CV3YSvFemb6m7Tjvu2WE5iGdQoPhfRdJ/XFHy+l2sPKTRF6Tks3FzM6RNXvZ?=
 =?us-ascii?Q?4v6Z8deQ+RVUclh/kXhty2lEnl4+yX1kNMhksw0pDgohGWmfqHsocZUm6xhX?=
 =?us-ascii?Q?j8dz063T/9iDPgaNP9kFGEa/sOJBWB1Hl6m8ryX2t9UihbzjimHZZRgB18k3?=
 =?us-ascii?Q?2PPvzL1+z+kRv9VibRlIJtpEfzGJfW8nUWm4gFGqWuOFV0y8rcOknLK8LLFj?=
 =?us-ascii?Q?XwTwTZFJyxF/7IH0/S9zzFTRXS6IkKeC+z00wr6ihfcaOZkzJhL9ng84qzSY?=
 =?us-ascii?Q?CabmPm7c4lcMKXFj1IGjUn3ghlahdLidjOIxQepoHdYV8SdoCXuN1HGk/9Ig?=
 =?us-ascii?Q?WHecrOCQlbABkoxfj3hfH/0fDK5lI6VAS/ufhFZr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3736f8b-69f3-4104-96bd-08de02865a8d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 14:08:40.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2aHp2dyCTucmsrBqnHoqRkn4v1i9hg9HVnOm0Jta8D+YpC247V5uItQ95bXJwl6O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8966
X-Rspamd-Queue-Id: 1EB44180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: injdskzsiuh4e4m9e67xxz4crc6nttfn
X-HE-Tag: 1759500527-568712
X-HE-Meta: U2FsdGVkX1++2lt1pSngiy7/hm2F140sFx5HAvWBz2F/fINouUNcJ7OsHqE/mHx7cxVp2JiC1p0wgmkGUhD/ul9zSWo/zvLPWO6CvttMbxPf8eWxA4n1xJw5Mf00wvNDXc4lmJolKBDrWysiNYyusosAZC35g/hHgk4wTZ7Zzatq+gYPC22JxnrR4YngpG00eDbCawmxNAo+WLpN44YiOYrzFfwpVPOm71M5KJaOoQcmLj1apZTu4BZHPeC1y8yOiMAYtEx9rMzhqjvESkG1G2bdoXoEvZdFpd7U2XjZwmsI3s/PmtBwiojBfBOylU6dU46IEsKUSkYWgVLfSJpc1ll5D5qrE6YPGegXtSrlmZxYsooQuFoxsZlQjTooj4KepUT96sp/6soV9hgLqd/8QSspd2ZqJtTGqLXUYHXpuDmAFIgVnfo9/V40efPAKj9fgO6f0AzMZU3sWvDjioCfmbHBTZQZzconuL9jo0Lp7clswJlSoPy2Jzz6URCGwIKKM43Oy8JIjVyUdFX0Y9BBScP2aYe0sZtR4j8lpmqU0RF3/8vV5JWr9G98OGRmPOats03Jfz1aqpSCicSQzNizu3190D5/NLyrqXerxn0rxQvzYi9EgjpNs7J6xm3CDuTYuXToz3qnXn3iEZnHRdi/USYZuQ6gKiyaXYiojLROEY2U+6x4Buz2Xg459zEZZfHPuUzRM96uGVicmNrR4+vpnyEX2i8XxyQ11Kgmc04Ao/eXUiiSwqoVuHCpEst0/dxHC7WnxoOHjPBfvdZ5Bs1f0fbJCf1lgCEHYn1gDfFXIBIBcGPPJx1VpmynZLFtw/4hPsxcyhsNMbP9jC+KG+WCLo4WHPp46nt5jnloScY1qhl9xZvv5wQ6Q7k2/x8ZIeAFtWgU43XS7O6WpbyWy8vv69R+AO3cmTrIOxXFz9XHtMcKSrx3FGbNswHznDVJbpJHV/PzKDn8qNWIf7HiST5
 ku95V0tt
 7B6uJJ0b32Wkpi6bGIAqvw/KXO8N4vcCy+3AvkNVIkCYwhRTvnG+k8u1zlCH68iW0heFMZP5XuVnxdfrB+7R/xJVzlPsLRtk4pW+d+6h02jbugoXO+Ikw9qZt2XFQ5W3ORQ9T4b3z5ZNNf6SMbKOBQNhK2mnw9Fx/AX2UHx97+xukLS8ynMo8sthTgOWQIP7bqLvCI0mj25Oietmcxjgs9+aMRkUTiiL9WRKEDR22yyps0G4m1CNgriXJx605MgJ++cBmy4XUAjdLt8Ly8bJiUhlBuhXjaynpJAfU+3R+Tv3vPLXb9FXo+ioL4hIHdohzH7O4MgoAYfpcrmUBeXe2gei6zw+fafKTYXsMqdaQYHe3YaGId8Z9zJLYEukHOd2UQo0/i+DhVOQI6TSO5dg2Cw513zibjt2r1R42cI7u+DTjfAFwn9Blbv/CsVB1KsxkVTzvjgP4Pz+xCdrptEBa4WqhdfYMuOdtzT7qDXquWGNH7D2u52YfxbGT01FdJNCeagoMobYzlM4NDotk9lLDy9lfpRp8GaUOwOuh+Bp25ZJas/3KfZoBNueDv+mq/ca36eJU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Oct 2025, at 9:49, Lance Yang wrote:

> Hey Wei,
>
> On 2025/10/2 09:38, Wei Yang wrote:
>> We add pmd folio into ds_queue on the first page fault in
>> __do_huge_pmd_anonymous_page(), so that we can split it in case of
>> memory pressure. This should be the same for a pmd folio during wp
>> page fault.
>>
>> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss=

>> to add it to ds_queue, which means system may not reclaim enough memor=
y
>
> IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
> started unconditionally adding all new anon THPs to _deferred_list :)
>
>> in case of memory pressure even the pmd folio is under used.
>>
>> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
>> folio installation consistent.
>>
>> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
>
> Shouldn't this rather be the following?
>
> Fixes: dafff3f4c850 ("mm: split underused THPs")

Yes, I agree. In this case, this patch looks more like an optimization
for split underused THPs.

One observation on this change is that right after zero pmd wp, the
deferred split queue could be scanned, the newly added pmd folio will
split since it is all zero except one subpage. This means we probably
should allocate a base folio for zero pmd wp and map the rest to zero
page at the beginning if split underused THP is enabled to avoid
this long trip. The downside is that user app cannot get a pmd folio
if it is intended to write data into the entire folio.

Usama might be able to give some insight here.


>
> Thanks,
> Lance
>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lance Yang <lance.yang@linux.dev>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: <stable@vger.kernel.org>
>>
>> ---
>> v2:
>>    * add fix, cc stable and put description about the flow of current
>>      code
>>    * move deferred_split_folio() into map_anon_folio_pmd()
>> ---
>>   mm/huge_memory.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 1b81680b4225..f13de93637bf 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1232,6 +1232,7 @@ static void map_anon_folio_pmd(struct folio *fol=
io, pmd_t *pmd,
>>   	count_vm_event(THP_FAULT_ALLOC);
>>   	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>>   	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
>> +	deferred_split_folio(folio, false);
>>   }
>>    static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf=
)
>> @@ -1272,7 +1273,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page(s=
truct vm_fault *vmf)
>>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>>   		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
>>   		mm_inc_nr_ptes(vma->vm_mm);
>> -		deferred_split_folio(folio, false);
>>   		spin_unlock(vmf->ptl);
>>   	}
>>


Best Regards,
Yan, Zi

