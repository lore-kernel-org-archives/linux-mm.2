Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9325CD4660B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016496B008C; Thu, 15 Jan 2026 13:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD26B0093; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E846B008C; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7A416B008C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:27:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 808B61A0438
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:55 +0000 (UTC)
X-FDA: 84335032110.13.500397D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE46F180006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:27:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X9Tu63TR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H35MBjLt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501672; a=rsa-sha256;
	cv=pass;
	b=kqVBkashPo4IFnyke+weEhjbpZpSMrag6jBcQ1PYuVQWkQ7TPCtDwzvRYAH/1UYW80JW22
	2v10v9MJXE/uuslViuah/6IfxZL2j8AVVFwFiBWFWxAL4HtBoboXsxYPTtrdTdDYnp32Su
	N0HszUuzGy/8YkxhBKfHRTYh27cxcx4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X9Tu63TR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=H35MBjLt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
	b=XnM8WUOGpu+JLnaTyC49G018ufmtLsEucGnBkt/o8SBLyugiZyNWQANCWmaWpVi5Feo8Kq
	L3yEzlp/I1h8fnDWq9x4OxZSdZWvSVy9HoGk+6ZfzL1yX8Lt04nY7TdyUkL8fp6rrg8VgU
	TVUJwswbkDPuj2DPw521Cb6iZIuunSM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDhMhd1008313;
	Thu, 15 Jan 2026 18:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=; b=
	X9Tu63TRKXV6+/xtKO4yKxpS+geNVjt6NAIcwm4J/hwrI3eSQCsBIlqUNxrVGm5o
	ZU30UhS6/2cpIpHu5tCZnkhdIKpoQNBs3UNiRXProuddcTlICIxQ/0WiEEarPzYv
	xmrBr5Wbqv10ryU1lotLuB8lsxQrc7/oe/nSy55bZD/JKvPoiT+X7UY1tVTkNUzq
	10w8He16b1GPwV9+VLkoosTIzVxiZP3ZTO3tiUT/dkhT5tozvIK/b2Ab5vtRaj/m
	Ewhr5tYs7oR5cPh8XXLfkcujkbztNSLcCF25xpAo02p9QGfzM5LGwyN2yZKfzKBs
	FNllW8WgVUhGdxf+zZIkgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq58cw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FGpNoa032668;
	Thu, 15 Jan 2026 18:27:34 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011035.outbound.protection.outlook.com [40.93.194.35])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9dj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXAuCjJGojxUY6PYLnxeCjqtHG3oEOmKKVmU6AtCGxE9X4EG/01e1wHX3pPxLZNPXo/hBpg1aOylQIm4IrBnPNEINLuKZ/oJzW5antK76gmhYoex9mhyu84MmUtpm3ntvNGtJjYL50rj/rmRJ5nD17J4LEjNj1wDZhPys5G1GDoVmKS/X+x2qbrAQ+xiwCFBMthEstrFBjpnjRA/W6Sosj1z51BqIZE6nd04COXQgUBlSq45vDChD3bcAKxVd0YrT90bLqPnpvCWXiqUDJeW5DaHBSuK/kLLqTrgKrGo09Dpsdp7MmeBLlOhYIbo+1MNr6p2uBqILNTMaG/r9V+aAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
 b=ZkJb7Xb7eIxMsBCieXm3EOOmdE4Um2+E9BTzAjlqOWr45QhWEemU/gWpJFJbq7m04Vs5CngdwGRoaEEGuFXbM4xKvDfgcWuHCCHmrkB+GpLpfew7Z+ks2dAY+oYna1/ghXFufY8WcmNQaxmlVJ2YXmM4L5QQZjzoxRd+TRJ+O/Msrxpz5WamZhaVrG2gDTzEUWILk218ytyHHhckgnWhUbpkKUWZpEPxKcibBYyzP6oD9zq6l6TK5VfZVqJJra1L1X5aooalAdhkYw3TosD7Dz9te1RGOC7Rq1oHGrSscAaeAPCwCk4jej28csFoXREzwh0OmkS4u88eiW//W+2XrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
 b=H35MBjLtNdYG/ADMKbR2hMq11jL7PGU8xvGNTcxfO5LPs9pNpXlBfnWcu02noSGSDp6XqIou8w+KtnHfPbZMbGFyfnCXQa4y2mWYmQDDM0NchjqVWCrPwf+KPkawTHXaqm9JnW/WkFKT3KHS3AXi4Ufb+Xbt+3RuiQUn6QNOEpE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 18:27:31 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:31 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 03/10] mm/vma: Add limits to unmap_region() for vmas
Date: Thu, 15 Jan 2026 13:27:13 -0500
Message-ID: <20260115182720.1691130-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0443.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: c2381931-13f5-45f0-b5ec-08de5463bed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dkAaIPv971oldcrcEn/5NkI9aWbeodDvVBe2gpqgO/8YGFjkoFaLXG/0ICfn?=
 =?us-ascii?Q?svq4iynYCX/pb0o0ZMc+/22eUuDB6yH6ROSyisHKF3jik6m35HsLe7BgJCOn?=
 =?us-ascii?Q?FvsAS4Pj0fGCrALvvMyrS8hR/brtRajKzk7khAJGKNoP7eqMZKhEcSOUBTlX?=
 =?us-ascii?Q?uDUds/uRUeSQXfdjv36xlj8z7H6czMPNTwjRjqGVYYWg3637RzCQFqkX8tq9?=
 =?us-ascii?Q?yGN0Nlr2+nYfCBjJ/kAmeufN9mzytXDxQRJv0Pm4KkH4wSTSOycVloHTBzj8?=
 =?us-ascii?Q?Dz4yUPFTrvq0elhGcjWvMWxMLug2fFdPsALstZvbyjTpr57/x6CJ5/vYE3Fz?=
 =?us-ascii?Q?qDn51gKb9Ok6Z7qNIaS7Fw+sw43CZLLc29o5aj0br1pV6KFydlA1zYKF3MCQ?=
 =?us-ascii?Q?umuhoJxptNDomWqHVBWkV+NCb2QDLzGIkCjgBbUQIfccr7yXv4mBufaQTZhV?=
 =?us-ascii?Q?0MKPg+ebrbeQVstwouJp2LtYixfjUMXeFpyWVYA24V+nEcKCdSBIHKP+4ssI?=
 =?us-ascii?Q?3RbgVb3hA2B5HSePQo6Y+FhlyD4DbOcvAMh5hKr5+FfCN9CbuW9P6Xx3JixV?=
 =?us-ascii?Q?/uA6F5huEDZXuLDQokypIN9dn/9vH6BSi3m+OgPnqgx1O4juBaJA0mxdtRpG?=
 =?us-ascii?Q?nBQHeyZZ5LW0E5nOeAyFhmz+nxh9+cpX/8SzzqeWzf+AKdelvYkRJyA8hMJ2?=
 =?us-ascii?Q?1T2lrrFBNCsvVWDXadUJwACVj+opJLmPWjkzh9KqfscqYZNFMkyKa3Yn7eKx?=
 =?us-ascii?Q?myggWxmXx/nQNe/3Ra34Dy5DxTd5QRVCrPCXWgVcH2PPJaCCsrdQEo1ZqfbH?=
 =?us-ascii?Q?3zhPcJehcKojbSq8S8gTJlC4Fn6mT8DZgb6s8TlPvoQzshufOj74R5B8Nk5w?=
 =?us-ascii?Q?zwFUMcTvhaeLZf8JsX+QQmRBJ5Tb+NPoWhaNlcNsLdFP94nxTVugh+CFmfK6?=
 =?us-ascii?Q?Q+xlEO6yQJkf2gkGHb3kb8PQpaZg8f3JvKJpmLERzwuJQPhyq2YFG2S+bpZZ?=
 =?us-ascii?Q?B0fevPcHRWKWdFwercGGwNmxwMKkVUWT4gn+4WOwYzV3jekI6it0hAGUhJ9E?=
 =?us-ascii?Q?gy8Lca+c8EFY+TNFELE3jwpet+ilFPFF5tA0nrll5pOACwdzoJoswmPhYu4a?=
 =?us-ascii?Q?SOHgkxPbZ5gTsNT/ERv8uVOaB4xT3hxtHoAws1oBUcMmInd1sWNgjE/92jFO?=
 =?us-ascii?Q?4AiRcvlkGxzzRj89vSp9ykLml6ie6hofnbLaIQRzM9zRtcAB3s8QP46DOWHR?=
 =?us-ascii?Q?oQDhB3wDOMw0SmSI0pw0oyWYC8GMi/h2qsTez4QPeqWt/8WmjSEGApfUvw5q?=
 =?us-ascii?Q?n0BqfrI9FtU0owTyNyVji6hrBmjATqsyJX7J+/EDyHVZRp9/d1tl9+3BikeM?=
 =?us-ascii?Q?bBM4pV2ytIfd/HKu5srzuDgdEpu5GpGlbueWXMenQaAnnDwI6JNCb1CboPIa?=
 =?us-ascii?Q?I7pARaI0nkJcHQ8Iz6iZDvYzC0u2f4lVUXlJstbU+qqlm4ktfQZXPPgloHfJ?=
 =?us-ascii?Q?D2oCa0ZCASlRVcUIs/+hTgjk/wGjbmoFL8FaSzVHkoQIqATDOuM/ITWMRyO+?=
 =?us-ascii?Q?Nby752e6TBk2Ou4QH1s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oLFfWqSTQXbZJvFKKf54bk8fuTgRKwRQaDnU/oqySFfU2MiL2PmU1t+dL5XN?=
 =?us-ascii?Q?9NY7zLh2QlMsZoA6X5J2ZvWOd47LR1xOkzLYAL/WHaYnUS2Om6XVuA0c78GP?=
 =?us-ascii?Q?bg2uMmT8huPzBFPoP+iA9myDUj06gTvMTqGcvhtd3kcunVvY2nlbF67rb04D?=
 =?us-ascii?Q?CCAiPaQm0Hv3hm7tOTGpGvwpwwCcNllVXHKaPX5YdgOzxahazQBFp0VgX1Gh?=
 =?us-ascii?Q?9kYi4rHIVpj6pXiBINfpwAPpD+3rEBnCPdphq6J3SxONQ6zlyjyljGeuWoSy?=
 =?us-ascii?Q?rBD6HvGIWybsh7U2nO3rUT8TNPSL7TKs8Ffd3n25Sj76vpsngbIiccY/ks+k?=
 =?us-ascii?Q?BKLpIUmZPfen0T0B2tevexLfE0HvWws99nYSfs7OMxkI18dj9tDTDMJ6KQFq?=
 =?us-ascii?Q?XAEuhbUZoaMK3lQhcg1WAdq3/jSYTRWD1aHCWsUkj9C79CmQglg8YFCSNm9F?=
 =?us-ascii?Q?VjAp4BAwqpWkywPA7KJvvE9yluqsa4pjunJTBn0a2+BhUAI6Cw7Ws+HGTODo?=
 =?us-ascii?Q?TDyeC58+RyIyxtDz9G5onBUcWA7lV7eui1btyvn4xDTe7NLqDzEYBNKYvLuG?=
 =?us-ascii?Q?ELgl2tSrqIXBBko7rV0vWSuix3RPYUux/NW/Lgvl9J3UCNnXM1zzoHPr+cK8?=
 =?us-ascii?Q?Yr8CfgaISZ/8ozrwLM71RiB6x9+DxeTB9yVnnH/EV+UX2V8Jxp9so5mH3Tbb?=
 =?us-ascii?Q?ll/uST1xip1rft/enITQSJRqSd420cKRBATrD5ubEWghAYCyYlSM8V7UTo+3?=
 =?us-ascii?Q?AMQqDwldK7qbusvxfDQqoRHQl2xf/DOPO8AyMrHBhUxXrq3iz9RcKEPEDrbB?=
 =?us-ascii?Q?bkUpPvrB+bgg/WxP2JGU/sJ7CAyjMBcr5b2b7pX0EYHx5nneCcci/cwKsuz4?=
 =?us-ascii?Q?vZ1bf5LICJ0avxTaBCrud6jMRrYKhPH2XoDfy2d9eObzLoiTPVhR5cFJoJVO?=
 =?us-ascii?Q?9wd9WBSulaRcc3f5x2rgSCwtMYD1L391zs3TbeYCQPUBmniu0hC7U+LhElUg?=
 =?us-ascii?Q?8t3HjSBmO0zv9v968DVuUgJS3ycPuXNYlrn28+kMCu9jxvatOA7akeYJljYk?=
 =?us-ascii?Q?oYinWTa78X+30hLjTjwymZsCHMQBc7PGVY/quRzc7dQxA5vuR7BGsyJOYc5Y?=
 =?us-ascii?Q?pbrduDtiMkCiY9BCOSbO8dYzcsOX8UeBvqw5Lhp8N/mycoapWkAG5z2UQ0Qi?=
 =?us-ascii?Q?7vtwcksbZIQsVDkpJc0wlz+zsO/4tvuyqQ3tNJeUi0FSI5tLTsIkk7hAg4kP?=
 =?us-ascii?Q?1k42Twic6hQhN7ZIiusDQPcvj3ez3kn5GJN4aDHAWJSZhyO/zSguFhIPC9m/?=
 =?us-ascii?Q?AZfhRdcsv00zyDEHnyXIbkdWFszaTJmH6fZTlTHNTBNYmidaxmAMrLfMOny3?=
 =?us-ascii?Q?FCiQA5sxALBaIeaepC1ko+LW4SN//v12sgVlmdMPwhWA7X9/j7BvCdYOfB04?=
 =?us-ascii?Q?z1ZIu71gzC2z/9Z1mv6OgxR3N7bJC8d4AAlfeJz9PQcrBbioY7ncTWOPAfcn?=
 =?us-ascii?Q?hx1h/0sCAnG10JJEHeWzB7g3hnpFoP8xvFH9j+SoBxCnOZVGZQriods9kIit?=
 =?us-ascii?Q?5qs7v56luGuaYeODV+d+c+nc5rsfXAj0MyW7vSSA1EOhMkDnoGvut/qo1iFY?=
 =?us-ascii?Q?MCTTSKw5C6NGNxLlfWUQJ+IB/BiPcQCH8KMaGpO9HQnAyIQMShjLSgfoYlv5?=
 =?us-ascii?Q?Q7mVCc1z4ElXlsLggsVy8gNhb02TWFoQ9WDEijoRNbAzn8Wxa+xM1VHmTFtj?=
 =?us-ascii?Q?79Wh/UwHVg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NwNp09LgbRCCb5lecuEnShMxqI10T3q3RvMGVlm/h52pMYsIaC8RYs5jJcPmG0yqMxLZsaUYSUnogljQQEBYb3Q/JpXwH9AChto6CYJEHvBRLzPEAEBimq5p0Jh56D6ZzveERQS5gr3mVyONqUzN8HcHsRV2wLAYsC3RHBm+MP13vBBZc5jstLTDYQK6uqK6f7x8q/fV6NSDvBUWh404MpCML571Hu+r404dtK+NwlWI27atrHQ3NBLih0Dn5aRZIjbrUtmkCEKL2R2ZdRUzjojk26T84yJdgyv6co3KhMN3toXR1M8FhG2KTs3Ln9zegp2NhO1PNwjEi22yQnwe+leJXuT3KQLpgF+TfseiAWkShPbWyF1QBK1EABP22nG42FRc7c6321KwiUcwohZQR8lB6EWYV1iunRFvtrOEIVd2tkrsm56jBaIts6dN41M1ELnxhuSxKduOW02hSzwBmj6vqtzplqh/QwEzecACFUPQ7eB+DE6B3lwUcpc5yGL6EefLXyDjE0CCZrVanaRg9NE6WbCvtaP4qFA0BdDBzgd3vD5JGf6zYQFdjlKa6LK03WUTe2xl7pBE7H+vCgGTgYO0LIAG5JllKJbtC9dXpCo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2381931-13f5-45f0-b5ec-08de5463bed7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:31.4974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BSODE4xqZN0wKMW+bD0BuWR8jDIv2SWWot+o9S0865YM45RwxU7w05UscZ2KWoUUpE3bqa6f1H0FsKi4sbZsGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=779 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-ORIG-GUID: 4iZN6zX2rqdq4K8lYCV7TzlpxdRwASFZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfXzmIFBlIrT0Gs
 Y2p6eecGe1B4CRHE8EU3uVf5rlmcM8WWjUWHSaDr43jD46Z+hoQ7v87zWn8G3YEVSPVn8zq5T8c
 TAV5jCy0dU6/P8VGugNeNG38ApWUIm2WcaPFUklbko6KHDdBRoEVtAs1i42viwQf3sLztY/7aPK
 FAfgG4W9e7M/ZP1RNX/lse5Ix5/2SWU/y/TlNKQJ0Ynel93ZYCnLWlBNJM0BbryfPBuGSYegRHd
 iA+Cpfbp8///I4BFKwKKmMHH/7DAxni51+M1GnQBlDcTwfaMgZFCmD27gLkG1M/jWGIyT/e5lm/
 tdfjzpwTSPsB4i1qYqmuxy7vqp21AXOiTqfdmUVJlkb1K8a6l4MSFH8Iyz/gy68z8e7Qc0NACEL
 p/1tSKyOVK1os1XhQbwEnepZl4IJkc43IxzpB7Gxge+o6nbqyZOiyy52C+IXZCRm/A2teK4X96V
 t+sWKt1EXsrklsfHNRA==
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=69693197 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=q4Kie02juo130yM_dUcA:9
X-Proofpoint-GUID: 4iZN6zX2rqdq4K8lYCV7TzlpxdRwASFZ
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE46F180006
X-Stat-Signature: s3pxwzbsiuaywwkzrgroezbxcjbss9hk
X-Rspam-User: 
X-HE-Tag: 1768501671-206038
X-HE-Meta: U2FsdGVkX19pNBpcu8EYY/bloEU5FORNp+3X1HxByLHZCYJ4qzYWFnYNTKs4xkzYjfZ+KM/08+uv0TPNgYU+hJczN+aHftYP70tYeot/R3K9vXkgxFo7jD97yvEVyjjSa4TqZvVTMAZbVwWFEk5i+3ncSdUQgrw/HfkudhsAVN+fSEiLkAmjj+XbpmEZtpicxmXmvb2v/1wPxadPBEOpDXyvA+0vtb1+HFtmpYFFscruJ/f3vuzMjJNGyhyXvVMFF9kOPqmzHbNNXTdqp6z/T9LTaCM3RvjQVKvHZ6uClbn9UrSzB+NavkkbOeX/kmlMfm+lTvgeJaRTE4Om7As2CgaSn+JL7oAsQL4SbffRoRtXt+5qrHUhOM9cAkoJE3DEzMv9VjmuwC199SfA29CNQwZ8qpnsJEoZX9VHxQcHqQmSrPSHBFNJBUk585RIIUVYOjlmpcVuMxq1PChOGas/LVq2ujJEWOxIolVcQ7hZnq3ELT5HDdNBMffF6+vNV3+VJcUGJ2U4MD4eb6yKGn3GWKwPslaXZaiGwzPqkTevcGIYA3l/gVzltw2iIitBUJTLV3QYu2I1JRQuN7byeMB1DB8DrcDXX3V1hlG7yNqilumrvRah8RefIoslLe3z+/2MRZjan/qoo9l1BNGdFhW3PSfvpiBzHsQjG5l5yvUkEBCvkE7mYvjsIVI0TX/IIkRyGFXyjTxka6NTCJd1/AMLIPcJqnRUW+r2oC5k/5yX9Q4E/fyqUBl4v5LuI/Aisn2lrq9dBsg1GlBR7iqjENl9LcvGQjaPyZiq9tKE28jonD6yyPkgMdpVtYU8c3XIz5xeHnktkMNRvAY0iM2JvAkD2CkwmvUBoeJvSJe9oODPQLYac56DdVwJ7ReRmCBryVkJZcTCbVM8pR4Xea50tSWOhQLiKfyCgYPY0fhtbcJ7OOkVaEYXpeTNuVPmiuhcEvQZDQiQk09zaQZ0/JzCrf9
 8MKxhrLL
 cOY41s1XY6i/1AkT3iNkmK4ErjxTvmlFtCKv50Uuer2185tRdfbkmvsCpoMqlE2wLLNKbZoW4FucoBor0lI6YXXGr3g1J9gJee9nkucQOeFayh3V7coeMJrWuCh0EynO1TEH9Lp606wdoSewPPFbOhxiKKEo3LzjKjqvm164LEuepZKzt+WmaPtikBmToM1ZZ6eUzJ90/KTqOWiiC53m7e2cq7MWK1PLbIBib7BVt4aNWG9rTnEcIo2KvvdtEyCdjEvVU6dTSTn5SX/kXmVy/ztpA9TUBVqUVT85KX0uheDVr6E/joDgKVDFTD8XPKTZoTgwnSVJQPg1IRfaoNbxCqxAdzU/lo7+7QG/u9l1tD4lGgqskfumxoAjvMCzJ3tPIGpBYIfm5TIDxXidQrXBpH1s/mnjycEM+2xISfSZtC6eCuvZUbOUcyjw7PKgZ4hzDm/jHmktJ6edZ8lQLLDe4Wqxcf8SHohzBf+q9rGoMeo7IWgXYR8UiD0qjYWDYZ2TnBBmai7re3yJdXBtq+hSzuslUcwhwdcPgTuLb1kNmkhUMTX0n7mjttexLPwipSnILS119hValRi6zVTNkw91CsDIfjQU3YgeQtjLbUV1t+LmH4KpOfyKcWshlz3ZMACoER/yvvorjrH1pcgsSl3Q+a4M4w0Kt0lQstPlqpRgSC3SdkihFukNllNxy9hyEdAyrBt0ipn6O+CFMBSaUPWHT/GN/FMKsASBo15KhoiPsRZeflLrRy2cBM+TGBgQKyCW2UpBuVLRE/lGwJgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a limit to the vma search instead of using the start and end of the
one passed in.

No functional changes intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 6 ++++--
 mm/vma.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 3dbe414eff894..0c35cdc0d3b7b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -473,6 +473,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -480,7 +481,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
+	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
@@ -2466,7 +2467,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, map->prev, map->next);
+		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 
 		return error;
 	}
diff --git a/mm/vma.h b/mm/vma.h
index d51efd9da113f..e671adced3a03 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -264,6 +264,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /**
-- 
2.47.3


