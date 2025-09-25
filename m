Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF66CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 23:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FB08E0005; Thu, 25 Sep 2025 19:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420358E0001; Thu, 25 Sep 2025 19:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1D38E0005; Thu, 25 Sep 2025 19:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 11B368E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:02:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3C031604F2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:02:45 +0000 (UTC)
X-FDA: 83929299090.11.B9B44ED
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013028.outbound.protection.outlook.com [40.107.201.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id F3C5F180017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 23:02:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XuF6g7CB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758841363; a=rsa-sha256;
	cv=pass;
	b=ylab37nvfieJhsd73p0ZhL3EdEtpBmESsmyvvnYO8YS7O50yyK2b1vq30h3QkY7HZHNBXn
	6wJnsu3+P3oc1tvxFuuMsPkgy7878Q6rVNqln5nvF/ftzNco4YorP7hFj2bzqtruygTHOO
	80LDsZjb1P9WwMHoh5HVev6os0Kuy20=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XuF6g7CB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of jgg@nvidia.com designates 40.107.201.28 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758841363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9DRGUC/+247HjfmMmZEbtL8Id3J2isUez0i3l+wr1Y=;
	b=RL38DHRJ2fm6qE2+TMpQj7q7W0QPJXfRlP7K9ardH7WQqBaetfVIi9ZrVxZCqfnImvfjmD
	iC2Uk+ofpOn9tzUo+veGJRhoVgjEYUMKfsfHrrxcy3C7mOsUqupztdaZ+0E/zpuJMeNlk+
	RAhWzCiUin4aJDhmXyE9Y3dyAhpgehU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Veraw9i9rBeUxrT+g47phRuj7dndwLieMxxrjQBV1eKUhM+Fs6rmXiykLlp5Xt7NhooeNRFvFE8uGQm/sOiBXxqNLJxQkgYzx2Yx/bvVxmYz41veLFTlwVgZBadDScJyM4ObLgdStgKltE5jMTxBteOmvdYWSG06DHzKKQOIMO2PrhTMdpzUAv42aJRqUWGpLnjNqbfsj4fKkb+D9p/CWKTt1vtQ7UF0eTLn40OnUdt8B5Xxx4yIIFkQcmNs9UzwStArWUh9lO/D8c88aGxnK5yyD9YuCuLmnOYGiTD0cGMUxUOG83QSARABSmPjpyzHi5fZhkOppJDN7cWEA+wDBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9DRGUC/+247HjfmMmZEbtL8Id3J2isUez0i3l+wr1Y=;
 b=pJabHan0rnXiTyRgKV+vA6zrBYfBFFI+lzMzBqqQ3ywbwjVgRkIF0Gdlw19pQ8Evs82MOUP/3UjmVaQFsYvI57U8lB9Nh/0hnGYebguxiPwbGPgHOnD2HnibmfDJlEd2nQRDMW0Djyw+XwftrT67c/0StSrRbXz3DfoEUA0EXiss6DU4f3aKQs7jGXf636e6cxlCHiaG+XxPWEZPtyqkC720pRzC4btlBbzhojqYNNkrdWJzmUYwktD/iUOi29VpwlVaHA9PKWl6QTyckNxO8yeG5xJUEwnbvpop55DQHO3zxsdXWpjcBNIfvfeNKqs+iBuuRYfSu8qpIXW9ZGCKag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9DRGUC/+247HjfmMmZEbtL8Id3J2isUez0i3l+wr1Y=;
 b=XuF6g7CBdWx5+Xs05AVTRMVclzFa4ykGlvjopA8bZ9bzTKWUmVmsqo3OZEFGEbhDVe6IHNoPyWnP0QSCWBiGHWtKzeO1hoiQoXwW8fH2DjwBXogJrkD6NRuuEuTHFFvkk9WL0L2dzk+ecem6l+SDFgFOU1/aSnk30PQtfzAfvBHetuwnCETmM0rH/929WvBfKYKFGVd5LpU9lzT2tJTUAd1dK38ob430oPILKh/xwakWaxj5ZArQoi5j6qZRppmDx7ULv6ioc7pMDhNhDHuK7VeYAtoGJG3aZJ5us7mnwuNY5OSky8W76eNh+3I97UkskZt0FwyQcQZcAa9zviIxGw==
Received: from DM4PR12MB5769.namprd12.prod.outlook.com (2603:10b6:8:60::6) by
 DS0PR12MB8455.namprd12.prod.outlook.com (2603:10b6:8:158::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Thu, 25 Sep 2025 23:02:37 +0000
Received: from DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff]) by DM4PR12MB5769.namprd12.prod.outlook.com
 ([fe80::f5f:6beb:c64a:e1ff%5]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 23:02:37 +0000
Date: Thu, 25 Sep 2025 20:02:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 03/10] PCI/P2PDMA: Refactor to separate core P2P
 functionality from memory allocation
Message-ID: <20250925230236.GB2617119@nvidia.com>
References: <cover.1757589589.git.leon@kernel.org>
 <1e2cb89ea76a92949d06a804e3ab97478e7cacbb.1757589589.git.leon@kernel.org>
 <20250922150032.3e3da410.alex.williamson@redhat.com>
 <20250923150414.GA2608121@nvidia.com>
 <20250923113041.38bee711.alex.williamson@redhat.com>
 <20250923174333.GE2608121@nvidia.com>
 <20250923120932.47df57b2.alex.williamson@redhat.com>
 <20250925070314.GA12165@unreal>
 <20250925115308.GT2617119@nvidia.com>
 <20250925163131.22a2c09b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925163131.22a2c09b.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0077.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::22) To DM4PR12MB5769.namprd12.prod.outlook.com
 (2603:10b6:8:60::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5769:EE_|DS0PR12MB8455:EE_
X-MS-Office365-Filtering-Correlation-Id: df996379-51ba-453c-a6e2-08ddfc879eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6s6CuOOqj3mwU5QZIBx+E4R6YVsidi9Pw+wdvmniyRKBYX8dvUHswZUMSwZz?=
 =?us-ascii?Q?13zdU5I+Gj4apbAmsbFwh0WHvV2zXAOtsVxPWJcNHJqpTkwMybv+9WSC9d4a?=
 =?us-ascii?Q?efZf7LsfVUtoXF55hUmzr9+RK6zsAX4tEFIe3M/EFbg/6/oQKA9+j/Qe+pn+?=
 =?us-ascii?Q?LgXXQ4ayOUvFI+yaHxVWhNnDvrJfBTN2kzTUIASeSy2kKGptZtjbgxzVCBEp?=
 =?us-ascii?Q?I5FRjGzYKPv7LsrDpw5Tx9H9I56ISC96+Hdn3dU/K1230UGqkUGSEKZqp39c?=
 =?us-ascii?Q?uGidTUW0KfjLgSkJGlwUjExQYYdOzy7IETvwat+9O1rKjQsB6WlahMzOrg8g?=
 =?us-ascii?Q?TZ2OQN5V2PTJKygf/bY+PeH7R6KpVKJlb89nLM01gf1GkysaJIKiTIigrG2z?=
 =?us-ascii?Q?oJlK+59TjpSs024MzRYIedKVLXkZzjc43u2FS1EoSqvoNxpYKLnKXQ7qEUNB?=
 =?us-ascii?Q?cTAjrjyUu0h5uUEba1cna0mOap7SGM5Gu89osaGCXCLbb6PiRB57EdcaStro?=
 =?us-ascii?Q?gI3lH7GDgcdsRJUx6/IT/9gr6neWoGad0BT9NGgpuZ/i4DnuJdO+C8B36A91?=
 =?us-ascii?Q?ONExRAxW0cdfpshETsgET7wGmwsL6fYw4dSQV47hTZ0V/Ct4TXbG177PnbEL?=
 =?us-ascii?Q?mAQOrTC7L9TF+GcIicdA6HsI3RixNZ4EHGNO61ER2aVg1D+hAEeG3Cw7++tM?=
 =?us-ascii?Q?FS6lAN8kgcRXiVO8vrIPYrZilZy8sHqklaHY/lc4V4xYhXFE3wP4fkFV78Fq?=
 =?us-ascii?Q?KAOnZQ9BSWVgLiD9Kyci9bdjzeoCDhZej+K9GSFu4Fh6FG3w3R8YG1gILd+9?=
 =?us-ascii?Q?zh4NEF8FqpKIRkm2SqAknUKJqFvO19RCKktFidA1iVjuAhkd5X/XVCeeoym3?=
 =?us-ascii?Q?ihLwumCoJdEp1EC3DqAPF+cNizHDL5Vwkl5mwgGWYK2vTPFDORsyRY37Nd5S?=
 =?us-ascii?Q?wn5wK1volSlgGGeVOWMiaSsdbOCfFkeftREIS9Dds7F8uLsez713ul22Qiw9?=
 =?us-ascii?Q?b6nmwELi+CmgzQMeigx4WMNGn6vBRo7Ph9zRzfe5oUWwdhA8Uzn3c/JNv0ys?=
 =?us-ascii?Q?YAusgdYx0+lkkeSEOANh66TgNRStfBlq/LCX2wm7VLoZRCNKWchJxlkkpnWC?=
 =?us-ascii?Q?s1c2kF+LZEIQaYVanNRg4z31ECgGPN//ucPuEyGTD4q09OmvnLTQw48/1EwD?=
 =?us-ascii?Q?isnPnPfGq+XFE3s69wJIHrcgsuxX40xCKeUGwD8dRoCGdc/kIKKld6Ai2TKn?=
 =?us-ascii?Q?Qr6A8383nT4Vxd6i2tbqGXn0CLrk8v0xuxnJOErHm4Zpc3G8WdmSGMpFY9ve?=
 =?us-ascii?Q?ZrmY48GPXwa4GA3BSR6963+57n2Xg3pfWsjZB1RaiXe2oe+hbHulPEXE+/B4?=
 =?us-ascii?Q?bYhc995srBelZEsPySzC7OrExam5TknSGJ+jfTpyhtdhfmKIWRp6nnCQ6eO8?=
 =?us-ascii?Q?UvVedIw0vGI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5769.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mwv9bbd4kJFCVF8AypcgqX7//QxIezvvAJ/4KhakbxCCoUxxgF4Q4zR7qDWe?=
 =?us-ascii?Q?x++4wHs+OsP2hggshHzTJPqhLt1J+sIf12GuvKk1pl6M3V7gXJi4B1IN6NhV?=
 =?us-ascii?Q?ZfBW90b/Nl27k98GzvyR1cq8/PpVASDko5pdAD3PSOcgKE3dyRLuOH2m3Giy?=
 =?us-ascii?Q?bmt4V7FmWBA8ixYDPUNZdfUWe3G1XAFQYcMakRIH2zyFTSJ0huQJvOtqmwrr?=
 =?us-ascii?Q?SeB9RB5bAKaX4VxNIJb2NtJ5zXlIz+NWAJb/GK4SCGgkiZdqt7zI5ZywYoKp?=
 =?us-ascii?Q?ui7IqqYHylVW7ZKSPMoVrFnw2w4z3bS0nF/CnuaEHfHux4gc3lJyfUfNglsb?=
 =?us-ascii?Q?taiWxNKiKBi7sZ7Re9MzrgVkWB5JyuvtYb3nas/QAd2Zy/aTLIBAXs6ic0yh?=
 =?us-ascii?Q?CNmS4VECjT9B/Z03NmYsLFSM6ffvUx1EpC0qsjVxgXtVezOeWfzNTMXr0KMT?=
 =?us-ascii?Q?AaXKBMH/DZqG81AQJCITBq3aIvxBn44RO4+oVs307AEK8YpMos65yEasFajd?=
 =?us-ascii?Q?0E3sq66Ydo0Ek4m/zR4gV4QmE3t9NFYX/G8RUNeJcf/+m0OZHuN6kbHebAQo?=
 =?us-ascii?Q?b7nRzCl62Yh8PZVs5cU00LWMZuKPMvMUX/s4y93r4PDrfkCEesi4cT9Z+hd3?=
 =?us-ascii?Q?bPwN4RSt0e0Gp7ib/+D7gNfYE/5hh9O9zuvaxyXIiH2lSLOamE2kgnvCcpFe?=
 =?us-ascii?Q?O0CvmpV/HahrJcbiLix6JQrVGSRLUQ0lMkuJJxHLoyEFL4ekl7V0epl2GmeQ?=
 =?us-ascii?Q?SwjqEzYIOqU9zglYZcQo2J5Shaq5Qwliv3NWtfBxSnIzWTtq8G4eeJDjyg/L?=
 =?us-ascii?Q?OO2M/g+ZiH8TCjNiQlVfJEcYYFlVKcbphtp/5poRsjRYmQNeXLsPAunsBowP?=
 =?us-ascii?Q?WiUiMqI7KTl6YhxC1eGNFVjp9LjGwwHDMix+3aCDxTVAp+iT79vgHgo9dg2e?=
 =?us-ascii?Q?xOvEyOshzfx7PvnoYu4tCeZcTbJIWVZjuuc3CcEoNqZKm7WcjrRozFj0J0iw?=
 =?us-ascii?Q?/cQ2aXQZcbcz+T8XfmtuYb7jY0zogF8GvLbIVtNoPapYxjencJRotFdvjoOC?=
 =?us-ascii?Q?EJtFWmcBQtQ2KUG5SE+EUPqgv1xE9dO1ujvdwAxH/CqkO27MkPCVY4xuQPcd?=
 =?us-ascii?Q?D8bjZHoPBhba8Lo8rlEjdtkKCcH6DOTppdWdtT4eK0AAIbOEJ7fU5VngjEte?=
 =?us-ascii?Q?uSt/wCiZTK6ByfQVdp4CMtGLaZ5G7zdwfEXFHGaLvZZD/HSLLoTtvr2Fkd0R?=
 =?us-ascii?Q?F+y+G0zC9cTXXb0u4b4zcFVLmXiSNHZ+mJMGMfD/CJxM8uu01/9C9eXYgGOE?=
 =?us-ascii?Q?hQee1lWz7a4GBg7ObIGLoO1mTwbXX0wFB/Q+BfTa77mG78iTswJ0PQVB+9r4?=
 =?us-ascii?Q?6QmEde2e+i5vx9R3jWQGvQN8PJ0Alr33kymulGSgRMgtsrFjdEfjqXR7htpb?=
 =?us-ascii?Q?4J6N4bnfe+DwgBBZU5DOeefKBCl9lueLfLQfi/tHXHA8CzW5+CFyD23Ui+5F?=
 =?us-ascii?Q?bogFvTR9ja5fGOaO+VRqTy4Y8XBm/z1+MuhdL0RM+mNolWBSJLo1PwG+J4Vv?=
 =?us-ascii?Q?CRTX3RcvrrxPxOlm0Fg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df996379-51ba-453c-a6e2-08ddfc879eff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5769.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 23:02:37.6196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErHbqphuHRq9z0XrMlkoaWDRThIS4A7/KvynIm7iOQwaFvPaB8Zu6kbAhXUQO37N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8455
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3C5F180017
X-Stat-Signature: myieuoqu1k7p4pyep7j5onfhuqr56kqz
X-Rspam-User: 
X-HE-Tag: 1758841362-317769
X-HE-Meta: U2FsdGVkX1+iZakuKZHgEwyqaitITvbUTBM03QkE0ueD2OSjAIzDGoRifW2V3hE7SIo3O0wOE2sR7NCJ+0wZ3+YTcbo70880OO74ywSrV15cO+yrGeBmaMCF9BNrZJDXvOuKxIkoLUB5uRfAJRw3yp/n6hK1TN9NCW8qw6AJ0i1ajdDbNx5YfxvX45pdTvzXHjCmaINUEMny3rwxDyuRyjBpDm3nHdGhHFJSiF8O5NvUCdw8ZPs3wcP8GJ3EOlhkEt/wmSc36tYK+G0A9Xcpjh81tBs1nQ/f/coGw126Y4mOnuHNUgY/xHcODK+Yz+z0skAoH3+6Vah3zHg8a1jiTn/Hac9WcGvLzGA3XBA3xrNCQX3xQAaRMzEvBUzxRo3p/lNOWkb1S6vISpHawT4UMq+HeMbReb7FMkA6m/MiV2JYPAhsOvtGn8ThgVEsx03Vaxvy73JYUl68zVJ2ceI8u/QTRR6pkMV3B+gZYeit/7tovojy4dT/UrFDdjXjYjW97CRV+vgAPspz53FGkC2/dDJ5xd+ntJ80wqbNycMyJRT8hpQ/p8pMLq35yqbln93d2zwQZtUBJwcJcunURBG0ZnjelCN+vu6GBi6dUj7sV5f/+RcGvY247McyhV8iY34G0gKzh5x7xJSMbqNf7bBkQVSf/edZrtiWxWkjSam7G8KZvO2gtamcabZQw+4OwFJOAfeQJojnShQF+DXfLhueZHlujMLYoeVN260KSsHOwYLrPkpr9q4yReaqMnLccYUPy0zcSrnFxFIrhO8/3xGc+o3o011fPhENpmQ+Cbs52G3ygB9uMhChHP3vJ8P3DYWuetBWuwUd57lWXjHtK4j0pVwfdV4bD3o5+IUlwHcqnjEFeZev0cGCG6IB+m6Dw2o4EIh5wCpf6AhEx3gy+ucp4d2y7TmF32wb/5EMVpDlIrb3s/DM36NIyXhL7al7KLCWKUSsigDFlkHASCDnQZB
 j3+mxGVd
 /t9vQ7twZfLTFeAQpLYEksi2BC94CkRrLeNmz/0K5wjZ7ESVxxNajP67neLwVnOF8gwziQM98KL1SLYztoNdXhZTV9fCwiK2wPlwVhbWrvtza4X/0FdJ+dZ4blgD5pGYJeMAHXK3IIG2SoqeYpg0V+jWNaDzlQSD+klonX7g/AUMBm4R7ZQ8hqMVyh/WzlISrrKkjg2AVCNIu5vs+du5xLqgwUO8ad3XlyF3K/Aw0HKn68BJORku4utFnIC/LK/YNJJJSEVMtComt67K/ZxoDI57KJd+BKvY8hTtbk5U5pLlw+WX/5iWCCPU7eF/1sSXynwDjiyXXqZI1tVZRxdHU4YHokeHNmswbW1sSfSCfmpqImhlt1Q8ymFqrdLeGiCvXg9iOsMIXTWdOiPwY2CxLvAupDi3vgsuxebjr4BT47J5iejHp0C9fatj11tT/LkwNwcej7S2gGeVvHoo3B72Atnv/touwDWl+jW1zYURuagtSgQf5P5dZkIcyf6OMIYUIc/I5+UBqvB5t2DnW7MQXLmiuHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 04:31:31PM -0600, Alex Williamson wrote:
> On Thu, 25 Sep 2025 08:53:08 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Sep 25, 2025 at 10:03:14AM +0300, Leon Romanovsky wrote:
> > 
> > > > It would at least make sense to me then to store the provider on the
> > > > vfio_pci_dma_buf object at the time of the get feature call rather than
> > > > vfio_pci_core_init_dev() though.  That would eliminate patch 08/ and
> > > > the inline #ifdefs.  
> > > 
> > > I'll change it now. If "enable" function goes to be "get" function, we
> > > won't need to store anything in vfio_pci_dma_buf too. At the end, we
> > > have exactly two lines "provider = priv->vdev->provider[priv->bar];",
> > > which can easily be changed to be "provider = pcim_p2pdma_provider(priv->vdev->pdev, priv->bar)"  
> > 
> > Not without some kind of locking change. I'd keep the
> > priv->vdev->provider[priv->bar] because setup during probe doesn't
> > need special locking.
> 
> Why do we need to store the provider on the vfio_pci_core_device at
> probe though, we can get it later via pcim_p2pdma_provider(). 

Because you'd need some new locking to prevent races.

Besides, the model here should be to call the function once during
probe and get back the allocated provider. The fact internally it is
kind of nutzo still shouldn't leak out as a property of the ABI.

I would like to remove this weird behavior where it caches things
inside the struct device. That's not normal for an API to do that, it
is only done for the genalloc path that this doesn't use.

Jason

