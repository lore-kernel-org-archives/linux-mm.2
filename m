Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10665F5A8CE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 23:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411166B0088; Mon, 20 Apr 2026 19:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C14E6B0089; Mon, 20 Apr 2026 19:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B05D6B008A; Mon, 20 Apr 2026 19:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2426B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:42:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA2721B9175
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:42:37 +0000 (UTC)
X-FDA: 84680561154.02.1BA815F
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB591160008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:42:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a7R3JT51;
	spf=pass (imf08.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776728554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qnavOwErqJW//xCST5p2vfHkvP7a8SZEtGw7V2f7bk=;
	b=voRwUCQrCRDDXXgCJ7OnEjhY9PAhBfn8bqMli4F3Q0hZxnu/r/JBI0rY6Mtb2Xefqnigmd
	oROg7jZuSKxuoR7f1I5ZncaK7Qrw0k6ncKv0UoFveOCD1Jv8+9Z5FNn2uMnpr7W0XMdk5J
	XUjP7HuBW+1n8m9XkT15NLZGeJa1txY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a7R3JT51;
	spf=pass (imf08.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.201.45 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776728554; a=rsa-sha256;
	cv=pass;
	b=B5rHbtBw125PN4lvcp/cUKi+Z4gq37bUz+3qeh5sEve61wt23Q/BOSSdlMuZH6+aMI3mvy
	gz/JQ7yH667U+q7AlzHfLp1v5PF+ZM10yBuz82mP3rkGMs4gnHisTug6LeNWGl5yX/mzCu
	e7ruiw+XTzui+RZaFwi5BW9kAcW24nE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u2wLv8dqPS/iQL6AxlVPVxasBYSkw1IWGR01Yij0Bz3egCzDqgxFcwgQdiTqBb8UV/E5D2pY92K38mNyzR5Cnmm70Upe++rXicV2OjPiegvBX1N6g1YZ+Ru6llc6kyj6cruU2h50klDtPT1vru4Q32A54kRwB4pt3utdc5n3fljPRYls3Rq0mto+BXqkZSO0A2G4nprzbXE5tElrkKFGkxcY/wfVegbwXmQJomS06L0e7njZnb9P0UGQNXWpAaINea/Euq6f+KNzLyMh79yQNteLTgXXgFXE5xR9LTnfLT4bCxTBhMrH4MvGOanOzdUj48Y+1HFsmIsw9qUMWZbZGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qnavOwErqJW//xCST5p2vfHkvP7a8SZEtGw7V2f7bk=;
 b=wXyASbCEmeffM+Od6e0wsBI9djDYzJ6uA1IdH1DUgkGLU81nAUYPA+fZ2jhjt2RlIKx2Iocwe1+u7zl2z+LCjx5iSroNwQK1sXGhb5TO4gM5rmLtnhHELq8YDT3C4obUigrj1ZpSvwNeN5sDTM7OOlra+mvCHQI86AYi5Be0fiDJyAFIK8XNQvi9v34kanUQMwb67g9yXvlozbN1xhIpomRPT20tZ33/kMpd3YJ2M6lfbWPzIJaNVmu8vwygbn72AFGa3uO5Ba1wclNfpfzMD0msrpeeJRQkK9CE2JZAXVQq+m46ufQSVxQyeA9RO13LySc9Gg5+yM3JwXFckQMhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qnavOwErqJW//xCST5p2vfHkvP7a8SZEtGw7V2f7bk=;
 b=a7R3JT5133V8i+Q5n4VXbq3FvT6O4PtnFijjoscPviS60dS5gP+455ZS0Jks+8TDQZs9q+u5mfbwJYz6Ek6ySmFAJewTmrXyX5WgSM4ycQngUqpNpXW9vr/Fqme59PIvKjAbx07LO27exHZwkjJi191fV2cbfbS3Vm89H50ZbqzbA++fIYJuTr+Hsfe5CmfqFn3vg8/1FNcVWpy4ysyNgvWzbyaOwktVrbfaS0eLc6VIaTniy0QOFW0k29X9nioHw12pwPKbNFCM5Kk8l6Z21o+D/r9sHxiI2PtD4uftfsJuF4Iaeu0NwdcJ4zsfsSrmmTJsDlaXpXOpPoBtYPDnow==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 SJ0PR12MB7083.namprd12.prod.outlook.com (2603:10b6:a03:4ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.15; Mon, 20 Apr
 2026 23:42:29 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9846.011; Mon, 20 Apr 2026
 23:42:28 +0000
Message-ID: <19c86115-9e9b-4c81-94e4-5ef2524804f9@nvidia.com>
Date: Mon, 20 Apr 2026 19:42:25 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] rust: maple_tree: implement Send and Sync for
 MapleTree
To: Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-kernel@vger.kernel.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Alice Ryhl <aliceryhl@google.com>,
 Andrew Ballance <andrewjballance@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org
References: <20260420201040.1894760-1-joelagnelf@nvidia.com>
 <81F4369C-358A-40B5-81F9-24D84483D00B@collabora.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <81F4369C-358A-40B5-81F9-24D84483D00B@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::14) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|SJ0PR12MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce3f173-0005-4527-5592-08de9f367b16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HMrC8LK7BkhKOlZB+B9uXNHfkAYgF6Ndmr7jwnnzOH5qvtzJvwIcqVqxKZDAQXDVMyx7atiu4sYACEQ8QEl5iVksx0thJIRm4yJYZMi7j/TGXY6IuevmNiqK9x1bmO+yfuOe/QX80tzUc+s9dcZl7w2qt1v98u03Je1PTpkg9g09wciXeZvBd2QM1opls2Bx8SSQiwTsYOokbhTj6VcMMmxQHJXAx2FOraAuVAS/fmYvfpNWfMe031RN42Nd/tQK4sFOIGSqHyPt9w4iazQQC40eIpKVhFYRjeESN6+jd7zyPgQ/zenNR60VI6sGYQTWNcLRKssQSNLVHQryFNmB2RpoGUmTur5CX5uxnU7eCpJY6KT0OF1toHxJcAi2p2+Y95mNWN9Mj7usqvNoMXTII0x4OaEccXDgfQeDG8GwYNMOeUXjXCHHlEYDfZw+NWuLn1BxbYj4l9M4Yl8XK6OHoEdRdjVN7lI81KZJCqFyyRTc9I2lbG+hU82R7AY66LHJ0ligp/tYEsj6Tua+WZDfLcY8OalnMMGcxqNVWOs7OKg4qYo7mOEAp3YIrj6gk+QZ4t6rbpp1yOvOJS/7qbYpjDXG5oBn/fsKeA2YSWontPBHlsa/Piq8ncPJgHWxvNndhVVJ3Og+kB7GDPCsUvnb/XN4b4RwCMfiebXk839Z2d7JEHQOtisJGJAZ7/TIQgxC2tMlWft5Ne1f+L3h4GcjK+Ze0bWSBZNYDE77q/+b8h8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDNnL2p3SVNlYzBnWEVTVG5NaGRUNUxhbG1mYXNuSzhvQVZZcVNCaURuVlJx?=
 =?utf-8?B?QVRWNXYxcVlxZGJCQkFKNXRKZ3IwQ09GWXZGWEx0YkJybngzN0xvQWNCTG4y?=
 =?utf-8?B?SDVTUUFXQkdScDkxd2YxOTVkTi9XUXBMdEI5NExBejQ5VDh3a3hVaXVjcnVT?=
 =?utf-8?B?RDVvUm9PcysvaWVWNy9lWThxcWVDa0NmNERCRFpNM2FXR1hRbndwWjdpNSto?=
 =?utf-8?B?ZVM2NXUzeHNBR0JRejNDWVBORkUrOTJCSjMzblNvbWdCbDhWN29GYWFrVjls?=
 =?utf-8?B?bTd0aXp3eVJQakhlekk0UjJNOFpFcVFvME5sWS9FeVdRYXozdG1oek0rcWJk?=
 =?utf-8?B?OE9jaG4wMTNwcHhkV0FNRmx3dFN0UXh5R1JKVWhSZW5UVG1RdEFnRGVrYXMx?=
 =?utf-8?B?R2VHK1BJRG5IUCtYUWxpLytIRVM1d0pnMVozLzJaV2o0Nmd5UC9peCsyQS9K?=
 =?utf-8?B?YzY1SWh5Y1VHSHlpSnR0TERKN2FPbG43a2pnTENiVk4waENwYVBLbkxjckJ1?=
 =?utf-8?B?YnM1WE1wNzA2OWFxRndScWdQMHRYOGpSVmV5VTFVK3ZibjZXT2NOS1hIMVFU?=
 =?utf-8?B?WXVrYUhrY1g0WlZ1WUpScXlGUDhZTmQxNEVNeVVQYWlNZEFpc1EzbFNmaWw0?=
 =?utf-8?B?TlpiOUh4aXc2cEFzdzlWemxmUmwreUh2U3dpeUtvV1hJck9uODd0QVJVYVV4?=
 =?utf-8?B?OXluSGhSeUV3Q0ZmUjZKWmFSMjRYU0JQVVkzOGh3ZDFTM01mRXNZWUhXaUZB?=
 =?utf-8?B?WFJVT21nNFlkMUIxWUo0T3V5WVIxRnVjUlJGVHN3Z2tVWVkzRENUM3A4T0Jh?=
 =?utf-8?B?MURrdFdCVDhnYUJlaDdjR3E5a3NoNjRJblFEaHhRQlZRcTNGK3FxbXYxOXpa?=
 =?utf-8?B?MlhkYlVUZ081Zy94eVYxRHRpWUsyRzVOSGxzS3AwenVIeFU5MXFKMWVKeUtO?=
 =?utf-8?B?WXNpeGkzL3dZS0JWUjNSVUVoMGswaTNzamlzTWZzTjRkaGlaaElRL1Z6Y08z?=
 =?utf-8?B?bVk0ZXRFY1pVaE5CaVY5ZHJ6N254Wm9sNVl4S3ZEYVZWTUxHQnVUSWZqckI4?=
 =?utf-8?B?YXM2d2R5ajVKTEMyYzZ3RU8rN0RWaG1lVlZqcVNzUW1XTHFFOXN1NXREY2x0?=
 =?utf-8?B?TzVHclJQc3RtWHNTd1E5Nlc0SFBSUmZlZVQ3ZW1RdVNFUVhwMHExTXV5OER0?=
 =?utf-8?B?N0IxVTdQUlVXOGZiWFlXOFRkRlNQbyt3cnNiVkpCTjNKMzF1MGc3bkdBbWJj?=
 =?utf-8?B?M1VGWklXeDVabzBob0kwZDdjWHo2NmEyTUEzcGhOZ3hwRHhiV3Y5SHhqZnE2?=
 =?utf-8?B?MmNKT1Brb3BRajNKTWhhV2lXY2dYaW8xZDFuOWovVVZrY0V5VmdvTVczdmMr?=
 =?utf-8?B?bnl4M085OC9QWFpyc2pBUFdVNnlYeUtydElZZlpqMkdDWkwyYWlrbjFzTXJH?=
 =?utf-8?B?Z1FRNGZSSEJTSUs3K3J1ajU1SHREVDFRZHp1dnRMUGZSb0lzb0FOeWJBN3Fi?=
 =?utf-8?B?ZVkxZWphZ2ZodW9ndVd0RTNnY080QTVJNWsyTWY2dWJFSTlhSDVad0REKzg5?=
 =?utf-8?B?elplbTkxaVBuL2xIRGM0NGhicWdkTHdGOWVaNHVsd2xtZnYvOE5zQndua0Fx?=
 =?utf-8?B?dGViNm9NTUNzK1FZYklKNlFEaWxneC9aOFhrcWxpZmZnUmNqcEpwd3FUZWZr?=
 =?utf-8?B?djNyV0d2WjdWYUVHTmcyL1NuUkxzTjNhWXZMQnBkcTMweENhMmI2ZHhNdHFl?=
 =?utf-8?B?T1ZJbDhDQkkvTllMb1Vodkcva0JIa3pNckVGdi9Yd1BaYTZpTE5PSnBhSFk0?=
 =?utf-8?B?Q2VBMm9BdUNYUC9rbjhZMlhTdkxWRnh6WS9CNkVnbFdCcjQvZW4rblA4azVN?=
 =?utf-8?B?YzJRR01XRTVkVDlRU1BPUmRHa3ZmcGR3U1hxeW45UjhpRTJpQUFUQnJ4V1N1?=
 =?utf-8?B?YXovdE8xbDREZzlTRjBUR2UzN1pQTGNJVDFUTktGc1l3WkhlajJvZTN5WDV2?=
 =?utf-8?B?YmZyNlBIeGc0dFZsUWFwTmN6VUdabm1CR2gyZGtCRnJDdkloU1k1bnc3VUZV?=
 =?utf-8?B?eGNQYXFXWkVzWmVuMHNFWXo5QjJnc2VWalFCV3l1U0FTK0QwRFo3aWtQNUdj?=
 =?utf-8?B?QXpqZW1mL3BhS3pjeUdaa3lMSUdsbytZb29yOUFjZk85K2dhRHFZQlBZZXcw?=
 =?utf-8?B?ODdVZFlRcS9UbmlRbkNLZEJiL1ZGNTdiTnUwbXVoRjJBQ0lRa0R1R2I2RVZX?=
 =?utf-8?B?bVJEZ2ZmVDEyamc2OGxURE54aVgzTHNuYXpXdStWSmVQNk92OHdtQlFOM1Bm?=
 =?utf-8?B?cC9KODZkTUxvZ2tvMG1tOC9saTUzWlk0blVEZ1FxeFJXRmUvdEFxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce3f173-0005-4527-5592-08de9f367b16
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2026 23:42:28.0291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCBmeHLKiiomKQE50r9vbnlIQ9eP4FlWoHrazq8Ov4xOTgOAEN0AnZNisrFOfR9ow14v5rehENBXdfEaz9CRzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7083
X-Stat-Signature: toyggdnffem66ouiqrxqfbj3g8sukz1b
X-Rspamd-Queue-Id: CB591160008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776728554-29192
X-HE-Meta: U2FsdGVkX1/T1PTWBgDGPxjCMzv4Kyq/H1tH2Ux8T4RwzzsLZJqXs8BserFzRe+TIoDO5K2UWUo4Y54QnuxdhWHI8Cd7DrxJ6IfiyLmI/vl2fG3+mnuqehEkXu5fsdxoL4YWqqegXaZNLTk5bLqx1sehvUwNtP0tO7hYLlAZ91g8mti2xDbQLIgkuIwmwuLmruihBhZOqln98BTYWBhjdKvCsTTfIfgXb10QV5rNv+ecmKs8IhzMKAkPzuEa0YauI5dTYtLwJXZ14z0yXE/ZrkJkD5gUq9O+gm/41nQImrMoESpyN+Np7fAWBNSiShFPQJDfomw4V4AhTE61BnSPI/D2LHW4wklrsA6VwucbSbJaAOi6Y6x6QAo2lutw/FJnQcpc6ivvZBPsqjXxDMBW0gGOjdimTLk6OkvzDPT9AJ+6pYDrCsUXilPHpe2wJgFNtfrn2e/MMsW2I8ruGuqniE8f3dkpXSLZ/jgu/ggfeDYdj/CntKQeAY8PakDWm2fcNQvPqaW1/XW2t4ZxxiR4JOiMVnv6G5AZfYdbsW3GCwFqDlBP++bIG4yav6bFNpMrzfIjymTy1D2EiC/CVld8S0W/fAhHU529/5NU35bLDpUCwsvpVBi2hbtqoF3rcJrBD3pNNLK3rAJa2v/8taK9qkuMMyJ8dXJdvvQNXGvcYnfFaLqAIK5SrGDOMhv9UCKWqU1Jv0TcrzK8VA54zhhxqs3agjvt5rEkXsnNpMUfyCDIla9BhZNt6AKntiXasKG9re1asYA2/KMstpdJsBXrWUnaor+KuXkULEdcxVSqvCYqUmzr1Yg3rNEs3zzYHckfaloY7FlByy7LzE2xWQchu6qp3yJZ87YUhVQSqBpwAQscqbNGTOZRcVxgoIxDJu8lYkMPGfpEAJSyNJF7EjQjqgV8syPm0AqCmjWCM3hrS4/1rTOjohAMbgPc/d+gvXi77af1gnekdQcGSjWUQeJ
 bgVsItlI
 iuq/wCZHZtZd7y2mpq5jCH1RsFvE+DxXO8nqH1Jj28J9g6yI2W8qVTiwbo8VCw1vt5b6J5lpBNsytEozQCq8+rNuC7qAMjo7f7eYxbnvwVieMRczjQmupjanxM7TmTamhjNnrxqIFJZ+IBd4Ye5WJA4j285Y3sVVQ+QjMwsPGQPCvUkiuZOT0gA+8mK24D9CI8bUv7AaFfmCsgA8dw9yAdy2Kph0hSwobxMMJgZ8yBEWS/XS5mT6csGE7IgrKZdyANeOoasWgmKGqfc9HTuXVKiLFo7UfrohsjedNLpfRq/6TeklfVWubUXFf0em9KxbeSSQAgZ3/ci4eXrsTTDqq75OhWaVg/wcjD6hv0oZ1ZhBnHoAuE6rMNAwIXg+gvC4nR0uL18xq3EwHj6OiAXjhEdSAQj/wI0Oan3rge1bD4+SLkwkg27h9MqYK935fjoR/ZPNZZAEQbqwHxUgT238GeUzEv4UhchpR1A4fwW38UQ07B17znycergQ41I7QMda8ptCR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/20/2026 6:00 PM, Daniel Almeida wrote:
> Hi Joel,
> 
> I think there are others in a better position to review this than me, 
> however, while reading this patch, I noticed this:
>>
>>     #[inline]
>> @@ -302,19 +305,31 @@ fn drop(mut self: Pin<&mut Self>) {
>>     }
>> }
>>
>> +// SAFETY: `MapleTree<T>` is `Send` iff `T` is `Send`.  All access to the tree
>> +// goes through the internal `ma_lock` spinlock or via `&mut MapleTree`.
>> +unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
>> +// SAFETY: All shared access through `&MapleTree` either acquires `ma_lock`.
> 
> ^ Missing something here? Either … or? 
> 
Yes, it should be either acquires `ma_lock` or uses &mut. I will adjust it.

thanks,

--
Joel Fernandes


