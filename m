Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A072AD3EE62
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001796B01AE; Thu, 22 Jan 2026 08:03:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24676B01B3; Thu, 22 Jan 2026 08:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9B1B6B01F0; Thu, 22 Jan 2026 08:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C63F46B01AE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:03:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93F591AECDD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:03:12 +0000 (UTC)
X-FDA: 84359615424.17.0BD3D25
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 15B5640011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:03:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H5hWQd4x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s9hllpK8;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
	b=A14XIYGwV1YNTFtFyZyLs4r3QJVmQH0E47C74HOQucWAk/gRKj9976L1zviHMqtZg0K++9
	LzUncyQXoIGq5L111ovDX7FpI4yQChv65XTHqs4Ow89s0+fkHXPpJYP8hAES+3qhlrnYoI
	zhToFK5TGAnbjTMTW5gEZo8POETALTI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H5hWQd4x;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s9hllpK8;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086989; a=rsa-sha256;
	cv=pass;
	b=s2mzGF1zQMkQS8XZTsUR1NyiIK+r/d7/Ov42Fka1Hfx4pm8XScIWYikXOCIBGHPR8aw3WQ
	/IccFr+lvq68r/mDvh7GTwjEPIxeRixvpQeAYwQz+chTUOlmNnBMuQH0weNdi5hGl/w4QK
	Z3ZFi7zIawI1pfw8NyvEKKZJ/I3dRyQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MBFZUb3523773;
	Thu, 22 Jan 2026 13:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=; b=
	H5hWQd4xvEsC1TQSLGCiwmU6X0LwhKt4Qsy3LxvPn9vO+WEwBg6/yTQpXn6qkxqg
	JU/w/i8dBJxavblU5Se4RVG3ZcKshcR1Nm3gv6MFeG1quL5/CoJZdlxRmY+ri+Wt
	XH++EfVcZDjIUYzv9GcXExwcE7398Kht1/7hEVu2GpT6b9hBWNqGyQ0CQ2zQMCXr
	55XA95qYBry9RxiVgPVJgdGJjaJJJI1uNy/A/v4ZwQM8xaDxKYBDrpoVe6ouLp8C
	d0GgfbFCuVGi8I7PazIEeyicxXzSDyEIIkwwu8+wZJjnu5qafvy8FueOo6+j3dy2
	wGzL3utdIHOATINngKI7BQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qfuch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCejMG022456;
	Thu, 22 Jan 2026 13:02:19 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011061.outbound.protection.outlook.com [40.107.208.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgjp38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8olyow8ncL6LpYkeE6O4vMxwL6D4KwSC9pid1IGstYOQiNPhA1a7plcjTlP2Wv2lzrZhHlotJNdZ0NrbYwVI8TmxVA6KP/0cxp7NpyPjsqANBxLMOcmjT00no7dt3ODWdlkEccpAFffYOhDkRVJQg0ckv5kyQ3vdabqpSlJ/sWm7c4jEYD6jlmviompevAui//d6FT5TN4rBRXXp01gqx+oGW33J3woDRB1Sj+9ka0T915P3no139HSfbZWJBtXmrJ36D+XHwpEMgfoz2uVFzuTbTOwzIxOfwGhU3juPhjhPgjxXVq9LZV8T4By0wdLdU0PJ0lu1oURv/EmNtaDqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
 b=iL7N/0yoSxymqJXhLsmJsNNMczP8G91l4LCbaZWQbp7pVbappu5aZYg4NW+Tf7fgOFPk3XwYLjnDv1pMxNqStvpz+qIZObNLOmutod3PuH+nqfGAjFnhF1RT/MNtW81wXmm9jGY9VE8JB/IUQm20w9j4h+G5gbXfEESqApc8Nwa3LRPa9lOZJeErp7pPnzqjht7ura7aHDhrba2WJX9Fbkqfpt64e7HwrA2MV7OhHkTaHSKau4/ggPn7Qkpq8ZvcD3i5fVIvLkSKHRvjWPA6Ka+jS2R7HF/5FTWHyQQcuTzRZdsnmvehnKVsK3nE95Fu8QwZ944UoZ9PJf88Z4In9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXqUcP/kbNPK9GH0qkhSuzF9fSNu5zWTlel92eo+7XI=;
 b=s9hllpK8IU+ynALkSUA+kFfnJpnCssxzi54YKQ4NAsRU1IGvsFnk6sNjbvzPoi4y4DxmojMmhjrkK+yZNFa/HbHDh6GTpI3iMdiaxClSoayHBEhbDlCqr9lquCUVYUnxBtijOYkb85RC+IVzAIrpVY9LTx4a45yBBqdMBSBu27c=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:16 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread through exclusive lock fns
Date: Thu, 22 Jan 2026 13:01:59 +0000
Message-ID: <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0052.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::21) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c3f46f-1f6e-4b57-7114-08de59b677a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O8Ws21Ct9QtMK9qnWDp9DGvbZkPKNNgKevHOBh7lZ66CwAeAa9XRSdPhe+IE?=
 =?us-ascii?Q?f4W9ZVnjpgzEkhpa+3igRJe0nlUnQIVGzuTmzSgZpHJ3LdCJY6wFABLyhDmM?=
 =?us-ascii?Q?OgdFTkNervHglOI4kq6MhzoDWsmixLLw7zkwqFLM3TUCrsWp1P9s/sh8YqP0?=
 =?us-ascii?Q?DB7+ckuqCj9F/pJKSLqJrzQeoNAxi3vhlGU3sT9NhbWy4G84tcls2+sB0EFL?=
 =?us-ascii?Q?Ru7KE/Dj8rqXhtbJwNCKIqBYplvgkKA3DCLvYhJfpJxCQaf9A4YO/xL6dUKa?=
 =?us-ascii?Q?PCWjqUiX29QPqeywX7zf5/hrOxREZBcDs9oclmi6YzNWVZwSmgn3v0Oq3F5i?=
 =?us-ascii?Q?3Hc5YLC0893oR6NWEmYm8XPyz8gHdPwr21zF2XVBqBDUy1AWM2Lkkh0cvAk4?=
 =?us-ascii?Q?Hc84z/d2XfkD7QjSQQRPU8YtWaGMSVkhVGPtN5iV3WATYq5bmsI5ZRC+Vpuu?=
 =?us-ascii?Q?dOWEcApBQrLb5Qrjkc3mqf64Gm9WpwpkxRB837WXqFrgQ7d4lSSTI/GYi6wA?=
 =?us-ascii?Q?4WZeh6iWlTGa6IOxtQFOay9crdhB9TG1+P2A+Ou8kdfda0rlqWzeDU7DlJIE?=
 =?us-ascii?Q?zmZTwNmOlL0PI6SYr6G2CcONq9Hn/pC5t+6IlRhVLS55r66HEfF+5emPNOC0?=
 =?us-ascii?Q?YxhA+5JoExskwpK2+KOh8HogIJGR4GSNJBj4LsKNTb8uE8EdrpubtcvYLfr1?=
 =?us-ascii?Q?fQih4LUWJpsMxaBMMD0ZmNM3FNy6EIj8hIQFGkUsbpJUJjhdxq/NePbmu6/R?=
 =?us-ascii?Q?6Zgy/Gy9hJ/GE9IcJ/MqRpaHO1qWMpzsjebKD++98jf88PGxD0YQ3FByBIRJ?=
 =?us-ascii?Q?fgv19MxfkjpjJb+l60gEnD9gYrKShRahr5gkJmHzBUl9oTJzKbb+XXTEet9X?=
 =?us-ascii?Q?eIEMxZtrkqGI/zox+WVU+5JoW1pRj2m9XArwNCvONWpTodeGwBYBdKse/atl?=
 =?us-ascii?Q?5mFVdyM6iEjvLT4gO/sQ58425SZo2tK6lJCy9a1sJ22ozRsMDwGMsKiyH7eL?=
 =?us-ascii?Q?h6+Lq3RRsqmLseFp2UQ5K/OFhBlaImhR5mVJgiZq9Zd0R4Bdu5GdxKOwc1vg?=
 =?us-ascii?Q?qu1MWTOu+1lqUu3XGqzbEahH2kuTfgE/dtNxHY31QA4cWV+9ufZOhEqZp31N?=
 =?us-ascii?Q?XUuVS9uFTYSStwkn0ZqAGTkY2iP+u55wQ8R/WFb4fSFita0rbyb2XVc2mop4?=
 =?us-ascii?Q?X6TbuRw3euzbGAcz0rPZjUO11pv8VaEVX6nMOWiHSchzmJcdek0cD1f6t6CK?=
 =?us-ascii?Q?jN6QrFFICMOezT5kPcd6DktFJ3BZm0i01/6aSwnBPHJ9D+avIvnphsy4zn0B?=
 =?us-ascii?Q?2RThX2KEIquz9QPiX/GdcCC6Et+EfYPgWqKc9AP4TW1fJfKBchUKPrwoBy0G?=
 =?us-ascii?Q?MJg2n96J14IJRJ0ciYoFTneAlTEoOfA/jQj7UyIPOHH9F88ygxRmIcf3D80/?=
 =?us-ascii?Q?oWOxti6p2i1BN/lbK7x5IrdXDNvIlCojyxZs6vkUl7bz/ZQIO5cQEnnC4Ldt?=
 =?us-ascii?Q?vrjS1vSfEOv24pRf+VqsY9guyYgOzBoY6ILvnazj1k8DOtHZQfb5R2fm1j1t?=
 =?us-ascii?Q?72g0GUROaX9IndMz0wE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lzevujG/WCnW0i+DlS7XCDgAkhJWVLtcez7UyD2m+fW8SAiuQaRRdW0z2+92?=
 =?us-ascii?Q?zpPoVF3Sdk69ZRLs7hzooqj0ZeCU1LGMNq63TIOl8I8TkQ89by4VpiViVK8W?=
 =?us-ascii?Q?EvF5p0ae8mkCMdq1ba8mKasKGV6Ckf8t9dB4MBFjwlxreoBhsTlyCnRqb1qd?=
 =?us-ascii?Q?YvWXVxIFjLcAGHf9tGpUFpgDByyL9ukoRh1H87PbbvCSfFdPjIQXZ6kUt/So?=
 =?us-ascii?Q?pP//tMVtmNTQ2F19TGsBtX1c1KRKCbonnRI0XnLSsBLta9gCLkXCTJSwcKGz?=
 =?us-ascii?Q?2AdVp5N6+Xf9Nv7A+iUpivBvH1MdKR/0zxMl59AzlaGYTb6aRgUtGWElxteJ?=
 =?us-ascii?Q?YS7DkvVoGGdLUZC5dP37rpdyHoTdKDg7SCRKD7GQpPb4K4UtJ41/iqZaeoXo?=
 =?us-ascii?Q?vLBdnY5lm1NxWkNBdNEh/SwlufGKWUYvoUksapm6i4ObDcFe9olAT/gPFmF/?=
 =?us-ascii?Q?toDf/SgFpr7rENjxtKtbpGMgY0TP0Lj00DMmw1qW4/ZY2njBxZW1xyccAjZl?=
 =?us-ascii?Q?wXm4xfd378Fqkg3s6oFMX/jLe+vAXfjlaOSXyDL9qyxXKLm5XXvS+E4vbUF+?=
 =?us-ascii?Q?TH1fVFSjGm+8ivyWCmz6ZGJdnX5S7QhgL0n/PvJGFn7zdh4mD89juDC50oAH?=
 =?us-ascii?Q?eAhkdcF8WrTITkGin9wSVbuuCWi+HRb6hopgx0TqoTGyn8ALensI8jihIEsL?=
 =?us-ascii?Q?dn5iUYHqAZqxJ6ieiioeN/xBoW2n6D00Go4LrRXqe7c5pPJ6GAYn49KBMyNP?=
 =?us-ascii?Q?wxJsrBJby2j8VMQk54tiQPW15TAgwYd4QOGoJtBdJ2mS26DPA8PyjzxtEgtf?=
 =?us-ascii?Q?cN6msTOnCMC/vmMY3PeR862h12aJZRZ7d1lN5R+DjhsEuBaNf7cHG8Hun7/w?=
 =?us-ascii?Q?NieNLpYcWiG2OXgEo3CltQmY9hSaS23eOlEdgLFXb93xtjputyZWj15A7+BD?=
 =?us-ascii?Q?JZ7KZRVGX5Kx608/6Yl6NWu5F+JZvXY/csRifXZwBdCc8AM/r4LSkasaIrvm?=
 =?us-ascii?Q?Pdr+aOIyIYYe4xLkK25yIFgMxYqzC2nJ9z7RiWNtZy/jJ3C6KXs4nx7S2ACS?=
 =?us-ascii?Q?RtedfcWfmq/DYb2SR3E48rFn3u7z9bcAh2K6uGV+fAKtpDjdvbMsXDDzKU/U?=
 =?us-ascii?Q?jOKbKSxz2QJ6j5fCmaxRadQDSdLRWRi2OyQHsnktkyYmPNW0z6vjF7qYqJMY?=
 =?us-ascii?Q?X0qDlMsJod+WlDUm8eX/reRGO6QiPToetmOBlko1roUIrcBUcniK0cGH91nQ?=
 =?us-ascii?Q?l5+zQwM0Pbef7k69ICT/ggrtPI21Yp3I6r51I5Kd2ZTatk01JmntktklrJ4P?=
 =?us-ascii?Q?UXTF90ZYrThi+mIp2gbcwQ03Q8+F0b3KRyk/eN5cQoDcpVnnqf7T29piV/qK?=
 =?us-ascii?Q?KQ+iT8esJSHuusG7kJsOBf54r6sbFAnvMxgviGHwZn3MZkDQCpsNizFO7y+P?=
 =?us-ascii?Q?N9+oJENItX0Dd0Ihs7ELfivHjfFPhOXGGcXPwOvFKrKyFGVFCDfuY9WAMuh0?=
 =?us-ascii?Q?KWALRuS/lIN+H7JcU5zzsopCoIL02rDH+rAiqYJTL2K/DRJDNtCy/RlYOIFN?=
 =?us-ascii?Q?qT/JQbver662yrQb0QvX9jh5UbEtbjyA/9WFK6pE6xrwFL6MWXs73DDjXccK?=
 =?us-ascii?Q?lm0pQkLkqAA7P9jqbzX+DME9oyTkL6CSZZ5M2Mn9hx7n6mTRDTWGE3/m2Wjd?=
 =?us-ascii?Q?830r3hFpb1FqP7pUZWU2OgexbnQhwGgLuBUU61VjsGPrgRK90WJ5b7W0mNhN?=
 =?us-ascii?Q?pWa1t+vIgah8E5ZBZFujxZpb+9aSkY0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W0NTm50JYlWHjxwlNDM04Z8WIcgFitV9Hy08iCAJks54emGvjjLybxornoVpXipYuG8IuqG/LbiyAQ7xcsv5uI6QJDwGCLpbhP+fjQ6efJOXNRwial6nrfW6c2BOPaXfD+FW0zFUiMLmf1Dw4XAnUBj5wK0upX2W4eCmnvWz5Ti1Lx2cah01CErCl+2b2gZ5XgXX5aXWbb8FrOh94ZRz6owy4ArxHjOccYqt0Ox61YTDNppsCrbWxTbcLg1MVXDrpEh+wWv2s9DyFT3Oar0Cqu37YWwiaMSFFw78Y5k9g/1K25nA8YlxXbHf2PdW1735p0EsQNH3nNUVYGAW2gi66Y235blRLSaxROnrzbm93PP5qkH2hQnucqs5ScWJDt/zhGwrnHU+G3iy9qaKkS+G78IndcPgZOwcFt34bMX/7TDs3NmwFtsDQUg9ku/tGh53KV7fOZV7mB3QzLP/djCJJCXZGrMDOkFokbdan6axBLCeDguHGw64DZMmfRp3e0cI6vHHMC7ALejYE2dpM4vcOcPNiH5hddaHnOMUxyTPvjN0P9XiWltqRDDwgoPLk1vcKxgxpuS1fiODzCi1wPFhnWNkxsow8jXr4VS3MJ/0fCA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c3f46f-1f6e-4b57-7114-08de59b677a3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:16.0843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q000CpUAyhf+axba8jPDV7vOo7U3J74ADfTXiAkGmEW/2w+0KohoKeJQ4wikA4ldXP9dH5uEJp5uR6NkTAyEryzbVcSLSyv01KTa41GEOqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Proofpoint-GUID: LLHof2Z8N_bY9tOPGYeaU1vdloMTBUaU
X-Proofpoint-ORIG-GUID: LLHof2Z8N_bY9tOPGYeaU1vdloMTBUaU
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69722003 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=YKwRDwjWlvvmDIdOP-wA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXyAXvN8C4+GAs
 AwXht9LEDlFi/JzpXiTixf/JPpmV94UjmnOjjeMsoMHgIueiznV8g+xzeP/REuFEawoRyj2JCBi
 4o2MxV4n+pMyncLwflzKbLSIioxIXbvmzIEFcSPvET35ivlPf93+rvIvNpzXDL3EkF2MTC6I9w0
 vr9SCo7J2uBQi8rfe7AuVk+cuJFMQ88Hm5cgHUzvv3QDbRDo9Nt6z3mfsrTKt0/OqLbeU0teQCs
 WL1QOSQ1ndh6b+SpJqt+X1jRANUTpaOizhEBM6QM2RwWY3J+cL20ja+2YZkGPb6UnMhioNcnrF1
 TKxt7Ku95kVP7/qjQwORfpiCgPcFeMqq4ZScRDGZ6TB225I1VluTYngUKi8QOgS9Ln8HBvtOmBh
 XpDItBvLWvJuiloVIyIYUtIBCqx1X4sIjfUbPzoCrJljqwbfKoCeJXw2vjUQXkN0J/3uG9aL5FE
 vn+iNzhCecKOimqrSsSe5mihtU6XeliKGf/mBjpQ=
X-Rspamd-Server: rspam12
X-Stat-Signature: 5nm9qzxi4ou7qg9kpu49r91csfj4u175
X-Rspamd-Queue-Id: 15B5640011
X-Rspam-User: 
X-HE-Tag: 1769086988-457274
X-HE-Meta: U2FsdGVkX1+nhZrXgtconKz2p5JNAdieq6ze5c4TJx2zGejmwae9bw1ZnsiM9U5lPXZnl9fPqnv6IqwAb9jT0kVBL5SxNXSsQKiqkdzHYJQtL1FwVVMqS0TRvIZGs36XjtDvcSVGSMxzxgMtqEw+3sUj7KkgLpcVPOmH4Djyu+hASEeDPzFkSy4t+CTQWGTFc/v2UzUC0qESwzp4TnTgIqM/3uSQ5cTuX/EQs9bvdkT5GzN8kFe9eGJCRNNTxpv1OgVx89ELUkrEMiZmkE/Wg0L6NY1P4QTv6wx1OEAAFyAPjn7DnUkGgZQG69z+TBIkHp3reif4gp5jNMXgJxxNSHLOY0FOMaFEDrBl0xCyd35oGcp0wDV6uD6Dgop7cejIToCaTWCK6aKLzB+IVJ57IwO81Sk7etdsW7WslpkwVS/JrlZrvEu8tyjd0pc/ngWQw0FqGxsDSEWIU+IZy5QiiomqF2y3MARNJdyKdCi8iyIS8bEoHUeHW1j5nvPzv3b26925RhSMHJZrMT0SmRVBdDw9iZ+5V+ka36AyVbGqA4RdqNTFvtXtYoUDsZiMOh3jLrv2IMzg6hTYxJfr6mo4y3sBo3QZVxrQMaug4NUcSOrHQrRn1JAa38NKy/w8MQLvUAbmqfzOZLocXcXdT30yorIoQ7o9NaTRZXmkD6MruUATDfw/qfD6XOFi7EXCrOekQsfspkXPnu0om4uQwlOpgEUpohricpw6kxEP10/QX3jBU4SH04x6KowwEJTMrERK/0tDRpZZTByI9Q+jRIpwGx1ndZWpgJaBnd72rqSwk2dMnTq3bLVpB2qxttJM8bc8b4TcsoV/mgq9cCbkUdghkVoNdu6NUKSS2m9gOmd2n2/zXKX7ArIqp3u6nVSu4BTsGY/vE34RvWHS6dBWilL6h7mhYTzyOFdqMorBtgb9EwT/aJNzTMP3KDNRVqTiEfNvIpS9ErFlPHXR6/WVD2d
 UcVhelR+
 OyarbYRaE1mKw12tiPMb5T7eUqZ2afezDahdjl06vatuUVAuSnDPcBO5tBs2BJKTfPdNUzo4RPcJq1M0rJFChe0MmLM6x/XMyuaUBZfeEhKl+FY7A7K0eErTOyW01cE/xJ7JxNgNoprbH2XpKhf8uXiQvqKbuO300QrpdKyf55CH77TVrrl1Dra1iPPcp6NzPhf3wbuCPaMw7UXxKYLCYbYxry65v/UF7fDg7izoR8jGHWiPTJMaGCIVdX9st6/eM4eQz7bZS+0f36EUpjFOiM7IWg5NUM2hz992c66oGjSy0uy55S/Nh22Lczxl782pgSNIFsofWluj2MerNkghsbYwfYsWp2welZastMuOEZOade//aQFhJc9RAzOjtczhag5lB8blwlu4MfJIe3uMozsjtEI91nNcHGEyHlEE6uCJMwUtMc3GB0UBO5v0RV+4r2cuScMwcxvL4vLEyYrGEEvVwRXq9HdL7CQ/TSUky5mhyqQaG2oyjBCWpTIqjIvn5C5Rh0rEmLZlW2jt4FYdBNHPFBXchpeXSag1A/yTL2lnUOhdBwY0iKHYeVF18rb/CMYsVBl8oyvlbfOjWqmtO4pgrfeg/PftRZuydu3MYjJtvypcETcVHcV+FgzRD/nLa/a6OgFL5+IT6jxKiC3VqPBcaTv6GUaHSW4+wrszwrN+CSG0wrS1ufD5bU9KcFoSB0jO1sFHXmCPMnivyqpsFI01NZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
error (but only when waiting for readers in TASK_KILLABLE state), and
having the return value be stored in a stack variable called 'locked' is
further confusion.

More generally, we are doing a lock of rather finnicky things during the
acquisition of a state in which readers are excluded and moving out of this
state, including tracking whether we are detached or not or whether an
error occurred.

We are implementing logic in __vma_enter_exclusive_locked() that
effectively acts as if 'if one caller calls us do X, if another then do Y',
which is very confusing from a control flow perspective.

Introducing the shared helper object state helps us avoid this, as we can
now handle the 'an error arose but we're detached' condition correctly in
both callers - a warning if not detaching, and treating the situation as if
no error arose in the case of a VMA detaching.

This also acts to help document what's going on and allows us to add some
more logical debug asserts.

Also update vma_mark_detached() to add a guard clause for the likely
'already detached' state (given we hold the mmap write lock), and add a
comment about ephemeral VMA read lock reference count increments to clarify
why we are entering/exiting an exclusive locked state here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
 1 file changed, 91 insertions(+), 53 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index f73221174a8b..75166a43ffa4 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK

+/* State shared across __vma_[enter, exit]_exclusive_locked(). */
+struct vma_exclude_readers_state {
+	/* Input parameters. */
+	struct vm_area_struct *vma;
+	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
+	bool detaching;
+
+	bool detached;
+	bool exclusive; /* Are we exclusively locked? */
+};
+
 /*
  * Now that all readers have been evicted, mark the VMA as being out of the
  * 'exclude readers' state.
  *
  * Returns true if the VMA is now detached, otherwise false.
  */
-static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
+static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state *ves)
 {
-	bool detached;
+	struct vm_area_struct *vma = ves->vma;
+
+	VM_WARN_ON_ONCE(ves->detached);
+	VM_WARN_ON_ONCE(!ves->exclusive);

-	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					 &vma->vm_refcnt);
+	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					      &vma->vm_refcnt);
 	__vma_lockdep_release_exclusive(vma);
-	return detached;
+}
+
+static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
+{
+	const unsigned int tgt = ves->detaching ? 0 : 1;
+
+	return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
 }

 /*
@@ -69,30 +89,31 @@ static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
  * Note that this function pairs with vma_refcount_put() which will wake up this
  * thread when it detects that the last reader has released its lock.
  *
- * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
- * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
- * is permitted to kill it.
+ * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
+ * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
+ * signal is permitted to kill it.
  *
- * The function will return 0 immediately if the VMA is detached, and 1 once the
- * VMA has evicted all readers, leaving the VMA exclusively locked.
+ * The function sets the ves->locked parameter to true if an exclusive lock was
+ * acquired, or false if the VMA was detached or an error arose on wait.
  *
- * If the function returns 1, the caller is required to invoke
- * __vma_exit_exclusive_locked() once the exclusive state is no longer required.
+ * If the function indicates an exclusive lock was acquired via ves->exclusive
+ * (or equivalently, returning 0 with !ves->detached), the caller is required to
+ * invoke __vma_exit_exclusive_locked() once the exclusive state is no longer
+ * required.
  *
- * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
- * may also return -EINTR to indicate a fatal signal was received while waiting.
+ * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
+ * function may also return -EINTR to indicate a fatal signal was received while
+ * waiting.
  */
-static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
-		bool detaching, int state)
+static int __vma_enter_exclusive_locked(struct vma_exclude_readers_state *ves)
 {
-	int err;
-	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;
+	struct vm_area_struct *vma = ves->vma;
+	unsigned int tgt_refcnt = get_target_refcnt(ves);
+	int err = 0;

 	mmap_assert_write_locked(vma->vm_mm);
-
-	/* Additional refcnt if the vma is attached. */
-	if (!detaching)
-		tgt_refcnt++;
+	VM_WARN_ON_ONCE(ves->detached);
+	VM_WARN_ON_ONCE(ves->exclusive);

 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
@@ -101,37 +122,39 @@ static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
+	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		ves->detached = true;
 		return 0;
+	}

 	__vma_lockdep_acquire_exclusive(vma);
 	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
-		   state);
+		   ves->state);
 	if (err) {
-		if (__vma_exit_exclusive_locked(vma)) {
-			/*
-			 * The wait failed, but the last reader went away
-			 * as well. Tell the caller the VMA is detached.
-			 */
-			WARN_ON_ONCE(!detaching);
-			err = 0;
-		}
+		__vma_exit_exclusive_locked(ves);
 		return err;
 	}
-	__vma_lockdep_stat_mark_acquired(vma);

-	return 1;
+	__vma_lockdep_stat_mark_acquired(vma);
+	ves->exclusive = true;
+	return 0;
 }

 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
-	int locked;
+	int err;
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = state,
+	};

-	locked = __vma_enter_exclusive_locked(vma, false, state);
-	if (locked < 0)
-		return locked;
+	err = __vma_enter_exclusive_locked(&ves);
+	if (err) {
+		WARN_ON_ONCE(ves.detached);
+		return err;
+	}

 	/*
 	 * We should use WRITE_ONCE() here because we can have concurrent reads
@@ -141,9 +164,11 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 	 */
 	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);

-	/* vma should remain attached. */
-	if (locked)
-		WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
+	if (!ves.detached) {
+		__vma_exit_exclusive_locked(&ves);
+		/* VMA should remain attached. */
+		WARN_ON_ONCE(ves.detached);
+	}

 	return 0;
 }
@@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);

 void vma_mark_detached(struct vm_area_struct *vma)
 {
-	bool detached;
+	struct vma_exclude_readers_state ves = {
+		.vma = vma,
+		.state = TASK_UNINTERRUPTIBLE,
+		.detaching = true,
+	};
+	int err;

 	vma_assert_write_locked(vma);
 	vma_assert_attached(vma);
@@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	detached = __vma_refcount_put(vma, NULL);
-	if (unlikely(!detached)) {
-		/* Wait until vma is detached with no readers. */
-		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
-			/*
-			 * Once this is complete, no readers can increment the
-			 * reference count, and the VMA is marked detached.
-			 */
-			detached = __vma_exit_exclusive_locked(vma);
-			WARN_ON_ONCE(!detached);
-		}
+	if (likely(__vma_refcount_put(vma, NULL)))
+		return;
+
+	/*
+	 * Wait until the VMA is detached with no readers. Since we hold the VMA
+	 * write lock, the only read locks that might be present are those from
+	 * threads trying to acquire the read lock and incrementing the
+	 * reference count before realising the write lock is held and
+	 * decrementing it.
+	 */
+	err = __vma_enter_exclusive_locked(&ves);
+	if (!err && !ves.detached) {
+		/*
+		 * Once this is complete, no readers can increment the
+		 * reference count, and the VMA is marked detached.
+		 */
+		__vma_exit_exclusive_locked(&ves);
 	}
+	/* If an error arose but we were detached anyway, we don't care. */
+	WARN_ON_ONCE(!ves.detached);
 }

 /*
--
2.52.0

