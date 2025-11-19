Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5ADCF258E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030796B002E; Wed, 19 Nov 2025 02:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009BE6B00A2; Wed, 19 Nov 2025 02:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E118B6B00A3; Wed, 19 Nov 2025 02:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC54F6B002E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:24:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 647D8C0347
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:24:49 +0000 (UTC)
X-FDA: 84126519498.20.C5F9E38
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C879140009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:24:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JfbVW3O7;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eRBXeOPh;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763537086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8205IPbvcpqCpIK6KV13sASI61Mr1zUjkT4vopKw3kk=;
	b=lJIPZnsDGPWWbP0ZNypsVPQpQ3wn6zoMSttJffoNGeT/m2Eg9ITYwQ9if8MP1z4UYlrcaf
	r4qd8KQSPV/1SYuCiOx7AhNj1PGity71yY1k3mLkbDFUEgusMr6kD/QXdivO5+nfbXu2GG
	TVEU0fX5xD1Q8Tnwwi35ayeB2Rnc3S0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763537086; a=rsa-sha256;
	cv=fail;
	b=PefQAtzJQeNF+AuSiV4TH9RA+PJ48QCFtACaUwxaWIzJ8av1+nxcghrxMQ1e5IIsJxUo2q
	mKu6fNOgxAa/G/5uwmGCLfEfwDfbJH3+J6ddyhLlDbxjej9BbJEn++3mMSNQj5a68IFMo2
	JawAz52bj1sBBt47QRJPBIgauxHvMWE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JfbVW3O7;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eRBXeOPh;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AILNgYp007960;
	Wed, 19 Nov 2025 07:24:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8205IPbvcpqCpIK6KV13sASI61Mr1zUjkT4vopKw3kk=; b=
	JfbVW3O75CQJIcO8YGY4Tka0gxAB1oc+gpcjzsSThdq70SePZl9qRq480QwnjucW
	9Gghcxksaw37nPPHiFHwZ5B8qrgUOiesYDvCFOKDqZJU/Saq0IIL0KM6bDajBHk2
	grRDcp4sj7g1EFN8B2kAeJVTg6EyL1mioPx8qr1YEM8nh+v8B7WidqLVnCNyixZh
	wsHJg6W7tKhLJNp0CJtJutb/pQOAMBKEpxCLAvtXlCnxOyiIdMbi/LomHnsEz2Ee
	MBqcKBo9bViGe4oghQDLGBMd9TTbWNLWd2NqrUORQZIcjoDIG4xXaywz95jmmEse
	tsXamvQ2CWwAGq7SC31ufA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej966ejv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:24:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ6dKJG009661;
	Wed, 19 Nov 2025 07:24:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010060.outbound.protection.outlook.com [52.101.46.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefye90k5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNw778YdzDWxNUTFbjPaUhGhdjNvWf4Pwzz818rIoEYXpnFsuZcRyuJr7HzC/578E/EJ5Lu9CFbC37ydSI5LxDoL5s+pGmgp6m2NVVemf8JkuKZoIy5n50JruZzf9fhDOTMlrwnf3fhHeQQ7Mxsm2oe7447NA8qwZ9m7NwaCqFtp8jYFZoVQJXjvy3grykyKC7UqbzTrsnDdqmP/EP0NKwwQHRb0b0jaDe3hqe5uu8Vsc03wJKn188WUNJofTT0sHBH5lNveia/wKk7BIacNU+8K+ZVgyuyW6ByBKVGedWN/OavXvFOrz+fDCqugOkHdgGujk2xlGcrMIpBjUMz4LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hqiR0j28AzSriH6R59QzQoEEto0oHX+1BpiC6WXEPjU=;
 b=gHHAaiaXIYAV8b+PGgqOA6DAjUnSxGUqakiMl6UAbgZfUdwmnO9HbXqtodRJV0LSq/mlV87IKdoecXZYcdWTk8trAs9U26M3zTAFWt6pdTj3cnFgEwNGlwDfVfjWYX3B8YzVhtjPj2OL3Aaalqbin20Pqk0fPCTwHj1/ydnXGw8YKUvhsraWSCG+QcBQvwCKScSrmw+9H8sUctMnKomqN6UQ869NEfK9J31AhjRHM6QjiFDF45H7SSj5ljxXtX1KNt25KjA8TVR7UNXit6GoEuQDCnhhK0y5wrcCdgWCWX5cnmXYwtC/NLI47+g50i5iv/GknL4TTiqrIAMmtQ3b5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hqiR0j28AzSriH6R59QzQoEEto0oHX+1BpiC6WXEPjU=;
 b=eRBXeOPhec3AbYoWPTczEat3FHlMjAtCR5kRcwfgkdzP9458onF/YONMTHbEeYL8p1yvSzXDUa18wzvkUGJE4KlhnEun2fIVZvD/DKPsVDb3IDvUz32h60i6UO384k9gV6xHZ/WL5Df/ZeZaSsPMBl7FYJp7srShL2e9h8Upzu0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CYYPR10MB7565.namprd10.prod.outlook.com (2603:10b6:930:bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.20; Wed, 19 Nov
 2025 07:24:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Wed, 19 Nov 2025
 07:24:19 +0000
Date: Wed, 19 Nov 2025 16:24:09 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 06/26] mm: memcontrol: return root object cgroup for
 root memory cgroup
Message-ID: <aR1wmdn013bblCN_@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <5e9743f291e7ca7b8f052775e993090ed66cfa80.1761658310.git.zhengqi.arch@bytedance.com>
 <aRroO9ypxvHsAjug@hyeyoo>
 <e5edc1b6-4c63-42c7-91ab-f1a28cb0b50d@linux.dev>
 <a64d9d17-1706-4936-8742-8ee5bc4988ab@linux.dev>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a64d9d17-1706-4936-8742-8ee5bc4988ab@linux.dev>
X-ClientProxiedBy: SE2P216CA0087.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c6::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CYYPR10MB7565:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c34531f-d6a6-482c-6972-08de273ca75e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?Q57WbUVos6Z6kIE3xWlmF7D6QixKTrxPl4rNTV97iPbpRDwMpEGTXL7v0R?=
 =?iso-8859-1?Q?oBpce8irODTUoVdvhsIl4nd6QCo0RiKZHiU+2riH3Yl6HflCEnWNWlWNFH?=
 =?iso-8859-1?Q?rAbV1cnvVvd5c9568+QBIl8vgf5yWyCFFxgLVLPU6nW4ihVAMHgDA/1fb9?=
 =?iso-8859-1?Q?Labpzrv9J0E3qvhSf/tayCcypH/J3SuiccT5J4BkeYEqBIGMxwHYFAqOqv?=
 =?iso-8859-1?Q?INFe2StlOX617479viXKWLVRYYqUHTFDpOOTc/PKyMAQ+mqCxbmaW9ycm+?=
 =?iso-8859-1?Q?lwob0t1qZf3APOKC8Nurfo3qMYIMTz0xwQAd5yCvZg+lVIBxnDzdwRtAY2?=
 =?iso-8859-1?Q?vi/GV4pFVTU0B3VdXs+jOM78V8S3RcaDjH2SsvWu6pqzqH32Y1aTVpDTNn?=
 =?iso-8859-1?Q?ZhdkHTlIzdXSQN1/y18rfc+h9scVDScuhNSgz04I3xlwIehpEY1Ngrm9wU?=
 =?iso-8859-1?Q?JQ0kl3Eu5I7FNYhdNdm1ITLyOy/uDNvf/B8lHuWTaaVswo1nFJie8hMEUD?=
 =?iso-8859-1?Q?yRPWIr+NtxSV4mkYG2XT3vNvp0ydhYdOrnLXCYfyXKvI/L/rVfgs2xkeQH?=
 =?iso-8859-1?Q?/ENdUJcudo2XoCT8xt3Ldn8RQqhwGdcbpF/L/tylClgHDXmO3ydb7Xz3SI?=
 =?iso-8859-1?Q?XNOuBb+4H3U87Ocq191GpPhrsrVH1VBkkZ0wfevNk2dDFJHrGRv2VwPCyX?=
 =?iso-8859-1?Q?e4PixHuxwpTzAmzzUI4Ml/0Cb9SIEUPAHqqRAKtiW4bjD8viZR3lSk045Y?=
 =?iso-8859-1?Q?UUSxcooxXEgjWWgSDVX8FJgCBWzGWzgrYLxZ9mgR8D1HCj82VKklWnkMlR?=
 =?iso-8859-1?Q?euQlWrVZXVSLZ8RPmpxY826Uu36AbkFDOWFv5hg8DZEk4mZkdgd5xwfSf1?=
 =?iso-8859-1?Q?oAa298gBEW3jQAaexp2dTg/3UrNFkoOP2JtEmYcJIRUaorQ/KMlxEA81HT?=
 =?iso-8859-1?Q?df3bYLg46dZK1CZ3oRNmaKm7ilozAGA4CxI4pUdeWLDQrhjvMU/sE3k7PW?=
 =?iso-8859-1?Q?VkzraNAFGq9j/s3GOSq+0QTI6ATKp+I+XMgGlHtBDXq/0LqnZifQT4ffRB?=
 =?iso-8859-1?Q?BoE3f5Pp6vKzTpcY9nllx1AM39TXMbTRRwAXr/r4SwkJjZwX2PMXXkMcGN?=
 =?iso-8859-1?Q?2rPWKqJpKlpyzsHd8d4a/phI0GK026rM6YdXXpf3zThUJaTt4odQvPBemM?=
 =?iso-8859-1?Q?1I7qsfp38sKJFOvy0anJikWspnwxxrVpASb31pOeV0jiJjiWHnj8isLoqb?=
 =?iso-8859-1?Q?P4z3Bmb2t8wyDPejtsDj1b6/XqADlbMOeA8CNIeXX3e6uGOkZdCxPMJRNB?=
 =?iso-8859-1?Q?phfMqnJfzvxUgodKA4ghRMuI7fRvBu1/09meOjC82EeXcH8S5rH8PXWvSH?=
 =?iso-8859-1?Q?XBr4Qgxk5XTzqDJBRVEFHWQvlgFChNEQPkh5i7o/hei2DTsJQm0WmqFKIZ?=
 =?iso-8859-1?Q?bwl6fbedwHrR5+LoqCm4KdHK/2yXFY7Sd8Jq5R/QWSxZnyP8zP8wohMMgM?=
 =?iso-8859-1?Q?5SeWzZkj9rrLlMV0Jedo8+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?7xATBxGnNKighQH4+gBmlmIEjTuFbSCduUdoWGoUrnQiBPvcYUdfvhgMNS?=
 =?iso-8859-1?Q?jaYcaD57sve6POFg8lWLDLXLRolZ/tEuqqu/BC2GgSUaaAI0eJusyl8wIC?=
 =?iso-8859-1?Q?6vcut/0+F6hHr7mEALStB2ncmxwAQoU1D/sWVbXQLOBRjXzoo/kOgAUESA?=
 =?iso-8859-1?Q?jXFmd3LbaKzaQTq+7pI0T8RB8Wxb0CGgEwlrkjZVfyQzir/xK9IceZqwXl?=
 =?iso-8859-1?Q?ffWvRNczhhwauE6mYJjhTuWPLs/dUNfANFiTaxB4EUtDtAy3eztZq/YXg5?=
 =?iso-8859-1?Q?JnS1ahFXJ7J/NmPr/k1k9fY2K9dqZRU7PlyD/nO58TSJEGeCxLJSmUL6o1?=
 =?iso-8859-1?Q?3zzvIkvfPVLMjnIPdAN0Th0GOp7SmqNpURlvAl1MhloTHUmIHEPTeixUC8?=
 =?iso-8859-1?Q?zhnbjyavYQBRxIVfD76/qh6dcNHzYisFyODJZUuWW+S1O6/E1w+pJuWF4U?=
 =?iso-8859-1?Q?mZKC0bbipGv7R45i+BP73vxSeUiIrfHdk7EglRHA49jTx47RzRdfbbyywO?=
 =?iso-8859-1?Q?gctOHiJJ3zjoXCnYsl1NHB/DRfTretskwCpbbWRVIDqlp1GdwQDewWl1bD?=
 =?iso-8859-1?Q?FzWhnW0fv7PK+U9N753AQiqyHXVTl9jcndaA5D+JXqoQ22yIz+W+yiZYQO?=
 =?iso-8859-1?Q?ySFpixd2ZgjN0ojt9e7Kj4BryPf2OkNJgEk7p6rxdhyA6kmEA1W3wSFKfx?=
 =?iso-8859-1?Q?uWhEroLBDM0XBXnn3pnqRynq/NovBwbYYGKQOjktf9PSMI7KuOAZf4as3v?=
 =?iso-8859-1?Q?VxvR1C6RtARoKBV7abydxLt0RKSmlWCU8t3fGvO2Ew5W9s16K6BeNKHMaw?=
 =?iso-8859-1?Q?Ifd7T1pZe6ZoEA6ge6mdAP/8W7wWthcc6/C4kTYqRruluh62T4H43uSLE6?=
 =?iso-8859-1?Q?ODDXJrSEa0z7Y/ZRCUeeAVm/7ETX1gzCx8ENG4wdn9VdrXIe/3kb4Ay4QF?=
 =?iso-8859-1?Q?ciy/IuJnLjxtVftYSqRa9FNwcyNQ0BxNjNRri5C8XNrcTnwCZ83GrGr0X+?=
 =?iso-8859-1?Q?Qa9DxLFEnp9mWQaF6T6oEutfJKaMr3PxVy2xvZCLOURZYgR26dTHOwUL5f?=
 =?iso-8859-1?Q?/MBnhMrXwXeTppMTRCCG67+Av/CJXB2VoDiDPSE72yxopFEIEAFmkzM0Cp?=
 =?iso-8859-1?Q?r2ZQGuKWUO1JbqZBiyGEcQ4+zbIx7t7/3zl2aE/AcPqawA39hzXs9JC+1K?=
 =?iso-8859-1?Q?ki+oLO0mvgbIvjsXyKEgJXweZb301qL2nwI4Lt7rqEMHiGXAU3Fl95uzdp?=
 =?iso-8859-1?Q?yYwXxUMg+v63Vd4Z5egoZt5rVBki8W9Du3xhGnx/CaUUoUGRZGalHfmGIm?=
 =?iso-8859-1?Q?Y6qhgi5XqVDFAotWODUnqMZSHRadiAjoLib5C0RnUpd7A8qUL3lfg93MUu?=
 =?iso-8859-1?Q?lFJOkLpwkJ+zDBzwbAduKpzYDLtLTAG0Jq6W7lwqoX8hOMxF7aT0reSu8j?=
 =?iso-8859-1?Q?GiJoHsUkoWM92LxB+QfOxdgUqSdmLaiCxKpZmIddXCdElRSI0AaGgOL3RI?=
 =?iso-8859-1?Q?kzWKGYLCTTGchBMi3XA+OsRVWxaGUZuY0lENS4aCnLRqWo/oUIiCNwzguF?=
 =?iso-8859-1?Q?WKH3uu9W0Q2mKvgWqQeKnrpiTPn8AQPPbjrWDH0AxQkI5xgXU7RzUX43gl?=
 =?iso-8859-1?Q?JVOer0YSXDGfQbpvEKhpyc3NusuAFEzN/9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DMxoTIqOT+KFhproDjgP3ZV0XVI1IleV70GGnvXbqFo5MkTjNAR3vvoFebATUFHkERWKqA0yHq3q8jXBuyp7RKLIz1l50GBksgEWHPsQUnJwCvFS9qWmkNyf+dCTIcg7Dsg026f01bK1PA/HSapiCox2jjfgO9VFUxT/2RXoXjxqKGewBA3PM8W9/JdKiYQjJ3ZqP7nSgu838hoi3LrWsAPt8UB/Isr2r5VUaHy/AWDtViFtIZOo+s/ceXwhtx05QtZIpJFn/57oUNcWF6zvLfdOEHpk/Mavw0bk2euyGx+9Jjn13aPR8r9V+fkEe82V24+lUTcjn7qMPB5oyKaXtbMM+yoUXHSlnGBbA9BHH2cyhhq6IXU9FqrdRL9keqVBdYEiGiKdI5kCtuqQezAXf+/93YHMyYzfeFilnEYMljeIuC+++W4G2KpLaUP2WnQhD4X93ur5mNlWysiJT12aQj4b6IHdCz4vr830zImaqBsJszS74eYazdiHQKaBhWC0MX2Tvz+BgkihR53J8WXEWFxApXJaolbyXU4AP4XonS7zrfdCM+42gwKAi62Rso/iWkFzwi9N5Myekq/QNMd0gsi0DMyqdM2v2cOaMEUA+0Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c34531f-d6a6-482c-6972-08de273ca75e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:24:19.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ELuZq3s7zUePZVFfy4xXNmD9zuPWYnHAv1raAn4hl9TLd8Ba79DreX3WxfuQuDKmLjY3Mio7njwu6CeF6rDFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR10MB7565
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190056
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691d70a8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=BxFz02y2hMTOLod4YJsA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 cc=ntf awl=host:13643
X-Proofpoint-GUID: 6egU1KVNlDXXzhTAMstKswaVcIeP4c_f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX6f0obchWxBt8
 mDQ3qM67Gnc0+SqTuP8UmBAPfsln2b0mK5dTbOiVf3VmeTYmG+dYGYE/7bVrfc3+3OXyx04nm8C
 YSsUfNGNE6y3dTwD1I/si2TFb9nJc/MLB+9nRMDXmkVzi4SOZvtTIVsI2tweL5bEKuPsir5MCTT
 csTiI/PxFG7+8qohZOjjmAPfvZq+YfZ8tDVVJT6N8EN0tug0ls4OFAj5zUWRDvdWA9679WpAmT2
 9RW3D+4xW5Msask8UD1SeUce6qci4tTA1u+ZLeqwbrk83G98UJC7getR/BcMK0I6GgOlPE8gDYs
 I3mOKJIS46elAAylXrFapcCyHVoYQdJrszPqNxPBv+f1Dnteus61kKHoXup0ilE4zXzjTv54WyI
 i9vIiEPxxDX1UVFiQ9X+CQzVmKNG0Xa7M6RMQrFEtO5XjhsbjKw=
X-Proofpoint-ORIG-GUID: 6egU1KVNlDXXzhTAMstKswaVcIeP4c_f
X-Stat-Signature: ukjcdd66atfuxjtjp7izc33fyik5rx65
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C879140009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763537085-305273
X-HE-Meta: U2FsdGVkX19vMSy8bvMGvaNZC4W11bmFJCwNdSwpShXD/CpdBzFeAQ5CIvyuUMX2ipLZ/umgXADb9ohDMGDT58h050yY4L39jr8CN2xc/mfolkqJHfHoqQHVjgHvzMBxa6wWFd245qNiAvh0tf1oUbIy++OPibGbHfhCEXVXoYQJvL9RgHzMDW7Xy3+tuyLSMSw6z1JLCAIsBlPuGLzZEfv+yNiHMJPlAqD30EsTrnqI3+RwLu08okPBj4zu1ii/rx0Vj2yBlGNBOJ6LscW+nYEGNuW8RDFG32s0bRxC+YSTYzLTVb6X0A1k4j24GNAK0uv+SaX1EvBkcWMyWMNDGi8xF+dNGq/iE5lH5r4KBhS6TVcB++q593e0YZRLA4bDCnP9iacU8tfXvzDapIdVMkIkJ7kNmgE1hXEosED2xvYK6MNKIOJgFRj4uHnRq1P4J4SHW0ET5L3H4hXwRwVZYUN9oLrCMiT61fgevP9FxgGc911cBOprUJlwFOZAc+hC1jjoXTE7OPfaWSwmG75AoGsgZ8SvZ+np5G+TfTqHA+CJ+9n54iOGmjY8/qv+oYAfEoy1tbx2K5CNJmTgfa7lMMIa1W/Ox48Zfar1P2diWyIa6mPnEtZV0sTN71D0B18Il2Qh7I2UFH24djvjgi9sNl2tuSNwzcxFr96W/ogEOuWn3QIYbGdpPed5d1o28JXB9PshBDfVOCO4UyKO2EsLsjLeJRoGXPYyvkOOJBHG4/DkuYlorlEJgxZMPQH+sZqCu2vEJ5lK/Yg0J40Qo6SjRMs3uOUYoGb/JacpwjHdbf3zhLAxD7dJUutHWfqeklZEGk0PNVVyTH5d/p6celN7d+0c5MwEFTZstIx0bYHKXOCyRnAt0gLWtMpcqev05GyEDnhC88sTZBL7fyVNtdc5rX65UhgMKWSY7F+9rbbc2nvQMpzEUtOWQFg3H/BqiIebfZPt06zZiX3VuPP3zMp
 Xrm8xi4i
 n5Rsm5YlpUwboBg0iiINQuAYiyrTA1SQpiC79oASWB9eK6X44Ff6RKsqDLF9sG51IJPufNfRZcvuHYIwd1evl+g4f6vOIQvjPYIFpCMKrh1RkV/mmrhOMoLcH1aMkCm3Q3vt+7kgGfgibBLT4Ld1oYSSA0yPI1543R92yQydAZPa4oYuh5h2yr6Q2xp1DuLvC7IlpLn7Q7vpV0j2qxIB3nW9PXH5p5dSFDUTKKkld7DikfXxYnNJNyHBjG7f5HMA3U3qBD+Aw2fKfqSj5H6Zmy5RnjqB6MB8QDt9GGw8vP95vAPRe+wajylsNZVd/jflsAYBSdoipLEtZCXlw9ygtTo1xTHd++WO6AUNRgtxukueahleWBCh4REKjMYYyd4Bjz1cPGpIE7cy1F9FZIgS7uvO3vdnkm9GTG8uavmDfXYkfurFnRSEixjqzBorxkL5NlICNNoRsT3veXfrhVmJKdy6XoeDRxZcrEAuIosZYl4xEiVWT5THs7YeR18vtLMxylLSkdwVu0up+Dgr490C0Y+1J5U4Nsz2RXewAWzz7Spw1R0TobrUa/eFV0+nP1A/rbHAkpRH8ja8yKqRfJbSHaZdOKk7R/wWKkVBYoP3wdpo4AvXFbVOcoqAd6LdlAGI2HE3OWIqrTH5f7oUMhcUUGEgEOfXTthYOodxVJ1XksIeLP2SEvtnFYflHt4YGOtfHCfjPQqoEo+JNb/RfmB4mX+FeFGr9gRffD1rB15O5JdzVxZa5zjPYOxqkaKAzMNhBCgjdnYm9veLyKVYecGrVTWheuu8FaX+7XePyL5aTEUbt/5CfqkfQxU8Br8teqj3EydLEW9FZbcXzN0orIXXVWseQOU6TzAmatYzMfLDG9Puh54Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 08:11:04PM +0800, Qi Zheng wrote:
> 
> 
> On 11/18/25 7:28 PM, Qi Zheng wrote:
> > Hi Harry,
> > 
> > On 11/17/25 5:17 PM, Harry Yoo wrote:
> > > On Tue, Oct 28, 2025 at 09:58:19PM +0800, Qi Zheng wrote:
> > > > From: Muchun Song <songmuchun@bytedance.com>
> > > > 
> > > > Memory cgroup functions such as get_mem_cgroup_from_folio() and
> > > > get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
> > > > even for the root memory cgroup. In contrast, the situation for
> > > > object cgroups has been different.
> > > > 
> > > > Previously, the root object cgroup couldn't be returned because
> > > > it didn't exist. Now that a valid root object cgroup exists, for
> > > > the sake of consistency, it's necessary to align the behavior of
> > > > object-cgroup-related operations with that of memory cgroup APIs.
> > > > 
> > > > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > > > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > > > ---
> > > >   include/linux/memcontrol.h | 29 +++++++++++++++++-------
> > > >   mm/memcontrol.c            | 45 ++++++++++++++++++++------------------
> > > >   mm/percpu.c                |  2 +-
> > > >   3 files changed, 46 insertions(+), 30 deletions(-)
> > > > 
> > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > index 6185d8399a54e..9fdbd4970021d 100644
> > > > --- a/include/linux/memcontrol.h
> > > > +++ b/include/linux/memcontrol.h
> > > > @@ -332,6 +332,7 @@ struct mem_cgroup {
> > > >   #define MEMCG_CHARGE_BATCH 64U
> > > >   extern struct mem_cgroup *root_mem_cgroup;
> > > > +extern struct obj_cgroup *root_obj_cgroup;
> > > >   enum page_memcg_data_flags {
> > > >       /* page->memcg_data is a pointer to an slabobj_ext vector */
> > > > @@ -549,6 +550,11 @@ static inline bool
> > > > mem_cgroup_is_root(struct mem_cgroup *memcg)
> > > >       return (memcg == root_mem_cgroup);
> > > >   }
> > > > +static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
> > > > +{
> > > > +    return objcg == root_obj_cgroup;
> > > > +}
> > > 
> > > After reparenting, an objcg may satisfy objcg->memcg == root_mem_cgroup
> > > while objcg != root_obj_cgroup. Should they be considered as
> > > root objcgs?
> > 
> > Indeed, it's pointless to charge to root_mem_cgroup (objcg->memcg).
> > 
> > So it should be:
> > 
> > static inline bool obj_cgroup_is_root(const struct obj_cgroup *objcg)
> > {
> >      return (objcg == root_obj_cgroup) || (objcg->memcg ==
> > root_mem_cgroup);
> > }
> 
> Oh, we can't do that because we still need to consider this objcg when
> uncharging. Some pages may be charged before reparenting.

Ouch, right. We don't know if it's charged before reparenting and so
it can break statistics in a few places if we skip uncharging it after
repareting.

And I think we don't charge new pages to objcgs that satisfy
(objcg->memcg == root_mem_cgroup) && (objcg != root_obj_cgroup)
after they're reparented anyway...

-- 
Cheers,
Harry / Hyeonggon

