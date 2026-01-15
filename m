Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD86DD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911D76B00EB; Thu, 15 Jan 2026 14:38:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5216B00EE; Thu, 15 Jan 2026 14:38:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671D56B00EB; Thu, 15 Jan 2026 14:38:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF366B00EB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E96151BA2E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:06 +0000 (UTC)
X-FDA: 84335208972.18.3C07265
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id BED3C1C0014
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W0lgU5PW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MxB6qJWo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505883; a=rsa-sha256;
	cv=pass;
	b=T2qn4UD/WiuWLW4Atl30bTKLQWbd6bYyVRvYWk4zotZetFn4aBZLynMuHd/BYGjXJDyQh3
	s1aj5OFp38XekS1EktTuDDAu4JapL95I/aM6Aio9d3+7zamokTMZ9ZmIu7bfUKUCXBD1FV
	FHQDeNX6PM/3wSeBTul1wPjHCenEekQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=W0lgU5PW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MxB6qJWo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiF9eyHRWvy/ekopLFtqKBjLBToP81Yxs2891Lz/u/I=;
	b=vJeMHidk8Pb0zKw3IAL1gvY8SAK8LKQRFIY0FuAwuFiQFkov/k33mjZUzrGnIsUYkNCF+T
	5AWpdZZKtZN4mAptzetCkGNSt1RIj1rM7KsoetT4tubDeWLhXXEqd1gcjWd6JUodLaDS9v
	riC20rfzIFg9dgHZ9td2NKtNzAnVVA4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEAZUO1940271;
	Thu, 15 Jan 2026 19:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hiF9eyHRWvy/ekopLFtqKBjLBToP81Yxs2891Lz/u/I=; b=
	W0lgU5PWAG94oFzm8ZoQbV2arajkaliJcLULmtu35RCULGUTbyZ7WuKcw4cmUMI5
	mr4GbQELxRUfpYlzqNqQVcAz4evWz8B1/hm06gIJLTDmWPWv71jlevyOM+JPMYgb
	p1fOH4M2e4Vfj9thY1/dW9wwyBJ2Oz3UQn2JojAAraJwK+U6VENweVzJCNdJOaBN
	9hW+UQ7lZzR5qSnonjiNd+LqXZPTZsxWPtQt4hGy8/KPFs3S+9AMkAxuzWzZD/lc
	bWC7ngnXflW2WWYjQPMkuC8UU/RT9gTPhQH/CQ2Fk9YYhJwlEJKaELEDDgr4CRos
	WULLGrqb+oytYWm3bUQGxQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3bwct-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FHh9SF005654;
	Thu, 15 Jan 2026 19:37:55 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bffnr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UrQS1Ek3gHmOZ2tXCcSXQxmp2kOu+hAOAv9jZgSHnHS8HC7fL6edBma3zf+hlphrVuCxIgMuvzSAC2TTrWQWnUyMCqdlikFJ7yeyu/pn3UjapO1yHKF5ypeVuSDnzJ0ZBGU5N0p7cSof08mnkZhMnGSQFfY5DTmUigb1kzciuvURAqxNetpUfsqTDkgPmF07QVJGJk24FqqmH7lwhnE9GHtaVvbNwpElWmGP9CUxOcYcKo2AkagXBwuJ1+y+7cK90Q0G2EZJgSVsz/sTRgfOeu/x5qetxxj9EEyTqppV5O93rjxe9NidWTkRgfS+XdFBEXO22Nmjs0AEGLYZpNNxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiF9eyHRWvy/ekopLFtqKBjLBToP81Yxs2891Lz/u/I=;
 b=J9TlbBXUagfB3bq/B2eKUSbzWceeuO4XGtSuC5yRln+wqCPFqZH8rzZS965aT+MM+eTiisgENbAD8ue0OxI90h2/5+knVnLGyZSOhGoU11aLIkYgF/6GxRGVspIWpfahLQ1rHvZGC04uTNUScRaz6h4A+A/a4tdosX9HgSodNJqyiEvbrLobD7eblghH5Cqm4mcq2MNsoXWW+xAUUukU6IcyoV19WCjPLFW95iWZTIobghJi+/VF7l93S76+beJ4Zt28hDWtqYBzs6P563zXMCKKm2jOtHe0xWzERTjQRuDvpavDnxw7yvCkOW9tYhp9D2CCsrOEgQ2K1CwCpJ0e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiF9eyHRWvy/ekopLFtqKBjLBToP81Yxs2891Lz/u/I=;
 b=MxB6qJWoCDKZwJmaMRMDzjlC1pSDfbPaTt/OwpFj1xF5RVTzc9MHqmnIuWQtaBRzqU+Rc9Pw22yxX4/fnwZsNO3Pu0rJhJivDPVtYziq+4SIMDJ3ghqbYjJurernsNAofKU8jFB6QkC+kYKehA+yb0uYyG62QlE6PX1nLuNeDMw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB5774.namprd10.prod.outlook.com (2603:10b6:303:18e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:46 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:45 +0000
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
Subject: [PATCH 21/28] maple_tree: Use maple copy node for mas_wr_rebalance() operation
Date: Thu, 15 Jan 2026 14:36:40 -0500
Message-ID: <20260115193647.1695937-22-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0134.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 688865f3-57d2-40e6-3317-08de546d8ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IYNJRxKAV9+fIR2MemiqqzBco1bDdwmaZpPmx1surI02yOY3BAjLVGRqR3f7?=
 =?us-ascii?Q?i625Jcz5IYXv6S3T2DLSSCSYiFIWfbs5dha2FJx+ghH/DQt4aq240dxEDDhr?=
 =?us-ascii?Q?9mVfiFrgIhBc2P6mfhq9gnXAUxo9X5VbUTmlUEcIHyGGVHupQbiVAxbZEY93?=
 =?us-ascii?Q?GKPDpIkMdJ8eh/GyvL8ymk+fwni+vcXMM+CFCWuJytWARYyWI5NL/H7muIX3?=
 =?us-ascii?Q?Y6COlrDtkyzF72+bD1QN45doHmMowJxBKyMWBjdrktRD3wuRDVh81GOSqjeM?=
 =?us-ascii?Q?yKGJgtxK02wYJe/+3Gw97H6J7dmHt0hyjuOH6KbD/wvMTF9Sw/M1nKFK7ZHV?=
 =?us-ascii?Q?JXvkb5MxBHjd9GINnqzTJGQxL+WqO5STzCZD3qqhBkBtSlOHnCb9rNbGgLFO?=
 =?us-ascii?Q?rTKXuh0pL4T5vpmMHt/L8mvNJ6b7H6Ru7mbFL0cNcPsvZ8fv0A/mWveIbCt9?=
 =?us-ascii?Q?jk8maSXTzTMzUc10tR0OFsq+VCZ+uXjbdata4x7t23D5mqOXA6M8MJ8Z6sWF?=
 =?us-ascii?Q?vD3nKrQ0IIvsIXwQGWYq59J+54Y/KuYr1fd2bUPHANeFZtU5n6MtnHOrA+kM?=
 =?us-ascii?Q?K6rNkpTg6lS8qs4cQM8mUnkSs7GEqwlsNBs8q+oXomf3BsjS8O5rgBEEsxxQ?=
 =?us-ascii?Q?+oF6gK4CKtWxZMqyyNWSeOr6qA04cvGAs4gdPvSlTaztZcQ0I2Tq3DazPYAU?=
 =?us-ascii?Q?pshPb0KkpbdH/ayFxM/UA61+zasNUeSdRWz7f6h+9iL4Q0J+Hee3kMTuwKzb?=
 =?us-ascii?Q?dt8iCs4sORt50KiPz4NXGlwVZDbU1t4E8GwgqPurKy7V+kTpd2ULpzt3cOf6?=
 =?us-ascii?Q?M48kGcWim7pfotvtKAdlxL5OVwmTzVW71YOXzSb+hWznr88n9zKwKfngvi1e?=
 =?us-ascii?Q?2oZSxJFfNYl4CMGT5S9WPIV8uJFufglcRcPJkAtWUSfJMlvBuF1zX0Rum0mg?=
 =?us-ascii?Q?XSeJzm5ENmUfDoePbe0DIyhXdHGNu7T7kgNC8tYvHS/LBS11jKpTPJCSvH08?=
 =?us-ascii?Q?9ZHeKmRegAwAKochtqi/dBiFkL/aAQfoVWK2IQfj1sk4VKYGUddjFXNEi/eO?=
 =?us-ascii?Q?wjCPgZBPVEAraRgDE4UaPslQyZJfbKrHuCGbTUwBU/pl8daLeHW2vZmdVj7C?=
 =?us-ascii?Q?P+5P+eB7t3NUpmfu1z6zVlzizzpHcnFf9ld3Q2KTYqk8krTf0Y6PDkcOV13y?=
 =?us-ascii?Q?yxXF6lcKxStbRmn8hSMEbvKDUlmV9xRe2TcNwqqIltcX/A3jbjncFcANhG9B?=
 =?us-ascii?Q?F2263jDer1VLJjDFawyzigIYzW/8esAbr5l91Ki9aBnp/EHhWQVSsrMjnGVM?=
 =?us-ascii?Q?pj9xCtGkyHe6Wdb/Ib2OM7CxQ57dHLTD0feRycxFrjdYU9xMZR31JvPXrJUI?=
 =?us-ascii?Q?46i8r1nCWmVodmKoBxG4HJ//A0I4R2zB4ob+wLbmUBlltw2+oYcZnqEiduxL?=
 =?us-ascii?Q?Xr6D1lzObvSw8e17jolnuejE33jPsi3hn3bgNTxI+HyyDAPTQwz52YEbSDRN?=
 =?us-ascii?Q?DtU8WsDs0pkTB+ZP0CAnRq5h1UqNQiIZ7+HVffF3GDmvlfzJJoFeXxst0zXE?=
 =?us-ascii?Q?3MNK9o7XV65DcN7IOwI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T37dMcfVWeIhMd203QQw/rgsnb1ZrHy/jlVSdnyPfBNLLdmrAY8pl6rcU4PX?=
 =?us-ascii?Q?2ezclOxVvDAwr1YR/9k4jaQ6g7CI0J2/XnFJTdE2HOkyom992lJgMtZLspV9?=
 =?us-ascii?Q?1LbjeXvwtHFsRPAuZrxjywX9qojJ79xyOB9BWv3keDzQfvgDr1G3nEOvrOgR?=
 =?us-ascii?Q?lzIn3Mh7bwWj8NPbCqlpeJ1DCghVoNTnPM32eKNtToCnUlZJrb8TY+o/leZB?=
 =?us-ascii?Q?TRtRpSlJeSIoZaUPlVeFipSQ6lo2IghK2yy6RKJyMeCpQEoQxISCtPH65cKt?=
 =?us-ascii?Q?JKQdAGGpcaWo2i5cCC0ulbIvZJkzmQZHDDHArFsWTsIoEfmUYUfOY4ImbEXJ?=
 =?us-ascii?Q?qVc4lkReXsl25ocffaUZUymo9vKEBY8fVoRbIuMAMpd0vTC4LuMjJ4QkT+mo?=
 =?us-ascii?Q?fOCczaLUrRVE3wBK9buRijNNm5A/HufEto3AuwNjKWLoyCCHjNCgIpFloYyK?=
 =?us-ascii?Q?TuMiwWeAf9+6TopfPs0vEvuL5wotTtDRRNAWbyEYc57KIdl5i0ua3AT89Ikn?=
 =?us-ascii?Q?gXcuzAm31TcNli+/eoufIpjr4VEaeopp6jQhz5be+YTTntVNZ+Dx8EQ8LY7C?=
 =?us-ascii?Q?LOtnblWwx/0wOCX+ar1KD7xvu1bTqMP52cXYZkX6RVfeOT+xa+MN5KajnaAT?=
 =?us-ascii?Q?/9rje6jJS15mgWuBTBUZaaH3IGM8gxZ2IUkIYK9rlIyjo3XKrj7ECo95RqJM?=
 =?us-ascii?Q?4hTW1UAAtQn6loMTu55TKcddg4tKicrPoBBUmUOUzsQHHZ64sEv+O/Sfy2e3?=
 =?us-ascii?Q?QMrwuhuzk3ySkD85Nw0HQjThk7AT5jGIbTW3atxQE+rE2jlhp59Ardxn+8WK?=
 =?us-ascii?Q?fFvy2mfCd9mdTb9dBzOOROgYYLDO2mV8p7xso3MMOS4NBpR4mp5UKd18OLjV?=
 =?us-ascii?Q?Y74lZPS5QknTPrx3Xqw+tID7NBlUGQ6xGjEqSIVUSRJHMvKF1UBjFTj5lBPP?=
 =?us-ascii?Q?ODWADqhjFaE8Gohl/Z66Xb8f/x7IiDQx1bh8b01+8Abum4qXq2Dd17HKrFkj?=
 =?us-ascii?Q?YXXuE2uN1tMn0fn5W0eCCt3oqkF7rAQdKBba+/eeUFknZ8jhRCHOHYIKv5Fa?=
 =?us-ascii?Q?8H+5E5+5PbgrJqDMUG8S0W++1Fc3DMB1Iv+oKW4FjqQzmUkmvda7sNenO8d0?=
 =?us-ascii?Q?+2ar+g2+LBrAn2PKRz4TX19RMJoYGGHBEV83/jtrqgwoyRp41awJ9RaNKRS1?=
 =?us-ascii?Q?8sF16oklkA01TnYLvIKC2i14+r96jmADSzyCCgN6PjiBxlx1WPK9jmrtyga6?=
 =?us-ascii?Q?sWhlePM6vy+kG3tosFMm1kLDKu9O2qKEsoYFc0Gb1B+iV0bkVV560mqQZiSZ?=
 =?us-ascii?Q?w7rQ0pjsMBreC+h+dOeQ4mY1PBXTxzuu+YSFjj4n3gB1kRHAh+q5usDCiPs5?=
 =?us-ascii?Q?NyvYOmdpM7SRVEjd8QVmGCQsf/3d/AB+M0oKMcHuerO3v5kO5RoR62DmYZzH?=
 =?us-ascii?Q?16PWeUNanTdSvOTL8tP47Od+r8JPaukDYDUgEwLf/WdVEXcVWECOe+AoKXjr?=
 =?us-ascii?Q?pp7pXOdCFJyarok4Q9JV2uTLdm8bQ4QFwROi6Wm+34hVIFBbi4Ogla+ioIkE?=
 =?us-ascii?Q?EYnj8sxlEHmWeHGg2ZibQmnUqf9ckSX17hlkXpYIAs4wLzuTY/iZNLsSiHqb?=
 =?us-ascii?Q?RdGFMbYzljwUZhVOmyBvpXJyvM91RUNyuwAgnwIuMDTRJHu2FLvXy5jCRuH6?=
 =?us-ascii?Q?9/w8DLtc3Qsjk/ebNvB4bX8tDCncBgCOG5/Da4+rzHvFh7yuIes9KuwNyjbH?=
 =?us-ascii?Q?tvBIUFTAMg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KJmQq84O8BccDZ8BNNU0AbchJCRfusW0DifUDf8yF4WSlfPbM0aB+DLEMejW1r8J62UW+Q4yrZxOj6BDNIU4wZNAYmpxbslE3s/Z6d3EtFLxTtBzDdov1IYcadr1FCg6gFXjcz/01eohhS3BE49rhp/RDagDpgS8bxsYsbGIVmDNVDxDY9cnYG+tO6Ht96tNzLyTTWACqOFuLzS6Mpj+pW9zDKrLDKcZfNpmhOu8U3EIkMTBaTgBheQN2gJ/GeugEUmMfxqouqIlRju2W5lwQN8sdW/m46xNoKWwsJUijstlc57zAAGWn7qTDGmLkzARmFjKN/LnGOwjg6cyHgbunz9j66Chvl3JfY4/rcPWd1rP61wo7LAnwnWezTBVb4FzH5DPt9pEmrQPijtbxjJiniYNoGP18KoiIxBy+/9AFxR5lPOY6VgVijVwHgn/FXjmn4w+HQkFuktVbJWXlouAlJbMqZxO84SvSnHDHGstjzk94y8jaa4rtzEVaeNamRyjUkXDUtXTNUL5C0LhWpVARg+fYGGGJlXDvXqWaoYibjGUbZ0f6UeqWTez2lFbNBp36UypXst47SpTQeaKg84phc4fG6fJdIGMX5KooNO73Ss=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688865f3-57d2-40e6-3317-08de546d8ea4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:45.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3Tj/43yD8RltWsgCpsTa1sgZ2RkkucD2ALx82LCFMeLgmUeimjRGPzhaCA9GpVAZEfsNkk8h1+wB1euswCQ0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69694214 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=NMtRElkMPdqfRlTI_JQA:9
X-Proofpoint-ORIG-GUID: IzrBbx_I8lWDW2yKnSagwZ72RwR2MBqP
X-Proofpoint-GUID: IzrBbx_I8lWDW2yKnSagwZ72RwR2MBqP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXy7FoDWWVoqUV
 2edKM89HgVw8EGMZIzotobnammeyVJMwwifTgcMp3CGySQilrIBDTZK9DYK3JPCbjlqTBdewkzc
 R2nO672h1dzpQNox44Pr21G076kwcLnry4dXDy3R4xsciTcN/3LbibHi774PMoePlpsvXQi1m3S
 p8wTQPhgF0nXfkiCZkdmSAN33Cz/eOfEwL22JOBUn093WSJ/5V3FwTplKHlTJuDmER9rTq4XSFx
 m6P/QWmNBt0SlKImSyCEPXhWuoAS9MecYzOR+H0W58S+LeiIjgSgn+1aMt3e7ge4+y0MP0Rhcoc
 Epq/LCaPkw19+f0IpVKeBdYfpwjmNfQGFqJUY1iPuDycQ/LcFeuOGy2XXEiZyZTDY+bai0QPWiu
 LD2USq4ZePobKqp6k1pYSSavrhIHdE33DYHpkfYHdeEl0RefAfeoTAGN86LwjdTZIemBNw1o1mk
 TugLaXfI0DMIC1t12lQ==
X-Rspam-User: 
X-Stat-Signature: tcfoqpt5xideyrjfsbbz9kep1gcq7fpn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BED3C1C0014
X-HE-Tag: 1768505883-925989
X-HE-Meta: U2FsdGVkX19oHdJNiY9X/hQLSK0z8KfTiNsM9fnivKhBIsr4Fq5fK50nIrjy0zQrAuAUVzsS4JDJhGr9sayJc2Djo8jqi+SZGcAy7Hzyn8NTNNYVVqTu8RQut3Iq7xyW0T8Lp1KbJHa4QfRpN3QQedN6mLstoIlbfp9oGTdG2GZwtSYCUbOwHeWBDlizQ/hrzQveXc3dqrcwMMbzDWWQmMrNM9PBy+Zq7FrsNVHMNW5ixbZCR4kt4FNl84NJiqY6Dpaee0LRSAd4G5VxdpTeKO1p6DoqFOBc3JsTlSpGYTDcyyAW84/4Mbt/FszVQ2LYsadzB0yEGQaXCa3BsJMwW6FjtTFxFgO/b/3J2qAkNk3C+NobmNWV+0vLw6ofBxwUYn4vyQusysoEFJjjaKeXPQZexxmZ9nIDQIpMVSGH9+k71eyxd8QP6hi21k9kluTKPzbVAFhjxxNnJHnIkxby5L1fk28+di8MEjfBu3bWL6ZMCNYRumBo6i+8ahP96CpdEZOO1W18xNyqmVxcD03iAz9bdzj4WF/zIN9/ormNATdT9Ofl39IB+Z2gNfBntDB/GMOUA/vWICizfUDGW3g8Yif5tvNwKLd3LxtLLAbd/smtUCbFlEgbfad8pLxOlU/uJ36jPneB8bzBq2D+p4gDksO6CapvHStkQbS5PQXVwSNngzZAyB2Tv4L1ecwrLTLZUXHB7K9qT0mey52jwo6MoaUfpnyH06WuLWmFks4qnhWLCsopIJHdrJBzcxDGxcg3D/55inUM7MLIcg62K1knzWJKVTsLGfZKLqdn+a31UAq6gDjXx37xbKHVmZQ+t+gYcslj0aWxDA/swCmoNTUCGA3FtraZIH0B7qVLPNH+VvwYr9/teo4B4ZviGR5+xBmLmjvdNASrkVGGArn2kj/1kSSRToP/7Bzs4SJH1yCWEr8Q581FM6I5aVwOnm6hm/MLKModXjo15jeRuxCIizy
 xdyNNom9
 ewNf7TJMiodCnSMh9jgDPIz+sRho/dheAfHMTFQlSNLUHRmqw9PixM6F0yUfLzJjCA+iGNFMk3s4S1bYYmi9JntOdAyEvXl+hbFjGZjBAxg5/NNvt8J0XzL4oPc1UffW9UCYo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple big node for rebalance operations by changing to
more align with spanning store.  The rebalance operation needs its own
data calculation in rebalance_data().

In the event of too much data, the rebalance tries to push the data
using push_data_sib().  If there is insufficient data, the rebalance
operation will rebalance against a sibling (found with rebalance_sib()).

The rebalance starts at the leaf and works its way upward in the tree
using rebalance_ascend().  Most of the code is shared with spanning
store such as the copy node having a new root, but is fundamentally
different in that the data must come from a sibling.

A parent maple state is used to track the parent location to avoid
multiple mas_ascend() calls.  The maple state tree location is copied
from the parent to the mas (child) in the ascend step.  Ascending itself
is done in the main loop.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 212 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 205 insertions(+), 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d9313e63096e3..50e1d9f585502 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2298,6 +2298,19 @@ static inline void mte_mid_split_check(struct maple_enode **l,
 	*split = mid_split;
 }
 
+static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
+{
+	*sib = *parent;
+	/* Prioritize move right to pull data left */
+	if (sib->offset < sib->end)
+		sib->offset++;
+	else
+		sib->offset--;
+
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+}
+
 static inline
 void spanning_sib(struct ma_wr_state *l_wr_mas,
 		struct ma_wr_state *r_wr_mas, struct ma_state *nneighbour)
@@ -2838,6 +2851,111 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+static bool data_fits(struct ma_state *sib, struct ma_state *mas,
+		struct maple_copy *cp)
+{
+	unsigned char new_data;
+	enum maple_type type;
+	unsigned char space;
+	unsigned char end;
+
+	type = mte_node_type(mas->node);
+	space = 2 * mt_slots[type];
+	end = sib->end;
+
+	new_data = end + 1 + cp->data;
+	if (new_data > space)
+		return false;
+
+	/*
+	 * This is off by one by design.  The extra space is left to reduce
+	 * jitter in operations that add then remove two entries.
+	 *
+	 * end is an index while new space and data are both sizes.  Adding one
+	 * to end to convert the index to a size means that the below
+	 * calculation should be <=, but we want to keep an extra space in nodes
+	 * to reduce jitter.
+	 *
+	 * Note that it is still possible to get a full node on the left by the
+	 * NULL landing exactly on the split.  The NULL ending of a node happens
+	 * in the dst_setup() function, where we will either increase the split
+	 * by one or decrease it by one, if possible.  In the case of split
+	 * (this case), it is always possible to shift the spilt by one - again
+	 * because there is at least one slot free by the below checking.
+	 */
+	if (new_data < space)
+		return true;
+
+	return false;
+}
+
+static inline void push_data_sib(struct maple_copy *cp, struct ma_state *mas,
+		struct ma_state *sib, struct ma_state *parent)
+{
+
+	if (mte_is_root(mas->node))
+		goto no_push;
+
+
+	*sib = *parent;
+	if (sib->offset) {
+		sib->offset--;
+		mas_descend(sib);
+		sib->end = mas_data_end(sib);
+		if (data_fits(sib, mas, cp))	/* Push left */
+			return;
+
+		*sib = *parent;
+	}
+
+	if (sib->offset >= sib->end)
+		goto no_push;
+
+	sib->offset++;
+	mas_descend(sib);
+	sib->end = mas_data_end(sib);
+	if (data_fits(sib, mas, cp))		/* Push right*/
+		return;
+
+no_push:
+	sib->end = 0;
+}
+
+/*
+ * rebalance_data() - Calculate the @cp data, populate @sib if insufficient or
+ * if the data can be pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void rebalance_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	sib->end = 0;
+	if (cp->data >= mt_slots[wr_mas->type]) {
+		push_data_sib(cp, wr_mas->mas, sib, parent);
+		if (sib->end)
+			goto use_sib;
+	} else if (cp->data <= mt_min_slots[wr_mas->type]) {
+		if ((wr_mas->mas->min != 0) ||
+		    (wr_mas->mas->max != ULONG_MAX)) {
+			rebalance_sib(parent, sib);
+			goto use_sib;
+		}
+	}
+
+	return;
+
+use_sib:
+		cp->data += sib->end + 1;
+}
+
 /*
  * spanning_data() - Calculate the @cp data and populate @sib if insufficient
  * @cp: The maple copy node
@@ -3382,6 +3500,55 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+/*
+ * rebalance_ascend() - Ascend the tree and set up for the next loop - if
+ * necessary
+ *
+ * Return: True if there another rebalancing operation on the next level is
+ * needed, false otherwise.
+ */
+static inline bool rebalance_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	if (!sib->end) {
+		min = mas->min;
+		max = mas->max;
+	} else if (sib->min > mas->max) { /* Move right succeeded */
+		min = mas->min;
+		max = sib->max;
+		wr_mas->offset_end = parent->offset + 1;
+	} else {
+		min = sib->min;
+		max = mas->max;
+		wr_mas->offset_end = parent->offset;
+		parent->offset--;
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp->d_count == 1 && !sib->end) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
+
+	cp->height++;
+	mas->node = parent->node;
+	mas->offset = parent->offset;
+	mas->min = parent->min;
+	mas->max = parent->max;
+	mas->end = parent->end;
+	mas->depth = parent->depth;
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -4349,16 +4516,47 @@ static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
  * mas_wr_rebalance() - Insufficient data in one node needs to either get data
  * from a sibling or absorb a sibling all together.
  * @wr_mas: The write maple state
+ *
+ * Rebalance is different than a spanning store in that the write state is
+ * already at the leaf node that's being altered.
  */
-static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+static void mas_wr_rebalance(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
-	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
-	return mas_rebalance(wr_mas->mas, &b_node);
+	/*
+	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
+	 * against the node to the right if it exists, otherwise the node to the
+	 * left of this node is rebalanced against this node.  If rebalancing
+	 * causes just one node to be produced instead of two, then the parent
+	 * is also examined and rebalanced if it is insufficient.  Every level
+	 * tries to combine the data in the same way.  If one node contains the
+	 * entire range of the tree, then that node is used as a new root node.
+	 */
+
+	mas = wr_mas->mas;
+	trace_ma_op(TP_FCT, mas);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		rebalance_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (rebalance_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = cp.slot[0];
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
-- 
2.47.3


