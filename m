Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF502D5B169
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 00:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A3C6B0005; Sat, 13 Dec 2025 19:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875366B0007; Sat, 13 Dec 2025 19:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760156B0008; Sat, 13 Dec 2025 19:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD506B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 19:51:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA02B60968
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 00:51:33 +0000 (UTC)
X-FDA: 84216248466.28.8AA4F8C
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012067.outbound.protection.outlook.com [52.101.53.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5ECF1A0015
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 00:51:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CMPKzA97;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765673491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V5YduJG1IxdIWARpTchHNx4XWik22mAYe2CE452e1y4=;
	b=g5a7Iy9AaEjrzpAN9BGv2Oqc9Dy5HMgZicDbmAI8irbkbZSQnw+onUScb4zCElIfCH4S41
	aubqmjFgOnydJlkvnwDnT680Pt4ZBB4kaHoZDMKnFCKQyexuFBlQvXj01btOvZklgZVxci
	bAKkX9ieuamggKkO/e3cMSdhtcqJIIY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CMPKzA97;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 52.101.53.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765673491; a=rsa-sha256;
	cv=pass;
	b=qbEkuFj4UTHKSVQxPgLaA+bvoWYHPqP+eXrQMZW1smTyXgYpVdqVTDNpCw2uD9S5wOBbsB
	FPZnD9HkD+unl9AH1f5tP4eecaO3AhIxheE3F3VjHLtvdOIC6SEvCl0lUlhpRFx9lSP7se
	29kIba9cGG6s1vAsKRbjdozFliodY3I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bIHP/nyR5gbNvbCuJGHHnTciHui1lXc8SjVCnYoR5bdeQOVlgLLCtdxrARz1Q9Ntwtj95iTfHEDqnWpWhN0ruKI3SqYfmdEo6I/ZGPojrYW17kLmo83BZIpKdzONEzsXfWjT1xt1QbtBCx9hgtAJkV7lPkfHxq5/fiBBHLkdy1PeGe0OKNyuXG3lZX6vOdcgJCcQUtYxo7Z5GBFsRBedV2/tPfEvvoJ8cs59Scu8EncESSScJXnMljr9HNTuX0XC01SpKYkGD05NPvQE9iFpeW/qD9Mk2crawiFmcZf3QD04sIZHADrRAq0xPa7+n8lV31h43c2czKM/GLNfb09xsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V5YduJG1IxdIWARpTchHNx4XWik22mAYe2CE452e1y4=;
 b=RS9LXASIQ9o0AdBo3g5fQRW8yaJFdLTuc21npaWkSFS8E9iPPKjp3MnnfdfKqJhWmsoi5TL3I+AL99rdvjpY6m5o1hZD/c3GXqUSOtQ5Hu+4cN33h/7wIaD4TPa2HpDxIOtrO5JIBxtYKnN0O1zGNNcx0S4X62IOY++wUKGoitsMvFWhEXS4/QoGcOobQRiOAPV2yCHiJOlvkEHOJYtolLKUiOpnbN7+/ImsEm/r8NSXq91IWAdlzLxXYizqeQ4hwRj12ohDfaJSru6SXsGIW6eYC5ouXYg0xLT00sCxiNReQDfeMOg5WVy42eD8o4o1cOo3ZEi41H3Mecm98hdlmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5YduJG1IxdIWARpTchHNx4XWik22mAYe2CE452e1y4=;
 b=CMPKzA97/85Ou3oHv7NbXgW0rFIvUd4v0D8f//bov/Icev2rztTNn+DBsqI5lGJwnXzmAsaNypZ9k2iC4BIa5zuOA6OFRl/wp+3oYlCp32iGCi6glrjhRYCZzaLh+nxe2U76iSNOoXK+jiO2eB7Vv44f0QD+pvu0Z2NWxinRGp90pdgzjZPbqfkp8jzIxR5U/eRxpQYpT48flpqvBLnqe2x39y5u0pLI7BaaOSH7QrzL+3kmRaqjT1lC7n2enTBtA1qkRBLj0CtAPUwlXG4APh249juimB2CaJh3hJE88r8pyttdx/U/irW7eZsOnW2SeKsBJ5prZn5byVzC07rHdg==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Sun, 14 Dec
 2025 00:51:27 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Sun, 14 Dec 2025
 00:51:27 +0000
Date: Sat, 13 Dec 2025 20:51:25 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Will Deacon <will@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Asahi Lina <lina+kernel@asahilina.net>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	iommu@lists.linux.dev, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v3] io: add io_pgtable abstraction
Message-ID: <aT4KDZSWLMlKwusl@nvidia.com>
References: <20251112-io-pgtable-v3-1-b00c2e6b951a@google.com>
 <20251128180255.GA836877@nvidia.com>
 <20251212094427.2ec0b31e@fedora>
 <aTveh8c3RngvnIMp@nvidia.com>
 <20251212104105.6af97d05@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212104105.6af97d05@fedora>
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: 06593c58-7b46-4da2-aeff-08de3aaae9ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X8/9ucG1VwZm+500sykBQMuN1rmFKPVGVQMQT1wkNriln0HCSIoF4PrIs0iO?=
 =?us-ascii?Q?Jz1KL7DNI+gIHJI8DxTXTzO3RNp1T6Tvh+COtybik8KnioHDGVQHVjItqqZ8?=
 =?us-ascii?Q?uiBahjrMEEDyRxVQ41RKnNeHv4J5jrM/GRsKHdk35UgsgrHdDoTXrnC08ByG?=
 =?us-ascii?Q?VXnXr5XXj6fxvr4s3Y7QXaWqs3MbUJbP6v8LjKdIIZV1/zBlj1t1oLloqJaQ?=
 =?us-ascii?Q?J9ep98Ivi30DazXisQhKtEugywwNqUFMOAZWR1y9Iuzt5VEYmGEmSaaTjmT/?=
 =?us-ascii?Q?h9kP7MllFVXj/r1vtHqCQtGYvLCGvOtsKnovOLMfKE7M/G3YYPBO75SxQRQj?=
 =?us-ascii?Q?5E2BsP8jHg1dpepaPCx3hmM5D4vCdJHKy2ZbwWwajMt6lYnWe8mUUFSo2GH1?=
 =?us-ascii?Q?ESOl6PK3Xbpv9oNWvV2LKY66cFnwlIFjL3FYCHFSSciJt5jSD+k7bs3UnKaC?=
 =?us-ascii?Q?AIG3ilFHuHsNOZOv9SNygYBWTMBsYBDJmYdIWhnPK4bV0ZlwmavCkWyWiv6u?=
 =?us-ascii?Q?C/PyAzqy4VnwdGOUNd2u0sWtCuHg6Llc7SohJNPHY99C+uTpxzzF/5OJs73M?=
 =?us-ascii?Q?u/9i5HiAGhXlus5S2rUniNqfRQ9D2TLGZAeSUijkYXdUCTGZzvjSpkvMGOEt?=
 =?us-ascii?Q?MX7wVWb8OQFaOZ+O8VFqmSJpiwl5Zu8R9+Glft2YIGrJ7Qx/yylhiP/7hh+T?=
 =?us-ascii?Q?Tr//jqVgbY5oN4PDQemqndd0ieoNHrddkybEMUvYNo4ozUoKJ2bjZ/m30aN+?=
 =?us-ascii?Q?ex6aPqo6wO7p4Z+ssA/1bXcAPdStghSbOrvVYQgKrvZmwKWmv1RCzAZM5U4Z?=
 =?us-ascii?Q?Dyu8pjd4h5JqqS5hlbKHBiaF7DISRVvcmxwCaHXmUC4ea8Ip87szN6VdlL6T?=
 =?us-ascii?Q?aST1ryaKqtu/zbX7QU9IvHV3SqJutP/EKH0mpPos/BCIjJ204MAmiRDM+9lZ?=
 =?us-ascii?Q?wjOxfYJnAm5J8Q2b0eqYJQqVD2WukmFsDO5QF7KIgrlm9UjPllTkq28Uqby0?=
 =?us-ascii?Q?XycPofcNJgCstB4yhdhd/87DOxRkrAQ7utaRcpEu96yPi7ATPs9dF/XKKUbN?=
 =?us-ascii?Q?Hgp9wR8ks8CZy7MXlePFGFL5KPYQy2QtaN67i2dubJQSJEhJxg2rJzNx/BCv?=
 =?us-ascii?Q?yiYxA+RgiU1ywhtFZwb0ONanj7zuTCCrEZMxamvutnimpSDHEEPdQI9Mh3qd?=
 =?us-ascii?Q?ykmaxm8J4kvtsCpdSNZ9RmlOk2z/IGF5ZwjzpA3uGJizpzZByZd0LeOQv91B?=
 =?us-ascii?Q?lKsvCl8zrasa+wG4SUzPgfG7XD0Dx25s4chYRhacyGyzSgd1rav8eH4tCpiE?=
 =?us-ascii?Q?a54hicMW5iEQ4GwmoT/9OqMJlOjds9nChD+AIGOkVdqHCmbNGuRygDZU6byR?=
 =?us-ascii?Q?Qzken7xIrbRznh6PVihb/7bpFzkzgTSAw57Wvm2KMN/t0wgp0sNPEyRrRkwj?=
 =?us-ascii?Q?k3L3PME+dQzrcx3qp8pfsflkKWNzzPbG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xFPko/JrSeWMqgSNsMoCIYGgq093fT8KlTK7FzxzG3MrRbJDReazHXFgx6oV?=
 =?us-ascii?Q?V234NXXktJZeFw2lMw55Xw/+3eSsflshbUZExHlOJkNy5tXMW3NNddT7SHw1?=
 =?us-ascii?Q?1hOooLXG7iWh8yVVqa2q/xKbp/HUiW7AVDDW9hINuZdymx4wGe12TjLsq/Jv?=
 =?us-ascii?Q?vMt4JeRIGRujbxfTvsCEpVzKVrcMr7xVziN06x5JI0u9rkLVAgAIM6mq5ZC2?=
 =?us-ascii?Q?b1E57gvCEPC8KTE2fAs2x+aBhfIEQfnTEYsobP8At2f4RvCbtdP4KD/W7Eps?=
 =?us-ascii?Q?Bw2on2hcQ5p45ddtL0zg9eXVBxyU8vC6T7rUi1yUIrhKEXKkTh1Rp+9o0Fgj?=
 =?us-ascii?Q?JCO18w8CRFsf1fH83rGo13jXAPLIXpXTFslmEfzubmW53wwKv5Gow6QOWehS?=
 =?us-ascii?Q?ZyYlvnPPRBSHJ2dfXgefv+A1EwIIvpRBXhXWIDzUempKdZ+cL4HKAyLaPqt2?=
 =?us-ascii?Q?LHp38j7K/pGsZMDi7aBOtMDXU1Gk+XLzWPRKEC3XaOS7imUwYDwrZrcz0/CO?=
 =?us-ascii?Q?k/s3O+I2Q+tQFn3x+LPgTmDt7HfCXatUW+MJ45+0SLWxutF7U6THYl3aSwAK?=
 =?us-ascii?Q?PJz5HNj6POtayxd74bnoO7cn8+5nv8C0rLoZkRVZfx2SHot/usxKX3nFY4xH?=
 =?us-ascii?Q?1xqH6oKJhxcNLKKRw8WWsaMmNwuUbCwyKqGpGNiAKlnplEyxM+rsmelucdVy?=
 =?us-ascii?Q?xd7DQPSj33nwZmjfkOwmyve4ZLWRRHuNoGPVgUhyiBPUiLLWBTmGqakkK/Pc?=
 =?us-ascii?Q?E0NRhjYW4BXKRloq0PY9+MjDcxtAYwp1j2f6mNI5lxzqnt7l1DgsY/t0ugQw?=
 =?us-ascii?Q?A+6nkfUZL9dX6qD8JjiEyvEw2QQtSbAAOIpbhT5ggJhyQ9TV5VsaFBemmrPi?=
 =?us-ascii?Q?IV7vbve9CFzHkwAgOKhTIJb7DGjcGV6lsVw3NtvWtpaj+MvnU6Ys0AXMkvX6?=
 =?us-ascii?Q?2OX5NZx3MvWxkMd1YpXXcdN13FFUt9IzOy6b8R8FZpeXb0vwxZ5mVWGncHWH?=
 =?us-ascii?Q?GvOXEbstfCeCwgMJ64/Rh7bXEbnv7iRyaVyOaLMPQ4opksaTTc6j4sx6rD0g?=
 =?us-ascii?Q?9qiw2W6sC2ZlKnlV7XOwHqFlv662NjN7ySLMAg1p8IqkawXRnCnhELzH0I7w?=
 =?us-ascii?Q?IDPdPUXzVhbTeY9fiyJT9j7OUYZB5M+EDMCD8mOIt5Gt8F01fu1wpzA4fS1/?=
 =?us-ascii?Q?lEuurgHpMDajfu7WYPUEHvMVp9mAIoTNQZYg2lPK+7FFGYX8xa8JtHmPsRpg?=
 =?us-ascii?Q?vwmee7NaqJeXjfnWYGZJLJ+dwntyL7WaLZ99DScJMZLbFicV9uECZ1KF/EHO?=
 =?us-ascii?Q?TOJa7ywLoGjE1f3YaFl+HibDy9c6Owur+6sACx8hQ/UQ67Wfi3/stKNYnYvb?=
 =?us-ascii?Q?FsHDPrKOV41KFM0BaUkJkUdtu/EXEPaog1tHrTsAmQvOJsbfY2L/CgVtoWBo?=
 =?us-ascii?Q?OSO+2nM2r8ke7Y0XnDARRWi/qeTnqZ4O/mes0d4zbHDJwyvZn8aiONwgqqn2?=
 =?us-ascii?Q?9WSUcLIVXzytJDzExY8vuANwjrevrRBTooewZfkINeru0rIaApExkDRgO6sa?=
 =?us-ascii?Q?9Rqu9UbZZYwSPmjVeuQWZucTRrPWcyyclvrQpX2E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06593c58-7b46-4da2-aeff-08de3aaae9ca
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2025 00:51:27.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 82nhS1MCPwcr+xvxbYpdOPOrZPzawCFtnGAnbBO35ffExHCutpQc11rBv6Ey1yVK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5ECF1A0015
X-Stat-Signature: ofsand6krm3kpt9xku9k8nggtxmt3qwi
X-Rspam-User: 
X-HE-Tag: 1765673490-211238
X-HE-Meta: U2FsdGVkX1/IJfMPyy6PlKULgNi3D9STQNqYWlJGxPbgNLYFf8fWh3YohLn0VlQjQHtXQ4byYp/m7gwFi1g5x9FroNugvJjQKTuRYHIwsQzBz3PVBknKosYXGjlHx/24j3RBYXtLUuTils+V+k5Pv2xbEQt1yniWpaFLAWnWowQplH5Y+z9EDjKtlfLjrwQZfVn6CdsDw6uyxAqGV2s4RegRTim3BaHW2VNchC9EisLO7kK0Cvnm8aCuRGSPBWCOxMlXjiNBoY4000MyGaMCI+0XH80EhISNKn0gqyE2IA10cqxHNzTyOpArmVEDpi8JIAQi8VgNNy/ONb7TTiyoxQonMEAmyJ/nxEV6uWz2vU48Rn68oR57/L+ldWwqx83WrMC3rTjEOXd8mQ7WAbuUaoDOfkQm1LKTiVB+w5vTmksDG1wgBbyBHhSLDea2elmps/IVv4jaONX+eZxx5aPS4d6Tir9kc1O73eIugD0rXvmomgBXnCxj2zDbw1krUB2i9DQaJ6MgRXl12T+JlUt/BfbSt1lJgPN1/KbyL6WXQEiJFEIdud+QI0ldmUfYqr7eEp2nQ4qv/Sdsjx5IyvF8Ifw6QWZSw31uaJ0b7QrVWOriR2+IlU9ALULs+sUispvIsBsNULpqXD53eACoPCSCPEV8JvdGlFdpZ0PR3Vl1fA8LrOeJLYTS7QEjTve23VaC9xW4gWh3MqGNUHE1T7VdlrFzm0KDEHMBy8hdIjnlNw9mPyXVuIdAVjzFgD5Syeu4iEy99pn8Y5pQMJRYLr3kASL6WX0mgnT1ck2/lJrUfEyD28Q0ZaATjOi8GXqNdMy1RLqc+fAd0FmbuVJ38un6znTIyeSZlhPWrrg5tkfPqfiM6bw6IuslWZQgsLIV/Sm7qeQpHgbmDuta0eDD1T60G7/Y4NwpIUgL9vFaJLVbmIYnODHczJyN/ILbM8iABUA4JrP5LBweHuyYSKGem3I
 3dyVuN03
 rJ6AeEII37rZkT4dCc3Lx0iDggHrGLnyYqa1ngwTWSI+VALHhr8ZWpzUWwybxgCeb9y+oOjhzY26al1qXCMY/bAEHlRwHDOUU66FQXk+lsZy8d4U6GFp6GIPE316DLGYTkD0zf8NH+jb5KTu7yOHUj14pGjp2nMmafXN/a/brbhs1XHKIb08u5bzUa8TQOg2Db61+3sKuLM/tXEgPTU3oCtKsBFJ92m9zy6wLER2QYDgOalvxecyaemI6MsZSlQD93MR/CFKILKkriHirMhcqcdC5Yf79C4zDmrJsVklcWBmPz1IkQ0XtmJs5Evsrj+2XpU1FsxnIlX2N36XcBSphI8iu0e0OwAAwzvUAwDqjSsp7UwuoUs02qnFRSk2RZW5AzB2hHpoHpbx7Yqwfq2sRyx1NvuCoFWtzApIip+2uUbMHAyk8SrhofA2F9AYLVMN2D1bpfLVex4NdYN0glm0JPmVeZ0ly9q+ceolsTxpf1n/22HLaLghlXH/lqSMMSA/auwuHgulqdZw6j7gufCrzjYbRfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 10:41:05AM +0100, Boris Brezillon wrote:

> > Then you can think about what is ideal for GPU and consider what the
> > work would be like. My uneducated feeling is with gpuvm trying to be
> > common code it could also have gpuvm provide shared common code that
> > directly builds page tables in CPU memory using the above framework.
> 
> So, gpuvm is one level up (it doesn't deal at all with any HW
> representation), but I guess we could provide helpers for UMA-GPUs,
> where preparing the page table on the CPU is a thing, and it could be
> that MSM would be interested in using those helpers too.

You can make it work like the iommu does where gpuvm gets a "gpu
domain" from the driver that is created by using the common code from
gpuvm. Then most of the code is common.

I think something could be built that works with the framebuffer
resident page tables too if they are being accessed over mmio.

Jason

