Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3959BC83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 15:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFA2A8E0002; Wed, 30 Jul 2025 11:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2128E0001; Wed, 30 Jul 2025 11:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9991E8E0002; Wed, 30 Jul 2025 11:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 862048E0001
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 11:23:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C6BC1DA534
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:23:59 +0000 (UTC)
X-FDA: 83721301398.01.59267EC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D29A18000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 15:23:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lTls9bGD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VGUAS/AZ";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753889035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZDz5OkaDEfV1/6fayegXfnUwXO/LgOzwCITBjfMbjo=;
	b=8Hle1naAumdtoAvfGOdSIUit6CyRI6B0MSixB5AOvmeyow4IVi4er7DVAuNjvNKQgdAhD8
	qR2r3zMZfQj48BujQLbkiyFK/YcHrpGnyokbHea0gxJNhjR8gjxX0kAVLB58VO1A4hxbdR
	0nv+B2Nbm8qKKiJySFCioBeMiwTZxcE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lTls9bGD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="VGUAS/AZ";
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753889035; a=rsa-sha256;
	cv=pass;
	b=B6IH78C5expJYKV2LAzNhEp/jGv+hPk6Gc59U5+It+s2/gq4DQkoLlkbp3omw88+ggvy3Z
	2kuoj50FZ1Hew3/zZ9G3oTeGp5GoJ1Yq+tqR6brWrZfhBS6p/bqj9uJ+YreHADkWbnJOr8
	PV2zcPcfpoLQ6uhyHBzPLZ7TVdtTHqM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56UDMrAJ006984;
	Wed, 30 Jul 2025 15:23:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dZDz5OkaDEfV1/6fay
	egXfnUwXO/LgOzwCITBjfMbjo=; b=lTls9bGDE3hhQfalvgxP0PyFmvDNEIuUwo
	bg5Tz7HjENc7ymV9u7Mbp1rwQ0K53vi8rzKyAYTcn+gdYgKSjIFEZRgaq1Fu9zOO
	97DXJapmewpQwEeORNso3b8Y5nmNlsX0P+GP5q4dYW5A1ver+MNZM07Tqi1ZjoGV
	rW1uXolIJtA2bPC5OSAEzNNMAXl+Oz/HJ6xUTuirktl4W62GTHGTeJTAz6c0n54r
	K808jGmWGygY/YQ+5Gypkb9cbcd7aMeRmdrbdRgX3AEAWeCgjfS/cfowxGWvIfaY
	offMZu/S1bAyS/J6lhD6VOMV4+LniOyUff6EM+JENng4tiiCjqgw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q73275a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 15:23:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56UEAvBq016739;
	Wed, 30 Jul 2025 15:23:45 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfhn9gh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 15:23:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JECyMrzhbsSqJKReg0prZr3MZ9eKQNjXDlf318+Oj+SBdXodahyXXm74vmoj3rndSXdR8Xdg+srBNdKvHcPrRtBXt+Z8cdGCypzdh7S/i51MZpYkBTAxxQx+ywItc9QTmK5Ov/KcGyLbtglhaOmbD+FA1jbyB0DyhNTJnu+J8Od+TMkjFwiTwrmXr13BX7K/b5sSyaeaBKD+PXKbO+Jl/52Ne8JvKvGDSBy4T5JMARxWipYywfM5BjKFJmIpMESYRt7GSPR8Wn/NJSKJvHYZRpXhkRU20582kyYTGwPFHbbPsJUUBPrDirnnTr8eLOTxl3/lOW1UO69/gRFydykxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dZDz5OkaDEfV1/6fayegXfnUwXO/LgOzwCITBjfMbjo=;
 b=Ou1T27ZOOArJ+lJ4TZLrsiqc4EnivUP2fKEo9XMBkfT5+jIwX4umOeO+KL7RjPE0SiIUiI8cooYu4/sLcb1gcwUnG1CUuhC/WGpm47hRQK2b4oNLrh/6ztGSO4VZYNLrOeEgTxsT8+Wh2d8RA1Jdpf1BhOdAeu3Qg2xrfn+bfbVohi6MoRnXxB55E4zzpwjrPmjd2qMGq3uV6FC8qeCxbebx+kRR+pJTp2OPQt8xqpNblV7uUDOs8o02GKuvFqiOeHp0YOIIu4ylgATpS4KfYDXMGYZ7jjHaOIA5wUAMhX+pJb1K89e1xGmvGOQ0wwIhCIXNAdp5tlnTNE5bz4l0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dZDz5OkaDEfV1/6fayegXfnUwXO/LgOzwCITBjfMbjo=;
 b=VGUAS/AZwAXttd5uSHETgbyLFk34pvq4/KKGovZCSsH/CxNs+KNjTZAOMo7TKoWRdaaI36nyghdRds5KOPbPb3LnyZVHsVAH+P3l8a8+l+GomaXO0jD/HdESQUp5vpvWUEC9yw//6WnKTLfsQMAesDQYWlWV/AcFosO6kwqERr4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6471.namprd10.prod.outlook.com (2603:10b6:806:2b0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.25; Wed, 30 Jul
 2025 15:23:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8989.010; Wed, 30 Jul 2025
 15:23:42 +0000
Date: Wed, 30 Jul 2025 16:23:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
        hughd@google.com, willy@infradead.org, ziy@nvidia.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: shmem: fix the strategy for the tmpfs 'huge='
 options
Message-ID: <70841ec1-0d14-4fc3-a2be-fd5640f9670d@lucifer.local>
References: <701271092af74c2d969b195321c2c22e15e3c694.1753863013.git.baolin.wang@linux.alibaba.com>
 <0a689e9f-082b-497d-a32b-afc3feddcdb8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a689e9f-082b-497d-a32b-afc3feddcdb8@redhat.com>
X-ClientProxiedBy: MM0P280CA0107.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6471:EE_
X-MS-Office365-Filtering-Correlation-Id: 52cb356e-e81e-4857-2251-08ddcf7d1189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?be3Xm8WXfUSvDXcTdePL64dj8NHoQQqoWQncbm6OqzEqAGgiZQ7GcCiCLMrr?=
 =?us-ascii?Q?u3SlvTGRt6YU0FTYMFjMmCkNrdiEKQGs9O0X3Me/Z5tPYwve4WARev4pNJZ8?=
 =?us-ascii?Q?7bu507ZXvnGyX0Xniq2EiTN+0fRIjiUAOIkEUTHz3a87MFTwa98mApgK9cJ5?=
 =?us-ascii?Q?n1qzV4kZOnvW+QsmcV9UOTGYanZ4AR5rCKXmZr+h0IB+zo7/qzCWQxO8Vvg7?=
 =?us-ascii?Q?LwTqsqaKIaPSXNvlM5zP+XgBXZokQ+4kUU8zRAIZCkvud7exA2F4XZ/m8alG?=
 =?us-ascii?Q?e+Fy7AuJbG0+WE3w7nIKhHP/Vh6IscVBuLHUqR+WcdHmv+Gkq9PQCONpSH/n?=
 =?us-ascii?Q?lRBSTVn6dFvCzN42mtrrY0e75a6Knng6HyICxwdFOLtmPHNPQkHjpEh5dS8z?=
 =?us-ascii?Q?tZfPtyLkk/bkYAvhDU5igl0pmu/hQcTzcc597SdPXV1z4uY8IS5k/DTZ69hJ?=
 =?us-ascii?Q?XgpfABKptNrfjC3QJ92VT0azvf2jEhoRn0ik4uSSiX93gVOfB1B4XLvZYbBr?=
 =?us-ascii?Q?2VPbZ4EcBvxTq+hGiqf8Rs/GglMlK6ISWQbVnffdzpA0USIXdOf7Fr5tVGdo?=
 =?us-ascii?Q?w2C8XUNMAKKHIjG5C0PyyaEbDdLCDxCnL7LiZvg06XxbOARgZu+JMAkqchZi?=
 =?us-ascii?Q?MQmdRCUWptq+aBgucy19VFijn6fmLTmoIiA4zF7cCQ9NlEG7ZVuIWol6+CV1?=
 =?us-ascii?Q?Hn4bY1yo3gc6le2ozm0i2EzLcrHxK32LxKedbUf0RIuiHuSQhWOSlF64HFo/?=
 =?us-ascii?Q?dvtsCu9gTK1obF/pyuAxgCibM8rrBIvO8Hh6sIzBS5s4ukfZ1M/GlV7KJOPr?=
 =?us-ascii?Q?Fsj3NmSsZp00XIqzmmTEqmiD9vl9/NLVxzHOB3jQPATmKocARA7DBbzuFj7s?=
 =?us-ascii?Q?uoRGRbQEePAz2d1TKMbD0LAY4gY8akTU3dZISlfDsj3pmaveCnwM2s/liQom?=
 =?us-ascii?Q?p1vXVRYcbz7FP0JYht1ohDjYGuhyyDLJvKxHCJKyZvUFfAX2Zvi/p8riP2ug?=
 =?us-ascii?Q?Ly1U7iEZKyzcoK9CNNLg6zk+dFWH1NV6wwZXWb/e8J3tBeAlOwEkoZZA8zoO?=
 =?us-ascii?Q?YjYxy5XleEkptH3ELgd26fiC6uO2WFtMxeXIY42JkWEUSX1QsjAlVAmy4D4N?=
 =?us-ascii?Q?DZCXcI5hYAKIXtJcdi3eHbacJXrDrRGn2aPtnA5KVef4BOZbfoT+q+k7MBDY?=
 =?us-ascii?Q?N2gEK5t7LEooUk69HzRAX6VcIW/XONbbLS7XWW8j8fOo4y9twKiOB9adzvhV?=
 =?us-ascii?Q?tnAzDGVvB5BRIFJgpUximDumewZm9fUr9cXJK4CAU6tKwgKObc3/tCEt/uYx?=
 =?us-ascii?Q?eFwrT73Pz2/Zi6swEk1W4hkEY3W5Ouxrz+P+K29NN1eb0NtQtxeau4XWV9AD?=
 =?us-ascii?Q?i9Wb2LPt14Wd3CVeguiTxpwEUWf1GC63ds4ntJeakskZsE/2wHCEpNyQ12n6?=
 =?us-ascii?Q?fIS5a2VtOH8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Zd2NMfMsky3Qjti32XaaKkqWHET6vUDzuksi3mfpHWG/6h6d522AFh79+tSy?=
 =?us-ascii?Q?c4JEHE7Ha5xOtZi6PHB7eYTQ4V3PPf4FSpza8YgnnQw4IRcW48Q9QjDY6ZSK?=
 =?us-ascii?Q?cRQwmjbQ/OuN7DnrsTVqZHNpMxZeXNIPvZAYIweMyaGXadrHUubIcYLR+fK0?=
 =?us-ascii?Q?GedV+oQVa2YPCCG/WiG4UaV1o62IC3w7cn7p1+GgjTVVr+E9DnpzktcIDlQi?=
 =?us-ascii?Q?h/HZvgZTBDX6Er1neK4jpjpfH5gigTjh1RJB+yIhbDVe86u5kHa/IHCAKDho?=
 =?us-ascii?Q?65wsAmS9y11rb5J7ziIO+OZ5zQTFhF81dX5M04zPh544GAw+EZAzEtPmyby2?=
 =?us-ascii?Q?GXtuhs8y7RomBvWERUHulCgz8ioLBGyG3hvWxQpMlBPgvBESnnvs6UWo6NH1?=
 =?us-ascii?Q?DpZeKlleLGF6WNd94OeRfEiQWuXec6eK0DTn8BxXM2+6LdfZ69uYupSKV0vT?=
 =?us-ascii?Q?sh7avrUuX2Zz6F/eC1aG7W4p6wzHO3eIbpJ/5Xm73pKVQbPXu2i9ooPv/Q2d?=
 =?us-ascii?Q?yqwaZtO6m5bhi8oz5LgpkCdQtIgmNiNZWS/AEYN1y8ShatZtRrqfcZ1b3kgI?=
 =?us-ascii?Q?Ussj1pb1zUaMZKbm6SPlxDGdsjsuyU44puO2y6438c8aTrotATNBrCYc21rj?=
 =?us-ascii?Q?Wo2kBbiRw86rEdldBriipgYnRg0ENnBe8wRP3/3fycNL08wcTwwS0GxdlaUI?=
 =?us-ascii?Q?r8RCYAMb6WX5xMWlhlvBI8DS2Ob9aI9KD5MKLGLwmZZWFOdpWKLPMLMsWIFN?=
 =?us-ascii?Q?tL7pdCGL6caQAq8F7yU912C2+eRENtTTwSsr5mY//AqHxaW4qSOYE6loVbEt?=
 =?us-ascii?Q?e58Fq4gM2oXYhocmZ8+snZFakJj5EYZ0GjlhZBBAdreCj0PT8ipNniOLu6Vg?=
 =?us-ascii?Q?FU2NZYH+TKhYeibX8lqswBGhL/KBQNzroMfnoClO4Yj3wDq/lgduh9gitfTo?=
 =?us-ascii?Q?izMWGK9Y27V/lccXsXwZVuRcupy6/njcJpsWxdaguv2le06ZnyrsTq2XrMen?=
 =?us-ascii?Q?u0uqZNj00cNCGZOqzGnRQ+5ppcICQSUZZtOIWwsEEaIjfRNdpX26gyNpHLj+?=
 =?us-ascii?Q?NnO24nfoDJy1/K814AccrsKI/UWLxpYJeoYNY8WVh1R7BiccncDfFsUhrIY+?=
 =?us-ascii?Q?16aV0C8TkNWc2OnAb8ErmHgKVd3sNBOIC6/JBOKW+IGaOTvZXsmLK/B6FK5+?=
 =?us-ascii?Q?MRU9PiZ6OkTJzZsX3Z/kOgEE8H/LqB18mmox+sdlCVzdOeKLXP6aI5BRfW5c?=
 =?us-ascii?Q?em2dgZNEpVz+ho8EmgDvpA7UnHVSHZJ+R/taDjgSwQOqaqkHp6joLEWLlVhp?=
 =?us-ascii?Q?DiRozJhlpe+Qp1Lg61qy4egFvOIzVPb1KTRqaykjqzJUZcrfbxwywbjS56ng?=
 =?us-ascii?Q?OZ0prP4cLm9SwT3iS32c41+NxiUS0vF4QDi5htH/qbIJl0ej4JfMNyy9gJxJ?=
 =?us-ascii?Q?R+hUX8N5ObpLCpHD/JCuExX4UJal7vyKqvQJbhSEAm+JkBQ5LlF///9/WYEv?=
 =?us-ascii?Q?T8Bep4qmD7AbvhK0sbJrYtyxvATHoPyrhUAfj/bJNaEUBNOh3pP3lZDJ2vQW?=
 =?us-ascii?Q?kb280hPWRfJfw5+tSBNUIvoiv1aTewo5j83n6bj2foPu8FCHPubVBaUai2TJ?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2FCWtSZMA0uOt6ISqvv4urZxgyR1UNPdC/IE2ON3f8aobGeXisp6xwHwWx+tr4inR7LRofBqdFF9H0v+1SKTSUjpo/nGUVxnXwoyiAuugI837TtBFJxGntMQu/GKk0ie2pnEYXpZlCkcKJ96eQDR7U758aR1p3eZbLCoI0YXzUYKynNr/CZOo4eaqcjFHDG1tk+hlzuwHg8Uc6r/rTqvLshkE+WS/RZt4TmhVGkN2i1tRHPDc5aUdFFyecmKJkJPLChuq+6szoHG3BVXIeyzG9jES9u8EAHmm7oBa1VvujRZRc5XfaEC4E2UwzTuMnVHkeT8Cog9FW2KoEmiqAMjFYJQ0TeGxjlUBr+xgw7jL8v02mGAseoMUg3+P1txr8HutXwykHTN7BOLwQEn0EtQW/XLqaeQS/7lfDpmxwGW72iW3uYosfHhLcw2fD8IY+s4sKxDinA4aHXF8wOU20UXSMtN1yFzGPhiuMR9PJcR5n/yW3dAH27nUE67QRH8BV9DccICVUorPnOqOy2htzsJK7CEDWnYZBBk6WXNPf4gZOcSJphFvMqT0K7Ck36qsbvEkPN5fxubFjY3lHqzaV9dLYTlim+N9vo9NHgRYTexrag=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cb356e-e81e-4857-2251-08ddcf7d1189
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 15:23:42.9169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BExh2p7j1mOCfnPch+eK0dywB4gBadFy1okLCG5CMOrRbQXfu2KXeA372ugfsaFwLp1SLUl9ohKwkgp86ip6UN/rup/NcfIjqPifx5FDHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6471
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_05,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=809 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507300112
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDExMSBTYWx0ZWRfX4fobkfiLd59h
 uby0YrHb9wrvCURcLPHSkurPsQhu8W4ue6jxHFVgtoFcbplyebWeoRh2z52qqv+KprFHBXzr7M0
 I7Tuc3UqpL4TB4aaWtUmsK4ZDVKs+qnyFo5fomHf58IVNKX/qXm8qlEGkoVRie1KNdSMMdHBElz
 XdxN5ZxgfxZPazoTZ9HmpJd3+zsvSNqWuhqiE7pRX40EM3mCBXECrGctCT5AzQFXae8m3Zthbd9
 /gUODfkqeB1mpIAki58cv1Hc7IZk4/9e2bZTsD/RjxO1qXw8KbdWVZ26s9/mgM1gROwUCXmQA4e
 pqbIGJcO5ycXkeWaTZSrNEZsbob34QHzpnNLIXe6DLSYTSiG0u1Gd/5RfLo9kexLaXeXXLj7796
 pCntrd8l6HkL9uN7VHlbR1JD82UiuUO2IYHxk3WOBtPtrAHu3/5sxZgDibA2btXBFgVi6lgU
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688a3901 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=k1kfJH-k2cBGZC_bXoMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12070
X-Proofpoint-GUID: 5vKnLlsGpI6-98VuuilL1gs-4tWGYMAn
X-Proofpoint-ORIG-GUID: 5vKnLlsGpI6-98VuuilL1gs-4tWGYMAn
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D29A18000A
X-Rspamd-Server: rspam06
X-Stat-Signature: fxo84zjj9x6up1c7zssskixkzgf3pwgp
X-HE-Tag: 1753889035-480481
X-HE-Meta: U2FsdGVkX1/ViEhf8xeNReMeQSUvcxJYIg8B09EuWyLbEMnCa1iuLQnTFPv4ENImuDWgIlu63KRd8QBRzT30jX03S+8sVfrvV9aPKQlx9cZMIivQ3DMgoGBay8hY7MsAPZAqg3RVHRVKFzjzWImzcBSe3AQj5ZsXtuaMf8AZB9/9MoUovchRFVdIHgNf2iC2WjTh5ZpjHtkdMT6nuZ5k8d2JhDXpbLBPCMKQUnf7b+4CgMGErG8V29c4DhNVVQlqxNxDtEQfgvlQ3wM6EBkJq/uNR3OIpVf3ERfkzABE7aZNOcOpvD8s4kroSe3cgDsQdyH48HpVeMsOuW/ttLTT8OtfcGw/0ePmrOLOGDVx671euhvkwGF6OA809IlniM5dbsAjnPimLX9GdkMxDrjzfytx7bmWGguYjUk+yX5ztULXRD3oCOI8I+ptT2Hnd5RoVkK48tJqfGtH62Z2n+14UA3fmcAGh7hA5msuXGR+/lobnr/ZwFu1NGoojTy69JnjbLDhSEsXWa2QBfwZ1PbGTqYfD1RjXBuGisWtGQ+kA8e9J/HaZ6zKTdn0uiVkQ+QBgjLHNeq3mNbvmRoCLhgqyULjvF2UnwTrW1eL5xMJmrqJY/DuPhma2BLXHYPCjiL9JcTwZdDheEnAxSvndppAGqpg5kkt0s9Gt3uZrkP2l8hUhqY6/tLFTgSF+YxfGFyvjcHWS4BIS3AjFdSweKBho36KRRahEo4z9wF/n941nAxWhqg6jq8nuZxg0VcNHNJFUCmlCX6aHwfrBJo8pAfd4ur3VWfLYFyvoSx561eNTVRC7gUR+8wx9s/xImN6CL2qnHDdJWBOmMUWakNM5K8eGyNjRVpfO4+oU3MzVrZdONjeOikiq65NUcxr/AhuYzjJvBT8hD7cK4TL8Ge47OY1MBhRhHd3R02CAH02EmMyAqav09XkSKy+vD6iHdOGkk4xYIHSqERglO7LC+V/3qP
 72lrHcZa
 vc/w5ji0UHuj5+r3yHRvGLPjO3rBfAxmjPtPQgyVJTdIu+6ho2V5zNIGdJiwknkdoEZfBT1QvnYSM0s1VhnD+P14kB2xLPuHpKepfRux4rO5h9Whh1Pw+OoVSk4vN4+47YsYJs6OzsNLbMmsMUFrZpc30gR3eMpZrhia4ODcetbfed4tdxLPtuJ1gpxOyP/RwFcCoURnVOifG3wQ1/s7zMug/qbTuDBXyvjkndfye7D/Yf0dZVqr+iL910iNjt8PNTZa7UCwJ8JFmK+2S0Nenxl86eK7Ck/yJ8djr4BCA2R54HMV/p839GtbXmTd32qphY0LRSA3q+mWw4w9Jy1V4Vq0BkmZ9kR069FWkI+20029O+neH6s/AUAlSsoPZNdtBre6ilokKHHioleslkcOoES8flsy02/t0+g0t9V4kEAa7xvJNj1lLnea8brj7R2RB09vvi8FpdVHvtq+Wsle/jnBfjrZM+s1+QGHczDCt5A6eBV8zlt98K21UizurIYukSvCeA1vDrMAOwszJaOXpKJWcx0pVapn1rjugQvfCvzE89tEyMQTk5MpmhwmcsU0xBbZV9JFXTZRxFYq3Soa9L5q6ocsMytIPvC8tZs4If6Wc88a2MUEMTMw7Vkuo5qBYeH5PNUITV+Y+8O7IwkJAKFZqrNf1VEijoxVPr0C9DINOwXiqPrUQnRVYLaPqEKEAYrpqUWJvKEush9VeTmSjyDLSLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 11:30:20AM +0200, David Hildenbrand wrote:
> There were opinions in the past that tmpfs should just behave like any other
> fs, and I think that's what we tried to satisfy here: use the write size as
> an indication.

Indeed, it feels like we have too much 'special snowflake' stuff for shmem
anyway. Each instance of those adds more ways to get bugs/unexpected
behaviour.

