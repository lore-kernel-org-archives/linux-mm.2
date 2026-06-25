Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E3DCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B130A6B00A3; Thu, 25 Jun 2026 07:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAFB6B00A4; Thu, 25 Jun 2026 07:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2626B00A5; Thu, 25 Jun 2026 07:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73D2C6B00A3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36FCB40688
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:20 +0000 (UTC)
X-FDA: 84918141000.23.F19A3C5
Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazolkn19010016.outbound.protection.outlook.com [52.103.72.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E5B1100019
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=fvwDzDcM;
	spf=pass (imf05.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.16 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782385217;
	b=dpaT9Juf7MPWQknIhMtg6Mu0+7eguycEa+0H47e6KB9n0aXxtjxmv6XwjIG2XTwgV6NY8S
	Mh7VMxoGi9FsS40v1WRyYcecMotCcf6cXgxKxNndEy4DxEMw6RHjrVLWUhjRA2KVVC2Upk
	Vv7+hFeG54EpARE60LTtpxPkaWWwuBM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1omvIcwVXpixCCsiOZpunz7SR6/ADMNUnxevuHO0pfM=;
	b=pA+kXFd/vfW3qBU+U7LVnQBIGe/OlSW2XJOJWhr1jAnweksTqt/IMHzy0K/TlhH99kuID0
	r00TGIUdhKdJT9hrkR8FikwCsZ81jI7OPtdfsYaN7A+72mQP4mgxdIzbX99ksK9wB3iLnU
	jRV9PBSo79ahd7880UIdSJ8/WyBvYvc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=fvwDzDcM;
	spf=pass (imf05.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.16 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvUnXi8p4U4RGZc0DL38NCSjReQNHEJl/rFkMBrSAXCG2ulkk8wlsX687PEvSXAvYz79KWU2IhL+NfKj+ZFmUbbt1Xtq5vS6fS5AOPlSKz0TkTzYMv4+AUhpB+Jjd2mGcUJK9UkafMx0gWu4bsJLgYOKduXDO7S/1FHyViFNfJgJXKPNadFW7hUOrr+OWJdWJHagjtqRRaq6KMFY6g4/jqZHxJuGX13tl3kSixwCBMDcE6De4NuXy+8Kcw2I6rxzXX+acC0dduF7WYkwc2+zvHEgyS416v2LJc3Be9yW3/03DLhw84ly3DrrGEgdwHYquqa9gxnzFwoenySrtqUNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1omvIcwVXpixCCsiOZpunz7SR6/ADMNUnxevuHO0pfM=;
 b=hYnsymB3CHs9cGALuUgG8rO94RQQ/WDuY1r62TtjldGVqfLE9lVisLo7iy5oY7/Q/IzTTGU8BCPt/KizoV/+/NsdePKfcQ99UZaUXcJJ8xom26ShI+uUtZMPqrc3teMQNie5dBBPWULfvKOLsRXy56uFtk01uCq2AF50Q4F4sTW+4RXKrkPqEofgtFkWGrnRi4TBODNZRfOs1qvtD6Ou9sLMFpLOnE+YJBBhRzyXmoqSBWzt2sXSlitTwQHMBcwvcm/tpS/oboECcyPVELK6nLdADxw588tQ/I+/AbqTSs0ejLnFsT94C12mSQ9zUH2ncwTtTeq/iz8jj1LfRiiBWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1omvIcwVXpixCCsiOZpunz7SR6/ADMNUnxevuHO0pfM=;
 b=fvwDzDcMsclIriC81XE/w32mpeEFnEP9Ffe4J+yTzJYWFWVuD5ytZTB/aWkj42Q8Q4aIXr/3cyMPR48SCRrFaOGIEWYhEadQz8qzhNynAsujEQy5Rl9Zy0tAyONag2rIednLF75mpT+8iHvEzzC1LWdcVZAMmn4B12RMYQNoMCmO2U93Shln3jORpZguYW1kU0ixlCUiJoXTYr4Cew4JkRdhchAE2e2nVa5pLDaD5qTG2aczmkqu1FOv+zsuGHxzTjmAgz0PaPZKn8/Sc2P0cDk3d5ampaCpIpA5cJgj0hXSQvyZ3HhSQ239O3AXI+wZN5CAtvJh4Ay4xF/ZZBJRTA==
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
 by SY1PR01MB10657.ausprd01.prod.outlook.com (2603:10c6:10:315::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Thu, 25 Jun
 2026 11:00:08 +0000
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f]) by SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f%6]) with mapi id 15.21.0159.012; Thu, 25 Jun 2026
 11:00:08 +0000
From: Yitao Jiang <jytscientist@hotmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yitao Jiang <jytscientist@hotmail.com>
Subject: [PATCH 0/3] mm/mmu_notifier, drm/amdgpu: block THP for GPU user mappings
Date: Thu, 25 Jun 2026 18:59:50 +0800
Message-ID:
 <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0028.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::8)
 To SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
X-Microsoft-Original-Message-ID:
 <20260625105953.70647-1-jytscientist@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY1PR01MB10596:EE_|SY1PR01MB10657:EE_
X-MS-Office365-Filtering-Correlation-Id: 134f0b9b-a555-4ad6-bffa-08ded2a8ebb5
X-MS-Exchange-SLBlob-MailProps:
	Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CIgbjn9CPX368tW0y7zBVDYhBIlH2ZsP+Uystt/QMQ3Ah0OpW9RtGuKTUW8poaV4TDB7MxGaa6vqe+sy7BkKOw1IgBN8KKUvtBN+JxGTjHK+mg+QqXjjuci84zhUZA7uxXUbUuX2zDbvfVJ0SHfNwrFKYGtMk3XatKd4vu1Bewp3GtFylzXxXA2jxvUJRWxNwoSGx+y/QeUwEShzO43NyRZbOZZSynj1na4JBeMup/NpCjNDAAHNr36IHS7hml557x/3W4LnaaG+ndGuyFtrUxpxIJZhj7KDjPW3+x3yHLJxez4JioUBLPHz8czfkgwGZB6Liabcxu96AX3PAAad6z5vUxIOBrR6kglSYBsyfWU27JxqmLB/KmzW1HejhgiC+QKu+93fzeenqAhI9TX9rx/sby5OvKvSAXqKX8tvxciwzm3dwx0561e2gQDq3c+UGZpbeKA3auKrReWbsYQDqvbBkBQFGbrMPbqF2J1CqN08mp4lkQkQncJ9j/6f2GH22VRbca6DDdQvqUMTyEjplO8wA5xp5Qwdee+ue6c6rIdGGLPdbBOD+NctyI5w5cHMP+bBkpHwnCZ64675NaJz0bAx9EV3IA/eBTkiKBGHi2l/pRep/fibCB+GBXRpOPZi065x/fGQw/rbhvXE/vDgaQx0w7acBiuIScymKFviUOcHWqZBLtEQg9hPrFc+rGN8zcBnno0XvrDeL/eKpvHjdxs786Dx6AfBgAzOGqocX5R54=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|4140399003|5072599009|15080799012|25010399006|8060799015|39105399006|19110799012|24021099003|23021999003|12121999013|3412199025|440099028|40105399003|41105399003|18071099003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nMSJ8o+1xkjeUAglHVCRKnoNd7/e5TZjZar2SDuXpVvq7DBxuoKYu+BO84Gn?=
 =?us-ascii?Q?k9tnHZYbKvgJZ9q5FF/bTWwiQalMu9kjHLavGrW6ND7BWvT6E8X9Ytu6SghD?=
 =?us-ascii?Q?Ef48NW2DZXgptSYCpYI08Jkm+DceISnY7st4QIjysILeDYwLBL/abCmMbHkY?=
 =?us-ascii?Q?qjxe90qg24GCdL/xBWlZejRhkFQibIQ7DGpRzSVeLexPBS6mjdJIZ2TBn/Qi?=
 =?us-ascii?Q?MlJK5jpVYeDl4BbOBQrZcjmbOj0GS/YBD0RPx2zvqQIpue/aCfFsJpF844Mp?=
 =?us-ascii?Q?hvhTA6cVvkRM4QvNKF92aAgPLUr/U0rA87DrbDUA5rNA/bDBmEdM5oiUsPcx?=
 =?us-ascii?Q?nzpq6OGPs9o2m1CETNv4o3+LGHbpYbQThbHW0amS/27C9GUlY+ToA01c1o8F?=
 =?us-ascii?Q?1o+0CBBxah9VtkZkgoj3SE5ulL9vBRHzZxuvgwAZa32YxRF5TjU4xI/9yncl?=
 =?us-ascii?Q?90XRVa5PsK+JRg8uHDwASAA4T1d9aIPipA7CbaCCRdA1a8SUqCqMMs4o82hG?=
 =?us-ascii?Q?AV0mq2Wpu4BtBffPaFv1kswW5Xxfi9SQRXb+5pEEmKGta4COC/MnNo4Idz9K?=
 =?us-ascii?Q?Udl08YXPEIR1jVxSTPv2FAoES5T77oBdW6tZlcIbyVQUBZCDI8BwsgBK/p7c?=
 =?us-ascii?Q?s59O/CFA+g9XXOYzFuAHnwX2JIPkEMkwPUWAaVrga5KuAiGyd8rDwSV5WIZ+?=
 =?us-ascii?Q?KfYap1lQh0sJMih8s8jQI52PBT6SlccJMUjmTVbFDB+pK+tKqJgthbCqkxUj?=
 =?us-ascii?Q?VzkMr6TUaCG0Hy3wVnMnn9Ydl7ZRU9VljIg6B6DPRqcUtBf8+QheqoPzCK3w?=
 =?us-ascii?Q?OW7QSPP430AM/vnm5lkDhZX1gOYNb/mIFoZjiHvvEXNhjICMIlrNR+7oCaQS?=
 =?us-ascii?Q?wDLy8COpun6ITV6skf/xyEaPEEK1CKn5YCQJifTq4L7YSPK3Xhbt6x7xLV/L?=
 =?us-ascii?Q?7sTrbT31M+NBOlsOrqJW2FEYykZEF5srtEILsiUNnngqtQQKA+LtK/wTQ5yh?=
 =?us-ascii?Q?dsIjm1IQIMslL/ix2PfyLoz8rMvRsS4b9qpLUU4EcufNStTlIKVmBvY4CbOd?=
 =?us-ascii?Q?AXc+8syV?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8ZZzoS4VbHw/1gnTxO7ifjc4qb3RT1OPBITYtvi8CJptK3oofX2qoGaP45za?=
 =?us-ascii?Q?F2YyEfSHPEfsEPd7BF5MeDNNR9Pq3ospfv4ItKgKxqW9bJafY1xxLiKgyjDr?=
 =?us-ascii?Q?9oJyNaLUWKZS4/ECJLETpntphS0T6snsW8DIW2l0d+20VowP4Cl6rh/uOpvq?=
 =?us-ascii?Q?l3i2QN0hdSxAFVtDBJUlvX7f6XjzNkkw+fhpB5d67dZHyS8xXZpzM/jombc2?=
 =?us-ascii?Q?oWmt9poXz7LJtWouz5gFyp2hDtPdfkPY+P7CwNUySBZ1G4vPv47wlInTsop/?=
 =?us-ascii?Q?r4/lhCqNTzdgBHWjTcR18B0cy65ImWjj8UWvCS4Xr+hTF5barH3T6eob0hNr?=
 =?us-ascii?Q?LfpysaU9X2wqCjfaDMwptAGYcMhqa6J4kTkg9+is4LC+xho2yNQa3tBu7loa?=
 =?us-ascii?Q?xGFXsQp9yD06wIo0apsTJHEz2x876VBZ1AY6G0NRFYpXq1XEoY9f/ra+K2sU?=
 =?us-ascii?Q?GBZxdZHORHmRveIf7kZ90PlO1/7PIuwxhHiMJy5zh2bWcUacYemVYXDJCObq?=
 =?us-ascii?Q?ryLT03B6f5aIDrBpWrTiLLGOHV3fZCmJU+uY4Wq4maEogYaHh9mzloPoo8Zn?=
 =?us-ascii?Q?R8C3WpJoNfrZSB3RHH4zOkZkxLo9ibGyVyMUaBquLuhnsHeRS8fArKHDXZTl?=
 =?us-ascii?Q?LGhpuL+Tz6F1K6gX0VwDN2FOfFiCpxVmc2T09MMJhNicZC71aN4Xiznuw1Az?=
 =?us-ascii?Q?hXesA0RzwKiMjZqfl3kK9FcCNZGtshh//S8GOpqr2n6Mz7BZyCF86RSFeSun?=
 =?us-ascii?Q?8M54BmHGlPlTgABQ8exWxcUWBS/VoKXOfkk9Mlkuyj7hIahjuZnndC4/hTFn?=
 =?us-ascii?Q?2jksqrplI0Z2DuOz0nAdGJDvLMH3KvmtUwFGbNpIyl7G4FLLOTdwjybNMRbT?=
 =?us-ascii?Q?7MZYfsmiBZv3vj4BBczcfP0YYnxunPf78GTf+1VbDa27+clScO5WuxtKpSGv?=
 =?us-ascii?Q?+5y2rioqKPqtfdTkEFRmK9FUifvc/tM7+dBN5zM5eG7SSoI+SZ9U1COtpg+s?=
 =?us-ascii?Q?05ToQLMXDj3aab+ix7pLwfGCS2sFC9D5Imyn5HqpQF7WjH5Gw9Y/XxlMRY4p?=
 =?us-ascii?Q?sA07Sdvi/hWDUPr9gLsaLDLPNW5IM+Mo8n5DBGvzXk9xju4hDdLBXY9d5eNl?=
 =?us-ascii?Q?eozIMuxyR9L7kqDCQlP12w/1A6MxNcB5fUVs+9gMEQhJ9rPpsVmKuzF9HF06?=
 =?us-ascii?Q?E5rKEt2WgH8xzS0mHl5tzXLywm1qeMTqwv7mpNKCN8a7nf3KYtrYwv3a1HwM?=
 =?us-ascii?Q?lMGFRxBkou1bu5JjHa2LZWhQTxNtVCSnYCL3lAWO1Wg+UgTSezURTW+fgnda?=
 =?us-ascii?Q?6dYeEakV8InA2VPsnf4YjDaulL93aHq6LyxZ6bAdWCSnJSWKZjotpeoBv/BO?=
 =?us-ascii?Q?5qGPeXa5KO5nHYiXQuSM5t9YAxXk2HXlHKwBnQJ+i440VQzAUSUlD+3aMs9K?=
 =?us-ascii?Q?2+dN3im0mRgzRBo0zp5a4c48MOWsoS7wlXm5ovh67HWXsHrNePuBNQ=3D=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-feddd.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 134f0b9b-a555-4ad6-bffa-08ded2a8ebb5
X-MS-Exchange-CrossTenant-AuthSource: SY1PR01MB10596.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:00:08.6433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY1PR01MB10657
X-Rspam-User: 
X-Stat-Signature: t9rkgjwe3pio9zkmberyufjnxwj48nz7
X-Rspamd-Queue-Id: 6E5B1100019
X-Rspamd-Server: rspam06
X-HE-Tag: 1782385217-539286
X-HE-Meta: U2FsdGVkX19214LlFcZasazb1DogWLD/tqlnfymSQWNNTuUeg11tmeGBGrQPbl95idOTM/wDyFpaXymrHenJaNDvjyhqHU2NSO+Q/F8bsa36mzQT2ibATd1LpSwRbnA9p9BpJRsafEeQP96JcwwzKQR6pXJarfIou5xGjrPyZckMatseWQpIo0lx7ceYZ2K2r1bnxdfr/B5A0SBqSjdgjoiy4Y0fR1MiQAJYWuVZ5ghRXFMYQZGOyZgCXUOb8U1gAxL0a0TBxy+Wozo1slt0VCx3MYtO4w/9H1xI0cLCWxj+29oFi+u6zhAxpjxqCSZgrN0Kt3RgMyv3WP6Yde2C0J8s6KXEf+N/SjhT6NIJAtgjI8rhy3hyo6l2u6TpvA9wJxLfTtQ2jgjCyO/Z6oC4tuvG23BQ9TIdrrjADbMxGHU6l9K8evFWjXqUOdIccsLc01QawJkM4dXaAhhyXJfwHME0evrsm48ua+mY9b5FlY+a8ityeVZhQUCPrPuz3uaUC1htNjNLmlVBBybJuSzQCQBeFXfaPFMiBFzqpoGNlTmdXJe5L2GjrNQHqau0if280H00ip2beocaw3PGqI5YeBEX7PTg6xlmMJvkenLryJnM2Weawx//rmUEmXuaxbs2JgWC/GDhuF7pXKVsSxCeBj2e5xNh2lKhxKfZFlJmDPTz6F/IdkSW9aq/LIb4uB4K5yOjpsUTdVDgQpDiksqykuLyjUZMOrcJp1dwXn4gjYQkVUzAFxGOx1EaxQTShTa+EF4ILqlDTRrP8IYAWhNBw3JU2u/nA7SYCZFvpbp0oY9zXDegqPguePs+8bvjsU4DmX/Iigykr8YaeUK7NNn8cDBdSTJItib+W40ihCRis+RtfbnAtZS1/dq0VsHDYD3+ZG9F1mAhMJdjQmfhVyjZcamyeKUa9PkgFpKUlNNnw6KYh+9peC/x8IIAVurHHVcGUwS/jwLVhgYxIe3k8yW
 nSP0PQ3w
 JI7nPcBdXoCWV1LcmdRq6kCXUEa3sBtK2EODXlvaUs7p8/aZNgMXebpd/6mSI3b458fvTKZqlROitG9ghk2Jmbjlk3mxkeFdn8DCTwuDF6wQ8q65m0jswVtsq/ovSg2Y9DO54WSz8djN1jIpFHkYWpHUH/kw1bun+loKKm+Od4r5v/L9wjt0FD+VlVKMDBNsxq9syFg+4sbQbmR3uV8ZPmDh0ZcFWKAAquZJIGSnm1lD9aNcSn0I+baQ7MEgQnPbbGnxBLhV2fEj1Wjf1blKK47PH/7ERZGKDaTmezcg1GLkkPO4aCGcvNqq954IzGdo4NW49hFJylM+NWLBXuxafXah3t5BbLVo0TciRw2t2bQwHIuG+fpGirsIxOl2GEE+OCfWnVIFk+IwocYFccv/MVyzg6OrO33k0gRrHqu1U0vw6SYkPNAATxodNR+ldkqTUC8jdIZmKM4MAyCG2hDtTHCcPCNIWketUpCLWx8N8VfRjBzIDLhTlBk7R9g7dnyLwJ8pRR+zkfm68K2870wEQxF4FJEbA/y9pZGGJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series fixes a THP policy problem I found while debugging
frequent ROCm GPU failures on an AMD Radeon 780M system during ML
training.

Some AMDGPU/KFD user mappings are registered through interval
notifiers and cannot safely tolerate the backing VMA changing from base
pages to a transparent huge page after registration. Userspace can
still apply MADV_HUGEPAGE or MADV_COLLAPSE, and khugepaged can also
collapse the range, after the GPU mapping has been registered.

On my system this showed up as asynchronous ROCm/HIP kernel launch
failures, often reported later at a synchronization or copy point. I
expect the issue to be relevant to AMDGPU/KFD mappings on
XNACK-disabled GPUs more generally, because those mappings cannot rely
on replayable GPU faults after a CPU-side THP remap. I have validated
the failure and fix on AMD Radeon 780M / gfx1103.

Patch 1 adds MMU_INTERVAL_NOTIFIER_BLOCK_THP so interval notifier
users can ask the MM core to keep the covered VMA range out of THP
while the notifier is active. The MM core applies VM_NOHUGEPAGE and
clears VM_HUGEPAGE under mmap_lock for write. A later MADV_HUGEPAGE
over an active opt-in range is treated as an ignored hint, and
MADV_COLLAPSE is rejected by the existing VM_NOHUGEPAGE checks.

Patches 2 and 3 opt in the AMDGPU/KFD paths that need this behavior:
HSA userptr BOs, KFD SVM ranges when XNACK is disabled, and
GPU_ALWAYS_MAPPED SVM ranges. Other interval notifier users keep their
current behavior.

This does not disable THP globally and does not add work to GPU
command submission or kernel launch paths. Additional work is limited
to opt-in notifier registration, opt-in notifier flag transitions, and
MADV_HUGEPAGE attempts that overlap an active opt-in range.

I tested this on top of torvalds/linux commit ab9de95c9cf9 with:

  - scripts/checkpatch.pl --strict --no-tree
  - git apply --check
  - x86_64 defconfig build with TRANSPARENT_HUGEPAGE=y,
    DRM_AMDGPU=m, and HSA_AMD=y for mm/ and AMDGPU/KFD objects
  - standalone HSA/HIP reproducers and the ROCm/PyTorch workload that
    originally exposed the failure on my Radeon 780M system

The standalone reproducers depend on ROCm userspace libraries, so I
have not included them in this series. I can send them separately if
useful.

This series was prepared with assistance from OpenAI Codex (GPT-5.5).
I reviewed the resulting code and take responsibility for the
submission.

Yitao Jiang (3):
  mm/mmu_notifier: let interval notifiers block THP
  drm/amdgpu: block THP for HSA userptr notifiers
  drm/amdkfd: block THP for non-replayable SVM ranges

 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c |  25 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c    |  36 ++++-
 include/linux/huge_mm.h                 |   5 +-
 include/linux/mmu_notifier.h            |  28 ++++
 mm/khugepaged.c                         |   9 +-
 mm/madvise.c                            |   3 +-
 mm/mmu_notifier.c                       | 204 +++++++++++++++++++++++-
 7 files changed, 286 insertions(+), 24 deletions(-)


base-commit: ab9de95c9cf952332ab79453b4b5d1bfca8e514f
-- 
2.53.0

