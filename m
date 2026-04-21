Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EABF8FA98
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E9C6B0005; Tue, 21 Apr 2026 11:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F626B0088; Tue, 21 Apr 2026 11:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417106B008A; Tue, 21 Apr 2026 11:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2E37C6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:54:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27EE91B9225
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:54:45 +0000 (UTC)
X-FDA: 84683010930.28.4D310D4
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021132.outbound.protection.outlook.com [52.101.95.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 373F9A0011
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:54:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="g//T598h";
	spf=pass (imf15.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.132 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776786882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bXP3ae7HJFDeavh+W/ZEX9o+8APAT8iCZlybxLQVUU=;
	b=mbdtfBVWfPh04HlP5fU5PNT+YKLUO9S/2Mqy6/7a5qmSNZYNlT4vjCcnbqjkx+8cYZEJTX
	Z5khukujA5SD/aXefQ820Hdtb5D+kggKN9ovbj3hK83l6lCjYITR6tQC14SACBUBerEk6B
	7uhjuc5LOyEbdrhJUj5sYwRfZfTqgKM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b="g//T598h";
	spf=pass (imf15.hostedemail.com: domain of gary@garyguo.net designates 52.101.95.132 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776786882; a=rsa-sha256;
	cv=pass;
	b=WoTJJxmbXdKOjdXEb3Eb48+syT4Egy8x+dlw3EVNMTNf0Bzx1v9OOcNpUuYJXKZDwpa6jn
	6g23ufPEfLprIYVl5X7rjt5ymQRh4TrtgKCXGg2H4xxXsYy8X9HJaSdMf9fszAKr+MiQt9
	h1CSZxnQhmyOFL3TFc4YhPIYwajADHk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMZu3G6rERE7Hq7qYzXcDPP+HuxeKAvioyGNX6bUQoLmeLCmwUAG2JhdPU9sSDgwbjXy3pS3BICFkeXoV+1h2L9sOwlv5pdynrwrx3V2HbAXkMYko4xVCF2fc5hqVEaeqJvaG35N9gQWOhWRunHFBjfrl+RETSd+M4eDk+k2Jkwh9MLpokqgX9vaYgLQAZ9+sQgwZhD9DfmKr17ipqaFDZg96OJXPUYYYlEpO6weQp+QPCWWFnPPC9ht22jjVDW1zgtbiCdpNUO7XpSYkBWKteY7QHsTrJhs5vo2pPhuO6zSfePUw5nkiS7oMvHZkChELZaEncmO/mBehBGcpGNBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bXP3ae7HJFDeavh+W/ZEX9o+8APAT8iCZlybxLQVUU=;
 b=By5cqK4ypQV27eB2OwirwgLswpOHfUwU4ueiQMJWrAMhygVwAzsvLEiV/d+g+E9ioQ9RjslFbiJbY4PGnUJZ8L0IHa6IX8BcBMpuw5LM7CKsoKRQ+s7aVB9jB34ioqOqghuY2cgSd+880RJOcao1NbLmpR6pD9cmfHfceWFPakH2y0J+HJzS+xD01I542ujbAq2RzFwkxqID4+LxUVmffDLpaFtNhP2k4yNK6goOSNy1hv1C+LCalKin6wzRywpFdJVtO6zDVA0FIXUX2ugsc0l6KPQ/1H6LBsJ0yLhNlYz0ZLEQB7bdn06xI1y00yZEWx5EScBi4cX4nf/bsajAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bXP3ae7HJFDeavh+W/ZEX9o+8APAT8iCZlybxLQVUU=;
 b=g//T598hGRGvSLsyPYoPx0VONspBWZ3xfzRYw4N9JWlUC3ZoILMuuIj9irHAVPrm89ZOe2mUhpXFqmNXGVULmbD/7ShtEgTH3KJw6Ulh1ebP7Ujc46VSq4pck6B8G6UCxJ10KdrXlJjGD/tq+RP53ME8gFNSY0BsFMMl0oR5gIs=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by LO0P265MB5405.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:22a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 15:54:37 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%4]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 15:54:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 21 Apr 2026 16:54:37 +0100
Message-Id: <DHYYDQWP4FZ7.3MK090FH4HWID@garyguo.net>
To: "Joel Fernandes" <joelagnelf@nvidia.com>,
 <linux-kernel@vger.kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Alice Ryhl" <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>
Cc: <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH RFC] rust: maple_tree: implement Send and Sync for
 MapleTree
From: "Gary Guo" <gary@garyguo.net>
X-Mailer: aerc 0.21.0
References: <20260420201040.1894760-1-joelagnelf@nvidia.com>
In-Reply-To: <20260420201040.1894760-1-joelagnelf@nvidia.com>
X-ClientProxiedBy: LO4P123CA0118.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::15) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|LO0P265MB5405:EE_
X-MS-Office365-Filtering-Correlation-Id: f61d34f4-a05a-4c82-077d-08de9fbe4a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9so6KBPioH5aO0Vj16dqIfGIF9x6IskzvY5haFsBC+F7y1H5gT/svXRISN2dBpQay5/2nGp9RBFNAj+Iuhjweer/oNOQCFUWMuF8oY0ev0yRqS8k+W9CpgcXvw0CPl2KjCHUQ1y8qiR4HcjbkJhJuLHcpoOXA/mCrVl7GJBmgsYFWzhTPFf+NbhXB6RGWCErfcjipKkLcK/l04Kdtoyco/BPVHdhZGK2imHmHMjC4W4MidOe7HtG8mrjYHztPxhqEdAUMXPFk1ADJSI/rZh6cwfXMcYCsYbJV2l991zoNvc5ovrKNhZKtbE251NwA7SarchVZYkHBwkCD3phMdk+kgk1rjl71zlKQktiPtvvNGoxdGgNAB9lF5GBozLXISeJp7BgQ7Xa0H7iDhJxEdHtSGaZT1IrSPXFaRWmbQ+U+IgGBC2M171hIOZ/A6Yf1kxh12D96pfjAAaGHVCHk7/fdTqoG0HKiliqjP53/8Cg34OjlSAzmsIcj9aXpnaPaXW4r1PeyUWhMNlSTyKN0gYPo/VZd/wZ4x7HlwOS4xoL0/CTRQ4kSt/hoLGu5nnitkOrWOKIAu8mkXmKu7RVKAeK3au8o6c0HEUIZ6syjbF7lTrT6G5/Kb/Jz3rbefioWblqr9NjPS1EMVvVh4c0MIkr72aTpwYRn+6VmyKfUKr/YMUK2mubtaiDiTzVRgYozvw5++dA798SGoZz3LizLRwl1hICuDj8OVmm+0kHMfyvLPOkeUqho2PPN91OUPVEyURTCsGQMxJKddywRMw79HNfbg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RDI2SmhOU3lNSEJxVGRUTjdOV1lPUWtKaVZWMW52UVBUVUtnQUROMFU5MlJX?=
 =?utf-8?B?dGtrcGRFeGtmTGxDOEVsRFo2bDFMUE5LQjVjYU5iSlAzemhiVGZCdDRLZk1x?=
 =?utf-8?B?UWEvcTBRUk40ZVlXODd2WEg1UStjZ0VLdFUyMUJHQUtWSFI0cHZveDM3UEhK?=
 =?utf-8?B?T1J0SzVhZE1xVmhudFlLUDJoT1lxMW92a2U5NzFZUEM2OUYyZzl4NC9iV3lz?=
 =?utf-8?B?am51ek9adDRZZW9tWjg1ZVdNUkZCTjIxeWtuZEd0SlArNWVTVjhPSXpoZ00y?=
 =?utf-8?B?a2RkbGp6bEdaN0lMMUVwaC9kMjM0bDZQMGRkZk4wY2hzQWduYkNDeEFUa2N4?=
 =?utf-8?B?cEZNSWVDazN4dytzZDdNZzRmQjgvV2VSUCtNc2g1QWNMZVN1K1dpV01uTFdM?=
 =?utf-8?B?U1dIZlNPeklmS1lKOWRIYmZjenFreVpJU0NIbHNFWHpwdzgybkh6MmNCaEFs?=
 =?utf-8?B?bkszR0VFTlVKVjN6cVVZSUkxWWVHTTFaY3dMTzRDd3MxUDliQmJzdWpCY2FB?=
 =?utf-8?B?Z0RKUUFuSEF0cndBQTRRd21ic2Znek5uQTQvbVJ1b25NSnBTNlo5NmdmZWps?=
 =?utf-8?B?ZDczUmxleUw5SzNyaDVlTTdLcG1GSk9uVzA0Q0VhTStnT1Q2a1lLbXdNbFQ5?=
 =?utf-8?B?RWdyTEtFMDZvR3BmeDJOc0lwR2xBNkJyLzBmUFRDR21YZXIvNVJuSkdnR1Ft?=
 =?utf-8?B?dHFtYkhDVmFibWdWT29ocjFOSnNQS3RvcGJ0SG9Ec2phOEVBTmN1QVNQakV6?=
 =?utf-8?B?U2ExaVJPQVVvQk9oMGdRMHllZnN4cVVVYUZuZTBYV0tVSkptNmFHVUU2ZmVX?=
 =?utf-8?B?d3hCeUgvRVpSVTNuU1dIUm9VM01MSlk3aEI3UVR4eGo2UFRhVGVldEppYmFM?=
 =?utf-8?B?MytDODN0SmtFRm1rdktjZGo0SExIRzJzQWNvc09uT2syQlFPS2pYdHpxTXp0?=
 =?utf-8?B?U3J5Qlh5ZGNnLzltK1A4bmhkcUJuMHhYZWtIWDkxZlc1NGdOSW1VdkJiekVz?=
 =?utf-8?B?TkdxaGF0a3VjYjR1RDBxMUpYNUJ0ekR3dXN5OUFzcW03bmpzb0MybEo0RmZO?=
 =?utf-8?B?ZGNlK2ZXelM2U1o1cmhVZllhZ0JQcFRPRnJzaHhyOGZyOHBGTE9CbGNHcUxu?=
 =?utf-8?B?NnpnWk9SWmJ1blpCNWRLRTRIa2xCTWVaSVhWUHpyS0NMRUFHSjh1U2NqTkpz?=
 =?utf-8?B?b0lVMGUxSnFReldqenJUZEVOdDZmNGF2eGtxOHdGQ3gxaU1NWW9FZTBHRUpI?=
 =?utf-8?B?cVlwTWxaUmV6WERwdzlhTTR3WGppY2pXV0tObEpQRy9OS0hwUFVqL1VNbGlp?=
 =?utf-8?B?ZTNDMzhMVzgvbko3L0lXWEtQRXozcjdPZWQ2YUtGVERrYjRnNmliVERJbkU1?=
 =?utf-8?B?bkptdnlNYnBwcWIzN3JZQXUxMnRxVEgxaGxlZTBiSU5BaWU3Z2NjdDZZbG9n?=
 =?utf-8?B?aW1RdTR5ME9rY3kzQmVPKzBudTduNGgyRkl1c21JVlFQRkQ1ck84RUpUeGlC?=
 =?utf-8?B?Q3BuVHlxeng4NWlDWW91dnVjd0lQYWxSb3dNYnF6MmN0RlNlTW9BVjlBclUv?=
 =?utf-8?B?S3R1eUo3RUlyQnk5VC9nckRkbStyWkowb1oyTlozblBQY2FZRjBlOHlPS1Y4?=
 =?utf-8?B?ZkR3RWt1Z1RhUWFTTnZKVjN2MzNiQUpFRzlIaU5DTWNIcUVscHFLdHI1SUVP?=
 =?utf-8?B?S2hUZDdSd2praXNoYnhOaVVaNmtVYlFPSVBDemZsS3BMUER0UEtIdStZYWNw?=
 =?utf-8?B?U05WQWNETExSMEg4UmFDRUxtUXdpa3pZTkpCaUMvOEdhcjBpMWhrZ1d3Wmgv?=
 =?utf-8?B?d2RlL0R2Wjhib3Q2NUhIWkE1SkdWN3B4Y1NZVDRHZ2RndFZockV3czZCNWk3?=
 =?utf-8?B?NkxDN1pEV2g4S3pmbUc4RDB6c3JhYS9UMXNIWFJuMFpJWmlkNXE5NFZCT01i?=
 =?utf-8?B?dlJtZkE3UnFoZ1VDREJ3Z0IyNFVhY0NnMVRsbjJKTjI0NFNkakJjYXhONjRp?=
 =?utf-8?B?S0hvVE5iTURpVjNkem1VM0tUYWVNRlFyVHUzdnEwQjg1K3NrZFkvSis2T1hD?=
 =?utf-8?B?Nk5jR3o4dDRVNjdQYVI3MDNBU2ZXRDBGdGF6b1ZrL2hkb1ZjNTNCazNlRm1o?=
 =?utf-8?B?RlkrUWxoWWlKYU1PdzhGRzlmeERvNUNNWWVYQjZnZ2YrS3pzRUFLdWpzRFdw?=
 =?utf-8?B?N3o2RVBXTjA5MGRvNVNlaWlwYlB6cktTcGJUNEsyalR0amM3M2dFeG82YXRh?=
 =?utf-8?B?bkl2UElSREgvdEViSy9GWkFrbzFqNWdQbGRJVFVGT1ZTQ1VhR2dieWc5T2cz?=
 =?utf-8?B?cXZheFlOR0pkMVZKU1RxZlJlVGpmR05VR1pHZzFaYTFQVWh4VFc2Zz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: f61d34f4-a05a-4c82-077d-08de9fbe4a6b
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 15:54:37.5108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEMFdmv7JIr2qj+jqVFCOmrzKQvFFB8elnpOh4qWF0AwICC/KM1aczEajv8E6rQK8xwfuLyvAjdwU6JKF6mlFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB5405
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 373F9A0011
X-Stat-Signature: 5q9jhoixqukrbfoht8ebbzytrw3tn5nk
X-Rspam-User: 
X-HE-Tag: 1776786881-628668
X-HE-Meta: U2FsdGVkX18tv0i6BqCCKcQIDIBg/KXpZwzW6y4WzuaDLSvCIy6obZLHJAr+xEFU3WeeG//9by4jJT2rqEEBYh8IwlmYeV0/EYW7E1ghjJiQWH1wZiRCG/+ZGuxTjt2R/wnR866jx0agc8VNwTg5k85BTETQ90CD13Z89ckcSC6oMZLEcUCZBh8zfeNjWJfMXA0HiyU551Qogksp8z4nKNcpWz15b1AY5JfdUCOoUzs0xqP+GM8w4GuGL389r9q2xKvdcrkpxe20m9hKuX4SfOiIacP7VVw6eAVLOqZtFEZcFRKw7e/jOZTUAnTMtTlKYzb1+UB8tV3ghw+p2R4n615ERRHMwZUakb/xzrOZyllgto7L1mkjLzTU07UNwtZNeIxbLPm3SUQ/lZMgV3LpfsYDcYsMOPT43YmFT2Zp9qlvUD9ERhEyVsXxzbqUvNbENouTQtQiVWb6tGXmrkMP2uQGrOq+Nlx9AklT+SWh8qLoiQqXI1CpJUGKst2w2+R/A33eE70VnaqQflN7rfcq9F8CScRC9UxC0SDds6vSttyvb3jvw/o/oU6FYL0ysNHMfi1nyLWt5mXeWt0RDYKIXfT2Fpe3xTgMW27nDS6n/RMDMrWOoA1wCN8TC+zXyrPvuByJRMdELpeWroyaOCjNx/rTFrb66zwWjE5zIWej7WecKBkkyaNvMXo8n1sdK3EF50HURX1YablpTnoseqfk+fs3kO1Sf9D4e08hg62+mmD3Cg2v7Le/oJ1f/DqrzsY04lk48ezsUqTVj00m0HSMIR1RdUAtHJ1sHSdDcLL3sov23SsOwA/ohg7Xv+iNZEdFRT6lKWfa14tqyTyw5jgx3dWxQbCOdUW3dnOU9YUIlL1d8eGQm8Kn1RgtoH+o4KUONZoiE7aIVjT0n/voaaHF6xrgdm83yqb2Xrgy5Yjin+d+p1L4t2FTqyXDnrJlwbjuHvs9NUBnXW8/F6y6p45
 2vkMAkJf
 iE3sqsWCfl5Nru+/jx9TiqFtkQmaX4iyk9iuVsdFVALJHP56PFxaJwOi++FhklZwfMLYm15hKrf2DA8NRIgGwDORfIwuSE80lngQDhI4Pf0S0WVKhHjo8ZiUIiSiBlVt0h8bp3kvmvlTYBkfTfl0QdVvio6xWAR/lSLhV0W/WPI7laaAahYWJ0cdTHkHl3yADr02w8tXmF/lmXqUE2bS+rf84ek/H+krUkjyTkL1JC16MgznvyrHkWH0jv5Wtqb3/AKAeAkb5zvBthtORJByYE3o5rwcFe7TLl4DkBhoGemIctOQLa3M3n538WE9pDTnbeUZhArgB6yw7HOa3+dJezI28vYKyTK64rC6B3p6jCGemihaB85PNNnabz8S2cAZnCAcOD9ubVpdD06O19zfyvwW9/PhEWHJuYOJ0igj2LR65GtCp032Ooqf3WVWb4Wnw+TZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Apr 20, 2026 at 9:10 PM BST, Joel Fernandes wrote:
> The C maple_tree struct contains a *mut c_void, which prevents Rust from
> auto-deriving Send/Sync.
>
> Following is an example error message when using MapleTree in nova-core's=
 Vmm.
>
> This propagates up causing NovaCore to fail the Send bound required by
> pci::Driver:
>
>   error[E0277]: `*mut c_void` cannot be sent between threads safely
>       --> drivers/gpu/nova-core/driver.rs:77:22
>        |
>   77   | impl pci::Driver for NovaCore {
>        |                      ^^^^^^^^ `*mut c_void` cannot be sent betwe=
en threads safely
>        |
>        =3D help: within `MapleTreeAlloc<()>`, the trait `Send` is not imp=
lemented for `*mut c_void`
>   note: required because it appears within the type `kernel::bindings::ma=
ple_tree`
>   note: required because it appears within the type `Opaque<kernel::bindi=
ngs::maple_tree>`
>   note: required because it appears within the type `MapleTree<()>`
>   note: required because it appears within the type `MapleTreeAlloc<()>`
>        =3D note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to imple=
ment `Send`
>   note: required because it appears within the type `core::pin::Pin<Box<M=
apleTreeAlloc<()>, Kmalloc>>`
>   note: required because it appears within the type `Vmm`
>   note: required because it appears within the type `BarUser`
>   note: required because it appears within the type `Gpu`
>   note: required because it appears within the type `NovaCore`
>   note: required by a bound in `kernel::pci::Driver`
>       --> rust/kernel/pci.rs:294:19
>
> Implement Send and Sync for MapleTree to fix this.
>
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
> ---
>  rust/kernel/maple_tree.rs | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index 265d6396a78a1..1ecf05871e710 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -16,7 +16,7 @@
>      alloc::Flags,
>      error::to_result,
>      prelude::*,
> -    types::{ForeignOwnable, Opaque},
> +    types::{ForeignOwnable, NotThreadSafe, Opaque},
>  };
> =20
>  /// A maple tree optimized for storing non-overlapping ranges.
> @@ -240,7 +240,10 @@ pub fn lock(&self) -> MapleGuard<'_, T> {
>          unsafe { bindings::spin_lock(self.ma_lock()) };
> =20
>          // INVARIANT: We just took the spinlock.
> -        MapleGuard(self)
> +        MapleGuard {
> +            tree: self,
> +            _not_send: NotThreadSafe,
> +        }
>      }
> =20
>      #[inline]
> @@ -302,19 +305,31 @@ fn drop(mut self: Pin<&mut Self>) {
>      }
>  }
> =20
> +// SAFETY: `MapleTree<T>` is `Send` iff `T` is `Send`.  All access to th=
e tree
> +// goes through the internal `ma_lock` spinlock or via `&mut MapleTree`.

I don't think this needs to mention about the internal `ma_lock`. The lock
sounds like it'll be relevant for `Sync` impl rather than `Send`. Even if
accesses are completely unsynchronized, it's still okay to implement `Send`=
,
just not `Sync`.

For owning containers I think usually you don't need to put too much
justifications, I think a statement similar to that of `Vec`'s is sufficien=
t.

    // SAFETY: `Vec` is `Send` if `T` is `Send` because `Vec` owns its elem=
ents.

> +unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}
> +// SAFETY: All shared access through `&MapleTree` either acquires `ma_lo=
ck`.

This isn't the full picture. You need to also explain why it's okay for
`MapleTree<T>` to be `Sync` when `T` is merely `Send`, essentially the reas=
ons
that `&MapleTree<T>` doesn't give user ability to have two `&T` that points=
 to
the same object across two threads.

> +unsafe impl<T: ForeignOwnable + Send> Sync for MapleTree<T> {}
> +
>  /// A reference to a [`MapleTree`] that owns the inner lock.
>  ///
>  /// # Invariants
>  ///
>  /// This guard owns the inner spinlock.
>  #[must_use =3D "if unused, the lock will be immediately unlocked"]
> -pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);
> +pub struct MapleGuard<'tree, T: ForeignOwnable> {
> +    tree: &'tree MapleTree<T>,
> +    // A held spinlock must be released on the same CPU that acquired it=
.
> +    // Prevent `MapleGuard` from auto-deriving `Send` because `&MapleTre=
e<T>`
> +    // is `Send` due to `MapleTree<T>` being `Sync`.

nit: I think you can leave out the "auto-deriving" part, you should be allo=
wed
to assume people reading this knows about `Send` and `Sync` are auto traits=
 :)

Just the first line is sufficient. (We probably want to be explicit about
not-thread-safe things even if compiler would get it correct from auto trai=
t
inference anyway.

Best,
Gary

> +    _not_send: NotThreadSafe,
> +}
> =20
>  impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {
>      #[inline]
>      fn drop(&mut self) {
>          // SAFETY: By the type invariants, we hold this spinlock.
> -        unsafe { bindings::spin_unlock(self.0.ma_lock()) };
> +        unsafe { bindings::spin_unlock(self.tree.ma_lock()) };
>      }
>  }
> =20
> @@ -323,7 +338,7 @@ impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {
>      pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, =
T> {
>          // SAFETY: The `MaState` borrows this `MapleGuard`, so it can al=
so borrow the `MapleGuard`s
>          // read/write permissions to the maple tree.
> -        unsafe { MaState::new_raw(self.0, first, end) }
> +        unsafe { MaState::new_raw(self.tree, first, end) }
>      }
> =20
>      /// Load the value at the given index.
> @@ -375,7 +390,7 @@ pub fn ma_state(&mut self, first: usize, end: usize) =
-> MaState<'_, T> {
>      #[inline]
>      pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
>          // SAFETY: `self.tree` contains a valid maple tree.
> -        let ret =3D unsafe { bindings::mtree_load(self.0.tree.get(), ind=
ex) };
> +        let ret =3D unsafe { bindings::mtree_load(self.tree.tree.get(), =
index) };
>          if ret.is_null() {
>              return None;
>          }


