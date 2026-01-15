Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75153D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2496B00EE; Thu, 15 Jan 2026 14:38:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C856B00EF; Thu, 15 Jan 2026 14:38:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C341B6B00F0; Thu, 15 Jan 2026 14:38:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACF676B00EE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:38:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CC7E1BBAC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:37 +0000 (UTC)
X-FDA: 84335210274.10.C94502E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 27060140002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:38:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p2JLYXLM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GhXWzxmS;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BmmjrDOeW3p9F4604H3TcadU9lU9gGW3+zPDqsZOM8=;
	b=IKq2CeGtWWgt4a985yH91684BUXjPyrIGMKLJg5qAXptCPCQesjezHIYMYhWUa01b32ym+
	ea9PEpv1wQj1xAIpw6482J9mTKRjm6CL0gt1mSnTIiAsscQmOT4Yk3iUMauQn0YiYug3Wh
	Diei4UgPRKNz7RVJ+UmNW38AI687SEk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p2JLYXLM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GhXWzxmS;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505914; a=rsa-sha256;
	cv=pass;
	b=OjJ91eDev4plz1EBQXN+/4p7AAy6iaA3b/znnuROLXtAdQRYP+cAYgjddwq7QN9SghmMhH
	SKoX4rb7DRSLsy1l+XVMFqcqCARZtsvURoNZqPoVS1Iw5b3L8uImCFUgZl//ESqlCmsTMO
	JLpEyvOVoHcniFn37Uq5yaMETf8gwZs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEAZUP1940271;
	Thu, 15 Jan 2026 19:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4BmmjrDOeW3p9F4604H3TcadU9lU9gGW3+zPDqsZOM8=; b=
	p2JLYXLMSLwHggZJ3s8BP7c3m+56RbujuDkt/RldB0jRl6RS8pN2t7b4Ah3xq5QU
	JUzqfbNovMduBYlQyTO2Ml4d+01jCyaCvTsWTpgtdIpw3UscgGYl6ZV3ffkfldnv
	xCnuxhSwITElxOE6AoV37ZzuDFxOFB3QI5n0pTvlHiVYtUj+wTZSJmvcKct96yE6
	TH5dV8k9u9v26yQmkoqYCtVil9SrytQ6k/uCRo3sJXXYiLM734hrBz1vV6kFaiVh
	o/uEK1r3r25SPaft8+9U097JsQJP4t4EMEawVYVzqYFCJSeaKwMfiemHwP7Fj5R8
	E0Jn9klUFQaaC1boet8yoA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3bwd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FIIIvR034710;
	Thu, 15 Jan 2026 19:38:26 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bqnv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:38:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9h8nJ7sx/X/FK/jnLeFY3jbwlLKCt/sIsJQ4LJaYBeq/Bx7llrkB1eofd84kQbqspNAdbBZndSF1XvEyQZ0CuKGKp87va/rXnMowI9wfIUstTtjZv/6jxtx9DeufYNaem/2za4bOwvUSNNEiJar90tL4+NOiq1xF8b9vAnftCvxX8jlU0CwiIvGcmP//kbH+LysUl3m0/vF5uSDoqOHp/v77QIs0NPL/lpjSTYy1iYwq1zKbE/6KXOH1s1/AtDfzHMSEcKs3ShtZHFqUfzsAV4cCwQRZOnduclqxGAHo5IzFv050L7nwnWS3h0FdTCIxl9njo1R0uye7a7zM9d80Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BmmjrDOeW3p9F4604H3TcadU9lU9gGW3+zPDqsZOM8=;
 b=uA2F94rxuVFIFQgfkx6ln68iqW2ZlDIjXMIskiNP9R9QZoUWuIz/RaA/Ecdj5vt9f0mUMx/y543r29ZWM3UJbU5zzfhVq6nyRIWgRC/XgEgwQe/HU0RM2owj4VT/IGgjhpROC5wR536X+xxy+OPWCvLdesc+0Wli0Iew9X71r3UtjfBaPHLL1AwkZFUZsbDEZjmTmSVuKrhWgvVGoDcvC3J2tk9TOmXK44PFlL77u4o05/+QnyarW+tTUEIMj1zZnVKMFYawUl0Vmp6DbBB5DdmidUml1GOCw0Q+m6DtofAfWwATca1MTF4Gw7BtLeaz9Sc0m74a5nNQ9dj26CJkEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BmmjrDOeW3p9F4604H3TcadU9lU9gGW3+zPDqsZOM8=;
 b=GhXWzxmSjOkKMpe/d+B5hk1zlSLGTZ6DIE2CUE47IR3pZ0jFJUpopGRwSYoasHLCyyLye0KrcDkVQ6S7rDQZy36nxpBaCBqz76Q1TDg+GmynzdDayl4waM8dT4jRKE0gm7fGL3EGNh6n1ZsGt+fdgdjwy1zriV+PIBsmrfPRQpI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7869.namprd10.prod.outlook.com (2603:10b6:408:1e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 19:37:50 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:50 +0000
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
Subject: [PATCH 23/28] maple_tree: Add cp_converged() helper
Date: Thu, 15 Jan 2026 14:36:42 -0500
Message-ID: <20260115193647.1695937-24-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0036.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::35) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7869:EE_
X-MS-Office365-Filtering-Correlation-Id: 475b3606-5ac8-489b-0a48-08de546d916d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YtK5F6XuvQfYIaYh8n8dc73xqKn2jMg7BtWfTuzzWw326VmRYkClNc7p8FJk?=
 =?us-ascii?Q?R2+E5TK5SZKElGClg1Pt9Y5F0mMb8dT8dKo+2IP2NWrD+pqUTjYY2U35OFuE?=
 =?us-ascii?Q?CLZJX/boj2L1wkd/C3GyvEQMyXytjCRswwDS49nWW2qLt210n2sIWCiIiLMo?=
 =?us-ascii?Q?XuJX/m87D1Pk8NxypfnZ9yPXo61QbUcE0Jln0zsqv8Zo6UZOxPtUcK8jHfre?=
 =?us-ascii?Q?94BV27ImjfvxA38zEDly8PCuIfypub5ETzJ9vL+WrWPDyosNxcrpPSV+fxlA?=
 =?us-ascii?Q?4xzlLlxIMdk54alyJC22q+S1YiaIS5qdOcs+8uhOT/TLDX8B+xuS2lFndUUI?=
 =?us-ascii?Q?e8AJ+NwOFxEGKQ1X8N5CqFCPAq/WaWv8Au55pkhXS1/uAGHNwasSlqk3k7I6?=
 =?us-ascii?Q?eWw1yb1ZMlkj+/2f4VTcyqzZtEAPHyFclAqt6iKoMmtVIA8kDV/kUJM9EwFJ?=
 =?us-ascii?Q?dPeDBtaYDyuYgkLcHbVv35OG3npY74Ghz/8eLlrI9u6XSD8ownBeAecFgP0u?=
 =?us-ascii?Q?wvtbVFC8p9BQJyJbKxGdJmXTdA8mYQFV8uU9eDDZXmGnjL146wwyjbKhSrTo?=
 =?us-ascii?Q?d7pp2NK4OwlKiIl9xtSh6YsGhOeZv3vlIJ0nZvPljrtWrbDB/xWIcUokofRU?=
 =?us-ascii?Q?N+1je/k98u452w3ag3a+hKb+eAyRty3FOCwZDw2Bkr6E0dlx6w+d6zL5ir5t?=
 =?us-ascii?Q?RN466DHqf8tI3K9jy+IqutnTpICBrqm64fQhgCAWF9lvtpwTroPKP69ZkpUL?=
 =?us-ascii?Q?KB/OTVE8RU+M/QM21CW6D05SKi9MLFHh3+pWMIkKEIk5WbzKWcUHLyvZKywN?=
 =?us-ascii?Q?9MF3FOuB4yXtsyo3BQe7nqWxQDDCoNcsvD6+pOi72zUBBGkCDo4p8Fg3isUH?=
 =?us-ascii?Q?rpxJOHX3FsLy+ymz1aDRCPq/Iw5xknxGRDXZTxGSrFFEWC/S5j20IGCCLFqT?=
 =?us-ascii?Q?A9OHm5KPyfEy//6JflQiM/2k4ciXuhMbrhs7Yh+gHSblP7nn2HWQEBK4tNBM?=
 =?us-ascii?Q?T87Hwdlk/YCNKjQT6pYyKVmAvAwn2/B0dCu9nNu8JU9TxAoMgnUpKaWJEoyb?=
 =?us-ascii?Q?dnBj8LoDVh4/wf1awIBgshT1oCM+cZJQMQkY0BSdlUyFhCDP2KeqfTSIjs5o?=
 =?us-ascii?Q?NnVnsPFVREs2apYjgenOsgypZJTxbvKkgWac7eSZjOdegVtMSgNFQmA7obWq?=
 =?us-ascii?Q?kxKW+zxwFvTbhN1Oz5djTxp4CnpX234rkLWrnawajcsFIKu6C+W1aIwvdlTu?=
 =?us-ascii?Q?gp4cN323xmtAWAxksWqgQUbaO9m1H1BQrgGTbNBPANDibXiIIPaG3LrYQ5uf?=
 =?us-ascii?Q?qbZzKcK8rMNRMt5sdBu3k7oXC+CUfiZT1t8WHDg/WsN8fr4RMjNYOp3gNqAI?=
 =?us-ascii?Q?+8noWHYfpFXs0CR8JVnPjhIn/VJZEa8K1lAEe/PDhrMGQj00w8mn3Rcq0S1D?=
 =?us-ascii?Q?5y0mVjjk5jqQ5ugAYFQoQ/YAAr8xxwfq8P0Ifqsokmu7+qMrjC7j3LnBky+A?=
 =?us-ascii?Q?2R5/lGvgnR7yQ4HXoBCU/kMyr9Ntnv6IF/3ge0lIjv5X/0VgkQQhbT9ZAu8g?=
 =?us-ascii?Q?LuheP+bUglAYC9HKm48=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GekoEjh2bFlj4yZywIbjHxylWcNWdsWMHYbj+qEj5GxYSwsltxcV3X+MUdrq?=
 =?us-ascii?Q?9aS6zDPOR21Os/kyFbjgNrVgsRhJlvfu+PY0a3kFkcq+gxeXZxm+bBqCqvA/?=
 =?us-ascii?Q?3j4odbfTIdWJNaRtZCgpOS9PVdOOirMv+0c8eDbXIO9kKFtUcgNqPtY/8gSO?=
 =?us-ascii?Q?U1Ibtm1Rov9jByHls0bGut88UVGqyc3+JNk0M2YxUoQAF3p624xuY58kt8bR?=
 =?us-ascii?Q?PweFROhXwqwNuSG5gvWVVEKZpAkgMXFkkH+iYsKDv4KMhK2ygsF+2sDoUUgp?=
 =?us-ascii?Q?phczj0uXzyLulGSmxghGvP/ClUL3Nfs1hWGD4SLk5fC6y180swDXbJ6yGLRI?=
 =?us-ascii?Q?W1p0b1l6wMHplVmReOcTEAJTXK5861tAA7BNpqULCZ6I0HQUVwKUh89LVKbG?=
 =?us-ascii?Q?ttaNesxqtF1YJeCTXePxnNWug+TTSWmUDOB/WTMhfvfmyGeNuQ5mYRIvuaHg?=
 =?us-ascii?Q?4Nj2zOIbbdEz9D5Uy9fYYTNZ855xLLlFiJEtO7J1f+O1f3LM2lHMlj4N2fjz?=
 =?us-ascii?Q?cemnQgZKz9iECF8kv7rGp6chibB5+K0/rKQXt2iI3517cR3E2wXj4+TA3H+g?=
 =?us-ascii?Q?+QnBQhscY5V7dfAsqCMdTFjU6xKxPFV8UaNSwstnhF7r2ij90a0PPpMhbG/n?=
 =?us-ascii?Q?7pEqJX/OGuTM82FeYEZJ1JEQJ2O1TcqbiyW8BjJuNYlnbdZaVgNZlIHubBZe?=
 =?us-ascii?Q?mJvw9l+IiP11p0sVCd6Ehr1Ft+8g0JKOtQVjV3cVNyJag+NtRaLKywFirIXr?=
 =?us-ascii?Q?mj8pKvi6AxSR4yBQKR78FLM9jmFc1WVIWn7M03YkWd6ASxP1sdCAqr71bajg?=
 =?us-ascii?Q?0LHOL4JpN/P+yq1rcJrlfjBXI2iI2sxOL3iJjn/aKE6rrziZv8x/Jt8hGZgI?=
 =?us-ascii?Q?ToP5BukNiUGTDi8sDZpo1EMCk8AE5in4bR3nKtc8UTN9KdvS3m/+qHCdFdNg?=
 =?us-ascii?Q?13Xbqk/aqjmq6MESETR9jR/SaMzuM8VqYrseyxAKskqfPTpupU79zS8SegER?=
 =?us-ascii?Q?X1utYSNNKhX2tzxspqG+QQvAY4H1fSKAMqNyN2Xhk5rkmkS41WMHxmMvgAu5?=
 =?us-ascii?Q?aPWqsBp8GT3qx1nze86R+hdhZOOJAmpirxG2+rdNhPbKyOQXXvVji3MMKXJ+?=
 =?us-ascii?Q?cDqsIW6EV9JhcqHdcG3ULeBVXlWnCAS+w3mwHcMi98B1zNJZ3sCeTEwHrFmI?=
 =?us-ascii?Q?ZZC41fX1ksUz7Un77v+nnDVaerkLJWz5jAJLaCzaX+rYFEwaeWDFJtz57rUr?=
 =?us-ascii?Q?sXVxLJjs6SP9trZpeftXsLMh0U5sUkjECaq3C8pCChecjSd5JGbMcWRuC8vJ?=
 =?us-ascii?Q?g62wNatjWQJLg1O01LgooF2/zp1dnEzRqnI0Rcg9Ap17wo1hjGCqNfkeAENo?=
 =?us-ascii?Q?AcV3zQi7dEJaujPHxCmN+0xHREEHeNW25lM/E5hAcZAcIodlle60RCHt45eU?=
 =?us-ascii?Q?1VCU1JGXXn9Kaw/2jkyIYpxYkS3Rcinm9o7JQggKWcjD7KmBKo4BRQ9kbTXR?=
 =?us-ascii?Q?buqFLht3kYKWCHLepD9P7AdNDbsmcPzlJQRaH3Fk7R8mnlixf/pum/qD/ukb?=
 =?us-ascii?Q?kW9bZqraa3dNI0Q158XDV4eal2Kkc2WYoXpIAFAOkZtK/CpYKOg8mtVK3eDC?=
 =?us-ascii?Q?/LWKzl8Zz6cFWCVgF2eVrBTEJcUcpUp7JvM3pgyluRPpFTh5X24GoSMTrBhg?=
 =?us-ascii?Q?MxFvtIzyN0qVL01L33TcMf0dutaLYPOwK4Fk6mhDapP1Np6XZ6wMLAJ06ca7?=
 =?us-ascii?Q?272chUxM7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WWF+WA+XdJQxj+4baxmV6FSwLCJi+MFpxgCuA1aPHBsYkfQ5mId3TbnMHfkHTijIMIVObDMPkFbY07eYi9sC/qDe7dbcfxodkNd93dkaF9m4jWz7RSEOtp8XYCuEg7rbBEdz8r8V4kY9kkr7stdyJSJa6P4u/nRwLzYFIHP4qhkD+xEznf8/fuM1PNRMSFUIP8gRSbxn4XI1I0paNLs3MnU+prRxxra2BIdDj7TNHWSsaKX33n7ENyC0wm9zPysGiFLska5KnSatott22nv4B8PwuBJNAn+A42WBRdniNNbP0gffNs3JaBcYBp57eKNR4DtgOfSNDfr/Oh5osoY419dH4G4jd49jEFmmqViS6Vq7Nr7VB5TkEs/oO7wwHlNYTgnj4sV+26b9VOuV7Y4PxOr5V8jMtPb84RgPHCc93axHgO42JDMp36Ql54W7javdMKzwoH9/88V+9eOYbfPZLUjov3h6oOa2b6McZGryVYhXqB/MCGHvzqp/vXZRN5gK/T7U2yRRJblzxJPI5uxzKACmoVH48HnD1vnltks32HJoyEHSW+hSfzAC7LsJNpR8cX9AQqFhUlLE6Ho/4TO7YSdxtmLLL0NEsv9hmKUnwgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475b3606-5ac8-489b-0a48-08de546d916d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:50.2128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAmWs0bDqhVDk+oDb8Xs72wZf5HjN/NNYV74iC0mdIR2ClVrTuGvdhBOY1H6yzoBRQkUtaJW72sqkZzShQWH3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150153
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69694233 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=MoTMpwtd16bSVnSR3GwA:9
X-Proofpoint-ORIG-GUID: r97qGuFoyKDNQRQ54vEBgoIaz4QJEU3p
X-Proofpoint-GUID: r97qGuFoyKDNQRQ54vEBgoIaz4QJEU3p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfXxX06mpMo/wGZ
 dSzvpfR3C7VKknZmX6Ax3QiSIhSlrc4KHDWWF1yxtZ106gP5HGo5o8tW7Vgze7cu2HBRmFPxEoE
 6Oqi95lID6Kk36uB+XYmrF2aowGOs0noBKMQ3sFiIbOi78luQKxn2e1QefxSp307TL6HqJHNKrY
 RWvj3GUd8eX/LxVjnBXbXYa/re9khgE6as7yw098wSlPRXEuYRATn8ZZ79AjWTME28z6tC8F556
 l9kV9x10Xn27Kn8puNrhLLaPvVvFLc6c7Tz/J5TY88T/2gUDVXQRgmk4eKR1CwgvEjjwSuM79s1
 yx86bPD1dmc6nFxmsJHs8chpiOjoyfZ4bzEbr6EuQ7o+Okfza8A1k46CZMf8PoBuyyHd3ZACIpR
 obVL8WNz3YUIpIKV/TcyuuwCoyIpbrYLX/k2wKe4DTkyAH77XnARWpHAgjbtiW8hcvHX6y7+alw
 KeAz6V7txtDlRN9C9ew==
X-Rspamd-Queue-Id: 27060140002
X-Stat-Signature: 64pyegurbeb4cwo8nuaymir3m4ro1jcq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768505913-345925
X-HE-Meta: U2FsdGVkX1+vu03MDHeo2HFzwpG2/8evVgrs2b+id1JPQiQDR8e09av2DRKmiAx5VwvxFfxMAvfubFnybcQAR+RNu9VbF821thAqpA9hHA+42ZAyBkFaOUHYyFjyMEpjPVhTlbPYObXZXxGYu0SKkdk0VnuktV3Vq5hw3eTrIFek5P4td3W1bBE4doXABGZgG+4G+2nPKVgpNAaUjTUPZSaNIXXA0A9Y3fRaVLaDJ5iTxZa6inbUDQ77K8QXPxi2TZkLuh+8AB+q08YnDngS7uSXptwJB7GXjRcLmR9mEaVOjrp7Io5Lc+IzSF1wt9eCQsSUwdznfufVdXUAfeRGE1dB4PkFX+pBVaQe0MfElc+wsxkBe7fpAnSnpjLSBHjM6G7n3Dsu+SIbOTYb9KlnDoAP7oFkTujXH5Zm0yuGbderkVJTV3eN/NZyG7phSKoDogWDBWzKI6H+sIF9Qzqy9g7QUY5LnZdUwWAaq0qnN7NIX6YWOypv5TVSkQTqFeVNmlTvckldjMffshtPfftBJkGVAmR6e1neB4pLBKldP4bpLuNazTdeRL8TMePHBcR23APkCm94vxn8yN19+jWjGr1Ea199uQRFfm78OWKjnIYvviMjlKp7G03L6tweF+0CAutfdE1Y8Tj9KHswqDbOhkR5Jc1WkbqH+qowu9YHF7ckcVXQBTh5//Yiu/lWhLVn+jXPKgiXZ9YBxmfdueaOVWlC/HMthZqLfc0rpEFX06t/iek2e4kTFNXysoksE3IE6F97MD0nJSMRLIYg7q/uP1fzW4wwi9lta2KiapOl0H/tM3ZPArQsZuD1uKKIF5R9UczlTCC1Wk1yM7cebiGUEqBN0hLj2F/Kv9nrnHpoWfd6k8r9HEsjcF6QaMu90zXDAhWOSsABXOFE3do199svGSx0tFViJHBpxJMovGilMMgj81zY0teycylK+DASwfal7XwdixObOf3jUwto+0A
 yb1/LAf/
 Q1z/ZIlGZSkhYcOCAaGJbfh0UeAKR9pO41htmBrmDtZ+TmRjyYZMKSNfmeu7FGJ3UlqlinUcpJJkiOYCgG2Al+3MxhDERjPfVY0DtELA3K8RhMkamzw7RuObKt89JbuPoi08u3z3rafAF4UcWmqTtvtFObi1Jz23+nJPO1yfwAoVe5ATEHyRPxKp3dGZrL+wYCMQ7PDwY4sukMQCdjtpOdHOfKt4yYmBoblYOCWRzuPnWfyCrObGuiSLamerIGSwOToPVYryeQI/TuiroctsUYQrcZaCTDF3bBIjAHYig1bxNtQZ50ssfFfVqs+F4hJymkn8Y/dKM/xUO5nhl2owXRsxqsfImb6g44Nc6f1X/GwaCFWiKiF7dKWVnp2VStvVwHajqaEaOWH7IFhwYTfQ2d0DvocGg6B3tEZexeHmoXAw9zaWFTBk4660kna/9wjtwGQ3n+WFCOxJUa/MKa8tZiWojfrTN13rs23bzC5fSA0YLviFr/A29eVizVYaUOaqapL+iasWeFt+a0gjDxGHHZ+/58aPAPRsIqcccz1ZzW9JVY66lkWDgZCwJtbJBLwLcYUbcHDBXaf2GkApWMYzDMY9sqSQcj5KmpMpLtG77L75aB1UHbPGB3TMswxM0s9v2X510mqg4ldN2mBaiTwGP9xJvr3NVV6+Ww80eLwqZzZrge+hNWC9vi4Df4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the maple copy node converges into a single entry, then certain
operations can stop ascending the tree.

This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a6f4a1c8549b5..46daa1ef32084 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3462,6 +3462,16 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 	return true;
 }
 
+static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
+				struct ma_state *sib)
+{
+	if (cp->d_count != 1 || sib->end)
+		return false;
+
+	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3544,10 +3554,8 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp->d_count == 1 && !sib->end) {
-		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	if (cp_converged(cp, mas, sib))
 		return false;
-	}
 
 	cp->height++;
 	copy_tree_location(parent, mas);
-- 
2.47.3


