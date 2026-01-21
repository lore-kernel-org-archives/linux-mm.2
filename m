Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 594F8C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF506B00AD; Wed, 21 Jan 2026 11:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA316B00AE; Wed, 21 Jan 2026 11:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30616B00AF; Wed, 21 Jan 2026 11:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3CD96B00AD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:51:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F4891B0571
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:12 +0000 (UTC)
X-FDA: 84356561184.04.8E51D52
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0004C140013
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:51:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RANmLMA8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Wt622WWR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
	b=ANsNI3VkQwkb/4Hy9848QRIl9+vCLVfp2yGNBlBerWDc5f80lQhIS47/hoLNFfq5vCozsq
	MiUVmRUAJapBODZtxL1e4Nof9BNDxzebpj8SADg4D6gSwoAEcvIYNg28rj1IhWFAh6O9dm
	atKo7pvUX/y4ViATuHG8I1d7oSWm5ic=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014269; a=rsa-sha256;
	cv=pass;
	b=MptngA2f6+3Ugp7ClQQ6i8jQ8NfTz7zCf1UejZASTMyXNX4h4IEBOY/3g6T/h1kWGFMqgN
	vlY8lU8LA3UjFDJYrTwEDHUHJ8apkNdmvMNPcrRzCVFqx600DHgma2Hey1IdBX+GWqEw0T
	//cep85eNcu/cNv2ET5UIoRJwmTTcUE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RANmLMA8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Wt622WWR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFIRUA420923;
	Wed, 21 Jan 2026 16:50:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=; b=
	RANmLMA8JGF8UyLfjkpBlieytIoYbLHQ2jtDphZXT3s28sAJZXckRpzahsjJ++l6
	3u1BxCg+W1ySQRXRakJIdWZhUkVvH0n5SSDUpUVkxsP9cPmNRtc/cZ3Y4XD2NfvO
	+qOPkBS9ZMxaNzssXsTL4P2+GGyPLcw2AVybJaBIQliSUADjxeFgYrJQQ+pJpHYY
	OIs14uS2nd9XqD3wafYXvs9XXVpTII45xlCHQ9ipiVj+60C58tw6yam+p+Y+YKMC
	upcy3Bcy3HMLLeZ4Y3qNhEv8WKgAmwDdbD5kF/SA/yuRwWF2TvvLJupwGWzKHfN6
	KTA+s/IHFpjq12DGpg1YJg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagctsyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFZ8dX032198;
	Wed, 21 Jan 2026 16:50:54 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010067.outbound.protection.outlook.com [52.101.46.67])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfacqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=buJd4e5PH7VLVtD9s1sK5heXWMYBVd/DYAy4SblhrgcJIXRQV2v0gjS8+bujsjkAG1Htt1g94BkGPKiTN00Ox8PqFMwuCDTy61lMBxP3QOgpIHt/1fB90mqOyriJ8GdmmNsloQpwhpqolsIK8Lr7YdDuGSsRh+I/eb1BF7W4dH994ZfkwR7PcmWcPziw/DDZZxWj2CZw4Qqazb9BNRbS5Mb4c0pJYcYveUlBS0UWqp0F8bb3hxwQfKUqhMsKkMG5Mt3DWVwBiNadgnYA7p1ufRSaIka/1/QotCikoasR5VZX4W7jbo4poA87uB3A5xI3NjdBjW6nyqSGYNwe350iuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
 b=inUFo5aSAxnK2pnzFKJazjxX+n+8NmEAUDFr4C/T1uAD+A3Tdy+nzKfs632C9Td8HSUpiTZcmfqLty5wCiE9c3bikXtewUzFXDU9BHoTa+MQ+drcb8z33NBfk/xHi9ReEUACQYLtemdEa4WEjE74SHNRSQuhIeeccUr2oELTNlDAR2eErE+uwCxS8l8AOczLGN7Uh1rqjWarv4QgGvZE8AeCK6gBDRH6QUiHKgHV8qmYkLa+3clU5EKEmEK8gSDLbPExpGmMgYW8CeKjTyh2ZSwn/3LVt26b1IiDZ5frxp3K+FAb4TqjtcaTGS0pOTXqvATl8GsypEnlX8qrvChcUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpCrBGdNAAAxeutEPB+5jLo/y6sd9s6YXgyfaqDfFXs=;
 b=Wt622WWR/p2pn+Ft3Qeiiud2cwgi+iF2JwtlYpUolujXK/W26+cYZrocLsTBXfPOX86eonLkvyKNnNde3Ng82WMx/15ei0fjTuOTI9GmfzPaos6G5xaHcRKIXyHmor/1R2PYmZfSJr+PUfqykNbSunoqCgb8Z85rOEF5gm/juT0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:50 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 03/11] mm/mmap: Abstract vma clean up from exit_mmap()
Date: Wed, 21 Jan 2026 11:49:38 -0500
Message-ID: <20260121164946.2093480-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0483.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: cc8870ad-2950-4f45-b065-08de590d3ba8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SQMOSTTvPcCc/BUOgwv0E633on5zsGS0IioIHZ+gQaj0vGrHAMlbCgBkXYZO?=
 =?us-ascii?Q?I1YduGcen40aNxOoQd3AKK6mayldv7YOx+CotRRhJLHQgsmhi4T7fVHvLkla?=
 =?us-ascii?Q?J2ajTVkmYdt8MAeO4AEmQ22Q9FeNzn2KeGaP+pFNXWnPqVuNBE63fVNmrwiZ?=
 =?us-ascii?Q?vavMdBquqiu3eUaQaP9PritDp9g1fBo1tquantxIkkCD4l83xUZBFJZcsahq?=
 =?us-ascii?Q?6mD5tK/vehzGwTjPjauta/1JvuJgw2HBY+TN3OZN553aEKW6pRJbN+23ylNJ?=
 =?us-ascii?Q?ya4EsCgXMiBoEnhRfj5EV0g4YgZj0XJ8U/HAQUMvSuozGFdpSM+eKAfwo9PY?=
 =?us-ascii?Q?RZgceLmBpCQTkidqbYuuvN58ZiJJvaNhO5ALoMq1nM7Qi0ydu/cjuh/n7RAu?=
 =?us-ascii?Q?eBLtzE2gkidagcucaii2JPGX7Yqbwhrn6mXcsF4A98HEFjpv6AmtJGzIxcQX?=
 =?us-ascii?Q?qzp+gip3dSBzuJcjv0jcUaovAxLyWAs05vPm7uK5yxes1rK7byVLrqpiuGXL?=
 =?us-ascii?Q?ABCLTGuFJrKSWrLUP924H1GZw4LqDEfhiFu1pAou3byCk2JiAvrg7Io4eFF1?=
 =?us-ascii?Q?uqRdY0ZK/3VxW+R/fnpd2IPyAy4m0Q3GckJxdHlMOCsLOyYFqZUfjarGidr3?=
 =?us-ascii?Q?jQEbb8xuGtcm8UhDzr+OnuAvG80l4XJvAe9NVZazjv8d73bor9QpozZmin2+?=
 =?us-ascii?Q?NVqZopMuUip52n574kGD2Li1dMKpivmBqB+AsblbpIzCDH5I87/N4lqB89hJ?=
 =?us-ascii?Q?Zo6t6Jcf3A46morKWfN0P04mcsU9XLB6iqN8PfhG7Xg1KzaBOVBC5zIDEOYl?=
 =?us-ascii?Q?zSOT01SeqeFK3CWvxUc1bpe2orr1oQl4dAXv8NyveuheAtS2EOJ5JjPURhMs?=
 =?us-ascii?Q?1dx56ltm1QexN3wiuCWWTGkp6MeHP9KwuY59+vIzi5OEmvw00FpuWkm1qP88?=
 =?us-ascii?Q?x4AMekYF19wXrYU2+fQVrdvlcoVETJ8IQvnU/d/WWbwvMyI1RI4qYM4PS/VU?=
 =?us-ascii?Q?1IHIY83S9W1mz0ER1zXxBJRz8qPmgH94gKbmrUB0TloYUYkRMFVCBMUEBtU3?=
 =?us-ascii?Q?AdIrWw92dNYvDEnYiQlQNKtHfgor8pZ6KjYAWqlihCrCQ11eruhnjTVRWpbY?=
 =?us-ascii?Q?ftoUtVcRyEHc8KcUzM0+NPkUr9z6VlvC6cpVcRvv8h6UEMEDJhQ3SwSoXbi5?=
 =?us-ascii?Q?NyFmJAbeig6dk9cwMx8gdf3yfdCkB/RxcG911msbbeq9RsVPbZPFejuaNPIG?=
 =?us-ascii?Q?2ruYRlVkFjC8ab7GBzyze1K8I9O2ckFNrlV6paz2JtMkYaMmuAzBFvLnD3y+?=
 =?us-ascii?Q?4iVNiz9yjtjaDyyBDy0YNkMHnCK7efVBiL1CfMwG2q106c0r4A39DT0f9lOu?=
 =?us-ascii?Q?DEbEDk7712G/HAATGzj5cR0YaIo5BYh6LrnXwyAsPwn4XxnYX5ut5IriFnhE?=
 =?us-ascii?Q?XlR4RFNfBAlOQIuevfJ4T0zYPVEwyneR/DG2WryLzjh1bZqSIbr2W3FGNDWK?=
 =?us-ascii?Q?3AcM13SEWhh17uUJrsl9/1Dp4TMTfsMJhC9GGmCBxAyA75bDk72ZeE4IyxpV?=
 =?us-ascii?Q?BdGuaZiQN8AyzJoCpPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jKTG//jNfpellPm5fhtf/76rG7Y390XHnzCCFO1a0If/2VX33kDPx75+NPDO?=
 =?us-ascii?Q?jssmfmM5bxP3ZztaPPVP0lxnIHe3dsx6doBZDdiIJt2mGMG36r0EIsTxiAsg?=
 =?us-ascii?Q?5qkuyiE2ttQ3OP9zHs6mu/68fGXrQhmThTN/hj4ek6bapTRVy62OemvO6Q0C?=
 =?us-ascii?Q?+HWaNesW074YoFY3lBSUYFwZ44WK8Vd1tAXpC2agqVDpguHn6h8vZK7f7iNw?=
 =?us-ascii?Q?7PO/mU669KQXhYe8Y5K65B/jc7x5J7Huv8H5ePxfa07FN/isSIDMy21aicZu?=
 =?us-ascii?Q?iuEeqGvpXIg041B2w3sriSewVsio24uEGDo1ecMZOZwrc3dLrqXmcc8R/oN1?=
 =?us-ascii?Q?ic3viYqGyaXi58+Kr6afgMIwNzN4FzPLr3RjB0d7eRZ6kEM9sZAZdycC2uRl?=
 =?us-ascii?Q?g0/sbUB0tdTOzUXjr9o/FqnaI2FYbiaY1424AhXGa0Woiy578MZvl5kqT/4R?=
 =?us-ascii?Q?6FvHXjVMhw3nGZIj4yYsIk7GDJWlQnGIRMa2FXh662l4CISsmlnGElFtZCwi?=
 =?us-ascii?Q?PdMTuZXHrolNuaHIaBpOekHfIH4BE1W1GQdrkwtnl6AlJ+GLkaZoXNjAl2r0?=
 =?us-ascii?Q?/Mxnt7gJFBgD2jCcXmvwDkjued/iPXpG1CRgYxByh5I4Nwbgu2Pax2zVImpU?=
 =?us-ascii?Q?PajPsczlnPmSzpdhIJyI+JCsUxMdZtMLFcz0hFEdobh4D20qvbbkMOjlFTSr?=
 =?us-ascii?Q?Lu1KDeliYrIxY0s0YeBZMv7e8GNqm5DrTfembWDauUolGOIP710U0vX6lZ+h?=
 =?us-ascii?Q?3atfkTgjUsfJCa25QpeG/B3Pa87MfLPQkVuYpOgUbFipvKhvwE4CWye2/nXz?=
 =?us-ascii?Q?VTIsFQqtvJrJiOavqcNdAoJQyfAxolKE6Lv/arb1U0lU6pbadhjK0IkOR09H?=
 =?us-ascii?Q?LVf5iN/YGSwikB/QZrQZYVK3D2IuDy/CDsby/9U4l0jxxmFZKfIZAGi2Pxv6?=
 =?us-ascii?Q?WOXk0Er1TWySfjxHIz2yakCCDd5XnPbyQIrHFRRi5P0YPft82G9l3LGu1Slq?=
 =?us-ascii?Q?RA6uxVpkvRlhb6/3FY4GglhqxSxir+1wO9uoIuu9fpVgM4c3TL43PFHIoFD2?=
 =?us-ascii?Q?81h6MULfx40S2mgYdlwIOaqSsqIk8M6oW/zvOAVqEs0TYzr6CrHIrVGUOLqT?=
 =?us-ascii?Q?FwMy86Ng/i3TPVFQvK+D7AOEw5Oxss5vUjvo02otVGTVXfAxpC1+luKZ/21r?=
 =?us-ascii?Q?Z94UrWGK8qk3O7HT23U2l6iHGf/gdbvDHB5T7B13ghIxoDJvEjMw6W/xXcg1?=
 =?us-ascii?Q?49KaQhIPhpg5oKGNiok4zWX7+LBm3NMy3eSEFLpPZvRwD0DKLv5cK5t0ce+o?=
 =?us-ascii?Q?FI6q1jPZcHMVHFmJdKnwHg3gdzb1ARr4dJlK1pW2X3tCT8MA9lT6Vv0fi+9R?=
 =?us-ascii?Q?mygozqbWpu+oQ4rbKxSsW8mIpOd0b4ruuelkEjPhhmstZ1McYvhlcbjEVG8H?=
 =?us-ascii?Q?xqNbXnF6GgXIAPsKcfIOpt/Duf0ED7xVjVxtUdD095RG8BQafOZeH4HWD/u9?=
 =?us-ascii?Q?b7n/+li94QrgcFeFZYj53XRjk0Iqfg3gSvyj0aS6grj01eRXOAqcvHlSAxXl?=
 =?us-ascii?Q?bTAtYBuSXPbt3gJuX6MCwZQ/8Bi7KB1KLcj+Z+r1uJZUgna27XGIZJ6qMr6u?=
 =?us-ascii?Q?uamYC34DbOovzZUKTTkOuo4q8aAipjMi7cDV2AfUSO54GMBuXNj3cTHMY82T?=
 =?us-ascii?Q?C1Avz6HEStgcF+Ty7xDwVP1tozrwrA82wNtRWwTnhpTLgwwXM5IdBmnEQTkt?=
 =?us-ascii?Q?UN1rToHG4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9+RwWEtvY6z1fRxEwzHiPZMjE8W3UQELqRNK/X5XzyeEZ+B/MqfYdZKPE93uN/60mESIEza2XFwnkVHzUV5XotvmixWRcAYVnfKR1phwYH5WdV7ue8bnMWaXVKgtGcUDLZruWguV4kv4NtQ82gln2wtZhtXEoFoUfh6uguiSRZb9lFqLhkUiN4IZNNLtTD0LSsCunzgSo6UUcfouVz6vxLs2KuCS/ng09rrAFllfibg6LN6sVywe/lCjdHv8fW+ktwodMQXoPauyGaJEmfT5zLsQMvfMfyuZ1RrDcfLoIV0MMqRkk4hYkCY6US+80AGTbRIGsmVD0EYkDT5D6AW8S7XSoM3OE7yrFjqYAoNVhE8QtrK6ql7/q/VQ5ySheE/5GgycsI7ZnXJRLFd7+ZooyWPcoSU1rjYn+BkbQAN/HBRj04QGo6/eL6Are6Rl++mSP3pU/7OoxX0ACIQtZ/F3S18sG2+kmjwGowA3WNUS9IQ2jKQfGyxm6zKIKPh1QOdqJIhfqTVP8yie9YDiKAc/Po/wKKeBv9J0nnaSjT2hvNM7dvF1OfLnVWo+C5y4p2l3obTJLhzR7cdMyMwlDV2JAfQZu03peCvSRxeFAiscqKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8870ad-2950-4f45-b065-08de590d3ba8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:50.4917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jR4mLhPQbdpJh6G6kAPch1Sr7OaDLE+Tefn2V6VUkKTa8ONVh4KJWD8Wr6Ee6/hvLF173QL5tvm7UZD7or9tzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-ORIG-GUID: ww-9txRTdcUKCYGDFvckRANIZKWSSBVz
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=697103ee b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=1XWaLZrsAAAA:8 a=DO5yfXpT9pfNaLUI-vsA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfXxiugqPznAF19
 fluzjjCPJKODse5bkWzkZ6qKKTDTLp6xC6czuFuS7+XJQ4jrbq28c2BuU8zCfatg0v3Yo8vnC5a
 cFXfQgMojzg71MBLohP3XXEWgKLl5JyGj8Hqg4+bX8HB5gGLW1iSOYR2HZ+HJSMr+iTom1KBX1k
 EQkex2LzpwWhahsJZPO2GW/loQG3TIF9QkZe2OmHy6IX0fIAw+zzJKQ6qi9X4MLUTz+BcsjMfkY
 dnGUR/BSsHVSAH6//rdZCn7N8m7jFlvIL/pVBLgkla/WhPfG86skVH4aTW1NM6dMj5N/iBSdqY3
 +DQwQdw7qmfGYZj9IJZoHnDXHD1abttLvOUzhTJisH6TbO3fMIvuXmBGqx0u/gIOqMb4tiYcChm
 R876ZDlrPznEmJXjIUK2B9fzC7pimLEwf40PL1pIL2D1PXeDJVhfRjc7TaaNdxxOqxFafzX3fzl
 YUDpZIC8QodPz9dYFGB6NFG4lXRPILn0Fb+Y5pZ0=
X-Proofpoint-GUID: ww-9txRTdcUKCYGDFvckRANIZKWSSBVz
X-Rspamd-Queue-Id: 0004C140013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q7r6ytmecis8p8x7jdwcq313ehbkb44e
X-HE-Tag: 1769014268-786194
X-HE-Meta: U2FsdGVkX19gytaVQFEIuv3aiRrJFnGuAmq/5tenowiHOD+OmaSnbrixWn7Vp/iPGOkSS+Hg2hsM7VVHDJcE6wcxAGi6qp5i4A+DFCBh7oNrxFGLpnqBGzetqqsgNdp3c46TIHfV5xHUpYxBqdXKOFDJQEiCW2v7koX/qEo86b/ZQc9Ss1Og/4UlB2TLxQLLWB1fhtUN9y1Yx1Ibt5JGVM3HeZm/DMWsbeArYvOjfDQrhpCaXrr/JaKKtSJQZseP0UlngXpJd2zx6Hn09AKwgovjDUi4/szJoy6H5ZqRTqzMcofRdkZR7sh+CNJbCUmPkkFOG3x+gSb0HvOwkw+bt0kcClCNfvroX1xk8PGcNSWcda8TI+U6HMYsNj3w5iR+ObWChHuxnj8Bzstxj7X3Jsd0Os3qnLsP+nGnQvsE2TPbXa13qSQqis6cN4Jlw5RxNoSi87DBk+JcCUZrfOg805K0RWpK1oAl5yNJcHc6+bY2KjlfaA6l0MPPIL/VNs6ukAL2EL03V5Jx7y/1ln2OGx1K/NAkYQIBvem4s6pH5jw0GoTQ8Ca/rfepZrbrJ7ZkMLbOjV0Q0IY4qIsh39TrW3RqEIwDN11VzxQhdPmOzQ4k6kaaYITYyH1MMPeo0mgcm4QdyGfAzL8HNzWoTMm23kw3QhU0T9QIMCHeWbKzi1VGy4z8JlcVvZpxxk0M3oKcz2VeQv7/kcRiV1CXve5LNItHNRxf/hfTkwN/Qx6bXmMzf41rIop5j10nmn2WhfkHZtIpje2qcR5E0YfSrEcmcNrcZpXhM3QBctcgH19YC+F4N4XWJl/HS2bOk1725OqaEcEaj1cM1w7K+iKZWAAYFmrQLb+a8mn0Oz8ySkXUPpeO3oka2uWntszMoty8r15c6Zrg7Ittsg1mz1aa37VaAPJHMiXRP6ioSYUiYi7CqwiSbFtoYk3P5KtjS6yjq9BasvD9gSQRLCHQR5oAMgn
 wzzUkJtj
 qNaqkoY92R4fUmBFTY84B/E4ZlB16YTplwFHCHEsbTgk8Moj/irEHf6dAG6JhfmkBkHxIbgAz4DF6eB/gL6ggTtisWbzn5b3VXQx9NEYWn4v8rjaZb2ePCPLDABnfIv+xwYYaqsi4i7yiXHD2nsc5NkS/vLPP+yJWZ1AdaEvD0pNpMfmKbLObbzEDTPRU/yc8YP/9pmjbJP9tC4+VY638Flq0m05MNiAHKFgd8RHS+5L0b1KL+LwefRTYoDUYfh08H7TCusor+3nGiT6Y6U7We68TlTHbKAoB0WFVH21ULvlKRK4Z+pEAcK6bpe/AOab30uDEwDpimbUTeLQow5zNGP1S1J9rfzOd9fLp7e5/qqlrBcPpffa6X59IoJDhLREyyOYT26aq6vy6WppPxlyRJeKi2An15GeaUAQgaYQE95OxsyPkH7r32H6BLnPK3EJVQ5f7L/G7vFTWc1oPCW479TkjmN5J5kNchkdqtbzXZX+vUa7S46SwI3T2nLPXBfdjrR0Tr7h+wWmd6UpyKdwOFLC6MqPbA1un9jeis2t2cW3qL//6o9HgdUSWkRJhMVxQY4eS38+ABZ6Q0GdwIEkLz9yoURYW75qcnF4gyeTfGkn6wSbbr73/JnktJN8lSa3O8pRoDCCfaTgFM4ZYzi00aeBY47n0MAMQ9OSt02orpo+gmwNQpGvZyV0Sun/kEAAyBNHM97qIbKlVrj5nKkS3LMbCTSrvFpoF4bqb2w7ID6rysB7qrerBJlm2NoICatI5PCzqWcNEoXUxOWg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create the new function tear_down_vmas() to remove a range of vmas.
exit_mmap() will be removing all the vmas.

This is necessary for future patches.

No functional changes intended.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 1f025edf8d7d0..9c8adc505d3de 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1247,6 +1247,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
 }
 EXPORT_SYMBOL(vm_brk_flags);
 
+static
+unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
+		struct vm_area_struct *vma, unsigned long end)
+{
+	unsigned long nr_accounted = 0;
+	int count = 0;
+
+	mmap_assert_write_locked(mm);
+	vma_iter_set(vmi, vma->vm_end);
+	do {
+		if (vma->vm_flags & VM_ACCOUNT)
+			nr_accounted += vma_pages(vma);
+		vma_mark_detached(vma);
+		remove_vma(vma);
+		count++;
+		cond_resched();
+		vma = vma_next(vmi);
+	} while (vma && vma->vm_end <= end);
+
+	VM_WARN_ON_ONCE(count != mm->map_count);
+	return nr_accounted;
+}
+
 /* Release all mmaps. */
 void exit_mmap(struct mm_struct *mm)
 {
@@ -1254,7 +1277,6 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
-	int count = 0;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -1294,18 +1316,7 @@ void exit_mmap(struct mm_struct *mm)
 	 * enabled, without holding any MM locks besides the unreachable
 	 * mmap_write_lock.
 	 */
-	vma_iter_set(&vmi, vma->vm_end);
-	do {
-		if (vma->vm_flags & VM_ACCOUNT)
-			nr_accounted += vma_pages(vma);
-		vma_mark_detached(vma);
-		remove_vma(vma);
-		count++;
-		cond_resched();
-		vma = vma_next(&vmi);
-	} while (vma && likely(!xa_is_zero(vma)));
-
-	BUG_ON(count != mm->map_count);
+	nr_accounted = tear_down_vmas(mm, &vmi, vma, ULONG_MAX);
 
 destroy:
 	__mt_destroy(&mm->mm_mt);
-- 
2.47.3


