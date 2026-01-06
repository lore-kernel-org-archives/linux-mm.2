Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A95CEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E2116B0088; Tue,  6 Jan 2026 13:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F916B008A; Tue,  6 Jan 2026 13:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC56B0092; Tue,  6 Jan 2026 13:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0B1B6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:54:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9DE70CF440
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:54:49 +0000 (UTC)
X-FDA: 84302440698.04.1107883
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0C9D8A0011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:54:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dOXwGjA0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pajv+6Wb;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Za+I1H1PNN04Mwu+bnlCr0CTuGzyjjbgKgCq9KQhZLE=;
	b=T00Log5HDYb68tbGPspQM45QVNWFmVCPQJzMjzAoAbcvbRRAwwoQMoUv91gBbjnnwUAZdO
	RbAlyZvVhEGgyWv+MdH4XzkpAaOPp/HM1GJ9qmrixnC6VWlEQWLuacsRX15BZjAuhj1jUh
	wVxqmcyyeXYx/MpD0+L1PRJsfxStBbY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dOXwGjA0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pajv+6Wb;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767725686; a=rsa-sha256;
	cv=pass;
	b=OhvUcjsIu6BThNKhFN6FxvVulCswU25Mxry1v4tMlVFQJA6wZsS9h38VKVfFElhNxfSR8a
	qmSwR9NMonJCP1zd/baXf6OIL6yYK+GXDg8V08VrqfDT1W7/UqlgyTO5W11SPoAeCcPfII
	oWKGYGClk6LlbkWC0bqnpytuChXPdUg=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606IBXrY247659;
	Tue, 6 Jan 2026 18:54:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Za+I1H1PNN04Mwu+bn
	lCr0CTuGzyjjbgKgCq9KQhZLE=; b=dOXwGjA0WmlZPRXFGU4KvCRqK42ymnk9qu
	5no/1NzS06WPzajtkLKZdAdFbFp5t/Uv0aUvJL96TAWJrEnkOq+vZkZl4EqoDXhV
	WiyQEoPqhZuSsbcj3wW48T9bPKPvOH6YfDbSOK7bXIJrxg0k9kSqg9bQ6hnDUZmz
	SHIe8ly9288oqFJtpKsjrRHUCDmAd6TMrgkFkcPlruM1hX3xtfAa+YgQn+tZVctp
	4BJCMTcCynE43rrPV+sd4HYDjwgSlWEc+r3mFSfjimLdkoEbgyb42IRMeih0h9zr
	M4MmDNroQ03fTpXIGDQoSQoOobrzBz0+PbyV3lFJ8mBpn/QGdFng==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh7eyr271-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:54:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606HiJMf017260;
	Tue, 6 Jan 2026 18:54:39 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjk7cew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:54:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1K13FHMPNX4koJfvclUatZhmHcbyZ+LMv7dZj4yxdKC77z2SEr6N8tXTBkaNmRlvi/SuhvQTyoKG0c1QFCxDbHAGtc8bDVlRoE4WeCJMcl4jSNxNR4r9EnawI/KNOViWyOTcqGv27UlXWWHRnMLhjMDYdgclheNGIge6SfeocmoISWix4bsxko/hp/dd4U83TtI2CIvVYH79T0sb1vmxjhsrOlfZt89aFYFxOq/L2kZTHkMcHDYRRFKYPfW9KpMgsfX82/82V0PzW1UN54/ylZpfmOl/KnKuTPr4glVGVw5CMt3H1IkHpYk881p+VmFlUe0a5oJnu0ApHZS6zTS3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Za+I1H1PNN04Mwu+bnlCr0CTuGzyjjbgKgCq9KQhZLE=;
 b=bcVx0GOe1KI9MvFtiKRDEL1xdNq93kiyKM54PHFdEVxPzD6sgGwbGFRc8d4vPdtE273zVEquFAF4aVQOkftTUTbWxuWVBOVvTNsWea+O8Oxc/d4+qOgD3eYdRZKObjs3l3P5HxLPVF58Wwo+qJF1jqSp834yCP+ZhgsKcQYXv8sx/8FL+ViejP7ZRaO+G9J001UV0KDR2SGJUoTQXdBxGcKdUNqIxy0jZXmGI9jQqRG9LwF+H6PIPoPz8H0NiFFPmAGJ+4aqSGpbyGW13eCSZA7583GJMMlWiqShHS93zFWhy7g+n5IQkvsyd9wi7rJEgx2QXT9i4zEdyzwdhoaszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za+I1H1PNN04Mwu+bnlCr0CTuGzyjjbgKgCq9KQhZLE=;
 b=pajv+6WbB9CtrZ99045RCCQUf0WjKSlY6apG/OW4Fqnl6yhy7r3APbmQzm9T7k8c3SJa+YRu1frVhj3XAEapYYRYZZ2/MTX6OXPaNOx9ROA0lhkPawutsrCuZ0zLL6F25W9r1TNfatb8/qd4RychOC+rpeGJKQarVRgirAyYtk4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 18:54:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:54:35 +0000
Date: Tue, 6 Jan 2026 13:54:32 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/8] mm/rmap: make anon_vma functions internal
Message-ID: <44ystpkmakm7hurg65min2mc7pzuqcojcvuxkwzcrb224px2i7@abel6mfu6jat>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <01fb330542cc1b9437c1a9d1f54432b0547a1582.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01fb330542cc1b9437c1a9d1f54432b0547a1582.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0184.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:110::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6798:EE_
X-MS-Office365-Filtering-Correlation-Id: f47a3ae3-f187-4eb9-709f-08de4d550943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jlVGONPBCJNB4cTH/++i5SlvmsRkJffP/HY27p8gM5r3J9MMyRunPxemy40M?=
 =?us-ascii?Q?iAwakwtDiMRFs5qwWGoXTR71Va3d2n2niT7W+hV6HHSD/SF7007AnX8Huiyn?=
 =?us-ascii?Q?oU7+zpHOHtGIVIjVqq6dJhfs6MJ1aBbAG7Tychi1N91W36Xk4NK6aD6jMv0m?=
 =?us-ascii?Q?3K0KmJIB49nQPHtsvEHjtRVDGLNj7aOOk9Qk+uE1xhg83hTZYeFTsZw1By9y?=
 =?us-ascii?Q?R+1o/85vH9VRQnCX9i06SaEQy98aH0pkHg9dBqTDlBBclkTdgCeq3rj3AqSK?=
 =?us-ascii?Q?dFp05pVVIyDH03XhfkMNadyOnnqbck/NQvnXSnJPknr3Nva41dWH5N3yrg0K?=
 =?us-ascii?Q?yenou9YsHs4p0KJSoNC/AAP/V8YU2jjOb9RB/j61fXVKrAlBQRPJxKW/+fHe?=
 =?us-ascii?Q?GPsNqOb8XPLcKyVmg5fcRvYqQR3ozk6EmWknVnIMzwHMF0G2dsCD/PWPUwdV?=
 =?us-ascii?Q?1S6KAuHaca65rr/LtNCvjSppiAy9Bq8AplTnsRdBvGZgJktx0l4cRsVb4JND?=
 =?us-ascii?Q?epVnmy5E0ja34SmQulmeay6kuYKZEiDfLiSIbEB29ZLqT//HJ2JyxAtH7dy7?=
 =?us-ascii?Q?Z3bbG/f9RUXujf2t1hngVO6hdb/nOn5DyGf/+IsvlljHYMR2ukVWG83mEs4A?=
 =?us-ascii?Q?hJ9mU+O5EfNp9bdZRKshm6oMFTBa1ic4IaQazcFB+39EV3qzYqtZUrW089Fz?=
 =?us-ascii?Q?JAK85igr06tIeLLU3et/bWjU07u7OjZb7RazGigoszyvxFInenIwehBJCy76?=
 =?us-ascii?Q?gbrEvgpK8VFFWp/a9qmW866e5I7Ai6+hR14TRuOP6VnAw+seXNG4YsHVoZPq?=
 =?us-ascii?Q?evMUthStzPb+wUY1FpGOKntB2qWhe1h5sszM2dBHsiQPtlzeCuubNHZ/0wet?=
 =?us-ascii?Q?gIH8CfiLaInec/bX8pLMNTu0Mf/3r1WzfKXTpHVNXRNwLCLUoObksLHvTwpE?=
 =?us-ascii?Q?Cti7zg8xVtEaOWCWn+4UHYSvFXxol8vHOfPH8SV5h8kzbnyC/VGx/s6+GsNI?=
 =?us-ascii?Q?heCDDMY7eP5rsh2cYLvGw7mCNeFEBYsuYWCXghWGd/HwmwQXrRiNU/H29lOS?=
 =?us-ascii?Q?5dCDr44js8kKdTmn9BeAyhhAnJehm7y2hp2/xaORFOMGB/sMa5exz1uGhPVl?=
 =?us-ascii?Q?ARi7ElLQXBckI56tPwxauPjZl5wlZFJcWh8Acl3XigSGOqY//TvdrRutUE5G?=
 =?us-ascii?Q?uRV9T1AbEb5NPzIXrvpBWJli5Qlx8OuzTdy74mW0zCxHBXK+HfrmOYHT5S+t?=
 =?us-ascii?Q?5e8HDy2J7oq+UKfaEWiZMNR8/2bY6v0N9up6juX30H+z+BsQKpIPpR15rCSP?=
 =?us-ascii?Q?1mxRt5gqN8MhPMpVgycil12JdEWrtf55yR+qnbpwikSGp1tg87krTwcfDoQq?=
 =?us-ascii?Q?Cq9txEm5c/26ciG1WrOKly2whrnuYBoGA76PnEoGk6n6vZg7DfbTNDEpEogC?=
 =?us-ascii?Q?Rd+22kDklMwlmuawnLAUQsAw0B1wbHwC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DWWGAXoY2lQN6gaX67GkU8BHHDrSaxwsgpqumLj8zfIa0I3WOtT63dTfjpgQ?=
 =?us-ascii?Q?UUhzoW44fdFk22B41BUqob73SZWljYYxPdSegchyFCE7jVJSNLIOOIopyXCW?=
 =?us-ascii?Q?t3jQAmnbbcVH/ICJtUbwK/52DA7Vdr3lSSYDC5Xf30kbrtulT0cPXqkDdwK8?=
 =?us-ascii?Q?RYTrh71H673BBiG71TfvLp4ld2azGj8K+lrjFxZn8otS3PKa35pvxNioww8f?=
 =?us-ascii?Q?W6DElU7Uv/sTYYjXVSnYyQTT/FVsSEuryiQD0REzoY6V8detST60/AeIqC+R?=
 =?us-ascii?Q?pS2DNtJ8kRbP4swWN+Rl8jWwr5TTmq25+GMYAd53c0o1qo5+xEzAJ09eNuY6?=
 =?us-ascii?Q?vHy7tHIhpVTnZX3Zyiygl83SPeOuiZb74ZRYCZP8FzBKKDjS6hQVSmHu3NAI?=
 =?us-ascii?Q?FONQ31KKEsSZ7WxkOKjKo7kSjyBYXXRYSJswNXM5XDyzOKBA2zgPunH+9MY3?=
 =?us-ascii?Q?cqq3Hqs2VrO66hf6hXDcWdKg49vP7KK9DzVTxYhspdyP9IxaMg3kktByp0cM?=
 =?us-ascii?Q?vP/24EZNo4R9WdOmqP0eKUzxOvqV6e78r0iM4stJIbHh5r0yZkLipjz+lrXr?=
 =?us-ascii?Q?0EgD3x2uu6+7kC7e+QRwI8D0xE/dJ7Lrepsk2ZwROSQu/6hqC7jEQBnoKjc8?=
 =?us-ascii?Q?zfJJRHQ3TXfYFNuedHQtfglFtwuq4t9uXx12P5y5AVRgkHhcRdpWXHlKqd9w?=
 =?us-ascii?Q?aqTSKmUTy7VSnHLEIkTrzf0mnYb6fTZLPLG60g9Yp/9fMV9aHcyHhWm1KwL4?=
 =?us-ascii?Q?vyeRAG8Zmssasdn/Z0mMlOoKtRxzb5UABILJMUbj83KnlWxHEc6t8Fxotjwc?=
 =?us-ascii?Q?fHZFKPo3P4LrW5wfYC2fBGdlvIPM+UeJKk/xLIxP+6y6Y29NxZs/yIJQsf/X?=
 =?us-ascii?Q?fRi/+Ljb11jJOjv0qY6Wb8LuMpr6xxzHEcmCF7e1omh87AHg4H2JcTPx7VHX?=
 =?us-ascii?Q?fgW5nb606+qCBaQXZOD3vgmtF1IV/Bps41PbPDGzoL3vcUDWHLqC3ULaRbf6?=
 =?us-ascii?Q?VU4Bsq57peaQuUzc5X+8XUgzbhM7hwh8AqZ8DbKJiJ8CsezgJD8ngwP4YFsd?=
 =?us-ascii?Q?y8PsDM+Ujoi/dEbhYyTmIy3vIJu5t4Qr7Y7btLa2pnhDHjVDsUwjOaZzf/FL?=
 =?us-ascii?Q?PHPyNmwQ+FjJifUX2PzDS6vUxrNdDhAvq7+CdG2NMpDsvsylGX1BCaZEfYZK?=
 =?us-ascii?Q?qdeKCohw+f0+tLwBxIQLKd4l4SrphTWGlTxrGodx8RQAyUDbDjQXBj0b1w2n?=
 =?us-ascii?Q?RBlSV00nJ5wBPpAE0InYXYYb9NyhKcMka0XW+GiN7wbu9fL+7wk2OuAjk90N?=
 =?us-ascii?Q?QrXLuU0vuxPwMsJx5wiLjymoZ3lwHVAQoiWc1Lqq2A75uflDJWV3qkeKlCZe?=
 =?us-ascii?Q?5w/tCRXngi0N6I5MtCk1LB1p4DXKQJaeP5y5Gyu+KFw7JixvKibUvBgz6tZw?=
 =?us-ascii?Q?8atfHmp0mpRr+vnd1zDQCaurAA7Of1zD6KgsJqOrf/bxXW89GkXyxNT5UFkk?=
 =?us-ascii?Q?k+0a9LZd3sakTbbsyk8SoV1816RbxEAQ0//jMydo0GrcEAuHxq/nlNXZQnUE?=
 =?us-ascii?Q?PlxYrliklo8+Y1gZyFPBkxPauak3BP+ou1KnvDzMit+Lb9ZtCwdG0EeZ8DKm?=
 =?us-ascii?Q?FVdAz7enmlDnHQO3J+h4I+Z7yHjM3Q9wIJV4Talt04D5D6krpRIwuCBLTV7s?=
 =?us-ascii?Q?jyHIcOevkuI9mhrYiIP2VpjqP7FqDdS8FkZtkTFzwzExNtPyIS176kI5Qgmj?=
 =?us-ascii?Q?pVEx5K4qdA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mA3ZyP1gXt7LzgYwKVN1F5BoT+WX8d8QBPLW8pX6YcUlYy493oWD1vLNHo3vgyOdhTGO06v46XokgZK0kULDEjS/k5LJL4J98yX6efEQRza9DtuZ7Lm8ktSy7olZUZDyg/jJmsTkCF4YqaDeB3Z43Hba2ulTHXxU8x3viYuIqDThSfDEgUJXXjQ469BGOBMBY/gZOSDDFSeFOR/hT2OlMn/9sDDZXo7BQdCWXJRl5cYJFIaWngB9P4lyShX+9xnYUchMftj/1tH48V3pt1U9DE2M/Jo7gHDPy1NiNul0uNmhGDwVR0upwxqhrbkM671StT8XG9HgssDH0pPTTLImgRorWkmMnXcne4wdpAEP6uvrUnf/52hRsGaoJ4YPChfXurVGgfk7/TH8P0X/7NBN47e7+1PKlAN+hNv09jzNB06ODVWhdYXtUUQq4jpTQGMz8L/1X/3bHDNL2/n10K6U/tcIwtTMKKSvbloUrP0X1/4MlFPwf6JEnShwY7tAXY9OZXDsa3+bGX+DOjzGxn0z6uv45OqhcNxVBRxJ0UfithDESLPqmqceA/4ik42qSNhv92cOCp6P6+c36hbHkxIQdb/5wpCNFxhMrzrkRRtvgHs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47a3ae3-f187-4eb9-709f-08de4d550943
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:54:35.7302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lg93kq8FpceS1DY9LPnwXGyOvgnPMbtY42rY47JiuFR2jQdY73qAS9yv/oDfR3qN2HeZKnYIEeuE91rIimDsjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060164
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2MyBTYWx0ZWRfX0Y44+YBszbK5
 lxUco0Sajy/P/uVq6wGVCN4ZMB0JXAfoVRBRknBZu9oaQTaqCy4aiohbCOP6UXfPjSy8CLuMbwK
 m0vHNZETWA8jbwHIb4nyfZGXr7AdWultt18Dy2NVubze0tRlF9ywkYQpy9gcjEX4MDs+UNJCY0C
 fFRm2CcEnUHJ23xGdkqijQyBK5ovaD3h0NwunpN7JvN7J6dWsf5WMKF8csXaOYqMOKGtv3IC0Gl
 +LIbOzhdQnEDDJpt8EFGQcOlHV8WNHBTTeZZzIRfmf2SlhOC7Jr2huvuhxnMpFNqcvPb2ExtQ6t
 BwscA58aUSnWGTQy99Gww7TmgSl6MJ0LBQTMk6HD7XYNzqbHE5UbJEKkFTkdSFtWYLO7gYmjtqa
 MAp31dDJd5YF6oEXvJ58bc9Slr8Hs247Cj7/gTEuqzW4cQvl/X1aKbMGer/sMoySOp26yQFx9Rp
 VSO06y4qfZwCXNXTd+DIzRHzS9uGtSS2Kmb2t4Yo=
X-Proofpoint-ORIG-GUID: wteqnvfsdExo0uCbsWUYy2CDLWyfKG9a
X-Proofpoint-GUID: wteqnvfsdExo0uCbsWUYy2CDLWyfKG9a
X-Authority-Analysis: v=2.4 cv=U+SfzOru c=1 sm=1 tr=0 ts=695d5a70 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=RRxkZUZ9Lt8eHEL8Ut0A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12110
X-Rspamd-Server: rspam02
X-Stat-Signature: 5ryxqfn1974ifqw1a1nwaupw78bfz397
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C9D8A0011
X-HE-Tag: 1767725685-326177
X-HE-Meta: U2FsdGVkX19mbTBMzu+whBl4MnOQ4RliYWHv4RZrhwAkQ9SF4a+hASRt/XFpaDb9u9oJH7kaCYUNwEhkbJ2h6tuKbS16lLEIFRp7VUd8ZPh7yJ69CkKjngcN36z6yJAiHI2ZqGMjA32OyFa/orhhevBCGZGRHxbmhxR0l8Wh0D7Zd28KCZRnLIb1uMFygyYGjWLv3OsmFgtxatCAne5AFem0Wx06mU4fQVgY9FXfKvpKW604+FzCKtWDsqYoKvLmruwTCTSlX3Qiqj1sn3Bi9b+b/rV5e37bUXO6wynQKhN2ARaPjJbFcPWaxSer7pqMAGOD7shYdrhrHdmt3OIQRPJSmyr2iZ6vDWagfKvsyFkqozVBtL2X68v3o9D7Ru1ue+RYmbrE6gZVpudbPo1J/Dumz62EiT0f+iVVQdWLdpVyTOiyMo4i8vvmT4g5uNa/qucSiOAprcLf9txhpzAcFYTQ+HnoVeWbxr7ssT6rGvOxzoYx9pwjMcKYYAsKEIaGXiIblVIKkDoOgAXfLTckKDHmoHcwwleQ5osBO7mr5knUcKgL/JzqRSL5CV/7H9nQSjRc5vpbJivb8M/30kUYu1SeIZcaCWY98y3mK31uQLoV8Lgb8nG2NDSUVmUavazi2rtC29c2hswYOqVQXNK4KEJaAKOfcP9sM2ug1FCSN2K6dZq6NzgbjlIVa5D2VublOBQLf4IiEXw4LrM8ecCTHj7sUszFjF20LC6kO+VLTBaysfyMtFXHGEbpsxGBvZRH75uZNAPRKeclyTLD3YL+M7ClzIJqnhBbGfUGJM8lsNhoSNDM2Xx6h+1hyteX8S+4TWiQEhS6MertQ3ZFJ+LgSc+LMAuzuJUpNEoASnn5lOIeCCupq24DJz6W4fsMDzDi1fHN3zaR5MbLXdaD8oRIcSHiJp1roiQ++eOg91Q9Kd3VaD5TIJJGVb3+2dg7UhQbm/zf6UGGjdFrF2sASD2
 ZxTT05oP
 h/cxPdYnVBPe62sbY7AijTHVaCy5L8qxo/qbLRmtWP4XYGXfwlBtdqpqNjmn0R9oIKJxdYtQDbuw2FfMqSWZX/i64VLVjiTUio5S+I0jQMJzYqtCKHGLocjkJAjyKBWk1e57OSzynybamumKsOH8t1uPwvc0+dl2B1fsQHrtgemcHzG+EQklCl9iA3bKiPM2UjbN2IHsfMyHIKKAA62l8To2WNcs8yNeUn0w6komhIz8BAM3m53srA/3A+ZOqNYNNo3o5MlSxiBFdz0j2RqUUUGxRDbg2zUHLIuGl7Rt5gZBFjHGnb3IstCu2m5begAkl2IK6o6x+NXDvMn0JnY1wdeZbkOVbyD+Ed42yrX7+flrNA+wSsP0AOOaXXtLxS8vAdullkICjocbNXONucG4VrHCR/u1Tgc2trrNjBqHXnFgYhqFqT5xczw2IKHRvelZ0U6p0uzN1mHaPXjp8UJ7JgJnMfUs0Zd+MTrJi+ybO7JUnnOyIjvLF279wr/RKJfi+hmxHiaRdNmqwoInIKV204Q4BQFifOkkPj6+lPKisVxL73UXlGvQIJ7hKLrppXpKtUadEZAT4LUsUu0ohBSR87YDW5aQ9YLJkkKK2rfuNZZejsEX0OZEzw+263FOV1e4FHuc45Q7rW6lsp54MTmZD+P3Qj7XOuMkVFs9OGkg/subc+4MmwXrOxdChgcRESgQ+FVrXmkpVp4cuNFn2NJvhW2UVaa2OESjGgjX5HcNORiM66OAzsTduB05klA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> The bulk of the anon_vma operations are only used by mm, so formalise this
> by putting the function prototypes and inlines in mm/internal.h. This
> allows us to make changes without having to worry about the rest of the
> kernel.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

nit, One extra space in this one too

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/rmap.h | 60 --------------------------------------------
>  mm/internal.h        | 58 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 60 deletions(-)
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 832bfc0ccfc6..dd764951b03d 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -104,68 +104,8 @@ enum ttu_flags {
>  };
>  
>  #ifdef CONFIG_MMU
> -static inline void get_anon_vma(struct anon_vma *anon_vma)
> -{
> -	atomic_inc(&anon_vma->refcount);
> -}
> -
> -void __put_anon_vma(struct anon_vma *anon_vma);
> -
> -static inline void put_anon_vma(struct anon_vma *anon_vma)
> -{
> -	if (atomic_dec_and_test(&anon_vma->refcount))
> -		__put_anon_vma(anon_vma);
> -}
> -
> -static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
> -{
> -	down_write(&anon_vma->root->rwsem);
> -}
>  
> -static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
> -{
> -	return down_write_trylock(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
> -{
> -	up_write(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
> -{
> -	down_read(&anon_vma->root->rwsem);
> -}
> -
> -static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
> -{
> -	return down_read_trylock(&anon_vma->root->rwsem);
> -}
> -
> -static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> -{
> -	up_read(&anon_vma->root->rwsem);
> -}
> -
> -
> -/*
> - * anon_vma helper functions.
> - */
>  void anon_vma_init(void);	/* create anon_vma_cachep */
> -int  __anon_vma_prepare(struct vm_area_struct *);
> -void unlink_anon_vmas(struct vm_area_struct *);
> -int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
> -int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
> -
> -static inline int anon_vma_prepare(struct vm_area_struct *vma)
> -{
> -	if (likely(vma->anon_vma))
> -		return 0;
> -
> -	return __anon_vma_prepare(vma);
> -}
> -
> -struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>  
>  #ifdef CONFIG_MM_ID
>  static __always_inline void folio_lock_large_mapcount(struct folio *folio)
> diff --git a/mm/internal.h b/mm/internal.h
> index 8319a91e363b..4ba784023a9f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -199,6 +199,64 @@ static inline void vma_close(struct vm_area_struct *vma)
>  
>  #ifdef CONFIG_MMU
>  
> +static inline void get_anon_vma(struct anon_vma *anon_vma)
> +{
> +	atomic_inc(&anon_vma->refcount);
> +}
> +
> +void __put_anon_vma(struct anon_vma *anon_vma);
> +
> +static inline void put_anon_vma(struct anon_vma *anon_vma)
> +{
> +	if (atomic_dec_and_test(&anon_vma->refcount))
> +		__put_anon_vma(anon_vma);
> +}
> +
> +static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
> +{
> +	down_write(&anon_vma->root->rwsem);
> +}
> +
> +static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
> +{
> +	return down_write_trylock(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
> +{
> +	up_write(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
> +{
> +	down_read(&anon_vma->root->rwsem);
> +}
> +
> +static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
> +{
> +	return down_read_trylock(&anon_vma->root->rwsem);
> +}
> +
> +static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
> +{
> +	up_read(&anon_vma->root->rwsem);
> +}
> +
> +struct anon_vma *folio_get_anon_vma(const struct folio *folio);
> +
> +int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
> +int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
> +int  __anon_vma_prepare(struct vm_area_struct *vma);
> +void unlink_anon_vmas(struct vm_area_struct *vma);
> +
> +static inline int anon_vma_prepare(struct vm_area_struct *vma)
> +{
> +	if (likely(vma->anon_vma))
> +		return 0;
> +
> +	return __anon_vma_prepare(vma);
> +}
> +
>  /* Flags for folio_pte_batch(). */
>  typedef int __bitwise fpb_t;
>  
> -- 
> 2.52.0
> 

