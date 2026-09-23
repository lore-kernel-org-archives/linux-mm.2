Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0FFC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44FC6B0092; Wed, 23 Sep 2026 04:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C676B0095; Wed, 23 Sep 2026 04:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B6F6B0096; Wed, 23 Sep 2026 04:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9078D6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:47:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B155680705
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:47:28 +0000 (UTC)
X-FDA: 85244398176.21.3D50CA1
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010058.outbound.protection.outlook.com [52.101.61.58])
	by imf31.hostedemail.com (Postfix) with ESMTP id DE66D20007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:47:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Xm7Jh6uB;
	spf=pass (imf31.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790153246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q1PdpA2HlwCEscT7LtbV1Ih1mHhPfyNO2+wAWI7imM=;
	b=kFBzNz/qdEqBeOXxXVi15yQo3TTR1ZQUrjrSvjd/+rj744OGvNhHG1v/rhpDeQ8eipT5fS
	mMN3ywNLZOLzO1voLMVBRzyxSqbyrfKMq6LsPSA+bZJQNJ2YKqAcPDc6CAwy8zyxhEpr8/
	Ea7eW1AtNU2kME9fJ14dWeNrJKFJO7o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790153246;
	b=HM2mN4cfO6bVxGi0OuLEBWtWOn5luymoorOqMIAAwgAH7zwn0LqD/jTpLZdK3TP8NNvOJy
	/Cnz6/BaSpSwDJWzKutULm/MpwK+7KDKdTga6XM2oycV4bg+wOII7jjhLdcik0svaaSf3u
	5Y4SYdywhonoU78mktgj/Y1ZRWBbOhA=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Xm7Jh6uB;
	spf=pass (imf31.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.58 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmIL/kfewwa5UuftoxGSs9ynNz8hNKt2U2yp10JOLA/vq32Bvt7yfRJSXZA3WOEEP9zlMHBIR/jcNfQkAAfWWO2wENHZs45ypF4Bem67HVgmqj/kusze900P/suiNreqNCpa0LDARUwX8zTblEQzCfI/SwFt940Eo4NSBN4hWjYSmyc9nt0cLJt2osSgkXOlJYVKLtoeEimVAGXnd0oTCIXzGqrrY9xyqFhTWNcOkiYynRzOF0xeMZm0DRWJygdCSpjE8NHZyR01Xmitcoq31iS5wP319ohqJdyCml7fLMWFMBGsqbh8abmMzuftOgcoLW66QCWGcfNbukumh9cP4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7q1PdpA2HlwCEscT7LtbV1Ih1mHhPfyNO2+wAWI7imM=;
 b=bzG+aDG7TCYr+c5emkYmHuvTYz3jQ5D04em60nbewtGapUfUmRqraK/sV+tQWHauF6CzR+/FmNBENAndudJSnNXXSmbpkkXLvGntsf6LruWHPU86l4kbMtKkeBuUVQA0ITt0a6cBZ/Er6534AbBAkD7YCSU/nH5EKzCCnmyyfwVyypoqFNvLb8IHXSH4fU0zWC+OQFWusqqRdv40vzkKEX5w/pSM6aPue86GAJ8G5YVMANAH+glokHG5oSmkvmWfzhcopk7QMfuBhdWc1wv85FkUmWT2oeeBSdPizbM2sSNylgp//TBxhcnvwU3H0DnRZNnEkQQoby4XSug21x0VUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q1PdpA2HlwCEscT7LtbV1Ih1mHhPfyNO2+wAWI7imM=;
 b=Xm7Jh6uBK3OKDP0anxHpQ+lUazyb5gASPryoG5Je79nMfaQwRVyqMYz6A7BUlQPjOCZZI5AyxwfoCXfcHdAV9Z0Otbz+fe7CDzFquv2PB5fKOFqf5KkS4DtozdGOXfj3zvYV35eX3SUfUnBfOMNZ77puPOlL5lFEy+h9jnpkW5M=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Wed, 23 Sep
 2026 08:46:40 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0451.014; Wed, 23 Sep 2026
 08:46:40 +0000
Message-ID: <60934676-6279-4aa8-a946-f2df9ab5990c@amd.com>
Date: Wed, 23 Sep 2026 10:46:34 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 12/13] dma-buf: system_heap: Allocate shared
 buffers using CoCo shared memory allocator
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-13-aneesh.kumar@kernel.org> <arKvKME-_wNeW7ea@arm.com>
 <yq5acxu42wrk.fsf@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <yq5acxu42wrk.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0031.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::15) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 88271104-831d-42ca-881c-08df194f2f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|3023799007|11063799006|10067099003|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	s5ZrUTX5aW4VdbuEPlf9SMnNtqfSJrqqkTXSoYQxKX6UlIV/GGCXyjI7VEd0sQmDNMopAHEhcpJ6tjdjKj7AcdjIV0F6S/kIvCmBAX79dVrBshKuKe+CkZE+4BFVkId1ppthpdhdIqMGNNObG2HLIrfk85BlxNZZN5dgiIhiqpm40J59zZ0rRNZNWlmLYia69QpipMULawEZC8G3nlpBoErhY+tnbXAb/67TN87e3OOS1QYigD1o8lzw2sAzcZs9+WeFSgJB/B1WQjlVJHId3jJIlxJVW9UsjaCpSDPV+3NJV0OF/vplTBWv/kXWNj5XL6Pno1zK3MrkGylNHoc5geetUgnKWdT/m9ND0IbIrTQ5MZarDlSvgjEJxUbOlwxXBGlR5WgYQXYJnXBcYxBCegQFTXEiNVDTdll55DWQkwFk+JU+37/+P/OBMKwe3b1SBCuGtVE9lBFlhzp3RTCFCTjNAfyEkq30ZYGWM/hFNPQ9bs5w4S3pyydKHod86YP4WypjD5GgEGaHPSX/m/xtPv5ndadPTXtRe5Oz7Pw3V7peKBD06tuNnjCpbVtoHIm/G9PhRc8q++tv0rE0Cs9ad/wkJDaeOCDc/YTnmGLhw4B+mxNL3U3eLyuXCVptYxhJ5c5y7h5vC627HRJcGUmGVvG+cl8L0PRUnqRE7TikZ2c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(3023799007)(11063799006)(10067099003)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1hxQ1NIdUx2UmhnbzdnK2JkaFNldjVNWGsveDFlVlpxR1RVcEFwUmZ2OHN0?=
 =?utf-8?B?QXJMOGRmUEZqTXdvTUZQRUZId0szb2svNVJpMk5vN2w1RUhjVUxHbEw0N2Zl?=
 =?utf-8?B?TFdRZDFSTFlaUnhZdmFtYkY3eWs0N0wwczQ2UnkrQ3ZIMUo3Zjd1T0xXeHZ4?=
 =?utf-8?B?WUFsSVdPNnROWWMwS284L0VaU1NKQWVaaFloMXZ3dFBGU1IrWm4zb1lLbExX?=
 =?utf-8?B?bWxYdnUvTFNFdGpwS21hcTFNUkVWUTFQVElYUnh5Qlcra002NXJjOFhlazhZ?=
 =?utf-8?B?VHo5VWlYakdWUHhINmYxUmd0cU5xamc4aEJsMmMyQ2RNSEZmM3FFUlhiVTVQ?=
 =?utf-8?B?Q3FaQnBtVjhyYTdXUGpia2FEdE92VjlIN3ZPbzZnRFlwbERIN0lJNE1IY25v?=
 =?utf-8?B?MDhjN2FkUWRMS1Vtd1E0WW93dm4va1QrMW5Ud3hIYURqY1dMYk5Xb2x3WmtO?=
 =?utf-8?B?dUdaVllzWkVPS0FJSHZUVUlJZGJ2SEMxbVVvUXUwQnZWL2lWbHVBVStzME1P?=
 =?utf-8?B?akFFNUV0U2p6YXlBTVhRVS9vM2NaU296Q21SM0VEdFIzNlM3c05iY2hXTlo2?=
 =?utf-8?B?aXZpejZjMDc0N3FqNnBRZTZwRVdiMlh4dXhQRkhqQ0dva090WGt2dnJrdWZ5?=
 =?utf-8?B?VmdLc3pKTVFOQkYzT0NWb3JXTXBqa1c2K0FDS0dJUEdIQWNWSGZ3bXd6VDc5?=
 =?utf-8?B?SUpJblhsbnI3ck1FeC9TYVZGNk1GUWluQStKSWhFUVpXSmZONlJwSWVjd3V3?=
 =?utf-8?B?eDFaODMydnpkM2JqZjlwRGo0TVZJa3lDbkVRaitvQ3V1N1dFY3crQ0RQNmZJ?=
 =?utf-8?B?eHZjMmJ6ZHd5SlpwYUNheUFmdFFrNys3dGFxMzZJRmpqVlFhUDlWOVNkS0ps?=
 =?utf-8?B?NjRIZi9VQ1JhdnZTVGxQamg1RXlyZVJHQzFMV2dacDRNWFpRMHFPYTl6Wk40?=
 =?utf-8?B?Y0xUdU5JVnBmSE1MMkxtM2lLQmNVdmFRSmh6MjdxOTlJdUJQRlVpdUJJejNu?=
 =?utf-8?B?TjFYU2l2MTkxS1JWQXNjRmt2V1h4eWxqaEtzZmRLVVF4dGlvaDA2RTFFUnpu?=
 =?utf-8?B?ajlucW9sZW8zbkdNOThHN0ZWNXliZ3kvSmNyYmRvcEY2WWdVVUpCMmJJUHlO?=
 =?utf-8?B?bElXcys5NDg5NWRRa2Y1cW40eTU1TDJDNlBqZklRU1lTWjUxNmtFVFdqK0FG?=
 =?utf-8?B?c2xiNzVsSFhUTXF1SXE1ak0wUE54c2RnSW9iQ0dzb01FTDg3Qk5MQUVxOHdo?=
 =?utf-8?B?OGl5YVNhV0laWTVVYnVNVDdhai9UdmhxdHNKalFxQXM4Z1dWNFd6Y0FUdTYx?=
 =?utf-8?B?NWVieXFzNkMyT1YyeC81NTlHOVcvNmZCd2drVzFKSE9DVG5MMmhJNXk4UlFu?=
 =?utf-8?B?eW1Sa3NsUGhxNSs1RWxkNlB1ZzhtTGZPanVsS3hWaDVyN0FXSU1zZnl2M2J6?=
 =?utf-8?B?cjV2SEczdjUxRHh2Uk5LbEd3YmQxU1hGTzFCTkIvT0YzQlREaVpOYURqbjVG?=
 =?utf-8?B?QnJnd3Z0YWpRVy9YRHNEc2ZUVkVCang5cmI4QWtxSkcxb0xDbUdhL1NKMWd2?=
 =?utf-8?B?RklnOWIxZDN3TVZnQmlFZExvOVE4emhVZEFmd0sweVgrQkIrTUxoZmkycTVS?=
 =?utf-8?B?ZEVoanRkelZGR2hwVjF1TTZ0R0g4QkxkTnhEUmFXbTFtZkF5ODAyQ2UxY1FB?=
 =?utf-8?B?Z2daekVOK0ZNVG1DMElqVDA5S25DeDIzcDFXTnNOWlhqWFRobWNmK3dELytr?=
 =?utf-8?B?Vm11MWplVjFGdjUzOG5yWW9TUzgvdXFrSThlSEJPZTI0dENIUmtid0laR3dp?=
 =?utf-8?B?NTI1WHdLZVQ5bDd2dzZpRndONXFXRTJsSGdxRENZK3JIcXNVUzIzRVdXSTZ2?=
 =?utf-8?B?VTk1NDc0RHJpSlNTcFlzNGsvUmh1S0RkQkd5SWpIa0ZWaTBiZU54QWVpak14?=
 =?utf-8?B?b3huUFhJNDlIQUV4U1o1Y2lqaDJRdkxwWGJaME94eUZtVVJGbU02c3NKYUJa?=
 =?utf-8?B?aXVSVU9oOGtmVnpQRU0rdVppeXcxUkIyWTkyQ1J5TVV0dUo1Q0FZb2JueFdI?=
 =?utf-8?B?NGZIZk9OeEdDZ2tqRVh1WkpZeDJZVDZvcEsyMklTZ0U4QVlDTnRkYlhFU2Q3?=
 =?utf-8?B?dlFZOWJ4ZEpvcDA1OXZ3dWpPRUo3SUJpUkRqVjAxNUtXZnNkY2JHTVlkQlhT?=
 =?utf-8?B?azhDbXVoVmhUTVBwODJpSmtaWlRuVHFDcGdHQWhSSzZCQ3N0dnR5MStDM09X?=
 =?utf-8?B?QXNMbVI0Y1pXUWl5bitwdFU5V3BoZnBJTDlFdGtDSDY2L3kzNlVpSTZ2ZHR3?=
 =?utf-8?Q?zOekEnmZZ4UHEI0QGN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88271104-831d-42ca-881c-08df194f2f73
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 08:46:40.1701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSV7X9T9/wrrZP6OXkgzkAZcL54qbeS/MtUbw3lrx1eYaGlPITvtaRG02ojN+oNk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929
X-Rspam-User: 
X-Stat-Signature: xk176nuk1jxd8wj8c5htjy1ehx6b6cpe
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DE66D20007
X-HE-Tag: 1790153245-760810
X-HE-Meta: U2FsdGVkX1+kLOifsQJhgM8wsNHoT4ROjO9oPB1L8L0DEpfYW7VgV+V1Do58a2JT85BjdxcXPgdIy3EzA58EgVE5LJP+zOTfnU15Zntnj5rrlDIckVozD2/oF6kzy5szAqq92chj9xNQswF/fPbOu1Cs+H6RwkfCII44zSWGyM7EK9EkGyFLmnsvlXM6IyXsARsWMQbUnv1+VpJ4zBfH2tPaKhaKMXFHMEElXp2YixVXToY9124czrsvfvXQEs6MmGsj87QKF9ibFBSe/JKm5d8FR7dtcRPQLTsfnzhEUCJo7RpguOaRxqVEvEpZV3ap/Wv1if26JhV931x0tVlu25zTIJMoOOP+5CKd6iG73VYxEeF0mQNseBRyiR1anzWQxj7mjCPb5byeoo9pGkZu9OLI+khiDxmsDLOWamIMHFt79IOkk8BaWnn4jSDLhX7pV8GUutqmi39zfRTS2l0eV5VnETyDWvtSlP+ZkzzsIRIQ2HS2Q+FeOro4KCgNKgkvw8XpH9A4NcRkWegXuD3k1TZgTGpHLdQo4/sX1/zTS/OqQ9vHI2/HsyKSZk/ye74jQAEXz2I37gi3P6YMprmlpWa+LvybQlNCq7a5Fzja9paF1h70vDDyc3jput75SjxRiymZ6m5wqhKs4uqJlxhVHF6Jl2MA5z364+QCdf7ndeqxQZraXawVQGG9X38euIclgEQnkuMQav6AmcKBwK+y+wLlhBvk9tnRxR2MqT4KpPobdtSqzF56TUFSyfYMVL1QB7G9UzuHKRpemPD7KK98RX3eYxR4Qh3tjoP/Y9mmjdQtHyl1IQg+HkY0mKqXg5XF0ud6oPs2AZGPEQbPZkNK5loBBbTV0P4J+MOebQHXv7eOLMYp+vcFhxd/XXUZRCtrtj45l8CnNocFQrAuVNhfkmSrwd4aS0k7DWUFrdrkBPltVq2jGWCH2s5dCH8eIPBRm2DyaE6sGfIhdmeugMw
 PB3ArP7i
 DVJD3im68ZJ1enKN7+0VA5QFp/q+PKyiD5RRu9lfa4eulY/WK41cO0E3W6VBHIFEzXvqJ56KqdX2Zz9mR+gtcrRSxQy3Z0zOtzz6Sao3yhRr4xEXoIiPHsi5f6eS9gIKAVffwkTWn2pg4eEuD89QDxLAf38Js290b6xxisJ/6fEPMmNFlWsx6/AowzUl8+MKz2VDSmVLn4qNqHR6ib5xzhC2z61Y/1N1fwY62FjCnwK0FEwCtsZ89QzCgvqNNc9IJLOligq/ULsIE2NXRQTHw1Eha+cZ/vILY83xWCWrGMSlK59FQOcnYTBKYACZTXFFV8IMU5/yDk5Qv+y38r6401qNHPH0zNkYVOgUvOb+KRkmdmbJITb0BoKRPh/AfrYn/HDqicHcnGNQaKPSQoPW2ywAFIGfyeaXlNooZyYL+Rs47meO8s2sp3ZphQMUuyHCtaFU0TJ2l/HBDpT0/d8O73FlML2e8TBQB/vRGqhW4hCV+t2zuDqpm0LKk+ba1yJNy96qcBrV1w2WLlyHMG6mFQfwtWbeT3aplHFEqmgPyRfG4wF0AV4xzNAhQvzx8q7T3ogtzXROV5JjqG3+bUlqc/ei8C4vKkJueNLC7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 10:32, Aneesh Kumar K.V wrote:
> Catalin Marinas <catalin.marinas@arm.com> writes:
> 
>> On Mon, Sep 21, 2026 at 08:18:46PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>> @@ -405,6 +396,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>  {
>>>  	struct system_heap_buffer *buffer;
>>>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>>> +	struct cc_shared_layout layout;
>>>  	unsigned long size_remaining = len;
>>>  	unsigned long sg_remaining = len;
>>>  	unsigned int max_order = orders[0];
>>> @@ -417,6 +409,14 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>>>  	struct page *page, *tmp_page;
>>>  	int i, ret = -ENOMEM;
>>>  
>>> +	if (cc_shared) {
>>> +		ret = cc_shared_calc_layout(len, &layout);
>>
>> You should not override 'ret' here, it was set to -ENOMEM for a reason.
>> cc_shared_calc_layout() succeeds resetting 'ret' and some further down
>> allocation failure, goto free will return ERR_PTR(0).
> 
> 
> Agreed. I’ll fix this in the next revision.

Please CC me on that as well, I will try to find time to take a look.

Regards,
Christian.

> 
> -aneesh


