Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EF9BCA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863F48E000B; Fri, 29 Aug 2025 08:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812168E0001; Fri, 29 Aug 2025 08:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD7F8E000B; Fri, 29 Aug 2025 08:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 524848E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:18:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE78F119733
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:18:37 +0000 (UTC)
X-FDA: 83829698274.13.31AA8C5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5F87B4000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:18:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kGM+MNYW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VeKnTGYK;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756469914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=txC1XkQsb2R6wgh4KvJ4mm4Ea4I8RAHr+f9h/9mME4c=;
	b=gxBfXZj6eGpBCIh0fjfFpcrvsbqTNb0qBaXfLv1S63DfU7cMLYXcmhiWcthF6V4xgsR9SR
	FumPxUvpsPz5BdVEJBS6XelKn0CmK67k1iRhsJ3jPNJk4YvHq8UhUEAdRS/fOQJiSlFyOj
	tYgw+8rhdQ2PwFXvaW/3k22TEObPpGk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kGM+MNYW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VeKnTGYK;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756469914; a=rsa-sha256;
	cv=pass;
	b=dlRn4XOYd5bSqGdHdIbyukwQ61SBw3rsuNABgralX6vZSEStsaMI7sSnAeP0m7TKuVqFnn
	QOGEnrNDnvVs3XDBKWAH9OXZzEVLexD5P1jwGmUxdk5OsQ+HcGMhdaLQLaVx2MxgLoG/Gs
	NMJHp81bwKTO8dO+SnLX2WSd/nkoALs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAYkR4026796;
	Fri, 29 Aug 2025 12:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=txC1XkQsb2R6wgh4Kv
	J4mm4Ea4I8RAHr+f9h/9mME4c=; b=kGM+MNYWD5RBFVYZp0ds1XdUfsOrhVFjWh
	zl5FybWX5o0U3KkkXNPWISDZcmFhE6Y8TghBjrtY7+XGQcJTKQlNZnIpwCbMwQ8o
	BzLvGUHdPRD8hH5xHpgfhK81TMPfe+sBMIjYLyQSBCq23LizbthQS9b+USd42aI5
	sm5n4wn1FjiF0yJcmbPtDKfOciEn75c1THFIEBGl28V7+EhIuTw0ghBXZHknfkuf
	VvypZje5UMhXOwyObcDdsyYV2UXlTFe+rLoNj+k9Q8WJvGqVpM1EJTTPg3CMeQYG
	47XWOteP7lMjypaKgQgk+OKcIu37Ha3+mJFY0OrBEY9upfPJnQfg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48etf93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:18:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TBoEJ6005010;
	Fri, 29 Aug 2025 12:18:19 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d6avc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 12:18:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hwNi74ysUvL4jP4P89tgTUz8zOiu1/k5q7p8jd49JBJefj2UAhlJEcndjxd3obJIDBatXeZnEwq2vrJauBpIQXsmCd9Top4KnawOTJOqI0yuGvYhPtLknV/RLkiJT5ZUXDLrZorQWcUgJbdEMx9OrX7kuh32JJFcf3Q6QTjCUCP7WH2wLnRXsgoUmzeU2AwCXaTAjVgdKWViocZlCRhkOijHy6vtaq9ATPmdlyT0enDpinxeaeHSfKK4HnCBZolAq6ttRBcULLlPU87FSWkOgZlwf+2LTfHVDl7WNHAMByEPWhfaTK1nJDan6wy/gQOYLMK6DTUyRnTgEe21+bShvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txC1XkQsb2R6wgh4KvJ4mm4Ea4I8RAHr+f9h/9mME4c=;
 b=bDGGDmctCpKDwkB6zlkvHc2knEA/y5XcXkrdc4TOsa4zQdArXIj+cnvWHOJQSnHd8Bt9CNRS5QsFf4kejtLq3XB4XeabnW/hItrDgag+3HY4FGvktm1ZW2kax/19z5nnNkvu2M3CDyHG9wqGv7rYc+hhqYeMLIPDN11TcWlGltu/gXdYdJInG/o7UJnqeYJwkEsvdIpiyNq1Bs/gnd4OqwQ4AW/zb/zwJYi1k/GzpdhkeK6LgF3OWRO5crpe9qvQj1vDB0CMxMsvHZ1pZhuAG6Kt2dORTchaHllm0B1yBb1ipA/SdkQN8yAQdx5X+Qv6qKc8TIUpwGv3rSWjQJBmgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txC1XkQsb2R6wgh4KvJ4mm4Ea4I8RAHr+f9h/9mME4c=;
 b=VeKnTGYKS/o/nODYn7mpdmquPh56HFF+wPX2c4IkCjO7WEXBA2o9LwzcyHPFzxaUf3Y4+IiCPe4TwHTo154ovziMsTh5yeyCTxhkH5ThKJOa1/4Ja8IIrc2miCxIXBFdUr6aaBQ+NA3I1yuGaJi8OKyVZlxISR/kxTBITxiPE7Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6372.namprd10.prod.outlook.com (2603:10b6:303:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 12:18:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 12:18:08 +0000
Date: Fri, 29 Aug 2025 13:18:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <ad3ff8d5-a9ea-4f83-9860-a96cc1e728c7@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-11-david@redhat.com>
 <f0c6e9f6-df09-4b10-9338-7bfe4aa46601@lucifer.local>
 <a9b2b570-dc81-43dd-b2f3-a82a8de37705@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9b2b570-dc81-43dd-b2f3-a82a8de37705@redhat.com>
X-ClientProxiedBy: LO2P265CA0450.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6372:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ec3c301-2c3d-48ec-39dc-08dde6f61d41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?07hbUwOxBelOrEfLfSkvldmuNlKzvAotAP0oJehQfhVPD85aG2rvbDnSpdNp?=
 =?us-ascii?Q?F+3tY0K7+fKjUrPIWuzFXOwe5PV+LXG72E+lcWxkvDHxbmdRQ4EPe+1aryBI?=
 =?us-ascii?Q?BNbRp3OPCQVbdi3pT1WhNN+sjy0MrN4PVxWOCyMH7lUbhWFqGoknK1y/v+Zr?=
 =?us-ascii?Q?R5Qv6NbPcehL/1ztJo02dqyoQLin3/UOaMSahj21+DvxMqsPCnZMFn2tNUFi?=
 =?us-ascii?Q?/stgQN0s0IsVH+8NjZIkTT1xPlb90jFDWASfvc8ZgfiJ/rfZxvm00UhDFI4E?=
 =?us-ascii?Q?/fSAZb6+3vNqOxrXidFTbB4ZaX5S/BL+bCMPmZd9j8vxB52qxNnLJfNfptqT?=
 =?us-ascii?Q?Ss6c93zTNrJpN2K/BXwOrGIKpTX18pmlfCLQcnwBo/HXIpkEuaLwovzzX+nA?=
 =?us-ascii?Q?3v/8IRscKd9Ie+ZGA8rMaCePm9KSnTpYOCuOPMcT/5PfV2U93VmCvk78fK60?=
 =?us-ascii?Q?Pb5EFP2o7CROW9jRw39dk6FFZql8O353h/NKG3qcAt4IH9UjqLmeTe0PgVNZ?=
 =?us-ascii?Q?rDq1ETEb0CunxoQpNZe/iYHAqAiENF6/xBWwJfPewHNis8b4vVr7BTJ47UNs?=
 =?us-ascii?Q?A5WV/sKo51cSNutUPUwRvJX3m4v3M1wmv8HcvJelxoY20tMCmykaXjoykdrO?=
 =?us-ascii?Q?LZEVlSKa/Ndo8VYS5KYuVIMR86UmIdyoyOyjliFWZRnjxmcqDxoMAlL160zZ?=
 =?us-ascii?Q?6jolSPnNvkJBwVKz0gkb8EvIGhrTXtWS+YxbfmTdOsB+ilRzzUn+44bEa30Z?=
 =?us-ascii?Q?LApeMXjXxynCz1YYBiBgYVmKLZdSJI+cN8JTD8seA/UJOqHZnX/Ewvw5Go+x?=
 =?us-ascii?Q?jPSser+uKrIkXVVUfyQE9+6Odh1w2WA0IEh6O421N9ttQHoDvzJ0w+rZrCpa?=
 =?us-ascii?Q?pnWBjxB8lCiGM8g30NwEYo9yKTDbWYDPqYLsRj0BvPhUDGzPxeZnY/ehaIDL?=
 =?us-ascii?Q?VtieWGJXJNROTJfoJIQ1baHBT9zleVAAuxaWKwLHeSrwk2oljsSXLJBps1Si?=
 =?us-ascii?Q?DRZz0gvOvU5aSw0P8BKdpKcwXks0/1BnmuMFpl5lzNpy2RbKFRn2f4lC7XiL?=
 =?us-ascii?Q?5rzk4xj5OUuwT7eLGt2QKc/xJgG8MLwnVs/ncDVc+TDIHe6lwq+IvZhYQk7I?=
 =?us-ascii?Q?Adgb/RkRcTE/UbKY4n0Bsb0MF6UTIiN1rFijV4gBP/aLv5yJZJuUXk1CUWd3?=
 =?us-ascii?Q?/NMrGM4n5chNHTXDakGaO8S08v4jIwCElzdhzTYicl8RhbZFCPBBVREFYPwj?=
 =?us-ascii?Q?k27rLNxlr7G1PUQ0GqbXcHJj6tGhbczIe7wonAxVoS/2Yd9KYHn1KoTjNXz0?=
 =?us-ascii?Q?tsDC38Ut8XBQFrlSNqWEAiFu+ZnwjAvddbQ6/ny8yeP+ThvKLTcQlN3ywKDJ?=
 =?us-ascii?Q?BjcT/Q4iWMaiWBSwp6FSFthtj64Wf8hUhx6Raq2uyVk/Q/XfiLWy8o+WbUj0?=
 =?us-ascii?Q?hUHnmjt+SLk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y6wUnjW9NT20j+EVtH3uR4ULhwhe/A9bP5DG0JNwcYGnvK2OGnCWD5ysNykZ?=
 =?us-ascii?Q?fq+sGlcbvcbH7k4xxZYPkeFS03wRQ0ZEWs4t+Kj3KFldQ6DY/H/aZX/RJg/W?=
 =?us-ascii?Q?YfF0Tkdqruutfs8rF9+q2u52wSvt2tkMhwLv9mnkGK8s8SaenSoX4ghvKSHp?=
 =?us-ascii?Q?TuNkQKP/cBFo+GIB03IUaUea68yyZq3xpOiKBUSieq68lPgMcTYq3Go6c25Z?=
 =?us-ascii?Q?RZncgMtQiG8d7J56+p2Nbv7tq9icC5LQBRHGAO4QU8YBkXMBl9lcM73RYhmu?=
 =?us-ascii?Q?t3hZXIJfF51H3o2Nuaz21WGVyIGnyHFGvKMo5kPuADn+IPvz3XPurfnvR9/x?=
 =?us-ascii?Q?4PMBOyzgntwQlmyIGFpPCNNrYP7rJ8ptq5izw1ilyGc0FAaQREWeXURDneJq?=
 =?us-ascii?Q?dGRgy3o0yZPRppl/mKW8Y0AqCkkVHjDLgu0lLCaQsesxJLY2/VUtldyVqMxb?=
 =?us-ascii?Q?0ze9oeKmibFi97ftRbFUywhIhYSa6w1X6TEmEv6iZvK+h4WViY/1LlFLLrFG?=
 =?us-ascii?Q?L3zWbqzbKS6ifZKfy7o8MNjVePu2O21gwd/igr3295MohszrMatalyjkmpst?=
 =?us-ascii?Q?w6POQ/TKDdoDM0t6Zi2PdhBm/FDyaym+0fZwz/DUWIcm4/nRw7m1cI4tW1iG?=
 =?us-ascii?Q?vgIBOziuuwT1t6dhChMr8CYamC8BFmJzFAXnMeNtQaBQTvBpndJJPf8dBYF6?=
 =?us-ascii?Q?WvALrXzQ4n/Q2/RM9rOWPNSBwm2caPQKjeKXFtEJIxS1WYDnaUSi0U1zSWBy?=
 =?us-ascii?Q?ebJDh2T+CQQRXarUBa5WN6qoQ2OnUNIAPlE33PvBC/oHm3uAJQVUZ8nBeNPn?=
 =?us-ascii?Q?aQ+oY0hQC/+5KBbvGOR4m8+VWSvZkzASxzUHBwRINl+05LCi2YCqofCQmjNV?=
 =?us-ascii?Q?ZcsbQFOuGGf0gn5l5oz1x3ZKkUDZ+gi/s/yz2wstTnJ7Aid4mdBIVROpiPJl?=
 =?us-ascii?Q?53wtCaDb5fE3pRtk7+Si/MXc/EwVaaGoexfnkbmVVE9uPFU76vI+hnj9h9Km?=
 =?us-ascii?Q?PBQ7P9AvTf20jtb6874RDtGa6KpQ3LNBeV0V/xV+f/m+V6scKa5Ss9+j7ACD?=
 =?us-ascii?Q?XEzsiuatkIHYOmahz23aIGtSXy2zNUTQkALRsQhb1CKBUNF/6v5q9VocVoPb?=
 =?us-ascii?Q?FdB9exN6+OwzN5VEpkQA6q9nAARa/ECoRVeoO4A6qNcrqdGZQVsE30N2EjQP?=
 =?us-ascii?Q?VtfQHnw6/8HisY8nkrQWr+HwfO0CDN/8eii4HznmAj6pS8Wd9ffLF0Bws4O3?=
 =?us-ascii?Q?MiPpnDHrB0pKkUWbT+UKrA1j6WbJn7rrcD3sett92IfZdCNh/0O+neWPCOFf?=
 =?us-ascii?Q?3iBLjmUI2No9tQeJlXocELJfy7LtZgr5K+O2lL/Rq/pNd9SeEjSZd/UXm2Nr?=
 =?us-ascii?Q?t+Vemk9VWh/tZifDxpilEyoUgxPUp24UQDS5NMERGi5rhEDQwiys1e8+g5fv?=
 =?us-ascii?Q?Nc3yW+OUvMIy2FUvrpVMDhPYiYc3wrxqM1j3X/dt1/ta9XXQCN1Jt9ogCSjd?=
 =?us-ascii?Q?XLzyTxu4nKUHRQ0yas8J7pJdPwZKjplmR9PEkgLD8/YfF/EVWubFdNFdH3uK?=
 =?us-ascii?Q?uQf68qYMjg16M3TnfRZmzcJR/VjBfjDpX7rRGsFjHkTGRWJhjJgBlSfZiKOZ?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D0lc82rukZHwxtF6+vhsXDXlmz5e5oyToQLJvxD9pZQA+qWyNYh2aV63OxUfuFQYPaHED+j2cKTRLDAIiVzyufHZwOKglgslhLbZyYfXli91BUmURyUkqp8CVkS9Rly7oyq3XMQXsWV5z0wDHAx4OhM5PPPCgd68KqkUuhPJRQmVF67F8KU+XXKDFMDT0qPqjM11bwszv2j65AAkIY0EfC3h3VfLR0SPbZGriq8sYAD3N2324F4oAw55Ilie6RF/i8jYaK2/EnTMIIjo2Ldx4qezROyZIr90tPoXZ2a/B2m997xY/xPE62l/ZhqVKb5gWPmF+bJj8mHULm7M6Bbm5D/Uks7aR0tbEY9UfeDQK3d7ACKexoi9EprtAvmAIIbE31kkKv1GI4dIGacGL4l0b+ywtmkaMd3bFy+as75XVhA5Rk7COQII3zhRv30zunnXrUWhCp1UAroEyoAbiBurRE2wtwSIR61hbduF5/CwH0IMWMfkvt6KMrTBhtSAwsm0EbVzu081StmZmmqTjQqpsfrszF46e0nk5Vx/BD+BDuM/VYZP7aDdmuCljl2lg/q0RBVvl8khF81YqphHfed68S/SWv32lTRWUFstaOujx2o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec3c301-2c3d-48ec-39dc-08dde6f61d41
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 12:18:08.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEYAnIIbdMuhiMm6cpBVTMJPimWrU2sLD1un3aqASFaecY44AMu7lD9YEHrO7dYBrU7s4/pCdc1RCoZphQdSTvpBThXhKrBQplwMSAHNEAg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290103
X-Proofpoint-GUID: 9bl8cvboEeeC7gQtAnc9bmxC5BOjDDMk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX26V+ZtTsXsFy
 xs1yuXK2euGcI9pO7wuZDAh7oUCYEt2yzaaSpFCx8J/jeOLR1WNlcWHgKoz+ESfxLLEEtFs2q9v
 QY9CLYMr10ki9XynwYuxeLGY/FF9+ZKcesorTBOBTdgIGNb7v/U5bmbnh2je9Jvh1ajGXLls5gl
 Stti1onFvVWhboKyt7ucURPnppwhEIU+qTUsW4TqlA3F4x8VvZ84dEUTcr46Wk1eOUk4WsulHx6
 MVqd6ytKX7thIHLD3zxcEXB+RibmqMuJ1wJPx2nVd++kC3sW4IQgmAAaziwrHTzn1JaI+Os/vWX
 rsO/F4AnYWBzhMGsVNbHVTQOCuXdWDubZz9BhF6lUdnTIj1VkmIByCkwkIrCOzm4vVKe3pqxDwK
 9kOY5y97
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b19a8b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=t4HjgU3YqRTIp5Dt6lEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 9bl8cvboEeeC7gQtAnc9bmxC5BOjDDMk
X-Rspamd-Queue-Id: 5F87B4000F
X-Rspam-User: 
X-Stat-Signature: f5wwhafa9ora64tj5q48dq6bdy1ouwqe
X-Rspamd-Server: rspam09
X-HE-Tag: 1756469914-403706
X-HE-Meta: U2FsdGVkX1/HysVd5bKbhfprXdOCmxjwQl1hCsYb9eXunycBM0mCOk1RJoujnkXu0yzmXyJLPnrA0c6JOZFnfIBLCZzsThDYxpB+wXPp6FjilG71WCSFWc9Do8EYP+wxrKWoHQYvDclw2vihowhBhYGvkw74tiK23K61FyNx4dlqOrlBv0Rb0xlAPt3Tz8uI/ILm/GiHncyVOp4vWuIv/nZgIivkOYK/AhgDFBMMDczlPWX7tyT/vrQTFOBXaiK8NWtFLQVRb0kHhb8Ni9kT4zRKSZ9m7zvT0QRULEQ7fz6P0bPUrKMG/NVw7ilSa+ycYWxr4iAFgAyf1GNOBZwqqZFBfZ31TuYqr5ieJevTk+6VwlWeqhqYa/rkx72jgsS5R29MWWOwfYlM/BTQcPmm85ODUHe3ANmPsdQkNIzATzo2yigLTxMfJEPKd8Faj2KVF8VHud2NJtW0Te4CzSkO4BXvlBBVSfhFjkq7LnIYf9yMugIGUGhTpRuaPvlau9xrirFzY8bUnqbIYQg2lEkzVx18076/dpAbhCAAfwT4daejcIgvhB0ewtWDa0TPmPfMP6kG1sVoc66tIYMgqXjyq+djygdchOPn34rdV2IrZIQe3FmzXNtnR9DHt4ySDHECiZIXA0tD98AnDis3DeJ4GiiCLLGljXVVm0uAjjGJqZpowIcFya748FjtDL5N3iEKw/4pRQJi+HRBcOck0KTHfcJOAQxakmVrYgnJmEGAbaVL/F34M788QURtWUHZbZh3EbMBKKjeWM6G84wnYAuV8SdoZZrctVVCkVPRU0bHn/DT214LeIM+SuJNhUlMX5zihxdiYnJd5IGh++m8IrtYURNfPz2+R15F+6M+HImVcsLREFChMRfVIHAk/Oag6UYEcqInQgVrXRmztDOTuj6PLUJeeQWJXDnCv2imhFm8X0obJ+p5/lllevG9Fur+xozWMS7Cjjzq0kD7Nn6dC+O
 SKQf+13v
 4DZC0wC/pabQfoNYlh9ArgNTYTqNgUOEsOgp5KlqUegqGEmgelq73tnKlFlve0QD9b0bw/HVeAOApBQ0EPYaW9JuStJblN4yt0+rHC5cO5ilwLwRU9tDH8mLrcP+jl8Z8KH7iUVCL4l+MG5ze4aG+jZAc56f/TEG4Huu/6smtTZ5oivMD5t7A72OAvLGt+PUU1bJ94eVMS/t2gTA+3nnmVZ/igxLusu3015g8JTrC/OdjtaLca/+50Zf2MUYV+ss5omRDTGz3ufFw7duuT/3sbkM7r7fJPpufIDXGljg9ibVsAY19lHs5k2JaBg3WbvWtbFBpLGynnVi20p0uKyi8ycNQz21UZKWZBFgS7yumpTdYoLE82l6uLrQ2s+pHAPqHk5xV272pxFFAcfci6/JViuRkaw+T5hZQ416NCvIB9CI1/OdFYBf9ewpROXFQrl1eCzFEqEiSGMSC1T0wmQvE2lBh3n88nFrEye6SZpl3OGoyoIXOYtMoY0VGo2IHmXQqrN5z+mzYGfusG+XZtlsIqtUffJxaDLscMPe2iwb7g0BZpUngcE9/35T+K/ukPjrOWhzxZWdg01p0oSpoJeew8PjFDrpeuKWSJD24VHo8sGQf3ineAOz8yuXbjZuxTe+TjVzdzLoOtkhC4tQ2PQKSHAWNq65nwLPcsJJVXdPH/cldPUoee/Y9a8n/gmWtnQZ6hggnXcdHOHxfsU8Il+G7IsgoPo1dJPTYhHoJFx6zTunRD+OiOmVJcpZQ3/EjOWTpM6G5mEMsmtCd7l98Ry5m/KwvWitzerRH554ncWu4HISvgiGtSpNGTk9YcoBtsl1fmFAzmTVj/HJnfNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 12:10:30PM +0200, David Hildenbrand wrote:
> On 28.08.25 17:00, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 12:01:14AM +0200, David Hildenbrand wrote:
> > > Let's sanity-check in folio_set_order() whether we would be trying to
> > > create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
> > >
> > > This will enable the check whenever a folio/compound page is initialized
> > > through prepare_compound_head() / prepare_compound_page().
> >
> > NIT: with CONFIG_DEBUG_VM set :)
>
> Yes, will add that.

Thanks!

>
> >
> > >
> > > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > LGTM (apart from nit below), so:
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > > ---
> > >   mm/internal.h | 1 +
> > >   1 file changed, 1 insertion(+)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 45da9ff5694f6..9b0129531d004 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
> > >   {
> > >   	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
> > >   		return;
> > > +	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
> >
> > Given we have 'full-fat' WARN_ON*()'s above, maybe worth making this one too?
>
> The idea is that if you reach this point here, previous such checks I added
> failed. So this is the safety net, and for that VM_WARN_ON_ONCE() is
> sufficient.
>
> I think we should rather convert the WARN_ON_ONCE to VM_WARN_ON_ONCE() at
> some point, because no sane code should ever trigger that.

Ack, ok. I don't think vital for this series though!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

