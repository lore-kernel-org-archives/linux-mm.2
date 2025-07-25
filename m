Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF00CC83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8616B0088; Fri, 25 Jul 2025 04:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A89A6B008A; Fri, 25 Jul 2025 04:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349246B008C; Fri, 25 Jul 2025 04:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE9F6B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:30:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA1331339C2
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:24 +0000 (UTC)
X-FDA: 83702115168.20.F1E862D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id A658A40011
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m7fNP0kf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OdHC7aZL;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6X1mrtu4xQy/PPhVjBztpZqHgNuZO/oWYkH2msHBdPY=;
	b=gpdFXg/vW8f/dJ5C7mZ3paO9t+4e9S5CisLLfKtYCJZByMAk3ZKSb4lNf64xxBS0Ag1Y4C
	ZYHwmtEVnnTQtdLjVQgsAvIDb+eroDdKfWCWrrfWha02KOZypJMH6kh8M98YEAITSAE5w9
	aDDjdw5/iz37itQBg4FaQRzZXCQgZ2o=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m7fNP0kf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OdHC7aZL;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753432221; a=rsa-sha256;
	cv=pass;
	b=s6CC0oNKs/gOX31u17RWXd67xeHShOyqQxIDOwl6gDKrRhnxXHmFRHTpENGMvO32vRumZm
	JzYZeP/AhEqETf07AWlXbKkK/Uo7HttQHA4ytuXTof0it0HQ4G39uzTVCHxRZSRI0rnBSv
	1Mgd+AN2FrXUKrR1xXo3ABHsnySqCeI=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7gFap002243;
	Fri, 25 Jul 2025 08:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=6X1mrtu4xQy/PPhV
	jBztpZqHgNuZO/oWYkH2msHBdPY=; b=m7fNP0kfXETXqadXtB/NFsbv0G7WJNvT
	p8bm2b5agAEb9/n1TaIAMy+RqyjMnUy35Bwt5aB8MIKF/LpKNHXsmtyNoqZv89/5
	eRvUu/Exsqn+RRm/r23++7duDal+knIqQrjB3Ntm5lGJC5co6fCgpUCp4vkDJ/Uy
	ABH49NsEBDeusMPHemjXfGtSWhGWDRz8a9FnOslhsx0Qdb3AaAxso6CzCGAUNXDx
	m9TnT8+YMxPGlrEqPts3ifl++LCMHVbiojjhj8HuT1njRTkRbwn4KE1DHL58FIB8
	QQrPAkb2b7VHfSMIKQ4ZApIjXhtHhB3QIoB5bp6Ryhlc8gijqnOEUQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1k8m8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7vdG3031647;
	Fri, 25 Jul 2025 08:30:16 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012047.outbound.protection.outlook.com [52.101.43.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tk5qat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/6T0r2a0yPhsVfc8QJPqacq2XogaWFReVOgQkC6ATfgD8Ibw9QIb6FN4NUBhCDeA4U2HMIuM4ziQIyrwoGmgHa4WjUObdwd0vD68z7HipM3vIxVPXJ9ROGCbWX80Ww9ZIkpo90zrwa/JbpDqwt5iW5eH5hcExDWmAwCxruTxjzBE6d/asMVcZzwZYcKGUbB6w51qavw+ylz9lrqAdDZxHkd6BxYNvyCRzjczjn4hUP+cghH/ZfJPISzcxHITWiyTv8pfy0IMpvBKf+dPsDwhTvDm9Op1pHpYtRE8LYqwt/kGDUgm+hMxbM5HMVmhUmH09meyn47mbyQCVEkullqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6X1mrtu4xQy/PPhVjBztpZqHgNuZO/oWYkH2msHBdPY=;
 b=oIHf2AkYmZpGc4VJXSAAS35dmkP3Tf41VCG8kO8R3dcENxzL8BRHmqz5rPAU7XnVIkFDQh7xcS8AyfIOHJsBn0QpYK5bkbzrG+0Y///y481gW8vwY3K279hKbIjnSaFjLKimtVskSsb4sb9Dz/8LeydQUbgJbPh4ga3GxP9A7HWRWFe2Cu32QdyVauVQZobIMRoXJTTK9+FT5BOcGF0ENFrUyUjCXSxF8rfnr3Q4rhHDF4P+oo3OxZpPz5voJceIR6uO+pSGbDXOPdh7B3gpuPAolbZgmHP/cWSjhp6t7/3rnLAgqkFd/RKx+w16weXc6ZSqNP+2mGY4zGm9H5zebg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X1mrtu4xQy/PPhVjBztpZqHgNuZO/oWYkH2msHBdPY=;
 b=OdHC7aZLQW3e6jzDF0IQMZk4bg34C94MHRQX0kml46o9tXYQIj1FBPIC1MHiz7U5MRRh0rI8xxOorGRCR1ZKfM6j+9l7GAdK8UAH9YmvwxaIYzOVC66CcXvbuIFcEvrYRIjiq5BoeZnPeA5eZQlOmQmMmeTr4c3eupEjkuC2Jcg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:30:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 08:30:13 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: [PATCH v4 0/5] mseal cleanups
Date: Fri, 25 Jul 2025 09:29:40 +0100
Message-ID: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0501.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d901ca-9bad-4280-3aa7-08ddcb5579a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uFGMvXLw19dD6S9l/r8BBtV+JkVr8if4xGSufBENPKQxECjpwbGHFZujL2xj?=
 =?us-ascii?Q?2/CdUkkpdIaxg3wL0e/s0gmvJnZsgZFbr+nC1YxsOoHPXKSTqKoEX+3ekfMa?=
 =?us-ascii?Q?NlYiTK4870hrSWscrI4UJV/F/ktd9q3EDANnxasEif8nVt4llPXDv2+IfGR2?=
 =?us-ascii?Q?E3dADVYuSzoc6n8yFwgMgAJqLe2ta09824vPjnfJVUVrudJ9zGMiv9hhoBFf?=
 =?us-ascii?Q?KpD0L4RTn67WTzjlLaG9v9aOGetUtROlTYOmJLZgkcbgixnmiY9HJYn2WaIS?=
 =?us-ascii?Q?t4r3RA/LG9d981WW+3b1bbzCEKPLjTyKWmnvngdI7gpKIDyJRheCda4UUjsZ?=
 =?us-ascii?Q?UFC/SCmgjg6H6tPaM6qt+0P8NK0j1jOJZtcEkLyHVEF78SeFQ11jeWPfOP+2?=
 =?us-ascii?Q?Aql38cLZd/W490tvZ9Cit6zhGp/QBS8QVFAkrf9wwdHs+FspJ/n2atRcRbuJ?=
 =?us-ascii?Q?jzzRsUszgr8r41BHEbRrWtDx9eyMfCeiSo7Vane9Jk4T1tA0xbARuyub8ukr?=
 =?us-ascii?Q?CNVqtrdOh3HhTNJ7bEAG12ep5CDvEToH7p/hO5ZEbAAf1Ui/aH1L/9sXOLrR?=
 =?us-ascii?Q?vaTy7PeAlYfKPMZlBBQ0LRmVzVDDD8zxgz62icHhJxvMjoXhOb2D+cd/Lw5x?=
 =?us-ascii?Q?90Asv6zQemi8JHvWxMkqA9YP0EU9v9u5lfmVtqbH5ZTWrjM3FAN/PlyAc+dp?=
 =?us-ascii?Q?rrwbtw40pSDSOaXABhYufGmEwWZH/Dq1VbQZN4iIQHFcV+x2Pa0M7jKV7vZ9?=
 =?us-ascii?Q?32fVg4fMoNutkSVp75JR8EG+7qKp235xhXniycfBXtb6YrFPj7DvmxnWHZ4G?=
 =?us-ascii?Q?svDWgeZEf2j4O1j8pXKz1TOCA6ViS6ialoym7UcZp0Sdfd65UgjVI863SHCM?=
 =?us-ascii?Q?GvQJnsnLKqxa80l7EIE83MMQ6wpaBseBgJXYEcljM+e2/1cmiCrYmrvr2rNJ?=
 =?us-ascii?Q?NcJbD9N1CnN6q5D1EirbnLvsm6GcB6RHeJw73HA8jh4fJDqIFhtkz6hMjBuE?=
 =?us-ascii?Q?3CSOToIUzI4ps0LEEcxoXkCgYmD8Pe5B59iWWWgqzbuEikBFR37srOn0OFJ7?=
 =?us-ascii?Q?G2CUuVm01ZLoXx84rmGLNVRnQG1b+Ws9XA0vK5FUU4Ut0sFlp+AX28QL+Zv3?=
 =?us-ascii?Q?tM/uSgo/jglOA21D1SWcXMy0+D33rZX8t3QmR/Jr2cUq6/sPT/Xgnh4rXtPF?=
 =?us-ascii?Q?l54fREipznhnj4iUXClc/XegxPYePTKtFfa8RGnhH/4NSecgFjaE+RSVE6QF?=
 =?us-ascii?Q?XQNOiXeduaDS+6T01iJTjOYjl0urW9wl4N8t/1/cR7PRaIkEotIBhC2hqiQV?=
 =?us-ascii?Q?EQf5JY8lqQkzVB+ygEDT9oNpRjYr2TypfaDpTzHOgp1t65PGRhVx2Jl8gwxO?=
 =?us-ascii?Q?SvNzYmRtnTpJn16JC3fxS/86fnL253kgU7mRd/ydV4WkyPCcpA464NeqQpdq?=
 =?us-ascii?Q?TjRfOQWdIwI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?snAI3/GGuH8G1XPsu1TacmIywsIJCTOFRF7lZyjLlK8tpC6nm8eWpsJfi5sE?=
 =?us-ascii?Q?s5C/vwJi8+ZCUrVCKash4YHhT5AzrItOd1h9XBZEz80NtfXXvprZBO1dB6QP?=
 =?us-ascii?Q?ajtJVWaICNHZyy6EqLn2K9y48NLLjAyoVQDl+wDoeS9DuMl3LoP+68xtu8Yv?=
 =?us-ascii?Q?FWChULPE/1I5aNi+TmB5hLS4FK5rpEabXEDs7lYNmT/V12CiS1VIfjyx31Rn?=
 =?us-ascii?Q?+kvcLy4buT9XKR9nQDpZyWABsAFL+LaQyRK7byGIDuW07Mo8BFBeRXc1M8Za?=
 =?us-ascii?Q?GKnFkHHMNH72dwUwy6mxPFvVMYrxI9//X0FLA6VURBKoiDas3wiBSwZLKGd6?=
 =?us-ascii?Q?aF/gVBQKvwPuZfIwJu3ub1k6VUvkBR+HMsZCFJWh8SUsttRh6WJ7gT4RXqPd?=
 =?us-ascii?Q?Yn9B8Cb5n08tKk4T/FqjN0GFOg88XOpWRRC1TV2JLAUUkdD+JJVr8h9M+lVr?=
 =?us-ascii?Q?0KPnuDhTnG/BeyuxN7oefPvFU9k8ZZ+4cXnpOgx7T2c6vM60eUsZek8sb/gP?=
 =?us-ascii?Q?OHFu+KWnGGX5hhO9Zqy8iaBJOJk0luupwt++Pu3EUvm/NzEwroVtMjkKSUrw?=
 =?us-ascii?Q?3t9Ttm5oaBqgAqI4WknEDgZLi0WK8mpIX7tYnZgsVQUFpO0st8bqC4KVB2ff?=
 =?us-ascii?Q?IOEFanQ2UbJAY+2v2bqtTRSv03nWLd0yrsApipECdTUAl5EVV8P9/m7Zmfu4?=
 =?us-ascii?Q?eSBuC1GHQNZLk+cBhZb45bLQ65X5ifs1NSP4H2CiboTZ6M3WKZmkLmkNGSB5?=
 =?us-ascii?Q?EqWsLq9Qs+a5036upRqQL0/gpcNBIE/Rrqw9BZ3VIEQW9CHIWFXNYzQp3TOi?=
 =?us-ascii?Q?JcdGq7PBrcrqbLerEMB7rjU4qRVuxs7qnNP2fUlQML+n7ghXwApeuAt5fG1U?=
 =?us-ascii?Q?84Ko79W8+StPQhvLVgF0YuufqE6mdRmiOh4yJSJjXfDW0YemiErOHNi06SwZ?=
 =?us-ascii?Q?d7/Azz1khObq48stLMC0756oEAw26wpDK7cnNKu8dyichr7T7MQ8JqVRRPdY?=
 =?us-ascii?Q?8DusH6C2g0LAtdavg0VvMa89bn7NDWHCBdizWimhU4pTGxLtOWy/AHKTaw2K?=
 =?us-ascii?Q?/jJ+L0TXutbpHxH6IcDklsMGhJ7pRBSMfZaPc5GTKYLHmd5IAXsTzk7karBk?=
 =?us-ascii?Q?d4g5kZnKYfz4wd1q+uGdmRipBZBjU7Wnz2KXmMgf5XHt+6z1NSvAOEM0N+xs?=
 =?us-ascii?Q?ruzmNLGnmEO5EhJPh/+9F/PQonwJujdqT67r0XEMXqr97CZjHDsHUgHTUjlM?=
 =?us-ascii?Q?OUayhS3pvbsoxXH/sT8DRXG900c7Y0XkiZ1EyS8FQWBg7ENAOeQwWdv5U4ub?=
 =?us-ascii?Q?zZEOXf+zFxo+vgIFLmdUqLD+WRPzw7CERd3m4C2HfM3GrJwXTrJAzlQXyUur?=
 =?us-ascii?Q?fvhJzuLsqaxV0g+7QCWK8V5FLkFj81K9oK1lIA8WjDWcJyMXYaz8E7BvQYkg?=
 =?us-ascii?Q?iM1T8aAoUhARq4YADn25MeyFUcr4BDTvuhuObfVbdQSqzND6xo6g2Z0SDUCl?=
 =?us-ascii?Q?gaqfCab/fV72RI35Ovgqz/V7OFXFtLiPEbvZanY4XhIEeXAwCmKPnC5Vlx3w?=
 =?us-ascii?Q?cFnM1/NiNd3jiSKdlYkfgd0EQfyGqrSnZUE5lrR7ww2o6zEfh1OdUdjGBoXM?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ztzZLyCkGSqvcX241X7ccqaNEThnxfU5isgapBQVO0znMnSxA+IjmlEuvcU/LYZRSIc2L5gRonkkNaFoTDvb9NRQf8lIPKNzHe9zxO38v/FNwmlT+vjT5ksssQ++eun4tW9hKwhaABf8e8GX+znXzTfXJ4uYcgJMFgoOhS9juLtsQBaI/EKnuvhpgvuOHMjkqlNDS37xMfBJvaJn2FDSFZDeHic8AqJNNW0MXXxDK3/aI6zsf3Akwpd83WwknDT5oAepCwfYEq9yPZE8SeyifAwOpYHzhg4F/7ir1I8VErwJOzhwD4Xj+4bFLLesM3rDe+v1sMqwBNiEDk7YHXa583IDLL1AeKIArqFEYbBqNewn09Dr5ri1g8F1bWsrmLHXiVVGwtb16Wfj3tzGRO3OELrTMuKmZrRVGqjpGh+3J7UsS210iIaHXscqSASN4mt0gT5J/QljkrzKxPVO9alnbwwLu90bmBSjG/Z+Iq8VizA5Y2EmPKWK0puH1ijqNoDypr1y+gK6fjTfEcxBn4Joofi7Sew4c6P+vHOFqqZztvHrKDY7tfgbNBEFbiuL7Ue/fCJPhWa8EmH5OxqIy/16JdB5ftpLtrQQk+juiVLJhZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d901ca-9bad-4280-3aa7-08ddcb5579a8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:30:13.0940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mx3OrumN5TQ57ui0ZUTBBx9BYLHzEzdTOsihw6y9nAertKkGaGvhxJ1eNE/wlfhFwk7beNubOB3rrBGt+car3MDf4K0KFVGbWfHDkTM3R5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250071
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA3MiBTYWx0ZWRfXxQmrY5T8ClMR
 wn3XjsU5k1myOPDRASG60ZUjx5RYhogEL2DNNJwTZu6cuG8t21F3LTQzwfMjjK+OSKQYw8zwTYy
 6A1SiZiEm0wOjN3ZvvcUMI1UJw78uH/n67woi+nf4n9gGAk9Vuc1ucw/bECYedwMqAeoF0CCrCS
 kVkHJWYtyqJ3dueNSs4z1IzTpJrDzan78247xPBBkYfHDCrNa13W0tPLKen1c5GUE/Y459EpD9o
 qONHwwqwDEB+CjFUUfKGmgQEPKjAL6O9sBugtmXXCBVUtMXqMTyhxtZuS4re3nny9rs3/eNsK1M
 nJqiXFARuSKmUy9RtXSdVyANAVShvPalDECl5v3GbmilxQ67vlK0WebQ501WSF1+c0mPRO4P0UB
 m9tBQfdKqhkPj8D4a7p92kvZ8YGHmO+FNvEdjrKZMIW+uo6OJ4jGuzI/gBioCywpEnZknrd2
X-Proofpoint-ORIG-GUID: x0IRajE4tGm-9Qa4KSQaOtHlGMUbybLC
X-Proofpoint-GUID: x0IRajE4tGm-9Qa4KSQaOtHlGMUbybLC
X-Authority-Analysis: v=2.4 cv=JIQ7s9Kb c=1 sm=1 tr=0 ts=68834098 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=ck-w0BNYe300RZnOrkAA:9 cc=ntf awl=host:13600
X-Stat-Signature: xz9kk6u5sywbj54d5r6yokt4dpj6ktt8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A658A40011
X-Rspam-User: 
X-HE-Tag: 1753432221-472676
X-HE-Meta: U2FsdGVkX18M2cgqB6jKnZ0MmyIgfPr5LIzIpR0NoKF96LwABx01y4L4nqWNeMlQ4sXcDA3F2y7R0fpSIeUkrRGy9uBV/TL2wSCN7CPQyl1V6n4MKg7YxTlofewvdd3D9KZhtiew6k7euZyFKTtgvitcficrOlHRjR/Ya4/RnAFWED0zDK0eJwwXhLDDAO4RETkRzvsDLDS/AaZgdC2/qQv8JvqWgppTtIYO/l0pcJ25JRVKVaWPUIG3vx+0SqUWYjTTTf4FBtiOTPaCc0aDgQDDL24VEWj5iq0weu12can+u4QzYI9Jy5iMn7PeO+UvNj5ZjWwQRH5kixgllCulhlAM6agQtVtid8c4hM81SmrkqAF5aODPkiStArHH3k5RdBY48ipTkH8Xl5DkCJyvv0IcRow42God63tDFOLIshcxwbAqCoiwswqd5BdVsfQAEjeYF8lqFBKtxW3BMRyCEeH0T3vb0PiXufOrEzDN44CqP7xx44Chx+z8k9LyIrQl5c/VKqOoY0DIw4aIRwgu7Cee3aeope9rTDIxevIhV0y5Ri9+sNrCl041JgMw+z4ixpyH2Bd6nR+oouLgD1FOBjpPqkNOjCzxse4rQUcam9o06d5U/2Fs+E3u7SCU3ulEsgH5ERyi/BlMf8XSMXPsHS15KQ9YBkMvWVhQt2FHcXzt8iufchHbTUbJxXJ40qMxFr0Uw4WcHBvCgaqCUzveP2UGdK24KbfMMU8ozTXezWP9l+Tl7PhoB5EPNPXFLgwoaYulBjdCT898MIhAQMHqmuDZWkgfrKaLqS5LCgDYMzDGOQEGW9dEKlI9t747owVpxpklkOf7jidR8LiqO45tf2aeVUjlJT/4Up2YEQoSr84WdWz8vIICUnEqey0SIqScznRm4rVOXpGAk/VUgdSmhvoRb4o+LLa6QP0/kD5/V0lRN5tp1FZNdd/5DjNg6LMqJKfWWMPJyX6xFTUREIo
 Mw3k1lGw
 H941oPy/XfOJsLgZB056rsIb9nw53Dp1IwMo43Bk1JdT4z780Lz+7YFgb6HS88ls+r5uzZ4PXwREpmrtqzxdTebr1RQ3BEZERwPcyE7AFcAN+s0tDLC+3sgUSLADHgHb/yS55jge938v/9DQCWM3JKuaBXue1VPHPMIZkNM9jcsF2LFx/0AbFBAYpgRGUB28jRMpPoW/PPLjxJsGKlCFvUG4lHOL4lBfji7hmUGqi8gMDqVwOtDIuBwuFK0kGgKQ5QYIyamuGvKR4wD9FUBO5QrnzzggijZ9p5iR7JEajmMncNixjU3iz2mPHsmXsjI3oMgC8yYWVZjRxUhZ9sM+AEO8ZJzsxas9WMEwg+gh4wfAE0/nN9J3IfuDrEqzf8qGU+sx4eLxshbFKHdMOCZn6hY8zSyKCeTviRKs9NCOyfKD3JK5vRvO5NnYmNOmTkuAwpMArLpa+9aIjtft/Sr2Wzbf+5quqwaspnqWt/cdLtpXdED8j5LDpJt3cHD7WansGMz4fwXPthfBgqM70Uiukoc5M2sJ5pBecO/ZNWcmOy3L/Wy6RW69TgqEl8ZXS014XTs0Ev8/+I4d/yFCKKcp6ZLo9GcYv4h61/CxYzjMFymAi1ojeAHkuc5MOVrkELr2kM4O1v7c5goTyMVCWDIRbUAkOs53o/dZR8maQqO5abSpYht6yQhoWLLOj3CQZ7QwDnEupQCtupLASYUhPHlerqwLuXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Perform a number of cleanups to the mseal logic. Firstly, VM_SEALED is
treated differently from every other VMA flag, it really doesn't make sense
to do this, so we start by making this consistent with everything else.

Next we place the madvise logic where it belongs - in mm/madvise.c. It
really makes no sense to abstract this elsewhere. In doing so, we go to
great lengths to explain very clearly the previously very confusing logic
as to what sealed mappings are impacted here.

In doing so, we retain existing logic regarding treatment of madvise()
discard operations for a sealed, read-only MAP_PRIVATE file-backed
mapping. This is something we likely need to revisit.

We then abstract out and explain the 'are there are any gaps in this range
in the mm?' check being performed as a prerequisite to mseal being
performed.

Finally, we simplify the actual mseal logic which is really quite
straightforward.

No functional change is intended.


NOTE - this replaces the previous "mseal cleanups, fixup MAP_PRIVATE
file-backed case" series (linked below under v3), I renamed to 'mseal
cleaups' only as now we do not adjust MAP_PRIVATE behaviour.

v4:
* Propagated tags, thanks Jeff!
* Remove the change in semantics for MAP_PRIVATE, file-backed, mseal()'d
  mappings, as it turns out there is more complexity than expected
  here. Let's stick to a straight refactoring for now. Based on discussions
  with Jeff, Kees and David.
* Reinstated comment previously present in check_mm_seal() regarding
  expectations of input range in range_contains_unmapped() where this makes
  sense to locate, removing the redundant 'map is sealable' step, as per
  Jeff.

v3:
* Propagated more tags, thanks everyone!
* Updated 5/5 to assign curr_start in a smarter way as per Liam. Adjust
  code to more sensibly handle already-sealed case at the same time.
* Updated 4/5 to not move range_contains_unmapped() for better diff.
* Renamed can_modify_vma() to vma_is_sealed() and inverted the logic - this
  is far clearer than the nebulous 'can modify VMA'.
https://lore.kernel.org/all/cover.1752687069.git.lorenzo.stoakes@oracle.com/

v2:
* Propagated tags, thanks everyone!
* Updated can_madvise_modify() to a more logical order re: the checks
  performed, as per David.
* Replaced vma_is_anonymous() check (which was, in the original code, a
  vma->vm_file or vma->vm_ops check) with a vma->vm_flags & VM_SHARED
  check - to explicitly check for shared mappings vs private to preclude
  MAP_PRIVATE-mapping file-baked mappings, as per David.
* Made range_contains_unmapped() static and placed in mm/mseal.c to avoid
  encouraging any other internal users towards this rather silly pattern,
  as per Pedro and Liam.
https://lore.kernel.org/all/cover.1752586090.git.lorenzo.stoakes@oracle.com/

v1:
https://lore.kernel.org/all/cover.1752497324.git.lorenzo.stoakes@oracle.com/


Lorenzo Stoakes (5):
  mm/mseal: always define VM_SEALED
  mm/mseal: update madvise() logic
  mm/mseal: small cleanups
  mm/mseal: simplify and rename VMA gap check
  mm/mseal: rework mseal apply logic

 include/linux/mm.h               |   6 +-
 mm/madvise.c                     |  71 +++++++++++++-
 mm/mprotect.c                    |   2 +-
 mm/mremap.c                      |   2 +-
 mm/mseal.c                       | 160 +++++++------------------------
 mm/vma.c                         |   4 +-
 mm/vma.h                         |  27 +-----
 tools/testing/vma/vma_internal.h |   6 +-
 8 files changed, 119 insertions(+), 159 deletions(-)

--
2.50.1

