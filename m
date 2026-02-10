Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAB9EB271B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 21:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73286B0088; Tue, 10 Feb 2026 16:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20CD6B0089; Tue, 10 Feb 2026 16:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7B06B008A; Tue, 10 Feb 2026 16:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8FE76B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:42:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5ED3F1A07BB
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:42:45 +0000 (UTC)
X-FDA: 84429871890.26.ED232A5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB66220007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 21:42:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mD81cX3W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUVNZlIK;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770759761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta40VthM7v60EFpuOXmaKW5kqCd3GTz4J+xjzc0aqOg=;
	b=cHt+ad2Cn4dxnpq7+OsZojXYuxVEQhd4scLHS6e4ef2OuzqlbRYvl/5+PNc/NgAmeWSXMd
	FGJ5bkESl6+gDBlB/OQm2Xg3xcLT3TEPQ9/G+0TvExcKsltCcK5nE6Rb0eyly54cuHXLhO
	rLbrs7Az9PWoCJRBM7af6TVYZrag3Po=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mD81cX3W;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sUVNZlIK;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770759761; a=rsa-sha256;
	cv=pass;
	b=B45w8nd09cDAUaoKgRO9DP6QfW4RBV9fj/yL1Pp9L8IY4EkK3jcepRiEAqM9Tv6d9Arzkx
	CZLBOpBT65xXpP95TRZdrE5EaG+ekWbwiSKtYRbj1p4IV0vaQfnMun3RX2McICjnIxJdPK
	+2wfCqGjkOCxd7fc8JPrd8gi/cjOpVg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AGeWnn1407038;
	Tue, 10 Feb 2026 21:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ta40VthM7v60EFpuOXmaKW5kqCd3GTz4J+xjzc0aqOg=; b=
	mD81cX3WnRhOwuzAJ/Uzi8bSWptyf/KBdPteUuVibGipGiD10iGtmjgdl9j71jwd
	gpStbbSuJd3NS03Cea8QMuV4vTZls5jTekw3YsgqwzR624+zKGswN9mP/WL+A847
	7NKA41nyLIVpS6eYGA4WPn6NZP81xqEUEft7AZ1IN6Dqar+9VxfNt4qsC7vbrCvb
	3FSrh0D/mS7XeN3VTitECnfDUf1SvEzjcSuNm0yKnnJjDhrotKjK2mfMzbvs3WfV
	H/XLOTN1CKZM5ZJ14TYFTlUp+Nbm3dTFWyHOrVkqAWD4/nrisE0tCOiQGVJMBU4K
	RSi60yNborf15mHE2LHLYQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88df0jj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 21:42:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61AKGGkM008472;
	Tue, 10 Feb 2026 21:42:23 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012031.outbound.protection.outlook.com [52.101.48.31])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c8234wsx2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 21:42:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VURMiPfdji/VAvRh1QmUCWuxXpF2sRhoihJlI1qXg0W9EJSUBLJvsTA10HG77g34EqLLQgieeeRqBXDYluoolInvRbggmaQN8U52rBv8cbuD2U+8xCXsTA7LOkQ92r+xiWLNPHRqGLPy7im9S4zkfY58vsMbnYY/Kyh1Go0TAjfIugnJZ3jdcX/2KZ9ZZtVYXq4PgEZ79Ud/ICB+GVX8+6i14sRlZOQ349apEI8Ud9EovJaeFB8S/feiHipJxYeZ8EZjX575sgw5ROEldrzkv5yOO2qmV0A3qYx6MyrD4DMSTsVsZj3PJaWJn+EtyTfrzTV9eeODokY/ztWhHIBGZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ta40VthM7v60EFpuOXmaKW5kqCd3GTz4J+xjzc0aqOg=;
 b=rjmhWpfNsLbwJyfQWSUHKzvVMrL5l+F/lMYW/lPV8PEM6qiMlZ7TgyEA6PjCJTLRqotLeaWbcrAmlzD1UzV9NfWGdJ/F9UT8GZmX29+3zdvbd4LUlJn/04awxi9MUQ43UAup2DfXvRksw+q+C7qPVK+tyS+5ogRgpknTFrvJSAT1xIajB1sKRZNX8ABYiJcCL2/RtNwk8JDbZywmls2Oo5DMjphzkQS7y9w6pRjHa7CBKzlr283teTrYzaekK6KA8d+I6ZopkHi446lU0GupGtXFtOe/GA+hUGatQ0bdwD76lk/i4vca1b5t4Q5eM8z3cRAb+Ju1+PGyCij4f6j3sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ta40VthM7v60EFpuOXmaKW5kqCd3GTz4J+xjzc0aqOg=;
 b=sUVNZlIK1YeLlbnfifHe3wT94UoYhnPcAb5mn5pXoBXiLTJta8NSs/IKERe4ykS0Mm4JIt1qGJX9/HkqNtJYjPDwlUReXeq+xEAZr6FxONs3kluEmZz2ONG3Em00cy2MJeVyZfydFG3HvxSDGWYeEuomjUsFAcefjnTeKbeo0NE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW5PR10MB5875.namprd10.prod.outlook.com (2603:10b6:303:191::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 21:42:19 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 21:42:19 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
        shikemeng@huaweicloud.com, song@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH] mm: Fix up unmap desc use on exit_mmap()
Date: Tue, 10 Feb 2026 16:42:14 -0500
Message-ID: <20260210214214.364856-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-12-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0213.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::8) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW5PR10MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: af3d1728-3e00-45c0-9b49-08de68ed444d
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?3CiBqxmr1GIHLcypfwA50+5EnqqllR7jC47hvW35ADqS7fBCdZUSGTH3x4TG?=
 =?us-ascii?Q?9fGaWSKJC25rXcohLUqvZLg+5OZDTZSirAKaHRbqXtOV3Ft5L2Jt9Vy2Dnqa?=
 =?us-ascii?Q?8mGczfumLDI7GUu6TYFGfPWuMEbMmMA0Rn6jh1hCPzUDR8pOy66oK5jk/oG+?=
 =?us-ascii?Q?215VGXQu7SSlIq04ISctKu5SB+4XCkIGGRpMBlXAXR+IsMiWEt233xielDmK?=
 =?us-ascii?Q?pzHF5OfShi1FSrSJArAaxa6nAIW/mPvuw005PqtKVa9KW2ipq3uYGknhcdC7?=
 =?us-ascii?Q?mL1FTCPpoUCsDBUXddwPZHvO3/xRU0+RpferUIx+zU2kvcwhAHr2vtjsl9+u?=
 =?us-ascii?Q?S45OeKQvxaz46Xn38JuSeOqHjzW1HNNsY5T/DPSluPui50PrZ3bUc/Eap5Ci?=
 =?us-ascii?Q?EF9lYfGQGB0CCox+hF8IS/ilDH12xl7od+sMtZJK0M8oTjUOxwpRVEWxjFqX?=
 =?us-ascii?Q?TlFTzPV5MIdEZ5O5V6DDCCwaqhpuzMIAnV9LznR/YLigezn80m6p4+DuPsSq?=
 =?us-ascii?Q?L/2M3O3VUZuTzHFefLZJI/p8YloakxikIROtW6zbt9Jq2pw/kHDRes4s4g7n?=
 =?us-ascii?Q?BxenL9ICRvEQZkuQIdwmLateA1MRR2y3+i69OIet5PJFIGefHyVgDU0PN43M?=
 =?us-ascii?Q?9C7JS07DbdmWoJHssTvEsSp0ggsjGl/DWQJyJUsLseAeNflTwWhGrHfzdGky?=
 =?us-ascii?Q?QgiEpsPCoO0ebSxuQVjWyyYmmHrmWPSVfOcvvVZq6uvK4Jl7skkRc78lZngS?=
 =?us-ascii?Q?aE2QxXCGGEQvO3sQiEEwvtz7yfEn9n5Vwi1VtUw6K+Ac+CZn/IG7D96hSr4q?=
 =?us-ascii?Q?edWFziqnbxKYGf4CMN9fqZ6Oa4oLC1LA4avrpI4xSwXr79rU2wJDz9jOs9pG?=
 =?us-ascii?Q?1NXM7Afu5OpV6vA8WO0wjaPq+lUmW8fCqfQL3WBBYVZMmY2w5Bjz8SuKV9Zf?=
 =?us-ascii?Q?QTiGkS/ooyRT8lQwzLXo33e97E0pFT+pWobNkKnH1fR+T176xaKD3YayCtcu?=
 =?us-ascii?Q?npqKaEx3/jhA3IgSrMHOioi4SkLPLKiyGjnbMO3/vYiTSnaiG6mW8yX9CfkX?=
 =?us-ascii?Q?ePFkbTifwmQKajgaoiKnJnP3tadzlfBnVtOGlHKAoJNvXmrbIngmh8jh5zmL?=
 =?us-ascii?Q?aLc8e6dohlAwxxZM6AAJ1ltFD1xW/XEKq5nEiyDtkP5B2UTpW1e6bu4FwQyW?=
 =?us-ascii?Q?D1HNoBqJegw3KE8dMjyoYtwdoj34WNiIXboHwt4iUOu0P/nHNXqj9072vH9v?=
 =?us-ascii?Q?9BQRNiS+Q9VQmdh1rl5OeonHqzMpM5fskJtOBkb1JhQcjacqmtuNAm6ChdqD?=
 =?us-ascii?Q?ZMlxBl8LVHOIIAgbVSVZtsbXzjd2bcpDTqR+oaBdk1U+Qg277/hN1umzwkui?=
 =?us-ascii?Q?EcL2576nH4NiHY7FQGvH47S4ec8yeLUuZMUzNLwWAezAoEVazSTxH8CYLg3f?=
 =?us-ascii?Q?bWH66dRxho94DslLoG4I9QrLw/D2p5h/knU7AM8BI+f1GedPA9zlJmIEylln?=
 =?us-ascii?Q?Bdb+K/xkdVUMya1Ve5szw7YDtaEefOXyIxbbv56Db8U3kN6th8znFh6Qaw6r?=
 =?us-ascii?Q?fUEDzSExBJfH7tkWCl8=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?1Fm2r7SKNDduOaXZOIfxgvQHpR/phi8XMw/g5twX5CtLN/58zIq3AUWfmn1A?=
 =?us-ascii?Q?oO2RQjkwi3JeR42CZhUXR+kWVFY4G5XH8LAQtkn2sBwqXGTwyXWiCUTCdW64?=
 =?us-ascii?Q?nic4jVjflyYMn6MQL1J20fGjeDX0gOTeK0Gcok0KcPmOcQfZ+6jzvlH5+zGv?=
 =?us-ascii?Q?HmH5VOH5qDbpoVNU3LNnx6W3z7pO6na9lttx0NJfAcVKy6v4SiqHyxiWjC6V?=
 =?us-ascii?Q?0k4ZoNVNpPRnyAiFJHLkoHYyFNZJBrLkJ51p1x0oOeu5QjiDLRyNNatfqtfQ?=
 =?us-ascii?Q?dJXszMbkKIOvajZVMPIwzCHyeGQxc51WzXseP1pIsTppukZNwQpY78dsffi5?=
 =?us-ascii?Q?aGlKgauZ43y558Ux1/PaGlgIWqj64vJ4XbzkYad/JMqsTyZD0A0HNYa+vjVO?=
 =?us-ascii?Q?5TMNLBKXKzCRaI6KRtUn+ay7JOpqSO6G9zFNBt0PcjLnytp17xO6NBkGyYEe?=
 =?us-ascii?Q?j04LoTp614WEipUJV3DNM6TB2JjEduZ/oY7yCJ1ugtdwfAnaMABML2cRaRFM?=
 =?us-ascii?Q?9PeEASIOTvH6hcKrhpsF03FYU5psGSQjEoBk54L89LYbPfyqObU2sV+wv9S/?=
 =?us-ascii?Q?34bvptoAQE3HpvN3y+1PCSk/I2vmqoFY5voT7uuBwXBC/Ake2IIcygnCnCrz?=
 =?us-ascii?Q?nu7SC3/LbHbVSiJeQ6km+VKjzopckx5AIguxpxygvZ9rNu5QDtjkkkP7lzER?=
 =?us-ascii?Q?CKj8pQZLc8S93oXVYU5h0yvQ1vY/poWkKKoqaqTkD91r4dhDk/j/QjiTnWMS?=
 =?us-ascii?Q?+O1my9QUF1sL6fISf3nxkBlCYfEdzktGiGyRJ9fRuT3/97dihJquvVgVxWpt?=
 =?us-ascii?Q?VbUinx6Q2XaNNCFIDRAhJ8dfpx8wFvdyqfMd+VEuYpqPtfKxzP0hhWowtYRx?=
 =?us-ascii?Q?wA+9R6f/vpzdrPGzQ/8qGYoGOmtwMhbfZ08GS6X8cdzSqWGLDYmo5VpDn9bb?=
 =?us-ascii?Q?VDeVb5S6fiBLn/YLSlnjBFdr3f5P03detncam6pf0AM0OrC27EKtzP8vCNbE?=
 =?us-ascii?Q?DNNba9BTgPPUjrpu6cpCTPBcnycdOuvtRLh71mzPgtjnCYZ31/lOsdEYTZyA?=
 =?us-ascii?Q?eAYLEiJgyAv05Stas1CmkVl6dB1/LzjhLYL+Mkaxc/ZReKUozPU3YhyyHUMC?=
 =?us-ascii?Q?sW4omThDAmUacVXtQhBscqlqu4tcfNIpB6DtZ9YNyjs0lW558OsbIEGWC9Vp?=
 =?us-ascii?Q?wiM9sLZqa0xHL7dzHTAV/5ViqdxFaNLXQ2wAF7TveGMupqBmxKgdSit9w6eQ?=
 =?us-ascii?Q?IMoOqVJsUwzz6LD/Nn07xBGCi55Vv34JKYd7P4zJBwm4XW81FB24WvxHG2q7?=
 =?us-ascii?Q?gbC83PKNTUBOQQIfgLapKT63s8EOOrzofxYl8W3SyKqVhiOtnpAPX3xMD0av?=
 =?us-ascii?Q?l2wdcGOTluY+e0iANXKstVAEUOZ3n+MlpKaHTXSmHsgjYE+juxm9BcMoJviw?=
 =?us-ascii?Q?mTaVxLmHT4ON21S8SYVO4zwElGG4i/Gs1VYb6Kpj9N3Erj8VJFEZYFULxc2D?=
 =?us-ascii?Q?vIHir4qYUDLVrA4isD9TQAMdp5wxEUmzLYvIveFXjcAuX+pOiusP6YRMXkdf?=
 =?us-ascii?Q?+ANHYgKUXfkKXJ1stHvvV0tmVaOPzOLR5cX2VWhWKXtJX/7r8LtCSI33hgHS?=
 =?us-ascii?Q?u0inXkc4ut0cFm+lcwFwbBFMJFHgZQlfCPhctnDYdYVz3IBQAePTaz/LWrzZ?=
 =?us-ascii?Q?yiXvxN+mcrRgnSw004h7+55ZN+KenIx74lUKdeiDKuEC+HmHASU3qQz2bgft?=
 =?us-ascii?Q?WLfowOIeWQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OO/ZQPbqpoVHi6/mZ0Ala4W/cIDLPivD77TOXmQtiF9JDAGuExqGGNVQMluyjhSWjYszgB6GiCiNJ6kHsvfzN6Y2PiZTsohIrlNeepZkrwRgxZLRWMg6/lQxaKx66elfp0evZ0GlTFrK6SubNN9odxf2OiENo8mMRcb2DgXaEyLFcKrCChUEAHrg32VhF9wAyUjuz4p5Cx/JjuDO1WiaTMVxEO0Wir8JgPq3U7HiYMJW5JvpRsV1yW7DYa6vET5Zg2X09l2gM9C1BWMsu/d8j8sTziDOyA8qOj6jkZ50ygMPhZbwuuXConR0zrpxo5Sv62NhIrAOOOX4LMx/maw43f9hDGUApwG+PgK2MUeVjpQiuj0c7H8EOBLMAEmNGaSWnh7tat6xEf5WiZG9SAyY2P8JzZs43F9ONOJc399efhJJ1jyCLsd/+G3uynDAhNqkIEXzlnvtiEgCqBO3jXZH/kRggmsfOmzVnH2b5YDPx8INNX8YE/olh3x9v86aW02Ed4AL/9w0FTmQtqd9mwYSaNif2wx7KZZzOsztdr6+n3rEw+IWe8MbWEGUyxI9V7XOxQm9lNYkS1qJVzv8sKXq/3ShbGsgQNe67EFAUcTFWQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af3d1728-3e00-45c0-9b49-08de68ed444d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 21:42:19.7104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISSsbYFDfbU0Ewb0Up6EbTrC0WZnQ3nwgYjc4W6ZPGH5to3XD1xQnnRxrSOIrgNlKFy/sF0ltuZlgnuGog6EMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_03,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDE3OSBTYWx0ZWRfX04+3A9uoCZJo
 tjeenExjih34XIUGzxOXHoXyLSuySyYrMCphFxegIR6rzJuzX7gLsEjkE+0IedJjbyeeoEGayrt
 Bz+rDI1LAao7bWVhDGCHV+L677U9gnqEeott23258mnwl+5EiqaEvuCIiWgEM74aI+hhGB1tky9
 9vThh+hqYowaQHAvNF7RqmVoT/n/H5AnvIbPombhCdt3n6JRzUB2GehzsC3lDbGaPeryhIRHg5W
 thzamKsdnehMXwh6paTy3So07tArL+TP53DIpnLkqctb4WpYn47ci5PBXv84rY47//LrZCYMWVr
 UdAf3m/NQNt3+I3tdJztaAnFL/CUEecEMYatfG+K4J1/V53j+u9y98k8Id7nL+WUnINWTf7DME7
 TLzn68nLI2tVGnT/pMczXDIBuzQ/s4PmmUYpCz9Alp36vFIEU/VnNHG9XAbRJVBuADlYY047ivZ
 SaHKfztvdJTFcHWSvgw==
X-Proofpoint-GUID: ba7Ca16FUzcyNG7LA9_l5vQfGad5SvUW
X-Authority-Analysis: v=2.4 cv=AqbjHe9P c=1 sm=1 tr=0 ts=698ba640 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=VabnemYjAAAA:8
 a=_RAKNqUDTzB8GgAF3ZYA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: ba7Ca16FUzcyNG7LA9_l5vQfGad5SvUW
X-Rspamd-Server: rspam11
X-Stat-Signature: xc8jp3pdk3b63yupq83ajnes71s1o51r
X-Rspam-User: 
X-Rspamd-Queue-Id: BB66220007
X-HE-Tag: 1770759761-381102
X-HE-Meta: U2FsdGVkX18UAS6BUj7CXiA70RfRk089iEsGD/uwv+I5ijiqruUsBpcF0Qvic3ONttbfgnO0wk2c/DJ6E0JIfrr/I08hXY7nOR10Ek8DscTPum2mkJQAuXn+6SLWl4IYSr5xzz6nQxtTIUub72MzuVUsCe+Gce4lU83CHf+WFpjyBRyAJsaPxWYZl+D/Sj8Y8oj8GYOILdriOtw/hCYGaOTLUZZqEu32CFpu0wBqNvvvD1HULbWbzdJg5fBzF2md60xMQQXASXeS6oAYfZ5Ri1few6m+1eEELgl7iaBMRYyYRo1zVEATeaPJ3kufOK4ItyVTw9u3R9joFNnYlpPEMulM/ypYc+lCIOZPOwdqCmNjuTa0InyTWLOB7lirNTN1TOxfGuQkGVGIljtZWz0WR3FqCz1B4/8yyuTROgeapdv95bj2+FpQ+6lzaBOmw4wCSxoKlhd6HPfqAVeWHBl7bSd9fAGyWBrig2H4ds30qFMTscUNz+If/XSgSjc7MNW9OI4tMSgtcwStcCaMRgpd8oqWS65u93BuB4lJxuGXULtr4fZ5WutCrY1vOS81VmIfsxU/U0tVeC/CfOhOX7pOk/jAVyjvczSiyAVdmN2eBmV9txyjMnzkr9Cxn9chrasloJaWhzmmJIZBjWALPzHnw4d/E1Tj6rRF9bH+uUaWWJnghJCczsEORXz0phDHQIc+DTaXjcgoebO5cIdvU7rSx/5LQn7YFjSZ0RFsZ01pELoshdTLpi0wO8OTk50/nUE0rOhnAxZj7WOvn+zdA/081CVKy5HEhiLEs8F7QJjrXAVDvW5kCremVfkWVcM8fEGZ6jIvIjegtmP0NY1UTMkYGzRWnmLWY2AVeN+IiuH4zxCjtg4Q7jvpO6w3+WccXbQ4i448Zh0bqZmFCBVL3w9KJKz97hXeZhFCveKn5SED1FJWVhtf3ZQ57jmUWVcXyjS2YtRe+//wW/imZwtNMrb
 TwWtpV5z
 e+maEU2R9zMKQqOfatabyDs/hxk4+VJ2PTUYcw34fm4r5Z6LrKkeLiOCumNYZ4CTY3XZgprvmFnPRKV9paKUTfz5iVCh7+5zak+C1YPMMjodTLymTaoY7ccZXUohVcPXfFBeglbjvmG5/w/MQ67koXrBwdua8TkCZZtG5h2AoQ2ERfHritH15FAZlxwHfhs565/BxidOXkUifRvBd3ytAc9DfVwKug1itNEvfuStlpm0K7BwWm6/H3987PX/k6I5aVQf++DFO7tQcBTwohwAEJjx0zTlPCrIueclUTJNE4tz/WDMUrg6mEZ3k/wQKG7aLjN0gCEt285HAamKXi4h1PhNOvfS34MjvZDrkIyHrzC4KfBloOivwYDzXdMWXYaf8yH7cfs0Q5vuDkIx7NdzCFxzadxgR46CuvOxqpp4hfHUypYT0QCuUSji34C7hjsdQXzahd0bMYTnCnFq5f0zR/BaOvWrHInEEMM4KUtt8HDXiWFtOhNHYknd7bsA0uNUauu9hrgtLzbAQ8du/BGHxeg3dpugL9pL2bAYbFF2pKIFXs1LhSBKyWoeRtN+4Zg9AKIt27jq3lK9ZYYsbA2pXF1sfRwQdNMOnZm1rZQT3f0fCSqRZP+KsRiKo5VTZzhjwNXNBQGFVqfIaWpkayU8lBOjQZKYQO7VWf0uqP2i8xpIoX6j+b3YdI7nFRdZ1tCeHW5vjILvn1rL7OFMeJidlSGQaGiwjyH959bnTTkL5ikF6LXMCJxhS01Jx6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On exiting mmap, the page table vma limit was set to 0 - ULONG_MAX.
These setting will trigger the WARN_ON_ONCE() because the vma end will
be larger than the page table end (which is set to TASK_SIZE, in this
case).

Adding an unmap_pgtable_init() to initialize the vma range to the user
address limits, as was being used before, will avoid the triggering of
the WARN_ON_ONCE() in free_pgtables().

Comments have been added to the unmap_pgtable_init() in regards to the
arm arch behaviour surrounding the vmas.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---

Andrew,

This is a pretty significant change on the last patch of the series.
Please let me know if you want me to resend the series for this.

The Reviewed-by tags should be dropped, at least.

Reported-by: Chris Mason <clm@meta.com> (via AI tools)
Fixes: [PATCH v3 11/11] mm: Use unmap_desc struct for freeing page
tables. 

 mm/memory.c |  8 +++-----
 mm/mmap.c   |  2 +-
 mm/vma.h    | 23 +++++++++++++++++++++++
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index abb41cb66ced9..befa3cbe5358a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -391,11 +391,9 @@ void free_pgtables(struct mmu_gather *tlb, struct unmap_desc *unmap)
 
 	/*
 	 * Note: USER_PGTABLES_CEILING may be passed as the value of pg_end and
-	 * may be 0.  The underflow here is fine and expected.
-	 * The vma_end is exclusive, which is fine until we use the mas_ instead
-	 * of the vma iterators.
-	 * For freeing the page tables to make sense, the vma_end must be larger
-	 * than the pg_end, so check that after the potential underflow.
+	 * may be 0.  Underflow is expected in this case.  Otherwise the
+	 * pagetable end is exclusive.  vma_end is exclusive.  The last vma
+	 * address should never be larger than the pagetable end.
 	 */
 	WARN_ON_ONCE(unmap->vma_end - 1 > unmap->pg_end - 1);
 
diff --git a/mm/mmap.c b/mm/mmap.c
index 8771b276d63db..a03b7681e13c2 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1309,7 +1309,7 @@ void exit_mmap(struct mm_struct *mm)
 	mmap_write_lock(mm);
 	unmap.mm_wr_locked = true;
 	mt_clear_in_rcu(&mm->mm_mt);
-	vma_iter_set(&vmi, unmap.tree_reset);
+	unmap_pgtable_init(&unmap, &vmi);
 	free_pgtables(&tlb, &unmap);
 	tlb_finish_mmu(&tlb);
 
diff --git a/mm/vma.h b/mm/vma.h
index 83db6beaa985d..d02154c3ceade 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -167,6 +167,10 @@ struct unmap_desc {
 	bool mm_wr_locked;            /* If the mmap write lock is held */
 };
 
+/*
+ * unmap_all_init() - Initialize unmap_desc to remove all vmas, point the
+ * pg_start and pg_end to a safe location.
+ */
 static inline void unmap_all_init(struct unmap_desc *unmap,
 		struct vma_iterator *vmi, struct vm_area_struct *vma)
 {
@@ -181,6 +185,25 @@ static inline void unmap_all_init(struct unmap_desc *unmap,
 	unmap->mm_wr_locked = false;
 }
 
+/*
+ * unmap_pgtable_init() - Initialize unmap_desc to remove all page tables within
+ * the user range.
+ *
+ * ARM can have mappings outside of vmas.
+ * See: e2cdef8c847b4 ("[PATCH] freepgt: free_pgtables from FIRST_USER_ADDRESS")
+ *
+ * ARM LPAE uses page table mappings beyond the USER_PGTABLES_CEILING
+ * See: CONFIG_ARM_LPAE in arch/arm/include/asm/pgtable.h
+ */
+static inline void unmap_pgtable_init(struct unmap_desc *unmap,
+				      struct vma_iterator *vmi)
+{
+	vma_iter_set(vmi, unmap->tree_reset);
+	unmap->vma_start = FIRST_USER_ADDRESS;
+	unmap->vma_end = USER_PGTABLES_CEILING;
+	unmap->tree_end = USER_PGTABLES_CEILING;
+}
+
 #define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
 	struct unmap_desc name = {                                             \
 		.mas = &(_vmi)->mas,                                           \
-- 
2.47.3


