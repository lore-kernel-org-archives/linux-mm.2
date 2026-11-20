Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D55606A33A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=cmpEWRFh
Received: by kanga.kvack.org (Postfix)
	id BD6956B05C2; Thu, 19 Nov 2026 19:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86FE6B0627; Thu, 19 Nov 2026 19:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F0A6B070C; Thu, 19 Nov 2026 19:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5C76B05C2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:10:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8B82160CED
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:10:51 +0000 (UTC)
X-FDA: 85453566702.01.F3CF563
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011008.outbound.protection.outlook.com [40.107.208.8])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09445180006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:10:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=cmpEWRFh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of alwilliamson@nvidia.com designates 40.107.208.8 as permitted sender) smtp.mailfrom=alwilliamson@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795133448;
	b=TGkUDZzYFdACfKL6x1vt69CMkgpohz8NmZLuSUKwIX260mq/HdkxrwKD0W4GyZor59GZ76
	T7UTijWr2k8mFdHBp4Cm21tN3GLMq3p44DNsBLbICX9VUvtFBmKc6LCp38JFEEFuBL8hlb
	3G1Li2IsBoIqQ3ALhRg1Bg61C2pOVks=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaKcoVOIlrU450/oZNaFSQVblgQGB2IoQu9v8QphIiw=;
	b=53EZk405YnvuLXI+oNwS1udPGJjePphZSfZyk3LqwxnFtPqx6VoeG6W/I08Zkfzmsq++UM
	uGcacgm8ngyGngeeYPZNj4GE5UxTO82X7H2ZYu+O4JyL63tLzAm+NZp3TYWH3a8Dug9QoN
	I5hOvxa80TgSye38r50aeRjlWSeJtvo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=cmpEWRFh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of alwilliamson@nvidia.com designates 40.107.208.8 as permitted sender) smtp.mailfrom=alwilliamson@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDgc82BdHoCaOrXE+83aYaIv7kiSeIRlaTHbvkrLyk/JCx0w8KogZ4qlY2ekyjWN/9RCddm9zTUsDAb/s8wmzPMVvDDlcHq5wjSIekvCgjGX/4+M75tTvvOHsC0q8hYJkOiximQ/sYa6MQ6k4iPppaQTWbbGcBFdtiAet/Itw5B4Q3M/8E5usEjw6rm9Z5SQXHF8zCKKQDFSNx6XVKQY46SVTVB1Gncscq+wkWfdacRdpxnPmb94gSUA+uB68G5Zq2aqwukP3dW+4ECT7dlN/0JmG9s93QyHY8EtwM6+mxkA4tkHCynBJ26D42TFL1uA2FfNEMR6HMxFMoBFnR7Pbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaKcoVOIlrU450/oZNaFSQVblgQGB2IoQu9v8QphIiw=;
 b=kV48Of1V12h0pDLlrQh829Jyq9sKzJGE3iMRN+fEjOEhiAGoKdiCJEtdqAMWP1l6QnqDoLSdb/aEteHO7jDUKpls7fcisB/ZRNSTGcNr/13Zg1O5FtiUJW/bSNP058qFTjVDARpFYwcmSOl1rd/xou3kxCMozkF6ijUE/hRSBg5ys1songorIrR2wfMSf50M3ZwpAFnVsLv28gV6cMrrum+4Mb8fno6X/a7dn2hd9tgyWgX40OkOQ9mxrl7RhYQvoNubueyiWdIsjt55NrLcuVc1SZg999WlJvqKMkQ84kVtB8lfPGsplPP4TkqCigLzhz+cSxat2dx0AHe978fVkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaKcoVOIlrU450/oZNaFSQVblgQGB2IoQu9v8QphIiw=;
 b=cmpEWRFh769DAxR3HF/1vqkJNThaNuo9fw6xatvqnGjg41kR69WN0Qg3cnxxAh6Oj9pBIDk/mfgYCxyq/WV/KIAgNb7wFUxSJFZchU3uBl17qmPVnXBh7O+B+I0QLOas+vOs/78hEkRL213pXsMb3RpxpcDUT1j0jFQej2K96vRPjHATZQAEMQKH1gCYv2jEC8TmGFRSq9esmPsE9FKhipMhwhT1qddGuXi+lZ/4FTCvIE5MesbTr/fjNSDLwJ9KyXebtjvjOxXTSWr8A9Q7IcN8b3LSmlN76ucA4GybEhxFII3Xb2p9lx7D70cdiYsAFa63JrPh+EotyjiqfHJP7A==
Received: from LV3PR12MB9411.namprd12.prod.outlook.com (2603:10b6:408:215::20)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 00:10:43 +0000
Received: from LV3PR12MB9411.namprd12.prod.outlook.com
 ([fe80::98b7:86de:b69:2a15]) by LV3PR12MB9411.namprd12.prod.outlook.com
 ([fe80::98b7:86de:b69:2a15%5]) with mapi id 15.21.0639.011; Fri, 20 Nov 2026
 00:10:43 +0000
Date: Thu, 19 Nov 2026 16:10:34 -0800
From: Alex Williamson <alex.williamson@nvidia.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Williamson
 <alex.williamson@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris
 Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, David Rientjes
 <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke
 <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner
 <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit
 <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal
 Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, Randy
 Dunlap <rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>,
 Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu
 <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 09/13] PCI: liveupdate: Adopt ACS controls in
 incoming preserved devices
Message-ID: <20261119161034.4e23c1c6@nvidia.com>
In-Reply-To: <20261118223704.3286085-10-dmatlack@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
	<20261118223704.3286085-10-dmatlack@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:334::21) To LV3PR12MB9411.namprd12.prod.outlook.com
 (2603:10b6:408:215::20)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9411:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: 22eb5e39-0abe-47f8-d9e0-08df469ab767
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|6133799003|22082099003|18002099003|261009220027099003|261009223327099003|261009221227099003|261009223027099003|3023799007|261009221727099003|56012099006|4143699003|11063799006|261022075727099003|261021121427099003|261102123227099003|10067099003|261022105027099003|261026121527099003|261021135927099003|261026140227099003|261102130727099003|261028144727099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	dfAfAbgPKSMOzBmqhhqeVEUKjG0m3mtfmwYun5Qm+gIT3tKti7e6W8eyknpn4cJEKyWDiXdDYDkMtGhw+LRLSHbWQBAAwogKL5NWWK7AyqD9aYqSMWi1Sx0vrFCzTiJiQ73rWcxVTRhljxZmRcbERXu8jN91/ewZcc5rnN2lbHyQqjSLAFP42AsJPxbyib0Gr7Sbdnr4gFFw3xVFV7gNjnzPtZ/cCc1Jm4l9yz1JjruonFx5zQ47qz0bFR6vG7FUE33+v3q8zN5yZ9Po+GzmQMmBxdQGe6isem4RNrKxGPRgIIrFuUTgwY6k6Lt6Pz87OZHKZxnhBLfoJPwiJYFhTqjlkxcBpzOSL/YXlmMGalqYMk/msuo/aXlm90yDs/PdE16WjWDC+asAcUQOsWgMcVGGwN6KjqBX0YiDVkokIwv49RjEqDOtFX5oWFYF9xuZEMhNev+XjuLewGBESqKIGbtABNCLAlSjdJ9N6TU3IfayTFSgcoqOnoGbbF+v/+H8QJ1SjyCZZ7ERJ+8uQf3qa0UnsEDqAeEwxbY0XoDnqRYnUbieK9CBqQbn0Ww0ZgosUyG2TMqQEhi5JfE55RrXXUkzOjDISkU2Sq4xVb+TimRMIPWjMzv7tNAdWe7xtnBM1dtPnaJ78O6cIx8rVgyvweRRM/geeILldUYBIr0euyk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9411.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(6133799003)(22082099003)(18002099003)(261009220027099003)(261009223327099003)(261009221227099003)(261009223027099003)(3023799007)(261009221727099003)(56012099006)(4143699003)(11063799006)(261022075727099003)(261021121427099003)(261102123227099003)(10067099003)(261022105027099003)(261026121527099003)(261021135927099003)(261026140227099003)(261102130727099003)(261028144727099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HiyI/1GS2brxWcarnd4vYhMC5QOBBlS1BmTqugNfkfD6b4FouFWZ6pSKiSZZ?=
 =?us-ascii?Q?kz57MlfIkbcWVuQtwcP/gbZMEDbJJbeP+3AbN21WgUEYwelukXEghWU7nPq4?=
 =?us-ascii?Q?F4eegeQt9owcF8I3j0gI65ZTchURstodcTX145nN1Jt0eVrXo4XQK3R5aDmL?=
 =?us-ascii?Q?Klpi9jhkrBvXKLjYbcAGV32h3o21qyPURziHbcvK2SnfsigyiHl5oV0hbIbd?=
 =?us-ascii?Q?u7d7rRX23RrXjAi2tFWlj1PA1mS+R5iO9h6DgGrkDAnpiQa4mkHXOxZoRHPo?=
 =?us-ascii?Q?EFEQyuTr+WRW2wj9ponchkTEzFFjZ0+Fg456d6/LKvSg+FUyYkMhuQI0U5PC?=
 =?us-ascii?Q?6umCvz/1NIqwVrVqiq47C/nmtYKXklKVtjIWRR5+Mx9SxqM1R9R85El0K6le?=
 =?us-ascii?Q?VNjwfmMX7kZ1kNfmwl7y2Jxbr3G14dxRJRXyddMvIyQjO6zQ9VXTVptlB4kg?=
 =?us-ascii?Q?uiDN62EXoexYzx6tytYWo/5dtmEn2wdQ9xKq4ZHu69RVDnUpK3CsALgQGmfP?=
 =?us-ascii?Q?JRpeqsq5wmwhTHCb5ozIDK1JENgexm/Oft0HdczFep0kZ078tk5nI+VLjkcf?=
 =?us-ascii?Q?ABqZQuwcQFf0hBbMGjfcO6KkTJpLGTOzA60gjdPS5ANWdTDsyW7R6NGHTAUf?=
 =?us-ascii?Q?BLn8n7pVKIt8INKSlh+M/WdRPBIzv4k1dsCjbYpWgoGWswpB3x9fyHdPLNuS?=
 =?us-ascii?Q?FvEr2A3jNtvu5DnOCKSRRddI8Q3Be3EN/LHesUrfijB6iR/JQkWyCX5bE+U9?=
 =?us-ascii?Q?KrY5gJAabMmwXtYzZqeUL8iJDGMuCC4Md9g/eskBSDpFq0qZ/KF31omuzTL8?=
 =?us-ascii?Q?SPzhImNd8WXWql+5EIoVPDfK0hRO6LT/k60qgJvrfWk+y+tTxWMsttvRDbLy?=
 =?us-ascii?Q?LRFP2xynZprf4mQv4f7+wcuqENjqHP7md2tZBmPCBk8RIDDmYhHCO4H7gpjg?=
 =?us-ascii?Q?GRJ6nYzGQOWjhFnTQ2XHxP3TBTwvzv9WejJ2j8a0CNIoSNO45/Bh7q5NNBM9?=
 =?us-ascii?Q?Q72Yfo1ZZs1oNTMa9QBjFAY6NoTmxiuZ6xwepfpJkKW3RUyfEIr4KjGldsll?=
 =?us-ascii?Q?TeOZJ4i1QGk56R3FEAo8ksQxuBSJNlugTj7jlbuOFl+PKUVKKs/E7oh7hKBo?=
 =?us-ascii?Q?K79klgMOWGQiAi6/SWLIpxd04bkEnhRephpyuvDXlgY9gUU/aPwUMVtetGpE?=
 =?us-ascii?Q?vPXWh9jDOX/VoMRxeG3rCJdsnGPzEMnBTKHpT8dNs63t+HNnoQqWt91eJUs1?=
 =?us-ascii?Q?y1anELvcyvArYZnKW/6Hq6yo1ZgrIL0YLBxe0MshHz2FIBpGGwglIj6x+dFw?=
 =?us-ascii?Q?w3zt8HQfstYzamPyGBArC6001PTn0o1Zw58RU+8jKep4YMdBPeF3lXqZJF9o?=
 =?us-ascii?Q?aYOS6WJ6gNhE2T4A6ZyTgORjaJO2JNdrkD/xNht2hZWHWPkZx14adklWKTPg?=
 =?us-ascii?Q?P/DaJh6ZILEfrgiXU6VQeFGX4HDh7VjFaHDmxvoq6FojvRm9GCaCCxeLLC1l?=
 =?us-ascii?Q?s5mhZmTnRm4MUVnAiAXjNYXn/7iTvcRG2Ms1BhRMGXLd83U2wj6pSXxRTLoS?=
 =?us-ascii?Q?QI9I2JEKZmmMO2TX627FuC67+VctOLOj0Dl/ZKBlYw1+y8B4LnspXgMvwE5Y?=
 =?us-ascii?Q?1iqijsGZoNSLNxRr0qkmByvPk1WS5fZO7b1un9Yx/jrjTw85YsQwkoCx00vp?=
 =?us-ascii?Q?GpGL9DPVcZOrYX5kOZdwDIWdP2Mwv+BuDzAO10w72GuAWEIB+AtRQ/Ma1svi?=
 =?us-ascii?Q?4swGlA5bsQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22eb5e39-0abe-47f8-d9e0-08df469ab767
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9411.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 00:10:42.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQkmudEqfYdc7zqdXXdsMUSGjzp2bQVVXgnpjb7z+esnm1LH+TvxoqMx+rmP2sg5yK9Yg+7A6CkNe0Kg1nIyWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 09445180006
X-Stat-Signature: aeis16qbxm9qbhbseqc7u3rfuhi45rrf
X-HE-Tag: 1795133447-91766
X-HE-Meta: U2FsdGVkX19c/03hnJaLkhCLgSH6ET1XS53UUNnENWE1/FCXV+6cnJDQKunYnBjd/Ow0ozvDL5loJMZPUnKdVwCivYByjZa6Z+spAFMqCFBxIVcXzx23MjRT1TFjEo3LkGZoNietX3hDLj5saVnoRJzxPYwdw6bL+oHieyrbp3dTyagdVm0bsp0GQZWWN2sqS02KeQAP68xxbTQDyV8Oa0R5HxQ7iUq5atUg3ByWLCYm1/mG25exvCoxI75LyWr5KrhKCv0S+mh1eBkuylS6NOeO4mZ3IrCAzD3YfpYKjkISCik18mEqX9fOkkK0cvCoXGAu9JedE3WfhpYjN1MpEjijxAMlecsyg0QMDVEUFQ1hP5gE1i4oA7fdtmROpj1aHHeHkTLNJk7CuqxInf9eVqm0ayC00fmAtf0bLmsYAS/qZK3VFDUkfUSrgUvgVtsAznZBUsJ5caIAxfzm1QdmdJikkHV3ilSjrsWF4tJXHuysqtiAXbkJZESebuaKxo2/YZhkhcLKjVh8k1cpOIq8AZf1F+FxJHk0iBYIQm3t94zVOqLj0Q3XqCTGRFXPfrUwAHmNtmUafUVdRaziGMmYaFnMgvnGliJ2Wc2OoSpRGSkrNJDdRaof/f8oLNvAVd52RJ4EemkU0Mp5g4R8hZHqHDAdGO7wfKHC9tuLGKaiMMKbiCqltfHpRTmUDK8TVyggEmzGCFb3aAq6lKsVsZWOExJNbYxreMOZ2LgnQ9r+nrTQwVeZjch4l1zIHdiyLnfrEqhpYtcvzNKI25mwjDe5jSY3kmgzIZnUqqtZJ7t+guPZJ+8qBvJ2Mt2hOzDwqbEMThFw2S+VDj2hrhHBawhsXw579lVpfFhDeLIDKAsAmpCTO7Bv2RsMJ8Pa2TpsdQ/dLuPwb8Djt3ZweenmF8iNNeCfFOom9c6xsVcUlouiWn/fSKv8JRoWbwz80wyuQVav3X6jOiooxN1GsROlm9m
 Tyz2z1Eh
 oWiLc1YGFSPM7M+wOHV+hC4alnhzMKlKf5WOmZ/MLVrMfeVO2PBsDpU03QQGOwBLozQHHBOW/Zm/bW6Re48ccTevBPT0uIfoQ17qM5dvGw3KVZg2YT8uZPTpgjXcQjjUqdrWdsHsl6N5CARXMXHayApK5CFMePpOF5kcmlrgD89BP2LciiXYEeyX9CzLGhJwwkq5YJsgk7MZlVabvGwiy/LauoS/d/+LIGvra+0Gz6WoXnDsXnHO7PxFGt+vaPu9PVX343K7oXS6I+6aq3jgvwyBn5B5Nv8rM4dtoUbKUTLCLsRgLD6ErRHp4zWGKAlBhpl4XKblYHu7+OkNI7PwXWCSJuzdspQzSI9+bFQgddKHHdQwtRT9nYzjz+cP1jRQLnqq9n2IKGQJKZAtBdrSkA2BIgqFb/nRVrvEeshOu1h5+AOXEBFjT8WA4RpAm4XBSTepjc3QQuFBD9XiqVF2FiYct9RU4asF8+Usjy6Lo4Ba2iomfiop6toHEt2g/x87X43go+A2JF+HB2a51av9vZ1d/WxuZ1GQVD1hDlT/JWqX9HM3/s6H/7yySUg0aUKY5eP8QUzvm3B1GiKpdJJ8MFJCdbeiyoLEnlpUu9rekMrtBNjfRBbBVw1/hyyTe05xywJKaXuxLI59a2Q+fj9U5o6fTvWd7FCAeZ6EX1jc0u5gDaWqjLApIuUGK0oAtz5zHje7atedIv5w5jL0HauXg7XYjuCXQ+wWER1QprK4CIe3QRpHv0tl7/99q6ERFCCjJ0E4I3rM4AvYV5Hksh78dGZwlNZEpMzxe6YVF2FbzU9nRP2WFR0eSVMsD5/4sMQJUPhtYExZ06swzQgX2NATd5KUCqq5R3vO4iKyzD/mSjrxqaYvMPbh39W1GSlspA21kmiyrzZH5ATdiprA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 22:37:00 +0000
David Matlack <dmatlack@google.com> wrote:

> Adopt Access Control Services (ACS) controls on all incoming preserved
> devices (endpoints and upstream bridges) during a Live Update.
> 
> Adopting ACS controls avoids changing routing rules while memory
> transactions are in flight from preserved devices. It also keeps IOMMU
> groups from changing during or after Live Update.
> 
> The adopted controls are recorded by the pci_save_state() call in
> pci_bus_add_device(), which runs before drivers bind, so they are
> reapplied by pci_restore_state() if the device is reset. Allocate the
> ACS save buffer for incoming preserved devices even if they match a
> device-specific ACS quirk, since their adopted controls live in the ACS
> capability, and panic if it could not be allocated.
> 
> To simplify ACS adoption, reject preserving any devices that require
> quirks to enable ACS as those quirks would also have to take Live Update
> into account. If such a quirk matches an incoming preserved device
> anyway, e.g. because it was added in the new kernel, log a warning and
> adopt the device's ACS controls regardless, rather than reprogram a
> device in the path of a preserved device's memory transactions.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/liveupdate.c | 75 ++++++++++++++++++++++++++++++++++++++++
>  drivers/pci/liveupdate.h | 16 +++++++++
>  drivers/pci/pci.c        | 13 +++++--
>  3 files changed, 102 insertions(+), 2 deletions(-)

Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>

> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 00d6fa5236e9..b99a88c2c199 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -123,6 +123,9 @@
>   *
>   *  * The device cannot be a Virtual Function (VF).
>   *
> + *  * The device cannot require device-specific quirks to enable Access
> + *    Control Services (ACS).
> + *
>   * Driver Binding
>   * ==============
>   *
> @@ -174,6 +177,17 @@
>   * bus, since the bus numbers of the failed bridge can no longer be read from
>   * hardware and handing them to another bridge would let an unrelated device
>   * inherit the BDF of a preserved device.
> + *
> + * Handling Preserved Devices
> + * ==========================
> + *
> + * The PCI core handles preserved devices differently in the following ways:
> + *
> + *  * The PCI core adopts all ACS controls enabled on incoming preserved devices
> + *    rather than assigning new ones, so TLP routing and IOMMU groups stay the
> + *    same after Live Update. Note that a device will use its adopted ACS
> + *    controls for the lifetime of its struct pci_dev (i.e. even after
> + *    pci_liveupdate_finish()).
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> @@ -189,6 +203,7 @@
>  #include <linux/slab.h>
>  
>  #include "liveupdate.h"
> +#include "pci.h"
>  
>  /**
>   * struct pci_liveupdate_global - Global state for PCI Live Update support
> @@ -540,6 +555,15 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Do not preserve devices that rely on device-specific ACS equivalents
> +	 * since that would complicate keeping ACS constant across Live Update.
> +	 */
> +	if (pci_need_dev_specific_enable_acs(dev)) {
> +		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
> +		return -EINVAL;
> +	}
> +
>  	if (dev_ser) {
>  		/*
>  		 * Endpoint devices can only be preserved once. Bridges are
> @@ -816,6 +840,57 @@ void pci_liveupdate_finish(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
>  
> +/**
> + * pci_liveupdate_adopt_acs() - Adopt ACS controls
> + * @dev: The PCI device to adopt ACS controls for
> + *
> + * For devices preserved across a Live Update, leave the ACS controls
> + * established by the previous kernel alone instead of programming new ones.
> + * The adopted controls are recorded by the pci_save_state() call in
> + * pci_bus_add_device(), so they are reapplied by pci_restore_state() if the
> + * device is subsequently reset.
> + *
> + * Panics if the device has an ACS capability but no ACS save buffer, since the
> + * adopted controls would be lost on the first reset.
> + *
> + * Return: 0 if the ACS controls were adopted, or -EINVAL if the device was not
> + * preserved.
> + */
> +int pci_liveupdate_adopt_acs(struct pci_dev *dev)
> +{
> +	/*
> +	 * Check if the device was preserved over a previous Live Update (even
> +	 * if it has already gone through pci_liveupdate_finish()). This ensures
> +	 * that the device continues to use the ACS controls established by the
> +	 * previous kernel.
> +	 */
> +	if (!dev->liveupdate.was_incoming)
> +		return -EINVAL;
> +
> +	/*
> +	 * The previous kernel does not preserve devices that require
> +	 * device-specific quirks to enable ACS, so the controls being adopted
> +	 * live entirely in the ACS capability. If such a quirk matches anyway
> +	 * (e.g. it was added in the current kernel), ignore it rather than
> +	 * reprogram a device in the path of a preserved device's memory
> +	 * transactions.
> +	 */
> +	if (pci_need_dev_specific_enable_acs(dev))
> +		pci_warn(dev, "Ignoring device-specific ACS quirk, adopting ACS controls from previous kernel\n");
> +
> +	/*
> +	 * The adopted controls must be captured in the ACS save buffer so that
> +	 * they are reapplied if the device is later reset. Without it, e.g.
> +	 * because it could not be allocated, the first reset would silently
> +	 * drop them.
> +	 */
> +	if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS))
> +		panic("%s: No ACS save buffer for preserved device\n",
> +		      pci_name(dev));
> +
> +	return 0;
> +}
> +
>  /**
>   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
>   * @dev: The PCI device to check
> diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> index e5d2a19d2ca2..c643f2664296 100644
> --- a/drivers/pci/liveupdate.h
> +++ b/drivers/pci/liveupdate.h
> @@ -15,6 +15,12 @@ void pci_liveupdate_setup_device(struct pci_dev *dev);
>  void pci_liveupdate_cleanup_device(struct pci_dev *dev);
>  bool pci_liveupdate_preserve_bus_numbers(void);
>  bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
> +int pci_liveupdate_adopt_acs(struct pci_dev *dev);
> +
> +static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
> +{
> +	return dev->liveupdate.was_incoming;
> +}
>  #else
>  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
>  {
> @@ -34,6 +40,16 @@ static inline bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus,
>  {
>  	return false;
>  }
> +
> +static inline int pci_liveupdate_adopt_acs(struct pci_dev *dev)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
> +{
> +	return false;
> +}
>  #endif
>  
>  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index fc4307a2327d..ebc565b4780a 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -35,6 +35,8 @@
>  #include <linux/aer.h>
>  #include <linux/bitfield.h>
>  #include <linux/suspend.h>
> +
> +#include "liveupdate.h"
>  #include "pci.h"
>  
>  DEFINE_MUTEX(pci_slot_mutex);
> @@ -1071,9 +1073,13 @@ static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
>  	/*
>  	 * Devices that rely on device-specific quirks to enable an ACS
>  	 * equivalent keep that configuration outside of the ACS Control
> -	 * register, so they are configured from scratch on restore.
> +	 * register, so they are configured from scratch on restore. The
> +	 * exception is devices preserved across a Live Update, which always
> +	 * adopt the ACS controls established by the previous kernel and need
> +	 * the buffer to keep them across resets.
>  	 */
> -	if (pci_need_dev_specific_enable_acs(dev))
> +	if (pci_need_dev_specific_enable_acs(dev) &&
> +	    !pci_liveupdate_was_incoming(dev))
>  		return;
>  
>  	/* dev->acs_cap is not set yet, pci_acs_init() runs later */
> @@ -1170,6 +1176,9 @@ void pci_enable_acs(struct pci_dev *dev)
>  	bool enable_acs = false;
>  	int pos;
>  
> +	if (!pci_liveupdate_adopt_acs(dev))
> +		return;
> +
>  	/* If an iommu is present we start with kernel default caps */
>  	if (pci_acs_enable) {
>  		if (pci_dev_specific_enable_acs(dev))


