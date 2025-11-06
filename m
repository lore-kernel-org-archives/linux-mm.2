Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4039ACCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A43F8E000D; Thu,  6 Nov 2025 11:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B988E0002; Thu,  6 Nov 2025 11:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669CC8E000D; Thu,  6 Nov 2025 11:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55CFC8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:38:45 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA749C01B5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:38:44 +0000 (UTC)
X-FDA: 84080740968.02.1C2660D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 66EC5180013
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:38:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+JsD1h7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y7DKh15v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxqy2T12v/9yIvsRjPt0SgQS2TVRLjszKYNDg+CyMe0=;
	b=oLGFg8Rv1wz/xU49f8kO/Esmg7MdHYgF4yq7dgoaDuYrd30JiV1TtxIIbElQ9R0x0Zi7hv
	IaJ3Aar4xsUD/29J8HKRXosqpDRogE90ea0sLEniuyZqDdjmXFs3uRtXZzJVBgYllB34QL
	IKcNqaUnelTGCCf98ovlIwu949TvcZg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X+JsD1h7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y7DKh15v;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762447121; a=rsa-sha256;
	cv=pass;
	b=r59Gtkq/DhRcgiTi87SfDnR6YqEcqugmJEr6yTvK3znnxoN4Moqodz/saI6X0MgEL29V6e
	RA0w5iQIQAu7WZjE3nJN74lVe+EPW+aNo8zUVn1JII5Of8ONtXK/VZB7Dv8oM5LKN0FvfR
	Wc6VxOpsmTu0X1QdNRDLwEMI7s5eTBE=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6AAK0D025630;
	Thu, 6 Nov 2025 16:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wxqy2T12v/9yIvsRjP
	t0SgQS2TVRLjszKYNDg+CyMe0=; b=X+JsD1h7q3RRelsJ1nujFocHAGI3wLO3cC
	vGsr6lDVB4ydOjby6xJVFVWG97/UABsKxLI8YyUs8e9Fu4wkXA3pY0isZObss9en
	6sR4Nw2rJY8Jo0kZB9o6GYH63HzNaLXYlvKDR5M4TXErW58YtJ8Tbth9pl2abf+P
	/xijuKTfW69P72IU2J/gkf7AgqdMTKcodQNuf3TDqSO94kMYul51hEEpALKzY9C7
	rmdiIiWtcyX7OV5ZjLIjSMeMwpIB9qsDOjtlvlLaHmV1+TTSz8yvDruxcTDO5ViG
	UEp3PTJhgNfNqLYNTjYnNjqqz87dW8PsHf6GnEYc9C8+Cqk3WVxg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a88akaujt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:38:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FRE0c036162;
	Thu, 6 Nov 2025 16:38:36 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58npf7ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:38:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VWAhTLwqY47OGqCxwYcvw1q+cumTymM3xSw5x9r3Uu4z3O1R0sj3AEdF+VlOuOjSdVHt4f6Lb/fUIlAQ8TqLLMyTtnVzvUwIxLGjsVwRBuaxQwUuRFNCwKU/WniUdm3eu+8GKYYfmDOAmoYfR8jESKP1pXblY5Deksq7l1SDRB2xMPRDrIPdu8YPz/4Uqm7m9CuCw3CKmroQm6TVGKcVVjUTiWoaj8Fb22KZbjmtYNOWaPedZ6kjMjmJZgbLvYy4507np35w/bX83ncIAii73TD8FcIsS6PUxXglsW5GJz8FnVP37DpYxprXMruhY2HH7tx4I6jxk0ujaGbEwnuOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxqy2T12v/9yIvsRjPt0SgQS2TVRLjszKYNDg+CyMe0=;
 b=AIbD8yXv2TWaSW7hKPJM85JNjFitrK6hkYr6cb0HHz6S9jJBENY90698AacIv8PeqlfqnCOYYXFA6u8kmEaqkzDOgfZfxwkUhqRfexNG9+4iYnpRqYmbju8FHzozgoXdVgz7SQb87IzYj2Ay+Qig5x9R1n5mt3DGT+PTRrJpoQVAGNq6j0g1Fo+nCEWt+IJpqP0GP8oJzBgbQoHctY9MHqPcewKIP/+e3xkXeCORzZtytQ49zVxFeNvMeQxfPe6hy7xW+BsAbDMJ/RZqC7hHSpTXRhNQux9tM2jxu7UpTRPq0R09HOkSPwEZ+s7+jBFp2/k3i6AOOnrV4i3teRkm+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxqy2T12v/9yIvsRjPt0SgQS2TVRLjszKYNDg+CyMe0=;
 b=y7DKh15vsTpUmf+8kjHXxzlG3g/Dxbe74VATK4Bssor5UEVkFbDv5pjFZ4d8VpT5LbAfenHoc6K2+2pv67FQDyb345zuTT7s/yFz+6ABxgr2kZ9t6kn14vo/Nbr5MxEj9iW2FtLHkjLfouOh9UkSFoAz+bTyVlyq3gPtIGsjWa0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS3PR10MB997701.namprd10.prod.outlook.com (2603:10b6:8:344::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Thu, 6 Nov
 2025 16:38:22 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:38:22 +0000
Date: Thu, 6 Nov 2025 11:38:19 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: anshuman.khandual@arm.com, vbabka@suse.cz, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, zhanjun@uniontech.com,
        niecheng1@uniontech.com
Subject: Re: [PATCH v2] mm: cleanup vma_iter_bulk_alloc
Message-ID: <tgyfn6a4fzzb2vqds3ksqxepnceotibcyrnqdagppjehqj6peb@lku2utzs5zxf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Wentao Guan <guanwentao@uniontech.com>, anshuman.khandual@arm.com, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, zhanjun@uniontech.com, niecheng1@uniontech.com
References: <20251106110929.3522073-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106110929.3522073-1-guanwentao@uniontech.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YQBPR0101CA0051.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS3PR10MB997701:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b2d00ea-2e9a-48cb-cead-08de1d52e696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qMIIsSxcYBkEqgnAoxku8I3wjQjfV4cQ9T/yjq6FI4gfnflnYwgrKOCYVcjj?=
 =?us-ascii?Q?v894TwWDOYxkSunY0mRKrMIaba3WhGlANCgIOIaqU1bf6+RDfLFHCeoxxskF?=
 =?us-ascii?Q?/ZhoRBv+rxPg+AsrZhoVxR/tlQwQ0SqIOSiM6/MOWoP1UsimvbrixYX227kQ?=
 =?us-ascii?Q?mjEXz16hhapzct9/zSfFSkAqi0D5LxCJW4OjAD9h0B+DmH74erXr5a7rzs9b?=
 =?us-ascii?Q?rRpo/PvAkpjZFzE72BLE8+uxZwOmQcEMexXmi6JtQLDyC7E9nmmcjADCL4vO?=
 =?us-ascii?Q?nuJr9NcTMkGeQjR7oXSQVOMcoTSPdO6I9N6Fhkfub19aGDtto0Q4kJ+A5kU2?=
 =?us-ascii?Q?7CMd/lZkruTHiSbpUDkDXxtkuL58zJb+GJWwlE5ObhnldNRYBqmsshJnKR6i?=
 =?us-ascii?Q?73Z5GaA07P15w81Ytvmff6RgN+LXYT1AvuUReZcL9y8TisNl53QbZz183q4j?=
 =?us-ascii?Q?bNcARQwG6l7Bk00OsHaZ2UhEiX+lQVyzjOePWfGLE3xVaFCMcBJDc4Vq4iDo?=
 =?us-ascii?Q?Iq5nY7PKjNILZUqHZbC2aMVuDdWE3mbJLzGrkLS+Eq+X1tURT37s6GiTXb7t?=
 =?us-ascii?Q?PT/RB18qUvjSDSJ9virOdAapBrEWpp3sjnixoka/AauJvKNURfEh1ThhTpmz?=
 =?us-ascii?Q?ycs/snUixyELX7Q5BJXasxH36LO0gnEodvYx+8GEQH4qdk3JB8T+8XsGX9V+?=
 =?us-ascii?Q?qGhwCJjbgTWO2ZKDKTq4Pq+7a47EhZfO9hB9i4xaEHTk8+NGCih4ABogz4Nx?=
 =?us-ascii?Q?aKZTt6RO+Pdmfbaxh/rkbVdNHs+giACKdAIzjuJp+naJN0mZqRiwbxl0GLCb?=
 =?us-ascii?Q?o6/+ai9as1bbBgWephBpVMeAWHa1nnHqr6290E0aV3pvFsYlP6dIWYV8gso3?=
 =?us-ascii?Q?dbk6SvgNAIizP8yhTWDqvHiX8l1D0a+ItrTcMml45MLyuwl0rIorLiEr5fgQ?=
 =?us-ascii?Q?Gq4Qlh4eF2T+vhkGQvKGTCrhJAzmBhtCYTR2c0fEJwe85JT9HCU0AfWFdX8p?=
 =?us-ascii?Q?5oI5Kec2a9dMtMRSI/0fn0F7AgUazziUFuXvxZ9FdiPYOINHBBarrtu5ehx0?=
 =?us-ascii?Q?3c1scIwwsh/CrAAHGXfvLCyylUfbl/1ullL0W8oQYrVSBhV9S6JQBxpZW9Fm?=
 =?us-ascii?Q?XOM6YVDS6qbfjf2knu+wpEVrWMVFe554GwPSoWKi7hWFQhDBWhjkLasX1GST?=
 =?us-ascii?Q?/mggCyxAO4ax2dSchV0AQAI2LAXsRZ0+uzdDgy9siY8rgZvEes2122EH2SMG?=
 =?us-ascii?Q?DreFQkrsMpQ/ZD8s7S9l+zzch+nDbKbRGctH3fpiG/nr7YeadkyOQ8XnH9A6?=
 =?us-ascii?Q?8EUYbZi/rN06pgb/aRtq2bwdpiQKDdTB7YA16FAjCDSpninfONht2HJQOwy4?=
 =?us-ascii?Q?bKqMMjvn2FSEPh5TjUj05e+3baNKjF2gDYfsQIIz+/ztKuYRvY/nATGAH/Lu?=
 =?us-ascii?Q?qfs21JnGC9JzUgY9Afe/J0dcYJ6DHdyh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6QZ3jfSRPynht0xl8giOyRC834at95jyHFhxhf2eRz+bh3XcWy72GqTu5Yko?=
 =?us-ascii?Q?RZEDEydWUUPuHnWAz8EwyRhoaPqHf2oEr/ICulql3v13qrmLcwSY1UGPol+O?=
 =?us-ascii?Q?UYJC8Cpkhyj+bc9DfvuwVBPDT62wGxkYSvJQtCUmRIWeAvbxUVRymkMzsSP5?=
 =?us-ascii?Q?z4OrCswQFu2+1Jq75cN1r7HS3D8jWayGsq1Wcos8DufwGfxsAyOZKwpwT/Yj?=
 =?us-ascii?Q?1d4FdrCJnbjfNXJbl2hqaftKRO3YAB+llhHYhlXhB6sIrNFtLkrpRYFhufsO?=
 =?us-ascii?Q?6uq/UIeIeCFODy1MNg9lG+dpSXPzOkTyfryDuCDODyy0tu6Yt3xByzg+/KpU?=
 =?us-ascii?Q?znxpEAK4kYMvVGrnEhZZjFfnexRz9qJQ0rOAHP4QAskVR58ilJRML9Q7g/kS?=
 =?us-ascii?Q?UP5zS0myQRtPnzKiCy+xmTuLonR2Aq29ocMFvTsgkNbhVFRJXWTPjvYvjZsk?=
 =?us-ascii?Q?LhjXdAnc6jpooTktM3fwYaWeIJG0V3NrKjY0+JZh63EkAP5733laOMiLk+Gh?=
 =?us-ascii?Q?fMenoT+M0H6O6V0P15v5lrcj3JBi9gMuPoTQqgv6B5Qi0WLQe0x84Db/8OJq?=
 =?us-ascii?Q?dKHePx/IY2L/6IiAginoiOJSL9ivkq2gfdstKO3FTFWEVDrCzYQViwU/CZCw?=
 =?us-ascii?Q?W5mz6f5J6TJY5Ve0U7GHsYUsn202c2BdvVQKZbfzlTThK792gy9Pdg0o6G+f?=
 =?us-ascii?Q?K33IQPwGt5Ny9FJlN9mMhzRaVRoqMY/vgwP8B6vi/Cqu2baJreFfOBKDsGFS?=
 =?us-ascii?Q?G+CqDsbx91ka9vz7HTGiH2Cwkxxx0lMdxy6rASPnPJqbLq3L+RaEeVgkAgmy?=
 =?us-ascii?Q?Qngi2nlCjhhW7+JykuQ5QRAKPOSFwyc0m5V899NUTe6ot0vBcQyTuDWD6tSw?=
 =?us-ascii?Q?vB/nXLKNwhSAwvcxda5XDZtQmO/qlplaBaW7Ykk0BLW60r/i+cUNMHyEIFpr?=
 =?us-ascii?Q?RbvX507/Zp2EYamJAMvHzOF9pki1Tab1m9dVvejeRLtikOAhQ7788+qygdqc?=
 =?us-ascii?Q?5XbojmurQeIgqqYm+1X9kDdc7QxdqsfyLaCL9eAtq2iwBTUe3iBuBx446ht0?=
 =?us-ascii?Q?DRc8/+7x5hSa3nQqmrbnyjTgXxuTXV1SG/XVy9mjcVIKklB4ee+mOVvQOPob?=
 =?us-ascii?Q?gRgNaIGA3t8xMxmlp8Rq28l3VBS9u/hB1dtZg6PbUJEjwjgr+XNS+rn4pDCP?=
 =?us-ascii?Q?ztXJt776xmn4783CvSk0odt9ChTUmJ/Md9WebpT6kBJ/qc69Cr2W3BYU4Jhn?=
 =?us-ascii?Q?7dDQoyeSP2FEVD5F6QRW1FoYlpJUGgYHdygQQkU3sHGeu0HPnhBcVlSLwZvq?=
 =?us-ascii?Q?DRoIVXyYDOMQ/Z/VY1IIqPjbRrMeHjaGZOAlszSZAIpIds8qhVxEd31248T3?=
 =?us-ascii?Q?1zge2Gzskhp0lWvoC9fiYVYhIpfuLby2mUvklSegtVsxOxUNS1aX/gxYsBqo?=
 =?us-ascii?Q?bPpBY7ZvwXKybyiVlR7vcylSl3VvQ7Xb5WLNqaI8BJPcLCwSzTP8orZUtffe?=
 =?us-ascii?Q?ggMmTNuJHc5ejKxTz7qM6zVbnmANUMkPBkmCSFIHHzkuU0AObRj69vqipQSs?=
 =?us-ascii?Q?4eNNF0esyszaQ8PS+ukOubum0g85G3XNUCFGHn3W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YOBS5q8/mGwxBzMg8NC7OTQC+LMNnymtNUuXss/Vk/bCKkXPd5sXzpFBAUF9RXmgzTon5/lLXjkePl3YYByZsFelnpH1652UtkP5D2GLmGpb5YNojTOGBUE7IJMWzbc8QsytARudfs/jkkyMAYz3nLrnsxUXr+3/cNrCpV/NRf5BzWzQXnC56Qx1ogIQEEkptj0ayRd/y10sGLmgGdFYLV9MAabSnMrtHKLh/P5WfLo4swYXk+AlIdTXQclPWxbRCpfUpZ5CtwRuBs4Eb+Zz7QncQD8w3CQnR5gdYU7Org8/UDjLO0nF8Ff2asciVjNUpy5Mj8TcaRKGhX6CDyNY8SEO8brhJTSw2bWDAwk68Nlper7BcqxBwcwe+p5UGVQh8rX/IqkbC+0//WXeNHctbcGQPkC6Pc2Uzdl7eO3eN049XvGCZ6vQrcySdx/LcaNiYAkruonb2Uf7kAsEslrJy+Ih/1DKhCxs1nNAxe79FLgZu3U0mb+zB7jy5Fdb23gYs0wn1+FwPxcZ0c3ZpBCN9KVerWu6Ea6er+YSJq8vepZKnChdX0v+9zwLS2bTNxNgCsAB6B/5iRB7wiCvW2jPQkMe1nxAdLk8ihc3blnMotU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2d00ea-2e9a-48cb-cead-08de1d52e696
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:38:22.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TlQwoA3mJJHRbaxnNAbs8qDFb+J2xi9ctGSZf9fR17p5rkmSo8zu/1ig3Vq+5dIwK1Px/TvAxPSH7aIxJ+yXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060133
X-Authority-Analysis: v=2.4 cv=LsGfC3dc c=1 sm=1 tr=0 ts=690ccf0d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=iHwBjlyiAAAA:8 a=yPCof4ZbAAAA:8 a=AuENwBSfVz57ptVbzJQA:9 a=CjuIK1q_8ugA:10
 a=uNSKXYNwxGiU6LD0JREI:22 cc=ntf awl=host:12124
X-Proofpoint-ORIG-GUID: 7dHSN4dIX9D-bJysaTQubab5li_kAg7C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEwOSBTYWx0ZWRfX5KoogYddI/21
 FVI4MzGh8mLvH+i5cKiU2KvsGlakXrgK+pjMM1a1mTIAKg7+o9aqa/r2vFOcckfaPQPjOMCJ1hY
 DGF1NENB02Pf+op28dOIFPkRb32LXn6bAYnd9Sx4TOpgmm8MuqdbE73vKaw2KVwt9ADiJ2myMN/
 IlMfKo305EoAbKjaq08sgXo5/iQkNqLBefvwNtgr89SXX8Hi1lfOzW9Xo8lnD4YzmRUPeauAfOg
 9F5mOGZU7eIgc2kDMC6jmv9P3lRxSJyQ4OpcmIYAQ6CYMn1zo2CEpyzNRYzxuzFXZcwYhguFrxl
 2zRC9DPTqNXcPqkpacJxTpqkLXGsRZyi//9u2/pG3iuF2bD+VfHK4u0BvzkzzG7jjFDAjOpBU5W
 cLchWG1IWvsc/diGSEOvkx4S5Ff2l1PYJWFQIM0osEn2bBZnZ0I=
X-Proofpoint-GUID: 7dHSN4dIX9D-bJysaTQubab5li_kAg7C
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66EC5180013
X-Stat-Signature: cfd6ijry1b54cpeaoa5dr47f7rajxumc
X-Rspam-User: 
X-HE-Tag: 1762447121-805641
X-HE-Meta: U2FsdGVkX18FnLI+1ZR9862EaAx02IMLoZs4zqNrNmvat7afDmF/EIb3dt2O+krGXDx3J1RDKp58P9ilJs5OfqmZxtU+sCeRuUPiCHBOtxA+0DBdi/JxVChuGF5fKonC8S3qvHkHuuaUpWIh+fS47zU9UCiUulyXoTxrLZkYd4nntOQF1XNzcOy2yGXXZs9kPWMvnQLDrJXeGLHIDIkPPvrPETkY7/uV6xhKJLlU8S2Jg19cQIa4LkLQgPwzLck1aCFHpfNpQj/V4fQwRof9Y1H91BQgFT9X7SVR+bzhHTKUrek+/YMxgmPq6/vsXZOIv7ZaW+HWQyo+5F0pVR6NTxgj5Pc5KozTwF+w8Ou+QmN/nt4KHQa1Jut6n8YUOihvQvyn2JLP9ldH+O+RJI6aO8jjIqLnUQMF6snFz5+IiDo2OUXn52kn8kF4alPWD5JueoFK9/hemM8hu2cm+6zeYnpymC+4KKVpW59W8tnQq53fl200HOPvOxvTj1IPl2QAUpH5zCo70FytRM+nPiZwEMjC84fxi3MKlbmKpH8LPrjMH2Z+kT3+N6FKac/ADpJA4RfGtrH/m2CNUratfbahAb4xZkUY0YMbQkN1833MVQOKAnzPyEga9FvaxiFsWQ+MiHC8oilgMvZKEnXhihaRc+An126fTtRRnFVVFGRy91n9/IWmo5P8Bdi/DB5gKmnx1ryHLN62IgBt3ga3xguyH+5VOBm1IDoPDKNmeRYwwXH8nymBBatEv9EyBO4LWLla6DdBaSY5uE/UKtAv1+Z0vEi3FFHTWeWZ/6UxTwEqk7aoC0xBrN5/4cuA1d7waHBegtQSYRv0okGw/8Q9MqK/4+/wZVKL3MyLTgHu7BGn/zmbzgObJHNYXblYUG/EAtUGHH4Rn1XIGez2oUhnVZ+pJErPyp0PuWJOicArVdRe3MF45iEg04sdVmrzxWDfgppWvv4W7vXXC0QXlXG8OmQ
 p65FK3jJ
 1TisRw9T8lTNZNFYo3KMElnMxTa0jppVRisZO7RF5fcpqI6Em2PjymcjvbzMpCCp4O4onO4UdUKs8A6tKBEe68nJsa2YnAoilXaIWoIz53H3Bwxh6grtBvkpydGcyfWi/jv9hiJ9+O9QuDxN4TV6Ic8DP9tUoTCYCy11/OAAkx/CsX/vNZKoKtJct26N6/J+tsDgnrqhQF9tKMLjuJvvFEEk95i5Tr7F/UsXPU2bd2Zs6yfWipUAVGqUySdxKnUIwIEZ4xhqNU0vkUYATTciyzuC2KEP1zo6BgZlmZGnNJuie9GpJFhfStxjGlG/lKetu+LWPr+bZFEemumkrm3AF9uK8ijsfwKW1pwglje+sZ6VJGe4KpjuIpZqtHcyvxSV/qBF9VmiPsz+/bVEooofY12+tWv+7t41UsvSRCOf7Ew34o12Pg3S+zpAdFE1CMzcyC9FtjpjQ0fox+G9qVkw4t8A7phWBpabKEIzFpGylfznScVZseQC1hsPFUyAHhJd1aKV3rXyqEaaypqESzdJma3TjZG6htbhChDJ9DAIDOeh7AJ7XbJK/IOoJc8/gKJx4psQ8a7qZUhJdiP3c4ycUoHmavOXPrIDtTiEXP2GtHox37ksFZoLuTzom850Kaeh+SIMOm7A7gYfMHkXJXNQkmuBte2qk6A2m1h7Fq9Lt4+416Fx/DoS95OgobIIx3yL4IM3GHBanh4cEURGzc31fpRctp2RHQlcDT1QH4IjFQpSi8f5TEKqXQ9vDAH2dKVYQRNbNnDND+c08HoDajF366+9q/ClpBYqcLu/5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Wentao Guan <guanwentao@uniontech.com> [251106 06:10]:
> commit d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()"),
> remove the only user and mas_expected_entries has been removed,
> since commit e3852a1213ffc ("maple_tree: Drop bulk insert support").
> Also cleanup the mas_expected_entries in maple_tree.h.
> 
> No functional change.
> 
> Signed-off-by: Wentao Guan <guanwentao@uniontech.com>

Thanks!

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>


> ---
> v2 changelog:
> also remove mas_expected_entries from include/maple_tree.h.
> ---
> ---
>  include/linux/maple_tree.h | 1 -
>  mm/vma.h                   | 6 ------
>  2 files changed, 7 deletions(-)
> 
> diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
> index 66f98a3da8d8b..f7ba53f3f9035 100644
> --- a/include/linux/maple_tree.h
> +++ b/include/linux/maple_tree.h
> @@ -536,7 +536,6 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp);
>  void mas_pause(struct ma_state *mas);
>  void maple_tree_init(void);
>  void mas_destroy(struct ma_state *mas);
> -int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries);
>  
>  void *mas_prev(struct ma_state *mas, unsigned long min);
>  void *mas_prev_range(struct ma_state *mas, unsigned long max);
> diff --git a/mm/vma.h b/mm/vma.h
> index 9183fe5490090..4aa72c7e94400 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -498,12 +498,6 @@ static inline unsigned long vma_iter_end(struct vma_iterator *vmi)
>  	return vmi->mas.last + 1;
>  }
>  
> -static inline int vma_iter_bulk_alloc(struct vma_iterator *vmi,
> -				      unsigned long count)
> -{
> -	return mas_expected_entries(&vmi->mas, count);
> -}
> -
>  static inline
>  struct vm_area_struct *vma_iter_prev_range(struct vma_iterator *vmi)
>  {
> 
> base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
> -- 
> 2.20.1
> 
> 

