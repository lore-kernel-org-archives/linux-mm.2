Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6886F436AB
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 14:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96CA6B0110; Fri, 17 Apr 2026 10:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E916B0111; Fri, 17 Apr 2026 10:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83996B0112; Fri, 17 Apr 2026 10:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4B576B0110
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:06:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4806EB69E9
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:06:45 +0000 (UTC)
X-FDA: 84668223570.19.42C0E01
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4283420009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:06:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uSDIWdXu;
	spf=pass (imf13.hostedemail.com: domain of acourbot@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776434802; a=rsa-sha256;
	cv=pass;
	b=MK2P9jHb9kV1xevk0yCC0Ao07GyQfe8Ir1lX7N4qMcpN4ASuZ8xeAfi5Y0LJDqUqMHRQNI
	q6JWzFuos78UMkDVgSQdvYZaaH0+bS+9WjwyPQ87iHJHycq1TSAojeHdUz7TNb9l1OXgjO
	j+M15JuKpoNMmZzy3ZqboesMwhTFWLw=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uSDIWdXu;
	spf=pass (imf13.hostedemail.com: domain of acourbot@nvidia.com designates 52.101.43.61 as permitted sender) smtp.mailfrom=acourbot@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776434802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCv4D0YH4Hq7riwYwZAGyNAJKip4CTcP7FY+Qeea7VM=;
	b=CVJebNgkCKZye9gOj8k9wlJgPfKoD/eZKBiXvdbDoF8j1TG3xigJY6wtO/rqEeuQIG5ipX
	bRpytzqCW80T234TImjdT02R3mTYMVnlquho/BLlNtfJebkB6NsQh9sN3gw+llPZ6itfjc
	RRXAx+N1P1WPxk93hzUQ5C/zWoX+WUk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DG8jYXGIdvTHt5BhTVCy48tSUpvjp1gGp/IPk6Dojos5LMeQAX/Va7RQ/ZBzkrSyH0RE4urKBDIgJa5z1HGaFsEfAZ9O1jEodJFRbjk+tVzNTL4Sfk+7p7vzBwn8mqFDzwesEDeAWQA2hs/qmsR3Mw3XCApFG3zM/bIR31KcVTWIwrEP82hjnCpY9awtVvntqWJeriqMpdlEBf3E4doUVm9IueOE87+ttAa3eCtq+7MSE/Sn0YSsOgn3KYfWHbNeSwVF5MJMLcRDSnTy5NPr2UrHwfPD8F/kXdh7FAZO73RivzhnHCfuNqVSvlrJWZ8UL+vHOPAXgAa/raR8o2/9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCv4D0YH4Hq7riwYwZAGyNAJKip4CTcP7FY+Qeea7VM=;
 b=ZWkO06o4+WnHULoWMp3XblckmxOczKzYt5WTdibcq2ws2NqMEbm6ME83Uf5TpKwDdr8VhbuViisXTdSuzIuYMzABzij0Pm9Ah03U61ouyNTAYxIlMKDutOgj1BsM8udJ3d6A+HIw6PCLUJPwmm+OUR2cNhBtjG8teitpMugkSC1XpmE5qO4d+wmxkLnMk4Be59XDbu7/6V7VNCAEvlFrWrFa/U5A+0gnoX6Y69PXxaY7Rec4LqqbEE8ZLcwipnxtAubaBItKJCG/9+5kEmpSh2fdQ7r43xAJPtLNJiHHtDt8gXTC53A4vGsH4PNYAUZq+s8ebTcb60Yf0TNwpVpLFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wCv4D0YH4Hq7riwYwZAGyNAJKip4CTcP7FY+Qeea7VM=;
 b=uSDIWdXu/+rSfm/TpL487Uwt8xJYyeHG5m07srR5FiSI+vhCLDDCfMjvVYZPUYspBcGzS5A2yH2mgCbuYiPd7hJtjza4TpgOiGvVxkLEeIFLgz2fZyvg+B7C7fQJPtvBdM3UmRg9BL5nElJk98YKMsMOa2aJAYUR2r8FzQud6JWx900W3BOtsxfrJ4DBmIHomBaLU29ROADNjgXNIrh6uv7uU/8PSAOAel7A6vjGHW+s1FMi4XSwIld52tKclYY9eHiB3h+8W7EI4g8LEebVWIHeK2UMZc4zwOtB/oDZ5k2S1/K0Psb2/AcWfHiY7Zsk89lCnRdg4smDH1yto8JrNg==
Received: from CH2PR12MB3990.namprd12.prod.outlook.com (2603:10b6:610:28::18)
 by SJ2PR12MB7821.namprd12.prod.outlook.com (2603:10b6:a03:4d2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 14:06:35 +0000
Received: from CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989]) by CH2PR12MB3990.namprd12.prod.outlook.com
 ([fe80::7de1:4fe5:8ead:5989%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:06:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 17 Apr 2026 23:06:30 +0900
Message-Id: <DHVHKSI90H02.143VLYN9JY4FZ@nvidia.com>
To: "Alvin Sun" <alvin.sun@linux.dev>
Cc: "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Tamir Duberstein" <tamird@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
From: "Alexandre Courbot" <acourbot@nvidia.com>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
 <DHV3SQ191564.3FMK513OJUMKV@nvidia.com>
 <cb3dd598-04f8-486c-ba6b-9965d93170a0@linux.dev>
In-Reply-To: <cb3dd598-04f8-486c-ba6b-9965d93170a0@linux.dev>
X-ClientProxiedBy: OS7PR01CA0055.jpnprd01.prod.outlook.com
 (2603:1096:604:254::12) To CH2PR12MB3990.namprd12.prod.outlook.com
 (2603:10b6:610:28::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB3990:EE_|SJ2PR12MB7821:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ae1762a-ddcc-404d-fb71-08de9c8a885b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	wXj+firHaI4Z9QnAMv6osNPTZndqLafl5umBEhk02ikByVpIoQYh8G2xV9Uin9y0oYSSZcQK8B92+2WijT9t4tPay3TlNTxNeK7lR3rOPPr3M2ybkBiNFjG7b7yWcYhGETy+7lVIEQTQmtbEbgWQDoTNfWHwTHLa06EkD8CmyzIDlMSEYpByztGc3fW/dfFeA2ENh02RWnu3iUoDOjYBFeVcFwqbLv2pAtYHfQq4YPOirkvao4mRxFZWjMzqYqXlY3gzi2D4A+vclr+gc0ZU61N5clSbOhbwL7CJ/zIYzjE6xlKeqtK/tg2DM7VIB66mIfTio3edMUygrd0ysrGN2R2Yj1TAdMPJQsONE4WaYVSHVTOt4CATsUiQDRZw/U+WCx+5TsjTzyMPA0b4qyF7foUHgnHCvssIG+6gGR5TQF24umtAtSqqZ6G62mBxwZsu9jkQ15MErgs5hiL2/7JOGkR1JByeohe48/NtGof1QC8dZdkKqZz4Opewdo1tQ6iESUFabspW+ehdHpPW705trVH4B6YDHruQIF2FR15i1bp/feN4lpYuFHkRI0MvXT4Q462KhrvHu31zLkN/y7icSPFFZ63Wq4fSUUQJ1+gXm030juo86oKh4sfsLuBJzeTK4vkwwgG5ixFw2a6SPo3Vx7Ynksrsxf0bzH5BjkCZnM3IyHpFDGPcXv+8C8Lsf1bLsVIsgJmpoL5cB9bfbcg13u9HkeKO9bbGCKaU6TtSJlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3990.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T09Sb3NJZzh5YjRCOUxLeUcvclgyV3ZGby9QNHYyU2YrVHl1Skg4TjhWby8z?=
 =?utf-8?B?dEVLZEIyZlV0NkpLUFBGVEdsZWRpUk4vUVJXbXZxbUFYMU1tS3dLdU5Wb3Ar?=
 =?utf-8?B?OGlvcC9kTXJOQk5TcGJQeDVSdXpFaVJxejNkdEpYZVgzeVRVd0FGMHlNc2l0?=
 =?utf-8?B?R0ZLQThKdUU4UzFhZVBqUmw0U0dBZXM4SEJpTk9idzc2OFYrMkVnbDhGZmFo?=
 =?utf-8?B?RWUyZUcwZjMyNDZmTTBkZUFaYVJEMUYvYjVmSDFINzJVRmx0SU5Ib2p1MGU2?=
 =?utf-8?B?UG9pcGhoVUJxR3NHcHQvSEVzSzU0dVNzV3l6L0l2YThFU3NTTnBzN2ViN0Vn?=
 =?utf-8?B?Zmc1UnYwc0RhL3RPeVFURTcyYWdKOXlDOHQ3dmlMM1VPRVJ1dVIyL0pxbm0v?=
 =?utf-8?B?STI1L2RudUpjMlo4QkhuTVZvSUNQMURvYzhzUUljOWdmS2RnMmNWQS9Gak1Q?=
 =?utf-8?B?KzZvTXhFMUJkd1pucWk0Umk3YkhaOWUyTHpBSk1oRTBZRmNnQVZBNmhzd25J?=
 =?utf-8?B?cVhhRFM0ZXdOZ1ZWeXQ4aFFaVlBIcHhseFRsNnN5MlBpSVFGQXc3Vy9EamhB?=
 =?utf-8?B?d3FFNVcxb3I0b09URVhzZlJCL1NVaEFoRG5DTnJ3VGtaQ2tjUURTajFKcldG?=
 =?utf-8?B?V20xMjJlM29nSjZhY0VISkxvL3BlV3FFM2h2djQ4US9pekN1cnk3REpUV3I2?=
 =?utf-8?B?Wlg2QVFvNkJORHNOeC9xSVpHaWlReXBHU2NZZ0xHbzJqSWg0OUkrL3kvVUFC?=
 =?utf-8?B?ekNhQzRsdWx1T21lRUJtUTV2SHo1MHEvZFdPTlpQWmdJeGIycmJ4MW9vSFdi?=
 =?utf-8?B?RmJ3TTlqTHJlVUZvbTNRVFcvb0dWYlFmNyt5bjhYWVVrVTBmOUNXNGZQRExU?=
 =?utf-8?B?VXU2T3VZRWl2M0NUbzh1Z1Z5a3dFTU16WHFTQndKOG5kZ3hueEdmOXZjaHB6?=
 =?utf-8?B?UjhGZTV0T3A5b1IzOGkyMUFrZmlNdlVOcGMzN21rMGR2NjFXaDl5dmZVVzN1?=
 =?utf-8?B?LzdpNzlpUDVuZWhsNndxdmM5c3VuZFVFeG1UTExHZkJUek1OV3ZlVWR4bkZF?=
 =?utf-8?B?akQvT1hUelVucHBEaEpSS3V5WkgwSDl2RmVKakhxSWZjZ0ZMcWo0R3lJdkZW?=
 =?utf-8?B?UjZWWFZRemltMzRRcmErZUNKd1labnB3aFcwNU0xQW9JK2JucjV2aFZmWXR0?=
 =?utf-8?B?RksyTCt5YTB4MWlDWWtzZTJrZHhIWUNGdUVqT0U2U3FVKy90Z1Q5LzllMFFN?=
 =?utf-8?B?UmY0U1BpSnRONFNrTWlWK0trQnMvWm4wZTNYZFREck5FbkVWR1U2Q3BUemZI?=
 =?utf-8?B?aGZuYUdMUFRyM1diUHBVTSswUDkvWUVzbHhxWTZWalhiK0pYS1VVaGtZY012?=
 =?utf-8?B?ajQxdzBVdHk3S1BaK3g1M2pEVlgzd05sSHV3VnU1bG1DVnMvVjBtUlZIMG94?=
 =?utf-8?B?WldRVk9HVnpPZ0FKdWZtTVFTc1FyRlR6aDRkWjBLVUJsNEw0MW80Z2V5eHh6?=
 =?utf-8?B?aXZ6aDdNOUwzS0VjSFV3RHNWSGxjdFhDUnJtOWYweU9HcFJDSnB1MTZ3L2c0?=
 =?utf-8?B?NHkvVDFPblErRDQxM2swVGs4TXVHVVZmdVZrSjR6bzlzUkZSOHRPYjQ1cFBU?=
 =?utf-8?B?Z0RqMEQzdlJiQmtkK1FFeHBKUnVRL0V4ZlB5cUl3MVhSUUVwR0lOMkt5cDJt?=
 =?utf-8?B?U3RGMGtMVEpsVnVyb0JpTlpCSzdEQW1idUZQNGtCK3FKdzBzMlZxR3dtU1FH?=
 =?utf-8?B?QWZXaU14MEhvOXlMQWU3bXlaUWo4NlJ3bTlmd3ZLbzdmWjRDRlJpOHpxZkg5?=
 =?utf-8?B?UStjS05oTHFMUFA3emhUNzhlL3JxczNkSUZTRTRZWE9ScWJUaUozeUlFSnRR?=
 =?utf-8?B?M2pNT3RqdnVTTnFxVzliK2NvUVR5WWdWVHZNWnhjRExFbkRzRFcrSUpMRlZU?=
 =?utf-8?B?Uy9kOC9IRUdJWmtyU0cxR1lTRTFSdlFpSEo4OHVPV1ZKS0gvYUhXZGpvdzgy?=
 =?utf-8?B?aWV0Y2lSbUdubXJ4TSsrWURKVU5tdXVMTktUVzZLdGtCVU1KQUljc2NOcWMz?=
 =?utf-8?B?d0Ryc3FDOW9MYXJ2d2F3RFdJQ2wyTmlGQXk1MHdwYlVRMkthbk9RNzdzTGFR?=
 =?utf-8?B?QWJqTHFINVFWRCtPRGtSVlBmRFZoRW9McnRhYkZMSWhRWUV6a3M3V3BWWkdO?=
 =?utf-8?B?U3hKWXZOU3dHLzI1TkMzTHVvYVlaQnhZN2ljNWgzQ3d0di9sOG9XU0hMVlM2?=
 =?utf-8?B?aXpJTXI5VzVSUitMdy9qNDVJVXNzTmFlL0pvd3Z2MnJFd2xBTkRxdENRc1I5?=
 =?utf-8?B?eVJEckp2cXJBNjdjREhhYjhXREQwNXRlZ25QVVNFWXZHZm9IcEhjSUNRN2px?=
 =?utf-8?Q?oCCyxostuWYDIulChwBi2bXAqrzKrjJKQuuGe5bTAjQ69?=
X-MS-Exchange-AntiSpam-MessageData-1: gtIJZG90gWjCdg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ae1762a-ddcc-404d-fb71-08de9c8a885b
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3990.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:06:34.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEfH+odvACS23qm7kf+ZgAPHcQnnTdo+6DdqxCJudkYoA2soCEkB5ZDZmI4K/zNn8vVDPQyLFQV2mGC/BoM0sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7821
X-Rspamd-Queue-Id: 4283420009
X-Stat-Signature: ezk3cs9qw9hk39i9b5baea6sfcq3paw4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776434802-372875
X-HE-Meta: U2FsdGVkX18vYo+Zli3yYfiBHysf2xx7FJYxeX7hpLZZKrh9eqYFp3yX8eA2Bcqyw9ZlNLhHKmeGkUSqlfYpi9HZBg70GHCKH/JeqqhNotUfI1qauY1r9Ssl5M04Xkm3NcybSGNPy2SYqvoS7zbw/5w9rgCeG55f0EhSGB7hr/4ddk26U4eU+2jm8/7V6douIw5JIjj7gytZwtlfxa2qN8jMs9Ou06U5N9DGRaT/cT/B3wx/kOAvQB9auGs0gALGUXJuV/l9VH2Bbg9PdcaAO+1Z1uEa1ujAIUD4mq0+hxQwM5Q7lJsluEeKg2+mC3aJYZRSFTZ1VlMt5eNud7CTDxoo75Uo8s+QSn4x0wANRDUFjNI82aU+QoXklSf0BbsijoVgYnu3pH/76QSIyzWN9hzjleoUSu3xZVldWVBTc2dwnAS1WZvEa1BWz7hepqcBaHwhKm5sAC4QhAG/0y9LfXV/QVaQb6CaIzY7oqDrxXtkxPQDtRBGDzmKoWR48SS3JKzIRyPgyociJ2q8OT6rc4Ojwhn70I8gu5MFpchM3gN7TUJX68Efr2y6RZYf2IAWrUhfhGoTmsJUAdjsRNUJKdCJSYs8Ga8cUe6BMpOAITAAW6yaON1luJSVDbW/SvkACvhva2NLCFzF6E1KMhDQcmcO8fvYREcxa61EVmc4Nu6/lFTu2xY3M95w823VLmyWdQ8jEsF6g+YMrdOKFfO7b3wKgrfyO6yLWNGARV4k7/DuqzQ7WqirlcF+/1oB5h7IWKTUek7EdtGlcR4Rl55Zh6S4XWmT6ai/5Bk6zuAW8bUnirPcW0EdI4js/bqvBYNV+vNLYWtFmotYB/QSkOw5gO4d8wdOUfzv8QN1kYAZR6aW8S+w9AOKh7Z5OT5Fe7AMy8zNW88IhYeCeOXCTAanhz+cAbgaVFjCIPyuYaEFOcx8gXbjRG7XXs9hn6nV6tmKxLNUWKU1Cif8DMwLlXu
 D/xpl8oF
 r0uT6Gdt36eXU/5UjFboIq4U39B09ldcjHLQn9pSjCZSj+0HmXNIHBqEujMtcoVdYyvLvBGEkcpB0MSQm7wq9sJ54EMF/qLeSwXujlddkqR6FMc4W0cIoKtbbTAL9K9koTAHB3hBFd/Qc2dgvP5HUZlt5ttYe8AhdcZCNzfTDz4c3wS/utxpFf5ILjMvjHnYYsMSi3vkG8XP76U7dj0+xrH8zdbc2avYsCee1mGZxqueVkJJy846cmqEEk9qgT9qpQ3Tuy619LjOz+xPY77z7K9QNF22MFn5Gx2mskuS9jSVBI9RrYfx1R02OzgfH+EPrNG9/T+aXA7jUWxr+Dp6fnNuD0PWvAwu2yrODnsD1hjAqAiND5pq/XHbfdwLojevZ6DmoF2DRKZ/d47hZ4koURBy0Lb1zP9d+JhGmYwJPEzChOIc9b3NmGE+glKYaga2DMAGWMC7Xg5ckcMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Apr 17, 2026 at 8:56 PM JST, Alvin Sun wrote:
>> Finally, maybe I missed something but the new value doesn't appear to be
>> used by this series?
> This patchset is a prerequisite for the Tyr ioctls patchset [2] that I'm
> currently developing, which hasn't been submitted to the list yet.

Why not have this patch in the series that actually makes use of it?
It's a bit confusing to see code merged without any clear user in the
same context.

