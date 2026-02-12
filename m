Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53D6AEE36B2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:03:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921136B0089; Thu, 12 Feb 2026 13:03:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901E56B008A; Thu, 12 Feb 2026 13:03:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7851C6B008C; Thu, 12 Feb 2026 13:03:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B7C6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:03:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0864A57A91
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:03:06 +0000 (UTC)
X-FDA: 84436575972.08.F5C0C03
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011037.outbound.protection.outlook.com [40.107.130.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id 04DD614000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:03:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mR4oiFty;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mR4oiFty;
	spf=pass (imf23.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.37 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAVhsV4vMroAVaoK4iz9+VhkTIXrt5UzQykYoOzD27c=;
	b=x9p0/sDE0PFX7COWjGPTTU+4NgCAL7j3R0c5O7bH4UQ26XvSRLJ1D5mheJP857ishTguPI
	vC53MEuIrtNkacHWm0K4sS/HqQrlaKgbkTXAnAuQmbpr0gdpNNX1Fh7G1ZBiImDDl/tCj9
	jmBCW0LmnCATLXl2lEA6ju2kUIz+8rU=
ARC-Authentication-Results: i=3;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mR4oiFty;
	dkim=pass header.d=arm.com header.s=selector1 header.b=mR4oiFty;
	spf=pass (imf23.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.130.37 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1770919382; a=rsa-sha256;
	cv=pass;
	b=Art5NXcBUFns3cwsC+3JcPA9MHSN1hTVhee3XRCgUmx5n8jOrd9SQHh1Wa45dnSlNJWBxR
	143EsNBNrynslea/u2/pt5NHOnPYrYw1Itykedm8Ewr1hzcL1wAF5ltK8CsW2DKyPGBy1O
	sq8HYh3iJzXwxmE3Td53YyOwvB+EMUg=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LJVP+iAhcn3MpwJDwpO8ICKu9bIPVtgdtZGR0HtsLE7Yg5f5NDj3572lj+rwgVAgR+xlZyhgVHlxpzHdqssfR0nk8tRGEWeDrC/NKeKUV/PwiWwtA2Ve65KT0udU5bElTkCzBIQo7Tp26l3wntEukv4QkNZkw+ZGO3ZNR4UxyTppPtjGR19fL4YZoECNi3d1R7ZRT0oPREBSMe9FXqT7LxpvaBcpMAzYIjd84EsRjGt4CvPTDU0CmIJ0C0Z0S6kj64aP5nN7v5+p2f8avYop3zAOywIAFFhjJV3iV5AfA+aG/kCb72bu/fbQPHoB9KY88IMqJ6MonUOBl/0Q6qI1tA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAVhsV4vMroAVaoK4iz9+VhkTIXrt5UzQykYoOzD27c=;
 b=ilnIpOMh/7EHGnbOQReSchrQeRpE+LTIUH3gUgk9v7jendGPB2EguDxOJcG8InOXXQB9Xz/mps5ATcTbOQ4WeJpzyz71f0sS+u0O2oaOAkafl/g6vG77RNzkdVxfh+oaZfMvBEbu0cLyJ++fhdwPRM2LNDLGd/HAQ5mFhhwzgUJxO/ATjFH78BH5p8LYhl/N6eX9dCvGcIai/cf48ogEwKgAG3CzUVyhVZPkuWRP3Ugxu7GLCbOd93MP4T+MteQ4BhhwqqqRqsV8u/Dh/ABOru45qCdSvgr6xVncPdXF4A9KrkkhVDhVIf7xYZKKCROqT7W/rncKVjLxuiaYMH1G8w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAVhsV4vMroAVaoK4iz9+VhkTIXrt5UzQykYoOzD27c=;
 b=mR4oiFty2DrhpCB8yegsypDc+UIzZb5qKmYLsXbAJnDrxO5iHAoNSblT5ElkDBQl40gY5aC8xrYvjhr+NpLlhTy/lmhCtaZQJYrY0QyszZA/NJKRG7894pXDTCjee9OWMm0E9ZKyqnfclm+wj0vRauzNl0xKwUcaYCQNWkHMdvg=
Received: from AS4PR10CA0026.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5d8::20)
 by DB4PR08MB7935.eurprd08.prod.outlook.com (2603:10a6:10:379::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Thu, 12 Feb
 2026 18:02:52 +0000
Received: from AMS0EPF0000019F.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d8:cafe::22) by AS4PR10CA0026.outlook.office365.com
 (2603:10a6:20b:5d8::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.11 via Frontend Transport; Thu,
 12 Feb 2026 18:02:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019F.mail.protection.outlook.com (10.167.16.251) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Thu, 12 Feb 2026 18:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yk9oItzr4ZXeh27ia5NBl4N8xl7LLKGSd843jGFKPbUhcFPYTKgcYt3qu8OKPd2brwxthLFv5L9r+HBFUverU7XfUwmkHeYjOe+ztwMoAqwCdWHdYh5tV27l0Z2si6mMuE+i+7mLE6pocu1SiiOhgkap7TG/co6R6JEongC0QDCMZ/6uqpTLI2uy915qJ8MlxuMLBFKxPixmuCKUiZCL6kpRcCg/D/v0VvNxJXvW6qCeHU0PTPWeT8pcbLI/yOvd2kynzEIeJyer+XqtuHG2GAnIWCbULaLeuo4GNS1UNComSS2GhjrEloWj4GOE7tIt/mAO7aWqhPcIm4GQM+ZhEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAVhsV4vMroAVaoK4iz9+VhkTIXrt5UzQykYoOzD27c=;
 b=K1SMhhc7rUbXSZ5SWwOH2QpGLhzv36WJixbGSLm67HszaOWFbJfsriXZ2IjqWNHNKVk41LE+lRiHKTqw5d3zicKITcrDkQSPdN03HT44t36NnOkTiDJdTRi7ES92ur4vxeeyEUBgwLe1K0Ns9qkXa7CAg1UJ0+qxJWaSti9BgiZ3+V7kQAG6bBpepHYBWNfNMiM1jwQ94zuB0YHOyAkdF8GJF0u9uoH6wxXBXho0F6meANkjNsWNRtbGU6SscXjAL99wngwPM2/jvNvy95lHjls6dFE7gyra4EDfCcR01WeexxGmyDF0eqvMtMSOXMvutKDHS2NPbHVtDkw7pV4XiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAVhsV4vMroAVaoK4iz9+VhkTIXrt5UzQykYoOzD27c=;
 b=mR4oiFty2DrhpCB8yegsypDc+UIzZb5qKmYLsXbAJnDrxO5iHAoNSblT5ElkDBQl40gY5aC8xrYvjhr+NpLlhTy/lmhCtaZQJYrY0QyszZA/NJKRG7894pXDTCjee9OWMm0E9ZKyqnfclm+wj0vRauzNl0xKwUcaYCQNWkHMdvg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM7PR08MB5526.eurprd08.prod.outlook.com
 (2603:10a6:20b:108::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 18:01:50 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 18:01:50 +0000
Date: Thu, 12 Feb 2026 18:01:46 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
	linux-mm <linux-mm@kvack.org>, bpf <bpf@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, david@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com,
	sebastian.osterlund@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
Message-ID: <aY4Vipl+4rGa+u6D@e129823.arm.com>
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
 <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
X-ClientProxiedBy: LO0P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::7) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM7PR08MB5526:EE_|AMS0EPF0000019F:EE_|DB4PR08MB7935:EE_
X-MS-Office365-Filtering-Correlation-Id: 2225fb9d-9454-472c-2795-08de6a60f0f7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?SlhkcmpYWTU5Y29mdGlvTy9vTk1qTTFaQXpwbUZ3aEFrSlloaTIxTkxuVmxz?=
 =?utf-8?B?djlFWnNiamRxYW9DdFlWcGg1dGJDRWRJSUtqYVkyMzFaeVJkdTYwQkZZR3hk?=
 =?utf-8?B?S1lxcmlvcWs1WGNFcTRpa3BwTlh4bUxPam53djJ6VmRlZDhReGVDR0ZKK2ND?=
 =?utf-8?B?RE8xY1FCWWRDYkd3Q2Fja21YYmpOVWlRbWM4RTFOdEg5V3U4L0JGMGdDNlVp?=
 =?utf-8?B?aGZvVkc1NU12aDZQWTV3b0tKSk9RK0lTZzVmaHl2YTVBUjFsWnlWMmxnaS9v?=
 =?utf-8?B?dFpEVW92TTVjenZrUEpPU0VKc04zU3pCNlQxMzNyY3Y0bGpHQ0FXdTlJbDRz?=
 =?utf-8?B?bW9NaytXWk1vM2I2TE9pQ3NZYk0xaEgweVJHbDNkM1RDU2pGZXlLRlhnd2hC?=
 =?utf-8?B?a0t5VTlEanI4Y0g0Y0dmR1B5UzJKeDVscjk5OCtNUjV6ZDVxMHhLbkdjeXVy?=
 =?utf-8?B?MDJaZDVkejM4Y1pQUkFzVUpyd2hTT1dmNCsrWVNCeWtlLzMwREZQdlBLLzJk?=
 =?utf-8?B?Mk1kVDdkaTYxc2pHaUNjSi9jYm9IRFRkdGRKVDdhTVVvV1VDNGdaS2k4d0g5?=
 =?utf-8?B?N3RQdkJ4RHdCVjI1MFNoM0RiUHdXNDMyNUtyYmgvdHBSRnVkZVdTVmtqRkN3?=
 =?utf-8?B?YkhXYnJUeTFTVkQzWWNxZjB0cVhlL0FHWitUU0gwYVhLdVhCTnQ3cUJJalhB?=
 =?utf-8?B?ZGJ2T1ZkY3hCV1JKaTVRUUpVMTVTR0E5Nm1PTzMrUkllUjZWZzZtS20vdStj?=
 =?utf-8?B?dnN0c2ZnSjdFSE9hWmZWekp5a25KL3JqNkpXbVp4TGlJMjFkbitnL3h5WEJ5?=
 =?utf-8?B?bCtoZGhjZ3pSL1NWVm5lT3ZJTEZNUWV4eW1sVVhMZ3NCL24xaTZpU2V1RlFJ?=
 =?utf-8?B?TTV4UnFtcHpCRytjQW14T2tTYmRxbkVqMHphcjI2anVJQVpoNVh4UUVkTUVh?=
 =?utf-8?B?RDhPbjF2NTIzQTZZYStpS3k5Sk5tQlZEQTVoam5XNW9MdlE1eWZrSnN6RUhU?=
 =?utf-8?B?YlFUeFQvcU1RaUdNTEkyYnNoZUNJQUFnQjQvSmMvajhWeTY5ZzJwSUoramxP?=
 =?utf-8?B?aHJsay9xdTBPQjg4aEswVXRmd1VtWTBhY0Jlb0c4ZWlMRUI0dGg5V09Gc0hn?=
 =?utf-8?B?SkVrUUxtcHBURTMyVkFvMVRYKzdSWGtPNGtxOE54Qlp2ZjljYXc5T1dmS2pm?=
 =?utf-8?B?K1BFeGwwb1J4dFczTGkra0dMNDhTY3VoWkFGY2hsdWdYMGJTYzA1SDdDalRM?=
 =?utf-8?B?elZLMmdjb2FuV204dnEyalpwVDJZUkN6L3Z5THdkTUoxcHFxVnVEajFESGxT?=
 =?utf-8?B?Y25KZ0pqVnVmSXhseGNJR3I2WVVhclcwWTJLcDV1MFpVekIxbmFhMEY5OEpW?=
 =?utf-8?B?SXU4TkZnYzFpcDc3OHpiVXZOUURyMXZrWE94WEQrTnlleW90Z0lUSFpZMjZh?=
 =?utf-8?B?czVWOUJOaGZwaENTTTh0Tlp1QVN0L3hyVThnb2IzOGtNQTdkdWx5SmVlbUpx?=
 =?utf-8?B?V1lDd0xkMXRSS1IwTTI0T0ZHbHpiYVo1RklBM2RsWkpLOVB3ZGNxbVZWV0hX?=
 =?utf-8?B?Vytsei9oUlpQSk8rVTd0M2xXeGZiYm1vYXM4TE1PTFBHdmRZNXhmdkNNM09R?=
 =?utf-8?B?aUU4dzB0cXk3ZklYK21xVTArQ1g5YzlwN0htVTkyejhjTjNNRVY1TjllRm9W?=
 =?utf-8?B?ekRzM1Q0cCtPNzFZUjY1WVFSczMyM29sUTI2VmV3WWtLeXIyaGhobWgxTXk2?=
 =?utf-8?B?MWFjeTNjQ2s4UncxaG9LZGptQTEzbGxOOE56aS9LYmhtYWRlSnhxS1VNOWdE?=
 =?utf-8?B?UmZYTnFhS2RRRENlZS9jL3czM2grRzBlbEFua0oyaXlZNjhiNWdpYkJPVWxy?=
 =?utf-8?B?RVRmeWtTTmZBclVVSTVOVmVvUHk0VEFLejQ5VGI3MzJRNTVsNE9kV0dXWjF6?=
 =?utf-8?B?RmgzTks2T3hqR2RjSnJZZHVKM0JhdnEyZmdCekJZTzY5cHpIaEliUVdpejVE?=
 =?utf-8?B?aDZRYkE2a1lJUkloajZJS0JNUXdPN04zODU2cmpSQ3lkVmVpeGFnSGllWURz?=
 =?utf-8?B?Y0Z1QmJjQTAyQVpGZEt0WGdabi8yV09KamoydThiRzFvc0xjdlRtTURIWXY1?=
 =?utf-8?Q?9Pd8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5526
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ec7c3fd4-e596-4b31-f419-08de6a60cba3
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|14060799003|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aW1od0JSU3AxNDhWQlBGNHE5L1hHOEc2SWNzQXM0NU1Rb3VORXMyNWJ4aXZL?=
 =?utf-8?B?QmRqTFV5U3Jac0ZuY3c3eGIyRkxrSG53TjkzWWJ3Qit2VXlsbkt2R3UwSzY3?=
 =?utf-8?B?MnZqY3hrcm13VlExS3JnSEx4TStkcGhPNXEzZDdqT0c1NGxGcEhvOEozWUlW?=
 =?utf-8?B?OW93OWJuRGhRKytzUFhzRlBkbk9JekNzTlBvOXRjQjhOY2xoV0ZYRmIweEY4?=
 =?utf-8?B?WTRXYjBUV1dxYjh3SHRHTGxCUWtnUUN6NFZkYkdXc1dLMjB5SVYxZGxSMHZL?=
 =?utf-8?B?UEowWlhaR3MyUEpRc1FORkRQaDZWRHVtUGR1QUlYWk9oczE0TXQ4Y0xiK283?=
 =?utf-8?B?bEZKaUV0OVAwMlllYkVvZ294YjgwOXE1RlZTYW9ScUJmcmxkenluekdRZWZS?=
 =?utf-8?B?SHY5ZHJ3MVdoTkpTQUFTdkJwODgzUHdKY2doV1h0NTBKT295SDBDbTBiM0ZX?=
 =?utf-8?B?YTZaYjRKTDJiK0tUMWtDYkdRUWZ2b0Y2RS82b2tPc29LTWt6NjdzTGo5Tmp3?=
 =?utf-8?B?RkJXcVREUjhGUTdadDZVZkFRamxheU1RdzZEa0RJdkcxT01OcG5iOXhlbUxn?=
 =?utf-8?B?QStyVldqSmgxZnl4cGt4YTlBTWYydUVLV2xhK1JVSkNpTG9PQXgycW9QNUM0?=
 =?utf-8?B?VGkxaS9SVnQ2dG9xMmdpNFpVZGp1VE5HVW9UWmhqMWpDeExDTVp4RDB2UEYx?=
 =?utf-8?B?aklRVU1VaERkeHBrdElIQS93QTBrOUxXcWJVWnlzLzRsNFJld1dUbm1hR09Q?=
 =?utf-8?B?eWJmb3FiQjJJcFZDZlVOeXU5U3dqb3NTL2NTQXdWRXhaeHlUd2dMeXFQb3lz?=
 =?utf-8?B?SWNDTGVia1NsWS9BMzNTNGR3RExHTWhHM3h0dDQ1V1R2Mk93bzFWQ3FzVFda?=
 =?utf-8?B?YkdQb3ZYeTZZdGxXM1J3WjFQQVM4enk2MzNPeUNPQUw2NHR3TzRNQUVlTk5L?=
 =?utf-8?B?dXRRcFE4OTl4OVFNRlVySktpb0hSTFhtK0ptMG5VZHJRUDRkMWwzQyt0RVI4?=
 =?utf-8?B?dXpPTm9jalBJRkRhK3hvUzBkODcxUy9yenlBeEYyTGlYcndNNHYvczZicXB6?=
 =?utf-8?B?RnE4Tkx0MkNlU2xKN3hLZ0tqRkZNODN4eFY2eDdmaTNHN3lzRExBekl2VjZq?=
 =?utf-8?B?eGlKenAwM0l2ODlBaVB1c2JWWEtsWHkrWjAyVjMzUEdtclpoYnJoU0lGbzd6?=
 =?utf-8?B?V3R0blQ3eWdkNVBVWnNCdnJzbDQyRGdvTGFVYW1EcEJSOUp0VEVPMW1QVmRC?=
 =?utf-8?B?UEJtOGxDY2FaYzhIcXlCUzFtdjdEYnArdXZOTXB6VCs3MTJtZkFBQk14U1lQ?=
 =?utf-8?B?K0JOYTZ4WDdLOEZGMHhEb1JkSVB3eVJyTld4QmpINWc1ZjdxOXhhNGNIdlR5?=
 =?utf-8?B?Nml0UExSZHQ1ekRLZDQ4VEVFM3cxNmNNSUxTaG12dmRDNXBHOUYxMTlweTEx?=
 =?utf-8?B?Undjd2d2S2JPRDc4QVVaUTFVYS9jRnJVYkduL0taU1UzYkhGSFgxRkhqOGJH?=
 =?utf-8?B?R1JSMXVKKzh1QnMrT2VQaHpQRkFFaW9xa002N1J0S1MyWVo1VVlyRm8yTkVa?=
 =?utf-8?B?MDdJbHhOMEUxb2JaVXU4akdlRFlRWUZwQkFiaFVSV3A2dU1iemJ4L2tMZjZ1?=
 =?utf-8?B?K3dIOURSTElpU2YxMWRZVHRSOCtNc2EyUGdBQ3QvM2dwRWRLbG9tbTArdnFS?=
 =?utf-8?B?bjRpOVRZbXNoMkJoZHU5bUVKYkE2NFVLZjZsQnpKR1ZEWnNwMFZiQ09jRlhi?=
 =?utf-8?B?RWFhNGphWlk4RWdaWk9QeWxWd0k2V1hFRGI0ZG9IR3k0amkwRnpyMGZvRW1K?=
 =?utf-8?B?NmpwYW9lZkhSbWFmc09lL2NDc21tRi9kVWdjTTM2MENYQldBRTJta0RzWDFl?=
 =?utf-8?B?YmMrK0xIanEveUlqR0xINHo2ZUsyaEg1eFdGRExTa1ZWU0FVM3FCSGhhSkkx?=
 =?utf-8?B?QXRZTU90ZDZNUGVqYmJ5U2poMTcxSVF2NXVNcVdXNjQyalBRWHVHZFBzRklS?=
 =?utf-8?B?Q0pPblVXbk8vYlc0USt6bnlEenliUkVQWEc1OExIMEtPZGRjOVRPTFFVWjdh?=
 =?utf-8?B?R0s3YXk0SC9FNy9PVXMrblFmd3lmZGtwMUlwMEVtbHZINHhZNEtvTGJmVlhC?=
 =?utf-8?B?Z1VBMGNXZzN0Z3VUTHR1QzhQWmpzK2dNenIxRVlKQXdhVnlERmRLcVFsOWRh?=
 =?utf-8?B?WGxVd1JXVGw4QnI5cHgxeG0wdWZBRmJxaWNXa3Y5cWJKbkV3dk5sUlp5MG5K?=
 =?utf-8?B?Um1SMU5aVW9tZkRtdHFaZGt4Sld3PT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(14060799003)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5Bt5Xt3FVrlGH3f+YtmrrU33pUaydRk7eKCt2yO9LU5pA7zw/QwrYiKOf52AB1ADThfnZl5upXs9jDRCQfMSHux3SDz16s4QRz2lnGhphpHZwpbEcqjOxUpEIlx2ifP0BWiKKUe3JelGUYMhup3Ymfpqa7bSvw5m7BxzqYFeP5gSnCRRIYp0QjKK6lzOLoDL7knCfl4FuqFTHwUWK9TwOkaoeuBCzkgrqGHSOgLPmn442Na6ZobIdnmo5KkAlCK8+MW34zz4nNjm64hRqSHl6eo1rbuJ6fduVDZI+nDs3MMg1kArLYFRpZoYug5kYqR5mVPO9sMOmRT03BAG5PjiNrI3A20/+NiYQ029ETZro7Z6hQo17gEJwgb1W5xZysz8V14d180yLrKP19Wtn5iahybk5R5rO5kZcqdrWPgSla1yOsEDSAe2W/3RXrdWU9Xa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 18:02:52.4495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2225fb9d-9454-472c-2795-08de6a60f0f7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019F.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB7935
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 04DD614000C
X-Stat-Signature: 358fw41c7pz13jes6tsobeqow6k376o1
X-Rspam-User: 
X-HE-Tag: 1770919381-870705
X-HE-Meta: U2FsdGVkX1/V/tOy6KGU+Y0yXHURshKwjXTWP/98V3AykEFBX0Bg8BLOUgaMrk55Qvcc+2N1ex+0c9XbdRbP5pVKMrXAt/H6tjKknFHtg6GYTHIrtqjrFscGugoj/5Xtnl6Z+kGB9d25GjRK+cNVR6L2mMWcVF4RIe97RZ14Oqf+8znrIETXUkOA84QtD8026sqm0qe1siMfHQA1XEZ31ANHUQn+cuOjCVQmYzmWETOcm1Z7TTwzj0yoCAgehPeLu+qXKIM3o5jpLilIChi78zMMNW7SGLNi1BLsJgNufusNE06MdNPA8aTWdMt4FnVXOFMyqzyvUqAZXkhGYr6hkwBSneQr+GSAF+4ehfJwWQuIDWcEftxu4muLuQMa+hiPZcOx9wqxR/7Ic7crVI0BkBcOHrVdObwSzxCtIemNZYHr6NwzzahS9e1S3I1mYUDGIP39SEsATqovRbYf6JdgmpE8H5hq+7Jx1jVmSEfGDs1/+oUQ3E2RSH4CBCslL21kHNoKOdT/wVxpQYxalsUf0QB1u7jhBWX09sqqYSHVMF6rhiQwTqCENI0WVl7ttrGq/l1WhiYqCGjB3TeF/WRqzRPJ2mYrufd4NhotijbWhw+rQbZ+sumdEbmMbjjsZq9vaDw6nIbwTO8idTgDVrCgQCbXEhIhEkxWuBH+7VICnjhwzHwm+4GRC5wMHJU9UOSanLpZUVHYcd+sPX+WGNtuyDGHdOpKiKfHUIso65Ka+2k+WYEOiNQF6alTRdFnrDN7imWXEcckeHgw8AcKWxfqYxj8GFOHp2ezuEa7Fv1/3zbNa1i3Pt44yR+jVI9d/TMDtMvP0huviOi6p+p/24T4mHYLqtYesjxbK/7a7KFLzNT8dt6qvBL5GRYDC9wFzDsrNNP7mS7N0f8OIZYdDpFg9vqL9It3ThMn+drMF/+OFoHdgZ8bUx+BFLh+TSivhg2mTstbYf21gJGY0Ae5npr
 j943g5+b
 ddrv/6wjtV0hs8neeMJvGKWKqE6O4w1Iogl25q05SYMn1O65nFOP2C05dWXw+r7Kb1UYQGh774zZmNA8MhKJ6nZORjDTIAfe5XPmhy6jcedEzGixKMawo90DHZHOQ18/xp1zXpzTCOBReVVEICn6gBGkhkgyAIKIKGN6fcI/TJmy3smy0ziQkGTpWbMMEN8JcGbJ/6kVa1PQfhwR41wuCP8CrO+qjHoNQQwW1RMAcwbT3fsneVLG0oIImXvZYkiJHGwjbQq/rc5Elc/qxyAF0YIX0dNDR//mQ4RSvW0griORGKPi6Imd+jqunh8JDRMULlYmWPNcz2StYN4NQ8bwRy1zubcKRhKbKYOFjpAOPm6n7wwYAH5abETOKOouzPTgkiz01uXD0Aado2ONxQN6EDoMiz62eqVTsMTKTCascmN5dks5IVwDZ4N0Gl+wHmxISoICBtt59iMVgskRDNEMGqBtqmkcujAKAFV7vTMZ9eMTwQyF2S4ZPSev2dv1lfU2ZIq7rhAzq5GMr0RfpXN4908Is5EHNlxWnuc6XbyEmhZ4ng3Tx7/KZbErcoNnn2XJMO34xR12cgfeqgDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexei,

> On Thu, Feb 12, 2026 at 8:24=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com>=
 wrote:
> >
> > Hi all,
> >
> > I would like to propose the topic of eBPF isolation with pkeys at the
> > upcoming LSF/MM/BPF summit.
> >
> >
> > Background
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Today, eBPF programs provide powerful capabilities to extend kernel
> > functionality without requiring modifications to the kernel itself.
> > These capabilities are largely enabled by the eBPF verifier, which
> > enforces memory safety and other constraints to protect the kernel.
> >
> > However, vulnerabilities in the verifier have repeatedly demonstrated t=
hat
> > eBPF programs can also become a serious attack surface.  In several cas=
es,
> > flaws in verifier logic have allowed malicious eBPF programs to bypass
> > safety guarantees and compromise kernel security.
>
> eBPF was restricted to root for many years, so the above is simply not tr=
ue.
>
> > Representative CVEs include:
> >
> >      - CVE-2020-8835   [1]
> >      - CVE-2021-3490   [2]
> >      - CVE-2022-23222  [3]
> >      - CVE-2023-2163   [4]
>
> None of them are security issues. They're just bugs.
> Like all those found by syzbot.
>
> > An RFC series is planned for around Q2 2026, and the experimental
> > implementations for eBPF isolation with pkey and pkey-aware memory
> > allocators have already been completed internally.  Using these
> > implementations, we verified that eBPF programs running under isolation
> > successfully execute several sched_ext applications provided by
> > tools/sched_ext, as well as some bpf kselftest cases.
>
> The stated goal is wrong, hence not interested in patches
> or discussion at lsfmm.
>
> arm has a nice hw feature. Sure, but this is not a place to apply it.

That is correct =E2=80=94 this is a verifier bug.
However, the concern is that such a bug can lead to a security incident.
Not only root, but also users with CAP_BPF who are allowed to
load eBPF programs could potentially trigger additional security issues
through such bugs.

The proposed isolation mechanism is intended as a safeguard to minimize
the impact of security incidents that could arise from
bugs in the eBPF verifier. For that reason, I believe LSF/MM would be
an appropriate venue to discuss this approach and apply pkeys to here.

Am I overlooking anything?

--
Sincerely,
Yeoreum Yun
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

