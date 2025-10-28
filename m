Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6264ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 19:00:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C70801B3; Tue, 28 Oct 2025 15:00:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD1280199; Tue, 28 Oct 2025 15:00:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C478801B3; Tue, 28 Oct 2025 15:00:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 414F180199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:00:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF79512AC97
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:00:08 +0000 (UTC)
X-FDA: 84048438096.06.297CF48
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5ADEF40009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:00:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dXlmrmbT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ASh+90rK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761678005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/27a6cDSIq89UiNiQ27Lo7Pv2RvZE+2pIXst16y0d6Q=;
	b=o2D26Yl/V2QaswLpJC8Q08uBs1eB7wXA33h9qDkDtPjFB9gOEkx+Bkm9mIx5Yz0tZyetnu
	kHDlOGjccxqzI2tLLSMUlRFi9q2bmbqGHgiwyAGGEhVk6z/+ZMmpZGHquVUpjT5NdmMUAn
	BMTIAr/8ARCEReNQRpbzIHD4ZNZvLzM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761678005; a=rsa-sha256;
	cv=pass;
	b=CuqYbkAQtuuBH64EQIZdx9SGr66fk4FY/arrzrAnwVNeTRqWkaKJJ3S3ueUUEoWEnGA/P3
	MNXu+kdyu88VGfIwOcE9molKf3N/Vzpjigxkxv3zdnVY7xiJnzF6D+ckWSKYWaibSs/wxt
	DU9wQxrC5srnXHwPvmXhL0wvGBeEudM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dXlmrmbT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ASh+90rK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHecWq015518;
	Tue, 28 Oct 2025 18:59:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/27a6cDSIq89UiNiQ2
	7Lo7Pv2RvZE+2pIXst16y0d6Q=; b=dXlmrmbTFqwxEDuMETgPco+s0MVGgQZZWw
	YX0XPqAx0dQPojy8rwCDnwIuOUrJ9yRH5b1FUC/mwyg+HF/XI0Bsu8qni2upeYo0
	5z3CI7gY8T0dfQQyg1ykpSjNnZUZcL6b44AChMr1i1nn+4LJQeBWQ7zTbZTMUlkI
	bZSMLGusDwt/1A3Al4mOXUX+6Fi4NbpMg92CYAp3y6fJrDNSzRoDxdSXPiXdIfri
	7+1XgeLqf9c2PpwQYh+b9YQGMwPo0Psi5So1itYH2YQPQQ9ynjXhxBWBRNNK2YZD
	ZHs/bwvdAWXIouGmPZUZWW1pB4YWt50xhp89WFYTf47PZVsiZMQw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a0n4yq2jt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 18:59:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SHqtPr037435;
	Tue, 28 Oct 2025 18:59:40 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a0n08mm04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 18:59:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGb4tO3kGAVB87RQlwgeg8LkiGWHUIjv9iUZacKHYRzIa1/5VLUpq1Wbjnb+xu1HQP4SH5q0/eNOWq0F5YLRt1EvmmtBu8ZqjLYqM1Ju91I+QizUK24rjV11AmvcMvIBhodV6smZoeFMyfb2c5leG9IfwwvDQAKNzmbHJ0DJhHoNZvrou+9kwMq7k6Atd8/mh1Aud6ZQNjdnDjvh9F/U/1Nh29Mcuh0LXPiKCVJdSYHnxl+z/A3SP944JcMwOoRBL1eprfx4t+nDJNrkPgJkPbOTd9miFDj18JigIqU1RHsokpMZL7pzzI1EkkAiMQOoUWY9lkychcp5N6P/icijRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/27a6cDSIq89UiNiQ27Lo7Pv2RvZE+2pIXst16y0d6Q=;
 b=BLk/UELahnTE4k8MwQdpWWMSSNkf6kz+G9fUa2/5lrBJukFUOitNXlSrKvgxis6a4kNw8USflmsj8FU1YgJrCO0iXQcVLqZJJfpx4mIX2rzAcxCIap4bU5qYOEjJZpukB9l1vBtX/tvsSNmQEOrWMlpcNo5HDlstFtO1v3Zti0CwcjI3f0TSDUTefiPROaJbeIYxI6+tnU25nSwvVcwAN1Z1/C8tV4otCFK3TEkkKgNfMl0SdkQid6suAuGaoDiei5gI402yBfyDNwENL6PIwY2OlRqcMiQBRl+3xcVzt65N8zWV1r77jb9fMlgZjV9nw2SNYdJ3JpjEsn8huY5XHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/27a6cDSIq89UiNiQ27Lo7Pv2RvZE+2pIXst16y0d6Q=;
 b=ASh+90rKfqwgR7h4dDm+jjuhTjASCIYnWPZoDnwLgmvHdmaj7tVHxGXH+vlUhECeUECKwjye93g0dOJ8gOoDpjBgTW9+BNxSRGgsDp65dgX319VQytRXBHJPpwiqExwqUCl/75i1cBpiC5FuJILj22zM7rLXVfO5F0kq6KeJ1Eo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB6889.namprd10.prod.outlook.com (2603:10b6:208:433::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Tue, 28 Oct
 2025 18:59:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 18:59:34 +0000
Date: Tue, 28 Oct 2025 18:59:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <3dc6b17f-a3e0-4b2c-9348-c75257b0e7f6@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
 <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
 <e66b671f-c6df-48c1-8045-903631a8eb85@lucifer.local>
 <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74583699-bd9e-496c-904c-ce6a8e1b42d9@redhat.com>
X-ClientProxiedBy: LO2P265CA0311.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 10f06630-bf36-4483-93a6-08de1654220f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?815DI1ItGHAhmH+4cjkw/8okrtnan7qJbanDYIzg0y80SREr6+CxapwxfH+m?=
 =?us-ascii?Q?Z1zXFs3XpmhHb9+hrXhGzCYLaqAHYgXuWP8FWKWoRBMdNo6APgP9Hzw9XMWd?=
 =?us-ascii?Q?6GQBTtwhjCcfFbDQOjeyRnQmktX1AFjwIWxacSs/CaERgDngOoyVFzWMiF9y?=
 =?us-ascii?Q?IgCZhK3TgkZP5iknzjcNoSCwdpzwvKUXO97SsDoi3FH2NuKBmWNQgFrUM4tg?=
 =?us-ascii?Q?LnfX+BofC5Ap4XMVZ9iBFh7j0QFb4AZrYaNw6iB1BYI7yaS1B2rFLj6AHDwZ?=
 =?us-ascii?Q?CZi81NEYs4S3XPTzIgkHbotd4AN17LrCi0G+XTPhXe+Oz2sq6MXNLoccMoAl?=
 =?us-ascii?Q?lgcCohf005E5N7kMlWUoFt5+jyC8wyeaaZkULpkkUpHhJc+mmRArjX3U+/mm?=
 =?us-ascii?Q?ecSpVrbzp6tf1gBd67kyvBWJfIuMMzIqqSSFSU0z7kN5KiHddX2a1/teHeRf?=
 =?us-ascii?Q?we+IbIBquPI0Ag4tn4/AeA6Vfd6MF0avbXJVGsiHod5oqfhhZ+2S4sHoOuqc?=
 =?us-ascii?Q?J5Wmd6N875fCKAt55RaZ7ELDKpKDKRlC7vzHEbBqqkKp5WFjvEeygbzhjpON?=
 =?us-ascii?Q?3KGamn9L7XdiiTACdsiHjbgm3RmLe5phxalSI5OLItGTUp3cKLxb78GQdCTm?=
 =?us-ascii?Q?EUQ6iorn3euZi8xA1RcVVpJpLKBl5Rpx13DjNnk8yrjRc7zi62aY50qRkEOT?=
 =?us-ascii?Q?nUAXERas7vB5JTfiXIgd3Knx//OpL7Ko28aJl9JMCp74lXPRuceSSzv3/8x1?=
 =?us-ascii?Q?g/X9x6R3Y6JeQ4BWggKXsq6GY5yr1ZnyGj+L5oJoWsQ0+6/FvnfjD2LGzmkI?=
 =?us-ascii?Q?GADVPjHCZMVqQmPXtctHJ/hURTqoLkzf7W9JXyiNqKPYuJDvqPerKBSnn5V/?=
 =?us-ascii?Q?x4mXKEpx3Qo0RlQxUpGvXN+VnJbPPitQugL7GG1KrFUgGOsSo4VV5N2P+Baa?=
 =?us-ascii?Q?xXV+Rzkhqra7QppscSmfDeEvOKHUnp9CoB7Lb+A+kFfVwNY2Ko1ujXoXL1eI?=
 =?us-ascii?Q?aBXkPdDF23bCY/WMxDB/7BBZnuoPI91BsyYrGKCz6SXwIA5jYlyqnAmE8oNO?=
 =?us-ascii?Q?FL0Y0+Vtfryzak54oODPhtZ05TvQlrEV8/TfbqniPEI/syxkh5xWb2ECh1iA?=
 =?us-ascii?Q?SiXBV3Ct/FK1d2eqNGspzkDxcwKnQXvsVeLG478HV4sguMq3VrEyg5+qs4N4?=
 =?us-ascii?Q?9mLhpHGzms1gHSi9Wp85VCQcv1xXvTOhnrL7N3bCKvJWS4o0sBm6Wo6W7agF?=
 =?us-ascii?Q?Jw3pu2SfYyCG0dY8oqvQ8ewlwgxBFZppGVjTA/9Jqs1ZWS/Gbq7zJeo35R4I?=
 =?us-ascii?Q?jJODrV0XTJo+lzKddY0jcRdDgHuMSv3gv33C4hDa1ma3WPbCij/paUNm5kQS?=
 =?us-ascii?Q?v5cr+BM/t+RSmfFGkwZTmoItNjXLl5yXYPkc+EqULcFwAAb2pmBobpXOEwz7?=
 =?us-ascii?Q?V9ml79JwX11lE3yEQ1bNHqvnwK7Ivytb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dR3jelqkENANnK7G0SZSr0HKRwEnrxXImsjGc80OXmfdEEKZs7lMjMoJxTxN?=
 =?us-ascii?Q?ltho1P9eLAIwEBPEBhMuekHK0u5qjFr3xgCaUorJ2QPx5kVMwvtgIHOibvdy?=
 =?us-ascii?Q?bI1jI+QIO2+faN+Jm//2hYGUChbk+jOjJT/xYB3om/Zyz1Ex+ra8627fKtsw?=
 =?us-ascii?Q?fp1V991lWrWepqgF+VOhg/M0dtjI8qMDIQFeucdRG3Ia8IVgEBe4qRLZyELW?=
 =?us-ascii?Q?8fGFFJvaGsiTJDg9mjTF7EWvIVvR16tZUrjwTDKOej0Wkth6h6dxKD6jMQYx?=
 =?us-ascii?Q?T1+ZJnZ3KAfhM9cYxyzEn2dlcZw1xiQXTlGh54jFPy2fB4r9QHNsvUe9BBnW?=
 =?us-ascii?Q?Ba5/cU0jIwM3AmJNX4imS20TE4oCexC/lqKelbD3Y9EdX0T2wWu9umy1FelJ?=
 =?us-ascii?Q?aLzkWKoavOak9+wSxmzVrJTCXCfD30xZ5LJV7/mYNtBN5gD8NOeTKNM5BVBk?=
 =?us-ascii?Q?AxnflB4sxUiELIxBuArjxu4w97kg5hIy1gHJxda6vX3X1mDJAISSqDbbx6R6?=
 =?us-ascii?Q?r2d6ZNE7bFDBUjDXDeZplMH/T5Rl1F4WV5Vvwt126cTz8Yra313WCuDCzaiN?=
 =?us-ascii?Q?HjJku1ekERtqPIswNO6OZuSu6IZSgqEVb9hoeK927VZWcnsza2KfUIbtxJEx?=
 =?us-ascii?Q?nBuqLghy9k39BOI+wd8LF7XSg2A22DtqkTpbtBYHScUDDbJM7nyAuSA8Iw44?=
 =?us-ascii?Q?Knab1rndunm8tBTb/uvPmLTQnzqoRrXcA6NKiXXkdSNEWFCn64ds3negAMUd?=
 =?us-ascii?Q?2mVLLN0kfoyiIjJnRxUFC+VEVHUlMM5UTUOsyw8Put8JTYuxXQs3jHBBOsp+?=
 =?us-ascii?Q?7fPlsY6ECzwQE6bDenPnJ/gIUp/NDfCk6DAxXCB2+8KNDx7umln4qQhZhx+y?=
 =?us-ascii?Q?DrpoqeLrMKOAybNeiTh7Ni2taVDuH5AN59+zMQN2pGm15RcA9iBcR+KdNkCt?=
 =?us-ascii?Q?kOSJuOGr1PNviDHBVwE8ZyMeng2itmYTiAl84xJYqiZOZ6N5UNNLXvvApCIj?=
 =?us-ascii?Q?Mc9tdXjPXQMLB2vHmZuBtIEMxkazfhuxmskosxmAwnNEoY9ovUS1hK0X24zK?=
 =?us-ascii?Q?K6zSd9OpWyQtV8LU9NK/W43NTHRWgkXMRtTH4JOVQYTlcAs0SJdbmGFJomVV?=
 =?us-ascii?Q?iFjcdrUbVoTttfH3kfMAmikiKAwqkMqASyKvYStiNMYnYgzjvSi4Fu8rB3y/?=
 =?us-ascii?Q?aQ5JIyq4dHo4KgTPiOAf5jfnm8k0G77EbgnhWZkcZop+WyNHs5ZLqzHRHaIF?=
 =?us-ascii?Q?G/khPYGo2wdhlMxIeif7uY8cM4WxfPfQsjypCtWdI7GddQASzxW21j/0HHf0?=
 =?us-ascii?Q?LvrRpmO0dpSeiQNffKBS2jYNq/ecdQbPDutnrO7MQdnoRnHks//CMgeElvxL?=
 =?us-ascii?Q?XhpJp89pAYppK7/P28WnR2MBQPLeuVkHZuxoDr+9uAxZfKqDk5qryqPFtm3K?=
 =?us-ascii?Q?AhvfWH87JHuDwh+985A+Pb5ng1kQ4LEBjqtpjliern1LyehxuFGvHyu6swH/?=
 =?us-ascii?Q?wCfGNNiNFC1aPVXRf1g4x5SCTvUHyyHfUWjfKZQsJhkHZDVi+lH4586uCowT?=
 =?us-ascii?Q?cyBUeY5IJ6ETB+B7XqHgZuMVQiJCN/eXRZ7/zLcojmM1a7Z/nu5mH07415gr?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ph/p25nL1klXqLHyQJcfD+deNqb5Ce2G0nhg/mXIQDZr1E+8upzCT9EBABY5EdIWEhKeiyTAgQXnGzPQYUFAUpVZsC77RvLlmIp+/Jff0ZivIJ+AjvjROlsobOSTCIYrM/I42+4o1XsdjauQidweeR9v4K2tzbsWyLUHtUv5FQtBmhit9M0hCi0Bdt//wlp2VGVCvfOOzgKKaYScyePUvT9gJjUo3HQZYhQZlFpEqfpdmTYLdsoqQBypNG6guzemQPxPPcOUGsNZ5QtS2ZPZJA4SsHYeHPsUsQbGMZ1Zxovj+wl9kKneetiTE1TW9sH+ZvkImd764eucL57dcRuglWBsqwWVtC4tMSbnVGJcWKL3Zi3J/Ks9flaCAwvIHDE8NnAWR+KCdGhsn8mlUlQPc3ZoPDWRaMONNb33naXe5NweDs8Y5y6POezIjYwfaQuoW+OZkrGmFTTveHOzHBQm26elldd25fuYXXpMe2/LfYf+QIrVLYO70KSJj+ITXS2wIP5JJnYkF9gHA5f6w20KxtL4ff2MurphNolSJDhbWqDsfoF1pQ41ryTUBUGxbr0VMnMUB9nCwTjcY3Rk2KMHPHtMazUHmmAxF1iGG9u4HSE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f06630-bf36-4483-93a6-08de1654220f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 18:59:33.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 694rZ74ynLjiqXCAYYawCdE8fVqYd8xvxrPVHU/899WPZt/O9yu0+Xa2Gcni/EfoHUC//XpgKye7MBsYN0Jjh3YNscpGh9ZkVoVLszpjzjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6889
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAxMyBTYWx0ZWRfX/0//m80uwbup
 Pi/+sWgRRbX/Rm0r0yV4D4mWTAKQszdLo3BUWrgP0VnNQNHw+lIICdJq+u1cDIbjawD1MJ4xPWG
 UZMrGPWDTvyBl1Vh5d3rtUDMkl8JTwgBO0h4BzwCKK0fTIGudvnI4qnf5bJBsBN89R3f2FNe7mc
 d4vaHs8nUXA1brydH85w3mtOtNyp6Io/ZV/owZljHFXzInnzTlqvBsF+Myo9zC/zaxlVjpV3UYc
 35L3vKVSao8cGwLb1id9jHTq7uOtDCAavzAgyf0ul84UeJjkpYT39B7BnycA6bHyJXqrR0BCiX0
 NFW5FyKetbyYM40X/0+7RYlUHCxk3pTfFuTrad1tXTID2JD73/jVS0M8mmBBzojcZpMoMD9v1uj
 8UTUCw4J6UVjmNwE7CTdD2vBNiIm0g==
X-Authority-Analysis: v=2.4 cv=Z9vh3XRA c=1 sm=1 tr=0 ts=6901129d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=lm_c3_3Ww6B06y51cfgA:9 a=CjuIK1q_8ugA:10 a=UhEZJTgQB8St2RibIkdl:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: ScB-zABZ6c2PmpD_fO9reB0nWc9wU9Ow
X-Proofpoint-GUID: ScB-zABZ6c2PmpD_fO9reB0nWc9wU9Ow
X-Rspamd-Server: rspam05
X-Stat-Signature: 6moiujk9d8hmjijh7ruh8x6frnfhwtqu
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ADEF40009
X-HE-Tag: 1761678005-553958
X-HE-Meta: U2FsdGVkX1/zmOPTIp6xiSej2PRkpo/VDImXpH5IxH2HBXh1vBSzbb6PTi67TDmE+gQCQnWNaJoH+aMQ70KSgt4jw9cC43KDiTq8fQaSzTsAvl+dLHzZSyMLWRRGnn7gwKk5PTFFpEn5yTvPLlTXrHOBHgU4vdqMSmMbMnIfMZgqYA99balmnQ9bhKaLEUvxF/zv2/YbTnml/cftrw87nOt/BRki5AskAJDIpoV8c8kZstjyw4GJ6KlahLg5gt534hGCeZIl6nPmcQaBZJyEU1VhiDC72H3BwpTOeere9CEE7yKcOaRa9h8mGhU6+09hO5aq4kSiCgBhhZz6fuNNyRMGpb6CvLAnDE65pGYPxyYCcete72xbBMyIsXq4ap8F7uFopWu+4cBj/YyFXhKqUp7TQrou0msHqik2tysZZoe0wOQVNOh8/v9PGPNh0cGlNluQrFFU2TxuyJ58/Aeq9rFd8AEBRPkw8ndY6VN/d8Z+e9BP3ZaGX0RR+ECktTU9KH8Dqr6Rxzl/ft07z++/ShGU8xDkMN79mhshx93BAvW3us8mDdgko9IgTT4zBHi1ripAb/Sc/9sMdpkvXOwm3YbC2Phb6WeW1RxWKTgsL4fS1VCGAvZAle/SH4KIRwS35r4fR8ANDPLXs8GlF9GCbUmdd6py5SdtrpNeBAGgYnkTl/ZcK1GHQPoaTEsYYIR4SoHDZ1T9BCasMBcDY4Oa0VKKOQ9iLglzTUo5n5kBct8uzO4wl5dwTVPAF8sBALlo3whoGPX4Y/3qnghfZBbA7XWM8ibyJM4HMG50Lf9NWO6J1y1HCb8hiuaji0c/zYwy+qIKQeXe9QJAFD0O72uS/lbtsVMuBhCx7HnLZhuHP6N/NUFXn946D/slJb58THudDhnvR/GdH1SUWXDtTcX7ZqeUkN6iboWoK5Icz6uHsE7xqnyoPU9wALrBNR5KqXgEMaWAXbdGCzAxQEmu/l/
 W9+F8lzQ
 v/0F+3zB4/7xY7H9m2/gaduR6C5bsiPQEd+WhdLM+D500PL3ana5k4gpRM/3bJjUunRPpuLtpndT395ULUgXEbfBEnGxQUk7u6OGZ7IgUr48QYQO3a8E5JSf7eTWrEh4MCTJz/2oPxxxthcwTXClVrmPjpGPrQAgDlkbSBEiGdmUbsUpkvXNvZze/3l1ZAgPseiCi38GUukvXDqIjNwJQ4l90KA1WJcFj2AFJRcaTjWe9NbnRqvhhJTFMI6B1VmQ5cIRPwX3dL7i2wJc2jiCngmK+FV+wJR2CZtUgy3peeGxtsiPfgVKBPumTHp/A5m+aPXLvyzfdfA/mpRBc1o1bTY2c2dtbffJBqs9Ok8A+bcCjJWSig2mTVO4xUr2kqfA1YaUwCSx53/RgIpp9noyiD0cP3j2w6a77ZWLwe8Wydq1NRsxjbbkCJxsNkDVzYAeRoKC5kMLJCZpAPVAiPUvm154FD+VSaegg9vb0Aja4t+P2GGBQfAJmn0qco7wHxPpQak8aJjxlq9Qh5NAdJBtoFnk0BqVZCct6Y63zymxOkUQa/E2hqakJYaZbun/KvL3ETHbMDF8PsP8gJsptXP8oVDlBRLXQXgRg4Um2OF3y35amKLDRbTC3xWOSk+ZxvtbY5Txiic9vyK5p36KWBCl9x+Kq6tBBMZBHtsp7LF2upxPx9UQKuEHle/eZXkzIxY/xmmXTUo8Sqz3y6MY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 07:08:38PM +0100, David Hildenbrand wrote:
>
> > > > Hey Lorenzo,
> > > >
> > > > > I mean not to beat a dead horse re: v11 commentary, but I thought we were going
> > > > > to implement David's idea re: the new 'eagerness' tunable, and again we're now just
> > > > > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> > > >
> > > > I spoke to David and he said to continue forward with this series; the
> > > > "eagerness" tunable will take some time, and may require further
> > > > considerations/discussion.
> > >
> > > Right, after talking to Johannes it got clearer that what we envisioned with
> >
> > I'm not sure that you meant to say go ahead with the series as-is with this
> > silent capping?
>
> No, "go ahead" as in "let's find some way forward that works for all and is
> not too crazy".

Right we clearly needed to discuss that further at the time but that's moot now,
we're figuring it out now :)

>
> [...]
>
> > > "eagerness" would not be like swappiness, and we will really have to be
> > > careful here. I don't know yet when I will have time to look into that.
> >
> > I guess I missed this part of the converastion, what do you mean?
>
> Johannes raised issues with that on the list and afterwards we had an
> offline discussion about some of the details and why something unpredictable
> is not good.

Could we get these details on-list so we can discuss them? This doesn't have to
be urgent, but I would like to have a say in this or at least be part of the
converastion please.

>
> >
> > The whole concept is that we have a paramaeter whose value is _abstracted_ and
> > which we control what it means.
> >
> > I'm not sure exactly why that would now be problematic? The fundamental concept
> > seems sound no? Last I remember of the conversation this was the case.
>
> The basic idea was to do something abstracted as swappiness. Turns out
> "swappiness" is really something predictable, not something we can randomly
> change how it behaves under the hood.
>
> So we'd have to find something similar for "eagerness", and that's where it
> stops being easy.

I think we shouldn't be too stuck on

>
> >
> > >
> > > If we want to avoid the implicit capping, I think there are the following
> > > possible approaches
> > >
> > > (1) Tolerate creep for now, maybe warning if the user configures it.
> >
> > I mean this seems a viable option if there is pressure to land this series
> > before we have a viable uAPI for configuring this.
> >
> > A part of me thinks we shouldn't rush series in for that reason though and
> > should require that we have a proper control here.
> >
> > But I guess this approach is the least-worst as it leaves us with the most
> > options moving forwards.
>
> Yes. There is also the alternative of respecting only 0 / 511 for mTHP
> collapse for now as discussed in the other thread.

Yes I guess let's carry that on over there.

I mean this is why I said it's better to try to keep things in one thread :) but
anyway, we've forked and can't be helped now.

To be clear that was a criticism of - email development - not you.

It's _extremely easy_ to have this happen because one thread naturally leads to
a broader discussion of a given topic, whereas another has questions from
somebody else about the same topic, to which people reply and then... you have a
fork and it can't be helped.

I guess I'm saying it'd be good if we could say 'ok let's move this to X'.

But that's also broken in its own way, you can't stop people from replying in
the other thread still and yeah. It's a limitation of this model :)

>
> >
> > > (2) Avoid creep by counting zero-filled pages towards none_or_zero.
> >
> > Would this really make all that much difference?
>
> It solves the creep problem I think, but it's a bit nasty IMHO.

Ah because you'd end up wtih a bunch of zeroed pages from the prior mTHP
collapses, interesting...

Scanning for that does seem a bit nasty though yes...

>
> >
> > > (3) Have separate toggles for each THP size. Doesn't quite solve the
> > >      problem, only shifts it.
> >
> > Yeah I did wonder about this as an alternative solution. But of course it then
> > makes it vague what the parent values means in respect of the individual levels,
> > unless we have an 'inherit' mode there too (possible).
> >
> > It's going to be confusing though as max_ptes_none sits at the root khugepaged/
> > level and I don't think any other parameter from khugepaged/ is exposed at
> > individual page size levels.
> >
> > And of course doing this means we
> >
> > >
> > > Anything else?
> >
> > Err... I mean I'm not sure if you missed it but I suggested an approach in the
> > sub-thread - exposing mthp_max_ptes_none as a _READ-ONLY_ field at:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> >
> > Then we allow the capping, but simply document that we specify what the capped
> > value will be here for mTHP.
>
> I did not have time to read the details on that so far.

OK. It is a bit nasty, yes. The idea is to find something that allows the
capping to work.

>
> It would be one solution forward. I dislike it because I think the whole
> capping is an intermediate thing that can be (and likely must be, when
> considering mTHP underused shrinking I think) solved in the future
> differently. That's why I would prefer adding this only if there is no
> other, simpler, way forward.

Yes I agree that if we could avoid it it'd be great.

Really I proposed this solution on the basis that we were somehow ok with the
capping.

If we can avoid that'd be ideal as it reduces complexity and 'unexpected'
behaviour.

We'll clarify on the other thread, but the 511/0 was compelling to me before as
a simplification, and if we can have a straightforward model of how mTHP
collapse across none/zero page PTEs behaves this is ideal.

The only question is w.r.t. warnings etc. but we can handle details there.

>
> >
> > That struck me as the simplest way of getting this series landed without
> > necessarily violating any future eagerness which:
> >
> > a. Must still support khugepaged/max_ptes_none - we aren't getting away from
> >     this, it's uAPI.
> >
> > b. Surely must want to do different things for mTHP in eagerness, so if we're
> >     exposing some PTE value in max_ptes_none doing so in
> >     khugepaged/mthp_max_ptes_none wouldn't be problematic (note again - it's
> >     readonly so unlike max_ptes_none we don't have to worry about the other
> >     direction).
> >
> > HOWEVER, eagerness might want want to change this behaviour per-mTHP size, in
> > which case perhaps mthp_max_ptes_none would be problematic in that it is some
> > kind of average.
> >
> > Then again we could always revert to putting this parameter as in (3) in that
> > case, ugly but kinda viable.
> >
> > >
> > > IIUC, creep is less of a problem when we have the underused shrinker
> > > enabled: whatever we over-allocated can (unless longterm-pinned etc) get
> > > reclaimed again.
> > >
> > > So maybe having underused-shrinker support for mTHP as well would be a
> > > solution to tackle (1) later?
> >
> > How viable is this in the short term?
>
> I once started looking into it, but it will require quite some work, because
> the lists will essentially include each and every (m)THP in the system ...
> so i think we will need some redesign.

Ack.

This aligns with non-0/511 settings being non-functional for mTHP atm anyway.

>
> >
> > Another possible solution:
> >
> > If mthp_max_ptes_none is not workable, we could have a toggle at, e.g.:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_cap_collapse_none
> >
> > As a simple boolean. If switched on then we document that it caps mTHP as
> > per Nico's suggestion.
> >
> > That way we avoid the 'silent' issue I have with all this and it's an
> > explicit setting.
>
> Right, but it's another toggle I wish we wouldn't need. We could of course
> also make it some compile-time option, but not sure if that's really any
> better.
>
> I'd hope we find an easy way forward that doesn't require new toggles, at
> least for now ...

Right, well I agree if we can make this 0/511 thing work, let's do that.

Toggle are just 'least worst' workarounds on assumption of the need for capping.

>
> --
> Cheers
>
> David / dhildenb
>

Thanks, Lorenzo

