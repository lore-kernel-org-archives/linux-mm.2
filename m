Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 413FECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F77F6B0029; Fri, 12 Sep 2025 06:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FC96B00AC; Fri, 12 Sep 2025 06:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2DE8E0011; Fri, 12 Sep 2025 06:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6651F6B0029
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:25:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 328F7C07C9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:25:11 +0000 (UTC)
X-FDA: 83880215622.24.958185C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC01340015
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:25:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=USlXtwF0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="LF8Lr4F/";
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757672708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5wCVel5Gg+fp9xxjjAdkfTJ9BuvMI4jnE/QdyIUDKg=;
	b=otN//+wExHcMRowUPTiHY8AoVDF6Kza9NhCHBTwA6gHyj2VCrT/n0Bsgo/WD1PqM5Kqjf9
	rJpMwjNMsgUZic/pMIuTmz9l0C6CR72nZ0o9aWA0T5u4tzq7ea9cKvxNDsi0jpp6CdFjNx
	kxZ+Th15OIGns3T7O9dgYvQo1PDj/Gw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=USlXtwF0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="LF8Lr4F/";
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757672708; a=rsa-sha256;
	cv=pass;
	b=41Jd3WfqV9++dplyrrRzTtLNVzK4T4GxcISqE/U9mOsH5pB5dLeQqYYZFq1rXAForqgmQt
	db4rh/rD2Nug2aftXL7tAHu0A76j7g08L/To13Tn974i4+Gy3LvOa+wsKQq/lb0nEFZNdc
	Imu9a96/fepTmXJdlwV9RiTtRB8B43k=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1uPhq022740;
	Fri, 12 Sep 2025 10:25:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Z5wCVel5Gg+fp9xxjj
	AdkfTJ9BuvMI4jnE/QdyIUDKg=; b=USlXtwF0kQOAWhR9raY+OBd75krgTYVj/N
	QRwo+3PLvVUx5RF4lBk5nZ6VIY73Ab7ytFXOtZVDvYzcX3HzjjlJO9lDYkmXrKGV
	yfxbrQFCcl1d83FJ1vma4Z3/vLQZ6LG0BMrLhbSe2AmH5JiduosjjPLRftR6E5s9
	65mQeP89ZtqgjmdVnnp3Q19hT8kWKuCKmeq6k9a5/lKzSPo3ONlzSErUCTNFvz5m
	wFSbKE+WwVYH9dPck0vbYdWq0N+TOKgBR7bkGD1XtkggVqE/4TEL6ELCAgZJtIJK
	GK3gep2uw/c6ydU5uGvKmzz6bYskOMumaCS1mFgRmRuPxBul3K6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pefyxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:25:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58C8pM3s032803;
	Fri, 12 Sep 2025 10:25:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012022.outbound.protection.outlook.com [40.93.195.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdensh1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 10:25:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m48MCuE7Db+sXNh8Mj2Uy7Aa3NZpk2abGEHt0vHyQ/HJ5nIVlv07cUxIVmxAhqSQOOhtCyG8Y2+B005mSu3mPpyL4FcXeK1EmoiUsGbd1rHqHolKrggmi4S2S3q+Iq/1pvzreLLVUY24AmGX/8PF53yxMVxX3qA7uNiDqPJB5CAvjkUWuI8LxArLJYbYGPjk1rQu20s7LJwZJvpUCi93YuvH4LV+lGTfxe0x9EAJCm9pZmlMYYg1jO4yinbRm4I550dA4R+rRmTioJEzrgMRX9GrC04XqIcOLB8vxL5K6KKtWpuGRmFXlRe96/BVJ7IRNjcgQGy2hpHDN3Hf8fW4nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5wCVel5Gg+fp9xxjjAdkfTJ9BuvMI4jnE/QdyIUDKg=;
 b=napJLH9L6peooqGvi9xc491Xk44bpShafQ8HjYgMhJncnvWl+QtbhIlzQ93jRWxkqAJetcHW78Q0ps9jMQgamLkWAQw/FR3IM7de6ivTF0gnmbLw5z60xbi6R9egbtvU7+3lXwSAOPgG9TT/0NYYLc9z+BDWdA2x35TSklAomvcJcUtwtIYKFWgcO9dSp6eEdYB3gh1kGNc2EludaFCkeADBCI+hOJqB8fY9CQAHspG8oRAh4D6e0IZ/mGWjJFzgso9Ypugt5/0TGjD/cADlJK98g5r+V0Bdmvbl9AuTof05fsjAxthfYRAJOw/xJjjVBqQIS2XSFB4eD5Cpfj0y1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5wCVel5Gg+fp9xxjjAdkfTJ9BuvMI4jnE/QdyIUDKg=;
 b=LF8Lr4F/K4VY1263vqqcAKiowtB/YwtiexjetL/1noo9NnSX2CAGWi1HjzyujjSacNDp/WulZ2UnICLLwXH7bazIAb3mHYi1LDIhxuIuRUjyUvpIFPq4IngYdCcDqWmNzvnqkc7Gry/mwUWxnzoV24mTjKLl4aiF0KDufWDAQVM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7793.namprd10.prod.outlook.com (2603:10b6:408:1b8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 10:24:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 10:24:59 +0000
Date: Fri, 12 Sep 2025 19:24:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] slab: move validate_slab_ptr() from check_slab() to
 its callers
Message-ID: <aMP09Rrvxt9AxizN@hyeyoo>
References: <20250911-slub-slab-validation-v1-0-8b67eb3b3dc5@suse.cz>
 <20250911-slub-slab-validation-v1-3-8b67eb3b3dc5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911-slub-slab-validation-v1-3-8b67eb3b3dc5@suse.cz>
X-ClientProxiedBy: SEWP216CA0130.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7793:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c66c7c-beec-44cc-646a-08ddf1e6a059
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a2795s4mBRwZ1u2WD3SQV0yorbdzUTGU3Fky7N5bAN7D8RAIBkOx5zAnMXY6?=
 =?us-ascii?Q?5O0g9IxZKDod7j7/CrZjaTouYcHbehrAV1sUfg7H0GbJ6dwzingF25lX0ybj?=
 =?us-ascii?Q?FoF3LVELsFBvcgtJEn6P+5nvTB0uDCnO0GMFuBTs+ZJmDFo/c4VgGy4cgRw1?=
 =?us-ascii?Q?ovMU5qvoDxeWWl9RKYWKIXYyJo2uMJjV1euN4YEoycOK7hHDbIgY6IZIiZUp?=
 =?us-ascii?Q?O4vJ9RuwH0w3xFV0EeyJZDuevpScRRAKlOvfL0YJv9z8TZppXB94aElzlJ2T?=
 =?us-ascii?Q?SJNUpoQb5uGAHDJi/6MduKg6o8sxzw/rnIS+5yPs8Xm3fV3tCOYx1k3ddpj1?=
 =?us-ascii?Q?kFP+nCXwpXkdYg1vENvQjr3s+Ua7aoW+6cuzevChBM1jRZjMHhM4i3avaWP7?=
 =?us-ascii?Q?NZHcl61sr2WDtmEYw9AAMmHtDdcNr5V3gCoTTFm+Vg0YXRly11/EcagV2Gv8?=
 =?us-ascii?Q?CaSUwG+1EXHWIaD3BWovMxGlcyaxjfXyJkH8AgJ0L8GjUBPkcM+M3E7StNQF?=
 =?us-ascii?Q?kjYkT0G9LIj47B44jJsY9YvoJQ3FRbpBtxQX5FCKf7WqT7jBZbhxu9faqIDd?=
 =?us-ascii?Q?XGHdXcDLn1dmy/f2f4LS1qhvmJJkijW4IKPFzTcvnWuM3YuEbShm17MydK7x?=
 =?us-ascii?Q?wLT5VAIQze8Xax7yma1pD7OoMCnLS1DILpLxHURl92aLlilpol1a/tZMhIF0?=
 =?us-ascii?Q?yxalrVRN4nMUryu+jodFjYrwXwkWujQnukVj2qaVTRgJp9O/MKQqwyLKbkm/?=
 =?us-ascii?Q?u/qcaYUYoexvIVZPjVQnNLRtimODvFGtfqZBiFZAAO5Wd6IGdVkIL3to1O1h?=
 =?us-ascii?Q?AgDlv5m1YzJB6mXiQpKd+MkOmXl2Dlgv8Mu404gxCUTUT7aE2EKqwRepZevu?=
 =?us-ascii?Q?jR+i/pNjsqxrrQm0z4PgaeDYWsG1G4TSB7zMzZJyDQQ5pU7GandSKp4QkufI?=
 =?us-ascii?Q?7TAWPJWj07w+sTpFWrM5JwOrmHNAcSVp3ENIvDVTxETn348u2QPIy7R7GutY?=
 =?us-ascii?Q?OuTBo33qnmhEfAXzpQEhSLsNg8lz03ZrvdAaVMIjSco+SK+5VvwudeZoCN0M?=
 =?us-ascii?Q?j4FpExHjB14XO5/zxiX7tFsmbh5aBjiYrBph7XalEa2EUBfTXlkDIhBZ687x?=
 =?us-ascii?Q?B4HhForhMvvMa/Y37QSgHkCM7RKIkWeO3BqKa/X3HeMeWY2tdVx3YK7bmIcO?=
 =?us-ascii?Q?/lIzzkSGnqEWD9zifBEuFUkm3MWg2eKBCyAQ3Aqb8TJspLIfAGrMBxR4lYha?=
 =?us-ascii?Q?/5yrCG4SGZRbVizAsraPgIOn7RAI35U3aE3hf0m6hFpo8dLoOXxWnDAaIrhV?=
 =?us-ascii?Q?eb0LmB9bfJGyRk7AXF2gPiQsrlzYnQlVWzqW6jVHugL0/mpziqvL2tmJYMKW?=
 =?us-ascii?Q?wC0qHzK8mkdcAOqpXmXn3G0AHt0BiXD3IO5htPjIuKF3tDy1dFs3zwJGQnbs?=
 =?us-ascii?Q?GbHVCNy5Kqg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jn4IZAeYtRtZ4dsqQLRvtrvpE+eOsptVPvwxUZ1MzMxK8WD0kUBSMUEvK7Vw?=
 =?us-ascii?Q?LrbV55jmfvVUVVqASB4TIOl/bPYLHRTJGR/dX1yPFNs8jEdv+Ef0lVQTWa5h?=
 =?us-ascii?Q?coMehhRdZLePS4FlbO3JscKtdtP7g1ecSqqKH+RGVjpUF8xXEKRnl896SJue?=
 =?us-ascii?Q?A/uGRjveM9NIgcx7I60ODrYm8xGLMRFkNet/qK78Dvq7GqfHvNS1fEb4+FXn?=
 =?us-ascii?Q?1h7UPM5dss7moGEMwSA7agq32t0ulUJjcGV9pNGX9SKeZnKj+pFH14wyF3Zs?=
 =?us-ascii?Q?ZVz6Z2AkXZvSJ38IVpdiADfudFgqffHr/XKh8uN3CmAqYI9VhiPMF5lL6haM?=
 =?us-ascii?Q?4ApPYFwOl5dDEL75+USoTBBVd7vI52dKfRybF6uG5ZSXbMnnwswNZuVKRalI?=
 =?us-ascii?Q?jgM6azZ9yB4qN9xaERW6b6NXWkKWYyHjf4jx1nL+K1QCLYDYgdaV5l0iFBdb?=
 =?us-ascii?Q?rN2Ub73Ct10eAWakMcfcX/+AzA4acViQsQIfYJrc8UCP0EB5RYLfqqYAlt3q?=
 =?us-ascii?Q?N9x52WcWPLc1xfh+Br3eTRHfu8NqHiNfM5gAmYiqUYnMUpoGn9BCVcsqSz6J?=
 =?us-ascii?Q?u3nmhlBmcd43xmwPnyxGdYD4DxzKT3bUZ/J07ag47HB+UKQajd/jHCLxaDsB?=
 =?us-ascii?Q?d4YvAmvBgxUormdBlpM7e+DDyiYFhnJ0MQm+u/7BrjeT7qL6Eal97ogvG4pz?=
 =?us-ascii?Q?cJHC8PlGgLGpjhbc1+NcXNQoPdj6gKupq3/WQAl5FCxQ64PqQx+YJIU9WfwP?=
 =?us-ascii?Q?C8Vnf/KwH1O9wTpZ2DnUpY/iaImI03O3iwCd+8pEwsHIWoMyFQ3wzJ5eOWMQ?=
 =?us-ascii?Q?+fxgiwM20K6uq4HaNbx66zHvUPBVOQKQUdxmNkRW4NT+kIKcntotaCeC0sRG?=
 =?us-ascii?Q?GEzRX7poiOYFq970FgOhMi0A8f8tY3YdRijMjrzptI76ayHGvqw6zPMt1fL+?=
 =?us-ascii?Q?KgxZ3laD0uTKIZL6DYqukc4/gQpdymZuznF/FQ6E4x6A9VvguK+Mr8JRZyzU?=
 =?us-ascii?Q?Ot3gnFAKRzkfVozw2KzwTH2JCwE0AwEqXk1VrilBUVntOZz/SXhQZvATyUr4?=
 =?us-ascii?Q?zKpobabdLiQ1CKsPJbG2cfitHqT/1jmIldAKclBlrg8qJKH2LszOYdnzT3Ip?=
 =?us-ascii?Q?IkCqkYIEfUbAw6XkUXKN/g+hS7FIcW+AddYKwOBlvBClcAhghozQLEyD7og5?=
 =?us-ascii?Q?ceaTMVi1C/OCQq/2+4+o+YjxFQetxesetcUPj52W9ayiX43vl40fZuFfX2Yi?=
 =?us-ascii?Q?2oCueb9q3gzVi5JH0ZSRCkmduew35hEyaAHONfm6t/izPLOFUv6HhfD78Yuo?=
 =?us-ascii?Q?JYiMV/rCNTUyvpuxm2xSS/LE9rfo2hEnDy8Fd8bgl8OT6PqDs6p7224QepBV?=
 =?us-ascii?Q?SfNuLzU8Hwh/wExUYv+Hr1wbX0HBgYXPwGQQpnDCjy1QbYmXXUE+dgW/oQvd?=
 =?us-ascii?Q?tD9EGAMn/FXj+YEWkpDTYTmgoD82rGOXLGuP20dhWjA/J202qnTLwkNUQSr8?=
 =?us-ascii?Q?QWpOzI6SBT2i5fycyXYJylGnpOmWwdQv80o3qdLDEkYJkU+2mSuL6uUEt9kN?=
 =?us-ascii?Q?Ha762vdPLKzuuCV7tvIEIKkAijtumxAREt3BTnIq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7DbuYxR6/6lDWkxlqnaUsIY1ucLEJ7maYl7p83yU3YG5u0hE7LxigKmUlNcB+1Wd1IArbvpavjcS3KJhmSDmKYbvgvEDDjOY7PLTL/0mPa3WmZiCy73ZfjDplFkdZaVyySssak9cTuuWD6S9F0dINL6+/Yi0RcbAtZcoVVHm2cFvmZ11Q8M/TMHiNRq+C4eB6JmDb+xhHeJ686zJao1bEYltJHUksb8ib9NdYeTjsBGMyrteSWCNKyh5SrsdwPNeEPKZOzsQa25fqEucfAN3iFk3MH6RCAWR9T3in7zt5wZ/2X7iYCwtaryZsMYVgrXt7k9z0kh9qCt8qWmJtbvlbuvSZ/W66yHQ/DgeXIPkyQ/0fMCKIvL/uJBUUgFT4qahLZxMWmk5aIfDrCFHHwMgg+M/msZpJQafkxqcFmtLCy1KtUJH8cN+G75G36p8wjiyyBEfJ/QCfZzD20oteckDbW/d77m5yMM06B1UFaVuVodFLA5IxH1xylU6Vp8fZBRqRVkpIgqKCHOFKquNlwYhzfebfHZPL89JH8sxkaRDxQ+ef3g8ULhcgEY0tb46VOzXsIsjQw86Pt2n0v341BQLmT5vgq1LKkBFtfuJJYnCiUE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c66c7c-beec-44cc-646a-08ddf1e6a059
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 10:24:59.2978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j98RFHwGY1xPudSLsR+QuyN9YMlzg+9cgl7wtpkhASF3WA4IrxZ0H3VXoPKEqlrIuaP1fB/vs+N1KvAlXpH+6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_03,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=793 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120098
X-Proofpoint-GUID: 1nYNRSw6WIxbvE8xRrwSMHOYobqoi_qu
X-Proofpoint-ORIG-GUID: 1nYNRSw6WIxbvE8xRrwSMHOYobqoi_qu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfXwd6R3/1WZFaM
 wAOdOnjA0B7nzBdWyVKMLQEYTuLckHmXsUr6iiuEfEj5LBUi1PmdX65hclB8Z1VwvSpCR4XQwYT
 8MWZFWZ774368G5r15FNPmp9GpfbXPPctTt0/tyL/vJrNW2hA22N++9PEfUkE7IVhvmFnuOusDT
 LKZO/qCaMFWiD+DPzYZXPbdAcD6VNNn7LqEduxngq5Ju3DTLvbLUAlmwAOWedMdtcgfqH0CgBRZ
 9Tq1DkzOyjuoZ3Q8O26xf4s+YV3LqLvJCtpl99TJo/k7CPgWeVPKuwY97xcV3GP+1D9DnEKsS8x
 U4tORmuF/JKlZQGSLAF2sA3PbohTUFfZ3o3IgivWJYqBcAfW37MIekyEzJr9syEmBTm6y28f/A0
 uvkkmVbd
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c3f4ff cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=d3c0fo04SkBpMT8-iEwA:9
 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: BC01340015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 81hq4xihj5wuiqnjkaqeotdfhjzmsgey
X-HE-Tag: 1757672707-780677
X-HE-Meta: U2FsdGVkX1/qTsTEsmSake7r1xqXe19CgLgTPlTfWHfx1AMp5Dc3TFOpiWcrGeViy3xHYTx+PLawtLwn7UHa0MkloMMFyYQHJtqIG5lJ3bUojpzQaDuJewOr2Rgxn4yOe0BSLWdQZBMEC9U/QCuf5VFv8QWmIic6jamYN3W6b6Tb+Ifq2TS9lmLDkpPcl0TFjFS8JD0ut12rSKbJoFDQLid4mhfu2a2XK0UW9xRR10ywtE7Cs7md/kD72FTfgAI+MfEuXKYeckglBZ82NSRlTBq4PXHyO99FavNBODQMu4drtnwY8pWIOJr31gPZ8vWVLPBucaSw0znrqeYjZnA6wP0QU30LGVHGcOvzs4xsqRDvhYjXhY7oA6UM+O81sphj6k7o38ofN1DEzrDDVyyCS9DZ0n69BSTGRhsWV9NU+UQyOikSu7SS5UKdVBPgyLzjFbZ/sq7m5zsFEbn0qDbPY0eUbOASztCcMMUuvrTwj6GEVnSgFHrzzmaBrg2iaGDby9ZD//JYLPE7nGHjpqMf/lf/XKrBy3DK/nL7lLnhrgVk2cxx5F/LzSzfejHtXHd1OdhmFwq/xDmezMc2fshkBhfjO0VwEUehQM5YePxgJCPrRmrVFidOlORYThVwJbbYXXEKzGyMDR/exWb8WIq/YcPnQcF+ta+ysI3b8bXJr5UWmm3+T1sZeLe9xI8hwhFlBfFcx79Z9Oy+3ObBg2vdw0ZuA5CIqBnVYIwfHyIJOr3lX/MjK3V0o6VE4d5lqdcesT11a+rAjcx3Xgxvrlt8xF+YS0BzgdiCekWjTS3enJkMEOq5IptNVJel7yHAg7rivCCLcGTXoZSU3A+2xMDJbEQetJW8aHr+EiL4frvdm4B3jDBGkqCtUTQj4TYN9jhYKX/H5gdVl+wCXSBeziIbFazwfXB8vPjVEl9ptyBoNUzZ/nNv+3nBPIPwBrkLO1RNC0t0md/20vA8oLmI50b
 XZlewEBY
 H/fGMISBMTkhbYwEJCN6Ef6GQwzyKNcrpEQN1Hievk8nnRRlgbl7VNqWQ0dTM9KV8fO3MCdpkBYdmBoNCnkjTzdh9ubkFSNMMvHo6NC3l3tLJFWJh6/Bs9VgzKK72Uo3NJyD4BACi2jATe+qVp8uoMklXiBNn6kv9oRmBo+8bbZUYu4xubmxoGWJwQU5h0+tK67hKHneq8EZjmOd8hODeMftrrPAyEKPeZQ3104taa02yenmUAs1WpYsy6IbY5ILx5k+rdRKmt718AASKktPDJnHWV9kOETtIZWCbr2KRDSHPnAgDy9d08INHh5kNvgRTGe/JVX94mGkR6lR3UYZ5DkfXUDorYTYJRkwIpM58H42AycbKgfrXyui6A5DNceEtH8g1+kcaPPqr4CbdBntVD6f4fcw7DeWk1LwhmLIRbzf4sr4NiZ+vawlmR94syEb3p2fDac+ocBqgT+EInSHSGcvmwzlheSa3812419nkQLpCGEWckDdyBDrcVhGVJX/g48wEYrtSTsp1V5VQb1PBqBL0suOfq/DWKduPdJGPRKh3GljgmlMaHC0OWfBOox5UCkYbt2RvwtBDqgtt7AsSlyo4gClMkUZsPENfkYkGzvPBN/H6pymLwk5uEOoxC4uXrclp05gtoQbDkLZYDYHMu6//l3uYjnkpmPOGlj1jGwRSWqCZ71x1fFnjQP6Ii9yr4cu8rRm9hrvfFtpdJNm9ULeGtaldtPs1RXYN9n4GTYveKZw0bkTeYuB5LJiLS7W05kSGpxt7KVszpb1KfUQHp0SzpYpcmRbLTC/c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:02:36PM +0200, Vlastimil Babka wrote:
> We will want to do the validation earlier in some callers or remove it
> completely, so extract it from check_slab() first. No functional change.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 25 ++++++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)
> 

-- 
Cheers,
Harry / Hyeonggon

