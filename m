Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3750D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556F86B00C7; Thu, 15 Jan 2026 14:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51ED56B00C9; Thu, 15 Jan 2026 14:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357C06B00CA; Thu, 15 Jan 2026 14:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2017E6B00C7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1CBBC1D55
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:26 +0000 (UTC)
X-FDA: 84335207292.09.C3878D5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 644D9C0010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dwqgJUw+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nTIeMBFl;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlZKMYbqz9xaYpfii3dvINKHuYkWyJzgEo6SHOCVqX4=;
	b=4Eg6LdzTH7I+OBMvO5hmbxev6JQi3IHPTRLmPc1WX6baVmWyjJ/NCcThnqoojVpQ8Y8Drs
	Intfg6VwdIj/sz0x+aFEHWOAz7UZyRI35AtFBU8BSNwyO44VM9HfW4vdfCDx4YyYEJMxYs
	GdsZz0aPMX4otQAbV85z+93qMW/rAQU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dwqgJUw+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nTIeMBFl;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505843; a=rsa-sha256;
	cv=pass;
	b=tU91Ds6a5VWlyheuB/RhuM3K1vRmuam5T9pEnnMG8GdNp/QS8YUzLbTV95MvRrUt7AtWsP
	EVoSW5SX5S4zPlkYC/1WnIVfsMX7FDwUE295EZLNHyCqsDy1avRbz7pS8T7NCjwGXukMxv
	agRkZu8cf0DxvYyX6LSiP0Ni9ssqpbA=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FH0kDt1360897;
	Thu, 15 Jan 2026 19:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WlZKMYbqz9xaYpfii3dvINKHuYkWyJzgEo6SHOCVqX4=; b=
	dwqgJUw+HVZyzWVlkjqtXKSK7QbnA9AIvAK8Ivv6EBEXGAwz0NqJIT8kYVbgGxx0
	J3NBz0BpdUot+jdwKiN1Z7Vi5itfWVemVV1RseUY8NGu3lPVAm1sX0GMhR1XFhMj
	IcQi876qIxWDsL6QptjWkU6vUbHWf44jklhHkPOoHKVj/BGrDlSzPI4bvooA9+wI
	P96/HX2wiU7l9WOpbd25b8QQlU1REhL00K6S9UUsxChSvkgMgkwKC4eGrq2IXNrb
	eCOFAt7OxzTPjmBeYk7FhYz3AKJ/fR2mjb4GGHVnr0Ezh7ZACcclfjfyx5BNQ+vu
	G7E8gY7GHWTA/iEo0JHAKQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp3s4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJZwWF000404;
	Thu, 15 Jan 2026 19:37:16 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fgkds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvMHYGyZ+xXvn2IlxQzSonABuyKI9FWk4racw5Yc7jssz+NqCRFSNSMrLxkyJRNVDRHsqdKfyzpiDQyHjVwSXPBera4VgmBLlrJUrBaZ2fYhAOKvILBsU1Uavi+VYrzvrY1auNofrIO18M8DKNS9jIsDkYoM00GRAYlC1cZPhcal/7/ovr/JU2O1IvR50ZIlMXG4wZgz1aDIDPJpGT+TMndPWAy56MitMXpdW3ePrA/THmUaAElW2q09oA55qYFGiswdpxacNh/vIop/wchj+hhPYlVnzsdUHsgn5NZmtJp3bs7Vr5U38VUDmZGys3JLGC3Z451Iwh/z/VIyW3rfAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlZKMYbqz9xaYpfii3dvINKHuYkWyJzgEo6SHOCVqX4=;
 b=dzM4ob6bUmh+/KlxrDf1kVGumhZFf3Esm73NIKZAeJjC90gI67rwWaQTtSp5YX3H1/tQUSVkg3e1edUuYLOKEjquqLxxHgSOEb8nNwX2z7B/qPLACdKf4OqzIs76as2Pyvgic+WO8l8P1STGbCRMPRNQQQC4Ko8wFYLltU8lwpoFUvGIA4TBMFnIZRzRjHNm+n5EfXGpLvnH1RTywEanZ9gia/45oVl/TzPkL7/YSOsBey/u92ckwe8GC3olGy3TSW9fHP0MTKQkzromPR4slZ2rlZ/aLNJQsqF0G/GV9lO+3iwKFe4linpGLFXTp2Vdl490/UKCmqZwrHnyGzzv9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlZKMYbqz9xaYpfii3dvINKHuYkWyJzgEo6SHOCVqX4=;
 b=nTIeMBFlQeCzKReE4j769CxmzizXI7v5H9HOc4rKHlc/ld2zpILdU/UOO3+55OjAybiaHzX3cFUxf5UIFDSbzUPN8K7TjhPucYAWQWDx1prLr+uau8ztDIvSkfnlGbwcuiyr++RAmhzEddr/MouI5m1kyHJjT+qHznM+wGrlOj0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:12 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:12 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 07/28] maple_tree: Don't pass through height in mas_wr_spanning_store
Date: Thu, 15 Jan 2026 14:36:26 -0500
Message-ID: <20260115193647.1695937-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d5::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d79b5a-5302-4c5a-1170-08de546d7b1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xKP/a/EqTfrdLewtT9+mChMJCuuLLpK6nDQ9NeqJ7GmGejxMgTIPu6BOKUUk?=
 =?us-ascii?Q?PiRsjwXPlOiWx07tpgjl9cmsHalv8IqupioHfP2NYhpr6xN0vchcN3jNAeXn?=
 =?us-ascii?Q?sGOhzqU++Qvr0Pd5cah5Jqdvt3M4PPGcyMvQKhrMb+CfYM5x1OkSklKk/Xd+?=
 =?us-ascii?Q?V4ENqA80qWKbqkf999tm8yoxlMR2pJfYk30DK0hF14tb1mRAtmUwtKorUZVu?=
 =?us-ascii?Q?7OVklqisgHX+RdHCmEXH37qjGsHKYLCuz4c3ku/DglDDkkrEeCI6IrGyGrBI?=
 =?us-ascii?Q?g7nIDwq8bwc1GE9GL4LG3m9vBSIK6b9RiWSSsBsk2e6iTnoj8yKVa0ZeW+Oy?=
 =?us-ascii?Q?jcQjk7I48uCdDGYaE3MLFoZFw3kukTrbW4+Q7EWE1hFE9WyCv4QbK1Hlzf+x?=
 =?us-ascii?Q?Jx4w2W61eU4JIW6JIqgbXog8CJb2uUYuPOp+jemdaAu4VYZxAzmqc8Hu/z7b?=
 =?us-ascii?Q?xaL1l4BLfo+TDocBqajsukPhPPPw1lBTp1fzZxzJwiCOVnoOx3mzuzgmdNo/?=
 =?us-ascii?Q?htDMaIqY6wjQ665cI+hJa9HWyD+hUSWly2lajtUy26BRXsjrmI0DvIDBlYMc?=
 =?us-ascii?Q?lvux6SHQopGZbh3nJWRLM7o89XlD+TMwiAUfRFssc3lf2SQzGbZA9ijBsORQ?=
 =?us-ascii?Q?oe0+YZEWbvVjSdLm7c9GOdmxjd1X9WhEs7DjnNyF7PE6fkmaq4qBOUdhmH7W?=
 =?us-ascii?Q?nVh4rprZKEcgiPJ4hu54zjt09u1js73PcIlQF2Q+7ndCM32mKJ/nQTUWCkor?=
 =?us-ascii?Q?5SENbGxsJfy6sVWYXs6DAJJ5qzbrgnP2ircarSMK1rNl4vbaYoamPML8UUw8?=
 =?us-ascii?Q?cvRG8jUwgtheC4Cbmt2tq/hrTM9XAK/LLvtQOfwdSxgdoXe3p+X5xUHTdZsS?=
 =?us-ascii?Q?3e1NdXrYMm+sCKX8L5Ur6DHhn2YQcPWcHFhH9HjQUga1Qdx/T+0VCqmo1XpA?=
 =?us-ascii?Q?mX9cwxHUjw7eaF/6xDlVPGnt4EAOiDUfRhXZKfYHrFx1Xo1mQwguSmuR/fCB?=
 =?us-ascii?Q?EhMya6CsoH0fLCA/wIhACOzsM74cJmt6LaeSkXwfA6sRjUBXe2TcPzC38sP+?=
 =?us-ascii?Q?e7394Oxg2/xvjrCLWcF66migcKbBbWUuh2/HBVHodaczuC8Mr7WKeLCjwEsW?=
 =?us-ascii?Q?s2iTocGsv0TXLOOCkf/YohAdhJkHg1RZOP06RTTsOd5bWTMC3UT55aNiakoE?=
 =?us-ascii?Q?PpSok3PdHfCYmgdxrNuFWyJTZX2NSpK36h7nbaoE1AOTp/gRKRkfYXkpPSko?=
 =?us-ascii?Q?LP12k6IkUxD8S+s/TSZNBR+DxT8zVZrb0xOPo1/6IkR6ZjUrxni3kXgXKCNW?=
 =?us-ascii?Q?9RGF+mYrgUbkorAR/EbZRM1v4BnZcAIoQ8DQoc1dBK3yxQBpKh/r2BhUZSJD?=
 =?us-ascii?Q?M8BuLECgxOCD4uGeEuXu5gciE2lmeXMLl+GphPtfaR2+JaATrIJJg9fPyoju?=
 =?us-ascii?Q?vH0kiUCaJ2m/LbLwpVzk/VsOPeR8LMUI8QRUF46tVcDVAOxE6OYDsx1OhIa7?=
 =?us-ascii?Q?7T2caXDqJt8rpTIRPqqUo3OSe7tWk8XW43kw4kRawpXXbmqVb+meLn1QsZJX?=
 =?us-ascii?Q?BRHMtH+gGR9uItZOV8s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wLmnozlHR08djkGo5b03rPeD5yGvSh5CuhiV9xBbl8GTnEqdKaIFvdU/OwCY?=
 =?us-ascii?Q?m24wxt09wKyolXx8lFjweFKDUJSUvUbdKOxadp9an9XrjKm+Lj4xYyt9prk1?=
 =?us-ascii?Q?Ur9UvLkpneR0nW0cN0oTTxV/cTEXYm51cHky+4NWPw62RmgzlMq0u6nNMPcy?=
 =?us-ascii?Q?+Xpa2UiXGz4Dk3c/IHeAogN2UR6CgO4b2F+47ILUqc+KWcECS59gtdntAZRW?=
 =?us-ascii?Q?0mVHOIEdt4DzzI7HR15OmjGyxj87cqL5CJ0UvMqP9FxGyV3V62gHEvpMisyl?=
 =?us-ascii?Q?Lb6pOexyFnjC37xo34vuuY9ZJcOV/c+wnwUwik3sY6HrunBCy3Y7TJdCnQ62?=
 =?us-ascii?Q?6BYw2Jt4mbGQVc/elQdqpAEoFpEAU780qkh+ZF98LhO1oW4hspNOl4zGYKc2?=
 =?us-ascii?Q?YOTvZRt2NFbZv5gxi6LG+GzVPXT02ijE6lGi2pDnHKiwrSryNRMVozMvR2ym?=
 =?us-ascii?Q?VhsWm8X/sBjCB7f6k8D1N1oE8KSdnQoDN/nSs2+Or9v1j0lha2HFex47KqKq?=
 =?us-ascii?Q?lfmI8kWta/oCnROiLH0qoJAgq7JgW8makH3Vu80GdSKVZ0iw05fCX62xvSAb?=
 =?us-ascii?Q?yDa8u7OFrBVhuJcDwa2vIbxnSbW+FKMhDLSESUIKBuaCNVFQvmCinbWnGSyP?=
 =?us-ascii?Q?/54zQZ3+56gaicHQ+EbESjXswrBM5SWmCn3FiWz/0JCfCmzRtNkjWM4Rz6Oe?=
 =?us-ascii?Q?oE3fJO0gY7mUI9ySBtV5n0f6mFykx8JdtOcmUNVlNcg0E2p/YOCq1djtLFsv?=
 =?us-ascii?Q?xNhPqtxmippytEB+mX1FK74oN+/9GTqphI9q5maQDuFUz2bQWwrJB7w440a3?=
 =?us-ascii?Q?MoB8S9HeD4yMMzxa6t00ebZUxUfOhFF9GUkLVPudTRRN5JIWx19DnQR7S07z?=
 =?us-ascii?Q?+FVneVVYCTziiHXHbYJ4MiVisnHzIZrl59ksTz/GA0QoeUO+rGW5PBbZisFn?=
 =?us-ascii?Q?88233bg1RPfpikkVDY4L+cpefwtl3jh+F5+knLFjWvtZe5PuX1//295YNyK6?=
 =?us-ascii?Q?TCjOyIQnWo4lNODR4soMIApYIjLKoxHS8hqmxfOBu6UqccydFULXGfYRMqrh?=
 =?us-ascii?Q?wvEtb99xhI4IO8TywkOzcHSn8jG9ajCvjQi+m6dmQcTNgP+LhHSQIXk0c9YM?=
 =?us-ascii?Q?wVE3LhbSpZdu6u4b/+5Jg05G/Li6o1j76cM5N+/you1VbFxO7ZnW039Lgpkh?=
 =?us-ascii?Q?pAug56dtDxPmgsGxEf+wgsbbyaHMJbmSAj3ONrc2rv+kekC5oSOkeTFuoJD7?=
 =?us-ascii?Q?uxA+ZUEU4fj3ntlAKw1iiEepkduqqchZwwXtRM37MwA7dIbPd9RgQ78zcOAk?=
 =?us-ascii?Q?jlPRrwr+oWRgCTBLY/vsVtu8XClurXolPVPMBm7AilQtup340Htfx+NZDPzw?=
 =?us-ascii?Q?SZW1f7W8USlPjlpBrIFmztMZHcTjQGukDiC6onSZ9S+xdqMlnFqVL1V7xrN0?=
 =?us-ascii?Q?2sJNmB16lJfhfjqvDWnLaTfA7sIuEj1UWXT9MOClkt5anWbFBeRrRhwP466d?=
 =?us-ascii?Q?vAIgqu74MJKGU7/KpgUUzJhJ1eIL+U5tlJJyQy4d0VzU8UwyqZK7yUzXkWAi?=
 =?us-ascii?Q?K/BF5V+4P7AHire1KakLEmwIA4m1ZnpzeGDODKdcm9H0OBB6iwUxWIn52BU8?=
 =?us-ascii?Q?2TDuwMJNDmTrgaScysO0buddZfYJVCjkp8An+6B1oZr9gNgzP6J8oe/EvcgB?=
 =?us-ascii?Q?61+gR+VcKZmK3xCyk/67bTqfxYZh7N7ziaXWZs8WO5mWevTJ/8bqjKT9djHm?=
 =?us-ascii?Q?1bHpyrDY8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grwpMVkZg6DQmfYPu59v6TlNYAqChcUW2sMoLnQzd4aeuJ28pVkCVJ9I+wp8f+MLExrp/bzkQJUl8rnbO8YVmmxZ7cS+ksz0drFKqSekZqMJE/i2VrjlBa/g5Lo2SFQExKriV8qtNhuio3i0n6vCoPia0UWcaA0Ne4jz77oiLaeLEVpJ368AQBGWSlK5kf5BPFJx/MnFEXxDwSkSZI7JOIvjJXFMBEdkr003X46VMAlQL4pRZksKMeu49zzLn0X8l2nGVCll73IIhElKwTZoPQ5ma/si7YxAePDsNZUmhJosLeW7wz4hk1/Dw+B3wZdS9PeItnjZVgG95Lip22qXdZJqo5/u+52DxiXF5iF4lUPpGCOlNF2TW3435l3pfUHKCjFugJwmUcW0vrHBaeBe4PBHjxXvrgrnIzGoTqIJpskwf2X7PnT98BIWqQFvoUaTGE1IfrptTrALWXGPdwU65wJNRBounq6RZGQ/VZr04E36G6VN6UbIbkZAVL3H5Eq9E0lN9yj6QF8RH+hTGX2nl856K/tVdOniCrH5Eep/yVpylgO8Noxu0vSjXySGBB20ON4JNLbswk3fY9rWkv5li4g7yWFQ2Pjy+nVKQ9UzVdo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d79b5a-5302-4c5a-1170-08de546d7b1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:12.7971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVTbXlgt75mU8heis8V4cme/lsvHDA/2YwvE6AxU+lAxacXShL66IrmDYVJauM6knxxe/bmElWL1f98+MEiYDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXyNtKqjPoMxfX
 tBL6Hij7Mqsz8H/0Q5kmpkztJ9CZpgQNuXgzZH2x9V2HAtVZUsPVFmowKhS3oPUlcfl7LfjAE4g
 iVjCWAwvlbLGoAmRvfMx84CVXd0Yi8lQUpT4Nzp+tsDMBbB8kdCulqVYGhE5eBOA8U8DNpBOgTa
 3bUX0h437H8QEIsRGTklUZSkmp9XrhyOWRfSJ9OCLgxa3U79jZX6Nf+B2zabqs7anBfZOjNZ6Ee
 ZbOU+nCz7Uxd5mIFUzQitlE73I5OzAzswkcPhwCjgD+5q+mSI0w0nDchm4bxHi4zgyx3WBajfhZ
 syWfl8hGX7numlNkRuCdBEQvuK95xSxKj93I8jo9CSRMS4pBiDTmIwYG15zrjxAxXtC6Gagu0u8
 njKLbXs1+57HBjv6+V8m7K7ogjrZqRRDwm3s/hcCmEO/kqBDm64zDVEzaoyq4ux6rrir8Ylttkg
 tOChvrR6hobcIuqoNEqzeLnjDteHKvpNb6K/sQcI=
X-Proofpoint-GUID: qY6ZhOLfShcYroPirInmZd9IhOf_WSet
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696941ec b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=OdRVoOdji5KT7ucrDR4A:9 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: qY6ZhOLfShcYroPirInmZd9IhOf_WSet
X-Stat-Signature: p4ttic4z41qceoy59tq4g7tg9dqt19h3
X-Rspamd-Queue-Id: 644D9C0010
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768505843-529710
X-HE-Meta: U2FsdGVkX1/7akE1IkGH1AVevDhamYBK+mYb0hEpD7DkJNxQ2SDC0MgxwlmzT0ONDh3WZGVj/DtD7DS07I9yiqN+lR6l62wLzzTijuRdhkcxgBtDi9kGKpXKeIpHfcvpIqVP12qn/IC9LQkqF8eXsMpWI9CxsdiktSTkFpiHfThmS9doRJTHM2tc9XkuqleJ6At8TJjFu2nWzWMJRBbkRqvMmaEIUI08iUXQl2AMgiZ3ibZDBRzehIjM9hmzDvImlgaUjuGlRj5UMHiyCSR0WM3eTXVIHqUQC0y/dExbKA6nZHdt3Ht/kW0UXlX32YGARJMrXvDIC8sukXIUPToV/udL04NVQuZKMV4YYWHZ5Bt9ZdroIdoqgdoTipHxVSAhzChvox4UmfdNN74dXP+NTUICz1BVyWWQXeILoEs0RPkVY8o1OjEuaKVFflo81l/nE2ehaMxjSGopdcheKSTAhYxSPTkIwWDFoogUDGP5IkujphYzA2ZAyj5d9hL/o6Sn/P49R2SKzn9GhEPHUCqoGutdkW/y1fN+77OMri/T6nnN8q+SiToVJIFVgVq0/qbDPXOLjEKIXDtz3rhIgnJO8PW4xCEHK/wrc4/VmXD+aircWo+RDVbjg5v002FIQJBfLXkMwH/lXgI0Bu0GEoxnoHKtNEMH/JS+wK6PrxOMsFDYhd+OhIGgj+tmPduwyCmlrXzWQGu3gMRKMrS+CDYSFbjuZVXp90S4rJwdB0WQYh0xRWnrBun1cyt8d6ZJkmexGAdiaUvKxToj8cuONwwTSITqST3JxJ9eTeUsJbSEWMp9DV98of3YJyIJKNXza5FWS36ePAnUbr5BXjD9imyekaRPsF3Xhv4aXbDaCC/CipSSjNhPtKQTOjEinwMNGB4ujOIm9srsyxPYxRB+738D6FbvRtYLigoxxCmNwbp7QG5ubxtZey6u7fzqgDYTbgmwiywlkP+7qEQFhPwVf88
 3eeaYM3p
 yFFBBOsLzq84TYJSVlbUlTpu5eGEQQyrvK5ASy7XA+WYMKqwt2hJOHDmLlpL19KPxoV5rvDnhpUc/tttHL/cHeoAIJg4LX55NdXMwyn8y1qRjs8MHLvQOhAely9WTy4c0aNRZFicTJvQCMk8So2G1rZqX0Liq1vP5ZH5IZVaiESU59ANKBI7T0WdPL49Xa6YdnGO3iXPp5lAOMqHZUUXoHUbZ7kPeN1w3PtQzli5p7skcYs4gMYhdK0/FcJRKNZAV0J0gpHkERs1mS2JiAyGcvuTFoKEv6ynmEzqHBzKSXATGXAAbvnIW2RLVTPKa2gbLYNz3PGU1WeFNGWNqzO0RknlqS3GN0/8hpvmGsFtToZ3v/2j5ZRw2vT2UiNzU2ZBno/7+Q2NX8w2k0quv6GAUHbCv3J/SEEZeBj8eYSE8kXJzRvK+MBW4LFvozlStJPS3zshZZ52WHcR448nk2Dl1/sb0slnubUSOtpeoJHd1oLRxpd8VmzUemTBsCmpAykbN8UlD15omsGDnInhz8cLJX69zHwFv7eYPKNC69ggCmz6+foufYE7xoHjpCKmYvCiHDtf1VQTj6PjScoqK8OYbHsMoC4ets3/KZlCaH++GmruIWX16qdqwyDgn6HCo6b6OaTnz+z9IMpjYFLiAIR8NREnWJlS+UcOErd00whX6+SNyz/GmeHUBaWJPAlZoxaCyD6hN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Height is not used locally in the function, so call the height argument
closer to where it is passed in the next level.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index e17f0b6723a85..bdcfcdd18dd65 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,10 +2750,10 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *wr_mas)
+		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
+	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
@@ -2788,6 +2788,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
 		mast_spanning_rebalance(mast);
 
+	height = mas_mt_height(mas) + 1;
 	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
@@ -3448,7 +3449,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct ma_state *mas;
-	unsigned char height;
 
 	/* Left and Right side of spanning store */
 	MA_STATE(l_mas, NULL, 0, 0);
@@ -3476,7 +3476,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	 * Node rebalancing may occur due to this store, so there may be three new
 	 * entries per level plus a new root.
 	 */
-	height = mas_mt_height(mas);
 
 	/*
 	 * Set up right side.  Need to get to the next offset after the spanning
@@ -3509,7 +3508,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
 }
 
 /*
-- 
2.47.3


