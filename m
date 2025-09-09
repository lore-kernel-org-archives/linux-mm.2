Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C81CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 426388E0009; Tue,  9 Sep 2025 15:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA728E0001; Tue,  9 Sep 2025 15:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251468E000A; Tue,  9 Sep 2025 15:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0981D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB3D01A05E9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:11 +0000 (UTC)
X-FDA: 83870652222.20.FD6E7FE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4708C40012
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JUQtA/sN";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VKoqu772;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEEePusihNpX7da3SzTojd1qJc9pT0Qu9LVSHOZ2qSo=;
	b=5DKJCLGQMITgk8m0OoTatz/qLcImfxkId42hCr/TaK7EBDFhRbFVvQMFdr3wDuDLSlHSAt
	znkiaXMK8idsa0hs+jqYYKHljyV6c+8jVb+XSpJF3yzcIja51GRQjl0iv8eQMoPNVM7D24
	/eEbIe/nl4dNM1ZYCEkFLixCgLPtr70=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445008; a=rsa-sha256;
	cv=pass;
	b=5ZjSrAjaxrafSEeFkwHaOPLgo17IOdPDH5NNdvEDyWYZaKhaCeEsPWmfHk8qoEDPw9ol8x
	31BHo+f7SlkvtnJCSBymyM2wgOPPCIt4f1I5ke1WRz8NIY4ZfsATHdro7u6G82FO7+Ljg/
	5eWPc4Pb6K9S7WWMyN7a/JsHAJ3xKF4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JUQtA/sN";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VKoqu772;
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtgWo020291;
	Tue, 9 Sep 2025 19:09:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mEEePusihNpX7da3SzTojd1qJc9pT0Qu9LVSHOZ2qSo=; b=
	JUQtA/sNvI2WozhnK2LYC2tdBRicuLLjn3dmXbmj6oES5SxAduBx/jvMlB5DjsLH
	JkM0EirAHiLSRYQ02GFnCmxHFYIbaHgC+17KXilFA0538WoVkjyo1bGoq9vi+2LZ
	GisTZJWIcUjLywXlpjk2cilVinO6FHevI/pRcoLFdwzCPhk/yoivIF/RTGVV/kHv
	WW3p7/4peGwA0hM4qglKddcRc0VY5SP3pvtN9i6n7yj0xd/LFBgoWshSHYL7XrLj
	XSu8q0nik9JZZrSNzZbO7Ir6DGy/l3PgWyiAtbmbnKT43UO4iIixBv+Szvt7eU2C
	AwXynVBHMoryS+qJcsNyzQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shtjd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:09:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589HFIqr012871;
	Tue, 9 Sep 2025 19:09:54 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bda8ett-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:09:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O//kPNLdBtcn1jHxWLrnlA0f9+/95seNopFsrR+gscI9X0Fj133TJtvsHqY3dcpGdJyavGk1CYPFyRQt/sC+f8FlpIvJtnp/LY0m44Q7oYuKA/s2IWuU1g7z6uqnKgYVLO8cL2rH+2lS1zi4zmWnt8K3pnnvqRBa+8Y8ZKghPQQeGN3nm2uYPx2cHHSXUb/W7eJceYWQMPmg5tYkmAgZUkUb10veZLsjjIefVrsrtwPMY256/VnzO6y9D83FSo/HsJoRcqOJh8HQOjzTIBRuBqiSThqZesTXl3MjHQd7rOkF6y7wGstl1bVExMnZoEeM10h1C8a1dwPBkoQDyHXpoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mEEePusihNpX7da3SzTojd1qJc9pT0Qu9LVSHOZ2qSo=;
 b=o3KzAv6VTg1EZW7OQ2aQk3DFF2RaQ2ZH3Y6YWu1wKOp1tgZB4tz7VMzp3JGVAltfZSJ4DLcBv8ds2sSaff9kDBfpFr5+bjKC4fuFvKqdU67+ffxQmYvrW7zYNsYjjnoAlFBje6aUdXuaz5U5qSFsyaL0FNAjjP6YhVL9/GwswhhciNEGE2zIvGwOM4S8mONDdbgBolurxoFayl9Vqi7HZBAkZ90kfFmicUY2b/OPdMTBOuYQuPWzbQArQOlSSfhh1rlVOA33yWArDp64Xv4cpKMDoZYGwtvGY+3P4GAVBWT6f5zpJQpLlVAwm2r4yRSNMX9Y4z8+wbnNrSRbV6lW0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEEePusihNpX7da3SzTojd1qJc9pT0Qu9LVSHOZ2qSo=;
 b=VKoqu772YXNGGMfZP39syUznHfm3GWqRexVOk8fmwKB2J8NLN7nXB1tt8bBBL9HyNZKzrro8XC8rBLME0EPwz7Sx1Ik+CTXuu1FsllowpOIE2Z9VLfYr4JhaczXnLr64H+Dy6/Dh5xZIYsK9UQ9e4vlrZuT6bVMmLPrYHjQaz+g=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7052.namprd10.prod.outlook.com (2603:10b6:8:14c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:09:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:09:51 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 1/9] mm/mmap: Move exit_mmap() trace point
Date: Tue,  9 Sep 2025 15:09:37 -0400
Message-ID: <20250909190945.1030905-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: 0468cccc-efa6-411b-937f-08ddefd473de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AUvlZRkqrHPa9FsBX4NjqBiqbQmsXvhzBtxFYQoxxhOCOHlJxXTbhxccMPMc?=
 =?us-ascii?Q?IiMiN04NhWrS+8C4Ldp1/Y+jV6+feZ4fpophy+1iGibRnmy1LukHmHwLF3OJ?=
 =?us-ascii?Q?jmSTLqhhAE5jOmOdQ6zO2NKEQenPlxUJQ8wRnrvTJMZZXKZAxIlwHtgWWydl?=
 =?us-ascii?Q?cMfAOebkurOnQnAj8l8Mcys6VecGuL4iLv+l9v0ckMxn6aiintg7ujlYSjDw?=
 =?us-ascii?Q?cbGr7dFgQd1cbXA5n869jkJbDjfWHpUmcHg82qWavSEUS7Q9zMMZiAeiW8Mo?=
 =?us-ascii?Q?TIKpSbxUiX+7XfRKExSUN5DdS5sGHHYAQH7f7zvmNBKa/ndqQXqeqT4SKzFl?=
 =?us-ascii?Q?UiPKg4Ti5lrS2f+NL+dIe6QeedRtamJwpNERNiQJTmhoDokDnn6JxG0cnsVU?=
 =?us-ascii?Q?Ozd5a+MKklWKa7ssi5KgsRvvKJyr3DHSMZDsZuD961SZ/QCxOGFAFpuYUVEd?=
 =?us-ascii?Q?mT5LlT859/+vy7L6ssomNOcVTRS16JJiobOAdRLPjV/nSjXZj2YKUkZR3F/N?=
 =?us-ascii?Q?ARyRNoZqmhX74m4KnhBgkgv1aVOKpESASiwsBJY0UYKk9PhtoRJd+RIxQO/z?=
 =?us-ascii?Q?rOwtQQietqK3N3vyH/TtDw+VgiWj3myRv00eTKo2xnkZCm/YVga/CgM3TYIN?=
 =?us-ascii?Q?4aq26720EPXyeHTV9jL/as0jRBEnWZ4pWzptdD66wo2vcg/X8KmVre5oWuuq?=
 =?us-ascii?Q?S9A1o76BYTlAQx3wjXmEhOJFUY4wnjL7FVppgFGDRGUzSBEhG2uPIYgbDmEi?=
 =?us-ascii?Q?hT1NJTPR0UQWo+a25/J2rS4hLbGcAKeNBaFZuPx8qSj5K8ZxYGuAMasUFFIL?=
 =?us-ascii?Q?k2dPwxVxuuGf2w6KJEY008gUUBG9dHWSV+Yp9v0xnfguYoLkzU6t4PlT+DWL?=
 =?us-ascii?Q?dktQoKHpjh3JSBupFu2b6rT5dOtRq7zGz0xQfdmHIhft70zdriiZuy9Zr1zt?=
 =?us-ascii?Q?mAqEPl79fVy+AXhr6EVdR/SgRTlmf0P9xWKCbJz7nA+48Ho9ySv4bAcC9rCQ?=
 =?us-ascii?Q?62xZp4dSCM9WM1fS+mnlOMyNBzN6d3JRoZhdLe9O0y/wNwWDWn/gtqPGe7Zt?=
 =?us-ascii?Q?CF82UQJjmAtcxYnZlGQOqFkUWUGx+9D2hBuW6i8HYXCoV568NYvDyoC9UUq7?=
 =?us-ascii?Q?hahg/VSOwRHJ+77gG9rIQP2SAC+opOJ3kh0S83BGWdSJhsETRVMBbiQvuTWd?=
 =?us-ascii?Q?qgXXAzbSxRdOl/9LOG7H+/fPHyvAHqzkP+t5cIKv0Dv3yBHOXjf3pLltpsOo?=
 =?us-ascii?Q?Nk0h3y7IKXjTNDHsGdD+ODChbfTVywN9s1+uG1Ler8d3g6iyzoOr9oomkvwQ?=
 =?us-ascii?Q?YwAQdCCGLD4LR+a3GJLmgHnxBQmM0puaT3l4UkokGyyduprEZmfV20nJVNGW?=
 =?us-ascii?Q?9JE6TXQPB8qjUIZeWVZ0F+OcLWths9n9929c5ozaOffKdYZSmDC+gk2HGL+A?=
 =?us-ascii?Q?HKgz9qMRjVk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R1ZzvYAoEHU7FgFix6jKNbpjWRdt6/cjSP8swLfHx3CnhFDalq2WS9B271Fc?=
 =?us-ascii?Q?kvIhs4l/eKYkPp/hhKbu+Z02YjZVZ0PWGKx3LJZpqrcDNmlOFJj94d7oSXnh?=
 =?us-ascii?Q?DsQSB+Ky6XvZE7+nX/XpryoSl4G3mvc7N9+Y/bHp8AI9UOxKRKv2Ifjw8inz?=
 =?us-ascii?Q?4HoG3FfL+9ldeyPdFKF5zcNUg+tGCRCUIP+dpSvgW7USyWlSsYbOMPZHtxCH?=
 =?us-ascii?Q?6kl845cda1eyNTgC5RrIFVwMm5udYko+QuVts5fgnqbCowAqGEH1x5maShAR?=
 =?us-ascii?Q?hVO/L0JNLJ9GuM7GGQ/Hq3b2HDY4pgKmRouqntJ7SjzQYT3s62VC3nkK5JNt?=
 =?us-ascii?Q?JardH/i0jNwUqfVpjmPgLR5BF2BmGEQMvcTz/fBHk5NIMhhJo/XJ9Ai3AgjK?=
 =?us-ascii?Q?dxZdnjnMSrodXiVNhLeW4osSoMrA5BSiLzMMATe/3fd5VGnKauqkWxaU8w28?=
 =?us-ascii?Q?VKF+Z6ru3Txrgy+jpKF5wlHu/vkJB+hwTASkEySO+y9DSlKHJiPYp/JWE6rA?=
 =?us-ascii?Q?+qHsUt04SlkUzzPqW82Jzwa1+0V7PREgNGIH8h5xdgqyJD7vGcqXtmD8GXUN?=
 =?us-ascii?Q?6AxBtWwFZ9OEjYmynMAgD8CLZyeoFP+7YXd/86wqizZq+AaxM+9SfrxXD2V9?=
 =?us-ascii?Q?OY+7mT15cmCZF6zLGC4VAZClwVdD9ZnpAboW1g7E9BDAiCYt163/ROWeIkkx?=
 =?us-ascii?Q?lkTwd1WJK3YkQZJ3LGocK/U7CjgpbsdBwMuankdwio3WdxkXEk8abv9ZLJOR?=
 =?us-ascii?Q?NxihCrSY9r2lke4GSNDhCocSN61rgto5gN11fj3CgZ9XlF194NuCyKUXb4R+?=
 =?us-ascii?Q?YiZ6J8p9oZuB/qy/lQYxHJMbmA+0+an6Av+sXpFL/k5bw72jCkHUFRycYnkH?=
 =?us-ascii?Q?QxT+0Ve0iSoPxE5EVIydJFAH0UFiv26O9T2sCNyVLyiYk3tbyUI7fQZ7fN5L?=
 =?us-ascii?Q?pXB8XFFTO5LR6c5j3Ms8jH6JqwSCOVjnTriwpidliPKUY3Fk1mgLIODWMOWV?=
 =?us-ascii?Q?EbcgyfcfVmSvD5I6c0jFEvP5QiOe+24RSLCHLi7+YQibhJ+obtiumAXufnAO?=
 =?us-ascii?Q?dNpGMQVRVooylBf6LMbnw38ye32x4CyYiApTw3dFb5HPmtwR4Q7zo/WxnAqx?=
 =?us-ascii?Q?6dtnDadif2pBtABtKOQA0PVvUsO1X4+PtsWQWeXFCHJ+bzHTJL/pMCpmhVRs?=
 =?us-ascii?Q?E5uRyGcbR6o/6lJk3k2N3ylCMWWIMtft3pvyvHcsS9Jx+zmux4kn5oHmHzf5?=
 =?us-ascii?Q?nNVLRdbIZpB2hC0hfUsgs3v0NH6QY82FijvdBG2t7CwpHfyz2g2SAQvB1nU9?=
 =?us-ascii?Q?mvhn2Q9nxtZUZjVwDsMnO1mt2dPHVeCXNPvOZINM0Gl177Uf/yVxS/qylnlr?=
 =?us-ascii?Q?eEe+saBQhBbgnhkUg5EPHChls8g1APKfb4IcHjl2da8Uml4CiY4GZgh2HwqZ?=
 =?us-ascii?Q?TaPOZ98q6ALXJLwWw03NfScyXPyzCqi3DDrOqUPjkgpGSkb75K+MtUhsv+BV?=
 =?us-ascii?Q?ZqfDFsi3QBhOrt91Loz7xMAZiyZsjkH2UBiBm99tPRKx0QLy+0U9zbB9Qk+h?=
 =?us-ascii?Q?pM8iKVb+fX2FaR74LRkVOBFOv+HTZx10sgzw0+s8/uDqEouMJb2hVNLTbXhW?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EsIPF6utmNfPylShyM0haqBGs82bmJdWJRf0VfCxnEhH7E1pUcbwdbhiHBw7/YVAaPNjeEhBzSaNBeo1M2OBdyzxGtoaVKsqJvPullB412uJ44NnHwvRVrBZgOlckUoBcTsQ48QMasf5p7+HM/bo2sI7DD9OVp1g8LlJVWJ29sEmXIR/4vEEJ65LIaVQllcbNX5M3b8ip1rkw5Cv1lyawsinA3M6RZ7Mo8NjMPqCyrsoP7IwueuC7/RAmQJq9WAUg2gMtarB45NlAnJtIphVCP+yd/yK0fCAILFbz2OZXefxBHeQeqXVoIHdlV0UgPWuDiLIrO54sVkzjn2ZaIrICjf8Fv0/yyl0S5vIkqMmxXtztmDwBj94geiNgqW+BfpmWMtn8SFhv66Ww5V1/kjtkeJMJEUPmQFWbRy23tXxgG4o94V+yHuo8LyzJjItYkBmU31+ssiGHIl5VsTf6ZHxmFoG1ZrfEjGiJdVitkH6VJq9AVqOaUZru8DEfaWXl1Vh902RbLPb3DsU02EUkJ1SrkW9+5DVxl4/6fwv+2hsA41tr33IJIj6DFWrn8WvLP1Aos43FLeohmxik5gbWphNC31J/CF9fMxKna+sTq9Bvmo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0468cccc-efa6-411b-937f-08ddefd473de
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:09:51.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3XvejdM2FEVdKLRKkO+3DVB5dNq3uzOHgZ6Sm44dXeP9+2tbBaBJqudoTueMVeBP7jhGl6H6T0MTxO2T4yNMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090188
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c07b83 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=tpUyc1irQyRqAcisbJgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX89f3TY74iyTg
 b27CS57I+Vf0suwzzYZQ84T+haA9HzLw4X26+3weyCNIpye57tFsYovpbygfPBHshi3ZD9etFTy
 vB6iYzl2hHyZmw8P2SVAFekb6UT9ytuAktgBL4XskMaJ9jnvhPVE2SSPaEWDIj1Ed4BYfvCYE5x
 r1LLk5nEqlvsUOxuK6AY3D3uzfEyGom1sGFUvJAoBgdiS78pUjIiC5IS/rVX5sp0TZ26IdDtHpa
 o4NxFXAdHSE4bsgomy78XWJDOkP6MtDz4hvUI//g0yHU/tjJ0r43Y3W66E08zo1a4yOm2ClHyeP
 vSCpdpaonn/mlWzOcm+MgbMeCn9tQxN2AWe5RFX5hxH9q2I4qYfVt2fDUEeYyX/4+CFEpfNhaS7
 QgOv8a+2
X-Proofpoint-GUID: Ojz2gcOysINMSGUMXzdtOImjABRLib_i
X-Proofpoint-ORIG-GUID: Ojz2gcOysINMSGUMXzdtOImjABRLib_i
X-Stat-Signature: 5yg94jz6w5qpdxh8y9xn18m19rjh1yx1
X-Rspam-User: 
X-Rspamd-Queue-Id: 4708C40012
X-Rspamd-Server: rspam10
X-HE-Tag: 1757445008-16414
X-HE-Meta: U2FsdGVkX18uJgnwoaB4VkcRq05U2UHA6tIqG/4DxYqPI/6V+iwq7mR5gj9xRCDSN8wsPILSGakfTdSmmwgjXgEXWNMr5t5w7EzosMbI8Xdo89EurPlwSOJMzqsY/dVmyT0zDoGKBv1/IjmYy1WHzNdph+koHzgUv4UksVYqX66XYmMVZO0rxunLROsm2tIaaYpd2hUgZ9zhZXoZfHnS9WOnRiWqNA3WzfaRM5v8NtBfuwgQwvYAUggUbRIyGxqPcBAMh1VSBhTDuLZWgfysTwM0piT0gzjDF+HlnmeJ8rPSYvtOTMU2hz0ID/HKKIeaV/kworeZCPns9HI7WH00GA56ADS8wbPA0VlXX1Mn3o8/L9hRdeP0g0IN/l1oYkq4+e7KCFyN0tkE+Q6ovTtCPSi+zlVzUrV+EXSWx5oYQ6+DUnfKmc6YRM9ybaRMerKhLSIP+kHx39SCYgl9OxFT7Ke9UcTcF1Cggha66Hgw3gYEAixBSvg9Dx1Sr2m+KloB3Q6V8PJst6ZuY5Ot3qDEN6ve6rdKcUHIagIwEr0y09frcs3Z5PlKrQKWCW3I67Yk+7nxIkoIdPb/34oyJm1BjtvVVhZyv97gs7luPah6M+me8Qb0BteVWXk8PW+MjV4RTdXc6bdIlqvww2joqtsEqaC5F0umdzjUwjQGJ1TvMq8tKSD3zQ+L8lpXXR4QMUq03d/WgcLayni1SgUqDyHx3e0vUgzrbjtagvOeTKN2Ku6nzx0gY1yT7k7+14y2586LvLRiQ4gcavyA89aRqPDVlnlLsQ2Yd/LuT8/bkrCfvfUNSOJQgj1CxnqFjxncIhAlNsEIKinGJOwUAo/Mhe7PzqDD82PnbydhcoZdgfyLW6u56Ud7Ify5ZSUGh5QlGoYDb/PXkyGn/pic9/E0GJHdnT1IQf2+Ytq73zoDot3kGAQTta44iEcuKRhOArpauYNgu9HnJBgKsPmFOUzPs8p
 rq0tgGuH
 JVA3PPAqLs5Y1DKxe2NYjPfm6n1MpjAzEP/w2jPH/GC+uaXuuq6ORzc+UzKkoDs/kkOQJ2zSRTQKSe/FM5w7S0VYyAq+gEEmd6oBOphEnXBNfyTm9BVMnMPPxcvWXnm0YYJA1rplf9X+EoRIw+3psLzEN12pNu0PBhOyqQPGjKTvSdJBqf9KUx1o/Zn9XylS0rQN1pQM+PlYTsjPOmu20gOcVuNGvO5UY2DTJSKNYuStfkyBmQ0vIpnxY3lri8frjLChW4j6tpDkbyyNQW/w5e34hpbMFPMgSFHjaUw2io53qAsH+l0uItk3ICj0Z+u7swLaF39CfdKJuemQPEwxTf4aooEGJ4b+quyOuSkCMe2134+ZnkUy1ht13q+Njo8VHv9ekA0jZ/7kkXzAjOxMXMT97+Ixs0mFhZmelP3Zf9UEoSVNACCK4rdPAFBMAVL381D8P6AwriYkxH3AMHq1bFOcbNEjHfgkYdPlzDHys/VMYg1tAUAbbONj7Lji4XElAqqkFj/iMIShl654jNSp8lUd0saTIo6Kit3zCOjdEA5bCJhK/JE94vyEk+b3p0ywDPY2VBcMuXoFXru101PnrA5Ddky9QXUGsP9hkVtbimki/vOEy8Im6CROjBrjpP4gbag3LUBmYbNK3GSZgWsLRIPrACkaZeVoJmxJIYarl2ZVOBN2eq8OYZ+QMl5ghulFha8vXhfb0WaUyZob/HE7YxTNGsNXhLBp10ZtxcpCWWeytBc/z7HU7v5Yii9f4m8IJnLLebE2+YTGc3lcmGgFnB6/ZvgHGeaS8CK7zSf3c83rXm2QyXwsyomzVpvlefsbYEBuDKTpmXih3+GPhfoNssRmJ5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the trace point later in the function so that it is not skipped in
the event of a failed fork.

Acked-by: Chris Li <chrisl@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d5..b07b3ec5e28f5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1310,9 +1310,9 @@ void exit_mmap(struct mm_struct *mm)
 
 	BUG_ON(count != mm->map_count);
 
-	trace_exit_mmap(mm);
 destroy:
 	__mt_destroy(&mm->mm_mt);
+	trace_exit_mmap(mm);
 	mmap_write_unlock(mm);
 	vm_unacct_memory(nr_accounted);
 }
-- 
2.47.2


