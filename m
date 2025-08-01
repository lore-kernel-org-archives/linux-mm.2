Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C787C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46026B0095; Fri,  1 Aug 2025 12:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DA96B0096; Fri,  1 Aug 2025 12:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BD66B0098; Fri,  1 Aug 2025 12:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB276B0095
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:53:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 628E2802CA
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:53:07 +0000 (UTC)
X-FDA: 83728783614.08.DA99D3B
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2056.outbound.protection.outlook.com [40.107.212.56])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9181820011
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:53:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OWyLJg6D;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754067184; a=rsa-sha256;
	cv=pass;
	b=lMZmPhxCzbV5YUYOkw5kKRz8hUHKFQC5CHVmeyQzGX6Lfja8dymslggZiTBIQdiKhhSqUz
	mt47vwprnu9bOEMnwznfnjJBmqiE3xThyho8mcTyEDpMvpSqDcQzvo3U0wc/MPkkjHAoQK
	PXT8oivNRe7LGK4ADSdW8yMjAOe8MXI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OWyLJg6D;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.212.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754067184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTzqg5kpTfnmlZ/+wFgnQFBqph6h0Rma6qUhiO9piIU=;
	b=Oq5CfbCbGIVHMldFxQEIJ0j0K7aBsUXu250UjUrhybmjhtDRudJ9tg2BSZDx/AkLEe72Vv
	m9HXGMEUNPgxqT7BcX6RB+6g8j8MHhX+aR77EFCRbTUKsUpH3pRrXupu3Gs3kMGpzw8VKO
	uFxgV8a/fgL5ZuJGSyDZr6OwMaGlD4k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwcWz6n0SZ/1Mya0UBbErLGJmLD1B0VqJ/OzeWfqzh/QlCffqsphn5/dkG3D/Pt4NAZBZE+Drr5cF9HJteeETDe2i9gMpyzC6Z+9VsNrSemEEdmEMEjwWxqdC/Ndsy/vxDNPY/JrXPGbmUk8ULUMlMmhxOEX9Nu/z/pmzlfdyBPnerNIjt1vN6AieS0Yp6tCwxVHPYD0kJ/3YaX5uSHtziBKnw00PplpVuZZWGaY3mSnwIOIBDwM3UAE7OHqzNTHKGD6gJ6jCPLCp/VXzPyKZKk8sGImt1VO0T1SiPNMF5IgrIU2B1rx9VySlN4cWoqopyTEPBCOV03kGK/srd46Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTzqg5kpTfnmlZ/+wFgnQFBqph6h0Rma6qUhiO9piIU=;
 b=eaiI4xJpttIW0+S8IoyLn0E5ry8rmw34LdeeEAjUrkJI9eHbo9jkGfgTlJodJhbNFhwTj7maL6lZzMmM+4eZ4J19Sf1Uug/40crVuyltjL/O/mNOBG8RSOz0qlWljJDZvFW1wgzcEYN0+BJw8U4VHw+xSWsPKu2QZjLT7LV/yk4qh0yAdhUzhjKfq/+xFBg8wKt7t4O9dtGyTEWA2x6XRpmyEDRkgmpAH9Mfmot+Xh3n3RVCxlkrDkx78y4SeAoYWOpEwW1BBQptUfD71F6TrplTzDVT1/qwfGM9qEJQjoWAF3GBQotRVPTt4KePMrjBnDjEgeYirSGimf4nnxGlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTzqg5kpTfnmlZ/+wFgnQFBqph6h0Rma6qUhiO9piIU=;
 b=OWyLJg6DvP5pToRFtoQM0374PzrAf32ssKUO48oRX+hmVnp5C6lafVr+MG0z3vuZcd9a5nEOCKf8FJSTDjmDh7yCw8MiF6TyQpQwF9DgdViiKKTxgVU7N5+e/pYXLQrBThBfHHBcyNJXYqz+jfozEeD1bJu5c2e0zJ1KRrxl3lVW1Mvjbv6r7Y1OhC+lsMa7X8LnW29SbWpb/Q5p1xdyeABFDDUXbTxf1zGGpdqNUmuH4fi8RFuREiHznSLT/iJdyEomLDAoxSP8b/aQQrCwcXcxGEsI7ZC5m6ejlTQaaFaXcVHkvPDUpPGXHfMijA+b+FE0WCiAHvbz5cCKvTGG4w==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BN5PR12MB9537.namprd12.prod.outlook.com (2603:10b6:408:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Fri, 1 Aug
 2025 16:53:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 16:53:01 +0000
Date: Fri, 1 Aug 2025 13:52:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alistair Popple <apopple@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 1/5] mm/hmm: HMM API to enable P2P DMA for device
 private pages
Message-ID: <20250801165259.GA250572@nvidia.com>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-2-ymaman@nvidia.com>
 <aH3lPnIUGn29HJFo@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH3lPnIUGn29HJFo@infradead.org>
X-ClientProxiedBy: YT4PR01CA0297.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::22) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BN5PR12MB9537:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ec2be63-5c5e-4690-81f0-08ddd11be016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MsQuxU/E3leQ0iRphRpUFYVhwzrkwsZKF8OdSsVProdTXJNfUgGdr5QIMuD4?=
 =?us-ascii?Q?Z/xHGs54G8UvmMwSNmKOP+JCoqo8m0pQW/QPh7wO6GId6vYwYaLwFWxJ4Ri8?=
 =?us-ascii?Q?jQ+Ujn5SA8+K9IJvCygwHYa+D3Dn1XaV2TYcQpITT2GiZ7kogvV/3HDiwHh7?=
 =?us-ascii?Q?x6QcMRU3KBUO4SCth2GbX9VXnlidB0woM1f4+ZwghtPXJmtFv4W4IvQRnxTZ?=
 =?us-ascii?Q?ehoYLzjzwfbF9ZscB76FoqFcE5nWWEwrh3LIO9BxkSYn2OsnVpdZmwfW2kuN?=
 =?us-ascii?Q?YSmu8PsZZnZK6aABjNcLohGKU/Uz1XbhvRqC7xwIii2fAOKTtxM1PcoO6Exh?=
 =?us-ascii?Q?OJ3Y7/fFfvevludd5iszvPZhKJPbw48Q2eUiKImHTPIPxUJL2rrrRxDNfohM?=
 =?us-ascii?Q?d9upU7Cfv9On4DhOqg1dVPnCSe11qhpEcoRVtKMyWuZlR5g3PxQCPjLfaVVl?=
 =?us-ascii?Q?cS8D5rqjZ2tNYnAVWmgA6nVwNe58SWdMJcrUpbhQ+9qCUNehq8ISQprU1k/A?=
 =?us-ascii?Q?bReJzwTlpGMAEaQAvg8HAFSGgAUAeprBjheVoB2tXU9ekKh3qGPGXC3UBCAK?=
 =?us-ascii?Q?CoVV+IqRu2Aky+DCHG2SRFwqHGj3PYmzgkvJFt36Gkxx0bgkZfAQ1GKoCpVO?=
 =?us-ascii?Q?B315jv4mOtkBbUjm+xIx/+nnfos+GkPzpejyPCbqmexhYPwo8spXhBqWmJsP?=
 =?us-ascii?Q?qkQoV+5WDC5M9pc4dbzYOZjfJZWu/4SNb15uQJYX+I8WlHji+0qHgh+QIwte?=
 =?us-ascii?Q?0d2mSsm0eaIfCFQgQEi7Sw1Z4In+rNT844rmIuQ2wZe/PWKxVSqK4V9ji3PV?=
 =?us-ascii?Q?ZIKndUnd/m84b6udm3ggB8e4orBc7Awi8gB5VfJPvQaBumBelSSin9RP8lwO?=
 =?us-ascii?Q?MUXT5wqtNLC2IU8BsBUIuWk9rjdZ8TwbPJhyLRHdHYWAQKV5oRhgpg942GEA?=
 =?us-ascii?Q?O5cFvzIdyfKC7dvVmup1QuVq1hR7fG+y5zSjUcXdOKeGx7a6R6ZE0E53zzCw?=
 =?us-ascii?Q?jww6V8uKWZMvcVoCSoBGaITcFiGS4gVSaVeAD7gFs/0VdBpZhNJ4uFlwiwlu?=
 =?us-ascii?Q?48Ay6UEdG5YMluxDSgahR4ypfX879bTgVMJXa+dBQe8iJeT7DsqIdbWsTmgT?=
 =?us-ascii?Q?tioqTIIZR4AlkgBNaHt0nmTWfy84vmTfuneWd1g+IM+WLv2/jK4D9Oi1mD/8?=
 =?us-ascii?Q?QKUt6CM39RWq60rXnTeqZmqcHXJ+hPO0WEyBWQUPkZE9fRCOJD+upTrZz53v?=
 =?us-ascii?Q?FOsPV00myi+Y9eVoXmlLSnVgy3vgwtr8uRsu7uKDfUUNDXoCyYg5Rvl69Yc8?=
 =?us-ascii?Q?0gPGXuvplXlxzZ2/AmuPeV/qnbzSWtJuNj8njqSGZsjNO4xua89YX0cFyYHg?=
 =?us-ascii?Q?vfAOXQ19peJVDGzkkZf6+a+maLew+isvtRD2Ass9VoUoU1OIdwfH4tD5rZEn?=
 =?us-ascii?Q?Pf04Ir20sGI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gaPTtiW+oyviLR1zUB1/Otw2vZUdQKcnGsw3j+GBhN8HuewTZqRb/ov/P2S0?=
 =?us-ascii?Q?vz8x1JOWdX/Ktotavb9puOT9xRTqjo4MF25fvdZgS8UKmHdGulxhW0KuALz8?=
 =?us-ascii?Q?yo9iOS1bc185TThx4fiKdAPRFWVs0FllRBkUct3uLKdCj+qmY+MLdthhJxgc?=
 =?us-ascii?Q?zVfd8+W3d1VHA87e9p0BQ/w5o0Pe9fKXTPvjNpZA42Fl61p5ylXHIiVQ92TE?=
 =?us-ascii?Q?EOWabhN3dDKoR77MJhbhMklRRSxT2+2h0KyNd9+2aNsXunTwF9GIdiQTsAyF?=
 =?us-ascii?Q?5wlm7TxkSYHsQQXnupHbdcKpkQDFpzZSdfrxH103CMsnWx4igQnu78dlXYe3?=
 =?us-ascii?Q?t/lAgtAbvHgcPEHj58KthSDgDJE+x3qkFfuXz+lj+16NcDTTgc2RiOkGlzPT?=
 =?us-ascii?Q?+gfbXGu7bZokuKGQAteA3uGJ9SuJoTYZe9h1326yAVvHBc5JAVSIhN33eRt1?=
 =?us-ascii?Q?XgVxXI0O++kBXjDfuvSG/c411MjbRH5FiLlYbt5rAjGZHOaTJF2bamF0V8eG?=
 =?us-ascii?Q?HlZkRyw3J6dI1HFxf0v25hKFMbkoZohEPflK6NY5CQAJFs8a+ycSAuB8bTRK?=
 =?us-ascii?Q?Npu+2PQovhwy09hsrpHLPdIamcYW+f+se69GFZ52PEKj6l16adCWb5UhyIbO?=
 =?us-ascii?Q?L+IThhqaX+k65mB45qPOic9c3dvSk9Z1et9/k8QB40zsjXnW93C+yjYqUM6f?=
 =?us-ascii?Q?WTScHu1XpTI322Ggm3iDwH1GoxsLPW3uaBng+y1uh63eloBq/CF75fJ9iPYh?=
 =?us-ascii?Q?Ldhl42i4XfaurZ78x8PBVeA/mMRpDdMr5Zz1+50/3lIC9X6B2gKNJXThdRsQ?=
 =?us-ascii?Q?E+y6HoiOyXmgTWUoIlCregBlfqoll/mxqtrIt78q5b9mp/V/h28wAWRqgKEc?=
 =?us-ascii?Q?RKVlc77GDsns/zZC2SKwDvpRXUAvFOfhGHfDUez4D4gRc6p+MQg8etWK2fGP?=
 =?us-ascii?Q?dEFjT7H1JxsgUygNdNlUkNVg0Lwh40dOrU0Kj/baL4OfVscDAEBPtG+wYMxQ?=
 =?us-ascii?Q?qVWgwEUkpHJdV+rQA1zFKzylT/p4Cx1diIFGMRB7KuLYJlGpnwITNBBjeRgf?=
 =?us-ascii?Q?df1q0u2LBb8whGnoz8iMkWBe01n6VjuWe2EvRrk2BDzcnkWIF8saI+1g3+eH?=
 =?us-ascii?Q?uL5/jQ1PVrzcTFppu5NtKDpOII6Q2FOS1NeKSFtT7b/bdk1mFW/jZmSZvtJJ?=
 =?us-ascii?Q?P9kaLOq93IWFkYfZB01VDhxAp6My+1fVUDeihIRnuJywnEr3uQImF2DLEX3N?=
 =?us-ascii?Q?Bm9bwEGG1K/PcldSlpcijjFEdf40zIef1dEMn2hCWp96ZBuEcaCue77TmYd/?=
 =?us-ascii?Q?Gbu2iBp+/xkyq37Jr2Tlvn/3pK8N8jyLIh/Nm2LL7EejRYVGfi+8QcURGs6K?=
 =?us-ascii?Q?IxPdND22vk7R7noRW37WHYuQJ0c9c4KaHZRjloRCmbG1ZT3w/OOsWSjTeCed?=
 =?us-ascii?Q?lzCffg1WKA5fcRnoE5uYdBgA5wvCyl3c7qfzoqJmagOb60YembCwUOQCpuwh?=
 =?us-ascii?Q?2nwmcPSlgiNeC/TTrZb4fU5twLyL1+NDKWutAKJR7b6NN7nH3GGsPghKzOQR?=
 =?us-ascii?Q?IZ5AuAuNh1UpBPSEnM0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec2be63-5c5e-4690-81f0-08ddd11be016
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 16:53:01.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKSKe0QGMrF7tsKhbuPfh2J4t9Kqcj0OgyCKDDZJXZn3RToQthrTx7KMEuuGQYsH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9537
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9181820011
X-Stat-Signature: 8jezsxe66ojib68bjzjk1m1rzzymzsuh
X-Rspam-User: 
X-HE-Tag: 1754067184-495266
X-HE-Meta: U2FsdGVkX19Fm4FrFPMSU4zeZkEaP7yyyJFQBM73OpwpX5dsiip2IF0IGN5qe3Xu9qDJdYaLo9BKu8ldwNHDKM22HNVfLb00PR5WNXFL/JUzsaw3YhJR8YBVcBE3q+H7e1cOP2aqvbNXYGm7cYq0PCBMK1IC2T81d0exX5sssodNTNA3gg5Nt0eOqZccDH6rKAN5gaAM3S2MCd2A1LR/jH7MMpI1/bfUag1GvdhAf7RC0LsVKdP3c6xdCdfo8s2o709n8jS7GeGYRH9jm3FNVubW2lx8vlS9aGNo4RCH+1//1xipmbPRHHtXRkgGEw2x6xm6hplAoS2uKT0FSqIT17R6m0zaiXRqodjD+sXEk6Xtjf1xXlbE6mJ+fBbB8ka8ZJiHCCS1e6yH9cbtSO+4TS6354RowmC/ul4Q4F6HZQNnQT26uIHND1wE3/yLcC+2+gwd1/F9sX8oqkl+dr1HNCCnzmMawa6Wf6r7UiR7+dnXaYcOTh11reeQOamH55Yg85zXN+cX2l7n599W6WKZBJ4AbhAPlEgh2/7j6EFacCdCsA5k4jD93YejbuZSwrT37y/lQlerhNmXgpuyR0SQuxBBSVSaEoncd+MaMogettJ9yjBkvqmopeeMNsVu+DAXjC3eL3hsp0XFPO4icxnloR4hIeTzFxH7+UJNpof1gxZ8IwswbjYJO28tWt5DjlFe9RJqAADfSIwHQGfaKi36ipZ6RLKy8edeFENUyJCQ9dMcMdSIuPPzwDB4Ss1pDsZgxAxF3rVmCImJ0xtwm5vbi/Bluvf5EYJlwZbIzXiaapRZmXC9XqwAq0Xw4C98DcL/Fk0Dn6oDC6z4dHF/zTVcOPKXMdypKLkWH6rpZEjiZpU/SaVjer4Q2fcjKG8vnrQJyEQqpwPqv8ugk7m1kIskuvmp4G+9m/Y7R+LoQO8SsrxDkKpk9tcJFVP25HgLQ31+Li9GL+HZx36/EZAKafN
 ErVyVnR8
 6q+XYM/ZMaFjxntGOmet1+Lm+U2NlLmu0IZMWXlVg+/1c7gyOjaELcjog/NdmbQnCWmIedziYGksuHpAid9UulCK23sLHe0I+9DWFseJh5WxY5TNy/jIoyhMzTrDGKGMH1fmvCNbtfRmKDK5SuQRzGqJ97sSfKHctz6sCEn9zI9ZG6tdg6EO2b4TXg/P8lZcN35fCmeLeCe37I7Rt3JR56ruGT2oKGlmvnolSOff27TVq9hvbmqHXwOpl3vqq/gM64Rl/KcEf2XLBbcE1gh2qOEyalXtQ2Cq3m8ebCDUWPlXNlJYRJrPMKqjwIby8nGuoA159nZSQsosJ2Eb0vle8uHQdzfeTwqtYlOwdpNVBwIuWJxQHzg6okY1CDxSxEjc32JhT6+Y/Q/K2aHuw/QplpWqHbK0NVBt1I6MI4Mb6ed+6F+KcA6pCW8yVuPp2/VHoQB0VA46htLBT1aY95NsOU5GydlcYxfqydOroSKNm6wcNSIrrLBTxTDRekQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 20, 2025 at 11:59:10PM -0700, Christoph Hellwig wrote:
> > +	/*
> > +	 * Don't fault in device private pages owned by the caller,
> > +	 * just report the PFN.
> > +	 */
> > +	if (pgmap->owner == range->dev_private_owner) {
> > +		*hmm_pfn = swp_offset_pfn(entry);
> > +		goto found;
> 
> This is dangerous because it mixes actual DMAable alias PFNs with the
> device private fake PFNs.  Maybe your hardware / driver can handle
> it, but just leaking this out is not a good idea.

For better or worse that is how the hmm API works today.

Recall the result is an array of unsigned long with a pfn and flags:

enum hmm_pfn_flags {
	/* Output fields and flags */
	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),

The only promise is that every pfn has a struct page behind it.

If the caller specifies dev_private_owner then it must also look into
the struct page of every returned pfn to see if it is device private
or not.

hmm_dma_map_pfn() already unconditionally calls pci_p2pdma_state()
which checks for P2P struct pages.

It does sound like a good improvement to return the type of the pfn
(normal, p2p, private) in the flags bits as well to optimize away
these extra struct page lookups.

But this is a different project..

Jason

