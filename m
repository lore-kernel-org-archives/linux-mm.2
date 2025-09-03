Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8658ACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1A78E0009; Wed,  3 Sep 2025 08:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A62778E0001; Wed,  3 Sep 2025 08:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929D58E0009; Wed,  3 Sep 2025 08:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4238E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:43:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35B2113B4BE
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:43:22 +0000 (UTC)
X-FDA: 83847904644.03.DFDE4BE
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id 71CF520013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:43:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RieRX0rW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.220.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756903399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA7qH3RBngbDiPDaHS0LAPVRXB/NhC5VF19iAp5pHs4=;
	b=L5kIGrW2mCUBnbrBl5jAysyLOJ2VUCVlmE6/vQtL8Ux3e7JBf1pIw42B52tf0+EHaEbKsI
	YnYZz2NXqWDKe4cK0886bswsWi/rAzOMhmI/bOnFy+v05qABYPWKRfrk4xZnSF1oG1CGT4
	sHh0GvrU3eWVgzzkXxaZpCX6T4k8z+U=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RieRX0rW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jgg@nvidia.com designates 40.107.220.66 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756903399; a=rsa-sha256;
	cv=pass;
	b=e4TmGh2BzSNOtS9K/jJo6v5DHFX/I/NIpGeJLSUMVTsh2tYZO6VfmAwWByuPg4ZOOzE+KF
	0M0vTzaaIORuYdH61Y/WgXXkrpd7AQaAPIXxEIrijVVhepr5k4ZK2ZRRikP3LNJXlN3noX
	c6WwNMBalvda8Z0IeXanXX1Xe9gG+iY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GsKYUca4p012gCmh48lGX4VEuVdMYgIp3xiDT2g4Qi8wxofnT30FDWX4ln62efglvf/Q7S+uZEjID84+iGlc3+Bf0Id1ul/1s/LWpa3VWgnSt3G5QL4H+TAdWYyL8v1S/WAeKrGxYXSdrFQuTtKuDQjJi1iaP8bZh0Jn+E9H+2TLtJgJ2/SRhEESA8UTNKyynxMoDpta2f8i/Q5u63Bq1IjoJb0D5CBYjaPqA/rNCFC+9yO75zHZjS5BuPkACy4TZhcg8+sHcKf1WwiqG4ckyT26HWD69D1Vtuq2P020pI7oOMINESxCMAN/ML8k3h8UvDbeileD97sBaHrw93n0Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vA7qH3RBngbDiPDaHS0LAPVRXB/NhC5VF19iAp5pHs4=;
 b=By/2eckztJSDcXBiB3r035qcecJvNJu1BWcpASYUUPcR9kOHGKu/IgI6AOtNRQaNFw9am5QPcJ5nh5imiUFsp6XlM9szSC2hKwwLcMWwyOSNj93tiiFp+FPbyN4r6rtuOLeTZcTsqluUi7w9hsVMM6woTXpzLbKwi34h9eeYJmxjsDF5quW6ahECrjvKKbNH7YeJ7nJkc3It5L1AZzU6z+/j8OU7Db2KsXgqDucUoefA8A9bh5RjH8yrHR0HvWptb4epQkoxMMdr4HTJmnUoEr0JLJ1WkERIqD/2UXAyKsc2N6yp6c9nC106B4toQ2E98D1Hv0o/QauSV2tZULhAow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA7qH3RBngbDiPDaHS0LAPVRXB/NhC5VF19iAp5pHs4=;
 b=RieRX0rW4aKVUWByTX5f1Y0nyi5xg+cQHvQglxUVlvyvSaJ3edYiZ9cK3eRQ4UV+EeRgwxeXCSBTF5uKH0OkrZ9QMA6XQ4CYuxKS5BDK+LWpRTcQhsqqZxso5Gz9w+OB73Vo+1jz1idgbQ6BbEMx4Su1egfzumjCUeafFJkoJ8IIMldn7YPyFpgBcpQMbqrftz0qtmPj8/SRiFdNLv3IT+nrtkzo+Mi0zmHF14ZRjhZeJMO8ufG5kLhFjqaBIxA+FfE/SYdGQEYOg3uhb0MI1YDLd5NK0czLwdhKErKn7d74KyL61RmUKE2FsNnBTxOxdP8BbHs9EXHmshuBpRIzVw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH8PR12MB9766.namprd12.prod.outlook.com (2603:10b6:610:2b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 12:43:16 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 12:43:16 +0000
Date: Wed, 3 Sep 2025 09:43:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <20250903124314.GF470103@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
 <20250902211514.GQ186519@nvidia.com>
 <aLd8l8v_DL75NU43@casper.infradead.org>
 <20250902235740.GD470103@nvidia.com>
 <aLfIEKLqpe_xB7mW@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLfIEKLqpe_xB7mW@casper.infradead.org>
X-ClientProxiedBy: YT1PR01CA0142.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::21) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH8PR12MB9766:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da1f1a8-fa7b-4187-3268-08ddeae77439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OzAKuzvt0a9hm51j35ddRSuMLAkK1YWTQbKxRUeSoGzqNaIi4LmLNUVu7rnL?=
 =?us-ascii?Q?9FpXeGSMDF4z9h7k8SFz24b8Nw6e/DHOTHWax1o52sivuUsg6BsDKUXWstif?=
 =?us-ascii?Q?JP/DkjZ+unkG0z/91upkDvAnpS/dVQzyO56ibzZLH4zVKd+LGqDPXqeoYSRk?=
 =?us-ascii?Q?2NaawvDXKb+uzRbLqrRgi5M2VHmkkLmUoneJRS6DQmxD3ld8fUU4K1lSWiUt?=
 =?us-ascii?Q?Fv4xG6OnyboVAbbd+roPZIviyAjMnbTcSD3zqMda9YE7WyT1hcgFJQwk+9Gg?=
 =?us-ascii?Q?W3sAH7maBgG2e4dAXYez7IbA0t0u1e5nA42ObgL+rXgzaat2I6VxidXvnFI+?=
 =?us-ascii?Q?1AfNDAYyQS1w0dyIeTx+9wzB40b4MMJkE/YrHu7fGCT3j1Dkk5KpBWNWU9za?=
 =?us-ascii?Q?AJwFwaOYoFdhBfK00rRvpzvFO0WFTTE8wabFpxTyS8w1gvZqe6Ps8sT1vj9L?=
 =?us-ascii?Q?TcsDi9+pSMDYD4nxP4kl8hhEfSk5BcmfRcKSptS/2ZwhrsCUM5IvA+//ZNCH?=
 =?us-ascii?Q?z0N2k/H9j9pwhTh4C17fEKsPeEpaCNXxQny+iZ+YjeDkxawvWKHYnPCoY8I6?=
 =?us-ascii?Q?2LIzIc8mRUr0Xe1vYVlg1MjGV3IA7MyjdLAHOm0tZ4dAWKntJ8QZZkPKXXQY?=
 =?us-ascii?Q?ICcpapn4e8rDZHumnURpK42tYMD8AN2DN02EYXBufrFOXAxudn0cv3Jkuziq?=
 =?us-ascii?Q?0DR4Bi7tFWT6qXbqxiP7Qv5iiZz+iX7jeOdmIIpFACVFQVs6MyLq3MyNLWR/?=
 =?us-ascii?Q?AXizRHMN+53z54CGIKQVLV8Rvpj/59ycj/SmUkP8LA7gVj/5CXymgR8FmN3N?=
 =?us-ascii?Q?cF6QMNzyUEiBvSUZUprfPH193onH+Rtn8iWM8O3smvADYrcJWYrOnYMs3XWF?=
 =?us-ascii?Q?sDiXudrKJPiQPVyicJU/10wKRq3Co3vD2GHic0MC16tDkLFr1BPOyreosNxB?=
 =?us-ascii?Q?QIqXB1doZbFbcPkY2k5Aw5q86vfu4s+TmUtm5gW7sXdE3xTVxXYM9JrFAmn9?=
 =?us-ascii?Q?GK8LPvKuJ4R1VIgATSht3bTXJQgc5p5aHHfP21/LI/Up47aafOGfgoYk1lUC?=
 =?us-ascii?Q?mwWT3KRaUzg/cDWIFeYkTRE+nSbiN2L2PyTtQds46PT4BWMeYwzfq0Jt0BYF?=
 =?us-ascii?Q?cVQlxyNTFScnPMc9XQf5vToz5kuZiuqM59d8u9zZZ1dAvqaxrM+bp7EGCJRM?=
 =?us-ascii?Q?y9dBRUkNOgKVNpScxqR7tqBGd6ay+Cm72Zv30WH/bEouRXRID5P+nrvwHjCF?=
 =?us-ascii?Q?j//kFEizbMzlpizxbf7WTw1p3Glx1AUfrtsIu89CK9Zngl54+rQHekZPVsqM?=
 =?us-ascii?Q?tTzGafCWTOzlhO4b9Btehu3r7TnAQ2/eWukaz6G4lpJRwbET/sr0rQiwABLF?=
 =?us-ascii?Q?m0qFZnlU5sEI/qIsNQusXVTrhkD9ygFXxRPFPMMMALBFF3+4Yz/Xg9bx8Pkr?=
 =?us-ascii?Q?b6Oyt2qzk5c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZELyOVLOrh58cBiS4VKejhDMtuebFkfBB9HhDLnTQYYhZjWps/gk/NilizKI?=
 =?us-ascii?Q?koVEBt9mb3ootlx6h1eEFobx2nyy0RaHUgprdHx8KLp/UZ57hdiB3M471SCx?=
 =?us-ascii?Q?dLKTu8iZhWSP2zwoF/n8UU0haNqI4AJj+ioJnyuP0eg9y4nW8tJYA3hB3dbk?=
 =?us-ascii?Q?Onv/mufFF4Ntyb0g8sOOoFMephUMh6kxTVZzPa/YckOqT0NzstYWDR2aG9V5?=
 =?us-ascii?Q?r/ZFqU1Y1Wqfh+PVK7/pC9Vgu73rmPKRFfZkcCcoYiK8WtxnZiqTPVZ2rfR7?=
 =?us-ascii?Q?naHwHYl6Dy+nt/Q3nendX2PXC+F4OAJA7x1VzUMklNc0fb1Q8q/UUPYbgZdV?=
 =?us-ascii?Q?FeHgj+zc8Cl1UFizj5mUKytnIvS5SdZj6epbPuqJoUV7uP5PPEpOR1YeJl92?=
 =?us-ascii?Q?0RW1GtrxfRft5J4KN7KLUq7g+pDjRNerTbvQQVOX/3k6d2SXHVi1/HMIeQtY?=
 =?us-ascii?Q?A0ByF2jLAOX+Dv+G+u282+5MIBFNW0FDbzRoKecnrWoL+dL3EbKIt/CvhZVk?=
 =?us-ascii?Q?Ye011knElaGcI+0l6Q9ej55Ukz+KWtNQ6WDBMUDuMbuPjacIhfmPSk/oGwcV?=
 =?us-ascii?Q?0INQjMXzH8OESh0iQgy8mY7V45W2yvB1ME+vNPxbQnET4ZvoV4jCnyjJh9l1?=
 =?us-ascii?Q?IsiYRs9xBwY+8A6JPdf7GdtdZho5F3LKe5GyeNTDK6DHnOXSVAWsRjwvqkoK?=
 =?us-ascii?Q?6YUdP610pudBKvON375SrG128yfwyzXPxr8M3SrMPI5QSesTJZnnMZgX3Pxh?=
 =?us-ascii?Q?LehMvDCqzuvpfYuRcjVBLkWDn6/GderhufRWpOOWbLeRLZzRxJiuCbmrNnLI?=
 =?us-ascii?Q?EvkuXhyeM15h/AhVcFxbZH9ywo7rwUMpPCuA/1LzruSLUMLjNX5V50oEX3Pd?=
 =?us-ascii?Q?HYgKt/ZCsQE5Ljz/jD4VW4kSKOMPGaV4IFD7fgHHJ7LRTFL3dMzTL92yeR/o?=
 =?us-ascii?Q?NeKue7xSljviGQ4OGFnDedesDyhuStJjYZ5mhW6dKaVOcjT9efnAnuYFVscY?=
 =?us-ascii?Q?p5nBuZC7FyNJ+0nr5mh+PrxFqMbGF12xOETZ4gzScNAfxU1xCptdKRo+5Ykw?=
 =?us-ascii?Q?1d/kqKNliCW1QWX15CqmOVciWaO/V/1gJkiNhfyLxqm/AFHj5WWZxPFGNO7K?=
 =?us-ascii?Q?Tj8pqIjYsPYk+JYs8vHIiOmDxWXOYg1Dt9e8DmJ3d8b9IETy1BVKw9kM0rFz?=
 =?us-ascii?Q?w4dFTylGq/qiDAgU8tyIzNnJ6mtadjRRtq4EVKTI/2H9ojM/u54vt6xfyFc3?=
 =?us-ascii?Q?H1wG4sb1SDdU1RmaMirJWf635skZ5wtI4T0IU6NkuCK4c9648g0O4rrst6Lb?=
 =?us-ascii?Q?sJPPDZBXpvSBK0DTA34A7Nr01OK3/4zfnBmckbTl7LeHFFNDxnGgbkJzm/pd?=
 =?us-ascii?Q?i5kyUNdswWLah9oqPnkt1nL7LsWwjIFYqfY/ovfJ7bPr2ADpt4jBqad05tuG?=
 =?us-ascii?Q?LFRmaPQkQibXBAR0gQSZxXG8liYvYLOTDJc3mxxf7s8qcXqhEDwX++CrwZYW?=
 =?us-ascii?Q?N9yvlOJq9EMIgQEMo4c/XJhiY4JjKFC6BUdcjYJTBEZrTXirzioBnVaBxwI/?=
 =?us-ascii?Q?w57fz9uk61Y2KHTRsKw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da1f1a8-fa7b-4187-3268-08ddeae77439
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 12:43:16.6256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gKbYppeDzSIJavXjQKkdcX07d77qIy0IhrJ3Oza2hEcHiFYNrkR1yhsp7haKJeu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9766
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 71CF520013
X-Stat-Signature: niqp9q5pcej6mnr3nufo9nqkbmjm8t7w
X-Rspam-User: 
X-HE-Tag: 1756903399-48734
X-HE-Meta: U2FsdGVkX183k8XR5IXEuzkrvh73vXyFv4Iomrj7V9jQnwvxNZze1R3AgflEW5YOpMKmnW7Gk2a7CUGZ2y89iwNDQhQ33JTO837uKvl+fSgTVrpNnvQVqLpva3zJr+h8saiY9MvUET4sQyYZLmLWwFhBTJEz+8yMjn4I9a0acg/y5LxEbe2SPwkbcCygxgqeFZ0TljUeCxKE2gJ7q3zVzSOtXOHbXv1FputeDIfdmtkP3Iq72zdJftGyXTFou30pF4rOntqXcsNdsEmgp2WXR7FR+ue7jMPSMIDYFmi/HJLOpfvXt1NMB9ocmOy1CshLaYK0UoVezZr/dcXFd5m3Y73bA8c71X5Vvrqm2nngvh0jENaW5we3BPOQsfHHXjleM8cT7hVIFERE2FyUMejibm+36/pgYq0Ee/T5tqfNiozqd+kaQNrKjTbbi9N0ThYTaCVCe2YRLdttsNpsfG1x543tvYJzigjkWV3iLbrR4LgSeDRNeGNlblig+sfDhT2lZrH7k7IdsvpkbsSOOJn3aVHhqUGYvskkJ6NWYtMdBCraGL/GHKNq1pbdzaLjvJL7wNa2ITYffGDTQxWK/vdJUv/3FWhBI9I5pFVqIGjdMisaZ4lL2DYdAXYJm6lx66y/VO5beI4Z+vn57Oef0zIxF4Csjw8NOR6EZNX0JZGb9Rcv/akMGy9vW6pizzOlB/SPSSqEFOTBdeJf70GJJjc05qroXGXx7VzPFjVB0jxAARm6thbnmYF/05VCKqFZ7oYpU14oa+burCKbDY1eWgDuz/elEc9NW8o+t6lnCr1JDzI30R5nsPWZGEJdq283PReg4mzCNq61nTzm18seF7r8EUtvAPDK+tlUGl91V5+KThpDLXMnlp3OZrZ1/LpcP2juA5WRQ8y4Y7HGJ43J+sInHS8TaSkfawg8QMBm1eeuCr9Lh0mL1pILG1uunoBzQIHPCFGhxoLCT1R4X9dIKc3
 kIXndzyQ
 Z8eFEHqbCSsz4Pd1K6hPCwnMuBx2GmsW1GQ7Dh+oq6pP33BozWaU1QbNVPfy7fCDfWuTxK9klult27dtEMODqb1GZ9vDkUhNbOz0mmY/JpxY7zHkvUD4F+TSMEP0/KlRygUGd4SkeZFrpdN1VWO7LmFOCNTmvrOavN3gXOiE2pRHurI6DIpR3fy9i/Scucw/4NiW4HWtwIpvapHPTXOr8wGECzrs4YdV6ntbOTToZPsmOB4LMIw+UfpwIzS1GoZAHOtocbdwOeAGuaIt/b6SrmwKOlc4dCtMlCCrprxFXy4yTadykSswawIoObP6tZxgtiugTYyyEM4/huUJNX/SrSyIEg/nx6FmuOULAs8nq8ygyvhgVq9u0cDXT7w5vV7SGrsnq9Mc/pRWYLJOOkbNiUoZpZBlDvr+4C10g5zElc+YzNQZ59UwYIDqLS9KiJLKzfPmTLgJ6TcSiahJSQAsz+zIAFe4/l4yHjlxRt5DRPbDJUPv5qYh3tDt/2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:46:08AM +0100, Matthew Wilcox wrote:

> Once we switch to memdescs for these things, they no longer need a
> refcount field.   By the end of Page2025, plain pages have a refcount,
> but folios/slabs/ptdesc/etc set the page->_refcount to 0.  

Reading this again, I didn't quite get this till now. Maybe it is
worth adding this detail to the wikki.

In this case, what are "plain pages"? 

One I can think of is naked calls to alloc_page*(), which I see often
used in place of kmalloc(PAGE_SIZE), do you imagine a project to
favour kmalloc instead?

Jason

