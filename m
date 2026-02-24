Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993B0F4BB62
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A086B0088; Tue, 24 Feb 2026 12:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD796B0089; Tue, 24 Feb 2026 12:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94AB6B008A; Tue, 24 Feb 2026 12:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1E886B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:29:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C3A81B600E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:29:26 +0000 (UTC)
X-FDA: 84480036732.05.CE7F2C8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf27.hostedemail.com (Postfix) with ESMTP id 722B540014
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:29:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tS9snNrO;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771954163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWHqRp0fiECdQRqnQo+JCa2QPlVg/9AHOGsMNx59+0k=;
	b=0ET3x/y0iwEOC0yUcEwuUy/xZShWaEybilGNV+xUUExOiWq6ODSsbbzuIbagC1XLu5MnL1
	TbMjuJsLwsTv7SuE71xR9kZyiCo0incGwafo+/P5QNwiSNMX1uMKHEPmFNq/KB5g2uXYTU
	czOE6ubFtvDecJQslxArZdl5KwJte7s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771954163; a=rsa-sha256;
	cv=pass;
	b=R8kebvYaHTel3i51W1vFwshJ3igZQ+sAhICNNDKX8Bu1AJrkpBwXrQHJc1R3af4eeLHoWK
	yj8Q8tSnUqk5RoU+0uZO9SAP4xCi9Dr8702Gx4yO+rOpFmTiIHswS/tgYEGNGoWqpWe88z
	TwEtq66T8Y7z1IQGvZsc5EDTI0XZAc4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=tS9snNrO;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lrrqcBsQcawLmlJ323OFT7tX+WsDlyqFVfak/CSxt0Maax11x/RcLkBC00hEo/nU8aD2IuTzgHO3P7P/XsBON7igECEMjI4awfhwslalnoE6vdrpOSDWYGLd05LQoHpbwpyTDasbrP68ur7y+klz00RPzUmqHMhaFEeDVXoMvEqKVwcSbGGAqb2c0CddTwqoUj0+3//N0VTSJDOS8n9eRjMBh39hmPwLMfIlsnqZXHosd1SJX0SywnV1z2xHws6senpSn0D6BtOPSs/a5VIXBHfEPfTjtAr9k/PCkeAjs569HCuvqS+UDk+sA1XAD4wBJvDRfKMaNRvJY5Rz0J00nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hWHqRp0fiECdQRqnQo+JCa2QPlVg/9AHOGsMNx59+0k=;
 b=Mxk1jaQKH8bMPnGlitnGGKG5SXuTvkYu6FwUbBi8FqI52oZLLOjIZz/y66dH/GIRhcDd7RwFtZRc0ZURnsnLmZhCjMSy7DueASeVBPJZPcKbMi4RwMb9Fd9DSA5BHjich3EGjWg9kYFh5OET3Ro2BShf0hnst/DBOoo/MYdtFLWIHc+IWMDLihm+wkYA0kpRNoBsdhUlZFOiZK6TDjTSNoTGeNhdTPArjGXEqHeAq+idCgZLoME2ISDsGISLrwnpsUa/CwFlvwoy0E410qH+TrsgK7i64VjGX3Uxufj8ulnMSDeIK25jXocOjY2PjH0uaPiN2UEyaxZKC3e85JGDMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hWHqRp0fiECdQRqnQo+JCa2QPlVg/9AHOGsMNx59+0k=;
 b=tS9snNrOKnpaw0dC+qL9ztbQCTqms93vgje95IhlONZ09s71std/LOJJfU3p0f7MR1SX/qAHanYT/d3UvtNUrcb4yQ1OloOZTr+zVcqQwKkpb91K4VHrTpZ8YLIJ0ITNn6rxtR2arX9qrxuO996xDeUCLcSB0Ct2cpav9BdaAHAp3vtcOHeYXf1kew6X+VrhGyzHYQrTm5xGakKu1VZI5rxzoiv80AOgfH3hAGxVRXd9EaZ7rX+YT3r1KatfAnb757LLzVyly+dBDv529M9snZr1/KpGp890wnkb1uiI3FM49NjoWvrpwARxQ8wLSMvVbWvz2CZGNj4zSRHkC1Rr3w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6646.namprd12.prod.outlook.com (2603:10b6:930:41::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.22; Tue, 24 Feb 2026 17:29:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 17:29:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ron Economos <re@w6rz.net>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 jackmanb@google.com, jane.chu@oracle.com, hannes@cmpxchg.org,
 willy@infradead.org, muchun.song@linux.dev, osalvador@suse.de,
 sidhartha.kumar@oracle.com, vbabka@suse.cz, claudiu.beznea.uj@bp.renesas.com,
 Mark Brown <broonie@kernel.org>, akpm@linux-foundation.org, pjw@kernel.org
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
Date: Tue, 24 Feb 2026 12:29:13 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <272A58BA-445F-46F9-8DAB-D82E43D7771A@nvidia.com>
In-Reply-To: <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <13b8d60d-1209-4650-9fa5-982381c53512@kernel.org>
 <1966378802.577797.1771952827516@app.mailbox.org>
 <78D36EC1-2596-448A-A939-0A1AC7B3D1BC@nvidia.com>
 <1AB3E96B-F4CA-4B00-9078-2AC20A1A60DC@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: d24f77aa-4001-4a72-d1c5-08de73ca3db7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3hzQkx6L1c1eCt6dmgwQVcxNWlLSFhWRlk2a0FnR1lJYnJNM3hadlZWY1kr?=
 =?utf-8?B?ZDZ1K255OWNXenhmUWE3c3dqK3d5SlN1OEZUSVYzMzN1WURab3VRSWlSVU9R?=
 =?utf-8?B?V1pjbUJFZXliYjI4UnlqZXhLOWFQMVA5ZUVkYnZlRDQ4d0VEcEx0ZSt3YlAw?=
 =?utf-8?B?cGxWclJIYlBLWWMyQjBMWG5HTDlYeGNHanhuU1h5aVBJZ28rUDQ1WTFTUVZ6?=
 =?utf-8?B?WTNlUWR0bUtKcVR4UGt5YlJHQklrSThFQ1FjdXhvWngwTXRzOUJvK0wzMTFT?=
 =?utf-8?B?cThGN0JPc2hYVUh1ak5tYUdVZm83V01uV2YrVDY2Q1JpbzNuSlhnNTJOa1Rm?=
 =?utf-8?B?ZVRNZDdRWUlDN2FrTmszTHdMd0NmOFRsUzdxN0RnSjJDS0UwYWxaVEhxVy9D?=
 =?utf-8?B?Q25iUWorV01PWklacFNBQjh4WGMweTRhVzlZNGY1d1dmYThsc1hTc0VSemdh?=
 =?utf-8?B?bkRrNVpLcUNycEFLa0N4S0IrRWxWYnY1c3d3SnpSdzRPUERHUE1FOEc3QURr?=
 =?utf-8?B?T1BGVlk3dVJDUTIrV1pYM3p5V1gxNTdBck50bGxmUC9TTCs1V2ROWm1ld20v?=
 =?utf-8?B?Sk8wdlB4cXVlMldJSmxaNWV2MHZlNFY0UktnNWpGVkdnRHVYOUdxUjRmMjlw?=
 =?utf-8?B?a1dqYXpjWVNvdkFMdkZDVVdVSVJFS2FiSEtnQWRtNSt4dDk3WGIveXVXUEZa?=
 =?utf-8?B?dUJPeWZjcms1aVphVERxSUZVNlpYKzRNNWd6YmF6SnFyWDhJLzJaTms5ZkRV?=
 =?utf-8?B?MWxBN2Q1K3hQTDVIdWxDbnhBeHlYQVEvcmFqSHpHNm9TekxXT3h4VXNrMDJa?=
 =?utf-8?B?VVpaQnBocE51Sm1NQ1Ntdi9uZ1pPYkhZRUZOVStrcnZ4MWNKckxOQlhITERh?=
 =?utf-8?B?N1pBQldkSGVOVWZQcHN0SzAxZVFyenJ3aUpvck42aldCZUhjQnlYU0owS2J2?=
 =?utf-8?B?WnVsQ1grTXhSWVkxN1JweVI5cTRNVlVCdDNOY2QwUVBybzg3RERTK21ZSnFB?=
 =?utf-8?B?RU41c0haaXVoeE00M3o3VFUwUU9nNms1VlB1TU5wSUYvT0oyWFdhc3BSN1dJ?=
 =?utf-8?B?eTVzMFdaMWpWNWRVVmsySlZHVmF4d29qZ1l5R2tDWFViUTY1dkdRVWgxb1Vn?=
 =?utf-8?B?RE1wdUNlYmR6Sk83MUxkRXhnTWNUWGNIWVlaaTZ3STlXVC9oK1BuMkx2akk3?=
 =?utf-8?B?Sm44YTF6SnlaWEdHOW9IRTJKd1pUTzM2U2NvYThxR1Q1VzlVNnFpUUhTc3M4?=
 =?utf-8?B?OWpmNkJyV2pEM01DTCt4WXE0S1B2WmZFTzJtT0tWTHc5NmlGSGNYbU9TU2ds?=
 =?utf-8?B?cFh2czNLeTdxZzQ5QlNDdVhQcWpWZFNkUlRVZmo1NlhtdnRUVUtPUWV0TGVY?=
 =?utf-8?B?NnZFNENmZ3ZUbS9TWEVFMElUY2JkSXpQQmZNZUdDRGM5cEhLMDh2U2ZGSHJX?=
 =?utf-8?B?Mjl1VUtvM211NmxZNU5nQXhOMnJVOUlvem5TL1lGS0VqTmVZZFlKZUVjVTlj?=
 =?utf-8?B?U29xUlNzazlJY3BrclRGMVZIVXlVeWFScTdtUU9USkdYbTdUM2tyY1BiU1pF?=
 =?utf-8?B?T2pOeWxXdkl5aUVPQlVjT0IxNDd2MzJ1MzJqQ3BHTVp0L1ZpQlNHeVFzUzg2?=
 =?utf-8?B?NjJuZGwvVHNJUTFLc2ZYUGUvMXphcldUelZOYkg1ZDV0L0Z1cS9QZkN3cWRz?=
 =?utf-8?B?dGtvaHJTRHV4eE9ucUV4NU9PNm9GWmxDL2VVNEZ1YzhZc0xtSUZDcDBWaFZC?=
 =?utf-8?B?Uk1IRTd1MW5VSUFiQjdabXFSSjkyZ0oyZEVuUTRtZzJkclkvd3VpSkYwQy80?=
 =?utf-8?B?ZzlFR0tuNG9xZmZsZ1ZlSlAzdUVPZW50SnZ5Ulp5L2RJK1J0Y1JMR0Y1cUVE?=
 =?utf-8?B?cmsxWjd5WGpEUUNIWHhsTFlTNzZqaklGemxTRlNVdmNlVzhSMjIvcFlDcGxW?=
 =?utf-8?B?dzdQR01IMVBxeUpIVzlrRW1pYllwWVVqUXMzN3JpMFlYWTRPMU41ejU1Z0FS?=
 =?utf-8?B?YTR6V1gxcWJmZ3FMRENoRWpLZGJFdWszQnU2V1UyTzNmU3FPTDdZLzFIdWxH?=
 =?utf-8?B?YVQ1SDhOZzRuYmg4RGpzblRQSkI3aUdwQ2FKekNsSGovLzRYMkFobGdJYVNu?=
 =?utf-8?Q?svrc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Mk9BTVQxOUhuMGpFZ3RHTUVCWldGVGFCOGVZOUhOcWlTbVZqWFlHQ09BNVZq?=
 =?utf-8?B?RmxUaU1hcXpBSUYxYnZsWE9hNllGM1lyb3FmaXpqZ0V5UDBYNmdFZHhyeW4y?=
 =?utf-8?B?alQ5U3NKSVF3aFFYQkRIUE1iVzFNdlRsa2ZBcm15SlZuWXFybnRhQ3FzQk0v?=
 =?utf-8?B?dUVXSjdoUmhFMnhwYXJHSVdNejROWUdOQitXazJXeVd4bkdHbDc1NkprSStW?=
 =?utf-8?B?TjJyOUt5S1NVS0Y1RFJ5dkR1R3FkUEwxbW1ucFF0VGs5K2ZHRWs4REJMVm5Z?=
 =?utf-8?B?bkxQeE52QXFaMWpUd01BU3N1VVB4bG91d0tRWisxZ3NVZ0t0VmdsQVdRNStD?=
 =?utf-8?B?OWZLbk5lYmY2SHFQdndpNVRNVFJnaDVtNklFYTRHN2I0YkVmYkZUR2FFU0sv?=
 =?utf-8?B?VVhlU2hkcHVNeW03YXh6R0NucDJJVUxueVpzL1lrenkwVUs3Zm1GUEJuOVho?=
 =?utf-8?B?VXJBTXJXUTFYV2lTQmd0V2U2OTUyQmZtaEhmSXJ1a0JiYktyRjZ0VFgza0hn?=
 =?utf-8?B?VmR6a2hyN25pMHAvbXd0THJRQlZOMWRvZzNNUWt3bS9pUG51NENQUzZxRjl6?=
 =?utf-8?B?M090eWJGQlVRdkFsMnFNdVU1QjJPNjB4blYzNEFtdzNmalJnT0hUQlZMN3VJ?=
 =?utf-8?B?TXdsWFZKczRmN1FEUHpsZ3FEQ2wrbUhMdjFWVGtxeFhUOTg5UDFrRHJJVHRo?=
 =?utf-8?B?Y1JiRmFZOGxlTHlDU1R1NjFMSkhGWTUvZHdTOW5mK1B6VnZJYWtBTkpPbUgw?=
 =?utf-8?B?aHRCbW80UzdlVE1tMmg3TGx4N1lhaXVDTUxxSm9DZ2prZUxWbU5ta0dEWWt1?=
 =?utf-8?B?MVgveUNuODBkU1ZiejhmU0sraXBoTkYzb0VycWNHYkJaMnhYQlVsY2thTmU3?=
 =?utf-8?B?TVhSd2JQaWtTQ1RFYUUxMUw4NHdMSDdwejlBejFXdUtxcU9FSk9JbC9CVVo1?=
 =?utf-8?B?cGdJc1J6V0VvU3ZnMjJSUkM1bDRDY1BEYjFnTDd0Q0J2ekpBVjM4azZ0N2Fv?=
 =?utf-8?B?VnFVMVF0MU9HNmdzYmxDa2dGSEoyb2d5M2MvQ1M0RUFaWElaQW5WcjdaWklP?=
 =?utf-8?B?RUZWcU5MaDFSUnZ6RTBHTHRPZmlVT2d5SGExamV0OGdYMnRaSm5uaUM0N0Fo?=
 =?utf-8?B?Q1pncGtLak45RWsxdnVJRktQUmxpN2g0VXhEMy9mcjBpL3hRRVIxa3pObTh3?=
 =?utf-8?B?aWFZSUpmTkhCekx4RW5xYTFIT0NJYUVWWkFXSm5jY1BqM0lFcTdmaGVyMHlC?=
 =?utf-8?B?YTNYeTZPYldwOVhOYVdZRm1FdE9lL2lYOHZSek5aenlPWVJDalBPQmRHWUlU?=
 =?utf-8?B?M3RzQklxVk5ucC9vQXhkc0RaTzNkSUxqTDRsWmZPYWJxZkh5NVdqMmo3blhJ?=
 =?utf-8?B?aFNJSlhzWE15SjFNUkJiMStWZXMyK0ZLam82OHg4R1ExRS9zbGtaYzIvaHBQ?=
 =?utf-8?B?TWx5cisyMnh4c3REVjZYK1hOczdlQ3NEWmFoUEZzRk9DQ2plb1c5UjNLc1hm?=
 =?utf-8?B?VHhEWVBWbDJMNnM4VFJVSkl3ZjVtZ3pCcDl2S2ZKekdkOHhZVk5BSmt2bXht?=
 =?utf-8?B?VURhTlNTOWRsWnplY0YxNG1KaFZFaE9Gajc5RmpDMFJkaWkvNW9XQW44ME16?=
 =?utf-8?B?WU92eDhTWFl3M25PWEMvY3lydU84QkJjaWhCaVR0eGJXaFdRdW1aQlRyZXVS?=
 =?utf-8?B?MUlzdmNSNEttV3lrVFV6S2RXYWFkNUhMTUJNcDNaZkt2dVljaDR2QVBWUlhl?=
 =?utf-8?B?ank2TFlGU2dONGJzamZicDRyTGp2SVNTdjNiSFBPOHVseE5peDhoMXFyczB1?=
 =?utf-8?B?L2d0UzB5eCtrTW1rSFZ3Q0tOd0d2WWkxNVhsTyt0WFdmd2tLcFJzMjh6eVpy?=
 =?utf-8?B?NDdqNEgvbXNGY3ZsN2wveVRKa2tqaUVxemZjV2xkUnZWN1VDMjEwK3EvTFVC?=
 =?utf-8?B?Y05IV2YxV25rcTBvM2hCQ3lJbGc4dXhtaHdWQVF2dWxsVlZ3OWlpczlpM3Jj?=
 =?utf-8?B?QnAxdi8vajd2M2tNQTE3V0I1THJmYlBzYm45Ry95NXpUbkZBMnFtYzAzUm9Z?=
 =?utf-8?B?dzJ3NjNwZlBBbW9WWjA2dXVWRGIzOGxLZ1NTNlJyaUpYQzdjdXdLc3JFeVV0?=
 =?utf-8?B?czZkQUpYTTRxdCtqd3Y2aUNKVFQ1dHBZVzQxd2pVcTdVQ2pQWUF3NDVTL29B?=
 =?utf-8?B?MkYxWVlab3dCNGNtNWpkdVhzaURycU13K3dIMy9LR3ZsRjEwSGVVSUZwUCtr?=
 =?utf-8?B?VldpWVRkL3djSjNEWFFZejJhaC9GcTZMRms1RmxWUjNzK2lHUnFCdlBUMGk5?=
 =?utf-8?B?aXBjQ2hFY2tHM2R1dFM5VFNzdGlwUmpveEdIWFdiRkF6bUFhaDlEUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24f77aa-4001-4a72-d1c5-08de73ca3db7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 17:29:19.1230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5/cQ501SEZj0jY3W4bVHOK+/A8PMe60moCIrNgzKYJf/LZO4jo+HWmR0xtu9+O2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6646
X-Rspam-User: 
X-Stat-Signature: oxyznag7eqbkhduk5ndy76pyxcqymrf8
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 722B540014
X-HE-Tag: 1771954163-709324
X-HE-Meta: U2FsdGVkX1/bKQbXC5YUJxbfCSG8fT9C7H0v3qWwy6eQ8xgyieNHIU2U0DydFhg86CsLvV6MmJAsGtymHqkLUjtUzLI914j23JcXHDKxUhJmYZ70GRlLLvh73SJLJN+JoOSN9szhTScXOGBZKQd8TW773Q6BkYOpNWgn1LoDq06jYUByO6XSj9z2zl9wsR1oiHaq072MRUM0AjvOa4+gfcfx/jFVnsP9T7+UG+SqNhfrMFRHcHgZJsu3yAubPYlgRxVMVj8OkTY2Z1WnsT2Ll1/X7Z8Jddk0omO77Qd6M5c1uj/OAdKhhRLRbc0VmOVrZWiyj1vwwjSLzSjBukrdZUcYV395tD6kne3KEI6gRjAhuWtT/Hnow9kxfFUWBZA6sOXvg+/AGDeNgXnPDADYlwuSe0kXWAP+Xz97W/YQbQjFN/Yuaki1oulPfkQ7v8lr19V0u8ZdHQzBDWX3VUk2mP6OW7fisESwvN7m9bSd9qmnuiG+PhaigwV3k4Zi9kZQ+44hTBkggke5KzULDm4cVExxjeQbRTQLOdxL4TYHt55O2SlUXH3wrWoC8vGFCpx6bYOgezj7Qmd+gcPaL7S3kz0Kd4Le+MFDD3mPMOfVvYFoSwjQKLkHIWZCuZr/7mF6aYaHbXLnySSHx4c1C6j7NlDhbzDyu8jLxmYJiLlzzbuNR9fryNC+xKi6iTbjNV24pFyUwjxqksV9JnaZufOnZ5kRTeA9OelAkzHV+oa4Wl2YcCGXDL9CxnTNp+bxNse1knGrk5YAoUz6QtpYit3z/jHj91LaC0pATGSglow9W6gG8qyi4RBCSJKep6YiniwWHKo7yJ1pVMT04ikFiXvkTSAmLvL3Ilj32cJotBD4ctsiqph5sNVnb95SXWtlBrfoYQJXVJTfbkS4Qj0D/f3LhhpTPk1KdVp9xwVuzWyOh8hKEdQrcJcXRl/BOWBoKc3vzl+tCXEwUNJfUp/ppQP
 6i2E4lF8
 EDilsyIxkEc6RuEEquPaQe2D4Ws+rnYUpQ8HnqMxMzORQqJYxkg6WqzvTCuYkTCqz7k4VS0mciA8HD1ecTcnT7lsnWF7Zcxrc0c7ZAN737YtlnFULuFqBrstpRpD28xiOcPHh2xUsYxxGVCq6carCQAoHjOCn8QFpqCUItEBBmiQ6plA1+AcXXM9khmRwT8Nf4oIMzOC+w9qeRSBjITJCk9Z6xKuHdpORBF4rjjXQXGXZSD34egc0k+v13XtE3KIlmh3KUzRyASg7c3GuIiPreYOcV1Hco/cECqGX/PBUuBNfA66kXbNikle9or0pNkRDuBzmB+6a0N0mqeu5Fzwodcx0fP24xs7QdZE1+N4vOFUl6CDEC8OwkYbPNnW7YUBIRC5aAtX+OgzVJHWTjUSCEtK51HM96dCQQyRA4Pq6CU5P3+cWoGRXqpQUcoleH66d1fugD+oNnURi5sY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Feb 2026, at 12:17, Zi Yan wrote:

> On 24 Feb 2026, at 12:14, Zi Yan wrote:
>
>> On 24 Feb 2026, at 12:07, David Hildenbrand wrote:
>>
>>>> David Hildenbrand (Arm) <david@kernel.org> hat am 24.02.2026 12:00 CET=
 geschrieben:
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> On 2/24/26 09:37, Ron Economos wrote:
>>>>
>>>>> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
>>>>>
>>>>>
>>>>>
>>>>> [  OK  ] Reached target shutdown.target - System Shutdown.
>>>>>
>>>>> [  OK  ] Reached target final.target - Late Shutdown Services.
>>>>>
>>>>> [  OK  ] Finished systemd-reboot.service - System Reboot.
>>>>>
>>>>> [  OK  ] Reached target reboot.target - System Reboot.
>>>>>
>>>>> [  173.985249] BUG: Bad page state in process shutdown  pfn:f8850
>>>>>
>>>>> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000
>>>>>
>>>>> index:0x0 pfn:0xf8850
>>>>>
>>>>> [  173.985336] flags: 0xffff80000000000(node=3D0|zone=3D0|
>>>>>
>>>>> lastcpupid=3D0x1ffff) CMA
>>>>>
>>>>> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae8=
8
>>>>>
>>>>> 0000000000000000
>>>>>
>>>>> [  173.985386] raw: 0000000000000000 0000000000000000 00000001fffffff=
f
>>>>>
>>>>> 0000000000000000
>>>>>
>>>>> [  173.985403] page dumped because: nonzero _refcount
>>>>
>>>> So, we're freeing something from CMA in cma_release().
>>>>
>>>>
>>>>
>>>> In cma_release() we iterate all pages to decrement their refcount
>>>>
>>>>
>>>>
>>>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>>>>
>>>>
>>>>
>>>> I would expect that this would fire already if there is still a page
>>>>
>>>> referenced.
>>>>
>>>>
>>>>
>>>> Are you running with CONFIG_DEBUG_VM=3Dy ?
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> --
>>>>
>>>> Cheers,
>>>>
>>>>
>>>>
>>>> David
>>>
>>> Thinking again without my computer at hand =E2=80=A6 isn=E2=80=98t the =
call completely optimized out without CONFIG_DEBUG_VM?
>>>
>>>
>>>
>>> At least that=E2=80=99s what I remember.
>>
>> Right. Without CONFIG_DEBUG_VM=3Dy, VM_WARN_ON(!put_page_testzero(pfn_to=
_page(pfn)))
>> and is_check_pages_enabled(), which leads to free_page_is_bad()=E2=80=99=
s
>> =E2=80=9Cpage dumped because: nonzero _refcount=E2=80=9D, are disabled.
>>
>> It seems to me that someone else bump the page refcount between
>> VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn))) and free_page_is_bad().
>>
>
> Merging Ron=E2=80=99s reply from another thread[1]:
>
> =E2=80=9CSomething strange is going on. I enabled CONFIG_DEBUG_VM by itse=
lf and
> the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.=E2=80=9D
>
> Looks like something is racy, since it is reproducible reliably.
>
> [1] https://lore.kernel.org/all/30dd1efc-9bd9-4664-999e-610d181600f9@w6rz=
.net/

VM_WARN_ON() is BUILD_BUG_ON_INVALID() when CONFIG_DEBUG_VM is off. Only
the validity of the expression is checked and no code is generated.
So that put_page_testzero() becomes a NOP.

Hi Ron,

Can you check if the patch below fix the issue without CONFIG_DEBUG_VM?

diff --git a/mm/cma.c b/mm/cma.c
index 94b5da468a7d..96be62eb3713 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1020,8 +1020,11 @@ bool cma_release(struct cma *cma, const struct page =
*pages,
 		return false;

 	pfn =3D page_to_pfn(pages);
-	for (i =3D 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+	for (i =3D 0; i < count; i++, pfn++) {
+		int __maybe_unused ret =3D put_page_testzero(pfn_to_page(pfn));
+
+		VM_WARN_ON(!ret);
+	}

 	__cma_release_frozen(cma, cmr, pages, count);



Best Regards,
Yan, Zi

