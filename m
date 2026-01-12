Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2916D2502E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 00:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD7B6B0095; Sun, 11 Jan 2026 19:55:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0645D6B0096; Sun, 11 Jan 2026 19:55:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5986B0098; Sun, 11 Jan 2026 19:54:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D4A006B0095
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:54:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 820D8CD5AB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:54:59 +0000 (UTC)
X-FDA: 84321492318.17.EEF0386
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id B8B5E40008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:54:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OBn4Xt6B;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768179296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I5Yks1f+vyeoeXvXs4VsIrUP6CgOwqIDC53ptHOrbPM=;
	b=vKMNl4cxix5JoIL5doSzyamLWzSx5ZmqBn423vuEJuYzICRRA5iO5JO+RiRkaSiVniLTd9
	8NJhyMv5P3546orK1LMCPtbwd9d6bgFCcOuOqluCG+0eklr7JwsoCTlCYCMlna71DL28dM
	RmtnP+IABr8mkjJwSYKtY8y2efw1Kz0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OBn4Xt6B;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768179296; a=rsa-sha256;
	cv=pass;
	b=GjCAeSo/abrgf1GCQb+OKVY8bOWGx3Q56+wpqNYkaF07vqYwmAviZCb6e1Ot2UVTKzVC4i
	rJwRHZQcuMjTrQbaNiekcmgOFyRgPOpamU35EgqKUO7gC9v+xcrO1+s3yl5ZmBMGYK64mS
	PRJk67DeeasVpmC5UE2vToFWVTMsVOc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FyfWu4oxPWRK6RhNZbzoUgqpUOQYvQRkYLVAsPzqmO8YZvD3/YkJSO0bBnMhnhrvhmq/0vmyZVl7/RoplEBVJ++UUBVGVH+tk/Mb6dEKtRQ+qqArw5L8Br39lLtq5ZvyXJz+lHwLgSVZlxmwNHf3IubNIbgj0zg0UVq3XabJkRczbd64wT/LLUdYtBQzQHhFDUCKDhWgjm7QkZmHGJlf31VfRa6X0N28Z0IVeOhnPmsUD7W1xswGUU7a5Yr3pz07k1dLpVkTzSK2bhG3dmTyxfWkukCEXdT5sN047CTusDpBUnRcDH9T0orhsIYL+aEEcrJIJqF/wF228Z0OreTDCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5Yks1f+vyeoeXvXs4VsIrUP6CgOwqIDC53ptHOrbPM=;
 b=ykyiXDX8zGIXXTT54xobaQOCYoLb2u6jOHr/rLMeGA8yVbwxpCnLy3mpvHRVV2wBkpC1UnUONy52+iBxvv4YRAW7EUCobbmfIlFYziM/PWfYOHiw0qUbb3wVQNOFwF57nRBwMe+5sPmqBw7lTiAftKGuNxVxPz1n5+UEbyBGZsFek0EdgC3ebpljCkPAfqWfZG3bA3IUgTDsIZqWUylFx4+sy3KG+7/kSG1OJW+yDnkHSwBvTGJbYw8gKSS4JaSXfecK13zjIBocurHSVJmV5cIh7PWW98SRpWXR9pwsGF4rUZWWNzDquOfwC+zhdJhWx+XoWx1p/UuWIxz8ZBRGxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5Yks1f+vyeoeXvXs4VsIrUP6CgOwqIDC53ptHOrbPM=;
 b=OBn4Xt6B6kqvu5NLBM5XJU2nQNhGFKu8WVDp3KoU2fLB7nG4RFP1bmXLdVpKcJpMGbAj05jk21w8sGCwpDw1S3WvyGwPVRcEJuQ+Enw+gapk5aSizRkt13hcUcYdgKJQKswLsSkRovnBKAw1cz8Ly6/m+czs9wa3BHS5qn8Hxs/zkWuwHVaSIiQk5IIxinkpYk7ODhdHJSGh3R+/tIKzf5cUHFgi5mav4oALag29wpX0G7CCHwFQAxbqij+R+7ggPElULPDUqeCxKPeiZnNzJvST+xdZtOm9M76IlMUiSYtMxwCxoNNkgaweVTuR54ZoLaudXZQNDUrWfa51Ip4z0g==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 IA1PR12MB8468.namprd12.prod.outlook.com (2603:10b6:208:445::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 00:54:52 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 00:54:52 +0000
From: Alistair Popple <apopple@nvidia.com>
To: helgaas@kernel.org
Cc: houtao@huaweicloud.com,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	bhelgaas@google.com,
	logang@deltatee.com,
	leonro@nvidia.com,
	gregkh@linuxfoundation.org,
	tj@kernel.org,
	rafael@kernel.org,
	dakr@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	houtao1@huawei.com,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH] PCI/P2PDMA: Reset page reference count when page mapping fails
Date: Mon, 12 Jan 2026 11:54:40 +1100
Message-ID: <20260112005440.998543-1-apopple@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0027.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:202::13) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 064ef53d-148d-4302-2559-08de517531a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Zs/01giyeywyi/IXAj+vb2ajJgnEMgeRNPJSE2B1qu6pF28hSNUhMnLqnnv6?=
 =?us-ascii?Q?aMfjrkxoRzn/OKhu64dgCaWeQPOOshZ4OY1Q9x/odceyaawlEUWokdGBX6+m?=
 =?us-ascii?Q?Az2lp0FS/BerS9WfYtLn7udWDEcHApVVqdfSSFvIT6CoFVaf+frpff7aNW1G?=
 =?us-ascii?Q?fCioja+FmcUQv5FU94t3NhIYacr8fWty3cpspjsZo9islgxIpem8V4K06PnK?=
 =?us-ascii?Q?qeEHgLe8M4zoFME6kZ5WYGGR3J3uGCENUhCaQsfpU2/Y6R6jCZ45opWMfhvH?=
 =?us-ascii?Q?0xA1DS4t30Z8I/d1i+506nGrX8gy/lKIGAFIz53KWCgRr8t7kpazGVeURRCo?=
 =?us-ascii?Q?m+K7IvJOXorjH4xhrc8rU4Bt423HJjBRnl/2NGJ9EyIEdDiiOGDpomQIs7IJ?=
 =?us-ascii?Q?ErEsKWUWkMzxzOwMRl64GK5HNeJn95GQfZRLRpULcvakBTYxfzYRsoFpN6Jb?=
 =?us-ascii?Q?RRIEV3cX+XnVCHrLgbpKkF/9grNNMienLhBlLX6NuPbm1gwBpOft2R/R/fHX?=
 =?us-ascii?Q?V493ZmPpsZdHRYja06KcqakaDAil+ZeXkDW5KRL7iLTjgaqDMj9Wia2K3Ixt?=
 =?us-ascii?Q?xjbDtxIXrCNFvdrHzgST6nMqKYINFM7PZEuhy7JmFbfUvE6W3i96tLLAaH8t?=
 =?us-ascii?Q?GqbIlyeHt+1Y4Z6ZdVPOBFgcOXdTFIFYkGPweAE/tmPrUTbme/39racHUe+E?=
 =?us-ascii?Q?TX3ddxQ2stpSADOwHTr6Uoufxx/MV98cvL2IVCoaJSaSQOmdG6suDGU6FcXz?=
 =?us-ascii?Q?+X/Gkp95INsrXJIaBxIODFOWciu3cssrcyGhddNA858wo9argHbuPcWfmj/h?=
 =?us-ascii?Q?b6yamZLAw5+yrTjr+kEfhKKswh3oUpOYCBRoZ87iwKlOEbHWJzZuRHz+9Axk?=
 =?us-ascii?Q?bklcqrblG7EF2LsyguZOAFPV0wY6M7YDuKN37JrTqIPiQizwmC2vPm13dfCk?=
 =?us-ascii?Q?/V3FhsPeB78xOLQhcYaS7ZpMPqWaMLrULRFvr4+FhtSCKIStgAvgvHOucf9i?=
 =?us-ascii?Q?IqVUuxpi+bOhiv3VB1kmAPgsefxlBRLgEofel2gF0ACwyYI7U8WxJTzO0MKC?=
 =?us-ascii?Q?tZv79AozgjfDgl7DTgiZ12XuzIhbdVFMVfRZsnVd3fLgbPEk1N94rtE+crWo?=
 =?us-ascii?Q?s78Qg8JR8Gr8iKioCx4KSxZnw5AATTMJb8/MEzEX914Wq6iszNHewBIdDFZT?=
 =?us-ascii?Q?OCxbvi1COnDcxT5bWUyqKk0glkI6zY909I2RERunlzrEfBbBxLxKgqPk2pSH?=
 =?us-ascii?Q?6sVnc+D9CkLCYG4ME8mJ/rcvRlinhDaF/GspdWdSxczTgraoNQ+PS+lYUfhR?=
 =?us-ascii?Q?SqFZSxVA3kboJidGa30rgLk2AFNfwpwCPPJxTgA6IZA8uT3gc//tRTePc1bG?=
 =?us-ascii?Q?Zzl4hmXVI04Quq6uvA18gXVbAGflnQLDDeciDKuNp70fq9L8GYJ2pq21wG+k?=
 =?us-ascii?Q?JG8VfJx5YjputPRTWFLGq1A9KqXFHchb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bpBaBHIE8GhcYdgO8S0yNgUlbkxaJO9HSEyJhyrzUVJSeo8DwKmpZQXzopo4?=
 =?us-ascii?Q?jKCKVM2zV8Xxb7SgnyRuh9J01ooiEGDUrRhrEZEWdg0IhGsIu1ZKtRpLJOZI?=
 =?us-ascii?Q?MhjqoPjeHke6P70tjlwYPhcNGW24ET9YYS2b20hdvkSVX1pomIPJSyGg1i7L?=
 =?us-ascii?Q?tgSv8DAk6MuTQhVnAB5mxLnHrJuRgJ6v0LGMYLxK7IYyORwnexWGFMPKrkvc?=
 =?us-ascii?Q?dCfepOd53fyzqxkhrTS/9O8W2XOnd2vYujWyptcyN/3aVneGbhFE5SRAjFp/?=
 =?us-ascii?Q?aItjqo3jxgQ+R/NsqMtO9eWDt350LplmOTF/LKJCnFn2jnbGbbXznGVdAAm1?=
 =?us-ascii?Q?cfEAyFKENLywf+prWDEiRd6CIeR9l8CRXxYoB2r7XDumkMcc/5BA2ckW9R2Z?=
 =?us-ascii?Q?Cduh4/A2GJiRdjsgyg/GovczMImu6IHuEOnL/DVGwymkgEtf8E+N9jTrk1D8?=
 =?us-ascii?Q?XGtv2yuiOOXLQ3YD7RCXLkyTXxUlxYOJgRLN8SaHvWGgvb6SQRV6YBnJLXeY?=
 =?us-ascii?Q?2eWG7/8Yp83vSDM+jJWFYsLk8NW5AB/k/bo0MJSQf+ccQTOtL1OVe35B/4Q+?=
 =?us-ascii?Q?ICWp7ggrsoGdXJD6x/HmzMAQMFWXjS/a/ufgnrBmaVQT4KXjJIoeJbX/88je?=
 =?us-ascii?Q?VBUYkF4/+qxmT4oJ+tJhZBDP4OtPbXZOG2eyRxhNETQLoKLRUnlCAftZTBM5?=
 =?us-ascii?Q?/XwJgSDTz/qEou+T9z0dDuOB8kwC+QRYuOGytDTAFs/PgnzLzAbtWThDdlFQ?=
 =?us-ascii?Q?PHZZA0ylQP/n/fNgT7MpMEkCqHvOh+kh0TWpzj8WVnK4joSOyFIFJp63Q5Vj?=
 =?us-ascii?Q?ibuqYidhsnF7oFvu3dl6gU89ny0MBNbD99mtsFlGF1SE6WoPr1SWHh9gIwr8?=
 =?us-ascii?Q?A+rirCjJql7+9kuJ9L5PXf8L9o0SQLtQKhDJmjEtfIRiXnfRtFw9ZUPDoCiE?=
 =?us-ascii?Q?n7lL7Nz40NQRPKZxP6NUzwbEa6MKEFWRdbvDTBj/Q1gmgzzFgfdNbHKOXHx2?=
 =?us-ascii?Q?cm5sIq8q+2JGvHljv51cGVAkO+YNfsA9EI9r3AaSbKOIHcjrEJZ940qUId2n?=
 =?us-ascii?Q?+FH7j+CyIWRIDQccSZZBENHnEX/5/Aoz8R04tr7JqPILvvEWtQNt27sUA0hd?=
 =?us-ascii?Q?MZ/3R6UrDy58CLIPsNLMtJtaCPp5FpuXS7bKBuK8JMAN5w5tGH375ecl8uvA?=
 =?us-ascii?Q?qy8inKiYsJizmh/d02UfjVBsjoIkCqPnubBPye/cHdmuQh3xKSqCbqI8HdOB?=
 =?us-ascii?Q?HmEYAQ2CQ3aQoktjThenu+IkreLIS1nSGtm1Z34usqJvn7SfVQYvKFtx8RuB?=
 =?us-ascii?Q?fv6mkKUciv4vhNnREI3wjloT6u9Fw44T7UhXUJqPcPwGCtYfLzid7+YFc/S+?=
 =?us-ascii?Q?4BLXROB/xQw8XE7GnPduzJF6TPCZCrHVwdq4k4SILtylc0AjegV2lyuMNA2a?=
 =?us-ascii?Q?dTPcMcgqWkMPjvFZlPganqYrDtdY/PwDzcaeVJ9QwqguCpdvuIynA+42Y5Uq?=
 =?us-ascii?Q?+0/UHJp44k/GPz5/nGi6JmFvu6qEuEChjHfU/Mb5yjhvVx/dHpEB/yZYEucx?=
 =?us-ascii?Q?fWxLjuF7oUjebAl8u3ooKZD0UteJ+pbh04qq+15AUL91DtJixR5xWneplFP3?=
 =?us-ascii?Q?/bBOFc1xSx1vXScC0vz09wNTnc8fnTMU6NhqEnKNl4GOO41MqlUqWPRAHcfP?=
 =?us-ascii?Q?inXyldSZNxgiZ+XwXGhb/eeX3NOrFyX1WzrQylDlhSMYL8y8UdkUUmddXMHk?=
 =?us-ascii?Q?BPtQZ7mExA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 064ef53d-148d-4302-2559-08de517531a4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 00:54:52.0763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 21AMEXVHr8wpB0qK6QGAXc1IxZhwogov3+KGat2nucIIOjqxdfEMr8DchsQxatDyQARLdmoIwn/YwIm8O+0/7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468
X-Stat-Signature: trxpsa4cdfgai61w3gtqdh84qmyjk31i
X-Rspam-User: 
X-Rspamd-Queue-Id: B8B5E40008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768179296-387372
X-HE-Meta: U2FsdGVkX1+9DUHoSrBM6HYPs8vDiQ+h8KYrEQ1mKhCjSeV8K77CCdqenW4cIsjgkkGUinin2goSs1Vz/xAGeVrQGn8k1ABEzF+X8DyroMCwAA+rTGeT0UWBxD6r+F+t5IeFD35aYDoMqGeAqd1cIBTtdQ59FssymEfNkk6JVy/QoMV953oImMPsdW9C5vQlA/J1lSV/LBUJpLDfhYHYpRkBIAr3cqWU0iqm9AhobA+mFY3NN08+SxuAwr/w4oEvnsVatFfSshy5zwaYMCCa9BSdUM/Wlgdlb4qHRu65P07w0xppLgjapdbq2MTR2+NukUAVzZlb2EW13CQueITTNCWvs5KFuevzTH3Xx78OnmJInnFN5nrrx3OjxYz21Nb6XKUQkQNcS9G8UlxRLh0PP3x0FmW/jj8mH6NmAmeQVziUAbghyV9noRD8gYpmqSKlgMZ7G485hGMkqdeIQk4BqE7MPNMq/3XAazFGC4Ehj1gsReUk6g7hTQNcVbuOJz3FIEyDXbruuw+vWe2H/MOjDSC9v4I+5G7bauIktYCBct0HEIBJZp1abIU5N+NpZAf11xTfO5Ob3inwxZXxjwkSdj7T7CFH+GOF9fPrfF/9+y27QVE9ptK+jBkf80U3QI6kPacKo7tnBAXhXdDUZKi4w+OxY/ERUiv5yNxaLx+0QBvpseLk4loBViKSbrRKQBNj0Uxo92r8UuXBEw6MpLWOsv3xtJ0II9KhemqWhojeoHRigaA88V/z8VNhqGydXKzt7LCuZjFDfFGi/guGugBmZTWnuS1RgHcqGW4ekqKPCpfN3KsRnPrIXILuTAIvzO4ed63roLyml5TtUZcZn5Zvi1RZsvoyZubpeGO4nG00kNQUrPOFygRl4d7Rn3CtvSgLOicJvFQeSABfnXt0+lYJCj0BCDtyhwoRFciHcz+vJxaDaHjbDgXnowF53oXpRcFZT+AdFhcKr9W3j2Li5AX
 ElhhYtPU
 8RSShPqsWCsPXmfbgtIaqegSUa63B5KCcQCvNiqMAjzDeY7qxpVylD69MLztlLiE7B97pLMwZyizAXmhXMH0iWbg2hkbfvkbosGW8fwY+/YfctYcQvQ0Nngoys/2K2ueCG2DC4PegHADpgthceJzTlYdnLhEFLJbvVwLlGlg/ZQRyv8/LecBPLqBFPeBueG/BsGgNyfayelcLzwAsc38DaF+gV3gV0osYfeGCTuwkPvda37zymVmO12k+oAA2R11M4LULIDdatPaZMsuUyAGmBHv/GyqSLUvlX0j6rQJE+9ZBVtXGBShuoJSiz5MGuuEhaBUnIymA6YiY4VJk4KwUYKvp33Ttor53BcDuGzg9DQWl/94kXNhO1fVO1pmoxvedi0xa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mapping a p2pdma page the page reference count is initialised to
1 prior to calling vm_insert_page(). This is to avoid vm_insert_page()
warning if the page refcount is zero. Prior to setting the page count
there is a check to ensure the page is currently free (ie. has a zero
reference count).

However vm_insert_page() can fail. In this case the pages are freed
back to the genalloc pool, but that does not reset the page refcount.
So a future allocation of the same page will see the elevated page
refcount from the previous set_page_count() call triggering the
VM_WARN_ON_ONCE_PAGE checking that the page is free.

Fix this by resetting the page refcount back to zero using
set_page_count(). Note that put_page() is not used because that
would result in freeing the page twice due to implicitly calling
p2pdma_folio_free().

Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
Signed-off-by: Alistair Popple <apopple@nvidia.com>

---

This was found by inspection. I don't currently have a good setup that
exercises the p2pmem_alloc_mmap() path so this has only been compile
tested - additional testing would be appreciated.
---
 drivers/pci/p2pdma.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index dd64ec830fdd..3b29246b9e86 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -152,6 +152,12 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
+
+			/*
+			 * Reset the page count. We don't use put_page() because
+			 * we don't want to trigger the p2pdma_folio_free() path.
+			 */
+			set_page_count(page, 0);
 			percpu_ref_put(ref);
 			return ret;
 		}
-- 
2.51.0


