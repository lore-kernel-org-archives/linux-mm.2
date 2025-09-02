Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC6ACA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6A48E000D; Tue,  2 Sep 2025 17:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656208E0001; Tue,  2 Sep 2025 17:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E5E8E000D; Tue,  2 Sep 2025 17:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1338E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:15:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E170DB91DB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:15:24 +0000 (UTC)
X-FDA: 83845566168.25.5CEDCF0
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41C8CA000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:15:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="r5ztnYm/";
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756847722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqDnGrUZBMAigW0zISVJr3IcsSvXmUJyw3W/r4ty3dY=;
	b=Jiu467pJgA1QQL12u2kLx/OFJWclRJo1L/X71sId5UjM3FJXHIm4j6LqgNkUyXXVl/lC7D
	NGWKJBAeB/rmESwzhxW87b75AotmpPuM8UgrY6HS1IackXETyETYN2rD5U9uCvFAGAi3wP
	DdxQ40LhwMZ66ww7/F1tblC4imMddrk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="r5ztnYm/";
	spf=pass (imf15.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.40 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756847722; a=rsa-sha256;
	cv=pass;
	b=JZneMPexyVONsL29fclZt3FXXDg0bBsB29SmH6r2mQH+NHoWvjdc0HNlFo41flQnn7MyQY
	wYvcchZu3fnUQbvKTqh0YMFejhRRSm6uPF4KqLmY5yiLisuf98B+mUSE85RY7wauAVZfTK
	3AOocSBdRUVBoDnfKkEk5ge1iqheCCo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZ1dnsBtKDOx2VUZybG95edTXbJVuwz4k1uvP6cB0FF2Mb7K7dRUS+Q0HJzeYT0xeBULFpinHJ6RxPXyjrLu+TVl4gCGNJ7zSZx3c8Dt+SZqkp9mzlYEBlY/shWFZOWPuqCCCn9JOcyZljRF+bhjEp0WIYKQ/ayT2pMJhLjCOiRpdYK7U/fRYeqaPv0lbWSA9/AH0fRaUOnLHk5N8MZtFcC0+VGYQfqF9LClEo1E7AS+z63T8qWrRO0RnqSBeEL3yiLi0ulDosR8giu6M6p8ZS6RVNgyKS4sxb7LeY3J+iV8dUf/rY+XOCvjMSP3j2ghziln/IVWweBhdXdm+aUfFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqDnGrUZBMAigW0zISVJr3IcsSvXmUJyw3W/r4ty3dY=;
 b=DcnGDrtivPRxrb9Cgxe0J/OhWtY/q6BIwoHBOpRXI+A943dHMONgdF1x40sgyTJe+V2xgu1dqTn4jEtIa9NdY7DI2Eo3EEQWcFcHEre0I/AdbqTW/UQDpB/3RlqN+0DBqhSY6E02knjT5OiDBkIJcsDG7/V4PFKSuty7m+t7l4O/mg4/M8oMQAQ/kEyHYHuCaK4HgznouQqxPxl/yOOua6AQZQuRyeVgPMtck4vEiui4BOwCrO6xA5427bC5Dl8y3uRJUWnaEVBOmO3l/SRcdJhbk32XaNvutH3t/egTw8S0bGrCB0gL99kS736QnwcKRp4Ped+P6VOoXHFECvaqog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqDnGrUZBMAigW0zISVJr3IcsSvXmUJyw3W/r4ty3dY=;
 b=r5ztnYm/rTdjjtB4O57jGnb+hJ/giHkdPGDYuB59xObngUyTEGrkbrYuzTcNX+CSIaPYb+XuWcsf1kSep6u2ElLGhJeumrqpuTbxfu/b0bmRHh+r+A63X3XuN1DzfagA/MczN+Ypt5VsNRcH7LQD3X/0Xs08AuDz7GL8A1BR7sF6k2tZCQO6XOrCQYgARaOyqpnHWT6zIiN/w0/Xh79veQCe7sW0G0xEw9awFd21U9ubnK0xdKVrrZELnrpZANl9kkopvrjxWuMKHHHoqcA8gOEdkcYqnMNMQi3Cn9sseSZtwR9uMCqOuEzKn4LvwBROXbpp2rfaYTsz1i3Zmo8DXA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8912.namprd12.prod.outlook.com (2603:10b6:610:169::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 21:15:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 21:15:16 +0000
Date: Tue, 2 Sep 2025 18:15:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <20250902211514.GQ186519@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLdcPeb8zrfDwd2p@casper.infradead.org>
X-ClientProxiedBy: YT4PR01CA0020.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8912:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a7a3b66-471b-48fb-e9fb-08ddea65d056
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B306vuOq4l28RqfoaICHvFapVJDhqz1pvUBLqOxwAR6ldCJLU0J6Q9EABJta?=
 =?us-ascii?Q?+x0jnjfZWAZOEeYQBaXxBLnlB9BAqOK7zLsYuTqq3qh7pR5t/GVJuOitZv/l?=
 =?us-ascii?Q?G72Bf4omsGvix5FWUNVTzRwAQXsyGpd4liyST+BtgsFrC+VArVm4tmsDlQO2?=
 =?us-ascii?Q?VHEmcmPHwXxjlFQKdnh9VbXwR5gdQxqTuOR+0s8X1iVzksCk3+ws2IO5FKEc?=
 =?us-ascii?Q?pxM3e7o/D2tb7erbN869l+PWRFSyzj11w9YdM0kcxDi3JHQdAo1sXYBc/kxV?=
 =?us-ascii?Q?eMmR3zn7HHL1hF/TFocng3FiEKrsPlvBSPpjS8wDkoHNwq2oDn2Kn12pr1yx?=
 =?us-ascii?Q?cBMcpVmoDDQkSUxJ++5WfGLeszGegBTrqfwMIV8GgrSQgUexsR9jy8zgpffa?=
 =?us-ascii?Q?G/OsXo3mAJsGrYfhtPSb4osFqvsXc6TIFfLqAqaKATghdZ8TAEGShswAWYpb?=
 =?us-ascii?Q?ouSyaeIFvx1/CDfkWUo7ztiI3P+eOJh4n0fJFgFoDaLFXOhuHb+K5txOI/MW?=
 =?us-ascii?Q?TUAPGIzQGonJSQ2QRLFWF8g4351NMzx3VmVCNbLggM2nZl4G2AWlOfAd3E4S?=
 =?us-ascii?Q?g5G8ov1UsOVDv2z6IG8yUD0+85o0ck4blUYtj4lljD0GClDXTo1eLhtmTUdx?=
 =?us-ascii?Q?KIEjhW3K4PDueBZTbxm69LON/lv7YjI00pPcx/mDznXSDaW9DB6dJKcXwc+6?=
 =?us-ascii?Q?UhS7END6MzA3IZulB+Ceq6U6uRwPgQGBKGrubr4Myznb1qxk9jhaDV1qAFEq?=
 =?us-ascii?Q?pBMVk686NG4M+dkkCmcZQfSpVGAKetpupC2kkj9NDdwgSKLGZKOLLVnesabN?=
 =?us-ascii?Q?l3skxJtNpMrKZtFYRKYarjgOp7doxIl0AqfUsr1SZ23lz2btqaHh2tyuK8nR?=
 =?us-ascii?Q?TJfwKyz4t1UI1boHNGd5ZNCNNmoW2j80/dGNMqH5skKMLAs3jLkJimFqKJD2?=
 =?us-ascii?Q?Sx/Exj8YOIgfGQFD5BBX6GK0pBGIVovO89gjIUkgr7P7yquDLckcHeZ87O/w?=
 =?us-ascii?Q?IHe2aITjodvF9pz+8GyKla4pIbJrJacvszsicyPUxI3ESV5LnZBVg7PjK/1T?=
 =?us-ascii?Q?xY3ogkU0wnge6Ke7GKzD4IpgfeXJ61ovXmIs28+Z4NYA+nj109o1u2Y45Q2S?=
 =?us-ascii?Q?J/p5vU/2goNvRKhBWkMy6GH+aHQlUAdUqw/tH3vrQ11PiYIFYzu9zLlPqJRi?=
 =?us-ascii?Q?6D6C4IrDY+wwCUsUaV6SKYWP4PibVSp5DLNDy2LnonDBBw9k31Ccpbzhn3uB?=
 =?us-ascii?Q?cpm+QqarlF1LClW6IFysqFxisqvQ/n5uMuBkrL1PHKenaB0NHClFPkurwWAf?=
 =?us-ascii?Q?5LVboAqbAu/VLm7wMT6mPiOO6R8TIBEt8vyhTgXdOV4U+TKmTzG4nEduvVul?=
 =?us-ascii?Q?08FhvT2QCjXSLf3cYQFJDNRsJZCfU1wN9gc9sKBfjb+A3GB9+g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HchQRo5vQdCxgZfAaASKrj+GT4cr76YJy2hiBpWThp3k+h6JTT3/RMQUHc/J?=
 =?us-ascii?Q?DIagywDlRapvYoOdjykBDPK3xzJYqvn3wnSq3OJa1xXjZqanZjTBL4pVVA08?=
 =?us-ascii?Q?47DbTKGsvXXNUQeDmQuFwYDVBA8XRpC96nE76zCDOv8qTsnaMdjcTmPGfhGV?=
 =?us-ascii?Q?l/IUG9mRWD2TQZ50SDJL/lCKS/e2Tu2ZNekPBSMO97Jpz7FXX4J0exnrgNML?=
 =?us-ascii?Q?eFI1ihOnhV+RbQFl90NXhEbvQf7rR7jy1aegwSRSQ7PPSnnFc9rrUKSe5pce?=
 =?us-ascii?Q?zU2gvq7mt4SWhgtlI8BhjDIqatSF8JEQSJHp1WxMQDXjXwrDPgrt7VTyvGJS?=
 =?us-ascii?Q?JTx9xlwqBLqe/3DBgUPcKF3gYJA5gjjT3YX7ERv5bTGc+0rc/abHBVu6Zm5k?=
 =?us-ascii?Q?QmjsvrruJBDlUU82nKMWtVS1voVDAPEL0c2Ihq+joZIWi2+Pz+VSGg2s0jih?=
 =?us-ascii?Q?sNoH3C7aYtn089k3Ln7YOBrJVVaZFycSTW0JQEWzhVdsMl1rFXmp4Ldn970v?=
 =?us-ascii?Q?h/CUfYC598EYHGXIAsvykw8JwR822a/rqEDg3oUdMFPzvmp5ccxRpIbkjtDJ?=
 =?us-ascii?Q?JMt78XmNbdP4hwugNgmPSVqwx4cCOYWK8S1PgZydbUp6fN1OPI446k0+SCaL?=
 =?us-ascii?Q?4s5/L/cUvuOUr6wnNsWneJ18EGSWsV3D5AV5m6ROxYR4dn9mw3Z0x9LarmCR?=
 =?us-ascii?Q?fzrZ9jDAAgWOaImwn2v31Ra1NcG1DNJ7YcDCgmKHNa/DRujHHXi28Hllqydq?=
 =?us-ascii?Q?pdqEGNL4sS/nNN9myhkapx54wKVHQUDv4SSP0SMg6FsC7BGu0UvX+k6T8ZMi?=
 =?us-ascii?Q?D0BuLoE+RP3QmmpS45YtbLSQ5I3eHVOehUrM5t10ePD1fFm29Y2YtYe4l9TE?=
 =?us-ascii?Q?95PtFWd4yIHpGHUFVx+j4BprQfUf0lnDK4nFKWYO6H2991qmRGLEWUS+oRpq?=
 =?us-ascii?Q?Ns5gWt/YKbKf2zRiedOqYwYdTLmlhUOqw1xTxeTkV292bUt2popKllCf0IUU?=
 =?us-ascii?Q?edgJdKzby8aMSVZE/8Zs+7n6dEXXCCvN+QabsOcus3vRt+Z/uAySoTnUE/9B?=
 =?us-ascii?Q?Nftdy6/OrDrML0aGNWls82KX/aLMokjpwDZmeqm23FqYV+MkxbGYpiGR3gZi?=
 =?us-ascii?Q?rG9EngiNEIIURzx64GjPotH2AGm8708F2NcGr78m07iyLD1qFP8Uw3WIeb1v?=
 =?us-ascii?Q?+tFGcUaj5xX6zXjQNxq4xCEwy4A08sRQziZYHbBGLSUUFKN90EOIkqv7dq5S?=
 =?us-ascii?Q?b4a8oDunzR9J3imeNbaq5JIED9W14FfaMoCFe34L2T/v51I6BiFCR3K1HXyi?=
 =?us-ascii?Q?nBo9AhEPF1POqnA0YeVV3H6ntWTysDAKDbhhj55iHRqsL5m3gWlsc6Um+sLA?=
 =?us-ascii?Q?fR4CtZ88GFWTpTt7AY6gb/SdhqKnQoFkbDpVN36gD/jezQ2EoIwnY9F373tp?=
 =?us-ascii?Q?ICV8GMUUi0NhXISnXO3bx6/2g+99Dqe3upJTo7eWxWQENbWFGy03S4QpmrNl?=
 =?us-ascii?Q?X3BuQr7nCxXKaWm8VVFcZiQYyl6MJBEQVzY48B6m8B8ikrCC3b3mklN0+ECm?=
 =?us-ascii?Q?OCKUxij2kz2GvG0A8gY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a7a3b66-471b-48fb-e9fb-08ddea65d056
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 21:15:16.6576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3TR1jK2GRR/06ClZP/64wKUW43gkmwKUrtFMJv6ZSqombK81kolgjIwttyKh767
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8912
X-Stat-Signature: cxatwgdpnpf74p1b6yd9qgo7b4kk5ir1
X-Rspam-User: 
X-Rspamd-Queue-Id: 41C8CA000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756847722-993115
X-HE-Meta: U2FsdGVkX1/jwln77+Lj98koXj5MV4yYv3yPpdYFrdpJKdjUcSB7umsYz6+t8/vzctJ+ftmUox/weiKNn1VuGTpo22mJdUPaJnY+J4oDjqPqOKfi1D+hFj4a9aQ2GQYPwDVrB3zmp4tKhHt5Ib9JhwihuIqIdAJJsb40wtfq9Jr2Ya4/vxeqo7VHIWt84nhUYVEtOZcOvdgZsQyfApN4EKxTZe0OOva35/C0InsepuKZoJwVup04Wk90Jekqy/pm+7t2QST0NhlwfJY4z2TazHEAJ9BLXMHZ6UMVKShJ49Mr0UsM43XjguTC506JAWmbJ0MbZkvD6Hqb8DFvOHilrqq/ylTIn1h4Q8tx2TW9UBQ7qQb37cyDvYqmZLs4ELTX4b9kIf0gA9c9bwc7kDuu9Bz/TaSO6isQPOSzmC8iQqY7dnVJHfbHu8kJaFKlVfjSqYkCzKlvjznAYMq2uBounykoy/wyLNZcx1FDub2U+ZKItaLN89XJjlZ2EGuWP+9vyuxQnhRwNY67kZHj9oJGtJp59MX/phy0LIHKyar75zefRPNKoxzsJpzseFy9WrlxAiZMMRhTSFCQhKR4Atsk07zHUXyVC6e1VCry00wqkYMpOeETS6TuPBjwgoxiiNFo4/A96OpytUCbDHhHLFf6gaW2hMvFtEdLZYu+UF02njrmPCGfzSD2JabIwKgE7H+RxY/mz1jaBTSZoKaR26E+fX6WErUH07nEEMAMWju6hFoccTDjAOGYVD/W2XDbTq76ZazvcFsauY8s4tz+SYPRNQekfWdD2nwNq/pFnJg9WFPGuNEPCrB6EZV8HrNOU6NBglHf8mnP3x8AYHkd3YhfEiqJefLw+7hs+51NMul/klSZqFnXeEq4u8ihKmaYmCC/RUwzAId7J55Qjc3AI75zwogTYgRz9z/H0IpJ1nI/lFRivfOfNiSJiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 10:06:05PM +0100, Matthew Wilcox wrote:

> I'm concerned by things like compaction that are executing
> asynchronously and might see a page mid-transition.  Or something like
> GUP or lockless pagecache lookup that might get a stale page
> pointer.

At least GUP fast obtains a page refcount before touching the rest of
struct page, so I think it can't see those kinds of races since the
page shouldn't be transitioning with a non-zero refcount?

Jason

