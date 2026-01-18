Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00C1FD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BA806B0005; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DDE6B008A; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41F226B008C; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 294556B0089
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:51:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8160140562
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:57 +0000 (UTC)
X-FDA: 84345374274.06.46EC64B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DCA440002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:51:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EP5xyaro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oXA0Pb4U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uZ/BOv0AM9UPqbBkqCuKvXvL11F1O06LcIEO0fERKPU=;
	b=wH1c5dMbFVMHa8fqIhQVn3/H0A/4LE5uDlVApOEz5HRxMeZaQxnoYtlay/Sd4Sxn6zcEUv
	J0p2f/iCg0x/J7W1hYBuh3OViUWG6kQ0gby1hPtdORNpgfFzGmGBq3Yb8MIsTpFJFeYyQd
	sA+3iDbuxrQFflTh3TEKV/7LqlXfmcY=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EP5xyaro;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oXA0Pb4U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747914; a=rsa-sha256;
	cv=pass;
	b=uqTXih075oF5iV8dqusu+EZm9fdPCDAsK7LjlhcEV+zjafwvouIPvdeLyRr91dgt6jhGl9
	Pwp29/pEhvhvhi2ka54uPJl/nmAH3BNhQpxg7URCtf22kYtpikUxOk9pgpM0IDTl4kkUjN
	B1TigZCwtyytL6yzDIK8N5fxPM+LN54=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEm6aX151012;
	Sun, 18 Jan 2026 14:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=uZ/BOv0AM9UPqbBk
	qCuKvXvL11F1O06LcIEO0fERKPU=; b=EP5xyaroaeM2vivgActiHsP8RyAVyICs
	DED+GwTSawLr0m4CoXg9e5D/2bgDD3f/T/09hxuiQo4KZMrG6MQMzkM7phMhe1vT
	q2ihmAUegz9I9Oe3fzr9lBV8R7IZ59BWx6DeWjI/P/kApfmiyVIunrI+UP19InWx
	kd5XnrFQYOS5R27NWkMkBUwAf+fwhT3DqwR3GPbk6ZSJ/RkoZKLr3NlSb86NMu5y
	Oe+/ICZhZ1HCgvYT9HYcIj7vsR2l+Yk0YIj3pGgFaUZyEl7FXI3Tk3GuQxiKFCDg
	4L5BFv094UntD7e26SJaBav3+g8h9drszT9WPN/UmFjv1lhdHjRoEA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa1b7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IBt4cd032145;
	Sun, 18 Jan 2026 14:51:47 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010064.outbound.protection.outlook.com [52.101.61.64])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7ctx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:51:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIIEdY3JCwBoBa7obYS1+ud8SV6D8zfGZQV+y/HOn12QEjfRBVAxDpCp3pwFo1DZSzE65DsSl5FOt7/3BSCgg88tIh96LiGlzhB18eo5M+0qEMyZBPsGJDFv+HImUykwItN1vmst6KmX+j4bFeabuRuxnAPk4tP9Up0Vpx+Upz/QtB1OWM7qGo3g2PsGYZHTcz6sXXkdbUy8SgytB/7BJsB1Q/wfDQ6UlAtvMgnLXDEara4G+MP/dNs45YJoE8E3drl9TfbFmhYzEwZAE0PGmsjw5GlP+E3n9//tpo6HvJyTu76zmXAqgM0KbC6Iim9ouIXKvjXLivawOmOzTF3ujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZ/BOv0AM9UPqbBkqCuKvXvL11F1O06LcIEO0fERKPU=;
 b=JvxLZ0d98G/ituUEsCmwDpvxa8TYUc3Ba185oQnZMlDgeh/HfPDKxLRcweiR8FIcuHfMEubTvwlQdrp6dxyCXXMbw6J6EPL20fTxcUMph2YV8vSatc1dsv3HzFNgvpKC0OYtLCQ57JRkxc7ex4ptt1F0LTtqERGZAtfJFWovcrRp0zSBfdaN1bgzMITE1UnCqXMvrcjXWHwWp1RBvRnvPzkruzCPa962lljQ3a3PU37ASQCJ1s8ooyHp399NLs7d22pvUlhG55LHJzZiwhWGfQ0FesV0Fj4k6dhwz/VEf0NgtJ3cJqwOPfuVIQSMcTaeJmAZs7IMwlAcrLMTjyGBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZ/BOv0AM9UPqbBkqCuKvXvL11F1O06LcIEO0fERKPU=;
 b=oXA0Pb4UdSPK29IQKFfcrMTcN+S0Z1HHIelzCfGwpdxeuJAuPM7b9ondfCQz8cBXjABiTCN7ZEADdj0ZtgChvZjA0IV/FT+TCJ700MLJIhH03mTQ7091TXOSMdZCy8d8QlwiToFoWn3B8g6FrMWWSybHKTk5pEmaC0BTSbVLOo8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:44 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/9] mm: clean up anon_vma implementation
Date: Sun, 18 Jan 2026 14:50:36 +0000
Message-ID: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0470.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::26) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 014df47d-3246-4b9f-87d9-08de56a118f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jp6KY5hPTP/LieRaD+Vpf40VeTN1FyTzxyzlwBBpMXcmUtvOq6YXbUYBNDLX?=
 =?us-ascii?Q?GbOu6GlDwqVz99wNfpM1AXmX5j8TQkGYdMC3HBOdku945wCM8E5WZeMpIEeR?=
 =?us-ascii?Q?UJ1sHdfsH32QsEg54oYAY9mc3qti6tJ4E4wjNvNmOpHiccQx5rm/BYB/wyai?=
 =?us-ascii?Q?BZ2AkNEdRA32jydLT7NvS0bCbhCEgz0vxGokSE9yXIIczmEaQt8Q9gdfqDe8?=
 =?us-ascii?Q?oNB9xoWZ442UytebFzhR9yMZn1dGAx0pYi/4ozVgDLMwNXHxEC8+b/61PU6O?=
 =?us-ascii?Q?CJfapjvHb91l0rsJF3sp7PqppNn8raBEhqzM3ZMBOD3VODHQQhf6Eko/s/dh?=
 =?us-ascii?Q?AuN9j0P6Bs4Bs6PUcl7z6jeOpG21ALHf/RlPZNPDor1NIwqwf11eZkaxZBbs?=
 =?us-ascii?Q?BN6KPGVV4UWf+8sU0p+CHZNSHgT+y48UObqmB6kbJLLlB+KQQppjvkYQeAQn?=
 =?us-ascii?Q?aHVioub3jU8UmwotCSS1kJ+J0JbjZ8aNzdzrdLx4vFYeYo1zolG50vGit02t?=
 =?us-ascii?Q?bLoqOQjHt0OHezbcWW14tXBaZCOh64+xeOATUjhknOvl4wk80rpbRcvFCT44?=
 =?us-ascii?Q?d8gVtiT2WYNfRb9dvLh3FDL1a9HScK+hmTytl2VQ6D9z1oc4Nhh/52/zM3fn?=
 =?us-ascii?Q?tnGQLE1kVf3TxaovZ9CelKgYHlFnG8KwFAXXHXe9wEm+bfLlc7sTE2DqwBWN?=
 =?us-ascii?Q?Zu8cekaViDKU7UdiOzECLQUdE2NCYcY0Z+agyGSz4zec2lIwWZC1BKUO0zFl?=
 =?us-ascii?Q?z+WKRhZdQGmo8U7kZTIzlQnTRP14L9i1D+O8zUAKoq/Reo2U/noKjl9BwaFn?=
 =?us-ascii?Q?pKrLtEn4wxh0fDxLY4Lt62Nr4BccVhYVw84+q6+zMZhUxtnJa4/zE5zTYI5b?=
 =?us-ascii?Q?2Pqw/J+HqNFieGkduDHSt7dKkc0awN+4K8d5vQQVfagc4GzmcdGJVGpgcOM3?=
 =?us-ascii?Q?98FkJGGHtcZcH0DMGSLY7y91Cip2Ieo+zuZUvwrnrMwHzR+UULKlFNV10kFY?=
 =?us-ascii?Q?j1Y/kNCJgf7gtuhroLrhyKAxpbRgsiN72z6H8hffHbz3lzMeqR4SG5UmR7fq?=
 =?us-ascii?Q?uKoR/LSqiX3juB2uQKhUXdBm8dNDyl9dNGgksu/S2FsZHrGAQUrUq6/xk5YT?=
 =?us-ascii?Q?h6QhX09UuUIHWP4ksO0aL+fFwNnuINexxRMr+fgyEN6j9YFUEfFo7aJAFdVc?=
 =?us-ascii?Q?mLjb2mDdkhlI46tjEXUM/9uuUpcZLWBXeQiT2jR9JD6GbJngt6PvxlKbqkDW?=
 =?us-ascii?Q?9HdJdDwW9ulXd4w+i7FF0MPmjMJTvUIJSJDxM0FJQFuUG9fX9AmVtkPlPU5f?=
 =?us-ascii?Q?IFDjJNqoqKbFAM0Xpbk/qJUjm0oosDhYLx0b6jgMhMRv9FO9Ay4dzseGaqFh?=
 =?us-ascii?Q?CUTlHOBEKaplPtNH0hePpLpWO4MTakL7iLVWxOtWf4loI/Efio3CSjvbQP+R?=
 =?us-ascii?Q?NubKovuGMS3BSyDJJtqttzG1YInTwKVJGwJbYt5ucGyHPLcBoW6AY0m/myHM?=
 =?us-ascii?Q?rcHt09bngK3yFFvFZ4F/WKya8GOPgR+zcSCnjwH6hnGhx+EwReQ8oXad+o4t?=
 =?us-ascii?Q?mKJFAMqOAd9S/MyPo+v7qBzvqgLs+CNPrgigGkUu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ruTBYw1ATvh7jTIHQkrI5KFSrkqkAYRPzogJoy2M4xUiEO6jUGeVoOIjnux4?=
 =?us-ascii?Q?JdXP0YFbnYzJVdOrsNk2R9jT3LElSN+/VW1JxyOzy5jMahF4jVJPHrVh4qjJ?=
 =?us-ascii?Q?aFtWCZdiblNkwCJoBsmZMY/SpHWu8KMHEmjomtbnlNLkhWwL9JWVPyo+K30m?=
 =?us-ascii?Q?F0gBJEHDAMZ4QTtBHfM484mLMGG0//BpGUvvAkl2qfFInnijlsaJdq3AV/gj?=
 =?us-ascii?Q?fU1Pqz7RNX5veWKIUKbZ3Z73RA6WiR8g683DWyPWPWJ8O5B3uO/mdGO4AisS?=
 =?us-ascii?Q?JYvDoCDzKj/D901GqH9LqYHVQMvsobkgHy3+LWlwtNikCDWL2kgaQEZhXtj+?=
 =?us-ascii?Q?d1PwjUHIdtg47GpYL/kjwLoc9VVydNzzeYtpbOhJVcfVIBAAomrSFMM58pjm?=
 =?us-ascii?Q?Me7n7qSoXB1K9nnkAE34/mf9SxjB7vbwQgac+gim6DrGCvb3gAXW9GRGlDjZ?=
 =?us-ascii?Q?dNv0WAuYunDsomvLOW4DKcYO4XkC7p3uqNJOZl3UnlsG1haqapBtDI1FvG28?=
 =?us-ascii?Q?b11QfAz9D6fftiZM4GtUImBBBMjGkb0bKqS21TaNA2TGWZTePDjNqtQUrNf3?=
 =?us-ascii?Q?EgDDgeDm3q8EODcn+nGWEXAhizlMRif/mmqq1BZsmBqHDz7G9W3CmIfgAa4h?=
 =?us-ascii?Q?AfzSSqpGMp7n7MGsA3dGGP5eVQAUS030vFvU4DlbvennEV+Z63THqMG4CCJD?=
 =?us-ascii?Q?vo7HxQgF5B+u9NcRGrru/7L0ZUTytPSG17IlWtn+8pYxOGNrAKtI2cmREceC?=
 =?us-ascii?Q?jXDt6jjjDjEfHolD2jXjztBnUxIY1CCE20CTfOIS44LPULoNjuTaegM4W+rt?=
 =?us-ascii?Q?kbVP3PuBhVL/wZl1IZXcEQ/A8Z+mUOq2ClOCWGuT1T5bBI9O8L8wgrAM+eo2?=
 =?us-ascii?Q?tIuJabVj5ACLQt2Ckw9IEOXOUYW8veVchnEpgrHP+QHxj5aqXWemDCbldMEa?=
 =?us-ascii?Q?nk3jRQyvwDmjIHTLbGINAXawkKZNEB1Q5h4ue1NOn8F6ATrHbh+Dx1PuX/Fc?=
 =?us-ascii?Q?6qm3hgyWnKQ5QirEGV719JCrTo1AQaXfAXRFVPJGaTi+USFgGt97ZrjyTbu/?=
 =?us-ascii?Q?WeBrbXRmSvLB5NIRy5bm4Q6DilmjxfKjnzouEa0sCmwTc6kAoBjA8VVceqyR?=
 =?us-ascii?Q?7om59L/UI/r3R3OivV64ht5PG9Dqm3tJuhkfGXyuIDT/vLp/tliur0LhBut/?=
 =?us-ascii?Q?RcN944ZIOddyBWVNHD9aFZ1oS1zSjZlv94ZZpUkVIq2TxS2ESAsKrCQx/qz8?=
 =?us-ascii?Q?R6sM2jbC4S4KscCknXv7vYqhQy71YXg2Ggq2+mG86S5mhuAzo3WUND38/bMr?=
 =?us-ascii?Q?enbGS5i9ZtlKfjV37Z2pzBbOrW10WP6GdXI071UutxBYAIqdhtbaI6S8o8A8?=
 =?us-ascii?Q?VU4FudCMTsYUQ1GHNrGaVdI3wW+Beh+aeCKZPvBPr16/ypDj1gnQePG/IZV7?=
 =?us-ascii?Q?/4IzFW87/qCxJaGSf7NshloE/zNWlIdkvMDjK+stxvQ3qIFWNv/8+vI0/IJ8?=
 =?us-ascii?Q?I2sOG3lRJKelC0gO71vF2nd23q+umtYJMLtzjRUHFsSbRrQVj79uaHg6wEOI?=
 =?us-ascii?Q?zD2Ufc6pbbuaDuOZ+uEokvFMuzcS8QWhNZmUhLtgncoNZDRclPKTUxgNStkO?=
 =?us-ascii?Q?7k0WfCjCpxPF26pQ+1DSX7FF6xnyxNWiWbXxMmxkFgHu53zCZwfvgt8jaM+m?=
 =?us-ascii?Q?Rq02O5ROtlpfCI1nYIds7LyySJT+dnKxmS7NiMzM41noyKr9jt1E6tTPGnx8?=
 =?us-ascii?Q?s7I1PXYoRyLM2hw3sevEChw8GHK1Ntk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FKQ8RdWteZt8VA6xrDDhMDQ0RkoZWhDwik3XKUID2l3AnApSVyHIFO+WKR0datNBTwKJ21toE5HgMTzxP5MgcPsML2kbT3mrPjSbMg+r6tL0caKzCsvbfWipEllcJ0WxhED1bfSjeWSunzN1AAgxLiPK6/McgCQbuvDK2pB+qrfb2aQpdGOpEd8Hi0gyXGVJogzZvlFUYKmC8DfYfogjz5Ps1Wi8Yth2iv5+SaXltkRqJmFj69FF7cApzXViw7wwdPi883KRD+KdLMzUh3cXuswv7bCFRJPFMBAmXhEnx0KdD9CF/wOeon6jFrdSr3/xzht8SiLR9rSkE0jiRKdumL1fYzU2GyBJrPpOFIC6yjG8BEIV2ZhkyD68aAI8ssF0qP0Dsf9k/mrmmkjzsUnTV+g1P7Ri0CM/OXvYRbI+PSKgFeDr2XKfruvtJicpOAuNIsVQ6s1VYlR+/6LQ90fECvczDGTPHd3ZWYTMBxVSSXQMrk8XHkSOpYbpOGyHm4lIX4qHSITTSwJYDopZ649x65ZYhlKYrc7FTEB2aRTP5WZ3uem42P0BfSc9OTsxVV4umYOGySv4V8OgfyYIh/Oj9y6AeyvBOl3+YA9SkC4STlE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 014df47d-3246-4b9f-87d9-08de56a118f5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:44.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GK94+v+beuC1AeM9M4DkMC/vrM8FmjldqXktGKUpphfNnwreQ6IXnOtDVnZsTlQfvuJ7kzgDKaGSZdjEx02+N/vXztw9ocMVN0k7Sg41vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX8wYMI26uhaYh
 Uhcjxsswyh/pgghH8INIuk6hR/HP2Lrakq8b3cVlz2Og7YwOZUic76ruIYIgvccnvCdO2K9ebI4
 pOnoSEj0P5aT1Pdz9pzLcOgtCn12mgzbmHCcBMVGJ5aKVI2BYW+qSFBuO5kvvr97BZpWr3ySglg
 0xOVnZgwtOZ1PKoBOuVeJGp098Xo0ZOBKJ1KD01PbgdHE+hPf5EP4YKRe9aGqDdWyrpwIUkYQp6
 SHTr9Yftn0M/cFrlX0+hzaF2lZalR5UZAhi6rmr4v5KjiBSNsDd81IAtJIZtyyNEUKvviE0SxR5
 JJVDj7J1YDLOSQ+x4nyJh36OcMFFDg6GmtcLrmh7IqrlFL4Rv7fIARZcNfN1jRFd9K5AY4HzXLY
 lpgeB4wQwlaA2FF5LdTyatFI/qQJ6gLsMdNdHNO/FsInSHuv/4lwhHNzeVwYGFr/F6WuLnFR/hn
 LO+OfV2ZOaqMgDtRdUcYQlbjoxEadWlHxcKHczbU=
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696cf384 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=TCNhpU7RlrZeGyURkIkA:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: 4Q38x0Xh4O_neMCF8eyZdLIAPc52JcP4
X-Proofpoint-GUID: 4Q38x0Xh4O_neMCF8eyZdLIAPc52JcP4
X-Rspam-User: 
X-Stat-Signature: igddo68khtbyssfpx6rtek5ajrb9sgf6
X-Rspamd-Queue-Id: 4DCA440002
X-Rspamd-Server: rspam04
X-HE-Tag: 1768747914-244258
X-HE-Meta: U2FsdGVkX19o7YMooJ4U/DKeZS1i61i4NazrRpIQELx5VIeptQzWNuukVmxepCTpSTkPSGkf7x1zhigngfHI+GBzzWxbWJ+D3W9W6/0OY3t0IoHWlR0Mfc0u477wbu7tuPt0NEtaR3rtbRdlYcmOTNq26xKd+yE3nWGpXsy51AiD+B2aMOiTdX013/Qru+QDB1BOX0W77PWV3To5e+dzzAufUTxYtej3Wjv02GCfoAtmHpoDa831xRJY+MtOuJEWf/u8N7ScO5d8w+uxe0/AcTmPhFJcIhd+SSrAiLUL+hIESnGf4eqa8DfX8jgrqQZfVvo7E89SMtkbU0/l7GTG7V+F/3azKhqJsT7Um4Y/28Qa0Pe3nkp+Jq0PRoT1bkyE/Wv23XBECeRG9cr/EJpsgyH8wnsspsstHbuB9MLqSmxAE/gqjPpafQ3mHy51BmhhemQDCPHK/DGTXkcn96DuQtmJVI2CJQIVZ1gjUj0Cnjb+vvmhv0fw8Us1EW5PxeI1Sb/eZsCwXHwOvsHCA+0kd0RavV9pO1dGw9gEwhmnNUxVlUafyb6c9M3hP5Dnghih1oFCjHMl6exfuN/HZJH6GsgnWuFHNOX63EcIqWjStfP0NdPih2RbCJ108Nv5/2ECPvC3HiPwz8zKIfIXr2az+GPpB8zHz6oifrXWKlumDB6OtBYUKAGIgHb14Sn0XVtHoQTaNIV7CtQsevpPdNH1eOqkPjZyzN8yp1M01YHBdPMMsgdvYOSfm2lOsFhf5ty5bOjlJkN2qoovppnz8OWnX0se0+ueQRwdB+CK6WglavGorQBg0DxAvKZYa7FTe7MLW219YajZc64VxMgnv+rW/ZXh1nKV4x6Cw2U7tJ3aZbYc9L+Yn3nXe8kqG5sM7ohNH0QoXCHlggkSSId8Par9Aueb6IznXO9HWk0RVRfo6rMv2msUlerGffKrcmb5ZYaYLxD/QpDSfB/8V9kQp0c
 2wvWb2qi
 sv59dKlSoSPsHOkc8kOlvMv/okWtQg7RXixqj55WBSHihH4bEhFWbq7Enkpd5f9k2R01u4b3zfHkyyxNSZaJtGphxfriPirsfNi4ZQ4FHoaWiUAZr8E9mwFboYL6v10gMs28J6HCS7wWJNU+jpofl4iReUos6gN8BJoAnK0O/OOM4P0Fsv4tMM0sdqbnV6xXNox7CH8fRPXXdZFjNmnIQsN8MvpjrRCqZxOFBBKcYMnQFN0PdPSZyMZUQxsjaZZuame2+cWHSl412hiW6iY6yQGcMfnSWIn8XNnNm+glwey1Lmo1iQLAzKHGskRnjNSoxwgDwITkN055ulAjAxFqPF3MiHyJVB38fmlpNjuZfkN7VKeFC937H5+m/bG0ed4r/JwzZ2BzNcgsv0FSOgFYgD9t9+1kalut7pYt9jdn6ka0Enpsk8LKOiCW6ILb8iP8nuWP0VUpFv5UWHjBJEVbY2e37ZeF5EBpcPPLTFgxCDpC90FoUqagSxjGURU6U8TZISgMQwQfjXpVRKRyyFNmCSRfTea8mh5NF7wX5O95LhNlFKfkQxEybf44SuCD836qbpg5QMrTHKqJknZ8TKrofBXSuWKKv1078uN02OIuuvgu9Dq33sQnIqRM/51yrZjHwtnydeQUplpymqdx6GepwHFoZ7IcRV6QjfBxUOwyeuJm+bZWpoAfSH5ddzWJXsci/BxFyzhbqvyjarqiduPScDJX15Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The anon_vma logic is hugely confusing and, much like a bundle of wires
entangled with one another, pulling on one thread seems only to lead to
more entanglement elsewhere.

There is a mish-mash of the core implementation, how that implementation is
invoked, how helper functions are invoked and concepts such as adjacent
anon_vma merge and anon_vma object reuse.

This series tries to improve the situation somewhat.

It starts by establishing some invariants in the core anon_vma_clone() and
unlink_anon_vmas() functions, largely expressed via VM_WARN_ON_ONCE()
asserts.

These act as some form of self-documentation as to the conditions we find
ourselves in when invoking these functions.

We also add kdoc comments for anon_vma_clone() and unlink_anon_vmas().

We then update anon_vma_fork() to avoid passing a partially set up (and
thus invalid) VMA to unlink_anon_vmas() - functions which are used both for
partially set up and valid data types has historically been the source of a
lot of confusion and bugs.

We then makes use of the established known conditions to directly skip
unfaulted VMAs (rather than implicitly via an empty vma->anon_vma_chain
list).

We remove the confusing anon_vma_merge() function (we already have a
concept of anon_vma merge in that we merge anon_vma's that would otherwise
be compatible except for attributes that mprotect() could change - which
anon_vma_merge() has nothing to do with).

We make the anon_vma functions internal to mm as they do not need to be
used by any other part of the kernel, which allows for future abstraction
without concern about this.

We then reduce the time over which we hold the anon rmap lock in
anon_vma_clone(), as it turns out we can allocate anon_vma_chain objects
without holding this lock, since the objects are not yet accessible from
the rmap.

This should reduce anon_vma lock contention.

This additionally allows us to remove a confusing GFP_NOWAIT, GFP_KERNEL
allocation fallback strategy.

Finally, we explicitly indicate which operation is being performed upon
anon_vma_clone(), and separate out fork-only logic to make it very clear
that anon_vma reuse only occurs on fork.


v3:
* Propagate tags (thanks everyone!)
* Fold fix-patches into series.
* Add fix for syzbot report about an accursed partially-initialised VMA
  fault injection error path.
* Fixed a typo, a comment whitespace error I noticed and add some comments
  to anon_vma_fork(), set anon_vma->num_active_vmas = 1 to make it clear
  that we're setting this on a newly allocated anon_vma.

v2:
* Propagated tags (thanks all!)
* Corrected typo in 1/8 as per Suren.
* Updated commit message in 1/8 to clarify when we use a downgraded read
  lock in unlink_anon_vmas(), as per Suren.
* Updated !src->anon_vma no-op comment as per Suren.
* When anon_vma_clone() fails to allocate we have thus far been invoking
  unlink_anon_vmas() to clean up the partially set up VMA. However this
  means we have to account for this (likely impossible) scenario in the
  code and prevents further improvements. Resolve by adding a partial
  cleanup function specifically for this case.
* Fixed various other typos.
* Placed check_anon_vma_clone() before the !src->anon_vma check in
  anon_vma_clone() in 2/8 as per Suren.
* Retained !vma->anon_vma && !list_empty(&vma->anon_vma_chain) check on
  unlink_anon_vmas() as per Liam.
* Added comment about anon_vma's sharing same root in 3/8 as per Suren.
* Updated 7/8 to have cleanup_partial_anon_vmas() do even less - since we
  now allocate AVC's first before inserting into the interval tree we do
  not need to acquire the lock or do anything special here, just clean up
  the AVC's.
* Updated commit messages as necessary.
* Renamed find_reusable_anon_vma() to try_to_reuse_anon_vma() for clarity
  as per Suren.
* Added a new assert to check_anon_vma_clone() to make it clear that, when
  not forking, we expect dst->anon_vma to be set.
* Renamed vma to dst in try_to_reuse_anon_vma() to make it clear that we're
  checking/manipulating the destination VMA.
https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/cover.1765970117.git.lorenzo.stoakes@oracle.com/


Lorenzo Stoakes (9):
  mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add
    asserts
  mm/rmap: eliminate partial anon_vma tear-down in anon_vma_fork()
  mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
  mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
  mm/rmap: remove anon_vma_merge() function
  mm/rmap: make anon_vma functions internal
  mm/mmap_lock: add vma_is_attached() helper
  mm/rmap: allocate anon_vma_chain objects unlocked when possible
  mm/rmap: separate out fork-only logic on anon_vma_clone()

 include/linux/mmap_lock.h        |   9 +-
 include/linux/rmap.h             |  67 -------
 mm/internal.h                    |  67 +++++++
 mm/rmap.c                        | 315 ++++++++++++++++++++-----------
 mm/vma.c                         |   8 +-
 tools/testing/vma/vma_internal.h |  16 +-
 6 files changed, 288 insertions(+), 194 deletions(-)

--
2.52.0

