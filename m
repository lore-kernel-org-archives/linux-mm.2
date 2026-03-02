Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C68ED58E48
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95C2A6B0005; Mon,  2 Mar 2026 12:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A196B0088; Mon,  2 Mar 2026 12:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1926B0089; Mon,  2 Mar 2026 12:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 686266B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:06:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A83B576E3
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:06:46 +0000 (UTC)
X-FDA: 84501752412.10.520F849
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 986AB4000F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:06:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bBQOTXcw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WyXXy4GE;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qsbtlakfpYVBarEtbVtnSVhQatO0AP35nc5uJT3ihhM=;
	b=7m15vAx7sYhvFobesleop4rUi8Q90K9LwvIKQqqn/6yWQ3+p5IJzBhCh63CBYaJhLrTcDC
	BQHLnDwZ7Dwje2zbAh/zvmdw7TJBLMH/aD5Ti7R9uWdUIJhEgJwPOgfQtt7uno6ZbD/Ug3
	ZYL23Zp1QkiupWltdr+woGjrzzRZNq4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772471202; a=rsa-sha256;
	cv=pass;
	b=FltN14OLLJu8mjQXRTwfXmuNYmEcCEzhWlkolauwUp+TFn0ymr6P45Re8MgDjQUD81WgFn
	QvD479qKLqvw0AX7OOBh9YGzgw9HW6C2A6u9WbM4riZp4CjUSiUkSRq0OV1dQQxteTt8tU
	AhiKxk1bwywZU5B/6qExZPEaX/ODi6o=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bBQOTXcw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WyXXy4GE;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622GH2sb3803376;
	Mon, 2 Mar 2026 17:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=qsbtlakfpYVBarEt
	bVtnSVhQatO0AP35nc5uJT3ihhM=; b=bBQOTXcwXa6YZQpY0Gb4alBemg0zb+1E
	aM1k8UqOqLgX14Z4t5sug53lpgX83PPTlk4mM5x7SqZkfv7y7R5YD35IdDd7vm74
	M8eQxGgMBzhkYZi93IDE/SIQyWT/73N/3WG0D28eMrMPfNJqHLujhKyAV6orqMBp
	3s4WjGpyYiTH/SqS4WdUqXLY+9s4OqS46iVTRhWrCf3VnKZMKXK0DRNVGVT8iY+9
	IeuSuG3jTHxB/BfA3H6rZgtVbxU60S5K0snO0vcbPE1rJWjBX1LYvycTsqiUQgoW
	T2SoFfiYeax9MBD6tmTi62t2Cj5pJ4Hdj/q4JpTHNmzUWvWKSOzLag==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cndxer2j2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:06:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622FpQf2034810;
	Mon, 2 Mar 2026 17:06:29 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010029.outbound.protection.outlook.com [52.101.85.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd78xn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 17:06:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6QlZqmyof27O18iEX6D2jxP7fzsC97U6w/Xn7LwsND4c6w7SlqDfppkk3UaIa8AdP7bwu+ZB0IbhmdAoyiv5J+0l8Nfebl+t6Ep+4uvr+GASvqRt6S+w+8IPQhGRc7Ymbxu916Y4OTbai/IGQBxxYzyy+3hjlFFVWFbvH1DePq7Cjw0PUVNTv4RXcQ/B9UfN1RdbgCCikpZdrGz/mMd+hIm4zULE0rrDNobpFVOhi4NJ0Mx0f8YzOwBq7TWMt2N/uHsOlndj8TSjFi7Taw8QprD/283FxtOmyRJhpbEIZCcph8K3I9DXUSh0aKFUkkysh5DerjNO9zqi07+xQjImg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsbtlakfpYVBarEtbVtnSVhQatO0AP35nc5uJT3ihhM=;
 b=R/RDsp2+PfyrL64IoTkn7yGtxIcN0A1A/lGgPvhaSofEdR2Y2rODGbgClLYyJyoGUkorvgtJjn4letII0oaFH7+/sKUxmxuxZmqp4VSDaqAXQgyJmW2My6hkjstEn5gVnKo4rkwol/zSsB68yoKNxT6knu88qoYq6ph1Kveet5+Ntkgd8zfazhYL8csZCXGia+x1algje52xXIo/ouhk2OGk1SQSVFAKyovfKBfJ9LoX9m4bHkevTzyyobn2T7RohhzD4/AOrQB8NuTAYEtnl6thkU0zcFTPpcXRFMzvE4Wxi0ffdR31eC2UkLxjQGJvmBlSB3KVMWAWL93V9EaLIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qsbtlakfpYVBarEtbVtnSVhQatO0AP35nc5uJT3ihhM=;
 b=WyXXy4GEtWWchRYwLJSRX9hnuPjkUYlTFrYGqp73Z/5mpmUifchLwpK56pHIHb6yqWFknLTDffm8iaGB+zHau5s6fU8Gb/Eq5E5eq5EVRbWAo4cQ5OSOybgK7RrLNrwnRuKXowimRGAi5lOSvJkWioz6xtPBxUYQZO0lPd0ypMU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4736.namprd10.prod.outlook.com (2603:10b6:a03:2d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Mon, 2 Mar
 2026 17:06:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 17:06:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
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
Subject: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on huge zero page move
Date: Mon,  2 Mar 2026 17:06:19 +0000
Message-ID: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0029.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4736:EE_
X-MS-Office365-Filtering-Correlation-Id: a6927e80-874d-4c2d-27d2-08de787e0926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	P/FfE9V+w0oTkSvjRj2oVe2xC4zQsskw9dS12lkzSXBAqMDmpxDhzgZH5JFPXPglHkRcWvHUmyj2qfUFQM20ujvmLa+Cw3hB6KQJlHwzBZ46LMRRKVp41kjRlL7SInCx7fUMm5EA/pTKNsvJhCPCW+hBQGNx6YrLf1LIx+DlVXaWJWTCw8Xx1stYWvOkFQrMPjx9ZqYzixCMl0GGeY4Yg3HKkX2jPeVZfflMuoIrLH5ZpnYku/9rzZTuC8KdJqCKie1t9YNjcwM4fToZfxbzvpW4kSccgvNTbGQIOm1pTi2BrvlWl2XolJ3FihAVq1TvROSlXBhhFoAZ4Odog6OXiVzpePESzZaKNOnuybCDPs1sBwZHnmceOk7r14lHkkRUAkkq7OvNb1bTMhfhcU79rCsur7bS+Z3wt+meP/0imfxwyjhLbUwFHK7QP5dmhLBm+PsBqZ/oEYjtXGky1PvjQDrIhyX3MENRNtSYRSFK65BMpr8UYdbnc/BkAHx78zxzVqUS7o2JLsUvt5RWL6DYNmVGpGgemnUrTD3M3l3epkZOtu1frrh9PCNmaZGuQlrUOTYpHFq0JhcTFiBg5Tp7DUDMuPpkY8DYqG2PyLWhmhVfdTV9mjjWyMBxoGtKSv8UeD833DJZ4ye6ODcY2DeQ8IdnRE9MKAZHRdGs794UI61UiHwqL+uUcA5tCUl51wLjIJxURNxCmUeML/Kgz5lkRo4+qklxP6q6f1qXcPnf7DU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uIXgAFPuRR1idVsce7HXihcYTJPYCQUbEdbTOh0Ps5erkdgKXtZZvKc4fQkh?=
 =?us-ascii?Q?cShrM+GkGfAkIrTsR5k6dhUu5F3vwRqntB8Eh/G26iwmGMcBpit431Kt+Fr9?=
 =?us-ascii?Q?MNKOtj04ayzcm5ugKcX86S0CDxfyMuuDiGoduaBsYh6iVyk9L16m4yBsbBU4?=
 =?us-ascii?Q?4kKhMT+g9nBJunJRcCc040ZcnH3rbDvMFw2TlW9z0YELyIWPvwuVYUoNmwE8?=
 =?us-ascii?Q?E4gmh4liCXcsmP+Nk5hIZMLorIsnUSQRt4P0cCoII/OFsPBe4bv6RpPQCQnX?=
 =?us-ascii?Q?oUUjaHRhPM4mzWux5OhqG5x6u7Zwi+2npvrDVkK4U1Jof+qxZ5UlsE8dQZEW?=
 =?us-ascii?Q?GmdLuuUksUBJF9TvKpgzYT88TE5pExR3dLt/JRXdd++wp1JwEOhlJvHhp/vH?=
 =?us-ascii?Q?TUjvHydLR8WNRojMSW0cFReHmII4ZlzWo6/V3EkPjRAE5KcZuY0Eu3rGeZXX?=
 =?us-ascii?Q?/1UTvrzFFaoagC3FvXtSZLI6Pt0cAmnW3mSidvN+rV/zmvoCecCYYo4LZaTs?=
 =?us-ascii?Q?bVS3gEtp3DKUBKSbc67F7wC/WjG5BjXmB3lAnMpmrQVdqX6sXMdPv5W1L+/W?=
 =?us-ascii?Q?Akk2zVaDGsTgwMvez11HiTlkadt9flpyyKvATCGjpozuqUXoDvsx2iY8Bgsd?=
 =?us-ascii?Q?ORSkMqQ+66+o33G/fejTjJCSp/giIUr70ps0DP/jvyM4sAKo7A8cK86Z10h9?=
 =?us-ascii?Q?gXdqDoda0z+KxX7hHIg/x+J7KeLKV9tfsURh2p6mAc5xbCNhkTM1GhSDmNqU?=
 =?us-ascii?Q?b/hAWvAJJy4XRDhuif27pWIj7vwMbdQR9Hs79EJC74buehqdn+tvXJ4Vux63?=
 =?us-ascii?Q?hi7c00mjzNNyHYccR4MvbINyICd7/yXr+yS6jTPj4XMqvHeOcXlIO2YzToBW?=
 =?us-ascii?Q?xc430k5ZkieRqZRmjeUA6Gq4F1zwrCauyl4B6TPOOuUXODCEaPjJTuZDBwQs?=
 =?us-ascii?Q?IQN7x3tzQ/O3R2C13NtdyMWFAYToF+exYHn63PoDqM3uqKQtJ6x44Uyzp9NH?=
 =?us-ascii?Q?pOVSlCO/2mHdD3J7yR1MSpC9BdGp9rlmkQ8jJpgkVcvme0ejO/UMSmTljoDX?=
 =?us-ascii?Q?Rs28KBXjiGWbMHt8jkhsHup7XFPo2VJBcw6nWcwDHteHFDm1C9hML7g2XWVw?=
 =?us-ascii?Q?GXmPFTCS4SeqB/o380nLY/xgmNKAiZtK/1dqqYqv0BnCahXDs4RcqnpLrSLe?=
 =?us-ascii?Q?Z8NCqoGq5DG1nV8BaRVypY6iCLblcUnGdTsEujJyXgTNw6PM/9XTgUNHWp+g?=
 =?us-ascii?Q?ovhlIRw+jF8HBkznMM1k/JHi+5/buTfAWDF9YCZ9KrQ6/pwduROkAhZ5gexz?=
 =?us-ascii?Q?j4TmHOokBBqXhheN7wh5XWZDzkWtq0AMu4QRmrhHQz2ePlbfJfdG8t1MMczJ?=
 =?us-ascii?Q?IOM08Fuf4a6QAPYPtybQ1SeCjZiGZudMhJJjOHQqp9Id9JsYpCJ/72wpc5xC?=
 =?us-ascii?Q?OnH9vArvA/7KLnrbsbfKN7Wyi1B/gxQOJz4FE7mUZCqfsN2TOuaXL1aZuL6x?=
 =?us-ascii?Q?fiUfcJbY5XIUNP4c7AdZtj+gP67OtJK2R52gXfWzzJ2qRUzb1/v/W/qnL4cg?=
 =?us-ascii?Q?Aoolb3HgMtYi3hlHYNiT8vWyGqy0xcwP/EhDGol7oOeUeb/5uWppPrzi7xkk?=
 =?us-ascii?Q?0FvEVzr8fUEEjIIKfWHSwxzocU3wWh0EHWomK1KNGLvdekRIhkRRBuPjyPi/?=
 =?us-ascii?Q?pbY+M1gRlPNH7/4TTrnxoYP7P8CH/d3b1yfCEtVyaRBPd41wNAhwHVt5OI6H?=
 =?us-ascii?Q?Y4s5AKSnw9GA1cfWMLkePRqEptCft6E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+mmWFb/im4TvDIWCJyMNmHQkcA7JByNo/qduPBXi164OL2LLe1k9vj0nyFpy4W78XPF1zoWo3fMOaWVVnbKl4AiR2/o6As6gNfFQZ99zbGV/M45GmFOLCCPsxMWys8ulpFemCP0x7YwnayS4U1c+LK1hA2I3LCbT08ofAJ55L5A2uRBkKXsaMEaQgUMPG+wccJfajZfTgrEgsYs7Tzvpivyyth/2QjmVqB0p3TkfYz9PLkhqGpshFToadDvvZjTfhViigsvO8CTI44vYqpcwLOxi/7PHmrVclDNuAdesmdn+kqJJg6ZaC4KfPK8xSaxkU7Xk9e07y7qw+X0oJ3HEPzNKwEdqxKG+smsB/+XT68dsx9YikpOMvXfCs3yif3+kAOi4lVW/Vll13koHS9SgJfHm2gmg4wrjYl/Pm8rU4zdHg9U5NMD8S8G7FoJCZcrbnzlt9A7xaAiBMCtvp9s0xuQN0haldE+SOK6YBkxLJbYMBPibr01ad6/FOVgmhHrSt6OnHaaUZLHHWHYqhpEYmmQhvn2W3SRFzim37XJjmwHCj79wS6eiB3OCDSi+6ORSQqG3woDGwhvOms7dkZ++B23OH4b3f0upwtozO89qScs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6927e80-874d-4c2d-27d2-08de787e0926
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 17:06:25.0513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/MOoNxbRy921P5glruaTm1hU1Cg3lAw3FfFMD8mDYAJpo0VAbcmHkfCgpFdVWsHpEVBIiGMEFdmD5x+S+Z9ccCMRMwvUa2+Uh3jjbrFPOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4736
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020139
X-Authority-Analysis: v=2.4 cv=JrP8bc4C c=1 sm=1 tr=0 ts=69a5c396 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=vATiTS43Dei885RGKPQA:9 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEzOSBTYWx0ZWRfXx/cgeYs0UXWB
 EPG58Y6RgYMhFbpb1wcEcEwlhJSD522ZyCpd7YVyI+ZJKII3YWb5pJUG3wj9IDoDDRbx37tSMi8
 GQY/U/Egcebk2CzWnHHtuSdaSdqA6IBkWTnrhKJh3MK8k5DdVFWazg9LB696rv/OBa9WP+OXYfz
 c1zRDVYnqmZDPqGYYpWOxS6S+dEWGiRc8mozlAA4TNeT5CobHv77GJZFKzB4QoGmaUEKNRyNLI6
 KI/cf1WHN6h4K+Lv9aINLcomyZi3JGn5K2dpCSGut77WJIjDgxlccCXR7mHuOA3uS5EsYTUAYZY
 Z0EsnUSPtpoEUtsAcoaoAfSKRCk2Z9j4euNadCGj67Lfub3ZMaMgVLoDvfuqcDkmDF3Psqsvc05
 5M5Is1ipF5/NlZHmSf4M4GKNaohtc8rpI0p9SG70qKVzYoglNqFooT5g0wPr9imwfcz227fZXvA
 IYdvbHByWt+Pok5VApUA93YcMI/HiIsDosldxMJI=
X-Proofpoint-ORIG-GUID: IKaiuIN6Trax5BVASwjkrJzL78bUnkZB
X-Proofpoint-GUID: IKaiuIN6Trax5BVASwjkrJzL78bUnkZB
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 986AB4000F
X-Stat-Signature: ee7ex96f9ewapi6zwmd1b8pzcya3oc7j
X-HE-Tag: 1772471202-339399
X-HE-Meta: U2FsdGVkX1/ME0XLdEDfxuFGyVNcSTa+hZzt/EuU88jK5NuhP+KhkCUC6P/PtwwfL5fh2upTtHXp72lJOIIDgIYthFn+OmColqb+9D3Lg+m9yCd33VUo6jHsv5B73fUvWbKKdEtGLMotTvZb87/Fu4dB8K5y48zT+PxOTLLpVK6zumj0WmJ5g6spAbzjVdNV1/z6JRQOxYglQ3lurEWZThHLjAHRsUgQvvViibys7JFyFX3J38OHGGZQq+cUqpQOF/VHekqpfaup6wqNNs8OhjBah5KCitvHH6ZQqELYj8RA6NykMa//Zn0QBvqETrDXDf5dg2mLnRoIzebMxZlF2wD4dA89oqnp0gXIqt+y3tMX0vcX8Mef8bTFugq3KaBW/N2QACzXYi0tdA6xMpCrz/vCe13PYBOla/fVGDG+5x+01gNnqK/s0uHPz60IV5F6D3VJqlcEmAiAKU+k961NS6/yrFr3tCm6TJeWSdFp+Y6iYFUuR+O2Xs9Fr32JaW3O76lQ5jobHMqG5StNIBxl+LtHaF4aBT3q83yIz2318ULkQAtPgN/+rEFX3PAZ2n1vDaHiyDkFgm3o9ISPAkilkw1mYqJ8+bnPCCAdyhDDUuoWuhv9sPy/b7CCpoItve7qOMDgqclvAOu3X10XDwAQFNowFs146k4m/9HQ9RXeR24mVi4JqGB9mgGdMb23WjGaC32EQVQsLRpr2IUFFgrui529HwZgEKbYvDQ5rrVRQ1I2dhLgJJtzusqKR4ZcDGJc+Z9yabU2MvzMbkFNsGUxCLV6NfVX67eJpKOid0fSGkpF6E/4gAd6nJ9aSZiYIk3gaqBcNxvzdPmbDpgpfTiMBrR9/70sOw9EouJRUui7TUZemfyW2ISw6+PMcqaNfLqgPnLn5fTfeP+j87W3Lq+SsaKI9XIJey4MOVetYYUZvQldw4VaE0H+fJ14FLy/T39PVZ2oyuYaktSkPUXWHQF
 8fEBQbAP
 0ROQhnIPaKT56fVtZPoV94BX6AbT6EY1hKk1JhpO0QZhpN0LfxiS8wmylzu25x9y1uKrqpGzbjHN7k2tVhDacUc5aoIL/JPYai3PkanCxXv7Wqv0ndqUALgNU7FxQA9NsE4HjyJboRovPQXYQMOoiayfn6DPzrm4qf2bQPdtSDA5/J30Ybki7LBlMjn4PJMovGgrufgnf/a4Tp3vSucCfYD3Wog5zqazKvRGen4qwbgVKCN+xTlgE0b5Z6Y7cLzZDFx+cf7G7YthmzGcXXlxMJCrz8fwILExIbfc3tXkZpXOWINEGZhIu4JNUkq9xsr8ovrUscw6UL+kRT4AKghZ1aEREic/gmia1FY2cdupZZWZYfwBQfFJs3X5QMdsOhx+DLqtUhp6oyiD8ZG+TRbBi1O1GfM/eOvRn0kj0R2jXxnhBNSCbuJreNu7dRkZWfCAgtrNrrHT7VzxJrWw9qUH4hiV7gbSI54a8xY1U/4lqYfyKvhwBfS4lRvvdcBCIrY1dWMrtz0h3tIzTk6MtJ8IUKmPeTupyv+DxDJ/zI8IQl34g0PQ58uVhHJ5qmzrH3KcUKbuqZl8YBp0heze8VoR2VGzyejubtJQ2s6NqfrJy1ZGAmc5lZZoJ3D2C1j0hgvR80TqsslEayBYkDdsoG8jXSPL1OYm/PWTYRZgOVYl5EgWbTikqdUfyX5l9rdmjlVKcTm7d14uSpkSyA4Sx4Y8c7NIfPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In commit eb1521dad8f3 ("userfaultfd: handle zeropage moves by
UFFDIO_MOVE"), handling was added to enable the moving of huge zero pages
in move_pages_huge_pmd().

This achieves this by setting src_folio to NULL, and adding subsequent
checks for src_folio being NULL to determine whether to perform the usual
move operations or to simply establish the huge zero page in the
destination.

As part of this change, when installing the destination huge zero page it
invoked mk_huge_pmd() on src_page, correctly.

However, commit e3981db444a0 ("mm: add folio_mk_pmd()") updated the code in
the huge zero page branch from mk_huge_pmd(src_page, ...) to
folio_mk_pmd(src_folio, ...), where src_folio is guaranteed to be NULL at
this point.

This resulted in an invocation of folio_mk_pmd(NULL, ...) in effect, which
causes an invocation of page_to_pfn(0) and results in the installation of a
corrupted PMD entry and undefined behaviour.

This patch fixes the issue by obtaining the zero folio via
page_folio(src_page) and feeding this into folio_mk_pmd(). This retains the
use of folio_mk_pmd() whilst avoiding the memory corruption.

Additionally, this code path was not updated to reflect the changes
introduced by commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of
the huge zero folio special"), meaning a zero huge folio was installed but
not marked special in this case.

This patch additionally fixes that issue by invoking pmd_mkspecial().

With thanks to Chris Down who exposed this bug by adding an explicit test
for UFFDIO_MOVE in commit f07254dce67d ("selftests/mm: add UFFDIO_MOVE huge
zeropage PMD regression test").

Fixes: e3981db444a0 ("mm: add folio_mk_pmd()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/huge_memory.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c17965f5682f..de2a775590f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2796,8 +2796,12 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
+		struct folio *zero_folio = page_folio(src_page);
+
+		VM_WARN_ON_ONCE_FOLIO(!is_huge_zero_folio(zero_folio), zero_folio);
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = pmd_mkspecial(_dst_pmd);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);

--
2.53.0

