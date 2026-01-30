Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC51E6BF3A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C176B00C4; Fri, 30 Jan 2026 16:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE3F6B00CC; Fri, 30 Jan 2026 16:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398E76B00C9; Fri, 30 Jan 2026 16:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0477A6B00C8
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD5FAD4D13
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:22 +0000 (UTC)
X-FDA: 84389850804.26.32E0EC1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 52945180011
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iUKeIqcb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qcMdP46y;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEiJoyw3YHksM/aZTUhenuMeueyh6vvn+ya7DJviXQE=;
	b=Cxd9mtt+qj+PfsU5wOv9i1PSGnL1oiqbMZkGE1STi/fp7FjdxN3d8fPqRji/BCd2VXKcco
	0mwjDPZNAOoes6CUy9erRqb1cos81QXLgsUelEfQ2Wek7bojeVlVMD6Gsy+ZEJRzeHelzs
	RPGo5napDqrykmwbNkCe4TSBD+p0D+w=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iUKeIqcb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qcMdP46y;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806879; a=rsa-sha256;
	cv=pass;
	b=C23LpParwL4qHtGpfDK9F3LZWPXv8ZXCaEvURThe+LzyqPc1gpQaQ5CU+m96WR2Nqs9J1E
	c3FoPtJeEhwMahcU0NLBgsnii8fQwvVFKg7NAd82z9VkjcROr+AsKuwk7dIxN+mC+7g1KQ
	1dX/boR8Aswe9SLZ3mWgwyHkDhriv4U=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDIZg3732537;
	Fri, 30 Jan 2026 21:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PEiJoyw3YHksM/aZTUhenuMeueyh6vvn+ya7DJviXQE=; b=
	iUKeIqcbyB9CXy9SvbV99NqkWucNMg/3whgERBegdGG2GZbUA0gI2+RFU1qblyll
	p55u9ffQDVGKmBBPsXaCRK0UpJKX09rA9avRZPMWTsK0JD1EBYyEgsWYEOHIeWle
	Tk6oTW/eNCsQQRhJlVKDYf9Kj4YOube+IVX75yyODNA06lVwOHpQi4uVNaCnLbVB
	3HzCExjZl/CCDih6J9SPON7Po68WkYjMCs8wFd0RuMt7K4pkOASKGDdswQhttm+S
	Mvv0y+xp0jXQkbe8YMH5KXUk3ZWKD+8V7rM/Igh+uyMujyyMtrTF0OEzNTFbl09k
	Y3X5scdd8immbvFZLLg55A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5t6dj7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJAMUb033453;
	Fri, 30 Jan 2026 21:01:07 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010051.outbound.protection.outlook.com [52.101.61.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4h27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:01:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QpSdB6WBHqsEghW0Czefgf/mBGEZbvC35blVnvcq+fyIopXcPSfGD5pQXtTRJLEWUy1o4LD0nstEFvRfd311bPyaq2YOSV7RbJjpJdu4yWFCzzTPmnC780IvonZ/48Nme77Y6bD3KvNzuVR/gyFC1CdpWZZEc8RGIhE7jOJSO5n/FRK2/1fLTIF8+Vf/3+EzhdM1rJ8OfqjX2W7EiVgPTcYiLnZMPLDa4ddVx2oH3AsRcio7LsAcM45SFZ1w81D51xw19y7fSu5cEwFMpQd1i8qZVrCmlJxGMTvbdfPSlXOhe2PwrVR6aLjH4cBLv08asx8HJnO+G0EJE0d8/glfBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEiJoyw3YHksM/aZTUhenuMeueyh6vvn+ya7DJviXQE=;
 b=OJ9skZKqu0NgY5mSsb9pWVj5eEas0TDBHPALt7i7hj2KQa97aZ/NZuYxQukt0kFAGviHPeXqOpX1DlXFrKyOY7vwfwkBB1g8L0GbKJGv+hQpQi3Ddz4GMoyaq+JeKleWhennKB+hheK/fW54XuSDUd74qX2UJctG7Q7PTajAw4qeEJdDbPIdzdGMsFdiHz+tJxm18ZKqRWez9UDdJU2HfL9KUH3SaYkoSEfPtrx3qdLJbzGMMl38dUM+XhD2gKFlcb5j8Js8n61JI9jNU62uGF4u1DoPjBxd7OidVZ817pIq8kkzvNCZuY8XBwrBfxYFyrZU7KwA97fPM5cxSXwXoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEiJoyw3YHksM/aZTUhenuMeueyh6vvn+ya7DJviXQE=;
 b=qcMdP46yX57aDxsHSjqGjmgxdyXnuYd4LB8PWJMF2i8x/frP5C7jGmxEh63ZYPlHTF+cNqo7KaMDDwRZqYoyqU/6hkY7dI/fxP7/vv2W3dil51JJtsgvGVQu4pJ8o6qRPYBrZd5U3lZVCgnkCjWn7Yii6OlhzVxP+BmYKyjrlVQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA4PR10MB8541.namprd10.prod.outlook.com (2603:10b6:208:56b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Fri, 30 Jan
 2026 21:01:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:01:04 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 30/30] maple_tree: Clean up mas_wr_node_store()
Date: Fri, 30 Jan 2026 15:59:35 -0500
Message-ID: <20260130205935.2559335-31-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0003.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA4PR10MB8541:EE_
X-MS-Office365-Filtering-Correlation-Id: cdf50dcc-4610-4196-7013-08de6042ae9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yaLa8IrAbuXY7ArNuzy2AcDC1+9CHTouvv4BJSoX8IPd6WC2ZdnbfuwW8w0p?=
 =?us-ascii?Q?Z34iSS5LjO/MMNH2GQYQOOLLEr24eUrkf5qCrIouARTSLfPwMyjky0aX3qjA?=
 =?us-ascii?Q?PdVTlQ5H3AhvyUaSAhjMuPFbBSE70cTybUxu7QzKk3Vn+NdU3Tb8+XAMdtro?=
 =?us-ascii?Q?pDSQl8VbpYpOsv4Z7bGahENUN5CpXra0+lEmMF1Uip1xeOWkPAqkH2hYySbd?=
 =?us-ascii?Q?acYQb5xQvT68go5kbabxqpL8mWVgKMWFUtQ8EFrgpl15a3tTec3lcsQzYTPU?=
 =?us-ascii?Q?xNJamjRTZyTFMz9dmbSqmqfngbil3hrRKWADNfndrLwki5StlFzqOInb0KfD?=
 =?us-ascii?Q?nDgG24BzpuhoIFDwBQhOOA1q+3sPjFPfGgVFW54U/Nbu/q/YxjagpZiA1reT?=
 =?us-ascii?Q?UZPpNFybh9Uca/sVPoX1tAphC0wRkmraJaxyRCZgaCViHe2lId+yka/jsElJ?=
 =?us-ascii?Q?/pw4gyOAnfl8sE60K0R1PW3JlIpWZcOkPVb05g4/cuWqwl/FZmrWq6ZSnQrL?=
 =?us-ascii?Q?t3jrj8NcKORpJFpqqo0uKM+DT/cVsoUHoP71ZZfu+EKwTilMTNnjIm+ui8wC?=
 =?us-ascii?Q?Nb3+2SAQRt0Gyfnf54qhToAparcWJGizzOB/VQhGySejurgySxBsB7QZBV9D?=
 =?us-ascii?Q?DeiXrpz8HVCh6zFXbdGMdaoktuPJcHEpTENvYPhQrl80seD/BykKtv0gcRza?=
 =?us-ascii?Q?DBGzP2NUHra+TMXUbBc+pb3OzzSZokztCrUS3iX+D+c3GBUDpBIvfHU23r3n?=
 =?us-ascii?Q?ki/SgBXt0RTFFqzFDN09qdkyq9pHW5H7n0lQu3SQaCC89jvcozwNjxRl6Gp/?=
 =?us-ascii?Q?d8xCDkagDIojCWNDYRezV4jSOKFUIruzOviZP1GcS71FnKVxLM8UmLYQXwTM?=
 =?us-ascii?Q?cPUk9lygilodv2pTn7p+3ydbz0D167ApB2dRJKSlyUgdxz+AI02wElXlXVNp?=
 =?us-ascii?Q?+Y4JwknDreyAuATBksvkONlr4HuJUSR2DGTs2lRTUaIAIrmEX20ZCLqedYpZ?=
 =?us-ascii?Q?zCcBlTncaqANM/D05exBu9AdoIwKs9d9Z+t6f39r76wnSvU1/qlJXd+2W/wp?=
 =?us-ascii?Q?ChPS9AhKRBAV+NI5AWIHAm1H9cCeW+kEVWubtl4Q0XgA8uKXVbCGWh4wDIw2?=
 =?us-ascii?Q?PhHapdwgFdQ7KmeZ25MV4sVZCT38O/M5io3M56+6GgSNvApd7vkSEPuI09fp?=
 =?us-ascii?Q?/eaSqNSiJfgb7fE6SPE/xIDgwYpzF3BtHNIS1EhBWBdFhHAFV4NbaOK9IoIh?=
 =?us-ascii?Q?AMMXyy40xBvj9y318YARgHe7EWgtFiq+6wpAuoD6jD0/3Y4m6W03Px1wCY8M?=
 =?us-ascii?Q?ZqEH71S07/57p+HTnIntEm016gM+2QfMHrUSAulMT3reILwkR2KA3M5CfnfM?=
 =?us-ascii?Q?zM/v7CByEZul+qChKUG/e5IU1t/ixKCALJ2s/gR0ks0hnteztPrzDlC9SPhN?=
 =?us-ascii?Q?c9Aq+dn5RnjUl3LI8RJRTNrA7jlq2GIRKYmXHSdoREDS1LJDYn10kXq/oznd?=
 =?us-ascii?Q?q0jwOkK2FALhkRoqWbsT5F5sPNU5ebOgsaIjuufc2VnGnkrmbz6XFBzrgGbi?=
 =?us-ascii?Q?HeYr1gkxKrRCjlTVyvM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZkoDY7D80vTnnnPHqsoLL0DGr0qcik2Su7Wo7DSIbDjbrpLBvD37UGGQj8FB?=
 =?us-ascii?Q?1WC2lCa17Le0o6wGzRQZ3fzzajk6ADupw3ARHHuMGSwHyDwNSYLsh48PKM/0?=
 =?us-ascii?Q?Z8qRnOqqGrab6DN1QLEH4jrWUpQYTuiG8AJ8b4vZiExABZR3Fy+w3C9qSS8v?=
 =?us-ascii?Q?UxZGHi8NB6uhm4lKfVBf02d1Fzg2NhWn/Q3sP0Vkn6oW3LMLYzmV/L1JUVj+?=
 =?us-ascii?Q?a2yPhuE86JtUEf+IccCQ8ubBi6y+D6K6hAUtm0POEz9AioqNuBfYLqQgXS9c?=
 =?us-ascii?Q?FloEK+JHOWHUBi+nTwC7fpVgxSy89fOgrxZHzcx6TIPxy1OOBSwWwpGppSzC?=
 =?us-ascii?Q?JmUdzSL3963ESTJ3cxK1/NhczaMA6CaF00znJRxDfcnC6STGbpFAmwUE9tmg?=
 =?us-ascii?Q?+az/td5TA0D/7KOESB1umUqsnKBV8lvZ69qCw5dbt1f6jKRtcg2GymAnz6/C?=
 =?us-ascii?Q?I/mErkjsX3oB9wi+rhJfTmg+o9qaL3TNyF1kXMxDCbxYeoxspZCdQ6uX22VX?=
 =?us-ascii?Q?dRtScTtvlESn42IqS7C6X+5KAeSwJE0dL/kEx6XSlzqgsK6kTz0vfPod/t94?=
 =?us-ascii?Q?jU0uUJANiApRa13/BCrs7rb1rvgmLsfBM6QGJDRusx3N8kLh9m5prtjIPQWk?=
 =?us-ascii?Q?A4OhK8FhJI2M4RKq5Ji2CGTf/D2rtJCLu8fClbd3ZQ0WsxH2iZ11MqElnYqk?=
 =?us-ascii?Q?hbDabVoHMDLroas+5wpw06m2mx3m9W6HOS7in4jawPV+UPz053rA6OqM0VsT?=
 =?us-ascii?Q?0R0tGfaxltJAlP1vbQmcHUI+IlKqItnPN5yWx5jmXOI9Vs4Ci8Nhijd1t0S1?=
 =?us-ascii?Q?V49O+8PBr/jIvjSkUGf4PryfXliIsZvNyPXmFhLOlQSUTAfbOKyqbtOQmXHi?=
 =?us-ascii?Q?IG8Yshx9Sz0sFxXlXP8Xbf5xRh7k3Azscy6VP1p/W31S8yxQHQrz7cLMekYo?=
 =?us-ascii?Q?SWiboCWYy9xPFR5psBWZfpVqdbAr5tflboeiHrTsL82SUvyKH3Bgeppt51X6?=
 =?us-ascii?Q?i7nCNuEzV6vR1tKP0u2NibtzD1Lb7AfLWuUEIsqjj3QEb5mXdK6grO0sYW18?=
 =?us-ascii?Q?H7TJsTP9kNEbDg43vP8f524/TncApwEjA+TwguHpeEneMPRhnqn+n3GJRpSo?=
 =?us-ascii?Q?TBdUopadKKTO4sWmoYsLg1LR/qZ9PhrATb8UxmF5WWXMaEqyg9/b1B5TCzyP?=
 =?us-ascii?Q?zoU9NpbYJ7/HOFl49z+CcnyylZGlKkidJMfVUayXn2nA6Cgafth1wCpV6ELI?=
 =?us-ascii?Q?c7G/2XnXkYMALVoq8VrFNTH0HwT2t3SSuwA4fSF4QiF47pCHeaQLiauJNobj?=
 =?us-ascii?Q?Xm+TD2aMQMfl/xgbj5oryN1pYpLxG+7KkIhW0GyYfwq6O4oejI7ikfO8b0fa?=
 =?us-ascii?Q?Vm687gtaBr8FxoZ6KfDz/0o5ODF8f+ZvunU3nQvc6HRvBDLL3/KRFjRitXuN?=
 =?us-ascii?Q?LxzvHiGSAO7BL+z1+juO5xQhmMfGtJveAqfQASnsgHxs5pL0RTVFVd1NhE7k?=
 =?us-ascii?Q?9vCReYnTbIhxaw2k8/LbMTKJ7GG5Kzz26wCI3FynPTHsgCOM/o2cPoed6+/8?=
 =?us-ascii?Q?2NjC/1kvHgPTXIt4fxYEf0c5SrJKPayqWuDTEBRt/KtnpIbKxPxSK4qH13wM?=
 =?us-ascii?Q?2enpX3kVFvutyv26WdzXU0640tE4c6zX0RDzdEDTwBJewfdKMbDUOqWucyOO?=
 =?us-ascii?Q?XfOm9oG5joMG8Sab1LnVwy3Vx3tAA+atwWE+VTVaWwigTLk76vflcosw5JVA?=
 =?us-ascii?Q?V8btsE9wcw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4rkG5IeTR2dSOUYlAp+lE2aUkxq+m0iyMvDnaImyC90dpbxHE+MOzyH7GR/R3kq2eK6KsKKxWUhPZs0aOTtzMCPG64rNb5ZzKnLV+ZrKzRxDX0f+tfgoJNU/an2h6QLqueOER1uvQ3hWDzzNSj6PfQfZd4Fmtpj7HQ1YuLHai/rZOuxi55PP1xltn3qUbvXi5sj3ZLgabwoQ5LhLMMUz8q+yaAvMu4bzEXpyaUYWvV9/tFmpG8SQKRMqIhiaeKUrE7bOG7xcgUa9j09GHUzpJBLeCXSZAKtq9ijkKjk+GU5+EjHQZCMheToWQtDkzq81HuB9fqiIAEULaJ25Kyq1MUinxiZYH1okTHrRZFDlC6ODUWQV3nx8+aYSf/UM2nN0lk1Ev484x3KqEbTSq+D2uNUeNuGwgjZG8v57rnNXGm7Tp0hfeT1Utlkdt5Aa7hW+qF4rFfvurkeNgMwJEdGs8fhlJa/4xoAgnNocPAjrOgA4i1WriU8WFYaU7pi09Mulog3K8pSBqiKwsW5gDg4S/uYluhbE8WrDPPW363l4D88G5SnKu+5TniEmaNfXUxf+nGjy7kPnZu1ysZVTU3RZS4feAavNQ3miYocNZKTf7N8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf50dcc-4610-4196-7013-08de6042ae9f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:01:04.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i8ja3TmH2JZ1sdiOBFbOlQtVxwaQD/WFRiGFTxvfWilLJI6ktZzHg9fHfgsTk3KvdGDNDbkOhs1PCutGZQOJAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8541
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: Ocl7908bam60ptZwVD5k1nm8V_PJ_EsX
X-Proofpoint-GUID: Ocl7908bam60ptZwVD5k1nm8V_PJ_EsX
X-Authority-Analysis: v=2.4 cv=IIcPywvG c=1 sm=1 tr=0 ts=697d1c14 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=I3VoEf0meaw97abzItIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXxdgoaZ4m/lvl
 0X8I74ASmxRXjkGTrZkvw5Re6doKFRQPHBTAsGo2pX1Mcu8RtBBSNSOzMwd6jvNRSsxmHTn2Gyf
 4HMCEy4jAYLDH5AwZwUkGRkZqm78QojRsMz/ny0tgreQmMvEY2iipn4PjCtDWsARwOUIghf2nIf
 70rGI/PrLd2nHZ9Ct5Xape4YCyQo9WIt9aXB8dhXVmzHAsVuDt9vBnD8IehMIGQv50nTqoYdBxN
 Pz5OGcfQouCFxhCmE5DD/438YgxhQeK3py2KuobQCsBsRALcXNsQwqFkQq1HHlLbH9nxV2SyT84
 /1liSBSZpQvYwgy7H/IPfiWstC+zEznvV8LtBOmD2QP5N9WJojX0fhch+Gyw5s1HaMuxYoAONuY
 e9/GuT6y0IjkYUf5Z8UYnZjUv6ZWDkEJStNedWv3c87GkifFDMSQo/ABLEVN5PdY17g5NecvsyA
 5DZGMOxfFp/nVk9b/wg==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52945180011
X-Stat-Signature: 17qqro1t91zxtu53py96h9om9dcwn8of
X-Rspam-User: 
X-HE-Tag: 1769806879-91980
X-HE-Meta: U2FsdGVkX1/I/TxEHQQ5qRFbGqdh3gnBfbhvYE3Opc2yD/XNZlh9M3Jv6yTpR4d5wLvobLyvpUzsNcl1Fkfwx8v9+1/xx/84hI+B7x78cticPFggZDynplkTUGIZ6ijWn6fE8qeuHqZI3BCoWYdnZQUMNPwqN4iq2UEsIjoEtJ/mm+AS2nr3/oL8+id0Aa46p4A/qEWpWfqXfBcOYE/t4FTwt6Rq+Vz+ZnJ8nbTx4snW5rSf0crKw1SMLegS5ibTVyOsAGEtO2kr13HAdVvYiwQ7kc2+FEQdl0cjjox2AYDfPpuGWGk5TWdefhqgjybJmT2G9JZhmQXEYO53lGujeaM8jM2FtTpKP4TLE92wJCn5PcCTwxvispf8gWo8VCQIN7TD+EbdSjMr7agqEzToB7NxcI4uB2ZdkR63NE4xcu2UzJcS3q/A30Xo1/Cf8xD9dNxkd3ZgM3QpdBm+7a5m9Hg5QUZKYEo9Xd4lPMHyhvmmm8HLp74SW9utS2Jpt6DcbpadbwU1dHBhH8rFgCSXMZEY33088cX6hnDxt0cHeT28sFx6ldvV1VdNnQbJdgeSw7JPDk554oZvD8iq6qj560q0r9cuZ2Znnhpakyw4jCQPyMYI1Dd3SVHq1jPhSWATXuqsnnXm8Wi/dz+JBfOaSEflGshlYP8JPQu/SPrsfxrboR72jZcHELER3Qf9w6utBKy7cGFNa51SnDQAO4FcXMpeZj67rs2i7m2wteRileJiwFSE25K6W07alsPluzRfgslOZ8t1KuuIPSXnwipIxJOihPfTDhvwG3bkTLTOclQ0aHLKqmaqbwYy9Dcm+qUrmCaEJBcCmSCBPfqxSiTqi8XIQcnnyEEUIzBL/Em7a5KatmxLj/JUgvyMQ3zArbnTfm8sZd+kg3X34OfP9nDwzAUrEuxoZP1NHTRG5nGjqLGcE/VlYfVcuLzw6YvjvPBKu7qmnAedK48S+kFLzsY
 czieWHQ6
 jjI88Sn1DNQaMtGwaHU9qnWD4TvF67rh0ZYLjUbhcuns3jJmvkSVr/yRkUFmoiMIpAMV2gSqUSF6BjrvBikr5ZvVBlbJZMtCpugshutgIBFh7Ajimw5ZIo63c5EXs8zgW1pnK3sxIEmq6YH0dhoHnsoiXpbzzjx7b0JNDDo2rjTfkJVrVGM8bMtG1vu/virKVw6lojhaUeICcq53k8OV98rQdOAQJUfOTtcTjZibpOo1+odkco2H2DongDovPpkocg2ZX6OTZitcIuXqUilKfx6ufouKmiH03dj5goygvj5HISaZFye6gEOaZIYyUlZpNY6vseZPNqbosc2PSjMj3Gmc6OYV3V2mEflPJf7VbXGZ1o7i+RGaJMAiGIrejAu8b9OLcpw96Gb1bU2bounUDU4zHJvTmIzS8KA/Z7sCmqoVvSZ2Zxp6ozgrbWVjRFRJ2Uj8nnW8FNIQGXJDdZCIknmvCWM0HMT5ZowVKFwuiTH129FCp4jeezQPUjg0Nk0J6hSl3utDQLDfpTKWqTyFWzZkN9v/zt9qVuqDJMG9LiF7NvA0bFNRHLt6MLR11oEqQ9d+UGD+kGEjSEi4vB9hTn5C1RYyfg4z4rIF/rfvADex0AEquqWd8Tp1nzMhJs0vWD+9IzfLDBEQp95OqCtdSSderUGn+QNa01hIDER1APRBxc/WKiUtSZbCkI3LvOxnWTa6i
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new_end does not need to be passed in as the data is already being
checked.  This allows for other areas to skip getting the node new_end
in the calling function.

The type was incorrectly void * instead of void __rcu *, which isn't an
issue but is technically incorrect.

Move the variable assignment to after the declarations to clean up the
initial setup.

Ensure there is something to copy before calling memcpy().

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index c9c63246f721c..af4554a23881d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3122,20 +3122,28 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
  *
  * Attempts to reuse the node, but may allocate.
  */
-static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
-				     unsigned char new_end)
+static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
-	struct ma_state *mas = wr_mas->mas;
-	void __rcu **dst_slots;
-	unsigned long *dst_pivots;
-	unsigned char dst_offset, offset_end = wr_mas->offset_end;
+	unsigned char dst_offset, offset_end;
+	unsigned char copy_size, node_pivots;
 	struct maple_node reuse, *newnode;
-	unsigned char copy_size, node_pivots = mt_pivots[wr_mas->type];
-	bool in_rcu = mt_in_rcu(mas->tree);
-	unsigned char height = mas_mt_height(mas);
+	unsigned long *dst_pivots;
+	void __rcu **dst_slots;
+	unsigned char new_end;
+	struct ma_state *mas;
+	bool in_rcu;
 
-	if (mas->last == wr_mas->end_piv)
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	offset_end = wr_mas->offset_end;
+	node_pivots = mt_pivots[wr_mas->type];
+	/* Assume last adds an entry */
+	new_end = mas->end + 1 - offset_end + mas->offset;
+	if (mas->last == wr_mas->end_piv) {
 		offset_end++; /* don't copy this offset */
+		new_end--;
+	}
 
 	/* set up node. */
 	if (in_rcu) {
@@ -3149,13 +3157,16 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	dst_pivots = ma_pivots(newnode, wr_mas->type);
 	dst_slots = ma_slots(newnode, wr_mas->type);
 	/* Copy from start to insert point */
-	memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
-	memcpy(dst_slots, wr_mas->slots, sizeof(void *) * mas->offset);
+	if (mas->offset) {
+		memcpy(dst_pivots, wr_mas->pivots, sizeof(unsigned long) * mas->offset);
+		memcpy(dst_slots, wr_mas->slots, sizeof(void __rcu *) * mas->offset);
+	}
 
 	/* Handle insert of new range starting after old range */
 	if (wr_mas->r_min < mas->index) {
 		rcu_assign_pointer(dst_slots[mas->offset], wr_mas->content);
 		dst_pivots[mas->offset++] = mas->index - 1;
+		new_end++;
 	}
 
 	/* Store the new entry and range end. */
@@ -3174,7 +3185,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	/* Copy to the end of node if necessary. */
 	copy_size = mas->end - offset_end + 1;
 	memcpy(dst_slots + dst_offset, wr_mas->slots + offset_end,
-	       sizeof(void *) * copy_size);
+	       sizeof(void __rcu *) * copy_size);
 	memcpy(dst_pivots + dst_offset, wr_mas->pivots + offset_end,
 	       sizeof(unsigned long) * (copy_size - 1));
 
@@ -3187,7 +3198,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 		struct maple_enode *old_enode = mas->node;
 
 		mas->node = mt_mk_node(newnode, wr_mas->type);
-		mas_replace_node(mas, old_enode, height);
+		mas_replace_node(mas, old_enode, mas_mt_height(mas));
 	} else {
 		memcpy(wr_mas->node, newnode, sizeof(struct maple_node));
 	}
@@ -3503,7 +3514,6 @@ static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
-	unsigned char new_end = mas_wr_new_end(wr_mas);
 
 	switch (mas->store_type) {
 	case wr_exact_fit:
@@ -3518,7 +3528,7 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_slot_store(wr_mas);
 		break;
 	case wr_node_store:
-		mas_wr_node_store(wr_mas, new_end);
+		mas_wr_node_store(wr_mas);
 		break;
 	case wr_spanning_store:
 		mas_wr_spanning_store(wr_mas);
-- 
2.47.3


