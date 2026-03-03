Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8186E67A8D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D4F6B0089; Tue,  3 Mar 2026 02:25:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFE836B008C; Tue,  3 Mar 2026 02:25:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8F36B0092; Tue,  3 Mar 2026 02:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6CDA6B0089
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:25:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42AAC16068A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:25:58 +0000 (UTC)
X-FDA: 84503917596.01.4F31A46
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 23D42140005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:25:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NF5ASPR7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k+Ygj3Wp;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772522755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4N8DR7QlEgDXuoSkFTFOftvfrvJ8qWZNt1k0QGGLE/A=;
	b=pCpj/3SIrOYYGJz1o5HyBhZhgfz/JHWlCoDAD9kC7LnLMmSrACZN0wt84Wjpp13j9kxRrN
	tIq+s3BxRG1hHP9OHfW1YsIHkPjWkMYICIPq/biNvOgmsllnD0dvHdrV/H68KjqHZUs7gf
	MOpzz1ST1GMwzOdWvOeut3UNnlDUh70=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NF5ASPR7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k+Ygj3Wp;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772522755; a=rsa-sha256;
	cv=pass;
	b=Gzs8h9x7azksqdNJekN6vCCrBHqPu34BoqgVNIQSJttBq5CBDHJDWLblAM5l5ms+P8L35b
	Tngo1fXqGVfCDOfp9Qm7cQiXM3A4KCqRyyG9JIh5eu5V074ZXX0FS6dqIB9H10QpswlwNK
	Pf4li19iX/RiOqS+uqxyETOFfttqX6U=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6235Wl60924969;
	Tue, 3 Mar 2026 07:25:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4N8DR7QlEgDXuoSkFT
	FOftvfrvJ8qWZNt1k0QGGLE/A=; b=NF5ASPR77vj3Ij2yjdNcTaPH5kOBz5kynA
	eQRGQvoPHzN21mdhYPZWo7U36njR/z2sD+KX5uGilRINM3D6rLie3oG+RQATRgrw
	EViJGGeovuf67WZ6z02X9rJ8Up8w6OMzS0vbBuRjThA02u7iGf2Uqkc5lFJclsLY
	lmwcZhAHvTpDCkVQImfBa5f+fTRIJ3aC1AUR7jkORGTXD5DVD/qn6+09uguXSdHQ
	umnVdcUQBnFi/V7yl0whauu4k1+lAT5YEynxGhKfds8aSG1OPu2+nywmAmMTX7lY
	IexdwTPWm+4miiUou6kht3NSrL4HBSflrtKj55itaqZP51WAb17w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnky3rcn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:25:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6237Lo3V023214;
	Tue, 3 Mar 2026 07:25:39 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpte8xmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Mar 2026 07:25:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9ZfE6N+DFhxuur5u2QxIYJb5v/Jj/fmJ6jZkSv9KQD7eEQUEahY1eoCkY2U750gh07r1wkklP9AMGTs23uP40/C/fDx9uASg5jrsKXOCL8nb83SKtIC20vMjdF/Iycc4El4LYiUwfi04ZN2XgLwSwGd2hRxxnI7JAMBlhNhNIejlx5s9WjO30Ad0Mtu7u6Jb7Sp1Pf4KwEj1/GugA9IgsPhMWMvvMFnOsgX858ShtGwEW6L1w354grBIM6Wyx2quhAQ1niKYPVkoS50Bk3AKM5If5hRHRI6XKeLFkDySvMjDYWCPKyHxjE/uo4kx4d8/rKt39tz1WYAwpHWuol45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4N8DR7QlEgDXuoSkFTFOftvfrvJ8qWZNt1k0QGGLE/A=;
 b=wXjM81b1t/rAe57phD24vslk/MrQxEZtFpB+7lVbJm1fLG9n1/2cCFE4OnzeYW8wiC7cdsCAb5EddJjpLzPQwJ0VUDd0Qyp5JPiSgxg+n1lDHRWFxKIXX0hAVT6XDjkKSiCJBh6sDp6IfvIH7p9C2n+0XbKQebbTZr6ZXb2Z3/XpDt6qK2Lw/aSNbkMscV59Sj3BYMufAIr6nS8jxv2gga3odAq2OBssQ8B3LHHevUNVnvVXwLLlmlUrf6Rqhq16NPpOxZIoDO29GKby8C88QxYQeFbxy0P4yQ4u0nyZdIfdA1AmAeTEzU5OySv+oZZzXiFWoOVP5xe1l49WlTVFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N8DR7QlEgDXuoSkFTFOftvfrvJ8qWZNt1k0QGGLE/A=;
 b=k+Ygj3WpDtEbV9YyYNBuaV9CUt7bPTDN+6I6yQYWJgjtrE+zs7HL4l7mZ3BjotTphyuoExSjJPX1gEa/abrxAVa0a7pT/P4OjqhOjcBGGRasrUBL70M9ykFBiim5A78vM0oQTVbR+DCjyy2trEbaD3gTG7G/WhCMH6eMoFXEedM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPFD7011BF84.namprd10.prod.outlook.com (2603:10b6:518:1::7c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Tue, 3 Mar
 2026 07:25:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 07:25:35 +0000
Date: Tue, 3 Mar 2026 07:25:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Matthew Wilcox <willy@infradead.org>,
        Chris Down <chris@chrisdown.name>,
        Suren Baghdasaryan <surenb@google.com>,
        Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-ID: <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
 <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
 <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPFD7011BF84:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e96a706-1b68-4f84-7ffd-08de78f60faf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	qF/VRXNjzQiiCqxL2NxXeRz8qXXjvHsRIfUG1Hj/xRC1u0hZ5IqrCLLGJh4tupal32mT7Z4l/dFQJv96ry1oRSPqFV3gc/7quTeFK+N0ai30/YqkNcvthWpsi8JYTvCxb3scXk7s+7wxrmtQU0gxPsE6k3ZAtrVE08j1ug4k2mBE7ksWXvZG4mLlldwkiV75s+2ITi9fZeTygxYryPR1G95XlAqcLCi5/47CBjNu7pLKavbp4vwKtdy9jqGk82GUwiFQxnxxBsN4U/U0/rgdnOX4UjIE8LHcm5ikpdrzN6XIoHllzWg+rtVGW0S2RRanTNbPOLGH+aLckpvkgvzKxaebid4r2upjkeOAP2APMHGy79G283Jt+Qp/Ym4J9yb1xZNe49Nt4nF4Al4PlTpOHHflADe/tECFXH89fZB326BeqOIwbCNZIui1RO1F7/bqZ/SQCvnamI7C/AhNiNxoCkFs3ZqZDpRkA3vFOGVOGnZaui77enzXiUzQCyDxH+VkvGzXkbloGo2Og6A0iWsH4OSHiKjqsNWHBwBeKRIAJdq7kQWj2bZ5lNH/fnAY6VIFk2if6PhqBM5FEYeyoxm3Ijn6yo0801DdmdSyH9uHwhKjeoe7s8UEHiM6FCWMPUdeJRTuX282hx29u8JgzvoSeGRJBm+7MGDNSJFtSjIFk5bAvNFHjonRaMJv3ZfyNeCc8vOnKqLfzk6pzbI/UqFwCaySuq0YOcXTyuDjc+NPA5BboZP8YdO3IU9n8+kGoJNc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7/mZci18N6yvuh/hgwGSDnElePr2WU1yUpdbtJBKAhu3QZHeOeaqrkVs6Roz?=
 =?us-ascii?Q?6q+asLmBHrd0V7s5UERBFdi2pUoK3K0cuvl8pt9ATfhULdmj5imfh/bwexvX?=
 =?us-ascii?Q?4x2Ca25lce7D55U8eJX1XlBShUfN2O6zyunsYl1R+46XJJHwO0X54QSMNzVj?=
 =?us-ascii?Q?adY0w1mPSqZfH5fbPXUPf/RKvo8Dbud5z/BcPzdmIuuYnMNndH2fhziPlPye?=
 =?us-ascii?Q?yxqJIbqBI0faxD/OVdnphGLyawJgRzlb+mOLyOUU3rvMrZPWnmLmCSa5BH+R?=
 =?us-ascii?Q?jqgys1ZbmMezXufNInFkS6X8N06ulT7xw08vivlQntkvbNO+7MhimvuFkFzU?=
 =?us-ascii?Q?jkWH6vYaKLAo5q1gT4yFGrXEpFVcmzJ53JqrXX5C0atdHh/J8OjZXa1mkQRl?=
 =?us-ascii?Q?0BWdpBcbmmLT+vLLJTFGvXfKH+VA/+brZxWc+k6F0x4uodrhzmyemz/RZe7k?=
 =?us-ascii?Q?RP+gHlwfh/HiRnq+J5AS0lWSgwwbRZAHqWogte55ZStpYhNvsRDdfszfIDds?=
 =?us-ascii?Q?jiVCWEAo7oyD6eB0Tq4gOefVS6vIOZBktGcXuQh5gFajHDXdcyUf3yfBQOvy?=
 =?us-ascii?Q?Hpxqs+zeJ3ZoK2jqCxBmaBwbAqmIg1lk479PsurfvvXbKgOV29x8bu2bM5CR?=
 =?us-ascii?Q?VBIvNgffSldkbdJCLfc4VnPtvXJYayXoJAWdYLCtDmZZMJg4zHkqjRxzrck6?=
 =?us-ascii?Q?tCWA/Ne4a/E3BIpzAf66qRT94P7d82mME8GTloO4OVEPCQFLUxPVElNH483P?=
 =?us-ascii?Q?Ly4x/DocBREz7XJ8i/AjrwN5a17jLSKDYhB1rUqNTLK27xjrnmwktYUJqX++?=
 =?us-ascii?Q?UgbmSQpAbV16bS4VGvPqo1oT30F91XCDoodKmh3uwFtFlRxtBFMIggWUeHhK?=
 =?us-ascii?Q?Kd3mJrHObyGOAaouKEO2DQIiHGx0dGQt9YdzXTMq6RKzSy/m4lOks+JGyXYU?=
 =?us-ascii?Q?C9iupro0ZX3IHCTyJrt9vm01Tas5TNLj04sFz7M2/TWtjIdiIEGcZdRZWzYp?=
 =?us-ascii?Q?cRdwLfKq0XINU2RrmF01KKq/SN7fAuZG0OojXJmQbzXvu3M7ixPr+zp0ydIt?=
 =?us-ascii?Q?osRBKyJB9riDAMM5sh1kyEZP7i/TkB3Ll2cveNYBc6uHxCYcuOvEAmADNgkp?=
 =?us-ascii?Q?XZM0kzhiZmayr6DArBrdSGiMnjTFRp8mElh6CxDOjuLT8+jwO02tUWEGR8CX?=
 =?us-ascii?Q?Xgfa4NLb1P/M/Rrb192TzmSXbWHBbkCmHxi8fuJAbuHQp2JUGBtBzaaN08+P?=
 =?us-ascii?Q?XXzU9oTVvcshLBNSy/OVxMUpO0T7h23vddL0FkuQFIgTSwa4YpGV0A2yJ2Gg?=
 =?us-ascii?Q?+qyqQIsO/yHZp7AazYVT7P6ogkjuaDcB1swl8qa1xMLvDqOuQCQKJ6VlcmEV?=
 =?us-ascii?Q?rlXvWWOtzzRBlEJ0K/fsZ34NBSd8md2So2Qn5F2TUBZofaAC+SDzHHl9orAn?=
 =?us-ascii?Q?jREwBow17ldXS7gIaSoi10xoUpVGBKx96ZS56Nb/kmatOe+pa8qN7iAgBhM7?=
 =?us-ascii?Q?jkn44mARcwL7qP74BhwuRVRoerr2fSkV/ZD0Shkfn2kRqkSDUdAwaGlNqnN0?=
 =?us-ascii?Q?rQtKdI2ykS3Iq601uYWGAWfhpQj9jB6feKD2EhG272Ox2m1J9tSTgZhQhC0P?=
 =?us-ascii?Q?Qz1Tfh+chyBPJlkAkH7bCCMEsaU+8i9r4+h5F3h8NfWZVpogGvfSR3hlw1gr?=
 =?us-ascii?Q?LOHtw/XOI3EegP7nWb1aibqkvM7ts2ryZ/mId7X8bhZwf3npjfWtYzCFn1kO?=
 =?us-ascii?Q?FQRbwLShBy8lkfcJnFoz9FHaMYV27GU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TMvwzVfIoAAfQwmof7RJsz62hDLc3i3b614Mimnr1ENjGq9VmbcEDWYR9fpFSo1tPQx4ApJuQTwIeFjF7prZVkiRlDKEO+RrrT9a3CwuD6zITpju+MyfqyJkh6n1SdJaXMb/Zui9Q5ia+3rEoy3s3q1Tm+MRByVQRcnhJPmf+enlrJHEVfoX8wk2Bfw+qzv3m98weq9DAzvoxmZI0U2Y8qhcMzi7g03CI279ahJUTlwYyI9k6harcI2/cxZRMid5kT9bdBxjmj5IaxxRCkxTO85cBNJqc6vrezkYvrdCvLsUlcbuf07VtiufDTto3VQPfUylWPVMu1Nk8puPc+lRiuodKBUBsq0KTJOJ0XgtWGyP4ZKg35xi9YqteGu+gN5iHa7ponP2KcdZ+89x5GNdOEFCwBwBrWBUqjOtUhfkT0Xo5JIRPEgfLsgRnpckI2aHodBsIeoeL/n4AdczXiSFdY5n216V9hKA2aX7mYdA1d42Zytl/MFEYcjfTNmZeMMfLyvnDU6es+jIct8RJHr4B5F0rS4sGqjwrqZH+hKskqQCR7IrClje5nOjlqQlxMUHvqBxFsza41zlmTWHIdN/VWZ6YM27jYuYLk9JXMAUQEk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e96a706-1b68-4f84-7ffd-08de78f60faf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:25:35.8133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bsVtV0odtAxRdCd41x1ZI+p3N+j2JzxE54cZ2FviuTZ4Hm/6s4YphWA9kwaVM1M6jjx3VPzGD/C7wrOkx2ws6wBesS37TgEQqcrHPJ6gUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFD7011BF84
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603030051
X-Proofpoint-GUID: _iII8VkDKZ7qwoGcj_7y4sjLfek7IAQw
X-Proofpoint-ORIG-GUID: _iII8VkDKZ7qwoGcj_7y4sjLfek7IAQw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA1MiBTYWx0ZWRfXyxvEVHvyy1np
 zSiAXQcS1m93Mu1eLy2LjLny0DV5ogMFadXnoGU54dfI3CvbImsQ+aM2I6OEoHRfOVJ6ybSYISU
 UeEkO0O1BqoiWsTGd4J/ORsT40pnzPnX2SZcCELhPj80tv7QUAmaQOAdnjyFKyEd3VhcFR0Yw6U
 5Nc8hrfy8BPpD9KTCWKGKSyEAmSsqPNpyAlY1xUg8e+xiBtTQobOp9J8e5gwdkNmF238VyOytal
 /Xch9FB7/NUodMTP+bAdErS+BpaNeyM+7cNuQ3IbY9a0iG+8w3K1QWriOhcJ/DfKQ73F1gKVhYP
 EOB5B9JRlPCw/WhOFJh/h6B4QFSI93aXKTK+samkkBbmjlGABENLfUPadlKvaiyVzNDhuvBd9/D
 FcmNVUvY4v0w7RzaFoB+AlOb5PYnpmDEXVYJNfXBAXlVzdx2VI1V8m3HVA0xhN9px7O6HHHY/sU
 bhwzjkRvyUPoQglPYQsQNhBNHxaFMKtp34vUFT8I=
X-Authority-Analysis: v=2.4 cv=EMELElZC c=1 sm=1 tr=0 ts=69a68cf4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=D85KN3_ElKQtqC5z57MA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12262
X-Stat-Signature: p8mxxwbasjdnyrp9q684iru69mhpjwce
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 23D42140005
X-HE-Tag: 1772522754-375232
X-HE-Meta: U2FsdGVkX19WQw0ULjsJ8iAA9bMC9NLjLkV5Aw80Cz40IHRhpd9YCvuCNZ/0uiHf3C52QJla8mvwuoSDLZi2Wdhuc7eNi6YOxQ7C8ZC1CluOK+OG0KL/syaq/TrLu6Gt31pkhvwkUzKLAWKJA//XPqNjI+MmgAh8UhUimqVxsLOp6nlzkbNZLrVf62KRbvO8cLkTwu3OtyU2/wjPj6Mr3kTWFcX3xF0+ZZ79igj+Z9JlyUSYbVpfSlkSpKfnDIo+eqq+cD9xb8dF2VietbH/H0oUfUXfN9kUE4s8lmogas3LrFDd8sM9V5rBFdQmADTQ7ryZ7pdXkpAdRAyEzLr8/GLgAE+dTS5o2Wl33h3TrGtguPc8SZszAgR1ywhQMhT92foEjyYxKs39SEhqaO1c6Iz9yBn9PrW5F+0uHGYqrNx4w//KCDwmADxmHaGzDWfCoWqBLrBEkjN/E17InAKILQKDgL/rwyqdOTkLuty+Kj2aWkVBlX92pqAF/SevfbYIuFeP6W8ICJ52k7vti4P7Dh7y/3AZEzKgAbIJrQxwCyAM508jFvDfFEhTzfyC8x/LAXHdKgLPdx1IXCaQiciXbxhcrgyTh1KlSunySlvDq57UhSuKXqjVzepeYa8hDLN0dmXqAVhbpwVoZI2YPFZs70hs0DZu6jszNnnSX9TWSIniylJpMmX05SyRGXfqPaRO6Rk4aVAAMA8kX66ITpAXtgoZy5HTAXNKfPlQIIB8oXrHEDYDywEeXF8Dnhau+PpQaj+Oq7Ktjs51G22G3RSwTjw+UtPkJiXBcrPd+C4psa7EZ40SxRdpkjGLqO4pN/A9WUy+qHMkYSZ5KcJnm2dkDY5i2vOmSfp3oJtW8J1RliqDlKafuftxN8P0j6+TRdL8ZbUQffIsukKTDwaEWwErDX5xZWf2MF8VDO/lVw2GeXmD0U+KckdpxVc3WkZlzJAeM38CrLQr4P4Q0Yv69ZE
 7Wc3UUKn
 JbuNHOXkQKvWueJCbuYyr630C8wjxSim2JsdOhPclo7kzNrLm+KsIL+bpL0rVF87WMKpy+EIlvnt0HOrDgziIdqqCgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 12:50:32PM -0800, Andrew Morton wrote:
> On Mon, 2 Mar 2026 17:19:15 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Mon, Mar 02, 2026 at 06:10:06PM +0100, David Hildenbrand (Arm) wrote:
> > > There are already patches in flight:
> > >
> > > https://lore.kernel.org/r/aaBVaHs8rIkNcwM0@chrisdown.name
> >
> > Yup, if people would actually cc the right people I'd not have wasted my
> > afternoon.
> >
> > Replying there.
> >
>
> I'm not sure where this is headed but I'll queue this patch for now, to
> get it some testing, to lessen duplicated bug reports and to generally track things.

Hi Andrew -

We should drop my patch and take Chris's.

However, life isn't so simple :) as there's been some confusion with his series
since his email client seemed to mess up somehow and a couple patches need to be
squashed on one another.

So to make life easier, I enclose a squashed patch (combining the commit
message from both), with my R-b, T-b tags attached, please replace my patch
with this one.

Also, could you make this into a 2 patch series with
https://lore.kernel.org/linux-mm/aaBWG4fajXXbjpVN@chrisdown.name/ _after_ this
one?

mm-unstable (I'm not sure why we're rushing changes there so quick...) had
_only_ this regression test patch in it, so we were left with a kernel that
splatted on running mm selftests, which is not what we want.

(It seems to me this is what mm-new is for, and it seems we have some holes in
our testing still since this got thorugh).

Please drop the patch you have for this already in mm-unstable and make sure we
only have it _after_ the fix is applied :)

Thanks, Lorenzo

----8<----
From fbabbc38c000308d2c621a4b3ec1f4bca1d71c1d Mon Sep 17 00:00:00 2001
From: Chris Down <chris@chrisdown.name>
Date: Tue, 3 Mar 2026 07:21:21 +0000
Subject: [PATCH] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()

move_pages_huge_pmd() handles UFFDIO_MOVE for both normal THPs and huge
zero pages. For the huge zero page path, src_folio is explicitly set to
NULL, and is used as a sentinel to skip folio operations like lock and
rmap.

In the huge zero page branch, src_folio is NULL, so folio_mk_pmd(NULL,
pgprot) passes NULL through folio_pfn() and page_to_pfn(). With
SPARSEMEM_VMEMMAP this silently produces a bogus PFN, installing a PMD
pointing to non-existent physical memory. On other memory models it is a
NULL dereference.

Use page_folio(src_page) to obtain the valid huge zero folio from the
page, which was obtained from pmd_page() and remains valid throughout.

After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the
huge zero folio special"), moved huge zero PMDs must remain special so
vm_normal_page_pmd() continues to treat them as special mappings.

move_pages_huge_pmd() currently reconstructs the destination PMD in the
huge zero page branch, which drops PMD state such as pmd_special() on
architectures with CONFIG_ARCH_HAS_PTE_SPECIAL. As a result,
vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
and corrupt its refcount.

Instead of reconstructing the PMD from the folio, derive the destination
entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
metadata the same way move_huge_pmd() does for moved entries by marking
it soft-dirty and clearing uffd-wp.

Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..c5d3e7bf6414 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2797,7 +2797,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
+		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);

--
2.53.0

