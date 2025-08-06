Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57874C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8D56B00A9; Wed,  6 Aug 2025 14:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80B56B00AA; Wed,  6 Aug 2025 14:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F6B6B00AC; Wed,  6 Aug 2025 14:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B70DE6B00A9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:10:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C72A1362DE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:10:52 +0000 (UTC)
X-FDA: 83747123544.25.6B9DA5C
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2044.outbound.protection.outlook.com [40.107.96.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86940C000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:10:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HPdzjbYj;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754503849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhmvRULt71lzNlfdmUfFLRjqdndltyCAJJ0V75nB3/U=;
	b=kZm0l4R63ONJnGFtK6J4cpP4ps9My7wcHZECY9nwoHFvkyBz91MIE54yaVYRI+btVIk0YO
	vvxjF44tCkHIn24ZLImjeRFo3GoXQ4zNpNDUMo1L8n5TSBE5bu9QK9yZbA9kuc/KJ0XgAe
	C8rGBywwPZZuhcKYzLakPuseIAu7nIs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754503849; a=rsa-sha256;
	cv=pass;
	b=RI3rk5gxYlJsDwtP24l5y+etxEltXkW7v35GwUdPLESm4iXV53AiCSPYXw/7s+e0tM5thz
	FeInCos4Bnc9gacQP1HHjQIsUwTboCNrhw0OnC4aguZ9Nf8isvFY8udw6tSSFvLjGUMnHn
	7xRENFuKVcD8frAVeXNaabIBvvWnwoY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HPdzjbYj;
	spf=pass (imf28.hostedemail.com: domain of jgg@nvidia.com designates 40.107.96.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F/xGIwO8l037lIet6XDnEcFADS1S4j1v+xJwq0xbosit3tvuqIY0absR1Ze6wMZ/TKCGl5espW1F2qu9dgEs6hTCxmawYCRVyDJjqkx7uD10rBjCwn9thhOntxISwFDEopAsxahHsMDlteNOsTJTkCdL2YGQDqIORFmMOM+3FPlwgdzAeqB2dGIczqSr30NvwqpnUgihCVGp1w5qoXa+kZKJKBiL8eIGeNkj+On/3ej5JAQzmOa1eNWrANLxLbe4sN9Kqc3Ro6ZWap3O9DIHRdwYlqL09vOTdhX/ylkh+94s1oda8c4XWXi1LgmDah3KH5A6OmG3mbY2sYOXPqS5aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhmvRULt71lzNlfdmUfFLRjqdndltyCAJJ0V75nB3/U=;
 b=OfRNJMP8osnjMHer6JHInrB65m7fKLygp+Zaw4kPvI/fO2epH1i54gQoMtc/g7fcD9oCsP3R4D7x5HQrqLdVpmAjYX1fI1UZo2kgN1eJG+WzQgWenMsETr6zko5fX6OsVPba4mqTddkBLydlbQkDWEzamKI5CDfzaVKtaSIzRY9RSbKuv5DjHhaQ3Ja3mWJpxdvT4gdOv/JxTLdThDEal0FfLizU8YSyasLE6+Yebri6vKbxL5AfS3cu8gjlyHfcdXsqqbB6fv3jl7ZY4TUVG4eb5xOMbSDNyXi+wBRbChzImtDLGpmevb9ks0SJ3eQoWEXQCPq3fIHE7DyNJRxb8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhmvRULt71lzNlfdmUfFLRjqdndltyCAJJ0V75nB3/U=;
 b=HPdzjbYjWyAM0YIrP7JN/Qv9VjR1knp1b+AZSzy3OHlN6i9+poG4a/ygS7kbPE/w4w3CkDMVoi1fhRxxp/RlDzNUfWjTa64t1UTL8F1y4dXdqPseZx0vaKjS9mL46TIOUPMlyIGcpFhRe/ph9w+1c7PfX1sTMRYp8VVK8rKTotrMrTt1QzJRovHrYKDAPXvm4gCIsbQ7tv6J2df+7qgcLOX/APDtSck+iS4VdLgeMc3OVf2Bf1nm7AEK5dtwugkfpvtmhV0VUu7p3ftHZP7JMrhoKtDN8FbN3VFMslO/QQ+wtqqye4OevJQooE5f8r99Z52fZ2sbjCjHdKoMfbogXA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9451.namprd12.prod.outlook.com (2603:10b6:408:206::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Wed, 6 Aug
 2025 18:10:42 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:10:42 +0000
Date: Wed, 6 Aug 2025 15:10:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 02/16] iommu/dma: handle MMIO path in dma_iova_link
Message-ID: <20250806181041.GB184255@nvidia.com>
References: <cover.1754292567.git.leon@kernel.org>
 <52e39cd31d8f30e54a27afac84ea35f45ae4e422.1754292567.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52e39cd31d8f30e54a27afac84ea35f45ae4e422.1754292567.git.leon@kernel.org>
X-ClientProxiedBy: BL0PR02CA0041.namprd02.prod.outlook.com
 (2603:10b6:207:3d::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9451:EE_
X-MS-Office365-Filtering-Correlation-Id: bc710f14-af91-47c0-1a00-08ddd5148e90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wVLnAhfU1oPkeBVGmvAU/NjH/TSeWNoRRIFzWOltqiha8M23FQAybsbpsbZ8?=
 =?us-ascii?Q?4l4viwCu5culuho8iDDBGWEwTq5CXF/Ngqk90oWIfIjUq5vAwtzT3hhe1nou?=
 =?us-ascii?Q?RfHnvfTyjNJJBuNajTKmkrOGxuljQcHezyYYeUOLG8J7e7YhoUfBKi18txfI?=
 =?us-ascii?Q?hy7/LEu5hLaURAAotyzklEoBhtCcuF7b0wjIbikh26fAB0AZcdevouc+gZJl?=
 =?us-ascii?Q?ti3ebAKulXWxzMRy1HKeWCwDMydUyj8or18L2n2kDgRFSozaD5v5MYot+TdF?=
 =?us-ascii?Q?dKxC2QBL/XGhT2R//kxm/Z1i678GXWr53qAvo6Mc8mHvDJOsshvXhzgmGGB/?=
 =?us-ascii?Q?1Y06utPzxf9qZyCI2F1LJWhLSf4aNoLYR7ieU2V2hpnKr0S2IdGAXNglv/V2?=
 =?us-ascii?Q?NbgCREZxnz6y58V3BD9Sto4B8J6D0WmOSREtfBhKzVNd+wqZQEawog1Fo6l3?=
 =?us-ascii?Q?eRHt230nua56QWjnnXCSpemvdaFAgSKyHpP2nrc0T8ngDw+BS+qk/NKK9dKv?=
 =?us-ascii?Q?2miix6/Inv7eZLR4QvFRHYlQVH8fCvteG8WevBDiAT1ifHwyS+kdJMH8MQGa?=
 =?us-ascii?Q?h2oeqnJ+pRCKKqoq3l7Xdxtc06wtRFd1swF3vJw5r9832y4wpSyaBH0ABxQZ?=
 =?us-ascii?Q?/TX07M/n/4wX45/p1sgbqJYIOsZ0f4Kln/pnJIVSKrohhzOpGyheofoWZZwr?=
 =?us-ascii?Q?zXK4lEn71gfSBgA5dXwibv+GitvdQntloKB8klvUD0TvVZmtwBJThY49DnbC?=
 =?us-ascii?Q?SaGwAetiGd0ewGNePMd0j77vgGJ3S9gqeItBg9HkWW8nbdofeXTiplfgFybO?=
 =?us-ascii?Q?lNs6BYW5LAGJmg5Pnawnlkaoh+Nu2SQBxWVZvByCSr2ZHmU6y4hzSYjah2pp?=
 =?us-ascii?Q?1GZgNFRY32XyTX6LfRGJggIvzUvpSKMuFrq/0QbyskUfTnXJtDJqF0u+r0vl?=
 =?us-ascii?Q?FHzw8sLP+mEJIfzWRclp/XpMBrRAtaUz7RJbNp49GDoGb+fHebg/sui6tJqa?=
 =?us-ascii?Q?wBts/fdjF4cWzul1birOsqA2+3Pud2Qkx8i2mJUFiA56ilpf7GZYh/4BAKqM?=
 =?us-ascii?Q?OAzISkmGBsUomFlDjgPXqH/Qtpqizg5ROAIex+09zc5Y9oC7rG28YV1LqC94?=
 =?us-ascii?Q?egOWspWxPkTJ+R+F/qXelpRIyqn/e5juK2Wy3HEjN4aUfEMGE97D0f0V/Yij?=
 =?us-ascii?Q?syps8uDsBntlosNdSlMw7fhzyzdd06tVoGAh+PdjNimZiG3526VvcP3FONDU?=
 =?us-ascii?Q?KeMnRP53LaaCcC4Lr3AycUDXY7BzbMLA+NiIjU7SYQ82Y4tbyP6+KXMLO7oR?=
 =?us-ascii?Q?KZdVJYnIwvN0wJ00oOIphNxFr25xv8l9YxKjGSH9X0lfl5uX35COldoJjmls?=
 =?us-ascii?Q?N3G+dMU9uhXhk6kUq0/AGJnwyceFZ8ROJfy6iKa44R5ANOUgva4Iwo2J4sMs?=
 =?us-ascii?Q?1Yj7dqgsMO4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jxar6JHm676v7S2VA0b2tp/6YMZTPFXTUBggGgPT3+7w2y648Aing5nielgU?=
 =?us-ascii?Q?C8RGQR5E58Tovl/J41NfvXPwqo83HFAte/q1ThYUU8DpXUJ7xyiOtLI1agTm?=
 =?us-ascii?Q?cJCIeUGMb9nlAL6DL4HqITNVhi1xiGzDJTxsise2ikW8UjN21FJkGKqHdOUx?=
 =?us-ascii?Q?X/NlDLBiVPvSQUFkiKhqQLbU2EEshCknX1MeN/X+GTK9p7yYbr6l2wMFcY+9?=
 =?us-ascii?Q?ND2X9L4Sjj6dAZp144RnyvH9xB1EeMcQ3MsqbdVYA2Ohb6AJiP1WZuEE9jTE?=
 =?us-ascii?Q?XFged2dzreWxtqlRa6tgiGz7uZkQbLA36UuQlGNftfAreBjl1O5vF36LOuVR?=
 =?us-ascii?Q?zTHLQ2sKkyx+9cLiddBDG3UiMuXP2mRrPQ017uORc5S9zBMDpq3jpRzbWLRT?=
 =?us-ascii?Q?OVurgCMW1L9Z6zBg53ZYKRLC/qgk+o8quUk6BvWqo6W4P5Rd5IMUWHGHBi5y?=
 =?us-ascii?Q?zdrO8nCMOYop7lH+MmAFmSuLZhUg6mt/5V3y9Fp/vWWfSmLAzwsQkSU7dsgg?=
 =?us-ascii?Q?IAB3+JkLsRIpcJduXAoL+sT45A1wQHO/TB4imafngd0gcyTT8Nm5dui7KsQu?=
 =?us-ascii?Q?ZAhJZZJ3+iEN4Uo6RQYdG3oU5rGuY/gZN0+7fSIcjdEYFy8qUweayZycVBPS?=
 =?us-ascii?Q?uZTvHKGucjLJA2HHCw5BagLz7ijI619ndghyaq4NY7lrrhDyNS6MdJb9zDTh?=
 =?us-ascii?Q?2ZeuZx7xpC8KaV9ALslVxl4yBLn0WACNoPNnnl+qKNv9Ld8VGZa92JNAkL6O?=
 =?us-ascii?Q?mbSbXlRHXr/hjkElMKDR4FLunfOidt0S4xNZeK19Fuk3N2Z55CsnM5dni9n6?=
 =?us-ascii?Q?AZ728B8IPw3/FN4p5QbS/PdWs5zSXzyPNfdPLZxq9RH1sBV2zdLc3Hjj3BHu?=
 =?us-ascii?Q?8LDmyMknR3iaD0SNhgHj6TZ85GYy/Tx8lFGZAF4XQ1LGJnO5FifPUQE4QmaD?=
 =?us-ascii?Q?1kP0GIcg8w798usyvr0wYVhs4GZo5+Zpp3b4dpymUYFqmXP2hQBqYCP1bM3Y?=
 =?us-ascii?Q?h74ncSMb98quwFZXCze2mn/T7w4TnOnr/4Dcp9XX2npo95Yj4h9SYCXafZGe?=
 =?us-ascii?Q?jVL2DPa9rh+ENyPMGZLYi3KcMJWqmKkGj8Jvx5Ypzo0LsTRiHR8GsTpKDvr0?=
 =?us-ascii?Q?BTOXJuD8u1xnH5J/ttsctfR8qI0NZ50tfYg6KKv6dOO7kwrpZpsqHiCzA8M8?=
 =?us-ascii?Q?8d0LTLkulB7BiIULaMxBzFFXkXy/pUia/A51+edj5UoRdDi6Ef7h4QGrxd/Y?=
 =?us-ascii?Q?UOKnpmM9pkkJkhcM1ufy1RiOi9tFwSJhgqM8ttWgYxD0qePXUBTH3eYMoyhU?=
 =?us-ascii?Q?TUzWO08a7crrOTEWta5HWlFQ/WxCNtSamczRCSy2ZnNeSD0r77+9YRkskgZF?=
 =?us-ascii?Q?llQ6s964oNLxAP1n0oPbz6t2VSbJe+pK1mJMbHJFWwYFZ+zSofvu4kiYHzRC?=
 =?us-ascii?Q?KICyKCvRLsCxNdOToQbBeBEJNAp8AcjnYdGopdOCo1EWynuitRyDGJk/V5CM?=
 =?us-ascii?Q?VaBwfFAxVDY+usMsHxhCwVNi8gUwS3FmQuDxqFeLd4A4XIh04K0X4u7fUifG?=
 =?us-ascii?Q?zTlIkUmjnOYfRUF6+uo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc710f14-af91-47c0-1a00-08ddd5148e90
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:10:42.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57xtDWWsAmS2DZ7qtHKMR4Dn5D+k0Cp1JThowypQclS3wEaF2KtlmBeaDSAVaxXY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9451
X-Rspamd-Queue-Id: 86940C000D
X-Stat-Signature: cbq9okiwhe391he5c3pwr3m75dcq5fkr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754503847-902631
X-HE-Meta: U2FsdGVkX19bpOQza/iPCVuhIgKpy4/+3P8ec0UPQRL1HU+CuMaaVW8vncOAHvarK4dMq8pDIKAFZ/bx4iv+vcKhf9YXHiVvI9jFA899mm9tLVOoLhnHFwFCChEZFHzwUBkx2fuY14AnwxavlUGhtoidxE3yfmOZvBRDzUQhtmON+cl/iQBPDrnY7c9Y1OUogoewtJJfG/LMbNs5yt7fAycHGHfly8FdmD6Ah1rzeDhveVsYLSLTPQuqoqB1WfWh0uGzNXrfOdT0anrSPdP5J5LVK2Lfz2YsJ2jimj8gPRTN6maR1WQQs0Bg6B5wxXWQ8zYY3D1Ryh2vd+vC1uH+ZICrpdmtqVjFOHLjFukeAlqO3r2sMhRG5SPyDBCl3aien97e5ey2tBYBhQ+b3x3kyOeiMnUEl9Qm5lBi3kxF/3+VnSZY+L3Tru1iJPjVkwCMByrEd+5UF2wabFs/jSOLrYnFMnMp/agiv2DYQlZrQ4leeUsk34/5XNv7FwP3TuknHBpK2mddfumaxE8PL7CrJe2lEeRsCdDPFg29Vu6/CTUwy5npmL0QJuDvPnIbMaOz7mx62x/vFvSjprx8olFFDrcdSfeqmzG0Ph23DdZ/56tEnVNB3Mdp37zTEh4k2EWUU0QSkJNVeWab2KNAQXXISfSXLUXoll0Ihp5eSVeswN/x0pq322Np+vRO9boFts6gjlnHGtQ/ec0Awxng53x03pAclo8YCePkQvF669/pNWm5hm4wZQDzA6D+ImTVxWGeEyTOIhVvdu3FhcrnexGIAqLw3m3nrJrbH9lmAN6F6mEmuoCXYRZ5NWLqJvau6k/dysnl7CC80TTb7Hsme4UO8RDbf5gHVToMEputf1i4HEUEGhO3vHhOwSfc5AX/yUNMWc8zDsMQXQNBk8q1g4gCubGtiyvE4W5it/580MRVFwyTCM2P4pNC0PKQBHG6HdJCRCeOfK/vW1Sd2aT+eJ3
 SRhhfLxu
 Mu6az2ab9Q1Gzpx3emJDMwCcIxCfcg19hzZHuw7x672+Eyy6lZBUcQlpZ1UivceSNjptb6e9G4m7PpDc7zmSrAJXNuCorCj5grGoNnNJr611kxIsBCwLjVyco/6hXMZRuTBBie6139uiD1FYEvGBgO+3nYy+20pMKxWHL8HPAwKBWqJO9sxJivwOpmyjEd1cJ/jSvaENHGzzeZYueJD+FSe5dAhNd2FV+Y/Sj4QP+iuXZLehtsEQen3Kx7wKUmh0fnWevIubryxbQMspp2wZljagIPINZp8dtppUlzhN0kQ75NSjYjRG0oivaJwTv0RYjfC6gI4jN86LV40Zk1oWD6uk5d6gSxcWman8CEjqjOSKfOeRNGbAbFQxPgskfioBrEZ8Uu0Xpp4nlPqPsAAv3mxN53yFv/XG/8OXHqMDSLlQz6/bvdivYAmN8X6FYg1g4DkvRlc33VpzkUoujhRNYEapbQyGYqIDRfFGssJyLtqcWgs6+R7H0xnqzCOGAMJF0lq4zDA7jkWTiErGWZV9bf3mnhvYnfk6+POL6V2PQfU0QuRSUfMYk+AzxKDhS4V/c9ZCSSPiKcr2ZPAOJUic7Zr6I8Qps6/nt7RN2E/kzdX7xqQc0O+zj9DlKehrDf55960zNBrOAS1hPeFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 03:42:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Make sure that CPU is not synced if MMIO path is taken.

Let's elaborate..

Implement DMA_ATTR_MMIO for dma_iova_link().

This will replace the hacky use of DMA_ATTR_SKIP_CPU_SYNC to avoid
touching the possibly non-KVA MMIO memory.

Also correct the incorrect caching attribute for the IOMMU, MMIO
memory should not be cachable inside the IOMMU mapping or it can
possibly create system problems. Set IOMMU_MMIO for DMA_ATTR_MMIO.

> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index ea2ef53bd4fef..399838c17b705 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1837,13 +1837,20 @@ static int __dma_iova_link(struct device *dev, dma_addr_t addr,
>  		phys_addr_t phys, size_t size, enum dma_data_direction dir,
>  		unsigned long attrs)
>  {
> -	bool coherent = dev_is_dma_coherent(dev);
> +	int prot;
>  
> -	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> -		arch_sync_dma_for_device(phys, size, dir);
> +	if (attrs & DMA_ATTR_MMIO)
> +		prot = dma_info_to_prot(dir, false, attrs) | IOMMU_MMIO;

Yeah, exactly, we need the IOPTE on ARM to have the right cachability
or some systems might go wrong.


> +	else {
> +		bool coherent = dev_is_dma_coherent(dev);
> +
> +		if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
> +			arch_sync_dma_for_device(phys, size, dir);
> +		prot = dma_info_to_prot(dir, coherent, attrs);
> +	}
>  
>  	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
> -			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
> +			prot, GFP_ATOMIC);
>  }

Hmm, I missed this in prior series, ideally the GFP_ATOMIC should be
passed in as a gfp_t here so we can use GFP_KERNEL in callers that are
able.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

